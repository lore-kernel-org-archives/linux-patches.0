Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E4BBA53
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bWa9TRNC"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-28019b66ad5so4697371a91.3
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699936214; x=1700541014; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BVR/Ivq5aw+9huCWfoclhyK6Cz1m1uGsfFPrSjVP+os=;
        b=bWa9TRNC2ebqVFgy1+3yLYZpRUdzO3QxHC3ZrW45cWtg+MzwsOoEcFCtZpz+UtVxkD
         uy5zY7mpueQQfKfqPy3c5SgvkKzEqb9rWV5ASWGOw6bKTHTgnrh4URlMnZ81MgHVUwCv
         EPXRk/BhwTMOfIneINTr7jdDkXLichjb+sm9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699936214; x=1700541014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVR/Ivq5aw+9huCWfoclhyK6Cz1m1uGsfFPrSjVP+os=;
        b=ZApm0ieaC4Tcf70TZt00bC5pTd85AcLaZXdowpVpu16OhHKB472n6AqYiczk5SbMYl
         PSld2QRlhmuyk7MytBkBVoG+VBBjwwNHIhMXKxdq+buhi5nH55oOZvlWFjO0QeLTkDVQ
         cVojCmUDLBI7QpI5lWau1IpOOWDERAet5clKkvnIfXW+Ad2z2wLcmLht07Vb1JzVzfYc
         29nUWKnWuxTgZWDcqn8cgv1rvzfPDDBpDloxpNYaUw/XyCOA8GcgUgQ/aGwcbro58K+G
         ilh/omGchwCIzHe5Aj6bNw6HOA0kTss3WEo7gclWKBHGy1jV36Sol5hisGKIfBSDzszN
         T2nQ==
X-Gm-Message-State: AOJu0YzqBaSlDW0h4sydH+mSW7pWDunnsRfNuEEPxzSiXDtl/ZAmFQ7c
	mdZgnOZyvIEjvxm3V++rqxBngw==
X-Google-Smtp-Source: AGHT+IGHpiRYqf1wnawSvDbbqcUpNVvAlWIHQjTAdYW+tyahOMwSwXjVkxNjFnslO/Q+Xg7jd3gPkg==
X-Received: by 2002:a17:90b:1d06:b0:280:2823:6615 with SMTP id on6-20020a17090b1d0600b0028028236615mr8237152pjb.36.1699936214292;
        Mon, 13 Nov 2023 20:30:14 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l24-20020a17090aec1800b00280fcbbe774sm4405770pjy.10.2023.11.13.20.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:30:13 -0800 (PST)
Date: Mon, 13 Nov 2023 20:30:13 -0800
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
Subject: Re: [PATCH 06/20] mm/slab: remove CONFIG_SLAB code from slab common
 code
Message-ID: <202311132024.80A0D5D58@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-28-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-28-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:47PM +0100, Vlastimil Babka wrote:
> In slab_common.c and slab.h headers, we can now remove all code behind
> CONFIG_SLAB and CONFIG_DEBUG_SLAB ifdefs, and remove all CONFIG_SLUB
> ifdefs.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/slab.h | 13 +--------
>  mm/slab.h            | 69 ++++----------------------------------------
>  mm/slab_common.c     | 22 ++------------
>  3 files changed, 8 insertions(+), 96 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 34e43cddc520..90fb1f0d843a 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -24,7 +24,6 @@
>  
>  /*
>   * Flags to pass to kmem_cache_create().
> - * The ones marked DEBUG are only valid if CONFIG_DEBUG_SLAB is set.

I think this comment was wrong, yes? i.e. the "DEBUG" flags are also
used in SLUB?

Regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
