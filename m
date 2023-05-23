Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56925393
	for <patches@lists.linux.dev>; Tue, 23 May 2023 07:42:25 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3f6094cb2ebso4132005e9.3
        for <patches@lists.linux.dev>; Tue, 23 May 2023 00:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684827744; x=1687419744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s31X+dH39BfhZ2YOL6vkW3ng692uRsODYiuHdEJt6mQ=;
        b=VBksCNIhqZ2ik3L1QCbmJQ7nz9900GoqegY7JqClevxcmWuBYb640XQMx3CgaX2bXt
         dRXoYVcOuhd1gex415FiIe4qFyTjXnr1uteCjbo9p58uEjstQB5rcgEdlUjEBvAKqzdu
         PzBxjkWAJTOn+86aYcPlfWGpjxsexi3Z6OjRTIZKDnV4kCh1PUGFOaW7eQxIJsfAobz3
         HWjk8iGapyYa3w/wlDjzd1AWlH7A2r7nXrVMs0V7/LL7KLKe5ch30JZ/AFTJ4CYWlhVC
         w8OZ4/T+UHvXLHpnYCY8xY8Ncwrxp8B4Vd7L5aX+ZbVUAqwO5FJdHwBGfhgd5gtqBfne
         XSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684827744; x=1687419744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s31X+dH39BfhZ2YOL6vkW3ng692uRsODYiuHdEJt6mQ=;
        b=HuGbiTFUa6BZZRucb8GeJwznoxrlx/FY5NMd7MKPPYDbKuGsktdOIdvQ8R8KEYSBAQ
         lB5HiTEKsalA/LE1p+NFVqRDXRnS0ycDmTwwM5tltoxfGQvCNCyq9KnUwfkTUELy1WzX
         25el3KagRIrHOgUk6RsdpfmdyqVqhuSVeZgzah6QD3AbRYjwOZSJJApl9aH+107Yq3l7
         Gm8NltZOgyyvYPlFLV2gOhzdaINYsv8JLO0mUKrD6WnyH/qV/dJ0CoU/SnvEMBQG81ox
         Lqrv9t+O6NrHdMKv1E77qPSEafssq1JfVCFhJaadqMAwkzz0BR1AIxD3dIulML+NHuFq
         1c8g==
X-Gm-Message-State: AC+VfDz/hZRLqgiuqiNWtRawHJWj1yT4nvqytBZeH8KHy4Ga1aayvebh
	5SNWnwNlJm4Tho3IowACzho=
X-Google-Smtp-Source: ACHHUZ70nLnWyddNm83xHQcgMWDvEGGRF2urF+lDsb3LmnEA43JMJZAoRwPp2ewfkwo8HNfWqc9HYA==
X-Received: by 2002:a05:600c:294c:b0:3f5:fa8e:aaa3 with SMTP id n12-20020a05600c294c00b003f5fa8eaaa3mr6983948wmd.28.1684827743725;
        Tue, 23 May 2023 00:42:23 -0700 (PDT)
Received: from localhost (host81-154-179-160.range81-154.btcentralplus.com. [81.154.179.160])
        by smtp.gmail.com with ESMTPSA id a12-20020a05600c224c00b003edc4788fa0sm14091106wmm.2.2023.05.23.00.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 00:42:22 -0700 (PDT)
Date: Tue, 23 May 2023 08:42:21 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: remove HAVE_HARDENED_USERCOPY_ALLOCATOR
Message-ID: <310077ed-6f3f-41fe-afcf-36500a9408ec@lucifer.local>
References: <20230523073136.4900-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523073136.4900-1-vbabka@suse.cz>

On Tue, May 23, 2023 at 09:31:36AM +0200, Vlastimil Babka wrote:
> With SLOB removed, both remaining allocators support hardened usercopy,
> so remove the config and associated #ifdef.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/Kconfig       | 2 --
>  mm/slab.h        | 9 ---------
>  security/Kconfig | 8 --------
>  3 files changed, 19 deletions(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 7672a22647b4..041f0da42f2b 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -221,7 +221,6 @@ choice
>  config SLAB
>  	bool "SLAB"
>  	depends on !PREEMPT_RT
> -	select HAVE_HARDENED_USERCOPY_ALLOCATOR
>  	help
>  	  The regular slab allocator that is established and known to work
>  	  well in all environments. It organizes cache hot objects in
> @@ -229,7 +228,6 @@ config SLAB
>
>  config SLUB
>  	bool "SLUB (Unqueued Allocator)"
> -	select HAVE_HARDENED_USERCOPY_ALLOCATOR
>  	help
>  	   SLUB is a slab allocator that minimizes cache line usage
>  	   instead of managing queues of cached objects (SLAB approach).
> diff --git a/mm/slab.h b/mm/slab.h
> index f01ac256a8f5..695ef96b4b5b 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -832,17 +832,8 @@ struct kmem_obj_info {
>  void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
>  #endif
>
> -#ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
>  void __check_heap_object(const void *ptr, unsigned long n,
>  			 const struct slab *slab, bool to_user);
> -#else
> -static inline
> -void __check_heap_object(const void *ptr, unsigned long n,
> -			 const struct slab *slab, bool to_user)
> -{
> -}
> -#endif

Hm, this is still defined in slab.c/slub.c and invoked in usercopy.c, do we
not want the prototype? Perhaps replacing with #ifdef
CONFIG_HARDENED_USERCOPY instead? I may be missing something here :)

> -
>  #ifdef CONFIG_SLUB_DEBUG
>  void skip_orig_size_check(struct kmem_cache *s, const void *object);
>  #endif
> diff --git a/security/Kconfig b/security/Kconfig
> index 97abeb9b9a19..52c9af08ad35 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -127,16 +127,8 @@ config LSM_MMAP_MIN_ADDR
>  	  this low address space will need the permission specific to the
>  	  systems running LSM.
>
> -config HAVE_HARDENED_USERCOPY_ALLOCATOR
> -	bool
> -	help
> -	  The heap allocator implements __check_heap_object() for
> -	  validating memory ranges against heap object sizes in
> -	  support of CONFIG_HARDENED_USERCOPY.
> -
>  config HARDENED_USERCOPY
>  	bool "Harden memory copies between kernel and userspace"
> -	depends on HAVE_HARDENED_USERCOPY_ALLOCATOR
>  	imply STRICT_DEVMEM
>  	help
>  	  This option checks for obviously wrong memory regions when
> --
> 2.40.1
>
