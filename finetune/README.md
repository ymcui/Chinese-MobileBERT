## 如何使用MobileBERT精调XNLI任务

本目录提供了下游任务精调的代码（TensorFlow）。以XNLI任务为例介绍如何精调MobileBERT（base-f2）。
示例代码的训练设备为TPU，请根据自己的训练设备对脚本进行调整。
入口为`run.xnli.sh`，内容如下。关键环境变量见注释。
```bash
# TPU_NAME, TPU_ZONE为TPU专用变量，不使用TPU则不需要传入
TPU_NAME=
TPU_ZONE= 
# INIT_PATH为预训练过的MobileBERT解压后的位置，其中包含模型文件、配置文件、词表等
INIT_PATH=
# MODEL_PATH为当前精调任务的模型存放位置
MODEL_PATH=
# 存放XNLI数据的位置
DATA_PATH=
# 任务名称，与run_classifier中的各个processor名字对应，详见run_classifier.py
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
```

