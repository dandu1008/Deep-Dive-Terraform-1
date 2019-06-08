#!/bin/bash

# Access JSON values
eval "$(jq -r '@sh "export TF_WORKSPACE=\(.workspace) TF_PROJECTCODE=\(.projectcode) TF_URL=\(.url)"')"

#Configure the query
curl_args=(
  -H "querytext: $TF_WORKSPACE-$TF_PROJECTCODE" 
  -H "content-type:application/json" 
  #--user admin:password
)

response=`curl "${curl_args[@]}" "$TF_URL"`

echo $response