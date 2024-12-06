Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A1011C83;
	Fri,  6 Dec 2024 00:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444636; cv=fail; b=TcXNjIbq+4sxPwipg35lcpQQhtK45QtQE8jWW6TjzErAdFh+/9bSVkFXVvZVoemnzFd9T9i9b4hVO+nrj8D+i02n8+6QE1fXkIao20CsQPEu2+iTSnLN+OhqCKC7skG06OL/Dzc/NwobnNvmPsNJWsvLI8a677/7MfSFI6tgg8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444636; c=relaxed/simple;
	bh=h+pmNNG8HCTBNIjyudXYia1zHs3yotlm8U3xRyaTYQI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=h8zONkgJQESlrKg7g1LvSYvcjx6Bu4OxppOqYrwl8S+kC+QYNBy0LcHTXUOieLYayV9sdkWszuPCgowmtNP2VFfVgElv17dIaztr4sGPMjvF53hipR4kNZeWBTlA9IsMNCiQ/L82qdQMoViZ1t2Y5pnwHZ69tQmQfhXXjg5wgOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KbUUCx+s; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KbUUCx+s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NxFfdoicppnXndd7o+UOIr+RgKEhJHuLCo9//XJy+sJs94fpeN4FFGtePRAl4B5SVCGB/QTCZkj16GbD4qkHLhHSFTaxxcV+kkthBCrCZe8TgfzMVALEjTJLHJjDWZmjqQR6kSbxxALPxePukHB/9PKR/WILrCVp29c2T7QkSUiiRnjptL4TmJjzYuXCe+Q5x9xQQzgVEpAWc7e0x4fU18zY/JhBEKQqzySceB/OzoN2B8YVG434j1B0E5xSU0cAN1OREOtHWMG8AWQihYv3VMW+IdX1IWRkg/ozATEhJPRdMNF4qAAcHO8QeTVGVs1b/CMmGnNJxOzz4rzX20hEkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vfv0VA5N/eEWjNjbNSQWZj+Q84mW0/hW9X+bkmyUMnY=;
 b=Q+OroLlWC1s49XvLrT7wTqF0wnxWyrRgQCEEeIfspkASTnMx+j//8wzasjNF2+hlXytwR71vqJoiu28LBRxr0E0Ygpy/sPLdQWK3PvokExwjIWgg7s3A3K9H3gD3tVyVMzrsY3FgNdgzfiP6ysruPITy15L9qdW410mBlWUDJX79IGpEQz+4iuHQnX7LL8Q5LH5GG0bnSq2gVfcLdUEEvGKAOBElYMH5k0PP4I/19lgB1ADetyydF1iwNqTVritEpW1Xd3eZf+fIldjsNXcZiRf33QhUU97Fe+vMWi0HXB4qCUwC+oPrdRmKhWL41Q2d447OKXC2tsx37a7bCzjT0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vfv0VA5N/eEWjNjbNSQWZj+Q84mW0/hW9X+bkmyUMnY=;
 b=KbUUCx+sM1NmSg/2om4yBDlYuNIbYD61Awoc6EXXN1QtS5U/Hl1eTh9HRgIU+sstn/FdPj7sCiS7u2gbJydJ9oGT9YWWDLmSJMslNLYMbz14N1iQetrNeZ+S6V8rG2YSG/zWEBc0eXf7CZ739TDPmYifKVufYptcx9kSaKyoO3pPpb8t8GJ81J96uHCysHDNPcDe4uwP0H6bS6sQPEcvxGF4n6Fy3uFbXMMNmW9h/O/qWfc1FINike6C7xjwXpA0upfCxFoZgefHlWZbY5dFxpyjyecd+QwI9kalbP+3AlJ2T9dXtfa3mY7b1gTOB8Y3uWEPZGtac9DvFwSLjG5LBg==
Received: from BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7)
 by SJ2PR12MB8830.namprd12.prod.outlook.com (2603:10b6:a03:4d0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Fri, 6 Dec
 2024 00:23:51 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.10; Fri, 6 Dec
 2024 00:23:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:23:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 0/7] iommu/amd: Cleanup some of the domain_alloc_paging path
Date: Thu,  5 Dec 2024 20:23:35 -0400
Message-ID: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0931.namprd03.prod.outlook.com
 (2603:10b6:408:108::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|BL4PR12MB9480:EE_|SJ2PR12MB8830:EE_
X-MS-Office365-Filtering-Correlation-Id: 98eafdfe-6370-47ec-2e69-08dd158c3ea3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GqTJrJsWLnGc9qIWSLeim/pl1ukxIegrT9q77MhUpcBlm+NI0UsNi7uPMeog?=
 =?us-ascii?Q?FKx+S2ylDVhtsAhDk7tyOZQoGFGsJ7WVwPnidVJuhtDCOOLbzhe3/WmGVtWv?=
 =?us-ascii?Q?hEplgY/89rgifqQuSE/ffcL1BWEBcITbpAs7ucruAzo2TZWoSozneaHtVHQP?=
 =?us-ascii?Q?0yOXnfQF4q85OhoaeCXwHOY2MAc9nQMafOmxQPifqMot6xY/BPDUeXFCghP6?=
 =?us-ascii?Q?YaE+YTmphEewzf55ynTzCkIlVIS5BUpdjF21ANSD+/Og70WaqVCuES3suOM1?=
 =?us-ascii?Q?h5DC2aGeI/f7GxmW5xSoSLwXrwC41h8kVP2MninvE49s/XYtpSeOimmjP436?=
 =?us-ascii?Q?UDLAh5ffPf++ULVYRg5P+6/zHcX7/veTP7CxraWf64zAGt1/Ij4pQWZWuZEL?=
 =?us-ascii?Q?0P/XnEfpeZHf+rLjTjBQ0aQCuSCT5BFF0+uCalBGjsqXpDIOHknIVbqdwbRW?=
 =?us-ascii?Q?vv5s2UyL6nMRU0CJC2n7k+qnB4DDnXvEzd2YdGHUD5Zx/w2QUBw9ks2WAYKo?=
 =?us-ascii?Q?u0oCTH8NHxfo/VGcP4AvekEz5MB/yOEkn9xuK7g/SczuSpjKhDhdleoeJz27?=
 =?us-ascii?Q?HO+qw2i3AFBrNA1f1ei8E4U+sJqSgnG+aP/tQuFemfMkZ7HtLAmAFoNdU7B2?=
 =?us-ascii?Q?qVHsRFBhSFHbRlEhCA1wytpQmjtQ1HbnwQym0QFLKUPA6zSkMMZFAT9zXLVX?=
 =?us-ascii?Q?w9wB6PfYeL5TH2wF3SVZtMHJFN0udIlwWv/TFyYz2ZIOawrZRCLyTihA1DGx?=
 =?us-ascii?Q?EH8J73wPvEJDdW64rbFqJMHzFoNiI+Lu5mPIuNEcLsxC3J1rcC7QPwDo0DGB?=
 =?us-ascii?Q?h+SUzasMrjYRIWwvjzw9UBaapBXKU0Shl+dwbvAnsS9OiUvtPjSnRzho0nOA?=
 =?us-ascii?Q?RJpgdHel02nLIRSMd0p9QRK0w2+FiM1U9+Bx6OPhBcmZDPWlBpMyS1H/zPGW?=
 =?us-ascii?Q?08jgEqn+3ZA6zOD+YMBHoX+kzRFDscOirTz60bLBX+7iGxj7D/AulCNqmTnQ?=
 =?us-ascii?Q?ExdJgkRXeiW1bkoHcViiZgj62moUe3cJwgYxm7/PcNiYxQig1ex0gdJTp55E?=
 =?us-ascii?Q?2V/gXOUWfJSkUqA6Sh8fIeLmRqDHxBSnFl64PGocGlwDteJR5ABHl+SNeyZF?=
 =?us-ascii?Q?b6R39gSIpvxzcAGgOJ95BlLOZMLggIjykgwIt8MgXXZ7IyOuoOuXkq6IPAsI?=
 =?us-ascii?Q?weHKgiWX4rRA9SWt4OTZ6bHPRYwYJfW6ZCBGU8ZC9iMzTU7wqlXSECNfTSPC?=
 =?us-ascii?Q?4Q6KIoDR1D5kREi9TqO9aCQ66U4IgDWsuyyEkWdn732fkweShmb//a+secFs?=
 =?us-ascii?Q?xE+TqLBmsEB6QBDnYJeQKjzY2ulNdo1DGMsTkbOgEei52Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KBWMhJLupWdvrmJ7xQXC7Q5h2ku2GL0XTbhivUTPrWv6kHMk00KDO2xvOSbw?=
 =?us-ascii?Q?qMky6k2IAqBdgIys+CPsmO/AHZYY+y2btJeGirIU8s2yGRobq7EftkSbG3ir?=
 =?us-ascii?Q?a+0fgSTf+1f9cyBxGM3ZtuiUUHq0Gl3BVlGenlq9YTqIIxABe/4gnRj0vTit?=
 =?us-ascii?Q?VSwlaghIB8GEcl1vyE1rjLS9NPbsFbE1eLqWMMg7vcAY+RgGqB0m51J8UFJM?=
 =?us-ascii?Q?Y7s0Wr40wyJacVH8fXeLlZRJC0ZPLDge8Ki3GX86E+h3IqIYT1SfUMLS1CHY?=
 =?us-ascii?Q?vLq2+Xb16lRN+DaTeLfhxb5TkgUiBkClANE36Wev3mPtSRR1aplsLbtx/Gl+?=
 =?us-ascii?Q?zQYhLxPjWuNmhoE6rHN8SvsE4rS0iJj6OLFTEh+jKlV4vKNxMW9P8/Ia4Y8B?=
 =?us-ascii?Q?P/Xuer4ur2wl/QKw8hK6R3KHpavbAqHP7gAwSUUd0JIVd9fqgOUpDzxYKooK?=
 =?us-ascii?Q?n6HxmGvPMpyoj3WE1M8yoj7YAa0UdhTxOAxB3FqzUMjjzpEQZmxjTRITbWsW?=
 =?us-ascii?Q?WdT/WEHQ107Wwh4E2zL225tvowMySOstklsGgiOCA9aX6+sVKEFa72XsINuw?=
 =?us-ascii?Q?lIMC5BQ+KpL7uu1LWQ5JAm4aQ/2mIEUNWYd8+FPYQZCkhZH+lo5KBMwpPIEd?=
 =?us-ascii?Q?Tee8LfnZrQwIJu9TgZRmNqoRk6aSra3TayePDYcny0qd7f5DAFYg3du2MQKC?=
 =?us-ascii?Q?6W/IiFHapUsVXJjSVGIh3UX9l4PdU1otaU+ItBln7CqqQPDCj8PlgU/yrJso?=
 =?us-ascii?Q?UvsMcigIi+XnEEcylphEDXcZMPNSVdbqr3Y37LPneO7IGT07eB3XEJ6LOj9u?=
 =?us-ascii?Q?sfNjlz8jVwLMV0kLWg1CMRnYsFTHeyHympTUrBUfRUE7yG058Y4fOiQhUy4W?=
 =?us-ascii?Q?EPg1nI37eav757TlqVU85dUaWdsNj6GDX0xuVOIaEY1F5FpNkHjDcna+4PO/?=
 =?us-ascii?Q?Uj9riuVdvdEanh2380HIRMFP3i/vCCpvcos26uEOm51SIU6o4aF1XsBrSgqZ?=
 =?us-ascii?Q?l8vQadBdOKAuhNnlkhP/QhWZ/SiEyxRwUBoggPPU0Xyr9ZnyLrmo/speaayU?=
 =?us-ascii?Q?4XV+cGnLFBzTPJjbMNUKZ/6Xujy1Qv8Nl8TZghBsFany8xQO06dOKTrkOIQU?=
 =?us-ascii?Q?8W5oBO+oqNpOnwUgrL+uZp5FpDmFzY3HK47R2LAEG+5vS003KLbB6XlVyGKS?=
 =?us-ascii?Q?K3ehlGPqaLuy5DjIvEuFsA7xB0nPi/KvaDfGj3jVdRaZsUu3R5lYf3BLxzZb?=
 =?us-ascii?Q?tRZXcuglwc/wsobfkw+xjngWolkNYvhoqrXT6970JLH/3xKKddYcSCuK9hCH?=
 =?us-ascii?Q?esatRdLc/+KB4OD9Ew2vgsiSZWbsvRm9SeXrq3LexCbLaQeRIWwDnueRiXC/?=
 =?us-ascii?Q?6yAQzZyhQfWS6YJlTbLh0yOn19xkil+0au2q98nTYf4o2Sg1zRyk3D7LwVkz?=
 =?us-ascii?Q?ZHe8JJAeghc1L18un6d564kxZV9tKPTM+NfxqVwjXXVK0WfJI9gqAt5GQNsX?=
 =?us-ascii?Q?dfsSqwGwjfc53lv9h6KO1rR8EPpJrp1/dLzGAhol3kgtp2VTZCXPB4896RAu?=
 =?us-ascii?Q?h0CIOb16RDVxzYY07zpd56JWYdXZnrHQPMaK3y79?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98eafdfe-6370-47ec-2e69-08dd158c3ea3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:23:44.8353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRznzNsoFfd4FX3TVpH7eDZFJl3qklpJsfdsbnITq1fP98Rxlu+otwBIOkqOkrfd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8830

This is a small collection of cleanups
 - Remove amd_iommu_domain_update() (dead code)
 - Remove domain_alloc()
 - Remove now obsolete NULL checks
 - Remove obsolete domain types in the domain_alloc_paging_flags() flow
 - Use PD_MODE consistently instead of mixing with io_pgtable stuff

Alejandro Jimenez (1):
  iommu/amd: Remove unused amd_iommu_domain_update()

Jason Gunthorpe (6):
  iommu/amd: Remove domain_alloc()
  iommu/amd: Remove dev == NULL checks
  iommu/amd: Remove type argument from do_iommu_domain_alloc() and
    related
  iommu/amd: Change amd_iommu_pgtable to use enum protection_domain_mode
  iommu/amd: Move the nid to pdom_setup_pgtable()
  iommu/amd: Fully decode all combinations of alloc_paging_flags

 drivers/iommu/amd/amd_iommu.h |   5 +-
 drivers/iommu/amd/init.c      |  14 ++--
 drivers/iommu/amd/iommu.c     | 145 +++++++++++-----------------------
 drivers/iommu/amd/pasid.c     |   3 +-
 4 files changed, 55 insertions(+), 112 deletions(-)


base-commit: 94c61483a6b67a288f8272d9356eee71e63bfe06
-- 
2.43.0

