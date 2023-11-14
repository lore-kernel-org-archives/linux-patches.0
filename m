Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32E0B650
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XszGoouP"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1cc2575dfc7so37677545ad.1
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699935634; x=1700540434; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ew+aEAUFKMT5ddXwYjWs+9wP5nLqtY4565XxaEvPnVw=;
        b=XszGoouP5kY0+/V0BwdGO3Qryg0ZwJIuBBBxCMv526jgFiPrtRw/JwSkKq/lXwQQNL
         7u2foTscnCZ/VNro0YvxoT5L+wAgXAyzF8mxGYMnZ63ld0CruLgcfmtGHC443Hrt2FjM
         ziY3flcuExBBmr4VixSEaulU/7AMyQJMOU2mE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699935634; x=1700540434;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ew+aEAUFKMT5ddXwYjWs+9wP5nLqtY4565XxaEvPnVw=;
        b=EX4NwB+U/hN6pUOM8keb0vYl8h0Hn4mY1m9rZwqqJF2fq7sqp+yX+E/zGEDx/YO07v
         OE0pj3gQ04ZUL636EEZTS87GcwDUH1Yq+uQf3uUt1ST6f0SLszGs1pWAKuzj0D7ZScX7
         8shXvmiLG9pHJi9D0GwTK1x286SZMbBscfgXhXYdQjqKtS8bTx++ZI5FrYbf1ukc/rWK
         SVcy9xpEl9pjplnXPk63YncLlzNBehevDkLbSoG/zXjjXxwER/bBgT96vlk3sgxdo5vM
         qHpvbwh0BmtcymBquwuKsZe5XLm+xNdy+RaMubKjOTJIP+x+QqggEyOLRfOA8sgtUVrR
         Huhg==
X-Gm-Message-State: AOJu0YwEPFymnNyRoREQrc8tki/RfCcpDqEqjX6iKcmR4SR9561hnwfv
	B5bZT74PtVFVgRUe3A1R+StO7A==
X-Google-Smtp-Source: AGHT+IEEuR9OHz0h/+qyQyKe+kSZOUz74iG8+oSzIWHLFYokTNJRmRlv4PFje7Gdb+90MtEYK337Ug==
X-Received: by 2002:a17:903:260b:b0:1ce:171d:2795 with SMTP id jd11-20020a170903260b00b001ce171d2795mr1129493plb.65.1699935633849;
        Mon, 13 Nov 2023 20:20:33 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902d90200b001cc3875e658sm4792216plz.303.2023.11.13.20.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:20:33 -0800 (PST)
Date: Mon, 13 Nov 2023 20:20:32 -0800
From: Kees Cook <keescook@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>, kasan-dev@googlegroups.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH 05/20] cpu/hotplug: remove CPUHP_SLAB_PREPARE hooks
Message-ID: <202311132020.5A4B63D@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-27-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-27-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:46PM +0100, Vlastimil Babka wrote:
> The CPUHP_SLAB_PREPARE hooks are only used by SLAB which is removed.
> SLUB defines them as NULL, so we can remove those altogether.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/slab.h | 8 --------
>  kernel/cpu.c         | 5 -----
>  2 files changed, 13 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index d6d6ffeeb9a2..34e43cddc520 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -788,12 +788,4 @@ size_t kmalloc_size_roundup(size_t size);
>  
>  void __init kmem_cache_init_late(void);
>  
> -#if defined(CONFIG_SMP) && defined(CONFIG_SLAB)
> -int slab_prepare_cpu(unsigned int cpu);
> -int slab_dead_cpu(unsigned int cpu);
> -#else
> -#define slab_prepare_cpu	NULL
> -#define slab_dead_cpu		NULL
> -#endif
> -
>  #endif	/* _LINUX_SLAB_H */
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 9e4c6780adde..530b026d95a1 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -2125,11 +2125,6 @@ static struct cpuhp_step cpuhp_hp_states[] = {
>  		.startup.single		= relay_prepare_cpu,
>  		.teardown.single	= NULL,
>  	},
> -	[CPUHP_SLAB_PREPARE] = {
> -		.name			= "slab:prepare",
> -		.startup.single		= slab_prepare_cpu,
> -		.teardown.single	= slab_dead_cpu,
> -	},
>  	[CPUHP_RCUTREE_PREP] = {
>  		.name			= "RCU/tree:prepare",
>  		.startup.single		= rcutree_prepare_cpu,

Should CPUHP_SLAB_PREPARE be removed from the enum too?

-- 
Kees Cook
