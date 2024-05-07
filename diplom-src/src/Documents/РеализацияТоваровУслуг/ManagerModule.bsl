
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
        КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
        КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
        КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
        КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли


#Область СлужебныйПрограммныйИнтерфейс

// Процедура заполняет табличный документ для печати.
//
// Параметры:
//	ТабДок - ТабличныйДокумент - табличный документ для заполнения и печати.
//	Ссылка - Произвольный - содержит ссылку на объект, для которого вызвана команда печати.

Процедура ВКМ_ПечатьАкта(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(ВКМ_ПечатьАкта1)
	Макет = Документы.РеализацияТоваровУслуг.ПолучитьМакет("ВКМ_АктОбУслугах");
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РеализацияТоваровУслуг.Номер,
		|	РеализацияТоваровУслуг.Дата,
		|	РеализацияТоваровУслуг.Организация,
		|	РеализацияТоваровУслуг.Контрагент,
		|	РеализацияТоваровУслуг.Договор,
		|	РеализацияТоваровУслуг.СуммаДокумента,
		|	РеализацияТоваровУслуг.Услуги.(
		|		НомерСтроки,
		|		Номенклатура,
		|		Количество,
		|		Цена,
		|		Сумма)
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	РеализацияТоваровУслуг.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьУслугиШапка = Макет.ПолучитьОбласть("УслугиШапка");
	ОбластьУслуги = Макет.ПолучитьОбласть("Услуги");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	Подписи = Макет.ПолучитьОбласть("Подписи");
	
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ОбластьЗаголовок.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьЗаголовок);
		
		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());	
				
		ТабДок.Вывести(ОбластьУслугиШапка);
		ВыборкаУслуги = Выборка.Услуги.Выбрать();
		Пока ВыборкаУслуги.Следующий() Цикл
			ОбластьУслуги.Параметры.Заполнить(ВыборкаУслуги);
			ТабДок.Вывести(ОбластьУслуги, ВыборкаУслуги.Уровень());
		КонецЦикла;
		
		ФормСтрока = "Л = ru_RU; ДП = Истина";
		ПарамПредмИсчисления="рубль,рубля,рублей,м,копейка,копейки,копеек,ж,2";
		СуммаДокументаПрописью = ЧислоПрописью(Выборка.СуммаДокумента, ФормСтрока, ПарамПредмИсчисления);
		Подвал.Параметры.Заполнить(Выборка);
		Подвал.Параметры.Установить(1, СуммаДокументаПрописью);
		ТабДок.Вывести(Подвал);	
		
		ТабДок.Вывести(Подписи);	
		
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры

#КонецОбласти
