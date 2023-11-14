Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0BEB660
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MS1SkYt+"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6c4cf0aea06so4141015b3a.0
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699936894; x=1700541694; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eA82Hdspg/bY+CR7CFpsTdFZp4h7gtZ2SoVDA2UEAEM=;
        b=MS1SkYt+40Wdw6ZXaOr4Y26Rtpov/C4tcXTg1GLm3bur5D/qRfJgEAQgr445hcMm16
         q87Incf7e/FpjPvFXYEYVlNVNb9iUVtKlqBPDM1Z2IW7EKeHZfG7No02cFS/1vssiO4D
         Rn6ZRWLb9U7vBLT3lJDvP3lrsvc4dhubL0hj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699936894; x=1700541694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eA82Hdspg/bY+CR7CFpsTdFZp4h7gtZ2SoVDA2UEAEM=;
        b=WdqgP+dZhR14WSQTroBASMMcSEwVbN3P4KpSfv6MCFPky5IUFTZFgD2N+nyoQ+QAjo
         Nymb0BmuZsdbe2x4ta4B2M9DpF6uHdPfg/ZANEyA9f0RV42L6YeQhyDzyrnYXgxRRwMB
         8MOOVn3F7WuMRyIv3XnkEQxnbKaGMM3Pd9p0GsUKMlINmnHhZU/SL3MAnrycAMW2IcXL
         ezLj/N/WtNOFlVy4g1pLtmwCc9xPpMOrxyr1qfSR2b2JNwD/WKHlVvdf0iBBtf2/Pdmj
         IrQcNu2LuKjVNNIn3ze4DXA25sC7nZPizmru9liF9SMoBXzIfOpRsKel4Xgkm62toiki
         Gw/Q==
X-Gm-Message-State: AOJu0YzZ/UVhYZgd7aOfKe42tjRJ/66nW6FHQ/mEsl/KevzBVAEjw6+2
	b79LapGYWbU7NMaEV+rJpgs2fw==
X-Google-Smtp-Source: AGHT+IFUbqnfiVhlSCwWCV5DGdqS5OAFW8uF1N6KtxMGpaKCHywxvsAYJi+LSQYhPHziOoJn8xTdZQ==
X-Received: by 2002:a05:6a00:10c8:b0:6b8:a6d6:f51a with SMTP id d8-20020a056a0010c800b006b8a6d6f51amr9811289pfu.31.1699936893812;
        Mon, 13 Nov 2023 20:41:33 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id b13-20020a056a00114d00b006baa1cf561dsm395221pfm.0.2023.11.13.20.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:41:33 -0800 (PST)
Date: Mon, 13 Nov 2023 20:41:32 -0800
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
Subject: Re: [PATCH 11/20] mm/slab: consolidate includes in the internal
 mm/slab.h
Message-ID: <202311132039.7CC758A@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-33-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-33-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:52PM +0100, Vlastimil Babka wrote:
> The #include's are scattered at several places of the file, but it does
> not seem this is needed to prevent any include loops (anymore?) so
> consolidate them at the top. Also move the misplaced kmem_cache_init()
> declaration away from the top.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab.h | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 6e76216ac74e..c278f8b15251 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -1,10 +1,22 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef MM_SLAB_H
>  #define MM_SLAB_H
> +
> +#include <linux/reciprocal_div.h>
> +#include <linux/list_lru.h>
> +#include <linux/local_lock.h>
> +#include <linux/random.h>
> +#include <linux/kobject.h>
> +#include <linux/sched/mm.h>
> +#include <linux/memcontrol.h>
> +#include <linux/fault-inject.h>
> +#include <linux/kmemleak.h>
> +#include <linux/kfence.h>
> +#include <linux/kasan.h>

I've seen kernel code style in other places ask that includes be
organized alphabetically. Is the order here in this order for some
particular reason?

-- 
Kees Cook
