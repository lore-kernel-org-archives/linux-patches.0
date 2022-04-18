Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A789AA29
	for <patches@lists.linux.dev>; Mon, 18 Apr 2022 17:11:03 +0000 (UTC)
Received: by mail-lf1-f50.google.com with SMTP id bq30so25141653lfb.3
        for <patches@lists.linux.dev>; Mon, 18 Apr 2022 10:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JnfBKZjgF0QAT2+ZNkrVkIt3p+ZK2qll9C8ReRWwK94=;
        b=N/kozEv3htHzVB9QEynfrlQU/Mv+YKRQ+Usc9cumiP5Mmpjh7RTikZqiiUaqpeWnlX
         cPoGWW1kY4AhKXsnK+qQTcNnOhTGfJIve2qIABJfHTK8YQyvK1KPMYZxO+iuDVgjUoj9
         Idk6AkYvv0WfNah3F8jeBIGSzSMzsddOwZ3UA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JnfBKZjgF0QAT2+ZNkrVkIt3p+ZK2qll9C8ReRWwK94=;
        b=3R0WV8plG8LpAhiTZsK+mB66D4ewPqCFz+waZQz3JKanUy9Fzebp4G4XvIWP2dBaTe
         S9OXAmcy+DXJuMuBufW/CW4nalgP93ypGeZ6V7M1/Ugn9Pte++Uc0chpZ02V4cHcADRe
         mDTFPgOuPfiUljYSPc4k2z58PGA6SRId2gTVRQ3gni8GUp/TxAF0WfiY85lCH8yY7t4s
         4KYQFXAkJIPr7mYBBTdV4dQIXWJbFGx0yeE7skdxyZvsO0T7N6b+z3EuL1k1WYDKouL0
         cFz6q0NpTTRt3QzDDbGsHmdiIXjLWTqkE7gMJ4As8KQWEeF06uel9vHJ8+fVmXtwYhKz
         JlwQ==
X-Gm-Message-State: AOAM532WF3aqcJos0MUjUaadzQT/JcoLhP/Zv4YmJj1B3zsyjMOtvqnm
	+TzrnwvghZ5zlXkQLaJP3CdPwxTPOwXFC7lCgG8=
X-Google-Smtp-Source: ABdhPJzAWW8WVLNLPtLi5A0UrueCUNMiP0psg0Plvp9GRESIHnZaLSdE2zsDZ5JWw5tf2rTj7IAzIA==
X-Received: by 2002:a19:7717:0:b0:46b:be15:db05 with SMTP id s23-20020a197717000000b0046bbe15db05mr8615549lfc.326.1650301861434;
        Mon, 18 Apr 2022 10:11:01 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id s11-20020a2e9c0b000000b0024ace83744asm1226635lji.116.2022.04.18.10.10.59
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 10:11:00 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id y32so25124361lfa.6
        for <patches@lists.linux.dev>; Mon, 18 Apr 2022 10:10:59 -0700 (PDT)
X-Received: by 2002:a05:6512:2291:b0:46b:b72b:c947 with SMTP id
 f17-20020a056512229100b0046bb72bc947mr8563401lfu.531.1650301859252; Mon, 18
 Apr 2022 10:10:59 -0700 (PDT)
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
 <Ylsx5PwyUPOainHa@zn.tnic> <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic>
In-Reply-To: <Yl06PWVgeZplboXV@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Apr 2022 10:10:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
Message-ID: <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 18, 2022 at 3:15 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Yah, wanted to singlestep that whole asm anyway to make sure it is good.
> And just started going through it - I think it can be even optimized a
> bit to use %rax for the rest bytes and decrement it into 0 eventually.

Ugh. If you do this, you need to have a big comment about how that
%rcx value gets fixed up with EX_TYPE_UCOPY_LEN (which basically ends
up doing "%rcx = %rcx*8+%rax" in ex_handler_ucopy_len() for the
exception case).

Plus you need to explain the xorl here:

> 3:
>         xorl %eax,%eax
>         RET

because with your re-written function it *looks* like %eax is already
zero, so - once again - this is about how the exception cases work and
get here magically.

So that needs some big comment about "if an exception happens, we jump
to label '3', and the exception handler will fix up %rcx, but we'll
need to clear %rax".

Or something like that.

But yes, that does look like it will work, it's just really subtle how
%rcx is zero for the 'rest bytes', and %rax is the byte count
remaining in addition.

                  Linus
