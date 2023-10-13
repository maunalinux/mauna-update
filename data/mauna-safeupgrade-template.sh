#!/bin/bash

set +e

rm -f /system-update

message="System is upgrading, please don't turn off machine ..."
upmessage="Upgrading"
if [[ $LANG == "pt_BR.UTF-8" ]]; then
    message="O sistema está sendo atualizado, por favor não desligue a máquina ..."
    upmessage="Atualizando"
elif [[ $LANG == "pt.UTF-8" ]]; then
    message="O sistema está a ser actualizado, por favor não desligue a máquina ..."
    upmessage="Actualizando"
elif [[ $LANG == "af_ZA.UTF-8" ]]; then
    message="Stelsel is besig om op te gradeer, moet asseblief nie die masjien afskakel nie ..."
    upmessage="Opgradering"    
elif [[ $LANG == "ar.UTF-8" ]]; then
    message="يتم ترقية النظام، يرجى عدم إيقاف تشغيل الجهاز ..."
    upmessage="الترقية" 
elif [[ $LANG == "ca_ES.UTF-8" ]]; then
    message="El sistema s'està actualitzant, no apagueu la màquina ..."
    upmessage="Actualització"  
elif [[ $LANG == "da_DK.UTF-8" ]]; then
    message="Systemet er ved at opgradere, sluk venligst ikke maskinen ..."
    upmessage="Opgradering"
elif [[ $LANG == "de.UTF-8" ]]; then
    message="Das System wird aktualisiert, bitte schalten Sie das Gerät nicht aus ..."
    upmessage="Upgrade durchführen"                    
elif [[ $LANG == "es.UTF-8" ]]; then
    message="El sistema se está actualizando, no apague la máquina ..."
    upmessage="Actualizando" 
elif [[ $LANG == "eu_ES.UTF-8" ]]; then
    message="Sistema berritzen ari da, mesedez ez itzali makina ..."
    upmessage="Berritzea"    
elif [[ $LANG == "fr_CA.UTF-8" ]]; then
    message="Le système est en cours de mise à niveau, s’il vous plaît ne pas éteindre la machine ..."
    upmessage="Mise à niveau"
elif [[ $LANG == "fr.UTF-8" ]]; then
    message="Le système est en cours de mise à niveau, veuillez ne pas éteindre la machine ..."
    upmessage="Mise à niveau"  
elif [[ $LANG == "he_EL.UTF-8" ]]; then  
    message="המערכת משתדרגת, נא לא לכבות את המחשב ..."
    upmessage="משדרג"
elif [[ $LANG == "hi_IN.UTF-8" ]]; then  
    message="सिस्टम अपग्रेड हो रहा है, कृपया मशीन बंद न करें ..."
    upmessage="उन्नयन"
elif [[ $LANG == "id_ID.UTF-8" ]]; then  
    message="Sistem sedang ditingkatkan, mohon jangan matikan mesin ..."
    upmessage="Perbaikan"
elif [[ $LANG == "it_IT.UTF-8" ]]; then  
    message="Il sistema è in aggiornamento, non spegnere la macchina ..."
    upmessage="Aggiornamento"
elif [[ $LANG == "ja_JP.UTF-8" ]]; then  
    message="システムをアップグレード中です。マシンの電源を切らないでください ..."
    upmessage="アップグレード中"
elif [[ $LANG == "ko_KR.UTF-8" ]]; then  
    message="시스템이 업그레이드 중입니다. 컴퓨터를 끄지 마십시오 ..."
    upmessage="업그레이드 중"                      
elif [[ $LANG == "tr_TR.UTF-8" ]]; then
    message="Sistem güncelleniyor, lütfen makineyi kapatmayın ..."
    upmessage="Güncelleniyor"
elif [[ $LANG == "zh_CN.UTF-8" ]]; then  
    message="系统正在升级，请勿关机 ..."
    upmessage="升级中"
elif [[ $LANG == "zh_HK.UTF-8" ]]; then  
    message="系統正在升級，請勿關機 ..."
    upmessage="升級中"     
elif [[ $LANG == "zh_SG.UTF-8" ]]; then  
    message="系统正在升级，请勿关机 ..."
    upmessage="升级中"
elif [[ $LANG == "zh_TW.UTF-8" ]]; then  
    message="系統正在升級，請勿關機 ..."
    upmessage="升級中"               
fi

echo "$(date) - Mauna safe upgrade is starting" >> /var/log/mauna-upgrade.log

plymouth display-message --text="$message"

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
source /etc/profile

# block upgrade b43 and mscorefonts
apt-mark hold firmware-b43-installer
apt-mark hold firmware-b43legacy-installer
apt-mark hold ttf-mscorefonts-installer
echo 'libc6 libraries/restart-without-asking boolean true' | debconf-set-selections
apt -fuyq  install ./var/cache/apt/archives/*.deb \
    --no-download \
    -o Dpkg::Options::="@@askconf@@" \
    --allow-downgrades \
    --allow-change-held-packages \
    -o APT::Status-Fd=1 | while read line; do
        echo $line >> /var/log/mauna-upgrade.log
        echo $line > /dev/console
        if echo $line | grep "pmstatus" > /dev/null
        then
            numberr=`echo $line | cut -d":" -f3`
            plymouth display-message --text="$upmessage: ${numberr%??}%"
        fi
    done
apt-mark unhold firmware-b43-installer
apt-mark unhold firmware-b43legacy-installer
apt-mark unhold ttf-mscorefonts-installer

reboot -f
