class VpnServer {
  final String hostName;
  final String ip;
  final int score;
  final String ping;
  final int speed;
  final String countryLong;
  final String countryShort;
  final int numVpnSessions;
  // final int uptime;//
  // final int totalUsers;//
  // final int totalTraffic;//
  // final String logType;//
  // final String operator;//
  // final String message;//
  final String openVpnConfigDataBase64;

  VpnServer({
    required this.hostName,
    required this.ip,
    required this.score,
    required this.ping,
    required this.speed,
    required this.countryLong,
    required this.countryShort,
    required this.numVpnSessions,
    // required this.uptime,
    // required this.totalUsers,
    // required this.totalTraffic,
    // required this.logType,
    // required this.operator,
    // required this.message,
    required this.openVpnConfigDataBase64,
  });

  factory VpnServer.fromJson(Map<String, dynamic> json) {
    return VpnServer(
      hostName: json['HostName'] as String? ?? "",
      ip: json['IP'] as String? ?? "",
      score: json['Score'] as int? ?? 0,
      ping: json['Ping'].toString(),
      speed: json['Speed'] as int? ?? 0,
      countryLong: json['CountryLong'] as String? ?? "",
      countryShort: json['CountryShort'] as String? ?? "",
      numVpnSessions: json['NumVpnSessions'] as int? ?? 0,
      // uptime: json['Uptime'] as int? ?? 0,
      // totalUsers: json['TotalUsers'] as int? ?? 0,
      // totalTraffic: json['TotalTraffic'] as int? ?? 0,
      // logType: json['LogType'] as String? ?? "",
      // operator: json['Operator'] as String? ?? "",
      // message: json['Message'] as String? ?? "",
      openVpnConfigDataBase64:
          json['OpenVPN_ConfigData_Base64'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'HostName': hostName,
      'IP': ip,
      'Score': score,
      'Ping': ping,
      'Speed': speed,
      'CountryLong': countryLong,
      'CountryShort': countryShort,
      'NumVpnSessions': numVpnSessions,
      // 'Uptime': uptime,
      // 'TotalUsers': totalUsers,
      // 'TotalTraffic': totalTraffic,
      // 'LogType': logType,
      // 'Operator': operator,
      // 'Message': message,
      'OpenVPN_ConfigData_Base64': openVpnConfigDataBase64,
    };
  }

  // Factory constructor to create an empty model
  factory VpnServer.empty() {
    return VpnServer(
      hostName: "",
      ip: "",
      score: 0,
      ping: "",
      speed: 0,
      countryLong: "",
      countryShort: "",
      numVpnSessions: 0,
      // uptime: 0,
      // totalUsers: 0,
      // totalTraffic: 0,
      // logType: "",
      // operator: "",
      // message: "",
      openVpnConfigDataBase64: "",
    );
  }
}
