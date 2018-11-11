Supporting project for my presentation `The path to high availability`
-


#### Overview of the tools used to run this project

- Cloud provider: [Digital Ocean](https://www.terraform.io/intro/getting-started/install.html). Hosts yours infrastructure artefacts like compute/storage objects, domains, firewalls, load balancers. This is where you get your digital ocean `API_KEY`. Without it your Cloud infrastructure design tool can't work.
- Cloud infrastructure design tool: [Terraform](https://www.terraform.io/intro/getting-started/install.html). Describes your infrastructure, creates/destroys it via simple commands
- Provisioning tool: [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). Configures whatever is required for a running environment. Orchestrates provisioning between multiple compute machines which form a coherent group. Targets `hosts` of the same `group`
- Ansible & Terraform integration
    - hosts (IP, groups mostly) variables outputed in a special section of the tfstate: [terraform ansible provider](https://github.com/nbering/terraform-provider-ansible). Creates ansible inventory output in the `tfstate` file. It's a [terraform plugin](https://www.terraform.io/docs/plugins/basics.html#installing-a-plugin)
    - [Dynamic inventory](http://docs.ansible.com/ansible/latest/intro_dynamic_inventory.html) based on a `tfstate` file: [terraform inventory](https://github.com/nbering/terraform-provider-ansible) 
- [Ansible Galaxy](https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file). Github for ansible playbooks. Downloaded and made available in your ansible environment

#### Goal of the project

Provide a working basis for an HA architecture of a classical micro service.

The service persists in cockroachdb, a natively distributed, SQL compliant database.

The service uses spring-boot stack.

The service is proxied, balanced and served with nginx.

Coackroachdb does not provide a cluster client, rather single nodes client. This makes it impossible for JDBC drivers to operate them in a HA mode. Therefore, we introduced consul to act as the service discovery component as well as DNS server. Consul is the key component that makes all this possible

The main requirement is to be `resilient to datacenter outage`. 

This constraint affects the way we design the infrastructure but does not affect the rest of the stack. We need to carefully distribute hosts so that no datacenter owns the quorum majority. Actually it was consul and cockroach who imposed the main infrastructure architecture because they both use the [Raft](https://raft.github.io/) consensus algorithm to implement HA and node failover resiliency. 

To make our point the following scenario has been implemented

1. create the infrastructure
    - 3 consul instances on 3 datacenters
    - 3 cockroach instances on 3 datacenters
    - 2 backend instances on 2 datacenters
    - 2 nginx instances on 2 datacenters
2. provision/configure the hosts
    - register hosts to avoid ssh fingerprint prompt
    - install+configure consul servers
    - install+configure consul clients (cockroach servers, backends, load balancer)
    - install+configure cockroach servers
    - create db, users, schemas 
    - install+configure backends
    - install+configure load balancers
    - register domains to reach load balancer
3. generate traffic: traffic app will behave as our IoT devices: try `primary` datacenter and fallback to `fallback` datacenter if `primary` is unavailable
4. outage `primary` datacenter and note that traffic is routed to `fallback` datacenter
5. restore `primary` datacenter and note that traffic is routed back to `primary` datacenter
6. destroy the infrastructure (just because I don't want my billing to explode :smiling_face:)

#### Overview of the project layout

I'm a big fan of intent oriented layouts because they are more expressive (first tell us what you try to achieve, then how you did it)  but I kind of mixed both for this project, sorry about that. 

- `terraform`: infrastructure design implementation (compute/storage instances) 
    - `provider.tf`: ssh credentials and API_KEY from environment
    - `hademo.tf`: main infrastructure descriptor
- `ansible`: provisioning implementation (playbooks, roles and group vars)
    - `sos.yml`: main playbook
    - `outage.yml`: shut downs all `primary` datacenter services (nginx, backend, cockroach, consul)
    - `restore.yml`: restores `primary` datacenter services (nginx, backend, cockroach, consul)
    - `cleanup_dns_entries.yml`: cleans public dns entries (api, consul ui, corporate website)
- `sos`: spring-boot backend implementation
- `traffic`: spring-boot traffic implementation
- `demo`: bash script to support me during the demo. Helps avoid typos and save time with long commands
