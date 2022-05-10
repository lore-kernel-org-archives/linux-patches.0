Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C7323C0
	for <patches@lists.linux.dev>; Tue, 10 May 2022 06:22:14 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so1106566pjb.1
        for <patches@lists.linux.dev>; Mon, 09 May 2022 23:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pLsX+xsYEgwEJEwz99NE4N6HjmBRdHv5xHVOacRi1x8=;
        b=MzCALGLyrimjV3VurhfrU/MhuO18uKXyDYWtCNbVxxqRTKTZ8doRsmDAxtqodTGFTY
         WantHJMBW8ivyi1d2ES8sjzA8nzem5rv0P67ldHiXextcSSuhRtA22MMIjLFiPhpvBM5
         b3SumCxRtLYFDMrdv0k5d1Lw4E/m3SbMMHj2LKi4AYUvuJqcFVtZHTk7GPz7bZLxGz6j
         ZVUs1PggCEVAXI6I7wo58iN+VLYymshtWjdNHU4hQQkkbd2auLm6ickvsnG8Cb1OEHuW
         KBAVob7hXXR5R+huTBrf83ulYGi3HIgFScBwshkKAasT+HBETKD6sw10UXEUkaa9veoL
         orRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pLsX+xsYEgwEJEwz99NE4N6HjmBRdHv5xHVOacRi1x8=;
        b=sT23aqPxcop371ZxCr5dlMP0qljlZMks3d5GwulIIVXDz6AmXZCqLJ86El35lcULvS
         WpLmjei010UPtr3UvOthNLvh4KQfP978LiA36GEMRodls6Cmi4qt6ttg8F7ICi5nnYKX
         kL0tlkmWQoPK8QMhnN5Qt4N5XNKTAcpW2ZQMkGvOnWqSrmBDYvMR0V7VTx0Jne+76dmU
         bZNAuw/mlAakNXFAwWFwPmZ5zAjULnWD53NF8Kqp8LyFSw99cc8nWxdDrAHtuAfQ+wRM
         XkhOZMbtgF9pb9/ZVjMA4GAYqbgG6FAhSoGAx6UN1F5wFaAN4H/jrUhaQo6WzSNaGZn6
         +drg==
X-Gm-Message-State: AOAM533SV8399ytFLBDzWsMa+eKEeiDXTBfzGh5PGZkHI9ckYR+TofQP
	aQgCeb5rSEXc5j/MEEzMePgqsQ==
X-Google-Smtp-Source: ABdhPJxVburEU+sUT4s6CpJbLeAGJou2OCa9ZWStLyZ2YL9ESmJVKWLG+Zcqv6yZuGBiwjPwLZN7xA==
X-Received: by 2002:a17:902:ea46:b0:15d:dbc:34f2 with SMTP id r6-20020a170902ea4600b0015d0dbc34f2mr19070743plg.60.1652163734044;
        Mon, 09 May 2022 23:22:14 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id v13-20020a17090331cd00b0015e8d4eb247sm1026976ple.145.2022.05.09.23.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 23:22:13 -0700 (PDT)
Message-ID: <ea0096e5-e1cb-a25d-e5b1-1774c0614397@ozlabs.ru>
Date: Tue, 10 May 2022 16:22:08 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:100.0) Gecko/20100101
 Thunderbird/100.0
Subject: Re: [PATCH 1/2] powerpc/vdso: Remove unused ENTRY in linker scripts
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Paul Mackerras <paulus@samba.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20220509204635.2539549-1-nathan@kernel.org>
 <20220509204635.2539549-2-nathan@kernel.org>
From: Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220509204635.2539549-2-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/10/22 06:46, Nathan Chancellor wrote:
> When linking vdso{32,64}.so.dbg with ld.lld, there is a warning about
> not finding _start for the starting address:
> 
>    ld.lld: warning: cannot find entry symbol _start; not setting start address
>    ld.lld: warning: cannot find entry symbol _start; not setting start address
> 
> Looking at GCC + GNU ld, the entry point address is 0x0:
> 
>    $ llvm-readelf -h vdso{32,64}.so.dbg &| rg "(File|Entry point address):"
>    File: vdso32.so.dbg
>      Entry point address:               0x0
>    File: vdso64.so.dbg
>      Entry point address:               0x0
> 
> This matches what ld.lld emits:
> 
>    $ powerpc64le-linux-gnu-readelf -p .comment vdso{32,64}.so.dbg
> 
>    File: vdso32.so.dbg
> 
>    String dump of section '.comment':
>      [     0]  Linker: LLD 14.0.0
>      [    14]  clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> 
>    File: vdso64.so.dbg
> 
>    String dump of section '.comment':
>      [     0]  Linker: LLD 14.0.0
>      [    14]  clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> 
>    $ llvm-readelf -h vdso{32,64}.so.dbg &| rg "(File|Entry point address):"
>    File: vdso32.so.dbg
>      Entry point address:               0x0
>    File: vdso64.so.dbg
>      Entry point address:               0x0
> 
> Remove ENTRY to remove the warning, as it is unnecessary for the vDSO to
> function correctly.


Sounds more like a bugfix to me - _start is simply not defined, I wonder 
why ld is not complaining.


Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>


> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   arch/powerpc/kernel/vdso/vdso32.lds.S | 1 -
>   arch/powerpc/kernel/vdso/vdso64.lds.S | 1 -
>   2 files changed, 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/vdso/vdso32.lds.S b/arch/powerpc/kernel/vdso/vdso32.lds.S
> index 58e0099f70f4..e0d19d74455f 100644
> --- a/arch/powerpc/kernel/vdso/vdso32.lds.S
> +++ b/arch/powerpc/kernel/vdso/vdso32.lds.S
> @@ -13,7 +13,6 @@ OUTPUT_FORMAT("elf32-powerpcle", "elf32-powerpcle", "elf32-powerpcle")
>   OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
>   #endif
>   OUTPUT_ARCH(powerpc:common)
> -ENTRY(_start)
>   
>   SECTIONS
>   {
> diff --git a/arch/powerpc/kernel/vdso/vdso64.lds.S b/arch/powerpc/kernel/vdso/vdso64.lds.S
> index 0288cad428b0..1a4a7bc4c815 100644
> --- a/arch/powerpc/kernel/vdso/vdso64.lds.S
> +++ b/arch/powerpc/kernel/vdso/vdso64.lds.S
> @@ -13,7 +13,6 @@ OUTPUT_FORMAT("elf64-powerpcle", "elf64-powerpcle", "elf64-powerpcle")
>   OUTPUT_FORMAT("elf64-powerpc", "elf64-powerpc", "elf64-powerpc")
>   #endif
>   OUTPUT_ARCH(powerpc:common64)
> -ENTRY(_start)
>   
>   SECTIONS
>   {
