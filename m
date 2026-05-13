Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388BD3CE485;
	Wed, 13 May 2026 23:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716691; cv=fail; b=rZzi0zH/yRTADd39xacPaY55Wqj4jDDUZstTkH5Am2ea9D1SjW648haemzJm/IWXIFa+eCpFbPusQydZt6mxgmpFxCNAqBJcMiITsVg8IZCN+sN+4tPVMlYUExpvrlHnBTxorFsTgkq2zh13o2x70bmMIe7YgKNGwfTbCiKk848=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716691; c=relaxed/simple;
	bh=7vTmd5kRWUaSxOoa7OUb7sWNvFthY8N1zT072/hmljc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sOBVoIcTX1OQR8DgdnQyIXHAFxBrFxEQ+NtTGbmumSZ+hVRGDIC1wQJ52SZTN/mBqMyp2kjPO3qtW6mR3R9meGhCIjSdAyuP7JF1e76fdc9EmE5i+VhNmxkwHSrad4Q85SY+ZF8fk/wSie3WK+UENcgux3Zf0gopM8yKyMEo7sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N/ixGrmv; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N/ixGrmv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c4NsRher4Yd85mzX3wLPGb/lntFXxTbs4Xicw8pKoUA6lwJ7DXOWMeg4+9FLwHvFU/fyAiy0njlCOG7GOPv5nMp164tlJnm5A72o+h1+8M7fSDdPx8pFpz25BvOYsXPWMY3tyVXVUN+x3DGwa/b75fl//bJxD7F0viv88oT1V3b+ZATD8/jnw0r3yPQyLSt36nE+QFLzIQjeBK5kTR94077JFKNS13vyj0DIorsZcnFxws/FUjqr9m1qhcwABfFlVUCbIdFZ0rW+Ke9xqYlJgdFRKaLnevL9hCUMCSOONii4k4S5lYDfB3QRtIzkRlBB79vv4QNqB9zhS+9yIYL9IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REwXXkRDimZLnWFk17shy2VyacSOgz6J7dP94RL8VbI=;
 b=c87L6ZWtIb8LK1Jacr++2dG6eOcxxm+nShYPqi/1osCbV1fEGdpWwLyKrR9qZ2ocqTl31Ry+aYCKersagtvPGDn4hBawd1r5qN+R+ZDSaI/SR5J6Lr+fsWiyqCQwp2b1LKoHyeeke56h0U8Fim3+DG6f4mrDee8IXpURfig3D/soUTedem5dnQ/9QYRtZBK+bwHF6BHikijhV9mp5EXrv86FBhGqnqr41dS6qOrxzniKMLv+RouIfLhRSihXAGK8De85yP9P669aa8kZB8VPdPmBrGdHLBseBydxmWM3zApGgpME1lvon/tK275skSghTFhp44O+kGYd1OiYLOzFaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REwXXkRDimZLnWFk17shy2VyacSOgz6J7dP94RL8VbI=;
 b=N/ixGrmvPt+skWUqpAo3W9vMRtFc7VnhfDpsz+e3LNAkC68CONT83tSYeK5L9Og/+/luzu8Z+vs0sVj925brArNauvGE6s/exsgUY445lkshpOIef+7ZsmHzXgjlRopT/CdbJZcWlwOVQ0nLWI5HWQ5CbfYuVaeAgu1JyajI8pQbrB0CdU6y4+EkXGeQjOxpcE4SW4KwnrsVl3vewNyO/GzaimYJDXQlmmBhn5BKLQCizFZ48QLmNjqe+dT53BMJhvyoT+XlJ4rSXuZjSnvrJ+3dys5PIUqixcIni8ulYCa8/4nm6ApqW615ckQ7uOpfgevk7LPLGA6BcDxw08mgTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 23:57:56 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:57:56 +0000
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
Subject: [PATCH v2 9/9] iommu/arm-smmu-v3: Directly encode TLBI commands
Date: Wed, 13 May 2026 20:57:48 -0300
Message-ID: <9-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0097.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: b2ec3e8b-8766-4ee6-74fe-08deb14b72da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799003|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	V5CAT8N6ziNOq9fADjj8oRGhLbMcoCkRoiRPx4E+d2b2pbHQWV6lA/llhrb5TqGGOT8Pzz3oi0MGGrdNv+SkajHrWS4Px+cyig6dZP0QOy6voFFUyoIBBYoV8E70qWo5r7Y0yy1FU5cMw3W3PvD/n4L8F/+tMQcwyNhxht9u2rHo+gDRiqIDP/vrm4mpxEG9+9h368ZNSQ4RCoQw9jK4IJfC9SLtP0AagoaceqEaE6+1LrpZKVXkHQxH2YE3ogbWOhCIOV6//9WF+rLSOspa2FcVnchnP3AumANjQQRuVziu2CbpAueGjAm1UQAqjBX9TjB1eqFtuAn5H8233QlvU0JzCn3bp9jSlNNTSroJpRZnTLj8OSaviVYphb5ES5i0rbzvE3XsuX08GPCMoHebCb01NdQuz1DHpH+ZuOlxB5gPqNBY1BBRlDYu9OhuggtF25S4tRR4kqRKvYssHf/uaMWlAqlJvnqQlK64/1Mmk7r7acR80JnktDD18COXi3Qv4LSUkTWD0pIdbmh6gWIzl9CJ22KFZXFUaAxMWxXVea3l7onXAqfmMwgFwpdS2s05Eo00YI2PwrwntsgyLPsPHSl1DFIYGNwskBBWjtIrKbW7uo3gD5AIqHs06eu7LGWlYnPRNxcRK4UIjp4vGQ2txkHWQj3ZR13ca/7ozPql05XQ3IX3Jc49YIbNUrYcuDg8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799003)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TSfbwanR2eoRKRW5jLBL6U2umG/FA++K1qEvAFjzJqTnj2vv1DCiYRB1q0ea?=
 =?us-ascii?Q?XIsw+aK29TsW5QB0YSkBQjjMMaH4oI89PaA4rKqJm150GH7/fS1ib1ObSZAA?=
 =?us-ascii?Q?v5o4xR7gfRFv60IUNM/k9e10ycZhnA5EiTrfyD5W++UYX/x3ap0IyAIFrkC9?=
 =?us-ascii?Q?+LhloYgNag0FcLMHWW8clr+YPZwgsorNBCPu8Ze8HSAbx0jYZL0z7qAAbf9t?=
 =?us-ascii?Q?Uet57iG9QdXUb2mCd4AQBUmlH8L5CZc8yoDdx87RINhSVUTAT4O52gZjugFu?=
 =?us-ascii?Q?4AcOzyKhRUHqiy2E++eKVCuoE/PRgT1jW6OnGpw1483vGuDvNIqPE4A+j06+?=
 =?us-ascii?Q?KpBkdvKtTAqEbTl6TzjWMyTnWpi+xqbhYbNoJvUIfPnGqYp7mAXbLQKvl/qL?=
 =?us-ascii?Q?FRK5HNIAWGJfIHpIoW07hiey3DZp/lYwNFhR3GCnWM20MitV8JXFIE+8t/zk?=
 =?us-ascii?Q?bprbueH2IyBiO51NfeJU447vLCDvgX6Myaff8LC7CW1JJUJl2/x1HAp5AlGV?=
 =?us-ascii?Q?FPRJGZTOgqQvXW+c1i99z7hfXhvEEB7K8WCXyTGoeDqSyGs8cNmWjzLklO5A?=
 =?us-ascii?Q?2cAJf0DfHcF5EK8i4ooexokQT5ImzEIZl+Wlhns8/gitcfuNIClLyo0ydiwa?=
 =?us-ascii?Q?YY4YFwFokc0n5vLcxzhjwJ/3sInAe71Jid5pqrUNtSp2ZjzxzANdQmGzzb76?=
 =?us-ascii?Q?HsboXhH+6tzA4+beZAs/slDckCJqIWHVGE8waXyeAGPpV/E95cVoyEde4mqF?=
 =?us-ascii?Q?vQ/L162Nqizkw0+da2kmdMdYImBtiD0Tbp8JaQgON6C3BXH1JjB/KUANj6wT?=
 =?us-ascii?Q?JtrNRDRjS3mwsQtCc7PTXz/L4/tpoY9r7ZTDQTyeTMO2gS22KCZu21zf7QxD?=
 =?us-ascii?Q?+a2F+SYnixQnMDWZG7seE4vFTgGvPZFzXEbNBIzS4eYvpgO+B6a7V2wOnDYV?=
 =?us-ascii?Q?+5VZWOnFNCWrbBrBcwbi1z1L3+jDpLCRxuoBPddlpYbN3+rZuVPzh/ZfVAc1?=
 =?us-ascii?Q?ups1btwPLIb3Ubt+a4zyObPQt/JZjKYMfvpLafU9UvX9DTsdL07IRO3Yz5Lz?=
 =?us-ascii?Q?oKqNH3aJstaGOevNKltypB4ts0i6ClBAtetwSl8bq7zZT9SWvxCxaMbR/4bm?=
 =?us-ascii?Q?o9lxxlpJR/IBzCarogkn2zMXZvhD3afZhs3LREOEgaTarPq5eeM2/8l1ywsC?=
 =?us-ascii?Q?nH2idCSwZG98yzoMepVPlea/IissCjI2c0w9wzSW6NN38nI3ivzXkfxz0i9T?=
 =?us-ascii?Q?NtaSVT7CHrY5O3Y2VXk3g8kvnfa5t7/BNk8AwLrINX3/BH+VWPL0Nr3R8f1t?=
 =?us-ascii?Q?mzKbKUzaLdlTuUExOJ6L6/t44buZeT151uPaFLwO/4B5bP72Jra3u9pYeRuY?=
 =?us-ascii?Q?8ZrbNij7SOBerVcH1A5eOKLp7i5Pol5O3UL7EQ/0N0z4z3mZB8vQJ+nb26dD?=
 =?us-ascii?Q?6udxMeubGgI+I9IJQMGbU4ITmAH7tnMI4W6+tlU5Or9rxqzpTPXXHSA30wl4?=
 =?us-ascii?Q?vbXU91C5/ax7lMQj7/tdzkXkDX0Gqw3sVIODIdrmYjtuYI89YFodJzwakZye?=
 =?us-ascii?Q?8OL7zEsJu6jLd1sEDn6VmnLA86p0OJRLyuS55iJivvVcceO6KtUBvtpn0+6V?=
 =?us-ascii?Q?PgjoCmZqoq9ahc/x7/QHSdkgbYIi9TQPcwafUCwMgtKPG4DEd64BrlhPLUM+?=
 =?us-ascii?Q?osnyMkdUz7Jbh/b+Zi0+W50yfUCBR5g5t9MPNsb7kpQAF35u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ec3e8b-8766-4ee6-74fe-08deb14b72da
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:57:54.3319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vv5AFxEs7+LcWkKBMe/lHfJA8BXuQWwCh+nU8FfGWU3CwJJWgZAfHpoD5zg9Cgd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

TLBI is more complicated than all the other commands because the
invalidation loop builds a template command from the struct
arm_smmu_inv which is then expanded into many TLBI commands for the
invalidation.

Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 170 +++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  35 ++--
 2 files changed, 71 insertions(+), 134 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8147b9cdcc6b99..9be589d14a3bd4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -268,53 +268,6 @@ static int queue_remove_raw(struct arm_smmu_queue *q, u64 *ent)
 }
 
 /* High-level queue accessors */
-static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
-				   struct arm_smmu_cmdq_ent *ent)
-{
-	u64 *cmd = cmd_out->data;
-
-	memset(cmd_out, 0, sizeof(*cmd_out));
-	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
-
-	switch (ent->opcode) {
-	case CMDQ_OP_TLBI_NH_VA:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
-		fallthrough;
-	case CMDQ_OP_TLBI_EL2_VA:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
-		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_VA_MASK;
-		break;
-	case CMDQ_OP_TLBI_S2_IPA:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
-		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_IPA_MASK;
-		break;
-	case CMDQ_OP_TLBI_NH_ASID:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
-		fallthrough;
-	case CMDQ_OP_TLBI_NH_ALL:
-	case CMDQ_OP_TLBI_S12_VMALL:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
-		break;
-	case CMDQ_OP_TLBI_EL2_ASID:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
-		break;
-	default:
-		return -ENOENT;
-	}
-
-	return 0;
-}
-
 static struct arm_smmu_cmdq *arm_smmu_get_cmdq(struct arm_smmu_device *smmu,
 					       struct arm_smmu_cmd *cmd)
 {
@@ -894,16 +847,6 @@ static void arm_smmu_cmdq_batch_init_cmd(struct arm_smmu_device *smmu,
 	cmds->cmdq = arm_smmu_get_cmdq(smmu, cmd);
 }
 
-static void arm_smmu_cmdq_batch_init(struct arm_smmu_device *smmu,
-				     struct arm_smmu_cmdq_batch *cmds,
-				     struct arm_smmu_cmdq_ent *ent)
-{
-	struct arm_smmu_cmd cmd;
-
-	arm_smmu_cmdq_build_cmd(&cmd, ent);
-	arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
-}
-
 static void arm_smmu_cmdq_batch_add_cmd_p(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd)
@@ -934,21 +877,6 @@ static void arm_smmu_cmdq_batch_add_cmd_p(struct arm_smmu_device *smmu,
 		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &__cmd); \
 	})
 
-static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
-				    struct arm_smmu_cmdq_batch *cmds,
-				    struct arm_smmu_cmdq_ent *ent)
-{
-	struct arm_smmu_cmd cmd;
-
-	if (unlikely(arm_smmu_cmdq_build_cmd(&cmd, ent))) {
-		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
-			 ent->opcode);
-		return;
-	}
-
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
-}
-
 static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
 				      struct arm_smmu_cmdq_batch *cmds)
 {
@@ -2450,12 +2378,14 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmdq_ent *cmd,
+					  struct arm_smmu_cmd *cmd, bool leaf,
 					  unsigned long iova, size_t size,
 					  size_t granule, size_t pgsize)
 {
 	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
+	u64 orig_data0 = cmd->data[0];
 	size_t inv_range = granule;
+	u8 ttl = 0, tg_enc = 0;
 
 	if (WARN_ON_ONCE(!size))
 		return;
@@ -2464,7 +2394,7 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		num_pages = size >> tg;
 
 		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
-		cmd->tlbi.tg = (tg - 10) / 2;
+		tg_enc = (tg - 10) / 2;
 
 		/*
 		 * Determine what level the granule is at. For non-leaf, both
@@ -2474,8 +2404,8 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * want to use a range command, so avoid the SVA corner case
 		 * where both scale and num could be 0 as well.
 		 */
-		if (cmd->tlbi.leaf)
-			cmd->tlbi.ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
+		if (leaf)
+			ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
 		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
 			num_pages++;
 	}
@@ -2493,11 +2423,13 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 
 			/* Determine the power of 2 multiple number of pages */
 			scale = __ffs(num_pages);
-			cmd->tlbi.scale = scale;
 
 			/* Determine how many chunks of 2^scale size we have */
 			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
-			cmd->tlbi.num = num - 1;
+
+			cmd->data[0] = orig_data0 |
+				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
+				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
 
 			/* range is num * 2^scale * pgsize */
 			inv_range = num << (scale + tg);
@@ -2506,8 +2438,17 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 			num_pages -= num << scale;
 		}
 
-		cmd->tlbi.addr = iova;
-		arm_smmu_cmdq_batch_add(smmu, cmds, cmd);
+		/*
+		 * IPA has fewer bits than VA, but they are reserved in the
+		 * command and something would be very broken if iova had them
+		 * set.
+		 */
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
+			       (iova & ~GENMASK_U64(11, 0));
+
+		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
 		iova += inv_range;
 	}
 }
@@ -2538,19 +2479,22 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
 /* Used by non INV_TYPE_ATS* invalidations */
 static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
-				       struct arm_smmu_cmdq_ent *cmd,
+				       struct arm_smmu_cmd *cmd,
+				       bool leaf,
 				       unsigned long iova, size_t size,
 				       unsigned int granule)
 {
 	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule)) {
-		cmd->opcode = inv->nsize_opcode;
-		arm_smmu_cmdq_batch_add(inv->smmu, cmds, cmd);
+		struct arm_smmu_cmd nsize_cmd = *cmd;
+
+		u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode,
+				  CMDQ_0_OP);
+		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
 		return;
 	}
 
-	cmd->opcode = inv->size_opcode;
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, iova, size, granule,
-				      inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf,
+				      iova, size, granule, inv->pgsize);
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2585,38 +2529,39 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 			break;
 	while (cur != end) {
 		struct arm_smmu_device *smmu = cur->smmu;
-		struct arm_smmu_cmdq_ent cmd = {
-			/*
-			 * Pick size_opcode to run arm_smmu_get_cmdq(). This can
-			 * be changed to nsize_opcode, which would result in the
-			 * same CMDQ pointer.
-			 */
-			.opcode = cur->size_opcode,
-		};
+		/*
+		 * Pick size_opcode to run arm_smmu_get_cmdq(). This can
+		 * be changed to nsize_opcode, which would result in the
+		 * same CMDQ pointer.
+		 */
+		struct arm_smmu_cmd cmd =
+			arm_smmu_make_cmd_op(cur->size_opcode);
 		struct arm_smmu_inv *next;
 
 		if (!cmds.num)
-			arm_smmu_cmdq_batch_init(smmu, &cmds, &cmd);
+			arm_smmu_cmdq_batch_init_cmd(smmu, &cmds, &cmd);
 
 		switch (cur->type) {
 		case INV_TYPE_S1_ASID:
-			cmd.tlbi.asid = cur->id;
-			cmd.tlbi.leaf = leaf;
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, iova, size,
-						   granule);
+			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
+						     cur->id, 0);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
+						   iova, size, granule);
 			break;
 		case INV_TYPE_S2_VMID:
-			cmd.tlbi.vmid = cur->id;
-			cmd.tlbi.leaf = leaf;
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, iova, size,
-						   granule);
+			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
+						     0, cur->id);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
+						   iova, size, granule);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
 			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
 			if (arm_smmu_inv_size_too_big(cur->smmu, size, granule))
 				break;
-			cmd.tlbi.vmid = cur->id;
-			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
+			arm_smmu_cmdq_batch_add_cmd(
+				smmu, &cmds,
+				arm_smmu_make_cmd_tlbi(cur->size_opcode, 0,
+						       cur->id));
 			break;
 		case INV_TYPE_ATS:
 			arm_smmu_cmdq_batch_add_cmd(
@@ -3359,24 +3304,21 @@ arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
 
 static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
 {
-	struct arm_smmu_cmdq_ent cmd = {};
-	struct arm_smmu_cmd hw_cmd;
-
 	switch (inv->type) {
 	case INV_TYPE_S1_ASID:
-		cmd.tlbi.asid = inv->id;
+		arm_smmu_cmdq_issue_cmd_with_sync(
+			inv->smmu,
+			arm_smmu_make_cmd_tlbi(inv->nsize_opcode, inv->id, 0));
 		break;
 	case INV_TYPE_S2_VMID:
 		/* S2_VMID using nsize_opcode covers S2_VMID_S1_CLEAR */
-		cmd.tlbi.vmid = inv->id;
+		arm_smmu_cmdq_issue_cmd_with_sync(
+			inv->smmu,
+			arm_smmu_make_cmd_tlbi(inv->nsize_opcode, 0, inv->id));
 		break;
 	default:
 		return;
 	}
-
-	cmd.opcode = inv->nsize_opcode;
-	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
-	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, hw_cmd);
 }
 
 /* Should be installed after arm_smmu_install_ste_for_dev() */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 538380de7d48a0..16353596e08ad8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -583,6 +583,21 @@ static inline struct arm_smmu_cmd arm_smmu_make_cmd_sync(unsigned int cs,
 	return cmd;
 }
 
+/*
+ * TLBI commands - the non-sized variants just need opcode + asid/vmid.
+ * For sized variants the caller sets up data[0] with the immutable fields
+ * (opcode + asid/vmid) and the range loop fills in per-iteration fields.
+ */
+static inline struct arm_smmu_cmd
+arm_smmu_make_cmd_tlbi(enum arm_smmu_cmdq_opcode op, u16 asid, u16 vmid)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(op);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, asid) |
+		       FIELD_PREP(CMDQ_TLBI_0_VMID, vmid);
+	return cmd;
+}
+
 /* Event queue */
 #define EVTQ_ENT_SZ_SHIFT		5
 #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
@@ -643,26 +658,6 @@ static inline struct arm_smmu_cmd arm_smmu_make_cmd_sync(unsigned int cs,
 #define MSI_IOVA_BASE			0x8000000
 #define MSI_IOVA_LENGTH			0x100000
 
-struct arm_smmu_cmdq_ent {
-	/* Common fields */
-	u8				opcode;
-	bool				substream_valid;
-
-	/* Command-specific fields */
-	union {
-		struct {
-			u8			num;
-			u8			scale;
-			u16			asid;
-			u16			vmid;
-			bool			leaf;
-			u8			ttl;
-			u8			tg;
-			u64			addr;
-		} tlbi;
-	};
-};
-
 struct arm_smmu_ll_queue {
 	union {
 		u64			val;
-- 
2.43.0

