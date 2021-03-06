﻿
&НаКлиенте
Процедура ВыполнитьПарсинг(Команда)
	//чистим от символов разметки
	пВыход = СтрЗаменить(Объект.Вход, " --> ", Символы.ПС);
	чСтрок = СтрЧислоСтрок(пВыход);
	Для н = 1 по чСтрок Цикл
		стр = СтрПолучитьСтроку(пВыход, н);
		Попытка
		
			стр = Число(Лев(стр, 1));
			пВыход = СтрЗаменить(пВыход, стр, "");
			
		
		Исключение
		
		КонецПопытки; 
    	
	КонецЦикла;	
	Объект.Выход = СтрЗаменить(пВыход, "::,", "");
	
	//
	Объект.Таблица.Очистить();
	чСтрок = СтрЧислоСтрок(Объект.Выход);
	мсв = Новый Массив;
	Для н = 1 по чСтрок Цикл
		стр = СтрПолучитьСтроку(Объект.Выход, н);
		Если ЗначениеЗаполнено(стр) Тогда
			стр = СокрЛП(стр);
			Если СтрЗаканчиваетсяНа(стр, ".") 
				ИЛИ СтрЗаканчиваетсяНа(стр, "!")
				ИЛИ СтрЗаканчиваетсяНа(стр, "?") Тогда
				
				мсв.Добавить(стр);
				//добавим строку в таблицу
				СтрокаВТаблицу = СтрСоединить(мсв, " ");
				НоваяСтрока = Объект.Таблица.Добавить();
				НоваяСтрока.СтрокаАнгл = СтрокаВТаблицу;
				мсв.Очистить();
				//добавим слово в таблицу
				мсвСлов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаВТаблицу, " ", Истина);
				Для каждого Эл Из мсвСлов Цикл
					Отбор = Новый Структура("СловоАнгл", Эл);
					Если Объект.СписокСлов.НайтиСтроки(Отбор).Количество() = 0 Тогда
					
						НовоеСлово = Объект.СписокСлов.Добавить();
						НовоеСлово.СловоАнгл = Эл;
					
					КонецЕсли; 
				
				КонецЦикла; 
			Иначе
			    мсв.Добавить(стр);
			
			КонецЕсли; 
		
		Иначе
		
			
		
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СписокСловСловоРусПриИзменении(Элемент)
	//ТекДанные = Элементы.СписокСлов.ТекущиеДанные;
	//
	//СловоАнгл = ТекДанные.СловоАнгл;
	//СловоРус = ТекДанные.СловоРус;
	
	ПодставитьСловаАнгл();
	
	//Для каждого ТекСтрока Из Объект.Таблица Цикл
	//	ТекФраза = ТекСтрока.СтрокаАнгл;
	//	
	//    мсвСлов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекСтрока.СтрокаАнгл, " ", Истина);
	//	Для каждого Эл Из мсвСлов Цикл
	//		
	//		Отбор = Новый Структура("СловоАнгл", Эл);
	//		мсв = Объект.СписокСлов.НайтиСтроки(Отбор);
	//		Попытка
	//		
	//			СловоРус = мсв[0].СловоРус;
	//			СловоАнгл  = мсв[0].СловоАнгл;
	//			Если СловоРус = "" Тогда
	//			
	//				СловоРус = "...";
	//			
	//			КонецЕсли; 
	//		
	//		Исключение
	//			СловоРус = "...";
	//		КонецПопытки; 
	//		
	//		//ТекСтрока
	//		ТекФраза = СтрЗаменить(ТекФраза, СловоАнгл+", ", СловоРус+" ");
	//		
	//		Если СтрЗаканчиваетсяНа(ТекФраза, ".") Тогда
	//		
	//			ТекФраза = СтрЗаменить(ТекФраза, СловоАнгл, СловоРус+" ");
	//		
	//		Иначе
	//		
	//			ТекФраза = СтрЗаменить(ТекФраза, СловоАнгл+" ", СловоРус+" ");
	//		
	//		КонецЕсли; 
	//		
	//	КонецЦикла;
	//	
	//    ТекСтрока.СтрокаРусАвто = ТекФраза;
	//КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура ПодставитьСловаАнгл()

	Для каждого ТекСтрока Из Объект.Таблица Цикл
		ТекФраза = ТекСтрока.СтрокаАнгл;
		
	    мсвСлов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекСтрока.СтрокаАнгл, " ", Истина);
		Для каждого Эл Из мсвСлов Цикл
			
			Отбор = Новый Структура("СловоАнгл", Эл);
			мсв = Объект.СписокСлов.НайтиСтроки(Отбор);
			Попытка
			
				СловоРус = мсв[0].СловоРус;
				СловоАнгл  = мсв[0].СловоАнгл;
				Если СловоРус = "" Тогда
				
					СловоРус = "...";
				
				КонецЕсли; 
			
			Исключение
				СловоРус = "...";
			КонецПопытки; 
			
			//ТекСтрока
			ТекФраза = СтрЗаменить(ТекФраза, СловоАнгл+", ", СловоРус+" ");
			
			Если СтрЗаканчиваетсяНа(ТекФраза, ".") Тогда
			
				ТекФраза = СтрЗаменить(ТекФраза, СловоАнгл, СловоРус+" ");
			
			Иначе
			
				ТекФраза = СтрЗаменить(ТекФраза, СловоАнгл+" ", СловоРус+" ");
			
			КонецЕсли; 
			
		КонецЦикла;
		
	    ТекСтрока.СтрокаРусАвто = ТекФраза;
	КонецЦикла;
	
КонецПроцедуры
 