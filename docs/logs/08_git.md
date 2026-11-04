# Git 설정 / GitHub 연동 로그

- 실행 시각: 2026-11-04 08:35:01
- 생성: `scripts/08_git.sh` 실행 결과 (명령 + 출력 자동 기록)

## 1. 설정

```bash
$ git --version
git version 2.56.0
$ git config --global user.name "ilililililil4319"
$ git config --global user.email "jlhk722@naver.com"
$ git config --global init.defaultBranch main
```

## 2. 설정 확인

```bash
$ git config --list
user.name=ilililililil4319
user.email=jlhk722@naver.com
gpg.program=/.codespaces/bin/gh-gpgsign
init.defaultbranch=main
credential.helper=/.codespaces/bin/gitcredential_github.sh
filter.lfs.process=git-lfs filter-process
filter.lfs.required=true
filter.lfs.clean=git-lfs clean -- %f
filter.lfs.smudge=git-lfs smudge -- %f
user.name=ilililililil4319
user.email=jlhk722@naver.com
init.defaultbranch=main
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
remote.origin.url=https://github.com/ilililililil4319/E1-1
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.main.remote=origin
branch.main.merge=refs/heads/main
lfs.repositoryformatversion=0
lfs.https://github.com/ilililililil4319/E1-1.git/info/lfs.access=basic
```

## 3. 저장소 연동 확인

```bash
$ cd /workspaces/E1-1
$ git remote -v
origin	https://github.com/ilililililil4319/E1-1 (fetch)
origin	https://github.com/ilililililil4319/E1-1 (push)
$ git branch
* main
$ git log --oneline -5
dde1933 실습 로그 추가 (run_all.sh)
6412c17 과제 폴더 구조 및 실습 스크립트 구성
750d48c Initial commit
```

VSCode GitHub 로그인 화면 스크린샷을 docs/screenshots/ 에 저장 (이메일·토큰은 가리기)

