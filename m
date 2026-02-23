Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011063.outbound.protection.outlook.com [52.101.62.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E457377573;
	Mon, 23 Feb 2026 20:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878537; cv=fail; b=c/OpUpI4dMbK74DclboLh0bMXWiJz2UclXKSGHdM8IYcGHLFDCw0qEoZ83UAjtxd9YkXBf13xn+AI+bbk+z/pmHVBlBAGkTvonnuKmDLgf1MLWsxJSCtwY4J03rZk3jx6VP/6nMS+4W6aK+1e/LfQTZP81IuE2twreHRCTUPCpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878537; c=relaxed/simple;
	bh=YX7GS/+jItuBBS0xdVetcKrASMAEbWTo7q55LUd5nac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9QQeHVllQOOpm3ek2K/jt02eIxWQgHU35et+mrGGjcwToVAP7qt62OpvMoOLBnWoM09dLbH0fo6csxwrMqbuGCEay0jxRnmy6mr9Tem5A9FS7DJfCzfqO6aXVybIyM4Oe9B9Av7LA+2j9LnkgQFg0A31BKfIXi1ka5t7e/ViL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JqlYCVMz; arc=fail smtp.client-ip=52.101.62.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JqlYCVMz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vOB/YSCxLNEuPmEfnpv7YEwuzeGyLZX5yzKbic7PyYnLt8pVdjEG/jDqiKLS09rOgrlPs9WjiWyxoFUl9fp/TzkvdfuO0861nbz0wN2P5bObb29tW/CaKBmH5baUR44QNtTAUirVtWiufdaI5aqR3X9x5MVMxsQOVFp1+6tT2pk6B8kyGDmBGMz6Ue1N4TBWhhAEn14/qvOhduaVPk8jM/zjZ2FDPeuSkkoJfabxPbvKLg59CiRN88MeZFl10ETDXX2FhbgLNuerOgO94BRH/O7dtIIniOvh90Abgwwmno78YfRVEJGyD7YD1Oh3RGjmtvNTNUN6iEFGgypTtAeW1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfCZZG3W6Lo3huPgL51r4+BgTt8juKTleUHK5t2NxT8=;
 b=wmyYxaopTw4hSsbh5YD40nkL2YI5kmgP88LuARwglTi8K/+xaGHC71a5dsrk0MLRoY4HyI8G+sohFVDwEgSwp+9J8qkw25vGdZWdacHjnfGxL/SKB+WEOhoPr7hHLAAn3UezW90UqxOI9E4IThTQ8J0Kj90fsnN9oV6HOhuIG93QNN9nOexTSuMYVyVSWUgG6De86ts3YbgVQe73sYANDCPvR5gj02vgfmuYbEAWBqnnErmAkv3gn2Y8InKGArbPi+7w5dxOsJALcgZPCCH8B96J7vWS7udNrxjzRLxt6xekaH6OHtkHbqK48YahIF3JMSfIQ5ZXh7Wz/yHqnSqWHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfCZZG3W6Lo3huPgL51r4+BgTt8juKTleUHK5t2NxT8=;
 b=JqlYCVMzaKq2WYJViL8PZsG1GjGk+EGkFIxt1TD3N8JaO5CjZyvJ6IemDPTBsDdNHqt5WQajl0kRzYAhFs24uneSFY6ZrViNfJPjpkoTaw0QvKnQu0Y3W9KTC8o2DdcrGxxTk4YB6mRJVCnVFVNteDX0Ydu/qBAjK62a1iHQYMHx3KOIjv40V0/SLfsLOVBxWUQk0s8U6RxLzEcaEU/gmblajTT/PwCLgBB++FWjs1DRgmmYV6jpDV5SQX/Y365f2hMbSe3BLkg7VBcagjjAooB7B3nOJYbWvPX29BOGhVxHwTdN/wxYXXv671V80EIbBB0ByG3osSdP8zwbSsqpMw==
Received: from CH2PR10CA0020.namprd10.prod.outlook.com (2603:10b6:610:4c::30)
 by BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:28:48 +0000
Received: from CH3PEPF00000010.namprd04.prod.outlook.com
 (2603:10b6:610:4c:cafe::ac) by CH2PR10CA0020.outlook.office365.com
 (2603:10b6:610:4c::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 20:28:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF00000010.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:30 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:29 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:29 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 09/10] iommu/arm-smmu-v3: Remove ASID/VMID from arm_smmu_domain
Date: Mon, 23 Feb 2026 12:27:45 -0800
Message-ID: <31785d893e906a177bd4695552c0ea37c1a0b269.1771877893.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771877893.git.nicolinc@nvidia.com>
References: <cover.1771877893.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000010:EE_|BL1PR12MB5825:EE_
X-MS-Office365-Filtering-Correlation-Id: d6e571a7-fca2-4266-b75a-08de731a2631
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qQ0M+bOnsM0A0DIVbETT2Y7ZZOw4Gz14vg3SromDFBQ1zsVTvms5bF8UHErl?=
 =?us-ascii?Q?fxLI8aZnJKUZQ/o/Z0K6YiKXZsTYDGCsySAJzb/PZokNTRvk3UG5Ta4+RjCP?=
 =?us-ascii?Q?7fYiYXcrLHpJZReob4QB2hnHLnOi1XEiGOOc3qUGaimbCArpW07nyBUS6gj+?=
 =?us-ascii?Q?/NVDxZ3PtY3ISqXn+nqBz0gFWwXJ8MxZmKvOHt4gJCGwJSwXUSQGeuQAW/LA?=
 =?us-ascii?Q?xLef8u7v+dnrAYAhpkEnhnlDRdDDJ+eoMJDyCWDyoZKcaTLe+67fwZdnuzk9?=
 =?us-ascii?Q?KOSkCzc1ZMOBpyyFS59H8auy8jzIW8gRTfQnK7uqiKzKBpe4DE7bPrOY7Cc6?=
 =?us-ascii?Q?7gTDz4L6F30xiAXx/C56bzzl67+9kiATq1M+1+xBbiPPK2WDZAEpSHSjFjeO?=
 =?us-ascii?Q?xCgLPkzEkKO8/AWDBZuUstvdcKSx2MDmO+/6cOLMRNNrdxBVWscrBCs94/BB?=
 =?us-ascii?Q?Ez+2r1BY0p1nYVmy7NCslskUPs8o/q5vOdqf2Of9nLnU0qVUqFJf53m+cXrA?=
 =?us-ascii?Q?Zo2KEdQQ+Rpw8VKn8jx6WyRJ/j6twd4cO3R9dgFM7ha4A94vv515NaOx+I/A?=
 =?us-ascii?Q?L4nXAIjTzbTk4PNLek+AHPmRwm5/Rc4B+xDo7JUkt7AjIn9Ysc/59tNmyJNo?=
 =?us-ascii?Q?78umYFoKXkc3SQO8gAwCUzP7kXsCI1IIogbhKL3UFVZvIQv0SdeOLKgcWfWV?=
 =?us-ascii?Q?RRqjhr1bs9/gMz1EEKxAv80OIGfFKaN9xJ4SKQm0/1yd+jvt4oG8woU7i093?=
 =?us-ascii?Q?j5hAooWy/vq26PGn/M7gAbL6V2bya6BmRFDV2jj/NRKfFn629wSW3X30UWrn?=
 =?us-ascii?Q?GBT2yST83Tggn2IfkoQCcvQ+LNiX+bUzMiyNelllg+Z50pDsBsGMY8n6sWlj?=
 =?us-ascii?Q?eI9MkWRtHv7yym7Ta5TTginjJJK/evTXkbbiTPMFjqpRBA6L+schiijmWKiB?=
 =?us-ascii?Q?E7iQQRe11k++BUmmSfpeyy5t1sgDzDZeJ5Xi6gar8p/SEK65yeVKg/N1QdlK?=
 =?us-ascii?Q?yYHAYOu88KV9Fk6flccIjQVbfaxYYI3kkwI7+D7BO/n454US0Hb2Yvj22VqB?=
 =?us-ascii?Q?/kPVYbesD0+nFCZl/Gy4JwkizSKp7/gOdtTHeHtR4t6F3ZvdHGMLlUtWFg8Z?=
 =?us-ascii?Q?JXQdgawGWnYmZZCUZG5AK5Xl09OlUDcXdfy7T3P1G1YJFSlyoBE4wUB+dleh?=
 =?us-ascii?Q?IgngKZblEnRORZXxxzUG5P9T3kioFZmwEU7vmN3D8NsJuuEGrYRswkW8ch//?=
 =?us-ascii?Q?pbaz7ZnnBxNkPev5zpRzKJ7wRF7jy+KfduYs+fNDlGrKJshw9GGRq1O3fbBg?=
 =?us-ascii?Q?kqipW2QG006MRBQB//PV5NSP93uGtOrNX22kUV8P9D5OvIr2tnwl20169Jbx?=
 =?us-ascii?Q?sbmJ5wO6CWvqE7VFPsHBPzZ3HlnifD45t7VuzEpCrsBQBa0XNEA8gjYEqNFL?=
 =?us-ascii?Q?a8/aydNHbCBRuhaynytepECdktcgd0ecwwWkvTytgm3jMoJs4Ltq0Yn6E8Ff?=
 =?us-ascii?Q?3eZKXPEdLz0CDYwltp61Fiw0j0qcv0H74hJog7/HwPlb2m+FE7R/GnbDk79s?=
 =?us-ascii?Q?F1rbfZ2KRzxpwoL/s/6Vey7Jjd9Alzu+nLkUMisT7A7E/SvTXB0sK8jAIlNA?=
 =?us-ascii?Q?eqng1z7KQtRyX3VZUXzxNrbgLHh94zHlM/RHwI9Te9AA1UDIOimYP5C8mrte?=
 =?us-ascii?Q?ZxblMQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YC+g0Bx/JhcyM/pRipx1Rr6qh8/ZvK6kUh1Gg5f47Q2eln7w42twlNMhOIHxwCTSwrE0r7zDRh91AU9YwvY9wtbOMScaq4iul6hOCfBB+mZKV+rPqCp/y2gNoOLd/a3Lfm9qrmop4wA5kK8mTPEUiYuhBAkyYVwoAdJJyV4Hexa/gRl1xtctaTMKf+fEqYClzoEFxfUisD8zNtfdEAZzkSIa3KwWGIa4PeIXm6ZuMK44Y71miBp2Rnk1GRnyDOKXFC4QcJwyC3Xoi8lVyHWfXX0RdbNUElrmgwCJBsWyTNpy/kZ/WLR8qOFh29BwCY2024emp2IywNuefNjSfBGSg1FfHDyKQX8IckG2Fb3y+XZfPq4HTxAfcKdsO1kuggDMmBdzt1Q5LIA2+nEGgzE6dO7L2UYQyAT2TEn8LkL0VT9h8f0Z2PRoNdvnTq95egdJ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:47.8783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e571a7-fca2-4266-b75a-08de731a2631
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000010.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825

Now ASID/VMID are stored in the arm_smmu_master. These are dead code now.

Remove all.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 ---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 20 +------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  3 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 58 -------------------
 4 files changed, 1 insertion(+), 88 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index db6568f1b2dd6..e0832b191a2a6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -790,10 +790,6 @@ static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
 	return cd_table->used_ssids;
 }
 
-struct arm_smmu_s2_cfg {
-	u16				vmid;
-};
-
 struct arm_smmu_strtab_cfg {
 	union {
 		struct {
@@ -969,10 +965,6 @@ struct arm_smmu_domain {
 	atomic_t			nr_ats_masters;
 
 	enum arm_smmu_domain_stage	stage;
-	union {
-		struct arm_smmu_ctx_desc	cd;
-		struct arm_smmu_s2_cfg		s2_cfg;
-	};
 
 	struct iommu_domain		domain;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 846a278fa5469..0e48264ccd01b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -300,14 +300,6 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 	 */
 	arm_smmu_domain_inv(smmu_domain);
 
-	/*
-	 * Notice that the arm_smmu_mm_arch_invalidate_secondary_tlbs op can
-	 * still be called/running at this point. We allow the ASID to be
-	 * reused, and if there is a race then it just suffers harmless
-	 * unnecessary invalidation.
-	 */
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
-
 	/*
 	 * Actual free is defered to the SRCU callback
 	 * arm_smmu_mmu_notifier_free()
@@ -326,7 +318,6 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
-	u32 asid;
 	int ret;
 
 	if (!(master->smmu->features & ARM_SMMU_FEAT_SVA))
@@ -345,22 +336,13 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
 	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
 	smmu_domain->smmu = smmu;
-
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	if (ret)
-		goto err_free;
-
-	smmu_domain->cd.asid = asid;
 	smmu_domain->mmu_notifier.ops = &arm_smmu_mmu_notifier_ops;
 	ret = mmu_notifier_register(&smmu_domain->mmu_notifier, mm);
 	if (ret)
-		goto err_asid;
+		goto err_free;
 
 	return &smmu_domain->domain;
 
-err_asid:
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 err_free:
 	arm_smmu_domain_free(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index c0cdded058fc8..d7f39313c6b34 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -502,9 +502,6 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 	struct io_pgtable io_pgtable = {};
 	struct arm_smmu_domain smmu_domain = {
 		.pgtbl_ops = &io_pgtable.ops,
-		.cd = {
-			.asid = asid,
-		},
 	};
 	struct arm_smmu_inv tag = {
 		.type = INV_TYPE_S1_ASID,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9ab904d9d142c..a10da6b8f64d5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2871,66 +2871,17 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
 	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
-
-	/* Free the ASID or VMID */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		/* Prevent SVA from touching the CD while we're freeing it */
-		mutex_lock(&arm_smmu_asid_lock);
-		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
-		mutex_unlock(&arm_smmu_asid_lock);
-	} else {
-		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-		if (cfg->vmid)
-			ida_free(&smmu->vmid_map, cfg->vmid);
-	}
-
 	arm_smmu_domain_free(smmu_domain);
 }
 
-static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain)
-{
-	int ret;
-	u32 asid = 0;
-	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
-
-	/* Prevent SVA from modifying the ASID until it is written to the CD */
-	mutex_lock(&arm_smmu_asid_lock);
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	cd->asid	= (u16)asid;
-	mutex_unlock(&arm_smmu_asid_lock);
-	return ret;
-}
-
-static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain)
-{
-	int vmid;
-	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-
-	/* Reserve VMID 0 for stage-2 bypass STEs */
-	vmid = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
-			       GFP_KERNEL);
-	if (vmid < 0)
-		return vmid;
-
-	cfg->vmid	= (u16)vmid;
-	return 0;
-}
-
 static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu, u32 flags)
 {
-	int ret;
 	enum io_pgtable_fmt fmt;
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
-	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
-				 struct arm_smmu_domain *smmu_domain);
 	bool enable_dirty = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 
 	pgtbl_cfg = (struct io_pgtable_cfg) {
@@ -2950,7 +2901,6 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		if (enable_dirty)
 			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;
 		fmt = ARM_64_LPAE_S1;
-		finalise_stage_fn = arm_smmu_domain_finalise_s1;
 		break;
 	}
 	case ARM_SMMU_DOMAIN_S2:
@@ -2959,7 +2909,6 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		pgtbl_cfg.ias = smmu->oas;
 		pgtbl_cfg.oas = smmu->oas;
 		fmt = ARM_64_LPAE_S2;
-		finalise_stage_fn = arm_smmu_domain_finalise_s2;
 		if ((smmu->features & ARM_SMMU_FEAT_S2FWB) &&
 		    (flags & IOMMU_HWPT_ALLOC_NEST_PARENT))
 			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
@@ -2977,13 +2926,6 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	smmu_domain->domain.geometry.force_aperture = true;
 	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
 		smmu_domain->domain.dirty_ops = &arm_smmu_dirty_ops;
-
-	ret = finalise_stage_fn(smmu, smmu_domain);
-	if (ret < 0) {
-		free_io_pgtable_ops(pgtbl_ops);
-		return ret;
-	}
-
 	smmu_domain->pgtbl_ops = pgtbl_ops;
 	smmu_domain->smmu = smmu;
 	return 0;
-- 
2.43.0

