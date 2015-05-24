ssl_certificate_key /var/ssl/talk.jekyllrb.com.key;
ssl_certificate /var/ssl/talk.jekyllrb.com.crt;
perl_set $rails_host 'sub {
  use Socket;

  $p = gethostbyname("discourse");
  return inet_ntoa(
    $p
  );
}';

server {
  root /srv/nginx/discourse;
  server_name talk.jekyllrb.com;
  set $rails_port '3000';

  include /usr/share/nginx/ssl.conf;
  include /usr/share/nginx/locations/discourse.conf;
  include /usr/share/nginx/rails.conf;
}
