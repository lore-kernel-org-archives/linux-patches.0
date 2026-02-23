Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013016.outbound.protection.outlook.com [40.107.201.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C203783B4;
	Mon, 23 Feb 2026 20:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878530; cv=fail; b=V1EZurMD/g2HWPXkfEvS07xBqYNS+wSOK83hmAQrIiMEOaqiDEqlE7dr0lKO+rIkpmqch45UFTJ1K8YUSTnRAS4beY6XDc25O+EwPRAHlYi32MUi5Hs7ubXJrQsgqGh0r+Lyf4vB/fMeCJtbNz7Oo0C8E+bXaiJlPgTcIOLTVeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878530; c=relaxed/simple;
	bh=ljx+Ri59Zwg/EP89Tv+woXdU1uPxj6SemE3lVk6ZJyg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GlDWPGLA1xVrJBfmMTnFy5IB6pMkw6sLtqVB7+SfuZDEURrCIdtax4mx8BUmpj4eipiyxXe+cDMd1YkQ8TlLLg8ViE32TauUipCPVwYJzV1tWoyS98J/QYmEamLxQCqdjqnpUcaRDxSOmXBFjc2N/kS7C6/DHONrRm4SNkomKQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gFeUzT0Z; arc=fail smtp.client-ip=40.107.201.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gFeUzT0Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=np5xhY/jxyZLpt1JH9n5Zo2UWlpkZ0+DJ+pBDG2O+mfzEI/VxLiUF+hBYXTMPVrAD/8YeXQJmtgaeW06DsJuNuwcocV9uI/vYuLDskDK7w9NWrVYR8C33NaQL0bhFxACZ9IWDjqEmEqpqv2UvlMd49lNVr1+IKaBFB388iBP11pjwXuJl+SpIJ1NJ1Viqa0h5K3+8RBoWg311RAbTVq60A0Uq8awZvBb3rD3mmK+r1n0ZzxnKHmUhFa0M2tr1yKNQiVnMkezMkmNyOJsRVLtz2+JxB28oAKqUSghQombr1l91sCXg+94/ZHk2YnLYPM0rumJJpHLuuDHgD8kdNBdwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2CYuxpCuRJMs49k+wdml7/XrOVYHY7/xCNA+j77+1g=;
 b=ZIuW/r/BYoSGJ1YisajEPdTsS6FlBTbMkq/0DyBLs5xY0I3WOni17ShWdxZiQfZNKeG+8gLKmOuo8MGqvpqUK8mnuUJ1RgZwd4pkKHwgU/10EqgOucuitZ88FghGNFKV1mPoKqA1QIR1dRRh6ulqmDeowaM8RF+UV5IZpz0cLbJ/17napw6MdlBgZM7dEHp7MWLXTgXn+9jnYP/N3OBTK2LO+FJQxysXj3EdsuTdf0hGiE6bpg4xeBR68brGfXujzXxtD2KphzvTEPNS0lfXDTjdqkeHNIWKyzaQDN18wkP+C9IBg/VLYd2cUmI7OxE1Ya/KtBWB8rnAQIURLaI5LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2CYuxpCuRJMs49k+wdml7/XrOVYHY7/xCNA+j77+1g=;
 b=gFeUzT0ZPCRTnGuD8WIE9N7j1aLH/ZsnmxaIwld3fhvrxQpg5EseJ9h2bNCqFtFyxGM9X1juHIMb2roAS8psFFRcf4PYqpqdp3ftH2x0ZK0S17HhpOPXZHgS5tLsKBjY4RcwwhpiSxTwbO5VZIyZSCkaKJNgm9JU1q85K5808Kfnh0M2scR5241zGkhey3KZ0Talny0fwG5VFVrlLCCBtKzQfOzi2rd//kSAGIwn2AKI1uaR0UA6pU0+SyA1qvJlMdpXtNQhDkUAWr6sUnYKnvMo887ujbu2gn/RXPmK3Ryxn5FXH8BmzQxNcN5EeR7/oXXJ/xyJ/ziVzbwEXL29ag==
Received: from BYAPR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:c0::35)
 by IA1PR12MB8262.namprd12.prod.outlook.com (2603:10b6:208:3f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:28:38 +0000
Received: from CO1PEPF00012E60.namprd05.prod.outlook.com
 (2603:10b6:a03:c0:cafe::78) by BYAPR05CA0022.outlook.office365.com
 (2603:10b6:a03:c0::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 20:28:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E60.mail.protection.outlook.com (10.167.249.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:19 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:18 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:18 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 00/10] iommu/arm-smmu-v3: Share domain across SMMU/vSMMU instances
Date: Mon, 23 Feb 2026 12:27:36 -0800
Message-ID: <cover.1771877893.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E60:EE_|IA1PR12MB8262:EE_
X-MS-Office365-Filtering-Correlation-Id: 61437a34-2053-4f66-ef92-08de731a202b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sEImIElLKvtN3M+gb18SpHRS+wzfsUFuvQTc4rc/2BbmZE7+u660NSkmcTb8?=
 =?us-ascii?Q?C8u5YVuR/r1Ljf3MCmPLgWd8tOhJlfT3gl/ji6Cbq4Fh0YUehmjwMsZOHaMX?=
 =?us-ascii?Q?h6ueI/vRlvxwCckvfSqnvw4x159sAEYWU+NFg7KGNdxGQLDbakcBfetKuN6F?=
 =?us-ascii?Q?M27utAkhZ5BS4GbKf9xwv70C3uUeK0rXPs3dbe9uYC7Gflm9V8BQZ1Rc79fq?=
 =?us-ascii?Q?yhIkXQZwPEqB6lyoV+1Do1vuqtGOimZEyoWgmDlnMomr5jmVxO+fq8qCpmZa?=
 =?us-ascii?Q?QyYes5ChaCYckASx13R6z56BO9tmfH0wL9NNLnKj1APxaieF/1xQgecyd/qu?=
 =?us-ascii?Q?AgFtlRZQlSgwW2QODJhult70vkMAllebEcoc2QG4dNZuk67SQU0K+ReC1r0J?=
 =?us-ascii?Q?tADK+U4jBU04DehE+yW1hPwRhcJD2m92AhE4A2le64NwUEgLSp3gquDyVnPo?=
 =?us-ascii?Q?4u/Uz2FTOOq0Vc8Y7MlMM1bZbhJgzXrgmrQn5imT6iqZPxqsXr9edcNdvUii?=
 =?us-ascii?Q?KQIpEUCcY9k2ZjW+CXPq4KjDQX0MUVyCiDgr2g0mCYWQ9dOnS9/+erhEokog?=
 =?us-ascii?Q?jliz9GbI7K2wKHpUSAz+numPF3NQszHXw2qwXJQXWN22fiHw8ZEtuBoMEbXm?=
 =?us-ascii?Q?PoAzjnlg9YhlJp/abSgxqi1rVD9+oAnnRzT2JVCtDwbV/naMMQze045qaaxG?=
 =?us-ascii?Q?W4jZgDi35UX4MRuJF0IkXQONfiBAJf2Vj8zNmyb7Nqdn0ps2giLAzzcF65tb?=
 =?us-ascii?Q?9jkoGQIzIhgnBUkmHmJENS+WLbEdEuyORZilfMT/1CgHiezzzMvjcNf/EkOh?=
 =?us-ascii?Q?7BK7sFasjHxAYq4jy2SeYsP6tCiT3IIFcOTB2tS0eiER3Pj8kSUdoRaX/UMQ?=
 =?us-ascii?Q?Qrhluts3KSvGH6KVQsh+B/7hTiX2XIx1+SsJE83YGS7STawFWJ8jej4irqTb?=
 =?us-ascii?Q?cFkvFC2WckOhuTi8l3qlhyrt/8okkVh5f3w1r4t/MTPG0BucU5wYxdYLPbCr?=
 =?us-ascii?Q?YNHSBS8c4ZDUvbwKec6X8AYjzSWaUeXRVPKhvLyIIfNpKSSJni2xgwOivmYk?=
 =?us-ascii?Q?l4rL7XBoDHTad2Qcu565l0B2BY5HD6qNUPRnSulge1Mj64B6lAcQmemnouKQ?=
 =?us-ascii?Q?+jgxMHJslQGw1XL0ixH6s3nDiYRKoOMBdXC6cAcGZyxj3N/lIorepsTCQeSf?=
 =?us-ascii?Q?lyqcEGQMbiPI1Wxzoli3l40e0A3sCPxIKEC8ntxK5u8JPWDyoSceRFg9bL86?=
 =?us-ascii?Q?bi5bXYuTcb7+ZCTNq0oScwUp/k454wIEGMu1VuRNTptq1P9PxwAUj85KMG64?=
 =?us-ascii?Q?U9rqfpTITuFNwBWav90U8eMcdws8MLzEaXEOw/qQAA8n/lSM02Iww0uA1W72?=
 =?us-ascii?Q?w1o5tLGBbAsWnWK5PwHZEBnPZWn1hZ24NraUoq8QMpXZ8tZNoJsNh411mwya?=
 =?us-ascii?Q?RJoYo3M1Z1OOfDsc5cpkEZGlXr+0ifHPAIIj6K/RiwWRlXDNN7tZtHu32ucz?=
 =?us-ascii?Q?SL6x67Iu6HDYMt7CrZ9k+ODazwYO99+9/fIQsgFGLz8U3Jyi5WWwGFTuv46X?=
 =?us-ascii?Q?g+JJAbg4rri/TWTbOw6YyolCGXMhCp4x+uMMB9hLHmQ2273e8Y/iu6kclwgM?=
 =?us-ascii?Q?En8+96T2rhSfcZQ4Cd4oIb+ahZ/VoIINYcDkPHsmkEj4ubmdelPOHPY4qM/V?=
 =?us-ascii?Q?Va0aSQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pOE1SbgzXqDXLPQtPBLZ0TGgOnh3B4JRxh4dR9LM7dHqwoQKWe2Dcz1djt+5ln2t+ySMWgDpm2nLex8MvmHKFUERlRmjMKXUhbVTpEOvnHuiSgPwfFRc+cx4NXZ4/OtytXUnpfvkllhEOr4g1oJ8DcK44VEOT3wGc5d7IJIMdAwgm/+S4VzQCyoQFoYmapSO/zM73S9FpeFyX3K1fqmQ4ZmdJZU3rk1DuZJ4gYJGjeXy+gRyXbC74E0MUpYV7rkajq1bBHfsWiiIB9G53E5ltjY/wWtDru7+GhyxpF/XXec65/X5Xa+vqoKhbzfLx9DdPl77QGmSujw6fG/4ZXfW+dtWbLfKPc0vGnlUQHtMIiSKQz0tiYMNxTag3Q0L+/u43Hw+AnW4DG5Wm1vh2FwzpxFJtkDp70MoJJ7K4/hGC0zzcfvisDIsU8e1y6/J/TTq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:37.8862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61437a34-2053-4f66-ef92-08de731a202b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E60.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8262

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
https://github.com/nicolinc/iommufd/commits/smmuv3_share_domain-v3

This is based on the series "Introduce an RCU-protected invalidation array"
https://lore.kernel.org/all/cover.1766013662.git.nicolinc@nvidia.com/
So the whole implementation follows the path Jason envisioned initially.

An earlier effort to share S2 domain can be found:
https://lore.kernel.org/all/cover.1744692494.git.nicolinc@nvidia.com/

Changelog
v3
 * Rebase on arm_smmu_invs-v12
 * Add Reviewed-by tags from Jason
 * Avoid Boolean function parameters
 * Set users counter in arm_smmu_ins_unref()
 * Add arm_smmu_inv_assert_iotlb_tag() helper
 * Fix the return values in arm_smmu_alloc_iotlb_tag()
 * Reorder the patches introducing INV_TYPE_S2_VMID_VSMMU
 * Add a note explaining the lifecycle of vSMMU-owned iotlb tag
 * Compare pgtbl with the new smmu in arm_smmu_domain_can_share()
 * Pass in a function pointer to arm_smmu_set_pasid() for CD making
 * Pass the raw domain pointer down to arm_smmu_domain_get_iotlb_tag()
v2
 https://lore.kernel.org/all/cover.1769044718.git.nicolinc@nvidia.com/
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
  iommu/arm-smmu-v3: Add a wrapper for arm_smmu_make_sva_cd()
  iommu/arm-smmu-v3: Pass in arm_smmu_make_cd_fn to arm_smmu_set_pasid()
  iommu/arm-smmu-v3: Store IOTLB cache tags in struct
    arm_smmu_attach_state
  iommu/arm-smmu-v3: Pass in IOTLB cache tag to
    arm_smmu_master_build_invs()
  iommu/arm-smmu-v3: Pass in IOTLB cache tag to CD and STE
  iommu/arm-smmu-v3: Introduce INV_TYPE_S2_VMID_VSMMU
  iommu/arm-smmu-v3: Allocate IOTLB cache tag if no id to reuse
  iommu/arm-smmu-v3: Allocate INV_TYPE_S2_VMID_VSMMU in arm_vsmmu_init
  iommu/arm-smmu-v3: Remove ASID/VMID from arm_smmu_domain
  iommu/arm-smmu-v3: Allow sharing domain across SMMUs

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  76 ++++-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  52 +++-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  57 ++--
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  19 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 290 ++++++++++--------
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |   1 +
 6 files changed, 305 insertions(+), 190 deletions(-)

-- 
2.43.0

