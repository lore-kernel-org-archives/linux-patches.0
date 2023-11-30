Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FB75380E
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zDXucOGT"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40b35199f94so81575e9.0
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 08:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701360378; x=1701965178; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6Wu9BYoPOgzOTrfzG/UoYHqri4WRctrB3D+iqT3Lb8=;
        b=zDXucOGTe9Q+zX3I0MrnA3TXibfE8oyIIYjHXq8o8v4yWt6lm0fo+vKyHlqMY9HE4C
         sE/mEZrRvc+TiIIfFBqUIuXuKuZChPkWfD9qI2fhzkqUuRTNiU7fWvAT34gfI1bkD586
         +031vW39i7kN3oz3cZWUcsvLWvLECiF16T8yUcMBXYEyvYvXXrmNPUzvWa9p9kmBzZLe
         AdP+kZXvfDLoHTX0yV7JwQhROWfpE1CGCtvxASmGIUeVUVYRQLcl+SP6HxlZflSwCLo+
         dlBRr8wUa2qY6sMrm9n+4GC1xLhF6j0w/Ajs2RF+5au18vsLcWBF+TDZ9j5TUZqq4oRf
         GjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701360378; x=1701965178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6Wu9BYoPOgzOTrfzG/UoYHqri4WRctrB3D+iqT3Lb8=;
        b=l1i9RGhkHId4bjdSvEiuCzogvs97Ld5+9nc3hpnkqMr1fGIgmzmocSBSvMLZzRzEbz
         rHVSR6+m/qSaNKA92vtsmNAW1rApjZwr2CVzdsgHq4nw5FC5VkBOnfJJiBWjZwwRZ1uO
         fsDO0sDNQeEcW5KqFvUeblSuZ+9lA6qO0ri6pPVwcK2pugUgTyxsVZ6p5l2SWUk9sZeu
         7CfcJxl+u89ASB6xWU2zkloybYJDqTRDlEDtoY7Qgr3en9NTqhMLxsHPs5iFSSBrfWAW
         h+bDGiqGSuMkePcjfnSjuuvsxSPBiI4fGVCh0x8FvVY4qIaJwxa2LcrUgtZRSygdDPWB
         m6SQ==
X-Gm-Message-State: AOJu0Yy5Q+9+pnjDSh/Wxv+royGbCQ4pgGMAVkY6/tumA2fThdNWclIl
	+4uOKFNwYKX5lGNhuDDJGM56gqjGZLp5KdcKdo4u6Q==
X-Google-Smtp-Source: AGHT+IFCeuDKxzqLbWkqyo4oZIA5ZPre+Z7BPi/It9wdY5IGOQ7jgdPnEFeelRaufUJIJAQBvu7D/RkZCQb4LKJexsA=
X-Received: by 2002:a05:600c:1e15:b0:40b:3483:8488 with SMTP id
 ay21-20020a05600c1e1500b0040b34838488mr133007wmb.3.1701360378046; Thu, 30 Nov
 2023 08:06:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org> <20231129-riscv-restrict-dwarf5-llvm-v1-1-ec0d368fb538@kernel.org>
In-Reply-To: <20231129-riscv-restrict-dwarf5-llvm-v1-1-ec0d368fb538@kernel.org>
From: Fangrui Song <maskray@google.com>
Date: Thu, 30 Nov 2023 08:06:04 -0800
Message-ID: <CAFP8O3LNUFREj4er4Ateq2-6hyHyeJLLg71bE7bLjFZ23E1xgg@mail.gmail.com>
Subject: Re: [PATCH 1/2] riscv: Hoist linker relaxation disabling logic into Kconfig
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	conor@kernel.org, ndesaulniers@google.com, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2023 at 3:30=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Certain configurations may need to be disabled if linker relaxation is
> in use, such as DWARF5 with ld.lld < 18. Hoist the logic of whether or
> not linker relaxation is in use into Kconfig so decisions can be made at
> configuration time.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/riscv/Kconfig  | 5 +++++
>  arch/riscv/Makefile | 4 +---
>  2 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 95a2a06acc6a..72be1d8122a3 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -181,6 +181,11 @@ config HAVE_SHADOW_CALL_STACK
>         # https://github.com/riscv-non-isa/riscv-elf-psabi-doc/commit/a48=
4e843e6eeb51f0cb7b8819e50da6d2444d769
>         depends on $(ld-option,--no-relax-gp)
>
> +config RISCV_USE_LINKER_RELAXATION
> +       def_bool y
> +       # https://github.com/llvm/llvm-project/commit/6611d58f5bbcbec7726=
2d392e2923e1d680f6985
> +       depends on !LD_IS_LLD || LLD_VERSION >=3D 150000
> +
>  config ARCH_MMAP_RND_BITS_MIN
>         default 18 if 64BIT
>         default 8
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index a74be78678eb..e383aa9e2757 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -43,8 +43,7 @@ else
>         KBUILD_LDFLAGS +=3D -melf32lriscv
>  endif
>
> -ifeq ($(CONFIG_LD_IS_LLD),y)
> -ifeq ($(call test-lt, $(CONFIG_LLD_VERSION), 150000),y)
> +ifndef CONFIG_RISCV_USE_LINKER_RELAXATION
>         KBUILD_CFLAGS +=3D -mno-relax
>         KBUILD_AFLAGS +=3D -mno-relax
>  ifndef CONFIG_AS_IS_LLVM
> @@ -52,7 +51,6 @@ ifndef CONFIG_AS_IS_LLVM
>         KBUILD_AFLAGS +=3D -Wa,-mno-relax
>  endif
>  endif
> -endif
>
>  ifeq ($(CONFIG_SHADOW_CALL_STACK),y)
>         KBUILD_LDFLAGS +=3D --no-relax-gp
>
> --
> 2.43.0


Reviewed-by: Fangrui Song <maskray@google.com>


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
