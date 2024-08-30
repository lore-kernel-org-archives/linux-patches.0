Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002B6182;
	Fri, 30 Aug 2024 00:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976401; cv=fail; b=IKTqn5+KtMtYmauX7zOiT8UxGmXzc0026Q2InmGrz6T7FCbCp7jjbV/jyu91u2aOI+0vNjNJDlmIYlOwpaxWivNbAVM6TO5/r7EOw1QOYrTBei8F+yBlq8joQQNDIbLbcV8TE1MIfxX3D2t9ymNRHCqBtBmalMzrUKnZqvR1wvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976401; c=relaxed/simple;
	bh=zoFKGCacO+w7xlHV5iBr/ZJ1Y4aSB1CjZ9pPAu97NWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BFh17RGsFsGxLH5617mdwAwDPwAm3B//NokdbLbhJ8WvAmt1NIqDy6VMKeb9rbf1MZr90b91ppahlNjD6uLCs3jNKzxhDNoeX8plSfmV4l444pmP4RYoFui/dzMLDj2D44DTIdnDk5z3XVa2QxuIm382zCdCt61FYsjETrM0zZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VQbD/J1t; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VQbD/J1t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7TBvlgw/yb4+V9CvVFP83TRXtEhg+pMPdUgOA+ugNDwVFSZQFh3AsteeU642euwxy5epK4shJuJ6iOEI3MRZILYh5UzDrfeq+t+LJKpksfbAo9e1vVr93Y/tsDc1mhXoflNIY0eccjbZ4CwlkZdIKuy7eA1EBk4F/dKsbxbvUpebEsoHZK3dyf2BPrwnVDli+7gfwesRDK8He4sKRnr8PakWddwGoOK5WFXzfNOdRnqHNMHdAg/9mOTxaxxJFLi71fqcsMhDbf+asweAKpzR3dakJCWs8N+ommNe+iNr4EPRDr2XvqMjYOviRnXiJHD+OGnbw4sBnoEaSwp7V0VSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ooNmblLw/jBFpnqBZTlIUZrJrmcu34ZAqIGHpopdlNg=;
 b=p675Eq2L5D0+17BvkbkdsaGargG/lmt7A9A2MAnf30zgRJpkcRocB6JZfM+P5yGh0Us90e0cz4dVxzwxGpbnlZzfsGuueYKB5/1V7bJ4YB1BChs2TKV7kTgT+IyNRPYu6O77Ec7qO+wTQvfZotB2rXLrsG1JoeSGyAwC0at2Ysh3BPYS9gGKPKvWvvBcXTLnlC4AqtkkkRmMRErEGFY2uB63owERKB8FduA0Aab6Iq9NirbdT5Wr3Inehi61JkqssJCkesTqGzkz7TfJkYNyq7z3Mc7QPPmyEUab01U4TEDuWcKnWDokQJuif7HwX7EXpSu4sHZnDSFsz6H6pfLPIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooNmblLw/jBFpnqBZTlIUZrJrmcu34ZAqIGHpopdlNg=;
 b=VQbD/J1t1X66EPS0KTguoJ0fU3u7e6s4/Rqh3vRsFi0HZquhKRiGSQGAtS2S4JWrHn39z/1p5e/PvfDP5eNCi8AuhOF04N7alZL9OHJsh2b5TOljFMjU1SEUgfmTFAM5COAg6jDhyJywkluTerzanEX/Nv1uT/4xV4SBSLEg7lh9nnaNLd/fP1pqv8NgyFSPe9ND+XzsFFNOkd+EIid4Ey9bEPxY8e5MVsU4Xfju3/rLRnfEjkCqNbJ+T0f8gTS5JT6KrWGzJZcSm/XbkDjTTtTneFIjxM9AVYs6OJOky1nMMu0+w0Vo16nnHHLJkn/0drnFDBqJ3yVBcFHjyeVctg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 00:06:31 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 06/14] iommu/amd: Rename struct amd_io_pgtable iopt to pgtbl
Date: Thu, 29 Aug 2024 21:06:15 -0300
Message-ID: <6-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0800.namprd03.prod.outlook.com
 (2603:10b6:408:13f::25) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: 34bae677-f93e-4b4c-b053-08dcc88796c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/MA7fRlbDPRMIYKpIsaY/TV1M7C2obeuxz4tdmz2krEQguGFqiWyiO02DKsS?=
 =?us-ascii?Q?DwYwHF9mTRIju37fHQTLMG+XIU+G+dQ+dz2us8vabZNIZYAMqVKKK0UFzoWc?=
 =?us-ascii?Q?O/cM77EfRWYCkuaWmVrNyz1gBTh2nO6AIaT9mVEn0WXEge/Be6QRCEjw1Gpq?=
 =?us-ascii?Q?stTofaUsZPZac/1dulxKaA7jQBYBmzUhxZwcOpUrpdAPQhI8t7OwDwCYZHp5?=
 =?us-ascii?Q?mYDVbswmz4vMkNoK0JVbOSTmh0OzZITBD7THFdJFJucxc2ebMu9qCMUsh2tg?=
 =?us-ascii?Q?I3QqZYxcUi5A7jM96FydyxOoKNYPYn0Km62zmIqKdjC/gI1FksjUilh0qZl2?=
 =?us-ascii?Q?z5csvtxEjd20RQPCamFXU8byFTI4F4cB1U75lImqBEgp2IUJbRyZb7JQhZXd?=
 =?us-ascii?Q?VKNve3+dZ3e8YLiXG5HgDWnLVqsAQbBMLC8KA8bFpEx3ekwH7ErfYYP4CYXQ?=
 =?us-ascii?Q?qcJYaMsuyY0lfGDRy22fpouNTKSlI1nM1eGohZcy3jEI6kT8A0VMRP3CmGxK?=
 =?us-ascii?Q?ZobGg/9Ws81CXn8iK3S+NJ9WVTE1EsiDylsa7Y2ZpxG2XwEJTkrjxWv2B0zd?=
 =?us-ascii?Q?kAKsu3q4Y01EVAOFHyoXs+jcLDWmIYchZQ8+dO0miyCGjYWcOOnozIwZmdWY?=
 =?us-ascii?Q?QDqscl3xkWishDLEW8ZC8MlXrT4YbFp1eV39u9HkSf5apCAtPn3fiqPpTiVG?=
 =?us-ascii?Q?zT6aDuTvZO/QrFou+ByBYKDVGs/p0sUOdr0uX3LpXHtS40M3ZF9G7wKD3PWO?=
 =?us-ascii?Q?Su23PufXEwogWlAZDwRKuWqE0YoxVZ2kUroKoLOoYsLbEnsg1xL+wAU4+CaF?=
 =?us-ascii?Q?q8kzRvCqQpzIyfPnEUQ0K7R9nguBLBZPbLobIaVIGcgwRE5IlGS7WPVrw4ja?=
 =?us-ascii?Q?8N3pNOVh6KS0chVwK4+Flz0L1gwdmfuTR01P65Anw74IPjJM91RFQ2DSZUQv?=
 =?us-ascii?Q?JCZ3sFy6npLXgtm6w7v1yrpNdsJU93+f+deOLM6le+RBhpM2YB2H9iEybbC6?=
 =?us-ascii?Q?+0UJuZiUEGxP9/vAndptpFxybkRJJIelcwfz/5WBE72vdvyonfk6oEnZPfzs?=
 =?us-ascii?Q?c043MjmsGr8nCqqXZve5jRNyvCr7PrObxNPtm54WPfVErIMhKDpSG9ytlL52?=
 =?us-ascii?Q?G8yn0m+noP87uz+DxKhH6AVlZ9XZT8JeXIL84C9NuBEuRvvCoJdd0qoqGd/L?=
 =?us-ascii?Q?DvNpeiL6AC2WBQbJxn4hyvsPMnzcSDPiQTuNGVjY421jjoHoOwGqc+1dVvxF?=
 =?us-ascii?Q?9grLJytQU2St/ILBpNoqHEWfiFRWJEiLNGwr0sXYszPZwC8NzPXRpWeQBsd5?=
 =?us-ascii?Q?C3CyKFEh05enhjMQXj058tgj5JUtgJx4SFOEB8CxaW6pgw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5eA0iW0ILIndDa9L1TCGQ7V/cNPuhu1tUEgikIeyOGalE1Cpx/L0azR9NsDT?=
 =?us-ascii?Q?biNs0OuHuHk0rKH8e+87qMDgm0oqgBeSIKIwRkfvgB+aqjI7IwHlJ6lkg8QQ?=
 =?us-ascii?Q?D58fuKezrJCxA3Wc+8P/9FKdAHCIoWaS1TwO0i0IntJISfDILu+1Zy554lTs?=
 =?us-ascii?Q?uQxaErlnMCEXTh/0T3ApYIQPqUnsZtLJhmccDEbkb2byiDc3QS0iqfruG8il?=
 =?us-ascii?Q?meGHsfi6nyb3WLATAKbMd5i8b0CjjIGsjMFoyV8TPsu7y8yvpkvea1YHlkEf?=
 =?us-ascii?Q?5SAru7rubrddacbT9+ZJ9Ft8HNTTp5r6V3ZOhwme9GsKR0BWW+jt0N1mkawJ?=
 =?us-ascii?Q?p9GFCqCdrF3OW5aAk6mdxsnexgS/y8weGd3EwR7oeuE1xQYMjVlXJvaobSfD?=
 =?us-ascii?Q?2hjgPoDSIJj96TXCJ1aUtirVgcAEMdqgXc1+DkNujbyZeTlfqoouZKo3+VfN?=
 =?us-ascii?Q?KbbeFKXZNyhD+Ebigr4L+eIFwPt3pOVOB4a2CF1sImEovfSHqxl265Hn/fVQ?=
 =?us-ascii?Q?Y15htCWeQEPhInMaSJs4UUPtBZ/q7g/UAvByk/RN2pjTHGuaxi1Z6Czsregw?=
 =?us-ascii?Q?OrSdfIWzOI238HaYmXoZ2qJLqMyRk1prHA8FYRex5Oxlqh+9e+QZLv2bb+5R?=
 =?us-ascii?Q?JNDypZV4XepChHcFKTACJu++6txByR4IaVlKKPnz77HPDLy/O6duAc6kLLm5?=
 =?us-ascii?Q?g4ZHWO7s7rYwkUWicbsYOk70GNtnFOHl9tjmLgpW9Df0KLgHYEec94iEKYy/?=
 =?us-ascii?Q?guituL7aOHbNrlZkpu9BS3IPo+AUJquox02lQOA9gZs2Fkrpvjbta5At7g0R?=
 =?us-ascii?Q?aKZH2BdIKzNR/rLjs2di5y30vEEsCN2i/e3ne1wIG7mGH253iGqNEeCa1sn9?=
 =?us-ascii?Q?V/Vfdfp5WjbUQ0R4Nt3BKCMbn1TYV98auhZKx2c1oPAgf0PF66TTDElwXGDO?=
 =?us-ascii?Q?BSnwKJWNaAp4iQdW7BSi0EozOJZC8U6wOvB3mXcfufP0B3TiD413zwLTHo+n?=
 =?us-ascii?Q?JSEG+WkCACWV8b247QjtsvcNZQxEiDJrXriOy/PLoAok9HBVCGBmHwO7o8X5?=
 =?us-ascii?Q?iOp7T0tRh9nWqJTARVvOUuC6dayRGdjCOQMDCEkeCNiOgAeAlRgCzG1dvogd?=
 =?us-ascii?Q?FFhyppOCSDuFbU8/oCbO8y2f5Bz/HGZ50GSBEJNF3HhA0grVsGepI8gW1eo5?=
 =?us-ascii?Q?z8XDU7XY8prE/l3Mj+PeRegGNnCf4zvxh8y1uHHOyc/1QCfgOxD6y3Zkobe1?=
 =?us-ascii?Q?sCuDZ91+li9gmJ6+MPlBcPzvtclSzTtZZ/B4UVq/ZzE/pSViGDX0qPnE5CbG?=
 =?us-ascii?Q?CYNnF1TDY088YSpQrqpeTk0AZk4BKSQLb0kAjChdrg5uCnA6fEC5yAT/XmbJ?=
 =?us-ascii?Q?0GwDCObHhFz4lSM9JxOxkRB9rScVQzg3jZ45weHifXJ8fYh1X7Hl30Gd3wKh?=
 =?us-ascii?Q?n2G+3qnAQI+aP41L2t4wDjdFBwRamvNKtEPWkFO+NCx3xmTTU7V6Yf+lh2Ip?=
 =?us-ascii?Q?XqoeXYrQtWsJC7kZ81FCWWAyZ6/bEZLrfQK8P4ple4jZdbbay2UUIt4xS1OJ?=
 =?us-ascii?Q?a0W0TLpI9NKTlhdNxrvKqozikb2vQtFYRPhFu278?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34bae677-f93e-4b4c-b053-08dcc88796c0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:25.6579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VnKt4RzhAf19C++oLWxPuFtY7+kaUECRnFO3wvRf5M2+EMpSRaE3mEJc+0k+I2S7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

There is struct protection_domain iopt and struct amd_io_pgtable iopt.
Next patches are going to want to write domain.iopt.iopt.xx which is quite
unnatural to read.

Give one of them a different name, amd_io_pgtable has fewer references so
call it pgtbl, to match pgtbl_cfg, instead.

Suggested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h |  4 ++--
 drivers/iommu/amd/io_pgtable.c      | 12 ++++++------
 drivers/iommu/amd/io_pgtable_v2.c   | 14 +++++++-------
 drivers/iommu/amd/iommu.c           | 14 +++++++-------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 2b76b5dedc1d9b..90a2e4790bffdf 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -527,7 +527,7 @@ struct amd_irte_ops;
 #define AMD_IOMMU_FLAG_TRANS_PRE_ENABLED      (1 << 0)
 
 #define io_pgtable_to_data(x) \
-	container_of((x), struct amd_io_pgtable, iop)
+	container_of((x), struct amd_io_pgtable, pgtbl)
 
 #define io_pgtable_ops_to_data(x) \
 	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
@@ -548,7 +548,7 @@ struct gcr3_tbl_info {
 
 struct amd_io_pgtable {
 	struct io_pgtable_cfg	pgtbl_cfg;
-	struct io_pgtable	iop;
+	struct io_pgtable	pgtbl;
 	int			mode;
 	u64			*root;
 	u64			*pgd;		/* v2 pgtable pgd pointer */
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 5278ba3f676c45..dab1cf53b1f3ff 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -542,7 +542,7 @@ static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
  */
 static void v1_free_pgtable(struct io_pgtable *iop)
 {
-	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
+	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, pgtbl);
 	LIST_HEAD(freelist);
 
 	if (pgtable->mode == PAGE_MODE_NONE)
@@ -570,12 +570,12 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE;
 	cfg->tlb            = &v1_flush_ops;
 
-	pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
-	pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
-	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
-	pgtable->iop.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
+	pgtable->pgtbl.ops.map_pages    = iommu_v1_map_pages;
+	pgtable->pgtbl.ops.unmap_pages  = iommu_v1_unmap_pages;
+	pgtable->pgtbl.ops.iova_to_phys = iommu_v1_iova_to_phys;
+	pgtable->pgtbl.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
 
-	return &pgtable->iop;
+	return &pgtable->pgtbl;
 }
 
 struct io_pgtable_init_fns io_pgtable_amd_iommu_v1_init_fns = {
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 6088822180e1e4..45a6bc3326397f 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -234,7 +234,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
 	struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
-	struct io_pgtable_cfg *cfg = &pdom->iop.iop.cfg;
+	struct io_pgtable_cfg *cfg = &pdom->iop.pgtbl.cfg;
 	u64 *pte;
 	unsigned long map_size;
 	unsigned long mapped_size = 0;
@@ -281,7 +281,7 @@ static unsigned long iommu_v2_unmap_pages(struct io_pgtable_ops *ops,
 					  struct iommu_iotlb_gather *gather)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
-	struct io_pgtable_cfg *cfg = &pgtable->iop.cfg;
+	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
 	unsigned long unmap_size;
 	unsigned long unmapped = 0;
 	size_t size = pgcount << __ffs(pgsize);
@@ -346,7 +346,7 @@ static const struct iommu_flush_ops v2_flush_ops = {
 
 static void v2_free_pgtable(struct io_pgtable *iop)
 {
-	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
+	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, pgtbl);
 
 	if (!pgtable || !pgtable->pgd)
 		return;
@@ -369,16 +369,16 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	if (get_pgtable_level() == PAGE_MODE_5_LEVEL)
 		ias = 57;
 
-	pgtable->iop.ops.map_pages    = iommu_v2_map_pages;
-	pgtable->iop.ops.unmap_pages  = iommu_v2_unmap_pages;
-	pgtable->iop.ops.iova_to_phys = iommu_v2_iova_to_phys;
+	pgtable->pgtbl.ops.map_pages    = iommu_v2_map_pages;
+	pgtable->pgtbl.ops.unmap_pages  = iommu_v2_unmap_pages;
+	pgtable->pgtbl.ops.iova_to_phys = iommu_v2_iova_to_phys;
 
 	cfg->pgsize_bitmap = AMD_IOMMU_PGSIZES_V2,
 	cfg->ias           = ias,
 	cfg->oas           = IOMMU_OUT_ADDR_BIT_SIZE,
 	cfg->tlb           = &v2_flush_ops;
 
-	return &pgtable->iop;
+	return &pgtable->pgtbl;
 }
 
 struct io_pgtable_init_fns io_pgtable_amd_iommu_v2_init_fns = {
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 426aecacc63009..e3e935b0fdf637 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2263,7 +2263,7 @@ void protection_domain_free(struct protection_domain *domain)
 	WARN_ON(!list_empty(&domain->dev_list));
 
 	if (domain->iop.pgtbl_cfg.tlb)
-		free_io_pgtable_ops(&domain->iop.iop.ops);
+		free_io_pgtable_ops(&domain->iop.pgtbl.ops);
 
 	if (domain->id)
 		domain_id_free(domain->id);
@@ -2371,7 +2371,7 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.aperture_start = 0;
 	domain->domain.geometry.aperture_end   = dma_max_address();
 	domain->domain.geometry.force_aperture = true;
-	domain->domain.pgsize_bitmap = domain->iop.iop.cfg.pgsize_bitmap;
+	domain->domain.pgsize_bitmap = domain->iop.pgtbl.cfg.pgsize_bitmap;
 
 	if (iommu) {
 		domain->domain.type = type;
@@ -2492,7 +2492,7 @@ static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
 				    unsigned long iova, size_t size)
 {
 	struct protection_domain *domain = to_pdomain(dom);
-	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &domain->iop.pgtbl.ops;
 
 	if (ops->map_pages)
 		domain_flush_np_cache(domain, iova, size);
@@ -2504,7 +2504,7 @@ static int amd_iommu_map_pages(struct iommu_domain *dom, unsigned long iova,
 			       int iommu_prot, gfp_t gfp, size_t *mapped)
 {
 	struct protection_domain *domain = to_pdomain(dom);
-	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &domain->iop.pgtbl.ops;
 	int prot = 0;
 	int ret = -EINVAL;
 
@@ -2551,7 +2551,7 @@ static size_t amd_iommu_unmap_pages(struct iommu_domain *dom, unsigned long iova
 				    struct iommu_iotlb_gather *gather)
 {
 	struct protection_domain *domain = to_pdomain(dom);
-	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &domain->iop.pgtbl.ops;
 	size_t r;
 
 	if ((domain->pd_mode == PD_MODE_V1) &&
@@ -2570,7 +2570,7 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 					  dma_addr_t iova)
 {
 	struct protection_domain *domain = to_pdomain(dom);
-	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &domain->iop.pgtbl.ops;
 
 	return ops->iova_to_phys(ops, iova);
 }
@@ -2648,7 +2648,7 @@ static int amd_iommu_read_and_clear_dirty(struct iommu_domain *domain,
 					  struct iommu_dirty_bitmap *dirty)
 {
 	struct protection_domain *pdomain = to_pdomain(domain);
-	struct io_pgtable_ops *ops = &pdomain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &pdomain->iop.pgtbl.ops;
 	unsigned long lflags;
 
 	if (!ops || !ops->read_and_clear_dirty)
-- 
2.46.0

