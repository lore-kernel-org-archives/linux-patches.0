Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91CD2E0D8
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 17:30:28 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6b2e1023f30so4688222a34.1
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 10:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686850227; x=1689442227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBFAQ+OspbXgxiU1uwcjpJ+KgjxBMeHaD8ugzzQiLeU=;
        b=DYHm+gT66KuV9e2kX1K7tNs1xU9tgGlItzNUZ1iRBBQrwfCAkcDV9cnKKHaAGB7M9F
         sZmsZhyTndnwepjYMLa2x+v0MEVo5U0Sfr+NPf+wLdWHanjR4HaLDjGs+e5jwh82zGJb
         XoPrahc5N5C7FPPy/fqyg/VgQgCHoMMlZFUH/SgUoYapNzCrmFkRy/PUvqRFgGLUEf5v
         e6EJggAmMKnti3SDZTfyA6vlK6/RfPZRbvbveMXA9fnM0l27BjwSMLJoBy8GrfYk5DM5
         k62BhikLVPBOtMOo7uHGqfzTaDvb7zErRS0o8+AdxXLjcTHQMXSE9vqv4Jh2tAm8oVOL
         gmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686850227; x=1689442227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DBFAQ+OspbXgxiU1uwcjpJ+KgjxBMeHaD8ugzzQiLeU=;
        b=Va60+u9PcXF82K9oweIK9Cvy/2OwPGaQ6+sdXWNQIZAu/JPrbrbNHJ/Zlw43XLsScv
         ARYloBaIEERQg0DKK4t+jrgQ8v2s/TOUuSOgxigP0eIG62Hx+U5CxjaWd84310cEY37G
         gRBXxz2Hx0Pfjick++ZRHdxzk6NE1QrSswHynV/jUTtnuT6jhrqV79qul/UcNbweJPbK
         CaeA1rL0YwTj2rNm/qfm1if1isj6JxKJwP5nLCyu73Zy1QoKqmLxs+GmXc5EO4w6bqBS
         or3mkvWCawsyxucyWEMRk17ZQpexCGHIATYpnT1+Sf6OABH1EUoParXV3K3bZ4RCbq/b
         NbVA==
X-Gm-Message-State: AC+VfDzueladn6dUm2jD4f6xJmRCZ/m6JWszUEwbXvAAb4lGbLMe965+
	jMEuQGS+0ms1gqOPBdgKnRGPzzP7MBL7aPeJ3qI=
X-Google-Smtp-Source: ACHHUZ43pEX4UxqrYbGcs9QMb5obU3lfpTRVrSjmZvwNSem2mYI53z+kAnG4gGLHZnRBTB+m7jNmjoyPuJiodrPSifg=
X-Received: by 2002:a05:6870:4515:b0:180:b716:9825 with SMTP id
 e21-20020a056870451500b00180b7169825mr14924552oao.57.1686850227681; Thu, 15
 Jun 2023 10:30:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230615-amdgpu-wunused-const-variable-wo-debugfs-v1-0-06efd224aebb@kernel.org>
 <20230615-amdgpu-wunused-const-variable-wo-debugfs-v1-2-06efd224aebb@kernel.org>
In-Reply-To: <20230615-amdgpu-wunused-const-variable-wo-debugfs-v1-2-06efd224aebb@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Thu, 15 Jun 2023 13:30:16 -0400
Message-ID: <CADnq5_OWLXzuZvro4g7bDngcO4xjesNr1H=pwDypLKNY-_7PPg@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/amdgpu: Move clocks closer to its only usage in amdgpu_parse_cg_state()
To: Nathan Chancellor <nathan@kernel.org>
Cc: alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com, 
	dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied the series.  Thanks!

Alex

On Thu, Jun 15, 2023 at 1:06=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> After commit a25a9dae2067 ("drm/amd/amdgpu: enable W=3D1 for amdgpu"),
> there is an instance of -Wunused-const-variable when CONFIG_DEBUG_FS is
> disabled:
>
>   drivers/gpu/drm/amd/amdgpu/../pm/amdgpu_pm.c:38:34: error: unused varia=
ble 'clocks' [-Werror,-Wunused-const-variable]
>      38 | static const struct cg_flag_name clocks[] =3D {
>         |                                  ^
>   1 error generated.
>
> clocks is only used when CONFIG_DEBUG_FS is set, so move the definition
> into the CONFIG_DEBUG_FS block right above its only usage to clear up
> the warning.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/amd/pm/amdgpu_pm.c | 76 +++++++++++++++++++-------------=
------
>  1 file changed, 38 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/=
amdgpu_pm.c
> index a57952b93e73..386ccf11e657 100644
> --- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
> +++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
> @@ -35,44 +35,6 @@
>  #include <linux/pm_runtime.h>
>  #include <asm/processor.h>
>
> -static const struct cg_flag_name clocks[] =3D {
> -       {AMD_CG_SUPPORT_GFX_FGCG, "Graphics Fine Grain Clock Gating"},
> -       {AMD_CG_SUPPORT_GFX_MGCG, "Graphics Medium Grain Clock Gating"},
> -       {AMD_CG_SUPPORT_GFX_MGLS, "Graphics Medium Grain memory Light Sle=
ep"},
> -       {AMD_CG_SUPPORT_GFX_CGCG, "Graphics Coarse Grain Clock Gating"},
> -       {AMD_CG_SUPPORT_GFX_CGLS, "Graphics Coarse Grain memory Light Sle=
ep"},
> -       {AMD_CG_SUPPORT_GFX_CGTS, "Graphics Coarse Grain Tree Shader Cloc=
k Gating"},
> -       {AMD_CG_SUPPORT_GFX_CGTS_LS, "Graphics Coarse Grain Tree Shader L=
ight Sleep"},
> -       {AMD_CG_SUPPORT_GFX_CP_LS, "Graphics Command Processor Light Slee=
p"},
> -       {AMD_CG_SUPPORT_GFX_RLC_LS, "Graphics Run List Controller Light S=
leep"},
> -       {AMD_CG_SUPPORT_GFX_3D_CGCG, "Graphics 3D Coarse Grain Clock Gati=
ng"},
> -       {AMD_CG_SUPPORT_GFX_3D_CGLS, "Graphics 3D Coarse Grain memory Lig=
ht Sleep"},
> -       {AMD_CG_SUPPORT_MC_LS, "Memory Controller Light Sleep"},
> -       {AMD_CG_SUPPORT_MC_MGCG, "Memory Controller Medium Grain Clock Ga=
ting"},
> -       {AMD_CG_SUPPORT_SDMA_LS, "System Direct Memory Access Light Sleep=
"},
> -       {AMD_CG_SUPPORT_SDMA_MGCG, "System Direct Memory Access Medium Gr=
ain Clock Gating"},
> -       {AMD_CG_SUPPORT_BIF_MGCG, "Bus Interface Medium Grain Clock Gatin=
g"},
> -       {AMD_CG_SUPPORT_BIF_LS, "Bus Interface Light Sleep"},
> -       {AMD_CG_SUPPORT_UVD_MGCG, "Unified Video Decoder Medium Grain Clo=
ck Gating"},
> -       {AMD_CG_SUPPORT_VCE_MGCG, "Video Compression Engine Medium Grain =
Clock Gating"},
> -       {AMD_CG_SUPPORT_HDP_LS, "Host Data Path Light Sleep"},
> -       {AMD_CG_SUPPORT_HDP_MGCG, "Host Data Path Medium Grain Clock Gati=
ng"},
> -       {AMD_CG_SUPPORT_DRM_MGCG, "Digital Right Management Medium Grain =
Clock Gating"},
> -       {AMD_CG_SUPPORT_DRM_LS, "Digital Right Management Light Sleep"},
> -       {AMD_CG_SUPPORT_ROM_MGCG, "Rom Medium Grain Clock Gating"},
> -       {AMD_CG_SUPPORT_DF_MGCG, "Data Fabric Medium Grain Clock Gating"}=
,
> -       {AMD_CG_SUPPORT_VCN_MGCG, "VCN Medium Grain Clock Gating"},
> -       {AMD_CG_SUPPORT_HDP_DS, "Host Data Path Deep Sleep"},
> -       {AMD_CG_SUPPORT_HDP_SD, "Host Data Path Shutdown"},
> -       {AMD_CG_SUPPORT_IH_CG, "Interrupt Handler Clock Gating"},
> -       {AMD_CG_SUPPORT_JPEG_MGCG, "JPEG Medium Grain Clock Gating"},
> -       {AMD_CG_SUPPORT_REPEATER_FGCG, "Repeater Fine Grain Clock Gating"=
},
> -       {AMD_CG_SUPPORT_GFX_PERF_CLK, "Perfmon Clock Gating"},
> -       {AMD_CG_SUPPORT_ATHUB_MGCG, "Address Translation Hub Medium Grain=
 Clock Gating"},
> -       {AMD_CG_SUPPORT_ATHUB_LS, "Address Translation Hub Light Sleep"},
> -       {0, NULL},
> -};
> -
>  static const struct hwmon_temp_label {
>         enum PP_HWMON_TEMP channel;
>         const char *label;
> @@ -3684,6 +3646,44 @@ static int amdgpu_debugfs_pm_info_pp(struct seq_fi=
le *m, struct amdgpu_device *a
>         return 0;
>  }
>
> +static const struct cg_flag_name clocks[] =3D {
> +       {AMD_CG_SUPPORT_GFX_FGCG, "Graphics Fine Grain Clock Gating"},
> +       {AMD_CG_SUPPORT_GFX_MGCG, "Graphics Medium Grain Clock Gating"},
> +       {AMD_CG_SUPPORT_GFX_MGLS, "Graphics Medium Grain memory Light Sle=
ep"},
> +       {AMD_CG_SUPPORT_GFX_CGCG, "Graphics Coarse Grain Clock Gating"},
> +       {AMD_CG_SUPPORT_GFX_CGLS, "Graphics Coarse Grain memory Light Sle=
ep"},
> +       {AMD_CG_SUPPORT_GFX_CGTS, "Graphics Coarse Grain Tree Shader Cloc=
k Gating"},
> +       {AMD_CG_SUPPORT_GFX_CGTS_LS, "Graphics Coarse Grain Tree Shader L=
ight Sleep"},
> +       {AMD_CG_SUPPORT_GFX_CP_LS, "Graphics Command Processor Light Slee=
p"},
> +       {AMD_CG_SUPPORT_GFX_RLC_LS, "Graphics Run List Controller Light S=
leep"},
> +       {AMD_CG_SUPPORT_GFX_3D_CGCG, "Graphics 3D Coarse Grain Clock Gati=
ng"},
> +       {AMD_CG_SUPPORT_GFX_3D_CGLS, "Graphics 3D Coarse Grain memory Lig=
ht Sleep"},
> +       {AMD_CG_SUPPORT_MC_LS, "Memory Controller Light Sleep"},
> +       {AMD_CG_SUPPORT_MC_MGCG, "Memory Controller Medium Grain Clock Ga=
ting"},
> +       {AMD_CG_SUPPORT_SDMA_LS, "System Direct Memory Access Light Sleep=
"},
> +       {AMD_CG_SUPPORT_SDMA_MGCG, "System Direct Memory Access Medium Gr=
ain Clock Gating"},
> +       {AMD_CG_SUPPORT_BIF_MGCG, "Bus Interface Medium Grain Clock Gatin=
g"},
> +       {AMD_CG_SUPPORT_BIF_LS, "Bus Interface Light Sleep"},
> +       {AMD_CG_SUPPORT_UVD_MGCG, "Unified Video Decoder Medium Grain Clo=
ck Gating"},
> +       {AMD_CG_SUPPORT_VCE_MGCG, "Video Compression Engine Medium Grain =
Clock Gating"},
> +       {AMD_CG_SUPPORT_HDP_LS, "Host Data Path Light Sleep"},
> +       {AMD_CG_SUPPORT_HDP_MGCG, "Host Data Path Medium Grain Clock Gati=
ng"},
> +       {AMD_CG_SUPPORT_DRM_MGCG, "Digital Right Management Medium Grain =
Clock Gating"},
> +       {AMD_CG_SUPPORT_DRM_LS, "Digital Right Management Light Sleep"},
> +       {AMD_CG_SUPPORT_ROM_MGCG, "Rom Medium Grain Clock Gating"},
> +       {AMD_CG_SUPPORT_DF_MGCG, "Data Fabric Medium Grain Clock Gating"}=
,
> +       {AMD_CG_SUPPORT_VCN_MGCG, "VCN Medium Grain Clock Gating"},
> +       {AMD_CG_SUPPORT_HDP_DS, "Host Data Path Deep Sleep"},
> +       {AMD_CG_SUPPORT_HDP_SD, "Host Data Path Shutdown"},
> +       {AMD_CG_SUPPORT_IH_CG, "Interrupt Handler Clock Gating"},
> +       {AMD_CG_SUPPORT_JPEG_MGCG, "JPEG Medium Grain Clock Gating"},
> +       {AMD_CG_SUPPORT_REPEATER_FGCG, "Repeater Fine Grain Clock Gating"=
},
> +       {AMD_CG_SUPPORT_GFX_PERF_CLK, "Perfmon Clock Gating"},
> +       {AMD_CG_SUPPORT_ATHUB_MGCG, "Address Translation Hub Medium Grain=
 Clock Gating"},
> +       {AMD_CG_SUPPORT_ATHUB_LS, "Address Translation Hub Light Sleep"},
> +       {0, NULL},
> +};
> +
>  static void amdgpu_parse_cg_state(struct seq_file *m, u64 flags)
>  {
>         int i;
>
> --
> 2.41.0
>
