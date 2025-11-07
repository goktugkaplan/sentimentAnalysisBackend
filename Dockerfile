# ----------------------
# Base image for runtime
# ----------------------
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 5115

# ----------------------
# Build stage
# ----------------------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Tüm projeyi kopyala
COPY . .

# NuGet paketlerini restore et
RUN dotnet restore

# Publish ile derle
RUN dotnet publish -c Release -o /app/out

# ----------------------
# Final stage
# ----------------------
FROM base AS final
WORKDIR /app

# Publish edilmiş dosyaları kopyala
COPY --from=build /app/out .

# SQLite DB dosyasını kopyala
COPY ChatApp.API/chatapp.db ./chatapp.db

# Uygulamayı çalıştır
ENTRYPOINT ["dotnet", "ChatApp.API.dll"]
