# **Flutter 관광지 추천 프로젝트**

프로젝트 소개
- 관광지 추천 프로젝트로 관광지 api를 호출해서 구현한 관광지 추천 프로젝트입니다.
- 관광하고 싶은 지역을 클릭하면 지도와 마커가 나오고 마커 또는 지도의 아이콘을 클릭하면 관광지의 상세 정보를 알 수 있습니다.
- 검색 기능이 있어서 서울 이외에 원하는 지역을 검색해서 클릭 후 관광지 정보를 얻을 수 있습니다.

## 목차
- [개발 환경](#1-개발-환경)
- [프로젝트 구조](#2-프로젝트-구조)
- [개발 기간 및 작업 관리](#3-개발-기간-및-작업-관리)
- [페이지별 기능](#4-페이지별-기능)
- [구현하면서 경험한 이슈사항 및 신경 쓴 부분](#5-구현하면서-경험한-이슈사항-및-신경-쓴-부분)
- [후기](#6-후기)

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

 ## 3. 개발 기간 및 작업 관리
 ### 개발 기간
 - 2025.01.15 ~ 2025.01.15
 ### 작업 관리
 - github desktop 을 사용해서 관리

## 4. 실제 동작 영상
### 구 선택 및 관광지 정보 확인
- 모든 api 호출은 dio 라이브러리 사용했습니다.
- 스플레쉬 화면을 통해서 네이버 지도 업로드를 준비했습니다.
- 원하는 지역을 클릭하면 해당하는 지역의 관광지를 마커로 찍습니다.
  - flutter_naver_map 라이브러리를 사용해서 네이버 지도를 호출했습니다.
  - 지역 클릭시 provider 라이브러리를 사용해서 위경도, 관광지 이름을 전역으로 저장해서 네이버 지도로 이동 후 실시간으로 마커를 찍었습니다.
  - 관광지 api 를 사용해서 지역의 관광지 정보를 가져왔습니다.
  - 가져온 관광지 정보를 네이버 지오코딩 api를 사용해서 위경도 값으로 변경 후 네이버 지도에 마커를 찍었습니다.
- 마커, 지도에 떠 있는 아이콘을 클릭하면 카카오 장소 검색 api 를 사용해서 관광지 정보를 가져왔습니다.
  - 카카오 장소 검색 api 호출이 완료될 때 까지(상태코드 200) CircularProgressIndicator(빙글빙글 도는 위젯)을 띄우도록 구현했습니다.
  - webview_flutter 라이브러리를 사용해서 이미 만들어진 웹 사이트를 앱에서 띄움으로 개발 시간을 단축했습니다. 

![Image](https://github.com/user-attachments/assets/8816050b-f5b1-4240-b8a1-6ccd41c6fa50)

### 원하는 지역, 관광지 검색
- 화면 상단에 검색 아이콘을 클릭하면 검색 창이 뜨도록 했습니다.
  - 일치하는 검색 결과가 있을 때 만 검색창이 닫치도록 구현했습니다.
  - 일치하는 검색 결과가 없다면 "일치하느 검색 결과가 없습니다" 토스트바를 띄었습니다.
  - 검색창 외의 화면을 클릭하면 검색창이 사라지도록 구현했습니다.

![Image](https://github.com/user-attachments/assets/fb8117d3-5f7c-4041-8c3f-10b7b3dfcd4f)

## 5. 구현하면서 경험한 이슈사항 및 신경 쓴 부분
### 구현하면서 경험한 이슈사항
- 마커, 아이콘을 클릭하면 밑에서 위젯이 올라오고 밑으로 슬라이드 하면 위젯이 내려가도록 구현하고 싶었는데 이슈가 있어서 화면이동으로 대체했습니다.
  - 위젯을 슬라이드 해서 내려가도록 구현하면 화면 스크롤이 되지 않는 이슈가 발생했습니다.
  - 화면 스크롤이 가능하도록 하면 위젯을 슬라이드 해도 내려가지 않는 이슈가 발생했습니다.
- 네이버 지도 api를 사용해서 장소 검색 api도 네이버를 사용하려고 했지만 서비스 중단 이슈가 있었습니다.
  - 카카오 장소 검색 api가 있다는 것을 알고 검색 api는 카카오로 대체했습니다.
 
### 신경 쓴 부분
- 유지보수, 코드의 가독성
  - 많이 사용하는 위젯, 함수를 컴포넌트로 만들어서 필요할 때 마다 호출을 하도록 구현했습니다.
- 메모리 누수
  - 메모리 누수가 발생하지 않도록 dispose 메서드, mounted 속성을 적절히 사용했습니다.
- UI
  - 기기마다 크기가 다르기 때문에 px가 아닌 %로 위젯, 글자 크기를 주었습니다.
- UX
  - 직접 사용해봤을 때 불편한 부분이 있다면 사소한 부분도 수정했습니다.
    - 검색할 때 검색 창 밖을 클릭 시 검색창 사라지도록 구현했습니다.
    - 검색에 실패했을 때 왜 실패했는지 화면에 토스트바를 띄었습니다.
    - 마커를 클릭 시 어떤 마커를 클릭했는지 확인을 위해 마커 색상을 변경했습니다.

## 6. 후기
Flutter를 활용해서 오랜만에 만든 개인 프로젝트였는데 이전 프로젝트에 비해서 <br/>
코드의 가독성, 유지 보수가 높아진 것을 느꼈고 많은 api를 사용해서 프로젝트를 진행하다 보니 <br/>
공식 문서 검색, 원하는 기능을 구현하는 방법을 찾는 능력도 는 거 같아서 <br/>
뿌듯한 마음이 드는 프로젝트입니다!
