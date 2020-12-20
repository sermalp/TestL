﻿#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("*");
	Возврат Результат;
	
КонецФункции

#КонецЕсли

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	Если Не СтандартнаяОбработка Тогда 
		// Обрабатывается в другом месте.
		Возврат;
		
	ИначеЕсли Не Параметры.Свойство("РазрешитьДанныеКлассификатора") Тогда
		// Поведение по умолчанию, подбор только справочника.
		Возврат;
		
	ИначеЕсли Истина<>Параметры.РазрешитьДанныеКлассификатора Тогда
		// Подбор классификатора отключен, поведение по умолчанию.
		Возврат;
		
	ИначеЕсли Не ЕстьПравоДобавления() Тогда
		// Нет прав на добавление страны мира, поведение по умолчанию.
		Возврат;
		
	КонецЕсли;
	
	// Будем имитировать поведение платформы - поиск по всем доступным полям поиска с формированием подобного списка.
	
	// Подразумеваем, что поля справочника и классификатора совпадают, за исключением отсутствующего в классификаторе поля
	// "Ссылка".
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПрефиксПараметраОтбора = "ПараметрыОтбора";
	
	// Общий отбор по параметрам
	ШаблонОтбора = "ИСТИНА";
	Для Каждого КлючЗначение Из Параметры.Отбор Цикл
		ЗначениеПоля = КлючЗначение.Значение;
		ИмяПоля      = КлючЗначение.Ключ;
		ИмяПараметра = ПрефиксПараметраОтбора + ИмяПоля;
		
		Если ТипЗнч(ЗначениеПоля)=Тип("Массив") Тогда
			ШаблонОтбора = ШаблонОтбора + " И %1." + ИмяПоля + " В (&" + ИмяПараметра + ")";
		Иначе
			ШаблонОтбора = ШаблонОтбора + " И %1." + ИмяПоля + " = &" + ИмяПараметра;
		КонецЕсли;
		
		Запрос.УстановитьПараметр(ИмяПараметра, КлючЗначение.Значение);
	КонецЦикла;
	
	// Дополнительные отборы
	Если Параметры.Свойство("ВыборГруппИЭлементов") Тогда
		Если Параметры.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Группы Тогда
			ШаблонОтбора = ШаблонОтбора + " И %1.ЭтоГруппа";
			
		ИначеЕсли Параметры.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы Тогда
			ШаблонОтбора = ШаблонОтбора + " И (НЕ %1.ЭтоГруппа)";
			
		КонецЕсли;
	КонецЕсли;
	
	// Источники данных
	Если (Параметры.Свойство("ТолькоДанныеКлассификатора") И Параметры.ТолькоДанныеКлассификатора) Тогда
		// Запрос только по классификатору.
		ШаблонЗапроса = "
			|ВЫБРАТЬ ПЕРВЫЕ 50
			|	NULL                       КАК Ссылка,
			|	Классификатор.Код          КАК Код,
			|	Классификатор.Наименование КАК Наименование,
			|	ЛОЖЬ                       КАК ПометкаУдаления,
			|	%2                         КАК Представление
			|ИЗ
			|	Классификатор КАК Классификатор
			|ГДЕ
			|	Классификатор.%1 ПОДОБНО &СтрокаПоиска
			|	И (
			|		" + СтрЗаменить(ШаблонОтбора, "%1", "Классификатор") + "
			|	)
			|УПОРЯДОЧИТЬ ПО
			|	Классификатор.%1
			|";
	Иначе
		// Запрос и по справочнику и по классификатору.
		ШаблонЗапроса = "
			|ВЫБРАТЬ ПЕРВЫЕ 50 
			|	СтраныМира.Ссылка                                             КАК Ссылка,
			|	ЕСТЬNULL(СтраныМира.Код, Классификатор.Код)                   КАК Код,
			|	ЕСТЬNULL(СтраныМира.Наименование, Классификатор.Наименование) КАК Наименование,
			|	ЕСТЬNULL(СтраныМира.ПометкаУдаления, ЛОЖЬ)                    КАК ПометкаУдаления,
			|
			|	ВЫБОР КОГДА СтраныМира.Ссылка ЕСТЬ NULL ТОГДА 
			|		%2 
			|	ИНАЧЕ 
			|		%3
			|	КОНЕЦ КАК Представление
			|
			|ИЗ
			|	Справочник.СтраныМира КАК СтраныМира
			|ПОЛНОЕ СОЕДИНЕНИЕ
			|	Классификатор
			|ПО
			|	Классификатор.Код = СтраныМира.Код
			|	И Классификатор.Наименование = СтраныМира.Наименование
			|ГДЕ 
			|	(СтраныМира.%1 ПОДОБНО &СтрокаПоиска ИЛИ Классификатор.%1 ПОДОБНО &СтрокаПоиска)
			|	И (" + СтрЗаменить(ШаблонОтбора, "%1", "Классификатор") + ")
			|	И (" + СтрЗаменить(ШаблонОтбора, "%1", "СтраныМира") + ")
			|
			|УПОРЯДОЧИТЬ ПО
			|	ЕСТЬNULL(СтраныМира.%1, Классификатор.%1)
			|";
	КонецЕсли;
	
	ИменаПолей = ПоляПоиска();
	
	// Код + Наименование - ключевые поля соответствия справочника классификатору. Их обрабатываем всегда.
	ИменаПолейСтрокой = "," + СтрЗаменить(ИменаПолей.ИменаПолейСтрокой, " ", "");
	ИменаПолейСтрокой = СтрЗаменить(ИменаПолейСтрокой, ",Код", "");
	ИменаПолейСтрокой = СтрЗаменить(ИменаПолейСтрокой, ",Наименование", "");
	
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	Код, Наименование " + ИменаПолейСтрокой + "
		|ПОМЕСТИТЬ
		|	Классификатор
		|ИЗ
		|	&Классификатор КАК Классификатор
		|ИНДЕКСИРОВАТЬ ПО
		|	Код, Наименование
		|	" + ИменаПолейСтрокой + "
		|";
	Запрос.УстановитьПараметр("Классификатор", ТаблицаКлассификатора());
	Запрос.Выполнить();
	Запрос.УстановитьПараметр("СтрокаПоиска", ЭкранироватьСимволыПодобия(Параметры.СтрокаПоиска) + "%");
	
	Для Каждого ДанныеПоля Из ИменаПолей.СписокПолей Цикл
		ТекстЗапроса = СтрЗаменить(ШаблонЗапроса, "%1", ДанныеПоля.Имя);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%2", СтрЗаменить(ДанныеПоля.ШаблонПредставления, "%1", "Классификатор"));
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "%3", СтрЗаменить(ДанныеПоля.ШаблонПредставления, "%1", "СтраныМира"));
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			ДанныеВыбора = Новый СписокЗначений;
			СтандартнаяОбработка = Ложь;
			
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
					// Данные справочника
					ЭлементВыбора = Выборка.Ссылка;
				Иначе
					// Данные классификатора
					РезультатВыбора = Новый Структура("Код, Наименование", 
						Выборка.Код, Выборка.Наименование);
					
					ЭлементВыбора = Новый Структура("Значение, ПометкаУдаления, Предупреждение",
						РезультатВыбора, Выборка.ПометкаУдаления, Неопределено);
				КонецЕсли;
				
				ДанныеВыбора.Добавить(ЭлементВыбора, Выборка.Представление);
			КонецЦикла;
		
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Определяет данные страны по справочнику стран или классификатору ОКСМ.
//
// Параметры:
//    КодСтраны    - Строка, Число - код ОКСМ страны. Если не указано, то поиск по коду не производится.
//    Наименование - Строка        - наименование страны. Если не указано, то поиск по наименованию не производится.
//
// Возвращаемое значение:
//    Структура - поля:
//          * Код                - Строка - реквизит найденной страны.
//          * Наименование       - Строка - реквизит найденной страны.
//          * НаименованиеПолное - Строка - реквизит найденной страны.
//          * КодАльфа2          - Строка - реквизит найденной страны.
//          * КодАльфа3          - Строка - реквизит найденной страны.
//          * Ссылка             - СправочникаСсылка.СтраныМира - реквизит найденной страны.
//    Неопределено - страна не найдена.
//
Функция ДанныеСтраныМира(Знач КодСтраны = Неопределено, Знач Наименование = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	
	Если КодСтраны=Неопределено И Наименование=Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	НормализованныйКод = КодСтраныМира(КодСтраны);
	Если КодСтраны=Неопределено Тогда
		УсловиеПоиска = "ИСТИНА";
		ФильтрКлассификатора = Новый Структура;
	Иначе
		УсловиеПоиска = "Код=" + КонтрольКавычекВСтроке(НормализованныйКод);
		ФильтрКлассификатора = Новый Структура("Код", НормализованныйКод);
	КонецЕсли;
	
	Если Наименование<>Неопределено Тогда
		УсловиеПоиска = УсловиеПоиска + " И Наименование=" + КонтрольКавычекВСтроке(Наименование);
		ФильтрКлассификатора.Вставить("Наименование", Наименование);
	КонецЕсли;
	
	Результат = Новый Структура("Ссылка, Код, Наименование, НаименованиеПолное, КодАльфа2, КодАльфа3");
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Ссылка, Код, Наименование, НаименованиеПолное, КодАльфа2, КодАльфа3
	|ИЗ
	|	Справочник.СтраныМира
	|ГДЕ
	|	" + УсловиеПоиска + "
	|УПОРЯДОЧИТЬ ПО
	|	Наименование
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
		
	Иначе
		ДанныеКлассификатора = ТаблицаКлассификатора();
		СтрокиДанных = ДанныеКлассификатора.НайтиСтроки(ФильтрКлассификатора);
		Если СтрокиДанных.Количество()=0 Тогда
			Результат = Неопределено;
		Иначе
			ЗаполнитьЗначенияСвойств(Результат, СтрокиДанных[0]);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Определяет данные страны по классификатору ОКСМ.
//
// Параметры:
//    Код - Строка, Число - код ОКСМ страны.
//    ТипКода - Строка - Варианты: КодСтраны (по умолчанию), Альфа2, Альфа3.
//
// Возвращаемое значение:
//    Структура - поля:
//          * Код                - Строка - реквизит найденной страны.
//          * Наименование       - Строка - реквизит найденной страны.
//          * НаименованиеПолное - Строка - реквизит найденной страны.
//          * КодАльфа2          - Строка - реквизит найденной страны.
//          * КодАльфа3          - Строка - реквизит найденной страны.
//    Неопределено - страна не найдена.
//
Функция ДанныеКлассификатораСтранМираПоКоду(Знач Код, ТипКода = "КодСтраны") Экспорт
	
	ДанныеКлассификатора = ТаблицаКлассификатора();
	Если СтрСравнить(ТипКода, "Альфа2") = 0 Тогда
		СтрокаДанных = ДанныеКлассификатора.Найти(ВРег(Код), "КодАльфа2");
	ИначеЕсли СтрСравнить(ТипКода, "Альфа3") = 0 Тогда
		СтрокаДанных = ДанныеКлассификатора.Найти(ВРег(Код), "КодАльфа3");
	Иначе
		СтрокаДанных = ДанныеКлассификатора.Найти(КодСтраныМира(Код), "Код");
	КонецЕсли;
	
	Если СтрокаДанных=Неопределено Тогда
		Результат = Неопределено;
	Иначе
		Результат = Новый Структура("Код, Наименование, НаименованиеПолное, КодАльфа2, КодАльфа3");
		ЗаполнитьЗначенияСвойств(Результат, СтрокаДанных);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Определяет данные страны по классификатору ОКСМ.
//
// Параметры:
//    Наименование - Строка - наименование страны.
//
// Возвращаемое значение:
//    Структура - поля:
//          * Код                - Строка - реквизит найденной страны.
//          * Наименование       - Строка - реквизит найденной страны.
//          * НаименованиеПолное - Строка - реквизит найденной страны.
//          * КодАльфа2          - Строка - реквизит найденной страны.
//          * КодАльфа3          - Строка - реквизит найденной страны.
//    Неопределено - страна не найдена.
//
Функция ДанныеКлассификатораСтранМираПоНаименованию(Знач Наименование) Экспорт
	ДанныеКлассификатора = ТаблицаКлассификатора();
	СтрокаДанных = ДанныеКлассификатора.Найти(Наименование, "Наименование");
	Если СтрокаДанных=Неопределено Тогда
		Результат = Неопределено;
	Иначе
		Результат = Новый Структура("Код, Наименование, НаименованиеПолное, КодАльфа2, КодАльфа3");
		ЗаполнитьЗначенияСвойств(Результат, СтрокаДанных);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Создает или возвращает существующую ссылку по данным классификатора.
//
// Параметры:
//    Отбор - Структура - содержит поле:
//          * Код - Строка - для поиска страны в классификаторе.
//    Данные - Структура - для заполнения одноименных оставшихся полей создаваемого объекта.
//
// Возвращаемое значение:
//     СправочникСсылка.СтраныМира - ссылка на созданный элемент.
//
Функция СсылкаПоДаннымКлассификатора(Знач Отбор, Знач ДополнительныеДанные = Неопределено) Экспорт
	
	// Убеждаемся, что страна есть в классификаторе.
	ДанныеПоиска = ДанныеКлассификатораСтранМираПоКоду(Отбор.Код);
	Если ДанныеПоиска=Неопределено Тогда
		ВызватьИсключение НСтр("ru='Некорректный код страны мира для поиска в классификаторе'");
	КонецЕсли;
	
	// Проверяем на существование в справочнике по данным классификатора.
	ДанныеПоиска = ДанныеСтраныМира(ДанныеПоиска.Код, ДанныеПоиска.Наименование);
	Результат = ДанныеПоиска.Ссылка;
	Если Не ЗначениеЗаполнено(Результат) Тогда
		ОбъектСтраны = Справочники.СтраныМира.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(ОбъектСтраны, ДанныеПоиска);
		Если ДополнительныеДанные<>Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ОбъектСтраны, ДополнительныеДанные);
		КонецЕсли;
		ОбъектСтраны.Записать();
		Результат = ОбъектСтраны.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Возвращает полные данные ОКСМ классификатора.
//
// Возвращаемое значение:
//     ТаблицаЗначений - данные классификатора с колонками:
//         * Код                - Строка - данные страны.
//         * Наименование       - Строка - данные страны.
//         * НаименованиеПолное - Строка - данные страны.
//         * КодАльфа2          - Строка - данные страны.
//         * КодАльфа3          - Строка - данные страны.
//
//     Таблица значений проиндексирована по полям "Код", "Наименование".
//
Функция ТаблицаКлассификатора() Экспорт
	Макет = Справочники.СтраныМира.ПолучитьМакет("Классификатор");
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Макет.ПолучитьТекст());
	
	Возврат СериализаторXDTO.ПрочитатьXML(Чтение);
КонецФункции

// Возвращает флаг возможности добавления и изменения элементов.
//
Функция ЕстьПравоДобавления() Экспорт
	Возврат ПравоДоступа("Добавление", Метаданные.Справочники.СтраныМира);
КонецФункции

// Возвращает поля поиска в порядке предпочтения для справочника стран мира.
//
// Возвращаемое значение:
//    Массив - содержит структуры с полями:
//      * Имя                 - Строка - имя реквизита поиска.
//      * ШаблонПредставления - Строка - шаблон для формирования значения представления по именам реквизитов, 
//                                       например: "%1.Наименование (%1.Код)". Здесь "Наименование" и "Код" - имена
//                                       реквизитов,
//                                       "%1" - заполнитель для передачи псевдонима таблицы.
//
Функция ПоляПоиска()
	Результат = Новый Массив;
	СписокПолей = Справочники.СтраныМира.ПустаяСсылка().Метаданные().ВводПоСтроке;
	ГраницаПолей = СписокПолей.Количество() - 1;
	ВсеИменаСтрокой = "";
	
	ПредставлениеРазделителя = ", ";
	РазделительПредставлений = " + """ + ПредставлениеРазделителя + """ + ";
	
	Для Индекс=0 По ГраницаПолей Цикл
		ИмяПоля = СписокПолей[Индекс].Имя;
		ВсеИменаСтрокой = ВсеИменаСтрокой + "," + ИмяПоля;
		
		ШаблонПредставления = "%1." + ИмяПоля;
		
		ОстальныеПоля = "";
		Для Позиция=0 По ГраницаПолей Цикл
			Если Позиция<>Индекс Тогда
				ОстальныеПоля = ОстальныеПоля + РазделительПредставлений + СписокПолей[Позиция].Имя;
			КонецЕсли;
		КонецЦикла;
		Если Не ПустаяСтрока(ОстальныеПоля) Тогда
			ШаблонПредставления = ШаблонПредставления
				+ " + "" ("" + " 
				+ "%1." + Сред(ОстальныеПоля, СтрДлина(РазделительПредставлений) + 1) 
				+ " + "")""";
		КонецЕсли;
		
		Результат.Добавить(
			Новый Структура("Имя, ШаблонПредставления", ИмяПоля, ШаблонПредставления));
	КонецЦикла;
	
	Возврат Новый Структура("СписокПолей, ИменаПолейСтрокой", Результат, Сред(ВсеИменаСтрокой, 2));
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Приводит код страны к единому виду - строка длиной три символа.
//
Функция КодСтраныМира(Знач КодСтраны)
	
	Если ТипЗнч(КодСтраны)=Тип("Число") Тогда
		Возврат Формат(КодСтраны, "ЧЦ=3; ЧН=; ЧВН=; ЧГ=");
	КонецЕсли;
	
	Возврат Прав("000" + КодСтраны, 3);
КонецФункции

// Возвращает строку в кавычках.
//
Функция КонтрольКавычекВСтроке(Знач Строка)
	Возврат """" + СтрЗаменить(Строка, """", """""") + """";
КонецФункции

// Экранирует символы для использования в функции запроса ПОДОБНО.
//
Функция ЭкранироватьСимволыПодобия(Знач Текст, Знач СпецСимвол = "\")
	Результат = Текст;
	СимволыПодобия = "%_[]^" + СпецСимвол;
	
	Для Позиция=1 По СтрДлина(СимволыПодобия) Цикл
		ТекущийСимвол = Сред(СимволыПодобия, Позиция, 1);
		Результат = СтрЗаменить(Результат, ТекущийСимвол, СпецСимвол + ТекущийСимвол);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецЕсли