import express from 'express';

const app = express();
const port = process.env.PORT ? process.environment.PORT : 8080;

app.use(express.json())

app.post('/', (req, res) => {
	res.send(req.body)
})

app.listen(port, () => {
	console.log(`Signer is listening on port ${port}.`)
})
