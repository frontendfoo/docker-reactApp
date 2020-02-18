# build environment
FROM node:13.8.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY . /app
RUN apk add --no-cache --virtual .gyp \
  python \
  make \
  g++
RUN npm ci
RUN npm run build

# production environment
FROM nginx:1.16.0-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
