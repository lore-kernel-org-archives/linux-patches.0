Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0426E3FF4
	for <patches@lists.linux.dev>; Wed,  2 Mar 2022 18:02:03 +0000 (UTC)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222FrVfu004476;
	Wed, 2 Mar 2022 18:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=Ecfr1lWooPK7EFSXfaFaOgEiH/8IP3GWVaG5xGL9pQM=;
 b=qiAO4AmIiIvjOsAOkh2IINxxYs6u49xleBzu2/ytRer4ozbSvsyBHl7KyNqh1hcJAgKs
 bdgSWPE8WD+m/SmlZ0wmlphUWROp4Wg8ho5wLKzD+N8uSjWbTZh9Uz2R2gvEZmnQKhth
 JZ2ynnz5TjVejyqKwivJV+OlqzHpQEpNU7qh+Mou0/B7m9d3lVdRqAtpzaDfskuA+/Zm
 k9A8RqRlimgiw78YSRuzTSfNImoHlU6BG7rGQp4UUs6xYMzHR+ORKhwYfEjIQqWOzeBi
 fp1PzsHX/xVR9DghJjht21n8UliP1G1W9YVTBQmoND7tDET0TMnYM7EhbeLE0VPpAxHq EA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3ejbmdtn9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Mar 2022 18:01:46 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222HsJhq019012;
	Wed, 2 Mar 2022 18:01:45 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3ejbmdtn8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Mar 2022 18:01:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222HhI7e005631;
	Wed, 2 Mar 2022 18:01:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma01fra.de.ibm.com with ESMTP id 3efbu9618q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Mar 2022 18:01:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222Hoi9E23593274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Mar 2022 17:50:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D4F9A405F;
	Wed,  2 Mar 2022 18:01:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A709CA4064;
	Wed,  2 Mar 2022 18:01:38 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.6.152])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
	Wed,  2 Mar 2022 18:01:38 +0000 (GMT)
Date: Wed, 2 Mar 2022 20:01:36 +0200
From: Mike Rapoport <rppt@linux.ibm.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        Oliver Glitta <glittao@gmail.com>,
        Faiyaz Mohammed <faiyazm@codeaurora.org>,
        Marco Elver <elver@google.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Imran Khan <imran.f.khan@oracle.com>
Subject: Re: [PATCH v2 1/6] lib/stackdepot: allow requesting early
 initialization dynamically
Message-ID: <Yh+xAGvzV6WQC5Q/@linux.ibm.com>
References: <20220302173122.11939-1-vbabka@suse.cz>
 <20220302173122.11939-2-vbabka@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302173122.11939-2-vbabka@suse.cz>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VzkmQiUA1xiDd9HfpIRConjGr6CA35-w
X-Proofpoint-GUID: JOby3tPVJ_KbezTIQZTIpNpXBsUXVLW7
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020077

On Wed, Mar 02, 2022 at 06:31:17PM +0100, Vlastimil Babka wrote:
> In a later patch we want to add stackdepot support for object owner
> tracking in slub caches, which is enabled by slub_debug boot parameter.
> This creates a bootstrap problem as some caches are created early in
> boot when slab_is_available() is false and thus stack_depot_init()
> tries to use memblock. But, as reported by Hyeonggon Yoo [1] we are
> already beyond memblock_free_all(). Ideally memblock allocation should
> fail, yet it succeeds, but later the system crashes, which is a
> separately handled issue.
> 
> To resolve this boostrap issue in a robust way, this patch adds another
> way to request stack_depot_early_init(), which happens at a well-defined
> point of time. In addition to build-time CONFIG_STACKDEPOT_ALWAYS_INIT,
> code that's e.g. processing boot parmeters (which happens early enough)
> can set a new variable stack_depot_want_early_init as true.
> 
> In this patch we also convert page_owner to this approach. While it
> doesn't have the bootstrap issue as slub, it's also a functionality
> enabled by a boot param and can thus request stack_depot_early_init()
> with memblock allocation instead of later initialization with
> kvmalloc().
> 
> [1] https://lore.kernel.org/all/YhnUcqyeMgCrWZbd@ip-172-31-19-208.ap-northeast-1.compute.internal/
> 
> Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/stackdepot.h | 16 ++++++++++++++--
>  lib/stackdepot.c           |  2 ++
>  mm/page_owner.c            |  9 ++++++---
>  3 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
> index 17f992fe6355..1217ba2b636e 100644
> --- a/include/linux/stackdepot.h
> +++ b/include/linux/stackdepot.h
> @@ -15,6 +15,8 @@
>  
>  typedef u32 depot_stack_handle_t;
>  
> +extern bool stack_depot_want_early_init;
> +
>  depot_stack_handle_t __stack_depot_save(unsigned long *entries,
>  					unsigned int nr_entries,
>  					gfp_t gfp_flags, bool can_alloc);
> @@ -26,11 +28,21 @@ depot_stack_handle_t __stack_depot_save(unsigned long *entries,
>   * The alternative is to select STACKDEPOT_ALWAYS_INIT to have stack depot
>   * enabled as part of mm_init(), for subsystems where it's known at compile time
>   * that stack depot will be used.
> + *
> + * Another alternative is to set stack_depot_want_early_init as true, when the
> + * decision to use stack depot is taken e.g. when evaluating kernel boot
> + * parameters, which precedes the call to stack_depot_want_early_init().
>   */
>  int stack_depot_init(void);
>  
> -#ifdef CONFIG_STACKDEPOT_ALWAYS_INIT
> -static inline int stack_depot_early_init(void)	{ return stack_depot_init(); }
> +#ifdef CONFIG_STACKDEPOT
> +static inline int stack_depot_early_init(void)
> +{
> +	if (IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT)
> +	    || stack_depot_want_early_init)
> +		return stack_depot_init();
> +	return 0;
> +}

I'd also suggest splitting memblock allocation from stack_depot_init() to
stack_depot_early_init().

>  #else
>  static inline int stack_depot_early_init(void)	{ return 0; }
>  #endif
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index bf5ba9af0500..02e2b5fcbf3b 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -66,6 +66,8 @@ struct stack_record {
>  	unsigned long entries[];	/* Variable-sized array of entries. */
>  };
>  
> +bool stack_depot_want_early_init = false;
> +
>  static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
>  
>  static int depot_index;
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 99e360df9465..40dce2b81d13 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -42,7 +42,12 @@ static void init_early_allocated_pages(void);
>  
>  static int __init early_page_owner_param(char *buf)
>  {
> -	return kstrtobool(buf, &page_owner_enabled);
> +	int ret = kstrtobool(buf, &page_owner_enabled);
> +
> +	if (page_owner_enabled)
> +		stack_depot_want_early_init = true;
> +
> +	return ret;
>  }
>  early_param("page_owner", early_page_owner_param);
>  
> @@ -80,8 +85,6 @@ static __init void init_page_owner(void)
>  	if (!page_owner_enabled)
>  		return;
>  
> -	stack_depot_init();
> -
>  	register_dummy_stack();
>  	register_failure_stack();
>  	register_early_stack();
> -- 
> 2.35.1
> 

-- 
Sincerely yours,
Mike.
