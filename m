Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2723CAE74;
	Fri,  1 May 2026 14:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645770; cv=fail; b=eFW3LAT9p13cO86kvqf+QLqs7hcIJTWVHiLGm6xfMHEexfCM7lkI1+PCv/OFa0ei7EQoghXFEoeKYVZdzSHfPta3RvVlK6FvzBSBwxFhZ20Qx4RRkCrZ+3AmNtS8ASvTMRvWMRQK7isjijlFRwUUD+2sBLtyST9kDLuYgbgqYl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645770; c=relaxed/simple;
	bh=HeDOCrrXKa0ncxY88pk1d0VVBLQdFhWkoTqoZ2BGxSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=otdlVrxhUPiNSWx3CAiO+MVIjO9EWwCQY0bOfD3o+WpiC5Sm13x6apUk88mSEAq2gkywQaWjRjir962yoT+5XnFe/x+VaJQg0izNASUv/idRyxn9/1uL+W9RWC7ojAVD1q0ky/HCgB798JQjTsEa9n8nhwAPUMhTaSexYEET64k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YxCen9cV; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YxCen9cV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FuLntN6mpoMKQwwiY4M9XZ7OZh7LdDVcZHVDZSb5YooKm5hDRz4y7XOxhbPKO+tHof2JYWxqaayPZGHmtwtP+WWqeE1tkAMg5aC7Dk+hygSCNe/lu+rgr4Gv4xpe+AN3NlDMg0cWIX5XGCyq/zBaTf7b5Emu1Vpi+ubxC9psnUA4VlUQre9bryWUQv0ktdkFkQi3q2b48879q7mLdR6HlxrOclovdfV0w2ruYoESP24g26SQ8sn/WaR0hqRsMdhXoxgl32Mdprwb3FoayC4aRGXfWBHRh8ZVm8WlZNJyWJC1+YlQhKCqJUUzxEXkXF73sE7SDw6bouM8u7vohOC5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RYIXocgMM5PzB9N2mYiUcD0fy2ktzu64bjEhQcjwNY=;
 b=k31VC86k5f04PIJsnMf3Vxcx3c3tV+UYThriIbIoY4uLAhlyIX0EvYt4/WUHqLh0lmNj87FHwKzrxpb3CP5Z48BGbIlUbTmlFGoOSlMDQs2cy9C5S9BEUe/LMEI1mN+kj8QvDSTb1yuLJReYpLPDaine8GsiaAWRyoM9zLUV8sSr+CZKrj+vLh7u9qHrcPJFLvEOdYKS3HMXe+2RKV1AOgtyRSArZeZaGb71AG+DpPeQy2ajLub1zKv9cgumzyvAtv6Y7ycZhD2QXMMcC139geWx6QHi4sglYzeWi3YIutSEGqqHt2gukv1mcm8jjMDFVASKPaRRln2pLN3qITFHmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RYIXocgMM5PzB9N2mYiUcD0fy2ktzu64bjEhQcjwNY=;
 b=YxCen9cVoGo8yHvSSQH95jIEEbVhm74PFDF8Dw3BnlyZlnDZqBfLG0XrhZN183ehLpn0ah1FHMuYioVBlIvnx3D4LD2vSdnkDtlr2pCR71FaesJSQhyRRQ9FwVwyBWzxb2W5LrDWbdelDqb3ckF07tMMX2D2ke3GkadUS3Ifw/bD0qJdxgVAYtAfO/QUJY4tDanmtDB3RJEkIlLwx1JYbBOhFkiaDhe/LjsCveFzMWZQA8pOk1b0pBsYM0B1lti4PEXKLrzVuw8akjFLlee3IzuiMOGw/sWkVMBCjxDrKWODMjJMPGCMU5apqeVS+E3jO5HcTc2gvdp2HP9f6YP1YA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8096.namprd12.prod.outlook.com (2603:10b6:806:326::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Fri, 1 May
 2026 14:29:21 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 14:29:21 +0000
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
Subject: [PATCH 9/9] iommu/arm-smmu-v3: Directly encode TLBI commands
Date: Fri,  1 May 2026 11:29:18 -0300
Message-ID: <9-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0040.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: b0032a06-8315-434b-3444-08dea78e07ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dZBKz35QRhazgiJ1oxnAiv7kPjcVwAsja/+rgQgb6Z1NP6w3Fbkb1izVdPKXuVirQfAmxz3UDHJO7oPChbVJeqSqwFWlI0K8Z0goB+Apc4zRE/xdGP0pYqMpllQR1iiGLF1nQ0Q++6BbyBnoUgyPiiW/KVoy3m24bHv1Fr/5bDpPbntVzc0jn1Rvu/OgISYedkTkK1K/TACDyabN4MTpM0nRtXWUxHhOyTDTcEXJcdOka7Jbzgtn1csOPjJPlz2GuMyUuPJO3dnumylWCdpndjxPfohlUtGp+nFMBlMDowwzAuuDM3f2tDkbHgGk/1opTgJEqevHkOA+FufJdwIdpYQizaWqthS9O7YVdrpGae1EON7Yb2/+FRKYZYuYqCZiM6gqYbpWkO4zealiDI7RQqtezwnUhASVNgwikzJDWXR/zdem3Fl71282DVoYKjjSEhPksNvWxts3lE2clU6aC2aqXVittFK4E6WsRhDy3O0nPbxV29d30OLe/PwZhjl9FTzdb5BqCysyjPXVBtFhbWusxNNZjUjm2dCRno4SXIF7+na1GYosS89JIaOWks8YsCvSKiDjUvvz0O1j09jTPEmwvE+tDZkEd198lf2NoL8odhIaaCn5toiaRQXfWOXpfBWO7gmc4ybc2BKgYNzZSJIKU+pkeS1tRwXyBGQjUsqh+iPM2UkRjXyX3zcDg1pJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HmFVdSmm7lBgW7QuoH1Hl9WJTAgXAWFIhLRDIenAuYEd3duBXOuuI5fomP9b?=
 =?us-ascii?Q?sHChh6WuqTaayw5HwMwnEtahrLk1diDJj5NDK+qHeU+uFlUfYwbXLy2fQjTI?=
 =?us-ascii?Q?iD1tZjWjit1WI74wjgTB6+6fFzkP28N2wp6TeNBW45AiBJFzoXsOABmr6UYo?=
 =?us-ascii?Q?/x6bLoiC56Dq1vYFZtz2fcfLLAnu8zw32EZZ9HWOqD6quxJqcL1L7vYoXsLR?=
 =?us-ascii?Q?KLgJX6j362le4HnWNT5xgmef5UAWExILYj4QQCNIaqHaDXy70aSsa9ie4ZGI?=
 =?us-ascii?Q?vyMifdWzwLfzBy1KYSFMcRMuuddpHiVzlnTATTgdaAtD42mmMz48GovrasT1?=
 =?us-ascii?Q?SphHtKJkbOBVYFkFFvrLf/9XKOFDrCsHtHgnyF5qu3lP4jgpFXomDn65VRrw?=
 =?us-ascii?Q?W63jMWGDI01YCDLHFw0jv0J0LS+sMc2ys50ItRMDIWjXRcl5O0gxUuO3XI2W?=
 =?us-ascii?Q?ekbBH9dWqCVkCda5oCr/jiL3Ipd9QTVI9ysA8Ng/UCqYbAzZaZ3ESzjbmpDp?=
 =?us-ascii?Q?23DE70uH7J18vW9MuXxZtW9ryro8QFhjqCUaVIruiWkjLGWEhwL996PHYJjT?=
 =?us-ascii?Q?iaSFgUSR0iINJ8Oy3zIi/z0YJz2pbJmy2cMhEQom9aw70SWyQZczPtflJByO?=
 =?us-ascii?Q?Ad+iNbu4eqetHyzfb+oCM2iCxMvTjQxTEb02303ZpYyS25MElBRwU7fDwMtz?=
 =?us-ascii?Q?JasD8My+aSUG/RYNu0e/Dt9gwYtOy1PUhultZG9OFN4cig0U364BIo2ESD7S?=
 =?us-ascii?Q?xYOE9nX5aAJIPooXNq0rSIEXsmqiOXLxHUYE5fgW/WaVZ8MROiKtREsac8Js?=
 =?us-ascii?Q?PuSp0rqWH++T5H8sA9wXrJG2KObFUvDE7jrl19M52NOZXYI/JIYzxaiNHzqm?=
 =?us-ascii?Q?yv5G4GfrthYi2QA4GAolwGiCXRBQIS6CygftKUPRja7gOtTjSH2SQA+kxK+H?=
 =?us-ascii?Q?OTSE4iB22U5LQ5fD2hcMnVB7SSODuxpyn824Qffn+CkO0BPd+HnpsrR+Fj5K?=
 =?us-ascii?Q?rid++21pQ2Jq4ocV+CK5VyRK8FL+mEU2C4p/L9oPOtkBGNmHNOv0PsRUlCWR?=
 =?us-ascii?Q?szNoJRNfKxgRRkmCCFZqJY5JnS19QQGTW4041+nrvHmBFg6yKaZ1XS1IpvHg?=
 =?us-ascii?Q?JMoVzasIzDzLl6a/LnY0rFSjBnlToZsDYGz026puYOJLR+P9qADKaP22m1Xg?=
 =?us-ascii?Q?qxtrLjL1qR8D6p78Mbhl7Y2zAOhn1DbDAemBkM+zaaebJg7q0vRxsQHmE4vk?=
 =?us-ascii?Q?JWGpzb+9l3b6zsPMAU30slGUWWZjtohf0eUEuvKwfSs5L9v5rvhsnNUAO5WF?=
 =?us-ascii?Q?yeAqcG21yB4nk5xEd4V2NFAxcBctiS22Xr1lHO00dBErMETpGqzfxfU9Jd6b?=
 =?us-ascii?Q?dlI07eW3pDnw7TXL9ApRyP9y+cdxCrqVUi5yJqbhZjlLDcJb12dfDmdgJUa2?=
 =?us-ascii?Q?E+p6zf4Pw5Jny07LkGuSfkG7mkkPLcJLgUZzxcQVjWpBe+HBFnJT3J7gNgEV?=
 =?us-ascii?Q?UaS49D78lFyIBB5TK7uEK7gTM/ErXmNf5dh6AdCPlk9PZeuty7xLr/vDd0UH?=
 =?us-ascii?Q?8RJuM1bWAvYNy96eJHthlX/EZV9vPbN/o1Jb1E7F21VH6+Q6QWQ+35/i9Lmt?=
 =?us-ascii?Q?W3bTaEBY0iYtYU5NzOKqVF62nz72vV2Wo/p/iGUYHGnDNnq0FEMowzCWyYkf?=
 =?us-ascii?Q?ZLUzJ/M2HkQDatHFEmHbTx/Vc54Pa5e9OY7gUCcaS42GwyXr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0032a06-8315-434b-3444-08dea78e07ba
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:19.3524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eVD2YNOMsorvaA5kK3p1dwPRiI3CVcGdJdbHkoQu49x6csEs65gJp6r2d3LML3i6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8096

TLBI is more complicated than all the other commands because the
invalidation loop builds a template command from the struct
arm_smmu_inv which is then expanded into many TLBI commands for the
invalidation.

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

