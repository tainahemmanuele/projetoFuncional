let info = {};
let carregado = false;

fetch("http://150.165.15.10:8080/todasTransacoes",{method: 'POST'})
.then((response) => response.json())
.then((result) => {
	info = result;
	carregado = true;
	console.log(info.length)
	//document.body.innerHTML+=JSON.stringify(info);
	})
.catch((err) => { console.error(err); });

