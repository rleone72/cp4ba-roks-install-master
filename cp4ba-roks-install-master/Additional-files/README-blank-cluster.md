# Installing Your Own Cloud Pak for Business Automation on Red Hat OpenShift on IBM Cloud (ROKS)

Last Updated: 2021-12-06

### Are you a technical IBMer or Business Partner with access to Technology Zone and validated technical skill on CP4BA (also encompassing CP4Auto moving forward)?

### Prerequisites:
  * experience with OpenShift Container Platform (OCP) and the oc / ibmcloud CLIs
    * install the appropriate **Client-side requirements** from here: [V21.0.x](https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/21.0.x?topic=deployments-preparing-demo-deployment) or [V20.0.x](https://www.ibm.com/support/knowledgecenter/SSYHZ8_20.0.x/com.ibm.dba.install/op_topics/tsk_preparing_demo_.html)
  * experience with Cloud Pak for Business Automation (or willingness to learn!)

***

## Need Support?

Please see [Support and additional resources](#support-and-additional-resources) below.

***

## Instructions (click to expand each section)

<details><summary>1 - Reserve your OpenShift cluster</summary>

The first step is to reserve your OpenShift cluster.  All IBMers and Business Partners have access to cluster reservations specifically configured to support CP4BA on the IBM Technology Zone site.

1. Go to the [Technology Zone CP4BA Activation Kit](https://techzone.ibm.com/collection/5ef3994456dfa7001728cb5c) and login.
1. Click the **Environments - Reserve Here!** subtab of the CP4BA Activation Kit.
1. Click the OpenShift tile to open the collection.
1. Open the **Blank OpenShift Envionments** subtab.
1. Choose tile for the CP4BA version you intend to install.
1. Fill in the form, being sure to carefully read the information embedded about length of reservation and manual extension policy for the selected **purpose**.
1. Submit and wait for your cluster to be ready **(read on to learn more about time expectations)**.

> **_NOTE:_  If your reservation submission fails with an error, you may try a second time.  If it fails again, please wait 30 minutes and check https://techzone.ibm.com/my/reservations to see if the reservation was successful after all before you try again.**

</details>

<details><summary>2 - Wait for your cluster</summary>

### Cluster readiness expectations

**Blank Clusters** are generally used to install CP4BA yourself with an enterprise pattern, they may take from 20-60 minutes to fully provision and be ready for access during normal IBM Cloud operations.  Once ready, check out the [Additional Resources](#additional-resources) section below for more details on installing yourself.

### How will you know when the cluster is ready?

1. First, wait for an email with the subject **Your OpenShift Cluster is ready on IBM Cloud** in 30-60 minutes.
    * If you do not receive an email or to check on status, go to IBM Technology Zone's My Library -> My Reservations page.
1. Next, use the email with the subject **Your OpenShift Cluster is ready on IBM Cloud** and click to open the console.
    * You may also use the IBM Technology Zone's My Library -> My Reservations page.
1. This should take you to IBM Cloud console for your cluster.
1. Once you can get to your IBM Cloud cluster page, check to be sure the status shows **Normal** with a green check and an **Ingress subdomain** exists and do not proceed until they are.
1. Click the OpenShift web console button in the upper right and you are ready to start using the web console or get the login token for the CLI.

</details>

<details><summary>3 - Login to CP4BA</summary>

## Get ready!  Get set!  Login!

If you installed your own CP4BA demo pattern then you can (new in V21.0.x) open the `icp4adeploy-cp4ba-access-info` config map from the OCP Console under Workloads -> Config Maps.  If you are on V20.0.3, you may need use the `/scripts/cp4a-post-deployment.sh` script to generate a list of routes (and possibly logins) available.

If you installed your own CP4BA enterprise pattern, access your cluster based on your own knowledge.

</details>

*****

## Enjoy your use of CP4BA on ROKS!

******

## Support and additional resources

### Support

**Check out the [Troubleshooting](troubleshooting-cluster.md) page to see if your question is answered there.**

IBMers:

  * If you have any questions specific to ROKS or reservation and infrastructure access, please slack [#itz-techzone-support](https://ibm-cloud.slack.com/archives/C0124J683GW) for assistance.
  * If you have any questions specific to CP4BA, support is on a best effort community basis and recommend that you send a slack to [#dba-techsales](https://ibm-cloud.slack.com/archives/CBSQ40JSW) for assistance.

Business Partners:

  * If you have any questions specific to ROKS or reservation and infrastructure access, please email [techzone.help@ibm.com](mailto:techzone.help@ibm.com) for assistance.
  * If you have any questions specific to CP4BA, please use PartnerWorld to access IBM Support and open a case for assistance.

### Additional resources

Looking for additional resources to get you started installing, here is a list I find useful:

* Main Knowledge Center: https://www.ibm.com/support/knowledgecenter/SSYHZ8/kc_welcome_dbamc.html
  * V21.0.x Installing section: https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/21.0.x?topic=automation-installing
  * V20.0.3 Installing section: https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/20.0.x?topic=automation-installing
* TEC CP4BA VMware template: https://pages.github.ibm.com/fadi-sandakly/CP4AutoTemplate/CP4Auto20.0.3/
* CP4BA Installation Guide: https://github.ibm.com/apollo-dba-community/cp4a-installation/
  * One-shot enterprise deployment: https://ibm.biz/cp4ba-enterprise-deployment
* Cloud Adoption Resources: https://pages.github.ibm.com/dwakeman/ibm-cloud-adoption/cloud-paks/biz-automation/
