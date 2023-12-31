
1- create .github Dir in root of project and put in it workflows

2- set 'runs-on': macos-latest the machine that will run on

3- set 'environment' :that hold variables and secrets of Client

4- uses: actions/checkout@v1 : to checkout the code 

5- setup java and cash it So that we don't have to download it again every time
uses: actions/setup-java@v1
with:
  distribution: 'zulu'
  java-version: "12.x"
  cache: gradle

6- setup Flutter Sdk and cash it So that we don't have to download it again every time
uses: subosito/flutter-action@v1
with:
  flutter-version: "3.16.1"
  channel: 'stable'
  cache: true

7-change App Name
sed -i.bak "s/android:label=.*/android:label=\"$APP_NAME\"/g" android/app/src/main/AndroidManifest.xml

8-change Change App Package Id
echo "android {  defaultConfig { applicationId '${PACKAGE_NAME}' }  }" > android/changePackage.gradle
echo "apply from: rootProject.file('changePackage.gradle')" >> android/app/build.gradle

9-Download Logo Image
echo "$LOGO" | base64 -d > assets/images/logo.png

10-Download env file
echo "$DOTENV" | base64 -d > client.env

11- Get dependencies
flutter pub get

12- Generate App Assets
flutter pub run flutter_launcher_icons

13- Start Android Release Build
flutter build apk

14- Store App release
uses: actions/upload-artifact@v2
with:
  name: android-release
  path: build/app/outputs/flutter-apk/app-release.apk


* for Firebase Distribution use 
- https://github.com/marketplace/actions/firebase-app-distribution
- https://steveos.medium.com/github-action-and-firebase-app-distribution-ci-cd-ways-part-2-fcf9ba425c0

* generate git hub token from 
-https://github.com/settings/tokens

* Create SSH key to access private package in private repo 
- ssh-keygen -t ed25519 -C "mabdelmoez@nxt.so" => to generate ssh key
- pbcopy < ~/.ssh/id_ed25519.pub => to copy public key 
- ssh -T git@github.com  => to test key


* build ios
  - name: build Ios ipa
  - run: |
  flutter build ios --no-codesign
  cd build/ios/iphoneos
  mkdir Payload
  cd Payload
  In -s ../Runner-app
  cd ..
  zip -r app.ipa Payload


* Deploy on google play store 
- use package https://github.com/r0adkll/upload-google-play
- create service account with role owner 
- use json content file
- enable Google Play Android Developer API service from  https://console.cloud.google.com/apis/api/androidpublisher.googleapis.com/overview

