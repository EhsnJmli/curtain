# Curtain
A flutter dynamic responsive dashboard, easy to use and completely customizable.

<img src="https://i.imgur.com/gPsrnso.gif" width="550" height="450">
<img src="https://i.imgur.com/BlTmCyF.gif" width="300" height="500">

| Data Type | Parameter | Details | Default value |
|:------------------------:|:---------------------:|:-----------------------------------------:|:--------------:|
| List | items | list of pages and sidebar actions. | `null` |
| CurtainSideBarConfig? | curtainSideBarConfig | Config of the sidebar. | `null` |
| int | initialPage | Initial Page. | `0` |
| bool | extendBody | Extends Page Body under edge of sidebar. | `false` |
| void Function(int page)? | onPageChange | Function which called when page changes. | `null` |
| ScaffoldConfig? | scaffoldConfig | Config of the main page scaffold. | `null` |
| TextDirection? | direction | Direction of the page. | `null` |
