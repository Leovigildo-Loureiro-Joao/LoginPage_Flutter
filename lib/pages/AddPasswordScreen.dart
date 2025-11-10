import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loginpage/model/passordItem.dart';
import 'package:loginpage/repositories/PassordRepository.dart';
import 'package:loginpage/services/EncryptionService.dart';

class AddPasswordScreen extends StatefulWidget {
  final PasswordItem? password;
  final ThemeData theme;
  final VoidCallback updateTheme;

  const AddPasswordScreen({super.key, this.password,required this.theme,
    required this.updateTheme,});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _websiteController = TextEditingController();
  
  bool _obscurePassword = true;
  PasswordRepository _passwordRepo = PasswordRepository();
  PasswordItem? _passwordItem;

  // ✅ NOVOS ESTADOS PARA ÍCONE E CATEGORIA
  String _selectedIcon = 'lock';
  String _selectedCategory = 'Outros';
  
  // ✅ LISTAS DE OPÇÕES
  final List<Map<String, dynamic>> _icons = [
    {'name': 'lock', 'icon': Icons.lock, 'label': 'Geral'},
    {'name': 'email', 'icon': Icons.email, 'label': 'Email'},
    {'name': 'facebook', 'icon': Icons.facebook, 'label': 'Facebook'},
    {'name': 'account_balance', 'icon': Icons.account_balance, 'label': 'Banco'},
    {'name': 'wifi', 'icon': Icons.wifi, 'label': 'WiFi'},
    {'name': 'movie', 'icon': Icons.movie, 'label': 'Streaming'},
    {'name': 'shopping_cart', 'icon': Icons.shopping_cart, 'label': 'Compras'},
    {'name': 'work', 'icon': Icons.work, 'label': 'Trabalho'},
    {'name': 'school', 'icon': Icons.school, 'label': 'Educação'},
    {'name': 'health_and_safety', 'icon': Icons.health_and_safety, 'label': 'Saúde'},
  ];

  final List<String> _categories = [
    'Email',
    'Social',
    'Banco',
    'Trabalho',
    'Streaming',
    'Compras',
    'Educação',
    'Saúde',
    'Jogos',
    'Outros'
  ];

  @override
  void initState() {
    super.initState();
    _passwordRepo.init();
    
    // ✅ PREENCHE CAMPOS SE ESTIVER EDITANDO
    if (widget.password != null) {
      _titleController.text = widget.password!.title;
      _usernameController.text = widget.password!.username;
      _passwordController.text = widget.password!.encryptedPassword;
      _websiteController.text = widget.password!.website;
      _selectedIcon = widget.password!.iconName;
      _selectedCategory = widget.password!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.password == null ? 'Nova Senha' : 'Editar Senha'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePassword,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            SvgPicture.asset(
              "assets/create.svg",
              fit: BoxFit.cover,
              height: 150,
              width: 150,
            ),
            Text("Seja discreto com cada sua password"),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ✅ TÍTULO
                    TextFormField(
                      controller: _titleController,
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        border: UnderlineInputBorder(),
                        labelText: 'Título (ex: Gmail, Facebook)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite um título';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // ✅ USUÁRIO/EMAIL
                    TextFormField(
                      controller: _usernameController,
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        border: UnderlineInputBorder(),
                        labelText: 'Usuário/E-mail',
                      ),
                    ),
                    SizedBox(height: 16),

                    // ✅ SENHA
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        border: UnderlineInputBorder(),
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a senha';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // ✅ WEBSITE
                    TextFormField(
                      controller: _websiteController,
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        border: UnderlineInputBorder(),
                        labelText: 'Website (opcional)',
                      ),
                    ),
                    SizedBox(height: 20),

                    // ✅ SELECIONAR ÍCONE
                    _buildIconSelector(),
                    SizedBox(height: 16),

                    // ✅ SELECIONAR CATEGORIA
                    _buildCategorySelector(),
                    SizedBox(height: 20),

                    // ✅ INDICADOR DE FORÇA DA SENHA
                    if (_passwordController.text.isNotEmpty)
                      _buildPasswordStrength(),
                    SizedBox(height: 16),

                    // ✅ GERAR SENHA (apenas para nova senha)
                    if (widget.password == null) ...[
                      ElevatedButton.icon(
                        onPressed: _generatePassword,
                        icon: Icon(Icons.autorenew),
                        label: Text('Gerar Senha Forte'),
                      ),
                      SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ WIDGET PARA SELECIONAR ÍCONE
  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ícone',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _icons.length,
            itemBuilder: (context, index) {
              final icon = _icons[index];
              final isSelected = _selectedIcon == icon['name'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = icon['name'] as String;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Theme.of(context).primaryColor.withOpacity(0.2)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon['icon'] as IconData,
                        color: isSelected 
                            ? Theme.of(context).primaryColor
                            : Colors.grey[600],
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        icon['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected 
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ WIDGET PARA SELECIONAR CATEGORIA
  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoria',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          style: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          items: _categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
          },
        ),
      ],
    );
  }

  // ✅ INDICADOR DE FORÇA DA SENHA
  Widget _buildPasswordStrength() {
    final strength = PasswordItem.calculatePasswordStrength(_passwordController.text);
    final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green];
    final labels = ['Muito Fraca', 'Fraca', 'Média', 'Forte', 'Muito Forte'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Força da Senha: ${labels[strength - 1]}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors[strength - 1],
          ),
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: strength / 5,
          backgroundColor: Colors.grey[300],
          color: colors[strength - 1],
          minHeight: 6,
        ),
      ],
    );
  }

  // ✅ SALVAR SENHA
  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      final passwordItem = PasswordItem(
        id: widget.password?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        username: _usernameController.text,
        encryptedPassword: EncryptionService.encrypt(_passwordController.text), // Sem criptografia por enquanto
        website: _websiteController.text,
        iconName: _selectedIcon,
        strength: PasswordItem.calculatePasswordStrength(_passwordController.text),
        category: _selectedCategory,
      );
      if (widget.password==null) {
        _passwordRepo.addPassword(passwordItem);
      }else{
        _passwordRepo.updatePassword(passwordItem);
      }
      
      Navigator.pop(context, true);
    }
  }

  // ✅ GERAR SENHA FORTE
  void _generatePassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final random = Random();
    final password = String.fromCharCodes(
      Iterable.generate(12, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
    
    setState(() {
      _passwordController.text = password;
      _obscurePassword = false; // Mostra a senha gerada
    });
  }
}