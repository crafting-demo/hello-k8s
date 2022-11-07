FROM node:16-alpine
ADD *.js package*.json public /app/
WORKDIR /app
RUN npm install
ENTRYPOINT ["npm", "start"]
