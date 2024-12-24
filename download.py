import os
# os.environ['ATTN_BACKEND'] = 'xformers'   # Can be 'flash-attn' or 'xformers', default is 'flash-attn'
os.environ['SPCONV_ALGO'] = 'native'        # Can be 'native' or 'auto', default is 'auto'.
                                            # 'auto' is faster but will do benchmarking at the beginning.
                                            # Recommended to set to 'native' if run only once.

from trellis.pipelines import TrellisImageTo3DPipeline

# Load a pipeline from a model folder or a Hugging Face model hub.
TrellisImageTo3DPipeline.from_pretrained("JeffreyXiang/TRELLIS-image-large")
