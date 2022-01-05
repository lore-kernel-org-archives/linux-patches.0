Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB56173
	for <patches@lists.linux.dev>; Wed,  5 Jan 2022 01:01:14 +0000 (UTC)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 204M3SaJ022709;
	Tue, 4 Jan 2022 17:01:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=de29XjUhcR+BuvdwhSjRfJhrwMhstb84HAUhi0c8Q9o=;
 b=Zi62cRGJKv0Bxb+cuWTidsMiF0GB4tzDNmXWKpCKqhhNGdqaQppsDSfF63+PmEKb6UEs
 fQt7JIo3rtJUfZdIAe25+TZVPXct525VbtnQTvNXdWpNSIttBhUtCoaqyWiMbAxcSYu8
 dU5YrD0t2jXPwDo40MaevrrN5qNcCof58w8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 3dcxpr0us3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 04 Jan 2022 17:01:03 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 17:01:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yikjq4eafX5amZjgbWLVUc9sABDUjGpwOTCCSEo3PjVHBxh+n3rjYA+nO+8CIf+m/1ccNonESR8hCoQnioac6WkaJSLWCFJrjQyRozaU54vxozFkm5g8XCITwETdabJ9KI6egq+6y0GKiWvi07TdcLnja812x7/BzJrrT1vwD4FSoU2iM2xnBrSgeDugA7Y9Cif0jw8vb1+l3MyY2U47g/n5Rav0h21j+OpT8liwad0Xc4LGbDG2yeQJxrWdRSgj/F9ZwHTmsFenDvRtVENbnOChYX0qu1vMSseDA2vvnTfaESbJn8CiTZRKCV1WQcI03RQMRJgXcG4PCMtsPmJI7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=de29XjUhcR+BuvdwhSjRfJhrwMhstb84HAUhi0c8Q9o=;
 b=GYTmkCYtZ1L/RkwUpfM2gllPpNPcp76Aupyx7ir4Z4G4hNwjg1ci+v9sJZPp9bEs1iXBxOj71jj67GTNz7AtmlZunWLu3EM5t/kIo57NyRf4iZHtcpKYVN1iNXx77RSoJ/8+BR1CScufZ3rB7UltRn8XN2H2/OYZdFoc0QHreqPG2LrviEfEx7oLjHJf42Yg3HXdK2Hxbe9yAw/JIyYzPUr5VkxXJeFReUtwcA64H2Jor06wSF2fSSVFVRTr5F6sUO7RmFGE3Gasv/0sz8krgRg7zXoj31RfFLnGeyAkSlZ81hVwXjtJKEB8ExaN9yjuShgWiJ8qo03VpHumNDGvVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2517.namprd15.prod.outlook.com (2603:10b6:a03:151::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 01:00:58 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 01:00:58 +0000
Date: Tue, 4 Jan 2022 17:00:53 -0800
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
Subject: Re: [PATCH v4 11/32] mm/slub: Convert kfree() to use a struct slab
Message-ID: <YdTtxVgABILFkAIN@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-12-vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-12-vbabka@suse.cz>
X-ClientProxiedBy: MWHPR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:300:115::15) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ed9fb0c-38df-414f-dc2a-08d9cfe6d568
X-MS-TrafficTypeDiagnostic: BYAPR15MB2517:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2517D05DD7FF2BB554EBD79FBE4B9@BYAPR15MB2517.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:234;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBQLG4s3gqN9D+X6QSKGwjR8v/grIrJI6s697us4elaW671yrMQJqR4hhAB4KN+Iehl7rbM2h0ggxZWu9ppHsHs03GCwO6Lyn7La1R3kvJ6jXDjk3QaU9kCA1Fv6bo8EcuA2xfYpvZuw/8kBJ477PsP9V5Cdld2TMcRjZ8jf1Dg2ILkx1jF766i1bIwB+ieX3RZo06iXgB2nw1WcFLqr/brkBRZuUZ5PLTmSUv4jtg9SozRwKOe0A56znH4FmemxnTKQYmuZd2qT6x43RcCcs8xyhOWIEIf40X6cGM5D8lL0D7ceekzXcclCa7YxhXffVZomQXSs/zS8CM1XvZCcsYKH0qZ08ERmmmAaakcFG0tov7IdXokvuWmleHElOHRESjAfWJDW6BRN1MJsEeHy2wZLa4QE05na6gjWxehhpDLvoQbN8sGvU8gii8gz82SbarRthnfsnXl8wF6VzCzbO4zFzwG3J2eEOOF72fYZPBLewpTDYKaCjaZ8Y1fwy+W2L0y7CezG2UosQgmTYptAo/EoXqcmearwBebtgiy7YdZz20lcG6NO/fQQ7Q0NTwP/B4eGMymja5kl1Xo+FHMvUdMTwrmkln+7w0KZDStufxrIMYqasDV0pgGqiCq1PTmA5ofT4C2mdw9pUOnEaiHJhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(2906002)(8936002)(6506007)(54906003)(66476007)(6512007)(52116002)(508600001)(6666004)(8676002)(66946007)(86362001)(5660300002)(7416002)(66556008)(316002)(6916009)(9686003)(4326008)(186003)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Jxl/VV+cgXbKyatnogKhpekuirvgdXXflmCMNBmVbLXsh0WeSpLxlrF4WgO?=
 =?us-ascii?Q?wFPsI69IbrlkS91ZZrvoJdSyTSs8V8w6ioKeFKVOPOBmJsXh9ZawfvuKwDpM?=
 =?us-ascii?Q?euLaozQlCiLxtCALw9as6oCrAzrFyCdTYIRubMEK1KPcXaFd2GwVpl7jEjMT?=
 =?us-ascii?Q?7Ry6D8J/JoO7eJXH11zb2wENPjNx5MkE2KZDd2bju8nhy7Ely95BYdszJdT0?=
 =?us-ascii?Q?aAnXVxzxpohcxqkwqITCHDDuxjs7EfrNGZF1ZGk5q0m38S/zfbWwPATSJPFM?=
 =?us-ascii?Q?pw/CaM+7hWIJG6F8cYaYZvWyDnLb/LJmm5af2jKoHQ2dCt/khWve03WQa5wN?=
 =?us-ascii?Q?+N0RL18iSlfMhRl6K48SdiP0beWdjQNPHySP3omURXK6/mzgimBda9IDH21S?=
 =?us-ascii?Q?IVDzYeAUAt/YSbydw5VwPUZO5P0UJLSnyhNdJD8Iu2iqyu2DOA3OEM6GtuhF?=
 =?us-ascii?Q?M0gbTQmaOp2PkFezjmJjvMXM/wfYBkE/yaP/aQ6XKrAUylrQro4xBwVeMPN4?=
 =?us-ascii?Q?vyzliY+pgKLnQ8zPiaWSpWbOfHQ6gVgwiHGvTF1vGUYxSTVxCyCKJu/gl1fx?=
 =?us-ascii?Q?12OxUrDzSzaTaAqe9wVf59WzQ2fgbpsYsYtRRspqATFsIIL/0KA2MRQ1Tgkl?=
 =?us-ascii?Q?k20t5gMxAKkb6fvXHi3O/r5PkT716gWxaZoq1aZ2GixOYAgH/VII7r1M1cc1?=
 =?us-ascii?Q?3sv0y1oNUOKWMomha1lPeUgH+4ErSnijSQhaVW8R7aPVvSFsUpinErQRarWM?=
 =?us-ascii?Q?ZGJko2Bu95+HOMci2tsgcCsrr2Hr492BVjNRr81ys0q98owmT9a2FJeZvQmj?=
 =?us-ascii?Q?8HMIgLcjvbZJyUl4GAWfGhsZU8D6GtLUu+cJcGhH4FJOTVYXAZC2j2MqRxZk?=
 =?us-ascii?Q?b76EJxNRXhKszgb5Hyi7tpvQrFDqu4YdCQSo0VXb9GBbwR/DQz7xMedQaV0I?=
 =?us-ascii?Q?BEEQJ/wBshGo3SAkN3V7B5N1KnqBr9KTNkENF/8ZXrMZkwbesmSv+3IG6iVp?=
 =?us-ascii?Q?cj3w1PuE96sXKpaJabcHxkWalAQvOwCm6tIdov9pMoKUPn5F3+4oH5gS9ZlI?=
 =?us-ascii?Q?hteKqe0MxSBQz0Ac+8vFm2pwvHGfm/5PqxgFTQCqgyANOxnPxfDIeDPfR3BF?=
 =?us-ascii?Q?N8O8dPlvi/MAqQzFxmur54PBFAqvn0w1C9cP8BxdYnjbmqRJT5mYMGVifPPb?=
 =?us-ascii?Q?jN+6JtTURQ715Cz/giK9qzIgQXX8RYIgudMHRGZduZCbUNf9Ivb6RN291AC4?=
 =?us-ascii?Q?flczTZHBu+mMZMjh5cgKgbSQcQ85BuedqrJj4MYQM+xwswZUM9V181QUF1I0?=
 =?us-ascii?Q?2YKrjXQL1iglBwUlfyRSTJfNM/jHDJLum4/lEeR9le4Z4t0KkCK61Yngyds/?=
 =?us-ascii?Q?hQjbR2bCs9wJRWz5d/8F6l000SD2Mp7FRYaVwXP3YT8G674xXKUr1A1C9MM5?=
 =?us-ascii?Q?M1FVGpl5QMhcnNbck9dGtB4mSFsNhKIhaAk+VsAJgAHDhfmnAD56SAkZgv5T?=
 =?us-ascii?Q?Cs6owZ2s5l61fVxBm7dRDXaou6ziMVmqOj7b8j50ov2bgEXbY/PaRePppoay?=
 =?us-ascii?Q?TRUnq+aQnXq76WzkCJSf7w31FSPQ7kN2/DH+3uM3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed9fb0c-38df-414f-dc2a-08d9cfe6d568
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 01:00:58.1045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xE693bZ4OJbPTfZzJgFFCfGAmEggamx8nUcXvnkV8aCLnt9fU3HkvAinQ5PpRl8v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2517
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: hTn2ERFeZ8VJYj3sVJ5aZnaQmF4KcDjV
X-Proofpoint-GUID: hTn2ERFeZ8VJYj3sVJ5aZnaQmF4KcDjV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_11,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050004
X-FB-Internal: deliver

On Tue, Jan 04, 2022 at 01:10:25AM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Convert kfree(), kmem_cache_free() and ___cache_free() to resolve object
> addresses to struct slab, using folio as intermediate step where needed.
> Keep passing the result as struct page for now in preparation for mass
> conversion of internal functions.
> 
> [ vbabka@suse.cz: Use folio as intermediate step when checking for
>   large kmalloc pages, and when freeing them - rename
>   free_nonslab_page() to free_large_kmalloc() that takes struct folio ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index a45b74d2712f..acf2608a57c5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3517,7 +3517,7 @@ static __always_inline void slab_free(struct kmem_cache *s, struct page *page,
>  #ifdef CONFIG_KASAN_GENERIC
>  void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr)
>  {
> -	do_slab_free(cache, virt_to_head_page(x), x, NULL, 1, addr);
> +	do_slab_free(cache, slab_page(virt_to_slab(x)), x, NULL, 1, addr);
>  }
>  #endif
>  
> @@ -3527,7 +3527,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
>  	if (!s)
>  		return;
>  	trace_kmem_cache_free(_RET_IP_, x, s->name);
> -	slab_free(s, virt_to_head_page(x), x, NULL, 1, _RET_IP_);
> +	slab_free(s, slab_page(virt_to_slab(x)), x, NULL, 1, _RET_IP_);
>  }
>  EXPORT_SYMBOL(kmem_cache_free);
>  
> @@ -3539,16 +3539,17 @@ struct detached_freelist {
>  	struct kmem_cache *s;
>  };
>  
> -static inline void free_nonslab_page(struct page *page, void *object)
> +static inline void free_large_kmalloc(struct folio *folio, void *object)

It's way more clear now what's it's all about. Thanks!

Reviewed-by: Roman Gushchin <guro@fb.com>
