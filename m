Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C2C3CBE70;
	Fri,  1 May 2026 14:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645775; cv=fail; b=f2feFEw5idXNyd41q/zzyVawHoW/JyS0rphXTiO0mGaRj2FKj6CZwf0XIIGXky837bGpLnuiTV7pguSu3jMhjwXJBi+YKWZAEebxXH3n1Zax0t+ciKzEl2ns4adjGZUcoleNyX0mTkvVeGN+gfsZK3QitBqWXEKC2bKpgP0ah6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645775; c=relaxed/simple;
	bh=gn5HlVZyX8VnUehFG6bidDI9KSXqrhbDohKVMmme42o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eLgiTSMn60NW+ZmSSDN9CaHHgHL3ELRHdbcVINfqBybb6W6CoZNpcFIMkQ0FHBz/jgEtukof832k3GKeWh1ZuHa6xIClg9/qM3jodrp9wR0IZEYFcVMnq1t2XXbuxrP4uaSAuJWls9SgEceFR8KRebi4c6/YeKe5TQSg9g8vK/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LYyIDXyj; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LYyIDXyj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhqGHtR/iu5gqfQ0cePp3TOPK+edAzuZIlbfeJA+3mmzzqnD0YrDeyTB/eY0TvBsAb/CeIyiML80Dqa73HJhfEjv0sUIrWIcwFFb21U968+GZUgFTKGwKgZMVrcJb/99LLOYahilztdHfIDo/mDkmJNrRb1Ppy4aFZoM16Ib5OwMgtf4SrOoHzhdaT2ol1/YpZGiObLcmr/zqidnLiGuH+ivZJfvS0TIr9tfOYyEen//EcWpNJiOpnxEt6Bta8IjNq/Q7iSXkWfBcyxcR3//B1rYjPruO+my/kn57XGCpLs0dOK4xG2wLdX83XM1h4S9XEuAb+ipaiLC9MgqbvAxZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5+RRk8gmuwu1ShgI4kGOGgWDuE1ikupDWuNgYtX+XU=;
 b=Wy0lERPPToHklsdjI+qJ63TIF4VDczlgkLM/jJEz8NYcaOkbeNcTXw6OYo2522U5aNj7hz2sVYlxPheA2vUgl7jJGL2TCX9UQVurd5JhwxKR50WqdCtCQL9NFdfHTvcPMB8oJjIUxu9RPobO0DFQIQp6SjOnbr9Ak4ot8f9DcWl8CzYBQ6KCV+TOHTvjPCDtvIhj/In1tvNcd6eIwusb8LEcTciqeYRk5Wg28zN3xStUe6koIRLKLSZlgJbHOljdWm06stxRd0D9kI8pmZwnoUjALLmNQobZmvINYBRpniUmgDoSvqCecvKDX0R832WwsHKTaJ/uZvyZ1q16ZSP9zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5+RRk8gmuwu1ShgI4kGOGgWDuE1ikupDWuNgYtX+XU=;
 b=LYyIDXyjWJCWU+iDIStI1YdD0WeBJY4gxtC5AqDyLCPQ63T33ZmqzfHSFpsljayDbeqIhcCCWjW878jHEHpTZA+cEAgA2YEELhfc4wMdsL55KbqRa1YLTqahNzgMs+OSggwA+tf6PpMlsH2kxzpLjxvaRFt5+j2msVpapcDYxR/kYkWeMqn9ectKcgEBZsKsksH42O2yIXHBRnEtQE8vw13ZQjJahLo/UtMxnAXnCN9TB5674DEMC9cbDYGBALQDF+PLffi8UrFDT8NNUmf9TJ/tWxBkIfeUMnNmDBaxkIUhiO4rhjcLzsqg1Xmrwccf66y3CU3ujzkCXt0nMZsrrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8096.namprd12.prod.outlook.com (2603:10b6:806:326::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Fri, 1 May
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
Subject: [PATCH 3/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq submission functions
Date: Fri,  1 May 2026 11:29:12 -0300
Message-ID: <3-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0031.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: a9393881-be6b-4a36-9bb6-08dea78e091d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JPGcawhZqA/o5fEvE3NFl/lAP4oZDAa5vlQbkDEG9GiuHYlQdcBZVVy64NQsY11LhGkkhJsMgO1SEgcmRWj3EMWEn02hbKkYaDB4nitc+++tT8YuDZ306s7GIeu9osDdl1IESiEx/4DyKbMjJzUlmFOFw9ivHsM22eRosbr+/m/Y7eOCgzrIAzCAmarMlRF7lvQ6AnhCD/YcDXnBv+293efs2LoKxIh9nSeq2QTZt98n4ZCi1L6zNDkd8TOc5zrD57eLxBQzWCIqEBCCk01GG6ro+gJXOuYKxYscF//X8GK3S366ih7hdhLrW4b4dgUPZVL9wwl6QJmdgMtczHdXI4sa1R4S+XEhJbeZLkXqAMnYii3selFBfhNJxQfo2M91rYn90IBCI/Z9otm3w7BM/qTnB6pLX/vUgFvY7qi3/zs3T71VviCXQERcRfFw4sHSVejZMORniPnlAZ+1S6x27WTd0zrJEZB3JNP+tJJDTwCa3V9cmkStr4Ne9wnO1YZGw6CQrd7FcK06mWzOlaWOdGNYl/g33x46LCzMSQdih9zj3h+2l8nLF6UdChR/ybj5VIRRGFaabq22B4rQu3MBoCrsFPBnivy266EJeWvGom4zTVLPcSfaJewtA3XCh2encr9a92PCJhQfsucTDQjQq84/G2YllTCAxGx5QYVmczQRUFu0hRgoPL1VomvK0NaV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ygzql0HaWyBLCYxoxeWDq8HSOoc7ho4/XiLQRpv0LJUJ+QqJuxbvXwiopfd8?=
 =?us-ascii?Q?skXiEHgbhwYAZoA1/91N8JfpNYBLK7Sj4vfuP+1BVx5DPRil/+yPsvW4KA4T?=
 =?us-ascii?Q?f0op3qlzydnG3cOmdoNcPWGDFHxuSXiFdpRx06w06vwlHm+Sko6/QPFUaiNn?=
 =?us-ascii?Q?c5VBQTg/e8W8gqt6mIa/+NUgj5QgFsl63FJxjiy07n9pht7+GyPkPonNsVCh?=
 =?us-ascii?Q?exfp/p98cmuRDTNIkupxGf7Znz/HvZs6JeVwgJx7FDgoVt5j+kcaGdjA08fx?=
 =?us-ascii?Q?YBAcmQk5uSJ/6FaV+MOV+07nIhlR6ZQ0xdrF6kCWKGxcQv7rPkE1NFFRfTCa?=
 =?us-ascii?Q?5Zstpgc3P5BIW5qF+tzDJGoDb3nCx1BVqVAz2CwW0VDbudiWv8bsH2wwgpn/?=
 =?us-ascii?Q?GQZ0lymPtd8GVl8cGr/CPIZcWORWVrYVpDAHnIHeoa5Yhjz4zoBK/UjSnMs8?=
 =?us-ascii?Q?NpeG5oTSyyXiXvVZvRCo7C9IBTxxi2IdPGaNvKWs/Pn1gZzFnHPH0qFGQevP?=
 =?us-ascii?Q?hEGV3M0K4QXmZAMW2g1fE7pk2BeuHIn7bY39bhV+S0AwONzTOzHVfSdzf9id?=
 =?us-ascii?Q?evMLmjBvbGfZMMX6lsbRnfrrUXCSs1xFJAxGw6C7wm59/ksTLStu+q23Myen?=
 =?us-ascii?Q?xbiuIbBlhjFUdh2KYI+uqJg5HJMwWWaaA13TiL7Cyiw9PmzKN1I7uuKMKste?=
 =?us-ascii?Q?QPyw6axcmHnoy9yYJhVj9ujDWt3IG8epTkV8Hit0pZoYVI7PmGkQrrVbsApm?=
 =?us-ascii?Q?mb3WUVZeuVbuEW3q//MtHgxXec4zea7vOzoR9y9VTdY4qPfKfQ2hj8nFMRSi?=
 =?us-ascii?Q?hJ0SGpQe1jy95p6eZV3Z6uEVyGEsSdfb5llaZdDAh6zWrvaXDk462VwwFzrm?=
 =?us-ascii?Q?i/0aFd9uunx5h/JGR9c2C5dXkq8k7VlFew2J2DPjKD2SpvkpDKo9GVXTkoE7?=
 =?us-ascii?Q?b66dVulZwQ6TWkeKpsDiwaosmhXXLOOeinHTyYw+2DIfg3DaZeqa73dk8THQ?=
 =?us-ascii?Q?tRri9YFrZSyYCe1rL57qhw0NZ6HaN7V/taLgwSz5u5ux9DGFJMOpOGoOP0BX?=
 =?us-ascii?Q?KFQ5VjAQMuBMlc9uVN0KpFPqjVfYtc7PPt+3dl2bv/ggWJ4KcrEopDqODltv?=
 =?us-ascii?Q?gSOXVVovSQJj8RVcwrDKT40Pmmq7RS1izpAkn3Eb/xhnT/PpxiEy7dSjIasy?=
 =?us-ascii?Q?nJoTJcgSJyJStAb7IP2PI16fhgmb7PAH0lUsSiCdhPvH/DCbmL7KiPfmjy/u?=
 =?us-ascii?Q?IIYnwGPo8dRGEhirHu/Uu1UdEplhwLYYXU2t7wvgm7PpwSOnhLTFs+vyu95S?=
 =?us-ascii?Q?9MvowH5Dso/oD0S8W3uVpOSii2rjpZBgFdZJ6cgwuHcxJkRKCJVHvQa/vAh1?=
 =?us-ascii?Q?u9PBLgx3ZVgdQtDBCyKo70GA6FU/3l5ZPSU5CFZJbECkj193JXXZFq77dky6?=
 =?us-ascii?Q?QfgYr7jyDR6j8Ha+4i1LFgbX5ipN9+sEv2OvfFt2szX7BLvIue7Gwd3px9QT?=
 =?us-ascii?Q?RvR+N3+PUDyhNvt1okV1fVBzDv/Tl9fWkneqRuL3xvmKMcEbKEM/qhsCCGiY?=
 =?us-ascii?Q?6vRi4oRzUs05PKzvKq1lOKeuq/RutfU+z43NOJByQfL/FudMkY9Rn1fXqOuu?=
 =?us-ascii?Q?j9xJCbVrs2AB5Wc4LwWjZgIHQeWr8JxvLd2sQIJgqy0xQ2komjO4gz0anTv1?=
 =?us-ascii?Q?Bq5uLXnBTxKdsptvxFHSTcV5QyZRORnJucaLMHLvLkE/G49o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9393881-be6b-4a36-9bb6-08dea78e091d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:21.6304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBQiI7D0Bx/lyjrHnA8hUc1Q0lgp5HGl55hfU7LK2DWT+NMSISvE2EMWG4Gp+VJU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8096

Continue removing struct arm_smmu_cmdq_ent in favour of the HW based
struct arm_smmu_cmd. Switch the lower level issue commands to work on
the native struct by lifting arm_smmu_cmdq_build_cmd() into all the
callers.

Following patches will revise each of the arm_smmu_cmdq_build_cmd()
call sites to replace it with the HW struct.

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

