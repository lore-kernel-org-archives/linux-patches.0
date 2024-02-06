Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E8E13249E;
	Tue,  6 Feb 2024 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707230694; cv=none; b=mbXTOse78aAxlTV9hQKYe37sLcR66Zx1swda9RP3FC1Z1WzfWLJiDtNSCh6iKoLOn8w1TB195D9aX2FPm+6/iopCqAj7tHM/sLXiu8b4bTw08ILXmYjuuuV0GAhRpI6D1+CgMBS5oD5UdNflO878hE9w/6rxq5/jv93FD6544Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707230694; c=relaxed/simple;
	bh=kLzvA/GRNTVv1kRX2H3c4v6G8uj/+CXni/hGUK053Lc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OQ+OJKSfu+qUk+JcR3nzk7vgsGIj1at0RjeMpoQUxK06ufVLW26DzJWM67hnqLd7i0hE/Q42jrZhKmQKaZt9Ct6L7ac7UM63kLOfmchxguh14ed+8igyG+mj+f1dYFSDhsnBtrl3NjiKhbX9RlUwl2P1E67r6pV0jA+xr9bNXmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lof75yzB; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lof75yzB"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2184133da88so3270287fac.0;
        Tue, 06 Feb 2024 06:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707230692; x=1707835492; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+20KhE5CzGghzyw+yh5TsIxVW9/ObxNGsBkKGzjlNGA=;
        b=Lof75yzB7ZZIdhXDURYevyf77ceem9WzCB+MuDgV6Zg7SnnHBXjjpD76GDImw6E8wi
         gjBbRqB525rjWqBeX5ec1Xb282QioRcyU/zE5dYkrqx1PXxp4NjM2DxCdUyRiYusA6Xj
         OGZ1vmVegj/4neFVO+enczGENIhBDhmM+sGyYstte3B0jVtIYcoA90JWYVW9VnNywnmO
         tiQ+wmkedY0IuqA8ORQ7I8uiJ7osw0XBAPxvppS3d/jpC4f5Z/QdinepouJK3kw+rBHW
         TVp67TyZsaFdRew5EFYqPwm/2ZBTMTxjKYoWciNpBj7TUOKYqSTnswB5XnjxL7g8s4R6
         U1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707230692; x=1707835492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+20KhE5CzGghzyw+yh5TsIxVW9/ObxNGsBkKGzjlNGA=;
        b=sfQ8p7z0YHg0aDdGEB1SbIkGDgjrbfrwPT9VoMUuURj2oUjFDuTiRGc6JoYpj8wa18
         mqjohtEGJgLKE8WmOAGpR2Q6XNv95j3hfFUkY7x2YPBx8yGG45LBVv4yKCeFw/LZiFcX
         B3KOIQG0xKnEEUwTuBZkG0hdR8dPTJaGa9vMGWzdY/kHT11AkQngu2JnjutfF3W2dfpU
         OF0FFtQfJWrLxln2F1qGtN2EpCEpWfqdph9gty1+K9V9a4fgo4ZkWuJ10nQ9g43j5BXQ
         ZeJr1LiQ4ILQopBce3Ac07M9x9xL5p2t1FGuP0eUKIzrapb1gKuCSEwILnTTYCxKbKBH
         eoEA==
X-Gm-Message-State: AOJu0YzSmVz1HRkDIIVkM3TsXn3Nt0O1C/+ewbEBdKr6ovGKeXAtaAoU
	bq6z7xZWSJYL2Q/kOhA9kS7FOUoqfTwy5JjKxB6tshvXsxzWz4cWANeczscdWqS+IhUvPZDrADS
	8ATDWytwX8+ymaDXgZ3wQt8CMQRs=
X-Google-Smtp-Source: AGHT+IF0WZWM6Ib5EqucHZaEu5uV8FtMlbuTK8HqLl2KoroGz2pfdLgomL1X+7K8CnT8yIn7ZCEgAcp+W+dbQdJdLrU=
X-Received: by 2002:a05:6870:638c:b0:219:3d70:97b9 with SMTP id
 t12-20020a056870638c00b002193d7097b9mr3072489oap.37.1707230692108; Tue, 06
 Feb 2024 06:44:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240205-amdgpu-raise-flt-for-dml-vba-files-v1-1-9bc8c8b98fb4@kernel.org>
In-Reply-To: <20240205-amdgpu-raise-flt-for-dml-vba-files-v1-1-9bc8c8b98fb4@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 6 Feb 2024 09:44:40 -0500
Message-ID: <CADnq5_OZq2s2wcLcMccMuk2Vrk2dzYu9uQdfM3hbzciB_AWbMQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Increase frame-larger-than for all
 display_mode_vba files
To: Nathan Chancellor <nathan@kernel.org>
Cc: harry.wentland@amd.com, sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com, 
	alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com, 
	morbo@google.com, justinstitt@google.com, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.  Thanks!

On Mon, Feb 5, 2024 at 5:08=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> After a recent change in LLVM, allmodconfig (which has CONFIG_KCSAN=3Dy
> and CONFIG_WERROR=3Dy enabled) has a few new instances of
> -Wframe-larger-than for the mode support and system configuration
> functions:
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn20/display_mode_vba_20v=
2.c:3393:6: error: stack frame size (2144) exceeds limit (2048) in 'dml20v2=
_ModeSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
>    3393 | void dml20v2_ModeSupportAndSystemConfigurationFull(struct displ=
ay_mode_lib *mode_lib)
>         |      ^
>   1 error generated.
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn21/display_mode_vba_21.=
c:3520:6: error: stack frame size (2192) exceeds limit (2048) in 'dml21_Mod=
eSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
>    3520 | void dml21_ModeSupportAndSystemConfigurationFull(struct display=
_mode_lib *mode_lib)
>         |      ^
>   1 error generated.
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn20/display_mode_vba_20.=
c:3286:6: error: stack frame size (2128) exceeds limit (2048) in 'dml20_Mod=
eSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
>    3286 | void dml20_ModeSupportAndSystemConfigurationFull(struct display=
_mode_lib *mode_lib)
>         |      ^
>   1 error generated.
>
> Without the sanitizers enabled, there are no warnings.
>
> This was the catalyst for commit 6740ec97bcdb ("drm/amd/display:
> Increase frame warning limit with KASAN or KCSAN in dml2") and that same
> change was made to dml in commit 5b750b22530f ("drm/amd/display:
> Increase frame warning limit with KASAN or KCSAN in dml") but the
> frame_warn_flag variable was not applied to all files. Do so now to
> clear up the warnings and make all these files consistent.
>
> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issue/1990
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/amd/display/dc/dml/Makefile | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/dr=
m/amd/display/dc/dml/Makefile
> index 6042a5a6a44f..59ade76ffb18 100644
> --- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
> @@ -72,11 +72,11 @@ CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_lib.o :=3D $=
(dml_ccflags)
>  CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_vba.o :=3D $(dml_ccflags)
>  CFLAGS_$(AMDDALPATH)/dc/dml/dcn10/dcn10_fpu.o :=3D $(dml_ccflags)
>  CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/dcn20_fpu.o :=3D $(dml_ccflags)
> -CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20.o :=3D $(dml_ccfla=
gs)
> +CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20.o :=3D $(dml_ccfla=
gs) $(frame_warn_flag)
>  CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_rq_dlg_calc_20.o :=3D $(dml_cc=
flags)
> -CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20v2.o :=3D $(dml_ccf=
lags)
> +CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20v2.o :=3D $(dml_ccf=
lags) $(frame_warn_flag)
>  CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_rq_dlg_calc_20v2.o :=3D $(dml_=
ccflags)
> -CFLAGS_$(AMDDALPATH)/dc/dml/dcn21/display_mode_vba_21.o :=3D $(dml_ccfla=
gs)
> +CFLAGS_$(AMDDALPATH)/dc/dml/dcn21/display_mode_vba_21.o :=3D $(dml_ccfla=
gs) $(frame_warn_flag)
>  CFLAGS_$(AMDDALPATH)/dc/dml/dcn21/display_rq_dlg_calc_21.o :=3D $(dml_cc=
flags)
>  CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_mode_vba_30.o :=3D $(dml_ccfla=
gs) $(frame_warn_flag)
>  CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_rq_dlg_calc_30.o :=3D $(dml_cc=
flags)
>
> ---
> base-commit: 6813cdca4ab94a238f8eb0cef3d3f3fcbdfb0ee0
> change-id: 20240205-amdgpu-raise-flt-for-dml-vba-files-ee5b5a9c5e43
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
