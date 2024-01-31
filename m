Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840E880C0F;
	Wed, 31 Jan 2024 14:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706711366; cv=none; b=FLYC+y9BGB47KI9ShXUwYOGc9Jgl3wOGPZ7Pre4rKRyfiJhl3rkKfC+fJMSmXyLY+orjijnTR77aVVTZBFevP6lldmPHfaIPuhpWJzExYGNlQN7FasSNStDgqM6prK3uyRH6gq9a42Kcx+aDrJ75q9Y+T+2Tsdll59MfVPzehe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706711366; c=relaxed/simple;
	bh=CkOVV4bLlMuDuGgyOFPc5s9rmZ4yqLT5d5EOVI4ET4Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fjsIUe8QyjurZsTIHdQTg39Ws3fYSbNIbG5KpG8g0g7175Ov2WODD+ssNu4CFKMUDfYWperBu0JofV6IQdIevHTeYbWdddLpC/mYHnDZ98XV+euNOciQSDKII5+1pp7QdF1334ibeslo1rt0h9VP5irCF40OZszXo8+WslTlrKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TQ48R1lrKz6J9dR;
	Wed, 31 Jan 2024 22:25:59 +0800 (CST)
Received: from lhrpeml100001.china.huawei.com (unknown [7.191.160.183])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F27F1404F9;
	Wed, 31 Jan 2024 22:29:19 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100001.china.huawei.com (7.191.160.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 31 Jan 2024 14:29:18 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Wed, 31 Jan 2024 14:29:18 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v4 14/27] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Thread-Topic: [PATCH v4 14/27] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Thread-Index: AQHaUIOw1lOGfTAiLU2HDVkp8/O+97Dzxx+AgAA214CAAAQjAA==
Date: Wed, 31 Jan 2024 14:29:18 +0000
Message-ID: <82ae7070b9cb4d95b09b51987fb3ad4e@huawei.com>
References: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <14-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <78401f5d541042f5a71f13bf8af7ed3f@huawei.com>
 <20240131141217.GG1455070@nvidia.com>
In-Reply-To: <20240131141217.GG1455070@nvidia.com>
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
> Sent: Wednesday, January 31, 2024 2:12 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: iommu@lists.linux.dev; Joerg Roedel <joro@8bytes.org>; linux-arm-
> kernel@lists.infradead.org; Robin Murphy <robin.murphy@arm.com>; Will
> Deacon <will@kernel.org>; Eric Auger <eric.auger@redhat.com>; Jean-
> Philippe Brucker <jean-philippe@linaro.org>; Moritz Fischer
> <mdf@kernel.org>; Michael Shavit <mshavit@google.com>; Nicolin Chen
> <nicolinc@nvidia.com>; patches@lists.linux.dev
> Subject: Re: [PATCH v4 14/27] iommu/arm-smmu-v3: Make changing
> domains be hitless for ATS
>=20
> On Wed, Jan 31, 2024 at 11:20:48AM +0000, Shameerali Kolothum Thodi
> wrote:
>=20
> > > +static void arm_smmu_attach_commit(struct arm_smmu_master
> *master,
> > > +				   struct attach_state *state)
> > > +{
> > > +	lockdep_assert_held(&arm_smmu_asid_lock);
> > > +
> > > +	if (state->want_ats && !master->ats_enabled) {
> > > +		arm_smmu_enable_ats(master);
> > > +	} else if (master->ats_enabled) {
> > > +		/*
> > > +		 * The translation has changed, flush the ATC. At this point
> the
> > > +		 * SMMU is translating for the new domain and both the
> > > old&new
> > > +		 * domain will issue invalidations.
> > > +		 */
> > > +		arm_smmu_atc_inv_master(master);
> > > +	}
> > > +	master->ats_enabled =3D state->want_ats;
> > > +
> > > +	arm_smmu_remove_master_domain(master,
> > > +				      iommu_get_domain_for_dev(master-
> > > >dev));
> >
> > I think the core has not yet set the group->domain since we are still i=
n
> attach().
>=20
> Any chance you are not running exactly v4? There was an earlier
> version on github that had exactly what you said, Nicolin
> found it and it was fixed before v4 was posted:
>=20
> static struct arm_smmu_domain *
> to_smmu_domain_devices(struct iommu_domain *domain)
> {
>         /* The domain can be NULL only when processing the first attach *=
/
>         if (!domain)
>                 return NULL;

Ah...I think I am on an older version as the above check is missing. That s=
hould
fix it.

Thanks,
Shameer.
