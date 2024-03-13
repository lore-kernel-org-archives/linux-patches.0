Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291CC3F9E8
	for <patches@lists.linux.dev>; Wed, 13 Mar 2024 11:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710331065; cv=none; b=b+u+ttR9DRIuc2yTeNNDhaxFMsOn0yyxW4oSGI3neUg+2hjwDijjBADw6xF9kVB6ZMUxrdszPCg9SkG1LpPRU/oy40NkWYhA+53QVGKg9yCnwHodRO2xAcOAuLD9CUGyStMk9B8oqysC1fWu4s+CDNSxdsNnyECwzpgOt7Rc3xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710331065; c=relaxed/simple;
	bh=e318kagEYXlDSDg3WDo5MGGdLNEA36rAw6KQwBrs3/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ygk6tGbwU2n+n0lb4ecVVXz+AuS+k7HSAeAz9LjzMNthQcAwhTbdmcEubgH5/8GMN7TzwYdi3ADo2oEzT/njCEavT6Bixe5ND/l2n17YKuwdy0T8usSwYrA8KeISTfgdl6x/tsQOD0vG8taxxJ4SO379lQRdEjvXRx4nFRIqf2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IdavEYEk; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IdavEYEk"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-43095dcbee6so55171cf.0
        for <patches@lists.linux.dev>; Wed, 13 Mar 2024 04:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710331063; x=1710935863; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QcuhZT7YdcGYX4RrD7oEdKK2DG70cQRUmttKwI9oJFo=;
        b=IdavEYEkE712NwmAMKAgnuBX5H5ljWJavU/I1Q3+p+gpZ0ql/7x9zWg8b5YmQVCbd0
         q0RBrjKYU7tQXaMJhevF0cQuGtXMmK6eGJPsBA9VnGsyRYwYwdIUod7wuF6p6A+0PAKR
         vvWW4qs5bVNq48trjolQGqzwmVqgdQj9PPuWPaJi5YsYj8lIN416tYlfdXOFgZ9bXWBX
         UIdufPPQIrSKLonTXzFbU1AfIKt2hwJPjEpBalXxQ3pT8GyBOY2rWoWfKNjB85rlJPk/
         jfkz1LecMrQZ7Px/+83rdKHRyHRm87arw2PEfLUcj7Ma7tMWHNJBh1ywWqckw7A8QQe/
         tp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710331063; x=1710935863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QcuhZT7YdcGYX4RrD7oEdKK2DG70cQRUmttKwI9oJFo=;
        b=Y1fiubX2x5GVyHhMB1rbjpe8eE14hfJSWP/axJE0Ti0F1uP7RSZC1hn4uBq7FCaGXc
         h/fNQHTSYt8el1ANEjJGLm0h4OOecwFiBBwTtN9dyY7nO66pd8y3/7MKEEDaKgJgQdRo
         ivQa9ZiL+XgxY56RdWM20BIndR2O3j5E90zAWLokiwQwbbs6f/uzCgWsQOave/CI2Rbg
         DXSzqaKDcyeDuxA55D2VJNnxriV1XeF0qvxaiGnb44TkpRUUJpXyRrEZmD9iH7LQth1t
         NBp0AXqB3y1+/ro3WYO3VYEcdZbaEkjXCHVIK5xaisAL6+9HSaPmyYbc61zeh7tPYTEp
         YgxQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1DsddrSgmor2fyLuBdJph+GS6kdttU9QZXpSyUUu/gNW3+rhQ92wtMJwQebAV7zmc6WpjUIcJjRDdYIvzDHirQgGFuhHw2A==
X-Gm-Message-State: AOJu0YyZcd6zpR3hNbiPZkvJschrkCBX4pBJ2ZXG9oqeUD+eYz8gmaVR
	KHcdoEoMnuUJxVZl6KWGKdxLHs1xgD/pGTgTyM9mXU7+S+kBGTzPwdPNqn9ffPPejNxaWvwLwTp
	DlZEF5w6xgVA94Ak1rlNev6rxrZgAibHrqy8W
X-Google-Smtp-Source: AGHT+IFWgrSB1cqH8Z4fnV4y4/PotcsnTay6f7iQVxmRrcZ1z2xbrw4FZLkQ4nyxzzXEDf1olnTINHFXk8v8+Rwvgn0=
X-Received: by 2002:ac8:661a:0:b0:42e:ef82:231b with SMTP id
 c26-20020ac8661a000000b0042eef82231bmr218382qtp.23.1710331062788; Wed, 13 Mar
 2024 04:57:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <6-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <6-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Wed, 13 Mar 2024 19:57:05 +0800
Message-ID: <CAKHBV247j4bHsH23AQ6tJbDnwo3-Jr0NAwZtA9+in_wZDikrXA@mail.gmail.com>
Subject: Re: [PATCH v5 06/27] iommu/arm-smmu-v3: Consolidate clearing a CD
 table entry
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
> A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.
>
> If we are clearing an entry and for some reason it is not already
> allocated in the CD table then something has gone wrong.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 20 ++++++++++++++-----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
>  3 files changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 347c2fdd865c1a..bb9bb6fd7914ce 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -558,7 +558,7 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domai=
n *domain,
>
>         mutex_lock(&sva_lock);
>
> -       arm_smmu_write_ctx_desc(master, id, NULL);
> +       arm_smmu_clear_cd(master, id);
>
>         list_for_each_entry(t, &master->bonds, list) {
>                 if (t->mm =3D=3D mm) {
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 237fd6d92c880b..3fb4a1523d1d3f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1303,6 +1303,19 @@ static void arm_smmu_write_cd_entry(struct arm_smm=
u_master *master, int ssid,
>         arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data=
);
>  }
>
> +void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
> +{
> +       struct arm_smmu_cd target =3D {};
> +       struct arm_smmu_cd *cdptr;
> +
> +       if (!master->cd_table.cdtab)
> +               return;
> +       cdptr =3D arm_smmu_get_cd_ptr(master, ssid);
> +       if (WARN_ON(!cdptr))
> +               return;
> +       arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
> +}
> +
>  int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>                             struct arm_smmu_ctx_desc *cd)
>  {
> @@ -2702,9 +2715,7 @@ static int arm_smmu_attach_dev(struct iommu_domain =
*domain, struct device *dev)
>         case ARM_SMMU_DOMAIN_S2:
>                 arm_smmu_make_s2_domain_ste(&target, master, smmu_domain)=
;
>                 arm_smmu_install_ste_for_dev(master, &target);
> -               if (master->cd_table.cdtab)
> -                       arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> -                                                     NULL);
> +               arm_smmu_clear_cd(master, IOMMU_NO_PASID);
>                 break;
>         }
>
> @@ -2752,8 +2763,7 @@ static int arm_smmu_attach_dev_ste(struct device *d=
ev,
>          * arm_smmu_domain->devices to avoid races updating the same cont=
ext
>          * descriptor from arm_smmu_share_asid().
>          */
> -       if (master->cd_table.cdtab)
> -               arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
> +       arm_smmu_clear_cd(master, IOMMU_NO_PASID);
>         return 0;
>  }
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index 7078ed569fd4d3..87a7b57f566fbc 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -749,6 +749,8 @@ extern struct xarray arm_smmu_asid_xa;
>  extern struct mutex arm_smmu_asid_lock;
>  extern struct arm_smmu_ctx_desc quiet_cd;
>
> +void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
> +
>  int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssi=
d,
>                             struct arm_smmu_ctx_desc *cd);
>  void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
> --
> 2.43.2
>
>
Reviewed-by: Michael Shavit <mshavit@google.com>
