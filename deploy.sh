# Bump build number
perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.($2+1)/e' pubspec.yaml

# Format
flutter format lib

# Upload
flutter packages pub publish --force