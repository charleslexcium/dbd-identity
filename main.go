package main

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	// Create a new Gin router
	router := gin.Default()

	// Define a simple GET endpoint
	router.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})

	// Define a simple GET endpoint
	router.POST("/auth/event", func(c *gin.Context) {
		var requestBody map[string]any
		if err := c.ShouldBindJSON(&requestBody); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		// Log the request body

		fmt.Println("Request Body:", requestBody)
		c.JSON(http.StatusOK, nil)
	})

	// Start the server on port 9090
	router.Run(":9090")
}
