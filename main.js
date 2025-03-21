const express = require("express");
const jwt = require("jsonwebtoken");
const fs = require("node:fs");

const app = express();
const port = process.env.PORT ? process.environment.PORT : 8080;
const secret = fs.readFileSync("private.pem");
// TODO: Validate `secret` is an ES512 key

app.use(express.json())

app.post('/', (req, res) => {
	if (!req.is("application/json")) { res.status(415).end(); return }
	if (!req.accepts('json')) { res.status(406).end(); return }
	try {
		let token = jwt.sign(
			req.body,
			secret,
			{
				algorithm: "ES512",
				expiresIn: "1h"
			}
		)
		res.send({
			auth_token: token
		})
	} catch(e) {
		console.log(e)
		res.status(500).end()
		return
	}
})

app.listen(port, () => {
	console.log(`Signer is listening on port ${port}.`)
})
