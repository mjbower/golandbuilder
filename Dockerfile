FROM golang:alpine AS builder
ARG projectname
# Install git.
# Git is required for fetching the dependencies.
ENV projectname=${projectname}
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/github.com/${projectname}
COPY . .
# Fetch dependencies.
# Using go get.
RUN go get -d -v
# Build the binary.
RUN go build -o /go/bin/${projectname} .

############################
# STEP 2 build a small image
############################
FROM alpine
## Copy our static executable.
COPY --from=builder /go/bin/${projectname} /go/bin/${projectname}
