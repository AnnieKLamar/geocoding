#!/bin/sh

while getopts f: flag
do
        case "${flag}" in
                f) input_file=${OPTARG};;
        esac
done

ml purge
ml java
echo -e "\nRemoving current installation of Stanford CoreNLP... \n"
rm -r stanford-corenlp*

echo -e "\Installing Stanford CoreNLP... \n"
wget https://nlp.stanford.edu/software/stanford-corenlp-4.5.5.zip
unzip stanford-corenlp-4.5.5.zip
rm stanford-corenlp-4.5.5/input.txt stanford-corenlp-4.5.5/input.txt.xml


cp $input_file stanford-corenlp-4.5.5/input.txt
cd stanford-corenlp-4.5.5
echo -e "\nCollecting extra models for wikification... \n"
wget https://huggingface.co/stanfordnlp/corenlp-english-kbp/resolve/main/stanford-corenlp-models-english-kbp.jar https://huggingface.co/stanfordnlp/corenlp-english-extra/resolve/main/stanford-corenlp-models-english-extra.jar

unzip -o stanford-corenlp-models-english-extra.jar
unzip -o stanford-corenlp-models-english-extra.jar
unzip -o stanford-corenlp-models-english-kbp.jar

zip stanford-corenlp-4.5.5-models.jar stanford-corenlp-4.5.5-models.jar stanford-corenlp-models-english-extra.jar stanford-corenlp-models-english-kbp.jar
echo -e "\nEstablishing classpath... \n"
for file in `find . -name "*.jar"`; do export
CLASSPATH="$CLASSPATH:`realpath $file`"; done
echo -e "\nWikifying text... \n"

ls -d -1 /path/to/txt/corpus/*.* > filelist.lst
mkdir /scratch/users/$USER/output/coreEntities
java -cp "*" -Xmx16g edu.stanford.nlp.pipeline.StanfordCoreNLP -annotators tokenize,pos,lemma,ner,entitylink -filelist "filelist.lst" -outputDirectory "/scratch/users/$USER/output/coreEntities/"
