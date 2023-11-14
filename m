Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE511857
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PKy1bVLT"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1cc3c51f830so39187615ad.1
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699936520; x=1700541320; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2qJn7DbKeJdLYDJu5dncSAZYv48TYbHL51nKAxUFFOc=;
        b=PKy1bVLTloImKx7AWwJC03CAi5I0B8SS0wJeAAOBq+ujzKGP6/FCkKluVCsgI44mWs
         XxiOF4yYtxgk/f0c8/u0Lyl1EqqSFXqGAD2llidq2V2LCrGWnw6h189J07rWutkZlK6p
         VrePLozwPwXZvuXt4+bT4hknnWjPbsJUMNWaQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699936520; x=1700541320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qJn7DbKeJdLYDJu5dncSAZYv48TYbHL51nKAxUFFOc=;
        b=eypH3PUCozPUCf4rzr7InKaqRbzHe43fI0avUifI5MRsbUjv1MlVjSTmDglP3Y+/6/
         5mzXYGTfnuju1lQ4w2KHQjprlOUIHYCozdnZ2BTh2yDNOOM8OSuzIHIfgg0Ou8baPyb4
         /Ic935qLvDZBCneJEWlMGx/ov6S8R8z6ntxfYar7WuOB44FhzMZRbS7sFsDmqkxDQ3Sq
         vuAhljjXzFM3eEwIEF3wyGq+vmHFBVHvkqhetkxPnjeV2S2figGKAXbQHwh7dD6e7Ncf
         O4EEs84HKS1Eh9JZMyx9zOZRCygj/UJaiUmFSu5KeKY3P4mRUnVBKURpKYmu0H98v1ly
         kOGw==
X-Gm-Message-State: AOJu0YxzMe7B1EDSnCTjDxdxOKdhrPOt9zY/FtFb7PVzIqNJ5OP6SkSs
	7QCNRZsJUR4YDJbBde7RwahiaQ==
X-Google-Smtp-Source: AGHT+IE2Kxwisuvac82p84jaALXF4xxfKmYC9mDZ5biXrUMK+/x45Z1bswMrDeJnNGtZLpoEhO/6PA==
X-Received: by 2002:a17:903:11d1:b0:1cc:6cc7:e29f with SMTP id q17-20020a17090311d100b001cc6cc7e29fmr1410299plh.43.1699936520572;
        Mon, 13 Nov 2023 20:35:20 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l18-20020a170903121200b001bf52834696sm4762331plh.207.2023.11.13.20.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:35:20 -0800 (PST)
Date: Mon, 13 Nov 2023 20:35:19 -0800
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
Subject: Re: [PATCH 09/20] mm/slab: move struct kmem_cache_cpu declaration to
 slub.c
Message-ID: <202311132035.A0F72C0F5@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-31-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-31-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:50PM +0100, Vlastimil Babka wrote:
> Nothing outside SLUB itself accesses the struct kmem_cache_cpu fields so
> it does not need to be declared in slub_def.h. This allows also to move
> enum stat_item.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
