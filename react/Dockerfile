# Usa uma versão específica do Node para evitar mudanças inesperadas
FROM node:22.10-alpine as build

# Define o diretório de trabalho
WORKDIR /app

# Copia apenas os arquivos essenciais primeiro para otimizar o cache de camadas
COPY package*.json ./

# Instala as dependências com versões fixas para evitar quebras no futuro
RUN npm install --production --frozen-lockfile

# Copia o restante dos arquivos da aplicação
COPY . .

# Roda o build, garantindo que a aplicação esteja configurada corretamente
RUN npm run build

# Usa uma versão específica e minimalista do Nginx para garantir segurança
FROM nginx:1.21-alpine

# Cria o diretório de destino caso não exista (garante que a cópia ocorra corretamente)
RUN mkdir -p /usr/share/nginx/html

# Copia os arquivos do build para o diretório do Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Copia o arquivo de configuração do Nginx para garantir que está correto
COPY ./nginx.default.conf /etc/nginx/conf.d/default.conf

# Expõe a porta, mas adiciona uma variável de ambiente para controlar o ambiente de execução
ENV NODE_ENV=production

# Expõe a porta 80 para acesso
EXPOSE 80