# kpack-demo

This is a script to install kpack on an existing K8's cluster. It's meant to demo the product, so there are some things assumed. Like,

  - You already have a healthy K8's cluster, and have loaded its context in your profile's config file.
  - The image repository of choice is Docker Hub.
  - You have a Docker Hub account
  - When installing the needed ClusterBuilder the `cloudfoundry/cnb:bionic` is used.
  - A generic `docker-service-account` is created for use throughout the cluster. As opposed to a service-account specific to an app.

To learn more about the kpack project, go [here](https://github.com/pivotal/kpack).
To learn more about the cloud native buildpacks project, go [here](https://buildpacks.io/).

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
    $ git clone https://github.com/ddieruf/kpack-demo.git; cd "kpack-demo"
    ```

1. Provide credentials for interacting with Docker Hub in the `Install-kpack/kpack-assets.yaml` file.

1. Run the install script to get everything going. Pass in the location of the kpack manifest downloaded earlier.
    ```bash
    $ ./Install-kpack/install-kpack.sh ./release-XXX.yaml
    ```

1. If the script was able to run successfully, it should exit with no error messages and a final "success" message.

1. You are ready to use kpack with an application. Have a look at the preconfigured [.NET Core project](https://github.com/ddieruf/kpack-demo-dotnet).

## Extra Credit

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