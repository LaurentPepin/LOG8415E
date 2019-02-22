#!/usr/bin/env python3

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import sys
import shutil

instances = ['a1-large', 'c5-xlarge', 'c5-2xlarge', 'r5-large', 'h1-2xlarge']

df = pd.DataFrame()
df = pd.read_csv("./../results/memory_test_results_" + instances[0] + ".csv")
for instance in instances[1:]:
	df = pd.concat([df, pd.read_csv("./../results/memory_test_results_" + instance + ".csv")])
df["index"] = pd.Series(df.index, index=df.index)

g1 = sns.lineplot(data=df, x="index", y="brk", hue="instance")
plt.title("BRK test")
plt.savefig("memory_brk.png")
plt.close()

g2 = sns.lineplot(data=df, x="index", y="stack", hue="instance")
plt.title("Stack test")
plt.savefig("memory_stack.png")
plt.close()

g3 = sns.lineplot(data=df, x="index", y="bigheap", hue="instance")
plt.title("Bigheap test")
plt.savefig("memory_bigheap.png")
plt.close()
