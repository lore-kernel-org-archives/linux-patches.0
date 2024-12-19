Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091641A0BE1;
	Thu, 19 Dec 2024 22:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734646915; cv=none; b=PrXk1caLkXOh40lz/ZHGQdR3IZt1fa5TRQ/JvYDMPmoVJUf9sjINsUCeAMJoDb04tvFUzQPVr3qX75ECBLAQTBYhaCBZU3q3jxZZ4XC91Kzm+dovocMHq/imLDllV0Z6errHbhGIb3uBVDR6fgECVEeeSBBOLRdW7jXXyvOFafE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734646915; c=relaxed/simple;
	bh=mRU3YNRSCcEdTqYHqnJz9r5++0Z9A8RsX+OeZtYeFoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=arNkUSyC5A/9iS1NbmLVQ9s15p7uk6BQXlGLmosCjm6HJCN8AOaydhTmN1Jaa8QnZ/MqcgEi4nW4XREv1qsq6sh2AdZ9zIPWoFol4tAIel4UkZCwm8+p8+JbHjDAJN18wAJwClZl6GmvZTxrdUlhPgP7w6Ghg7gG9gymT5Bl9fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TBQX9pD9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TBQX9pD9"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee8ecb721dso182524a91.3;
        Thu, 19 Dec 2024 14:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734646913; x=1735251713; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NpyOh9PEmR1wonp/zJLSpYnuM8i7MAUQCFZJqCoYXXM=;
        b=TBQX9pD9CQl29YA9MOwEeB3GZTnwCQ709gRERA0gyp0Wc+b9KdDxNGsIkC0sjDQS7r
         vlR4XuOXRT/s8GUpG7vstE0XoPG/4sggKec7sVrVCu/W5YTxJvcqt9UKYXOzWbKBUh9g
         O15tW7YS+cAiJS4OcZOY62m6RyIeu129ltlXN4efHJQAgMnwR97uWMOugT3hf98ptrod
         yIFUHQx+kf5EUXLy4TanpT6jdx+9ssBIbVevFZC9VeGGbEGkZxS3Tb7NQoGg/mOjnqb5
         WVxhLm4CwoJIYwkPJpws01tdCSX+CHqcvihH3MZIf4R6PFnbKESawT6UOQwfkJLjhbha
         tSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734646913; x=1735251713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NpyOh9PEmR1wonp/zJLSpYnuM8i7MAUQCFZJqCoYXXM=;
        b=IErhfhBUYtZkvksyKfKBevrCqxh2ObB3+kbcceSl4wwYg1OxgVDDlP1SqAI0CoE6UK
         FTJVBSq73hqHL1+54fWNq2EWl5DZThdE95w8/QTk9wi64tUhu6G/ohC9c14w4kk4zZXE
         7H0drPK+k5CtW487mWY0epUlaDjRrkBiWmmoHwlmX5JJxqOp8xxcjjhVFTBsaFgbD0bg
         Hs67QQ/aE99TNm2unmmfTrAT5I4vMdToklz4ZypYwdsJcZ8IhwDf03ncmi7BzPu5jdgu
         wooz5eabqQDYaMtt4sYLP1Z2WEBIrVpz8AAZTzl89NRsqrKdlQSwtnHUHmKcVhfGVaQ2
         H0NQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2bbIvmJ/OgxydVL2NN/0kcrqZh0Nsh/GLiLP5o0UV4QO4MDKMscD/VrleK4FuymnaAB1E@lists.linux.dev, AJvYcCWvIvNHFL21GGxSsL6M6cBsgW3yr+2HuMm3W+FOCpmDjv/gGmFAT60+TbuIXMaMyXsi/C/pVHxJ0g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwvuJ9o7iggqDcgYYxpFdntP8PSWoJ2EV6vn57n/4107maIQ3zr
	vhyjbNBmzhFXEu2zW5WqCiKZmdbZfvJ24GopcTsId8Uq170Z7KroAni0AStUDsWhRxHLVPYlhUb
	1r6BrEQHa0PVFoC1BcQqH6XRnRcI=
X-Gm-Gg: ASbGnculwSOWiCoBt0h9qzvVGZz0axmrX/DF8iAU3pstJpQzdwXlG7LQ8UAAXI1RKUi
	X0ZycDeHyZoNNsRLnnk0IziicvOvQ/uKpCa3fZQ==
X-Google-Smtp-Source: AGHT+IHk1/grqd1ADN6czf24WSJdap3R17icA82+hUB2wW2bK6YBJXVkJO05KC5cWNVn1MLq+HhTM0botvc7FLL8ToU=
X-Received: by 2002:a17:90b:3d47:b0:2ee:3fa7:ef23 with SMTP id
 98e67ed59e1d1-2f452efbf6fmr357914a91.8.1734646913184; Thu, 19 Dec 2024
 14:21:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241219-amdgpu-fix-enum-float-conversion-again-again-v1-1-ef2c619724b1@kernel.org>
In-Reply-To: <20241219-amdgpu-fix-enum-float-conversion-again-again-v1-1-ef2c619724b1@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Thu, 19 Dec 2024 17:21:41 -0500
Message-ID: <CADnq5_NKWH7UC_ow825aAtF1tZXJTVOwDWaqDR8_4Y6EmPXUiA@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Disable -Wenum-float-conversion for dml2_dpmm_dcn4.c
To: Nathan Chancellor <nathan@kernel.org>
Cc: Chaitanya Dhere <chaitanya.dhere@amd.com>, Jun Lei <jun.lei@amd.com>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Xinhui Pan <Xinhui.Pan@amd.com>, Austin Zheng <Austin.Zheng@amd.com>, 
	Dillon Varone <dillon.varone@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024 at 12:23=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> Commit be4e3509314a ("drm/amd/display: DML21 Reintegration For Various
> Fixes") blew away commit fdedd77b0eb3 ("drm/amd/display: Reapply
> 2fde4fdddc1f"), which itself was a reapplication for the same reason,
> which results in that compiler warning returning:
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_dpmm/dml2_=
dpmm_dcn4.c:215:58: error: arithmetic between enumeration type 'enum dentis=
t_divider_range' and floating-point type 'double' [-Werror,-Wenum-float-con=
version]
>     215 |         divider =3D (unsigned int)(DFS_DIVIDER_RANGE_SCALE_FACT=
OR * (vco_freq_khz / clock_khz));
>         |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
 ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Just disable the warning for the whole file via Makefile to avoid having
> to reapply the same fix every time the code syncs from wherever it is
> actually maintained.
>
> Fixes: be4e3509314a ("drm/amd/display: DML21 Reintegration For Various Fi=
xes")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> If you would prefer reapplying the local fix, feel free to do so, but I
> would like for it to be in the upstream source so it does not have to
> keep being applied.

I've reapplied the original fix and I've confirmed that the fix will
be pushed to the DML tree as well this time.

Thanks,

Alex

> ---
>  drivers/gpu/drm/amd/display/dc/dml2/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/d=
rm/amd/display/dc/dml2/Makefile
> index d9c27ebe12ee08d6330eb199cd8ca9c8489fa5b2..5c0f93644c5d43c8a0bc12713=
fc400712d8de50b 100644
> --- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
> @@ -78,7 +78,7 @@ CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_top/dml2_to=
p_soc15.o :=3D $(dml2_ccfla
>  CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4.o :=3D $=
(dml2_ccflags)
>  CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.o =
:=3D $(dml2_ccflags) $(frame_warn_flag)
>  CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_factory.o :=
=3D $(dml2_ccflags)
> -CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.o :=3D $=
(dml2_ccflags)
> +CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.o :=3D $=
(dml2_ccflags) $(call cc-disable-warning,enum-float-conversion)
>  CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_factory.o :=
=3D $(dml2_ccflags)
>  CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_mcg/dml2_mcg_dcn4.o :=3D $(d=
ml2_ccflags)
>  CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_mcg/dml2_mcg_factory.o :=3D =
$(dml2_ccflags)
>
> ---
> base-commit: 695c2c745e5dff201b75da8a1d237ce403600d04
> change-id: 20241219-amdgpu-fix-enum-float-conversion-again-again-cbfd9159=
f76d
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
