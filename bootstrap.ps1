$ErrorActionPreference = 'Stop'
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) { throw 'Flutter not found in PATH. Install Flutter stable first.' }
$version = (flutter --version --machine | ConvertFrom-Json).frameworkVersion
Write-Host "Flutter version: $version"
if (-not (Test-Path 'android')) {
  flutter create --platforms=android --org com.example --project-name global_invoice .
  if ($LASTEXITCODE -ne 0) { throw 'Flutter Android generation failed' }
}
flutter pub get
if ($LASTEXITCODE -ne 0) { throw 'Dependency resolution failed' }
dart run build_runner build --delete-conflicting-outputs
if ($LASTEXITCODE -ne 0) { throw 'Code generation failed' }
dart format lib test
if ($LASTEXITCODE -ne 0) { throw 'Formatting failed' }
flutter analyze
if ($LASTEXITCODE -ne 0) { throw 'Static analysis failed' }
flutter test
if ($LASTEXITCODE -ne 0) { throw 'Tests failed' }
Write-Host 'Bootstrap and checks passed. Run flutter run.'
