#!/usr/bin/env bash
# 바인드 마운트: 호스트 파일을 고치면 컨테이너에 바로 반영되는지 전/후 비교
source "$(dirname "$0")/lib.sh"
require_docker
docker rm -f bind-test > /dev/null 2>&1
start_log "06_bind_mount.md" "바인드 마운트 반영 로그"

run "cd $REPO_ROOT/bind-mount"
run "mkdir -p site"

section "1. 변경 전: 호스트 파일 작성"
run "echo '<h1>Before: bind mount test</h1>' > site/index.html"
run "cat site/index.html"

section "2. 호스트 폴더를 컨테이너에 연결해서 실행"
note "-v 호스트절대경로:컨테이너경로 / \$(pwd) = 현재 폴더 절대 경로"
run 'docker run -d -p 8082:80 --name bind-test -v "$(pwd)/site":/usr/share/nginx/html nginx:1.27-alpine'
sleep 2
run "curl -s http://localhost:8082"

section "3. 변경 후: 호스트에서만 파일 수정 (재빌드/재시작 없음)"
run "echo '<h1>After: changed on host!</h1>' > site/index.html"
run "curl -s http://localhost:8082"
note "→ 컨테이너를 다시 만들지 않았는데도 내용이 바뀌었다 = 바인드 마운트로 호스트 폴더를 그대로 공유"

section "4. 연결 정보 확인"
run "docker inspect -f '{{range .Mounts}}{{.Type}}: {{.Source}} -> {{.Destination}}{{end}}' bind-test"
run "docker rm -f bind-test"
