FROM node:16-alpine
ADD *.js package*.json /app/
ADD public /app/public
WORKDIR /app
RUN npm install
ENTRYPOINT ["npm", "start"]
