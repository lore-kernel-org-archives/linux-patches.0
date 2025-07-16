Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A3127BF6F;
	Wed, 16 Jul 2025 19:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695874; cv=fail; b=cOXItpC7EMK9WzlqkNhBm2emtx2CPQte461a6UuTG50RMflgYAB/67tsuXhqLzN+ERDiOpUhz5n/VmiZ9A0FQKpsIfqkYEI1VBI67ZcX5/BWxtJz/TBcoytYhDkqjBrf2hGf9DWPHh/1DNdDUHGmSyo4tjlLFacLKf4uglJa55s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695874; c=relaxed/simple;
	bh=EdPM/4TcpFD5B7o6cUoycBdmNg0PqDnKYHZMFFB0R24=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nEqFwChYTBs4XhGuCnn5Db65QpOpfhGT7O1X+Avp6yaBx2E+gMeMbbmFlMoCFfFQp4J5yH60Qfo01xkUEGx2tNkYDHdav3UvduePlgAOobn0Z6wa0TxbYJzVDAI0O7wKNJBvYrfkA2reHBCFRJNUTED9feo5mpBSyZrYpEknyvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nJDbxrbD; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nJDbxrbD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlereDcxBg/ANM1T+Rg+5otI9Vl+UKWrXWxKMJcN+4t4cJXFHKxc7l2eoaScA4Yg9QSqWnUIA0SoHntEpsTwI3yLcwcciGSHE5w57x8LT9xs3EcJcP97I++vUesRZRhTMuvn0q48dt1WJ3y9GbpRbf/qfUv1HPIylVYCWpVuXDgGCC0LG5JWaotwxU6UOWKM3th3kxsCg9vaf4aNje+yhSdthbj8uPxKa2GQnPRpHhta3uXjZN0ffoGM/A9w9oHZBJZUFnxDSdF7q29FgWM7K6/l1alST38XENqIUXDPcfVKldZLx0qvDxn9KrDNEDOi5VHrMSZprrLmY4KadTvUog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZnwAJV94hSYchfb8iL6G1DLCxg4es2eHPnZZcmaUBM=;
 b=BBk1KrJIQHg5UuolzkxihxWR7Zib4lCAHskj3bQ4TvTYycw6hoApo8FfRvZM1w4DmYLl8P45bPIqUVsjNi1JNIVjljiW8n6qhodw2bw+Mykxv/SBVvdNnIbUXiFY+0sdC9jRRyUcci4/mRsSycDI06TmiXziFdrVIO9Te2mPxYehzDph8uG1OhInSWRxl0+KyAAtbhCO9rsxNSLOh9xtozmt/HrcrJ74LeVJ59Q++yv53SIabjn4pR7NwvmEpqzjU+wN3qHR1G39/Xrx7KkvkHAUcgtpIatOYa7mpDIb9tyLHpztpNq6yNBI5q8rn8TK4cHoon+Udzb6xjN7PX0fYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZnwAJV94hSYchfb8iL6G1DLCxg4es2eHPnZZcmaUBM=;
 b=nJDbxrbDTkYHbLSWj8Jr4BaQCWHGgeKBdHrBLq+iVe+K/tk3QW2DK0Y4v6C7X1dwgqlX6sPYaODat/9hm6OSRhaQEn/Uu2oVNqNYGMF6TQ6sMSo70taghUk2EGuQwWJnAzr8jNHaWGN84Eu41VxRrtABUqt8rEUJpoZSe9gZWqbOIISz5nDv+efHapwC+GqijVSmf8nCQvLA8Zo0THCiPTfgMqGQH/sxCB8IDYwWbnG5OepO9b37eKk4OTVatz3GCAZmU30v4q2fT5w7DAwMJphYE54U4xmCffIsNoCDEOV997SEgT4AkNcrp4GVRRsJR9uX22NSOhy4Po+RLiVqJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6105.namprd12.prod.outlook.com (2603:10b6:930:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Wed, 16 Jul
 2025 19:57:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:49 +0000
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
Subject: [PATCH 0/9] Convert Intel VT-D to use the generic iommu page table
Date: Wed, 16 Jul 2025 16:57:36 -0300
Message-ID: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6105:EE_
X-MS-Office365-Filtering-Correlation-Id: 1140b37f-8d49-4106-3374-08ddc4a3097e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9yt+HUc3wYXbTuEgzigZH2n5cn03gln+VbB521rUbLxCkEMS2PyFWg/9dLi5?=
 =?us-ascii?Q?ciYgwHPX10lmoOEE3zSfSCt5xhTPYIcrcN12t0weJLppZXfzJyKE34wVbt5I?=
 =?us-ascii?Q?dbnzqCNvpkvrHlkt8JavuNHh8I7dlgGYCj+1xQxCuveBmlgAIpaP3M57Kvpl?=
 =?us-ascii?Q?yP3ReTmShKyhu9odPxqVqcFPoG27nCZFZsZAN8slWAdxGlqHAFMX6Deg33VY?=
 =?us-ascii?Q?FsedW8+wz7w1OdvwisXoHltVxmnRqjgehkpV16R/v80v+3e+mWHpmVBtmLSP?=
 =?us-ascii?Q?Fjb8m1on9n9JxChSMOiuPst51zQjNuD5rn36U+qvo81cwzyDjbqnBO5poiig?=
 =?us-ascii?Q?6il8ywK0MDfKvBUB+npJjPwXtesprdEH9Tieb3s0cL9wK3NIAf3vng51FmmH?=
 =?us-ascii?Q?EMzbmj/GAkMhVNjQn8I0K7lFFIDvOxRzto9HJZfFWOv/1VyfOfpG3+n6pyHA?=
 =?us-ascii?Q?j8fKmEvXw93wxLspFlUAm2HeOWsNQMp0hfgWJHwabTEIxjLZh0zKImwNjeJp?=
 =?us-ascii?Q?mPBuRo3F9junPsG1hLHT7HTv9cNDltSZOVBcGeqh+GbvDBEU8YavYxQYlpBp?=
 =?us-ascii?Q?bzVw86ALr4EytYvxoqjcGpKfl9Pw1uVhQYJ+GQ86ZUAEO3B8pIfnfciYFKGN?=
 =?us-ascii?Q?8nDZBIBvw5H94EMNJLk1BmEXhkjJtILKYbRy+ViOB+dgcC6tIc8Xot765V3l?=
 =?us-ascii?Q?dWo6oWxrPTYb0qT4pGIbm7MW6MKJHMBqvkJGYhergOBL4kS+2V8n5/+Dsg1L?=
 =?us-ascii?Q?LCgos1SYZD8Tbmn/XC60weZZDupVmj86Yhm/F/ELxmd/j1BsdzJU2ATyzILU?=
 =?us-ascii?Q?IJJIk7XsZ3VrNirxXuV+8/wnsxY449axfJzdli459UM+uePpKW9/qFy0aFoX?=
 =?us-ascii?Q?iKErnIqM5leeMUoQqfSljiM97ddOIP8J+vXMNUpdEKwz1X1X32/sQUF4V6fv?=
 =?us-ascii?Q?Gf+fid36VoQGz6+dOrqDTfJEMrv6PoogpCrpD1yMyvQ/oNGrIQvAaS2J+nY1?=
 =?us-ascii?Q?OdRDw8LD1C9eAsTObAQj51cFRSPHTL6RC+hs8nl41qiExPbaWA7J6hNMBmYT?=
 =?us-ascii?Q?25KTSDuNcVxoQG6jmheeTHsx7iIwVm4cvw6cgsHkmTElyuDansSz3lvARcmi?=
 =?us-ascii?Q?55vfRHI/nUdTMslG3h9QSg+BIs9COHfblsctFWGZhu6/G9aFJmh0LPOiSFeN?=
 =?us-ascii?Q?1TaLh5LomXPI+geKUcgsNucGHO1yGNE0hjEMetLfaqycPc3LxSUE/wPJyBgY?=
 =?us-ascii?Q?WOKtRqcS9uSXrQNTBadns3JabWC2ZT1fXBdIrxvuzyQPp185M79IagtbZtTH?=
 =?us-ascii?Q?lALBQP6lRs8WnE9zUQyS9NhGwNbrrv/6iyQi6uhV+axkG9PhNnFcFxUwQaLT?=
 =?us-ascii?Q?7LiDI5foP8NkGpeyh/X0Unq2y38cubuUcv6BO1nq3lbGmwxhH186dgPCq+m4?=
 =?us-ascii?Q?fcST/JvEmTc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?moeze8eIYgc7A8hEk6RGVLXLMc2BuCG+HRTEiETcE5hZ+tDlbFcFZnIicJXU?=
 =?us-ascii?Q?/8lEsfUjChX/OqPdfMkLrlumz6c+mcE5nzEwOz5MpDr78KujrJYPHv6MGauk?=
 =?us-ascii?Q?9v62A7l2KCC9npJsZxX8LhV78yEpbQlvCDWf7DcBK18wTQr5KM8elQFyzr6S?=
 =?us-ascii?Q?oXnbTUv+uURH2zw0SE58N12zO87R5kgLmYotWvQjb6fgKq3N7fWptmLJOTaL?=
 =?us-ascii?Q?X5SJX4bYMMFN1XthnXRKCw9iKaDT53VvSPSpLoKacn1DE0VJCMWouXTYXxUH?=
 =?us-ascii?Q?xPzlA1RGqwyGP7HfrMdQUnlwWgrfuZmvJBSW3BengpB+3ngh9SBURRmbfOHD?=
 =?us-ascii?Q?EwWgLkB1NRxVweaAez2FRvCG4rj/e29104InBUmQFgcE2v8l5OY9OrPcdyv2?=
 =?us-ascii?Q?s8SOq6dYTocZWLW3raz2ZfXFu+EBqN7wKqY0dOiy+dl4NEhA/H6EtDkIz2aj?=
 =?us-ascii?Q?A9ZJAHanqYGS1e6m5XqQGym8fNARi48WjCYzo5/P1SFJfsnfe88nHp/PPAx4?=
 =?us-ascii?Q?YJodEC5xuxN+inWHQDmv4yLfWQ7+1x9HOy4FsWdhOZoIZvoGJPXfdIF4iVcP?=
 =?us-ascii?Q?zvRN+I67wok8vmFcMeBpwoT6hz9y63jjG5Vq9GBQc4j/bUVfNis1OHd0F6MS?=
 =?us-ascii?Q?9fdRHcVvImVt/w01lkwBJD8mKbzcYs+8zAvdNCjyhLsYpSssOn2wwsIR9Nte?=
 =?us-ascii?Q?6QEfCd10v0FfxVx17dXyW+RXVL0+2gge0pkdUTR/P1XyaPAGS5gw0bzTGIFf?=
 =?us-ascii?Q?AO2JZ9HMikAxaslysfc3oNVRgzg+dNxLFdDhJMFasok5UT1acMCs0ap+NH6P?=
 =?us-ascii?Q?0u3fJKuIMhjk3Mlw1F92V0U5NUQDbBrDIqU9W33O1sjTt4oqPRy2aJSDQui8?=
 =?us-ascii?Q?Tj4uJYu3pdRnOaBG2yRAamk8BA49i3OlRPG+JG4A2n5gMJK+/TB49kRFC7HB?=
 =?us-ascii?Q?JV0wTJxntPCzmnblfpe8c3cFreH0HymXI70dHwdgCA/I5U9Ykll+0nYvAUpE?=
 =?us-ascii?Q?KnuGgqKeWxSWekvu0xABnV1WLkz5Cm4aoYpwxTWUis703Hl76liHLJzwGPSF?=
 =?us-ascii?Q?ap2M4F84kZ68j2TOyJjXXkmS4nkq7tS4GuKG/bpug3dBS0sXZup8U7h7CyJr?=
 =?us-ascii?Q?8BOHTWZ2OU7PYOyZfSPVla9LibJrro/RVVBDJks2tTUjg5JG/4wKEcSeFpgt?=
 =?us-ascii?Q?9a43av16EBkP39/qg2ag0XtGTqYCKq/o863oCzxqBR0YRUHusONdcuVS8qng?=
 =?us-ascii?Q?8JJEHmZnNvHjRCHnW6ZSyhhSeym91QH4P6EGdCq9pfzTP7CjG8RWZ07CD8G5?=
 =?us-ascii?Q?X9H5nCm7SJ7x7QVsnMrOUedR96DRS0YtfHHDgAajYbeDX5YKK7VkWaC6w7dz?=
 =?us-ascii?Q?NvIbZeUELDYFe1D/N7LjeuJSfA9gDSucW2hDqBesbYjmI/jtasKJQAz9G5it?=
 =?us-ascii?Q?bfnIso9o0MWLtvxonxJCZ3h2krqNT0hog4zcyGanXzPhVVBfL+NXMkEtpGkr?=
 =?us-ascii?Q?j91j+yQzqinkmPobB7RdyIWEQBy44yamLB2w+WZ8pu/d4UqLBpdQLTdRZNSQ?=
 =?us-ascii?Q?MzTJNunVp23dwM2U7geHWy1zvI49QmCiGkC1eRIb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1140b37f-8d49-4106-3374-08ddc4a3097e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:47.7721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/nTXSvSjD5hI3EXiBGP0MgZ0p35DtVzloLS5gw6X7SfHrzy5bvVIO5Z0AAVM+yt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6105

Replace the VT-D iommu_domain implementation of the VTD second stage and
first stage page tables with the iommupt VTDSS and x86_64
pagetables. x86_64 is shared with the AMD driver.

VT-D has HW that requires an incoherent page table walker, the majority of
the patches are adding generic support for the required cache flushing to
iommupt. This is modeled after the existing ARM64 version and is intended
to be re-used there.

Applies on top of the AMD conversion:
  https://patch.msgid.link/r/0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com

This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pt_vtd

Jason Gunthorpe (9):
  iommu/pages: Add support for a incoherent IOMMU page walker
  iommupt: Add basic support for SW bits in the page table
  iommupt: Use the incoherent start/stop functions for
    PT_FEAT_DMA_INCOHERENT
  iommupt: Flush the CPU cache after any writes to the page table
  iommupt: Add the Intel VT-D second stage page table format
  iommupt/x86: Set the dirty bit only for writable PTEs
  iommupt/x86: Support SW bits and permit PT_FEAT_DMA_INCOHERENT
  iommu/vt-d: Use the generic iommu page table
  iommupt: Add a kunit test for the SW bits

 drivers/iommu/generic_pt/.kunitconfig       |   1 +
 drivers/iommu/generic_pt/Kconfig            |  12 +
 drivers/iommu/generic_pt/fmt/Makefile       |   2 +
 drivers/iommu/generic_pt/fmt/defs_vtdss.h   |  21 +
 drivers/iommu/generic_pt/fmt/iommu_vtdss.c  |  10 +
 drivers/iommu/generic_pt/fmt/iommu_x86_64.c |   2 +-
 drivers/iommu/generic_pt/fmt/vtdss.h        | 289 +++++++
 drivers/iommu/generic_pt/fmt/x86_64.h       |  31 +-
 drivers/iommu/generic_pt/iommu_pt.h         | 137 ++-
 drivers/iommu/generic_pt/kunit_generic_pt.h | 110 +++
 drivers/iommu/generic_pt/kunit_iommu.h      |   1 +
 drivers/iommu/generic_pt/pt_common.h        |  29 +
 drivers/iommu/generic_pt/pt_defs.h          |   3 +
 drivers/iommu/generic_pt/pt_fmt_defaults.h  |  62 ++
 drivers/iommu/intel/Kconfig                 |   4 +
 drivers/iommu/intel/iommu.c                 | 903 ++++----------------
 drivers/iommu/intel/iommu.h                 |  99 +--
 drivers/iommu/intel/nested.c                |   5 -
 drivers/iommu/intel/pasid.c                 |  29 +-
 drivers/iommu/iommu-pages.c                 | 116 +++
 drivers/iommu/iommu-pages.h                 |  39 +-
 include/linux/generic_pt/common.h           |  24 +
 include/linux/generic_pt/iommu.h            |  17 +
 23 files changed, 1065 insertions(+), 881 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
 create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h


base-commit: 67fbcacd065fa5bb51f3e4432eb1e7468f0be992
-- 
2.43.0

