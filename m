Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30BE23B7
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 10:41:21 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 27so6982558pgk.10
        for <patches@lists.linux.dev>; Sat, 26 Feb 2022 02:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mjKhWjMPgXbeTa11qHZqOVCkCLpM7JLImgJi+vBEKC8=;
        b=fmng/ke0W2wco9Dkgh/fE1Mc4KET/2dyix7KRg3kGVQKCHDTQfcvyAPerYvGon36po
         LeWBx2bpFD6t6bWZsEw0JlquCY8SljLS47eIm8IZMJmo9Je9tRCy9yIqns9uDYeKp8+A
         tI3vv9hWYPhbqQcIzLc2+U/IeIbJw6rwms0HPWWh+tVDSNYE+X5VsJ8hZ3ebh2GXd3pg
         QJQFRvil9q6Gw2qATURb9ZHyrR4nbSFU0fbr3KgUFCEZ1UDwXD65smcRs0AvjamfTjOJ
         995OvEwV0pjf7Fwto5W3AFSXTQCJorRELw8KJa0i9Hr4R9KNeCOAQEfNUo7kaknRT7CW
         AU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mjKhWjMPgXbeTa11qHZqOVCkCLpM7JLImgJi+vBEKC8=;
        b=k/dB2NZOxqLy3zfHYHoTYTqScSWDS0LNBctCEKxOsfV8ogwe861JmcDtaPxJWqw0AS
         28n66JEp2PwSnN9VQwh7PbqnA5UsW97S/2mCLLhOYk2HRR/yVIjhkKi2tqtHHTEf1EVO
         BpnP5QPAHAwpF1ySl4u89QYfc/aAFcwrQKHLFehDPT3UO0316aNGJQjdx0U8gLpvHx2i
         H1FDz77qQdPgGw1DGOFfOWabG49psl5ZhJnjS2AtSpn2rQOJWeZgi0MXok3kG4mrhSYb
         RWiu7KC8l7WyGEIZP5WaMzf71qvNw+UHnAr63Qq83O1Tb9lsUPgt4rA28aAn9hUgpe7J
         ZLMQ==
X-Gm-Message-State: AOAM532XexgDoiemQ8DKZdihrv/NMTGsa2iYgUn/zdJDepnB943waqwD
	vTLVO+zhSOBe3ETdcLenUBg=
X-Google-Smtp-Source: ABdhPJwkz7N4NjXwnG7ZBWanGBQgQQx6wh8pZy+BiHHzDDCntbMTgl4OsBqWhmBEnJbB8Fm0tus8xQ==
X-Received: by 2002:a63:64a:0:b0:36c:6d40:5688 with SMTP id 71-20020a63064a000000b0036c6d405688mr9731007pgg.554.1645872081193;
        Sat, 26 Feb 2022 02:41:21 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id g9-20020a056a0023c900b004e10365c47dsm6552162pfc.192.2022.02.26.02.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 02:41:20 -0800 (PST)
Date: Sat, 26 Feb 2022 10:41:16 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Oliver Glitta <glittao@gmail.com>,
	Faiyaz Mohammed <faiyazm@codeaurora.org>
Subject: Re: [PATCH 1/5] mm/slub: move struct track init out of set_track()
Message-ID: <YhoDzPfUtorL8U8L@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220225180318.20594-1-vbabka@suse.cz>
 <20220225180318.20594-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225180318.20594-2-vbabka@suse.cz>

On Fri, Feb 25, 2022 at 07:03:14PM +0100, Vlastimil Babka wrote:
> set_track() either zeroes out the struct track or fills it, depending on
> the addr parameter. This is unnecessary as there's only one place that
> calls it for the initialization - init_tracking(). We can simply do the
> zeroing there, with a single memset() that covers both TRACK_ALLOC and
> TRACK_FREE as they are adjacent.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 261474092e43..1fc451f4fe62 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -729,34 +729,32 @@ static void set_track(struct kmem_cache *s, void *object,
>  {
>  	struct track *p = get_track(s, object, alloc);
>  
> -	if (addr) {
>  #ifdef CONFIG_STACKTRACE
> -		unsigned int nr_entries;
> +	unsigned int nr_entries;
>  
> -		metadata_access_enable();
> -		nr_entries = stack_trace_save(kasan_reset_tag(p->addrs),
> -					      TRACK_ADDRS_COUNT, 3);
> -		metadata_access_disable();
> +	metadata_access_enable();
> +	nr_entries = stack_trace_save(kasan_reset_tag(p->addrs),
> +				      TRACK_ADDRS_COUNT, 3);
> +	metadata_access_disable();
>  
> -		if (nr_entries < TRACK_ADDRS_COUNT)
> -			p->addrs[nr_entries] = 0;
> +	if (nr_entries < TRACK_ADDRS_COUNT)
> +		p->addrs[nr_entries] = 0;
>  #endif
> -		p->addr = addr;
> -		p->cpu = smp_processor_id();
> -		p->pid = current->pid;
> -		p->when = jiffies;
> -	} else {
> -		memset(p, 0, sizeof(struct track));
> -	}
> +	p->addr = addr;
> +	p->cpu = smp_processor_id();
> +	p->pid = current->pid;
> +	p->when = jiffies;
>  }
>  
>  static void init_tracking(struct kmem_cache *s, void *object)
>  {
> +	struct track *p;
> +
>  	if (!(s->flags & SLAB_STORE_USER))
>  		return;
>  
> -	set_track(s, object, TRACK_FREE, 0UL);
> -	set_track(s, object, TRACK_ALLOC, 0UL);
> +	p = get_track(s, object, TRACK_ALLOC);
> +	memset(p, 0, 2*sizeof(struct track));
>  }
>

Looks good.
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

And works nicely.
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

>  static void print_track(const char *s, struct track *t, unsigned long pr_time)
> -- 
> 2.35.1
> 
> 

-- 
Thank you, You are awesome!
Hyeonggon :-)
