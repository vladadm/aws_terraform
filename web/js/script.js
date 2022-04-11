//let timer_show = document.getElementById("timer");

// Функция для вычисления разности времени
function diffSubtract(date1, date2) {
    return date2 - date1;
}

// Массив данных о времени
let start_date = {
    "full_year": "2022",
    "month": "04",
    "day": "09",
    "hours": "00",
    "minutes": "00",
    "seconds": "00"
}
let end_date = {
    "full_year": "2022",
    "month": "06",
    "day": "07",
    "hours": "23",
    "minutes": "20",
    "seconds": "00"
}

// Строка для вывода времени
let start_date_str = `${start_date.full_year}-${start_date.month}-${start_date.day}T${start_date.hours}:${end_date.minutes}:${start_date.seconds}`;


// Запуск интервала таймера
timer = setInterval(function () {
    // Получение времени сейчас
    let now = new Date();
    // Получение заданного времени
    let date = new Date(start_date_str);
    // Вычисление разницы времени
    let ms_left = diffSubtract(date, now);
    let res = new Date(ms_left);
    // Если разница времени меньше или равна нулю
    // if (ms_left <= 0) { // То
    //     // Выключаем интервал
    //     clearInterval(timer);
    //     // Выводим сообщение об окончание
    //     alert("Время закончилось");
    // } else { // Иначе
    //     // Получаем время зависимую от разницы
    //     let res = new Date(ms_left);
    //     // Делаем строку для вывода
        //let str_timer = `${res.getUTCDate() - 1} ${res.getUTCHours()}:${res.getUTCMinutes()}:${res.getUTCSeconds()}`;
        // Выводим время
        //timer_show.innerHTML = str_timer;
        document.getElementById("numblock days").innerHTML = res.getUTCDate() - 1;
        document.getElementById("numblock hours").innerHTML = res.getUTCHours();
        document.getElementById("numblock mins").innerHTML = res.getUTCMinutes();
        document.getElementById("numblock secs").innerHTML = res.getUTCSeconds();
    // }
}, 1000)
