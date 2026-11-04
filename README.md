# E1-1. 내 컴퓨터에 개발자용 '작업실' 꾸미기

## 1. 프로젝트 개요

터미널(리눅스 CLI), Docker, Git/GitHub 를 직접 세팅하고 **실행 결과(로그·접속·데이터 유지)로 검증**하는 미션입니다.

- 터미널로 작업 폴더를 만들고 파일 권한을 바꿔 본다.
- Docker 를 점검하고 컨테이너를 실행·관리한다.
- NGINX 베이스 이미지로 **커스텀 이미지**를 만들고, **포트 매핑**으로 접속한다.
- **바인드 마운트**(변경 반영)와 **볼륨**(데이터 영속성)을 직접 검증한다.
- Git 설정 후 VSCode 로 GitHub 와 연동한다.

목표: 누가 몇 번을 실행해도 같은 결과가 나오는 **재현 가능한 환경**을 만든다.

## 2. 저장소 구조

```text
E1-1/
├── README.md               # 기술 문서 (이 파일)
├── app/                    # 웹 서버 소스 + Dockerfile
│   ├── Dockerfile
│   └── site/index.html
├── bind-mount/             # 바인드 마운트 실습 폴더 (site/ 는 스크립트가 생성)
├── compose/                # 보너스: docker-compose.yml
├── scripts/                # 실습 자동화 스크립트 (명령 + 출력을 로그로 저장)
│   ├── lib.sh              #   공통 함수 (기록, 마스킹)
│   ├── 00_env.sh ~ 09_compose.sh
│   └── run_all.sh          #   00~07 한 번에 실행
└── docs/
    ├── SETUP.md            # 환경 세팅 가이드 (공용 PC / 집 PC)
    ├── logs/               # 실행 로그 (스크립트가 자동 생성)
    └── screenshots/        # 스크린샷
```

## 3. 실행 환경

교육장 PC(Windows)에 Docker와 WSL이 없어서, 모든 실습은 **GitHub Codespaces(클라우드 Ubuntu + Docker + 브라우저 VSCode)** 에서 수행했습니다. (자세한 경위: [트러블슈팅 9-1](#9-1-교육장-pc에서-docker-명령을-찾을-수-없음))

| 항목 | 값 | 근거 |
| --- | --- | --- |
| 작업 환경 | GitHub Codespaces (교육장 Windows PC의 브라우저로 접속) | |
| OS | Ubuntu 24.04.5 LTS (x86_64) | [00_env.md](docs/logs/00_env.md) |
| Shell | GNU bash 5.2.21 | [00_env.md](docs/logs/00_env.md) |
| Terminal | VSCode 통합 터미널 (`TERM_PROGRAM=vscode`) | [00_env.md](docs/logs/00_env.md) |
| Docker | Docker version 29.9.2-2 (Server 29.9.2-2) | [03_docker_check.md](docs/logs/03_docker_check.md) |
| Git | git version 2.56.0 | [00_env.md](docs/logs/00_env.md) |

## 4. 빠른 재현 방법

세팅 방법은 [docs/SETUP.md](docs/SETUP.md) 를 참고하세요.

방법 1) 내 PC (Docker 설치 + 실행된 상태)

```bash
git clone https://github.com/ilililililil4319/E1-1.git
cd E1-1
bash scripts/run_all.sh        # 00~07 실행, 결과는 docs/logs/ 에 저장
bash scripts/08_git.sh         # Git 설정 확인
bash scripts/09_compose.sh     # (보너스)
```

방법 2) 설치 없이 GitHub Codespaces (이 과제를 수행한 방법)

1. 저장소 페이지 → `<> Code` → `Codespaces` → `Create codespace on main`
2. 브라우저에 VSCode가 열리면 아래 터미널에서 위와 같은 `bash scripts/...` 명령 실행
3. 웹 서버 접속은 `포트` 탭의 전달된 주소(`...-8080.app.github.dev`)로 확인

주의 (개인 PC 의존성):
- Windows에서 올린 파일은 실행 권한(x)이 빠질 수 있어 `./scripts/...` 대신 `bash scripts/...` 로 실행합니다.
- 터미널 실습 폴더는 `~/codyssey/practice` 이며, `~` 는 PC마다 다른 홈 폴더로 바뀝니다.
- 포트 8080, 8081, 8082, 8090 을 사용합니다. 이미 쓰는 포트가 있으면 스크립트의 숫자를 바꾸세요.
- Windows 는 WSL2 사용을 권장합니다 ([SETUP.md](docs/SETUP.md#windows)).

## 5. 수행 체크리스트

- [x] 터미널 기본 조작 및 폴더 구성
- [x] 권한 변경 실습 (파일 1, 디렉토리 1)
- [x] Docker 점검 (Codespaces: `docker --version`, `docker info`)
- [ ] Docker 직접 설치 / 점검 (집 PC Windows + Docker Desktop, 추가 예정)
- [x] Docker 기본 운영 명령 (images, ps, logs, stats)
- [x] hello-world 실행
- [x] ubuntu 컨테이너 진입 + attach / exec 차이 관찰
- [x] Dockerfile 커스텀 이미지 빌드 / 실행
- [x] 포트 매핑 접속 (2회: 8080, 8081)
- [x] 바인드 마운트 반영
- [x] 볼륨 영속성
- [x] Git 설정 + VSCode GitHub 연동
- [x] 트러블슈팅 2건 이상 작성
- [x] (보너스) Docker Compose 멀티 컨테이너 + 환경 변수

## 6. 수행 내용과 검증 방법

모든 로그는 "입력 명령 + 출력 결과"가 함께 코드블록으로 저장됩니다.

| # | 항목 | 무엇으로 확인했나 | 증거 |
| --- | --- | --- | --- |
| 1 | 터미널 조작 | `pwd`, `ls -la`, `cd`(절대/상대), `mkdir -p`, `touch`, `cat`, `cp`, `mv`, `rm` | [01_terminal.md](docs/logs/01_terminal.md) |
| 2 | 권한 | `ls -l` / `ls -ld` → `chmod` → 다시 확인 (파일 644→755, 폴더 755→700) | [02_permission.md](docs/logs/02_permission.md) |
| 3 | Docker 점검 | `docker --version`(설치), `docker info`(엔진 동작) | [03_docker_check.md](docs/logs/03_docker_check.md) |
| 4 | 운영 / 실행 | `pull`, `images`, `run hello-world`, `ps`, `ps -a`, `logs`, `stats`, `stop`, `start`, `exec` | [04_docker_ops.md](docs/logs/04_docker_ops.md) |
| 5 | 커스텀 이미지 + 포트 | `docker build`, `run -p 8080:80`, `run -p 8081:80`, `curl` | [05_build_run.md](docs/logs/05_build_run.md) |
| 6 | 바인드 마운트 | 호스트 파일 Before → After 수정 후 `curl` 비교 | [06_bind_mount.md](docs/logs/06_bind_mount.md) |
| 7 | 볼륨 | 데이터 쓰기 → 컨테이너 삭제 → 새 컨테이너에서 `cat` | [07_volume.md](docs/logs/07_volume.md) |
| 8 | Git | `git config --list`, `git remote -v` | [08_git.md](docs/logs/08_git.md) |
| 9 | (보너스) Compose | `up`, `ps`, `logs`, `down`, 서비스 이름으로 통신 | [09_compose.md](docs/logs/09_compose.md) |

### 6-1. 커스텀 이미지 (방식 A: 웹 서버 베이스 + 정적 콘텐츠 교체)

- 베이스: `nginx:1.27-alpine` (웹 서버가 이미 들어 있고 가벼움, 버전 고정으로 재현성 확보)
- Dockerfile: [app/Dockerfile](app/Dockerfile)

| 커스텀 포인트 | 목적 |
| --- | --- |
| `COPY site/ /usr/share/nginx/html/` | 기본 환영 페이지를 내 페이지로 교체 |
| `ENV APP_ENV=dev` | 실행 모드 설정값 주입 (`printenv` 로 확인) |
| `LABEL ...` | 이미지 설명 메타데이터 (`docker inspect` 로 확인) |
| `HEALTHCHECK` | 10초마다 응답 검사 → `docker ps` 에 (healthy) 표시 |

```bash
cd app
docker build -t my-web:1.0 .
docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
curl http://localhost:8080
```

### 6-2. 포트 매핑 접속 증거 (브라우저, 주소창 포함)

Codespaces는 컨테이너의 `-p 8080:80`, `-p 8081:80` 으로 열린 호스트 포트를 `https://<코드스페이스 이름>-<포트>.app.github.dev` 주소로 전달합니다. 주소창의 `-8080`, `-8081` 이 호스트 포트 번호입니다. 같은 응답을 Codespaces 안에서 `curl http://localhost:8080` 으로도 확인했습니다([05_build_run.md](docs/logs/05_build_run.md)).

![8080 접속](docs/screenshots/port-8080.png)
![8081 접속](docs/screenshots/port-8081.png)

### 6-3. Git / VSCode GitHub 연동 증거

`git config --list` 결과는 [08_git.md](docs/logs/08_git.md) 에 있습니다 (`user.name`, `user.email`, `init.defaultbranch=main`). 아래는 VSCode(Codespaces)에 GitHub 계정으로 로그인된 화면이며, 이 저장소의 커밋과 push도 이 연동으로 수행했습니다.

![VSCode GitHub 연동](docs/screenshots/vscode-github.png)

## 7. 대화형 실습 (스크린샷)

대화형(`-it`) 실습은 스크립트로 자동화할 수 없어서 직접 입력하고 화면을 캡처했습니다.

### 7-1. ubuntu 컨테이너 진입

```bash
docker run -it --name my-ubuntu ubuntu:24.04 bash
# (컨테이너 안) 프롬프트가 root@xxxx:/# 로 바뀜
ls
echo "hello from inside"
exit
```

![ubuntu 진입](docs/screenshots/ubuntu-it.png)

### 7-2. attach vs exec 관찰

```bash
docker start my-ubuntu
docker exec -it my-ubuntu bash    # 새 bash 를 하나 더 열기
exit
docker ps                         # → 여전히 Up

docker attach my-ubuntu           # 메인 bash 에 직접 붙기
exit
docker ps -a                      # → Exited
```

![attach vs exec 1](docs/screenshots/attach-exec-1.png)
![attach vs exec 2](docs/screenshots/attach-exec-2.png)

관찰 결과: exec로 들어갔다 `exit` 한 뒤 `docker ps` 에서 `my-ubuntu` 는 **Up** 이었고, attach로 들어갔다 `exit` 한 뒤 `docker ps -a` 에서는 **Exited (0)** 이었습니다. exec 방식은 [04_docker_ops.md](docs/logs/04_docker_ops.md) 의 `obs-ubuntu` 실험에서도 같은 결과를 확인했습니다.

관찰 정리:

| 방법 | 동작 | exit 후 컨테이너 |
| --- | --- | --- |
| `docker exec -it` | 컨테이너 안에 **새 프로세스**를 추가로 실행 | 계속 실행(Up) |
| `docker attach` | 이미 돌고 있는 **메인 프로세스**에 연결 | 메인 프로세스가 끝나서 종료(Exited) |

컨테이너는 메인 프로세스(PID 1)가 살아 있는 동안만 실행됩니다. attach 상태에서 끄지 않고 나오려면 `Ctrl+P` → `Ctrl+Q`.

## 8. 핵심 개념 정리

**절대 경로 vs 상대 경로**: 절대 경로는 `/` 부터 시작하는 전체 주소라 어디서 실행해도 같은 곳(`/Users/me/codyssey/practice`). 상대 경로는 현재 위치 기준(`./practice`, `../`)이라 현재 위치에 따라 결과가 달라진다.

**권한 r/w/x 와 755, 644**: r=4, w=2, x=1 을 더해 소유자/그룹/그 외 순서로 쓴다. 755 = `rwxr-xr-x`(폴더·실행 파일), 644 = `rw-r--r--`(일반 파일). 폴더의 x 는 "들어갈 수 있는 권한"이다.

**이미지 vs 컨테이너**: 이미지는 읽기 전용 설계도, 컨테이너는 그 이미지를 실행한 것. 한 이미지로 여러 컨테이너를 만들 수 있어 같은 환경이 재현된다.

**포트 매핑이 필요한 이유**: 컨테이너는 격리된 네트워크를 가져서 밖에서 바로 접근할 수 없다. `-p 호스트:컨테이너` 로 호스트 포트를 컨테이너 포트에 연결해야 브라우저에서 접속된다. `EXPOSE` 는 안내일 뿐 실제 연결은 `-p` 가 한다.

**바인드 마운트 vs 볼륨**: 바인드 마운트는 내가 고른 호스트 폴더를 연결해 수정이 즉시 반영된다(개발용). 볼륨은 Docker 가 관리하는 저장소로, 컨테이너를 지워도 데이터가 남는다(영속성).

**Git vs GitHub**: Git 은 내 PC에서 변경 이력을 관리하는 도구(로컬), GitHub 는 Git 저장소를 인터넷에 올려 공유·협업하는 서비스(원격).

## 9. 트러블슈팅

실습 중 실제로 겪은 문제입니다. (문제 → 원인 가설 → 확인 → 해결/대안)

### 9-1. 교육장 PC에서 docker 명령을 찾을 수 없음

- 문제: 경남대 교육장에서 작업하다가 봉암동 교육장으로 옮겨 작업했다. 봉암동 교육장 PC의 PowerShell에서 `docker run ...` 을 실행하자 `'docker' 용어가 cmdlet, 함수, 스크립트 파일 또는 실행할 수 있는 프로그램 이름으로 인식되지 않습니다 (CommandNotFoundException)` 오류가 났다.
- 원인 가설: 이 PC(Windows)에 Docker가 설치되어 있지 않거나, 리눅스 환경(WSL)이 없을 것이다.
- 확인:
  - `PS C:\Users\...` 프롬프트 → Windows PowerShell 환경
  - `docker --version` → 같은 CommandNotFoundException (Docker 미설치)
  - `wsl -l -v` → `Linux용 Windows 하위 시스템 설치되어 있지 않습니다` (WSL 미설치)
- 해결 / 대안:
  - 선택한 방법: **GitHub Codespaces** 로 전환. 설치 없이 브라우저에서 Ubuntu + Docker + VSCode 를 바로 쓸 수 있고, `chmod` 권한 실습도 진짜 리눅스에서 정상 동작한다.
  - 다른 대안: Windows에 Docker Desktop(+ WSL2) 설치. 관리자 권한과 재부팅이 필요할 수 있어 공용 PC에서는 운영진 허가가 필요하다. 또한 Windows 폴더(NTFS)에서는 `chmod` 가 제대로 반영되지 않아 권한 실습은 WSL/컨테이너 안에서 해야 한다.
  - 공용 PC에 WSL 설치 안내가 떴을 때는 `ESC` 로 취소했다(관리자 권한·재부팅 필요).

### 9-2. 대화형 컨테이너에 여러 줄을 붙여 넣었더니 명령이 실행되지 않음

- 문제: `docker run -it --name my-ubuntu ubuntu:24.04 bash` 와 `ls`, `echo`, `exit` 를 한꺼번에 붙여 넣었더니, 프롬프트만 `root@0defc4e8da2c:/#` 로 바뀌고 `ls`, `echo` 결과가 나오지 않았다.
- 원인 가설: 컨테이너의 bash 가 준비되기 **전에** 나머지 줄이 입력되어 컨테이너 안으로 전달되지 않았다.
- 확인: 컨테이너 프롬프트에서 `ls` 를 한 줄씩 다시 입력하자 `bin boot dev etc ...` 목록이 정상 출력됐다.
- 해결 / 대안: 대화형(`-it`) 컨테이너에서는 프롬프트가 바뀐 것을 확인한 뒤 **한 줄씩** 입력한다. 여러 명령을 한 번에 실행하려면 비대화형으로 `docker run --rm ubuntu:24.04 bash -c 'ls && echo hi'` 처럼 쓴다.

### 9-3. 공용 PC 폴더에서 push 하자 403 거부 (다른 사람 저장소·계정)

- 문제: 교육장 PC 바탕화면 폴더에서 커밋 후 `git push` 하자 `remote: Permission to vlfgl/M1-1.git denied to love4xox.` / `error: 403` 이 났다. 그래서 Codespaces에는 `README.md` 만 있었다(`ls` 결과).
- 원인 가설: 그 폴더가 내 저장소가 아니라 이전 사용자의 저장소에 연결되어 있고, PC에 다른 사람의 GitHub 로그인이 남아 있다.
- 확인: 오류 메시지에 내 저장소(`ilililililil4319/E1-1`)가 아닌 `vlfgl/M1-1` 과 다른 계정(`love4xox`)이 표시됨.
- 해결 / 대안: 그 폴더의 커밋은 `git reset HEAD~1` 로 되돌리고 더 이상 사용하지 않았다. 내 GitHub 계정으로 연결된 Codespaces에 파일을 직접 올려 커밋·push 했다. 공용 PC를 쓸 때는 `git remote -v` 로 연결된 저장소를 먼저 확인하고, 작업 후 로그아웃해야 한다.

### 9-4. 스크린샷 파일 이름이 `port-8080.png.png` 로 저장됨

- 문제: README 에서 `port-8080.png` 이미지가 보이지 않았다.
- 원인 가설: 저장할 때 이름에 `.png` 를 직접 쓰면서 확장자가 두 번 붙었다.
- 확인: 탐색기에서 `port-8080.png.png` 로 표시됨.
- 해결 / 대안: `mv docs/screenshots/port-8080.png.png docs/screenshots/port-8080.png` 로 이름을 바꿨다.

## 10. 보안 / 개인정보

- 로그 스크립트는 `ghp_...` 같은 GitHub 토큰과 password/token/secret 줄을 자동으로 `****` 처리합니다 ([scripts/lib.sh](scripts/lib.sh)).
- 스크린샷의 이메일, 토큰, 인증 코드는 업로드 전에 가립니다.
- `.gitignore` 로 `.env`, 키 파일(`*.pem`, `id_ed25519*`)이 올라가지 않게 막았습니다.
- 민감 정보가 올라간 경우: 파일과 Git 기록에서 제거하고 해당 토큰/키를 폐기 후 재발급합니다.
- 공용 PC 사용 후에는 GitHub 로그아웃 및 자격 증명을 삭제합니다 ([SETUP.md 1-7](docs/SETUP.md#1-7-공용-pc-떠나기-전-정리-중요-보안)).
