# Cloud Deployment Platform

<div align="center">
  
![Client UI](https://cdn.mojasim.com/1781412849530-Pizza-Client.jpeg)

</div>

<div align="center">

![Admin UI](https://cdn.mojasim.com/1781412864271-Pizza-Admin.png)

</div>

<div align="center">

![Architecture Diagram](https://cdn.mojasim.com/1786892864572-pizza-app-diagram.png)

</div>

## Architecture & Service Breakdown

### Service Flow & Communication
External traffic is captured by an AWS Application Load Balancer (ALB) and routed to a Kubernetes Ingress controller. The Ingress controller acts as the cluster's gateway, proxying requests to the appropriate microservices based on path definitions. Once inside the cluster, microservices communicate with one another over the internal cluster network.

### Microservices Directory
- [Auth Service](https://github.com/your-username/auth-service)
- [Catalog Service](https://github.com/your-username/catalog-service)
- [Client Frontend](https://github.com/your-username/client-frontend)
- [Notification Service](https://github.com/your-username/notification-service)
- [Order Service](https://github.com/your-username/order-service)
- [WebSocket / Real-time Service](https://github.com/your-username/websocket-service)

### External Dependencies & Datastores
- **Databases:** PostgreSQL (Core Data), Redis (Caching)
- **Message Brokers:** Kafka (Asynchronous Event Streaming)
- **Integrations:** Stripe (Payments)

## Infrastructure & Deployment

The infrastructure is provisioned using **Terraform**, managing the underlying networking and the **AWS EKS** cluster. 

**CI/CD Flow:**
- **Push & Build:** Code pushed to the repository triggers the CI pipeline, which runs tests and builds new Docker images.
- **Publish:** Images are tagged and pushed to a container registry.
- **Rollout:** The CD pipeline updates the Kubernetes manifests and applies them to the EKS cluster, initiating a rolling deployment for the updated services.
