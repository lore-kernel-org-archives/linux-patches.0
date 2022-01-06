Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FDD168
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 11:54:16 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so8211885pjd.1
        for <patches@lists.linux.dev>; Thu, 06 Jan 2022 03:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mdI3MyvYt8ICTn9SgICBNbhMHeF2Ow0PNUrwmjCmoHQ=;
        b=WK5qga0o12mnYqdf78vaXfxv695wF52OVcg9rbYEot9BXtDrxUprxLBBEYNkwVRbRn
         icWJ3majNlzDvglg4/9XBVFw3MxAnF1rSZdAv4eluZZ+BfF43jREFxWuCVQJRPeYIoY/
         lcLD7zQMD5JdhOiSAwf65cm7ddKlJrXObro+ewHeaDR1ZQMp4LhUh/SpJP5NVH/RHyEb
         tWicql1/buUTeB0hiihaRGySCuGrQ/PVU6bjCRvap4UgIiVcMskZo9s6iW1mdsdPkh8I
         VfuYBMrCHqgtWauBrBR8j7qqAwb9EICLmRrGeWVlaX6ykFSTooZt0f/CfmYEOR6elBYW
         CnxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mdI3MyvYt8ICTn9SgICBNbhMHeF2Ow0PNUrwmjCmoHQ=;
        b=lzs+X5nQg5OIJAMe3iYDAgUsnKRQnB7lODZrcGxd81y/Kip6wOGY7gsVILA8PcWsaq
         YinX5CIhF1eUchpM3pGAcVTB9+Dl7enAwk9FMQTscDZs0xJ4qECoVKtgrevr0Ea9HeoM
         ZjH/RSHPOcQ92LcwR48J6UZEuEMhlJS2NfwELlYLnQnkpf4oTxx6Jn/yQwKbYVLZ0xA/
         sj0MIrJvTVfnv1xpYk/VHJPSaILQba7d0wagC6252lvJ2V49kaF5uJRoGosAuBkql2lH
         ECxUL8nJIbxTlF2G6B0NFj6S4YHgV2G8eFSlTjcYsNIUpWbn+R4MlekSSW74wEWdY5hy
         MMog==
X-Gm-Message-State: AOAM532nP5WBbs2TcMwGOMsHQw/VcMXdkhLZunLSgtlNGGC76PNbYyXW
	TN8UlLT5JTEucSfGXmyv7YA=
X-Google-Smtp-Source: ABdhPJzNIrcQQRlKN00PAZiLbAsYvZrsoeOD5xJMd6fybc1w2QWNBKssNEG50hQn8BWOxJRI2o4scw==
X-Received: by 2002:a17:902:8f91:b0:149:87ff:ac85 with SMTP id z17-20020a1709028f9100b0014987ffac85mr41005894plo.162.1641470056221;
        Thu, 06 Jan 2022 03:54:16 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id v8sm2695512pfu.68.2022.01.06.03.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 03:54:15 -0800 (PST)
Date: Thu, 6 Jan 2022 11:54:11 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 04/32] mm: Split slab into its own type
Message-ID: <YdbYY4nNr7rMfazU@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-5-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-5-vbabka@suse.cz>

On Tue, Jan 04, 2022 at 01:10:18AM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Make struct slab independent of struct page. It still uses the
> underlying memory in struct page for storing slab-specific data, but
> slab and slub can now be weaned off using struct page directly.  Some of
> the wrapper functions (slab_address() and slab_order()) still need to
> cast to struct folio, but this is a significant disentanglement.
> 
> [ vbabka@suse.cz: Rebase on folios, use folio instead of page where
>   possible.
> 
>   Do not duplicate flags field in struct slab, instead make the related
>   accessors go through slab_folio(). For testing pfmemalloc use the
>   folio_*_active flag accessors directly so the PageSlabPfmemalloc
>   wrappers can be removed later.
> 
>   Make folio_slab() expect only folio_test_slab() == true folios and
>   virt_to_slab() return NULL when folio_test_slab() == false.
> 
>   Move struct slab to mm/slab.h.
> 
>   Don't represent with struct slab pages that are not true slab pages,
>   but just a compound page obtained directly rom page allocator (with

a typo here: (f)rom

>   large kmalloc() for SLUB and SLOB). ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Roman Gushchin <guro@fb.com>
> ---
>  include/linux/mm_types.h |  10 +--
>  mm/slab.h                | 167 +++++++++++++++++++++++++++++++++++++++
>  mm/slub.c                |   8 +-
>  3 files changed, 176 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index c3a6e6209600..1ae3537c7920 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -56,11 +56,11 @@ struct mem_cgroup;
>   * in each subpage, but you may need to restore some of their values
>   * afterwards.
>   *
> - * SLUB uses cmpxchg_double() to atomically update its freelist and
> - * counters.  That requires that freelist & counters be adjacent and
> - * double-word aligned.  We align all struct pages to double-word
> - * boundaries, and ensure that 'freelist' is aligned within the
> - * struct.
> + * SLUB uses cmpxchg_double() to atomically update its freelist and counters.
> + * That requires that freelist & counters in struct slab be adjacent and
> + * double-word aligned. Because struct slab currently just reinterprets the
> + * bits of struct page, we align all struct pages to double-word boundaries,
> + * and ensure that 'freelist' is aligned within struct slab.
>   */
>  #ifdef CONFIG_HAVE_ALIGNED_STRUCT_PAGE
>  #define _struct_page_alignment	__aligned(2 * sizeof(unsigned long))
> diff --git a/mm/slab.h b/mm/slab.h
> index 56ad7eea3ddf..0e67a8cb7f80 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -5,6 +5,173 @@
>   * Internal slab definitions
>   */
>  
> +/* Reuses the bits in struct page */
> +struct slab {
> +	unsigned long __page_flags;
> +	union {
> +		struct list_head slab_list;
> +		struct {	/* Partial pages */
> +			struct slab *next;
> +#ifdef CONFIG_64BIT
> +			int slabs;	/* Nr of slabs left */
> +#else
> +			short int slabs;
> +#endif
> +		};
> +		struct rcu_head rcu_head;
> +	};
> +	struct kmem_cache *slab_cache; /* not slob */
> +	/* Double-word boundary */
> +	void *freelist;		/* first free object */
> +	union {
> +		void *s_mem;	/* slab: first object */
> +		unsigned long counters;		/* SLUB */
> +		struct {			/* SLUB */
> +			unsigned inuse:16;
> +			unsigned objects:15;
> +			unsigned frozen:1;
> +		};
> +	};
> +
> +	union {
> +		unsigned int active;		/* SLAB */
> +		int units;			/* SLOB */
> +	};
> +	atomic_t __page_refcount;
> +#ifdef CONFIG_MEMCG
> +	unsigned long memcg_data;
> +#endif
> +};
> +
> +#define SLAB_MATCH(pg, sl)						\
> +	static_assert(offsetof(struct page, pg) == offsetof(struct slab, sl))
> +SLAB_MATCH(flags, __page_flags);
> +SLAB_MATCH(compound_head, slab_list);	/* Ensure bit 0 is clear */
> +SLAB_MATCH(slab_list, slab_list);
> +SLAB_MATCH(rcu_head, rcu_head);
> +SLAB_MATCH(slab_cache, slab_cache);
> +SLAB_MATCH(s_mem, s_mem);
> +SLAB_MATCH(active, active);
> +SLAB_MATCH(_refcount, __page_refcount);
> +#ifdef CONFIG_MEMCG
> +SLAB_MATCH(memcg_data, memcg_data);
> +#endif
> +#undef SLAB_MATCH
> +static_assert(sizeof(struct slab) <= sizeof(struct page));
> +
> +/**
> + * folio_slab - Converts from folio to slab.
> + * @folio: The folio.
> + *
> + * Currently struct slab is a different representation of a folio where
> + * folio_test_slab() is true.
> + *
> + * Return: The slab which contains this folio.
> + */
> +#define folio_slab(folio)	(_Generic((folio),			\
> +	const struct folio *:	(const struct slab *)(folio),		\
> +	struct folio *:		(struct slab *)(folio)))
> +
> +/**
> + * slab_folio - The folio allocated for a slab
> + * @slab: The slab.
> + *
> + * Slabs are allocated as folios that contain the individual objects and are
> + * using some fields in the first struct page of the folio - those fields are
> + * now accessed by struct slab. It is occasionally necessary to convert back to
> + * a folio in order to communicate with the rest of the mm.  Please use this
> + * helper function instead of casting yourself, as the implementation may change
> + * in the future.
> + */
> +#define slab_folio(s)		(_Generic((s),				\
> +	const struct slab *:	(const struct folio *)s,		\
> +	struct slab *:		(struct folio *)s))
> +
> +/**
> + * page_slab - Converts from first struct page to slab.
> + * @p: The first (either head of compound or single) page of slab.
> + *
> + * A temporary wrapper to convert struct page to struct slab in situations where
> + * we know the page is the compound head, or single order-0 page.
> + *
> + * Long-term ideally everything would work with struct slab directly or go
> + * through folio to struct slab.
> + *
> + * Return: The slab which contains this page
> + */
> +#define page_slab(p)		(_Generic((p),				\
> +	const struct page *:	(const struct slab *)(p),		\
> +	struct page *:		(struct slab *)(p)))
> +
> +/**
> + * slab_page - The first struct page allocated for a slab
> + * @slab: The slab.
> + *
> + * A convenience wrapper for converting slab to the first struct page of the
> + * underlying folio, to communicate with code not yet converted to folio or
> + * struct slab.
> + */
> +#define slab_page(s) folio_page(slab_folio(s), 0)
> +
> +/*
> + * If network-based swap is enabled, sl*b must keep track of whether pages
> + * were allocated from pfmemalloc reserves.
> + */
> +static inline bool slab_test_pfmemalloc(const struct slab *slab)
> +{
> +	return folio_test_active((struct folio *)slab_folio(slab));
> +}
> +
> +static inline void slab_set_pfmemalloc(struct slab *slab)
> +{
> +	folio_set_active(slab_folio(slab));
> +}
> +
> +static inline void slab_clear_pfmemalloc(struct slab *slab)
> +{
> +	folio_clear_active(slab_folio(slab));
> +}
> +
> +static inline void __slab_clear_pfmemalloc(struct slab *slab)
> +{
> +	__folio_clear_active(slab_folio(slab));
> +}
> +
> +static inline void *slab_address(const struct slab *slab)
> +{
> +	return folio_address(slab_folio(slab));
> +}
> +
> +static inline int slab_nid(const struct slab *slab)
> +{
> +	return folio_nid(slab_folio(slab));
> +}
> +
> +static inline pg_data_t *slab_pgdat(const struct slab *slab)
> +{
> +	return folio_pgdat(slab_folio(slab));
> +}
> +
> +static inline struct slab *virt_to_slab(const void *addr)
> +{
> +	struct folio *folio = virt_to_folio(addr);
> +
> +	if (!folio_test_slab(folio))
> +		return NULL;
> +
> +	return folio_slab(folio);
> +}
> +
> +static inline int slab_order(const struct slab *slab)
> +{
> +	return folio_order((struct folio *)slab_folio(slab));
> +}
> +
> +static inline size_t slab_size(const struct slab *slab)
> +{
> +	return PAGE_SIZE << slab_order(slab);
> +}
> +
>  #ifdef CONFIG_SLOB
>  /*
>   * Common fields provided in kmem_cache by all slab allocators
> diff --git a/mm/slub.c b/mm/slub.c
> index 2ccb1c71fc36..a211d96011ba 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3787,7 +3787,7 @@ static unsigned int slub_min_objects;
>   * requested a higher minimum order then we start with that one instead of
>   * the smallest order which will fit the object.
>   */
> -static inline unsigned int slab_order(unsigned int size,
> +static inline unsigned int calc_slab_order(unsigned int size,
>  		unsigned int min_objects, unsigned int max_order,
>  		unsigned int fract_leftover)
>  {
> @@ -3851,7 +3851,7 @@ static inline int calculate_order(unsigned int size)
>  
>  		fraction = 16;
>  		while (fraction >= 4) {
> -			order = slab_order(size, min_objects,
> +			order = calc_slab_order(size, min_objects,
>  					slub_max_order, fraction);
>  			if (order <= slub_max_order)
>  				return order;
> @@ -3864,14 +3864,14 @@ static inline int calculate_order(unsigned int size)
>  	 * We were unable to place multiple objects in a slab. Now
>  	 * lets see if we can place a single object there.
>  	 */
> -	order = slab_order(size, 1, slub_max_order, 1);
> +	order = calc_slab_order(size, 1, slub_max_order, 1);
>  	if (order <= slub_max_order)
>  		return order;
>  
>  	/*
>  	 * Doh this slab cannot be placed using slub_max_order.
>  	 */
> -	order = slab_order(size, 1, MAX_ORDER, 1);
> +	order = calc_slab_order(size, 1, MAX_ORDER, 1);
>  	if (order < MAX_ORDER)
>  		return order;
>  	return -ENOSYS;

This patch looks good.
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

SL[AUO]B works fine on the top of this patch.
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

> -- 
> 2.34.1
> 
