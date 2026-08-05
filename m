Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE9C3E6399;
	Wed,  5 Aug 2026 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957363; cv=fail; b=BCbA92dl4YsERlUByBqRg6kDfzc3Z0h1Ix/JMRAMkR02XP+humFWgfXGMut7XgGHaxqWDnONlSqlqLB660+ddhsye22SsOqSdrq0fPXPG4GZtlrOqbUVJBdPPkHVDEtshQgTyCDSi6T1BFIjuCc7LihYguBXzBCjpMolrWeQM2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957363; c=relaxed/simple;
	bh=U3RZGxkYvFGRsiuizJ4tlJbsn6Tq+d10ukSCfg+rVu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=keMJcnmCW8qXX+MKp1V2q2ajXeWOg8CCpTCQHgScDqGrqMjvQxq/oi7c/vWZgqEP/qcEDWA6bg5BkINp7po0hOm8HLmJh7Z+HDllBt2nT1rI6AyBH9CqmXExoKKRImsSIzTnWjNE6jN+PmxWvcyjPoiVTWQ76JXxmzv8p4/g1Rs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iZfRBYFa; arc=fail smtp.client-ip=40.107.209.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iZfRBYFa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sSPdzoEZHQZQxaM1W5WdhPqQFCVW6iFeywNPDDtxqWFo4ToJHvpk/c9AsnVOl5Tx4FbNRSYlDM5hbY8JwSH/hboc2a9LUX+QRjnqJHAzkXmC4zG96QIfSbx7JYvcXuVelOsYZaDSRXpX6uC2zCmeb2ZiP7gsJUzN3jPUeuPT6FK0kaIc9P1x4vEYUrVKKYrntC66YmzqwyQ+NZvU3fuG3ls2YYjWDhOzNJhtopfx2T/DB2+nTPQ2WHgSLa6iQ4wSuQ68HVOlBpMWNspozNgLgqZ3WBrkwg1tH8D/laLAqmKBbc0JyxMheLM5ZlOWO/FsrG6hcdgai2837mceHxaCmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c72dJf2mp4Fi/n/MssH4U8k6Dvtqe/OTKjWKnp6bRuM=;
 b=D19o8N6EnV8eLmfSJu3RycRv4RxzYrLO/OiT3nzou/gXuf418XY313GblJhxOx8WqIiFmYqyNg3+R1uB4WIRw1wTiP4JyVwU5gFgwr1O4IYzF7gFsGL2t94E2GF3NVtqhhPDs4h8CyAIfqUzxCSzTBu44L5APwTtJCamLYruehOYkv27uMRJnny1zzkF9kOjy9b86qt6EQSADMYeF7x2+0s1woh8VqRSCzKV7Qt+YB/JHCh9s5qiRg48s2BpaqSDgMakQcyug6D0zrVGYfM5lz5gTnlKhXj4XjybLmGEaMrolT0tmiAuRWAMTmHmYTu9j1h5k/GgtFebNOa/Lrc42g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c72dJf2mp4Fi/n/MssH4U8k6Dvtqe/OTKjWKnp6bRuM=;
 b=iZfRBYFaJFjRKqyXa3wq7q4nCdKj0OjU/VIOgzaEaFa3TRB97U4mqZC2HTDLaI3dNCkUCL9i/zBE89aKWXsogUZbkwXRK8c5vQUsTe9SXF6+TfRLLpYvrnjMhi4crMbTnpbTxXBuHyyWWhLIU1UuxB+eOwBOlY55UjMyOudr/npZU8pKs5IL9Uw1YvAzMQH1a1Ec5ACl73eCL0WctmOGdpvWpGPjvH7BMCZ+U0eH/nCAlSxZaNxdTAOCpDWF/mWObO0cw8yJLRoFWhunLlXL/QWttXtWM4bvuwRdA6ZNSQh6NL+c3omm37kDWJA5mVCzSU0bZRy4fCCqLqTIA5F+Fg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Wed, 5 Aug
 2026 19:15:29 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 19:15:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 3/8] iommu/arm-smmu-v3: Optimize range invalidation for latency
Date: Wed,  5 Aug 2026 16:15:21 -0300
Message-ID: <3-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0071.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::23) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: bbdd9a11-6815-45c2-8d47-08def325e956
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Y1TWe5RNZTns3NUimeh8TCBqdcKwMUZegKNhx9pXPJfXq7JIvcJVhSGdRHjFGmNb8+nQnBGRShGKesFDE2f01C9jNbYqzC4qGDLYqHcCPzbXe4pZbPPOrG154Hb2bcFuUW3RAdeGN2u8Hx94aRkCONphTj6a6JH4DCe6xxzoPvyDuQ5RMxvkv/KcnliOmveZkoPAVby+Ct8ufmq/cHsPfi+CAEBq2klVLGJGthBmBSeTAjc3FRv7jB+ieY27Gu2W5jZvSJG/FE3wVetEDqyb2XWpjzCQ1WZJ1HCy9V2ms6kPkEbyIvp7vo1MQ9WKdPWRF0qUdoGSauKeQP5OQVnm8kLlLyxER8SybCRiqWNnup/qMOJK/OO6BbLdwYXs2EScEFHxIt88zFrNXE+R6xhUsVCX5Ib7aV4W0WrlZtNRHsESJUvfL8o4h3t7vwOg3urw9rfXBHl4sBRuhZWM4MbWN8erwtM1k3zLCySia4ZqRyiQw23TDg16mhf8Rqi9xaaXYzOZFk/nHgZFvwiEfthHZMBCkrBfRdwzPW76HB2naNJDG3c2AYwUvURutSwoF0W7Ww6OGkEY7fnJFE4YWshUK6bmkounmHTSjWbc9b2mNK031Gxi+FMjDlE5X/2QfmvtoowWkM7e601+aQu3DYuVKvTstTKM0z7iQ93iklejX7A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ae9Mn4lPPUSzA/nS6mGHcQilcnbGjvYdeiX+HT1qPiW5P+CvLYZsBq8Fj+Lb?=
 =?us-ascii?Q?BmwdBEtw26rXLBTqmx+Ak35XyxIsBglJGZD/+QAiuapFw3nfFfTwPZ+WMVHd?=
 =?us-ascii?Q?YCK6wxEF7xxg69tk2VFKbsFvKCjPKvwQ+QsvZMIvslnHMgG0fHtCSGYN+f+a?=
 =?us-ascii?Q?CscsuAtPhUzGD/i9mLzCrCloOBkpTnzAlh837PTBw+wWB2faZsHywYU/WlPA?=
 =?us-ascii?Q?0WDque1be1I3aaNV+g4wHShOg6gINYue83axqW3CSF/SqT3BTHesTEhvxTsq?=
 =?us-ascii?Q?RuPHEKGKXYLDMvdES3ZpRIlERHDHbf90aD8XiYpDw6Ox/9O5uKqy0mcpD3yH?=
 =?us-ascii?Q?zNEY0US15TcEk5iaXFIrdWW0ESAyz5w3rFiP31gExlu94X3Zk5m29Ix3Js4Q?=
 =?us-ascii?Q?xnHkrOqFAHH2aSTZ3aODQA7qseaREhsKIyxevyqckmPuwcWBuK8gj89Wz7j3?=
 =?us-ascii?Q?mPeKlfJY9d+nZ2QuBO2hKPfMzM/JnRL29QAfYB7Y8PA9lsRgbM9nX9WOP0TF?=
 =?us-ascii?Q?R1YOxOFijR+O8lU5Pkwal/kvpVYhE8aNIJ6Ls4EzyGQedBMpVtn68JdWwS32?=
 =?us-ascii?Q?7XZYRSAEENzxLRk1LnJAS0Y0BWrtzZCkJtIWmuLcPX7sLVPSamMngvygeJiq?=
 =?us-ascii?Q?tRXklUhGHVCl42ktlxfcC9cPFcR4UibLjDeEL9hbiQB20ZeoTe4G5YLxqnlI?=
 =?us-ascii?Q?fyj6LuFx3wn2RZ//kxi8LNqOU1z/WnZhylrbLEeQJ3CxAweal6GqB54WQck3?=
 =?us-ascii?Q?ArrQ7UxTskk6JlrLNA6hFKpBl05ZoGmQwQKj+cpRSrjAmyrCgvPVGQHYZSO/?=
 =?us-ascii?Q?TINbbO737dtF+k2awrilbMRvDF02OhvYSPXViCetw6Mynopk2CW3aMHfuYPC?=
 =?us-ascii?Q?JJuWJleXuPuWJR3aE0AFGautdWyNeEP6DkdE3+xbJB7viv7kIJfS7iSJfEFd?=
 =?us-ascii?Q?uEnPuttT9phA6CgDjqgjXtwuujOmSzY3KAZKCxPVWaO2efJ0N+qsr5dpMOmJ?=
 =?us-ascii?Q?BIjCbNehEwr/3KlaiuQARDiOOciV/vojARzmCn/RDRYwWM1IYkFnQB3RYva6?=
 =?us-ascii?Q?iqZ3vmG1o0oVIvWprH1GBnf7AlvsrcYMXaDkfzWU6S9/DKl3WzZbNgVUQi2c?=
 =?us-ascii?Q?/m8ZNM6MrU6reKd+SJI28eLCus86uTHpPuqLJhwIbCQYYTiFpHS63v545575?=
 =?us-ascii?Q?InqOfCPl/86HV9pu8+H2KBitzWiSc0jkR4/fpddrUgBsqR7/oXi8LLSISjQS?=
 =?us-ascii?Q?faB97lKzce33Lo8KZ4DeL3i3sintfjI5qPeI23GJHI5qOBhjL9Cgr7D5smTe?=
 =?us-ascii?Q?iPXGoY7NtSOGe20B1oTSopUO6I9MSlPk9NpPPeRqKFJdMhDuPuO8V1i52yhO?=
 =?us-ascii?Q?7sJEUs1xoLeVaGaKTXcSKmmK/+AB8LCZMOiM+6f/WggleFkjlIOpsxvnRXSZ?=
 =?us-ascii?Q?HFL5SuD9rKQ0o4Y3CwfEoLRVWmMWHAPXk9M03A0xynXupES3aEsCaenqHQ4x?=
 =?us-ascii?Q?Mhqp11qxy3xWEKFgQi/ASKisbN8m09o9WF9GWqRQRo/jZJg9ZWAMk5F+KTQd?=
 =?us-ascii?Q?sckpf1Elk1OiNV87qL/TfOzxgGCgJRpDS2WhYEMUE17KkBc2l4e2p59uYtGh?=
 =?us-ascii?Q?vt2HDCTdwSuH9lrUc3RB9E0SMXNhrYM2DXpZXr0+Cc/qe1VPSymYxAP28uJw?=
 =?us-ascii?Q?65Enyshlwz/7HzI6NkPtHv6SD1QJzhLDsB7bZ5/2dFxDigkwNlrozRqS1GGH?=
 =?us-ascii?Q?IEX2duJk+Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbdd9a11-6815-45c2-8d47-08def325e956
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 19:15:28.9825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PlCvKJfLLJK3Sk0VIo2NGPUZL7s19PDTDG+jLpT2GX+12gVe9QJ8GW3rTgr9cco
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157

The server IOMMU drivers focus on invalidation latency by default,
over-invalidating if necessary, to round the invalidation range up to a
single command. I think this represents a trade off for DMA non-FQ and SVA
where stalling the operation is overall worse than re-loading the IOTLB.

For instance AMD and VT-d both round the range up to the largest aligned
power of two and invalidate that. This causes over-invalidation but that
is preferred on real HW over trying to issue a number of smaller
range invalidations.

Only if a para-virtualizating hypervisor is detected do they switch to
using more accurate invalidation. This also triggers using
iommu_iotlb_gather_is_disjoint() (ie PT_FEAT_FLUSH_RANGE_NO_GAPS) to
remove over invalidation from the gather. A pvIOMMU has a hypervisor that
will walk the IOPTEs and resync them. Over invalidation, especially
significant over invalidation, can incur a big latency cost reloading alot
of page table. x86 IOMMUs have aligned range restrictions so there are
some pretty nasty corner cases that can trigger huge over invalidation.

Currently SMMUv3 doesn't support detecting a hypervisor, and it
unconditionally runs in a NO_GAPS mode. This makes some sense for the
single invalidation flow where there is little reason to push single
commands across a gap.

When we get to RIL hardware, this doesn't look so good. On real HW the
best option is the same as x86: issue a single RIL per gather and optimize
for latency. SMMUv3 has a significant advantage as its RIL does not have
alignment limitations so it's single-command over-invalidation is capped
at < 1/32 of the gather's size, making it much more suitable for a
pvIOMMU.

However even with RIL SMMUv3 still uses NO_GAPS and it breaks down the
gather into several exactly sized RILs to avoid any over-invalidation,
costing latency on real HW.

When the HW has RIL support follow the x86 approach in SMMUv3 and
calculate a single RIL per gather that will cover the required
invalidation.

Calculate the smallest SCALE such that NUM can cover the range to minimize
over-invalidation. Always use a RIL command if RIL is possible working
around the spec limitations to form a valid one. If RIL is not possible
then do full invalidation.

This approach is selected because there is an invalidation errata related
to CONT that is solved by 'always use RIL', so we don't want to switch
back to single invalidation if RIL is present.

Since the normal path is now the only one with a loop, split them into two
functions and fold a simplified version of arm_smmu_inv_size_too_big()
directly into the normal flow in a way that directly limits the number of
single invalidation commands generated, again focusing on controlling
latency.

The end result is any gather is converted into either:
 - One invalidate all
 - One range invalidate op
 - At most 512 single invalidation ops

arm_smmu_domain_inv() is modified to always pass in the tgsz because the
new logic relies on it being valid.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 264 ++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   3 +-
 2 files changed, 161 insertions(+), 106 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 73278cc8c5e5ff..643cb81c50e462 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2460,125 +2460,172 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_domain_inv(smmu_domain);
 }
 
-static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
+/*
+ * Check address alignment for TTL hint per SMMUv3 F.b Section 4.4.1.
+ * Address bits below the alignment must be zero, otherwise UNPREDICTABLE.
+ */
+static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
+				      unsigned int ttl)
+{
+	unsigned int pgsz_lg2 = (tg - 3) * (3 - ttl) + tg;
+
+	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
+}
+
+static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
+					struct arm_smmu_cmdq_batch *cmds,
+					struct arm_smmu_cmd *cmd, bool leaf,
+					u64 address, unsigned int num,
+					unsigned int scale, u8 ttl, u8 tg_enc)
+{
+	cmd->data[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+			FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | address;
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+}
+
+/*
+ * Issue a single range TLBI command covering [iova, iova+size). Returns true if
+ * successful, false if the range is too large for a single command.
+ *
+ * The algorithm finds the smallest SCALE where the range (in tg-sized pages)
+ * fits in the 5-bit NUM field (max 32 units of 2^SCALE pages). This may widen
+ * the invalidation range.
+ */
+static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
 					  struct arm_smmu_tlbi *tlbi)
 {
-	size_t inv_range = tlbi->iopte_size;
-	unsigned long iova = tlbi->iova;
-	unsigned long end = iova + tlbi->size;
-	unsigned long num_pages = 0;
-	u8 tg = tlbi->tgsz_lg2;
-	u64 orig_data0 = cmd->data[0];
-	u8 ttl = 0, tg_enc = 0;
+	u8 tgsz_lg2 = tlbi->tgsz_lg2;
+	u64 cur_tg = tlbi->iova >> tgsz_lg2;
+	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 num_tg = last_tg - cur_tg + 1;
+	u8 tg_enc = (tgsz_lg2 - 10) / 2;
+	unsigned int scale;
+	u8 ttl = 0;
 
-	if (WARN_ON_ONCE(!tlbi->size))
-		return;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = tlbi->size >> tg;
-
-		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
-		tg_enc = (tg - 10) / 2;
-
-		/*
-		 * Determine what level the granule is at. For non-leaf, both
-		 * io-pgtable and SVA pass a nominal last-level granule because
-		 * they don't know what level(s) actually apply, so ignore that
-		 * and leave TTL=0. However for various errata reasons we still
-		 * want to use a range command, so avoid the SVA corner case
-		 * where both scale and num could be 0 as well.
-		 */
-		if (tlbi->leaf_only)
-			ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tg - 3));
-		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
-			num_pages++;
-	}
-
-	while (iova < end) {
-		if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-			/*
-			 * On each iteration of the loop, the range is 5 bits
-			 * worth of the aligned size remaining.
-			 * The range in pages is:
-			 *
-			 * range = (num_pages & (0x1f << __ffs(num_pages)))
-			 */
-			unsigned long scale, num;
-
-			/* Determine the power of 2 multiple number of pages */
-			scale = __ffs(num_pages);
-
-			/* Determine how many chunks of 2^scale size we have */
-			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
-
-			/* Keep the pre-DS 5-bit truncation when scale > 31 */
-			cmd->data[0] = orig_data0 |
-				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
-				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);
-
-			/* range is num * 2^scale * pgsize */
-			inv_range = num << (scale + tg);
-
-			/* Clear out the lower order bits for the next iteration */
-			num_pages -= num << scale;
-		}
-
-		/*
-		 * IPA has fewer bits than VA, but they are reserved in the
-		 * command and something would be very broken if iova had them
-		 * set.
-		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-			       (iova & ~GENMASK_U64(11, 0));
-
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += inv_range;
-	}
-}
-
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
-				      struct arm_smmu_tlbi *tlbi)
-{
-	size_t max_tlbi_ops;
-
-	/* 0 size means invalidate all */
-	if (!tlbi->size || tlbi->size == SIZE_MAX)
-		return true;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
+	if (!tlbi->size)
 		return false;
 
 	/*
-	 * Borrowed from the MAX_TLBI_OPS in arch/arm64/include/asm/tlbflush.h,
-	 * this is used as a threshold to replace "size_opcode" commands with a
-	 * single "nsize_opcode" command, when SMMU doesn't implement the range
-	 * invalidation feature, where there can be too many per-granule TLBIs,
-	 * resulting in a soft lockup.
+	 * Determine what level the granule is at. For non-leaf, both
+	 * io-pgtable and SVA pass a nominal last-level granule because they
+	 * don't know what level(s) actually apply, so leave TTL=0.
 	 */
-	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_size) - 3);
-	return tlbi->size >= max_tlbi_ops * tlbi->iopte_size;
+	if (tlbi->leaf_only)
+		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
+
+	/*
+	 * SMMUv3 F.b Section 4.4.1: TG!=0, NUM==0, SCALE==0, TTL==0 is
+	 * Reserved and causes CERROR_ILL. Single page uses NUM=0, SCALE=0 with
+	 * a TTL hint to target only the exact leaf entry.
+	 */
+	if (num_tg == 1) {
+		if (!ttl)
+			ttl = 3;
+		arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
+					    cur_tg << tgsz_lg2, 0, 0, ttl,
+					    tg_enc);
+		return true;
+	}
+
+	/*
+	 * The spec defines the invalidated range as:
+	 *   Range = ((NUM+1) * 2^SCALE) * Translation_Granule_Size
+	 * NUM is 5 bits, so (NUM+1) covers 1..32 granules and SCALE scales
+	 * that by a power of two. We must pick NUM and SCALE so the range
+	 * covers num_tg granules, i.e. (NUM+1) * 2^SCALE >= num_tg with
+	 * NUM+1 <= 32. That constrains SCALE to:
+	 *    ceil(num_tg / 2^SCALE) <= 32
+	 *    SCALE >= ceil(log2(num_tg / 32))
+	 * Choosing the smallest such SCALE gives the finest granularity and
+	 * thus the tightest (least over-covering) range, and equivalently the
+	 * largest NUM.
+	 *
+	 * Unlike other IOMMUs the spec has no alignment requirement on the
+	 * address beyond alignment to tg (so long as TTL=0).
+	 */
+	scale = fls64((num_tg - 1) / 32);
+	if (scale > 31) {
+		/*
+		 * Range too large for a single command, use full invalidation.
+		 */
+		return false;
+	}
+
+	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
+	if (tgsz_lg2 == 14 && ttl == 1)
+		ttl = 0;
+
+	/* Verify address alignment for the TTL hint */
+	if (ttl &&
+	    !arm_smmu_ttl_addr_aligned(cur_tg << tgsz_lg2, tgsz_lg2, ttl))
+		ttl = 0;
+
+	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
+				    cur_tg << tgsz_lg2,
+				    DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1,
+				    scale, ttl, tg_enc);
+	return true;
 }
 
-/* Used by non INV_TYPE_ATS* invalidations */
-static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
+/*
+ * One TLBI command per IOTLB entry, assuming the entries are all at least
+ * iopte_granule sized. Returns false if too many commands would be needed which
+ * indicates too high a latency. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ */
+static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
+					   struct arm_smmu_cmdq_batch *cmds,
+					   struct arm_smmu_cmd *cmd,
+					   struct arm_smmu_tlbi *tlbi)
+{
+	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
+	unsigned long iova = tlbi->iova;
+	unsigned long i;
+
+	if (!num_ops || num_ops > 512)
+		return false;
+
+	for (i = 0; i < num_ops; i++) {
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			       (iova & ~GENMASK_U64(11, 0));
+		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+		iova += tlbi->iopte_size;
+	}
+	return true;
+}
+
+static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
+				 struct arm_smmu_cmdq_batch *cmds,
+				 struct arm_smmu_cmd *cmd)
+{
+	u64p_replace_bits(&cmd->data[0], inv->nsize_opcode, CMDQ_0_OP);
+	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+}
+
+/*
+ * Used by non INV_TYPE_ATS* invalidations. Returns true if it fell back to
+ * full invalidation using nsize_opcode.
+ */
+static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi)) {
-		struct arm_smmu_cmd nsize_cmd = *cmd;
-
-		u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode,
-				  CMDQ_0_OP);
-		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
-		return;
+	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
+		if (arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi))
+			return false;
+	} else {
+		if (arm_smmu_cmdq_batch_add_single(inv->smmu, cmds, cmd, tlbi))
+			return false;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
+	arm_smmu_inv_all_cmd(inv, cmds, cmd);
+	return true;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2601,6 +2648,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 					struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
+	bool used_s12_vmall = false;
 	struct arm_smmu_inv *cur;
 	struct arm_smmu_inv *end;
 
@@ -2633,11 +2681,17 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
+			used_s12_vmall = arm_smmu_inv_to_cmdq_batch(cur, &cmds,
+								    &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
-			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
+			/*
+			 * S2_VMID used CMDQ_OP_TLBI_S12_VMALL which already
+			 * flushed S1 entries. These two types always come in
+			 * pairs and arm_smmu_inv_cmp() ensures that they are
+			 * consecutive in the list.
+			 */
+			if (used_s12_vmall)
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 81f1b61ea29c53..9bc655f25adcfd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1170,7 +1170,8 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
+	arm_smmu_domain_inv_range(smmu_domain, 0, 0, smmu_domain->tgsz_lg2,
+				  false);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0

