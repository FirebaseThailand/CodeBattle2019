import React from "react";
import Layout from "./Layout";
import Card from "./Card";
import { useCollection } from "react-firebase-hooks/firestore";
import StackGrid from "react-stack-grid";
import LoadingScreen from "./LoadingScreen";
import RandomScreen from "./RandomScreen";

const firebase = require("firebase");
require("firebase/firestore");

firebase.initializeApp({
  apiKey: "AIzaSyBMEQL7bAroE0LDe_wdRxMhmIlStx4LTIU",
  authDomain: "fir-devday.firebaseapp.com",
  projectId: "fir-devday"
});

var db = firebase.firestore();

const App = () => {
  const [snapshot, loading, error] = useCollection(
    db
      .collection("code-battle-2019")
      .orderBy("timestamp", "desc")
      .where("status", "==", true)
  );
  const items =
    loading || error ? [] : snapshot.docs.map(d => ({ id: d.id, ...d.data() }));

  return (
    <Layout>
      {loading && <LoadingScreen />}
      <RandomScreen items={items} number={2}></RandomScreen>
      <StackGrid
        columnWidth={300}
        gutterWidth={10}
        gutterHeight={10}
        monitorImagesLoaded={true}
      >
        {items.map(doc => (
          <Card data={doc} key={doc.id} />
        ))}
      </StackGrid>
    </Layout>
  );
};

export default App;
