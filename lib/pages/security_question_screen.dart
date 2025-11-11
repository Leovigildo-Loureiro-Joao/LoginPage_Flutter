// Tela de recuperação de senha mestra
import 'package:flutter/material.dart';
import 'package:loginpage/services/secureStroregeService.dart';
import 'package:loginpage/ui/themes.dart';

class SecurityQuestionScreen extends StatefulWidget {
  const SecurityQuestionScreen({super.key});

  @override
  _SecurityQuestionScreenState createState() => _SecurityQuestionScreenState();
}

class _SecurityQuestionScreenState extends State<SecurityQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _savedQuestion;
  String _userAnswer = '';
  bool _isLoading = true;
  bool _showPassword = false;
  String? _masterPassword;

  @override
  void initState() {
    super.initState();
    _loadSecurityQuestion();
  }

  void _loadSecurityQuestion() async {
    final question = await SecureStorageService.getSecurityQuestion();
    setState(() {
      _savedQuestion = question;
      _isLoading = false;
    });
  }

  void _verifyAnswer() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      setState(() {
        _isLoading = true;
      });

      SecureStorageService.verifySecurityAnswer(_userAnswer).then((isCorrect) {
        setState(() {
          _isLoading = false;
        });

        if (isCorrect!) {
          // Se a resposta estiver correta, mostrar a senha mestra
          _showMasterPassword();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Resposta incorreta! Tente novamente.'),
              backgroundColor: Colors.red,
            )
          );
        }
      });
    }
  }

  void _showMasterPassword() async {
    final password = await SecureStorageService.getMasterPassword();
    setState(() {
      _masterPassword = password;
      _showPassword = true;
    });
  }

  void _resetForm() {
    setState(() {
      _userAnswer = '';
      _showPassword = false;
      _masterPassword = null;
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha Mestra'),
        actions: [
          if (_showPassword)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetForm,
              tooltip: 'Verificar novamente',
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _savedQuestion == null
              ? _buildNoQuestionConfigured()
              : Center(child: Container(
                  width: 500,
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_showPassword) ...[
                          // Tela de verificação
                          _buildVerificationUI()
                        ] else ...[
                          // Tela com senha revelada
                          _buildPasswordRevealedUI()
                        ]
                      ],
                    ),
                  ),
                )
                ),
    );
  }

  Widget _buildNoQuestionConfigured() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Pergunta de segurança não configurada',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Não foi encontrada nenhuma pergunta de segurança configurada. '
              'Você precisa configurar uma pergunta de segurança primeiro.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Voltar'),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Responda à sua pergunta de segurança:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        
        // Card com a pergunta
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sua pergunta:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _savedQuestion!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        
        // Campo de resposta
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Sua resposta',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.security),
          ),
          obscureText: true,
          onSaved: (value) => _userAnswer = value!.trim(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Digite sua resposta';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        Text(
          'Digite a resposta exatamente como configurou durante o cadastro.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 30),
        
        // Botão de verificação
        ElevatedButton(
          onPressed: _verifyAnswer,
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Verificar Resposta'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRevealedUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.verified_user, size: 64, color: Colors.green),
        SizedBox(height: 20),
        Text(
          'Resposta verificada com sucesso!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 20),
        
        // Card com a senha mestra
        Card(
          color: Colors.green[50],
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sua senha mestra é:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                     color: Theme.of(context).brightness==Themes.darkTheme.brightness ?const Color.fromARGB(255, 64, 158, 9) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: SelectableText(
                    _masterPassword ?? 'Não encontrada',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        
        // Avisos de segurança
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Importante:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '• Anote esta senha em um local seguro\n'
                '• Não compartilhe com ninguém\n'
                '• Esta senha é necessária para acessar suas outras senhas',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        
        // Botões de ação
        Row(
          children: [
          
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Concluir'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}