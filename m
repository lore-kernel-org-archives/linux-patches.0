Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC3E3D6B;
	Mon, 24 Oct 2022 15:27:07 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id a14-20020a9d470e000000b00661b66a5393so6060579otf.11;
        Mon, 24 Oct 2022 08:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nub8BP8GK64yoOEOVp/VCw/GranT7qsuMJj9rUXtDDA=;
        b=iRF9APagwpOQ6U/BO5CHcMMIOGjLT4OwMWfaw5FBv5PbU/XHsctLi/oMCwvapYDdHf
         E1rOp4GbohVg1TLh57BEG2CoR0sZHDgQjrWr/7bvOINl2I6Dn0Av24R9WDQF1Osg3PAY
         vVqADyKG2vPSRe2gJfT2tkk2sPwfa/Mer+ALTFz002xD37BMLVQZSQlQ4EEwkw/rl8Oe
         SwasYlGv4ZH4vdRO2ST+9D5OuPA+KTn3z3WHcdfiLBSKjQROE+EyODHCfrX0sg2TkZpb
         Zl9mlCx3Eq/togle/IHwzYUqWoOMza2xA/Ry8Yc1sBhHCKGRF3/rdUL0htUh+obpr2Xz
         pNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nub8BP8GK64yoOEOVp/VCw/GranT7qsuMJj9rUXtDDA=;
        b=UrizI5m/NqZdK7AyjmDdftJcejzLFPjKr29jjfs26ZcqidF4i9tBFfmbc1eRK0/3O4
         2i7lFCEAAOjngnXRkI3fItHLmeqNUJ94433E1kjb5/CsXqfZsuk1n4bq7si4cBl9k6He
         UIgVJVLsunZUPIaDHFHhgE75O40BHYwJU+Oh4Uk6f1AYjtP4yyaYrQrLr5oDIAU6afXz
         AGy230eKpMg5/7jqB2IWiWVRdF+YB41S2ITdQrXp1LT32DqU2l+E8zSFZmY5h5+DsCyI
         iS4yEIgnY6fii6xKkMRWB/6QzWlesTmziWUNAzjx6GOu4bKuzdKc/e6oDjw8pQunrzAz
         lqZQ==
X-Gm-Message-State: ACrzQf0ZZ7sMR5cmiXQq3WYmsRBa3b9Z28fTgbfY2/dMY5utfGkITSws
	gbgzzy+MfZcpD0h/X9Atka7TtCQof1Svl2MMl2I=
X-Google-Smtp-Source: AMsMyM4/bhQvenoyCezxgqiDKYW+75o2ItfjCqdf8xA2HZ030BPYzRlZPg6WCThDy7uDjX+ADkpnTzMDjEKqn02sK2c=
X-Received: by 2002:a9d:6645:0:b0:661:b778:41b8 with SMTP id
 q5-20020a9d6645000000b00661b77841b8mr17129566otm.233.1666625226162; Mon, 24
 Oct 2022 08:27:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221024151953.2238616-1-nathan@kernel.org>
In-Reply-To: <20221024151953.2238616-1-nathan@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Mon, 24 Oct 2022 11:26:52 -0400
Message-ID: <CADnq5_PotEg3naWq111RKbRFsxSd_ETN4J8tE+V+fhhrJqCygg@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: Fix uninitialized warning in mmhub_v2_0_get_clockgating()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Lijo Lazar <lijo.lazar@amd.com>, Tom Rix <trix@redhat.com>, 
	llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>, patches@lists.linux.dev, 
	dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"

Applied.  Thanks!

Alex

On Mon, Oct 24, 2022 at 11:20 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns:
>
>   drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c:686:3: error: variable 'data' is uninitialized when used here [-Werror,-Wuninitialized]
>                   data |= MM_ATC_L2_MISC_CG__ENABLE_MASK;
>                   ^~~~
>   drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c:674:10: note: initialize the variable 'data' to silence this warning
>           int data, data1;
>                   ^
>                   = 0
>   1 error generated.
>
> This clearly should have just been a regular '=', as there was no prior
> assignment.
>
> Fixes: 7a4fad619819 ("drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1748
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
> index 5ec6d17fed09..998b5d17b271 100644
> --- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
> @@ -683,7 +683,7 @@ static void mmhub_v2_0_get_clockgating(struct amdgpu_device *adev, u64 *flags)
>                 /* There is no ATCL2 in MMHUB for 2.1.x. Keep the status
>                  * based on DAGB
>                  */
> -               data |= MM_ATC_L2_MISC_CG__ENABLE_MASK;
> +               data = MM_ATC_L2_MISC_CG__ENABLE_MASK;
>                 data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
>                 break;
>         default:
>
> base-commit: fb5e487f910e1105019b883e8ed25e36e4bfd657
> --
> 2.38.1
>
