#!/bin/sh
gcloud container clusters get-credentials mediawiki-cluster-gke --region us-central1
helm create mediawiki-chart-values
rm -rf ./mediawiki-chart-values/*
rsync -r mediawiki-chart-values/ mediawiki-chart
helm install mediawiki-chart ./mediawiki-chart-values