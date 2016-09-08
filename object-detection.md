## Tuning Object Detection

Tuning Object Detection can mean the difference between accuracy and speed or an unresponsive implementation.

The following function, `ObjectCategorize(cv::Mat)`, located in lcar_bot/src/machine_vision/src/object_detect.cpp contains a call to `hog_.detectMultiscale()` as shown below.

 ```cpp
void ObjectCategorize(cv::Mat image) {
 if (!image.empty()) {
 vector <double> weights;
 vector <Rect> detected_objects;
 vector <Rect> door_objects;
 vector <double> door_weights;
 hog_.detectMultiScale(
     image,
     detected_objects
     ,weights
     ,0.8 // hit threshold
     ,Size(8,8) // step size
     ,Size(8,8) // padding
     ,1.1 // scale factor
     ,2 // final threshold
     ,false // use mean shift grouping?
 );
```

For best results, tune the following parameters to the recommended values:

* **hit threshold**: rejects detected objects with confidence below the specified number. Between 0.0 and 0.9 for best results.
* **step size**: both values for step size will always be the same and can be 4, 8, or 16. for example, Size(4,4) or Size(16,16).
* **padding**: like step size both values are the same with possible values of 0, 4, or 8 producing best results.
* **scale factor**: a number **greater** than 1, eg 1.05, 1.2, etc. It should stay below 1.3 for accuracy.
* **final threshold**: not sure about this one to be honest.
* **mean shift grouping**: controls overlapping bounding boxes to decide if the common space between boxes is an object of interest. Can be true or false.


