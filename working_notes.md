### 12.14.23 ###

Take filename as argument in shell script; move it into the folder once unzipped.

- To download CoreNLP GitHub files, use:
 `wget https://nlp.stanford.edu/software/stanford-corenlp-4.5.5.zip`
- Unzip the downloaded files:
 `unzip stanford-corenlp-4.5.5.zip`

cd stanford-corenlp-4.5.5.zip
 
Download extra english files
wget https://huggingface.co/stanfordnlp/corenlp-english-kbp/resolve/main/stanford-corenlp-models-english-kbp.jar
wget https://huggingface.co/stanfordnlp/corenlp-english-extra/resolve/main/stanford-corenlp-models-english-extra.jar
Unzip all three files
unzip stanford-corenlp-models-english-extra.jar
unzip -o stanford-corenlp-models-english-extra.jar
unzip -o stanford-corenlp-models-english-kbp.jar

rezip them together
zip stanford-corenlp-4.5.5-models.jar stanford-corenlp-4.5.5-models.jar stanford-corenlp-models-english-extra.jar stanford-corenlp-models-english-kbp.jar

- Set up the classpath in bash:
    `for file in `find . -name "*.jar"\`; do export
    CLASSPATH="$CLASSPATH:`realpath $file`"; done`


    java -cp "*" -mx3g edu.stanford.nlp.pipeline.StanfordCoreNLP -outputFormat json -file input.txt

====
#TODO 
needs to work on a corpus (use parallelization)
turns the output file into something easy for humanists to read

### 12.19.23 ###
Wikification sbatch file is now working with a single input file.
After talking to Mark H., it does not make sense to parallelize.
We can successfully get wikipedia IDs (strings) and NER tags from CORENLP
We need to select wikipedia IDs from output file rows where NER tags == "LOCATION"
Now, we are working on how to get coordinates from wikipedia IDs.

From <https://dumps.wikimedia.org/wikidatawiki/latest/wikidatawiki-latest-geo_tags.sql.gz> we can get a list of coordiantes and a 'gt_id' and a 'gt_page_id'. We cannot yet figure out how to match those to an ID that we can eventually then match to the wikipedia ID.

We are working on looking for matching IDs in tables from this webpage: https://dumps.wikimedia.org/wikidatawiki/latest/

Here is also a tool to make a custom RDF dump: https://wdumps.toolforge.org/#. Can we download only wikidata that has coordinate information?