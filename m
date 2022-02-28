Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1417C
	for <patches@lists.linux.dev>; Mon, 28 Feb 2022 16:28:26 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id p4so6015435wmg.1
        for <patches@lists.linux.dev>; Mon, 28 Feb 2022 08:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BliGt+iPKuKGr4oLeNuQ/K/5nXnK23JHVRrUdB5Tty4=;
        b=Mt08F5B/Al0+2RudF6JL95dKNQ9fFfqz++XHh5fxjmdL6aF8yCVa63qI0wDVf5YH8F
         D2ZiWA8rZgPHTk9YYdYriyerp6DCVt33b+ORMLpXY++8MNmjhlqL4eXMVVsEF386UFZc
         C+7zaRsYrCbzTEgc9YmkaPtHWAcw90x7Fz7wk33Dl+VomcnbPiW35/ZCjDjfdUC2Lu7o
         3qBrQSpnSbwaMS8bBInqDjX4r86wxiOQXMjLT7EJd/0FA0eoAKU+7Nl+HqqpR/EqUHnk
         tCzc8hHUW8vIb7CWEgE31naKa42QlYbyHYnmGQBs2zXeJI+x6OE/HdeZwEyr3UEk05FI
         yzmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BliGt+iPKuKGr4oLeNuQ/K/5nXnK23JHVRrUdB5Tty4=;
        b=O59MPSTUNKBCHKDqMZ296Kdsht12qbgO+lP7B76GmzUlzzbX6I2rd889WtZe4pEsHv
         7SQsX8ziaaXVcrxp1MJQTjFL5vN/YYHUMAkbE0abEbhuC6MLy6Vm24vrNXmiYl0NPZmB
         xHN8UwB+tlxh6okssQWP8ijfPkukvWh6VaLqpE6CdjE1HaYE8FZ8ymnLAy4s1nlEtng3
         yXCIgQ33pX4ridCo1YU5cEVvixdGRN8wfWgvAs7NbVZBkJcLyY9jlwy2wexiq+X3ayVo
         4wx9XcA8xsAiug0Cb57c4GGf7zAgsCAo4PGIJafUR3Kn4ieCguqgPcg9xRCgeOoJ3m6p
         RhTg==
X-Gm-Message-State: AOAM531E2qMgN//yakGRMex9mP72WPibrKpHFivrxHxkQc5+dyekC9B2
	a8Q/SHbcwL7uoYOUrFydQNQtqQ==
X-Google-Smtp-Source: ABdhPJxZIvUBldRsZFQEsWiZZluxxoz8ubHo63gOYgUKw80pFb+R/RqQoRzJITseDXlGGvaxWo6/4Q==
X-Received: by 2002:a7b:c381:0:b0:37b:e01f:c1c0 with SMTP id s1-20020a7bc381000000b0037be01fc1c0mr13771904wmj.98.1646065704302;
        Mon, 28 Feb 2022 08:28:24 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:15:13:4ba9:ec5e:bee2:4388])
        by smtp.gmail.com with ESMTPSA id e22-20020adf9bd6000000b001eda1017861sm11422337wrc.64.2022.02.28.08.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 08:28:23 -0800 (PST)
Date: Mon, 28 Feb 2022 17:28:17 +0100
From: Marco Elver <elver@google.com>
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
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
	Matteo Croce <mcroce@microsoft.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Zqiang <qiang.zhang@windriver.com>
Subject: Re: [PATCH] mm/slub: initialize stack depot in boot process
Message-ID: <Yhz4IQUQr7ln+G86@elver.google.com>
References: <CANpmjNOOhuoU7T4UqHbzkRAvM+b-gvt+Qtx41va=9ixGgUSWaQ@mail.gmail.com>
 <Yhzlw0GGBeuCALJp@ip-172-31-19-208.ap-northeast-1.compute.internal>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yhzlw0GGBeuCALJp@ip-172-31-19-208.ap-northeast-1.compute.internal>
User-Agent: Mutt/2.1.4 (2021-12-11)

On Mon, Feb 28, 2022 at 03:09PM +0000, Hyeonggon Yoo wrote:
> commit ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in
> objects") initializes stack depot while creating cache if SLAB_STORE_USER
> flag is set.
> 
> This can make kernel crash because a cache can be created in various
> contexts. For example if user sets slub_debug=U, kernel crashes
> because create_boot_cache() calls stack_depot_init(), which tries to
> allocate hash table using memblock_alloc() if slab is not available.
> But memblock is also not available at that time.
> 
> This patch solves the problem by initializing stack depot early
> in boot process if SLAB_STORE_USER debug flag is set globally
> or the flag is set to at least one cache.
> 
> [ elver@google.com: initialize stack depot depending on slub_debug
>   parameter instead of allowing stack_depot_init() can be called
>   in kmem_cache_init() for simplicity. ]
> 
> Link: https://lkml.org/lkml/2022/2/28/238

This would be a better permalink:
https://lore.kernel.org/all/YhyeaP8lrzKgKm5A@ip-172-31-19-208.ap-northeast-1.compute.internal/

> Fixes: ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in objects")

This commit does not exist in -next.

I assume you intend that "lib/stackdepot: Use page allocator if both
slab and memblock is unavailable" should be dropped now.

> Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> ---
>  include/linux/slab.h |  1 +
>  init/main.c          |  1 +
>  mm/slab.c            |  4 ++++
>  mm/slob.c            |  4 ++++
>  mm/slub.c            | 28 +++++++++++++++++++++++++---
>  5 files changed, 35 insertions(+), 3 deletions(-)
[...]
>  
> +/* Initialize stack depot if needed */
> +void __init kmem_cache_init_early(void)
> +{
> +#ifdef CONFIG_STACKDEPOT
> +	slab_flags_t block_flags;
> +	char *next_block;
> +	char *slab_list;
> +
> +	if (slub_debug & SLAB_STORE_USER)
> +		goto init_stack_depot;
> +
> +	next_block = slub_debug_string;
> +	while (next_block) {
> +		next_block = parse_slub_debug_flags(next_block, &block_flags, &slab_list, false);
> +		if (block_flags & SLAB_STORE_USER)
> +			goto init_stack_depot;
> +	}
> +
> +	return;
> +
> +init_stack_depot:
> +	stack_depot_init();
> +#endif
> +}

You can simplify this function to avoid the goto:

	/* Initialize stack depot if needed */
	void __init kmem_cache_init_early(void)
	{
	#ifdef CONFIG_STACKDEPOT
		slab_flags_t flags = slub_debug;
		char *next_block = slub_debug_string;
		char *slab_list;
	
		for (;;) {
			if (flags & SLAB_STORE_USER) {
				stack_depot_init();
				break;
			}
			if (!next_block)
				break;
			next_block = parse_slub_debug_flags(next_block, &flags, &slab_list, false);
		}
	#endif
	}

^^ with this version, it'd also be much easier and less confusing to add
other initialization logic unrelated to stackdepot later after the loop
(should it ever be required).
