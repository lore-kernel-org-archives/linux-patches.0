Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCA52C99
	for <patches@lists.linux.dev>; Fri, 10 Dec 2021 18:09:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 75B361F3A1;
	Fri, 10 Dec 2021 18:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1639159797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tgLinzXkqLzA+3DcUUkLtOr6bYC4tRJ7C/1OYr17srg=;
	b=Y2Q/A8UqfaC4ZDZchBqtsx8BnUA8NkZsGU4aQzzcy3zsmYbEtlItx9I6M9AY7fKPfmQud8
	OLTNhYZzYb7jnFqLOgXtjQ+YcKeWnX0gDheb1HuF2CDX//7ZlVU0UGXS/5TygueDYrtrga
	hXAnxbp5+Vp2fQXDvHSQ2EjYIYxfiW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1639159797;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tgLinzXkqLzA+3DcUUkLtOr6bYC4tRJ7C/1OYr17srg=;
	b=Un09fp28D0zU/7soKqkNLxA3YZPd5mzWHCPWFH9vvcIAuiNhgtUPf7A4C1Vkfkc/5G/uuF
	RTu2Oq2hh4hrPCCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5173D13E4A;
	Fri, 10 Dec 2021 18:09:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 2yIfE/WXs2HsJAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 10 Dec 2021 18:09:57 +0000
Message-ID: <98f0b82f-6e3c-58f6-04cb-36268d40b0fe@suse.cz>
Date: Fri, 10 Dec 2021 19:09:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 24/33] mm/slob: Convert SLOB to use struct slab
Content-Language: en-US
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-25-vbabka@suse.cz> <20211210104435.GA632117@odroid>
 <254ce648-2b1c-edbd-1e1f-4bfc6bf6a195@suse.cz>
 <20211210152905.GA694381@odroid>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20211210152905.GA694381@odroid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/21 16:29, Hyeonggon Yoo wrote:
> On Fri, Dec 10, 2021 at 12:44:32PM +0100, Vlastimil Babka wrote:
>> On 12/10/21 11:44, Hyeonggon Yoo wrote:
>> > On Wed, Dec 01, 2021 at 07:15:01PM +0100, Vlastimil Babka wrote:
>> >> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> >> 
>> >> Use struct slab throughout the slob allocator.
>> >> 
>> >> [ vbabka@suse.cz: don't introduce wrappers for PageSlobFree in mm/slab.h just
>> >>   for the single callers being wrappers in mm/slob.c ]
>> >> 
>> >> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> >> ---
>> >>  mm/slob.c | 34 +++++++++++++++++-----------------
>> >>  1 file changed, 17 insertions(+), 17 deletions(-)
>> >> 
>> >> diff --git a/mm/slob.c b/mm/slob.c
>> >> index d2d15e7f191c..d3512bcc3141 100644
>> >> --- a/mm/slob.c
>> >> +++ b/mm/slob.c
>> > 
>> > ...
>> > 
>> >>  		/* Enough room on this page? */
>> >> @@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
>> >>  		b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
>> >>  		if (!b)
>> >>  			return NULL;
>> >> -		sp = virt_to_page(b);
>> >> -		__SetPageSlab(sp);
>> >> +		sp = virt_to_slab(b);
>> >> +		__SetPageSlab(slab_page(sp));
>> > 
>> > Hello Vlastimil.
>> > 
>> > I've tested this patch on my machine and it causes NULL pointer dereference.
>> > that's because virt_to_slab returns NULL if folio_test_slab is false.
>> > and __SetPageSlab is called with sp = NULL.
>> 
>> Oops, thanks for catching this.
>> 
>> > diff below fixed bug.
>> 
>> Changed it to use folio and will push an updated branch
>> slab-struct_slab-v3r2
>> 
>> Thanks!
> 
> Tested again on slab-struct_slab-v3r2 and everyting works fine!
> And the code overall looks good to me.
> 
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Thanks!

> And below is not about this patch,
> but what about something like this?
> 
> Because it's not necessary that page->_mapcount and
> slab->units have same offset, so we can remove
> (somewhat confusing) page_mapcount_reset function call.

Yeah this could be done as new patch on top of 21/33. I wouldn't squash it
there so that it remains just a split without functional change.

> I want to remove calling page_mapcount_reset also in
> SLAB, but I have no idea. (maybe we can do that if we remove
> SLAB colouring but that's going too far)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 90d7fceba470..dd0480149d38 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -50,8 +50,8 @@ struct slab {
>         struct list_head slab_list;
>         void * __unused_1;
>         void *freelist;         /* first free block */
> -       void * __unused_2;
> -       int units;
> +       long units;
> +       unsigned int __unused_2;
> 
>  #else
>  #error "Unexpected slab allocator configured"
> diff --git a/mm/slob.c b/mm/slob.c
> index 39b651b3e6e7..7b2d2c7d69cc 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -404,7 +404,6 @@ static void slob_free(void *block, int size)
>                         clear_slob_page_free(sp);
>                 spin_unlock_irqrestore(&slob_lock, flags);
>                 __ClearPageSlab(slab_page(sp));
> -               page_mapcount_reset(slab_page(sp));
>                 slob_free_pages(b, 0);
>                 return;
>         }
> 
>> 
>> > diff --git a/mm/slob.c b/mm/slob.c
>> > index d3512bcc3141..cf669f03440f 100644
>> > --- a/mm/slob.c
>> > +++ b/mm/slob.c
>> > @@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int a
>> > lign, int node,
>> >                 b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
>> >                 if (!b)
>> >                         return NULL;
>> > +               __SetPageSlab(virt_to_page(b));
>> >                 sp = virt_to_slab(b);
>> > -               __SetPageSlab(slab_page(sp));
>> > 
>> >                 spin_lock_irqsave(&slob_lock, flags);
>> >                 sp->units = SLOB_UNITS(PAGE_SIZE);
>> >  
>> >  Thanks,
>> >  Hyeonggon.
>> > 
>> >>  
>> >>  		spin_lock_irqsave(&slob_lock, flags);
>> >>  		sp->units = SLOB_UNITS(PAGE_SIZE);
>> >> @@ -381,7 +381,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
>> >>   */
>> >>  static void slob_free(void *block, int size)
>> >>  {
>> >> -	struct page *sp;
>> >> +	struct slab *sp;
>> >>  	slob_t *prev, *next, *b = (slob_t *)block;
>> >>  	slobidx_t units;
>> >>  	unsigned long flags;
>> >> @@ -391,7 +391,7 @@ static void slob_free(void *block, int size)
>> >>  		return;
>> >>  	BUG_ON(!size);
>> >>  
>> >> -	sp = virt_to_page(block);
>> >> +	sp = virt_to_slab(block);
>> >>  	units = SLOB_UNITS(size);
>> >>  
>> >>  	spin_lock_irqsave(&slob_lock, flags);
>> >> @@ -401,8 +401,8 @@ static void slob_free(void *block, int size)
>> >>  		if (slob_page_free(sp))
>> >>  			clear_slob_page_free(sp);
>> >>  		spin_unlock_irqrestore(&slob_lock, flags);
>> >> -		__ClearPageSlab(sp);
>> >> -		page_mapcount_reset(sp);
>> >> +		__ClearPageSlab(slab_page(sp));
>> >> +		page_mapcount_reset(slab_page(sp));
>> >>  		slob_free_pages(b, 0);
>> >>  		return;
>> >>  	}
>> >> -- 
>> >> 2.33.1
>> >> 
>> >> 
>> 

