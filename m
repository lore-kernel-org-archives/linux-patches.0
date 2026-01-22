Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012063.outbound.protection.outlook.com [52.101.48.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8675343D6F;
	Thu, 22 Jan 2026 01:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045105; cv=fail; b=B7blBvafuRZh5IbR4n1ra2Yae9RxxTrMKCYG3aCgLICF3ySpgizshKQOO3GRX1kWjU3B7R9j3P5tNqN9GIKAI6Dz+epyDGeD8TqdtlZI41CgSYaPQxF+Q1KRGnVIvEmCfINbcs8z879aoPut0+iURjsL1Kq++dOPoW/iR2VhjuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045105; c=relaxed/simple;
	bh=U3rAlMze7L2csN53nae+x0RmyF/9CGbFZa67OGf2gGA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NvF+tKsP877HXdOG25YpKBn5wkES9p6Mqr9hManzJ7YJIdmAs90KHFwxk0lC6kbnEmI6nuvIlr7NjuwlUmmwqT26O1ajzH6rkLMMAs1Gk87xj0rWJ7S4JN++U4tHVBJDYHvRA3XaaTpXj68Zk8niy7YdZvJQ1zVM017gkqXHjLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PI72C+0I; arc=fail smtp.client-ip=52.101.48.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PI72C+0I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJ5XNx7Oq1IJFHgeLBVBpQfMXibBH0IHG0kGtw1rbWPrKJo79znyxhwpDAaj2te6H00l3IGgxlB+OUp1E2pmyTNVHpHMVCJ64TwKdWkTDMgwmgTpv7HJs3c4HpbEZedQt6rVFLMT4qr2iF43nn9Vv43RXrFbE+1at4uAAwqgRK70kUBM5Hg+1n6i1gkCQJwWXnan3deYb4BKfYx7HUWDj3IVvUOHomH3KjckL03YdkHy4ILl62xbp0UNVZ0xQnkcJU0SWe9AlGBsDGcfgxdaVRUJeq0XN3DZCUJUoAlENQYKiz6AWL4m1cLeyWDqcCD68a75o40pv9Bzi5Y80jnvYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZunZQmSARl/9tmwQVYXYfNiT5M0YMjge74VrlTVbaWA=;
 b=N88BuaA9SP6iLzF+jd5I2E/le62c5QF+PSdNSTBOixEzOwoocga/+qEGoGPqn20YlUx2icoANZLunoyBR+cDNI7GQ1YQmlaI2+cR8H4v+jZ89aW4r/gMmXQU1N4Iv3x6hDkDS05G0b+jVPeFubTZv3EPvMLWP8GxD7SM9jFfi2qjA3j5VQlWwKhoP2Ft7PLR2hmRdQhPHAIPtvTwV1lOKlR0mkD74hcAA37X7pKzRfJR1if1xB6Bl6+wlBH3+x0lahbdAMJM1Lj2invtbP+Ctm09q81ug6ozCCAWOefFLLvx9X3I21FjG/HTN7ywJC+vdszXg40j4iZqXToDJoq1vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZunZQmSARl/9tmwQVYXYfNiT5M0YMjge74VrlTVbaWA=;
 b=PI72C+0IHu0AbT2ZWC6/viReDI/hfPzTeniCIF1HmcSMXu1vlJHMV8kVuT50nS9eKo6JLuTuSGUJv7LkJdqqX32pFMgYmynqwvnpdEDhLZ8ckkWKmDOYilTOq/4I9x/lYznzEwCAHXRrp0v+LUSZsvnE6cLsoIQG2+tzsh5efU4QjdAUJa40z4VDO+VzebtvF/IISXyKhdWtvuL9o6T3mscSNJnOQqqhXXhzB5KR00wZUgwDeTx6aGAjI4QlyDw64i3cQPpb9tYzow6J2AJC6lq2PaWsIhQk8x4jaT+CuLH7zWo9I+WSR+++SDhBKBi5HtL5zwddx6o5ReqQDqNWHA==
Received: from CH0PR03CA0067.namprd03.prod.outlook.com (2603:10b6:610:cc::12)
 by SA1PR12MB9514.namprd12.prod.outlook.com (2603:10b6:806:458::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 01:24:51 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:cc:cafe::eb) by CH0PR03CA0067.outlook.office365.com
 (2603:10b6:610:cc::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 01:24:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 22 Jan 2026 01:24:50 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:40 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:39 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:39 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 03/10] iommu/arm-smmu-v3: Look for existing iotlb tag in smmu_domain->invs
Date: Wed, 21 Jan 2026 17:24:21 -0800
Message-ID: <86118601583b0c98fef39d38ad08be232bf1d04f.1769044718.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769044718.git.nicolinc@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|SA1PR12MB9514:EE_
X-MS-Office365-Filtering-Correlation-Id: d9789593-e257-4ae7-f13c-08de59550a1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cfJWVROttQfoyPb3ey0XG7VVjlogaCtK1hL7kqfvKGPc13m8Ohbgz2K8su36?=
 =?us-ascii?Q?LcNK7l72s8xvlv8+j0WCsl/j18YkuJ4Sugixa6EA4VclLnnXlZx/BWLeq/+n?=
 =?us-ascii?Q?Cyle2YgyINp5wYJ3kdHwf5IjWzUaVgUPrTs5l4qtr/AlzCoKuDdOyPUryGsn?=
 =?us-ascii?Q?kdSB0cLD9b/QcprrmYs3pLEgvESHwCzfIcUi8l7so3uJtIcdi8rceIA1QpxV?=
 =?us-ascii?Q?lIJF5J8Fm8p4DhBfqp6FcrQjhaSmcdJO9cQhd61cEHiNwkHHBLIAuOy1t36X?=
 =?us-ascii?Q?0ZekED4Upj8fZn/aLDJyuAy9wjZrBa7ml8X+aGLWH1AhoTXHxiA1yuvgAvLH?=
 =?us-ascii?Q?BWC4YQPwN5B1cSSddSUNhrmael1UbiZDyiZnmp98K0eTdNwoU8ZftKf6nl9W?=
 =?us-ascii?Q?M5Jliok1QqxKExoqA2lynctZLN1ZuNogCzhPTcZ9QTaKftS2sDozwK7MiYjY?=
 =?us-ascii?Q?EtW+cvzMAouHFNew+DxAT6aRGQyY4NI6dwplt61Rgm9UYLhmN739bR8c10Vm?=
 =?us-ascii?Q?kEGpHKykTaxe60HIQcDVIzzM7/H7GbOlPVfpXP0HebiAcpL93fZV1rvGjWh8?=
 =?us-ascii?Q?7W1eqILCPiv61ReKCGzVKhji85B/6AUMvK6wpPa/sCmKZ59dZz1TkNKiTmnK?=
 =?us-ascii?Q?sTHOZpmJ5aVCI/+YUh5rxW/myncbBOB222bccAfSrw71N4TXeJF2zQefxotF?=
 =?us-ascii?Q?ST170Kh0Ljcz6qfWRLs1WFXQIiBsez7dhRXkTFAzqhHRfuIRgJT+xYcVR/Rx?=
 =?us-ascii?Q?pO1ObgjWtArL0Icflhp+DHTklv8y0MdX397u7+mXhPmHTfeTz3zqGpN2z2OI?=
 =?us-ascii?Q?PnB5x6T46hEebIXLuYg7MSNnIzcxDsd2NvdcxirCihMUQ6nQ9DeSMIHTMDB4?=
 =?us-ascii?Q?S8f7zerQ07+E7LMPDxCU8k2tqmaknTygXwR9vQ+xclR8WTz22blPyPJ7Hnxc?=
 =?us-ascii?Q?q/d0XuOZ4AWRcgcCvizq0stqNoFcBFaaqiiS51kounv6XE5oZ/TsqKjQrYgY?=
 =?us-ascii?Q?b4bwwhwStgkxbo1a5a1BG8YZymbivxOu5jZhWh5hVdKtb3NhP8ym9MClQviA?=
 =?us-ascii?Q?EWmNm/CasiVS62/j0mAZJ4L4xMFJ7sLs5qEQb7bCZUqjtfkG6BS+gChN+Nyj?=
 =?us-ascii?Q?YNt7DeZm4YChvPNRNvZ1ipIt3PbHrBLD0TGQj7jjyrXO7zG6/Y94km/qgW65?=
 =?us-ascii?Q?zcyIzN/opXRMU2AOywIOFDbGCQVTAcoEZ1Qe0XOS0YRVGDEu4gmW4PkYCPWD?=
 =?us-ascii?Q?eKIM+1S8l83Lp1exlI7LOdk/wRiDc53FYOxKth82Tkzk2xSaLdKoobOCHH7q?=
 =?us-ascii?Q?CHphBXYJDh8qH2HhkEXfKD2LZDIAgNrK0VMKiyTKXRQBfW0q2+nZPEg/e9oL?=
 =?us-ascii?Q?mhw1Xi254r0lgIDi0tlzayuqMkma0KJ9j5VR7jGKjA7IwJtQmvFcjjT/z3rL?=
 =?us-ascii?Q?fzSXAZZVYrbDXIN8/UWLAfTMWvX5+RGfth03wYlOm+tLw+q5rYB7i2jUOYAN?=
 =?us-ascii?Q?3URPvW+UOzOrKYVOT+WgT3cZIhxj94coazkOSaoiXRvtFKnD77t4e5WNb3cS?=
 =?us-ascii?Q?zCDMR6BiM6wBhMlIABiPUOXFbvBtLwIh9WkcHYXu79p9LmLHAQAAtAixhMgw?=
 =?us-ascii?Q?CMrPmIbRwOlO0HENOd/yCBlmIFoat90XUbFECo2P2Y9tpAkH+ueyiaHZ/t6G?=
 =?us-ascii?Q?HY3bPQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:50.8654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9789593-e257-4ae7-f13c-08de59550a1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9514

Once arm_smmu_attach_prepare() installs an iotlb tag to smmu_domain->invs,
arm_smmu_domain_get_iotlb_tag() callers should get the tag from the array.

Only the arm_smmu_domain_get_iotlb_tag() caller for new_smmu_domain in the
arm_smmu_attach_prepare_invs() will be allowed to allocate a new tag.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  8 ++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 32 +++++++++++++++++--
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 11879148dad0..812314aaaa6a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1137,7 +1137,7 @@ struct arm_smmu_attach_state {
 
 int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
 				  struct arm_smmu_device *smmu,
-				  struct arm_smmu_inv *tag);
+				  struct arm_smmu_inv *tag, bool alloc);
 
 int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 			    struct iommu_domain *new_domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index dff494584008..5c8960d31a9b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -30,8 +30,8 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 		if (WARN_ON(!cdptr))
 			continue;
 
-		if (WARN_ON(arm_smmu_domain_get_iotlb_tag(smmu_domain,
-							  master->smmu, &tag)))
+		if (WARN_ON(arm_smmu_domain_get_iotlb_tag(
+			    smmu_domain, master->smmu, &tag, false)))
 			continue;
 		if (WARN_ON(tag.type != INV_TYPE_S1_ASID))
 			continue;
@@ -170,8 +170,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		if (WARN_ON(!cdptr))
 			continue;
 
-		if (WARN_ON(arm_smmu_domain_get_iotlb_tag(smmu_domain,
-							  master->smmu, &tag)))
+		if (WARN_ON(arm_smmu_domain_get_iotlb_tag(
+			    smmu_domain, master->smmu, &tag, false)))
 			continue;
 		if (WARN_ON(tag.type != INV_TYPE_S1_ASID))
 			continue;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index cf0543f276f3..1927eb794db9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3120,10 +3120,31 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 		iopf_queue_remove_device(master->smmu->evtq.iopf, master->dev);
 }
 
+static int __arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
+					   struct arm_smmu_inv *tag)
+{
+	struct arm_smmu_invs *invs = rcu_dereference_protected(
+		smmu_domain->invs, lockdep_is_held(&arm_smmu_asid_lock));
+	size_t i;
+
+	for (i = 0; i != invs->num_invs; i++) {
+		if (invs->inv[i].type == tag->type &&
+		    invs->inv[i].smmu == tag->smmu &&
+		    refcount_read(&invs->inv[i].users)) {
+			*tag = invs->inv[i];
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
 int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
 				  struct arm_smmu_device *smmu,
-				  struct arm_smmu_inv *tag)
+				  struct arm_smmu_inv *tag, bool alloc)
 {
+	int ret;
+
 	/* Decide the type of the iotlb cache tag */
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_SVA:
@@ -3139,6 +3160,11 @@ int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
 
 	tag->smmu = smmu;
 
+	/* Re-use an existing IOTLB cache tag in invs (users counter != 0) */
+	ret = __arm_smmu_domain_get_iotlb_tag(smmu_domain, tag);
+	if (!ret || !alloc)
+		return ret;
+
 	if (tag->type == INV_TYPE_S1_ASID)
 		tag->id = smmu_domain->cd.asid;
 	else
@@ -3314,7 +3340,7 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 			lockdep_is_held(&arm_smmu_asid_lock));
 
 		ret = arm_smmu_domain_get_iotlb_tag(new_smmu_domain, smmu,
-						    &invst->tag);
+						    &invst->tag, true);
 		if (ret)
 			return ret;
 
@@ -3344,7 +3370,7 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 				lockdep_is_held(&arm_smmu_asid_lock));
 
 		ret = arm_smmu_domain_get_iotlb_tag(old_smmu_domain, smmu,
-						    &invst->tag);
+						    &invst->tag, false);
 		if (WARN_ON(ret))
 			return ret;
 
-- 
2.43.0

