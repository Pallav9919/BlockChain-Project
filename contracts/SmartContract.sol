// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.22 <0.9.0;

contract SmartContract {

    // ProcessOfProduct

    struct ProcessOfProduct{
        mapping(uint256 => uint256) processId;
        uint256 processCount; 
    }

    mapping(uint256 => ProcessOfProduct) processOfProducts;

    function addProcessToProduct(uint256 productId,uint256 processId) public {
        processOfProducts[productId].processId[processOfProducts[productId].processCount] = processId;
        ++processOfProducts[productId].processCount;
    }

    function addProcessToProductAtIndex(uint256 productId,uint256 processId,uint256 index) public {
        for(uint256 i=processOfProducts[productId].processCount;i>index;--i){
            processOfProducts[productId].processId[i] = processOfProducts[productId].processId[i-1];
        }
        processOfProducts[productId].processId[index] = processId;
        ++processOfProducts[productId].processCount;
    }

    function removeProcessFromProduct(uint256 productId,uint256 index) public {
        for(uint256 i=index;i<processOfProducts[productId].processCount;++i){
            processOfProducts[productId].processId[i] = processOfProducts[productId].processId[i+1];
        }
        --processOfProducts[productId].processCount;
    }

    function getProcessOfProducts(uint256 productId) public view returns(uint256[] memory) {
        uint256[] memory memoryArray = new uint256[](processOfProducts[productId].processCount);
        for(uint256 i=0;i<processOfProducts[productId].processCount;++i){
            memoryArray[i] = processOfProducts[productId].processId[i];
        }
        return memoryArray;
    }

    // Product 
    uint256 productCount = 0;

    struct Product {
        uint256 productId;
        string productName;
        string productDescription;
        uint256 maxTemprature;
    }

    mapping(uint256 => Product) products;

    function addProduct(
        string memory productName,
        string memory productDescription,
        uint256 maxTemprature
    ) public returns (uint256) {
        products[productCount] = Product(
            productCount,
            productName,
            productDescription,
            maxTemprature
        );
        processOfProducts[productCount].processCount = 0;
        return productCount++;
    }

    function updateProductName(
        uint256 productId, 
        string memory productName
    ) public {
        products[productId].productName = productName;
    }

    function updateProductDescription(
        uint256 productId,
        string memory productDescription
    ) public {
        products[productId].productDescription = productDescription;
    }

    function getNumberOfProducts() public view returns (uint256) {
        return productCount;
    }

    function updateProductMaxTemprature(
        uint256 productId,
        uint256 maxTemprature
    ) public {
        products[productId].maxTemprature = maxTemprature;
    }

    function getProductDetails() public view returns (Product[] memory) {
        Product[] memory memoryArray = new Product[](productCount);
        for (uint256 i = 0; i < productCount; ++i) {
            memoryArray[i] = products[i];
        }
        return memoryArray;
    }

    function getProductDetailsById(uint256 productId) public view returns (Product memory) {
        return products[productId];
    }

    // Process

    uint256 processCount = 0;

    struct Process {
        uint256 processId;
        string processName;
        string processDescription;
    }

    mapping(uint256 => Process) processes;

    function addProcess(string memory processName, string memory processDescription) public returns(uint256){
        processes[processCount] = Process(
            processCount,
            processName,
            processDescription
        );
        return processCount++;
    }    

    function updateProcessName(
        uint256 processId, 
        string memory processName
    ) public {
        processes[processId].processName = processName;
    }

    function updateProcessDescription(
        uint256 processId,
        string memory processDescription
    ) public {
        processes[processId].processDescription = processDescription;
    }

    function getNumberOfProcesses() public view returns (uint256) {
        return processCount;
    }

    function getProcessDetails() public view returns (Process[] memory) {
        Process[] memory memoryArray = new Process[](processCount);
        for (uint256 i = 0; i < processCount; ++i) {
            memoryArray[i] = processes[i];
        }
        return memoryArray;
    }

    function getProcessDetailsById(uint256 processId) public view returns(Process memory) {
        return processes[processId];
    }

    // Refrigerator

    uint256 refrigeratorCount = 0;

    struct Refrigerator {
        uint256 refrigeratorId;
        uint256 itemsCount;
        mapping (uint256 => uint256) items;
    }

    mapping(uint256 => Refrigerator) refrigerators;

    function addRefrigerator() public returns(uint256){
        refrigerators[refrigeratorCount].refrigeratorId = refrigeratorCount;
        refrigerators[refrigeratorCount].itemsCount = 0;
        return refrigeratorCount++;
    } 

    function addItemInRefrigerator(
        uint256 refrigeratorId,
        uint256 itemId
    ) public {
        refrigerators[refrigeratorId].items[refrigerators[refrigeratorId].itemsCount++] = itemId;
    }  

    function remmoveItemFromRefrigerator(uint256 refrigeratorId,uint256 itemId) public {
        uint256 itemIndex = 0;
        for(;itemIndex<refrigerators[refrigeratorId].itemsCount;++itemIndex){
            if(refrigerators[refrigeratorId].items[itemIndex] == itemId){
                break;
            }
        }
        --refrigerators[refrigeratorId].itemsCount;
        for(;itemIndex<refrigerators[refrigeratorId].itemsCount;++itemIndex){
            refrigerators[refrigeratorId].items[itemIndex] = refrigerators[refrigeratorId].items[itemIndex+1];
        }
    }

    function addTemprature(uint256 refrigeratorId,uint256 temprature) public {
        for(uint256 i=0;i<refrigerators[refrigeratorId].itemsCount;++i){
            if(products[items[refrigerators[refrigeratorId].items[i]].productId].maxTemprature < temprature){
                items[refrigerators[refrigeratorId].items[i]].isUsable = false;
            }
        }
    }

    // Employee

    uint256 employeeCount = 0;

    struct Employee {
        uint256 employeeId;
        string employeeName;
        uint256 contactNumber;
        bool isVaccinated;
        uint256 numberOfDose;
        string vaccineName;
    }

    mapping(uint256 => Employee) employees;

    function addEmployee(
        string memory employeeName,
        uint256 contactNumber
    ) public returns(uint256) {
        employees[employeeCount] = Employee(
            employeeCount,
            employeeName,
            contactNumber,
            false,
            0,
            "NA"
        );
        return employeeCount++;
    }

    function addEmployee(
        string memory employeeName,
        uint256 contactNumber,
        uint256 numberOfDose,
        string memory vaccineName
    ) public returns(uint256) {
        employees[employeeCount] = Employee(
            employeeCount,
            employeeName,
            contactNumber,
            true,
            numberOfDose,
            vaccineName
        );
        return employeeCount++;
    }

    // Retailer

    uint256 retailerCount = 0;

    struct Retailer {
        uint256 retailerId;
        string retailerName;
        string retailerAddress;
    }

    mapping (uint256 => Retailer) retailers;

    function addRetailer(string memory retailerName,string memory retailerAddress) public returns(uint256) {
        retailers[retailerCount] = Retailer(retailerCount,retailerName,retailerAddress);
        return retailerCount++;
    }

    // Products to produce

    mapping(uint256 => uint256) amountOfProductsToProduce;

    function getAmountOfProductsToProduce() public view returns(uint256[] memory) {
        uint256[] memory memoryArray = new uint256[](productCount);
        for(uint256 i=0;i<productCount;++i){
            memoryArray[i] = amountOfProductsToProduce[i];
        }
        return memoryArray;
    }

    function getAmountOfProductToProduce(uint256 productId) public view returns(uint256) {
        return amountOfProductsToProduce[productId];
    }

    // Order

    uint256 orderCount = 0;

    struct Order {
        uint256 orderId;
        uint256 retailerId;
        mapping(uint256 => uint256) productAmount;
        bool isDelivered;
    }

    mapping(uint256 => Order) orders;

    function placeOrder(uint256 retailerId,uint256[] memory productAmount) public returns(uint256) {
        orders[orderCount].orderId = orderCount;
        orders[orderCount].retailerId = retailerId;
        orders[orderCount].isDelivered = false;
        for(uint256 i=0;i<productCount;++i){
            if(productAmount[i] != 0) {
                orders[orderCount].productAmount[i] = productAmount[i];
                amountOfProductsToProduce[i] += productAmount[i];
            }
        }
        return orderCount++;
    }

    struct ReturnOrder {
        uint256 orderId;
        uint256 retailerId;
        uint256[] productAmount;
        bool isDelivered;
    }

    function getOrderDetails(uint256 orderId) public view returns(ReturnOrder memory) {
        ReturnOrder memory memoryReturnOrder;
        memoryReturnOrder.orderId = orderId;
        memoryReturnOrder.retailerId = orders[orderId].retailerId;
        memoryReturnOrder.productAmount = new uint256[](productCount);
        memoryReturnOrder.isDelivered = orders[orderId].isDelivered;
        for(uint256 i=0;i<productCount;++i){
            memoryReturnOrder.productAmount[i] = orders[orderId].productAmount[i];
        }
        return memoryReturnOrder;
    }

    function updateOrderDetails(uint256 orderId,uint256[] memory productAmount) public {
        for(uint256 i=0;i<productCount;++i){
            if(productAmount[i] != 0) {
                orders[orderId].productAmount[i] -= productAmount[i];
            }
        }
    }

    // Milk

    uint256 milkCount = 0;

    struct Milk {
        uint256 milkId;
        uint256 milkAmount;
        uint256 timestamp;
    }

    mapping (uint256 => Milk) milks;

    function addMilk(uint256 milkAmount, uint256 timestamp) public returns(uint256) {
        milks[milkCount] = Milk(
            milkCount,
            milkAmount,
            timestamp
        );
        return milkCount++;
    }

    function reduceMilk(uint256 milkId, uint256 milkAmount) public {
        milks[milkId].milkAmount -= milkAmount;
    }

    function getAmountOfMilks() public view returns(Milk[] memory) {
        Milk[] memory memoryArray = new Milk[](milkCount);
        for(uint256 i=0;i<milkCount;++i){
            memoryArray[i] = milks[i];
        }
        return memoryArray;
    }

    // Item
    
    uint256 itemCount = 0;
    
    struct Item {
        uint256 itemId;
        uint256 productId;
        mapping (uint256 => uint256) processTimestamp;
        mapping (uint256 => bool) employeeWorked;
        bool isUsable;
    }

    struct ReturnItem {
        uint256 itemId;
        uint256 productId;
        uint256[] processTimestamp;
        bool[] employeeWorked;
        bool isUsable;
    }

    mapping(uint256 => Item) items;

    function addItem(uint256 productId) public returns(uint256){
        --amountOfProductsToProduce[productId];
        items[itemCount].itemId = itemCount;
        items[itemCount].productId = productId;
        items[itemCount].isUsable = true;
        return itemCount++;
    }

    function addEmployeeToItem(uint256 itemId,uint256 employeeId) public {
        items[itemId].employeeWorked[employeeId] = true;
    }

    function addProcessToItem(uint256 itemId,uint256 processId,uint256 timestamp) public {
        items[itemId].processTimestamp[processId] = timestamp;
    }

    function getItemDetails(uint256 itemId) public view returns(ReturnItem memory){
        ReturnItem memory memoryReturnItem;
        memoryReturnItem.itemId = itemId;
        memoryReturnItem.productId = items[itemId].productId;
        memoryReturnItem.isUsable = items[itemId].isUsable;
        memoryReturnItem.processTimestamp = new uint256[](processCount);
        memoryReturnItem.employeeWorked = new bool[](employeeCount);
        for(uint256 i=0;i<processCount;++i){
            memoryReturnItem.processTimestamp[i] = items[itemId].processTimestamp[i];
        }
        for(uint256 i=0;i<employeeCount;++i){
            memoryReturnItem.employeeWorked[i] = items[itemId].employeeWorked[i];
        }
        return memoryReturnItem;
    }

    function getNumberOfItems() public view returns(uint256) {
        return itemCount;
    }

}
