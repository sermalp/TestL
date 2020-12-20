﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-процессы и задачи".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при открытии формы выбора исполнителя.
// Позволяет переопределить стандартную форму выбора.
//
// Параметры:
//   ЭлементИсполнитель   - ЭлементФормы - элемент формы, в которой выполняется выбора исполнителя, 
//                          который будет указан как владелец формы выбора исполнителя.
//   РеквизитИсполнитель  - СправочникСсылка.Пользователи - выбранное ранее значение исполнителя.
//                          Используется для установки текущей строки в форме выбора исполнителя.
//   ТолькоПростыеРоли    - Булево, если Истина, то указывает что для выбора нужно 
//                          использовать только роли без объектов адресации.
//   БезВнешнихРолей      - Булево, если Истина, то указывает, что для выбора надо
//                          использовать только роли, у которых не установлен признак ВнешняяРоль.
//   СтандартнаяОбработка - Булево - если установить в Ложь, то не требуется выводить стандартную форму выбора
//                                   исполнителя.
//
Процедура ПриВыбореИсполнителя(ЭлементИсполнитель, РеквизитИсполнитель, ТолькоПростыеРоли, БезВнешнихРолей,
	СтандартнаяОбработка) Экспорт
	
КонецПроцедуры	

#КонецОбласти
