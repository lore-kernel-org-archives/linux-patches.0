Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DEA23D4
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 11:41:02 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 6so1359946pgm.6
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 03:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jCd6zgZ9Hqz9sR1Spt/uKXD2LWWaO3T2x6GLxEqyUkg=;
        b=aVtcbxcWGK5RCiec4i5uxxwG6QRkwATKRsEZtp+hNgtD6GKJBJMHXAXgiA4M9kOETk
         PZSbcC1I+uFxZI7U6tYmA+Ujthmm18YFZlhRFH7Vp77+Ipyuhbv2F/CDofWiu9yeZvdg
         usz4tJtMQNNpo4yyRcEC8rXBel62a2MIH86Wu5qqFgTa/B+ppw1RmC1wdQwvJWsSim2O
         RoeLGpgzmFM22+MJ1kj/D24r765zNqlZWuT08zaPCv/lLKAKipm+3OBCQiX3IRN3hqUu
         loOBXEMKQZWXo/N0E/TuxPcsgUDg/uhhA1jCEdcM3j3w3JQ3NgoSrjAKtpNwV5oy+7L2
         p+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCd6zgZ9Hqz9sR1Spt/uKXD2LWWaO3T2x6GLxEqyUkg=;
        b=lT4XS8NoAnrW2D0smzY+qgJL6sdlVqOA6sYhdiEGzkKerfZyrt2LiOGq8uD0+3qRI0
         wD5NbeDu2/P4T9B73GXv9d2V6b/jkUCXdQEnvhrLdmR+giP8EmE1Zwx8xy0sDb/o9x0J
         3iMSL8UyZLIFXRbpndUJqssHUiUVuJ/PrTHBqnC04BjvgXFBKzpoog7oDpQCNx9Kw/tH
         LChCM04zh6hxF8Uhfv6PYii9bnt79tbxWg2NIhI6MDpBgXe3ysWOHgIbo0p84fcjRYqk
         bblobTtbS+n7a+zbFi/fAnhghQOl3P/ErAkP06vlRTpcPzhhRXN0ubr1azylCdEnhZHd
         hjPA==
X-Gm-Message-State: ANoB5pmaCaPcxoIgQrefasc/yYBN8CjKaDUQOO6ixMPIfjuW4HaYob/B
	aBAmGhxg5Pyeo7ha/UX6OFQ=
X-Google-Smtp-Source: AA0mqf5wa9KogvZ0ibs8xKawXeQ7pWMiPHK8R57Xr6/6pRLZQZVtwvu7Pwy75DKI3kFZofZ+tgzfTA==
X-Received: by 2002:a63:fc49:0:b0:476:941a:8582 with SMTP id r9-20020a63fc49000000b00476941a8582mr11276389pgk.321.1669290062175;
        Thu, 24 Nov 2022 03:41:02 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090341cb00b00186b55e3cd6sm1098576ple.133.2022.11.24.03.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:41:01 -0800 (PST)
Date: Thu, 24 Nov 2022 20:40:55 +0900
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
Subject: Re: [PATCH 05/12] mm, slub: lower the default slub_max_order with
 CONFIG_SLUB_TINY
Message-ID: <Y39YR5nn6aUs2KRW@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-6-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121171202.22080-6-vbabka@suse.cz>

On Mon, Nov 21, 2022 at 06:11:55PM +0100, Vlastimil Babka wrote:
> With CONFIG_SLUB_TINY we want to minimize memory overhead. By lowering
> the default slub_max_order we can make slab allocations use smaller
> pages. However depending on object sizes, order-0 might not be the best
> due to increased fragmentation. When testing on a 8MB RAM k210 system by
> Damien Le Moal [1], slub_max_order=1 had the best results, so use that
> as the default for CONFIG_SLUB_TINY.
> 
> [1] https://lore.kernel.org/all/6a1883c4-4c3f-545a-90e8-2cd805bcf4ae@opensource.wdc.com/
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 917b79278bad..bf726dd00f7d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3888,7 +3888,8 @@ EXPORT_SYMBOL(kmem_cache_alloc_bulk);
>   * take the list_lock.
>   */
>  static unsigned int slub_min_order;
> -static unsigned int slub_max_order = PAGE_ALLOC_COSTLY_ORDER;
> +static unsigned int slub_max_order =
> +	IS_ENABLED(CONFIG_SLUB_TINY) ? 1 : PAGE_ALLOC_COSTLY_ORDER;
>  static unsigned int slub_min_objects;
>  
>  /*
> -- 
> 2.38.1
>

Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

-- 
Thanks,
Hyeonggon
