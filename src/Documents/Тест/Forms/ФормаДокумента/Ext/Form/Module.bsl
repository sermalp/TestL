﻿&НаКлиенте
Перем КомпонентБО;
&НаКлиенте
Перем ИмяБиблиотекиClipboard;

&НаКлиенте
Процедура Вставить(Команда)
	Попытка
		СтрокаКартинки = КомпонентБО.ПолучитьКартинкуИзБуфераОбмена(); 
		Если ЗначениеЗаполнено(СтрокаКартинки) Тогда
			ДанныеКартинки = Base64Значение(СтрокаКартинки);
			ИмяФайлаВФайловойСистеме = КаталогВременныхФайлов()+"врем";
			ДанныеКартинки.Записать(ИмяФайлаВФайловойСистеме);
			//Элементы.Скриншот.КартинкаЗначений = Новый Картинка(ДанныеКартинки);
			
			
			АдресВоВременномХранилище = "";
			ПоместитьФайл(АдресВоВременномХранилище, ИмяФайлаВФайловойСистеме, , Ложь);
			Скриншот = АдресВоВременномХранилище;
			УстановитьКартинку();
		КонецЕсли;
	Исключение
		Предупреждение("Ошибка при вставке изображения из буфера: " + Символы.ПС + ОписаниеОшибки());
	КонецПопытки; 	
	ВставитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинку()
	
	//ПолучитьНавигационнуюСсылку(Объект.Ссылка, "Картинка");
	сп = РеквизитФормыВЗначение("Объект");// сп - элемент справочника
	сп.Картинка = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Скриншот));
	сп.Записать();
КонецПроцедуры

&НаСервере
Процедура ВставитьНаСервере()
	//Объект=Новый ("Addin.Clipboard");
	//Нечто=Объект.ПолучитьИзБуфераОбмена(2);//Получаем буфер обмена. Если картинка - то в формате (1) - jpg, (2) - bmp
	//
	//Если ТипЗнч(Нечто)<>Тип("Картинка") Тогда
	//	Сообщить("В буфере обмена нет картинки!",СтатусСообщения.Важное);
	//	Возврат;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
// проверка наличия библиотеки Clipboard
	ИмяФайла = КаталогПрограммы() + ИмяБиблиотекиClipboard;
	Файл = Новый Файл(ИмяФайла);
	Если Не Файл.Существует() Тогда
		ИзвлечьИЗаписатьБиблиотеку(ИмяФайла);
	КонецЕсли;
	
	Попытка
		//ПодключитьВнешнююКомпоненту(ИмяФайла);
		ПодключитьВнешнююКомпоненту("AddIn.clipboard");
		//ЗагрузитьВнешнююКомпоненту(ИмяФайла);
		Попытка
			КомпонентБО = Новый("AddIn.clipboard");
		Исключение
			Сообщить("Не удалось создать объект компоненты " + ИмяБиблиотекиClipboard, СтатусСообщения.Важное);
		КонецПопытки;	
	Исключение
		Сообщить("Компонента " + ИмяБиблиотекиClipboard + " не найдена!", СтатусСообщения.Важное);
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ИзвлечьИЗаписатьБиблиотеку(ИмяФайла)
	
	Попытка
		Библиотека = ПолучитьМакетНаСервере();
		Библиотека.Записать(ИмяФайла);
	Исключение
		Сообщить("Ошибка при записи файла: " + ИмяФайла + Символы.ПС
						+ ОписаниеОшибки() + "
						|Файл не записан.
						|Возможно у вас отсутствуют права доступа к папке. Обратитесь к администратору.", СтатусСообщения.Важное);
	КонецПопытки;
			
КонецПроцедуры	

&НаСервере
Функция ПолучитьМакетНаСервере()

	Возврат Документы.Тест.ПолучитьМакет("clipboard_dll");

КонецФункции
 
ИмяБиблиотекиClipboard = "clipboard.dll";
