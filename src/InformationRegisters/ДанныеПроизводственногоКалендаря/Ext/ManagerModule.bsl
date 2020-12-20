﻿
Функция ЭтоВыходной(Дата, ПроизводственныйКалендарь = Неопределено) Экспорт

	Если ПроизводственныйКалендарь = Неопределено Тогда
		ПроизводственныйКалендарь = Справочники.ПроизводственныеКалендари.НайтиПоКоду("РФ");
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ДанныеПроизводственногоКалендаря.ВидДня В (&мсвВыходныеВидыДня)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК флВыходной
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
		|	И ДанныеПроизводственногоКалендаря.Дата = &Дата";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	мсвВыходныеВидыДня = Новый Массив();
	мсвВыходныеВидыДня.Добавить(Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье);
	мсвВыходныеВидыДня.Добавить(Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота);
	мсвВыходныеВидыДня.Добавить(Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник);
	Запрос.УстановитьПараметр("мсвВыходныеВидыДня", мсвВыходныеВидыДня);
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь", ПроизводственныйКалендарь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.флВыходной;
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА


КонецФункции
 