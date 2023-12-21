Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC64F5990A
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JlQyOrFf"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5cd86e3a9afso746673a12.1
        for <patches@lists.linux.dev>; Thu, 21 Dec 2023 10:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703181618; x=1703786418; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VDdp8WfkBByjzDwq6Ok/AjXzstviyjPC8n93eKiHrkU=;
        b=JlQyOrFfQqSj13anV+gMdqmZeN2NMoDUb6/p48piivkC3xHqsUIpelTi1SHjE7gbVd
         IzaiJPNSnx4s7Nq82iWg6v3g8zKsHVfz1lIBpN12W0JDePRNfmfx17LUpLmfpf5L/f1V
         yc0pO7XqNhaXRhLgcAzdCGr6N5QxG2dD/q0VbYMyOh6ZZuTcqmPzWiGBaRyZgHLl5EAN
         uDua0V+a/VUdrV4S2DG12msiq+J2XcnLhrZv0y2nzwLM9rUsWN2LUlqELkwxKH7WL0xV
         pjJ8GFTfEvASOgaDZyRnuKRm/SBHbNiKFJJUIFQEy2Gv/RlNQQO/4OQwWO2lqDONXU3V
         7WOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703181618; x=1703786418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VDdp8WfkBByjzDwq6Ok/AjXzstviyjPC8n93eKiHrkU=;
        b=vs/WuvyZ5LXzgRz8IIHnyeVyUt+YZV8aYAxSj66DSrdrk+snSwjMO7cJpdgwCnBpFf
         8M4Dacr+2lUFtWJOxsDmtiQY/MZP9hGW3Z5Qetmjdg7BKZXcM62UJaAmBOcGPpAYlcG+
         QzwVMWzep7NW8LZpTm3QVoyFppPbXv+I03SdNMYNho85KLKn7V8O28k7rRq6VJ7w5w6E
         6LmS2V7tnQMlU6S3wlUZFXxgckwQtcJgvx6oHK6c75G0B4VPL+jN2io0ctDEVoz6nTHw
         HfWjziegHam4HydlIZGpXLPpLFIeOl5E4VoZUn7gWaHKJHQgRCfshGGGC+2VMgRG6WGT
         d9Lg==
X-Gm-Message-State: AOJu0YxfI445VF3W/VbefZPIUTlIfwjp0RbfcpU9bBIPoXuH2H2WvEgP
	iF+xYJuCJYDjAAs5UIjXTKjE16EjCmiCG3tKyYY=
X-Google-Smtp-Source: AGHT+IFuOW7jV74kdaQ1EiZtJSMtFg/uNlhiKGSob025+0Bow6FzWbsJR4rVvjKcJbmkGB4HDsUiaIOAL3kQagZSPIQ=
X-Received: by 2002:a05:6a20:394b:b0:194:3af:19ca with SMTP id
 r11-20020a056a20394b00b0019403af19camr61272pzg.47.1703181617939; Thu, 21 Dec
 2023 10:00:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231221-mark-unpoison_slab_object-as-static-v1-1-bf24f0982edc@kernel.org>
 <CA+fCnZfO6JyNvf7Wt7sOBoPKTX_UGexuWpyvgXYq9XSJEp-dLg@mail.gmail.com>
In-Reply-To: <CA+fCnZfO6JyNvf7Wt7sOBoPKTX_UGexuWpyvgXYq9XSJEp-dLg@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 21 Dec 2023 19:00:07 +0100
Message-ID: <CA+fCnZcPmxCOpAucAJd=WoNHUeA5TpmLeRs+zei8E63Se-xP4Q@mail.gmail.com>
Subject: Re: [PATCH] kasan: Mark unpoison_slab_object() as static
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 21, 2023 at 6:33=E2=80=AFPM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> On Thu, Dec 21, 2023 at 6:27=E2=80=AFPM Nathan Chancellor <nathan@kernel.=
org> wrote:
> >
> > With -Wmissing-prototypes enabled, there is a warning that
> > unpoison_slab_object() has no prototype, breaking the build with
> > CONFIG_WERROR=3Dy:
> >
> >   mm/kasan/common.c:271:6: error: no previous prototype for 'unpoison_s=
lab_object' [-Werror=3Dmissing-prototypes]
> >     271 | void unpoison_slab_object(struct kmem_cache *cache, void *obj=
ect, gfp_t flags,
> >         |      ^~~~~~~~~~~~~~~~~~~~
> >   cc1: all warnings being treated as errors
> >
> > Mark the function as static, as it is not used outside of this
> > translation unit, clearing up the warning.
> >
> > Fixes: 3f38c3c5bc40 ("kasan: save alloc stack traces for mempool")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  mm/kasan/common.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> > index ebb1b23d6480..563cda95240b 100644
> > --- a/mm/kasan/common.c
> > +++ b/mm/kasan/common.c
> > @@ -277,8 +277,8 @@ void __kasan_kfree_large(void *ptr, unsigned long i=
p)
> >         /* The object will be poisoned by kasan_poison_pages(). */
> >  }
> >
> > -void unpoison_slab_object(struct kmem_cache *cache, void *object, gfp_=
t flags,
> > -                         bool init)
> > +static void unpoison_slab_object(struct kmem_cache *cache, void *objec=
t,
> > +                                gfp_t flags, bool init)
> >  {
> >         /*
> >          * Unpoison the whole object. For kmalloc() allocations,
> >
> > ---
> > base-commit: eacce8189e28717da6f44ee492b7404c636ae0de
> > change-id: 20231221-mark-unpoison_slab_object-as-static-3bf224e1527f
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >
>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
>
> I'll fold this fix into v2 if I end up resending the series.
>
> Thank you, Nathan!

Let's actually mark it as "static inline", I'll send a v2.
