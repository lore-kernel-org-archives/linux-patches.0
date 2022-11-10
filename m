Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D3E20FA
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:48:59 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id r18so1863388pgr.12
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 05:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LnFXtuVA4NYqbhGKoWGds6kgTIbomnPNzPXIEWeGMzA=;
        b=Rq4WavHCZSENVhdgHs1/rY+/SSxB00ToA/rMllcLsCMKD3jblV1wXVIrhk2ITsU070
         RtkJ73FaZqP4cCekNlMnzLDeEJMVpEcam5UTEI3l5piEzDvw15ZKf12sR6vlsuDgUld8
         j9mba8Gin1SdeeRXVQdlIiSh/iANUo6iRoIwFxEJPwZHTK5Lv3pAutoSLLtlZJWub0NF
         yNTUKp8MsqJvWQlAOwe+l8fZJBCk4LI98t2tE4Bm+iR+0md8yQRSHkYHRWvB+GI18oZD
         nxz8njas6j+F7P959vRjlc77ladwwhBn+31PWTIA29/tuehfh5sFRLCVaz7FGP2khHbB
         kwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LnFXtuVA4NYqbhGKoWGds6kgTIbomnPNzPXIEWeGMzA=;
        b=FHZLcXNmK5wa2yhwMVwZcGTOQIEnL2tDs9t6k9ma7vXNperjAy1oaxBalm04JHXBeK
         pgR7YB8m6AqFNmUHQycwa1OjxbXXU9gEs4Yw0fHDbWGpQeTzu6g4HywwjPB0Vkf7Lce8
         4N7n6i2j/BVfsqxz/YY5lcw9VrC+Hi2w6rohAEjDEnPChd73J4SoMw67k1YbsY0+241c
         WFQ9Wuu7JTIT2UKIfK9FRqWJd9mmzxs4tnoV4unpHBTGL8jRvGSVGEh98af7DdHdQTXm
         dV3pko4nrwJAMbaiWnS4ExG9qGW42GrkaGuYV3J3qy5mCqCvZFxXjDmn9xtNKcOwpQuD
         5IXA==
X-Gm-Message-State: ACrzQf24NPEkbyUBcWU5inWvxBzqghFKfccbTalVZXK9VBRILWaGj6Km
	pMeWVZu1C28YIxaQ7nJcBcw=
X-Google-Smtp-Source: AMsMyM43/BE/K1xNrCRl0YtgPZEMGAS9AkDZFR+/Yilr+I8eGgX+HEWjonQeoiWTN1IlbV/xdOlmkw==
X-Received: by 2002:a05:6a00:3497:b0:56b:6936:ddfb with SMTP id cp23-20020a056a00349700b0056b6936ddfbmr2688071pfb.15.1668088138958;
        Thu, 10 Nov 2022 05:48:58 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id j9-20020a170902690900b0017a018221e2sm11236297plk.70.2022.11.10.05.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 05:48:58 -0800 (PST)
Date: Thu, 10 Nov 2022 22:48:52 +0900
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Matthew Wilcox <willy@infradead.org>, paulmck@kernel.org,
	rcu@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	kernel test robot <yujie.liu@intel.com>
Subject: Re: [PATCH v2 2/3] mm/migrate: make isolate_movable_page() skip slab
 pages
Message-ID: <Y20BRJmRzRVMzoJw@hyeyoo>
References: <20221107170554.7869-1-vbabka@suse.cz>
 <20221107170554.7869-3-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107170554.7869-3-vbabka@suse.cz>

On Mon, Nov 07, 2022 at 06:05:53PM +0100, Vlastimil Babka wrote:
> In the next commit we want to rearrange struct slab fields to allow a larger
> rcu_head. Afterwards, the page->mapping field will overlap with SLUB's "struct
> list_head slab_list", where the value of prev pointer can become LIST_POISON2,
> which is 0x122 + POISON_POINTER_DELTA.  Unfortunately the bit 1 being set can
> confuse PageMovable() to be a false positive and cause a GPF as reported by lkp
> [1].
> 
> To fix this, make isolate_movable_page() skip pages with the PageSlab flag set.
> This is a bit tricky as we need to add memory barriers to SLAB and SLUB's page
> allocation and freeing, and their counterparts to isolate_movable_page().
> 
> Based on my RFC from [2]. Added a comment update from Matthew's variant in [3]
> and, as done there, moved the PageSlab checks to happen before trying to take
> the page lock.
> 
> [1] https://lore.kernel.org/all/208c1757-5edd-fd42-67d4-1940cc43b50f@intel.com/
> [2] https://lore.kernel.org/all/aec59f53-0e53-1736-5932-25407125d4d4@suse.cz/
> [3] https://lore.kernel.org/all/YzsVM8eToHUeTP75@casper.infradead.org/
> 
> Reported-by: kernel test robot <yujie.liu@intel.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/migrate.c | 15 ++++++++++++---
>  mm/slab.c    |  6 +++++-
>  mm/slub.c    |  6 +++++-
>  3 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 1379e1912772..959c99cff814 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -74,13 +74,22 @@ int isolate_movable_page(struct page *page, isolate_mode_t mode)
>  	if (unlikely(!get_page_unless_zero(page)))
>  		goto out;
>  
> +	if (unlikely(PageSlab(page)))
> +		goto out_putpage;
> +	/* Pairs with smp_wmb() in slab freeing, e.g. SLUB's __free_slab() */
> +	smp_rmb();
>  	/*
> -	 * Check PageMovable before holding a PG_lock because page's owner
> -	 * assumes anybody doesn't touch PG_lock of newly allocated page
> -	 * so unconditionally grabbing the lock ruins page's owner side.
> +	 * Check movable flag before taking the page lock because
> +	 * we use non-atomic bitops on newly allocated page flags so
> +	 * unconditionally grabbing the lock ruins page's owner side.
>  	 */
>  	if (unlikely(!__PageMovable(page)))
>  		goto out_putpage;
> +	/* Pairs with smp_wmb() in slab allocation, e.g. SLUB's alloc_slab_page() */
> +	smp_rmb();
> +	if (unlikely(PageSlab(page)))
> +		goto out_putpage;
> +
>  	/*
>  	 * As movable pages are not isolated from LRU lists, concurrent
>  	 * compaction threads can race against page migration functions
> diff --git a/mm/slab.c b/mm/slab.c
> index 59c8e28f7b6a..219beb48588e 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1370,6 +1370,8 @@ static struct slab *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
>  
>  	account_slab(slab, cachep->gfporder, cachep, flags);
>  	__folio_set_slab(folio);
> +	/* Make the flag visible before any changes to folio->mapping */
> +	smp_wmb();
>  	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
>  	if (sk_memalloc_socks() && page_is_pfmemalloc(folio_page(folio, 0)))
>  		slab_set_pfmemalloc(slab);
> @@ -1387,9 +1389,11 @@ static void kmem_freepages(struct kmem_cache *cachep, struct slab *slab)
>  
>  	BUG_ON(!folio_test_slab(folio));
>  	__slab_clear_pfmemalloc(slab);
> -	__folio_clear_slab(folio);
>  	page_mapcount_reset(folio_page(folio, 0));
>  	folio->mapping = NULL;
> +	/* Make the mapping reset visible before clearing the flag */
> +	smp_wmb();
> +	__folio_clear_slab(folio);
>  
>  	if (current->reclaim_state)
>  		current->reclaim_state->reclaimed_slab += 1 << order;
> diff --git a/mm/slub.c b/mm/slub.c
> index 99ba865afc4a..5e6519d5169c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1800,6 +1800,8 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
>  
>  	slab = folio_slab(folio);
>  	__folio_set_slab(folio);
> +	/* Make the flag visible before any changes to folio->mapping */
> +	smp_wmb();
>  	if (page_is_pfmemalloc(folio_page(folio, 0)))
>  		slab_set_pfmemalloc(slab);
>  
> @@ -2000,8 +2002,10 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
>  	int pages = 1 << order;
>  
>  	__slab_clear_pfmemalloc(slab);
> -	__folio_clear_slab(folio);
>  	folio->mapping = NULL;
> +	/* Make the mapping reset visible before clearing the flag */
> +	smp_wmb();
> +	__folio_clear_slab(folio);
>  	if (current->reclaim_state)
>  		current->reclaim_state->reclaimed_slab += pages;
>  	unaccount_slab(slab, order, s);
> -- 
> 2.38.0

This looks correct to me.

Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Just noting to myself to avoid confusion in the future:

- When one sees PageSlab() == false, __PageMovable() == true should not be false positive
  from slab page because resetting ->mapping is visible first and then it clears PG_slab.

- When one sees __PageMoveable() == true for slab page, PageSlab() must be true because
  setting PG_slab in slab allocation is visible first and then it writes to ->mapping field.

I hope it's nicely reshaped after Matthew's frozen refcount series.

-- 
Thanks,
Hyeonggon
