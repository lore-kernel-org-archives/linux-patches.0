Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4285817;
	Tue,  4 Jun 2024 00:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460172; cv=fail; b=s7ikj4AWgldbZUUPJFKlABZQh+3E5PKNQgZup0Gn3VK2OwKoRGSeRusbAkhcXme/K2ao0IHWFv3S5fcqkIjbg1uSj6BAg0skRAHJmgJxiUGta2YuIwtUPqTIzM9woSh+FhV9V7yrijXKJhSUG4mW64b7Il1j+rk/8tPqJrz9DcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460172; c=relaxed/simple;
	bh=jb6h1JSSWIKyrgpFoon+5/DsDjlEJhWPwZ1SGjjZsiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZDmUbAFNYQdeJJ4ozdF10yjlV542HhbOP7nhS5TzdXTJsuh7/3GXQ2MfX9pqgg30jt0LO97NkeFp3kuHwjKS/cPb77ws7pQY4KAsd98UFfzZPhU/rckppS5ub8UEBiSWfORfVTAzAQhW4qaMAqGxVniBScq7uDwVWmcCopO7bIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RaCfIPh9; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RaCfIPh9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zo9tOqcRprE5+sSNpBRpLfA6OhXX/IWico8GGxTbSxxcKmiYON7z9XVyJLug2BxIMzgARofStn0VRmlSEg7myz2AUUC2KAaefOIlrpt2k8Px3HU413JpKkybHLl0Wna+pvhthWRXro4+60fuy69Q2i/2I4oN2gCtU+dlh9B4BE3j07iIM3PLYgvinZuHEMBvZDFT2h1lcg+AvxR/pLRMgk6V1auHuodPIXlpLxHUsn9CK2MxHrh4sroA88ZUlBed+33dXvJF6czF4/1HvOC5QLfbp4dFhopGRsyPEBgl0zaqNdCDjb2ZawLoaWNFuzhAzAQHT6nDKCbWaMjecd+wyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTVBkEYsj9G/CPf70NAUiHk2pLwRaHrDKXv6mSt2U0I=;
 b=W5uGfztzydPmPehoH2qUAP1RZgVAOkxL8P1zWLu61TurNzyoni3rOgUlrkgU4tl9f06qTlOmDko3Bymv8Eh0LN5osVkjbNqAH5CjEuAdLMP5PTuVQKdr7H582G9zB/XH8pGmemVjTE3gsNWm35ZQqUHQzJRPE9FlhFPIwVE3XYQAAyVACm0Pa2Z8sy3wGYTrPYUc9ixpzmdokv3d1S3wWpC3Z/CkSiyUPoLvzQLkTFC0KLx8xVj7JPvGWwJTT47ap7KXkPK1lVxgg0yMs3si+yVCQvYgLA0OTh8rLMWi1jde+Q8Pm1LWGVHOnWJpWMaXlgFkaiYq4bWd7an2O3ebYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTVBkEYsj9G/CPf70NAUiHk2pLwRaHrDKXv6mSt2U0I=;
 b=RaCfIPh9/hRu1gMiBdXw3qarCBUixqwOeJzE5kSBmS8HLOqeG9JDdliGKyCVhOjWwtazkfGmRBNArP0o98nOWZ9MbMIyvfjQWI1pBUWcdA7nQey+S59ZiTZXiZLQk9QGqH1iZAQm6cmfOErZEk65vr5lOKpnglVcyOTzPyOieCvMJkK/H4TJLRjoEeTpy1tfIqELFuOlt0GkGtI0G0WC5r36/KNezWrwNauBBhtqAbCKRcgslVNQLHPL5Kr8Ds7+Yr0MuWqecELh4AzXDAn2DMiBvu27jNSXAvNGsNnHfeNGGqL3Vk42oqZOYefHy3XldxpwQ+8UfBGHoLJJUsAtIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 00:16:02 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:02 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 09/14] iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
Date: Mon,  3 Jun 2024 21:15:54 -0300
Message-ID: <9-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0427.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::12) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: c114f983-58e4-4f7a-a955-08dc842b8497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gdp2YFjAgmdQJjZ/M2ncNlxDKOIM9fRuVW5qC54TO4Zz29nIM4GY0fAOGPa2?=
 =?us-ascii?Q?P2eV9Dv3uVfcfH9rVmGGDYc3r+TPKUvB7mtHauBfX/0vekQ0PLeGaurFQcjq?=
 =?us-ascii?Q?A9zJl3LTiSp7RNWa3Kf2Oh7F5SDRLvmGPJ+iTXefBL0UiHZgXHBmosIW/D6r?=
 =?us-ascii?Q?dXp/ckj9+FSjZf7aN78CbW3cuowX+l8TXh54npIUwTQ1rvbSnJhvONwPsGpN?=
 =?us-ascii?Q?xJC09vLesvYOeJB+4aFSaLljz3H7iv6dpVZR9JBJqQO/LwsO1BAwEakQcmb/?=
 =?us-ascii?Q?C+++z+PVE9Eu5IysaPK6u9OMZdA7OTswbmmw51x0CngYItCUl2yCbTWf9N5G?=
 =?us-ascii?Q?HIVKQogvNIgNQr8Jl3slTQh0pxs9RbCvxCRXdxR6O0Min9DG+CtzvQLYhbV4?=
 =?us-ascii?Q?5ciGpX/rz4QIuyoDp+3zoWcwHGMinQNsIOCZjsYg503RSpHknD19sRU8ukFP?=
 =?us-ascii?Q?OEmVCzBNc5xNJMSTyVVyYxMSY0yU2ikmU9fluAvmX6u+EiC8vjQNMgqI/Sxs?=
 =?us-ascii?Q?NAhMLmjv4A1WowwRod3q5xizqXyNdgiEdrcYw2zqiythAzddcU0uH/MzciaO?=
 =?us-ascii?Q?hVDBbtLEH910aVflCmv0liZ4MnJNfO0xCl51ug5Qh8P6+qZMhTSEff5i54yU?=
 =?us-ascii?Q?avmyJr0A+4oieB70dVxb7M+7g6UQ7feQk7T9R5b5StbXxFVgIKN4AlsItA+y?=
 =?us-ascii?Q?3hCmEebGTPflwYxhBnDPuHhr9C7/JqByHdeYW1Y1kympz4bf4CZBL4YZBP/4?=
 =?us-ascii?Q?Zt6s2Osrk4yv6/Gt4EjM+d4Xx22N0HePt0SU4O4yhGXCv+7cqxYXYjGFBk5S?=
 =?us-ascii?Q?ICbT6t6uI/FjvHsbysriAdpDKxDVMKZaDHnsRDI1cDWDr9MpFCwBjLJt82+2?=
 =?us-ascii?Q?p8k8Q9UjbjwLyRMhErdsnjSjtLQPPT4f96AWEhd5Z5uNR15zGp24cLAfdyFH?=
 =?us-ascii?Q?q3YxzA0MU1ImPffIg6QtOXP7RLhEOiTzxg3Go8RWJlDUKmipzgpu6LMHlB3F?=
 =?us-ascii?Q?9rE/RdJd66DbBHlI561ONpY+KiTrrEEH3hz7aINQzkJWY5UbCIkTRq6V/4M4?=
 =?us-ascii?Q?8pjIzKC25hFNrP1hyrC3R36EiDnADKicrb4GGHRNgOhMvQOozl+GycJmlCJQ?=
 =?us-ascii?Q?ORoqPLdEb9KVILRsVei24eC+L0ZvArN94Rkn5m3Hc+9IfN6l58pN4ZECWmsb?=
 =?us-ascii?Q?2cLmx+BBpcf+RTZGj8jASiJZtpVRNhBnUYM8eJVVNtq4gdpOPZiiUWmoPDlP?=
 =?us-ascii?Q?mhvz4Bo71jAKe+GCmskyBWVaTBv0GYmnfp/MrA3Xhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EAHPlHZndgg0+eD5b9JxcktlGs/ilMxlyHPgVKFSn0bp6Y24/yCgEGlEoiQW?=
 =?us-ascii?Q?pE6GtIoRobDfywliktdVnwiMvuT+qI1krlSPxKcEGaKCrVjJHtvfm6uw8j2q?=
 =?us-ascii?Q?ZScHLSIIrnZy0hpqF4mVS+0+bNieQhboFemPXf+2KrpD9TodmkXFr0XS5OgH?=
 =?us-ascii?Q?juZFr7zEqzoGBWYkA1FewiMh3StDGe/3H8jRiYS+IL6bMnAmkxtBwHZm3zBO?=
 =?us-ascii?Q?oTiWxh11ETV0yBbW8vrD9uMiENHT+0uaEtXcHELZtGwSiI+qpU/f6Yf973gt?=
 =?us-ascii?Q?WecoqUIeblqHbiWWE7ByxWJGa72GLnQns675oWjKXuHgtJjcLP+x7jOMcBOO?=
 =?us-ascii?Q?9d2m/GB620rLuo99PmE6exAUUT/B8SYJjnbI2LPpEczZvt7yIcXPdVYnhuxl?=
 =?us-ascii?Q?1q1Bqv18X0FEoib4/sQhORnVa+wn7diOx9V+dhsSsXGsPOuu18stQVIMypOU?=
 =?us-ascii?Q?908D9AxR9wlydCaZmwhFkUc8UYpnFHaG4LLaeucB8/cxUoa9dJzcSAJroI35?=
 =?us-ascii?Q?mHeWDY8bugeMdThiFKWWjbNvrIwnJ/c3PJ3KQlflA3F7a10R0poqTlruLZP/?=
 =?us-ascii?Q?FRlhkR+QxQ39GAAdsblLShSy2r3rpPz10t57v7aSMf4u+326FC6awPJeLUiR?=
 =?us-ascii?Q?JK3dQmgpCAAw6apxxHdE3ZyE4kL9pVlRK10hQoSREjZPwgMZs5cVIn3d0kAI?=
 =?us-ascii?Q?6YM0g/KVo+4EDS/z1adCxYXVcpxsdMVSSWwetKNTK4jxP1MOar4Wsl6/3LfQ?=
 =?us-ascii?Q?q2PCnx9xJtNldfcZDfRpHgcGsXSXWCaIc9QmyL1sUXydmA6Rim7yuwpyKwId?=
 =?us-ascii?Q?IBMrt3UclFd2liMQToBy+TjinR2vO39bdXVM8xveg3HE4igPI/vTej5QvcDz?=
 =?us-ascii?Q?fTCbzyQ87Hg0CMGT+n6zvDIBx/7Fnt/Vq3qfQf5sGWqwtB8VrkcdKPVt7OfS?=
 =?us-ascii?Q?rweBpyRg6xO795x/u53VXX4hWAY2llWZ4YGw/EJ+xicGIL+zy71IS6hPSV3S?=
 =?us-ascii?Q?FlDlOpMVz7TuDuMFyya5yzT4SrdOpzevR3GkmIQxv+kyE60J9I/9/+DkPsDw?=
 =?us-ascii?Q?5/uZOrFhRdMA1R7fJTiIeLSML+3JbgUQ+5K6rb61y23mrIDykY0CglFMlREh?=
 =?us-ascii?Q?tNrMddyU/nk97ekj3Q5oFQq9VJt3tnt056iHyLvEvu6e+erBGblig0feq6oX?=
 =?us-ascii?Q?IAU2Y/MSUfx6mBdwy+UJOMeqZvOLMyQXYC6P3d5CxQBx+ugUd2ELXldNi87Q?=
 =?us-ascii?Q?Q9QPS4k/HR84R2NkHYu7V2TcCxGAfJ0R6YGOE2AwKWN6YG4SWkRixTedOjWB?=
 =?us-ascii?Q?1QvhoovjdyMTJmq1h6QQlDNtOHvuHjmyT1+KVHiP2MPMWz3p4ohOJvQl5yum?=
 =?us-ascii?Q?yhhrE72wbNythkrP6vMKIH3WKFQ+JiA5TADJLKb6Vmr/XvXeu0p+O4Dtell9?=
 =?us-ascii?Q?8t+RxoxezRM/yJX9tB3YE40QQE5pmVCE+FbhWPQlOlFXKDPbxzUsMvhAS+1Y?=
 =?us-ascii?Q?5cUGYT1esKiqz2OV+mw4wE1nugPPMtdoAHAmoMzXOlH6YKZoyRM5reF8p7TK?=
 =?us-ascii?Q?YdmyXHUGFVeRiStb7/A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c114f983-58e4-4f7a-a955-08dc842b8497
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:02.3878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uem5dv2b9+JGp9Qef2lkj0qaUZNLR2uk26Dpu5hngxxU9XOniGYiZAHnK7IVi6bJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296

Fill in the smmu_domain->devices list in the new struct arm_smmu_domain
that SVA allocates. Keep track of every SSID and master that is using the
domain reusing the logic for the RID attach.

This is the first step to making the SVA invalidation follow the same
design as S1/S2 invalidation. At present nothing will read this list.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 30 +++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c6dba933d2c38c..24000027253de8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2587,7 +2587,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	/* The domain can be NULL only when processing the first attach */
 	if (!domain)
 		return NULL;
-	if (domain->type & __IOMMU_DOMAIN_PAGING)
+	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
+	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
 	return NULL;
 }
@@ -2821,7 +2822,16 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct arm_smmu_attach_state state = {
+		.master = master,
+		/*
+		 * For now the core code prevents calling this when a domain is
+		 * already attached, no need to set old_domain.
+		 */
+		.ssid = pasid,
+	};
 	struct arm_smmu_cd *cdptr;
+	int ret;
 
 	/* The core code validates pasid */
 
@@ -2831,14 +2841,30 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
 	if (!cdptr)
 		return -ENOMEM;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(&state, &smmu_domain->domain);
+	if (ret)
+		goto out_unlock;
+
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
-	return 0;
+
+	arm_smmu_attach_commit(&state);
+
+out_unlock:
+	mutex_unlock(&arm_smmu_asid_lock);
+	return ret;
 }
 
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
 {
+	mutex_lock(&arm_smmu_asid_lock);
 	arm_smmu_clear_cd(master, pasid);
+	if (master->ats_enabled)
+		arm_smmu_atc_inv_master(master, pasid);
+	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
+	mutex_unlock(&arm_smmu_asid_lock);
 }
 
 static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
-- 
2.45.2

