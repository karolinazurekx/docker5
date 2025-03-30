
FROM alpine AS builder


ARG VERSION="1.0.0"

RUN apk add --no-cache bash coreutils


WORKDIR /app


RUN echo "<html><head><meta charset='UTF-8'><title>Info</title></head><body>" > /app/index.html && \
    echo "<h2>Adres IP serwera: $(hostname -i)</h2>" >> /app/index.html && \
    echo "<h2>Nazwa serwera: $(hostname)</h2>" >> /app/index.html && \
    echo "<h2>Wersja aplikacji: ${VERSION}</h2>" >> /app/index.html && \
    echo "</body></html>" >> /app/index.html


FROM nginx


COPY --from=builder /app/index.html /usr/share/nginx/html/index.html


HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost || exit 1
