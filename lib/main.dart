// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'process.dart';
import 'product.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Milk Factory',
      home: MilkFactory(),
    );
  }
}

_MilkFactoryState milkFactoryState = _MilkFactoryState();

class MilkFactory extends StatefulWidget {
  const MilkFactory({Key? key}) : super(key: key);

  @override
  _MilkFactoryState createState() => milkFactoryState;
}

class _MilkFactoryState extends State<MilkFactory> {
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545/";

  final String _privateKey =
      "9b65be4ea79ceec77bec428643e3709e79973a16d577fdf4dd0e62741f580a42";

  late Web3Client _client;
  bool isLoading = true;

  late String _abiCode;

  late EthereumAddress _contractAddress;

  late Credentials _credentials;

  late EthereumAddress _ownAddress;

  late DeployedContract _contract;

  late ContractFunction _getNumberOfProducts;
  late ContractFunction _addProduct;
  late ContractFunction _getProductDetails;

  _MilkFactoryState() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/SmartContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "SmartContract"), _contractAddress);
    _getNumberOfProducts = _contract.function("getNumberOfProducts");
    _addProduct = _contract.function("addProduct");
    _getProductDetails = _contract.function("getProductDetails");
    // print(await _client.call(contract: _contract, function: _addProduct, params: ["Pallav","Pallav",BigInt.from(20)]));
    // await _client.sendTransaction(_credentials, Transaction.callContract(contract: _contract, function: _addProduct, parameters:["Pallav","Pallav",BigInt.from(20)], maxGas: 1000000));
  }

  Future<List<dynamic>> getProductDetails() async {
    return await _client
        .call(contract: _contract, function: _getProductDetails, params: []);
  }

  Future<void> addPoduct() async {
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _addProduct,
            parameters: ["Pallav", "Pallav", BigInt.from(20)],
            maxGas: 1000000));
  }

  String title = 'Product';
  Widget body = product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Text(
                'Milk Factory',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Product'),
              onTap: () {
                setState(() {
                  title = 'Product';
                  body = product;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: const Text('Process'),
              onTap: () {
                setState(() {
                  title = 'Process';
                  body = process;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : body,
    );
  }
}
