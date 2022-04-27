Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566F6621
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 01:29:38 +0000 (UTC)
Received: by mail-lf1-f43.google.com with SMTP id w1so613132lfa.4
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 18:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cuMemhK5xIsarCH9/oTmT9dxFi1jAyKuuZDdiuUgrA8=;
        b=TCP10/qe9Q7mX7BBVd9N5qR12JU4ZU7GN1Vdw0bT4WLE6GBs8lZf8d6pIMh6W99uuy
         +ByiZ0SKyNBKfVivB20Qfv1HcyYocCLPeMkZ8BxU77r8QuWnXeWbOUZeXPmIO/Ez4lFU
         QTV1CIUoDVtcWPB3PtminDbgmMVEToyNmLloo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cuMemhK5xIsarCH9/oTmT9dxFi1jAyKuuZDdiuUgrA8=;
        b=tXr6we3shTVfAgLpmwoxsxNyUlyPs/wzlkxooU0yNRb179PCF7hX4qGxrkrzFio5u8
         vV/HTe5kC3HNO3ta5YozNhn3aahj+FxaRAhj/B1uqoCxsme7RwUlUl5tR0ILZE1MP6op
         1RQ7VL6JkF6+RG+AxU5N9PyOjRtDJnWHu9MXgU5VNlz662J8JJ26IvnSy287kfg414vV
         ouAXEofEB9lkoVv00LB9WhD3HxPpp3TuZ4fjfFdiEy4eDNyMvvqO/YfwadCoKBp6GzRn
         8qL1WicA81BP9cCHllpPm4w7H9qEuThnzWANXETh88tfIhqIO4z0iQZ3QRWvr6fZqYi2
         Epfg==
X-Gm-Message-State: AOAM530qH8zgWhYGq/stQXKqFKrKxdnu+T7IOj1fpNFu4ADBu9rAMHMF
	tBcPiEcENRt/R3mSFJudD1lze6DTpbtdYzg0
X-Google-Smtp-Source: ABdhPJxy9/nYS+1vTUMxnibZXmO9l7JUvb5OXg2u0WkXTY+SB5CJlBvhnzmTzyzth8qU1eY1+4YiQw==
X-Received: by 2002:a19:ca0d:0:b0:472:1a4d:a67d with SMTP id a13-20020a19ca0d000000b004721a4da67dmr3846978lfg.222.1651022975870;
        Tue, 26 Apr 2022 18:29:35 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id t17-20020a192d51000000b0047212cead69sm470293lft.253.2022.04.26.18.29.33
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 18:29:34 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id p12so606404lfs.5
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 18:29:33 -0700 (PDT)
X-Received: by 2002:a05:6512:6c6:b0:472:296e:6dfb with SMTP id
 u6-20020a05651206c600b00472296e6dfbmr767509lff.542.1651022972680; Tue, 26 Apr
 2022 18:29:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic> <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic>
In-Reply-To: <YmiK7Bos+zLAvL0t@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Apr 2022 18:29:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
Message-ID: <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 26, 2022 at 5:14 PM Borislav Petkov <bp@alien8.de> wrote:
>
> So when we enter the function, we shift %rcx to get the number of
> qword-sized quantities to zero:
>
> SYM_FUNC_START(clear_user_original)
>         mov %rcx,%rax
>         shr $3,%rcx             # qwords        <---

Yes.

But that's what we do for "rep stosq" too, for all the same reasons.

> but when we encounter the fault here, we return *%rcx* - not %rcx << 3
> - latter being the *bytes* leftover which we *actually* need to return
> when we encounter the #PF.

Yes, but:

> So, we need to shift back when we fault during the qword-sized zeroing,
> i.e., full function below, see label 3 there.

No.

The problem is that you're using the wrong exception type.

Thanks for posting the whole thing, because that makes it much more obvious.

You have the exception table entries switched.

You should have

         _ASM_EXTABLE_TYPE_REG(0b, 3b, EX_TYPE_UCOPY_LEN8, %rax)
        _ASM_EXTABLE_UA(2b, 3b)

and not need that label '4' at all.

Note how that "_ASM_EXTABLE_TYPE_REG" thing is literally designed to do

   %rcx = 8*%rcx+%rax

in the exception handler.

Of course, to get that regular

        _ASM_EXTABLE_UA(2b, 3b)

to work, you need to have the final byte count in %rcx, not in %rax so
that means that the "now do the rest of the bytes" case should have
done something like

        movl %eax,%ecx
2:      movb $0,(%rdi)
        inc %rdi
        decl %ecx
        jnz  2b

instead.

Yeah, yeah, you could also use that _ASM_EXTABLE_TYPE_REG thing for
the second exception point, and keep %rcx as zero, and keep it in
%eax, and depend on that whole "%rcx = 8*%rcx+%rax" fixing it up, and
knowing that if an exception does *not* happen, %rcx will be zero from
the word-size loop.

But that really seems much too subtle for me - why not just keep
things in %rcx, and try to make this look as much as possible like the
"rep stosq + rep stosb" case?

And finally: I still think that those fancy exception table things are
*much* too fancy, and much too subtle, and much too complicated.

So I'd actually prefer to get rid of them entirely, and make the code
use the "no register changes" exception, and make the exception
handler do a proper site-specific fixup. At that point, you can get
rid of all the "mask bits early" logic, get rid of all the extraneous
'test' instructions, and make it all look something like below.

NOTE! I've intentionally kept the %eax thing using 32-bit instructions
- smaller encoding, and only the low three bits matter, so why
move/mask full 64 bits?

NOTE2! Entirely untested. But I tried to make the normal code do
minimal work, and then fix things up in the exception case more. So it
just keeps the original count in the 32 bits in %eax until it wants to
test it, and then uses the 'andl' to both mask and test. And the
exception case knows that, so it masks there too.

I dunno. But I really think that whole new _ASM_EXTABLE_TYPE_REG and
EX_TYPE_UCOPY_LEN8 was unnecessary.

               Linus

SYM_FUNC_START(clear_user_original)
        movl %ecx,%eax
        shrq $3,%rcx             # qwords
        jz .Lrest_bytes

        # do the qwords first
        .p2align 4
.Lqwords:
        movq $0,(%rdi)
        lea 8(%rdi),%rdi
        dec %rcx
        jnz .Lqwords

.Lrest_bytes:
        andl $7,%eax             # rest bytes
        jz .Lexit

        # now do the rest bytes
.Lbytes:
        movb $0,(%rdi)
        inc %rdi
        decl %eax
        jnz .Lbytes

.Lexit:
        xorl %eax,%eax
        RET

.Lqwords_exception:
        # convert qwords back into bytes to return to caller
        shlq $3, %rcx
        andl $7, %eax
        addq %rax,%rcx
        jmp .Lexit

.Lbytes_exception:
        movl %eax,%ecx
        jmp .Lexit

        _ASM_EXTABLE_UA(.Lqwords, .Lqwords_exception)
        _ASM_EXTABLE_UA(.Lbytes, .Lbytes_exception)
