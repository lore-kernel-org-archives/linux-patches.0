Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67276F088;
	Mon, 29 Jan 2024 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706551914; cv=none; b=YDkmsuL9I3a6ZCAaKYJ3xxt1IvozCj4KjU2g+p6ELuXWLqBiaIg6NVpReqqp+VRshZhExzIb4yoLRbG92vJ3/B3Z41byhhflxtexC06esrg25+ctV1PbIee2uI1gr8I3v4G7y0rgccxkwwMgA+MTANQ/oF8vLUb4AOGu3e6TVyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706551914; c=relaxed/simple;
	bh=E3lTORM7PSDD85xmwMqTI3B8iC4Y4+WeKwWAe4BQ/B0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Medhgyyjt2AVG615pVFrny+fAXuWKGdP588ER9Oxg3Bucw8vq8NywpdfjpUwH93HfVTi66AM63lnyBwIlxKz4heaZC6Qze1uP87WtofFJK13fbcIbh3JwsSjM4lTVZNf/FMbsgi51K+B+bvxLLJ8R+lZU0ORS2XAipma4/xI68E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TNxBN5JlSz6K95t;
	Tue, 30 Jan 2024 02:08:44 +0800 (CST)
Received: from lhrpeml100006.china.huawei.com (unknown [7.191.160.224])
	by mail.maildlp.com (Postfix) with ESMTPS id C80621400D7;
	Tue, 30 Jan 2024 02:11:48 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100006.china.huawei.com (7.191.160.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 18:11:48 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Mon, 29 Jan 2024 18:11:48 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
CC: Moritz Fischer <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v4 12/16] iommu/arm-smmu-v3: Add a global static IDENTITY
 domain
Thread-Topic: [PATCH v4 12/16] iommu/arm-smmu-v3: Add a global static IDENTITY
 domain
Thread-Index: AQHaT+pNVhHFEhXMHk+FZtmV7qYxyLDxFnkA
Date: Mon, 29 Jan 2024 18:11:48 +0000
Message-ID: <2a828e481416405fb3a4cceb9e075a59@huawei.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <12-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <12-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
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
> Subject: [PATCH v4 12/16] iommu/arm-smmu-v3: Add a global static
> IDENTITY domain
>=20
> Move to the new static global for identity domains. Move all the logic ou=
t
> of arm_smmu_attach_dev into an identity only function.
>=20
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 82 +++++++++++++++--
> ----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
>  2 files changed, 58 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index f08cfa9b90b3eb..d35bf9655c9b1b 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2226,8 +2226,7 @@ static struct iommu_domain
> *arm_smmu_domain_alloc(unsigned type)
>  		return arm_smmu_sva_domain_alloc();
>=20
>  	if (type !=3D IOMMU_DOMAIN_UNMANAGED &&
> -	    type !=3D IOMMU_DOMAIN_DMA &&
> -	    type !=3D IOMMU_DOMAIN_IDENTITY)
> +	    type !=3D IOMMU_DOMAIN_DMA)
>  		return NULL;
>=20
>  	/*
> @@ -2335,11 +2334,6 @@ static int arm_smmu_domain_finalise(struct
> iommu_domain *domain)
>  	struct arm_smmu_domain *smmu_domain =3D
> to_smmu_domain(domain);
>  	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
>=20
> -	if (domain->type =3D=3D IOMMU_DOMAIN_IDENTITY) {
> -		smmu_domain->stage =3D ARM_SMMU_DOMAIN_BYPASS;
> -		return 0;
> -	}
> -
>  	/* Restrict the stage to what we can actually support */
>  	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
>  		smmu_domain->stage =3D ARM_SMMU_DOMAIN_S2;
> @@ -2537,7 +2531,7 @@ static void arm_smmu_detach_dev(struct
> arm_smmu_master *master)
>  	struct arm_smmu_domain *smmu_domain;
>  	unsigned long flags;
>=20
> -	if (!domain)
> +	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
>  		return;
>=20
>  	smmu_domain =3D to_smmu_domain(domain);
> @@ -2600,15 +2594,7 @@ static int arm_smmu_attach_dev(struct
> iommu_domain *domain, struct device *dev)
>=20
>  	arm_smmu_detach_dev(master);
>=20
> -	/*
> -	 * The SMMU does not support enabling ATS with bypass. When the
> STE is
> -	 * in bypass (STE.Config[2:0] =3D=3D 0b100), ATS Translation Requests a=
nd
> -	 * Translated transactions are denied as though ATS is disabled for
> the
> -	 * stream (STE.EATS =3D=3D 0b00), causing F_BAD_ATS_TREQ and
> -	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
> -	 */
> -	if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_BYPASS)
> -		master->ats_enabled =3D arm_smmu_ats_supported(master);
> +	master->ats_enabled =3D arm_smmu_ats_supported(master);
>=20
>  	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>  	list_add(&master->domain_head, &smmu_domain->devices);
> @@ -2645,13 +2631,6 @@ static int arm_smmu_attach_dev(struct
> iommu_domain *domain, struct device *dev)
>  			arm_smmu_write_ctx_desc(master,
> IOMMU_NO_PASID,
>  						      NULL);
>  		break;
> -	case ARM_SMMU_DOMAIN_BYPASS:
> -		arm_smmu_make_bypass_ste(&target);
> -		arm_smmu_install_ste_for_dev(master, &target);
> -		if (master->cd_table.cdtab)
> -			arm_smmu_write_ctx_desc(master,
> IOMMU_NO_PASID,
> -						      NULL);
> -		break;
>  	}
>=20
>  	arm_smmu_enable_ats(master, smmu_domain);
> @@ -2667,6 +2646,60 @@ static int arm_smmu_attach_dev(struct
> iommu_domain *domain, struct device *dev)
>  	return ret;
>  }
>=20
> +static int arm_smmu_attach_dev_ste(struct device *dev,
> +				   struct arm_smmu_ste *ste)
> +{
> +	struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> +
> +	if (arm_smmu_master_sva_enabled(master))
> +		return -EBUSY;
> +
> +	/*
> +	 * Do not allow any ASID to be changed while are working on the STE,
> +	 * otherwise we could miss invalidations.
> +	 */
> +	mutex_lock(&arm_smmu_asid_lock);
> +
> +	/*
> +	 * The SMMU does not support enabling ATS with bypass/abort.
> When the
> +	 * STE is in bypass (STE.Config[2:0] =3D=3D 0b100), ATS Translation
> Requests
> +	 * and Translated transactions are denied as though ATS is disabled
> for
> +	 * the stream (STE.EATS =3D=3D 0b00), causing F_BAD_ATS_TREQ and
> +	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
> +	 */
> +	arm_smmu_detach_dev(master);
> +
> +	arm_smmu_install_ste_for_dev(master, ste);
> +	mutex_unlock(&arm_smmu_asid_lock);
> +
> +	/*
> +	 * This has to be done after removing the master from the
> +	 * arm_smmu_domain->devices to avoid races updating the same
> context
> +	 * descriptor from arm_smmu_share_asid().
> +	 */
> +	if (master->cd_table.cdtab)
> +		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> NULL);
> +	return 0;
> +}
> +
> +static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
> +					struct device *dev)
> +{
> +	struct arm_smmu_ste ste;
> +
> +	arm_smmu_make_bypass_ste(&ste);
> +	return arm_smmu_attach_dev_ste(dev, &ste);
> +}
> +
> +static const struct iommu_domain_ops arm_smmu_identity_ops =3D {
> +	.attach_dev =3D arm_smmu_attach_dev_identity,
> +};
> +
> +static struct iommu_domain arm_smmu_identity_domain =3D {
> +	.type =3D IOMMU_DOMAIN_IDENTITY,
> +	.ops =3D &arm_smmu_identity_ops,
> +};
> +
>  static int arm_smmu_map_pages(struct iommu_domain *domain, unsigned
> long iova,
>  			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
>  			      int prot, gfp_t gfp, size_t *mapped)
> @@ -3056,6 +3089,7 @@ static void arm_smmu_remove_dev_pasid(struct
> device *dev, ioasid_t pasid)
>  }
>=20
>  static struct iommu_ops arm_smmu_ops =3D {
> +	.identity_domain	=3D &arm_smmu_identity_domain,

This seems to create a problem when we have set the identity domain and
try to enable sva for the device. Since there is no smmu_domain for this ca=
se=20
and there is no specific domain type checking in iommu_sva_bind_device() pa=
th,
it eventually crashes(hangs in my test) in,

iommu_sva_bind_device()
   ...
      arm_smmu_sva_set_dev_pasid()
        __arm_smmu_sva_bind()
           arm_smmu_mmu_notifier_get(smmu_domain, ..)  --> never exit the m=
mu notifier list loop.

I think we should check for the domain type in iommu_sva_bind_device() or l=
ater
before trying to use smmu_domain.  At present(ie, without this series) it r=
eturns error
while we are trying to write the CD. But that looks too late as well.

Thanks,
Shameer


