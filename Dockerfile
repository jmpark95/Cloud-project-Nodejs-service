ARG NODE_VERSION=18.17.1
FROM node:${NODE_VERSION}-alpine
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --omit=dev
USER node
COPY . .
EXPOSE 8080
CMD npm start
