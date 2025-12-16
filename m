Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AF533065F
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765897750; cv=none; b=u5xRARO24ftCTUuTF+KoyzYVMOCWsFnV/orn5uRrhwAyLmYId73UIsYPY/SluOjdMpyXl8OFiniusrPBdtQtFXcKfbURrZKstVyz/dtdFGcrKQawyVAV5nE4nSZiNyOrhOdsLnndGRsfh32gElQoslNqtx4r0WBxIUDDTYnzJcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765897750; c=relaxed/simple;
	bh=kaCnNQu10IecAEcgUBVksPSpUHP7s0XUXmn3lqVr7io=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thR2RBXXkZKJcohfl/KzgQgKDQoJ6+Hr1vDguo8WixJmFMzp97YUp8+BDo4VwxCxAcagCcBYh38hY3gJgHyIwbAFrv9pwQ9DCxuAJW4mkM6AXzZqKfR0E0XjI26o8RMNidREp5lzciAE5jbwtsHiNJN7Oy92/7aU8HNEpL+LNVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hz1ySY+I; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hz1ySY+I"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a110548f10so4191595ad.1
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 07:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765897747; x=1766502547; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBQ+KEKtZFBQW9f8fhCsIZyeGJB9EoLToMD3vA7Aj08=;
        b=Hz1ySY+IcEV+DUW7qnHPOGzFfPWOPTQxX2ilMqbM9ZjdoRwwCOYDSuKJOYnuj4xt9n
         YtafYYbBTW4oqJbjCdzrjDxNFSAhtj7WYCBh7/b2Ap5LuwnOknTXU90Fqw11XYoUIvpX
         tRyTrgyQ4Dv722EehaDnalqEuYD4zLBT5j9FBGlXG6wvxOIg3SzbxGsLFIFm36H68L0j
         Nle6HrUmN9535FXUhuyHBLN7/4/Ru31+ZvEtQNk3653buAC2uME9XXoLY+YizkYBa9ed
         K9QiOZBHuSFZ/xv6zgslukdr0TkG+RZTRasWt021j9na7k4Pp7g+NBycjU6+cnn6QX/3
         rFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765897747; x=1766502547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TBQ+KEKtZFBQW9f8fhCsIZyeGJB9EoLToMD3vA7Aj08=;
        b=lGhcV5LOnlSNn17ymBFl7ewWEkZCJ7dQ6sdG3wIvFKuad8JqqBUNFpd1MIO2eQOcUf
         JI/CFhG4SsevuHj46j6BiIw0FYvgVfBaC6N2oytfEPdrq1yElAYcyCENdHto6o5B9Hm/
         N3or3xzEgpifBXK2+MlOzAaUULCZMMK9ASaTYEKBNuM681t0w3hZl3LYDAVAkHdoAbiW
         d7ZVgAl2MLZJDoUCJRfJGgSlki/Q0YcEKLmXrnCCcZrx9+xHhOtHr4RnneJt16g7xal1
         7Z99DOwDryZ2GgX21kk9CWJzUkyKYSy/YnqK9/oM1A+vBMcOUwtAJixPUCN4WoyLhJ6z
         9oSQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+kfrx64Sun/bOxwpAnNjls8NUnbAa/eQ7t+hgNdSyCk4Ln34VpCaSIAjsRNoPGDBOoiQPctgW@lists.linux.dev
X-Gm-Message-State: AOJu0YwgkjhNkRcA460W9xygEwHAZ5F8H+Kui1Irev/30mec9FEy9TEg
	9LOKVCXr76ecbrix98mX6mZKX07ifZUL7f/5XOs017Z9VSVZKR18JfAVQ4h9vzbvhs04ZfDR533
	ltm0yS7n7jD0b4wrYF8LuQacJwZJGTLE=
X-Gm-Gg: AY/fxX5StBeOccddAtl5QNbe3WvfhlF8EG4CPmhMateDLgMe0sle2dpWS6MHRxvk02W
	+pGIIXf6FPUcTvr6VkB+FG0vVOWakHNTqbpY9Sdgtcp74Eq0E4TdTBQLbXf6YCXJoi3+91MysOW
	wHvbftuNnuzTHJ0GnZ06r1JaQrgmO6xGA4iwJr06XlgvxQG1pDugPA2IYwWHGgAbaFmw+lcatke
	5LdD9iOkWvk+BXpldk/8gKpblMxeCS6DN45SSZ8wdv2Hw3kSYBVW4+mQovcpwuGv4SKSfQG8xVL
	I6ajgrQ=
X-Google-Smtp-Source: AGHT+IE06XFlmMgvXerznAhzoCBIgwCI6cVyUE2Vj6xD/o7J8s5VveIDQEUmJl1xe3ToLTKUn/phA5QKg6FpsbGtWOw=
X-Received: by 2002:a05:7022:fa2:b0:11b:862d:8031 with SMTP id
 a92af1059eb24-11f34874285mr6126769c88.0.1765897746571; Tue, 16 Dec 2025
 07:09:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251213-dml-bump-frame-warn-clang-sanitizers-v1-1-0e91608db9eb@kernel.org>
In-Reply-To: <20251213-dml-bump-frame-warn-clang-sanitizers-v1-1-0e91608db9eb@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 16 Dec 2025 10:08:55 -0500
X-Gm-Features: AQt7F2qcbLgX7_41oZokd-Bui00GaFx0PuQiAfWWLBHHuXsoZHZJuKEIq9MvOX0
Message-ID: <CADnq5_OHj3Vz1uVKer8AKH+h3jthM=FE+hCJ=M=xFox65sxcHw@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Apply e4479aecf658 to dml
To: Nathan Chancellor <nathan@kernel.org>
Cc: Austin Zheng <austin.zheng@amd.com>, Jun Lei <jun.lei@amd.com>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	Rodrigo Siqueira <siqueira@igalia.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.  Thanks!

On Sat, Dec 13, 2025 at 1:16=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> After an innocuous optimization change in clang-22, allmodconfig (which
> enables CONFIG_KASAN and CONFIG_WERROR) breaks with:
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn32/display_mode_vba_32.=
c:1724:6: error: stack frame size (3144) exceeds limit (3072) in 'dml32_Mod=
eSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
>    1724 | void dml32_ModeSupportAndSystemConfigurationFull(struct display=
_mode_lib *mode_lib)
>         |      ^
>
> With clang-21, this function was already pretty close to the existing
> limit of 3072 bytes.
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn32/display_mode_vba_32.=
c:1724:6: error: stack frame size (2904) exceeds limit (2048) in 'dml32_Mod=
eSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
>    1724 | void dml32_ModeSupportAndSystemConfigurationFull(struct display=
_mode_lib *mode_lib)
>         |      ^
>
> A similar situation occurred in dml2, which was resolved by
> commit e4479aecf658 ("drm/amd/display: Increase sanitizer frame larger
> than limit when compile testing with clang") by increasing the limit for
> clang when compile testing with certain sanitizer enabled, so that
> allmodconfig (an easy testing target) continues to work.
>
> Apply that same change to the dml folder to clear up the warning for
> allmodconfig, unbreaking the build.
>
> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2135
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/amd/display/dc/dml/Makefile | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/dr=
m/amd/display/dc/dml/Makefile
> index b357683b4255..268b5fbdb48b 100644
> --- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
> @@ -30,7 +30,11 @@ dml_rcflags :=3D $(CC_FLAGS_NO_FPU)
>
>  ifneq ($(CONFIG_FRAME_WARN),0)
>      ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
> -        frame_warn_limit :=3D 3072
> +        ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_COMPILE_TEST),yy)
> +            frame_warn_limit :=3D 4096
> +        else
> +            frame_warn_limit :=3D 3072
> +        endif
>      else
>          frame_warn_limit :=3D 2048
>      endif
>
> ---
> base-commit: f24e96d69f5b9eb0f3b9c49e53c385c50729edfd
> change-id: 20251213-dml-bump-frame-warn-clang-sanitizers-0a34fc916aec
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
