# 환경 세팅 가이드 (교육장 공용 PC / 집 PC)

이 저장소는 **어느 PC에서든 clone → 스크립트 실행 → push** 만으로 같은 결과가 나오도록 만들었습니다.
작업 PC가 바뀌어도 GitHub 저장소가 "원본"입니다. 작업 전엔 `git pull`, 작업 후엔 `git push` 를 꼭 하세요.

---

## 1. 교육장 공용 PC (macOS + OrbStack, sudo 불가)

### 1-1. 준비물 확인

터미널(Terminal 앱 또는 iTerm)을 열고:

```bash
git --version          # Git 이 있는지
code --version         # VSCode 명령이 있는지 (없어도 VSCode 앱만 있으면 됨)
```

### 1-2. OrbStack 실행 → Docker 확인

1. Launchpad/응용 프로그램에서 **OrbStack** 실행 (상단 메뉴바에 아이콘이 생기면 OK)
2. 터미널에서:

```bash
docker --version
docker info | head -20     # Server: 정보가 나오면 엔진 동작 중
```

`Cannot connect to the Docker daemon` 이 나오면 OrbStack 이 아직 안 켜진 것 → 앱 실행 후 10초 뒤 재시도.

### 1-3. Git 사용자 설정

```bash
git config --global user.name "내 이름"
git config --global user.email "GitHub 가입 이메일"
git config --global init.defaultBranch main
```

### 1-4. VSCode 로 GitHub 로그인 + 저장소 clone

1. VSCode 실행 → 왼쪽 아래 **계정(사람) 아이콘** → `Sign in with GitHub` → 브라우저에서 승인
2. `Cmd + Shift + P` → `Git: Clone` → `Clone from GitHub` → `ilililililil4319/E1-1` 선택
3. 저장 위치는 `~/codyssey` 처럼 기억하기 쉬운 곳
4. 이 상태(계정 로그인 + 소스 제어 탭)를 **스크린샷** → `docs/screenshots/vscode-github.png`
   (이메일·토큰 등은 가리기)

터미널로 clone 하고 싶다면:

```bash
mkdir -p ~/codyssey && cd ~/codyssey
git clone https://github.com/ilililililil4319/E1-1.git
cd E1-1
```

### 1-5. 실습 실행

```bash
cd ~/codyssey/E1-1
./scripts/run_all.sh                          # 00~07 자동 실행 + 로그 저장
./scripts/08_git.sh                           # Git 설정 확인 로그
./scripts/09_compose.sh                       # (보너스) Compose
```

그다음 README 의 **"직접 해야 하는 실습"** (ubuntu 진입, attach/exec, 브라우저 스크린샷)을 진행합니다.

### 1-6. 올리기

```bash
git add .
git commit -m "실습 로그 및 스크린샷 추가"
git push
```

### 1-7. 공용 PC 떠나기 전 정리 (중요: 보안)

공용 PC에는 내 GitHub 로그인이 남으면 안 됩니다.

1. VSCode 왼쪽 아래 계정 아이콘 → GitHub 계정 → **Sign Out**
2. 키체인에 저장된 GitHub 비밀번호/토큰 삭제:

```bash
printf "protocol=https\nhost=github.com\n\n" | git credential-osxkeychain erase
```

3. Git 사용자 정보 지우기 (다음 사람이 내 이름으로 커밋하지 않게):

```bash
git config --global --unset user.name
git config --global --unset user.email
```

4. 실습 컨테이너/폴더 정리 (선택):

```bash
docker rm -f $(docker ps -aq) 2>/dev/null
rm -rf ~/codyssey
```

---

## 2. 집 PC

### macOS

- Docker: **OrbStack** 또는 **Docker Desktop** 설치 → 실행
- Git: 터미널에서 `git --version` 실행 시 설치 안내가 뜨면 설치(Xcode Command Line Tools)
- VSCode 설치
- 그다음은 위 **1-3 ~ 1-6** 과 같음

### Windows (WSL2 + Docker Desktop) — 처음부터 순서대로

스크립트가 리눅스(bash)용이고, Windows 폴더에서는 `chmod` 가 동작하지 않으므로 **WSL2(Windows 안의 Ubuntu)** 에서 작업합니다.
📸 표시가 있는 단계는 스크린샷을 찍어 `docs/screenshots/` 에 같은 이름으로 저장합니다.

#### W1. WSL2 + Ubuntu 설치

1. 시작 메뉴에서 **PowerShell** 을 마우스 오른쪽 클릭 → **관리자 권한으로 실행**
2. `wsl --install` 입력 → 끝나면 **재부팅**
3. 재부팅 후 Ubuntu 창이 자동으로 열리면 사용자 이름(영문 소문자)과 비밀번호를 만든다
   (비밀번호는 입력해도 화면에 안 보이는 것이 정상)
4. 시작 메뉴에서 **Ubuntu** 를 열 수 있으면 성공

#### W2. Docker Desktop 설치

1. https://www.docker.com/products/docker-desktop/ → **Download for Windows** → 설치 파일 실행
2. 설치 옵션에서 **Use WSL 2 instead of Hyper-V** 체크 유지 → 설치 → (요청 시) 재부팅
3. Docker Desktop 실행 → 약관 동의 → 로그인은 **Skip** 해도 됨
4. 톱니바퀴(Settings) → **Resources → WSL integration** → `Ubuntu` 켜기 → **Apply & restart**
5. 📸 `docker-desktop.png`: Docker Desktop 창(왼쪽 아래 `Engine running` 이 보이게)

#### W3. Ubuntu 에서 Docker 확인

Ubuntu 창(또는 VSCode 의 WSL 터미널)에서:

```bash
docker --version
docker info | head -20
```

📸 `docker-check.png`: 두 명령과 결과(`Server:` 부분 포함)

#### W4. Git 설정 (Ubuntu 안은 Windows 와 별개라 다시 설정)

```bash
git config --global user.name "ilililililil4319"
git config --global user.email "jlhk722@naver.com"
git config --global init.defaultBranch main
```

#### W5. SSH 키 등록 (보너스 5)

```bash
ssh-keygen -t ed25519 -C "jlhk722@naver.com"   # Enter 3번 (기본 위치, 암호 없음)
cat ~/.ssh/id_ed25519.pub                       # 공개키 출력 → 전체 복사
```

1. GitHub → 오른쪽 위 프로필 → **Settings → SSH and GPG keys → New SSH key**
2. Title: `home-pc-wsl`, Key: 복사한 공개키(`ssh-ed25519 ...`) 붙여넣기 → **Add SSH key**
3. 연결 확인:

```bash
ssh -T git@github.com     # 처음 한 번 yes 입력
```

`Hi ilililililil4319! You've successfully authenticated` 가 나오면 성공.
📸 `ssh-github.png`: `ssh -T` 명령과 성공 메시지
⚠️ `id_ed25519`(`.pub` 없는 파일)는 **개인키** 이므로 절대 출력·공유·업로드하지 않는다.

#### W6. 저장소 clone (SSH 주소로, Ubuntu 홈 폴더에)

```bash
mkdir -p ~/codyssey && cd ~/codyssey
git clone git@github.com:ilililililil4319/E1-1.git
cd E1-1
git remote -v              # git@github.com:... 이면 SSH 연결
```

> `/mnt/c/...`(Windows 폴더) 가 아니라 `~`(Ubuntu 폴더) 에 받아야 권한 실습과 바인드 마운트가 정상 동작한다.

#### W7. VSCode 연결 + GitHub 로그인

1. Windows 에 VSCode 설치 → 확장(Extensions)에서 **WSL** 설치
2. Ubuntu 터미널의 `~/codyssey/E1-1` 에서 `code .` → VSCode 가 열리고 왼쪽 아래에 `WSL: Ubuntu` 표시
3. 왼쪽 아래 사람 아이콘 → **GitHub 로 로그인**
4. 📸 `vscode-github.png`: 계정 메뉴에 `(GitHub)` 가 보이는 화면 (왼쪽 아래 `WSL: Ubuntu` 도 보이면 더 좋음)

이후 명령은 VSCode 아래 터미널(`` Ctrl + ` ``)에서 실행한다.

#### W8. 실습 실행

```bash
bash scripts/run_all.sh                                   # 00~07
bash scripts/08_git.sh "ilililililil4319" "jlhk722@naver.com"
```

마지막에 `완료!` 가 나오면 성공. `[중단]` 이 나오면 그 앞 10줄을 확인한다.

#### W9. 포트 매핑 접속 (Windows 브라우저)

`run_all.sh` 가 끝나도 웹 서버 2개는 계속 켜져 있다.

- 📸 `port-8080.png`: 브라우저 주소창에 `http://localhost:8080` (주소창 + 페이지)
- 📸 `port-8081.png`: `http://localhost:8081`

#### W10. 대화형 실습 (한 줄씩 입력)

```bash
docker run -it --name my-ubuntu ubuntu:24.04 bash
ls
echo "hello from inside"
exit
```

📸 `ubuntu-it.png`

```bash
docker start my-ubuntu
docker exec -it my-ubuntu bash
exit
docker ps
```

📸 `attach-exec-1.png` (exec 후 `docker ps` 에서 **Up**)

```bash
docker attach my-ubuntu        # 화면이 멈추면 Enter
exit
docker ps -a
```

📸 `attach-exec-2.png` (attach 후 `docker ps -a` 에서 **Exited**)

#### W11. 보너스 Compose

```bash
bash scripts/09_compose.sh
```

#### W12. 스크린샷 넣고 올리기

1. 스크린샷 9장을 VSCode 왼쪽 탐색기의 `docs/screenshots` 에 끌어다 놓는다 (같은 이름이면 덮어쓰기)
2. 커밋·push (SSH 로 올라감):

```bash
ls docs/screenshots
git add .
git commit -m "집 PC(WSL2 + Docker Desktop)에서 전체 실습 재수행"
git push
```

| 📸 파일 이름 | 내용 |
|---|---|
| `docker-desktop.png` | Docker Desktop 실행 (Engine running) |
| `docker-check.png` | `docker --version`, `docker info` |
| `ssh-github.png` | `ssh -T git@github.com` 성공 |
| `vscode-github.png` | VSCode GitHub 로그인 |
| `port-8080.png` | 브라우저 `localhost:8080` |
| `port-8081.png` | 브라우저 `localhost:8081` |
| `ubuntu-it.png` | ubuntu 진입 `ls`, `echo` |
| `attach-exec-1.png` | exec 후 Up |
| `attach-exec-2.png` | attach 후 Exited |

> Git Bash 로 할 경우: 바인드 마운트 경로가 바뀌는 문제가 있어 먼저 `export MSYS_NO_PATHCONV=1` 을 실행해야 하며, 권한 실습은 정상 동작하지 않는다. WSL2 를 권장한다.

### 이어서 작업할 때

```bash
cd ~/codyssey/E1-1
git pull                 # 공용 PC에서 올린 내용 받기
# ... 작업 ...
git add . && git commit -m "작업 내용" && git push
```

로그(`docs/logs/*.md`)는 스크립트를 다시 돌리면 **그 PC 기준으로 덮어써집니다.**
README 의 실행 환경 표는 최종 제출할 로그를 만든 PC 기준으로 맞춰 주세요.
