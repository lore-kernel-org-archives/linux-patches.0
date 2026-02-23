Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011015.outbound.protection.outlook.com [52.101.52.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E0437757A;
	Mon, 23 Feb 2026 20:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878546; cv=fail; b=fgDsEcxxC3D/94bcsiSquHiIwXnZ68YGzRmP4SzWrUqYJzTbrgCzVMv6QznTOKAfhLcBAmEUvh8KLVMtnNisMEnrYlJySVwrbRW1ZQfDGBdtVI05aNP+L7o6Sgrgy8jhxBVz+Ef2ikxb+k3M/PXovuwusJMXtb+ayBPe7UIi2l4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878546; c=relaxed/simple;
	bh=qAMY+rTAnvGMOlTr6ZxlLYw8U9Mpi/VBd3zAz45KKNw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebUBzzlAyCfajdxtHMQvYjZFFrl5Qu0jEJ40GBrS0gcmkMzUL3wM/nP0JP5aQyGNX27OM3WeoK1ZPBLanSX5SL4/41FWx6QLx4Fqd3WD/wbhAyoyysCgOhH6ZqRhoivOSKZGW965oQSbptYAaZfTOP3cTuBRhD9O8UH2ZrYhWCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nReeyk2V; arc=fail smtp.client-ip=52.101.52.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nReeyk2V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wpm6p7T9YK2mL/92u3pYxkiXFqutYU54t1AlrMwYFwC3qyibPeeL2MWVpLEKaGwVTSHIn2kdfDX9YHVkjrqXJ4dAZYKSAGTzQ0w5ufOi73Qmd6LsNvUa/IEwM3FAUkt9no5DnVbufWucZEwCDbLOl/4i2Oe0l/3VLm4ot3jq5WeZTw2GeqgkpzPcrQlbTjxLnaAUbvzFicS++c0+DNpti4uuNzgVjMKN3a5swfVcUQLa60eeeGc9qA76DMyODYZhV4bvDXQIfs/vCPauk8rCc0IIfSgNw/0AM9QTYh0lPZfwVrl7b0hav4Axy1z+W7golAb9KI+Ramb/Y6iWjAP+/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Jb70Ji6WMl8a5vtKsjU/eqH4es20064dVCCqJvDNGI=;
 b=Hx4R9Us9mclUoEhrpshCQUsCBqAafsU/fSHp8F2ffCmyfK2+qPY4hGsFp+fO2urWKz6/zsEzMwDj4kxvrhXQ/GFXz7AKv43zsTl7LC1kfT1Bn608mvW/sTZsIxFtwPiXC+5TaZQ8udZvUo2GoRbGMz00cNvbxkBYTaKQQsd4X8VvVVEOwVxbrKRA7lfVsKiMvCcXR8+HqqJHxJdecraFpFV+gJniyGm2jfzNukxiUqYszpnjDBkmgAKFuypkT8OpXeK1+RMLTpwp4X32lK7vBhkY949j9xj7ULJc57QaWLO/tj3X0Jg+QBcinEKfp4HnaLolDzdftSHNYrh+MOfOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Jb70Ji6WMl8a5vtKsjU/eqH4es20064dVCCqJvDNGI=;
 b=nReeyk2VjYScYIE8PSMT1bCmq9oqbyo843gbbL4s9yVA8UdSv7BmhMa+7zGl5dd9OTGoBmG7KklzSkH8KLdVnUX7+aOZYZdaO4f4gLqlvcafDRrmHr7jzXdGqe1E7C55voHGeYsdN59yqRvw2KFtAAARlyAq8mu/1eYNOUXiE8bugWho07mKcUUyPYZ3BYv2pU7lHIwMrUaMGSaQL9ugWukS6qZbZ0+NonVvOOOHg85P9KLvK0LanvuRhCk0y5IJsyA5rmOpID1f2DZGA/OUVOYrl4KTPhA6C0GxwMnV3QIyhbt7/NfxL3B29/enyNidRCusZa1GbX42AIF2sdSP+A==
Received: from CH0PR03CA0263.namprd03.prod.outlook.com (2603:10b6:610:e5::28)
 by LV8PR12MB9357.namprd12.prod.outlook.com (2603:10b6:408:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.19; Mon, 23 Feb
 2026 20:28:43 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:e5:cafe::66) by CH0PR03CA0263.outlook.office365.com
 (2603:10b6:610:e5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend
 Transport; Mon, 23 Feb 2026 20:28:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:25 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:24 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:24 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 05/10] iommu/arm-smmu-v3: Pass in IOTLB cache tag to CD and STE
Date: Mon, 23 Feb 2026 12:27:41 -0800
Message-ID: <c55b310e51f0c5ddf31f41537fd8ac54eb16c178.1771877893.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|LV8PR12MB9357:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d87a188-4ebc-42de-1f8e-08de731a230d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Cqf51DhEgulKTlUK323WMj8+ZJefkg/b0Sl/f0Uytr9mU9aOivd2w+TzIMz?=
 =?us-ascii?Q?HepWnQFoQCr66ZHDWALIPMv+w63r1ubeO2y3LLBkc6gMd5iAabBkGrCuP3+U?=
 =?us-ascii?Q?X/Hj7YP6DP1VLHYQScMrpCTFy0JoGxTgAcVQJuaH+JNW5rK2Kvho7fe/hS+M?=
 =?us-ascii?Q?eZ0DW5l6bBYEzmW5YqY3Y7uNeYudlD445IaLPJpAXUBSRllBkXwkg994pHdt?=
 =?us-ascii?Q?5FZO7fCs3bXqMDvgeTj9fLf6qRdm+c6zi/JUx8tV1VOkpmSDDVfNUSUG8Ow7?=
 =?us-ascii?Q?Q7QoX1OASL8HF+RhgYiRa+tSNg4SPqdVv6M2PYsl1ywfqiii8S9rabqgUvec?=
 =?us-ascii?Q?b71BS7vta+tjKYyT4SHjBlV7Zt+ZTEGNGTsYAUniztZlTjMlw2aVk0cKRhvr?=
 =?us-ascii?Q?uq2Zr12MQGireXgJt9O9h0jtHWa9G7DVdJ1ULWb4AUXigO3/aKZOWsRpQil7?=
 =?us-ascii?Q?2hQbz2MOau2g8MbI5dImy7duIsvgz17znrw+NQaG9QlqWxUpkAQVD1pfR8yM?=
 =?us-ascii?Q?baCkx3KkNMiPcG1dV1OtS3QWw7tDqiLA7OQci8xDVDnqH8BVa6ArNtm03zfZ?=
 =?us-ascii?Q?MQVNRd++c6c00mJU7DI+R4AVKHKFIKMa02K9be+qL58mA9SAk68c56X6RZM1?=
 =?us-ascii?Q?zardQDrBf80aRM0NbGSE91b4spRbwtloOtMCW6xRvkub9j8WFl0G7Z+x9vcG?=
 =?us-ascii?Q?lQDbFD65bpVIYADNXm7z7T103kr3RcOrfwU3c3zaQzw3PcacxxBYAV31opC0?=
 =?us-ascii?Q?ARkWyWADH3jXCVdXT+5/ZHv10eKZGSRU5G2M4jlAcUMvdLq9/3LfpCG3oyP4?=
 =?us-ascii?Q?PXR33z01QbdXW9qqsS5rB4d5Cqni1Dj9fn1698EV6ddF6FNSvZa/5ZdFUebG?=
 =?us-ascii?Q?1R1LQXNT+2LQkII1LQKo5vRStjQHwauyItu0lXZtuQ9mKiVE/qhOpC9a6SVg?=
 =?us-ascii?Q?XFipgfHy8/m08I9OInumkc46W3bgU/d2hmdQQGZE3/y7GzmDlrPJcOvZTP1h?=
 =?us-ascii?Q?ZFJeLMqAm72JGsStcb8bdm8XhenzKGBHOLXzGSg4zpzigxXYbeaRrGQxSmWK?=
 =?us-ascii?Q?aRym4IrTgOuEWhPSwrZd1yRw9bJqPdWicxiQEhRy0ukUv/os4nIy9uQLjzom?=
 =?us-ascii?Q?GSjeQmXEHECo99Mpz8W7Jh0VLNI1kM4ICB7sljQgOj4yYd1kMXxxP4kUpirz?=
 =?us-ascii?Q?/3hCsAPFEA369gKeSTEjufuQPGlnDL4CGHeTx/ty/VtwFpDnUUsx/OL4fcZO?=
 =?us-ascii?Q?JLRwIyfpTsBpjoNlD5jF/JntiNiK1YjOSa98TnuqXXzUn8w3ZfT6gsveeZCS?=
 =?us-ascii?Q?Vmnzv4HSMEA3DAYknoOUswJOCZDw/CtjHWKhyKac+rTYjc+NOJvFh8aU+zTx?=
 =?us-ascii?Q?tZG5Zgzq7Xt9dWCpDuRLcv6ftxU++f/SmURPoYqBS+js1fal74cWGBb3hbUE?=
 =?us-ascii?Q?pN03A0Bbod8pkPBp1/OvBXcKtkcSOdse3NDtYKs/h7k7KSp/oAU1Wb5LRLD1?=
 =?us-ascii?Q?yeiAagV11B3/79Z9XzA0yJ7/za+4M3xpnPgTodmwUaeOHpnCLfsdG42q4wPx?=
 =?us-ascii?Q?bENtILohH59lyo7z94PPeGH8I8SGe5mjaUtpwL+AvxGXVrb+PPv9M4XcACFW?=
 =?us-ascii?Q?yTS6WyvqT/M9WxyQgOXYNsWkcFePrbfUIZQqdoMKWGH7nb9xlvso+hXq/840?=
 =?us-ascii?Q?TVjt9w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7lroStDJDYRx0FxXa4xkzeDG/1ac2JyyAqD+9rjZzwV9q08zr324N8Ev9QcufRAz/K4P98Ql2Wgnxuc9jwvXxrrQsnzmCoWzY4qV+qgMeM8GbdLpNYhqiR2QiPTqJumNVTfSneV33f0FjJCvzWNOXapMCFQBQWL6bcTdNLL6JPO9Cp7ZwjXW5JxYP9RVtBTcWUIQzhFgS3vNKPb1mDDZndwfSHRNm2LnWEoBc/pFpgXSMpXbKF0fbTNEzAXFZfp7vbljVY9eG9UoQuGo4Ht0aFMnDQjQBTXCAigjs7xypwEvepw82Apm8VsE9fy2xNI0FuRnWW7OzlXUuXnhY//E0r9OK8FIgQGDPwzbEr5WAgVfVdgdfNaOFaqX2tPstVllbQddWT6p18ipsbcH30jj0jZwTPy80RstiADTuz5nxGfeQxGuuylrC9e5lmpBilTo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:42.6454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d87a188-4ebc-42de-1f8e-08de731a230d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9357

Now, struct arm_smmu_attach_state has the IOTLB cache tags.

Pass them down to arm_smmu_make_s1_cd() and arm_smmu_make_s2_domain_ste()
to set in the CD and STE, removing the uses of smmu_domain for ASID/VMID.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 +++---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 26 ++++++++++++-------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 23 +++++++++++-----
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 12 +++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 22 ++++++++++------
 5 files changed, 62 insertions(+), 29 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 11b61a19e6e53..3b91e4596ffee 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1010,7 +1010,7 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
 				 struct arm_smmu_domain *smmu_domain,
-				 bool ats_enabled);
+				 struct arm_smmu_inv *tag, bool ats_enabled);
 
 #if IS_ENABLED(CONFIG_KUNIT)
 void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
@@ -1076,14 +1076,16 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
-			 struct arm_smmu_domain *smmu_domain);
+			 struct arm_smmu_domain *smmu_domain,
+			 struct arm_smmu_inv *tag);
 void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
 typedef void (*arm_smmu_make_cd_fn)(struct arm_smmu_cd *target,
 				    struct arm_smmu_master *master,
-				    struct arm_smmu_domain *smmu_domain);
+				    struct arm_smmu_domain *smmu_domain,
+				    struct arm_smmu_inv *tag);
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index ddae0b07c76b5..a77c60321203c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -39,12 +39,15 @@ void *arm_smmu_hw_info(struct device *dev, u32 *length,
 	return info;
 }
 
-static void arm_smmu_make_nested_cd_table_ste(
-	struct arm_smmu_ste *target, struct arm_smmu_master *master,
-	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+static void
+arm_smmu_make_nested_cd_table_ste(struct arm_smmu_ste *target,
+				  struct arm_smmu_master *master,
+				  struct arm_smmu_nested_domain *nested_domain,
+				  struct arm_smmu_inv *tag, bool ats_enabled)
 {
-	arm_smmu_make_s2_domain_ste(
-		target, master, nested_domain->vsmmu->s2_parent, ats_enabled);
+	arm_smmu_make_s2_domain_ste(target, master,
+				    nested_domain->vsmmu->s2_parent, tag,
+				    ats_enabled);
 
 	target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
 				      FIELD_PREP(STRTAB_STE_0_CFG,
@@ -64,9 +67,11 @@ static void arm_smmu_make_nested_cd_table_ste(
  * - Bypass STE (install the S2, no CD table)
  * - CD table STE (install the S2 and the userspace CD table)
  */
-static void arm_smmu_make_nested_domain_ste(
-	struct arm_smmu_ste *target, struct arm_smmu_master *master,
-	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+static void
+arm_smmu_make_nested_domain_ste(struct arm_smmu_ste *target,
+				struct arm_smmu_master *master,
+				struct arm_smmu_nested_domain *nested_domain,
+				struct arm_smmu_inv *tag, bool ats_enabled)
 {
 	unsigned int cfg =
 		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(nested_domain->ste[0]));
@@ -82,12 +87,12 @@ static void arm_smmu_make_nested_domain_ste(
 	switch (cfg) {
 	case STRTAB_STE_0_CFG_S1_TRANS:
 		arm_smmu_make_nested_cd_table_ste(target, master, nested_domain,
-						  ats_enabled);
+						  tag, ats_enabled);
 		break;
 	case STRTAB_STE_0_CFG_BYPASS:
 		arm_smmu_make_s2_domain_ste(target, master,
 					    nested_domain->vsmmu->s2_parent,
-					    ats_enabled);
+					    tag, ats_enabled);
 		break;
 	case STRTAB_STE_0_CFG_ABORT:
 	default:
@@ -187,6 +192,7 @@ static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
 	}
 
 	arm_smmu_make_nested_domain_ste(&ste, master, nested_domain,
+					&state.new_domain_invst.tag,
 					state.ats_enabled);
 	arm_smmu_install_ste_for_dev(master, &ste);
 	arm_smmu_attach_commit(&state);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 4370cb88c57cf..846a278fa5469 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -24,12 +24,18 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
 		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
+		struct arm_smmu_inv tag;
 
 		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
 
-		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		if (WARN_ON(arm_smmu_find_iotlb_tag(&smmu_domain->domain,
+						    master->smmu, &tag)))
+			continue;
+		if (WARN_ON(tag.type != INV_TYPE_S1_ASID))
+			continue;
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain, &tag);
 		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target_cd);
 	}
@@ -124,10 +130,10 @@ EXPORT_SYMBOL_IF_KUNIT(__arm_smmu_make_sva_cd);
 
 static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 				 struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
+				 struct arm_smmu_domain *smmu_domain,
+				 struct arm_smmu_inv *tag)
 {
-	__arm_smmu_make_sva_cd(target, master, smmu_domain->domain.mm,
-			       smmu_domain->cd.asid);
+	__arm_smmu_make_sva_cd(target, master, smmu_domain->domain.mm, tag->id);
 }
 
 static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
@@ -166,12 +172,17 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
+		struct arm_smmu_inv tag;
 
 		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
-		__arm_smmu_make_sva_cd(&target, master, NULL,
-				       smmu_domain->cd.asid);
+		if (WARN_ON(arm_smmu_find_iotlb_tag(&smmu_domain->domain,
+						    master->smmu, &tag)))
+			continue;
+		if (WARN_ON(tag.type != INV_TYPE_S1_ASID))
+			continue;
+		__arm_smmu_make_sva_cd(&target, master, NULL, tag.id);
 		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target);
 	}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index bf4412e904b01..c0cdded058fc8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -347,6 +347,9 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 	struct arm_smmu_domain smmu_domain = {
 		.pgtbl_ops = &io_pgtable.ops,
 	};
+	struct arm_smmu_inv tag = {
+		.type = INV_TYPE_S2_VMID,
+	};
 
 	io_pgtable.cfg.arm_lpae_s2_cfg.vttbr = 0xdaedbeefdeadbeefULL;
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.ps = 1;
@@ -357,7 +360,8 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl = 3;
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz = 4;
 
-	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, ats_enabled);
+	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, &tag,
+				    ats_enabled);
 }
 
 static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
@@ -502,6 +506,10 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 			.asid = asid,
 		},
 	};
+	struct arm_smmu_inv tag = {
+		.type = INV_TYPE_S1_ASID,
+		.id = asid,
+	};
 
 	io_pgtable.cfg.arm_lpae_s1_cfg.ttbr = 0xdaedbeefdeadbeefULL;
 	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.ips = 1;
@@ -512,7 +520,7 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tsz = 4;
 	io_pgtable.cfg.arm_lpae_s1_cfg.mair = 0xabcdef012345678ULL;
 
-	arm_smmu_make_s1_cd(cd, &master, &smmu_domain);
+	arm_smmu_make_s1_cd(cd, &master, &smmu_domain, &tag);
 }
 
 static void arm_smmu_v3_write_cd_test_s1_clear(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4649368910e0c..aa00c7cd3503e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1687,14 +1687,16 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
-			 struct arm_smmu_domain *smmu_domain)
+			 struct arm_smmu_domain *smmu_domain,
+			 struct arm_smmu_inv *tag)
 {
-	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 	const struct io_pgtable_cfg *pgtbl_cfg =
 		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
+	WARN_ON(tag->type != INV_TYPE_S1_ASID);
+
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -1714,7 +1716,7 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		CTXDESC_CD_0_R |
 		CTXDESC_CD_0_A |
 		CTXDESC_CD_0_ASET |
-		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		FIELD_PREP(CTXDESC_CD_0_ASID, tag->id)
 		);
 
 	/* To enable dirty flag update, set both Access flag and dirty state update */
@@ -1971,9 +1973,8 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_cdtable_ste);
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
 				 struct arm_smmu_domain *smmu_domain,
-				 bool ats_enabled)
+				 struct arm_smmu_inv *tag, bool ats_enabled)
 {
-	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
 		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
 	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
@@ -1981,6 +1982,8 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 	u64 vtcr_val;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	WARN_ON(tag->type != INV_TYPE_S2_VMID);
+
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
 		STRTAB_STE_0_V |
@@ -2004,7 +2007,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
 		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	target->data[2] = cpu_to_le64(
-		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
+		FIELD_PREP(STRTAB_STE_2_S2VMID, tag->id) |
 		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
 		STRTAB_STE_2_S2AA64 |
 #ifdef __BIG_ENDIAN
@@ -3767,7 +3770,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev,
 	case ARM_SMMU_DOMAIN_S1: {
 		struct arm_smmu_cd target_cd;
 
-		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain,
+				    &state.new_domain_invst.tag);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master, state.ats_enabled,
@@ -3777,6 +3781,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev,
 	}
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
+					    &state.new_domain_invst.tag,
 					    state.ats_enabled);
 		arm_smmu_install_ste_for_dev(master, &target);
 		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
@@ -3869,7 +3874,8 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (ret)
 		goto out_unlock;
 
-	arm_smmu_make_cd_fn(cd, master, smmu_domain);
+	arm_smmu_make_cd_fn(cd, master, smmu_domain,
+			    &state.new_domain_invst.tag);
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
 	arm_smmu_update_ste(master, sid_domain, state.ats_enabled);
 
-- 
2.43.0

