Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6050D1C36;
	Tue, 11 Jun 2024 00:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065896; cv=fail; b=erzCWte+1MbxZt3DFCLxSyt7CmxgNpGkBiIGXIh/SkQpY5TpxShqXxeQIQcL8F49vXEB/4AzWLA5wf3/FjfiucrZUYaCv6d36RSnvbXFhfnu8IbbHESjIxZcOpgjsX0Q0tqcDBghxz/d+De1rkP+zunoba8odGgsASEpGSxCsyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065896; c=relaxed/simple;
	bh=pdOH0fITf+bejpSGYyKlvJ7FPMp7PRPUW9SJSnMBa6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WsiMCIBnAWEJc2ITG+QwVW/p3Vuo42c72FhNWy1Yac4IROpOpXh+O0ydQk5axDsy+buxfgLnaXmp5O2TnELw8ZIv8q9HsieYDW8o+aFH1Vikbfq5635gHSkdOKr3Qf858sQsBefM5OQwg9j/GYkTHaWgwtwfl0rdu9U8Ncug56k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UiMcxh0d; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UiMcxh0d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqXqUh/POHvOl8hXU6P4WBVf/KpV8ufp15PG3iRHskfHtKbNhUg+vNeAofdwRyROLhhxrY+s9i5uSR5F9E3jduGPn7mTzw5aCGxxZcGyJj/yF3hwMn57XHEuiZ8+uSdBQFV7zCulDg7grpuDID+41AVVeDJsbJ8WtCAa96LjzUehrAigVcAJSKQhbeJ9xA2rgTiHq6gsz7nm3CoUzlYhPiRecyHEtIk1tNJIodAxEfuadDUBOH6Ctv48NMLz5ndRQSVohX7KlnT9Q0emgECKSzH/a8QqwXwbSVKlhURIsE16T+FXuLsxVvBk6sA1wDZVwP9OAPOTEmHBqtdtaBQjkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqfhfdFL/+MaeVlul3bkxBoIl3Eo/WKDwW3y5rvA6Pk=;
 b=P3n6+ka7ZwvaqZBr5XfEyyiXLDRAcqTPwCTQxj13bwy/xw6b4poSKsJbxiO9y/Wb8H1XvPbjCufQauZtiVtlXSjhOeSqwv5tcg/ikgnLJD3by093OJwQzclnKaU1gPdh7OysL0fkDzz8HRMFxTXLxFHpb6na4h5ONHBI8UHmjjOXDCu0WoYzP3uX5sxVKDs7k211XKAHMGS0AeCQZbYykzqX1v76TqaDSXQUYnn5CDF4l63z9v0fn0ST/GivHQMun/W79M1Lfc4DCw3+KqLy53m673fuPXuHeBWreabCpb+7qPIM8z9L9+0wYcRopVJLYwcmt/h+UwNwfAmQXlrw7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqfhfdFL/+MaeVlul3bkxBoIl3Eo/WKDwW3y5rvA6Pk=;
 b=UiMcxh0dxmVNC36VT9oedw2a6vHKeSKp/Zbn2kdPcGwx1no1+2nS7VKDJPPdtUo4zZ/ARsiaYVQpRHzDW0ZtXI3e9AqFZ0+Xb28x7BiOFy3Uqk0Ga8CUKcHAw5Aqz7RGfo/UDjnUpRvcRQZac4aRISxuwgMxlWzyabvLRl5EH+AA3XO9mGbYZqShlgD4E+9wsgJvysYVNOoz0IjKxsj2ro6jViKsC9UMQzPqRjWtuYYAuP+WcVA4DHzVsdRVV793ORBSRSQ9OFaQzC4BmuIsuGCHjPZ473lBpqGdZM6dmAorjs80Pri0eUZm95F/oPXWtQj6hJyCzZsLgqUampk5YQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:26 +0000
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
Subject: [PATCH v2 05/10] iommu/arm-smmu-v3: Reorganize struct arm_smmu_strtab_cfg
Date: Mon, 10 Jun 2024 21:31:14 -0300
Message-ID: <5-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:208:234::13) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 4552bb12-76ef-413a-6ef5-08dc89add22d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mpESTBqyQ3d7F6CMlmQrQzalqI6hi++dvvm6mcn5whFgO+qmQHXNnH68qwAQ?=
 =?us-ascii?Q?OVRQgSSJPqst1+GfZsn5CGc4KHJM7T/+0jdaHQXx6V4CCYHzrwhlLAXjAnnT?=
 =?us-ascii?Q?oyCxKBDds30PmymLsGYtZQPbX+W+BlcsHgEEaQW/nrlZ+0Qqh2XVj55ya4ly?=
 =?us-ascii?Q?JdquaxZrkn+ApNKrE2gEJVUcL8ViJc6nV95/W89AD/sGR5S7jQFIVUo/amdG?=
 =?us-ascii?Q?pjH/FluvzFW2oBLLd59GNhAsu6NKdOh0bJ7/DJbwYf1FDZYeSsdXFaQnNzfx?=
 =?us-ascii?Q?putEdHPLW8GQ1vUE9WPXgPlEHZxlapRSXrD9avO17RV/Iyf5f2BNZJanHz9U?=
 =?us-ascii?Q?4FM0cB8ABD34RYmurR+whfqcCPajUC5yvn4NafsctzAX0TzkYFuZBAIY72RJ?=
 =?us-ascii?Q?QJIoRgpPibA88wEOdUlNfpKaOU8mAUFva2LK2GB4Y1ffPDg36jmPIVM2sn3H?=
 =?us-ascii?Q?Hbc8xCGHCw/NwYVZODgaeio5f3AGaCtHubqlATpDEvN5JNU2nNdlVr408MfM?=
 =?us-ascii?Q?ZPPawnszjVb3O1dnXp2SNkTzTlXiyzJyxGZLZxzeLdf2IAV5Q3cA0Pk/NLJj?=
 =?us-ascii?Q?tgli+Xg7+F1mgJo+PpZRUUc906xsLAUio5g/lxV2o+8xECT7Lc+TCwhM7Vmh?=
 =?us-ascii?Q?D0HiY7GDH/TZZvGJk5k7EPHacXVLJTFIm/TAxK3dyN5UGKVgGQeF7TEOjjbg?=
 =?us-ascii?Q?um8PUzNklMXLFMHF06UFKZhxAffZW68nydWQkYicqtse3HGsBw++b57NSN79?=
 =?us-ascii?Q?VGzaIQ2na+tihYLRlqjVhaFLhmGld6iFzcaUHGbDb59NpiYSS5ygF3+azide?=
 =?us-ascii?Q?7hjMg8gHpQiMYAajUdSJHxnR5Gt91YoEjkIUolQkS/SPKMvq/gFyp29ElM2G?=
 =?us-ascii?Q?pu+AD4YJE8ZRszW4OZsmOu+ipE0xCvSxvc4+fi1KImdrEycQZuUy3ACgvL/G?=
 =?us-ascii?Q?jDM1J3P/MSpNqPz3+HTOZyYFH6hLaq4Srmu+kK+eovhQDYt4NvWArHaVakJA?=
 =?us-ascii?Q?h7pFxxK0kUI0sXfZijUR64i0S6ouvCWbEeg29Q8B5Jcbmq+UA61iFNvC+FT3?=
 =?us-ascii?Q?Y5mRnViUzoiHk52+9d58R0cNsswqvdIL/lVhRm70C+YWAcS3u5i7CCc/Ovws?=
 =?us-ascii?Q?XGuzpuRnmex2Q1QOdBVsIMWyG2tIVOJ2KAxrujAIzlt3YphDccEYC1oHS6cA?=
 =?us-ascii?Q?TcyanX7lTvAP5jV8MSrWlNAdmp7WtyKB3gxv9DH3ZRc98mLKN8VnFg8vF0AT?=
 =?us-ascii?Q?eZe3CS2+/3lVq/fa1bzp3d2hDXbrvQ8vPHODs9mKSvkrZew09AKxz1RYTDVD?=
 =?us-ascii?Q?TqwWFmh5xEjASGeOIsYmRAAd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XXfuXikb7op7w/YIxwUytKHmJ5FH2tc2P730Cs+0MNbDOnTMlMBklnNPhCMF?=
 =?us-ascii?Q?c1wPDbTRKxkYRgToLbuXApn1FwmOUGChsAuGAfehI2i+6H29f3W7K8OKyjCc?=
 =?us-ascii?Q?t2V+xh7LcNXdxLneIIsatnC87mu+4/uKlIYWv5gMXEkYpe10KZLc6h758ffS?=
 =?us-ascii?Q?leiePVZCWJbOqtZ9CKqVIS1iatD7h0gFq631B82bvtcZG9hdfJBnCAlhC61I?=
 =?us-ascii?Q?YUtjT488i1oUcZmwrn50CQwc41Nh956f2XXIhiPegLQB1YeD9jZNIlBMXQ/o?=
 =?us-ascii?Q?mbpBGY+eq4IHqP5nuEm1DVMESrd7p/Xhn2shxv4ozF2HjdS70j7ybQ6w1PM7?=
 =?us-ascii?Q?ILMvmTSKWHIlB08PTnSDF4QXdsUSvip7A3k/8q5XBvm4ZonH1ify5WxyJN32?=
 =?us-ascii?Q?hOWGmzQFGDCJVZwcnQF2EQMlbDT2BDAgrDk1E31aOrpkji419mxufIdERM1O?=
 =?us-ascii?Q?cu5+AnCNy5nW7cxp9ipi24F4sm1S64xYdnrrWlzKUEfTC1GEmrzFkoe2hr0S?=
 =?us-ascii?Q?B8MK0+a6wXNf+9heMx8mQ1gCYd+SPzODz0f5oevNDLKSNSQlo9OW1cAuoWuc?=
 =?us-ascii?Q?niMqFanKc5oFoIYqzyA136OX0mArSpV8XLALsPiKyyYQgI9IWKpRrezH13BK?=
 =?us-ascii?Q?I5hU66mX2S3uf4j/R1vqgMNnG7pBLgW+tTmee54CtP3/VUkGsoEAjV74qS5H?=
 =?us-ascii?Q?Dl4ToI1xtkRvFtcluiAYsai/Cvqthu77WWRAYvnQrcNN3KZVnzle/2ZTVkq2?=
 =?us-ascii?Q?OLV/wRSG5rRALYI9ikBlF1pvXu1R0RM8esZlJV3CRdy3om6xYGPzaIXPI21o?=
 =?us-ascii?Q?YVwUjkqyzXrLFRN+fUxd7zbBCSlXgM4m+h1xFJRL7VyI7m2uyJaSk+o9zgN5?=
 =?us-ascii?Q?4gMRDLvvaEzdp2LLCllHrzlML+hM7sLUP2OBlTdMvnfqHmq0+hrhcwFK5whp?=
 =?us-ascii?Q?XkdQyn2PK+ggVBl6N3cXX7bppjOQiouRS6lltM1oRC5RBlShhlyt7EyNjb61?=
 =?us-ascii?Q?e+8cfFgaB+Ok3x0GMAaxYp5Iba8HuCYYurYDaGd4ua+MJlxF/aLkOLgPlleo?=
 =?us-ascii?Q?eMGLTI6oZ8X40Djf32Nfh1q6x/2FFezpTq+f0B4+sZgnECGy1HTmOIahjxya?=
 =?us-ascii?Q?WFG6GQwGcNOFG+scXCHNighqEWNjD+7ND506FncRVepRgW99S28x1k36VvvF?=
 =?us-ascii?Q?Acz7dWErnzw1tprenokO6MDgHIs9K/UW8BVKSIIXv3ezdDa4BYDsnIuXaTJT?=
 =?us-ascii?Q?lsTa4V/veNR7FHrhcmo0xF4lcpXR1FESS3eZI9hVIxV1kHoAEVB/FPPMyz+2?=
 =?us-ascii?Q?MhIr9DKMxJuZYoNO1wJb7lHP8ZIR0QQ/si9C72L+UhBNWazEhADIoAQ1R/FU?=
 =?us-ascii?Q?5t9lcyySiK/aBktnivlkeeUxkgHrFWgW/R20kNl+tP5DIOnv6YWXMN3WNSga?=
 =?us-ascii?Q?lZGz2b1udV8GtnJ39KqwuejFoUjhjhcQib6hnTaohsnLqOJ+undHR8Sxa/v3?=
 =?us-ascii?Q?q6uXd+WU912OsBLzqnau7iDBAc4szEh60Nt/0MC07D993FLYzevPhE00F+nR?=
 =?us-ascii?Q?iTpCdC/7RWp0nVkJ7/E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4552bb12-76ef-413a-6ef5-08dc89add22d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:23.0592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DvZ13pz8ego4JL+9oN4LB4b8z8QT6wstV3bqlBW2u8TMawwYQ7s+i1hbjYIIsegB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

The members here are being used for both the linear and the 2 level case,
with the meaning of each item slightly different in the two cases.

Split it into a clean union where both cases have their own struct with
their own logical names and correct types.

Adjust all the users to detect linear/2lvl and use the right sub structure
and types consistently.

Remove STRTAB_STE_DWORDS by changing the last places to use
sizeof(struct arm_smmu_ste).

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 79 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 26 +++----
 2 files changed, 51 insertions(+), 54 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6643594121a2b2..21e0438d09b26e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1655,26 +1655,25 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
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
 
@@ -2412,12 +2411,11 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 
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
 
@@ -2791,8 +2789,8 @@ static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
 {
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
 		return arm_smmu_strtab_l1_idx(sid) <
-		       smmu->strtab_cfg.num_l1_ents;
-	return sid < smmu->strtab_cfg.num_l1_ents;
+		       smmu->strtab_cfg.l2.num_l1_ents;
+	return sid < smmu->strtab_cfg.linear.num_ents;
 }
 
 static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
@@ -3211,7 +3209,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
-	void *strtab;
 	u64 reg;
 	u32 l1size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
@@ -3219,37 +3216,36 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 		arm_smmu_strtab_l1_idx((1 << smmu->sid_bits) - 1);
 
 	/* Calculate the L1 size, capped to the SIDSIZE. */
-	cfg->num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
-	if (cfg->num_l1_ents <= last_sid_idx)
+	cfg->l2.num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
+	if (cfg->l2.num_l1_ents <= last_sid_idx)
 		dev_warn(smmu->dev,
 			 "2-level strtab only covers %u/%u of SIDs\n",
-			 cfg->num_l1_ents * STRTAB_NUM_L2_STES,
+			 cfg->l2.num_l1_ents * STRTAB_NUM_L2_STES,
 			 1 << smmu->sid_bits);
 
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
-	if (!cfg->l1_desc) {
+	cfg->l2.l2ptrs = devm_kcalloc(smmu->dev, cfg->l2.num_l1_ents,
+				      sizeof(*cfg->l2.l2ptrs), GFP_KERNEL);
+	if (!cfg->l2.l2ptrs) {
 		dev_err(smmu->dev,
 			"failed to allocate l1 stream table (%zu bytes)\n",
-			cfg->num_l1_ents * sizeof(*cfg->l1_desc));
+			cfg->l2.num_l1_ents * sizeof(*cfg->l2.l2ptrs));
 		return -ENOMEM;
 	}
 	return 0;
@@ -3257,29 +3253,27 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
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
 
@@ -3288,16 +3282,17 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
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
index 1418f21f5db6a0..8b58a30ebeb06b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -204,10 +204,8 @@
 #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
 #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
 
-#define STRTAB_STE_DWORDS		8
-
 struct arm_smmu_ste {
-	__le64 data[STRTAB_STE_DWORDS];
+	__le64 data[8];
 };
 
 #define STRTAB_NUM_L2_STES (1 << STRTAB_SPLIT)
@@ -596,10 +594,6 @@ struct arm_smmu_priq {
 };
 
 /* High-level stream table and context descriptor structures */
-struct arm_smmu_strtab_l1_desc {
-	struct arm_smmu_strtab_l2	*l2ptr;
-};
-
 struct arm_smmu_ctx_desc {
 	u16				asid;
 
@@ -627,11 +621,19 @@ struct arm_smmu_s2_cfg {
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
2.45.2

