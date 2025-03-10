## Artificial Intelligence classification model comparison based on NYHA keywords and history of present illness to predict heart failure classification 
<b>Question</b>: Can Artificial Intelligence accurately predict, based solely on the students’ free text portion of the SOAP note, the level of heart failure the simulation demonstrated, New York Heart Association classification? 

<b>Findings</b>: In this evaluation of Artificial Intelligence models the Random Forests technique satisfied the requirements of the application. The final model had a 0.22% misclassification rate on the bootstrap sample training set and a 0.04% misclassification rate on the bootstrap sample testing set. 

<b>Meaning</b>: Artificial Intelligence, specifically using the Random Forests technique, demonstrated its’ ability to predict New York Heart Association classification based on a free text SOAP note with a low misclassification rate. 
Importance: Artificial Intelligence has been found to provide a more accurate assessment of student competency via assessment of the students’ clinical notes.3 

<b>Objective</b>: To determine the ability of an Artificial Intelligence to accurately predict, based solely on Edward Via College of Osteopathic Medicine students’ free text portion of the SOAP note, the New York Heart Association heart failure classification. 

<b>Design</b>: This study evaluated the performance of various Artificial Intelligence models based on model misclassification rate and model attributes. 

<b>Setting</b>: Osteopathic Medical School in Southeastern Virginia. 

<b>Participants</b>: De-identified History of Present Illness responses of First-Year Osteopathic Medical Students from all four campuses who completed Block 4 Hospital Integrated Clinical Cases Cardiopulmonary Testing and completed their SOAP note documentation were included. 649 responses were accepted, 2 responses were excluded due to incomplete responses. 

<b>Interventions</b>: New York Heart Association classifications established terminology for delineation of various heart failure presentations, this terminology was converted into keywords shared by a standardized patient. First Year Osteopathic Medical Students typed History of Present Illness were de-identified. Data was tokenized, cleaned, and assessed for the number of correct keywords, incorrect keywords, and keyword usage. Data was indexed to a de-identified subject, lexically analyzed, and prepared for model training. The models were assessed on testing data using nonparametric bootstrap sampling. 

<b>Main Outcomes and Measures</b>: The variables of interest were the student free text responses in the subjective section of their SOAP note, the keywords used in their responses, and the classification associated with the keywords. 

<b>Results</b>: The Random Forests model had a 0.22% misclassification rate on the bootstrap sample training set and a 0.04% misclassification rate on the bootstrap sample testing set. 

<b>Conclusion and Relevance</b>: This adaptation of the Random Forests technique satisfied the requirements of its’ application as demonstrated by the low misclassification rate in evaluation of the sample training set and sample testing set. In future application, the Random Forest Importance Plot output may be used as feedback for the students – providing the keywords vital to making the distinction between each NYHA Classification
