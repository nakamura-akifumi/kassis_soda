# docker/elasticsearch/Dockerfile

FROM docker.elastic.co/elasticsearch/elasticsearch:6.5.4
RUN elasticsearch-plugin install analysis-kuromoji
RUN kibana-plugin install https://github.com/johtani/analyze-api-ui-plugin/releases/download/6.5.4/analyze-api-ui-plugin-6.5.4.zip