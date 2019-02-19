import sys
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt

prefix = './../results/iops_test_results_'
postfix = '.csv'
instances = ['a1-large', 'c5-2xlarge', 'c5-xlarge', 'h1-2xlarge', 'r5-large']

for instance in instances:
    df = pd.read_csv(prefix+instance+postfix)
    df = df.drop(columns=['Instance', 'numFiles', 'sequentialCreateCPU%', 'sequentialReadCPU%', 'sequentialDeleteCPU%', 'randomCreateCPU%', 'randomReadCPU%', 'randomDeleteCPU%',
                          ' sequentialCreateLatency', 'sequentialReadLatency', 'sequentialDeleteLatency', 'randomCreateLatency', 'randomReadLatency', ' randomDeleteLatency'])
    print(df)
    df = df.melt('iteration', var_name='Test',  value_name='ops/sec')
    g = sns.factorplot(x='iteration', y='ops/sec', hue='Test', data=df)

    outputFile = './iops/graph_'+instance
    plt.savefig(outputFile)
