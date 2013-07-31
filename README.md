apache_vhosts
=============

Chef cookbook setting up apache virtual hosts basing on the attributes. Can be used for setting up simple virtual hosts without writing additional cookbooks.

Requires
========

This cookbook requires the following cookbooks to be present:

* `apache2` >= 1.0.0


Attributes
==========

###General attributes

* `['apache']['vhosts']` - list of hashes containing virtual hosts configurations. Please see the description below for more details about the elements structure.

###Virtual hosts configuration.

Please use the following convention for the elements in the `['apache']['vhosts']` array:

* `['name']` - (string, required) name of the virtual host configuration,
* `['server_name'] - (string, required) `ServerName` value,
* `['server_aliases'] - (array) values for `ServerAlias`,
* `['server_admin'] - (string) `ServerAdmin` value,
* `['rails_env'] - (string) `RailsEnv` value,
* `['port'] - (string, required, default `80`) port of the virtual host,
* `['docroot'] - (string, required, default `/var/www/`) `DocumentRoot` value,
* `['log_level']` - (string, required, default `info`) `LogLevel` value,
* `['custom_log']` - (string) path for the application logs,
* `['error_log']` - (string) path for the application error logs,
* `['php_flags'] - (hash) custom php flags embedded into IfModule node:
  * key - php flag name,
  * value - php flag value.
* `['server_signature'] - (string, default `Off`) `ServerSignature` value,
* `['directories'] - (array) list of the directories defined for the virtual host. Please see the description below for more details about the elements structure.

###Directories configuration.

Please use the following convention for the elements in the `['directories']` array:

* `['path']` - (string, required) Directory path,
* `['options']` - (array) `Options` directory options,
* `['allow_override'] - (array) `AllowOverride` value,
* `['order']` - (array) `Order` value,
* `['allow'] - (array) `Allow` value,
* `['deny'] - (array) `Deny` value,
* `['expires_active']` - (array) `ExpiresActive` value,
* `['expires_default']` - (array) `ExpiresDefault` value,
* `['files_match`] - (hash) `FilesMatch` nodes, where key is a regex and value is a hash containing configuration for the FilesMatch using the same convention as for `['directories']` elements.

###Examples

Example ['apache']['vhosts'] value:
```json
[
  {
    "name": "example",
    "server_name": "example.net",
    "docroot": "/var/www/example/",
    "directories": [
      {
        "path":"/",
	"options": ["FollowSymLinks"],
	"allow_override":"None"
      },
      {
        "path": "/var/www/example/",
        "options": [
          "Indexes",
          "FollowSymLinks",
          "MultiViews"
        ],
        "allow_override": "All",
        "order": ["allow","deny"],
        "allow":"All"
      }
    ],
    "server_signature":"On"
  }
]
```

will produce the following `example.conf` file in the apache `sites-enabled` directory:

```
<VirtualHost *:80>
  ServerName example.net
  DocumentRoot /var/www/example/

  <Directory />
    Options FollowSymLinks
    AllowOverride None
  </Directory>

  <Directory /var/www/example/>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    Allow from All
  </Directory>

  LogLevel info
  ErrorLog /var/log/httpd/example-error.log
  CustomLog /var/log/httpd/example-access.log combined
  ServerSignature On
</VirtualHost>
```

Missing features
================

Definitely the cookbook lacks a lot of the apache attributes to be configurable. It would be nice to add proxies and SSL configuration.