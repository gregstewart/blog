#!/bin/bash

aws s3 sync public/blog s3://tcias.co.uk/blog/ --acl public-read  \
  --cache-control 'max-age=604800'  \
  --region eu-west-1 \
  --include="*"  \
  --exclude "*favicon*" \
  --exclude "wp-content/*" \
  --exclude "assets/*" \
  --exclude "images/*" \
  --exclude "*javascripts/*"
