Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2052.outbound.protection.outlook.com [40.107.101.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9144C1B2536;
	Wed, 21 Aug 2024 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261852; cv=fail; b=DLpSrjdIQQ6upSu6dDXwTLSuMzrlgs2W4/DUtDUggbi9+N5BgBXY/KtgSC0K9Dd/muN+L66uB7FCeftb/dJNKFPjlVtZINpkRgmLDvKJjuZaxlnU0sU9dqFh8hbug+JRuXfjCD+twI6xjiyLuCJExRvZRLC7i46N7jAJPTR7b/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261852; c=relaxed/simple;
	bh=pBEQtazKIgbZvfJkCaIa5+vsXbxdcPphjlDt1XW0neI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=txyIXM/6aOn6Qe1rXyjxw6ftb1aj62GDYWccU3f0lDuHHK9Wl7S35YdVcOt/ch+KbKp8XzL2FS8pMJdTNLUnM4FE9ZHugMmbz0W6rq83APUiUHispVszNucjppO14Z5GPgWUhBBsgPXI+vmff8FRNmqutkzpfv5l2X3wjTkHyaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nEpBOr77; arc=fail smtp.client-ip=40.107.101.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nEpBOr77"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i7D2gVWw7+YrgtlE3nXriPrPACUkCLWKfeDPMk4hv9ysZicWQfJm4ywd1AAdJxmrDQBORWRyH4aRBTYUeSLzW6dbnSvDSa0JRi6CmOJ9ZH8xax+wZZssOaTLNqLEbfBmf80DcKkfhgduLL98vkKSnzCQGugJwu7Fs5LcAE5gmTKsCkxnG2+2C+RDIzkUJsTzrnwQweceGdiqWDRl+fC0NfDrx4d7+G2sYIfH/75Ge+xOki2+hci4AYBZ91Z1PPeDSQm7nvT1DTrZrijwFApwFK96n4a5mbK8DL5Ismb3904CxXfTxc1/MsduIwrxsSp51QQP3PXEYlxhYDlQfV4DvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEngg8wEybcfkrISJ9WBrs80Clk6d/J+ls4ZVLiMD14=;
 b=OeOwI6RvTvXw661b24IYNbAfLiv4BN3Cq1NtJpA6p1PBG98ZCkJGA9N2ZE5heN2UyctOSLQrv/x0Jej64HSqTo5EIqF5N7XVm24u23TBrRnaXWmrGmXdOtVpJCGhbPB+iACEN4CyFoeQslwr86YNssZKdVCsKCrFD0JrWYpKgnPWz+2oIlZKsIYOLBqrDEWKJTKWCDxtVooAt973rTXCUOB8Mhe9EtPraFoYd4HU6jRWsFFh2bWRioG1/fwfPhm6sQhKT21iuQAeLcjhm6FawUTKtTO4KkzPESBwnYMKiE93ZZdznGRQi+pESSl0ITIIfhMYON8g1sNPmc+ZVOeIlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEngg8wEybcfkrISJ9WBrs80Clk6d/J+ls4ZVLiMD14=;
 b=nEpBOr775qhv/jbF0fL/C6u/2IDE5dKQFkA5Q/CsbO8zw1J7yzlNBiiMp0m3Te9rmZf0RDHTmL0MRzTsoMu8228XC9w+EbQGG8RIufD9RKXlRKPYCqNHuOksqNHv/AeJ/QXjFfViqcSV/nThHIP4EVFAao6yujMUh2NT31oD2uY+VOlWaYEqHd73o2Avo7t/FMQ7/k7OtFsYZEpiRSNn3gmAyf6GcFf6qymFJEqDcdKEkVdlLvj3oMSAnSXsLcFkRK0SfHXngHjHMd51FtN5OdcCRGOcCd3hKrtpq+r6rxLEyQlFusEZNyC9IKWa9+fklal2j5K/9wlAWvHDp2GYCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MW6PR12MB9017.namprd12.prod.outlook.com (2603:10b6:303:23b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Wed, 21 Aug
 2024 17:37:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:26 +0000
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
Subject: [PATCH 05/14] iommu/amd: Remove the amd_iommu_domain_set_pt_root() and related
Date: Wed, 21 Aug 2024 14:37:11 -0300
Message-ID: <5-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:208:32b::12) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MW6PR12MB9017:EE_
X-MS-Office365-Filtering-Correlation-Id: 1db23cc5-bb7e-4dee-f4a4-08dcc207ea0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?waO3iMYNTh7TwUE2gibSjXL/gqkH6ZabDAE0P/dJxp/DXqe3tGwfN//AzPOc?=
 =?us-ascii?Q?JshpZe3aA+eh4KWT5KLlE+pOHh2smX/vbQg8o7zQ+KOEwqqqPc+4942bLbzi?=
 =?us-ascii?Q?HaPbgTXiGeIgUqJ+0wMNv+UsuyTgaglZyTZ9pAM4LfVhIr0jD2uKZ1BVX5Rm?=
 =?us-ascii?Q?dljTd39LwvWHZzal45xMXc+IDZONHsVR1SBlCwResPf78VqTiEIT6eUCcBr4?=
 =?us-ascii?Q?tuYsAaOkN6lnEGAWbnhb0VCXH1F52InGdMdN44VHFYe+esGwkJh+KSb4hS1j?=
 =?us-ascii?Q?hfM8pmP6EHPKnli1+XuHEIAoQ3BJRKno1tHADz21W1HFpZJ7EA+L6gC0g4Sx?=
 =?us-ascii?Q?r40Q7bnH4k0FmGbqm6CA47gxmwHLIJ4rg2MeMB8ETfQAJhjpkUrj+Ij584lo?=
 =?us-ascii?Q?8798dh8bcvWgZbD1v4K2UR0PebA3pSNSRu8lK+/d/AuIS0z7Oq1nEASnnRBz?=
 =?us-ascii?Q?EkHta7axrmYJExwSz1wbUhMU8luDVWeRMBAQNKCfxPO+VtX5onlPFluXIyxk?=
 =?us-ascii?Q?YiReIvzNfPMTMJCBJqpW/nm53voj+p+51+SdQwnCcke15s/gBBJbKBPA4PBX?=
 =?us-ascii?Q?WBzkYr342R+2g64fnmY+BOZED/EbX4dOIllpZSr5xaJVymswIkDrdUlf+MlL?=
 =?us-ascii?Q?AcWkVK9JRZmh4ouwfIDr/QjcTyjoXBwypiMWILVH6U7naQ3UZq7FXzmi85nr?=
 =?us-ascii?Q?ckSwHvo1A9FXibw4igaBA6+h78j1vi0upeXLlWX9xXrpRiXXmdFkI4pNQJYs?=
 =?us-ascii?Q?bU0wI/azV32ema0JALs4StHGYIt+YnqB4IBlqUmwLtf/YGwHXXo0lCAMuZQJ?=
 =?us-ascii?Q?+YwCQBIkSjJN1liLIkRQHjw92jWPi1DXjcyGuaPvcIH9+wll8qJfakFVWTyG?=
 =?us-ascii?Q?b9y+x1L7qXmqD4dAuKB6ChYQoV/6AB6sOhs0ot1yXZu0ABuxKfrltvHUxqMF?=
 =?us-ascii?Q?XhtSvlsbSPsf1jJP2CeYyxE5mSZhMCUb91omi/TFRZmLYmwITG9TqOCKiPFG?=
 =?us-ascii?Q?Qch9+CuWf7JKjV4nmQBGOVIGT0n/FBYOx219EbtoYr2n0VdxHfR36eRMMerI?=
 =?us-ascii?Q?9Rc1jL4WgUqfYclhT5hYlF+/bwKilz4PfZTt6b1p2kGpImQXMe9IHAehUj1w?=
 =?us-ascii?Q?HQhmRI5iI91YD/Ygar8gKP5UYkzFfOZ5OpbLG8BubIcrfILQuDY8qcIRwC5A?=
 =?us-ascii?Q?b3FNNzTNL+ZQTzj4eJVBXIQAau0XcPX1RCJsKkstbEYx5pbW1RMJJTV0V+cp?=
 =?us-ascii?Q?d/bgRXtritdfQqgAi2dcGliLW39CPlrDIfIJ11ipumM/S8DhDRNnPR8S82mf?=
 =?us-ascii?Q?hntC9iI4T0PwKY20SiJnrqX+wO3e21/i7/ppdZ7a2CFleg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rr8iD2GvUq9x7gwPxhn2C7XkuehxINJuNe8eCdFlfXS9CZ8DJwH6pZtXe8gc?=
 =?us-ascii?Q?1k+i5GGGQY95Qxg5Tm+jUOoxi0y5i1tGblgwFjiD/FD6WTGQpw49ITMUnmk9?=
 =?us-ascii?Q?JrxNYKgAs8RKJ4Op9/Ojy/t8uL9KsPDGQGaO8Q0VO9I8Eujo8p6L3Aovt2hW?=
 =?us-ascii?Q?TU3VFgAvWsLh9eQ1oSBzC+MUHoUi2TVrgIEQgUsvdF/+QNtBKCWeqZ4nl/4u?=
 =?us-ascii?Q?ERqpqYd15h+2QO/6VMZ1UqhbRlgvE5rBhgninwoYSOh0Ds1bCoG9M6y3W9f3?=
 =?us-ascii?Q?7ZrXpbsYyLVusu8/gDPXdFV16+QUmuwKsHn6JWbC/eV3XL79zKUha/1dIodB?=
 =?us-ascii?Q?DvCbqrkAoPp62o9DSErlog2qXkr0a1VVh6KNvPjCyAGULM/QkLQrNfJfMBM/?=
 =?us-ascii?Q?zh8Ot9I2XQ7f0oAC3CgugBBO/eWpzs3gPR3n/MqzvpBjYD6O4qdarm+CWj0H?=
 =?us-ascii?Q?2tFLio1IcK3K+pm3ZVUnpQ+C0tuzgiF4n6Onu0FKzNS7Aht4uLZBVqGW20m3?=
 =?us-ascii?Q?8nU+deB367uURwXRDI7F1XgyC48PCGvp7gwJyJyS2QdsPTjGaACCCzaCoCr3?=
 =?us-ascii?Q?b2b3M5OeX4kzg7LUbKpKsvm7Uh79hvFWU4uC3wP6TFAMxd+3xB+T0eSSHRNP?=
 =?us-ascii?Q?tlpYRaldMq9CotarFBZMDFUNwHHSbtqlPrflvEXjsv0dxIIBE9uSWVwFDBhZ?=
 =?us-ascii?Q?rW5ULHeVww5L0aPkiOkQP6NnhP2x2B/9m4s6+2mLudOmdnxUApkVX6W0OH8z?=
 =?us-ascii?Q?qn22kjwzhv4+ZpHWMnTJClrG22oZCNdRmYzzY+0qgEI+myg9WLlSO5EhluOT?=
 =?us-ascii?Q?qMepn7SeuvTdkqViKrIGjM9hZzQLoFuxdDVvLDDX7ouYdj7DqM6RerZPo352?=
 =?us-ascii?Q?JEiIY31Wt63BtSnGkTpMC7UB5b9HVN+4dwBhM0sjrgKEPSlbuuUIEpCQzgeP?=
 =?us-ascii?Q?mCaL+HVSmDS4Bb1Um5W774CVsjLm4K6/w+F9om6IxH15uim/TJ8EdR/WGxMa?=
 =?us-ascii?Q?f/KEvq7qAEgPpbi/0TE1V4KZu/xcuDJZG3T0maNedz3VxRFCQcyqVVFp7Zzb?=
 =?us-ascii?Q?/HzwW4OURJMRWA6Pmc+1gJl0Lzjs/CZDxcVo1H18Nwtrp49o6er8JxEuUkZk?=
 =?us-ascii?Q?7CN2KMopoq3Od9KignwhWSXAI9vfi0l/bDa37V6NuaTuBHW5W/fETHqvDna2?=
 =?us-ascii?Q?Bcg/OfY//8Wu1dUxr/jhzuSLoAmUb0L2IVeLMSySTpUUPT2ZbCFW/iYN2W6G?=
 =?us-ascii?Q?eI0+hDZXL3+gOSm6Z/uzNOF9CAdSYR3dsIHP/mpdKwtLFDoEgud/oxV3Qwmz?=
 =?us-ascii?Q?GUuaxXAkDCxGMNU0ZXi/4T/PNZ1sTRg1BczvEbOE7keJsYelfYyssrhsT0pj?=
 =?us-ascii?Q?czZtkpIV+nlbnCGKaghpVXQLjlmBdR+mOdzdi2ugY1nhZufp43tU6Xf/z4p0?=
 =?us-ascii?Q?JBrSIBKqchuCsVkNPlMoDwsS1petklbIrwSVTSrNLD7L6bw2d0o07BEcrC5R?=
 =?us-ascii?Q?Nf7uNnas/SLm95IdMEuzhxgVMiQ5bB5kO1t9Sj864DiGktdtNZUFjPBjuJwo?=
 =?us-ascii?Q?JaLbkoknV6UQ6bxq+vyauu/HAL514uxmVyih7qBA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db23cc5-bb7e-4dee-f4a4-08dcc207ea0d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:22.7958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58ebQZ7XTCzZ81H9xkC/3RsrVa0gKGMp5+WCB4deppqH/jMa9Nqnm2DkwCiCSQ3u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9017

Looks like many refactorings here have left this confused. There is only
one storage of the root/mode, it is in the iop struct.

increase_address_space() calls amd_iommu_domain_set_pgtable() with values
that it already stored in iop a few lines above.

amd_iommu_domain_clr_pt_root() is zero'ing memory we are about to free. It
used to protect agains a double free of root, but that is gone now.

Remove amd_iommu_domain_set_pgtable(), amd_iommu_domain_set_pt_root(),
amd_iommu_domain_clr_pt_root() as they are all pointless.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h  | 13 -------------
 drivers/iommu/amd/io_pgtable.c | 24 ------------------------
 2 files changed, 37 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 2d5945c982bde5..5a050080d2e814 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -143,19 +143,6 @@ static inline void *iommu_phys_to_virt(unsigned long paddr)
 	return phys_to_virt(__sme_clr(paddr));
 }
 
-static inline
-void amd_iommu_domain_set_pt_root(struct protection_domain *domain, u64 root)
-{
-	domain->iop.root = (u64 *)(root & PAGE_MASK);
-	domain->iop.mode = root & 7; /* lowest 3 bits encode pgtable mode */
-}
-
-static inline
-void amd_iommu_domain_clr_pt_root(struct protection_domain *domain)
-{
-	amd_iommu_domain_set_pt_root(domain, 0);
-}
-
 static inline int get_pci_sbdf_id(struct pci_dev *pdev)
 {
 	int seg = pci_domain_nr(pdev->bus);
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index b3991ad1ae8ea3..5278ba3f676c45 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -132,18 +132,6 @@ static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
 	}
 }
 
-void amd_iommu_domain_set_pgtable(struct protection_domain *domain,
-				  u64 *root, int mode)
-{
-	u64 pt_root;
-
-	/* lowest 3 bits encode pgtable mode */
-	pt_root = mode & 7;
-	pt_root |= (u64)root;
-
-	amd_iommu_domain_set_pt_root(domain, pt_root);
-}
-
 /*
  * This function is used to add another level to an IO page table. Adding
  * another level increases the size of the address space by 9 bits to a size up
@@ -177,12 +165,6 @@ static bool increase_address_space(struct protection_domain *domain,
 	amd_iommu_update_and_flush_device_table(domain);
 	amd_iommu_domain_flush_complete(domain);
 
-	/*
-	 * Device Table needs to be updated and flushed before the new root can
-	 * be published.
-	 */
-	amd_iommu_domain_set_pgtable(domain, pte, domain->iop.mode);
-
 	pte = NULL;
 	ret = true;
 
@@ -561,23 +543,17 @@ static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
 static void v1_free_pgtable(struct io_pgtable *iop)
 {
 	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
-	struct protection_domain *dom;
 	LIST_HEAD(freelist);
 
 	if (pgtable->mode == PAGE_MODE_NONE)
 		return;
 
-	dom = container_of(pgtable, struct protection_domain, iop);
-
 	/* Page-table is not visible to IOMMU anymore, so free it */
 	BUG_ON(pgtable->mode < PAGE_MODE_NONE ||
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
 	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
 	iommu_put_pages_list(&freelist);
-
-	/* Update data structure */
-	amd_iommu_domain_clr_pt_root(dom);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
-- 
2.46.0

