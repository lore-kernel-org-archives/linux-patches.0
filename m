Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1618C2580
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA55B212B8
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A407313A94
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id B4JkI2VnE2LBIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <e149de1d-13de-22c0-43bb-cf584b307653@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id 8ETULR16DWJYVQAAMHmgww
	(envelope-from <prvs=3046c06256=guro@fb.com>)
	for <vbabka>; Wed, 16 Feb 2022 22:26:37 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id aJK1LB16DWJ/JwAApTUePA
	(envelope-from <prvs=3046c06256=guro@fb.com>)
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 22:26:37 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id ADF51A3B88
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 22:26:37 +0000 (UTC)
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
	with ESMTP id Wob-Q9YD690h for <vbabka@imap.suse.de>;
	Wed, 16 Feb 2022 22:26:32 +0000 (UTC)
Received: from mx2.suse.de (unknown [149.44.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 19DB7A3B8A
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 22:26:32 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTPS id C0C66AD43
	for <vbabka@suse.cz>; Wed, 16 Feb 2022 22:26:31 +0000 (UTC)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21GLnIAl003127;
	Wed, 16 Feb 2022 14:26:25 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8n40g5c6-19
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 16 Feb 2022 14:26:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 14:26:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXciHfwkFvvHfCVBcUeGjryqjO2/3s384V4ka2n6Iy9Kt+kPaLzeHmOQDsz0zGJGe/Obklr0Vim0hhX0MmbHmr64crDTHUYEWZes857wKANxeevoxT5s4kK8ik2iD1L1fLdjYl63wv0d6q4MBHmqICkZXMndQz8UdQEMHvnMjv4mNC61lcd4phfjDoSWKPY8IZnAmqGBq8NGMn5zsl6kWGKUNkZJuCOd5jkZF8s4nSYoFoYjd8tDamBraW6UUrfNqJ+BA+NncY1JkRkgOJqYuK22rRXXc8NlAZm+fTnBJWnksuGc/AtWeJm6fQbLAoONFNXd/gbWMNjBfQKMRTTohA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yH879Tn6gzBI8L7zAM6VUBODM0NrHWGqvKv9TRDFUsE=;
 b=cxFaGy6a2WlT4Hvu5s6XJOkiTdq27VDOZDVZXqTiecBYhR2pjP5tgrELxl/C+hkCSajzB++rfHXhz4ElII5BNNIc62fZQnXCo0e9uU6Wkckf8SZJx04C2w5eqoIk8OvRDhgHsi+GYKZUuV81+1f4/DGcKahZusIPELisHW2YegYMUX6TjbOyqVJNkDyZlC85tGT/CfwTY/yBd+webvFf7wHdbdjqB87NcKlXaN3JM+fJW/9ifCxK+mGNAu8NO+8N+cyPO57eWtGzlqJSi3MEczOTgd/tp7ohMjlkydu8+uJAwsyYYaUcmFCkJQMRewnGJsth4e8dSYLa37aTXr91Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BN6PR15MB1220.namprd15.prod.outlook.com (2603:10b6:404:e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 22:26:21 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c%5]) with mapi id 15.20.4995.014; Wed, 16 Feb 2022
 22:26:21 +0000
Date: Wed, 16 Feb 2022 14:26:18 -0800
From: Roman Gushchin <guro@fb.com>
To: Matthew Wilcox <willy@infradead.org>
CC: Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>, Vlastimil Babka
	<vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Yg16ClVQj8SLSlqV@carbon.DHCP.thefacebook.com>
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
 <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
 <Yg1ooYmX54j8l+Fz@casper.infradead.org>
 <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>
 <Yg1y0ax5bnjGLAqz@casper.infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yg1y0ax5bnjGLAqz@casper.infradead.org>
X-ClientProxiedBy: MWHPR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:300:95::22) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a8932d6-78ae-4025-cd3b-08d9f19b5bc4
X-MS-TrafficTypeDiagnostic: BN6PR15MB1220:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB122010F7FEFF4D794E3C031ABE359@BN6PR15MB1220.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SThS/BSUGazrW7h3WvomM7asO75ELnLMhcsG7v8Om+rz6QagRX9O+xGf90uviPzSFnSjtq9pHpgDT9QHBRKcKdvsRNppklV62ZNVldaXvqptkxGFFxTzHtJufKgdS3g/bm862lJvH/nCqpBq9AAuydTnJ5c2Y0+xsnAvzc8ja8usYdhWY7Zz+ImlaauuEnGEIsuCqW4iJVtR78tRY97WKM/1l9JQN2y4c3Mm27LZtBamzkCiTt3YB87c9b8dTjhmdtJYuUA/CjIthawE2jsiGl79oRrVJpSeluvlUWoOp9iJbtZDXqj/Lrj7S+W+htz56IDQ3yOXB82NbRKuV+gMotxWKF83WxzVkSxZ4awsX7iZb5n0DppP4WT3io6ZRgDq3rphl1WOamcN8kZFzcQF3iuVSRLX6LdtHnYcjOkmoMAlzk+hUfhG5jIT7Kc5dHc8Le9Kdic92QvXahq1NAk/OpN9L5/c7SigmlEMIIVJaMD/JiCqeipgkpoeMMoarsVEg1niM5p15pOrH/b/OrOluzHRX19gQnzVaZFYrDg4wO4GsSkU0NoWY5iFsXfsOc/WvPhOvEhIzwdtzCBo8+u7rulWDHad/i0A0pPC6tFKl1QJ0AiQlkowa88Jn16uhW79ufTV4zjzEYAdbOJ6v0fPeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(2906002)(6486002)(66946007)(8676002)(66476007)(66556008)(86362001)(4326008)(38100700002)(5660300002)(83380400001)(186003)(508600001)(6666004)(6512007)(6506007)(316002)(6916009)(54906003)(9686003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N0rifb6theA7CJLkmBqJqshzNEpO6s1mpcyTC4o1L1SK7zCalsJOyF/NyDAZ?=
 =?us-ascii?Q?9Jpbo27+IjgZ/IYm/TP7K3Zty4AOFd+BV8PKTI7cHve2UnyR21QnlHI1lCtb?=
 =?us-ascii?Q?D66WO/yR8lcyWSbPH7xeM3fmXAJx4bDyMw7PdTdj/nbPJSnsmQOeEZxZ5IoG?=
 =?us-ascii?Q?uBMIkdYzONxQsZJ3VGGX+GkNMTdQj/apJKvsAO3Qm2I0FAFxDbgtWewCA+de?=
 =?us-ascii?Q?3IDiKjiCGTu8whdu3Z10a3xzD6UYIpMIJofLIfWDrpJW7pk1tfgBcWDTpU80?=
 =?us-ascii?Q?WvQHV303X8CzuuXXRMJV0Rc1HAkwJJr1Hg24Uf48XIl1beKcq94fBt5ouabG?=
 =?us-ascii?Q?U6tj/5juiTZbhruy1ygPApPA5rOmouXBKnXsKKfn4kaanAeSFDYNNaMRqc/A?=
 =?us-ascii?Q?+6EzwfFX0ccar2HdOrVpZjgOa1TPsGL7bXepRUKut+Plk68ZyzwYeBuQ45wf?=
 =?us-ascii?Q?OHW+uHYTRRypm8+g9xgDMdpcwGvhODCkvXVG3oQ3iT1WbZ312WCSppdK3yzp?=
 =?us-ascii?Q?XoitFXWVZAjWkzRJIefb+c/9rvJt8KLXj7ySkNso7aHrl4HN0V5a1yhueAcO?=
 =?us-ascii?Q?+VEHNjqZyODtZLm4dW1uYIvHKG/iPbPC7wlXRa2t93m3MTetnPix4AhmAX3m?=
 =?us-ascii?Q?PAYYZJqQO99vBoX9UrzxGyEZpnldJbePVkQvoJ4H9qCx0bX9zBqecJ9y/BU0?=
 =?us-ascii?Q?5qMKnIeqEmYqLxOew7aZHuhCOc/hO0IeKw3hKF48q754njqZyVCK+GZP1Wnl?=
 =?us-ascii?Q?jfiFE9AQFU1hBwubvuOConXeVm31bTjx+HuwporHXo30NDediLV3XYYr5eMx?=
 =?us-ascii?Q?ODkWBJR3kZb9w7OL1OxQdr0h+FTydayQs/6p2HQbgm3vwTh0XDFIgTWo3p97?=
 =?us-ascii?Q?n4OndEW9L8dQc/lycIQZqaorpzeHXDNX9ymxSvpka3CfOkn3gsX3U/bkIu6r?=
 =?us-ascii?Q?zPw1HP8f/SVlNkUhhwrfuGz0Wng5dA5/uYWhFH3whMIUEaM8AQ/nFMD8Frkd?=
 =?us-ascii?Q?WJ4uZ/54HHS1JYfnZvNFbmPFr5rnzzW9XHPLPVCHxQ51tIsw3Adv3uhw3oem?=
 =?us-ascii?Q?ouZKiuvhFWzjPBr/1N01UH+l6KRrlyraaDQaYdVauEohMtE0D557+7LUISkq?=
 =?us-ascii?Q?oAqheI2wtsM0pvtRPtRP2DGqtKda1i596coxYJQNABv0nyIO/rJf+Cpcjp5Z?=
 =?us-ascii?Q?WkxXLbMs4eT5O0kyPV4cBOp+AW11eqswHYrGxcULfX6lkTi9wBQDabU5/BOI?=
 =?us-ascii?Q?Z+B2XQjEkqxuFJQoBSXoWm2fep/wBmcGHE44VwSnHjWXJ1nEkArd7i0DsnPB?=
 =?us-ascii?Q?sML9tdjom5CGEO3D8F/MPAJomMrH2Lyy8Ndg8P3kwfmkItXFbNe2CacVIyyZ?=
 =?us-ascii?Q?piWNUIw/cfLvor4EGJCn+KdhSNirIGpzm2kG7Xh/2wBUoQQvun+YeRQ4tkgw?=
 =?us-ascii?Q?u9vciWZBOAwyuxeN8Hn82oh00y818VjOHsSdc6KB4E7K2889E2YHDNLB79w6?=
 =?us-ascii?Q?qdWPegOns11dtvG5xzUGAZdx/9QWPMCnxGpGNj9yRXiGhhafpilx3Uml7idf?=
 =?us-ascii?Q?jXTrC7b4NdP13MSD+NdTyzfD4umgEiL9f03r6SJTafv7y/xhKa6CIvKUKsmr?=
 =?us-ascii?Q?vA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8932d6-78ae-4025-cd3b-08d9f19b5bc4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 22:26:21.2734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3eV9lcgk7RUkmLpf7fCHEQb7GomBuMcuzm/fEGsEY6Cwve/jxvc/9qhsk6o+/Ib
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1220
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: q0_A4bSKnLzXyfSkrPziouklk2SGFlOe
X-Proofpoint-GUID: q0_A4bSKnLzXyfSkrPziouklk2SGFlOe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_10,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=904
 clxscore=1015 impostorscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202160121
X-FB-Internal: deliver

On Wed, Feb 16, 2022 at 09:55:29PM +0000, Matthew Wilcox wrote:
> On Wed, Feb 16, 2022 at 01:44:10PM -0800, Roman Gushchin wrote:
> > On Wed, Feb 16, 2022 at 09:12:01PM +0000, Matthew Wilcox wrote:
> > > On Wed, Feb 16, 2022 at 12:52:36PM -0800, Roman Gushchin wrote:
> > > > The problem can be fixed by explicitly casting struct page * to struct
> > > > slab * for slab pages. The tools works as expected with this fix, e.g.:
> > > 
> > > This feels like a quick fix, and not really correct.
> > 
> > Do you mind to provide a correct version?
> 
> I know nothing about python, nor how to even run this script.  But this
> is the kind of thing I was thinking about.
> 
> I didn't do the 'skip over tail pages' because I have no idea how
> you'd tell for_each_page() to do that.  I don't know where to get
> drgn.helpers.linux from, so I can't look at the implementation.
> Maybe it already does that.

Is there an actual plan to set the slab flag for tail pages?
If not, why to check both? It's fairly expensive already, so I'd
not add any additional checks if there is no strict necessity.

> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> diff --git a/tools/cgroup/memcg_slabinfo.py b/tools/cgroup/memcg_slabinfo.py
> index 1600b17dbb8a..6bb588946f50 100644
> --- a/tools/cgroup/memcg_slabinfo.py
> +++ b/tools/cgroup/memcg_slabinfo.py
> @@ -11,7 +11,7 @@ from drgn.helpers.linux import list_for_each_entry, list_empty
>  from drgn.helpers.linux import for_each_page
>  from drgn.helpers.linux.cpumask import for_each_online_cpu
>  from drgn.helpers.linux.percpu import per_cpu_ptr
> -from drgn import container_of, FaultError, Object
> +from drgn import container_of, FaultError, Object, cast
>  
>  
>  DESC = """
> @@ -69,15 +69,15 @@ def oo_objects(s):
>  
>  
>  def count_partial(n, fn):
> -    nr_pages = 0
> -    for page in list_for_each_entry('struct page', n.partial.address_of_(),
> -                                    'lru'):
> -         nr_pages += fn(page)
> -    return nr_pages
> +    nr_objs = 0
> +    for slab in list_for_each_entry('struct slab', n.partial.address_of_(),
> +                                    'slab_list'):
> +         nr_objs += fn(slab)
> +    return nr_objs
>  
>  
> -def count_free(page):
> -    return page.objects - page.inuse
> +def count_free(slab):
> +    return slab.objects - slab.inuse

This part looks good to me.

>  
>  
>  def slub_get_slabinfo(s, cfg):
> @@ -145,14 +145,14 @@ def detect_kernel_config():
>      return cfg
>  
>  
> -def for_each_slab_page(prog):
> +def for_each_slab(prog):

Here I'd keep _page (or _folio, if you want), because
it makes it clear that the function goes over all pages
(and is expensive therefore).

>      PGSlab = 1 << prog.constant('PG_slab')
>      PGHead = 1 << prog.constant('PG_head')
>  
>      for page in for_each_page(prog):
>          try:
>              if page.flags.value_() & PGSlab:
> -                yield page
> +                yield cast('struct slab *', page)
>          except FaultError:
>              pass
>  
> @@ -190,13 +190,13 @@ def main():
>                                         'list'):
>              obj_cgroups.add(ptr.value_())
>  
> -        # look over all slab pages, belonging to non-root memcgs
> +        # look over all slabs, belonging to non-root memcgs
>          # and look for objects belonging to the given memory cgroup
> -        for page in for_each_slab_page(prog):
> -            objcg_vec_raw = page.memcg_data.value_()
> +        for slab in for_each_slab(prog):
> +            objcg_vec_raw = slab.memcg_data.value_()

So I'd go with something like this:
   for folio in for_each_slab_folio(prog):
       slab = cast('struct slab *', folio)
       ...

>              if objcg_vec_raw == 0:
>                  continue
> -            cache = page.slab_cache
> +            cache = slab.slab_cache
>              if not cache:
>                  continue
>              addr = cache.value_()

But I'm fine with either version.

Thanks!
