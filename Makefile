# Run the JAR locally (via script)
run-local:
	@chmod +x run_app.sh
	@./run_app.sh

# Build Docker image
build-image:
	docker build -t my-java-app .

# Run Docker container locally
run-docker:
	docker run -d -p 8080:8080 --name my-running-app my-java-app

# Deploy Docker image to EC2 instance
deploy:
	@echo "🚀 Push your code to GitHub to trigger CI/CD via deploy.yaml"


# Create AWS Load Balancer
create-elb:
	@chmod +x create_elb.sh
	@./create_elb.sh
