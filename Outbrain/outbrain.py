import pandas as pd
import numpy as np 

regularization = 10
eval = False

train = pd.read_csv("clicks_train.csv")

count = train[train.clicked == 1].ad_id.value_counts()
toatlCount = train.ad_id.value_counts()
del train

def get_prob(k):
    if k not in count:
        return 0
    print(count[k]/(float(toatlCount[k]) + regularization))
    return count[k]/(float(toatlCount[k]) + regularization)

def arrangement(x):
    ad_ids = map(int, x.split())
    ad_ids = sorted(ad_ids, key = get_prob, reverse=True)
    return " ".join(map(str, ad_ids))
   
result = pd.read_csv("sample_result.csv") 
result['ad_id'] = result.ad_id.apply(lambda x: arrangement(x))
result.to_csv("result.csv", index=False)
