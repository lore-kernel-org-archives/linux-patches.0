Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439CA29CA;
	Wed, 24 Jul 2024 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721840031; cv=none; b=QMvqk780/dTQHJKx5Hph7kk+PF4muAWJf76rwWn77gwGpwQdZ1A1vN5i/v/0nFQf3xfRmUxHm4ixIe5Ovh15yIDj26szfNe/whGhcb9HAvWP6dbVllBbUG4806Z5V/nNnLdq1x5W15KQjvWi4mPjwVYYDGZQpbNbfdf7xMrTM3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721840031; c=relaxed/simple;
	bh=OzSYFnTbzdkzUkGP46jK7DV7EI4vEvo+Bwf/Jpdw4mw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NLpYdHKPdTrkK91H78i6UPdO001HVdboSNEgRBsr9c5fQmQFSfD0Tg5pJA6MIUOINp7aeA9bsgdM1EgLrZZYpwyA66F/HLrQP+GasFw5mvGOeUD3W/jpjkZn6ifDZEJMtVGQXEnHPLXITYQxeV1qNVGy5fzyESBuWPpy7ZhtPeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A6A1j9HQ; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A6A1j9HQ"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-260e3e295a7so3981284fac.3;
        Wed, 24 Jul 2024 09:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721840029; x=1722444829; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NvLHGP7NtgU2zYg3eBNSuq3Vab7Pm5T+4+N9Ml7WexE=;
        b=A6A1j9HQAI53cwlVDjPwAK0vPMRsPnUBvQ15Vy1mPnQmzfRL6Y3UzjRh7va9NUJ3V8
         TADiD/bafVZFIU1LfdA7bFujKp2ezAX7JixmiwE4sxXoTqY2ZY2ICEcnmuhs9Qc+L0I9
         0pv6QaGAJBFUhCUVuqeNu6Wiz6tzuragyWEf0gYBGkj61erbDE72T15u9qdI5CyGZg7w
         EbPDZhfmFl6X5wYjL+FjEEkJVkwOUgHfuC4i0vZbBXtvKzIKksaDPo8dqwI2hqwJgaU8
         xluZxEBBzIhNZexkRG8Y3dLWy1TSMC9U5iwWx+FbEDO1CnIELFEYComCqC52O7+ia3w6
         jLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721840029; x=1722444829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NvLHGP7NtgU2zYg3eBNSuq3Vab7Pm5T+4+N9Ml7WexE=;
        b=EDm5i46/aM8LggHtT9htU8p4Yt9M5Mcs8+VpksLqqbRQ67MxN4a/pNvhkexr9eA09W
         t3kDSKLohH+Fr143nql4QnC3AD9+DOUyrWAVC+zalEwjBC8Z7l28VaX3PAUFf26jPgub
         KkSEDkW7sFl58SHyFQYBkLFW3TWde45duURh2DZCkHkse6tqt3npy+F/RoVSOdM5k//G
         VGo2N31thpP/FC/0+RnVNAHRQ5qeqOFsGS7ewlXV/F0g0Koc8oI6D7I7DqOMhmHGtPFI
         fYrsEpDy07134Ge3gaHjVrh3Vm4GMLb3BrRdu5j9zBbFw3+S6RPxMHDtYZKFwH3Gniye
         dtGg==
X-Forwarded-Encrypted: i=1; AJvYcCURrgnNVYvQYVWpYFPEx+UBjkux5hLxnANLFnHsQE65MHW3MbP86vQxGIUTjUYsQX7O0pJjZaVAOR+9Pdx0r1m1XGx0iDflCEN3Pu6Juqdo4xg+vRYdcj6KW2ScqX4=
X-Gm-Message-State: AOJu0YzR77lh7faj+CedeBhxXs2kjw3Wqvr3Jcf/3UGmpUstxxbtcKmC
	MxezVy3Qjma2Dx9pGA9LggyldjhOK12BxhJ6RsAGBc8GhjwPsjk5MTZSGOTlP6nfy4KZnpF+u2K
	BSUEYQO7JaR07W/8Uqfn3hzUX+dI=
X-Google-Smtp-Source: AGHT+IEbq31zJ8FEqU0AqZdlXaLrABGr5CixketK3hxxAzSb5AIrpBGwPrOVrdCmrACNXxmgFZzx7TDERf/Ody34MtQ=
X-Received: by 2002:a05:6871:811:b0:25e:8509:160e with SMTP id
 586e51a60fabf-264a0c091e5mr163881fac.3.1721840029071; Wed, 24 Jul 2024
 09:53:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724-amdgpu-dml2-fix-float-enum-warning-again-v1-1-740e7946f77a@kernel.org>
In-Reply-To: <20240724-amdgpu-dml2-fix-float-enum-warning-again-v1-1-740e7946f77a@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 24 Jul 2024 12:53:37 -0400
Message-ID: <CADnq5_ModC1+noYkpBm1bQMT6heE1vLTi+6CdPKPo2DkbagOgg@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Reapply 2fde4fdddc1f
To: Nathan Chancellor <nathan@kernel.org>
Cc: Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Xinhui Pan <Xinhui.Pan@amd.com>, Aurabindo Pillai <aurabindo.pillai@amd.com>, 
	Chaitanya Dhere <chaitanya.dhere@amd.com>, Jerry Zuo <jerry.zuo@amd.com>, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.  Thanks!

On Wed, Jul 24, 2024 at 11:50=E2=80=AFAM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> Commit 2563391e57b5 ("drm/amd/display: DML2.1 resynchronization") blew
> away the compiler warning fix from commit 2fde4fdddc1f
> ("drm/amd/display: Avoid -Wenum-float-conversion in
> add_margin_and_round_to_dfs_grainularity()"), causing the warning to
> reappear.
>
>   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_dpmm/dml2_=
dpmm_dcn4.c:183:58: error: arithmetic between enumeration type 'enum dentis=
t_divider_range' and floating-point type 'double' [-Werror,-Wenum-float-con=
version]
>     183 |         divider =3D (unsigned int)(DFS_DIVIDER_RANGE_SCALE_FACT=
OR * (vco_freq_khz / clock_khz));
>         |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
 ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
>
> Apply the fix again to resolve the warning.
>
> Fixes: 2563391e57b5 ("drm/amd/display: DML2.1 resynchronization")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  .../gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.c    =
| 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2=
_dpmm_dcn4.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2=
_dpmm_dcn4.c
> index 0021bbaa4b91..f19f6ebaae13 100644
> --- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_d=
cn4.c
> +++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_d=
cn4.c
> @@ -180,7 +180,7 @@ static bool add_margin_and_round_to_dfs_grainularity(=
double clock_khz, double ma
>
>         clock_khz *=3D 1.0 + margin;
>
> -       divider =3D (unsigned int)(DFS_DIVIDER_RANGE_SCALE_FACTOR * (vco_=
freq_khz / clock_khz));
> +       divider =3D (unsigned int)((int)DFS_DIVIDER_RANGE_SCALE_FACTOR * =
(vco_freq_khz / clock_khz));
>
>         /* we want to floor here to get higher clock than required rather=
 than lower */
>         if (divider < DFS_DIVIDER_RANGE_2_START) {
>
> ---
> base-commit: bd4bea5ab2bda37ddb092a978218c4d9b46927e6
> change-id: 20240724-amdgpu-dml2-fix-float-enum-warning-again-647a33789138
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
