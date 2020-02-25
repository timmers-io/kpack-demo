# kpack-demo

This is a repo containing scripts to install kpack on an existing K8's cluster. It's meant to demo the product, so there are some things assumed. Like,

  - You already have a healthy K8's cluster, and have loaded its context in your profile's config file.
  - When installing the needed ClusterBuilder the `cloudfoundry/cnb:bionic` is used.
  - The image repository of choice is Docker Hub.
  - A generic `docker-service-account` is created for use throughout the cluster. As opposed to a service-account specific to an app.

## Getting Started

1. List your installed cluster contexts.

 ```bash
 $ kubectl config get-contexts
 ```

1. Using the name retrieved from above output, set your context for `kubectl` interactions.

 ```bash
 $ kubectl config use-context <CONTEXT_NAME>
 ```

1. Head over to the [releases](https://github.com/pivotal/kpack/releases) page in the kpack repo to download the latest yaml asset. (The install script will ask for its location)

1. Clone this repo.

```bash
$ git clone https://github.com/ddieruf/kpack-demo.git
```

1. Provide credentials for interacting with Docker Hub in the `Install-kpack/kpack-assets.yaml` file.

1. Run the install script to get everything going. Pass in the location of the kpack manifest downloaded earlier.

```bash
$ ./kpack-demo/Install-kpack/install-kpack.sh ./release-XXX.yaml
```

1. If the script was able to run successfully, it should exit with no error messages and a final "success" message.

1. You are ready to use kpack with an application. Have a look at the preconfigured [.NET Core project](https://github.com/ddieruf/kpack-demo-dotnet).

## Extra Credit

If you would like to see the kpack things created try any one of the below commands.

See the namespace created for kpack things:
```bash
kubectl describe namespace "kpack"
```

List the installed ClusterBuilder details, along with what buildpacks were included:
```bash
kubectl describe clusterbuilder "cloud-foundry"
```

List the pods included in the kpack namespace:
```bash
kubectl get pods --namespace "kpack"
```