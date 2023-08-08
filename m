Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BB3100A3
	for <patches@lists.linux.dev>; Tue,  8 Aug 2023 12:06:19 +0000 (UTC)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-4fe1344b707so8735147e87.1
        for <patches@lists.linux.dev>; Tue, 08 Aug 2023 05:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691496377; x=1692101177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VxlsPWdBTPAUvYb7Kun1tKN0ClHERPlCGEFAPO7bek=;
        b=Wc4mMPNMD4w/ICoukamaO2bZtr2lJAZOAvRWtRlfwQmrjGMC/xmsMhIATPraxqyd07
         DLTmFShm+iopMcLzZaoxoml19h+5A+/dKeKdM9vdjZ9ilbl2OKtMwhgzMZi7PUSUzb4v
         qmhDzznLbXRG0A5c+wSFlsnouAZexRrVZA7SCa7TTRBOV4QbJCWInRJs80mcPpVrVP/P
         ZNKBy+XX0aPT7O6eIA4z5nF3CrmFCu3qyQkVLSiY0zsBrlZWqJ2a9FZAM+Ld/yUxk8oT
         uCYpXX5girgutnTguoPmyjjgzpDUtyAKcoP23O6w7A5EuUjemlmvoLjhYs8+YKU5DMUb
         SfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691496377; x=1692101177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6VxlsPWdBTPAUvYb7Kun1tKN0ClHERPlCGEFAPO7bek=;
        b=crhC1IU/jX/tUPkAdzfD9hGhMCRwWBUnPxd+8L825VjaKlAv5HU7TaEbJZWNv3VJiT
         fhlPhNi9J3AcUHlc4Tw6Hwrwm6g1xp2MB5kMQ/DbNUcdjDx81sXb0WTiOr9y6/sF2UoT
         mbJmKDQAMWO1csRZGkzDJhmwFsgIMnoi7T9Cay7/28JswMi89ejMNFwmVgiPBFJWHQ80
         kLmt339hqyqNnXV0RWuHha8MoNZYOdwAzdOIQNuWrEs2n78tEYVRJNd4eAr9nMqx4cg4
         TtOBMHmpWD06VWNQEF02XkBzgRaPeUFIx+yfgzNjxIaCGcX0n4nxAUg9nzrs3OKHNBy4
         1sIQ==
X-Gm-Message-State: AOJu0Yyu0oFcncmxEr5bd6dEe2yuGdDk9Iu0Hoq0tgCyBFjJ7cfXTQ/v
	prM6PAarllQkFvbCSIbbwBF8hSuMGbAozpN2mgs=
X-Google-Smtp-Source: AGHT+IFJxFw11piHdQ5PI9U2WJIIc/+c38Pseu7O4O5J602XrFi/HqPWExd1zSzBT69vUcuwSJ38XgGzvfxwECyMXmk=
X-Received: by 2002:a05:6512:3c8b:b0:4f8:67aa:4f03 with SMTP id
 h11-20020a0565123c8b00b004f867aa4f03mr9348992lfv.1.1691496376797; Tue, 08 Aug
 2023 05:06:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808095342.12637-7-vbabka@suse.cz> <20230808095342.12637-9-vbabka@suse.cz>
In-Reply-To: <20230808095342.12637-9-vbabka@suse.cz>
From: Pedro Falcato <pedro.falcato@gmail.com>
Date: Tue, 8 Aug 2023 13:06:04 +0100
Message-ID: <CAKbZUD1v1xXB-sPknsVhVVa812TG6YffoVU+3r59NY7r3t=fmQ@mail.gmail.com>
Subject: Re: [RFC v1 2/5] mm, slub: add opt-in slub_percpu_array
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 8, 2023 at 10:54=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> kmem_cache_setup_percpu_array() will allocate a per-cpu array for
> caching alloc/free objects of given size for the cache. The cache
> has to be created with SLAB_NO_MERGE flag.
>
> The array is filled by freeing. When empty for alloc or full for
> freeing, it's simply bypassed by the operation, there's currently no
> batch freeing/allocations.
>
> The locking is copied from the page allocator's pcplists, based on
> embedded spin locks. Interrupts are not disabled, only preemption (cpu
> migration on RT). Trylock is attempted to avoid deadlock due to
> an intnerrupt, trylock failure means the array is bypassed.
>
> Sysfs stat counters alloc_cpu_cache and free_cpu_cache count operations
> that used the percpu array.
>
> Bulk allocation bypasses the array, bulk freeing does not.
>
> kmem_cache_prefill_percpu_array() can be called to ensure the array on
> the current cpu to at least the given number of objects. However this is
> only opportunistic as there's no cpu pinning and the trylocks may always
> fail. Therefore allocations cannot rely on the array for success even
> after the prefill. But misses should be rare enough that e.g. GFP_ATOMIC
> allocations should be acceptable after the refill.
> The operation is currently not optimized.

As I asked on IRC, I'm curious about three questions:

1) How does this affect SLUB's anti-queueing ideas?

2) Since this is so similar to SLAB's caching, is it realistic to make
this opt-out instead?

3) What performance difference do you expect/see from benchmarks?

> More TODO/FIXMEs:
>
> - NUMA awareness - preferred node currently ignored, __GFP_THISNODE not
>   honored
> - slub_debug - will not work for allocations from the array. Normally in
>   SLUB implementation the slub_debug kills all fast paths, but that
>   could lead to depleting the reserves if we ignore the prefill and use
>   GFP_ATOMIC. Needs more thought.
> ---
>  include/linux/slab.h     |   4 +
>  include/linux/slub_def.h |  10 ++
>  mm/slub.c                | 210 ++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 223 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 848c7c82ad5a..f6c91cbc1544 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -196,6 +196,8 @@ struct kmem_cache *kmem_cache_create_usercopy(const c=
har *name,
>  void kmem_cache_destroy(struct kmem_cache *s);
>  int kmem_cache_shrink(struct kmem_cache *s);
>
> +int kmem_cache_setup_percpu_array(struct kmem_cache *s, unsigned int cou=
nt);
> +
>  /*
>   * Please use this macro to create slab caches. Simply specify the
>   * name of the structure and maybe some flags that are listed above.
> @@ -494,6 +496,8 @@ void kmem_cache_free(struct kmem_cache *s, void *objp=
);
>  void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p);
>  int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size=
, void **p);
>
> +int kmem_cache_prefill_percpu_array(struct kmem_cache *s, unsigned int c=
ount, gfp_t gfp);
> +
>  static __always_inline void kfree_bulk(size_t size, void **p)
>  {
>         kmem_cache_free_bulk(NULL, size, p);
> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> index deb90cf4bffb..c85434668419 100644
> --- a/include/linux/slub_def.h
> +++ b/include/linux/slub_def.h
> @@ -13,8 +13,10 @@
>  #include <linux/local_lock.h>
>
>  enum stat_item {
> +       ALLOC_PERCPU_CACHE,     /* Allocation from percpu array cache */
>         ALLOC_FASTPATH,         /* Allocation from cpu slab */
>         ALLOC_SLOWPATH,         /* Allocation by getting a new cpu slab *=
/
> +       FREE_PERCPU_CACHE,      /* Free to percpu array cache */
>         FREE_FASTPATH,          /* Free to cpu slab */
>         FREE_SLOWPATH,          /* Freeing not to cpu slab */
>         FREE_FROZEN,            /* Freeing to frozen slab */
> @@ -66,6 +68,13 @@ struct kmem_cache_cpu {
>  };
>  #endif /* CONFIG_SLUB_TINY */
>
> +struct slub_percpu_array {
> +       spinlock_t lock;

Since this is a percpu array, you probably want to avoid a lock here.
An idea would be to have some sort of bool accessing;
and then doing:

preempt_disable();
WRITE_ONCE(accessing, 1);

/* doing pcpu array stuff */
WRITE_ONCE(accessing, 0);
preempt_enable();

which would avoid the atomic in a fast path while still giving you
safety on IRQ paths. Although reclamation gets harder as you stop
being able to reclaim these pcpu arrays from other CPUs.

--=20
Pedro
