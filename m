Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27A78F70
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="k0QwcH60"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1f256362bb5so3143527fac.0
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699935103; x=1700539903; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+4yq4rGlFBGUUVelo6loa8LJ3whEhAhDSYlb9+Og4U=;
        b=k0QwcH605OYAzTa4nUSgqi0TBgjqhYjTw3/SbL4akmZWW+7idKepao2qI2GZOHG7cp
         ewOFbm5fsiJzzsvuAh0E3+ufPfn34qsFTIVG0LFCUlMQZ0taDOQH3DCBWYxX1Z7Yq5qw
         yl1qwQCIxZohvD0QkS943Uw6yUM3ODruyBbeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699935103; x=1700539903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n+4yq4rGlFBGUUVelo6loa8LJ3whEhAhDSYlb9+Og4U=;
        b=gQAgrPsSTZ8B043oN27RlnSsI7bp8W32jydF5thWYCB+NzJKgzWwE8R2qHk5/v8bAU
         k+fXU7qsxYfVw92SLiWwigz/Dcc4p/SnO7LW8gzd2FMNaMIGWEiGfKSuBQZoQ6pCQw6N
         MZniObYXOOwAPwONYswDUWkzE03uWTUj1py+vvTnvc+ls1lYR3ELnuzON49YI25FLtjC
         PIZEqs/omYTTeweteV4HSU2hitEqn8O9mAu1FsSvGCvD5Z4QCk+iPCuZp6writ+UQXIO
         8euzY7M4yhVG9w8awHdeoygCSY1YVSTqj8XGqTJTg3p58e3tGiX5smqzEhAQnGAp9xpq
         aMTA==
X-Gm-Message-State: AOJu0YzirkEEU1hSrmavdaNukBlIeC0WbxNXoTNnfTeAyzfS/dmjF0Hd
	ib5jtZYK2v+75iVQvMjQvMnGZQ==
X-Google-Smtp-Source: AGHT+IEfNarlWdnfTnb+4lj9a61ndeE58KtCzt4cIWOf0C0hGaQoDCR9asaBxInqDvXXBZ8V8HT8ig==
X-Received: by 2002:a05:6870:b155:b0:1ef:62fc:d51c with SMTP id a21-20020a056870b15500b001ef62fcd51cmr10394447oal.51.1699935102819;
        Mon, 13 Nov 2023 20:11:42 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id fz10-20020a17090b024a00b00268b439a0cbsm4292411pjb.23.2023.11.13.20.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:11:42 -0800 (PST)
Date: Mon, 13 Nov 2023 20:11:41 -0800
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
Subject: Re: [PATCH 01/20] mm/slab: remove CONFIG_SLAB from all Kconfig and
 Makefile
Message-ID: <202311132009.8329C2F5D@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-23-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-23-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:42PM +0100, Vlastimil Babka wrote:
> Remove CONFIG_SLAB, CONFIG_DEBUG_SLAB, CONFIG_SLAB_DEPRECATED and
> everything in Kconfig files and mm/Makefile that depends on those. Since
> SLUB is the only remaining allocator, remove the allocator choice, make
> CONFIG_SLUB a "def_bool y" for now and remove all explicit dependencies
> on SLUB as it's now always enabled.
> 
> Everything under #ifdef CONFIG_SLAB, and mm/slab.c is now dead code, all
> code under #ifdef CONFIG_SLUB is now always compiled.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> [...]
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 89971a894b60..766aa8f8e553 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -228,47 +228,12 @@ config ZSMALLOC_CHAIN_SIZE
>  
>  menu "SLAB allocator options"

Should this be "Slab allocator options" ? (I've always understood
"slab" to mean the general idea, and "SLAB" to mean the particular
implementation.

Regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
