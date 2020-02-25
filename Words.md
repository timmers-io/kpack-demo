# Cloud Native Buildpacks and kpack Vocabulary

(sourced from the [kpack repo](https://github.com/pivotal/kpack) and the CNBP concepts page)

## Cloud Native Buildpacks (CNBP) concepts

 **Buildpack**
 A buildpack is a unit of work that inspects your app source code and formulates a plan to build and run your application. More [here](https://buildpacks.io/docs/concepts/components/buildpack/).

 **Stack**
 A stack provides the buildpack lifecycle with build-time and run-time environments in the form of images. More [here](https://buildpacks.io/docs/concepts/components/stack/).

 **Lifecycle**
 The lifecycle orchestrates buildpack execution, then assembles the resulting artifacts into a final app image. More [here](https://buildpacks.io/docs/concepts/components/lifecycle/).

 **Build**
 Build is the process of executing one or more buildpacks against the app’s source code to produce a runnable OCI image. More [here](https://buildpacks.io/docs/concepts/operations/build/).

**Builder**
A builder is an image that bundles all the bits and information on how to build your apps, such as buildpacks and build-time image, as well as executes the buildpacks against your app source code. More [here](https://buildpacks.io/docs/concepts/components/builder/).

**Rebase**
Rebase allows app developers or operators to rapidly update an app image when its stack's run image has changed. More [here](https://buildpacks.io/docs/concepts/operations/rebase/).
 

## Kubernetes Native Container Build Service (kpack) concepts

**Images**
Images provide a configuration for kpack to build and maintain a docker image utilizing Cloud Native Buildpacks. More [here](https://github.com/pivotal/kpack/blob/master/docs/image.md).

**Secrets**
kpack utilizes kubernetes secrets to configure credentials to publish images to docker registries and access private github repositories. More [here](https://github.com/pivotal/kpack/blob/master/docs/secrets.md).

**Builders**
In kpack the Builder and ClusterBuilder resources are a reference to a Cloud Native Buildpacks builder image. More [here](https://github.com/pivotal/kpack/blob/master/docs/builders.md).

**Builds**
A Build is a resource that schedules and run a single Cloud Native Buildpacks build. More [here](https://github.com/pivotal/kpack/blob/master/docs/build.md).

**CustomBuilders**
kpack provides the experimental CustomBuilder and CustomClusterBuilder resources to define and create Cloud Native Buildpacks builders all within the kpack api. More [here](https://github.com/pivotal/kpack/blob/master/docs/custombuilders.md).
