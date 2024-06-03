Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8480D13C918;
	Mon,  3 Jun 2024 22:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717453907; cv=fail; b=d4ALuepsA6Yaj1JgaJBFv6CT7i5udAjK5x36JEs0uVqBLO+e30mlZzCsn4XXrK+xd/Cg652Ikjqb4u6vHycG+61z+lAES101hfApFyG4ydm9uCMq6ON4hrsyc+0FRpQpQtdh57nPZwZPB5bfUyucMSa1SYLMDOqrN4R+tll9lM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717453907; c=relaxed/simple;
	bh=1FzQW8tif8ywu9AFUJmcA7bD4zmA3ndH4s+Ztgjkm1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sYELZ344yr+Hy0jLUhBqGBzk0kNRMVyji4x7A3T1aU0+9yPOYTKc4KY1jEvjbGOu2llfhsdsnRZcP7sQL+YmrXVBpYYNyDkxjigokYXii4ONXskm2km4y7CopK/d3kF68PZAS+my4d5wSUf6qfuB7sveunLumAzFjTOY7SYePLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qitLtzbt; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qitLtzbt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvYdLiXofMsYz2n1/eQ21KdA1cTINSIyjootUsWGEUNE1Ss6YJQ41oNWI5vLF6RX6+Z1rdT6HpzjmePzxkTs8fDgeaF2XDwXELwZzP2ZuPxYyemFbcirzd0hWjclgnkbMgQuT4iKdxhtAaycTVDX1fJxtof2G3joIwfhMaYvqxEmhL/IdvX3HiriLaMetGaWT1qqRv4OzoAtcuECCbjQhi1GT5JlGUraVxQ6+0gzqU/xmKNQq7npfTbaVgEMIr04xp2XedU5vtkc02Y41v1A7/Js/N2N+9z1CotfeOGQGdIVjXL6xmhUr9mFDnrSY4tAljesSEIQ+SHMseds97hMTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qCVi2xl8orchsUFQicYXMk+Odlf8xzCNbGmii+6RcZY=;
 b=TdOXjZ8SFexy7L9lJQgSS4QBtZVSHXDLB6SE5NeQTEy5u2mj/zbW9YYLyxOvhkE4ZYLJU19J9c8ioRu1rxoc0vmEYGcICVIcAC19j2pDa4OO0/NZe7iZLYlFpkgHDwo/H3KPVm0OdQZAMScsDfD2/xxA8IEcc6qfvcmlUmGUbVlDBUYF9LhE7tkj/QImIXUsXWE2eOYzAcGxQF828oWq6tekaXGbqV2sWwSupzrOESKgWTOHZ1w/iNoiobGDNDL6dMpITYxNBj9EFkGQB///J44PHq/sBi8pe5UjD32uR1Y2GADDOqO4qSi2S+3ENQGBcJlnA6DQHdJMECG79RoQjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qCVi2xl8orchsUFQicYXMk+Odlf8xzCNbGmii+6RcZY=;
 b=qitLtzbtasCVYEyHTWDNJcsGTTYsZiU1cgIMxC8iUisnTjGHpSOSYNdt9PKld572si+RnYA6YLYFNyBd7yBQjY/nUOoTdshSz3V+WjyO9stg2vLkCjDoZNZIOV31paCao3M2dNxnKJikmoIwZyayKpXOxseyMk69zWrVMEeSLUpcwkAs9h55P1gTuCqyZHs+5JW/H5H1J71/DnKLrR5MYtQqP4JdsIV+r6m1tfzv4n1KkxEdKuyjESCIZrH0f2Ei65i6IIoyBsaTNc3b1C3KDHhQ/7Q+Ig3ocyp0p/0NBq7S6m75KNrcw1oqSl810R9N3fbSkSq34wtXmEiiQZ6Vzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 22:31:38 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 22:31:38 +0000
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
Subject: [PATCH 6/7] iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
Date: Mon,  3 Jun 2024 19:31:32 -0300
Message-ID: <6-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: ac9e383d-4050-4538-8157-08dc841cee0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ExMqfyACUcLJhoY41mw0itTSV3C7NpF2WXjeHYIAlpMmA7VPbrOnAfiudI2r?=
 =?us-ascii?Q?OzOKYHjPl1p5sKwCBRzF9w5e5+zLZWzemnm/+xfVO1EoTWx8MhOe+DCGUnDx?=
 =?us-ascii?Q?qNtbzLNS8SwS/sVnokf9p+5HcYWVjdA+Au/5lFYWMTby3I+vSqIxwGFTzkgD?=
 =?us-ascii?Q?gTH/yw4Z+uZ/WVA/WATMPHkvW5M1DQlCj151PbtD19zQ7qCM9E+AECbVBusv?=
 =?us-ascii?Q?GqWdSY7GMqn6BYvDIOqG1QHqXVeJAzb4D+pbNRGsL0o28hcZmFRv1yBQJPIq?=
 =?us-ascii?Q?YabvBxX88PrwxW4DrFcOvrK6CuDkHobBsP9vBwSlud4Kk2c9RccxHB2m3SKf?=
 =?us-ascii?Q?5lkAtbWev+wlFqRaIQPu02ybEI0471BMPABuSEoZkT6Pvkg+a2BZk74wSMzh?=
 =?us-ascii?Q?ziTVdKDfTcjoiBgR3Q5AAHXBmQsWper3qC34OYr3tFiWdsCvzUW3VShzTzVT?=
 =?us-ascii?Q?E0ZRaxEtd42N0WJVN/PBhg+B5C7KBnZ3Cju6vbIl5MZYZVX3g++ectfXkH8c?=
 =?us-ascii?Q?xI8MfCeC20RIvzAFWqlzuP8G4t7mAHjSrYh135qLqMOiL3sDtRyo67zCc/g5?=
 =?us-ascii?Q?1dTvkGExJiNCcDwm7L/Oi6FXe2FjXEu7iIvbhMdJwYpTX9x+mlV7+YLa8Mg6?=
 =?us-ascii?Q?WxJtpPurFrABsXluBxwRdFybkNoOZ/qn5hBQE9n1lrPhTgvY5bCTh3T1p0kR?=
 =?us-ascii?Q?ZGfIztzeXjF0wIuyJyIqq+iinQ97R1rWoWx+xMZ8xbxMR617X0+v6rN/oRro?=
 =?us-ascii?Q?jIyRvAl+KQ8TkeskSjC7FHNcjVjfec144dTANPkEKXWb9OvcyMlTZdFvWAJe?=
 =?us-ascii?Q?/+QyY5cG7qcKKua/F19tzRLfEzeCzkmu95Xuapf4mNfYD+RSwiVNS8Sse/GB?=
 =?us-ascii?Q?UrmfXk+TuCJ/EYAtmip9ZS1K4hZVgSYcKQJm+8ZYH2U4sb5ga+cmIRHVFyKV?=
 =?us-ascii?Q?/6jwjWXVkthvMbWBOevL4nwD0p2+wEt3Bjj1zpogBc951+knGQkWxM2cU+Ev?=
 =?us-ascii?Q?zEat8FXVeqjMB1fkedA6fBBNhu8Y3i+8xdZlB0rQZzPP1dSJlI9wNR82h+Al?=
 =?us-ascii?Q?gP1TOglD0lIqmU8jWaBuBM9QUOOwvdNDmigFZEric9PNA8zg5Fk3LYAy51bu?=
 =?us-ascii?Q?TurlQiNc2tU8PgB9ctZUsh3CuOpOxggRFHPCJkNd6UsgFea6rnCxTOXsfBiX?=
 =?us-ascii?Q?bURr+g9x4wXW8D16Rbi6J5toq7twPOER6fIWFTZZRWV79+CQz6F60uk9Yfp6?=
 =?us-ascii?Q?IYSd7zeW3qvKKaW496inlljYRYoH/bHExMtw81sqCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZgJGoIXMzvWVur9FpJdGlLU9jHCt5SeFD0wdmkCxAVuIq/ribsFNbomIynRB?=
 =?us-ascii?Q?dqfIFfAK6/iSOcQMok4vAaCP3rxwJ7OQnGBf3/x715wFDxwWVT/xy0Pf5cnT?=
 =?us-ascii?Q?Eg1FjMFM+ZVhVH+Ysq/GQ0ynX8pBh9DzqPA1iwCm5Gi4HEDz516tfbLvR8SC?=
 =?us-ascii?Q?gTJY3swBUatQdIuiKO/4uu/nzznLu2bfowoBbi//gbmK2Cl2BdsQDIC/IxVL?=
 =?us-ascii?Q?MhBFTJ3vF7mSNAUqkmKAwPsQ8s0v44YUoT7xYN+rG6YnlmM7bTPPuDiNk55o?=
 =?us-ascii?Q?ckXTcbYuTPMoLozRVKWJrHv02phhfdJxPe1zqe4BZiNGhVw77inqdoVFCCx6?=
 =?us-ascii?Q?My3IvnKSTKBahM/bwlABsYixnZeBjvmRQyJxz/dQJa3r7Se9C9/r/40+dyuV?=
 =?us-ascii?Q?6nJBJ1GwidWxJbhR0fxY1kjoX/C7KIpM9DIOHHYmffFBcRyMvfC1oY3R8IRF?=
 =?us-ascii?Q?Oavf3U4rFrWmpN/zA+RyzpN8pDokz5uSpE+XGCJhQzuAK9lxLbY1gAv3JwCF?=
 =?us-ascii?Q?VwHvd4Ls3/qah6wuUe1oBTCgInRP+ZaxcUh5eAK1bQu5VVJIaU3YQf8LbCNA?=
 =?us-ascii?Q?ukAKEnYjIfr2TvUVAqErhmrzOb0426ZgaJwlwm+S/+0VBfrZ7BC3BdBpNKeY?=
 =?us-ascii?Q?/BwmC0fqOHzE64wPxhQewQtZvw2ovfhCbzJLxpRZcgVSRMr8P700sBDB27MB?=
 =?us-ascii?Q?hzKog6QNv2BiwnLyrubByVDXbJtF4D8hMDwgszbGl7iQ4rxOFVWEAdD49D7T?=
 =?us-ascii?Q?BeoNGMUNaviXyVLBNvPhjK8ggS//z0j1G+t+JOwlTVKW31S0GEaDsky2WqgD?=
 =?us-ascii?Q?Tw2PxTs3mO1R7Y+CsGsO/Wr9JQt/kAaWRN43GJ+5IaWualmAgpQ0jkSz0Iur?=
 =?us-ascii?Q?X5KJ/J50VQY12a85M2caU7h5skJCR+tBr/7AWNugJ3USLrqThU2p2czUm6q1?=
 =?us-ascii?Q?+6Aa5AjHPuqolFlJJz9nNIEN1hayUJLU+4m+IyL+dPiDp+1irHs/0L5eXq9h?=
 =?us-ascii?Q?yLjZhpIucxo8xtfxLu3oKsAA0CkkXYbv0SStEDQunHeu2xTmucwL2tVmwpdP?=
 =?us-ascii?Q?UO9ck+5IXvtwNgoms0E1hFhlUVRleL6qRTiKy62eu/+Nr7NCe46aRnJFBrAC?=
 =?us-ascii?Q?G5bw3qzvyzSEqlmSYO4WftBTUVd4v8lyYUdgC0GzN4DGStLTKLBRBX5ig9nP?=
 =?us-ascii?Q?bDJJiwIwC3k5BImOfCcMWgR58QKc66Y2Y7kvwrEF+p1Op/AteKuEKzIGLTY2?=
 =?us-ascii?Q?FVPB9Ui3tpm6kI2x4Q20pfHvqJ6KEZcO8cE8IDygYI2pmRqy0q+JpQc1GHX1?=
 =?us-ascii?Q?eMoiq1wAfRdS8q0D/mslZKL0HIPnIZucIZmilzzTuzd0R4K0bt107y9FbEfc?=
 =?us-ascii?Q?a8ZVVVSuz5AfnRzXH+MzrAUKOqXP0X8g59gtR4lqaT50ROQZCSLTeBX4vWoQ?=
 =?us-ascii?Q?/TKS3HaaOU07LXprftT4c5J4olOROmXxOHu5AxQ3y1jBOYt44GTa4SOBr8+W?=
 =?us-ascii?Q?EKROj71Smb/aSWq8jUGCZNPwLg7g9f3uC4/7c00gqsC1uD+Sb+MiLdaz1iGr?=
 =?us-ascii?Q?YUK2BWtbzocPYtek53Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9e383d-4050-4538-8157-08dc841cee0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:31:36.8964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3DdrKnlzJdbuzzyWEI422Uj4XEFHDfTnxJU5eG15Jh8edA6Lj4Xwiayt7IKJXrL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

The top of the 2 level CD table is (at most) 1024 entries big, and two
high order allocations are required. One of __le64 which is programmed
into the HW (8k) and one of struct arm_smmu_l1_ctx_desc which holds the
CPU pointer (16k).

There are two copies of the l2ptr_dma, one is stored in the struct
arm_smmu_l1_ctx_desc, and another is encoded in the __le64 for the HW to
use. Instead of storing two copies just decode the value from the __le64.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 35 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3f2e0462433d2d..7a6c9aac4cd450 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1167,28 +1167,19 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
-static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
-					struct arm_smmu_l1_ctx_desc *l1_desc)
+static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
 {
-	size_t size = CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd);
-
-	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
-					    &l1_desc->l2ptr_dma, GFP_KERNEL);
-	if (!l1_desc->l2ptr)
-		return -ENOMEM;
-	return 0;
-}
-
-static void arm_smmu_write_cd_l1_desc(__le64 *dst,
-				      struct arm_smmu_l1_ctx_desc *l1_desc)
-{
-	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
-		  CTXDESC_L1_DESC_V;
+	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
 
 	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
+static dma_addr_t arm_smmu_cd_l1_get_desc(__le64 *src)
+{
+	return le64_to_cpu(*src) & CTXDESC_L1_DESC_L2PTR_MASK;
+}
+
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid)
 {
@@ -1227,13 +1218,18 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 
 		l1_desc = &cd_table->l1_desc[idx];
 		if (!l1_desc->l2ptr) {
+			dma_addr_t l2ptr_dma;
 			__le64 *l1ptr;
 
-			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
+			l1_desc->l2ptr = dma_alloc_coherent(
+				smmu->dev,
+				CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd),
+				&l2ptr_dma, GFP_KERNEL);
+			if (!l1_desc->l2ptr)
 				return NULL;
 
 			l1ptr = &cd_table->cdtab.l1_desc[idx];
-			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
+			arm_smmu_write_cd_l1_desc(l1ptr, l2ptr_dma);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
 		}
@@ -1406,7 +1402,8 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 
 			dma_free_coherent(smmu->dev, size,
 					  cd_table->l1_desc[i].l2ptr,
-					  cd_table->l1_desc[i].l2ptr_dma);
+					  arm_smmu_cd_l1_get_desc(
+						  &cd_table->cdtab.l1_desc[i]));
 		}
 		kfree(cd_table->l1_desc);
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 21c1acf34dd29c..1ffe2fdfd3755f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -587,7 +587,6 @@ struct arm_smmu_ctx_desc {
 
 struct arm_smmu_l1_ctx_desc {
 	struct arm_smmu_cd		*l2ptr;
-	dma_addr_t			l2ptr_dma;
 };
 
 struct arm_smmu_ctx_desc_cfg {
-- 
2.45.2

