# 권한 실습 로그

- 실행 시각: 2026-11-05 14:42:08
- 생성: `scripts/02_permission.sh` 실행 결과 (명령 + 출력 자동 기록)

```bash
$ mkdir -p ~/codyssey/practice && cd ~/codyssey/practice
$ rm -rf perm_file.txt perm_dir
```

## 1. 파일 권한: 644 → 755

```bash
$ echo "permission test" > perm_file.txt
$ chmod 644 perm_file.txt
```

변경 전: 644 = rw-r--r-- (소유자 읽기/쓰기, 나머지 읽기만)

```bash
$ ls -l perm_file.txt
-rw-r--r-- 1 ilililililil4319 ilililililil4319 16 Nov  5 14:42 perm_file.txt
$ chmod 755 perm_file.txt
```

변경 후: 755 = rwxr-xr-x (소유자 전부, 나머지 읽기/실행)

```bash
$ ls -l perm_file.txt
-rwxr-xr-x 1 ilililililil4319 ilililililil4319 16 Nov  5 14:42 perm_file.txt
```

## 2. 디렉토리 권한: 755 → 700

```bash
$ mkdir perm_dir
$ chmod 755 perm_dir
```

변경 전: 755 = drwxr-xr-x (맨 앞 d = 디렉토리, -d 옵션 = 폴더 자체 권한 보기)

```bash
$ ls -ld perm_dir
drwxr-xr-x 2 ilililililil4319 ilililililil4319 4096 Nov  5 14:42 perm_dir
$ chmod 700 perm_dir
```

변경 후: 700 = drwx------ (소유자만 모든 권한, 다른 사람은 아무것도 못 함)

```bash
$ ls -ld perm_dir
drwx------ 2 ilililililil4319 ilililililil4319 4096 Nov  5 14:42 perm_dir
```

## 3. 실험: 디렉토리의 x(실행) 권한을 빼면?

디렉토리의 x = 안으로 들어갈(cd) 수 있는 권한

```bash
$ chmod 600 perm_dir
$ ls -ld perm_dir
drw------- 2 ilililililil4319 ilililililil4319 4096 Nov  5 14:42 perm_dir
$ cd perm_dir
./lib.sh: line 56: cd: perm_dir: Permission denied
```

→ Permission denied: x 가 없어서 들어갈 수 없다. (root/관리자 계정은 권한을 무시하므로 들어가질 수 있음)

```bash
$ chmod 755 perm_dir
$ cd perm_dir && pwd && cd ..
/home/ilililililil4319/codyssey/practice/perm_dir
```

## 4. 문자 방식 chmod

```bash
$ chmod u-x,g-x,o-x perm_file.txt
$ ls -l perm_file.txt
-rw-r--r-- 1 ilililililil4319 ilililililil4319 16 Nov  5 14:42 perm_file.txt
```

u=소유자, g=그룹, o=그 외 / + 추가, - 제거

