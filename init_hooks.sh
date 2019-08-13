#!/bin/sh

# commit直前にファイルを暗号化して、addする
PRE_COMMIT=$(cat << EOS
#!/bin/sh
gcloud kms encrypt --location global --keyring test --key quickstart --plaintext-file secret.php --ciphertext-file secret.php.encrypted
git add secret.php.encrypted
EOS
)
echo "$PRE_COMMIT" > .git/hooks/pre-commit

# pullした時merge直後に複合化する
POST_MERGE=$(cat << EOS
#!/bin/sh
gcloud kms decrypt --location global --keyring test --key quickstart --ciphertext-file secret.php.encrypted --plaintext-file secret.php
EOS
)
echo "$POST_MERGE" > .git/hooks/post-merge

# cloneした時に複合化される
# POST_MERGE=$(cat << EOS
# #!/bin/sh
# gcloud kms decrypt --location global --keyring test --key quickstart --ciphertext-file secret.php.encrypted --plaintext-file secret.php
# EOS
# )

# echo "$POST_MERGE" > .git/hooks/post-merge