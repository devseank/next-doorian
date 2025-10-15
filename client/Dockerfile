FROM node:20-alpine

# Set the working directory
WORKDIR /client

# Copy package.json and install dependencies (we'll create this file later)
COPY client/package*.json ./
RUN npm install

# Copy the rest of the application code
COPY client/ .

# Expose the default Vite port
EXPOSE 5173

# Start the development server
CMD ["npm", "run", "dev"]