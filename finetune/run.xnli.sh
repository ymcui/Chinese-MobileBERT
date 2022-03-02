TPU_NAME=
TPU_ZONE= 
INIT_PATH=
MODEL_PATH=
DATA_PATH=
TASK=xnli

python -u run_classifier.py \
--vocab_file=${INIT_PATH}/vocab.txt \
--bert_config_file=${INIT_PATH}/student_base_f2.json \
--init_checkpoint=${INIT_PATH}/mobilebert.ckpt \
--task_name=${TASK} \
--do_train=True \
--do_eval=True \
--data_dir=${DATA_PATH} \
--train_batch_size=64 \
--predict_batch_size=64 \
--num_train_epochs=2 \
--max_seq_length=128 \
--learning_rate=6e-5 \
--save_checkpoints_steps=10000 \
--rand_seed=12345 \
--output_dir=${MODEL_DIR} \
--do_lower_case=True \
--use_tpu=True \
--tpu_name=${TPU_NAME} \
--tpu_zone=${TPU_ZONE}
