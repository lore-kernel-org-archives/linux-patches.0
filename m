Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1F233D4
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 14:02:57 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id m4so15725205pls.4
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 06:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5YiSjWHoQWvxaPnMWkhQIQOkA+9eRIuJnwPdOS374zI=;
        b=i191arESYf3ytwMfFMtgeaKAS9H5vjtkaPCums6F5nmiiiXLgP6n3izOpIxcPDHuMa
         tGJT27K3n4zgHFtYDXQ/uuQ0wOOJJ8qYhZBSs2mJzJnZjInobNMYKb1uDZve++kIoQdO
         lrn3gZIlO83al62AO3fAseNoqtZc5KiGkccvYuPzzKc3Do0EUC0I/Yn/cB4q+xHGkiKF
         vYH/g7vgwp75Nw4Oi2NrBk/EDD4MKcjWRqiQbP0qGt+3Rlm5vOOWcYW3a5DrfIOlS/fT
         SlsuX6f+4sIX3TyQ6AS/tL6BrA0Wh8C4PE0exCBY4cX0amezW2ahyc/0eRcs7bfoOd6H
         8L0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5YiSjWHoQWvxaPnMWkhQIQOkA+9eRIuJnwPdOS374zI=;
        b=WKoco+ZOoIrT7AOBHYpOgVxsBg00+3PD3B/ItO3SLAeKxqbq1B7fNdFh3KrEvz2K12
         EID5y2SlLl10BT1zsfi9hLR85V+djSpBFqZbPjsQOT4jqQOdShTZRCMqgiMdE9bMqLn5
         oBPkyOQAP3VCVAgBXRsJ0T3OYET1iAq0vhqZK+sNyUuIeY1hZ38jVfUwt760pEiXlPX8
         wVv+CDww2IDdozqXS21zk6l1Xpg1oS5b1QcohoFbc+jo9WNM8uSHI4C+jOefBGEcwv6e
         bgSGhCuPie8NuVhw8SVJ2vCPtNi4R11I3aSIdhiVuj5zhO2sQ/bscKpHj91ndH/2AxDk
         U/qw==
X-Gm-Message-State: ANoB5plkMxCLPfPkI7g8qxBhni2WQXlUIKPrZl8kf1iqkLnH4pFXfZQ8
	JBhLKvluaw70Qw0RMChcnyY=
X-Google-Smtp-Source: AA0mqf4ZPrtW54ww6Zvl6Ql4G2TELTlzGR4srjVLOEtRgpEOsxTRyyMe9EvHYVftTjcf85a6AR9rNw==
X-Received: by 2002:a17:902:a588:b0:185:441e:90b5 with SMTP id az8-20020a170902a58800b00185441e90b5mr20420811plb.27.1670940176560;
        Tue, 13 Dec 2022 06:02:56 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b001811a197797sm8462259plb.194.2022.12.13.06.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 06:02:55 -0800 (PST)
Date: Tue, 13 Dec 2022 23:02:49 +0900
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Baoquan He <bhe@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] mm, slub: remove percpu slabs with CONFIG_SLUB_TINY
Message-ID: <Y5iGCY7LfQ1SKylO@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-11-vbabka@suse.cz>
 <Y4NEkF8DI1uXFRv4@hyeyoo>
 <f318ccc3-eb03-e359-cb6f-157d0b4aed31@suse.cz>
 <Y5cob2jicdNoviU3@fedora>
 <Y5frwZNPN++sqHLY@MiWiFi-R3L-srv>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5frwZNPN++sqHLY@MiWiFi-R3L-srv>

On Tue, Dec 13, 2022 at 11:04:33AM +0800, Baoquan He wrote:
> On 12/12/22 at 05:11am, Dennis Zhou wrote:
> > Hello,
> > 
> > On Mon, Dec 12, 2022 at 11:54:28AM +0100, Vlastimil Babka wrote:
> > > On 11/27/22 12:05, Hyeonggon Yoo wrote:
> > > > On Mon, Nov 21, 2022 at 06:12:00PM +0100, Vlastimil Babka wrote:
> > > >> SLUB gets most of its scalability by percpu slabs. However for
> > > >> CONFIG_SLUB_TINY the goal is minimal memory overhead, not scalability.
> > > >> Thus, #ifdef out the whole kmem_cache_cpu percpu structure and
> > > >> associated code. Additionally to the slab page savings, this reduces
> > > >> percpu allocator usage, and code size.
> > > > 
> > > > [+Cc Dennis]
> > > 
> > > +To: Baoquan also.
> 
> Thanks for adding me.
> 
> > > 
> > > > Wondering if we can reduce (or zero) early reservation of percpu area
> > > > when #if !defined(CONFIG_SLUB) || defined(CONFIG_SLUB_TINY)?
> > > 
> > > Good point. I've sent a PR as it was [1], but (if merged) we can still
> > > improve that during RC series, if it means more memory saved thanks to less
> > > percpu usage with CONFIG_SLUB_TINY.
> > > 
> > > [1]
> > > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/tag/?h=slab-for-6.2-rc1
> > 
> > The early reservation area not used at boot is then used to serve normal
> > percpu allocations. Percpu allocates additional chunks based on a free
> > page float count and is backed page by page, not all at once. I get
> > slabs is the main motivator of early reservation, but if there are other
> > users of percpu, then shrinking the early reservation area is a bit
> > moot.
> 
> Agree. Before kmem_cache_init() is done, anyone calling alloc_percpu()
> can only get allocation done from early reservatoin of percpu area.
> So, unless we can make sure nobody need to call alloc_percpu() before
> kmem_cache_init() now and future.

Thank you both for explaination.
just googled and found random /proc/meminfo output of K210 board (6MB RAM, dual-core)

Given that even K210 board uses around 100kB of percpu area,
might not be worth thing to do :(

https://gist.github.com/pdp7/0fd86d39e07ad7084f430c85a7a567f4?permalink_comment_id=3179983#gistcomment-3179983

> The only drawback of early reservation is it's not so flexible. We can
> only dynamically create chunk to increase percpu areas when early
> reservation is run out, but can't shrink early reservation if system
> doesn't need that much.
> 
> So we may need weigh the two ideas:
>   - Not allowing to alloc_percpu() before kmem_cache_init();
>   - Keep early reservation, and think of a economic value for
>     CONFIG_SLUB_TINY.
>  
> start_kernel()
>   ->setup_per_cpu_areas();
>   ......
>   ->mm_init();
>       ......
>       -->kmem_cache_init();
> 
> 
> __alloc_percpu()
>   -->pcpu_alloc()
>      --> succeed to allocate from early reservation
>       or
>      -->pcpu_create_chunk()
>         -->pcpu_alloc_chunk()
>            -->pcpu_mem_zalloc()
> 

-- 
Thanks,
Hyeonggon
