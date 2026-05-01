Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3FC3B19B2;
	Fri,  1 May 2026 14:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645773; cv=fail; b=POK4U/lBEu4k/b8bL9VCR5kuCYXGNlT+q8VX/6u3n69xlAY/5Suf0vFQPOYmUXvEr06nukov+77VaVqKvgqGYVOHkxksy9wFU+dLewzPX9ll9ZRRYe/ll94BYIljVxwX6W7bOf/OmZeVjlAwRhoTF4ZIi6+jUGWEhxf0to5nmOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645773; c=relaxed/simple;
	bh=a3MFnZERz50aNDAJNxADtiuJTLV3Ezeihqc5g2aiZdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gfKs7cWQaMTdqS0iylZsNRQRrjoUDm/rdLyyW2+HeSPB8c+dlMXftwOlfMbp+1KhquMHxCbMMGk/ywpFPjSEdWuI0vAyZf1U3xPChn9sQCD9YESuK2Qj5C0bZp4v/Mpz50nXBQn3OrIJDOPnzvQOKADBxLpL1X8nAwTDO4Vbjec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=krkv6MJu; arc=fail smtp.client-ip=40.107.208.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="krkv6MJu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VwJ3su4uhhjh4MpZrMmMJNwZtA5uLKTjQ/YMY0tlC5EzuZMhb1Cl8ey5xPwyWfhlSn0EPMIvns6NZ3G6wh9nuX5zbMAO44dIplypfK8bhnkUwKB3UJMkY78vTBIxtjjd4V4YJDDajCjrH3WrHEbpLwWTdgdI0lvhQm+WyL1jOXU2qq4C7S0yVMvUY9ycP7GylFCXRqhOxGyvQivgB5l64HcIDS5A9moqzsZS2spF3EMHA5x0JkphpAcTuuQS80h0JfunFcg7xlmkRJuWRFojHLYmranh6WiUZXgfLleU2OZybXsBfCh6JRytrUYqHM9uIw/9M+QztsbnZ+jDhF0ZgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+HGYcVtKWbihSScQRlIt+2G8LLyZesKUPL2TthPmqY=;
 b=JSk66rM07S27F1cO2T0vI7VoxV48HaWxg77OG++XLyioZI2OP7+2rZgZhzOL8QRLX4RkQjU9dTurHsVZ60+oCPAWCFpMwmXJi0HMQiBIWPm76CwcefLvxrGIpnklXkzBfnpxp5H4HtE1XSDFExxnVObifFyAX8IEU/tsCvYlnwnQo+HSsJdYA3LfyGsfbLRVXdrw7tinC/WTT3t+/gu7rLEAfdIZSwcyQhLTP3tdkT2+6vhgXqUGxCGeXu35JeDX87Raqw68YuX2utjpU0J5IBkXYiBk2fx0bh3ZZhRCWP493lBxvSRA7y7XxQKQDbETegLwOPpyRx8joEzn5GidRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+HGYcVtKWbihSScQRlIt+2G8LLyZesKUPL2TthPmqY=;
 b=krkv6MJuHNiK/eCR3t8AyzUgeyL8SyYi3o74jpZUOMUNjOsbOzCp3aZDSAS0GB1Dxes4ZIEOkEpHQoPb+bMo9nsjm4gcB3VL0UjR7eAQ0qOINIrXP5x4g7Phc6aopyQvewEuJ7lEvc0FbgVKPaurZs63mkj2MA6AJRgWI0jkQCdmIB/d71Ju2YhdjrewUf1PxvYX7a98qTCBP5mtAjbqKj1g+jwXoAo9P0lXH5yrgjGEm0c5v6kuKMe1wdjS15TJw7WepVfgmm44rfwO/p5LCdyXZS21JMGdjkGbvxkccjjZF6D+Mblyer631V12iiitlpNlFFBnpJDDS0H7UWSz6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV3PR12MB9216.namprd12.prod.outlook.com (2603:10b6:408:1a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.21; Fri, 1 May
 2026 14:29:24 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 14:29:24 +0000
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
Subject: [PATCH 4/9] iommu/arm-smmu-v3: Convert arm_smmu_cmdq_batch cmds to struct arm_smmu_cmd
Date: Fri,  1 May 2026 11:29:13 -0300
Message-ID: <4-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0042.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV3PR12MB9216:EE_
X-MS-Office365-Filtering-Correlation-Id: 914e0347-2dcd-4d78-a739-08dea78e0938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	LkUsbw9l+DjLAlYVScXG5//p1VgRU5yc4OzJD6JgKqfdmkOwWi3WRxDJUW0h5QSKXgCxqSDzU/VgZmziSNRCCUkW/bYW0g/dgcKVwg6oSVuTn/ML4VWGK4VtFL6eiLcavae4qngkQQHiQ874fdPGnLkCIRCBjR90gZ3HVPe4N11ZTnWoBGL71H7bM/JuoqsipkiPBbiSfpYyLaw9G57nmGHl4Tx7z5mZZ2wneHBiXn7JDLRVB+cCECsRqaFwW1C030z901RTZeMJ+GDvIsCq45WfqOQANSc2Otz0g6Epcbtzn4ILJj6DQlfhL5qUTuw5PfAjZqF3Of5UQUdVSxFuTBMOOD8cYRgX0jFtqCv2DC1lnTvi78d1UcfAhyG2T5ZHqzisFtZtju6/d1elkWU7qPrynVMmhElxaqJw/D3WY42C9Z9Cn6wu1B7tv77ZhJ9fHu1Oyznu4y103HdlPHjbvsjSTrxePsV5sMC/3ids4DpnEgN3gKj1K+HnfjSBwQcd/BNyo5WkIBJAkTCf0+PPPIiMwtRMM8dLedz/CuBa6BXGns78JaVq/K4eLRkGh4vIoUPEkvG9olgecSAW5Y5Ml3+xG2IprcLhUk1H3H2aAL9oFyJdDpK1KP+cm7RmFAH1HLx2xoOKdan7ip8WEPzu/wi9OX0QWJ5n1HyVH/5nobxh/lpgy/3YmM/sDn3M85Xx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D589EeCkH6S08/uEqEldBV6gdEiMeM7AeNzNaRNkJ2fk0yfFIUrl6PJjhDt/?=
 =?us-ascii?Q?Dv7ZrVsKCHyBdlGtmhxappj7Ym+KWdZOUcFuSvdr5ypCps1d/T4xDqehT5M4?=
 =?us-ascii?Q?qbYhWIac/BY+lyM0h8oZfIXK5DJSZXrpcgaeaoCl8xsSsBrTX18+3sEs/AjA?=
 =?us-ascii?Q?bKYBNIRI1UqXV9+MNiWSXAXkXK2vnvSVzDWxsg0q0/cNduTrL6zE2WiqNu4F?=
 =?us-ascii?Q?lnXjufwZprSXKqxSz83UCl2quwYtO56b4ZPdnDyONeXaGhlIbsoMGZkldIxa?=
 =?us-ascii?Q?P2PFyVmI/lhaYMc75DPPBtnuCUhW8Pd6OMRV8pdt5zLtVLNga9QC9SvereMv?=
 =?us-ascii?Q?6d+fozeuqkKp9wAq2PShsc0JWPMvPFlio9G7lol8+3FoFByPjSa3iRZ7o7cD?=
 =?us-ascii?Q?lEGC/RrAHfr0y1C5D8+HlMwkB5WqDtXcwD+nj3h3UBq2T97WubkVd2HxZfC4?=
 =?us-ascii?Q?TrRl/DbKcbHg9ZQlJZI7zLlWqSwgBI2uvX4M2gnS6y17LT71XrSUPo1rgEXV?=
 =?us-ascii?Q?uX93Luuk59TygeCpTwdGJCuyzAF5eOq4BljsfifUYvje+bOonMbjDF7U1j45?=
 =?us-ascii?Q?A6XubJgUKDv1zOKQ/jdS2NOBygrpO00lv1eQp/75s0qz9A+Mw3PsbYXGrANo?=
 =?us-ascii?Q?0oHYOdx8LrLii9B+HkDNkSw7+PRXMDsRoFrjqSqVH4FbQ4Iueay1G/0zNe6b?=
 =?us-ascii?Q?9OmKN0z2hXPj5NNYqCbwJJsxozuPfVGyBalQtMipU//z9GQCpTy28yty9AFC?=
 =?us-ascii?Q?tcks8XZAPypqqG35snzvsZsKTUTRfwSBekfU1ekag4M6a8gG+d7bYLR0S04x?=
 =?us-ascii?Q?SisMSmqsxl82p94iKEH3FYzHdld0ZNLzLwNBXhTv33shg/q+K/TBHTHdH3lO?=
 =?us-ascii?Q?P/g4HhFiuIXBVV/O29nzIV/ko7pa+j/4JhZGm3i+Zt4fRdVsfNG6qj58C3Qw?=
 =?us-ascii?Q?aiHctwQDH54dU3qUhLkN+NaQWLe90nR9iWuswDan4MQy6n4gfnOsMdg8f3SX?=
 =?us-ascii?Q?PUCV971H6r7ab5PZOuV6behmuU+AIuWzo7G0v8w2DkpvJSA7Ec3PHfHvKxbU?=
 =?us-ascii?Q?+ktonbnHYEXt2UgtX83Lm6x6UT2FXKFKx8sMGaLNdOK3OT3J5MG146g5bxPO?=
 =?us-ascii?Q?e7pgejAsxUmDHmDIUmNhOjJibbIqviDApNHYOh75T/ceRwVt1uI+LLC/Ihza?=
 =?us-ascii?Q?UccigAoaGnX/jugwq8/amfmsWq9U494m8naephjFtHFDi1Zp3PAMvsEpWy0y?=
 =?us-ascii?Q?dW8txEeIDh2Avo05yUwcOD8u0PhEY64vaPwDYEtjc37OwnTWW9IiwCSNlUSi?=
 =?us-ascii?Q?wXprZ79VeEqOMJvXO8ZhtG6ougSHhSdTLoHvFuglTv/jyU2Rm9/1R9SdqxHI?=
 =?us-ascii?Q?3OK+Qp4ap1f3DG/WmyTpoyuJKkaP0wiYcENnhwkfc1Q5dorvq5aWojvY2ZUB?=
 =?us-ascii?Q?LZGirYISDWPDH17tYrwtu+0yq4muaBDtJYZ65PnrMPlfaG61pPpn1f7Gd3x7?=
 =?us-ascii?Q?1aPD7pSFs9aZPsb3f5gdvZhaC+ClqsAHGoMPVbGH4/kANGou3wrbGDfNNM0U?=
 =?us-ascii?Q?8nSBqOeGLxjDB6n3Kved8uQMrsYA3HULDh/MJtCh2SYEr9MmYBXDsPzsZd7t?=
 =?us-ascii?Q?MYqiGlrUhse4yXKUoynGn2o7ydA+ZP0OT18eewNtv1nIsDK0jiSENm+EcPCJ?=
 =?us-ascii?Q?itKaxLSOYRY/9TXU2G123gheEzyLLozCJYTugWTZGDMH8La8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 914e0347-2dcd-4d78-a739-08dea78e0938
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:22.4244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pmlxebjwlpApYCsLo4v7VwTSzSuYwZcyZzAobo1dfNsoeMq7Uz1Lq4Co9u7LM5Sr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9216

Convert the batch's type to also get the remaining helper functions to
use the new type and complete replacing naked u64s with the new struct.

The low-level queue_write()/queue_read()/queue_remove_raw() functions
remain u64-based since they are shared by event and PRI queues which
have different entry sizes.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 24 +++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 74 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +-
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  8 +-
 4 files changed, 58 insertions(+), 53 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index ddae0b07c76b50..1e9f7d2de34414 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -300,7 +300,7 @@ static int arm_vsmmu_vsid_to_sid(struct arm_vsmmu *vsmmu, u32 vsid, u32 *sid)
 /* This is basically iommu_viommu_arm_smmuv3_invalidate in u64 for conversion */
 struct arm_vsmmu_invalidation_cmd {
 	union {
-		u64 cmd[2];
+		struct arm_smmu_cmd cmd;
 		struct iommu_viommu_arm_smmuv3_invalidate ucmd;
 	};
 };
@@ -316,32 +316,32 @@ static int arm_vsmmu_convert_user_cmd(struct arm_vsmmu *vsmmu,
 				      struct arm_vsmmu_invalidation_cmd *cmd)
 {
 	/* Commands are le64 stored in u64 */
-	cmd->cmd[0] = le64_to_cpu(cmd->ucmd.cmd[0]);
-	cmd->cmd[1] = le64_to_cpu(cmd->ucmd.cmd[1]);
+	cmd->cmd.data[0] = le64_to_cpu(cmd->ucmd.cmd[0]);
+	cmd->cmd.data[1] = le64_to_cpu(cmd->ucmd.cmd[1]);
 
-	switch (cmd->cmd[0] & CMDQ_0_OP) {
+	switch (cmd->cmd.data[0] & CMDQ_0_OP) {
 	case CMDQ_OP_TLBI_NSNH_ALL:
 		/* Convert to NH_ALL */
-		cmd->cmd[0] = CMDQ_OP_TLBI_NH_ALL |
+		cmd->cmd.data[0] = CMDQ_OP_TLBI_NH_ALL |
 			      FIELD_PREP(CMDQ_TLBI_0_VMID, vsmmu->vmid);
-		cmd->cmd[1] = 0;
+		cmd->cmd.data[1] = 0;
 		break;
 	case CMDQ_OP_TLBI_NH_VA:
 	case CMDQ_OP_TLBI_NH_VAA:
 	case CMDQ_OP_TLBI_NH_ALL:
 	case CMDQ_OP_TLBI_NH_ASID:
-		cmd->cmd[0] &= ~CMDQ_TLBI_0_VMID;
-		cmd->cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, vsmmu->vmid);
+		cmd->cmd.data[0] &= ~CMDQ_TLBI_0_VMID;
+		cmd->cmd.data[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, vsmmu->vmid);
 		break;
 	case CMDQ_OP_ATC_INV:
 	case CMDQ_OP_CFGI_CD:
 	case CMDQ_OP_CFGI_CD_ALL: {
-		u32 sid, vsid = FIELD_GET(CMDQ_CFGI_0_SID, cmd->cmd[0]);
+		u32 sid, vsid = FIELD_GET(CMDQ_CFGI_0_SID, cmd->cmd.data[0]);
 
 		if (arm_vsmmu_vsid_to_sid(vsmmu, vsid, &sid))
 			return -EIO;
-		cmd->cmd[0] &= ~CMDQ_CFGI_0_SID;
-		cmd->cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, sid);
+		cmd->cmd.data[0] &= ~CMDQ_CFGI_0_SID;
+		cmd->cmd.data[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, sid);
 		break;
 	}
 	default:
@@ -386,7 +386,7 @@ int arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu,
 			continue;
 
 		/* FIXME always uses the main cmdq rather than trying to group by type */
-		ret = arm_smmu_cmdq_issue_cmdlist(smmu, &smmu->cmdq, last->cmd,
+		ret = arm_smmu_cmdq_issue_cmdlist(smmu, &smmu->cmdq, &last->cmd,
 						  cur - last, true);
 		if (ret) {
 			cur--;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 67d23e9c54804e..b3ef001ce80d23 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -268,9 +268,12 @@ static int queue_remove_raw(struct arm_smmu_queue *q, u64 *ent)
 }
 
 /* High-level queue accessors */
-static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
+static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
+				   struct arm_smmu_cmdq_ent *ent)
 {
-	memset(cmd, 0, 1 << CMDQ_ENT_SZ_SHIFT);
+	u64 *cmd = cmd_out->data;
+
+	memset(cmd_out, 0, sizeof(*cmd_out));
 	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
 
 	switch (ent->opcode) {
@@ -390,7 +393,8 @@ static bool arm_smmu_cmdq_needs_busy_polling(struct arm_smmu_device *smmu,
 	return smmu->options & ARM_SMMU_OPT_TEGRA241_CMDQV;
 }
 
-static void arm_smmu_cmdq_build_sync_cmd(u64 *cmd, struct arm_smmu_device *smmu,
+static void arm_smmu_cmdq_build_sync_cmd(struct arm_smmu_cmd *cmd,
+					 struct arm_smmu_device *smmu,
 					 struct arm_smmu_cmdq *cmdq, u32 prod)
 {
 	struct arm_smmu_queue *q = &cmdq->q;
@@ -409,7 +413,8 @@ static void arm_smmu_cmdq_build_sync_cmd(u64 *cmd, struct arm_smmu_device *smmu,
 
 	arm_smmu_cmdq_build_cmd(cmd, &ent);
 	if (arm_smmu_cmdq_needs_busy_polling(smmu, cmdq))
-		u64p_replace_bits(cmd, CMDQ_SYNC_0_CS_NONE, CMDQ_SYNC_0_CS);
+		u64p_replace_bits(&cmd->data[0], CMDQ_SYNC_0_CS_NONE,
+				  CMDQ_SYNC_0_CS);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
@@ -422,9 +427,8 @@ void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
 		[CMDQ_ERR_CERROR_ATC_INV_IDX]	= "ATC invalidate timeout",
 	};
 	struct arm_smmu_queue *q = &cmdq->q;
-
 	int i;
-	u64 cmd[CMDQ_ENT_DWORDS];
+	struct arm_smmu_cmd cmd;
 	u32 cons = readl_relaxed(q->cons_reg);
 	u32 idx = FIELD_GET(CMDQ_CONS_ERR, cons);
 	struct arm_smmu_cmdq_ent cmd_sync = {
@@ -457,17 +461,18 @@ void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
 	 * We may have concurrent producers, so we need to be careful
 	 * not to touch any of the shadow cmdq state.
 	 */
-	queue_read(cmd, Q_ENT(q, cons), q->ent_dwords);
+	queue_read(cmd.data, Q_ENT(q, cons), q->ent_dwords);
 	dev_err(smmu->dev, "skipping command in error state:\n");
-	for (i = 0; i < ARRAY_SIZE(cmd); ++i)
-		dev_err(smmu->dev, "\t0x%016llx\n", (unsigned long long)cmd[i]);
+	for (i = 0; i < ARRAY_SIZE(cmd.data); ++i)
+		dev_err(smmu->dev, "\t0x%016llx\n", (unsigned long long)cmd.data[i]);
 
 	/* Convert the erroneous command into a CMD_SYNC */
-	arm_smmu_cmdq_build_cmd(cmd, &cmd_sync);
+	arm_smmu_cmdq_build_cmd(&cmd, &cmd_sync);
 	if (arm_smmu_cmdq_needs_busy_polling(smmu, cmdq))
-		u64p_replace_bits(cmd, CMDQ_SYNC_0_CS_NONE, CMDQ_SYNC_0_CS);
+		u64p_replace_bits(&cmd.data[0], CMDQ_SYNC_0_CS_NONE,
+				  CMDQ_SYNC_0_CS);
 
-	queue_write(Q_ENT(q, cons), cmd, q->ent_dwords);
+	queue_write(Q_ENT(q, cons), cmd.data, q->ent_dwords);
 }
 
 static void arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu)
@@ -767,7 +772,8 @@ static int arm_smmu_cmdq_poll_until_sync(struct arm_smmu_device *smmu,
 	return __arm_smmu_cmdq_poll_until_consumed(smmu, cmdq, llq);
 }
 
-static void arm_smmu_cmdq_write_entries(struct arm_smmu_cmdq *cmdq, u64 *cmds,
+static void arm_smmu_cmdq_write_entries(struct arm_smmu_cmdq *cmdq,
+					struct arm_smmu_cmd *cmds,
 					u32 prod, int n)
 {
 	int i;
@@ -777,10 +783,9 @@ static void arm_smmu_cmdq_write_entries(struct arm_smmu_cmdq *cmdq, u64 *cmds,
 	};
 
 	for (i = 0; i < n; ++i) {
-		u64 *cmd = &cmds[i * CMDQ_ENT_DWORDS];
-
 		prod = queue_inc_prod_n(&llq, i);
-		queue_write(Q_ENT(&cmdq->q, prod), cmd, CMDQ_ENT_DWORDS);
+		queue_write(Q_ENT(&cmdq->q, prod), cmds[i].data,
+			    ARRAY_SIZE(cmds[i].data));
 	}
 }
 
@@ -801,10 +806,11 @@ static void arm_smmu_cmdq_write_entries(struct arm_smmu_cmdq *cmdq, u64 *cmds,
  *   CPU will appear before any of the commands from the other CPU.
  */
 int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
-				struct arm_smmu_cmdq *cmdq, u64 *cmds, int n,
+				struct arm_smmu_cmdq *cmdq,
+				struct arm_smmu_cmd *cmds, int n,
 				bool sync)
 {
-	u64 cmd_sync[CMDQ_ENT_DWORDS];
+	struct arm_smmu_cmd cmd_sync;
 	u32 prod;
 	unsigned long flags;
 	bool owner;
@@ -847,8 +853,9 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 	arm_smmu_cmdq_write_entries(cmdq, cmds, llq.prod, n);
 	if (sync) {
 		prod = queue_inc_prod_n(&llq, n);
-		arm_smmu_cmdq_build_sync_cmd(cmd_sync, smmu, cmdq, prod);
-		queue_write(Q_ENT(&cmdq->q, prod), cmd_sync, CMDQ_ENT_DWORDS);
+		arm_smmu_cmdq_build_sync_cmd(&cmd_sync, smmu, cmdq, prod);
+		queue_write(Q_ENT(&cmdq->q, prod), cmd_sync.data,
+			    ARRAY_SIZE(cmd_sync.data));
 
 		/*
 		 * In order to determine completion of our CMD_SYNC, we must
@@ -925,7 +932,7 @@ static int __arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
 				     bool sync)
 {
 	return arm_smmu_cmdq_issue_cmdlist(
-		smmu, arm_smmu_get_cmdq(smmu, cmd), cmd->data, 1, sync);
+		smmu, arm_smmu_get_cmdq(smmu, cmd), cmd, 1, sync);
 }
 
 static int arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
@@ -954,7 +961,7 @@ static void arm_smmu_cmdq_batch_init(struct arm_smmu_device *smmu,
 {
 	struct arm_smmu_cmd cmd;
 
-	arm_smmu_cmdq_build_cmd(cmd.data, ent);
+	arm_smmu_cmdq_build_cmd(&cmd, ent);
 	arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 }
 
@@ -966,9 +973,8 @@ static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
 			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
 	struct arm_smmu_cmd cmd;
 	bool unsupported_cmd;
-	int index;
 
-	if (unlikely(arm_smmu_cmdq_build_cmd(cmd.data, ent))) {
+	if (unlikely(arm_smmu_cmdq_build_cmd(&cmd, ent))) {
 		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
 			 ent->opcode);
 		return;
@@ -987,9 +993,7 @@ static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
 		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 	}
 
-	index = cmds->num * CMDQ_ENT_DWORDS;
-	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));
-	cmds->num++;
+	cmds->cmds[cmds->num++] = cmd;
 }
 
 static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
@@ -1025,7 +1029,7 @@ static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused
 		break;
 	}
 
-	arm_smmu_cmdq_build_cmd(hw_cmd.data, &cmd);
+	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
 	arm_smmu_cmdq_issue_cmd(master->smmu, &hw_cmd);
 
 	/*
@@ -1865,7 +1869,7 @@ static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
 	};
 	struct arm_smmu_cmd cmd;
 
-	arm_smmu_cmdq_build_cmd(cmd.data, &ent);
+	arm_smmu_cmdq_build_cmd(&cmd, &ent);
 	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
 }
 
@@ -1899,7 +1903,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 					 } };
 		struct arm_smmu_cmd prefetch_cmd;
 
-		arm_smmu_cmdq_build_cmd(prefetch_cmd.data, &prefetch_ent);
+		arm_smmu_cmdq_build_cmd(&prefetch_cmd, &prefetch_ent);
 		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
 	}
 }
@@ -2339,7 +2343,7 @@ static void arm_smmu_handle_ppr(struct arm_smmu_device *smmu, u64 *evt)
 		};
 		struct arm_smmu_cmd cmd;
 
-		arm_smmu_cmdq_build_cmd(cmd.data, &ent);
+		arm_smmu_cmdq_build_cmd(&cmd, &ent);
 		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
 	}
 }
@@ -3462,7 +3466,7 @@ static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
 	}
 
 	cmd.opcode = inv->nsize_opcode;
-	arm_smmu_cmdq_build_cmd(hw_cmd.data, &cmd);
+	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
 	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &hw_cmd);
 }
 
@@ -4875,18 +4879,18 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 
 	/* Invalidate any cached configuration */
 	ent.opcode = CMDQ_OP_CFGI_ALL;
-	arm_smmu_cmdq_build_cmd(cmd.data, &ent);
+	arm_smmu_cmdq_build_cmd(&cmd, &ent);
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 
 	/* Invalidate any stale TLB entries */
 	if (smmu->features & ARM_SMMU_FEAT_HYP) {
 		ent.opcode = CMDQ_OP_TLBI_EL2_ALL;
-		arm_smmu_cmdq_build_cmd(cmd.data, &ent);
+		arm_smmu_cmdq_build_cmd(&cmd, &ent);
 		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 	}
 
 	ent.opcode = CMDQ_OP_TLBI_NSNH_ALL;
-	arm_smmu_cmdq_build_cmd(cmd.data, &ent);
+	arm_smmu_cmdq_build_cmd(&cmd, &ent);
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 
 	/* Event queue */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6d73f6b63e64a9..1fe6917448b774 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -651,7 +651,7 @@ static inline bool arm_smmu_cmdq_supports_cmd(struct arm_smmu_cmdq *cmdq,
 }
 
 struct arm_smmu_cmdq_batch {
-	u64				cmds[CMDQ_BATCH_ENTRIES * CMDQ_ENT_DWORDS];
+	struct arm_smmu_cmd		cmds[CMDQ_BATCH_ENTRIES];
 	struct arm_smmu_cmdq		*cmdq;
 	int				num;
 };
@@ -1148,7 +1148,8 @@ void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 				  const struct arm_smmu_ste *target);
 
 int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
-				struct arm_smmu_cmdq *cmdq, u64 *cmds, int n,
+				struct arm_smmu_cmdq *cmdq,
+				struct arm_smmu_cmd *cmds, int n,
 				bool sync);
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index b4d8c1f2fd3878..67be62a6e7640a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -427,16 +427,16 @@ tegra241_cmdqv_get_cmdq(struct arm_smmu_device *smmu,
 static void tegra241_vcmdq_hw_flush_timeout(struct tegra241_vcmdq *vcmdq)
 {
 	struct arm_smmu_device *smmu = &vcmdq->cmdqv->smmu;
-	u64 cmd_sync[CMDQ_ENT_DWORDS] = {};
+	struct arm_smmu_cmd cmd_sync = {};
 
-	cmd_sync[0] = FIELD_PREP(CMDQ_0_OP, CMDQ_OP_CMD_SYNC) |
-		      FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_NONE);
+	cmd_sync.data[0] = FIELD_PREP(CMDQ_0_OP, CMDQ_OP_CMD_SYNC) |
+			   FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_NONE);
 
 	/*
 	 * It does not hurt to insert another CMD_SYNC, taking advantage of the
 	 * arm_smmu_cmdq_issue_cmdlist() that waits for the CMD_SYNC completion.
 	 */
-	arm_smmu_cmdq_issue_cmdlist(smmu, &smmu->cmdq, cmd_sync, 1, true);
+	arm_smmu_cmdq_issue_cmdlist(smmu, &smmu->cmdq, &cmd_sync, 1, true);
 }
 
 /* This function is for LVCMDQ, so @vcmdq must not be unmapped yet */
-- 
2.43.0

