#!/bin/sh

#while getopts f: flag
#do
#        case "${flag}" in
#                f) input_file=${OPTARG};;
#        esac
#done

#ml purge
#ml java
echo -e "\nRemoving current installation of Stanford CoreNLP... \n"
rm -r $GROUP_HOME/$USER/stanford-corenlp*

echo -e "\Installing Stanford CoreNLP... \n"
wget https://nlp.stanford.edu/software/stanford-corenlp-4.5.5.zip -P $GROUP_HOME/$USER
unzip $GROUP_HOME/$USER/stanford-corenlp-4.5.5.zip -d $GROUP_HOME/$USER

cd $GROUP_HOME/$USER/stanford-corenlp-4.5.5
echo -e "\nCollecting extra models for wikification... \n"
wget https://huggingface.co/stanfordnlp/corenlp-english-kbp/resolve/main/stanford-corenlp-models-english-kbp.jar https://huggingface.co/stanfordnlp/corenlp-english-extra/resolve/main/stanford-corenlp-models-english-extra.jar -P $GROUP_HOME/$USER/stanford-corenlp-4.5.5/

unzip -o $GROUP_HOME/$USER/stanford-corenlp-4.5.5/stanford-corenlp-models-english-extra.jar -d $GROUP_HOME/$USER/stanford-corenlp.4.5.5/
unzip -o $GROUP_HOME/$USER/stanford-corenlp-4.5.5/stanford-corenlp-models-english-kbp.jar -d $GROUP_HOME/$USER/stanford-corenlp.4.5.5/

zip $GROUP_HOME/$USER/stanford-corenlp.4.5.5/stanford-corenlp-4.5.5-models.jar $GROUP_HOME/$USER/stanford-corenlp.4.5.5/stanford-corenlp-4.5.5-models.jar $GROUP_HOME/$USER/stanford-corenlp.4.5.5/stanford-corenlp-models-english-extra.jar $GROUP_HOME/$USER/stanford-corenlp.4.5.5/stanford-corenlp-models-english-kbp.jar
echo -e "\nEstablishing classpath... \n"
for file in `find . -name "*.jar"`; do export
CLASSPATH="$CLASSPATH:`realpath $file`"; done
echo -e "\nWikifying text... \n"

ls -d -1 /scratch/users/$USER/testCorpus/*.* > filelist.lst
mkdir -p /scratch/users/$USER/outputs/coreEntities
java -cp "*" -Xmx16g edu.stanford.nlp.pipeline.StanfordCoreNLP -annotators tokenize,pos,lemma,ner,entitylink -filelist "filelist.lst" -outputDirectory "/scratch/users/$USER/outputs/coreEntities/"
