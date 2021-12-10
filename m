Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A07173
	for <patches@lists.linux.dev>; Fri, 10 Dec 2021 15:29:12 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id h24so7087970pjq.2
        for <patches@lists.linux.dev>; Fri, 10 Dec 2021 07:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1liFekIPKHTV+M4ebcVncHi6VLy9DuhF0BgnVbN503A=;
        b=pMTGchejqovrxGMURNOhgsnw17bW/NUepyoWwnLg6nQHILcwUSeWcAfyLD3XsJZNvT
         drIXSTvfgwTGAX0b2tybyr/Ye6kE+TT48LBcnXOchDsUQ8HwRKdksCVQjajhrLy/j2HE
         DgQVj/VgL06dZIJKctl53+pVYxQ9rB+cT+X4HUYpeZlrnLpsWu6j4TijSqSCIj89tjfC
         JHcWVt3dV/JfYdCTNKRNJZawWOCRMFn+u5LfjHGl3YvefahnrAcug+E3VSzoQmHrvlkf
         ZnC4FH1w0tuunjc5xaRzEl5lWcBVv5ZGy3/98WMETvxn5Z4HxVN8k7V3Y2PQnEitv+I/
         mKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1liFekIPKHTV+M4ebcVncHi6VLy9DuhF0BgnVbN503A=;
        b=d6IgmX74OUl5feI6+q0/JgvcUEt9Rwf99aFMGj9C60OWeW+dsqLG7MV6iiPGAeplWr
         4x2OPjI8iGxr6jMzB6XNGXZBRdoQQQY+YGSxLO8GzL1p988kVcw6d7fYU757QU98F3Wk
         5/aXWvuh7y+YpUc/MvzRT1THSf4nvctCarestNvk3qASPuCBEjRT6qxaO3+N1WE/M2f8
         eIiFeD8Em0HDn/l/e55bNcP8+KRmpEY/31IdgofRJxJ+60tNTYyD9MDagRD21DbI6AWr
         c6yozp17B1Ub9NAQrF+sctubb4XBRf6JU3k7tI+nUzmD2wpY/Z/0Iu4in/LkmtTnKKo+
         sqBg==
X-Gm-Message-State: AOAM5328r174i2gTO78Y9DlJ2oqy/IKvQ/fMAkq+7bSV5raZukvgD92t
	KVHO/rr/1puoHnNY3z73F84=
X-Google-Smtp-Source: ABdhPJxq9iw0mDWSHdKFbMs1RBbUFgFC39xy04+u+bufJVOlA4kYNruPycR7GkAqH1zrAAZ7ziKIfQ==
X-Received: by 2002:a17:90b:2290:: with SMTP id kx16mr24625938pjb.193.1639150151781;
        Fri, 10 Dec 2021 07:29:11 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id t13sm3609919pfl.214.2021.12.10.07.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 07:29:11 -0800 (PST)
Date: Fri, 10 Dec 2021 15:29:05 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 24/33] mm/slob: Convert SLOB to use struct slab
Message-ID: <20211210152905.GA694381@odroid>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-25-vbabka@suse.cz>
 <20211210104435.GA632117@odroid>
 <254ce648-2b1c-edbd-1e1f-4bfc6bf6a195@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254ce648-2b1c-edbd-1e1f-4bfc6bf6a195@suse.cz>

On Fri, Dec 10, 2021 at 12:44:32PM +0100, Vlastimil Babka wrote:
> On 12/10/21 11:44, Hyeonggon Yoo wrote:
> > On Wed, Dec 01, 2021 at 07:15:01PM +0100, Vlastimil Babka wrote:
> >> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> >> 
> >> Use struct slab throughout the slob allocator.
> >> 
> >> [ vbabka@suse.cz: don't introduce wrappers for PageSlobFree in mm/slab.h just
> >>   for the single callers being wrappers in mm/slob.c ]
> >> 
> >> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> ---
> >>  mm/slob.c | 34 +++++++++++++++++-----------------
> >>  1 file changed, 17 insertions(+), 17 deletions(-)
> >> 
> >> diff --git a/mm/slob.c b/mm/slob.c
> >> index d2d15e7f191c..d3512bcc3141 100644
> >> --- a/mm/slob.c
> >> +++ b/mm/slob.c
> > 
> > ...
> > 
> >>  		/* Enough room on this page? */
> >> @@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
> >>  		b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
> >>  		if (!b)
> >>  			return NULL;
> >> -		sp = virt_to_page(b);
> >> -		__SetPageSlab(sp);
> >> +		sp = virt_to_slab(b);
> >> +		__SetPageSlab(slab_page(sp));
> > 
> > Hello Vlastimil.
> > 
> > I've tested this patch on my machine and it causes NULL pointer dereference.
> > that's because virt_to_slab returns NULL if folio_test_slab is false.
> > and __SetPageSlab is called with sp = NULL.
> 
> Oops, thanks for catching this.
> 
> > diff below fixed bug.
> 
> Changed it to use folio and will push an updated branch
> slab-struct_slab-v3r2
> 
> Thanks!

Tested again on slab-struct_slab-v3r2 and everyting works fine!
And the code overall looks good to me.

Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

And below is not about this patch,
but what about something like this?

Because it's not necessary that page->_mapcount and
slab->units have same offset, so we can remove
(somewhat confusing) page_mapcount_reset function call.

I want to remove calling page_mapcount_reset also in
SLAB, but I have no idea. (maybe we can do that if we remove
SLAB colouring but that's going too far)

diff --git a/mm/slab.h b/mm/slab.h
index 90d7fceba470..dd0480149d38 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -50,8 +50,8 @@ struct slab {
        struct list_head slab_list;
        void * __unused_1;
        void *freelist;         /* first free block */
-       void * __unused_2;
-       int units;
+       long units;
+       unsigned int __unused_2;

 #else
 #error "Unexpected slab allocator configured"
diff --git a/mm/slob.c b/mm/slob.c
index 39b651b3e6e7..7b2d2c7d69cc 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -404,7 +404,6 @@ static void slob_free(void *block, int size)
                        clear_slob_page_free(sp);
                spin_unlock_irqrestore(&slob_lock, flags);
                __ClearPageSlab(slab_page(sp));
-               page_mapcount_reset(slab_page(sp));
                slob_free_pages(b, 0);
                return;
        }

> 
> > diff --git a/mm/slob.c b/mm/slob.c
> > index d3512bcc3141..cf669f03440f 100644
> > --- a/mm/slob.c
> > +++ b/mm/slob.c
> > @@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int a
> > lign, int node,
> >                 b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
> >                 if (!b)
> >                         return NULL;
> > +               __SetPageSlab(virt_to_page(b));
> >                 sp = virt_to_slab(b);
> > -               __SetPageSlab(slab_page(sp));
> > 
> >                 spin_lock_irqsave(&slob_lock, flags);
> >                 sp->units = SLOB_UNITS(PAGE_SIZE);
> >  
> >  Thanks,
> >  Hyeonggon.
> > 
> >>  
> >>  		spin_lock_irqsave(&slob_lock, flags);
> >>  		sp->units = SLOB_UNITS(PAGE_SIZE);
> >> @@ -381,7 +381,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
> >>   */
> >>  static void slob_free(void *block, int size)
> >>  {
> >> -	struct page *sp;
> >> +	struct slab *sp;
> >>  	slob_t *prev, *next, *b = (slob_t *)block;
> >>  	slobidx_t units;
> >>  	unsigned long flags;
> >> @@ -391,7 +391,7 @@ static void slob_free(void *block, int size)
> >>  		return;
> >>  	BUG_ON(!size);
> >>  
> >> -	sp = virt_to_page(block);
> >> +	sp = virt_to_slab(block);
> >>  	units = SLOB_UNITS(size);
> >>  
> >>  	spin_lock_irqsave(&slob_lock, flags);
> >> @@ -401,8 +401,8 @@ static void slob_free(void *block, int size)
> >>  		if (slob_page_free(sp))
> >>  			clear_slob_page_free(sp);
> >>  		spin_unlock_irqrestore(&slob_lock, flags);
> >> -		__ClearPageSlab(sp);
> >> -		page_mapcount_reset(sp);
> >> +		__ClearPageSlab(slab_page(sp));
> >> +		page_mapcount_reset(slab_page(sp));
> >>  		slob_free_pages(b, 0);
> >>  		return;
> >>  	}
> >> -- 
> >> 2.33.1
> >> 
> >> 
> 
