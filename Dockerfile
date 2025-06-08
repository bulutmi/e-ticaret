# --- 1) Build Stage ---
FROM node:18-alpine AS build

# Create and set working directory
WORKDIR /app

# Copy package manifests and install dependencies
COPY package*.json ./
RUN npm install

# Copy application source and build (if you have a build step)
COPY . .
RUN npm run build

# --- 2) Runtime Stage ---
FROM node:18-alpine

WORKDIR /app

# Copy package manifests and install production dependencies
COPY package*.json ./
RUN npm install --production

# Copy built files and source from the build stage
COPY --from=build /app ./

# Notify Docker of the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
