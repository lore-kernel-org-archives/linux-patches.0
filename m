Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010060.outbound.protection.outlook.com [52.101.56.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CBA15CD74;
	Mon, 23 Feb 2026 20:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878537; cv=fail; b=QhrjlUQH3HUqRckFFcxiqX57OZzttY/YRtLOnHs9z4Xsp1ReLK1yEK2FkJZMsWhf5MRp4Z5dX82/dG8FNPwZg8dg/0JRXbIFz/yUfCMpj1vAw41ozuVzFdeGbcrxqMFH4c4ZrnpDnSVg+ssb+hfU7inuIWWxiHrwRwzcsS2uKbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878537; c=relaxed/simple;
	bh=6Nw8bvEpnFshxmOIGmFpc9/UPZAPV5hXrd9+DvZpcqs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGbMHx6oLm3hKDqmbWtIGwz7zqYP2ikL8bRjhjtQYfbplO321xbbCzR6Mc9en6AcFieOuDv4qBQbps4xXVIjvudZiFaavc91cOA4Yo/eQ+NV8CLZPvtIV/ao5LsT7qX/bYqdlToN0ePDdjvUMOFhspYKEZRHiYYAzqTEJkad9b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Lz1rwxZv; arc=fail smtp.client-ip=52.101.56.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Lz1rwxZv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KE7JVsI+IvfguoQeMnih3ahUiPZnckiJcQyDbjh0KzkTGtoWkqZW01MvtFl9nS6oaHA4Xs4BzruEApYJNI606/HuHkO18qJPcZ+38Bt9iqN7K2BdzDRGvbUDW/aYaMPQHw4gfuR4u0K6X/Df+bVka7qRkx1oP4frnEZ26R2dzMf2UKDQsBx5KiLT2RJkPePLp/JD7dpq6M/aSPshrbU8dRSQ/dYlrX68XEnfk4kd6k4ryGL6mViAFqiJlPeSmUpQJiGu4pmVwFASU96MUmNNVq3ExDTSPtzXISlmCUBP074y+0WK4uuqGEMO1knex9IMVMU5Z4Tc+6VMlq965CjRpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5He7eQ8wORpimEvUjWfJVwWA7i3E2+VVq2HxTBUtHdk=;
 b=v6c1zVXKxj7teVi7xQ6ZdkLpA+R0TQcG2cMKXvSsMIm/FQGYObSvKxdo3fMoGXIX+k4EfV46naLnJNKHigcs32Xooee37V9EmNz4EatRXlZChSULXHXMOhXM39tfOkAmDcaOYgCDA9SX73kB/2mQtNYSqy21Fj/VuyUu02K2GWtbwyUjLe+Etpo8BMXfhvBRoy7YKIUUSpWHHFjDvWz7gvKtAQb0HXrXdlfA9l6DjzEKW8otQoaKaOBGHRtZHk5hyaVk+L9T/cMfU9qoZEbyls7ItRE4sLJ6ASHQUo6e/dho0h/e8hZ6pLO2Ix7VQ6V/JzWk9RoIJbXgw2Bb9OtwRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5He7eQ8wORpimEvUjWfJVwWA7i3E2+VVq2HxTBUtHdk=;
 b=Lz1rwxZvubIQV51i+pQMs5p48kbJTMh4BpI2izeyPRSECGQKKQpQ3mMqLi6efgjfxsdtU5R01Csz7uPgtMKxxUiE9K85leQqj7tBN+CkZcQy2GMH7OW6OhzhYDv2Amsjc1ppNV7hIS5CEfKEwjwTz40sIQ1htWXvo9piS0pyteENUd9hQ8DWaOSuG9T7geecXP3BDhIvf3RYwWX/uPuUbwJXA6xphppnd8ncfx6pT8yHl9irVoqKiM37JMYb1cKK9+gjE1UDQ+hfdl8aNAeFZXcEwwRYc4ZmFzeA4lrvzw+76oyND98C+MSzw3CO/TlQnFu0vFtVBiXCJ/8CdYxYKA==
Received: from CH2PR14CA0001.namprd14.prod.outlook.com (2603:10b6:610:60::11)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:28:44 +0000
Received: from CH3PEPF00000009.namprd04.prod.outlook.com
 (2603:10b6:610:60:cafe::92) by CH2PR14CA0001.outlook.office365.com
 (2603:10b6:610:60::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 20:28:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF00000009.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:26 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:26 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:25 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 06/10] iommu/arm-smmu-v3: Introduce INV_TYPE_S2_VMID_VSMMU
Date: Mon, 23 Feb 2026 12:27:42 -0800
Message-ID: <0dfce70dd16501127fd1213dd7d2511d6ab17386.1771877893.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000009:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 0655fc21-6690-4205-8f76-08de731a23c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f9+82xRojSeRwMPblv6mieJ2uMYf+nY2Zh2KYSjGoA5NDd6PpIDZdN2wMVUR?=
 =?us-ascii?Q?6iwJ96OJRGmBm0nVZpQ/zLu5C1x6kVJAwjrzmxZH0AZ2XQfFmDjKCHwOkSlE?=
 =?us-ascii?Q?hwoFELCBj6r+VtgMrh1CqTHPPgqy2i7kHEwDij1Iyz6TJ5lhaV7zoczHBNBV?=
 =?us-ascii?Q?huFiK0HGjUrxkZMbooikHmydC8ZMBp5YrzCmlx+F1M+zBcVkVY73cIaOsbU2?=
 =?us-ascii?Q?vblKdEqtjFAFMoBiaJDmzeR4q+ojxTvkoS+Aw5dE+acyhvH9nHFWe4GYM3/m?=
 =?us-ascii?Q?ESFRd1FIKYRNAGfRhWp81YGAP8q509W+4U6PS1Fn+k9jSvU5CTuJS0Rjg5kX?=
 =?us-ascii?Q?i0138esADBSf5Z/43va3nGz+IESzLdo6ubSeWtICWPD71/Lplvug6/AyEbjk?=
 =?us-ascii?Q?lBF/4ZTxmAc2mnxtcpZZfbH6RF3MZHrI5sH6t6nY4qkxNdjcVm9ysm6RF7lQ?=
 =?us-ascii?Q?N2pv8Dw86llpA1bzyoPLnO6sbecL2gj53htGVtk906MfFdSLSFe1dZt5GXMe?=
 =?us-ascii?Q?3R6Ns9LyZyVIhgbiLttKniPN3QVyG2QmM/xsEkYUYeTo4QOhy8mPzOasDADx?=
 =?us-ascii?Q?g6tiGOnsThoa0mDIsPUGqsvWz4DMS15mLEmThTuLHYCHItR9MYaITGRO0oF5?=
 =?us-ascii?Q?6H87T0WgR4KjPaYUgao1GJrTDf4CM4kAcussHym5jonW4JFCpg0dXceP8fAK?=
 =?us-ascii?Q?1aHXUkSOpVjjjJiiFHYpgDwu/XZ+l+OqejqgGzXvI8clFWxq7oqEB6ADa34m?=
 =?us-ascii?Q?w/dbkozX3HBvhE8BSGPZf9f2zakgorEMZJRsnADJPBEc3fZVZzeEOhSr3Z6w?=
 =?us-ascii?Q?Qqe5vTaKegnlnIPc2VNkHEH0eDivaLuK5OJ5fSNwBw9vYoF94BY59vrZcXSF?=
 =?us-ascii?Q?cEED/QNWYzTtKGOLFaC0P0Gs/3NQk6Bqdbn5W4ZecqYN++Xd1YbezJ00m81Y?=
 =?us-ascii?Q?Y2CxpYCU7RFLV9sSLUo+s8rTpWYDdPWoDHa+q7a6bpLhMWM0tiCubOVYSDPg?=
 =?us-ascii?Q?pHZ+TNpJ3ndivoNtLlf62qpEX0dxyZ4dslJ7fi7+NXWkcQZjeWlnxX3zHkeY?=
 =?us-ascii?Q?ugSXXQdDp+6aNpdX8S5xPz1FExYGOu78TIiuqvpwTSqMbBAu8NqZyLHghPt1?=
 =?us-ascii?Q?Z5TzOe9ulSVZyiPfypNzC7Pk48rJoIdaOjtbEYZnxjr91grFCK3dKATNL3dA?=
 =?us-ascii?Q?bzZqwk/8vRaWfZ8WHOB2etMqbipsgUS1VfBcIzDj95urBIDGVQ20t4SkR2D6?=
 =?us-ascii?Q?y74GzsLJdViZr55omBUlsUFPYgfeTL7l7fPTo/xeTp/foHbPqERdTgzTn2dU?=
 =?us-ascii?Q?xWL8jaSBmwhrSNkT8Qfnl8UyHLUCh8eS+DZadRSIPIuQp+YWpQgnm8UvOPMJ?=
 =?us-ascii?Q?5VkDyKK0PbQMBuPRyaNQHQO1yR4oNQWXXyIrqKULMRpv7uINeK7f1Bk2nkY2?=
 =?us-ascii?Q?HRlrqfJRrY+EXr8fK3KAUkuuNksMv3bhk5kYUvUbK5D3geo7HMJfW9lH6qxa?=
 =?us-ascii?Q?Xaq3IoJQBXTDEJf6thtDbc9z66urjz/ATQUJ0uPN5ukeHrBeiwK9INOoBasM?=
 =?us-ascii?Q?rW55IhVx4Je/jFRrruCmeWmRpl3gjHqpznxJ+haHWiW9O7t3VCE4ZTzimxFT?=
 =?us-ascii?Q?RVbx7kHufblMRGJyk/QUO5nrrkrLY8UAUjedfUdSTOmZH7pe/yr1gLlPA9O2?=
 =?us-ascii?Q?ensNKR+cKcHJafFQ+tGkto9NH6A=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zkfw4SgA1PNYZnI/d9D7PB8MvywQD3W00BveyRaRsE2Yag1VbXkhyei9W7RkHV0QVf6UWjJ3FpNy6FOl26oJhibnsMxnuFoj88bcyOiumkWx/dXwI+YvrIBbptNk9xrLO62Fm9Fc7DuTFPh03tTpree/RCP6cw9+Lr7FAjEj5PxNasHpiev8GCXEYzlvWv/MreQDhwycS79eYwIZpcAPRzdD0N6e6hKQlWtAPh7cb/HKXjosd9bq6a2OViKj8nDicGN5bNLHpWkrla6EhdI7RPSI1aVP7sWdtHb1/FDSBAoBdeOvknbYFE+aZvmArshdlC3dxf8dcsrkV4Ov6XoRjY3c6WkqDuuU5wX6JfLyX9CWnvMUgEXKzELcfzunTGxMeKwVIWL2banby2qz+i3m+Kt286u8Xiy4Sl0D2tO2lWT2oVZ/Zuq0h4i/V2j24xCQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:43.8301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0655fc21-6690-4205-8f76-08de731a23c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000009.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

A VMID held by a vSMMU is required to setup hardware (e.g. tegra241-cmdqv)
during its initialization. So, it should be allocated in the ->viommu_init
callback. This makes the VMID lifecycle unique than a VMID allocated for a
naked S2 attachment.

Introduce an INV_TYPE_S2_VMID_VSMMU to prepare for this case.

In arm_smmu_alloc_iotlb_tag(), retrieve the preallocated VMID on the vSMMU
directly instead of allocating a new one.

In arm_smmu_find_iotlb_tag(), continue searching in the smmu_domain->invs,
using the type INV_TYPE_S2_VMID_VSMMU. This means a second device attached
to a nested domain associated with the same vSMMU instance shall reuse the
VMID held by the vSMMU. (FWIW, device attached to a nesting parent domain
will have an INV_TYPE_S2_VMID and will not resue the VMID on any vSMMU.)

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 12 +++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 18 +++++++++++++++---
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3b91e4596ffee..b821241f73c7a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -655,6 +655,7 @@ struct arm_smmu_cmdq_batch {
 enum arm_smmu_inv_type {
 	INV_TYPE_S1_ASID,
 	INV_TYPE_S2_VMID,
+	INV_TYPE_S2_VMID_VSMMU,
 	INV_TYPE_S2_VMID_S1_CLEAR,
 	INV_TYPE_ATS,
 	INV_TYPE_ATS_FULL,
@@ -676,7 +677,9 @@ struct arm_smmu_inv {
 
 static inline void arm_smmu_inv_assert_iotlb_tag(struct arm_smmu_inv *inv)
 {
-	WARN_ON(inv->type != INV_TYPE_S1_ASID && inv->type != INV_TYPE_S2_VMID);
+	WARN_ON(inv->type != INV_TYPE_S1_ASID &&
+		inv->type != INV_TYPE_S2_VMID &&
+		inv->type != INV_TYPE_S2_VMID_VSMMU);
 }
 
 static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
@@ -1195,6 +1198,13 @@ struct arm_vsmmu {
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index aa00c7cd3503e..0755ebe1c1560 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1982,7 +1982,8 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 	u64 vtcr_val;
 	struct arm_smmu_device *smmu = master->smmu;
 
-	WARN_ON(tag->type != INV_TYPE_S2_VMID);
+	WARN_ON(tag->type != INV_TYPE_S2_VMID &&
+		tag->type != INV_TYPE_S2_VMID_VSMMU);
 
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
@@ -2678,6 +2679,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 						   granule);
 			break;
 		case INV_TYPE_S2_VMID:
+		case INV_TYPE_S2_VMID_VSMMU:
 			cmd.tlbi.vmid = cur->id;
 			cmd.tlbi.leaf = leaf;
 			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, iova, size,
@@ -3241,7 +3243,10 @@ int arm_smmu_find_iotlb_tag(struct iommu_domain *domain,
 		tag->type = INV_TYPE_S1_ASID;
 		break;
 	case ARM_SMMU_DOMAIN_S2:
-		tag->type = INV_TYPE_S2_VMID;
+		if (to_vsmmu(domain))
+			tag->type = INV_TYPE_S2_VMID_VSMMU;
+		else
+			tag->type = INV_TYPE_S2_VMID;
 		break;
 	default:
 		return -EINVAL;
@@ -3265,6 +3270,12 @@ static int arm_smmu_alloc_iotlb_tag(struct iommu_domain *domain,
 	if (!ret || ret != -ENOENT)
 		return ret;
 
+	if (tag->type == INV_TYPE_S2_VMID_VSMMU) {
+		/* Use the pre-allocated VMID from vSMMU */
+		tag->id = to_vsmmu(domain)->vmid;
+		return 0;
+	}
+
 	/* FIXME replace with an actual allocation from the bitmap */
 	if (tag->type == INV_TYPE_S1_ASID)
 		tag->id = smmu_domain->cd.asid;
@@ -3308,6 +3319,7 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
 		}
 		break;
 	case INV_TYPE_S2_VMID:
+	case INV_TYPE_S2_VMID_VSMMU:
 		cur->size_opcode = CMDQ_OP_TLBI_S2_IPA;
 		cur->nsize_opcode = CMDQ_OP_TLBI_S12_VMALL;
 		break;
@@ -3352,7 +3364,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 		return NULL;
 
 	/* All the nested S1 ASIDs have to be flushed when S2 parent changes */
-	if (nesting) {
+	if (tag->type == INV_TYPE_S2_VMID_VSMMU) {
 		if (!arm_smmu_master_build_inv(master,
 					       INV_TYPE_S2_VMID_S1_CLEAR,
 					       tag->id, IOMMU_NO_PASID, 0))
-- 
2.43.0

