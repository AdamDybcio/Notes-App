# Notes Storage

And yet today I am uploading a ready-made application to this repository. A bit in a hurry, which makes the files messy, but I want to start making another application, this time calmly (and again with BLoC architecture).

So before I start talking about the app:
For the application to work for you, you must create a project on Firebase and add an Android and/or IOS application to the project (generate a google-services file for the platform). Follow the instructions on the Firebase website, after that everything should work fine.

## Application description

### Login/Register Screen:

After opening the application, it shows a standard login screen. The user can log in or create an account. When creating an account, it is checked whether the user with the given login already exists, whether the passwords are the same and whether the password has at least 6 characters. Of course, after logging in, the user will be transferred further (which I will talk about in a moment) and his login details will be saved locally so that the next time the application is launched, the user will not have to enter his login details again.

<img src="https://user-images.githubusercontent.com/68535467/202294213-b5e88aad-f821-4ed6-9ee2-b2ce4bad3a51.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202294227-67602e1e-f9f0-4a8d-970e-e176c1ad40d3.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202294269-03ed0469-6013-4ca7-b38b-8b38a5214b2b.png" width="320" height="720">

<img src="https://user-images.githubusercontent.com/68535467/202294280-64a3277f-c08f-4e54-87a9-53f9656db2b5.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202294285-459aa31c-1e6b-4ce8-b840-7a4a6a2cd914.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202294314-cb46f638-fd39-4aa7-85da-bd9e806f077c.png" width="320" height="720">

<img src="https://user-images.githubusercontent.com/68535467/202294322-9541677b-a635-42f6-9fe8-cf17fd5a1486.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202294335-a8c77a2d-2b40-4726-ab18-29fc4a0051cf.png" width="320" height="720">

## Home Screen:

After registering / logging in, the user must set his nickname to be able to use the functions of the application. It is more of a visual addition, so as not to be associated only through a unique login. After entering the login, the functions of the application are unlocked. The user sees which groups he is in (or not in any). A user can create his own group (his own group names cannot be repeated, but another user can create a group with the same name as another user) or count on being added to a group (a user cannot request to be added or join yourself, due to the assumption of privacy of groups and photos in these groups in the application. After creating your group, the user becomes its administrator, who is the only one who can kick other group members or delete the group completely (other group users can leave the group or together with admin to add users to the group. There is also a button for refreshing data on the screen (because I did not make queries as streams) and some visual additions, such as a clock or custom shapes. The user can switch between pages using navigation (NOTE: after pressing another button on the navigation, THE NEW PAGE IS NOT LOADED, BUT THE WIDGETS VIEWED ON THE SCREEN ARE CHANGED).

<img src="https://user-images.githubusercontent.com/68535467/202295049-4a69c833-f690-4346-a8a8-e5bb456515b4.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202295054-d5e80a3b-627a-47a4-b725-533cee6f55f5.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202295061-dc4ae8b2-5f2d-405d-8acb-8a45b95cfe08.png" width="320" height="720">

<img src="https://user-images.githubusercontent.com/68535467/202295065-cc4118f0-b348-4c7e-9c53-baa481e3cfda.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202295069-6b3ce902-a931-49ac-9cbe-d481bbbd7c89.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202295076-bb8ebaee-b650-41d9-ada7-64d983167f69.png" width="320" height="720">

<img src="https://user-images.githubusercontent.com/68535467/202295082-5a4bbb35-e767-4792-ae20-257f33ad0631.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202295097-56c77d40-746a-431a-a0b4-b6364e938eb7.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202295109-d4e2dd96-e2b6-457a-a856-de9e960e0d19.png" width="320" height="720">

<img src="https://user-images.githubusercontent.com/68535467/202295119-93a7f8d8-853b-4ff0-9a4d-a33c4d3174e6.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202295126-7055bd8e-536c-4bd0-b09a-2ee4a9a780a7.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202295132-5c3e6304-819e-4687-b5c0-9de3e544fad1.png" width="320" height="720">

<img src="https://user-images.githubusercontent.com/68535467/202295152-13867f08-be7e-418e-bf23-b49e4c6623e2.png" width="320" height="720">

## Write Note Screen:

This page is simple: the user can simply draw or write something, create a note of his choice using the ready-made tools in the top bar. After clicking the save icon, the user can save the created note in the phone gallery.

<img src="https://user-images.githubusercontent.com/68535467/202296761-7dd4e391-f191-46f8-8710-f7dec8d54e18.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202296771-b416ff31-a568-40f8-9397-d19b27f0a13d.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202296779-2c675e35-45d2-4620-b7d5-0deed376a2a4.png" width="320" height="720">


<img src="https://user-images.githubusercontent.com/68535467/202298381-3b6e0c37-ba47-4826-a855-aa99478a0b00.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202298387-7bcee829-1117-44d9-848c-c71ce2443453.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202298393-55386ab1-3fdd-47af-beac-cee38ee7b86e.png" width="320" height="720">

<img src="https://user-images.githubusercontent.com/68535467/202298402-be8ece1a-a31d-4416-b818-08cd43b78cc1.png" width="320" height="720">

## Add Images Screen:

In this screen user can select images from gallery after clicking button with big plus. He can choose as many as he wants. After adding images, their preview is displayed. After clicking on a tile with a image, it will be removed from the list and will not be added to the group's images. After selecting at least one image, the user can add the selected image or images to the selected group to which he belongs (if he is not in any group, then he cannot add). The rest of the operation of this page, i.e. sending and messages, I leave to be seen in the pictures.

<img src="https://user-images.githubusercontent.com/68535467/202297232-38a13d9e-a57c-4ce4-bf06-88ec0fdafc11.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202297242-c252fb71-31c0-45da-aaf7-efb19850b4d3.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202297246-7fc7a727-be2e-48d7-9dfb-764e3b834caa.png" width="320" height="720">

<img src="https://user-images.githubusercontent.com/68535467/202297256-53733175-4357-494d-bbec-873c823eaac9.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202297268-c22088e8-c88b-4eba-9196-13f7d444a360.png" width="320" height="720">

## Browse Images Screen:

The last screen is used to view all sent images by all members of the group selected on the list to which the logged in user belongs. After clicking on the loaded image, the user has a preview of the image in full screen. Unfortunately, I did not add the ability to download these images or view detailed information about the image. The rest is as shown in the attached images. And of course, after pressing the last button on the navigation bar, the user logs out.

<img src="https://user-images.githubusercontent.com/68535467/202298237-1b8389c7-fdef-4545-a257-b1e531fa1f31.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202298274-b20f204a-eac6-45d5-a253-d5b22bab88cc.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202298245-f64ba835-4787-4175-8f10-ea8ce7f2bc55.png" width="320" height="720">

<img src="https://user-images.githubusercontent.com/68535467/202298329-c6887c22-8eec-4ec3-8b40-f60070d79557.png" width="320" height="720">     <img src="https://user-images.githubusercontent.com/68535467/202297268-c22088e8-c88b-4eba-9196-13f7d444a360.png" width="320" height="720">

## Summary:

I think this application is quite ambitious and has potential, but there are many shortcomings (e.g. checking the user's internet connection on a regular basis and handling it, handling queries with streams, no use of BLoC, file clutter, etc.) . Anyway, I'm leaving it here, maybe someone will want to develop it further, test it. And at that time I will start making another application, this time for sure with BLoC and possible streams. And I won't mess with the code anymore, I promise 😆 it's just a one-time action. If you have any cool idea for an app to create, contact me and give me this idea, I will gladly make it. Greetings!
