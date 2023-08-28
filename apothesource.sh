#!/usr/bin/env bash
set -ex

case $(uname) in
  'Darwin')
    brew install \
      jenv\
      maven\
      openjdk@11\
      protobuf\
      protoc-gen-go\
      protog-gen-go-grpc

    brew install --cask microsoft-teams
  ;;
esac
