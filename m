Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4BF2589
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 12:33:16 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id w129so1530940pfb.5
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 04:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Quv6TMBzkc3UUUbbJrq3QGuUoQYufo/Oq650F1/qMrI=;
        b=heDVlR5Dn1z5kZ8D5R39SrSt7bwu7FzD1Nv4YfOm5jCygUt+mdhkpngNMRc8GU/w3V
         SvIN7bu290HDyqOHUYQKIV0PGkOgHq7U3EqJHxtIOyQfet8RaX7Xl1kbE+fkYso0IQ2+
         vDVRW7iOeLAjysw2HMaRyvusNEunq9Z1Zj0y7YDE5YszOXR2opynwz3HB0XLX7pXHvc1
         rnJTusKztBIA3LLmZRVfb21mcekpaVEXAFpqHMNwEiw55snQBwkK9j/BuAl515bF33Qj
         Nn8fBbUDmmQZhWOrFaR2ricsjGdNTRujV0ZprCKy0AqQ20lCEFHA/yzOllpoLJ3SXbyl
         1AJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Quv6TMBzkc3UUUbbJrq3QGuUoQYufo/Oq650F1/qMrI=;
        b=j4W8WEL+wf+Ai9lL91AfsBp3nKFIs/qEkh1PWnFSomg2dJ945C1c8UtlGgn2oa7rFR
         DhSGzvmrBWjjj3dX4hMJmSIEXjSNHOSRJWbsKFYOTQbJMmh4I+9Bz5H2LYOuMMH3vSRz
         oaALpAqHWmCBEeVrP9liIRkSKXz+BqNB834eUbt1Faducmu7F3c6sc2mzG8TNwcnpIcn
         qTJd83i4+hCN9yNT8hyOSL11wZhfOOANc9/ECIjoHp8d+RnE41Ci70ZKd95qTN4oRiF9
         lWhMzKHe9u/rgiMhb/XTp+rtrQyui8HvNCuZhRuqcTlHWIxUiUL0l/TGyjnV2Edy/6pI
         Zsog==
X-Gm-Message-State: ANoB5ploTsEf/zdYEd0KH/Cdy2EhVe60JBtzqC9JMGefdrWUzArThZRB
	VpFIw6yz4LmKF6owLfZwp6A=
X-Google-Smtp-Source: AA0mqf7x6sFPa/ZpV9mrih0Y6ON5XSBgGE7tQPlyxowj7vdIVhiugqM1WzpDFvafwPdiwgdN45A7zg==
X-Received: by 2002:a63:d43:0:b0:477:cc1f:3f97 with SMTP id 3-20020a630d43000000b00477cc1f3f97mr3131562pgn.331.1669293196203;
        Thu, 24 Nov 2022 04:33:16 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id x80-20020a633153000000b004308422060csm967312pgx.69.2022.11.24.04.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 04:33:15 -0800 (PST)
Date: Thu, 24 Nov 2022 21:33:08 +0900
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 01/12] mm, slab: ignore hardened usercopy parameters when
 disabled
Message-ID: <Y39khFc7wKQ3qQLv@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-2-vbabka@suse.cz>
 <206E0154-63A6-45CF-8E19-BD01B35AEF0B@kernel.org>
 <0058169a-1659-7ab1-edff-de9ebadcf236@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0058169a-1659-7ab1-edff-de9ebadcf236@suse.cz>

On Wed, Nov 23, 2022 at 03:23:15PM +0100, Vlastimil Babka wrote:
> 
> On 11/21/22 22:35, Kees Cook wrote:
> > On November 21, 2022 9:11:51 AM PST, Vlastimil Babka <vbabka@suse.cz> wrote:
> >>With CONFIG_HARDENED_USERCOPY not enabled, there are no
> >>__check_heap_object() checks happening that would use the kmem_cache
> >>useroffset and usersize fields. Yet the fields are still initialized,
> >>preventing merging of otherwise compatible caches. Thus ignore the
> >>values passed to cache creation and leave them zero when
> >>CONFIG_HARDENED_USERCOPY is disabled.
> >>
> >>In a quick virtme boot test, this has reduced the number of caches in
> >>/proc/slabinfo from 131 to 111.
> >>
> >>Cc: Kees Cook <keescook@chromium.org>
> >>Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >>---
> >> mm/slab_common.c | 6 +++++-
> >> 1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/mm/slab_common.c b/mm/slab_common.c
> >>index 0042fb2730d1..a8cb5de255fc 100644
> >>--- a/mm/slab_common.c
> >>+++ b/mm/slab_common.c
> >>@@ -317,7 +317,8 @@ kmem_cache_create_usercopy(const char *name,
> >> 	flags &= CACHE_CREATE_MASK;
> >> 
> >> 	/* Fail closed on bad usersize of useroffset values. */
> >>-	if (WARN_ON(!usersize && useroffset) ||
> >>+	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||
> >>+	    WARN_ON(!usersize && useroffset) ||
> >> 	    WARN_ON(size < usersize || size - usersize < useroffset))
> >> 		usersize = useroffset = 0;
> >> 
> >>@@ -640,6 +641,9 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name,
> >> 		align = max(align, size);
> >> 	s->align = calculate_alignment(flags, align, size);
> >> 
> >>+	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY))
> >>+		useroffset = usersize = 0;
> >>+
> >> 	s->useroffset = useroffset;
> >> 	s->usersize = usersize;
> >> 
> > 
> > "Always non-mergeable" is intentional here, but I do see the argument
> > for not doing it under hardened-usercopy.
> > 
> > That said, if you keep this part, maybe go the full step and ifdef away
> > useroffset/usersize's struct member definition and other logic, especially
> > for SLUB_TINY benefits, so 2 ulongs are dropped from the cache struct?
> 
> Okay, probably won't make much difference in practice, but for consistency...
> ----8<----
> From 3cdb7b6ad16a9d95603b482969fa870f996ac9dc Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Wed, 16 Nov 2022 15:56:32 +0100
> Subject: [PATCH] mm, slab: ignore hardened usercopy parameters when disabled
> 
> With CONFIG_HARDENED_USERCOPY not enabled, there are no
> __check_heap_object() checks happening that would use the struct
> kmem_cache useroffset and usersize fields. Yet the fields are still
> initialized, preventing merging of otherwise compatible caches.
> 
> Also the fields contribute to struct kmem_cache size unnecessarily when
> unused. Thus #ifdef them out completely when CONFIG_HARDENED_USERCOPY is
> disabled.
> 
> In a quick virtme boot test, this has reduced the number of caches in
> /proc/slabinfo from 131 to 111.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/slab_def.h | 2 ++
>  include/linux/slub_def.h | 2 ++
>  mm/slab.h                | 2 --
>  mm/slab_common.c         | 9 ++++++++-
>  mm/slub.c                | 4 ++++
>  5 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> index f0ffad6a3365..5834bad8ad78 100644
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -80,8 +80,10 @@ struct kmem_cache {
>  	unsigned int *random_seq;
>  #endif
>  
> +#ifdef CONFIG_HARDENED_USERCOPY
>  	unsigned int useroffset;	/* Usercopy region offset */
>  	unsigned int usersize;		/* Usercopy region size */
> +#endif
>  
>  	struct kmem_cache_node *node[MAX_NUMNODES];
>  };
> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> index f9c68a9dac04..7ed5e455cbf4 100644
> --- a/include/linux/slub_def.h
> +++ b/include/linux/slub_def.h
> @@ -136,8 +136,10 @@ struct kmem_cache {
>  	struct kasan_cache kasan_info;
>  #endif
>  
> +#ifdef CONFIG_HARDENED_USERCOPY
>  	unsigned int useroffset;	/* Usercopy region offset */
>  	unsigned int usersize;		/* Usercopy region size */
> +#endif
>  
>  	struct kmem_cache_node *node[MAX_NUMNODES];
>  };
> diff --git a/mm/slab.h b/mm/slab.h
> index 0202a8c2f0d2..db9a7984e22e 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -207,8 +207,6 @@ struct kmem_cache {
>  	unsigned int size;	/* The aligned/padded/added on size  */
>  	unsigned int align;	/* Alignment as calculated */
>  	slab_flags_t flags;	/* Active flags on the slab */
> -	unsigned int useroffset;/* Usercopy region offset */
> -	unsigned int usersize;	/* Usercopy region size */
>  	const char *name;	/* Slab name for sysfs */
>  	int refcount;		/* Use counter */
>  	void (*ctor)(void *);	/* Called on object slot creation */
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 0042fb2730d1..4339c839a452 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -143,8 +143,10 @@ int slab_unmergeable(struct kmem_cache *s)
>  	if (s->ctor)
>  		return 1;
>  
> +#ifdef CONFIG_HARDENED_USERCOPY
>  	if (s->usersize)
>  		return 1;
> +#endif
>  
>  	/*
>  	 * We may have set a slab to be unmergeable during bootstrap.
> @@ -223,8 +225,10 @@ static struct kmem_cache *create_cache(const char *name,
>  	s->size = s->object_size = object_size;
>  	s->align = align;
>  	s->ctor = ctor;
> +#ifdef CONFIG_HARDENED_USERCOPY
>  	s->useroffset = useroffset;
>  	s->usersize = usersize;
> +#endif
>  
>  	err = __kmem_cache_create(s, flags);
>  	if (err)
> @@ -317,7 +321,8 @@ kmem_cache_create_usercopy(const char *name,
>  	flags &= CACHE_CREATE_MASK;
>  
>  	/* Fail closed on bad usersize of useroffset values. */
> -	if (WARN_ON(!usersize && useroffset) ||
> +	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||
> +	    WARN_ON(!usersize && useroffset) ||
>  	    WARN_ON(size < usersize || size - usersize < useroffset))
>  		usersize = useroffset = 0;
>  
> @@ -640,8 +645,10 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name,
>  		align = max(align, size);
>  	s->align = calculate_alignment(flags, align, size);
>  
> +#ifdef CONFIG_HARDENED_USERCOPY
>  	s->useroffset = useroffset;
>  	s->usersize = usersize;
> +#endif
>  
>  	err = __kmem_cache_create(s, flags);
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index 157527d7101b..e32db8540767 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5502,11 +5502,13 @@ static ssize_t cache_dma_show(struct kmem_cache *s, char *buf)
>  SLAB_ATTR_RO(cache_dma);
>  #endif
>  
> +#ifdef CONFIG_HARDENED_USERCOPY
>  static ssize_t usersize_show(struct kmem_cache *s, char *buf)
>  {
>  	return sysfs_emit(buf, "%u\n", s->usersize);
>  }
>  SLAB_ATTR_RO(usersize);
> +#endif
>  
>  static ssize_t destroy_by_rcu_show(struct kmem_cache *s, char *buf)
>  {
> @@ -5803,7 +5805,9 @@ static struct attribute *slab_attrs[] = {
>  #ifdef CONFIG_FAILSLAB
>  	&failslab_attr.attr,
>  #endif
> +#ifdef CONFIG_HARDENED_USERCOPY
>  	&usersize_attr.attr,
> +#endif
>  #ifdef CONFIG_KFENCE
>  	&skip_kfence_attr.attr,
>  #endif
> -- 
> 2.38.1
>

Looks good to me,
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

-- 
Thanks,
Hyeonggon
