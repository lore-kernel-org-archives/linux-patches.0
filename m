Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CAB2F23
	for <patches@lists.linux.dev>; Wed,  4 May 2022 19:28:25 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id w1so4051485lfa.4
        for <patches@lists.linux.dev>; Wed, 04 May 2022 12:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bl4DsFmDfwvhyMeIDRKZ+MZU2qUZebxraWgPXLtE/5g=;
        b=ehxpRxo5gzBoJTc0GfE/8H6JBEvsN6M2waqrFAfJM3/amRzGZehEE2yL+0HKx0b+YA
         Pz/CMNCNVd14jevagAbqkG3+IRSEWHA4sziJUQa39BkiZStOD//nwHtCgsaypxe8Qwgf
         E1zfjx06w4nHOO9Ci2X2WVJ0fo+jDmCYrlXn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bl4DsFmDfwvhyMeIDRKZ+MZU2qUZebxraWgPXLtE/5g=;
        b=pygmjCg2Z5lM1neWOlzunAb5tttWmdj5ROPzMABBukKErEGT4vhrglnBskWvyON2UD
         K4A6MeTn8YMDGS2N++/Z+90xZXn7Yxh62BsF9T+vPmKWEL0qrvqjI++7iE2R/iQ6wc7G
         aSeprrOepkP9r9XXdC9SOBdOmPj+6q4m26jcu9uW9XXiUf9NLAH1QUeBhXPd+5zG8h/p
         XFON6aGJGpxtgVP5zNv9UNx6bilbbobnCzz3x6wKnYJ88L8FkwYXxEWHLSUoDnMVKL4T
         40iMDvViLtWioo+6r2+S5Dgd1A+wSdk9ZKpwAcAMRH4+u+IYrCiucZrF76RQuj6TqMpE
         ss7g==
X-Gm-Message-State: AOAM5338NepQpapi6AWqc0btzPwNHGCdDMuIGxhgmzbIiEu3nQL/ThZC
	lLql618HJMLi/UpfuLDxuiNONp6woRYZSZxYr3A=
X-Google-Smtp-Source: ABdhPJz5ZdGm2azTYnCzN6LkbWO9xj5M3JH9zPWy3Ie0lyKPhnxyFUzVT6pIQngwzJee99hCfLF/rg==
X-Received: by 2002:ac2:530c:0:b0:471:fa37:1123 with SMTP id c12-20020ac2530c000000b00471fa371123mr14927208lfh.397.1651692503412;
        Wed, 04 May 2022 12:28:23 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id v21-20020ac25935000000b0047255d210efsm1279348lfi.30.2022.05.04.12.28.22
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 12:28:23 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id i10so4012677lfg.13
        for <patches@lists.linux.dev>; Wed, 04 May 2022 12:28:22 -0700 (PDT)
X-Received: by 2002:a05:6512:b12:b0:44a:ba81:f874 with SMTP id
 w18-20020a0565120b1200b0044aba81f874mr15622518lfu.449.1651692171026; Wed, 04
 May 2022 12:22:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic>
 <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic>
In-Reply-To: <YnLMSWbz6BNfsBME@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2022 12:22:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
Message-ID: <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, May 4, 2022 at 11:56 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Just to update folks here: I haven't forgotten about this - Mel and I
> are running some benchmarks first and staring at results to see whether
> all the hoopla is even worth it.

Side note: the "do FSRM inline" would likely be a really good thing
for "copy_to_user()", more so than the silly "clear_user()" that we
realistically do almost nowhere.

I doubt you can find "clear_user()" outside of benchmarks (but hey,
people do odd things).

But "copy_to_user()" is everywhere, and the I$ advantage of inlining
it might be noticeable on some real loads.

I remember some git profiles having copy_to_user very high due to
fstat(), for example - cp_new_stat64 and friends.

Of course, I haven't profiled git in ages, but I doubt that has
changed. Many of those kinds of loads are all about name lookup and
stat (basic things like "make" would be that too, if it weren't for
the fact that it spends a _lot_ of its time in user space string
handling).

The inlining advantage would obviously only show up on CPUs that
actually do FSRM. Which I think is currently only Ice Lake. I don't
have access to one.

                Linus
