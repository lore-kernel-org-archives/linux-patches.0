Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8A0745C8;
	Wed, 31 Jan 2024 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706700060; cv=none; b=uPD9AFkI2MvZNiTgvveF70fWtaE2AtR3imMi9D3uvLeJTpy9UZAZqhHtaXmKZ9IT6wDYJgRkSe5C0FMv4eCDdTTCieQu5uUL90EgpqmuVf8AcoxnD/imJhVUNHgoGBpmzcwQrmr2BynWO1x9iOeKfZDp5yhN9i/9zv+n/OBno60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706700060; c=relaxed/simple;
	bh=IjZfiDSUftx65t98JuLiBJx2cybDsZAAjkwGdesTTqo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U1kTLZJdWSz0vCFoqTaKq+vLq40RwDTlcwVxFj9dYt8dGumy9aqqqTIlXPVsYHPQA7fQJm/rUq59rq9qPtqf3Sfrt9tQ2ZOaUfCpkY1U9ZIq70EgHgVIlRP46RrZ3Oyp7Y1vrEbzXURo+mtgPOgTEBywT5FbSZwvPsCHyazlZIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TPzzN6LNrz6K5Tg;
	Wed, 31 Jan 2024 19:17:52 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (unknown [7.191.163.9])
	by mail.maildlp.com (Postfix) with ESMTPS id D16601400D3;
	Wed, 31 Jan 2024 19:20:48 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 31 Jan 2024 11:20:48 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Wed, 31 Jan 2024 11:20:48 +0000
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
Subject: RE: [PATCH v4 14/27] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Thread-Topic: [PATCH v4 14/27] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Thread-Index: AQHaUIOw1lOGfTAiLU2HDVkp8/O+97Dzxx+A
Date: Wed, 31 Jan 2024 11:20:48 +0000
Message-ID: <78401f5d541042f5a71f13bf8af7ed3f@huawei.com>
References: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <14-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <14-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
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
> Subject: [PATCH v4 14/27] iommu/arm-smmu-v3: Make changing domains be
> hitless for ATS
>=20
> The core code allows the domain to be changed on the fly without a forced
> stop in BLOCKED/IDENTITY. In this flow the driver should just continually
> maintain the ATS with no change while the STE is updated.
>=20
> ATS relies on a linked list smmu_domain->devices to keep track of which
> masters have the domain programmed, but this list is also used by
> arm_smmu_share_asid(), unrelated to ats.
>=20
> Create two new functions to encapsulate this combined logic:
>  arm_smmu_attach_prepare()
>  <caller generates and sets the STE>
>  arm_smmu_attach_commit()
>=20
> The two functions can sequence both enabling ATS and disabling across
> the STE store. Have every update of the STE use this sequence.
>=20
> Installing a S1/S2 domain always enables the ATS if the PCIe device
> supports it.
>=20
> The enable flow is now ordered differently to allow it to be hitless:
>=20
>   1) Add the master to the new smmu_domain->devices list
>   2) Program the STE
>   3) Enable ATS at PCIe
>   4) Remove the master from the old smmu_domain
>=20
> This flow ensures that invalidations to either domain will generate an AT=
C
> invalidation to the device while the STE is being switched. Thus we don't
> need to turn off the ATS anymore for correctness.
>=20
> The disable flow is the reverse:
>  1) Disable ATS at PCIe
>  2) Program the STE
>  3) Invalidate the ATC
>  4) Remove the master from the old smmu_domain
>=20
> Move the nr_ats_masters adjustments to be close to the list
> manipulations. It is a count of the number of ATS enabled masters
> currently in the list. This is stricly before and after the STE/CD are
> revised, and done under the list's spin_lock.


This part 2 fails to boot in my hardware setup and the bisect points to
this patch here.

Splat:

31.988204] Unable to handle kernel NULL pointer dereference at virtual addr=
ess 0000000000000000
...
[   32.357876] Call trace:
[   32.363018]  arm_smmu_attach_commit+0xa4/0x210
[   32.372361]  arm_smmu_attach_dev+0x208/0x3b4
[   32.381344]  __iommu_device_set_domain+0x7c/0x11c
[   32.391243]  __iommu_group_set_domain_internal+0x90/0x184
[   32.402601]  iommu_setup_default_domain+0x32c/0x4e8
[   32.412863]  __iommu_probe_device+0x450/0x478
...

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 199 ++++++++++++++------
>  1 file changed, 141 insertions(+), 58 deletions(-)
>=20
> +static void arm_smmu_attach_commit(struct arm_smmu_master *master,
> +				   struct attach_state *state)
> +{
> +	lockdep_assert_held(&arm_smmu_asid_lock);
> +
> +	if (state->want_ats && !master->ats_enabled) {
> +		arm_smmu_enable_ats(master);
> +	} else if (master->ats_enabled) {
> +		/*
> +		 * The translation has changed, flush the ATC. At this point the
> +		 * SMMU is translating for the new domain and both the
> old&new
> +		 * domain will issue invalidations.
> +		 */
> +		arm_smmu_atc_inv_master(master);
> +	}
> +	master->ats_enabled =3D state->want_ats;
> +
> +	arm_smmu_remove_master_domain(master,
> +				      iommu_get_domain_for_dev(master-
> >dev));

I think the core has not yet set the group->domain since we are still in at=
tach().

Thanks,
Shameer

