#!/usr/bin/env bash
#
# Script para demonstrar o processo de procura por APIKEYS
#
# Esse script pode ser aprimorado.

if [[ "$*" = "*-h*" ]]
then
    cat <<AJUDA

    Use: $(basename $0) [arquivo] ou por pipe (|):

    cat subs | apihunter.sh
AJUDA
exit 0
fi

if test -f "$1"; then
    examinar_subs=$(cat "$1")
else
    examinar_subs=$(cat)
    [ -z "$examinar_subs" ] && \
    echo -e "\n\t Pipe vazio..." && \
    exit 1
fi

apis=(
    'https?://[\\w\-\.]\\.file.core.windows.net'                                                        #  AZURE STORAGE
    'https://hooks.slack.com/services/T[a-zA-Z0-9_]{8}/B[a-zA-Z0-9_]{8}/[a-zA-Z0-9_]{24}'               # SLACK WEBHOOK
    "[f|F][a|A][c|C][e|E][b|B][o|O][o|O][k|K].{0,30}[\'\"\\\s][0-9a-f]{32}[\'\"\\\s]"                   # FACEBOOK OAUTH"
    "[t|T][w|W][i|I][t|T][t|T][e|E][r|R].{0,30}[\'\"\\s][0-9a-zA-Z]{35,44}[\'\"\\\s]"                   # Twitter OAUTH
    "[h|H][e|E][r|R][o|O][k|K][u|U].{0,30}[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}" # Heroku api
    "key-[0-9a-zA-Z]{32}"                                                                               # Mailgun API
    "[0-9a-f]{32}-us[0-9]{1,2}"                                                                         # Mail champ API
    "sk_live_[0-9a-z]{32}"                                                                              # Picatic API
    "[0-9(+-[0-9A-Za-z_]{32}.apps.qooqleusercontent.com"                                                # Google Oauth ID
    "AIza[0-9A-Za-z-_]{35}"                                                                             # Google API
    "6L[0-9A-Za-z-_]{38}"                                                                               # Google Captcha
    "ya29\\.[0-9A-Za-z\\-_]+"                                                                           # Google Oauth
    "AKIA[0-9A-Z]{16}"                                                                                  # Amazon Aws Access Key ID
    "amzn\\.mws\\.[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"                         # Amazon Mws Auth
    "s3\\.amazonaws.com[/]+|[a-zA-Z0-9_-]*\\.s3\\.amazonaws.com"                                        # Amazon URL
    "EAACEdEose0cBA[0-9A-Za-z]+"                                                                        # Facebook access token
    "SK[0-9a-fA-F]{32}"                                                                                 # Twilio Api
    "AC[a-zA-Z0-9_\\-]{32}"                                                                             # Twilio API ID
    "AP[a-zA-Z0-9_\\-]{32}"                                                                             # Twilio APP SID
    "access_token\\\$production\\\$[0-9a-z]{16}\\\$[0-9a-f]{32}"                                        # Paypal BrainTree
    "sq0csp-[ 0-9A-Za-z\\-_]{43}"                                                                       # Square Oauth Secret
    "sqOatp-[0-9A-Za-z\\-_]{22}"                                                                        # Square Oauth Access token
    "sk_live_[0-9a-zA-Z]{24}"                                                                           # Stripe standart API
    "rk_live_[0-9a-zA-Z]{24}"                                                                           # Stripe restricted API
    "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"                                                     # Google Cloud Oauth
    "[a-zA-Z0-9_-]*:[a-zA-Z0-9_\\-]+@github\\.com*"                                                     # Github Access Token
    "[A-Za-z0-9_]{21}--[A-Za-z0-9_]{8}"                                                                 # Google Cloud API-KEY
    "-----BEGIN PRIVATE KEY-----[a-zA-Z0-9\\S]{100,}-----END PRIVATE KEY——"                             # Private SSH KEY
    "-----BEGIN RSA PRIVATE KEY-----[a-zA-Z0-9\\S]{100,}-----END RSA PRIVATE KEY-----"                  # Private RSA KEY
)

regex_final="\"(?m:([\\w-.]\\.oss.aliyuncs.com)$(printf "|(%s)" "${apis[@]}"))\""
echo "$examinar_subs" | httpx -extract-regex "$regex_final"