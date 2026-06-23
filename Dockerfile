FROM alpine/jmeter:5.6.3

WORKDIR /test

COPY socksproject.jmx .

CMD ["-n","-t","socksproject.jmx","-l","result.jtl"]
