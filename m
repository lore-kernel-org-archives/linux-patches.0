Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CC8257E
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AEE132114E
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 88C2D13A96
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id gWZcH2VnE2KyIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <3404f540-052b-d976-fa6d-b1724d246327@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id GDO4BjBkDWLwMAAAMHmgww
	(envelope-from <prvs=3046c06256=guro@fb.com>)
	for <vbabka>; Wed, 16 Feb 2022 20:53:04 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id KJa0BTBkDWIoGQAApTUePA
	(envelope-from <prvs=3046c06256=guro@fb.com>)
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 20:53:04 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id 0D2FFA3B8B
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 20:53:04 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: -0.109
X-Spam-Level:
X-Spam-Status: No, score=-0.109 tagged_above=-9999 required=5
	tests=[BAYES_50=0.8, DKIMWL_WL_HIGH=-0.001, DKIM_SIGNED=0.1,
	DKIM_VALID=-0.1, DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1,
	RCVD_IN_DNSWL_LOW=-0.7, RCVD_IN_MSPIKE_H3=0.001,
	RCVD_IN_MSPIKE_WL=0.001, T_SCC_BODY_TEXT_LINE=-0.01]
	autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vMSh2wgQeJcS for <vbabka@imap.suse.de>;
	Wed, 16 Feb 2022 20:52:58 +0000 (UTC)
Received: from mx2.suse.de (unknown [149.44.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 49402A3B84
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 20:52:58 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTPS id CFD8FAD43
	for <vbabka@suse.cz>; Wed, 16 Feb 2022 20:52:57 +0000 (UTC)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21GK4G8F028305;
	Wed, 16 Feb 2022 12:52:42 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e92mq35nv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 16 Feb 2022 12:52:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 12:52:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQdHi7e/T9y8A5FDIl9PK9zmAwLr9HAXAPXpzGGaAOOdkUmi6gBsgbzUopJ8pj4A998ZIduUGA/QG4C5iTIrIj7Ol0WEdDUZEsx41sTqKngKGPVC5sZ7w6aac/U3XJ6oKWCLu0X0pcLTwa/ckV8bryhV8boCjM00REPxQHKpQarYm0Ze7TpjKaRaqIynt6ZOe7C2HT95E/U098aPGM0uzbidc3UId9/tap3TdnEBk6qKe149tLQMAiim5EMu2zI04zxAyQUWpVHZp2EPphrnrAhvNzztUwMlHfMYKa7bo4RvJCoR3FnJua0KCXzPO68ipCDQoSN4EnCcl/gnNOYV4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCmjVNqfo1l5YOcHUx7LgpEAJNRMTtOVLB2/JLmFDgw=;
 b=CCWIrIWetGSkHcJAWsyHbbBZwLniuByTOzijHpmKFGv6Yv2FTf4cMdKRQAf9h6JQLAIA8eLYfSVvengpvsmPl21AKWWONYH18EO8ckPA/fMuSSaufOY2Ki15XfcB9WFZYHB6+IIvzP2+adPWFFGDqQC7UNgetOhZKDZHvbhr32rzPvBzEhX7nPh9qWaIURiD6oH8djrdvPxKTrVxBujcCZQ9SxrwC1SXVMSGFgfZDPr6OtcZAor5q3WYBK4x0Q3x042cLV1IGsQ4baJMPRgj54m2RnRIK2woYwJhtqfJRpz3j5jdx54OEjStuUG2wL5qzhjC/+VaoZ45WcT2AFaRHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by PH0PR15MB4624.namprd15.prod.outlook.com (2603:10b6:510:8c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Wed, 16 Feb
 2022 20:52:40 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c%5]) with mapi id 15.20.4995.014; Wed, 16 Feb 2022
 20:52:40 +0000
Date: Wed, 16 Feb 2022 12:52:36 -0800
From: Roman Gushchin <guro@fb.com>
To: Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton
	<akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
 <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
X-ClientProxiedBy: MW4P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::32) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2be74515-d45b-42d0-b78f-08d9f18e450f
X-MS-TrafficTypeDiagnostic: PH0PR15MB4624:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB462425E0AC43B73C64806575BE359@PH0PR15MB4624.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a7PQa5ePd3F6gG2+F4TTRo2nvjdGv+RA1NaE7SKUOiMsePBhZYNBQ1h4EfG2t5L+hFGlwVAMMCAgj4wo0QYHeyzSqjT2v+nImiQpccwq6BFIdq7h7WtA/2dRRgTm/OWqKv8/d9es2Sa7IvKgXD0XymQBu77O9gBjllbQLAQ/OCUhwBDStSjpcAou4K/8eS/p9A/2iDq4oeZbPsakIapQLq2JPx04BVnXN9vdTTs1U14jNVvjcbdnUk/0UFxiKdG+awqaaj7P9Ba/DD9xFUYbhHEWOgP69Ep0kD26zt1xpXi+68Qlb+TGBtlPq4QRVxRYfZjnChQdMTy81xDvhitOBYEYkbjka8vw8TH/b0LJtaxQWKF/lnm0L4fXoXqi7hSrbG6czFGjCwsZMU3EJGTA6r2VqtYIOebgQVB9dvtSZ8lABMaaTaV91VgqDhs3rOtvWtG5RjEesKj8waBR1XhBxqQXpCtXFlHFT5sEg6HLVvz52k+5oJHegUTadFr+t159LhoT5UL2Sp7++DnhBj8bM1ww3HLlgObQVXsCc1O7Oa2RFLi9kRENn7AcPRhrBfi/s68fivTD0mQafW7cvHhY5PszvQangoNlOkqkY4rjzhhz5jYMi/jOidx2QSmmqOfPP+knDcD7976uAkJ6jidZPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(66946007)(9686003)(86362001)(6512007)(66556008)(8676002)(6506007)(508600001)(66476007)(54906003)(53546011)(6486002)(110136005)(52116002)(6666004)(83380400001)(186003)(4326008)(38100700002)(5660300002)(8936002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/yfwtUZzjwuEWZ1HJWG/+IAWHXZIBF6Yyxf+7HQFH0ICBuUAp6xyQwAyp1Gx?=
 =?us-ascii?Q?BsogJVmb74HaJ0WBOowhq24bRgFdCcRGR+TF4tjhpLb4mOLNRx9us2MJzPNK?=
 =?us-ascii?Q?ksRNrh23lchjkhfRchAFGJ0ezvVddwiglmCL9VGeB15+n+WUvkXlYJu4WXoZ?=
 =?us-ascii?Q?8T4FO3G8azpvpBRtIICm3xQj1qtYJVY2u88GYCPBG7hkLokUfJTloxpw4Lnn?=
 =?us-ascii?Q?F0nf7qXsy2UMQ3AfGnBUz6B3NNThiiYdCRi0R064k8SplX8fGMPqj5IDLNV5?=
 =?us-ascii?Q?0TiOl1AMAksIqD1/+UrfwhDjLyH1tjnPNa0evyVptYjIzpROFK+1seUj6xfq?=
 =?us-ascii?Q?4/7XVe15H+iozm0WD4t1kTaNbVn/UPQQe430N4pEncSO1u/4apsHEYoYH/OD?=
 =?us-ascii?Q?ypAUh5QpqLcfN5IsDQNOmJyTL/IJwSDlOj9JaJOJN0oxk8SCEQaCfDkZhb9x?=
 =?us-ascii?Q?UAkLsF0NY9Kf77Pug73sMSe4e0VRQ+QuPsjeSp92llJvA9xigfG0K0nFYUtY?=
 =?us-ascii?Q?ZsIBo2wrIHBKr/HsTtlKtGq0SMO476Bl7+OoGoG1jqp5x/5L60X72qcOuHe8?=
 =?us-ascii?Q?eOTgZxQzSjjEaORoTvwXrCJxdBQeHfSMxm+Kokne3wwOabd3zAD6NVbX0XYu?=
 =?us-ascii?Q?E/FgxDH8rbzHirrput5WF9XTX2YuBOJOUlFMRZL+8fHqIrELujhpwr+tAqYU?=
 =?us-ascii?Q?SazYu+BieDEqrP+by6jPp4hbekknl7FTn+okTUV+1fDUtKrRLFN1ZsuPO2VC?=
 =?us-ascii?Q?OIkrJBgfW87H71NOUp3VwNH0vs09d9GDZJOI75m5R5tTu2qkDFWy0qZl0syA?=
 =?us-ascii?Q?SO73VhEAWeulX41O2z4bJR4qj2vtQIqLttjzKVl4ArjfaF8MUxezocM/tQ4k?=
 =?us-ascii?Q?iU1o7x2mHRrmfdD8/bcZHbFgmiT5aYzy9sSmL1AHScZO9EX4qliaW/k9WDWd?=
 =?us-ascii?Q?UzqDc+8w5e0qr7HlAMfepb3edipf17ajV+6CHH5pRUg5+SiPUCJXlcqVxv7j?=
 =?us-ascii?Q?8+K3xLKdqrnvtgTK9Ch44yxS4Ua3Z+q/RY2YBuj95MKvuhXfIUGX/dnKr08a?=
 =?us-ascii?Q?M2XP4BxRzYIaUkKdIJmVXyc6pVFnRXHr3E5BDpu9HoOzup7O/o5ePjoMuBwo?=
 =?us-ascii?Q?KxfVJOQaoE828ZqVKNf+rqvLXzHmWIhrQd9gJk8Rcofg61M7kjagspjEtCuQ?=
 =?us-ascii?Q?nacHzN3pLv3vSsG/BE26gTIF3XLaofgIu8gQLt8xtD+OMAYze2NBwLDkbmJB?=
 =?us-ascii?Q?SeYRhcuNEHd8Um8l1ZSXOnEjgsufHC6YIonMwZrW0UJAfNsmysXNLjo6WVwW?=
 =?us-ascii?Q?umyMU/4fK9WHTWrV5IxKd03e6vtzQn/u4Nci2oKobDCc0xpnzp2c8UJVIhGZ?=
 =?us-ascii?Q?4vEI/QowEKNfdpf00KJ18xv+YPHQy/tCPG/dV6HyYjDxQ3BcfyTadIfzPGBu?=
 =?us-ascii?Q?MClUymZpY5oCSfQcLvYomJ67lil+aJrXp6r6BEeh9wdYkFGRH+X4OvrKJEAV?=
 =?us-ascii?Q?fjZMS1Tqy0xaxPZaS6uQmrzJzXrikyOxpOBJj35nUFSt94HchQYiIOyGnCPL?=
 =?us-ascii?Q?NnTPWy6z8ULLYsyJ2H8wkB3sL/0odSl4afflhbMi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be74515-d45b-42d0-b78f-08d9f18e450f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 20:52:39.9537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjjDL5neWfiI9ztHty5ehuWS0uTBILiauNlo9UUJ1cTC6M+lqMWe5tyAXWkJJnFL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4624
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: fZYVcesjql-32Zl28V6weRbTF2-Ze2Zj
X-Proofpoint-ORIG-GUID: fZYVcesjql-32Zl28V6weRbTF2-Ze2Zj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_09,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 mlxlogscore=946
 suspectscore=0 clxscore=1015 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160113
X-FB-Internal: deliver

On Wed, Feb 16, 2022 at 10:47:35AM +0300, Vasily Averin wrote:
> One or more of the originally attached files triggered the rule module.access.rule.exestrip_notify
> 
> The following attachments were deleted from the original message.
> diff-memcg-slabinfo.py

Sorry, I haven't received it.

Anyway, can you, please, test the following patch?

Thanks!

--

From b649752a0b6de605ce4ba4be73ddf99ea7dd1d5c Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Wed, 16 Feb 2022 12:43:30 -0800
Subject: [PATCH] tools/cgroup/slabinfo: update to work with struct slab

After the introduction of the dedicated struct slab to describe slab
pages by commit d122019bf061 ("mm: Split slab into its own type") and
the following removal of the corresponding struct page's fields by
commit 07f910f9b729 ("mm: Remove slab from struct page") the
memcg_slabinfo tool broke. An attempt to run it produces a trace like
this:
Traceback (most recent call last):
  File "/usr/bin/drgn", line 33, in <module>
    sys.exit(load_entry_point('drgn==0.0.16', 'console_scripts', 'drgn')())
  File "/usr/lib64/python3.9/site-packages/drgn/internal/cli.py", line 133, in main
    runpy.run_path(args.script[0], init_globals=init_globals, run_name="__main__")
  File "/usr/lib64/python3.9/runpy.py", line 268, in run_path
    return _run_module_code(code, init_globals, run_name,
  File "/usr/lib64/python3.9/runpy.py", line 97, in _run_module_code
    _run_code(code, mod_globals, init_globals,
  File "/usr/lib64/python3.9/runpy.py", line 87, in _run_code
    exec(code, run_globals)
  File "memcg_slabinfo.py", line 226, in <module>
    main()
  File "memcg_slabinfo.py", line 199, in main
    cache = page.slab_cache
AttributeError: 'struct page' has no member 'slab_cache'

The problem can be fixed by explicitly casting struct page * to struct
slab * for slab pages. The tools works as expected with this fix, e.g.:

cred_jar             776    776    192   21    1 : tunables    0    0    0 : slabdata    547    547      0
kmalloc-cg-32          6      6     32  128    1 : tunables    0    0    0 : slabdata      9      9      0
files_cache            3      3    832   39    8 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-cg-512         1      1    512   32    4 : tunables    0    0    0 : slabdata     10     10      0
task_struct           10     10   6720    4    8 : tunables    0    0    0 : slabdata     63     63      0
mm_struct              3      3   1664   19    8 : tunables    0    0    0 : slabdata      9      9      0
kmalloc-cg-16          1      1     16  256    1 : tunables    0    0    0 : slabdata      8      8      0
pde_opener             1      1     40  102    1 : tunables    0    0    0 : slabdata      8      8      0
anon_vma_chain       375    375     64   64    1 : tunables    0    0    0 : slabdata     81     81      0
radix_tree_node        3      3    584   28    4 : tunables    0    0    0 : slabdata    419    419      0
dentry                98     98    312   26    2 : tunables    0    0    0 : slabdata   1420   1420      0
btrfs_inode            3      3   2368   13    8 : tunables    0    0    0 : slabdata    730    730      0
signal_cache           3      3   1600   20    8 : tunables    0    0    0 : slabdata     17     17      0
sighand_cache          3      3   2240   14    8 : tunables    0    0    0 : slabdata     20     20      0
filp                  90     90    512   32    4 : tunables    0    0    0 : slabdata     95     95      0
anon_vma             214    214    200   20    1 : tunables    0    0    0 : slabdata    162    162      0
kmalloc-cg-1k          1      1   1024   32    8 : tunables    0    0    0 : slabdata     22     22      0
pid                   10     10    256   32    2 : tunables    0    0    0 : slabdata     14     14      0
kmalloc-cg-64          2      2     64   64    1 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-cg-96          3      3     96   42    1 : tunables    0    0    0 : slabdata      8      8      0
sock_inode_cache       5      5   1408   23    8 : tunables    0    0    0 : slabdata     29     29      0
UNIX                   7      7   1920   17    8 : tunables    0    0    0 : slabdata     21     21      0
inode_cache           36     36   1152   28    8 : tunables    0    0    0 : slabdata    680    680      0
proc_inode_cache      26     26   1224   26    8 : tunables    0    0    0 : slabdata     64     64      0
kmalloc-cg-2k          2      2   2048   16    8 : tunables    0    0    0 : slabdata      9      9      0

Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Vasily Averin <vvs@virtuozzo.com>
---
 tools/cgroup/memcg_slabinfo.py | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/cgroup/memcg_slabinfo.py b/tools/cgroup/memcg_slabinfo.py
index 1600b17dbb8a..a6b609f2d5d6 100644
--- a/tools/cgroup/memcg_slabinfo.py
+++ b/tools/cgroup/memcg_slabinfo.py
@@ -11,7 +11,7 @@ from drgn.helpers.linux import list_for_each_entry, list_empty
 from drgn.helpers.linux import for_each_page
 from drgn.helpers.linux.cpumask import for_each_online_cpu
 from drgn.helpers.linux.percpu import per_cpu_ptr
-from drgn import container_of, FaultError, Object
+from drgn import container_of, FaultError, Object, cast
 
 
 DESC = """
@@ -77,7 +77,8 @@ def count_partial(n, fn):
 
 
 def count_free(page):
-    return page.objects - page.inuse
+    slab = cast('struct slab *', page)
+    return slab.objects - slab.inuse
 
 
 def slub_get_slabinfo(s, cfg):
@@ -193,10 +194,11 @@ def main():
         # look over all slab pages, belonging to non-root memcgs
         # and look for objects belonging to the given memory cgroup
         for page in for_each_slab_page(prog):
-            objcg_vec_raw = page.memcg_data.value_()
+            slab = cast('struct slab *', page)
+            objcg_vec_raw = slab.memcg_data.value_()
             if objcg_vec_raw == 0:
                 continue
-            cache = page.slab_cache
+            cache = slab.slab_cache
             if not cache:
                 continue
             addr = cache.value_()
-- 
2.34.1

