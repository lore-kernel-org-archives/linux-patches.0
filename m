Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A72914D6E9;
	Wed, 27 Mar 2024 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562909; cv=fail; b=TvxwGkAPvlGN8lQHsosiYsfkwQ6RQsAEjKOoYMvL6ED6TJNhyKaJGHdZqoj+m/Zi3VjvkOEdNV+Q2/Sf+7nlowuFt0e8WYuZhKHczznSXyI7SRChOlENql5PccmaefSdh0OMtxGlf4GlFoY13m9E9EPzAf6CSgoUCiuz5gVjMa0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562909; c=relaxed/simple;
	bh=rkougF/VKGxqjy9dCnu1ClR1+orS2giZHsHkSQGBZUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gc0Em/nRGYdZla2EJM4zcXolMN8zrLA12y4Mhs2h042Owej5P3Apf/38/2A/peQPJinDOeA3329jvlhIWYzyfulX7UecUpCyH7CBr0gqPUBaEWBSzPompwBh7FfRFkb9ULMDl9kEs1xG1PGJCrdnrTLAPZx49xDKDSFu22eUsm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kb8RWZJv; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kb8RWZJv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EF0oKuAqeRTIDYXYC60eMAl4J9aM8/tUwAWvKW6l/+Ni5Y20x280fL7yLMk1rKjQBLXDEwTK4+jjyasl4WmSCSDf401Aa8wjoW9Cu8WvkTNDhHP2xtcDbyb2IOpYtbEJ3DdombQiTz+4Nz6p5EJHRDXEMwYNbt/IDAOoiQmPT5An1BpKw9TUuihglV+kZQ46C2XVFQFIgMxVP6fvlj7aa25a31M/6iNxZle1b704XmPJqDqeb1pm0nDPvz0P9us2po/Fai5snktNqh+T+zQitpk4vaT83Zz/2mCQd8191H6a88clVqWMW6cl2OKuUy6863vDtmp0PeA0qXO3p/5vZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjcPxWTDoKE5QE2U1JWsA/frcjjI8u6RrYDI05HXnBY=;
 b=KV6bBYlSm7s8FyqfOaav+26/r0me0YeeeXdSjmflTqFwlKhuVjQVC8FSGdij8IFCa+e3q1tnCSN5e9FYhvdt/I7uuA3uSSf/Rf2fMa8ddWyepgpyu8YjCTH1iLLgHs7ASv46DHlLTw1g+anJPhBJSVVNal4PfC7qauiMRM9KGJENAUHaBgbM9lTyiOzFkBvFvPLtavps9QCxWUIh0avn/OryI9S0Ovk0sBZRp3uyvQsknmrnubedL1nbw/D7Rcdz/hEwwy8OAmTU/zElwvbpHGhejSgQ7Hy6gTrFXXOkcml+nbllmdTrq+4KckkyHLNvae5BObGPbVaX4ZzHoIoLVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjcPxWTDoKE5QE2U1JWsA/frcjjI8u6RrYDI05HXnBY=;
 b=kb8RWZJvIuYD6+OxZY8bCU04D4Pa0/Z0fC11LoIGb84y/9DeE2Mta5DdzfZ4WAldoEo7/UKHhvJxBGgl8aLM7TLb+T+pJVKV6CJeVN0Pasa28GbeOMdXse5Sv2jAmR6kVoVaYjqTMOKJoObNlgtDOoTk655UWtdYj96zprNAX9wPY2RNWCfxzwEbqvnYc2FXr/M3IEQWE+I/q+/EnBw4Q4GtFmGTwuP3W6C5mXfxFCyG6BHAjh9lABuxQWO61ogbjoFDT0vp9TOwResyMy2hqK/+Mw9YeeeH0vzyf5hff4w6Sp9soYucdI/EjFYWOurWb2J+OzqpG9eIFzjTyfw/dQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:20 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:19 +0000
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
Subject: [PATCH v6 04/29] iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
Date: Wed, 27 Mar 2024 15:07:50 -0300
Message-ID: <4-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:208:91::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: ddd7296e-d957-4d45-9275-08dc4e88e0de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	G+2KXiu9Gb+fPkHUXsW67hu/RjXz6t07jViQ0VQ7jFNFxajXTGS8VQBV2RL+eLMHufQWaLn4KN/FrZK6QXL+a0/GTrrhlnxNLNsBia2qUbEk5F/8CUb7qrYMl6MKl23l107870dAuFSJFxi38Gd8qdcDkwz8WEXpk5rvV9jOt6HKH3o8uJNSaspIj0gl0lJA3vEcHhItDuAboBYWRQqgQwMlunA0AJ+VcZdXND1f5CzvS+C1U66SkZym7nW3k5DePY/Tiyaukx66swuAOBXS/nLqEXeaC1m9uo8vItdPth+eWW/wX0/vunPAduU2ltgOLd1U9d6cHDsfy0b5cRMdGxeA6U4+Qsoeyx+YGVtIAWy8H80E9o3A49DH1zGJufRmM1SqkB8gXbA69Oj2CBLM8uY+uOonvvdrBSlWIS3MlLgAH2PrNdfcaurm8Puxh4WJ7sKjX5Z5TRTMj2y8zH5NUnw6ygMyPmuX1kfj/BLydKvn34Aceyj3Pquu2bVRAOMskn+Mn3ZkhpUOOpPtGAY3JaPaaX/Ou+HG2LgM2LCGmuegb1RzyMLaEFNPd7ER/pAozrDiI0CoQSvfDd7BByB0YXp4W/xCOXND/ix0C3UkYKNoij+o1MugQ5+SzgMq3Yzg4GBh+NWOKL8UzXzcVyzxz8EnKVUw29uIoRIwdodY6VI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ksISuH4XfcgxbAZFvSPqnMu0QlNJf4Z2antcxyKpTlQCOVCSQWeYnxXDVvDf?=
 =?us-ascii?Q?45MmEioKhG7r/lNp+jIl3k8OXUQVhl7cRS+xLDgiRNR4kGlY3LcEdftHj85k?=
 =?us-ascii?Q?HKayGXkoCD4ZPpgJhpL4fortR7e2wqBuF6vzlF39o4ptd0CoAaBx0OOG5ZPD?=
 =?us-ascii?Q?/k/M2251zX9c8nvK+LqEDyLsf2IysKLW9lBaiVu+5de8m7B4AdzilDyvCoNz?=
 =?us-ascii?Q?0Vz+xVqeAfGw06HdERgU3R77fdIezycaO/CKN5B/IJYSotdboAMBPtYyQ8no?=
 =?us-ascii?Q?gp0V6+pTfXJDBPbwOKm8XDKtFCVtJK7L1q0Lsbltyj7bAFoBp7/I1GFpQ8bV?=
 =?us-ascii?Q?QXRuCdlcsVHaBfB+3yfIADDWFAFPH/kJW++QMvqEpRXsOJKyh0kkwjWsXY7A?=
 =?us-ascii?Q?ICTarBoazoHLyX/JKLiyLD9K3bntpbo8FGz0HAs8Sl+Cae3ToKUcDX4amt+P?=
 =?us-ascii?Q?GIWojJdSG/d9S/0sy1n+Uid51zrO4tVJ12hn2sJJiCCVCqr0zhyG9JeQFqsE?=
 =?us-ascii?Q?+h9YDRR7EhtKxs15kqm3eKJjmLtO+acvr5b2hx6ObRYfPECU4YOODEr7x2Uf?=
 =?us-ascii?Q?Eo8vG3GruULmanUvytddr3QM0E7RQv4iOKJW7/xmCVxqcdcrzXojNpJe/xL0?=
 =?us-ascii?Q?mekuPBertVCKvYdB8LoKQ+O38Iw+D36bN8g1pO5v19uxBImxy+JRCNsOtbBI?=
 =?us-ascii?Q?E+zTLFcXZANK+ZDQSnrXMze57TBXf6r0N1kwrB0Dt5vpq/nOHQexusM0Q73J?=
 =?us-ascii?Q?4XiICogBQfmoKWy7BTXesygmO5Ujuvx3fhuZjDsdAyQGxC4cpYVlZBNVb0nD?=
 =?us-ascii?Q?cQBV6wT1o7pNp7AQqYq8bbebRhmFJcc+A/wPsDEnM+GI7Q03OyIdOSagUzes?=
 =?us-ascii?Q?Izdp7DrQ0zbxTPKIpy3WPr6gDATw1DChSDwWaV00c1yVZfOrQsg7kolJrSaF?=
 =?us-ascii?Q?c0myci2y2RHXyNdDI4ohurKrlMX3sG7GrCvPo0fil8QJAyc+kM70QKSFTYYl?=
 =?us-ascii?Q?fMjyHBTVlFLbSceVLnerXvScHUjNpBNyhREhKPKyN08bcky3AwC9GyoT5OPO?=
 =?us-ascii?Q?chgyqXjynS8YWpmvRse7bJOLdTqFe+SfyBpQnNJWS12ncWhheYZqC6o/wVtr?=
 =?us-ascii?Q?WduAZc8X01y2ELL9nOp15gq2l4jdyPOyjHHfth3Hhkozk+K6eDV/IJxWnhDc?=
 =?us-ascii?Q?sSC5Jix+yprTuuerTh2JXzpj3tWsBpxFMWCxnJKT0+C3QzK6Xc4kDI4fSCEC?=
 =?us-ascii?Q?R59b0041mR15YNq5eiyQZByR4zLyFDWlOBLGy4KKhVigurCWndi8s6MpeW6x?=
 =?us-ascii?Q?gAROL0vXQ1UB10TN/DuGDxGCnrxfTQjs9/16pH+o7GaAA2C1iyu3y/Fec1wZ?=
 =?us-ascii?Q?EXWPCpxeGsiHwUVc+r9p5eJJMZK6hg9PNXy3jLOgJr3+2x4R2xYJzb26rtQo?=
 =?us-ascii?Q?dULDn5n7mEPaGMMeb5mDOL7ym9vnHDGNJDwFYIhLoTCimWotfvrR2j51VOtH?=
 =?us-ascii?Q?/g49J95qqdqwTuxu+l/P8ZynNe+NsTbOj3JAGCXmKMQ48NUELKmwOwN9OqXt?=
 =?us-ascii?Q?5HPUFHRXHBp2bc3FveQM5yGQ7ulp9oaP+lONcO8J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd7296e-d957-4d45-9275-08dc4e88e0de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:17.6153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXqo4Pubz945+lY15SSSbZnxPewPOJecW3PamLQwz2X1pYm0QUOHcXbd/PT4iLnf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

At this point we know which master we are going to change the PCI config
on, this is the only device we need to invalidate. Switch
arm_smmu_atc_inv_domain() for arm_smmu_atc_inv_master().

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fa3f3e7d9b0cba..7480f70701a045 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2412,7 +2412,10 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 	pdev = to_pci_dev(master->dev);
 
 	atomic_inc(&smmu_domain->nr_ats_masters);
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	/*
+	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
+	 */
+	arm_smmu_atc_inv_master(master);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
-- 
2.43.2

