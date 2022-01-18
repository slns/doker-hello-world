FROM golang:1.13 as builder

LABEL maintainer="Sergio Santos, sergiolns75@gmail.com"

### Create new directly 
RUN mkdir -p /app

### Set it as working directory
WORKDIR /app

### Copy Go application dependency files
COPY go.mod .
# COPY go.sum .

### Setting a proxy for downloading modules
ENV GOPROXY https://proxy.golang.org,direct

### Download Go application module dependencies
RUN go mod download

### Copy actual source code for building the application
COPY . .

### CGO has to be disabled cross platform builds
### Otherwise the application won't be able to start
ENV CGO_ENABLED=0

### Build the Go hello-world for a linux OS
### 'scratch' and 'alpine' both are Linux distributions
RUN GOOS=linux go build ./hello-world.go

##### Stage 2 #####

### Define the running image
FROM scratch

### Alternatively to 'FROM scratch', use 'alpine':
# FROM alpine:3.13.1, with size 7,53mb

### Set working directory
WORKDIR /app

### Copy built binary application from 'builder' image
COPY --from=builder /app/hello-world .

### Run the binary application
CMD ["/app/hello-world"]