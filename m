Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052EF3CDBC4;
	Wed, 13 May 2026 23:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716679; cv=fail; b=Qvv73J5J3DFSo/P6lrPA0/soUruDHnIb4s4SkKNEG5waS19Vi8nW0tLi6G5Xt+wa2C2DRZNFQALeJTl6EaQyOmeXBXQc+qY3ZeLeODReO2vCAFx7Kae7IFgA9bvg5l8AYq7/gH2cQLYxsTmFD3QgHGirgLM/ispabRL+AZYzVlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716679; c=relaxed/simple;
	bh=bzMwZZ5RAnvKXBGtbaqBQq3ziUsUBvp7WscHTR2cqnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jh6LaKARpw63MpYkIMqiiYMUIBZ96pgtHNqNttt/GbfrYaCQPsUUG6tHf3qK7unxbNViXu1iEfCwUNFst92FS4VXdoGuE/yNpLvcCvjCjLburykQB6X20cguGg2b4Cfa7AjPQ3WI41aIMsE8pHNRiGbbfEx6vCyJ4Ddek3V+7xo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=erVI3KSA; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="erVI3KSA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8Out2767S4fbRmvirpD2oEGwHW1MecaCiJ+WDF2+xKpFauE82ex5ykCa1MOkXd/AFNxBfmPGvil9C1s36Sfs3HGiou2YmbG0jQuwkzvDX6qXnDwT/aBcclSV9w1DNslAQVqWDYnQFDDODr+OXXe9/nL6N42AuUFLoJYOnNYr88+5WsGON79jYHOCr5s6NimbhY/07JfQedXz/ZyO6zg0hQijna6QszL8EAibE1L/vN3rHQPg/9U0Qu/0D9jEA6WEKtLp4mCDsvDtwZxTrk6endB4ZjqmvJHEwjgBSPTdEZyy8qiyw2OOyKN6a0DbqN3Qea1r26xQgQY01j6s6APAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mipax813VXuk5/wwaPRUXBrV+DUpgyJYXqdEd3iElw=;
 b=yXNO0E4G+xMZX6l+ZXGrs69q05UdbRIzielOdffZjjC8Aj3IQOQZqc4whdCmwSTswIBhcNQ0f9H7hckrV/HrGUxHGbQ1BB4gXUFU2S7eCER/5PQbY5+uKS6zMesl+FNLbZ8Ak+6CiJUGqbmDykmqWyv6FqJoIdaAtDx5iNWsK8+BYFFLDhsgHLTCIPTPIzHCycc+RgZCpQWqT/d0SNMf9jxha2pLE6m2Ppn+DxSErLR3FntPLDM8PVnRSNHTKF0Yp+WhD/sF7V5OqHSBqqIbzL1T3bkXYO8/AYqkf/dvZPLmSG/04tv2tqLr0vN3Vxqf5TzAIMv+iDHsAmp0ligh1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4mipax813VXuk5/wwaPRUXBrV+DUpgyJYXqdEd3iElw=;
 b=erVI3KSA5icsuBCcJydUt8Wn1zyepWWW6CaUvm7N9phReBe15no9fg1u7UX/8yxH6xEV9I7P8MUOvyXsCQE6XeyLI61er9cDqqg7xJKYdMGJdN3KBEcmR20B9hm602YoDUskT5UkLXgenjWH0uLy9PcvsGlnusGsrq0i9UMdiTVkAsP352QHQnNYvOOm1m6P1V8hoA/kZB/9nvjp3ueZL+lo+cHhnsrx5IJcQy6goLqbJMck5mNW1Gn7PaNvx6nPngfX159PBX5bBOFl3Q9bzYupW+TSrvrzTFDnlstsSwuQpCsfAYZP7EZP4W1OCRBg59a3fHi3Ds6qmK+L6QwQ/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 23:57:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:57:51 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 3/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq submission functions
Date: Wed, 13 May 2026 20:57:42 -0300
Message-ID: <3-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0493.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fee8825-0d56-4592-318e-08deb14b7006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799003|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	l97pdaipEDQ0I//9eT+7rzvryjCbZslrN4p8zIgVdFLXEzJxVuVGfc+yy29V4ZwDUEptapPGBA8QHWU6A+mdEHtLknwr5qb6PhhiEh5SairZ9PWMJcNdinLFHRZ6S0vzXuJct7mp4Bdd+SeZObTffN96HAhYgkh6lMk7OUA6pG/DxDaMy2MuXJ4QMsNxcfzsIzQQMMaSfFCJsInWB0/FHJQc/VcqJKl1wew8GC7CzGCf0xMUyGJYYxaL1Tf8fu+GfuRsZeRrqFphMYOSHeSDZ+yH2TOycBDx32TVS6XSio2Sq9uD+z5uyQKvsTNAqwbrX0P5R/4vaGoziKiEyVhYYmiBtzBEd/YsFLuaAvsA+uz0TJ860OoafhTEKL+p100JrFUtk1QRt6wTZj8Cwz1jaCWH2NQIp/PEH0/ovN8dfmPzHLkXsG3/NbarZjszKZ2WQxQFOKoGgtio1jzhNAFkzdZ1V6kYVxFubKx9bsvVMYdGWZFtclfKOWC6GRzKljBS/0VSdPqczz3n1+q2wWnubav9oTzM/CT0mlg7zUujab0OwAkzqOZgJ5ZJ8T4u43TqfdXH0T6ZmjiXzl88BJzrILC4vthQzHUR2ttM1bc2sgoXxMuysgeHbZUr5lQRHaELrDGMA3qqWFcDqi3VNm17gyLThVXDqcm40Yw7EJab7kDNAF+CFtyoOT0m99gkDF9+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799003)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1lWrP5oDOOb2tsx2ctpoE3p4w/DpbvNc/XbQ2NFuZmzXDrbMjcoamKtAW8gk?=
 =?us-ascii?Q?FByDB3DFZSKRuF1ZxNJCoxU79gui5zQ36UlHZCtWTPEZXu8TaNIn+ueQHedl?=
 =?us-ascii?Q?0hPYBsUmLJpBhW+KApsVcoPJ+jGc/zZnthwmlKQrn9KYwdQ5zEO1Xx4YJD+0?=
 =?us-ascii?Q?wLuVExky/OkzZYX2IWn1GhDXFfBVX26XdwyFLXmxJIDDfD/pa0RX8gN4VdtZ?=
 =?us-ascii?Q?glOQssR70V5kjzyknxb6bHRqHZqiOnFCH01VwBWT9FInw/fXyxLLWKJfdMgO?=
 =?us-ascii?Q?i3IbaXNCMys927YgtdQfhlC3hDgDebqE8/tCMriRGtuNVFWalHYUCX4GNu7q?=
 =?us-ascii?Q?QYrMKKeGKkWVsQCS6phdr4VcdCgVV5wDRbFwLqG1w3ly1I287e0nlMsIF2lZ?=
 =?us-ascii?Q?9CO5wjF/YBLsd3IIY5ycFyrTw6/61784Tf4XHghHWrNGu6OTVteweU/MuSco?=
 =?us-ascii?Q?hc2Jtxl4nezRdKYy36ug8McRnv1q9kXpWoTSwkr+PPKkpQOFzznoFqqw/uWQ?=
 =?us-ascii?Q?xHc8C74oi5owA3hJ2qyRxjOKah3qwH4gfdxVD7aeosWmyjaeLCXE0sOi0VCq?=
 =?us-ascii?Q?kNHp3inYy/tw4A3gzg5RoRz4zg1uEeDX13G/w6ssjOmxPTWn4okDkXBYPkUR?=
 =?us-ascii?Q?FD+5KdhuYaQp2WhMd8atfrvDMd3BCvpImclofFpIoxSxBf7wR/ZgUuDZmmHq?=
 =?us-ascii?Q?NL+5R8btJXwaLpNg9axp2nuJq2LiO9U0//59Q3TSYoN/PrvRuQWhkB4HCqOv?=
 =?us-ascii?Q?OG6o1KPeSOeHXe064QMHQknqClo2HBije4Zat5Wwypvj7vZGW+it1Qw/TSRT?=
 =?us-ascii?Q?AGZ7vHjw01s5yL4WYtMZEPJIULK1Os8FfXnnD3Cqap4+A8CGIyFhn2L3iFdl?=
 =?us-ascii?Q?JeVcS+Ae1TMs+oODXr3r6yJzousLkoGQLkGM0QLwnT56ToqTLC3KbE1g1DmZ?=
 =?us-ascii?Q?cUP/PNnsNDTJGFxOjGfZIlY0PVzT58rhb1apfrF+qHJnCxPOLOL9Urc3wj0J?=
 =?us-ascii?Q?F6mGMLfjr5/vhvUusDpVpKT4sduu5ZW2WjiARatdkv1CTtoUAk4/lz58ifjS?=
 =?us-ascii?Q?LoU0ToRxtVhlVbbuNWEyRLTIGhv54b+gSZ3BGNUptImuphRMUEy8eCruAzDn?=
 =?us-ascii?Q?trdK3hScwWJanzZj7wJiA5gS3QWqcJBFcTxyGL4/G65r+SHMliG7Xi25w20P?=
 =?us-ascii?Q?hOM0q/T7/9dGscxyNB64Yf2fvhqhOFuwkYHSe8w/aeynQMyre844fdQxqf2u?=
 =?us-ascii?Q?qqSn2Ob/L77KhfmsDCq326HGK5M/9P4rsRfzx+zaixjYh7dmzfV9oACxxZc6?=
 =?us-ascii?Q?YQFHaJ7K9SFwYDF674/BVcaVR1uqImqsez14NANX3siikESaRCzpi2wLoVV6?=
 =?us-ascii?Q?jL9J2RWu3W9lC79reN8vaXjy3TPkLemJya9JoZeIYDhKVS6Mq6zZpHr31uOQ?=
 =?us-ascii?Q?sOSsxzs7cWhjhjnQKHDX2lpT5zyA5psAu7hSAgV8J2yUeM6Ff7mjhUz5lfSt?=
 =?us-ascii?Q?utHrDpZW29GJMIFN6uenOv2pNLyNUO2M8MSYVpkvNvcscoCeegurg9kVoMmh?=
 =?us-ascii?Q?AGOdtdn4p3YCqBsNt09e68KZXISRH+F7GqnkBLA/r74nhIpC9SlvhJT2xEd+?=
 =?us-ascii?Q?mZDIt+4ctn2ouOrJhfmBvsZJT1wHEAHJqw8EoAdbR1dyi1Bw4hTmtwM67lct?=
 =?us-ascii?Q?CKk1d1I61PoIqyfFucVkW+ze5HmjtawagQGH5bqmZDgJ8BO7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fee8825-0d56-4592-318e-08deb14b7006
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:57:50.0440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ohQSFGABb0KTkuZH4o9+JRa8gyz8W9Hp4hUoVzFK/ahGqGmA99p8CtNl3YHL0yOJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

Continue removing struct arm_smmu_cmdq_ent in favour of the HW based
struct arm_smmu_cmd. Switch the lower level issue commands to work on
the native struct by lifting arm_smmu_cmdq_build_cmd() into all the
callers.

Following patches will revise each of the arm_smmu_cmdq_build_cmd()
call sites to replace it with the HW struct.

Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 53 ++++++++++++---------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5cdeaec890592f..67d23e9c54804e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -921,31 +921,23 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 }
 
 static int __arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
-				     struct arm_smmu_cmdq_ent *ent,
+				     struct arm_smmu_cmd *cmd,
 				     bool sync)
 {
-	struct arm_smmu_cmd cmd;
-
-	if (unlikely(arm_smmu_cmdq_build_cmd(cmd.data, ent))) {
-		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
-			 ent->opcode);
-		return -EINVAL;
-	}
-
 	return arm_smmu_cmdq_issue_cmdlist(
-		smmu, arm_smmu_get_cmdq(smmu, &cmd), cmd.data, 1, sync);
+		smmu, arm_smmu_get_cmdq(smmu, cmd), cmd->data, 1, sync);
 }
 
 static int arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
-				   struct arm_smmu_cmdq_ent *ent)
+				   struct arm_smmu_cmd *cmd)
 {
-	return __arm_smmu_cmdq_issue_cmd(smmu, ent, false);
+	return __arm_smmu_cmdq_issue_cmd(smmu, cmd, false);
 }
 
 static int arm_smmu_cmdq_issue_cmd_with_sync(struct arm_smmu_device *smmu,
-					     struct arm_smmu_cmdq_ent *ent)
+					     struct arm_smmu_cmd *cmd)
 {
-	return __arm_smmu_cmdq_issue_cmd(smmu, ent, true);
+	return __arm_smmu_cmdq_issue_cmd(smmu, cmd, true);
 }
 
 static void arm_smmu_cmdq_batch_init_cmd(struct arm_smmu_device *smmu,
@@ -1013,6 +1005,7 @@ static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused
 	struct arm_smmu_cmdq_ent cmd = {0};
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	int sid = master->streams[0].id;
+	struct arm_smmu_cmd hw_cmd;
 
 	if (WARN_ON(!master->stall_enabled))
 		return;
@@ -1032,7 +1025,9 @@ static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused
 		break;
 	}
 
-	arm_smmu_cmdq_issue_cmd(master->smmu, &cmd);
+	arm_smmu_cmdq_build_cmd(hw_cmd.data, &cmd);
+	arm_smmu_cmdq_issue_cmd(master->smmu, &hw_cmd);
+
 	/*
 	 * Don't send a SYNC, it doesn't do anything for RESUME or PRI_RESP.
 	 * RESUME consumption guarantees that the stalled transaction will be
@@ -1861,14 +1856,16 @@ static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
 {
 	struct arm_smmu_ste_writer *ste_writer =
 		container_of(writer, struct arm_smmu_ste_writer, writer);
-	struct arm_smmu_cmdq_ent cmd = {
+	struct arm_smmu_cmdq_ent ent = {
 		.opcode	= CMDQ_OP_CFGI_STE,
 		.cfgi	= {
 			.sid	= ste_writer->sid,
 			.leaf	= true,
 		},
 	};
+	struct arm_smmu_cmd cmd;
 
+	arm_smmu_cmdq_build_cmd(cmd.data, &ent);
 	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
 }
 
@@ -1896,11 +1893,13 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	/* It's likely that we'll want to use the new STE soon */
 	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
 		struct arm_smmu_cmdq_ent
-			prefetch_cmd = { .opcode = CMDQ_OP_PREFETCH_CFG,
+			prefetch_ent = { .opcode = CMDQ_OP_PREFETCH_CFG,
 					 .prefetch = {
 						 .sid = sid,
 					 } };
+		struct arm_smmu_cmd prefetch_cmd;
 
+		arm_smmu_cmdq_build_cmd(prefetch_cmd.data, &prefetch_ent);
 		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
 	}
 }
@@ -2328,7 +2327,7 @@ static void arm_smmu_handle_ppr(struct arm_smmu_device *smmu, u64 *evt)
 		 evt[1] & PRIQ_1_ADDR_MASK);
 
 	if (last) {
-		struct arm_smmu_cmdq_ent cmd = {
+		struct arm_smmu_cmdq_ent ent = {
 			.opcode			= CMDQ_OP_PRI_RESP,
 			.substream_valid	= ssv,
 			.pri			= {
@@ -2338,7 +2337,9 @@ static void arm_smmu_handle_ppr(struct arm_smmu_device *smmu, u64 *evt)
 				.resp	= PRI_RESP_DENY,
 			},
 		};
+		struct arm_smmu_cmd cmd;
 
+		arm_smmu_cmdq_build_cmd(cmd.data, &ent);
 		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
 	}
 }
@@ -3446,6 +3447,7 @@ arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
 static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
 {
 	struct arm_smmu_cmdq_ent cmd = {};
+	struct arm_smmu_cmd hw_cmd;
 
 	switch (inv->type) {
 	case INV_TYPE_S1_ASID:
@@ -3460,7 +3462,8 @@ static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
 	}
 
 	cmd.opcode = inv->nsize_opcode;
-	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &cmd);
+	arm_smmu_cmdq_build_cmd(hw_cmd.data, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &hw_cmd);
 }
 
 /* Should be installed after arm_smmu_install_ste_for_dev() */
@@ -4823,7 +4826,8 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 {
 	int ret;
 	u32 reg, enables;
-	struct arm_smmu_cmdq_ent cmd;
+	struct arm_smmu_cmdq_ent ent;
+	struct arm_smmu_cmd cmd;
 
 	/* Clear CR0 and sync (disables SMMU and queue processing) */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_CR0);
@@ -4870,16 +4874,19 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 	}
 
 	/* Invalidate any cached configuration */
-	cmd.opcode = CMDQ_OP_CFGI_ALL;
+	ent.opcode = CMDQ_OP_CFGI_ALL;
+	arm_smmu_cmdq_build_cmd(cmd.data, &ent);
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 
 	/* Invalidate any stale TLB entries */
 	if (smmu->features & ARM_SMMU_FEAT_HYP) {
-		cmd.opcode = CMDQ_OP_TLBI_EL2_ALL;
+		ent.opcode = CMDQ_OP_TLBI_EL2_ALL;
+		arm_smmu_cmdq_build_cmd(cmd.data, &ent);
 		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 	}
 
-	cmd.opcode = CMDQ_OP_TLBI_NSNH_ALL;
+	ent.opcode = CMDQ_OP_TLBI_NSNH_ALL;
+	arm_smmu_cmdq_build_cmd(cmd.data, &ent);
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 
 	/* Event queue */
-- 
2.43.0

