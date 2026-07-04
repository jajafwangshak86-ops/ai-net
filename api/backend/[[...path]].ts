import "dotenv/config";
import express from "express";
import backendApp from "../../backend/src/server";

const app = express();
app.use("/api/backend", backendApp);
export default app;
