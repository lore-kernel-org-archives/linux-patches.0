Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171FD134406
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 09:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719222925; cv=none; b=rURfxrrx2tCI+aQEMILSD6cwNmGg5eTkR/E/xS5ev25TDaPivwpabbrkpDZJTBYKTv9E7uXlzTYKcmqo9mlZZu6gSZ4v7xvKTMsZ6QmKs5aPZwAyaxdDk6TPrhlk3zIEbRbZTHOtQMWwlumTguNxG14tAzLx+8N+y/ElYYdGcBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719222925; c=relaxed/simple;
	bh=ootugsjxm3m15IKhSH3pDxWCiDDRJcLha77szeFcY6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dbNkTQMsPBLtfPR/+XeCj6F8yscHfY5SoQ+OgXYymEzcFANXoTDwGYg3evU4rzTNc/tlD+pPgIPDKevLXc0YtOwIFPw58F9EGnV0vHO1bXurqsGoRT7BCRZUdS0GTUraYDe19SjoL8uYodY1tlEv/cq/kUihDZ4U08ZyRAk/Zaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rix8Ufqm; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rix8Ufqm"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-44056f72257so979411cf.0
        for <patches@lists.linux.dev>; Mon, 24 Jun 2024 02:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719222921; x=1719827721; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Xks0RP/Gil3jwqDmzn+VRs4MPGLQVDwytj+rPU8QDs=;
        b=Rix8UfqmoCgIghLcIrXbDA/N+2zYH/4Hv+n7wjl1fLA0BDE1OQlumdcG6ObHSlpGkM
         7YtXjfFXiWu0aK5rn7+cxOCeMPuAcR4qSQOqL1zjJ6lFGpFITnw/6Q5cU3I46+vmO/fc
         5lyBqk13L0G/f1wozHz4YDMLSzfAqb/nvmvITtf7+RlNi0FAnH+0RpixNDNqbaTCIQij
         8j4u13ade71KKb7BeB8kOG/bS7wUffLcMLLWgQjdP+84bizMFIFSORPkO1RhWkydV1fz
         6IMwY1wMVujvajnRi37cSWtW6H5w9iEqirDCIUf4FGwOHY3HgcnhdWqFB6/o62JFqdOt
         cprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719222921; x=1719827721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Xks0RP/Gil3jwqDmzn+VRs4MPGLQVDwytj+rPU8QDs=;
        b=sPWdF7VtpSnpe5SmRgiH3p/X3gWgHW+w9jSmLmNdgSnSn2anFfTOJ6cg3IZ9rMmLqP
         l3etb/um3c72BvKeWhIhFYPDW1j7pACyQSrX4K3dd4W9frH8u1JC41JONQ8DnbYmQUuT
         eVfQKF9cPUs2I8kYGdPrd3Q3FDFbEQb7ROhFjpYEaH+dAlZ7//H76NEGjSkawOYYkP6H
         AFz15CdfhS73SNGkoy0iAcV/7pYBzTIvbTMW6Uo/8sEV/9aqdd69wxYn/omjw5TouQnx
         O9T8NNL0mHxiLfGTwulCHLwIlN5NZg68r9e94O2DRKBhJ7D97lTgosbxxGBzeSblH9pL
         0gkw==
X-Forwarded-Encrypted: i=1; AJvYcCXKFyy7fZvQf+6OczB0s3hLd2Hz5q77OuteJ1nwwHYCMyIIaYQG7YtdjTB937mU/jpd8AYvvUm4wZ2kj/PfTtqZM9yi0a9HOw==
X-Gm-Message-State: AOJu0YzdUUs4CdJdQC09u21QIzNk3PfHXl1FVbiQg5QnzkV5GGxAWe8G
	38Yy4nF92xZj5OWfm2XeLK088vWfgnQkrx5iH4Bpt3+rcYR4OSkNmx548nb1p22NZEEevYLM6Ds
	pZ/B4ggIF0D38HlX/h0Wq6aETm275E/4+s1wJ
X-Google-Smtp-Source: AGHT+IGjyb70B6SDuY6wbgv03PDQBnzlJHXoezrkDksvAWcp/tWgb1al0Y3A+AXmmF09ME9ZvkZTyuBhj4nPA5ao6V4=
X-Received: by 2002:a05:622a:6fc7:b0:444:e366:3fda with SMTP id
 d75a77b69052e-444e36643aamr2439491cf.27.1719222920463; Mon, 24 Jun 2024
 02:55:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com> <10-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <10-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Mon, 24 Jun 2024 17:54:42 +0800
Message-ID: <CAKHBV27hj5cefib6nx9CM9-9P3N2k=Y2W-FwT06W4OoEFJ_zqA@mail.gmail.com>
Subject: Re: [PATCH v8 10/14] iommu/arm-smmu-v3: Put the SVA mmu notifier in
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

On Tue, Jun 4, 2024 at 8:16=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> This removes all the notifier de-duplication logic in the driver and
> relies on the core code to de-duplicate and allocate only one SVA domain
> per mm per smmu instance. This naturally gives a 1:1 relationship between
> SVA domain and mmu notifier.
>
> It is a significant simplication of the flow, as we end up with a single
> struct arm_smmu_domain for each MM and the invalidation can then be
> shifted to properly use the masters list like S1/S2 do.
>
> Remove all of the previous mmu_notifier, bond, shared cd, and cd refcount
> logic entirely.
>
> The logic here is tightly wound together with the unusued BTM
> support. Since the BTM logic requires holding all the iommu_domains in a
> global ASID xarray it conflicts with the design to have a single SVA
> domain per PASID, as multiple SMMU instances will need to have different
> domains.
>
> Following patches resolve this by making the ASID xarray per-instance
> instead of global. However, converting the BTM code over to this
> methodology requires many changes.
>
> Thus, since ARM_SMMU_FEAT_BTM is never enabled, remove the parts of the
> BTM support for ASID sharing that interact with SVA as well.
>
> A followup series is already working on fully enabling the BTM support,
> that requires iommufd's VIOMMU feature to bring in the KVM's VMID as
> well. It will come with an already written patch to bring back the ASID
> sharing using a per-instance ASID xarray.
>
> https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kol=
othum.thodi@huawei.com/
> https://lore.kernel.org/linux-iommu/26-v6-228e7adf25eb+4155-smmuv3_newapi=
_p2_jgg@nvidia.com/
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 395 +++---------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  69 +--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  15 +-
>  3 files changed, 86 insertions(+), 393 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index aa033cd65adc5a..a7c36654dee5a5 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -13,29 +13,9 @@
>  #include "arm-smmu-v3.h"
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

Can we leave a comment on ASID sharing in the code since it isn't
added back until the next patch series? There are references to ASID
sharing remaining (and even added in this commit) that don't make
sense without this function (e.g "Prevent arm_smmu_share_asid() from
trying to change the ASID").


>  static u64 page_size_to_cd(void)
>  {
>         static_assert(PAGE_SIZE =3D=3D SZ_4K || PAGE_SIZE =3D=3D SZ_16K |=
|
> @@ -187,69 +115,6 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target=
,
>  }
>  EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_sva_cd);
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
> @@ -264,8 +129,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlb=
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
> @@ -282,34 +147,22 @@ static void arm_smmu_mm_arch_invalidate_secondary_t=
lbs(struct mmu_notifier *mn,
>                         size =3D 0;
>         }
>
> -       if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM)) {
> -               if (!size)
> -                       arm_smmu_tlb_inv_asid(smmu_domain->smmu,
> -                                             smmu_mn->cd->asid);
> -               else
> -                       arm_smmu_tlb_inv_range_asid(start, size,
> -                                                   smmu_mn->cd->asid,
> -                                                   PAGE_SIZE, false,
> -                                                   smmu_domain);
> -       }
> +       if (!size)
> +               arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.=
asid);
> +       else
> +               arm_smmu_tlb_inv_range_asid(start, size, smmu_domain->cd.=
asid,
> +                                           PAGE_SIZE, false, smmu_domain=
);
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
> @@ -321,25 +174,23 @@ static void arm_smmu_mm_release(struct mmu_notifier=
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
> +                                    smmu_domain->cd.asid);
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
> +       kfree(container_of(mn, struct arm_smmu_domain, mmu_notifier));
>  }
>
>  static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops =3D {
> @@ -348,115 +199,6 @@ static const struct mmu_notifier_ops arm_smmu_mmu_n=
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
> -static struct arm_smmu_bond *__arm_smmu_sva_bind(struct device *dev,
> -                                                struct mm_struct *mm)
> -{
> -       int ret;
> -       struct arm_smmu_bond *bond;
> -       struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> -       struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
> -       struct arm_smmu_domain *smmu_domain;
> -
> -       if (!(domain->type & __IOMMU_DOMAIN_PAGING))
> -               return ERR_PTR(-ENODEV);
> -       smmu_domain =3D to_smmu_domain(domain);
> -       if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_S1)
> -               return ERR_PTR(-ENODEV);
> -
> -       if (!master || !master->sva_enabled)
> -               return ERR_PTR(-ENODEV);
> -
> -       bond =3D kzalloc(sizeof(*bond), GFP_KERNEL);
> -       if (!bond)
> -               return ERR_PTR(-ENOMEM);
> -
> -       bond->mm =3D mm;
> -
> -       bond->smmu_mn =3D arm_smmu_mmu_notifier_get(smmu_domain, mm);
> -       if (IS_ERR(bond->smmu_mn)) {
> -               ret =3D PTR_ERR(bond->smmu_mn);
> -               goto err_free_bond;
> -       }
> -
> -       list_add(&bond->list, &master->bonds);
> -       return bond;
> -
> -err_free_bond:
> -       kfree(bond);
> -       return ERR_PTR(ret);
> -}
> -
>  bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
>  {
>         unsigned long reg, fld;
> @@ -573,11 +315,6 @@ int arm_smmu_master_enable_sva(struct arm_smmu_maste=
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
> @@ -594,66 +331,51 @@ void arm_smmu_sva_notifier_synchronize(void)
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
> -       struct mm_struct *mm =3D domain->mm;
> -       struct arm_smmu_bond *bond;
>         struct arm_smmu_cd target;
>         int ret;
>
> -       if (mm_get_enqcmd_pasid(mm) !=3D id)
> +       /* Prevent arm_smmu_mm_release from being called while we are att=
aching */
> +       if (!mmget_not_zero(domain->mm))
>                 return -EINVAL;
>
> -       mutex_lock(&sva_lock);
> -       bond =3D __arm_smmu_sva_bind(dev, mm);
> -       if (IS_ERR(bond)) {
> -               mutex_unlock(&sva_lock);
> -               return PTR_ERR(bond);
> -       }
> +       /*
> +        * This does not need the arm_smmu_asid_lock because SVA domains =
never
> +        * get reassigned
> +        */
> +       arm_smmu_make_sva_cd(&target, master, domain->mm, smmu_domain->cd=
.asid);
> +       ret =3D arm_smmu_set_pasid(master, smmu_domain, id, &target);
>
> -       arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid=
);
> -       ret =3D arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &t=
arget);
> -       if (ret) {
> -               list_del(&bond->list);
> -               arm_smmu_mmu_notifier_put(bond->smmu_mn);
> -               kfree(bond);
> -               mutex_unlock(&sva_lock);
> -               return ret;
> -       }
> -       mutex_unlock(&sva_lock);
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
>
>  static const struct iommu_domain_ops arm_smmu_sva_domain_ops =3D {
> @@ -667,6 +389,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct=
 device *dev,
>         struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
>         struct arm_smmu_device *smmu =3D master->smmu;
>         struct arm_smmu_domain *smmu_domain;
> +       u32 asid;
> +       int ret;
>
>         smmu_domain =3D arm_smmu_domain_alloc();
>         if (IS_ERR(smmu_domain))
> @@ -675,5 +399,22 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struc=
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
> index 24000027253de8..2a845ab6d53b57 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1439,22 +1439,6 @@ static void arm_smmu_free_cd_tables(struct arm_smm=
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
> @@ -2023,8 +2007,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_=
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
> @@ -2062,15 +2046,7 @@ static int __arm_smmu_atc_inv_domain(struct arm_sm=
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
> @@ -2082,19 +2058,6 @@ static int __arm_smmu_atc_inv_domain(struct arm_sm=
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
> @@ -2283,7 +2246,6 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
>         mutex_init(&smmu_domain->init_mutex);
>         INIT_LIST_HEAD(&smmu_domain->devices);
>         spin_lock_init(&smmu_domain->devices_lock);
> -       INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
>
>         return smmu_domain;
>  }
> @@ -2325,7 +2287,7 @@ static void arm_smmu_domain_free_paging(struct iomm=
u_domain *domain)
>         if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
>                 /* Prevent SVA from touching the CD while we're freeing i=
t */
>                 mutex_lock(&arm_smmu_asid_lock);
> -               arm_smmu_free_asid(&smmu_domain->cd);
> +               xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
>                 mutex_unlock(&arm_smmu_asid_lock);
>         } else {
>                 struct arm_smmu_s2_cfg *cfg =3D &smmu_domain->s2_cfg;
> @@ -2343,11 +2305,9 @@ static int arm_smmu_domain_finalise_s1(struct arm_=
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
> @@ -2835,6 +2795,9 @@ int arm_smmu_set_pasid(struct arm_smmu_master *mast=
er,
>
>         /* The core code validates pasid */
>
> +       if (smmu_domain->smmu !=3D master->smmu)
> +               return -EINVAL;
> +
>         if (!master->cd_table.in_ste)
>                 return -ENODEV;
>
> @@ -2856,9 +2819,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *mas=
ter,
>         return ret;
>  }
>
> -void arm_smmu_remove_pasid(struct arm_smmu_master *master,
> -                          struct arm_smmu_domain *smmu_domain, ioasid_t =
pasid)
> +static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid=
,
> +                                     struct iommu_domain *domain)
>  {
> +       struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> +       struct arm_smmu_domain *smmu_domain;
> +
> +       smmu_domain =3D to_smmu_domain(domain);
> +
>         mutex_lock(&arm_smmu_asid_lock);
>         arm_smmu_clear_cd(master, pasid);
>         if (master->ats_enabled)
> @@ -3129,7 +3097,6 @@ static struct iommu_device *arm_smmu_probe_device(s=
truct device *dev)
>
>         master->dev =3D dev;
>         master->smmu =3D smmu;
> -       INIT_LIST_HEAD(&master->bonds);
>         dev_iommu_priv_set(dev, master);
>
>         ret =3D arm_smmu_insert_master(smmu, master);
> @@ -3311,12 +3278,6 @@ static int arm_smmu_def_domain_type(struct device =
*dev)
>         return 0;
>  }
>
> -static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid=
,
> -                                     struct iommu_domain *domain)
> -{
> -       arm_smmu_sva_remove_dev_pasid(domain, dev, pasid);
> -}
> -
>  static struct iommu_ops arm_smmu_ops =3D {
>         .identity_domain        =3D &arm_smmu_identity_domain,
>         .blocked_domain         =3D &arm_smmu_blocked_domain,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index 212c18c70fa03e..d175d9eee6c61b 100644
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
> @@ -712,7 +709,6 @@ struct arm_smmu_master {
>         bool                            stall_enabled;
>         bool                            sva_enabled;
>         bool                            iopf_enabled;
> -       struct list_head                bonds;
>         unsigned int                    ssid_bits;
>  };
>
> @@ -741,7 +737,7 @@ struct arm_smmu_domain {
>         struct list_head                devices;
>         spinlock_t                      devices_lock;
>
> -       struct list_head                mmu_notifiers;
> +       struct mmu_notifier             mmu_notifier;
>  };


>
>  /* The following are exposed for testing purposes. */
> @@ -805,16 +801,13 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master=
 *master, int ssid,
>  int arm_smmu_set_pasid(struct arm_smmu_master *master,
>                        struct arm_smmu_domain *smmu_domain, ioasid_t pasi=
d,
>                        const struct arm_smmu_cd *cd);
> -void arm_smmu_remove_pasid(struct arm_smmu_master *master,
> -                          struct arm_smmu_domain *smmu_domain, ioasid_t =
pasid);
>
>  void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
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
> @@ -826,8 +819,6 @@ bool arm_smmu_master_iopf_supported(struct arm_smmu_m=
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
> 2.45.2
>

Reviewed-by: Michael Shavit <mshavit@google.com>
