package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	//https://github.com/gin-gonic/gin/issues/1207
	router.Any("/*proxyPath", cookieX)
	//router.GET("/", cookieX)
	//router.GET("/headers", cookieX)

	router.Run("0.0.0.0:8081")
}

func cookieX(c *gin.Context) {
	status := http.StatusForbidden
	cookie := c.GetHeader("Cookie")
	log.Println("cookie:", cookie)
	if cookie == "valid" {
		c.Header("authorization", "EXAMPLETOKEN")
		c.Header("hello", "world")
		status = http.StatusOK
	}
	c.Status(status)
}
