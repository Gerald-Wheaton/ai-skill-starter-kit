#!/bin/sh
input=$(cat)
# Cache latest payload so `claude-stats` can read live rate-limit data.
printf '%s' "$input" > "$HOME/.claude/last-statusline.json" 2>/dev/null

# --- ANSI helpers ---------------------------------------------------------
RESET='\033[0m'
DIM='\033[2m'
BOLD='\033[1m'
SEP=" ${DIM}|${RESET} "

# color_for <int-pct>: green <50, yellow 50-79, red >=80
color_for() {
  p=$(printf '%s' "$1" | awk '{printf "%d", $1}')
  if [ "$p" -lt 50 ]; then printf '\033[32m'
  elif [ "$p" -lt 80 ]; then printf '\033[33m'
  else printf '\033[31m'
  fi
}

# --- account email (from local config, not the payload) -------------------
email=$(jq -r '.oauthAccount.emailAddress // empty' "$HOME/.claude.json" 2>/dev/null)

# --- model ----------------------------------------------------------------
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')

# --- context window -------------------------------------------------------
pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')

# --- 5-hour session rate limit --------------------------------------------
sess_pct=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
sess_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

# --- cost -----------------------------------------------------------------
cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // empty')

# --- elapsed since this launch (resets on resume/reopen) ------------------
# Marker keyed by the Claude Code process ($PPID): stable across renders in
# one launch, new PID on resume -> timer resets. Purge markers >1 day old.
now=$(date +%s)
marker="/tmp/cc-open-since-$PPID"
find /tmp -maxdepth 1 -name 'cc-open-since-*' -mtime +1 -delete 2>/dev/null
if [ -f "$marker" ]; then start=$(cat "$marker"); else start=$now; printf '%s' "$now" > "$marker"; fi
elapsed=$((now - start))
[ "$elapsed" -lt 0 ] && elapsed=0

out=""
add() { # append a segment with separator if we already have output
  if [ -n "$out" ]; then out="${out}${SEP}"; fi
  out="${out}$1"
}

# email
[ -n "$email" ] && add "${DIM}${email}${RESET}"

# model
[ -n "$model" ] && add "${BOLD}${model}${RESET}"

# context bar + %
if [ -n "$pct" ]; then
  filled=$(printf '%s' "$pct" | awk '{printf "%d", ($1+5)/10}')
  bar=""
  i=1
  while [ "$i" -le 10 ]; do
    if [ "$i" -le "$filled" ]; then bar="${bar}█"; else bar="${bar}░"; fi
    i=$((i + 1))
  done
  c=$(color_for "$pct")
  add "$(printf '%b[%s]%b' "$c" "$bar" "$RESET")"
fi

# session (5h) usage + reset countdown
if [ -n "$sess_pct" ]; then
  reset_str=""
  if [ -n "$sess_reset" ]; then
    now=$(date +%s)
    diff=$((sess_reset - now))
    [ "$diff" -lt 0 ] && diff=0
    h=$((diff / 3600))
    m=$(((diff % 3600) / 60))
    reset_str=" ${DIM}(${h}h${m}m)${RESET}"
  fi
  sc=$(color_for "$sess_pct")
  sess_disp=$(printf '%s' "$sess_pct" | awk '{printf "%.1f", $1}')
  add "$(printf 'Sess %b%s%%%b%b' "$sc" "$sess_disp" "$RESET" "$reset_str")"
fi

# cost + elapsed-since-open
if [ -n "$cost" ]; then
  hh=$((elapsed / 3600))
  mm=$(((elapsed % 3600) / 60))
  ss=$((elapsed % 60))
  if [ "$hh" -gt 0 ]; then dur_str=" ${DIM}${hh}h${mm}m${RESET}"
  else dur_str=" ${DIM}${mm}m${ss}s${RESET}"; fi
  add "$(printf '$%.2f%b' "$cost" "$dur_str")"
fi

printf '%b' "$out"
