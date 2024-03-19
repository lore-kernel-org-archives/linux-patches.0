Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6047D81203
	for <patches@lists.linux.dev>; Tue, 19 Mar 2024 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853784; cv=none; b=s6ODhhjFdFvPkg2BaGgz37b68u/4jCnQQA3zMaCpz6e1eUz5ZRcgoLgDyHnsz/b8VAQv5jcsb4p1dUvfll8AXQJhbMsPz83XRWqNna4y761GbcUZ8K1N8EdnDaJBPYdr9XRQP+rgFHv4A0N1p1Y/bPlE8zVtlWF7f0LHsM9UfNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853784; c=relaxed/simple;
	bh=m8eQJUjQf9SsLufdEs1WSSnvmZMf9kFoVHaNlvkn3EM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aBjXyOTmHo3+2BlKjAw/OlwcjaPOs53k4knRnFxHIJsL4Kf+x9wNEn/qQopy7QiuS/UusBem+xr34iEXb5sDgknBAJ/V7isU5T8maOhQHQaRsMvBM8BCqEnehnFe5E/AkVyg8tWs+azxdnLj+nOfl8+j1uY6O6u0ttzuvOSCMzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UqYV/SA6; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UqYV/SA6"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-42ee0c326e8so261321cf.0
        for <patches@lists.linux.dev>; Tue, 19 Mar 2024 06:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710853781; x=1711458581; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MghlcANp/ubj6EldaICUW15V5GROTir69c/LW5qGo7o=;
        b=UqYV/SA6I8o56R6xiN/buijWBo5qZOBPJXGb6H2nplPaZjeOhXQYa3z9NDLK1KNyLg
         tzhLX8wT5gUfX4Z6VWd2SQuXQuL9nU8plc/366vCSaXuhYfqQ7Bzd0S0zTOxJlitpLGA
         TJ61ywkiwpeubB1BDziUN2UUs/Z6bqBoRCUbOf/cUvYNr4aUe27wogvnxZzcO757WUTR
         PzTygHVstFR6rQuIeAOICHbq3y9+Vnsawy6CR8yoNT9zSzlQmvyOp3YZdbCR6Jm3Hz7c
         F2NCoV32C0q3j+EyQSlp2nygVVDzaGTmXD9raYO3aJn3F2lReZWGsNNNcazq5Pl0/5M+
         Jmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710853781; x=1711458581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MghlcANp/ubj6EldaICUW15V5GROTir69c/LW5qGo7o=;
        b=SMix8BLHPk4nDahbb0bbWhuFeX+lHA1Se9wba8sr2J+KyOvhowrXZzgr3TFD1C/Gkc
         j/rAdH2b/DX9rszOQgXQGcvvrWYOEmjGu5+CMliiB3Ex4JjSRXg0iFnRO6GFkD8IqAlC
         9NDt8NV4ND5nHY14cyHZ2NuH3+RIosOyoJ1kbh9kITdXy5CEDIMVhZ3sHH/qi7MglKpW
         WDfygMe1D+OebpolXgsEUvdUGlc+f++a2SvG3ycRk3PUEktG/RaIFyVNQ5kzQc8tsT0q
         hiEDINLqCVDU7nHBV3xbwkp7q5aO1U77Be4dc5WB75eIXWY0ZUcHtrnNA0Fy/5zN6sr+
         w0QA==
X-Forwarded-Encrypted: i=1; AJvYcCVXvg0TTKpMUE5Ft2C0LB7T8Wn/ysMhVsO7ldVHNjIU4HCKMPakl/+ZvoATJVtS/SfeftueiPvQ7mKnhXFe7O9Z/d+0Rk2jHQ==
X-Gm-Message-State: AOJu0YzcsAifBEdhkdbyzH7n0bquCMVsphyoZY6PuYFKeTJXki/fm3j4
	REHGVdfqyCNfRRHS24GV7vqnn8gT6AhLZzY3SnkD1LYh9qCzcqctQrjSPXWy/hu1Ex6AIJC+Wy8
	gHN+2kiPAEJOulgZQqL4V+TAclJ2ZiJokdWjL
X-Google-Smtp-Source: AGHT+IFMBeRoFnQzBZT6LjmbsqOUYqa2fKnjDevwFQWsDxj5SmlbnwNjBf6iKAGvnekj6PJNJQbWXqnG3cWJF/5cYC8=
X-Received: by 2002:a05:622a:10b:b0:430:ed72:bc0d with SMTP id
 u11-20020a05622a010b00b00430ed72bc0dmr114017qtw.26.1710853781068; Tue, 19 Mar
 2024 06:09:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <13-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <13-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Tue, 19 Mar 2024 21:09:03 +0800
Message-ID: <CAKHBV277RwYh0eK0UCzYaJcKOJ66XgakmeQ+q7CX6mDnGZ1vwA@mail.gmail.com>
Subject: Re: [PATCH v5 13/27] iommu/arm-smmu-v3: Make smmu_domain->devices
 into an allocated list
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
> The next patch will need to store the same master twice (with different
> SSIDs), so allocate memory for each list element.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 11 ++++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 ++++++++++++++++---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 +++-
>  3 files changed, 47 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index e1fa2074c0b37b..9a285b828e8b12 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -38,12 +38,13 @@ static DEFINE_MUTEX(sva_lock);
>  static void
>  arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
>  {
> -       struct arm_smmu_master *master;
> +       struct arm_smmu_master_domain *master_domain;
>         struct arm_smmu_cd target_cd;
>         unsigned long flags;
>
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -       list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> +       list_for_each_entry(master_domain, &smmu_domain->devices, devices=
_elm) {
> +               struct arm_smmu_master *master =3D master_domain->master;
>                 struct arm_smmu_cd *cdptr;
>
>                 /* S1 domains only support RID attachment right now */
> @@ -300,7 +301,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *=
mn, struct mm_struct *mm)
>  {
>         struct arm_smmu_mmu_notifier *smmu_mn =3D mn_to_smmu(mn);
>         struct arm_smmu_domain *smmu_domain =3D smmu_mn->domain;
> -       struct arm_smmu_master *master;
> +       struct arm_smmu_master_domain *master_domain;
>         unsigned long flags;
>
>         mutex_lock(&sva_lock);
> @@ -314,7 +315,9 @@ static void arm_smmu_mm_release(struct mmu_notifier *=
mn, struct mm_struct *mm)
>          * but disable translation.
>          */
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -       list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> +       list_for_each_entry(master_domain, &smmu_domain->devices,
> +                           devices_elm) {
> +               struct arm_smmu_master *master =3D master_domain->master;
>                 struct arm_smmu_cd target;
>                 struct arm_smmu_cd *cdptr;
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 7a0be7dd719793..51a1e7198fd1af 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2031,10 +2031,10 @@ static int arm_smmu_atc_inv_master(struct arm_smm=
u_master *master)
>  int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssi=
d,
>                             unsigned long iova, size_t size)
>  {
> +       struct arm_smmu_master_domain *master_domain;
>         int i;
>         unsigned long flags;
>         struct arm_smmu_cmdq_ent cmd;
> -       struct arm_smmu_master *master;
>         struct arm_smmu_cmdq_batch cmds;
>
>         if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_ATS))
> @@ -2062,7 +2062,10 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain=
 *smmu_domain, int ssid,
>         cmds.num =3D 0;
>
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -       list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> +       list_for_each_entry(master_domain, &smmu_domain->devices,
> +                           devices_elm) {
> +               struct arm_smmu_master *master =3D master_domain->master;
> +
>                 if (!master->ats_enabled)
>                         continue;
>
> @@ -2554,9 +2557,26 @@ static void arm_smmu_disable_pasid(struct arm_smmu=
_master *master)
>         pci_disable_pasid(pdev);
>  }
>
> +static struct arm_smmu_master_domain *
> +arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
> +                           struct arm_smmu_master *master)
> +{
> +       struct arm_smmu_master_domain *master_domain;
> +
> +       lockdep_assert_held(&smmu_domain->devices_lock);
> +
> +       list_for_each_entry(master_domain, &smmu_domain->devices,
> +                           devices_elm) {
> +               if (master_domain->master =3D=3D master)
> +                       return master_domain;
> +       }
> +       return NULL;
> +}
> +
>  static void arm_smmu_detach_dev(struct arm_smmu_master *master)
>  {
>         struct iommu_domain *domain =3D iommu_get_domain_for_dev(master->=
dev);
> +       struct arm_smmu_master_domain *master_domain;
>         struct arm_smmu_domain *smmu_domain;
>         unsigned long flags;
>
> @@ -2567,7 +2587,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_ma=
ster *master)
>         arm_smmu_disable_ats(master, smmu_domain);
>
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -       list_del_init(&master->domain_head);
> +       master_domain =3D arm_smmu_find_master_domain(smmu_domain, master=
);
> +       if (master_domain) {
> +               list_del(&master_domain->devices_elm);
> +               kfree(master_domain);
> +       }
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>
>         master->ats_enabled =3D false;
> @@ -2581,6 +2605,7 @@ static int arm_smmu_attach_dev(struct iommu_domain =
*domain, struct device *dev)
>         struct iommu_fwspec *fwspec =3D dev_iommu_fwspec_get(dev);
>         struct arm_smmu_device *smmu;
>         struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
> +       struct arm_smmu_master_domain *master_domain;
>         struct arm_smmu_master *master;
>         struct arm_smmu_cd *cdptr;
>
> @@ -2617,6 +2642,11 @@ static int arm_smmu_attach_dev(struct iommu_domain=
 *domain, struct device *dev)
>                         return -ENOMEM;
>         }
>
> +       master_domain =3D kzalloc(sizeof(*master_domain), GFP_KERNEL);
> +       if (!master_domain)
> +               return -ENOMEM;
> +       master_domain->master =3D master;
> +
>         /*
>          * Prevent arm_smmu_share_asid() from trying to change the ASID
>          * of either the old or new domain while we are working on it.
> @@ -2630,7 +2660,7 @@ static int arm_smmu_attach_dev(struct iommu_domain =
*domain, struct device *dev)
>         master->ats_enabled =3D arm_smmu_ats_supported(master);
>
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -       list_add(&master->domain_head, &smmu_domain->devices);
> +       list_add(&master_domain->devices_elm, &smmu_domain->devices);
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>
>         switch (smmu_domain->stage) {
> @@ -2949,7 +2979,6 @@ static struct iommu_device *arm_smmu_probe_device(s=
truct device *dev)
>         master->dev =3D dev;
>         master->smmu =3D smmu;
>         INIT_LIST_HEAD(&master->bonds);
> -       INIT_LIST_HEAD(&master->domain_head);
>         dev_iommu_priv_set(dev, master);
>
>         ret =3D arm_smmu_insert_master(smmu, master);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index ab0a6587e07ec8..c4b79bc52991be 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -695,7 +695,6 @@ struct arm_smmu_stream {
>  struct arm_smmu_master {
>         struct arm_smmu_device          *smmu;
>         struct device                   *dev;
> -       struct list_head                domain_head;
>         struct arm_smmu_stream          *streams;
>         /* Locked by the iommu core using the group mutex */
>         struct arm_smmu_ctx_desc_cfg    cd_table;
> @@ -729,12 +728,18 @@ struct arm_smmu_domain {
>
>         struct iommu_domain             domain;
>
> +       /* List of struct arm_smmu_master_domain */
>         struct list_head                devices;
>         spinlock_t                      devices_lock;
>
>         struct list_head                mmu_notifiers;
>  };
>
> +struct arm_smmu_master_domain {
> +       struct list_head devices_elm;
> +       struct arm_smmu_master *master;
> +};
> +
>  static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain=
 *dom)
>  {
>         return container_of(dom, struct arm_smmu_domain, domain);
> --
> 2.43.2
>
Reviewed-by: Michael Shavit <mshavit@google.com>
