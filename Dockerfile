# -------------------
# שלב Build
# -------------------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# העתק רק את קבצי הפרויקט (csproj + סולושן)
COPY myWebsite/*.csproj ./myWebsite/
COPY myWebsite.sln ./

# שחזור חבילות
RUN dotnet restore myWebsite/myWebsite.csproj

# העתק את כל הקבצים
COPY . .

# פרסום הפרויקט בלבד (כדי להימנע מ-NETSDK1194)
RUN dotnet publish myWebsite/myWebsite.csproj -c Release -o /app

# -------------------
# שלב Runtime
# -------------------
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# העתק את הפלט מ-build
COPY --from=build /app ./

# צור תיקיית media אם היא חסרה
RUN mkdir -p /app/wwwroot/media

# Render מגדיר את ה־PORT
ENV ASPNETCORE_URLS=http://*:$PORT

EXPOSE 8080

ENTRYPOINT ["dotnet", "myWebsite.dll"]
