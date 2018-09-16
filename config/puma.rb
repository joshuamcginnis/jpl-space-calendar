if ENV['RACK_ENV'] == 'production'
  ssl_bind '0.0.0.0', '9292', {
    key: ENV['SSL_KEY_PATH'],
    cert: ENV['SSL_CERT_PATH']
  }
else
  bind 'tcp://0.0.0.0:4567'
end

preload_app!
workers 4
