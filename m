Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03CB170A1F;
	Tue,  6 Aug 2024 23:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987096; cv=fail; b=H3OAnrqM82AS87z7HY5ajQ4aL8YZrcgxHq1w5o5Fw8WUkleFQrhVZ1hP2qC2kGQRs4SR9cghm4Tm6u0e2LIBzc6ZYVKAvQGQI+m50rkta9xWSdQVT5CIDisAnpIaVx/K4NYUci7ejseP8Mz1piMh+O8YheMLlCJ1lf5yWvX2E4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987096; c=relaxed/simple;
	bh=2/AqfyIBFzqHP1/QFiLzJs5NheHWUowod3UPhcVCNHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DV9XJnqx33KotDS6+GTXxLPJuopRRyoR9YxYCu8wyTzQSMPmvFWM4ZaxBBNkxc380CsaNcL3xSsORKb38KLLjTMSv7v1aHVtL7hlf6WJNZoJX/63rz3Oeop2LNybvObyuINGfVkR+DDaNTzZlUVyXpLjNU4MRsjHEQwfgP9hqzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TxAooxyC; arc=fail smtp.client-ip=40.107.212.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TxAooxyC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCUHTcgCkDeFs1MtB0a6V844FmwEI1UcO5jl3ofj0lqkJSgWQ+wII5aYKEG8EJh3iJvYRdcq2LrM5qT3QRRzXCNbVksxyhKSZZHgXIgUc48FjiO2o+EP0UJ1qatv591XVTQJblTgAE5pEflPdEq1I9DLBbDfAZluBLghJdPaVyuKTNorIUPRo3oaWmoj9LWP9QJfyFMm1vSqGUFh7rjUMB3QJZaZnV4srYHajNwtM9LyYFZJXvj0i2vzlmGqSdnNtjcPa9/BdYL11AL6tGapFef/8HzQEy7qVNErpd/z57uyCwNKwsKhoD9mrjfJyDnJA7XvyENSut4sXq/KvXArng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjpq912QHSJ+k3bzBg5GnE73iFdknyO5U374443igcg=;
 b=RRYrRguBPzQaduTtKcWlj4a4br/rBW3u7xTms7+Pf4/sibSOXv0kLYpImCLcBezcXZzgcWkJ9EJq/juQaeRYRV45Du/pGtvNLC6VdQrsNq/4yt3wizHmPCFfIx/lRZAC8periG3dJo4mzo3gbmIsmGejTZT3xHxQSn9lt3Cuu1ov5rS9zOAcmQSMCVnZ4OGseWdtvWyv7eafP18q4CUqm5FCBfEFk7v1SqpYZ9bdaqB8Vzbz4LtzMTZ0KwRgHoxv1pU6QCfLGS/ehWRG2+m3bDg0niAvlwjk4M4eOtz27PMX0rPH6SSdUGToS4nenhZD76nOXLvKHZzG5HQzt4M1yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjpq912QHSJ+k3bzBg5GnE73iFdknyO5U374443igcg=;
 b=TxAooxyC0i4sCPR4oWa2cpBizml2xtWVcUjhrBEyfa7lu6xsKPm09wxaZ9O4fzYTBA73qHKDjSV/MRn2uaE+oFM/OKYVdQKz3EnLOHP9ygfiYRpATMH5R9YN5tF4MFDaCHd/NKO1go2bManil2iYnTYcHZ70q6ZFVh7FRvtSHGGzTpMrXum9DXu80YzC5VTqoB/G7/fglEkJJJWX/YIlvkNnAB/m8WxjakgR80JD462FdMq70VBDJwgLz/ph+mtY6bqz+jAsZbETkWknHB/+ageUzMudeviw2fAH5XMpKJ1KyKiXmXUEosABfQKqM/BpJ939jbn1YZMPDGGSLzlhHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN0PR12MB6248.namprd12.prod.outlook.com (2603:10b6:208:3c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 23:31:28 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 4/9] iommu/arm-smmu-v3: Reorganize struct arm_smmu_strtab_cfg
Date: Tue,  6 Aug 2024 20:31:18 -0300
Message-ID: <4-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:408:fd::6) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN0PR12MB6248:EE_
X-MS-Office365-Filtering-Correlation-Id: 97a99ca5-f5d2-4851-33d6-08dcb66fe32f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rRAGOqGuZKGsosYgQTfvHtoo2COnU+XEayjPmPWw232WZIsNwYGBKC+DgIR2?=
 =?us-ascii?Q?fZpjV1cg/zxqXeqnzIqL3OLr6qrypYFvB4oCCyQ7VXSh66k0auXbRrYV6qyF?=
 =?us-ascii?Q?hVtR93wapHlBPjpTsMC+E0vmS5s7GANGhCykGUStDNBYWGdnLW3D7IdbT4dm?=
 =?us-ascii?Q?HuKjLS0yyDfqzxgQ0nbK/tbd8mfaJslNt0FiAHSC9reWTdvCiA8TF/M2iJ9O?=
 =?us-ascii?Q?bpaW5UEf9B/TqxrHblHiX+tCZ2sHesyFYZ4uqetUBy2m54ni5luBzvn+/zLN?=
 =?us-ascii?Q?q+NhAks3MtSFta28v9Wnwu1+Sx1/Egy1C43tTderzodGVhCan/1CIbpwcFh9?=
 =?us-ascii?Q?LRkJ4TruCNtE+xQr2SLTNLGCzSS/VKovALHzr4Jm2p8uH5JMFWvQHWec96md?=
 =?us-ascii?Q?wU3m+W2IlzkwVrA9B2T3yCESddR84nTZkReQklQ/6TMw08XsHrOf+njZ09LX?=
 =?us-ascii?Q?5IF7kRS2YFWXU/YOCnDEA1YQJUsf2NCZYP6W/VWW+/XvnjDYFtpWSnR0OMdg?=
 =?us-ascii?Q?eBvJ7/GbgtG91xG+cIIjTsp5LAypJtoxPS5zdvXj+GF8WQg2H/tywps5pQwk?=
 =?us-ascii?Q?Q4NSFfvqExSo3Ht3E5HPK8Oy64qq40GmlhmKEJh/VZnksPhV5ewIGTEwInNt?=
 =?us-ascii?Q?4rCu17uhSp5UyCY/y2MtX6n4jSz+tQyKUtGTMI6IlC50YHyi9qtJQKwfGqzh?=
 =?us-ascii?Q?txiY9bEUny3xDTNPu1lI5O443jPv1jxhZWHuLIF6Znn4ks4eQcRJT2QeCoL7?=
 =?us-ascii?Q?RKCqHtA4Ubb+Ve6gFqa8ClQzIGK9bCGm8x3xh4iaanFncBV7WTU5GerzJdJD?=
 =?us-ascii?Q?qwo3fVpEg9Sxt9hSzogzy9SQ5dUsESGBbQDT4+wi1gzfl4cRRrYD7F7LRMvY?=
 =?us-ascii?Q?dFlE+C5nemomMfsPoAXjvXAlSUNuPi90SWok471BTgYtQa0EdjdHa/zqkkYX?=
 =?us-ascii?Q?JL2Jm5e2Zd3lJjby7KaEuESDQtQr8cnXJRWE1zzcDBpfeOHxSI99bDeyxc40?=
 =?us-ascii?Q?46c75lTTPYiIsoHTKc2d7BFT7ZzcrcP8bWoY62WeiTyv0P+VhlnBcXg4f2os?=
 =?us-ascii?Q?h5ypDi6sYW+7ejl507/RBrwmQPs5GAak1mUhKObMpC5342NxCTrwrBCeJNyP?=
 =?us-ascii?Q?qdRkGBFHJXJLSlD76eMEB8yhhJtpIO2f5TpZ3smvGO9+BkTJGWghwRNUNewl?=
 =?us-ascii?Q?Qz8EL7o1ad2di1XZoY3EoW7JQqVXoGl74cKKFLP3vlk3mruoF31uYaTa9vFb?=
 =?us-ascii?Q?WVlIhF7P5ogSoHs3zrzzNPK+2hTEFakrLqBmV0nt2Rs4U+IcwQgRpz8uod9k?=
 =?us-ascii?Q?b17jTqADJZW2GFnMURG2RFyhUSA9CnBIdRRmNl6Yo+6SuQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U9lU/g1+PWA16YpzPwP1XIzaJwXVViQopcAd1sYt93/91UKy6VoyQYHTRzXC?=
 =?us-ascii?Q?qRs6moO24HcccapHZNnlD8bZhuViNdPelvhRwP+pACgYRknKM335jr/kwgCG?=
 =?us-ascii?Q?JFrC41pjYpZtpn++EJHyJ6iPDdke4/mqa71liSB5GMSl3n3XM6RcXHs+zFRB?=
 =?us-ascii?Q?iq4RES9YSccOTJQSGdAaHiMZz2ZGl/loqlHripsV9aEsymMTzfpNcLnC5kn6?=
 =?us-ascii?Q?20fQ+8p9VE6kJUXDrmBIjnSRbNzxAZ0HURuF7OCx0Kw9JaYsaJq31DSEQZfN?=
 =?us-ascii?Q?WkbBXBvPjFEacVibzRM5aqZcbgW2DIKCIB62RcKhvVH78nkx3Qq0JdcO6gbL?=
 =?us-ascii?Q?TqClMmiZzVrTg6jHkZIOnYaltOORmyhcRi0ndxwkO5wtqEQx84KoNN3+WAuY?=
 =?us-ascii?Q?LTCh2vpGXOxaPeBnm5LOa/W7cZr4RDWGPHz2lR/O2t+L/rds0ozLNUjuTN2M?=
 =?us-ascii?Q?I5zlLv8Inm2vqnEBXQKUfiyNgJuS10QOk4U+IGw7fO6cFOwoa9wuNC5dBPK/?=
 =?us-ascii?Q?xRxOVjOwNH/JNrRNhcye5GSzYzM6O9JAMhEd0r6oe/vgttchjodSt7OVpYZ2?=
 =?us-ascii?Q?i3CSv45wajxCG6dSjMGl79Q0alcehHaoZU8rUpROcfIhsgr7g8yOw311flec?=
 =?us-ascii?Q?5AMJzolKF1NrEPHbVYwyCykBkrTbqW9HZUvYqfhXbWYPiLFPISlROkYcX9QE?=
 =?us-ascii?Q?oXsmGt6IIgqICi20UmtdNcBaU22ML8BIyT/a700azNTNOS/rWy0aGfkvsIWO?=
 =?us-ascii?Q?AYgZfK5R8PJP59setu3N0Lj/HJPRddm3fw/rKiCwjQ8/qoYZXk4FDvwSsmZj?=
 =?us-ascii?Q?h6PMy8W1DNFbrNPKAkOB3Z8svAr9tgHiM6n+Cw2Ks2ftRGnvcSUOmOZsH93N?=
 =?us-ascii?Q?XaJHhG5p832mkJ3GkJncMWBacdtjWMVml+pa+RqvJGgs1mmTW9UZOHx9g1O/?=
 =?us-ascii?Q?EnE13z0TJp1sMRrpvfF27i303TimAeSIcunmfkjKhzBQKhjJv2TaftSpeceb?=
 =?us-ascii?Q?E0Bw3PC/0AjPOpodbRXNLq5BfDpLUDBoM10P2LpB4D9VMTh+sjd6HMxZ5V5m?=
 =?us-ascii?Q?TUA19tWhPY5Cqt+7rJVE33Tu4gvRA9apA9qn08eR5MTIyzoSYTTX8YhcBlIz?=
 =?us-ascii?Q?2O5s4tqXCk/MHq+iBVPHDok3WNdMjeZt8dbXaxBEhdR/dVxqNsyhuMdrdcly?=
 =?us-ascii?Q?f5T1faFP/cv2LM32QuDgNXr0YpDNSGoVy+c0Alp6khb/RIaAJ7FOlwKMWmXD?=
 =?us-ascii?Q?gFB3GulcRuf4+//ox9/JxWSUQDDFKpTUhfEAy8h/uT9l2geyKmtuTyrtXP6p?=
 =?us-ascii?Q?zeQVMrBle8lSM4zwBOwFbepgWjNP8k5DEGOa8NuD2qcnAcUOqzsn/hCWTzBj?=
 =?us-ascii?Q?q1PsMukWOvVrkKQ6+KhMwMY8wA3Hi9GSkgDQCaxrAX4c3cIl3QSlV9516Wod?=
 =?us-ascii?Q?WcXz/aJ36QZCfzy7xRq4ZDZsfGs6foicxy08cV+hvIz2fGaYt+2GYUmrpKK+?=
 =?us-ascii?Q?9QehBvIUFwsOkBrspr47aF6FKzyQ1LDj+PQK5bC+gQzGkGXoB6EHOdPLgcQr?=
 =?us-ascii?Q?YecE46IUakXFFFbPND3AxMkUpuV/6290UeGAcRpC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a99ca5-f5d2-4851-33d6-08dcb66fe32f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:25.0634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwSgZvVgHNyhTnUN0sUTgiLE0RJSqXR8sZOhZIez4FnN4b3ygme6/2goP5yd2bFV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6248

The members here are being used for both the linear and the 2 level case,
with the meaning of each item slightly different in the two cases.

Split it into a clean union where both cases have their own struct with
their own logical names and correct types.

Adjust all the users to detect linear/2lvl and use the right sub structure
and types consistently.

Remove STRTAB_STE_DWORDS by changing the last places to use
sizeof(struct arm_smmu_ste).

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 77 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 26 +++----
 2 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7a2d102fc11eb0..9b1f947102a554 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1673,26 +1673,25 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 {
 	dma_addr_t l2ptr_dma;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	struct arm_smmu_strtab_l1_desc *desc =
-		&cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)];
+	struct arm_smmu_strtab_l2 **l2table =
+		&cfg->l2.l2ptrs[arm_smmu_strtab_l1_idx(sid)];
 
-	if (desc->l2ptr)
+	if (*l2table)
 		return 0;
 
-	desc->l2ptr = dmam_alloc_coherent(smmu->dev, sizeof(*desc->l2ptr),
-					  &l2ptr_dma, GFP_KERNEL);
-	if (!desc->l2ptr) {
+	*l2table = dmam_alloc_coherent(smmu->dev, sizeof(**l2table),
+				       &l2ptr_dma, GFP_KERNEL);
+	if (!*l2table) {
 		dev_err(smmu->dev,
 			"failed to allocate l2 stream table for SID %u\n",
 			sid);
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_initial_stes(desc->l2ptr->stes, STRTAB_NUM_L2_STES);
+	arm_smmu_init_initial_stes((*l2table)->stes,
+				   ARRAY_SIZE((*l2table)->stes));
 	arm_smmu_write_strtab_l1_desc(
-		(struct arm_smmu_strtab_l1 *)&cfg
-			->strtab[arm_smmu_strtab_l1_idx(sid)],
-		l2ptr_dma);
+		&cfg->l2.l1tab[arm_smmu_strtab_l1_idx(sid)], l2ptr_dma);
 	return 0;
 }
 
@@ -2450,12 +2449,11 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
 		/* Two-level walk */
-		return &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)]
-				.l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
+		return &cfg->l2.l2ptrs[arm_smmu_strtab_l1_idx(sid)]
+				->stes[arm_smmu_strtab_l2_idx(sid)];
 	} else {
 		/* Simple linear lookup */
-		return (struct arm_smmu_ste *)&cfg
-			       ->strtab[sid * STRTAB_STE_DWORDS];
+		return &cfg->linear.table[sid];
 	}
 }
 
@@ -3157,8 +3155,8 @@ static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
 {
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
 		return arm_smmu_strtab_l1_idx(sid) <
-		       smmu->strtab_cfg.num_l1_ents;
-	return sid < smmu->strtab_cfg.num_l1_ents;
+		       smmu->strtab_cfg.l2.num_l1_ents;
+	return sid < smmu->strtab_cfg.linear.num_ents;
 }
 
 static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
@@ -3595,7 +3593,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
-	void *strtab;
 	u64 reg;
 	u32 l1size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
@@ -3603,34 +3600,33 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 		arm_smmu_strtab_l1_idx((1 << smmu->sid_bits) - 1);
 
 	/* Calculate the L1 size, capped to the SIDSIZE. */
-	cfg->num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
-	if (cfg->num_l1_ents <= last_sid_idx)
+	cfg->l2.num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
+	if (cfg->l2.num_l1_ents <= last_sid_idx)
 		dev_warn(smmu->dev,
 			 "2-level strtab only covers %u/%u bits of SID\n",
-			 ilog2(cfg->num_l1_ents * STRTAB_NUM_L2_STES),
+			 ilog2(cfg->l2.num_l1_ents * STRTAB_NUM_L2_STES),
 			 smmu->sid_bits);
 
-	l1size = cfg->num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
-	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
-				     GFP_KERNEL);
-	if (!strtab) {
+	l1size = cfg->l2.num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
+	cfg->l2.l1tab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->l2.l1_dma,
+					    GFP_KERNEL);
+	if (!cfg->l2.l1tab) {
 		dev_err(smmu->dev,
 			"failed to allocate l1 stream table (%u bytes)\n",
 			l1size);
 		return -ENOMEM;
 	}
-	cfg->strtab = strtab;
 
 	/* Configure strtab_base_cfg for 2 levels */
 	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
-			  ilog2(cfg->num_l1_ents) + STRTAB_SPLIT);
+			  ilog2(cfg->l2.num_l1_ents) + STRTAB_SPLIT);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
 	cfg->strtab_base_cfg = reg;
 
-	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
-				    sizeof(*cfg->l1_desc), GFP_KERNEL);
-	if (!cfg->l1_desc)
+	cfg->l2.l2ptrs = devm_kcalloc(smmu->dev, cfg->l2.num_l1_ents,
+				      sizeof(*cfg->l2.l2ptrs), GFP_KERNEL);
+	if (!cfg->l2.l2ptrs)
 		return -ENOMEM;
 
 	return 0;
@@ -3638,29 +3634,27 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 {
-	void *strtab;
 	u64 reg;
 	u32 size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
-	size = (1 << smmu->sid_bits) * (STRTAB_STE_DWORDS << 3);
-	strtab = dmam_alloc_coherent(smmu->dev, size, &cfg->strtab_dma,
-				     GFP_KERNEL);
-	if (!strtab) {
+	size = (1 << smmu->sid_bits) * sizeof(struct arm_smmu_ste);
+	cfg->linear.table = dmam_alloc_coherent(
+		smmu->dev, size, &cfg->linear.ste_dma, GFP_KERNEL);
+	if (!cfg->linear.table) {
 		dev_err(smmu->dev,
 			"failed to allocate linear stream table (%u bytes)\n",
 			size);
 		return -ENOMEM;
 	}
-	cfg->strtab = strtab;
-	cfg->num_l1_ents = 1 << smmu->sid_bits;
+	cfg->linear.num_ents = 1 << smmu->sid_bits;
 
 	/* Configure strtab_base_cfg for a linear table covering all SIDs */
 	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_LINEAR);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
 	cfg->strtab_base_cfg = reg;
 
-	arm_smmu_init_initial_stes(strtab, cfg->num_l1_ents);
+	arm_smmu_init_initial_stes(cfg->linear.table, cfg->linear.num_ents);
 	return 0;
 }
 
@@ -3669,16 +3663,17 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 	u64 reg;
 	int ret;
 
-	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
 		ret = arm_smmu_init_strtab_2lvl(smmu);
-	else
+		reg = smmu->strtab_cfg.l2.l1_dma & STRTAB_BASE_ADDR_MASK;
+	} else {
 		ret = arm_smmu_init_strtab_linear(smmu);
-
+		reg = smmu->strtab_cfg.linear.ste_dma & STRTAB_BASE_ADDR_MASK;
+	}
 	if (ret)
 		return ret;
 
 	/* Set the strtab base address */
-	reg  = smmu->strtab_cfg.strtab_dma & STRTAB_BASE_ADDR_MASK;
 	reg |= STRTAB_BASE_RA;
 	smmu->strtab_cfg.strtab_base = reg;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3a8a459f899fd8..18e85fc936876b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -207,10 +207,8 @@
 #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
 #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
 
-#define STRTAB_STE_DWORDS		8
-
 struct arm_smmu_ste {
-	__le64 data[STRTAB_STE_DWORDS];
+	__le64 data[8];
 };
 
 #define STRTAB_NUM_L2_STES		(1 << STRTAB_SPLIT)
@@ -602,10 +600,6 @@ struct arm_smmu_priq {
 };
 
 /* High-level stream table and context descriptor structures */
-struct arm_smmu_strtab_l1_desc {
-	struct arm_smmu_strtab_l2	*l2ptr;
-};
-
 struct arm_smmu_ctx_desc {
 	u16				asid;
 };
@@ -638,11 +632,19 @@ struct arm_smmu_s2_cfg {
 };
 
 struct arm_smmu_strtab_cfg {
-	__le64				*strtab;
-	dma_addr_t			strtab_dma;
-	struct arm_smmu_strtab_l1_desc	*l1_desc;
-	unsigned int			num_l1_ents;
-
+	union {
+		struct {
+			struct arm_smmu_ste *table;
+			dma_addr_t ste_dma;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			struct arm_smmu_strtab_l1 *l1tab;
+			struct arm_smmu_strtab_l2 **l2ptrs;
+			dma_addr_t l1_dma;
+			unsigned int num_l1_ents;
+		} l2;
+	};
 	u64				strtab_base;
 	u32				strtab_base_cfg;
 };
-- 
2.46.0

