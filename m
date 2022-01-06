Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FC5173
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 13:04:19 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso1103697pjo.5
        for <patches@lists.linux.dev>; Thu, 06 Jan 2022 05:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sVQSzR4SW/MjdTNCbawWQclxIiDCCDlvlCWcNdSiJlo=;
        b=aYFntmZpi/1A7f2zgSveTw5J092LCtkg9gYHatO+kGp7546I2L7x4Pv1dRevww05x6
         hN+Y85JxvzIJ+ORMzTfviGdCez0+vhmR+2Wx2BlG98ggGLqsL9XshsJOVdbh5ry35yJ0
         K0yn/HfW7PgUUqRdmGOPzvSHCn7dxQOvDtuv2jkQ1JSw+IDoaTOVMkM2kCyFBiAlaF1M
         AjB2jiEFefKnNgfZWSJto2ov+Z7kOcVhFqnDVER17uvCwaOK8vTlz8+0HBkhOaomhaMG
         LByVic1VvangfCwFvZiefoirQAPZPITv/VnO9aLYoSsitX6HAe91Lt9sj8gMsLM75RtL
         MP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sVQSzR4SW/MjdTNCbawWQclxIiDCCDlvlCWcNdSiJlo=;
        b=qDtQX1FHqEJahhIZ3VFaNL8pKoKqvpd03bhgBb2A7xgvxAucdfnUnwebHei+eljtzS
         ludptBnW8s+OsRxpsuamYO0pxJyQU5CcclMIMq+rzSSTTYfFvE5/0FDfJ6SWWzmQn7z7
         wTsVK3wpPJ8Gymc3tr1+34UUk/LU6bMkbUuizGk39RatoMCZk7O873xEKiBgZT92I1KU
         9SGKAzC8R1A27PXKyMyy2mgzswx4TsxaKpPk1yu+5llOIdcWVms3vCvhlTUprdqvToQ3
         E15H5MAvzanbiY9UiiXL+2gsucqObAWmvwWLMeFcqVTHm68agIBpQ3tsYUYK/u9gpq+g
         rbzw==
X-Gm-Message-State: AOAM531ZOThaaIFMjMKqJzR5Be37jfZAnPc85qTBdGnmD8vxyoyR9Zuf
	vzmqqU7Vls2fDPKHj5/J3Is=
X-Google-Smtp-Source: ABdhPJzs6KJtOLErUNPsy9jMGZoT4Alg/c40yXtpJ71bVQRyjPDC+8PJrxe5w8HjysU6EmFuAj84Yg==
X-Received: by 2002:a17:902:c784:b0:148:ef6f:fc4a with SMTP id w4-20020a170902c78400b00148ef6ffc4amr59164268pla.165.1641474259010;
        Thu, 06 Jan 2022 05:04:19 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id u5sm2649842pfk.67.2022.01.06.05.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:04:18 -0800 (PST)
Date: Thu, 6 Jan 2022 13:04:14 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 05/32] mm: Convert [un]account_slab_page() to struct
 slab
Message-ID: <Ydbozv2Zu7u6VDZs@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-6-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-6-vbabka@suse.cz>

On Tue, Jan 04, 2022 at 01:10:19AM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Convert the parameter of these functions to struct slab instead of
> struct page and drop _page from the names. For now their callers just
> convert page to slab.
> 
> [ vbabka@suse.cz: replace existing functions instead of calling them ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Roman Gushchin <guro@fb.com>
> ---
>  mm/slab.c |  4 ++--
>  mm/slab.h | 17 ++++++++---------
>  mm/slub.c |  4 ++--
>  3 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 381875e23277..7f147805d0ab 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1380,7 +1380,7 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
>  		return NULL;
>  	}
>  
> -	account_slab_page(page, cachep->gfporder, cachep, flags);
> +	account_slab(page_slab(page), cachep->gfporder, cachep, flags);
>  	__SetPageSlab(page);
>  	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
>  	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
> @@ -1405,7 +1405,7 @@ static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
>  
>  	if (current->reclaim_state)
>  		current->reclaim_state->reclaimed_slab += 1 << order;
> -	unaccount_slab_page(page, order, cachep);
> +	unaccount_slab(page_slab(page), order, cachep);
>  	__free_pages(page, order);
>  }
>  
> diff --git a/mm/slab.h b/mm/slab.h
> index 0e67a8cb7f80..dd3f72fddff6 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -583,24 +583,23 @@ static inline struct kmem_cache *virt_to_cache(const void *obj)
>  	return page->slab_cache;
>  }
>  
> -static __always_inline void account_slab_page(struct page *page, int order,
> -					      struct kmem_cache *s,
> -					      gfp_t gfp)
> +static __always_inline void account_slab(struct slab *slab, int order,
> +					 struct kmem_cache *s, gfp_t gfp)
>  {
>  	if (memcg_kmem_enabled() && (s->flags & SLAB_ACCOUNT))
> -		memcg_alloc_page_obj_cgroups(page, s, gfp, true);
> +		memcg_alloc_page_obj_cgroups(slab_page(slab), s, gfp, true);
>  
> -	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
> +	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
>  			    PAGE_SIZE << order);
>  }
>  
> -static __always_inline void unaccount_slab_page(struct page *page, int order,
> -						struct kmem_cache *s)
> +static __always_inline void unaccount_slab(struct slab *slab, int order,
> +					   struct kmem_cache *s)
>  {
>  	if (memcg_kmem_enabled())
> -		memcg_free_page_obj_cgroups(page);
> +		memcg_free_page_obj_cgroups(slab_page(slab));
>  
> -	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
> +	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
>  			    -(PAGE_SIZE << order));
>  }
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index a211d96011ba..c94fb4b4d655 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1943,7 +1943,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  
>  	page->objects = oo_objects(oo);
>  
> -	account_slab_page(page, oo_order(oo), s, flags);
> +	account_slab(page_slab(page), oo_order(oo), s, flags);
>  
>  	page->slab_cache = s;
>  	__SetPageSlab(page);
> @@ -2014,7 +2014,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
>  	page->slab_cache = NULL;
>  	if (current->reclaim_state)
>  		current->reclaim_state->reclaimed_slab += pages;
> -	unaccount_slab_page(page, order, s);
> +	unaccount_slab(page_slab(page), order, s);
>  	__free_pages(page, order);
>  }
>  

Looks good.
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

> -- 
> 2.34.1
> 
