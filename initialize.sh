#!/bin/sh
set -ex

echo ${GITHUB_RUN_ID} > ${GITHUB_WORKSPACE}/workflow_id

pkgbase=$(jq -r .action "${GITHUB_EVENT_PATH}")
uuid=$(echo $pkgbase | cut -d' ' -f2)
pkgbase=$(echo $pkgbase | cut -d' ' -f1)

echo "::add-path::${GITHUB_WORKSPACE}/action-tools"
echo "::add-path::${GITHUB_WORKSPACE}/lilac"
echo "::set-output name=pkgbase::${pkgbase}"
echo "::set-output name=uuid::${uuid}"
