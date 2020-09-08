# develop stage
FROM dvillace/vue-cli as develop-stage
WORKDIR /app
COPY package*.json ./
#RUN yarn install
RUN npm install
COPY . .

# build stage
FROM develop-stage as build-stage
#RUN yarn build
RUN npm run build

# production stage
FROM nginx:latest as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

