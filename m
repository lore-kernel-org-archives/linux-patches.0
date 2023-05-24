Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB2AC13A;
	Wed, 24 May 2023 18:51:03 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-19674cab442so495786fac.3;
        Wed, 24 May 2023 11:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684954263; x=1687546263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fh+vsCfQhWMTg601LSuJ7dosZCBsyljcCI/FGdQ7IFo=;
        b=N+2xxIX5+s0dqsPU37iciIjhPlC28VKz/AYi1eSQJUbEAUSmQhU+qLYsJOWj34NyiD
         ZvL3M5fuHUgaTKU0sFRBDPXyivvJOPQXzCPA2Higv5SGOrCUykNZz6atWnuJdEyM3/SS
         qge9WM7LugfKyLWwuRNXxs+efsYid9+w4S57tr3s5QS18IUUDUAlItF3QzQmvdmey861
         uEUxcJpoyUZRHmGENebnb9bdwhhktKNqd8ykkL0C6hWKauw/fU9TEnfd9nH6DXLjMxDu
         Blj28lcCCd8BT8adBmFV5yFzX3sjTYO++Tvo8/PGIP57vNJpz0Yv8mdk7PiCciDuN/wH
         7psg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684954263; x=1687546263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fh+vsCfQhWMTg601LSuJ7dosZCBsyljcCI/FGdQ7IFo=;
        b=iHr00AvhC5lkI+eVNqc6svUxU9wjxaDf0TuFfo8vv18Ie1uMUP+MBcN+U8TpK8HttO
         HR+A5M+pur6FyIwpTdFKujLTqW4gAVXSWbyHrUmOB1OEp+F0Mw6Bs0h+kBvvd6MJ/BOb
         3OVIGLbsGYAA66Mw5lD4NXS2v1zVRzzmiCf2jjm+P8x/vkCwbn/prufOSmX39fOoWdIU
         aJKLnK7/koVmev4D9K66zSX/g1yWIw1oFYPh2HuiYxyyqGf/lhFx0vv64YJUi9wKcdoA
         fnBXE8r3Y+CDkFcQSTGlGwP1onHIzJbuaq/nRvz7gt6zvQ+7W3F8NziHj6E6/g6T8T6I
         EZUw==
X-Gm-Message-State: AC+VfDx+y9Yl9B9GZSKf9UPrl0fhUUK/0OvMJ95lXjtXiQ41CvES19+f
	OZGUaptd5iv/xoX72M5msHzdlnGQWcygsrwdD2M=
X-Google-Smtp-Source: ACHHUZ56MBkHwuJZUxtHdnEmW+CctVr/y6MwOU/WfTd0k8F+Qa4utnXsYUMxDo2Ul/b6ay1xTR7WpL7PVVLtW7k7um4=
X-Received: by 2002:a05:6870:d413:b0:19b:9835:a2cc with SMTP id
 i19-20020a056870d41300b0019b9835a2ccmr382637oag.30.1684954262854; Wed, 24 May
 2023 11:51:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524-nbio_v7_9-wincompatible-function-pointer-types-strict-v1-1-da17e01907cf@kernel.org>
In-Reply-To: <20230524-nbio_v7_9-wincompatible-function-pointer-types-strict-v1-1-da17e01907cf@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 24 May 2023 14:50:51 -0400
Message-ID: <CADnq5_OXzN3_9r8_X9ESx_axvGw-sNdGfPbU0NZuwQ+gFzZEag@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: Fix return types of certain NBIOv7.9 callbacks
To: Nathan Chancellor <nathan@kernel.org>
Cc: alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com, 
	trix@redhat.com, llvm@lists.linux.dev, ndesaulniers@google.com, 
	patches@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	amd-gfx@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.  Thanks!

On Wed, May 24, 2023 at 12:44=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> When building with clang's -Wincompatible-function-pointer-types-strict,
> which ensures that function pointer signatures match exactly to avoid
> tripping clang's Control Flow Integrity (kCFI) checks at run time and
> will eventually be turned on for the kernel, the following instances
> appear in the NBIOv7.9 code:
>
>   drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c:465:32: error: incompatible func=
tion pointer types initializing 'int (*)(struct amdgpu_device *)' with an e=
xpression of type 'enum amdgpu_gfx_partition (struct amdgpu_device *)' [-We=
rror,-Wincompatible-function-pointer-types-strict]
>           .get_compute_partition_mode =3D nbio_v7_9_get_compute_partition=
_mode,
>                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~
>   drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c:467:31: error: incompatible func=
tion pointer types initializing 'u32 (*)(struct amdgpu_device *, u32 *)' (a=
ka 'unsigned int (*)(struct amdgpu_device *, unsigned int *)') with an expr=
ession of type 'enum amdgpu_memory_partition (struct amdgpu_device *, u32 *=
)' (aka 'enum amdgpu_memory_partition (struct amdgpu_device *, unsigned int=
 *)') [-Werror,-Wincompatible-function-pointer-types-strict]
>           .get_memory_partition_mode =3D nbio_v7_9_get_memory_partition_m=
ode,
>                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~
>   2 errors generated.
>
> Change the return types of these callbacks to match the prototypes to
> clear up the warning and avoid tripping kCFI at run time. Both functions
> return a value from ffs(), which is an integer that can fit into either
> int or unsigned int.
>
> Fixes: 11f64eb1472f ("drm/amdgpu: add sysfs node for compute partition mo=
de")
> Fixes: 41a717ea8afc ("drm/amdgpu: detect current GPU memory partition mod=
e")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c b/drivers/gpu/drm/amd=
/amdgpu/nbio_v7_9.c
> index e082f6343d20..d19325476752 100644
> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
> @@ -382,7 +382,7 @@ static void nbio_v7_9_enable_doorbell_interrupt(struc=
t amdgpu_device *adev,
>                               DOORBELL_INTERRUPT_DISABLE, enable ? 0 : 1)=
;
>  }
>
> -static enum amdgpu_gfx_partition nbio_v7_9_get_compute_partition_mode(st=
ruct amdgpu_device *adev)
> +static int nbio_v7_9_get_compute_partition_mode(struct amdgpu_device *ad=
ev)
>  {
>         u32 tmp, px;
>
> @@ -408,8 +408,8 @@ static void nbio_v7_9_set_compute_partition_mode(stru=
ct amdgpu_device *adev,
>         WREG32_SOC15(NBIO, 0, regBIF_BX_PF0_PARTITION_COMPUTE_STATUS, tmp=
);
>  }
>
> -static enum amdgpu_memory_partition
> -nbio_v7_9_get_memory_partition_mode(struct amdgpu_device *adev, u32 *sup=
p_modes)
> +static u32 nbio_v7_9_get_memory_partition_mode(struct amdgpu_device *ade=
v,
> +                                              u32 *supp_modes)
>  {
>         u32 tmp;
>
>
> ---
> base-commit: fd8f7bb391fa9c1979232cb5ab5bedb08abc855d
> change-id: 20230524-nbio_v7_9-wincompatible-function-pointer-types-strict=
-c894636ce146
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
