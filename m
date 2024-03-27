Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8A514E2C8;
	Wed, 27 Mar 2024 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562913; cv=fail; b=bgxEF9B8GcKSyCmACxahJWNvJNE43bQFrfBekKAQx1de2NjBAl+yF9LdENdRrxXhN0PxMG4ONFj5FVTcoy30qhpks/BQdtBtaHMV4bqv4ppFnaZ8ZG2eDZfEBqPQFwjA+KaQxlSiNMO5zP4bRCjZoo56MQM/ydbJzgn8TJMeojs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562913; c=relaxed/simple;
	bh=OKr3maPMCeWVtZ9YxCDhTu5WtqnrFMyLb++DBjwDbiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qIlcMeTP6oLKHkAX9iCp4mtzKENbS7IXERR6ECMxA9rSf108B0uWaZEH6OmFRC0btoVST/A0Y482kvSH9na0Ea0UFmES2OaKzYNjrKIt7YlVn7BmJakmvTd2ir8c/wC+1QScvM1WfAfa1DIWi6mQ4KaNUDZX9TDkJvXBmkyTaBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IdAN5Vgs; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IdAN5Vgs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xnvh1FLhRnn49a01NqAfug52JiQXfsVPj51foa1z7zDL5eSOH0pblPomijiK42DW03SCrogeids1aPC4bM261weRAHkTq2UI5W89vg0RzUvCIIX0oWWza6i0DCvKCdLFt/cI0u7P91NjiqYOEBeN/RFFplSRkfg5oA8FUWiy4713bB8oT2RoQ6RuNIV7y+kuWNObLb7OYa6nZsQIP5XbnX7K7IbRb/InNW3TQ2B+P//0nY+EWUGEW2FW5OV7qd6jMBrxM2H+doqFJtRJGJ2AXFyPvG9QcpvCP17TLlmBfR/cylvOjlwD05qFfDAa+e6TmPOflQtNwRAaeIiHPw9+0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYplJVT6i2QO8Qki5MFmA2QlS4i7sXa+pl68wMcz9v4=;
 b=PactBvjsMJHLVMEekzPy+YxeYAc6P4pyrRxGoc72vxv4KiXOESCPGmluIhvD1CU94AlcTs+H5W1AC2vr7YQq/q61AaWfGe3qZPzMdXrWuHz0FyladTwghH+LSBipeQXosAFf9CrDPCAKMqtjjsxk93l8kK7cWaq+aRSvzF9rREIJcKWDxkeNHCu/f+5FwXnPokV90eIJ0VCIzUKoB80jwMRmLSPEuJwodKGn9CFzyPViGKdeg7HCCfWqqTWpmseXEJ4DexO+pxDPILZmiidlXeFiP5nlSsGyPXswxXS1Fca/us1/3/emp7uIIxD7+AUow+A8W4cca1rvbm8HcrWHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYplJVT6i2QO8Qki5MFmA2QlS4i7sXa+pl68wMcz9v4=;
 b=IdAN5VgsBXYxYGJt/2biJb2/cQJSCAjUIB0cs0Ouqkqv1iHp/p/R0XrQb85TtNWaFAXz9pFEIjJu0v7up+KeB4xU2kByGDLjAaq8YkXcf1/z+bxqP/4qOTSjFLFTPie439kgfiek5xeAyNJDOU195KyLhVRAhb+pPrZKMESPu9tg4W9l4vi44ZesIcN2NDp3da31tf0ocWvvWA+pY82Su1BQ1DoXONVy8OY1J8KWIACCfgkApiVfd1sNy3euGXZ0MV2ZhRUQt5Z7q+z7Em1NwR84eRrrow4Kv9JtU7WCr1wJN9uqEiwvYeXt3nR3xdiCsiVr2IwtWl9SGDqGjs8EwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:23 +0000
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
Subject: [PATCH v6 03/29] iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong PASID
Date: Wed, 27 Mar 2024 15:07:49 -0300
Message-ID: <3-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0312.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b05ab97-48a3-45fe-893d-08dc4e88e14a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yS83FIXJw/rNUHZ0fQ6cB5R/E2wyGRo6nKfH5c6iS5LxkH+7bEE7GS43f3RvlhtKMAOag5G84PtQDDzfmRO7no52ol4jSy0KJaN7JPn5r5fsQ8t6ESIUZD6GLC1gz9v0/v8wKz/G1OcnD3GGse1aQLQESYrh15bWKFn2q4DIB1Vbqun8M5ayDuU66x13kCsx3ostOLyn3HiA8C55YgKOSu1jtjz+Kx+oBfwfXN9OOVPfF08NjjhmnznDIQW2ctLWV2q1Si6rNW0of9lto24YFEDqrCgv80ysOf4ijsmUqd5ryMfYLh9i9CqXBAqXcU7Xqkrlrgp0zbNnG3Ke4s8B6jG73YD5XyvD+OroKvsb6CY4Gwri3CBngZYtIDNFMsURyvTFjLJXaNc9PbFk7jNp7dlc2VI57EPaTXkATZFWa1slBywBDmJx+Efe3udY6rn80oYVpBnwgms/RIWQ9RRC+8Abfs7PvcrVUhpv/gusiPX2gDrixrkFVwHvFaCvgJ/OeGDMFschEuN4JPaFIgGSHH/P80AQ/JM9vU0jSFKRDhsmkrNy5OrMRSgazViH/LCPEVjYgSlPlppWZ5TJSqp5rUeThA4HPIRHbcQjZzsbbEoabUkkPsd3nvyVrNECRBFYyVbJt2JX+rNW40Eaek+yHIR4pvoHDgh2frGlfzsj9Ug=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I10IeHzrwokqWPwR8pV/AkVxrifCcG/zzKkfbBJOSb7QAclE5tU/T+77qxTi?=
 =?us-ascii?Q?Cf+QlNRo4TO5rAzaq7qLSVTv9q4lQJGdea2BFtGxZ6u/H5LJ6fzRs3wLp+pH?=
 =?us-ascii?Q?W/EMrZUH3NqNeo/f4KjT1amCHZ0bxin9x2lk2QlWm1jiDmyoumzdQdvhh5tM?=
 =?us-ascii?Q?0KKnWF9EtqKct03u7DLVqPdph1TsFDsxjMihj2Zmp+34v0s95Lu4/NVU14kt?=
 =?us-ascii?Q?/60Buk2XFCxuoNmfj5OHATr0Nuy5v+X2/gPwgPQMgGspcJADpxt4aN0lQv2Z?=
 =?us-ascii?Q?i136Ddrs5ZiQ3Rp6MfJaw9ojp8688ZF6bZ+98tGoW3P9eCMUgcaeycZP/GMr?=
 =?us-ascii?Q?O4NASyfelnLxglukpZU1Q2SHMsOkoLSPlBHPasBDF+yR/dKJF+GPoi7iGC5d?=
 =?us-ascii?Q?xPkx6NxIIy2jCX9bZKx7IUZGsLvYzo+3nQO7XIS5vlUuumIX9qz6JWSLd4Rb?=
 =?us-ascii?Q?QJvzLDQywC/zjSdpV/N3ySYkFaIKwOTSxbbMERuHVAj6c0LjvkcZ41fYg6KC?=
 =?us-ascii?Q?vf//59F34sGVpSox8nY9cHBmfJ+szZ5M63DQM0DIh1Xfl/ufF8di4bso9Qcs?=
 =?us-ascii?Q?zM7Dlpsi5BQ48kZvIgOkoHEZ/FHLFxPKgwXcbCnTN8rojG5IjoJFciMighvZ?=
 =?us-ascii?Q?rRjUB1dmGvgnTFz9oS5YKkkKV22tcECuNbsmUECS6Pa4S3CKASXBnYL7IvZM?=
 =?us-ascii?Q?Ruk/DGzUdCprvCxsGP1rurJb5gohzL63JymuXIqWKX6lehV74+eI0dFg2uxr?=
 =?us-ascii?Q?awVWF8zq+1smpy2Er1hhauJR18ASQ7/tOa2ZbRmsbTbrLu5yZcAlhM6WoZym?=
 =?us-ascii?Q?S4aIxLnrcC6vVGSH4RbkIkynjbkoxwp5kpNFgfDmLKy0p7FtL+ICqTdYVGyG?=
 =?us-ascii?Q?TBeP7PEt7DwpH87kP9h6Xc8hRanoJy+KOL5BQ1bpagn6eTS8S1ZPGdlzRp1i?=
 =?us-ascii?Q?blDOxLSwb45cuQCfvrCvnNmy1a9HuJBv7AoFEydBwrqvzL2tiqXiXcXn6o+P?=
 =?us-ascii?Q?4mYd9Dxx5HUdgluee1WnkP3O846NBunYAtPhnCglmovUlIHqqs5mp+XSXcPw?=
 =?us-ascii?Q?bvze6oDR0e1hFcM09qO/f5zwIl4TDHa1XjEmn+daroqWGdx7BZUXhXEDdjNh?=
 =?us-ascii?Q?v7tlmRZMDx6FlnUOV6rP3Jr/InJn6L3Y+jFYh1akE/ybOF7QB9hm99nvVObs?=
 =?us-ascii?Q?i8aNRitM8L2Abns2J5MqSPcT2FG9EuSd3XEBoeaeOK00U4jYOeVh95IE9raJ?=
 =?us-ascii?Q?bQy6i99Z3f9uLiFMfr7m6amUFSvgSwJVYrUudiNjsfsS9EEgux9uPMT5TfI9?=
 =?us-ascii?Q?E6j9b52/Dp+v6RnAr0ycvtB0XVowRDTBJiRSUuEIinxQZs4WFcjZ87Gobpfm?=
 =?us-ascii?Q?aDpqev+FSYsl26lV+wNzqMSAoBvc2gi6P/NPxWDzuNQdFpuV8uTgp1KYNsPG?=
 =?us-ascii?Q?p01Ql3IuBXMq+UcjTsniIWISxyiWEfdRGkY6ZNnNIPGeNwza+ODl8GRvnQjI?=
 =?us-ascii?Q?GuqHhl7lMWKKZpZMzIgps3TjQJ3ZWog/AmEp2rTcCxgD7Ud8g6iUPljja5di?=
 =?us-ascii?Q?UGSe9MsxY5xjVtm1gyuGYiZmBfvTBeXUwi69FWBK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b05ab97-48a3-45fe-893d-08dc4e88e14a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.3188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkFZWYEIma5zz8NaP3JvgZJ8BPxTqJyFVuzTDmqDvrnd3s7J3XDK+XawEVu2kDgk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

The SVA code is wired to assume that the SVA is programmed onto the
mm->pasid. The current core code always does this, so it is fine.

Add a check for clarity.

Fixes: 386fa64fd52b ("arm-smmu-v3/sva: Add SVA domain support")
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 2cd433a9c8a0fa..41b44baef15e80 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -569,6 +569,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
 
+	if (mm_get_enqcmd_pasid(mm) != id)
+		return -EINVAL;
+
 	mutex_lock(&sva_lock);
 	ret = __arm_smmu_sva_bind(dev, id, mm);
 	mutex_unlock(&sva_lock);
-- 
2.43.2

