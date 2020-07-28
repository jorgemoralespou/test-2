#!/bin/bash
kapp deploy -a petclinic-pipeline -n default -f cicd/pipeline/ -c -y

WEBHOOK_URL="https://$(kubectl get ingress/el-github-listener-interceptor -n petclinic-pipeline -o jsonpath='{ .spec.rules[0].host }')"
echo "Configure the webhook URL ($WEBHOOK_URL) in your GitHub repo (https://github.com/danielhelfand/test-2)"