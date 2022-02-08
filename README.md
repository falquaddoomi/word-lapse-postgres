# Word-Lapse Postgres DB

This repo contains configuration for setting up and loading a PostgreSQL
database with word vectors from the word-lapse project. It makes use of
[https://github.com/guenthermi/postgres-word2vec](postgres-word2vec), with some
custom additions to facilitate loading from Gensim word2vec files.

The `/data` folder should be populated from
[https://github.com/greenelab/word-lapse-models](word-lapse-models), or
symlinked if you already have it elsewhere.
