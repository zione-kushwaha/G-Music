package com.example.music

import android.Manifest
import android.content.ContentUris
import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.database.Cursor
import android.provider.MediaStore
import android.content.pm.PackageManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.content.ContentValues

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.myapp/ringtone"
    private var currentUriString: String? = null

    companion object {
        const val WRITE_SETTINGS_REQUEST_CODE = 200
    }

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setRingtone" -> {
                    val uriString = call.argument<String>("uri")
                    currentUriString = uriString
                    if (hasWriteSettingsPermission()) {
                        val success = uriString?.let { setRingtone(it) }
                        result.success(success)
                    } else {
                        requestWriteSettingsPermission()
                        result.error("PERMISSION_REQUIRED", "The WRITE_SETTINGS permission is required.", null)
                    }
                }
                "deleteSong" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString != null) {
                        val success = deleteSong(uriString)
                        result.success(success)
                    } else {
                        result.error("INVALID_URI", "The URI is null.", null)
                    }
                }
                "changeSongTitle" -> {
                    val uriString = call.argument<String>("uri")
                    val newTitle = call.argument<String>("newTitle")
                    if (uriString != null && newTitle != null) {
                        val success = changeSongTitle(uriString, newTitle)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENTS", "The URI or new title is null.", null)
                    }
                }
                "requestWriteSettingsPermission" -> {
                    requestWriteSettingsPermission()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == WRITE_SETTINGS_REQUEST_CODE) {
            if (hasWriteSettingsPermission()) {
                currentUriString?.let { setRingtone(it) }
                // Handle the success status...
            } else {
                // Permission has not been granted, handle the error...
            }
        }
    }

    private fun setRingtone(uriString: String): Boolean {
        val uri = Uri.parse(uriString)
        val ringtone = RingtoneManager.getRingtone(this, uri)
        if (ringtone == null) {
            Log.e("RingtoneManager", "Ringtone not found at URI: $uri")
            return false
        }
        if (!hasWriteSettingsPermission()) {
            Log.e("RingtoneManager", "App does not have permission to write settings")
            return false
        }
        RingtoneManager.setActualDefaultRingtoneUri(this, RingtoneManager.TYPE_RINGTONE, uri)
        return true
    }

    private fun deleteSong(uriString: String): Boolean {
        val uri = Uri.parse(uriString)
        val id = uri.lastPathSegment?.toLongOrNull()
        if (id != null) {
            val contentUri = ContentUris.withAppendedId(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, id)
            val rowsDeleted = contentResolver.delete(contentUri, null, null)
            return rowsDeleted > 0
        } else {
            Log.e("MainActivity", "Invalid URI: $uri")
            return false
        }
    }

    private fun hasWriteSettingsPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.System.canWrite(this)
        } else {
            true
        }
    }

    private fun requestWriteSettingsPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS)
            intent.data = Uri.parse("package:$packageName")
            startActivityForResult(intent, WRITE_SETTINGS_REQUEST_CODE)
        }
    }

    private fun changeSongTitle(uriString: String, newTitle: String): Boolean {
        if (!hasWriteExternalStoragePermission()) {
            Log.e("MainActivity", "Write external storage permission is required.")
            requestStoragePermissions()
            return false
        }

        val uri = Uri.parse(uriString)
        val id = uri.lastPathSegment?.toLongOrNull()
        if (id != null) {
            val contentUri = ContentUris.withAppendedId(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, id)
            Log.d("MainActivity", "Content URI: $contentUri")

            val values = ContentValues().apply {
                put(MediaStore.Audio.Media.TITLE, newTitle)
            }

            val rowsUpdated = contentResolver.update(contentUri, values, null, null)
            if (rowsUpdated > 0) {
                Log.d("MainActivity", "Successfully updated song title.")
                return true
            } else {
                Log.e("MainActivity", "Failed to update song title. Rows updated: $rowsUpdated")
                return false
            }
        } else {
            Log.e("MainActivity", "Invalid URI: $uri")
            return false
        }
    }

    private fun getAlbumArt(uriString: String): Uri? {
        val uri = Uri.parse(uriString)
        val id = uri.lastPathSegment?.toLongOrNull()
        if (id != null) {
            val contentUri = ContentUris.withAppendedId(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, id)
            val cursor: Cursor? = contentResolver.query(contentUri, arrayOf(MediaStore.Audio.Albums.ALBUM_ART), null, null, null)
            if (cursor?.moveToFirst() == true) {
                val albumArtUriString = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Albums.ALBUM_ART))
                cursor.close()
                return Uri.parse(albumArtUriString)
            } else {
                Log.e("MainActivity", "Failed to get album art. Cursor is null or empty.")
                cursor?.close()
            }
        } else {
            Log.e("MainActivity", "Invalid URI: $uri")
        }
        return null
    }

    private fun hasWriteExternalStoragePermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
    }

    private fun requestStoragePermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE), WRITE_SETTINGS_REQUEST_CODE)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            WRITE_SETTINGS_REQUEST_CODE -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Log.d("MainActivity", "Storage permissions granted.")
                    currentUriString?.let { setRingtone(it) }
                } else {
                    Log.e("MainActivity", "Storage permissions denied.")
                }
            }
        }
    }
}