Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61AE2E7BC2;
	Tue, 26 Aug 2025 17:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229211; cv=fail; b=JNuEb0rpt/OtSIvXIXYDzd3f0xJ5Hb+HvtRHwC8kLo+XNikW79+h9IZLKYlviDPkSGM+JWAc1AQwT1Oqasl/lFWbCWln1MjI3dUXuGVqzFSVtX77gl9CqQkWDpxEUNU3FFzrm9H74xoxlT6IjuKe+wuktOL6V3T1ftbXiP2AlcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229211; c=relaxed/simple;
	bh=5tAWL7e9f9eupxGkY5u7MfQdXS0Ljh0QkojbxzTtA0U=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=niXH+iur6xzGboScnqg5NlySbHE9xNnrCndegyUdiOQljbQkS4/s4KHNmAQg6AN87oCZpoSviIbtuyEdb6BObRyZzLntmw+29hDf+UziRLkLT3BTlYUMUu/sdu6JhPCreARD7zJM64qjG18vONYvaMBTRb8vWsfHarLWC+AKUHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iu1jW5pa; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iu1jW5pa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wns/NWcBpTfqOw9UVPpEFybwD7m7LAcyChWIWxzYLXHULWj3cKUgYbVdoVl/i0/ueOa/tpLxfmowrE5CrdjNjNF+0R5XCNdfSLeLcuRAdUVLo5sf9gf9GEhIrObPz8ZYjWI6mxrUtaBGJCZpPTgjCjr9LudEGMh4Abgi5E5FFEFdiclVkAXP++lYwxFfp2sV4Pi5ic9bD5bmcYZbxYnRn5CNWmKbawQNJ1RUKKydN+0bkUEniUf9hBc4s47JU74OdXMlja+88wNxw0kvT0x9lqACCxcHfUs6HVZ8iI9rV3AWrZQf1CRmviDij2kK0+wSYGLKsXfdtxv5xN8QBzEAgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4cHQTcR960sJN+608213gVNnaXUBMR4W0HmQVDgrnoo=;
 b=PFKgLfdIMZIV+rC3nnn6faNGFTjzUAneuYCccYtH9E8tHropuLdA/mOgBdjB6qbpYM0vOUiNTbVOgLiY1o7E3UZfjcfoWjGVM9P4a7uQ0dg37exo8awPj4jCW8efBcARb92A/uHxChpPkDCx7WVkQK+GLe0CQKjfx+Z5QpQl4c7BVBlsPwnYaJZvaI1bjPwxVYVAEB6/DiE1EPta46VgyTqVX7wyc9Er+YyeT60cSLtLMWuCcd3xoqXKncgvMGLpNhwrVCvQvcrbgRV52IQ0YRoF9EiduaH3ue3KLpfe48TUlUJuwi0abPuZqUiFdz281x1DeeBgM2jSzOoKMD8YaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cHQTcR960sJN+608213gVNnaXUBMR4W0HmQVDgrnoo=;
 b=iu1jW5papguDmYuIMYW03r1xJHeaMDv9+IG3eIYWUBvpB1K1D2Lel0IZY+fOVxWiCWRQADFNDpzWlAItEs43GLrG2FZoacc0iGqjMDwAWlrHhap6VjIRl8Be7kfnQEjNlM84nUSGoBJu9PcIlYf9ebDr8+9Skx+JMsMDIllVvlUvdxu3ICu+ZXkjhAnMoCMQCflW4mbhMgcq/CXPuRhfLemqmoTW1gst8TojGEO3QyWcHUrQNa/WkT0VxTMQNs3Z8Wh5lgXmWlGXNb72GERq8DXc97epcp+PPNH/6EeV4KBX2QRPy5nY/DcYp65ppsPrrU1Ahkmjpfu6tLU03OIwnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:41 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:41 +0000
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
Subject: [PATCH v2 00/10] Convert Intel VT-D to use the generic iommu page table
Date: Tue, 26 Aug 2025 14:26:23 -0300
Message-ID: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::40) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: bc10292c-a907-4b00-12be-08dde4c5b852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fsmDaSxXw6Y621fJQuGl3S/VvR3JsyUsJ3GLsDI5zOTRtUOoEZtP7ph6xhZ+?=
 =?us-ascii?Q?RGG318Xfm2e1GVjKUjJU2R3Id4mHtAGum4VyCD/beGPpXtZIDqOCOf0TI4vQ?=
 =?us-ascii?Q?p8oSZpSSMqrjbZLYS06mFl/kduo118OFkUKJ7n8r+3a3y/vL412ium/ZNLDs?=
 =?us-ascii?Q?JidqXKaMeti6iVhy9MStIlrPYvcA0EEOAPxFFG4qv5oKdxpxWe/MIfu7VC8Z?=
 =?us-ascii?Q?KyZP8630GmXZbcd/goc7eT35YuPbjKpKnoYBBkxSfE4KyhN5iR87CPswJDos?=
 =?us-ascii?Q?SQr69frUygxic4HJ2uTz6ef2eQM0Yjy0plSn415GC0Lih5gME43Sk0uaxom0?=
 =?us-ascii?Q?AyUZn/psimBZR+BhdeBjVSF4iM4bqjKVgz0LAAopGWvwYk9WzH8NVjn+Tlyu?=
 =?us-ascii?Q?ABxi/o53DYbSzg78GPaX/oVTIUrb+Q4k6fS/bivnTkE304ZSD2g+JcNG7TtI?=
 =?us-ascii?Q?HrARfODNrUZS0v9l2FAeLduEb5PckGm9tiB7EcEnX+F3xVqt86KeXXqGZYBF?=
 =?us-ascii?Q?sFS+7Gbo+apkY5EAp7KPHAwe4hEMNAgVtgDq4YThAUfaM9oX4Z7hoqq7hw1M?=
 =?us-ascii?Q?wy59Ey0F3EgC7yaJSyuaO6FwkjvzRI4F0R3JDyXW43EKdhL0Vezk6szXaBQ4?=
 =?us-ascii?Q?nimo5Vo3wpYojBW4XWhOYl3sqr4SshLS/7M6KJaREecTtUcomvli+bu/l152?=
 =?us-ascii?Q?iC7hKiNZBF2asrp3ykmwWs8dtfr9I2Qrzbh8YD4X54uHdPbtdrF63bo0sSzT?=
 =?us-ascii?Q?uIPY55K3D3+dvIoCLJlCe1bjhYbDkne8dyBrQigSbAMmuFvWCPmc+m8NDPHZ?=
 =?us-ascii?Q?tNwHuPr3XIF4qapszeCftOsVsgJNe/QqCybAVIFK+Q9si7t0oHlKhOUxNSox?=
 =?us-ascii?Q?Foxa7Fi4/7tFfTe6hWFpStew6aiiQ5IdBSCPu6ryRFlaY1DWoBThty6NH55R?=
 =?us-ascii?Q?3N3RlftEudkpdwKRRlMV8KKhjJLXQwDyYNG8OHA5eZq5OjFcgYEpHmGmlKcA?=
 =?us-ascii?Q?CMpE5Qr3kElNT+D2UagxtSX4WgKM2pSsA6nm949jcixQjrlKuSYkNKB8K6Kh?=
 =?us-ascii?Q?TwDssEZjKZ6XEBmepRk9wtG3hKVHNIp04XnhCIuRqTwZswd9byx9q+B4Sig2?=
 =?us-ascii?Q?rkdIjrTwRg0AoJUEq3Lb/wzs7oPmT4KsJDq7n/rJcI3+VEchobOkDEc+UgOP?=
 =?us-ascii?Q?NCc7CYs6Nk9igyb4kr7uc9nilc99L1Un+eeW8bf3gl/jOsyU8tX/h79PGCR7?=
 =?us-ascii?Q?M7Hw99myroeawoPhL8kzUqbDAEgU3U4pbX1TDi8/btT5xYGGgNGm6hoSwT8c?=
 =?us-ascii?Q?tKhmjayygGstw2QDSgzHr9Bka0msA6R4qsS51vgQD7qJ5EEywWhJbdCTbfV3?=
 =?us-ascii?Q?BKQGoOljCTiT30Qdz8zZyp5wOPvfrsEqn+DX79EvAJ/BPB5SCHEGF7ow6cyf?=
 =?us-ascii?Q?FStxkZIeKh0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vH8/o2ZWgRK5qNHtBdLgPGirdZhFhVKr5aXhN6U5Guy64p3VOTpG8aO8IXvB?=
 =?us-ascii?Q?QjdZ3BdhPyli3JS6XXzKFlv99Obi/9FfyfetVfth4If+WR0Saehi2YGJvs+c?=
 =?us-ascii?Q?66kzOuXtCWwftM/Dcces2ZX7S7q05gcQ8dQow81Wg6kzjg+CQmu1dhxixFXl?=
 =?us-ascii?Q?FRNVwTNlfopqYf/KQAr9NoyHx9FxxuebyZOYcCLdIjQy75FHKw+HPnbfZKaB?=
 =?us-ascii?Q?btB221S6kyD3MEJZ2lC0Jcpnhvcfi4hlq81aIBl3kqogxZyZ5KZSQDnTTAeT?=
 =?us-ascii?Q?1q9Oh7aKPHOxBGuyrvFFaIQcAfXEV05lu62FlLD2FgVK/4a+9FuVIPKWCBmF?=
 =?us-ascii?Q?huF6aY35PssKNKdAIdEYKLj2dveO2+7jwWJAHP046n+VNkQtzqgdsBgiMo8P?=
 =?us-ascii?Q?0tjqC4hIYwrgC4BVI2E2RERGQBsbOMMaonxGgfRyHMvIfSeh2MYyIiMUmaC0?=
 =?us-ascii?Q?0hdpETzNM9nsgmtsgILSynKb7OoyPbbRYGwF9V+MWkVw+Pkrvi//e/ms4G9y?=
 =?us-ascii?Q?2qno/Ey4QvSy4B5KCSlOpldcS1rhb9fNd0c71eL/JiMEhtSXuU7Gkmv7XWh/?=
 =?us-ascii?Q?E7pkuk7ic8qIvCAIFzYZDTXQ7G0ddfSYDTV0YzIqvvz9FvUm2Yro+fPlcFZq?=
 =?us-ascii?Q?1VsfkK7UjMekZjDiZ9bLGTVkTLFKV4fI3q1nw50KMp9IPhOnb/vBbIOKM9b6?=
 =?us-ascii?Q?27qq/f8pVcRDrFcEeM3p1n+q+lnKZtUR0fI+ZN9iUK4AsNTRsiPMT3ejV7ZJ?=
 =?us-ascii?Q?mxL68bQXv+aODZE8NQ99uDnKyMc5ML+0MT+HojGLhMzXUe+DP4hZToMHD/n6?=
 =?us-ascii?Q?0OoNjwi4TEbBif/sj7cBxmEfGRxjb+aKopvG/DHozTmwHPCwFyG/ZH04VSw3?=
 =?us-ascii?Q?rE39O72j1HLLbxX245NxOGZG5OAeCTmwMFOcGlECZKUA2J6exnpOxJtaEyOy?=
 =?us-ascii?Q?pGcDBnglh8eN9OmfNsNbriuO6i4ILIzoM5sxIjZdCbQjC62xRutACNFpAm8r?=
 =?us-ascii?Q?BSQ46M4e7AaDdDbBV9FCtKQEJiHmFzwLnLp7UFhU7tGcaxhaExxhFEHkD9VI?=
 =?us-ascii?Q?BkOuBuYD3pTKR5k+7LHr5/9sEnmMdUsy1WG+i2BvHXwf29BcPm9W7W/TT7D8?=
 =?us-ascii?Q?V1acmsYL65Yv6X5KHJ60MSatedxSI+aeJ95HXufGTvrcu0L8jIa1+vRMFcoE?=
 =?us-ascii?Q?L+Ju24Hw74gK/lsmlXIgOyKPjNTpwVFY4G4MtvHRo6WaYCOKqGCx5ok+hyI1?=
 =?us-ascii?Q?u8zq9nrhm0GSrpNI3vx8sFfGtV5+fYnR/oOQuYpEBsLkEFd23J4d+PvGSYew?=
 =?us-ascii?Q?Kec8dgecfwmdTQXoeTyXuysRX4HcMOybdVmiiQ58rVwKpylhiEXeHv34/b+m?=
 =?us-ascii?Q?NHG3u9P0PHiVOUHwohPD0PbxPiHDa6qlx7maLQaog4hf6Mk2b/xQDc/9EKHx?=
 =?us-ascii?Q?yQA4T8Ehc2nlaYbbfbQBJabNtgCIMiLYRxf0Gq6ptDxAoefZTvoxA0+Lmxj8?=
 =?us-ascii?Q?RERHBrPJNxsDSUggOgtgkLhwvxbz13v3++V7hJqLV0E68aqJ+Z8v9Rozbf11?=
 =?us-ascii?Q?D+AP7+eXrJiK0XxOoyS9WU742TEW5OCFQJBjbLI5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc10292c-a907-4b00-12be-08dde4c5b852
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:41.3359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtXbECviFIXanp0opoTryfeRCHll2qlmYxI5Hs5WxTzk5+RHzCUTjv5sFcDSH5Bg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

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

v2:
 - s/!IS_ENABLED(CONFIG_X86)/IOMMU_PAGES_USE_DMA_API/
 - Update comments
 - Update ignored bits for VTDSS
 - Fix PT_FEAT_VTDSS_FORCE_WRITEABLE
 - New patch to reflow how PT_FEAT_DMA_INCOHERENT reaches the PASID entry
v1: https://patch.msgid.link/r/0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com

Jason Gunthorpe (10):
  iommu/pages: Add support for a incoherent IOMMU page walker
  iommupt: Add basic support for SW bits in the page table
  iommupt: Use the incoherent start/stop functions for
    PT_FEAT_DMA_INCOHERENT
  iommupt: Flush the CPU cache after any writes to the page table
  iommupt: Add the Intel VT-D second stage page table format
  iommupt/x86: Set the dirty bit only for writable PTEs
  iommupt/x86: Support SW bits and permit PT_FEAT_DMA_INCOHERENT
  iommu/vt-d: Use the generic iommu page table
  iommu/vt-d: Follow PT_FEAT_DMA_INCOHERENT into the PASID entry
  iommupt: Add a kunit test for the SW bits

 drivers/iommu/generic_pt/.kunitconfig       |   1 +
 drivers/iommu/generic_pt/Kconfig            |  11 +
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
 drivers/iommu/intel/iommu.c                 | 900 ++++----------------
 drivers/iommu/intel/iommu.h                 |  99 +--
 drivers/iommu/intel/nested.c                |   5 -
 drivers/iommu/intel/pasid.c                 |  44 +-
 drivers/iommu/intel/pasid.h                 |   1 +
 drivers/iommu/intel/svm.c                   |   1 +
 drivers/iommu/iommu-pages.c                 | 117 +++
 drivers/iommu/iommu-pages.h                 |  45 +-
 include/linux/generic_pt/common.h           |  24 +
 include/linux/generic_pt/iommu.h            |  18 +
 25 files changed, 1077 insertions(+), 890 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
 create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h


base-commit: 2265e2af0b8fb7314f9be9abd1270557824a045c
-- 
2.43.0

