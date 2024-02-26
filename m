Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29B512F5B2;
	Mon, 26 Feb 2024 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967264; cv=fail; b=lDGJYMlVJlIIPG5t9JgLEDwPOTDf4V32Bxqi9d2swzlVu4hNx0hAieNmddU6+ZM7pk0UVc4ELz+57r3g5cwQJEFmxYh/uSWgP9XGMDKgf3W7fTtJQ2kzADVZ0YOnWhrdOjQl2hJAqhFAVQ56/Wrd1zd3F6HD2TwmtYxZv53JrU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967264; c=relaxed/simple;
	bh=2BSr2NEP7/ixoW49fL56GaWU1FquOLXmt921h+PIMBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kxdZGvvoSnGk/Ah5l8EBSdjWwn64Lq+8VG0wlzMBqmU2Af9++2kmVGDwW2Y39fv5Z5Y+fZ8DXDmDcD9w5fExscpz2ggyNdnMKRrqUqgKhI4Y3Wm3NvBQtrROIPDaTdFXrs+I7wvvMsj905w/RBsyBPydTKbM5vpeVFugYHYV/98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H+PBDRku; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H+PBDRku"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DV2kHTsbTU5gOBk/DijmRaCHpGfxlJEWBSDgeECulBE6fRLfFFPSEwa40z+zg26jG6jorjIFzD8e4pNz8Xj2WaXlLBP3gZAqwZ9InnPt89qowsyz1B+kW2wLGegPLk74pDUS5e+tUUouxHYU6u74ZynvKgZiZDRcd0aFtMawR19bdodBpNsicDT9LjD0+a6PqucMmVIVKvBDL9Ixh/qwRXnImoYb+o71+Q02ZpMQCMcDc6+A+3Hf2pvTwIL1j92PhgSXG9/Fxb4FYLLzzZr2TFKTXiySyCrFgRkDVaxXWhwDhoW7TbbDoLCe/24emJ1F6qvRhj6RdpLY6KnCjYEgKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CD0+FHrIzPyJO85Q97dh3teCEo7kSfrLDHD10sjtyxI=;
 b=RSShp/B3l4mhBXN1/hFKmUwNKMJtO81F1km+pBftT2eDmvPJNQQ14XPlVd31IZW/qrl7AnY9qxU0OfsTyWUm4teSP8vB3gHStNEY7UnJEvq3bYbG59oAN0Q5TerIvefMNZ7juPzNBKhFWCWcG29nVrTePp6RGjUM5Hecor+y611AnkItikYDiAvAfGvxaXgA47apoOa/kuy9UjYyXoErgIpiZejBuvDCubbrNXLoUolctzVk8VyrKi++ZWqMpMsugoH/RefGuJuP0D1ciKKb7wKUTh8KDMCSOQ7PynZhePL3xkJ2UMPrPVAERFJ6y4/5cwLdMYR4cm6ENIa7kreXkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CD0+FHrIzPyJO85Q97dh3teCEo7kSfrLDHD10sjtyxI=;
 b=H+PBDRku3EMgb4mD2jqM/RgYct/2MKIotUys8bOnC/FmRjyxeYktPapLor9zM4XDe0Y7RUU/IF6lg0bi4Ztva2dnZSBsMuEzYWzz23796CVYxnwCCVe6uaDClOW0iL1QBGlU56wbZXuBb17oxWISYVnA8xfgOBeo/Pl6qd5346ioKZAuZb5+hmZYsIS32h7Lq9nxoT+wSaTzpWs8+peT4WWj8Pf5bYRqeqNnYGc+FcXPoVNceS4+oOg5t4AJ9l92AJLujg7AOEHQs3mk+9R032PphRpbE6nq6dwexmBYC03OaN0MH2PwDjuB4ei3PJ1NbLDx/54Ps3OEs/+ne/JWpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:33 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 02/16] iommu/arm-smmu-v3: Consolidate the STE generation for abort/bypass
Date: Mon, 26 Feb 2024 13:07:13 -0400
Message-ID: <2-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:23a::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 8889dac3-5f55-4258-1997-08dc36ed6a5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Pod089Eo3tsKlOCGtDEshuW3U0RD8KJr6WkK6/4UHuf7eu7xN4R7RTCdAy8rBF2UQdUNEOv0IPbEzEQAGxl1r9y3i6/+Q58EarCKW9DoKnGucHdBVAUEuziGDI46ZP5geno8TJL2zb945jFmGy8YmQTJtZ++ia1YLBZKJdixrIKUPo2zGTxc2YgQ8FbONYOAueR0MhEF2c+NhgdcH5wfleZ6simdDWqMGmvoFOgwjfTzFHZ9T/IFzsD6lFvq/8i6rpospRwrwi9DybTPgPV3C0p4o09cizUrQCGM/JzvQkb668H6Db8YnwpfEmfdYukATyecBLEIquoA7KKvX4oG4APNeT0dlDmrpJgOClt7LrvIKwSARN3dgS8K7e/Zl0qwH/ZbvijTM+wl15TzmU2NXKgWf6xZ5QjdJjblREKqbgpbURgk/POk4YOAB4zxyBhZJ9ZuZ8xhS0gPZVIMee2AT1ZqQ7D0wQJd+m5oI9H1Lxy6QjqUifbdgsFkT4jDRv8hZ9GTGfizyyrkOlR8kjZdbmoD/jpZvyX9mrg7a+vvspUEItm3DzMUH6PjvKcZZtQojPTapJqaG2f791fLwuGFFahPEb87WKgCrYLYkZLv9Z+BDaxFREbUptTB9FXGQzY+ocpAMQNVmnkb949qmrgQ9Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M1suTowiZ5bMPht+LI0Ks6QKC0cr7faGQhaAkyqtf5exBsUJkmbVfLmLTpuE?=
 =?us-ascii?Q?cttTR9i2WS4s94pRbVZ8qSLiGbnsIEVey5PGWFB/nv02MQA+27nnqqG6wIFN?=
 =?us-ascii?Q?juSYUo1e1uuTAYncJ4x7eaNcEckgGhM1Vl/c5dvxbK5F6yAiaP1N9kj78265?=
 =?us-ascii?Q?RLxuTz2qWI6+iag8esGD9X9bBWmb5GgMaiHS3r0M5iXixz0PBlxadMd3ItG2?=
 =?us-ascii?Q?+DuOn8wWn94h0y7nYFKxQCz2KXh6pfrA1SxV/nVH2BVtBWfqrfsCZRKvN8Ph?=
 =?us-ascii?Q?iJxRsPPhHe8gx7En+OM4/7j3C/2yAbwM1n0TRALojpyrQ4nnmLAZ+2RdFDe6?=
 =?us-ascii?Q?WeT4zGDZNTPdyOAzvzNBPU+AHYdqHytVRjNu0aX8NltUFXi3DEu3Z5kfT1d8?=
 =?us-ascii?Q?pRtXtPfobEharXDs+Eegf0TL4+YGDCYTVm0YYt2uXsahkLQNSRgRfuQTMRsR?=
 =?us-ascii?Q?fUiB9S747tAyqBUZw9GEIsPzfxgHd1IayceA0QU+2FJIz+8r/bbs+t07T0pv?=
 =?us-ascii?Q?jilmpMKgcH1s/uo2WUpIT5uEWmviIFiahK5Gs2l8Dr9+/tKobeNYVrwAIrkz?=
 =?us-ascii?Q?QVrQXLHOqbCHSNcZ+n7A4Go1mKqM+n/r6ehrqV1oK7ufwkVtzoZTOsU7waPi?=
 =?us-ascii?Q?n32WhlrbpD1fflobQMBr0ENfHONw0C/DmvTaA/ME6LFykO4C+5ztZbYSwPMP?=
 =?us-ascii?Q?PFx31wPBYP95x21BFLC6wuYUx5N37GiQGdZVRpQUJoXpX62CJP8vlt7K+Zda?=
 =?us-ascii?Q?gBJ2nqbfESkCrUcoqFb07S4n+zIzq6MJ0W1JZej+di9jdiQt2isaePCPyKLs?=
 =?us-ascii?Q?yixfZ8AwgfSfbmYpe3mAy8mm8WZ4psOq0iTyuYN6ACyhhWI8PgnApzisCQfE?=
 =?us-ascii?Q?bBjhbcKenlrRpacxXGmZIM3Wj4DeZspqGcPqLxtYhDDWcejzYJOGrhaV8Yt9?=
 =?us-ascii?Q?0DgkWEesSOZcUjPWChOV6ybZcqTN9EP73SpGfUIFEcGtYpfms/pSYG6FRoFh?=
 =?us-ascii?Q?T+g4TMyYm49A6cE94TQ5eCo4fXD6Lbg+HLo0IuJReuDexGpX2kOeFB1Ni76l?=
 =?us-ascii?Q?HrBpkx4gH9v9JYlZEcNkm/ORWWdfzmGD6oaaoYb8EtKmrnbZPE3Y8gvgCdHS?=
 =?us-ascii?Q?809UCkOJwJVueO/jUhj/uYcqI8txe59bcpLJnTy9LLqRYqCFeyaNwz4wKcfG?=
 =?us-ascii?Q?TCyIO2wR5waE+FL/oilpxnfU8YTOQP5Xj4jTZp85xrNGmsixUDxzulfxjtKI?=
 =?us-ascii?Q?C0yT5W15mUx6Wby9oneSL9q5R6++LnWaiWQQ9eopNtoKS3xfoYncL5LH5kjC?=
 =?us-ascii?Q?kfGL4hGONZB50JfXXrTotoPTztAasY9HoI9Uq8VgV5S8y+efXEDPuOeQZ3Oq?=
 =?us-ascii?Q?7hGg7/L3j5Fc4d0N8PDIeEahMxQ/8gxnxNXz4wpcNhgjTQwV8J7kyvgfqorv?=
 =?us-ascii?Q?Td/NX5By2J2S08P0aKRZACOm2Gx8rndTIfapQr7BX0v5p4OwEGGffYkW80j4?=
 =?us-ascii?Q?lQfXSGWLYtIFpPKiGW9MwylDj7i3zdzNKAQgoniaNJumc4sabKDCKuFmzHrc?=
 =?us-ascii?Q?2xWYT6CRdu6iUOw0rj+KXDkGBnqWpMR7Lh6f3WI6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8889dac3-5f55-4258-1997-08dc36ed6a5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:30.1113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ty3zT2IZ20iHH6UP4pojYL//ob5tIZsj0NyNhEfxT2sTKcq/oJdU2+jCVNq5CiFE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

This allows writing the flow of arm_smmu_write_strtab_ent() around abort
and bypass domains more naturally.

Note that the core code no longer supplies NULL domains, though there is
still a flow in the driver that end up in arm_smmu_write_strtab_ent() with
NULL. A later patch will remove it.

Remove the duplicate calculation of the STE in arm_smmu_init_bypass_stes()
and remove the force parameter. arm_smmu_rmr_install_bypass_ste() can now
simply invoke arm_smmu_make_bypass_ste() directly.

Rename arm_smmu_init_bypass_stes() to arm_smmu_init_initial_stes() to
better reflect its purpose.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 99 ++++++++++++---------
 1 file changed, 56 insertions(+), 43 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9805d989dafd79..12ba1b97d696c9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1447,6 +1447,24 @@ static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 }
 
+static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
+{
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
+}
+
+static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
+{
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS));
+	target->data[1] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+}
+
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 				      struct arm_smmu_ste *dst)
 {
@@ -1457,37 +1475,31 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	struct arm_smmu_domain *smmu_domain = master->domain;
 	struct arm_smmu_ste target = {};
 
-	if (smmu_domain) {
-		switch (smmu_domain->stage) {
-		case ARM_SMMU_DOMAIN_S1:
-			cd_table = &master->cd_table;
-			break;
-		case ARM_SMMU_DOMAIN_S2:
-			s2_cfg = &smmu_domain->s2_cfg;
-			break;
-		default:
-			break;
-		}
+	if (!smmu_domain) {
+		if (disable_bypass)
+			arm_smmu_make_abort_ste(&target);
+		else
+			arm_smmu_make_bypass_ste(&target);
+		arm_smmu_write_ste(master, sid, dst, &target);
+		return;
+	}
+
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_S1:
+		cd_table = &master->cd_table;
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		s2_cfg = &smmu_domain->s2_cfg;
+		break;
+	case ARM_SMMU_DOMAIN_BYPASS:
+		arm_smmu_make_bypass_ste(&target);
+		arm_smmu_write_ste(master, sid, dst, &target);
+		return;
 	}
 
 	/* Nuke the existing STE_0 value, as we're going to rewrite it */
 	val = STRTAB_STE_0_V;
 
-	/* Bypass/fault */
-	if (!smmu_domain || !(cd_table || s2_cfg)) {
-		if (!smmu_domain && disable_bypass)
-			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
-		else
-			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
-
-		target.data[0] = cpu_to_le64(val);
-		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
-						STRTAB_STE_1_SHCFG_INCOMING));
-		target.data[2] = 0; /* Nuke the VMID */
-		arm_smmu_write_ste(master, sid, dst, &target);
-		return;
-	}
-
 	if (cd_table) {
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
@@ -1534,22 +1546,20 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	arm_smmu_write_ste(master, sid, dst, &target);
 }
 
-static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
-				      unsigned int nent, bool force)
+/*
+ * This can safely directly manipulate the STE memory without a sync sequence
+ * because the STE table has not been installed in the SMMU yet.
+ */
+static void arm_smmu_init_initial_stes(struct arm_smmu_ste *strtab,
+				       unsigned int nent)
 {
 	unsigned int i;
-	u64 val = STRTAB_STE_0_V;
-
-	if (disable_bypass && !force)
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
-	else
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
 
 	for (i = 0; i < nent; ++i) {
-		strtab->data[0] = cpu_to_le64(val);
-		strtab->data[1] = cpu_to_le64(FIELD_PREP(
-			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
-		strtab->data[2] = 0;
+		if (disable_bypass)
+			arm_smmu_make_abort_ste(strtab);
+		else
+			arm_smmu_make_bypass_ste(strtab);
 		strtab++;
 	}
 }
@@ -1577,7 +1587,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT, false);
+	arm_smmu_init_initial_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
 	arm_smmu_write_strtab_l1_desc(strtab, desc);
 	return 0;
 }
@@ -3196,7 +3206,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
 	cfg->strtab_base_cfg = reg;
 
-	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents, false);
+	arm_smmu_init_initial_stes(strtab, cfg->num_l1_ents);
 	return 0;
 }
 
@@ -3907,7 +3917,6 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 	iort_get_rmr_sids(dev_fwnode(smmu->dev), &rmr_list);
 
 	list_for_each_entry(e, &rmr_list, list) {
-		struct arm_smmu_ste *step;
 		struct iommu_iort_rmr_data *rmr;
 		int ret, i;
 
@@ -3920,8 +3929,12 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 				continue;
 			}
 
-			step = arm_smmu_get_step_for_sid(smmu, rmr->sids[i]);
-			arm_smmu_init_bypass_stes(step, 1, true);
+			/*
+			 * STE table is not programmed to HW, see
+			 * arm_smmu_initial_bypass_stes()
+			 */
+			arm_smmu_make_bypass_ste(
+				arm_smmu_get_step_for_sid(smmu, rmr->sids[i]));
 		}
 	}
 
-- 
2.43.2

