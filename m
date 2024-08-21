Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A41B3B28;
	Wed, 21 Aug 2024 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261860; cv=fail; b=TLXneRpaORJJOR6iKKF+gdy1qgWPhJwZJ0tKanEQhyUa+IxTDKZ+/MqbitkEPGPVjQEL9RjJPkB4PsYXbJUZpzLWCupvJdLZWt2x3WPBmqvIRYW8T43e9t5635s/X04KnRrSnzMETsN3UmWrblz5F/R5PZBEeeB9r7rUW1Rrkgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261860; c=relaxed/simple;
	bh=JGFVuvlMw2Onwv4KeWy5tIE11O5R3RqTuaaOoZCzZYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bbbKXBUPSivs5ww+XVU4c12Hjb9VG2rGEJfi7yeqf6RxvNQQAXLqgWtcWeyOvxaXl/jLmvoPeZh7trgt3Yl5SATSUlJJfot7ErXr4fc5QkucPdvwHZq/DoxswoeHC/BbOHqLOEKhcf8babygdgIMYeSBeqWa0xnrTBDaboep2Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tUmU5Wms; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tUmU5Wms"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpYRg+kSZlZYaCTVLnUQJgpg73hd0fzddi6xjYS/KokveJx+yzpEXkSsxJB8U8NhOq9MORWNdGJ81H/I1ye6t4za5WwRj24oykulbZNtCClc1hfRT5JFstipUpyy3e1QV4lNQc426nxG87/5QBQp8i1VMmOlc+uH1RuUPK/MWRhz9bGU/BmJibWI01sqje4SBUEhDolR0rqA8HJMYL9HhI01wKJ317jnTfq2qvQ3kjVZxR4ZOst+XQ/chLDLHRJ5ATLXLK6J0xRulmPutz6vcLY3m7owwz70dncJgB2yyvLUFUotWtGkQRO++rLUK4fjvDmf5njwq4F4KkQOmidL9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5WRlcb89hk/94zOJfMEnrhhi7qoUMZpBWqx9XBw3B0=;
 b=spsSfzLA+sIjv1MZJ1Wb4C+Fj6B442aZCa989Wgtfy2vzI9kPS98YHu88bO6aTMG4mJ11PsD5p4pyvT9vw50ZESusPSCWdmFXc6Krx3I8X2Uxmy6WPArYz8XAtzu9OhNBVW/CUWvVPoI8BnKKZ4+mvM0devop2acJzl7+fGynY+LxqAju0dK0X/0NNxR7hIQOGn0X+ituSVjbB+j8ug9LnMKs11qUabSm7/mNbvLLXh3ukx/QtuuvJ/TpvBKwT/L2kEO/FhnYPT67dstc5VUuO8t+hreyW+gJhC5FZUFlHRINlksS1s6tquE6JUySfcJWG/YTHAOQGM4eVIWSyJgDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5WRlcb89hk/94zOJfMEnrhhi7qoUMZpBWqx9XBw3B0=;
 b=tUmU5WmsmZYal22ZhkyClUHhZQ0je+/IoDf2cmvD6Q9tNiOAyZo13sfX0QIPzoimtalmOrHDwczXrKDRwI58Zeswi6Gx0lJOJXHKF4jaFQwk4fA7c9g9uSoZUNbY6gTB3mPvlK4ciETSL8oValHcr3sO7NAG2/jTb0Znpf3niI5Nt3xTfJvp8uypotgwA9cNTTaZbkrmeucBlUIu7tLWQf9ADeAjPasFbFsRQ4A77Yh/o1iQsxvbRa8LO/xRyx4EH95uK3DFaPZmkywK+qSpBLk1b0lKXMBEvSJddCzDmj3sgdzi4cgj9aXUc/lfxb0Md8PoylQoEHy0PKZzhqV3GA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:25 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:25 +0000
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
Subject: [PATCH 06/14] iommu/amd: Rename struct amd_io_pgtable iopt to pgtbl
Date: Wed, 21 Aug 2024 14:37:12 -0300
Message-ID: <6-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:208:36e::29) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e13e2d8-76ba-478b-a2e8-08dcc207e9c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OpIiPBshcGWmt0kgyXBGcJlRiagHT896IZUF4pTbLSyL5nhshKa5iL/Uy2JF?=
 =?us-ascii?Q?TRCJATMRZSyRHeycGtxYNP8GxoxLD7MOTxGheYXDu/O6EmCajryhM+Av7bfr?=
 =?us-ascii?Q?ggRHQyxv1zgzhtyJC7AJR2oPuDqILI6s+X6sv7/6oiwtWqIk94anzWJ03gON?=
 =?us-ascii?Q?fBk2z/kqhOYAFMB19z2DJRxtd0X1cznW92VEvBA/iD089/9Zgt8+08P0Hp52?=
 =?us-ascii?Q?qT3O6WygERfzRgh5UfYKpmPISXC9YhYznI69erey0D/eBR8p7XqGf3nYfIa+?=
 =?us-ascii?Q?mhnlhMG49NcYntomU/KIpgRMKpejbLfx46YGF0+0yzUMhB43o76mT7VEqj8q?=
 =?us-ascii?Q?9weoaD0ycXtOHIoKMunleXlicsuPNOJG53L9qokSddVtkWbbY/hQyaTnfsDj?=
 =?us-ascii?Q?ApRH/ke9BW0u3dVoThZjBPazZFQmUWMVDnhjLxpNu3Yhn8HQgjgM5ejA2l8k?=
 =?us-ascii?Q?3+pZYalw6xm90EnovBNVzQid85G08jTFhT29SKGFv2kvQELT2Ise4n67S3EH?=
 =?us-ascii?Q?N/SszDUmRFVW6HOMvBucwyAiZA93HRbgrB+qqxwyHs963Bm+8mN55cJRQqmy?=
 =?us-ascii?Q?b//Fr4XBfHirYLi1PvilRdinK+ic2HMLsgxTUfbpo/dH7fRwAKiycQSJBhoL?=
 =?us-ascii?Q?RmImRD4AzS/VUw24RDNtvoaJZo65MhBV0C5pGrBgH8VEa00nHBsLhXzArYya?=
 =?us-ascii?Q?nfKH2+3y5bbQA597BHPJvocCw/JgG0Jd9fftIOVvahaN1CENiZncjk+rmiF0?=
 =?us-ascii?Q?PoRoBKw2N52jwMdkCR4nACNFOWjxy/Lt5iQFYImpKnp12VcS5ccMVgJ5Pegi?=
 =?us-ascii?Q?HSfaZ2ERg2qhAhEgyY8FHac3FFQLX23HHlsrqpgW2r4feT+cZnkXHcfG63iE?=
 =?us-ascii?Q?y4GoGMzs7LsHgLN4INtpMXHyWuQvsqUUkYnLcgShTOVf2/nhMLzI/ayCiFAM?=
 =?us-ascii?Q?0J4RLQQmrtdWNt+O8NvHZabZSHWBLg+3RTiAp6dqZsFBZ+DmD3Ftdyw0qKgJ?=
 =?us-ascii?Q?+hW70A37iHjznQ/cheZqrz2ahPI00kKCd6Pcv4XtxhVuWm3J/bE1UzvBDZlk?=
 =?us-ascii?Q?AA2MHEwkJO2g1pxja+SR32HkUhS93qlKb0Q8MFbvKTOXQ3gbK7RKGdLDQ89p?=
 =?us-ascii?Q?A8E5hOEy+1sEUvS8PkHT+C9mtiqP5uKEV0xpV7C3bI7ltu7Wk8HoHooP0v0n?=
 =?us-ascii?Q?fLzfdwavK0kVHxikaEa55T8QcA+JLGj+Ydc2QlSTq1BUBpOWE3C4fCDnPTek?=
 =?us-ascii?Q?gSYG7G1OPTiVWwKcs8GD3INtkdocEDg3rJuxErHDGHujFnRv5pp0eL5nPVwU?=
 =?us-ascii?Q?SjH3DqqrO0o3c+Af0lz4qM7Llvx6ErFjzLYEAXiqLEWZAA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gH2dAeh78baEDpOLGW4JqlJQIhi6AdtT1ttD8BbmJIdtNS82up4G7RBM4dN/?=
 =?us-ascii?Q?6OJ/LlCbSwTXoKJjiHIS1yigbnqWwF5kH8OthyeEfXvgqXy9nPg9fYbiHgnZ?=
 =?us-ascii?Q?ca3mkxLJoBbwNuLl+d613wvKlf1+eOEzLnXfBZSm9aCWb1Au3Ake9Iue5fz/?=
 =?us-ascii?Q?hBSpsEK7dTJPiXBokRiNyeVSr4v2b3gvAUBW0Xs74KdY0YxTIVTEl/uSKVxn?=
 =?us-ascii?Q?+Rt70P9Hz4+gV5DUf0guunUUd9LnN5NOXB0haHmvsWRf3m6dJfvqgiLkwURJ?=
 =?us-ascii?Q?ho44w6EegEgE1FwMQvEbW8xnRyRI4TIUGe994nS+OFC1tVxyA9HYmTUZFEgV?=
 =?us-ascii?Q?e/o+3BOKjwTixRTOqQAYwnybO6uHoMBdpUvbvXjBs4zDh+01eRJPSic4TE3d?=
 =?us-ascii?Q?+eRofsDWS6W50kGRFmFc0EnPwDbUB0GoZeB4m1MZ0oLSkePtyi6zFxZRflhp?=
 =?us-ascii?Q?IWu8iZ0ar0o4mNyPt1KCsz4M/A3LpMlLEK2MbXC9P0MJnqdeBZ37ewLFp0hK?=
 =?us-ascii?Q?Xllmcm+OUvn1cUhtr47heywd4vp86Ys92fM6sLfkZEhY3c/ktyZTTXmGdhW0?=
 =?us-ascii?Q?vm+gU6rKBGCS200w4xbwaHOOoztQdjqQjRPvPz/l6XlbowkzM3Ok6p2iltVI?=
 =?us-ascii?Q?K8DxTaC5vIujWfY5KbUeHDOFfp4cKdFchjjf4E8RzKha8ZTqkYUYE6RDJ1pR?=
 =?us-ascii?Q?USq6wL8XfE4wgKK/EqTILg67SkormIRh3wPsJdZHi6Q0X8xKwXk+M/OVfAjM?=
 =?us-ascii?Q?YlaZUxiTgeGJi/kv47c4DsOH641OWL08CngJClL3BOcCZYayWfEiEkh356jw?=
 =?us-ascii?Q?LlBjMomySeOHeZ+e9y5ScrzND1Qplaqhs00adOJePo7d6dlUUWE80Fp93BRs?=
 =?us-ascii?Q?93uMXXNRe7btqqbJI/KNiVIHd51QLULESd4GLKi9jESIA0aH8OKrnK2VQWyl?=
 =?us-ascii?Q?e2Qc5sdSom0eM/tZjah8MmIhCtFrW9GGCrT2GqyNRka6s2XckGhcmj4Kef/Q?=
 =?us-ascii?Q?euQECcmJZTco6uvW6vAST8xEqVxLiuS/Zmr9Z1kW0sBTsl3Mt60AxDLA62ap?=
 =?us-ascii?Q?wGBKYGeAgBMmsEiCWedgHoZpxjjMzgJ2MRJ+DsmKqZsvd1yqBeAnY+OMIhYg?=
 =?us-ascii?Q?z+U1fHat7ldMzgwiwtt55f92cVAOO3Fjo0HZnDCjox76zkcwgj9DLA/7J+GC?=
 =?us-ascii?Q?dVfvVm53kFtLH16QEs9V7LNoMUxS4SPjU0oJPkYEug+tkBYWTHPHz14Ka31A?=
 =?us-ascii?Q?wBqR+wS5KmjQiXpR7fXJhp1Lvm7gyXLxPngHJQM6q5xTO3HFGumup9btFhh2?=
 =?us-ascii?Q?qVcrHOqylRTtxSxHvgAJ2qsIOf5ifvDI8ROo+3cVdtIl02M51RCLmDRGC3SI?=
 =?us-ascii?Q?lUTc17pNThPO9n3/SS28pe9OJ2BpNKa75QM50Ssl2gqXScv7MRhynAX9uevF?=
 =?us-ascii?Q?MuaUV1gsXE24uksX1akIo/LP5frIEmVMG41F1lbrQU0ol6Fwr1/gdKab2dgR?=
 =?us-ascii?Q?MRhGuiaS0CdmOD976W/wt1LP16Yjmw+27iabUsQOQC9hi1O6A8sBYkfKVZph?=
 =?us-ascii?Q?/tOJ4xG30li+FDednfil6pbXFaNwuv+SjGtQsbp9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e13e2d8-76ba-478b-a2e8-08dcc207e9c6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:22.3858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3RazQ092kj/Zk0Yo/e8WxHp1FIwphCv2Pc36W/s+6JyeO72ds1ls8bW64k8rfbT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

There is struct protection_domain iopt and struct amd_io_pgtable iopt.
Next patches are going to want to write domain.iopt.iopt.xx which is quite
unnatural to read.

Give one of them a different name, amd_io_pgtable has fewer references so
call it pgtbl, to match pgtbl_cfg, instead.

Suggested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
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

