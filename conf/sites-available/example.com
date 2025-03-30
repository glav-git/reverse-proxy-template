server {
    server_name example.com;

    location / {
         proxy_pass             http://host.docker.internal:9999;
         proxy_read_timeout     600;
         proxy_connect_timeout  600;
         proxy_redirect         off;

         # Allow the use of websockets
         proxy_http_version 1.1;
         proxy_set_header Upgrade $http_upgrade;
         proxy_set_header Connection 'upgrade';
         proxy_set_header Host $host;
         proxy_cache_bypass $http_upgrade;
    }

    http2 on;
    listen 443 ssl;
    listen [::]:443 ssl;

    # fullchain contains main certificate first and any intermidiate
    # (like Cloudflare Origin CA root certificate) should be concatinated after
    ssl_certificate /etc/cert/$server_name/fullchain.pem;
    ssl_certificate_key /etc/cert/$server_name/private.pem;
    # using of mTLS when proxied by cloudflare
    ssl_client_certificate  /etc/cert/cloudflare/authenticated_origin_pull_ca.pem;
    ssl_verify_client on;

    include /etc/nginx/ssl-options-nginx.conf;
}

server {
    server_name example.com;

    if ($host = $server_name) {
        return 301 https://$host$request_uri;
    }

    listen 80;
    listen [::]:80;
    return 404;
}
