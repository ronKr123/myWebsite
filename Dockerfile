# שלב Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# העתק את כל הקבצים
COPY . .

# שחזור חבילות והידור
RUN dotnet restore
RUN dotnet publish -c Release -o /app

# שלב Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# העתק את התוצאה
COPY --from=build /app ./

# קובץ SQLite נשמר בתקיית Data בתוך ה־publish
# דאג שהקובץ Umbraco.sqlite.db ייכנס ל־git (או תעתיק אותו ל־/umbraco/Data)
# אחרת Render יריץ את האתר בלי DB

# Render מגדיר את ה־PORT
ENV ASPNETCORE_URLS=http://*:$PORT

EXPOSE 8080

ENTRYPOINT ["dotnet", "myWebsite.dll"]
