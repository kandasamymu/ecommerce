function changeh2toInputTag(event){
  var product_id = event.target.dataset.id
  h2 = document.getElementById(`${product_id}_h2`)
  menuInput = document.getElementById(`${product_id}_input`)
  editButton = document.getElementById(`${product_id}_edit`)
  saveButton = document.getElementById(`${product_id}_save`)
  cancelButton = document.getElementById(`${product_id}_cancel`)

  h2.classList.add("hideElement")
  editButton.classList.add("hideElement")

  cancelButton.classList.remove("hideElement")

  menuInput.classList.remove("hideElement")
  saveButton.classList.remove("hideElement")
}

function changeInputToH2Tag(event){
  var product_id = event.target.dataset.id
  h2 = document.getElementById(`${product_id}_h2`)
  menuInput = document.getElementById(`${product_id}_input`)
  editButton = document.getElementById(`${product_id}_edit`)
  saveButton = document.getElementById(`${product_id}_save`)
  cancelButton = document.getElementById(`${product_id}_cancel`)

  h2.classList.remove("hideElement")
  editButton.classList.remove("hideElement")

  cancelButton.classList.add("hideElement")
  menuInput.classList.add("hideElement")
  saveButton.classList.add("hideElement")
}
