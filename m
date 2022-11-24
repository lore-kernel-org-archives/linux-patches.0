Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C0A2589
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 12:55:23 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d192so1611911pfd.0
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 04:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9gtzrOrsoNCV5o2QC8fgzxtE8ANXsxJSKoxo24IyFcc=;
        b=RINqxyHQ1+PlMbJe7syJQm04IztogY5hCRUwRAOi2i6WrIByZqpDK/LPRjeplsTdtt
         KmV0QCeI7hNtnElUTudG0rFIOCSmDz0TIEzLxL0dqiMXf5WqexjgDYpG04EqvRDOKN+A
         hHGG54Gxkoxp5bX1FZuVUR+ZL2jp60VVAzJmgruSqKBm2U9UWswEHBwaNGnPpy3yScY3
         Nd7FcA4BcRX0No/2vhLV0sttRpn69iZeRUtlXCFRXC8W0Vgz6kL1WigkyZ5Gr0mMT1KF
         H6fK8w5WDLioJaJWJZcuGwt3lfRGfKbscQfk4Fq85TjYkZ7SOBS67RgtSGY7Fvdbb/uT
         hFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gtzrOrsoNCV5o2QC8fgzxtE8ANXsxJSKoxo24IyFcc=;
        b=YuWiHwdHkZU2EQL6bDEXGnsCi6nc4EOx9BAHiNIJzCefMRPdTt6UMAdcddL2veGzK+
         uvEyydLV2INYSB95lBthxJG02OSs9p5L0r/lFSL2dLjNdGznylhWyRBlNtiw0U/ncpnr
         juVzyQ7kRED107IvmBbgGeIE+8khIsoLJ/N8qY2qmCKoKy3PcKyg8nNEVcJMIAuEh/jh
         58j80VByr2mUfG0c7ZTc9er3kMzjJAuBR81Tc5qzEk0/ctUhwQyr3j73bJx2GDIp1kua
         HrEVRW5Iu642Ae4bCBt7y4641BZtP5JCUUEOe4q3VaLNNigsxNeyOQVcU1bKH9R02z7u
         Q3Vw==
X-Gm-Message-State: ANoB5pkmUSYIt93lEIG/6OXDXIx+9uipN6NCTD2eSAoy2Ia+a3pIkLgm
	cEi+O6tbQa1UMjXeOiy64GQ=
X-Google-Smtp-Source: AA0mqf4rEBDF5wX9BJnHhW0nfowVburVfHmQhsIXGzqgWOWAmaPXelMP15ZuJXhvQFBMs9Sb+5x4Pg==
X-Received: by 2002:a63:ea52:0:b0:46f:9c0c:8673 with SMTP id l18-20020a63ea52000000b0046f9c0c8673mr13642591pgk.154.1669294522593;
        Thu, 24 Nov 2022 04:55:22 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090a390800b0020d48bc6661sm3120211pjb.31.2022.11.24.04.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 04:55:21 -0800 (PST)
Date: Thu, 24 Nov 2022 21:55:15 +0900
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] mm, slub: don't create kmalloc-rcl caches with
 CONFIG_SLUB_TINY
Message-ID: <Y39psxclH4QEAzN+@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-7-vbabka@suse.cz>
 <d77498f8-b15f-9dae-1803-2d2bbb99da50@suse.cz>
 <Y39eLaW0mDNrHI6i@hyeyoo>
 <4fb214a4-0535-2d4a-fcde-bc2ab71329e3@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fb214a4-0535-2d4a-fcde-bc2ab71329e3@suse.cz>

On Thu, Nov 24, 2022 at 01:12:13PM +0100, Vlastimil Babka wrote:
> On 11/24/22 13:06, Hyeonggon Yoo wrote:
> > On Wed, Nov 23, 2022 at 02:53:43PM +0100, Vlastimil Babka wrote:
> >> On 11/21/22 18:11, Vlastimil Babka wrote:
> >> > Distinguishing kmalloc(__GFP_RECLAIMABLE) can help against fragmentation
> >> > by grouping pages by mobility, but on tiny systems the extra memory
> >> > overhead of separate set of kmalloc-rcl caches will probably be worse,
> >> > and mobility grouping likely disabled anyway.
> >> > 
> >> > Thus with CONFIG_SLUB_TINY, don't create kmalloc-rcl caches and use the
> >> > regular ones.
> >> > 
> >> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> 
> >> Fixed up in response to lkp report for a MEMCG_KMEM+SLUB_TINY combo:
> >> ---8<---
> >> From c1ec0b924850a2863d061f316615d596176f15bb Mon Sep 17 00:00:00 2001
> >> From: Vlastimil Babka <vbabka@suse.cz>
> >> Date: Tue, 15 Nov 2022 18:19:28 +0100
> >> Subject: [PATCH 06/12] mm, slub: don't create kmalloc-rcl caches with
> >>  CONFIG_SLUB_TINY
> >> 
> >> Distinguishing kmalloc(__GFP_RECLAIMABLE) can help against fragmentation
> >> by grouping pages by mobility, but on tiny systems the extra memory
> >> overhead of separate set of kmalloc-rcl caches will probably be worse,
> >> and mobility grouping likely disabled anyway.
> >> 
> >> Thus with CONFIG_SLUB_TINY, don't create kmalloc-rcl caches and use the
> >> regular ones.
> >> 
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> ---
> >>  include/linux/slab.h |  9 +++++++--
> >>  mm/slab_common.c     | 10 ++++++++--
> >>  2 files changed, 15 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/include/linux/slab.h b/include/linux/slab.h
> >> index 45efc6c553b8..ae2d19ec8467 100644
> >> --- a/include/linux/slab.h
> >> +++ b/include/linux/slab.h
> >> @@ -336,12 +336,17 @@ enum kmalloc_cache_type {
> >>  #endif
> >>  #ifndef CONFIG_MEMCG_KMEM
> >>  	KMALLOC_CGROUP = KMALLOC_NORMAL,
> >> -#else
> >> -	KMALLOC_CGROUP,
> >>  #endif
> >> +#ifdef CONFIG_SLUB_TINY
> >> +	KMALLOC_RECLAIM = KMALLOC_NORMAL,
> >> +#else
> >>  	KMALLOC_RECLAIM,
> >> +#endif
> >>  #ifdef CONFIG_ZONE_DMA
> >>  	KMALLOC_DMA,
> >> +#endif
> >> +#ifdef CONFIG_MEMCG_KMEM
> >> +	KMALLOC_CGROUP,
> >>  #endif
> >>  	NR_KMALLOC_TYPES
> >>  };
> > 
> > Can you please elaborate what the lkp report was about
> > and how you fixed it? I'm not getting what the problem of previous
> > version is.
> 
> Report here:
> https://lore.kernel.org/all/202211231949.nIyAWKam-lkp@intel.com/
> 
> Problem is that if the preprocessing results in e.g.
> KMALLOC_NORMAL = 0,
> KMALLOC_DMA = KMALLOC_NORMAL
> KMALLOC_CGROUP,
> KMALLOC_RECLAIM = KMALLOC_NORMAL,
> NR_KMALLOC_TYPES
> 
> then NR_KMALLOC_TYPES is not 2, but 1, because the enum's internal counter
> got reset to 0 by KMALLOC_RECLAIM = KMALLOC_NORMAL. A common gotcha :/

Thanks for quick and kind explanation :)
That was easy to be missed.

-- 
Thanks,
Hyeonggon
