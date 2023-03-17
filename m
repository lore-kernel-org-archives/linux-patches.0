Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905CE33C9
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 11:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C39C433EF;
	Fri, 17 Mar 2023 11:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679053837;
	bh=P6v6r6R1v/vIPhHbXwX6vrqG7HQxKQSoSr5UuD/sfe8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eoboMQBI4H1dstMVVfHxogZFyfyDPor1l8SW8xAl6lz7GE1lpr3O6sa9m/r3REcSb
	 HHduvUkjIF7zmVcgJOGYZ77vsfhPvDntALJNAeRj16xA3FJg3ZbJs0M98SnFyYtSCZ
	 jaoH3BarvXIzLDi9aW0OTdeMD7zPAmeqonzv1vjuLZGuis6+DZp9yVk4RAG5JJ2Ejx
	 DshL6F1s26EDKFNdYR06vV0v/exEx0rSIP7VRIvc5mr6PivwRQe+2sjiincEM8nFK1
	 ec29bKOekazQ6d5Tpy5GrCPEeAVTa6ga2/MvPFyG8UmwaGUPamAmUpZwHsvLtUvNQe
	 rELVRh+ukTDmA==
Date: Fri, 17 Mar 2023 13:50:22 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-doc@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>
Subject: Re: [PATCH v2 2/6] mm, page_flags: remove PG_slob_free
Message-ID: <ZBRT/vUehBgby3TO@kernel.org>
References: <20230317104307.29328-1-vbabka@suse.cz>
 <20230317104307.29328-3-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317104307.29328-3-vbabka@suse.cz>

On Fri, Mar 17, 2023 at 11:43:03AM +0100, Vlastimil Babka wrote:
> With SLOB removed we no longer need the PG_slob_free alias for
> PG_private. Also update tools/mm/page-types.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>

Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>

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
> 

-- 
Sincerely yours,
Mike.
