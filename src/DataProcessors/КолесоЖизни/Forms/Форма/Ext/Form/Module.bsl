﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьНаСервере();
	
	////заполняем список дат и инфо по задачам на каждую дату
	//ЗаполнитьСписокДат();
	//ВыбраннаяДата = СписокДат[0].Дата;
	//
	////строи график по данным задач
	//Если НЕ ЗначениеЗаполнено(ВидГрафика) Тогда
	//	ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.ЧасыФакт;
	//КонецЕсли; 
	//ПолучитьИОтобразитьДиаграмму();
	//
	////создаем доп реквизиты для описаний дня
	//СоздатьДополнительныеРеквизитыФормыДляПрочейИнформации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДат()

	СписокДат.Очистить();
	
	ТекДата = ТекущаяДата();
	Дней = Константы.КоличествоАнализируемыхДней_КолесоЖизни.Получить();
	ДнейП = Окр(Дней/2);//чтобы текущая дата была примерно по-середине
	
	ОдинДень = 86400;
	ДатаНач = ТекДата - ДнейП * ОдинДень;//дней назад
	ТаблицаЗадач.Очистить();
	Для Сч = 1 По Дней Цикл
		//добавить дату в список
		НоваяДата = СписокДат.Добавить();
		НоваяДата.Дата = ДатаНач;
		НоваяДата.флВыходной = РегистрыСведений.ДанныеПроизводственногоКалендаря.ЭтоВыходной(ДатаНач);
		//заполнить для даты план и резльтат по плану
		ЗаполнитьТаблицуЗадач(ДатаНач, ТаблицаЗадач);
		//
		ДатаНач = ДатаНач + ОдинДень;
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьИОтобразитьДиаграмму()

	Диаграмма = График;//ЭлементыФормы.ДиаграммаПродажиПоМесяцам; 

    // Очистить диаграмму, возможно ранее в нее уже выводились данные. 
    Диаграмма.КоличествоСерий = 0; 
    Диаграмма.КоличествоТочек = 0; 


    // Количество серий будет ограничиваться (не все значения будут показываться). 
    //Диаграмма.МаксимумСерий = МаксимумСерий.Ограничено; 
    //Диаграмма.МаксимумСерийКоличество = 7; 
    Диаграмма.ВидПодписей = ВидПодписейКДиаграмме.СерияЗначение;
	
	//
	//Диаграмма.ОтображатьЗаголовок = Ложь;
	//Диаграмма.ОтображатьЛегенду = Ложь;
    //Диаграмма.ОбластьЗаголовка.Текст = "Выручка по месяцам, руб"; 

	Таблица = ПолучитьТаблицуДляВидаГрафика(ВидГрафика, СписокДат.Выгрузить(,"Дата"));
	//Запрос = Новый Запрос; 
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ТипыИПроекты.Ссылка,
	//|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РСПлан.ИД) КАК Количество
	//|ИЗ
	//|	Справочник.ТипыИПроекты КАК ТипыИПроекты
	//|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	//|			РСПлан.ИД КАК ИД,
	//|			РСПлан.Проект.Родитель КАК ПроектРодитель
	//|		ИЗ
	//|			РегистрСведений.План КАК РСПлан
	//|		ГДЕ
	//|			РСПлан.Дата В(&СписокДат)) КАК РСПлан
	//|		ПО ТипыИПроекты.Ссылка = РСПлан.ПроектРодитель
	//|ГДЕ
	//|	ТипыИПроекты.ЭтоГруппа
	//|	И НЕ ТипыИПроекты.ПометкаУдаления
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	ТипыИПроекты.Ссылка"
	//	"";
	//	
	//Запрос.УстановитьПараметр("СписокДат", СписокДат.Выгрузить(,"Дата"));
	//

	//Результат = Запрос.Выполнить(); 


    // Запретить обновление диаграммы на время вывода данных. 
    Диаграмма.Обновление = Ложь; 


    // Установить единственную точку. 
    Диаграмма.КоличествоТочек = 1; 
    Диаграмма.Точки[0].Текст = "количество"; 
	
	Диаграмма.МаксимумСерийКоличество = Таблица.Количество();
	Для каждого ТекТипПроекта Из Таблица Цикл
        // Количество серий, если бы не ограничивали зависело бы от результата запроса. 
        КоличествоСерий = Диаграмма.Серии.Количество(); 
        Диаграмма.КоличествоСерий = КоличествоСерий + 1; 
		
		КолонкаСоЗначением = ?(ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.КоличествоПлан
			ИЛИ ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.КоличествоФакт, "Количество", "ЧЧ");
		Значение = ТекТипПроекта[КолонкаСоЗначением];
		
        Диаграмма.Серии[КоличествоСерий].Текст = ""+ТекТипПроекта.ТипПроекта+", "+Значение;
        // Установить значение "на пересечении" точки и серии. 
        // Первый параметр - 0 , так как в диаграмме только одна точка.
		
		
		Диаграмма.УстановитьЗначение(0, КоличествоСерий, Значение); 	
		
	
	КонецЦикла; 
	
	//Выборка = Результат.Выбрать(); 
	//
	//Диаграмма.МаксимумСерийКоличество = Выборка.Количество();
	//Пока Выборка.Следующий() Цикл 
	//    // Количество серий, если бы не ограничивали зависело бы от результата запроса. 
	//    КоличествоСерий = Диаграмма.Серии.Количество(); 
	//    Диаграмма.КоличествоСерий = КоличествоСерий + 1; 
	//    Диаграмма.Серии[КоличествоСерий].Текст = Выборка.Ссылка;
	//    // Установить значение "на пересечении" точки и серии. 
	//    // Первый параметр - 0 , так как в диаграмме только одна точка. 
	//    Диаграмма.УстановитьЗначение(0, КоличествоСерий, Выборка.Количество); 
	//КонецЦикла; 

    // Обновить диаграмму. 
    Диаграмма.Обновление = Истина;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТаблицуДляВидаГрафика(ВидГрафика, Даты)

	Если ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.КоличествоПлан
		ИЛИ ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.ЧасыПлан Тогда
	
		ИмяРегистра = "План";
		КолонкаРесурса = "ОценкаЧЧ";
			
	ИначеЕсли ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.КоличествоФакт
		ИЛИ ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.ЧасыФакт Тогда
	
		ИмяРегистра = "РезультатПоПлану";
		КолонкаРесурса = "ФактЧЧ";
	
	КонецЕсли; 

	Запрос = Новый Запрос; 
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТипыИПроекты.Ссылка КАК ТипПроекта,
		|	ВЫБОР
		|		КОГДА РС.Количество ЕСТЬ NULL 
		|			ТОГДА 0.01
		|		ИНАЧЕ РС.Количество
		|	КОНЕЦ КАК Количество,
		|	ВЫБОР
		|		КОГДА РС.ЧЧ ЕСТЬ NULL 
		|			ТОГДА 0.01
		|		ИНАЧЕ РС.ЧЧ
		|	КОНЕЦ КАК ЧЧ
		|ИЗ
		|	Справочник.ТипыИПроекты КАК ТипыИПроекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			РС.Проект.Родитель КАК ПроектРодитель,
		|			1 КАК Количество,
		|			РС."+КолонкаРесурса+" КАК ЧЧ
		|		ИЗ
		|			РегистрСведений."+ИмяРегистра+" КАК РС
		|		ГДЕ
		|			РС.Дата В(&СписокДат)) КАК РС
		|		ПО ТипыИПроекты.Ссылка = РС.ПроектРодитель
		|ГДЕ
		|	ТипыИПроекты.ЭтоГруппа
		|	И НЕ ТипыИПроекты.ПометкаУдаления";
			
		//|	РС.ОценкаЧЧ КАК ЧЧ
		//|	РС."+КолонкаРесурса+" КАК ЧЧ
		
		//|	РегистрСведений.План КАК РСПлан
		//|	РегистрСведений."+ИмяРегистра+" КАК РС
		
	Запрос.УстановитьПараметр("СписокДат", Даты);
	
	Результат = Запрос.Выполнить();
	тз = Результат.Выгрузить();
	
	Если ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.КоличествоПлан
		ИЛИ ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.КоличествоФакт Тогда
	
		КолонкиСуммирования = "Количество";
			
	ИначеЕсли ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.ЧасыПлан
		ИЛИ ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.ЧасыФакт Тогда
	
		КолонкиСуммирования = "ЧЧ";
	
	КонецЕсли;
	
	тз.Свернуть("ТипПроекта", КолонкиСуммирования);
	
	Возврат тз;
КонецФункции
 
&НаСервере
Процедура СоздатьДополнительныеРеквизитыФормыДляПрочейИнформации()
	Пользователь = ПараметрыСеанса.ТекущийПользователь;
	ТаблицаДня = Справочники.СодержаниеДня.ПолучитьТаблицуЭлементовСправочника();	
	Для каждого СтрокаДата Из СписокДат Цикл
		ИмяГруппы = СформироватьИмяГруппы(СтрокаДата.Дата);
		Элемент = ЭтаФорма.Элементы.Найти(ИмяГруппы);
		Если Элемент = Неопределено Тогда
			Элемент = ЭтаФорма.Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), ЭтаФорма.Элементы.ПрочееИнфо);
			Элемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		КонецЕсли; 
		
		Для каждого ТекЭлемент Из ТаблицаДня Цикл
			ИмяРеквизита = СформироватьИмяРеквизита(ТекЭлемент.Код, СтрокаДата.Дата);
			Попытка
				ЗначениеНовогоРеквизита = ЭтотОбъект[ИмяРеквизита];
			Исключение
				СоздатьПолеНаСервере(ИмяРеквизита, ТекЭлемент.Наименование, Элемент);
			КонецПопытки; 
			
			//заполним значение из регистра
			ТекущееЗначение = РегистрыСведений.ОписаниеДняПоСодержанию.ПрочитатьЗначение(ТекЭлемент.Ссылка, СтрокаДата.Дата, Пользователь);
			ЭтотОбъект[ИмяРеквизита] = ТекущееЗначение.Описание;
		КонецЦикла; 	
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СоздатьПолеНаСервере(ИмяРеквизита, ЗаголовокРеквизита, ЭлементРодитель)
     //Добавляем реквизит
     нРеквизиты = Новый Массив;
	 //ИмяРеквизита = "Реквизит1";
	 //ЗаголовокРеквизита = "Созданное поле";
     Реквизит = Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("Строка"), , ЗаголовокРеквизита, Истина);
     нРеквизиты.Добавить(Реквизит);
     ИзменитьРеквизиты(нРеквизиты);
 
     //Добавляем поле ввода
     //Элемент = ЭтаФорма.Элементы.Добавить("Поле", Тип("ПолеФормы"), ЭтаФорма);
	 Элемент = ЭтаФорма.Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), ЭлементРодитель);//Элементы.ПрочееИнфо
     Элемент.Вид = ВидПоляФормы.ПолеВвода;
	 Элемент.МногострочныйРежим = Истина;
     Элемент.ПутьКДанным = ИмяРеквизита;
	 Элемент.УстановитьДействие("ПриИзменении", "ПриИзмененииПоляСодержаниеДня");
КонецПроцедуры

&НаСервере
Процедура СоздатьПолеКартинкиНаСервере(ИмяРеквизита, ЗаголовокРеквизита, ЭлементРодитель)
	//Добавляем реквизит
	нРеквизиты = Новый Массив;
	//ИмяРеквизита = "Реквизит1";
	//ЗаголовокРеквизита = "Созданное поле";
	Реквизит = Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("Строка"), , ЗаголовокРеквизита, Истина);
	нРеквизиты.Добавить(Реквизит);
	ИзменитьРеквизиты(нРеквизиты);
	
	//Добавляем поле ввода
	Попытка
	
		//Элемент = ЭтаФорма.Элементы.Добавить(ИмяРеквизита, Тип("ПолеКартинки"), ЭлементРодитель);
		Элемент = ЭтаФорма.Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), ЭлементРодитель);
		//Элемент = ЭтаФорма.Элементы.Добавить(ИмяРеквизита, Тип("ДекорацияФормы"), ЭлементРодитель);
	
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки; 
	
	//Элемент.Видимость = Ложь;
	Элемент.Вид = ВидПоляФормы.ПолеКартинки;
	Элемент.РазмерКартинки = РазмерКартинки.АвтоРазмер;
	Элемент.ПутьКДанным = ИмяРеквизита;
	//Элемент.Картинка = БиблиотекаКартинок.ДлительнаяОперация48;	 
	
	//Элемент.Вид = ВидПоляФормы.ПолеВвода;
	//Элемент.МногострочныйРежим = Истина;
	
	//Элемент.УстановитьДействие("ПриИзменении", "ПриИзмененииПоляСодержаниеДня");
КонецПроцедуры

&НаСервере
Процедура УдалитьПоляКартинокНаСервере(ЭлементРодитель)
	уРеквизиты = Новый Массив;
	Для каждого ТекЭлемент Из ЭлементРодитель.ПодчиненныеЭлементы Цикл
	
		Если Лев(ТекЭлемент.Имя, 17) = "СсылкаНаКартинку_" Тогда
			
			уРеквизиты.Добавить(ТекЭлемент.Имя);
			
			Элементы.Удалить(ТекЭлемент);
		
		КонецЕсли;
	
	КонецЦикла; 
	
	ИзменитьРеквизиты(, уРеквизиты);
	
КонецПроцедуры
&НаКлиенте
Процедура ПриИзмененииПоляСодержаниеДня(Элемент)
	ПриИзмененииПоляСодержаниеДняНаСервере(Элемент.Имя);
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПоляСодержаниеДняНаСервере(ИмяРеквизита)
	
	струкРеквизита = РазобратьИмяРеквизита(ИмяРеквизита);
	
	стрОписание = ЭтотОбъект[ИмяРеквизита];
	
	РегистрыСведений.ОписаниеДняПоСодержанию.ЗаписатьЗначение(струкРеквизита.ЗначениеИзмерения, струкРеквизита.Дата, стрОписание);
	
КонецПроцедуры

&НаСервере
Функция РазобратьИмяРеквизита(ИмяРеквизита)
	струк = Новый Структура("Дата, ЗначениеИзмерения");
	
	//Дата
	стрДата = Прав(ИмяРеквизита, 8);
	струк.Дата = Дата(стрДата);
	
	//Измерение
	пИмяРеквизита = СтрЗаменить(ИмяРеквизита, "Реквизит_", "");
	стрКод = Лев(пИмяРеквизита, Метаданные.Справочники.СодержаниеДня.ДлинаКода);
	струк.ЗначениеИзмерения = Справочники.СодержаниеДня.НайтиПоКоду(стрКод);
	
	Возврат струк;
КонецФункции
&НаСервере
Функция СформироватьИмяГруппы(Дата)

	стрДата = ПреобразоватьДатуДляИмениРеквизита(Дата);
	Возврат "Группа_"+стрДата;

КонецФункции // СформироватьИмяГруппы()
&НаСервере
Функция СформироватьИмяРеквизита(Код, Дата)
	
	Возврат "Реквизит_"+Код+"_"+ПреобразоватьДатуДляИмениРеквизита(Дата);

КонецФункции

&НаСервере
Функция ПреобразоватьДатуДляИмениРеквизита(Дата)

	Возврат Формат(Дата, "ДФ=yyyyMMdd");

КонецФункции

&НаКлиенте
Процедура СписокДатПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.СписокДат.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ВыбраннаяДата = ТекущиеДанные.Дата;
	КонецЕсли;
	
	УстановитьВидимостьГруппПрочееИнфо(СформироватьИмяГруппы(ВыбраннаяДата));
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьКартинкиВыбранногоДня()

	УдалитьПоляКартинокНаСервере(Элементы.Фотографии);
	
	СсылкаНаКартинку = "";
	КартинкиДня = РегистрыСведений.ФотографииДня.ПрочитатьЗначение(ПараметрыСеанса.ТекущийПользователь, ВыбраннаяДата);
	
	Если КартинкиДня = Неопределено Тогда
		Возврат;
	Иначе
		
		Если ТипЗнч(КартинкиДня) = Тип("Структура") Тогда
			ОтобразитьКартинку(КартинкиДня);
		Иначе
			Для каждого ТекСтрока Из КартинкиДня Цикл
				ОтобразитьКартинку(ТекСтрока);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры
&НаСервере
Процедура ОтобразитьКартинку(ПараметрыКартинки)
	ИмяРеквизита = "СсылкаНаКартинку_"+СтрЗаменить(ПараметрыКартинки.ИД, "-", "_1_");
	ЗаголовокРеквизита = "Картинка";
	ЭлементРодитель = Элементы.Фотографии;
	Попытка
		СоздатьПолеКартинкиНаСервере(ИмяРеквизита, ЗаголовокРеквизита, ЭлементРодитель);
	Исключение
		
	КонецПопытки; 
	
	ЗначениеКлюча = Новый Структура("Пользователь, Дата, ИД", ПараметрыКартинки.Пользователь, ПараметрыКартинки.Дата, ПараметрыКартинки.ИД);
	КлючЗаписи = РегистрыСведений.ФотографииДня.СоздатьКлючЗаписи(ЗначениеКлюча);
	
	СсылкаНаКартинку = ПолучитьНавигационнуюСсылку(КлючЗаписи, "Картинка");
	ЭтаФорма[ИмяРеквизита] = ПолучитьНавигационнуюСсылку(КлючЗаписи, "Картинка");

КонецПроцедуры
  
&НаКлиенте
Процедура УстановитьВидимостьГруппПрочееИнфо(ИмяГруппы)
	ЭлементыГруппы = ЭтаФорма.Элементы.ПрочееИнфо.ПодчиненныеЭлементы;
	Для каждого ТекЭлементФормы Из ЭлементыГруппы Цикл
		ТекЭлементФормы.Видимость = ТекЭлементФормы.Имя = ИмяГруппы;
	КонецЦикла; 
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Функция ЗаполнитьТаблицуЗадач(Дата, ТаблицаЗадач) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СпрТипыПроектов.ТипПроекта КАК ТипПроекта,
		|	СпрТипыПроектов.Дата КАК Дата,
		|	РСПлан.Проект,
		|	РСПлан.ИД,
		|	РСПлан.Пользователь,
		|	РСПлан.План,
		|	РСПлан.ОценкаЧЧ,
		|	РСФакт.РезультатПоПлану,
		|	РСФакт.ФактЧЧ
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТипыИПроекты.Ссылка КАК ТипПроекта,
		|		&ВыбраннаяДата КАК Дата
		|	ИЗ
		|		Справочник.ТипыИПроекты КАК ТипыИПроекты
		|	ГДЕ
		|		НЕ ТипыИПроекты.ПометкаУдаления
		|		И ТипыИПроекты.ЭтоГруппа
		|		И ТипыИПроекты.Родитель = &ПустойРодитель) КАК СпрТипыПроектов
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			РСПлан.Проект КАК Проект,
		|			РСПлан.ИД КАК ИД,
		|			РСПлан.Дата КАК Дата,
		|			РСПлан.Пользователь КАК Пользователь,
		|			РСПлан.План КАК План,
		|			РСПлан.ОценкаЧЧ КАК ОценкаЧЧ,
		|			РСПлан.Проект.Родитель КАК ТипПроекта
		|		ИЗ
		|			РегистрСведений.План КАК РСПлан
		|		ГДЕ
		|			РСПлан.Дата В(&ВыбраннаяДата)) КАК РСПлан
		|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|				РСРезультатПоПлану.Дата КАК Дата,
		|				РСРезультатПоПлану.Проект КАК Проект,
		|				РСРезультатПоПлану.ИД КАК ИД,
		|				РСРезультатПоПлану.РезультатПоПлану КАК РезультатПоПлану,
		|				РСРезультатПоПлану.ФактЧЧ КАК ФактЧЧ,
		|				РСРезультатПоПлану.Проект.Родитель КАК ТипПроекта
		|			ИЗ
		|				РегистрСведений.РезультатПоПлану КАК РСРезультатПоПлану
		|			ГДЕ
		|				РСРезультатПоПлану.Дата В(&ВыбраннаяДата)) КАК РСФакт
		|			ПО РСПлан.ИД = РСФакт.ИД
		|				И РСПлан.Дата = РСФакт.Дата
		|		ПО СпрТипыПроектов.ТипПроекта = РСПлан.ТипПроекта
		|			И СпрТипыПроектов.Дата = РСПлан.Дата
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	СпрТипыПроектов.ТипПроекта.Код";
	
	Запрос.УстановитьПараметр("ВыбраннаяДата", Дата);
	Запрос.УстановитьПараметр("ПустойРодитель", Справочники.ТипыИПроекты.ПустаяСсылка());
	
	РезультатЗапроса = Запрос.Выполнить();
	//ТаблицаЗадач.Загрузить(РезультатЗапроса.Выгрузить());
	//Возврат РезультатЗапроса.Выгрузить();
	
	тз = РезультатЗапроса.Выгрузить();
	Для каждого ТекСтрока Из тз Цикл
	
		НоваяСтрока = ТаблицаЗадач.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
	
	КонецЦикла; 	
	
	
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	// Вставить обработку выборки ВыборкаДетальныеЗаписи
	//КонецЦикла;

КонецФункции 

&НаКлиенте
Процедура ТаблицаЗадачПланПриИзменении(Элемент)
	ТаблицаЗадачПланПриИзмененииНаСервере(Элементы.ТаблицаЗадач.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТаблицаЗадачПланПриИзмененииНаСервере(Инд)
	ОбработатьИзмененияВСтрокеЗадачи(Инд, "План");
КонецПроцедуры
// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ОбработатьИзмененияВСтрокеЗадачи(Инд, стрТип)

	Пользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Если Инд <> Неопределено Тогда
		ТекДанные = ТаблицаЗадач.Получить(Инд);
		
		Проект = ТекДанные.Проект;
		ИД = ТекДанные.ИД;
		Дата = ТекДанные.Дата;
		
		Если стрТип = "План" Тогда
		
			ОценкаЧЧ = ТекДанные.ОценкаЧЧ;
			План = ТекДанные.План;
			РегистрыСведений.План.ЗаписатьЗначение(Проект, ИД, Дата, План, ОценкаЧЧ);
			
		ИначеЕсли стрТип = "Факт" Тогда
		
			ФактЧЧ = ТекДанные.ФактЧЧ;
			РезультатПоПлану = ТекДанные.РезультатПоПлану;
			РегистрыСведений.РезультатПоПлану.ЗаписатьЗначение(Проект, ИД, Дата, РезультатПоПлану, ФактЧЧ);
			
		КонецЕсли; 
	КонецЕсли; 	
	
	//подставим ИД в таблицу на форме
	ТекДанные.ИД = ИД;
	
КонецПроцедуры // ОбработатьИзмененияВСтрокеЗадачи(Инд)()
 
&НаКлиенте
Процедура ТаблицаЗадачПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Копирование Тогда
	
		ТекДанные = Элемент.ТекущиеДанные;
		ВыбЗнач = ТекДанные.Дата;
		
		Оповещение = Новый ОписаниеОповещения("ПослеВводаДатыЗадачи", ЭтаФорма, ТекДанные);
		ПоказатьВводЗначения(Оповещение, ВыбЗнач, "Введит дату переноса");
		
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаДатыЗадачи(ВыбЗнач, ТекДанные) Экспорт
	//если копируем в ту же дату, то подразумеваем, что просто копируем Проект и Тип, поэтому остальные поля очищаем
	//	и в регистр не пишем, а при изменнии описания плана пишем в регистр
	//если копируем в новую дату, тогда подразумеваем, что такую же задачу ставим на другой день, при этом
	//	сохраняем описание плана - добавляем в таблицу и пишем в регистр на выбранную дату
	
	Если ВыбЗнач = НачалоДня(ТекДанные.Дата) Тогда
		//если перенос в этот же день, тогда очистим описание задачи, потмоу что одинаковая не нужна
		ТекДанные.План = "";
		ТекДанные.ОценкаЧЧ = 0;
		ТекДанные.ИД = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Иначе
		ТекДанные.Дата = ВыбЗнач;
		
		ДопПараметры = Новый Структура("Проект, Дата, План, ИД, ОценкаЧЧ", 
				ТекДанные.Проект,
				ТекДанные.Дата,
				ТекДанные.План,
				Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
				ТекДанные.ОценкаЧЧ);	
				
		ТаблицаЗадачПриНачалеРедактированияНаСервере(ДопПараметры);		
	КонецЕсли; 
	
КонецПроцедуры
&НаСервереБезКонтекста
Процедура ТаблицаЗадачПриНачалеРедактированияНаСервере(ДопПараметры)
	РегистрыСведений.План.ЗаписатьЗначение(ДопПараметры.Проект, ДопПараметры.ИД, ДопПараметры.Дата, ДопПараметры.План, ДопПараметры.ОценкаЧЧ);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗадачОценкаЧЧПриИзменении(Элемент)
	ТаблицаЗадачОценкаЧЧПриИзмененииНаСервере(Элементы.ТаблицаЗадач.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТаблицаЗадачОценкаЧЧПриИзмененииНаСервере(Инд)
	ОбработатьИзмененияВСтрокеЗадачи(Инд, "План");
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗадачФактЧЧПриИзменении(Элемент)
	
	ТаблицаЗадачФактЧЧПриИзмененииНаСервере(Элементы.ТаблицаЗадач.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТаблицаЗадачФактЧЧПриИзмененииНаСервере(Инд)
	ОбработатьИзмененияВСтрокеЗадачи(Инд, "Факт");
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗадачРезультатПоПлануПриИзменении(Элемент)
	ТаблицаЗадачРезультатПоПлануПриИзмененииНаСервере(Элементы.ТаблицаЗадач.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТаблицаЗадачРезультатПоПлануПриИзмененииНаСервере(Инд)
	ОбработатьИзмененияВСтрокеЗадачи(Инд, "Факт");
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗадачПередУдалением(Элемент, Отказ)
	ТекДанные = Элемент.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
	
		ИД = ТекДанные.ИД;
		Дата = ТекДанные.Дата;
		Проект = ТекДанные.Проект;
	
	КонецЕсли; 
	ТаблицаЗадачПередУдалениемНаСервере(Проект, ИД, Дата);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТаблицаЗадачПередУдалениемНаСервере(Проект, ИД, Дата)
	Пользователь = ПараметрыСеанса.ТекущийПользователь;
	РегистрыСведений.План.УдалитьЗапись(Проект, ИД, Дата, Пользователь);
	РегистрыСведений.РезультатПоПлану.УдалитьЗапись(Проект, ИД, Дата, Пользователь);
КонецПроцедуры

&НаКлиенте
Процедура ВидГрафикаПриИзменении(Элемент)
	ВидГрафикаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВидГрафикаПриИзмененииНаСервере()
	ПолучитьИОтобразитьДиаграмму();
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	//заполняем список дат и инфо по задачам на каждую дату
	ЗаполнитьСписокДат();
	ВыбраннаяДата = СписокДат[0].Дата;
	
	//строим график по данным задач
	Если НЕ ЗначениеЗаполнено(ВидГрафика) Тогда
		ВидГрафика = Перечисления.КолесоЖизни_ВидыГрафика.ЧасыФакт;
	КонецЕсли; 
	ПолучитьИОтобразитьДиаграмму();
	
	//создаем доп реквизиты для описаний дня
	СоздатьДополнительныеРеквизитыФормыДляПрочейИнформации();
	
	//картинки
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	СписокДат.Очистить();
	ТаблицаЗадач.Очистить();
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьФото(Команда)
	Попытка
		СтрокаКартинки = КомпонентБО.ПолучитьКартинкуИзБуфераОбмена(); 
		Если ЗначениеЗаполнено(СтрокаКартинки) Тогда
			//из буфера
			СохранитьИзБуфера(СтрокаКартинки);
		Иначе
			//по адресу картинки
			СохранитьИзФайловойСистемы();
		КонецЕсли;
	Исключение
		Предупреждение("Ошибка при вставке изображения: " + Символы.ПС + ОписаниеОшибки());
	КонецПопытки; 	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзБуфера(СтрокаКартинки)

	ддКартинки = Base64Значение(СтрокаКартинки);
	РегистрыСведений.ФотографииДня.ЗаписатьЗначение(ВыбраннаяДата, ддКартинки, "");
	//ИмяФайлаВФайловойСистеме = КаталогВременныхФайлов()+"врем";
	//ДанныеКартинки.Записать(ИмяФайлаВФайловойСистеме);
	//Элементы.Скриншот.КартинкаЗначений = Новый Картинка(ДанныеКартинки);

КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзФайловойСистемы()
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьВыборФайла", ЭтотОбъект);
	
	ИмяФайла = "";
	ПутьФайла = "";
	НачатьПомещениеФайла(Оповещение, ИмяФайла, ПутьФайла, Истина, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборФайла(Результат, ПутьФайла, ИмяФайла, ДополнительныеПараметры) Экспорт

	Если НЕ Результат Тогда Возврат КонецЕсли; 
	
	//проверим, что файл существует и выбрали картинку допустимого формата
	ВыбранныйФайл = Новый Файл(ИмяФайла);
	Если ВыбранныйФайл.Существует() Тогда
		стрДопустимыеФорматыКартинок = ".jpg; .jpeg; .png";
		стрРасширениеФайла = ВыбранныйФайл.Расширение;
		Если СтрНайти(стрДопустимыеФорматыКартинок, стрРасширениеФайла) = 0 Тогда
			Сообщить("Выбрать можно только: "+стрДопустимыеФорматыКартинок);
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	
	УстановитьКартинку(ПутьФайла);
КонецПроцедуры
   
&НаСервере
Процедура УстановитьКартинку(ПутьФайла)
	
	Описание = "";
	ддКартинка = ПолучитьИзВременногоХранилища(ПутьФайла);
	РегистрыСведений.ФотографииДня.ЗаписатьЗначение(ВыбраннаяДата, ддКартинка, Описание);//Справочники.Файлы.СоздатьЭлемент();
	//удалим из временного хранилища
	Если ЭтоАдресВременногоХранилища(ПутьФайла) Тогда
        УдалитьИзВременногоХранилища(ПутьФайла);
	КонецЕсли;
	
	//Фото = ПоместитьВоВременноеХранилище(НовыйФайлКартинки.Файл.Получить());
	//записываем новый элемент справочника Файлы
	//НовыйФайлКартинки.Записать();
	
	//устанавливаем значение реквизита Картинка Справочника Сотрудники
	//Объект.Картинка = НовыйФайлКартинки.Ссылка;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФото(Команда)
	//ПоказатьФотоНаСервере();
	//картинки
	Попытка
	
		ОтобразитьКартинкиВыбранногоДня();
	
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки; 
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьФотоНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры
