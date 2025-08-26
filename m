Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3604C2E7648;
	Tue, 26 Aug 2025 17:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229211; cv=fail; b=O1b69rjf/MAqcc4JtYTT19YmEedepH0IXl+LozfnE4I56btcuLGsxwUAtE2mR506qxnUSnfHMNdYi4bqetU/ThrcRihTJ8ncbBsPYjdvvqdUe/ZOAPkfQ7bX7kujhmRYtRfU/XC6qyDmSO3XRwt5evsVTnP6pIGEST6aPuBnZbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229211; c=relaxed/simple;
	bh=fkHqoj6dUKAQEYmv+eJd6SdE3x920nJQbmTa2awgUCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nsvpVWKl7Eo8cCZ5z8/1S0qbef3pO0wzB8zqZ8d/sIm3SnTinZyGFM9sE02XsFbAyrQL9Tpz/GQa4wMvdmQsKgcOxp5koYLFNv9UIZB3pCgw4qrFCCeN1n7ggcC4yn3mJ9KZUPVZi+UPDdw277hEllyGtjDHUxxfbxyZMmCuPzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ccCPcxFq; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ccCPcxFq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v3F/yU3LtXNyGvE63/pc+NcVyVsPOSvGIOu0IIdDWDzYw9sk4u6FL0kWMbxneddE7H2AapVvtHzOinYviYwD9Hwvxvxr0Bwhoq7mGvdGGL+0OfjwoLUnPsNl+pqfVzlKvWgTVOLOyGWR8GeZwCa3CdzNfe4I6XtJ95d8f+OdTAhZVfjpn8hLqjTemdxy6TonMT30XMshKayBF7h8GSblvfnbTsDVc47ZUsLMzq/QMrevZn6vaL3zZtd/KQn1qkkOQV7XeLqUScoqAoKXv9BjxFJpSaERoTWLx3MldgCzZFK+vd9/q4zLrhbTQ0HRoOngw+phyGktYuZdzgPFtCsJ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2yS7510LO+ondK9o3zwALTHPf0tJb1lbI1x+iRpb3A=;
 b=LzFIsxSMvFhZcipqZp4J7TobfNaEfp3Vom+/yavIOP04tF9kSlGvqTX/9zgYZnJ84Qyw/Ys2MIe++WAby8nZVcjHviHGPTFKZp9Qj0Nea0cIiKhPL3ieUkGk58QLg9i3wEPWAn1CVWy0fEHzxYJMqEsGQWMxB0miLOUXheSZOXZgZsnAPtBjAnOdVQlDmgZe1tGXr9X9hOjvz3obb3OUCScLY3v1P6zjJcLMv2UHUPvw0Lqb97BHaR923kDSwlVXA44EdEiA3U+cdJyA87HOw1ugYAQNCjNVFXbBOP8EjMFmoEEJW2r+Nj2/k8t6ranP15bYW/1FZ4mmB1yxspiaCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2yS7510LO+ondK9o3zwALTHPf0tJb1lbI1x+iRpb3A=;
 b=ccCPcxFqeRos/hETCrw+nkGLPHU1zMYB+gdLcMuwJjeT/1xN9QorbeexOQ44DFL7jebzfEtps5bJtSJA+h/3qwDVvqtomoiXQH1DXfcgleRjDJNRm7TICzbeXSKognzS0/pNiQgi41Xf83q8tJ2R1Ve13hrsXYUkIW5ud0pOG1lR5gIucBI3bB+mU7dMyQ+6smoH8Ir/vpvAMOBUWheg+T3+R1+OxI+iVKUklVUl0Zj6xv9+M6cHuvHDEWFkxFOA24Gb8Lc9f2rXEe98v//9PfSoS08UA6w4InIDHuYABZU7mIG1j3/3vK8zk+1B6nGR5F9M0zGe+VHcwdKzbduMKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:40 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:40 +0000
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
Subject: [PATCH v2 05/10] iommupt: Add the Intel VT-D second stage page table format
Date: Tue, 26 Aug 2025 14:26:28 -0300
Message-ID: <5-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::29) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: 98aba4d9-ef76-4bb1-b4a0-08dde4c5b743
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2c33rSpj4dmZBy2DVxD2WkB/opeAkW+Yr54EikKcsFkD/TSERWd2jDRbhnGi?=
 =?us-ascii?Q?o+XNC5tFfk/3xMhyYve9KBCEtawn/78MefTR0r3hvGZWFqK1q3zgB8XJGeCr?=
 =?us-ascii?Q?INzTDvv1h+pb5IOYpK1Xpsk6vyzRM8VKVWvmXtsWvp3v6X6AI+8DBPmZImYs?=
 =?us-ascii?Q?FWZAtUDMwLApVxQZzDbjW9weN9qqzxh5p9nwjKw/bqTXHD+7MX19ivZDt7b4?=
 =?us-ascii?Q?sugIj8tZ0uI0nC9sGveFOHQ0QxkERtJmKL6SCb9eHkbYobKbnx7FD/LMqJ3h?=
 =?us-ascii?Q?kG72vyjSCVDuVb9Kj58As2sdFALNusMIabNo/78BO/C6Y59aebwxDKpw1iNI?=
 =?us-ascii?Q?nfglkd9EkLEgXx/9xklHjKdXOiHCHnLiWDbBNCms0kT2MpiI4ukejiEemAkx?=
 =?us-ascii?Q?THZ1mGaEQOG45HBcoAyrxHs7pRIkVfWsKOAc2NUhOhxPB4PBqTY/2fIsZFl5?=
 =?us-ascii?Q?R69/x/6YtVlIqTG5nsfCevi0OeTIKqPfpx9fuNkRLtrOdQ8ZRRwSQSBhKOcT?=
 =?us-ascii?Q?1Cj9FdHGUdMsjqDlxP96cX1AMqklJuOEGrPbs3TZfzg8gYP2uwzuA4Y5Z34R?=
 =?us-ascii?Q?WJlun5Hilq/QYHSrZEPdpEkIwF/CcJJkjq2IM+Gep0u/mrQctsc2RP0yulhA?=
 =?us-ascii?Q?ReMKZvE/yYQNm121mh2z4eNynuZL/ifLuIsD465ZPYGZrd4gkV68lhnrmqej?=
 =?us-ascii?Q?wvqtUHJmd8XT9ADorpUUmoNABQsJUjOFW4N4umgzZGc4nH6fYcK2/9xCyZd3?=
 =?us-ascii?Q?rGAVhLymp1tQ0itrlGIKCWRQnRcA/ZR54OSs/TZFcrlHF3VECiWnAkV4K6/E?=
 =?us-ascii?Q?RNDUnmUCynBdU+ILWK88DYU4IaPv6ZzB49O11qzw2OpPK3htFM7MOfgob2XP?=
 =?us-ascii?Q?odtcVoO9ONWsUTifs8UK02M/laHh7Kz8npWvam9eY3wLFX9oQYwBUgDkzUkO?=
 =?us-ascii?Q?xi3ShPvFA5u2N7NYAJAeOkUH55p200ycv4vt/TLy0ITeeZZyuPl8fLZjBDZy?=
 =?us-ascii?Q?0CnBNMuA2IwZ7vKu9hfEZyU9bO9seJ2ga/nxEaXYhrocYR3KFatr6Vr7PmBq?=
 =?us-ascii?Q?JGIBiVrIcc18n2p1OgmMGfwwiGuYgcedyc1n9Oi/VmINCK5AFWXSRT5DBnCV?=
 =?us-ascii?Q?SIJN6qeCn7yghHTdDl81MAK+eChCappkmX+hendmv0neaEgmDkeuFsw6bGUo?=
 =?us-ascii?Q?Z9/SO9T8Iw1feg1BDOpwwqTeoW8x28YqTIVuUJ7IMg/fqTh8wpe05fpAscDw?=
 =?us-ascii?Q?rTWcnnF/fxC5pG4FL/Lh6hwAMTVD9c2fbThA7ewshEdxiyd8JA0gFDdLxemX?=
 =?us-ascii?Q?/Jf/+xwV26dqhzuAnRV7ZaNV+NIN6BwUYstv9jAEIYiKxuTtiiSOJLbQS9RT?=
 =?us-ascii?Q?Od5skNtqtw1Ih3SbihGXCn7q9KAVR83bGijMloQ+/AQ04MRhyxFPk/I1XwVf?=
 =?us-ascii?Q?xTiW4SGCoBc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3L83EBGD/8466zeWU/mOc050TkfdBUFei6Cl4ZTruxgmXOuA2JHTfnifSZqK?=
 =?us-ascii?Q?P/CAqRX/3jRUQHOQsJ2MUkCtO1HyD/cxvJHJPcwc2RARFJEdt7k2N9lfyc/F?=
 =?us-ascii?Q?HPmPmjJCsZaxiJcpzYkormLwWzK9PHPMsZ7upS0o+mWDefEp/P4FYqO0ZomV?=
 =?us-ascii?Q?UFW+M5Lvh15zt4mYJFSFrKEX/kkVo51qJNsSS+1DQbVYJ0pJEVWwJ09VgZwM?=
 =?us-ascii?Q?IcQLpqVR0TsB1S2tOfjDspUkDVXFJJIuOAv8CRH7UaTdT0vMzURW9rm9fHZ7?=
 =?us-ascii?Q?5Ut4mH+YkYjN/cNcR/F4cKcytg9DeV4DpTTNw53UBatlBMBtOt9Hr6Y8WmZp?=
 =?us-ascii?Q?Rkdgd+MajXXyRaI3mE0bmyP/LtsZfO8/5OwgNnj7DP7jR3s/WsuIuqizYUds?=
 =?us-ascii?Q?fFmTOLEwqDQLNhfL1B8x1YWpWgA/PJGKQv9s+V48HHUrHM2siWRXDoN0/142?=
 =?us-ascii?Q?/z/nY4q4XDNNA7pJhziaevlsTaIYFD9hCaRpPNNUnqtzasUItMhHkpTlWfL+?=
 =?us-ascii?Q?2DII8yyrRy3nOeZ79SW0zV8ZVjxaP11BLx/LGF75w9+5QZ+FjZxA4G3SWVdH?=
 =?us-ascii?Q?iJWYId+H1X3+s4NYLDb4aYb8K9vzGtV3GIli/sV0Kf+QUL4JCSlHs//j4rCN?=
 =?us-ascii?Q?CX2j/a29lDHjvHp/3Xwt0CfA1T2NP3VUlu7zBVZNtUk8+My+6xdSfhZ5ujyL?=
 =?us-ascii?Q?lcmfs8cTPSh3Uk7kWg/n296jy/+AUzttBsr7OlsXiLJR0qsSo0hDs6UAr1u4?=
 =?us-ascii?Q?C+iLN/mYZGW/jiKya7wEsv1Bg5X2gVHCSTOWBxN6BmhqavRW3T0yAO8l0OqL?=
 =?us-ascii?Q?jjLaelOu4D28txfa1MHLlIOnP/NoQ43CLv5wiAOnfooe9irgtXijLJpC8By3?=
 =?us-ascii?Q?PaFo8ztxOybKakQ1unhWn4WU2+t1ivh+nVwAr8rkc+g/BqElwA5MqurrBJ5c?=
 =?us-ascii?Q?ITSXY9BqpTtHXzl1s2jkBT8Ghft9nSWFmRTMpj2d0ZSQiCviilJKJaSbMe5a?=
 =?us-ascii?Q?y8Uc5N6h5e7c1nAQi+tzwD7ZoWQYV5NFPxKwpogWS5NWEK8AyHZ5X+o0MU2C?=
 =?us-ascii?Q?icftVLOoLqCedGOH5POmgjjFIFsjudv5D7k5FF2l+bLE0Gq905YyG3uGU5uh?=
 =?us-ascii?Q?R32y0HgdeDCAv4DycfRow9sLnYIMNAWOmkOLuNwZ2xyVDiwy+U2U/h3dk3/v?=
 =?us-ascii?Q?OoHAUFWzgN/Zb3bBDtog/40NHK4SCzoSO1A7Mmu+T15ZCCDdPgPtYVNJXZRr?=
 =?us-ascii?Q?QlyRY7MdrxwLbkLes4JHBC+pAIyf8Yh4JDlRmdCDGewA779jS75LQH/LwBSZ?=
 =?us-ascii?Q?B+azz604tv9lmL3RT4LPClMj5TylY+iGxtcXJ2q5+VjLvxqOTlyN7n5tlqwD?=
 =?us-ascii?Q?VJRby8x/ke11xeGBr82+9j4hpxtEtPXK1Yg8cZ3of2UJyKVVaV+r7VaZDBbM?=
 =?us-ascii?Q?m+Qbv9/CSvnqfh8bpp3dMEcf+T1lu7eE+Ex4AIHWrCTTQ8stf7sZyIT8YRBt?=
 =?us-ascii?Q?6N2hHE+joyP5pVPk2AgnWV8nu1XDhc9g+W2I0j4ppxajlvIjYhv3NsdleaHg?=
 =?us-ascii?Q?OgCePd/Wkqwx+Rj6mMu4aWWt41Ra5+D5OG3+3Vom?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98aba4d9-ef76-4bb1-b4a0-08dde4c5b743
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:39.5936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VnKQ194bbC4GdN08cSM2Ww9hhLdz3YKibK77xWbkHEgKnJUbkLeNOd4589vEIqoq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

The VT-D second stage format is almost the same as the x86 PAE format,
except the bit encodings in the PTE are different and a few new PTE
features, like force coherency are present.

Among all the formats it is unique in not having a designated present bit.

Comparing the performance of several operations to the existing version:

iommu_map()
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,     53,66    ,      50,64      ,  21.21
     2^21,     59,70    ,      56,67      ,  16.16
     2^30,     54,66    ,      52,63      ,  17.17
 256*2^12,    384,524   ,     337,516     ,  34.34
 256*2^21,    387,632   ,     336,626     ,  46.46
 256*2^30,    376,629   ,     323,623     ,  48.48

iommu_unmap()
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,     67,86    ,      63,84      ,  25.25
     2^21,     64,84    ,      59,80      ,  26.26
     2^30,     59,78    ,      56,74      ,  24.24
 256*2^12,    216,335   ,     198,317     ,  37.37
 256*2^21,    245,350   ,     232,344     ,  32.32
 256*2^30,    248,345   ,     226,339     ,  33.33

Cc: Tina Zhang <tina.zhang@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig      |   1 +
 drivers/iommu/generic_pt/Kconfig           |  11 +
 drivers/iommu/generic_pt/fmt/Makefile      |   2 +
 drivers/iommu/generic_pt/fmt/defs_vtdss.h  |  21 ++
 drivers/iommu/generic_pt/fmt/iommu_vtdss.c |  10 +
 drivers/iommu/generic_pt/fmt/vtdss.h       | 289 +++++++++++++++++++++
 include/linux/generic_pt/common.h          |  18 ++
 include/linux/generic_pt/iommu.h           |  11 +
 8 files changed, 363 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
 create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index 5265d884e79cea..2f9b6060e3b983 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -4,6 +4,7 @@ CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
 CONFIG_IOMMU_PT_RISCV64=y
+CONFIG_IOMMU_PT_VTDSS=y
 CONFIG_IOMMU_PT_X86_64=y
 CONFIG_IOMMU_PT_KUNIT_TEST=y
 
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 59007b794d3b54..5e4f44e25e38e5 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -51,6 +51,16 @@ config IOMMU_PT_RISCV64
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
+config IOMMU_PT_VTDSS
+       tristate "IOMMU page table for Intel VT-D IOMMU Second Stage"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	help
+	  iommu_domain implementation for the Intel VT-D IOMMU's 64 bit 3/4/5
+	  level Second Stage page table. It is similar to the X86_64 format with
+	  4K/2M/1G page sizes.
+
+	  Selected automatically by an IOMMU driver that uses this format.
+
 config IOMMU_PT_X86_64
        tristate "IOMMU page table for x86 64 bit, 4/5 levels"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -66,6 +76,7 @@ config IOMMU_PT_KUNIT_TEST
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
 	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
+	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
 	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	default KUNIT_ALL_TESTS
 	help
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 9c0edc4d5396b3..6fe95fc8466523 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -5,6 +5,8 @@ iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_RISCV64) += riscv64
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86_64) += x86_64
 
 IOMMU_PT_KUNIT_TEST :=
diff --git a/drivers/iommu/generic_pt/fmt/defs_vtdss.h b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
new file mode 100644
index 00000000000000..4a239bcaae2a90
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_VTDSS_H
+#define __GENERIC_PT_FMT_DEFS_VTDSS_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct vtdss_pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs vtdss_pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_vtdss.c b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
new file mode 100644
index 00000000000000..f551711e2a336d
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT vtdss
+#define PT_SUPPORTED_FEATURES                                            \
+	(BIT(PT_FEAT_FLUSH_RANGE) | BIT(PT_FEAT_VTDSS_FORCE_COHERENCE) | \
+	 BIT(PT_FEAT_VTDSS_FORCE_WRITEABLE) | BIT(PT_FEAT_DMA_INCOHERENT))
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/vtdss.h b/drivers/iommu/generic_pt/fmt/vtdss.h
new file mode 100644
index 00000000000000..da2f11d2e348c0
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/vtdss.h
@@ -0,0 +1,289 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Intel VT-D Second Stange 5/4 level page table
+ *
+ * This is described in
+ *   Section "3.7 Second-Stage Translation"
+ *   Section "9.8 Second-Stage Paging Entries"
+ *
+ * Of the "Intel Virtualization Technology for Directed I/O Architecture
+ * Specification".
+ *
+ * The named levels in the spec map to the pts->level as:
+ *   Table/SS-PTE - 0
+ *   Directory/SS-PDE - 1
+ *   Directory Ptr/SS-PDPTE - 2
+ *   PML4/SS-PML4E - 3
+ *   PML5/SS-PML5E - 4
+ */
+#ifndef __GENERIC_PT_FMT_VTDSS_H
+#define __GENERIC_PT_FMT_VTDSS_H
+
+#include "defs_vtdss.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 52,
+	PT_MAX_VA_ADDRESS_LG2 = 57,
+	PT_ITEM_WORD_SIZE = sizeof(u64),
+	PT_MAX_TOP_LEVEL = 4,
+	PT_GRANULE_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 12,
+
+	/* SSPTPTR is 4k aligned and limited by HAW */
+	PT_TOP_PHYS_MASK = GENMASK_ULL(63, 12),
+};
+
+/* Shared descriptor bits */
+enum {
+	VTDSS_FMT_R = BIT(0),
+	VTDSS_FMT_W = BIT(1),
+	VTDSS_FMT_A = BIT(8),
+	VTDSS_FMT_D = BIT(9),
+	VTDSS_FMT_SNP = BIT(11),
+	VTDSS_FMT_OA = GENMASK_ULL(51, 12),
+};
+
+/* PDPTE/PDE */
+enum {
+	VTDSS_FMT_PS = BIT(7),
+};
+
+#define common_to_vtdss_pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_vtdss, common)
+#define to_vtdss_pt(pts) common_to_vtdss_pt((pts)->range->common)
+
+static inline pt_oaddr_t vtdss_pt_table_pa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry),
+			  PT_TABLEMEM_LG2SZ);
+}
+#define pt_table_pa vtdss_pt_table_pa
+
+static inline pt_oaddr_t vtdss_pt_entry_oa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry),
+			  PT_GRANULE_LG2SZ);
+}
+#define pt_entry_oa vtdss_pt_entry_oa
+
+static inline bool vtdss_pt_can_have_leaf(const struct pt_state *pts)
+{
+	return pts->level <= 2;
+}
+#define pt_can_have_leaf vtdss_pt_can_have_leaf
+
+static inline unsigned int vtdss_pt_num_items_lg2(const struct pt_state *pts)
+{
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 vtdss_pt_num_items_lg2
+
+static inline enum pt_entry_type vtdss_pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!entry)
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 0 ||
+	    (vtdss_pt_can_have_leaf(pts) && (pts->entry & VTDSS_FMT_PS)))
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw vtdss_pt_load_entry_raw
+
+static inline void
+vtdss_pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			    unsigned int oasz_lg2,
+			    const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	entry = FIELD_PREP(VTDSS_FMT_OA, log2_div(oa, PT_GRANULE_LG2SZ)) |
+		attrs->descriptor_bits;
+	if (pts->level != 0)
+		entry |= VTDSS_FMT_PS;
+
+	WRITE_ONCE(tablep[pts->index], entry);
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry vtdss_pt_install_leaf_entry
+
+static inline bool vtdss_pt_install_table(struct pt_state *pts,
+					  pt_oaddr_t table_pa,
+					  const struct pt_write_attrs *attrs)
+{
+	u64 entry;
+
+	entry = VTDSS_FMT_R | VTDSS_FMT_W |
+		FIELD_PREP(VTDSS_FMT_OA, log2_div(table_pa, PT_GRANULE_LG2SZ));
+	return pt_table_install64(pts, entry);
+}
+#define pt_install_table vtdss_pt_install_table
+
+static inline void vtdss_pt_attr_from_entry(const struct pt_state *pts,
+					    struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits = pts->entry &
+				 (VTDSS_FMT_R | VTDSS_FMT_W | VTDSS_FMT_SNP);
+}
+#define pt_attr_from_entry vtdss_pt_attr_from_entry
+
+static inline bool vtdss_pt_entry_write_is_dirty(const struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+
+	return READ_ONCE(*tablep) & VTDSS_FMT_D;
+}
+#define pt_entry_write_is_dirty vtdss_pt_entry_write_is_dirty
+
+static inline void vtdss_pt_entry_set_write_clean(struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+
+	WRITE_ONCE(*tablep, READ_ONCE(*tablep) & ~(u64)VTDSS_FMT_D);
+}
+#define pt_entry_set_write_clean vtdss_pt_entry_set_write_clean
+
+static inline bool vtdss_pt_entry_make_write_dirty(struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 new = pts->entry | VTDSS_FMT_D;
+
+	return try_cmpxchg64(tablep, &pts->entry, new);
+}
+#define pt_entry_make_write_dirty vtdss_pt_entry_make_write_dirty
+
+static inline unsigned int vtdss_pt_max_sw_bit(struct pt_common *common)
+{
+	return 10;
+}
+#define pt_max_sw_bit vtdss_pt_max_sw_bit
+
+static inline u64 vtdss_pt_sw_bit(unsigned int bitnr)
+{
+	/* Bits marked Ignored in the specification */
+	switch (bitnr) {
+	case 0:
+		return BIT(10);
+	case 1 ... 9:
+		return BIT_ULL((bitnr - 1) + 52);
+	case 10:
+		return BIT_ULL(63);
+	/* Some bits in 9-3 are available in some entries */
+	default:
+		if (__builtin_constant_p(bitnr))
+			BUILD_BUG();
+		else
+			PT_WARN_ON(true);
+		return 0;
+	}
+}
+#define pt_sw_bit vtdss_pt_sw_bit
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_vtdss
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->vtdss_pt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, vtdss_pt.common)
+			->iommu;
+}
+
+static inline int vtdss_pt_iommu_set_prot(struct pt_common *common,
+					  struct pt_write_attrs *attrs,
+					  unsigned int iommu_prot)
+{
+	u64 pte = 0;
+
+	/*
+	 * VTDSS does not have a present bit, so we tell if any entry is present
+	 * by checking for R or W.
+	 */
+	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
+		return -EINVAL;
+
+	if (iommu_prot & IOMMU_READ)
+		pte |= VTDSS_FMT_R;
+	if (iommu_prot & IOMMU_WRITE)
+		pte |= VTDSS_FMT_W;
+	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_COHERENCE))
+		pte |= VTDSS_FMT_SNP;
+
+	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_WRITEABLE) &&
+	    !(iommu_prot & IOMMU_WRITE)) {
+		pr_err_ratelimited(
+			"Read-only mapping is disallowed on the domain which serves as the parent in a nested configuration, due to HW errata (ERRATA_772415_SPR17)\n");
+		return -EINVAL;
+	}
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot vtdss_pt_iommu_set_prot
+
+static inline int vtdss_pt_iommu_fmt_init(struct pt_iommu_vtdss *iommu_table,
+					  const struct pt_iommu_vtdss_cfg *cfg)
+{
+	struct pt_vtdss *table = &iommu_table->vtdss_pt;
+	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
+
+	if (vasz_lg2 > PT_MAX_VA_ADDRESS_LG2)
+		return -EOPNOTSUPP;
+	else if (vasz_lg2 > 48)
+		pt_top_set_level(&table->common, 4);
+	else if (vasz_lg2 > 39)
+		pt_top_set_level(&table->common, 3);
+	else if (vasz_lg2 > 30)
+		pt_top_set_level(&table->common, 2);
+	else
+		return -EOPNOTSUPP;
+	return 0;
+}
+#define pt_iommu_fmt_init vtdss_pt_iommu_fmt_init
+
+static inline void
+vtdss_pt_iommu_fmt_hw_info(struct pt_iommu_vtdss *table,
+			   const struct pt_range *top_range,
+			   struct pt_iommu_vtdss_hw_info *info)
+{
+	info->ssptptr = virt_to_phys(top_range->top_table);
+	PT_WARN_ON(info->ssptptr & ~PT_TOP_PHYS_MASK);
+	/*
+	 * top_level = 2 = 3 level table aw=1
+	 * top_level = 3 = 4 level table aw=2
+	 * top_level = 4 = 5 level table aw=3
+	 */
+	info->aw = top_range->top_level - 1;
+}
+#define pt_iommu_fmt_hw_info vtdss_pt_iommu_fmt_hw_info
+
+#if defined(GENERIC_PT_KUNIT)
+static const struct pt_iommu_vtdss_cfg vtdss_kunit_fmt_cfgs[] = {
+	[0] = { .common.hw_max_vasz_lg2 = 39 },
+	[1] = { .common.hw_max_vasz_lg2 = 48 },
+	[2] = { .common.hw_max_vasz_lg2 = 57 },
+};
+#define kunit_fmt_cfgs vtdss_kunit_fmt_cfgs
+enum { KUNIT_FMT_FEATURES = BIT(PT_FEAT_VTDSS_FORCE_WRITEABLE) };
+#endif
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 1b97bbfaa4f90a..fa6e36e0b9efa3 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -171,6 +171,24 @@ enum {
 	PT_FEAT_RSICV_SVNAPOT_64K = PT_FEAT_FMT_START,
 };
 
+struct pt_vtdss {
+	struct pt_common common;
+};
+
+enum {
+	/*
+	 * The PTEs are set to prevent cache incoherent traffic, such as PCI no
+	 * snoop. This is set either at creation time or before the first map
+	 * operation.
+	 */
+	PT_FEAT_VTDSS_FORCE_COHERENCE = PT_FEAT_FMT_START,
+	/*
+	 * Prevent creating read-only PTEs. Used to work around HW errata
+	 * ERRATA_772415_SPR17.
+	 */
+	PT_FEAT_VTDSS_FORCE_WRITEABLE,
+};
+
 struct pt_x86_64 {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 5dc3a960a8989e..9557e78c110fde 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -272,6 +272,17 @@ struct pt_iommu_riscv_64_hw_info {
 
 IOMMU_FORMAT(riscv_64, riscv_64pt);
 
+struct pt_iommu_vtdss_cfg {
+	struct pt_iommu_cfg common;
+};
+
+struct pt_iommu_vtdss_hw_info {
+	u64 ssptptr;
+	u8 aw;
+};
+
+IOMMU_FORMAT(vtdss, vtdss_pt);
+
 struct pt_iommu_x86_64_cfg {
 	struct pt_iommu_cfg common;
 };
-- 
2.43.0

