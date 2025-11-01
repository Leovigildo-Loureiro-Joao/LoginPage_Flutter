# 📱 SmartControl - App de Login em Flutter

<div align="center">

[https://img.shields.io/badge/Flutter-3.19-blue?style=for-the-badge&logo=flutter](https://img.shields.io/badge/Flutter-3.19-blue?style=for-the-badge&logo=flutter)  
[https://img.shields.io/badge/Dart-3.0-blue?style=for-the-badge&logo=dart](https://img.shields.io/badge/Dart-3.0-blue?style=for-the-badge&logo=dart)  
[https://img.shields.io/badge/License-MIT-green?style=for-the-badge](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Uma aplicação de login elegante e funcional construída com Flutter**

</div>

## 🚀 Sobre o Projeto

O **SmartControl** é uma aplicação de autenticação moderna que demonstra boas práticas de desenvolvimento Flutter, incluindo gestão de estado, validação de formulários e navegação entre telas.

### ✨ Funcionalidades Implementadas

- ✅ **Interface de login responsiva e moderna**
    
- ✅ **Validação de email e password**
    
- ✅ **Gestão de estado com setState**
    
- ✅ **Navegação entre telas**
    
- ✅ **Feedback visual (loading states)**
    
- ✅ **Design consistente com cores personalizadas**
    
- ✅ **AppBar customizado**
    

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.19** - Framework UI
    
- **Dart 3.0** - Linguagem de programação
    
- **Material Design** - Sistema de design
    
- **Widgets Nativos** - Gestão de estado com StatefulWidget
    

## 📁 Estrutura do Projeto

```text

lib/
├── main.dart                 # Ponto de entrada da aplicação
├── login_screen.dart         # Tela de login principal
└── home_screen.dart          # Tela após login bem-sucedido
```
## 🎯 Componentes Principais

### MyApp (StatelessWidget)

- Configuração do MaterialApp
    
- Definição do tema global
    
- Tela inicial: LoginScreen
    

### LoginScreen (StatefulWidget)

- Campos de email e password
    
- Validação em tempo real
    
- Botão de login com estados de loading
    
- Navegação para HomeScreen
    

### HomeScreen (StatelessWidget)

- Tela de boas-vindas após autenticação
    
- Layout simples e clean
    

## 💡 Lógica de Negócio Implementada

### Validações:

``` dart

// Email deve conter "@"
emailController.text.contains("@")

// Password deve ter pelo menos 6 caracteres  
passwordController.text.length >= 6
```
### Estados do Login:

```dart

setState(() => isLoading = true);  // Início do processo
// Validações e navegação...
setState(() => isLoading = false); // Fim do processo
```
## 🎨 Design System

### Cores Principais:

```dart

const primaryColor = Color(0xFF21BDE4);  // Azul principal
const seedColor = Color(0xFF3A70B7);     // Cor base do tema
```
### Características Visuais:

- **AppBar** centralizado com cor personalizada
    
- **Botões** com tamanho consistente (500x50)
    
- **Tipografia** responsiva e legível
    
- **Espaçamento** harmonioso entre elementos
    

## 🚀 Como Executar

1. **Clone o repositório**
    
```    bash
    
    git clone https://github.com/seu-usuario/smartcontrol.git
 ```   
2. **Acesse o diretório**
    
 ```   bash
    
    cd smartcontrol
    ```
3. **Instale as dependências**
    
   ``` bash
    
    flutter pub get
    ```
4. **Execute o projeto**
    
   ``` bash
    
    flutter run
   ``` 

## 📱 Capturas de Tela

|Tela de Login|Tela Principal|
|---|---|
|<img src="assets/login.png" width="300">|<img src="assets/home.png" width="300">|

## 🔮 Próximas Funcionalidades

- **Toggle para mostrar/esconder password**
    
- **ThemeData global personalizado**
    
- **Validação em tempo real nos campos**
    
- **Botão desabilitado quando formulário inválido**
    
- **Integração com Firebase Auth**
    
- **Modo escuro/claro**
    

## 👨‍💻 Desenvolvido por

**Leovigildo** - _Desenvolvedor Flutter_

- GitHub: [@seu-usuario](https://github.com/seu-usuario)
    
- LinkedIn: [Leovigildo](https://linkedin.com/in/leovigildo)
    

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](https://license/) para mais detalhes.

---

<div align="center">

### 💡 _"Código não é só instruções para máquinas, é poesia para resolver problemas"_

</div>