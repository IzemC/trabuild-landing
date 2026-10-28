# Build stage - Flutter web
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Copy pubspec files (pubspec.lock is committed, so versions stay pinned)
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# The API base URL the web app calls. The default is relative, so requests go
# to this container's nginx, which proxies them to BACKEND_ORIGIN.
# Set an absolute URL instead if you do not want the proxy.
ARG API_URL=/api/v1

# Build for web (release)
RUN flutter build web --release --dart-define=API_URL=$API_URL

# Production stage - serve with nginx
FROM nginx:alpine AS runner

# Where nginx sends /api/ requests. Override at run time.
ENV BACKEND_ORIGIN=http://backend:3000

# Substitute only BACKEND_ORIGIN, so nginx variables such as $uri stay intact
ENV NGINX_ENVSUBST_FILTER=BACKEND_ORIGIN

# nginx renders this template into /etc/nginx/conf.d/default.conf at startup
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template

# Copy built files
COPY --from=builder /app/build/web /usr/share/nginx/html

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
