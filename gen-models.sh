#! /bin/sh

PROTOBUF_DIR=$PWD/Sources/Neon/Protobuf/
protoc --proto_path $PROTOBUF_DIR --swift_out=$PROTOBUF_DIR Models.proto
