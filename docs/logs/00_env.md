# 실행 환경

- 실행 시각: 2026-11-05 14:42:08
- 생성: `scripts/00_env.sh` 실행 결과 (명령 + 출력 자동 기록)

## OS

```bash
$ cat /etc/os-release | head -4
PRETTY_NAME="Ubuntu 26.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="26.04"
VERSION="26.04.1 LTS (Resolute Raccoon)"
$ uname -m
x86_64
$ uname -r
6.18.54.1-microsoft-standard-WSL2
$ cmd.exe /c ver 2>/dev/null | tr -d '\r' | grep -v '^$'
Microsoft Windows [Version 10.0.26200.9711]
```

## 쉘 / 터미널

```bash
$ echo "SHELL=$SHELL"
SHELL=/bin/bash
$ "$SHELL" --version 2>&1 | head -1
GNU bash, version 5.3.9(1)-release (x86_64-pc-linux-gnu)
$ echo "TERM_PROGRAM=${TERM_PROGRAM:-unknown}"
TERM_PROGRAM=vscode
```

## Docker / Git 버전

```bash
$ docker --version
Docker version 29.9.2, build a82e528
$ git --version
git version 2.53.0
```

