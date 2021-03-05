FROM openethereum/openethereum

ARG NODE_ID=${NODE_ID}
ARG JSON_KEY=${JSON_KEY}

COPY --chown=openethereum node${NODE_ID}.toml /config.toml
COPY --chown=openethereum ./base-chainspec.json /chainspec.json
COPY --chown=openethereum ./json-wallets/node${NODE_ID}.json /home/openethereum/.local/share/io.parity.ethereum/keys/BARBABIETOLA-DEV/node${NODE_ID}.json

RUN echo ${JSON_KEY} > /home/openethereum/node.pwd
