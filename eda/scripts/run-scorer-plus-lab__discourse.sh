SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR=$SCRIPT_DIR/../..
DISCRIM_DIR=$ROOT_DIR/../controlled-sequence-gen/discriminator/
cache_dir=$ROOT_DIR/../named-models

model_type=roberta
if [[ $model_type == 'gpt2' ]]
then
  pretrained_model="$cache_dir/gpt2-medium-expanded-embeddings"
  frozen_layers="0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"
else
  pretrained_model="$cache_dir/roberta-base"
  frozen_layers="0 1 2 3 4 5 6 7 8 9"
fi
##

python3.7 $DISCRIM_DIR/score_using_discriminator.py \
        --model_type $model_type \
        --pretrained_files_s3 $pretrained_model \
        --experiment lstm_sequential \
        --batch_size 1 \
        --num_train_epochs 3 \
        --do_train \
        --do_eval \
        --train_data_file_s3 data/edit-events-sentences-for-discourse-modeling.csv \
        --notes "Score sentence edits" \
        --freeze_transformer \
        --discriminator_path "$SCRIPT_DIR/../models/trial-Roberta, high level labels__epoch=08-f1_macro=0.65.ckpt" \
        --processed_data_fname "$SCRIPT_DIR/data/edit_scores.txt" \
        --context_layer 'lstm' \
        --num_contextual_layers 2 \
        --num_sent_attn_heads 2 \
        --sentence_embedding_method 'attention' \
        --dropout .1 \
        --accumulate_grad_batches 1 \
        --learning_rate 1e-4 \
        --warmup_steps 0 \
        --max_num_word_positions 2048 \
        --map_tags \
        --local


#       --pretrained_files_s3 $pretrained_model \
#        --freeze_encoder_layers $frozen_layers \
#        --bidirectional \
#        --use_positional \
#        --use_doc_emb \
#        --doc_embed_arithmetic \
#    ;
#            --train_data_file_s3 data/news-discourse-training-data.csv \
#        --concat_headline \



#for i in version_0  version_1  version_10 version_11 version_12 version_13 version_14 version_15 version_16 version_17 version_18 version_19 version_2  version_20 version_21 version_22 version_23 version_24 version_25 version_26 version_27 version_28 version_29 version_3  version_30 version_31 version_32 version_33 version_34 version_35 version_36 version_37 version_38 version_39 version_4  version_40 version_41 version_42 version_43 version_44 version_45 version_46 version_47 version_48 version_49 version_5 version_6  version_7  version_8  version_9;
#do
#  katie hdfs --identity ai-clf-dob2-gen --namespace s-ai-classification rename /projects/ai_classification/aspangher/controlled-sequence-gen/tensorboard/default/$i /projects/ai_classification/aspangher/controlled-sequence-gen/tensorboard-old/default/$i
#done
