Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B20A4D
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 10:48:05 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so6500360pju.2
        for <patches@lists.linux.dev>; Fri, 04 Mar 2022 02:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z54H2QvreHmJqqQnwQD09l+XU0wFN1Y2CxR47bcJ36Y=;
        b=B9zgMJXFKibA/4srIpbdHFFI7vfXq0r70bUvuhAidUvllaRYXwbC4w/vOtqYMhh+Cu
         79zXMyTR7F0uQJmF6oWPVJy8HMQ92Bc6qbPqu9hT4RP3akjQwermpe4cjB/2QD6PELVn
         lltOqQIlX9v2S+lExEfduP5IKZ5bof0jgaKvOhEZC5Q1Xl9CPSxwsgJwV9kn07IrdZ9d
         lZenOiDi/a1lVhxHTJjfQaqPldY+uRd523kqlAL0IPFMl7lkdYXaDtZ9f81sl+qooBPZ
         XNV/Qbr4RXPOyVTMOakD6gAREQxDafdAvipBS6+G452kvdgA3NNYD96xWxtTjGJBdrg7
         +3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z54H2QvreHmJqqQnwQD09l+XU0wFN1Y2CxR47bcJ36Y=;
        b=Ed3N8U4ceO5OPWTHsl9eebh656/UvcSdKc3ZmDkFEZGMUKYp+ukJsuaMTZ/oZbPbaV
         hWRr6nPG0mZxGrHE4GBw3WUfn+qNWGMk7XgA7D7MnGj7B4jzye8rrrTA2NsZyJ8dc8Xg
         Fz8AFA5ZmiFvJg+uu11fqGuW0sZX/nye0Vd0OEtcDa/9TBbuD/rgle2ZbN6Mtpa0dzP3
         avg6KaKD72bStnh1sS53qdlvE7UuNdSCLM6n6lOejiP9kPa8l8lUhNCbaAg6D1g7JHfe
         +ZeiJGtD74gK72l9LuPN+upSqAiJRpo3WVOcUyUl///PaE3dB2OXBNle9fERHC+XC5Lm
         kL+g==
X-Gm-Message-State: AOAM533YZfOfn4gfi0BUlglp0b91Z3wyZqa3bPTQasjxmDQEbZ9IYi1K
	PkiPYQfCBA37FEqr2ZvI/SA=
X-Google-Smtp-Source: ABdhPJyv1f/qjb13ch8hfn//KCV8fKt9UHWLMFcFGeFj8P6lx9v0weoDI0vgtRrL2iHJ0OVRi3trYA==
X-Received: by 2002:a17:90b:3b82:b0:1bf:32c4:7dc6 with SMTP id pc2-20020a17090b3b8200b001bf32c47dc6mr237756pjb.155.1646390885229;
        Fri, 04 Mar 2022 02:48:05 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id cv15-20020a17090afd0f00b001bedcbca1a9sm10278010pjb.57.2022.03.04.02.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 02:48:04 -0800 (PST)
Date: Fri, 4 Mar 2022 10:47:59 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Oliver Glitta <glittao@gmail.com>,
	Faiyaz Mohammed <faiyazm@codeaurora.org>,
	Marco Elver <elver@google.com>, Mike Rapoport <rppt@linux.ibm.com>,
	Imran Khan <imran.f.khan@oracle.com>
Subject: Re: [PATCH v3r0 1/6] lib/stackdepot: allow requesting early
 initialization dynamically
Message-ID: <YiHuXyu9/5I83hP8@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220302173122.11939-1-vbabka@suse.cz>
 <20220302173122.11939-2-vbabka@suse.cz>
 <c923550e-c88e-aad4-ecc2-fa8a3d0a1f1c@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c923550e-c88e-aad4-ecc2-fa8a3d0a1f1c@suse.cz>

On Thu, Mar 03, 2022 at 08:19:33PM +0100, Vlastimil Babka wrote:
> Here's an updated version based on feedback so I don't re-send everything
> so soon after v2. Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slub-stackdepot-v3r0
> There are only trivial adaptations in patch 3/6 to the stack depot init
> changes otherwise.
> Thanks, Vlastimil
> 
> ----8<----
> From 230ebae0f83540574d167f9ba1f71d3f602ca410 Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Wed, 2 Mar 2022 12:02:22 +0100
> Subject: [PATCH v3 1/6] lib/stackdepot: allow requesting early initialization
>  dynamically
> 
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
> code that's e.g. processing boot parameters (which happens early enough)
> can call a new function stack_depot_want_early_init(), which sets a flag
> that stack_depot_early_init() will check.
> 
> In this patch we also convert page_owner to this approach. While it
> doesn't have the bootstrap issue as slub, it's also a functionality
> enabled by a boot param and can thus request stack_depot_early_init()
> with memblock allocation instead of later initialization with
> kvmalloc().
> 
> As suggested by Mike, make stack_depot_early_init() only attempt
> memblock allocation and stack_depot_init() only attempt kvmalloc().
> Also change the latter to kvcalloc(). In both cases we can lose the
> explicit array zeroing, which the allocations do already.
> 
> As suggested by Marco, provide empty implementations of the init
> functions for !CONFIG_STACKDEPOT builds to simplify the callers.
> 
> [1] https://lore.kernel.org/all/YhnUcqyeMgCrWZbd@ip-172-31-19-208.ap-northeast-1.compute.internal/
> 
> Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Suggested-by: Mike Rapoport <rppt@linux.ibm.com>
> Suggested-by: Marco Elver <elver@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/stackdepot.h | 26 ++++++++++++---
>  lib/stackdepot.c           | 67 +++++++++++++++++++++++++-------------
>  mm/page_owner.c            |  9 +++--
>  3 files changed, 73 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
> index 17f992fe6355..bc2797955de9 100644
> --- a/include/linux/stackdepot.h
> +++ b/include/linux/stackdepot.h
> @@ -20,18 +20,36 @@ depot_stack_handle_t __stack_depot_save(unsigned long *entries,
>  					gfp_t gfp_flags, bool can_alloc);
>  
>  /*
> - * Every user of stack depot has to call this during its own init when it's
> - * decided that it will be calling stack_depot_save() later.
> + * Every user of stack depot has to call stack_depot_init() during its own init
> + * when it's decided that it will be calling stack_depot_save() later. This is
> + * recommended for e.g. modules initialized later in the boot process, when
> + * slab_is_available() is true.
>   *
>   * The alternative is to select STACKDEPOT_ALWAYS_INIT to have stack depot
>   * enabled as part of mm_init(), for subsystems where it's known at compile time
>   * that stack depot will be used.
> + *
> + * Another alternative is to call stack_depot_want_early_init(), when the
> + * decision to use stack depot is taken e.g. when evaluating kernel boot
> + * parameters, which precedes the enablement point in mm_init().
> + *
> + * stack_depot_init() and stack_depot_want_early_init() can be called regardless
> + * of CONFIG_STACKDEPOT and are no-op when disabled. The actual save/fetch/print
> + * functions should only be called from code that makes sure CONFIG_STACKDEPOT
> + * is enabled.
>   */
> +#ifdef CONFIG_STACKDEPOT
>  int stack_depot_init(void);
>  
> -#ifdef CONFIG_STACKDEPOT_ALWAYS_INIT
> -static inline int stack_depot_early_init(void)	{ return stack_depot_init(); }
> +void __init stack_depot_want_early_init(void);
> +
> +/* This is supposed to be called only from mm_init() */
> +int __init stack_depot_early_init(void);
>  #else
> +static inline int stack_depot_init(void) { return 0; }
> +
> +static inline void stack_depot_want_early_init(void) { }
> +
>  static inline int stack_depot_early_init(void)	{ return 0; }
>  #endif
>  
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index bf5ba9af0500..0a5916f1e7a3 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -66,6 +66,9 @@ struct stack_record {
>  	unsigned long entries[];	/* Variable-sized array of entries. */
>  };
>  
> +static bool __stack_depot_want_early_init __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
> +static bool __stack_depot_early_init_passed __initdata;
> +
>  static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
>  
>  static int depot_index;
> @@ -162,38 +165,58 @@ static int __init is_stack_depot_disabled(char *str)
>  }
>  early_param("stack_depot_disable", is_stack_depot_disabled);
>  
> -/*
> - * __ref because of memblock_alloc(), which will not be actually called after
> - * the __init code is gone, because at that point slab_is_available() is true
> - */
> -__ref int stack_depot_init(void)
> +void __init stack_depot_want_early_init(void)
> +{
> +	/* Too late to request early init now */
> +	WARN_ON(__stack_depot_early_init_passed);
> +
> +	__stack_depot_want_early_init = true;
> +}
> +
> +int __init stack_depot_early_init(void)
> +{
> +	size_t size;
> +	int i;

compile warning: unused variable i.

> +	/* This is supposed to be called only once, from mm_init() */
> +	if (WARN_ON(__stacki_depot_early_init_passed))
> +		return 0;
> +
> +	__stack_depot_early_init_passed = true;
> +
> +	if (!__stack_depot_want_early_init || stack_depot_disable)
> +		return 0;
> +
> +	pr_info("Stack Depot early init allocating hash table with memblock_alloc\n");
> +	size = (STACK_HASH_SIZE * sizeof(struct stack_record *));
> +	stack_table = memblock_alloc(size, SMP_CACHE_BYTES);
> +
> +	if (!stack_table) {
> +		pr_err("Stack Depot hash table allocation failed, disabling\n");
> +		stack_depot_disable = true;
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +int stack_depot_init(void)
>  {
>  	static DEFINE_MUTEX(stack_depot_init_mutex);
> +	int ret = 0;
>  
>  	mutex_lock(&stack_depot_init_mutex);
>  	if (!stack_depot_disable && !stack_table) {
> -		size_t size = (STACK_HASH_SIZE * sizeof(struct stack_record *));
> -		int i;
> -
> -		if (slab_is_available()) {
> -			pr_info("Stack Depot allocating hash table with kvmalloc\n");
> -			stack_table = kvmalloc(size, GFP_KERNEL);
> -		} else {
> -			pr_info("Stack Depot allocating hash table with memblock_alloc\n");
> -			stack_table = memblock_alloc(size, SMP_CACHE_BYTES);
> -		}
> -		if (stack_table) {
> -			for (i = 0; i < STACK_HASH_SIZE;  i++)
> -				stack_table[i] = NULL;
> -		} else {
> +		pr_info("Stack Depot allocating hash table with kvcalloc\n");
> +		stack_table = kvcalloc(STACK_HASH_SIZE, sizeof(struct stack_record *), GFP_KERNEL);
> +		if (!stack_table) {
>  			pr_err("Stack Depot hash table allocation failed, disabling\n");
>  			stack_depot_disable = true;
> -			mutex_unlock(&stack_depot_init_mutex);
> -			return -ENOMEM;
> +			ret = -ENOMEM;
>  		}
>  	}
>  	mutex_unlock(&stack_depot_init_mutex);
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(stack_depot_init);
>  
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 99e360df9465..4313f8212a83 100644
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
> +		stack_depot_want_early_init();
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
>

This approach looks much better!

Otherwise looks good.
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Works as expected on my system.
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

-- 
Thank you, You are awesome!
Hyeonggon :-)
