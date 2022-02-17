Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220E1257F
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 96B962114D
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7B38D13A95
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id tdW8HGVnE2KtIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <3811f654-576e-8766-b35f-c65e192682ae@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id 0NVUD1OcDWJuBQAAMHmgww
	(envelope-from <prvs=30472c63f5=guro@fb.com>)
	for <vbabka>; Thu, 17 Feb 2022 00:52:35 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id OIU0DlOcDWJXQQAApTUePA
	(envelope-from <prvs=30472c63f5=guro@fb.com>)
	for <vbabka@imap.suse.de>; Thu, 17 Feb 2022 00:52:35 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id 2D299A3B84
	for <vbabka@imap.suse.de>; Thu, 17 Feb 2022 00:52:35 +0000 (UTC)
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
	with ESMTP id awYH3pGDrrGV for <vbabka@imap.suse.de>;
	Thu, 17 Feb 2022 00:52:29 +0000 (UTC)
Received: from mx1.suse.de (unknown [149.44.161.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 59957A3B81
	for <vbabka@imap.suse.de>; Thu, 17 Feb 2022 00:52:29 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTPS id 094A0AB87
	for <vbabka@suse.cz>; Thu, 17 Feb 2022 00:52:27 +0000 (UTC)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21GMV6ME017994;
	Wed, 16 Feb 2022 16:52:18 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
	by m0089730.ppops.net (PPS) with ESMTPS id 3e8n41ru36-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 16 Feb 2022 16:52:18 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 16:51:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgseFlGSi/0MrVwJQy23U/S2IG4cNDU8GD78gd6VXwShvT9b8MYPiaRjhCrQvTWPBmVNpsCrjBgBiZGKatUYsFBOJ20ToRx2QCDHXrL35TJUzsw2wLcpFl4W5r7nL6NppHo0c+xSAfoECXtNTXyjBLH2gQgHrxDuOJw8u7nvLGs9H7YKab0R//x6jFl4ycOeYmFdsPVYeIg8VVu3K40aydflPvzMpI4WdKcXmuGr/h5S6m7/myDWFHDQodXdKBeNAfYQCu3z7CGiBTbmORxHpJDMCEAWZ1zBfCdAQpUNgBuiv//NUU2AI8+0EiaLBlPuXPS6j1VzHnRuq6TpucUOGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUEQl511ok4DAILob3776VUOVn5xd+kYmrGwMYpUGjI=;
 b=cOW9vxMdJZ1IZP/pG/NTYoFyp8GZP3W0yUsKDm+LfBna86C81vVuuXI72s3V01idfWvrsfoY1UMB41PRvvcBU0jZCX/1KB8crLIakepJfFEXReMDjf09PsRaQ+8RGWThZmgFT2TpcYCQBwdhc9afHce2Fc/mejLptg7LZNMpBecJJMuLMJ8ZWzOzvqB6drETGLTMJxUSswMmzdCR04udRCLnh/U3nsMx9ApHKOKbwrSeznzgxOFGiuhmA33X1pSTn1MtYyNgOdrrKliuCXguPUIdjOxuSqqlDn/nD2mw1O+lejROG3EzTCNJBxy68ry+QBqK0A5nvw6gK5+2BIw/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by DM6PR15MB3674.namprd15.prod.outlook.com (2603:10b6:5:1fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 00:51:57 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c%5]) with mapi id 15.20.4995.014; Thu, 17 Feb 2022
 00:51:56 +0000
Date: Wed, 16 Feb 2022 16:51:52 -0800
From: Roman Gushchin <guro@fb.com>
To: Matthew Wilcox <willy@infradead.org>
CC: Shakeel Butt <shakeelb@google.com>, Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Yg2cKKnIboNu7j+p@carbon.DHCP.thefacebook.com>
References: <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
 <Yg1ooYmX54j8l+Fz@casper.infradead.org>
 <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>
 <Yg1y0ax5bnjGLAqz@casper.infradead.org>
 <Yg16ClVQj8SLSlqV@carbon.DHCP.thefacebook.com>
 <Yg2EwqE07d97gmms@casper.infradead.org>
 <CALvZod5nqqt_9Xn0Yq4wiue_QePY5wz6BX6Vk2dH3P9qc92yPw@mail.gmail.com>
 <Yg2TQbpWen2SUP+l@casper.infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yg2TQbpWen2SUP+l@casper.infradead.org>
X-ClientProxiedBy: MWHPR21CA0071.namprd21.prod.outlook.com
 (2603:10b6:300:db::33) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21e1558e-69eb-468b-2fa9-08d9f1afb28a
X-MS-TrafficTypeDiagnostic: DM6PR15MB3674:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB3674726813FC13D4E48D8050BE369@DM6PR15MB3674.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:153;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YcCNd2fvvKeVxFr4cVJBesxnA9lc3pLJFzWFtT/uwdchjABlrnqYy/ye47dfZZyfLmGRSRwrHk6xPXgI/7gfbDftva950I27FeCIS/ADJH+vp1KJ90gUnqaeFpC3i2RhweU9mgx6ZvB+ieYpBQTh8QrAMRPDVYsZvbOBOh4aau4osmEnZgUtYOKLuZeOCkYpzdkAIMazY6gRdbR5XdR5dcpmZw83WYjsYlsKC6XTnFgjUcwhH17b7n+XVO2qwgSlLYdoVxuzs1gQu2w3cM04m0S6wSEQwVkCt+OzUaDWEMfKf0ZD33EyNNmqkF1Oqvkh3gmpXCvSzf6Pz5mFZ2DkC1WvYlkuRx4ZAhvHRl6UE25LSGZB7LOiXhCpnbY4iHx/BGvGxcB/F76T0ZKF6p2FKPtHpaYQXpiYxa4v0DuXDEOtvWPKN5cCK8Qopeuc5UgAIcAv+OQDikDEkNlUCrSdoZaqUawp/XMUm1SA76AL4vAFX8bqziYSkA4yWo1iLhFP+wJtIgODFM+HeyGKXqQwfz2GIqUCRhA0E8+HcXAzYy5oCaZM6zUvGu0c9UImNJW16todutGA8RWoXmsnf37HOwipqQKlEFh3gcF/OzaxqNnOyrK74L6HEYYPejMETeWR6hVYAnYqRvSF2GT6S4hrRSMgWta1gWFHnyL/AfWJyNuozTJYP0Iad12haiZ8iOw2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8676002)(2906002)(66556008)(66476007)(8936002)(6506007)(6666004)(186003)(86362001)(4326008)(83380400001)(316002)(6486002)(6512007)(9686003)(52116002)(53546011)(38100700002)(6916009)(508600001)(5660300002)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aSoSpUSVXI6NQ7ZTE2DY+Gh/jyOoBZC7z6k/kLMTlOWxkxsgeveTJ84ocCvy?=
 =?us-ascii?Q?jJsqpjoV6OAeWCr2vXNdo5LJzVcbs31cY3toZ2NjOhik3a++2uiSjlL4StaZ?=
 =?us-ascii?Q?HDcKkWrNRkAiK0XkhGwpzRjOrNAdsKgdCzFfxUMk3vjMP1n7uT2mWRtd6v3T?=
 =?us-ascii?Q?fuUt1tEpWQ0Amnz1SdSEivYqfpN/QZo+hDfYMcsjzn9j5XDg79zWzr1NTIjZ?=
 =?us-ascii?Q?Fnp7YTYg1Pt/596jxcRkVW8dwyvf5B8nh/I5nhTVHouCFUp0ZnYOvndelDke?=
 =?us-ascii?Q?b+FD2CsjiZb8HH5t98GWI1xyOhhGt570zgvatjH1uSPpw9pnQUJZFPVGUdyc?=
 =?us-ascii?Q?eWZGu9XHgUhSRh0FfibbdVDOCQC4Y9byEjqTyx/MiPL8LgyNhBQDtpwHNCak?=
 =?us-ascii?Q?hHCE7wcUcaoL4jwoLaVF36GC5/VY/9PSYExk3veH9905080jMsUvg6DEQf6X?=
 =?us-ascii?Q?EsP48SgxJAP/rvzhdXfO/2YKCIcJKvhrFv6P1IHQr5CqNs6MoWHAfxd0ybqN?=
 =?us-ascii?Q?ZbxLyI+4aLmH0GeoDRkNXEavqDL8AR/fnFstA5IAxmqgq3UiCAjjN7P6VMAi?=
 =?us-ascii?Q?teGa280Y4fF+TqC6j0FTwhTtdk38iQdIuhgqxX5i//kRNdx9o1hjsftCOkMb?=
 =?us-ascii?Q?ZYuqIwzfi7qrx64v1dOb9uACqcDWwhU9/foQJmrV5X9a3XAe1Nfwkg9JYH1i?=
 =?us-ascii?Q?KEKYaVpjqXzcqojkSKiaV1P2lTQLqscBYzLvjhJygOaN8W1A8f3M93dEsywX?=
 =?us-ascii?Q?Fo+je78Deiw8KixKKQudlApeoBGSJodbGUJZpTEPBlie0PsWRb9b4s0nPv3v?=
 =?us-ascii?Q?Q0CsrkdW9rwu+bT90hvfB/sOcosN36agXEVyJv2av8ApZrj0H239ehlYuUO6?=
 =?us-ascii?Q?hGySO3wNWumows4B7uAFWD1yr8+rwDYcCZubby+ez1k3+mpbamTwN8w84OQ5?=
 =?us-ascii?Q?eVYKNF1rRfCsA+jTR22uGkO0lZhJgf7ycNIralKLdbqVoF9EbFDZoj59wrjv?=
 =?us-ascii?Q?2rtWCArUY1E/7ie0lbWUuYVpfNOb4Uja2mAxUyCelnVYofyUUKcON4tj9CUf?=
 =?us-ascii?Q?ixc5xn3bMt2v8OPiOjPz8zP3X7bv09mc4fKU2Id7JEMMyGdmoFi0wDahuLqi?=
 =?us-ascii?Q?lfZDPK123KpEODEGdhXGgeeif7kDGHG8zyzESzwr/EpGdK/l7kCFyiqQo5In?=
 =?us-ascii?Q?LlLwsW7aIOYaSN6Z0CPp2XgziQCsj+pDkigx0FSEz4dOlmxIq9cVMi2AzZo8?=
 =?us-ascii?Q?98ZvonTP5XhwTUv3p+Jce0BIa6e0mnjp8NxdIZzgphnMhArKFE8oV+0/cYN3?=
 =?us-ascii?Q?rijSmk2qdS/vWb19FVVyREfZgMqlWjiU7FEOjnKyDoWIkIqIU1uVXva6F390?=
 =?us-ascii?Q?TH9FgIKwNO4grhf77rPcSLRtvq03ykhw3NYSePpqJApT2zd6yCCZN1TSBGyG?=
 =?us-ascii?Q?m2urcyb8W8cHSbLXVdvP/1VXk41Sek5MvmCyxs6vAj3jIdv88JYgi4xG1vGt?=
 =?us-ascii?Q?9yQwPdPURWce3PY4zdIl2icVJXptxZ3YNYLuVc25zgzJVigPfut2otWIiNg3?=
 =?us-ascii?Q?vouM6zBPDh1TjIY3xZKAhyZbVdFqUN4IfYysdLoD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e1558e-69eb-468b-2fa9-08d9f1afb28a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 00:51:56.8482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/L/8zfWzssI8AJLLwVrgTY7GJ7BHiDfGMdIrDnyFUiMLD/o2wazv5MClA+IkjSQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3674
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: AUdLzdjTsOliu4qMyVnq1xfIeXq1gXRF
X-Proofpoint-ORIG-GUID: AUdLzdjTsOliu4qMyVnq1xfIeXq1gXRF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_11,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170002
X-FB-Internal: deliver

On Thu, Feb 17, 2022 at 12:13:53AM +0000, Matthew Wilcox wrote:
> On Wed, Feb 16, 2022 at 03:57:39PM -0800, Shakeel Butt wrote:
> > On Wed, Feb 16, 2022 at 3:12 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > [...]
> > > > Here I'd keep _page (or _folio, if you want), because
> > > > it makes it clear that the function goes over all pages
> > > > (and is expensive therefore).
> > >
> > > But there's no intrinsic reason that it should.  If that's a
> > > performance problem, you could keep slabs on a separate list
> > > from, eg, file or anon memory.
> > >
> > 
> > Is there enough space in the struct slab for that list or do you mean
> > something different?
> 
> Well, I don't know what data structure your for_each_page() uses, so
> I don't know what to suggest exactly.
> 
> If it's an iteration over the entirety of memmap, then maybe you'd
> rather iterate over each kmem_cache like /proc/slabinfo does?

Anyway, here is v2. I hope you're fine with it.

--

From 04efbbdcfde4535c4623f2fd6910a505a9c638bb Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Wed, 16 Feb 2022 12:43:30 -0800
Subject: [PATCH v2] tools/cgroup/slabinfo: update to work with struct slab

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

v2: change naming and count_partial()/count_free()/for_each_slab()
    signatures to work with slabs, suggested by Matthew Wilcox

Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Vasily Averin <vvs@virtuozzo.com>
---
 tools/cgroup/memcg_slabinfo.py | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/cgroup/memcg_slabinfo.py b/tools/cgroup/memcg_slabinfo.py
index 1600b17dbb8a..1d3a90d93fe2 100644
--- a/tools/cgroup/memcg_slabinfo.py
+++ b/tools/cgroup/memcg_slabinfo.py
@@ -11,7 +11,7 @@ from drgn.helpers.linux import list_for_each_entry, list_empty
 from drgn.helpers.linux import for_each_page
 from drgn.helpers.linux.cpumask import for_each_online_cpu
 from drgn.helpers.linux.percpu import per_cpu_ptr
-from drgn import container_of, FaultError, Object
+from drgn import container_of, FaultError, Object, cast
 
 
 DESC = """
@@ -69,15 +69,15 @@ def oo_objects(s):
 
 
 def count_partial(n, fn):
-    nr_pages = 0
-    for page in list_for_each_entry('struct page', n.partial.address_of_(),
-                                    'lru'):
-         nr_pages += fn(page)
-    return nr_pages
+    nr_objs = 0
+    for slab in list_for_each_entry('struct slab', n.partial.address_of_(),
+                                    'slab_list'):
+         nr_objs += fn(slab)
+    return nr_objs
 
 
-def count_free(page):
-    return page.objects - page.inuse
+def count_free(slab):
+    return slab.objects - slab.inuse
 
 
 def slub_get_slabinfo(s, cfg):
@@ -145,14 +145,14 @@ def detect_kernel_config():
     return cfg
 
 
-def for_each_slab_page(prog):
+def for_each_slab(prog):
     PGSlab = 1 << prog.constant('PG_slab')
     PGHead = 1 << prog.constant('PG_head')
 
     for page in for_each_page(prog):
         try:
             if page.flags.value_() & PGSlab:
-                yield page
+                yield cast('struct slab *', page)
         except FaultError:
             pass
 
@@ -190,13 +190,13 @@ def main():
                                        'list'):
             obj_cgroups.add(ptr.value_())
 
-        # look over all slab pages, belonging to non-root memcgs
-        # and look for objects belonging to the given memory cgroup
-        for page in for_each_slab_page(prog):
-            objcg_vec_raw = page.memcg_data.value_()
+        # look over all slab folios and look for objects belonging
+        # to the given memory cgroup
+        for slab in for_each_slab(prog):
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

