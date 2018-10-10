FROM centos:7

RUN echo "tsflags=nodocs" >> /etc/yum.conf && \
		yum -y install epel-release centos-release-scl && \
		yum -y install wget git rh-python36-python-pip && \
		yum clean all

ENV PYTHONUNBUFFERED=0
ENV DJANGO_SETTINGS_MODULE=pulpcore.app.settings

RUN mkdir -p /etc/pulp

RUN scl enable rh-python36 'pip install whitenoise'

WORKDIR /root
RUN git clone https://github.com/pulp/pulp.git
RUN git clone https://github.com/pulp/pulp_file.git
RUN git clone https://github.com/pulp/pulp_ansible.git

RUN scl enable rh-python36 'pip install gunicorn'

WORKDIR /root/pulp
RUN scl enable rh-python36 'pip install -e pulpcore/'
RUN scl enable rh-python36 'pip install -e plugin/'

WORKDIR /root/pulp_file
RUN scl enable rh-python36 'pip install -e .'

WORKDIR /root/pulp_ansible
RUN git checkout 20b57227a98a8c8da5a58eb7e32a4e7217beef89
RUN scl enable rh-python36 'pip install -e .'

WORKDIR /root/pulp

COPY container-assets/settings.py /etc/pulp/settings.py
RUN echo "SECRET_KEY = '`cat /dev/urandom | tr -dc 'a-z0-9!@#$%^&*(\-_=+)' | head -c 50`'" >> /etc/pulp/settings.py

RUN mkdir -p /var/lib/pulp/staticfiles

RUN scl enable rh-python36 "pulp-manager makemigrations pulp_app"
RUN scl enable rh-python36 "pulp-manager makemigrations pulp_file"
RUN scl enable rh-python36 "pulp-manager makemigrations pulp_ansible"
RUN scl enable rh-python36 "pulp-manager collectstatic --noinput"

COPY container-assets/wait_on_postgres.py /usr/bin/wait_on_postgres.py
COPY container-assets/pulp_server /usr/bin/pulp_server
COPY container-assets/entrypoint /usr/bin/entrypoint

CMD ["/usr/bin/pulp_server"]
ENTRYPOINT ["/usr/bin/entrypoint"]
