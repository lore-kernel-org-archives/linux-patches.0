Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4586619513
	for <patches@lists.linux.dev>; Wed, 24 May 2023 18:32:44 +0000 (UTC)
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-75b050b75a1so4995585a.1
        for <patches@lists.linux.dev>; Wed, 24 May 2023 11:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684953163; x=1687545163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kx7mM+wlBDag2NiqFv59OekQ4/nY4NVg+DZAOXRKXf0=;
        b=xvPJ1K05zCBWblZd67vxLGCp6Fs+2fWU9qpTjFSEcuFnpSG1Izc3zqpldFcHKBM4MW
         OIUWObsCfhcTq/5nAlIpefJABNW0+2q8LQX4IFjhDtilNEc2hGw8Tge/INsCdF3j6XqA
         iGvgPYKXHOZNQcdf7NaiLMPKaSW2wD9L3c43Xh6Kdc7bhDnoZCGxRw9oV9Kp6jc9JnDU
         3S/YXMijoNLuCrDd1yF0zpI1yHrzeMGb6v+SvE8EFiudRK00ZMgpsXOcx4L8NvbIjG/t
         wNZWw4oUMLjNpZaYUKcfoN5KljLt5Wd0bWknN5Yn1fMsvl8lXZflNopgfTyl4mo5d0ox
         dhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684953163; x=1687545163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kx7mM+wlBDag2NiqFv59OekQ4/nY4NVg+DZAOXRKXf0=;
        b=KYGE9vppRIlfe5lvpw1JiUvapL4ttBnLDleEAX70dZmAPwx9Ylu2HdjkDjWYKbjmuQ
         72a1anx5243v6GlSdzDf6UOwIqrH+Lnyfqmrg8dy63tIoKFyOHUiLDHX/wltJG0tnB6T
         4+2N5fdFHUY6ANzaxO9vVs6LMcj2lMhLFYP/7wqymyJ+KZCjO1qK48OoeVojuj7Zfd6+
         RbYyNReuRM/JD+MQpWobPawS6XWZjcGW501MsQKUhUIuGauLzslX92CMzCbtw+UUbr5L
         TLrJyMd0xCrSl62JO3SeMnyYmstfY6gC7OfD8RLHiiOMPTL1i7WNyUAZcpxUzQgnJ5Ig
         YoxA==
X-Gm-Message-State: AC+VfDyEQPtJkjNM9ymQLMiXWhgk1b5r7SKa1FOkqf8TQCrChCALpRxY
	246aYhI2WkWdyiopzalgnC6aNZFkwWuA7frzA/7JNQ==
X-Google-Smtp-Source: ACHHUZ718i5kUzBcUx1gbb52XudfRIB3OBcG9q6EKb7cotiF7zF1M86ob4jRGYIYhZIJCyGRABXQJo639vqSkahfT9M=
X-Received: by 2002:a05:6214:248d:b0:623:8ce1:6ccd with SMTP id
 gi13-20020a056214248d00b006238ce16ccdmr34441476qvb.14.1684953163083; Wed, 24
 May 2023 11:32:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524-intel_async_flip_check_hw-implicit-fallthrough-v1-1-83de89e376a1@kernel.org>
In-Reply-To: <20230524-intel_async_flip_check_hw-implicit-fallthrough-v1-1-83de89e376a1@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 24 May 2023 11:32:32 -0700
Message-ID: <CAKwvOd=jZJouuNMd3Rvc--goA0EXPHcf6cHXUA6W1kXJg2ay2w@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Fix clang -Wimplicit-fallthrough in intel_async_flip_check_hw()
To: Nathan Chancellor <nathan@kernel.org>
Cc: jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, 
	rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com, trix@redhat.com, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>, Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 24, 2023 at 8:38=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns:
>
>   drivers/gpu/drm/i915/display/intel_display.c:6012:3: error: unannotated=
 fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>                   case I915_FORMAT_MOD_X_TILED:
>                   ^
>   drivers/gpu/drm/i915/display/intel_display.c:6012:3: note: insert 'brea=
k;' to avoid fall-through
>                   case I915_FORMAT_MOD_X_TILED:
>                   ^
>                   break;
>   1 error generated.
>
> Clang is a little more pedantic than GCC, which does not warn when
> falling through to a case that is just break or return. Clang's version
> is more in line with the kernel's own stance in deprecated.rst, which
> states that all switch/case blocks must end in either break,
> fallthrough, continue, goto, or return. Add the missing break to silence
> the warning.
>
> Fixes: 937859485aef ("drm/i915: Support Async Flip on Linear buffers")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/202305241902.UvHtMoxa-lkp@intel.com/
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Closes: https://lore.kernel.org/CA+G9fYv68V3ewK0Qj-syQj7qX-hQr0H1MFL=3DQF=
NuDoE_J2Zu-g@mail.gmail.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch! I've never seen the closes tag before, that's
new to me. Can you tell me more about it?

A few more tags

Reported-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/all/20230523125116.1669057-1-trix@redhat.com/
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>


> ---
>  drivers/gpu/drm/i915/display/intel_display.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/d=
rm/i915/display/intel_display.c
> index 0490c6412ab5..6d49e0ab3e85 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -6008,6 +6008,7 @@ static int intel_async_flip_check_hw(struct intel_a=
tomic_state *state, struct in
>                                             plane->base.base.id, plane->b=
ase.name);
>                                 return -EINVAL;
>                         }
> +                       break;
>
>                 case I915_FORMAT_MOD_X_TILED:
>                 case I915_FORMAT_MOD_Y_TILED:
>
> ---
> base-commit: 9a2cb1b31c040e2f1b313e2f7921f0f5e6b66d82
> change-id: 20230524-intel_async_flip_check_hw-implicit-fallthrough-c4c40b=
03802f
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Thanks,
~Nick Desaulniers
