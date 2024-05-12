Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5F328DD0;
	Sun, 12 May 2024 14:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715524093; cv=fail; b=prb42njDc27dJ+6J8zGMMF9Q+fWu0h9t+y6zF1CDMLZUjREmA2DX7jIIJuk+Pl8u/itS9Dz5PlX12vyi5wfLoQGncs0b6+wqbtPn9sgkMcXs/CXKu8v7jtWHBXifBj0KC8PL72iiA60H6WvB6eo422tr5TEwPkKCpjOe4A8hw8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715524093; c=relaxed/simple;
	bh=s4nNWEEPf+YbQMcy+BbytWiJcAUlVsPBy7af8PJH8lY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=G9m2ZaDAIKcMo70VirdA38k01DvomKClhamToe82yceYHlOC9xdfmfQr5oTssQ9A8ccdbIkdw3k+9GFy4tqktQuWN6hSP/Lx48NDdXSRgSmZjQ4EALj+HLus+Jb0pqPl7z3+x3Eh6RnRHcsx2i1RXS1wB9fuKJ7BYKypaUUGlto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WH3MTdE0; arc=fail smtp.client-ip=40.107.92.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WH3MTdE0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfOJeStMqHp7HGzD3XnM0TGMNalrPj8ofAJPxhp+4hpK8/J6XQisj/A9BJ395Gl8yNL/zYhawo5x8shlFlt3RQw6EkWRYQ7V0isjVRD1+nz9gPSKRWfqS7/scMvY1GcKXbbBbSaNPRJczkpvvQWyzJAvPd/5MrkRabq6aNz2q5csm0+U8GxUbAEOnwMEpFR46vlOiAi6K2Uv+XwG3I67lY8jesfM6WdwMsyieuJHN03jDBz0v5HCaDJttk4ftXOWLuSsBJlOkc/r3AdRe4BzINBwSfnTs7djLXjSHfULNtqEK5xJMOsze4akOcmIlwBzXI0D7vlQYVDYitLOu7IRBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avmWSUuO0X8AikJwEwWGh5/Yu+jrZWNGM+VZ1LmU5Yg=;
 b=QdWCP0Zoh6FQDNkDkocWh9n5GSupUzHJ9IyngF/8N+Uun8LBC0o9AzIQyDFq/DYTbNzWgHieGUqBckNtQrTMzzSqmXFLvhVvHDJneApXoD3cVwFeKut7nGrazk8mucYeopW/0NLW5+8lQGQ9epBMyvQwxiCUJl8rmRtRrehr67nSgL+dD9pW9r7Ib9GG8IzaEesRF1k63EqGRUzL8UjB89IVd7bpAA8RAxs13N8dhiXeSHxviJMWJkmi9bMqAKOUkyQOSueHiB3YjSNqOp7/zF4gtfJZ7rB789pv3rC1k3p4JOmia3QGhQ9A2L/sEmJE68L2rmhLYJ7sGRtWbRtCLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avmWSUuO0X8AikJwEwWGh5/Yu+jrZWNGM+VZ1LmU5Yg=;
 b=WH3MTdE0Z/zf1Jec+eZYoMVjawZ424p/SCvQ4Vu1TnXoKPfE6Jiyjq6HFPWy4SoAwbR5dpJkXHTmF+xxFtwNfrsIjTOEk0125kR/BFTmBC7IspoHkH0S1+kjspQlvpC/TTKq3J+p6sNBC2olZ/CzfnmU8Z7EW8cJEkqJyuS/kWjOYReUKmA3fUHvcofxHWkzX1EJxuer7F7bbxpQVVMHBlT3Nbo4wMMdM/G3WTzrhiUuFh0zDJpb3vKT1DirmRy9yTaBj9QfIIWnSj8sj+hst3v6o7mtYWbuhO2+DYMpwsqs3sbo6yPxSxFXa3Oieh8DoZW1IuKIsx4+BhraqO3dJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB8570.namprd12.prod.outlook.com (2603:10b6:8:18b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Sun, 12 May
 2024 14:28:07 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7544.052; Sun, 12 May 2024
 14:28:06 +0000
Date: Sun, 12 May 2024 10:12:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 02/14] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <ZkDAL+TX93QfTFMc@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <2-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <Zj7YsKWSqGqOgOoV@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj7YsKWSqGqOgOoV@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB8570:EE_
X-MS-Office365-Filtering-Correlation-Id: 135f7c1e-8e1e-4b55-a4ee-08dc728fbd3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I4w6eV8fKcrLvHJyMKqvBJvp6ZRYjFrSyVfKPclH6d7p0rTQbGnnTvAfOth5?=
 =?us-ascii?Q?RwnN85RPwRkFZ84gdBXztCJOGfMR3rUCadajomzg+5rJxBY6wxinEuZ+Lsm+?=
 =?us-ascii?Q?G414NxU6RSlnCiJIYc1rm6GCd77E7za89krx5wAXwlSCtbZlVaqvlVeblPn6?=
 =?us-ascii?Q?+8qu1RxdlcdRTJ+zGkawa1e8odExMBcCgQk/sYW7zGLwrYWIqrBLuE48nqVL?=
 =?us-ascii?Q?fv72qyh+1qKWsScngXDpv0AOgMXRsXWRFPu6eG6frruayv651X4IbWH5Oa0L?=
 =?us-ascii?Q?HE4C9Bv7rzb/d+DLpy8K2bD9bmmKge4rXtEviIGw2RMHKMC1SNxmcGmsaJsL?=
 =?us-ascii?Q?UrW5ODqjWNO1E8TW5SjEqLMwFAQIhpoT+xead1LknPw2+Ekk2UHxxG/QiW2R?=
 =?us-ascii?Q?cx9Tl6mE0iP+CzUabyaEtriXeQfTz2jDf53vgDUqopjpnFPa3yvGirCg0ded?=
 =?us-ascii?Q?0PX0Z1iG5OdnBQZYgK5oLTuDSKshdXKSUngv/kf9uStbMHed80Nr4m3R47yq?=
 =?us-ascii?Q?9ym/rR8x7atRsWU7sNbIRXxImuwMfM+/VCbJDtAra8NNSr0DiDwvNrT4sNfW?=
 =?us-ascii?Q?w/QfsidHw/SJMHtgo8twZo8kZtwnyrHgrcmCQ/PMoU1Y/f3ZGiocCj1RJx2E?=
 =?us-ascii?Q?RgNru8/Hm0wlnXMGR6ZYyFd4t5u6pzApduYrcKhGAxRfm+djwOVW70Pxz5v7?=
 =?us-ascii?Q?Utxl0ivKHGOFfwDSGbLlGvcN/PVoWrMtwm19wuJQ8ulyWK8hVoKfjftjwNXk?=
 =?us-ascii?Q?uo7G1uIqL9d2YINODlTzyCM1JqEBWNPMt0PXnYbeP3lb/0zlU4XoLK05W6g1?=
 =?us-ascii?Q?pz0exjs2YCnhfhBssxC0HJtKo+NxPWsYCe80jim6ySRK5I8x6K9wQRf6uKNj?=
 =?us-ascii?Q?pXjupyvBCMBh9Zdg3aa3BLtaSAZF9KLeEtPzC+yVWbowZl7g1eHriN+8nf4C?=
 =?us-ascii?Q?O7B/sDj0eLRu+eggjIKJSYClTnQxyH+7Or400P3hW4fERU9ejcxymu1ubJCN?=
 =?us-ascii?Q?v7l4dHw8ozKfPJTFgLxj5MuMQXtuaEz0IwcbjNL7jXcbQkIpw5W7yRQUF8Jp?=
 =?us-ascii?Q?RkvczEhKVtDx0C9ZNuzMTorvyhtukeGcJ1SFSlvKzDpfXRa00StSCYo6AM7S?=
 =?us-ascii?Q?Ulxi8ATUc9Ba94se6KrjoYAVbJOhdDvJD42uOURjaCDelosPxqF1IOCfUmOZ?=
 =?us-ascii?Q?a16IDDV8FycplPlWKN9SJohw94ueu8BoGzcMVqpeOnHiKm0FQPRUZ76yyijf?=
 =?us-ascii?Q?IfLlUaxf30Si9CVbTmmSsMbXG/6q8zMJ5cAgrGJeCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xuPd3hywoZ5pay1zCeoNt+Jgk+anv8A3a3BYQN9mF91SeKpCU+tqr7xg/R+j?=
 =?us-ascii?Q?hyM4AJOSNbpJtwGOOAN83JTYqCVOCYkfQ1v3jIJEwNJjs01iHk2bZBPpbAtE?=
 =?us-ascii?Q?aCGCND1E5RA7YKgR+qiE7o3tptmxSMN2dYpm2HP82cJC3NJszpRAUV2MsWQC?=
 =?us-ascii?Q?8PrJmS0S4FPy/EtHSalD5L54WW/I3xSlyvrXuIYIU91TVIElWjHkcpWEkdDv?=
 =?us-ascii?Q?LO+Ble0osF8hyA1AqBVrjS0Iv6PS0NCElMyt2EGTSvgWX2GmyvL752OcnuV7?=
 =?us-ascii?Q?LivL94suPCuVd+1E8wXSVloJ/WtaiGvn2MMAIVY/8S1og/z0cRhkraNkPl+X?=
 =?us-ascii?Q?czp7/kJtuXAu1nb8yWKVxC10r707i1lvdz5XV75oETKfdF5zAMRwrE8C8gF3?=
 =?us-ascii?Q?eQ6PuD3quQoaLQIxSm5eotRQDBJ1axIPPLmdfq70GGXEvuku9jppVp8+e0Mx?=
 =?us-ascii?Q?Qn2nP3DuVymILbPv+w2gNF+UOPqWSJYVDc24/C2nxreUUNOf4GWBZayzAbUi?=
 =?us-ascii?Q?hn0ka6v/Nr3QICqy+rPMOiBMc5mYF2zqiAH9Q6r22obwKXoBwK3Gk3IuHyAe?=
 =?us-ascii?Q?Xu/wJRPQAjr4BQQpHZE6NSb4uBZUaWsQ/ftKBOd/5TRQadxFOlf52l3D/GV+?=
 =?us-ascii?Q?WBXa4WNzAf9Pbe0JbEMj6xA+NaIX7reAodG3v/pSAqPbOnSUN0Bi5eKyaRGL?=
 =?us-ascii?Q?hvyr0LpXy0MaZHctAIoE8Brq8dY2iqitHcpWhKvYavGRbwRWMvyCeRULuKg4?=
 =?us-ascii?Q?7+IZximu6il4lq+Z01jTolqnRPee59Ui9RDjiEexGGlbMckBTRcI5fmivXga?=
 =?us-ascii?Q?+LRA+o7abXVdHBdFruT8MTrzl6e429+MQMEmjQ/zX/xy9zYsZxKVuHhIVln2?=
 =?us-ascii?Q?62vDSPaELHzX8iTllFbD8fouvS8qPpSsx/LNfJZ1xEQRgk4sza4+XKCn3qYE?=
 =?us-ascii?Q?30/01GPy/247k3rn85OjFCUAuRK2lKZzuSYYC2LH5vKCBu/Rw64Cwei5IYLe?=
 =?us-ascii?Q?FmzrANCLeaMQmDlAEb7xvEY62JYlvUDUI9zrRKEJbcPXeKEjO9c8I/QAGYyW?=
 =?us-ascii?Q?XYI3sfVqR+mpCYJaGw9XBajZQoNZz9GRYCsuoTKMtO9jMHXj+nUdPxPISIbf?=
 =?us-ascii?Q?ogbrxm7uSpOyNBtnhwWhb/z/IrN3Ge8BKi9kuFjbm1MtYOyjakv0gBb61q3L?=
 =?us-ascii?Q?tJQX7gBGInmFNj2vGPPRn8BFnvI2buMALv797BxJkeAZUQYH8aqKQ+huS0Dy?=
 =?us-ascii?Q?9jeidMFYMZ8KC1wMHS4xRiG8RhGzYEqgqV2LT+LNFsRPcKTWPZzZ3k3gChUp?=
 =?us-ascii?Q?odMXL7vkMVwZ3LSJ6kIEkI8c/t8OrMEChjcXBBQ07zDPh1zxsPFUSBswVdwM?=
 =?us-ascii?Q?xAxGr1y84pImeN8iNd0tnu4MXiGMA+a3HzeWFiJZXhP8JUydiZNfx5+4c//D?=
 =?us-ascii?Q?SOZlZTx9wa4QrA0E18o/GXEt+A/b5M/jKMlHYd4p8/iJy2AgT6eZRM9DJEGN?=
 =?us-ascii?Q?zQTqAcrfMpb1JPHfH8zypTVXVyO/ZW9mhKr/khk5n6vMZA4xa3xbDp0k2z/T?=
 =?us-ascii?Q?H8yfUEHtXscHIspArHZvvN/sqG0aaPMatu9F+3A+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 135f7c1e-8e1e-4b55-a4ee-08dc728fbd3e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2024 14:28:06.1921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tq7ms6nrulmvKm2QehfJBvx27VOPmxNz5CsxT2UMRVR1F4ikmp4BuijIkZwAOu07
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8570

On Fri, May 10, 2024 at 07:32:16PM -0700, Nicolin Chen wrote:
> On Wed, May 08, 2024 at 03:57:10PM -0300, Jason Gunthorpe wrote:
> > @@ -611,10 +599,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
> >  	struct arm_smmu_bond *bond = NULL, *t;
> >  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> >  
> > +	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
> > +
> >  	mutex_lock(&sva_lock);
> > -
> > -	arm_smmu_clear_cd(master, id);
> > -
> 
> Should the new arm_smmu_remove_pasid() be inside the sva_lock as
> the arm_smmu_clear_cd() previously? This would also seem to match
> with the arm_smmu_set_pasid() that's inside the sva_lock too.

Not needed, the sva_lock primarily protects the bond/etc stuff. The CD
is locked by the group mutex. By the end of the series the sva_lock is
just protecting the set_feature stuff, none of the attach flow.

> With that, arm_smmu_remove_pasid() seems to be removed entirely
> by a following change, though its function declare still exists
> in arm-smmu-v3.h (I probably should find what following patch and
> comment there..)

Woops, yep, I missed that.

> > +int arm_smmu_set_pasid(struct arm_smmu_master *master,
> > +		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
> > +		       const struct arm_smmu_cd *cd)
> > +{
> > +	struct arm_smmu_cd *cdptr;
> > +
> > +	/* The core code validates pasid */
> > +
> > +	if (!master->cd_table.in_ste)
> > +		return -ENODEV;
> > +
> > +	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
> > +	if (!cdptr)
> > +		return -ENOMEM;
> 
> Though I might be missing some piece, the in_ste is set in the
> arm_smmu_install_ste_for_dev() when STE.Config=S1_TRANS, in which
> case cdptr is already allocated? 

This only means that at least the first level of a two level (or
entire linear) table is allocated.

alloc_cd_ptr() is sill needed to allocate any second level. For
instance if the PASID is > 1024 then we will need a new second level
page as only SSID=0 will have been allocated.

When we get further along in the series the above changes to:

	if (!master->cd_table.in_ste &&
	    sid_domain->type != IOMMU_DOMAIN_IDENTITY &&
	    sid_domain->type != IOMMU_DOMAIN_BLOCKED)
		return -EINVAL;

	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);

In those additional cases the entire allocation can be needed.

Jason
