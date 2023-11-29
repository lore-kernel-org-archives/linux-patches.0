Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261E9219EF
	for <patches@lists.linux.dev>; Wed, 29 Nov 2023 20:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="f3PGnF6r"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2c9c03dac8aso3227451fa.0
        for <patches@lists.linux.dev>; Wed, 29 Nov 2023 12:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701290535; x=1701895335; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SjyD2uy7rhiIwUguKMOS6O61vfhptuzTgpHO35Q0vkM=;
        b=f3PGnF6r3ODBgTp6SyO/Li/bp5ZF/wB5T9NtqK4f1yTI8gNGE4eSDMoTbAVIhsz6pV
         d3x4CO+bGPMPHSQ8VmZPyz/2VRPZl9vDuuneXSwI9IQZJEp4OlmB5hF8vo2psuHvPASI
         Or9GNegnSEQ2S4GHVBG5wp8Q3HlydHIYBFY1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701290535; x=1701895335;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SjyD2uy7rhiIwUguKMOS6O61vfhptuzTgpHO35Q0vkM=;
        b=bSlbs46mZan/2BVmkNcwLPGAeEyyga/hEq1VmOdYuFCtVMeFoKQ/VBQrnTw/oIrCZe
         IGkJS5IawjuoxWegEdR+EnFoudD4oAfvo3ezkC6ZoyS9j03WbKHhf5wMCg4B/GJoEAbH
         ZPlWAjWMc3w5IhZ9wdlthw5iK0JURxpSq7gNGX01BvBOZ9C8cO7cyTM0l30lYsI2Jon+
         LtV/azHm2f6MZxAfVRbzRZcwAZWtqM9lQw+Gow4AmgRXeAcG0Ptsuu5h/JlTl3POeqVV
         GinHhqmEgrjGCmDIv6rNoQgpF3m1kfqsJYh+sul2FUU+t9FoA9n6au2rsb4Z+8IX61cX
         8B/w==
X-Gm-Message-State: AOJu0Yzxg30F/QWHYw/DHnwlJkjmFaXDmYJRhIfslh0etB6seunc+RbF
	tqCjtZmWt4ejfI8SDfmhmKABMONXtFX+vMbVxfhMYw==
X-Google-Smtp-Source: AGHT+IGLtBi/LhsApUdsOPv/Q/7AseQ1qifIjVFc58wVFu+pFHvSnzJz7JInqQ9Npx4mSLCP14BLJFdwCOSfEaqh9eA=
X-Received: by 2002:a2e:9d8e:0:b0:2c9:c22e:31eb with SMTP id
 c14-20020a2e9d8e000000b002c9c22e31ebmr1958958ljj.22.1701290534275; Wed, 29
 Nov 2023 12:42:14 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 29 Nov 2023 12:42:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <202311291219.A6E3E58@keescook>
References: <20231127234946.2514120-1-swboyd@chromium.org> <202311291219.A6E3E58@keescook>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 29 Nov 2023 12:42:13 -0800
Message-ID: <CAE-0n53x8AXUPaq5_TaqF6PN5u5J6g5RYoNWALN-MnEJBa5syA@mail.gmail.com>
Subject: Re: [PATCH] lkdtm: Add kfence read after free crash type
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Adding kfence folks (will add on v2).

Quoting Kees Cook (2023-11-29 12:22:27)
> On Mon, Nov 27, 2023 at 03:49:45PM -0800, Stephen Boyd wrote:
> > Add the ability to allocate memory from kfence and trigger a read after
> > free on that memory to validate that kfence is working properly. This is
> > used by ChromeOS integration tests to validate that kfence errors can be
> > collected on user devices and parsed properly.
>
> This looks really good; thanks for adding this!
>
> >
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >  drivers/misc/lkdtm/heap.c | 64 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 64 insertions(+)
> >
> > diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
> > index 0ce4cbf6abda..608872bcc7e0 100644
> > --- a/drivers/misc/lkdtm/heap.c
> > +++ b/drivers/misc/lkdtm/heap.c
> > @@ -4,6 +4,7 @@
> >   * page allocation and slab allocations.
> >   */
> >  #include "lkdtm.h"
> > +#include <linux/kfence.h>
> >  #include <linux/slab.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/sched.h>
> > @@ -132,6 +133,66 @@ static void lkdtm_READ_AFTER_FREE(void)
> >       kfree(val);
> >  }
> >
> > +#if IS_ENABLED(CONFIG_KFENCE)
>
> I really try hard to avoid having tests disappear depending on configs,
> and instead report the expected failure case (as you have). Can this be
> built without the IS_ENABLED() tests?
>

We need IS_ENABLED() for the kfence_sample_interval variable. I suppose
if the config isn't set that variable can be assumed as zero and then
the timeout would hit immediately. We can either define the name
'kfence_sample_interval' as 0 in the header, or put an ifdef in the
function.

---8<---
diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
index 4f467d3972a6..574d0aa726dc 100644
--- a/drivers/misc/lkdtm/heap.c
+++ b/drivers/misc/lkdtm/heap.c
@@ -138,6 +138,14 @@ static void lkdtm_KFENCE_READ_AFTER_FREE(void)
 	int *base, val, saw;
 	unsigned long timeout, resched_after;
 	size_t len = 1024;
+	unsigned long interval;
+
+#ifdef CONFIG_KFENCE
+	interval = kfence_sample_interval;
+#else
+	interval = 0;
+#endif
+
 	/*
 	 * The slub allocator will use the either the first word or
 	 * the middle of the allocation to store the free pointer,
@@ -150,13 +158,13 @@ static void lkdtm_KFENCE_READ_AFTER_FREE(void)
 	 * 100x the sample interval should be more than enough to ensure we get
 	 * a KFENCE allocation eventually.
 	 */
-	timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
+	timeout = jiffies + msecs_to_jiffies(100 * interval);
 	/*
 	 * Especially for non-preemption kernels, ensure the allocation-gate
 	 * timer can catch up: after @resched_after, every failed allocation
 	 * attempt yields, to ensure the allocation-gate timer is scheduled.
 	 */
-	resched_after = jiffies + msecs_to_jiffies(kfence_sample_interval);
+	resched_after = jiffies + msecs_to_jiffies(interval);
 	do {
 		base = kmalloc(len, GFP_KERNEL);
 		if (!base) {

---8<----
diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 401af4757514..88100cc9caba 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -223,6 +223,8 @@ bool __kfence_obj_info(struct kmem_obj_info *kpp,
void *object, struct slab *sla

 #else /* CONFIG_KFENCE */

+#define kfence_sample_interval	(0)
+
 static inline bool is_kfence_address(const void *addr) { return false; }
 static inline void kfence_alloc_pool_and_metadata(void) { }
 static inline void kfence_init(void) { }
