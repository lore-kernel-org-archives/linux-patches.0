Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A4612839E;
	Tue, 30 Jan 2024 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706634703; cv=none; b=sPh8uRG6MaMIXJmV2ihFhVTG43hX2LBUasl7fdx2tuqcpR/Zs86+NQ71/PTNrQvHn/7awoqG9p74bUJv80ozPNpwwjD7dWRDH0mttXOdQ5La0bGlz6pKzPR5fNBa3FF4x0LtsIlr6FTC9JsBwj5A4gN9U+dK8ozQO0jAvI2Ufss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706634703; c=relaxed/simple;
	bh=JQcNQuaaB+nXiA7OcisbVo1daD8zQuNELXoIue+oNzw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ty/u0X4A254vgxA5mx5PkoBCjnDv5xfcif75YGrmTgQV1qPd1ov/UCUAWaKDVanstfODmT7g3bdIIhUUimR5OJ02SX+bijorDtWj5oFDmN1A14yqfhPYC57pJmSWaEkUJa7c7maE/+dEupOH/1g6cIQRWNdy7kT+leqCuw2f8Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TPWpC5YCMz6JB5c;
	Wed, 31 Jan 2024 01:08:19 +0800 (CST)
Received: from lhrpeml100005.china.huawei.com (unknown [7.191.160.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 338D21400D3;
	Wed, 31 Jan 2024 01:11:37 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100005.china.huawei.com (7.191.160.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 17:11:36 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Tue, 30 Jan 2024 17:11:36 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v4 01/27] iommu/arm-smmu-v3: Check that the RID domain is
 S1 in SVA
Thread-Topic: [PATCH v4 01/27] iommu/arm-smmu-v3: Check that the RID domain is
 S1 in SVA
Thread-Index: AQHaUIOwEvsu/yJdMEqnvQfiRYY9c7DyDZ2ggAB9XwCAABCyEA==
Date: Tue, 30 Jan 2024 17:11:36 +0000
Message-ID: <c8cf99b2532644de9b38c44019bf83a2@huawei.com>
References: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <b3a7b564dcef4b518af0493155b67cc6@huawei.com>
 <20240130160430.GC1455070@nvidia.com>
In-Reply-To: <20240130160430.GC1455070@nvidia.com>
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
> Sent: Tuesday, January 30, 2024 4:05 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: iommu@lists.linux.dev; Joerg Roedel <joro@8bytes.org>; linux-arm-
> kernel@lists.infradead.org; Robin Murphy <robin.murphy@arm.com>; Will
> Deacon <will@kernel.org>; Eric Auger <eric.auger@redhat.com>; Jean-
> Philippe Brucker <jean-philippe@linaro.org>; Moritz Fischer
> <mdf@kernel.org>; Michael Shavit <mshavit@google.com>; Nicolin Chen
> <nicolinc@nvidia.com>; patches@lists.linux.dev
> Subject: Re: [PATCH v4 01/27] iommu/arm-smmu-v3: Check that the RID
> domain is S1 in SVA
>=20
> On Tue, Jan 30, 2024 at 08:46:10AM +0000, Shameerali Kolothum Thodi
> wrote:
>=20
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > index 05722121f00e70..b4549d698f3569 100644
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > @@ -387,7 +387,13 @@ static int __arm_smmu_sva_bind(struct device
> *dev,
> > > struct mm_struct *mm)
> > >  	struct arm_smmu_bond *bond;
> > >  	struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> > >  	struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
> > > -	struct arm_smmu_domain *smmu_domain =3D
> > > to_smmu_domain(domain);
> > > +	struct arm_smmu_domain *smmu_domain;
> > > +
> > > +	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
> > > +		return -ENODEV;
> > > +	smmu_domain =3D
> to_smmu_domain(iommu_get_domain_for_dev(dev));
> >
> > We already have the iommu_domain from above.
>=20
> Yep
>=20
> > > +	if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_S1)
> > > +		return -ENODEV;
> >
> > I think we need to do the above checks in
> arm_smmu_sva_remove_dev_pasid()
> > as well.
>=20
> The core won't call that unless a PASID is already attached, meaning
> we already passed the above check in bind. So it shouldn't need to be
> duplicated.

I think it does in the error path.  See __iommu_set_group_pasid() call.
I haven't tested what happens if that returns error because of identity=20
domain and then __iommu_remove_group_pasid() is called.

So as an exported function, still think it is better to check for domain
type before accessing smmu_domain there.

Thanks,
Shameer
