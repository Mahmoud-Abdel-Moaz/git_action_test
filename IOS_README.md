
1- Create files :-
- Create manual distribution Certificate 
- create .p12 certificate (add certificate to keychain and export certificate from keychain and set password)
- create provision profile included create certificate
- create ExportOptions file with distribution configurations
 <?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>destination</key>
	<string>export</string>
	<key>method</key>
	<string>app-store</string>
	<key>teamID</key>
	<string>teamID value</string>
	<key>teamName</key>
	<string>teamName value</string>
	 <key>provisioningProfiles</key>
        <dict>
          <key>bundle id</key>
          <string>provision profile name </string>
        </dict>
       <key>signingStyle</key>
       <string>manual</string>
</dict>
</plist>


2- Encode created .p12 Certificate base 64 with (cat ci.p12 | base64 | pbcopy)

3- Encode Profile  base 64 with (cat ci2.mobileprovision | base64 | pbcopy)

3- Encode ExportOptions  base 64 with (cat ExportOptions.plist | base64 | pbcopy)

4- add encoded certificate and profile and password of certificate and keychain password to secrets
BUILD_CERTIFICATE_BASE64: ${{ secrets.BUILD_CERTIFICATE_BASE64 }}
P12_PASSWORD: ${{ secrets.P12_PASSWORD }}
BUILD_PROVISION_PROFILE_BASE64: ${{ secrets.BUILD_PROVISION_PROFILE_BASE64 }}
KEYCHAIN_PASSWORD: ${{ secrets.KEYCHAIN_PASSWORD }}
EXPORT_OPTIONS: ${{ secrets.IOS_EXPORT_OPTIONS_BASE64 }}

* in Script

6-  Add Certificate File
CERTIFICATE_PATH=$RUNNER_TEMP/build_certificate.p12
echo "$BUILD_CERTIFICATE_BASE64" | base64 -d > $CERTIFICATE_PATH

7- Add Profile File
PP_PATH=$RUNNER_TEMP/ci.mobileprovision
echo "$BUILD_PROVISION_PROFILE_BASE64" | base64 -d > $PP_PATH

7- Add ExportOptions File
EXPORT_OPTIONS_PATH="${{ github.workspace }}/app/ios/Runner/ExportOptions.plist"
echo -n "$EXPORT_OPTIONS_BASE64" | base64 -d > $EXPORT_OPTIONS_PATH

8- Create Keychain file
KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db
security create-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
security unlock-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH

9-  Install the Apple certificate in Keychain
CERTIFICATE_PATH=$RUNNER_TEMP/build_certificate.p12
KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db
security import $CERTIFICATE_PATH -P "$P12_PASSWORD" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
security list-keychain -d user -s $KEYCHAIN_PATH

10- Install Apple Profile
PP_PATH=$RUNNER_TEMP/ci.mobileprovision
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp $PP_PATH ~/Library/MobileDevice/Provisioning\ Profiles

11-  Building IPA
flutter build ipa --release --export-options-plist=ios/Runner/ExportOptions.plist

12-
* Deploy to App Store  (Testflight)
- create access api key from users and permissions in App Content
- get issuer-id and save in secrets.APP_STORE_CONNECT_ISSUER_ID
- get api-key-id and save in secrets.APP_STORE_CONNECT_API_KEY_ID
- get  api-private-key (the content of downloaded api key file) and save in secrets.APP_STORE_CONNECT_API_PRIVATE_KEY
- to deploy  use
      - name:  Deploy to App Store  (Testflight)
        uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/ios/ipa/gitaction.ipa
          issuer-id: ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
          api-key-id: ${{ secrets.APP_STORE_CONNECT_API_KEY_ID }}
          api-private-key: ${{ secrets.APP_STORE_CONNECT_API_PRIVATE_KEY }}

13- clean keychain and profile after job done
security delete-keychain $RUNNER_TEMP/app-signing.keychain-db
rm ~/Library/MobileDevice/Provisioning\ Profiles/ci.mobileprovision


