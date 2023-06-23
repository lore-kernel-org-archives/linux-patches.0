Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F5C15A2
	for <patches@lists.linux.dev>; Fri, 23 Jun 2023 06:12:39 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-3f9c532f9e3so3942075e9.1
        for <patches@lists.linux.dev>; Thu, 22 Jun 2023 23:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687500757; x=1690092757;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cH76kt6UTmIx3qjb+jJaF/n8MOD0hF4u7nMAFs65XK0=;
        b=ablaUhmcEHIJieh3y2uEPumflActhxF3w2uUefbopG41DHD/4IguWMQM6LmV/eJhJt
         kpI7kJ5qu5GvsxvZSFC1bv08urkcOCWNjpGXKhMXgLLBQbjpZIHbnnDaNjtTfu7HrHqm
         D+CZvJKvv5wH8Yp01G63XjLTf7zlnBPerepHcijNPVszvDde1LQhbzMrLXjCJpo/RmXF
         fM0SVswubH6P8O9+WABzmAsRwQmO5592fKrXGcw1DKmZrnUtoslz7swOR3UT0Cg3Z6J0
         33bOaM6NV7AWp2EcM9SmM8h+gd5GPjLp3Ze0ZXCWJTo2EEnlJILk5ILZMoZbCi8Tgda8
         PsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687500757; x=1690092757;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cH76kt6UTmIx3qjb+jJaF/n8MOD0hF4u7nMAFs65XK0=;
        b=NtS09xv4QMz8H4ue0Wa9LYxOKjQzZVaRZXdJoaJQ4Sl2DZkolbCVOj33e2b80BrKXb
         agkNpTs+d5vLcdxpqCAb6U36ArnDFeAC5P9kFDEwvLgez35mKLeue4+/CBJMw1F/5PXW
         l4VuejMbC8EaOStAK+nYfq/DLPGLOHX3QwwOpMMBhx7tiETB0f8GrkVUdw4H9twfMyOd
         5zQEZcrqawocMZjnBTq1pO0aR7Cy0DfxxTyq4/lu3z0ZgMmGs0nJdhOCXq1IJ+kS+7RL
         JbxP3ym78f9/zZBU/tof94dsas8tkYUKezUovkrmqgtbPceO90QLim7Yk+7WEOp+2r9x
         yyAA==
X-Gm-Message-State: AC+VfDy0ZvQyWu5ngcbKxekNQcCm2MKEsCP0laDWj9cenHqPscwNU1v7
	s9Nrujpz/8brpiPYcIDdhAOz/A==
X-Google-Smtp-Source: ACHHUZ49+GAafnSTu35IsubJ8ajqMPMD2FfaOa0PM7wZ1CfvRVc4avU2TwVtAfElopHYu6azWxfjgA==
X-Received: by 2002:adf:ffce:0:b0:30a:ec3b:58d8 with SMTP id x14-20020adfffce000000b0030aec3b58d8mr16321353wrs.3.1687500757261;
        Thu, 22 Jun 2023 23:12:37 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r7-20020adfce87000000b0030af54c5f33sm8635028wrn.113.2023.06.22.23.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 23:12:35 -0700 (PDT)
Date: Fri, 23 Jun 2023 09:12:30 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, tsbogend@alpha.franken.de,
	sergio.paracuellos@gmail.com, sboyd@kernel.org, trix@redhat.com,
	linux-clk@vger.kernel.org, linux-mips@vger.kernel.org,
	patches@lists.linux.dev, llvm@lists.linux.dev
Subject: Re: [PATCH] clk: ralink: mtmips: Fix uninitialized use of ret in
 mtmips_register_{fixed,factor}_clocks()
Message-ID: <27507a23-c1f4-40b2-a999-d6ebd10269f0@moroto.mountain>
References: <20230622-mips-ralink-clk-wuninitialized-v1-1-ea9041240d10@kernel.org>
 <CAKwvOd=jaaf7jpjFYe=J0uBiOkGbY3hQ1JsSThp+171cyOsP7Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOd=jaaf7jpjFYe=J0uBiOkGbY3hQ1JsSThp+171cyOsP7Q@mail.gmail.com>

On Thu, Jun 22, 2023 at 09:36:53AM -0700, Nick Desaulniers wrote:
> On Thu, Jun 22, 2023 at 8:56 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Clang warns:
> >
> >   drivers/clk/ralink/clk-mtmips.c:309:9: error: variable 'ret' is uninitialized when used here [-Werror,-Wuninitialized]
> >     309 |         return ret;
> >         |                ^~~
> >   drivers/clk/ralink/clk-mtmips.c:285:9: note: initialize the variable 'ret' to silence this warning
> >     285 |         int ret, i;
> >         |                ^
> >         |                 = 0
> >   drivers/clk/ralink/clk-mtmips.c:359:9: error: variable 'ret' is uninitialized when used here [-Werror,-Wuninitialized]
> >     359 |         return ret;
> >         |                ^~~
> >   drivers/clk/ralink/clk-mtmips.c:335:9: note: initialize the variable 'ret' to silence this warning
> >     335 |         int ret, i;
> >         |                ^
> >         |                 = 0
> >   2 errors generated.
> >
> > Set ret to the return value of clk_hw_register_fixed_rate() using the
> > PTR_ERR() macro, which ensures ret is not used uninitialized, clearing
> > up the warning.
> >
> > Fixes: 6f3b15586eef ("clk: ralink: add clock and reset driver for MTMIPS SoCs")
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1879
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Thanks for the patch!
> PTR_ERR returns a long; assigning to an int risks truncation of the
> error.  The use of PTR_ERR on L1079 has a similar risk...]
> 

If PTR_ERR() ever returns anything outside of the (-4095)-(0) range then
we are already screwed.

I'm 90% sure there is a reason why PTR_ERR() returns long but I can't
think off the top of my head why that is...  It's been that way since
before the git era.  I could imagine type promotion bugs involving
u32 and int if we changed it.

	ssize_t ret_val = PTR_ERR(x) ?: u32_something;

Or maybe Linus just felt casting a pointer to int was ugly.

regards,
dan carpenter

