FROM centos:7

RUN echo "tsflags=nodocs" >> /etc/yum.conf && \
		yum -y install epel-release centos-release-scl && \
		yum -y install wget git rh-python36-python-pip && \
		yum clean all

ENV PYTHONUNBUFFERED=0
ENV DJANGO_SETTINGS_MODULE=pulpcore.app.settings

RUN mkdir -p /etc/pulp

RUN scl enable rh-python36 'pip install gunicorn'
RUN scl enable rh-python36 'pip install pulpcore'
RUN scl enable rh-python36 'pip install pulp_file'
RUN scl enable rh-python36 'pip install pulp_ansible'

COPY container-assets/settings.py /etc/pulp/settings.py
RUN echo "SECRET_KEY = '`cat /dev/urandom | tr -dc 'a-z0-9!@#$%^&*(\-_=+)' | head -c 50`'" >> /etc/pulp/settings.py

RUN scl enable rh-python36 "pulp-manager makemigrations pulp_app"
RUN scl enable rh-python36 "pulp-manager makemigrations pulp_file"
RUN scl enable rh-python36 "pulp-manager makemigrations pulp_ansible"
RUN scl enable rh-python36 "pulp-manager collectstatic --noinput"

COPY container-assets/wait_on_postgres.py /usr/bin/wait_on_postgres.py
COPY container-assets/pulp_server /usr/bin/pulp_server
COPY container-assets/entrypoint /usr/bin/entrypoint

CMD ["/usr/bin/pulp_server"]
ENTRYPOINT ["/usr/bin/entrypoint"]
