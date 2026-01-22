Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010052.outbound.protection.outlook.com [52.101.61.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C12534F24B;
	Thu, 22 Jan 2026 01:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045116; cv=fail; b=m09Lgr9DKbr2HDFYHrUdqhTO/bP4T/VoulSu0V9Eg8l9IgRPYuKCGDHc2B0pxfpCT8Pb13JiYB+2h3a8TQ3FiUikr0n7qSbcnmCWhjVuwwZr117+z/qjDm0OJTV9Bdn29H875N7FPiWJoH/viQhwRK7rirtG9OaQK31UjGMY3OU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045116; c=relaxed/simple;
	bh=mPXvfGQgx9L5Hqa2o4d1uQX1MWzghz6UEwMKSlBSoBk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i1pC1pl1eNXKME80lCCj3EFcf9zdkZYAjeQpfEuX8/RCBdLlcfuRciTphNvTZMPfWuMPLlWgmzbP6U/7aXAa3CrSQy1ZgZZ3qjTSCuEKsyob5bQOxsCzJLFAXuzo1FVrAaZqUm2jsh+rgxYdijLXsqB8a33aXEotEN5vfMrVS4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pUViNHHn; arc=fail smtp.client-ip=52.101.61.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pUViNHHn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kdekjNYGxhyTMqavTR6SqPlQ0ixgkPM59mpLHmxIkb/IxBMcHV4kBf+P7apmFA8k0tbtiow9jpcmuguYif4CiD1Ewij9ynUjBmxtfghjnk94EZXEWrVb2UV9ZY/MHBf/PqGaJVNP7Megy80/z3TjYm4M3m2UKJEMcg1fac9TD+Zzm2YtXoNZlJme8HIH0LI34hKJTxZWBncN9hsjvjdhOCcBjFN+n7+qW8zQ14a1epvjZ7XcPZjtYAXMy3KQhhs/O5PrfcC8Tui53ocpp02BiFXAEvK6q7h0iZA+UCAutKBNWNz8V/2JWVhMxqHQ02ikkjsQibW8rbyTG1sG1kmjGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YMwvRPFJq0wOCLf18QflpQOjqT0FuMK8M7XVLyvccM=;
 b=hGz07veJ8Oc5OlhbHjSGHhBXXLVVYVOlWWgC0iKxOxkCydoHcE5lTcN86lzWYvnnSe0WSOxH/8NbNiiyjltg5IgnBwWWl6L/bt/IOTnQEOyzL511qH7gTuQ1Z/4om6XzjxQ7GG7ua15nR+pkL6497F+1A2TQZWV5tR//97UXt0gt3QopRKOgPubLVbl+ozXcLgb40JxMLTbee7msGrX1cna1aXDvtWMeBgPzcS1/lYeYWVncr2v1tZZOXEGdi7+mDrtyqRDfmORVWFr2ZwsxOAB4z3v+Yz/UOQny/udtmpk1LUCKYQbexKew/X3zWb24c+WmSnUcsp8CgXB75bm7cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YMwvRPFJq0wOCLf18QflpQOjqT0FuMK8M7XVLyvccM=;
 b=pUViNHHnIh8KINqGiPCNgqzjyWTeLjhXouUFcVqL2JBnx0anRhNaJoqg4NLKx/us2KDdeRIluOVb0tQF+Z4Jx5TC1yGGrA9G+a6ZIDPVIFugPD6AqjSui2c/PKWl18e/CejmlaJUfBhBHmOqGj4aKPuj/2yVkJAon59eGGVerT7yeKw9vrgIVzV8rqNrhRzgD96EMHZ75KIOmSAE9/J87PPuSxWCCXhote15NN5IsLhoFdUzrzuw1Y94UnQ2yzrERMFOFc+/6ed4Kk50xxB3HGzDaiKkYKhrTRv95udm8cSuV3NRJRRq5khwbJZ14SFWFTpgNdddOnP3bwDhls5vZQ==
Received: from SN7PR04CA0120.namprd04.prod.outlook.com (2603:10b6:806:122::35)
 by MN0PR12MB6248.namprd12.prod.outlook.com (2603:10b6:208:3c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 01:24:53 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:806:122:cafe::20) by SN7PR04CA0120.outlook.office365.com
 (2603:10b6:806:122::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 01:24:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 22 Jan 2026 01:24:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:43 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:43 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:42 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 07/10] iommu/arm-smmu-v3: Pass in vsmmu to arm_smmu_domain_get_iotlb_tag()
Date: Wed, 21 Jan 2026 17:24:25 -0800
Message-ID: <813abd4f054c21f1bdb4c26999ecb46eb54f266e.1769044718.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|MN0PR12MB6248:EE_
X-MS-Office365-Filtering-Correlation-Id: 486c61cc-5836-46cb-0ca9-08de59550b38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pjTPc1OXKgUAr8euzYqUfJI69Sbel4633c9ceCU60QEtvwUaEtIdoBFGHZqU?=
 =?us-ascii?Q?LJwya++wTtkUqkxJgyyTjCpdEtqvSr+opzIpNz/sYuKZj9hfrxi5qXP+1Gpr?=
 =?us-ascii?Q?0wjL2S1mKRlrSllfWH2PK8iibU+GReLXLKkTaqblmIFhH3eNpOIVBofY89bh?=
 =?us-ascii?Q?fbow/2QiZPf1BdDQqVQS30T+f8E++KK8Y71weNmz1Xp+N+GsFIXihQRGIrNi?=
 =?us-ascii?Q?ptdndbt5auTH3/mt+28H4c6DKi1vPaA1QhRQhboZ3vjRgL27LYE3WgyUg/pv?=
 =?us-ascii?Q?PkEmuUykuH3GLYTnSeN9TryO8NDQRqOo9b/rNWRlxWlPgLtGqrcRJNPGdSxC?=
 =?us-ascii?Q?hF1uQqarJgEqrJW3auVXvgp537kr9v3Esj32BXqK/VY2QP8/AY+jM//mEajo?=
 =?us-ascii?Q?9vhZGBc8DIUsEYystdN4lmH8Q8ANfabaGl1gUV+H0smOPYjOVXJI6OR/2Qx5?=
 =?us-ascii?Q?1PNTrGPKRA7E4FTj4tFv1O4ajetNj1aQ/QtITdJ+CxnPwSYOeW2rjKyfSB3o?=
 =?us-ascii?Q?KeK8710scQPxzNt5wjgNQTPn/YtYLp26ULtqUrU4sy0EClPOR4w4muLNSPM/?=
 =?us-ascii?Q?uOQSgLaE8gTdgSgBpBVHF4vFlaiR9YXf9JSV3sPnOmOJNzU3YvVsaLOgJkNp?=
 =?us-ascii?Q?ZlhhotoQNuBzL0RhkLvwnW8NbTX8MFcpTEKIn15Z11AizEHCCAS2nS0uD6tw?=
 =?us-ascii?Q?zvNzWMCg879PeHGobr2yqJeGAxWNJRozpYUyuuU5Q16vG70psPu1wAsdLPZs?=
 =?us-ascii?Q?vLdaBbT4GK2nJA6P7PZa3gWCXlAPCVGN45kbsA2HI0eJgH7sLhrEzWjphX+K?=
 =?us-ascii?Q?iNhjDueBulsi1nD0shgq1bOZr8cdavP1GNCweuXqX0l2sRSIqxEqpYxFgg6Y?=
 =?us-ascii?Q?NSOYlag1RQC7EvK88IaKgnoanrTgVkW6NwzYCS0kHQUCXboOQ2brvey17inr?=
 =?us-ascii?Q?gc81FlMoxxHQ8966tt0bl4ynnU6WcsRFdW8lgHhyFkJ7GZUQIk86zwkq71oX?=
 =?us-ascii?Q?nGVKIYiSBUYGyrZvqCWCCM+tJHkWQO/cJMq7r6og87WHIdSG+xh5aYKTfvWh?=
 =?us-ascii?Q?MXi9zlSOSuKUjwcGfZrUM+uZpPypnDAqTSBs5TtSuUDVWvr5CX6j2MhsugaS?=
 =?us-ascii?Q?oYd26dxQTj9DWD1b6smaE7mdYIJHqwOR/u0+3Vh8pKyUnO/EsN7pbaAvG4C1?=
 =?us-ascii?Q?n5gT+49e1esFlGEuZ183wOzmG+l0A0cgwiJ1leDIAEkbdzhIiHjKm/o6YQgx?=
 =?us-ascii?Q?Sk+R1ZIrcKElz6Po5jw5JsqGk6RXrkP3kY33ueuUKKv170oQD5Ng+Z2Z5Z3m?=
 =?us-ascii?Q?EsdvBKjgOW+KaFlcmJ15PcKvcj4G0kuWTDydQW7DdnAa3R2JifZA1kDvAZGm?=
 =?us-ascii?Q?uajtbGd+g7AwMIgMikLu1X/2WNmqolSuL2Jty6RemDoqc5nE74IEvhxGqoL4?=
 =?us-ascii?Q?jQCf02InX2K8rN6hnPv2c1DEt6s/YEYkPWU+aS8zPzszNLIsPhOO4iQpdxHg?=
 =?us-ascii?Q?13ZsnM+AH2MAu72ZOuenSsGj1XK3cImAzWJXyPRYhKDv5oWzpj7A7GqNXbSY?=
 =?us-ascii?Q?l4JbRHj+xbJL96zlhUWzPdCU7TPPGC9G1knlRsKFEzA1ssfAr3Gr6b2N1Tq4?=
 =?us-ascii?Q?XHZvfW+HuCMFiWuh7f0s6lAxZDc1SCrZhKV3JqC6+9B+mAABm58LYaPvfDDW?=
 =?us-ascii?Q?HZMtqQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:52.7215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 486c61cc-5836-46cb-0ca9-08de59550b38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6248

When a device attaches to a nested domain, VMID is held by its associated
vSMMU instance. So arm_smmu_domain_get_iotlb_tag() should return the VMID
from the vSMMU instance rather than allocating a new one. Pass in a vsmmu
pointer to arm_smmu_domain_get_iotlb_tag(), to prepare for this.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h         | 9 +++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c | 1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c     | 4 ++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c         | 7 +++++--
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8aecdbceb974..386ac75879c0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1124,6 +1124,7 @@ struct arm_smmu_attach_state {
 	/* Inputs */
 	struct iommu_domain *old_domain;
 	struct arm_smmu_master *master;
+	struct arm_vsmmu *vsmmu;
 	bool cd_needs_ats;
 	bool disable_ats;
 	ioasid_t ssid;
@@ -1136,6 +1137,7 @@ struct arm_smmu_attach_state {
 
 int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
 				  struct arm_smmu_device *smmu,
+				  struct arm_vsmmu *vsmmu,
 				  struct arm_smmu_inv *tag, bool alloc);
 
 int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
@@ -1182,6 +1184,13 @@ struct arm_vsmmu {
 	u16 vmid;
 };
 
+static inline struct arm_vsmmu *to_vsmmu(struct iommu_domain *domain)
+{
+	if (domain->type == IOMMU_DOMAIN_NESTED)
+		return to_smmu_nested_domain(domain)->vsmmu;
+	return NULL;
+}
+
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
 void *arm_smmu_hw_info(struct device *dev, u32 *length,
 		       enum iommu_hw_info_type *type);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 9998871f69a0..33b336d494c3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -162,6 +162,7 @@ static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_attach_state state = {
 		.master = master,
+		.vsmmu = nested_domain->vsmmu,
 		.old_domain = old_domain,
 		.ssid = IOMMU_NO_PASID,
 	};
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 5c8960d31a9b..461ccf4bdb03 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -31,7 +31,7 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 			continue;
 
 		if (WARN_ON(arm_smmu_domain_get_iotlb_tag(
-			    smmu_domain, master->smmu, &tag, false)))
+			    smmu_domain, master->smmu, NULL, &tag, false)))
 			continue;
 		if (WARN_ON(tag.type != INV_TYPE_S1_ASID))
 			continue;
@@ -171,7 +171,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 			continue;
 
 		if (WARN_ON(arm_smmu_domain_get_iotlb_tag(
-			    smmu_domain, master->smmu, &tag, false)))
+			    smmu_domain, master->smmu, NULL, &tag, false)))
 			continue;
 		if (WARN_ON(tag.type != INV_TYPE_S1_ASID))
 			continue;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5a7032081553..8323f74c8923 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3137,6 +3137,7 @@ static int __arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
 
 int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
 				  struct arm_smmu_device *smmu,
+				  struct arm_vsmmu *vsmmu,
 				  struct arm_smmu_inv *tag, bool alloc)
 {
 	int ret;
@@ -3360,6 +3361,7 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 	 */
 	if (new_smmu_domain) {
 		struct arm_smmu_inv_state *invst = &state->new_domain_invst;
+		struct arm_vsmmu *vsmmu = state->vsmmu;
 		struct arm_smmu_invs *build_invs;
 
 		invst->invs_ptr = &new_smmu_domain->invs;
@@ -3368,7 +3370,7 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 			lockdep_is_held(&arm_smmu_asid_lock));
 
 		ret = arm_smmu_domain_get_iotlb_tag(new_smmu_domain, smmu,
-						    &invst->tag, true);
+						    vsmmu, &invst->tag, true);
 		if (ret)
 			return ret;
 
@@ -3387,6 +3389,7 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 
 	if (old_smmu_domain) {
 		struct arm_smmu_inv_state *invst = &state->old_domain_invst;
+		struct arm_vsmmu *vsmmu = to_vsmmu(state->old_domain);
 
 		invst->invs_ptr = &old_smmu_domain->invs;
 		/* A re-attach case might have a different ats_enabled state */
@@ -3398,7 +3401,7 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 				lockdep_is_held(&arm_smmu_asid_lock));
 
 		ret = arm_smmu_domain_get_iotlb_tag(old_smmu_domain, smmu,
-						    &invst->tag, false);
+						    vsmmu, &invst->tag, false);
 		if (WARN_ON(ret))
 			return ret;
 
-- 
2.43.0

