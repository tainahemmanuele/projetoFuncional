let yearMonth = {"year": 2017, "month": 1,"day": 1};
let db = [];
let filterType = "yearMonthDay";

fetch("http://150.165.15.10:8080/todasTransacoes",{method: 'POST'})
.then((response) => response.json())
.then((result) => {
	result = result.map(cleanObj);
	populateHTML(result);
	db = result;
	})
.catch((err) => { console.error(err); });


function cleanObj(obj){
	obj.data = new Date(obj.data.year + "-" + (obj.data.month+1) + "-" + obj.data.dayOfMonth);
	delete obj.arquivos;
	return obj;
}

function yearEquals(obj){
	return obj.data.getFullYear() == this.year;
}

function yearMonthEquals(obj){
	return obj.data.getFullYear() == this.year && obj.data.getMonth() == this.month-1;
}

function yearMonthDayEquals(obj){
	return obj.data.getFullYear() == this.year && obj.data.getMonth() == this.month-1 && obj.data.getDate() == this.day;
}

//1 - Filtrar transações por ano.
//2 - Filtrar transações por ano e mês.
//1.2.C - Filtrar transações por ano e mês e dia.
function filterByYear(list, yearMonth){
	return list.filter(yearEquals,yearMonth);
}

function filterByYearMonthDay(list, yearMonth){
	return list.filter(yearMonthDayEquals,yearMonth);
}

function filterByYearMonth(list, yearMonth){
	return list.filter(yearMonthEquals,yearMonth);
}
//3 - Calcular o valor das receitas (créditos) em um determinado mês e ano.
function computeCreditsByYearMonth(list,yearMonth){
	return (filterByYearMonth(list,yearMonth).filter(isCredit)).reduce(function(a,b){ return a + b.valor;}, 0);
}
//4 - Calcular o valor das despesas (débitos) em um determinado mês e ano.
function computeDebitsByYearMonth(list,yearMonth){
	return (filterByYearMonth(list,yearMonth).filter(isDebit)).reduce(function(a,b){ return a + b.valor;}, 0);
}

//5 - Calcular a sobra (receitas - despesas) de determinado mês e ano
function computeDCByYearMonth(list,yearMonth){
	return computeCreditsByYearMonth(list, yearMonth) + computeDebitsByYearMonth(list, yearMonth);
}

//6 - Calcular o saldo final em um determinado ano e mês
function computeBalance(list,yearMonth){
	return getInitialBalanceAtYearMonth(list,yearMonth) + computeDCByYearMonth(list,yearMonth);
}


//7 - Calcular o saldo máximo atingido em determinado ano e mês
function getMaxBalance(list,yearMonth){
	let balance = 0;//getInitialBalanceAtYearMonth(list,yearMonth);
	let maxBalance = balance;
	filterByYearMonth(list,yearMonth).forEach((action) => {
		balance+=action.valor;
		if (maxBalance < balance)
			maxBalance = balance;
	});
	return balance;
}
//8 - Calcular o saldo mínimo atingido em determinado ano e mês
function getMinBalance(list,yearMonth){
	let balance = 0;//getInitialBalanceAtYearMonth(list,yearMonth);
	let minBalance = balance;
	filterByYearMonth(list,yearMonth).forEach((action) => {
		balance+=action.valor;
		if (minBalance > balance)
			minBalance = balance;
	});
	return balance;
}

//9 - Calcular a média das receitas em determinado ano
function computeCreditMeansByYear(list,yearMonth){
	let filtered = list.filter(yearEquals,yearMonth).filter(isCredit);
	return (filtered).reduce(function(a,b){ return a + b.valor;}, 0) /filtered.length;
}
//10 - Calcular a média das despesas em determinado ano
function computeDebitsMeansByYear(list,yearMonth){
	let filtered = list.filter(yearEquals,yearMonth).filter(isDebit);
	return (filtered).reduce(function(a,b){ return a + b.valor;}, 0) /filtered.length;
}
//11 - Calcular a média das sobras em determinado ano
function computeDCMeans(list,yearMonth){
	let filtered = list.filter(yearEquals,yearMonth).filter(isNotBalance);
	return (filtered).reduce(function(a,b){ return a + b.valor;}, 0) /filtered.length;
}

//12 - Retornar o fluxo de caixa de determinado mês/ano. O fluxo de caixa nada mais é do que uma lista contendo pares (dia,saldoFinalDoDia). 
function getCashFlow(list, yearMonth){
	let cashFlow = [];
	days = getDateArray(yearMonth.month);
	days.forEach(d => cashFlow.push("( Dia: " + d + "/" + yearMonth.month + "/" + yearMonth.year  + ", R$: " + getBalanceAtYearMonthDay(list,{"year": yearMonth.year,"month":yearMonth.month,"day":d}).toFixed(2) + ")"));
	return cashFlow;
}


//UTIL
function getDateArray(month){
	return (Array.from(Array(new Date(yearMonth.year, month, 0).getDate()).keys())).map((x) => x+1);
}


function getBalanceAtYearMonthDay(list,yearMonth){
	let balance = getInitialBalanceAtYearMonth(list,yearMonth);
	
	let days = getDateArray(yearMonth.month).filter(function(day){ return day<=yearMonth.day;});

	days.forEach( (day) => balance += computeCDByDay(list,{"year": yearMonth.year,"month":yearMonth.month,"day":day}));
	
	return balance;
}

function computeCDByDay(list,yearMonth){
	return (list.filter(yearMonthDayEquals,yearMonth).filter(isNotBalance)).reduce(function(a,b){ return a + b.valor;}, 0);
}


function isDebit(obj){
	return obj.valor < 0 && !(obj.textoIdentificador === "Saldo Corrente");
}

function isNotBalance(obj){
	return !(obj.textoIdentificador === "Saldo Corrente");
}


function isCredit(obj){
	return obj.valor > 0 && !(obj.textoIdentificador === "Saldo Corrente");
}


function getInitialBalanceAtYearMonth(list,yearMonth){	
	let balance = 0;
	(filterByYearMonth(list,yearMonth)).forEach(function (obj) {
		if (obj.textoIdentificador === "Saldo Corrente")
			balance = obj.valor;
	});
	return balance;
}
function dateSort(a,b){
	return a.data - b.data;
}


//Interface
function filterDate(e){
	let d = e.target.value.split('-');
	yearMonth = {"year": Number(d[0]), "month": Number(d[1]),"day": Number(d[2])};
	updateEverything();
}
function filterChange(e){
	filterType = e;
	updateEverything();
}

function updateEverything(){
	//Receita Mês
	document.getElementById("receitaMes").innerHTML = "Receita Mês: R$  " + computeCreditsByYearMonth(db,yearMonth).toFixed(2);
	document.getElementById("despesaMes").innerHTML = "Despesas Mês: R$ " + computeDebitsByYearMonth(db,yearMonth).toFixed(2);
	document.getElementById("sobraMes").innerHTML = "Sobra Mês: R$ " + computeDCByYearMonth(db,yearMonth).toFixed(2);
	document.getElementById("saldoMes").innerHTML = "Saldo Mês: R$ " + computeBalance(db,yearMonth).toFixed(2);


	document.getElementById("saldoMax").innerHTML = "Saldo Max: R$ " + getMaxBalance(db,yearMonth).toFixed(2);
	document.getElementById("saldoMin").innerHTML = "Saldo Min: R$ " + getMinBalance(db,yearMonth).toFixed(2);


	document.getElementById("receitaMedia").innerHTML = "Receita Média/Ano: R$ " + computeCreditMeansByYear(db,yearMonth).toFixed(2);
	document.getElementById("despesaMedia").innerHTML = "Despesa Média/Ano: R$ " + computeDebitsMeansByYear(db,yearMonth).toFixed(2);
	document.getElementById("sobraMedia").innerHTML = "Sobra Média/Ano: R$ " + computeDCMeans(db,yearMonth).toFixed(2);


	document.getElementById("fluxoDeCaixa").innerHTML = "Fluxo de caixa:  <br>" + getCashFlow(db,yearMonth).join("<br>");
	
	let el = document.getElementById("main");
	let filtered = db;
	switch (filterType) {
	  	case "year": 			
	  		filtered = filterByYear(filtered,yearMonth); 	
	  	break;

	  	case "yearMonth": 		
	  		filtered = filterByYearMonth(filtered,yearMonth); 	
	  	break;
	  	
	  	case "yearMonthDay": 	
	  		filtered = filterByYearMonthDay(filtered,yearMonth); 	
	  	break;
	}
	populateHTML(filtered);	
}

function populateHTML(arr){
	let el = document.getElementById("main");
	el.innerHTML = "";
	arr.forEach(a=>{
		let ul = document.createElement("ul");
		let l1 = document.createElement("li");
		let l2 = document.createElement("li");
		let l3 = document.createElement("li");

		l1.innerHTML = "Descrição: " + a.textoIdentificador; 
		l2.innerHTML = "valor: " + a.valor; 
		l3.innerHTML = "Data: " + a.data; 
	
		ul.append(l1);
		ul.append(l2);
		ul.append(l3);

		el.append(ul);
	})
}