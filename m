Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB93B54F93;
	Tue, 30 Jan 2024 08:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706603727; cv=none; b=E2uxqb77S/R6yHktgEWUZoqICEf+Ey/0ZjRNZiOU9dPhM+HHhOU79G3nh0UuTKna7rgykky/g9Rk9mNbUxIczxX34zcuqCSgekAFMTxM0+kDfJ6hg/FtMeU/SSZwCQjDVeTsS/sQzxDILa2yWJP3g/kBvsviY7lfOet4WM/ht/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706603727; c=relaxed/simple;
	bh=x6UvXf0B9DkBFjhLYi0HvD7G+az9Hq4hjG4s6T7ntSs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NoprjjrFImuMw3GFl5//KpymbrSJ/Z3QGPVJCKMTfi+Da+IruhmuAktgPXB0gHEr9fp/MEfG7fVEOWIOdnxrVOssNq/80vOJSO4rg8nfytCGskGM7/edfKjqB2bawDD2M0mQ5xWrUlX6f7jaiFisPVvCKeaFe91XzDpaCZZnGss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TPJLv3t7cz6K6DY;
	Tue, 30 Jan 2024 16:32:23 +0800 (CST)
Received: from lhrpeml500006.china.huawei.com (unknown [7.191.161.198])
	by mail.maildlp.com (Postfix) with ESMTPS id EF0F41400D3;
	Tue, 30 Jan 2024 16:35:15 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 08:35:15 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Tue, 30 Jan 2024 08:35:15 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Moritz Fischer <mdf@kernel.org>, "Moritz
 Fischer" <moritzf@google.com>, Michael Shavit <mshavit@google.com>, "Nicolin
 Chen" <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v4 12/16] iommu/arm-smmu-v3: Add a global static IDENTITY
 domain
Thread-Topic: [PATCH v4 12/16] iommu/arm-smmu-v3: Add a global static IDENTITY
 domain
Thread-Index: AQHaT+pNVhHFEhXMHk+FZtmV7qYxyLDxFnkAgAAOOACAAOfGYA==
Date: Tue, 30 Jan 2024 08:35:15 +0000
Message-ID: <84bb5ddba8b04f28b4cec5cb7a544817@huawei.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <12-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <2a828e481416405fb3a4cceb9e075a59@huawei.com>
 <20240129183750.GZ1455070@nvidia.com>
In-Reply-To: <20240129183750.GZ1455070@nvidia.com>
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
> Sent: Monday, January 29, 2024 6:38 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: iommu@lists.linux.dev; Joerg Roedel <joro@8bytes.org>; linux-arm-
> kernel@lists.infradead.org; Robin Murphy <robin.murphy@arm.com>; Will
> Deacon <will@kernel.org>; Moritz Fischer <mdf@kernel.org>; Moritz Fischer
> <moritzf@google.com>; Michael Shavit <mshavit@google.com>; Nicolin Chen
> <nicolinc@nvidia.com>; patches@lists.linux.dev
> Subject: Re: [PATCH v4 12/16] iommu/arm-smmu-v3: Add a global static
> IDENTITY domain
>=20
> On Mon, Jan 29, 2024 at 06:11:48PM +0000, Shameerali Kolothum Thodi
> wrote:
>=20
> > > @@ -3056,6 +3089,7 @@ static void
> arm_smmu_remove_dev_pasid(struct
> > > device *dev, ioasid_t pasid)
> > >  }
> > >
> > >  static struct iommu_ops arm_smmu_ops =3D {
> > > +	.identity_domain	=3D &arm_smmu_identity_domain,
> >
> > This seems to create a problem when we have set the identity domain and
> > try to enable sva for the device. Since there is no smmu_domain for thi=
s
> case
> > and there is no specific domain type checking in iommu_sva_bind_device(=
)
> path,
> > it eventually crashes(hangs in my test) in,
>=20
> Yeah, that is a longstanding issue in the SVA implementation, it only
> works if the RID is set to a S1 paging domain.
>=20
> I cleaned it up here so that the SVA series was cleaer:
>=20
> https://lore.kernel.org/linux-iommu/1-v4-e7091cdd9e8d+43b1-
> smmuv3_newapi_p2_jgg@nvidia.com/

Yes, this will do. But I think it is not complete. I will comment on that o=
ne.

>=20
> > iommu_sva_bind_device()
> >    ...
> >       arm_smmu_sva_set_dev_pasid()
> >         __arm_smmu_sva_bind()
> >            arm_smmu_mmu_notifier_get(smmu_domain, ..)  --> never exit t=
he
> mmu notifier list loop.
> >
> > I think we should check for the domain type in iommu_sva_bind_device()
> or later
> > before trying to use smmu_domain.  At present(ie, without this series) =
it
> returns error
> > while we are trying to write the CD. But that looks too late as well.
>=20
> Oh wow, is that how it worked? OK, I figured it was just broken but if
> there was some error code that happened indirectly then lets've move
> the above patch ahead of this one.

Yes, indirectly indeed :)
https://elixir.bootlin.com/linux/v6.8-rc2/source/drivers/iommu/arm/arm-smmu=
-v3/arm-smmu-v3.c#L1068

Thanks,
Shameer
