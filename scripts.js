let promptText1, defaultText1, userInputTotal;
let promptText2, defaultText2, userInputRate;

promptText1 = "Enter the bill amount";
defaultText1 = "Type your answer here.";
promptText2 = "Enter the percent tip";
defaultText2 = "Type your answer here.";
userInputTotal = prompt(promptText1, defaultText1);
userInputRate = prompt(promptText2, defaultText2);

let tipCalculator;
tipCalculator = function(userInputTotal, userInputRate){
    // check to see if % less than 1
    let tipRate_noChars;
    let tipRate;
    tipRate_noChars = userInputRate.replace(/[%,]+/g,"");
    if (parseFloat(tipRate_noChars) < 1) {
      tipRate = parseFloat(tipRate_noChars);
    } else {
      tipRate = parseFloat(tipRate_noChars) / 100;
    };
    // get rid of dollar sign if entered
    // and convert to $x.xx
    let baseAmount;
    baseAmount = userInputTotal.replace(/[$,]+/g,"");
    baseAmount = parseFloat(baseAmount).toFixed(2);
    let tipAmount;
    tipAmount = tipRate * baseAmount;
    tipAmount = tipAmount.toFixed(2);
    // format output statement
  $("#response").html("Your tip is $" + tipAmount + 
    "<br />" + "(This is " + tipRate*100 + "% of $" + baseAmount + ")");
}; 

// Now call (or “execute”) the function
tipCalculator(userInputTotal, userInputRate);


