# OSFT Continual Learning Pipeline on Red Hat OpenShift AI (RHOAI)

This example provides an overview of the OSFT algorithm and an example on how to use it with Red Hat OpenShift AI pipelines.

Our example will go through: dataset download, training on a single node with GPU, evaluation of the fine-tuned model, and registering the model to Model Registry.

## Note

This example is compatible with RHOAI version 3.3

## OSFT Overview

Fine-tuning language models is hard—you need good data, lots of resources, and even small changes can cause problems. This makes it tough to add new abilities to a model. This problem is called continual learning and is what our new training technique, orthogonal subspace fine-tuning (OSFT), solves.

The OSFT algorithm implements Orthogonal Subspace Fine-Tuning based on Nayak et al. (2025), arXiv:2504.07097. This algorithm allows for continual training of pre-trained or instruction-tuned models without the need of a supplementary dataset to maintain the distribution of the original model/dataset that was trained.

**OSFT Key Benefits:**

- Enables continual learning without catastrophic forgetting
- No need for supplementary datasets to maintain original model distribution
- Significantly reduces data requirements for customizing instruction-tuned models
- Memory requirements similar to standard SFT

## Pipeline Overview

The reusable training pipeline consists of **four** steps:

- **Dataset Download** - Downloads and validates the dataset, ensuring it's in the expected chat format for Training Hub
- **Fine-Tuning** - Downloads the base model, performs OSFT fine-tuning, and produces training metrics
- **Evaluation** - Uses LM-Eval harness to evaluate the fine-tuned model against benchmark tasks and produce metrics
- **Model Registry** - Registers the fine-tuned model to Kubeflow Model Registry (optional)

**Pipeline Key Benefits:**

- **Minimal configuration** - Only one required parameter (dataset URI); sensible defaults for everything else
- **End-to-end workflow** - From raw data to registered model in a single pipeline run
- **Built-in evaluation** - Automatic benchmarking with LM-Eval harness
- **Model lineage tracking** - Full provenance recorded in Model Registry (training params, metrics, source pipeline)

## General requirements to run the example pipeline

- An OpenShift cluster with OpenShift AI (RHOAI 3.3) installed:
  - The **dashboard**, **trainer** and **aipipelines** components enabled
  - The **modelregistry** component optionally enabled (for registering fine-tuned models to model registry)
  > - Note: If model registry is not set up, the pipeline will still succeed but it won't push the model to model registry
  > - Note: To set up model registry in RHOAI follow the [official documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.0/html/managing_model_registries/creating-a-model-registry_managing-model-registries).
  - The **pipeline server** running
  > - Note: To set up pipeline server in RHOAI follow the [official documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.0/html/working_with_ai_pipelines/managing-ai-pipelines_ai-pipelines#configuring-a-pipeline-server_ai-pipelines) 

## Hardware requirements to run the example pipeline

### Training Job Requirements

The pipeline uses a single GPU node by default

| Component | Configuration | GPU per node | GPU Type (per GPU) | CPU | Memory |
|-----------|--------------|---|------------|-----|--------|
| Training Pods | 1 node × 1 GPU | 1 | NVIDIA L40/L40S or equivalent | 8 cores/pod | 32Gi/pod |

> - This example was tested on 1 node × 1 GPU provided by L40S; however, it will work on larger configurations.
> - CPU and Memory requirements scale with batch size and model size. Above suit the example as it is.
> - GPU is also used for the evaluation step but by the time it starts, the training allocated GPU is relieved

## Prerequisites

#### Storage Class

The pipeline automatically creates a 50GB PVC that is used across stages.

RWX storage is required with storage class name `nfs-csi`. In our example, we are using NFS storage with nfs-csi drivers.

> - Note: If the name of your cluster rwx storage class is different, it can be changed directly in the [pipeline.py file](https://github.com/red-hat-data-services/pipelines-components/blob/main/pipelines/training/osft_minimal/pipeline.py#L28) as part of generating pipeline
yaml step in Quickstart Guide below.

#### Kubernetes authentication secret

The training component requires Kubernetes API access to submit training jobs, find clusterTrainingRuntimes etc. Create a secret named `kubernetes-credentials` with the following keys:

| Key | Description |
|-----|-------------|
| `KUBERNETES_SERVER_URL` | Kubernetes API server URL (e.g., `https://api.cluster.example.com:6443`) |
| `KUBERNETES_AUTH_TOKEN` | Service account token with permissions to create training jobs |

```bash
oc create secret generic kubernetes-credentials \
  --from-literal=KUBERNETES_SERVER_URL="https://api.your-cluster.com:6443" \
  --from-literal=KUBERNETES_AUTH_TOKEN="<your-service-account-token>"
```

> **Note:** This is the only **required** secret for running the pipeline with default values.

#### Optional Secrets

The following secrets are optional and only needed for specific use cases:

- **s3-secret (required for `s3://` based datasets)**
    - **Used by**: Dataset download step when **dataset_uri** starts with `s3://`.
    - **Keys**:
      - `AWS_ACCESS_KEY_ID`
      - `AWS_SECRET_ACCESS_KEY`

- **hf-token (required for gated models/datasets)**
    - **Used by**: Dataset download, training, and evaluation steps.
    - **Key**:
      - `HF_TOKEN` – a valid Hugging Face access token.

- **oci-pull-secret-model-download (required for private OCI base models)**
    - **Used by**: Training step when `phase_02_train_man_train_model` is an `oci://` reference.
    - **Key**:
      - `OCI_PULL_SECRET_MODEL_DOWNLOAD` – the contents of a Docker `config.json`, used by `skopeo` to
        authenticate to the registry.

## Pipeline Parameters

The OSFT minimal pipeline exposes only the most important parameters and the list can be found in the
[repository readme](https://github.com/red-hat-data-services/pipelines-components/blob/main/pipelines/training/osft_minimal/README.md).

## Quick Start

### 1. Generate the Pipeline YAML

The compiled pipeline YAML is not included in the repository and must be generated locally.

**Requirements:**
- Python 3.11+
- KFP SDK version **2.15.2** (important: other versions may produce incompatible YAML)

```bash
# Clone the repository
git clone https://github.com/kubeflow/pipelines-components.git
cd pipelines-components

# Create a virtual environment with the correct KFP version
python -m venv .venv-kfp
source .venv-kfp/bin/activate
pip install kfp==2.15.2 kfp-kubernetes==2.15.2

# Generate the pipeline YAML
PYTHONPATH=$(pwd) python pipelines/training/osft_minimal/pipeline.py

# The compiled pipeline will be at:
# pipelines/training/osft_minimal/pipeline.yaml
```

### 2. Create Required Secrets

Create the `kubernetes-credentials` secret (see [Prerequisites](#kubernetes-authentication-secret) section above).

### 3. Upload Pipeline to RHOAI

1. In OpenShift AI Dashboard, navigate to **Develop & train** > **Pipelines** > **Pipeline definitions**

![](./docs/01.png)
 
2. Click **Import pipeline**
3. Upload the generated `pipeline.yaml` file by drag and drop or by clicking on the **Upload** button and selecting your `pipeline.yaml`. Add a **Pipeline name** and optionally, a **Pipeline description**

> - Note: Learn more about pipeline definitions in the [official documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.0/html/working_with_ai_pipelines/managing-ai-pipelines_ai-pipelines#importing-a-pipeline_ai-pipelines)

![](./docs/02.png)

> - Note: Pipeline definitions can contain multiple versions of the same pipeline, to add new version of the pipeline click on **Upload new version**. More about versions can be found in [official documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.0/html/working_with_ai_pipelines/managing-ai-pipelines_ai-pipelines#overview-of-pipeline-versions_ai-pipelines).

![](./docs/03.png)



### 4. Run the Pipeline

1. Navigate to **Develop & train** > **Pipelines** > **Runs** and click **Create run**

![](./docs/04.png)

2. Set the following
  
    - Experiment - optional - can be left as Default (learn more about how to manage experiments in [official documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.0/html/working_with_ai_pipelines/managing-pipeline-experiments_ai-pipelines#overview-of-pipeline-experiments_ai-pipelines))
    - Name - required - name of the run
    - Description - optional - description of the run
    - Pipeline - required - select the pipeline name defined in pipeline definition step
    - Pipeline version - required - autoselects latest version

![](./docs/05.png)

3. Scroll down to **Parameters** and set the following required parameter:

    - **phase_01_dataset_man_data_uri** to **LipengCS/Table-GPT:All**

> - Other parameters are optional, ranging from dataset subset size, fine-tuning number of workers, batch size to lm-eval evaluation tasks or
model registry. For the example purpose, model registry has been set up to showcase produced metrics and selected only a subset of the dataset to fine-tune the model on (2000 samples)

4. Click **Run**
5. Pipeline run view will appear where steps, logs and a loss chart can be viewed at any point (during or after the run)

- Overall view:

![](./docs/06.png)

- Logs, inputs or outputs, task details or visualization can be viewed by clicking on a step icon and navigating to the required tab

![](./docs/07.png)

- Training loss chart - training component provides a loss chart, which can be viewed by clicking on the **output_loss_chart** icon and
navigating to **Visualization**

> - Note: The chart can be viewed in full screen from the **Artifact details** S3 link

![](./docs/08.png)

- Completed pipeline

![](./docs/09.png)

Each pipeline step is performed as a separate Kubernetes pod. Pods can be investigated for further details if required.

### 5. Model Registry

1. To view model registered in model registry navigate to **AI hub** > **Registry**

![](./docs/10.png)

2. Select the model and navigate to **Versions**, from where you can select your fine-tuned model version and view
metrics in **Details**

> - Note: Version, model name, and registry address are all part of exposed optional parameters in the pipeline.
> - Note: The amount of metrics varies based on the number of evaluation tasks selected; by default, evaluation performs only the arc_easy task.

![](./docs/11.png)
