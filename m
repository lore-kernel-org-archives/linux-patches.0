Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010018.outbound.protection.outlook.com [52.101.193.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CE534F279;
	Thu, 22 Jan 2026 01:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045100; cv=fail; b=KwK27Vh8kY4OBzGuASSA6Rsrx975SJdrWX8ClrZliMrZk9Blwuq5jePV5E1WqYrp0vFMsAuTACxZriIolktORyrmsEjP5LFOQIaIGllyjGxewtBjRT3Q8369k8IoG0DmXbTe89+sPbM9Gyf9s3jkC37pu+rROwWxVBd1jjyPzv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045100; c=relaxed/simple;
	bh=h7qdyUSDVrAJlxQnYp0YQg1AK2tbYjOFseje8Hi2WZc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tNWFP4U+1LsdK7yQsHV6in/SLck3DwuzIpGnVDeHx+cfhitFsALDbbTHa4SF9R0zINwa32G5WSNl9aST2OSFL2UEQfPrgwAMjX5wiCvilWekP/4AFOxnQjwfzHFIb4pGumvZc1Y36xk3nuhi8jZEAMOih2N0wHyARtUhc9qOGVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jGrPuHeD; arc=fail smtp.client-ip=52.101.193.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jGrPuHeD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P++V6UwwgsCJo+xVG/bFCzL1uEIvYK/P9DuCHAn674npewmevCsVTE5GKYmqpFKYyWhplBBpuCCPxfXHajsBZ8HxObBs4M0HXIY65l1Vcbk5LCTVBWsgPC9a2dnnAG07FSrNhxZk2N4ziutfCksVjpgURXHMajPkms8XTzBovRGF/+VcwrayU3ZrF75z+CYw9DQ71/t5KSfNJROK5y97ilrB6ROa9LRg0bEbkNk8vuSCuKl5UKgyKVSUkZDyNiswezn8KlAUOGi9Jx804cxllKZ7cjXOvHT7cwMyGyvzT8EkrKp4Thy0kf/VsqdqYTOPmExMK4CmtRbIFzNwcVZ2jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoHGXEZqHJv+HodEqkbH6xmAHw76g4B+3LcovDVRA8E=;
 b=k33DGfvCefWaDx2JoqsfR1rgpqZ9tAvTe+/P3UuzeTp9/YPF8Pu6gwX9JJeacGkufXdGEj+PH74xyrwJh5MRExtonWl/1LN9ap4z6QyaTLUstN6bDi3c3y8N1izXpMxp8AOEHmWmYFlOJHMpeSl0Qv2UPkAXDv/jXlQGWVD57Y+K8kPyZr9tNFXOG8E45wAarVlgX1VAZhfu8ZGccIthB5yGQDGnvIJddhmPXMD+gfVFf/Ln1HuGzrukQq3q1teYH9H+rvGh4QiLVK9Ywd05OEYclXCoQmDmFD9FGTHy8JmxtWotKWUQFnYvLZfzX+Z5gg3TuCMiYLwywVPT3vHVkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoHGXEZqHJv+HodEqkbH6xmAHw76g4B+3LcovDVRA8E=;
 b=jGrPuHeDzidbxV39jV0EnjfNOtYmXlsaZa6n+aiN3q2NZPi22nhIhUzwAg1b1MsV95ceELa52LmjHBMCYL2LFzm0rVKxCQnrdNfQBr05Bx1utozswv3asqeQ7DlT3Mf2RBbbZj6jC5KRFqJKwDNo9OfQN8ginsqPKT2rk9zMM9aMXQX7mn3JDwVXvm0nfERFd0ZRSddl4GBjbyOiDiP8ZNvjbtEmkuyAeek/93wtYbFZtIy0NKAHqiOGdHkARAehXHSG4CLT2MGxFG6tVUV22T367lvBAn2MKyOiU86eRZZiQfqNSZXQPtMgX8T39OzdU9JnG/9ALovKjoGoiDtmtA==
Received: from PH7P220CA0039.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::26)
 by DM3PR12MB9389.namprd12.prod.outlook.com (2603:10b6:0:46::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Thu, 22 Jan 2026 01:24:44 +0000
Received: from SA2PEPF000015CC.namprd03.prod.outlook.com
 (2603:10b6:510:32b:cafe::81) by PH7P220CA0039.outlook.office365.com
 (2603:10b6:510:32b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 01:24:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF000015CC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 01:24:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:37 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:36 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:36 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 00/10] iommu/arm-smmu-v3: Share domain across SMMU/vSMMU instances
Date: Wed, 21 Jan 2026 17:24:18 -0800
Message-ID: <cover.1769044718.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CC:EE_|DM3PR12MB9389:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c7f46c9-1824-40c6-a98c-08de595505ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j2Q066qucWRi/MiVYvcvLG49l368t4wIUJePwW1QrvFeyXAcRDpF8i1TAsAC?=
 =?us-ascii?Q?tTS7LTITnyZlpBQ1wB1G7VSPIcTz7j+PNK0pGsfdNeXhZd9/pikW5AHNRjU7?=
 =?us-ascii?Q?yN9D9t+lXtmMVPIFxubuwInV/M6R19R1z6BJ2v+TAChkYhqJJjKdrRV3esm2?=
 =?us-ascii?Q?ihXV11enu/h4+FJogTuoPL33k0cBPORQGnsV65R5ZJ4IXpEKuBrXvlhiqjxw?=
 =?us-ascii?Q?TOujznHXX2oi9sHs+qP47EvsjgUsAdKse+CvBt3DJebAjXwF76AoV9yYFI56?=
 =?us-ascii?Q?iQ9FwW31wvwAFJzY46FrWr/7pO1HRprf4IYuN09Lpe0kLrlWn9B5o3ZKdcu9?=
 =?us-ascii?Q?KD6kqWUKbQM/LJAaCWYcJOjFCshFroaG9Wd+2RsLDaeh0lkffX33JRzJqaqm?=
 =?us-ascii?Q?Rdm0pBCetIc4XPHA+ojYfJJ+ijeFLmz4uZHK5igqFeNte89q9f47e4UMVTWo?=
 =?us-ascii?Q?WtvBjD+7MdN8l7eRcK9Hd54cAB9txc0iheMVKMochwPU+DT3rZU9cq5VyvxR?=
 =?us-ascii?Q?rK1eNh+AxkS9skbnME9DAsIczSgPnxA5NyBrYNPJ1YpItj8YJv4ZN0bKuqU5?=
 =?us-ascii?Q?ntqD1MWEjRU2gMFIz687siPWOmOVP4C6AyvlQwcF4W75uhTywZKCR1v/fK+i?=
 =?us-ascii?Q?5RZfBDwJ/n+36mOE3GksVj1vH40xDRDZpJPdwv4zYxP6wK+jRNjHVCntO7IS?=
 =?us-ascii?Q?x4RGZ3ivzbBXrQutKHFGQef7gZkVhA1CqFpH/on9AWEpb7bH5GpSpZeI0s4X?=
 =?us-ascii?Q?lTzyDEO/ib1VbaX2XLbmc9cu0mKSt5AMMRSo9N8bDkrpaGWA3Pm4MeAipsMM?=
 =?us-ascii?Q?mEpx/SdHOMVy1A3HWFLwFWa+HZTAc3nAc7zteY4GpaAu2cfGTHgQ096H7dOf?=
 =?us-ascii?Q?Ucf/3RfBTImuBe0r25K5ujUMJtSaHe9Xckix88rnVId8bXzXYrlCRcFFvE2t?=
 =?us-ascii?Q?ZNrlmLlLGBhJE9iDV2ZF3dlSAr11mJ8rnEly6JAy5yOt42NQmDUkiRk8u9jP?=
 =?us-ascii?Q?SXOgdQLWhlCfk6XJyuOotCx/4uP4tNscVA6VKadiyzA8H6QYYA0MppdSul5Y?=
 =?us-ascii?Q?1FaSXdCk2UYypgyF9lxVRGdF1tJH+eR6DZaGNo5/B04RKtuDX6BPJAGdvKrS?=
 =?us-ascii?Q?DZcczSQinCyAWJGqcQnSp2Epa8QT+BccoipH+1xmSJv5eZHf03VsmrHQSYeE?=
 =?us-ascii?Q?DW3ipBQ0jchRBojzNm5zzAmBMzP+zeMchMh5D6KqTLOsmRlb57uHpT3YV4yC?=
 =?us-ascii?Q?DcQkagikHZLfTHbYKRJpr5c5+415BnGma72k5YB1Nx8tOgrSmzwMJHvj0NMI?=
 =?us-ascii?Q?8aQNW9VE36T5gK3D/jHAiKbLiJjEgYgkIY8fKuVr8BzSFt+5ZTB4stIB86Gh?=
 =?us-ascii?Q?PrH8exkmwg/bkcTphpHZKxCU/l/c6QBruAez2qbugIscmH1lCdgZ6f2e6CY4?=
 =?us-ascii?Q?YtPtIVszSYI1u7olJvO/PpGP9TiZNp2uyeUUAkZoDH+BLbYxisaGFyafHDN5?=
 =?us-ascii?Q?YWwV3qwob83aiZT5/I//oA4/gzwCuCWM9R7jvfofZTA8yoeVPOYocu2BpbG2?=
 =?us-ascii?Q?zisyuNNh2wMsnbzlwR7h9HoopWOh/V75eDdL/4eWC5DHUAiMlWwa7GiqLyFb?=
 =?us-ascii?Q?6CH7rgYpQf5g166+qpAo9jjaJ1rD0zfEScM0mVDf/bYBgWfOp4jn33kttRBi?=
 =?us-ascii?Q?xpsDOQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:43.4130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c7f46c9-1824-40c6-a98c-08de595505ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9389

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
it is ideal to allocate a new iotlb tag before arm_smmu_invs_merge():
 - when a device attaches, the driver first searches for an existing iotlb
   tag for the SMMU the device sits behind
 - If a match is found, the "users" counter is incremented
 - otherwise, a new tag is allocated.

A nested domain case is slightly unique as certain HW requires the VMID at
the vSMMU init stage v.s. a device attachment (to the nested domain). Thus
 - allocate/free a vmid in vsmmu_init/vsmmu_destroy and store in vSMMU
 - introduce an INV_TYPE_S2_VMID_VSMMU to separate it from a naked S2 case
 - retrieve the vmid from the vSMMU during attachment instead of allocation

With this, deprecate the cd->asid and s2_cfg->vmid from struct smmu_domain,
and replace them with the iotlb tag stored in the smmu_domain->invs array.

Finally, allow sharing a domain across the SMMU instances, so long as they
passes a compatibility test.

This is on Github:
https://github.com/nicolinc/iommufd/commits/smmuv3_share_domain-v2

This is based on the series "Introduce an RCU-protected invalidation array"
https://lore.kernel.org/all/cover.1766013662.git.nicolinc@nvidia.com/
So the whole implementation follows the path Jason envisioned initially.

A earlier effort to share S2 domain can be found:
https://lore.kernel.org/all/cover.1744692494.git.nicolinc@nvidia.com/

Changelog
v2
 * Add arm_smmu_domain_get_iotlb_tag()
 * Drop asid array and vmid from master structure, and get the iotlb
   tag in the smmu_domain->invs array
 * Introduce INV_TYPE_S2_VMID_VSMMU for vSMMU type, and separate the
   nested attach case from a naked S2 attach case
v1
 https://lore.kernel.org/all/cover.1766088962.git.nicolinc@nvidia.com/

Thanks
Nicolin

Nicolin Chen (10):
  iommu/arm-smmu-v3: Store IOTLB cache tags in struct
    arm_smmu_attach_state
  iommu/arm-smmu-v3: Pass in IOTLB cache tag to CD and STE
  iommu/arm-smmu-v3: Look for existing iotlb tag in smmu_domain->invs
  iommu/arm-smmu-v3: Allocate IOTLB cache tag if no id to reuse
  iommu/arm-smmu-v3: Flush iotlb in arm_smmu_iotlb_tag_free()
  iommu/arm-smmu-v3: Allocate vmid in arm_vsmmu_init
  iommu/arm-smmu-v3: Pass in vsmmu to arm_smmu_domain_get_iotlb_tag()
  iommu/arm-smmu-v3: Introduce INV_TYPE_S2_VMID_VSMMU
  iommu/arm-smmu-v3: Remove ASID/VMID from arm_smmu_domain
  iommu/arm-smmu-v3: Allow sharing domain across SMMUs

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  53 +++-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  50 ++-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  42 ++-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  21 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 286 ++++++++++--------
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |   1 +
 6 files changed, 266 insertions(+), 187 deletions(-)

-- 
2.43.0

