Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5666519D
	for <patches@lists.linux.dev>; Tue, 19 Mar 2024 15:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710861007; cv=none; b=laoYmTAsHa1JjyVX/iOLaJIZRGdANwXRNAZPKmZL3yOvyjAxLGCOiIi8BUnlqJl2T/LZd3DhVR50XFGHuS3tvl8Mb9X2fGsOk+uwo3Vii6AhsWlDE24+oLh7OE3Z/Qyo2lrKhbilFC+AoyDw8kL7hH33j5eWeEnostDfSdr4dLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710861007; c=relaxed/simple;
	bh=wtQ0qM6S23AEiNjS00UjSpHz41jnOmFYuaTxVXh0ClM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TuCXLkWFBn8UnRFoW2bs5VteV+RMcPrMLzUhVAilQQ0G4FjpmduixGUnsCvJ9iqnghznJ816jTYpU6V8L69jnnXyAwBD1tLP4S9t9vzmqzC0+wwBU1rbh5I4vz64jw+rrsU+1m13dhdpkp9R//xcEGdfqWB3yk9Lpctp3Kpjxfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aOIAlmY4; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aOIAlmY4"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-430e1e06e75so404581cf.0
        for <patches@lists.linux.dev>; Tue, 19 Mar 2024 08:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710861004; x=1711465804; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3nDS1TFkM/P04Hm28o9nB5crZnsavj1XrT2oYhN9xU=;
        b=aOIAlmY4wrxHR1K4uoxnTZg8IxPypacan+Zyd8vahaKbDzsDowHbkLgNe3trEaPf25
         lZOM7hnGtTQ3tLjmv9UYOjqZkf9ziOniulDY4fuS+42rqalxIhKd0UOFf8ZxCXuNuEz8
         X+cNYb3NO/zT7wf+8ee4u+1gvL5/ThjTgfySwwEz/pkYSdku6DxuGJowl1JowEPFnCK8
         IzPN+7p6NrT3RKNWpU0vP0cvgj8AlCdTSr6exwl/SMLbIb/qjNkgdb+rYZdfrRxAUrJJ
         /MPnh64lIkG831QYuwsAgJ+FnyQJGRP9xTPh8btTDRIHGU64MLbGHTrnFKWLiQbV+Orm
         Uoag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710861004; x=1711465804;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e3nDS1TFkM/P04Hm28o9nB5crZnsavj1XrT2oYhN9xU=;
        b=crh1eqbQ3oFga4Nl5zNg+xK/jT8PTyLhG29MBd/2hDFDUNU8ooCGG0CPBR9BjWMyJ6
         pu4VBlWQt6ndEVBJyc1y86Zs8UUN1xTuYKOOK21xBBS+uR33XE+EpYJbuRJid8slMjd8
         sl215WdfSoKN0kMNLt0U/B2toCop1124xyrt7RAw2FqbYrh/FaOiTg1pgZya9t8gId5d
         4G5b/o7GLVLYqxlIFM50jRcV8nUGHjp6F6nSv5jsLptpDcgsV7TiQmRoKv36IOV6BtqC
         gEL3xJobWwjnISLlbr03OPTg1kWoGQAHr2vT5+qRbo0tUEmZjZ662Bnhaz2levo5CASF
         oevg==
X-Forwarded-Encrypted: i=1; AJvYcCWqBfZtq4nrwOyzwbbGnd+Bbw/Ov76u+S6/cTLoaaMD17icaVtPfNevMnkYkDWrjAGr2J9vALnMdKQcQHJZqVJ0asuU797yXg==
X-Gm-Message-State: AOJu0Yy0CGd7YC2GZqI7jBmaPSIUhM5u90Lwk+OSwdYz7sU4FTi677ys
	MGjq7KqmoEsoDBIKqE0elSNlOgSyS6Uiw4ccmHI+t/4gupZiYQVqPDNTann97NTuSPUodjxGlJc
	j8m+3NEI5TFzIM1rXgQ72MelkmlXuBqALqVrn
X-Google-Smtp-Source: AGHT+IE2dIbHwHLF81gLz+1R0LMSOY4rRcLnjiOH5JmdyZNSQpaH0QPkg41TsWlctGcQyZt7uwSK9r58RkbC7mSo5a4=
X-Received: by 2002:a05:622a:2d1:b0:430:ea89:df93 with SMTP id
 a17-20020a05622a02d100b00430ea89df93mr182912qtx.0.1710861003658; Tue, 19 Mar
 2024 08:10:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <20-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <20-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Tue, 19 Mar 2024 23:09:27 +0800
Message-ID: <CAKHBV25UCJsxSGqPQLnOOm8CcUjCjhLakx6MCf52guCTSrwtzA@mail.gmail.com>
Subject: Re: [PATCH v5 20/27] iommu: Add ops->domain_alloc_sva()
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
> Make a new op that receives the device and the mm_struct that the SVA
> domain should be created for. Unlike domain_alloc_paging() the dev
> argument is never NULL here.
>
> This allows drivers to fully initialize the SVA domain and allocate the
> mmu_notifier during allocation. It allows the notifier lifetime to follow
> the lifetime of the iommu_domain.
>
> Since we have only one call site, upgrade the new op to return ERR_PTR
> instead of NULL.
>
> Change SMMUv3 to use the new op.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 11 +++++++----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     |  2 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  6 +++++-
>  drivers/iommu/iommu-sva.c                       |  4 ++--
>  drivers/iommu/iommu.c                           | 12 +++++++++---
>  include/linux/iommu.h                           |  3 +++
>  6 files changed, 27 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index d633316f2e45bc..30b1cf587efffb 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -662,17 +662,20 @@ static const struct iommu_domain_ops arm_smmu_sva_d=
omain_ops =3D {
>         .free                   =3D arm_smmu_sva_domain_free
>  };
>
> -struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned type)
> +struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
> +                                              struct mm_struct *mm)
>  {
> +       struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> +       struct arm_smmu_device *smmu =3D master->smmu;
>         struct arm_smmu_domain *smmu_domain;
>
> -       if (type !=3D IOMMU_DOMAIN_SVA)
> -               return ERR_PTR(-EOPNOTSUPP);
> -
>         smmu_domain =3D arm_smmu_domain_alloc();
>         if (IS_ERR(smmu_domain))
>                 return ERR_CAST(smmu_domain);
> +
> +       smmu_domain->domain.type =3D IOMMU_DOMAIN_SVA;
>         smmu_domain->domain.ops =3D &arm_smmu_sva_domain_ops;
> +       smmu_domain->smmu =3D smmu;
>
>         return &smmu_domain->domain;
>  }
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 6d15fe3a160acf..a255a02a5fc8a9 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3311,8 +3311,8 @@ static struct iommu_ops arm_smmu_ops =3D {
>         .identity_domain        =3D &arm_smmu_identity_domain,
>         .blocked_domain         =3D &arm_smmu_blocked_domain,
>         .capable                =3D arm_smmu_capable,
> -       .domain_alloc           =3D arm_smmu_sva_domain_alloc,
>         .domain_alloc_paging    =3D arm_smmu_domain_alloc_paging,
> +       .domain_alloc_sva       =3D arm_smmu_sva_domain_alloc,
>         .probe_device           =3D arm_smmu_probe_device,
>         .release_device         =3D arm_smmu_release_device,
>         .device_group           =3D arm_smmu_device_group,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index c47e07d695bef2..f62bd2ef36a18d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -793,7 +793,8 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master=
 *master);
>  int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
>  bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
>  void arm_smmu_sva_notifier_synchronize(void);
> -struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned int type);
> +struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
> +                                              struct mm_struct *mm);
>  void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
>                                    struct device *dev, ioasid_t id);
>  #else /* CONFIG_ARM_SMMU_V3_SVA */
> @@ -839,5 +840,8 @@ static inline void arm_smmu_sva_remove_dev_pasid(stru=
ct iommu_domain *domain,
>                                                  ioasid_t id)
>  {
>  }
> +
> +#define arm_smmu_sva_domain_alloc NULL
> +
>  #endif /* CONFIG_ARM_SMMU_V3_SVA */
>  #endif /* _ARM_SMMU_V3_H */
> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
> index 65814cbc840200..aa20ee6a1d8ae7 100644
> --- a/drivers/iommu/iommu-sva.c
> +++ b/drivers/iommu/iommu-sva.c
> @@ -108,8 +108,8 @@ struct iommu_sva *iommu_sva_bind_device(struct device=
 *dev, struct mm_struct *mm
>
>         /* Allocate a new domain and set it on device pasid. */
>         domain =3D iommu_sva_domain_alloc(dev, mm);
> -       if (!domain) {
> -               ret =3D -ENOMEM;
> +       if (IS_ERR(domain)) {
> +               ret =3D PTR_ERR(domain);
>                 goto out_free_handle;
>         }
>
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index d14413916f93a0..f9a2b8363ad941 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3629,9 +3629,15 @@ struct iommu_domain *iommu_sva_domain_alloc(struct=
 device *dev,
>         const struct iommu_ops *ops =3D dev_iommu_ops(dev);
>         struct iommu_domain *domain;
>
> -       domain =3D ops->domain_alloc(IOMMU_DOMAIN_SVA);
> -       if (!domain)
> -               return NULL;
> +       if (ops->domain_alloc_sva) {
> +               domain =3D ops->domain_alloc_sva(dev, mm);
> +               if (IS_ERR(domain))
> +                       return domain;
> +       } else {
> +               domain =3D ops->domain_alloc(IOMMU_DOMAIN_SVA);
> +               if (!domain)
> +                       return ERR_PTR(-ENOMEM);
> +       }
>
>         domain->type =3D IOMMU_DOMAIN_SVA;
>         mmgrab(mm);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 5e27cb3a3be99b..0274044f1fb084 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -419,6 +419,7 @@ static inline int __iommu_copy_struct_from_user_array=
(
>   *                     Upon failure, ERR_PTR must be returned.
>   * @domain_alloc_paging: Allocate an iommu_domain that can be used for
>   *                       UNMANAGED, DMA, and DMA_FQ domain types.
> + * @domain_alloc_sva: Allocate an iommu_domain for Shared Virtual Addres=
sing.
>   * @probe_device: Add device to iommu driver handling
>   * @release_device: Remove device from iommu driver handling
>   * @probe_finalize: Do final setup work after the device is added to an =
IOMMU
> @@ -459,6 +460,8 @@ struct iommu_ops {
>                 struct device *dev, u32 flags, struct iommu_domain *paren=
t,
>                 const struct iommu_user_data *user_data);
>         struct iommu_domain *(*domain_alloc_paging)(struct device *dev);
> +       struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
> +                                                struct mm_struct *mm);
>
>         struct iommu_device *(*probe_device)(struct device *dev);
>         void (*release_device)(struct device *dev);
> --
> 2.43.2
>
Reviewed-by: Michael Shavit <mshavit@google.com>
