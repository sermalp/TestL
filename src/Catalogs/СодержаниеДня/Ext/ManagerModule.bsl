﻿
Функция ПолучитьТаблицуЭлементовСправочника() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	Справочник.СодержаниеДня КАК СодержаниеДня
		|ГДЕ
		|	НЕ СодержаниеДня.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Код";
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выгрузить();
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	// Вставить обработку выборки ВыборкаДетальныеЗаписи
	//КонецЦикла;

КонецФункции
 