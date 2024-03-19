Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBC6101EB
	for <patches@lists.linux.dev>; Tue, 19 Mar 2024 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710866723; cv=none; b=TsFSe9gSWhNWJlAen5f/cQI3E4yNCcIvCDCFkO0H18Gu4+oTFRXq0rgSq3+wCMGfCOpEzof1kxO1NF4rs9OZ9wX87r3aLSml9vNuYv87RNBMzbNfb/JQhvnlgLbJgbLuYcRxoAe3NCb+v0KsJ+yb0u/pABn5mTaWnrw7WOtuvng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710866723; c=relaxed/simple;
	bh=am/yM1P7k8+aYk0pUA1+MbvQbQqzJoKGbiBAyO2+yLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LtgfFQNIyKqCbwJ21EPb56egCCDKe22Bc8T3HW2eX+IBG2kTKDVl/iE8PoMQ6QXNxdUqHfQCofFmyvj4vRzMjjgiqj8TaQVifn0i4R3GUC6mI8h5kQ+t/pKKXtcxXTcn5sRG7KNyG6mXZjF0VtnWgO+MspLx9TqUnpnPmrvoNJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ilo3DKyR; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ilo3DKyR"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-428405a0205so141cf.1
        for <patches@lists.linux.dev>; Tue, 19 Mar 2024 09:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710866720; x=1711471520; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GiH0rqSwkuvZ1EEeTTR2550tC/9fd5xcH1dKyyhBtGs=;
        b=ilo3DKyRCca1Yp241NtpeeLmFzyF1PaBzReQXWhQLKq8hEP0W1uq27mVj9ntT7MgaN
         JZsz58yeeb2m5sWxFWHfz86gCooWGY5eb7fuTBOG31vgL6fdjKwWWsOKguivdgwcNK4W
         PRvMjfycDcV/IETvyKX/KdrUCZ6tBexNfJsyXzLHFLNgenSMlhpuP9eVmD6DbIvpaVJG
         FKa/1x5V8++U8D4wiWky/oHMrueEpezp/wX74RxTpfG/hTYEyweuZF1z/j+wuCBxOqd0
         uYcrVELq3MO/lDL05bly4Fe6wgfCooWSvn9j0T6aNwxdKRJThm1sSne+12z20YsxwLAM
         KTVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710866720; x=1711471520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GiH0rqSwkuvZ1EEeTTR2550tC/9fd5xcH1dKyyhBtGs=;
        b=ISl6mp/G0DEl72y+O8l0iukxH+oGgdR9jM6RZnExjAyFmNn2aBp/XtEGeylQXaNiPZ
         L/Aq9+dZe423D1fbVqs7z9ZKJiJBRSqimRgWbw3FdFABNiXJfWpHiigUdEQSjW2L5lYi
         nF4ZEyjc0SszzUWkIK6Ul+OIO04RTTZvu2aWlb1C55RutYLW3blqNON8JYnhzt5RBBeJ
         8V2IuSl/cG7lSVMN1JiSm0COEmWUfLxk39hYNfV32quz0pAGDcp0b44MF2qFQOhH6x0z
         1ZQowUsljzQqY2mHoa3rPrHT44wUcNFuAGhkfgyNaLFVWy5DJu5QhvE6eppjaOtZI7NA
         NGtw==
X-Forwarded-Encrypted: i=1; AJvYcCU6ITztXmQSrTAu0AGksSCRjK5cZVDz65wID2+NkSHug5iOLa+5LsLfitEoRAhrKQ+o/g95aVjH+hoY0cv1ADE1mD14NwSKfw==
X-Gm-Message-State: AOJu0Yx2ri8m1Tx/bgnAP3qqnY8Jl0i9EnzMhnrQ1sCnPE7A8zhOeZVL
	Z2958U7+SRYjplaGXOWDYMz4mnijWSJjYpUaCn3OkQIwn1V0SGnO7Y92rsW+bg0iRqCFneh9RLz
	WVQLrfbBj0Dt4wuPcKxcxH+K5wSXmoW3UF//J
X-Google-Smtp-Source: AGHT+IG/jceIKDRqsO4QTFs3h9lF1LPtNMSgWaM8CfM8aVRrb6oV+sc7bAuwCl7FzL2rSq/+ZybHDiFxK9Ep2DPpGH0=
X-Received: by 2002:a05:622a:1749:b0:42f:a3c:2d50 with SMTP id
 l9-20020a05622a174900b0042f0a3c2d50mr324938qtk.17.1710866720054; Tue, 19 Mar
 2024 09:45:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <22-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <22-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Wed, 20 Mar 2024 00:44:42 +0800
Message-ID: <CAKHBV26RwVZXysaLDMxCsNkYB9BkkQqRBkj1-dnhBf8pO_QE5w@mail.gmail.com>
Subject: Re: [PATCH v5 22/27] iommu/arm-smmu-v3: Consolidate freeing the ASID/VMID
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
> The SMMUv3 IOTLB is tagged with a VMID/ASID cache tag. Any time the
> underlying translation is changed these need to be invalidated. At boot
> time the IOTLB starts out empty and all cache tags are available for
> allocation.
>
> When a tag is taken out of the allocator the code assumes the IOTLB
> doesn't reference it, and immediately programs it into a STE/CD. If the
> cache is referencing the tag then it will have stale data and IOMMU will
> become incoherent.
>
> Thus, whenever an ASID/VMID is freed back to the allocator we need to kno=
w
> that the IOTLB doesn't have any references to it. The SVA code correctly
> had an invalidation here, but the paging code does not.

Isn't that....bad?

>
> Consolidate freeing the VMID/ASID to one place and consistently flush bot=
h
> ID types before returning to their allocators.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  9 ++---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 36 +++++++++++++------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
>  3 files changed, 29 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index cb0da4e5a5517a..3a9f4ef47c6b6f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -381,18 +381,13 @@ static void arm_smmu_sva_domain_free(struct iommu_d=
omain *domain)
>  {
>         struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
>
> -       /*
> -        * Ensure the ASID is empty in the iommu cache before allowing re=
use.
> -        */
> -       arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
> -
>         /*
>          * Notice that the arm_smmu_mm_arch_invalidate_secondary_tlbs op =
can
>          * still be called/running at this point. We allow the ASID to be
>          * reused, and if there is a race then it just suffers harmless
>          * unnecessary invalidation.
>          */
> -       xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
> +       arm_smmu_domain_free_id(smmu_domain);
>
>         /*
>          * Actual free is defered to the SRCU callback
> @@ -437,7 +432,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct=
 device *dev,
>         return &smmu_domain->domain;
>
>  err_asid:
> -       xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
> +       arm_smmu_domain_free_id(smmu_domain);
>  err_free:
>         kfree(smmu_domain);
>         return ERR_PTR(ret);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 5642321b2124d9..4f22eb810c8dbd 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2296,25 +2296,41 @@ static struct iommu_domain *arm_smmu_domain_alloc=
_paging(struct device *dev)
>         return &smmu_domain->domain;
>  }
>
> -static void arm_smmu_domain_free(struct iommu_domain *domain)
> +/*
> + * Return the domain's ASID or VMID back to the allocator. All IDs in th=
e
> + * allocator do not have an IOTLB entries referencing them.
> + */
> +void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain)
>  {
> -       struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
>         struct arm_smmu_device *smmu =3D smmu_domain->smmu;
>
> -       free_io_pgtable_ops(smmu_domain->pgtbl_ops);
> +       if ((smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1 ||
> +            smmu_domain->domain.type =3D=3D IOMMU_DOMAIN_SVA) &&
> +           smmu_domain->cd.asid) {
> +               arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
>
> -       /* Free the ASID or VMID */
> -       if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
>                 /* Prevent SVA from touching the CD while we're freeing i=
t */
>                 mutex_lock(&arm_smmu_asid_lock);
>                 xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
>                 mutex_unlock(&arm_smmu_asid_lock);
> -       } else {
> -               struct arm_smmu_s2_cfg *cfg =3D &smmu_domain->s2_cfg;
> -               if (cfg->vmid)
> -                       ida_free(&smmu->vmid_map, cfg->vmid);
> -       }
> +       } else if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S2 &&
> +                  smmu_domain->s2_cfg.vmid) {
> +               struct arm_smmu_cmdq_ent cmd =3D {
> +                       .opcode =3D CMDQ_OP_TLBI_S12_VMALL,
> +                       .tlbi.vmid =3D smmu_domain->s2_cfg.vmid
> +               };
>
> +               arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> +               ida_free(&smmu->vmid_map, smmu_domain->s2_cfg.vmid);
> +       }
> +}
> +

There's room to refactor and share the tlb id invalidation logic with
arm_smmu_tlb_inv_context by the way, but this works too.

> +static void arm_smmu_domain_free(struct iommu_domain *domain)
> +{
> +       struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
> +
> +       free_io_pgtable_ops(smmu_domain->pgtbl_ops);
> +       arm_smmu_domain_free_id(smmu_domain);
>         kfree(smmu_domain);
>  }
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index cfae4d69cd810c..4631f0ac396dc3 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -774,6 +774,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master=
,
>  void arm_smmu_remove_pasid(struct arm_smmu_master *master,
>                            struct arm_smmu_domain *smmu_domain, ioasid_t =
pasid);
>
> +void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain);
>  void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
>  void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int as=
id,
>                                  size_t granule, bool leaf,
> --
> 2.43.2
>
>

Reviewed-by: Michael Shavit <mshavit@google.com>
