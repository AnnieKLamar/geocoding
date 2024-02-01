!/bin/sh

while getopts d: flag
do
        case "${flag}" in
                d) corpus_directory=${OPTARG};;
        esac
done
# load modules
ml purge
ml java
ml python3

# remove current installation of CoreNLP
echo -e "\nRemoving current installation of Stanford CoreNLP... \n"
rm -r $GROUP_HOME/$USER/stanford-corenlp*
# install CoreNLP
echo -e "\Installing Stanford CoreNLP... \n"
wget https://nlp.stanford.edu/software/stanford-corenlp-4.5.5.zip -P $GROUP_HOME/$USER
unzip $GROUP_HOME/$USER/stanford-corenlp-4.5.5.zip -d $GROUP_HOME/$USER
# navigate into CoreNP and download extra Wikification modules
cd $GROUP_HOME/$USER/stanford-corenlp-4.5.5
echo -e "\nCollecting extra models for wikification... \n"
wget https://huggingface.co/stanfordnlp/corenlp-english-kbp/resolve/main/stanford-corenlp-models-english-kbp.jar https://huggingface.co/stanfordnlp/corenlp-english-extra/resolve/main/stanford-corenlp-models-english-extra.jar -P $GROUP_HOME/$USER/stanford-corenlp-4.5.5/
# unzip all downloaded modules and re-zip them together
unzip -o $GROUP_HOME/$USER/stanford-corenlp-4.5.5/stanford-corenlp-models-english-extra.jar -d $GROUP_HOME/$USER/stanford-corenlp.4.5.5/
unzip -o $GROUP_HOME/$USER/stanford-corenlp-4.5.5/stanford-corenlp-models-english-kbp.jar -d $GROUP_HOME/$USER/stanford-corenlp.4.5.5/
zip $GROUP_HOME/$USER/stanford-corenlp.4.5.5/stanford-corenlp-4.5.5-models.jar $GROUP_HOME/$USER/stanford-corenlp.4.5.5/stanford-corenlp-4.5.5-models.jar $GROUP_HOME/$USER/stanford-corenlp.4.5.5/stanford-corenlp-models-english-extra.jar $GROUP_HOME/$USER/stanford-corenlp.4.5.5/stanford-corenlp-models-english-kbp.jar
# export all .jar files
echo -e "\nEstablishing classpath... \n"
for file in `find . -name "*.jar"`; do export
CLASSPATH="$CLASSPATH:`realpath $file`"; done
echo -e "\nWikifying text... \n"
# get all files in specified corpus directory
ls -d -1 /scratch/users/$USER/$corpus_directory/*.* > filelist.lst
# NER with Wikification links into outputs/coreEntities
mkdir -p /scratch/users/$USER/outputs/coreEntities
java -cp "*" -Xmx16g edu.stanford.nlp.pipeline.StanfordCoreNLP -annotators tokenize,pos,lemma,ner,entitylink -filelist "filelist.lst" -outputDirectory "/scratch/users/$USER/outputs/coreEntities/"
# get only locations with Wikipedia IDs from coreEntities
grep "LOCATION Wikipedia" /scratch/users/$USER/outputs/coreEntities/*.out | sed 's/.*\=//' | sed 's/]//' > /scratch/users/$USER/outputs/coreEntities/entities.txt
# get the wiki data dump with geographic information
# still in the $USER/stanford-corenlp-4.5.5 directory
wget https://iw.toolforge.org/wp-world/dumps/new_red0.gz
gunzip new_red0.gz
# removes all \N from file
sed 's/\\N/ /g' new_red0 | tr -s '[:blank:]' ' ' > clean.txt
