FROM alpine:3.10

ENV ANSIBLE_VERSION=2.9.12

RUN set -xe \
    && echo "****** Install system dependencies ******" \
    && apk add --no-cache --progress python3 openssl \
    ca-certificates git openssh rpm sshpass \
    && apk --update add --virtual build-dependencies \
    python3-dev libffi-dev openssl-dev build-base \
    \
    && echo "****** Install ansible and python dependencies ******" \
    && pip3 install --upgrade pip \
    && pip3 install ansible==${ANSIBLE_VERSION} boto3 \
    && echo "****** Remove unused system librabies ******" \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* 

COPY . /ansible

WORKDIR /ansible

RUN ansible-galaxy collection install f5networks.f5_modules -p ./collections

CMD [ "sh" ]