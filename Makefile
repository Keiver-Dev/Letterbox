.PHONY: install env key up down test dev setup help

# Default target
help:
	@echo "Letterbox Email Service Setup"
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  setup    - Complete installation and setup (install, env, key, up)"
	@echo "  install  - Install dependencies"
	@echo "  env      - Copy .env.example to .env (if not exists)"
	@echo "  key      - Generate a secure API key in .env"
	@echo "  up       - Start infrastructure with docker-compose"
	@echo "  down     - Stop docker services"
	@echo "  test     - Run integration tests"
	@echo "  dev      - Start development server"

setup: install env key up
	@echo "Setup complete! The service is ready."

install:
	npm install

env:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo ".env created."; \
	else \
		echo ".env already exists."; \
	fi

key:
	@if [ -f .env ]; then \
		NEW_KEY=$$(node -e "console.log(require('crypto').randomBytes(16).toString('hex'))"); \
		sed -i "s/INTERNAL_API_KEY=.*/INTERNAL_API_KEY=$$NEW_KEY/" .env; \
		echo "Secure API Key generated and added to .env"; \
	else \
		echo ".env not found. Please run 'make env' first."; \
	fi

up:
	docker-compose up -d

down:
	docker-compose down

test:
	npm test

dev:
	npm run dev
