Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010055.outbound.protection.outlook.com [52.101.201.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65E92D8DB1;
	Thu, 18 Dec 2025 20:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766089673; cv=fail; b=XCY40dqs5XhX7etgQU/DJhedmFrjCcU/boe4HCicSspCsSrBEWJhT4mPU5IGgGfK61boCNHezb3MLgKb9p+6fYXeSOuXkr8tIuQk7RO6Ctj74krwNMIkkOfXS68q1TcfgoHJKGGUjxZTKLkpkRg2494fNLoJvnAfKLWyxWjzjgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766089673; c=relaxed/simple;
	bh=vixlqheVAM5eLliO6OwpCZsx0y2PMkJG3ncLoe8KfDw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGZ9kKbB0xV2kIfsxKPPb5jhazphiAZeT1c5SOmHO3cxExCJjBfGX0ErVAIr5/sPGCIK0KOOm1/jEB6tVS56OUGtaxUXXurD5u4NKRVtJcT4d2jBTwSVGPV7XTVAOOu11xtc6SMVVH5FVtld9vdEZ0mN2cb20McztYvjwmyO4J8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=amaCg4iO; arc=fail smtp.client-ip=52.101.201.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="amaCg4iO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JtoGDczH6phmU1cPODCXMFx8Pu/I8EP3SQC9anlVMJzPmkUMnhs3TDaXynQvLMV5QCvA5Kjxh1spgTm2LGcPkKwWgQ7eEldxmY/c5bLCWICgDoPlWkfGNsz5fOOusndxt9FygWS7mQLye2qUhWyyi4ge6Qk47TE7+HFODpkB+1MSHacX20b4ozfIn79X4cYoWfZZH8SmlL7T+wXF7DsKQuo5ik3l3MzDQiqtnt3ga3q4uhs+8Wb4z9AT/yl7dui0OnPUwRWosBwxeiWhRuzUOG6Qra779a+XYOqT06d4s1xQmilwgTRY7LG4vhfa+Kaykb7dKQbCEhWOZ4qlGpcwVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTO8Z+1Ivml27dzKfjRl4jA/Z07rPlCbGKunUYoqBMQ=;
 b=wHgiUMzoChEsrkefr3rzPmVZz6fosGRags7JRBv8Sxwxa5R7eW+9qvHJr5MOQWhKFgnjdL9FymORDQy5694Jq6gcmwHt5WGMnkkHK6HirJmkMv9NpvQ/wBWyy9f6OoMVojycIxVuWLnJAE5IJ8HAiIuYap4hBxbNu+qUbGjjN0eMhR6GXXCCn5IK2tw78aCYZegDyCcppMonIGpk1N7IvfScWkRYWZU4CfZ7Zwq5QH3LjxqmYb4Knih3pPRFsayB6ShAzeMTinbfW71GY1qOQYYas0RFhn+WWz4cyihSo2DvbEut/KSNxTpK0+dEVpJMFv/5UreHfO2mI6E6s1515g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTO8Z+1Ivml27dzKfjRl4jA/Z07rPlCbGKunUYoqBMQ=;
 b=amaCg4iOqpuFR4kSQ1vSB4BDKw7Vl/sckhIHC4Nmq+bArmw0+TcQDV9P/hB9OOeP88/YewOSJkiTUGsnd+d1N7YQNsKFeUOg1HrhUPIzlubTyfJkFxdoswCwS3B39A7DZr1YvJOV/97yHxN8dp8oHz1ZFdjWAXPVbj+UZji002pDNz3xhs9Xxg24bVfcCvnyvYA2pAigzFUgdLxK/Yx2GO6cv0tm0sAGVzd0u5TprVRY+IuPfLwe8HPiIYsh1l2FCdn0eHHcp1wZgf4vShnRfQZl7d58sVBXweoZBdhqrD3fObxInkfya6WIFprsYKL7KwSNPNYOJsihs74oqegjqQ==
Received: from DM6PR08CA0033.namprd08.prod.outlook.com (2603:10b6:5:80::46) by
 SN7PR12MB6886.namprd12.prod.outlook.com (2603:10b6:806:262::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.7; Thu, 18 Dec 2025 20:27:41 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:5:80:cafe::e3) by DM6PR08CA0033.outlook.office365.com
 (2603:10b6:5:80::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Thu,
 18 Dec 2025 20:27:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Thu, 18 Dec 2025 20:27:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:18 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:18 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 18 Dec 2025 12:27:17 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v1 4/9] iommu/arm-smmu-v3: Use alloc_id/free_id ops in arm_smmu_invs_merge/unref
Date: Thu, 18 Dec 2025 12:26:50 -0800
Message-ID: <54c98cd7092a406d84df0abc9a6cb013aadb619a.1766088962.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|SN7PR12MB6886:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ba6ff14-5769-4cde-3500-08de3e73e489
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eMhFRs+1wVxU67L+VHrH9D/DgqnPeyiDNBUO9Jp1W/KlAjMzCjjeGnl7sFHB?=
 =?us-ascii?Q?pBOZ3i/76aAOxd+pwFnKbvEAGe24UiTddPFcvlwjnFrN4/W0Z+rIJ3b+gJ0T?=
 =?us-ascii?Q?K+X14IYGz2k5bkvcusIjPTUIPNZdJWlODKQuAyLooA+c+bgvkZf5YOBbTXaK?=
 =?us-ascii?Q?pE5pb+SWe2o9cn8DX0uiXJ6TQcYkD4mj9u0YazUM1Zr61lG38J5SzF7IDDs5?=
 =?us-ascii?Q?x80xWmjzs2o4mLvEpJUlTMs9LhY+H0KZfQMRoZPhs9vKneXsCUnmzs10Qz8V?=
 =?us-ascii?Q?wBgV8InaM4JlZKpmCdv7N+JgLwiCsEROJ4ypzTM9zbL7SaoyC9OATwsUpA+d?=
 =?us-ascii?Q?IEnPwbDljTFXvu+adpJtTH57AL7oir8J+dcHc/MZvBJD4T0YNlWrpzmClhCI?=
 =?us-ascii?Q?m4/zmYBWfK6tE70bnU6vCH83HeSS672yqI/HREidZhkgzpszmi1uyijo2i+w?=
 =?us-ascii?Q?JABc9oIAPihRry+HUYxx3hf31hvBAm1COhYt/v+QKo3GMUzoY1zX/BFS8tYR?=
 =?us-ascii?Q?bDPM/itM6bTLc9PmfYJ0YVi30L+8gJ/ccW2b3Hn99mTfs/i7EDqYh9ZcO3Jx?=
 =?us-ascii?Q?OpEh6sYysIXhlVI1+y6a+Mdxde/hzIl6KpDizwgTyN+3QaOUf1Gsoe6CGOaC?=
 =?us-ascii?Q?G9jfToK9QBeI4Z8Jnq60xHyq6d8Q55foT4rzc5kBrEUWe3iJOtwXh0g4PVBr?=
 =?us-ascii?Q?1ZERD/awISL2utgXonfsimtG/+ZYwZu+J1RcQfi/JFQJsd+9qRjXq+UNAWCc?=
 =?us-ascii?Q?zIjE4cXETYLobiOxujzVEQBGRa+BMDD0C5Km0+KIcx9WLwbMLye3EBNb59Wy?=
 =?us-ascii?Q?AJLYa7DrLTQVgy22/ZwpxWGExvhKNFyH54i240mvNAHTkAb7lFLUplSwwUjC?=
 =?us-ascii?Q?cjPC4Qkze7fACFMKEV46OiVcCLL54t5pj2Ws/nuImMQRfN1zAziDqKSMs7IS?=
 =?us-ascii?Q?S7EWRMSZBHlee7djoJk9/cVWNVXvkABkQpCWKbOKmNRGyUgKSS5zYbWrxAh1?=
 =?us-ascii?Q?czzpgA9d2GUOeuGeYbTBcV43nIti4KVqTGrlwYVoyXlzdGfsPB4fYamGzkAm?=
 =?us-ascii?Q?QSw5awmfQQrI5Q9/MIAnruVGdsDH9E95MpJ6k60r+zRRndgr3iwNp01v2ZHQ?=
 =?us-ascii?Q?qImC++a8A9c9C+PaOSUpOPNDBlnHYMgoREEMc/gnMagQixOePkrZuPzOZa1d?=
 =?us-ascii?Q?vgo3JBDWEMZgWyiiazpzwlMfJI51wSm2xrOxrzxmlAMD038i1TnYSBO2NU0r?=
 =?us-ascii?Q?FxqNgLEjKc3b2PAivDuqCvz/t5dGMSr5E/SYzEuraehiVtOKOFm0kAciJHS5?=
 =?us-ascii?Q?f/0q9k3FR8/UjYkKhh2RY40Bzw9zN0zeJC/Ibjp2IjtXSJKot+ao4C7WG+4f?=
 =?us-ascii?Q?xq3lIP/3RrLIPjZbi57cd4Nx1uaUNnS9QOjVLl+gcu2sqTq9aZK2GBzj9O0I?=
 =?us-ascii?Q?XDcY4icM2YP/QpN0HH+5Q6IzgsaYH4E4dkG/9NRf8WwrQGC/5Wbw2NMUdrLb?=
 =?us-ascii?Q?U3rPzm2ogauPMGFlWmVjQjP2PKglsaDnx9izY1AA7R2u0ry7wypMpRaZU+9u?=
 =?us-ascii?Q?2DRxtYnL0RygSmvtSSQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:27:40.8210
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba6ff14-5769-4cde-3500-08de3e73e489
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6886

If a domain->invs has an iotlb tag (ASID/VMID) for an SMMU, all the devices
behind the SMMU can reuse the same iotlb tag. This exactly matches with the
existing case where attaching multiple devices to the same SMMU domain has
a shared iotlb tag stored in the domain (cd->asid or s2_cfg->vmid).

If a domain->invs doesn't have an iotlb tag for another SMMU, there can be
two cases:
1) This is a new domain so not yet attached to any devices
2) This is a shareable domain that is attached to a device behind one SMMU
   but not yet to the other SMMU.

In either case, a new iotlb tag is required. Call the ->alloc_id op in the
arm_smmu_invs_merge(). The domain->invs arrary will keep it. The allocated
new iotlb tag will be returned to the caller via to_merge arrary.

Relax the arm_smmu_inv_cmp(), to allow sharing an iotlb tag across devices
behind the same SMMU instance.

Similarly, call the ->free_id op in the arm_smmu_invs_unref() when there's
no device using it any more.

Lastly, add a free helper for the revert path of arm_smmu_attach_prepare()
to use.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 70 +++++++++++++++++++--
 2 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e21e95936b05..230ab902a9b6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -680,6 +680,9 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
 	return inv->type == INV_TYPE_ATS || inv->type == INV_TYPE_ATS_FULL;
 }
 
+/* S1_ASID/S2_VMID(S1_CLEAR) types */
+#define arm_smmu_inv_is_iotlb_tag(inv) !arm_smmu_inv_is_ats(inv)
+
 /**
  * struct arm_smmu_invs - Per-domain invalidation array
  * @max_invs: maximum capacity of the flexible array
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1bf7b7233109..ec370e54b1bc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1051,6 +1051,9 @@ static int arm_smmu_inv_cmp(const struct arm_smmu_inv *inv_l,
 		return cmp_int((uintptr_t)inv_l->smmu, (uintptr_t)inv_r->smmu);
 	if (inv_l->type != inv_r->type)
 		return cmp_int(inv_l->type, inv_r->type);
+	/* Each SMMU shares a single iotlb tag on a domain, so it is a match */
+	if (arm_smmu_inv_is_iotlb_tag(inv_l))
+		return 0;
 	return cmp_int(inv_l->id, inv_r->id);
 }
 
@@ -1127,9 +1130,52 @@ struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
 	size_t i, j;
 	int cmp;
 
-	arm_smmu_invs_for_each_cmp(invs, i, to_merge, j, cmp)
+	arm_smmu_invs_for_each_cmp(invs, i, to_merge, j, cmp) {
+		struct arm_smmu_inv *cur = &to_merge->inv[j];
+
 		num_invs++;
 
+		if (!arm_smmu_inv_is_iotlb_tag(cur))
+			continue;
+
+		/* A matching iotlb tag owned by the same SMMU can be shared */
+		if (cmp == 0) {
+			*cur = invs->inv[i];
+			continue;
+		}
+
+		/* Iterate the base invs array to find if next is a match */
+		if (cmp < 0 && i < invs->num_invs)
+			continue;
+
+		/*
+		 * Currently the @to_merge array always carries an id (> 0) that
+		 * is also installed in the CD/STE. So, we cannot allocate a new
+		 * ID at this moment, because that would misalign with what's in
+		 * the CD/STE. To not break the existing flow, bypass the new ID
+		 * allocating code. We will lift this bypass line once rework is
+		 * done.
+		 */
+		if (cur->id)
+			continue;
+
+		/* No found. Allocate a new one */
+		if (j == 0) {
+			/* KUNIT test doesn't pass in an alloc_id function */
+			if (to_merge->alloc_id) {
+				int ret;
+
+				ret = to_merge->alloc_id(cur,
+							 invs->smmu_domain);
+				if (ret)
+					return ERR_PTR(ret);
+			}
+		} else {
+			/* Copy the allocated iotlb tag from the previous inv */
+			cur->id = cur[-1].id;
+		}
+	}
+
 	new_invs = arm_smmu_invs_alloc(num_invs);
 	if (!new_invs)
 		return ERR_PTR(-ENOMEM);
@@ -1207,9 +1253,9 @@ void arm_smmu_invs_unref(struct arm_smmu_invs *invs,
 				continue;
 			}
 
-			/* KUNIT test doesn't pass in a free_fn */
-			if (free_fn)
-				free_fn(&invs->inv[i]);
+			/* KUNIT test doesn't pass in a free_id function */
+			if (to_unref->free_id)
+				to_unref->free_id(&invs->inv[i], true);
 			invs->num_trashes++;
 		} else {
 			/* item in to_unref is not in invs or already a trash */
@@ -3167,6 +3213,21 @@ static void arm_smmu_inv_free_vmid(struct arm_smmu_inv *inv, bool flush)
 	ida_free(&inv->smmu->vmid_map, inv->id);
 }
 
+static void arm_smmu_inv_free_iotlb_tag(struct arm_smmu_inv *inv)
+{
+	switch (inv->type) {
+	case INV_TYPE_S1_ASID:
+		arm_smmu_inv_free_asid(inv, false);
+		return;
+	case INV_TYPE_S2_VMID:
+		arm_smmu_inv_free_vmid(inv, false);
+		return;
+	default:
+		WARN_ON(true);
+		return;
+	}
+}
+
 static int arm_smmu_inv_alloc_asid(struct arm_smmu_inv *inv, void *data)
 {
 	struct arm_smmu_domain *smmu_domain = data;
@@ -3662,6 +3723,7 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 err_free_vmaster:
 	kfree(state->vmaster);
 err_unprepare_invs:
+	arm_smmu_inv_free_iotlb_tag(&state->new_domain_invst.iotlb_tag);
 	kfree(state->new_domain_invst.new_invs);
 	return ret;
 }
-- 
2.43.0

