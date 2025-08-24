# ===========================
# Build stage
# ===========================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# העתק את כל הקבצים
COPY . .

# publish האתר ל־Release
RUN dotnet publish -c Release -o /app

# ===========================
# Runtime stage
# ===========================
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

# העתק את הקבצים מה־build
COPY --from=build /app .

# צור תיקיות חשובות
RUN mkdir -p wwwroot/media
RUN mkdir -p App_Data

# העתק את קובץ ה‑SQLite הקיים
COPY umbraco/Data/Umbraco.sqlite.db App_Data/Umbraco.sqlite.db

# העתק מדיה אם יש קבצים קיימים
COPY wwwroot/media wwwroot/media

# הגדר Environment Variables
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:10000
# Connection string ל‑SQLite
ENV ConnectionStrings__umbracoDbDSN="Data Source=App_Data/Umbraco.sqlite.db;"

# חשיפת הפורט ש‑Render מאזין עליו
EXPOSE 10000

# הפקודה שמריצה את האתר
CMD ["dotnet", "myWebsite.dll"]
