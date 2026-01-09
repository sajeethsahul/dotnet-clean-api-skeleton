# Deployment Guide

This guide provides generic deployment instructions for the Therapy Companion API.


## Table of Contents
- [Prerequisites](#prerequisites)
- [Environment Variables](#environment-variables)
- [Local Development](#local-development)
- [Docker Deployment](#docker-deployment)
- [Azure App Service](#azure-app-service)
- [Kubernetes](#kubernetes)
- [Database Migrations](#database-migrations)
- [Monitoring](#monitoring)
- [Backup and Recovery](#backup-and-recovery)
- [Troubleshooting](#troubleshooting)

## Prerequisites
- .NET 8.0 SDK
- SQL Server (or compatible DB)
- Git
- Docker (optional)


### For All Deployments
- .NET 8.0 SDK
- SQL Server 2019+
- Git

### For Containerized Deployments
- Docker 20.10+
- Docker Compose 1.29+
- (Optional) Kubernetes CLI (kubectl)

### For Cloud Deployments
- Azure CLI (for Azure deployments)
- AWS CLI (for AWS deployments)
- Google Cloud SDK (for GCP deployments)

## Environment Variables

Create a `.env` file in the project root with the following variables:

```env
# Database
DB_SERVER=localhost
DB_NAME=TherapyCompanion
DB_USER=sa
DB_PASSWORD=your-password

# JWT
JWT_SECRET=your-secret
JWT_ISSUER=TherapyCompanionAPI
JWT_AUDIENCE=TherapyCompanionClients

# App
ASPNETCORE_ENVIRONMENT=Development
ASPNETCORE_URLS=http://+:5000


# CORS
CORS_ORIGINS=https://your-frontend.com,http://localhost:3000

# Email Settings
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASSWORD=your-sendgrid-api-key
SMTP_SenderEmail=noreply@yourdomain.com
SMTP_SenderName="Hotel Booking"
SMTP_EnableSsl=true



# Application Settings
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://+:8080
```

## Local Development

### 1. Clone the Repository
```bash
git clone https://github.com/sajeethsahul/therapy-companion-platform
cd therapy-companion-platform
```

### 2. Configure Environment
1. Copy `.env.example` to `.env`
2. Update the values in `.env`
3. For development, you can use SQL Server LocalDB

### 3. Run Database Migrations
```bash
dotnet ef database update --project src/Infrastructure --startup-project src/API
```

### 4. Run the Application
```bash
# Development (watch mode)
dotnet watch --project src/API run

# Or production mode
dotnet run --project src/API --launch-profile Production
```

## Docker Deployment

### 1. Build the Docker Image
```bash
docker build -t therapy-companion-api .
```

### 2. Run with Docker Compose
```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### 3. Verify the Deployment
```bash
docker ps
docker logs therapy-companion-api
```




## Database Migrations

### 1. Generate Migrations
```bash
dotnet ef migrations add InitialCreate --project src/Infrastructure --startup-project src/API
```

### 2. Apply Migrations
```bash
# For local development
dotnet ef database update --project src/Infrastructure --startup-project src/API

# For production (using EF Core tools in Docker)
docker-compose -f docker-compose.migrations.yml up
```

## Monitoring

### Application Insights
1. Create an Application Insights resource in Azure
2. Add the Instrumentation Key to your app settings:
   ```
   ApplicationInsights__InstrumentationKey=your-instrumentation-key
   ```

### Health Checks
Access the health check endpoint:
```
GET /health
```

### Logging
Logs are written to:
- Console (stdout/stderr)
- Application Insights (if configured)
- File system (in development)


## Troubleshooting

### Common Issues

#### Database Connection Issues
- Verify connection string
- Check if the database server is accessible
- Ensure firewall rules allow the connection

#### Application Startup Errors
- Check application logs
- Verify all required environment variables are set
- Check database migrations have been applied

#### Performance Issues
- Check database query performance
- Review application logs for slow requests
- Monitor resource usage (CPU, memory, disk I/O)

### Logs

#### Local Development
```bash
# View application logs
dotnet run --project src/API

# View container logs
docker logs therapy-companion-api
```

#### Azure App Service
```bash
# Stream logs
az webapp log tail --name <app-name> --resource-group TherapyCompanionRG

# Download logs
az webapp log download --log-file app-logs.zip --name <app-name> --resource-group TherapyCompanionRG
```

#### Kubernetes
```bash
# View pod logs
kubectl logs -f <pod-name> -n therapy-companion

# Describe pod for more details
kubectl describe pod <pod-name> -n therapy-companion
```

## Maintenance

### Updating the Application
1. Pull the latest changes
2. Run database migrations if needed
3. Rebuild and restart the application

### Monitoring
- Set up alerts for critical issues
- Monitor application performance
- Review security logs regularly

## Rollback Plan

### Manual Rollback
1. Revert to previous deployment
2. Run database rollback if needed
3. Verify application functionality

### Automated Rollback
- Configure health probes in Kubernetes
- Set up deployment strategies (e.g., rolling updates with max unavailable)
- Use feature flags for risky changes

## Security Considerations

### Secrets Management
- Never commit secrets to source control
- Use environment variables for sensitive values
- Rotate secrets when compromised

### Authentication & Authorization
- JWT-based authentication
- Protect sensitive endpoints with authorization
- Validate token expiration and issuer

### Input Validation
- Validate all incoming requests
- Use server-side validation for DTOs
- Reject malformed or unexpected input

### HTTPS
- Use HTTPS in all non-local environments
- Avoid transmitting tokens or credentials over HTTP

### Logging
- Do not log sensitive data (passwords, tokens, PII)
- Log authentication failures and unexpected errors

