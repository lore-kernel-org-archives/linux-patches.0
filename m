Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1757C23FC7D;
	Tue, 29 Apr 2025 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745943153; cv=fail; b=DuuuteNzDO5BX1Suy2J3m2snCsv1mx9QC3IeNu9VwL2a64ZW4HEBlSdDMO76OfucUwj1FQbh5L/WJCRPkuXCE+n8GzYIMjCBAL2Y/taO2w6KZrs8HWxgQn9vJIxAAvNmoES1Ok6JswK/KPqM92CfkVkq/lTWbiKWBT3/E6i0+wU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745943153; c=relaxed/simple;
	bh=rAbn+A/fdmGuLnYn4evqar25etHCcclxnr30+VeVaPE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SMgHyXcmeWtBScOeYXeRuqQlMTJYgxX4G5ZcHMJsepTs/iuWP5nNynm5hMd91CT7HIbdigmObpfgmHqDs3KYmsGvaPipUyYyWXUaWLMDOrUB5rKOT3qAVkEISWLUvSv3TbBOKGqQ/njXYamzSVqak2qfjFeugDuyjvFj1bqRFLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nJSYQUUb; arc=fail smtp.client-ip=40.107.236.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nJSYQUUb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fY6vifsH6AvXCcHhqU9wCVSJ32Kf14rGIxut5fYNEGpNonZMiutr0/QzfSbIg61fwMCpzop55zg7UDPBOdM34fnJSrOcbYJFOzbGyqyMX7n7k1oP/oRVenDlmaBFZwvSpwhAQQZc7olURfGSOcWBg73TEoz8QRWHoNUL3OgchjrYtBChLAICLdvdzsP45GbulLb9yhAintaCVKys2LncVRWi5NLDRD3Nt+Hq4LxLJp25HpqHHbp1zVhVzDn9BBE91YSsifN1j1bD9uPcC1pThs7ikUJUAvi8024yZ1//0w8aPO3AfLZbO7GNDeaX1kIZyiHvjmCkufGqYCPOEyMgXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYn6y9eu1lQzJ0qhLNhz2lfBS3USwqTiWgGm2bac63Q=;
 b=AkeUcn9od66/z3ltyHPQvRJu+4tbeBCdYHraAlBEemMCU7wumU6Zy7oErMrLUdVtk76qPnd6CYV1QzZJR5DLIwJpfqDRUMz2aM4WHjfC/zIwxt6q+Ngr5kDav/SlSSumfoQkAv6Dtos/gJyNq9GCl+4QMWebZIHng8o7kOu/afAGmkZrkbNC2nIUIyz3M53plt2xc/930SLkTJOdm9twvIudYxB8o4Kgsz/LwUK8XVCU34cWOWAWX7lU7OhocodnX0TTVL3yI2y+pHFng1lEvrYI8PXmYRWN66KOfGYGl7H6reR2/1s/zJZFYSAQOfDXZ7TfIIHSzUgvWGt2X5KTjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYn6y9eu1lQzJ0qhLNhz2lfBS3USwqTiWgGm2bac63Q=;
 b=nJSYQUUbR8ZSCXWkIMBVEOORjAMd5ap4ilWDtyuwMh57rfJrEEL+Itkrr4n4aKmqg4bNZ6mL4g3eXJF1/YEKVT/vY8cJepiP1hbYk3b9DKbQi3ym0E2eTi7gMNsmAZQBOLx4LLyMGm0++wLPDGuaYFxKAWm4gnpsPIoj29qIkqbtgqrTSu+xzjG6Z5NFTzbXU+pnl2a8kcBkc3Psjvp1vk7ejCuYSqIruQuo6qWLPk6gvmdGfFGsTsq4zCebjvyrWEkt5pwE/G5Jc8vIzCj9+oA19iGQFu3faQRh1DojEXhPCRlaarFaUp+f06GL4pzFaoPhEBUO5RoeT+GKHmyNsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9211.namprd12.prod.outlook.com (2603:10b6:a03:55e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.30; Tue, 29 Apr
 2025 16:12:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 16:12:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] iommu/vt-d: Restore WO permissions on second-level paging entries
Date: Tue, 29 Apr 2025 13:12:26 -0300
Message-ID: <0-v1-c26553717e90+65f-iommu_vtd_ss_wo_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0776.namprd03.prod.outlook.com
 (2603:10b6:408:13a::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9211:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e4ce26f-5450-4518-226a-08dd8738a2bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YbMWeV2FSIVbs0fusMEw72EPRdPvqMGonn2IPo7nlMbyQdSH043hRAdkB5rf?=
 =?us-ascii?Q?zdwUtF9cz7L1WWOuG+4Qt7HUAZumCeq4+/WHoPtE8OZ7QjJEEACG9YbwHIgb?=
 =?us-ascii?Q?I4NowQN8ctxG+RthgQ+P2XvAhznfAEsDlXHYEJTfPUZo9fV7hV8ei3lXQ/TX?=
 =?us-ascii?Q?R0FV5Se3WygvzB7mljkMPX4JDSNCZvDUYf2jIv75EXHKVo5uxr5zoNEbIDCL?=
 =?us-ascii?Q?QkPdupHx61uRSSDZxmCsII8vf1ruQ6wxbTiXF33L2PYswNQTa4abZoGMrg9e?=
 =?us-ascii?Q?H3EaLbV5ElemLuUODN2Ctll9nz+/Rvzs0+yznL5gfscVyUMRJV99xN6tNu9f?=
 =?us-ascii?Q?xlevuyADitzKjxum35h9YxHpaR5fxQR4t3uTlHtLwP7SDqi6J6y6KyrfuXvQ?=
 =?us-ascii?Q?pNAYyLJy6DYBLrlx6Pk4bBtYXOrWHcRPmFecrYtXsERnRF844koSI7daSku5?=
 =?us-ascii?Q?dv/mNgjjmubH1sFN2PkAxt/Y9Ns2VrrVvFTHbeAL9goFKw92Qz5RocKSZNVD?=
 =?us-ascii?Q?Adu8wha72Nmpa9z6FBOXeATfzGuN6mgRrREV4t10q6TTkBB/yT/Cu76UkuCR?=
 =?us-ascii?Q?/ge3oa/NnvhlycFOM7lyo6ZBvhxLi/as2H07IF5A7iLojuVRszbgqC2rxwZV?=
 =?us-ascii?Q?Oi3Pt74epGJiC645M3JV5+WlAmyfIx27ojLRug40UdIcIDEF7hZyzi5zw7Az?=
 =?us-ascii?Q?HlzKxbo+AkExawWig8xM+nJ7PPU1S6G3pLtCFqw6A7sybv3/LOTM6D9H5nJO?=
 =?us-ascii?Q?eWoO8Ng0K1A8b2s7xgQwgx72G277QbZBWnYQEufA9Nj55YFIWJQqT1+RtjEg?=
 =?us-ascii?Q?vfMUrhOASkOVCN3ohQXKSbgmGAgSJFlPHbXTFNnRG/U8wgPYByVhA6f0BVqP?=
 =?us-ascii?Q?7DjNp4lfUQv3QLMz0puDySiT47GzyBlpMAVabqJwfPWoXoRcwKPxZ+IIZu87?=
 =?us-ascii?Q?cCVeT446exIVHLtdhSXkh1D/hf0bpwOq0Hdc9fcH4xav/tgZwuQCqcUoDXN5?=
 =?us-ascii?Q?fdnp1yzV3/nAkFrQzuZ+4yLVYCNL8+7INEDxz1v2utPM3C9xDn9tMUmQa3dv?=
 =?us-ascii?Q?rM8q1yf5gwFTdJY733y90ig9e3ufTDKfy4u6u4DzbFtIzpb3YlDQwzY8KaqR?=
 =?us-ascii?Q?MCfovzut9r+vkYxCbrd1jyMFQudI3Ge09NBFyJv2ZYS+sbcSx8/Gm7X0zZUL?=
 =?us-ascii?Q?EO9voJIbUZtCWPqKOp5Ga1PhXZhNTwfdDS0s3iGDkiqch8kz8ODU9B4jwWx6?=
 =?us-ascii?Q?g18azMSVL9JnV1NQr2HST0p3tEPtLW0oyKKrTYtVX2h/J+I7AlCrHxYwpzmp?=
 =?us-ascii?Q?/Xzi3wgVyO8BFDBiPAwBgzZpijYEWhk3PjuvQYTovbUE3yGUr4kljONdTIsr?=
 =?us-ascii?Q?m0JV+sxdLneIxDAKiuHpTQIVfL1+akmYPOBjzSZ093Cf9psTNMrFD2MAQhi2?=
 =?us-ascii?Q?CoQjpdZe77M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wYV+1OlaKGwTH6tVIA4OCBkuALY+VuaOCFbTxB/ZxkQxFJJsqDc0BY09bnSI?=
 =?us-ascii?Q?Tr1MX+ivONy8aZejmxm7+2XGcHjs+EgDN0CT1WfEFuE6QsOHpfVUrdJ2XfVB?=
 =?us-ascii?Q?UsUGwaybRTDBGkrYE5YPq9qOhFubv9FtVC3v6J9JoZsYSFbqAiIx/lHjYaY/?=
 =?us-ascii?Q?aoNcIOtVz+GEye+P7TkPyBrFTv+QLrdAtoY2e4No4JMhvC218Yg5Mu8c8lAB?=
 =?us-ascii?Q?J0oOpKWFo1NOzFYHMyCkjaPCBDJe0JbUWjCzZWKlaFdOen1MfZ9ZoFygtvBD?=
 =?us-ascii?Q?z1rb3NVWUj45cLR/EhLbDKjEmOU43p20fDeLVsRx/8hrXc1hKylMnsOcjzsN?=
 =?us-ascii?Q?360UEOkgsOJ/iUO+v0WLc2VpXC6nW6sXn2QMuvpqwtxwk4Z/NAksuygrWnmv?=
 =?us-ascii?Q?Dh0egfQN3SCCr1Nm31/5V4lRdxngdCjruc1ZskiQaDft7x3EGB34a/RerbzG?=
 =?us-ascii?Q?viy2H8YdfekjjX6ILsTWBtmjTscbBDoul/FCE/oUlm370jm9oxwtFtsORBUw?=
 =?us-ascii?Q?J8JjtMPBM+A0krL7ar3HvE6RzDNXktO1ot0Z1l/qEv9LjD4skkSuXKkH0VQ+?=
 =?us-ascii?Q?sInbzomQxAtzjR3ERXJuKqsLhln06emU8ZlgeSfup2lm+S+5xdysHagOqrNU?=
 =?us-ascii?Q?4qcYNMASQfudfu0c2d9JCKVzdrpGLhk8Yg8JBERjlZVgUQjUGjdFaysKJjXv?=
 =?us-ascii?Q?xAVkQWKbz06tZSFjmwd9WHjRvJQOPJTo9vsGsROP55hSJSlS0jueugw9MDQt?=
 =?us-ascii?Q?AFnJJfLsOle2TZH3vqBZjBGtTtvjTUvPvjQZNoPt2Ie/hYzqAzL2R+AEK6WE?=
 =?us-ascii?Q?Mr9JlEG9cSop/vZxX4FPSU/Y0a9Xi9yvLDUa+Ma7jm56FtdSrweJUkyg34VQ?=
 =?us-ascii?Q?r9yYxyNCck5pei/QzuqWL9E7XvwB2A9n7rl1IONjbF+TyBTwxY+TEe9n2/lf?=
 =?us-ascii?Q?gSNrPtve82TYNUiI+dL7DWmuHAeKSNSlnJVb8vn4add6YO+D/a888tAHMMj/?=
 =?us-ascii?Q?IFtKMFHGzWygQefBaUJmy1Y7aATZueuhv91mAHrrbllDC6i/YAkvBeha5kcG?=
 =?us-ascii?Q?nRzG0Ai+Nl2vF4snhTtvrd7S1HoqvZzFuotEmCx5GPU49AD+MGPwXDrXzQij?=
 =?us-ascii?Q?DlJoWfZEpt0rBRjXjcy9NorqF0Kd5IGdNeIEjftbsIxwUh1LKV87TCf8rffN?=
 =?us-ascii?Q?46ayGeibL4E8CX9aIuOWuyihT34b19LSMRZr6gpzGSXZWacqhxWtAbTAkNbw?=
 =?us-ascii?Q?1ND+jvTVPyuSql2gdNDusMTumIkjeWk01vIMOTifBE5uvIKWK6DiWgVK9sFO?=
 =?us-ascii?Q?y5kpnLiMH5ZrLK8d1bNc/iN5wUOPfK4mNt6IcO077x5leZ22Q+FdntDbtDO5?=
 =?us-ascii?Q?KEVyswxIesidicFwgltaCWNUDjXSbB/vt2nZ0AEcGHKQ3j9EdIboOdsFYfI6?=
 =?us-ascii?Q?wRDtQSCrgFPMgyxTnD4Pb5rykztuNWi9bD5R4xohfF8OlXbtKNEBvnlNlEko?=
 =?us-ascii?Q?cdLXW27xyoyfP4jMSViDKJuLZVHKNU8i7JaXv3lLX+rqkDPpomrTG1jer32o?=
 =?us-ascii?Q?udLW9knPcOhViRS9h9LRHhFSXqokJmnL1Xsfs0t7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4ce26f-5450-4518-226a-08dd8738a2bc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 16:12:27.6438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLKgCqUd4yz7js1YaPTPmdXbppsfk+KUCpT5Ou2Fbi+pVzdWUWbIJdoewgpP3o+5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9211

VT-D HW can do WO permissions on the second-stage but not the first-stage
page table formats. The commit eea53c581688 ("iommu/vt-d: Remove WO
permissions on second-level paging entries") wanted to make this uniform
for VT-D by disabling the support for WO permissions in the second-stage.

This isn't consistent with how other drivers are working. Instead if the
underlying HW can support WO, it should. For instance AMD already supports
WO on its second stage (v1) format and not its first (v2).

If WO support needs to be discoverable it should be done through an
iommu_domain capability flag.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5d5291887516d1..fbe65e97381200 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1682,9 +1682,8 @@ __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 	}
 
 	attr = prot & (DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP);
-	attr |= DMA_FL_PTE_PRESENT;
 	if (domain->use_first_level) {
-		attr |= DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
+		attr |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
 		if (prot & DMA_PTE_WRITE)
 			attr |= DMA_FL_PTE_DIRTY;
 	}

base-commit: 398ca5040723f1b5bdc35900357f4a889b4b5611
-- 
2.43.0

