Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B63D7D06E;
	Mon,  4 Mar 2024 23:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595880; cv=fail; b=BwB8Ew17lMgkkk4DkRsIsScylQVCqQI8B66jASjqKS610xjH7eNWC8ziNrueOvhu9BrKALZj2q+6cPz/anr3ZADvl5n0T9UCvp8nsM0pY2cuYCuDzJUkkAp7i6tS2N+XAqGmr8h4XGpQywt5ti/mqHd2Wdf38tKX5Pom+RhNyyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595880; c=relaxed/simple;
	bh=19OaOJnGWlQuxNE7HoxYP9aqwC27pjDjkB5x6iEq6Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XWXNDKHDo/nksdIPWmOd7aO07TMg1I9QWSC1zIXPZ1wgLkv6EX9npBdulVHXwODvjGN7kQj0qdefjDLnCMmxKKneiSfqrDD9cN6l8rHxn3mxQL4M3OsX8Lp3HTemYMLNGVRVOu4txePcDL2PztuT3KQH3t7v9XvQX4VaQQXv3m0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CWN47uZq; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CWN47uZq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUD75L/YCGpk2GDytcR4TBx4Y8bcrHEMHdpCYXLcUzsRXQIJvtPGm7DHwhNFefFp8vnSxEKe3PTInAhTbBKfjnlq9ltYvrUATs2cBSYIA0zYroHQYxnY/a7IXDL8UJCmPu9wH39ic+/QH8+u34sPavR9sb6nWGUby/TGcfyI0c5K3UNnpXDbsR3nMrGXKtLFkBx9Qbw1coUjxfiqMGo07hPf/9el9M/A0RJRIH4kzoDADKdDRPV5Osp/prDXE7XSGKJ6MKYlqtFuqnsdNr5BrXVneS3JthEO0EoRam5S8GPLhH+lqk/epEWxHwsRYYiM6pEbG3pz/ffxZShiixrZcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6GSDo0qQZHLBbB5G/VYk7teyuJwqcTMTi7Lsx7jrUQ=;
 b=aojzrcPMQ2cwmc6oNb5br/3dCjUZR1Ly5a+twBxGwo9mi/gEuYXCOnJnLGwPXU5/91VpDeCoY9rihqllwMPmLoF3FaaO/6pVj/cJWjiXPk4+LoCVE+lD2hgxsn/2il0Zw0gAcwEtC6coiFsBZ/nUfFwKHUbpAhyXOsxJ08MC0bUD1sAAsj3tO/fRYi+UJJxn++/JOAlP3B247fuj5MLD/59k+8NQMwCR1yq+gWsIzBjHklLhFkMJ7OcUTaQPNGK/0U/I3eyoURRVdtgQJL7kUcke2Ru8M0LfZhKrLUTvMBvUtTwPL9pCzJvLqLpBA0k/29ATq0wkapoS9lPxqoUdxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6GSDo0qQZHLBbB5G/VYk7teyuJwqcTMTi7Lsx7jrUQ=;
 b=CWN47uZqvAtVtB/nWrwLs9ZL7Fon784zdR091SZr+jnsrhyVj9gu8B8VnJhT4usy7Z1ulbIpFyKiDr/1Hy/WYB22N9lrmj6gSzD6qf1MuEjrYUD5xnLGRIIlA9LIKWgJeuKNFrC/WM7R6xFrVGUQAMJGjSOUsjq1NKLuOeEzuRw4wiGhdJqepS0SlWKXHHBcPn7fIJ3RdlLp99XTgueyT3qEm0hmmLiTjdY4WdNhWQtUHLR2IGZ/PPZf7tbA2f+0onXVqzNQBP5ZzDoYG8k5taGzSROeOmo2QevWI0P+0GSwMhgsE0WTwzC8LNdQTLtuy2iUzFTZI22aKMkXGnGB4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v5 14/27] iommu/arm-smmu-v3: Make changing domains be hitless for ATS
Date: Mon,  4 Mar 2024 19:44:02 -0400
Message-ID: <14-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E08.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:5) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 2115c13f-b2f4-4a94-e60a-08dc3ca5021b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gYg7ZAl0DpQG0NLhny0SVSxKhj3FivPUfmORWnNhrxl86rUiCSS9Sex9zTnnzfm6vEEUMIMKsbLvUPffDsUM9y++vRd1tzoMjdr/Y2NrNc7myk4wxPm7eXLARrMMP0Qou8CDlbcKIbrIMTDE+m3PrLarlZDuWS9U+hIETgM1iwJUtxXBLiUSi+PLlg0xxnLLWqeUMG/YJb68+m+AimX4JhTNniScU63bAXqigrIiKwZ4JdZzolPhxc/QrBsERkg/JUzuUYCi1cEmJzQeT7ohWz5OuNMg+PMsaoBKtp/X9D3FOMWvJxX3jipQJCxVgpwil0jeFwJ+GWXS8l9sQ/L5qwwcey6Js3FwGUVOynr7dg4HZzRrMxsUsxxDiqaI2yXEPce/4sWbuST/vokE3qjFzrvvEr5Z6phbtW19kuDQTO0qWUihrSiWE1zWWWk6nHCCBG8X7Ymfde9ImyVl71k0uou4kdnuDgSEF40AiNByW/cUzveYqXfrvgZmt97EIb68yuTmFvegxpXLthCLqRmW/p61lN1r75Qy5quF7g4wWZpTiaz9NRwkn+Jv6gQh+YMtx06gsHjMJ01XkPfgR2+PEzxXx0YO+sDrF1L4g/nzDUsfXGwJX/FKd6RVPEAV3ksPJLZ+WgOzgowoqej99CZEWhiO8C4ecBe6oemugLbR+jM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xAtn7ji48Zl9YHWxWoR+/u1oARexG8XKYBiV/Em0Z+M5XiKtZgTqzs/T+Pex?=
 =?us-ascii?Q?vwj9DWjofZQIn/gVkx1DorGoZECa87660ktDcc2yFg0kwOILzxhsRfb+9Cc1?=
 =?us-ascii?Q?SnXQw/mMU/jitywDz1BwPHsNdFnj+u7z4nm9XKZgtseyc07aDL30Ko6Heetd?=
 =?us-ascii?Q?En4SjPdC1gX7cIoJT44FaIv8B9L2TeVTSu0ab8jKyYByAmrbAFl/mIUcxS6T?=
 =?us-ascii?Q?0yWYWYuxxqExrMkzqo6QbMdAHiBZFv91mP3MBWsByyu5xmY8Sr8IDrn3w2oY?=
 =?us-ascii?Q?7hjNPmR4KpAG1+1khFXC3DUcBNGfvusPLhZy6ZBeaSDVYejoablCSWra3lqC?=
 =?us-ascii?Q?v+2h6mffxuOEPUO3r5VVgwp7jEOMcLvSbPNUQXqX6CcghV/J23fvOitq5dg+?=
 =?us-ascii?Q?iHsaRcs3Y8h3I6NTTJL3Z56RVnfbCfUcGwI0Kcsy6Njs84oAGemSAVg6oBMe?=
 =?us-ascii?Q?fTMkyxI7Pf/hI5RzDOptFVNX821yzQNobLJH/Hhfs/zR6qqStvKpDsS3HZMW?=
 =?us-ascii?Q?/66DuaGXxUn3wzItPlLKBPzGP+/U7pFSyRvrWxRBTYMmmsywFxNDu1yVI30j?=
 =?us-ascii?Q?m2VGALo18CGx+p0YycLwk1M3DH6F+uio10W8tnqEaWc0ChmQ7Sn0xAUg7tGI?=
 =?us-ascii?Q?ocHoIgVRC9supvRlpXCu6GKwFrqIvIKak2OQ1Spieavr+jUm0QuLGt1FFQq6?=
 =?us-ascii?Q?V6ZJxqxBaiDRRJEdbqfRjxCdm8z7gzKel29CaZ66PQm9gj0bf6BGGFtQF4hn?=
 =?us-ascii?Q?vhu9ixAObc2U8HYiBx6MvX2CmRE7dh1ZO07MITDtJfKHT3kdFPIkTrSg4uRw?=
 =?us-ascii?Q?8a5c3hI5mYXenWw1JHcD8cqnxToQ9j2jx+SeyFnn8pe7fSpSd9uBzdeWJJ89?=
 =?us-ascii?Q?ucDHCSdxt0civ7I0SX+lB8aSE7Y4U8MX5YEltnE+5cjXLaZ8mPdSisETYsd1?=
 =?us-ascii?Q?LbWSrMGQfabVDl1xGkUjpsAnoJb2frXB5nYsZd3vx3oEm5ijZa5XBM4GZxZ3?=
 =?us-ascii?Q?5J4mBmY/i3e9fh6RebjKJmS6fF0stESamNQ+pumIVXpTnEIlks1x7TD3X5l9?=
 =?us-ascii?Q?OCqqVObAp2jOcw1Hyu2aUARblLZCsuveyDWDLE8O0IqZrWf4a8CCiGn9r1lt?=
 =?us-ascii?Q?AFsSztArZHZKRKinNk4ZwKrkcmghGorWTJRMtLJaUNahBEVvjkoR0GJ1WF1A?=
 =?us-ascii?Q?TcYHJMw91lt/Nn+ViKroaydt78QuSpQPwcdn6Wqp56mHWzQICbvClRhyB/il?=
 =?us-ascii?Q?B9FfYBngsGBuZoPMbrCl2qtVIKympLHiTI/xGAzhUlBILcl6kDA0e8M0zqQA?=
 =?us-ascii?Q?TXja+l4o9gcY7hkGz2aBHMKiZt8syyPwqz4t5FXhmabaf6SiW+hgqeLMY6Dp?=
 =?us-ascii?Q?uIwMQ1wzcIOoTEz6oqPcbHTSrtPDZMJVkyLbilPXxu0vIvjLfhquLC3O4+Vd?=
 =?us-ascii?Q?fzQ5aFmH8NFmjfqyhTqdMLOzm4JEDsGMsyANDfxcU5BKM+zV9+1jzy7wbYjy?=
 =?us-ascii?Q?pgaD1Y72st8K7ReyGGxPFDavITk1+9MH9gkq+T6vfLgCQf9nRlR93svWZOSR?=
 =?us-ascii?Q?NuTdzGFvq1kDg0jAVvtaJikN1NlvhKQVDmydX6yN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2115c13f-b2f4-4a94-e60a-08dc3ca5021b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:18.3946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxOe8JZ53mZsw1jnqzvL15NVkBh/JWtYvJZn6096FSaqmVc25gyWUR6MTQrc1IaK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

The core code allows the domain to be changed on the fly without a forced
stop in BLOCKED/IDENTITY. In this flow the driver should just continually
maintain the ATS with no change while the STE is updated.

ATS relies on a linked list smmu_domain->devices to keep track of which
masters have the domain programmed, but this list is also used by
arm_smmu_share_asid(), unrelated to ats.

Create two new functions to encapsulate this combined logic:
 arm_smmu_attach_prepare()
 <caller generates and sets the STE>
 arm_smmu_attach_commit()

The two functions can sequence both enabling ATS and disabling across
the STE store. Have every update of the STE use this sequence.

Installing a S1/S2 domain always enables the ATS if the PCIe device
supports it.

The enable flow is now ordered differently to allow it to be hitless:

  1) Add the master to the new smmu_domain->devices list
  2) Program the STE
  3) Enable ATS at PCIe
  4) Remove the master from the old smmu_domain

This flow ensures that invalidations to either domain will generate an ATC
invalidation to the device while the STE is being switched. Thus we don't
need to turn off the ATS anymore for correctness.

The disable flow is the reverse:
 1) Disable ATS at PCIe
 2) Program the STE
 3) Invalidate the ATC
 4) Remove the master from the old smmu_domain

Move the nr_ats_masters adjustments to be close to the list
manipulations. It is a count of the number of ATS enabled masters
currently in the list. This is stricly before and after the STE/CD are
revised, and done under the list's spin_lock.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 198 ++++++++++++++------
 1 file changed, 140 insertions(+), 58 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 51a1e7198fd1af..45f2190fc31786 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1527,7 +1527,8 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 }
 
 static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-				      struct arm_smmu_master *master)
+				      struct arm_smmu_master *master,
+				      bool ats_enabled)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1550,7 +1551,7 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			 STRTAB_STE_1_S1STALLD :
 			 0) |
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	if (smmu->features & ARM_SMMU_FEAT_E2H) {
 		/*
@@ -1578,7 +1579,8 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 
 static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 					struct arm_smmu_master *master,
-					struct arm_smmu_domain *smmu_domain)
+					struct arm_smmu_domain *smmu_domain,
+					bool ats_enabled)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
@@ -1594,7 +1596,7 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 
 	target->data[1] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
 		FIELD_PREP(STRTAB_STE_1_SHCFG,
 			   STRTAB_STE_1_SHCFG_INCOMING));
 
@@ -2470,22 +2472,16 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
 	return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
 }
 
-static void arm_smmu_enable_ats(struct arm_smmu_master *master,
-				struct arm_smmu_domain *smmu_domain)
+static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 {
 	size_t stu;
 	struct pci_dev *pdev;
 	struct arm_smmu_device *smmu = master->smmu;
 
-	/* Don't enable ATS at the endpoint if it's not enabled in the STE */
-	if (!master->ats_enabled)
-		return;
-
 	/* Smallest Translation Unit: log2 of the smallest supported granule */
 	stu = __ffs(smmu->pgsize_bitmap);
 	pdev = to_pci_dev(master->dev);
 
-	atomic_inc(&smmu_domain->nr_ats_masters);
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
@@ -2494,22 +2490,6 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
 
-static void arm_smmu_disable_ats(struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
-{
-	if (!master->ats_enabled)
-		return;
-
-	pci_disable_ats(to_pci_dev(master->dev));
-	/*
-	 * Ensure ATS is disabled at the endpoint before we issue the
-	 * ATC invalidation via the SMMU.
-	 */
-	wmb();
-	arm_smmu_atc_inv_master(master);
-	atomic_dec(&smmu_domain->nr_ats_masters);
-}
-
 static int arm_smmu_enable_pasid(struct arm_smmu_master *master)
 {
 	int ret;
@@ -2573,39 +2553,145 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	return NULL;
 }
 
-static void arm_smmu_detach_dev(struct arm_smmu_master *master)
+/*
+ * If the domain uses the smmu_domain->devices list return the arm_smmu_domain
+ * structure, otherwise NULL. These domains track attached devices so they can
+ * issue invalidations.
+ */
+static struct arm_smmu_domain *
+to_smmu_domain_devices(struct iommu_domain *domain)
 {
-	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	/* The domain can be NULL only when processing the first attach */
+	if (!domain)
+		return NULL;
+	if (domain->type & __IOMMU_DOMAIN_PAGING)
+		return to_smmu_domain(domain);
+	return NULL;
+}
+
+static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
+					  struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
-	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
+	if (!smmu_domain)
 		return;
 
-	smmu_domain = to_smmu_domain(domain);
-	arm_smmu_disable_ats(master, smmu_domain);
-
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
+		if (master->ats_enabled)
+			atomic_dec(&smmu_domain->nr_ats_masters);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
 
-	master->ats_enabled = false;
+struct attach_state {
+	bool want_ats;
+	bool disable_ats;
+};
+
+/*
+ * Prepare to attach a domain to a master. If disable_ats is not set this will
+ * turn on ATS if supported. smmu_domain can be NULL if the domain being
+ * attached does not have a page table and does not require invalidation
+ * tracking.
+ */
+static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
+				   struct iommu_domain *domain,
+				   struct attach_state *state)
+{
+	struct arm_smmu_domain *smmu_domain =
+		to_smmu_domain_devices(domain);
+	struct arm_smmu_master_domain *master_domain;
+	unsigned long flags;
+
+	/*
+	 * arm_smmu_share_asid() must not see two domains pointing to the same
+	 * arm_smmu_master_domain contents otherwise it could randomly write one
+	 * or the other to the CD.
+	 */
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	state->want_ats = !state->disable_ats && arm_smmu_ats_supported(master);
+
+	if (smmu_domain) {
+		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+		if (!master_domain)
+			return -ENOMEM;
+		master_domain->master = master;
+
+		/*
+		 * During prepare we want the current smmu_domain and new
+		 * smmu_domain to be in the devices list before we change any
+		 * HW. This ensures that both domains will send ATS
+		 * invalidations to the master until we are done.
+		 *
+		 * It is tempting to make this list only track masters that are
+		 * using ATS, but arm_smmu_share_asid() also uses this to change
+		 * the ASID of a domain, unrelated to ATS.
+		 *
+		 * Notice if we are re-attaching the same domain then the list
+		 * will have two identical entries and commit will remove only
+		 * one of them.
+		 */
+		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		if (state->want_ats)
+			atomic_inc(&smmu_domain->nr_ats_masters);
+		list_add(&master_domain->devices_elm, &smmu_domain->devices);
+		spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	}
+
+	if (!state->want_ats && master->ats_enabled) {
+		pci_disable_ats(to_pci_dev(master->dev));
+		/*
+		 * This is probably overkill, but the config write for disabling
+		 * ATS should complete before the STE is configured to generate
+		 * UR to avoid AER noise.
+		 */
+		wmb();
+	}
+	return 0;
+}
+
+/*
+ * Commit is done after the STE/CD are configured with the EATS setting. It
+ * completes synchronizing the PCI device's ATC and finishes manipulating the
+ * smmu_domain->devices list.
+ */
+static void arm_smmu_attach_commit(struct arm_smmu_master *master,
+				   struct attach_state *state)
+{
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (state->want_ats && !master->ats_enabled) {
+		arm_smmu_enable_ats(master);
+	} else if (master->ats_enabled) {
+		/*
+		 * The translation has changed, flush the ATC. At this point the
+		 * SMMU is translating for the new domain and both the old&new
+		 * domain will issue invalidations.
+		 */
+		arm_smmu_atc_inv_master(master);
+	}
+	master->ats_enabled = state->want_ats;
+
+	arm_smmu_remove_master_domain(master,
+				      iommu_get_domain_for_dev(master->dev));
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
-	unsigned long flags;
 	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_master_domain *master_domain;
+	struct attach_state state = {};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2642,11 +2728,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
-	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
-	if (!master_domain)
-		return -ENOMEM;
-	master_domain->master = master;
-
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2655,13 +2736,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	arm_smmu_detach_dev(master);
-
-	master->ats_enabled = arm_smmu_ats_supported(master);
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master_domain->devices_elm, &smmu_domain->devices);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret = arm_smmu_attach_prepare(master, domain, &state);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
@@ -2670,18 +2749,19 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master);
+		arm_smmu_make_cdtable_ste(&target, master, state.want_ats);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
 	case ARM_SMMU_DOMAIN_S2:
-		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
+					    state.want_ats);
 		arm_smmu_install_ste_for_dev(master, &target);
 		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
-	arm_smmu_enable_ats(master, smmu_domain);
+	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
 	return 0;
 }
@@ -2715,10 +2795,11 @@ void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 	arm_smmu_clear_cd(master, pasid);
 }
 
-static int arm_smmu_attach_dev_ste(struct device *dev,
-				   struct arm_smmu_ste *ste)
+static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				   struct device *dev, struct arm_smmu_ste *ste)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct attach_state state = {};
 
 	if (arm_smmu_master_sva_enabled(master))
 		return -EBUSY;
@@ -2736,9 +2817,10 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
 	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
 	 */
-	arm_smmu_detach_dev(master);
-
+	state.disable_ats = true;
+	arm_smmu_attach_prepare(master, domain, &state);
 	arm_smmu_install_ste_for_dev(master, ste);
+	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
 
 	/*
@@ -2756,7 +2838,7 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_bypass_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2774,7 +2856,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
-- 
2.43.2

