Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E863FB17
	for <patches@lists.linux.dev>; Wed, 13 Mar 2024 12:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710332196; cv=none; b=OB4u6Rfccaggq2w/Mrt7AoitzPeKxV8LcWnagrKRPRf+nQCF5Eu9hLElM/q6MDZfWOXat4EwtWUwY2oWH0ZUKT6eCkWgu0GRT11EmjpIOk8WOELtxNDyPt2wZtndVbJ9l2v9tlimaTAu9n6gRqpzx/PsdSRjE+ejMHKQpLaEB6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710332196; c=relaxed/simple;
	bh=w/UkJqZx0+qbMq9vIxxvT9MqRUVJpm/VyAiU/3tjtcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LRD4WXzBJY6iJYjsLyRAgJh1vrIM3tAW5/2DqEUDM4sC8EQaUSCGJmNtQLSYQqjy8DdLi6hbBpPUPC9rBOjVkh2eHajSQBoB7CQs//nG6aaLpDtczaX/qe/IEEJe2BNhh2jKx5+wmkFL9Ab0+sJGAJRAinnEEyliYEDUXJS6638=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GIuXbhsI; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GIuXbhsI"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-428405a0205so261861cf.1
        for <patches@lists.linux.dev>; Wed, 13 Mar 2024 05:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710332194; x=1710936994; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EVdmJZss4pChUCgxVts8qpcnh//A1w80+RPNXQA7KU=;
        b=GIuXbhsIwZG7uOvjHaVBdQBpIs9q6cUZ7wV+k6XE9Go82Xw7ZbZNR//oKRWKZmZ+U1
         LYKgErDxuENLqD1OaswBaweKA0HsD8c8iyV7kOzXTTvnPcCrDca4mr7Eb5dgJ2L+bjsd
         ftcpog7nkQb/4ajxcIm2KOqqDT636JkFzflck9Z9qcyW0i3VFvjTQVCYjhdfhxEpmxwA
         cUUrt6wBOZ2/S6yGu22Sl9+NjqQoMi8dflZQxK4qyZQLDV4uQ1q5MMQgB+RmuewTouYp
         iFlqbjXViZHedbWYSyjUL7x4LCb953JTOGGOWi3FBEIvXngoFuQPPAYwxAJ/vAqGzewX
         LC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710332194; x=1710936994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EVdmJZss4pChUCgxVts8qpcnh//A1w80+RPNXQA7KU=;
        b=etmRkS0bc8n6V27JvpwqPgGw0bALaimfeGW2ecHFBN6fCNqUdXVA/TWhAsODzeWGV8
         PhGAp9tSBZH5y1HBIKScx2ke8Vpp7Yic9rBpjlqNgqK8nDXJOJvVU59u8sUfFcezvDZE
         0tNOyOK+/qBL0YWxGWTiiPbMXP//Wk2+xYfDcBHi22GL+F1GHMaEhWp32Ky7RAJaAue1
         lbdR9InQDquqPMrNHbmpZ7n5riWHdSgosXfH7L7ZOQouZPf4S4qqqHHWasV8boPIVkGb
         PYvpLIsp5k2mxUD66sNGBWE+LDrZMa5DnxnUXEz6aGxjisZUBdoZYDem8QSbuQsKWjjB
         lTZw==
X-Forwarded-Encrypted: i=1; AJvYcCV06jlzTXDRayN1D7n2ZsYS9/5eff+cPX69nNQFAGIz9g2aUJxxccX5CcWeelrt1OgHAw2qkQ+SWI7bYIJ53PhikxPbk/E0Pw==
X-Gm-Message-State: AOJu0YwGKJ1himtkGrQKTgKTwrPOZ2FeG95VR0whhNn+XTBZ3wcyfdGA
	2z5Dy7GYfnG5jWPgwEuW5/DqBqOJs9nCfOUC96g2UDvtFlUWo4TxPV+0S+X8uexGcAlPNopBZCh
	MvD/IDfjoseRc3u3xyhffpv6lMRydnkOzK8q5
X-Google-Smtp-Source: AGHT+IFPFaRuah0y+5hvgjxFJHH654TyA2LF1EZuJewxZs0nS3L6K76nZEDX7El7F1wQc5i0+qYPeE4ehCd3GZihrNw=
X-Received: by 2002:ac8:53d2:0:b0:42f:a3c:2d44 with SMTP id
 c18-20020ac853d2000000b0042f0a3c2d44mr212682qtq.5.1710332194074; Wed, 13 Mar
 2024 05:16:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <8-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <8-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Wed, 13 Mar 2024 20:15:58 +0800
Message-ID: <CAKHBV24+-n6MCF3YCv6NS1nUWUDxXVTmTHnduQk_bvEcYYFRnw@mail.gmail.com>
Subject: Re: [PATCH v5 08/27] iommu/arm-smmu-v3: Move allocation of the
 cdtable into arm_smmu_get_cd_ptr()
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
> No reason to force callers to do two steps. Make arm_smmu_get_cd_ptr()
> able to return an entry in all cases except OOM.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index e25dbb982feeee..2dd6cb17112e98 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -106,6 +106,7 @@ static struct arm_smmu_option_prop arm_smmu_options[]=
 =3D {
>
>  static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
>                                     struct arm_smmu_device *smmu);
> +static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
>
>  static void parse_driver_options(struct arm_smmu_device *smmu)
>  {
> @@ -1231,6 +1232,11 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm=
_smmu_master *master,
>         struct arm_smmu_device *smmu =3D master->smmu;
>         struct arm_smmu_ctx_desc_cfg *cd_table =3D &master->cd_table;
>
> +       if (!master->cd_table.cdtab) {
> +               if (arm_smmu_alloc_cd_tables(master))
> +                       return NULL;
> +       }
> +
>         if (cd_table->s1fmt =3D=3D STRTAB_STE_0_S1FMT_LINEAR)
>                 return (struct arm_smmu_cd *)(cd_table->cdtab +
>                                               ssid * CTXDESC_CD_DWORDS);
> @@ -2719,12 +2725,6 @@ static int arm_smmu_attach_dev(struct iommu_domain=
 *domain, struct device *dev)
>                 struct arm_smmu_cd target_cd;
>                 struct arm_smmu_cd *cdptr;
>
> -               if (!master->cd_table.cdtab) {
> -                       ret =3D arm_smmu_alloc_cd_tables(master);
> -                       if (ret)
> -                               goto out_list_del;
> -               }
> -
>                 cdptr =3D arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
>                 if (!cdptr) {
>                         ret =3D -ENOMEM;
> --
> 2.43.2
>
Reviewed-by: Michael Shavit <mshavit@google.com>
