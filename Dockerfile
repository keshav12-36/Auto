FROM node:lts

# Install all the required packages
RUN apt-get update
RUN apt-get install -y \
    git bash build-essential curl python3

# setup workdir
WORKDIR /bot
RUN chmod 777 /bot

# Copies config(if it exists)
COPY . .

# Install requirements and start the bot
RUN npm install
CMD ["node", "server"]
