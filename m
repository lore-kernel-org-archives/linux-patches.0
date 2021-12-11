Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D2029CA
	for <patches@lists.linux.dev>; Sat, 11 Dec 2021 11:55:34 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id o4so10740300pfp.13
        for <patches@lists.linux.dev>; Sat, 11 Dec 2021 03:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8z6MGF2AYvRVQGXmgU3xITNKiS7vT0SuNIf6r0/o/DM=;
        b=gs09pHLimqOFM/hMDrxpTqNwL9pJnp5cbZV5KV0Lc7TuVZhauKl+3MTRx/FOExFW03
         9Jv9DVaa4FeGtC4Jw4rkkOvhdw7jKdfDIulVIZwK8Cw0zMWEo9ksanweKmiofraPUGBx
         UeFFFn3r6hFkW72QUm9hGqmXjxsdxmx24uJC+0G1fhkCYluzeAWR/YmS0NCIG6PwdHhT
         BA6pOlZeDVXv5hHHLMHe1Ryce4fpljphiDyL92NN7CMnFMYedP3N22ZdfT0VF3hXSd1e
         0RIeX2NaJEYEZX/uKm+gieCuZNQgwH/HtBPvw1qkpe1OCJNeBdnqCRX9QvImg29axEaF
         XFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8z6MGF2AYvRVQGXmgU3xITNKiS7vT0SuNIf6r0/o/DM=;
        b=ETCN8DEe6YSPUzgwovnjrbkSP6ZUMhcFBNH0Ydtqfpmx2vZ/Vlxjryn1F1r2Cgcm5y
         QUI57ieyXx6S5vmcfvnYM7Ev2UfQ/JMR1bbInJruEuRQDhixzLVSUMyh2qKToZUCvj1m
         3w++nlSLdzTGf1h3i2NW5+kv8Gs6m48H2Q5LEAsPGYgebWxuwAYTJSYqciRnYsJa16bI
         VQCjN7VkKNJRFXmw3pdj5thwM4A/BZFLiZfpub1BSE3ZvoM1t5bIqyA21CUYLsOhZjd5
         Jn/cOjkq9iSPiBCJnYTfEV6/ItHJEFhAxCpvTP50fK2A4+GVi00USbWAx+RZmrMBtgU+
         ovOA==
X-Gm-Message-State: AOAM532TcMn7kMYuwiT/s5DBW9aVfZ+dGH/8CfxbcKAZ0TjODuaCEH4k
	vl++MO8Dl23iMGDhl17Jjdo=
X-Google-Smtp-Source: ABdhPJzjiYrfBVyGz+vCrLCBWUEstp0uBmpBIrYR+rNUQ+yyHtywtt3tlkD2T9Vc19DYmxe/0W8BCA==
X-Received: by 2002:a05:6a00:1385:b0:4ad:580d:8a8 with SMTP id t5-20020a056a00138500b004ad580d08a8mr23014733pfg.10.1639223733929;
        Sat, 11 Dec 2021 03:55:33 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id nl16sm1935442pjb.13.2021.12.11.03.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 03:55:33 -0800 (PST)
Date: Sat, 11 Dec 2021 11:55:27 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v2 31/33] mm/sl*b: Differentiate struct slab fields by
 sl*b implementations
Message-ID: <20211211115527.GA822127@odroid>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-32-vbabka@suse.cz>
 <20211210163757.GA717823@odroid>
 <f3f02e1e-88b2-a188-1679-9c6256d19c7a@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3f02e1e-88b2-a188-1679-9c6256d19c7a@suse.cz>

On Fri, Dec 10, 2021 at 07:26:11PM +0100, Vlastimil Babka wrote:
> On 12/10/21 17:37, Hyeonggon Yoo wrote:
> > On Wed, Dec 01, 2021 at 07:15:08PM +0100, Vlastimil Babka wrote:
> >> With a struct slab definition separate from struct page, we can go further and
> >> define only fields that the chosen sl*b implementation uses. This means
> >> everything between __page_flags and __page_refcount placeholders now depends on
> >> the chosen CONFIG_SL*B.
> > 
> > When I read this patch series first, I thought struct slab is allocated
> > separately from struct page.
> > 
> > But after reading it again, It uses same allocated space of struct page.
> 
> Yes. Allocating it elsewhere is something that can be discussed later. It's
> not a simple clear win - more memory used, more overhead, complicated code...
>

Right. That is a something that can be discussed,
But I don't think there will be much win.

> > So, the code should care about fields that page allocator cares when
> > freeing page. (->mapping, ->refcount, ->flags, ...)
> > 
> > And, we can change offset of fields between page->flags and page->refcount,
> > If we care about the value of page->mapping before freeing it.
> > 
> > Did I get it right?
> 
> Yeah. Also whatever aliases with compound_head must not have bit zero set as
> that means a tail page.
> 

Oh I was missing that. Thank you.

Hmm then in struct slab, page->compound_head and slab->list_head (or
slab->rcu_head) has same offset. And list_head / rcu_head both store pointers.

then it has a alignment requirement. (address saved in list_head/rcu_head
should be multiple of 2)

Anyway, it was required long time before this patch,
so it is not a problem for this patch.

> >> Some fields exist in all implementations (slab_list)
> >> but can be part of a union in some, so it's simpler to repeat them than
> >> complicate the definition with ifdefs even more.
> > 
> > Before this patch I always ran preprocessor in my brain.
> > now it's MUCH easier to understand than before!
> > 
> >> 
> >> The patch doesn't change physical offsets of the fields, although it could be
> >> done later - for example it's now clear that tighter packing in SLOB could be
> >> possible.
> >>
> > 
> > Is there a benefit if we pack SLOB's struct slab tighter?
> 
> I don't see any immediate benefit, except avoiding the page->mapping alias
> as you suggested.
> 
> > ...
> > 
> >>  #ifdef CONFIG_MEMCG
> >>  	unsigned long memcg_data;
> >> @@ -47,7 +69,9 @@ struct slab {
> >>  	static_assert(offsetof(struct page, pg) == offsetof(struct slab, sl))
> >>  SLAB_MATCH(flags, __page_flags);
> >>  SLAB_MATCH(compound_head, slab_list);	/* Ensure bit 0 is clear */
> >> +#ifndef CONFIG_SLOB
> >>  SLAB_MATCH(rcu_head, rcu_head);
> > 
> > Because SLUB and SLAB sets slab->slab_cache = NULL (to set page->mapping = NULL),
> 
> Hm, now that you mention it, maybe it would be better to do a
> "folio->mapping = NULL" instead as we now have a more clearer view where we
> operate on struct slab, and where we transition between that and a plain
> folio. 

Oh, folio->mapping = NULL seems more intuitive.

And we can reorder fields of struct slab more flexibly with
folio->mapping = NULL because we have no reason to make page->mapping
and slab->slab_cache to have same offset.

So it should be done in separate patch for SLUB/SLAB.
Do you mind If I send a patch for this after some testing?

> This is IMHO part of preparing the folio for freeing, not a struct
> slab cleanup as struct slab doesn't need this cleanup.

I agree that. it's needed for folio, not for struct slab.

> > What about adding this?:
> > 
> > SLAB_MATCH(mapping, slab_cache);
> > 
> > there was SLAB_MATCH(slab_cache, slab_cache) but removed.
> 
> With the change suggested above, it wouldn't be needed as a safety check
> anymore.
> 

Okay.

> >> +#endif
> >>  SLAB_MATCH(_refcount, __page_refcount);
> >>  #ifdef CONFIG_MEMCG
> >>  SLAB_MATCH(memcg_data, memcg_data);
> > 
> > I couldn't find any functional problem on this patch.
> > but it seems there's some style issues.
> > 
> > Below is what checkpatch.pl complains.
> > it's better to fix them!
> 
> Not all checkpatch suggestions are correct and have to be followed, but I'll
> check what I missed. Thanks.
>

You're welcome.
They are just a typo in changelog and white space warnings.

So now, exept few style issues, I can't find any problem in this patch.
And this patch gives us much better view of struct slab.

Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Thanks,
Hyeonggon.

> > WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
> > #7: 
> > With a struct slab definition separate from struct page, we can go further and
> > 
> > WARNING: Possible repeated word: 'and'
> > #19: 
> > implementation. Before this patch virt_to_cache() and and cache_from_obj() was
> > 
> > WARNING: space prohibited between function name and open parenthesis '('
> > #49: FILE: mm/kfence/core.c:432:
> > +#elif defined (CONFIG_SLAB)
> > 
> > ERROR: "foo * bar" should be "foo *bar"
> > #73: FILE: mm/slab.h:20:
> > +void * s_mem;/* first object */
> > 
> > ERROR: "foo * bar" should be "foo *bar"
> > #111: FILE: mm/slab.h:53:
> > +void * __unused_1;
> > 
> > ERROR: "foo * bar" should be "foo *bar"
> > #113: FILE: mm/slab.h:55:
> > +void * __unused_2;
> > 
> > ---
> > Thanks,
> > Hyeonggon.
> 
