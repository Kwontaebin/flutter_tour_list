# **Flutter 관광지 추천 프로젝트**

프로젝트 소개
- 관광지 추천 프로젝트로 관광지 api를 호출해서 구현한 관광지 추천 프로젝트입니다.
- 관광하고 싶은 지역을 클릭하면 지도와 마커가 나오고 마커 또는 지도의 아이콘을 클릭하면 관광지의 상세 정보를 알 수 있습니다.
- 검색 기능이 있어서 서울 이외에 원하는 지역을 검색해서 클릭 후 관광지 정보를 얻을 수 있습니다.

## 목차
- [개발 환경](#1-개발-환경)
- [프로젝트 구조](#2-프로젝트-구조)
- [개발 기간](#3-개발-기간)
- [페이지별 기능](#4-페이지별-기능)
- [후기](#5-후기)

## 1. 개발 환경
- #### App Front-end : Dart, Flutter
- #### back-end : MySQL, Node-js
- #### 사용한 api : 네이버 지오 코딩 api, 관광지 api, 카카오 장소 검색 api, 네이버 지도 api
- #### 사용한 라이브러리 : provider(상태관리), dio(api 통신), webview_flutter(마커 또는 아이콘 클릭 시 관광지 정보 띄우기), flutter_naver_map(네이버 지도)

## 2. 프로젝트 구조
📦lib <br/> 
 ┣ 📂common <br/> 
 ┃ ┣ 📂component <br/> 
 ┃ ┃ ┣ 📜custom_appbar.dart <br/> 
 ┃ ┃ ┣ 📜custom_checkbox.dart <br/> 
 ┃ ┃ ┣ 📜custom_elevatedButton.dart <br/> 
 ┃ ┃ ┣ 📜custom_image.dart <br/> 
 ┃ ┃ ┣ 📜custom_loading.dart <br/> 
 ┃ ┃ ┣ 📜custom_show_hide_text.dart <br/> 
 ┃ ┃ ┣ 📜custom_showdiaLog.dart <br/> 
 ┃ ┃ ┣ 📜custom_text.dart <br/> 
 ┃ ┃ ┣ 📜custom_text_field.dart <br/> 
 ┃ ┃ ┣ 📜custom_toast.dart <br/> 
 ┃ ┃ ┗ 📜webview.dart <br/> 
 ┃ ┣ 📂const <br/> 
 ┃ ┃ ┗ 📜data.dart <br/> 
 ┃ ┗ 📂function <br/> 
 ┃ ┃ ┣ 📜navigator.dart <br/> 
 ┃ ┃ ┣ 📜postDio.dart <br/> 
 ┃ ┃ ┗ 📜sizeFn.dart <br/> 
 ┣ 📂mainScreen <br/> 
 ┃ ┣ 📂component <br/> 
 ┃ ┃ ┗ 📜showDialog.dart <br/> 
 ┃ ┗ 📂view <br/> 
 ┃ ┃ ┣ 📜locationInformation.dart <br/> 
 ┃ ┃ ┣ 📜mainScreen.dart <br/> 
 ┃ ┃ ┗ 📜subScreen.dart <br/> 
 ┣ 📂searchScreen <br/> 
 ┃ ┣ 📂component <br/> 
 ┃ ┃ ┗ 📜geoCoding.dart <br/> 
 ┃ ┗ 📂view <br/> 
 ┃ ┃ ┗ 📜search.dart <br/> 
 ┣ 📂splashScreen <br/> 
 ┃ ┗ 📂view <br/> 
 ┃ ┃ ┗ 📜splash.dart <br/> 
 ┗ 📜main.dart <br/> 
