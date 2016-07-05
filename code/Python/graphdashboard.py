#!/usr/bin/python
# -*- coding: utf-8 -*-

# Author: Evan Owen
# -------------------------------------------------------------------------------
# NEED THESE TO RUN THIS PROPERLY------------------------------------------------
# http://matplotlib.org/
# http://sourceforge.net/projects/numpy/files/NumPy/1.7.1/numpy-1.7.1-win32-superpack-python2.7.exe/download

import operator
import sys
import csv
import numpy as np
import os
import tempfile
os.environ['MPLCONFIGDIR'] = tempfile.mkdtemp()
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
import matplotlib.mlab as mlab
import zipfile

# -------------------------------------------------------------------------------
###GLOBAL_VARS___________________________________________________________________

savepath = None
filter = None


# -------------------------------------------------------------------------------
###FUNCTIONS____________________________________________________________________

# this function graphs each bar graph for each seperate command

def graph(dashboardcommand):
    print dashboardcommand.name
    if len(dashboardcommand.commands) > 0:

        fig = plt.figure()
        fig.set_size_inches(30, 4.5)
        N = 5
        createSQL = (dashboardcommand.avgCreateSQL,
                     dashboardcommand.medianCreateSQL,
                     dashboardcommand.rangeCreateSQL,
                     dashboardcommand.lowestCreateSQL,
                     dashboardcommand.highestCreateSQL)

        query = (dashboardcommand.avgQuery,
                 dashboardcommand.medianQuery,
                 dashboardcommand.rangeQuery,
                 dashboardcommand.lowestQuery,
                 dashboardcommand.highestQuery)

        createXML = (dashboardcommand.avgCreateXML,
                     dashboardcommand.medianCreateXML,
                     dashboardcommand.rangeCreateXML,
                     dashboardcommand.lowestCreateXML,
                     dashboardcommand.highestCreateXML)

        whole = (dashboardcommand.avgWhole,
                 dashboardcommand.medianWhole,
                 dashboardcommand.rangeWhole,
                 dashboardcommand.lowestWhole,
                 dashboardcommand.highestWhole)

        ind = np.arange(N)  # the x locations for the groups
        width = 0.35  # the width of the bars
        fig = plt.figure(figsize=(20, 9))
        ax = fig.add_subplot(111)

        rects1 = ax.bar(ind, createSQL, width, color='b')
        rects2 = ax.bar(ind, query, width, color='g', bottom=createSQL)
        rects3 = ax.bar(ind, createXML, width, color='y', bottom=query)
        rects4 = ax.bar(ind + width, whole, width, color='r')

    # add bars

        ax.set_ylabel('Time (msecs)')
        ax.set_title(dashboardcommand.name + ': x'
                     + str(len(dashboardcommand.commands)) + 'times')
        ax.set_xticks(ind + width)
        ax.set_xticklabels(('Average', 'Median', 'Range', 'Lowest',
                           'Highest'))

        ax.legend((rects1[0], rects2[0], rects3[0], rects4[0]),
                  ('Create SQL', 'Query', 'Create XML', 'Whole'), loc=4)

    # labelbars
    # attach some text labels

    for x in range(0, len(rects1)):

        sqls = rects1[x]
        sqlsheight = sqls.get_height()
        ax.text(sqls.get_x() + sqls.get_width() / 2., 12 + sqlsheight,
                '%d' % int(sqlsheight), ha='center', va='bottom')

        querys = rects2[x]
        querysheight = querys.get_height()
        fakequerysheight = querys.get_height()

        if sqlsheight + querysheight - sqlsheight < 100:
            fakequerysheight = 250 + querysheight

        ax.text(querys.get_x() + querys.get_width() / 2., 12
                + fakequerysheight + sqlsheight, '%d'
                % int(querysheight + sqlsheight), ha='center',
                va='bottom')

        xmls = rects3[x]
        xmlsheight = xmls.get_height()
        fakexmlsheight = xmls.get_height()

        if xmlsheight + fakequerysheight - querysheight < 100:
            fakexmlsheight = 250 + xmlsheight

        ax.text(xmls.get_x() + xmls.get_width() / 2., 12
                + fakequerysheight + sqlsheight + fakexmlsheight, '%d'
                % int(xmlsheight + querysheight + sqlsheight),
                ha='center', va='bottom')

    if rects4 is not None:

  # attach some text labels

        for rect in rects4:
            height = rect.get_height()
            ax.text(rect.get_x() + rect.get_width() / 2., 12 + height,
                    '%d' % int(height), ha='center', va='bottom')

    # plt.show()

    fig.savefig(savepath + '_' + dashboardcommand.commands[0].type
                + '.png', dpi=80)
    plt.close(fig)


# this function graphs all the commands in one bar graph by avg

def graphbar(
    GroupOpenRecords,
    RecordsIOwn,
    IssuesByProduct,
    SOFsByProduct,
    GroupSOFsByProduct,
    TPsByProduct,
    FAMeetingSOF,
    IssueClassByProduct,
    AssemblyClassByProduct,
    CauseClassByProduct,
    SourceSOF,
    CustomerRMA,
    CAPAsByCustomer,
    MyOpenRecs,
    ):

    N = 14
    createSQL = (
        GroupOpenRecords.avgCreateSQL,
        RecordsIOwn.avgCreateSQL,
        IssuesByProduct.avgCreateSQL,
        SOFsByProduct.avgCreateSQL,
        GroupSOFsByProduct.avgCreateSQL,
        TPsByProduct.avgCreateSQL,
        FAMeetingSOF.avgCreateSQL,
        IssueClassByProduct.avgCreateSQL,
        AssemblyClassByProduct.avgCreateSQL,
        CauseClassByProduct.avgCreateSQL,
        SourceSOF.avgCreateSQL,
        CustomerRMA.avgCreateSQL,
        CAPAsByCustomer.avgCreateSQL,
        MyOpenRecs.avgCreateSQL,
        )

    query = (
        GroupOpenRecords.avgQuery,
        RecordsIOwn.avgQuery,
        IssuesByProduct.avgQuery,
        SOFsByProduct.avgQuery,
        GroupSOFsByProduct.avgQuery,
        TPsByProduct.avgQuery,
        FAMeetingSOF.avgQuery,
        IssueClassByProduct.avgQuery,
        AssemblyClassByProduct.avgQuery,
        CauseClassByProduct.avgQuery,
        SourceSOF.avgQuery,
        CustomerRMA.avgQuery,
        CAPAsByCustomer.avgQuery,
        MyOpenRecs.avgQuery,
        )

    createXML = (
        GroupOpenRecords.avgCreateXML,
        RecordsIOwn.avgCreateXML,
        IssuesByProduct.avgCreateXML,
        SOFsByProduct.avgCreateXML,
        GroupSOFsByProduct.avgCreateXML,
        TPsByProduct.avgCreateXML,
        FAMeetingSOF.avgCreateXML,
        IssueClassByProduct.avgCreateXML,
        AssemblyClassByProduct.avgCreateXML,
        CauseClassByProduct.avgCreateXML,
        SourceSOF.avgCreateXML,
        CustomerRMA.avgCreateXML,
        CAPAsByCustomer.avgCreateXML,
        MyOpenRecs.avgCreateXML,
        )

    ind = np.arange(N)  # the x locations for the groups
    width = 0.35  # the width of the bars
    fig = plt.figure(figsize=(20, 9))
    ax = fig.add_subplot(111)

    # Set the title.

    ax.set_title('Average Time Taken By Command', fontsize=14)

  # Set the X Axis label.

    ax.set_xlabel('Commands', fontsize=12)

  # Set the Y Axis label.

    ax.set_ylabel('Time(msecs)', fontsize=12)

  # Display Grid.

    ax.grid(True, linestyle='-', color='0.75')

    rects1 = ax.bar(ind, createSQL, width, color='b')
    rects2 = ax.bar(ind, query, width, color='g', bottom=createSQL)
    rects3 = ax.bar(ind, createXML, width, color='y', bottom=query)

    x = [
        0.2,
        1.2,
        2.2,
        3.2,
        4.2,
        5.2,
        6.1,
        7.1,
        8.1,
        9.1,
        10.1,
        11.1,
        12.1,
        13.1,
        14.1,
        ]
    plt.xticks(np.arange(min(x), max(x), 1.0))

    group_labels = [
        'GOR',
        'RIO',
        'IBP',
        'SBP',
        'GBP',
        'TBP',
        'FMS',
        'ICBP',
        'ACBP',
        'CCBP',
        'SSOF',
        'CRMA',
        'CBC',
        'MOR',
        ]

    ax.set_xticklabels(group_labels)

  # label bars
      # attach some text labels

    for x in range(0, len(rects1)):

        sqls = rects1[x]
        sqlsheight = sqls.get_height()
        ax.text(sqls.get_x() + sqls.get_width() / 2., 12 + sqlsheight,
                '%d' % int(sqlsheight), ha='center', va='bottom')

        querys = rects2[x]
        querysheight = querys.get_height()
        fakequerysheight = querys.get_height()

        if sqlsheight + querysheight - sqlsheight < 100:
            fakequerysheight = 250 + querysheight

        ax.text(querys.get_x() + querys.get_width() / 2., 12
                + fakequerysheight + sqlsheight, '%d'
                % int(querysheight + sqlsheight), ha='center',
                va='bottom')

        xmls = rects3[x]
        xmlsheight = xmls.get_height()
        fakexmlsheight = xmls.get_height()

        if xmlsheight + fakequerysheight - querysheight < 100:
            fakexmlsheight = 250 + xmlsheight

        ax.text(xmls.get_x() + xmls.get_width() / 2., 12
                + fakequerysheight + sqlsheight + fakexmlsheight, '%d'
                % int(xmlsheight + querysheight + sqlsheight),
                ha='center', va='bottom')

    ax.legend((rects1[0], rects2[0], rects3[0]), ('Create SQL', 'Query'
              , 'Create XML'), loc=4)

  # plt.show()

    fig.savefig(savepath + '_AveragesCommand.png', dpi=80)
    plt.close(fig)


# this function graphs all the commands in one bar graph by avg

def graphtimes(
    GroupOpenRecords,
    RecordsIOwn,
    IssuesByProduct,
    SOFsByProduct,
    GroupSOFsByProduct,
    TPsByProduct,
    FAMeetingSOF,
    IssueClassByProduct,
    AssemblyClassByProduct,
    CauseClassByProduct,
    SourceSOF,
    CustomerRMA,
    CAPAsByCustomer,
    MyOpenRecs,
    ):

    N = 14

    times = (
        len(GroupOpenRecords.commands),
        len(RecordsIOwn.commands),
        len(IssuesByProduct.commands),
        len(SOFsByProduct.commands),
        len(GroupSOFsByProduct.commands),
        len(TPsByProduct.commands),
        len(FAMeetingSOF.commands),
        len(IssueClassByProduct.commands),
        len(AssemblyClassByProduct.commands),
        len(CauseClassByProduct.commands),
        len(SourceSOF.commands),
        len(CustomerRMA.commands),
        len(CAPAsByCustomer.commands),
        len(MyOpenRecs.commands),
        )

    ind = np.arange(N)  # the x locations for the groups
    width = 0.35  # the width of the bars
    fig = plt.figure(figsize=(20, 9))
    ax = fig.add_subplot(111)

    # Set the title.

    ax.set_title('Number Of Occurrences By Command', fontsize=14)

  # Set the X Axis label.

    ax.set_xlabel('Commands', fontsize=12)

  # Set the Y Axis label.

    ax.set_ylabel('Occurrences', fontsize=12)

  # Display Grid.

    ax.grid(True, linestyle='-', color='0.75')

    rects1 = ax.bar(ind, times, width, color='g')

    x = [
        0.2,
        1.2,
        2.2,
        3.2,
        4.2,
        5.2,
        6.1,
        7.1,
        8.1,
        9.1,
        10.1,
        11.1,
        12.1,
        13.1,
        14.1,
        ]
    plt.xticks(np.arange(min(x), max(x), 1.0))

    group_labels = [
        'GOR',
        'RIO',
        'IBP',
        'SBP',
        'GBP',
        'TBP',
        'FMS',
        'ICBP',
        'ACBP',
        'CCBP',
        'SSOF',
        'CRMA',
        'CBC',
        'MOR',
        ]

    ax.set_xticklabels(group_labels)

  # label bars
      # attach some text labels

    for x in range(0, len(rects1)):

        sqls = rects1[x]
        sqlsheight = sqls.get_height()
        ax.text(sqls.get_x() + sqls.get_width() / 2., 5 + sqlsheight,
                '%d' % int(sqlsheight), ha='center', va='bottom')

  # plt.show()

    fig.savefig(savepath + '_OccurrenceCommand.png', dpi=80)
    plt.close(fig)


# this function graphs the scatter plot by type (SQL,XML,WHOLE,QUERY)

def graphscatter(
    GroupOpenRecords,
    RecordsIOwn,
    IssuesByProduct,
    SOFsByProduct,
    GroupSOFsByProduct,
    TPsByProduct,
    FAMeetingSOF,
    IssueClassByProduct,
    AssemblyClassByProduct,
    CauseClassByProduct,
    SourceSOF,
    CustomerRMA,
    CAPAsByCustomer,
    MyOpenRecs,
    ):

    r = mlab.csv2rec(savepath + '_DashboardStats.csv')

  # Create a figure with size 20 x 8 inches.

    fig = Figure(figsize=(20, 8))

  # Create a canvas and add the figure to it.

    canvas = FigureCanvas(fig)

  # Create a subplot.

    ax = fig.add_subplot(111)

  # Set the title.

    ax.set_title('Whole vs Others', fontsize=14)

  # Set the X Axis label.

    ax.set_xlabel('Other Times (msecs)', fontsize=12)

  # Set the Y Axis label.

    ax.set_ylabel('Whole Time(msecs)', fontsize=12)

  # Display Grid.

    ax.grid(True, linestyle='-', color='0.75')

  # Generate the Scatter Plot.
  # ax.scatter(r.whole,r.query, c = z , marker = 'o', cmap = cm.jet)

    sql = ax.scatter(r.sql, r.whole, color='b')
    query = ax.scatter(r.query, r.whole, color='r')
    xml = ax.scatter(r.xml, r.whole, color='y')

    ax.legend((sql, query, xml), ('Create SQL', 'Query', 'Create XML'),
              loc=4)

  # Save the generated Scatter Plot to a PNG file.

    canvas.print_figure(savepath + '_WholeVsOthers.png', dpi=80)
    plt.close(fig)


# this function graphs scatter plot by dashboard command

def graphscattermethod(
    GroupOpenRecords,
    RecordsIOwn,
    IssuesByProduct,
    SOFsByProduct,
    GroupSOFsByProduct,
    TPsByProduct,
    FAMeetingSOF,
    IssueClassByProduct,
    AssemblyClassByProduct,
    CauseClassByProduct,
    SourceSOF,
    CustomerRMA,
    CAPAsByCustomer,
    MyOpenRecs,
    ):

  # Create a figure with size 20 x 8 inches.

    fig = Figure(figsize=(20, 8))

  # Create a canvas and add the figure to it.

    canvas = FigureCanvas(fig)

  # Create a subplot.

    ax = fig.add_subplot(111)

  # Set the title.

    ax.set_title('Whole vs Query by Method', fontsize=14)

  # Set the X Axis label.

    ax.set_xlabel(' Query Times (msecs)', fontsize=12)

  # Set the Y Axis label.

    ax.set_ylabel('Whole Time(msecs)', fontsize=12)

  # Display Grid.

    ax.grid(True, linestyle='-', color='0.75')

    GetGroupOpenRecords = ax.scatter(GroupOpenRecords.arrayQuery,
            GroupOpenRecords.arrayWhole, color='Black')
    GetRecordsIOwn = ax.scatter(RecordsIOwn.arrayQuery,
                                RecordsIOwn.arrayWhole, color='Gray')

    GetIssuesByProduct = ax.scatter(IssuesByProduct.arrayQuery,
                                    IssuesByProduct.arrayWhole,
                                    color='Maroon')
    GetSOFsByProduct = ax.scatter(SOFsByProduct.arrayQuery,
                                  SOFsByProduct.arrayWhole, color='Red')
    GetGroupSOFsByProduct = ax.scatter(GroupSOFsByProduct.arrayQuery,
            GroupSOFsByProduct.arrayWhole, color='Purple')
    GetTPsByProduct = ax.scatter(TPsByProduct.arrayQuery,
                                 TPsByProduct.arrayWhole,
                                 color='Fuchsia')
    GetFAMeetingSOF = ax.scatter(FAMeetingSOF.arrayQuery,
                                 FAMeetingSOF.arrayWhole, color='Green')
    GetIssueClassByProduct = ax.scatter(IssueClassByProduct.arrayQuery,
            IssueClassByProduct.arrayWhole, color='Lime')
    GetAssemblyClassByProduct = \
        ax.scatter(AssemblyClassByProduct.arrayQuery,
                   AssemblyClassByProduct.arrayWhole, color='Olive')
    GetCauseClassByProduct = ax.scatter(CauseClassByProduct.arrayQuery,
            CauseClassByProduct.arrayWhole, color='Tomato')

    GetSourceSOF = ax.scatter(SourceSOF.arrayQuery,
                              SourceSOF.arrayWhole, color='Navy')

    GetCustomerRMA = ax.scatter(CustomerRMA.arrayQuery,
                                CustomerRMA.arrayWhole, color='Teal')
    GetCAPAsByCustomer = ax.scatter(CAPAsByCustomer.arrayQuery,
                                    CAPAsByCustomer.arrayWhole,
                                    color='Aqua')
    GetMyOpenRecs = ax.scatter(MyOpenRecs.arrayQuery,
                               MyOpenRecs.arrayWhole,
                               color='YellowGreen')

    ax.legend((
        GetGroupOpenRecords,
        GetRecordsIOwn,
        GetIssuesByProduct,
        GetSOFsByProduct,
        GetGroupSOFsByProduct,
        GetTPsByProduct,
        GetFAMeetingSOF,
        GetIssueClassByProduct,
        GetAssemblyClassByProduct,
        GetCauseClassByProduct,
        GetSourceSOF,
        GetCustomerRMA,
        GetCAPAsByCustomer,
        GetMyOpenRecs,
        ), (
        'Group > Open Records',
        'Records I Own',
        'Issues by Product',
        'SOFs by Product',
        'Group SOFs by Product',
        'TPs by Product',
        'FA Meeting > SOF',
        'Issue Class By Product',
        'Assembly Class By Product',
        'Cause Class By Product',
        'Source > SOF',
        'Customer > RMA',
        'CAPAs by Customer',
        'My Open Records',
        ), loc=4)

  # Save the generated Scatter Plot to a PNG file.

    canvas.print_figure(savepath + '_WholeQuerybyMethod.png', dpi=80)
    plt.close(fig)


# -------------------------------------------------------------------------------
###CLASSES______________________________________________________________________

class DashboardCommands(object):

    def __init__(self):
        self.commands = []
        self.arraySQL = []
        self.arrayQuery = []
        self.arrayXML = []
        self.arrayWhole = []

        self.name = None
        self.avgCreateSQL = None
        self.avgQuery = None
        self.avgCreateXML = None
        self.avgWhole = None

        self.medianCreateSQL = None
        self.medianQuery = None
        self.medianCreateXML = None
        self.medianWhole = None

        self.rangeCreateSQL = None
        self.rangeQuery = None
        self.rangeCreateXML = None
        self.rangeWhole = None

        self.highestCreateSQL = None
        self.highestQuery = None
        self.highestCreateXML = None
        self.highestWhole = None

        self.lowestCreateSQL = None
        self.lowestQuery = None
        self.lowestCreateXML = None
        self.lowestWhole = None

        self.outfile = open(savepath + '_DashboardStats.txt', 'wb')

    def stats(self):

        if len(self.commands) > 0:
            for count in self.commands:
                self.arraySQL.append(count.createSQL)
                self.arrayQuery.append(count.query)
                self.arrayXML.append(count.createXML)
                self.arrayWhole.append(count.whole)

            self.lowestWhole = min(self.arrayWhole)
            self.highestWhole = max(self.arrayWhole)
            for x in range(0, len(self.arrayWhole)):
                if self.lowestWhole == self.arrayWhole[x]:
                    self.lowestQuery = self.arrayQuery[x]
                    self.lowestCreateXML = self.arrayXML[x]
                    self.lowestCreateSQL = self.arraySQL[x]

                if self.highestWhole == self.arrayWhole[x]:
                    self.highestQuery = self.arrayQuery[x]
                    self.highestCreateXML = self.arrayXML[x]
                    self.highestCreateSQL = self.arraySQL[x]

            self.rangeCreateSQL = abs(self.highestCreateSQL
                    - self.lowestCreateSQL)
            self.rangeQuery = abs(self.highestQuery - self.lowestQuery)
            self.rangeCreateXML = abs(self.highestCreateXML
                    - self.lowestCreateXML)
            self.rangeWhole = abs(self.highestWhole - self.lowestWhole)

            self.arraySQL = sorted(self.arraySQL)
            self.arrayQuery = sorted(self.arrayQuery)
            self.arrayXML = sorted(self.arrayXML)
            self.arrayWhole = sorted(self.arrayWhole)

            sqlLength = len(self.arraySQL)
            queryLength = len(self.arrayQuery)
            xmlLength = len(self.arrayXML)
            wholeLength = len(self.arrayWhole)

            self.medianCreateSQL = self.arraySQL[sqlLength / 2]
            self.medianQuery = self.arrayQuery[queryLength / 2]
            self.medianCreateXML = self.arrayXML[xmlLength / 2]
            self.medianWhole = self.arrayWhole[wholeLength / 2]

            self.avgCreateSQL = float(sum(self.arraySQL) / sqlLength)
            self.avgQuery = float(sum(self.arrayQuery) / queryLength)
            self.avgCreateXML = float(sum(self.arrayXML) / xmlLength)
            self.avgWhole = float(sum(self.arrayWhole) / wholeLength)

    def write(self, outfile):
        self.stats()

        outfile.write('\n' + self.name + '\n')
        outfile.write('   TIMES RAN: ' + str(len(self.commands)) + '\n'
                      + '\n')
        outfile.write('   Average Create SQL   : '
                      + str(self.avgCreateSQL) + ' msecs.' + '\n')
        outfile.write('   Average Query  DB    : ' + str(self.avgQuery)
                      + ' msecs.' + '\n')
        outfile.write('   Average Create XML   : '
                      + str(self.avgCreateXML) + ' msecs.' + '\n')
        outfile.write('   Average Create WHOLE : ' + str(self.avgWhole)
                      + ' msecs.' + '\n' + '\n')

        outfile.write('   Median Create SQL    : '
                      + str(self.medianCreateSQL) + ' msecs.' + '\n')
        outfile.write('   Median Query  DB     : '
                      + str(self.medianQuery) + ' msecs.' + '\n')
        outfile.write('   Median Create XML    : '
                      + str(self.medianCreateXML) + ' msecs.' + '\n')
        outfile.write('   Median Create WHOLE  : '
                      + str(self.medianWhole) + ' msecs.' + '\n' + '\n')

        outfile.write('   Range Create SQL     : '
                      + str(self.rangeCreateSQL) + ' msecs.' + '\n')
        outfile.write('   Range Query  DB      : '
                      + str(self.rangeQuery) + ' msecs.' + '\n')
        outfile.write('   Range Create XML     : '
                      + str(self.rangeCreateXML) + ' msecs.' + '\n')
        outfile.write('   Range Create WHOLE   : '
                      + str(self.rangeWhole) + ' msecs.' + '\n' + '\n')

        outfile.write('   Highest Create SQL   : '
                      + str(self.highestCreateSQL) + ' msecs.' + '\n')
        outfile.write('   Highest Query  DB    : '
                      + str(self.highestQuery) + ' msecs.' + '\n')
        outfile.write('   Highest Create XML   : '
                      + str(self.highestCreateXML) + ' msecs.' + '\n')
        outfile.write('   Highest Create WHOLE : '
                      + str(self.highestWhole) + ' msecs.' + '\n' + '\n'
                      )

        outfile.write('   Lowest Create SQL    : '
                      + str(self.lowestCreateSQL) + ' msecs.' + '\n')
        outfile.write('   Lowest Query  DB     : '
                      + str(self.lowestQuery) + ' msecs.' + '\n')
        outfile.write('   Lowest Create XML    : '
                      + str(self.lowestCreateXML) + ' msecs.' + '\n')
        outfile.write('   Lowest Create WHOLE  : '
                      + str(self.lowestWhole) + ' msecs.' + '\n' + '\n')


class Command(object):

    def __init__(
        self,
        type=None,
        createSQL=None,
        query=None,
        createXML=None,
        whole=None,
        ):
        self.type = type
        self.createSQL = createSQL
        self.query = query
        self.createXML = createXML
        self.whole = whole


# -------------------------------------------------------------------------------
###MAIN_________________________________________________________________________........

def main(*args):

    # ##ARGS_PATH__________________________________________________________________  ....

    for a in args:
        print a

    global savepath
    if 'DEV' in args[0]:
        savepath = './static/DEV/'
    elif 'PROD' in args[0]:
        savepath = './static/PROD/'
    else:
        savepath = './static/TEST/'

    # ##CLASS_INSTANCES______________________________________________________________
    # Drive Tracking

    GroupOpenRecords = DashboardCommands()  # GOR
    RecordsIOwn = DashboardCommands()  # RIO

    # Product

    IssuesByProduct = DashboardCommands()  # IBP
    SOFsByProduct = DashboardCommands()  # SBP
    GroupSOFsByProduct = DashboardCommands()  # GBP
    TPsByProduct = DashboardCommands()  # TBP
    FAMeetingSOF = DashboardCommands()  # FMS
    IssueClassByProduct = DashboardCommands()  # ICBP
    AssemblyClassByProduct = DashboardCommands()  # ACBP
    CauseClassByProduct = DashboardCommands()  # CCBP

    # Generasl

    SourceSOF = DashboardCommands()  # SSOF

    # Customer

    CustomerRMA = DashboardCommands()  # CRMA
    CAPAsByCustomer = DashboardCommands()  # CBC

    # Hidden

    MyOpenRecs = DashboardCommands()  # MOR

    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    # ##EXAMPLE_INPUT________________________________________________________________
    # 2013-06-13 12:33:09,268 INFO  [Dashboards] - ea315ace-da90-42e9-b60d-ff2856311123 - 509491 - SQL WAS CREATED:....Time/webfacts.beans.GetRecsIOwnView/1/41.632666 msec.
    # 2013-06-13 12:33:14,690 INFO  [Dashboards] - ea315ace-da90-42e9-b60d-ff2856311123 - 509491 - Query Database:....Time/webfacts.beans.GetRecsIOwnView/2/5413.10837 msec.
    # 2013-06-13 12:33:14,690 INFO  [Dashboards] - ea315ace-da90-42e9-b60d-ff2856311123 - 509491 - Execute and build xml:....Time/webfacts.GetRecsIOwnCommand/3/0.8489909999999999 msec.
    # 2013-06-13 12:33:14,690 INFO  [Dashboards] - ea315ace-da90-42e9-b60d-ff2856311123 - 509491 - Executed:....Time/webfacts.GetRecsIOwnCommand/4/5465.4650249999995 msec.

    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    # ##I/O__________________________________________________________________________

    lastMethod = None
    lastNumber = '0'
    sql = None
    query = None
    xml = None
    whole = None
    ids = []

    # get UUIDS of each command

    with open(savepath + 'Dashboards.log', 'r') as readfile:
        for line in readfile:
            if ' - ' in line and 'Time/' in line:
                id = line.split('[Dashboards] - ')[1]
                id = id[:36]
                if id not in ids:
                    ids.append(id)
    readfile.closed

    # print ids

    with open(savepath + '_DashboardStats.csv', 'wb') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')
        data = [['COMMAND', 'SQL', 'QUERY', 'XML', 'WHOLE']]
        writer.writerows(data)
        for id in ids:
            with open(savepath + 'Dashboards.log', 'r') as readfile:
                data = []
                for line in readfile:
                    if id == line[45:81]:

                  # check to see if it was in temp

                        line = line.split('Time/')[1]
                        array = line.split('/')
                        tempstr = array[0]
                        if array[1] in '1':
                            position = tempstr.rfind('.')
                            lastMethod = tempstr[position
                                + 1:len(tempstr) - 4]

                    # lastMethod = array[0].split("View")[0]
                    # lastMethod = lastMethod.split("webfacts.beans.")[1]

                            sql = float(array[2].split(' ')[0])
                            query = None
                            xml = None
                            whole = None
                        elif lastNumber == '1' and array[1] == '2':

                            query = float(array[2].split(' ')[0])
                        elif lastNumber == '2' and array[1] == '3':

                            xml = float(array[2].split(' ')[0])
                        elif lastNumber == '3' and array[1] == '4':

                            whole = float(array[2].split(' ')[0])
                            lastNumber = '0'

                        # only allow full commmands (gets rid of skipping around)

                            if whole >= sql + xml + query:

                          # add to csv

                                data += [(lastMethod, sql, query, xml,
                                        whole)]

                          # make command && add it to the correct class instance

                                temp = Command(lastMethod, sql, query,
                                        xml, whole)

                          # add it to proper class

                                if 'GetMyOpenRecsByGrp' in tempstr:
                                    GroupOpenRecords.commands.append(temp)
                                elif 'GetRecsIOwn' in tempstr:
                                    RecordsIOwn.commands.append(temp)
                                elif 'GetAllIssuesByProduct' in tempstr:
                                    IssuesByProduct.commands.append(temp)
                                elif 'GetAllSOFsByProduct' in tempstr:
                                    SOFsByProduct.commands.append(temp)
                                elif 'GetAllGPSOFsByProduct' in tempstr:
                                    GroupSOFsByProduct.commands.append(temp)
                                elif 'GetAllTPsByProduct' in tempstr:
                                    TPsByProduct.commands.append(temp)
                                elif 'GetFAMeetingSOF' in tempstr:
                                    FAMeetingSOF.commands.append(temp)
                                elif 'GetIssuesClassByProduct' \
                                    in tempstr:
                                    IssueClassByProduct.commands.append(temp)
                                elif 'GetAssemblyClassByProduct' \
                                    in tempstr:
                                    AssemblyClassByProduct.commands.append(temp)
                                elif 'GetCauseClassByProduct' \
                                    in tempstr:
                                    CauseClassByProduct.commands.append(temp)
                                elif 'GetAllSOFsByProdAndSrc' \
                                    in tempstr:
                                    SourceSOF.commands.append(temp)
                                elif 'GetAllRMAsByCustomer' in tempstr:
                                    CustomerRMA.commands.append(temp)
                                elif 'GetAllCAPAsByCustomer' in tempstr:
                                    CAPAsByCustomer.commands.append(temp)
                                elif 'GetMyOpenRecs' in tempstr:
                                    MyOpenRecs.commands.append(temp)
                            break  # breaking here to stop reading through file

                        if lastNumber != '0' or array[1] == '1':
                            lastNumber = array[1]

              # output to DashboardStats.csv

            writer.writerows(data)

    readfile.closed
    csvfile.closed

    print 'reading done'

    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------
    # ##Output_to_DashboardStats.txt_________________________________________________

    with open(savepath + '_DashboardStats.txt', 'w') as outfile:
        GroupOpenRecords.name = 'Group > Open Records'
        GroupOpenRecords.write(outfile)
        graph(GroupOpenRecords)

        RecordsIOwn.name = 'Records I Own'
        RecordsIOwn.write(outfile)
        graph(RecordsIOwn)

        IssuesByProduct.name = 'Issues by Product'
        IssuesByProduct.write(outfile)
        graph(IssuesByProduct)

        SOFsByProduct.name = 'SOFs by Product'
        SOFsByProduct.write(outfile)
        graph(SOFsByProduct)

        GroupSOFsByProduct.name = 'Group SOFs by Product'
        GroupSOFsByProduct.write(outfile)
        graph(GroupSOFsByProduct)

        TPsByProduct.name = 'TPs by Product'
        TPsByProduct.write(outfile)
        graph(TPsByProduct)

        FAMeetingSOF.name = 'FA Meeting > SOF'
        FAMeetingSOF.write(outfile)
        graph(FAMeetingSOF)

        IssueClassByProduct.name = 'Issue Class By Product'
        IssueClassByProduct.write(outfile)
        graph(IssueClassByProduct)

        AssemblyClassByProduct.name = 'Assembly Class By Product'
        AssemblyClassByProduct.write(outfile)
        graph(AssemblyClassByProduct)

        CauseClassByProduct.name = 'Cause Class By Product'
        CauseClassByProduct.write(outfile)
        graph(CauseClassByProduct)

        SourceSOF.name = 'Source > SOF'
        SourceSOF.write(outfile)
        graph(SourceSOF)

        CustomerRMA.name = 'Customer > RMA'
        CustomerRMA.write(outfile)
        graph(CustomerRMA)

        CAPAsByCustomer.name = 'CAPAs by Customer'
        CAPAsByCustomer.write(outfile)
        graph(CAPAsByCustomer)

        MyOpenRecs.name = 'My Open Records'
        MyOpenRecs.write(outfile)
        graph(MyOpenRecs)

      # really long method signature b.c globals disappeared

        graphscatter(
            GroupOpenRecords,
            RecordsIOwn,
            IssuesByProduct,
            SOFsByProduct,
            GroupSOFsByProduct,
            TPsByProduct,
            FAMeetingSOF,
            IssueClassByProduct,
            AssemblyClassByProduct,
            CauseClassByProduct,
            SourceSOF,
            CustomerRMA,
            CAPAsByCustomer,
            MyOpenRecs,
            )

        graphscattermethod(
            GroupOpenRecords,
            RecordsIOwn,
            IssuesByProduct,
            SOFsByProduct,
            GroupSOFsByProduct,
            TPsByProduct,
            FAMeetingSOF,
            IssueClassByProduct,
            AssemblyClassByProduct,
            CauseClassByProduct,
            SourceSOF,
            CustomerRMA,
            CAPAsByCustomer,
            MyOpenRecs,
            )

        graphbar(
            GroupOpenRecords,
            RecordsIOwn,
            IssuesByProduct,
            SOFsByProduct,
            GroupSOFsByProduct,
            TPsByProduct,
            FAMeetingSOF,
            IssueClassByProduct,
            AssemblyClassByProduct,
            CauseClassByProduct,
            SourceSOF,
            CustomerRMA,
            CAPAsByCustomer,
            MyOpenRecs,
            )

        graphtimes(
            GroupOpenRecords,
            RecordsIOwn,
            IssuesByProduct,
            SOFsByProduct,
            GroupSOFsByProduct,
            TPsByProduct,
            FAMeetingSOF,
            IssueClassByProduct,
            AssemblyClassByProduct,
            CauseClassByProduct,
            SourceSOF,
            CustomerRMA,
            CAPAsByCustomer,
            MyOpenRecs,
            )

    outfile.closed
    plt.close('all')

    # Create the ZIP file

    print 'zipping files'

    zf = zipfile.ZipFile('./static/' + args[0] + '_' + args[1] + '_'
                         + 'graphs.zip', 'w')
    for (dirname, subdirs, files) in os.walk(savepath):
        zf.write(dirname)
        for filename in files:
            zf.write(os.path.join(dirname, filename))
    zf.close()

    print 'finished'


# since it is a script this calls the main....when in terminal "magical"....

if __name__ == '__main__':
    main(sys.argv)


			
