# Buildbox Swarm Node

## Usage

__In Dockerfile__

```shell
FROM  reppard/buildbox-swarm-node
```

## Customizing the node

The node is configured via Puppet.  Fork the repository in order to track new
changes.  The swarm node image can be customized by editing the puppet
manifests in the `puppet/` folder.

See the [documentation](https://docs.docker.com/engine/reference/commandline/build/) for more information.
