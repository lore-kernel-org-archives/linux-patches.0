Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AEE208BA;
	Thu,  2 Nov 2023 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DxMqapnL"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5842a94feb2so634519eaf.0;
        Thu, 02 Nov 2023 10:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698947844; x=1699552644; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Zmxt6jWHSk0ufE+QEoUUpI6OvaXUdy9+PMpDjlbgbE=;
        b=DxMqapnLvwNDxK9JdfmRTCe7n8KsCCQcUAPnZV6M9WuUQuKWGqnnUypiJJb7EeXBih
         4AgGTYV4AjA65rmAPU36GVUm6nTa0Z3bSfum2arfnd2u+IpIocWQcz27DakNtSduEmAZ
         K5z0065pZn8tQ8eLuh0UxI8H+oBsqoUXU21XqXzX0ndesqp0XJCm0IFUeU+oU1M0t0zP
         lRPzdAL37ZpAqjkUQDNwwlrVoc6ISQzzPR7sha7R8YETT+lQiZQmMW0OcYB/fjkBR6L5
         SjO8tYIIGmlvL/bR1N3g58DFbRQReO9rAXmwAl1nOR+VWMXB7b3qBwRg3zr/D0y36wix
         bRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698947844; x=1699552644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Zmxt6jWHSk0ufE+QEoUUpI6OvaXUdy9+PMpDjlbgbE=;
        b=tkvoBlZTgk6b8PbW6T6lmoI9mPqgthHGWbZHNtq24ZayLdNTNWgLdzNDA56gtaA/5V
         BDVMSkhhksqP1ejI58/qwSMMkql3DqiKiYIpM4Gi0LavBLf7yx3E0hDuFI81hoQasNqo
         GGXUxbz3ebcgQ/n83f4eQMJVuo+ImPDg/MHF//YmSOETYx04Cr1+BpMvhEBh39njvgFO
         jtT87dvVNkRGbFlpCVTefE7F0MC5XUkmYp8qMKZfljYrz913/wYvxBN/+36atZ2R+2QA
         qoFHaT4dbTLnWYfSYd1A8lbpg8OSjV5JZ5aAoOLhM1W95zGyI152+xwRhQIi6b8ThOX/
         RHsg==
X-Gm-Message-State: AOJu0YxKjFqmNptnJg1GuYQhNrIf1qJHc6AsTA0AN/JPML5E2MYV8wxt
	6KmV1K6eFF5I75oD9abwVFk0dlXgzHAHc3o9kg6lDGOK
X-Google-Smtp-Source: AGHT+IEzDqhOut1KREmFrWLe+QG/NITaNhdTFcbHjufmkoxmoYPpZ7zZ11VJWIqQKnQGyX9v9BIiLWnuBQEeAkHRqzQ=
X-Received: by 2002:a05:6870:815:b0:1e9:9c39:a580 with SMTP id
 fw21-20020a056870081500b001e99c39a580mr22766888oab.7.1698947843923; Thu, 02
 Nov 2023 10:57:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231102-amdgpu-dml2-increase-frame-size-warning-for-clang-v2-1-b088a718131a@kernel.org>
In-Reply-To: <20231102-amdgpu-dml2-increase-frame-size-warning-for-clang-v2-1-b088a718131a@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Thu, 2 Nov 2023 13:57:12 -0400
Message-ID: <CADnq5_O_V7mxRP4PWv8+M0GaHb42N00NoyQqN-GiX0HKSgaS+A@mail.gmail.com>
Subject: Re: [PATCH v2] drm/amd/display: Increase frame warning limit with
 KASAN or KCSAN in dml2
To: Nathan Chancellor <nathan@kernel.org>
Cc: harry.wentland@amd.com, sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com, 
	alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com, 
	trix@redhat.com, llvm@lists.linux.dev, ndesaulniers@google.com, 
	patches@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	amd-gfx@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 2, 2023 at 1:41=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> When building ARCH=3Dx86_64 allmodconfig with clang, which will typically
> have sanitizers enabled, there is a warning about a large stack frame.
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/display_mode_core.c:6265:=
13: error: stack frame size (2520) exceeds limit (2048) in 'dml_prefetch_ch=
eck' [-Werror,-Wframe-larger-than]
>    6265 | static void dml_prefetch_check(struct display_mode_lib_st *mode=
_lib)
>         |             ^
>   1 error generated.
>
> Notably, GCC 13.2.0 does not do too much of a better job, as it is right
> at the current limit of 2048 (and others have reported being over with
> older GCC versions):
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/display_mode_core.c: In f=
unction 'dml_prefetch_check':
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/display_mode_core.c:6705:=
1: error: the frame size of 2048 bytes is larger than 1800 bytes [-Werror=
=3Dframe-larger-than=3D]
>    6705 | }
>         | ^
>
> In the past, these warnings have been avoided by reducing the number of
> parameters to various functions so that not as many arguments need to be
> passed on the stack. However, these patches take a good amount of effort
> to write despite being mechanical due to code structure and complexity
> and they are never carried forward to new generations of the code so
> that effort has to be expended every new hardware generation, which
> becomes harder to justify as time goes on.
>
> To avoid having a noticeable or lengthy breakage in all{mod,yes}config,
> which are easy testing targets that have -Werror enabled, increase the
> limit for configurations that have KASAN or KCSAN enabled by 50% so that
> cases of extremely poor code generation can still be caught while not
> breaking the majority of builds. CONFIG_KMSAN also causes high stack
> usage but the frame limit is already set to zero when it is enabled,
> which is accounted for by the check for CONFIG_FRAME_WARN=3D0 in the dml2
> Makefile.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> If there is another DRM pull before 6.7-rc1, it would be much
> appreciated if this could make that so that other trees are not
> potentially broken by this. If not, no worries, as it was my fault for
> not sending this sooner.

Applied.  Thanks!  Will send out a PR this week.

Alex


>
> Changes in v2:
> - Adjust workaround to check for either CONFIG_KASAN=3Dy or
>   CONFIG_KCSAN=3Dy, as the same problem has been reported with older
>   versions of GCC (Hamza, Alex)
> - Link to v1: https://lore.kernel.org/r/20231102-amdgpu-dml2-increase-fra=
me-size-warning-for-clang-v1-1-6eb157352931@kernel.org
> ---
>  drivers/gpu/drm/amd/display/dc/dml2/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/d=
rm/amd/display/dc/dml2/Makefile
> index 70ae5eba624e..acff3449b8d7 100644
> --- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
> @@ -60,8 +60,12 @@ endif
>  endif
>
>  ifneq ($(CONFIG_FRAME_WARN),0)
> +ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
> +frame_warn_flag :=3D -Wframe-larger-than=3D3072
> +else
>  frame_warn_flag :=3D -Wframe-larger-than=3D2048
>  endif
> +endif
>
>  CFLAGS_$(AMDDALPATH)/dc/dml2/display_mode_core.o :=3D $(dml2_ccflags) $(=
frame_warn_flag)
>  CFLAGS_$(AMDDALPATH)/dc/dml2/display_mode_util.o :=3D $(dml2_ccflags)
>
> ---
> base-commit: 21e80f3841c01aeaf32d7aee7bbc87b3db1aa0c6
> change-id: 20231102-amdgpu-dml2-increase-frame-size-warning-for-clang-c93=
bd2d6a871
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
