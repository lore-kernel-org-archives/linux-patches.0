Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F74537756E;
	Mon, 23 Feb 2026 20:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878535; cv=fail; b=fzzByJIHRk5OQQZNjZEgG/p4PIG9HPgeCrRryiIjemZBVgw1z4UMmv7gpYERhnUaFfggzvu6aIR8LsnVGM90LomRqgntU+TcGfLxTudIt1HlBHyaVNSZuIFx0xC4y3QMPghBxm42UtYrsVHjl96VcOroQQQEWDJ0mi+Y+7nvelI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878535; c=relaxed/simple;
	bh=h39eoYDNllDDd7actL249RqzvOoEPXgg8A2GnUQrYaw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kBGyHkQzNJmnhucR4XCFvw/uKCttnT3vPgdzn9xkme6Bnhn33AY6aWJKlQnyGLWvsfwGIazTSJxuIOE3fVmb6sZk+zfPFbKDxfZiqnoptIe5B/I6+QwKDVjyNpUs85liBTiu+lKC5PqquaNhMcXh7Yk5hqt5uhRyZdVVow/BkYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LlP4m7Cn; arc=fail smtp.client-ip=52.101.43.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LlP4m7Cn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tAwxi1LeClxzIR3r/rYnWFg/xHRrHTkgO0o+Psq5LYHtMQehhXRrM1rSiPX6zDkvjUBWRABiNsqozQXWUxKF1RngJ8JN24jJ6gaebG2I5YkNrQBQLqZAKw1OQwm12Lqg46yUJjYIoU+ALLG4ErZV59ff5QVsKTgSKVoP5BgFOqUvnoCMg9aelu+erm2R6Qn4c8rtQeBqVLlaiairqbLi0yhhhvf0krOJuVqZQnmIYvxl1EmLEWh3wLfCMdM4LK6TfuMrHW0i3JQBnysMwxMkLjDjPB03QI5VShqGv70KQHpOZKBCa6fCHKgvfYEAe466tivihspmNEfxthLyn2WBiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hybV7cHWWS9frKWiessEd8TKB+kAt+bQnqqTJXw5cGM=;
 b=AscApxVOXCP2iwY3T5J9TSDfZmh1n30gG8E1VdeRwVhhzl1UTJX3TFjGcVO66XnzFuOmsCglyL5l8Z6WJw8kERJ4zd8ArNOXk8maJCcpynkOWSV+AGFmqTy14ATn5gPcheV69xgoiDmrRNWpdSysqvsvMjTYDfbNky0u3/422pIdJr0NMAvZ0RblvJ6cTADoaxYN4MDxtJbyy2k/vUeTMAaAM+ApTIzSbMCEkJAOkFkLoJ1Ozd5ENtj87XneKEmTkG9twaOII+F2pWRmYBdUDhrNXnjM1AMCLZtlZv0cI1CHk2NBwwKIXsg0XNrXE45I/6IQ5arDh2xqhSe5T80Uhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hybV7cHWWS9frKWiessEd8TKB+kAt+bQnqqTJXw5cGM=;
 b=LlP4m7CnZFKzesHxdZP5k79oMn3etFQ9YD0Ec3s81RGQS/6w/4MFMOk3Gq1JlDat8fnuQdWyt6nzE2X+W5i0kUogbR7s1OIEygKrXhJx3bMrCgC7Yq1RT6h6zyfNtssqu6Gt/iXO2TApvHBrt6YKSxqwYyeAwGcBQvsJOTATYb83YxV3XY0HVmtQBdlsGHiImau457H9X3lXmoRmOzxL+ulo5jopD/i4S+LZUOAeHEtguPr0C69FqpgZtyqdtTNLholHh94mGGQRxA+kg971PPgihHqm6J2soR9xTBgxikb054YZRYipWFOwND7gE3+agWsQ6gAWRu+1Ixzp1kIrYA==
Received: from SJ0PR13CA0162.namprd13.prod.outlook.com (2603:10b6:a03:2c7::17)
 by CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:28:44 +0000
Received: from CO1PEPF00012E65.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::58) by SJ0PR13CA0162.outlook.office365.com
 (2603:10b6:a03:2c7::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 20:28:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E65.mail.protection.outlook.com (10.167.249.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:24 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:23 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:23 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 04/10] iommu/arm-smmu-v3: Pass in IOTLB cache tag to arm_smmu_master_build_invs()
Date: Mon, 23 Feb 2026 12:27:40 -0800
Message-ID: <4b42c150b92d0e16566dea661fcb6810f89170d1.1771877893.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E65:EE_|CY5PR12MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: 994f3096-b540-47a3-db0f-08de731a23df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A4W/myA1owSxf3fgULNI/AROur0sqOrTxjSAyQysJ/FQM3ct7wjdx9S6LG+0?=
 =?us-ascii?Q?QM8+aa6OnDw975uSz8edywwH+Zl44rJyNSXkDlQ+iVGSF/Wsjr5CLvwVC0F6?=
 =?us-ascii?Q?15ziR+5NebS2pzd7nzySN63M/uX7WZcOgHLNH6AVkjGWt9Xm5kuoIShQ8Npc?=
 =?us-ascii?Q?xvJWbuiNAQDEyHWd0aDBRHgRg0D4ZovXDULoa3L/TlTA5LEJQsF2rrWKYgdh?=
 =?us-ascii?Q?iSBvRSbOJ1TBZ7e+Dw8GQLhjmhPJyL+aIv2LD1Jaj8Dr+oPC7DwBcDOncW6u?=
 =?us-ascii?Q?1gBU/A2SeWRsv58nEu8nQVs3qMWw+s/KPROSUsqeDMeYVz8ZcE1iOTw4LULS?=
 =?us-ascii?Q?RGftZsK0eae7eLxiw+spDYq3fNCVxcJWiXISd7I5SCJFSf6B/kd5gFOb+UAA?=
 =?us-ascii?Q?/EiLm6OZTQvA4jZ7pEr3uqoRlAJtM/WIABcLGiCo/Cd/H51BLFzlDewOJYWD?=
 =?us-ascii?Q?9wq1DUUEXdyh/0BiQKMXoOQkGzUVa4KMeQsz+XGELtXxsoSTXy/thQhcC+o2?=
 =?us-ascii?Q?EUkd/a86giRgGL6Bved3qYmFkikxKiHLTeF0VU43V6B1Y+EqclOx1bWXcZQe?=
 =?us-ascii?Q?T9uL6tfLMXuycLMZV1qgjSYCW/+0ZmCOL4GTJReqRwrxRp/JplC9fw9aLnuw?=
 =?us-ascii?Q?pB0BcGauiAQQGZrF4oOdyvecP4/Hq0bTJ9uKyvvARX2aavEP3wd1fkIqA/sO?=
 =?us-ascii?Q?D7a/OLXRyuMTIP7w+tGI9qS7OON0nLtLqwJ174Zw5gva8oLTWSET1u4HOL9R?=
 =?us-ascii?Q?/Oe3ls4p35EQRhHTFth7PHpah6yzf7VfekyXvJhNh5fUFW2yAJmM7lB6ZB4b?=
 =?us-ascii?Q?PwK9GU/JRdAA3L7tvsW2dPqRYSBjUS4oIhedhsMKTS25Rpo7SDmq6N5D6Kj4?=
 =?us-ascii?Q?KVDfoL12+lbqPVy/AL0ZZPfPJcIRTeOEyYdU6zc+FYNv1IvgmoWzaafuy+pm?=
 =?us-ascii?Q?pfUdQT3m78wylQGTeBBb7FObtsKQ7teH1IK0+72u7PZ9SHC3n8WP27xGxgBv?=
 =?us-ascii?Q?gfA/qLlP/TxNs8DjF+CFCqqecZJ3OM44n2UPzveLXAt6wO+6Y7ya7FiQzUM8?=
 =?us-ascii?Q?yMFC+TQZaaZBuruXaIKB7Z1M/vdnzzZd7VeFWPMOLQOGIg2WpW2HOIh+hbzJ?=
 =?us-ascii?Q?XuAGEh/cJOtMw73rP75nSj9kJRU9agbZCwRXajzklvU3QlX6NRE+vVRMraPN?=
 =?us-ascii?Q?lglERb0m5Uqj0aG9KNjVcqpvztsBkJeNm0ubiyzlzrOgNbE9qXVl9tXeJScV?=
 =?us-ascii?Q?Zgw48ztozcOBzBtH1jac/ir202nRCgqFBQUBWnDGEsFW8nLF5yGQURZol4qV?=
 =?us-ascii?Q?l5uy4ULFT8J1WrkWI4Psd46AC6+Zr8R0iAlQtL86Lr2+f0ypnxh7krjro9Be?=
 =?us-ascii?Q?VZ2yzSUL7bYijZgSrPYb+7vMG02FE8SknTNj265ljwXfk8mtO0pFMwz7+lmD?=
 =?us-ascii?Q?cFrCe7ODWpZYRT354f3wPhnX9z8KMnBGwFgIf8W9wRN7hRPd0y8nN/d0ELmp?=
 =?us-ascii?Q?I7Xhb128T+MSNIsgO2ZqaT9pa2wVtQQLUrKsOg8vDQAWMubFCmPVvqnKAvkc?=
 =?us-ascii?Q?WpxPO5oC+6Dsj5bj+c7vziIyT1/WXpO16Bi2iJR39fEubCLtQxHsQD2fc/zu?=
 =?us-ascii?Q?ARXiPncTDbdJwCcj2pKxTOWx69KJFya8E0q3TJnHWXnE?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UgQ3NqxY6imhGxY754ZfDzl9jiFGc3F/mD8pD1lU+s1afMQjFHvPARU3QWEdHAJ/Y/vqZOJjJjzzcsxE71WC3AOBaffvVz1g+Y/hlfC9jylD3ZrEGYkfKbzJnVW8AAEDD5Fxys1QAGtOr2gQSJ7btoUZQs9/gpGarWyJ8pBgY0/OEzQkBdqxK5Tql6DRecQc90qvHOKjFoGKDNMDzaWsAKjOpjOH7iaNlRG0pR+B1G+3/WC9qSKUx8CJXLB9oUmhLMuodaYZBNbPzMLMczXB/lMNJe302Qi6c/GtarZ+alC0A/gXax4IP01SniBtl0ZOoHt2jBTJiPH3D+CHn6VjZBk5EDu++BE8wXZvbdmBI7fhHd5q3a/T+zhHdMEjPEjAbULG9SGb26i51n7mKTkcCGkbj7t6jjdGP6feXdPlaSKNNq0lv7KB1w/QTXWjlsrq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:44.0917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 994f3096-b540-47a3-db0f-08de731a23df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E65.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060

Now struct arm_smmu_attach_state carrys an IOTLB cache tag in invst->tag.

Instead of getting the tag from smmu_domain again, pass in the invst->tag
to arm_smmu_master_build_invs(). This could simplify the function.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 37 ++++++++-------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2033468dbf1e8..4649368910e0c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3330,7 +3330,8 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
  */
 static struct arm_smmu_invs *
 arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
-			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
+			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain,
+			   struct arm_smmu_inv *tag)
 {
 	const bool nesting = smmu_domain->nest_parent;
 	size_t pgsize = 0, i;
@@ -3343,30 +3344,15 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
 		pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
 
-	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_SVA:
-	case ARM_SMMU_DOMAIN_S1:
-		if (!arm_smmu_master_build_inv(master, INV_TYPE_S1_ASID,
-					       smmu_domain->cd.asid,
-					       IOMMU_NO_PASID, pgsize))
-			return NULL;
-		break;
-	case ARM_SMMU_DOMAIN_S2:
-		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
-					       smmu_domain->s2_cfg.vmid,
-					       IOMMU_NO_PASID, pgsize))
-			return NULL;
-		break;
-	default:
-		WARN_ON(true);
+	if (!arm_smmu_master_build_inv(master, tag->type, tag->id,
+				       IOMMU_NO_PASID, pgsize))
 		return NULL;
-	}
 
 	/* All the nested S1 ASIDs have to be flushed when S2 parent changes */
 	if (nesting) {
-		if (!arm_smmu_master_build_inv(
-			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+		if (!arm_smmu_master_build_inv(master,
+					       INV_TYPE_S2_VMID_S1_CLEAR,
+					       tag->id, IOMMU_NO_PASID, 0))
 			return NULL;
 	}
 
@@ -3457,8 +3443,10 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 		if (ret)
 			return ret;
 
-		build_invs = arm_smmu_master_build_invs(
-			master, state->ats_enabled, ssid, new_smmu_domain);
+		build_invs = arm_smmu_master_build_invs(master,
+							state->ats_enabled,
+							ssid, new_smmu_domain,
+							&invst->tag);
 		if (!build_invs)
 			return -EINVAL;
 
@@ -3487,7 +3475,8 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 
 		/* For old_smmu_domain, new_invs points to master->build_invs */
 		invst->new_invs = arm_smmu_master_build_invs(
-			master, master->ats_enabled, ssid, old_smmu_domain);
+			master, master->ats_enabled, ssid, old_smmu_domain,
+			&invst->tag);
 	}
 
 	return 0;
-- 
2.43.0

