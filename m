Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45272152DEC;
	Mon, 29 Jan 2024 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706540850; cv=none; b=cg4ospYoJJQQyRGxu16qypP1EBkLMzA4ztavAPZLescfBlz2FNGOo9Rh28sG8KJ+JBiDBDlX3/rDh4CVbG4urptSl0EsDrKnEq/dEYMEf3V6ehdnGC/1Hk8sldMl8OfyD7KN/jr1dDIQdR5tYGj5irx28MT8n9ztIhebUhmVo90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706540850; c=relaxed/simple;
	bh=MOVnGTNVe1IORp4sptKL0gw7MufMThZhvd70TOeOF9A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cxXb9bQgfLDLnVfofP5MSZOOrHH/Ek0/dkx3H+HAIZuVCAyRosVdrM5LtVS4yYRe0Ug8mosNSTqyeBMQM80vqcF9rgx+/0qDWxTIcYkUPtswFiCeAMsFl6fM1nWkGH0zPuGgcnGszR3GwelWRU+2m9TiYP6dr2kNvkYq/U5uhoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TNs5M0FRmz6JBRK;
	Mon, 29 Jan 2024 23:04:07 +0800 (CST)
Received: from lhrpeml100005.china.huawei.com (unknown [7.191.160.25])
	by mail.maildlp.com (Postfix) with ESMTPS id BC9A4140136;
	Mon, 29 Jan 2024 23:07:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100005.china.huawei.com (7.191.160.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 15:07:21 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Mon, 29 Jan 2024 15:07:21 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
CC: Moritz Fischer <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v4 03/16] iommu/arm-smmu-v3: Move
 arm_smmu_rmr_install_bypass_ste()
Thread-Topic: [PATCH v4 03/16] iommu/arm-smmu-v3: Move
 arm_smmu_rmr_install_bypass_ste()
Thread-Index: AQHaT+pKiKkHv/nblEGt84Ts1FQwm7Dw5+zw
Date: Mon, 29 Jan 2024 15:07:21 +0000
Message-ID: <e1b1a2fbaf3f4312a6d6c27afdfaf7fd@huawei.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <3-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <3-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
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
> Sent: Thursday, January 25, 2024 11:57 PM
> To: iommu@lists.linux.dev; Joerg Roedel <joro@8bytes.org>; linux-arm-
> kernel@lists.infradead.org; Robin Murphy <robin.murphy@arm.com>; Will
> Deacon <will@kernel.org>
> Cc: Moritz Fischer <mdf@kernel.org>; Moritz Fischer <moritzf@google.com>;
> Michael Shavit <mshavit@google.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Subject: [PATCH v4 03/16] iommu/arm-smmu-v3: Move
> arm_smmu_rmr_install_bypass_ste()
>=20
> Logically arm_smmu_init_strtab_linear() is the function that allocates an=
d
> populates the stream table with the initial value of the STEs. After this
> function returns the stream table should be fully ready.
>=20
> arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to for=
ce
> any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
> ensures there is no disruption to the identity mapping during boot.
>=20
> Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab_linear(),
> it already executes immediately after arm_smmu_init_strtab_linear().
>=20
> No functional change intended.

I think this actually changes the behavior and will cause regression as we
now install rmr  sids only for linear stream table not for SMMUv3 with=20
2-level stream table supported.

Please check.

Thanks,
Shameer

>=20
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 38bcb4ed1fccc1..df8fc7b87a7907 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -102,6 +102,8 @@ static struct arm_smmu_option_prop
> arm_smmu_options[] =3D {
>  	{ 0, NULL},
>  };
>=20
> +static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device
> *smmu);
> +
>  static void parse_driver_options(struct arm_smmu_device *smmu)
>  {
>  	int i =3D 0;
> @@ -3250,6 +3252,9 @@ static int arm_smmu_init_strtab_linear(struct
> arm_smmu_device *smmu)
>  	cfg->strtab_base_cfg =3D reg;
>=20
>  	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
> +
> +	/* Check for RMRs and install bypass STEs if any */
> +	arm_smmu_rmr_install_bypass_ste(smmu);
>  	return 0;
>  }
>=20
> @@ -4063,9 +4068,6 @@ static int arm_smmu_device_probe(struct
> platform_device *pdev)
>  	/* Record our private device structure */
>  	platform_set_drvdata(pdev, smmu);
>=20
> -	/* Check for RMRs and install bypass STEs if any */
> -	arm_smmu_rmr_install_bypass_ste(smmu);
> -
>  	/* Reset the device */
>  	ret =3D arm_smmu_device_reset(smmu, bypass);
>  	if (ret)
> --
> 2.43.0

