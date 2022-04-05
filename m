Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A983216
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 21:40:05 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id 2so737670pjw.2
        for <patches@lists.linux.dev>; Tue, 05 Apr 2022 14:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=zKtk8IB6XHTmH0rCMSyzNZth13clvLYrEOIwPUoghbk=;
        b=S5IX/7UJx34NsUTApmyYCV0F/JLcTJY4iR5N1wG9UIzjBrqYqkgvGk1o8HH9iJY9mG
         jCCsZDzVU86SFHE5ozcmOBigOFi05AzbzIO+dJaqhBsApL6y8fLHQrHglt3pKo174ZHn
         zHMcwxxlvTbg4QrGWC9hOKcjEuBz8E+tFbRtEJrNPdcPb1QfWD55UzuTVVih31SaEaKz
         TS3GUgnzQ95tPpjzuiGUjsDu7G8weuIbzoGLoaxZN6u4OlyNMUYLza/0dG0wC4Ng8IQK
         jU6jTkst9VzN41g0Gf9EReaup3pyzB38l5FJ8OgTzfASbMqb7+n52CJgZ3/3n2aAJlUL
         dOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=zKtk8IB6XHTmH0rCMSyzNZth13clvLYrEOIwPUoghbk=;
        b=09zO3rSlrxtCS0GEHKgIYmr83sownqz4apxaRbnGYTCWj/ngJ5haK1Gq0SBxhJvvMB
         kQ/64AzD+SiWlnZTtn9JC3ZsqaxN2DsQ9pj7jWgYupOzn+p//+4jbGZZMhfTpeQ8zHZ5
         5vmJl6ffyUXw/Rqu7r3GeDZWr+r0boLW3UIndOrKEZ/aU5llo/hpCrgqpVO6ZDS8nt1B
         OdZBYuSelmXP1O7UF/bLcKknt9X56BNQls1nJmMZldfG3Cj+WDB+mEj4ap8NXbpxn1sL
         PgazMhiB7ll0esYVt4QHG0GbGaGNXH7bI3GMqWHGC5V00U1uyprPXaY+7PDvoWBPJYiG
         faTg==
X-Gm-Message-State: AOAM533OzInDPnrnnW9/d5lUcCdf6YgP69Ne8k1+JIDG8k8PukZ9ZURj
	cuHTa5PfWubpYRZ3/ipUAMP4Dw==
X-Google-Smtp-Source: ABdhPJxe5rGvLugDy5hnVIrZMk9Aay9zhdwj6790D9RZgURPBRtDTauGOf1wpuNP1IMEZfRxBh8d5Q==
X-Received: by 2002:a17:903:2309:b0:153:ad3f:b074 with SMTP id d9-20020a170903230900b00153ad3fb074mr5272861plh.82.1649194804269;
        Tue, 05 Apr 2022 14:40:04 -0700 (PDT)
Received: from [2620:15c:29:204:be3e:5e1c:99cc:513f] ([2620:15c:29:204:be3e:5e1c:99cc:513f])
        by smtp.gmail.com with ESMTPSA id f3-20020a17090aa78300b001ca7dfab2e4sm3270192pjq.25.2022.04.05.14.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 14:40:03 -0700 (PDT)
Date: Tue, 5 Apr 2022 14:40:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Pekka Enberg <penberg@kernel.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
    patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Oliver Glitta <glittao@gmail.com>, Marco Elver <elver@google.com>, 
    Mike Rapoport <rppt@linux.ibm.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
    Imran Khan <imran.f.khan@oracle.com>
Subject: Re: [PATCH v3 1/6] lib/stackdepot: allow requesting early initialization
 dynamically
In-Reply-To: <20220404164112.18372-2-vbabka@suse.cz>
Message-ID: <8a13e52b-f4ff-4fd9-1f8a-fdea3868bc1@google.com>
References: <20220404164112.18372-1-vbabka@suse.cz> <20220404164112.18372-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 4 Apr 2022, Vlastimil Babka wrote:

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
> Reviewed-by: Marco Elver <elver@google.com>
> Reviewed-and-tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  include/linux/stackdepot.h | 26 ++++++++++++---
>  lib/stackdepot.c           | 66 +++++++++++++++++++++++++-------------
>  mm/page_owner.c            |  9 ++++--
>  3 files changed, 72 insertions(+), 29 deletions(-)
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
> index bf5ba9af0500..6c4644c9ed44 100644
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
> @@ -162,38 +165,57 @@ static int __init is_stack_depot_disabled(char *str)
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
> +
> +	/* This is supposed to be called only once, from mm_init() */
> +	if (WARN_ON(__stack_depot_early_init_passed))
> +		return 0;
> +
> +	__stack_depot_early_init_passed = true;
> +
> +	if (!__stack_depot_want_early_init || stack_depot_disable)
> +		return 0;
> +
> +	pr_info("Stack Depot early init allocating hash table with memblock_alloc\n");
> +	size = (STACK_HASH_SIZE * sizeof(struct stack_record *));

I think the kvcalloc() in the main init path is very unlikely to fail, but 
perhaps this memblock_alloc() might?  If so, a nit might be to include 
this size as part of the printk.

Either way:

Acked-by: David Rientjes <rientjes@google.com>
