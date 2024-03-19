Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC848288D
	for <patches@lists.linux.dev>; Tue, 19 Mar 2024 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710865423; cv=none; b=BtAnTu+MFZo2OVcF+oRgYyW/tAl4fy7FMZmNrbCcs/ly0X6WThy5PqXKhUDTOiNNa2QW8RCAvRTn2Z6hg5j/TtcrUlvkGMgsP4jK4VJJEasgKQIdz1z/LgLzn3clq+VmWqbKdd5PFiA8JLWX8GOdswCe6EOZlCVVVDwMp1b6Cc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710865423; c=relaxed/simple;
	bh=AAmHZUYqsDU53+fAjmojb+p1lYpnbiNYYKThD97Ky4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t5uJSKg2yJr+Pak4c08SOP16EP4QcbxfNmrK2QdpRiWLmNISu42MWGsaCDAafLsCoRYNm3y3rQhixlsaZNVXTOjMKE42Amg5TpONbbtfIIO2/4XxtOFvz8/FtH3TGkBBPoE103vd4Avo2YOzf2AxpKna7Y5HghnXVmae3RT5h18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pfx6quGr; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pfx6quGr"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-430d3fcc511so267771cf.1
        for <patches@lists.linux.dev>; Tue, 19 Mar 2024 09:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710865419; x=1711470219; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iWGznRtjprEQdvMwwqFEvT3NX3IMbKF7QCHX1+NctEM=;
        b=pfx6quGrLp9So1fwB21ZY41pIMl31hVDaGJoA2uebklEyEj0QazYj8QTyu70ndMiks
         lEM+0SXU71QgHpscLvsWGnH25WwevCcePYdAATlHGbrl+2LDDzDDuMwOVcXFLPLOwGEF
         UyOTi3IgRAEBGlpj60s1a0U6cJPw1DxkFvQlrhXT+fJ6G0f37iddyCvnJZznyzhCkNGF
         GU2FSPbsHwsa5wnjpRN8GEq6iRK1INe0tzQ8fSKWL/3QsHYLDPwm2EZEyCLNWcauuESN
         S+uFqw291doEw/kKHD1PFbHuAn91Wm3n6r0BSSHfppNjOBHeOc6XBEol8FoYTcj84owm
         fpag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710865419; x=1711470219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iWGznRtjprEQdvMwwqFEvT3NX3IMbKF7QCHX1+NctEM=;
        b=JJcUtVCzPlD6LxAJP8RsyWY2o4m0F6fEn4FQvrwGzKZxemMqXq9j4lMvzFbC0ABaOy
         zilaLtIQDbCMsXDFbE1QzgPX7V8DQcmBpPlU+YXRYPJJvl6HRTCoO6dv+ZgUnqsJlitN
         R3m0yNNDaUY/pHTBlTUJcvyk3cmqtG8F6PLC26M7+IIF9NHDaeS/WA54TS5fORObnRFW
         MzjEXqbdvB0OXDsS40V+USDt+hqGO4RLxNsFOaRSA4h45ZYkzvXGa8asrqb6BvCkYBVJ
         6LH62zEKsuEY8Tgfd/jEpqKM3jfakc0oNc4mGDm/PLd9TdVN3FBxpEFqrwzZbyo+J2Is
         RiKg==
X-Forwarded-Encrypted: i=1; AJvYcCXLC5ksWTs8H3CctP/wV2/JGku9GUflq+5zhrr6rjwJjPyHZJOe6BYLBAuOO3bf0QJhTbEDiK4OCMBrX8FFef0MKEEtkM2aFA==
X-Gm-Message-State: AOJu0YycrYjbutGq/vg9RPs0azdg7ADlOIm8+82k/+MBUq8+37WId/k7
	x//CLQsH4iBmUB+jfkJ+wqu9cQQComAw5OQBCWF12oP5LvWQCCNUzKAYZrthOS+WpH1SaAykOhD
	EJAyLvXM9Rub7s1ptUF88SgtPN+JPLpFDSv1D
X-Google-Smtp-Source: AGHT+IEivgNAG7tSwC4z2YONnWnfKrEyjMbI/Z5h56kU3TKMVeV9totjzIkuVx1n/elA7cULgs/uIbOO3ToqCcata1w=
X-Received: by 2002:a05:622a:40b:b0:430:a3f2:6f66 with SMTP id
 n11-20020a05622a040b00b00430a3f26f66mr238066qtx.3.1710865418688; Tue, 19 Mar
 2024 09:23:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <21-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <21-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Wed, 20 Mar 2024 00:23:02 +0800
Message-ID: <CAKHBV24+c4ZB2ehRgp+hRX4LcQtTr8ZeU==+==gwbT+-J28Zmw@mail.gmail.com>
Subject: Re: [PATCH v5 21/27] iommu/arm-smmu-v3: Put the SVA mmu notifier in
 the smmu_domain
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
> This removes all the notifier de-duplication logic in the driver and
> relies on the core code to de-duplicate and allocate only one SVA domain
> per mm per smmu instance. This naturally gives a 1:1 relationship between
> SVA domain and mmu notifier.
>
> Remove all of the previous mmu_notifier, bond, shared cd, and cd refcount
> logic entirely.
>
> For the purpose of organizing patches lightly remove BTM support. The nex=
t
> patches will add it back in. BTM is a performance optimization so this is
> bisection friendly functionally invisible change. Note that the current
> code never even enables ARM_SMMU_FEAT_BTM so none of this code is ever
> even used.
>
> The bond/shared_cd/btm/asid allocator are tightly wound together and
> changing them all at once would make this patch too big. The core issue i=
s
> that having a single SVA domain per-smmu instance conflicts with the
> design of having a global ASID table that BTM currently needs, as we woul=
d
> end up having to assign multiple SVA domains to the same ASID.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 389 ++++--------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  81 +---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 +-
>  3 files changed, 101 insertions(+), 383 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 30b1cf587efffb..cb0da4e5a5517a 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -13,29 +13,9 @@
>  #include "../../iommu-sva.h"
>  #include "../../io-pgtable-arm.h"
>
> -struct arm_smmu_mmu_notifier {
> -       struct mmu_notifier             mn;
> -       struct arm_smmu_ctx_desc        *cd;
> -       bool                            cleared;
> -       refcount_t                      refs;
> -       struct list_head                list;
> -       struct arm_smmu_domain          *domain;
> -};
> -
> -#define mn_to_smmu(mn) container_of(mn, struct arm_smmu_mmu_notifier, mn=
)
> -
> -struct arm_smmu_bond {
> -       struct mm_struct                *mm;
> -       struct arm_smmu_mmu_notifier    *smmu_mn;
> -       struct list_head                list;
> -};
> -
> -#define sva_to_bond(handle) \
> -       container_of(handle, struct arm_smmu_bond, sva)
> -
>  static DEFINE_MUTEX(sva_lock);
>
> -static void
> +static void __maybe_unused
>  arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
>  {
>         struct arm_smmu_master_domain *master_domain;
> @@ -58,58 +38,6 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_dom=
ain *smmu_domain)
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  }
>
> -/*
> - * Check if the CPU ASID is available on the SMMU side. If a private con=
text
> - * descriptor is using it, try to replace it.
> - */
> -static struct arm_smmu_ctx_desc *
> -arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
> -{
> -       int ret;
> -       u32 new_asid;
> -       struct arm_smmu_ctx_desc *cd;
> -       struct arm_smmu_device *smmu;
> -       struct arm_smmu_domain *smmu_domain;
> -
> -       cd =3D xa_load(&arm_smmu_asid_xa, asid);
> -       if (!cd)
> -               return NULL;
> -
> -       if (cd->mm) {
> -               if (WARN_ON(cd->mm !=3D mm))
> -                       return ERR_PTR(-EINVAL);
> -               /* All devices bound to this mm use the same cd struct. *=
/
> -               refcount_inc(&cd->refs);
> -               return cd;
> -       }
> -
> -       smmu_domain =3D container_of(cd, struct arm_smmu_domain, cd);
> -       smmu =3D smmu_domain->smmu;
> -
> -       ret =3D xa_alloc(&arm_smmu_asid_xa, &new_asid, cd,
> -                      XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNE=
L);
> -       if (ret)
> -               return ERR_PTR(-ENOSPC);
> -       /*
> -        * Race with unmap: TLB invalidations will start targeting the ne=
w ASID,
> -        * which isn't assigned yet. We'll do an invalidate-all on the ol=
d ASID
> -        * later, so it doesn't matter.
> -        */
> -       cd->asid =3D new_asid;
> -       /*
> -        * Update ASID and invalidate CD in all associated masters. There=
 will
> -        * be some overlap between use of both ASIDs, until we invalidate=
 the
> -        * TLB.
> -        */
> -       arm_smmu_update_s1_domain_cd_entry(smmu_domain);
> -
> -       /* Invalidate TLB entries previously associated with that context=
 */
> -       arm_smmu_tlb_inv_asid(smmu, asid);
> -
> -       xa_erase(&arm_smmu_asid_xa, asid);
> -       return NULL;
> -}
> -
>  static u64 page_size_to_cd(void)
>  {
>         static_assert(PAGE_SIZE =3D=3D SZ_4K || PAGE_SIZE =3D=3D SZ_16K |=
|
> @@ -123,7 +51,8 @@ static u64 page_size_to_cd(void)
>
>  static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
>                                  struct arm_smmu_master *master,
> -                                struct mm_struct *mm, u16 asid)
> +                                struct mm_struct *mm, u16 asid,
> +                                bool btm_invalidation)
>  {
>         u64 par;
>
> @@ -144,7 +73,7 @@ static void arm_smmu_make_sva_cd(struct arm_smmu_cd *t=
arget,
>                 (master->stall_enabled ? CTXDESC_CD_0_S : 0) |
>                 CTXDESC_CD_0_R |
>                 CTXDESC_CD_0_A |
> -               CTXDESC_CD_0_ASET |
> +               (btm_invalidation ? 0 : CTXDESC_CD_0_ASET) |
>                 FIELD_PREP(CTXDESC_CD_0_ASID, asid));
>
>         /*
> @@ -186,69 +115,6 @@ static void arm_smmu_make_sva_cd(struct arm_smmu_cd =
*target,
>         target->data[3] =3D cpu_to_le64(read_sysreg(mair_el1));
>  }
>
> -static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_stru=
ct *mm)
> -{
> -       u16 asid;
> -       int err =3D 0;
> -       struct arm_smmu_ctx_desc *cd;
> -       struct arm_smmu_ctx_desc *ret =3D NULL;
> -
> -       /* Don't free the mm until we release the ASID */
> -       mmgrab(mm);
> -
> -       asid =3D arm64_mm_context_get(mm);
> -       if (!asid) {
> -               err =3D -ESRCH;
> -               goto out_drop_mm;
> -       }
> -
> -       cd =3D kzalloc(sizeof(*cd), GFP_KERNEL);
> -       if (!cd) {
> -               err =3D -ENOMEM;
> -               goto out_put_context;
> -       }
> -
> -       refcount_set(&cd->refs, 1);
> -
> -       mutex_lock(&arm_smmu_asid_lock);
> -       ret =3D arm_smmu_share_asid(mm, asid);
> -       if (ret) {
> -               mutex_unlock(&arm_smmu_asid_lock);
> -               goto out_free_cd;
> -       }
> -
> -       err =3D xa_insert(&arm_smmu_asid_xa, asid, cd, GFP_KERNEL);
> -       mutex_unlock(&arm_smmu_asid_lock);
> -
> -       if (err)
> -               goto out_free_asid;
> -
> -       cd->asid =3D asid;
> -       cd->mm =3D mm;
> -
> -       return cd;
> -
> -out_free_asid:
> -       arm_smmu_free_asid(cd);
> -out_free_cd:
> -       kfree(cd);
> -out_put_context:
> -       arm64_mm_context_put(mm);
> -out_drop_mm:
> -       mmdrop(mm);
> -       return err < 0 ? ERR_PTR(err) : ret;
> -}
> -
> -static void arm_smmu_free_shared_cd(struct arm_smmu_ctx_desc *cd)
> -{
> -       if (arm_smmu_free_asid(cd)) {
> -               /* Unpin ASID */
> -               arm64_mm_context_put(cd->mm);
> -               mmdrop(cd->mm);
> -               kfree(cd);
> -       }
> -}
> -
>  /*
>   * Cloned from the MAX_TLBI_OPS in arch/arm64/include/asm/tlbflush.h, th=
is
>   * is used as a threshold to replace per-page TLBI commands to issue in =
the
> @@ -263,8 +129,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlb=
s(struct mmu_notifier *mn,
>                                                 unsigned long start,
>                                                 unsigned long end)
>  {
> -       struct arm_smmu_mmu_notifier *smmu_mn =3D mn_to_smmu(mn);
> -       struct arm_smmu_domain *smmu_domain =3D smmu_mn->domain;
> +       struct arm_smmu_domain *smmu_domain =3D
> +               container_of(mn, struct arm_smmu_domain, mmu_notifier);
>         size_t size;
>
>         /*
> @@ -281,34 +147,27 @@ static void arm_smmu_mm_arch_invalidate_secondary_t=
lbs(struct mmu_notifier *mn,
>                         size =3D 0;
>         }
>
> -       if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM)) {
> +       if (!smmu_domain->btm_invalidation) {
>                 if (!size)
>                         arm_smmu_tlb_inv_asid(smmu_domain->smmu,
> -                                             smmu_mn->cd->asid);
> +                                             smmu_domain->cd.asid);
>                 else
>                         arm_smmu_tlb_inv_range_asid(start, size,
> -                                                   smmu_mn->cd->asid,
> +                                                   smmu_domain->cd.asid,
>                                                     PAGE_SIZE, false,
>                                                     smmu_domain);
>         }
>
> -       arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm),=
 start,
> -                                   size);
> +       arm_smmu_atc_inv_domain(smmu_domain, start, size);
>  }
>
>  static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struc=
t *mm)
>  {
> -       struct arm_smmu_mmu_notifier *smmu_mn =3D mn_to_smmu(mn);
> -       struct arm_smmu_domain *smmu_domain =3D smmu_mn->domain;
> +       struct arm_smmu_domain *smmu_domain =3D
> +               container_of(mn, struct arm_smmu_domain, mmu_notifier);
>         struct arm_smmu_master_domain *master_domain;
>         unsigned long flags;
>
> -       mutex_lock(&sva_lock);
> -       if (smmu_mn->cleared) {
> -               mutex_unlock(&sva_lock);
> -               return;
> -       }
> -
>         /*
>          * DMA may still be running. Keep the cd valid to avoid C_BAD_CD =
events,
>          * but disable translation.
> @@ -320,25 +179,27 @@ static void arm_smmu_mm_release(struct mmu_notifier=
 *mn, struct mm_struct *mm)
>                 struct arm_smmu_cd target;
>                 struct arm_smmu_cd *cdptr;
>
> -               cdptr =3D arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid=
(mm));
> +               cdptr =3D arm_smmu_get_cd_ptr(master, master_domain->ssid=
);
>                 if (WARN_ON(!cdptr))
>                         continue;
> -               arm_smmu_make_sva_cd(&target, master, NULL, smmu_mn->cd->=
asid);
> -               arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), =
cdptr,
> +               arm_smmu_make_sva_cd(&target, master, NULL,
> +                                    smmu_domain->cd.asid,
> +                                    smmu_domain->btm_invalidation);
> +               arm_smmu_write_cd_entry(master, master_domain->ssid, cdpt=
r,
>                                         &target);
>         }
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>
> -       arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
> -       arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm),=
 0, 0);
> -
> -       smmu_mn->cleared =3D true;
> -       mutex_unlock(&sva_lock);
> +       arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
> +       arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
>  }
>
>  static void arm_smmu_mmu_notifier_free(struct mmu_notifier *mn)
>  {
> -       kfree(mn_to_smmu(mn));
> +       struct arm_smmu_domain *smmu_domain =3D
> +               container_of(mn, struct arm_smmu_domain, mmu_notifier);
> +
> +       kfree(smmu_domain);
>  }
>
>  static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops =3D {
> @@ -347,113 +208,6 @@ static const struct mmu_notifier_ops arm_smmu_mmu_n=
otifier_ops =3D {
>         .free_notifier                  =3D arm_smmu_mmu_notifier_free,
>  };
>
> -/* Allocate or get existing MMU notifier for this {domain, mm} pair */
> -static struct arm_smmu_mmu_notifier *
> -arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
> -                         struct mm_struct *mm)
> -{
> -       int ret;
> -       struct arm_smmu_ctx_desc *cd;
> -       struct arm_smmu_mmu_notifier *smmu_mn;
> -
> -       list_for_each_entry(smmu_mn, &smmu_domain->mmu_notifiers, list) {
> -               if (smmu_mn->mn.mm =3D=3D mm) {
> -                       refcount_inc(&smmu_mn->refs);
> -                       return smmu_mn;
> -               }
> -       }
> -
> -       cd =3D arm_smmu_alloc_shared_cd(mm);
> -       if (IS_ERR(cd))
> -               return ERR_CAST(cd);
> -
> -       smmu_mn =3D kzalloc(sizeof(*smmu_mn), GFP_KERNEL);
> -       if (!smmu_mn) {
> -               ret =3D -ENOMEM;
> -               goto err_free_cd;
> -       }
> -
> -       refcount_set(&smmu_mn->refs, 1);
> -       smmu_mn->cd =3D cd;
> -       smmu_mn->domain =3D smmu_domain;
> -       smmu_mn->mn.ops =3D &arm_smmu_mmu_notifier_ops;
> -
> -       ret =3D mmu_notifier_register(&smmu_mn->mn, mm);
> -       if (ret) {
> -               kfree(smmu_mn);
> -               goto err_free_cd;
> -       }
> -
> -       list_add(&smmu_mn->list, &smmu_domain->mmu_notifiers);
> -       return smmu_mn;
> -
> -err_free_cd:
> -       arm_smmu_free_shared_cd(cd);
> -       return ERR_PTR(ret);
> -}
> -
> -static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu=
_mn)
> -{
> -       struct mm_struct *mm =3D smmu_mn->mn.mm;
> -       struct arm_smmu_ctx_desc *cd =3D smmu_mn->cd;
> -       struct arm_smmu_domain *smmu_domain =3D smmu_mn->domain;
> -
> -       if (!refcount_dec_and_test(&smmu_mn->refs))
> -               return;
> -
> -       list_del(&smmu_mn->list);
> -
> -       /*
> -        * If we went through clear(), we've already invalidated, and no
> -        * new TLB entry can have been formed.
> -        */
> -       if (!smmu_mn->cleared) {
> -               arm_smmu_tlb_inv_asid(smmu_domain->smmu, cd->asid);
> -               arm_smmu_atc_inv_domain_sva(smmu_domain,
> -                                           mm_get_enqcmd_pasid(mm), 0, 0=
);
> -       }
> -
> -       /* Frees smmu_mn */
> -       mmu_notifier_put(&smmu_mn->mn);
> -       arm_smmu_free_shared_cd(cd);
> -}
> -
> -static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm,
> -                              struct arm_smmu_cd *target)
> -{
> -       int ret;
> -       struct arm_smmu_bond *bond;
> -       struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> -       struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
> -       struct arm_smmu_domain *smmu_domain;
> -
> -       if (!(domain->type & __IOMMU_DOMAIN_PAGING))
> -               return -ENODEV;
> -       smmu_domain =3D to_smmu_domain(domain);
> -       if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_S1)
> -               return -ENODEV;
> -
> -       bond =3D kzalloc(sizeof(*bond), GFP_KERNEL);
> -       if (!bond)
> -               return -ENOMEM;
> -
> -       bond->mm =3D mm;
> -
> -       bond->smmu_mn =3D arm_smmu_mmu_notifier_get(smmu_domain, mm);
> -       if (IS_ERR(bond->smmu_mn)) {
> -               ret =3D PTR_ERR(bond->smmu_mn);
> -               goto err_free_bond;
> -       }
> -
> -       arm_smmu_make_sva_cd(target, master, mm, bond->smmu_mn->cd->asid)=
;
> -       list_add(&bond->list, &master->bonds);
> -       return 0;
> -
> -err_free_bond:
> -       kfree(bond);
> -       return ret;
> -}
> -
>  bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
>  {
>         unsigned long reg, fld;
> @@ -581,11 +335,6 @@ int arm_smmu_master_enable_sva(struct arm_smmu_maste=
r *master)
>  int arm_smmu_master_disable_sva(struct arm_smmu_master *master)
>  {
>         mutex_lock(&sva_lock);
> -       if (!list_empty(&master->bonds)) {
> -               dev_err(master->dev, "cannot disable SVA, device is bound=
\n");
> -               mutex_unlock(&sva_lock);
> -               return -EBUSY;
> -       }
>         arm_smmu_master_sva_disable_iopf(master);
>         master->sva_enabled =3D false;
>         mutex_unlock(&sva_lock);
> @@ -602,59 +351,54 @@ void arm_smmu_sva_notifier_synchronize(void)
>         mmu_notifier_synchronize();
>  }
>
> -void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
> -                                  struct device *dev, ioasid_t id)
> -{
> -       struct mm_struct *mm =3D domain->mm;
> -       struct arm_smmu_bond *bond =3D NULL, *t;
> -       struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> -
> -       arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
> -
> -       mutex_lock(&sva_lock);
> -       list_for_each_entry(t, &master->bonds, list) {
> -               if (t->mm =3D=3D mm) {
> -                       bond =3D t;
> -                       break;
> -               }
> -       }
> -
> -       if (!WARN_ON(!bond)) {
> -               list_del(&bond->list);
> -               arm_smmu_mmu_notifier_put(bond->smmu_mn);
> -               kfree(bond);
> -       }
> -       mutex_unlock(&sva_lock);
> -}
> -
>  static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
>                                       struct device *dev, ioasid_t id)
>  {
> +       struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
>         struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> -       int ret =3D 0;
> -       struct mm_struct *mm =3D domain->mm;
>         struct arm_smmu_cd target;
> +       int ret;
>
> -       if (mm_get_enqcmd_pasid(mm) !=3D id || !master->cd_table.used_sid=
)
> +       /* Prevent arm_smmu_mm_release from being called while we are att=
aching */
> +       if (!mmget_not_zero(domain->mm))
>                 return -EINVAL;
>
> -       if (!arm_smmu_get_cd_ptr(master, id))
> -               return -ENOMEM;
> +       /*
> +        * This does not need the arm_smmu_asid_lock because SVA domains =
never
> +        * get reassigned
> +        */
> +       arm_smmu_make_sva_cd(&target, master, smmu_domain->domain.mm,
> +                            smmu_domain->cd.asid,
> +                            smmu_domain->btm_invalidation);
>
> -       mutex_lock(&sva_lock);
> -       ret =3D __arm_smmu_sva_bind(dev, mm, &target);
> -       mutex_unlock(&sva_lock);
> -       if (ret)
> -               return ret;
> +       ret =3D arm_smmu_set_pasid(master, smmu_domain, id, &target);
>
> -       /* This cannot fail since we preallocated the cdptr */
> -       arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
> -       return 0;
> +       mmput(domain->mm);
> +       return ret;
>  }
>
>  static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
>  {
> -       kfree(to_smmu_domain(domain));
> +       struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
> +
> +       /*
> +        * Ensure the ASID is empty in the iommu cache before allowing re=
use.
> +        */
> +       arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
> +
> +       /*
> +        * Notice that the arm_smmu_mm_arch_invalidate_secondary_tlbs op =
can
> +        * still be called/running at this point. We allow the ASID to be
> +        * reused, and if there is a race then it just suffers harmless
> +        * unnecessary invalidation.
> +        */
> +       xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
> +
> +       /*
> +        * Actual free is defered to the SRCU callback
> +        * arm_smmu_mmu_notifier_free()
> +        */
> +       mmu_notifier_put(&smmu_domain->mmu_notifier);
>  }

I'm far from familiar with mmu_notifier and how the sva layers manage
its reference count....but is calling mmu_notifier_unregister instead
of mmu_notifier_put possible here? Such that invalidating the TL,
releasing the allocated ASID, and freeing the smmu_domain can take
place here after the mmu_notifier is gone.


>
>  static const struct iommu_domain_ops arm_smmu_sva_domain_ops =3D {
> @@ -668,6 +412,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct=
 device *dev,
>         struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
>         struct arm_smmu_device *smmu =3D master->smmu;
>         struct arm_smmu_domain *smmu_domain;
> +       u32 asid;
> +       int ret;
>
>         smmu_domain =3D arm_smmu_domain_alloc();
>         if (IS_ERR(smmu_domain))
> @@ -677,5 +423,22 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struc=
t device *dev,
>         smmu_domain->domain.ops =3D &arm_smmu_sva_domain_ops;
>         smmu_domain->smmu =3D smmu;
>
> +       ret =3D xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
> +                      XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNE=
L);
> +       if (ret)
> +               goto err_free;
> +
> +       smmu_domain->cd.asid =3D asid;
> +       smmu_domain->mmu_notifier.ops =3D &arm_smmu_mmu_notifier_ops;
> +       ret =3D mmu_notifier_register(&smmu_domain->mmu_notifier, mm);
> +       if (ret)
> +               goto err_asid;
> +
>         return &smmu_domain->domain;
> +
> +err_asid:
> +       xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
> +err_free:
> +       kfree(smmu_domain);
> +       return ERR_PTR(ret);
>  }
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index a255a02a5fc8a9..5642321b2124d9 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1436,22 +1436,6 @@ static void arm_smmu_free_cd_tables(struct arm_smm=
u_master *master)
>         cd_table->cdtab =3D NULL;
>  }
>
> -bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
> -{
> -       bool free;
> -       struct arm_smmu_ctx_desc *old_cd;
> -
> -       if (!cd->asid)
> -               return false;
> -
> -       free =3D refcount_dec_and_test(&cd->refs);
> -       if (free) {
> -               old_cd =3D xa_erase(&arm_smmu_asid_xa, cd->asid);
> -               WARN_ON(old_cd !=3D cd);
> -       }
> -       return free;
> -}
> -
>  /* Stream table manipulation functions */
>  static void
>  arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_des=
c *desc)
> @@ -2042,8 +2026,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_=
master *master,
>         return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
>  }
>
> -static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain=
,
> -                                    ioasid_t ssid, unsigned long iova, s=
ize_t size)
> +int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
> +                           unsigned long iova, size_t size)
>  {
>         struct arm_smmu_master_domain *master_domain;
>         int i;
> @@ -2081,15 +2065,7 @@ static int __arm_smmu_atc_inv_domain(struct arm_sm=
mu_domain *smmu_domain,
>                 if (!master->ats_enabled)
>                         continue;
>
> -               /*
> -                * Non-zero ssid means SVA is co-opting the S1 domain to =
issue
> -                * invalidations for SVA PASIDs.
> -                */
> -               if (ssid !=3D IOMMU_NO_PASID)
> -                       arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
> -               else
> -                       arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova=
, size,
> -                                               &cmd);
> +               arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size, =
&cmd);
>
>                 for (i =3D 0; i < master->num_streams; i++) {
>                         cmd.atc.sid =3D master->streams[i].id;
> @@ -2101,19 +2077,6 @@ static int __arm_smmu_atc_inv_domain(struct arm_sm=
mu_domain *smmu_domain,
>         return arm_smmu_cmdq_batch_submit(smmu_domain->smmu, &cmds);
>  }
>
> -static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
> -                                  unsigned long iova, size_t size)
> -{
> -       return __arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iov=
a,
> -                                        size);
> -}
> -
> -int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
> -                               ioasid_t ssid, unsigned long iova, size_t=
 size)
> -{
> -       return __arm_smmu_atc_inv_domain(smmu_domain, ssid, iova, size);
> -}
> -
>  /* IO_PGTABLE API */
>  static void arm_smmu_tlb_inv_context(void *cookie)
>  {
> @@ -2302,7 +2265,6 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
>         mutex_init(&smmu_domain->init_mutex);
>         INIT_LIST_HEAD(&smmu_domain->devices);
>         spin_lock_init(&smmu_domain->devices_lock);
> -       INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
>
>         return smmu_domain;
>  }
> @@ -2345,7 +2307,7 @@ static void arm_smmu_domain_free(struct iommu_domai=
n *domain)
>         if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
>                 /* Prevent SVA from touching the CD while we're freeing i=
t */
>                 mutex_lock(&arm_smmu_asid_lock);
> -               arm_smmu_free_asid(&smmu_domain->cd);
> +               xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
>                 mutex_unlock(&arm_smmu_asid_lock);
>         } else {
>                 struct arm_smmu_s2_cfg *cfg =3D &smmu_domain->s2_cfg;
> @@ -2363,11 +2325,9 @@ static int arm_smmu_domain_finalise_s1(struct arm_=
smmu_device *smmu,
>         u32 asid;
>         struct arm_smmu_ctx_desc *cd =3D &smmu_domain->cd;
>
> -       refcount_set(&cd->refs, 1);
> -
>         /* Prevent SVA from modifying the ASID until it is written to the=
 CD */
>         mutex_lock(&arm_smmu_asid_lock);
> -       ret =3D xa_alloc(&arm_smmu_asid_xa, &asid, cd,
> +       ret =3D xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
>                        XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNE=
L);
>         cd->asid        =3D (u16)asid;
>         mutex_unlock(&arm_smmu_asid_lock);
> @@ -2818,7 +2778,11 @@ int arm_smmu_set_pasid(struct arm_smmu_master *mas=
ter,
>         struct arm_smmu_cd *cdptr;
>         int ret;
>
> -       if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev))=
)
> +       if (smmu_domain->smmu !=3D master->smmu)
> +               return -EINVAL;
> +
> +       if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev))=
 ||
> +           !master->cd_table.used_sid)
>                 return -ENODEV;
>
>         cdptr =3D arm_smmu_get_cd_ptr(master, pasid);
> @@ -2839,9 +2803,18 @@ int arm_smmu_set_pasid(struct arm_smmu_master *mas=
ter,
>         return ret;
>  }
>
> -void arm_smmu_remove_pasid(struct arm_smmu_master *master,
> -                          struct arm_smmu_domain *smmu_domain, ioasid_t =
pasid)
> +static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid=
)
>  {
> +       struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> +       struct arm_smmu_domain *smmu_domain;
> +       struct iommu_domain *domain;
> +
> +       domain =3D iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAI=
N_SVA);
> +       if (WARN_ON(IS_ERR(domain)) || !domain)
> +               return;
> +
> +       smmu_domain =3D to_smmu_domain(domain);
> +
>         mutex_lock(&arm_smmu_asid_lock);
>         arm_smmu_clear_cd(master, pasid);
>         if (master->ats_enabled)
> @@ -3115,7 +3088,6 @@ static struct iommu_device *arm_smmu_probe_device(s=
truct device *dev)
>
>         master->dev =3D dev;
>         master->smmu =3D smmu;
> -       INIT_LIST_HEAD(&master->bonds);
>         dev_iommu_priv_set(dev, master);
>
>         ret =3D arm_smmu_insert_master(smmu, master);
> @@ -3296,17 +3268,6 @@ static int arm_smmu_def_domain_type(struct device =
*dev)
>         return 0;
>  }
>
> -static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid=
)
> -{
> -       struct iommu_domain *domain;
> -
> -       domain =3D iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAI=
N_SVA);
> -       if (WARN_ON(IS_ERR(domain)) || !domain)
> -               return;
> -
> -       arm_smmu_sva_remove_dev_pasid(domain, dev, pasid);
> -}
> -
>  static struct iommu_ops arm_smmu_ops =3D {
>         .identity_domain        =3D &arm_smmu_identity_domain,
>         .blocked_domain         =3D &arm_smmu_blocked_domain,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index f62bd2ef36a18d..cfae4d69cd810c 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -587,9 +587,6 @@ struct arm_smmu_strtab_l1_desc {
>
>  struct arm_smmu_ctx_desc {
>         u16                             asid;
> -
> -       refcount_t                      refs;
> -       struct mm_struct                *mm;
>  };
>
>  struct arm_smmu_l1_ctx_desc {
> @@ -713,7 +710,6 @@ struct arm_smmu_master {
>         bool                            stall_enabled;
>         bool                            sva_enabled;
>         bool                            iopf_enabled;
> -       struct list_head                bonds;
>         unsigned int                    ssid_bits;
>  };
>
> @@ -742,7 +738,8 @@ struct arm_smmu_domain {
>         struct list_head                devices;
>         spinlock_t                      devices_lock;
>
> -       struct list_head                mmu_notifiers;
> +       struct mmu_notifier             mmu_notifier;
> +       bool                            btm_invalidation;
>  };
>
>  struct arm_smmu_master_domain {
> @@ -781,9 +778,8 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *sm=
mu, u16 asid);
>  void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int as=
id,
>                                  size_t granule, bool leaf,
>                                  struct arm_smmu_domain *smmu_domain);
> -bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
> -int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
> -                               ioasid_t ssid, unsigned long iova, size_t=
 size);
> +int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
> +                           unsigned long iova, size_t size);
>
>  #ifdef CONFIG_ARM_SMMU_V3_SVA
>  bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
> @@ -795,8 +791,6 @@ bool arm_smmu_master_iopf_supported(struct arm_smmu_m=
aster *master);
>  void arm_smmu_sva_notifier_synchronize(void);
>  struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
>                                                struct mm_struct *mm);
> -void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
> -                                  struct device *dev, ioasid_t id);
>  #else /* CONFIG_ARM_SMMU_V3_SVA */
>  static inline bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
>  {
> --
> 2.43.2
>
