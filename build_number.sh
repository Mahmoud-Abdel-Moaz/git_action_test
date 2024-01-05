fastlane run latest_testflight_build_number app_identifier:"com.nxt.ci" api_key_path:"api_key.json"  |  grep "Result: " | awk '{print $3}'

echo SharedValues::LATEST_TESTFLIGHT_VERSION