# Development

## Structure

```
.
├── docker
│   ├── build-image.sh
│   └── Dockerfile            # The image where the tasks are running
├── manifests
│   ├── base-cloud-config.yml
│   ├── deployment.yml        # A single VM running Nginx.
│   └── use-availability-zones.yml
├── pipelines
│   ├── credentials.yml.sample
│   └── pipelines.yml         # It creates several BOSH directors, and run multiple e2e scenarios in parallel. 
├── scenarios
│   ├── accelerated-networking
│   │   ├── cloud-config.yml  # (Required) Define a dedicated subnet where the scenario is running. The subnet is only for this scenario, so that all the scenarios can run in parallel.
│   │   ├──                   #            Define the VM extensions.
│   │   ├── deploy            # (Required) Deploy an instance, run tests, and cleanup the deployment.
│   │   └── ops.yml           # (Optional) Used to add/remove/replace the contents of "manifests/deployment.yml"
│   ├── managed-identity
│   │   ├── cloud-config.yml
│   │   ├── deploy
│   │   ├── use-system-assigned-managed-identity.yml
│   │   └── use-user-assigned-managed-identity.yml
│   ├── manual-network
│   │   ├── cloud-config.yml
│   │   └── deploy
│   ├── multiple-storage-accounts
│   │   ├── cloud-config.yml
│   │   ├── deploy
│   │   └── ops.yml
│   └── network-security-groups
│       └── cloud-config.yml  # A placeholder. The scenario is not implemented yet.
├── tasks
│   ├── e2e-tests
│   │   ├── task
│   │   └── task.yml
│   └── update-cloud-config
│       ├── task
│       └── task.yml
└── terraform                 # Setup the infrastructure
    ├── application_security_groups.tf
    ├── basic_load_balancer.tf
    ├── constants.tf
    ├── director_public_ip.tf
    ├── network_security_group.tf
    ├── networks.tf
    ├── outputs.tf
    ├── provider.tf
    ├── resource_group.tf
    ├── standard_load_balancer.tf
    ├── storage.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    ├── terraform.tfvars
    ├── user_assigned_identity.tf
    ├── variables.tf
    └── vip_public_ip.tf
```

## Add a new scenario

1. Add a new directory under `scenarios`. E.g. `scenarios/accelerated-networking`.

1. Define a new subnet in `scenarios/accelerated-networking/cloud-config.yml`.

    ```
    ---
    - type: replace
      path: /networks/-
      value:
        name: accelerated-networking
        type: manual
        subnets:
        - range: 10.0.16.0/24
          gateway: 10.0.16.1
          azs: [z1, z2, z3]
          dns: [168.63.129.16, 8.8.8.8]
          reserved: [10.0.16.0/30]
          cloud_properties:
            security_group: ((default_security_group))
            virtual_network_name: ((vnet_name))
            subnet_name: subnet-16
    ```

    The subnet `subnet-16` should be only used by this scenario. If there's no available subnet in the virtual network, please increase the `count` of `e2e_subnets` in `terraform/networks.tf`.

1. Define a new `vm_extension` in `scenarios/accelerated-networking/cloud-config.yml`. The feature `Azure Accelerated Networking` will be enabled by this VM extension.

    ```
    - type: replace
      path: /vm_extensions/-
      value:
        name: accelerated-networking
        cloud_properties:
          accelerated_networking: true
    ```

1. Specify the VM extension `accelerated-networking` to the instance group `nginx` in an Ops file.

1. If the scenario needs to configure the CPI global configuration, you need to add a new job to create a new BOSH director in `pipelines/pipelines`. If not, just skip this step and continue.

1. Add a task with the parameter `SCENARIO`, which has to be same with the directory name under "scenarios/". If all directors support the scenario, then the task shoulbe be a common case. Otherwise, it should be only put into some directors.

    ```
    - <<: *run-e2e
      params:
        <<: *azure-environment-params
        SCENARIO: accelerated-networking
    ```

1. `tasks/e2e-tests/task` will run `scenarios/accelerated-networking/deploy`. So you need to run deploy an instance, verify the result and delete the instance in `deploy`.
