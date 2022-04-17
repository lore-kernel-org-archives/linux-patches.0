Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C8E2C9D
	for <patches@lists.linux.dev>; Sun, 17 Apr 2022 20:56:47 +0000 (UTC)
Received: by mail-lf1-f47.google.com with SMTP id p10so21582932lfa.12
        for <patches@lists.linux.dev>; Sun, 17 Apr 2022 13:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DsyxLgNrrlFcEa7Y01Ulqliiz+Bkxw84zt+8RzzuZRo=;
        b=WXRtYH3k6SxBF/y/KFw7kiV8oQU8icffy4o+sluqUWmZ1tbNBig1mFI9GYeGtGdw1y
         uFQCY6mv+8o1UtvYz8mD/ZEpob40zlS8W5FIjQpHXzi0UUzCLQuiM9oWDenMmppAdKRb
         GmYRYlbNO68MYyq/zyzukR0j04JB6zUHJxzO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DsyxLgNrrlFcEa7Y01Ulqliiz+Bkxw84zt+8RzzuZRo=;
        b=GNInuSbBkqs6KGmiS8kj4qFDpBLD5AZH83sAoOoD0DTmKljLWw6N8WZRLfQCH9Gisd
         0lo8JZvXFGwrFs8qc6Lu75bMfPTkBea7uQlIYMKM/YidHLdb3baduvArBVE6OjMpg3JM
         W5rtvpEEhLAkAdPu2xENylDRyLRfE/+oRL9It2aMsIoMniqGBGNR6c+GXnVL6S42cAoA
         VJZeYZv27bBQWwQFkiWzMqgQrJ8hH90eXCChd4p2LsBSQBkrs4YIKSaB1luhB1ZPoqVG
         tierY64w3RJvRAixWf/d4VXl6b3ltnGfa3Y06B03vNaj3kuMsEsswVtUBR5qlzaSqwL9
         pDsQ==
X-Gm-Message-State: AOAM530zDdE6h1ifBovDt7qMB6jIti6Cd9NszVq/xwPrlvs0vFMPj1/l
	Lkb7c4I8KTBhHuip5B8t/ASCmPLpkXgOB8M7
X-Google-Smtp-Source: ABdhPJzcZu/63i7WsLtfz2zIMWURLoNbfoQQH30eG7suRoFMgz8k64WJVzd1K1GTSS549LGZOEUkQw==
X-Received: by 2002:ac2:5d6d:0:b0:46d:f50:7c7 with SMTP id h13-20020ac25d6d000000b0046d0f5007c7mr5928055lft.340.1650229005931;
        Sun, 17 Apr 2022 13:56:45 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id q17-20020a194311000000b0046fff294fa3sm664729lfa.193.2022.04.17.13.56.41
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 13:56:42 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id x33so21668549lfu.1
        for <patches@lists.linux.dev>; Sun, 17 Apr 2022 13:56:41 -0700 (PDT)
X-Received: by 2002:a05:6512:3055:b0:44a:3914:6603 with SMTP id
 b21-20020a056512305500b0044a39146603mr6024068lfb.435.1650229001342; Sun, 17
 Apr 2022 13:56:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org> <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic> <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic> <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic> <YlxtTNFP58TcUHZQ@zn.tnic>
In-Reply-To: <YlxtTNFP58TcUHZQ@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 17 Apr 2022 13:56:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
Message-ID: <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, Apr 17, 2022 at 12:41 PM Borislav Petkov <bp@alien8.de> wrote:
>
> Anyway, more playing with this later to make sure it really does what it
> should.

I think the special calling conventions have tripped you up:

>  SYM_FUNC_START(clear_user_original)
> -       ASM_STAC
>         movq %rcx,%rax
>         shrq $3,%rcx
>         andq $7,%rax
> @@ -86,7 +84,7 @@ SYM_FUNC_START(clear_user_original)
>         decl %ecx
>         jnz  2b
>
> -3:     ASM_CLAC
> +3:
>         movq %rcx,%rax
>         RET

That 'movq %rcx,%rax' can't be right. The caller expects it to be zero
on input and stay zero on output.

But I think "xorl %eax,%eax" is good, since %eax was used as a
temporary in that function.

And the comment above the function should be fixed too.

>  SYM_FUNC_START(clear_user_rep_good)
> -       ASM_STAC
>         movq %rcx,%rdx
> -       xorq %rax,%rax
>         shrq $3,%rcx
>         andq $7,%rdx
>
> @@ -118,7 +113,7 @@ SYM_FUNC_START(clear_user_rep_good)
>
>  1:     rep stosb
>
> -3:     ASM_CLAC
> +3:
>         movq %rcx,%rax
>         RET

Same issue here.

Probably nothing notices, since %rcx *does* end up containing the
right value, and it's _likely_ that the compiler doesn't actually end
up re-using the zero value in %rax after the inline asm (that this bug
has corrupted), but if the compiler ever goes "Oh, I put zero in %rax,
so I'll just use that afterwards", this is going to blow up very
spectacularly and be very hard to debug.

> @@ -135,15 +130,13 @@ EXPORT_SYMBOL(clear_user_rep_good)
>   *
>   * Output:
>   * rax uncopied bytes or 0 if successful.
> + *
> + * XXX: check for small sizes and call the original version.
> + * Benchmark it first though.
>   */
> -
>  SYM_FUNC_START(clear_user_erms)
> -       xorq %rax,%rax
> -       ASM_STAC
> -
>  0:     rep stosb
> -
> -3:     ASM_CLAC
> +3:
>         movq %rcx,%rax
>         RET

.. and one more time.

Also, I do think that the rep_good and erms cases should probably
check for small copes, and use the clear_user_original thing for %rcx
< 64 or something like that.

It's what we do on the memcpy side - and more importantly, it's the
only difference between "erms" and FSRM. If the ERMS code doesn't do
anything different for small copies, why have it at all?

But other than these small issues, it looks good to me.

                  Linus
