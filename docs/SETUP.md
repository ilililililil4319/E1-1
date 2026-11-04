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

### Windows

스크립트가 bash 용이므로 **WSL2(Ubuntu)** 를 권장합니다.

1. PowerShell(관리자)에서 `wsl --install` → 재부팅 → Ubuntu 사용자 만들기
2. **Docker Desktop** 설치 → Settings → Resources → WSL Integration 에서 Ubuntu 켜기
3. Ubuntu 터미널에서:

```bash
sudo apt update && sudo apt install -y git curl
docker --version && docker info | head -5
```

4. VSCode 설치 + 확장 **WSL** 설치 → Ubuntu 터미널에서 `code .` 로 열기
5. 그다음은 **1-3 ~ 1-6** 과 같음 (clone 은 Ubuntu 안의 `~/codyssey` 에)

> Git Bash 로 할 경우: 바인드 마운트 경로가 바뀌는 문제가 있어 먼저 `export MSYS_NO_PATHCONV=1` 을 실행하세요.

### 이어서 작업할 때

```bash
cd ~/codyssey/E1-1
git pull                 # 공용 PC에서 올린 내용 받기
# ... 작업 ...
git add . && git commit -m "작업 내용" && git push
```

로그(`docs/logs/*.md`)는 스크립트를 다시 돌리면 **그 PC 기준으로 덮어써집니다.**
README 의 실행 환경 표는 최종 제출할 로그를 만든 PC 기준으로 맞춰 주세요.
