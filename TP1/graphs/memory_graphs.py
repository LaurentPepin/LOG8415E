#!/usr/bin/env python3

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import sys
import shutil

instances = ['a1-large', 'c5-xlarge', 'c5-2xlarge', 'r5-large', 'h1-2xlarge']

# brk
for instance in instances:
		df = pd.read_csv("./../results/memory_test_results_" + instance + ".csv")
		plt.ylim(100000, 900000)
		g = sns.relplot(x="iteration", y="brk", kind="line", data=df)
		g.add_legend()
		plt.savefig('memory_graph_' + instance + "_brk.png")
# stack
for instance in instances:
		df = pd.read_csv("./../results/memory_test_results_" + instance + ".csv")
		plt.ylim(0, 500)
		g = sns.relplot(x="iteration", y="stack", kind="line", data=df)
		g.add_legend()
		plt.savefig('memory_graph_' + instance + "_stack.png")

# bigheap
for instance in instances:
		df = pd.read_csv("./../results/memory_test_results_" + instance + ".csv")
		plt.ylim(9000, 58000)
		g = sns.relplot(x="iteration", y="bigheap", kind="line", data=df)
		g.add_legend()
		plt.savefig('memory_graph_' + instance + "_bigheap.png")