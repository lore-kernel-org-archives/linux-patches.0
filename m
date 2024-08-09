Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222B116D328;
	Fri,  9 Aug 2024 15:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723216536; cv=none; b=eCh3dbOlg0DL0Nmj/vgIJuLjYzvnSopu8de99muHi3UAnHzvR3ZGXNwaiP6ny72ROfsqrIDcBafHDTeKYXX9JI6/R77ZGrH6ANaNso2zme9+lm0q6s/vvwnu/QlGTqyud2xgPsafJqRLOF+rUqD5yIuWFaSX4VrKFpo3m7iK3fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723216536; c=relaxed/simple;
	bh=Sv4OQmdpn3Gu3oDJ/ErEeKBV+jpQaKCimhh1f8omE7w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=apa7KEXLf4AyXhgkTaEhqRUMgYIWEYTFVYq9eEGxF4BQIGT5bMkfkqAQD0pnxe6d0mCTFk7K0bmTnr+5MwULusa822HYtNzFFzz28xpaA9+dmq1ckIeZe2M/C3MjTyxR4rQSDcbLG+5M8iwTfMfyftrXb0+jWokxjEh4WtBd7LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WgS660pztzQpTk;
	Fri,  9 Aug 2024 23:10:54 +0800 (CST)
Received: from dggpemf200003.china.huawei.com (unknown [7.185.36.52])
	by mail.maildlp.com (Postfix) with ESMTPS id 3859914011A;
	Fri,  9 Aug 2024 23:15:23 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf200003.china.huawei.com (7.185.36.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Aug 2024 23:15:22 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Fri, 9 Aug 2024 16:15:20 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>, "Alex
 Williamson" <alex.williamson@redhat.com>, "Guohanjun (Hanjun Guo)"
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"Nicolin Chen" <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Topic: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Index: AQHa6FotpRfMo8Wi40urDv/LZ+pM/rIfAPiQ///2/wCAABHcwA==
Date: Fri, 9 Aug 2024 15:15:20 +0000
Message-ID: <8ccabbffaae042a9b9c727272fd352e6@huawei.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <3-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <c2dc5966ab794825a69e2ae2b2905632@huawei.com>
 <20240809145922.GH8378@nvidia.com>
In-Reply-To: <20240809145922.GH8378@nvidia.com>
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
> Sent: Friday, August 9, 2024 3:59 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: acpica-devel@lists.linux.dev; Alex Williamson
> <alex.williamson@redhat.com>; Guohanjun (Hanjun Guo)
> <guohanjun@huawei.com>; iommu@lists.linux.dev; Joerg Roedel
> <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>; kvm@vger.kernel.org=
;
> Len Brown <lenb@kernel.org>; linux-acpi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Lorenzo Pieralisi <lpieralisi@kernel.org>; Ra=
fael J.
> Wysocki <rafael@kernel.org>; Robert Moore <robert.moore@intel.com>; Robin
> Murphy <robin.murphy@arm.com>; Sudeep Holla <sudeep.holla@arm.com>;
> Will Deacon <will@kernel.org>; Eric Auger <eric.auger@redhat.com>; Jean-
> Philippe Brucker <jean-philippe@linaro.org>; Moritz Fischer <mdf@kernel.o=
rg>;
> Michael Shavit <mshavit@google.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev
> Subject: Re: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
>=20
> On Fri, Aug 09, 2024 at 02:36:31PM +0000, Shameerali Kolothum Thodi wrote=
:
> > > @@ -524,6 +524,7 @@ struct acpi_iort_memory_access {
> > >
> > >  #define ACPI_IORT_MF_COHERENCY          (1)
> > >  #define ACPI_IORT_MF_ATTRIBUTES         (1<<1)
> > > +#define ACPI_IORT_MF_CANWBS             (1<<2)
> >
> > I think we need to update Document number to E.f in IORT section in
> > this file. Also isn't it this file normally gets updated through ACPICA=
 pull ?
>=20
> I don't know anything about the ACPI process..
>=20
> Can someone say for sure what to do here?

From past experience, it is normally sending a PULL request to here,
https://github.com/acpica/acpica/pulls

And I think it then gets merged by Robert Moore and then send to LKML.

Thanks,
Shameer

