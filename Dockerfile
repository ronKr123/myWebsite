# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /app

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app .

# צור תיקיות חשובות
RUN mkdir -p wwwroot/media
RUN mkdir -p App_Data

# העתק את הקובץ הקיים של SQLite ל-App_Data
COPY umbraco/Data/Umbraco.sqlite.db App_Data/Umbraco.sqlite.db

ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

CMD ["dotnet", "myWebsite.dll"]
