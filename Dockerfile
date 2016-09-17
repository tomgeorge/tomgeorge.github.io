FROM jekyll/jekyll
USER root
RUN mkdir -p /usr/src/blog
COPY * /usr/src/blog/
RUN chown -vR jekyll:jekyll /usr/src/blog
USER jekyll
WORKDIR /usr/src/blog
CMD "bundle exec jekyll serve"