Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A860C7C
	for <patches@lists.linux.dev>; Sun, 24 Apr 2022 19:55:18 +0000 (UTC)
Received: by mail-lf1-f54.google.com with SMTP id x17so22866472lfa.10
        for <patches@lists.linux.dev>; Sun, 24 Apr 2022 12:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LLHrC18vqO4mAkzdZZc8nx6SJWE+jfgShrpAIINRfoE=;
        b=EdsexeSGCi4k+MyrihuimqWCq1Wu41k8sNbO7+/sbse2JMHu0Iv9yNxRjmA9oZYxE+
         Orvp/Y/ct3CmG6lrZ4yp8YX79dWSC9Oef/kSYIBtDo5AjFMU5RHfs1pwXYhW2ddthYpB
         a/NKPJjwB/aNxIQQPCcuct2n9voSoTmgtvA0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LLHrC18vqO4mAkzdZZc8nx6SJWE+jfgShrpAIINRfoE=;
        b=oHiWjxb+e7txRsTO9GKwGeW2p2rTVS+QH+pU7iX1CD7ttrqqdWflk2F7vT4XdM3wwD
         Zayzpj7z7wj9B36pY3S9UgEKBJ+y3bGn5i3Jx1ul/UC3jxir37okAyfKdeYFLjtnHNv/
         GCHrjjkhozl5xA+ij4CRH/HEv2btb+ZIW40Ch4GqidW9VhhFNQkonYcnvEN7hNfWpETa
         92rh9EdyZFqxUr0gUOETLCS9E8zofFm3uSk3JJYzpRIBhYZ/DCRLwBX7v+8/WnDfPBdC
         bZPyQEHktOfUtPQw/U81ze+boRQublYwke32nHRIF1kQw9YICU4D6BTjoPIlBnWARjh6
         a4Kw==
X-Gm-Message-State: AOAM533WdZ5T/Y4JBkx9w5Sqn/HNToZvluQbokO8T4Y2Hn8WvTkxbqgv
	bNnqlgSSsHaBB1crx6AqVjdcfLQ41n2rv/5U
X-Google-Smtp-Source: ABdhPJwRpi5qwoFraQIBSZv3EFQtMTN5Ycw5rEIWWYtGcqAehTLFYdGpLRM2VqcxodqxJFBs/GsDAA==
X-Received: by 2002:ac2:4bcb:0:b0:471:ec56:1513 with SMTP id o11-20020ac24bcb000000b00471ec561513mr7941180lfq.174.1650830116343;
        Sun, 24 Apr 2022 12:55:16 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id k16-20020a192d10000000b0046ba99878a6sm1127688lfj.17.2022.04.24.12.55.14
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 12:55:15 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id y19so4257080ljd.4
        for <patches@lists.linux.dev>; Sun, 24 Apr 2022 12:55:14 -0700 (PDT)
X-Received: by 2002:a2e:934b:0:b0:24f:cce:5501 with SMTP id
 m11-20020a2e934b000000b0024f0cce5501mr3034323ljh.443.1650830114045; Sun, 24
 Apr 2022 12:55:14 -0700 (PDT)
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
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com> <YmWm5AXdwgwu57KZ@zn.tnic>
In-Reply-To: <YmWm5AXdwgwu57KZ@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Apr 2022 12:54:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
Message-ID: <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, Apr 24, 2022 at 12:37 PM Borislav Petkov <bp@alien8.de> wrote:
>
> You could give me some more details but AFAIU, you mean, that
> fallback to byte-sized reads is unnecessary and I can get rid of
> copy_user_handle_tail? Because that would be a nice cleanup.

Yeah, we already don't have that fallback in many other places.

For example: traditionally we implemented fixed-size small
copy_to/from_user() with get/put_user().

We don't do that any more, but see commit 4b842e4e25b1 ("x86: get rid
of small constant size cases in raw_copy_{to,from}_user()") and
realize how it historically never did the byte-loop fallback.

The "clear_user()" case is another example of something that was never
byte-exact.

And last time we discussed this, Al was looking at making it
byte-exact, and I'm pretty sure he noted that other architectures
already didn't do always do it.

Let me go try to find it.

> Anyway, I ran your short prog and it all looks like you predicted it:

Well, this actually shows a bug.

> fsrm:
> ----
> read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 17

The above is good.

> erms:
> -----
> read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 17

This is good too: erms should do small copies with the expanded case,
but sicne it *thinks* it's a large copy, it will just use "rep movsb"
and be byte-exact.

> rep_good:
> ---------
> read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 16

This is good: it starts off with "rep movsq", does two iterations, and
then fails on the third word, so it only succeeds for 16 bytes.

> original:
> ---------
> read(3, strace: umoven: short read (17 < 33) @0x7f3ff61d5fef
> 0x7f3ff61d5fef, 65536)          = 3586

This is broken.

And I'm *not* talking about the strace warning. The strace warning is
actually just a *result* of the kernel bug.

Look at that return value. It returns '3586'. That's just pure garbage.

So that 'original' routine simply returns the wrong value.

I suspect it's a %rax vs %rcx confusion again, but with your "patch on
top of earlier patch" I didn't go and sort it out.

                   Linus
