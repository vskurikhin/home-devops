#!/bin/sh

awk=/usr/bin/awk
awk_name='$1 !~ /^NAME/{print$1}'

kubectl=/usr/bin/kubectl

NAMESPACES=$($kubectl get namespaces | $awk "$awk_name")

API_RESOURCES_NAMESPACES=$($kubectl api-resources --namespaced=true | $awk "$awk_name")

API_RESOURCES_NO_NAMESPACES=$($kubectl api-resources --namespaced=false | $awk "$awk_name")

get_api_resource_object() {
  api_resource=$1
  object=$2
  namespace=$3
  if [ "x$namespace" != "x" ]
  then
    $kubectl get $api_resource $object -o yaml --namespace=$namespace > $object.yaml
  else
    $kubectl get $api_resource $object -o yaml > $object.yaml
  fi
}

iterate_by_objects() {
  api_resource=$1
  namespace=$2
  echo $api_resource
  mkdir -p $api_resource > /dev/null
  pushd $api_resource
  objects=$($kubectl get $api_resource --namespace=$namespace | $awk "$awk_name")
  for object in $objects
  do
    get_api_resource_object $api_resource $object $namespace
  done
  popd
}

iterate_by_namespaces() {
  echo Namespaces:
  for namespace in $NAMESPACES
  do
    echo $namespace
    mkdir -p $namespace > /dev/null
    pushd $namespace
    echo Namespaced API resources:
    for api_resource in $API_RESOURCES_NAMESPACES
    do
      iterate_by_objects $api_resource $namespace
    done
    popd
  done
}

iterate_by_no_namespaced_resources() {
  echo No namespaced API resources:
  for api_resource in $API_RESOURCES_NO_NAMESPACES
  do
    echo $api_resource
    mkdir -p no_namespaced > /dev/null
    pushd no_namespaced
    iterate_by_objects $api_resource
    popd
  done
}

iterate_by_namespaces
iterate_by_no_namespaced_resources