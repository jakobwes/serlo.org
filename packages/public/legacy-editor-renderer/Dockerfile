FROM node:10 as base
#ENV NODE_ENV production
WORKDIR /usr/src/app

FROM base as dependencies
COPY packages/public/legacy-editor-renderer/package.json packages/public/legacy-editor-renderer/
COPY packages/private/markdown/package.json packages/private/markdown/
COPY package.json .
COPY yarn.lock .
COPY babel.config.js .

#FROM base as dependencies
RUN yarn install --frozen-lockfile

#FROM dependencies as release
COPY packages/public/legacy-editor-renderer packages/public/legacy-editor-renderer
COPY packages/private/markdown packages/private/markdown

WORKDIR /usr/src/app/packages/private/markdown
RUN yarn install && yarn run build

WORKDIR /usr/src/app/packages/public/legacy-editor-renderer
RUN yarn install && yarn run build:babel

FROM node:10-alpine as runtime

WORKDIR /usr/src/app
ENV NODE_ENV production

COPY --from=0 /usr/src/app/node_modules node_modules/
COPY --from=0 /usr/src/app/packages packages/
COPY --from=0 /usr/src/app/package.json package.json

WORKDIR /usr/src/app/packages/public/legacy-editor-renderer

ENTRYPOINT node .
EXPOSE 3000
