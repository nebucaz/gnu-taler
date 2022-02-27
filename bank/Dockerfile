FROM taler-base:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    libpq-dev \
    python3.8 \
    python3.8-dev \
    python3-pip \
    postgresql


ARG user=talerbank
RUN useradd -U -ms /bin/bash -u 1001 $user

ENV HOME="/home/$user"
WORKDIR $HOME
USER $user
RUN mkdir -p \
    $HOME/.local/bin \
    $HOME/.cache/pip

ENV PATH="$HOME/.local/bin:$PATH"
RUN pip3 install --user poetry talerbank

COPY config "$HOME/.config"

# append DB connection params to the end of settings.py
# The standard config parser of talerbank does not support
# definition of user/pass/host/port parameters which are
# needed to connecto to postgres in another container
RUN cat $HOME/.config/dbconn.py >> $HOME/.local/lib/python3.8/site-packages/talerbank/settings.py

EXPOSE 5882

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
