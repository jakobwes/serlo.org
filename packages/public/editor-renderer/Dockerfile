FROM node:10 as base
#ENV NODE_ENV production
WORKDIR /usr/src/app

FROM base as dependencies
COPY packages/private/legacy-editor-to-editor/package.json packages/private/legacy-editor-to-editor/
COPY packages/private/markdown/package.json packages/private/markdown/
COPY packages/private/editor-helpers/package.json packages/private/editor-helpers/
COPY packages/public/editor-renderer/package.json packages/public/editor-renderer/
COPY package.json .
COPY yarn.lock .
COPY babel.config.js .

#FROM base as dependencies
RUN yarn install --frozen-lockfile

#FROM dependencies as release
COPY packages/private/legacy-editor-to-editor packages/private/legacy-editor-to-editor/
COPY packages/private/markdown packages/private/markdown/
COPY packages/private/editor-helpers packages/private/editor-helpers/
COPY packages/public/editor-renderer packages/public/editor-renderer/

WORKDIR /usr/src/app/packages/private/legacy-editor-to-editor
RUN yarn run build

WORKDIR /usr/src/app/packages/private/markdown
RUN yarn run build

WORKDIR /usr/src/app/packages/private/editor-helpers
RUN yarn run build

WORKDIR /usr/src/app/packages/public/editor-renderer
RUN yarn run build:babel

FROM node:10-alpine as runtime

WORKDIR /usr/src/app
ENV NODE_ENV production

COPY --from=0 /usr/src/app/node_modules node_modules/
COPY --from=0 /usr/src/app/packages packages/
COPY --from=0 /usr/src/app/package.json package.json

WORKDIR /usr/src/app/packages/public/editor-renderer

ENTRYPOINT node .
EXPOSE 3000
