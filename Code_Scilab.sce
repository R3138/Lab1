// Импортируем файл XCOS для использования
importXcosDiagram("C:\Users\roman\Desktop\Lab1\Scheme_angle.zcos")
typeof(scs_m)

// Очистим файл для полученных значений
deletefile('C:\Users\roman\Desktop\Lab1\values_angle.txt')
deletefile('C:\Users\roman\Desktop\Lab1\values_speed.txt')

// Постоянная: момент инерции ротора
J = 0.0023
        
for i = 100:-20:-100
    if i == 0 then
        continue
    elseif i > 0 then
        j = 1
    else
        j = -1
    end
    
    // Определяем графическое окно для графиков зависимости угла поворота от времени
    scf(0)
    // Очистим графическое окно
    clf()
   
    // Читаем файл, содержащий неизвестное количество строк и 3 столбца
    results = read(".\data" + string(i) + ".txt", -1, 3)

    // Количество строк в матрице results
    qlines = size(results, 1)
    
    // Данные снятые с робота
    time = results(:, 1) 
    angle = results(:, 2) * %pi / 180 // Угол поворота в радианах
    speed = results(:, 3) * %pi / 180 // Угловая скорость в радианах в секунду
    
    // График зависимости угла поворота от времени, полученный на основе эксперимента
    xtitle("График зависимости угла поворота от времени")
    xlabel("time, [sec]")
    ylabel("angle, [rad]")
    xgrid()
    plot2d(time, angle, 2)
    
    // Выполнение аппроксимации зависимости
    aim = [time, angle]'
    deff('e = func(k,z)', 'e = z(2) - k(1) * (z(1) - k(2) * (1 - exp(-z(1) / k(2))))')
    att = [50 * j; 0.06]
    [koeffs, errs] = datafit(func, aim, att)
    // Получим переменные Wnls и Tm
    Wnls = koeffs(1)
    Tm = koeffs(2)
    // По формуле найдем Mst
    Mst = J * Wnls / Tm
    // Запишим полученные данные в файл
    values = mopen('C:\Users\roman\Desktop\Lab1\values_angle.txt', 'at')
        mputl(string(i) + ' ' + string(Wnls) + ' ' + string(Tm) + ' ' + string(Mst), values)
    mclose(values)
    // Построим модель зависимости
    model = Wnls * (time - Tm * (1 - exp(-time / Tm)))
    // График аппроксимирующей кривой
    plot2d(time, model, 3)
    
    // Запустим XCOS
    xcos_simulate(scs_m, 4)
    
    // Построим график по формуле, полученной в XCOS
    plot2d(A.time, A.values, 5)
    
    // Создадим легенду нашего графика
    if j == 1 then 
        legend('Experiment', 'Model', '$\theta(t) = \omega_{nls} \left(t - T_m \left(1 - \exp \left(-\frac{t}{T_m}\right)\right)\right)$', 'in_upper_left')
    elseif j == -1 then
        legend('Experiment', 'Model', '$\theta(t) = \omega_{nls} \left(t - T_m \left(1 - \exp \left(-\frac{t}{T_m}\right)\right)\right)$', 'in_lower_left')
    end
    // Сохраним файл (экспортируем в png)
    xs2png(0, 'C:\Users\roman\Desktop\Lab1\angle' + string(i) + '.png')
    
    // Построим графики в другом окне для общего рисунка
    if j == 1 then
        scf(1)
        xtitle("График зависимости угла поворота от времени")
        xlabel("time, [sec]")
        ylabel("angle, [rad]")
        xgrid()
        plot2d(time, angle, 2)
        plot2d(time, model, 3)
        plot2d(A.time, A.values, 5)
        legend('Experiment', 'Model', '$\theta(t) = \omega_{nls} \left(t - T_m \left(1 - \exp \left(-\frac{t}{T_m}\right)\right)\right)$', 'in_upper_left')
    elseif j == -1 then
        scf(2)
        xtitle("График зависимости угла поворота от времени")
        xlabel("time, [sec]")
        ylabel("angle, [rad]")
        xgrid()
        plot2d(time, angle, 2)
        plot2d(time, model, 3)
        plot2d(A.time, A.values, 5)
        legend('Experiment', 'Model', '$\theta(t) = \omega_{nls} \left(t - T_m \left(1 - \exp \left(-\frac{t}{T_m}\right)\right)\right)$', 'in_lower_left')
    end
    
    
    
    
    // Определяем графическое окно для графиков зависимости угловой скорости от времени
    scf(3)
    // Очистим графическое окно
    clf()
    
    // График зависимости угловой скорости от времени, полученный на основе эксперимента       
    xtitle("График зависимости угловой скорости от времени")
    xlabel("time, [sec]")
    ylabel("speed, [rad/sec]")
    xgrid()
    plot2d(time, speed, 2)
    
    // Выполнение аппроксимации зависимости
    aim = [time, speed]'
    deff('e = func(k,z)', 'e = z(2) - k(1) * (1 - exp(-z(1) / k(2)))')
    att = [50 * j; 0.06]
    [koeffs, errs] = datafit(func, aim, att)
    // Получим переменные Wnls и Tm
    Wnls = koeffs(1)
    Tm = koeffs(2)
    // По формуле найдем Mst
    Mst = J * Wnls / Tm
    // Запишим полученные данные в файл
    values = mopen('C:\Users\roman\Desktop\Lab1\values_speed.txt', 'at')
        mputl(string(i) + ' ' + string(Wnls) + ' ' + string(Tm) + ' ' + string(Mst), values)
    mclose(values)
    // Построим модель зависимости
    model = Wnls * (1 - exp(-time / Tm))
    // График аппроксимирующей кривой
    plot2d(time, model, 3)
    
    // Запустим XCOS
    xcos_simulate(scs_m, 4)
    
    // Построим график по формуле, полученной в XCOS
    plot2d(B.time, B.values, 5)
    
    // Создадим легенду нашего графика
    if j == 1 then 
        legend('Experiment', 'Model', '$\omega(t) = \omega_{nls} \left(1 - \exp \left(-\frac{t}{T_m}\right)\right)$', 'in_lower_right')
    elseif j == -1 then
        legend('Experiment', 'Model', '$\omega(t) = \omega_{nls} \left(1 - \exp \left(-\frac{t}{T_m}\right)\right)$', 'in_upper_right')
    end
    // Сохраним файл
    xs2png(3, 'C:\Users\roman\Desktop\Lab1\speed' + string(i) + '.png')
    
    // Построим графики в другом окне для общего рисунка
    if j == 1 then
        scf(4)
        xtitle("График зависимости угловой скорости от времени")
        xlabel("time, [sec]")
        ylabel("speed, [rad/sec]")
        xgrid()
        plot2d(time, speed, 2)
        plot2d(time, model, 3)
        plot2d(B.time, B.values, 5)
        legend('Experiment', 'Model', '$\omega(t) = \omega_{nls} \left(1 - \exp \left(-\frac{t}{T_m}\right)\right)$', 'in_lower_right')
    elseif j == -1 then
        scf(5)
        xtitle("График зависимости угловой скорости от времени")
        xlabel("time, [sec]")
        ylabel("speed, [rad/sec]")
        xgrid()
        plot2d(time, speed, 2)
        plot2d(time, model, 3)
        plot2d(B.time, B.values, 5)
        legend('Experiment', 'Model', '$\omega(t) = \omega_{nls} \left(1 - \exp \left(-\frac{t}{T_m}\right)\right)$', 'in_upper_right')
    end   
end

// Сохраним файлы общих графиков
xs2png(1, 'C:\Users\roman\Desktop\Lab1\angle_positive.png')
xs2png(2, 'C:\Users\roman\Desktop\Lab1\angle_negative.png')
xs2png(4, 'C:\Users\roman\Desktop\Lab1\speed_positive.png')
xs2png(5, 'C:\Users\roman\Desktop\Lab1\speed_negative.png')

// Построим графики зависимости Wnls и Tm от Votage
res = fscanfMat('C:\Users\roman\Desktop\Lab1\values_angle.txt')
Voltage = res(:,1)
Wnls = res(:,2)
Tm = res(:,3)
scf(6)
xtitle("График зависимости Wnls от voltage")
xlabel("Voltage, %")
ylabel('Wnls, [rad/sec]')
xgrid()
plot2d(Voltage, Wnls, 2)
scf(7)
xtitle("График зависимости Tm от voltage")
xlabel("Voltage, %")
ylabel('Tm, [sec]')
xgrid()
plot2d(Voltage, Tm, 2)

// Сохраним эти графики
xs2png(6, 'C:\Users\roman\Desktop\Lab1\Wnls_angle.png')
xs2png(7, 'C:\Users\roman\Desktop\Lab1\Tm_angle.png')


// Построим графики зависимости Wnls и Tm от Votage
res = fscanfMat('C:\Users\roman\Desktop\Lab1\values_speed.txt')
Voltage = res(:,1)
Wnls = res(:,2)
Tm = res(:,3)
scf(8)
xtitle("График зависимости Wnls от voltage")
xlabel("Voltage, %")
ylabel('Wnls, [rad/sec]')
xgrid()
plot2d(Voltage, Wnls, 2)
scf(9)
xtitle("График зависимости Tm от voltage")
xlabel("Voltage, %")
ylabel('Tm, [sec]')
xgrid()
plot2d(Voltage, Tm, 2)

// Сохраним эти графики
xs2png(8, 'C:\Users\roman\Desktop\Lab1\Wnls_speed.png')
xs2png(9, 'C:\Users\roman\Desktop\Lab1\Tm_speed.png')

