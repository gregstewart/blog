#!/bin/bash

aws s3 sync public/blog s3://tcias.co.uk/blog/ --acl public-read \
  --cache-control 'max-age=31104000' \
  --region eu-west-1 \
  --exclude="*" \
  --include "*favicon*" \
  --include "wp-content/uploads/" \
  --include "assets/*" \
  --include "images/*" \
  --include "*javascripts/*"
