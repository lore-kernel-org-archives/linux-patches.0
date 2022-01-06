Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3802D2C80
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 04:16:20 +0000 (UTC)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 205N64J0030391;
	Wed, 5 Jan 2022 20:16:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Oacj3H6EmTSxEjOYKs9b6CLvKNkaks8Lw+OWl8ielvE=;
 b=Pc/MQc26gNCeGAyNUHonlI6D64XS7IJJvEaHXnJ8tsywAYIeVS4UZvIwERXlwIEb0/rY
 hPr/Bv3mBchtQmaC23COyorIMboKcn/rLIHMt/31CXuUQSH/0tTusYeoAn50ZiwB97go
 5tCD4Gwakmor561c5lKSOzxKxgSIzN1AQVQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ddmq3h7r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 05 Jan 2022 20:16:07 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 20:16:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/MQAwTvHwVrHfd3ai1xWtylHDNUl8v0AXl4j+lBFrbnSENYHISLtDkUHFn/5MHyaZWVk6bsXGURlx2UzsXLIKzEqCFT/uBm29iohTjuSWmeBa5ByhtDjaj1mdtsdkku5BqM0GP67XYh/hwjt01QlZ0KAshAqRKHfj/E1uYFFevEgzCqbB7IvDjHOkauvZkWCuVZ0uNaEeneYAWeEIPl1cSDke2/6U2MsaCZ8bfhkBTxlNEyjt/4RPxVUESbtB1GB65KU0g2ejhTrbOdPAMHqlGFvigJET9nogJENCk64rCx5kguJFOJS+ThaGR+atTW3KMVU9pY5SHKn7HkY5CoHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oacj3H6EmTSxEjOYKs9b6CLvKNkaks8Lw+OWl8ielvE=;
 b=f3r5JYtxnjrpg2tO718HueJMRwL2WGgQ5ALQRR1BWwbG3kld/eXXLW5n0NjznM99asE4I13neXnmCJqTx5K3edLcnvW5xA0606zjXsnENDuThVCbZORcd8eGNZ45R80XTbgH28AhYwtNgzY9tknzCMPKTu6mVbQMYP43dDNbM3fidfEwVjlRcGZcRR5Jde5dvvyKvDqJs7lzPfNUEKvPjG/+ty9HsjuCDaL9e/g8p09ulnSEsaRruxWlq6SGPfcAo9BjLfbr8/KyPlFltz3rJ5VEzVUTks6Vr6CTIIU6nkSemsa/3KcuxfMzvSGL3fFakCOTcjCfJ/SQ/OI2K3OfAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2663.namprd15.prod.outlook.com (2603:10b6:a03:15c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 04:16:06 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913%3]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 04:16:06 +0000
Date: Wed, 5 Jan 2022 20:16:02 -0800
From: Roman Gushchin <guro@fb.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hyeonggon
 Yoo <42.hyeyoo@gmail.com>, <patches@lists.linux.dev>
Subject: Re: [PATCH v4 29/32] mm/slub: Define struct slab fields for
 CONFIG_SLUB_CPU_PARTIAL only when enabled
Message-ID: <YdZtAg1JKyO8vDBV@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-30-vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-30-vbabka@suse.cz>
X-ClientProxiedBy: MW4P222CA0014.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::19) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24914d4e-3473-4b01-608e-08d9d0cb425c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2663:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB26630A596104C02F3057B194BE4C9@BYAPR15MB2663.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TxCS5A2ghjbYw32oPy3yUaJ5ektFHxmv0kqA29nOe6zMppADXB1skwi4v+JH4Iq+JHP8LptoVlMyc6EaqHxAt2aWmiUWPJpfLWTQErrf8jD1Q4OZO8F1HCE42B43fhukkZul8dB5YVp7Pkz6gdEKdLSXAC3+AKNpL5D5BDw3RfO116PsFTw2VJ38eCo5U8eFw5O7qhEZ+rgn0ILJplOyPoUSgZl/Xf+vNvfPMxY9b4C6zsFnP4YTE3Q2Jc794S4T7EvfzF0Pr+OrPdu2ejTPZL0PdZDx+clfaCGx0wTzKpGoyS99kyzwNDrMWckyNwAG+NXQ36eQiVsQTHda/rOo7KZgYnYBdL0JIay/j7bE2en383PcN9aFeI9Oov356wd9VFe7DCtb73k/lkHdVqhpr76Fky9tyvNxhtV26dBWYoy5s5B/x9buv34wyuyy0p2v/8X8mB2UBDj03sfAyhiW3r4b41vHHyR6nSAv0I203S7N4UaOnwUHl9hw4/ix833yI6jN5yjN26+NOpkD3q6mnfff0iJ9qG1eN/4IF+8569AX88rnhRa4KqExNgE48tC9S4fpelUW2yhKXSMRjFoEtDdMYwFAUIxUuaBgQcu6W30gCaRJa1JQqG8UV6lRotZfBJ6Lzb0OYCcGhlg+F4XAOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(38100700002)(9686003)(6512007)(6486002)(86362001)(8936002)(7416002)(66476007)(6666004)(316002)(54906003)(83380400001)(4326008)(66556008)(66946007)(8676002)(508600001)(6916009)(5660300002)(186003)(52116002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lJA9LPnTd9cUOG5ofvbiSNDOk2lA3BMlDDahFjGK1TA7hwMFQCm0ujqBjBwy?=
 =?us-ascii?Q?fNHn1GhoihfQ459uf65L6uSvPEnUpVR9ARnaqXmPZcmV11NqNik0CF19U4aQ?=
 =?us-ascii?Q?P0kJqUi/D1jcOyATUpRXpJtMpam8BgijZmZy1Z6uCn0+tWJH02rHFuQb1RsZ?=
 =?us-ascii?Q?yJcwaYtkZ/BE1qSZckiyixmI8oc3i5d9xKvKDyzyKWh1qDZccaTDBLXUVnUw?=
 =?us-ascii?Q?9WDccAoWxqaXHHOOcLsUcA8tG0zcv9DMtIqKEhX70gEj+pEP4gA5rt/xfZrZ?=
 =?us-ascii?Q?Esj+GECq8sirLabL2JA7K9r4nu9F8nCE6LPFAEOU6U44c6Lz2nQRrNNFlZSu?=
 =?us-ascii?Q?VrlcYRsdcSoKFaskW58cIaa0InljJq2KNzGFs1HyQpGsFy/n/6jS3q4ULokW?=
 =?us-ascii?Q?XfK+x57nWuCp1ruuyaLuKMlu+E9gWST3uMKFajzE9gjsrKtq7q56amOz0ygV?=
 =?us-ascii?Q?laiYmllXcfuo7D8cvVIFMsU4Tqfx+2o5U91N7a7KoG8TAm/ePspdZISs6geg?=
 =?us-ascii?Q?zGNsxWM2zR0SvHCrNPEWywsxrDaQKPouGSlBMOBoxccY/S2UnB3j+WOE9Gvq?=
 =?us-ascii?Q?h7VPGPqfWnO22JSBlTQu1v1mWlxLGfvHA7KPL0PtxzbybeUqEwc6OVQW02Ml?=
 =?us-ascii?Q?bqRF6aWVyI+csUzJkKJwSwJCqzfiLUz8YFRNV+Ws8LRM2efXpKSlN6pH3Ez0?=
 =?us-ascii?Q?xiB3ZA1YjCNKY/+Yeqcfb6SdQDVlTpff3EvMAlGT18eqqCsdG2ps/2xEEzLF?=
 =?us-ascii?Q?EaegivWx095xkN6rgwjYeKvWrMAl1pDEeYrKDKyx92LY+Aqw+ifvMOwqyMr9?=
 =?us-ascii?Q?kDo1ZFsskgw0+5BClgpK7u84YSORE3WzIjJRYPRIVP2SwnEbX+HyTcmmamZn?=
 =?us-ascii?Q?9XbgN4WeWEhgeU7E2kC7w0iAE+qAlf3EIaMBdYtuvNst18vAu/H6oyU/zrQ6?=
 =?us-ascii?Q?P/Hux6PK3LPDk1y/qMF1zeG0Z8Kt7EkTfnwHVhOBvrNJNh/dcbfSyvB1J43C?=
 =?us-ascii?Q?0e9/NRTkShojTEtnDdGBGoSWjmdDg4qgrClrcgrc8PCdM8Aps7OZQ9HnBI/F?=
 =?us-ascii?Q?i/YZ5ykljMHwLuhGu2kFZGkBV+SOThDCa/scVEHEZOb/u73CpXZp+e7x/vHG?=
 =?us-ascii?Q?zZZmmUe6Y97vU7gb3zNEz6P7RleaSa4J/HwkYT6AY21EJE7F71FB2nYG48q8?=
 =?us-ascii?Q?AzzhKaUCb9Eht9WgVh0uhaGFweAb/MfD8bTzp03CfNqW/ZPCNPo43tXjswcJ?=
 =?us-ascii?Q?jfI0/jl76t2NrmSCUjlSPkG3FUo11yu2sZfPReQeSO/Bn7w/Vrndsw5M0yNm?=
 =?us-ascii?Q?C0UXlvzsH+BbGV1uHqXht1EKK7va0qyekIpETGitNshcB5g8q5Iqz0G/oAvy?=
 =?us-ascii?Q?DufziBj05uudQskij4ynDTKvTq5Oh5waYD0ygY0bjVY8NhoGKEWH4Ak3SeO4?=
 =?us-ascii?Q?12qv+NKiPWzrLzAQQtaBy/+pJ9SxQITtgzfQRjM3f2MHGsiaqXv+wKr5xC0J?=
 =?us-ascii?Q?3m0mIoHVuhLSnHl8/G1Ez/DkSYEjtMh8Yke9D6RWdE+VQv59HmH2VKxG7h0v?=
 =?us-ascii?Q?vv1ddttpVBaEAiWiTd9B/AoJnSMwXDvPq0Ck1qIW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 24914d4e-3473-4b01-608e-08d9d0cb425c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 04:16:06.1174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tTjmlpxJGQl5bK/ZKB5W1KGPm0iAAdmH8C0gVRirIuxUHVzji72MR/0Kc8M2jesz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2663
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: cY9BVt-hBuDPIFVCP-TS52yTS1XLP4Qd
X-Proofpoint-ORIG-GUID: cY9BVt-hBuDPIFVCP-TS52yTS1XLP4Qd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_01,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=875 bulkscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060025
X-FB-Internal: deliver

On Tue, Jan 04, 2022 at 01:10:43AM +0100, Vlastimil Babka wrote:
> The fields 'next' and 'slabs' are only used when CONFIG_SLUB_CPU_PARTIAL
> is enabled. We can put their definition to #ifdef to prevent accidental
> use when disabled.
> 
> Currenlty show_slab_objects() and slabs_cpu_partial_show() contain code
> accessing the slabs field that's effectively dead with
> CONFIG_SLUB_CPU_PARTIAL=n through the wrappers slub_percpu_partial() and
> slub_percpu_partial_read_once(), but to prevent a compile error, we need
> to hide all this code behind #ifdef.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> ---
>  mm/slab.h | 2 ++
>  mm/slub.c | 8 ++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 362832f465e6..ac8be7dab535 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -25,10 +25,12 @@ struct slab {
>  	union {
>  		struct list_head slab_list;
>  		struct rcu_head rcu_head;
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  		struct {
>  			struct slab *next;
>  			int slabs;	/* Nr of slabs left */
>  		};
> +#endif
>  	};
>  	struct kmem_cache *slab_cache;
>  	/* Double-word boundary */
> diff --git a/mm/slub.c b/mm/slub.c
> index d08ba1025aae..261474092e43 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5258,6 +5258,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
>  			total += x;
>  			nodes[node] += x;
>  
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  			slab = slub_percpu_partial_read_once(c);
>  			if (slab) {
>  				node = slab_nid(slab);
> @@ -5270,6 +5271,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
>  				total += x;
>  				nodes[node] += x;
>  			}
> +#endif
>  		}
>  	}
>  
> @@ -5469,9 +5471,10 @@ static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
>  {
>  	int objects = 0;
>  	int slabs = 0;
> -	int cpu;
> +	int cpu __maybe_unused;
>  	int len = 0;
>  
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  	for_each_online_cpu(cpu) {
>  		struct slab *slab;
>  
> @@ -5480,12 +5483,13 @@ static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
>  		if (slab)
>  			slabs += slab->slabs;
>  	}
> +#endif
>  
>  	/* Approximate half-full slabs, see slub_set_cpu_partial() */
>  	objects = (slabs * oo_objects(s->oo)) / 2;
>  	len += sysfs_emit_at(buf, len, "%d(%d)", objects, slabs);
>  
> -#ifdef CONFIG_SMP
> +#if defined(CONFIG_SLUB_CPU_PARTIAL) && defined(CONFIG_SMP)

CONFIG_SLUB_CPU_PARTIAL is defined like:
config SLUB_CPU_PARTIAL
	default y
	depends on SLUB && SMP

So I guess the " && defined(CONFIG_SMP)" part can be dropped.

Otherwise lgtm.

Reviewed-by: Roman Gushchin <guro@fb.com>
