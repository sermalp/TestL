﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Взаимодействия"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму нового документа "Электронное письмо исходящее"
// с переданными в процедуру параметрами.
//
// Параметры:
//  Отправитель  - СправочникСсылка.УчетныеЗаписи - учетная запись, с которой выполняется отправка.
//  Получатель   - Строка, СписокЗначений, Массив - список получателей письма.
//  Тема         - Строка - тема письма.
//  Текст        - Строка - текст письма.
//  СписокФайлов - Массив - вложения письма.
//  Предмет      - Ссылка - предмет письма.
//
Процедура ОткрытьФормуОтправкиПочтовогоСообщения(Знач Отправитель = Неопределено,
                                                 Знач Получатель = Неопределено,
                                                 Знач Тема = "",
                                                 Знач Текст = "",
                                                 Знач СписокФайлов = Неопределено,
                                                 Знач Предмет = Неопределено,
                                                 Знач ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	ПараметрыПисьма = Новый Структура;
	
	ПараметрыПисьма.Вставить("УчетнаяЗапись", Отправитель);
	ПараметрыПисьма.Вставить("Кому", Получатель);
	ПараметрыПисьма.Вставить("Тема", Тема);
	ПараметрыПисьма.Вставить("Тело", Текст);
	ПараметрыПисьма.Вставить("Вложения", СписокФайлов);
	ПараметрыПисьма.Вставить("Предмет", Предмет);
	
	ОткрытьФорму("Документ.ЭлектронноеПисьмоИсходящее.Форма.ФормаДокумента", ПараметрыПисьма, , , , , ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// Открывает форму нового документа "Сообщение SMS"
// с переданными в процедуру параметрами.
//
// Параметры:
//  Адресаты             - Строка, СписокЗначений, Массив - список получателей письма.
//  Текст                - Строка - текст письма.
//  Предмет              - Ссылка - предмет письма.
//  ОтправлятьВТранслите - Булево - признак того, что сообщение при отправке должно быть преобразовано в латинские
//                                  символы.
//
Процедура ОткрытьФормуОтправкиSMS(знач Адресаты = Неопределено,
                                  знач Текст = "",
                                  знач Предмет = Неопределено,
                                  знач ОтправлятьВТранслите = Ложь) Экспорт
	
	ПараметрыСообщения = Новый Структура;
	
	ПараметрыСообщения.Вставить("Адресаты", Адресаты);
	ПараметрыСообщения.Вставить("Текст", Текст);
	ПараметрыСообщения.Вставить("Предмет", Предмет);
	ПараметрыСообщения.Вставить("ОтправлятьВТранслите", ОтправлятьВТранслите);
	
	ОткрытьФорму("Документ.СообщениеSMS.Форма.ФормаДокумента", ПараметрыСообщения);
	
КонецПроцедуры

// Обработчик для события формы ПослеЗаписиНаСервере. Вызывается для контакта.
//
// Параметры:
//  Форма                          - УправляемаяФорма - форма, для которой обрабатывается событие.
//  Объект                         - ДанныеФормыКоллекция - данные объекта хранимые в форме.
//  ПараметрыЗаписи                - Структура - структура, в которую добавляются параметры, которые потом будут
//                                               посланы с оповещением.
//  ИмяОбъектаОтправителяСообщения - Строка - имя объекта метаданных, для формы которого обрабатывается событие.
//  ПосылатьОповещение  - Булево   - признак необходимости отправки оповещения из этой процедуры.
//
Процедура КонтактПослеЗаписи(Форма,Объект,ПараметрыЗаписи,ИмяОбъектаОтправителяСообщения,ПосылатьОповещение = Истина) Экспорт
	
	Если Форма.НеобходимоОповещение Тогда
		
		Если ЗначениеЗаполнено(Форма.ОбъектОснование) Тогда
			ПараметрыЗаписи.Вставить("Ссылка",Объект.Ссылка);
			ПараметрыЗаписи.Вставить("Наименование",Объект.Наименование);
			ПараметрыЗаписи.Вставить("Основание",Форма.ОбъектОснование);
			ПараметрыЗаписи.Вставить("ТипОповещения","ЗаписьКонтакта");
		КонецЕсли;
		
		Если ПосылатьОповещение Тогда
			Оповестить("Запись_" + ИмяОбъектаОтправителяСообщения,ПараметрыЗаписи,Объект.Ссылка);
			Форма.НеобходимоОповещение = Ложь
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик для события формы ПослеЗаписиНаСервере. Вызывается для взаимодействия или предмета взаимодействия.
//
// Параметры:
//  Форма                          - УправляемаяФорма - форма, для которой обрабатывается событие.
//  Объект                         - ДанныеФормыКоллекция - данные объекта хранимые в форме.
//  ПараметрыЗаписи                - Структура - структура, в которую добавляются параметры, которые потом будут
//                                               посланы с оповещением.
//  ИмяОбъектаОтправителяСообщения - Строка - имя объекта метаданных, для формы которого обрабатывается событие.
//  ПосылатьОповещение  - Булево   - признак необходимости отправки оповещения из этой процедуры.
// 
Процедура ВзаимодействиеПредметПослеЗаписи(Форма,Объект,ПараметрыЗаписи,ИмяОбъектаОтправителяСообщения = "",ПосылатьОповещение = Истина) Экспорт
	
	Если Форма.НеобходимоОповещение Тогда
		
		Если ЗначениеЗаполнено(Форма.ВзаимодействиеОснование) Тогда
			ПараметрыЗаписи.Вставить("Основание",Форма.ВзаимодействиеОснование);
		Иначе
			ПараметрыЗаписи.Вставить("Основание",Неопределено);
		КонецЕсли;
	
		Если ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(Объект.Ссылка) Тогда
			ПараметрыЗаписи.Вставить("Предмет",Форма.Предмет);
			ПараметрыЗаписи.Вставить("ТипОповещения","ЗаписьВзаимодействия");
		ИначеЕсли ВзаимодействияКлиентСервер.ЯвляетсяПредметом(Объект.Ссылка) Тогда
			ПараметрыЗаписи.Вставить("Предмет",Объект.Ссылка);
			ПараметрыЗаписи.Вставить("ТипОповещения","ЗаписьПредмета");
		КонецЕсли;
		
		Если ПосылатьОповещение Тогда
			Оповестить("Запись_" + ИмяОбъектаОтправителяСообщения,ПараметрыЗаписи,Объект.Ссылка);
			Форма.НеобходимоОповещение = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик для события формы ПроверкаПеретаскивания. Вызывается для списка предметов при перетаскивании в него взаимодействий.
//
// Параметры:
//  Элемент                   - ТаблицаФормы - таблица, для которой обрабатывается событие.
//  ПараметрыПеретаскивания   - ПараметрыПеретаскивания - содержит перетаскиваемое значение, тип действия и возможные действия при перетаскивании.
//  СтандартнаяОбработка      - Булево - признак стандартной обработки события.
//  Строка                    - СтрокаТаблицы - строка таблицы, над которой находится курсор.
//  Поле                      - Поле - элемент управляемой формы, с которым связана данная колонка таблицы.
//
Процедура СписокПредметПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле) Экспорт
	
	Если (Строка = Неопределено) ИЛИ (ПараметрыПеретаскивания.Значение = Неопределено) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Для каждого ЭлементМассива Из ПараметрыПеретаскивания.Значение Цикл
			Если ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(ЭлементМассива) Тогда
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	
КонецПроцедуры

// Обработчик для события формы Перетаскивание Вызывается для списка предметов при перетаскивании в него взаимодействий.
//
// Параметры:
//  Элемент                   - ТаблицаФормы - таблица, для которой обрабатывается событие.
//  ПараметрыПеретаскивания   - ПараметрыПеретаскивания - содержит перетаскиваемое значение, тип действия и возможные действия при перетаскивании.
//  СтандартнаяОбработка      - Булево - признак стандартной обработки события.
//  Строка                    - СтрокаТаблицы - строка таблицы, над которой находится курсор.
//  Поле                      - Поле - элемент управляемой формы, с которым связана данная колонка таблицы.
//
Процедура СписокПредметПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		ВзаимодействияВызовСервера.УстановитьПредметДляМассиваВзаимодействий(ПараметрыПеретаскивания.Значение,
			Строка, Истина);
			
	КонецЕсли;
	
	Оповестить("ИзменениеПредметаВзаимодействий");
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создает взаимодействие или предмет взаимодействия.
// Параметры:
//  ИмяФормыОбъекта - имя формы элемента создаваемого объекта,
//  Основание       - объект основание,
//  Источник        - форма объекта-основания.
//
Процедура СоздатьВзаимодействиеИлиПредмет(ИмяФормыОбъекта, Основание, Источник) Экспорт

	ПараметрыОткрытияФормы = Новый Структура("Основание", Основание);
	Если (ТипЗнч(Основание) = Тип("ДокументСсылка.Встреча") 
	    ИЛИ  ТипЗнч(Основание) = Тип("ДокументСсылка.ЗапланированноеВзаимодействие"))
		И Источник.Элементы.Найти("Участники") <> Неопределено
		И Источник.Элементы.Участники.ТекущиеДанные <> Неопределено Тогда
	
	    ДанныеУчастникаИсточник = Источник.Элементы.Участники.ТекущиеДанные;
	    ПараметрыОткрытияФормы.Вставить("ДанныеУчастника",Новый Структура("Контакт,КакСвязаться,Представление",
	                                                                      ДанныеУчастникаИсточник.Контакт,
	                                                                      ДанныеУчастникаИсточник.КакСвязаться,
	                                                                      ДанныеУчастникаИсточник.ПредставлениеКонтакта));
	
	ИначеЕсли (ТипЗнч(Основание) = Тип("ДокументСсылка.СообщениеSMS") 
		 И Источник.Элементы.Адресаты.ТекущиеДанные <> Неопределено)
		 И Источник.Элементы.Найти("Адресаты") <> Неопределено Тогда
		
		ДанныеУчастникаИсточник = Источник.Элементы.Адресаты.ТекущиеДанные;
		ПараметрыОткрытияФормы.Вставить("ДанныеУчастника",Новый Структура("Контакт,КакСвязаться,Представление",
		                                                                  ДанныеУчастникаИсточник.Контакт,
		                                                                  ДанныеУчастникаИсточник.КакСвязаться,
		                                                                  ДанныеУчастникаИсточник.ПредставлениеКонтакта));
	
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормыОбъекта, ПараметрыОткрытияФормы, Источник);

КонецПроцедуры

// Открывает форму объекта-контакта заполненную по описанию участника взаимодействия.
// Параметры:
//  Описание  - текстовое описание контакта,
//  Адрес     - контактная информация,
//  Основание - объект, из которого создается контакт.
//
Процедура СоздатьКонтакт(Описание, Адрес, Основание,ТипыКонтактов) Экспорт

	Если ТипыКонтактов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Описание", Описание);
	ДополнительныеПараметры.Вставить("Адрес", Адрес);
	ДополнительныеПараметры.Вставить("Основание", Основание);
	ОбработчикОповещения = Новый ОписаниеОповещения("ВыборТипаКонтактаПриЗавершении", ЭтотОбъект, ДополнительныеПараметры);
	ТипыКонтактов.ПоказатьВыборЭлемента(ОбработчикОповещения, НСтр("ru = 'Выбор типа контакта'"));

КонецПроцедуры

// Обработчик оповещения выбора типа контакта при создании контакта из документов взаимодействий.
// Параметры:
//  РезультатВыбора - ЭлементСпискаЗначений - в значение элемента содержится строковое представление типа контакта,
//  ДополнительныеПараметры - Структура - содержит поля "Описание", "Адрес" и "Основание".
//
Процедура ВыборТипаКонтактаПриЗавершении(РезультатВыбора, ДополнительныеПараметры) Экспорт

	Если РезультатВыбора <> Неопределено Тогда
		ПараметрФормы = Новый Структура(
			"Основание",ДополнительныеПараметры);
		Если НЕ ВзаимодействияКлиентПереопределяемый.СоздатьКонтактНестандартнаяФорма(РезультатВыбора.Значение,ПараметрФормы) Тогда
			ОткрытьФорму("Справочник." + РезультатВыбора.Значение + ".ФормаОбъекта", ПараметрФормы);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Обработчик для события формы ОбработкаОповещения. Вызывается для взаимодействия.
Процедура ОтработатьОповещение(Форма,ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("ТипОповещения") Тогда
		Если (Параметр.ТипОповещения = "ЗаписьВзаимодействия" ИЛИ Параметр.ТипОповещения = "ЗаписьПредмета")
			И Параметр.Основание = Форма.Объект.Ссылка Тогда
			
			Если (Форма.Предмет = Неопределено ИЛИ ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(Форма.Предмет))
				И Форма.Предмет <> Параметр.Предмет Тогда
				Форма.Предмет = Параметр.Предмет;
				Форма.ОтобразитьИзменениеДанных(Форма.Предмет, ВидИзмененияДанных.Изменение);
			КонецЕсли;
			
		ИначеЕсли Параметр.ТипОповещения = "ЗаписьКонтакта" И Параметр.Основание = Форма.Объект.Ссылка Тогда
			
			Если ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда
				Форма.Объект.АбонентКонтакт = Параметр.Ссылка;
				Если ПустаяСтрока(Форма.Объект.АбонентПредставление) Тогда
					Форма.Объект.АбонентПредставление = Параметр.Наименование;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.Встреча") 
				ИЛИ ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.ЗапланированноеВзаимодействие")Тогда
				Форма.Элементы.Участники.ТекущиеДанные.Контакт = Параметр.Ссылка;
				Если ПустаяСтрока(Форма.Элементы.Участники.ТекущиеДанные.ПредставлениеКонтакта) Тогда
					Форма.Элементы.Участники.ТекущиеДанные.ПредставлениеКонтакта = Параметр.Наименование;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.СообщениеSMS") Тогда
				Форма.Элементы.Адресаты.ТекущиеДанные.Контакт = Параметр.Ссылка;
				Если ПустаяСтрока(Форма.Элементы.Адресаты.ТекущиеДанные.ПредставлениеКонтакта) Тогда
					Форма.Элементы.Адресаты.ТекущиеДанные.ПредставлениеКонтакта = Параметр.Наименование;
				КонецЕсли;
			КонецЕсли;
			
			Форма.Элементы.СоздатьКонтакт.Доступность = Ложь;
			Форма.Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ВыбранКонтакт" Тогда
		
		Если Форма.ИмяФормы = "Документ.ЭлектронноеПисьмоИсходящее.Форма.ФормаДокумента" 
			ИЛИ Форма.ИмяФормы = "Документ.ЭлектронноеПисьмоВходящее.Форма.ФормаДокумента" Тогда
			Возврат;
		КонецЕсли;
		
		БылИзмененКонтакт = (Параметр.Контакт <> Параметр.ВыбранныйКонтакт) И ЗначениеЗаполнено(Параметр.Контакт);
		Контакт = Параметр.ВыбранныйКонтакт;
		Если Параметр.ТолькоEmail Тогда
			ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты");
		ИначеЕсли Параметр.ТолькоТелефон Тогда
			ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон");
		Иначе
			ТипКонтактнойИнформации = Неопределено;
		КонецЕсли;
		
		Если БылИзмененКонтакт Тогда
			
			Если НЕ Параметр.ДляФормыУточненияКонтактов Тогда
				ВзаимодействияВызовСервера.ПолучитьПредставлениеИВсюКонтактнуюИнформациюКонтакта(
				             Контакт, Параметр.Представление, Параметр.Адрес, ТипКонтактнойИнформации);
			КонецЕсли;
			
			Адрес         = Параметр.Адрес;
			Представление = Параметр.Представление;
			
		ИначеЕсли Параметр.ЗаменятьПустыеАдресИПредставление И (ПустаяСтрока(Параметр.Адрес) ИЛИ ПустаяСтрока(Параметр.Представление)) Тогда
			
			нПредставление = ""; 
			нАдрес = "";
			ВзаимодействияВызовСервера.ПолучитьПредставлениеИВсюКонтактнуюИнформациюКонтакта(
			             Контакт, нПредставление, нАдрес, ТипКонтактнойИнформации);
			
			Представление = ?(ПустаяСтрока(Параметр.Представление), нПредставление, Параметр.Представление);
			Адрес         = ?(ПустаяСтрока(Параметр.Адрес), нАдрес, Параметр.Адрес);
			
		Иначе
			
			Адрес         = Параметр.Адрес;
			Представление = Параметр.Представление;
			
		КонецЕсли;
		
		Если Форма.ИмяФормы = "ОбщаяФорма.АдреснаяКнига" Тогда

			ТекущиеДанные = Форма.Элементы.ПолучателиПисьма.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			ТекущиеДанные.Контакт       = Контакт;
			ТекущиеДанные.Адрес         = Адрес;
			ТекущиеДанные.Представление = Представление;
			
			Форма.Модифицированность = Истина;
			
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.СообщениеSMS") Тогда
			ТекущиеДанные = Форма.Элементы.Адресаты.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			Форма.ИзменилисьКонтакты = Истина;
			
			ТекущиеДанные.Контакт               = Контакт;
			ТекущиеДанные.КакСвязаться          = Адрес;
			ТекущиеДанные.ПредставлениеКонтакта = Представление;
			
			ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Форма.Объект,Форма,"СообщениеSMS");
			
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.ЗапланированноеВзаимодействие") Тогда
			ТекущиеДанные = Форма.Элементы.Участники.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			Форма.ИзменилисьКонтакты = Истина;
			
			ТекущиеДанные.Контакт               = Контакт;
			ТекущиеДанные.КакСвязаться          = Адрес;
			ТекущиеДанные.ПредставлениеКонтакта = Представление;
			
			ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Форма.Объект,Форма,"ЗапланированноеВзаимодействие");
			Форма.Модифицированность = Истина;
			
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.Встреча") Тогда
			ТекущиеДанные = Форма.Элементы.Участники.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			Форма.ИзменилисьКонтакты = Истина;
			
			ТекущиеДанные.Контакт               = Контакт;
			ТекущиеДанные.КакСвязаться          = Адрес;
			ТекущиеДанные.ПредставлениеКонтакта = Представление;
			
			ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Форма.Объект,Форма,"ЗапланированноеВзаимодействие");
			Форма.Модифицированность = Истина;
			
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда
			
			Форма.ИзменилисьКонтакты = Истина;
			
			Форма.Объект.АбонентКонтакт       = Контакт;
			Форма.Объект.АбонентКакСвязаться  = Адрес;
			Форма.Объект.АбонентПредставление = Представление;
			
			ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Форма.Объект,Форма,"ТелефонныйЗвонок");
			Форма.Модифицированность = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Создает новый документ взаимодействий.
//
// Параметры:
//  ТипОбъект         - Строка - тип создаваемого объекта.
//  ПараметрыСоздания - Структура - параметры создаваемого документа.
//  ЭлементСписок     - ТаблицаФормы - элемент формы в котором происходит создание.
//
Процедура СоздатьНовоеВзаимодействие(ТипОбъекта,ПараметрыСоздания = Неопределено, Форма = Неопределено) Экспорт

	ОткрытьФорму("Документ."+ ТипОбъекта+".ФормаОбъекта",ПараметрыСоздания, Форма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ОБРАБОТЧИКИ СОБЫТИЙ ДОКУМЕНТОВ ВЗАИМОДЕЙСТВИЙ

// Вызывает форму выбора контакта и обрабатывает результат выбора.
//
// Параметры:
//  Предмет                           - Ссылка - ссылка на предмет взаимодействия.
//  Адрес                             - Строка - адрес контакта.
//  Представление                     - Строка - представление контакта.
//  Контакт                           - Ссылка - контакт.
//  Параметры                         - Структура - структура параметров открытия формы, состоит из
//                                                ТолькоEmail, 
//                                                ТолькоТелефон,
//                                                ЗаменятьПустыеАдресИПредставление,
//                                                ДляФормыУточненияКонтактов.
//
// Возвращаемое значение:
//  Булево - истина, если выбор был сделан, ложь в обратном случае.
//
Функция ВыбратьКонтакт(Предмет, Адрес, Представление, Контакт, Параметры) Экспорт

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Предмет",       Предмет);
	ПараметрыОткрытия.Вставить("Адрес",         Адрес);
	ПараметрыОткрытия.Вставить("Представление", Представление);
	ПараметрыОткрытия.Вставить("Контакт",       Контакт);
	ПараметрыОткрытия.Вставить("ТолькоEmail",   Параметры.ТолькоEmail);
	ПараметрыОткрытия.Вставить("ТолькоТелефон", Параметры.ТолькоТелефон);
	ПараметрыОткрытия.Вставить("ЗаменятьПустыеАдресИПредставление", Параметры.ЗаменятьПустыеАдресИПредставление);
	ПараметрыОткрытия.Вставить("ДляФормыУточненияКонтактов", Параметры.ДляФормыУточненияКонтактов);
	
	ОткрытьФорму("ОбщаяФорма.ВыборКонтакта", ПараметрыОткрытия);

КонецФункции

// Обработка выбора поля "рассмотреть после" в документах взаимодействиях.
//
// Параметры:
//  ЗначениеПоля         - Дата - значение поля "Отработать после". 
//  ВыбранноеЗначение    - Дата, число - либо выбранная дата, либо числовой инкремент от текущей даты.
//  СтандартнаяОбработка - Булево - признак стандартной обработки обработчика события формы.
//  Модифицированность   - Булево - признак модифицированности формы.
//
Процедура ОбработатьВыборВПолеРассмотретьПосле(ЗначениеПоля, ВыбранноеЗначение, СтандартнаяОбработка, Модифицированность) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Число") Тогда
		ЗначениеПоля = ОбщегоНазначенияКлиент.ДатаСеанса() + ВыбранноеЗначение;
	Иначе
		ЗначениеПоля = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает отбор по владельцу в динамическом списке подчиненного справочника, при активизации строки
// динамического списка справочника родителя.
 //
// Параметры:
 //  Элемент  		- ТаблицаФормы - таблица в которой произошло событие.
 //  Форма		 	- УправляемаяФорма - форма, на которой находятся элементы.
 //
Процедура КонтактВладелецПриАктивизацииСтроки(Элемент,Форма)  Экспорт
	
	ИмяТаблицыБезПрефикса = Прав(Элемент.Имя,СтрДлина(Элемент.Имя)-8);
	ЗначениеОтбора = ?(Элемент.ТекущиеДанные = Неопределено, Неопределено, Элемент.ТекущиеДанные.Ссылка);
	
	МассивОписанияКонтактов = ВзаимодействияКлиентСервер.МассивОписанияВозможныхКонтактов();
	Для каждого ЭлементМассиваОписания Из МассивОписанияКонтактов  Цикл
		Если ЭлементМассиваОписания.ИмяВладельца = ИмяТаблицыБезПрефикса Тогда
			КоллекцияОтборов = Форма["Список_" + ЭлементМассиваОписания.Имя].КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
			КоллекцияОтборов.Элементы[0].ПравоеЗначение = ЗначениеОтбора;
		КонецЕсли;
	КонецЦикла;
 
КонецПроцедуры 

// Задает вопрос пользователю при смене режима форматирования электронного письма с HTML на обычный текст.
Процедура ВопросПриИзмененииФорматаСообщенияНаОбычныйТекст(Форма, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросПриИзмененииФорматаПриЗакрытии", Форма, ДополнительныеПараметры);
	ТекстСообщения = НСтр("ru='При преобразовании этого сообщения в обычный текст будут утеряны все элементы оформления, картинки и прочие вставленные элементы. Продолжить?'");
	ПоказатьВопрос(ОбработчикОповещенияОЗакрытии, ТекстСообщения, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Изменение формата письма'"));
	
КонецПроцедуры

// Обработчик перед началом добавления динамических списков журнала взаимодействия.
//
// Параметры:
//  Элемент - ЭлементФормы - список в который происходит добавление.
//  Отказ  - Булево - признак отказа от добавления.
//  Копирование  - Булево - признак копирования.
//  ТолькоПочта  - ТолькоПочта - признак того что используются только почтовый клиент.
//  ДокументыДоступныеДляСоздания  - СписокЗначений - список доступных для создания документов.
//  ПараметрыСоздания  - Структура - параметры создания нового документа.
//
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование,ТолькоПочта,ДокументыДоступныеДляСоздания,ПараметрыСоздания = Неопределено) Экспорт
	
	Если Копирование Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") 
			Или ТипЗнч(ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
			Отказ = Истина;
			Если Не ТолькоПочта Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Копирование электронных писем запрещено'"));
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик для события формы ПриНажатии поля HTML документа.
//
// Параметры:
//  Элемент                        - ЭлементФормы - для которой обрабатывается событие.
//  ДанныеСобытия                  - ФиксированнаяСтруктура - данные содержит параметры события.
//  СтандартнаяОбработка           - Булево - признак стандартной обработки события.
//
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка) Экспорт
	
	Если ДанныеСобытия.Href <> Неопределено Тогда
		СтандартнаяОбработка = ЛОЖЬ;
		
		ОбщегоНазначенияКлиент.ПерейтиПоСсылке(ДанныеСобытия.Href);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет проверку правильности заполнения реквизитов ДатаКогдаОтправить и ДатаАктуальностиОтправки в форме
// документа.
//
// Параметры:
//  Объект - ДокументОбъект - документ, в котором выполняется проверка.
//  Отказ  - Булево - устанавливает в истина, если реквизиты заполнены не правильно.
//
Процедура ПроверкаЗаполненностиРеквизитовОтложеннойОтправки(Объект, Отказ) Экспорт
	
	Если Объект.ДатаКогдаОтправить > Объект.ДатаАктуальностиОтправки И (Не Объект.ДатаАктуальностиОтправки = Дата(1,1,1)) Тогда
		
		Отказ = Истина;
		ТекстСообщения= НСтр("ru = 'Дата актуальности отправки меньше чем дата отправки.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ДатаАктуальностиОтправки");
		
	КонецЕсли;
	
	Если НЕ Объект.ДатаАктуальностиОтправки = Дата(1,1,1)
			И Объект.ДатаАктуальностиОтправки < ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
	
		Отказ = Истина;
		ТекстСообщения= НСтр("ru = 'Указанная дата актуальности меньше текущей даты, такое сообщение никогда не будет отправлено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ДатаАктуальностиОтправки");
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредметНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("ЖурналДокументов.Взаимодействия.Форма.ВыборТипаПредмета", ,Форма);
	
КонецПроцедуры

Процедура ФормаОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора, КонтекстВыбора) Экспорт
	
	 Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ЖурналДокументов.Взаимодействия.Форма.ВыборТипаПредмета") Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		
		КонтекстВыбора = "ВыборПредмета";
		
		ОткрытьФорму(ВыбранноеЗначение + ".ФормаВыбора", ПараметрыФормы, Форма);
		
	ИначеЕсли КонтекстВыбора = "ВыборПредмета" Тогда
		
		Если ВзаимодействияКлиентСервер.ЯвляетсяПредметом(ВыбранноеЗначение)
			Или ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(ВыбранноеЗначение) Тогда
		
			Форма.Предмет = ВыбранноеЗначение;
			Форма.Модифицированность = Истина;
		
		КонецЕсли;
		
		КонтекстВыбора = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
