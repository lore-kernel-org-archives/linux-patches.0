Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640B22589
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 13:23:51 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id v28so1614082pfi.12
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 05:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8y/808AEnHwi3gKJBM+uetYeo4u9vQ49H82jeAEWhHU=;
        b=V+QjrA/U7ScHxJ9ZYpE7O3RSWmSkzchs2ANjV8VzLrCCY/niTxtyQWGpPbyM9XkmyW
         WUZzaMIhKqFZFU8oxa222F3tpEq3Y1YS3msg7uTrIWc7lZ5zVT2Av3x39VFIhcPpBlAk
         G0hZmwyYAAjE6+KaJbFb3EiDMmTQzATe/MJ+UHCfocUWVLNcKAVFKgrP36sOAkUgFzeN
         HMPL3Zi3SO02hDye9/9wyECt8ctuhmRJx2U+jb9AdWcny/T0kfhMZgTavulYELFx/8oW
         VsVdiUQYGBOJ3nWlF4RTajvzflna4ZgeRJ+Q76rY2eJeasSHYJVyRRfSiXuq/KwD/6Ym
         Brfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8y/808AEnHwi3gKJBM+uetYeo4u9vQ49H82jeAEWhHU=;
        b=Dv8EVTHmvnWv40kljL88VnBi2e/NTIUJ9tJKk67UThqPHXjwpSZqGHIjardmyDYKFM
         pxgV25uTwdw8BHAm549cEO9zAMrbMLGTSghniNqFqm2q6f6g4q7zYdl6i3MyDn96FZ9v
         cw6l5sCTrPDTvEDkJabv4MwSzozSReGygNIxx/nT7xFNft54FkM4I+8d7g/VmPexL0iW
         FN0oJdwTQgSy+ml3t6Eywdzp8Mh0uvnr6recLQwFHLhVuBBYSVyJLYHAtmZLL6mTj+h6
         MdnJs4fChzfCA3P5VzaR2eYDmCv0/rAh3TqdE1btxpE6mzbJWDwyPYA3W8uvveDmYQAD
         KoyQ==
X-Gm-Message-State: ANoB5pl0gasS9PO/Plxlw9HtBr217SYxP7rQA8uwAFkd1ea4VbQGLSpv
	7NQ5ngGUQaiF9yGYKlJ8qdyKyI0Src3JsSv3
X-Google-Smtp-Source: AA0mqf4TyZNNwzl3rHjI/din13NVJjNuRxJ1olfSN/enVVVxr/ZPBliA6gHtprrBtvgwnZY7JQPUMg==
X-Received: by 2002:a63:4c4b:0:b0:46f:f112:e782 with SMTP id m11-20020a634c4b000000b0046ff112e782mr11630314pgl.219.1669296230710;
        Thu, 24 Nov 2022 05:23:50 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id ik16-20020a170902ab1000b00172f6726d8esm1229687plb.277.2022.11.24.05.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 05:23:49 -0800 (PST)
Date: Thu, 24 Nov 2022 22:23:44 +0900
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] mm, slub: don't create kmalloc-rcl caches with
 CONFIG_SLUB_TINY
Message-ID: <Y39wYPl5y3apKbD2@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-7-vbabka@suse.cz>
 <d77498f8-b15f-9dae-1803-2d2bbb99da50@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d77498f8-b15f-9dae-1803-2d2bbb99da50@suse.cz>

On Wed, Nov 23, 2022 at 02:53:43PM +0100, Vlastimil Babka wrote:
> On 11/21/22 18:11, Vlastimil Babka wrote:
> > Distinguishing kmalloc(__GFP_RECLAIMABLE) can help against fragmentation
> > by grouping pages by mobility, but on tiny systems the extra memory
> > overhead of separate set of kmalloc-rcl caches will probably be worse,
> > and mobility grouping likely disabled anyway.
> > 
> > Thus with CONFIG_SLUB_TINY, don't create kmalloc-rcl caches and use the
> > regular ones.
> > 
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Fixed up in response to lkp report for a MEMCG_KMEM+SLUB_TINY combo:
> ---8<---
> From c1ec0b924850a2863d061f316615d596176f15bb Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Tue, 15 Nov 2022 18:19:28 +0100
> Subject: [PATCH 06/12] mm, slub: don't create kmalloc-rcl caches with
>  CONFIG_SLUB_TINY
> 
> Distinguishing kmalloc(__GFP_RECLAIMABLE) can help against fragmentation
> by grouping pages by mobility, but on tiny systems the extra memory
> overhead of separate set of kmalloc-rcl caches will probably be worse,
> and mobility grouping likely disabled anyway.
> 
> Thus with CONFIG_SLUB_TINY, don't create kmalloc-rcl caches and use the
> regular ones.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/slab.h |  9 +++++++--
>  mm/slab_common.c     | 10 ++++++++--
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 45efc6c553b8..ae2d19ec8467 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -336,12 +336,17 @@ enum kmalloc_cache_type {
>  #endif
>  #ifndef CONFIG_MEMCG_KMEM
>  	KMALLOC_CGROUP = KMALLOC_NORMAL,
> -#else
> -	KMALLOC_CGROUP,
>  #endif
> +#ifdef CONFIG_SLUB_TINY
> +	KMALLOC_RECLAIM = KMALLOC_NORMAL,
> +#else
>  	KMALLOC_RECLAIM,
> +#endif
>  #ifdef CONFIG_ZONE_DMA
>  	KMALLOC_DMA,
> +#endif
> +#ifdef CONFIG_MEMCG_KMEM
> +	KMALLOC_CGROUP,
>  #endif
>  	NR_KMALLOC_TYPES
>  };
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index a8cb5de255fc..907d52963806 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -770,10 +770,16 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
>  #define KMALLOC_CGROUP_NAME(sz)
>  #endif
>  
> +#ifndef CONFIG_SLUB_TINY
> +#define KMALLOC_RCL_NAME(sz)	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #sz,
> +#else
> +#define KMALLOC_RCL_NAME(sz)
> +#endif
> +
>  #define INIT_KMALLOC_INFO(__size, __short_size)			\
>  {								\
>  	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
> -	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #__short_size,	\
> +	KMALLOC_RCL_NAME(__short_size)				\
>  	KMALLOC_CGROUP_NAME(__short_size)			\
>  	KMALLOC_DMA_NAME(__short_size)				\
>  	.size = __size,						\
> @@ -859,7 +865,7 @@ void __init setup_kmalloc_cache_index_table(void)
>  static void __init
>  new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
>  {
> -	if (type == KMALLOC_RECLAIM) {
> +	if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {

for consistency this can be:
	if (IS_ENABLED(CONFIG_SLUB_TINY) && (type == KMALLOC_RECLAIM)) {

But yeah, it's not a big deal.

>  		flags |= SLAB_RECLAIM_ACCOUNT;
>  	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
>  		if (mem_cgroup_kmem_disabled()) {
> -- 
> 2.38.1
> 

For either case:

Looks good to me.
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

-- 
Thanks,
Hyeonggon
