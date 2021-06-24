---
title: Using client and server certificates to secure ESP32 connections
excerpt: >-
  This article will show you some simple steps of how to use client and server certificates to secure your communications and to achieve mutual authentication. 
date: '2021-06-20'
thumb_image: images/Client-Server-Figure-1.jpg
image: images/Client-Server-Figure-1.jpg
layout: post
---

Once we have our ESP32 modules up and communicating on the network, we start looking to integrate them into cloud frameworks such as Azure or AWS IoT. We quickly discover the need to pick up a basic knowledge of how secure connections work since these are a fundamental building block of integrating our nodes with these cloud frameworks.

This article will show you some simple steps of how to use client and server certificates to secure your communications and to achieve mutual authentication. This means that you know that you are talking to a verified server, and the server knows that you are a verified client. This kind of mutual authentication is important for critical operations such as over-the -air updates.

Let's begin by taking a look at an example. We will build this example around the OTA capabilities built into the ESP-IDF framework (V4.2). The ESP-IDF OTA capabilities are quite sophisticated. In addition to optionally handling signed images, rollbacks, versioning etc, the framework provides the ability to do this over secure connections.

The basic outline of how this happens is shown in Figure(1)

![](/images/Client-Server-Figure-1.png)
<p align="center"><small><b>Figure (1)</b></small></p>


1) The OTA image is stored in a location where it is accessible to download via an HTTPS request from the node
2) The node is setup with additional partitions to hold at least the OTA images, and the OTA app.
3) The node, on reset, or on first boot, triggers the OTA process.
4) The node then connects up to an HTTPS server and downloads the OTA into a separate OTA partition.
5) After verifying and flashing the OTA, the node reboots and starts executing the new application.

Information about the HTTPS server address could be made available to the node either as part of the initial flash of an image, or by booting the node into AP mode where a local host can initialize the device appropriately.

In this example, we will use AWS S3 as the storage location for OTA updates for our ESP32 product. OTA images are stored (encrypted) on S3. Normally, bundles/files on S3 are not available over HTTPS. However we will use S3 pre-signed URLS that enable us to provide short-term access to our OTA images. This fits the model where the node can access a standard OTA URL hosted on an OTA server, and on being authenticated, can be given a pre-signed URL to use for the OTA.

In order to have a secure connection established, the node must know which server to connect to and must know the server certificate in advance. With this information the node can connect to the server and verify it by validating the peers server certificate.

We must therefore obtain the X509 certificate of our end-point. The easiest way to do this is to use openssl as follows to connect to the server

    openssl s_client -showcerts -connect SERVER:443 </dev/null

The details of the certificate chain (the certificate, the list of signers in the signing chain and the root) will be printed on the console.  Note that the full certificate chain is required so that the node can establish that the server certificate is signed by a well-known (root) certificate signer.

In our case, when we connect up to our pre-signed S3 link (which happens to be in the US east region), we see that the certificate chain consists of two certificates. We concatenate the two certificates into the ca_cert.pem file that ESP-IDF asks us to place in the server_certs directory of our project, so that the build system can automatically add the certificates to our node application image.

In Figure (2) we see that the S3 certificate is issued with the Common Name (CN) s3.amazonaws.com, and the the certificate is issued by DigiCert Baltimore CA-2 G2.

![](/images/Client-Server-Figure-2.jpg)
<p align="center"><small><b>Figure (2)</b></small></p>


in Figure (3) we inspect the Digicert Certificate and see that it is signed by Baltimore CyberTrust Root, which is a root certificate.

![](/images/Client-Server-Figure-3.jpg)
<p align="center"><small><b>Figure (3)</b></small></p>

You may be wondering, how is it that the AWS S3 region is US-East and the certificate is for s3.amazonaws.com. There exists the capability to use a single certificate to authenticate multiple sub-domains of a given domain, typically by using a wild-card CN like *.amazonaws.com. This does not seem to be the case here. While wildcard names were common usage, that functionality is being subsumed by the usage of a capability called Subject Alternative Names (SAN). A SAN is an extension to the X.509 specification that allows users to specify additional host names for the SSL certificate. While SAN hostnames are not specifically limited, there usually exist some limitations that are imposed by the certificate signer.

In Figure(4) we examine the SAN field of the S3 certificate and note that in addition to a wildcard for subdomains of s3.amazonaws.com it also includes several other AWS S3 domains. The advantage of course is that we don't need separate S3 certificates depending on our region or location, but can use this single certificate chain for our accesses.

![](/images/Client-Server-Figure-4.jpg)
<p align="center"><small><b>Figure (4)</b></small></p>

There is one more step that we have to take complete the requirements for server authentication. When the node connects to the server and receives the server certificate, it has to validate the certificate chain. In order to do so, the node needs to know that the certificate(chain) is signed by a trusted CA. ESP-IDF, by default uses a restricted set of recognized validated root server certificates, and it is possible that when the server presents its certificate(s), the node cannot find the signer in its list of recognized signers. Fortunately, ESP-IDF allows us to over-ride the bundle of accepted signers as a configuration option in the menuconfig file for mbedtls. Mozilla provides a list of some 130+ trusted certificates that are used by Firefox, and that can be downloaded directly from Mozilla. Use this list to download the subset of trusted certificates you want the node house, making sure that the Root Certificate signer for the server is included.

Once you have completed these steps, you will be able to have the node issue a request using the pre-signed S3 URL as the link for the OTA image file, and complete the OTA.

We now need to look at how to have the node prove to the server that it is authorized to connect.  When a server is configured for client certificate authentication, at the time the node tries to connect to the server, the server sends a request to the client for its certificate along with a list of supported CA names. The node sends its client certificate and uses its private key to generate a hash that the server can verify using the public key of the node. This process is outlined in Figure (5)

![](/images/Client-Server-Figure-5.png)
<p align="center"><small><b>Figure (5)</b></small></p>

The node therefore must hold a signed client certificate and  private key, where the client certificate is signed by a CA known to the server..

Client and server authentication are controlled by mbedtls configuration flags. These are described in the ESP32-IDF documentation under the Certificate Bundle and ESP HTTP Client sections.
