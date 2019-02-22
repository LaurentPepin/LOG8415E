#!/usr/bin/env python3

import sys
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
prefix = './../results/cpu_results_'
postfix = '.csv'
instances = ['a1-large', 'c5-2xlarge', 'c5-xlarge', 'h1-2xlarge', 'r5-large']

# create dataset with all iops results from all instances
df = pd.DataFrame()
df = pd.read_csv(prefix + instances[0] + ".csv")
for instance in instances[1:]:
    df = pd.concat([df, pd.read_csv(prefix + instance + postfix)])

print(df)

# Create 1 graph per measure (3 graphs)
outputFolder = './cpu/'
measures = ['time']
for measure in measures:
    g = sns.lineplot(data=df, x="iteration", y=measure,
                     hue="instance", marker='o')
    plt.title("Variation of " + measure.lstrip() +
              " over 5 iterations", y=1.08)
    plt.xticks([1, 2, 3, 4, 5])
    plt.ylabel(measure + ' (s)')
    plt.xlabel("Iteration")
    plt.subplots_adjust(right=0.75)
    plt.legend(loc='center left', bbox_to_anchor=(1, 0.5))
    plt.savefig(outputFolder + measure.lstrip() + '.png')
    plt.close()

# Create 6 bar graph comparing instances average performances for each measure
# Modify dataframe to means
df = df.groupby(['instance']).mean().reset_index()
print(df)
for measure in measures:
    g = sns.barplot(x='instance', y=measure, data=df)
    plt.ylabel(measure + ' (s)')
    plt.xlabel("Instance")
    plt.title("Average value of " + measure.lstrip() +
              " over 5 iterations for each instance", y=1.08)
    plt.savefig(outputFolder + 'average_' + measure.lstrip() + '.png')
    plt.close()
