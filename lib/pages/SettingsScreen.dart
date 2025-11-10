import 'package:flutter/material.dart';
import 'package:loginpage/pages/homescreen.dart';
import 'package:loginpage/pages/loginscreen.dart';
import 'package:loginpage/services/appSettings.dart';
import 'package:loginpage/services/biometryService.dart';
import 'package:loginpage/ui/themes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.theme,
    required this.updateTheme,
  });

  final ThemeData theme;
  final VoidCallback updateTheme;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ✅ CONTROLE DO ESTADO DO SWITCH
  bool _biometriaAtiva = false;
  bool _isCheckingBiometrics = false;
  bool _biometricsAvailable = false;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    AppSettings.loadSettings().then((values) => {
      
        setState(() {
          if (values["darkMode"]!=null) {
            _isCheckingBiometrics = values["biometricEnabled"]!;
            _darkMode = values["darkMode"]!;
            _backupAutomatico = values["backup_auto"]!;
          }
          
        })
    },);

  }

  void _checkBiometricAvailability() async {

    setState(() => _isCheckingBiometrics = true);
    
    try {
      final hasBiometrics = await BiometricService.hasEnrolledBiometrics;
      setState(() {
        _biometricsAvailable = hasBiometrics;
        _isCheckingBiometrics = false;
      });
    } catch (e) {
      setState(() {
        _biometricsAvailable = false;
        _isCheckingBiometrics = false;
      });
    }
  }

  void _toggleBiometria(bool value) async {
    AppSettings.saveSettings(darkMode: _isDarkMode, biometricEnabled: _biometricsAvailable,backup_auto: _backupAutomatico);
    if (value) {
      try {
        final authenticated = await BiometricService.authenticate();
        if (authenticated) {
          setState(() => _biometriaAtiva = true);
          _showSuccessMessage('Biometria ativada com sucesso!');
        } else {
          _showErrorMessage('Falha na autenticação biométrica');
        }
      } catch (e) {
        _showErrorMessage('Erro ao ativar biometria');
      }
    } else {
      // ✅ DESATIVAR BIOMETRIA
      setState(() => _biometriaAtiva = false);
      _showSuccessMessage('Biometria desativada');
    }
  }

  bool _backupAutomatico = false;
  
  // ✅ VERIFICA SE O TEMA ATUAL É ESCURO
  bool get _isDarkMode {
    setState(() {
      _darkMode=!_darkMode;
    });
    return widget.theme.brightness == Theme.of(context).brightness;
  }

  void _alternarTema() {
    AppSettings.saveSettings(darkMode: _isDarkMode, biometricEnabled: _biometricsAvailable,backup_auto: _backupAutomatico);
    widget.updateTheme();
    setState(() {});
  }


  Widget _buildBiometricNotAvailable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Colors.orange[50],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Biometria não configurada no dispositivo',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        backgroundColor: widget.theme.appBarTheme.backgroundColor,
      ),
      body: ListView(
        children: [
          // ✅ SEÇÃO DE SEGURANÇA
          _buildSectionHeader('Segurança'),
          if (!_biometricsAvailable && !_isCheckingBiometrics)
            _buildBiometricNotAvailable(),
            
          SwitchListTile(
            title: Text('Biometria'),
            subtitle: _isCheckingBiometrics
                ? Text('Verificando disponibilidade...')
                : _biometricsAvailable
                    ? Text('Entrar com digital ou reconhecimento facial')
                    : Text('Biometria não disponível neste dispositivo'),
            value: _biometriaAtiva,
            onChanged: _biometricsAvailable && !_isCheckingBiometrics 
                ? _toggleBiometria 
                : null,
            activeColor: ColorsApp.primaryColor,
            secondary: _isCheckingBiometrics
                ? CircularProgressIndicator(strokeWidth: 2)
                : Icon(
                    Icons.fingerprint,
                    color: _biometriaAtiva && _biometricsAvailable
                        ? ColorsApp.primaryColor
                        : Colors.grey,
                  ),
          ),
          
          
          // ✅ SEÇÃO DE APARÊNCIA
          _buildSectionHeader('Aparência'),
          SwitchListTile(
            title: Text('Modo noturno'),
            subtitle: Text(_darkMode ? 'Tema escuro ativo' : 'Tema claro ativo'),
            value: _darkMode, // ✅ SINCRONIZADO COM O TEMA ATUAL
            onChanged: (value) {
              _alternarTema();
            },
            activeColor: ColorsApp.primaryColor,
            secondary: Icon(
              _darkMode ? Icons.dark_mode : Icons.light_mode,
              color: ColorsApp.primaryColor,
            ),
          ),
          
          // ✅ SEÇÃO DE CONTA
          _buildSectionHeader('Conta'),
          ListTile(
            leading: Icon(Icons.lock_reset, color: ColorsApp.primaryColor),
            title: Text('Alterar Senha Mestra'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showChangeMasterPasswordDialog();
            },
          ),
          
          // ✅ SEÇÃO DE DADOS
          _buildSectionHeader('Dados'),
          SwitchListTile(
            title: Text('Backup Automático'),
            subtitle: Text('Fazer backup das senhas automaticamente'),
            value: _backupAutomatico,
            onChanged: (value) {
              setState(() {
                _backupAutomatico = value;
                AppSettings.saveSettings(darkMode: _isDarkMode, biometricEnabled: _biometricsAvailable,backup_auto: _backupAutomatico);
              });
            },
            activeColor: ColorsApp.primaryColor,
          ),
          
          ListTile(
            leading: Icon(Icons.note_alt_sharp, color: ColorsApp.primaryColor),
            title: Text('Exportar Senhas'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _exportPasswords();
            },
          ),
          
          // ✅ SEÇÃO DE SOBRE
          _buildSectionHeader('Sobre'),
          ListTile(
            leading: Icon(Icons.info_outline, color: ColorsApp.primaryColor),
            title: Text('Sobre o App'),
            subtitle: Text('Versão 1.0.0'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showAboutDialog();
            },
          ),
          
          // ✅ SEÇÃO DE SESSÃO
          _buildSectionHeader('Sessão'),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: () {
              _showLogoutConfirmation();
            },
          ),
          
          SizedBox(height: 20),
          
          // ✅ BOTÃO DE LIMPAR DADOS (PERIGOSO)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              label: Text(
                'Limpar Todos os Dados',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _showClearDataConfirmation();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red.withOpacity(0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ WIDGET PARA HEADER DAS SEÇÕES
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorsApp.primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ✅ DIALOG PARA ALTERAR SENHA MESTRA
  void _showChangeMasterPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alterar Senha Mestra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha Atual',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nova Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar Nova Senha',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para alterar senha
              Navigator.pop(context);
              _showSuccessMessage('Senha alterada com sucesso!');
            },
            child: Text('Alterar'),
          ),
        ],
      ),
    );
  }

  // ✅ DIALOG DE SOBRE
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sobre o App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestor de Senhas Seguro',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Versão: 1.0.0'),
            Text('Desenvolvido com Flutter'),
            SizedBox(height: 12),
            Text(
              'Um aplicativo seguro para gerenciar todas as suas senhas em um único lugar.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  // ✅ CONFIRMAÇÃO PARA SAIR
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sair do App'),
        content: Text('Tem certeza que deseja sair? Você precisará fazer login novamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(
                    theme: widget.theme,
                    updateTheme: widget.updateTheme,
                  ),
                ),
              );
            },
            child: Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ CONFIRMAÇÃO PARA LIMPAR DADOS
  void _showClearDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Todos os Dados'),
        content: Text(
          '⚠️ ATENÇÃO: Esta ação não pode ser desfeita!\n\n'
          'Todas as suas senhas e configurações serão permanentemente excluídas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Lógica para limpar dados
              Navigator.pop(context);
              _showSuccessMessage('Dados limpos com sucesso!');
            },
            child: Text(
              'Limpar Tudo',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ MENSAGEM DE SUCESSO
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ✅ EXPORTAR SENHAS
  void _exportPasswords() {
    // Simular exportação
    _showSuccessMessage('Senhas exportadas com sucesso!');
  }
}