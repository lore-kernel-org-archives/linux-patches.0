Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0D328B7EA;
	Mon, 30 Jun 2025 15:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295847; cv=fail; b=Ut0+VfKqI8KGkQNHILah8yoCGmwTY4UVxXkpVS7pIV67K3dir3FdPcPaRmplC3LNlvjLgIFYQxRkgzqwFReNpKjBkVko9whcVqzWWPh1JnodRcZ/9D0CTi5KupmGJWg69aFzd4+4eKBEfS2/iCH+tSecFerZaRYcntASiQ4EaLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295847; c=relaxed/simple;
	bh=bHfdo9G5SN34YFPz92dbdCqISNI7BBxG+nqSj0YYmNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XsVYQ7V81yBaNpCNov/lG9eus75k/ENe+bNwxjG1Bi7OcI3qsFXAZbkkZFFHxWVVK7CGvSY73lf0actMuAkWEUbi95ysiMGbRQFK4K3qQ1BMWX6pPldOerGAasiObGhe4txwOyFQl0vdIvwRFkJIEcheFd6RqvRO1tXepxYrj1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JWyPXsb8; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JWyPXsb8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x2cuddjA+Jj2yqs3JOUEnSCvrCeXUvPZXDOiNUFjWeykBLbuW3Ayqr4NX86SY54VDrZn9oqUj7H4Aq01TG7m4MgOLUsutwALrCMIxiFJR/yVRsNpoD98XsI09nB3+EcXD4faDEDxhBlRzq96Ob89uS0dhg7y2k0wuB9D81jsZspkFEOKoJz3tODknn77ZMD11MLyENRHzLooNn+fLtcSPJ3/DmCyqC1thkL0O1bWLdo1JRyuajpEPwtl+llV7L/kzHFKlHKltOhAldPJHWr8HjdB6ENItcLB+WBRDq5XLu17Uv0ih3wCzE7nUENpVcusUSV9BOUjgI4C6ZCwvE+HIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlrrRTgWb+B5no3q9pyj+J5mZl/mvq6muMzt1NbXqHU=;
 b=v2xNK6GL7LMLt0yz5f3gkFgPy1JiespEq2ixhJkv4WssVPgEu8mU6jpe+u0lwjhJBeXN7XzXrVWjoUiNYBFPPuJFxWJ5D+xSBsfQX5Rdt37nMlVv7261iMyGfk08fW2mIOPHWwZqqvuGk3PwPnLy7dcZvEnYOPLSGTZe0bO8JdQCQ5zc715QhMGz9mUxceQ99RzZBuaElsgGbiVzKMTFAPieWoQ/noqsiLVuiP4i4VVTSuOX+k4qumSIUbOScW6U14qJsA5c5Xho+L7ShxFO9FcSSf1kmsUWfRYAgsTKWZcRGjAqfwCnx5W7W7ilJkYtpg4gAFMUqdncYY8Ml67lRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlrrRTgWb+B5no3q9pyj+J5mZl/mvq6muMzt1NbXqHU=;
 b=JWyPXsb8qYwy2PfTTcJVdeB3khMjmToy8zrmclvAgEhQ4E02XVLOKqOPoIITQw75a/rYncbOUGbzfpY6yr0ABslQ2TlrhC3HKodrIBApTk8FGM69y0BcB8AfidGsebkrnAiEb0vJBkLKA24j5uSPjefOBy7lIT29QDG/S9j+efCucqq5TokqNfLg5OweNagF9LzXhW/57ZHB2wS2nooLNOFENrP/k55HQLetrGbutBDMZmAydNugiuCfocqfzRkbxMeyv3k2H5SopUb2eoSAUT2EAM6PTqqqE0wVpci2MC5RHvHyzLTCoWVytxVuCSscvcbYgjtLmcA+FWFZbRdqOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9643.namprd12.prod.outlook.com (2603:10b6:408:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Mon, 30 Jun
 2025 15:04:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 15:04:01 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 6/7] iommu/vt-d: Split intel_iommu_enforce_cache_coherency()
Date: Mon, 30 Jun 2025 12:03:56 -0300
Message-ID: <6-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0063.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::40) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9643:EE_
X-MS-Office365-Filtering-Correlation-Id: ea003ca6-4a99-4485-6502-08ddb7e757ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NaEkNJ5TuRhzn+raEv4BSukd19KuUFgV9AoVY+Lhd8/ZniVq6IgzvOL2LX6y?=
 =?us-ascii?Q?qYsYTni6zBw2tfDaqrSCjkJ9xhPWvDH5cPrpGIiRfghR7MN8MOUz0e3JP8Xk?=
 =?us-ascii?Q?usuTUQRaxah+dhkd9vhPDZ3QtAcDNwrs2DzzgkSgchrmTAJEea3HuoRVM+t3?=
 =?us-ascii?Q?QbKSXo6f3dt2edZITWaC5XrwEIuoqWHuYfxgzonrvgsS+IoqGDLBVpZSvFUN?=
 =?us-ascii?Q?2ta8P0YhtPdl+0I0fWi6tBxBML8UmXrIRwHRI3FFc6uUOHmzZoStwZIdIkCU?=
 =?us-ascii?Q?jFZ/UXnLBRJGA5Iabns6bGPTfl7LgI6LWtIOSdEbtz6U8VDmhLyDC5OvHivo?=
 =?us-ascii?Q?ed/RJIVehUODm1I+FORNuCZaATnzd/kak2bPFUWD81zq6AELc4Veeg/UjCxb?=
 =?us-ascii?Q?IrByJu1/xtrfz8lyf1sYo1LK1nvC9TULrBFKuS3dJQ9PlsM4pkQvYVVAzRA/?=
 =?us-ascii?Q?y/JsJEMc7SNWpnTpiXSBnJKNhrapMscWu6bqXUTVyzE7ySG+D4L4/4Bg1as6?=
 =?us-ascii?Q?bIDfwn03SZO7EXVDNOYyZePfXZ8OdXkibdb9KrX/a3Xv0y90itspTd6GcKlH?=
 =?us-ascii?Q?vut1jONWqefTXXXep7g0pBqajNznyPA8VUg1asdnU85JbpaO8FyU3kp9lmiD?=
 =?us-ascii?Q?AedypgpMmxCFChuS5HgD3r9xf9qhCSjpRuEaJHQH9Eejs9g3dbMTDEQ1ingD?=
 =?us-ascii?Q?t61EUS2qFylXZwtnRd2jQmNLyGBQoo85re4d77DRMS2Vp7twVMpYF+vbQlLX?=
 =?us-ascii?Q?3kmrXcMai9/AdOL8ea6meypF82GK8erIWjEvL+I0QRCuFxrAcqMHm6k1UPx3?=
 =?us-ascii?Q?aBkvdDDtYCCYkwCyqctJNEUws0Ta7tKqbhSaLoo/x/zJfMjP+IoGgxQyQ7wk?=
 =?us-ascii?Q?I1DJ4Du9A2KENygI5gMpWfQyrqUzJzgZxE3/a0WxbXUEmc0ptf2s5dBqvYUG?=
 =?us-ascii?Q?dY5GMbbppXb1r1J4ocmHEL0g7PUFlol0CHzLXqMpBTgsglisvacHvnUQE0oh?=
 =?us-ascii?Q?SBhxzrb5M8iHukRBd3yLffmCFXHHOGSZKTR8mLtpCMGmrbZbUba/WuIgnJ87?=
 =?us-ascii?Q?EAarN/DtXH3tH1fP5K3QXtHB+cCyu9+DcizXWfE9Km3aKanOw6o+vQGkKwdL?=
 =?us-ascii?Q?4mrRD1NcOkSCo0W9pgODiaZRJIt1f8yV1uS3g0Rcb/KCrib8CgqUb8Q740W1?=
 =?us-ascii?Q?9G47Kb779ByKz60X+3Rh0DYEEJfEx3jtFHAi9f1MVJa0YI+8EUfhMQeLn6sy?=
 =?us-ascii?Q?bFXCKka3QVcMgzax4POV/gY46PoOgpB/vUEoVo3t+PsM8EMVNfoXmbFDFBY8?=
 =?us-ascii?Q?HRTsU2rIfJKL4gRSkN7zKbbv+50t+XW9PyUg4GRx01DmNrk6eS6FdGbImax2?=
 =?us-ascii?Q?zxBjPSgKdBqOqREfBfuS0sQyxTlwBP8yKSfQ9MPupUJ4hJDhFA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x3pbeE7yKBNnteeNzxw9eHN0S7LH3h3MOK65dS/wCpb6unDgcN3pFXievWxL?=
 =?us-ascii?Q?DH+3RuIhmtUepMIainJgqyLdfjwxa6BrVOBAfCwxWBxH2zny8UE//jx53FQp?=
 =?us-ascii?Q?5BqTDwlh43h5lvONT8RqrzeJqY1ZtY6am99vWHvORs2UhkJFcs0HX0y04mTA?=
 =?us-ascii?Q?LmT1fyiKC6U1+1lJmr+x94zV6pUN3SaWGtZvJUULLLSNi1VsfuNNlFsQaPQi?=
 =?us-ascii?Q?iSYkfAQDIFDJeQ+srac/Ag4+yaebfQuij/lCrwtUbVi0txAXmJQEvJQZfF/7?=
 =?us-ascii?Q?dOLIfVgr8aTXhyYJFBzgaZSicxcWH9syoegcYaKpFOKnsfI8gWPDlz+E7koh?=
 =?us-ascii?Q?EXSQFE4BFjTXymEd5GcVS+U1G7Qm397UxDWNY8X0rEkqObrkZy8FsDuxXLBu?=
 =?us-ascii?Q?+5FTVA4bE0Pk1AWQEM5qNt8Vx0LGJ2Uw1d50tkm2Jk/xswrLVZLmOf/2/KoC?=
 =?us-ascii?Q?uUAEiHkZv+YzjXev4SJxuNoDQN5F5NQba4IqQUnbohJVNLDm+p36WrOcUMBS?=
 =?us-ascii?Q?XrXRELVOkzHue7M3av6MZgWj1lZlf1M9ZAzvuc2uJpNIuMaR5hfJP91lSGVM?=
 =?us-ascii?Q?4Pb8NNwjkMf4xU4o4GMnJGNtJKQfMlqDXK2+CBKfH40YRqzMpx4vbRwuFkex?=
 =?us-ascii?Q?aTCTI64mW/f1Wdy4SYu9xBEZnm5yop5S535pEamQo0z13YTo3ImvsURRu0P6?=
 =?us-ascii?Q?AD4HueUuZ4koKaeFEYQ+t0QL7UgAJA5u9++fVp06RGLOB4jXpFXYqHJ9fUtv?=
 =?us-ascii?Q?Wwf946+IOOXyRHlKdy1XGhBJRb0w7LKH22wFznNhnJh10VlXCxrOb0DsRKbG?=
 =?us-ascii?Q?hsbZuFmfBjChyJh3Oq6N9MAEdPdk8ZmLPuvOo6Xai/tf4IsGXDpCqN11Onr5?=
 =?us-ascii?Q?vII2pClVQZxR6cv4/J9rUs6hVaU1w6PRKMN6rVjGjV3TLNW7pD/Oeu36sLVW?=
 =?us-ascii?Q?7UGw9Bji8p5ObKBEuGWxARI1h/sTCXsyPkAFRQi5SLAPYUvGZ1WAG22fLPNf?=
 =?us-ascii?Q?d3Ug3X06wxNQaHKy15taUbb4Qpbs4R6VvUAQzqxu95UNAnweu7c7mZllSMyB?=
 =?us-ascii?Q?mOzwvZpkPG1kIpLENieMG4Qxh1Ti9OCNpEWQhnInc9czxvmkmXlbeIwjAhZ8?=
 =?us-ascii?Q?2Alrm1OcAhrq1oz27OKIvpiFiGORjcccWTzQjlbwqMZ+d+kk8FdEZP4ICV9l?=
 =?us-ascii?Q?NJOIH3LE+HHp8vqvoiOLTc9isiEXOfSm23I1BBO+Syp65DvtXomDHpdPvd9f?=
 =?us-ascii?Q?9qwvBCQJn4WjuNp9hGmibqRbnyT0V1SnWe20EWIM6MYKcYsZ+oOXg0S691Rp?=
 =?us-ascii?Q?Pj+az7AYoOk3GZoGiB4bhNQNDgRH6+EoRzOLb6Af9Wzb2IDMcpMdnX/xz2Bf?=
 =?us-ascii?Q?4kgEJXAyZ1BVzbBbwOSHMQ0tceCGUIm/l0PmCjYfUIb2Pw9yj5RGuQkgYOTK?=
 =?us-ascii?Q?MvnTTRo49jgw+vCrR6Y5NDx2hlSJyZGYeHSECKMhkrSrLbPMP+Ob9VDc5VZM?=
 =?us-ascii?Q?46Dv3NCCx1nGRSGQP7z8YoIoNDV4Lsy/awi5gTUN0J+7EgzdG34sVdgEbKVB?=
 =?us-ascii?Q?a+/0jJ6YuhYbeOOzX6cYrOQYvV+ocWsZEp7WmQi5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea003ca6-4a99-4485-6502-08ddb7e757ac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 15:03:59.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UweLunn0e1r16tSNUezXv2VbRZwnETjtMlvVeFoOIYDhvYHdWRoMvSczyt06iRhh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9643

First Stage and Second Stage have very different ways to deny
no-snoop. The first stage uses the PGSNP bit which is global per-PASID so
enabling requires loading new PASID entries for all the attached devices.

Second stage uses a bit per PTE, so enabling just requires telling future
maps to set the bit.

Since we now have two domain ops we can have two functions that can
directly code their required actions instead of a bunch of logic dancing
around use_first_level.

Combine domain_set_force_snooping() into the new functions since they are
the only caller.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 57 ++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d32dc0c301633c..7ac267830bae93 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3629,44 +3629,41 @@ static bool domain_support_force_snooping(struct dmar_domain *domain)
 	return support;
 }
 
-static void domain_set_force_snooping(struct dmar_domain *domain)
-{
-	struct device_domain_info *info;
-
-	assert_spin_locked(&domain->lock);
-	/*
-	 * Second level page table supports per-PTE snoop control. The
-	 * iommu_map() interface will handle this by setting SNP bit.
-	 */
-	if (!domain->use_first_level) {
-		domain->set_pte_snp = true;
-		return;
-	}
-
-	list_for_each_entry(info, &domain->devices, link)
-		intel_pasid_setup_page_snoop_control(info->iommu, info->dev,
-						     IOMMU_NO_PASID);
-}
-
-static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+static bool intel_iommu_enforce_cache_coherency_fs(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	unsigned long flags;
+	struct device_domain_info *info;
+
+	guard(spinlock_irqsave)(&dmar_domain->lock);
 
 	if (dmar_domain->force_snooping)
 		return true;
 
-	spin_lock_irqsave(&dmar_domain->lock, flags);
-	if (!domain_support_force_snooping(dmar_domain) ||
-	    (!dmar_domain->use_first_level && dmar_domain->has_mappings)) {
-		spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	if (!domain_support_force_snooping(dmar_domain))
 		return false;
-	}
 
-	domain_set_force_snooping(dmar_domain);
 	dmar_domain->force_snooping = true;
-	spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	list_for_each_entry(info, &dmar_domain->devices, link)
+		intel_pasid_setup_page_snoop_control(info->iommu, info->dev,
+						     IOMMU_NO_PASID);
+	return true;
+}
 
+static bool intel_iommu_enforce_cache_coherency_ss(struct iommu_domain *domain)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+
+	guard(spinlock_irqsave)(&dmar_domain->lock);
+	if (!domain_support_force_snooping(dmar_domain) ||
+	    dmar_domain->has_mappings)
+		return false;
+
+	/*
+	 * Second level page table supports per-PTE snoop control. The
+	 * iommu_map() interface will handle this by setting SNP bit.
+	 */
+	dmar_domain->set_pte_snp = true;
+	dmar_domain->force_snooping = true;
 	return true;
 }
 
@@ -4381,7 +4378,7 @@ const struct iommu_domain_ops intel_fs_paging_domain_ops = {
 	.iotlb_sync = intel_iommu_tlb_sync,
 	.iova_to_phys = intel_iommu_iova_to_phys,
 	.free = intel_iommu_domain_free,
-	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
+	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency_fs,
 };
 
 const struct iommu_domain_ops intel_ss_paging_domain_ops = {
@@ -4394,7 +4391,7 @@ const struct iommu_domain_ops intel_ss_paging_domain_ops = {
 	.iotlb_sync = intel_iommu_tlb_sync,
 	.iova_to_phys = intel_iommu_iova_to_phys,
 	.free = intel_iommu_domain_free,
-	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
+	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency_ss,
 };
 
 const struct iommu_ops intel_iommu_ops = {
-- 
2.43.0

