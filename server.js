import express from "express";
import cors from "cors";
import e from "express";

const app = express();

app.use(cors({ optionsSuccessStatus: 200 }));

app.use(express.static("public"));

app.get("/", (_req, res) => {
  res.sendFile(import.meta.dirname + "/views/index.html");
});

// Do not change code above this line
app.get("/api", (req, res) => {
  const currentDate = new Date()
  res.json({unix: currentDate.getTime(), utc: currentDate.toUTCString()})
} )

app.get("/api/:date", (req, res) => {
    try {
      const dateInput = new Date(Number(req.params.date) || req.params.date)
      if (!dateInput.getTime()) {
        throw new Error() 
        }
      res.json({ unix: dateInput.getTime(), utc: dateInput.toUTCString()})
        }
    catch {
      res.json({error: "Invalid Date"})
      }
    }
  )
// Do not change code below this line

const PORT = 8000;
const listener = app.listen(PORT, function () {
  console.log("Your app is listening on port " + listener.address().port);
});
