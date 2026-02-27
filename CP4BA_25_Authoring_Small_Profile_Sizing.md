# IBM Cloud Pak for Business Automation 25.0.0
## Sizing Specification: Authoring - Small Profile

**Document Version:** 1.0  
**Date:** 2026-02-27  
**Profile Type:** Small (no HA)  
**Source:** IBM Cloud Pak for Business Automation 25.0.0 Documentation

---

## Executive Summary

This document provides the sizing specifications for IBM Cloud Pak for Business Automation (CP4BA) version 25.0.0 with focus on **Authoring capabilities** using a **Small profile** deployment. The small profile is designed for environments used by a single department with a few users, useful for application development and non-production environments.

---

## Deployment Profile Overview

### Small Profile Characteristics

- **Target Environment:** Single department, application development, non-production
- **User Base:** 10 developers and 25 users
- **High Availability:** No HA configuration
- **Minimum Worker Nodes:** 8 nodes
- **Scaling Capability:** Can be scaled up to medium or large profiles post-installation

### Workload Estimates (Small Profile)

| Metric | Value |
|--------|-------|
| Documents Processed | 10,000 documents |
| Human Workflows | 5,000 workflows |
| Straight-Through Processes | 500,000 processes |
| Transactions | 5,000 transactions |
| Decisions | 500,000 decisions |
| Failover Support | No (single instance) |

---

## CP4BA Operator Requirements (Small Profile)

The CP4BA operator is the foundational component that manages all CP4BA capabilities.

| Component | CPU Request (m) | CPU Limit (m) | Memory Request (Mi) | Memory Limit (Mi) | Ephemeral Storage (Gi) |
|-----------|-----------------|---------------|---------------------|-------------------|------------------------|
| ibm-cp4a-operator | 500 | 1000 | 256 | 2048 | N/A |

**Notes:**
- CPU values are measured in millicore (m)
- Memory values are measured in mebibyte (Mi)
- This operator manages all CP4BA capabilities in the namespace

---

## Content Platform Engine (CPE) - Foundation for Authoring

FileNet Content Manager CPE is essential for document management and content services in authoring environments.

### CPE Requirements (Small Profile)

| Component | CPU Request (m) | CPU Limit (m) | Memory Request (Mi) | Memory Limit (Mi) |
|-----------|-----------------|---------------|---------------------|-------------------|
| ibm-content-operator | 500 | 1000 | 256 | 2048 |

**Capabilities Supported:**
- Document storage and management
- Content services for Business Automation Workflow
- No support for Business Automation Application
- No support for Automation Workstream Services

**Pod Name Convention:** `<metadata.name>-cpe-deploy`

---

## Content Services (CSS)

FileNet Content Manager CSS provides content integration services.

### CSS Requirements (Small Profile)

| Component | CPU Request (m) | CPU Limit (m) | Memory Request (Mi) | Memory Limit (Mi) |
|-----------|-----------------|---------------|---------------------|-------------------|
| FileNet Content Manager: CSS | 500 | 1000 | 256 | 2048 |

**Pod Name Convention:** `<metadata.name>-css-deploy`

---

## Business Automation Workflow (BAW) - Core Authoring Component

Business Automation Workflow Server is the primary authoring environment for process applications.

### BAW Server Requirements (Small Profile)

| Component | CPU Request (m) | CPU Limit (m) | Memory Request (Mi) | Memory Limit (Mi) |
|-----------|-----------------|---------------|---------------------|-------------------|
| ibm-workflow-operator | 100 | 500 | 20 | 500 |

**Workload Capacity:**
- **Human Workflows:** 5,000 workflows
- **Straight-Through Processes:** 500,000 processes
- **Transactions:** 5,000 transactions
- **Decisions:** 500,000 decisions

**Key Features:**
- Process Designer (authoring tool)
- Process Portal (runtime environment)
- Integration with Process Federation Server
- Support for playback functions
- No support for automation services only

**Pod Name Convention:** `<metadata.name>-<baw_instance_name>-baw-server-n`

---

## Workflow Process Service (WFPS)

Provides workflow processing capabilities for the authoring environment.

### WFPS Requirements (Small Profile)

| Component | CPU Request (m) | CPU Limit (m) | Memory Request (Mi) | Memory Limit (Mi) |
|-----------|-----------------|---------------|---------------------|-------------------|
| ibm-wfps-operator | 100 | 500 | 20 | 500 |

**Pod Name Convention:** `<metadata.name>-wfps-operator`

---

## Operational Decision Manager (ODM)

ODM provides decision services and business rules management for the authoring environment.

### ODM Decision Center (Small Profile)

| Component | CPU Request (m) | CPU Limit (m) | Memory Request (Mi) | Memory Limit (Mi) |
|-----------|-----------------|---------------|---------------------|-------------------|
| ibm-odm-operator | 10 | 500 | 256 | 768 |

**Capabilities:**
- Business rules authoring
- Decision tables
- Decision services
- Integration with BAW

**Pod Name Convention:** `<metadata.name>-odm-decisioncenter`

---

## Automation Decision Services (ADS)

ADS provides advanced decision modeling and automation capabilities.

### ADS Requirements (Small Profile)

| Component | CPU Request (m) | CPU Limit (m) | Memory Request (Mi) | Memory Limit (Mi) |
|-----------|-----------------|---------------|---------------------|-------------------|
| ibm-ads-operator | 10 | 500 | 64 | 512 |

**Pod Name Convention:** `<metadata.name>-ads-runtime`

---

## Business Automation Insights (BAI)

BAI provides analytics and monitoring for business automation processes.

### BAI Requirements (Small Profile)

| Component | CPU Request (m) | CPU Limit (m) | Memory Request (Mi) | Memory Limit (Mi) |
|-----------|-----------------|---------------|---------------------|-------------------|
| ibm-insights-engine-operator | 500 | 1000 | 256 | 2048 |

**Capabilities:**
- Process analytics
- Performance monitoring
- Business dashboards
- Historical data analysis

**Pod Name Convention:** `<metadata.name>-bai-bpmn`

---

## Database Requirements

### Supported Databases

CP4BA 25.0.0 supports the following databases for small profile deployments:

1. **IBM Db2** (Recommended)
2. **PostgreSQL** (EDB Postgres)
3. **Oracle Database**
4. **Microsoft SQL Server**

### Database Sizing Guidelines (Small Profile)

| Database Component | Minimum Size | Recommended Size | Purpose |
|-------------------|--------------|------------------|---------|
| GCD (Global Configuration Database) | 5 GB | 10 GB | Content Platform Engine configuration |
| Object Store Database | 20 GB | 50 GB | Document storage metadata |
| BAW Database | 10 GB | 25 GB | Workflow and process data |
| ODM Database | 5 GB | 10 GB | Decision services data |
| BAI Database | 10 GB | 20 GB | Analytics and monitoring data |

**Total Estimated Database Storage:** 50-115 GB

---

## Storage Requirements

### Persistent Volume Claims (PVC)

| Storage Type | Size (Small Profile) | Access Mode | Purpose |
|--------------|---------------------|-------------|---------|
| Content Storage (Object Store) | 100 GB | ReadWriteMany | Document content files |
| BAW File Storage | 20 GB | ReadWriteMany | Process application files |
| Logs Storage | 10 GB | ReadWriteOnce | Application logs |
| Backup Storage | 50 GB | ReadWriteMany | Database backups |

**Total Persistent Storage:** ~180 GB minimum

### Ephemeral Storage

Ephemeral storage is used for temporary data and is tied to pod lifecycle. The `/bin/df` tool can monitor ephemeral storage usage.

**Recommendation:** Ensure adequate ephemeral storage quotas are set at the namespace level.

---

## OpenShift Container Platform Requirements

### Minimum Cluster Configuration (Small Profile)

| Resource | Requirement |
|----------|-------------|
| **Worker Nodes** | 8 nodes minimum |
| **Node CPU** | 16 cores per node (Intel amd64 or x86_64) |
| **Node Memory** | 32 GB per node |
| **OpenShift Version** | 4.12+ |
| **Kubernetes Version** | 1.25+ |

### Total Cluster Resources (Small Profile)

| Resource Type | Total Requirement |
|---------------|-------------------|
| **Total CPU** | 128 cores (8 nodes × 16 cores) |
| **Total Memory** | 256 GB (8 nodes × 32 GB) |
| **Storage Class** | RWX (ReadWriteMany) capable storage |

---

## Network Requirements

### Port Requirements

| Service | Port | Protocol | Purpose |
|---------|------|----------|---------|
| CP4BA Console | 443 | HTTPS | Web console access |
| Process Portal | 443 | HTTPS | Workflow user interface |
| Process Designer | 443 | HTTPS | Authoring tool |
| REST APIs | 443 | HTTPS | Integration endpoints |
| Database | 50000 (Db2) / 5432 (PostgreSQL) | TCP | Database connections |

### Network Policies

- Ensure network policies allow communication between CP4BA pods
- Configure ingress/routes for external access
- Set up proper firewall rules for database connectivity

---

## Licensing Requirements

### Small Profile License Considerations

For a small profile authoring environment with **10 developers and 25 users**, you need:

1. **CP4BA Authoring License**
   - Covers Process Designer and authoring tools
   - Required for developers creating process applications

2. **Virtual Processor Core (VPC) Licensing**
   - Based on the number of VPCs allocated to CP4BA pods
   - Small profile typically requires licensing for foundational services

3. **User-Based Licensing**
   - Named user licenses for developers
   - Concurrent user licenses for runtime users

**Note:** Consult with IBM Sales or licensing team for exact entitlements based on your deployment.

---

## Installation Considerations

### Pre-Installation Checklist

- [ ] OpenShift cluster with 8+ worker nodes provisioned
- [ ] Storage classes configured (RWX and RWO)
- [ ] Database instances created and accessible
- [ ] LDAP/Active Directory configured for user authentication
- [ ] SSL certificates prepared for secure communications
- [ ] Network connectivity verified between all components
- [ ] Sufficient resource quotas set at namespace level

### Installation Parameters

```yaml
sc_deployment_profile_size: small
sc_deployment_type: production
shared_configuration:
  sc_deployment_license: non-production
```

### Deployment Time Estimate

- **Initial Installation:** 2-4 hours
- **Configuration:** 4-8 hours
- **Testing and Validation:** 4-8 hours
- **Total:** 1-2 days for complete setup

---

## Scaling Considerations

### Scaling from Small to Medium Profile

The small profile can be scaled to medium or large profiles after installation:

1. Update `sc_deployment_profile_size` parameter
2. Increase worker node count (16 nodes for medium)
3. Scale up database resources
4. Adjust storage allocations
5. Update resource quotas

**Important:** Scaling down from medium/large to small is not supported if another Cloud Pak specifies medium/large profile.

---

## Monitoring and Performance

### Key Metrics to Monitor

1. **CPU Utilization**
   - Target: < 70% average utilization
   - Alert threshold: > 85%

2. **Memory Usage**
   - Target: < 75% average utilization
   - Alert threshold: > 90%

3. **Storage Capacity**
   - Monitor PVC usage
   - Plan for growth (20-30% annually)

4. **Database Performance**
   - Query response times
   - Connection pool utilization
   - Transaction throughput

### Performance Testing Recommendations

Conduct performance testing with peaked workload in a test or UAT environment to:
- Validate resource allocations
- Identify bottlenecks
- Adjust CPU/memory limits as needed
- Optimize database queries

---

## High Availability Considerations

**Note:** The small profile does **NOT** include high availability (HA) configuration.

For HA requirements:
- Use **Medium** or **Large** profile
- Minimum 3 nodes for most services
- Configure failover mechanisms
- Implement load balancing

---

## Backup and Recovery

### Backup Strategy

1. **Database Backups**
   - Daily full backups
   - Transaction log backups every 15 minutes
   - Retention: 30 days

2. **Persistent Volume Backups**
   - Weekly snapshots of PVCs
   - Retention: 4 weeks

3. **Configuration Backups**
   - Export CR (Custom Resource) definitions
   - Store in version control
   - Update after each configuration change

### Recovery Time Objectives (RTO)

- **Database Recovery:** 2-4 hours
- **Application Recovery:** 1-2 hours
- **Total RTO:** 4-6 hours

---

## Security Considerations

### Authentication and Authorization

- **LDAP Integration:** Required for user authentication
- **Role-Based Access Control (RBAC):** Configure appropriate roles
- **Service Accounts:** Use dedicated service accounts for integrations

### Encryption

- **Data in Transit:** TLS 1.2+ for all communications
- **Data at Rest:** Enable database encryption
- **Secrets Management:** Use OpenShift secrets for sensitive data

### Security Scanning

- Regular vulnerability scanning of container images
- Keep CP4BA updated with latest security patches
- Monitor IBM security bulletins

---

## Support and Maintenance

### Maintenance Windows

Recommended maintenance schedule:
- **Monthly:** Apply security patches
- **Quarterly:** Minor version updates
- **Annually:** Major version upgrades

### Support Resources

- **IBM Documentation:** https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/25.0.0
- **IBM Support:** https://www.ibm.com/mysupport
- **Red Hat Support:** For OpenShift-related issues

---

## Summary Table: Small Profile Resource Requirements

| Component | CPU Request | CPU Limit | Memory Request | Memory Limit | Replicas |
|-----------|-------------|-----------|----------------|--------------|----------|
| CP4BA Operator | 500m | 1000m | 256Mi | 2048Mi | 1 |
| Content Operator (CPE) | 500m | 1000m | 256Mi | 2048Mi | 1 |
| CSS | 500m | 1000m | 256Mi | 2048Mi | 1 |
| BAW Operator | 100m | 500m | 20Mi | 500Mi | 1 |
| WFPS Operator | 100m | 500m | 20Mi | 500Mi | 1 |
| ODM Operator | 10m | 500m | 256Mi | 768Mi | 1 |
| ADS Operator | 10m | 500m | 64Mi | 512Mi | 1 |
| BAI Engine | 500m | 1000m | 256Mi | 2048Mi | 1 |

**Total Estimated Resources:**
- **CPU Request:** ~2.2 cores
- **CPU Limit:** ~6 cores
- **Memory Request:** ~1.3 GB
- **Memory Limit:** ~10 GB

**Note:** These are operator-level requirements. Actual workload pods will require additional resources based on usage patterns.

---

## Appendix A: Useful Commands

### Check Resource Usage

```bash
# Check pod resource usage
oc top pods -n <namespace>

# Check node resource usage
oc top nodes

# Check PVC usage
oc get pvc -n <namespace>

# Check ephemeral storage
oc exec <pod-name> -n <namespace> -- df -h
```

### Scaling Operations

```bash
# Scale a deployment
oc scale deployment <deployment-name> --replicas=<count> -n <namespace>

# Update resource limits
oc set resources deployment <deployment-name> \
  --limits=cpu=2,memory=4Gi \
  --requests=cpu=1,memory=2Gi \
  -n <namespace>
```

---

## Appendix B: Troubleshooting

### Common Issues

1. **Pod Pending State**
   - Check resource availability on nodes
   - Verify PVC binding status
   - Review pod events: `oc describe pod <pod-name>`

2. **Performance Issues**
   - Monitor CPU/memory usage
   - Check database connection pools
   - Review application logs

3. **Storage Issues**
   - Verify storage class configuration
   - Check PVC provisioning
   - Monitor storage capacity

---

## Document Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-27 | IBM Bob | Initial document creation based on CP4BA 25.0.0 documentation |

---

## References

1. IBM Cloud Pak for Business Automation 25.0.0 Documentation
   - https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/25.0.0

2. Planning for a CP4BA multi-pattern production deployment
   - System requirements section

3. Deployment profiles and estimated workloads
   - Table 2: Small profile specifications

4. Hardware requirements and recommendations for foundational services
   - Component-specific sizing tables

---

**End of Document**