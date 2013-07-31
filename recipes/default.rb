node['apache']['vhosts'].each do |vhost|
  web_app vhost['name'] do
    template 'web_app.conf.erb'
    server_name vhost['server_name']
    server_aliases vhost['aliases']
    server_admin vhost['server_admin']
    rails_env vhost['rails_env']
    port vhost['port'] || '80'
    docroot vhost['docroot'] || '/var/www/'

    log_level vhost['log_level'] || 'info'
    custom_log vhost['custom_log'] || "node['apache']['log_dir'] %>/<%= vhost['name'] %>-access.log combined"
    error_log vhost['error_log'] || "node['apache']['log_dir'] %>/<%= vhost['name'] %>-error.log"

    php_flags vhost['php_flags']
    server_signature vhost['server_signature'] || 'Off'
    directories vhost['directories']
  end
end if node['apache']['vhosts']
