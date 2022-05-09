Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A93529A8
	for <patches@lists.linux.dev>; Mon,  9 May 2022 21:58:23 +0000 (UTC)
Received: by mail-lf1-f52.google.com with SMTP id p26so12881488lfh.10
        for <patches@lists.linux.dev>; Mon, 09 May 2022 14:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aM58VLEYK3OPz+dxz/e3P39oZMoTQOHg5Skeyfuaw+k=;
        b=PgydWL3iTr2+I7wwsidaRzy2KvNTlCFmCHi3NEgdM4U5/OxxoUcNyUi0fZX095bEy/
         u8gfFHMeT9ZDIR9vAwTWhYx4Q08Bvi9ZqGTCPxANowlGLYBJgftCkf5TC0hi3fxt6CQK
         3e35rJ9iQCJ+59jZJ9QsBy0XmRmoSDLxVdFxtIArysOaiMXvWR5HMlwmH0QKaXBRdnWX
         2U7SFHMcBxI/JnZKhCginJrSqmQohQKV99PIH4qOOugMz8nruN1YMFhPjAjfN//X2XRj
         P/i0fiUqC5WNOpd9WnurknYwSXiWhhI1fvhCwGjzasF1gR0bsPggUfvDqfAQwWtvTZyI
         M0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aM58VLEYK3OPz+dxz/e3P39oZMoTQOHg5Skeyfuaw+k=;
        b=fv/2x2kiVEkKPY44mFSDktAq4yhQ/fWuAHA+Q+g91Mc+wCuyvMJXTmd8OkuywcKcQd
         461liLGN6/w4r/GXdL0cb5v89cP/j32JuDGovRqZjZcZMwg5gc2SWgT4bwb8aN8NIXFe
         APLRMVEKtUc3f2fGj8m0izBfcCwc7Fno0WA4RIyYESYV0J6l5vmhm24PwljeZq1CwEJM
         +F6TuXXCSq2nKB6i3m2c27Yik6NmeLSeShxIbI9Bq+By+JIesRFY1fHt/sOMI7FlYzsF
         tX37LYACYvua05SwyzgzqO+RWARyNgNuzw+2GThRPxzWsu8gi/RcNiJxm99ObBP4HUhP
         hl4w==
X-Gm-Message-State: AOAM530tS1vDqNmUVIX3ulDd8ol3vvyMATpz6Xba8n+BOK+xTHSShaGW
	qZ2NjKYkrZw4mh7o/I22/62UTcK27WEUVY8r9Z8RwBBUElERBg==
X-Google-Smtp-Source: ABdhPJxIH8+tsIhft4L3Ly9ibBwf8nUknmdWV0+D0qaUm7yXlZfZMRiNhcm2509AU0Xek7fJ/kWMwz5mBiDFGroZkhY=
X-Received: by 2002:a05:6512:48f:b0:472:3c47:94a0 with SMTP id
 v15-20020a056512048f00b004723c4794a0mr14081977lfq.579.1652133501024; Mon, 09
 May 2022 14:58:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220509204635.2539549-1-nathan@kernel.org> <20220509204635.2539549-3-nathan@kernel.org>
 <CAKwvOdkvF8AJudCcu=CVmU42eyVMJwUjQFnX+rpVF45bTR86Mg@mail.gmail.com> <YnmL6a8eObtstNjZ@dev-arch.thelio-3990X>
In-Reply-To: <YnmL6a8eObtstNjZ@dev-arch.thelio-3990X>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 9 May 2022 14:58:09 -0700
Message-ID: <CAKwvOdnbTGpNvXsum-cM8i5sWuATLHouaURE1vkjuOj5rzTuqw@mail.gmail.com>
Subject: Re: [PATCH 2/2] powerpc/vdso: Link with ld.lld when requested
To: Nathan Chancellor <nathan@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, 
	Paul Mackerras <paulus@samba.org>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Alexey Kardashevskiy <aik@ozlabs.ru>, Tom Rix <trix@redhat.com>, linuxppc-dev@lists.ozlabs.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, May 9, 2022 at 2:47 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Mon, May 09, 2022 at 02:24:40PM -0700, Nick Desaulniers wrote:
> > On Mon, May 9, 2022 at 1:47 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > >
> > > The PowerPC vDSO is linked with $(CC) instead of $(LD), which means the
> > > default linker of the compiler is used instead of the linker requested
> > > by the builder.
> > >
> > >   $ make ARCH=powerpc LLVM=1 mrproper defconfig arch/powerpc/kernel/vdso/
> > >   ...
> > >
> > >   $ llvm-readelf -p .comment arch/powerpc/kernel/vdso/vdso{32,64}.so.dbg
> > >
> > >   File: arch/powerpc/kernel/vdso/vdso32.so.dbg
> > >   String dump of section '.comment':
> > >   [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> > >
> > >   File: arch/powerpc/kernel/vdso/vdso64.so.dbg
> > >   String dump of section '.comment':
> > >   [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> > >
> > > The compiler option '-fuse-ld' tells the compiler which linker to use
> > > when it is invoked as both the compiler and linker. Use '-fuse-ld=lld'
> > > when LD=ld.lld has been specified (CONFIG_LD_IS_LLD) so that the vDSO is
> > > linked with the same linker as the rest of the kernel.
> > >
> > >   $ llvm-readelf -p .comment arch/powerpc/kernel/vdso/vdso{32,64}.so.dbg
> > >
> > >   File: arch/powerpc/kernel/vdso/vdso32.so.dbg
> > >   String dump of section '.comment':
> > >   [     0] Linker: LLD 14.0.0
> > >   [    14] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> > >
> > >   File: arch/powerpc/kernel/vdso/vdso64.so.dbg
> > >   String dump of section '.comment':
> > >   [     0] Linker: LLD 14.0.0
> > >   [    14] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> > >
> > > LD can be a full path to ld.lld, which will not be handled properly by
> > > '-fuse-ld=lld' if the full path to ld.lld is outside of the compiler's
> > > search path. '-fuse-ld' can take a path to the linker but it is
> > > deprecated in clang 12.0.0; '--ld-path' is preferred for this scenario.
> > >
> > > Use '--ld-path' if it is supported, as it will handle a full path or
> > > just 'ld.lld' properly. See the LLVM commit below for the full details
> > > of '--ld-path'.
> >
> > Perhaps worth adding some additional background from the cover letter
> > to the commit message that will actually go into the kernel,
> > particularly:
> > 1. Kbuild mostly invokes the compiler and linker distinctly; the ppc
> > vdso code uses the compiler as the linker driver though.
> > 2. When doing so, depending on how the compiler was configured, the
> > implicit default linker the compiler invokes might not match $LD.
>
> Sure, I think I can clear up these two points with something like:
>
> "The PowerPC vDSO uses $(CC) to link, which differs from the rest of the
> kernel, which uses $(LD) directly. As a result, the default linker of
> the compiler is used, which may differ from the linker requested by the
> builder. For example:
>
> <example above>
>
> LLVM=1 sets LD=ld.lld but ld.lld is not used to link the vDSO; GNU ld is
> because "ld" is the default linker for clang on most Linux platforms."
>
> Thoughts?

SGTM

>
> > 3. This is a problem for LTO since clang may try to invoke ld.gold,
> > which is not supported as of
> > commit 75959d44f9dc ("kbuild: Fail if gold linker is detected")
>
> Technically, it seemed like ld.bfd was being invoked but the LLVMgold
> plugin did not exist. Regardless, moving to ld.lld will resolve that,
> since the LLVMgold plugin won't be needed.

Oh indeed, invoking clang with `-flto -###` shows it does invoke the
system's linker with `-plugin path/to/LLVMgold.so`, not `ld.gold`
itself.  I don't think we should use or depend on the LLVMgold.so
plugin either (I suspect it will invoke ld.gold, but as you noticed, I
don't bother to build LLVMgold.so).  So, perhaps reworded (feel free
to reword further):

3. This is a problem for LTO since clang may try to invoke ld.bfd with
the LLVMgold.so plugin.
https://llvm.org/docs/GoldPlugin.html states that "usage of the LLVM
gold plugin with ld.bfd is not tested and therefore not officially
supported or recommended." Users should instead use ld.lld to drive
linking for LTO with clang.

>
> > 4. Using the linker as the driver can cause ld.bfd 2.26 to crash.
> > https://lore.kernel.org/all/b2066ccd-2b81-6032-08e3-41105b400f75@csgroup.eu/
> > (Though, I wonder if that's because I was trying to add
> > --orphan-handling=warn, which we're not yet doing for the ppc vdso
> > AFAICT).
>
> I can add this if necessary but it seemed like there might have been
> other problems reported? I could just add a blanket "linker driver had
> issues, we'll try again later" or something of that effect?

Sure.

-- 
Thanks,
~Nick Desaulniers
