let context;
const tempo = 80;
const yubiuchi = 0.05; // 指打ちの時間(秒)
const volume = 0.2;

const notes = {
  "O3b-": 939 / 4, // 一
  "O3b":  990 / 4, // 二x
  "O4c":  528 / 2, // 二
  "O4d-": 560 / 2, // 三x
  "O4d":  594 / 2, // 三
  "O4e-": 627 / 2, // 四
  "O4e":  660 / 2, // 五x
  "O4f":  704 / 2, // 五
  "O4g-": 746 / 2, // 六x
  "O4g":  792 / 2, // 六
  "O4a-": 836 / 2, // 七x
  "O4a":  888 / 2, // 七
  "O4b-": 939 / 2, // １
  "O4b":  990 / 2, // ２x
  "O5c":  528,     // ２
  "O5d-": 560,     // ３x
  "O5d":  594,     // ３
  "O5e-": 627,     // ４
  "O5e":  660,     // ５x
  "O5f":  704,     // ５
  "O5g-": 746,     // ６x
  "O5g":  792,     // ６
  "O5a-": 836,     // ７x
  "O5a":  888,     // ７
  "O5b-": 939,     // ８x(未使用)
  "O5b":  997,     // ８(大甲)
  "O6c":  528 * 2, // ２(大甲)
  "O6d":  594 * 2, // ３(大甲)
  "O6e-": 627 * 2, // ４(大甲)
  "O6f":  704 * 2, // ５(大甲)
  "O6g":  792 * 2, // (未使用)
};
const uchi_notes = {
  "O3b-": 528 / 2, // 一
  "O3b":  594 / 2, // 二x
  "O4c":  594 / 2, // 二
  "O4d-": 660 / 2, // 三x
  "O4d":  660 / 2, // 三
  "O4e-": 704 / 2, // 四
  "O4e":  792 / 2, // 五x
  "O4f":  792 / 2, // 五
  "O4g-": 888 / 2, // 六x
  "O4g":  888 / 2, // 六
  "O4a-": 888 / 2, // 七x
  "O4a":  792 / 2, // 七
  "O4b-": 528,     // １
  "O4b":  594,     // ２x
  "O5c":  594,     // ２
  "O5d-": 660,     // ３x
  "O5d":  660,     // ３
  "O5e-": 704,     // ４
  "O5e":  792,     // ５x
  "O5f":  792,     // ５
  "O5g-": 888,     // ６x
  "O5g":  888,     // ６
  "O5a-": 888,     // ７x
  "O5a":  792,     // ７
  "O5b-": 888,     // ８x(未使用)
  "O5b":  888,     // ８(大甲)
  "O6c":  0,       // ２(大甲)
  "O6d":  0,       // ３(大甲)
  "O6e-": 0,       // ４(大甲)
  "O6f":  0,       // ５(大甲)
  "O6g":  0,       // (未使用)
};

function playMusic(sheet) {
  context = new AudioContext();
  const gainNode = context.createGain();
  gainNode.gain.value = volume;

  const soundData = sheet.split(',');
  const oscillator = context.createOscillator();
  oscillator.type = "sine";
  oscillator.connect(gainNode);
  gainNode.connect(context.destination);
  oscillator.start(0);
  let currentTime = context.currentTime;

  for (let i = 0; i < soundData.length; ++i) {
    const pitch_re = /O\d.+/g;
    const length_re = /L\d{1,2}/g;
    const pitch = soundData[i].match(pitch_re);
    const length = soundData[i].match(length_re);
    let time;

    if (length[0] === "L4") {
      // 四分音符
      time = 60 / tempo;
    } else if (length[0] === "L8") {
      // 八分音符
      time = (60 / tempo) / 2;
    } else {
      // 二分音符
      time = (60 / tempo) * 2;
    }

    let frequency = notes[pitch[0]];
    let uchi_frequency = uchi_notes[pitch[0]];

    if ( ( i === ( soundData.length - 1 ) ) ||
         ( pitch[0] !== soundData[i + 1].match(pitch_re)[0] ) ) {
      oscillator.frequency.setValueAtTime(frequency, currentTime);
      currentTime += time;  
    } else {
      // 次の音が同じ高さの場合は、指打ちをする
      oscillator.frequency.setValueAtTime(frequency, currentTime);
      currentTime += time - yubiuchi;
      oscillator.frequency.setValueAtTime(uchi_frequency, currentTime);
      currentTime += yubiuchi;
    }
  }

  oscillator.stop(currentTime);
}

function stopMusic() {
  if (context) {
    context.close();
    context = null;
  }
}

const playBtn = document.getElementById("play-btn");
if (playBtn){
  playBtn.addEventListener("click", () => {
    const sheet = document.getElementById('sheet').value
    playMusic(sheet);
  });
}

const stopBtn = document.getElementById("stop-btn");
if (stopBtn){
  stopBtn.addEventListener("click", () => {
    stopMusic();
  });
}
