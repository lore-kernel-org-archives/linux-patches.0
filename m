Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB7F2569
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 12:06:13 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so302073pjo.3
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 04:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IAX5cjv3FV+pwILnpnHsO44lgFo9KZIJeSsheZZLVIg=;
        b=hvY1uDyL0ey9sUdH1VlAPTnxAQ6Z4wMH2cJPwB39IuOLSrbbwT6J/MPAr422yfgWLc
         5WGaaaTTywlbrL3NoU1/EHsbe9MiwUOq2TpFeUEOQSN6X4ePtVOgRn294LHwnYb7ycL4
         NoCmjKIE+2tOJjJFVlEattu1U1hGXPJL/ffS1GurdZM0VamAPKr9iWm7xyDk+vnh8JwP
         Uh86JffdWQSnDgAmeRDZ09uwsBEXgvcIFmqj+UvRb8SohnfsfpUTybWWgoLD0vcVLLHG
         Cu9aX1FLr0ptzWJLb3D212Mt5U+dTjKS3mucKL3wZALgrFmBOqqORl+JPrLHOX1MwMW8
         O8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAX5cjv3FV+pwILnpnHsO44lgFo9KZIJeSsheZZLVIg=;
        b=BjgGxbmdeTj/gFtmuKAUjGnIsnsUdYXHnp/z4DeSbdL0nBcmXb9s00jjcr+Op6yIpI
         nhJ0EjnGyyH37MHGR0FCP6JpdwxTG/rfCZkE1zx8OBQNCJgM61xUMSqtDkvSR7Kxn0ro
         yA9o0+st6pQY4P9stWU0oXw762/Mp1TwHhhGih2ezY82onJMbHI7x35AoPKNhRLHvp30
         9OLby2At3zpdARVxiR3NzNf9t6X+57SkDMBkwxf1wREmXkM0J/Yuj2c9IES7zd+sRMkl
         LDxYo8nVf+I9JZT+HVTmLJLvI8tktzeca4wJGeQXvvPyRpjKCkSEVY347ub19Gxs9Qyy
         bHMg==
X-Gm-Message-State: ANoB5plERZVXzRDYFdKwcBNfoXDO2CwzTSA5Jbe0kwNizYrp76X2MK9Y
	b75b9PkaCoUdJ9sjstrA3J4=
X-Google-Smtp-Source: AA0mqf5pZO7aBuavuyzfuW0tbHgET6lLrCyFD/qydLNuN75Z1M9V0V9SMX2yq7hOSsMDdB81BXMWVg==
X-Received: by 2002:a17:90b:2d8b:b0:202:f88d:587 with SMTP id sj11-20020a17090b2d8b00b00202f88d0587mr36177116pjb.232.1669291572617;
        Thu, 24 Nov 2022 04:06:12 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id s1-20020a625e01000000b0056cea9530b6sm1028976pfb.202.2022.11.24.04.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 04:06:11 -0800 (PST)
Date: Thu, 24 Nov 2022 21:06:05 +0900
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
Message-ID: <Y39eLaW0mDNrHI6i@hyeyoo>
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

Can you please elaborate what the lkp report was about
and how you fixed it? I'm not getting what the problem of previous
version is.

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
>  		flags |= SLAB_RECLAIM_ACCOUNT;
>  	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
>  		if (mem_cgroup_kmem_disabled()) {
> -- 
> 2.38.1
>

Otherwise looks fine to me.

-- 
Thanks,
Hyeonggon
