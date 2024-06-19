Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCDE40879
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 10:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718792496; cv=none; b=qdPlYG+lmM2Q/8i7aOBUmkaudBg2Daq6v9VV8bnNHZN7xD+3jxn35PLzUgnAefcDiD/3uT24g+LImc8c3+4UrdWE/47m80iDn0JSL7AxpgV8zvfnaHE2K1qN6NZ6Jxu6JLtWRoRh2p4ezV5kSKM1c0jYhZR6yU11AqOeuXUmAdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718792496; c=relaxed/simple;
	bh=jNhwQToM/rB10NA9YYKkQ5oeLQ7H9IENBXylesCDr/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AMuptkgCAOir/IC2QvRg7JmjMrZUL0MQt7v/DL13HAPKDJlGlz7VYEr7iOe/8ccXXXc8oGYhI4uQeWp7KbrsdMLaGxSguxJSV5t1Ffjuj0dMyuenFBmlOQc0BGYsdjr1EW5Eswrb3m1X9CNFPKpbtiSdPb2bYrl6f7U+LA9ZQFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3TONN3mp; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3TONN3mp"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-44056f72257so296291cf.0
        for <patches@lists.linux.dev>; Wed, 19 Jun 2024 03:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718792493; x=1719397293; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HV25he0H2rOGmnivlV05dJ3C0n5+wazULH63FlqMS4c=;
        b=3TONN3mpWEAfqanKlxgx1q2gTXqxp9HObdTX+zyJskSrLs+QFioXIsKhZSXY2JT4mY
         dugUAbwr203Mg6nw/flpTi6VzDQSOBIestgTE48I5ldVeF5+Z/0DKK6DeaCdELzTJ1Le
         U3czfVLA9KpbULjdmWpuuZDaITV7uFbl/nqZ2rtYj43Q/21xSrbzCuN+PI/CDgMbxgCW
         7beKhejHobClnSPgPHCG28mQHzGtlIvSnaOnto+ND5ZnG+zu37qYs6uPu4pMbdLHFgxn
         xPHMXbedyCt/dw7AlsgizZlc2ti35FGSHUiw+6tzBRzNbVTIKWglFlA7WL4uC1JrdyUs
         5nCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718792493; x=1719397293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HV25he0H2rOGmnivlV05dJ3C0n5+wazULH63FlqMS4c=;
        b=jzFEP4d7/44JDtPlIVI1/d42WC70jph2vr1oB9vxodudTI2+Z8PAle6u2zyCdvmMYE
         8v2DVlExOQKy/MTwDoFF8UDLU8/w+0JPSniSOWDMH6By2n01Y29LUKJvYshr+u7yGq00
         5Kpza3L7YP3sU5WlYK7QKIFRsEnbUdlxiMpb+VmAigZx6n6+PveWuVyXP2b6nye22iD0
         sQxAjL7afhZYG3X9NbZZizzHm4nDfI/4VZdrlfDQl9bZeRxwzqwbfCmveYG4bZy6pUlj
         cWuFrvEw8WzJWLgwm81euYREIh5uD7T9TbGSMYm42MmogLp4rp/rFyhcgT8uuPfuB1iB
         nO/g==
X-Forwarded-Encrypted: i=1; AJvYcCVdYEJoVPY36d6dVr7Vg5cWYXm7kfNJLxZesrsaW0nIrVKzWpq8biKLs1i/kh/3xlUfk7FWrWPAxOYvWMcvCyfgbATdYhdHpw==
X-Gm-Message-State: AOJu0YyleU2d03PnNWAGTKA9Q19rdCce5dFw08JyJysRF6KyWXSa4S6D
	2HCaXxuPN3QNd+CThgrNZKnvt9952u1sIx8FMwSIxnLlpMir4Q2IyZ39XbUFUPq5k2n+QCztJvT
	BVQ1Hw7buvGy80sx9aOdQbDH/oZGwcH/BZCJN
X-Google-Smtp-Source: AGHT+IGzl7+xDJXyXQ9zBrDyYFN/PgFARybkM4iZ9UhaUHf2t/VdCiRlyjzut+eExwGPl6K3YBI/4vCNcNPpErz5ht4=
X-Received: by 2002:ac8:5fd2:0:b0:444:92a6:188a with SMTP id
 d75a77b69052e-444aa406a89mr2413281cf.9.1718792492804; Wed, 19 Jun 2024
 03:21:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com> <4-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <4-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Wed, 19 Jun 2024 18:20:56 +0800
Message-ID: <CAKHBV24ANjwSF=YpzxdtOR32N2y8v+Phh5jbxxmw-tLopV2Lyw@mail.gmail.com>
Subject: Re: [PATCH v8 04/14] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 4, 2024 at 8:16=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> The core code allows the domain to be changed on the fly without a forced
> stop in BLOCKED/IDENTITY. In this flow the driver should just continually
> maintain the ATS with no change while the STE is updated.
>
> ATS relies on a linked list smmu_domain->devices to keep track of which
> masters have the domain programmed, but this list is also used by
> arm_smmu_share_asid(), unrelated to ats.
>
> Create two new functions to encapsulate this combined logic:
>  arm_smmu_attach_prepare()
>  <caller generates and sets the STE>
>  arm_smmu_attach_commit()
>
> The two functions can sequence both enabling ATS and disabling across
> the STE store. Have every update of the STE use this sequence.
>
> Installing a S1/S2 domain always enables the ATS if the PCIe device
> supports it.
>
> The enable flow is now ordered differently to allow it to be hitless:
>
>  1) Add the master to the new smmu_domain->devices list
>  2) Program the STE
>  3) Enable ATS at PCIe
>  4) Remove the master from the old smmu_domain
>
> This flow ensures that invalidations to either domain will generate an AT=
C
> invalidation to the device while the STE is being switched. Thus we don't
> need to turn off the ATS anymore for correctness.
>
> The disable flow is the reverse:
>  1) Disable ATS at PCIe
>  2) Program the STE
>  3) Invalidate the ATC
>  4) Remove the master from the old smmu_domain
>
> Move the nr_ats_masters adjustments to be close to the list
> manipulations. It is a count of the number of ATS enabled masters
> currently in the list. This is stricly before and after the STE/CD are
> revised, and done under the list's spin_lock.
>
> This is part of the bigger picture to allow changing the RID domain while
> a PASID is in use. If a SVA PASID is relying on ATS to function then
> changing the RID domain cannot just temporarily toggle ATS off without
> also wrecking the SVA PASID. The new infrastructure here is organized so
> that the PASID attach/detach flows will make use of it as well in
> following patches.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   5 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 238 +++++++++++++-----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   6 +-
>  3 files changed, 178 insertions(+), 71 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/i=
ommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> index 315e487fd990eb..a460b71f585789 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> @@ -164,7 +164,7 @@ static void arm_smmu_test_make_cdtable_ste(struct arm=
_smmu_ste *ste,
>                 .smmu =3D &smmu,
>         };
>
> -       arm_smmu_make_cdtable_ste(ste, &master);
> +       arm_smmu_make_cdtable_ste(ste, &master, true);
>  }
>
>  static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *tes=
t)
> @@ -231,7 +231,6 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu=
_ste *ste,
>  {
>         struct arm_smmu_master master =3D {
>                 .smmu =3D &smmu,
> -               .ats_enabled =3D ats_enabled,
>         };
>         struct io_pgtable io_pgtable =3D {};
>         struct arm_smmu_domain smmu_domain =3D {
> @@ -247,7 +246,7 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu=
_ste *ste,
>         io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl =3D 3;
>         io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz =3D 4;
>
> -       arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain);
> +       arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, ats_enabl=
ed);
>  }
>
>  static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 532fe17f28bfe5..24f42ff39f77a9 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1538,7 +1538,7 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_bypass_ste);
>
>  VISIBLE_IF_KUNIT
>  void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> -                              struct arm_smmu_master *master)
> +                              struct arm_smmu_master *master, bool ats_e=
nabled)
>  {
>         struct arm_smmu_ctx_desc_cfg *cd_table =3D &master->cd_table;
>         struct arm_smmu_device *smmu =3D master->smmu;
> @@ -1561,7 +1561,7 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste =
*target,
>                          STRTAB_STE_1_S1STALLD :
>                          0) |
>                 FIELD_PREP(STRTAB_STE_1_EATS,
> -                          master->ats_enabled ? STRTAB_STE_1_EATS_TRANS =
: 0));
> +                          ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
>
>         if (smmu->features & ARM_SMMU_FEAT_E2H) {
>                 /*
> @@ -1591,7 +1591,8 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_cdtable_ste);
>  VISIBLE_IF_KUNIT
>  void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>                                  struct arm_smmu_master *master,
> -                                struct arm_smmu_domain *smmu_domain)
> +                                struct arm_smmu_domain *smmu_domain,
> +                                bool ats_enabled)
>  {
>         struct arm_smmu_s2_cfg *s2_cfg =3D &smmu_domain->s2_cfg;
>         const struct io_pgtable_cfg *pgtbl_cfg =3D
> @@ -1608,7 +1609,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_st=
e *target,
>
>         target->data[1] =3D cpu_to_le64(
>                 FIELD_PREP(STRTAB_STE_1_EATS,
> -                          master->ats_enabled ? STRTAB_STE_1_EATS_TRANS =
: 0));
> +                          ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
>
>         if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
>                 target->data[1] |=3D cpu_to_le64(FIELD_PREP(STRTAB_STE_1_=
SHCFG,
> @@ -2450,22 +2451,16 @@ static bool arm_smmu_ats_supported(struct arm_smm=
u_master *master)
>         return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
>  }
>
> -static void arm_smmu_enable_ats(struct arm_smmu_master *master,
> -                               struct arm_smmu_domain *smmu_domain)
> +static void arm_smmu_enable_ats(struct arm_smmu_master *master)
>  {
>         size_t stu;
>         struct pci_dev *pdev;
>         struct arm_smmu_device *smmu =3D master->smmu;
>
> -       /* Don't enable ATS at the endpoint if it's not enabled in the ST=
E */
> -       if (!master->ats_enabled)
> -               return;
> -
>         /* Smallest Translation Unit: log2 of the smallest supported gran=
ule */
>         stu =3D __ffs(smmu->pgsize_bitmap);
>         pdev =3D to_pci_dev(master->dev);
>
> -       atomic_inc(&smmu_domain->nr_ats_masters);
>         /*
>          * ATC invalidation of PASID 0 causes the entire ATC to be flushe=
d.
>          */
> @@ -2474,22 +2469,6 @@ static void arm_smmu_enable_ats(struct arm_smmu_ma=
ster *master,
>                 dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", =
stu);
>  }
>
> -static void arm_smmu_disable_ats(struct arm_smmu_master *master,
> -                                struct arm_smmu_domain *smmu_domain)
> -{
> -       if (!master->ats_enabled)
> -               return;
> -
> -       pci_disable_ats(to_pci_dev(master->dev));
> -       /*
> -        * Ensure ATS is disabled at the endpoint before we issue the
> -        * ATC invalidation via the SMMU.
> -        */
> -       wmb();
> -       arm_smmu_atc_inv_master(master);
> -       atomic_dec(&smmu_domain->nr_ats_masters);
> -}
> -
>  static int arm_smmu_enable_pasid(struct arm_smmu_master *master)
>  {
>         int ret;
> @@ -2553,46 +2532,182 @@ arm_smmu_find_master_domain(struct arm_smmu_doma=
in *smmu_domain,
>         return NULL;
>  }
>
> -static void arm_smmu_detach_dev(struct arm_smmu_master *master)
> +/*
> + * If the domain uses the smmu_domain->devices list return the arm_smmu_=
domain
> + * structure, otherwise NULL. These domains track attached devices so th=
ey can
> + * issue invalidations.
> + */
> +static struct arm_smmu_domain *
> +to_smmu_domain_devices(struct iommu_domain *domain)
>  {
> -       struct iommu_domain *domain =3D iommu_get_domain_for_dev(master->=
dev);
> +       /* The domain can be NULL only when processing the first attach *=
/
> +       if (!domain)
> +               return NULL;
> +       if (domain->type & __IOMMU_DOMAIN_PAGING)
> +               return to_smmu_domain(domain);
> +       return NULL;
> +}
> +
> +static void arm_smmu_remove_master_domain(struct arm_smmu_master *master=
,
> +                                         struct iommu_domain *domain)
> +{
> +       struct arm_smmu_domain *smmu_domain =3D to_smmu_domain_devices(do=
main);
>         struct arm_smmu_master_domain *master_domain;
> -       struct arm_smmu_domain *smmu_domain;
>         unsigned long flags;
>
> -       if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
> +       if (!smmu_domain)
>                 return;
>
> -       smmu_domain =3D to_smmu_domain(domain);
> -       arm_smmu_disable_ats(master, smmu_domain);
> -
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>         master_domain =3D arm_smmu_find_master_domain(smmu_domain, master=
);
>         if (master_domain) {
>                 list_del(&master_domain->devices_elm);
>                 kfree(master_domain);
> +               if (master->ats_enabled)
> +                       atomic_dec(&smmu_domain->nr_ats_masters);
>         }
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +}
>
> -       master->ats_enabled =3D false;
> +struct arm_smmu_attach_state {
> +       /* Inputs */
> +       struct iommu_domain *old_domain;
> +       struct arm_smmu_master *master;
> +       /* Resulting state */
> +       bool ats_enabled;
> +};
> +
> +/*
> + * Start the sequence to attach a domain to a master. The sequence conta=
ins three
> + * steps:
> + *  arm_smmu_attach_prepare()
> + *  arm_smmu_install_ste_for_dev()
> + *  arm_smmu_attach_commit()
> + *
> + * If prepare succeeds then the sequence must be completed. The STE inst=
alled
> + * must set the STE.EATS field according to state.ats_enabled.
> + *
> + * ATS is automatically enabled if the underlying device supports it.
> + * disable_ats can inhibit this to support STEs like bypass that don't a=
llow
> + * ATS.

This comment is out of date since disable_ats was removed between v7 and v8=
.
A nit, but "automatically" is also a little imprecise IMO (almost
sounds like the device is automatically enabling it). How about:

+ * ATS is enabled after the STE is installed if the new domain and
underlying device
+ * supports it. On the other hand, ATS is disabled before installing
the STE if it doesn't
+ * support ATS like bypass domains.

Or something else if that's too redundant with the next paragraph :) .

> + *
> + * The change of the EATS in the STE and the PCI ATS config space is man=
aged by
> + * this sequence to be in the right order such that if PCI ATS is enable=
d then
> + * STE.ETAS is enabled.
> + *
> + * new_domain can be NULL if the domain being attached does not have a p=
age
> + * table and does not require invalidation tracking, and does not suppor=
t ATS.
> + */

This is also confusing, new_domain is never NULL. It's
to_smmu_domain_devices(new_domain) that can be null.


> +static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
> +                                  struct iommu_domain *new_domain)
> +{
> +       struct arm_smmu_master *master =3D state->master;
> +       struct arm_smmu_master_domain *master_domain;
> +       struct arm_smmu_domain *smmu_domain =3D
> +               to_smmu_domain_devices(new_domain);
> +       unsigned long flags;
> +
> +       /*
> +        * arm_smmu_share_asid() must not see two domains pointing to the=
 same
> +        * arm_smmu_master_domain contents otherwise it could randomly wr=
ite one
> +        * or the other to the CD.
> +        */
> +       lockdep_assert_held(&arm_smmu_asid_lock);
> +
> +       if (smmu_domain) {
> +               /*
> +                * The SMMU does not support enabling ATS with bypass/abo=
rt.
> +                * When the STE is in bypass (STE.Config[2:0] =3D=3D 0b10=
0), ATS
> +                * Translation Requests and Translated transactions are d=
enied
> +                * as though ATS is disabled for the stream (STE.EATS =3D=
=3D 0b00),
> +                * causing F_BAD_ATS_TREQ and F_TRANSL_FORBIDDEN events
> +                * (IHI0070Ea 5.2 Stream Table Entry). Thus ATS can only =
be
> +                * enabled if we have arm_smmu_domain, those always have =
page
> +                * tables.
> +                */
> +               state->ats_enabled =3D arm_smmu_ats_supported(master);
> +
> +               master_domain =3D kzalloc(sizeof(*master_domain), GFP_KER=
NEL);
> +               if (!master_domain)
> +                       return -ENOMEM;
> +               master_domain->master =3D master;
> +
> +               /*
> +                * During prepare we want the current smmu_domain and new
> +                * smmu_domain to be in the devices list before we change=
 any
> +                * HW. This ensures that both domains will send ATS
> +                * invalidations to the master until we are done.
> +                *
> +                * It is tempting to make this list only track masters th=
at are
> +                * using ATS, but arm_smmu_share_asid() also uses this to=
 change
> +                * the ASID of a domain, unrelated to ATS.
> +                *
> +                * Notice if we are re-attaching the same domain then the=
 list
> +                * will have two identical entries and commit will remove=
 only
> +                * one of them.
> +                */
> +               spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> +               if (state->ats_enabled)
> +                       atomic_inc(&smmu_domain->nr_ats_masters);
> +               list_add(&master_domain->devices_elm, &smmu_domain->devic=
es);
> +               spin_unlock_irqrestore(&smmu_domain->devices_lock, flags)=
;
> +       }
> +
> +       if (!state->ats_enabled && master->ats_enabled) {
> +               pci_disable_ats(to_pci_dev(master->dev));
> +               /*
> +                * This is probably overkill, but the config write for di=
sabling
> +                * ATS should complete before the STE is configured to ge=
nerate
> +                * UR to avoid AER noise.
> +                */
> +               wmb();
> +       }
> +       return 0;
> +}
> +
> +/*
> + * Commit is done after the STE/CD are configured with the EATS setting.=
 It
> + * completes synchronizing the PCI device's ATC and finishes manipulatin=
g the
> + * smmu_domain->devices list.
> + */
> +static void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
> +{
> +       struct arm_smmu_master *master =3D state->master;
> +
> +       lockdep_assert_held(&arm_smmu_asid_lock);
> +
> +       if (state->ats_enabled && !master->ats_enabled) {
> +               arm_smmu_enable_ats(master);
> +       } else if (master->ats_enabled) {
> +               /*
> +                * The translation has changed, flush the ATC. At this po=
int the
> +                * SMMU is translating for the new domain and both the ol=
d&new
> +                * domain will issue invalidations.
> +                */
> +               arm_smmu_atc_inv_master(master);
> +       }
> +       master->ats_enabled =3D state->ats_enabled;
> +
> +       arm_smmu_remove_master_domain(master, state->old_domain);
>  }
>
>  static int arm_smmu_attach_dev(struct iommu_domain *domain, struct devic=
e *dev)
>  {
>         int ret =3D 0;
> -       unsigned long flags;
>         struct arm_smmu_ste target;
>         struct iommu_fwspec *fwspec =3D dev_iommu_fwspec_get(dev);
>         struct arm_smmu_device *smmu;
>         struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
> -       struct arm_smmu_master_domain *master_domain;
> +       struct arm_smmu_attach_state state =3D {
> +               .old_domain =3D iommu_get_domain_for_dev(dev),
> +       };
>         struct arm_smmu_master *master;
>         struct arm_smmu_cd *cdptr;
>
>         if (!fwspec)
>                 return -ENOENT;
>
> -       master =3D dev_iommu_priv_get(dev);
> +       state.master =3D master =3D dev_iommu_priv_get(dev);
>         smmu =3D master->smmu;
>
>         /*
> @@ -2622,11 +2737,6 @@ static int arm_smmu_attach_dev(struct iommu_domain=
 *domain, struct device *dev)
>                         return -ENOMEM;
>         }
>
> -       master_domain =3D kzalloc(sizeof(*master_domain), GFP_KERNEL);
> -       if (!master_domain)
> -               return -ENOMEM;
> -       master_domain->master =3D master;
> -
>         /*
>          * Prevent arm_smmu_share_asid() from trying to change the ASID
>          * of either the old or new domain while we are working on it.
> @@ -2635,13 +2745,11 @@ static int arm_smmu_attach_dev(struct iommu_domai=
n *domain, struct device *dev)
>          */
>         mutex_lock(&arm_smmu_asid_lock);
>
> -       arm_smmu_detach_dev(master);
> -
> -       master->ats_enabled =3D arm_smmu_ats_supported(master);
> -
> -       spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -       list_add(&master_domain->devices_elm, &smmu_domain->devices);
> -       spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +       ret =3D arm_smmu_attach_prepare(&state, domain);
> +       if (ret) {
> +               mutex_unlock(&arm_smmu_asid_lock);
> +               return ret;
> +       }
>
>         switch (smmu_domain->stage) {
>         case ARM_SMMU_DOMAIN_S1: {
> @@ -2650,18 +2758,19 @@ static int arm_smmu_attach_dev(struct iommu_domai=
n *domain, struct device *dev)
>                 arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
>                 arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
>                                         &target_cd);
> -               arm_smmu_make_cdtable_ste(&target, master);
> +               arm_smmu_make_cdtable_ste(&target, master, state.ats_enab=
led);
>                 arm_smmu_install_ste_for_dev(master, &target);
>                 break;
>         }
>         case ARM_SMMU_DOMAIN_S2:
> -               arm_smmu_make_s2_domain_ste(&target, master, smmu_domain)=
;
> +               arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
> +                                           state.ats_enabled);
>                 arm_smmu_install_ste_for_dev(master, &target);
>                 arm_smmu_clear_cd(master, IOMMU_NO_PASID);
>                 break;
>         }
>
> -       arm_smmu_enable_ats(master, smmu_domain);
> +       arm_smmu_attach_commit(&state);
>         mutex_unlock(&arm_smmu_asid_lock);
>         return 0;
>  }
> @@ -2690,10 +2799,14 @@ void arm_smmu_remove_pasid(struct arm_smmu_master=
 *master,
>         arm_smmu_clear_cd(master, pasid);
>  }
>
> -static int arm_smmu_attach_dev_ste(struct device *dev,
> -                                  struct arm_smmu_ste *ste)
> +static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
> +                                  struct device *dev, struct arm_smmu_st=
e *ste)
>  {
>         struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> +       struct arm_smmu_attach_state state =3D {
> +               .master =3D master,
> +               .old_domain =3D iommu_get_domain_for_dev(dev),
> +       };
>
>         if (arm_smmu_master_sva_enabled(master))
>                 return -EBUSY;
> @@ -2704,16 +2817,9 @@ static int arm_smmu_attach_dev_ste(struct device *=
dev,
>          */
>         mutex_lock(&arm_smmu_asid_lock);
>
> -       /*
> -        * The SMMU does not support enabling ATS with bypass/abort. When=
 the
> -        * STE is in bypass (STE.Config[2:0] =3D=3D 0b100), ATS Translati=
on Requests
> -        * and Translated transactions are denied as though ATS is disabl=
ed for
> -        * the stream (STE.EATS =3D=3D 0b00), causing F_BAD_ATS_TREQ and
> -        * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
> -        */
> -       arm_smmu_detach_dev(master);
> -
> +       arm_smmu_attach_prepare(&state, domain);
>         arm_smmu_install_ste_for_dev(master, ste);
> +       arm_smmu_attach_commit(&state);
>         mutex_unlock(&arm_smmu_asid_lock);
>
>         /*
> @@ -2732,7 +2838,7 @@ static int arm_smmu_attach_dev_identity(struct iomm=
u_domain *domain,
>         struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
>
>         arm_smmu_make_bypass_ste(master->smmu, &ste);
> -       return arm_smmu_attach_dev_ste(dev, &ste);
> +       return arm_smmu_attach_dev_ste(domain, dev, &ste);
>  }
>
>  static const struct iommu_domain_ops arm_smmu_identity_ops =3D {
> @@ -2750,7 +2856,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu=
_domain *domain,
>         struct arm_smmu_ste ste;
>
>         arm_smmu_make_abort_ste(&ste);
> -       return arm_smmu_attach_dev_ste(dev, &ste);
> +       return arm_smmu_attach_dev_ste(domain, dev, &ste);
>  }
>
>  static const struct iommu_domain_ops arm_smmu_blocked_ops =3D {
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index 01769b5286a83a..f9b4bfb2e6b723 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -758,10 +758,12 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *t=
arget);
>  void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
>                               struct arm_smmu_ste *target);
>  void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> -                              struct arm_smmu_master *master);
> +                              struct arm_smmu_master *master,
> +                              bool ats_enabled);
>  void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>                                  struct arm_smmu_master *master,
> -                                struct arm_smmu_domain *smmu_domain);
> +                                struct arm_smmu_domain *smmu_domain,
> +                                bool ats_enabled);
>  void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
>                           struct arm_smmu_master *master, struct mm_struc=
t *mm,
>                           u16 asid);
> --
> 2.45.2
>

Reviewed-by: Michael Shavit <mshavit@google.com>
