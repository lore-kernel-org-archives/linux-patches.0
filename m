Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D5F26ACE
	for <patches@lists.linux.dev>; Thu, 18 Apr 2024 04:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713415242; cv=none; b=kM2UKZbLs4FVMyjf2/cdO7n6hkRSLgKcBrP/DeDgUVDzxBsguBxfzMU61Xt7BSHo2KEwnq4k6yL7sIFWqmmCG4+64gdJhfR4aHyST8pJoWhFSJN9GpGDBQRSDUinwkm4GWAwCAeIh/94f/avy3JBkTG1+3+ja5srZMeZRIANHwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713415242; c=relaxed/simple;
	bh=43SrLHPDyEnTxeKH3QY9A1+rxQERNvMpqMrl2h1AVJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TBVlryYKFwZKU/NjviEc84Sql0gpbZo2ehichjti1Sv7dbEFDFboSoFE9lQbkcMUjX3b8TSB9U1F1b69ODKikIvDaRHdoX34L40pVpRWp97B8D1FRwaS5zl9oOvjUfkYL1ixhHPYukpyBZwjUgRqN6grDhEKZplmdD1NPp/ixdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eCB+8CwF; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eCB+8CwF"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4348110e888so135281cf.1
        for <patches@lists.linux.dev>; Wed, 17 Apr 2024 21:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713415240; x=1714020040; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fxNQKRZxbyXhvsNg0KSP+acNzdGAI9loSPrVKhe4OQ=;
        b=eCB+8CwFapxjdecL3Pco+XyO2NdrmWQ3HmgHi+sYGNtGNE8lj+VxxKpKiCT6k8edS5
         Hemp5JrGXuMbLHaeGkoN5AOUdt0JeX3AMCbAWwvcs1jpX2fVh3Y+8XyTjj2zE4IW3uWf
         rzsrRah5NQJ4dSDytpZiTMadBrJf7YCyjVKj80fA3nNCQAC+a9juW+WxSbPuYPuSW+id
         vhGT4Qmq3QQY+GBTmPOf8IpUdw7yafY0Lr4QT9yVtLgqZ4Jx9+lM3CKFDfOL24bVUD6y
         XT3PlkjgPCLJxyvrZu0wQYL1IOfI++9uXyxO69nBXopBbzciCmggiZhqF9BkRxoUAMrN
         Hz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713415240; x=1714020040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fxNQKRZxbyXhvsNg0KSP+acNzdGAI9loSPrVKhe4OQ=;
        b=jQNitnfSptkz4WuIrgwFv2ZOYp7sYkKUvKnUdrIToXUm3c1S4SPkDxKN4mb7Zoh/P9
         nm4yiFQunD6AaRN6xyK2XU1u151F3MkKL0Zo4uEsjQc8kogFyQPH++L/knoi4uOtxbL7
         EYHwGHx5RtLKdgwVUetnx5DLDOcP+kes4Y17VMdTyN8ZnHwHWm0sPTSWokbzjVTMQS48
         SHP4zXw66RweJQhlCiTnIkoDa2OOP+eOlLg2PY14YnP0cL+n4kUIPxaNFS6j5Zd+08qG
         aFLCOPefbK32DCpnd0AMJOZb5rR757HHaDOpvAQGBUY1gXnUenbKm/R5ig6NJey2JO4a
         JV5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0cs85QSsH69gQcr1nfA7QfXH3dosDtsh4K0xKk0Bw0rHk/ROWlNj+OjgEpVt2abpJT/320FhWOD2P0tzl3r4YpUgU+00Sbw==
X-Gm-Message-State: AOJu0Yzh5VB+x6J2VfqGfBfvKg480eel64Ui14KREZjRXQK/ZwblEi9p
	baohxKCSyHTyVkj1kA/VHySYFDeYgH3sDw+BQqV0TsselB77hzExNR9yvnXgzkrG0O9z4SrpY6a
	XVSpYot+O9PXS4F+9Hre9ZclLqZJSyv+hlYn2
X-Google-Smtp-Source: AGHT+IGLs9JtW2ECZrL83YhlZl02Ky2Vuet7LX5DjB+kwwvhGwFcY7Zbljl2STvSsRFRnSfX0H4k9fwPv/Qn/lPjNf0=
X-Received: by 2002:ac8:7dcc:0:b0:436:6218:c90e with SMTP id
 c12-20020ac87dcc000000b004366218c90emr109485qte.13.1713415239344; Wed, 17 Apr
 2024 21:40:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com> <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Thu, 18 Apr 2024 12:40:03 +0800
Message-ID: <CAKHBV24s1j_AeAEHxYnGdMAERs21Z7iBMwG=ihaZmgNKsrA4SQ@mail.gmail.com>
Subject: Re: [PATCH v7 7/9] iommu/arm-smmu-v3: Move the CD generation for SVA
 into a function
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>, 
	Moritz Fischer <moritzf@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 3:28=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> Pull all the calculations for building the CD table entry for a mmu_struc=
t
> into arm_smmu_make_sva_cd().
>
> Call it in the two places installing the SVA CD table entry.
>
> Open code the last caller of arm_smmu_update_ctx_desc_devices() and remov=
e
> the function.
>
> Remove arm_smmu_write_ctx_desc() since all callers are gone. Add the
> locking assertions to arm_smmu_alloc_cd_ptr() since
> arm_smmu_update_ctx_desc_devices() was the last problematic caller.
>
> Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
> the same value.
>
> The behavior of quiet_cd changes slightly, the old implementation edited
> the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
> entry. This version generates a full CD entry with a 0 TTB0 and relies on
> arm_smmu_write_cd_entry() to install it hitlessly.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 156 +++++++++++-------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 103 +-----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   7 +-
>  3 files changed, 108 insertions(+), 158 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 7cf286f7a009fb..80a7d559ef2d3f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -34,25 +34,6 @@ struct arm_smmu_bond {
>
>  static DEFINE_MUTEX(sva_lock);
>
> -/*
> - * Write the CD to the CD tables for all masters that this domain is att=
ached
> - * to. Note that this is only used to update existing CD entries in the =
target
> - * CD table, for which it's assumed that arm_smmu_write_ctx_desc can't f=
ail.
> - */
> -static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smm=
u_domain,
> -                                          int ssid,
> -                                          struct arm_smmu_ctx_desc *cd)
> -{
> -       struct arm_smmu_master *master;
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -       list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> -               arm_smmu_write_ctx_desc(master, ssid, cd);
> -       }
> -       spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> -}
> -
>  static void
>  arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
>  {
> @@ -128,11 +109,86 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
>         return NULL;
>  }
>
> +static u64 page_size_to_cd(void)
> +{
> +       static_assert(PAGE_SIZE =3D=3D SZ_4K || PAGE_SIZE =3D=3D SZ_16K |=
|
> +                     PAGE_SIZE =3D=3D SZ_64K);
> +       if (PAGE_SIZE =3D=3D SZ_64K)
> +               return ARM_LPAE_TCR_TG0_64K;
> +       if (PAGE_SIZE =3D=3D SZ_16K)
> +               return ARM_LPAE_TCR_TG0_16K;
> +       return ARM_LPAE_TCR_TG0_4K;
> +}
> +
> +static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> +                                struct arm_smmu_master *master,
> +                                struct mm_struct *mm, u16 asid)
> +{
> +       u64 par;
> +
> +       memset(target, 0, sizeof(*target));
> +
> +       par =3D cpuid_feature_extract_unsigned_field(
> +               read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
> +               ID_AA64MMFR0_EL1_PARANGE_SHIFT);
> +
> +       target->data[0] =3D cpu_to_le64(
> +               CTXDESC_CD_0_TCR_EPD1 |
> +#ifdef __BIG_ENDIAN
> +               CTXDESC_CD_0_ENDI |
> +#endif
> +               CTXDESC_CD_0_V |
> +               FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par) |
> +               CTXDESC_CD_0_AA64 |
> +               (master->stall_enabled ? CTXDESC_CD_0_S : 0) |
> +               CTXDESC_CD_0_R |
> +               CTXDESC_CD_0_A |
> +               CTXDESC_CD_0_ASET |
> +               FIELD_PREP(CTXDESC_CD_0_ASID, asid));
> +
> +       /*
> +        * If no MM is passed then this creates a SVA entry that faults
> +        * everything. arm_smmu_write_cd_entry() can hitlessly go between=
 these
> +        * two entries types since TTB0 is ignored by HW when EPD0 is set=
.
> +        */
> +       if (mm) {
> +               target->data[0] |=3D cpu_to_le64(
> +                       FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ,
> +                                  64ULL - vabits_actual) |
> +                       FIELD_PREP(CTXDESC_CD_0_TCR_TG0, page_size_to_cd(=
)) |
> +                       FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0,
> +                                  ARM_LPAE_TCR_RGN_WBWA) |
> +                       FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0,
> +                                  ARM_LPAE_TCR_RGN_WBWA) |
> +                       FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_=
IS));
> +
> +               target->data[1] =3D cpu_to_le64(virt_to_phys(mm->pgd) &
> +                                             CTXDESC_CD_1_TTB0_MASK);
> +       } else {
> +               target->data[0] |=3D cpu_to_le64(CTXDESC_CD_0_TCR_EPD0);
> +
> +               /*
> +                * Disable stall and immediately generate an abort if sta=
ll
> +                * disable is permitted. This speeds up cleanup for an un=
clean
> +                * exit if the device is still doing a lot of DMA.
> +                */
> +               if (master->stall_enabled &&
> +                   !(master->smmu->features & ARM_SMMU_FEAT_STALL_FORCE)=
)
> +                       target->data[0] &=3D
> +                               cpu_to_le64(~(CTXDESC_CD_0_S | CTXDESC_CD=
_0_R));


This condition looks slightly different from the original one. Does
this imply a change in behaviour that should be noted in the commit
message?

>
> +       }
> +
> +       /*
> +        * MAIR value is pretty much constant and global, so we can just =
get it
> +        * from the current CPU register
> +        */
> +       target->data[3] =3D cpu_to_le64(read_sysreg(mair_el1));
> +}
> +
>  static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_stru=
ct *mm)
>  {
>         u16 asid;
>         int err =3D 0;
> -       u64 tcr, par, reg;
>         struct arm_smmu_ctx_desc *cd;
>         struct arm_smmu_ctx_desc *ret =3D NULL;
>
> @@ -166,39 +222,6 @@ static struct arm_smmu_ctx_desc *arm_smmu_alloc_shar=
ed_cd(struct mm_struct *mm)
>         if (err)
>                 goto out_free_asid;
>
> -       tcr =3D FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, 64ULL - vabits_actual) =
|
> -             FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, ARM_LPAE_TCR_RGN_WBWA) |
> -             FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, ARM_LPAE_TCR_RGN_WBWA) |
> -             FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS) |
> -             CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
> -
> -       switch (PAGE_SIZE) {
> -       case SZ_4K:
> -               tcr |=3D FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG=
0_4K);
> -               break;
> -       case SZ_16K:
> -               tcr |=3D FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG=
0_16K);
> -               break;
> -       case SZ_64K:
> -               tcr |=3D FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG=
0_64K);
> -               break;
> -       default:
> -               WARN_ON(1);
> -               err =3D -EINVAL;
> -               goto out_free_asid;
> -       }
> -
> -       reg =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> -       par =3D cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR0_EL=
1_PARANGE_SHIFT);
> -       tcr |=3D FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par);
> -
> -       cd->ttbr =3D virt_to_phys(mm->pgd);
> -       cd->tcr =3D tcr;
> -       /*
> -        * MAIR value is pretty much constant and global, so we can just =
get it
> -        * from the current CPU register
> -        */
> -       cd->mair =3D read_sysreg(mair_el1);
>         cd->asid =3D asid;
>         cd->mm =3D mm;
>
> @@ -276,6 +299,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *=
mn, struct mm_struct *mm)
>  {
>         struct arm_smmu_mmu_notifier *smmu_mn =3D mn_to_smmu(mn);
>         struct arm_smmu_domain *smmu_domain =3D smmu_mn->domain;
> +       struct arm_smmu_master *master;
> +       unsigned long flags;
>
>         mutex_lock(&sva_lock);
>         if (smmu_mn->cleared) {
> @@ -287,8 +312,19 @@ static void arm_smmu_mm_release(struct mmu_notifier =
*mn, struct mm_struct *mm)
>          * DMA may still be running. Keep the cd valid to avoid C_BAD_CD =
events,
>          * but disable translation.
>          */
> -       arm_smmu_update_ctx_desc_devices(smmu_domain, mm_get_enqcmd_pasid=
(mm),
> -                                        &quiet_cd);
> +       spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> +       list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> +               struct arm_smmu_cd target;
> +               struct arm_smmu_cd *cdptr;
> +
> +               cdptr =3D arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid=
(mm));
> +               if (WARN_ON(!cdptr))
> +                       continue;
> +               arm_smmu_make_sva_cd(&target, master, NULL, smmu_mn->cd->=
asid);
> +               arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), =
cdptr,
> +                                       &target);
> +       }
> +       spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>
>         arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
>         arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, =
0);
> @@ -383,6 +419,8 @@ static int __arm_smmu_sva_bind(struct device *dev, io=
asid_t pasid,
>                                struct mm_struct *mm)
>  {
>         int ret;
> +       struct arm_smmu_cd target;
> +       struct arm_smmu_cd *cdptr;
>         struct arm_smmu_bond *bond;
>         struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
>         struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
> @@ -409,9 +447,13 @@ static int __arm_smmu_sva_bind(struct device *dev, i=
oasid_t pasid,
>                 goto err_free_bond;
>         }
>
> -       ret =3D arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd)=
;
> -       if (ret)
> +       cdptr =3D arm_smmu_alloc_cd_ptr(master, mm_get_enqcmd_pasid(mm));
> +       if (!cdptr) {
> +               ret =3D -ENOMEM;
>                 goto err_put_notifier;
> +       }
> +       arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid=
);
> +       arm_smmu_write_cd_entry(master, pasid, cdptr, &target);
>
>         list_add(&bond->list, &master->bonds);
>         return 0;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 0aacd95f34a479..d01b632197c0b7 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -84,12 +84,6 @@ struct arm_smmu_option_prop {
>  DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
>  DEFINE_MUTEX(arm_smmu_asid_lock);
>
> -/*
> - * Special value used by SVA when a process dies, to quiesce a CD withou=
t
> - * disabling it.
> - */
> -struct arm_smmu_ctx_desc quiet_cd =3D { 0 };
> -
>  static struct arm_smmu_option_prop arm_smmu_options[] =3D {
>         { ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
>         { ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regsp=
ace"},
> @@ -1201,7 +1195,7 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
>         u64 val =3D (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
>                   CTXDESC_L1_DESC_V;
>
> -       /* See comment in arm_smmu_write_ctx_desc() */
> +       /* The HW has 64 bit atomicity with stores to the L2 CD table */
>         WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>
> @@ -1224,12 +1218,15 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct ar=
m_smmu_master *master,
>         return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
>  }
>
> -static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master =
*master,
> -                                                u32 ssid)
> +struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master=
,
> +                                         u32 ssid)
>  {
>         struct arm_smmu_ctx_desc_cfg *cd_table =3D &master->cd_table;
>         struct arm_smmu_device *smmu =3D master->smmu;
>
> +       might_sleep();
> +       iommu_group_mutex_assert(master->dev);
> +
>         if (!cd_table->cdtab) {
>                 if (arm_smmu_alloc_cd_tables(master))
>                         return NULL;
> @@ -1345,91 +1342,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *mas=
ter, ioasid_t ssid)
>         arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
>  }
>
> -static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
> -{
> -       struct arm_smmu_cd used =3D {};
> -       int i;
> -
> -       arm_smmu_get_cd_used(target->data, used.data);
> -       for (i =3D 0; i !=3D ARRAY_SIZE(target->data); i++)
> -               target->data[i] &=3D used.data[i];
> -}
> -
> -int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
> -                           struct arm_smmu_ctx_desc *cd)
> -{
> -       /*
> -        * This function handles the following cases:
> -        *
> -        * (1) Install primary CD, for normal DMA traffic (SSID =3D IOMMU=
_NO_PASID =3D 0).
> -        * (2) Install a secondary CD, for SID+SSID traffic.
> -        * (3) Update ASID of a CD. Atomically write the first 64 bits of=
 the
> -        *     CD, then invalidate the old entry and mappings.
> -        * (4) Quiesce the context without clearing the valid bit. Disabl=
e
> -        *     translation, and ignore any translation fault.
> -        * (5) Remove a secondary CD.
> -        */
> -       u64 val;
> -       bool cd_live;
> -       struct arm_smmu_cd target;
> -       struct arm_smmu_cd *cdptr =3D &target;
> -       struct arm_smmu_cd *cd_table_entry;
> -       struct arm_smmu_ctx_desc_cfg *cd_table =3D &master->cd_table;
> -       struct arm_smmu_device *smmu =3D master->smmu;
> -
> -       if (WARN_ON(ssid >=3D (1 << cd_table->s1cdmax)))
> -               return -E2BIG;
> -
> -       cd_table_entry =3D arm_smmu_alloc_cd_ptr(master, ssid);
> -       if (!cd_table_entry)
> -               return -ENOMEM;
> -
> -       target =3D *cd_table_entry;
> -       val =3D le64_to_cpu(cdptr->data[0]);
> -       cd_live =3D !!(val & CTXDESC_CD_0_V);
> -
> -       if (!cd) { /* (5) */
> -               val =3D 0;
> -       } else if (cd =3D=3D &quiet_cd) { /* (4) */
> -               if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
> -                       val &=3D ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
> -               val |=3D CTXDESC_CD_0_TCR_EPD0;
> -       } else if (cd_live) { /* (3) */
> -               val &=3D ~CTXDESC_CD_0_ASID;
> -               val |=3D FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);
> -               /*
> -                * Until CD+TLB invalidation, both ASIDs may be used for =
tagging
> -                * this substream's traffic
> -                */
> -       } else { /* (1) and (2) */
> -               cdptr->data[1] =3D cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TT=
B0_MASK);
> -               cdptr->data[2] =3D 0;
> -               cdptr->data[3] =3D cpu_to_le64(cd->mair);
> -
> -               val =3D cd->tcr |
> -#ifdef __BIG_ENDIAN
> -                       CTXDESC_CD_0_ENDI |
> -#endif
> -                       CTXDESC_CD_0_R | CTXDESC_CD_0_A |
> -                       (cd->mm ? 0 : CTXDESC_CD_0_ASET) |
> -                       CTXDESC_CD_0_AA64 |
> -                       FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid) |
> -                       CTXDESC_CD_0_V;
> -
> -               if (cd_table->stall_enabled)
> -                       val |=3D CTXDESC_CD_0_S;
> -       }
> -       cdptr->data[0] =3D cpu_to_le64(val);
> -       /*
> -        * Since the above is updating the CD entry based on the current =
value
> -        * without zeroing unused bits it needs fixing before being passe=
d to
> -        * the programming logic.
> -        */
> -       arm_smmu_clean_cd_entry(&target);
> -       arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
> -       return 0;
> -}
> -
>  static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
>  {
>         int ret;
> @@ -1438,7 +1350,6 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu=
_master *master)
>         struct arm_smmu_device *smmu =3D master->smmu;
>         struct arm_smmu_ctx_desc_cfg *cd_table =3D &master->cd_table;
>
> -       cd_table->stall_enabled =3D master->stall_enabled;
>         cd_table->s1cdmax =3D master->ssid_bits;
>         max_contexts =3D 1 << cd_table->s1cdmax;
>
> @@ -1536,7 +1447,7 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct a=
rm_smmu_strtab_l1_desc *desc)
>         val |=3D FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
>         val |=3D desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
>
> -       /* See comment in arm_smmu_write_ctx_desc() */
> +       /* The HW has 64 bit atomicity with stores to the L2 STE table */
>         WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index 99fd6f24caa818..8098bf8836a180 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -609,8 +609,6 @@ struct arm_smmu_ctx_desc_cfg {
>         u8                              s1fmt;
>         /* log2 of the maximum number of CDs supported by this table */
>         u8                              s1cdmax;
> -       /* Whether CD entries in this table have the stall bit set. */
> -       u8                              stall_enabled:1;
>  };
>
>  struct arm_smmu_s2_cfg {
> @@ -749,11 +747,12 @@ static inline struct arm_smmu_domain *to_smmu_domai=
n(struct iommu_domain *dom)
>
>  extern struct xarray arm_smmu_asid_xa;
>  extern struct mutex arm_smmu_asid_lock;
> -extern struct arm_smmu_ctx_desc quiet_cd;
>
>  void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
>  struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
>                                         u32 ssid);
> +struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master=
,
> +                                         u32 ssid);
>  void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
>                          struct arm_smmu_master *master,
>                          struct arm_smmu_domain *smmu_domain);
> @@ -761,8 +760,6 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *=
master, int ssid,
>                              struct arm_smmu_cd *cdptr,
>                              const struct arm_smmu_cd *target);
>
> -int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssi=
d,
> -                           struct arm_smmu_ctx_desc *cd);
>  void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
>  void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int as=
id,
>                                  size_t granule, bool leaf,
> --
> 2.43.2
>
