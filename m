Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAFD4A0A
	for <patches@lists.linux.dev>; Wed, 13 Jul 2022 19:11:49 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so5269203pjr.4
        for <patches@lists.linux.dev>; Wed, 13 Jul 2022 12:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6WniWrj3ZgV51g7LWc0uoxvElrFWWSWmqIiBeCx0TGA=;
        b=ftc2b3pp6VR3l1NA92GZ1N4vRKA+MEjmtdqoxsl3Ilze+gmL3NDB39Xm1aCUdHFAve
         ViqgNdDyRFizVooQRLgGQH4tRCDVbf4YL5Uh6mby/MBunMDDoadRWmyj+YL3qrHF0ypW
         MkAabV2guUnjUXJVxtpso92ITWK0U905ay0RjCxncmkv0mJM8tDNb4SXV8BKG4ELjF+V
         lgFX2eOjqFWohepJI+Jle2fvaTfUeWje32HNTboIhc2w6V2+2S5ky6HHrX0eWNVnaMfo
         UpJP2oGxGfI7HhWKRl9gQIMdw38F9HGZxfy6d326Dhx08QkiR6O7njqSDrStBulkTbw+
         NdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6WniWrj3ZgV51g7LWc0uoxvElrFWWSWmqIiBeCx0TGA=;
        b=5sDYvndKU1EZyPB5F4OTo2P4nahOy2tC7UBI88ZtYwEjTGRUqNAqSPSeeIQFXSpY/t
         VcR+RXL/cu9YHDRMRc1MlueqLlLuwoguTuStdvLd1Pu9cUFHtNDTTlll3FnNFoI77xzf
         F7G7GwDn4rB9y3yKK31I9bJn8oGPfV9sj8CcTg7jMpASBQQrF0waXCpBHoD5wueOuZCu
         jVUl38U4YzXFUJspLcKcjRU26HuruINS0s7Zvc288n+V6jTkaMv2lsS4Vrg+M0pqBdvy
         E3T8pS6Tu1UEbpa1FCU8j7FivwhPpDF23pn33JceGMsVkdHj3iZAdOgxZLXmMo1Zf6rC
         zaLA==
X-Gm-Message-State: AJIora9RSloIBGYLdvSORk48aEA2ZDXxTBCDN90mfLhh3S+WrzplXwMP
	u7UCzEO/u61yOeg8AHrS7nfTB68SSxT7uDzNU83omw==
X-Google-Smtp-Source: AGRyM1s7h95SkBhPctIM6Jk4WHc6HW94JZP5f9ql2cZvctg5a76kUb6rS1bFK6/zTvkzmwLovIkP/1ZWeMRAm34h4vI=
X-Received: by 2002:a17:903:244d:b0:16c:5bfe:2e87 with SMTP id
 l13-20020a170903244d00b0016c5bfe2e87mr4671742pls.148.1657739509327; Wed, 13
 Jul 2022 12:11:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220713173503.3889486-1-nathan@kernel.org>
In-Reply-To: <20220713173503.3889486-1-nathan@kernel.org>
From: Stanislav Fomichev <sdf@google.com>
Date: Wed, 13 Jul 2022 12:11:38 -0700
Message-ID: <CAKH8qBsTJcipS65962_hTLhpqzv42YWQpXntVkkt4RhCYubT7g@mail.gmail.com>
Subject: Re: [PATCH] bpf, arm64: Mark dummy_tramp as global
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Zi Shen Lim <zlim.lnx@gmail.com>, 
	Xu Kuohai <xukuohai@huawei.com>, Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 13, 2022 at 10:35 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> When building with clang + CONFIG_CFI_CLANG=y, the following error
> occurs at link time:
>
>   ld.lld: error: undefined symbol: dummy_tramp
>
> dummy_tramp is declared globally in C but its definition in inline
> assembly does not use .global, which prevents clang from properly
> resolving the references to it when creating the CFI jump tables.
>
> Mark dummy_tramp as global so that the reference can be properly
> resolved.
>
> Fixes: b2ad54e1533e ("bpf, arm64: Implement bpf_arch_text_poke() for arm64")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1661
> Suggested-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Stanislav Fomichev <sdf@google.com>

> ---
>  arch/arm64/net/bpf_jit_comp.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index fd1cb0d2aaa6..dcc572b7d4da 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -604,6 +604,7 @@ void dummy_tramp(void);
>
>  asm (
>  "      .pushsection .text, \"ax\", @progbits\n"
> +"      .global dummy_tramp\n"
>  "      .type dummy_tramp, %function\n"
>  "dummy_tramp:"
>  #if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
>
> base-commit: ace2bee839e08df324cb320763258dfd72e6120e
> --
> 2.37.1
>
