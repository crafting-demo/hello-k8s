FROM golang:1.18-alpine as BUILD
ADD * /src/
WORKDIR /src
RUN CGO_ENABLED=0 go build -o /app ./

FROM scratch
COPY --from=BUILD /app /
ENTRYPOINT ["/app"]
