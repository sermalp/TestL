﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	НастроитьОтображениеСпискаРолей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_НаборКонстант" И Источник = "ИспользоватьВнешнихПользователей" Тогда
		НастроитьОтображениеСпискаРолей();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьОтображениеСпискаРолей()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей") Тогда
		ТекстЗапроса = "ВЫБРАТЬ
		|	СправочникРолиИсполнителей.Ссылка,
		|	СправочникРолиИсполнителей.ПометкаУдаления,
		|	СправочникРолиИсполнителей.Предопределенный,
		|	СправочникРолиИсполнителей.Код,
		|	СправочникРолиИсполнителей.Наименование,
		|	СправочникРолиИсполнителей.ИспользуетсяБезОбъектовАдресации,
		|	СправочникРолиИсполнителей.ИспользуетсяСОбъектамиАдресации,
		|	СправочникРолиИсполнителей.ТипыОсновногоОбъектаАдресации,
		|	СправочникРолиИсполнителей.ТипыДополнительногоОбъектаАдресации,
		|	СправочникРолиИсполнителей.Комментарий,
		|	ВЫБОР
		|		КОГДА СправочникРолиИсполнителей.ИспользуетсяСОбъектамиАдресации
		|			ТОГДА ИСТИНА
		|		КОГДА СправочникРолиИсполнителей.Ссылка В
		|				(ВЫБРАТЬ ПЕРВЫЕ 1
		|					РегистрСведений.ИсполнителиЗадач.РольИсполнителя.Ссылка
		|				ИЗ
		|					РегистрСведений.ИсполнителиЗадач
		|				ГДЕ
		|					РегистрСведений.ИсполнителиЗадач.РольИсполнителя = СправочникРолиИсполнителей.Ссылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьИсполнители,
		|	СправочникРолиИсполнителей.ВнешняяРоль,
		|	СправочникРолиИсполнителей.КраткоеПредставление
		|ИЗ
		|	Справочник.РолиИсполнителей КАК СправочникРолиИсполнителей";
	Иначе
		ТекстЗапроса = "ВЫБРАТЬ
		|	СправочникРолиИсполнителей.Ссылка,
		|	СправочникРолиИсполнителей.ПометкаУдаления,
		|	СправочникРолиИсполнителей.Предопределенный,
		|	СправочникРолиИсполнителей.Код,
		|	СправочникРолиИсполнителей.Наименование,
		|	СправочникРолиИсполнителей.ИспользуетсяБезОбъектовАдресации,
		|	СправочникРолиИсполнителей.ИспользуетсяСОбъектамиАдресации,
		|	СправочникРолиИсполнителей.ТипыОсновногоОбъектаАдресации,
		|	СправочникРолиИсполнителей.ТипыДополнительногоОбъектаАдресации,
		|	СправочникРолиИсполнителей.Комментарий,
		|	ВЫБОР
		|		КОГДА СправочникРолиИсполнителей.ИспользуетсяСОбъектамиАдресации
		|			ТОГДА ИСТИНА
		|		КОГДА СправочникРолиИсполнителей.Ссылка В
		|				(ВЫБРАТЬ ПЕРВЫЕ 1
		|					РегистрСведений.ИсполнителиЗадач.РольИсполнителя.Ссылка
		|				ИЗ
		|					РегистрСведений.ИсполнителиЗадач
		|				ГДЕ
		|					РегистрСведений.ИсполнителиЗадач.РольИсполнителя = СправочникРолиИсполнителей.Ссылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьИсполнители,
		|	СправочникРолиИсполнителей.ВнешняяРоль,
		|	СправочникРолиИсполнителей.КраткоеПредставление
		|ИЗ
		|	Справочник.РолиИсполнителей.Назначение КАК РолиИсполнителейНазначение
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиИсполнителей КАК СправочникРолиИсполнителей
		|		ПО РолиИсполнителейНазначение.Ссылка = СправочникРолиИсполнителей.Ссылка
		|ГДЕ
		|	РолиИсполнителейНазначение.ТипПользователей = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
		КонецЕсли;
		
		Список.ТекстЗапроса = ТекстЗапроса;
	КонецПроцедуры
	
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ГруппаЭлементовОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора .ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьИсполнители");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВнешняяРоль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.РольБезИсполнителей);
	
КонецПроцедуры

#КонецОбласти
