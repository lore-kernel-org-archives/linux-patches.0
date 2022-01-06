Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C65D2C80
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 04:12:22 +0000 (UTC)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 205N524n028602;
	Wed, 5 Jan 2022 20:12:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=mBY0aVGrmg/UmGknsP0e3kT60vbGeb2O0zkHrou2tKk=;
 b=oQX2FWklwhmFWJq902HKWMMf39nPSUD7d1RAV4fY8lzDY8Lz0+IYq5YYuZwVUEhS7WG+
 TFu+AtMQbOkPy2kS59dT/95l0ZYZS0n5btEjLG6L7q/O4V0aWk8aTadDwgwdwW8sBLbo
 eIfdiAq89w/AikRrMbLQTBbVzVWyG3zGmHY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ddmpe17nm-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 05 Jan 2022 20:12:07 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 20:12:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpKH7ZB6B/u1sNSZRVplaFyuc8Di9S7MYFrXyLPTk+IinRL2AAHXLUsmUcE8A5bVyWvoUYH5DxTnphI+HMX2/bz7iybHSKXwDIfcI4GAOq1xyhwTfhhxtU4t2EakPtc1Cbv2SDRqjZgIj16cZrNF+QL35+JKiVjyMjIvwBjgEYefG7r5g7rhwfLY4+FsCSa+JZ9szAi+E22PdLhf34XR78JplAUjD7yi8Hfz/T2/f40B0QzDJxdPmDnpRoZgSVyJ9N4urAxVhgF/cwnOTVrytfr3HLMQ8gayzclfL7lSCymlM7g+UUwxtID/oTaIINjVAyBZQesMLK/gBiSZUTk6EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBY0aVGrmg/UmGknsP0e3kT60vbGeb2O0zkHrou2tKk=;
 b=iY4f39de+vLLFiVoegQQjr5f4oP+hSBoIwRNtwXJJ4yTEneJyENMF2XM3OSlS729qfu43dAoksN2ne29RxSJjkevJTTraWQgpkoTVaBtvsi8pZezxMe+5fbmeWUVcfuYt6Pq3fSP6RqhgPgRnd2NPvX4f9nwAAC81iNLzE6vXnzFs1gEXEcZkDXCZAcyVjMdn6E96x2MwiVc5edJqSxbXmibvDhjbULFst3wriBAU9JWiPZpl+IjFRYHrJim56cyAoPdmRUNtFYhvue0HQJ6AthXPitAe8+cH5WXIkbS8OBqq+fidDOEzTMla2MkX0w6cQopyS0/+1Qc0Cem9Y+emw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3143.namprd15.prod.outlook.com (2603:10b6:a03:b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Thu, 6 Jan
 2022 04:12:05 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913%3]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 04:12:05 +0000
Date: Wed, 5 Jan 2022 20:12:00 -0800
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
 Yoo <42.hyeyoo@gmail.com>, <patches@lists.linux.dev>,
        Marco Elver
	<elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov
	<dvyukov@google.com>, <kasan-dev@googlegroups.com>
Subject: Re: [PATCH v4 27/32] mm/sl*b: Differentiate struct slab fields by
 sl*b implementations
Message-ID: <YdZsENIJU3QQXDMD@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-28-vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-28-vbabka@suse.cz>
X-ClientProxiedBy: MW4PR04CA0155.namprd04.prod.outlook.com
 (2603:10b6:303:85::10) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4cf05af-b369-4334-a8a6-08d9d0cab2df
X-MS-TrafficTypeDiagnostic: BYAPR15MB3143:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB314387BE140278471E773F7CBE4C9@BYAPR15MB3143.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2OVrQ0wBc/fyMKJrx78P/QndDIx1iQk/CCZG3tdVH4cmcs29pYxwKfEwCvus6I80TFhHGrU47Ij0VMXbUkmXHuqRTnvlTYjjdiu+/dZZRxIs7MdwbGxuMg8nouaaJ+6BvQrhIzhbeeyGcSx8O9DeRkZ88b0/L44rVTUJIQA53tf2iRrND/zQSoOil9Q2O8Iv7sOLj47YRMiBXyQC7MLyhnLHYoAeUqrOj9KwrJZvnM0QgBT4or1ONR6fRLBLyNG23ujqiYnx5Eo0lm5BpoR1HuVfPI+XuYPMzn581Im3H1VcNop+1Oqr5hUFS1oqeVOz3NrOhVRLGvAq0c1a4azLKzMydpHZRScx16UWBOJ17WEkFFgVQb0+MuUPyQk4pSafJ3NakzTgr6LXuQMzh22enpvGsMnwMFOaade8JFXf1pKiIcupZJSGadLTbbar1YShHcaqtYiaB09TL5cm7tXe2EBSVKncvz6ybSoTZyDn+v+mRJ3PC3KHmw2B94RVrmwjF3T5e4vanDaiCWJ4mNHe9+k4Vj6z7zaHgkXD17V8s520C8tez/4aZ2FYjNsVPyguxCsjI1tu3+x16ITWEU1tdYdNfBinUxERg+d7cZPDMfY7thBUGVV7FRyvSyjABjkzjwOTH0JXyYAqTCjPSr0Mvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(8936002)(66556008)(2906002)(52116002)(186003)(6486002)(508600001)(6666004)(66946007)(4326008)(5660300002)(38100700002)(83380400001)(6916009)(54906003)(6512007)(9686003)(8676002)(316002)(86362001)(7416002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OTiTlcLzhO0rmuwABmzVLPXj+ULw1KQc4PETht/FoBwQsqkRb1EZ/N2ds6nB?=
 =?us-ascii?Q?Stp3dqg3osOrMa7Frf80rGrfcAxNrGDY4DvR0AjrM2H6b/L4NJNhofjCOpn5?=
 =?us-ascii?Q?CPLWhpVVtspxkvmi4Z6AdjZN2taWWEPqLYqlM7pAUGbWjZkQTp4voRyrK40o?=
 =?us-ascii?Q?XmLrOD6VeQgrKz/cHx3J8RZ8WQUpEHdfLlO6GKjsaAIUu05RIpM/zJThMC/h?=
 =?us-ascii?Q?H+3llwflGpSGvhrEQC8ANpouxMGr2zri6mZCIcWuxL8SjS3ICeTaBtmIVYNh?=
 =?us-ascii?Q?00UI7k8ry7AT8pu5/b1FGalOqxOuuvakIRethtdXKPijvYobLoA2D8txlBPy?=
 =?us-ascii?Q?sl9ZytjxERyHVBkRAQqTLCVOf1YtDtEN106KVEHeXIsUIMu7z6+xunwhXVvS?=
 =?us-ascii?Q?Ah8NHo33I0nH4s1cvyNx9GZoAkrXmFRCVqCdWyFuMnnYoKKM4h1NL8p38sM7?=
 =?us-ascii?Q?VeAS/P2m7qooo8N9wXAWvhWaFOcGvOpQGbcaxvWn1Pxsw6xQoharNS526NAj?=
 =?us-ascii?Q?u0dMxRZRAS7J7hXC4yaOq+EheCMo0JWpUpgWHG0poUKx++eClei+XIfi7Vl5?=
 =?us-ascii?Q?DYacH/hlEIt9SMX50i1m6CQ0adLvSWmwyQB5EJB1gXwo+Hc7rHYo1shc1kGY?=
 =?us-ascii?Q?cFwNH3glQthAkU4wRlfgEz0z1ollBBWJ/f0612uW4iw3Cdd49gL9CXMFR+iF?=
 =?us-ascii?Q?bLCbB27r5j+NlTX/jPNajocUiGKFaWC6yOoYRS2Pg1N4fKQAEBbtcIZJStWW?=
 =?us-ascii?Q?4ocGJ4CgZE5eZMWjsEHmcDPYdVopb99CcyVrjjK03XUJAL+27vcIdZR1h1AC?=
 =?us-ascii?Q?v1IDIzFaTnajMTi6wc8NyZfLCEJ+rW97v2aKUC9b6eIe1FNZ3WodFM24EdC1?=
 =?us-ascii?Q?y2nz1M2smMcSBaWzYudaph0DT9E/Z4WVPA1h/o8eA8TWey9ED2iUqi7BGRXz?=
 =?us-ascii?Q?rORb4/EhZEbT6/xC8N8qpLGIeIkJjI51Cf8+SMQAVWuigP/XBKDYrQ5Tj+Yx?=
 =?us-ascii?Q?OidbFdMi2wAbq14TW+6R0oogz+XCbjnSdoPNdHXb/7pt1ibSQHSUiPqRgXAT?=
 =?us-ascii?Q?4lDxP0uoFu2Ex85hDFjjns+t1dOu+w8ccqnBfYcCpnweHgWj/k27Qb3USWZN?=
 =?us-ascii?Q?BUiUZD43+0N3byamYbR+aUXT1D4sjJzTxy4l9/5pXJ5NGI/rKEHH/qM4McNh?=
 =?us-ascii?Q?+5ca2919U1yv0YTLpwny/Ku8I4oi2I7cN7zPZmELJbv7u2M8KBoA7Q3wc0ak?=
 =?us-ascii?Q?hamLTc8o10AT969AL7Y6ThGdx0O/LeW8EyfMOoVURhH5YBjwOWrH1/aTTgyA?=
 =?us-ascii?Q?fmew4RjnwyjmM4xPdIToHklLlvzXId4q3q+5PRHsUNfBI68smopjTQFMSQvx?=
 =?us-ascii?Q?VhesEJrymCDE7CEMP5H6wIYBhKCyVQSpBLaK73PFDltkFoP/ZtrF1mXRjEtB?=
 =?us-ascii?Q?KZaTbFh1yY+LthMlLjywFgQQsYZL3EMF7f9+HW/B0Lg+OgML+aLw0I13FD/W?=
 =?us-ascii?Q?cF6VVxm4ZPskoceVjXpEbxBA0AC6Q8iHe09ad/tzuYY2Ie1eKIeCBu8SoJNV?=
 =?us-ascii?Q?Te4Pnus8oPelQlsxyWtJg/NDoFLSp+bNFFFo9P7L?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4cf05af-b369-4334-a8a6-08d9d0cab2df
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 04:12:05.4015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yejlAy8JTC7ut/cQUuEUuDd8qWUiFC/sdMMS4+2P/7qD1yQipjA5tK0qSZzIhr9L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3143
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: e4t3ssZibJ3UEK0q6N5uwm4J-jJhRP8A
X-Proofpoint-GUID: e4t3ssZibJ3UEK0q6N5uwm4J-jJhRP8A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_01,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=782 clxscore=1015 adultscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060024
X-FB-Internal: deliver

On Tue, Jan 04, 2022 at 01:10:41AM +0100, Vlastimil Babka wrote:
> With a struct slab definition separate from struct page, we can go
> further and define only fields that the chosen sl*b implementation uses.
> This means everything between __page_flags and __page_refcount
> placeholders now depends on the chosen CONFIG_SL*B. Some fields exist in
> all implementations (slab_list) but can be part of a union in some, so
> it's simpler to repeat them than complicate the definition with ifdefs
> even more.
> 
> The patch doesn't change physical offsets of the fields, although it
> could be done later - for example it's now clear that tighter packing in
> SLOB could be possible.
> 
> This should also prevent accidental use of fields that don't exist in
> given implementation. Before this patch virt_to_cache() and
> cache_from_obj() were visible for SLOB (albeit not used), although they
> rely on the slab_cache field that isn't set by SLOB. With this patch
> it's now a compile error, so these functions are now hidden behind
> an #ifndef CONFIG_SLOB.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Tested-by: Marco Elver <elver@google.com> # kfence
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: <kasan-dev@googlegroups.com>
> ---
>  mm/kfence/core.c |  9 +++++----
>  mm/slab.h        | 48 ++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 43 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 4eb60cf5ff8b..267dfde43b91 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -427,10 +427,11 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
>  	/* Set required slab fields. */
>  	slab = virt_to_slab((void *)meta->addr);
>  	slab->slab_cache = cache;
> -	if (IS_ENABLED(CONFIG_SLUB))
> -		slab->objects = 1;
> -	if (IS_ENABLED(CONFIG_SLAB))
> -		slab->s_mem = addr;
> +#if defined(CONFIG_SLUB)
> +	slab->objects = 1;
> +#elif defined(CONFIG_SLAB)
> +	slab->s_mem = addr;
> +#endif
>  
>  	/* Memory initialization. */
>  	for_each_canary(meta, set_canary_byte);
> diff --git a/mm/slab.h b/mm/slab.h
> index 36e0022d8267..b8da249f44f9 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -8,9 +8,24 @@
>  /* Reuses the bits in struct page */
>  struct slab {
>  	unsigned long __page_flags;
> +
> +#if defined(CONFIG_SLAB)
> +
>  	union {
>  		struct list_head slab_list;
> -		struct {	/* Partial pages */
> +		struct rcu_head rcu_head;
> +	};
> +	struct kmem_cache *slab_cache;
> +	void *freelist;	/* array of free object indexes */
> +	void *s_mem;	/* first object */
> +	unsigned int active;
> +
> +#elif defined(CONFIG_SLUB)
> +
> +	union {
> +		struct list_head slab_list;
> +		struct rcu_head rcu_head;
> +		struct {
>  			struct slab *next;
>  #ifdef CONFIG_64BIT
>  			int slabs;	/* Nr of slabs left */
> @@ -18,25 +33,32 @@ struct slab {
>  			short int slabs;
>  #endif
>  		};
> -		struct rcu_head rcu_head;
>  	};
> -	struct kmem_cache *slab_cache; /* not slob */
> +	struct kmem_cache *slab_cache;
>  	/* Double-word boundary */
>  	void *freelist;		/* first free object */
>  	union {
> -		void *s_mem;	/* slab: first object */
> -		unsigned long counters;		/* SLUB */
> -		struct {			/* SLUB */
> +		unsigned long counters;
> +		struct {
>  			unsigned inuse:16;
>  			unsigned objects:15;
>  			unsigned frozen:1;
>  		};
>  	};
> +	unsigned int __unused;
> +
> +#elif defined(CONFIG_SLOB)
> +
> +	struct list_head slab_list;
> +	void *__unused_1;
> +	void *freelist;		/* first free block */
> +	void *__unused_2;
> +	int units;
> +
> +#else
> +#error "Unexpected slab allocator configured"
> +#endif

Nice!

Reviewed-by: Roman Gushchin <guro@fb.com>
