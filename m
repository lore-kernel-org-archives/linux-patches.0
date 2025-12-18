Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012061.outbound.protection.outlook.com [40.93.195.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181CA2D3A69;
	Thu, 18 Dec 2025 20:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766089662; cv=fail; b=SVNPAfSgsNI8DF7mJbUmse38cYDKov71uV9k1Ms9AhhWHEIKIfZiSvFZVHlex55NmvUOO/WZab8sHhNcPgiWAfZaX74Y0phglQ4Xog3bgwIyzjw62LbZJ0UfFO2wm2sZV0mIv8ns3MPdPlw2U7M25wgK0ZwMT8N14YrOGzfQjhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766089662; c=relaxed/simple;
	bh=TD+/j/I4yhxtDh5NkkZVk41yeEES0Js8lqGZ0xJ+n8k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HX7nL2wDEtVj3OaFXtXNnC30lG9h9Fn2sUoADK2r87UokMyBqVMtUnhkLuCfEE2s8YIYi80J89qhhPKPhdE7lCW+lLnvzErmQ/uxtkR+6WDRBIWCONNSY9LURetwD7/yWIb/NSd4VE3QK0IOUF3iZ+L+6Vs7diPX220kPdJHBtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bs89IJ4p; arc=fail smtp.client-ip=40.93.195.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bs89IJ4p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y2Zns6ruQc+eXxKJNcF7XsXcuKMQbJrJOs8bvAY/LmENtj1Bg9xjaOJ9qMq357BL/nthdY+scIx5o3293oyz+QB/Cv+bSEKXOFo0sEGEMnG75cka+Z1qGQ0RNsAvk91GGx4tD4HcqEeeQXvDWXdt+AE7SpPRc2EPBIfzsJ2AF4FKCbV584QPgs1SDcAa+XFt3FMzFLn31nUDRpboc/7e7h45Daexe5JHcBgrAsVBKWIdjjbNfszT+y6kqq1mHxYbYX/RxQ91hsAHKypYUePEPBj5ifGYiIq8Qjv/xm4q+pS4c3WSXnZRQs/KcgOKepNhBOZrABb6c2jX4iB0NLS69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKDpLxbtMphCs3w1ZdTcoO44W9z5oi3LhNIAXQ8VkPA=;
 b=M2PSGL5DfEtvxX2+FfFkl7qDCaaXwKTWMrNG/c3JW0Xffn87H9Tl1M7ipEVvwVaWtAXsP1oD2YQ3s7pHkpvKz5U44+aXOk80/ouJWJuQqHhXzo9AMNYjXo286X/k8kLdcZ8VhSSEjQ3vyGaLuxvmLmdSQszpoWb6QvqiNQxr+OWSTfOD+I3HejQ/1bi08xURdOlx/bXEyDQkLk0d1ZQ8aVH4Es5BwIqAWjHLI/XDOnGEJ6JR4lNUHfmWwuiUzuIXRNLgq+fA6enT/9tVhuunSUUlFJqlsi/hrMMUhrvPQa0Yit+lRrqtS3Z5Gb+XhB9+8hZjVTrs7mSrmPmT97B7Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKDpLxbtMphCs3w1ZdTcoO44W9z5oi3LhNIAXQ8VkPA=;
 b=bs89IJ4pE+AgrCmK9c9SGQDA/53A43VUVBTawo9ZoCtiVwVeH2txPsEcdeRbyNxr9OAGHn5horhLuJ5/jpyg/Ouj3jr3E69Yj+sjAoMEkEI9XDMINmhe8AYXKce7wZQ4SZHkdRMNUhLaZ89dOZ3u+aKMe0U4jVZv7QTsKN8iiKghqpsivuzXGtPw26H1lKSsV3Y+ZaAxv2IXPcV1fsVUfb5FGl54QueR/ZS7ajHoGd8GWRR5UVUfC2dJYnGzgh2YmRkCEd0kUmiB7KRGqsXC5KRYRzPEn7WaBv3gxwwgppWS1VogjUlbNAOUf/MDEgdhGATCJ2Gg2R4ncbsUirWktQ==
Received: from CH2PR08CA0009.namprd08.prod.outlook.com (2603:10b6:610:5a::19)
 by BL3PR12MB6402.namprd12.prod.outlook.com (2603:10b6:208:3b2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 20:27:33 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:610:5a:cafe::51) by CH2PR08CA0009.outlook.office365.com
 (2603:10b6:610:5a::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Thu,
 18 Dec 2025 20:27:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Thu, 18 Dec 2025 20:27:33 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:17 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:17 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 18 Dec 2025 12:27:16 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v1 3/9] iommu/arm-smmu-v3: Store ASIDs and VMID in arm_smmu_master
Date: Thu, 18 Dec 2025 12:26:49 -0800
Message-ID: <f7fa8725aab1fbd2c2a1d564e7493b16a586e88c.1766088962.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1766088962.git.nicolinc@nvidia.com>
References: <cover.1766088962.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|BL3PR12MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 02bd8fce-b077-4a3d-6aa1-08de3e73e00b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/0eQeG0FubfjoM/V6Z6rHpqJJUbkA+Zl9TWHZSPwJfouxltWvQPq4DLWiYaT?=
 =?us-ascii?Q?KHzj/DttpMW/jJ3R2hcObopS+Eu39i23RZP4HjD1ay9MjOokrYn9r8aOMa4H?=
 =?us-ascii?Q?Oi7jI5Nfsi7JUYnuY82kXG4KGOZhEWDRbUX14ZxM13/2fmdjIW9E+A4rYpvZ?=
 =?us-ascii?Q?gcdP/2SE9q4IvO7jHQMZtNAtQZGh+ZrROinLpPCbjhJh3D1ybRicoI3w03vL?=
 =?us-ascii?Q?A6ri4E+Pg0X8FigvWQmnjYMX9gPUADlgyaAUKlJvV6Ym0Tox4O2YSQkgeiSm?=
 =?us-ascii?Q?/7wGEf8qq+7r8HTn/eMu6ByT+63jwJusIwQf/p7/zvFIHvBpP6ofDdN54LBs?=
 =?us-ascii?Q?XpJkW7YwXJowqysOzcv3PSA1MCY3gOzfm5eGX8VWnSYeNi5OtLvzvWGnfGnn?=
 =?us-ascii?Q?Uwv6qrMUqYx97gi2TfdurpFXUIrsX5WX6rKaSW2gnQgGT5myZbtbl7jieqoq?=
 =?us-ascii?Q?K4+c8ZxrQ97oem/Ro645KTMGeR0YG0ERBav72ZEyZ1YZnuVYVsetXvMg5WXw?=
 =?us-ascii?Q?YuvIK7oibgpOZF3ZlGuRBRYO+FJUiePkMiVdGPFp6XtFdAXFzj5UVCdEDmu3?=
 =?us-ascii?Q?r+1NumkefdYrLncJDnxFOQ9V0KFVrLj/QZOopAvtipBV/kp8KXafCZ0OeEf2?=
 =?us-ascii?Q?UFxJK51DRlwk8yx2VQKE7UMbR/qUocIS5trNmbPwuI0E84jtMtu1VZoh2Qry?=
 =?us-ascii?Q?Y86fkQotJqzGwnvJZhbfoaqFbJXAu5HM7+1H+O4t4mSKKon8qXrsnEqlZQzC?=
 =?us-ascii?Q?xLvyNvqC9pxRbb3M60wcrcl5Dyds1j+fUcJFI+w/PlAxE/7HgE7X4FTAcYKl?=
 =?us-ascii?Q?lLdX/UEFAnuzaxwbUwjdp3NT00uCeC0kX4hnlGiF3gd1/tO71QECttCMFfz3?=
 =?us-ascii?Q?JWfK/Exg7sWVRULZXTLj2yZGXF2jhv5DrbJKiAH9FOcCSuv2TYZIxCHnwcYv?=
 =?us-ascii?Q?ztbbvNUuG27JfJNMbaeF6eqgLs7WsAnm5z17AejC6a/n+68U/ZY5nHx52GYj?=
 =?us-ascii?Q?KCV3ulJAWM4LQNQPXLs8UXCiXydqJk4nBkPSwFyytJ0wZ8Itcz4EVAM4YQQI?=
 =?us-ascii?Q?+8wypde8ADoM+xfP+vfgZRC6/fNP+0I2zytOn7WajAUicBIWxMP9GPZe2IFM?=
 =?us-ascii?Q?fC6GPvwWCsLrUUAlVVVourOSY46ORwCYQG77dFzOmKu9iSrjX9+2TEM0Qxz9?=
 =?us-ascii?Q?42I0eiGWQGz39GlK4uWX1swroAPfJz1NPVXXybXMZHwsVXV8LB5T5zGbUiBQ?=
 =?us-ascii?Q?QsuSBQHCuUKc9Yqy+uqieNl4bY6eXMfxfJfycRfUCIqGKpkS1jh/BGCQleD1?=
 =?us-ascii?Q?ZuVkw1zMFm+AgTmaZFC9kFk2HIfOOw/SLqMIn5cMBh4DxikUVz6bS3RC0aQp?=
 =?us-ascii?Q?bRWPF5DrMgJCw220twhLjMNdQD8TB0t71FqyaRT+FhuZTTko20/ja2Ng2gWr?=
 =?us-ascii?Q?2akszlJ2Yy1Myw8qULUEIsgpGzNmVYtOIdl0TcnqmwG8z3IcGVVc4ZJd6ed9?=
 =?us-ascii?Q?15z9B4y+2zoa1ysKjEvX+vU49+bwbnEr+t4f9vQmJfX13nqFssWacKqaR+eS?=
 =?us-ascii?Q?81JIk9bExy2Sti2Exmw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:27:33.2927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02bd8fce-b077-4a3d-6aa1-08de3e73e00b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6402

Currently, ASID is allocated per smmu_domain, stored in the domain, and
freed with the domain.

Practically, ASID is only used in a CD as an iotlb tag. Therefore, ASID
doesn't really follow the life cycle of a domain but domain attachment.

On the other hand, the CD carrying ASID is installed to a device's STE.

This applies to the VMID as well, which is installed in an STE directly.

Since a device can only have one ASID per SSID and one VMID per SID, add
an ASID array and VMID in the arm_smmu_master structure, to decouple the
ASID/VMID from the domain structure.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 +++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 13 ++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 28 +++++++++++++++++++
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b275673c03ce..e21e95936b05 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -953,6 +953,8 @@ struct arm_smmu_master {
 	bool				stall_enabled;
 	unsigned int			ssid_bits;
 	unsigned int			iopf_refcount;
+	/* Store allocated ASID[1 << ssid_bits] and VMID */
+	u16				*asid, vmid;
 };
 
 /* SMMU private data for an IOMMU domain */
@@ -1117,11 +1119,13 @@ static inline bool arm_smmu_master_canwbs(struct arm_smmu_master *master)
  * @new_invs: for new domain, this is the new invs array to update domain->invs;
  *            for old domain, this is the master->build_invs to pass in as the
  *            to_unref argument to an arm_smmu_invs_unref() call
+ * @iotlb_tag: copy of the first entry in the build_invs for the domain
  */
 struct arm_smmu_inv_state {
 	struct arm_smmu_invs __rcu **invs_ptr;
 	struct arm_smmu_invs *old_invs;
 	struct arm_smmu_invs *new_invs;
+	struct arm_smmu_inv iotlb_tag;
 };
 
 struct arm_smmu_attach_state {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index e4bdb4cfdacd..ead0d84cc9a0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -449,7 +449,8 @@ static void arm_smmu_v3_test_cd_expect_hitless_transition(
 					      num_syncs_expected, true);
 }
 
-static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
+static void arm_smmu_test_make_s1_cd(struct kunit *test, struct arm_smmu_cd *cd,
+				     unsigned int asid)
 {
 	struct arm_smmu_master master = {
 		.smmu = &smmu,
@@ -471,6 +472,10 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tsz = 4;
 	io_pgtable.cfg.arm_lpae_s1_cfg.mair = 0xabcdef012345678ULL;
 
+	master.asid = kunit_kzalloc(test, sizeof(*master.asid), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, master.asid);
+
+	master.asid[IOMMU_NO_PASID] = asid;
 	arm_smmu_make_s1_cd(cd, &master, &smmu_domain, IOMMU_NO_PASID);
 }
 
@@ -479,7 +484,7 @@ static void arm_smmu_v3_write_cd_test_s1_clear(struct kunit *test)
 	struct arm_smmu_cd cd = {};
 	struct arm_smmu_cd cd_2;
 
-	arm_smmu_test_make_s1_cd(&cd_2, 1997);
+	arm_smmu_test_make_s1_cd(test, &cd_2, 1997);
 	arm_smmu_v3_test_cd_expect_non_hitless_transition(
 		test, &cd, &cd_2, NUM_EXPECTED_SYNCS(2));
 	arm_smmu_v3_test_cd_expect_non_hitless_transition(
@@ -491,8 +496,8 @@ static void arm_smmu_v3_write_cd_test_s1_change_asid(struct kunit *test)
 	struct arm_smmu_cd cd = {};
 	struct arm_smmu_cd cd_2;
 
-	arm_smmu_test_make_s1_cd(&cd, 778);
-	arm_smmu_test_make_s1_cd(&cd_2, 1997);
+	arm_smmu_test_make_s1_cd(test, &cd, 778);
+	arm_smmu_test_make_s1_cd(test, &cd_2, 1997);
 	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd, &cd_2,
 						      NUM_EXPECTED_SYNCS(1));
 	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd_2, &cd,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8a2b7064d29b..1bf7b7233109 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3391,6 +3391,7 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 			arm_smmu_invs_merge(invst->old_invs, build_invs);
 		if (IS_ERR(invst->new_invs))
 			return PTR_ERR(invst->new_invs);
+		invst->iotlb_tag = build_invs->inv[0];
 	}
 
 	if (old_smmu_domain) {
@@ -3440,6 +3441,11 @@ arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
 	 */
 	smp_mb();
 	kfree_rcu(invst->old_invs, rcu);
+
+	if (invst->iotlb_tag.type == INV_TYPE_S1_ASID)
+		state->master->asid[state->ssid] = invst->iotlb_tag.id;
+	else
+		state->master->vmid = invst->iotlb_tag.id;
 }
 
 /*
@@ -3471,8 +3477,11 @@ static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
 static void
 arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
 {
+	struct arm_smmu_inv *new_iotlb_tag = &state->new_domain_invst.iotlb_tag;
+	struct arm_smmu_inv *old_iotlb_tag = &state->old_domain_invst.iotlb_tag;
 	struct arm_smmu_inv_state *invst = &state->old_domain_invst;
 	struct arm_smmu_invs *old_invs = invst->old_invs;
+	struct arm_smmu_master *master = state->master;
 	struct arm_smmu_invs *new_invs;
 
 	lockdep_assert_held(&arm_smmu_asid_lock);
@@ -3482,6 +3491,7 @@ arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
 
 	arm_smmu_invs_unref(old_invs, invst->new_invs,
 			    arm_smmu_inv_flush_iotlb_tag);
+	*old_iotlb_tag = invst->new_invs->inv[0];
 
 	new_invs = arm_smmu_invs_purge(old_invs);
 	if (!new_invs)
@@ -3506,6 +3516,14 @@ arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
 	 */
 	smp_mb();
 	kfree_rcu(old_invs, rcu);
+
+	/* Make sure we don't clear the stored new iotlb tag */
+	if (!new_iotlb_tag->id) {
+		if (old_iotlb_tag->type == INV_TYPE_S1_ASID)
+			cmpxchg(&master->asid[state->ssid], old_iotlb_tag->id, 0);
+		else
+			cmpxchg(&master->vmid, old_iotlb_tag->id, 0);
+	}
 }
 
 /*
@@ -4286,6 +4304,13 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 		master->ssid_bits = min_t(u8, master->ssid_bits,
 					  CTXDESC_LINEAR_CDMAX);
 
+	master->asid = kcalloc(1 << master->ssid_bits, sizeof(*master->asid),
+			       GFP_KERNEL);
+	if (!master->asid) {
+		ret = -ENOMEM;
+		goto err_disable_pasid;
+	}
+
 	if ((smmu->features & ARM_SMMU_FEAT_STALLS &&
 	     device_property_read_bool(dev, "dma-can-stall")) ||
 	    smmu->features & ARM_SMMU_FEAT_STALL_FORCE)
@@ -4299,6 +4324,9 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 
 	return &smmu->iommu;
 
+err_disable_pasid:
+	arm_smmu_disable_pasid(master);
+	arm_smmu_remove_master(master);
 err_free_master:
 	kfree(master);
 	return ERR_PTR(ret);
-- 
2.43.0

