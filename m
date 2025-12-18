Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012038.outbound.protection.outlook.com [52.101.53.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32362D8370;
	Thu, 18 Dec 2025 20:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766089664; cv=fail; b=Hx5EAGVf/mWsOqxn+kCeoq8V1Wg8zLKqgsBIdNBlYf5GOnpwJi0ehe5+xWZE85rSu09LHRzH/Lzq3nykJ59yIFeKPkNv+DyHO/E72UhpX1zHCoEzyyy1KbViuxftCTAyko/RKn2EuwF+941Hz4GAeyVOVegYSTn5L6O3IvqgjAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766089664; c=relaxed/simple;
	bh=5OKJLAP2sdrK0mbl9eB4owseJTvQf+fNrw38GTn9+yo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ezKgUvVWtglmRxq6QQuC8QimrYK0Icnrx1/7yG+W6dh/LKduCFhcOtgkoZ5rOHIkW3pmxn3juSZ1ZunfEvzYe2MkKp1jFyj23nJyfFY4yv2h2JNx0c0ObGZuaPkHQ19euKei4z6UPyTeLW8RPEzw271spTXHv20Zgh8eUM1+N6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Lzt4noC+; arc=fail smtp.client-ip=52.101.53.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Lzt4noC+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P2wxU8Y9Vn3u5mOBKkWoqDEBIYJmA2qcjnjG5IpjGgUp6p+BXJBWo+55AYVLopKakLXlNrJg8z2S4gSWXt4pot8R+lY4chUGmX2fOLA+me3BFefAYMgwauiUTBZR5u097KTvOyEQY3xyYI0abJ8BLxrKQ9B8PHI4x+6MpZLZzY2t3jKeJL3BdNhVAWdzN6W2JrwWzmQaAWH+zWIuaUI9T617+JeGCKShkLjrHdoyekEzSAVjFMeRQzxoJTdihRHo3D2WhexgrjQ5fKITqrjMqT8bitAKF2AahG9DSfEKSGO9nTeX1csyVhdzl54+86uHK72cmRUfOBpB2Iw4prhTVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3Vo0nHnkyFj7bq/TQ2nAx8LwTdOo4sOOIpSjIpTgH8=;
 b=GmGKDvzd2mBovGI8WiY+2x/sYn/PryG073x1GcEnxI7+dm7p5VL7iUOQSdl8hXLLK3Q7vbempQCs2u5pI+tOyo0TN2rQaTIXa1/BEHZjKmZLrUsXwUCmH2cIV+E4ecMY3AjF8O6dErlSMBMFLqNNBekwDZoyEpNzgn1SKE2Uh0hgYa96ku9Fss7qDI529jcv1oXfhjUl7L2tY3g6p8U93g5MHH6cyjnLQl6PDoSdm+Pzz8UY3aZTDKIo3zE+ACxsCVcRgWgQ1g3guxCCIB2qu1HvwWsjrOp4Zce4ytlvtOlxhn2oCKhKCXI3kR7KqiRg4Vhoi//su/FYO1gJvWCIEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3Vo0nHnkyFj7bq/TQ2nAx8LwTdOo4sOOIpSjIpTgH8=;
 b=Lzt4noC+hZCPMS7GIGzcjQp983BWP802LNKdNflkEJQBS94gRtD6lWo76KDjLYDSIaSeRQd+NAUOhWbf7rmUxSNSue7tirORcSW2RRxvUizF5vIyUiCVrfHqipuXKI8af4lIIw2NNVHAAlEjsY6P7cl5PoQv6bc0WSEjQiBy8owRNrrLAoBHDO03uUXLYYWmytc+zapBZM8ziyO5aNhnPdbcKVATDv6k6H2+meoCnN9eSg3aKV/Quv1kor63nj3Ge29SnjCKXFmax35MmuCJhv9Dqor3BD9uNoX7CYvVlRh13wMtGpp/Mb4D9gYb4SDkW7xsFQbXNhdECRGnOEStTw==
Received: from DS7PR03CA0269.namprd03.prod.outlook.com (2603:10b6:5:3b3::34)
 by DS0PR12MB6390.namprd12.prod.outlook.com (2603:10b6:8:ce::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.8; Thu, 18 Dec 2025 20:27:37 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:5:3b3:cafe::42) by DS7PR03CA0269.outlook.office365.com
 (2603:10b6:5:3b3::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Thu,
 18 Dec 2025 20:27:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Thu, 18 Dec 2025 20:27:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:14 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:14 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 18 Dec 2025 12:27:13 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v1 1/9] iommu/arm-smmu-v3: Pass in ssid to arm_smmu_make_s1_cd()
Date: Thu, 18 Dec 2025 12:26:47 -0800
Message-ID: <afa354cf674fea1a140af48cbd90096fe16cc671.1766088962.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|DS0PR12MB6390:EE_
X-MS-Office365-Filtering-Correlation-Id: fee3961b-c61a-4581-d24b-08de3e73e240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KIZ2Fl6InO6LSii3MeI9UISl8cLhDf7N57Cl1a1K7Zars6cftqLwLEVy77j5?=
 =?us-ascii?Q?xSNQju/oguItXKRXJTqwQiUA8bz5DkE975bhjMqJAQCxT+IKlGKRvRzLEvli?=
 =?us-ascii?Q?ODvw3C+jXMznfHt3FTArKbBD3mH7UYOsjr/NWynHZ1Ut2eViYD1vgThGfuIM?=
 =?us-ascii?Q?cMCnEDWmxHac8l4u8Z3t+xPYzSipm7b/CSLK7gffHsMsiaHdlvQg+lhsY/d5?=
 =?us-ascii?Q?jeznKxw47fiykvWVebVsnEX0+sc8n2Ws4BI85GIlGEinyAx8Cr0uE+XzWSij?=
 =?us-ascii?Q?orXiuBFGp604P7AhISqwQK5yQibmyA45WQd6/0CIuqb2CuZhHmEkZUlypp8y?=
 =?us-ascii?Q?vDwu91NDFEApovX+iwEB2NQbAgwAJ5424Mb3il+uzZ00dKLPTzah/8WaCqHN?=
 =?us-ascii?Q?QAqdFoOAMEjlONtjA+f9fbc8ewkIO+BMuXQCFM3m5x0fFtgluGwP3WLSJ2FB?=
 =?us-ascii?Q?wp4mcSph/DhcOtOZu4M5EKWxzOamXTqaXm0sk109UudoyE2a3xCviHpAU0dF?=
 =?us-ascii?Q?OE/EusV5XXrK9+u7M3R6fMZ7PeEiGbYkqtM/KxmUi6xDHGXpfIccAvvVQ1Mo?=
 =?us-ascii?Q?BkKYDckm40Ym50Qa7n1ZSz9lZdni+MAqchgKhaXtRYM3bPezruuBfPJ4mZKH?=
 =?us-ascii?Q?56QOM7D9kdXpJT4DtzpPHsN6MDZgfs3lbsfLjEyKUq7Aq6LAkG+KSsjaxjO9?=
 =?us-ascii?Q?9L4cX+so6jdrlUjQsKWbqQexEfOK05rQBL5JJOSLTf9uT23dg+XfPR8mHCEN?=
 =?us-ascii?Q?Auk3RtlDtdQAPaz+7cmelvx6zZrMPnm23brUXmC03cXQN1pIg4u2gf14GtKW?=
 =?us-ascii?Q?//E/0owKgdD7lpRlocncdfvmcsflzQIbXdLGIYKtGE8Tt5eYiPbDjz3O/bYL?=
 =?us-ascii?Q?PO785aV5CpeO5VBHS/F0xFdxTAKOnkZsKUuYI5FrX8qzkZGotvzZ7TmFJfaW?=
 =?us-ascii?Q?2W9LScTGOJvdpORwutNem3optApRalU2qiSYpdLTw8F5xw0VJ/sWFYuyn+G0?=
 =?us-ascii?Q?VA/IitUG5TfGjAcnceWcGolBruzPQqIYjW6AfmL88rFT+GpfS93Lok+yv4Wv?=
 =?us-ascii?Q?B13Sraf3YDq4msXQoxLQMrtcVnF/oBdArhcGLSMdFcWEjVncE53zkDyge7sO?=
 =?us-ascii?Q?ewq8UzLxmINQT5+NcH36r5SziM+MsY/cHq6sjJwRf4RTGqCMrqId8o5FdMXR?=
 =?us-ascii?Q?2dnOtdCgXEEFzA26auGOaXU2sQ7WxPCv2Zf66UTfni/ZZu5uiqZt0HxKpNuz?=
 =?us-ascii?Q?QJWba7opuFRk54ssmlBn1G5SHfWpKw7WTcrB1P/mrGRwjfOe98ww0sfcq7RO?=
 =?us-ascii?Q?3ikRVFH1XjJXIG9WLgBx5lHmB5vqdV7vKsxZQUOe+dYeOGFKv4RcDgsyCCwm?=
 =?us-ascii?Q?b8SeZ1gWvKedMYWnaFYxbEVGCOaQ7+BQLrTw7RbqCQszq3husxoQHAHtgLRU?=
 =?us-ascii?Q?5S+ZTnDCV4H10hZ2C/GfCc7Wdp8ACC1VJSubEGl2PtteMBHdrBqo8DJV5cR5?=
 =?us-ascii?Q?EnKdVI0mRq4ne944oLqeiYAjYxHj7OWNGIpTXRh3QbfDE4bfp7oMO8HhB0VC?=
 =?us-ascii?Q?SdbGt6gVMsS+OGeWp9M=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:27:36.9909
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fee3961b-c61a-4581-d24b-08de3e73e240
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6390

An S1 domain that holds the mappings of guest VM's RAM space can be shared
across the passthrough devices, as long as the S1 page table is compatible
with all the SMMU instances that the devices physically sit behind.

On the other hand, ASID is per CD, which is further per STE (i.e. device).
Thus, it should be decoupled from a domain structure and ideally stored in
the master structure instead.

There will be an ASID array stored in the arm_smmu_master structure, so it
needs an SSID/PASID to index a specific ASID to program the CD. To prepare
for that, pass in an SSID/PASID to arm_smmu_make_s1_cd() from its callers.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h      | 2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c  | 3 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c | 2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c      | 7 ++++---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4f104c1baa67..0a5aead300b6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1070,7 +1070,7 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
-			 struct arm_smmu_domain *smmu_domain);
+			 struct arm_smmu_domain *smmu_domain, ioasid_t ssid);
 void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index f1f8e01a7e91..adf802f165d1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -29,7 +29,8 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 		if (WARN_ON(!cdptr))
 			continue;
 
-		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain,
+				    master_domain->ssid);
 		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target_cd);
 	}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 238bfd328b5b..e4bdb4cfdacd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -471,7 +471,7 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tsz = 4;
 	io_pgtable.cfg.arm_lpae_s1_cfg.mair = 0xabcdef012345678ULL;
 
-	arm_smmu_make_s1_cd(cd, &master, &smmu_domain);
+	arm_smmu_make_s1_cd(cd, &master, &smmu_domain, IOMMU_NO_PASID);
 }
 
 static void arm_smmu_v3_write_cd_test_s1_clear(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d7c492ee0936..bf0df16cec45 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1613,7 +1613,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
-			 struct arm_smmu_domain *smmu_domain)
+			 struct arm_smmu_domain *smmu_domain, ioasid_t ssid)
 {
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 	const struct io_pgtable_cfg *pgtbl_cfg =
@@ -3636,7 +3636,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev,
 	case ARM_SMMU_DOMAIN_S1: {
 		struct arm_smmu_cd target_cd;
 
-		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain,
+				    IOMMU_NO_PASID);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master, state.ats_enabled,
@@ -3679,7 +3680,7 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
 	 * We can read cd.asid outside the lock because arm_smmu_set_pasid()
 	 * will fix it
 	 */
-	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain, id);
 	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
 				  &target_cd, old);
 }
-- 
2.43.0

