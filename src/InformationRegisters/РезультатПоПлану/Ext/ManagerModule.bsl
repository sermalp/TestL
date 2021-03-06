﻿
Функция ЗаписатьЗначение(Проект, ИД, Дата, РезультатПоПлану, ФактЧЧ) Экспорт

	Если НЕ ЗначениеЗаполнено(ИД) Тогда
	
		ИД = Новый УникальныйИдентификатор;
	
	КонецЕсли; 
	
	Пользователь = ПараметрыСеанса.ТекущийПользователь;
	ТекущееЗначение = ПрочитатьЗначение(Проект, ИД, Дата, Пользователь);
	
	Если ТекущееЗначение.РезультатПоПлану <> РезультатПоПлану ИЛИ ТекущееЗначение.ФактЧЧ <> ФактЧЧ Тогда
		
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Проект = Проект;
		МенеджерЗаписи.ИД = ИД;
		МенеджерЗаписи.Дата = Дата;
		МенеджерЗаписи.РезультатПоПлану = РезультатПоПлану;
		МенеджерЗаписи.ФактЧЧ = ФактЧЧ;
		МенеджерЗаписи.Пользователь = Пользователь;
		МенеджерЗаписи.Записать();
		
	КонецЕсли;		
КонецФункции
 
Функция ПрочитатьЗначение(Проект, ИД, Дата, Пользователь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РСРезультатПоПлану.Проект,
		|	РСРезультатПоПлану.ИД,
		|	РСРезультатПоПлану.Дата,
		|	РСРезультатПоПлану.Пользователь,
		|	РСРезультатПоПлану.РезультатПоПлану,
		|	РСРезультатПоПлану.ФактЧЧ
		|ИЗ
		|	РегистрСведений.РезультатПоПлану КАК РСРезультатПоПлану
		|ГДЕ
		|	РСРезультатПоПлану.Проект = &Проект
		|	И РСРезультатПоПлану.ИД = &ИД
		|	И РСРезультатПоПлану.Дата = &Дата
		|	И РСРезультатПоПлану.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ИД", ИД);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Проект", Проект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат Новый Структура("РезультатПоПлану,ФактЧЧ", ВыборкаДетальныеЗаписи.РезультатПоПлану, ВыборкаДетальныеЗаписи.ФактЧЧ);
	Иначе
		Возврат Новый Структура("РезультатПоПлану,ФактЧЧ", "", 0);
	КонецЕсли;	
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	// Вставить обработку выборки ВыборкаДетальныеЗаписи
	//КонецЦикла;

КонецФункции

Функция УдалитьЗапись(Проект, ИД, Дата, Пользователь = Неопределено) экспорт
	
	Если Пользователь = Неопределено Тогда
	
		Пользователь = ПараметрыСеанса.ТекущийПользователь;
	
	КонецЕсли;

	НаборЗаписей = СоздатьНаборЗаписей(); 
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Отбор.Проект.Установить(Проект);
	НаборЗаписей.Отбор.ИД.Установить(ИД);
	НаборЗаписей.Отбор.Дата.Установить(Дата);
	НаборЗаписей.Записать();	
	
КонецФункции
