Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295252580
	for <patches@lists.linux.dev>; Sat, 16 Apr 2022 17:42:44 +0000 (UTC)
Received: by mail-lj1-f182.google.com with SMTP id q14so12574257ljc.12
        for <patches@lists.linux.dev>; Sat, 16 Apr 2022 10:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jIUvFDPrhPXkkJF0Dp/55PJ5S0x4qstps2XI7eQ/M0=;
        b=YYzhPBou87optH724QK2IXpfqNyBE5k1bdRrq/6iVqz4j33fCs6gu77SZiD7uZ+/+y
         AyATSsUlQqmOxbDT/VFiodyniyPPS5dBwPFqxHjJltJ+4vFWCe6ZmMLgBqAp59zNbOWl
         mVLQQZ6sTlPDIsn1CrMHr8Rynu32DMPkzsZDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jIUvFDPrhPXkkJF0Dp/55PJ5S0x4qstps2XI7eQ/M0=;
        b=AfcF1pR+ENdzMpuSc42CI91FUm5X9be6mAn3WNdLfhuxDcqc+9MytwnyRcP0iUJuOL
         3Mhr9ACyuzI82jf2TzbUcb+dC2nbUgaGu4F9mUYi3e5F0dFd1+dKMWphboLVO12y8Dje
         iWry76mQ0ZyK/pcIP9n+HDHM83K47HlcRN8+p5PrBM2jFyX23iS3axdJodZzybJx00nB
         MirpYNMGByOFN1crm0zuF2bedN0EXr7lTDIH+UncMydqVKDcemB99dsQbde4LwI7yRUQ
         cKN7KjcaItN591WI+ZqBhowM9fAlV1SIf+64ziFGv0Ufr42WBLfBjBF7kkGNEZ+xhkwV
         9Xqw==
X-Gm-Message-State: AOAM53339Cul8FKlBt/knb0cqTWE+AOMhdighdlLDxR9udIZzsh0PrPj
	1mMXokmU+rMqYyQIlpMVaoweouqJLxWi7NL12FQ=
X-Google-Smtp-Source: ABdhPJzUk5DP58G+kqW7cbmLwQouyAKZgmEhGDkokd1u4KwB3L6IBr5+mpS2qo5cDMlm1rMcVWWzxg==
X-Received: by 2002:a2e:a54a:0:b0:24c:88db:783d with SMTP id e10-20020a2ea54a000000b0024c88db783dmr2572414ljn.341.1650130961891;
        Sat, 16 Apr 2022 10:42:41 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id q7-20020a2e84c7000000b0024da52893c4sm532957ljh.22.2022.04.16.10.42.39
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 10:42:40 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id t25so18468562lfg.7
        for <patches@lists.linux.dev>; Sat, 16 Apr 2022 10:42:39 -0700 (PDT)
X-Received: by 2002:a05:6512:2291:b0:46b:b72b:c947 with SMTP id
 f17-20020a056512229100b0046bb72bc947mr2938719lfu.531.1650130959084; Sat, 16
 Apr 2022 10:42:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org> <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic> <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com> <Ylr8rR+LHQ1uGL47@zn.tnic>
In-Reply-To: <Ylr8rR+LHQ1uGL47@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Apr 2022 10:42:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
Message-ID: <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, Apr 16, 2022 at 10:28 AM Borislav Petkov <bp@alien8.de> wrote:
>
> you also need a _fsrm() one which checks X86_FEATURE_FSRM. That one
> should simply do rep; stosb regardless of the size. For that you can
> define an alternative_call_3 similar to how the _2 variant is defined.

Honestly, my personal preference would be that with FSRM, we'd have an
alternative that looks something like

    asm volatile(
        "1:"
        ALTERNATIVE("call __stosb_user", "rep movsb", X86_FEATURE_FSRM)
        "2:"
       _ASM_EXTABLE_UA(1b, 2b)
        :"=c" (count), "=D" (dest),ASM_CALL_CONSTRAINT
        :"0" (count), "1" (dest), "a" (0)
        :"memory");

iow, the 'rep stosb' case would be inline.

Note that the above would have a few things to look out for:

 - special 'stosb' calling convention:

     %rax/%rcx/%rdx as inputs
     %rcx as "bytes not copied" return value
     %rdi can be clobbered

   so the actual functions would look a bit odd and would need to
save/restore some registers, but they'd basically just emulate "rep
stosb".

 - since the whole point is that the "rep movsb" is inlined, it also
means that the "call __stosb_user" is done within the STAC/CLAC
region, so objdump would have to be taught that's ok

but wouldn't it be lovely if we could start moving towards a model
where we can just inline 'memset' and 'memcpy' like this?

NOTE! The above asm has not been tested. I wrote it in this email. I'm
sure I messed something up.

               Linus
