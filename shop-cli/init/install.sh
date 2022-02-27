#!/bin/bash
set -eux

# "http://10.0.2.2:3128/"
export LOCAL_PROXY="http://10.0.2.2:3128"

echo "#==> adding proxy..." && sleep 1
tee /tmp/proxy.sh << EOF
export http_proxy="${LOCAL_PROXY}"
export https_proxy="${LOCAL_PROXY}"
export ftp_proxy="${LOCAL_PROXY}"
export no_proxy="localhost,127.0.0.*,10.*,192.168.*,*.pnet.ch,*.post.ch,*.postfinance.ch,exchange,db-exchange,bank,db-bank,merchant,db-merchant"

export HTTP_PROXY="${LOCAL_PROXY}"
export HTTPS_PROXY="${LOCAL_PROXY}"
export FTP_PROXY="${LOCAL_PROXY}"
export NO_PROXY="localhost,127.0.0.*,10.*,192.168.*,*.pnet.ch,*.post.ch,*.postfinance.ch,exchange,db-exchange,bank,db-bank,merchant,db-merchant"
EOF
source /tmp/proxy.sh

#export HTTPS_PROXY="http://host.docker.internal:3128"
#export HTTP_PROXY="http://host.docker.internal:3128"
#export https_proxy="http://host.docker.internal:3128"
#export http_proxy="http://host.docker.internal:3128"

#echo "-k" > /home/www-data/.curlrc

wp core install \
	--url=shop \
      	--path="/var/www/html" \
	--title="Shop Accepting Taler" \
       	--admin_user=shop_admin \
       	--admin_password=shop_admin \
       	--admin_email=info@example.com 

# update
wp core update --path="${WORDPRESS_HOME}" \

# install theme (for woocommerce) 
wp theme install storefront --activate --path="${WORDPRESS_HOME}"

# install woocommerce plugin
wp plugin install woocommerce --activate --path="${WORDPRESS_HOME}"
 
# install gnu-taler-payment-for-woocommerce plugin
wp plugin install gnu-taler-payment-for-woocommerce --activate --path="${WORDPRESS_HOME}"

# config shop
wp option update woocommerce_store_address "Store street 2" 
wp option update woocommerce_store_city "Bern" 
wp option update woocommerce_default_country "CH:BE"
wp option update woocommerce_store_postcode "3030" 
wp option update woocommerce_show_marketplace_suggestions 'no' 
wp option update woocommerce_allow_tracking 'no' 
wp option update woocommerce_task_list_hidden 'yes'

# docker-compose run shop-cli wp option update woocommerce_task_list_complete 'yes'
wp option update woocommerce_task_list_welcome_modal_dismissed 'yes' 
wp option update --format=json woocommerce_onboarding_profile "{\"is_agree_marketing\":false,\"store_email\":\"info@example.com\",\"industry\":[{\"slug\":\"other\",\"detail\":\"Digital Goods\"}],\"product_types\":[\"downloads\"],\"product_count\":\"0\",\"selling_venues\":\"no\",\"setup_client\":true,\"business_extensions\":[],\"theme\":\"storefront\",\"completed\":true,\"skipped\":true}"

# payment gateway
wp wc payment_gateway update gnutaler --enabled=1 --user=shop_admin 
wp option update woocommerce_gnutaler_settings --format=json '{"enabled":"yes","title":"GNU Taler","description":"Pay with GNU Taler","gnu_taler_backend_url":"http:\/\/merchant\/instances\/shop\/","GNU_Taler_Backend_API_Key":"Sandbox ApiKey","Order_text":"WooTalerShop #%s","GNU_Taler_refund_delay":"14","debug":"no"}'

# create category
cat_create_msg=$(wp wc product_cat create --name="Voucher" --user=shop_admin)
[[ $cat_create_msg =~ ^.*(\d+)$ ]] # pattern must be unquoted

cat_id=$BASH_REMATCH[1]

# create voucher products
wp wc product create --name="Netflix" --sku="NTFLX01" --regular_price=20.00 --virtual=1 --categories="{[${cat_id}]}" --user=shop_admin

