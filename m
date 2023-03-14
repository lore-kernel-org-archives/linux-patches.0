Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0EA2CA6
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 22:12:48 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id l12so7420345wrm.10
        for <patches@lists.linux.dev>; Tue, 14 Mar 2023 15:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678831966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qrgGQA2tyR+reLrtZ5whteGjP4sWvnWfOZPTVunlkec=;
        b=dootni8CEgUsi8N+v99TYqgtssTXuvVp/SJIRgJDBFOVvoKGidWBw5oOLU/rK6wUYZ
         cBx4OYl7vRuuganKp+xfQJnhf9PvhzTSn8oqx+UwcFdyCrztDVJrGJ0BoRA61QY8n9dB
         bXtvntpsQFVfiKpejt/sGKe1X6no2rXrbdem1rvGl/XHFUtjsWOwrpmvjDfAgkESqqOP
         vPVGUCUMFdm8SPYFo+vC36K2c8rg80rhwuO7T0kmx3c3sTAYmhbzwD7QW75zmHiYXKda
         J2kdWKdWYyMBKkKuiGaS2WSjV4fjOtcq3NuLxGVaGGfoL4cZqZVpDYgM2dKFjLbFo5l9
         xkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678831966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qrgGQA2tyR+reLrtZ5whteGjP4sWvnWfOZPTVunlkec=;
        b=beYMBJAxuyuXySI9C5c6F3hTwdfBWf9kqTu/51N7am5OePdOPfVyHgpF8BXhnPiDW3
         OzG7gGTitX0Equ4HGxk4l5WhqvbN725tbNJrINpXFanZxEa1vb1tQs4Zqbhg0OwIy00r
         8dL/KKRFqx8R0IFCKQwN8f2So8fUfeT161cEG92qJRMBM5mFhEiLxUnj70epp4c0nVA1
         7AGFjEFQ9QTSVnA7GVWAM0IO31dirVRObsfeVP3tg+BWglOh+5DJbN933ekYZ0AJO7iT
         Sa2oSW9w0IP2MCP+mzFTRSU+a6nocwFK16+YBa6KK9KuATPSq02KdnDNpOd11NJLRBVA
         jG1g==
X-Gm-Message-State: AO0yUKWKdETHNJ9kH0AgimkHb9FdT93t0gFNR6dq38s+a0uOd/3fnzRh
	v+wp7SZ3BrF8QSYP0POIVwk=
X-Google-Smtp-Source: AK7set/Oe1mK8ERAeym3Py4UdCVU7k6qkgj+mP/p9KCj/wwe0GCzObLYhzO768PXTzSuipVfAJ9mgw==
X-Received: by 2002:a5d:4002:0:b0:2ce:a0c2:d9ed with SMTP id n2-20020a5d4002000000b002cea0c2d9edmr363419wrp.32.1678831966299;
        Tue, 14 Mar 2023 15:12:46 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id u7-20020a5d4687000000b002c5544b3a69sm3010241wrq.89.2023.03.14.15.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:12:45 -0700 (PDT)
Date: Tue, 14 Mar 2023 22:12:44 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/7] mm, page_flags: remove PG_slob_free
Message-ID: <eae5fe2b-aa09-47be-a039-6f518bc4d678@lucifer.local>
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
>

Looks good to me too,

Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>
