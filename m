Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267016FA9
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 07:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xOKsUw8c"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-7b9ff6d89e6so2115059241.3
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 23:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699948001; x=1700552801; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sX2ZDi+R3Ev6T5LlvMfvdN7qFs7PkFHPelflvttGDD4=;
        b=xOKsUw8c4GOOvjgbuF9aNYXzMGg4vjP9QvkL7pOTtk0BqtzJyWf4I7YhE1ji0FyL5m
         wKjWozxEQG+NVtxGjlQwSlKMtZwAaoWv1wvJuGJnC4/cJtW2WzNAdYUQbh827gD4LuPq
         rA62xxxIa4lU5NTy4RIrw5/heIQi8tz9av4So3JcpnyFNtJ+St/xqd0OsiQt8WS6MbSt
         +4PyzKKO+VAVG0tZ7xohfxv60eYVy+Secnv6dTZXiZm8XtiSHTRFphVXzZx/5UohgfW9
         4Kjeajc+6Ok0VqBfvibWjzbfRZUIIKwwY3ymMIXTu0FFC0ddK2uLdk+25w1sdqyMvyz5
         1pPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699948001; x=1700552801;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sX2ZDi+R3Ev6T5LlvMfvdN7qFs7PkFHPelflvttGDD4=;
        b=CMLh++tlWXqm9eXafzqeBIOr4qmORD8qCQdz37jjToHtXPOWjn9M8IN/WY/N89rh1G
         o9bus/UN1Q7C8hmEeP7jNe+v2Xdq5OEVcUzp+7JhRLxvt7vOaT9MeJ7CZTt907mOLD2B
         a6/FHHdoxacuhoHAXkE60U5wxDJn//jxd7Za2cVdcZfTDiVc89w9Js/HJtH+eaXQOXgK
         Jx4EGY12gU0WboM6B4n63rhoDWwkFZslrlXVKyDiCAS2G5wedpsg3y9+MZX5GmBWbI6o
         kP0vx8o80m2MqV9Lvti/OM5V6xF+4S8R51slfKTeY4xAdRJ8v7BZXIEP6mT29IGklf4I
         AxUw==
X-Gm-Message-State: AOJu0Yx99fL9nqg5MSL2EOtgH3hFFtczyrjQP3hMH5rz3d1k5Hnbwrko
	TUoP18fSMKhwYndV333UAZGgVTUOacmgpVHTkbQTTA==
X-Google-Smtp-Source: AGHT+IEkx9qpi9PxginlouXMsLXjDm4AhflR5GKJMwuObn7dBWpabAiTtV5tdjgAPRBqG6d0RnyHF3wv2N9uz3bxx2o=
X-Received: by 2002:a05:6102:2908:b0:460:621c:d14b with SMTP id
 cz8-20020a056102290800b00460621cd14bmr9815342vsb.20.1699948000802; Mon, 13
 Nov 2023 23:46:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231113191340.17482-22-vbabka@suse.cz> <20231113191340.17482-25-vbabka@suse.cz>
In-Reply-To: <20231113191340.17482-25-vbabka@suse.cz>
From: Marco Elver <elver@google.com>
Date: Tue, 14 Nov 2023 08:46:04 +0100
Message-ID: <CANpmjNOrA_nfMsu1eaTqauVfc53p5xHxO7TZAueVXyi5Qf9wAg@mail.gmail.com>
Subject: Re: [PATCH 03/20] KFENCE: cleanup kfence_guarded_alloc() after
 CONFIG_SLAB removal
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Kees Cook <keescook@chromium.org>, 
	kasan-dev@googlegroups.com, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Nov 2023 at 20:14, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> Some struct slab fields are initialized differently for SLAB and SLUB so
> we can simplify with SLUB being the only remaining allocator.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  mm/kfence/core.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 3872528d0963..8350f5c06f2e 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -463,11 +463,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
>         /* Set required slab fields. */
>         slab = virt_to_slab((void *)meta->addr);
>         slab->slab_cache = cache;
> -#if defined(CONFIG_SLUB)
>         slab->objects = 1;
> -#elif defined(CONFIG_SLAB)
> -       slab->s_mem = addr;
> -#endif
>
>         /* Memory initialization. */
>         set_canary(meta);
> --
> 2.42.1
>
