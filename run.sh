#!/bin/sh

if [ ! -n "$DEPLOY" ]; then
  fail 'Please set deploy after steps only.'
fi

if [ "$WERCKER_RESULT" != "passed" ]; then
  info "deploy to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY failed."
  return 0
fi

if [ ! -n "$WERCKER_AIRBRAKE_NOTIFY_API_KEY" ]; then
  fail 'Please specify api key property.'
fi

cmd=`which curl`
if [ ! -n "$cmd" ]; then
  fail 'Command not found.'
fi

if [ -n "$WERCKER_AIRBRAKE_NOTIFY_HOST" ]; then
  host="$WERCKER_AIRBRAKE_NOTIFY_HOST"
else
  host="airbrake.io"
fi

if [ -n "$WERCKER_AIRBRAKE_NOTIFY_SECURE" ]; then
  test "$WERCKER_AIRBRAKE_NOTIFY_SECURE" = "true" && schema="https" || schema="http"
else
  schema="http"
fi

if [ ! -n "$WERCKER_AIRBRAKE_NOTIFY_ENVIRONMENT" ]; then
  environment="production"
else
  environment="$WERCKER_AIRBRAKE_NOTIFY_ENVIRONMENT"
fi
info $environment


if [ -n "$WERCKER_GIT_DOMAIN" ]; then
  scm_repository=git@$WERCKER_GIT_DOMAIN:$WERCKER_GIT_OWNER/$WERCKER_GIT_REPOSITORY\.git
fi
info $scm_repository


if [ -n "$WERCKER_GIT_COMMIT" ]; then
  scm_revision=$WERCKER_GIT_COMMIT
fi
info $scm_revision


if [ -n "$WERCKER_AIRBRAKE_NOTIFY_MESSAGE" ]; then
  message="$WERCKER_AIRBRAKE_NOTIFY_MESSAGE"
else
  message="Deploy to $WERCKER_DEPLOYTARGET_NAME passed."
fi
info "$message"

$cmd -G -s \
  --data-urlencode "api_key=$WERCKER_AIRBRAKE_NOTIFY_API_KEY" \
  --data-urlencode "deploy[local_username]=$WERCKER_STARTED_BY" \
  --data-urlencode "deploy[rails_env]=$environment" \
  --data-urlencode "deploy[scm_repository]=$scm_repository" \
  --data-urlencode "deploy[scm_revision]=$scm_revision" \
  --data-urlencode "deploy[message]=$message" \
  "$schema://$host/deploys.txt" > /dev/null
