# ------------------------------------------------------------
# 방식 (A): 웹 서버 베이스 이미지(NGINX) + 정적 콘텐츠 교체
# ------------------------------------------------------------

# [베이스] 공식 NGINX 이미지(alpine 버전 = 작고 가벼움)
# 태그를 1.27 로 고정 → 언제 빌드해도 같은 버전 (재현성)
FROM nginx:1.27-alpine

# [커스텀 1] LABEL: 이미지에 붙이는 설명 메모 (docker inspect 로 확인 가능)
LABEL org.opencontainers.image.title="e1-1-my-web" \
      org.opencontainers.image.description="Codyssey E1-1 custom nginx image"

# [커스텀 2] ENV: 환경 변수(설정값). 실행 모드를 표시
ENV APP_ENV=dev

# [커스텀 3] COPY: 기본 NGINX 환영 페이지 대신 내 웹페이지로 교체
COPY site/ /usr/share/nginx/html/

# [안내] 이 컨테이너는 80번 포트를 사용 (실제 연결은 docker run -p 가 함)
EXPOSE 80

# [커스텀 4] HEALTHCHECK: 10초마다 웹페이지가 응답하는지 검사
#            docker ps 의 STATUS 에 (healthy) 로 표시됨
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1
