Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2052.outbound.protection.outlook.com [40.107.101.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390DA1B2ECC;
	Wed, 21 Aug 2024 17:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261853; cv=fail; b=eVmxmHozRhkq2baDtv5pMvBr1wTLKn8zI+15//NWNTnpDZApSKMRODF9SenOnsW53Aluofy5hfMED8Nwkp8Li5+jj5m/OWHpFKQTr64quqdHFOcLGGrdlWM64SK7gxZhG4rzLqGlPlDi6IPASG1GPp3fjGZS+ILwAsfscjPqUoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261853; c=relaxed/simple;
	bh=h6lekupU2jWTNCT5sOvy/7BGIOlsd13D0LihoMP4uGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nuBjVDsJzV+5QRUUk3Fv+qAZMMKezLylKcUA+8XGGLU/FoQZ9HlydsHPqPdOjgL5NDgOKBqK2BiCe2j6bIYfW831ilJCs0YLHiFtoT3Lng9R1/a/ZUacAyRIpHMN2KuGSeFpBlxIBIZr/y9Ow/+ug1jl46DA6/C/zdFzS/ahsaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XId6GQcq; arc=fail smtp.client-ip=40.107.101.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XId6GQcq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SvTRGJjRkRME6LQsUJm/cDJTnrvOEpJTulwax7woIJ/Memiw2k+QFZ5Mho+b3cyRCS4/Wmc7saCcjUIsSPG9liBjchlQEaEyP/qT3fH/OEi/K9EWofgT6WzoXwoF7reMuVRzl31pLrFTlAf26rMGCqgEAaKOZFjHZBWzcqa3Y5lNzHvsu3dRx+OSgk/PGLavgL39PzK3kfFOZYeGd0c66o6UitvFyhJptsEmrFKVH+spktJmETEBOYql7TSgur0pLnpevxQiuxSQ8EIpfKdduf87Ntr57xUdhd70f14KqhBe2pUfvwd2LssvgtTCq5+MeGeeZBbBYS3w0uthTB/76g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvSOfJScLngTQ4hnxPTFC8FA7tBAE/VZ2MzUXSgcyzM=;
 b=GGvAN8gGqpX1xUTlBmw0n22qwQwfgqxpR5gaoEj7U2vaSlEQMpSXVFlCxxY7ya64sQyUEhffMh8mbqtJx4u/qYYaeH7xj1ilMeb4ufIVozfsxd2lwE7L9c/LJoy7LqtNhgaNsyz8q4siBvDPggUkc198kYHCb++I/0RqRPmXW8erGUclI/wYEt7A6Ipg/AIbNM5EFTvL2WMoopCDotRH3XLYOSFLZOm7cGk4kjisOrhP3cUEXPmBsLOLTUtrOLRVJlnmR1WpDORN+6kqCMKVUr5BmmCDN/PT1OXLRdT8v2Oe6PH6jJ7j8+ihszx6UC3F2N6pb7xGGadDbI55vfo04g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvSOfJScLngTQ4hnxPTFC8FA7tBAE/VZ2MzUXSgcyzM=;
 b=XId6GQcq/E8nnBGqr5y8dBqxXDgZX5ADLQcnX2izeJLoTcNsVOtu0OYz5wufTnvDxBtyDsRHhZc8ww6PNw7edLItRmKZWze6mwvrPq5dWqZUW1Ye12c7XjMNgn8ulqb6w7LQ5gQGR/USlOCFXrffP9f2dt/4G+vQKQN4n7po/1iSJ/DfQc/wQz+oILlCJicljmoBDaIqWDXe6zAFD+YyjSRLUWiB2DzDOJaOZgGdPfSeEaIJEtx3xDM68XhMvpbj70a6ToMqpG0TPs5H2TdmFpik4n5s6WFxx2E47Y3O+91vUJYJQAosY6h7+lDNlrjZ1rSN2VnJn8ABv41NIahXAA==
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
 17:37:27 +0000
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
Subject: [PATCH 01/14] iommu/amd: Move allocation of the top table into v1_alloc_pgtable
Date: Wed, 21 Aug 2024 14:37:07 -0300
Message-ID: <1-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:208:36e::10) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MW6PR12MB9017:EE_
X-MS-Office365-Filtering-Correlation-Id: c4983543-8677-472b-0d4e-08dcc207ea63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G+RFwYuFBp2tMRD9AFIVGXhJL5RJA28lKAurGQ2uEJa4pesbLWKCyrrFM3ek?=
 =?us-ascii?Q?n4ET8CaN2DxTWuwRadNpbzDPEynk70VzvYZjr/OdeiAPq/rQReXbKMkrWF35?=
 =?us-ascii?Q?joStirJFcLYp6/N7UPAJDFdciiaAsPDM2nvP/X2e/gIogv9vftATjK4ctLoU?=
 =?us-ascii?Q?B+fambft/QU29y25l7UQ8Wk1+AIeb3hgPlxqEt0jRT+qVzLjNc4jnHaA/IOR?=
 =?us-ascii?Q?CG4dl86qF1G0QvNLBEhWOOimVkABEZMhkjkbDhHtjUO/BWWkD8H4JQglPINQ?=
 =?us-ascii?Q?NpqB9GB4dXWIaSPjr8aHM2un+aqSgq3eNEYn7GvhS3Hpr+gIoWFAhyNHwrk2?=
 =?us-ascii?Q?z/Zr0rNPvvZAH2xMT9/7IqZGHQI4hTkPSSYuXoIoTneHFBN0qryUN7eSOD43?=
 =?us-ascii?Q?5tY4c6s0GUZldVrvzqgtAQBDBJvpGcT0rtWAkOjgOZJ3F4q1dhz5le4gQJ7p?=
 =?us-ascii?Q?kIhwTZzwnugWwCNRrDNrXA1uExjEIKhO6rEb8aWj8vFsPWyOgEiABmZG1UcU?=
 =?us-ascii?Q?qlh6MTxncNT0A2TpXMjUT89pO7185txjmHQov7c6R2pm8bqPzHh06Z1j3XPw?=
 =?us-ascii?Q?kRhBoUfiTfHVhn1s8WCZpcqDrKQUAtyaIgUcrDySA+RWEpeP4vnoDLb6nUld?=
 =?us-ascii?Q?80eyswDnz7gxZCQ9o/KxZLxQrhSi1cPGu/blNoFrjnY+XhcFskxMOZBNopFV?=
 =?us-ascii?Q?3UX8YTKOrclwxjaxxzJ/FlntIyfvIXCZD+O13EeL8qZ1mYi766Ypn83MGsEU?=
 =?us-ascii?Q?ffxZP4Qsmqasj8wQ678ZSOdCc3QuXkRJJ2mmnmTnqVCYaRDGlAr5TbQ1XxJS?=
 =?us-ascii?Q?ZBoYR74nTnT/SrgUm+c/LcCYCMrLZMwpNl2WdEnXCE6DPFKRaNu3Ig8q7Hkw?=
 =?us-ascii?Q?LPcErQ2qV2yBcpUPPwyVWc/AOrliZwUVcf55g2adppvSmUXTB6yPHULvpZBk?=
 =?us-ascii?Q?7FVQ/Y/zsTF5XfXuxuZa6lLBrcaHF+WZnv15+4ndn8RozqfzDXm0urBdqw5l?=
 =?us-ascii?Q?b3X4DZNt6p5DcrWwlGJwbILop5clczE7bgUbrZjS7UyTlkqqJeABs79IkHrO?=
 =?us-ascii?Q?HGlgrsIruioujpn3bk5MgrSIYfo20BhIpm8vMrbCdAwv+wL+DsqDck+wjXiF?=
 =?us-ascii?Q?OD14E7L0DhDj60GoBPxhRB0MhitLOcmBP8nzQxN18VyEhdR5uKAwSk9IGMzA?=
 =?us-ascii?Q?0Rbx7c6ysISPbAJBhQVITr4TD2BZKr4fx+bRCs1Z5Gyx4PheJojZFcrckQ54?=
 =?us-ascii?Q?/kKipygSIj/szVVU7zNbbn92o5JkBqNWnu56gBu5+kv5euzYg7vM33pItxug?=
 =?us-ascii?Q?eZNNkKopapfh7aVEfu0pQMtfvpGoZm9QtZp9XR8kdO8HLg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xOoCAMHSZ1VA2sWX+RygatLq1OoRhrUiJSnRL2Qg67RJiYSRo5Dk9iPvE6Zl?=
 =?us-ascii?Q?hczY03TKFuNTTtWPvVoCY/CVii9T7Z4GTzusb1uwI2QlkGfBlEkl7BdjasIc?=
 =?us-ascii?Q?EY4FyIpp/VsQof4e/LI8gHgMr1xHlUOdHcYxRRVlEd1E6ymU02mB8IPWVyy3?=
 =?us-ascii?Q?vLiVc//yTwfvz/ShCYRzMKoX35HSww/LiS/i8g6zai5cU0MciCaIyC/3dSCz?=
 =?us-ascii?Q?f0/w63riRLzy22vz3qrr57X6qdsBzf5Oi0hT60jPjpU+eI9WUlJHOFeMo3QF?=
 =?us-ascii?Q?hZOWECLyrlh0tY7Tmb/ZyzceP3T9lV7btTQ/FobojTggZ+c2IH5ttahxWIKN?=
 =?us-ascii?Q?2xCFJjdsWb7s5K5jeaZCiuh0ePHbvAwfHNy56YMxoohIXxMjXn9bJWyDKsjh?=
 =?us-ascii?Q?438FJkdlaMBXCnqSONWHeRSr3LKKOu7HHamHmV3gphq8ttMdhFydWBtSAOCJ?=
 =?us-ascii?Q?iJhJYcv+qH1c7apoJ7S/OO9kuDTGrt5UbemS9xfPbMEZPUsBnYLUiL1Hbn7U?=
 =?us-ascii?Q?nIUllPbhb1eOfHf+WQ57Y7uy8Q1UWxZtOU4uXGnSlAIuFFAZRevvrb4f3Xqk?=
 =?us-ascii?Q?yr4IDQTbRtsJD0S/eC8ZkrIEyd+DhNTTuA8hY9LW81vzGjzjp5uk4AEUukyt?=
 =?us-ascii?Q?P++yB9ftAF/9VCDQp2CamvW5ZXNhnj/YzyMJa6F7NmP39M00OMLgp71QPHMU?=
 =?us-ascii?Q?4LNOsQ6KGd1c5zz341ICSibhhK/BUpE3/OCN2SJce3TTZbcYGoJSKbKlSYhT?=
 =?us-ascii?Q?YfjVpuET8LBspdsV1grqdth/Y5TPyAqssh6m8wJXogDOJc5+9C/4Phpqdrjt?=
 =?us-ascii?Q?muZctlF27Apr3rbT3E7dtPakaYdZkvJrpBbtVXhkN8IygvegkgtrVPJEhRcz?=
 =?us-ascii?Q?oDSWH6xCXExrshXjNE2q2XHTowRp/K+jBO8oyLMpQPDs4P52QyzEI8PrdcDr?=
 =?us-ascii?Q?yp77qdPDH9zpFrY4B+AEmL7RgfJTJSBSeyTmKNuKWePDpwob1yG016mvn9Z2?=
 =?us-ascii?Q?6Y2MJB3k1Xr7+lbdBq5LYWlh+JHFQMjYpoYTn6mGpnyiw5ZVISeXglblzo+z?=
 =?us-ascii?Q?odz8R8EDK3pwZbcD9t84vKF79Y8rAAIvwSasemNgXDVCVBpjoAZbQNJsnYDe?=
 =?us-ascii?Q?WEkED9LJv3qEXdxiEE8esWvHww1u9ZpwFUGyb7lNpzWn3Dz8hQHuFmBYBX/C?=
 =?us-ascii?Q?+B+R20j/4vw1S5xskFJho7JPsdLe556jztLa4v4VPbpqPIcp0ozVv5pcWh/U?=
 =?us-ascii?Q?HYToFsUTbkxiMXk7HW6+3yMhTg1rULenbR8aheKr0u4+uZyG/Ia0/S4gSGG7?=
 =?us-ascii?Q?YhSyVfbVYfkd6yGv7ltFYHsNExeWVsNy+8n6m18A0sgFgSmW09Mv85F0iVBI?=
 =?us-ascii?Q?ZaodTVoYedXv4wn3KExWHPEpaCZ01Sofi9MN6/P3485xBKbXnkzoyQhA6Gma?=
 =?us-ascii?Q?jHTl37rgWRFbWfC08bW1WL/xqETBFuIWVj8G5xbgUsSYxK4kuiem6GGAlw6h?=
 =?us-ascii?Q?wSfCkwQqhzKA54XlqPpjZ4fjgvhBAVPtmUxfYvMkozNJKfgwRQuLiATkrY2h?=
 =?us-ascii?Q?dYP14hGKne8kKgyjbH1umlUHsFEhwQ69oNXdk3jV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4983543-8677-472b-0d4e-08dcc207ea63
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:23.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDWi53X1PVUBNJl3j8aQhyZXwpwClwEkpVyF2t8BHnyAcnK1BqSPk9IkjBujOAEt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9017

All the page table memory should be allocated/free within the io_pgtable
struct. The v2 path is already doing this, make it consistent.

It is hard to see but the free of the root in protection_domain_free() is
a NOP on the success path because v1_free_pgtable() does
amd_iommu_domain_clr_pt_root().

The root memory is already freed because free_sub_pt() put it on the
freelist. The free path in protection_domain_free() is only used during
error unwind of protection_domain_alloc().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c |  8 ++++++--
 drivers/iommu/amd/iommu.c      | 21 ++-------------------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 1074ee25064d06..05aed3cb46f1bf 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -574,20 +574,24 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
 	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
+	iommu_put_pages_list(&freelist);
 
 	/* Update data structure */
 	amd_iommu_domain_clr_pt_root(dom);
 
 	/* Make changes visible to IOMMUs */
 	amd_iommu_domain_update(dom);
-
-	iommu_put_pages_list(&freelist);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 
+	pgtable->root = iommu_alloc_page(GFP_KERNEL);
+	if (!pgtable->root)
+		return NULL;
+	pgtable->mode = PAGE_MODE_3_LEVEL;
+
 	cfg->pgsize_bitmap  = AMD_IOMMU_PGSIZES;
 	cfg->ias            = IOMMU_IN_ADDR_BIT_SIZE;
 	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b19e8c0f48fa25..b42e695af6dbe9 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -52,8 +52,6 @@
 #define HT_RANGE_START		(0xfd00000000ULL)
 #define HT_RANGE_END		(0xffffffffffULL)
 
-#define DEFAULT_PGTABLE_LEVEL	PAGE_MODE_3_LEVEL
-
 static DEFINE_SPINLOCK(pd_bitmap_lock);
 
 LIST_HEAD(ioapic_map);
@@ -2265,30 +2263,15 @@ void protection_domain_free(struct protection_domain *domain)
 	if (domain->iop.pgtbl_cfg.tlb)
 		free_io_pgtable_ops(&domain->iop.iop.ops);
 
-	if (domain->iop.root)
-		iommu_free_page(domain->iop.root);
-
 	if (domain->id)
 		domain_id_free(domain->id);
 
 	kfree(domain);
 }
 
-static int protection_domain_init_v1(struct protection_domain *domain, int mode)
+static int protection_domain_init_v1(struct protection_domain *domain)
 {
-	u64 *pt_root = NULL;
-
-	BUG_ON(mode < PAGE_MODE_NONE || mode > PAGE_MODE_6_LEVEL);
-
-	if (mode != PAGE_MODE_NONE) {
-		pt_root = iommu_alloc_page(GFP_KERNEL);
-		if (!pt_root)
-			return -ENOMEM;
-	}
-
 	domain->pd_mode = PD_MODE_V1;
-	amd_iommu_domain_set_pgtable(domain, pt_root, mode);
-
 	return 0;
 }
 
@@ -2341,7 +2324,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 
 	switch (pgtable) {
 	case AMD_IOMMU_V1:
-		ret = protection_domain_init_v1(domain, DEFAULT_PGTABLE_LEVEL);
+		ret = protection_domain_init_v1(domain);
 		break;
 	case AMD_IOMMU_V2:
 		ret = protection_domain_init_v2(domain);
-- 
2.46.0

