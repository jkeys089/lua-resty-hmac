FROM openresty/openresty:stretch-fat

WORKDIR /app

RUN apt-get update && apt-get install -y make cpanminus && cpanm -n Test::Nginx && apt-get clean
