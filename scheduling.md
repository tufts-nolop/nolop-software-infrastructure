First, have the staff enter their availability in a when2meet.

Then, run this code in the JS console after loading the when2meet.

```js
// from https://gist.github.com/camtheman256/3125e18ba20e90b6252678714e5102fd?permalink_comment_id=4678586#gistcomment-4678586
function getCSV() {
  result = "Time," + PeopleNames.join(",")+"\n"; 
  for(let i = 0; i < AvailableAtSlot.length; i++) {
      let slot = $x(`string(//div[@id="GroupTime${TimeOfSlot[i]}"]/@onmouseover)`);
      slot = slot.match(/.*"(.*)".*/)[1];
      result += slot + ",";
      result += PeopleIDs.map(id => AvailableAtSlot[i].includes(id) ? 1 : 0).join(",");
      result+= "\n";
  }
  console.log(result);
  return result;
}
content = getCSV()

// Create element with <a> tag
const link = document.createElement("a");

// Create a blog object with the file content which you want to add to the file
const file = new Blob([content], { type: 'text/plain' });

// Add file content in the object URL
link.href = URL.createObjectURL(file);

// Add file name
link.download = "when2meet.csv";

// Add click event to <a> tag to save file.
link.click();
URL.revokeObjectURL(link.href);
```
