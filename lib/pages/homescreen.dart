import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginpage/model/passordItem.dart';
import 'package:loginpage/pages/AddPasswordScreen.dart';
import 'package:loginpage/pages/SettingsScreen.dart';
import 'package:loginpage/pages/dashboardScreen.dart';
import 'package:loginpage/repositories/PassordRepository.dart';
import 'package:loginpage/services/EncryptionService.dart';
import 'package:loginpage/ui/themes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.theme,
    required this.updateTheme,
  });

  final ThemeData theme;
  final VoidCallback updateTheme;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  final PasswordRepository _passwordRepo = PasswordRepository();
  final TextEditingController _searchController = TextEditingController();
  late List<PasswordItem> _passwords = [];
  late List<PasswordItem>  _filteredPasswords = [];
  // ✅ CONTROLE DAS ABAS
  int _currentIndex = 0;

  void _loadPasswords() {
    setState(() {
      _passwords = _passwordRepo.getAllPasswords();
      _filteredPasswords = _passwords;
      print(_passwords.length);
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordRepo.init().then((value) {
      _loadPasswords();
    },);
   
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildPasswordListScreen();
      case 1:
        return DashboardScreen(
          passwords: _passwords, // ✅ SEMPRE com dados atualizados
          theme: widget.theme,
          updateTheme: widget.updateTheme,
        );
      case 2:
        return SettingsScreen(
          theme: widget.theme,
          updateTheme: widget.updateTheme,
        );
      default:
        return _buildPasswordListScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.scaffoldBackgroundColor,
     
      body: _buildCurrentScreen(),
      
      bottomNavigationBar: _buildBottomNavigationBar(),
      
      floatingActionButton: _currentIndex == 0 
          ? FloatingActionButton(
              onPressed: _addNewPassword,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: ColorsApp.primaryColor,
              elevation: 2,
            )
          : null,
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: widget.theme.cardTheme.color,
        selectedItemColor: ColorsApp.primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        
        // ✅ ITENS DO MENU
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_outline),
            activeIcon: Icon(Icons.lock),
            label: 'Senhas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }

  // ✅ TELA DE LISTA DE SENHAS (AGORA SEM APP BAR)
  Widget _buildPasswordListScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadPasswords();
        await Future.delayed(Duration(milliseconds: 500));
      },
      child: CustomScrollView(
          slivers: [
            // ✅ APP BAR PERSONALIZADA (OPCIONAL)
            SliverAppBar(
          backgroundColor: widget.theme.primaryColor,
          elevation: 0,
          floating: true,
          snap: true,
          title: Text(
            'Minhas Senhas',
            style: widget.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _showSearch,
              color: widget.theme.iconTheme.color,
            ),
            // No SliverAppBar actions, adiciona:

          ],
        ),
        
        // ✅ BARRA DE PESQUISA
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.theme.cardTheme.color,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar senhas...',
                  hintStyle: Themes.placeholder,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onChanged: (value) {
                  // Filtrar lista
                },
              ),
            ),
          ),
        ),
        
        // ✅ CONTADOR
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_passwords.length} senhas salvas',
                  style: TextStyle(
                    color: widget.theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, size: 14, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'Seguro',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // ✅ LISTA DE SENHAS
        _passwords.isEmpty
            ? SliverFillRemaining(
                child: _buildEmptyState(),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPasswordItem(_passwords[index]),
                  childCount: _passwords.length,
                ),
              ),
            ],
          )
      );
  }

  // ✅ MÉTODOS EXISTENTES (com pequenos ajustes)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'Nenhuma senha salva',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Toque no + para adicionar sua primeira senha',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordItem(PasswordItem item) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ColorsApp.primaryColor.withOpacity(0.1),
          child: Icon(item.icon, color: ColorsApp.primaryColor),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.strengthColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.username),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: item.strength / 5,
                    backgroundColor: Colors.grey[300],
                    color: item.strengthColor,
                    minHeight: 4,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  item.strengthLabel,
                  style: TextStyle(
                    fontSize: 10,
                    color: item.strengthColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        // ✅ BOTÕES DE AÇÃO NO TRAILING
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black87),
              onPressed: () => _editPassword(item),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.grey),
              onPressed: () => _deletePassword(item),
            ),
          ],
        ),
        onTap: () => _showPassword(item),
      ),
    ),
  );
}

// ✅ MANIPULA AS AÇÕES DO MENU
void _handleMenuAction(String action, PasswordItem item) {
  switch (action) {
    case 'edit':
      _editPassword(item);
      break;
    case 'delete':
      _deletePassword(item);
      break;
  }
}

// ✅ COPIAR SENHA
void _copyPassword(PasswordItem item) {
  final password = EncryptionService.decrypt(item.encryptedPassword);
  
  Clipboard.setData(ClipboardData(text: password));
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Senha de ${item.title} copiada!'),
      duration: Duration(seconds: 2),
    ),
  );
}

  void _showSearch() {
    showSearch(
      context: context,
      delegate: PasswordSearchDelegate(passwords: _passwords),
    );
  }

  // ✅ MANTENHA OS OUTROS MÉTODOS EXISTENTES
  void _addNewPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPasswordScreen(theme: widget.theme,updateTheme: widget.updateTheme,),
      ),
    ).then((value) {
      if (value != null) {
        _loadPasswords();
      }
    });
  }

  void _showPassword(PasswordItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuário: ${item.username}'),
            Text('Senha: ${item.encryptedPassword}'),
            SizedBox(height: 10),
            Text(
              'Website: ${item.website}',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
             _copyPassword(item);
            },
          ),
        ],
      ),
    );
  }

  void _editPassword(PasswordItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPasswordScreen(password: item,updateTheme: widget.updateTheme,theme: widget.theme,),
      ),
    ).then((value) {
      if (value != null) {
        _loadPasswords();
      }
    });
  }

  void _showOptions(PasswordItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Editar'),
            onTap: () {
              Navigator.pop(context);
              _editPassword(item);
            },
          ),
          ListTile(
            leading: Icon(Icons.copy),
            title: Text('Copiar senha'),
            onTap: () {
              Navigator.pop(context);
              // Copiar senha
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Excluir', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _deletePassword(item);
            },
          ),
        ],
      ),
    );
  }

  void _deletePassword(PasswordItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir senha?'),
        content: Text('Tem certeza que deseja excluir a senha de ${item.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _passwords.remove(item);
                _passwordRepo.deletePassword(item.id);
              });
              Navigator.pop(context);
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ✅ DELEGATE PARA BUSCA (OPCIONAL)
class PasswordSearchDelegate extends SearchDelegate {
  final List<PasswordItem> passwords;

  PasswordSearchDelegate({required this.passwords});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = passwords.where((password) =>
        password.title.toLowerCase().contains(query.toLowerCase()) ||
        password.username.toLowerCase().contains(query.toLowerCase()));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results.elementAt(index);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: ColorsApp.primaryColor.withOpacity(0.1),
            child: Icon(item.icon, color: ColorsApp.primaryColor),
          ),
          title: Text(item.title),
          subtitle: Text(item.username),
          onTap: () {
            // Navegar para detalhes
          },
        );
      },
    );
  }
}