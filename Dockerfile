FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/le0pard/pgtune.git && \
    cd pgtune && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node:24-alpine AS build

WORKDIR /pgtune
COPY --from=base /git/pgtune .
RUN yarn --frozen-lockfile && \
    yarn build

FROM joseluisq/static-web-server

COPY --from=build /pgtune/dist ./public
