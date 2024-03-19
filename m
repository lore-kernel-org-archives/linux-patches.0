Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BB280040
	for <patches@lists.linux.dev>; Tue, 19 Mar 2024 13:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710855119; cv=none; b=NlyeyLm0nuAHbjsegmVztM1/vmJtYkM8zpdqUJF/xg5exQg0WSFcjldWSDbGoLsxdiHqFsikLhz6i+9140mLXoJsyYJsTaKcvyAWUKsUV19wjeQrEc4o+6NlnzNTQzq2foo7HJm4H7RsKbIO1ettMtRDXGCBkSGlImeJz93ar1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710855119; c=relaxed/simple;
	bh=gyMSZt5dDhzgsNEYMrfAF2GNRjz+kq0/xKH02bmGLO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=En/w5tIbOWSxLhL7BIbUk08PlBJxIz2V8tqHYb+LG2aeXGEhRLB0KEqZKkM1MjGa35+5q4OPDS3W0OROd59gA5+iBMC1BdKYeuTKlTpPBhl+vuV6K811DU2FeZFx+jrpn8npobIrVxBZFnz10xdG2GKSoMzSvjGHKoL543hJIIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vDvJxFTp; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vDvJxFTp"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-430d3fcc511so218731cf.1
        for <patches@lists.linux.dev>; Tue, 19 Mar 2024 06:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710855116; x=1711459916; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCTNKcOemRKHIJbnQDVL6FBmnD6Nifk9uyED08/a8/o=;
        b=vDvJxFTpTIo53H8jH/i+jOA89qs/ZBIWtPKPPpbQHSPAy9Dqk20IQhh01LTFNRJHxv
         YrCDmg4/EnfI0xVF0LwYfvsLGW2GU8qjCr+WsTxsn2LpNgVA+XeAUyGmtqUfBq7KflZw
         9jOYQGDFXO1473Y3NYuqJc0pHszyCWR9Ymox7hYH9HfzPW9Krkhb6QkI6mDABGQBWSMO
         mAFwgq3JSHIGqsBVFQO1e2NPJel47tBNyzIzKHxjP7XdBIFxf9iWXLqj1N7TqzcMutdR
         nAPPoRRmOkZd6SOjuzHd/rBEjvwDTyNiAWtV19PftfNMypDmyRutFcogJUh25ZpXzLdF
         GrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710855116; x=1711459916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zCTNKcOemRKHIJbnQDVL6FBmnD6Nifk9uyED08/a8/o=;
        b=pQcEaUK75tmljLa4rJsSAwHmzmaaAKHMjEruPqH9r2EL+hnLZxLrkPcKgFT8rvFZCe
         NCp32M7boWZQFbcrBoqqgDbc3JUiSSr4Mtw+7CddvFG8hnTFPyoxWmQF5yfQta3je9I1
         s6FdVqPaQF6jNYWrBGubZ5nWOdmqPWEmU9IBkQEsUcR4gnN/lzXucsmqkxp8z0wY2Y1X
         VyMyDda4fhSVJy6FUemLd22kHqrSy+RKwAuIEQlg+ACdGdeJwKfu1j5RW7VUILFp+rQ8
         SYYGeWgUDNlGmd7wns3sSKkwU+Y6Iepl/8d3Z/JVZRLHh4peWiTiuF7Q9b0P/izpIQ3i
         Pbwg==
X-Forwarded-Encrypted: i=1; AJvYcCUSOMbDUjX/3x8UWIsM8SN/RkmzHu+W1V2DnfTTbRlzRuqZQONxGtNkQT+wldHGe/OkM5F2kHYsnTptVJXxkZApWMzUZUqM3g==
X-Gm-Message-State: AOJu0YwtmKtMPO1Qbqil5PmL7iyKyOwefjwg2mlL2IpW/DAxir9yiHNo
	mTh7v7EaSJBXl2rvHRityzgI8MIL6HJgKbiyBzgLjmNRg69wGEhU5B6C+8Pzct65L7qa/moyTXj
	NRO9D9wSzLR1taluWvb9dZ5Qqmt7rvLJvCSZ8
X-Google-Smtp-Source: AGHT+IFDxCVQqhylUAnjRaojTSv9eGRLtRx8S0Uu7+luoQb+S355PpxqHLm/0B3umSOhUayv+yxGo1uVOPkDwFF+j3w=
X-Received: by 2002:a05:622a:134f:b0:430:e9f8:6b03 with SMTP id
 w15-20020a05622a134f00b00430e9f86b03mr181310qtk.7.1710855115949; Tue, 19 Mar
 2024 06:31:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <15-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <15-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Tue, 19 Mar 2024 21:31:17 +0800
Message-ID: <CAKHBV24fgg97mpfiTfeppUEPhSDoQN54BG0GRNi1pw3hDdBeqw@mail.gmail.com>
Subject: Re: [PATCH v5 15/27] iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
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
> Prepare to allow a S1 domain to be attached to a PASID as well. Keep trac=
k
> of the SSID the domain is using on each master in the
> arm_smmu_master_domain.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 15 ++++---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 42 +++++++++++++++----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 ++-
>  3 files changed, 43 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 9a285b828e8b12..ab9de8e36c45f5 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -47,13 +47,12 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_do=
main *smmu_domain)
>                 struct arm_smmu_master *master =3D master_domain->master;
>                 struct arm_smmu_cd *cdptr;
>
> -               /* S1 domains only support RID attachment right now */
> -               cdptr =3D arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> +               cdptr =3D arm_smmu_get_cd_ptr(master, master_domain->ssid=
);
>                 if (WARN_ON(!cdptr))
>                         continue;
>
>                 arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
> -               arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
> +               arm_smmu_write_cd_entry(master, master_domain->ssid, cdpt=
r,
>                                         &target_cd);
>         }
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> @@ -293,8 +292,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlb=
s(struct mmu_notifier *mn,
>                                                     smmu_domain);
>         }
>
> -       arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), sta=
rt,
> -                               size);
> +       arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm),=
 start,
> +                                   size);
>  }
>
>  static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struc=
t *mm)
> @@ -331,7 +330,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *=
mn, struct mm_struct *mm)
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>
>         arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
> -       arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, =
0);
> +       arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm),=
 0, 0);
>
>         smmu_mn->cleared =3D true;
>         mutex_unlock(&sva_lock);
> @@ -410,8 +409,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu=
_mmu_notifier *smmu_mn)
>          */
>         if (!smmu_mn->cleared) {
>                 arm_smmu_tlb_inv_asid(smmu_domain->smmu, cd->asid);
> -               arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(=
mm), 0,
> -                                       0);
> +               arm_smmu_atc_inv_domain_sva(smmu_domain,
> +                                           mm_get_enqcmd_pasid(mm), 0, 0=
);
>         }
>
>         /* Frees smmu_mn */
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 45f2190fc31786..26c6b9f6f34fd3 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2030,8 +2030,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_=
master *master)
>         return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
>  }
>
> -int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssi=
d,
> -                           unsigned long iova, size_t size)
> +static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain=
,
> +                                    ioasid_t ssid, unsigned long iova, s=
ize_t size)
>  {
>         struct arm_smmu_master_domain *master_domain;
>         int i;
> @@ -2059,8 +2059,6 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain =
*smmu_domain, int ssid,
>         if (!atomic_read(&smmu_domain->nr_ats_masters))
>                 return 0;
>
> -       arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
> -
>         cmds.num =3D 0;
>
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> @@ -2071,6 +2069,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain=
 *smmu_domain, int ssid,
>                 if (!master->ats_enabled)
>                         continue;
>
> +               /*
> +                * Non-zero ssid means SVA is co-opting the S1 domain to =
issue
> +                * invalidations for SVA PASIDs.
> +                */
> +               if (ssid !=3D IOMMU_NO_PASID)
> +                       arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
> +               else
> +                       arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova=
, size,
> +                                               &cmd);
> +
>                 for (i =3D 0; i < master->num_streams; i++) {
>                         cmd.atc.sid =3D master->streams[i].id;
>                         arm_smmu_cmdq_batch_add(smmu_domain->smmu, &cmds,=
 &cmd);
> @@ -2081,6 +2089,19 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain=
 *smmu_domain, int ssid,
>         return arm_smmu_cmdq_batch_submit(smmu_domain->smmu, &cmds);
>  }
>
> +static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
> +                                  unsigned long iova, size_t size)
> +{
> +       return __arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iov=
a,
> +                                        size);
> +}
> +
> +int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
> +                               ioasid_t ssid, unsigned long iova, size_t=
 size)
> +{
> +       return __arm_smmu_atc_inv_domain(smmu_domain, ssid, iova, size);
> +}
> +
>  /* IO_PGTABLE API */
>  static void arm_smmu_tlb_inv_context(void *cookie)
>  {
> @@ -2102,7 +2123,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>                 cmd.tlbi.vmid   =3D smmu_domain->s2_cfg.vmid;
>                 arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>         }
> -       arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
> +       arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
>  }
>
>  static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
> @@ -2200,7 +2221,7 @@ static void arm_smmu_tlb_inv_range_domain(unsigned =
long iova, size_t size,
>          * Unfortunately, this can't be leaf-only since we may have
>          * zapped an entire table.
>          */
> -       arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova, size);
> +       arm_smmu_atc_inv_domain(smmu_domain, iova, size);
>  }
>
>  void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int as=
id,
> @@ -2539,7 +2560,8 @@ static void arm_smmu_disable_pasid(struct arm_smmu_=
master *master)
>
>  static struct arm_smmu_master_domain *
>  arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
> -                           struct arm_smmu_master *master)
> +                           struct arm_smmu_master *master,
> +                           ioasid_t ssid)
>  {
>         struct arm_smmu_master_domain *master_domain;
>
> @@ -2547,7 +2569,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain =
*smmu_domain,
>
>         list_for_each_entry(master_domain, &smmu_domain->devices,
>                             devices_elm) {
> -               if (master_domain->master =3D=3D master)
> +               if (master_domain->master =3D=3D master &&
> +                   master_domain->ssid =3D=3D ssid)
>                         return master_domain;
>         }
>         return NULL;
> @@ -2580,7 +2603,8 @@ static void arm_smmu_remove_master_domain(struct ar=
m_smmu_master *master,
>                 return;
>
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -       master_domain =3D arm_smmu_find_master_domain(smmu_domain, master=
);
> +       master_domain =3D arm_smmu_find_master_domain(smmu_domain, master=
,
> +                                                   IOMMU_NO_PASID);
>         if (master_domain) {
>                 list_del(&master_domain->devices_elm);
>                 kfree(master_domain);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index c4b79bc52991be..98dc5885c48655 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -738,6 +738,7 @@ struct arm_smmu_domain {
>  struct arm_smmu_master_domain {
>         struct list_head devices_elm;
>         struct arm_smmu_master *master;
> +       u16 ssid;
>  };

SMMU_IDR1.SSIDSIZE may be up to 20 according to the spec. The value
read from this register is used to populate iommu.max_pasids as well
as to compute the smmu/master ssid_bits fields so u16 is insufficient
here.

>
>  static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain=
 *dom)
> @@ -769,8 +770,8 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, =
size_t size, int asid,
>                                  size_t granule, bool leaf,
>                                  struct arm_smmu_domain *smmu_domain);
>  bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
> -int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssi=
d,
> -                           unsigned long iova, size_t size);
> +int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
> +                               ioasid_t ssid, unsigned long iova, size_t=
 size);
>
>  #ifdef CONFIG_ARM_SMMU_V3_SVA
>  bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
> --
> 2.43.2
>

Apart from ssid size issue
Reviewed-by: Michael Shavit <mshavit@google.com>
