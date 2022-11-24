Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5062568
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 11:39:02 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id s196so1367774pgs.3
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 03:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+5EcPqvErNguuUSXQjM4Gsm5NRO9cAbvO2IWMkYz6pI=;
        b=SOJw3pGmknQGOs+cKA4lwYKRAW23GcKLpXI9bEcqXWNIZQmj6qZgdaeAgW05Rnk5dc
         WhjgRoHta5X4f1roJmi0k+NF6085ffRp8wWbmxxYvuOoIjK9sr5+LvgZzdqjfMl6yIg+
         Xf8hDCmBAfcJ209YFFw0LR09iN2AQ+/+2K4/BuHnK7hymbqFRZa3aCGBW+KbAGkgX8Ir
         7TYe9cW84y2OSlc6te7WF3uPvtw/VwhP5V+eJ1+34SQ12F9m5BlSCk24SXS/howNODnc
         5pUXdgbG4YKP8ViGGHEvYP69ji6BO1ElS1MW+4CXwbAxFUxPUpVdRmQiSzEjQn+UuitS
         sxsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5EcPqvErNguuUSXQjM4Gsm5NRO9cAbvO2IWMkYz6pI=;
        b=Z9/BE2shoGzPbhOaH9O0b/tZxCtfDRSHJ5rt97MnhOZwX0/+tZAqQPJb+4DSImpvnc
         nbBqRFV5ApsKiuWdNzzyTINh7r74pHPkxE5phIi7N3wLpQyGanLCSWg5AiU0UDeXh/sG
         7i0fEH8zduFLV3pbi5Ll2WKuPUR3ExJ6hQTMkbIZoRKaWKVaAPgezoC4Hf7xtcbSW1ot
         ar0XYF1egSXIu2ei8zhG7xbX3C4aiR8XtUk35M3v4WKhgj5nMG1WZNwxu6SM70x1830u
         SA4HjpjNRvB2wqaEUkmJ91RIzCFWdQ7xF3nie3KGX3ewO/loWC97R8aIfyOc2+IwtAd8
         /UAg==
X-Gm-Message-State: ANoB5pmewsnqd2j+81EXj5OIbPjVRI8XqY4YZOGXklZht1N1TXnN7yuo
	uAgCKa6P6nY1BDVVlZwK2eQ=
X-Google-Smtp-Source: AA0mqf6DoxIbI42ZFR91whRSV72DkyTzPOXE08yKJHXysCt+s0YkgN8Huvbe8ojyWrwoVjgC2BICdA==
X-Received: by 2002:a62:6083:0:b0:56d:3180:c7fc with SMTP id u125-20020a626083000000b0056d3180c7fcmr16238203pfb.41.1669289942391;
        Thu, 24 Nov 2022 03:39:02 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902684f00b00177e5d83d3esm1098955pln.88.2022.11.24.03.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:39:01 -0800 (PST)
Date: Thu, 24 Nov 2022 20:38:55 +0900
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
Subject: Re: [PATCH 04/12] mm, slub: retain no free slabs on partial list
 with CONFIG_SLUB_TINY
Message-ID: <Y39Xz9VbI2A8+bfe@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-5-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121171202.22080-5-vbabka@suse.cz>

On Mon, Nov 21, 2022 at 06:11:54PM +0100, Vlastimil Babka wrote:
> SLUB will leave a number of slabs on the partial list even if they are
> empty, to avoid some slab freeing and reallocation. The goal of
> CONFIG_SLUB_TINY is to minimize memory overhead, so set the limits to 0
> for immediate slab page freeing.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index ab085aa2f1f0..917b79278bad 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -241,6 +241,7 @@ static inline bool kmem_cache_has_cpu_partial(struct kmem_cache *s)
>  /* Enable to log cmpxchg failures */
>  #undef SLUB_DEBUG_CMPXCHG
>  
> +#ifndef CONFIG_SLUB_TINY
>  /*
>   * Minimum number of partial slabs. These will be left on the partial
>   * lists even if they are empty. kmem_cache_shrink may reclaim them.
> @@ -253,6 +254,10 @@ static inline bool kmem_cache_has_cpu_partial(struct kmem_cache *s)
>   * sort the partial list by the number of objects in use.
>   */
>  #define MAX_PARTIAL 10
> +#else
> +#define MIN_PARTIAL 0
> +#define MAX_PARTIAL 0
> +#endif
>  
>  #define DEBUG_DEFAULT_FLAGS (SLAB_CONSISTENCY_CHECKS | SLAB_RED_ZONE | \
>  				SLAB_POISON | SLAB_STORE_USER)
> -- 
> 2.38.1
> 

Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

-- 
Thanks,
Hyeonggon
