# Etap 1: Budowanie aplikacji
FROM alpine AS builder

# Definiowanie zmiennej wersji aplikacji
ARG VERSION="1.0.0"

# Instalacja narzędzi potrzebnych do generowania pliku HTML
RUN apk add --no-cache bash coreutils

# Tworzenie katalogu dla aplikacji
WORKDIR /app

# Generowanie dynamicznego pliku HTML z danymi systemowymi
RUN echo "<html><head><meta charset='UTF-8'><title>Info</title></head><body>" > /app/index.html && \
    echo "<h2>Adres IP serwera: $(hostname -i)</h2>" >> /app/index.html && \
    echo "<h2>Nazwa serwera: $(hostname)</h2>" >> /app/index.html && \
    echo "<h2>Wersja aplikacji: ${VERSION}</h2>" >> /app/index.html && \
    echo "</body></html>" >> /app/index.html

# Etap 2: Serwer HTTP
FROM nginx

# Skopiowanie statycznego pliku HTML wygenerowanego w pierwszym etapie
COPY --from=builder /app/index.html /usr/share/nginx/html/index.html

# Sprawdzenie poprawności działania aplikacji
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost || exit 1
