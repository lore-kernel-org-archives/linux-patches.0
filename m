Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6087E6
	for <patches@lists.linux.dev>; Wed, 29 Nov 2023 20:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XxuQpl2P"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4644967b4adso45731137.3
        for <patches@lists.linux.dev>; Wed, 29 Nov 2023 12:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701291333; x=1701896133; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mh8mfkKmbZyezogReiTmoJ2/ZEYTC/jfxX54yQ12YVc=;
        b=XxuQpl2PRcfmudaW/GDJ8Gw+OG2kktapKvghBOMRyGSfRreOW8C480VQ4PUMnTtxfq
         kMcRMPsyaHEhMXBf9mvJ9ROVHVdnTuOHYVEZlDsUx8dTqHbobTPyyq+sfBIf+cWLNV5z
         HTo8kcJXVOycLVfiks+5aDc3cMplr1HOpDHCHdyRZiENjGEhHylVaB/F0+dZLdAICBY0
         4YpYXThTuKoSsFjLE9hVVJJHI432PMHMI65De9FSwO2Oa+dSpXwtOFh+S1stw2CRX7Yu
         xAAGTBBz8Pis3Vd+aIJdzaOnQdZ7kHkAAoakVqPfPDeMY+1cziTK3WOkMvlpRUtUqEGu
         2TBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701291333; x=1701896133;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mh8mfkKmbZyezogReiTmoJ2/ZEYTC/jfxX54yQ12YVc=;
        b=q4rAsu/svfEYVG6iCo9xnaDm92q/W9juQUz1LQw+VkTAXRqEf+Aa2yImlO6VAstXgn
         /0cvqBjXR3FVnZRx969r5qSJgga9rT4Hl+DKidszl3MNIMfN/lTcC/2hkWDXgcxJPcXQ
         oIFtYwcQXhWnZcMmVRaDy6stbK0aBRBcK3TdPfBHqM5hcZ/VYDpn9Z3yQPzROXNYthqg
         prfD1ivRxPAm9DMWjZYdwiCa+kv9FHv+5wG9FtCdVKv6HkzYdc6ulk0cp29rLvUmhRGx
         UVqQjOvPupnG0uwawRfQkLIvJH1OdmjiFTISeLKdx9KX6Ig0oTn8epGRjCKu6+fbhakS
         bX+Q==
X-Gm-Message-State: AOJu0Yzniga5CTy2qyMoKt8Q4Rrp5gPTusyUyDVgMA2Ti9X96QsX6ZEv
	7X8xMhrEAC01K9V64jdcjQ8bv5dY5fqPB4XxWumeww==
X-Google-Smtp-Source: AGHT+IHZofM+mWPqplXKo3oO5HK96UwBHrlAhtemO+AXxBVHuzRUX5DN/4Q8F5GFPbEvlwAl5R5uHEJrdpwE3tWD9CA=
X-Received: by 2002:a05:6102:244f:b0:464:4d97:2c01 with SMTP id
 g15-20020a056102244f00b004644d972c01mr2523133vss.31.1701291332997; Wed, 29
 Nov 2023 12:55:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231127234946.2514120-1-swboyd@chromium.org> <202311291219.A6E3E58@keescook>
 <CAE-0n53x8AXUPaq5_TaqF6PN5u5J6g5RYoNWALN-MnEJBa5syA@mail.gmail.com>
In-Reply-To: <CAE-0n53x8AXUPaq5_TaqF6PN5u5J6g5RYoNWALN-MnEJBa5syA@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Wed, 29 Nov 2023 21:54:54 +0100
Message-ID: <CANpmjNP9Koro2FKS9xG5LDvOvyRKrQBFkyKhJVSsqFJdEE+peA@mail.gmail.com>
Subject: Re: [PATCH] lkdtm: Add kfence read after free crash type
To: Stephen Boyd <swboyd@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 29 Nov 2023 at 21:42, Stephen Boyd <swboyd@chromium.org> wrote:
>
> Adding kfence folks (will add on v2).
>
> Quoting Kees Cook (2023-11-29 12:22:27)
> > On Mon, Nov 27, 2023 at 03:49:45PM -0800, Stephen Boyd wrote:
> > > Add the ability to allocate memory from kfence and trigger a read after
> > > free on that memory to validate that kfence is working properly. This is
> > > used by ChromeOS integration tests to validate that kfence errors can be
> > > collected on user devices and parsed properly.
> >
> > This looks really good; thanks for adding this!
> >
> > >
> > > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > > ---
> > >  drivers/misc/lkdtm/heap.c | 64 +++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 64 insertions(+)
> > >
> > > diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
> > > index 0ce4cbf6abda..608872bcc7e0 100644
> > > --- a/drivers/misc/lkdtm/heap.c
> > > +++ b/drivers/misc/lkdtm/heap.c
> > > @@ -4,6 +4,7 @@
> > >   * page allocation and slab allocations.
> > >   */
> > >  #include "lkdtm.h"
> > > +#include <linux/kfence.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/vmalloc.h>
> > >  #include <linux/sched.h>
> > > @@ -132,6 +133,66 @@ static void lkdtm_READ_AFTER_FREE(void)
> > >       kfree(val);
> > >  }
> > >
> > > +#if IS_ENABLED(CONFIG_KFENCE)
> >
> > I really try hard to avoid having tests disappear depending on configs,
> > and instead report the expected failure case (as you have). Can this be
> > built without the IS_ENABLED() tests?
> >
>
> We need IS_ENABLED() for the kfence_sample_interval variable. I suppose
> if the config isn't set that variable can be assumed as zero and then
> the timeout would hit immediately. We can either define the name
> 'kfence_sample_interval' as 0 in the header, or put an ifdef in the
> function.

I think it's fair to put it in the kfence header, so you don't need
the #ifdefs in the test code.

We didn't think anyone should depend on kfence_sample_interval outside
KFENCE code, but probably only tests would anyway.

> ---8<---
> diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
> index 4f467d3972a6..574d0aa726dc 100644
> --- a/drivers/misc/lkdtm/heap.c
> +++ b/drivers/misc/lkdtm/heap.c
> @@ -138,6 +138,14 @@ static void lkdtm_KFENCE_READ_AFTER_FREE(void)
>         int *base, val, saw;
>         unsigned long timeout, resched_after;
>         size_t len = 1024;
> +       unsigned long interval;
> +
> +#ifdef CONFIG_KFENCE
> +       interval = kfence_sample_interval;
> +#else
> +       interval = 0;
> +#endif
> +
>         /*
>          * The slub allocator will use the either the first word or
>          * the middle of the allocation to store the free pointer,
> @@ -150,13 +158,13 @@ static void lkdtm_KFENCE_READ_AFTER_FREE(void)
>          * 100x the sample interval should be more than enough to ensure we get
>          * a KFENCE allocation eventually.
>          */
> -       timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
> +       timeout = jiffies + msecs_to_jiffies(100 * interval);
>         /*
>          * Especially for non-preemption kernels, ensure the allocation-gate
>          * timer can catch up: after @resched_after, every failed allocation
>          * attempt yields, to ensure the allocation-gate timer is scheduled.
>          */
> -       resched_after = jiffies + msecs_to_jiffies(kfence_sample_interval);
> +       resched_after = jiffies + msecs_to_jiffies(interval);
>         do {
>                 base = kmalloc(len, GFP_KERNEL);
>                 if (!base) {
>
> ---8<----
> diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> index 401af4757514..88100cc9caba 100644
> --- a/include/linux/kfence.h
> +++ b/include/linux/kfence.h
> @@ -223,6 +223,8 @@ bool __kfence_obj_info(struct kmem_obj_info *kpp,
> void *object, struct slab *sla
>
>  #else /* CONFIG_KFENCE */
>
> +#define kfence_sample_interval (0)
> +
>  static inline bool is_kfence_address(const void *addr) { return false; }
>  static inline void kfence_alloc_pool_and_metadata(void) { }
>  static inline void kfence_init(void) { }

Acked-by: Marco Elver <elver@google.com>

FWIW, I've occasionally been using repeatedly invoked READ_AFTER_FREE
to test if KFENCE is working. Having a dedicated test like this seems
more reliable though.
