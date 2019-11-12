package com.firebase.androidcodebattle

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.ViewGroup
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import coil.api.load
import com.firebase.androidcodebattle.util.CameraUtil
import com.firebase.androidcodebattle.util.FileUtil
import com.firebase.androidcodebattle.util.ResizeUtil
import com.firebase.androidcodebattle.util.RotateUtil
import com.google.android.gms.tasks.Task
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.firestore.FieldValue
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.StorageMetadata
import com.google.firebase.storage.UploadTask
import kotlinx.android.synthetic.main.activity_main.*
import org.koin.android.ext.android.inject
import java.io.File


class MainActivity : AppCompatActivity() {
    companion object {
        private const val FIRESTORE_COLLECTION = "code-battle-2019"
        private const val DEFAULT_FILENAME = "awesome_picture_"
        private const val EXTRA_FILE_PATH = "extra_file_path"
    }

    private val storage: FirebaseStorage by inject()
    private val firestore: FirebaseFirestore by inject()
    private val fileUtil: FileUtil by inject()
    private val cameraUtil: CameraUtil by inject()
    private val resizeUtil: ResizeUtil by inject()
    private val rotateUtil: RotateUtil by inject()

    private var filePath: String? = null
    private var snackbar: Snackbar? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        imageViewPreviewImage.setOnClickListener { openCamera() }
        buttonShare.setOnClickListener { sharePost() }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putString(EXTRA_FILE_PATH, filePath)
    }

    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)
        filePath = savedInstanceState.getString(EXTRA_FILE_PATH)
        filePath?.let { setImageFromFile(File(it)) }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        cameraUtil.onActivityResult(requestCode, resultCode, data)
    }

    private fun openCamera() {
        cameraUtil.openCamera(this, fileUtil.createImageFile(DEFAULT_FILENAME)) { file ->
            this.filePath = resizeUtil.resize(rotateUtil.rotateImage(file))?.absolutePath
            setImageFromFile(file)
        }
    }

    private fun sharePost() {
        if (validateInput()) {
            disableUiState()
            showUploading()
            filePath?.let { uploadImageToStorage(File(it)) }
        }
    }

    private fun validateInput(): Boolean {
        val caption = editTextCaption.text
        if (filePath == null) {
            showInvalidImage()
            return false
        } else if (caption.isNullOrEmpty()) {
            showInvalidCaption()
            return false
        }
        return true
    }

    private fun uploadImageToStorage(file: File?) {
        val filename = "Android_${System.currentTimeMillis()}.jpg"
        val uri = Uri.fromFile(file)

        // TODO Create the reference and upload an image to Firebase Storage
        val reference = storage.reference.child(filename)
        val metadata = StorageMetadata.Builder().apply {
            contentType = "image/jpg"
        }.build()
        reference.putFile(uri, metadata)
            .continueWithTask { task: Task<UploadTask.TaskSnapshot> ->
                if (!task.isSuccessful) {
                    throw task.exception!!
                }
                reference.downloadUrl
            }.addOnCompleteListener { task: Task<Uri> ->
                val url = task.result.toString()
                onUploadImageSuccess(url)
            }.addOnFailureListener {
                onUploadImageFailure()
            }
    }

    private fun uploadPostToFirestore(imageUrl: String) {
        val caption = editTextCaption.text.toString()

        // TODO Create the data and send to Firebase Firestore
        val post = hashMapOf(
            "caption" to caption,
            "imageUrl" to imageUrl,
            "status" to false,
            "timestamp" to FieldValue.serverTimestamp()
        )
        firestore.collection(FIRESTORE_COLLECTION).add(post)
            .addOnCompleteListener { onUploadPostSuccess() }
            .addOnFailureListener { onUploadPostFailure() }
    }

    private fun showInvalidImage() {
        showSnackbar(getString(R.string.invalid_image))
    }

    private fun showInvalidCaption() {
        showSnackbar(getString(R.string.invalid_caption))
    }

    private fun onUploadPostSuccess() {
        hideUploading()
        showSnackbar(getString(R.string.upload_post_successful))
        enableUiState()
        clearPost()
    }

    private fun onUploadPostFailure() {
        hideUploading()
        showSnackbar(getString(R.string.upload_post_failure))
    }

    private fun onUploadImageSuccess(imageUrl: String) {
        uploadPostToFirestore(imageUrl)
    }

    private fun onUploadImageFailure() {
        hideUploading()
        showSnackbar(getString(R.string.upload_image_failure))
    }

    private fun showUploading() {
        snackbar = showSnackbar(getString(R.string.uploading), Snackbar.LENGTH_INDEFINITE)
    }

    private fun hideUploading() {
        snackbar?.dismiss()
    }

    private fun disableUiState() {
        editTextCaption.isEnabled = false
        buttonShare.isEnabled = false
        imageViewPreviewImage.isEnabled = false
    }

    private fun enableUiState() {
        editTextCaption.isEnabled = true
        buttonShare.isEnabled = true
        imageViewPreviewImage.isEnabled = true
    }

    private fun clearPost() {
        setDefaultImage()
        editTextCaption.setText("")
        filePath = null
    }

    private fun setImageFromFile(file: File) {
        imageViewPreviewImage.load(file)
        imageViewPreviewImage.scaleType = ImageView.ScaleType.CENTER_CROP
    }

    private fun setDefaultImage() {
        imageViewPreviewImage.scaleType = ImageView.ScaleType.CENTER
        imageViewPreviewImage.setImageResource(R.drawable.ic_camera)
    }

    private fun showSnackbar(message: String, duration: Int = Snackbar.LENGTH_SHORT): Snackbar {
        return Snackbar.make(findViewById<ViewGroup>(android.R.id.content), message, duration).apply {
            show()
        }
    }
}
