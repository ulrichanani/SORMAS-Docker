#!/bin/bash

cat << EOF > /usr/local/apache2/conf.d/001_ssl_${SORMAS_SERVER_URL}
<VirtualHost *:443>
        ServerName ${SORMAS_SERVER_URL}
	
	DocumentRoot /var/www/

        ErrorLog /var/log/apache2/error.log
        LogLevel warn
        LogFormat "%h %l %u %t \"%r\" %>s %b _%D_ \"%{User}i\"  \"%{Connection}i\"  \"%{Referer}i\" \"%{User-agent}i\"" combined_ext
        CustomLog /var/log/apache2/access.log combined_ext        

        SSLEngine on
        SSLCertificateFile    /etc/httpd/conf/${SORMAS_SERVER_URL}.crt
        SSLCertificateKeyFile /etc/httpd/conf/${SORMAS_SERVER_URL}.key
        #SSLCertificateChainFile /etc/ssl/certs/${SORMAS_SEVER_URL}.ca-bundle

        # disable weak ciphers and old TLS/SSL
        SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
	SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5
        #SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE$
        SSLHonorCipherOrder off

	
        #ProxyRequests Off
        #ProxyPass /sormas-ui http://172.17.0.1:6080/sormas-ui
        #ProxyPassReverse /sormas-ui http://172.17.0.1:6080/sormas-ui
        #ProxyPass /sormas-rest http://172.17.0.1:6080/sormas-rest
        #ProxyPassReverse /sormas-rest http://172.17.0.1:6080/sormas-rest

        Options -Indexes
        AliasMatch "/downloads/sormas-(.*)" "/var/www/sormas/downloads/sormas-$1"

        <IfModule mod_deflate.c>
            AddOutputFilterByType DEFLATE text/plain text/html text/xml
            AddOutputFilterByType DEFLATE text/css text/javascript
            AddOutputFilterByType DEFLATE application/json
            AddOutputFilterByType DEFLATE application/xml application/xhtml+xml
            AddOutputFilterByType DEFLATE application/javascript application/x-javascript
            DeflateCompressionLevel 1
        </IfModule>        
</VirtualHost>
EOF
