package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)

var (
	listenAddr = flag.String("l", ":8000", "Listening address.")
)

type HelloRequest struct {
	Name string `json:"name"`
}

type HelloResponse struct {
	Message string `json:"message"`
}

func main() {
	flag.Parse()

	server := http.Server{
		Addr: *listenAddr,
		Handler: http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			req := &HelloRequest{}
			if err := json.NewDecoder(r.Body).Decode(req); err != nil {
				http.Error(w, err.Error(), http.StatusBadRequest)
				return
			}
			resp := &HelloResponse{
				Message: fmt.Sprintf("Hello %s!", req.Name),
			}
			data, err := json.Marshal(resp)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			w.Header().Add("Content-type", "application/json")
			w.Write(data)
		}),
	}

	signalCh := make(chan os.Signal, 1)
	signal.Notify(signalCh, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-signalCh
		server.Shutdown(context.Background())
	}()

	err := server.ListenAndServe()
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Fatalln(err)
	}
}
