Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A13131BCF;
	Wed, 27 Mar 2024 18:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562905; cv=fail; b=XqjRPtqeHRytyhQ0wAGfc349u2YbBVS9QfSeHOSi0WUNQSMw9yE7m4wOZ4hIqOLRCzBx566giCFEq4ZN5spTD9uMqUlP6Ekk7pRt2YU4UbNbP8a2gb/kSqTY8Hifyi2fFK1F20GuHkC14Nl8Qko8aJ1ytXh0Td9RrkzxodHl7TU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562905; c=relaxed/simple;
	bh=4k+DdHY4XR9spBbo0rbxv7+9ieOuHJI57lPMZhAHWSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r3vsX2N8cqasmVMyfh8yqoZjja7hJabmN7u4yf7F2Tl97kgt5E/ZrxvOwMzgqpwDwWAvDHc0XxV7EV1HV2oDvmAK+uJBnUKoVRJ/8oS7DvPnqBdBWkLFOk6xdu6Nhjx6Ov7sWEjvEkwuYzWy3TNeRebaZ7wpji364fJRUTSmFXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DHTPa9JC; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DHTPa9JC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIpQcWfd3ZhknHeZAJtfd749zwHDt/SwfhqIO4seWLperwyiIK2/2dtjdWddvM11I8yCdlXjZPzxmeYaxgWFJiVGZJ1etq1IfebT04N3EznQy8id5reiaL9crWu3mNG0TW4jtlZaHa8828gXm9gyb+kXQcMoF3mI865b2CmMtd1F0h4Ie2DHqlUVOaylWc7tK/ODSuCrVasx1NGiOVBgssZ3JQ7LpW2orGHVHpwhxwOV91TTb0/s6cKuGKH6WnAWjFbuEdRT4WPpVDSTBh1BVQXB9ZwogoibFiW/hu9Q+43PIILb6r8MaAYIDbT6At0SC0qNlwjjPJUCr3A04H768w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKIg8fkiyGwdfKLRu0dNuardwFyH3L09ZLZSUEodqQk=;
 b=MJDlE2Q09swmGvoijCX9hkWj3rai/tu+kPV4sKRv6NgvuF3EWcht4jQm28KYin3fE7+ZaoYpp+TA2qoHSI5f0TIgepZIZg/AIa1wz0MP1AA3aIEZygcBbe4aN3YDUM/l7ESZq4VWYXOymM/zo8kqBbMWP21cQZTe1zME5hL5E7MUptti2H+YC4mwRLY2uqVkVCO2qrE+XhTK7P1Z7qsLAIoxQiObIbD7+IWwNayRoZzAhjyv2nG4JFE07MWDsSAQbRZTSuMXCOAbaxTjfWjrt8LL8dUcizGnnEwKxJXMFm3fslDqlLLowPrg2UP5ee2cEh/joE4lMgp4vg713qM2TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKIg8fkiyGwdfKLRu0dNuardwFyH3L09ZLZSUEodqQk=;
 b=DHTPa9JCUB+VyRyUbyuW3JWjYA+q/97aZPjr72nA+lzNx61/2CHUDvWb7u+E3WDFmLQFqHLR2MfRYRx/DFh+rFE3KCbkz1XN6/GuiGfz6kMQFJgLoI/8RdzBzYVyculb9tVWr6a8399ShP9mMnPDEJ+aQOt1P0hRT6qnL7O9dv1wNkf4yOd/nUh9PhtETmfi/LagWBkSwXME2v6bQgpqyimQgChzCcgXAzv4AxOIFrdzkx14RusdGbJq+MuZlm6xjWod9KOAe9VPS/Go/uQW+C5+S7DXqGqeoZVdU1FGJiPqvRfItV5Jpu3XVUmEkIHvm6t8m1iyVde45Csj4jeRmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:18 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:18 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 11/29] iommu/arm-smmu-v3: Allocate the CD table entry in advance
Date: Wed, 27 Mar 2024 15:07:57 -0300
Message-ID: <11-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:208:236::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 3108e2cf-a03c-4fc9-4821-08dc4e88e0ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jjMZO2P4bQdn03/a51G9zOqoVtFfDvdoixoNV8PIeO2E+6YPclNYqSakuZl/qjp5mBEhA42m+FkWB94Z7zWbjvW1vkUnqDs4PcdGTjlQUS4Xzt+4Pd1eMp0YTF/l9JOp4z2XSB6OIp4L0QHexjsIJazD4t92889xhP9oxdVKQvHdsaHqFuvwZTjhrv8+SWtgDJKE/jbxVw0gN+q0nWjORegKyinZFcthBrdhrlab/nHE0Ojf1LKUmkneE2E8MqjbHJeEjWvp3ceOcNngDxtCMF61XlwOCq5rZTO+QoZZQs9CP0yTjCh/AvYkCVD59p1H79IqjG3gHRdEJJX9wD1GiMaxkl+7c9Df8B5QMGxeJB51NVt5GMTF29ZOUaIPfw8kvppMMGDSZUYWsTka6DyFAYhYzKD/T+VqIw8Av5ra6MJiDrfabq0+/677ZRVjH2veSqz1JsftI4s6I29U17gjFbKiMeXmyG/OB2zgHraPg3otkeoStWPVmHs6jtnYKV2J7wb/9bJKKs8J8FQfbTjKXmYbpRXSMqEGqYTejRd/r5fN6o7PCkegVTK8pp7y103aqQzKewzrUcvDlhVjo08O0zMbCa/KpxgLlQ8GPsl1lpxELyJw+TT54rBy/NlLs2Yi6P2F4w69hb2SZPlQfiMQY/hEL/1REieJf/+Ri3TgDdQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dKj0VupSrK1Qd2Y42xnKuLdrYBrJ/NS9RB0lYhCuL97M9j9J3nqCIVXxu+QP?=
 =?us-ascii?Q?rA8zpwb9LHoWuYivusKnpSN4kqZoaJJ32RAYnZ/Wcki7NTXbPiEVD5N/W/Kg?=
 =?us-ascii?Q?giZffLgT1XYxFP6As3RBDXZlNfLnOT8IQ8daCRw/MOaCM2sgQvHG9WalPtZs?=
 =?us-ascii?Q?4oVnYeASsOwkI3C76fJF2GWe+R3wSBEdPjL5uqjj/JtI7bUYWnUJTV8Nbp/9?=
 =?us-ascii?Q?Vw+k09fcZExfUUFlB08u3oOIZg55vvQgVnGHrFjsr+zb9mgBXBAyscPStzYQ?=
 =?us-ascii?Q?hUdDlR79B765G0g+2HoW3tq0DFfVnyxsd42L75jEPAAjXxisKSo+F88YsLaO?=
 =?us-ascii?Q?vhLFHSm1fKOmAflyT4CtE3pTjlUIM/e42UePRrYrmaVKjrhPzn0SPJ1dFqUc?=
 =?us-ascii?Q?f5swmknyIQ68FI0VoBgpY6BmMEtAitRqaB3qXySq0bgTz+ieyiWe/d48AT1+?=
 =?us-ascii?Q?Uge8iV0OyNvSO3kGvbsqV3niU1c9o7g2YuztFgPkx+gm64hG0W16DXCJ7hmb?=
 =?us-ascii?Q?egxB0z3CnljpHEiiXSBj2IDhcTcBPvj/ua1+zxEMmnaJJ2/gvTeC/s0vjJlL?=
 =?us-ascii?Q?aKkcLwkfEDDMmLQVQhA3w8HVmGBWWnRgs2dIwFx/6OA3Jxqo5s6eVWC+OMZU?=
 =?us-ascii?Q?l2WPmBYG/j0jRi9d1gQ+J2mqBReIPp2KLUseq/8y8PBiTGL2RDklENVtZ63j?=
 =?us-ascii?Q?Z79PX2RKqoF0D4ElbUMzz67iixTg4LFkpgbGXmLZCvie3ILq2lsFzqnwXy4+?=
 =?us-ascii?Q?LfEW4l0dTpMCB0+bI9j3FmnM0t8VXHQA9pn4jakLezxX4MrtXWGDHerZJMgY?=
 =?us-ascii?Q?xvwlVh9Utdp4eMMkhIUYDcCKQvut5nmRcty5YkzHRxbE8oALWM32B0mqDO+s?=
 =?us-ascii?Q?QmnJWgMATjaFhbYrBY/Da92v7sESKskIvTRcb1N72a0kZpTRhQ2VynoKk+Uc?=
 =?us-ascii?Q?EpMeAsOBkMtD6LxJ6boxSlz1t1+705kkRXKqAIThXLcZElAxXev3SxPX0oTd?=
 =?us-ascii?Q?naaYwEwulhJIL5itv1GNFc9ieUEuv6ZF62HuvjGZeLZONjB/OS04l4tT5cIr?=
 =?us-ascii?Q?987grTLc4FR4fIV/i/R7mNkG1OzrCJ2MmFMvNWfjNJN3r9VfKGzS1+hcGv/r?=
 =?us-ascii?Q?Of/SWHwco+hmnQUx0XYfjni5kuxhslq4gqCzg3QNpp6PjyrXoG0HmFa8ukTv?=
 =?us-ascii?Q?JKCRPXlhNoNPjXptBYBUkb2tGZt0m2ToCz85a8bvXeLFMLOmMsD4CC/h/NjP?=
 =?us-ascii?Q?GJnjx+O4S59ypCzJQIRgHQfKxz3OUo3v0ZMjTeSo+2RsDWPjGxAz2QXyZsAj?=
 =?us-ascii?Q?2gIcpGnJ96R4ovFerCp0rEn0e6H/ad8jIHvvzgvNFMloJj3QXpck5suYEfaE?=
 =?us-ascii?Q?focLuMY/IzlrA0pLugkFXBmZenq7GobtFDsJfEJ9twiNKeRbabEdIMqLwUXz?=
 =?us-ascii?Q?6JpOIaJu0H+Q6fC0IOVXfcCWIcs5k9+m9yKufZH+DgKKeCxulMQRFXRR+HNe?=
 =?us-ascii?Q?Lq9P33tGfGf1eYtavtSh1WI2aJ3+z+1uMM12wIAHjy4CtrZSFxozowoPj3aI?=
 =?us-ascii?Q?/c0z7PrNvni0A4LSv5VrR7Scwc6OnuHP5ni2/ibs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3108e2cf-a03c-4fc9-4821-08dc4e88e0ad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:17.3427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TF79dbTXHpfZQfWvXZihvpsVUvza8dLJARCV45c+5aU+c5Yjttdsiz3reYs518Q0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Avoid arm_smmu_attach_dev() having to undo the changes to the
smmu_domain->devices list, acquire the cdptr earlier so we don't need to
handle that error.

Now there is a clear break in arm_smmu_attach_dev() where all the
prep-work has been done non-disruptively and we commit to making the HW
change, which cannot fail.

This completes transforming arm_smmu_attach_dev() so that it does not
disturb the HW if it fails.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 +++++++--------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2ea4fe9d6594bc..2bf55ed4e32ced 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2663,6 +2663,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master;
+	struct arm_smmu_cd *cdptr;
 
 	if (!fwspec)
 		return -ENOENT;
@@ -2691,6 +2692,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	if (ret)
 		return ret;
 
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr)
+			return -ENOMEM;
+	}
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2710,13 +2717,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
 		struct arm_smmu_cd target_cd;
-		struct arm_smmu_cd *cdptr;
-
-		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
-		if (!cdptr) {
-			ret = -ENOMEM;
-			goto out_list_del;
-		}
 
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
@@ -2733,16 +2733,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	arm_smmu_enable_ats(master, smmu_domain);
-	goto out_unlock;
-
-out_list_del:
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del_init(&master->domain_head);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-
-out_unlock:
 	mutex_unlock(&arm_smmu_asid_lock);
-	return ret;
+	return 0;
 }
 
 static int arm_smmu_attach_dev_ste(struct device *dev,
-- 
2.43.2

