Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E323CDBD3;
	Wed, 13 May 2026 23:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716677; cv=fail; b=gisa80Hl0MBdIFdYVxy1ntdNF5cPk0Wg8iGyFmJguhKShb126DmCfkNikOgfd2ZzWUGaZhzJ/BqHnMpwZpW/6vTym9q9wf5fad3hzhqulYaDMJ47heuxk4/B0VSHk4Fbw0j/JQiEt3RiYnBj+N6TV/eKyrk4PK7oUr+zOzua0g8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716677; c=relaxed/simple;
	bh=2wAewAk52duUa8/3Yidl1g1OFPmDeXdhdmlmL2ZiSKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LG96Hq8aEST8+db1myVk41nTq0gJ889MmlykYVWRqqyh2CB0S2HxKgliWI6ctkNSVYGNYleDI4R+No/wXObbxyks1rDILyxe+gLcfdM4IAJOQjSBRyn1NJnzfTjLjF9qNrrxTtAfwXR33TRMj3gAGRikL91zYqhsS25MkfF4QKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M+WSubqg; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M+WSubqg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yyl8YJOOoYDUGiHZnBa6QzJ0zEvSe7zVkv0XXYj/puu1WDq4D4BdWuzpHhxAIkxxJsLbeBArACq17hzdPG6HkrS5maah0pj2DBxvemK1qogUlFV1aLe8bbGVbyB1guH5/T+3g9KezIdjGWAIG0EtOumoUUe7bfyeTIGQ93IHpsOcjFbAyq7NwN3LzCdR89A7xoLdFWoF+GL/fJyMZxa7mRnYRZgjjWG+KIrLllQRnBRMbG1LwN33Cvp0oKZ2+9V+7PFpElw0qqTxYJ4ugRe1ZzBpcrkff5/mP7LqdoxKPMZ1qf5/2WRQQGrA8Qnp1Lf8QZpyYRJvLqLk7FovLsrU1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UuhhN2ow+8aUzefr3FH0DEGbH0rpxCfPOPRqcsdxH0Y=;
 b=kQf+gFoRyjf1h4G14+88uF7PIukS/q9WEzmTYi4/LNcVfG8yS1pmJnJhdyg4mDJUy2Xxswk9xPLP7qSQvzyH4+1YYfNYtJeInRy6yCyHsivaDupHHGw8hcWnrPaU535Wwp0f7yR5q7kjktzJzo7Xzp5NI0672OwUYyorw5ZlzTeoNCXYawPiUhnSMrqFs08WXXQ2TCHVg31uBHNIGZ6sf91L2QGKcUJAabpIY5EPHrV96gCNMzFDFfPAvSBQfV5g+sqIHR9HX100WfaHyvpsTKM4rOwCP0kyG34N1fOsV5vbTz4G3pzoyXrp6CO/BPA87HqAv/ZK4MmjlOsNtMgjjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuhhN2ow+8aUzefr3FH0DEGbH0rpxCfPOPRqcsdxH0Y=;
 b=M+WSubqggYZ+oL3Q03p3d4PFETekYq5lkR1ij6UdyEGzvFJ/B75Na79F8u6t6pfUef1Ve1DLbrka+H73pjXuS2eYpUt9QHl6eExQ7u3U2kstG3TRuCm4dPIpM2YmZ0/KCwOSPj1EB3DsyodJ936+1EoigooodU7Ha5A6bPfxKNOmI1FKEZgPC45G6Lc8YtAYwntCD9fH1+tUJ3Qz9Gl1IfgWgnvyzIvkCk2x2JBhybQjfco7iDV4x0P8AhpCiVCiYnxZlwg+WYPy/XAjlQ5g+5PigOzRF/C1xlYRbJCb1T4wF7tre+IumWJhryVyMZyZ7jUgKqHBjq3FJ9Uf+fqQxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 23:57:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:57:50 +0000
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
Subject: [PATCH v2 2/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq selection functions
Date: Wed, 13 May 2026 20:57:41 -0300
Message-ID: <2-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: ff48aaff-4628-4a32-8820-08deb14b6ffd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	hjSOLj4b3N0yEirgGaWQt77bzIaTfsz8I87C0Ysgs7wMvl3+OFeTDYr9P5M8fMjQAmovz+nZoAva5EvQsA7o0biOQ8piSXktIZ0kH93bQF85Ox4dWKMvVoTz91dBpcouOQ2LdAkQ8HjSA/PZ9CLqN2D4NUWvFvp5HgeKCwxwN5azZDept3kHeEj1BBjBq8ipEMAnPdnooa15f9Jj68GIIYO4PcTz00o3Q/+QxjgjCXZpE/XplrC9QPYpKVm04oDrvT6tk+qtPwYrycb4t+O97IQAfSQ5j6SuY4bw9o+7ePi4ix2Xwp02ccxYdNtmx1oJ0fNgGl/5zlbIep/1vCwJZJ+iydeeOrzKztaNchcu5f9mVUWQwkaPK/QUzEOZHFL5GlqPvdMYkMhZSpqAPg6qICLiIlUuTJoyGaNq1zw+coIfwc9eSl2I27ErsUF1r9zwTLtCeX+HO2j1ZRCCCvA/EWEaUh1V4MfwhPeTNC/RJFGmD5w4/2rPj1J4W46d4foxFTumD7bkppPn1e1YwfKDmnQPGwk0kC3t3tn6E7ZCEyO6cPvW3HCrkgFRWPRJL93ZiN+vbUIy225p6YZ10VWC6TNxWibSYYIA4B8Tn5ol/VYceBVJu+z+dkCM4FjFbGSQYRO3g1XFzVZlMVsV6LlUrIfbuG+iKqqX1GxMgQDCmhI3z2QUKlYQfsXLyR6k6DRc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OGtUIJ0UNd/V22nED7YMT5FQ+8Is36T9B3wHm59aIsfl9c2hOFRhONNYn246?=
 =?us-ascii?Q?9RjULIOvuk+lLS2byvMloRmIjCZ+duwir1wei8rNIFCkywYA38URbXjnPXhT?=
 =?us-ascii?Q?ruvXeweQH82hCzKNvC7YZnLuIFsX2AsT2YSfatIRJrLoj0Yd1a8zfRq4ZrHc?=
 =?us-ascii?Q?9HdUYLAzqDv/kaXI/4rFdFfzT7Rxp578ksLFLBhMvO2SOa8wVR1nxU8+X5nf?=
 =?us-ascii?Q?8o7RV+XrJ8Z0GZ9Km+JyCuCMOi5xrKs1UWZm1W84fYaXjaOcHE73Aq3ghMoS?=
 =?us-ascii?Q?bNHr4uDARKCsPQURKkuonWwVf99e/Rw5EOVuPTP5YFQrEAoKkZpLbF9Oj4H7?=
 =?us-ascii?Q?hnUF4nECnCohIKgLvmXt+EkbodE2piY5LMrQcseFk8sQGDoAWWPbpNJS9py1?=
 =?us-ascii?Q?d6q52CazibSt7AlRD8jLypwmr0axgMM/90ZJRGjLjQQk1Peef1AhzzqvdD57?=
 =?us-ascii?Q?JenZoGz9uyQBb2ZYqBwZz/4S9Ky3ejrvID4GUufZUI6UxtABzatS4WDXv7BV?=
 =?us-ascii?Q?bFwAdi7RGhPy4JP/zlIvp/qOlaHaKV4ybxFc4o4uL/g5NFTV3xgGykMGRM2r?=
 =?us-ascii?Q?qbao7FgnpfH1t8ClUGiqi70j7hvslA/fd0utk5ikVcL86/vnSfzOR+R9KTvM?=
 =?us-ascii?Q?hY8fyjYne9wgav7faDAUCukHI2cSpJycvMnK3cTtqNH7Sas9i5PNEayt3INt?=
 =?us-ascii?Q?aV0knmwQYMVFOfaaapiZt2GOQagAK/mcilb4iUtASiNOey6tAbl74s+DZx+t?=
 =?us-ascii?Q?B+cjNFVWwEYxMrIYQVUmAi25unLqCwwYmaCCreQkoOknO33dLinGQZQytStD?=
 =?us-ascii?Q?979WbkFcHPiTHu1i2bylVjB/Bw2/vD6Fx/R8wtAP05A4tdGqyNldTYHN6344?=
 =?us-ascii?Q?K8V7vNmJCpQCTKmmHX/pk6m2aGyW3yX/VifGvGHC3XY05ClqihJJ1ZPQ2vnY?=
 =?us-ascii?Q?pNpNlb3ioxqcEFTZni7sRI7NTjYXkL6DEmIS3hyJUOOnTvhEwCKWv6cHVSQx?=
 =?us-ascii?Q?4xe+B5JzAXhxCObwNuhHfAGIKTmLVYfTfDDDY9vqIijDICjWK4PS3OSY0yWc?=
 =?us-ascii?Q?Maz990u57SO8esLhADxQk4xZqB6FkLv59UpDc1JQy99lEeMC+AO3ekwpB2s/?=
 =?us-ascii?Q?XrzYcMR2AxtWdiNLHjW2hbbnV9ReYp76X04aZ9c5J1YD/9rhdh2IdurxLySq?=
 =?us-ascii?Q?lEDet898vhFKyXQ1bS39Kloipu0D9GAnb5C03YZrjODqQXkfchgQrbaMiuTH?=
 =?us-ascii?Q?sipEB/ZfVp4SpNJfxFqrDuivTHppcIZcicsqL8W9+YNoaLIP/h+OPUD6zR6B?=
 =?us-ascii?Q?EcXOunal8XxoIYnKNuglT3BESdIi1AIm08k5Xa+VXyj9HavGNMFTiPHu4g/F?=
 =?us-ascii?Q?sJ0t4ZZ3wGemEI9PZ0UMgAu+uHQdgHBmZE9uDegMS1m9h7mh8UaXIXy8QnGm?=
 =?us-ascii?Q?pNwYjaGzq+1GeZax2CTndKBcPNCj46LWz4k1admGRahWrq71JQ6Uo0ZrMO8y?=
 =?us-ascii?Q?FMgxHzfPwf3DZiOxPEOajqVSYg5FzbuXxEYi0Ji/sYIPoIBzquQ+U7fEaZRy?=
 =?us-ascii?Q?+DzFkimoz32JQ3dOF8ppIKq3Oijvou4YtYMrk+pc4HuPFd/CqsKbYUUzHmRF?=
 =?us-ascii?Q?M2I0ztKaS/hOrBcbd61FkyS+krfmKxpTY8WI3dIgM7++1CQ7XrM+D+yqt96c?=
 =?us-ascii?Q?1iNrZGJQR7ad70c98uiN8O0AKiy4SRFGcsxdrG33mB63DjUt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff48aaff-4628-4a32-8820-08deb14b6ffd
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:57:49.9265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxIZy6a0Nt/EfI0ptETBt5TarJlJHxVJ9Dz6WiYzv/yUy8VwFs1ayQy+mUNodgIy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

Start removing the use of struct arm_smmu_cmdq_ent, starting at the
lower levels of the call chain. Change the functions that determine what
cmdq to issue the batch to into using struct arm_smmu_cmd directly.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 47 ++++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 ++--
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  8 ++--
 3 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e8d7dbe495f030..5cdeaec890592f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -371,12 +371,12 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 }
 
 static struct arm_smmu_cmdq *arm_smmu_get_cmdq(struct arm_smmu_device *smmu,
-					       struct arm_smmu_cmdq_ent *ent)
+					       struct arm_smmu_cmd *cmd)
 {
 	struct arm_smmu_cmdq *cmdq = NULL;
 
 	if (smmu->impl_ops && smmu->impl_ops->get_secondary_cmdq)
-		cmdq = smmu->impl_ops->get_secondary_cmdq(smmu, ent);
+		cmdq = smmu->impl_ops->get_secondary_cmdq(smmu, cmd);
 
 	return cmdq ?: &smmu->cmdq;
 }
@@ -924,16 +924,16 @@ static int __arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
 				     struct arm_smmu_cmdq_ent *ent,
 				     bool sync)
 {
-	u64 cmd[CMDQ_ENT_DWORDS];
+	struct arm_smmu_cmd cmd;
 
-	if (unlikely(arm_smmu_cmdq_build_cmd(cmd, ent))) {
+	if (unlikely(arm_smmu_cmdq_build_cmd(cmd.data, ent))) {
 		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
 			 ent->opcode);
 		return -EINVAL;
 	}
 
 	return arm_smmu_cmdq_issue_cmdlist(
-		smmu, arm_smmu_get_cmdq(smmu, ent), cmd, 1, sync);
+		smmu, arm_smmu_get_cmdq(smmu, &cmd), cmd.data, 1, sync);
 }
 
 static int arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
@@ -948,42 +948,55 @@ static int arm_smmu_cmdq_issue_cmd_with_sync(struct arm_smmu_device *smmu,
 	return __arm_smmu_cmdq_issue_cmd(smmu, ent, true);
 }
 
+static void arm_smmu_cmdq_batch_init_cmd(struct arm_smmu_device *smmu,
+					 struct arm_smmu_cmdq_batch *cmds,
+					 struct arm_smmu_cmd *cmd)
+{
+	cmds->num = 0;
+	cmds->cmdq = arm_smmu_get_cmdq(smmu, cmd);
+}
+
 static void arm_smmu_cmdq_batch_init(struct arm_smmu_device *smmu,
 				     struct arm_smmu_cmdq_batch *cmds,
 				     struct arm_smmu_cmdq_ent *ent)
 {
-	cmds->num = 0;
-	cmds->cmdq = arm_smmu_get_cmdq(smmu, ent);
+	struct arm_smmu_cmd cmd;
+
+	arm_smmu_cmdq_build_cmd(cmd.data, ent);
+	arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 }
 
 static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
 				    struct arm_smmu_cmdq_batch *cmds,
-				    struct arm_smmu_cmdq_ent *cmd)
+				    struct arm_smmu_cmdq_ent *ent)
 {
-	bool unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, cmd);
 	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
 			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
+	struct arm_smmu_cmd cmd;
+	bool unsupported_cmd;
 	int index;
 
+	if (unlikely(arm_smmu_cmdq_build_cmd(cmd.data, ent))) {
+		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
+			 ent->opcode);
+		return;
+	}
+
+	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, &cmd);
 	if (force_sync || unsupported_cmd) {
 		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
 					    cmds->num, true);
-		arm_smmu_cmdq_batch_init(smmu, cmds, cmd);
+		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 	}
 
 	if (cmds->num == CMDQ_BATCH_ENTRIES) {
 		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
 					    cmds->num, false);
-		arm_smmu_cmdq_batch_init(smmu, cmds, cmd);
+		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 	}
 
 	index = cmds->num * CMDQ_ENT_DWORDS;
-	if (unlikely(arm_smmu_cmdq_build_cmd(&cmds->cmds[index], cmd))) {
-		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
-			 cmd->opcode);
-		return;
-	}
-
+	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));
 	cmds->num++;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 092179f689e9f1..6d73f6b63e64a9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -641,13 +641,13 @@ struct arm_smmu_cmdq {
 	atomic_long_t			*valid_map;
 	atomic_t			owner_prod;
 	atomic_t			lock;
-	bool				(*supports_cmd)(struct arm_smmu_cmdq_ent *ent);
+	bool				(*supports_cmd)(struct arm_smmu_cmd *cmd);
 };
 
 static inline bool arm_smmu_cmdq_supports_cmd(struct arm_smmu_cmdq *cmdq,
-					      struct arm_smmu_cmdq_ent *ent)
+					      struct arm_smmu_cmd *cmd)
 {
-	return cmdq->supports_cmd ? cmdq->supports_cmd(ent) : true;
+	return cmdq->supports_cmd ? cmdq->supports_cmd(cmd) : true;
 }
 
 struct arm_smmu_cmdq_batch {
@@ -815,7 +815,7 @@ struct arm_smmu_impl_ops {
 	void (*device_remove)(struct arm_smmu_device *smmu);
 	int (*init_structures)(struct arm_smmu_device *smmu);
 	struct arm_smmu_cmdq *(*get_secondary_cmdq)(
-		struct arm_smmu_device *smmu, struct arm_smmu_cmdq_ent *ent);
+		struct arm_smmu_device *smmu, struct arm_smmu_cmd *cmd);
 	/*
 	 * An implementation should define its own type other than the default
 	 * IOMMU_HW_INFO_TYPE_ARM_SMMUV3. And it must validate the input @type
diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 83f6e9f6c51d6b..b4d8c1f2fd3878 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -367,9 +367,9 @@ static irqreturn_t tegra241_cmdqv_isr(int irq, void *devid)
 
 /* Command Queue Function */
 
-static bool tegra241_guest_vcmdq_supports_cmd(struct arm_smmu_cmdq_ent *ent)
+static bool tegra241_guest_vcmdq_supports_cmd(struct arm_smmu_cmd *cmd)
 {
-	switch (ent->opcode) {
+	switch (FIELD_GET(CMDQ_0_OP, cmd->data[0])) {
 	case CMDQ_OP_TLBI_NH_ASID:
 	case CMDQ_OP_TLBI_NH_VA:
 	case CMDQ_OP_ATC_INV:
@@ -381,7 +381,7 @@ static bool tegra241_guest_vcmdq_supports_cmd(struct arm_smmu_cmdq_ent *ent)
 
 static struct arm_smmu_cmdq *
 tegra241_cmdqv_get_cmdq(struct arm_smmu_device *smmu,
-			struct arm_smmu_cmdq_ent *ent)
+			struct arm_smmu_cmd *cmd)
 {
 	struct tegra241_cmdqv *cmdqv =
 		container_of(smmu, struct tegra241_cmdqv, smmu);
@@ -409,7 +409,7 @@ tegra241_cmdqv_get_cmdq(struct arm_smmu_device *smmu,
 		return NULL;
 
 	/* Unsupported CMD goes for smmu->cmdq pathway */
-	if (!arm_smmu_cmdq_supports_cmd(&vcmdq->cmdq, ent))
+	if (!arm_smmu_cmdq_supports_cmd(&vcmdq->cmdq, cmd))
 		return NULL;
 	return &vcmdq->cmdq;
 }
-- 
2.43.0

