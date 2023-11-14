Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CF3B66D
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DXjqIM9T"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1cc29f39e7aso33002475ad.0
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699937447; x=1700542247; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gSHaE/1GVg9mC1SVDtWharYt7nYPJBYXesltql5ggN0=;
        b=DXjqIM9TnK8MClP2unKudKjrxiVR5nZBsna+C0V1+Qk+T8pSSzCEWgeN7BRC0TneHQ
         Xs80yfxEnOq5UigX4sAsSua/C0oLnAKmTX4rvodfaLZb666Q/2hMpFRQOkqN0f33pSC+
         11H/qjfM1ttLvLKcsJRcnss+fQvhGhUvMA7iM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699937447; x=1700542247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSHaE/1GVg9mC1SVDtWharYt7nYPJBYXesltql5ggN0=;
        b=mIT/5tf2Omjg7Xx6E6APmFXu5DPiyBwfIywoU3R3VwLlLW3ry+a4SZB9F2G4/bH6DL
         dMFFkBB1hWIzkgCE84oAfQrWWW12lCgToFj0ayeWg1L4ZUmi6xPLCU6xvVmbz/dRonGx
         oCdiV3XGOrEUDx0HQCiKYbAAKpSpPpumgTP3Zml6GVdRoDSXXvYINuf3/1SD736Oh8dD
         OsRhhFU4kt+KN9hqDZ1I4cRQiYVOwAtdNGQD6N45KMW8EBacBC69QnT17OAS7o7oihFu
         m7TfQynh0U1PCIkeRC5wXYOhyB6bbM0h5gOqYrwhEh+ruSaKIYHzEGAw20JYrxG7FpD9
         fESA==
X-Gm-Message-State: AOJu0Yx69j5s1Dnm1Vi0O7V9eo2xbSBxYOAoVZQioqoLH7zLIMXG0v83
	VZXcj97ivppMzfo615ge94RrCA==
X-Google-Smtp-Source: AGHT+IF7Byd1ljDiTcsJ0NghEeEEgnKHX0+3r+3s8w6VMPI04pb7VCutEUrPIzMWjcVxqsPNaM8wIg==
X-Received: by 2002:a17:902:8b85:b0:1cc:474d:bdf9 with SMTP id ay5-20020a1709028b8500b001cc474dbdf9mr1243778plb.36.1699937447538;
        Mon, 13 Nov 2023 20:50:47 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902b58d00b001c9db5e2929sm4875757pls.93.2023.11.13.20.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:50:47 -0800 (PST)
Date: Mon, 13 Nov 2023 20:50:46 -0800
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
Subject: Re: [PATCH 18/20] mm/slub: remove slab_alloc() and
 __kmem_cache_alloc_lru() wrappers
Message-ID: <202311132048.B3AADC400@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-40-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-40-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:59PM +0100, Vlastimil Babka wrote:
> slab_alloc() is a thin wrapper around slab_alloc_node() with only one
> caller.  Replace with direct call of slab_alloc_node().
> __kmem_cache_alloc_lru() itself is a thin wrapper with two callers,
> so replace it with direct calls of slab_alloc_node() and
> trace_kmem_cache_alloc().

I'd have a sense that with 2 callers a wrapper is still useful?

> 
> This also makes sure _RET_IP_ has always the expected value and not
> depending on inlining decisions.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> [...]
>  void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
>  {
> -	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_, s->object_size);
> +	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_,
> +				    s->object_size);
>  

Whitespace change here isn't mentioned in the commit log.

Regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
