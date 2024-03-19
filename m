Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63864208BA
	for <patches@lists.linux.dev>; Tue, 19 Mar 2024 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710859972; cv=none; b=eHxOG1ZQVNGWumEkyk1OrA17Hg/CjXVOkckLQUIUF5WcgDApNxCxW1Z5ERn7RHC00PLn0DQnM9COeFpMiFKR+ayPH8ucOnnvievxCPEYjnS0dghg6/6bMAJckU+HxygL4tpRIagimM3m5+wCf4yRomSPJCvqQXw6THvqCtjx6rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710859972; c=relaxed/simple;
	bh=50maL6MT4AmNwyc5uXEHxZUumYySzQQtu4H84HyY6nU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XqosuLTMxbM3RH7IQRlsdPB1TzjBhrRxhWnQf86HDjo3OtRXNBDGKNKDPkUan9duoCOU5nb2fyjDHZkieV8ejVYPUWhYAA33guQSDUgdoxUgqDHRgdh2FXISPPwGXn47H24Ty3USBfbztQGBIbm7bOkGFYns6oscXjV8XGApAV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E/BCJrth; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E/BCJrth"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-430d3fcc511so240591cf.1
        for <patches@lists.linux.dev>; Tue, 19 Mar 2024 07:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710859969; x=1711464769; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJ8ChgJnUWxF2RKWqu8FAxVV0Hj41kixdS2hEOp7xsY=;
        b=E/BCJrthalLKk6wtgxJrX7F6ByLHPSJVrzohubMs9QccGxm+xWv8ztJ5ZFyMghdZJC
         uVZbTYs97GRoMm6tzeH0UouN6rAVodq5ShoafkXipQ2EejVSRDHPMTkMJ8pQtL7ewvsh
         NqSYCLHEbjgo++Svdc+RLeLBoKtmK50ixS4VQLVM/Fd3jso/4t9PrBfwE8QXOeGzGz7E
         X828fvyRDKCfaNtQr4xcjSgUgVmI1ragSizy1H+TgsiAMZJ4s8+V9bcmlqaYErVCf1Vz
         4t821tINxO+uTbc5Wu4xis+D6Um/sl2hoWn8YLJfmXprAI42bC7ZSQLgTHOM/1AXy6NQ
         M5pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710859969; x=1711464769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJ8ChgJnUWxF2RKWqu8FAxVV0Hj41kixdS2hEOp7xsY=;
        b=gzua2NvRQWg2QoTs7euEGwfjEFFDmlD8/iIEUFaPCELtP/SHnQGueD81E/WjKDk0RD
         RunzYJhTOfgQPf1+hVhje9dvV7UxSEh2Nr27gNXednJdZ2VQVRj6OM36Cye2kf83ucLx
         HYopoETAAUr3Gxz9XJodnpTsZz4Px6HoWeJtN5yydVvkqdI4m8td/qlJicToyE4KD26v
         NG8+ItQ3skLMgfzk+Vl9HT/Foqf2oDbtwQBQqCFQWM6zDhPqrrxa3/tHKf8DsOf/3k8E
         wg74yZ2S5A5DKZFK8Yn7M3pKa1H7UdYrDCBw25dql1jJsUATvDECRAJhShtTmUxMFs6j
         g0zw==
X-Forwarded-Encrypted: i=1; AJvYcCW6fSz49+2LI8AF9E8ukI8JJT6Gw1XybHm8IsmqH5aZr9MauMeFkWG9+tcXpcMioSkOyKTdPo3i+w4GZWh5Qnwiy5XYPKJ3nw==
X-Gm-Message-State: AOJu0Yz1sOIq7pWvhw69Xet58BeWBoyH2AbVTTpNAV6sfAGTT/LJtz4P
	f0R8CqoaNaOpZVxUdnRsTAAqHHlYUsnAULbyPzp+2GQrh3biNII9CXuDVE45g6GEy/W2h5kkp+q
	zj/9d+lcbh8p97zFbbMZdENrboYP3trNCGERb
X-Google-Smtp-Source: AGHT+IEuC2giTpnRTu8dKl3oA9RxOiGLrvBMmIT31TyTUeXgIeRZFN31AqtvhaF1AD8HyI7jqz7FmpL2c6ypMFdQAEY=
X-Received: by 2002:ac8:58cf:0:b0:430:ed72:bc2b with SMTP id
 u15-20020ac858cf000000b00430ed72bc2bmr158076qta.22.1710859969087; Tue, 19 Mar
 2024 07:52:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <18-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <18-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Tue, 19 Mar 2024 22:52:11 +0800
Message-ID: <CAKHBV24C7Vesum8NzkOvTHiQy9F6K4fFFDWfWFHTjbfgiL5EaQ@mail.gmail.com>
Subject: Re: [PATCH v5 18/27] iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
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
> Currently the SVA domain is a naked struct iommu_domain, allocate a struc=
t
> arm_smmu_domain instead.
>
> This is necessary to be able to use the struct arm_master_domain
> mechanism.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 19 ++++++-----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 34 +++++++++++--------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 ++-
>  3 files changed, 33 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 82b9c4d4061c3d..d633316f2e45bc 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -654,7 +654,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_do=
main *domain,
>
>  static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
>  {
> -       kfree(domain);
> +       kfree(to_smmu_domain(domain));
>  }
>
>  static const struct iommu_domain_ops arm_smmu_sva_domain_ops =3D {
> @@ -662,14 +662,17 @@ static const struct iommu_domain_ops arm_smmu_sva_d=
omain_ops =3D {
>         .free                   =3D arm_smmu_sva_domain_free
>  };
>
> -struct iommu_domain *arm_smmu_sva_domain_alloc(void)
> +struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned type)
>  {
> -       struct iommu_domain *domain;
> +       struct arm_smmu_domain *smmu_domain;
>
> -       domain =3D kzalloc(sizeof(*domain), GFP_KERNEL);
> -       if (!domain)
> -               return NULL;
> -       domain->ops =3D &arm_smmu_sva_domain_ops;
> +       if (type !=3D IOMMU_DOMAIN_SVA)
> +               return ERR_PTR(-EOPNOTSUPP);
>
> -       return domain;
> +       smmu_domain =3D arm_smmu_domain_alloc();
> +       if (IS_ERR(smmu_domain))
> +               return ERR_CAST(smmu_domain);
> +       smmu_domain->domain.ops =3D &arm_smmu_sva_domain_ops;
> +
> +       return &smmu_domain->domain;
>  }
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index dd7f841cd19b3c..2db2b822292a87 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2291,23 +2291,10 @@ static bool arm_smmu_capable(struct device *dev, =
enum iommu_cap cap)
>         }
>  }
>
> -static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
> -{
> -
> -       if (type =3D=3D IOMMU_DOMAIN_SVA)
> -               return arm_smmu_sva_domain_alloc();
> -       return ERR_PTR(-EOPNOTSUPP);
> -}
> -
> -static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *=
dev)
> +struct arm_smmu_domain *arm_smmu_domain_alloc(void)

Consider renaming arm_smmu_domain_free as well since there's asymmetry
between arm_smmu_domain_alloc and arm_smmu_domain_free that could be a
little confusing:
1. arm_smmu_domain_alloc is shared between arm_smmu_sva_domain_alloc
and arm_smmu_domain_alloc_paging
2. arm_smmu_domain_free is only used by paging domains, with SVA
domains freed through arm_smmu_sva_domain_free.


>  {
>         struct arm_smmu_domain *smmu_domain;
>
> -       /*
> -        * Allocate the domain and initialise some of its data structures=
.
> -        * We can't really do anything meaningful until we've added a
> -        * master.
> -        */
>         smmu_domain =3D kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
>         if (!smmu_domain)
>                 return ERR_PTR(-ENOMEM);
> @@ -2317,6 +2304,23 @@ static struct iommu_domain *arm_smmu_domain_alloc_=
paging(struct device *dev)
>         spin_lock_init(&smmu_domain->devices_lock);
>         INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
>
> +       return smmu_domain;
> +}
> +
> +static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *=
dev)
> +{
> +       struct arm_smmu_domain *smmu_domain;
> +
> +       smmu_domain =3D arm_smmu_domain_alloc();
> +       if (IS_ERR(smmu_domain))
> +               return ERR_CAST(smmu_domain);
> +
> +       /*
> +        * Allocate the domain and initialise some of its data structures=
.
> +        * We can't really do anything meaningful until we've added a
> +        * master.
> +        */
> +
>         if (dev) {
>                 struct arm_smmu_master *master =3D dev_iommu_priv_get(dev=
);
>                 int ret;
> @@ -3288,7 +3292,7 @@ static struct iommu_ops arm_smmu_ops =3D {
>         .identity_domain        =3D &arm_smmu_identity_domain,
>         .blocked_domain         =3D &arm_smmu_blocked_domain,
>         .capable                =3D arm_smmu_capable,
> -       .domain_alloc           =3D arm_smmu_domain_alloc,
> +       .domain_alloc           =3D arm_smmu_sva_domain_alloc,
>         .domain_alloc_paging    =3D arm_smmu_domain_alloc_paging,
>         .probe_device           =3D arm_smmu_probe_device,
>         .release_device         =3D arm_smmu_release_device,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index 7e1f6af4ce4e79..c47e07d695bef2 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -759,6 +759,8 @@ static inline struct arm_smmu_domain *to_smmu_domain(=
struct iommu_domain *dom)
>  extern struct xarray arm_smmu_asid_xa;
>  extern struct mutex arm_smmu_asid_lock;
>
> +struct arm_smmu_domain *arm_smmu_domain_alloc(void);
> +
>  void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
>  struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
>                                         u32 ssid);
> @@ -791,7 +793,7 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master=
 *master);
>  int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
>  bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
>  void arm_smmu_sva_notifier_synchronize(void);
> -struct iommu_domain *arm_smmu_sva_domain_alloc(void);
> +struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned int type);
>  void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
>                                    struct device *dev, ioasid_t id);
>  #else /* CONFIG_ARM_SMMU_V3_SVA */
> --
> 2.43.2
>
>
Reviewed-by: Michael Shavit <mshavit@google.com>
