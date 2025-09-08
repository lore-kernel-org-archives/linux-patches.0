Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7D72FAC08;
	Mon,  8 Sep 2025 23:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757374142; cv=fail; b=uTW4hCde2a9oxC6hBaBFuh9nMABFfULuIKUaHcQU+Kv/hx2o8agWNGeJsT2PfQQwiOrSdoGEg8azgR/MZ/RMv3byQccTd/aZOmDZ2uJvT0vOH4bddaKrrAaBiEhdiIf0ll6oe8KWAVhvkgHm0KuVh4TYNyPBkHqkPePBKlr7awg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757374142; c=relaxed/simple;
	bh=Q839oIDFERa/2DgPFj+jPzh2qVv9BEKdVtJmz0kRGtI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GHQZ7i53m2MOGZcmfWjaMFIOFJ69xC3+GD4CnF51ncTOSexLEO9AyS9x7yWZWT1AkpKdrOl0fRxWrchNXU++Z+VIHMRtXyAS8hpxvWu6vgLLfXvmyMQL2RXqXr6hNrZfmrhHS4orIe4KcBgOGvVf3azq4iRAmgYiMewaksFVXyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sPjPQQbk; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sPjPQQbk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gWMNrmQQDD0D82zruvaTeb60khOn15KQavtOab8Ii889Sfc6UROg3CjreZpyDW9qwbyn+smaDqfdqkvlVMzlwmL+SbGmRBEkXPde2uMees0BvnVWLSVj60H3qM3SmjFW/DLTwl4Ja5wmO8mqqOC5cx3RNUT45Tkb9ri9QyssxdFQBvlWsE0vP4tBx5+SEhSxFJzTuYErxWqvl3wrSEMTfpMysogtY9dPToHnefEzWV8DKCtm2TGylZlUgXf3wy9tBQqyKThG/OZR8i6pWj+MYvVxFAZCUsYbWxMETVS1ZU62oKTqp4ihG0YZAvaxFx9GTM4fuwuJDwmYo4i275GWww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DA5oT1B4sxlJYC0uVhIgAiWhT50ZZpsWdyNXInhKvwY=;
 b=lgqJq/RHKAEq40tT4x/sK1c3vIJsaMMOezpdl0y89H9zHoxzkP3p8E2Dt4YROeDcDXiQe/Gr6uoB3lBRt0Gr2QlHpWLuBhHiRl5kYOIIWeGKiMLi0kkoyrJOXS2o7FqSYJTL28ewQKcZ5DwowVzBQlheP+iTeExbuGmmrSjCPNX8bwhc066eYiX5a95HPEeTB36OCxyGRsDd7vPPijwprYkp6XalGHYAFfdkwtLFfpjj9Ca0FPfkfdjpSx+oBlJDpfR+YXknNtmtynG1szih3exXVVORkEjLSuPLs171JzNFA+0yoAONx+QiMg/E1aoIDmbxwtuGkcPxyHKm2Gm56w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DA5oT1B4sxlJYC0uVhIgAiWhT50ZZpsWdyNXInhKvwY=;
 b=sPjPQQbkAsKbGv2/l8oTyfGUtBI/5eTuQsu0NCCQ/fATmZDln1J5yx9mGo9A6Im+vXKBfi21eEMEs/z7DyGxWoO3yQKzD3i+L21S6E3WJKBUnfgv09JIugf740nTSMPZZKb5P82/UcCO7QUgPHrrBYOEaPqX5T9xZI/BYce79pYF3H6Nr26LiV4AhCdlTO1INyA7Vivf84F6/mWuf6a7c9Kg/rdNsn2vtAuDiMb42HkpAtxpoW0RqyquVWTekmd5WuOBfgrRiwQRgLPbuwgTiAres/Bkf8Pmgk3xECkGV15ywIbeGkTa6LpPXgZgJQStjUEynQcTKxnrQLpckghrxg==
Received: from BY5PR03CA0012.namprd03.prod.outlook.com (2603:10b6:a03:1e0::22)
 by MN0PR12MB6295.namprd12.prod.outlook.com (2603:10b6:208:3c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.30; Mon, 8 Sep
 2025 23:28:53 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::4d) by BY5PR03CA0012.outlook.office365.com
 (2603:10b6:a03:1e0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 23:28:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 23:28:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 16:28:38 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 16:28:38 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 16:28:37 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv2 0/8] iommu/arm-smmu-v3: Introduce an RCU-protected invalidation array
Date: Mon, 8 Sep 2025 16:26:54 -0700
Message-ID: <cover.1757373449.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|MN0PR12MB6295:EE_
X-MS-Office365-Filtering-Correlation-Id: a542b3db-2c77-487a-0de0-08ddef2f78e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VDgrxj5vPh/f/fpyNosNx/gkWD+oAlpBt7y4MYWi3R5dJQSRLHzJ8zEGYpo5?=
 =?us-ascii?Q?ISWL0KyXmUo0PB0dMNOmARnuxzImkjr9+7DQ/RM6dx7WnE1hK3FvKcIj0xj6?=
 =?us-ascii?Q?vzN1tNnl+B/fH8Qx8P8bVyN0ukofev8X854vfMdKRWmRxNO1Sb6Vt12XMvPh?=
 =?us-ascii?Q?xnprR9U04eHY8FryH+/VeEsF39ZcFb0mSwIYi5xG7JfQzxZLpnGlagXIoGF6?=
 =?us-ascii?Q?86nWO2B05tsPffTdbjBdKG+XrU4MoUdC3XdDpLlBx0lolfT+DOub2ZvH+fvI?=
 =?us-ascii?Q?YmhBWB1BoYHHFxQowraFTj7UOoGdLGzLMPB28WIRj/0J7awxwtu8nqnDmHlq?=
 =?us-ascii?Q?F2NDYgyumH1FqwreHwktBjq2Sm8bUJSxM6BgJ9hTVLx7GXhtmUVq15d0f2f/?=
 =?us-ascii?Q?aLPBQIdUwCW6d6ZM+TaSD+vRlpUYB6/dfy6UaPa03Ds4b3t21+hoI7SJqhkO?=
 =?us-ascii?Q?iJntIluzcnXXsrLKhCRUQpU61TVPSjKfnO5khRPLE2BqCpnLUVWlxBSPEvjB?=
 =?us-ascii?Q?i+HxlmQf7OEYo/KIbX3qhTnmWnjktQg5RBPqkFatOBdAtpAiQX4+d7Opfx0M?=
 =?us-ascii?Q?xpqxWbaYwmeXXnoKr6xKddE8RuZN8t+stcnB3ltYqV+v2ZhUSO+KHotxPyE9?=
 =?us-ascii?Q?z+d6lxmYpAK2ITcIPSzmxTn+BNdLkVgHj9z5kzthuDQVV0cIDViGnp5Ukx2A?=
 =?us-ascii?Q?djrB4YBNJKuwXNoMDYop+z1m/cis3UzSRzXtGPQZcNpNoypHQvquWXeJGN1S?=
 =?us-ascii?Q?VcqQKhBV+F8ULfy0o4C+9nMvtwVzr2wvSAVq7oHl4nBMvDrFviE2wr8IIcSt?=
 =?us-ascii?Q?NlEIC8k5jTMMhzQDJyNJl/WiA46yEcCeF9Spsh3/LEnGGNyFPSJiGpe0gbcj?=
 =?us-ascii?Q?kr4I4TmdNDrIYz0qGu9axqflkjAJynmWT8Vlxi/kk6j4eb6eC0uXKz1lxMGw?=
 =?us-ascii?Q?SW/QRexciD7vmrCxhhLSYycFrcS8kMTpTrjxyyQJhgTiadHln3c016G3cjLm?=
 =?us-ascii?Q?cMY/pnbLby6IWTnLKqNX9v0cxp3iBb/Dt8lTCas7beQc1nM8tKYtI3aF2eaU?=
 =?us-ascii?Q?aGQ2DSolPO79/99kl9m6EBn0lYzf19lDlHVKjKpXBN9uMSBn0YkX9pUOuSZ/?=
 =?us-ascii?Q?4h2LIwp281pLSK0u952j+ipQJ6oY+f+VyHk9bUhuJTaAAcUomNDFpHs86eUQ?=
 =?us-ascii?Q?xRGcYPPCZu3bOWay8UrCKX5Aj4sbjmgcEVugVZHwjla/g0Dy8LSgBNADJQTf?=
 =?us-ascii?Q?KmvTLk2+GUmPAZJ9RJhy2IcEbFBAcCNDftmDEUBhNOtaIvpXQCinXytsDYCB?=
 =?us-ascii?Q?YmTtyT5iFmlGxz3m64TZavyrzmitw0dt28n9Qiyuygg2LTfAfxKHinA8yVnp?=
 =?us-ascii?Q?ADe4cFQccLl5J05LUjiCzJ+ifKgLV33vQV0jHwbFLXzt3wzkkXHxSU+/W3tq?=
 =?us-ascii?Q?yzY1EVeu1WIwLlXlQcnICNd7XLRTc80W+Jkm7BpyeqZBspxHz9WGMQgFs6Mh?=
 =?us-ascii?Q?KfWzVXyFnwpOHsElmL0zJqixL6cqkt+oVGbJULR2U1wgAEE3QautlLo52w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:28:52.6244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a542b3db-2c77-487a-0de0-08ddef2f78e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6295

This is a work based on Jason's design and algorithm. This implementation
follows his initial draft and revising as well.

The new arm_smmu_invs array is an RCU-protected array, mutated when device
attach to the domain, iterated when an invalidation is required for IOPTE
changes in this domain. This keeps the current invalidation efficiency of
a smb_mb() followed by a conditional rwlock replacing the atomic/spinlock
combination.

A new data structure is defined for the array and its entry, representing
invalidation operations, such as S1_ASID, S2_VMID, and ATS. The algorithm
adds and deletes array entries efficiently and also keeps the array sorted
so as to group similar invalidations into batches.

During an invalidation, a new invalidation function iterates domain->invs,
and converts each entry to the corresponding invalidation command(s). This
new function is fully compatible with all the existing use cases, allowing
a simple rework/replacement.

Some races to keep in mind:

1) A domain can be shared across SMMU instances. When an SMMU instance is
   removed, the updated invs array has to be sync-ed via synchronize_rcu()
   to prevent an concurrent invalidation routine that is accessing the old
   array from issuing commands to the removed SMMU instance.

2) When there are concurrent IOPTE changes (followed by invalidations) and
   a domain attachment, the new attachment must not become out of sync at
   the HW level, meaning that an STE store and invalidation array load must
   be sequenced by the CPU's memory model.

3) When an ATS-enabled device attaches to a blocking domain, the core code
   requires a hard fence to ensure all ATS invalidations to the device are
   completed. Relying on RCU alone requires calling synchronize_rcu() that
   can be too slow. Instead, when ATS is in use, hold a conditional rwlock
   till all concurrent invalidations are finished.

Related future work and dependent projects:

 * NVIDIA is building systems with > 10 SMMU instances where > 8 are being
   used concurrently in a single VM. So having 8 copies of an identical S2
   page table is not efficient. Instead, all vSMMU instances should check
   compatibility on a shared S2 iopt, to eliminate 7 copies.

   Previous attempt based on the list/spinlock design:
     iommu/arm-smmu-v3: Allocate vmid per vsmmu instead of s2_parent
     https://lore.kernel.org/all/cover.1744692494.git.nicolinc@nvidia.com/
   now can adopt this invs array, avoiding adding complex lists/locks.

 * The guest support for BTM requires temporarily invalidating two ASIDs
   for a single instance. When it renumbers ASIDs this can now be done via
   the invs array.

 * SVA with multiple devices being used by a single process (NVIDIA today
   has 4-8) sequentially iterates the invalidations through all instances.
   This ignores the HW concurrency available in each instance. It would be
   nice to not spin on each sync but go forward and issue batches to other
   instances also. Reducing to a single SVA domain shared across instances
   is required to look at this.

This is on Github:
https://github.com/nicolinc/iommufd/commits/arm_smmu_invs-rfcv2

Changelog
v2:
 * Rebase v6.17-rc5
 * Improve kdocs and inline comments
 * Add arm_smmu_invs_dbg() for tracing
 * Use users refcount to replace todel flag
 * Initialize num_invs in arm_smmu_invs_alloc()
 * Add a struct arm_smmu_inv_state to group invs pointers
 * Add in struct arm_smmu_invs two flags (has_ats and old)
 * Rename master->invs to master->build_invs, and sort the array
 * Rework arm_smmu_domain_inv_range() and arm_smmu_invs_end_batch()
 * Copy entries by struct arm_smmu_inv in arm_smmu_master_build_invs()
 * Add arm_smmu_invs_flush_iotlb_tags() for IOTLB flush by last device
 * Rework three invs mutation helpers, and prioritize use the in-place
   mutation for detach
 * Take writer's lock unconditionally but keep it short, and only take
   reader's lock conditionally on a has_ats flag
v1:
 https://lore.kernel.org/all/cover.1755131672.git.nicolinc@nvidia.com/

Thanks
Nicolin

Jason Gunthorpe (1):
  iommu/arm-smmu-v3: Introduce a per-domain arm_smmu_invs array

Nicolin Chen (7):
  iommu/arm-smmu-v3: Clear cmds->num after arm_smmu_cmdq_batch_submit
  iommu/arm-smmu-v3: Explicitly set smmu_domain->stage for SVA
  iommu/arm-smmu-v3: Add an inline arm_smmu_domain_free()
  iommu/arm-smmu-v3: Pre-allocate a per-master invalidation array
  iommu/arm-smmu-v3: Populate smmu_domain->invs when attaching masters
  iommu/arm-smmu-v3: Add arm_smmu_invs based arm_smmu_domain_inv_range()
  iommu/arm-smmu-v3: Perform per-domain invalidations using
    arm_smmu_invs

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 136 ++-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  32 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  93 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 891 +++++++++++++++---
 4 files changed, 976 insertions(+), 176 deletions(-)

-- 
2.43.0

