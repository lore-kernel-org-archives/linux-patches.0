Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A41829CA
	for <patches@lists.linux.dev>; Sat, 11 Dec 2021 10:54:16 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id q17so7902544plr.11
        for <patches@lists.linux.dev>; Sat, 11 Dec 2021 02:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=znmVQsCpemc29ojVlDjznsMT0hvQyEeu9H2sNGqGNOw=;
        b=YPRyDPyWB53YNmmg8/bqJPWaoNcyFJEH1p8zcw+T5qv3Yl82XQiTtnBpneHx8W3T9h
         Ga1JOwu1k0MWTjig+Yxw19+rvFxSWJGXZYq9rsL2d58OrsIDwbV4GYCYiaqKO/7CjiIT
         +aYmRQLyU1qfIrn+CFhPgok+FuN24nHhKnb036FIeudjGkirxRIa81DXar7OKyGiK63m
         U1U0sZwcnD0JNU2JKKCI8k/vAfKR2vxtlGCPIp+5ksn4i2sDNsY/XKkW6KJ9CHgx/R4h
         34tuSDr06KAwhw8j/kiKPnX8b0hJ7FRP4rYD5b9eg+KlRpB8Upwm5GvheLkZIybJ/zzg
         gAfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=znmVQsCpemc29ojVlDjznsMT0hvQyEeu9H2sNGqGNOw=;
        b=50wmt3W2dAbI7EYl47ZxF3ycfHJRzayyhl8W6cfnllmMde3czYKSvJ0kIBydG+OeXk
         bF3VoOv4cE5kOa8IPQVEtTQihbkDs+h4Df/1leENEUf8ZaAJGO5LyplPIK9Kb20xWExO
         1orl1z7ti/b1NARZiwvyxu8AhdtzoBM9z3FAoz9Zv+xPoGMB/VfWwk4Dz1AAeArx4c57
         Be2Q3aQ26MrCmKe2vRlHuvjzDEG48d/HZV9qau9Q+OK2sLYeEaxIti7s+9clBDyW9l1K
         hm1uepkXo9riqegXARoasCDG+oEVrVUemfwW+EAIF9BknSlh6vMqlv/YMh/JtpOZpECP
         KGSg==
X-Gm-Message-State: AOAM533S5UivgszHq7Bex/ZozlJwa/tEojgQ9rKxbscXcgQV83ghtqVa
	HGmRCDHfNSyXo3Hg1OBbjlc=
X-Google-Smtp-Source: ABdhPJyGgGTvVLAm+HCqaZj1eU+WoqDxulTrlmhuKzz9DLw8/bPy1GRlDSaUSXtKLXfW00hlPQN0gw==
X-Received: by 2002:a17:902:dac9:b0:141:e931:3b49 with SMTP id q9-20020a170902dac900b00141e9313b49mr80888286plx.45.1639220055687;
        Sat, 11 Dec 2021 02:54:15 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id y12sm5853389pfe.140.2021.12.11.02.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 02:54:15 -0800 (PST)
Date: Sat, 11 Dec 2021 10:54:10 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 24/33] mm/slob: Convert SLOB to use struct slab
Message-ID: <20211211105410.GA820243@odroid>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-25-vbabka@suse.cz>
 <20211210104435.GA632117@odroid>
 <254ce648-2b1c-edbd-1e1f-4bfc6bf6a195@suse.cz>
 <20211210152905.GA694381@odroid>
 <98f0b82f-6e3c-58f6-04cb-36268d40b0fe@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98f0b82f-6e3c-58f6-04cb-36268d40b0fe@suse.cz>

On Fri, Dec 10, 2021 at 07:09:56PM +0100, Vlastimil Babka wrote:
> On 12/10/21 16:29, Hyeonggon Yoo wrote:
> > On Fri, Dec 10, 2021 at 12:44:32PM +0100, Vlastimil Babka wrote:
> >> On 12/10/21 11:44, Hyeonggon Yoo wrote:
> >> > On Wed, Dec 01, 2021 at 07:15:01PM +0100, Vlastimil Babka wrote:
> >> >> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> >> >> 
> >> >> Use struct slab throughout the slob allocator.
> >> >> 
> >> >> [ vbabka@suse.cz: don't introduce wrappers for PageSlobFree in mm/slab.h just
> >> >>   for the single callers being wrappers in mm/slob.c ]
> >> >> 
> >> >> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> >> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> >> ---
> >> >>  mm/slob.c | 34 +++++++++++++++++-----------------
> >> >>  1 file changed, 17 insertions(+), 17 deletions(-)
> >> >> 
> >> >> diff --git a/mm/slob.c b/mm/slob.c
> >> >> index d2d15e7f191c..d3512bcc3141 100644
> >> >> --- a/mm/slob.c
> >> >> +++ b/mm/slob.c
> >> > 
> >> > ...
> >> > 
> >> >>  		/* Enough room on this page? */
> >> >> @@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
> >> >>  		b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
> >> >>  		if (!b)
> >> >>  			return NULL;
> >> >> -		sp = virt_to_page(b);
> >> >> -		__SetPageSlab(sp);
> >> >> +		sp = virt_to_slab(b);
> >> >> +		__SetPageSlab(slab_page(sp));
> >> > 
> >> > Hello Vlastimil.
> >> > 
> >> > I've tested this patch on my machine and it causes NULL pointer dereference.
> >> > that's because virt_to_slab returns NULL if folio_test_slab is false.
> >> > and __SetPageSlab is called with sp = NULL.
> >> 
> >> Oops, thanks for catching this.
> >> 
> >> > diff below fixed bug.
> >> 
> >> Changed it to use folio and will push an updated branch
> >> slab-struct_slab-v3r2
> >> 
> >> Thanks!
> > 
> > Tested again on slab-struct_slab-v3r2 and everyting works fine!
> > And the code overall looks good to me.
> > 
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> 
> Thanks!
>

You're welcome! :)

> > And below is not about this patch,
> > but what about something like this?
> > 
> > Because it's not necessary that page->_mapcount and
> > slab->units have same offset, so we can remove
> > (somewhat confusing) page_mapcount_reset function call.
> 
> Yeah this could be done as new patch on top of 21/33. I wouldn't squash it
> there so that it remains just a split without functional change.
>

Yeah, It is better to be done as separate patch.
I'll send it as a patch.

Thanks,
Hyeonggon

> > I want to remove calling page_mapcount_reset also in
> > SLAB, but I have no idea. (maybe we can do that if we remove
> > SLAB colouring but that's going too far)
> > 
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 90d7fceba470..dd0480149d38 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -50,8 +50,8 @@ struct slab {
> >         struct list_head slab_list;
> >         void * __unused_1;
> >         void *freelist;         /* first free block */
> > -       void * __unused_2;
> > -       int units;
> > +       long units;
> > +       unsigned int __unused_2;
> > 
> >  #else
> >  #error "Unexpected slab allocator configured"
> > diff --git a/mm/slob.c b/mm/slob.c
> > index 39b651b3e6e7..7b2d2c7d69cc 100644
> > --- a/mm/slob.c
> > +++ b/mm/slob.c
> > @@ -404,7 +404,6 @@ static void slob_free(void *block, int size)
> >                         clear_slob_page_free(sp);
> >                 spin_unlock_irqrestore(&slob_lock, flags);
> >                 __ClearPageSlab(slab_page(sp));
> > -               page_mapcount_reset(slab_page(sp));
> >                 slob_free_pages(b, 0);
> >                 return;
> >         }
> > 
> >> 
> >> > diff --git a/mm/slob.c b/mm/slob.c
> >> > index d3512bcc3141..cf669f03440f 100644
> >> > --- a/mm/slob.c
> >> > +++ b/mm/slob.c
> >> > @@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int a
> >> > lign, int node,
> >> >                 b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
> >> >                 if (!b)
> >> >                         return NULL;
> >> > +               __SetPageSlab(virt_to_page(b));
> >> >                 sp = virt_to_slab(b);
> >> > -               __SetPageSlab(slab_page(sp));
> >> > 
> >> >                 spin_lock_irqsave(&slob_lock, flags);
> >> >                 sp->units = SLOB_UNITS(PAGE_SIZE);
> >> >  
> >> >  Thanks,
> >> >  Hyeonggon.
> >> > 
> >> >>  
> >> >>  		spin_lock_irqsave(&slob_lock, flags);
> >> >>  		sp->units = SLOB_UNITS(PAGE_SIZE);
> >> >> @@ -381,7 +381,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
> >> >>   */
> >> >>  static void slob_free(void *block, int size)
> >> >>  {
> >> >> -	struct page *sp;
> >> >> +	struct slab *sp;
> >> >>  	slob_t *prev, *next, *b = (slob_t *)block;
> >> >>  	slobidx_t units;
> >> >>  	unsigned long flags;
> >> >> @@ -391,7 +391,7 @@ static void slob_free(void *block, int size)
> >> >>  		return;
> >> >>  	BUG_ON(!size);
> >> >>  
> >> >> -	sp = virt_to_page(block);
> >> >> +	sp = virt_to_slab(block);
> >> >>  	units = SLOB_UNITS(size);
> >> >>  
> >> >>  	spin_lock_irqsave(&slob_lock, flags);
> >> >> @@ -401,8 +401,8 @@ static void slob_free(void *block, int size)
> >> >>  		if (slob_page_free(sp))
> >> >>  			clear_slob_page_free(sp);
> >> >>  		spin_unlock_irqrestore(&slob_lock, flags);
> >> >> -		__ClearPageSlab(sp);
> >> >> -		page_mapcount_reset(sp);
> >> >> +		__ClearPageSlab(slab_page(sp));
> >> >> +		page_mapcount_reset(slab_page(sp));
> >> >>  		slob_free_pages(b, 0);
> >> >>  		return;
> >> >>  	}
> >> >> -- 
> >> >> 2.33.1
> >> >> 
> >> >> 
> >> 
> 
