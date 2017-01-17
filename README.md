# PromotionServicePrototype
This service will be used as a way for users of the game to advertise and invite their friends to play the game. This service goes from the idea of spreading the app through an informal, ‘word of mouth’ technique. 
The way this service works is that a user of the app will be able to send referrals to their friends through an in-app messaging service. The referral will be a message that the user can send through text message, Facebook Messenger, and other messaging services. The user of the app can choose which messaging service to send the message with. 
This message will be formatted so that the user will just have to fill in the blanks of what they want to say to their friends. At the end of the message, there will be a code that is unique to them.
One of the biggest goals of this service is to be able to integrate it with other products and not just this game application so that companies and other new products will be able to advertise their app using this new service.

# Step for receiving promotions:
1. Client will open the app and connect to the database. 
2. The app will download and store, in classes, all current promotions table and the current customer track for promotion table .
3. If the receiver gets a message that has a URL containing a promotion, and that URL is using the app’s URL scheme, then our service will open. It will call on the URL parser to redirect that link to the proper view controller.If the URL happens to be something about promotions to be redeemed, then the URL parser will call on a promotion reader will determine whether the user is eligible and give the user the reward.It does so by comparing the promotion that was taken in to the downloaded objects in the first step.
4. If the above step is successful then it will credit original sender for sending the promotion

# Step for sending promotion:
1. Client will open the app and connect to the database. 
2. The app will download and store, in classes, all current promotions table and the current customer track for promotion table.
3. User will choose a promotion from the table of current promotions.
4. Once they select a promotion to send, it will direct them to a message compose view controller where the user can generate a personalized message and select which service to send the message with. The URL generator will automatically generate a URL to be appended onto the message. The implementation for sending a message is based on which service they choose to send the message with. (Facebook, Twitter, and SMS/iMessage)

