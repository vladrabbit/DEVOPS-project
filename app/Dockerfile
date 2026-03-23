FROM nginx:alpine

# Metadata
LABEL org.opencontainers.image.title="DevOps Test App"
LABEL org.opencontainers.image.description="Test application for DevOps project"
LABEL org.opencontainers.image.source="https://github.com/YOUR_USERNAME/DEVOPS_project"

# Build arguments
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.version=$VERSION

COPY index.html /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]