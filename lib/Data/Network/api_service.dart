import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puff_vpn/Controller/vpn_controller.dart';
import 'package:puff_vpn/Data/app_exception.dart';
import 'package:puff_vpn/Model/vpn_server_model.dart';
import 'package:puff_vpn/Utils/helper_functions.dart';

class ApiServices {
  final vpnController = Get.find<VpnController>();

  Future<List<VpnServer>> getGetApiResponce(String url) async {
    final List<VpnServer> vpnServerList = [];
    try {
      debugPrint("🔍 Hitting API");
      // Empty list to store processed data
      final List<VpnServer> localVpnServerList = [];

      // Hit API and check status code
      var response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 100), onTimeout: () {
        throw RequestTimeOut("Request timed out");
      });

      // Use returnResponse to handle status code
      dynamic jsonResponse = returnResponse(response);

      // Process the CSV data if the response is successful
      if (jsonResponse is String) {
        // Remove unnecessary symbols
        final csvString = jsonResponse.split("#")[1].replaceAll("*", '');

        // Convert CSV to list
        List<List<dynamic>> csvList =
            const CsvToListConverter().convert(csvString);
        // Empty map
        Map<String, dynamic> tempJson = {};

        // Store header
        final header = csvList[0];

        // Run loop to add all list data into model list
        for (var i = 1; i < csvList.length - 1; i++) {
          for (var j = 0; j < header.length; j++) {
            tempJson.addAll({header[j]: csvList[i][j]});
          }
          localVpnServerList.add(VpnServer.fromJson(tempJson));
        }

        // Add the processed data to the final list
        vpnServerList.addAll(localVpnServerList);

        // Save the list to shared preferences
        await vpnController.saveVpnServers(vpnServerList);
      } else {
        HelperFunctions.showSnackbar(
            title: "Error",
            message: "An unexpected error occurred. Please try again.",
            icon: Icon(Icons.error));
        throw FetchDataException("Unexpected response format");
      }
    } on SocketException {
      vpnController.isLoading.value = false;
      HelperFunctions.showSnackbar(
          title: "Network Error",
          message: "No Internet Connection",
          icon: Icon(Icons.signal_wifi_statusbar_connected_no_internet_4));
      throw InternetException("No Internet Connection");
    } on RequestTimeOut {
      vpnController.isLoading.value = false;
      HelperFunctions.showSnackbar(
          title: "Request Timeout",
          message: "Request Timeout. Please try again later.",
          icon: Icon(Icons.timer_outlined));
      throw RequestTimeOut('Request Timeout');
    } catch (e) {
      debugPrint("Error on catch $e");
      vpnController.isLoading.value = false;
      HelperFunctions.showSnackbar(
          title: "Error",
          message: "An unexpected error occurred. Please try again.",
          icon: Icon(Icons.error));
      rethrow;
    }
    return vpnServerList;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        vpnController.isLoading.value = false;
        return response.body;

      case 400:
        vpnController.isLoading.value = false;
        return response.body;

      case 401:
      case 403:
        vpnController.isLoading.value = false;
        throw UnauthorisedException();

      case 404:
        vpnController.isLoading.value = false;
        throw FetchDataException(
            'Not found: ${response.statusCode.toString()}');

      case 500:
      case 502:
      case 503:
      case 504:
        vpnController.isLoading.value = false;
        HelperFunctions.showSnackbar(
            title: "Server Error",
            message:
                "There was an issue with the server. Please try again later.",
            icon: Icon(Icons.error));
        throw FetchDataException(
            'Error communicating with server! ${response.statusCode.toString()}');

      default:
        vpnController.isLoading.value = false;
        HelperFunctions.showSnackbar(
            title: "Error",
            message: "An unexpected error occurred. Please try again.",
            icon: Icon(Icons.error));
        throw FetchDataException(
            'Unexpected error: ${response.statusCode.toString()}');
    }
  }
}
