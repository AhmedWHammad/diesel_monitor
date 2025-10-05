import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/network/api_service.dart';
import '../../../data/repositories/diesel_repository.dart';
import '../../../core/utils/udp_discovery.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _ipController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isDiscovering = false;
  List<String> _discoveredDevices = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final repository = context.read<DieselRepository>();
    _ipController.text = repository.getSavedIpAddress() ?? '';
    _usernameController.text = repository.getSavedUsername() ?? 'admin';
    _passwordController.text = repository.getSavedPassword() ?? '1234';
    _rememberMe = repository.getRememberMe();
    setState(() {});
  }

  @override
  void dispose() {
    _ipController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final repository = context.read<DieselRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Connection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: l10n.ipAddress,
                        hintText: '192.168.1.100',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.router),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isDiscovering ? null : _discoverDevices,
                        icon: _isDiscovering
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(l10n.autoDiscover),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    if (_discoveredDevices.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Discovered Devices:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      ..._discoveredDevices.map((ip) {
                        return ListTile(
                          leading: const Icon(Icons.devices),
                          title: Text(ip),
                          trailing: ElevatedButton(
                            onPressed: () {
                              _ipController.text = ip;
                            },
                            child: const Text('Select'),
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Authentication',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: l10n.username,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title: Text(l10n.rememberMe),
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _saveAndLogin(context),
                        icon: const Icon(Icons.save),
                        label: Text(l10n.save),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preferences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: Text(l10n.updateInterval),
                      subtitle: Slider(
                        value: repository.getUpdateInterval().toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: '${repository.getUpdateInterval()}s',
                        onChanged: (value) {
                          repository.setUpdateInterval(value.toInt());
                          setState(() {});
                        },
                      ),
                      trailing: Text('${repository.getUpdateInterval()}s'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.thermostat),
                      title: Text(l10n.tempUnit),
                      subtitle: Text(
                        repository.isCelsius() ? l10n.celsius : l10n.fahrenheit,
                      ),
                      value: repository.isCelsius(),
                      onChanged: (value) {
                        repository.setTemperatureUnit(value);
                        setState(() {});
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode),
                      title: Text(l10n.theme),
                      subtitle: Text(
                        repository.isDarkMode() ? l10n.dark : l10n.light,
                      ),
                      value: repository.isDarkMode(),
                      onChanged: (value) {
                        repository.setDarkMode(value);
                        setState(() {});
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(l10n.language),
                      trailing: DropdownButton<String>(
                        value: repository.getLanguage(),
                        items: const [
                          DropdownMenuItem(value: 'ar', child: Text('العربية')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            repository.setLanguage(value);
                            setState(() {});
                          }
                        },
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _discoverDevices() async {
    setState(() {
      _isDiscovering = true;
      _discoveredDevices = [];
    });

    try {
      final devices = await UdpDiscovery.discoverESP32();
      setState(() {
        _discoveredDevices = devices;
      });

      if (devices.isEmpty) {
        _showSnackBar('No devices found', AppColors.warning);
      } else {
        _showSnackBar('Found ${devices.length} device(s)', AppColors.success);
      }
    } catch (e) {
      _showSnackBar('Discovery failed: $e', AppColors.danger);
    } finally {
      setState(() {
        _isDiscovering = false;
      });
    }
  }

  Future<void> _saveAndLogin(BuildContext context) async {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) {
      _showSnackBar('Please enter IP address', AppColors.warning);
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter username and password', AppColors.warning);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final repository = context.read<DieselRepository>();
      final apiService = context.read<ApiService>();

      await repository.saveIpAddress(ip);
      await repository.setRememberMe(_rememberMe);

      apiService.initialize(ip);

      final success = await repository.login(username, password);

      if (context.mounted) {
        Navigator.pop(context);

        if (success) {
          _showSnackBar('Connected successfully!', AppColors.success);
        } else {
          _showSnackBar('Login failed', AppColors.danger);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showSnackBar('Connection failed: $e', AppColors.danger);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
