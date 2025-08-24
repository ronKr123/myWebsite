# שלב 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# העתק את כל הקבצים
COPY . .

# הרץ publish
RUN dotnet publish -c Release -o /app

# שלב 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app .

# Render ייתן PORT באמבעה אוטומטית
ENV ASPNETCORE_URLS=http://+:10000

# הפורט ש-Render יאזין עליו
EXPOSE 10000

# הפקודה שמריצה את האתר
CMD ["dotnet", "MyWebsite.dll"]
# החלף את MyUmbracoProject.dll בשם הקובץ של הפרויקט שלך