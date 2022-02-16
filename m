Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA3C2584
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BE0701F393
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A39AE13A92
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id ECUPI2VnE2LCIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <c0486029-98cd-67c7-98bc-36e89363ab82@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id IJ6dMEBwDWKKRgAAMHmgww
	(envelope-from <prvs=3046c06256=guro@fb.com>)
	for <vbabka>; Wed, 16 Feb 2022 21:44:32 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id ILGLL0BwDWIcFwAApTUePA
	(envelope-from <prvs=3046c06256=guro@fb.com>)
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 21:44:32 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id BB691A3B90
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 21:44:32 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: -2.809
X-Spam-Level:
X-Spam-Status: No, score=-2.809 tagged_above=-9999 required=5
	tests=[BAYES_00=-1.9, DKIMWL_WL_HIGH=-0.001, DKIM_SIGNED=0.1,
	DKIM_VALID=-0.1, DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1,
	RCVD_IN_DNSWL_LOW=-0.7, RCVD_IN_MSPIKE_H3=0.001,
	RCVD_IN_MSPIKE_WL=0.001, T_SCC_BODY_TEXT_LINE=-0.01]
	autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hEki7PFrTNLj for <vbabka@imap.suse.de>;
	Wed, 16 Feb 2022 21:44:27 +0000 (UTC)
Received: from mx1.suse.de (unknown [149.44.161.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 6EB42A3B93
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 21:44:27 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTPS id 25155AD35
	for <vbabka@suse.cz>; Wed, 16 Feb 2022 21:44:26 +0000 (UTC)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21GK4pQu026924;
	Wed, 16 Feb 2022 13:44:18 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
	by m0089730.ppops.net (PPS) with ESMTPS id 3e8n41qtet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 16 Feb 2022 13:44:17 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 13:44:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZLUr+NQBuC3XAOFYnrYsJCKWyE5YpnObOp9pOMOC7Dg81mexqPxBAvOSpx86ZBjmQe/wUnJGNWQoRPvNUCwgHLRtTzyMpyOKwr3cMR/I0+xPDV8xkQv7PnqksRrnM89SvQsJYmToI0+pYqFO4NppixvvbPNcX/ORWsX5WquvNvZCp99zIgVFNHELgDPYo+PZLvMbexlxZmncGCRGWHTL8ts4LCLCWVg6YCylItiahU4h4LLvpPzFKYE+8boF721dnCm9wUvpyL8/Z5OzEog+AbPTHyDRUpkRHI74MC3XUde2FPntrujtkHodXKtW0yHFPttX8mkyKdyemuriZRm7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8AajC84ZjDN/JU/r2ZoWZCGTPY/v0zZ7Jd4IuDJAbIg=;
 b=ZITbtCynWqaY1MukeowpQyXXo+J07DrPzfxRmMimlfeTBJCrgf6ZpuyIGdJfouzG9D2uuge6VMhzfStHQkmBgtszKfF0ndlobL9I269hrf5veowOQZ8WevBKPQY1uFbrhhJFym+MjSRb0iVzXJf5LSNpc016QH5anw/1wknjQzO1P1dGUWfRSFB0L22JmsBYvjuVDpKv4FaAeY5ct9iVB9TvP9IeeLTLC1IDNDCUPlPqR5fTvali4/86x7YwfV0HHZRv4DUmp6k1xXsMXfRkTEUWAUSFHVS+s45oj33Wp46Kftr99lA1PJQ0f9S6T3QkvZ9SetUbUWHFZuLgpR7XhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BN6PR15MB1186.namprd15.prod.outlook.com (2603:10b6:404:e8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Wed, 16 Feb
 2022 21:44:14 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c%5]) with mapi id 15.20.4995.014; Wed, 16 Feb 2022
 21:44:14 +0000
Date: Wed, 16 Feb 2022 13:44:10 -0800
From: Roman Gushchin <guro@fb.com>
To: Matthew Wilcox <willy@infradead.org>
CC: Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>, Vlastimil Babka
	<vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
 <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
 <Yg1ooYmX54j8l+Fz@casper.infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yg1ooYmX54j8l+Fz@casper.infradead.org>
X-ClientProxiedBy: CO2PR04CA0069.namprd04.prod.outlook.com
 (2603:10b6:102:1::37) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5631fc0-2469-4d82-138d-08d9f1957990
X-MS-TrafficTypeDiagnostic: BN6PR15MB1186:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB118690C19E86EC18B00A87F4BE359@BN6PR15MB1186.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YRP40UP1H+MgLETXNllQsKypp14RPXzr7FCqSxuBK57Ery2R8L4hbamFPld6gudUWBgJ3++eYd4UJjpv+GwI2XAVs8/r+UEwVcRyL4RyBFtQw5/Mibb7EY7rNG9kpQZ6C4IUAgMUxl3jmLF1HU5pdjtX4Hx+z5jzwSS6PEZh9SGgEWlx/AtzAewkNCEmM6FYQPrAoPYsO4vtqQWj4O3hU/zL1+GtmbleC8oupxc9IErRyK6J5nfdjcWbCYLKqFHa9JF5yGmEf5UBNCxP9WtFEUon/nqa43g2eF71A0ZJpCJ9kpd4MBShLwC7JKapt6Ul/I7eAOu5i13Wcr3DMnZng+JyC/kt22TrLUDu9zh5lnih/VPlDE8e3XVE8mhq2v7Mvl5BdKYA/0agoG8y5sZh36OPutuDA4r4MURavqIqFb362Jkmkv0NoXuQPs4y6M4kn6OWWQGJZVI1ibQdnm4f+BFFt6yQPPWimH2ig/gL0g4YK1J1ZUWEtiw6OaqVqED0H229vaU3Gvo1FHapmSgWxx9Wc4Rs1NZix4q2o0Ngo8Tlp1XH443T5VVaGU85ixFif/vmceHV2DgWImrxOLO1dLYK55RI/Wn1c2gmxTMUV/nj45sWvK0NUTFwL8soDXOqh1Dz0ynTryKSsF5nv1jOLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(316002)(8936002)(4326008)(66556008)(54906003)(66946007)(6916009)(86362001)(8676002)(9686003)(6506007)(2906002)(5660300002)(186003)(4744005)(6486002)(6666004)(508600001)(52116002)(6512007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NYbU/vcITmhohrxJFGAuSC1niba8WEzFFP+xmLYogkAwu84MesQh8gvgnzPX?=
 =?us-ascii?Q?3seDPcnJId+aGfc6UinRw4USaMSIEdKjmamrS5Ef+KpiZnwEPoYfjbw9CEaq?=
 =?us-ascii?Q?WG9sqxY+G6ICG3vYSatak8Oco3+Replex+2CfWiwtxya4Hm5TxzinqTDJOLi?=
 =?us-ascii?Q?hvQlxcbjhJ/h/4TpKzhyud6nXk0BZBHZ/KmdY2iARHxFOXESMaZrctjA/Mc2?=
 =?us-ascii?Q?8gHtGnpwTwJgQoiue4QGNxzRGF7XpXxFGc7NQaSUagKLa4Z3bieweS9AZaM3?=
 =?us-ascii?Q?daeB0H2L1yzsyE0RQDjhehkVq/xq69vqrfyExpsmpl7YALUX/ze3z1VmaBSr?=
 =?us-ascii?Q?rviBMYLL0Db1WS74s6CoQvRmZQThxe8uCI/rbwPXeQ2r4P8JH5KZ9PlyAx0t?=
 =?us-ascii?Q?hoVpJguACUKQVb8lCptxOWhozVJgQAKK4mKpouNPEC2cxUSgXfdSr/Ge6G+I?=
 =?us-ascii?Q?RWePFJmuTWkez5Ky/Zm6Wlded/iAQ5Rj8zK/JkLqFLyD08yBgzuvBHGEEyWp?=
 =?us-ascii?Q?80ddGMXvpYnvC9+/7MFJP5HBZuHOYycvw7epOnUaOTFYhP+3fe09GbznVT/D?=
 =?us-ascii?Q?3NdJ3Dke5TI0mV7WjW18sXbJaIZaGHubbueduo4ZdkFO3T2bito0el4itUq8?=
 =?us-ascii?Q?I4SYXGe/cXYHwwiRjOp8aLQF+aDSs/x0y+EjGYplPMK5Qn/gSwa16BJemLKb?=
 =?us-ascii?Q?Hzact1HdE4YPMZQfURyBu+oJ23vxK5YueQRvS1oBZ+VJmU5ne/t+CgzjdXZf?=
 =?us-ascii?Q?DKOG//fctZoFUTxs7lTUR9gIOCButaennXqYo48q0d7eZAbbZENUAQ9tB8Lg?=
 =?us-ascii?Q?p+CHnkTZN2S/tIZMdU+SiRMNwol2M6mrHCS3FivQWC1QvmeSYp4EAM39/Kfr?=
 =?us-ascii?Q?Sld5zyPFs1LsL/ZfiiOQ6R9JO8+N7Eyniail6pfFqMmXmgdh2SwemJpqVhmx?=
 =?us-ascii?Q?OkQSwJOgJcRJczHhCpkUW+Wp3bEP7bjEhlsKqq4kz8+s6rq0JQMFDyUxi2RN?=
 =?us-ascii?Q?qD/1bN/xtREAy2zRtD4JVZz5GjKHGRnm1hOW8kg9MfL0GHOzdvg6yNhhon99?=
 =?us-ascii?Q?DvSd12OFZuE8xCUkz0TSXEKR+5OgNbK5A3l3T5fA/DRRDSchQcdQS88SyGg9?=
 =?us-ascii?Q?78KykCQkVL9LldlvTtBRx0kJljyWOC7v4lyxGkKk1JCgcVi0EhPePWRTXN1w?=
 =?us-ascii?Q?3Pm+5mWhiBzrs7sNqpl3mgpVoigHW/Q039T/j4/hybWjhUdtf6/mIKZzioj/?=
 =?us-ascii?Q?q2/riTaJLoEyf3/OwD3aCrj8FvHQiCuf8EKDaKIYJun04sgU4d9JzbAdp1BH?=
 =?us-ascii?Q?lZpTUtvMMMOnsWtfdYtZJ3mE2aNdXVwRk2a4EbWVq0xxgx2tqNwyOtCos8br?=
 =?us-ascii?Q?wLCldcNONTasDP+oTxsXCbxWziDwLhtmdl/rNZF5kDmjO9zjis/U1f78LDIn?=
 =?us-ascii?Q?IWiiHKnS9AFDS8qmkbo0MW/UvU1mrvlnQ2R2hL80lD3s7Fz6pZNOwzaeMIEN?=
 =?us-ascii?Q?sTH+JW6nwjNOnEzzB4gA6Ja1CUZwTelGSTAEFkSTAHjT52HI6kwl/ZPZciOm?=
 =?us-ascii?Q?YNkDdLGLg/0TcffFRe+iv4yfkE1uuJn9L1n/IqW2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5631fc0-2469-4d82-138d-08d9f1957990
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 21:44:14.3260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbgVId259vQU0zK0MtUE7OESrFCXR/TowgNNKU2UGpGEJex2RhSX8iIEpBqrpwq8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1186
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Udlqm078x3GY__nRvV8mni0G-E26pwoS
X-Proofpoint-ORIG-GUID: Udlqm078x3GY__nRvV8mni0G-E26pwoS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_10,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0 mlxlogscore=632
 adultscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160118
X-FB-Internal: deliver

On Wed, Feb 16, 2022 at 09:12:01PM +0000, Matthew Wilcox wrote:
> On Wed, Feb 16, 2022 at 12:52:36PM -0800, Roman Gushchin wrote:
> > The problem can be fixed by explicitly casting struct page * to struct
> > slab * for slab pages. The tools works as expected with this fix, e.g.:
> 
> This feels like a quick fix, and not really correct.

Do you mind to provide a correct version?

Thanks!
