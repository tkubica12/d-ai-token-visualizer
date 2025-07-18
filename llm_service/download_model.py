from huggingface_hub import hf_hub_download
from huggingface_hub import login
from huggingface_hub import snapshot_download
import os

login(token=os.getenv("HUGGINGFACE_TOKEN"))
snapshot_download(repo_id="google/gemma-2-2b", use_auth_token=True)

