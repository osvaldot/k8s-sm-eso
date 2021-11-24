ARG TERRAFORM_VERSION
ARG KUBECTL_VERSION
ARG AWS_IAM_AUTH_VERSION

FROM hashicorp/terraform:${TERRAFORM_VERSION}

RUN apk add --no-cache bash aws-cli curl openssl make

# RUN curl -L -o /usr/local/bin/kubectl https://dl.k8s.io/release/v1.22.4/bin/linux/amd64/kubectl 
RUN curl -L -o /usr/local/bin/kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl 
RUN chmod +x /usr/local/bin/kubectl 
RUN echo 'alias k=kubectl' >> $HOME/.bashrc
