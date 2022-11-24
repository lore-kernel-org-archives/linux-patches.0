Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2559323D4
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 11:33:19 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id g62so1398795pfb.10
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 03:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6YMTx0dYsCXcdicmdhniq9bvZBuxl4kai8z8N0OctaU=;
        b=FL9D8iGgmgmofA5VoLVagb3Z/kMvnn1F9H88SIPRFUTcPk6RrqxMqEYrQKpo7zMF+H
         CBX887MkKNednTWCyU6O+ZKdoK5jgvF9Pmg5Qp2U4OdK9TGmd5s8opFFIw4tGNjnqaY0
         EU2j9GKQKe2WzveuiSd5XvPv2O7qrTGsKjJdEYX6pUUP3HCfzHXPAfUiD1VWafcuEPaW
         qYWKk+ol1OhOfWIxXSSXqW8W/QQF/7Ke+8DmUvy73ww5Yim97xi3GOUT2k4xJ42buJLu
         iuEpUDtWQpt7USLqKmZJ0W6YeZFgY2KClw9nKVfhuJ2mqBafYYvuIOlqro/vmE0jLNfj
         Oq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6YMTx0dYsCXcdicmdhniq9bvZBuxl4kai8z8N0OctaU=;
        b=5k6T7DmNmqmFoqTP3w/V2tzz0VzRU4OaPLn/pl7CxnO7+fGxH+LwVzypkvhuX7sy6n
         42efKM3eJQ484R2MLkyOYK4NT3zqeO6CSkJ2+1IVlPqvbK3Ip9lTgUp5nkG9vmR0Cm8K
         yoNFTG3PQA33m8/WCE8VhXreZte4EypGRvQhdvBGyJax4HkJzD7+2Li04La1IXlP3Y+W
         +/wJzV2xGBcqqGSwA+0t66x5y86tmKsN9vMBnsDO2jJMuXoRsSlxpGR6zeywQKbB+b/J
         Axrk6vQOWSQ5Vh36eKPu4QChWvMNI1ANjHjG8ae4yAfQ5WDka92SnYHo/omkiqvcttvb
         lfLw==
X-Gm-Message-State: ANoB5pkyeUkiLrCXfiv/uii12Btg8RXilQPNk5GkG6heZyD5WzdbDTqf
	xi7MNQGR8GWEQwCO006ZhZQ=
X-Google-Smtp-Source: AA0mqf4XlADXE9OvMpXzVxVnILOKztzIa1G613NCrC4ef+qIggfZ8kQ5+6tkPgi9VcJqts5f8LMmQA==
X-Received: by 2002:a63:5007:0:b0:45f:beda:4116 with SMTP id e7-20020a635007000000b0045fbeda4116mr12995905pgb.618.1669289599361;
        Thu, 24 Nov 2022 03:33:19 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id p20-20020a170902a41400b0018693643504sm1100620plq.40.2022.11.24.03.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:33:18 -0800 (PST)
Date: Thu, 24 Nov 2022 20:33:12 +0900
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
Subject: Re: [PATCH 02/12] mm, slub: add CONFIG_SLUB_TINY
Message-ID: <Y39WeEpboF4u7pP6@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-3-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121171202.22080-3-vbabka@suse.cz>

On Mon, Nov 21, 2022 at 06:11:52PM +0100, Vlastimil Babka wrote:
> For tiny systems that have used SLOB until now, SLUB might be
> impractical due to its higher memory usage. To help with that, introduce
> an option CONFIG_SLUB_TINY that modifies SLUB to use less memory.
> This is done by sacrificing scalability, security and debugging
> features, therefore not recommended for any system with more than 16MB
> RAM.
> 
> This commit introduces the option and uses it to set other related
> options in a way that reduces memory usage.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/Kconfig       | 21 +++++++++++++++++----
>  mm/Kconfig.debug |  2 +-
>  2 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 57e1d8c5b505..5941cb34e30d 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -230,6 +230,19 @@ config SLOB
>  
>  endchoice
>  
> +config SLUB_TINY
> +	bool "Configure SLUB for minimal memory footprint"
> +	depends on SLUB && EXPERT
> +	select SLAB_MERGE_DEFAULT
> +	help
> +	   Configures the SLUB allocator in a way to achieve minimal memory
> +	   footprint, sacrificing scalability, debugging and other features.
> +	   This is intended only for the smallest system that had used the
> +	   SLOB allocator and is not recommended for systems with more than
> +	   16MB RAM.
> +
> +	   If unsure, say N.
> +
>  config SLAB_MERGE_DEFAULT
>  	bool "Allow slab caches to be merged"
>  	default y
> @@ -247,7 +260,7 @@ config SLAB_MERGE_DEFAULT
>  
>  config SLAB_FREELIST_RANDOM
>  	bool "Randomize slab freelist"
> -	depends on SLAB || SLUB
> +	depends on SLAB || SLUB && !SLUB_TINY
>  	help
>  	  Randomizes the freelist order used on creating new pages. This
>  	  security feature reduces the predictability of the kernel slab
> @@ -255,7 +268,7 @@ config SLAB_FREELIST_RANDOM
>  
>  config SLAB_FREELIST_HARDENED
>  	bool "Harden slab freelist metadata"
> -	depends on SLAB || SLUB
> +	depends on SLAB || SLUB && !SLUB_TINY
>  	help
>  	  Many kernel heap attacks try to target slab cache metadata and
>  	  other infrastructure. This options makes minor performance
> @@ -267,7 +280,7 @@ config SLAB_FREELIST_HARDENED
>  config SLUB_STATS
>  	default n
>  	bool "Enable SLUB performance statistics"
> -	depends on SLUB && SYSFS
> +	depends on SLUB && SYSFS && !SLUB_TINY
>  	help
>  	  SLUB statistics are useful to debug SLUBs allocation behavior in
>  	  order find ways to optimize the allocator. This should never be
> @@ -279,7 +292,7 @@ config SLUB_STATS
>  
>  config SLUB_CPU_PARTIAL
>  	default y
> -	depends on SLUB && SMP
> +	depends on SLUB && SMP && !SLUB_TINY
>  	bool "SLUB per cpu partial cache"
>  	help
>  	  Per cpu partial caches accelerate objects allocation and freeing
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index ce8dded36de9..fca699ad1fb0 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -56,7 +56,7 @@ config DEBUG_SLAB
>  config SLUB_DEBUG
>  	default y
>  	bool "Enable SLUB debugging support" if EXPERT
> -	depends on SLUB && SYSFS
> +	depends on SLUB && SYSFS && !SLUB_TINY
>  	select STACKDEPOT if STACKTRACE_SUPPORT
>  	help
>  	  SLUB has extensive debug support features. Disabling these can
> -- 
> 2.38.1

Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

small comment:
SLAB || (SLUB && !SLUB_TINY) would be easier to interpret than
SLAB || SLUB && !SLUB_TINY

-- 
Thanks,
Hyeonggon
