Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA3D2BCF5C;
	Wed, 16 Jul 2025 19:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695890; cv=fail; b=uoUabyE2dUniYgr4Y0jGZkR0sJA8B3FAUaCONDnKCtO1HH/HZPCvjARgzTFzuPi6B8cVVvTjp0I7vFyuDlM5zJ7Mg0DF2InDzJl/fUxXAMb9tJISNFJ4Q1vZ2vevZPgY900mpl89ntgOfJEAWQzbVOVBgwq+ryienKadeBi8Cq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695890; c=relaxed/simple;
	bh=R2Z+skTy0sxWjoNe3r60zEvO1JhRcQ+HabqWq6/VKtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YK4+Zw+hWvhwo9OGgl97zeCK/5HYY+u4LIeaKNZezwqGCCUUs8+04ahVg6tgMWIsoeEVukTycys36M1pmTMnvT6WHwmaU9UfI//3civULgBt6zjrgNFBo28DJvmMLKEjpn+7LdYHCDj6tN9B0LMIJgmrAxl7dhQ++so0Xbz3YBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t5vzq24F; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t5vzq24F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DViJJ9cJ9Ycj8/4wX+Zun0gpRrmINJX7U2rE7AJ5QolUQQDTx5yRguTun/Hh5zI8sqTL63LeOQxR4YT0l2sCOLxkb6paN3PfdBZUqvXjh+mmr6AmB/YFs1mwZ/n8uDhiPYGSaXv9c3glhr92zHpCbyXE+5dmiasQ/Cjm8PlRVMQFuBGlgJ0e2aisGiYl1B9tAJM7Vv7Of5O5rlpluKOqLpsgNhOyI3Tfd7ThEiZCnqXNYfoPULslYS4GaPzP2vbmUFuo+IgIV7O531oNTrbC18mM94gvdWhdHaMM4NlcrGlMcwfYg3ICSnkhfBdoZSSMF+qRLwmngwi+BcemE3mAzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXkIlOAC8n3VizlP3vq0MHMjxkDFTSMrbMOulQyojgw=;
 b=ssyMZxnRHhs6DdEuPupW/yI8IQPVWhHlB1lzjlqehjnIroutB3dWSRCrqQOiYnpJ+rxofyM3mIDRSY5CW9UPKXqv+9uM1sJLPl/5wJwADtiwRpMuFGKDpzeKdN6kGPZuvopHueayzffGnKoRqdoQyxndEoGX0GfDdVSHEvgyjFoEs2zm+101EQ3DgafylWByPty1O1NDpqcMI1J3VWL0S1txnuigsbaneOW08iMx+VqbI6IT4gs1/5Rj+jLA8IECtW+bJWC2PsudYbfaJAF+pUTDQ87NejJaiR8F5mzQUAVoAxgXzFmOmqiJcVCKE11aY5SSBAF0Y2pb0HFtJiz4zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXkIlOAC8n3VizlP3vq0MHMjxkDFTSMrbMOulQyojgw=;
 b=t5vzq24FN9VjONvJM1bpPyF8cEw0etY+G4r4+Foxme2yDVoe0v2Z3XmEsuqbjN8rZC76udRv6qRT0C1CFGDEa6rAcgXy539msYCXTCX5t6dSszh1mcZ2/mKV9nR962NIBZwfMI3qryj0h/m96XikAGLpQqLlq1Uu6QYXIDuNK9jsedAqrGpCZVqkvlLAViimXNpOEAoUM/wwyG9h6I9BseyAjgKb5nm1ZmxfoOcr36W7uIhzEqisqMyuWHK78TzVHOrICuNhQnjAhfMorY9PbLJ0AuvHpxwnWsEbsqLvN+wrMWLOc+XiIJyZNQqn6kqzAfV5K+eq4ZO7+y6rT8UvMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 19:57:53 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:53 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 8/9] iommu/vt-d: Use the generic iommu page table
Date: Wed, 16 Jul 2025 16:57:44 -0300
Message-ID: <8-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0030.namprd12.prod.outlook.com
 (2603:10b6:208:a8::43) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d74b0b3-d13c-4efb-95de-08ddc4a30b28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?frpBhuWsKB0yxgX5a7QJfU57HE6J1yNnYdqafgEbzyK/1Sm48JLOjgxtmhvw?=
 =?us-ascii?Q?wT/+O5DNI2yZCdcaueuVxYKgIRu7Doank9/QLxq51NEA4zrIL+dXOZ75q+G/?=
 =?us-ascii?Q?6PzjLI+QbgSP8JuRjRmelo1kiFca1b6b3xw8u0IIKtoDzUdg77fElbNUugds?=
 =?us-ascii?Q?5qhlI9xjftIUOqzu2jmOSfEETTJupIDUVvAZsjRMF3X8WleIwiVsMJjwlybu?=
 =?us-ascii?Q?Y0eJ4pctdSrCZo/xJe3Z113itR6jKh5k9or0gH5ZxuvDF1/I08yvWxBYq9LF?=
 =?us-ascii?Q?NbEEfolaZMEe0IPf7rkxWQgkkTWBzXLi07fAlti7zKtGYPHGuEK63zOxogZ4?=
 =?us-ascii?Q?UaiPgP2NnEs24EW0EudhyBcKGMFjQnJ9dISi6y5bmU+RK++QzVaNW2zElQUC?=
 =?us-ascii?Q?d4oBN/jEr5/L7xHI3narzg/FyuSDeliQ2yalIwvs54i0m/cl/I8uUZBfr7pA?=
 =?us-ascii?Q?+KukdpbMwGeBnLVw46PGqtCNJ2vdNwyd9abjefK9kIDMROmMcmx6UotqwamK?=
 =?us-ascii?Q?vWngsppjn14ZIzq20Z4s3p9oNvGXpawfPVHUHYAMwcr+2TV5kmKO55G2j/57?=
 =?us-ascii?Q?mP8So0BRGnMgc57M12b94+hy28KzsDHZOYlEglTM8CF/iNN80ZkeaFdeSheL?=
 =?us-ascii?Q?34YE6AbUF0em1NtyuZ9y8wKbotDQpsNLfhO3or8LaNip0R8aWbUZDi8l7DCo?=
 =?us-ascii?Q?2yBoW7bd4gATSnYYxrVJoo1uslhqsHhHijCC/l4WMLu1g9UMrr4rA1YN38aO?=
 =?us-ascii?Q?/0RT8GQ4Crn2c0Wg1mHikKB1ddX9aQaZIWKnbNicXRlidbCsmGJDLX7lLlMu?=
 =?us-ascii?Q?vpxJsYZUiD4yOCTw61fngybmD3+1wKaoioIoDtSWu6S03+G2d42YvlpLJcKj?=
 =?us-ascii?Q?l31my2T13S7HfvtFjt/uQu+M3Z9V06CW8KLBew2OX4III1OoIV9+xTvjFOEQ?=
 =?us-ascii?Q?lVDQ0E6qfHZzbo3Wn4H2wzRmLHft5gnhpTJqifnOqNbuvgJnjFv0oNg2Zx/f?=
 =?us-ascii?Q?khaBTPXyi+fxl4wpzAk8jfPULJlXz3GYtVNCItR2LOipNAVNn/2MjIFWk7TF?=
 =?us-ascii?Q?KoJcTt0yz3/AMfB6Jj4fLTZpUnHgH7yNU28K4jc81fTT2jYtO9fCvdwR/oOD?=
 =?us-ascii?Q?DLWP//nJ8irfl8BXy6j6q9FQCajHn528YPoX/iZquXD2ZQiboibqrHgz6uIg?=
 =?us-ascii?Q?rNxzDts/B2fe0Hn1ts3NDvjzbOmHCW4T+L07b/pmfelHHVA2ZgkjzPnvEp0/?=
 =?us-ascii?Q?A7MxmDol2b0T/hr7R93ijfpjPrgsOvEbhb1ggB34R27jr/apis9lLpO+CJUY?=
 =?us-ascii?Q?xA08fm5CtWD16v3YzItYvwSwRPtg4EdY0NV1rWaBz4IY8PoZlmSoEr2HN6Cd?=
 =?us-ascii?Q?paRtpOwkP5W5Ax/LPABRtrvG3BLPbE7UlPa+x5HUexX8P6bIFB3aHZAv2exC?=
 =?us-ascii?Q?EiJ6WSPg5Vw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I2HaifJijv3Qib4s2sBZOq0bscV6SkebRXHy2e7BA3ALsl1b1Akijfs+L5ZQ?=
 =?us-ascii?Q?pOx4cNzFBTdF45S8Bzg4rx3K1DnrBpDJq12x4AXH0fPoid/P5lCeqRcCDtX7?=
 =?us-ascii?Q?SSDx5V8ADNjv2XoIuXrhgjlMetw1VkR/WFSPSrdw08ByrTTmoEywsst9vQlv?=
 =?us-ascii?Q?6iLy20bz1dABQg5yT+85DJsSRx7lqEg5E2HcuiaLAyNGBjLBiFF0j0kjVMV3?=
 =?us-ascii?Q?jyle9+6bKixSYWwkrL3ZGBbyiDGIqw1dOygy5SiBMKYSN48U1imZ2UX2RMyU?=
 =?us-ascii?Q?+okNIdldCWAyiyF+dR8DUNMvAsGQN6k6xAwEF5gM8oI7Lj/1M8T1TCnzQlzO?=
 =?us-ascii?Q?fbF9TaEFDzu1+HPtRcscI5qo9+5iB2b0uJjQFp4BRuaDl9h3UrFGsm+AUbxa?=
 =?us-ascii?Q?A/vjFS+yXxaIQO1GPkS+ST33Er6hycaZ1DcHvapg0Zjy03X07eaxziN5derQ?=
 =?us-ascii?Q?0ajH8GZy/ZLaS0qAQCUmb4bjldm5odqNdajysq1OqThSWz3gUnPFfh2vO6xT?=
 =?us-ascii?Q?BP71k1Mf5Ah6KGZYPfdFlG/xcfxWNM01J6xKJyxl+SVn/7GXN9Jr3Hcl6EEO?=
 =?us-ascii?Q?iWye1opMGo/fh3BwwWGUkmeljwHj1jSsaKgoAtNH5fEuQB2eB5SIwVUMs5eu?=
 =?us-ascii?Q?0xOj5UiRKcVhjn/pgMXqQBEqdHxas6dC7EQdi7Drwfyc9H81QnUj1+L4JugL?=
 =?us-ascii?Q?jrHbjgSOyGSON+7KgazoH+Niiw0KshDmkaya7+6PrfNzHJo4MrKyzqh6+ILj?=
 =?us-ascii?Q?VXryq3DDGDiTsKUW6ua2VkyP9yNCt/HnQsvKjhoyDZj6WizBO4lXJJK2mJrn?=
 =?us-ascii?Q?umADGsximI4SZRf7bLA2Aw6P6XB0MkpCv2YLJ7tcQ6pswvX2jirRuq2MF3cs?=
 =?us-ascii?Q?UFykW93meNHSED7TayPdHOAcWKv9xxHlZK5/jqebPrfawO+rcs7IhhhWySK6?=
 =?us-ascii?Q?jnuWxg5H4E36jaGHXml7lIGdbVzNbuJFpACUtpOXhg0NXUMJslI/BRLLTehS?=
 =?us-ascii?Q?U2Dj7QrvP6bIv8frEXAmrZOvhj+yqogugDO164df4dibS0YiO7p/N4krplpd?=
 =?us-ascii?Q?WyfY5XwBi4LLNfwwK1rSAPAuOvdNuKFdg8ILThRyXQPMAf4me/1QwHibyn1W?=
 =?us-ascii?Q?ShLQrf9x88UsgVMTUKBt+58ZyTboA15M7znsOay5B0AlGpWSyRuBCUVqOyVV?=
 =?us-ascii?Q?zsbgPHm/KAfks0zPL75f7NxZYm+UiqytMbJ0Ia+9TDGChQ9L/TrgLxQHNm3W?=
 =?us-ascii?Q?0I0HJ+KcX21FFKohifOWnYb+hL/oWgUQD7Kr8F7cn/48Swk7QCj9Kgnw5kZk?=
 =?us-ascii?Q?N6edUo3Rk94BDtSp2il0pKZFIPMYiPtD5rGAnd3bQPybzePwF4Gm0iMjK0gj?=
 =?us-ascii?Q?7Q4ZRUVt1RmiBfixmy8SkFIe0AGDXHep/Qay/UcXawQRt2sziqS1NQg3dRxP?=
 =?us-ascii?Q?RSaw5KMPfX78w2dzfXd09ZQZLcO7tgsvvpllpKXFAf+L2G7IAWb1JIOUHgDI?=
 =?us-ascii?Q?3ZsHMkGA/Q692X0OzGJ/rosLxVrHzppxZVsfV573Dao9m8CKGQlDTOVGxvO8?=
 =?us-ascii?Q?Cd9be15TBPWIqxXUtI8FDFiwd7WLT9kitB2ljLKR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d74b0b3-d13c-4efb-95de-08ddc4a30b28
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:50.6450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QI1ayzTBfl+t1lITSDxGSCkfhMT9gsbBoh1uLd2r/d/7akUpYLs0V+PFqXyBMKKU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560

Replace the VT-D iommu_domain implementation of the VTD second stage and
first stage page tables with the iommupt VTDSS and x86_64
pagetables. x86_64 is shared with the AMD driver.

There are a couple notable things in VT-D:
- Like AMD the second stage format is not sign extended, unlike AMD it
  cannot decode a full 64 bits. The first stage format is a normal sign
  extended x86 page table
- The HW caps can indicate how many levels, how many address bits and what
  leaf page sizes are supported in HW. As before the highest number of
  levels that can translate the entire supported address width is used.
  The supported page sizes are adjusted directly from the dedicated
  first/second stage cap bits.
- VTD requires flushing 'write buffers'. This logic is left unchanged,
  the write buffer flushes on any gather flush or through iotlb_sync_map.
- Like ARM, VTD has an optional non-coherent page table walker that
  requires cache flushing. This is supported through PT_FEAT_DMA_INCOHERENT
  the same as ARM, however x86 can't use the DMA API for flush, it must
  call the arch function clflush_cache_range()
- The PT_FEAT_DYNAMIC_TOP can probably be supported on VTD someday for the
  second stage when it uses 128 bit atomic stores for the HW context
  structures.
- PT_FEAT_VTDSS_FORCE_WRITEABLE is used to work around ERRATA_772415_SPR17
- A kernel command line parameter "sp_off" disables all page sizes except 4k

Remove all the unused iommu_domain page table code. The debufs paths have
their own independent page table walker that is left alone for now.

This corrects a race with the non-coherent walker that the ARM
implementations have fixed:

     CPU 0                               CPU 1
  pfn_to_dma_pte()                    pfn_to_dma_pte()
   pte = &parent[offset];
   if (!dma_pte_present(pte)) {
     try_cmpxchg64(&pte->val)
					pte = &parent[offset];
					.. dma_pte_present(pte) ..
				        [...]
					// iommu_map() completes
					// Device does DMA
     domain_flush_cache(pte)

The CPU 1 mapping operation shares a page table level with the CPU 0
mapping operation. CPU 0 installed a new page table level but has not
flushed it yet. CPU1 returns from iommu_map() and the device does DMA. The
non coherent walker fails to see the new table level installed by CPU 0
and fails the DMA with non-present.

The iommupt PT_FEAT_DMA_INCOHERENT implementation uses the ARM design of
storing a flag when CPU 0 completes the flush. If the flag is not set CPU
1 will also flush to ensure the HW can fully walk to the PTE being
installed.

Cc: Tina Zhang <tina.zhang@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/Kconfig  |   4 +
 drivers/iommu/intel/iommu.c  | 903 ++++++-----------------------------
 drivers/iommu/intel/iommu.h  |  99 +---
 drivers/iommu/intel/nested.c |   5 -
 drivers/iommu/intel/pasid.c  |  29 +-
 5 files changed, 182 insertions(+), 858 deletions(-)

diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
index f2f538c7065032..b847266b19514f 100644
--- a/drivers/iommu/intel/Kconfig
+++ b/drivers/iommu/intel/Kconfig
@@ -13,6 +13,10 @@ config INTEL_IOMMU
 	bool "Support for Intel IOMMU using DMA Remapping Devices"
 	depends on PCI_MSI && ACPI && X86
 	select IOMMU_API
+	select GENERIC_PT
+	select IOMMU_PT
+	select IOMMU_PT_X86_64
+	select IOMMU_PT_VTDSS
 	select IOMMU_IOVA
 	select IOMMU_IOPF
 	select IOMMUFD_DRIVER if IOMMUFD
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 8db8be9b7e7d3e..3e657bec765c6e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -45,16 +45,9 @@
 
 #define DEFAULT_DOMAIN_ADDRESS_WIDTH 57
 
-#define __DOMAIN_MAX_PFN(gaw)  ((((uint64_t)1) << ((gaw) - VTD_PAGE_SHIFT)) - 1)
-#define __DOMAIN_MAX_ADDR(gaw) ((((uint64_t)1) << (gaw)) - 1)
-
-/* We limit DOMAIN_MAX_PFN to fit in an unsigned long, and DOMAIN_MAX_ADDR
-   to match. That way, we can use 'unsigned long' for PFNs with impunity. */
-#define DOMAIN_MAX_PFN(gaw)	((unsigned long) min_t(uint64_t, \
-				__DOMAIN_MAX_PFN(gaw), (unsigned long)-1))
-#define DOMAIN_MAX_ADDR(gaw)	(((uint64_t)__DOMAIN_MAX_PFN(gaw)) << VTD_PAGE_SHIFT)
-
 static void __init check_tylersburg_isoch(void);
+static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
+					  bool enable);
 static int rwbf_quirk;
 
 /*
@@ -215,7 +208,6 @@ static int disable_igfx_iommu;
 #define IDENTMAP_AZALIA		4
 
 const struct iommu_ops intel_iommu_ops;
-static const struct iommu_dirty_ops intel_dirty_ops;
 
 static bool translation_pre_enabled(struct intel_iommu *iommu)
 {
@@ -283,13 +275,6 @@ static int __init intel_iommu_setup(char *str)
 }
 __setup("intel_iommu=", intel_iommu_setup);
 
-static int domain_pfn_supported(struct dmar_domain *domain, unsigned long pfn)
-{
-	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
-
-	return !(addr_width < BITS_PER_LONG && pfn >> addr_width);
-}
-
 /*
  * Calculate the Supported Adjusted Guest Address Widths of an IOMMU.
  * Refer to 11.4.2 of the VT-d spec for the encoding of each bit of
@@ -351,23 +336,6 @@ static bool iommu_paging_structure_coherency(struct intel_iommu *iommu)
 			ecap_smpwc(iommu->ecap) : ecap_coherent(iommu->ecap);
 }
 
-/* Return the super pagesize bitmap if supported. */
-static unsigned long domain_super_pgsize_bitmap(struct dmar_domain *domain)
-{
-	unsigned long bitmap = 0;
-
-	/*
-	 * 1-level super page supports page size of 2MiB, 2-level super page
-	 * supports page size of both 2MiB and 1GiB.
-	 */
-	if (domain->iommu_superpage == 1)
-		bitmap |= SZ_2M;
-	else if (domain->iommu_superpage == 2)
-		bitmap |= SZ_2M | SZ_1G;
-
-	return bitmap;
-}
-
 struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 					 u8 devfn, int alloc)
 {
@@ -554,13 +522,6 @@ static struct intel_iommu *device_lookup_iommu(struct device *dev, u8 *bus, u8 *
 	return iommu;
 }
 
-static void domain_flush_cache(struct dmar_domain *domain,
-			       void *addr, int size)
-{
-	if (!domain->iommu_coherency)
-		clflush_cache_range(addr, size);
-}
-
 static void free_context_table(struct intel_iommu *iommu)
 {
 	struct context_entry *context;
@@ -705,280 +666,6 @@ void dmar_fault_dump_ptes(struct intel_iommu *iommu, u16 source_id,
 }
 #endif
 
-static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
-				      unsigned long pfn, int *target_level,
-				      gfp_t gfp)
-{
-	struct dma_pte *parent, *pte;
-	int level = agaw_to_level(domain->agaw);
-	int offset;
-
-	if (!domain_pfn_supported(domain, pfn))
-		/* Address beyond IOMMU's addressing capabilities. */
-		return NULL;
-
-	parent = domain->pgd;
-
-	while (1) {
-		void *tmp_page;
-
-		offset = pfn_level_offset(pfn, level);
-		pte = &parent[offset];
-		if (!*target_level && (dma_pte_superpage(pte) || !dma_pte_present(pte)))
-			break;
-		if (level == *target_level)
-			break;
-
-		if (!dma_pte_present(pte)) {
-			uint64_t pteval, tmp;
-
-			tmp_page = iommu_alloc_pages_node_sz(domain->nid, gfp,
-							     SZ_4K);
-
-			if (!tmp_page)
-				return NULL;
-
-			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
-			pteval = virt_to_phys(tmp_page) | DMA_PTE_READ |
-				 DMA_PTE_WRITE;
-			if (domain->use_first_level)
-				pteval |= DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
-
-			tmp = 0ULL;
-			if (!try_cmpxchg64(&pte->val, &tmp, pteval))
-				/* Someone else set it while we were thinking; use theirs. */
-				iommu_free_pages(tmp_page);
-			else
-				domain_flush_cache(domain, pte, sizeof(*pte));
-		}
-		if (level == 1)
-			break;
-
-		parent = phys_to_virt(dma_pte_addr(pte));
-		level--;
-	}
-
-	if (!*target_level)
-		*target_level = level;
-
-	return pte;
-}
-
-/* return address's pte at specific level */
-static struct dma_pte *dma_pfn_level_pte(struct dmar_domain *domain,
-					 unsigned long pfn,
-					 int level, int *large_page)
-{
-	struct dma_pte *parent, *pte;
-	int total = agaw_to_level(domain->agaw);
-	int offset;
-
-	parent = domain->pgd;
-	while (level <= total) {
-		offset = pfn_level_offset(pfn, total);
-		pte = &parent[offset];
-		if (level == total)
-			return pte;
-
-		if (!dma_pte_present(pte)) {
-			*large_page = total;
-			break;
-		}
-
-		if (dma_pte_superpage(pte)) {
-			*large_page = total;
-			return pte;
-		}
-
-		parent = phys_to_virt(dma_pte_addr(pte));
-		total--;
-	}
-	return NULL;
-}
-
-/* clear last level pte, a tlb flush should be followed */
-static void dma_pte_clear_range(struct dmar_domain *domain,
-				unsigned long start_pfn,
-				unsigned long last_pfn)
-{
-	unsigned int large_page;
-	struct dma_pte *first_pte, *pte;
-
-	if (WARN_ON(!domain_pfn_supported(domain, last_pfn)) ||
-	    WARN_ON(start_pfn > last_pfn))
-		return;
-
-	/* we don't need lock here; nobody else touches the iova range */
-	do {
-		large_page = 1;
-		first_pte = pte = dma_pfn_level_pte(domain, start_pfn, 1, &large_page);
-		if (!pte) {
-			start_pfn = align_to_level(start_pfn + 1, large_page + 1);
-			continue;
-		}
-		do {
-			dma_clear_pte(pte);
-			start_pfn += lvl_to_nr_pages(large_page);
-			pte++;
-		} while (start_pfn <= last_pfn && !first_pte_in_page(pte));
-
-		domain_flush_cache(domain, first_pte,
-				   (void *)pte - (void *)first_pte);
-
-	} while (start_pfn && start_pfn <= last_pfn);
-}
-
-static void dma_pte_free_level(struct dmar_domain *domain, int level,
-			       int retain_level, struct dma_pte *pte,
-			       unsigned long pfn, unsigned long start_pfn,
-			       unsigned long last_pfn)
-{
-	pfn = max(start_pfn, pfn);
-	pte = &pte[pfn_level_offset(pfn, level)];
-
-	do {
-		unsigned long level_pfn;
-		struct dma_pte *level_pte;
-
-		if (!dma_pte_present(pte) || dma_pte_superpage(pte))
-			goto next;
-
-		level_pfn = pfn & level_mask(level);
-		level_pte = phys_to_virt(dma_pte_addr(pte));
-
-		if (level > 2) {
-			dma_pte_free_level(domain, level - 1, retain_level,
-					   level_pte, level_pfn, start_pfn,
-					   last_pfn);
-		}
-
-		/*
-		 * Free the page table if we're below the level we want to
-		 * retain and the range covers the entire table.
-		 */
-		if (level < retain_level && !(start_pfn > level_pfn ||
-		      last_pfn < level_pfn + level_size(level) - 1)) {
-			dma_clear_pte(pte);
-			domain_flush_cache(domain, pte, sizeof(*pte));
-			iommu_free_pages(level_pte);
-		}
-next:
-		pfn += level_size(level);
-	} while (!first_pte_in_page(++pte) && pfn <= last_pfn);
-}
-
-/*
- * clear last level (leaf) ptes and free page table pages below the
- * level we wish to keep intact.
- */
-static void dma_pte_free_pagetable(struct dmar_domain *domain,
-				   unsigned long start_pfn,
-				   unsigned long last_pfn,
-				   int retain_level)
-{
-	dma_pte_clear_range(domain, start_pfn, last_pfn);
-
-	/* We don't need lock here; nobody else touches the iova range */
-	dma_pte_free_level(domain, agaw_to_level(domain->agaw), retain_level,
-			   domain->pgd, 0, start_pfn, last_pfn);
-
-	/* free pgd */
-	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
-		iommu_free_pages(domain->pgd);
-		domain->pgd = NULL;
-	}
-}
-
-/* When a page at a given level is being unlinked from its parent, we don't
-   need to *modify* it at all. All we need to do is make a list of all the
-   pages which can be freed just as soon as we've flushed the IOTLB and we
-   know the hardware page-walk will no longer touch them.
-   The 'pte' argument is the *parent* PTE, pointing to the page that is to
-   be freed. */
-static void dma_pte_list_pagetables(struct dmar_domain *domain,
-				    int level, struct dma_pte *parent_pte,
-				    struct iommu_pages_list *freelist)
-{
-	struct dma_pte *pte = phys_to_virt(dma_pte_addr(parent_pte));
-
-	iommu_pages_list_add(freelist, pte);
-
-	if (level == 1)
-		return;
-
-	do {
-		if (dma_pte_present(pte) && !dma_pte_superpage(pte))
-			dma_pte_list_pagetables(domain, level - 1, pte, freelist);
-		pte++;
-	} while (!first_pte_in_page(pte));
-}
-
-static void dma_pte_clear_level(struct dmar_domain *domain, int level,
-				struct dma_pte *pte, unsigned long pfn,
-				unsigned long start_pfn, unsigned long last_pfn,
-				struct iommu_pages_list *freelist)
-{
-	struct dma_pte *first_pte = NULL, *last_pte = NULL;
-
-	pfn = max(start_pfn, pfn);
-	pte = &pte[pfn_level_offset(pfn, level)];
-
-	do {
-		unsigned long level_pfn = pfn & level_mask(level);
-
-		if (!dma_pte_present(pte))
-			goto next;
-
-		/* If range covers entire pagetable, free it */
-		if (start_pfn <= level_pfn &&
-		    last_pfn >= level_pfn + level_size(level) - 1) {
-			/* These suborbinate page tables are going away entirely. Don't
-			   bother to clear them; we're just going to *free* them. */
-			if (level > 1 && !dma_pte_superpage(pte))
-				dma_pte_list_pagetables(domain, level - 1, pte, freelist);
-
-			dma_clear_pte(pte);
-			if (!first_pte)
-				first_pte = pte;
-			last_pte = pte;
-		} else if (level > 1) {
-			/* Recurse down into a level that isn't *entirely* obsolete */
-			dma_pte_clear_level(domain, level - 1,
-					    phys_to_virt(dma_pte_addr(pte)),
-					    level_pfn, start_pfn, last_pfn,
-					    freelist);
-		}
-next:
-		pfn = level_pfn + level_size(level);
-	} while (!first_pte_in_page(++pte) && pfn <= last_pfn);
-
-	if (first_pte)
-		domain_flush_cache(domain, first_pte,
-				   (void *)++last_pte - (void *)first_pte);
-}
-
-/* We can't just free the pages because the IOMMU may still be walking
-   the page tables, and may have cached the intermediate levels. The
-   pages can only be freed after the IOTLB flush has been done. */
-static void domain_unmap(struct dmar_domain *domain, unsigned long start_pfn,
-			 unsigned long last_pfn,
-			 struct iommu_pages_list *freelist)
-{
-	if (WARN_ON(!domain_pfn_supported(domain, last_pfn)) ||
-	    WARN_ON(start_pfn > last_pfn))
-		return;
-
-	/* we don't need lock here; nobody else touches the iova range */
-	dma_pte_clear_level(domain, agaw_to_level(domain->agaw),
-			    domain->pgd, 0, start_pfn, last_pfn, freelist);
-
-	/* free pgd */
-	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
-		iommu_pages_list_add(freelist, domain->pgd);
-		domain->pgd = NULL;
-	}
-}
-
 /* iommu handling */
 static int iommu_alloc_root_entry(struct intel_iommu *iommu)
 {
@@ -1458,13 +1145,15 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 			domain_lookup_dev_info(domain, iommu, bus, devfn);
 	u16 did = domain_id_iommu(domain, iommu);
 	int translation = CONTEXT_TT_MULTI_LEVEL;
-	struct dma_pte *pgd = domain->pgd;
+	struct pt_iommu_vtdss_hw_info pt_info;
 	struct context_entry *context;
 	int ret;
 
 	if (WARN_ON(!intel_domain_is_ss_paging(domain)))
 		return -EINVAL;
 
+	pt_iommu_vtdss_hw_info(&domain->sspt, &pt_info);
+
 	pr_debug("Set context mapping for %02x:%02x.%d\n",
 		bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
@@ -1487,8 +1176,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	else
 		translation = CONTEXT_TT_MULTI_LEVEL;
 
-	context_set_address_root(context, virt_to_phys(pgd));
-	context_set_address_width(context, domain->agaw);
+	context_set_address_root(context, pt_info.ssptptr);
+	context_set_address_width(context, pt_info.aw);
 	context_set_translation_type(context, translation);
 	context_set_fault_enable(context);
 	context_set_present(context);
@@ -1535,172 +1224,6 @@ domain_context_mapping(struct dmar_domain *domain, struct device *dev)
 	return 0;
 }
 
-/* Return largest possible superpage level for a given mapping */
-static int hardware_largepage_caps(struct dmar_domain *domain, unsigned long iov_pfn,
-				   unsigned long phy_pfn, unsigned long pages)
-{
-	int support, level = 1;
-	unsigned long pfnmerge;
-
-	support = domain->iommu_superpage;
-
-	/* To use a large page, the virtual *and* physical addresses
-	   must be aligned to 2MiB/1GiB/etc. Lower bits set in either
-	   of them will mean we have to use smaller pages. So just
-	   merge them and check both at once. */
-	pfnmerge = iov_pfn | phy_pfn;
-
-	while (support && !(pfnmerge & ~VTD_STRIDE_MASK)) {
-		pages >>= VTD_STRIDE_SHIFT;
-		if (!pages)
-			break;
-		pfnmerge >>= VTD_STRIDE_SHIFT;
-		level++;
-		support--;
-	}
-	return level;
-}
-
-/*
- * Ensure that old small page tables are removed to make room for superpage(s).
- * We're going to add new large pages, so make sure we don't remove their parent
- * tables. The IOTLB/devTLBs should be flushed if any PDE/PTEs are cleared.
- */
-static void switch_to_super_page(struct dmar_domain *domain,
-				 unsigned long start_pfn,
-				 unsigned long end_pfn, int level)
-{
-	unsigned long lvl_pages = lvl_to_nr_pages(level);
-	struct dma_pte *pte = NULL;
-
-	while (start_pfn <= end_pfn) {
-		if (!pte)
-			pte = pfn_to_dma_pte(domain, start_pfn, &level,
-					     GFP_ATOMIC);
-
-		if (dma_pte_present(pte)) {
-			dma_pte_free_pagetable(domain, start_pfn,
-					       start_pfn + lvl_pages - 1,
-					       level + 1);
-
-			cache_tag_flush_range(domain, start_pfn << VTD_PAGE_SHIFT,
-					      end_pfn << VTD_PAGE_SHIFT, 0);
-		}
-
-		pte++;
-		start_pfn += lvl_pages;
-		if (first_pte_in_page(pte))
-			pte = NULL;
-	}
-}
-
-static int
-__domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
-		 unsigned long phys_pfn, unsigned long nr_pages, int prot,
-		 gfp_t gfp)
-{
-	struct dma_pte *first_pte = NULL, *pte = NULL;
-	unsigned int largepage_lvl = 0;
-	unsigned long lvl_pages = 0;
-	phys_addr_t pteval;
-	u64 attr;
-
-	if (unlikely(!domain_pfn_supported(domain, iov_pfn + nr_pages - 1)))
-		return -EINVAL;
-
-	if ((prot & (DMA_PTE_READ|DMA_PTE_WRITE)) == 0)
-		return -EINVAL;
-
-	if (!(prot & DMA_PTE_WRITE) && domain->nested_parent) {
-		pr_err_ratelimited("Read-only mapping is disallowed on the domain which serves as the parent in a nested configuration, due to HW errata (ERRATA_772415_SPR17)\n");
-		return -EINVAL;
-	}
-
-	attr = prot & (DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP);
-	if (domain->use_first_level) {
-		attr |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
-		if (prot & DMA_PTE_WRITE)
-			attr |= DMA_FL_PTE_DIRTY;
-	}
-
-	domain->has_mappings = true;
-
-	pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
-
-	while (nr_pages > 0) {
-		uint64_t tmp;
-
-		if (!pte) {
-			largepage_lvl = hardware_largepage_caps(domain, iov_pfn,
-					phys_pfn, nr_pages);
-
-			pte = pfn_to_dma_pte(domain, iov_pfn, &largepage_lvl,
-					     gfp);
-			if (!pte)
-				return -ENOMEM;
-			first_pte = pte;
-
-			lvl_pages = lvl_to_nr_pages(largepage_lvl);
-
-			/* It is large page*/
-			if (largepage_lvl > 1) {
-				unsigned long end_pfn;
-				unsigned long pages_to_remove;
-
-				pteval |= DMA_PTE_LARGE_PAGE;
-				pages_to_remove = min_t(unsigned long, nr_pages,
-							nr_pte_to_next_page(pte) * lvl_pages);
-				end_pfn = iov_pfn + pages_to_remove - 1;
-				switch_to_super_page(domain, iov_pfn, end_pfn, largepage_lvl);
-			} else {
-				pteval &= ~(uint64_t)DMA_PTE_LARGE_PAGE;
-			}
-
-		}
-		/* We don't need lock here, nobody else
-		 * touches the iova range
-		 */
-		tmp = 0ULL;
-		if (!try_cmpxchg64_local(&pte->val, &tmp, pteval)) {
-			static int dumps = 5;
-			pr_crit("ERROR: DMA PTE for vPFN 0x%lx already set (to %llx not %llx)\n",
-				iov_pfn, tmp, (unsigned long long)pteval);
-			if (dumps) {
-				dumps--;
-				debug_dma_dump_mappings(NULL);
-			}
-			WARN_ON(1);
-		}
-
-		nr_pages -= lvl_pages;
-		iov_pfn += lvl_pages;
-		phys_pfn += lvl_pages;
-		pteval += lvl_pages * VTD_PAGE_SIZE;
-
-		/* If the next PTE would be the first in a new page, then we
-		 * need to flush the cache on the entries we've just written.
-		 * And then we'll need to recalculate 'pte', so clear it and
-		 * let it get set again in the if (!pte) block above.
-		 *
-		 * If we're done (!nr_pages) we need to flush the cache too.
-		 *
-		 * Also if we've been setting superpages, we may need to
-		 * recalculate 'pte' and switch back to smaller pages for the
-		 * end of the mapping, if the trailing size is not enough to
-		 * use another superpage (i.e. nr_pages < lvl_pages).
-		 */
-		pte++;
-		if (!nr_pages || first_pte_in_page(pte) ||
-		    (largepage_lvl > 1 && nr_pages < lvl_pages)) {
-			domain_flush_cache(domain, first_pte,
-					   (void *)pte - (void *)first_pte);
-			pte = NULL;
-		}
-	}
-
-	return 0;
-}
-
 static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8 devfn)
 {
 	struct intel_iommu *iommu = info->iommu;
@@ -1762,14 +1285,14 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 				    struct device *dev,
 				    u32 pasid, struct iommu_domain *old)
 {
-	struct dma_pte *pgd = domain->pgd;
-	int level, flags = 0;
+	struct pt_iommu_x86_64_hw_info pt_info;
+	unsigned int flags = 0;
 
-	level = agaw_to_level(domain->agaw);
-	if (level != 4 && level != 5)
+	pt_iommu_x86_64_hw_info(&domain->fspt, &pt_info);
+	if (WARN_ON(pt_info.levels != 4 && pt_info.levels != 5))
 		return -EINVAL;
 
-	if (level == 5)
+	if (pt_info.levels == 5)
 		flags |= PASID_FLAG_FL5LP;
 
 	if (domain->force_snooping)
@@ -1777,7 +1300,7 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 
 	return __domain_setup_first_level(iommu, dev, pasid,
 					  domain_id_iommu(domain, iommu),
-					  __pa(pgd), flags, old);
+					  pt_info.gcr3_pt, flags, old);
 }
 
 static bool domain_need_iotlb_sync_map(struct dmar_domain *domain,
@@ -3258,23 +2781,9 @@ static struct iommu_domain blocking_domain = {
 	}
 };
 
-static int iommu_superpage_capability(struct intel_iommu *iommu, bool first_stage)
+static struct dmar_domain *paging_domain_alloc(void)
 {
-	if (!intel_iommu_superpage)
-		return 0;
-
-	if (first_stage)
-		return cap_fl1gp_support(iommu->cap) ? 2 : 1;
-
-	return fls(cap_super_page_val(iommu->cap));
-}
-
-static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_stage)
-{
-	struct device_domain_info *info = dev_iommu_priv_get(dev);
-	struct intel_iommu *iommu = info->iommu;
 	struct dmar_domain *domain;
-	int addr_width;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
@@ -3289,48 +2798,6 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 	INIT_LIST_HEAD(&domain->s1_domains);
 	spin_lock_init(&domain->s1_lock);
 
-	domain->nid = dev_to_node(dev);
-	domain->use_first_level = first_stage;
-
-	domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
-
-	/* calculate the address width */
-	addr_width = agaw_to_width(iommu->agaw);
-	if (addr_width > cap_mgaw(iommu->cap))
-		addr_width = cap_mgaw(iommu->cap);
-	domain->gaw = addr_width;
-	domain->agaw = iommu->agaw;
-	domain->max_addr = __DOMAIN_MAX_ADDR(addr_width);
-
-	/* iommu memory access coherency */
-	domain->iommu_coherency = iommu_paging_structure_coherency(iommu);
-
-	/* pagesize bitmap */
-	domain->domain.pgsize_bitmap = SZ_4K;
-	domain->iommu_superpage = iommu_superpage_capability(iommu, first_stage);
-	domain->domain.pgsize_bitmap |= domain_super_pgsize_bitmap(domain);
-
-	/*
-	 * IOVA aperture: First-level translation restricts the input-address
-	 * to a canonical address (i.e., address bits 63:N have the same value
-	 * as address bit [N-1], where N is 48-bits with 4-level paging and
-	 * 57-bits with 5-level paging). Hence, skip bit [N-1].
-	 */
-	domain->domain.geometry.force_aperture = true;
-	domain->domain.geometry.aperture_start = 0;
-	if (first_stage)
-		domain->domain.geometry.aperture_end = __DOMAIN_MAX_ADDR(domain->gaw - 1);
-	else
-		domain->domain.geometry.aperture_end = __DOMAIN_MAX_ADDR(domain->gaw);
-
-	/* always allocate the top pgd */
-	domain->pgd = iommu_alloc_pages_node_sz(domain->nid, GFP_KERNEL, SZ_4K);
-	if (!domain->pgd) {
-		kfree(domain);
-		return ERR_PTR(-ENOMEM);
-	}
-	domain_flush_cache(domain, domain->pgd, PAGE_SIZE);
-
 	return domain;
 }
 
@@ -3338,7 +2805,9 @@ static struct iommu_domain *
 intel_iommu_domain_alloc_first_stage(struct device *dev,
 				     struct intel_iommu *iommu, u32 flags)
 {
+	struct pt_iommu_x86_64_cfg cfg = {};
 	struct dmar_domain *dmar_domain;
+	int ret;
 
 	if (flags & ~IOMMU_HWPT_ALLOC_PASID)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -3347,19 +2816,72 @@ intel_iommu_domain_alloc_first_stage(struct device *dev,
 	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	dmar_domain = paging_domain_alloc(dev, true);
+	dmar_domain = paging_domain_alloc();
 	if (IS_ERR(dmar_domain))
 		return ERR_CAST(dmar_domain);
 
+	if (cap_fl5lp_support(iommu->cap))
+		cfg.common.hw_max_vasz_lg2 = 57;
+	else
+		cfg.common.hw_max_vasz_lg2 = 48;
+	cfg.common.hw_max_oasz_lg2 = 52;
+	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
+			      BIT(PT_FEAT_FLUSH_RANGE);
+	/* First stage always uses scalable mode */
+	if (WARN_ON(!ecap_smpwc(iommu->ecap)))
+		return ERR_PTR(-EINVAL);
+	if (ecap_smpwc(iommu->ecap))
+		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);
+	dmar_domain->iommu.iommu_device = dev;
+	dmar_domain->iommu.nid = dev_to_node(dev);
 	dmar_domain->domain.ops = &intel_fs_paging_domain_ops;
+
+	ret = pt_iommu_x86_64_init(&dmar_domain->fspt, &cfg, GFP_KERNEL);
+	if (ret) {
+		kfree(dmar_domain);
+		return ERR_PTR(ret);
+	}
+
+	if (!cap_fl1gp_support(iommu->cap))
+		dmar_domain->domain.pgsize_bitmap &= ~(u64)SZ_1G;
+	if (!intel_iommu_superpage)
+		dmar_domain->domain.pgsize_bitmap = SZ_4K;
+
 	return &dmar_domain->domain;
 }
 
+static int compute_vasz_lg2_ss(struct intel_iommu *iommu)
+{
+	unsigned int sagaw = cap_sagaw(iommu->cap);
+	unsigned int mgaw = cap_mgaw(iommu->cap);
+
+	/*
+	 * Find the largest table size that both the mgaw and sagaw support.
+	 * This sets both the number of table levels and the valid range of
+	 * IOVA.
+	 */
+	if (mgaw >= 48 && (sagaw & BIT(3)))
+		return min(57, mgaw);
+	else if (mgaw >= 39 && (sagaw & BIT(2)))
+		return min(48, mgaw);
+	else if (mgaw >= 30 && (sagaw & BIT(1)))
+		return min(39, mgaw);
+	return 0;
+}
+
+static const struct iommu_dirty_ops intel_second_stage_dirty_ops = {
+	IOMMU_PT_DIRTY_OPS(vtdss),
+	.set_dirty_tracking = intel_iommu_set_dirty_tracking,
+};
+
 static struct iommu_domain *
 intel_iommu_domain_alloc_second_stage(struct device *dev,
 				      struct intel_iommu *iommu, u32 flags)
 {
+	struct pt_iommu_vtdss_cfg cfg = {};
 	struct dmar_domain *dmar_domain;
+	unsigned int sslps;
+	int ret;
 
 	if (flags &
 	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
@@ -3376,15 +2898,48 @@ intel_iommu_domain_alloc_second_stage(struct device *dev,
 	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	dmar_domain = paging_domain_alloc(dev, false);
+	dmar_domain = paging_domain_alloc();
 	if (IS_ERR(dmar_domain))
 		return ERR_CAST(dmar_domain);
 
+	cfg.common.hw_max_vasz_lg2 = compute_vasz_lg2_ss(iommu);
+	cfg.common.hw_max_oasz_lg2 = 52;
+	cfg.common.features = BIT(PT_FEAT_FLUSH_RANGE);
+
+	/*
+	 * Read-only mapping is disallowed on the domain which serves as the
+	 * parent in a nested configuration, due to HW errata
+	 * (ERRATA_772415_SPR17)
+	 */
+	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT)
+		cfg.common.features |= BIT(PT_FEAT_VTDSS_FORCE_WRITEABLE);
+
+	if (WARN_ON(!iommu_paging_structure_coherency(iommu)))
+		return ERR_PTR(-EINVAL);
+	if (!iommu_paging_structure_coherency(iommu))
+		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);
+	dmar_domain->iommu.iommu_device = dev;
+	dmar_domain->iommu.nid = dev_to_node(dev);
 	dmar_domain->domain.ops = &intel_ss_paging_domain_ops;
 	dmar_domain->nested_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
 
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING)
-		dmar_domain->domain.dirty_ops = &intel_dirty_ops;
+		dmar_domain->domain.dirty_ops = &intel_second_stage_dirty_ops;
+
+	ret = pt_iommu_vtdss_init(&dmar_domain->sspt, &cfg, GFP_KERNEL);
+	if (ret) {
+		kfree(dmar_domain);
+		return ERR_PTR(ret);
+	}
+
+	/* Adjust the supported page sizes to HW capability */
+	sslps = cap_super_page_val(iommu->cap);
+	if (!(sslps & BIT(0)))
+		dmar_domain->domain.pgsize_bitmap &= ~(u64)SZ_2M;
+	if (!(sslps & BIT(1)))
+		dmar_domain->domain.pgsize_bitmap &= ~(u64)SZ_1G;
+	if (!intel_iommu_superpage)
+		dmar_domain->domain.pgsize_bitmap = SZ_4K;
 
 	return &dmar_domain->domain;
 }
@@ -3418,14 +2973,7 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
 	if (WARN_ON(!list_empty(&dmar_domain->devices)))
 		return;
 
-	if (dmar_domain->pgd) {
-		struct iommu_pages_list freelist =
-			IOMMU_PAGES_LIST_INIT(freelist);
-
-		domain_unmap(dmar_domain, 0, DOMAIN_MAX_PFN(dmar_domain->gaw),
-			     &freelist);
-		iommu_put_pages_list(&freelist);
-	}
+	pt_iommu_deinit(&dmar_domain->iommu);
 
 	kfree(dmar_domain->qi_batch);
 	kfree(dmar_domain);
@@ -3442,6 +2990,16 @@ static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
 	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
 		return -EINVAL;
 
+	if (!ecap_smpwc(iommu->ecap) &&
+	    !(dmar_domain->fspt.x86_64_pt.common.features &
+	      BIT(PT_FEAT_DMA_INCOHERENT)))
+		return -EINVAL;
+
+	/* Supports the number of table levels */
+	if (!cap_fl5lp_support(iommu->cap) &&
+	    dmar_domain->fspt.x86_64_pt.common.max_vasz_lg2 > 48)
+		return -EINVAL;
+
 	/* Same page size support */
 	if (!cap_fl1gp_support(iommu->cap) &&
 	    (dmar_domain->domain.pgsize_bitmap & SZ_1G))
@@ -3453,7 +3011,11 @@ static int
 paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
 				      struct intel_iommu *iommu)
 {
+	unsigned int vasz_lg2 = dmar_domain->sspt.vtdss_pt.common.max_vasz_lg2;
 	unsigned int sslps = cap_super_page_val(iommu->cap);
+	struct pt_iommu_vtdss_hw_info pt_info;
+
+	pt_iommu_vtdss_hw_info(&dmar_domain->sspt, &pt_info);
 
 	if (dmar_domain->domain.dirty_ops && !ssads_supported(iommu))
 		return -EINVAL;
@@ -3464,11 +3026,33 @@ paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
 	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
 		return -EINVAL;
 
+	if (!iommu_paging_structure_coherency(iommu) &&
+	    !(dmar_domain->sspt.vtdss_pt.common.features &
+	      BIT(PT_FEAT_DMA_INCOHERENT)))
+		return -EINVAL;
+
+	/* Address width falls within the capability */
+	if (cap_mgaw(iommu->cap) < vasz_lg2)
+		return -EINVAL;
+
+	/* Page table level is supported. */
+	if (!(cap_sagaw(iommu->cap) & BIT(pt_info.aw)))
+		return -EINVAL;
+
 	/* Same page size support */
 	if (!(sslps & BIT(0)) && (dmar_domain->domain.pgsize_bitmap & SZ_2M))
 		return -EINVAL;
 	if (!(sslps & BIT(1)) && (dmar_domain->domain.pgsize_bitmap & SZ_1G))
 		return -EINVAL;
+
+	/*
+	 * FIXME this is locked wrong, it needs to be under the
+	 * dmar_domain->lock
+	 */
+	if ((dmar_domain->sspt.vtdss_pt.common.features &
+	     BIT(PT_FEAT_VTDSS_FORCE_COHERENCE)) &&
+	    !ecap_sc_support(iommu->ecap))
+		return -EINVAL;
 	return 0;
 }
 
@@ -3478,7 +3062,6 @@ int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu = info->iommu;
 	int ret = -EINVAL;
-	int addr_width;
 
 	if (intel_domain_is_fs_paging(dmar_domain))
 		ret = paging_domain_compatible_first_stage(dmar_domain, iommu);
@@ -3489,26 +3072,6 @@ int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
 	if (ret)
 		return ret;
 
-	/*
-	 * FIXME this is locked wrong, it needs to be under the
-	 * dmar_domain->lock
-	 */
-	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
-		return -EINVAL;
-
-	if (dmar_domain->iommu_coherency !=
-			iommu_paging_structure_coherency(iommu))
-		return -EINVAL;
-
-
-	/* check if this iommu agaw is sufficient for max mapped address */
-	addr_width = agaw_to_width(iommu->agaw);
-	if (addr_width > cap_mgaw(iommu->cap))
-		addr_width = cap_mgaw(iommu->cap);
-
-	if (dmar_domain->gaw > addr_width || dmar_domain->agaw > iommu->agaw)
-		return -EINVAL;
-
 	if (sm_supported(iommu) && !dev_is_real_dma_subdevice(dev) &&
 	    context_copied(iommu, info->bus, info->devfn))
 		return intel_pasid_setup_sm_context(dev);
@@ -3538,110 +3101,6 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 	return ret;
 }
 
-static int intel_iommu_map(struct iommu_domain *domain,
-			   unsigned long iova, phys_addr_t hpa,
-			   size_t size, int iommu_prot, gfp_t gfp)
-{
-	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	u64 max_addr;
-	int prot = 0;
-
-	if (iommu_prot & IOMMU_READ)
-		prot |= DMA_PTE_READ;
-	if (iommu_prot & IOMMU_WRITE)
-		prot |= DMA_PTE_WRITE;
-	if (dmar_domain->set_pte_snp)
-		prot |= DMA_PTE_SNP;
-
-	max_addr = iova + size;
-	if (dmar_domain->max_addr < max_addr) {
-		u64 end;
-
-		/* check if minimum agaw is sufficient for mapped address */
-		end = __DOMAIN_MAX_ADDR(dmar_domain->gaw) + 1;
-		if (end < max_addr) {
-			pr_err("%s: iommu width (%d) is not "
-			       "sufficient for the mapped address (%llx)\n",
-			       __func__, dmar_domain->gaw, max_addr);
-			return -EFAULT;
-		}
-		dmar_domain->max_addr = max_addr;
-	}
-	/* Round up size to next multiple of PAGE_SIZE, if it and
-	   the low bits of hpa would take us onto the next page */
-	size = aligned_nrpages(hpa, size);
-	return __domain_mapping(dmar_domain, iova >> VTD_PAGE_SHIFT,
-				hpa >> VTD_PAGE_SHIFT, size, prot, gfp);
-}
-
-static int intel_iommu_map_pages(struct iommu_domain *domain,
-				 unsigned long iova, phys_addr_t paddr,
-				 size_t pgsize, size_t pgcount,
-				 int prot, gfp_t gfp, size_t *mapped)
-{
-	unsigned long pgshift = __ffs(pgsize);
-	size_t size = pgcount << pgshift;
-	int ret;
-
-	if (pgsize != SZ_4K && pgsize != SZ_2M && pgsize != SZ_1G)
-		return -EINVAL;
-
-	if (!IS_ALIGNED(iova | paddr, pgsize))
-		return -EINVAL;
-
-	ret = intel_iommu_map(domain, iova, paddr, size, prot, gfp);
-	if (!ret && mapped)
-		*mapped = size;
-
-	return ret;
-}
-
-static size_t intel_iommu_unmap(struct iommu_domain *domain,
-				unsigned long iova, size_t size,
-				struct iommu_iotlb_gather *gather)
-{
-	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	unsigned long start_pfn, last_pfn;
-	int level = 0;
-
-	/* Cope with horrid API which requires us to unmap more than the
-	   size argument if it happens to be a large-page mapping. */
-	if (unlikely(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
-				     &level, GFP_ATOMIC)))
-		return 0;
-
-	if (size < VTD_PAGE_SIZE << level_to_offset_bits(level))
-		size = VTD_PAGE_SIZE << level_to_offset_bits(level);
-
-	start_pfn = iova >> VTD_PAGE_SHIFT;
-	last_pfn = (iova + size - 1) >> VTD_PAGE_SHIFT;
-
-	domain_unmap(dmar_domain, start_pfn, last_pfn, &gather->freelist);
-
-	if (dmar_domain->max_addr == iova + size)
-		dmar_domain->max_addr = iova;
-
-	/*
-	 * We do not use page-selective IOTLB invalidation in flush queue,
-	 * so there is no need to track page and sync iotlb.
-	 */
-	if (!iommu_iotlb_gather_queued(gather))
-		iommu_iotlb_gather_add_page(domain, gather, iova, size);
-
-	return size;
-}
-
-static size_t intel_iommu_unmap_pages(struct iommu_domain *domain,
-				      unsigned long iova,
-				      size_t pgsize, size_t pgcount,
-				      struct iommu_iotlb_gather *gather)
-{
-	unsigned long pgshift = __ffs(pgsize);
-	size_t size = pgcount << pgshift;
-
-	return intel_iommu_unmap(domain, iova, size, gather);
-}
-
 static void intel_iommu_tlb_sync(struct iommu_domain *domain,
 				 struct iommu_iotlb_gather *gather)
 {
@@ -3651,24 +3110,6 @@ static void intel_iommu_tlb_sync(struct iommu_domain *domain,
 	iommu_put_pages_list(&gather->freelist);
 }
 
-static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
-					    dma_addr_t iova)
-{
-	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	struct dma_pte *pte;
-	int level = 0;
-	u64 phys = 0;
-
-	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level,
-			     GFP_ATOMIC);
-	if (pte && dma_pte_present(pte))
-		phys = dma_pte_addr(pte) +
-			(iova & (BIT_MASK(level_to_offset_bits(level) +
-						VTD_PAGE_SHIFT) - 1));
-
-	return phys;
-}
-
 static bool domain_support_force_snooping(struct dmar_domain *domain)
 {
 	struct device_domain_info *info;
@@ -3710,15 +3151,16 @@ static bool intel_iommu_enforce_cache_coherency_ss(struct iommu_domain *domain)
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 
 	guard(spinlock_irqsave)(&dmar_domain->lock);
-	if (!domain_support_force_snooping(dmar_domain) ||
-	    dmar_domain->has_mappings)
+	if (!domain_support_force_snooping(dmar_domain))
 		return false;
+	/* FIXME no longer check for no mappings */
 
 	/*
 	 * Second level page table supports per-PTE snoop control. The
 	 * iommu_map() interface will handle this by setting SNP bit.
 	 */
-	dmar_domain->set_pte_snp = true;
+	dmar_domain->sspt.vtdss_pt.common.features |=
+		BIT(PT_FEAT_VTDSS_FORCE_COHERENCE);
 	dmar_domain->force_snooping = true;
 	return true;
 }
@@ -4268,49 +3710,6 @@ static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
 	return ret;
 }
 
-static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
-					    unsigned long iova, size_t size,
-					    unsigned long flags,
-					    struct iommu_dirty_bitmap *dirty)
-{
-	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	unsigned long end = iova + size - 1;
-	unsigned long pgsize;
-
-	/*
-	 * IOMMUFD core calls into a dirty tracking disabled domain without an
-	 * IOVA bitmap set in order to clean dirty bits in all PTEs that might
-	 * have occurred when we stopped dirty tracking. This ensures that we
-	 * never inherit dirtied bits from a previous cycle.
-	 */
-	if (!dmar_domain->dirty_tracking && dirty->bitmap)
-		return -EINVAL;
-
-	do {
-		struct dma_pte *pte;
-		int lvl = 0;
-
-		pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &lvl,
-				     GFP_ATOMIC);
-		pgsize = level_size(lvl) << VTD_PAGE_SHIFT;
-		if (!pte || !dma_pte_present(pte)) {
-			iova += pgsize;
-			continue;
-		}
-
-		if (dma_sl_pte_test_and_clear_dirty(pte, flags))
-			iommu_dirty_bitmap_record(dirty, iova, pgsize);
-		iova += pgsize;
-	} while (iova < end);
-
-	return 0;
-}
-
-static const struct iommu_dirty_ops intel_dirty_ops = {
-	.set_dirty_tracking = intel_iommu_set_dirty_tracking,
-	.read_and_clear_dirty = intel_iommu_read_and_clear_dirty,
-};
-
 static int context_setup_pass_through(struct device *dev, u8 bus, u8 devfn)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
@@ -4428,27 +3827,23 @@ static struct iommu_domain identity_domain = {
 };
 
 const struct iommu_domain_ops intel_fs_paging_domain_ops = {
+	IOMMU_PT_DOMAIN_OPS(x86_64),
 	.attach_dev = intel_iommu_attach_device,
 	.set_dev_pasid = intel_iommu_set_dev_pasid,
-	.map_pages = intel_iommu_map_pages,
-	.unmap_pages = intel_iommu_unmap_pages,
 	.iotlb_sync_map = intel_iommu_iotlb_sync_map,
 	.flush_iotlb_all = intel_flush_iotlb_all,
 	.iotlb_sync = intel_iommu_tlb_sync,
-	.iova_to_phys = intel_iommu_iova_to_phys,
 	.free = intel_iommu_domain_free,
 	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency_fs,
 };
 
 const struct iommu_domain_ops intel_ss_paging_domain_ops = {
+	IOMMU_PT_DOMAIN_OPS(vtdss),
 	.attach_dev = intel_iommu_attach_device,
 	.set_dev_pasid = intel_iommu_set_dev_pasid,
-	.map_pages = intel_iommu_map_pages,
-	.unmap_pages = intel_iommu_unmap_pages,
 	.iotlb_sync_map = intel_iommu_iotlb_sync_map,
 	.flush_iotlb_all = intel_flush_iotlb_all,
 	.iotlb_sync = intel_iommu_tlb_sync,
-	.iova_to_phys = intel_iommu_iova_to_phys,
 	.free = intel_iommu_domain_free,
 	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency_ss,
 };
@@ -4763,3 +4158,5 @@ int ecmd_submit_sync(struct intel_iommu *iommu, u8 ecmd, u64 oa, u64 ob)
 
 	return ret;
 }
+
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index eac6fda8e59ce5..c3c25ee9169aee 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -23,8 +23,8 @@
 #include <linux/xarray.h>
 #include <linux/perf_event.h>
 #include <linux/pci.h>
+#include <linux/generic_pt/iommu.h>
 
-#include <asm/cacheflush.h>
 #include <asm/iommu.h>
 #include <uapi/linux/iommufd.h>
 
@@ -173,8 +173,6 @@
 #define cap_pgsel_inv(c)	(((c) >> 39) & 1)
 
 #define cap_super_page_val(c)	(((c) >> 34) & 0xf)
-#define cap_super_offset(c)	(((find_first_bit(&cap_super_page_val(c), 4)) \
-					* OFFSET_STRIDE) + 21)
 
 #define cap_fault_reg_offset(c)	((((c) >> 24) & 0x3ff) * 16)
 #define cap_max_fault_reg_offset(c) \
@@ -598,22 +596,20 @@ struct qi_batch {
 };
 
 struct dmar_domain {
-	int	nid;			/* node id */
+	union {
+		struct iommu_domain domain;
+		struct pt_iommu iommu;
+		/* First stage page table */
+		struct pt_iommu_x86_64 fspt;
+		/* Second stage page table */
+		struct pt_iommu_vtdss sspt;
+	};
+
 	struct xarray iommu_array;	/* Attached IOMMU array */
 
-	u8 iommu_coherency: 1;		/* indicate coherency of iommu access */
-	u8 force_snooping : 1;		/* Create IOPTEs with snoop control */
-	u8 set_pte_snp:1;
-	u8 use_first_level:1;		/* DMA translation for the domain goes
-					 * through the first level page table,
-					 * otherwise, goes through the second
-					 * level.
-					 */
+	u8 force_snooping:1;		/* Create PASID entry with snoop control */
 	u8 dirty_tracking:1;		/* Dirty tracking is enabled */
 	u8 nested_parent:1;		/* Has other domains nested on it */
-	u8 has_mappings:1;		/* Has mappings configured through
-					 * iommu_map() interface.
-					 */
 	u8 iotlb_sync_map:1;		/* Need to flush IOTLB cache or write
 					 * buffer when creating mappings.
 					 */
@@ -626,26 +622,9 @@ struct dmar_domain {
 	struct list_head cache_tags;	/* Cache tag list */
 	struct qi_batch *qi_batch;	/* Batched QI descriptors */
 
-	int		iommu_superpage;/* Level of superpages supported:
-					   0 == 4KiB (no superpages), 1 == 2MiB,
-					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
 	union {
 		/* DMA remapping domain */
 		struct {
-			/* virtual address */
-			struct dma_pte	*pgd;
-			/* max guest address width */
-			int		gaw;
-			/*
-			 * adjusted guest address width:
-			 *   0: level 2 30-bit
-			 *   1: level 3 39-bit
-			 *   2: level 4 48-bit
-			 *   3: level 5 57-bit
-			 */
-			int		agaw;
-			/* maximum mapped address */
-			u64		max_addr;
 			/* Protect the s1_domains list */
 			spinlock_t	s1_lock;
 			/* Track s1_domains nested on this domain */
@@ -667,10 +646,10 @@ struct dmar_domain {
 			struct mmu_notifier notifier;
 		};
 	};
-
-	struct iommu_domain domain;	/* generic domain data structure for
-					   iommu core */
 };
+PT_IOMMU_CHECK_DOMAIN(struct dmar_domain, iommu, domain);
+PT_IOMMU_CHECK_DOMAIN(struct dmar_domain, sspt.iommu, domain);
+PT_IOMMU_CHECK_DOMAIN(struct dmar_domain, fspt.iommu, domain);
 
 /*
  * In theory, the VT-d 4.0 spec can support up to 2 ^ 16 counters.
@@ -869,11 +848,6 @@ struct dma_pte {
 	u64 val;
 };
 
-static inline void dma_clear_pte(struct dma_pte *pte)
-{
-	pte->val = 0;
-}
-
 static inline u64 dma_pte_addr(struct dma_pte *pte)
 {
 #ifdef CONFIG_64BIT
@@ -889,32 +863,11 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 	return (pte->val & 3) != 0;
 }
 
-static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
-						   unsigned long flags)
-{
-	if (flags & IOMMU_DIRTY_NO_CLEAR)
-		return (pte->val & DMA_SL_PTE_DIRTY) != 0;
-
-	return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
-				  (unsigned long *)&pte->val);
-}
-
 static inline bool dma_pte_superpage(struct dma_pte *pte)
 {
 	return (pte->val & DMA_PTE_LARGE_PAGE);
 }
 
-static inline bool first_pte_in_page(struct dma_pte *pte)
-{
-	return IS_ALIGNED((unsigned long)pte, VTD_PAGE_SIZE);
-}
-
-static inline int nr_pte_to_next_page(struct dma_pte *pte)
-{
-	return first_pte_in_page(pte) ? BIT_ULL(VTD_STRIDE_SHIFT) :
-		(struct dma_pte *)ALIGN((unsigned long)pte, VTD_PAGE_SIZE) - pte;
-}
-
 static inline bool context_present(struct context_entry *context)
 {
 	return (context->lo & 1);
@@ -930,11 +883,6 @@ static inline int agaw_to_level(int agaw)
 	return agaw + 2;
 }
 
-static inline int agaw_to_width(int agaw)
-{
-	return min_t(int, 30 + agaw * LEVEL_STRIDE, MAX_AGAW_WIDTH);
-}
-
 static inline int width_to_agaw(int width)
 {
 	return DIV_ROUND_UP(width - 30, LEVEL_STRIDE);
@@ -950,25 +898,6 @@ static inline int pfn_level_offset(u64 pfn, int level)
 	return (pfn >> level_to_offset_bits(level)) & LEVEL_MASK;
 }
 
-static inline u64 level_mask(int level)
-{
-	return -1ULL << level_to_offset_bits(level);
-}
-
-static inline u64 level_size(int level)
-{
-	return 1ULL << level_to_offset_bits(level);
-}
-
-static inline u64 align_to_level(u64 pfn, int level)
-{
-	return (pfn + level_size(level) - 1) & level_mask(level);
-}
-
-static inline unsigned long lvl_to_nr_pages(unsigned int lvl)
-{
-	return 1UL << min_t(int, (lvl - 1) * LEVEL_STRIDE, MAX_AGAW_PFN_WIDTH);
-}
 
 static inline void context_set_present(struct context_entry *context)
 {
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index 1b6ad9c900a5ad..f85f9110de0d89 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -29,11 +29,6 @@ static int intel_nested_attach_dev(struct iommu_domain *domain,
 
 	device_block_translation(dev);
 
-	if (iommu->agaw < dmar_domain->s2_domain->agaw) {
-		dev_err_ratelimited(dev, "Adjusted guest address width not compatible\n");
-		return -ENODEV;
-	}
-
 	/*
 	 * Stage-1 domain cannot work alone, it is nested on a s2_domain.
 	 * The s2_domain will be used in nested translation, hence needs
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 52f678975da745..b03da83583ac3a 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -483,11 +483,12 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid)
 {
+	struct pt_iommu_vtdss_hw_info pt_info;
 	struct pasid_entry *pte;
-	struct dma_pte *pgd;
-	u64 pgd_val;
 	u16 did;
 
+	pt_iommu_vtdss_hw_info(&domain->sspt, &pt_info);
+
 	/*
 	 * If hardware advertises no support for second level
 	 * translation, return directly.
@@ -498,8 +499,6 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -EINVAL;
 	}
 
-	pgd = domain->pgd;
-	pgd_val = virt_to_phys(pgd);
 	did = domain_id_iommu(domain, iommu);
 
 	spin_lock(&iommu->lock);
@@ -514,7 +513,7 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -EBUSY;
 	}
 
-	pasid_pte_config_second_level(iommu, pte, pgd_val, domain->agaw,
+	pasid_pte_config_second_level(iommu, pte, pt_info.ssptptr, pt_info.aw,
 				      did, domain->dirty_tracking);
 	spin_unlock(&iommu->lock);
 
@@ -528,11 +527,12 @@ int intel_pasid_replace_second_level(struct intel_iommu *iommu,
 				     struct device *dev, u16 old_did,
 				     u32 pasid)
 {
+	struct pt_iommu_vtdss_hw_info pt_info;
 	struct pasid_entry *pte, new_pte;
-	struct dma_pte *pgd;
-	u64 pgd_val;
 	u16 did;
 
+	pt_iommu_vtdss_hw_info(&domain->sspt, &pt_info);
+
 	/*
 	 * If hardware advertises no support for second level
 	 * translation, return directly.
@@ -543,13 +543,10 @@ int intel_pasid_replace_second_level(struct intel_iommu *iommu,
 		return -EINVAL;
 	}
 
-	pgd = domain->pgd;
-	pgd_val = virt_to_phys(pgd);
 	did = domain_id_iommu(domain, iommu);
 
-	pasid_pte_config_second_level(iommu, &new_pte, pgd_val,
-				      domain->agaw, did,
-				      domain->dirty_tracking);
+	pasid_pte_config_second_level(iommu, &new_pte, pt_info.ssptptr,
+				      pt_info.aw, did, domain->dirty_tracking);
 
 	spin_lock(&iommu->lock);
 	pte = intel_pasid_get_entry(dev, pasid);
@@ -747,10 +744,12 @@ static void pasid_pte_config_nestd(struct intel_iommu *iommu,
 				   struct dmar_domain *s2_domain,
 				   u16 did)
 {
-	struct dma_pte *pgd = s2_domain->pgd;
+	struct pt_iommu_vtdss_hw_info pt_info;
 
 	lockdep_assert_held(&iommu->lock);
 
+	pt_iommu_vtdss_hw_info(&s2_domain->sspt, &pt_info);
+
 	pasid_clear_entry(pte);
 
 	if (s1_cfg->addr_width == ADDR_WIDTH_5LEVEL)
@@ -770,10 +769,10 @@ static void pasid_pte_config_nestd(struct intel_iommu *iommu,
 	if (s2_domain->force_snooping)
 		pasid_set_pgsnp(pte);
 
-	pasid_set_slptr(pte, virt_to_phys(pgd));
+	pasid_set_slptr(pte, pt_info.ssptptr);
 	pasid_set_fault_enable(pte);
 	pasid_set_domain_id(pte, did);
-	pasid_set_address_width(pte, s2_domain->agaw);
+	pasid_set_address_width(pte, pt_info.aw);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
 	if (s2_domain->dirty_tracking)
 		pasid_set_ssade(pte);
-- 
2.43.0

