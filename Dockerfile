# check=skip=SecretsUsedInArgOrEnv
# PORTFOLIO_AUTH_MODE is a public branch contract, not a credential.
FROM node:22-alpine AS builder

WORKDIR /app

ARG PORTFOLIO_BRANCH
ARG PORTFOLIO_AUTH_MODE
COPY scripts/portfolio-auth-mode.sh /usr/local/bin/portfolio-auth-mode
RUN chmod 755 /usr/local/bin/portfolio-auth-mode \
    && /usr/local/bin/portfolio-auth-mode check

COPY frontend/indiv/package*.json ./
RUN npm ci

COPY frontend/indiv/ ./
RUN npm run build

FROM nginx:1.27-alpine

ARG PORTFOLIO_BRANCH
ARG PORTFOLIO_AUTH_MODE
ENV PORTFOLIO_BRANCH=${PORTFOLIO_BRANCH} \
    PORTFOLIO_AUTH_MODE=${PORTFOLIO_AUTH_MODE}
LABEL work.bonifacio.portfolio.branch=${PORTFOLIO_BRANCH} \
      work.bonifacio.portfolio.auth-mode=${PORTFOLIO_AUTH_MODE}

RUN printf '%s\n%s\n' "$PORTFOLIO_BRANCH" "$PORTFOLIO_AUTH_MODE" \
      > /etc/portfolio-auth-build \
    && chmod 0444 /etc/portfolio-auth-build

COPY scripts/portfolio-auth-mode.sh /usr/local/bin/portfolio-auth-mode
RUN chmod 755 /usr/local/bin/portfolio-auth-mode
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/portfolio-auth-mode", "exec", "--", "/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
