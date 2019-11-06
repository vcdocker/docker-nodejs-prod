FROM node:12.7-alpine

LABEL Maintainer="Hieupv <hieupv@codersvn.com>" \
  Description="Lightweight container for nodejs application on Alpine Linux."

# Install packages
RUN apk --no-cache add curl bash supervisor

# Configure supervisord
ADD ./.docker/supervisor/master.ini /etc/supervisor.d/
ADD ./.docker/nginx/nginx.conf /etc/nginx/nginx.conf

ENV NODE_ENV=production

WORKDIR /var/www/app

COPY package*.json ./

RUN sed -i '/\@vicoders\/generator/d' ./package.json

RUN yarn install

COPY . .

RUN yarn build

RUN rm -rf app && rm -rf node_modules

RUN yarn install --prod

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord"]


