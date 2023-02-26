// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
  apiKey: 'AIzaSyCvtjgrVF882WNMy47VFw__5XggAcpUREw',
  appId: '1:831991733527:web:abff7e05d1298f82912b52',
  messagingSenderId: '831991733527',
  projectId: 'fertilizer-admin',
  authDomain: 'fertilizer-admin.firebaseapp.com',
  storageBucket: 'fertilizer-admin.appspot.com',
  measurementId: 'G-CMH4Q9QK0S',
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();
