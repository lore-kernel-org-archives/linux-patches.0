Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74A8168D5
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="czX8Lh7S"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1cc5b705769so47246895ad.0
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699936312; x=1700541112; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VRGeaFnyf6oFg3w2q7Y0wKf4gObnq/HsTjuQwLGdqK8=;
        b=czX8Lh7SMkUmPjaq+3Jp8crVidnf4GM6iy8j/2JYUcJiA0WBYS/AZIl4nDNR0fEDoR
         q74Xfs9EAlLZ1iItChUbImh1mTUK9XzXO8rLpI6UvfyY7iWlbDETCDO/LGOpLJLuPfjB
         laA0lQa3MmEqOO8TwNTw2eAVPyewHuzuTsXKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699936312; x=1700541112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VRGeaFnyf6oFg3w2q7Y0wKf4gObnq/HsTjuQwLGdqK8=;
        b=AhmuT/q92GulzycouptL7T+IWYbZJhbLy5f6FWFQwM84Jd4fzWFLlQ5262dDagWaJ0
         eQhEOzipRh3O3L27kgdiIu8rRuBFG+FJZfgkU76ANyVhHhQPqAJ36J3f6KXUvvutWOSn
         MWky5yb7vgUUA2kn84wrYZ4vkYbp4jDlZJCHsdSXOOp9tnW8E5rZQjgRnROYpsrSF/hJ
         OpdGIbqCUAnqE1nH9rkC/MzkcCByTPz63Iden55KmetsPvtwwv6m4b0sLCyQhy54+CKc
         9GIH/xFVvlHud8foTG///nE5p4ze4Rh5OmITryEXzvMVex7ovkVG4RL2OfOSDZTWCVot
         pV+A==
X-Gm-Message-State: AOJu0Yy/Dm6jExvhPDqBFZ5C4c6TIn93iwKwfsrrF6VhQ5zOF8wFyLIY
	s62Y7ULLs0LwEB9AcJPdyEqWnA==
X-Google-Smtp-Source: AGHT+IFvceFQuU8pAlXLSAPEOVKfVP9ovqBBvtCeG6ahmhd48S+R6ZSbVzn8nuN1wKsAP5TgAinsRQ==
X-Received: by 2002:a17:903:2a8c:b0:1ce:8e4:111 with SMTP id lv12-20020a1709032a8c00b001ce08e40111mr1701477plb.27.1699936312112;
        Mon, 13 Nov 2023 20:31:52 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id u1-20020a170902bf4100b001bb9d6b1baasm4768235pls.198.2023.11.13.20.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:31:51 -0800 (PST)
Date: Mon, 13 Nov 2023 20:31:51 -0800
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
Subject: Re: [PATCH 07/20] mm/mempool/dmapool: remove CONFIG_DEBUG_SLAB ifdefs
Message-ID: <202311132030.1B2302BA4@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-29-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-29-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:48PM +0100, Vlastimil Babka wrote:
> CONFIG_DEBUG_SLAB is going away with CONFIG_SLAB, so remove dead ifdefs
> in mempool and dmapool code.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/dmapool.c | 2 +-
>  mm/mempool.c | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index a151a21e571b..f0bfc6c490f4 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -36,7 +36,7 @@
>  #include <linux/types.h>
>  #include <linux/wait.h>
>  
> -#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB_DEBUG_ON)
> +#ifdef CONFIG_SLUB_DEBUG_ON
>  #define DMAPOOL_DEBUG 1
>  #endif
>  
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 734bcf5afbb7..62dcbeb4c2a9 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -20,7 +20,7 @@
>  #include <linux/writeback.h>
>  #include "slab.h"
>  
> -#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB_DEBUG_ON)
> +#ifdef CONFIG_SLUB_DEBUG_ON
>  static void poison_error(mempool_t *pool, void *element, size_t size,
>  			 size_t byte)
>  {
> @@ -95,14 +95,14 @@ static void poison_element(mempool_t *pool, void *element)
>  		kunmap_atomic(addr);
>  	}
>  }
> -#else /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
> +#else /* CONFIG_SLUB_DEBUG_ON */
>  static inline void check_element(mempool_t *pool, void *element)
>  {
>  }
>  static inline void poison_element(mempool_t *pool, void *element)
>  {
>  }
> -#endif /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
> +#endif /*CONFIG_SLUB_DEBUG_ON */

nit: space after "*"

With that fixed:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
