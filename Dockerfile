FROM ubuntu:14.04

#install dependencies
RUN apt-get -y update && apt-get -y install \
	git-core curl zlib1g-dev build-essential libssl-dev \
	libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
	libxml2-dev libxslt1-dev libcurl4-openssl-dev \
	python-software-properties libffi-dev \
	git postgresql-9.3 postgresql-common libpq-dev phantomjs && apt-get clean

#Set rbenv
RUN mkdir /home/ofn && cd /home/ofn
# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv && \
	git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build && \
	/root/.rbenv/plugins/ruby-build/install.sh && \
	echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile &&\
	echo 'eval "$(rbenv init -)"' >> .bashrc

ENV PATH /root/.rbenv/bin:$PATH

RUN rbenv install 2.1.5 && rbenv global 2.1.5 

#Install gems
RUN echo "gem: --no-document" >> /root/.gemrc

RUN gem install git-up bundler zeus

RUN su - postgres -c "createuser --superuser --pwprompt ofn"
