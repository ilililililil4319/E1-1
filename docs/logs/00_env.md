# 실행 환경

- 실행 시각: 2026-11-04 07:53:33
- 생성: `scripts/00_env.sh` 실행 결과 (명령 + 출력 자동 기록)

## OS

```bash
$ cat /etc/os-release | head -4
PRETTY_NAME="Ubuntu 24.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.5 LTS (Noble Numbat)"
$ uname -m
x86_64
```

## 쉘 / 터미널

```bash
$ echo "SHELL=$SHELL"
SHELL=/bin/bash
$ "$SHELL" --version 2>&1 | head -1
GNU bash, version 5.2.21(1)-release (x86_64-pc-linux-gnu)
$ echo "TERM_PROGRAM=${TERM_PROGRAM:-unknown}"
TERM_PROGRAM=vscode
```

## Docker / Git 버전

```bash
$ docker --version
Docker version 29.9.2-2, build a82e528901260c8df6073311379eac65f92db204
$ git --version
git version 2.56.0
```

