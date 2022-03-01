Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6499317E4
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 03:53:15 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id z15so12991026pfe.7
        for <patches@lists.linux.dev>; Mon, 28 Feb 2022 19:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KOhBM55iXZYEmx9IYBkoTVCwltMj7BAc5rVJhF2Tk4Y=;
        b=Z3TtiMRUlxmZIIYkMRiY0fzmGGMZMMk4/slyPir2Q+k5jZFaTUur95x1fkat0XMlNf
         rmwEhvAifEr8kst0jhTJOfAdvPh0r1IB5/oHH8IUZXySf9D71eOPH0t//b9thWAoM+PB
         ELjfOUbX0xpENQaoU1GRs8io+Q7owQuRppcSRcZypgz8gqwxM+tAFrQXN4KIwmovmxUd
         w7nWe5Xx4on4p+ilbaAbmqyTP/nUMH3zYrXKaG1UvNa0lC8NHo6PREsy5P2liiOidsZd
         nT7yrfmuioV19ubeVlk8/LUNOSneKdLaje97Yy7782mk2sgeNhcBwTOicS81mQ1M3jeb
         S5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KOhBM55iXZYEmx9IYBkoTVCwltMj7BAc5rVJhF2Tk4Y=;
        b=Xb/M2jjZVvzfe4nDpV/hryPUtDriW7/yTvif47XJHuETPMe5QhTm4P/6/EsjIY+Mqq
         PJIexRiWo0bCD5eD1P3Qkl8TutuBRkXxkTiXtAltc5APR92d42k5Wfq6/S3grhhvs9rd
         v6xzirKpROx6/QtB3aanw2/w0fU5a8q4OC0kqhDyuUL9X5vWeU+55icVb546ShRNlnXe
         9vXRZI9ne5ReV10JoJETtHACEokceEl3OhtcjmyJc0rEJtr3KFOYMee/J4w5quuS75oZ
         A8Aazy9HD17Z0ONaZurVZlHkSQZTVa6n3swukfNSEeMd2nZX6+Dhi5WNQB2BrZ9f1RL5
         lsyw==
X-Gm-Message-State: AOAM531dlPiLnAzh2KHvwMVFn0MdicRxZkgP5oZBh8VVy5Uo6TzfZVH+
	OFYAoORF+zJc1pkOiBUboGA=
X-Google-Smtp-Source: ABdhPJzqCFyV7j39Dy/mmG6Qr16FWNaDuc2L/hx/fAXqPgDD7J1orR2RqOt3IAyldzvj5HKFXbsc+g==
X-Received: by 2002:a05:6a00:1143:b0:4f0:e9bf:6333 with SMTP id b3-20020a056a00114300b004f0e9bf6333mr25327109pfm.29.1646106794792;
        Mon, 28 Feb 2022 19:53:14 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id q24-20020aa79618000000b004e0e89985eesm14290953pfg.156.2022.02.28.19.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 19:53:14 -0800 (PST)
Date: Tue, 1 Mar 2022 03:53:06 +0000
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
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Yury Norov <yury.norov@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Matteo Croce <mcroce@microsoft.com>, Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Zqiang <qiang.zhang@windriver.com>
Subject: Re: [PATCH v2] mm/slub: initialize stack depot in boot process
Message-ID: <Yh2YoqGwfwwpiFOJ@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <Yh2Uxh9DMndwjGcb@ip-172-31-19-208.ap-northeast-1.compute.internal>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh2Uxh9DMndwjGcb@ip-172-31-19-208.ap-northeast-1.compute.internal>

On Tue, Mar 01, 2022 at 03:36:38AM +0000, Hyeonggon Yoo wrote:
> commit ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in
> objects") initializes stack depot in cache creation if SLAB_STORE_USER
> flag is set.
> 
> This can make kernel crash because a cache can be crashed in various
> contexts. For example if user sets slub_debug=U, kernel crashes
> because create_boot_cache() calls stack_depot_init(), which tries to
> allocate hash table using memblock_alloc() if slab is not available.
> But memblock is also not available at that time.
> 
> This patch solves the problem by initializing stack depot early
> in boot process if SLAB_STORE_USER debug flag is set globally
> or the flag is set for at least one cache.
> 

Hello Vlastimil, would you pick this up into slub-stackdepot-v1,
or fold it into original patch (2/5)?

Thanks!

-- 
Thank you, You are awesome!
Hyeonggon :-)

> [ elver@google.com: initialize stack depot depending on slub_debug
>   parameter instead of allowing stack_depot_init() to be called
>   during kmem_cache_init() for simplicity. ]
> 
> [ vbabka@suse.cz: parse slub_debug parameter in setup_slub_debug()
>   and initialize stack depot in stack_depot_early_init(). ]
> 
> Link: https://lore.kernel.org/all/YhyeaP8lrzKgKm5A@ip-172-31-19-208.ap-northeast-1.compute.internal/
> Fixes: ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in objects")
> Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> ---
>  include/linux/slab.h       |  6 ++++++
>  include/linux/stackdepot.h |  3 ++-
>  mm/slub.c                  | 18 +++++++++++++++---
>  3 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 37bde99b74af..062128e0db10 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -763,6 +763,12 @@ extern void kvfree_sensitive(const void *addr, size_t len);
>  unsigned int kmem_cache_size(struct kmem_cache *s);
>  void __init kmem_cache_init_late(void);
>  
> +#if defined(CONFIG_SLUB_DEBUG) && defined(CONFIG_STACKDEPOT)
> +int slab_stack_depot_init(void);
> +#else
> +int slab_stack_depot_init(void) { return 0; }
> +#endif
> +
>  #if defined(CONFIG_SMP) && defined(CONFIG_SLAB)
>  int slab_prepare_cpu(unsigned int cpu);
>  int slab_dead_cpu(unsigned int cpu);
> diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
> index 17f992fe6355..a813a2673c48 100644
> --- a/include/linux/stackdepot.h
> +++ b/include/linux/stackdepot.h
> @@ -12,6 +12,7 @@
>  #define _LINUX_STACKDEPOT_H
>  
>  #include <linux/gfp.h>
> +#include <linux/slab.h>
>  
>  typedef u32 depot_stack_handle_t;
>  
> @@ -32,7 +33,7 @@ int stack_depot_init(void);
>  #ifdef CONFIG_STACKDEPOT_ALWAYS_INIT
>  static inline int stack_depot_early_init(void)	{ return stack_depot_init(); }
>  #else
> -static inline int stack_depot_early_init(void)	{ return 0; }
> +static inline int stack_depot_early_init(void)	{ return slab_stack_depot_init(); }
>  #endif
>  
>  depot_stack_handle_t stack_depot_save(unsigned long *entries,
> diff --git a/mm/slub.c b/mm/slub.c
> index a74afe59a403..2419fc3cc9f3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -646,6 +646,14 @@ static slab_flags_t slub_debug;
>  
>  static char *slub_debug_string;
>  static int disable_higher_order_debug;
> +static bool init_stack_depot;
> +
> +int slab_stack_depot_init(void)
> +{
> +	if (init_stack_depot)
> +		stack_depot_init();
> +	return 0;
> +}
>  
>  /*
>   * slub is about to manipulate internal object metadata.  This memory lies
> @@ -1531,6 +1539,8 @@ static int __init setup_slub_debug(char *str)
>  			global_slub_debug_changed = true;
>  		} else {
>  			slab_list_specified = true;
> +			if (flags & SLAB_STORE_USER)
> +				init_stack_depot = true;
>  		}
>  	}
>  
> @@ -1546,6 +1556,10 @@ static int __init setup_slub_debug(char *str)
>  			global_flags = slub_debug;
>  		slub_debug_string = saved_str;
>  	}
> +
> +	if (global_flags & SLAB_STORE_USER)
> +		init_stack_depot = true;
> +
>  out:
>  	slub_debug = global_flags;
>  	if (slub_debug != 0 || slub_debug_string)
> @@ -1556,6 +1570,7 @@ static int __init setup_slub_debug(char *str)
>  	     static_branch_unlikely(&init_on_free)) &&
>  	    (slub_debug & SLAB_POISON))
>  		pr_info("mem auto-init: SLAB_POISON will take precedence over init_on_alloc/init_on_free\n");
> +
>  	return 1;
>  }
>  
> @@ -4221,9 +4236,6 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
>  	s->remote_node_defrag_ratio = 1000;
>  #endif
>  
> -	if (s->flags & SLAB_STORE_USER && IS_ENABLED(CONFIG_STACKDEPOT))
> -		stack_depot_init();
> -
>  	/* Initialize the pre-computed randomized freelist if slab is up */
>  	if (slab_state >= UP) {
>  		if (init_cache_random_seq(s))
> -- 
> 2.33.1
