Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58FD18041
	for <patches@lists.linux.dev>; Fri, 15 Mar 2024 10:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710497101; cv=none; b=qUy0DPtsOFlcLg/wWbT/SjmkbHckO2GhkqckkcUPUdEIJLtLWVb/JHOYAFr308syEPJz9cFio3c6a6iYvIpK9wzkfM/dG3mduIcFhAsmEFAE+mac0lTeFi6pznS0Da7YGzL3oYmWdDLgUweDrjFXEKsnf5cdsA14fg2D4/8JUQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710497101; c=relaxed/simple;
	bh=3CyYqvHwfz63mAluOxL8F1IVPiWpVkUAfJKVYtmxnnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kMcIupBvfRrrXXIVaErmRyYIqeABEL7bfGqOZj4wjDZlqOTBxgr3QT1BIygXROQQyW7lxhMjnJu4EergXAsIgEibIX1ILEYa4bs9w1QTB4oJf0hKoXm09u4kACC+Icbei00VBkZNuhJmq6kAUxw1Y4yRFEmaL7sirVFhhK9JosA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gsEJJYHl; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gsEJJYHl"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-43095dcbee6so259421cf.0
        for <patches@lists.linux.dev>; Fri, 15 Mar 2024 03:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710497098; x=1711101898; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jlf1/pKtOv7hm1HZwIRuhDCij9c7Kk5YDTMOJzk6hGg=;
        b=gsEJJYHl/0TQVqjf5+T27Aihsvf9MkquCDkJSwDJgBX6gY7Q6goZKtw9wVPwmff2RR
         xIQ0xJ1aZq4/0e1qnxWKFjf9xYadlQErl9WcNTJigLPeqTZmqqH6xPQEYNG1IiHx6H1S
         jgep8IY/WVWbjWAeybLn9oOKPu7IerG7a5OXdWsCHY9mDTckyQjxjKcDqx8QR/pS/b0b
         TBMF1NR60l99jjj3BbkFClFiNKuga8G8tEbFGmtUp175Tmy9+A53KnkknAHe9DMg9PJ5
         k/ZfnRMrLTyU85RJcM5rpByJ0qXBTZruWiutf4LXQB9wMbyLEdTMBo4raiX8wJ2Ng2JY
         NMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710497098; x=1711101898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jlf1/pKtOv7hm1HZwIRuhDCij9c7Kk5YDTMOJzk6hGg=;
        b=s1MRz0h1PfKy2feIOQ5SCkYYPHqrI7MuhUWDiIq8T37+t1DW4FwfDX9Jcwwzt8Tj8t
         uxjQLFR/oeWhahb/ip7ozCP8ZdJdymUIX3PY/RotbM+sp3vXZkxdwYdlLsEUmRuf+JpJ
         3xkDUSd8bbBB4i2yPHcz7nbHdJ7ApOX3bJ7rmGu0zWmMTfOOct1k/3LsGYT1w8/Vl7Ch
         pXckll59uATm8fY2wWaBBeQZ4UeZb2GMWat22ytqfI2tFYam3KKT4uZ4hnN5FSt4ZnDd
         3hNUSkKo7aTw0yFTm+kgqltfWmTqcKyvxSiaMjm9BBWNKWlFrzkMcJhfJ0GyewjKAB7a
         II3g==
X-Forwarded-Encrypted: i=1; AJvYcCUp4DdEAheGLLiB/Fz111Xsjpg7nbvokVxS1WdhgoXlBlEGaKtwcXZln8h5InaoXHkUWkYPspKtks7mpxZqS363fz767VPdyg==
X-Gm-Message-State: AOJu0Yx8u0LOlGy0IkKniUhg0pJa/i1wPaWGPq0pMIJumUcb1wcaTpqc
	/X/2RZqdpGVWgqfPlqiLsMvbL/CwqWqhrLC2BGtzHJaoC5V4wstTHO8Oq/RQZNaxM1u6oisNyb0
	RfwEw+3vkrnCFtNKvAKNt4X+0jDSKQX10O0uQ
X-Google-Smtp-Source: AGHT+IEr1vFgCuOWwo26klb8qScV+6JZDxcaNYhIOTN5JfqoACAoFdiPeC1IbzNeQJHB09f+W8VBtEnv8GP35HjY/QY=
X-Received: by 2002:a05:622a:8c:b0:430:a6bc:bbc0 with SMTP id
 o12-20020a05622a008c00b00430a6bcbbc0mr238774qtw.0.1710497098332; Fri, 15 Mar
 2024 03:04:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <11-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <11-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Fri, 15 Mar 2024 18:04:19 +0800
Message-ID: <CAKHBV26Rr5T-6swERRUyugXqy-=PUEgo9nEga=L4ZYT9hPc32A@mail.gmail.com>
Subject: Re: [PATCH v5 11/27] iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 5, 2024 at 7:44=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> Half the code was living in arm_smmu_domain_finalise_s1(), just move it
> here and take the values directly from the pgtbl_ops instead of storing
> copies.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 47 ++++++++-------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 --
>  2 files changed, 18 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 50d17e3ce0a956..dfdd48cf217c4e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1301,15 +1301,25 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *targ=
et,
>                          struct arm_smmu_domain *smmu_domain)
>  {
>         struct arm_smmu_ctx_desc *cd =3D &smmu_domain->cd;
> +       const struct io_pgtable_cfg *pgtbl_cfg =3D
> +               &io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
> +       typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =3D
> +               &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
>
>         memset(target, 0, sizeof(*target));
>
>         target->data[0] =3D cpu_to_le64(
> -               cd->tcr |
> +               FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
> +               FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
> +               FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
> +               FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
> +               FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
> +               CTXDESC_CD_0_TCR_EPD1 |
>  #ifdef __BIG_ENDIAN
>                 CTXDESC_CD_0_ENDI |
>  #endif
>                 CTXDESC_CD_0_V |
> +               FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |

I guess you're trying to keep these ordered by bit position, in which
case EPD1 should go after ENDI.

>                 CTXDESC_CD_0_AA64 |
>                 (master->stall_enabled ? CTXDESC_CD_0_S : 0) |
>                 CTXDESC_CD_0_R |
> @@ -1317,9 +1327,9 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target=
,
>                 CTXDESC_CD_0_ASET |
>                 FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
>                 );
> -
> -       target->data[1] =3D cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK=
);
> -       target->data[3] =3D cpu_to_le64(cd->mair);
> +       target->data[1] =3D cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.ttbr &
> +                                     CTXDESC_CD_1_TTB0_MASK);
> +       target->data[3] =3D cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.mair);
>  }
>
>  void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
> @@ -2305,13 +2315,11 @@ static void arm_smmu_domain_free(struct iommu_dom=
ain *domain)
>  }
>
>  static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
> -                                      struct arm_smmu_domain *smmu_domai=
n,
> -                                      struct io_pgtable_cfg *pgtbl_cfg)
> +                                      struct arm_smmu_domain *smmu_domai=
n)
>  {
>         int ret;
>         u32 asid;
>         struct arm_smmu_ctx_desc *cd =3D &smmu_domain->cd;
> -       typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =3D &pgtbl_cfg->arm_l=
pae_s1_cfg.tcr;
>
>         refcount_set(&cd->refs, 1);
>
> @@ -2319,31 +2327,13 @@ static int arm_smmu_domain_finalise_s1(struct arm=
_smmu_device *smmu,
>         mutex_lock(&arm_smmu_asid_lock);
>         ret =3D xa_alloc(&arm_smmu_asid_xa, &asid, cd,
>                        XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNE=
L);
> -       if (ret)
> -               goto out_unlock;
> -
>         cd->asid        =3D (u16)asid;
> -       cd->ttbr        =3D pgtbl_cfg->arm_lpae_s1_cfg.ttbr;
> -       cd->tcr         =3D FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
> -                         FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
> -                         FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
> -                         FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
> -                         FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
> -                         FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
> -                         CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
> -       cd->mair        =3D pgtbl_cfg->arm_lpae_s1_cfg.mair;
> -
> -       mutex_unlock(&arm_smmu_asid_lock);
> -       return 0;
> -
> -out_unlock:
>         mutex_unlock(&arm_smmu_asid_lock);
>         return ret;
>  }
>
>  static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
> -                                      struct arm_smmu_domain *smmu_domai=
n,
> -                                      struct io_pgtable_cfg *pgtbl_cfg)
> +                                      struct arm_smmu_domain *smmu_domai=
n)
>  {
>         int vmid;
>         struct arm_smmu_s2_cfg *cfg =3D &smmu_domain->s2_cfg;
> @@ -2367,8 +2357,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu=
_domain *smmu_domain,
>         struct io_pgtable_cfg pgtbl_cfg;
>         struct io_pgtable_ops *pgtbl_ops;
>         int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
> -                                struct arm_smmu_domain *smmu_domain,
> -                                struct io_pgtable_cfg *pgtbl_cfg);
> +                                struct arm_smmu_domain *smmu_domain);
>
>         /* Restrict the stage to what we can actually support */
>         if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
> @@ -2411,7 +2400,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu=
_domain *smmu_domain,
>         smmu_domain->domain.geometry.aperture_end =3D (1UL << pgtbl_cfg.i=
as) - 1;
>         smmu_domain->domain.geometry.force_aperture =3D true;
>
> -       ret =3D finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
> +       ret =3D finalise_stage_fn(smmu, smmu_domain);
>         if (ret < 0) {
>                 free_io_pgtable_ops(pgtbl_ops);
>                 return ret;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index 8eabcccb9420ba..468cd33b80ac35 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -587,9 +587,6 @@ struct arm_smmu_strtab_l1_desc {
>
>  struct arm_smmu_ctx_desc {
>         u16                             asid;
> -       u64                             ttbr;
> -       u64                             tcr;
> -       u64                             mair;
>
>         refcount_t                      refs;
>         struct mm_struct                *mm;
> --
> 2.43.2
>

Apart from the nit,
Reviewed-by: Michael Shavit <mshavit@google.com>
