#!/usr/bin/env bash
# ------------------------------------------------------------
# 공통 함수 모음 (다른 스크립트가 source 로 불러서 씀)
# 역할: "입력한 명령어"와 "출력 결과"를
#       1) 화면에 보여 주고  2) docs/logs/*.md 에 코드블록으로 저장
# ------------------------------------------------------------

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$REPO_ROOT/docs/logs"
mkdir -p "$LOG_DIR"
IN_BLOCK=0

# 민감 정보 가리기(마스킹): GitHub 토큰, password/token/secret 이 들어간 줄
mask() {
  sed -E \
    -e 's/(ghp_|gho_|ghu_|ghs_|github_pat_)[A-Za-z0-9_]+/\1****/g' \
    -e 's/(([Pp]assword|[Pp]asswd|[Tt]oken|[Ss]ecret)[^=:]*[=:]).*/\1 ****/'
}

open_block()  { [ "$IN_BLOCK" = 0 ] && { echo '```bash' >> "$LOG_FILE"; IN_BLOCK=1; }; }
close_block() { [ "$IN_BLOCK" = 1 ] && { printf '```\n\n' >> "$LOG_FILE"; IN_BLOCK=0; }; }

# 새 로그 파일 시작: start_log 파일이름.md "제목"
start_log() {
  LOG_FILE="$LOG_DIR/$1"
  {
    echo "# $2"
    echo
    echo "- 실행 시각: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "- 생성: \`scripts/$(basename "$0")\` 실행 결과 (명령 + 출력 자동 기록)"
    echo
  } > "$LOG_FILE"
  trap close_block EXIT        # 스크립트가 끝나면 코드블록 닫기
  echo "===== $2 ====="
}

# 소제목
section() {
  close_block
  printf '## %s\n\n' "$1" >> "$LOG_FILE"
  printf '\n----- %s -----\n' "$1"
}

# 설명 문장
note() {
  close_block
  printf '%s\n\n' "$*" >> "$LOG_FILE"
  echo "# $*"
}

# 명령 실행 + 기록 (cd 효과가 유지되도록 파이프 대신 임시 파일 사용)
_exec() {
  local cmd="$1" tmp rc
  tmp="$(mktemp)"
  echo "\$ $cmd"
  eval "$cmd" > "$tmp" 2>&1
  rc=$?
  open_block
  echo "\$ $cmd" >> "$LOG_FILE"
  mask < "$tmp" | tee -a "$LOG_FILE"
  rm -f "$tmp"
  return $rc
}

# run: 실패하면 스크립트를 멈춤
run() {
  _exec "$*" || {
    close_block
    echo
    echo "[중단] 위 명령이 실패했습니다: $*"
    echo "       오류 메시지를 확인하세요 (README 트러블슈팅 참고)."
    exit 1
  }
}

# try: 실패가 '예상된' 명령 (예: 권한 없는 폴더 들어가기)
try() { _exec "$*"; return 0; }

# 도커 엔진이 켜져 있는지 먼저 확인
require_docker() {
  if ! docker info > /dev/null 2>&1; then
    echo "[오류] Docker 엔진에 연결할 수 없습니다."
    echo "       OrbStack(또는 Docker Desktop) 앱을 먼저 실행하고 다시 시도하세요."
    exit 1
  fi
}
