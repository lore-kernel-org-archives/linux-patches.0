Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE9C62E;
	Tue,  1 Nov 2022 07:57:16 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id y14so35137580ejd.9;
        Tue, 01 Nov 2022 00:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S7YqvcW7uJgnvwYFXgxeJbVFHcM8MqyxOmFtKk4o1e8=;
        b=Axuh0GyB1m/5zx5ujC1ZRQ4nA4yP8lbxoJxh2ikRk1bImT3tAn0Nfc1R+2N0W4CwDI
         0ga1iUmOM+E/a6Z6sIIvR/usEy/w2grMFecHrNCgbAySFhBCTt2o4WKwVWJvvQoa5y+A
         /TLMYlvP0zcb5CtfVLCqlfrafVi/eXzekKxl9RCiQ6fSJ8234zLHsMA+A1JskX5PNeID
         kGqE+xU/9xhSNBVOtIX0olQpAcgipeFLWSoq3EC5UZ40SiiveQsuDCls2BedKmaWu/A8
         69NauQoJTskQwEuik/8OYa4xodSCjjE+bR6WWEk+NamTPh6YvxKoaIibUnkuZQu0AoXO
         Bm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7YqvcW7uJgnvwYFXgxeJbVFHcM8MqyxOmFtKk4o1e8=;
        b=navjSjYfx0c6c8udu6f9CLOZyDyiChfszKBKbZ6MoOcnl0cEi4xk2wmy7o9tWx1pz4
         cjSSBLxbibdjJgWm/YaPj1IsLvuCI5wGBv3Ceug7v43ZXYwQXB41AKjm6ABg49V3xVr2
         tIKDp+krlfntoh0lRQzvPZFMkiwKNmbBI97o0GEJhJfRTf4dFc07RET/mBblzvN9QcVs
         pVHD8ThFMjbMViDBz0wvGcIP04KVr4DmWkvnubMz7SVZcWXG9tefaPHT3VbFi2MGC8zc
         hqOZnpekpV1r0fOC3J0UPmom7e7bMnIfFwXtPl9UQso2wQMnwPf1DNn+zAVjxlZNV2Se
         q17Q==
X-Gm-Message-State: ACrzQf39pdaR69XktJuZ0Uy+wGSqh/zLAcrmlGCzF32BLQ+6lktyzYMg
	QYPHV+tLHVvAUPqy084l34g=
X-Google-Smtp-Source: AMsMyM4pjDNo0Kww61Ai4NrW4m8vcLBMwRCzHrkO1tvnytVeLlvNSWmy7Va37978oGE/Vpqawvpvhw==
X-Received: by 2002:a17:907:80a:b0:783:2585:5d73 with SMTP id wv10-20020a170907080a00b0078325855d73mr16851516ejb.642.1667289434901;
        Tue, 01 Nov 2022 00:57:14 -0700 (PDT)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id d25-20020aa7c1d9000000b00456c6b4b777sm4124898edp.69.2022.11.01.00.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 00:57:14 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Tue, 1 Nov 2022 08:57:11 +0100
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, x86@kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH bpf] bpf: Mark bpf_arch_init_dispatcher_early() as
 __init_or_module
Message-ID: <Y2DRVwI4bNUppmXJ@krava>
References: <20221031173819.2344270-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031173819.2344270-1-nathan@kernel.org>

On Mon, Oct 31, 2022 at 10:38:19AM -0700, Nathan Chancellor wrote:
> After commit dbe69b299884 ("bpf: Fix dispatcher patchable function entry
> to 5 bytes nop"), building kernel/bpf/dispatcher.c in certain
> configurations with LLVM's integrated assembler results in a known
> recordmcount bug:
> 
>   Cannot find symbol for section 4: .init.text.
>   kernel/bpf/dispatcher.o: failed
> 
> This occurs when there are only weak symbols in a particular section in
> the translation unit; in this case, bpf_arch_init_dispatcher_early() is
> marked '__weak __init' and it is the only symbol in the .init.text
> section. recordmcount expects there to be a symbol for a particular
> section but LLVM's integrated assembler (and GNU as after 2.37) do not
> generated section symbols. This has been worked around in the kernel
> before in commit 55d5b7dd6451 ("initramfs: fix clang build failure")
> and commit 6e7b64b9dd6d ("elfcore: fix building with clang").
> 
> Fixing recordmcount has been brought up before but there is no clear
> solution that does not break ftrace outright.
> 
> Unfortunately, working around this issue by removing the '__init' from
> bpf_arch_init_dispatcher_early() is not an option, as the x86 version of
> bpf_arch_init_dispatcher_early() calls text_poke_early(), which is
> marked '__init_or_module', meaning that when CONFIG_MODULES is disabled,
> bpf_arch_init_dispatcher_early() has to be marked '__init' as well to
> avoid a section mismatch warning from modpost.
> 
> However, bpf_arch_init_dispatcher_early() can be marked
> '__init_or_module' as well, which would resolve the recordmcount warning
> for configurations that support modules (i.e., the vast majority of
> them) while not introducing any new warnings for all configurations. Do
> so to clear up the build failure for CONFIG_MODULES=y configurations.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/981
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

LGTM but the whole thing might be actually going away:
  https://lore.kernel.org/bpf/Y2BD6xZ108lv3j7J@krava/T/#u

because it won't compile on gcc 7

jirka

> ---
>  arch/x86/net/bpf_jit_comp.c | 2 +-
>  include/linux/bpf.h         | 2 +-
>  kernel/bpf/dispatcher.c     | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 00127abd89ee..4145939bbb6a 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -389,7 +389,7 @@ static int __bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
>  	return ret;
>  }
>  
> -int __init bpf_arch_init_dispatcher_early(void *ip)
> +int __init_or_module bpf_arch_init_dispatcher_early(void *ip)
>  {
>  	const u8 *nop_insn = x86_nops[5];
>  
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0566705c1d4e..4aa7bde406f5 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -971,7 +971,7 @@ struct bpf_trampoline *bpf_trampoline_get(u64 key,
>  					  struct bpf_attach_target_info *tgt_info);
>  void bpf_trampoline_put(struct bpf_trampoline *tr);
>  int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs);
> -int __init bpf_arch_init_dispatcher_early(void *ip);
> +int __init_or_module bpf_arch_init_dispatcher_early(void *ip);
>  
>  #define BPF_DISPATCHER_INIT(_name) {				\
>  	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> index 04f0a045dcaa..e14a68e9a74f 100644
> --- a/kernel/bpf/dispatcher.c
> +++ b/kernel/bpf/dispatcher.c
> @@ -91,7 +91,7 @@ int __weak arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int n
>  	return -ENOTSUPP;
>  }
>  
> -int __weak __init bpf_arch_init_dispatcher_early(void *ip)
> +int __weak __init_or_module bpf_arch_init_dispatcher_early(void *ip)
>  {
>  	return -ENOTSUPP;
>  }
> 
> base-commit: 8bdc2acd420c6f3dd1f1c78750ec989f02a1e2b9
> -- 
> 2.38.1
> 
