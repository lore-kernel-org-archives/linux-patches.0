Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09196627FD
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 17:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqF7SiFf"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-28b6ea19368so865689a91.1
        for <patches@lists.linux.dev>; Thu, 21 Dec 2023 09:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703180013; x=1703784813; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E1w4+dtGj/8F8JaerQ8KRIMdSrjR4dovsf8QQX0Vak4=;
        b=HqF7SiFfxueu+JtdZOcjSE39KV/sl8/O2OBLHUxuS149tv6+LwUQQq1BFZNKy8oHeE
         itQiSQuLoZAPJ0Kf7SZMgn9aoeTdFPvckRknmqBM6Hc6urlklOlv9ruHxJYgaWCxOJvi
         nWzpoJSuzRbjAf3wYJPblOP5IbQryCjmoBZRyoVQeT/UE/cgFhrUcJo8K8uHTLI2jWaz
         RhhGIJ58+UT8jdjXHoFm9rawb2zEUt9BPapRdChv1l+S1h83U16j+haDvNh8HJxDA3lB
         we7LZ2P0JEtByF3M3dNUXFGrWpEiCH9ABcD14NO03Vex1HAbrU9ciy1LA1rneq2dC5FY
         tesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703180013; x=1703784813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E1w4+dtGj/8F8JaerQ8KRIMdSrjR4dovsf8QQX0Vak4=;
        b=iY4GcqG14RL/P+hnAOIWHrg3h4i4ONwqyynSsknn1z064YsDn1Jvm8ySE+QzEyRW0y
         91JrqcldGstaHVaO0NBlp/elKXmyRQchljmvmVjurYuNi3ojlFbCQfKpNckd3UqWhsww
         Z8vv+vHCFyvPt6i7sXIRH74+XATSS7N1PaqjHJk62OzXEkhVfILeQx2zt2nP4Zqfk7U7
         UP0TywohxaLU8c61m9r8I6t7yAlIX4Jcycg0oVibYQvwaHSGXCEpeyF6lMGZwWxdpOJD
         J0OT60W/SZUxvioVVF/IZhxZaN93S/BPcbA9Ba21RbBQBlDeS/HiKqyD21VpNRzqEAeO
         WYpA==
X-Gm-Message-State: AOJu0YwCAST8/Y6TBUcqUPTHwNRtlzaE1jD0hP0MWnYESp5pP3GJvbxg
	1U9y2nMwuTz8dsNBhhYXymYF73CpVq9lwmID5eQ=
X-Google-Smtp-Source: AGHT+IFsL8/D5VxUmULRHQiMZ8ANxgatyXPvIfAIxc3jgvF2biAA1U6q1k2/LML0p8Rl2cVG3grKgaef3R5poLhQHGc=
X-Received: by 2002:a17:90b:46d7:b0:28b:e688:6b97 with SMTP id
 jx23-20020a17090b46d700b0028be6886b97mr95676pjb.1.1703180013162; Thu, 21 Dec
 2023 09:33:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231221-mark-unpoison_slab_object-as-static-v1-1-bf24f0982edc@kernel.org>
In-Reply-To: <20231221-mark-unpoison_slab_object-as-static-v1-1-bf24f0982edc@kernel.org>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 21 Dec 2023 18:33:21 +0100
Message-ID: <CA+fCnZfO6JyNvf7Wt7sOBoPKTX_UGexuWpyvgXYq9XSJEp-dLg@mail.gmail.com>
Subject: Re: [PATCH] kasan: Mark unpoison_slab_object() as static
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 21, 2023 at 6:27=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> With -Wmissing-prototypes enabled, there is a warning that
> unpoison_slab_object() has no prototype, breaking the build with
> CONFIG_WERROR=3Dy:
>
>   mm/kasan/common.c:271:6: error: no previous prototype for 'unpoison_sla=
b_object' [-Werror=3Dmissing-prototypes]
>     271 | void unpoison_slab_object(struct kmem_cache *cache, void *objec=
t, gfp_t flags,
>         |      ^~~~~~~~~~~~~~~~~~~~
>   cc1: all warnings being treated as errors
>
> Mark the function as static, as it is not used outside of this
> translation unit, clearing up the warning.
>
> Fixes: 3f38c3c5bc40 ("kasan: save alloc stack traces for mempool")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  mm/kasan/common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index ebb1b23d6480..563cda95240b 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -277,8 +277,8 @@ void __kasan_kfree_large(void *ptr, unsigned long ip)
>         /* The object will be poisoned by kasan_poison_pages(). */
>  }
>
> -void unpoison_slab_object(struct kmem_cache *cache, void *object, gfp_t =
flags,
> -                         bool init)
> +static void unpoison_slab_object(struct kmem_cache *cache, void *object,
> +                                gfp_t flags, bool init)
>  {
>         /*
>          * Unpoison the whole object. For kmalloc() allocations,
>
> ---
> base-commit: eacce8189e28717da6f44ee492b7404c636ae0de
> change-id: 20231221-mark-unpoison_slab_object-as-static-3bf224e1527f
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

I'll fold this fix into v2 if I end up resending the series.

Thank you, Nathan!
