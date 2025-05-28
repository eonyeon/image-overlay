// 🌐 다국어 지원 시스템
// Language Support System for Image Overlay Tool

export const languages = {
  // 한국어 (기본)
  ko: {
    name: '한국어',
    code: 'ko',
    
    // 로그인 화면
    login: {
      title: 'Image overlay tool',
      developer: 'Developed by Eric (eon232@gmail.com)',
      passwordLabel: '대여용 비밀번호 입력:',
      passwordPlaceholder: '이번 달 비밀번호를 입력하세요',
      loginButton: '로그인',
      passwordInfo: {
        warning: '⚠️ 이 프로그램은 매달 비밀번호 인증이 필요합니다',
        renewal: '비밀번호는 매달 1일에 자동으로 갱신됩니다'
      }
    },
    
    // 메인 화면
    main: {
      title: 'Image overlay tool',
      subtitle: 'Add text overlays to your images - 한글 완벽 지원',
      userInfo: '현재 사용자: 인증됨 ✓',
      logoutButton: '로그아웃',
      inputFolder: '입력 폴더 선택',
      outputFolder: '출력 폴더 선택',
      selectFolder: '폴더 선택',
      noFolderSelected: '선택된 폴더 없음',
      batchMode: '전체 이미지 일괄 적용',
      individualMode: '개별 이미지 텍스트 지정',
      startButton: '시작하기'
    },
    
    // 일괄 처리 모달
    batch: {
      title: '전체 이미지 일괄 적용',
      autoText: '텍스트 자동 입력',
      customText: '텍스트 지정',
      textInput: '텍스트 입력',
      textPlaceholder: '오버레이할 텍스트를 입력하세요',
      fontSize: '텍스트 크기',
      positionRight: '텍스트 위치 - 우측에서',
      positionBottom: '텍스트 위치 - 하단에서',
      preview: '미리보기',
      cancel: '취소',
      save: '저장'
    },
    
    // 개별 처리 모달
    individual: {
      title: '개별 이미지 텍스트 지정',
      fontSize: '텍스트 크기',
      positionRight: '텍스트 위치 - 우측에서',
      positionBottom: '텍스트 위치 - 하단에서',
      preview: '미리보기',
      selectAll: '전체 선택',
      selectedCount: '선택됨',
      checkboxHelp: '✅ 체크된 이미지만 처리됩니다',
      textPlaceholder: '이 이미지에 추가할 텍스트를 입력하세요',
      skip: '건너뛰기 (선택 안됨)',
      cancel: '취소',
      save: '저장'
    },
    
    // 로그 모달
    log: {
      title: '처리 결과',
      confirm: '확인'
    },
    
    // 알림 메시지
    notifications: {
      loginRequired: '로그인이 필요합니다.',
      selectFolders: '입력 폴더와 출력 폴더를 선택해주세요.',
      noImages: '처리할 이미지가 없습니다.',
      inputFolderSelected: '입력 폴더가 선택되었습니다.',
      outputFolderSelected: '출력 폴더가 선택되었습니다.',
      loginSuccess: '로그인 성공! 이번 달 동안 재로그인이 필요하지 않습니다.',
      wrongPassword: '잘못된 비밀번호입니다. 비밀번호는 매달 갱신됩니다.',
      programInitialized: '프로그램이 초기화되었습니다.',
      imagesLoaded: '개의 이미지가 로드되었습니다.',
      processingStart: '이미지 처리를 시작합니다...',
      selectedImagesStart: '선택된 {count}개 이미지 처리를 시작합니다...',
      noSelectedImages: '선택된 이미지가 없습니다.',
      allCompleted: '모든 이미지 처리가 완료되었습니다!',
      processed: '처리',
      skipped: '건너뛰기',
      completed: '이미지 처리 완료',
      previewFor: '의 미리보기를 표시합니다',
      folderSelectionError: '폴더 선택 중 오류가 발생했습니다.',
      imageLoadError: '이미지 로드 중 오류가 발생했습니다.',
      alreadyAuthenticated: '이번 달 이미 인증됨 - 자동 로그인',
      newMonthLogin: '새로운 달 또는 처음 실행 - 로그인 필요',
      enterPassword: '비밀번호를 입력해주세요.',
      languageChanged: '언어가 변경되었습니다.',
      processingCompleted: '처리가 완료되었습니다!',
      noProcessedImages: '처리된 이미지가 없습니다.',
      partialCompletion: '개 이미지 처리 완료',
      thumbnailLoading: '썸네일 로딩 시작...',
      thumbnailComplete: '모든 썸네일 로딩 완료'
    },
    
    // 처리 결과
    processing: {
      success: '처리 완료',
      error: '처리 실패',
      skip: '건너뛰기'
    }
  },
  
  // English
  en: {
    name: 'English',
    code: 'en',
    
    // Login screen
    login: {
      title: 'Image overlay tool',
      developer: 'Developed by Eric (eon232@gmail.com)',
      passwordLabel: 'Enter rental password:',
      passwordPlaceholder: 'Enter this month\'s password',
      loginButton: 'Login',
      passwordInfo: {
        warning: '⚠️ This program requires monthly password authentication',
        renewal: 'Password is automatically renewed on the 1st of each month'
      }
    },
    
    // Main screen
    main: {
      title: 'Image overlay tool',
      subtitle: 'Add text overlays to your images - Perfect Korean support',
      userInfo: 'Current user: Authenticated ✓',
      logoutButton: 'Logout',
      inputFolder: 'Select input folder',
      outputFolder: 'Select output folder',
      selectFolder: 'Select folder',
      noFolderSelected: 'No folder selected',
      batchMode: 'Batch apply to all images',
      individualMode: 'Individual image text setting',
      startButton: 'Start'
    },
    
    // Batch processing modal
    batch: {
      title: 'Batch apply to all images',
      autoText: 'Auto text input',
      customText: 'Custom text',
      textInput: 'Text input',
      textPlaceholder: 'Enter text to overlay',
      fontSize: 'Font size',
      positionRight: 'Text position - from right',
      positionBottom: 'Text position - from bottom',
      preview: 'Preview',
      cancel: 'Cancel',
      save: 'Save'
    },
    
    // Individual processing modal
    individual: {
      title: 'Individual image text setting',
      fontSize: 'Font size',
      positionRight: 'Text position - from right',
      positionBottom: 'Text position - from bottom',
      preview: 'Preview',
      selectAll: 'Select all',
      selectedCount: 'Selected',
      checkboxHelp: '✅ Only checked images will be processed',
      textPlaceholder: 'Enter text to add to this image',
      skip: 'Skip (not selected)',
      cancel: 'Cancel',
      save: 'Save'
    },
    
    // Log modal
    log: {
      title: 'Processing results',
      confirm: 'OK'
    },
    
    // Notification messages
    notifications: {
      loginRequired: 'Login required.',
      selectFolders: 'Please select input and output folders.',
      noImages: 'No images to process.',
      inputFolderSelected: 'Input folder selected.',
      outputFolderSelected: 'Output folder selected.',
      loginSuccess: 'Login successful! No re-login required for this month.',
      wrongPassword: 'Invalid password. Password is renewed monthly.',
      programInitialized: 'Program initialized.',
      imagesLoaded: ' images loaded.',
      processingStart: 'Starting image processing...',
      selectedImagesStart: 'Starting processing {count} selected images...',
      noSelectedImages: 'No images selected.',
      allCompleted: 'All image processing completed!',
      processed: 'processed',
      skipped: 'skipped',
      completed: ' image processing completed',
      previewFor: 'Displaying preview for ',
      folderSelectionError: 'Error occurred while selecting folder.',
      imageLoadError: 'Error occurred while loading images.',
      alreadyAuthenticated: 'Already authenticated this month - auto login',
      newMonthLogin: 'New month or first run - login required',
      enterPassword: 'Please enter password.',
      languageChanged: 'Language changed.',
      processingCompleted: 'Processing completed!',
      noProcessedImages: 'No images processed.',
      partialCompletion: ' image processing completed',
      thumbnailLoading: 'Starting thumbnail loading...',
      thumbnailComplete: 'All thumbnails loaded'
    },
    
    // Processing results
    processing: {
      success: 'Success',
      error: 'Failed',
      skip: 'Skip'
    }
  }
};

// 언어 관리 클래스
export class LanguageManager {
  constructor() {
    this.currentLanguage = 'ko'; // 기본 언어
    this.texts = languages[this.currentLanguage];
    this.loadSavedLanguage();
  }
  
  // 저장된 언어 설정 로드
  loadSavedLanguage() {
    try {
      const savedLang = localStorage.getItem('imageOverlayLanguage');
      if (savedLang && languages[savedLang]) {
        this.setLanguage(savedLang);
      }
    } catch (error) {
      console.warn('언어 설정 로드 실패:', error);
    }
  }
  
  // 언어 설정
  setLanguage(langCode) {
    if (languages[langCode]) {
      this.currentLanguage = langCode;
      this.texts = languages[langCode];
      
      // 언어 설정 저장
      try {
        localStorage.setItem('imageOverlayLanguage', langCode);
      } catch (error) {
        console.warn('언어 설정 저장 실패:', error);
      }
      
      return true;
    }
    return false;
  }
  
  // 현재 언어 가져오기
  getCurrentLanguage() {
    return this.currentLanguage;
  }
  
  // 텍스트 가져오기 (중첩 객체 지원)
  getText(path) {
    const keys = path.split('.');
    let text = this.texts;
    
    for (const key of keys) {
      if (text && typeof text === 'object' && text[key] !== undefined) {
        text = text[key];
      } else {
        console.warn(`번역 텍스트를 찾을 수 없습니다: ${path} (언어: ${this.currentLanguage})`);
        return path; // 키를 그대로 반환
      }
    }
    
    return text;
  }
  
  // 템플릿 텍스트 (변수 치환)
  getFormattedText(path, variables = {}) {
    let text = this.getText(path);
    
    // {변수명} 형태의 플레이스홀더 치환
    Object.keys(variables).forEach(key => {
      const placeholder = `{${key}}`;
      text = text.replace(new RegExp(placeholder, 'g'), variables[key]);
    });
    
    return text;
  }
  
  // 사용 가능한 언어 목록
  getAvailableLanguages() {
    return Object.keys(languages).map(code => ({
      code,
      name: languages[code].name
    }));
  }
}

// 전역 인스턴스 생성
export const i18n = new LanguageManager();
