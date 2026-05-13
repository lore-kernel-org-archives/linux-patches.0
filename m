Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D913CE485;
	Wed, 13 May 2026 23:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716688; cv=fail; b=DKTYR2lqRru+k/rkrY3IdxHCKz0WNmgoo1MDUBpNh2sSyv2otiCMJqCqEP8nQpooDwDLhdQ/4I5+a0LPHlvWia737hZAHb75wF1HuLMJAJETqSLxn49sDNzzHqJ6ar/dpZGDOJkUrzbl9ES2iH+T94rKAMQui/9326+wMzQnTyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716688; c=relaxed/simple;
	bh=AxN+n0qcRnRl5T1x7lJlzZi9Ung0NInOcYG/8UubP8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gphVvpeDVEidjPNSjVVtSIhF1IO/2/5jVtaGl2ogrJmXIA9hWeDtOcPwXyIXwl81T/JCMzFVHmkF5lzVXyRcKS+nqgOp6gEAYIdm3hQRiAARqJ119MaaEmko5VUK//X0MOpxpbdSoaHB5YrbPmp5PoOFNU4DTF2+7cAWpDC2xmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E5M1GEvE; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E5M1GEvE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZHzIHhe3FG1ZLNhr1IrvrTCp75gmJJdYVvT3tiMuTbde6fU/XyeI8uznynsqwPPEcF46oBvSR9fz2T4cq0ipUer0FxKME/VJdQe5szLWDH9WunSoFzizFdcCcQ7WdmjuAFE2NvlHr5hYB7Zi7bz9GO1WnuHaiS4zsKfMdstfAW5+1Ij2m6tkkbYkZrWCU5pZeaKeTgATUW60dOD2aNvLIHJIxiIxhHU+TiwCLbPMZpyikgEDOiJkSfRUZhroDFZHZWwHE2WeU0jwvf1R6RqVojo5x0PUXY/tccZq4idKvmKkZtPTNwVUwnQ/RwDm4RznR2g+WFBucT12PG6SabfHHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTCbY0uyCxuTvnTd8IYOR/6WmvDlwXUTv0XC1ezYwKU=;
 b=wASwrbU0mVFfM8F1FbVEcgi09qFltqrKTg7eQQemy6JfIj0AmRQ1euRm6md8b2zIR0HCWjrfflUm4bdyzmF41HUX3bI2VHHsq1GEHIKS2YggEXT/kImBOJihHaA0Rd6+rehzNTGQxhGacCJHVsN4JRUVc95CFXW/ycnlv/beJ+nNx581wC4EcUPQg2FP2cKslOtDI6dvYOFHEIlOMFBw0itlqokuJJmXLhbLoOIxGJ6uqllPEUeLVevi3bjt7lUmdz8pQEkrXZIH3qwFS/bZP9bHniKNzKnBivqKDwhpeeE+5Qci+R5NGIXLzyIsGvIEKZPmsS1JI8TfICSlW7h2hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTCbY0uyCxuTvnTd8IYOR/6WmvDlwXUTv0XC1ezYwKU=;
 b=E5M1GEvER9JHdWfbUlqUL5WeQYS/m1bj3loEZt8MDgAZMOEwLi6Rc5BDBnAxndlrYtCoWqiRaWVDNMXx4DZHRnvqwFOujal7lKgg43Z0MtIsItivsxIlzbM1f3lZuZ73CRb3xZl5SRt7lyZMz4ttKhpQ0zlgl9/rMQIL4VGBHA+uuehtfqdJywgOhRFdonZoMvgwyOs47Zs+s86MWDGdnU8dWihFqRjrqgKVP6lKEPJJcDRurtvqslUfpmR1cxoIxd5R8EtIIAEFHsvrrCZJN9UjBs5DdZikjfAiS2AEuNM0BelwgCAtF0WX7PgrBHW21LzPV019vffHTqUclv+AZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 23:57:53 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:57:53 +0000
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
Subject: [PATCH v2 6/9] iommu/arm-smmu-v3: Directly encode simple commands
Date: Wed, 13 May 2026 20:57:45 -0300
Message-ID: <6-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0113.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aed9fc4-582b-4dc2-8c5d-08deb14b70ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799003|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	c9YHX8jN6byuD6Ua6KQCVA+Q+dgBrTcohtcsNcuZy7rIkP9p0/hKLj0J4yDt2kMGLDNL7um2UtICNFO7K0yNgDN5IMfLFGFxJDRllHeIDd0UsoR4S84oz4hs3gmezozsNHLJ0v4Fp9C2LPeucNSgvgWBrlod+AF+qGHYb8SShpcig10x3UaLkyKvIoSDoRMOebXAbIYMA/+J6oVRtoSoEMAvjXtJinNBcCgOZUglGGPRJYuu/UpZriiGgeu+0NUkgerYM9vh/FC9lj5lOuH7mvYleM2hW9dDkSNnDap/yTYUDf6Glp/q1UbJ0M+e40uqssNIyRvGB7vnDmrg8smIN77BL5ag/9aY35LvBYxgtDUg/RcJ3y589GsXQLdHVYLsgktarAikByDLjTHF5TV4LHICxrUxYUdcnrZdG5Y5s04dVOU5OBwtZAY2JpmgWLIbcBiIcjxd4LqHFC4e7rfgN4XUXusK7SU3TIGvVuSxe2EkcpjvIAE6l4mImf5IBsUL/nf13X8/G3bM7pZOmf3C1MQtN9pqKGs5IA6XbsU57/AA8GiltfcLI52Y90bvbR5aRak7ewf+A4KGMmynCjChiGEyEAF0UaH4bAmR1catg9Qc/2uN47i5mEw0vF4ht73PYwwU1qupf6HwWTDc9u9ob5RnGXOwD39xflXzwX0oyGf/jItyykF5DikALKBDvwDK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799003)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hkR7aRDn8tvLEsXUUGr0LqvUED5mi9xOBjUYVAD+c87u6HEZy1sZZ+mVDDui?=
 =?us-ascii?Q?SoWA3daiKGRAHUDy7a7CNUPt7gEYUuWFxuwumg3Wwr6GqLwq9nSV9csuRJNK?=
 =?us-ascii?Q?jJCZYgnOw9+Cb8OIJWe6wCawpenH4eRV+dC3HY5koDb5RnS+kOnp1mRGBFKJ?=
 =?us-ascii?Q?FilshSkzoF9Wp7GpT+NstbBnFHnQytkxFidiCPhookKoNbKTPZqQI2rTNxok?=
 =?us-ascii?Q?1dLPnxekAJm7YwMCDKow0E3UIxv8Soh1dL1R/lZzhZFUKyR2hR8+xeLNmWo2?=
 =?us-ascii?Q?psV0ns+DPj0RAZ1anmUc3PDSvs4csUM6L1LJL95VrG+8zD6j+aqe//MtcQ2d?=
 =?us-ascii?Q?FVOaCaqyb7Cb9BidpJ1gPoGP1oSiEwI6j8ENqRxwfFwkBpAoEv3SXo6Z1GPh?=
 =?us-ascii?Q?YPNeGXJasRJjyazv4agNopMPmRVhIMmFMNSX7PXs6QNBz+lxdt5cQ7ibMlFy?=
 =?us-ascii?Q?u+lZa1+JDRXdKHkB4EpU3sZYGBjwvzBlIYYIUwA5xII09G7Q0ThWHkMke5v5?=
 =?us-ascii?Q?EoHI8VLBcbrqFGrIY7z3cDHypBitfYmZn9Lc/Zg2h8+BOgUVybQn6UyceJG4?=
 =?us-ascii?Q?ABQW/dkkBdcFAWP97RFjyLPamJkK2uAkwAGOFxQs0o51NUK9w1TfwUOh3DaQ?=
 =?us-ascii?Q?STKw1eB+YhozKcTVZGFHBqZxTrOmnft5r4l3dUwH6FiH2hzrmTUygUqk3P/6?=
 =?us-ascii?Q?aE9kPXHKHADDxfrQwK4t4q6Annf7TJJk38JBDPz+jwQsROVQhL+XtZNOJpS2?=
 =?us-ascii?Q?jJYr1cbT/Qh9INzmosJAKEU1iFJllFrOzpTOX9CDm9XgTrm/8QvZn9LrspGs?=
 =?us-ascii?Q?walEGfpf3y8pDaE7aiVbKgf1Xhe5FJekpvPaBVtlSBJXqijvOR4vXfQZuwbM?=
 =?us-ascii?Q?Wi+Gcj3KKTdvlAzhj6MzHgMJZyLcauel5Xlc25Cm/QDRil2I2P1Y1TAg1h8Z?=
 =?us-ascii?Q?jAmCAhgWK/RTAkQAY5pEjCjrltn9PM36gL2vIRWqtkH8M4UfFuauo1PDb9E+?=
 =?us-ascii?Q?Lm5gZGbJ6wMWEkUfGYtaMePFEG1zHhD9IZRo/g/YRuTY11HDHFhu38mv+6zD?=
 =?us-ascii?Q?Mzs5Mux02ClNbYQy9EeNz47uv91bfVYYwpSupypF1P0+VZF2iOi00xpR/vIt?=
 =?us-ascii?Q?eA3p4GQraMyh1EPBpGOrF89aQ3KZypjvF0F2/uEZJXGa3Gl/NTH1PD0CvGrw?=
 =?us-ascii?Q?Gn+0tYu4OGtkHhydfwhdCJZjv51kYYXX4/qg1Zv34z6cPpXkGRg8IxPfZ1Lg?=
 =?us-ascii?Q?Z9E7lroQJJ8GC5xssVQ5li382k3bD5zzIFY06Zguq17sytfMRk1Wg54yJmQR?=
 =?us-ascii?Q?Af/VW8BS3BCO00iZKixkhzfoWpmGJK0bJ1jvrQLpbZR3EX7kMXh0xuhhI+HX?=
 =?us-ascii?Q?fMrZX0KxT5o+B5RCnPm/pfdHOMFktmoiw2ffTGkTFvQyrMkezKEP8GoXk28b?=
 =?us-ascii?Q?sp3zBwqMwQRgDbJSrJ6Y2xK6uSBsAZTbV3E95/Zu5P1aOFxIMF5DwNTOAisR?=
 =?us-ascii?Q?KhuM4JuXhrCnIHz8Jor2z+bxI1xHjNyzf+WSeG3lA7st6KIlGyUihk5pdRrX?=
 =?us-ascii?Q?TgSfwqbhn8cdwCiRzTSYVndQoq2TS51rpyucELPhD1JzWxUahivzITV5IvjK?=
 =?us-ascii?Q?szIHSZWrUODZuYM1Fxy9WboX9iamYsRVZAlzyJer6GOeARprgDwBN9Zy+CPH?=
 =?us-ascii?Q?KKf+zqdL/v6e7nP85ihHEYIBoixXXdpT7iM1cFiEeLJ8QK9L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aed9fc4-582b-4dc2-8c5d-08deb14b70ae
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:57:51.0251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGuGwl7bBUitMcposFuvYFnplCJP3mTWu+6KqENSBdUV04KQ2a7ClDHAt+NMqYWK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

Add make functions to build commands for

 CMDQ_OP_TLBI_EL2_ALL
 CMDQ_OP_TLBI_NSNH_ALL
 CMDQ_OP_CFGI_ALL
 CMDQ_OP_PREFETCH_CFG
 CMDQ_OP_CFGI_STE
 CMDQ_OP_CFGI_CD
 CMDQ_OP_RESUME
 CMDQ_OP_PRI_RESP

Convert all of these call sites to use the make function instead of
going through arm_smmu_cmdq_build_cmd(). Use a #define so the general
pattern is always:

   arm_smmu_cmdq_issue_cmd(smmu, arm_smmu_make_cmd_XX(..));

Add arm_smmu_cmdq_batch_add_cmd() which takes struct arm_smmu_cmd
directly to match the new flow.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 213 +++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 109 +++++++---
 2 files changed, 151 insertions(+), 171 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ef0907b1a2204f..f9c25ca9a9e7b8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -277,23 +277,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
 	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
 
 	switch (ent->opcode) {
-	case CMDQ_OP_TLBI_EL2_ALL:
-	case CMDQ_OP_TLBI_NSNH_ALL:
-		break;
-	case CMDQ_OP_PREFETCH_CFG:
-		cmd[0] |= FIELD_PREP(CMDQ_PREFETCH_0_SID, ent->prefetch.sid);
-		break;
-	case CMDQ_OP_CFGI_CD:
-		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SSID, ent->cfgi.ssid);
-		fallthrough;
-	case CMDQ_OP_CFGI_STE:
-		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
-		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
-		break;
-	case CMDQ_OP_CFGI_ALL:
-		/* Cover the entire SID range */
-		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
-		break;
 	case CMDQ_OP_TLBI_NH_VA:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
 		fallthrough;
@@ -333,26 +316,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
 		cmd[1] |= FIELD_PREP(CMDQ_ATC_1_SIZE, ent->atc.size);
 		cmd[1] |= ent->atc.addr & CMDQ_ATC_1_ADDR_MASK;
 		break;
-	case CMDQ_OP_PRI_RESP:
-		cmd[0] |= FIELD_PREP(CMDQ_0_SSV, ent->substream_valid);
-		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SSID, ent->pri.ssid);
-		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SID, ent->pri.sid);
-		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_GRPID, ent->pri.grpid);
-		switch (ent->pri.resp) {
-		case PRI_RESP_DENY:
-		case PRI_RESP_FAIL:
-		case PRI_RESP_SUCC:
-			break;
-		default:
-			return -EINVAL;
-		}
-		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_RESP, ent->pri.resp);
-		break;
-	case CMDQ_OP_RESUME:
-		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_SID, ent->resume.sid);
-		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_RESP, ent->resume.resp);
-		cmd[1] |= FIELD_PREP(CMDQ_RESUME_1_STAG, ent->resume.stag);
-		break;
 	case CMDQ_OP_CMD_SYNC:
 		if (ent->sync.msiaddr) {
 			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_IRQ);
@@ -924,25 +887,24 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 	return ret;
 }
 
-static int __arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
-				     struct arm_smmu_cmd *cmd,
-				     bool sync)
+static int arm_smmu_cmdq_issue_cmd_p(struct arm_smmu_device *smmu,
+				     struct arm_smmu_cmd *cmd, bool sync)
 {
 	return arm_smmu_cmdq_issue_cmdlist(
 		smmu, arm_smmu_get_cmdq(smmu, cmd), cmd, 1, sync);
 }
 
-static int arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
-				   struct arm_smmu_cmd *cmd)
-{
-	return __arm_smmu_cmdq_issue_cmd(smmu, cmd, false);
-}
+#define arm_smmu_cmdq_issue_cmd(smmu, cmd)                      \
+	({                                                      \
+		struct arm_smmu_cmd __cmd = cmd;                \
+		arm_smmu_cmdq_issue_cmd_p(smmu, &__cmd, false); \
+	})
 
-static int arm_smmu_cmdq_issue_cmd_with_sync(struct arm_smmu_device *smmu,
-					     struct arm_smmu_cmd *cmd)
-{
-	return __arm_smmu_cmdq_issue_cmd(smmu, cmd, true);
-}
+#define arm_smmu_cmdq_issue_cmd_with_sync(smmu, cmd)           \
+	({                                                     \
+		struct arm_smmu_cmd __cmd = cmd;               \
+		arm_smmu_cmdq_issue_cmd_p(smmu, &__cmd, true); \
+	})
 
 static void arm_smmu_cmdq_batch_init_cmd(struct arm_smmu_device *smmu,
 					 struct arm_smmu_cmdq_batch *cmds,
@@ -962,14 +924,41 @@ static void arm_smmu_cmdq_batch_init(struct arm_smmu_device *smmu,
 	arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 }
 
+static void arm_smmu_cmdq_batch_add_cmd_p(struct arm_smmu_device *smmu,
+					  struct arm_smmu_cmdq_batch *cmds,
+					  struct arm_smmu_cmd *cmd)
+{
+	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
+			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
+	bool unsupported_cmd;
+
+	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, cmd);
+	if (force_sync || unsupported_cmd) {
+		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
+					    cmds->num, true);
+		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, cmd);
+	}
+
+	if (cmds->num == CMDQ_BATCH_ENTRIES) {
+		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
+					    cmds->num, false);
+		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, cmd);
+	}
+
+	cmds->cmds[cmds->num++] = *cmd;
+}
+
+#define arm_smmu_cmdq_batch_add_cmd(smmu, cmds, cmd)               \
+	({                                                         \
+		struct arm_smmu_cmd __cmd = cmd;                   \
+		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &__cmd); \
+	})
+
 static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
 				    struct arm_smmu_cmdq_batch *cmds,
 				    struct arm_smmu_cmdq_ent *ent)
 {
-	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
-			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
 	struct arm_smmu_cmd cmd;
-	bool unsupported_cmd;
 
 	if (unlikely(arm_smmu_cmdq_build_cmd(&cmd, ent))) {
 		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
@@ -977,20 +966,7 @@ static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
 		return;
 	}
 
-	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, &cmd);
-	if (force_sync || unsupported_cmd) {
-		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
-					    cmds->num, true);
-		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
-	}
-
-	if (cmds->num == CMDQ_BATCH_ENTRIES) {
-		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
-					    cmds->num, false);
-		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
-	}
-
-	cmds->cmds[cmds->num++] = cmd;
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
 }
 
 static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
@@ -1003,32 +979,29 @@ static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
 static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused,
 				   struct iommu_page_response *resp)
 {
-	struct arm_smmu_cmdq_ent cmd = {0};
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	int sid = master->streams[0].id;
-	struct arm_smmu_cmd hw_cmd;
+	u8 resume_resp;
 
 	if (WARN_ON(!master->stall_enabled))
 		return;
 
-	cmd.opcode		= CMDQ_OP_RESUME;
-	cmd.resume.sid		= sid;
-	cmd.resume.stag		= resp->grpid;
 	switch (resp->code) {
 	case IOMMU_PAGE_RESP_INVALID:
 	case IOMMU_PAGE_RESP_FAILURE:
-		cmd.resume.resp = CMDQ_RESUME_0_RESP_ABORT;
+		resume_resp = CMDQ_RESUME_0_RESP_ABORT;
 		break;
 	case IOMMU_PAGE_RESP_SUCCESS:
-		cmd.resume.resp = CMDQ_RESUME_0_RESP_RETRY;
+		resume_resp = CMDQ_RESUME_0_RESP_RETRY;
 		break;
 	default:
+		resume_resp = CMDQ_RESUME_0_RESP_TERM;
 		break;
 	}
 
-	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
-	arm_smmu_cmdq_issue_cmd(master->smmu, &hw_cmd);
-
+	arm_smmu_cmdq_issue_cmd(master->smmu,
+				arm_smmu_make_cmd_resume(master->streams[0].id,
+							 resp->grpid,
+							 resume_resp));
 	/*
 	 * Don't send a SYNC, it doesn't do anything for RESUME or PRI_RESP.
 	 * RESUME consumption guarantees that the stalled transaction will be
@@ -1552,19 +1525,14 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 	size_t i;
 	struct arm_smmu_cmdq_batch cmds;
 	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_cmdq_ent cmd = {
-		.opcode	= CMDQ_OP_CFGI_CD,
-		.cfgi	= {
-			.ssid	= ssid,
-			.leaf	= leaf,
-		},
-	};
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_cfgi_cd(0, ssid, leaf);
 
-	arm_smmu_cmdq_batch_init(smmu, &cmds, &cmd);
-	for (i = 0; i < master->num_streams; i++) {
-		cmd.cfgi.sid = master->streams[i].id;
-		arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
-	}
+	arm_smmu_cmdq_batch_init_cmd(smmu, &cmds, &cmd);
+	for (i = 0; i < master->num_streams; i++)
+		arm_smmu_cmdq_batch_add_cmd(
+			smmu, &cmds,
+			arm_smmu_make_cmd_cfgi_cd(master->streams[i].id, ssid,
+						  leaf));
 
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
@@ -1857,17 +1825,10 @@ static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
 {
 	struct arm_smmu_ste_writer *ste_writer =
 		container_of(writer, struct arm_smmu_ste_writer, writer);
-	struct arm_smmu_cmdq_ent ent = {
-		.opcode	= CMDQ_OP_CFGI_STE,
-		.cfgi	= {
-			.sid	= ste_writer->sid,
-			.leaf	= true,
-		},
-	};
-	struct arm_smmu_cmd cmd;
 
-	arm_smmu_cmdq_build_cmd(&cmd, &ent);
-	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(
+		writer->master->smmu,
+		arm_smmu_make_cmd_cfgi_ste(ste_writer->sid, true));
 }
 
 static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
@@ -1892,17 +1853,9 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	arm_smmu_write_entry(&ste_writer.writer, ste->data, target->data);
 
 	/* It's likely that we'll want to use the new STE soon */
-	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
-		struct arm_smmu_cmdq_ent
-			prefetch_ent = { .opcode = CMDQ_OP_PREFETCH_CFG,
-					 .prefetch = {
-						 .sid = sid,
-					 } };
-		struct arm_smmu_cmd prefetch_cmd;
-
-		arm_smmu_cmdq_build_cmd(&prefetch_cmd, &prefetch_ent);
-		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
-	}
+	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH))
+		arm_smmu_cmdq_issue_cmd(smmu,
+					arm_smmu_make_cmd_prefetch_cfg(sid));
 }
 
 void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
@@ -2327,22 +2280,10 @@ static void arm_smmu_handle_ppr(struct arm_smmu_device *smmu, u64 *evt)
 		 evt[0] & PRIQ_0_PERM_EXEC ? "X" : "",
 		 evt[1] & PRIQ_1_ADDR_MASK);
 
-	if (last) {
-		struct arm_smmu_cmdq_ent ent = {
-			.opcode			= CMDQ_OP_PRI_RESP,
-			.substream_valid	= ssv,
-			.pri			= {
-				.sid	= sid,
-				.ssid	= ssid,
-				.grpid	= grpid,
-				.resp	= PRI_RESP_DENY,
-			},
-		};
-		struct arm_smmu_cmd cmd;
-
-		arm_smmu_cmdq_build_cmd(&cmd, &ent);
-		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
-	}
+	if (last)
+		arm_smmu_cmdq_issue_cmd(
+			smmu, arm_smmu_make_cmd_pri_resp(sid, ssid, ssv, grpid,
+							 PRI_RESP_DENY));
 }
 
 static irqreturn_t arm_smmu_priq_thread(int irq, void *dev)
@@ -3464,7 +3405,7 @@ static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
 
 	cmd.opcode = inv->nsize_opcode;
 	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
-	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &hw_cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, hw_cmd);
 }
 
 /* Should be installed after arm_smmu_install_ste_for_dev() */
@@ -4827,8 +4768,6 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 {
 	int ret;
 	u32 reg, enables;
-	struct arm_smmu_cmdq_ent ent;
-	struct arm_smmu_cmd cmd;
 
 	/* Clear CR0 and sync (disables SMMU and queue processing) */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_CR0);
@@ -4875,20 +4814,16 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 	}
 
 	/* Invalidate any cached configuration */
-	ent.opcode = CMDQ_OP_CFGI_ALL;
-	arm_smmu_cmdq_build_cmd(&cmd, &ent);
-	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(smmu, arm_smmu_make_cmd_cfgi_all());
 
 	/* Invalidate any stale TLB entries */
 	if (smmu->features & ARM_SMMU_FEAT_HYP) {
-		ent.opcode = CMDQ_OP_TLBI_EL2_ALL;
-		arm_smmu_cmdq_build_cmd(&cmd, &ent);
-		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+		arm_smmu_cmdq_issue_cmd_with_sync(
+			smmu, arm_smmu_make_cmd_op(CMDQ_OP_TLBI_EL2_ALL));
 	}
 
-	ent.opcode = CMDQ_OP_TLBI_NSNH_ALL;
-	arm_smmu_cmdq_build_cmd(&cmd, &ent);
-	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(
+		smmu, arm_smmu_make_cmd_op(CMDQ_OP_TLBI_NSNH_ALL));
 
 	/* Event queue */
 	writeq_relaxed(smmu->evtq.q.q_base, smmu->base + ARM_SMMU_EVTQ_BASE);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1fe6917448b774..10b3d95d9ee660 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -437,6 +437,12 @@ struct arm_smmu_cmd {
 #define CMDQ_PRI_1_GRPID		GENMASK_ULL(8, 0)
 #define CMDQ_PRI_1_RESP			GENMASK_ULL(13, 12)
 
+enum pri_resp {
+	PRI_RESP_DENY = 0,
+	PRI_RESP_FAIL = 1,
+	PRI_RESP_SUCC = 2,
+};
+
 #define CMDQ_RESUME_0_RESP_TERM		0UL
 #define CMDQ_RESUME_0_RESP_RETRY	1UL
 #define CMDQ_RESUME_0_RESP_ABORT	2UL
@@ -475,6 +481,77 @@ enum arm_smmu_cmdq_opcode {
 	CMDQ_OP_CMD_SYNC = 0x46,
 };
 
+static inline struct arm_smmu_cmd
+arm_smmu_make_cmd_op(enum arm_smmu_cmdq_opcode op)
+{
+	struct arm_smmu_cmd cmd = {};
+
+	cmd.data[0] = FIELD_PREP(CMDQ_0_OP, op);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_all(void)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_ALL);
+
+	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_prefetch_cfg(u32 sid)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_PREFETCH_CFG);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_PREFETCH_0_SID, sid);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_ste(u32 sid, bool leaf)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_STE);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, sid);
+	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, leaf);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_cd(u32 sid, u32 ssid,
+							    bool leaf)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_CD);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, sid) |
+		       FIELD_PREP(CMDQ_CFGI_0_SSID, ssid);
+	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, leaf);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_resume(u32 sid, u16 stag,
+							   u8 resp)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_RESUME);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_RESUME_0_SID, sid) |
+		       FIELD_PREP(CMDQ_RESUME_0_RESP, resp);
+	cmd.data[1] |= FIELD_PREP(CMDQ_RESUME_1_STAG, stag);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_pri_resp(u32 sid, u32 ssid,
+							     bool ssv,
+							     u16 grpid,
+							     enum pri_resp resp)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_PRI_RESP);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_0_SSV, ssv) |
+		       FIELD_PREP(CMDQ_PRI_0_SID, sid) |
+		       FIELD_PREP(CMDQ_PRI_0_SSID, ssid);
+	cmd.data[1] |= FIELD_PREP(CMDQ_PRI_1_GRPID, grpid) |
+		       FIELD_PREP(CMDQ_PRI_1_RESP, resp);
+	return cmd;
+}
+
 /* Event queue */
 #define EVTQ_ENT_SZ_SHIFT		5
 #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
@@ -535,12 +612,6 @@ enum arm_smmu_cmdq_opcode {
 #define MSI_IOVA_BASE			0x8000000
 #define MSI_IOVA_LENGTH			0x100000
 
-enum pri_resp {
-	PRI_RESP_DENY = 0,
-	PRI_RESP_FAIL = 1,
-	PRI_RESP_SUCC = 2,
-};
-
 struct arm_smmu_cmdq_ent {
 	/* Common fields */
 	u8				opcode;
@@ -548,19 +619,6 @@ struct arm_smmu_cmdq_ent {
 
 	/* Command-specific fields */
 	union {
-		struct {
-			u32			sid;
-		} prefetch;
-
-		struct {
-			u32			sid;
-			u32			ssid;
-			union {
-				bool		leaf;
-				u8		span;
-			};
-		} cfgi;
-
 		struct {
 			u8			num;
 			u8			scale;
@@ -580,19 +638,6 @@ struct arm_smmu_cmdq_ent {
 			bool			global;
 		} atc;
 
-		struct {
-			u32			sid;
-			u32			ssid;
-			u16			grpid;
-			enum pri_resp		resp;
-		} pri;
-
-		struct {
-			u32			sid;
-			u16			stag;
-			u8			resp;
-		} resume;
-
 		struct {
 			u64			msiaddr;
 		} sync;
-- 
2.43.0

