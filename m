Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511337A
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 02:12:51 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id d17so12852620pfl.0
        for <patches@lists.linux.dev>; Mon, 28 Feb 2022 18:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VqwKZSmUCQfMvGMcajV4YWfTIzz3lVqIZVMkUskoDd0=;
        b=L2RIdggPBz3kNS4Fh9HORTyRoN6vqkFQOJZikLYgVJtQGutU4yZx/SS1mYey8fHQjf
         Q7RYQyga0OpDiVARh8K+/L/mw61bs6pI8sxDCuyUGbinePN8+J9ktmmDR+5I4HfCZLTc
         4njttVqgCL3dm5iAWIbmhHV05thRj2dPa33d5kBYbToes7azrNyGnDAQ4nw1PhK09v2M
         xN5fxPZ2XkF4IL1aYB9KZvPE3ZO4WhlRWAKalK76KyjdJBQfIxBUAW8jAFwcFShyGjBp
         FWuVPf4fhQPIS9yGPM8YMOib6tYlcAJxgz6w3hO7DYe3IiStuboYpfC6FLNOsd7YwmJp
         Oo8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VqwKZSmUCQfMvGMcajV4YWfTIzz3lVqIZVMkUskoDd0=;
        b=CpytzXeZuUajbgv30ThfGIIuHHcG6jKFdcl+EIFfUhOI5wSZ7bHQPkNlljofMl77Nr
         2WUNHl8n+58bCVFsN7DWb3jYLcgHlrPQiclMUL+C9S4FEROyVbgZaHdlCuMvvydP9S2H
         yOjZfw6HoDfdRteTjaJoGPG73WqG2bL6xGIcqxvwhjPCmPlWGPj/cCBrl0MfW9ceaGrT
         L5gnv7SoiDLkHL/JMxx15FmWdl4b0DSbUBl2iE+iy1D0BbwaZcFTFBTSlzEehH+2H2NS
         g35vXd/M8af327fQB2eBYn4AbaRTlYtkx4BlOcQLhSFfzyrORwPgTxAmshJhg6Xde0u7
         iUSQ==
X-Gm-Message-State: AOAM53083RPYrXbHkTWky+9Y/m6mpHWr9FsqARli0qreXM5LzceDcdJl
	eeX2amD7jX2JOZoIyBC+Di0=
X-Google-Smtp-Source: ABdhPJxyCa36UIZKtFnjuddlsFNOGwSj5AlDJ2lllpJIIfwD3NMbWOqLhVwU8DTnhh27GWymwQuXnQ==
X-Received: by 2002:a63:5110:0:b0:374:2312:1860 with SMTP id f16-20020a635110000000b0037423121860mr19736943pgb.146.1646100770710;
        Mon, 28 Feb 2022 18:12:50 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id 17-20020a056a00071100b004f0f941d1e8sm14108030pfl.24.2022.02.28.18.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 18:12:50 -0800 (PST)
Date: Tue, 1 Mar 2022 02:12:43 +0000
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
Subject: Re: [PATCH] mm/slub: initialize stack depot in boot process
Message-ID: <Yh2BGxI42Ga0Y8Lv@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <CANpmjNOOhuoU7T4UqHbzkRAvM+b-gvt+Qtx41va=9ixGgUSWaQ@mail.gmail.com>
 <Yhzlw0GGBeuCALJp@ip-172-31-19-208.ap-northeast-1.compute.internal>
 <Yhz4IQUQr7ln+G86@elver.google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yhz4IQUQr7ln+G86@elver.google.com>

On Mon, Feb 28, 2022 at 05:28:17PM +0100, Marco Elver wrote:
> On Mon, Feb 28, 2022 at 03:09PM +0000, Hyeonggon Yoo wrote:
> > commit ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in
> > objects") initializes stack depot while creating cache if SLAB_STORE_USER
> > flag is set.
> > 
> > This can make kernel crash because a cache can be created in various
> > contexts. For example if user sets slub_debug=U, kernel crashes
> > because create_boot_cache() calls stack_depot_init(), which tries to
> > allocate hash table using memblock_alloc() if slab is not available.
> > But memblock is also not available at that time.
> > 
> > This patch solves the problem by initializing stack depot early
> > in boot process if SLAB_STORE_USER debug flag is set globally
> > or the flag is set to at least one cache.
> > 
> > [ elver@google.com: initialize stack depot depending on slub_debug
> >   parameter instead of allowing stack_depot_init() can be called
> >   in kmem_cache_init() for simplicity. ]
> > 
> > Link: https://lkml.org/lkml/2022/2/28/238
> 
> This would be a better permalink:
> https://lore.kernel.org/all/YhyeaP8lrzKgKm5A@ip-172-31-19-208.ap-northeast-1.compute.internal/
>

Agreed.

> > Fixes: ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in objects")
> 
> This commit does not exist in -next.
> 

It did not land -next yet.

> I assume you intend that "lib/stackdepot: Use page allocator if both
> slab and memblock is unavailable" should be dropped now.
>

I did not intend that, but I agree the patch you mentioned
should be dropped now.

> > Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > ---
> >  include/linux/slab.h |  1 +
> >  init/main.c          |  1 +
> >  mm/slab.c            |  4 ++++
> >  mm/slob.c            |  4 ++++
> >  mm/slub.c            | 28 +++++++++++++++++++++++++---
> >  5 files changed, 35 insertions(+), 3 deletions(-)
> [...]
> >  
> > +/* Initialize stack depot if needed */
> > +void __init kmem_cache_init_early(void)
> > +{
> > +#ifdef CONFIG_STACKDEPOT
> > +	slab_flags_t block_flags;
> > +	char *next_block;
> > +	char *slab_list;
> > +
> > +	if (slub_debug & SLAB_STORE_USER)
> > +		goto init_stack_depot;
> > +
> > +	next_block = slub_debug_string;
> > +	while (next_block) {
> > +		next_block = parse_slub_debug_flags(next_block, &block_flags, &slab_list, false);
> > +		if (block_flags & SLAB_STORE_USER)
> > +			goto init_stack_depot;
> > +	}
> > +
> > +	return;
> > +
> > +init_stack_depot:
> > +	stack_depot_init();
> > +#endif
> > +}
> 
> You can simplify this function to avoid the goto:
> 
> 	/* Initialize stack depot if needed */
> 	void __init kmem_cache_init_early(void)
> 	{
> 	#ifdef CONFIG_STACKDEPOT
> 		slab_flags_t flags = slub_debug;
> 		char *next_block = slub_debug_string;
> 		char *slab_list;
> 	
> 		for (;;) {
> 			if (flags & SLAB_STORE_USER) {
> 				stack_depot_init();
> 				break;
> 			}
> 			if (!next_block)
> 				break;
> 			next_block = parse_slub_debug_flags(next_block, &flags, &slab_list, false);
> 		}
> 	#endif
> 	}
> 
> ^^ with this version, it'd also be much easier and less confusing to add
> other initialization logic unrelated to stackdepot later after the loop
> (should it ever be required).

Thank you for nice suggestion, but I want to try it in
setup_slub_debug() as Vlastimil said!

Thanks.

-- 
Thank you, You are awesome!
Hyeonggon :-)
