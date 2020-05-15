# Cielo OAuth

iOS Library para auxiliar na obtenção do AccessToken para OAuth Cielo

## Requisitos

- Xcode 11+

## Instalação

### Cocoapods

Adicione ao arquivo podfile do seu projeto o seguinte código:

```swift
pod 'CieloOAuth'
```

### Instalação manual

Baixe o arquivo .zip, disponível em [releases](https://github.com/DeveloperCielo/cielo-ecommerce-oauth-ios/releases) (neste repositório), com a versão desejada, e siga o passo a passo abaixo:

1. Adicionar o sdk ao projeto, acessando as configurações do projeto na aba General, procurar a seção Frameworks, Libraries, and Embedded Content e clicar no botão +.
2. Selecione o arquivo CieloOAuth.framework e clique em Add.
3. Após adicionar o sdk ao projeto é necessário compilar o projeto através do menu *Product -> Build* ou pressionando *cmd + B*.
4. Assim que a build finalizar com sucesso, basta fazer o import do sdk nas classes desejadas.

## Modo de uso

### Configuração

Faça o `import` da biblioteca na classe em que será utilizada:

```swift
import CieloOAuth
```

Para iniciar o cliente do SDK será necessário informar o client id e o client secret:

```swift
var credentialClient = HttpCredentialsClient(clientId: clientId,
                                             clientSecret: clientSecret,
                                             environment: .sandbox)
```

### Utilização

```swift
credentialClient.getOAuthCredentials { [weak self] (accessToken, error) in
  ... 
}
```
