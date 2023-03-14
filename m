Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30762565
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 07:26:02 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id y2so14494010pjg.3
        for <patches@lists.linux.dev>; Tue, 14 Mar 2023 00:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678778762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4btLFxdwo7HqZYxM4e3XDdeo+DTrgbyuCAt7JOXufA=;
        b=lczv1+oCjA44tNBOXDuZb6ygf8VSugMU6SI4f3m4RkNiRBcKFtF/kAxXclBRAPKP8B
         M/0j99Xagn3nWRglvofL8CNl2IX2uyNzs3OsDdxT8GkAT/ILtxTcLB+Vjamhuf0yc58z
         hpd1OAyI2vqMtBI+oVFj2hKq7nkNYFHdmVEnU79S0Gjcorj7a6d34QqlN5bis3OyKhmk
         kp3XzQXtVR9Ddc6fqEhJjD6nRuiePRIsAX5U8mnaXz/nnpq0CGR/c9RZvb1Ik5DfOOA0
         S2TV3diroWan8IfHdVDY6rRKIpMvad79Rdt8/Icjq6QYxvmGhsfAtQiXQ3RHVi51gz9D
         dF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678778762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4btLFxdwo7HqZYxM4e3XDdeo+DTrgbyuCAt7JOXufA=;
        b=WNsx7GJtWApCpCkNgnj5Fjm9j4Ta9NmGWR8MttlFFYD9kgd1ATtk37IyxW1hQQtvWt
         J1ChWjcxm42SexHUepVyVrGWadavJIsbVp0aWI9BcQxRTGxPJ8GQxx5+q+HSgyR5aU/N
         PGR9FZfTB3pC8o5RbgNZdnIabexh5Lj4RpnXApeT6Iy0g1MPc+BK6UlT0K96icEdppqz
         P78YUpJwZleTUEZhTj4iEY4DdtiW/y09s0EVquJG52pscsweuOYsnzSZ0K+HN8WrIkGH
         cMy7Yr26k/QLas/fi1FutIx4/Y1n2N1Et8Gm2ymVuNELnE1n8BAtUDPMhCRd0GGQ2Rkl
         o+rw==
X-Gm-Message-State: AO0yUKWi0MDlzwJbK92+DG+OaWQlkoDdDqSfdRblJNytZ8bO8Gjm2gZ6
	nRPY2zy9LRXZ3kyzxmVrrLU=
X-Google-Smtp-Source: AK7set/kZq/B2QShY0y1HE88ddus1pElLywW15Ta+0oYzLvi6YuddzUADJuwEfCk9yGr65u+O8CuGQ==
X-Received: by 2002:a05:6a21:6da6:b0:cb:e8c6:26a0 with SMTP id wl38-20020a056a216da600b000cbe8c626a0mr49148859pzb.11.1678778762183;
        Tue, 14 Mar 2023 00:26:02 -0700 (PDT)
Received: from localhost ([2400:8902::f03c:93ff:fe27:642a])
        by smtp.gmail.com with ESMTPSA id l190-20020a6388c7000000b00502ea97cbc0sm888625pgd.40.2023.03.14.00.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 00:26:01 -0700 (PDT)
Date: Tue, 14 Mar 2023 07:25:54 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/7] mm, page_flags: remove PG_slob_free
Message-ID: <ZBAhgpY1KSE3FwAv@localhost>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-4-vbabka@suse.cz>

On Fri, Mar 10, 2023 at 11:32:05AM +0100, Vlastimil Babka wrote:
> With SLOB removed we no longer need the PG_slob_free alias for
> PG_private. Also update tools/mm/page-types.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/page-flags.h | 4 ----
>  tools/mm/page-types.c      | 6 +-----
>  2 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index a7e3a3405520..2bdc41cb0594 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -174,9 +174,6 @@ enum pageflags {
>  	/* Remapped by swiotlb-xen. */
>  	PG_xen_remapped = PG_owner_priv_1,
>  
> -	/* SLOB */
> -	PG_slob_free = PG_private,
> -
>  #ifdef CONFIG_MEMORY_FAILURE
>  	/*
>  	 * Compound pages. Stored in first tail page's flags.
> @@ -483,7 +480,6 @@ PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
>  PAGEFLAG(Workingset, workingset, PF_HEAD)
>  	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
>  __PAGEFLAG(Slab, slab, PF_NO_TAIL)
> -__PAGEFLAG(SlobFree, slob_free, PF_NO_TAIL)
>  PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
>  
>  /* Xen */
> diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
> index 381dcc00cb62..8d5595b6c59f 100644
> --- a/tools/mm/page-types.c
> +++ b/tools/mm/page-types.c
> @@ -85,7 +85,6 @@
>   */
>  #define KPF_ANON_EXCLUSIVE	47
>  #define KPF_READAHEAD		48
> -#define KPF_SLOB_FREE		49
>  #define KPF_SLUB_FROZEN		50
>  #define KPF_SLUB_DEBUG		51
>  #define KPF_FILE		61
> @@ -141,7 +140,6 @@ static const char * const page_flag_names[] = {
>  
>  	[KPF_ANON_EXCLUSIVE]	= "d:anon_exclusive",
>  	[KPF_READAHEAD]		= "I:readahead",
> -	[KPF_SLOB_FREE]		= "P:slob_free",
>  	[KPF_SLUB_FROZEN]	= "A:slub_frozen",
>  	[KPF_SLUB_DEBUG]	= "E:slub_debug",
>  
> @@ -478,10 +476,8 @@ static uint64_t expand_overloaded_flags(uint64_t flags, uint64_t pme)
>  	if ((flags & BIT(ANON)) && (flags & BIT(MAPPEDTODISK)))
>  		flags ^= BIT(MAPPEDTODISK) | BIT(ANON_EXCLUSIVE);
>  
> -	/* SLOB/SLUB overload several page flags */
> +	/* SLUB overloads several page flags */
>  	if (flags & BIT(SLAB)) {
> -		if (flags & BIT(PRIVATE))
> -			flags ^= BIT(PRIVATE) | BIT(SLOB_FREE);
>  		if (flags & BIT(ACTIVE))
>  			flags ^= BIT(ACTIVE) | BIT(SLUB_FROZEN);
>  		if (flags & BIT(ERROR))
> -- 
> 2.39.2

Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
