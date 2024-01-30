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

### 1.4.24 ###
bcr: 

    - checked out wdumps.toolforge.org. There is a recent dumps section, one of which is for "all films": https://wdumps.toolforge.org/dump/3727. I downloaded it and it creates a file ~12,000,000 lines long and 1.5gb, so may actually grab the info we want if we can create our own query correctly. If this provides a comprehensive dataset, the question then becomes "how do we distribute it to users when they run the script?" The tool seems to be an intermediary that generates a query that we could probably use with a CLI tool instead. Another option would be hosting the end file somewhere and serving it in the script. Haven't parsed the syntax of the query yet, but will work on that.
    - https://hay.toolforge.org/propbrowse/ seems to work well in concert with above. P276 looks like a top-level "location" category, though there are several sub-levels I included in a query to investigate. There are several pending requests on the site, so live queries are prob not a good idea if we use this tool, but dump will eventually be found here for evaluation: https://wdumps.toolforge.org/dump/3735
    - data should be parseable, just need to have it search for P-code within a record and return the QID (unique ID) within that record. Records have predictable structure that can be parsed:

This is somewhere near the start of a record for "12 Angry Men":

<http://www.wikidata.org/prop/direct/P5786> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2002/07/owl#DatatypeProperty> .
<http://www.wikidata.org/prop/novalue/P480> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2002/07/owl#Class> .
<http://www.wikidata.org/prop/novalue/P480> <http://www.w3.org/2002/07/owl#complementOf> _:node1himiok17x130 .
_:node1himiok17x130 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2002/07/owl#Restriction> .
_:node1himiok17x130 <http://www.w3.org/2002/07/owl#onProperty> <http://www.wikidata.org/entity/P480> .
_:node1himiok17x130 <http://www.w3.org/2002/07/owl#someValuesFrom> <http://www.w3.org/2001/XMLSchema#string> .
<http://www.wikidata.org/prop/direct/P480> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2002/07/owl#DatatypeProperty> .
<http://www.wikidata.org/entity/Q2345> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://wikiba.se/ontology#Item> .
<http://www.wikidata.org/entity/Q2345> <http://www.w3.org/2000/01/rdf-schema#label> "12 Angry Men"@en .
<http://www.wikidata.org/entity/Q2345> <http://schema.org/description> "1957 drama film by Sidney Lumet"@en .
<http://www.wikidata.org/entity/Q2345> <http://www.w3.org/2004/02/skos/core#altLabel> "Twelve Angry Men"@en .
<http://www.wikidata.org/entity/Q2345> <http://www.wikidata.org/prop/direct/P269> "17807599X" .
<http://www.wikidata.org/entity/Q2345> <http://www.wikidata.org/prop/direct/P268> "16473943m" .
<http://www.wikidata.org/entity/Q2345> <http://www.wikidata.org/prop/direct/P3808> "12-Angry-Men" .
<http://www.wikidata.org/entity/Q2345> <http://www.wikidata.org/prop/direct/P144> <http://www.wikidata.org/entity/Q13709586> .


I'm not sure exactly where it starts and ends, but the QID at the start of each entry is for the main entity (Q2345), and all the P codes are things linked in the entry. Determining the canonical P-code is probably tricker than this parsing. I'd start with either "the first one" or "all of them" for each entry.

### 1.5.24 ###

Was looking for an RDF parser to see if there was an easier way than regex to parse this (I think regex will still be pretty easy)
and found this tool: https://github.com/RDFLib/rdflib. Not sure how to get it working on the wikidata http, but the linked site there
(https://dbpedia.org/page/) contains good info on dbpedia's ontology and another potential route. FWIW, I think Populated Places
are what we're looking for in their data. Probably also want natural places.

I think the sparqlwrapper code I sent can probably be used for data acquisition in any of these routes.

### 1.9.24 ###
Data dump at https://wdumps.toolforge.org/dump/3735 is still processing; it should be done by Thursday.

In CORENLP output, WikiIDs are listed as words with underscores, e.g. "Catacombs_of_Paris" "Mount_Etna"; could connect to RDF results by replacing underscores with spaces.

Currently using https://github.com/dphiffer/wikidata-geo-index/tree/master to try. This downloads wikidata's latest dump and indexes only the items with latitude and longitude coordinates, then returns a SQLite database. Since the SQLite database has the name and ID of the locations, we should be able to query the downloaded db for the NER-ed location items. 

Use Brad's sentiment analysis script as a model for parallelizing this project. We probably want to parallelize at the file level.

### 1.23.24 ###
Combined wikification.sh and extractEntities.sh into a single script called 'geocode.sh'.
Changed geocode.sh to accept a directory as a parameter instead of a file. This variable is now stored in $corpus_directory.
Renamed wikification.sbatch to geocode.sbatch
Found a data dump with WikiIDs and geogrpahic coordinates.
Script to download and unzip data dump: 
`wget https://iw.toolforge.org/wp-world/dumps/new_red0.gz`
`gunzip new_red0.gz`

This is a sed command that should remove all '\N' characters, but it's only working on part of the file?
sed ':a;N;$!ba;s/\\N//g' new_red0 > formatted_wikidump

This replaces all tabs with single spaces.
sed 's/\t/ /g' remove_new_lines > no-tab-file

This replaces all multiple spaces with single spaces.
tr -s ' ' < no-tab-file > single_space_file

After these three commands, the top part of the file is ready to be parsed, but the bottom still has all the formatting problems. I've never seen a command only work on part of a file?

### 1.24.24 ###

bcr: 
```bash
sed 's/\\N/ /g' new_red0 | tr -s '[:blank:]' ' ' > clean.txt
```
 should work. If it still only processes half, it may be an OOM issue that doesn't fail, but doesn't complete execution.
I use this dev session for testing:
```bash
sh_dev -t 03:00:00 -c 4 -m 16GB -p normal
```
so ask for these resources for testing, and ensure similar resources are requested in the sbatch.
