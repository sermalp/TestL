﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает адресатов электронного письма.
//
// Параметры:
//  Ссылка  - ДокументСсылка.ЭлектронноеПисьмоИсходящее - документ, абонента которого необходимо получить.
//
// Возвращаемое значение:
//   ТаблицаЗначений   - таблица, содержащая колонки "Контакт", "Представление" и "Адрес".
//
Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиПисьма КАК ЭлектронноеПисьмоИсходящееПолучателиПисьма
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиКопий КАК ЭлектронноеПисьмоИсходящееПолучателиКопий
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиОтвета КАК ЭлектронноеПисьмоИсходящееПолучателиОтвета
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиСкрытыхКопий КАК ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ТаблицаКонтактов = Запрос.Выполнить().Выгрузить();
	
	Возврат Взаимодействия.ПреобразоватьТаблицуКонтактовВМассив(ТаблицаКонтактов);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Важность");
	Результат.Добавить("Ответственный");
	Результат.Добавить("ВзаимодействиеОснование");
	Результат.Добавить("Комментарий");
	Результат.Добавить("ПолучателиПисьма.Представление");
	Результат.Добавить("ПолучателиПисьма.Контакт");
	Результат.Добавить("ПолучателиКопий.Представление");
	Результат.Добавить("ПолучателиКопий.Контакт");
	Результат.Добавить("ПолучателиОтвета.Представление");
	Результат.Добавить("ПолучателиОтвета.Контакт");
	Результат.Добавить("ПолучателиСкрытыхКопий.Представление");
	Результат.Добавить("ПолучателиСкрытыхКопий.Контакт");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ВзаимодействияВызовСервера.ОбработкаПолученияДанныхВыбора(
		ДанныеВыбора,
		Параметры,
		СтандартнаяОбработка, 
		"ЭлектронноеПисьмоИсходящее");
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

// Регистрирует к обработке электронные письма у которых возможно заполнить ВзаимодействиеОснование.
//
Процедура ЗаполнитьВзаимодействияОснованияУПодчиненныхПисемКОбработке(Параметры) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = Взаимодействия.ТекстЗапросаОтметкиКОбработкиЗаполненияПисемОснований("Документ.ЭлектронноеПисьмоИсходящее");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(
		Параметры,
		Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));

КонецПроцедуры 

// Выполняет дозаполнение реквизита ВзаимодействиеОснование у электронных писем.
//
Процедура ЗаполнитьВзаимодействияОснованияУПодчиненныхПисем(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ЭлектронноеПисьмоИсходящее";
	МетаданныеДокумента = Метаданные.Документы.ЭлектронноеПисьмоИсходящее;
	
	Взаимодействия.ЗаполнитьВзаимодействияОснованияУПодчиненныхПисем(Параметры, ПолноеИмяДокумента, МетаданныеДокумента);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
