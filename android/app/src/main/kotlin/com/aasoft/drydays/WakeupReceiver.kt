package com.aasoft.drydays

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class WakeupReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("DryDays", "WakeupReceiver triggered!")

        // Burada BLE taramasını tetikleyebilir ya da Flutter MethodChannel ile haber verebilirsin.
        // Şimdilik sadece uyanmayı tetikliyoruz.
    }
}