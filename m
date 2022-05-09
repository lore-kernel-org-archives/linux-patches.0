Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B1123B3
	for <patches@lists.linux.dev>; Mon,  9 May 2022 21:06:02 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id bq30so25970184lfb.3
        for <patches@lists.linux.dev>; Mon, 09 May 2022 14:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjp1harQFIcR5JWDx27OsPZ+h/5ZSTnxNJxQGcpbR0Q=;
        b=orbrA4f77ogkxmKkJ3q/TQp+dmMTe5nI5SbmLDizn+BWtUFG8Veqt5b2zCd7XI/v0C
         2++5tFvOTalN0KW1AA0axYrWYizghY3kpdrmvNXVto7XaPmPKHVWTdWCqiCR61V+lIkg
         s9CF/QQDbaxAdyboGRDA09JFYQbpAPBvbY7qhyf+Jc0KYGEYTOw7lFRqZNkDCG1ZGmLE
         QJz9STkUtJlmOiy/nR3lnfGOG5XYt59SxISOM8zb2RbNNEQgXqWZblTbq2UTP54SLCVz
         tubogND8mcPPvr46k7AtFlLzJbSUwmOkxP4rDRYyZelkIvBVWy1QkdJfJ62fVLEyPyIF
         FAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjp1harQFIcR5JWDx27OsPZ+h/5ZSTnxNJxQGcpbR0Q=;
        b=GblPVltx/YUx2fexUm2jhyJ/dnHVLS2/O6j0JnjR71KU8ziluwHvV/TOqJQ7/eSu5n
         qyqD+SbppoRci80b1EwKmtuFreDEJtGHzlQsQZRz3XJLi8wkQH+atK1e8tDadQlE3PT0
         Mx5IF77uIFlUQojDrlvsvWr+b7JdNaSWc5wpAlR90emFnmayeGxL9SOTrIDxnja+Mw7R
         6dimB2ISSq6Rij9Mc8zeOw828YhsxuezULIzlfdFodeBOouXipnhK4T3QjTVuhKyut9p
         0/kBF55chdV85xYYX/AXZl+oZ/eG5NpW6V2uNZ56LFccbRfYFyU9siIrXjY4QW8V6tJh
         QAcA==
X-Gm-Message-State: AOAM531CYGfxb3h+l603S7fxdXuT9Vq0zhATFsagdDa2gBiw89PiVKTQ
	q0QvATsR99vo4OohVCG6EghRuiq0prZ9TLTZnQa7fw==
X-Google-Smtp-Source: ABdhPJysiyUy2xjHoY7K99LREor5hcP6IvAjiQlGyHJrA4xH+cD+Sc1vbSv1/2dj3A5+OpE+v2zcENJr5rPg1toaW24=
X-Received: by 2002:a05:6512:1291:b0:473:b522:ef58 with SMTP id
 u17-20020a056512129100b00473b522ef58mr13857412lfs.190.1652130360612; Mon, 09
 May 2022 14:06:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220509204635.2539549-1-nathan@kernel.org> <20220509204635.2539549-2-nathan@kernel.org>
In-Reply-To: <20220509204635.2539549-2-nathan@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 9 May 2022 14:05:48 -0700
Message-ID: <CAKwvOdnqFRhFvhFeGzKiVCp53iULFMhKeGmgf=n_sCohRt3q0Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc/vdso: Remove unused ENTRY in linker scripts
To: Nathan Chancellor <nathan@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, 
	Paul Mackerras <paulus@samba.org>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Alexey Kardashevskiy <aik@ozlabs.ru>, Tom Rix <trix@redhat.com>, linuxppc-dev@lists.ozlabs.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, 
	Fangrui Song <maskray@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, May 9, 2022 at 1:46 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> When linking vdso{32,64}.so.dbg with ld.lld, there is a warning about
> not finding _start for the starting address:
>
>   ld.lld: warning: cannot find entry symbol _start; not setting start address
>   ld.lld: warning: cannot find entry symbol _start; not setting start address
>
> Looking at GCC + GNU ld, the entry point address is 0x0:
>
>   $ llvm-readelf -h vdso{32,64}.so.dbg &| rg "(File|Entry point address):"
>   File: vdso32.so.dbg
>     Entry point address:               0x0
>   File: vdso64.so.dbg
>     Entry point address:               0x0
>
> This matches what ld.lld emits:
>
>   $ powerpc64le-linux-gnu-readelf -p .comment vdso{32,64}.so.dbg
>
>   File: vdso32.so.dbg
>
>   String dump of section '.comment':
>     [     0]  Linker: LLD 14.0.0
>     [    14]  clang version 14.0.0 (Fedora 14.0.0-1.fc37)
>
>   File: vdso64.so.dbg
>
>   String dump of section '.comment':
>     [     0]  Linker: LLD 14.0.0
>     [    14]  clang version 14.0.0 (Fedora 14.0.0-1.fc37)
>
>   $ llvm-readelf -h vdso{32,64}.so.dbg &| rg "(File|Entry point address):"
>   File: vdso32.so.dbg
>     Entry point address:               0x0
>   File: vdso64.so.dbg
>     Entry point address:               0x0
>
> Remove ENTRY to remove the warning, as it is unnecessary for the vDSO to
> function correctly.

Right, the vdso is going to be injected into the process' mappings;
what would it even mean for a DSO to have an entry point?
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/powerpc/kernel/vdso/vdso32.lds.S | 1 -
>  arch/powerpc/kernel/vdso/vdso64.lds.S | 1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/arch/powerpc/kernel/vdso/vdso32.lds.S b/arch/powerpc/kernel/vdso/vdso32.lds.S
> index 58e0099f70f4..e0d19d74455f 100644
> --- a/arch/powerpc/kernel/vdso/vdso32.lds.S
> +++ b/arch/powerpc/kernel/vdso/vdso32.lds.S
> @@ -13,7 +13,6 @@ OUTPUT_FORMAT("elf32-powerpcle", "elf32-powerpcle", "elf32-powerpcle")
>  OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
>  #endif
>  OUTPUT_ARCH(powerpc:common)
> -ENTRY(_start)
>
>  SECTIONS
>  {
> diff --git a/arch/powerpc/kernel/vdso/vdso64.lds.S b/arch/powerpc/kernel/vdso/vdso64.lds.S
> index 0288cad428b0..1a4a7bc4c815 100644
> --- a/arch/powerpc/kernel/vdso/vdso64.lds.S
> +++ b/arch/powerpc/kernel/vdso/vdso64.lds.S
> @@ -13,7 +13,6 @@ OUTPUT_FORMAT("elf64-powerpcle", "elf64-powerpcle", "elf64-powerpcle")
>  OUTPUT_FORMAT("elf64-powerpc", "elf64-powerpc", "elf64-powerpc")
>  #endif
>  OUTPUT_ARCH(powerpc:common64)
> -ENTRY(_start)
>
>  SECTIONS
>  {
> --
> 2.36.1
>


-- 
Thanks,
~Nick Desaulniers
