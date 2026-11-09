# 내 컴퓨터에 개발자용 '작업실' 꾸미기 🛠️

> 터미널(리눅스 CLI), Docker, Git/GitHub 를 직접 세팅하고,
> "실행 결과(로그·접속·데이터 유지)"로 검증해 누구나 같은 결과를 재현할 수 있는 개발 환경을 만든 미션

**💻 GitHub:** https://github.com/ilililililil4319/E1-1

**📋 미션:** E1-1 내 컴퓨터에 개발자용 '작업실' 꾸미기 (26년 경남 AI 올인원 1기 입학연수 · 개발 입문)

**🧾 실행 로그:** [`docs/logs/`](docs/logs/) (명령 + 출력 자동 기록)

**🖼 스크린샷:** [`docs/screenshots/`](docs/screenshots/)

**⚙️ 환경 세팅 가이드:** [`docs/SETUP.md`](docs/SETUP.md)

![커스텀 이미지 포트 매핑 접속 성공](docs/screenshots/port-8080.png)

---

## 목차

1. [프로젝트 소개](#1-프로젝트-소개)
2. [핵심 질문 (스스로 설명할 6가지)](#2-핵심-질문-스스로-설명할-6가지)
3. [프로젝트 개요 및 산출물 구성](#3-프로젝트-개요-및-산출물-구성)
4. [폴더 구조](#4-폴더-구조)
5. [용어 설명 (초보자를 위한 참고)](#5-용어-설명-초보자를-위한-참고)
6. [기술 스택 및 실행 환경](#6-기술-스택-및-실행-환경)
7. [사용 이미지 및 출처](#7-사용-이미지-및-출처)
8. [검증 방법 및 핵심 개념 요약](#8-검증-방법-및-핵심-개념-요약)
9. [전체 작업 순서 (STEP 1-14)](#9-전체-작업-순서-step-1-14)
10. [작업 흐름도](#10-작업-흐름도)
11. [Docker 연결 구조 (포트·마운트·볼륨)](#11-docker-연결-구조-포트마운트볼륨)
12. [핵심 실습 결과](#12-핵심-실습-결과)
13. [보너스 과제](#13-보너스-과제)
14. [로컬 실행 방법](#14-로컬-실행-방법)
15. [환경 변수 및 포트 설정](#15-환경-변수-및-포트-설정)
16. [실습 중 발생한 오류와 해결](#16-실습-중-발생한-오류와-해결)
17. [AI(Claude) 사용 로그 요약](#17-aiclaude-사용-로그-요약)
18. [기능요구사항 대비 결과](#18-기능요구사항-대비-결과)
19. [결론 및 한계점](#19-결론-및-한계점)
20. [보안 유의사항](#20-보안-유의사항)
21. [이미지·도구 출처 및 라이선스 유의사항](#21-이미지도구-출처-및-라이선스-유의사항)
22. [기타](#22-기타)

---

## 1. 프로젝트 소개

개발은 코드를 작성하는 순간이 아니라 환경을 세팅하는 순간부터 시작됩니다. 같은 코드가 "내 컴퓨터에서만" 돌아가는 문제를 줄이려면, 누가 어디서 실행해도 같은 결과가 나오는 환경이 필요합니다.

이 프로젝트는 터미널로 작업 폴더와 권한을 정리하고, Docker 로 컨테이너를 실행·관리하며, NGINX 기반 커스텀 이미지를 직접 만들어 포트 매핑·바인드 마운트·볼륨을 검증한 뒤, 모든 결과를 Git/GitHub 로 관리한 개인 미션입니다.

- **핵심 도구:** 리눅스 CLI(터미널) / Docker(컨테이너) / Git·GitHub(버전 관리·협업)
- **핵심 가치:** 따라 치는 실습이 아니라 "실행 결과"로 증명하고, README 만 보고도 같은 절차를 재현할 수 있게 문서화
- **자동화:** 실습 명령과 출력을 마크다운 로그로 자동 저장하는 스크립트(`scripts/`) 작성 → 재실행해도 같은 결과
- **보너스:** Docker Compose 멀티 컨테이너, 운영 명령(up/ps/logs/down), 환경 변수 주입

---

## 2. 핵심 질문 (스스로 설명할 6가지)

1. 절대 경로와 상대 경로는 무엇이 다른가?
    - **답:** 절대 경로는 `/` 부터 시작해 어디서 실행해도 같은 곳(`/home/사용자/codyssey`)을, 상대 경로는 현재 위치 기준(`./practice`, `../`)이라 실행 위치에 따라 결과가 달라진다.
2. 파일 권한 r/w/x 는 무슨 뜻이고, 755·644 는 어떤 규칙으로 읽는가?
    - **답:** r(읽기)=4, w(쓰기)=2, x(실행, 디렉토리는 들어가기)=1 을 더해 소유자·그룹·기타 순서로 쓴다. 755 = `rwxr-xr-x`, 644 = `rw-r--r--`.
3. 기존 이미지를 바탕으로 "커스텀 이미지"를 어떻게 만드는가?
    - **답:** Dockerfile 에 `FROM nginx:1.27-alpine` 으로 베이스를 정하고 `COPY`·`ENV`·`LABEL`·`HEALTHCHECK` 로 내 내용을 더한 뒤 `docker build -t my-web:1.0 .` 으로 빌드한다.
4. 포트 매핑은 왜 필요한가?
    - **답:** 컨테이너는 격리된 자기만의 네트워크를 가져 밖에서 바로 들어갈 수 없으므로, `-p 8080:80`(호스트:컨테이너)으로 호스트 포트를 컨테이너 포트에 연결해야 브라우저에서 접속된다.
5. Docker 볼륨(영속 데이터)은 무엇이고 바인드 마운트와 어떻게 다른가?
    - **답:** 볼륨은 Docker 가 관리하는 저장소라 컨테이너를 지워도 데이터가 남고(영속성), 바인드 마운트는 내가 고른 호스트 폴더를 연결해 파일 수정이 컨테이너에 즉시 반영된다.
6. Git 과 GitHub 의 역할은 어떻게 다른가?
    - **답:** Git 은 내 컴퓨터에서 변경 이력을 관리하는 로컬 버전 관리 도구이고, GitHub 는 Git 저장소를 인터넷에 올려 공유·협업하는 원격 플랫폼이다.

> 자세한 설명은 [8장](#8-검증-방법-및-핵심-개념-요약)에, 직접 확인한 결과는 [12장](#12-핵심-실습-결과)에 정리했습니다.

---

## 3. 프로젝트 개요 및 산출물 구성

| # | 최종 결과물 (미션 요구) | 이 저장소의 위치 |
|:---:|---|---|
| 1 | 제출 저장소 | 본 저장소 (공개) |
| 2 | 기술 문서 | `README.md` (본 문서) |
| 3 | 터미널 조작 로그 | [`01_terminal.md`](docs/logs/01_terminal.md), [`02_permission.md`](docs/logs/02_permission.md) |
| 4 | Docker 운영/검증 로그 | [`03_docker_check.md`](docs/logs/03_docker_check.md),<br>[`04_docker_ops.md`](docs/logs/04_docker_ops.md) |
| 5 | Dockerfile 기반 웹 서버 | [`app/Dockerfile`](app/Dockerfile), [`app/site/`](app/site/),<br>[`05_build_run.md`](docs/logs/05_build_run.md) |
| 6 | 포트 매핑 접속 증거 | [12-6](#12-6-포트-매핑-접속) 스크린샷 2장 |
| 7 | 바인드 마운트 + 볼륨 증거 | [`06_bind_mount.md`](docs/logs/06_bind_mount.md), [`07_volume.md`](docs/logs/07_volume.md) |
| 7-1 | 포트 충돌 진단·해제 증거 | [`10_port_check.md`](docs/logs/10_port_check.md), [12-10](#12-10-포트-충돌-진단-및-해제) |
| 8 | Git 설정 + GitHub/VSCode 연동 증거 | [`08_git.md`](docs/logs/08_git.md), [12-9](#12-9-git-설정-및-github-연동) 스크린샷 |

---

## 4. 폴더 구조

```text
E1-1/
├── README.md               # 기술 문서 (본 문서)
├── .gitignore              # 민감 파일·잡파일 제외
├── app/                    # 웹 서버 소스 + Dockerfile
│   ├── Dockerfile          #   nginx:1.27-alpine 기반 커스텀 이미지
│   └── site/index.html     #   교체한 정적 페이지
├── bind-mount/             # 바인드 마운트 실습 폴더 (site/ 는 스크립트가 생성)
├── compose/
│   └── docker-compose.yml  # 보너스: web + checker 멀티 컨테이너
├── scripts/                # 실습 자동화 (명령 + 출력 → docs/logs/*.md)
│   ├── lib.sh              #   공통 함수 (기록, 민감정보 마스킹, 실패 시 중단)
│   ├── 00_env.sh           #   실행 환경
│   ├── 01_terminal.sh      #   터미널 조작
│   ├── 02_permission.sh    #   권한
│   ├── 03_docker_check.sh  #   Docker 설치·점검
│   ├── 04_docker_ops.sh    #   운영 명령 + hello-world + ubuntu + exec
│   ├── 05_build_run.sh     #   커스텀 이미지 빌드 + 포트 매핑 2회
│   ├── 06_bind_mount.sh    #   바인드 마운트 반영
│   ├── 07_volume.sh        #   볼륨 영속성
│   ├── 08_git.sh           #   Git 설정 확인
│   ├── 09_compose.sh       #   보너스 Compose
│   ├── 10_port_check.sh    #   포트 충돌 진단·해제
│   └── run_all.sh          #   00~07 한 번에 실행
└── docs/
    ├── SETUP.md            # 환경 세팅 가이드 (Mac / Windows)
    ├── logs/               # 실행 로그
    └── screenshots/        # 스크린샷
```

---

## 5. 용어 설명 (초보자를 위한 참고)

이 미션에서 사용한 CLI·Git·Docker 용어와 명령을 한 줄씩 정리했습니다.

### CLI (터미널)

| 용어 / 명령 | 뜻 |
| --- | --- |
| CLI | 글자로 명령을 입력해 컴퓨터를 다루는 방식 (Command Line Interface) |
| 쉘 (Shell) | 입력한 명령을 해석해 실행하는 프로그램 (bash, zsh) |
| 프롬프트 | 명령 입력을 기다리는 표시 (`$`, `root@...:/#`) |
| 루트 디렉토리 | 파일 시스템의 맨 꼭대기 `/` |
| 홈 디렉토리 | 사용자 개인 폴더 `~` |
| 절대 경로 | `/` 부터 시작하는 전체 경로 (`/home/사용자/codyssey`) |
| 상대 경로 | 현재 위치 기준 경로 (`./practice`, `../`) |
| `.` / `..` | 현재 디렉토리 / 상위 디렉토리 |
| 숨김 파일 | 이름이 `.` 으로 시작하는 파일 (`.gitignore`) |
| `pwd` | 현재 위치 출력 |
| `ls -la` | 숨김 파일 포함 상세 목록 (`-l` 상세, `-a` 전부) |
| `cd` | 디렉토리 이동 |
| `mkdir -p` | 디렉토리 생성 (`-p`: 중간 디렉토리까지 한 번에) |
| `touch` | 빈 파일 생성 |
| `cat` | 파일 내용 출력 |
| `cp` / `cp -r` | 파일 복사 / 디렉토리 통째로 복사 |
| `mv` | 이동 또는 이름 변경 |
| `rm` / `rm -r` | 파일 삭제 / 디렉토리 삭제 |
| `rmdir` | 빈 디렉토리 삭제 |
| `echo` | 문자열 출력 |
| `>` / `>>` | 출력을 파일에 덮어쓰기 / 이어쓰기 |
| `\|` (파이프) | 앞 명령의 출력을 뒤 명령의 입력으로 전달 (`docker info \| head -5`) |
| `curl` | 터미널에서 URL 요청 (`curl http://localhost:8080`) |

### 권한

| 용어 / 명령 | 뜻 |
| --- | --- |
| r / w / x | 읽기(4) / 쓰기(2) / 실행(1) |
| 소유자 / 그룹 / 기타 | 권한 3자리의 순서 (user / group / others) |
| 755 | `rwxr-xr-x` — 디렉토리, 실행 파일 |
| 644 | `rw-r--r--` — 일반 파일 |
| 700 | `rwx------` — 소유자만 접근 |
| 디렉토리의 x | 그 안으로 들어갈(`cd`) 수 있는 권한 |
| `ls -l` | 파일 권한 확인 (맨 앞 `-` 파일, `d` 디렉토리) |
| `ls -ld` | 디렉토리 자체의 권한 확인 |
| `chmod` | 권한 변경 (`chmod 755 파일`, `chmod u+x 파일`) |
| 특수 권한 비트 | setuid(4000, 실행 시 소유자 권한), setgid(2000, 그룹 권한),<br>sticky(1000, `/tmp` 처럼 내 파일만 지울 수 있게) |
| `sudo` | 관리자(root) 권한으로 명령 실행 |
| Permission denied | 권한이 없어서 거부됨 |

### Docker

| 용어 / 명령 | 뜻 |
| --- | --- |
| 컨테이너 | 이미지를 실행한 격리된 실행 환경 |
| 이미지 | 컨테이너를 만드는 읽기 전용 템플릿 |
| 레지스트리 / Docker Hub | 이미지를 저장·공유하는 저장소 |
| 태그 | 이미지 버전 이름<br>(`nginx:1.27-alpine` 의 `1.27-alpine`, 생략 시 `latest`) |
| 데몬 (엔진) | 컨테이너를 실제로 관리하는<br>백그라운드 프로그램 (`dockerd`) |
| 호스트 | Docker 가 설치되어 돌아가는 실제 컴퓨터 |
| 격리 | 컨테이너끼리, 그리고 호스트와<br>분리되어 서로 영향을 주지 않음 |
| 재현성 | 언제 어디서 실행해도 같은 결과가 나오는 성질 |
| `docker --version` | 설치 및 버전 확인 |
| `docker info` | 데몬 동작 여부 확인 |
| `docker pull` | 이미지 다운로드 |
| `docker images` | 이미지 목록 |
| `docker run` | 이미지로 컨테이너 생성 + 실행 |
| `docker ps` / `docker ps -a` | 실행 중인 컨테이너 / 종료된 것 포함 전체 |
| `docker stop` / `docker start` | 컨테이너 중지 / 다시 시작 |
| `docker rm` / `docker rm -f` | 컨테이너 삭제 / 실행 중이어도 강제 삭제 |
| `docker rmi` | 이미지 삭제 |
| `docker logs` | 컨테이너 출력 로그 확인 (`-f` 실시간) |
| `docker stats` | CPU·메모리 사용량 확인 (`--no-stream` 한 번만) |
| `docker exec -it 이름 bash` | 실행 중인 컨테이너에 새 bash 열기<br>(exit 해도 컨테이너 유지) |
| `docker attach` | 메인 프로세스에 연결 (exit 하면 컨테이너 종료) |
| `docker inspect` | 컨테이너/이미지 상세 정보 (JSON) |
| `-d` | 백그라운드 실행 (detached) |
| `-it` | 대화형 + 터미널 연결 (interactive + tty) |
| `--name` | 컨테이너 이름 지정 |
| `--rm` | 종료되면 자동 삭제 |
| `-e` | 환경 변수 전달 |
| `Ctrl+P, Ctrl+Q` | attach 상태에서 컨테이너를 끄지 않고 빠져나오기 |
| Exited (0) | 정상 종료된 컨테이너 상태 |
| OrbStack / Docker Desktop | sudo 없이(또는 GUI로) Docker 엔진을 실행해 주는 앱 |

### Dockerfile

| 용어 / 명령 | 뜻 |
| --- | --- |
| Dockerfile | 이미지를 만드는 명령을 적은 파일 |
| 베이스 이미지 | `FROM` 으로 지정하는 출발 이미지 |
| `FROM` | 베이스 이미지 지정 (첫 줄) |
| `RUN` | 빌드할 때 명령 실행 (패키지 설치 등) |
| `CMD` | 컨테이너 시작 시 기본 실행 명령 |
| `COPY` | 호스트 파일을 이미지 안으로 복사 |
| `WORKDIR` | 작업 디렉토리 지정 |
| `ENV` | 환경 변수 지정 |
| `LABEL` | 이미지 메타데이터(설명) |
| `EXPOSE` | 사용하는 포트를 문서로 표시 (실제 연결은 `-p`) |
| `HEALTHCHECK` | 컨테이너 상태 주기 검사 → `(healthy)` 표시 |
| `docker build -t 이름:태그 .` | 이미지 빌드 (`-t` 이름, `.` 빌드 컨텍스트) |
| 빌드 컨텍스트 | 빌드에 사용할 파일이 있는 폴더 (명령 끝의 `.`) |
| 커스텀 이미지 | 기존 베이스 이미지에 내 설정·파일을 더해 만든 이미지 |

### 포트 / 스토리지

| 용어 / 명령 | 뜻 |
| --- | --- |
| 포트 | 한 컴퓨터 안에서 프로그램을<br>구분하는 번호 (웹 80, 8080) |
| 포트 매핑 | 호스트 포트를 컨테이너 포트에 연결 |
| `-p 8080:80` | 호스트 8080 → 컨테이너 80<br>(순서: 호스트:컨테이너) |
| localhost | 내 컴퓨터 자신 (127.0.0.1) |
| port is already allocated | 호스트 포트가 이미 사용 중이라는 오류 |
| `ss -ltnp` / `lsof -i :포트` | 포트를 점유한 프로세스(PID) 확인 |
| `kill PID` | 프로세스 종료 (강제는 `kill -9`) |
| 네트워크 네임스페이스 | 컨테이너마다 분리된 네트워크 공간<br>(그래서 포트 매핑이 필요) |
| 바인드 마운트 | 호스트의 특정 폴더를 컨테이너에 연결<br>→ 변경 즉시 반영 |
| `-v $(pwd)/site:/usr/share/nginx/html` | 바인드 마운트 (호스트 경로:컨테이너 경로) |
| 볼륨 | Docker 가 관리하는 저장 공간<br>→ 컨테이너를 지워도 데이터 유지 |
| 영속성 | 컨테이너가 사라져도 데이터가 남는 성질 |
| `docker volume create` | 볼륨 생성 |
| `docker volume ls` / `inspect` / `rm` | 볼륨 목록 / 상세 / 삭제 |
| `-v mydata:/data` | 볼륨 연결 (볼륨 이름:컨테이너 경로) |

### Docker Compose

| 용어 / 명령 | 뜻 |
| --- | --- |
| Docker Compose | 여러 컨테이너 실행 설정을 YAML 파일 하나로 관리하는 도구 |
| `docker-compose.yml` | Compose 설정 파일 |
| 서비스 (services) | Compose 에서 실행할 컨테이너 단위 (`web`, `checker`) |
| 서비스 디스커버리 | 같은 Compose 네트워크에서<br>서비스 이름으로 접속 (`http://web/`) |
| `docker compose up -d` | 전체 서비스 실행 (`--build` 이미지 다시 빌드) |
| `docker compose ps` | 서비스 상태 |
| `docker compose logs` | 서비스 로그 |
| `docker compose down` | 전체 중지 + 컨테이너·네트워크 삭제 |

### Git / GitHub

| 용어 / 명령 | 뜻 |
| --- | --- |
| Git | 로컬에서 파일 변경 이력을<br>관리하는 버전 관리 도구 |
| GitHub | Git 저장소를 온라인에 올려<br>공유·협업하는 원격 플랫폼 |
| 저장소 (Repository) | 프로젝트 파일 + 변경 이력 |
| 로컬 / 원격 (remote) | 내 컴퓨터의 저장소<br>/ GitHub 의 저장소 |
| origin | 원격 저장소의 기본 별칭 |
| 커밋 (commit) | 변경 내용을 저장한<br>기록(세이브 포인트) |
| 스테이징 영역 | 커밋할 파일을 모아 두는 곳<br>(`git add`) |
| 브랜치 (branch) | 독립된 작업 흐름, 기본 이름 `main` |
| `git config --global user.name / user.email` | 커밋 작성자 정보 설정 |
| `git config --global init.defaultBranch main` | 기본 브랜치 이름을 main 으로 |
| `git config --list` | 설정 전체 확인 |
| `git init` | 현재 폴더를 Git 저장소로 만들기 |
| `git clone` | 원격 저장소를 통째로 복사 |
| `git status` | 변경 상태 확인 |
| `git add .` | 변경 파일 전부 스테이징 |
| `git commit -m "메시지"` | 커밋 생성 |
| `git push` /<br>`git pull` | 원격으로 올리기 / 원격에서 받아오기 |
| `git log --oneline` | 커밋 기록 한 줄씩 보기 |
| `git remote -v` | 연결된 원격 저장소 주소 확인 |
| `git reset HEAD~1` | 마지막 커밋 취소 (파일 변경은 유지) |
| `.gitignore` | Git 이 추적하지 않을 파일 목록 |
| HTTPS / SSH | GitHub 인증 방식:<br>로그인·토큰 / 키 쌍(공개키 등록) |
| 공개키 / 개인키 | GitHub 에 등록하는 키(`.pub`)<br>/ 절대 공유하지 않는 키 |
| 403 | 권한 없음 (push 거부) |
| Codespaces | GitHub 가 제공하는<br>브라우저 기반 클라우드 개발 환경 |

---

## 6. 기술 스택 및 실행 환경

| 구분 | 사용 기술 |
|---|---|
| CLI | bash, coreutils (`ls`, `cp`, `mv`, `chmod` …), `curl` |
| 컨테이너 | Docker Desktop (WSL2 백엔드),<br>Docker Engine, Docker Compose, Dockerfile |
| 웹 서버 | NGINX (`nginx:1.27-alpine`) |
| 버전 관리 | Git, GitHub |
| 리눅스 환경 | WSL2 (Windows Subsystem for Linux) + Ubuntu |
| 에디터 | VSCode + WSL 확장 (GitHub 계정 연동) |
| 인증 | SSH 키 (ed25519) |

내 PC(Windows)에 WSL2(Ubuntu)와 Docker Desktop 을 설치하고, VSCode 를 WSL 에 연결해 모든 실습을 수행했습니다.

| 항목 | 값 | 근거 |
|---|---|:---:|
| 작업 환경 | Windows + WSL2(Ubuntu)<br>+ Docker Desktop + VSCode(WSL 연결) | — |
| Windows | Microsoft Windows [Version 10.0.26200] | [`00_env.md`](docs/logs/00_env.md) |
| OS (WSL) | Ubuntu 26.04.1 LTS (x86_64),<br>커널 6.18.54.1-microsoft-standard-WSL2 | [`00_env.md`](docs/logs/00_env.md) |
| Shell | GNU bash 5.3.9 | [`00_env.md`](docs/logs/00_env.md) |
| Terminal | VSCode 통합 터미널 (WSL: Ubuntu,<br>`TERM_PROGRAM=vscode`) | [`00_env.md`](docs/logs/00_env.md) |
| Docker | Docker version 29.9.2 (Server 29.9.2,<br>Docker Desktop 4.98.0) | [`03_docker_check.md`](docs/logs/03_docker_check.md) |
| Git | git version 2.53.0 | [`00_env.md`](docs/logs/00_env.md) |

---

## 7. 사용 이미지 및 출처

| 이미지 | 용도 | 출처 |
|---|---|---|
| `hello-world` | Docker 설치·실행 확인 | Docker Hub 공식 이미지 |
| `ubuntu:24.04` | 컨테이너 진입,<br>attach/exec 관찰, 볼륨 검증 | Docker Hub 공식 이미지 |
| `nginx:1.27-alpine` | 커스텀 이미지의 베이스,<br>바인드 마운트 실습 | Docker Hub 공식 이미지 |
| `alpine:3.20` | 보너스 Compose 의<br>보조 서비스(checker) | Docker Hub 공식 이미지 |
| `my-web:1.0` | **직접 만든 커스텀 이미지**<br>(`app/Dockerfile`) | 본 저장소 |

- 태그를 `latest` 대신 버전으로 고정(`1.27-alpine`, `24.04`)해, 나중에 다시 실행해도 같은 버전이 내려오도록 했습니다 (재현성).

---

## 8. 검증 방법 및 핵심 개념 요약

**검증 원칙:** 모든 실습은 `scripts/` 의 스크립트로 실행하고, 스크립트가 "입력 명령 + 출력 결과"를 코드블록으로 `docs/logs/*.md` 에 자동 저장합니다. 명령이 실패하면 즉시 멈추므로, 로그가 끝까지 있다는 것 자체가 성공의 증거입니다. 대화형(`-it`) 실습과 브라우저 접속은 스크린샷으로 남겼습니다.

| 핵심 질문 | 한 줄 답 | 확인한 결과 |
|---|---|---|
| 절대 vs 상대 경로 | 절대 경로는 `/` 부터<br>시작해 어디서나 같은 곳,<br>상대 경로는 현재 위치<br>기준(`./`, `../`) | `cd ..` → `cd ./practice`<br>후 `pwd` 비교 |
| r/w/x, 755·644 | r=4, w=2, x=1 을 더해<br>소유자/그룹/기타 순서로<br>표기. 755=`rwxr-xr-x`,<br>644=`rw-r--r--` | 폴더 x 를 빼자 `cd` 시<br>`Permission denied` |
| 커스텀 이미지 | 베이스 이미지(`FROM`)<br>위에 내 파일·설정(`COPY`,<br>`ENV`, `LABEL`,<br>`HEALTHCHECK`)을 더해 빌드 | `my-web:1.0` 빌드,<br>`healthy`, `APP_ENV=dev` |
| 포트 매핑 | 컨테이너는 격리된<br>네트워크라 밖에서 직접<br>못 들어감<br>→ `-p 호스트:컨테이너` 로 연결 | 같은 이미지로 8080,<br>8081 두 번 접속 |
| 볼륨 | Docker 가 관리하는 저장소.<br>컨테이너를 지워도 데이터<br>유지(영속성). 바인드 마운트는<br>내 폴더를 연결해 변경 즉시 반영 | 컨테이너 삭제 후 새<br>컨테이너에서 `hi` 확인 |
| Git vs GitHub | Git 은 로컬 버전 관리 도구,<br>GitHub 는 원격 저장소·협업 플랫폼 | 로컬 커밋<br>→ `git push` 로 GitHub 반영 |

---

## 9. 전체 작업 순서 (STEP 1-14)

| STEP | 작업 내용 | 증빙 |
|:---:|---|:---:|
| 1 | 미션 분석, GitHub 저장소 생성 | — |
| 2 | 폴더 구조·자동화<br>스크립트·Dockerfile·`.gitignore` 구성 | [4장](#4-폴더-구조) |
| 3 | 실행 환경 준비 (WSL2 + Docker Desktop<br>+ VSCode 설치, SSH 키 등록) | [`SETUP.md`](docs/SETUP.md), 스크린샷 3장 |
| 4 | 실행 환경 기록 | `00_env.md` |
| 5 | 터미널 기본 조작<br>(위치·목록·이동·생성·복사·이름변경·삭제) | `01_terminal.md` |
| 6 | 권한 실습 (파일 644→755,<br>디렉토리 755→700, x 제거 실험) | `02_permission.md` |
| 7 | Docker 설치·점검 (`--version`, `info`) | `03_docker_check.md` |
| 8 | Docker 운영 명령 + hello-world<br>+ ubuntu 진입 + attach/exec 관찰 | `04_docker_ops.md`, 스크린샷 3장 |
| 9 | Dockerfile 커스텀 이미지 빌드 | `05_build_run.md` |
| 10 | 포트 매핑 2회 실행 + 브라우저 접속 | `05_build_run.md`, 스크린샷 2장 |
| 11 | 바인드 마운트 변경 반영 검증 | `06_bind_mount.md` |
| 12 | 볼륨 영속성 검증 | `07_volume.md` |
| 13 | Git 설정 + VSCode GitHub 연동<br>+ 보너스 Compose·SSH | `08_git.md`, `09_compose.md`,<br>스크린샷 2장 |
| 14 | README 작성, 민감정보 마스킹, 최종 제출 | 본 문서 |

---

## 10. 작업 흐름도

**목적:** 이 미션은 "환경 준비 → 실습 → 증거 수집 → 문서화"가 반복되는 구조다. 어떤 단계에서 어떤 증거가 만들어지는지 한눈에 보이도록 정리했다.

### 10-1. 전체 진행 흐름

**설명:** ①·② 의 스크립트 실행(00~07)과 ③ 의 08~10 이 로그를 자동으로 만들고, 대화형 실습과 브라우저 접속(K)은 스크린샷으로 보완한 뒤, 모두 GitHub 에 커밋한다.

```mermaid
%%{init: {'flowchart': {'htmlLabels': false, 'padding': 24}}}%%
flowchart TB
    subgraph R1["① 준비"]
        direction LR
        A["미션 분석<br/>저장소 생성"] --> B["폴더 구조<br/>스크립트<br/>Dockerfile"] --> C["00<br/>실행 환경"] --> D["01<br/>터미널"] --> E["02<br/>권한"]
    end
    subgraph R2["② Docker 실습"]
        direction LR
        F["03<br/>Docker 점검"] --> G["04<br/>운영·컨테이너"] --> H["05<br/>빌드·포트"] --> I["06<br/>바인드 마운트"] --> J["07<br/>볼륨"]
    end
    subgraph R3["③ 증거 보완·마무리"]
        direction LR
        K["대화형 실습<br/>브라우저 접속<br/>(스크린샷)"] --> L["08 Git<br/>09 Compose"] --> P["10<br/>포트 충돌"] --> M["README 작성<br/>git push"]
    end
    R1 --> R2 --> R3
```

### 10-2. 스크립트 한 줄이 로그가 되는 과정

**설명:** `run "명령"` 한 줄이 실행되면 화면 출력과 로그 기록이 동시에 일어나고, 실패하면 그 자리에서 멈춘다.

```mermaid
sequenceDiagram
    participant S as 실습 스크립트
    participant L as lib.sh (run)
    participant SH as bash
    participant M as docs/logs/*.md

    S->>L: run "docker ps"
    L->>SH: 명령 실행
    SH-->>L: 출력 + 종료 코드
    L->>L: 민감정보 마스킹 (토큰 → ****)
    L->>M: "$ 명령" + 출력 을 코드블록으로 기록
    alt 종료 코드 ≠ 0
        L-->>S: [중단] 메시지 후 종료
    end
```

---

## 11. Docker 연결 구조 (포트·마운트·볼륨)

**설명:** 컨테이너는 호스트와 격리되어 있어서, 바깥과 연결하려면 네트워크는 **포트 매핑**, 파일은 **바인드 마운트** 또는 **볼륨**이라는 "문"을 직접 만들어야 한다.

```mermaid
%%{init: {'flowchart': {'htmlLabels': false, 'padding': 24}}}%%
flowchart LR
    subgraph HOST["호스트 (내 컴퓨터)"]
        BR["브라우저 / curl"]
        DIR["bind-mount/site<br/>(호스트 폴더)"]
        VOL[("mydata<br/>Docker 볼륨")]
    end
    subgraph C1["my-web-8080"]
        N1["nginx :80"]
    end
    subgraph C2["my-web-8081"]
        N2["nginx :80"]
    end
    subgraph C3["bind-test"]
        H3["/usr/share/nginx/html"]
    end
    subgraph C4["vol-test / vol-test2"]
        D4["/data"]
    end
    BR -- "-p 8080:80" --> N1
    BR -- "-p 8081:80" --> N2
    DIR -- "-v 호스트경로:<br/>컨테이너경로" --> H3
    VOL -- "-v mydata:/data" --> D4
```

### 설계 노트

- **네트워크 네임스페이스와 포트 포워딩:** 컨테이너는 자기만의 네트워크 공간(네트워크 네임스페이스)을 가져 호스트와 포트 번호가 분리된다. 그래서 `-p 8080:80` 은 "호스트 8080 으로 온 요청을 컨테이너 네임스페이스의 80 으로 전달(포워딩)하라"는 규칙이다.
- **같은 이미지, 다른 호스트 포트:** 컨테이너 안의 포트(80)는 서로 격리되어 같아도 되지만, 호스트 포트는 겹치면 `port is already allocated` 오류가 난다. 그래서 8080, 8081 로 나눴다.
- **`EXPOSE` 와 `-p` 는 다르다:** `EXPOSE 80` 은 "이 이미지는 80번을 쓴다"는 문서일 뿐이고, 실제 연결은 `docker run -p` 가 한다.
- **바인드 마운트는 개발용, 볼륨은 데이터용:** 바인드 마운트는 호스트에서 파일을 고치면 재빌드 없이 바로 반영된다. 볼륨은 컨테이너를 지워도 남아 DB 같은 데이터 보관에 쓴다.
- **`-p` 와 `-v` 모두 "밖:안" 순서:** 왼쪽이 호스트(또는 볼륨 이름), 오른쪽이 컨테이너다.

---

## 12. 핵심 실습 결과

### 12-1. 터미널 조작

`pwd`, `ls -la`(숨김 포함), `cd`(절대/상대), `mkdir -p`, `touch`, `echo >`/`>>`, `cat`, `cp`, `mv`, `rm`, `rmdir` 을 순서대로 수행했습니다. → [`01_terminal.md`](docs/logs/01_terminal.md)

### 12-2. 권한 변경 (파일 1, 디렉토리 1)

```bash
$ ls -l perm_file.txt          # 변경 전 644
-rw-r--r-- 1 ilililililil4319 ilililililil4319 16 Nov  5 14:42 perm_file.txt
$ chmod 755 perm_file.txt
$ ls -l perm_file.txt          # 변경 후 755
-rwxr-xr-x 1 ilililililil4319 ilililililil4319 16 Nov  5 14:42 perm_file.txt

$ ls -ld perm_dir              # 변경 전 755
drwxr-xr-x 2 ilililililil4319 ilililililil4319 4096 Nov  5 14:42 perm_dir
$ chmod 700 perm_dir
$ ls -ld perm_dir              # 변경 후 700
drwx------ 2 ilililililil4319 ilililililil4319 4096 Nov  5 14:42 perm_dir

$ chmod 600 perm_dir           # 디렉토리에서 x 제거
$ cd perm_dir
cd: perm_dir: Permission denied
```

파일은 실행 스크립트처럼 남도 읽고 실행할 수 있게 755 로, 디렉토리는 나만 들어갈 수 있게 700 으로 바꿔 보았습니다(개인 키·설정처럼 남이 보면 안 되는 폴더에 쓰는 값). 디렉토리에서 x(들어가기 권한)를 빼자 소유자인데도 `cd` 가 거부되었습니다. → [`02_permission.md`](docs/logs/02_permission.md)

### 12-3. Docker 설치·점검 및 운영 명령

- `docker --version` → 설치 확인, `docker info` → 데몬(Server) 동작 확인 → [`03_docker_check.md`](docs/logs/03_docker_check.md)
- `pull`, `images`, `run`, `ps`, `ps -a`, `logs`, `stats --no-stream`, `stop`, `start`, `rm` → [`04_docker_ops.md`](docs/logs/04_docker_ops.md)
- `hello-world` 는 메시지를 출력하고 할 일이 끝나 종료되므로 `docker ps` 에는 없고 `docker ps -a` 에만 `Exited (0)` 으로 보입니다.

Docker Desktop 설치 후 엔진 동작(`Engine running`)과 Ubuntu(WSL) 터미널에서의 버전 확인:

![Docker Desktop 실행](docs/screenshots/docker-desktop.png)
![Docker 버전 확인](docs/screenshots/docker-check.png)

### 12-4. ubuntu 컨테이너 진입 및 attach / exec 비교

```bash
docker run -it --name my-ubuntu ubuntu:24.04 bash   # 프롬프트가 root@...:/# 로 바뀜
ls
echo "hello from inside"
exit
```

![ubuntu 진입](docs/screenshots/ubuntu-it.png)

```bash
docker start my-ubuntu
docker exec -it my-ubuntu bash    # 새 bash 를 하나 더 열기
exit
docker ps                         # → Up (계속 실행)
docker attach my-ubuntu           # 메인 bash 에 직접 붙기
exit
docker ps -a                      # → Exited (0)
```

![attach vs exec 1](docs/screenshots/attach-exec-1.png)
![attach vs exec 2](docs/screenshots/attach-exec-2.png)

| 방법 | 동작 | exit 후 컨테이너 |
|---|---|:---:|
| `docker exec -it` | 컨테이너 안에 **새 프로세스**를 추가로 실행 | Up |
| `docker attach` | 이미 돌고 있는 **메인 프로세스(PID 1)** 에 연결 | Exited |

컨테이너는 메인 프로세스가 살아 있는 동안만 실행됩니다. attach 상태에서 끄지 않고 나오려면 `Ctrl+P` → `Ctrl+Q`.

### 12-5. Dockerfile 커스텀 이미지 (방식 A: 웹 서버 베이스 + 정적 콘텐츠 교체)

- **베이스:** `nginx:1.27-alpine` — 웹 서버가 이미 들어 있고 가벼우며, 버전을 고정해 재현성 확보
- **Dockerfile:** [`app/Dockerfile`](app/Dockerfile)

| 커스텀 포인트 | 목적 | 확인 방법과 결과 |
|---|---|---|
| `COPY site/`<br>`/usr/share/nginx/html/` | 기본 환영 페이지를<br>내 페이지로 교체 | `curl` → "Hello from my<br>custom NGINX image (E1-1)" |
| `ENV APP_ENV=dev` | 실행 모드<br>설정값 주입 | `docker exec my-web-8080`<br>`printenv APP_ENV` → `dev` |
| `LABEL ...` | 이미지 설명<br>메타데이터 | `docker inspect`<br>→ title, description 표시 |
| `HEALTHCHECK` | 10초마다<br>응답 검사 | `.State.Health.Status`<br>→ `healthy` |

```bash
$ docker build -t my-web:1.0 .
$ docker images my-web
IMAGE        ID             DISK USAGE   CONTENT SIZE
my-web:1.0   b4547f8e84e7       73.6MB           21MB
```

→ [`05_build_run.md`](docs/logs/05_build_run.md)

### 12-6. 포트 매핑 접속

```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
$ docker ps --filter name=my-web
... 0.0.0.0:8081->80/tcp ...   my-web-8081
... 0.0.0.0:8080->80/tcp ...   my-web-8080
```

브라우저 주소창에 `localhost:8080`, `localhost:8081` 을 입력해 접속했고, 같은 응답을 `curl http://localhost:8080` 으로도 확인했습니다.

![8080 접속](docs/screenshots/port-8080.png)
![8081 접속](docs/screenshots/port-8081.png)

### 12-7. 바인드 마운트 (변경 반영)

```bash
$ docker run -d -p 8082:80 --name bind-test -v "$(pwd)/site":/usr/share/nginx/html nginx:1.27-alpine
$ curl -s http://localhost:8082
<h1>Before: bind mount test</h1>
$ echo '<h1>After: changed on host!</h1>' > site/index.html     # 호스트에서만 수정
$ curl -s http://localhost:8082
<h1>After: changed on host!</h1>                                  # 재빌드 없이 즉시 반영
```

→ [`06_bind_mount.md`](docs/logs/06_bind_mount.md)

### 12-8. 볼륨 (영속성)

```bash
$ docker volume create mydata
$ docker run -d --name vol-test -v mydata:/data ubuntu:24.04 sleep infinity
$ docker exec vol-test bash -lc 'echo hi > /data/hello.txt && cat /data/hello.txt'
hi
$ docker rm -f vol-test                                            # 컨테이너 삭제
$ docker run -d --name vol-test2 -v mydata:/data ubuntu:24.04 sleep infinity
$ docker exec vol-test2 bash -lc 'cat /data/hello.txt'
hi                                                                 # 데이터 유지
```

→ [`07_volume.md`](docs/logs/07_volume.md)

### 12-9. Git 설정 및 GitHub 연동

- `git config --global user.name / user.email / init.defaultBranch main` 설정 후 `git config --list` 기록 → [`08_git.md`](docs/logs/08_git.md)
- VSCode(WSL: Ubuntu 연결)에 GitHub 계정으로 로그인해 저장소와 연동했습니다.
- SSH 키(ed25519)를 만들어 **공개키만** GitHub 에 등록하고, `git@github.com:` 주소로 clone·push 했습니다 (`remote.origin.url=git@github.com:ilililililil4319/E1-1.git`).

- push 결과는 GitHub 커밋 기록에서 확인할 수 있습니다: [커밋 목록](https://github.com/ilililililil4319/E1-1/commits/main) (예: `d9fb64d..cd074d7  main -> main`)

![VSCode GitHub 연동](docs/screenshots/vscode-github.png)
![SSH 연결 확인](docs/screenshots/ssh-github.png)

### 12-10. 포트 충돌 진단 및 해제

같은 호스트 포트를 두 프로그램이 동시에 쓸 수 없습니다. 충돌을 일부러 만들고 **확인 → 원인 찾기 → 해제 → 재확인** 순서로 처리했습니다. → [`10_port_check.md`](docs/logs/10_port_check.md) · 실행: `bash scripts/10_port_check.sh`

| 단계 | 컨테이너가<br>포트를 쓰는 경우 | 일반 프로세스가<br>포트를 쓰는 경우 |
|---|---|---|
| ① 증상 | `docker run -p 8085:80 ...`<br>→ `port is already allocated` | 서버 실행<br>→ `Address already in use` |
| ② 누가 쓰는지<br>확인 | `docker ps --filter publish=8085`<br>`docker port <컨테이너>` | `ss -ltnp \| grep :8099`<br>또는 `lsof -i :8099`<br>→ PID 확인 |
| ③ 해제 | `docker stop <컨테이너>`<br>→ `docker rm <컨테이너>` | `kill <PID>`<br>(응답이 없을 때만<br>`kill -9 <PID>`) |
| ④ 재확인 | 다시 `docker run`<br>→ 아래 `curl` 명령<br>→ `200` | `ss -ltnp \| grep :8099`<br>결과 없음 |

④의 `curl` 명령: `curl -s -o /dev/null -w '%{http_code}' localhost:8085`

- **Windows (PowerShell) 에서는:** `netstat -ano | findstr :8080` 으로 PID 를 찾고 `taskkill /PID <PID>` 로 종료합니다. Docker Desktop 이 연 포트라면 프로세스를 죽이지 말고 해당 컨테이너를 `docker stop` 합니다.
- **안전한 해제 원칙:** 무엇이 쓰고 있는지 먼저 확인하고, 내가 띄운 컨테이너·프로세스만 정상 종료(`stop`, `kill`)한다. 모르는 프로세스는 강제 종료하지 않고 다른 포트(예: 8081)를 쓴다.

---

## 13. 보너스 과제

설정: [`compose/docker-compose.yml`](compose/docker-compose.yml) · 실행: [`scripts/09_compose.sh`](scripts/09_compose.sh) · 로그: [`09_compose.md`](docs/logs/09_compose.md)

| 과제 (달성) | 수행 내용 | 확인 결과 |
|---|---|---|
| 1. Compose<br>기초 ✅ | `docker run` 옵션<br>(이미지, 포트, 환경 변수)을<br>`docker-compose.yml`로<br>문서화 | `docker compose up`<br>`-d --build`로<br>web 서비스 빌드, 실행 |
| 2. 멀티<br>컨테이너 ✅ | `web`(내 nginx)<br>+ `checker`(alpine) | checker가<br>`http://web/`으로 접속해 내 페이지 수신<br>→ 컨테이너 간 통신 성공 |
| 3. 운영<br>명령어 ✅ | `up` → `ps` → `logs`<br>→ `down` → `ps` | 두 서비스 Up, web `(healthy)`<br>down 후 목록 비어 있음 |
| 4. 환경<br>변수 ✅ | `APP_ENV=dev WEB_PORT=8090`<br>`docker compose up -d` | `printenv APP_ENV` → `dev`<br>`localhost:8090` 응답 |
| 5. GitHub<br>SSH 키 ✅ | `ssh-keygen -t ed25519`<br>→ 공개키(`.pub`)<br>GitHub 에 등록<br>→ SSH 주소로 clone | `ssh -T git@github.com`<br>→ `Hi …! You've successfully`<br>`authenticated`<br>서버 지문 `SHA256:+DiY3wvv…`가<br>GitHub 공개 값과 일치 |

**배운 점:** 실행 명령을 파일로 문서화하면 누구나 `up` 한 줄로 같은 구성을 재현할 수 있고, 포트·모드 같은 설정은 환경 변수로 분리해 코드를 고치지 않고 바꿀 수 있다.

---

## 14. 로컬 실행 방법

자세한 설치 방법은 [`docs/SETUP.md`](docs/SETUP.md) 를 참고하세요.

- **Windows (WSL2 + Docker Desktop) 단계별 가이드 W1~W12:** [바로 가기](docs/SETUP.md#windows-wsl2--docker-desktop--처음부터-순서대로)

### 내 PC (Docker 설치 + 실행된 상태)

```bash
git clone https://github.com/ilililililil4319/E1-1.git
cd E1-1
bash scripts/run_all.sh        # 00~07 실행 → docs/logs/ 에 저장
bash scripts/08_git.sh         # Git 설정 확인
bash scripts/09_compose.sh     # (보너스)
bash scripts/10_port_check.sh  # 포트 충돌 진단·해제
```

> Windows 는 Windows 폴더가 아닌 WSL Ubuntu 폴더(`~/codyssey`)에 clone 해야 권한 실습과 바인드 마운트가 정상 동작합니다.
>
> 참고: Docker 를 설치할 수 없는 PC 라면 GitHub Codespaces 처럼 Docker 가 준비된 클라우드 개발 환경에서 같은 스크립트를 실행하는 방법도 있습니다.

> 대화형 실습([12-4](#12-4-ubuntu-컨테이너-진입-및-attach--exec-비교))은 명령을 **한 줄씩** 직접 입력합니다.

---

## 15. 환경 변수 및 포트 설정

| 이름 | 위치 | 기본값 | 역할 |
|---|---|---|---|
| `APP_ENV` | `app/Dockerfile`<br>(`ENV`) | `dev` | 실행 모드 표시 |
| `APP_ENV` | `compose/`<br>`docker-compose.yml` | `prod`<br>(실행 시 `dev` 주입) | Compose 에서<br>모드 변경 |
| `WEB_PORT` | `compose/`<br>`docker-compose.yml` | `8090` | Compose web<br>서비스의 호스트 포트 |

| 호스트 포트 | 용도 |
|:---:|---|
| 8080, 8081 | 커스텀 이미지 포트 매핑 2회 |
| 8082 | 바인드 마운트 실습 |
| 8090 | 보너스 Compose |
| 8085, 8099 | 포트 충돌 진단 실습 |

이미 사용 중인 포트가 있으면 스크립트의 숫자 또는 `WEB_PORT` 를 바꿔 실행합니다.

---

## 16. 실습 중 발생한 오류와 해결

(문제 → 원인 가설 → 확인 → 해결/대안)

### 16-1. 대화형 컨테이너에 여러 줄을 붙여 넣었더니 명령이 실행되지 않음

- **문제:** `docker run -it ... bash` 와 `ls`, `echo`, `exit` 를 한꺼번에 붙여 넣었더니 프롬프트만 `root@0defc4e8da2c:/#` 로 바뀌고 `ls`, `echo` 결과가 나오지 않았다.
- **원인 가설:** 컨테이너 bash 가 준비되기 **전에** 나머지 줄이 입력되어 컨테이너로 전달되지 않았다.
- **확인:** 컨테이너 프롬프트에서 `ls` 를 한 줄씩 다시 입력하자 `bin boot dev etc ...` 가 정상 출력됐다.
- **해결/대안:** 대화형 컨테이너에서는 프롬프트가 바뀐 것을 확인한 뒤 **한 줄씩** 입력한다. 여러 명령을 한 번에 실행하려면 `docker run --rm ubuntu:24.04 bash -c 'ls && echo hi'` 처럼 비대화형으로 쓴다.

### 16-2. 스크린샷 파일 이름이 `port-8080.png.png` 로 저장됨

- **문제:** README 에서 `port-8080.png` 이미지가 보이지 않았다.
- **원인 가설:** 저장할 때 이름에 `.png` 를 직접 써서 확장자가 두 번 붙었다.
- **확인:** 탐색기에 `port-8080.png.png` 로 표시됨.
- **해결/대안:** `mv docs/screenshots/port-8080.png.png docs/screenshots/port-8080.png`

### 16-3. WSL 설치 후 "OOBE 명령이 완료되는 것을 기다리는 중" 에서 멈춤

- **문제:** `wsl --install` 후 재부팅하고 Ubuntu 를 열었더니 `wsl: "Ubuntu" 배포에 대해 OOBE 명령이 완료되는 것을 기다리는 중 ...` 에서 멈추고 아이디 입력 화면이 나오지 않았다.
- **원인 가설:** OOBE(처음 사용 설정: 사용자 계정 만들기)가 다른 창에서 대기 중이거나 설치가 끝까지 진행되지 않았다.
- **확인:** 다른 창에 계정 생성 화면이 없었고, 같은 창에서 계속 대기했다.
- **해결/대안:** PowerShell 에서 `wsl --install -d Ubuntu` 를 실행하자 `Create a default Unix user account:` 가 나타나 계정을 만들었다. 비밀번호는 입력해도 화면에 보이지 않으며, 두 번 입력이 다르면 `Sorry, passwords do not match` 가 나와 `y` 로 다시 입력했다.

### 16-4. ssh-keygen 의 저장 경로에 다음 명령이 입력됨

- **문제:** `ssh-keygen` 과 `cat ~/.ssh/id_ed25519.pub` 를 함께 붙여 넣자 키 저장 경로가 `cat ~/.ssh/id_ed25519.pub` 로 입력되고, 암호(passphrase) 확인에서 `Passphrases do not match` 가 반복됐다. ([스크린샷](docs/screenshots/trouble-ssh-keygen.png))
- **원인 가설:** `ssh-keygen` 은 질문을 하는 명령이라, 함께 붙여 넣은 두 번째 줄이 첫 질문(저장 경로)의 답으로 들어갔다.
- **확인:** 화면에 `Enter passphrase for "cat ~/.ssh/id_ed25519.pub"` 로 표시됨.
- **해결/대안:** `Ctrl + C` 로 취소한 뒤 `ssh-keygen -t ed25519` 한 줄만 직접 입력하고 질문 3개에 Enter 만 눌러 기본 경로(`~/.ssh/id_ed25519`)에 생성했다. 질문하는 명령은 한 줄씩 실행한다.

### 16-5. 컨테이너 안에서 docker / git 명령이 "command not found"

- **문제:** `docker run -it ... bash` 로 들어간 상태에서 `docker run`, `git pull`, `bash scripts/08_git.sh` 를 입력하자 `bash: docker: command not found`, `bash: git: command not found`, `No such file or directory` 가 나왔다.
- **원인 가설:** 프롬프트가 `root@830232cbdb8d:/#` 인 **컨테이너 안**이었다. 컨테이너는 호스트와 격리된 별도 리눅스라 docker·git·내 저장소 파일이 없다.
- **확인:** 프롬프트가 `ilililililil4319@DESKTOP-…:~/codyssey/E1-1$`(호스트)가 아닌 `root@<컨테이너ID>:/#` 였다.
- **해결/대안:** `exit` 로 호스트로 나온 뒤 실행했다. 명령 전에 프롬프트가 `$`(호스트)인지 `#`(컨테이너)인지 확인한다.

### 16-6. 따옴표가 닫히지 않아 `>` 가 나오고 명령이 실행되지 않음

- **문제:** 컨테이너 안에서 `echo "hello from inside"'exit` 를 입력하자 `>` 만 나오고, 이후 입력한 명령도 실행되지 않았다.
- **원인 가설:** `"` 뒤에 작은따옴표 `'` 가 하나 더 들어가 따옴표가 열린 채로 남아, 쉘이 닫는 따옴표를 기다렸다.
- **확인:** `>` 는 명령이 아직 끝나지 않았다는 연속 입력 표시다.
- **해결/대안:** `Ctrl + C` 로 취소하고 `echo hello from inside` 처럼 다시 입력했다.

---

## 17. AI(Claude) 사용 로그 요약

| 사용 작업 | 사용 이유 | 검증 방법 |
|---|---|---|
| 미션 분석, 폴더 구조와<br/>실습 자동화 스크립트 초안 | 반복 명령과 출력을<br/>빠짐없이 기록하기 위해 | 직접 실행해<br>`docs/logs/` 의<br/>명령·출력을 하나씩 확인 |
| Dockerfile 커스텀 포인트 설계 | 베이스 이미지 선택과<br/>커스텀 목적 정리 | 빌드 성공,<br>`healthy`,<br/>`printenv`,<br>`inspect` 로 확인 |
| README 구성, 용어 정리,<br/>스크린샷 아이디 마스킹 | 문서 구조화와<br/>개인정보 보호 | GitHub 에서<br>링크·이미지 표시 확인 |
| 개념 학습 노트 | 비전공자로서 개념 이해 | 핵심 질문 6가지를<br>직접 말로 설명 |

> 모든 명령은 직접 실행했고, 로그와 스크린샷은 내 실행 결과입니다. AI 가 제안한 내용은 실제 출력으로 다시 확인한 뒤에만 반영했습니다.

---

## 18. 기능요구사항 대비 결과

| 요구사항 | 구현 위치 | 달성 |
|---|---|:---:|
| 제출 저장소 + 기술 문서<br/>(개요·환경·체크리스트·검증·증거 링크) | 본 README | ✅ |
| 터미널 조작 로그 | [12-1](#12-1-터미널-조작), `01_terminal.md` | ✅ |
| 권한 실습 (파일 1, 디렉토리 1) | [12-2](#12-2-권한-변경-파일-1-디렉토리-1), `02_permission.md` | ✅ |
| Docker 설치 및 기본 점검 | [12-3](#12-3-docker-설치점검-및-운영-명령), `03_docker_check.md`, 스크린샷 2장 | ✅ |
| Docker 기본 운영 명령 | [12-3](#12-3-docker-설치점검-및-운영-명령), `04_docker_ops.md` | ✅ |
| 컨테이너 실행 실습<br/>(hello-world, ubuntu, attach/exec) | [12-4](#12-4-ubuntu-컨테이너-진입-및-attach--exec-비교), 스크린샷 3장 | ✅ |
| 기존 Dockerfile 기반 커스텀 이미지 | [12-5](#12-5-dockerfile-커스텀-이미지-방식-a-웹-서버-베이스--정적-콘텐츠-교체), `app/Dockerfile` | ✅ |
| 포트 매핑 및 접속 증거 | [12-6](#12-6-포트-매핑-접속), 스크린샷 2장 | ✅ |
| 포트 충돌 진단 및 해제<br/>(점유 프로세스 확인·해제) | [12-10](#12-10-포트-충돌-진단-및-해제), `10_port_check.md` | ✅ |
| 바인드 마운트 반영 | [12-7](#12-7-바인드-마운트-변경-반영), `06_bind_mount.md` | ✅ |
| Docker 볼륨 영속성 | [12-8](#12-8-볼륨-영속성), `07_volume.md` | ✅ |
| Git 설정 및 GitHub 연동 | [12-9](#12-9-git-설정-및-github-연동), `08_git.md`, 스크린샷 | ✅ |
| 트러블슈팅 2건 이상 | [16장](#16-실습-중-발생한-오류와-해결) (6건) | ✅ |
| 보안 및 개인정보 보호 | [20장](#20-보안-유의사항) | ✅ |
| 보너스 (Compose 1~4) | [13장](#13-보너스-과제) | ✅ |
| 보너스 (SSH 키) | [13장](#13-보너스-과제), [12-9](#12-9-git-설정-및-github-연동) | ✅ |

### 18-1. AI 사전평가(네이토) 결과

제출 전에 네이토 AI 사전평가로 요구사항 충족 여부를 점검하고, 부족한 항목을 실행 로그로 보완했습니다.

| 시도 | 평가 시각 | 결과 | 비고 |
|:---:|---|:---:|---|
| 1 | 2026-11-05 | ✕ | 평가 완료되지 않음 |
| 2 | 2026-11-05 15:17 | 94% (17 / 18) | #16 FAIL: 포트 점유 프로세스<br>확인·해제 절차 없음 |
| 3 | 2026-11-05 15:23 | **100% (18 / 18)** | #16 보완 후 전 항목 통과 |

**보완 내용 (#16):** 포트 충돌을 일부러 만들고 확인 → 원인 찾기 → 해제 → 재확인하는 [`scripts/10_port_check.sh`](scripts/10_port_check.sh)를 작성해 실행하고, 결과 로그 [`10_port_check.md`](docs/logs/10_port_check.md)와 [12-10](#12-10-포트-충돌-진단-및-해제) 설명을 추가했습니다. 같은 시점에 2차 평가의 보완 의견(응답 상태 코드 확인, 755/700 선택 이유, push 증거 링크, 네트워크 네임스페이스, 특수 권한 비트)도 함께 반영했습니다.

**3차 종합 평가:** "README.md, scripts/, docs/logs/ 하위에 실행 명령·출력·스크린샷·트러블슈팅이 체계적으로 정리되어 있어 미션 핵심(빌드·포트·볼륨·Git 연동) 증거가 모두 제출되어 있습니다."

![AI 사전평가 결과 100%](docs/screenshots/pre-eval-result.png)

> AI 사전평가는 참고용이며, 실제 동료평가 결과와 다를 수 있습니다.

---

## 19. 결론 및 한계점

### 결론

- 이미지(설계도)와 컨테이너(실행체)를 분리했기 때문에, 같은 `my-web:1.0` 으로 컨테이너를 몇 개를 만들어도 같은 결과가 나왔다.
- 컨테이너는 격리되어 있어 바깥과 연결하는 방법(포트·마운트·볼륨)을 직접 정해야 한다는 것을, 실행 결과로 하나씩 확인했다.
- Windows 에서도 WSL2 로 진짜 리눅스 환경을 만들자 권한(`chmod`)·바인드 마운트가 리눅스와 똑같이 동작했다.
- 실습 명령을 스크립트로 만들고 출력을 자동 기록하자, 몇 번을 다시 실행해도 `bash scripts/run_all.sh` 한 줄로 같은 결과를 재현할 수 있었다.

### 설계 결정과 다른 선택지

| 결정 | 이유 | 검토한 다른 방법과 고르지 않은 이유 |
|---|---|---|
| 실습을 스크립트로<br>자동 기록 | 명령·출력을 빠짐없이,<br>다시 실행해도 같은 결과 | 수동 입력 + 캡처:<br>누락이 생기고 오래 걸림<br>(대화형 실습만 수동으로 수행) |
| 베이스<br>`nginx:1.27-alpine` | 웹 서버 내장,<br>작은 이미지 | `ubuntu` + nginx 설치:<br>이미지가 크고 빌드가 느림<br>`httpd`: 가능하지만 nginx 로 충분 |
| 태그 버전 고정 | 시간이 지나도<br>같은 이미지 | `latest`: 가리키는 버전이 바뀌어<br>결과가 달라질 수 있음 |
| `HEALTHCHECK` 추가 | "켜짐"과 "응답함"을 구분 | 상태 표시만 확인:<br>서버가 멈춰도 Up 으로 보임 |
| 호스트 포트<br>8080·8081 | 개발용으로 흔하고<br>80 과 충돌 위험이 적음 | 80: 다른 프로그램·권한 문제 가능 |
| 개발은 바인드 마운트,<br>데이터는 볼륨 | 수정 즉시 반영<br>/ 컨테이너 삭제 후에도 유지 | 매번 이미지 재빌드: 느림 |
| Windows 에서<br>WSL2 사용 | `chmod`·마운트가<br>리눅스와 동일하게 동작 | Git Bash: 경로 변환·권한 문제<br>가상 머신: 무겁고 설정이 많음 |
| GitHub 연결은 SSH | push 마다 로그인 불필요,<br>토큰 노출 위험 감소 | HTTPS + 토큰:<br>WSL 에서 인증 설정이 번거로움 |
| 로그를 `.md` 로 저장 | GitHub 에서 바로 읽히고<br>코드 블록으로 명령·출력 구분 | `.txt`: 서식 없음<br>이미지: 검색·복사 불가 |

### 한계점

- 실습 환경은 Windows + WSL2 기준이다. macOS 는 OrbStack 또는 Docker Desktop 으로 같은 스크립트를 실행할 수 있지만 직접 검증하지는 않았다.
- 스크립트가 많은 명령을 자동으로 실행하므로, 각 명령의 의미는 따로 학습해 설명할 수 있어야 한다.

---

## 20. 보안 유의사항

- 로그 스크립트는 `ghp_...` 같은 GitHub 토큰과 password/token/secret 줄을 자동으로 `****` 처리한다 ([`scripts/lib.sh`](scripts/lib.sh)).
- 스크린샷의 GitHub 아이디·이메일은 가렸다. 토큰·비밀번호·인증 코드는 어떤 파일에도 없다.
- `.gitignore` 로 `.env`, 키 파일(`*.pem`, `id_ed25519*`)이 올라가지 않게 막았다.
- SSH 키는 **공개키(`id_ed25519.pub`)만** GitHub 에 등록했고, 개인키(`id_ed25519`)는 내 PC 의 `~/.ssh/` 에만 두고 출력·공유하지 않았다.
- 첫 SSH 접속 때 서버 지문을 GitHub 공개 값과 비교한 뒤 `yes` 로 승인했다 (`~/.ssh/known_hosts` 에 저장).
- 민감 정보가 올라간 경우: 파일과 Git 기록에서 제거하고 해당 토큰/키를 폐기 후 재발급한다.
- 공용 PC 를 쓸 때는 작업 후 GitHub 로그아웃과 Git 사용자 정보 삭제(`git config --global --unset user.name / user.email`)를 한다.

---

## 21. 이미지·도구 출처 및 라이선스 유의사항

- `hello-world`, `ubuntu`, `nginx`, `alpine` 은 Docker Hub 의 공식 이미지(Docker Official Images)를 사용했다. 각 이미지 안의 소프트웨어는 각자의 라이선스를 따른다 (예: NGINX 는 2-clause BSD 라이선스).
- 이 저장소에는 이미지 파일 자체를 포함하지 않고, `Dockerfile` 과 실행 명령만 포함한다. 이미지는 실행할 때 Docker Hub 에서 내려받는다.
- `app/site/index.html`, 스크립트, 문서는 이 미션을 위해 작성한 것이다.

---

## 22. 기타

- 실습 중 발생한 오류와 해결 과정은 [16장](#16-실습-중-발생한-오류와-해결)에 정리했다.
- AI(Claude)는 스크립트 초안, 오류 원인 분석, 문서 구성에 활용했고, 모든 실행과 결과 확인은 직접 했다.
- 환경 세팅(Mac / Windows / 공용 PC 정리) 방법은 [`docs/SETUP.md`](docs/SETUP.md) 에 있다.
- 실행 로그는 스크립트를 다시 실행하면 그 환경 기준으로 새로 만들어진다.

---

*본 프로젝트는 E1-1 미션(내 컴퓨터에 개발자용 '작업실' 꾸미기)의 결과물로 작성되었습니다.*
