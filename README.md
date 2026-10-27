## Introdução
Este projeto possui os códigos e assets utilizados no desenvolvimento do projeto de visita virtual da Secretaria de Ciências, Tecnologia e Inovação de Guarapuava.
As pastas do projeto estão listadas a seguir:
```
├── AssetsBlender/                <- Arquivos para Blender dos modelos em 3D criados para o projeto.
├── VersaoParaVR/                 <- Códigos, assets e texturas utilizados na versão para realidade virtual do projeto.
├── VersaoParaWeb/                <- Códigos, assets e texturas utilizados na versão para navegador do projeto.
└── README.md
```
Além disso, cada versão do projeto possui a seguinte organização:
```
├── assets/               
      ├── fontes/                 <- Armazena as fontes e suas respectivas licenças utilizadas no projeto.
      ├── materiais/              <- Armazena os materiais utilizados nos modelos 3D.
      ├── modelos3d/              <- Armazenas os modelos 3D utilizados no projeto, a salvo dos modelos .blend.
      └── texturas/               <- Armazena as texturas cc0 utilizadas no projeto.
├── cenas/                        <- Armazena as cenas do projeto, incluindo móveis, salas, ui, entre outros.
├── dialogos/                     <- Arquivos .json dos diálogos do projeto.
└── scripts/                      <- Scripts em .gd e .gdshader utilizados no projeto.
```
## Instalação do projeto:
  Para a instalação desse projeto, é necessário:
  - [Godot - Versão 4.6.stable.](https://godotengine.org/download/archive/4.6.3-stable/)
  - Arquivos .glb - [Armazenados em site externo](https://mega.nz/folder/dFBxSRLZ#ZTQL8AFMCbDHHwMraXbbjA).

### Versão Para Realidade Virtual
Para utilização da versão em realidade virtual, é necessário o download dos seguintes assets disponibilizados por Godot:
- [Godot XR Tools - Versão 4.5.0.](https://godotengine.org/asset-library/asset/1698)
- [Godot Open XR Vendors - Versão 2.0.3.](https://godotengine.org/asset-library/asset/2391)

Após a iniciação do projeto, além disso, é necessário baixar o modo de compilação para Android de Godot, por meio do menu de projeto do editor.
Além disso, os seguintes arquivos devem ser tornados globais:
- XRToolsUserSettings - ``res://addons/godot-xr-tools/user_settings/user_settings.gd``
- XRToolsRumbleManager - ``res://addons/godot-xr-tools/rumble/rumble_manager.gd``
Além disso, devido a limitação de tamanho de arquivos em github, certos arquivos .glb, mencionados na sessão de instalação do projeto, necessitam ser instalados e movidos para suas respectivas pastas:
```
├── modelo_3d_secretaria.glb          |
                                      |    -> devem ser movidos para a pasta ├── VersaoParaVR/assets/modelos3d/salas/modelo3d
├── modelo_3d_secretaria.glb.import   |
```
```
├── parede_primeiro_andar.glb         |
                                      |    -> devem ser movidos para a pasta ├── VersaoParaVR/assets/modelos3d/salas/parede_primeiro_andar
├── parede_primeiro_andar.glb.import  |
```
```
├── parede_segundo_andar.glb          |
                                      |    -> devem ser movidos para a pasta ├── VersaoParaVR/assets/modelos3d/salas/parede_segundo_andar
├── parede_segundo_andar.glb.import   |
```
