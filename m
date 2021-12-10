Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F64B2C99
	for <patches@lists.linux.dev>; Fri, 10 Dec 2021 16:38:05 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id 8so8943626pfo.4
        for <patches@lists.linux.dev>; Fri, 10 Dec 2021 08:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FOdVuXmZVxHQka5/xLY4uUXT8XTZfcWZO4u7CsQGj5o=;
        b=dZIXcowvv0qSO1hXNZeXT9W1CWbQ5AVqCk3GxT/OfpjJCaI7CVl35qDc1Mon9EY75+
         uQp11rwxRejz4RgDkdSJMXQPa9ZyB3DWwwjb8TPJt5Wq6p+Xdcly9oNZvH8qryfJbKam
         SOACfopLRGwRdkJYJKHUXOjUuwA7MPMfbwaMW2HAoAqo0cgXWKPp2p6dSm4PpnxYmdLu
         I+RB+RoJglOfVAqq1XZwlDzcQRo5ePiXL3AgEUGS8PxUutS18RzvV8WG5R26WNty0s0J
         /hklcGLu8QKg72ph0UoUoYJPJAX7DYjj1nTFvOiHrc4p880ztUYchV1NJCiXuRfnjhSJ
         EIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FOdVuXmZVxHQka5/xLY4uUXT8XTZfcWZO4u7CsQGj5o=;
        b=ykl6M16aDAZns7LrgL2afelAo3oN2bL6uNrOteC/xlYVhmOArkKeyCvMvK7uQ+B9i/
         bDnVn4kf4ucZSIfq7fdXJuP4ko8VZ1Nr67d33ttrZLYkaGpSvXKzEwHqgjvmdB6Eqliy
         ykBysukfclD3bF6WYrCoq1RtfJ2GEgWB7fHw5Y45VJXY7jV1N5cqtpIPpvTE5A7rz1ix
         PbgUzFJzz+7UC7A+pv/C8br5UuWygYrXDEEbVHbjl3/ueyFSxqd2Vx7nMvrFp5gsvjzU
         x15H2VCmy92EMmkMAdbK0MRNN9ReVxy3JB1z79NcKQui1/UzJZK1ItxpU/bOAAo/NhIz
         vncg==
X-Gm-Message-State: AOAM5333yo31O4e24ofDH461I/ug9U/im055bogFUqqBejsQkR+4/B/x
	1lPi3Qa5qjHVLJze0g4xdJA=
X-Google-Smtp-Source: ABdhPJxNbR43SvcmGgeplvrXDCfQcOmku3ubBQMewPgz1CqLQNt9FMGCHIgUP+3Yfh8ATce7L5Giew==
X-Received: by 2002:a63:5c0a:: with SMTP id q10mr39625623pgb.213.1639154284892;
        Fri, 10 Dec 2021 08:38:04 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id f4sm3709333pfg.34.2021.12.10.08.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:38:04 -0800 (PST)
Date: Fri, 10 Dec 2021 16:37:57 +0000
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
Message-ID: <20211210163757.GA717823@odroid>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-32-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-32-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:15:08PM +0100, Vlastimil Babka wrote:
> With a struct slab definition separate from struct page, we can go further and
> define only fields that the chosen sl*b implementation uses. This means
> everything between __page_flags and __page_refcount placeholders now depends on
> the chosen CONFIG_SL*B.

When I read this patch series first, I thought struct slab is allocated
separately from struct page.

But after reading it again, It uses same allocated space of struct page.

So, the code should care about fields that page allocator cares when
freeing page. (->mapping, ->refcount, ->flags, ...)

And, we can change offset of fields between page->flags and page->refcount,
If we care about the value of page->mapping before freeing it.

Did I get it right?

> Some fields exist in all implementations (slab_list)
> but can be part of a union in some, so it's simpler to repeat them than
> complicate the definition with ifdefs even more.

Before this patch I always ran preprocessor in my brain.
now it's MUCH easier to understand than before!

> 
> The patch doesn't change physical offsets of the fields, although it could be
> done later - for example it's now clear that tighter packing in SLOB could be
> possible.
>

Is there a benefit if we pack SLOB's struct slab tighter?

...

>  #ifdef CONFIG_MEMCG
>  	unsigned long memcg_data;
> @@ -47,7 +69,9 @@ struct slab {
>  	static_assert(offsetof(struct page, pg) == offsetof(struct slab, sl))
>  SLAB_MATCH(flags, __page_flags);
>  SLAB_MATCH(compound_head, slab_list);	/* Ensure bit 0 is clear */
> +#ifndef CONFIG_SLOB
>  SLAB_MATCH(rcu_head, rcu_head);

Because SLUB and SLAB sets slab->slab_cache = NULL (to set page->mapping = NULL),
What about adding this?:

SLAB_MATCH(mapping, slab_cache);

there was SLAB_MATCH(slab_cache, slab_cache) but removed.

> +#endif
>  SLAB_MATCH(_refcount, __page_refcount);
>  #ifdef CONFIG_MEMCG
>  SLAB_MATCH(memcg_data, memcg_data);

I couldn't find any functional problem on this patch.
but it seems there's some style issues.

Below is what checkpatch.pl complains.
it's better to fix them!

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#7: 
With a struct slab definition separate from struct page, we can go further and

WARNING: Possible repeated word: 'and'
#19: 
implementation. Before this patch virt_to_cache() and and cache_from_obj() was

WARNING: space prohibited between function name and open parenthesis '('
#49: FILE: mm/kfence/core.c:432:
+#elif defined (CONFIG_SLAB)

ERROR: "foo * bar" should be "foo *bar"
#73: FILE: mm/slab.h:20:
+void * s_mem;/* first object */

ERROR: "foo * bar" should be "foo *bar"
#111: FILE: mm/slab.h:53:
+void * __unused_1;

ERROR: "foo * bar" should be "foo *bar"
#113: FILE: mm/slab.h:55:
+void * __unused_2;

---
Thanks,
Hyeonggon.
