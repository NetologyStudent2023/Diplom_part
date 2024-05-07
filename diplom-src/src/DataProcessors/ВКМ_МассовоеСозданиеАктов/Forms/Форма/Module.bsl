
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокументы(Команда)
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.Интервал = 1;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОповещениеОЗавершении", ЭтотОбъект);
	Месяц = Месяц(Объект.Период);
	ДлительнаяОперация = СоздатьДокументыНаСервере(Месяц);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СоздатьДокументыНаСервере(Месяц)
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(УникальныйИдентификатор, 
						 "Обработки.ВКМ_МассовоеСозданиеАктов.СоздатьДокументыАкты", Месяц);
	Возврат ДлительнаяОперация;
КонецФункции

&НаКлиенте
Процедура ОповещениеОЗавершении(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Выполнено" Тогда 
		
		МассивДанных = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		Для Каждого Элемент Из МассивДанных Цикл
			
			НоваяСтрока = Объект.ТЧ.Добавить();
			НоваяСтрока.Договор = Элемент.Договор;
			НоваяСтрока.СсылкаНаДокументРеализация = Элемент.Документ;
			
		КонецЦикла;
		
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
