﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("СпособУстановкиКурса");
	Результат.Добавить("Наценка");
	Результат.Добавить("ОсновнаяВалюта");
	Результат.Добавить("ФормулаРасчетаКурса");
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Загрузка данных из файла

// Запрещает загрузку данных в этот справочник из подсистемы "ЗагрузкаДанныхИзФайла".
// Т.к. справочник реализует свой метод обновления данных.
//
Функция ИспользоватьЗагрузкуДанныхИзФайла() Экспорт
	Возврат Ложь;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Код = ""643""
	|	И Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Отключает у валюты 643 загрузку из интернета.
Процедура ОтключитьЗагрузкуКурсаВалюты643ИзИнтернета(Параметры) Экспорт
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.Валюты");
	Пока Выборка.Следующий() Цикл
		Валюта = Выборка.Ссылка.ПолучитьОбъект();
		Валюта.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Валюта);
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.Валюты");
КонецПроцедуры

#КонецОбласти

#КонецЕсли