# Git 설정 / GitHub 연동 로그

- 실행 시각: 2026-11-05 14:45:11
- 생성: `scripts/08_git.sh` 실행 결과 (명령 + 출력 자동 기록)

## 1. 설정

```bash
$ git --version
git version 2.53.0
$ git config --global user.name "ilililililil4319"
$ git config --global user.email "jlhk722@naver.com"
$ git config --global init.defaultBranch main
```

## 2. 설정 확인

```bash
$ git config --list
user.name=ilililililil4319
user.email=jlhk722@naver.com
init.defaultbranch=main
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
remote.origin.url=git@github.com:ilililililil4319/E1-1.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.main.remote=origin
branch.main.merge=refs/heads/main
branch.main.vscode-merge-base=origin/main
```

## 3. 저장소 연동 확인

```bash
$ cd /home/ilililililil4319/codyssey/E1-1
$ git remote -v
origin	git@github.com:ilililililil4319/E1-1.git (fetch)
origin	git@github.com:ilililililil4319/E1-1.git (push)
$ git branch
* main
$ git log --oneline -5
119e860 SSH 연결 확인 스크린샷 추가 (아이디 마스킹)
69c6003 Docker 확인 스크린샷, SSH 키 생성 트러블슈팅 스크린샷 추가 (개인정보 마스킹)
9e1afcc Docker Desktop 설치 스크린샷 추가
1c88bed README 상단 링크 줄바꿈, 클라우드 환경 관련 설명 정리
026342e 작업 흐름도 3줄로 변경, Windows 가이드 링크 추가
```

VSCode GitHub 로그인 화면 스크린샷을 docs/screenshots/ 에 저장 (이메일·토큰은 가리기)

