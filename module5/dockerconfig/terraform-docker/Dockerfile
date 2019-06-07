FROM hashicorp/terraform:0.11.7
RUN apk add --no-cache bash python3 && \
    pip3 install --no-cache-dir awscli

RUN mkdir -p /plugins

# AWS provider
ENV AWS_VERSION=1.16.0
ENV AWS_SHA256SUM=1150a4095f18d02258d1d52e176b0d291274dee3b3f5511a9bc265a0ef65a948

RUN wget https://releases.hashicorp.com/terraform-provider-aws/${AWS_VERSION}/terraform-provider-aws_${AWS_VERSION}_linux_amd64.zip && \
    echo "${AWS_SHA256SUM}  terraform-provider-aws_${AWS_VERSION}_linux_amd64.zip" | sha256sum -c - && \
    unzip *.zip && \
    rm -f *.zip && \
    mv -v terraform-provider-aws_* /plugins/

COPY . /app
WORKDIR /app
ENTRYPOINT []