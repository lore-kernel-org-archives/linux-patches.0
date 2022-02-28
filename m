Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DDE5398
	for <patches@lists.linux.dev>; Mon, 28 Feb 2022 10:05:36 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id z11so1866887pla.7
        for <patches@lists.linux.dev>; Mon, 28 Feb 2022 02:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Huy3B+KqiirbicrjfG7QYtU6RXoy6J2yqbxx/jFato=;
        b=WylLk6dQmc0g0Unwt29ybuguNKQEqAwvWBam7P+6AqCeRU+W2AkIudvpHAoJ8XIHGG
         Z33F9tb12L2CnUX7jvYTCZe0x7Rb3VcpPOy0C+fb3Kvw2B3FUy3r/eKpYjHWd6+mM9ZO
         K8TIjJBgfik5PY5krkpdxKe3L1/X5UaT+Dq0qU8mEUlL5Eu0jiwcDzOlaoXsM5dgEGzX
         WaCNkSM+ikEtB1TVgMYwtTnefqT/PdbsoUmfOdoxePIzivyKXVjuf7M+did2r6Inortn
         xbCDn1PnhS1ZM5Hn1tMH5u3SW3pBFHSWTe/L6+XssCVZlcc6o+3KrQ3cy53noI4Mkrw3
         +n2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Huy3B+KqiirbicrjfG7QYtU6RXoy6J2yqbxx/jFato=;
        b=0BF09pY4ZFFXxZKccDjTaqonFDk3sjm73HD+cBthf6tN4TB8fNemEJTKR9Nhbh4zwP
         Qnnqn7DqstPIxTCjN3awTiTeNmpFEBfd4uCa0xOVSe8EeiCViFqLBhf/JLsYdFuOgC7q
         jEAEvnCqw08kwQy2bxNsIZp5UJKI/iGj5/yZrsjHOGlrl3a8gSi9MwRD2y8aUqufhQFP
         owaeH5icEMUbhIm8vegiqEa8FEAkVXr6MKn9vPH+ZMr3mw1fC6qtX+KflyA88dRUqVK3
         I6Fw+aT37jDrVxtd6kr9fUU6mV8LpERKVJfQjE4C9JfhVfSSfK3mHkzC8YqWV+3DzosY
         CQvw==
X-Gm-Message-State: AOAM531LqZGcyJ2k1Fv8ChW9vIcUfkNyrrdV3i/vwW5dC/fn9IOqEIxQ
	Eou0s7Rn6F9ur6AGylybguMhATs23ZRuBQ==
X-Google-Smtp-Source: ABdhPJzfbEi/1pPSs2ygQ2goCH/E3mll8ovEe4Pc2xn5q2fbdVIGXXSsTOY+NXeUyJURrwMvlJBTxA==
X-Received: by 2002:a17:90a:5a05:b0:1bc:920e:f340 with SMTP id b5-20020a17090a5a0500b001bc920ef340mr15970006pjd.36.1646042736146;
        Mon, 28 Feb 2022 02:05:36 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id nv14-20020a17090b1b4e00b001bd36b55298sm4409181pjb.39.2022.02.28.02.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 02:05:35 -0800 (PST)
Date: Mon, 28 Feb 2022 10:05:28 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Marco Elver <elver@google.com>
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
Subject: Re: [PATCH] lib/stackdepot: Use page allocator if both slab and
 memblock is unavailable
Message-ID: <YhyeaP8lrzKgKm5A@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220225180318.20594-3-vbabka@suse.cz>
 <YhrrM7NTYXG5JluY@ip-172-31-19-208.ap-northeast-1.compute.internal>
 <CANpmjNOyVTQZroOEVF_ZLASCtQ=SiC12WGWEwOib3vDk3sCbtw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOyVTQZroOEVF_ZLASCtQ=SiC12WGWEwOib3vDk3sCbtw@mail.gmail.com>

On Mon, Feb 28, 2022 at 08:00:00AM +0100, Marco Elver wrote:
> On Sun, 27 Feb 2022 at 04:08, Hyeonggon Yoo <42.hyeyoo@gmail.com> wrote:
> >
> > After commit 2dba5eb1c73b ("lib/stackdepot: allow optional init and
> > stack_table allocation by kvmalloc()"), stack_depot_init() is called
> > later if CONFIG_STACKDEPOT_ALWAYS_INIT=n to remove unnecessary memory
> > usage. It allocates stack_table using memblock_alloc() or kvmalloc()
> > depending on availability of slab allocator.
> >
> > But when stack_depot_init() is called while creating boot slab caches,
> > both slab allocator and memblock is not available. So kernel crashes.
> > Allocate stack_table from page allocator when both slab allocator and
> > memblock is unavailable.
> 
> This is odd - who is calling stack_depot_init() while neither slab nor
> memblock are available? 

It's not merged yet - but Oliver's patch (2/5) in his series [1] does:
If user is debugging cache, it calls stack_depot_init() when creating
cache.

> @@ -4221,6 +4220,9 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
>  	s->remote_node_defrag_ratio = 1000;
>  #endif
> 
> +	if (s->flags & SLAB_STORE_USER && IS_ENABLED(CONFIG_STACKDEPOT))
> +		stack_depot_init();
> +

Oliver's patch series enables stack depot when arch supports stacktrace,
to store slab objects' stack traces. (as slub debugging feature.)

Because slub debugging is turned on by default, the commit 2dba5eb1c73b
("lib/stackdepot: allow optional init and stack_table allocation by
kvmalloc()") made stack_depot_init() can be called later.

With Oliver's patch applied, stack_depot_init() can be called in
contexts below:

  1) only memblock available (for kasan)
  2) only buddy available, vmalloc/memblock unavailable (for boot caches)
  3) buddy/slab available, vmalloc/memblock unavailable (vmap_area cache)
  4) buddy/slab/vmalloc available, memblock unavailable (other caches)

SLUB supports enabling debugging for specific cache by passing
slub_debug boot parameter. As slab caches can be created in
various context, stack_depot_init() should consider all contexts above.

Writing this, I realized my patch does not handle case 3).. I'll send v3.

[1] https://lore.kernel.org/linux-mm/YhoakP7Kih%2FYUgiN@ip-172-31-19-208.ap-northeast-1.compute.internal/T/#t
[2] https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slub-stackdepot-v1

> Do you have a stacktrace?

Yeah, here:

You can reproduce this on vbabka's slab-stackdepot-v1 branch [2] with
slub_debug=U, and CONFIG_STACKDEPOT_ALWAYS_INIT=n

[    0.000000] Stack Depot allocating hash table with memblock_alloc
[    0.000000] Unable to handle kernel paging request at virtual address ffff000097400000
[    0.000000] Mem abort info:
[    0.000000]   ESR = 0x96000047
[    0.000000]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.000000]   SET = 0, FnV = 0
[    0.000000]   EA = 0, S1PTW = 0
[    0.000000]   FSC = 0x07: level 3 translation fault
[    0.000000] Data abort info:
[    0.000000]   ISV = 0, ISS = 0x00000047
[    0.000000]   CM = 0, WnR = 1
[    0.000000] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000041719000
[    0.000000] [ffff000097400000] pgd=18000000dcff8003, p4d=18000000dcff8003, pud=18000000dcbfe003, pmd=18000000dcb43003, pte=00680000d7400706
[    0.000000] Internal error: Oops: 96000047 [#1] PREEMPT SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.17.0-rc1-11918-gbf5d03166d75 #51
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : __memset+0x16c/0x188
[    0.000000] lr : memblock_alloc_try_nid+0xcc/0xe4
[    0.000000] sp : ffff800009a33cd0
[    0.000000] x29: ffff800009a33cd0 x28: 0000000041720018 x27: ffff800009362640
[    0.000000] x26: ffff800009362640 x25: 0000000000000000 x24: 0000000000000000
[    0.000000] x23: 0000000000002000 x22: ffff80000932bb50 x21: 00000000ffffffff
[    0.000000] x20: ffff000097400000 x19: 0000000000800000 x18: ffffffffffffffff
[    0.000000] x17: 373578302f383278 x16: 302b657461657263 x15: 0000001000000000
[    0.000000] x14: 0000000000000360 x13: 0000000000009f8c x12: 00000000dcb0c070
[    0.000000] x11: 0000001000000000 x10: 00000000004ea000 x9 : 0000000000000000
[    0.000000] x8 : ffff000097400000 x7 : 0000000000000000 x6 : 000000000000003f
[    0.000000] x5 : 0000000000000040 x4 : 0000000000000000 x3 : 0000000000000004
[    0.000000] x2 : 00000000007fffc0 x1 : 0000000000000000 x0 : ffff000097400000
[    0.000000] Call trace:
[    0.000000]  __memset+0x16c/0x188
[    0.000000]  stack_depot_init+0xc8/0x100
[    0.000000]  __kmem_cache_create+0x454/0x570
[    0.000000]  create_boot_cache+0xa0/0xe0
[    0.000000]  kmem_cache_init+0xf8/0x204
[    0.000000]  start_kernel+0x3ec/0x668
[    0.000000]  __primary_switched+0xc0/0xc8
[    0.000000] Code: 91010108 54ffff4a 8b040108 cb050042 (d50b7428)
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

Thanks!

> > Limit size of stack_table when using page allocator because vmalloc()
> > is also unavailable in kmem_cache_init(). it must not be larger than
> > (PAGE_SIZE << (MAX_ORDER - 1)).
> >
> > This patch was tested on both CONFIG_STACKDEPOT_ALWAYS_INIT=y and n.
> >
> > Fixes: 2dba5eb1c73b ("lib/stackdepot: allow optional init and stack_table allocation by kvmalloc()")
> > Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > ---
> >  lib/stackdepot.c | 28 +++++++++++++++++++++-------
> >  1 file changed, 21 insertions(+), 7 deletions(-)
> >
> > diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> > index bf5ba9af0500..606f80ae2bf7 100644
> > --- a/lib/stackdepot.c
> > +++ b/lib/stackdepot.c
> > @@ -73,6 +73,14 @@ static int next_slab_inited;
> >  static size_t depot_offset;
> >  static DEFINE_RAW_SPINLOCK(depot_lock);
> >
> > +static unsigned int stack_hash_size = (1 << CONFIG_STACK_HASH_ORDER);
> > +static inline unsigned int stack_hash_mask(void)
> > +{
> > +       return stack_hash_size - 1;
> > +}
> > +
> > +#define STACK_HASH_SEED 0x9747b28c
> > +
> >  static bool init_stack_slab(void **prealloc)
> >  {
> >         if (!*prealloc)
> > @@ -142,10 +150,6 @@ depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
> >         return stack;
> >  }
> >
> > -#define STACK_HASH_SIZE (1L << CONFIG_STACK_HASH_ORDER)
> > -#define STACK_HASH_MASK (STACK_HASH_SIZE - 1)
> > -#define STACK_HASH_SEED 0x9747b28c
> > -
> >  static bool stack_depot_disable;
> >  static struct stack_record **stack_table;
> >
> > @@ -172,18 +176,28 @@ __ref int stack_depot_init(void)
> >
> >         mutex_lock(&stack_depot_init_mutex);
> >         if (!stack_depot_disable && !stack_table) {
> > -               size_t size = (STACK_HASH_SIZE * sizeof(struct stack_record *));
> > +               size_t size = (stack_hash_size * sizeof(struct stack_record *));
> >                 int i;
> >
> >                 if (slab_is_available()) {
> >                         pr_info("Stack Depot allocating hash table with kvmalloc\n");
> >                         stack_table = kvmalloc(size, GFP_KERNEL);
> > +               } else if (totalram_pages() > 0) {
> > +                       /* Reduce size because vmalloc may be unavailable */
> > +                       size = min(size, PAGE_SIZE << (MAX_ORDER - 1));
> > +                       stack_hash_size = size / sizeof(struct stack_record *);
> > +
> > +                       pr_info("Stack Depot allocating hash table with __get_free_pages\n");
> > +                       stack_table = (struct stack_record **)
> > +                                     __get_free_pages(GFP_KERNEL, get_order(size));
> >                 } else {
> >                         pr_info("Stack Depot allocating hash table with memblock_alloc\n");
> >                         stack_table = memblock_alloc(size, SMP_CACHE_BYTES);
> >                 }
> > +
> >                 if (stack_table) {
> > -                       for (i = 0; i < STACK_HASH_SIZE;  i++)
> > +                       pr_info("Stack Depot hash table size=%u\n", stack_hash_size);
> > +                       for (i = 0; i < stack_hash_size;  i++)
> >                                 stack_table[i] = NULL;
> >                 } else {
> >                         pr_err("Stack Depot hash table allocation failed, disabling\n");
> > @@ -363,7 +377,7 @@ depot_stack_handle_t __stack_depot_save(unsigned long *entries,
> >                 goto fast_exit;
> >
> >         hash = hash_stack(entries, nr_entries);
> > -       bucket = &stack_table[hash & STACK_HASH_MASK];
> > +       bucket = &stack_table[hash & stack_hash_mask()];
> >
> >         /*
> >          * Fast path: look the stack trace up without locking.
> > --
> > 2.33.1

-- 
Thank you, You are awesome!
Hyeonggon :-)
