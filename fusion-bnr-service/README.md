# OpenShift Extension Cleanup

This workspace contains a script to find and delete the following OpenShift objects:

- `icp4adeploy-ban-zen-extension`
- `icp4adeploy-cmis-zen-extension`
- `icp4adeploy-cp4ba-zen-extension`
- `icp4adeploy-cpe-zen-extension`
- `icp4adeploy-graphql-zen-extension`
- `icp4adeploy-workspace-aae-zen-ext`

## Usage

1. Ensure `oc` is installed and you are logged in to the target OpenShift cluster.
2. Run:

```bash
bash delete-openshift-extensions.sh
```

The script will search available resources and delete any matching objects.
