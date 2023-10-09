const express = require("express");
const port = process.env.PORT || 8080;
const cors = require("cors");

//Prod
const { Firestore } = require("@google-cloud/firestore");
const db = new Firestore();

//TODO: Come back to this later
// const admin = require("firebase-admin");
// admin.initializeApp({
//    credential: admin.credential.cert(require("./service-account-key.json")),
// });
// const db = admin.firestore();

const app = express();

app.use(cors());
app.use(express.json());

app.get("/viewcount", async (req, res) => {
   const query = await db.collection("viewCountCollection").doc("viewCountDocumentID").get();
   const data = query.data();

   if (data) {
      res.json(data);
   } else {
      res.status(500).json({ error: "An error has occurred." });
   }
});

app.post("/increment", async (req, res) => {
   try {
      const query = await db.collection("viewCountCollection").doc("viewCountDocumentID").get();
      const currentViewCount = query.data().count;
      const newCount = currentViewCount + 1;
      await db.collection("viewCountCollection").doc("viewCountDocumentID").update({ count: newCount });
      return res.status(201).json({ count: newCount });
   } catch {
      res.status(500).json({ error: "An error has occurred" });
   }
});

// app.get("/", async (req, res) => {
//    res.send("troubleshooting");
// });

app.listen(port, () => {
   console.log(`Listening on port ${port}`);
});
