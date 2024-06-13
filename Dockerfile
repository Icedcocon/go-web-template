FROM golang:1.22 AS build
WORKDIR /
COPY . /project/go-web-template
RUN cd /project/go-web-template \
&& CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on \
   go build -mod vendor -o go-web-template 
# -ldflags '-linkmode "external" -extldflags "-static"'

FROM scratch AS final
COPY --from=build /project/go-web-template/go-web-template .
COPY --from=build /project/go-web-template/config.yaml .
COPY --from=build /project/go-web-template/private.pem .
COPY --from=build /project/go-web-template/public.pem .
CMD ["./go-web-template"]