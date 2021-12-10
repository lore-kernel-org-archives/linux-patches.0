Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D8529CA
	for <patches@lists.linux.dev>; Fri, 10 Dec 2021 10:44:41 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id i12so8118781pfd.6
        for <patches@lists.linux.dev>; Fri, 10 Dec 2021 02:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0U8OtES5xOj4rqgnd2vdl4trSth3+050XfcObSQBQ58=;
        b=KdTmk3w7bmfzFk7lnwFxJUX4SzMf3YcvWLIvC/3KqTNvA5BCm0daDjN3XEP6tgr7fb
         qJjxeZl124cLQYufEByAOcgi0jlWmxl6OcxSZnUb5tFw8GjHStsxjMSpDJDLBosZlvcn
         k5ccAPIPdlLcRdBsMTP24plm4wRRaz6KbMps78pA97TBZZORbaNq03FkbgfYh7pxintc
         sBQ/WeMhcxm2X+ePjadP7N0yvevNjQ3RLL2SI4gPkls80c+gzF0VgYk7+K3bmTMjjUHY
         wIK4ChK9Lnu4OO611jbVCsnDVx0Ua41VaJ9bTccQej13+aiQFv41U8rB0k2zbi+Wvtr7
         h8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0U8OtES5xOj4rqgnd2vdl4trSth3+050XfcObSQBQ58=;
        b=XQQucOhESSH0KFlJ26adbAce1f37zVD4XSS7/ThpkR5hz/yL7F1dokyLYhuEVS/5ce
         02YrvBZOsarFjDQa4LMlP9gcYbfUKHfuvCBEq4b4V2p4qOr9NXN/F8a+TlZx2pMBc4zm
         5gXgwKkdGI4diosZqOlW1/SlFVxy8eJ01tS24ZCPHWA6Fp9dT+Psr741nDiPCbh4VGmE
         79EYf+EuYjUs6jrLckmziFSfEQ1/rdirp7FlfwZp8vkza9e3pleLP2n7hbEJ80W9cvPQ
         /x+GCAt3GOpAMKaNpWn5s2PFS/Xpv0Y+UJZSg7pc1Y0zu+rQi18ZEwhus+Jn7obLt5RW
         otQg==
X-Gm-Message-State: AOAM530Vhc9ePFRTCh9gfPUuX5gG57uyFOPXHONLDe1Vc9Fpi2wqTH2O
	Fn8h3jpNf21m2uJkJoEzIMc=
X-Google-Smtp-Source: ABdhPJyll9nMQuRPwgwMd9dUKhLY1En8Eimub3NMYDOH6MCdrfAGbhcNGJjptNiCGNdOecDZaxA/Xw==
X-Received: by 2002:a63:6987:: with SMTP id e129mr38676747pgc.520.1639133081071;
        Fri, 10 Dec 2021 02:44:41 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id 16sm2264896pgu.93.2021.12.10.02.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:44:40 -0800 (PST)
Date: Fri, 10 Dec 2021 10:44:35 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 24/33] mm/slob: Convert SLOB to use struct slab
Message-ID: <20211210104435.GA632117@odroid>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-25-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-25-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:15:01PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Use struct slab throughout the slob allocator.
> 
> [ vbabka@suse.cz: don't introduce wrappers for PageSlobFree in mm/slab.h just
>   for the single callers being wrappers in mm/slob.c ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slob.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/slob.c b/mm/slob.c
> index d2d15e7f191c..d3512bcc3141 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c

...

>  		/* Enough room on this page? */
> @@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
>  		b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
>  		if (!b)
>  			return NULL;
> -		sp = virt_to_page(b);
> -		__SetPageSlab(sp);
> +		sp = virt_to_slab(b);
> +		__SetPageSlab(slab_page(sp));

Hello Vlastimil.

I've tested this patch on my machine and it causes NULL pointer dereference.
that's because virt_to_slab returns NULL if folio_test_slab is false.
and __SetPageSlab is called with sp = NULL.

diff below fixed bug.

diff --git a/mm/slob.c b/mm/slob.c
index d3512bcc3141..cf669f03440f 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int a
lign, int node,
                b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
                if (!b)
                        return NULL;
+               __SetPageSlab(virt_to_page(b));
                sp = virt_to_slab(b);
-               __SetPageSlab(slab_page(sp));

                spin_lock_irqsave(&slob_lock, flags);
                sp->units = SLOB_UNITS(PAGE_SIZE);
 
 Thanks,
 Hyeonggon.

>  
>  		spin_lock_irqsave(&slob_lock, flags);
>  		sp->units = SLOB_UNITS(PAGE_SIZE);
> @@ -381,7 +381,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
>   */
>  static void slob_free(void *block, int size)
>  {
> -	struct page *sp;
> +	struct slab *sp;
>  	slob_t *prev, *next, *b = (slob_t *)block;
>  	slobidx_t units;
>  	unsigned long flags;
> @@ -391,7 +391,7 @@ static void slob_free(void *block, int size)
>  		return;
>  	BUG_ON(!size);
>  
> -	sp = virt_to_page(block);
> +	sp = virt_to_slab(block);
>  	units = SLOB_UNITS(size);
>  
>  	spin_lock_irqsave(&slob_lock, flags);
> @@ -401,8 +401,8 @@ static void slob_free(void *block, int size)
>  		if (slob_page_free(sp))
>  			clear_slob_page_free(sp);
>  		spin_unlock_irqrestore(&slob_lock, flags);
> -		__ClearPageSlab(sp);
> -		page_mapcount_reset(sp);
> +		__ClearPageSlab(slab_page(sp));
> +		page_mapcount_reset(slab_page(sp));
>  		slob_free_pages(b, 0);
>  		return;
>  	}
> -- 
> 2.33.1
> 
> 
