Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C311173
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 13:56:08 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id w7so2510052plp.13
        for <patches@lists.linux.dev>; Thu, 06 Jan 2022 05:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bi6KFP+/FYUtYYBBRHlusA6drg1CDNMrGuzdL/jqs9A=;
        b=I7eAiClvH/N8FY958BbxAJZW0K1qGaeSImAIbhYzQxU82RDBGODVaORwtRBa5ZMQ7w
         4Zo+a9g9LtaB+O8dJEMkclkQbR3V0Vr0Wemf8nmQrOHCqam/52TXUJskmuFNPbWFMDKL
         i00M1ggROXQCLmPEPeJGEDykz+vVB/5h14LdrvTz2sTQe7DBJyvERgR7m/3pnbiQOOY8
         DtY4dJSuakkiRR7Yz/OaHa1WpBInKvv/zuIJJisI8lYm+gq/JIxKKyV/l5XSXjqQh5cB
         1IdHKqVqPagBneC4TIJl3Bmn3+XA9w6yZyFnuwqfKlSwKLgKOjs5VmCEGKB9MaAmijx0
         0Ngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bi6KFP+/FYUtYYBBRHlusA6drg1CDNMrGuzdL/jqs9A=;
        b=RGZYbHdBgiNgnda+nCAAVDfuWfwusZwNG+WrzAzWM/MpbU/i6IixiOJcwmeImImhC2
         iNiJJMW9FiBk0GJtDQOOlk8rI2nJr8bdGwD92/HpM0HqWgAVI8YQahEtfG2+LuV7+E9v
         tRJwnnbAQ272pz2mZV1oiJCHGM8Eg/6o84Q87iHB6phgaFOOM8nZnUXJ8CKCXA/sYTVA
         ddzONvVn7DUYxeUku8UnangGhC5yDjxDtEXO0E4Axtj/qyWXfdDyTrGqOdrY40bHaX4s
         ymrT26hNsGLCJHhDORcLYDjkxOQAbIHr2BWmMYeARFcyHm2JXb9qXa55zSkcN0kB6h3P
         geOw==
X-Gm-Message-State: AOAM531TVZVOI9g41zME/66i5oJhlPLNE+hhOqRCkOZkpVBoCJPJ0OiW
	oxk3TMTpueGle4F2N3JDbcY=
X-Google-Smtp-Source: ABdhPJyjqsf7vgdNE6BzdJ+2Dd1DxX5Yo2FMZypz02zImltU60/DFDlqL2o5BF1GvhU/snNsqRFMTw==
X-Received: by 2002:a17:903:300b:b0:149:f48b:e8b8 with SMTP id o11-20020a170903300b00b00149f48be8b8mr2245245pla.108.1641477367937;
        Thu, 06 Jan 2022 05:56:07 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id d13sm2887698pfj.135.2022.01.06.05.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:56:07 -0800 (PST)
Date: Thu, 6 Jan 2022 13:56:02 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 09/32] mm: Convert check_heap_object() to use struct
 slab
Message-ID: <Ydb08tDjjrQObNPi@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-10-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-10-vbabka@suse.cz>

On Tue, Jan 04, 2022 at 01:10:23AM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Ensure that we're not seeing a tail page inside __check_heap_object() by
> converting to a slab instead of a page.  Take the opportunity to mark
> the slab as const since we're not modifying it.  Also move the
> declaration of __check_heap_object() to mm/slab.h so it's not available
> to the wider kernel.
> 
> [ vbabka@suse.cz: in check_heap_object() only convert to struct slab for
>   actual PageSlab pages; use folio as intermediate step instead of page ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Roman Gushchin <guro@fb.com>
> ---
>  include/linux/slab.h |  8 --------
>  mm/slab.c            | 14 +++++++-------
>  mm/slab.h            | 11 +++++++++++
>  mm/slub.c            | 10 +++++-----
>  mm/usercopy.c        | 13 +++++++------
>  5 files changed, 30 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 181045148b06..367366f1d1ff 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -189,14 +189,6 @@ bool kmem_valid_obj(void *object);
>  void kmem_dump_obj(void *object);
>  #endif
>  
> -#ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
> -void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
> -			bool to_user);
> -#else
> -static inline void __check_heap_object(const void *ptr, unsigned long n,
> -				       struct page *page, bool to_user) { }
> -#endif
> -
>  /*
>   * Some archs want to perform DMA into kmalloc caches and need a guaranteed
>   * alignment larger than the alignment of a 64-bit integer.
> diff --git a/mm/slab.c b/mm/slab.c
> index 44bc1fcd1393..38fcd3f496df 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -372,8 +372,8 @@ static void **dbg_userword(struct kmem_cache *cachep, void *objp)
>  static int slab_max_order = SLAB_MAX_ORDER_LO;
>  static bool slab_max_order_set __initdata;
>  
> -static inline void *index_to_obj(struct kmem_cache *cache, struct page *page,
> -				 unsigned int idx)
> +static inline void *index_to_obj(struct kmem_cache *cache,
> +				 const struct page *page, unsigned int idx)
>  {
>  	return page->s_mem + cache->size * idx;
>  }
> @@ -4166,8 +4166,8 @@ ssize_t slabinfo_write(struct file *file, const char __user *buffer,
>   * Returns NULL if check passes, otherwise const char * to name of cache
>   * to indicate an error.
>   */
> -void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
> -			 bool to_user)
> +void __check_heap_object(const void *ptr, unsigned long n,
> +			 const struct slab *slab, bool to_user)
>  {
>  	struct kmem_cache *cachep;
>  	unsigned int objnr;
> @@ -4176,15 +4176,15 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
>  	ptr = kasan_reset_tag(ptr);
>  
>  	/* Find and validate object. */
> -	cachep = page->slab_cache;
> -	objnr = obj_to_index(cachep, page, (void *)ptr);
> +	cachep = slab->slab_cache;
> +	objnr = obj_to_index(cachep, slab_page(slab), (void *)ptr);
>  	BUG_ON(objnr >= cachep->num);
>  
>  	/* Find offset within object. */
>  	if (is_kfence_address(ptr))
>  		offset = ptr - kfence_object_start(ptr);
>  	else
> -		offset = ptr - index_to_obj(cachep, page, objnr) - obj_offset(cachep);
> +		offset = ptr - index_to_obj(cachep, slab_page(slab), objnr) - obj_offset(cachep);
>  
>  	/* Allow address range falling entirely within usercopy region. */
>  	if (offset >= cachep->useroffset &&
> diff --git a/mm/slab.h b/mm/slab.h
> index 9ae9f6c3d1cb..039babfde2fe 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -812,4 +812,15 @@ struct kmem_obj_info {
>  void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
>  #endif
>  
> +#ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
> +void __check_heap_object(const void *ptr, unsigned long n,
> +			 const struct slab *slab, bool to_user);
> +#else
> +static inline
> +void __check_heap_object(const void *ptr, unsigned long n,
> +			 const struct slab *slab, bool to_user)
> +{
> +}
> +#endif
> +
>  #endif /* MM_SLAB_H */
> diff --git a/mm/slub.c b/mm/slub.c
> index 8e9667815f81..8b82188849ae 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4485,8 +4485,8 @@ EXPORT_SYMBOL(__kmalloc_node);
>   * Returns NULL if check passes, otherwise const char * to name of cache
>   * to indicate an error.
>   */
> -void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
> -			 bool to_user)
> +void __check_heap_object(const void *ptr, unsigned long n,
> +			 const struct slab *slab, bool to_user)
>  {
>  	struct kmem_cache *s;
>  	unsigned int offset;
> @@ -4495,10 +4495,10 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
>  	ptr = kasan_reset_tag(ptr);
>  
>  	/* Find object and usable object size. */
> -	s = page->slab_cache;
> +	s = slab->slab_cache;
>  
>  	/* Reject impossible pointers. */
> -	if (ptr < page_address(page))
> +	if (ptr < slab_address(slab))
>  		usercopy_abort("SLUB object not in SLUB page?!", NULL,
>  			       to_user, 0, n);
>  
> @@ -4506,7 +4506,7 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
>  	if (is_kfence)
>  		offset = ptr - kfence_object_start(ptr);
>  	else
> -		offset = (ptr - page_address(page)) % s->size;
> +		offset = (ptr - slab_address(slab)) % s->size;
>  
>  	/* Adjust for redzone and reject if within the redzone. */
>  	if (!is_kfence && kmem_cache_debug_flags(s, SLAB_RED_ZONE)) {
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index b3de3c4eefba..d0d268135d96 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -20,6 +20,7 @@
>  #include <linux/atomic.h>
>  #include <linux/jump_label.h>
>  #include <asm/sections.h>
> +#include "slab.h"
>  
>  /*
>   * Checks if a given pointer and length is contained by the current
> @@ -223,7 +224,7 @@ static inline void check_page_span(const void *ptr, unsigned long n,
>  static inline void check_heap_object(const void *ptr, unsigned long n,
>  				     bool to_user)
>  {
> -	struct page *page;
> +	struct folio *folio;
>  
>  	if (!virt_addr_valid(ptr))
>  		return;
> @@ -231,16 +232,16 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  	/*
>  	 * When CONFIG_HIGHMEM=y, kmap_to_page() will give either the
>  	 * highmem page or fallback to virt_to_page(). The following
> -	 * is effectively a highmem-aware virt_to_head_page().
> +	 * is effectively a highmem-aware virt_to_slab().
>  	 */
> -	page = compound_head(kmap_to_page((void *)ptr));
> +	folio = page_folio(kmap_to_page((void *)ptr));
>  
> -	if (PageSlab(page)) {
> +	if (folio_test_slab(folio)) {
>  		/* Check slab allocator for flags and size. */
> -		__check_heap_object(ptr, n, page, to_user);
> +		__check_heap_object(ptr, n, folio_slab(folio), to_user);
>  	} else {
>  		/* Verify object does not incorrectly span multiple pages. */
> -		check_page_span(ptr, n, page, to_user);
> +		check_page_span(ptr, n, folio_page(folio, 0), to_user);
>  	}
>  }
>

Looks good,
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Thanks!
> -- 
> 2.34.1
> 
