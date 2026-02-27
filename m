Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013019.outbound.protection.outlook.com [40.107.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E4D429834;
	Fri, 27 Feb 2026 15:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205960; cv=fail; b=Bntck+LqlHlExa8lA18WkWPBIqaeIJ9fNdxpv1QC+9vQKVNpZWJZZZCISg9fBcoF2HrROJK0kmNuFyK0XO5dxDQh2T+FJhmWOos6jAkVuuvm3HgxaM2ajsQ/wuHQgb3y+A1sITG98AJYi5f+DTMawFawnYKho7qqCBBg/hZK/P0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205960; c=relaxed/simple;
	bh=yXi5jtWIOqrw+vHAKDm4UVZtcrckf8oMEfe/IlHGl9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lsMhdVZ/FTnfoh9+FzwWzdcwugagnFXiHI6gWMlm9j86w5NpRugfmc18IoK7oGEGxK8VxCC8B2pYtzI+zfuchSqET97CFWOjfvCDANipa9qhBcYotMcbH8zagp2KoGmkd1Gb5XuJMrFx/Kg95o8PZuZx0HgHoIa2eABvfzQgs8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WzGLQQXK; arc=fail smtp.client-ip=40.107.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WzGLQQXK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gnu9zRWMpDQNogJ5ffTUbed32EIekfRsDg5HFg1M4VDj+A6n+7ZhxulBMxuBnR29TiCVCYSZBWR1rdiuR7pGNJ+RBXC7yvIfAW3yXKDfnG6FSBlUcwTmixDxVliUtZpHlJg+uRzUbQyq8tNGEOBWmMZlYsLC5M7AaS9n0/YEhWX7wp6B8zJ0MyKd0Ow1YN7SnR37sgqYBfogWfNn0/WgxjhtX+vsdjaZhCpfD3anxyDid9d21ppX3gWJXhWJUYhfCHyfGe40utztv8sgX8nhljBSX65VMvZtY4Hr6wiHQd2hJal72qrhe9IjdarKetlfOXeBv84rbErII3/acs7qAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgPTwkPFYaqlGo6E2yEnxO2AYLpRAiH4BrpwIlcfS2g=;
 b=ee+dtuPsFCFqwrW3PGM87yzUeJAd0C0yPvhMmMNlB6p0Ob53yNzmXztgzq0TNwIZIhUMpQ7rZIxjkw8z3C8x+s7Xmz6popYEVx4u/6KSlc1kQTTF33PQLDeDqhI7kzuggREqsaSYzvLvQucjVgTK4lAz8Bufv19eC1I8IkwKBUZmlPmNDEuiWoNA6k7t4KkV6gVr29iLptixpjENgMK/FvAvcUQsNcPAXMkN4keDD5bG52Rx1AyHB05/klcocMbgHfdXkARJHsbLx0KRO7/bvq9gkaB8E2L4Cy9aM+xFNKKRzs7v5amylNu8tlpXzNUDTv8yIU+1tSUbPcjAgog7pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgPTwkPFYaqlGo6E2yEnxO2AYLpRAiH4BrpwIlcfS2g=;
 b=WzGLQQXKLlGlzxVcJJS8malQfjowsOVh3KNH7rCjMQTW9rAsVSipfcyD3btYSN11ACD1b/m87WzTTm79qwS2L2owd057ke/FGLwi+zJKIwUjUeEGok8B1E2AXjcjBBn4Xy+3yN4a7h6YiWUoAQV9yJs6jw2TYOKv4UyMx6xOsYMrIAjSJgHI4VmPE0g8h0bI+bfy8+4DfrLWvqlhQwHCbZWFl3GLoZyN4fLTHYVBT6iMDC0JJCZntVlX6McnX0x2OoSRSjrtErFOdGufChgk4pVPO83ThvN1S5Nb9J2gdCyEAc6ym0rLkAWKsVHDZBIziiDP6Qg5ctbu0zOQTERT5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 15:25:46 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 15:25:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Andrew Jones <ajones@ventanamicro.com>,
	Joerg Roedel <jroedel@suse.de>,
	lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v4 4/6] iommu/riscv: Enable SVNAPOT support for contiguous ptes
Date: Fri, 27 Feb 2026 11:25:39 -0400
Message-ID: <4-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0038.namprd16.prod.outlook.com
 (2603:10b6:208:234::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 74beee6b-3ad9-4ab0-2679-08de761478d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	fMmUuFEv0kv34psV+r8fllIzVSPc00diUO8VHe4MwDofUlD+3Vf3a+r5u513B14J05WzRNnzncZ/jPaXrbgZEkzbkEAUgFqHxpFlavPkMaUCzu/Sz6s3Ey4qJjBSkeSoBC+sQ6ihhCaGLWxBDnSVrBmmM/VisQ6mc0NXXPMGy1nksXPfcLyK/tGR2MoUFvg9nuFncVgRQDtBwXr3qBgtfH1D5kV/x+B5UeXotIeDXzGeI/cKCkKW1LHxFiVHLpqoj0OGiQpTmJRT5kaP1QE7vRT+6MGQs164/5PDM3gwQaDR9uc+8phyH95LuaVvo58EJlQvjQX2ZxrWP7Btcpyespf8hR73NVNpCS08gBwig1SfOnIQFe95fbxx6onAkmzNxiY96nzci96SRY0QPh4EwQMTivd26KlSw/9oNUTULHC0ye3B2Ji8qrSnYrx0WyyjJXGVTw9D2IuC3iDfFVK3p6SY9QH4lUpY72Z0TqK7mNkIjipbitPnG2Hbgie0+mYq/ALvhtZu3xgla4jIKz3kqRMu2Kp9P9bGqQDx9c9AQgQ2PTAUXtFajRatJ7rRtE/HA7LPdluLUdWXwPGYFkBoC3xINYgr12JxjI2jlbXD6DRhBRR6JhM3i2yGGhln3TjAGCl7lZUbD0ZW4Lv9cr7WMXgR1uDJlkFL/iuUEka8Wvop8OMhJQf/xNkYt59H5g0brLw43eXkrpXMsnCbpKoOemx+CiPtPfIVqjRldo3PuKg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cbcN5d3l21NR7YldVGUAacPrb6gevqm8SRi/Bb0FGMN95nTg2JP/2iSrN+dJ?=
 =?us-ascii?Q?PUjSeSRgRl+l/ZKLq2pV1PA/5Zh1E4LJVZPUPWdaNzLqvI7dj+WDcs3RJnM5?=
 =?us-ascii?Q?qfuzS0Fplx5z4HT6xvDETuxQ99e8tr+WEMzNRUalbiGYV2bUsPWDvs/JSxqj?=
 =?us-ascii?Q?bPdjwlIJCeFUgr82doy/EO1eHJhWQueQgKJW9YSRdrQgtdT4/FJApAkylvOI?=
 =?us-ascii?Q?bU8yXkPzwH+Sz9/BWx1R36cgoVdpePkHWT1G89jA283CONVhI+hKJGMEPhvi?=
 =?us-ascii?Q?ACe17ZwQCegrUfrQTcDUortXvXNPniXUdmKdNza+5mXqqWcP9rS8SfQyFzRb?=
 =?us-ascii?Q?q1CuJwPQtfHTIKSjLZTf7eTL99V9RVOIYwn5epCEpD+VGXnVV2UauNTNdWbD?=
 =?us-ascii?Q?y8f51iO911/dGinZKKgiZcnFjd2CfncQx8C74gtkqHqM6p7LhBJTnQZJSEtA?=
 =?us-ascii?Q?FiT6f7ozVH/h/za03QTa/ZI2Rqwr7ABl3vA5C8TWifWok/ueqmQogxYZWJsC?=
 =?us-ascii?Q?a2+VRVu0hoYgAREFQA1Qyawv70sqiKB+AmOmW3X1Q1fwq07QQgQjf1R357V5?=
 =?us-ascii?Q?sukdTizqd+0MbCGmxFvKkHcKRirl/X4Y8dNL2pWUQwxlYFTJ1/6bZBYdGSc2?=
 =?us-ascii?Q?+swRImOg/oL7Fq1XpGFApL23OQJM/Gf8OBEbz2KKFe8T8ebaJpPNLgMBbE3O?=
 =?us-ascii?Q?Sr4NEnlQdnMGB7EPFEbfdhJItE6gxBjjZl7+yYjdfFYZzTm5lXGJdMQPQAca?=
 =?us-ascii?Q?1niJFMkhWLmL3EP4k5xKLB5tWEEejuoIcuHxhKarPrMfEc/O/TnbAUbWiFY4?=
 =?us-ascii?Q?+YzePISSuVXyXxjwHfiY0uDL1IYNS0cyj5+yN8vWzWlwy7wulvRYKFaZ629G?=
 =?us-ascii?Q?WmW/AW/braWvs75fzgXaDjy1e/XlE+1N8ksnmrxQW6/5ULDDpblntgRUFvUF?=
 =?us-ascii?Q?U99B3duwxF5Xn3emCdddaOuYG5ZBKsUDUl6dvAEF7vDl4Kbs37VvHGwkCMKe?=
 =?us-ascii?Q?aDo6gqaV2mGUN+5kjE19QWbtonVT0Oc5Q3NmSgocJ6uPr4Pld584SsQy6wBH?=
 =?us-ascii?Q?nN/OZR5YW0eJZkeZBgxhxmTuxyTupjLy8fSqvE8xB45yvtNy5kx+tM86NQdc?=
 =?us-ascii?Q?sk1o3lcdDuIrwDvM7LFl3lSgJk2s5jfFNuduDTsIB324xYiWNrB9IP13GfPp?=
 =?us-ascii?Q?SQ7TdL1rEKDZT+yHLZTO57sU2kwnmEwUsO3tStvf4moCfkAzrUfG3I/TvyKa?=
 =?us-ascii?Q?e4hwNIsUZBktaHO6/CsltE2k8rgQwQrKZp2B0DIvlkqPdJrVXjG5K6zZvITM?=
 =?us-ascii?Q?xZkJk9UFf+Rf91jNwq0PFfjNI7mrukIaay48gU9uDPAnDs0Q+529p+fHptY5?=
 =?us-ascii?Q?QWB01G3M2SRKjaWMC9o6QwZw5fSXpvEmRWpVRxF4ogqwrLJ6dYbYG7mdrbuA?=
 =?us-ascii?Q?ha6gSyNg8jhAAM5jaMSo8HXyM6cMpQpfv11ypCFNGZOwec+eH31ypLtUSciI?=
 =?us-ascii?Q?6TDiMadtmX/jKXuOhIIY5VNtC9pIvjAGrO4K4FhBEjkfTnGfSUXqFLVTA9Kb?=
 =?us-ascii?Q?VEwceB26EBeuDuwQya/Cv7XS1VCXN9W6BoHDw6y3W+ki+5OX+VyYv/A63NMS?=
 =?us-ascii?Q?dClrEG4tUaVgbu4kkc3YidmEBIGXmMKtfc6jwdQdDCt2pdvpbxEU5S07QZDv?=
 =?us-ascii?Q?MTIjUVLm0XUr76oj1yc+IwSnu2FUWJHRoQypEoEdMDXsCj96NEHVAipa1Jcs?=
 =?us-ascii?Q?4ZKwGG6q5g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74beee6b-3ad9-4ab0-2679-08de761478d7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 15:25:43.6512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8F8sRsA6mb1UpFKGoPTFzbZPt9gwLICfErwimUjsUp94FM7Z6V67QrmhFwhfjie
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156

This turns on a 64k page size. The "RISC-V IOMMU Architecture
Specification" states:

  6.4 IOMMU capabilities
  [..]
  IOMMU implementations must support the Svnapot standard extension for
  NAPOT Translation Contiguity.

So just switch it on unconditionally.

Cc: Xu Lu <luxu.kernel@bytedance.com>
Tested-by: Vincent Chen <vincent.chen@sifive.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Tested-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 6ceca9bed91723..5016475587b868 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1185,8 +1185,13 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 
 	INIT_LIST_HEAD_RCU(&domain->bonds);
 	spin_lock_init(&domain->lock);
+	/*
+	 * 6.4 IOMMU capabilities [..] IOMMU implementations must support the
+	 * Svnapot standard extension for NAPOT Translation Contiguity.
+	 */
 	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
-			      BIT(PT_FEAT_FLUSH_RANGE);
+			      BIT(PT_FEAT_FLUSH_RANGE) |
+			      BIT(PT_FEAT_RISCV_SVNAPOT_64K);
 	domain->riscvpt.iommu.nid = dev_to_node(iommu->dev);
 	domain->domain.ops = &riscv_iommu_paging_domain_ops;
 
-- 
2.43.0

