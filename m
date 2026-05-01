Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849603CBE79;
	Fri,  1 May 2026 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645777; cv=fail; b=j8Q66+6Fv43cBLxcCErpFR+/2NStG2cS114BB+4SKz624GRwAlMhUWvue2R+mZeG5JXefKvRYRoeykEbxeC/fJXJmA5ySQklCl6WHtxkPtr7HJzoEPClmO/Gcu5PRN/OGw845altDvG3+v+d6d78Im+1KtSc+bkhW/b/K9yfV2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645777; c=relaxed/simple;
	bh=bZ3uM4ap5wtGyEiy2wmDVtj65qKPmlc6pnvBZ/DnNuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OhAQgh8rUwNA4nU9WSp2UDzwuDyeJOV4zJx8SqG/ncPcdykFhtL2C/yxLT7T3heHxiaInvjox4TCSPAt7iKEACSfKcNAdDgDXiUGo5U+aU3Hw0OEv6DUinshjwKZmSN4tY1gBAjud+rVOYgHulDKMGYolLuVdEPuzVlwu5QlxAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n3qcdOBn; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n3qcdOBn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LvtnCUkiBWwd5mp8Y+LdVYhf7ETdnebbaocvP7916ZrmrdYGHWc61bx+LCqClRl50A7+NoNlLIkU0eCrqQPe67IrQhUOsl38gHbhCS+iknOrTpo6uKMT+VpzLGgcc2fqwnd4aEr424PuEYcB77tN/UifqD4Aw/oMntY7DXZFpsVEE+pTijMY06brDecVB1S/Hi/i3bktMVB1AwE9M47D4dK3/MikBvN3gN9OAvVxjnq9m7kBhYBhWwzAgDXyuLkz6oNnsLiZkG2fA5UFa+RPP9CRQCN6vaEf3GRQqpgI739QNRA+mVd8wd4OEjii8tXZ9iWGJBUyA+YmUJBL2/qS3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+23ibNiV1Yc2rzUh1l1KkI6KdwxQfsvZjfYHXBaB5PU=;
 b=HekZMv71VLzKUlXxomWsbNHciCuH+YOV3CAeNBQ4aTtM4UVh8P8R0+a/R9OPagkL1hLDbDoldjwYFVfuzCThoxA04CDObHcCho+19idirpeCGnLC/LQ0UrX3rQdLcSYpnML+9NdoW0xxcKQULakB6mIuYWwKA3sZGfLEMxJXcE96vb20CF4cuGP2+mJZYDNLebwawBpH3fG/8sjem3gl0WAtrixf5zILIIeuSF2MNz8aJRP/3ES4RpGRVKs7Vv6d5xI5lavwQzHDLoabciktVL4ZXIth807ZoTtfXBAV3RKCyVkpFCnf+8lvSap5s+qdHqLcHEfFjI1glgB+EWLfZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+23ibNiV1Yc2rzUh1l1KkI6KdwxQfsvZjfYHXBaB5PU=;
 b=n3qcdOBnYZSV2Mio7nLBXu4dWB9jTDouDc21FwW3UnDLuVwqwszq2amA0r13gdvv4bPAJLT8YC61NkJ1wEngA7kQzwmuNKYVrXhFbI8S5+YIq/PLsijDQU9YAniCQlnywF++AYZE86bDMNEeAw44HghkO7S/X+5KVUpDqgFjJrVpUuTRe1aeQBbKvHBKq/uH2eNx0UVpioMEC5JU4OGjM+q8QniKQpJ7krttOEEy0DkI1hnnJV1/GqHQ7AfJAp5zTdcp8Wlb9uZabV7jRGmO1SkDxjaLo1l9qu1LH/sCjpGiH+zHen4SkYrSIiyvCyTM+wrWkxG8G7tz4b25apTMeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8096.namprd12.prod.outlook.com (2603:10b6:806:326::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Fri, 1 May
 2026 14:29:25 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 14:29:25 +0000
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
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 8/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_SYNC
Date: Fri,  1 May 2026 11:29:17 -0300
Message-ID: <8-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:c0::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e0aaf7e-3170-4d8a-fbd7-08dea78e0949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2YLCbwNeQoNuJBnoirNgMiwv+Z+op1fNg0YMA6ydT2ZEzynUYkCbJD02RV5J6rho+eXtGhd0extatJ3zyvQk2rgNJBp+VyYgbVKtGVazf0tPVB8KySkwdNqYsvcrNEGDm0eEjZx9bDEh8c+v7dSGDICGqrzJl6rIX6d9SNJWxGIgDAF4EU04t2bYqgV3EewzQRgaeckY14raDvl5kcHfkPjcv9DssyUZUJK9/ubAmVgxEY4lQL8ruKzRwUb+J5bFSDpl4Rbt52ngU1rGz9hs19esw+HxFETWtBElJTH4Dsv7bUUjvs65oCbcwcydqEGR2g5sxsNznm8i7/9DZePCGQQ6K/NRNzU03zM5ROc3ctm/pYk3u7uFZ/BpPcJQCeiKDgr643lxmgMyYsz6RGGUtej4rQSeXz2LLCes9+9pOkWp+UzoHzIJldvOA5heQ5Vw6tsosOZp9iNDx194IH+DpcbSiPAjxjlClZ6uMc/4SbTI2ToLmsIxe6iBbKsxdxrvG+Wy/fUukAnTcz/gSc5dRgQBIG+NvA6pKikuy6UgWt/elg5m9VYGcgGYA36a0glHKl68UUNwm6+kmzXrjRODJr0Cf0FcbXRJA08Ip3foEhLrMjDfsOXMXjFK1gmMHp/Yf2kcLHWDt1D69OzvOQShOTwq76B0TkBbn7vszlhfcOsdsSJSdRKSLndB/pRqUp8D
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O5peZc8YjgPt3aTpr6qpzTLkPtzAokA8Avop1UrEw0GpDq2XWIMZurJhl+Ec?=
 =?us-ascii?Q?+Wx6n/mPJhimiX5XNVAuruT5kE57ponEsQpCkRLQ3AzLoWoG/ikjn9rYmRYx?=
 =?us-ascii?Q?2kq91XlnBaOdP+1xi25kNSTbMZ3K9UvBbHCX5wGWSbEM+QLubBnh2yWyJ5ji?=
 =?us-ascii?Q?/FQCRrkihf8E7BgTfmX/TnEM4hup506JcOtfkleJQKBahAjVAQFynpTR8fL3?=
 =?us-ascii?Q?fh8mCTTaepVzPIeN4/Rsw2YqHRS3lTohiiUiskRlP2v/AXLbC9qSfbXtSQlH?=
 =?us-ascii?Q?xMqr6ES/D7JFFQgVgsPpsMSEtdSn691wvXkvhIiFdZioB80976Tfn7KuQwMW?=
 =?us-ascii?Q?iFS2EWWGvAYUUCPGnOGJVGrqxCsIetSenOR85aPc2pdHoWrTXW5it7SVEva4?=
 =?us-ascii?Q?hjFc53JYh91jpLjV5KeqEZmopCCNru0M+VzNjQSRWxVeA5DHENjYBdAz7tKx?=
 =?us-ascii?Q?3gAlirZqahr5xgMW+umhSwqjEH07nSf44tKx4oJ2oJcWYaFLO+W7Y/sZYkAI?=
 =?us-ascii?Q?SdPPIapZHthkm53qAgqBNAx4USqNyr9YmpOgX/1aEPK0hSUGxdjT5DSeWym3?=
 =?us-ascii?Q?QcSoRJR02gL7WEL8W6eGjPMv907n1PwsEf9npfO7McFQarrq7N0FUa1BqF/c?=
 =?us-ascii?Q?/ZCR+Lisi3aP0BGfCGpb69fHTwZT4sZGXpjTioHLj9DBJ7TlAOC0m/YBiIek?=
 =?us-ascii?Q?E6LLY97wMmLJYlWO+7Gln/o45a4lMF5zKUhq2HhJFuV3FXM8TqG+0pI721z5?=
 =?us-ascii?Q?QOUSiAuHZ5r1B3fKY6/rbPMIOt+Kaw3ytuPSWm1a6lVzV3PEFw8jFHS9UGJl?=
 =?us-ascii?Q?vAX2/6ASl4fSrdrorqO+g5i8DC7TjtOIOltjfrmLbN4a0Ct1eJhRomImfgvr?=
 =?us-ascii?Q?n/e43vBunBaeTuVJv40wr5k94O/l+EHFsJfm/Ng+cODhCkd91SEAXvhQK7j6?=
 =?us-ascii?Q?GbRioCRwNsb2nOiO8I1a96HZMMEuPdbQ3TXY1Gop0zhUwqUJtXSm2TKPdmj2?=
 =?us-ascii?Q?e4nrQVBbHw1THg2NfQeYdLrZDcDvtQw82GpFJ5fdlcTXv9aQZptht4IUmJ7R?=
 =?us-ascii?Q?+Utl10MNJZzKU8OTO1IM6/K6p0lMPw8dfk9r61NKKjZvhR6GFSb321jzOnsV?=
 =?us-ascii?Q?ZVCU9roy5Vo4jcSbaiHB79SYsmBpAO2srIlqZ9uV/eXPZF+hFxT+48d37Kct?=
 =?us-ascii?Q?mVpL58lDH070SVRZApWh+M9XdtJf8dGgOqI9qtsZ5Nw/OwttHECFyVZdzTny?=
 =?us-ascii?Q?TCnSf8rNTz1e+Ftt7r/g/xbkdAPqNlx2YgIdPoONmn3U8buTLrI1HSlL2fat?=
 =?us-ascii?Q?mIZfDMlMSAPqP3r0ybbAgr3TsLEHIuUsUz97jgT1vFkhLVWkR/+jzWO1yF5l?=
 =?us-ascii?Q?OBC9L1Q+qV+s1cWfITVNOTszlGx7zM4VZosxRKPQdfErLomF1RmIDQ0Vtzsx?=
 =?us-ascii?Q?sFhAPFV/TmP2+kv+nwcZFkAjdmPA8xBxlig+o/jtvmvrqroOdu0HflNs6N9h?=
 =?us-ascii?Q?Y8Z9Z/oOIlkXP51xpAG65UdVmGzY0/aw41DnR6qRBhghKVVBj0aCuRP8ayyA?=
 =?us-ascii?Q?w8jzCZYHsKDtNnYEIpNVUaIDNF3ciVS5fMNl8Ml3RY40kVTxXvqlSnHRfFvE?=
 =?us-ascii?Q?LV5tB2h0WasEvU5Dm2LU2BOAJeWV32HP34JTXKO2MqzFHKZZjjVWLVMfRnUG?=
 =?us-ascii?Q?0wqUFrzSagKUl/24Sr5t9y/fQvchCFgQNMivGkJlCxz0c2fa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0aaf7e-3170-4d8a-fbd7-08dea78e0949
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:22.5517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9+XF/YgrUCS0tQyZhqyIyq5i0EA4KApDP3I7b9ekCmdRP0u3tGLnNDSEEHpG2OH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8096

Change the flow so the caller controls the CS field and remove the
weird u64p_replace_bits() thing to override it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 42 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 16 ++++++--
 2 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0cdf0752ff6d62..8147b9cdcc6b99 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -308,16 +308,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
 	case CMDQ_OP_TLBI_EL2_ASID:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		break;
-	case CMDQ_OP_CMD_SYNC:
-		if (ent->sync.msiaddr) {
-			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_IRQ);
-			cmd[1] |= ent->sync.msiaddr & CMDQ_SYNC_1_MSIADDR_MASK;
-		} else {
-			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
-		}
-		cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_MSH, ARM_SMMU_SH_ISH);
-		cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_MSIATTR, ARM_SMMU_MEMATTR_OIWB);
-		break;
 	default:
 		return -ENOENT;
 	}
@@ -350,23 +340,24 @@ static void arm_smmu_cmdq_build_sync_cmd(struct arm_smmu_cmd *cmd,
 					 struct arm_smmu_cmdq *cmdq, u32 prod)
 {
 	struct arm_smmu_queue *q = &cmdq->q;
-	struct arm_smmu_cmdq_ent ent = {
-		.opcode = CMDQ_OP_CMD_SYNC,
-	};
+	u64 msiaddr = 0;
+	unsigned int cs;
 
 	/*
 	 * Beware that Hi16xx adds an extra 32 bits of goodness to its MSI
 	 * payload, so the write will zero the entire command on that platform.
 	 */
-	if (smmu->options & ARM_SMMU_OPT_MSIPOLL) {
-		ent.sync.msiaddr = q->base_dma + Q_IDX(&q->llq, prod) *
-				   q->ent_dwords * 8;
+	if (arm_smmu_cmdq_needs_busy_polling(smmu, cmdq)) {
+		cs = CMDQ_SYNC_0_CS_NONE;
+	} else if (smmu->options & ARM_SMMU_OPT_MSIPOLL) {
+		cs = CMDQ_SYNC_0_CS_IRQ;
+		msiaddr = q->base_dma + Q_IDX(&q->llq, prod) *
+			  q->ent_dwords * 8;
+	} else {
+		cs = CMDQ_SYNC_0_CS_SEV;
 	}
 
-	arm_smmu_cmdq_build_cmd(cmd, &ent);
-	if (arm_smmu_cmdq_needs_busy_polling(smmu, cmdq))
-		u64p_replace_bits(&cmd->data[0], CMDQ_SYNC_0_CS_NONE,
-				  CMDQ_SYNC_0_CS);
+	*cmd = arm_smmu_make_cmd_sync(cs, msiaddr);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
@@ -383,9 +374,6 @@ void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
 	struct arm_smmu_cmd cmd;
 	u32 cons = readl_relaxed(q->cons_reg);
 	u32 idx = FIELD_GET(CMDQ_CONS_ERR, cons);
-	struct arm_smmu_cmdq_ent cmd_sync = {
-		.opcode = CMDQ_OP_CMD_SYNC,
-	};
 
 	dev_err(smmu->dev, "CMDQ error (cons 0x%08x): %s\n", cons,
 		idx < ARRAY_SIZE(cerror_str) ?  cerror_str[idx] : "Unknown");
@@ -419,10 +407,10 @@ void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
 		dev_err(smmu->dev, "\t0x%016llx\n", (unsigned long long)cmd.data[i]);
 
 	/* Convert the erroneous command into a CMD_SYNC */
-	arm_smmu_cmdq_build_cmd(&cmd, &cmd_sync);
-	if (arm_smmu_cmdq_needs_busy_polling(smmu, cmdq))
-		u64p_replace_bits(&cmd.data[0], CMDQ_SYNC_0_CS_NONE,
-				  CMDQ_SYNC_0_CS);
+	cmd = arm_smmu_make_cmd_sync(
+		arm_smmu_cmdq_needs_busy_polling(smmu, cmdq) ?
+			CMDQ_SYNC_0_CS_NONE : CMDQ_SYNC_0_CS_SEV,
+		0);
 
 	queue_write(Q_ENT(q, cons), cmd.data, q->ent_dwords);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 194f73cabef5c9..538380de7d48a0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -571,6 +571,18 @@ static inline struct arm_smmu_cmd arm_smmu_make_cmd_atc_inv_all(u32 sid,
 	return arm_smmu_make_cmd_atc_inv(sid, ssid, 0, ATC_INV_SIZE_ALL);
 }
 
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_sync(unsigned int cs,
+							 u64 msiaddr)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CMD_SYNC);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, cs) |
+		       FIELD_PREP(CMDQ_SYNC_0_MSH, ARM_SMMU_SH_ISH) |
+		       FIELD_PREP(CMDQ_SYNC_0_MSIATTR, ARM_SMMU_MEMATTR_OIWB);
+	cmd.data[1] |= msiaddr & CMDQ_SYNC_1_MSIADDR_MASK;
+	return cmd;
+}
+
 /* Event queue */
 #define EVTQ_ENT_SZ_SHIFT		5
 #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
@@ -648,10 +660,6 @@ struct arm_smmu_cmdq_ent {
 			u8			tg;
 			u64			addr;
 		} tlbi;
-
-		struct {
-			u64			msiaddr;
-		} sync;
 	};
 };
 
-- 
2.43.0

