Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2055.outbound.protection.outlook.com [40.107.212.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89FF2E62D8;
	Tue, 26 Aug 2025 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229221; cv=fail; b=dCaHk+TpH0XEKhuuxQn3awE8/HOqGYRu28bbuS5G00tB81TmJ0ai8MU5GGL5sl9FkW0IK8U/BC2aYcScn6agnPBEGOGoQUgsxHHR3RzG9Gj19T0CO/GrduJt4YJv80k8I+QLRiHv7Cx6PZyXBv9lHDtrMC3XBMJWCApVeJ5tCdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229221; c=relaxed/simple;
	bh=gIjPBjWJjZFk9BlMQ/lbe9KBpUc4gC9SBs2jBiBxuOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CswlQeO5YhvM6f1xSnQ++siTRBMVQ9G7T162A8J1ddEaDXPXzn1oWmiIveNm1a8O8yMEtVOb3L3G6P6K9fUiL1bsi3c2BAOGV8822bCIISAwXfTwcCGGXtHg6AkTdkK+Ni8M3Gc2CpUXZ8IkQj5inXF2KSHyxeBqOz18jnj4BsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FnXFNVeh; arc=fail smtp.client-ip=40.107.212.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FnXFNVeh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PzCl4syOl5+hIiODANXjcd3OQvsclUGdTFmburoLZDVLKd4crUg9XRmAvUErqxIUEKEVPfilaWhqPP6TV+L0ZOtLRhIxYyxPhC7EXcmCvPVzv0qtDmGpQkqMUd+Isfd/OG3KijcjgUOtRreuRCPf8Gx/2nT4DJn0VZw095ML973kpITDQxGCyot/SNJT/fCScsudSNSqO6MVi79oQ5NAoQVNvMoPxPBTzOO6WDTdqyXcMOaVymOqVCTptRnXHFXCeWk3zLxAYOc44a96QwNClHjZ6U5GWskkSTpga62w2b49Xw9hnYj5OUWfv4b67hOiXspW5gJcBb2p4qZUOnLCqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ypt11R6c5jOYjHY1ZK3r3Zmj/s5ZcFfCiYoSSEDyfE=;
 b=FrOh/oL2Au7RfF8vzQ41zmC59UJUXzNAAaW6NSdv3e9L/pIdx+rXC9lDsVVOn16fCKhpCeuj2YuKOOTassKxhVQgGRTwlAJN++axh/02AH4ja5zXqVIsyno9y16+Kac8AOXTpCsvERnNsqsw5N1NdPHGavKLK1cd7bAqUc+/rMWs2EkZnm4u8XVmSgFoh7nM6WvfXwENRj0DkCxj68UpvX9Ng8043mETzzve+xlOi98T0BGQiPcTNznSwmczbfvTMXl/dIG9dxAXZP6+wmH8GXSUJCO3kYOTC8tetjxiVjrserjENZNN4GbkDbKPL8b/lslGHuM7jrawRYu6MPDRjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ypt11R6c5jOYjHY1ZK3r3Zmj/s5ZcFfCiYoSSEDyfE=;
 b=FnXFNVehW3AcZIw7AxtsADsQVekxWSYvu/VL7ZGcutdpXyjiGHMkIUO4nFCl+Upm1IdfNrBGU6a2tSrcM7CgG6jAuveJfIfp6j/s5WouF1jx0rce9g97MviAZeyRVVeTi06IL5WibwnPfNuJdJMPesao6NLKaE7HPTRBmtFhHknLOVx+5noWgDVKB9PgWK3QDpABqtwsOOGnO99ihIHUUbjrJ3W/k+vH1DzhVSXSVU/8gLrYc5Fu8Iu7DKU/2wULaSEBH3Nt/M5H5HR+lrvJ1ChbNXI0yAVeYSAVXuGtEJaKswuNQZ4YVJLe96TCveku24pq4zy7pXtzI8qx9QNvvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:47 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:47 +0000
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
Subject: [PATCH v2 08/10] iommu/vt-d: Use the generic iommu page table
Date: Tue, 26 Aug 2025 14:26:31 -0300
Message-ID: <8-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0104.namprd03.prod.outlook.com
 (2603:10b6:a03:333::19) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c523024-62e5-4f71-4d9f-08dde4c5bb75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zbpHl8+5w0qG6mBTITFzQCVH8kTBgutT8zaav+WlOvtnZj9KvB7Sigv3/945?=
 =?us-ascii?Q?qFzoX9xMG40JvjKzbgcSjI/aajZOINLsV1KhUlFxshzW0bCLFDuXY6zgaYRa?=
 =?us-ascii?Q?5jfPHx/eJ3FqlykfymAa4y9nC0TiKVhD0nYphf1uheIbPu6vt8iG9b6w41IG?=
 =?us-ascii?Q?S/YzH2+c8z/EVdnK7Uq/BBAyag6OV8dX9lS2vJqhYiRBXRqZmkJTZ26VLxVD?=
 =?us-ascii?Q?uoK4d7ClKA0N9DRFw2bOHqrGe/4HRKRBgARsjJ+aic4LfmKIwLR7SOKJh+Tg?=
 =?us-ascii?Q?upaYTglXD/AyR8iJwb7yC3qS5tAxyeyhKeL3jXWDwMaF2GnaPNF1c1TbyRvo?=
 =?us-ascii?Q?B0Xmv5B7g234HlZLErO+y4ZXGBK2jDm0XWZ+M5YxrtJZsm9nr/4olN5oLb2W?=
 =?us-ascii?Q?YV0dF8SVuU9wzmii94RhsYPwvMXwe4/YSgiH0VYbdox9hYv7E7W/UFpS/7A7?=
 =?us-ascii?Q?xz6vIw6UFadLiK0lMDzYI1QhhrRLdllqOIy6qFK6Qx28wxOG+kZ0eGyn5h62?=
 =?us-ascii?Q?R5m1WgeP4uD4CCpDdqea39mszNvKOHvFy4Swg9EY0l0ErmcO3x7mA42GmACs?=
 =?us-ascii?Q?j0Y+TpdA9XrRMDbVlu8tHy+SJToqSHZPzfPggLf4KVZGW/jGusOFIaN4lRCk?=
 =?us-ascii?Q?oSyjH2JQaFBxjf4an8auDBZJXARPu/y+1rfIhmYTxTUwmEE5IrZtQNda/Qm9?=
 =?us-ascii?Q?8ksTNA2rZOTVBWtXGy/D6vSXRNLGsr64IEQTPOyNDv+24X2OlXURdGVJjkBH?=
 =?us-ascii?Q?zFFJL0hHQ10Bc6qfY+hw95MyqdpfzazNfwwwEpGdotXFoGI4d4280l2UmtKh?=
 =?us-ascii?Q?psh1CxUqQ9hb9Kz15R9ia4jqIQ/Yn6lZWZIACscNXZ64ZzLUC8Z9EAnY6x2H?=
 =?us-ascii?Q?4bm1kRiZfzrOo/CGtA/nx6OeADuvRTQQ2FV6Dj+BvjaZYCqdizl7e4tRaNJy?=
 =?us-ascii?Q?iTmNP8ElwTYieNI40jfIvwA7EnVYbLFk118l6oFA/HChT3MESosOKOaTjAil?=
 =?us-ascii?Q?Fsa1fE+Px2FseuUGqGstJMY1yhCHKR/3Bmxg+WvOQEjgvtEPyF0K4HIPdsWt?=
 =?us-ascii?Q?hhHyrY+HyaZ5FhbaytQWrs+zSZNJzqobuckqHP8qSD/CmV37JrPHLkdnZ+8C?=
 =?us-ascii?Q?sJ8F5thtX72JfSD3V0a8jO3au6ykzuLQSxN1UvrWkxqPesZKSUhW2FLbhC+M?=
 =?us-ascii?Q?+YZchvdwBFSb8B/hBBAUZY3xxMy7dwJw/bH5KfcsX0kIZcc0pgBntJ7/Q+2p?=
 =?us-ascii?Q?ZalqNP3G8lZ9lXuAeL0svab7YsD8q5KQEbLycNKqDgt/NBriGhx1SV8CEOgR?=
 =?us-ascii?Q?MIGpzsvKWGqYp5yO3tzjkjYTgJV1jhvTypZZ4/dZ+wyuwZuoJMhS2/nPrvtb?=
 =?us-ascii?Q?j11sJ+e1fcdCpZ1LKR2J/ISbT4cHvrdBREe7VFOqHAzxocJgz7QniLZqzKA3?=
 =?us-ascii?Q?DX5pM3vhrJg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UvmA3x69o4yTu3X+oUTzQ9jDxfYL267GBY131ZQ1Fstg5dm6Duyw6WYr//BJ?=
 =?us-ascii?Q?1PY1/TQnBqlwv8q51XiCSWWf5AlV591TpkphqrKwRKHYlRq9XGMCOHTY8RLM?=
 =?us-ascii?Q?xdplGPHhVEj5xH/CTg00q6cQtj8T/JnggqwszCCXeS0m9NIH6w27zAFv11AJ?=
 =?us-ascii?Q?t51hdMFSdanUTL30Zr21glqWbQe704u3+drXZfX49/o9I416HQAHckIVhHe8?=
 =?us-ascii?Q?F5yaPDqKufzi3xMt7H0cqIgAWF0LemyxYfVmOMVFGeQizxWy7Klz0whs275u?=
 =?us-ascii?Q?gjegv6dwiRUjalztkOH3mt3Ii8Kntf1U/T0wuzSSNK7cma5k+xNDYSHOg7vn?=
 =?us-ascii?Q?8bT64WPw4o8+/Pebo+UD3pErUc/ULazZM6ziT2jmKqhvkCDcCsJXhxy4WIbR?=
 =?us-ascii?Q?NHpHopiMZSCvbg9Ty2QsO9TQMI8/NFm5HiNXq/Mb6dRaBAC5KBuQgEQTyWGX?=
 =?us-ascii?Q?WE8kV0JgHOfoYbqOFippyRoO7FBgEThbrpDuvy8Dt04L+W3Qhb2VWNfsewFa?=
 =?us-ascii?Q?h4ns7VkVzqKcPHjMJqZ+Vhp35JRy2Sl3S/e1WtKud38JNXFZEmprYK2jEKNP?=
 =?us-ascii?Q?tbYtYvplrr/qVml3shPDfzaOuQrYmrBknsTShEqPAugrfFQ4/FCxFGhAcFd7?=
 =?us-ascii?Q?oANv8C6MeUGSPgE5NV5lh2fhztMHLCEcUBtNkTlHcguX4zLpq8pN83LgDJuW?=
 =?us-ascii?Q?MJw+bXXpJmLfgChBRC/XQ8CmrtTY/osA4Ur10fScuqDXyRMPi+PJeGdfSocv?=
 =?us-ascii?Q?A+Qe4K7w3+McUKZlYsCThtnYxPyos/9lqEyrpowgVv1JKro8YQmVk4+p9QzG?=
 =?us-ascii?Q?+6GFLjLoGx4rV2ZXcE2x2SBMG5+mKpsAKjEZrYxQCuzvNnzbv06xG/gBwhJN?=
 =?us-ascii?Q?VHvDjYkx2TXkQQhtVmHu3azjWatTTEhnsPA6CffN4YDpKsVnCfJSzgPkBrXF?=
 =?us-ascii?Q?x37I3KhEl4X7kxevZf5G5rUvWynSUbk7KPaJAxhkT8huGZcHfwrUxMGd6ti8?=
 =?us-ascii?Q?4V57X9r+KqoqqgY5MG3x9bijGVHYgoWj61zIcgTe/uOU2hWikQ4sbZ9AqNLN?=
 =?us-ascii?Q?qwlO5wZNRDWZV8SgYfTdhAmbP416JpYGvP7C81S9N2DzzPKl7Jh7+GyEIUmY?=
 =?us-ascii?Q?fSvOSzX4Hi6Ku43QMYc0fq4+7j0LFHK6sRWEaBvtkuQOULT+Rog79hJgOrAI?=
 =?us-ascii?Q?aQEE0IdF69+AvVHgwmtVN+SWx14xOx3v8kx3UlF6clPLHZoRQnbeOdhOKTU2?=
 =?us-ascii?Q?wozU7Knt3eDfY+gxqVtI3ryW7Jzf6WfXR68aXzC+dl1FgNGSLks8mguHyFQC?=
 =?us-ascii?Q?pxrM7qTK2c/LN6XLpwZXv7rPbhNHHcVvR3AGZabr9jyTYg/tA2KLADBXjD7m?=
 =?us-ascii?Q?CddVzFvFpsSw4+ks9NpCGBg0LY27RqLbp9WHUAUwniWjsLBW7iPk3loKETms?=
 =?us-ascii?Q?AaLhZqPq8Spmwhwvo18m/EPQ2ST4N1VzZpEUnxKmZ6jvMJnDrBdQSOWEX9h0?=
 =?us-ascii?Q?Sfg88+GoBFo2NY3wU/Yn1SVyDwE8RMRoBYx1sOSzAFoDWbwhPrUmyfDSfrkE?=
 =?us-ascii?Q?KylcyPeK327bdHLixU56/pras1/Qs9aJk+pWtYTp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c523024-62e5-4f71-4d9f-08dde4c5bb75
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:46.9589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4403M6eqjqXIDLN8DwT+EcDZgH9KG5OzJc0VAynijhS8BFUh1ettN4SjfS1Qa+F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

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
- A kernel command line parameter "sp_off" disables all page sizes except
  4k

Remove all the unused iommu_domain page table code. The debugfs paths have
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
 drivers/iommu/intel/iommu.c  | 896 ++++++-----------------------------
 drivers/iommu/intel/iommu.h  |  99 +---
 drivers/iommu/intel/nested.c |   5 -
 drivers/iommu/intel/pasid.c  |  29 +-
 5 files changed, 175 insertions(+), 858 deletions(-)

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
index 9c3ab9d9f69a3e..6a269d201a614b 100644
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
 
 #define rwbf_required(iommu)	(rwbf_quirk || cap_rwbf((iommu)->cap))
@@ -217,7 +210,6 @@ static int disable_igfx_iommu;
 #define IDENTMAP_AZALIA		4
 
 const struct iommu_ops intel_iommu_ops;
-static const struct iommu_dirty_ops intel_dirty_ops;
 
 static bool translation_pre_enabled(struct intel_iommu *iommu)
 {
@@ -285,13 +277,6 @@ static int __init intel_iommu_setup(char *str)
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
@@ -353,23 +338,6 @@ static bool iommu_paging_structure_coherency(struct intel_iommu *iommu)
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
@@ -556,13 +524,6 @@ static struct intel_iommu *device_lookup_iommu(struct device *dev, u8 *bus, u8 *
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
@@ -707,280 +668,6 @@ void dmar_fault_dump_ptes(struct intel_iommu *iommu, u16 source_id,
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
@@ -1460,13 +1147,15 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
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
 
@@ -1489,8 +1178,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	else
 		translation = CONTEXT_TT_MULTI_LEVEL;
 
-	context_set_address_root(context, virt_to_phys(pgd));
-	context_set_address_width(context, domain->agaw);
+	context_set_address_root(context, pt_info.ssptptr);
+	context_set_address_width(context, pt_info.aw);
 	context_set_translation_type(context, translation);
 	context_set_fault_enable(context);
 	context_set_present(context);
@@ -1537,172 +1226,6 @@ domain_context_mapping(struct dmar_domain *domain, struct device *dev)
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
@@ -1764,14 +1287,14 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
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
@@ -1779,7 +1302,7 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 
 	return __domain_setup_first_level(iommu, dev, pasid,
 					  domain_id_iommu(domain, iommu),
-					  __pa(pgd), flags, old);
+					  pt_info.gcr3_pt, flags, old);
 }
 
 static int dmar_domain_attach_device(struct dmar_domain *domain,
@@ -3246,23 +2769,9 @@ static struct iommu_domain blocking_domain = {
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
@@ -3277,48 +2786,6 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
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
 
@@ -3326,7 +2793,9 @@ static struct iommu_domain *
 intel_iommu_domain_alloc_first_stage(struct device *dev,
 				     struct intel_iommu *iommu, u32 flags)
 {
+	struct pt_iommu_x86_64_cfg cfg = {};
 	struct dmar_domain *dmar_domain;
+	int ret;
 
 	if (flags & ~IOMMU_HWPT_ALLOC_PASID)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -3335,10 +2804,22 @@ intel_iommu_domain_alloc_first_stage(struct device *dev,
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
+	if (!ecap_smpwc(iommu->ecap))
+		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);
+	dmar_domain->iommu.iommu_device = dev;
+	dmar_domain->iommu.nid = dev_to_node(dev);
 	dmar_domain->domain.ops = &intel_fs_paging_domain_ops;
 	/*
 	 * iotlb sync for map is only needed for legacy implementations that
@@ -3348,14 +2829,52 @@ intel_iommu_domain_alloc_first_stage(struct device *dev,
 	if (rwbf_required(iommu))
 		dmar_domain->iotlb_sync_map = true;
 
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
@@ -3372,15 +2891,46 @@ intel_iommu_domain_alloc_second_stage(struct device *dev,
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
 
 	/*
 	 * Besides the internal write buffer flush, the caching mode used for
@@ -3422,14 +2972,7 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
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
@@ -3446,6 +2989,16 @@ static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
 	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
 		return -EINVAL;
 
+	if (!!ecap_smpwc(iommu->ecap) !=
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
@@ -3462,7 +3015,11 @@ static int
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
@@ -3473,6 +3030,19 @@ paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
 	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
 		return -EINVAL;
 
+	if (iommu_paging_structure_coherency(iommu) !=
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
@@ -3484,6 +3054,14 @@ paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
 	    !dmar_domain->iotlb_sync_map)
 		return -EINVAL;
 
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
 
@@ -3493,7 +3071,6 @@ int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu = info->iommu;
 	int ret = -EINVAL;
-	int addr_width;
 
 	if (intel_domain_is_fs_paging(dmar_domain))
 		ret = paging_domain_compatible_first_stage(dmar_domain, iommu);
@@ -3504,26 +3081,6 @@ int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
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
@@ -3553,110 +3110,6 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
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
@@ -3666,24 +3119,6 @@ static void intel_iommu_tlb_sync(struct iommu_domain *domain,
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
@@ -3725,15 +3160,15 @@ static bool intel_iommu_enforce_cache_coherency_ss(struct iommu_domain *domain)
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 
 	guard(spinlock_irqsave)(&dmar_domain->lock);
-	if (!domain_support_force_snooping(dmar_domain) ||
-	    dmar_domain->has_mappings)
+	if (!domain_support_force_snooping(dmar_domain))
 		return false;
 
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
@@ -4297,49 +3732,6 @@ static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
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
@@ -4457,27 +3849,23 @@ static struct iommu_domain identity_domain = {
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
@@ -4792,3 +4180,5 @@ int ecmd_submit_sync(struct intel_iommu *iommu, u8 ecmd, u64 oa, u64 ob)
 
 	return ret;
 }
+
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index d09b9287165927..df069e4074c92a 100644
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

