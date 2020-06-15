# Stage 0, "build-stage", based on Node.js, to build and compile Angular
FROM tiangolo/node-frontend:10 as build-stage
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY ./ /app/
ARG configuration=production
ARG baseHref="/loadfile/"
RUN pwd
RUN npm run build -- --output-path=./dist/out --base-href $baseHref --configuration $configuration
# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:alpine
COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html/
COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf
