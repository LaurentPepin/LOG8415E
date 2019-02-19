#!/usr/bin/env python3

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import sys
import shutil

instances = ['a1-large', 'c5-xlarge', 'c5-2xlarge', 'r5-large', 'h1-2xlarge']

#generate cpu results graph for each instance
for instance in instances:
    df = pd.read_csv("./../results/cpu_results_" + instance + ".csv")
    g = sns.relplot(x="iteration", y="time", kind="line", data=df)
    g.add_legend()
    plt.savefig('cpu_graph_' + instance +'.png')

    # resultsSet = []
    # for i in range(1,4):
    #     df = pd.read_csv("./../results/raw/" + algo + "_" + str(i) + ".csv")
    #     resultsSet.append(df)
    # mergeDf = pd.concat(resultsSet)
    # mergeDf = mergeDf.sort_values(by=['taille'])
    # g = sns.FacetGrid(mergeDf, col='serie')
    # g = g.map(plt.plot, 'taille', 'temps')
    # g.set(xscale='log')
    # g.set(yscale='log')
    # g.add_legend()
    # plt.savefig(algo + '_test_puissance.png')
    # shutil.move(algo + "_test_puissance.png", "./../results/graphs/")
