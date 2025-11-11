import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loginpage/main.dart';
import 'package:loginpage/pages/login_screen.dart';
import 'package:loginpage/services/biometryService.dart';
import 'package:loginpage/services/secureStroregeService.dart';
import 'package:loginpage/widget/TypeWritterEraser.dart';
import '../ui/themes.dart';
import '../widget/textField.dart';
import 'home_screen.dart';

class SingScreen extends StatefulWidget {
  final bool? isFisrtTime;
  const SingScreen({super.key, required this.theme, required this.updateTheme, this.isFisrtTime});

  final ThemeData theme;
  final VoidCallback updateTheme;

  @override
  State<SingScreen> createState() => _MySingScreen();
}

class _MySingScreen extends State<SingScreen> {
  // ISSO É LÓGICA PURA! 👇
  TextEditingController _cpasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _apasswordController = TextEditingController();
  TextEditingController _securityQuestionController = TextEditingController();
  TextEditingController _securityAnswerController = TextEditingController();
  
  WidgetStatesController button = WidgetStatesController();
  bool isLoading = false;
  List erro = [false, false, false, false, false];
  bool _obscurePassword = true;
  bool _obscureCPassword = true;
  bool _obscureAPassword = true;

  String? _selectedQuestion;
  final List<String> _securityQuestions = [
    'Qual o nome do seu primeiro animal de estimação?',
    'Qual o nome da sua cidade natal?',
    'Qual o nome do seu melhor amigo de infância?',
    'Qual o nome do seu professor favorito?',
    'Qual o seu prato favorito?',
    'Qual era o nome da sua primeira escola?',
    'Qual é o nome do seu filme favorito?',
  ];

  IconData get iconeTema {
    return Theme.of(context).brightness == Themes.lightTheme.brightness 
        ? Icons.dark_mode 
        : Icons.light_mode;
  }

  bool _isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  void fakeLogin() async {
    setState(() => isLoading = true);
    
    // Validações
    erro[0] = !_isStrongPassword(_passwordController.text);
    erro[1] = _passwordController.text != _cpasswordController.text;
    erro[2] = _selectedQuestion == null;
    erro[3] = _securityAnswerController.text.isEmpty;
    
    if (!erro[0] && !erro[1] && !erro[2] && !erro[3]) {
      await Future.delayed(Duration(seconds: 2));
      
      // Salvar senha mestra e pergunta de segurança
      await SecureStorageService.saveMasterPassword(_passwordController.text);
      await SecureStorageService.setSecurityQuestion(
        _selectedQuestion!, 
        _securityAnswerController.text
      );
      await SecureStorageService.setFirstTimeCompleted();
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            theme: Theme.of(context),
            updateTheme: widget.updateTheme,
          ),
        ),
      );
    }
    setState(() => isLoading = false);
  }

  void fakeEdit() async {
    setState(() => isLoading = true);
    
    SecureStorageService.getMasterPassword().then((value) {
      erro[0] = _passwordController.text != value;
      erro[1] = !_isStrongPassword(_apasswordController.text);
      erro[2] = _apasswordController.text != _cpasswordController.text;
      
      if (!erro[0] && !erro[1] && !erro[2]) {
        SecureStorageService.saveMasterPassword(_apasswordController.text);
        SecureStorageService.setFirstTimeCompleted();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              theme: Theme.of(context),
              updateTheme: widget.updateTheme,
            ),
          ),
        );
      }
      setState(() => isLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    
    // Carregar pergunta de segurança existente se estiver editando
    if (widget.isFisrtTime == false) {
      _loadExistingSecurityQuestion();
    }
  }

  void _loadExistingSecurityQuestion() async {
    final question = await SecureStorageService.getSecurityQuestion();
    if (question != null && mounted) {
      setState(() {
        _selectedQuestion = question;
        _securityQuestionController.text = question;
      });
    }
  }

  Widget _buildPasswordStrengthIndicator(int strength) {
    final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green];
    final labels = ['Muito Fraca', 'Fraca', 'Média', 'Forte', 'Muito Forte'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [(strength - 1) < 0 ?
      SizedBox()
      :Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength / 5,
                backgroundColor: Colors.grey[300],
                color: colors[strength - 1],
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: 12),
            Text(
              labels[strength - 1],
              style: TextStyle(
                fontSize: 12,
                color: colors[strength - 1],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;
    
    final requirements = [
      {'text': 'Mínimo 8 caracteres', 'met': password.length >= 8},
      {'text': 'Pelo menos 1 letra maiúscula', 'met': password.contains(RegExp(r'[A-Z]'))},
      {'text': 'Pelo menos 1 letra minúscula', 'met': password.contains(RegExp(r'[a-z]'))},
      {'text': 'Pelo menos 1 número', 'met': password.contains(RegExp(r'[0-9]'))},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements.map((req) => Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(
              req['met'] as bool ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16,
              color: req['met'] as bool ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              req['text'] as String,
              style: TextStyle(
                fontSize: 12,
                color: req['met'] as bool ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  int _getPasswordStrength(String password) {
    int score = 0;
    if (password.isNotEmpty && password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    return score;
  }

  Widget _buildSecurityQuestionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Pergunta de Segurança",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
        onTap: _showQuestionSelectionDialog,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _selectedQuestion ?? 'Selecione uma pergunta de segurança',
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedQuestion == null ? Colors.grey : null,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
      if (erro[2]) 
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'Selecione uma pergunta',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: _securityAnswerController,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Resposta para a pergunta de segurança',
            errorText: erro[3] ? 'Digite a resposta' : null,
          ),
          onChanged: (value) {
            setState(() {
              erro[3] = false;
            });
          },
        ),
        SizedBox(height: 10),
        Text(
          'Esta pergunta será usada para recuperar sua senha mestra caso a esqueça.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }


void _showQuestionSelectionDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Selecione uma pergunta'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _securityQuestions.length,
          itemBuilder: (context, index) {
            final question = _securityQuestions[index];
            return ListTile(
              title: Text(
                question,
                softWrap: true,
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                setState(() {
                  _selectedQuestion = question;
                  erro[2] = false;
                });
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final passwordStrength = _getPasswordStrength(_passwordController.text);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isFisrtTime != false ? "Criar Conta Segura" : "Alterar Senha Mestra",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.all(10),
          width: 500,
          margin: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                TypewriterWithCursor(
                  text: widget.isFisrtTime == true 
                    ? "Proteja suas senhas com uma conta segura."
                    : "Altere sua senha mestra com segurança.",
                  duration: Duration(milliseconds: 1000),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  cursorColor: ColorsApp.primaryColor,
                ),
                
                if (widget.isFisrtTime == true || (_apasswordController.text.isNotEmpty && !widget.isFisrtTime!)) ...[
                  SizedBox(height: 8),
                  _buildPasswordStrengthIndicator(passwordStrength),
                  SizedBox(height: 8),
                  _buildPasswordRequirements(),
                ],
                
                SizedBox(height: 30),
                Column(
                  children: [
                    inputUnderline(
                      icone: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      obscure: _obscurePassword,
                      text: widget.isFisrtTime == true 
                        ? "Crie sua senha mestra" 
                        : "Digite sua senha atual",
                      error: erro[0],
                      controller: _passwordController,
                      context: context,
                    ),
                    
                    if (widget.isFisrtTime == false) ...[
                      SizedBox(height: 20),
                      inputUnderline(
                        icone: IconButton(
                          icon: Icon(
                            _obscureAPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureAPassword = !_obscureAPassword;
                            });
                          },
                        ),
                        obscure: _obscureAPassword,
                        text: "Nova senha mestra",
                        error: erro[1],
                        controller: _apasswordController,
                        context: context,
                      )
                    ],
                    
                    SizedBox(height: 20),
                    inputUnderline(
                      icone: IconButton(
                        icon: Icon(
                          _obscureCPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCPassword = !_obscureCPassword;
                          });
                        },
                      ),
                      obscure: _obscureCPassword,
                      text: "Confirme a senha",
                      error: erro[1],
                      controller: _cpasswordController,
                      context: context,
                    ),
                    
                    // Mostrar seção de pergunta de segurança apenas na criação da conta
                    if (widget.isFisrtTime == true) 
                      _buildSecurityQuestionSection(),
                    
                    SizedBox(height: 30),
                    isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: widget.isFisrtTime == true ? fakeLogin : fakeEdit,
                          child: Text(
                            widget.isFisrtTime == true ? "Criar Conta" : "Alterar Senha",
                          ),
                        )
                  ],
                ),
                
                if (widget.isFisrtTime == true) ...[
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(
                            theme: widget.theme,
                            updateTheme: widget.updateTheme,
                            cadastrado: widget.isFisrtTime,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Já tenho uma conta?",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}