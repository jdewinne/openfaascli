package function

import (
	"os"
	"time"

	faasflow "github.com/faasflow/lib/openfaas"
)

// Define provide definition of the workflow
func Define(flow *faasflow.Workflow, context *faasflow.Context) (err error) {
	namespace := os.Getenv("namespace")
	domain := os.Getenv("domain")
	flow.SyncNode().Apply(domain + "-cause-problem-part1." + namespace).Modify(func(data []byte) ([]byte, error) {
		time.Sleep(60 * time.Second) // Wait a minute before calling next one.
		return data, nil
	}).Apply(domain + "-cause-problem-part2." + namespace)
	return
}

// OverrideStateStore provides the override of the default StateStore
func OverrideStateStore() (faasflow.StateStore, error) {
	// NOTE: By default FaaS-Flow use consul as a state-store,
	//       This can be overridden with other synchronous KV store (e.g. ETCD)
	return nil, nil
}

// OverrideDataStore provides the override of the default DataStore
func OverrideDataStore() (faasflow.DataStore, error) {
	// NOTE: By default FaaS-Flow use minio as a data-store,
	//       This can be overridden with other synchronous KV store
	return nil, nil
}
