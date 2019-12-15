const express = require('express')
const mysql = require('mysql')
const bodyParser = require('body-parser');


//create connection to database
const db = mysql.createConnection({
	host : '',
	user : ''
	password : '',
	database : 'Stores',
	port : '3306'
});

//try to connect to database
db.connect((err) => {
	if(err){
		throw err;
	}
	console.log('MySql Connected...');
});

const app = express();
const port = 3000;


app.use(bodyParser.json() );
app.use(bodyParser.urlencoded({ extended: true }));
/*
 * GET request for an item 
 * Occurs when a user searches for an item to add to their list
*/
app.get('/Easygrocery/api/item', (req, res) => {
	try{
		var item = req.query.item;
		console.log("Request for item: " + item);

		//construct sql request for safeway
		//
		//SELECT * FROM (
		// SELECT ...
		// UNION
		// SELECT ...
		//)
		let sql = "SELECT productName FROM Safeway where productName like \'\%"
		words = item.split(" "); //split item into individual words
		for(var i = 0; i < words.length; i++)
			sql += (words[i] + "\%");
	
		sql += "\'";
		sql += " UNION "
		sql += "SELECT productName FROM Walmart where productName like \'\%"
		words = item.split(" "); //split item into individual words
		for(var i = 0; i < words.length; i++)
			sql += (words[i] + "\%");
	
		sql += "\'";
		
		console.log("db request = " + sql);
		//do sql query and store the results in rescontainer
		db.query(sql, (err, result) => {
			if(err) throw err;
			res.json(result);
		});
	}
	catch(err){
		console.log("An error occurred...");
	}
});	

//function to compare two strings and get the similarity
function compareSimilarity(target, other){
    let l1 = target.length;
    let l2 = other.length;
    let half = (l1+l2)/2;
    let count = 0;
    
    //convert both strings to lower case
    lowerTarget = target.toLowerCase();
    lowerOther = other.toLowerCase();
    
    targetWords = lowerTarget.split(" ");
    otherWords = lowerOther.split(" ");

    otherWords.forEach( function(other){
        if( targetWords.includes(other) ){
            count += 1;
        }
    });
    let value = count / half;
    return value;
}


//find most similar value from list of results
function findMostSimilar(target, results){
    if(results.length === 0){ return "NULL" }
    var length = results.length;
    let values = [];
    let score = 0;
    let simName = results[0].ProductName;
    let simPrice = results[0].ProductPrice;
    let i = 0;
    for(i=0; i<length; i+=1){
        let item = results[i].ProductName;
        let sc = compareSimilarity(target, item); 
        if(sc > score ){
            score = sc;
            simName = item;
            simPrice = results[i].ProductPrice;
        }
    }
    values[0] = simName;
    values[1] = simPrice
    return values;
}

/*
Converts store information to json format
*/
function convertToJson(info){
    let sPrice = info[0].toFixed(2);
    let sList = info[1];
    let sUnk = info[2];
    let wPrice = info[3].toFixed(2);
    let wList = info[4];
    let wUnk = info[5];
    let jsonStr = "";

    //beginning of json
    jsonStr += "[{";
    
    //safeway to json
        //cost
        jsonStr += "\"cost\" : "; 
        jsonStr += sPrice;
        jsonStr += ","
        //items
        jsonStr += "\"items\" : [";
        sList.forEach( function(item) {
            //parts = item.split(",");
            name = item[0];
            cost = item[1];
            json = "{ \"name\" : \"" + name + "\", \"cost\" : " + cost + "}";
            if(item !== sList[sList.length-1]){ json += ","; }
            jsonStr += json;
        }); 
        jsonStr += "],";
        //unknown
        //unknown
        jsonStr += "\"unknown\" : "; 
        jsonStr += wUnk;

    jsonStr+= "},";

    //walmart to Json
    jsonStr += "{";
        //cost
        jsonStr += "\"cost\" : "; 
        jsonStr += wPrice;
        jsonStr += ",";
        //items
        jsonStr += "\"items\" : [";
        wList.forEach( function(item) {
            //parts = item.split(",");
            name = item[0];
            cost = item[1];
            json = "{ \"name\" : \"" + name + "\", \"cost\" : " + cost + "}";
            if(item !== wList[wList.length-1]){ json += ","; }
            jsonStr += json;
        }); 
        jsonStr += "],";
        //unknown
        jsonStr += "\"unknown\" : "; 
        jsonStr += wUnk;

    //end of json
    jsonStr += "}]";
    
    return jsonStr;
}

/*
 * POST request
 * Occurs whenever a user requests to compare prices from the list
 *
*/
app.post('/Easygrocery/api/compare', (req, res) => {
	//construct list of all items from request
	const listLength = req.body.length;
	var list = [];
	let i = 0;
	for(i = 0; i < listLength; i++){
		list.push(req.body[i].itemname);
	}

    //initialize all variables
    let safewayPrice = 0;
    let walmartPrice = 0;
    let safewayList = [];
    let walmartList = [];
    let safewayUnknown = 0;
    let walmartUnknown = 0;

    //for each item in the list
    list.forEach( function(item) {
        var inSafeway = false;
        var inWalmart = false;
        var safewayTempPrice = 0;
        var walmartTempPrice = 0;
        var safewayTempName = "";
        var walmartTempName = "";
        var safewayCategory = "";
        //Search for item in safeway
        //create sql query
        let sql1 = `select ProductName, ProductPrice, Category from Safeway where ProductName = \'${item}\';`;
        //execute query
        db.query(sql1, (err, result) => {
            if(err) throw err;
            //if result not empty
            if(result.length != 0){
                inSafeway = true;
                safewayTempPrice = result[0].ProductPrice;
                safewayTempName = result[0].ProductName;
                safewayCategory = result[0].Category;
            }
        });
        
        //Search for item in walmart
        //create sql query
        let sql2 = `select ProductName, ProductPrice from Walmart where ProductName = \'${item}\';`;
        //execute query
        db.query(sql2, (err, result) => {
            if(err) throw err;
            //if result not empty
            if(result.length != 0){
                inWalmart = true;
                walmartTempPrice = result[0].ProductPrice;
                walmartTempName = result[0].ProductName;
            }
        });

        //wait for queries to complete
        setTimeout(() => {  
            if( inSafeway && inWalmart){
                safewayPrice += safewayTempPrice;
                safewayList.push(safewayTempName);
                walmartPrice += walmartTempPrice;
                walmartList.push(walmartTempName);
            }
            else if( inSafeway ) {
                safewayPrice += safewayTempPrice;
                safewayList.push([safewayTempName, safewayTempPrice]);
                //find most similar from walmart 
                let sql3 = "select ProductName, ProductPrice from Walmart;";
                db.query(sql3, (err, result) => { 
                    if(err) throw err;        
                    //find most similar from results
                    values = findMostSimilar(safewayTempName, result);
                    if(values !== "NULL"){
                        walmartPrice += values[1];
                        toAdd = [values[0], values[1]]
                        walmartList.push(toAdd);
                    }
                }); 
            }
            else if( inWalmart) {
                walmartPrice += walmartTempPrice;
                walmartList.push([walmartTempName, walmartTempPrice]);
                //find most similar in safeway
                let sql4 = `select ProductName, ProductPrice from Safeway where Category = \'${safewayCategory}\';`;
                db.query(sql4, (err, result) => { 
                    if(err) throw err;
                    //find most similar from results
                    values = findMostSimilar(walmartTempName, result);
                    if(values !== "NULL"){
                        safewayPrice += values[1];
                        toAdd = [values[0], values[1]]
                        safewayList.push(toAdd);
                    }   
                }); 
            }
            else {
                safewayUnknown += 1;
                walmartUnknown += 1;
            }
        }, 500);
    });

    //format results and send to app
    setTimeout(() => {
        let info = [safewayPrice, safewayList, safewayUnknown, walmartPrice, walmartList, walmartUnknown ];
        let packet = convertToJson(info);
        res.send(packet);
    }, 1000);
});



app.listen(port, () => console.log(`Easygrocery api listening on port ${port}!`))
