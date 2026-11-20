# Using a Preinstalled Cloud Pak for Business Automation on Red Hat OpenShift on IBM Cloud (ROKS) Reservation

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

The first step is to reserve your OpenShift cluster.  All IBMers have access to cluster reservations specifically configured to support CP4BA on the IBM Technology Zone site.

1. Go to the [Technology Zone CP4BA Activation Kit](https://techzone.ibm.com/collection/5ef3994456dfa7001728cb5c) and login.
1. Click the **Environments - Reserve Here!** subtab of the CP4BA Activation Kit.
1. Click the OpenShift tile to open the collection.
1. Open the **Preinstalled OpenShift Envionments** subtab.
1. Choose tile for the CP4BA version you prefer.
1. Fill in the form, being sure to carefully read the information embedded about length of reservation and manual extension policy for the selected **purpose**.
1. When selecting your data center location, use one with the lowest storage % even if this is further from your location.  I find the latency is low to any data center around the world assuming you have a strong Internet connection.
1. Submit and wait for your cluster to be ready **(read on to learn more about time expectations)**.

> **_NOTE:_  If your reservation submission fails with an error, you may try a second time.  If it fails again, please wait 30 minutes and check https://techzone.ibm.com/my/reservations to see if the reservation was successful after all before you try again.  For support and errors in Technology Zone, see [Support and additional resources](#support-and-additional-resources) below.**

</details>

<details><summary>2 - Wait for your cluster</summary>

### Cluster readiness expectations
**Demo Pattern Preinstalled Clusters** may be accessible via the IBM Cloud console and OpenShift web console in 20-60 minutes but the operator will still be deploying your CP4BA installation for at least 3 hours and generally not more than 8 hours.

### How will you know when the cluster is ready?

> **_NOTE:_  For issues with any of the steps below, go to the [Troubleshooting](troubleshooting-cluster.md) page.**

1. First, wait for an email with the subject **Your OpenShift Cluster is ready on IBM Cloud** in 30-60 minutes.
    * If you do not receive an email or to check on status, go to IBM Technology Zone's My Library -> My Reservations page.
1. Next, click the link in the email to open the console.
    * You may also need to use the IBM Technology Zone's My Library -> My Reservations page.
1. This should take you to IBM Cloud console for your cluster.
1. Once you can get to your IBM Cloud cluster page, do not proceed until the status shows **Normal** with a green check and an **Ingress subdomain** exists.  If not, refresh the page every few minutes.
1. Click the OpenShift web console button in the upper right.
1. For **Demo Pattern Preinstalled Clusters**, the operator will take 6-8 hours to deploy.
    * **V21.0.x**: The last task within the operator is to generate a config map named `icp4adeploy-cp4ba-access-info` which you can access in the OCP Console under **Workloads** -> **Config Maps** or via the CLI.  If this config map exists, then CP4BA should be ready.
    * **V20.0.3**: The last task within the operator is generally ADS so if this is deployed then we know CP4BA should be ready.
1. Again, for issues with any of the steps above, go to the [Troubleshooting](troubleshooting-cluster.md) page.

> **_NOTE:_  It is not recommended to change the password of `cp4admin`.  Instead, create a new admin user if this is required.**

</details>

<details><summary>3 - Login to CP4BA</summary>

## Get ready!  Get set!  Login!

### V21.0.x

All the URL and user and password information you need will be present in the `icp4adeploy-cp4ba-access-info` config map which you can access in the OCP Console under Workloads -> Config Maps or via the CLI.  When you navigate to an interface and need to login, use Enterprise LDAP and `cp4admin`.

> **_NOTE:_  Be sure to carefully follow the instructions in each section of the config map and open each of the mentioned URLs in your browser to accept the self-signed certificates or you will receive errors.**

> **_NOTE:_  For Automation Document Processing (ADP), in V21.0.1 and before (NOT V21.0.2+), you MUST perform some steps BEFORE using it to manually import sample data.  If you create a project before the import it will not be simple to recover.  See the steps under `Loading sample data for Automation Document Processing` on https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/21.0.x?topic=deployment-installing-capabilities-by-running-script for details.**

### V20.0.3

1. Retrieve the `cp4admin` user’s password (**be sure to use `cp4admin` as the user, do not use `umsadmin`**).  You can use the OpenShift web console or CLI:
    * Using the web console: open Workloads -> Secrets and filter for `ibm-dba-ums-admin-secret-internal`, then scroll to **Data**, click **Reveal Values** and copy the `adminPassword` value.
    * Using the CLI (see [Prerequisites](#prerequisites) to install): access it at the upper right by clicking `IBM#<email>` -> `Copy Login Command` and paste it into a terminal with the CLI installed.  Execute the following commands: `oc get secret ibm-dba-ums-admin-secret-internal -o=jsonpath=“{.data.adminPassword}” | base64 --decode`
1. Retrieve the routes for popular interfaces.  As you did not generate the CR, the cert-kubernetes post-deployment script will not work directly.
    1. Using the web console, open Networking -> Routes
    1. **IMPORTANT**: you must accept the self-signed certificates **BEFORE** you access the cluster within a browser session to avoid errors.  The following tells you which are required:
        * DO NOT expect all the below routes to display a web page, this is expected
        * ALL UIs will require accepting `icp4adeploy-ums-route` and/or `icp4adeploy-ums-sso-route`
        * Workflow (Process Portal and Case Client): `icp4adeploy-pfs-route`, `icp4adeploy-workflow-authoring-baw-server`, `icp4adeploy-navigator-route`
        * Workplace / Workstreams: `icp4adeploy-pbk-ae-service`, `icp4adeploy-workspace-aae-ae-service`, `icp4adeploy-workflow-authoring-baw-server`, `icp4adeploy-pfs-route`
        * Applications in Navigator: `icp4adeploy-pbk-ae-service`, `icp4adeploy-workspace-aae-ae-service`, `icp4adeploy-navigator-route`
        * Business Automation Studio: `icp4adeploy-workflow-authoring-baw-server`, `icp4adeploy-pbk-ae-service`
        * UMS Teams: `icp4adeploy-ums-teams-route`
    1. Retrieve the route for popular interfaces, note the following suffix patterns:
        * Navigator: you must add `/navigator` to the end of the `icp4adeploy-navigator-route` route
        * If you are using a Navigator desktop, the following is further appended to the end of the `icp4adeploy-navigator-route` route after `/navigator`:
            * Applications: `?desktop=appDesktop1`
            * BAW Case Client: `?desktop=baw`
            * Workplace: `?desktop=workplace`
        * Business Automation Studio (used for all web designers including Applications, Decisions (ADS), Document Processing (ADP) and Workflows (BAW)): you must add `/BAStudio` to the end of the bastudio route (note the capitalization is important)
            * Note: the demo pattern for V20.0.3 Automation Document Processing (ADP) is not stable, you should instead use V21.0.1.
        * Process Portal: you must add `/ProcessPortal` to the end of the `icp4adeploy-workflow-authoring-baw-server` route
        * UMS Teams: you must add `/teamserver/ui` to the end of the `icp4adeploy-ums-teams-route` route

</details>

******

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
