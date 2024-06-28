var orderProduct ={};
var cartProductsFromDb = undefined;

const addToCart = (event) => {
  console.log(event)
  cartOrderProductId = event.target.dataset.id
  this.orderProduct[cartOrderProductId] = 1;
  if (this.orderProduct[cartOrderProductId]== this.cartProductsFromDb[cartOrderProductId]){
    delete this.orderProduct[cartOrderProductId];
  }

  for(let element of $(`.cart_item_quantity_box_${cartOrderProductId}`)){
    console.log(element)
    element.innerHTML = this.orderProduct[cartOrderProductId]!=undefined ? this.orderProduct[cartOrderProductId] : this.cartProductsFromDb[cartOrderProductId]
  };
  for(let element of $(`.CartActionButtons_${cartOrderProductId}`)){
    element.classList.remove("hideElement")
  }
  for(let element of $(`.AddToCartButton_${cartOrderProductId}`)){
    element.classList.add("hideElement")
  }
  $('#client_cart_products')[0].value = JSON.stringify(this.orderProduct);
}

const addOrderProduct = (event) => {
  cartOrderProductId = event.target.dataset.id
  this.orderProduct[cartOrderProductId] =(this.orderProduct[cartOrderProductId]!=undefined ? this.orderProduct[cartOrderProductId] :this.cartProductsFromDb[cartOrderProductId]) + 1 ;
  if (this.orderProduct[cartOrderProductId]== this.cartProductsFromDb[cartOrderProductId]){
    delete this.orderProduct[cartOrderProductId];
  }
  for(let element of $(`.cart_item_quantity_box_${cartOrderProductId}`)){
    element.innerHTML = this.orderProduct[cartOrderProductId] ? this.orderProduct[cartOrderProductId] : this.cartProductsFromDb[cartOrderProductId]
  }
  $('#client_cart_products')[0].value = JSON.stringify(this.orderProduct);
}
const removeOrderProduct = (event) =>{
  cartOrderProductId = event.target.dataset.id
  if(this.orderProduct[cartOrderProductId]==1 || (this.orderProduct[cartOrderProductId]==undefined && this.cartProductsFromDb[cartOrderProductId]==1)){
    for(let element of $(`.CartActionButtons_${cartOrderProductId}`)){
        element.classList.add("hideElement")
    }
    for(let element of $(`.AddToCartButton_${cartOrderProductId}`)){
      element.classList.remove("hideElement")
    }

    if (!this.cartProductsFromDb[cartOrderProductId]) {
      delete this.orderProduct[cartOrderProductId];
    }
    else {
      this.orderProduct[cartOrderProductId] = 0 ;
    }
  }else {
    this.orderProduct[cartOrderProductId]  = (this.orderProduct[cartOrderProductId]!=undefined ? this.orderProduct[cartOrderProductId] : this.cartProductsFromDb[cartOrderProductId]) - 1 ;
  }

  if (this.orderProduct[cartOrderProductId]== this.cartProductsFromDb[cartOrderProductId]){
    delete this.orderProduct[cartOrderProductId];
  }

  for(let element of $(`.cart_item_quantity_box_${cartOrderProductId}`)){
    element.innerHTML = this.orderProduct[cartOrderProductId] ? this.orderProduct[cartOrderProductId] : this.cartProductsFromDb[cartOrderProductId]
  }
  $('#client_cart_products')[0].value = JSON.stringify(this.orderProduct);
}


jQuery(document).ready(function(){
  cartProductsFromDb = ($('#cart_products_from_db')[0]!=undefined ) ? JSON.parse($('#cart_products_from_db')[0].dataset.source): undefined;

})

