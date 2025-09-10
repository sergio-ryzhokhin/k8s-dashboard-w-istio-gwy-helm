## Intro
This is a sample Helm chart that builds on top of Kubernetes Dashboard and pushes it closer to plug-n-play install by exposing it through pre-installed Istio Ingress Gateway. 
This chart performs the following: 

1. Install Kubernetes Dashboard through dependency
1. Define Gateway entity for default/shared Istio Ingress followed by corresponding VirtualService with custom domain mapping
1. Pass through TLS certificate all the way to Kong Gateway used by Kubernetes Dashboard with ability to either specify custom certificate and key files or automatically generate self-signed certificate (domain-specific)
1. Automatically create sample user for Kubernetes Dashboard as per [official documentation](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)

### Disclaimer
Source code in this repository is distributed under Apache 2.0 license (see LICENSE file for details) and on "AS IS" basis, without warranties or conditions of any kind, either express or implied.

## Prerequisites
Make sure you have Istio Ingress Gateway properly installed. You can follow official documentation [here](https://preliminary.istio.io/latest/docs/setup/additional-setup/gateway/), but in a nutshell you'd need to do the following:

1. Add Istio Helm repo

    `helm repo add istio https://istio-release.storage.googleapis.com/charts`

    `helm repo update`

1. Install Istio Base Chart

    `helm install istio-base istio/base -n istio-system --create-namespace`

1. Install Istio Service Discovery Chart (Istio Control Plane)

    `helm install istiod istio/istiod -n istio-system --wait`

1. Install Istio Ingress Gateway Chart

    `helm install istio-ingress istio/gateway -n istio-ingress --create-namespace --wait`
    
    Make sure you've figured out how Istio Gateway would get External IP assigned for it's underlying `LoadBalancer`. If your Kubernetes cluster runs on any of the major cloud providers, it should work out of the box. If you're running test single node Kubernetes cluster it could be as easy as specifying `service.externalIPs` chart value with IP you're using to access corresponding machine. For more complex self-hosted setups you'd probably want to use something like [MetalLB](https://metallb.io/). More details [here](https://preliminary.istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports).

## Installation
Clone this repository or download it as a ZIP and unpack.
Once you have the source code and changed the directory to the root of it, basic installation would take a simple Helm command:

`helm install kubernetes-dashboard ./ -n kubernetes-dashboard --set domain=k8dashboard.example.com --create-namespace`

See Chart Values for additional customization options.

## Chart Values
In addition to values inherited from [Kubernetes Dashboard](https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard?modal=values) and subsequently [Kong Gateway](https://artifacthub.io/packages/helm/kong/kong?modal=values) subchatrs, this chart introduces the following parameters:

* `istioIngressGatewayName` (default value `ingressgateway`) - name of the shared Istio Gateway to expose Kubernetes Dashboard through
* `domain` (default value `localhost`) - domain name to use for Kubernetes Dashboard
* `createAdminUser` (deafult value `true`) - flag that determines if a sample user account should be created automatically
* `adminUsername` (default value `kubernetes-dashboard-user`) - username to use for sample user when it's created automatically
* `customTlsCertFile` - path to custom TLS certificate file to use for HTTPS instead of automatically generated self-signed certificate
* `customTlsKeyFile` - path to custom TLS certificate key file to use for HTTPS instead of automatically generated self-signed certificate

## Uninstall
To uninstall components deployed by this chart run the following Helm command:

`helm delete kubernetes-dashboard -n kubernetes-dashboard`

You also might want to delete corresponding namespace:

`kubectl delete namespace kubernetes-dashboard`
