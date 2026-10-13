#!/bin/bash
# Clipboard -> OpenCode. Modo invisível: sem janela, sem notificação, sem foco.
# Atalho: SUPER+O (hyprland). Resposta vai pro clipboard e pro ~/Documentos/<slug>.txt
# Debug: OPENCODE_CLIPBOARD_DEBUG=1 -> log em /tmp/opencode-clipboard.log

set -u

export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin"

LOCK="/tmp/opencode-clipboard.lock"
LOG="/tmp/opencode-clipboard.log"
export TIMEOUT=600 # segundos max por execução

# Modelo: vazio = padrão do opencode. Ex.: "opencode/mimo-v2.6-flash-free"
MODEL=""

# Pasta de saída (pt_BR vs en_US)
if [ -d "$HOME/Documentos" ]; then
    OUT_DIR="$HOME/Documentos"
elif [ -d "$HOME/Documents" ]; then
    OUT_DIR="$HOME/Documents"
else
    OUT_DIR="$HOME/Documentos"
    mkdir -p "$OUT_DIR" 2>/dev/null || OUT_DIR="$HOME"
fi

log() {
    [ "${OPENCODE_CLIPBOARD_DEBUG:-0}" = "1" ] &&
        printf '%s %s\n' "$(date '+%H:%M:%S')" "$*" >>"$LOG"
}

# --- lê o clipboard de forma síncrona (antes de alguém copiar outra coisa) ---
CONTENT="$(wl-paste --type text --no-newline 2>/dev/null)" || true
# vazio ou só espaço -> sai em silêncio
[ -z "${CONTENT//[[:space:]]/}" ] && exit 0

# --- slug do arquivo: 1a linha, ascii, lowercase, hífens ---
slug="$(printf '%s' "$CONTENT" | head -n1 | head -c 80 |
    iconv -f utf-8 -t ascii//TRANSLIT 2>/dev/null |
    tr '[:upper:]' '[:lower:]' |
    sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g' |
    cut -c1-50)"
[ -z "$slug" ] && slug="questao-$(date +%s)"

# --- solta o trabalho pesado em background e sai na hora ---
nohup bash -s -- "$CONTENT" "$slug" "$OUT_DIR" "$MODEL" "$LOCK" "$LOG" >/dev/null 2>&1 <<'WORKER' &
content="$1"
slug="$2"
out_dir="$3"
model="$4"
lock="$5"
logf="$6"

wlog() { [ "${OPENCODE_CLIPBOARD_DEBUG:-0}" = "1" ] && printf '%s %s\n' "$(date '+%H:%M:%S')" "$*" >>"$logf"; }

wlog "worker iniciado (pid $$)"

# serializa: apertar 2x rápido não embaralha
exec 9>"$lock" || exit 1
flock 9 || exit 1

tmp="$(mktemp -d /tmp/opencode-clipboard.XXXXXX)" || exit 1
trap 'rm -rf "$tmp"' EXIT

printf '%s' "$content" >"$tmp/input.txt"

read -r -d '' prompt <<'PROMPT' || true
Você é um resolvedor automático acionado por um atalho de teclado. Analise o conteúdo do arquivo anexado.

Se for uma QUESTÃO/PROBLEMA de programação (exercício, enunciado, desafio, código com bug):
- Resolva por completo, com uma seção por linguagem contendo o código final: C, C++, Python, Java e Haskell.
- MUITO IMPORTANTE sobre o código: prefira simplicidade, legibilidade e idiomacidade. NÃO faça otimização prematura nem use truques obscuros ou específicos de cada linguagem para ganhar performance (macros malucas, casting cru, operadores bit a bit, unrolling, assembly inline, APIs esotéricas). Estruturas naturais e nomes claros valem mais que velocidade.
- Explique brevemente a lógica antes do código.

Se for uma PERGUNTA (conceito, dúvida teórica, explicação):
- Responda de forma direta, completa e simples.

Formato: Markdown, em português. NÃO use ferramentas, NÃO leia nem escreva arquivos, NÃO execute comandos: responda apenas com o texto final.
PROMPT

args=(run --auto --title "clipboard: $slug" --file "$tmp/input.txt")
[ -n "$model" ] && args+=(-m "$model")
args+=("$prompt")

timeout "$TIMEOUT" opencode "${args[@]}" >"$tmp/out.md" 2>"$tmp/err.log" </dev/null
status=$?

if [ "$status" -ne 0 ] || [ ! -s "$tmp/out.md" ]; then
    wlog "falha opencode (status $status): $(tail -c 300 "$tmp/err.log" 2>/dev/null)"
    exit 1
fi

# nome único: slug.txt, slug-2.txt, ...
file="$out_dir/$slug.txt"
n=2
while [ -e "$file" ]; do
    file="$out_dir/$slug-$n.txt"
    n=$((n + 1))
done

{
    printf '# %s\n\n---\n\n' "$(printf '%s' "$content" | head -n 100)"
    cat "$tmp/out.md"
    printf '\n'
} >"$file" || exit 1

wl-copy --type text/plain <"$tmp/out.md"
wlog "ok: $file ($(wc -c <"$tmp/out.md") bytes)"
exit 0
WORKER
disown 2>/dev/null

exit 0
