Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0471DED79;
	Mon,  6 Jan 2025 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736184587; cv=none; b=lfFm4b4cJTMBT8GBpKaW2ona9GNQHSJw8x0UN8/8EltFjgl+9vt2Ml90E6SXHkXDPxld3MAcbJXHupWe6F/YABBr2j/J0qDXIITpdiB8nSUQpwtse2RSxmq2Rq0K8MIDhIVBnlj80+3SqsI+uy1IxzpHKGnj6vQPzSoaWGUuCxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736184587; c=relaxed/simple;
	bh=mN2Rqk7LFGOVDpFVo3Ijud0gGQREIuQiJPT/ANYxmoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iGORJfe4yXjASVpNARNTRrqb9VhAqqTR7lCAOdTholevRCzWmqstfwoexPnUiu2k2VWJauoHDBQkpGFsN/roplen7t18qs/xc6UkiHr5BkSzzctWV5l11UZtaKNzseoWHKtnlWJD6zy6+Tkkk4WRtUUhtzfmnDM36Jnzv8K9aV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfi82iF6; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfi82iF6"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2f45526dea0so2921353a91.1;
        Mon, 06 Jan 2025 09:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736184585; x=1736789385; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vBoNhSu6q49cqdqVQhKrU93NZBtBZPk5jCQdSRfDNk8=;
        b=bfi82iF6gyoihWqSC+Tfj0F65lxDYFK3fTq2jCXS9g//IqfDZwPQtScc4wAGXDuzKK
         15ArOh1FO3pB9EgJ2uE23ZKkAZiszF+WDianZGWlXATPGLoohy9WB81v8cPbqvKroa9T
         2eGpMMjBjlc7g3+F350TdfzyEtGkwRWtF/py9R89gJgKo6V902BUOFapG5PCscc9mrnE
         kgjZMAP+FS+yVU3ssAoQu/+M/KKlkUEAn8XL/O2L0PVwXVtex7ylK/LoL8TmaX2GYG0r
         bKuI8fOti9c7twEnb/T8Py2U/4zggXQG2UoB6gO4+IWQqTKqyglrdWcV5kK7hrx4wCyx
         qgkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736184585; x=1736789385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vBoNhSu6q49cqdqVQhKrU93NZBtBZPk5jCQdSRfDNk8=;
        b=A6F1hTeIsipSJCgb8H2GTkdy9xWArhXYXEVA7pZv7U7bUE8xydBQ6hW2HMfnaIoGIE
         OEAHp6M/TyZZa6fTsWvqmnYn2ujHmqQWyCq2UrkFXgp3fu24cJqMgiwpHQG7s9O64g0R
         HoDdFVkbUGPWMOfmDuCdkDDI0Rk42jJjIgpaWkMKc/KWQ+MTJtkBys1MemEdS2rUPtlt
         08LlYqNPHLo12MaxRZ2VLkdIkDC1GpmgAdX8ZVUcXlk2o2sfPHhpIhAsgy/rUlGr8t7g
         ZG0KrA/iAnmpUmGtaSzquvlWo5KTmiJ0uGIA/lPHDgxxbc/XYrKNQ5UFlq7bsht1g6hh
         xFCA==
X-Forwarded-Encrypted: i=1; AJvYcCUpXxhCUqJI1Urf8kff4taBuhV6pzdAiegy+n6uLmGYgr5Crvc6/oLANDIr8cOGhnqVoDOZh4P0Hw==@lists.linux.dev, AJvYcCV46GQrIzA4hoL8E8340tF6baFm+EFEBmAHXYpDqf8ldKqsV2OaHyww9XZUE4MwxvY8emkH@lists.linux.dev
X-Gm-Message-State: AOJu0YwiqADyPtW16JV5w1SWl1YJNkaWEBFxKM5d6T+5e47+RQf8Hqk7
	goKOrJRIUgRbhPJK71xKULY1chGpfND+l27zlurWNiABud30yHqapjS33B8AcBM5Kc+TtVZalrK
	ec1VPUFnJmudGFfMMcLtx4rF5u5w=
X-Gm-Gg: ASbGncvtrvn5348XQdVUz1M/lsQJ24u50DRWg2nuGvEdz3xhFowwH4+Vdw59iOb8Kkw
	XDTMETWv+hIjwBJfPax7B5WDYO2TclFf5R9yiNg==
X-Google-Smtp-Source: AGHT+IHCcADNAqOOaN+ufllc9x/Tbyw4zJm26vrtFwMVXoU/ZabvIUGlzJgCdr6YqtB+H/RX0NBzjQqvbNL5EVjm2+0=
X-Received: by 2002:a17:90b:2b8f:b0:2ea:853a:99e0 with SMTP id
 98e67ed59e1d1-2f452ec6f12mr33610613a91.5.1736184584899; Mon, 06 Jan 2025
 09:29:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241219-amdgpu-dml2-address-clang-frame-larger-than-allconfig-v1-1-8c53a644d486@kernel.org>
In-Reply-To: <20241219-amdgpu-dml2-address-clang-frame-larger-than-allconfig-v1-1-8c53a644d486@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Mon, 6 Jan 2025 12:29:32 -0500
Message-ID: <CADnq5_Pun+zN1=B0eFMw1w8k_oD3fw626SdaEug24YRg8aOLKw@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Increase sanitizer frame larger than
 limit when compile testing with clang
To: Nathan Chancellor <nathan@kernel.org>
Cc: Chaitanya Dhere <chaitanya.dhere@amd.com>, Jun Lei <jun.lei@amd.com>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Xinhui Pan <Xinhui.Pan@amd.com>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.  Thanks!

On Thu, Dec 19, 2024 at 6:46=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Commit 24909d9ec7c3 ("drm/amd/display: Overwriting dualDPP UBF values
> before usage") added a new warning in dml2/display_mode_core.c when
> building allmodconfig with clang:
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/display_mode_core.c:6268:=
13: error: stack frame size (3128) exceeds limit (3072) in 'dml_prefetch_ch=
eck' [-Werror,-Wframe-larger-than]
>    6268 | static void dml_prefetch_check(struct display_mode_lib_st *mode=
_lib)
>         |             ^
>
> Commit be4e3509314a ("drm/amd/display: DML21 Reintegration For Various
> Fixes") introduced one in dml2_core/dml2_core_dcn4_calcs.c with the same
> configuration:
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_core/dml2_=
core_dcn4_calcs.c:7236:13: error: stack frame size (3256) exceeds limit (30=
72) in 'dml_core_mode_support' [-Werror,-Wframe-larger-than]
>    7236 | static bool dml_core_mode_support(struct dml2_core_calcs_mode_s=
upport_ex *in_out_params)
>         |             ^
>
> In the case of the first warning, the stack usage was already at the
> limit at the parent change, so the offending change was rather
> innocuous. In the case of the second warning, there was a rather
> dramatic increase in stack usage compared to the parent:
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_core/dml2_=
core_dcn4_calcs.c:7032:13: error: stack frame size (2696) exceeds limit (20=
48) in 'dml_core_mode_support' [-Werror,-Wframe-larger-than]
>    7032 | static bool dml_core_mode_support(struct dml2_core_calcs_mode_s=
upport_ex *in_out_params)
>         |             ^
>
> This is an unfortunate interaction between an issue with stack slot
> reuse in LLVM that gets exacerbated by sanitization (which gets enabled
> with all{mod,yes}config) and function calls using a much higher number
> of parameters than is typical in the kernel, necessitating passing most
> of these values on the stack.
>
> While it is possible that there should be source code changes to address
> these warnings, this code is difficult to modify for various reasons, as
> has been noted in other changes that have occurred for similar reasons,
> such as commit 6740ec97bcdb ("drm/amd/display: Increase frame warning
> limit with KASAN or KCSAN in dml2").
>
> Increase the frame larger than limit when compile testing with clang and
> the sanitizers enabled to avoid this breakage in all{mod,yes}config, as
> they are commonly used and valuable testing targets. While it is not the
> best to hide this issue, it is not really relevant when compile testing,
> as the sanitizers are commonly stressful on optimizations and they are
> only truly useful at runtime, which COMPILE_TEST states will not occur
> with the current build.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202412121748.chuX4sap-lkp@i=
ntel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/amd/display/dc/dml2/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/d=
rm/amd/display/dc/dml2/Makefile
> index d9c27ebe12ee08d6330eb199cd8ca9c8489fa5b2..91c4f3b4bd5f46ac5c1c74f66=
5b06dbe61081917 100644
> --- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
> @@ -29,7 +29,11 @@ dml2_rcflags :=3D $(CC_FLAGS_NO_FPU)
>
>  ifneq ($(CONFIG_FRAME_WARN),0)
>  ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
> +ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_COMPILE_TEST),yy)
> +frame_warn_flag :=3D -Wframe-larger-than=3D4096
> +else
>  frame_warn_flag :=3D -Wframe-larger-than=3D3072
> +endif
>  else
>  frame_warn_flag :=3D -Wframe-larger-than=3D2048
>  endif
>
> ---
> base-commit: 695c2c745e5dff201b75da8a1d237ce403600d04
> change-id: 20241219-amdgpu-dml2-address-clang-frame-larger-than-allconfig=
-f034d9c5118e
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
