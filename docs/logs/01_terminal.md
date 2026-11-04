# 터미널 조작 로그

- 실행 시각: 2026-11-04 07:53:34
- 생성: `scripts/01_terminal.sh` 실행 결과 (명령 + 출력 자동 기록)

## 1. 현재 위치 확인

```bash
$ cd ~
$ pwd
/home/codespace
```

## 2. 폴더 생성 (중간 폴더까지 한 번에: -p)

```bash
$ mkdir -p ~/codyssey/practice
```

## 3. 이동 - 절대 경로

절대 경로: 루트(/)부터 시작하는 전체 주소라 어디서 실행해도 같은 곳으로 간다.

```bash
$ cd /home/codespace/codyssey/practice
$ pwd
/home/codespace/codyssey/practice
```

## 4. 이동 - 상대 경로

상대 경로: 현재 위치 기준. .. = 한 칸 위, . = 현재 폴더

```bash
$ cd ..
$ pwd
/home/codespace/codyssey
$ cd ./practice
$ pwd
/home/codespace/codyssey/practice
```

## 5. 빈 파일 생성 / 목록 확인 (숨김 파일 포함)

```bash
$ touch empty.txt
$ touch .hidden_file
$ ls -la
total 8
drwxr-xr-x 2 codespace codespace 4096 Nov  4 07:53 .
drwxr-xr-x 3 codespace codespace 4096 Nov  4 07:53 ..
-rw-r--r-- 1 codespace codespace    0 Nov  4 07:53 .hidden_file
-rw-r--r-- 1 codespace codespace    0 Nov  4 07:53 empty.txt
```

## 6. 파일에 내용 쓰기 / 내용 확인

```bash
$ echo "hello codyssey" > hello.txt
$ echo "second line" >> hello.txt
$ cat hello.txt
hello codyssey
second line
```

## 7. 하위 폴더 생성 후 복사

```bash
$ mkdir backup
$ cp hello.txt backup/hello_copy.txt
$ ls -la backup
total 12
drwxr-xr-x 2 codespace codespace 4096 Nov  4 07:53 .
drwxr-xr-x 3 codespace codespace 4096 Nov  4 07:53 ..
-rw-r--r-- 1 codespace codespace   27 Nov  4 07:53 hello_copy.txt
```

## 8. 이동 / 이름 변경

```bash
$ mv backup/hello_copy.txt backup/hello_renamed.txt
$ mv empty.txt backup/
$ ls -la backup
total 12
drwxr-xr-x 2 codespace codespace 4096 Nov  4 07:53 .
drwxr-xr-x 3 codespace codespace 4096 Nov  4 07:53 ..
-rw-r--r-- 1 codespace codespace    0 Nov  4 07:53 empty.txt
-rw-r--r-- 1 codespace codespace   27 Nov  4 07:53 hello_renamed.txt
```

## 9. 삭제

```bash
$ rm backup/hello_renamed.txt
$ rm backup/empty.txt
$ rmdir backup
$ ls -la
total 12
drwxr-xr-x 2 codespace codespace 4096 Nov  4 07:53 .
drwxr-xr-x 3 codespace codespace 4096 Nov  4 07:53 ..
-rw-r--r-- 1 codespace codespace    0 Nov  4 07:53 .hidden_file
-rw-r--r-- 1 codespace codespace   27 Nov  4 07:53 hello.txt
```

