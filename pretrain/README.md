## 如何预训练MobileBERT

本目录提供了预训练的代码（TensorFlow）。以预训练MobileBERT（base-f2）为例进行说明。
示例代码的训练设备为TPU，请根据自己的训练设备对脚本进行调整。
入口为`run.pretrain.sh`，内容如下。关键环境变量见注释。
```bash
#!/bin/bash
set -ex

# 预训练TF_RECORD存放路径，此文件与BERT生成预训练输入文件的方式一样
# 详见：https://github.com/google-research/bert/blob/master/create_pretraining_data.py
DATA_DIR=./data-dir/tf_examples.*
# 教师模型的存放路径，本例中base-f2的教师模型为RoBERTa-wwm-ext
TEACHER_CHECKPOINT=./roberta-wwm-ext/bert_model.ckpt
# 预训练后的MobileBERT存放路径
OUTPUT_DIR=./mobilebert/base-f2

# TPU_NAME, TPU_ZONE为TPU专用变量，不使用TPU则不需要传入
TPU_NAME=
TPU_ZONE= 

# run pretraining
python run_pretraining.py \
--input_file=${DATA_DIR} \
--first_input_file=${DATA_DIR} \
--attention_distill_factor=1 \
--bert_config_file=./config/student_base_f2.json \
--bert_teacher_config_file=./config/roberta_wwm_ext.json \
--beta_distill_factor=5000 \
--distill_ground_truth_ratio=0.5 \
--distill_temperature=1 \
--do_train \
--first_max_seq_length=128 \
--first_num_train_steps=0 \
--first_train_batch_size=256 \
--gamma_distill_factor=5 \
--hidden_distill_factor=100 \
--init_checkpoint=${TEACHER_CHECKPOINT} \
--layer_wise_warmup \
--learning_rate=1e-4 \
--max_predictions_per_seq=75 \
--max_seq_length=512 \
--num_distill_steps=500000 \
--num_train_steps=2000000 \
--num_warmup_steps=10000 \
--optimizer=adamw \
--output_dir=${OUTPUT_DIR} \
--save_checkpoints_steps=10000 \
--train_batch_size=384 \
--use_einsum \
--use_summary \
--use_tpu \
--tpu_zone=${TPU_ZONE} \
--tpu_name=${TPU_NAME}

echo "ALL DONE"
```

