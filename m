Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46627AD5A;
	Sat, 31 Jan 2026 00:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769817654; cv=fail; b=KYVkWqJZtlB+ZZs5CfpjmmkTObto8jNU6WP52t+9JhAeQEV3yJhGSp06Y9VZOieclpUT4whUDrbVTduSb9GYpQb4Gv5QLd+eotwTuMXGb6vDu+hQuKtztWNng3Sye6YzFtfoLBVUFF9nPTH2kW2fSavUTX4jhuPsipLy9VBwxuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769817654; c=relaxed/simple;
	bh=e1j4h8eydWFcmTq9i48R2/oaCX4PT1O5FOUuhO+MpKg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rH/NlukgktxW7/GtoEO3UV9fhMewVh38tlm0Gxl6L9mMm2QmI9cpJYfkDOPK9uO1yKnFHSm/DkcFbJXMwrlIWKiZFRKy94IsOahn3QS0GCLc2j+GYiftOIiqRqOpiMg5HVRIiiom3qE2l+vmFGCSeSnZUSrrpOWSqDi1noEolBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gl0qOJbH; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gl0qOJbH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D4cBMh7YO7XI3t4V6LPssXOlmVElI2k3faQxOGFMUH7UuTqiZnuou8v/oPagzBGKR9DYkyUTorJxwqCsZCxgMZhY4RUbK1P9ntvYL8uQwzJqbb10HjHSQk1fx9roryguq4I2AHi0p4fKs3mv7xwBqTu8iMbsG1F9MtXFaWj6eAmpj4kEXmByurhmcpWelFhSQEXnnn+PgxrJT0VUzvjNhI7MMp2Ik8d5V436JZDL0HGWaBbxKDdg/lfTqokNurbF3egzvY8JrBQEV4GYhHILFzld5QXvs5MIhlkVaw63y5//rUPK6Y6rWgAZmE52Gz+cGrQyNd/tY6Hkz1vjw8FnLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acHosuEpTdnbjk3E+0EES6zptclfKNgQ5BlNz82+Ct4=;
 b=ISydvfzCIMBts8MRvu7WoATzcnVCF/SGuz852p3ayPd3jO4Ban8l92Ep5HTcFUrCHByLuDs+sEMABoWFxRVkrUhUnKescIlOEICyk/3tO0E/C9xc0zCym32nPXo9pllHZwE9VNveI9GoHdoXiZ3/bKVN0e885D59GW0+SKQc/xcnDnvD8AvOzYgzUlKq0Wsz6wrjDoy/nrPPBXqGMFQUw61aklAHByfRvgzt3CCVoj3QfWiCvQ28lfMMEvqAUdeux4nA3cHahW/TGHPbm5r5NeujDqNM/tAjxAjcMpidnUQSSmg0eIIajmvJ+nlY1ENXplMq/EaJgvu5ObxyWpLqRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acHosuEpTdnbjk3E+0EES6zptclfKNgQ5BlNz82+Ct4=;
 b=Gl0qOJbHbut8kc4XV9TLuvlK3dlx9Y9CwF5MXk+VzDbrOhqCSksgtIiB/qx3NJEkXUunH7nzluu2qgr8yGDfUoRn6RzzMk21QCucflR2doQ6DUZWrrjSa2FNz/j0X4yRvMrS9hQhRYb6ZrS1tRDoFSjGvdqPU5kPdrLhWjeho5uzys0Y7GER17RWmGZMIXtCGIe7D4fJf4fE9PjwaazBiSp0VmJc01q02+HF/DndHKT6Aw37ocMteydhuziGI0cMor+ckD4NiZRgYp6ewL2V9h7bW2Ij+QKtzIjIb8a0n5vn8m9UDW26vVN/JXNnHRZp4IFYcaivcgsFwlNTo6qFCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH1PR12MB9672.namprd12.prod.outlook.com (2603:10b6:610:2b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Sat, 31 Jan
 2026 00:00:46 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.010; Sat, 31 Jan 2026
 00:00:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Paul Walmsley <pjw@kernel.org>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v3 0/5] Convert riscv to use the generic iommu page table
Date: Fri, 30 Jan 2026 20:00:40 -0400
Message-ID: <0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P222CA0022.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH1PR12MB9672:EE_
X-MS-Office365-Filtering-Correlation-Id: 80c46220-0e45-40e1-12be-08de605bc8b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fw17GMnotkNp9+UBvlUEZjUi8pCNuBJOYfhCSZnM18Cnb5QbYoP8/e37LvXk?=
 =?us-ascii?Q?cUuHDotAtX/GujJ4MVMnHAsYhuV2y6Vpp7f6KSyRMoHylE3OBr/UB3rgcLoP?=
 =?us-ascii?Q?c0NitrP7XZwDmDlYn05Snru54BxS/3UIJOQyQPCffJLV0yVBJc/mM2d5vI2S?=
 =?us-ascii?Q?FujJSjGt/dgh2wg7tDE1KmV7k85tahMStzyzRtwYd1q1fp6iCTNenV4q4FpJ?=
 =?us-ascii?Q?XR+diK8Hc+cC9SxM3CxGGMrzsBubBopgdER85FbDlmj6mas9C8cpIEgjQP/7?=
 =?us-ascii?Q?l+qQJkdP6yi/TQ31W/tQ1Bdq686XdleZr83x2b2krTX+3QvaY1kgrvN+RZFr?=
 =?us-ascii?Q?HhY6Pq+8qfXSlniwOOQ27rOQEXCmMjePXRacRLCjuaj5WRHRmlLq3BvoyucF?=
 =?us-ascii?Q?1NZMYbg8dzS+lJ6AtCAWZRjbEXg+5qYith2eYWuUTMXdsbDgOs9BcVpiko3e?=
 =?us-ascii?Q?JWgg92uLvQK00FjfhptExqS3SdZaJfBnzaXChFrI+5/yYxmdEbkRSqtvb/07?=
 =?us-ascii?Q?bsDUp9GRHsUIHUDfJqZ0av9Lq/DlFkbyw0ZVzb4gadZ4eDY6Ha/DUgZExx8o?=
 =?us-ascii?Q?pP/216809xeF4C7EeI/D5O4uWUww13U8YE/H7vQ9ylWY+8oibBhVNlVX57oe?=
 =?us-ascii?Q?u+Cz7k/KLQNyhtUfVjOmINIT0i1I6lr0rGUJTcNFdnI0nEX9BfQ+DFNpo6Fk?=
 =?us-ascii?Q?uNy+yimmxMgbjhCsp+1bWML0v2rig8hIbHlgb521mtnl1SVFqYED7EMqH/Se?=
 =?us-ascii?Q?1p46G8SwbylxaLLPSN10iahlOnGtVvN3mmPJEkW0qp4bcvJE5iG0Ar60GDcS?=
 =?us-ascii?Q?cZoYZ0reTF4ozeWeslq0VRxGY51kCotobPN3yJDRCZXE+6AlNkzR6DzUjR7Q?=
 =?us-ascii?Q?sSM0NUZuDygEScxagWktoNQCjseWEl+g3A7P+NH2Zd8BVE9YV25QehX2+qhN?=
 =?us-ascii?Q?j5LSIy022+Gvb+exdXScE7XrDSnb6SJ6wisfGk7oFYWLF8+IUlt9hCdyXBTu?=
 =?us-ascii?Q?UAx59Si33bah8ECWc6HOM0YcShZjnlqvoajerCENEOnmNslz0a/ILCc5wFwn?=
 =?us-ascii?Q?REg8tultlpgBqRSwx8b8q6M0pCzK17/ZPoP2vZ4+lpIvrRQZOen5E4UtvogR?=
 =?us-ascii?Q?ky6yA1SZJmSWzKgeXQsjtRuH2LICYaduxqNiPfPd9sk3Vx2dLsiG9WU5bp2x?=
 =?us-ascii?Q?FG73rhbA7rHMGYWfKEGKz8hOrWxTd6l9fBEOzJa8ah/pAuC0OswSuF/9UX4E?=
 =?us-ascii?Q?50LRfrf0RejeYNVAAtjrdy8GedV+o9nGgsv2IHIYoxDJibIv2Y10c5kN/zKI?=
 =?us-ascii?Q?WpKamPm4xtLPuQ4s5GOkEoMGCGApRDebPOej+0ktOsY1YKb90LFyp4sRRLz4?=
 =?us-ascii?Q?09blmKolG30t0iP/CTw1+QcN5YdB5zA66UgUEVdvCULKn3rMr1T7mth5Bt6t?=
 =?us-ascii?Q?ji6i6xVSDsPKEMWYSsvuuOCBmtGKCoMrg6/uxhdJZsEEJOVBwAVaSuFqKJue?=
 =?us-ascii?Q?ZVMbREGU0lnb9dbN4DilDrm4yANMW4SJ/ognM0MsnKOiDXS5CCtypOzinvOB?=
 =?us-ascii?Q?2m/C66yP3g102YNlq1PdszW74W5duSZeCEE2tArN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sL1BVuNUZNRqVtFQ82SZRseA55qzT94Nrc3bCRw8EAoTMevNgDltt2zoNOZ0?=
 =?us-ascii?Q?KnSronGYBxYg0cZmFbhZ7P6fUjHf/zAPY6GvVipptdYrKrOOVCPiY1UsjRtv?=
 =?us-ascii?Q?Ep9DNQEpRaZKSWtDwmnBJlw2GlmLYXrFAFx+G/HkcKJd/zqg040DKlyVMN2B?=
 =?us-ascii?Q?LEWg7dEP0+W7BgnU9MZnI6sh7mPWCDqQYjYUaXgQ9hiyONHWr2SltQcekELd?=
 =?us-ascii?Q?nHmr29Nsw0X/GMw8iR0ZtgTWC/gqNRAEQOUhiBVYmsmjQtl3MfDBrQ/fdBTQ?=
 =?us-ascii?Q?bycbodgcQnk1nuAUjiBPG5MgOSel2w4GuJtesRO0hHjhh2pqvo8hCA5hwnCv?=
 =?us-ascii?Q?08/72NSbrFI5gekhGwHE7edIlY95UJ0K4zo0UFR/oxZIQWqz2fl6UhDL7nuq?=
 =?us-ascii?Q?JOHArVdmCv42ZYySEl6EGJ4CS9DKbXPF2kIVhjcudpySYgy6Ug3oZL+VpVfO?=
 =?us-ascii?Q?jJ7zIkPqfXocnmH9Ikj8meSe0csSd8GV75EG4fDn/fdZlZFjuYUvndrCQgJB?=
 =?us-ascii?Q?lN4bRaB9T0MEmH7QHFAIysL1ozuXBsJv76ri8ErEGw0UP0rKg7hEPlrChVqR?=
 =?us-ascii?Q?V6n5u+qpvxlTxlMn4GBE17DB8ARwKbOgThsnngm2h8+1O8BEfHz0uQihf6mI?=
 =?us-ascii?Q?pG6CXUgjNb3iQWf87Pn6yROtKK0YL75mPLh6CNbQG9R+SqPE85e0CbPlG/fg?=
 =?us-ascii?Q?hH0N/6wmnMu4sG7A/NQWsi7KP5j/5oZ3zn7AW7yljyxKsFVhoc3s7+QJwMxD?=
 =?us-ascii?Q?QsmWLHydgSPvYznuJZz+Coh2iVhT4AoHB9sbIoGI4mBnVGzv1VQ1fxn7TMun?=
 =?us-ascii?Q?U+c2BG4dzjigjVE4jy6eQeBnNVJclEDMYToSzQEOLFoNKIiEiFMoLoywvGCZ?=
 =?us-ascii?Q?y6PQ1VrBplkcHRQjN5h2YugaHSUICASGpd6NBSduQ3SXk3mfLyELO7RI/HaO?=
 =?us-ascii?Q?yAGLByJu7H5Rd92T7XcBcCFbEQhbjUsoBn10/TnmAceB/8BbVetKTGASssl7?=
 =?us-ascii?Q?RwIaHYUSiY7PlNbLv31Xhm47M4yAikWC4I7dd7GzX8XlrVAlHbTUZJiCF9Nc?=
 =?us-ascii?Q?2X/E0b/6tDpwhwKWjKszh1LzmUk0xMJHwYu/7DGAoqTf5OR4nXfFuR5L+/B2?=
 =?us-ascii?Q?ZZwLWIbKcL49i9DAsNJfK0BlfEoFgbEvPwbiMV2scxI7ShgDzzUb8eD4PwwZ?=
 =?us-ascii?Q?nsSNJgoVjz11nH740tUnwFacNivQwLCEbxQcg7ttIt1mpLFBowqL+h8Yb4/x?=
 =?us-ascii?Q?MgHOiNBCCZTEm5GNjup+mscM+5u8D0Eaa5Wa8h0jPbDkvRm82s3mBsvP/y3K?=
 =?us-ascii?Q?p3EizvzUFUKlPPKlQemMXMAfIEmAYKSc3TkhM03Uce532YvmKcZSJNjDABnE?=
 =?us-ascii?Q?egm9xJQFQUXdLcwiyzUIJjG0pHVdSqQofSizf5nlZ90imf/w1HX33C/dSO0/?=
 =?us-ascii?Q?t7rrnyfJS7INh46762GkqZuc/sLt8VbzO7rYrIXM4SSwuTHXh/nSLMYjIqtt?=
 =?us-ascii?Q?mOzsX2x3eTfqy7I83m7oTtC9jv508LzjKd+O292d/II/hc3sKx7ne/69B3IZ?=
 =?us-ascii?Q?3Ob08qshgM2HFzxZpRVA20Pfj2hMpLdBzBYPg5BtMRcuRnqf7C9zqjB/1Qvc?=
 =?us-ascii?Q?pb6Ofv81aRJFDF52CEy4JdMf5mUUHlSdMtgC1FS7jj3Tt4Mk47yYKeq/gRzv?=
 =?us-ascii?Q?zPT2+YYPxvAN6VYZ5sbubVFjZ/Q+76VESzPEW0664cVvPMAH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c46220-0e45-40e1-12be-08de605bc8b2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 00:00:46.3266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yMeLNck9SmVNsVTa+MGYhg8RBoqQe7SYcEG8GBbYbxbOl/LV5Na2dNcKZxoqN8a1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9672

[ Joerg, I think we are good now, please pick it up this cycle ]

This is a fairly straightforward conversion of the RISC-V iommu driver to
use the now merged generic iommu page table code.

It brings support for SVNAPOT which is a 64K contiguous page. Otherwise it
should not change the behavior.

The series disables SADE as the dirty tracking support is not implemented
in the driver and should be done somewhat differently. The generic code
gets further along though this does not include the format implementation
of read and clear dirty.

The format implementation should be able to support the 32 bit option, but
this does not enable the iommu implementation as there seems to be no user
today.

It looks like RISCV could support the DYNAMIC_TOP option. It would require
some additional work on the core side to interact safely with SIGN_EXTEND.

This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pt_riscv

v3:
 - Rebase to v6.19-rc7
 - Add missed line in Kconfig
v2: https://patch.msgid.link/r/0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com
 - Rebase to v6.19-rc1
 - Fix typo in PT_FEAT_RISCV_SVNAPOT_64K
v1: https://patch.msgid.link/r/0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com

Jason Gunthorpe (5):
  iommupt: Add the RISC-V page table format
  iommu/riscv: Disable SADE
  iommu/riscv: Use the generic iommu page table
  iommu/riscv: Enable SVNAPOT support for contiguous ptes
  iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST

 drivers/iommu/generic_pt/.kunitconfig        |   1 +
 drivers/iommu/generic_pt/Kconfig             |  11 +
 drivers/iommu/generic_pt/fmt/Makefile        |   2 +
 drivers/iommu/generic_pt/fmt/defs_riscv.h    |  29 ++
 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  11 +
 drivers/iommu/generic_pt/fmt/riscv.h         | 313 +++++++++++++++++++
 drivers/iommu/riscv/Kconfig                  |   8 +-
 drivers/iommu/riscv/iommu-bits.h             |   4 +-
 drivers/iommu/riscv/iommu.c                  | 302 +++---------------
 include/linux/generic_pt/common.h            |  16 +
 include/linux/generic_pt/iommu.h             |  11 +
 11 files changed, 447 insertions(+), 261 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_riscv.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_riscv64.c
 create mode 100644 drivers/iommu/generic_pt/fmt/riscv.h


base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
-- 
2.43.0

