Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB3C57864;
	Tue, 30 Jan 2024 08:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706604376; cv=none; b=p17RVQ0L989Mtom/ivfN11OJGvNOgJ4TcvibiAKs/8b3WBdMGdc7Rj7WnCqtxNJTsFqd4UMFD2FYcNdLTQOVCkzibH0UPExaY9GNfI5BWc365IDf/YQ46FfduSGTHi0Jw8KHfcvSB7remxmutatNknbwX8cCy8XzDJWwkAZO2RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706604376; c=relaxed/simple;
	bh=KGcaW18+wdP+tuNGfWjZaKNswZI7TQLnbQDs5XXUCP8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jCQzmzCTFK0VrVUUcqsxO7SLeSOa8mZk+He4hsW0u3hxwOaHVgOYYl3/ktrtkFr8vnoDFJdrhpePP8NuRaF1tI/Z4urr6tNumJrngQ6RlCdnuw9Q3GLvQSmwx7Pd8N75Bkl/5OvD+TdIV/EoA2iX4dTuNu0UBQ5QBFB9ZL2bOU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TPJb23HMJz6JB1k;
	Tue, 30 Jan 2024 16:42:54 +0800 (CST)
Received: from lhrpeml500006.china.huawei.com (unknown [7.191.161.198])
	by mail.maildlp.com (Postfix) with ESMTPS id D17E7140C98;
	Tue, 30 Jan 2024 16:46:10 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 08:46:10 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Tue, 30 Jan 2024 08:46:10 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
CC: Eric Auger <eric.auger@redhat.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, Michael Shavit
	<mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v4 01/27] iommu/arm-smmu-v3: Check that the RID domain is
 S1 in SVA
Thread-Topic: [PATCH v4 01/27] iommu/arm-smmu-v3: Check that the RID domain is
 S1 in SVA
Thread-Index: AQHaUIOwEvsu/yJdMEqnvQfiRYY9c7DyDZ2g
Date: Tue, 30 Jan 2024 08:46:10 +0000
Message-ID: <b3a7b564dcef4b518af0493155b67cc6@huawei.com>
References: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <1-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0



> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, January 26, 2024 6:15 PM
> To: iommu@lists.linux.dev; Joerg Roedel <joro@8bytes.org>; linux-arm-
> kernel@lists.infradead.org; Robin Murphy <robin.murphy@arm.com>; Will
> Deacon <will@kernel.org>
> Cc: Eric Auger <eric.auger@redhat.com>; Jean-Philippe Brucker <jean-
> philippe@linaro.org>; Moritz Fischer <mdf@kernel.org>; Michael Shavit
> <mshavit@google.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Subject: [PATCH v4 01/27] iommu/arm-smmu-v3: Check that the RID domain is
> S1 in SVA
>=20
> This code only works if the RID domain is a S1 domain and has already
> installed the cdtable.
>=20
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 05722121f00e70..b4549d698f3569 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -387,7 +387,13 @@ static int __arm_smmu_sva_bind(struct device *dev,
> struct mm_struct *mm)
>  	struct arm_smmu_bond *bond;
>  	struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
>  	struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
> -	struct arm_smmu_domain *smmu_domain =3D
> to_smmu_domain(domain);
> +	struct arm_smmu_domain *smmu_domain;
> +
> +	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
> +		return -ENODEV;
> +	smmu_domain =3D to_smmu_domain(iommu_get_domain_for_dev(dev));

We already have the iommu_domain from above.

> +	if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_S1)
> +		return -ENODEV;

I think we need to do the above checks in arm_smmu_sva_remove_dev_pasid()
as well.

Thanks,
Shameer
