# Domain Customization Data Generation using Kubeflow Pipelines (KFP)

This example demonstrates how to generate synthetic data for domain-specific model customization using
**Kubeflow Pipelines (KFP)** on a **Red Hat OpenShift AI (RHOAI)** instance.

---

## Step 1: Configure Environment Variables (`.env`)

### 1. Copy the Example File

```bash
cp env.example .env
```

### 2. Update the Configuration

Edit the `.env` file to include your own settings such as:

* API endpoints and model providers
* Seed data paths
* Model configuration values

### 3. Store the `.env` File as a Kubernetes Secret

Use Kubernetes Secrets to securely store sensitive information like API keys.

```bash
# Delete the existing secret if it exists
oc delete secret sdg-pipeline-config

# Create a new secret from your .env file
oc create secret generic sdg-pipeline-config \
  --from-env-file=.env
```

---

## Step 2: Generate the KFP Pipeline YAML

Run the script below to generate the Kubeflow pipeline YAML definition:

```bash
python knowledge_generation_pipeline.py
```

This will create a ready-to-upload `.yaml` file that defines the **Knowledge Generation Pipeline**.

---

## Step 3: Deploy the Pipeline on RHOAI

1. Provision a **RHOAI instance**.

2. In the **Data Science Pipelines** section, create a new **pipeline server**.

3. Upload the generated pipeline YAML file.

4. Once uploaded, you can visualize the pipeline as shown below:

   ![Kubeflow Pipeline Visualization](/assets/domain_customization_kfp_pipeline/kfp_pipeline.png)

5. Go to the **Run** tab and start a new pipeline run.

All pipeline parameters are configured through the `.env` file.

---

## Key Parameters

| Parameter                                                     | Description                                                                                                                                                                              |
| ------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **SEED_DATA_PATH**                                            | Path to your seed data. If it doesn’t exist, a new dataset will be created automatically from a quality benchmark.                                                                       |
| **NUMBER_OF_SUMMARIES**                                       | Number of document augmentations (summaries) to generate per chunk. More summaries improve memorization.<br>Recommended values: `10–20` for large datasets, up to `50` for smaller ones. |
| **VLLM_MODEL / API_BASE_URL / OPENAI_API_KEY / OPENAI_MODEL** | Define the model provider and endpoint. Use `OPENAI_MODEL` and `OPENAI_API_KEY` for OpenAI models, or set `API_BASE_URL` for OpenRouter or any other OpenAI-compatible provider.         |
