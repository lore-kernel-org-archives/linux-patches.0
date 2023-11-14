Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A57B64D
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ANR1BpJE"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6c34e87b571so4299913b3a.3
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699935280; x=1700540080; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z2Esu3+YQCIX73TjWrtGheLocNwWakeCmjYailfwoZQ=;
        b=ANR1BpJEnXOv3J6r7ZvM7CIvWaA1TAqpDZ/DcvZmIoqYH0L8L6V2LRehe9wVRUdoiv
         lo08Z+JiGi5bUvyV1lJktNldr62Ni50EVyFWSpwQ7kO7ubvnVOBePGfUCdbrdi12LgBU
         Zn0iQauH2tb6SaSfP2Em1JAzzR0q3NwBQtnuE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699935280; x=1700540080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2Esu3+YQCIX73TjWrtGheLocNwWakeCmjYailfwoZQ=;
        b=te1ibzx4ZSSPyoI3zZNWuv0Z+yAd1DfE9hixIMRCeEp3zZwQ6UZ3TClaIgh1nFT+Od
         I0MbfOv2owKGCnvK3e/sVRUPkNXlFHFr0a/dJn9KiwzqPSTHfKktDfMwQhK8O5XP+Akd
         7hoKix5OXx5yNIciQ403aumCWAbZITxADpLleVQBgsea6vkizi/xeXPKypg4ELB8NNqc
         zzuovX2xltyEbNq6cIZw3pRnkWiUrIWspZPc5iD3uwZI/ZfIebFuntJbtzt5x8/ufE7+
         XoD/LXjYt6xQykrz8PdeK4AifsfiggixDut5JNYftHtTzEsU0Ht/jSxEyCVmMHHrFU1I
         o3sw==
X-Gm-Message-State: AOJu0YxAMB0OqU3PVf8p+MKIam4wfOcmF+QoVlKE2mPb5iWa+nKyiJ2o
	1bufbZGgKEF9YGMGQBJqdQHt9Q==
X-Google-Smtp-Source: AGHT+IGCneV7PtQMzCmZ88wslaQb+x3DXpaYJcES4QpU4Zi4tRF8aU2Wpu3C/XhsasN/dPCLeWXBbQ==
X-Received: by 2002:a05:6a21:a598:b0:186:7842:ad0f with SMTP id gd24-20020a056a21a59800b001867842ad0fmr5685978pzc.31.1699935279698;
        Mon, 13 Nov 2023 20:14:39 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id o9-20020a170902778900b001ccb81e851bsm4739949pll.103.2023.11.13.20.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:14:38 -0800 (PST)
Date: Mon, 13 Nov 2023 20:14:38 -0800
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
Subject: Re: [PATCH 03/20] KFENCE: cleanup kfence_guarded_alloc() after
 CONFIG_SLAB removal
Message-ID: <202311132014.809B164D@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-25-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-25-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:44PM +0100, Vlastimil Babka wrote:
> Some struct slab fields are initialized differently for SLAB and SLUB so
> we can simplify with SLUB being the only remaining allocator.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
