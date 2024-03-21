Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70370757F7
	for <patches@lists.linux.dev>; Thu, 21 Mar 2024 12:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711024045; cv=none; b=Kr+1TRLi3w/yQeOWyEkI+itFcFzTqHWsTL+H7GmKFJ5r9+g7d/wkVFdiCEIatJTpc6O4bwBNw/KeaMmDtQdZcY7UFcx23bHtH0mdBHq2PAkkGNDTSxOBOacBbjIq/DIbqtdXA+Yj1rRFD+/qupa54Ppp5/DjkPJtcKtsFNEvfq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711024045; c=relaxed/simple;
	bh=hWtvnOlvd1FQc2W6IvCooZnO0DRpSjeAuLOaw74zKyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eninEabZf4PCMxRNFIwHAiav2XUv+Nl/IvKfBUwEJjhwE2LHxEKZmpqUs+LFKhwqIMgmW4Hw3vQSxLJT1IWtNoNeUDxBdUUPuut1/lW4Vf2wJsyOanmpSYm2xTm2paydjhpbERQVITvNg0acm6qRzr1jq6nw+XqVFcwC4D083Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YXLKGstq; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YXLKGstq"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-428405a0205so265701cf.1
        for <patches@lists.linux.dev>; Thu, 21 Mar 2024 05:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711024042; x=1711628842; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bp3Ucnr4Xw7XoX2DZ6/e8KgdNiT0bH6dYM7rQrlas2M=;
        b=YXLKGstqC1I54iqEXuqAxHBQw6rGsReOe1iK1eoz4m2zeNm2eG2s65HV5YcAc1rJGo
         ZDUedhvqGX8FPqm4oI78RaINuZVXYnAGXXMK3O1IMYd+vTIW0rcj4hbkRRN1nMFrJa+X
         zwua6nJWAhdSg/gF9k7UiUPbjjcdeemMzjVFOJFDLN0vzhl4/iDZChUhh+MhOMHkPgL3
         N0BGSWRg3PlRS5dFITH0RTHAeRHOKrsEHxAbRx/QxiyH1HHDoiplQcP4NzORsMcLU/rY
         g0haiEvl0OyfmAdNsdTGGpMjkNZMHBfb1vq/BnC/AeKc/3+ZCnLKATAYDB+8zp2dc8aU
         EPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711024042; x=1711628842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bp3Ucnr4Xw7XoX2DZ6/e8KgdNiT0bH6dYM7rQrlas2M=;
        b=aUy+SrX4QcRWGuNMTQDlvPm0CpyIsuHOS6DoGO0YaXmHYbVLeyzmWrR66duiJ2tc35
         tIj04Amoz7rBP2KsEt9/r+3Tgx3miel4kNSQBO4cxYLPTatKv/ECW1l6Qpjg5y1wTURH
         4gm2WA+2ZcA489/asJTejICVM6moIwYb2Q2bIZ+urp/gSYbEd1gFeMHuRKhoui1ml1qf
         Sg1QeRTFOZxgI5qtEKoms8oh1WaxDGyWd/MjVkVYTUGl4LsxtEGYMwygP/rIsWLUSO6L
         WqYjOqlnm9tsZ64MfU6adHlv7ipIdlgWofRau+PrRAeCfmURFcgbvbeQ8bUFDjbwqZVB
         GUFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeC1p3H+6un7ikLBsAFaGaB2Hb3bI0ysAKltzmmNL+azssj0HvAUJd6pqinIJ4qgGgF2ppy2VkhQbA+4guQ1kkswQG0pcCJw==
X-Gm-Message-State: AOJu0YzdEMgHsApBc/E9YWlWu1FBvd2RSKXD8jM7Xlrw45Fg1KyTr0Ym
	1YfOb6xum9XrBRvddc4Br98PxFeKDjQKNWeWVD8halvgkPT+k1ATdCIqy2zUiPX2wB4KgoKLKBZ
	yvtGkKU9WSxKK4zucGIQNEyEt1xVpnGyJ5cdi
X-Google-Smtp-Source: AGHT+IHLaL/MKMUzCY9Q43gkWlDa5G8D/GFMEdZBtxL80/dMioSZNq8aCkJJZEGH2Be5BbkbxXlSuAbyGy71dhEV8e0=
X-Received: by 2002:ac8:5ad4:0:b0:431:2a26:2121 with SMTP id
 d20-20020ac85ad4000000b004312a262121mr8064qtd.25.1711024042130; Thu, 21 Mar
 2024 05:27:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <14-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <14-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Thu, 21 Mar 2024 20:26:43 +0800
Message-ID: <CAKHBV25xx51EuDXK91-o9BnFq5TZ66TAPuZ4YEdJ1UPq8sr7ZQ@mail.gmail.com>
Subject: Re: [PATCH v5 14/27] iommu/arm-smmu-v3: Make changing domains be
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

On Tue, Mar 5, 2024 at 7:44=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
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
>   1) Add the master to the new smmu_domain->devices list
>   2) Program the STE
>   3) Enable ATS at PCIe
>   4) Remove the master from the old smmu_domain
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
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 198 ++++++++++++++------
>  1 file changed, 140 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 51a1e7198fd1af..45f2190fc31786 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1527,7 +1527,8 @@ static void arm_smmu_make_bypass_ste(struct arm_smm=
u_ste *target)
>  }
>
>  static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> -                                     struct arm_smmu_master *master)
> +                                     struct arm_smmu_master *master,
> +                                     bool ats_enabled)
>  {
>         struct arm_smmu_ctx_desc_cfg *cd_table =3D &master->cd_table;
>         struct arm_smmu_device *smmu =3D master->smmu;
> @@ -1550,7 +1551,7 @@ static void arm_smmu_make_cdtable_ste(struct arm_sm=
mu_ste *target,
>                          STRTAB_STE_1_S1STALLD :
>                          0) |
>                 FIELD_PREP(STRTAB_STE_1_EATS,
> -                          master->ats_enabled ? STRTAB_STE_1_EATS_TRANS =
: 0));
> +                          ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
>
>         if (smmu->features & ARM_SMMU_FEAT_E2H) {
>                 /*
> @@ -1578,7 +1579,8 @@ static void arm_smmu_make_cdtable_ste(struct arm_sm=
mu_ste *target,
>
>  static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>                                         struct arm_smmu_master *master,
> -                                       struct arm_smmu_domain *smmu_doma=
in)
> +                                       struct arm_smmu_domain *smmu_doma=
in,
> +                                       bool ats_enabled)
>  {
>         struct arm_smmu_s2_cfg *s2_cfg =3D &smmu_domain->s2_cfg;
>         const struct io_pgtable_cfg *pgtbl_cfg =3D
> @@ -1594,7 +1596,7 @@ static void arm_smmu_make_s2_domain_ste(struct arm_=
smmu_ste *target,
>
>         target->data[1] =3D cpu_to_le64(
>                 FIELD_PREP(STRTAB_STE_1_EATS,
> -                          master->ats_enabled ? STRTAB_STE_1_EATS_TRANS =
: 0) |
> +                          ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
>                 FIELD_PREP(STRTAB_STE_1_SHCFG,
>                            STRTAB_STE_1_SHCFG_INCOMING));
>
> @@ -2470,22 +2472,16 @@ static bool arm_smmu_ats_supported(struct arm_smm=
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
> @@ -2494,22 +2490,6 @@ static void arm_smmu_enable_ats(struct arm_smmu_ma=
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
> @@ -2573,39 +2553,145 @@ arm_smmu_find_master_domain(struct arm_smmu_doma=
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
> +struct attach_state {
> +       bool want_ats;
> +       bool disable_ats;
> +};
> +
> +/*
> + * Prepare to attach a domain to a master. If disable_ats is not set thi=
s will
> + * turn on ATS if supported. smmu_domain can be NULL if the domain being
> + * attached does not have a page table and does not require invalidation
> + * tracking.
> + */
> +static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
> +                                  struct iommu_domain *domain,
> +                                  struct attach_state *state)
> +{
> +       struct arm_smmu_domain *smmu_domain =3D
> +               to_smmu_domain_devices(domain);
> +       struct arm_smmu_master_domain *master_domain;
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
> +       state->want_ats =3D !state->disable_ats && arm_smmu_ats_supported=
(master);
> +
> +       if (smmu_domain) {
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
> +               if (state->want_ats)
> +                       atomic_inc(&smmu_domain->nr_ats_masters);
> +               list_add(&master_domain->devices_elm, &smmu_domain->devic=
es);
> +               spin_unlock_irqrestore(&smmu_domain->devices_lock, flags)=
;
> +       }
> +
> +       if (!state->want_ats && master->ats_enabled) {
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
> +static void arm_smmu_attach_commit(struct arm_smmu_master *master,
> +                                  struct attach_state *state)
> +{
> +       lockdep_assert_held(&arm_smmu_asid_lock);
> +
> +       if (state->want_ats && !master->ats_enabled) {
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
> +       master->ats_enabled =3D state->want_ats;
> +
> +       arm_smmu_remove_master_domain(master,
> +                                     iommu_get_domain_for_dev(master->de=
v));
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
> +       struct attach_state state =3D {};
>         struct arm_smmu_master *master;
>         struct arm_smmu_cd *cdptr;
>
> @@ -2642,11 +2728,6 @@ static int arm_smmu_attach_dev(struct iommu_domain=
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
> @@ -2655,13 +2736,11 @@ static int arm_smmu_attach_dev(struct iommu_domai=
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
> +       ret =3D arm_smmu_attach_prepare(master, domain, &state);
> +       if (ret) {
> +               mutex_unlock(&arm_smmu_asid_lock);
> +               return ret;
> +       }
>
>         switch (smmu_domain->stage) {
>         case ARM_SMMU_DOMAIN_S1: {
> @@ -2670,18 +2749,19 @@ static int arm_smmu_attach_dev(struct iommu_domai=
n *domain, struct device *dev)
>                 arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
>                 arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
>                                         &target_cd);
> -               arm_smmu_make_cdtable_ste(&target, master);
> +               arm_smmu_make_cdtable_ste(&target, master, state.want_ats=
);
>                 arm_smmu_install_ste_for_dev(master, &target);
>                 break;
>         }
>         case ARM_SMMU_DOMAIN_S2:
> -               arm_smmu_make_s2_domain_ste(&target, master, smmu_domain)=
;
> +               arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
> +                                           state.want_ats);
>                 arm_smmu_install_ste_for_dev(master, &target);
>                 arm_smmu_clear_cd(master, IOMMU_NO_PASID);
>                 break;
>         }
>
> -       arm_smmu_enable_ats(master, smmu_domain);
> +       arm_smmu_attach_commit(master, &state);
>         mutex_unlock(&arm_smmu_asid_lock);
>         return 0;
>  }
> @@ -2715,10 +2795,11 @@ void arm_smmu_remove_pasid(struct arm_smmu_master=
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
> +       struct attach_state state =3D {};
>
>         if (arm_smmu_master_sva_enabled(master))
>                 return -EBUSY;
> @@ -2736,9 +2817,10 @@ static int arm_smmu_attach_dev_ste(struct device *=
dev,
>          * the stream (STE.EATS =3D=3D 0b00), causing F_BAD_ATS_TREQ and
>          * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
>          */
> -       arm_smmu_detach_dev(master);
> -
> +       state.disable_ats =3D true;
> +       arm_smmu_attach_prepare(master, domain, &state);
>         arm_smmu_install_ste_for_dev(master, ste);
> +       arm_smmu_attach_commit(master, &state);
>         mutex_unlock(&arm_smmu_asid_lock);
>
>         /*
> @@ -2756,7 +2838,7 @@ static int arm_smmu_attach_dev_identity(struct iomm=
u_domain *domain,
>         struct arm_smmu_ste ste;
>
>         arm_smmu_make_bypass_ste(&ste);
> -       return arm_smmu_attach_dev_ste(dev, &ste);
> +       return arm_smmu_attach_dev_ste(domain, dev, &ste);
>  }
>
>  static const struct iommu_domain_ops arm_smmu_identity_ops =3D {
> @@ -2774,7 +2856,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu=
_domain *domain,
>         struct arm_smmu_ste ste;
>
>         arm_smmu_make_abort_ste(&ste);
> -       return arm_smmu_attach_dev_ste(dev, &ste);
> +       return arm_smmu_attach_dev_ste(domain, dev, &ste);
>  }
>
>  static const struct iommu_domain_ops arm_smmu_blocked_ops =3D {
> --
> 2.43.2
>

Overall I think the patch works, but it took me a while to really
digest the big picture. Just to make sure I fully understand:

We're trying to satisfy the following invariants for correctness:
1. Devices cannot get translations from a domain that was detached
after arm_smmu_attach_dev() returns.
2. Devices cannot get cached translations from a domain after
arm_smmu_atc_inv_domain() returns, regardless of whether the domain is
simultaneously being attached/detached from a device.

Apart from note point 2. above, the behaviour of translations while in
the middle of an arm_smmu_attach_dev doesn't have well defined
requirements:
1. Before this patch, devices may get translations belonging to the
old domain, then aborts or identity translations, and then the new
domain while arm_smmu_attach_dev() is in progress.
2. Ater this patch, devices may get an arbitrary mix of translations
belonging to the old domain and the new domain while
arm_smmu_attach_dev() is in progress.

While disabling and re-enabling ATS inside arm_smmu_attach_dev() would
meet the same requirements as this patch, it's not optimal since the
device may still have traffic on other pasids than the one being
manipulated.
