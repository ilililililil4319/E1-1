#!/usr/bin/env bash
# 00 ~ 07 실습 스크립트를 순서대로 실행 (Git 08 은 이름/이메일이 필요해서 따로 실행)
# 사용법: 저장소 폴더에서  ./scripts/run_all.sh
cd "$(dirname "$0")" || exit 1
for s in 00_env.sh 01_terminal.sh 02_permission.sh 03_docker_check.sh \
         04_docker_ops.sh 05_build_run.sh 06_bind_mount.sh 07_volume.sh; do
  echo
  echo "################ $s ################"
  bash "./$s" || { echo "[중단] $s 에서 오류가 났습니다. 위 메시지를 확인하세요."; exit 1; }
done
echo
echo "완료! 결과는 docs/logs/ 폴더에 저장되었습니다."
