# Cloud-Native Food Ordering & Delivery Platform

<div align="center">

![Client UI](https://cdn.mojasim.com/1781412849530-Pizza-Client.jpeg)

</div>

<div align="center">

![Admin UI](https://cdn.mojasim.com/1781412864271-Pizza-Admin.png)

</div>

<div align="center">

![Architecture Diagram](https://cdn.mojasim.com/1786892864572-pizza-app-diagram.png)

</div>

## Architecture & System Overview

### Traffic Flow & Networking
1. **Edge & Load Balancing:** Incoming HTTPS traffic reaches an **AWS Network Load Balancer (NLB)** configured with **AWS Certificate Manager (ACM)** for TLS termination and cross-zone load balancing.
2. **Ingress Routing:** Decrypted traffic forwards to the **NGINX Ingress Controller** (`ingress-nginx`) running inside the AWS EKS cluster. The controller handles host/path-based routing, CORS policies, and WebSocket protocol connection upgrades.
3. **Internal Microservices:** Traffic routes across private subnets to internal ClusterIP services. Microservices communicate with datastores and publish/consume events over the private cluster network.

### Microservices Directory

| Service | Description | Tech Stack | Repository |
| :--- | :--- | :--- | :--- |
| **Auth Service** | User authentication, RBAC, tenant management, and asymmetric JWKS token issuing | Node.js, Express, TypeScript, PostgreSQL (TypeORM) | [auth-service](https://github.com/mo-jasim/auth-service) |
| **Catalog Service** | Product & pricing catalog, categories, toppings, and asset management | Node.js, Express, TypeScript, MongoDB (Mongoose), AWS S3 | [catalog-service](https://github.com/mo-jasim/catalog-service) |
| **Order Service** | Order placement, state machine workflows, and payment handling | Node.js, Express, TypeScript, MongoDB (Mongoose), Stripe API | [order-service](https://github.com/mo-jasim/order-service) |
| **Notification Service** | Event-driven customer transactional notifications and emails | Node.js, TypeScript, Apache Kafka, Nodemailer | [notification-service](https://github.com/mo-jasim/notification-service) |
| **WebSocket Service** | Real-time order tracking and live status updates | Node.js, TypeScript, Socket.IO, Apache Kafka | [websocket-service](https://github.com/mo-jasim/websocket-service) |
| **Client Frontend** | Customer web application for browsing menus and ordering | Next.js 14 (App Router), React, TypeScript, Tailwind CSS | [client-frontend](https://github.com/mo-jasim/client-frontend) |
| **Admin Dashboard** | Restaurant operations and catalog management portal | React 18, Vite, TypeScript, Ant Design, Zustand | [admin-dashboard](https://github.com/mo-jasim/admin-dashboard) |

### Datastores & External Services
- **PostgreSQL:** Relational database for user credentials, tenant hierarchies, and permission mappings.
- **MongoDB:** Document database powering product catalogs, customizable toppings, and order state history.
- **Apache Kafka:** Distributed event streaming platform connecting Catalog, Order, Notification, and WebSocket services for asynchronous, non-blocking workflows.
- **AWS S3:** Object storage for catalog product images.
- **Stripe API:** Payment processing and webhook lifecycle management.

## Infrastructure & GitOps Deployment

### Infrastructure as Code (Terraform)
The AWS cloud environment is automated through modular **Terraform** scripts:
- **AWS VPC:** Custom VPC with public, private, and intra subnets across multiple availability zones.
- **AWS EKS:** Managed Kubernetes cluster (v1.35) with managed node groups, EBS CSI Driver via IRSA (IAM Roles for Service Accounts), and EKS Pod Identity.
- **Platform Tooling:** Ingress-NGINX and Argo CD provisioned directly via Helm provider integrations.

### CI/CD & Deployment Flow
- **Continuous Integration:** Pushes to the `main` branch trigger GitHub Actions workflows to run linters, execute tests, build multi-architecture Docker containers, and publish them to Docker Hub.
- **GitOps Continuous Delivery:** **Argo CD** monitors the repository and automatically synchronizes application manifests to the AWS EKS cluster.
- **Zero-Downtime Rollouts:** Kubernetes Deployments execute rolling updates with active health checks (`readinessProbe` and `livenessProbe`) to maintain uninterrupted service availability.
