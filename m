Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57186134CB
	for <patches@lists.linux.dev>; Tue, 19 Mar 2024 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868064; cv=none; b=Ko6omg3XsIQSsluAfc2BKrkoWJX/JWrgq8iyQ6XTCs5Z57vfrB1Zvhnm9r8ujPGAOBeEtAcsTJmFsnIlC+uZik13zQqxlrBV7FgA52REx9iNogMwHMuqAo3gxE4n1lg2PTWQX31l2lE16Mn2Si6tcsK93LxhhJODEC/Au5ExwHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868064; c=relaxed/simple;
	bh=tXSTtorQDJlgygAerTXHdSF3hiEiMg27ToFjJy5uzkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JUXozTumHL6C+ONjdIC8jXA++5DnItCO38m+iySVQvMJopb52TfQB0izH01NCxy9m9qBNUwcShXgjcPwdUw3A8kfBCByGI32MJA3cy6Q1bs7WqFR7o18GFeae3BbiVfudvIicP2kdXgQqWv7NHzRx3iFLWDlXpfZfMtaeUduvmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t1SkPWTE; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t1SkPWTE"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-42ee0c326e8so14521cf.0
        for <patches@lists.linux.dev>; Tue, 19 Mar 2024 10:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710868060; x=1711472860; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ykeJzPkdHngNQcUb/QnCLjYJMU9ShnKvC/VB5HxyKvc=;
        b=t1SkPWTEz6za58dUIXlDbXeB/d1p0S8Vb5n9Ld0u1vFizaz87QjSTv8ifjZQucFT0O
         tbmAbXbGMtKjk4yIcEXyMBle2mnOuJUIxg86GLcLaLYcnBFjhttbzD68lDNSOn+3FCe4
         0NALUI+eHrgPCwcN++JCi1WbrErAMALM+KkHvHsdVGXAxgR3Xs7kdVvwHUQ7t/cz7Hrl
         21Ipt+1CQKhtTXGla9nQMbNhuu/PmvLYWV1gcMIiRyFHg+JW6UXpqjqlJGBCkAlBHdSc
         dD4k4UmJNuOnEipjb5YhKkaYYJf9+hyb5JoccZybSvjzvaVfx+rEd9Cr2tlYsn4xe5PS
         h9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710868060; x=1711472860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ykeJzPkdHngNQcUb/QnCLjYJMU9ShnKvC/VB5HxyKvc=;
        b=mTfJaN+SGv5L2k60ksnkntTUYIX5foAmni4bw2+RXh5GnnooDbq4qBaNmUjHRjsABq
         kGUse/FSUlbAkWS8XfY2BlfRg2Y9j0AjqWAvi0pCNp54gLZh5aJwI1vod2goPeAiHx1d
         yFHRfhXQ8Yy1bDOXxwSx238pGiDuXPalBRvoTKI5qww1Cn1oV0JuyNir33X9XTbf2lTh
         IKpJ5/xM1E7QV9MEO5a9dPhuFz7JOx4+AEG8OrAkOft0CEIzhtKhv4VVtHsrKtkXMAxD
         zzNKCf20XXL1AinhQuIKhrUz/vIbVNcVGPYWJBNV9MIiQ19xRdtXmziHClttTO8q/hpo
         cphw==
X-Forwarded-Encrypted: i=1; AJvYcCX8GEzcKdxO12ieOS80dPuLyaE/Uy45W/0a+yiSgTcDTQW4+SjkqNBxkr0fBmPrZ/jTOGJIkssig8qg+DzckoL82voafwOaiQ==
X-Gm-Message-State: AOJu0YwHmeLTcVg/+Tqq0DgpfUBX1p5bC3QwaHv6Qzy6Qxo65jn+kHoi
	ZWac6ctHPD2sw5r5zj4M9YmapY5eRXYQBevFeScQh2JMfdv3TxIjL7OrULcvtXMjB4n1gSMgQJp
	SvFlN9ldxBRv2CJ5Ep04Vx++ob9NtcE0ZY0k8
X-Google-Smtp-Source: AGHT+IHtrAMwTafr4kQ7GQ4Mq6ganVsavVSZ3Bm6GOTrJd1DinDR7kpv2lGvGSPIH2GEZirPI4KCR6KZ7omTh5QgRlo=
X-Received: by 2002:ac8:7dcc:0:b0:430:ad98:cc44 with SMTP id
 c12-20020ac87dcc000000b00430ad98cc44mr14415qte.12.1710868059925; Tue, 19 Mar
 2024 10:07:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <24-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <24-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Wed, 20 Mar 2024 01:07:01 +0800
Message-ID: <CAKHBV2493ppkJUHOn1jqVG4BzWaz0i2sXRBHD9XYAe9VHFSygQ@mail.gmail.com>
Subject: Re: [PATCH v5 24/27] iommu/arm-smmu-v3: Bring back SVA BTM support
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
> BTM support is a feature where the CPU TLB invalidation can be forwarded
> to the IOMMU and also invalidate the IOTLB. For this to work the CPU and
> IOMMU ASID must be the same.
>
> Retain the prior SVA design here of keeping the ASID allocator for the
> IOMMU private to SMMU and force SVA domains to set an ASID that matches
> the CPU ASID.
>
> This requires changing the ASID assigned to a S1 domain if it happens to
> be overlapping with the required CPU ASID. We hold on to the CPU ASID so
> long as the SVA iommu_domain exists, so SVA domain conflict is not
> possible.
>
> With the asid per-smmu we no longer have a problem that two per-smmu
> iommu_domain's would need to share a CPU ASID entry in the IOMMU's xarray=
.
>
> Use the same ASID move algorithm for the S1 domains as before with some
> streamlining around how the xarray is being used. Do not synchronize the
> ASID's if BTM mode is not supported. Just leave BTM features off
> everywhere.
>
> Audit all the places that touch cd->asid and think carefully about how th=
e
> locking works with the change to the cd->asid by the move algorithm. Use
> xarray internal locking during xa_alloc() instead of double locking. Add =
a
> note that concurrent S1 invalidation doesn't fully work.
>
> Note that this is all still dead code, ARM_SMMU_FEAT_BTM is never set.

Clearly a lot of work/thought has gone into this patch, but I have to
wonder if this complexity is worth carrying forward for a feature that
was never enabled... Is moving this to part 3 or dropping it all
together an option?

>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 133 ++++++++++++++++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  15 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +-
>  3 files changed, 129 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 3acd699433b7d8..0b5aeaa3a85575 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -15,12 +15,33 @@
>
>  static DEFINE_MUTEX(sva_lock);
>
> -static void __maybe_unused
> -arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
> +static int arm_smmu_realloc_s1_domain_asid(struct arm_smmu_device *smmu,
> +                                          struct arm_smmu_domain *smmu_d=
omain)
>  {
>         struct arm_smmu_master_domain *master_domain;
> +       u32 old_asid =3D smmu_domain->cd.asid;
>         struct arm_smmu_cd target_cd;
>         unsigned long flags;
> +       int ret;
> +
> +       lockdep_assert_held(&smmu->asid_lock);
> +
> +       /*
> +        * FIXME: The unmap and invalidation path doesn't take any locks =
but
> +        * this is not fully safe. Since updating the CD tables is not at=
omic
> +        * there is always a hole where invalidating only one ASID of two=
 active
> +        * ASIDs during unmap will cause the IOTLB to become stale.
> +        *
> +        * This approach is to hopefully shift the racing CPUs to the new=
 ASID
> +        * before we start programming the HW. This increases the chance =
that
> +        * racing IOPTE changes will pick up an invalidation for the new =
ASID
> +        * and we achieve eventual consistency. For the brief period wher=
e the
> +        * old ASID is still in the CD entries it will become incoherent.
> +        */
> +       ret =3D xa_alloc(&smmu->asid_map, &smmu_domain->cd.asid, smmu_dom=
ain,
> +                      XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNE=
L);
> +       if (ret)
> +               return ret;
>
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>         list_for_each_entry(master_domain, &smmu_domain->devices, devices=
_elm) {
> @@ -36,6 +57,10 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_dom=
ain *smmu_domain)
>                                         &target_cd);
>         }
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +
> +       /* Clean the ASID we are about to assign to a new translation */
> +       arm_smmu_tlb_inv_asid(smmu, old_asid);
> +       return 0;
>  }
>
>  static u64 page_size_to_cd(void)
> @@ -148,12 +173,12 @@ static void arm_smmu_mm_arch_invalidate_secondary_t=
lbs(struct mmu_notifier *mn,
>         }
>
>         if (!smmu_domain->btm_invalidation) {
> +               ioasid_t asid =3D READ_ONCE(smmu_domain->cd.asid);
> +
>                 if (!size)
> -                       arm_smmu_tlb_inv_asid(smmu_domain->smmu,
> -                                             smmu_domain->cd.asid);
> +                       arm_smmu_tlb_inv_asid(smmu_domain->smmu, asid);
>                 else
> -                       arm_smmu_tlb_inv_range_asid(start, size,
> -                                                   smmu_domain->cd.asid,
> +                       arm_smmu_tlb_inv_range_asid(start, size, asid,
>                                                     PAGE_SIZE, false,
>                                                     smmu_domain);
>         }
> @@ -182,6 +207,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *=
mn, struct mm_struct *mm)
>                 cdptr =3D arm_smmu_get_cd_ptr(master, master_domain->ssid=
);
>                 if (WARN_ON(!cdptr))
>                         continue;
> +
> +               /* An SVA ASID never changes, no asid_lock required */
>                 arm_smmu_make_sva_cd(&target, master, NULL,
>                                      smmu_domain->cd.asid,
>                                      smmu_domain->btm_invalidation);
> @@ -388,6 +415,8 @@ static void arm_smmu_sva_domain_free(struct iommu_dom=
ain *domain)
>          * unnecessary invalidation.
>          */
>         arm_smmu_domain_free_id(smmu_domain);
> +       if (smmu_domain->btm_invalidation)
> +               arm64_mm_context_put(domain->mm);
>
>         /*
>          * Actual free is defered to the SRCU callback
> @@ -401,13 +430,97 @@ static const struct iommu_domain_ops arm_smmu_sva_d=
omain_ops =3D {
>         .free                   =3D arm_smmu_sva_domain_free
>  };
>
> +static int arm_smmu_share_asid(struct arm_smmu_device *smmu,
> +                              struct arm_smmu_domain *smmu_domain,
> +                              struct mm_struct *mm)
> +{
> +       struct arm_smmu_domain *old_s1_domain;
> +       int ret;
> +
> +       /*
> +        * Notice that BTM is never currently enabled, this is all dead c=
ode.
> +        * The specification cautions:
> +        *
> +        * Note: Arm expects that SMMU stage 2 address spaces are general=
ly
> +        * shared with their respective PE virtual machine stage 2
> +        * configuration. If broadcast invalidation is required to be avo=
ided
> +        * for a particular SMMU stage 2 address space, Arm recommends th=
at a
> +        * hypervisor configures the STE with a VMID that is not allocate=
d for
> +        * virtual machine use on the PEs
> +        *
> +        * However, in Linux, both KVM and SMMU think they own the VMID p=
ool.
> +        * Unfortunately the ARM design is problematic for Linux as we do=
 not
> +        * currently share the S2 table with KVM. This creates a situatio=
n where
> +        * the S2 needs to have the same VMID as KVM in order to allow th=
e guest
> +        * to use BTM, however we must still invalidate the S2 directly s=
ince it
> +        * is a different radix tree. What Linux would like is something =
like
> +        * ASET for the STE to disable BTM only for the S2.
> +        *
> +        * Arguably in a system with BTM the driver should prefer to use =
a S1
> +        * table in all cases execpt when explicitly asked to create a ne=
sting
> +        * parent. Then it should use the VMID of KVM to enable BTM in th=
e
> +        * guest. We cannot optimize away the resulting double invalidati=
on of
> +        * the S2 :( Or we simply ignore BTM entirely as we are doing now=
.
> +        */
> +       if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
> +               return xa_alloc(&smmu->asid_map, &smmu_domain->cd.asid,
> +                               smmu_domain,
> +                               XA_LIMIT(1, (1 << smmu->asid_bits) - 1),
> +                               GFP_KERNEL);
> +
> +       /* At this point the caller ensures we have a mmget() */
> +       smmu_domain->cd.asid =3D arm64_mm_context_get(mm);
> +
> +       mutex_lock(&smmu->asid_lock);
> +       old_s1_domain =3D xa_store(&smmu->asid_map, smmu_domain->cd.asid,
> +                                smmu_domain, GFP_KERNEL);
> +       if (xa_err(old_s1_domain)) {
> +               ret =3D xa_err(old_s1_domain);
> +               goto out_put_asid;
> +       }
> +
> +       /*
> +        * In BTM mode the CPU ASID and the IOMMU ASID have to be the sam=
e.
> +        * Unfortunately we run separate allocators for this and the IOMM=
U
> +        * ASID can already have been assigned to a S1 domain. SVA domain=
s
> +        * always align to their CPU ASIDs. In this case we change
> +        * the S1 domain's ASID, update the CD entry and flush the caches=
.
> +        *
> +        * This is a bit tricky, all the places writing to a S1 CD, readi=
ng the
> +        * S1 ASID, or doing xa_erase must hold the asid_lock or xa_lock =
to
> +        * avoid IOTLB incoherence.
> +        */
> +       if (old_s1_domain) {
> +               if (WARN_ON(old_s1_domain->domain.type =3D=3D IOMMU_DOMAI=
N_SVA)) {
> +                       ret =3D -EINVAL;
> +                       goto out_restore_s1;
> +               }
> +               ret =3D arm_smmu_realloc_s1_domain_asid(smmu, old_s1_doma=
in);
> +               if (ret)
> +                       goto out_restore_s1;
> +       }
> +
> +       smmu_domain->btm_invalidation =3D true;
> +
> +       ret =3D 0;
> +       goto out_unlock;
> +
> +out_restore_s1:
> +       xa_store(&smmu->asid_map, smmu_domain->cd.asid, old_s1_domain,
> +                GFP_KERNEL);
> +out_put_asid:
> +       arm64_mm_context_put(mm);
> +out_unlock:
> +       mutex_unlock(&smmu->asid_lock);
> +       return ret;
> +}
> +
>  struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
>                                                struct mm_struct *mm)
>  {
>         struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
>         struct arm_smmu_device *smmu =3D master->smmu;
>         struct arm_smmu_domain *smmu_domain;
> -       u32 asid;
>         int ret;
>
>         smmu_domain =3D arm_smmu_domain_alloc();
> @@ -418,12 +531,10 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(stru=
ct device *dev,
>         smmu_domain->domain.ops =3D &arm_smmu_sva_domain_ops;
>         smmu_domain->smmu =3D smmu;
>
> -       ret =3D xa_alloc(&smmu->asid_map, &asid, smmu_domain,
> -                      XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNE=
L);
> +       ret =3D arm_smmu_share_asid(smmu, smmu_domain, mm);
>         if (ret)
>                 goto err_free;
>
> -       smmu_domain->cd.asid =3D asid;
>         smmu_domain->mmu_notifier.ops =3D &arm_smmu_mmu_notifier_ops;
>         ret =3D mmu_notifier_register(&smmu_domain->mmu_notifier, mm);
>         if (ret)
> @@ -433,6 +544,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct=
 device *dev,
>
>  err_asid:
>         arm_smmu_domain_free_id(smmu_domain);
> +       if (smmu_domain->btm_invalidation)
> +               arm64_mm_context_put(mm);
>  err_free:
>         kfree(smmu_domain);
>         return ERR_PTR(ret);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 1a72dd63e0ca14..01737a0fc82828 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1314,6 +1314,8 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target=
,
>         typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =3D
>                 &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
>
> +       lockdep_assert_held(&master->smmu->asid_lock);
> +
>         memset(target, 0, sizeof(*target));
>
>         target->data[0] =3D cpu_to_le64(
> @@ -2089,7 +2091,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>          * careful, 007.
>          */
>         if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
> -               arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
> +               arm_smmu_tlb_inv_asid(smmu, READ_ONCE(smmu_domain->cd.asi=
d));
>         } else {
>                 cmd.opcode      =3D CMDQ_OP_TLBI_S12_VMALL;
>                 cmd.tlbi.vmid   =3D smmu_domain->s2_cfg.vmid;
> @@ -2334,17 +2336,10 @@ static void arm_smmu_domain_free(struct iommu_dom=
ain *domain)
>  static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
>                                        struct arm_smmu_domain *smmu_domai=
n)
>  {
> -       int ret;
> -       u32 asid;
>         struct arm_smmu_ctx_desc *cd =3D &smmu_domain->cd;
>
> -       /* Prevent SVA from modifying the ASID until it is written to the=
 CD */
> -       mutex_lock(&smmu->asid_lock);
> -       ret =3D xa_alloc(&smmu->asid_map, &asid, smmu_domain,
> -                      XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNE=
L);
> -       cd->asid        =3D (u16)asid;
> -       mutex_unlock(&smmu->asid_lock);
> -       return ret;
> +       return xa_alloc(&smmu->asid_map, &cd->asid, smmu_domain,
> +                       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERN=
EL);
>  }
>
>  static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index 6becdbae905598..a23593f1830106 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -586,7 +586,7 @@ struct arm_smmu_strtab_l1_desc {
>  };
>
>  struct arm_smmu_ctx_desc {
> -       u16                             asid;
> +       u32                             asid;
>  };
>
>  struct arm_smmu_l1_ctx_desc {
> --
> 2.43.2
>
