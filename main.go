package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.GET("/", cookieX)

	router.Run("0.0.0.0:8081")
}

func cookieX(c *gin.Context) {
	status := http.StatusForbidden
	cookie := c.GetHeader("Cookie")
	log.Println("cookie:", cookie)
	if cookie == "valid" {
		c.Header("Hello", "World")
		status = http.StatusOK
	}
	c.Status(status)
}
