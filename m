Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A6CBA26
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="k/OkfVRg"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6c4884521f6so4370530b3a.0
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699935186; x=1700539986; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+59LbEu2KNUEAvaciP4no1NYqRz3c5xA76P/RF2+jHM=;
        b=k/OkfVRgSmFX1qw2+MPG1JSCDWP1rBlW9VqvWOnmfIrszpscnvCSvXfEbjOKpGiLI1
         VWdWcJqGx51fOQAkw3u/LrHSx9DNIJbveukGCb6c19Pltf3yBKLXN9ZgRTAP3skhmN3W
         7Zmd3GvTvXpZR70hO9UhHcUXKCoe6CkpfBuZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699935186; x=1700539986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+59LbEu2KNUEAvaciP4no1NYqRz3c5xA76P/RF2+jHM=;
        b=kDHAqdLeSVSMmZHp4u5mj8HLaisBEciXv5zSSkpXRGSNf7iHLdghWo8uOT/IjtnpcV
         eYN1ewXehOGaPZKlfk+w1by4WWdrO4rhxa78c/TfcwHKs1saTSRJIXYHTrdTsb209ALI
         WcPJ5LX53krG/OFSMdQhm33sMZxF8YxLjLzu9z8bMVJtNs0SV9XCNU0UQjGomDBt8xM0
         +tQMf/x32jHP+x4+OKh/0Al6RlBmzoIoIIBV5oirFo97JhgE6QsuJlIkeJ/EuXMA/xm0
         SYTQJlate/aLXe2zvmVWaaY1e0nJQnLSR3ALsO603S/qAOzBBAdtDHmHq+DP8cedFdVx
         cyYg==
X-Gm-Message-State: AOJu0Yzr9yFFNV1/RKSvlmLhlpZMtDMNuydwC+mrdw7eqrnGnRP0geFz
	1ZJRxQN9uZbIyz7BRsJb9UoKhQ==
X-Google-Smtp-Source: AGHT+IFnyRA9Bn0/Hw8sxY38vdUYS60UHoNlHsJm70MG0sel5PqsKgmyNC3i7GG3PlPRUovMdSf9XQ==
X-Received: by 2002:a05:6a00:2d82:b0:6c3:45bc:41f8 with SMTP id fb2-20020a056a002d8200b006c345bc41f8mr7440255pfb.33.1699935185790;
        Mon, 13 Nov 2023 20:13:05 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b006933e71956dsm353045pfh.9.2023.11.13.20.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:13:05 -0800 (PST)
Date: Mon, 13 Nov 2023 20:13:04 -0800
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
Subject: Re: [PATCH 02/20] KASAN: remove code paths guarded by CONFIG_SLAB
Message-ID: <202311132012.142AC3618@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-24-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-24-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:43PM +0100, Vlastimil Babka wrote:
> With SLAB removed and SLUB the only remaining allocator, we can clean up
> some code that was depending on the choice.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
