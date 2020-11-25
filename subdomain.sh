#!/bin/bash

domain=$1
resolvers="/root/tools/recon_auto/resolvers.txt"
#subfinder

basic_enum(){
mkdir -p $domain $domain/sources $domain/recon $domain/recon/nuclei $domain/recon/wayback $domain/recon/gf

subfinder -d $domain -o $domain/sources/subfinder.txt

#assetfinder
assetfinder -subs-only $domain | tee $domain/sources/assetfinder.txt

#amass
amass enum -passive -d $domain -o $domain/sources/passive.txt

cat $domain/sources/*.txt > $domain/sources/all.txt
}

basic_enum

resolve_domain(){

shuffledns -d $domain -list $domain/sources/all.txt -o $domain/domains.txt -r $resolvers
}

resolve_domain
http_probe(){
cat $domain/sources/all.txt | httpx -threads 200 -o $domain/recon/httpx.txt
}
http_probe
