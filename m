Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4749D3CE0B2;
	Wed, 13 May 2026 23:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716690; cv=fail; b=TU9oSI2pP1zCyMv+2MTI0VNK7q6OM7iOz7ijwyKc0xHF7O5UpuoWBxvlRRcGmuLqEc2q/Chc417JJCSX5SoHhYtfs3GHQPuwCKg0xzrk2DZxdNUu8z1LrUEAoOcoPWcf8zEt5e35JGez4J1R/r8s1MRCZTVSFxVDqLqHzUfbXLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716690; c=relaxed/simple;
	bh=qfmADE7Srldb7CduPVBzKEibh3xC4p8ky2XN5Ym32nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZUinH/WTc0e7+oEvqJaf2KQKKdb/Y/lrL+4igwtPyra19F0CYTqjNsENgjvFH++Vc4Xhas5D8i8CYsVryG1e5p9KaiymJaBalvV+0k3jEIcmjW+kmXxKVG6ngYxD7yT8YvwTQIfCpyQQwh6hF2M6KANEEhjtjgvkKqPiZo/Wn9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pMZ3iLm9; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pMZ3iLm9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xFmMZPTpl/O3GJWDI9Lr2XnbbW1E7ivalj/yrPK+Mtt3oMj2k2xQvyNFHtGKHQhnlsyArKxNVptjPXUfJ3OzdDiFYLL/dyH373Sv3w7aXvlAeSePJVglqYYrQJUjDGSpwxgDFNeMVkKwAxqtAnuvnNPnRtzXT9LTRgSxbQ06IHvizGlStgf3UZxkzNcgwZOkzt8CfRCij1DmRsoPDrJ6ANcUyDSDF2qUy+enMH2ACiKzau5shzj//LcZ32Om/BKN4+tXs1wosEb7A2zXVQyCtigzYpl7ZVjgvAI07kLOEKOuGy+iWNMOefrGZRr3Ra22O5ZaQPOIXpCUwL2ePAlvYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOJMyCp1ZUY2xxpf1WPq1YDJR3cy5Zao+ryxvOOk4II=;
 b=KOdwyc2SxdMN1n8mjyFgkOGPnq9jHU04a6UyYPizxHbbCryI8Z5ZZjZMDnylZrZoLoJC6N4w6Jy5jF6nUqwXX++YGk8fDkPLGWP8g29YuVdItpPyT05mL2sMmWB+rNy2hnIj863kNCQ4cWaGrJV7/+NM2jnoMzu8WQJnexF909mldQoPBvQHPFDRyi22yNcGa+LmwOrbBwt9/mpB7cYY/FY8TD/3DV90QItU6y+W4tg0b4g3Al7OGXp/HsoftsqEepJVX3rWCmZnFPDxO429yue4T3L58bfjcCZ9EwNmxEO3uQFOOYZnH+hJi5cM/bpNS/9BnP3IvRoZEhLifHdXuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOJMyCp1ZUY2xxpf1WPq1YDJR3cy5Zao+ryxvOOk4II=;
 b=pMZ3iLm9g1JrLkz5S0aSscXe/qPNhx9nGamDy2K6OU32yKlI4lmld/yDfqNKbbT0d3KvGFcsZS323U/vQnI9M87qLzAh9yL7u7RwlCYuaIpjTyZJTl012JKhENTGOA51HyRWHE4fXJB1ApsD5V/nvyLEpKieD8ECjL6aIOGD119yhA4x50WiQqsFq5xs/hPkfVrIeXpds9Li49ZFmRRJEmCZqao3HLG0dTeNkM4vWBpBqACSNv0Ee5EtkBgSh0Lt0Rgol/Kdk8QnBFxnTUJeektd5NZZ2zEQVvTLMZxkd7jo7fUnXvyrYkfB9szvX2KoZBl4A/8AaQg2ugB8NTI2cg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 23:57:55 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:57:55 +0000
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
Subject: [PATCH v2 4/9] iommu/arm-smmu-v3: Convert arm_smmu_cmdq_batch cmds to struct arm_smmu_cmd
Date: Wed, 13 May 2026 20:57:43 -0300
Message-ID: <4-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0064.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: d4acaddd-572a-4f66-c80a-08deb14b7199
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799003|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	44h4+w3/UDnBuAc+fPUGkKr9UT+miLJA8POX5XAnKZofN7cjh4FxSS7mCJ8BsZkDSE0gV7ISqv0XcSyab/Ajb/rna2UxbpAGTWGmIMX8qEUmDdAumolgkXH8+4iFwmGGtKv4tOMSbBgl459ltO8QIeMVmO41MH/J6S4z9HE8Y89AoDVMuRgnjFbHcOMqiJtstqDH2bz+aKONr7Z1TovoMxt7zf/V7RODjHueGRw2aGCd1/tc+6LiKDZcs5EOJyJOB+c9Rsg6lgNqYzt3OrG9R4DqoL64DLyBHoLj2lr9mBeELKPpYrBGO17YEEHzkJhUKnWVweXjQGk8G8yN8K+fKB/onssupFJ6OAnQbpyfPcWUmwEUIWN4x0vb2re53VCRqNroeH8Q6Lti0C5jZPhtKxp/UaTq2YVzCUQJt/d1F++01BQbpOA4zDZAiJx83ullPsm61CkinURMkBVqm9xIX9zsGnhwZRmaWxyq4gmj2xOEImyBf8AdWRbMG7DS+7kbQ3g7RDX8wRw45Q1U36EMmNOaZOrYc9xJueQHbiVHUSbHYvTAqAuqN+A3RtXJOZX8T6pC1aXLLghpjwy/r148nfuphcqTuHsVEnGcprXMOFqAa+qTo6hUBez/Qet06EJSAfjYPzKw5sie1Sskw/dQ3xUFg5608hfhcxYIgpijDK9nhdUJ+EZfASIKC0yHD/jd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799003)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mzXzsDwtmxvuw55Y1/yzNatqSuqZRl3qtjXxeftwCtJ34GELdmUYKXl42pgW?=
 =?us-ascii?Q?gMfiGTph0qtHN1z7Lvd0Z7MgcwTGGQiBVQle7NU2m/Jvf/qoXw90RcCaYbLn?=
 =?us-ascii?Q?vlWjWOvhevTKoKgKMSOwUIMfR1rVfuUGAhZSTzYjHutM89gN+vsBYkM6wGj6?=
 =?us-ascii?Q?eayJW7YvX+biJjxda9PFfqWJLB6sgn+L534NRjBfgGjiQFoKlpXraDoNIugy?=
 =?us-ascii?Q?FLoGfKVMpp/mvNxKz4+6eAZs3TyiKM0HK16klAYq4q2360dc9Uo9YzO1CFQ3?=
 =?us-ascii?Q?7qjXz8EYJFx7bo8tA591DrhL+dvCdM0xGbmTcXnr4/Ul5DtyGuJziHudwZxK?=
 =?us-ascii?Q?qQgrZFnpUmQU2O71Ey0TGWwmVXWQd7fMXUzHchzmP0JpfL2fKvzuo2pjua/H?=
 =?us-ascii?Q?kJMf2T9ySSEd17CPS9U4Hq+6WBSF8xMtHsYhh8bEBuW6SciW3FDERCR+jy6r?=
 =?us-ascii?Q?Kc8dAsfED3BHNwgPDiMT0mMwmp9FRyBYvRBlcmURn0ig4j0xtwNHdKDT/wKb?=
 =?us-ascii?Q?aICFpKaW0V6OoFLi6xPA9Yi6BL2f/O4Z0Q3hv+gtbvbguonUqHmXpefXm5+O?=
 =?us-ascii?Q?vA0AZl8tc2LJGRyXFhr0Jwr3K1Rur4Pfc+lK38P+GfUQEJ0OLRpzmL3IS2DV?=
 =?us-ascii?Q?Wqjbf+2OP2j1A0ZPmoG0VXPf5J/55iJRyUGo3m0M3p4Ff/fXBoSLx1dGpgxX?=
 =?us-ascii?Q?l7WgdlrC/OP0bmHWwZVeKSBPgChuAIq4SefXDGbtYM630wy5vLJAvy+EALXY?=
 =?us-ascii?Q?hEE3I2FgQgxVIhivAwZwF/jPFPlDcVYLaGJmQflatFGXwyva6Jo/oeJeMAL0?=
 =?us-ascii?Q?YIUr78hc5s1W58EwRAC5UnJY7Oc6aEVny/O7zzcCIt//DntJuPKIO46QJg2J?=
 =?us-ascii?Q?C1L6klRmGfeSI29itYvckvNabx5jbNaJI6OlVlxISUcZQqjd5QmGewGhKwPs?=
 =?us-ascii?Q?+KnINcisP4Z24nL/PnH/iNeMfNDcdCRCgLIrTHX+E7oqFkCbKt5mwzbDq4S1?=
 =?us-ascii?Q?vHJAl42MnuQIwVFqFkLvjn6YFFFeZoDNksFTkDIsl2stDGtR0f8dd2IdlsDl?=
 =?us-ascii?Q?Dwox8LdS0DnIkLoT7NzXu4ZIcs7ycMUI9tymUOBXrsPmkgAoXzp9AY+kve7w?=
 =?us-ascii?Q?ojRx8biCUiMh9vTZfm7u6oAM64f8tOCAAYL3YtmuYuryKQCtGGQ8gJclWK5Z?=
 =?us-ascii?Q?6AfuCQ79PN5MNNdDeCyN3JD/WzWKxbUPm+GkQPrXdRipsm86SFszuQOlTMXl?=
 =?us-ascii?Q?+JMjzp2BFsDMiDM4E2Dc2X11fk7Lph0ieV4ijoM0vxfSB3/2aICP1UWFhlkI?=
 =?us-ascii?Q?LYCFbsjfVrMQyTv6No53dGqVfywQKXv/Cd1gfqdMOULvhe0S2v5PyDkEur2l?=
 =?us-ascii?Q?s9ULZRUi/mlkLKOynRu0BcPjfBnje3ccLTz/nniCb231Ocz4Vg0qDtF4elOk?=
 =?us-ascii?Q?pYDsTLymR30q9jS5jg1ikFPBw+TKhgkjGuz3DxLPxapXvsIQ0Y08fxt19xNw?=
 =?us-ascii?Q?g0tBqus5/4nNJ6sgv8vS4QFUziTwZALjfZ0w9QCvNMZZOJir9Y5h9yMfM5+h?=
 =?us-ascii?Q?HD6XdQvPH5QQIJGr28Q4BLOWR14Zc1cjg3dlUnbGtyN71gs3TB6E17S9WjVU?=
 =?us-ascii?Q?u0TAN2EgThi5HYoxij9h6XrGZf7JvLAnRl4X71G+eWyJcbDTccSwkNehaymM?=
 =?us-ascii?Q?UdnnJZgZJAK5tcNfsboDJIcWhS8l2xQCs6NXyP0TWDJj0mMv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4acaddd-572a-4f66-c80a-08deb14b7199
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:57:52.8510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJNevBnbDtgRtVOCiXY1LTn2dJLoZK17AJH7XzXytmP/t//is6B3qas9ssNNT35e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

Convert the batch's type to also get the remaining helper functions to
use the new type and complete replacing naked u64s with the new struct.

The low-level queue_write()/queue_read()/queue_remove_raw() functions
remain u64-based since they are shared by event and PRI queues which
have different entry sizes.

Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
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

