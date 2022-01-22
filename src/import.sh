#!/bin/bash
source src/hardcoded_variables.txt
#source src/creds.txt
source ../personal_creds.txt
filler="Filler"

echo "LOOP"
# TODO: differentiate between GLOBAL and HARDCODED with:
#GITLAB_SERVER_ACCOUNT_GLOBAL=$(echo "$GITLAB_SERVER_ACCOUNT_HARDCODED" | tr -d '\r')
GITLAB_SERVER_ACCOUNT_GLOBAL=$(echo "$GITLAB_SERVER_ACCOUNT_GLOBAL" | tr -d '\r')
GITLAB_SERVER_PASSWORD_GLOBAL=$(echo "$GITLAB_SERVER_PASSWORD_GLOBAL" | tr -d '\r')
GITLAB_ROOT_EMAIL_GLOBAL=$(echo "$GITLAB_ROOT_EMAIL_GLOBAL" | tr -d '\r')
GITLAB_PERSONAL_ACCESS_TOKEN_GLOBAL=$(echo "$GITLAB_PERSONAL_ACCESS_TOKEN_GLOBAL" | tr -d '\r')
GITHUB_PERSONAL_ACCESS_TOKEN_GLOBAL=$(echo "$GITHUB_PERSONAL_ACCESS_TOKEN_GLOBAL" | tr -d '\r')
GITLAB_WEBSITE_URL_GLOBAL=$(echo "$GITLAB_WEBSITE_URL_GLOBAL" | tr -d '\r')
GITLAB_SERVER_PASSWORD_GLOBAL=$(echo "$GITLAB_SERVER_PASSWORD_GLOBAL" | tr -d '\r')
GITLAB_SERVER_PASSWORD_GLOBAL=$(echo "$GITLAB_SERVER_PASSWORD_GLOBAL" | tr -d '\r')
#echo "$GITLAB_SERVER_ACCOUNT_GLOBAL$filler"
#echo "$GITLAB_SERVER_PASSWORD_GLOBAL$filler"
#echo "$GITLAB_ROOT_EMAIL_GLOBAL$filler"
#echo "$GITLAB_PERSONAL_ACCESS_TOKEN_GLOBAL$filler"
#echo "$GITHUB_PERSONAL_ACCESS_TOKEN_GLOBAL$filler"
#echo "$GITLAB_WEBSITE_URL_GLOBAL$filler"
#echo "$GITLAB_SERVER_PASSWORD_GLOBAL$filler"
#read -p "Done"

source src/helper_ci_management.sh
source src/helper_dir_edit.sh
source src/helper_github_modify.sh
source src/helper_github_status.sh
source src/helper_gitlab_modify.sh
source src/helper_gitlab_status.sh
source src/helper_git_neutral.sh
source src/helper_ssh.sh

source src/get_gitlab_server_runner_token.sh
source src/run_ci_on_github_repo.sh


source src/helper.sh
source src/sha256_computing.sh


# Load assert abilities into code:
source src/helper_asserts.sh
echo "DOne importing"