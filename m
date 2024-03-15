Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7A218E3A;
	Fri, 15 Mar 2024 10:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710499286; cv=none; b=l75GHbwyi1EB7oNFNVhI/0ogpa4V1NEIy6EzpDQWWK+QuXvDbeorXKajDtp1uXtYfUY4xwRPxb6NU/yus7CCGiNb6BB1dnbYufZhBkQuiP+9U3rLYqOOs2HOReflwwL9697JABdhXpxC7XJHeuKLZnLYt/z66jJaah4nHV9IpEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710499286; c=relaxed/simple;
	bh=5xFB9PdQBwFHLssd8TQ27J3pn/CMe/PLe0vIgQY0uwk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IotGoJYwnI7i4+1ffRaJMelyo45FAABguM/iBw2euJz/UnHOFr4u3FaXFo+JY0GhsfBMUe/vBo7DGGECvZUXK2JdRTa3xEyJtB9Akrz0oJi9N54j/AJMr5VvTvQPQCQuo4Nnvv8KDU4q5nEV3a6p3wIY/EeLWFJp3sy1mKRi7uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Tx1063zcrz6D92K;
	Fri, 15 Mar 2024 18:37:10 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (unknown [7.191.163.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 34D28140DD4;
	Fri, 15 Mar 2024 18:41:00 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 15 Mar 2024 10:40:40 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Fri, 15 Mar 2024 10:40:40 +0000
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
Subject: RE: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Thread-Topic: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part
 2/3)
Thread-Index: AQHabo3wRMc+IC/UvkmrycX31nWce7E4q8kQ
Date: Fri, 15 Mar 2024 10:40:40 +0000
Message-ID: <40f3eb28997d421099d48100128bf218@huawei.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
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
> Sent: Monday, March 4, 2024 11:44 PM
> To: iommu@lists.linux.dev; Joerg Roedel <joro@8bytes.org>; linux-arm-
> kernel@lists.infradead.org; Robin Murphy <robin.murphy@arm.com>; Will
> Deacon <will@kernel.org>
> Cc: Eric Auger <eric.auger@redhat.com>; Jean-Philippe Brucker <jean-
> philippe@linaro.org>; Moritz Fischer <mdf@kernel.org>; Michael Shavit
> <mshavit@google.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Subject: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3=
)
>=20
> Continuing the work of part 1 this focuses on the CD, PASID and SVA
> components:
>=20
>  - attach_dev failure does not change the HW configuration.
>=20
>  - Full PASID API support including:
>     - S1/SVA domains attached to PASIDs
>     - IDENTITY/BLOCKED/S1 attached to RID
>     - Change of the RID domain while PASIDs are attached
>=20
>  - Streamlined SVA support using the core infrastructure
>=20
>  - Hitless, whenever possible, change between two domains
>=20
> Making the CD programming work like the new STE programming allows
> untangling some of the confusing SVA flows. From there the focus is on
> building out the core infrastructure for dealing with PASID and CD
> entries, then keeping track of unique SSID's for ATS invalidation.
>=20
> The ATS ordering is generalized so that the PASID flow can use it and put
> into a form where it is fully hitless, whenever possible. Care is taken t=
o
> ensure that ATC flushes are present after any change in translation.
>=20
> Finally we simply kill the entire outdated SVA mmu_notifier implementatio=
n
> in one shot and switch it over to the newly created generic PASID & CD
> code. This avoids the messy and confusing approach of trying to
> incrementally untangle this in place. The new code is small and simple
> enough this is much better than trying to figure out smaller steps.
>=20
> Once SVA is resting on the right CD code it is straightforward to make th=
e
> PASID interface functionally complete.
>=20
> It achieves the same goals as the several series from Michael and the S1D=
SS
> series from Nicolin that were trying to improve portions of the API.
>=20
> This is on github:
> https://github.com/jgunthorpe/linux/commits/smmuv3_newapi


Performed few tests with this series on a HiSilicon D06 board(SMMUv3).

-Host kernel: boot with translated and passthrough cases.
-Host kernel: ACC dev SVA test run with uadk/uadk_tool benchmark.

With Qemu branch:
https://github.com/nicolinc/qemu/commits/wip/iommufd_vsmmu-02292024/

-Guest with a n/w VF dev, legacy VFIO mode.
-Guest with a n/w VF dev, IOMMUFD mode.
-Hot plug(add/del) on both VFIO and IOMMUFD modes.

All works as expected.

FWIW:
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer
