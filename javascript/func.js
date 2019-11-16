let yearMonth = {"year": 2018, "month": 1,"day": 24};
fetch("http://150.165.15.10:8080/todasTransacoes",{method: 'POST'})
.then((response) => response.json())
.then((result) => {
	result = result.map(cleanObj);
	console.log("revenue:");/*
	console.log(computeBalance(result,yearMonth));
	console.log(computeCreditsByYearMonth(result,yearMonth));
	console.log(computeDebitsByYearMonth(result,yearMonth));
	console.log(computeDCByYearMonth(result,yearMonth));
	console.log(computeCreditMeansByYear(result,yearMonth.year));
	*/
	console.log(getMaxBalance(result,yearMonth));
	//console.log(getCashFlow(result,yearMonth));
	//console.log(computeCDByDay(result,yearMonth));
	//console.log(getBalanceAtYearMonthDay(result,yearMonth));
	//getBalanceAtYearMonthDay(result,yearMonth);
	document.body.innerHTML+=JSON.stringify(filterByYear(result,yearMonth));
	})
.catch((err) => { console.error(err); });




function populateHTML(arr){
	arr.forEach(a=>{})
}


function cleanObj(obj){
	obj.data = new Date(obj.data.year + "-" + obj.data.month + "-" + obj.data.dayOfMonth);
	delete obj.arquivos;
	return obj;
}

//1 - Filtrar transações por ano.
function yearEquals(obj){
	return obj.data.getFullYear() == this.year;
}
function filterByYear(list, yearMonth){
	return list.filter(yearEquals,yearMonth);
}

//2 - Filtrar transações por ano e mês.
function yearMonthEquals(obj){
	return obj.data.getFullYear() == this.year && obj.data.getMonth()+1 == this.month;
}

function filterByYearMonth(list, yearMonth){
	return list.filter(yearMonthEquals,yearMonth);
}
//3 - Calcular o valor das receitas (créditos) em um determinado mês e ano.
function computeCreditsByYearMonth(list,yearMonth){
	return (filterByYear(list,yearMonth).filter(isCredit)).reduce(function(a,b){ return a + b.valor;}, 0);
}
//4 - Calcular o valor das despesas (débitos) em um determinado mês e ano.
function computeDebitsByYearMonth(list,yearMonth){
	return (list.filter(yearMonthEquals,yearMonth).filter(isDebit)).reduce(function(a,b){ return a + b.valor;}, 0);
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
function getMaxBalance(list,yearMonth){
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
function computeCreditMeansByYear(list,year){
	let filtered = list.filter(yearEquals,year).filter(isCredit);
	return (filtered).reduce(function(a,b){ return a + b.valor;}, 0) /filtered.length;
}
//10 - Calcular a média das despesas em determinado ano
function computeDebitsMeansByYear(list,year){
	let filtered = list.filter(yearEquals,year).filter(isDebit);
	return (filtered).reduce(function(a,b){ return a + b.valor;}, 0) /filtered.length;
}
//11 - Calcular a média das sobras em determinado ano
function computeDCMeans(list,yearMonth){
	let filtered = list.filter(yearEquals,year).filter(isNotBalance);
	return (filtered).reduce(function(a,b){ return a + b.valor;}, 0) /filtered.length;
}

//12 - Retornar o fluxo de caixa de determinado mês/ano. O fluxo de caixa nada mais é do que uma lista contendo pares (dia,saldoFinalDoDia). 
function getCashFlow(list, yearMonth){
	let balance = getInitialBalanceAtYearMonth(list,yearMonth);
	let cashFlow = [];
	days = getDateArray(yearMonth.month);
	days.forEach((day) => cashFlow.push([day,getBalanceAtYearMonthDay(list,{"year": yearMonth.year,"month":yearMonth.month,"day":day})]));
	return cashFlow;
}


//UTIL
function getDateArray(month){
	return (Array.from(Array(new Date(yearMonth.year, month+1, 0).getDate()).keys())).map((x) => x+1);
}


function getBalanceAtYearMonthDay(list,yearMonth){
	let balance = getInitialBalanceAtYearMonth(list,yearMonth);
	let days = getDateArray(yearMonth.month).filter(function(day){ return day<=yearMonth.day;});
	days.forEach((day)=> balance+=computeCDByDay(list,day));
	return balance;
}

function computeCDByDay(list,day){
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


function yearMonthDayEquals(obj){
	return obj.data.getFullYear() == this.year && obj.data.getMonth()+1 == this.month && obj.data.getDate() == this.day;
}

function filterByYearMonthDay(list, yearMonth){
	return list.filter(yearMonthDayEquals,yearMonth);
}
function getInitialBalanceAtYearMonth(list,yearMonth){	
	let balance = 0;
	(filterByYearMonthDay(list,yearMonth)).forEach(function (obj) {
		if (obj.textoIdentificador === "Saldo Corrente")
			balance = obj.valor;
	});
	return balance;
}
function dateSort(a,b){
	return a.data - b.data;
}