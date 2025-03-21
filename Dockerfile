FROM node
WORKDIR /app
COPY package.json yarn.lock /app
RUN yarn install
COPY main.js /app
CMD ["yarn", "run", "start"]
