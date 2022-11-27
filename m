Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD56256E
	for <patches@lists.linux.dev>; Sun, 27 Nov 2022 10:54:38 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id 4so7690567pli.0
        for <patches@lists.linux.dev>; Sun, 27 Nov 2022 02:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kaGLCyXdBMIaKuINsSow+H91A2R/a1Mjh2wpGhwGfqc=;
        b=Lr3b8t+b+nSA4PI/Pfz5w8RtWZ0CYsK0Qx+29vlI65Y9TzCMP4rmS7qnx69Ohy0cMk
         n9P6TQiWiDHSrKXfRdHwhWUw8mAk2vSPJqDpViCtxZ6njrYzkNDw63j60++ACy1efjEa
         0mRS6RGREsTNjaEo/PKxwQFjwLoYt+r3kZa1DzUKUssPkr5QgqvaK28TS0xcYf0PuUab
         jbQTeSLjuOUW8NudOa/XT61TzHp2T/IK8zp+3baM4Sj2ZS5dNpODOSOcK+cHgIsPlJTk
         LQb0LVwmbNlaQ405kK5SLpisHMo5V5mmXAfPRf6SiWFLF4k3SeWzNmWIUoVtdIgXXRTB
         NPug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaGLCyXdBMIaKuINsSow+H91A2R/a1Mjh2wpGhwGfqc=;
        b=z2PsAEUJQMBwQU7hb9I1rAu1gpeTaa1lx5vJQOpmOgBIY45+OdgrwCO7wig8vTz5zX
         omKyLBWU3i/mOX/4HBZPLRvYcjb27RoYpSiB3+6HLw6vuG9FLk9tX3JKSfosk6xeOrZy
         CkrFSQL3OHcdlFN2GKCHNamhRMzftUqbtdJevdwZlxG8NBxkInQE9ZIg3QsNmmCiPP60
         SYmVxpRAQY0mp+JaWsjnEvNLUsgkRbV8SFIw5g4WUEX4rQos4hfdX8Jn2z036nGCX6e0
         8z+IMTTPAyKdUIozHtjMeMqDJwY/Ydp7iTe6w+ZDi8DI3UdWpqyJKZ0CQ9QKcERQ46ra
         W9yQ==
X-Gm-Message-State: ANoB5pmWn0feaoyjN0+kP/zSwrOu5w+/p5IYPncgwR0EL8A5YsHYkBwM
	aJGdcnCwJirQyX8453zLP78=
X-Google-Smtp-Source: AA0mqf6Q4OvnuAJ3a6PQCQkeShpgc1L6HV00PSdTaTzyvG1/h9Bsf5dTkPMiPc9yM2saAJ7+DqHn7Q==
X-Received: by 2002:a17:90a:eac2:b0:219:484:e955 with SMTP id ev2-20020a17090aeac200b002190484e955mr13854997pjb.214.1669546477967;
        Sun, 27 Nov 2022 02:54:37 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id s33-20020a63ff61000000b004772abe41f6sm5071054pgk.83.2022.11.27.02.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 02:54:36 -0800 (PST)
Date: Sun, 27 Nov 2022 19:54:30 +0900
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
Subject: Re: [PATCH 09/12] mm, slub: split out allocations from pre/post hooks
Message-ID: <Y4NB5i4WBvLr1GGZ@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-10-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121171202.22080-10-vbabka@suse.cz>

On Mon, Nov 21, 2022 at 06:11:59PM +0100, Vlastimil Babka wrote:
> In the following patch we want to introduce CONFIG_SLUB_TINY allocation
> paths that don't use the percpu slab. To prepare, refactor the
> allocation functions:
> 
> Split out __slab_alloc_node() from slab_alloc_node() where the former
> does the actual allocation and the latter calls the pre/post hooks.
> 
> Analogically, split out __kmem_cache_alloc_bulk() from
> kmem_cache_alloc_bulk().
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 127 +++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 77 insertions(+), 50 deletions(-)

[...]

> +
> +/* Note that interrupts must be enabled when calling this function. */
> +int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
> +			  void **p)
> +{
> +	int i;
> +	struct obj_cgroup *objcg = NULL;
> +
> +	/* memcg and kmem_cache debug support */
> +	s = slab_pre_alloc_hook(s, NULL, &objcg, size, flags);
> +	if (unlikely(!s))
> +		return false;
> +
> +	i = __kmem_cache_alloc_bulk(s, flags, size, p, objcg);
> +
> +	/*
> +	 * memcg and kmem_cache debug support and memory initialization.
> +	 * Done outside of the IRQ disabled fastpath loop.
> +	 */
> +	if (i != 0)
> +		slab_post_alloc_hook(s, objcg, flags, size, p,
> +				slab_want_init_on_alloc(flags, s));

This patch looks mostly good but wondering what happens if someone calls it with size == 0
so it does not call slab_post_alloc_hook()?

> +	return i;
>  }
>  EXPORT_SYMBOL(kmem_cache_alloc_bulk);
>  
> -- 
> 2.38.1
> 

-- 
Thanks,
Hyeonggon
