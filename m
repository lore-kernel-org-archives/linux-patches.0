Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011055.outbound.protection.outlook.com [40.107.208.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E8E2C11CF;
	Thu, 18 Dec 2025 20:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766089661; cv=fail; b=A/xt4f98SHC58CYSZXW3mWjyDV9MXHTadyxK7ybzXREDGXL3GzLctdPkABWu531DhQ/fiwTfegcbchqWumb9fX1He/v3pRnqrnJeFBsgoyUjvamV3090riy4XsVhn90bnJxaWBldHChGEZAM+t3qQJOpUFNceWNIwbcsXk7vTbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766089661; c=relaxed/simple;
	bh=6cJEwQMJrnanHOHMXo45R/crw6mGVzUpWbS0nPV79Hk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fe3Z26QmjUsog+3sYL7fW6b9lOL19otdvU2eA6BDNsPLihuM9t6iizB0bPZyvbeSyf4MLS7zYT/Lqmf3d6wzoXAjxx/bgdCGreEGt6vgtUyJavUfeOIOQi9zXQ7G9ETUgN5mxFjEK8p8gqMUuoPXamQaRqM2A3jvbt9wEtP06U8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H4sPvuHz; arc=fail smtp.client-ip=40.107.208.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H4sPvuHz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qh38SZ9AAe/NN4NyQUraQk8rF2n6CM/CaszR4zXeXj6GNv+iMS0NUJdSJdX+LEfW+l/x49zm9c2AadICbDndfExiElWORYCTVZcqDd9/nrDfVXSgx6Yrf0ViATbBNqmq0lmOJOof5SGQqgE9H15MXdyQCYkYG+Dfc2F6KobKnu76TmZzRGzJOFzt4Jqd395ItFnMLpKCeHcANbGSvlqeMZYON0IpPOnQ2Kbu/sPOOyXMZOgewSI5em48w1MlILaotqFGpvZezYjY0VK3j+zWmxZYgnmHgszrYJwRn8QBNaFuiSgRgv9/aJ86GPqEBBpmJR3RZEcWXNRu/6JETl8u1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0561PgQb5HR40S1otBtoBRGX4GahQd9yeoHcfCUV2c=;
 b=Y2pqrgkzvccoHEUJ1gFojVKUm+MAbEvWOLMvEEwZ01hF7Q1NVPQRazc8aTL6tjQKWZYb1/Rvx2qKEiJK2Qumb+vp/e0jEgptKWYzZS+Kahnngb2OMNh7cE5HNiM91oQFK+MPLwUxqNNXvbL8YML2wvt3J9IW5MM8eAExCkCpVDpIXx2l2iMriIQ8Dpg5V4e/UHS3IFLDgdbinLY1AzAn58CGR9pfSCN4uhHLk59B6ezdRjzhK77Ex3GlLLjuij06/EYIG+mou0llxO19EdF7FgQIyTg0T3D/gripg9yVyw9cqMcwwexdCBttOxn0EuwygAkU7SWraitsZ32caxIAnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0561PgQb5HR40S1otBtoBRGX4GahQd9yeoHcfCUV2c=;
 b=H4sPvuHzzjcIEitBjFHtH5AOv02ElBNi7Zyms+QQ+l5+FU3yDGIr3dBPum/ZuI3tKgVRPLfjA6v/l4YiMnTHwnZmKsRBhg2ir6yPpSqIxfpnR6490Bpp2STSS39S+u1dva+iPAWiTHnbj2XDyr87VUs4E+86AhltNAAvC6ZXXGS9+4Qyrf1VZlMyt/5IAEJ2j6D8kPwyeLYrgnq0Sx55fllPOFDwm5BcHNmYzvz1zOFmhxRBgGYbN9Iim8R8xE5azGbjhP8hO8F8uQp6LEx6FrVXs/8ESylfHxr3AwY18pvaLIf8MVI2tVT+6G7JwuVMZLQPFmkyf2qZwtNO/ss7VQ==
Received: from CH2PR08CA0007.namprd08.prod.outlook.com (2603:10b6:610:5a::17)
 by IA1PR12MB7688.namprd12.prod.outlook.com (2603:10b6:208:420::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Thu, 18 Dec
 2025 20:27:29 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:610:5a:cafe::cd) by CH2PR08CA0007.outlook.office365.com
 (2603:10b6:610:5a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Thu,
 18 Dec 2025 20:27:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Thu, 18 Dec 2025 20:27:29 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:13 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:13 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 18 Dec 2025 12:27:12 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v1 0/9] iommu/arm-smmu-v3: Share domain across SMMU/vSMMU instances
Date: Thu, 18 Dec 2025 12:26:46 -0800
Message-ID: <cover.1766088962.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|IA1PR12MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a20b6c4-c4f8-49da-732d-08de3e73dd82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|7416014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9CsbEoNflj28uTVqAQYP0h7ySqxhOqxSv53eIGopUPeBKlj8C2mn+U6bW5wc?=
 =?us-ascii?Q?UJ+3jNd4/uSpVGiNI69RM2D1v2NOfnRoGm97DKR6HDiIcJrsXUsHsgC0KdeX?=
 =?us-ascii?Q?HM9dZYMtsMiwCABFh4NeBscrqrOa1AKzfdnK9JmFPjCi/K6M2rlFU/2O3Ffp?=
 =?us-ascii?Q?jQP1fniog5hyj90lQkF72jl7pyCkWoLgF/w+MLAtRvvSU6Y+GUlDpt6H9PVx?=
 =?us-ascii?Q?ZNBz+8b7Ip1jxbzAss5XGPmNaM9KXkpbdvMoe3ucv9iG09YeVU9p4yJO22pE?=
 =?us-ascii?Q?gp3cWrYqgRGAqUrdxLGYnqCmBuCiIDyvHuA6pWkg4FOV0X5xeFKkK7QZd27u?=
 =?us-ascii?Q?9KcLFZiUOJ6vkjApgBp5tP7JLB3hdb2Gu1w+ItszxgoD78G48GfaRtXXBe7p?=
 =?us-ascii?Q?xTalaanzdaK9WbPm8iFwD6DwmWKJDhmyp6wEob0r+V1i20YqVh8bxbhuUURR?=
 =?us-ascii?Q?HvZ6xvyfqFphjWBNOotqIXDnvUX9ERN/18Jg28+OF+LRzcSul/6iQ7mNFQrX?=
 =?us-ascii?Q?iuEzWauoxEmoXkIjBh9X2hOu0g1VE8OQUypZfPkDS10r+V4g9K+GXUjUsrRU?=
 =?us-ascii?Q?FX4QnqFskvr+9T0vfAr2DQbws/EofKaP70bGk+huWZYToN3OcicSyl6GPI71?=
 =?us-ascii?Q?NN5tobhS4WGgY/0UeCzKg4u1VpnWt3sWo0Io3i6RqdZ9KzfahvyDVpv1UVJT?=
 =?us-ascii?Q?K1yMdRsd5WojrVf9Elvv+B8DMCEvlX4JL3LsQYkXv6o3WruuEdFS1NktQw4D?=
 =?us-ascii?Q?ty3pbOYaMXs38BGUA57TRT5+PSQ7X63tQl/j3Eddbm14NZyWjP0B85q/3NM6?=
 =?us-ascii?Q?V1ncixb0DgI0d6XyScxLyTp9dD8WVIcyVK+Y2RxhrXO61iOYRmeUOqllkg/9?=
 =?us-ascii?Q?+7ahQshgGFFR1gxJ8bLv2QfuKVzoXftUDX0YTuEMMSaeEqoYLvqZgPLag62h?=
 =?us-ascii?Q?kpbX0dHNIOopUUx0YELL8KyWA0Yr6X/AOc7KJhM/hb7J+e2Y3d4sbeDgKLvI?=
 =?us-ascii?Q?iF4q0WghcJq5echTPfUodMj/d0S5ndmws8xgWCozViMZPTYm8Dx9+bkFhwC7?=
 =?us-ascii?Q?JNo+adThsVQkt0kYvd9vpBGiMnBsa7GBER4qQlyIFTLJ2LvogRPywXeCzLGz?=
 =?us-ascii?Q?wR3AwW43cvip1AgayfjOpuBoLW7IxkL1gePiGxDSLdx2EznI3Fzxey09IQ3I?=
 =?us-ascii?Q?r5R5sjvDjvDxHXt1g7IDlLBt/TINMe+9S7HrGS/LM1DCKkH46eLaygoZ9bPe?=
 =?us-ascii?Q?MnZa6Npb5hhYrty7UeIJw8+tGPzUGsE/dK1DiMNXr1OtyBESDGjv2uNnR9Zj?=
 =?us-ascii?Q?v61o9fCqe4e7S+MJyWvfii4CMuPysSh3HjphKTPW5pP8g9mWk0RLaXPNSUNM?=
 =?us-ascii?Q?E7Xm+k92qlwPEF5p2be8dNfpLobWQrd9BCv7HRChAJWKYtujr2P7P0yDv3rO?=
 =?us-ascii?Q?+tZX2L0OWyMtPUDBcXEEIchZTb6M+x81ddMLyW9k+FpnvIdz/dXhf6cDO/ox?=
 =?us-ascii?Q?vrJqkGtwYnZgIxFyv5vE0feh1yByeJDX6IEjoPLve0EqF0HZbZ7sKEt1c6U4?=
 =?us-ascii?Q?5dowPXeQpONZ476Q1QBH7UHQLGaGKNLhMUn+WVeP?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(7416014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:27:29.0177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a20b6c4-c4f8-49da-732d-08de3e73dd82
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7688

In a system with multiple physical SMMU instances, multiple devices can be
passed through to a VM. Currently, a VM would allocate one domain per SMMU
instance that might be shared across devices that sit behind the same SMMU
instance. However, the gPA->PA mappings (either an S1 unmanaged domain or
an S2 nesting parent domain) can be shared across all the devices that sit
behind different SMMU instances as well, provided that the shared I/O page
table is compatible with all the SMMU instances.

The major difficulty in sharing the domain has been invalidation, since a
change to the shared I/O page table results in an invalidation on all SMMU
instances. A traditional approach involves building a linked list of SMMUs
within the domain, which is very inefficient for the invalidation path as
the linked list has to be locked.

To address this, the SMMUv3 driver now uses an RCU-protected invalidation
array. Any new device (and its SMMU) is preloaded into the array during a
device attachment. This array maintains all necessary information, such as
ASID/VMID and which SMMU instance (CMDQ) to issue the command to.

The second issue concerns the lifecycle of the iotlb tag. Currently, ASID
or VMID is allocated per domain and kept in the domain structure (cd->asid
or s2_cfg->vmid). This does not work ideally when the domain (e.g. S2) is
shared, as the VMID will have to be global across all SMMU instances, even
if a VM is not using all of them. This results in wasted VMID resources in
the bitmaps of unused SMMU instances.

Instead, an iotlb tag should be allocated per SMMU instance. Consequently,
these tags must be allocated and maintained separately. Since ASID or VMID
is only used when a CD or STE is installed to the HW (which happens during
device attachment), and the invalidation array is built right before that,
arm_smmu_invs_merge() is the ideal place to allocate a new iotlb tag:
 - when a device attaches, the driver first searches for an existing iotlb
   tag for the SMMU the device sits behind
 - If a match is found, the "users" counter is incremented
 - otherwise, a new tag is allocated.

As ASID/VMID are programmed to CD/STE that belong to a device, it's natural
to store the ASID/VMID in the master structure.

Given the above, this series reworks the driver further:
 - Add ASID/VMID allocation/free ops to the arm_smmu_invs data structure
 - Store the allocated ASID/VMID in the arm_smmu_master structure
 - Replace cd->asid and s2_cfg->vmid with the tags stored in the master
   structure, when installing them to the CD and STE
 - Deprecate cd->asid and s2_cfg->vmid.

Finally, allow sharing a domain across the SMMU instances, so long as they
passes a compatibility test.

This is on Github:
https://github.com/nicolinc/iommufd/commits/smmuv3_share_domain-v1

This is based on the series "Introduce an RCU-protected invalidation array"
https://lore.kernel.org/all/cover.1766013662.git.nicolinc@nvidia.com/
So the whole implementation follows the path Jason envisioned initially.

A earlier effort to share S2 domain can be found:
https://lore.kernel.org/all/cover.1744692494.git.nicolinc@nvidia.com/

Thanks
Nicolin

Nicolin Chen (9):
  iommu/arm-smmu-v3: Pass in ssid to arm_smmu_make_s1_cd()
  iommu/arm-smmu-v3: Add alloc_id/free_id functions to arm_smmu_invs
  iommu/arm-smmu-v3: Store ASIDs and VMID in arm_smmu_master
  iommu/arm-smmu-v3: Use alloc_id/free_id ops in
    arm_smmu_invs_merge/unref
  iommu/arm-smmu-v3: Install to CD/STE the ASID/VMID stored in the
    master
  iommu/arm-smmu-v3: Use dummy ASID/VMID in arm_smmu_master_build_invs()
  iommu/arm-smmu-v3: Remove free_fn argument from arm_smmu_invs_unref()
  iommu/arm-smmu-v3: Remove ASID/VMID from arm_smmu_domain
  iommu/arm-smmu-v3: Allow sharing domain across SMMUs

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  47 ++-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  17 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  27 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  24 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 307 +++++++++++-------
 5 files changed, 265 insertions(+), 157 deletions(-)

-- 
2.43.0

