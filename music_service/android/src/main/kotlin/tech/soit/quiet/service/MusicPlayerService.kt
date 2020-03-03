package tech.soit.quiet.service

import android.app.PendingIntent
import android.content.Intent
import android.os.Bundle
import android.os.IBinder
import android.support.v4.media.MediaBrowserCompat
import android.support.v4.media.session.MediaSessionCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.media.MediaBrowserServiceCompat
import tech.soit.quiet.player.MusicPlayerSessionImpl
import tech.soit.quiet.receiver.BecomingNoisyReceiverAdapter
import tech.soit.quiet.utils.LoggerLevel
import tech.soit.quiet.utils.log

class MusicPlayerService : MediaBrowserServiceCompat(), LifecycleOwner {

    companion object {
        const val ACTION_MUSIC_PLAYER_SERVICE = "tech.soit.quiet.session.MusicSessionService"
    }

    private val lifecycle = LifecycleRegistry(this)

    override fun getLifecycle(): Lifecycle = lifecycle

    private val playerSession by lazy { MusicPlayerSessionImpl(this) }

    private val mediaSession by lazy {
        val sessionIntent = packageManager?.getLaunchIntentForPackage(packageName)
        if (sessionIntent == null) {
            log(level = LoggerLevel.ERROR) { "application do not have launcher intent ??" }
        }
        return@lazy MediaSessionCompat(this, "MusicService").also { mediaSession ->
            sessionIntent?.let {
                mediaSession.setSessionActivity(PendingIntent.getActivity(this, 0, it, 0))
            }
            mediaSession.isActive = true
        }
    }


    override fun onCreate() {
        super.onCreate()
        lifecycle.markState(Lifecycle.State.CREATED)
        sessionToken = mediaSession.sessionToken
        mediaSession.setCallback(MediaSessionCallbackAdapter(playerSession))
        playerSession.addCallback(MusicSessionCallbackAdapter(mediaSession))
        playerSession.addCallback(BecomingNoisyReceiverAdapter(this, playerSession))
        val notificationAdapter = NotificationAdapter(this, playerSession, mediaSession)
        playerSession.addCallback(notificationAdapter)
        lifecycle.addObserver(notificationAdapter)
    }

    override fun onBind(intent: Intent?): IBinder? {
        if (intent?.action == ACTION_MUSIC_PLAYER_SERVICE) {
            return playerSession.asBinder()
        }
        return super.onBind(intent)
    }


    override fun onLoadChildren(
        parentId: String,
        result: Result<MutableList<MediaBrowserCompat.MediaItem>>
    ) {
        result.sendResult(mutableListOf())
    }

    override fun onGetRoot(
        clientPackageName: String,
        clientUid: Int,
        rootHints: Bundle?
    ): BrowserRoot? {
        return BrowserRoot("ROOT", null)
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        playerSession.stop()
    }

    override fun onDestroy() {
        lifecycle.markState(Lifecycle.State.DESTROYED)
        mediaSession.isActive = false
        mediaSession.release()
        playerSession.destroy()
        super.onDestroy()
    }


}