<p align="center">
    <br>
    <img src="./pics/banner.png" width="450"/>
    <br>
</p>
<p align="center">
    <a href="https://github.com/ymcui/Chinese-MobileBERT/blob/master/LICENSE">
        <img alt="GitHub" src="https://img.shields.io/github/license/ymcui/Chinese-MobileBERT.svg?color=blue&style=flat-square">
    </a>
</p>
本项目包含使用中文数据训练的MobileBERT模型。MobileBERT是BERT-large模型更“苗条”的版本，使用了瓶颈结构（bottleneck）并且对自注意力和前馈神经网络之间的平衡做了细致的设计。

本项目基于谷歌原版MobileBERT实现：[谷歌官方MobileBERT项目](https://github.com/google-research/google-research/tree/master/mobilebert)

**说明：本目录仅作为个人存档使用，如有问题还请互助解决。**

----

[PERT](https://github.com/ymcui/PERT) | [中文MacBERT](https://github.com/ymcui/MacBERT) | [中文ELECTRA](https://github.com/ymcui/Chinese-ELECTRA) | [中文XLNet](https://github.com/ymcui/Chinese-XLNet) | [中文BERT](https://github.com/ymcui/Chinese-BERT-wwm) |  [知识蒸馏工具TextBrewer](https://github.com/airaria/TextBrewer) | [模型裁剪工具TextPruner](https://github.com/airaria/TextPruner)

查看更多哈工大讯飞联合实验室（HFL）发布的资源：https://github.com/ymcui/HFL-Anthology

## 内容导引
| 章节                                  | 描述                                                         |
| ------------------------------------- | ------------------------------------------------------------ |
| [简介](#简介)                         | MobileBERT预训练模型的基本原理                                 |
| [模型下载](#模型下载)         | 中文MobileBERT预训练模型的下载地址                   |
| [基线系统效果](#基线系统效果) | 在部分NLU任务上的基线系统效果                                |
| [如何预训练和精调任务](#如何预训练和精调任务) | 介绍了如何预训练MobileBERT，以及在下游任务中精调 |
| [FAQ](#FAQ)                           | 常见问题答疑                                                 |

## 简介
请直接参考MobileBERT原论文：[MobileBERT: a Compact Task-Agnostic BERT for Resource-Limited Devices](https://arxiv.org/abs/2004.02984)

说明：

- 本目录中的base-f2和base-f4是以[RoBERTa-wwm-ext](https://github.com/ymcui/Chinese-BERT-wwm)为教师模型，训练2M步（batch=384）。
- 本目录中的large-f2和large-f4是以[RoBERTa-wwm-ext-large](https://github.com/ymcui/Chinese-BERT-wwm)为教师模型，训练2M步（batch=128）。

以下为本项目的目录结构；

- `config`目录：存放了所有模型config，roberta_wwm_ext\*.json是教师模型的config（分别对应base和large），student\*.json是学生模型（也就是MobileBERT）的config。uncased开头的是谷歌英文原版MobileBERT的config（供参考）。
- `pretrain`目录：提供了预训练MobileBERT的代码（几乎与谷歌原版一致）
- `finetune`目录：提供了精调XNLI任务的代码

## 模型下载

### 原版下载地址

这里主要提供TensorFlow 1.15版本的模型权重。如需PyTorch或者TensorFlow2版本的模型，请看下一小节。

以下是每个模型的重要参数，更详细的参数请查看每个模型的config文件。

| 结构         | 总层数 | 中间层大小 | 隐层大小 | 瓶颈大小 | 注意力头数 | FFN层数 | 总参数量<sup>[1]</sup> |
| :----------- | :----: | :--------: | :------: | :------: | :--------: | :-----: | :--------------------: |
| **Base-f2**  |   12   |    512     |   768    |   144    |     12     |    2    |         26.3M          |
| **Base-f4**  |   12   |    768     |   768    |   144    |     12     |    4    |         32.2M          |
| **Large-f2** |   24   |    512     |   1024   |   128    |     16     |    2    |         40.6M          |
| **Large-f4** |   24   |    512     |   1024   |   128    |     16     |    4    |         52.9M          |

> [1] 对照BERT-base是110M（约），BERT-large是330M（约）。

| 模型简称                           | 模型文件大小 |                          百度盘下载                          |
| :--------------------------------- | :--: | :----------------------------------------------------------: |
| **Chinese-MobileBERT-base-f2** | 672MB |[TensorFlow（密码：56bj）](https://pan.baidu.com/s/16g1LgXXAV01I-cFgPdeOow?pwd=56bj)|
| **Chinese-MobileBERT-base-f4** | 737MB |[TensorFlow（密码：v2v7）](https://pan.baidu.com/s/16SGBJhWFYru47EEyTZJljA?pwd=v2v7)|
| **Chinese-MobileBERT-large-f2** | 1.66GB |[TensorFlow（密码：6m5a）](https://pan.baidu.com/s/1Kp7n8lQJOtevzMovKSa3kw?pwd=6m5a)|
| **Chinese-MobileBERT-large-f4** | 1.80GB |[TensorFlow（密码：3h9b）](https://pan.baidu.com/s/19xz9kH1HmM2Og0Aqn7l6vA?pwd=3h9b)|

> 注：模型中的adam相关参数未删除，故模型文件较大。如有必要请自行删除。

### PyTorch以及TensorFlow 2版本

目前使用transformers给出的TF转PT脚本转换本目录中的模型会有一些问题，暂时不提供PT版本下载。

## 基线系统效果
为了测试中文MobileBERT的效果，我们选取了6个NLU进行测试，主要分为阅读理解和文本分类两大类。  

### 阅读理解

在以下两个任务上进行了测试：

- [**CMRC 2018**：篇章片段抽取型阅读理解（简体中文）](https://github.com/ymcui/cmrc2018)
- [**DRCD**：篇章片段抽取型阅读理解（繁体中文）](https://github.com/DRCSolutionService/DRCD)

MobileBERT超参：初始学习率3e-5、训练2轮、batch_size 32、最大长度512，其余保持默认。（注意：超参并非最优，还请自行多尝试）

评价指标：EM/F1

| CMRC 2018数据集           |            开发集             |            测试集             |            挑战集             |
| :------------------------ | :---------------------------: | :---------------------------: | :---------------------------: |
| BERT                      |   65.5 / 84.5   |   70.0 / 87.0    |   18.6 / 43.3   |
| RoBERTa-wwm-ext      |   67.4 / 87.2   |   72.6 / 89.4   |   26.2 / 51.0    |
| MobileBERT-base-f2 | 59.8 / 81.4 | 65.4 / 84.2 | 16.3 / 37.3 |
| MobileBERT-base-f4 | 62.4 / 83.3 | 67.5 / 85.8 | 19.0 / 41.6 |
| RoBERTa-wwm-ext-large | 68.5 / 88.4  | 74.2 / 90.6  | 31.5 / 60.1  |
| MobileBERT-large-f2 | 62.4 / 84.0 | 67.1 / 86.3 | 22.4 / 45.5 |
| MobileBERT-large-f4 | 64.4 / 85.6 | 68.2 / 87.1 | 22.2 / 46.3 |

| DRCD数据集 | 开发集 | 测试集 |
| :------- | :---------: | :---------: |
| BERT | 83.1 / 89.9 | 82.2 / 89.2 |
| RoBERTa-wwm-ext | 86.6 / 92.5 | 85.6 / 92.0 |
| MobileBERT-base-f2 | 81.4 / 88.6 | 80.3 / 87.7 |
| MobileBERT-base-f4 | 84.6 / 90.8 | 83.2 / 89.8 |
| RoBERTa-wwm-ext-large | 89.6 / 94.8 | 89.6 / 94.5 |
| MobileBERT-large-f2 | 84.1 / 90.5 | 83.3 / 90.2 |
| MobileBERT-large-f4 | 86.1 / 91.3 | 85.5 / 91.3 |

### 文本分类

在以下四个任务上进行了测试：

- [**XNLI**：自然语言推断](https://github.com/google-research/bert/blob/master/multilingual.md)
- [**ChnSentiCorp (CSC)**：情感分析](https://github.com/pengming617/bert_classification)
- [**LCQMC**：句对匹配](http://icrc.hitsz.edu.cn/info/1037/1146.htm)
- [**BQ Corpus**：句对匹配](http://icrc.hitsz.edu.cn/Article/show/175.html)

MobileBERT超参：初始学习率6e-5、训练3轮（XNLI为2轮）、batch_size为64、最大长度128（CSC为256），其余保持默认。（注意：超参并非最优，还请自行多尝试）

评价指标：Accuracy

| XNLI数据集                |     开发集      |     测试集      |
| :------------------------ | :-------------: | :-------------: |
| BERT                      |   77.8  |   77.8    |
| RoBERTa-wwm-ext       |   80.0   |   78.8   |
| MobileBERT-base-f2 | 74.3 | 73.6 |
| MobileBERT-base-f4 | 75.4 | 74.9 |
| RoBERTa-wwm-ext-large | 82.1 | 81.2  |
| MobileBERT-large-f2 | 75.5 | 75.6 |
| MobileBERT-large-f4 | 76.4 | 76.1 |


| CSC数据集                |     开发集      |     测试集      |
| :------------------------ | :-------------: | :-------------: |
| BERT                      |   94.7  |   95.0    |
| RoBERTa-wwm-ext       |   95.0   |  95.6   |
| MobileBERT-base-f2 | 94.0 | 94.0 |
| MobileBERT-base-f4 | 93.4 | 94.0 |
| RoBERTa-wwm-ext-large |95.8  | 95.8  |
| MobileBERT-large-f2 | 93.8 | 94.8 |
| MobileBERT-large-f4 | 94.7 | 95.3 |


| LCQMC数据集                |     开发集      |     测试集      |
| :------------------------ | :-------------: | :-------------: |
| BERT                      |   89.4  |  86.9    |
| RoBERTa-wwm-ext      |  89.0   |   86.4   |
| MobileBERT-base-f2 | 84.8 | 82.7 |
| MobileBERT-base-f4 | 85.8 | 84.1 |
| RoBERTa-wwm-ext-large | 90.4 |  87.0  |
| MobileBERT-large-f2 | 87.8 | 84.9 |
| MobileBERT-large-f4 | 87.2 | 85.4 |


| BQ数据集                |     开发集      |     测试集      |
| :------------------------ | :-------------: | :-------------: |
| BERT                      |   86.0  |   84.8    |
| RoBERTa-wwm-ext       |   86.4   |   85.3   |
| MobileBERT-base-f2 | 82.3 | 81.2 |
| MobileBERT-base-f4 | 83.1 | 83.1 |
| RoBERTa-wwm-ext-large | 86.3 | 85.8 |
| MobileBERT-large-f2 | 84.0 | 83.7 |
| MobileBERT-large-f4 |  84.4  | 84.3 |

## 如何预训练和精调任务

- 预训练：请查看`pretrain`目录中的[README.md](./pretrain/README.md)。
- 下游任务精调：请查看`finetune`目录中的[README.md](./finetune/README.md)。

## FAQ

1）本项目实际完成时间久远（2020年），如有问题还请自行查阅资料解决，感谢理解。

2）本项目中的内容仅供参考，实现也并非完全按照谷歌官方的配置进行，请酌情使用。


## 致谢
感谢TPU Research Cloud（TRC）提供TPU训练支持。

I would like to thank TPU Research Cloud (TRC) program for TPU access.

## 引用
```tex
@misc{cui-2022-chinese-mobilebert,
  title={Chinese MobileBERT},
  author={Cui, Yiming},
  howpublished={\url{https://github.com/ymcui/Chinese-MobileBERT}},
  year={2022}
}
```

