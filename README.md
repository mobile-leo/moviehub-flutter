# Movie Hub

Aplicativo Flutter que entrega uma experiencia estilo Netflix consumindo a [API publica do TMDB (The Movie Database)](https://www.themoviedb.org/documentation/api). O app cobre descoberta de filmes e series, paginas de detalhes completas, abertura de trailers, lista pessoal de favoritos, busca e recomendacoes inteligentes baseadas em genero — tudo em uma interface dark, limpa e inspirada nas grandes plataformas de streaming.

---

## Capturas de Tela

<p align="center">
  <img src="https://github.com/mobile-leo/movie-hub/blob/main/assets/screenshots/movie-hub-1.jpeg?raw=true" width="180"/>
  <img src="https://github.com/mobile-leo/movie-hub/blob/main/assets/screenshots/movie-hub-2.jpeg?raw=true" width="180"/>
  <img src="https://github.com/mobile-leo/movie-hub/blob/main/assets/screenshots/movie-hub-3.jpeg?raw=true" width="180"/>
</p>
<p align="center">
  <img src="https://github.com/mobile-leo/movie-hub/blob/main/assets/screenshots/movie-hub-4.jpeg?raw=true" width="180"/>
  <img src="https://github.com/mobile-leo/movie-hub/blob/main/assets/screenshots/movie-hub-5.jpeg?raw=true" width="180"/>
  <img src="https://github.com/mobile-leo/movie-hub/blob/main/assets/screenshots/movie-hub-6.jpeg?raw=true" width="180"/>
</p>

---

## Funcionalidades

- **Feed principal** com banner em tela cheia e auto-scroll ("Em Breve"), chips de filtro por genero, secoes "Em Alta Agora" e "Recomendados para Voce" que atualizam dinamicamente conforme o genero selecionado
- **Pagina de detalhes** de filmes e series com imagem hero em backdrop, duracao, avaliacao, sinopse com expandir/recolher, grade do elenco e botao de favorito com transicao animada
- **Abertura de trailer** que resolve a chave do trailer/teaser no YouTube via TMDB e abre nativamente no app do YouTube (com fallback para o navegador)
- **Busca** com queries em tempo real e debounce contra o endpoint de pesquisa do TMDB
- **Lista de favoritos (Minha Lista)** persistida em memoria via Provider, acessivel pela aba dedicada
- **Historico de navegacao** que rastreia os titulos visitados recentemente e os exibe como secao "Vistos Recentemente" na home
- **Cache HTTP em sessao** que deduplica chamadas identicas a API dentro da mesma sessao
- **Skeleton loaders** em cada secao assincrona, com estados de erro tratados de forma elegante

---

## Arquitetura

O projeto segue uma estrutura de pastas **feature-first** com separacao estrita entre camadas de UI, estado e dados. Nao existem god-classes nem logica de negocio dentro de widgets.

```
lib/
├── app/
│   └── router.dart                  # go_router com StatefulShellRoute
├── core/
│   ├── constants/
│   │   └── api_constants.dart       # Todos os caminhos de endpoints do TMDB
│   ├── models/
│   │   ├── movie.dart
│   │   ├── movie_detail.dart
│   │   ├── genre.dart
│   │   └── cast_member.dart
│   ├── providers/
│   │   ├── home_provider.dart       # Feed da home + filtro por genero + recomendacoes
│   │   ├── detail_provider.dart     # Pagina de detalhes + resolucao da chave do trailer
│   │   ├── search_provider.dart     # Busca com debounce
│   │   ├── favorites_provider.dart  # Estado da lista de favoritos
│   │   └── history_provider.dart   # Historico de navegacao (ultimos 20 titulos)
│   ├── services/
│   │   ├── http_client.dart         # Wrapper HTTP com cache em memoria
│   │   └── movie_service.dart       # Todos os metodos de busca de dados do TMDB
│   └── theme/
│       └── app_theme.dart           # Cores, estilos de texto e ThemeData
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── upcoming_banner.dart # PageView com auto-scroll via Timer
│   │       ├── genre_filter_row.dart
│   │       ├── trending_row.dart
│   │       ├── my_list_tab.dart
│   │       ├── home_header.dart
│   │       └── section_header.dart
│   ├── detail/
│   │   ├── detail_screen.dart
│   │   └── widgets/
│   │       ├── detail_backdrop.dart
│   │       ├── detail_info.dart
│   │       ├── cast_section.dart
│   │       └── trailer_player_sheet.dart
│   ├── search/
│   │   └── search_screen.dart
│   └── shell/
│       └── app_shell.dart           # Shell de navegacao inferior
├── shared/
│   └── widgets/
│       ├── pressable_card.dart      # Animacao de press reutilizavel (scale + fade)
│       ├── movie_poster.dart
│       ├── movie_backdrop.dart
│       ├── rating_badge.dart
│       └── genre_chip.dart
└── main.dart
```

---

## Tecnologias Utilizadas

| Camada | Tecnologia |
|---|---|
| Framework | Flutter 3 / Dart 3 |
| Gerenciamento de estado | Provider 6 (`ChangeNotifier`) |
| Navegacao | go_router 14 (`StatefulShellRoute`) |
| Requisicoes HTTP | `http` com camada de cache em memoria |
| Carregamento de imagens | `cached_network_image` |
| Fontes | Google Fonts via `google_fonts` |
| Skeleton loaders | `shimmer` |
| Links externos / trailer | `url_launcher` |
| Variaveis de ambiente | `flutter_dotenv` |
| Fonte de dados | TMDB REST API v3 |

---

## Como Rodar

### Pre-requisitos

- Flutter SDK `>=3.11.0`
- Uma chave gratuita da API do TMDB — [obtenha aqui](https://www.themoviedb.org/settings/api)

### Instalacao

```bash
# 1. Clone o repositorio
git clone https://github.com/mobile-leo/movie-hub.git
cd movie-hub

# 2. Crie o arquivo de variaveis de ambiente
echo "TMDB_API_KEY=sua_chave_aqui" > .env

# 3. Instale as dependencias
flutter pub get

# 4. Rode o app
flutter run
```

---

## Variaveis de Ambiente

Crie um arquivo `.env` na raiz do projeto (ja listado no `.gitignore`):

```env
TMDB_API_KEY=sua_chave_tmdb
```

A chave e carregada em tempo de execucao via `flutter_dotenv` e injetada no header de cada requisicao. Ela nunca e hardcoded nos arquivos de codigo-fonte.

---

## Integracao com a API

Toda a comunicacao com o TMDB e feita pelo `MovieService`, que delega as chamadas HTTP ao `ApiClient`. O cliente mantem um `Map<String, dynamic>` como cache em memoria, indexado pela URL — requisicoes identicas na mesma sessao utilizam o cache ao inves da rede.

Endpoints consumidos:

| Endpoint | Uso |
|---|---|
| `/movie/upcoming` | Banner "Em Breve" |
| `/trending/all/week` | Secao "Em Alta Agora" |
| `/discover/movie` e `/discover/tv` | Recomendacoes por genero |
| `/movie/{id}` e `/tv/{id}` | Pagina de detalhes |
| `/movie/{id}/videos` e `/tv/{id}/videos` | Resolucao da chave do trailer |
| `/movie/{id}/credits` e `/tv/{id}/credits` | Secao de elenco |
| `/genre/movie/list` e `/genre/tv/list` | Chips de filtro por genero |
| `/search/multi` | Tela de busca |

Todas as respostas sao parseadas em models Dart tipados com factories null-safe.

---

## Gerenciamento de Estado

O app usa `Provider` com `ChangeNotifier`. Cada tela possui seu proprio provider, com escopo limitado a sua dependencia:

- `HomeProvider` — orquestra todas as requisicoes do feed da home e expoe estados de loading/error por secao
- `DetailProvider` — carrega detalhes e chave do trailer em paralelo; os dois sao expostos de forma independente para que a UI renderize o conteudo antes do trailer ser resolvido
- `SearchProvider` — aplica debounce de 400ms na entrada do usuario antes de disparar a chamada a API
- `FavoritesProvider` — lista em memoria com lookup O(1) via `Set<int>` de IDs de filmes
- `HistoryProvider` — limitado a 20 entradas com deduplicacao estilo LRU

---

## Configuracao Android

O `AndroidManifest.xml` esta preparado para producao:

- `allowBackup="false"` — impede que preferencias sensiveis sejam incluidas nos backups do dispositivo
- `fullBackupContent="false"` com `dataExtractionRules` — bloqueia backup em nuvem e transferencia entre dispositivos (Android 12+)
- `networkSecurityConfig` — forcaa trafego exclusivamente via HTTPS; HTTP simples e bloqueado em nivel de sistema operacional
- `largeHeap="true"` — aloca heap extra para carregamento de imagens em alta resolucao
- `screenOrientation="portrait"` — trava a orientacao para evitar rebuilds desnecessarios de widgets
- Queries de intent declaradas para os esquemas `https` e `youtube` (obrigatorio no Android 11+)

---

## Licenca

Este projeto esta licenciado sob a Licenca MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

> Construido com Flutter. Dados fornecidos pelo [The Movie Database (TMDB)](https://www.themoviedb.org/). Este produto utiliza a API do TMDB, mas nao e endossado nem certificado pelo TMDB.
