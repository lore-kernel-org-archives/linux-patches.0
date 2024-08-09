Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E29A195FEC;
	Fri,  9 Aug 2024 14:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723213586; cv=none; b=Je+XtvmiWV03l53NaRwCg9g0m8bYftUeBtm1+TtzBATcG74R8+F0w2WEUfmVUyMleBwuJW/fQI0Uk7KDedHd9cK/OMYfCKeehPNmY6jAb3gOyqxEGLCraN5ST9qCPyvtGGqPBdfo7eK2AU011EsDsWrORSMZWH2NKqk/q0+Ea6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723213586; c=relaxed/simple;
	bh=BRSycxJtSK6+TNSeWc0Ke0HnnZcJoST+YtczCHXVm0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tNO1eSi3/Q+Y/lUSIeO4ThPKLXeT9I0MxxAS6e1GS/HwRrJMZS5CGdwhBggmpS95kcHripYbW4F9Qz3wYAF3WoGttA6hCDLFYKozaKOZBRe2fhzdho57tnQk3iCnK9xCFgifygkdQz2xqmdfTVbPMVoNkQz6brsgrgNrHfb4uu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WgR1628Bqz1S76l;
	Fri,  9 Aug 2024 22:21:30 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 626F818002B;
	Fri,  9 Aug 2024 22:26:16 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Aug 2024 22:26:15 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Fri, 9 Aug 2024 15:26:13 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Alex Williamson <alex.williamson@redhat.com>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Len
 Brown" <lenb@kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Eric Auger <eric.auger@redhat.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, Michael Shavit
	<mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Topic: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Index: AQHa6FotZjxW0m4zQk+YUXvVQrNfTbIe/kcw
Date: Fri, 9 Aug 2024 14:26:13 +0000
Message-ID: <5af45a0c060c487fb41983c434de0ec6@huawei.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
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
> Sent: Wednesday, August 7, 2024 12:41 AM
> To: acpica-devel@lists.linux.dev; Alex Williamson
> <alex.williamson@redhat.com>; Guohanjun (Hanjun Guo)
> <guohanjun@huawei.com>; iommu@lists.linux.dev; Joerg Roedel
> <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>; kvm@vger.kernel.org=
;
> Len Brown <lenb@kernel.org>; linux-acpi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Lorenzo Pieralisi <lpieralisi@kernel.org>; Ra=
fael J.
> Wysocki <rafael@kernel.org>; Robert Moore <robert.moore@intel.com>; Robin
> Murphy <robin.murphy@arm.com>; Sudeep Holla <sudeep.holla@arm.com>;
> Will Deacon <will@kernel.org>
> Cc: Eric Auger <eric.auger@redhat.com>; Jean-Philippe Brucker <jean-
> philippe@linaro.org>; Moritz Fischer <mdf@kernel.org>; Michael Shavit
> <mshavit@google.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Subject: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
>=20
> Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> works. When S2FWB is supported and enabled the IOPTE will force cachable
> access to IOMMU_CACHE memory and deny cachable access otherwise.
>=20
> This is not especially meaningful for simple S2 domains, it apparently
> doesn't even force PCI no-snoop access to be coherent.
>=20
> However, when used with a nested S1, FWB has the effect of preventing the
> guest from choosing a MemAttr that would cause ordinary DMA to bypass the
> cache. Consistent with KVM we wish to deny the guest the ability to becom=
e
> incoherent with cached memory the hypervisor believes is cachable so we
> don't have to flush it.
>=20
> Turn on S2FWB whenever the SMMU supports it and use it for all S2
> mappings.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  6 ++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
>  drivers/iommu/io-pgtable-arm.c              | 24 +++++++++++++++++----
>  include/linux/io-pgtable.h                  |  2 ++
>  4 files changed, 31 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 531125f231b662..7fe1e27d11586c 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1612,6 +1612,8 @@ void arm_smmu_make_s2_domain_ste(struct
> arm_smmu_ste *target,
>  		FIELD_PREP(STRTAB_STE_1_EATS,
>  			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
>=20
> +	if (smmu->features & ARM_SMMU_FEAT_S2FWB)
> +		target->data[1] |=3D cpu_to_le64(STRTAB_STE_1_S2FWB);
>  	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
>  		target->data[1] |=3D
> cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
>=20
> STRTAB_STE_1_SHCFG_INCOMING));
> @@ -2400,6 +2402,8 @@ static int arm_smmu_domain_finalise(struct
> arm_smmu_domain *smmu_domain,
>  		pgtbl_cfg.oas =3D smmu->oas;
>  		fmt =3D ARM_64_LPAE_S2;
>  		finalise_stage_fn =3D arm_smmu_domain_finalise_s2;
> +		if (smmu->features & ARM_SMMU_FEAT_S2FWB)
> +			pgtbl_cfg.quirks |=3D IO_PGTABLE_QUIRK_ARM_S2FWB;

This probably requires an update in arm_64_lpae_alloc_pgtable_s2() quirks c=
heck.

Thanks,
Shameer
