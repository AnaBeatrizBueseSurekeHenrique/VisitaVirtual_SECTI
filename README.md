## Introdução
Este projeto possui os códigos e assets utilizados no desenvolvimento do projeto de visita virtual da Secretaria de Ciências, Tecnologia e Inovação de Guarapuava.
As pastas do projeto estão listadas a seguir:
```
├── AssetsBlender/                <- Arquivos para Blender dos modelos em 3D criados para o projeto.
├── VersaoParaVR/                 <- Códigos, assets e texturas utilizados na versão para realidade virtual do projeto.
├── VersaoParaWeb/                <- Códigos, assets e texturas utilizados na versão para navegador do projeto.
└── README.md
```
Além disso, ambas as pastas ``VersaoParaVR`` e ``VersaoParaWeb`` possuem a seguinte organização:
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
  - [Godot - Versão 4.6.](https://godotengine.org/download/archive/4.6.3-stable/)
    
Ao ser finalizada a instalação, os seguintes passos devem ser seguidos para se utilizar dos projetos deste repositório:
- Em primeiro lugar, se é selecionado a opção de *Importar* de Godot:

![Importar](https://file.garden/XufHAN0HKkSMo1Zp/1.png)

Após isto, se é selecionado o *project.godot* do projeto. A versão para realidade virtual, e a versão para navegador possuem *project.godot*s diferentes, resultando em projetos diferentes na _game engine_.

![Projeto](https://file.garden/XufHAN0HKkSMo1Zp/2.png)

### Versão Para Realidade Virtual
Para utilização da versão em realidade virtual, é necessário o download dos seguintes assets:
- Arquivos .glb - [Armazenados em site externo](https://mega.nz/folder/dFBxSRLZ#ZTQL8AFMCbDHHwMraXbbjA).
- [Godot XR Tools - Versão 4.5.0.](https://godotengine.org/asset-library/asset/1698)
- [Godot Open XR Vendors - Versão 2.0.3.](https://godotengine.org/asset-library/asset/2391)

  
Após a iniciação do projeto, além disso, é necessário baixar o modo de compilação para Android de Godot, por meio do menu de projeto do editor.<br/>
![Modo de Compilação para Android](https://file.garden/XufHAN0HKkSMo1Zp/Captura%20de%20tela%202026-10-27%20151958.png)


Além disso, os seguintes arquivos devem ser tornados globais:
- XRToolsUserSettings - ``res://addons/godot-xr-tools/user_settings/user_settings.gd``
- XRToolsRumbleManager - ``res://addons/godot-xr-tools/rumble/rumble_manager.gd``

Em relação aos arquivos .glb requisitados, eles precisam ser baixados e movidos para suas respectivas pastas.
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
## Exportação
Para realização da exportação, e obtenção dos arquivos .html e .apk de cada versão, é necessário utilizar tela de exportação de godot, utilizando da versão Web para o projeto contido na VersãoParaWeb, e a primeira versão para Android contida no projeto VersaoParaVR, sendo selecionado a opção Exportar Projeto.
![Exportação do projeto](https://file.garden/XufHAN0HKkSMo1Zp/Captura%20de%20tela%202026-10-27%20152509.png)
