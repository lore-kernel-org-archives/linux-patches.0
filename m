Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E017A144D3C;
	Mon, 25 Mar 2024 10:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711363478; cv=none; b=bIHTRWcGWmp62w5IzlUNmmDYTzwe6UvYcJnuTbqnWArz+fLPMSn4V1CIDa6BQeNqI7dZ5NBKitgz+OTz6Kg3BgIDOmyRqmgUPhB5LORHDfvIgizeXCbWO4erYkfThyoQeXKNFebCpCc1X1j3vfPPBSKs4bbqpMarKKl/4Y98cOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711363478; c=relaxed/simple;
	bh=ny0zb1eCpfrT6gBqJlV5A/o1otXMvRxh0XOY4W4FvWg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YP31PZbh7JkNcBn70yTJ6L2uxwiRNulzdbkgQHGe+1H28wJ5oSlm8JAnx+kSie9rciG+9d7CrLqsbnof3piOnJbToY/g93G0yWYLaFU6jnKPsZIIVz9J0K5aGknuG3XBiDvAYGINNFKh16rHMkXVFahUXsIE4vNXUF8tpDK91y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4V38Zv0yYdz6K9HB;
	Mon, 25 Mar 2024 18:40:07 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (unknown [7.191.163.213])
	by mail.maildlp.com (Postfix) with ESMTPS id 34B5B140B33;
	Mon, 25 Mar 2024 18:44:31 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500001.china.huawei.com (7.191.163.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 10:44:30 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Mon, 25 Mar 2024 10:44:30 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Thread-Topic: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part
 2/3)
Thread-Index: AQHabo3wRMc+IC/UvkmrycX31nWce7FIX4GAgAAEMJA=
Date: Mon, 25 Mar 2024 10:44:30 +0000
Message-ID: <9819d9f48ad64fb8a704a0a779010581@huawei.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZgFQVy-gIJJKL2IG@google.com>
In-Reply-To: <ZgFQVy-gIJJKL2IG@google.com>
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
> From: Mostafa Saleh <smostafa@google.com>
> Sent: Monday, March 25, 2024 10:22 AM
> To: Jason Gunthorpe <jgg@nvidia.com>
> Cc: iommu@lists.linux.dev; Joerg Roedel <joro@8bytes.org>; linux-arm-
> kernel@lists.infradead.org; Robin Murphy <robin.murphy@arm.com>; Will
> Deacon <will@kernel.org>; Eric Auger <eric.auger@redhat.com>; Jean-
> Philippe Brucker <jean-philippe@linaro.org>; Moritz Fischer
> <mdf@kernel.org>; Michael Shavit <mshavit@google.com>; Nicolin Chen
> <nicolinc@nvidia.com>; patches@lists.linux.dev; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Subject: Re: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API
> (part 2/3)
>=20
> Hi Jason,
>=20
> On Mon, Mar 04, 2024 at 07:43:48PM -0400, Jason Gunthorpe wrote:
> > Continuing the work of part 1 this focuses on the CD, PASID and SVA
> > components:
> >
> >  - attach_dev failure does not change the HW configuration.
> >
> >  - Full PASID API support including:
> >     - S1/SVA domains attached to PASIDs
> >     - IDENTITY/BLOCKED/S1 attached to RID
> >     - Change of the RID domain while PASIDs are attached
> >
> >  - Streamlined SVA support using the core infrastructure
> >
> >  - Hitless, whenever possible, change between two domains
> >
> > Making the CD programming work like the new STE programming allows
> > untangling some of the confusing SVA flows. From there the focus is on
> > building out the core infrastructure for dealing with PASID and CD
> > entries, then keeping track of unique SSID's for ATS invalidation.
> >
> > The ATS ordering is generalized so that the PASID flow can use it and p=
ut
> > into a form where it is fully hitless, whenever possible. Care is taken=
 to
> > ensure that ATC flushes are present after any change in translation.
> >
> > Finally we simply kill the entire outdated SVA mmu_notifier
> implementation
> > in one shot and switch it over to the newly created generic PASID & CD
> > code. This avoids the messy and confusing approach of trying to
> > incrementally untangle this in place. The new code is small and simple
> > enough this is much better than trying to figure out smaller steps.
> >
> > Once SVA is resting on the right CD code it is straightforward to make =
the
> > PASID interface functionally complete.
> >
> > It achieves the same goals as the several series from Michael and the S=
1DSS
> > series from Nicolin that were trying to improve portions of the API.
> >
> > This is on github:
> > https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
>=20
> Testing on qemu[1], with the same VMM Shameer tested with[2]:
> qemu/build/qemu-system-aarch64 -M virt -machine virt,gic-
> version=3D3,iommu=3Dnested-smmuv3,iommufd=3Diommufd0 \
> -cpu cortex-a53,pmu=3Doff -smp 1 -m 2048 \
> -kernel Image \
> -drive file=3Drootfs.ext4,if=3Dvirtio,format=3Draw  \
> -object rng-random,filename=3D/dev/urandom,id=3Drng0 -device virtio-rng-
> pci,rng=3Drng0 -nographic  \
> -append 'console=3DttyAMA0 rootwait root=3D/dev/vda' \
> -device virtio-scsi-pci,id=3Dscsi0  \
> -device ioh3420,id=3Dpcie.1,chassis=3D1 \
> -object iommufd,id=3Diommufd0 \
> -device vfio-pci,host=3D0000:00:03.0,iommufd=3Diommufd0
>=20
> I see the following panic:

I think that is probably because you are testing with "nested-smmuv3". This
series not yet fully enable that. For that, I think you are missing few pat=
ches
from Nicolin's iommufd branch,
https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03112024/

Thanks,
Shameer

