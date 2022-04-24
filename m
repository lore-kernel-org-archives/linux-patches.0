Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC59F7C
	for <patches@lists.linux.dev>; Sun, 24 Apr 2022 20:24:35 +0000 (UTC)
Received: by mail-lj1-f182.google.com with SMTP id q14so15559850ljc.12
        for <patches@lists.linux.dev>; Sun, 24 Apr 2022 13:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8D1tjludKMiFebgWWVz4ujQ9Db5s730fW/dMT08kpsM=;
        b=B/znUTigREnkE9FGYtanhZgKzwF1BCsrwTatdUOzXcIQBpKPen5PEkOrDwrtwBSsa2
         rxNc/brlHn+IPbLFpZls+5ZVaWqq3eLMyIZDJcMiJq1TM+4IFVA/HfkJWn6RNLs4JSqh
         55EXE/t9HSnVgz4ZWkJHKOQQE73gr0ZuMmKzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8D1tjludKMiFebgWWVz4ujQ9Db5s730fW/dMT08kpsM=;
        b=Mzm8xRN/ZaO8A/Yp/E+Fpi+lqDfxl2FfmY/zKOIhG4E2g5ceceot/3C+a3Fa+QLyVo
         GkJhQLJy4DNCgzNg88YLnFMS3S/kj+67xCYpMukn9spuFNIXl2zJ5Z+dp6wx/TxdAMsw
         Y4I5p/l4I92gHaHvp2vPEC0ovO3UmdR5azcbZQ19kniNqlCyhwrikn8v9AdAHdZ2JqvQ
         zSrwYSkZpYfUIYQDTzKkEb9m/3SDuukgZ2e0YFkU0Dd8yPuRqc01BvTDwEMGQRoJuYuO
         PX0VVy1pxi692KOiXMCkU6QBKc6EKLbiZDxgWLQ4SAV7CYVrJiyckHMc9QGNZoy+87qF
         wMBA==
X-Gm-Message-State: AOAM5326BfKgAd2M77lL+RYhsPufnV4Yq8TtUx8Gr6pjngU7ErOzNEfK
	OuRXlZJTzXf1+dLIWQ0rbzMOkxpDlSNsysVPc40=
X-Google-Smtp-Source: ABdhPJzF1jht7A0ptEeAQmyHQiblt5F2EJIGOj/HWapZnnuVyYvt7r3eJU45KsePpGxCR7GqX3YCFQ==
X-Received: by 2002:a2e:bb88:0:b0:24d:bb5c:5555 with SMTP id y8-20020a2ebb88000000b0024dbb5c5555mr9117603lje.123.1650831873769;
        Sun, 24 Apr 2022 13:24:33 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id p41-20020a05651213a900b00443e2c39fc4sm1134786lfa.111.2022.04.24.13.24.31
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 13:24:32 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id n14so2212855lfu.13
        for <patches@lists.linux.dev>; Sun, 24 Apr 2022 13:24:31 -0700 (PDT)
X-Received: by 2002:a05:6512:1193:b0:471:af88:2d74 with SMTP id
 g19-20020a056512119300b00471af882d74mr10577735lfr.531.1650831871721; Sun, 24
 Apr 2022 13:24:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic> <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
In-Reply-To: <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Apr 2022 13:24:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiwbAUu3xs9c9-xxJrF1-OupynEEeXb+nzZ22wSz5M9Ug@mail.gmail.com>
Message-ID: <CAHk-=wiwbAUu3xs9c9-xxJrF1-OupynEEeXb+nzZ22wSz5M9Ug@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, Apr 24, 2022 at 12:54 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And last time we discussed this, Al was looking at making it
> byte-exact, and I'm pretty sure he noted that other architectures
> already didn't do always do it.
>
> Let me go try to find it.

Hmnm. I may have mis-remembered the details. The thread I was thinking
of was this:

   https://lore.kernel.org/all/20200719031733.GI2786714@ZenIV.linux.org.uk/

and while Al was arguing for not enforcing the exact byte count, he
still suggested that it must make *some* progress. But note the whole

 "There are two problems with that.  First of all, the promise was
  bogus - there are architectures where it is simply not true.  E.g. ppc
  (or alpha, or sparc, or...)  can have copy_from_user() called with source
  one word prior to an unmapped page, fetch that word, fail to fetch the next
  one and bugger off without doing any stores"

ie it's simply never been the case in general, and Al mentions ppc,
alpha and sparc as examples of architectures where it has not been
true.

(arm and arm64, btw, does seem to have the "try harder" byte copy loop
at the end, like x86 does).

And that's when I argued that we should just accept that the byte
exact behavior simply has never been reality, and we shouldn't even
try to make it be reality.

NOTE! We almost certainly do want to have some limit of how much off
we can be, though. I do *not* think we can just unroll the loop a ton,
and say "hey, we're doing copies in chunks of 16 words, so now we're
off by up to 128 bytes".

I'd suggest making it clear that being "off" by a word is fine,
because that's the natural thing for any architecture that needs to do
a "load low/high word" followed by "store aligned word" due to not
handling unaligned faults well (eg the whole traditional RISC thing).

And yes, I think it's actually somewhat detrimental to our test
coverage that x86 does the byte-exact thing, because it means that
*if* we have any code that depends on it, it will just happen to work
on x86, but then fail on architectures that don't get nearly the same
test coverage.

              Linus
