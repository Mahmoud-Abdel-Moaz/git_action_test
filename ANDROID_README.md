
1- create keystore file for each flavor

2- encode keystore file for each flavor (cat keystore.jks | base64 | pbcopy)

3- add data of keystore for each flavor (KEYSTORE_BASE64,STORE_PASSWORD,KEY_PASSWORD,KEY_ALIAS) to Github Secrets 

4- uses: actions/checkout@v1 : to checkout the code 

5- to use private package from private repo add
  - uses: webfactory/ssh-agent@v0.8.0
   with:
     ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}



(Note) Create SSH key to access private package in private repo
- ssh-keygen -t ed25519 -C "user@example.so" => to generate ssh key
- pbcopy < ~/.ssh/id_ed25519.pub => to copy public key
- add public key to ssh key from settings of account of private repo
- ssh -T git@github.com  => to test key
- and add private key to ssh key to secrets (SSH_PRIVATE_KEY) to access private package



6- Download Android keystore For each flavor use
- name: Download blink Android keystore
  id: android_blink_keystore
  uses: timheuer/base64-to-file@v1.0.3
  with:
    fileName: blink-keystore.jks
    encodedString: ${{ secrets.KEYSTORE_BASE64_BLINK }}

7- create key.properties file for each flavor
- name: Create key.properties
  run: |
    echo "storeFile=${{ steps.android_blink_keystore.outputs.filePath }}" > android/key1.properties
    echo "storePassword=${{ secrets.STORE_PASSWORD_BLINK }}" >> android/key1.properties
    echo "keyPassword=${{ secrets.KEY_PASSWORD_BLINK }}" >> android/key1.properties
    echo "keyAlias=${{ secrets.KEY_ALIAS_BLINK }}" >> android/key1.properties

8- setup java and cash it So that we don't have to download it again every time
- uses: actions/setup-java@v1
  with:
    distribution: 'zulu'
    java-version: "12.x"
    cache: gradle

9- setup Flutter Sdk and cash it So that we don't have to download it again every time
- uses: subosito/flutter-action@v1
  with:
    flutter-version: "3.16.1"
    channel: 'stable'
    cache: true


10- Get dependencies
flutter pub get


11- Start Android Release Build for blink flover
flutter build appbundle --flavor blink -t lib/main.dart


12- deploy release bundle to google store
- name: Release Build to internal track
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJsonPlainText: ${{secrets.PLAYSTORE_ACCOUNT_KEY}}
    packageName: appPackageId
    releaseFiles: build/app/outputs/bundle/app-release.aab
    track: internal
    status: draft


(Note) Deploy on google play store
* use package https://github.com/r0adkll/upload-google-play
* Configure service account in Google Cloud Platform
  - Navigate to https://cloud.google.com/gcp
  - Open IAM and admin > Service accounts > Create service account
  - Pick a name and add appropriate permissions 'owner'
  - Open the newly created service account, click on keys tab and add a new key, JSON type
  - When successful, a JSON file will be automatically downloaded on your machine
  - Store the content of this file to your GitHub secrets, e.g. (PLAYSTORE_ACCOUNT_KEY).
* Add user to Google Play Console
  - Open https://play.google.com/console and pick your developer account
  - Open Users and permissions
  - Click invite new user and add the email of the service account created in the previous step
  - create service account from Google Cloud Console with role owner
  - Grant permissions to the app that you want the service account to deploy in app permissions
* enable Google Play Android Developer API service from  https://console.cloud.google.com/apis/api/androidpublisher.googleapis.com/overview






(*) for Firebase Distribution use 
- create project for app at firebase
- get app id of project form firebase project settings and save it on secrets =>FIREBASE_APP_ID
- Navigate to https://cloud.google.com/gcp
- Open IAM and admin > Service accounts > Create service account
- Pick a name and add appropriate permissions 'Firebase App Distribution Admin'
- Open the newly created service account, click on keys tab and add a new key, JSON type
- When successful, a JSON file will be automatically downloaded on your machine
- Store the content of this file to your GitHub secrets, e.g. (CREDENTIAL_FILE_CONTENT).
- use script
        - name: Firebase Sportico Distribution
          uses: wzieba/Firebase-Distribution-Github-Action@v1.7.0
          with:
            appId: ${{secrets.FIREBASE_APP_ID}}
            serviceCredentialsFileContent: ${{ secrets.CREDENTIAL_FILE_CONTENT }}
            groups: testers
            file: build/app/outputs/flutter-apk/app-sportico-release.apk
* source
- https://github.com/marketplace/actions/firebase-app-distribution
- https://steveos.medium.com/github-action-and-firebase-app-distribution-ci-cd-ways-part-2-fcf9ba425c0






