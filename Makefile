test:
	xctool -project FeedbackDemo.xcodeproj -scheme FeedbackDemo -configuration Debug -sdk "iphonesimulator8.1" build
	xctool -project FeedbackDemo.xcodeproj -scheme FeedbackDemo -configuration Debug -sdk "iphoneos8.1" build

release:
	git archive master --prefix='UMFeedback_iOS_2.0.1/' --format=zip > UMFeedback_iOS_2.0.1.zip
	mv UMFeedback_iOS_2.0.1.zip ~/Downloads
