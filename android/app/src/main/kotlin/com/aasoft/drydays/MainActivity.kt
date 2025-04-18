package com.aasoft.drydays

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Bundle
import android.os.SystemClock
import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.util.Log

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        scheduleWakeUp()
    }

    private fun scheduleWakeUp() {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, WakeupReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)

        // 10 saniyede bir uyanmak için
        val interval: Long = 10 * 1000

        alarmManager.setRepeating(
            AlarmManager.ELAPSED_REALTIME_WAKEUP,
            SystemClock.elapsedRealtime() + interval,
            interval,
            pendingIntent
        )

        Log.d("DryDays", "Wakeup alarm scheduled every 10 seconds.")
    }
}
