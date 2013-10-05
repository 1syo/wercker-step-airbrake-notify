#!/bin/sh

if [ ! -n "$WERCKER_ERRBIT_NOTIFY_HOST" ]; then
  fail 'Please specify host property.'
fi

if [ ! -n "$WERCKER_ERRBIT_NOTIFY_API_KEY" ]; then
  fail 'Please specify api key property.'
fi

cmd=`which curl`
if [ ! -n "$cmd" ]; then
  fail 'Command not found.'
fi

if [ -n "$WERCKER_ERRBIT_NOTIFY_SSL" ]; then
  test "$WERCKER_ERRBIT_NOTIFY_SSL" = "true" && schema="https" || schema="http"
else
  schema="http"
fi

if [ ! -n "$WERCKER_ERRBIT_NOTIFY_ENVIRONMENT" ]; then
  environment="production"
fi

repository=git@$WERCKER_GIT_DOMAIN:$WERCKER_GIT_OWNER/$WERCKER_GIT_REPOSITORY\.git
info $repository

wercker_url=https://app.wercker.com/#deploy/$WERCKER_DEPLOY_ID
info $wercker_url

$cmd -G \
  --data-urlencode api_key=$WERCKER_ERRBIT_NOTIFY_API_KEY \
  --data-urlencode deploy\[local_username\]=$WERCKER_STARTED_BY \
  --data-urlencode deploy\[rails_env\]=$environment \
  --data-urlencode deploy\[scm_repository\]=$repository \
  --data-urlencode deploy\[scm_revision\]=$WERCKER_GIT_COMMIT \
  --data-urlencode deploy\[message\]=$wercker_url \
  $schema://$WERCKER_ERRBIT_NOTIFY_HOST/deploys.txt
