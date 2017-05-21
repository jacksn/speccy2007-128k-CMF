## Speccy 2007

Клон ZX Spectum 48 выполненный в духе минимализма. Функции ULA
выполняет плис EPM7128SLC84. Предусмотренны такие входы - ps2 клава, SD/MMC
карточка (для загрузки tzx, tap, sna файлов) и выходы - RGB и звук на скарт
телика. Не предусмотренно подключение какой либо другой периферии (в т.ч. и
обычного магитофона, дисковода, джойстика). Питание осуществляется от внешнего
источника питания 5В.

##### Совместимость с фирменным ZX Spectum 48 не полная.
  1. добавление WAIT при опросе порта 0xfe (сейчас WAIT добавляется при таких условиях - нажата клавиша, включена "лента", иначе без вейта).
  2. порт 0xff - нету, не помещается в EPM7128.

##### Список прошивок
    29C020 - прошивка /rom/speccy2007_v102.rom (содержит в себе три прошивки
		48.rom - фирменная прошивка (используется по умолчанию)
		48_sydpatch.rom - прошивка с патчем для загрузки/отгрузки снапов
		48_TURBO.ROM - улучшенная версия фирменной прошивки)

	EPM7128SLC84 - прошивка /cpld/speccy2007.pof

	ATmega16 - прошивка /avr/defautl/speccy2007.hex
		перед прошивкой нужно установить фузы
		CKSEL=0000 SUT=00 (Ext.clock)
		JTAGEN=1 (unprogrammed) (JTAG disabled)

	на SD/MMC (поддерживается только файловая система FAT16) записываются
	файлы tzx, tap, sna (можно использовать каталоги)
	в корневой каталог необходимо записать файл boot.sna
	(находится здесь /z80/boot/tap/boot.sna),
	который содержит снап минишела (запускается клавишей F12)

#### Инструкция по эксплуатации

##### 1. Функциональные клавиши

	L.Ctrl + R.Ctrl - reset.
	L.Ctrl + R.Alt - смена прошивка (ROM1 = 0 / ROM1 = 1).

	F1/F2 - вкл/выкл режима "tape_precise" (в этом режиме, при загрузке tap/tzx
			файлов длительность импульсов корректируется с учетом задержек,
			вызванных wait`ом. это устраняет сбои, при загрузке некоторых tzx
			файлов, но несколько искажает звук загрузки - частота меняется в
			зависимоси от интенсивности опроса порта магнитофона)
			при старте режим выключен.

	F3/F4 - выкл/вкл режима "nowait" (в этом режиме, плис генерирует wait при
			опросе порта 0xfe только если нажата клавиша или включена загрузка
			tap/tzx. это приводит к тому, что когда не происходит зарузка и не
			нажата клавиша не генерируется доп wait и тайминги макс соотетствуют
			фирменному спеку. при работе с портом 0x1f wait генерируется всегда)
			при старте режим включен.

	F5/F6 - вкл/выкл режима "sinclair_joystick" - в этом режиме клавиши со
			стрелочками и L.Ctrl эмулируют kempston + sinclair joystick (если
			выключен - только kempston)
			при старте режим выключен.

	F9 (или Pause/Break) - пауза

	F11 - отгрузка снапа, снап создается в корневом каталоге карточки, имеет
			имя snap01.sna - snap99.sna
	F12 - NMI (если используется прошивка 48_sydpatch.rom то это приводит к
			загрузке boot.sna с корневого каталога карточки)

	"+" - старт загрузки выбранного tap/tzx на нормальной скорости
	"-" - остановить/возобновить загрузку

	"enter" на цифровой клавиатуре или '\' - старт загрузки выбранного tap/tzx
			на удвоенной скорости (для прошивки 48_TURBO.ROM)

	L.Shift - CS
	R.Shift - SS

	стрелки на цифровой клавиатуре - CS + 5,6,7,8
	"backspace" - CS + 0

	стрелки + L.Ctrl - эмуляция джойстика

2. Загрузка програм

	F12 -> AVR дает NMI -> прошивка через порт 0x1f грузит с карты boot.sna ->
	boot.sna лазит по карте, позволяет выбрать для загрузки любой
	записанный tap, tzx, sna. если выбран sna загрузка производится сразу,
	если tap\tzx производится ресет, потом набираем load "", потом для
	включения пленки "+", для выключения "-".

3. Отгрузка снапа

	F11 -> AVR открывает для записи файл на карточке и дает NMI -> прошивка
	через порт 0x1f скидывает дамп в созданный файл.

	Для загрузки/отгрузки снапов необходимо, чтобы регист SP использовался
	по назначению, и что бы в стеке было 2 байта для сохранения PC.
	Нужно быть готовым что при загрузке/отгрузке снапов будет испорченно
	32 байта экранной области (нижняя строка - адреса 0x57e0 - 0x57ff)

4. А запись TAP реализована?

	для записи TAP файлов нужно сигнал tape_out c плис завести на avr`ку
	(чем-то пожертвовав) и доработать прошивку аврки. но не факт, что влезет
	в mega16.

5. Небольшое описание некоторых сигналов и работы

	1. TAPE_IN - сигнал загрузки, на плисе просто смешивается с SOUND_OUT (порт
		0xfe, бит 4) и выводится наружу (SOUND на плисе). В Z80 сигнал загрузки
		попадает другим способом (при опросе порта 0xfe).
	2. AVR_NOINT - если по этому порту авр выдает лог "1", значит прерываться
		на опрос 0xfe не нужно (z80 мирно читает с шины данный 0xff и все
		довольны), если "0" то, по приходу запроса на чтение порта 0xfe, Z80
		останавливается, и плис генерирует AVR_INT. Дальше авр читает состояние
		A8-A14, выставляет на шине данных нужный ответ и устанавливает AVR_WAIT
		в "0". Это значит что плис отпускает WAIT (Z80) до тех пор, пока
		IOREQ = '0'. Потом Z80 снова останавливается, авр делает
		AVR_WAIT -> "1" и Z80 запускается окончательно до следующего запроса.
		С портом 0x1f все так же, только AVR_NOINT не влияет на генерирование
		AVR_INT (AVR_INT генерируется всегда).

6. Команды минишела

	стрелки + Enter - выбор и загрузка програм с карточки
	SS + 'd' - удалить файл
	SS + 'r' - переименовать файл


#### History

  1.00 - Первая стабильная версия
  1.01 - Много изменений в VHDL коде - улучшена стабильность на разных процессорах.
  1.02 - Изменения в минишеле, коде аврки, патче прошивки спектрума
		1. сделана выгрузка снапов
		2. теперь используеться немодифицированная фирменная прошивка спектрума
			во время работы, модифицированная только во время загрузки/выгрузки
			снапов
  1.03 - Изменения только в коде АВР - добавленна пауза и упрвление тапами
		клавишами основной клавиатуры, теперь используеться WinAVR-20071221
