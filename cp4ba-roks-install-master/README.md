# IBM Technology Zone - Cloud Pak for Business Automation on Red Hat OpenShift on IBM Cloud (ROKS)

Last Updated: 2021-12-06

### Are you a technical IBMer or Business Partner with access to Technology Zone and validated technical skill on CP4BA (also encompassing CP4Auto moving forward)?

### Prerequisites:
  * IBMer with access to [Technology Zone](https://techzone.ibm.com)
  * experience with OpenShift Container Platform (OCP) and the oc / ibmcloud CLIs
  * experience with Cloud Pak for Business Automation (or willingness to learn!)

******

## Need Support?

Please see [Support and additional resources](#support-and-additional-resources) below.

***

All IBMers should begin their demos of CP4BA in the NextGen SaaS infrastructure, if possible.  Please see the Technical Sales Guide and additional resources at the following IBM Technology Zone collection: http://ibm.biz/nextgen-dbaoc.

There are reasons you may need to use ROKS.  The most common are...

  * ...containerized components not available in SaaS including but not limited to Automation Decision Services, Automation Document Processing and Workflow Authoring in Business Automation Studio as of the 4Q 2020 NextGen demo tenants).
  * ...a requirement to demonstrate non-SaaS infrastructure including operations in the OpenShift web console.
  * ...a prototype or PoC that may not be built or demonstrated on shared infrastructure for privacy, direct client access or another opportunity specific consideration.

If you still feel that you are in the right place, let's continue!

***

## To get started, let's choose a blank or preinstalled cluster

[Blank Cluster](Additional-files/README-blank-cluster.md) - I want to do the install of the cloud pak all on my own!  This is the recommended option for Proofs of Concept (PoCs) or similar usage that requires long term usage (more 2 weeks) and more control on what and how the pak is installed.

[Preinstalled Cluster](Additional-files/README-preinstalled-cluster.md) - I just care about using the cloud pak, give me everything already installed!  This is the recommended option for most demos and short term usage (around 2 weeks).  This option is not recommended for PoCs.

*****

## Enjoy your use of CP4BA on ROKS!

******

## Support and additional resources

### Support

**Check out the [Troubleshooting](Additional-files/troubleshooting-cluster.md) page to see if your question is answered there.**

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
