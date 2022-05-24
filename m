Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B607F4
	for <patches@lists.linux.dev>; Tue, 24 May 2022 16:52:17 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id y13so35831539eje.2
        for <patches@lists.linux.dev>; Tue, 24 May 2022 09:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r/MuG6L5wg6ekbZqKkFBCkCsgRhVQuriQemtR5tAuqg=;
        b=GD0YwoCZ3S1CikkMRh9gYfg7qoT48l1Xa6UQr2p67srysKfZzcCTz/BRE42M9MvHXy
         r6CVpL37X9JBP6LzKjXB2VbbX0S27JFNl1Vp3NSPTgsvhxgjlBF47XC7zTM/3O9sNGG/
         bgJgMIBZIMuWPYgKHYjJmlEiPET6u2cOAE44g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r/MuG6L5wg6ekbZqKkFBCkCsgRhVQuriQemtR5tAuqg=;
        b=k90/ZrCr4L1YYmeLf8HmzrA5fyZMOYpo53WrOnN8ibRjc4zrPraAZMTQzlESU+Ye6H
         WfCCl+v/NP5NqNcSrVtWNbYIKKOm1xcY6IK4NSDfkne1kLaPz7sFfV0oNaftdpBNLlC9
         YcyXqKpi2e1nHU1vTcxnOFaX9+hT2J+KC+Z+U7y6u2fEgLLjYgZkzGhL67ydC67qq7wx
         CT1H2ZueyDq9WwNiRTatSnPfyDDEADDxKCNNyP6COeDnZj+z8R/UhdIl/2eC/i8woYGB
         JYtZxbUIoiIYv0BaqYfdVbQVul96qdD17fjms+DxA6QFKGlxahuyx276lMK1OMeaoqpa
         aF5Q==
X-Gm-Message-State: AOAM5303Nv2jKV38V/CSKnAoVVXIbuwYJRW0ut1daSbSkchPhOAohVxg
	0L7d664JaoagvBVRHjAdxsYLBD813Msxjaa9
X-Google-Smtp-Source: ABdhPJweNJi69uO2xWKRScdi6jVqdvMR2ICyNhxUssOxNSN0mb5YXrMpvS7vhnppGzHMuNU+25nl7g==
X-Received: by 2002:a17:906:c106:b0:6fe:a292:103b with SMTP id do6-20020a170906c10600b006fea292103bmr21172011ejc.668.1653411135633;
        Tue, 24 May 2022 09:52:15 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id w12-20020a170906130c00b006fec69a3978sm3213405ejb.207.2022.05.24.09.52.12
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 09:52:13 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id p19so2503804wmg.2
        for <patches@lists.linux.dev>; Tue, 24 May 2022 09:52:12 -0700 (PDT)
X-Received: by 2002:a7b:cb91:0:b0:397:3225:244 with SMTP id
 m17-20020a7bcb91000000b0039732250244mr4682864wmi.68.1653411132437; Tue, 24
 May 2022 09:52:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic> <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic> <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic> <Ynq1nVpu1xCpjnXm@zn.tnic> <YozQZMyQ0NDdD8cH@zn.tnic>
In-Reply-To: <YozQZMyQ0NDdD8cH@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 May 2022 09:51:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiJ9xqFrdDJtUD3oc1kCxYcVjLi5BjBY-3NVHgYxYb_HA@mail.gmail.com>
Message-ID: <CAHk-=wiJ9xqFrdDJtUD3oc1kCxYcVjLi5BjBY-3NVHgYxYb_HA@mail.gmail.com>
Subject: Re: [PATCH] x86/clear_user: Make it faster
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, May 24, 2022 at 5:32 AM Borislav Petkov <bp@alien8.de> wrote:
>
> finally a somewhat final version, lightly tested.

I can't find anything wrong with this, but who knows what
patch-blindness I have from looking at a few different versions of it.
Maybe my eyes just skim over it now.

I do note that the clearing of %rax here:

> +.Lerms_exit:
> +       xorl %eax,%eax
> +       RET

seems to be unnecessary, since %rax is never modified in the path
leading to this. But maybe just as well just for consistency with the
cases where it *is* used as a temporary.

And I still suspect that "copy_to_user()" is *much* more interesting
than "clear_user()", but I guess we can't inline it anyway due to all
the other overhead (ie access_ok() and stac/clac).

And for a plain "call memcpy/memset", we'd need compiler help to do
this (at a minimum, we'd have to have the compiler use the 'rep
movs/stos' register logic, and then we could patch things in place
afterwards, with objtool creating the alternatives section or
something).

                    Linus
