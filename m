Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B7B8F51
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WFBXjX8D"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6bd73395bceso4082424b3a.0
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699937196; x=1700541996; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z0a8u4z+DUq7pMxicKnRyBLDUEkYlUYGe8Ef1Qv3STI=;
        b=WFBXjX8DDE3aIrh4lp5516c5C+Oguid5Vqfy8pXuEOXBxBCnlpOJQ3amCyvQBnv7Ym
         LAULHf1rUnjeYUDe9hNpr0Z/6Yhkzd7E6vmflccDgdC8KR4D+QeXMdWE/11fw0UJuI3X
         JvXdNmbEnd5QcZteIpMiWmdSVYDQ9m0mPrJ4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699937196; x=1700541996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z0a8u4z+DUq7pMxicKnRyBLDUEkYlUYGe8Ef1Qv3STI=;
        b=q6t3PhyHIrN2r/fUGfEEKtIxf0dZAWWtXw+yXhiGVfQMtFREajXKVDrlo2Jou0BS9Z
         6FjdgtQBQTBrzhm5GRvQy5y83kS3FHSBr97lgr9U06sOCDnUrHmQNXzcbaL12kWhi9+R
         rCk7rEa/mXSMA/WyOop6PNYvmGzPwmqaj/GgFnigfZad5IVSP2hmGDus2InVmkssCmzA
         bNnPPpZVZYpTLJTX2VoSSAdrTEjcw8opFPp5lPfEUbCh7BaXzTvJWOWbEAaKSvNXtau6
         tWsPqK91oaO9TUMRxjyRcU5iVw8nkk1Q+ZypPldUmEbnn3ucjzJC3VLkuq/AT97NDo4l
         85ag==
X-Gm-Message-State: AOJu0YyfXcgjSp9XTUT79v+Vb2jSUMs3/CzzqQuO5VHShvkOVxnEQClu
	XZlwfEAyP8ylxLgQJQ/pqM3tdA==
X-Google-Smtp-Source: AGHT+IGNQdjS2HSond40o2DEZuHcrsmwjNSXJJ6Otl8qWeHwrNfDjHKKQYMlq6qPVUmTUbyDR3kjJg==
X-Received: by 2002:a05:6a20:6a1c:b0:181:7d6d:c10b with SMTP id p28-20020a056a206a1c00b001817d6dc10bmr2434042pzk.7.1699937196532;
        Mon, 13 Nov 2023 20:46:36 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id hy13-20020a056a006a0d00b006c7ca969858sm398052pfb.82.2023.11.13.20.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:46:36 -0800 (PST)
Date: Mon, 13 Nov 2023 20:46:35 -0800
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
Subject: Re: [PATCH 17/20] mm/slab: move kmalloc() functions from
 slab_common.c to slub.c
Message-ID: <202311132046.04096EE39B@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-39-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-39-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:58PM +0100, Vlastimil Babka wrote:
> This will eliminate a call between compilation units through
> __kmem_cache_alloc_node() and allow better inlining of the allocation
> fast path.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
