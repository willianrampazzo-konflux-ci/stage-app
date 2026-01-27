# Test Resources for exchange-service-account-token Task

These resources are used to test the `exchange-service-account-token` task in the
`run-collectors` pipeline. The task exchanges a Kubernetes service account token
(with `rhacs` audience) for an ACS authentication token.

## Prerequisites

1. Access to a Konflux stage environment with namespace `wrampazz-tenant`
2. An application `wrampazz-stage-app` with at least two snapshots
3. The `build-pipeline-stage-app-a31cb` service account (created by Konflux)

## Setup

Apply the RBAC resources first (only needed once):

```bash
oc apply -f resources/rbac.yaml
```

## Test Cases

### Test 1: No sbomdiff collector (task should be SKIPPED)

Verifies that `exchange-service-account-token` is skipped when no sbomdiff collector
is defined in the ReleasePlan.

```bash
# Apply resources
oc apply -f resources/test1-no-sbomdiff/releaseplan.yaml
oc apply -f resources/test1-no-sbomdiff/release.yaml

# Run the pipeline
oc create -f resources/test1-no-sbomdiff/pipelinerun.yaml

# Monitor
PR_NAME=$(oc get pipelinerun -n wrampazz-tenant -l test.konflux.dev/case=no-sbomdiff \
  --sort-by=.metadata.creationTimestamp -o name | tail -1 | cut -d/ -f2)
tkn pr logs -f $PR_NAME -n wrampazz-tenant

# Verify task was SKIPPED
oc get pipelinerun $PR_NAME -n wrampazz-tenant -o jsonpath='{.status.skippedTasks}' | jq .
```

**Expected**: `exchange-service-account-token` appears in `skippedTasks`

### Test 2: With sbomdiff collector (task should RUN)

Verifies that `exchange-service-account-token` runs when a sbomdiff collector is defined.
No previous release is provided, so sbomdiff will skip the comparison.

```bash
# Apply resources
oc apply -f resources/test2-with-sbomdiff/releaseplan.yaml
oc apply -f resources/test2-with-sbomdiff/release.yaml

# Run the pipeline
oc create -f resources/test2-with-sbomdiff/pipelinerun.yaml

# Monitor
PR_NAME=$(oc get pipelinerun -n wrampazz-tenant -l test.konflux.dev/case=with-sbomdiff \
  --sort-by=.metadata.creationTimestamp -o name | tail -1 | cut -d/ -f2)
tkn pr logs -f $PR_NAME -n wrampazz-tenant

# Verify token exchange ran
oc get taskrun -n wrampazz-tenant \
  -l tekton.dev/pipelineRun=$PR_NAME,tekton.dev/pipelineTask=exchange-service-account-token
```

**Expected**: `exchange-service-account-token` TaskRun exists and logs show successful token exchange

### Test 3: With sbomdiff and previous release (full ACS scan)

Verifies the complete flow: token exchange + ACS vulnerability scanning + CVE diff.

```bash
# Apply resources
oc apply -f resources/test3-sbomdiff-with-previous/releaseplan.yaml
oc apply -f resources/test3-sbomdiff-with-previous/release.yaml

# Run the pipeline
oc create -f resources/test3-sbomdiff-with-previous/pipelinerun.yaml

# Monitor
PR_NAME=$(oc get pipelinerun -n wrampazz-tenant -l test.konflux.dev/case=sbomdiff-compare \
  --sort-by=.metadata.creationTimestamp -o name | tail -1 | cut -d/ -f2)
tkn pr logs -f $PR_NAME -n wrampazz-tenant
```

**Expected**:
- Token exchange succeeds
- ACS scans both images
- CVE diff is generated in the collector output

## Cleanup

```bash
# Delete PipelineRuns
oc delete pipelinerun -n wrampazz-tenant -l tekton.dev/pipeline=run-collectors

# Delete Test 1 resources
oc delete -f resources/test1-no-sbomdiff/release.yaml --ignore-not-found
oc delete -f resources/test1-no-sbomdiff/releaseplan.yaml --ignore-not-found

# Delete Test 2 resources
oc delete -f resources/test2-with-sbomdiff/release.yaml --ignore-not-found
oc delete -f resources/test2-with-sbomdiff/releaseplan.yaml --ignore-not-found

# Delete Test 3 resources
oc delete -f resources/test3-sbomdiff-with-previous/release.yaml --ignore-not-found
oc delete -f resources/test3-sbomdiff-with-previous/releaseplan.yaml --ignore-not-found

# Optionally delete RBAC (if no longer needed)
oc delete -f resources/rbac.yaml --ignore-not-found
```

## Notes

- The `build-pipeline-stage-app-a31cb` service account is used because it matches the
  ACS M2M rule pattern: `system:serviceaccount:.*-tenant:build.*`
- The `save-collectors-results` and `cleanup` tasks may fail due to missing permissions,
  but this doesn't affect the core functionality being tested
- Snapshots referenced in release.yaml files may need to be updated to valid snapshots
  in your environment
