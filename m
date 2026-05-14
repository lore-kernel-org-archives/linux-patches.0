Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011060.outbound.protection.outlook.com [40.107.208.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9201ACEDF;
	Thu, 14 May 2026 00:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717489; cv=fail; b=XPKa52ZVQdQr8fwlmEBpU8eq7cw9/VKtgX7ysv8js5YXhtDjEwNyfsocju2Zc6/dTW+Wh/K7oy2uAoirAGPgQhnljWve2z09f32FlZs7CtaICMpEhq+zxCRWQpcMQWveLcMfQ00eZnY7nnFKIXsHiZdwmoDUM7wguzsAP9KeC7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717489; c=relaxed/simple;
	bh=4QXGo4Lsj/WcotvyF+Lk9qxWyCKPnC0K43GnH3q91ok=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dKSsQqKuXqqtXalfxFIc1DLxwkwaB1H1lGInH+xq918ELbt6bgl7RnQstgVV+tfA31EhJIKIlQebeMbIV6k0uzS6phWWKhedUrUpGU0ZpEUwM4kh+cdSFSD7WX9ZkNRWD67faIc2e7E4yUngRqLjv+1btbf/zFwR1M55RTHnNdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SiYMlJpq; arc=fail smtp.client-ip=40.107.208.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SiYMlJpq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUGwRvaaScOnWE29GOi15SqmfZfpEgSoGDn04j+pUZqvReU0DBJd9om8Q45xzRSndoyNLi4Cf0Mc4E6THtuCJBMQ8k9+eCaX/NNDG65f19AQULaOiAe25TH/7xFtH4NtBQ4Eh0oeHlbd5h14yyjfoemej646uon0gmDFVVfLgBoiEVzE6wOkte+O5DUBMMi170TzseV1VntZV9dOl3qjOrXUmvdbGFyfbLUxW3WNXVwjJhX35HbwaTix1HA9zjZ/RMM6euFv7+TozZCwgu5XPSFbi8vG1DcDbMo4opS4BPnnMbUAG9aEZZFO40DgHlrNJAh52Npgd9DkHGyqX0w+2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRnuQwqnn/x24o++4gs7VDZvomqX+9eKdW1HylTRvGU=;
 b=qeU+mq4X28UJlQA1d1dlkEV/Ov+hOdZvDMz3YgcBlAazN/l4O3M6zfpo04NAFq54cp/G1ddFCwq9alDiz15vtaNezYVIEmRrkL7EK4KbLXlk2yRDwNr2sOMNQ78WcZvv7G9bE181DXI3CBkbSVO+zCdGoItPc70NmXwJe3kDi/00HnL5OTQqGY4ikXTgPwhZB3yV0MV+ivgMESOUj0BC0A97YVftJdEdnM/jW0FaDtMN+miilMSD9Xi6dOXbHcQyaK1o8AILUwYwqHSYlD4uD6uW9bYEShbpsTrfWO2Hie719S9lRJX5O133R2MJ0cuIlel+VbFdKbw9nmtjnxmG+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRnuQwqnn/x24o++4gs7VDZvomqX+9eKdW1HylTRvGU=;
 b=SiYMlJpqOWq4aByzf8HIA04M17UlEB21/bXiMUHm/QOiCq4nSWMmwXBv+FLUo2SFpkPjeHuyRlGrGDIRXjUOxRR3tdDCou3mIFmBklRdNmfWZEo2M/ALhMtQMAJaVdP3P/0OM/LvfdGNRdUeeLuUX6o1VCTxKMyVrwHQv8isrwn1IuSXD0yMDce7w/VE+Rfch7IAkSEN41+LtuPLeiZJLhRzO4qlTNmmwwKhlDqhl9UiDyzKKZs2j6A9au15hwdqT0W4REbWOxVHwEDlfvwA+3kAuNIXxa/KVUSig+Tew8WAFLn3BXScn+INKpk4MWhLSJHcVcoiSYr+XcYJHcggcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA3PR12MB8764.namprd12.prod.outlook.com (2603:10b6:806:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 00:11:21 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 00:11:21 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v3 0/5] Improve the invalidation path in AMD
Date: Wed, 13 May 2026 21:11:15 -0300
Message-ID: <0-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0026.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA3PR12MB8764:EE_
X-MS-Office365-Filtering-Correlation-Id: e470c4a5-13e2-448f-4642-08deb14d542d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|11063799003|56012099003|3023799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AytSkbiZJg+Ev0sbJxidAYeMv4lJsgObNr3TcPwhmgre0GPocdJ96oXILfPz6ExoO0Un4UkmQ0YiiJtO3gcOaQS9YbPN3WSAtHegv+FnHQxKiD+zpyq43vRq8olPMOdshIZjH1QX2NdDYHlyGk70SizVAB9GE4vW5q5XdzF2zKjXDs37AvrM7TtY1Nz7ylQ9e368Pm1McTRT8oRvtqAsJD1gSP5i2RDxTO/uvGrnPilpAaMSUzKJVo3AzL1TLS/GCk7I+NNOavU966wcs+lYOIkzJ33l0bNPRm0dA3wpykNuHlOlI2hcnRLMe0JdmHSGikA4vH/nj6FmMI+Zl0ZJmAnurV1sSYcy9YUA9H1H6UX2Rv7XQS2qp59OgtH8wa0/kPlVPcSyFgDYJyZ62VtTZhJAPyt9Og9E1oJuUKXUGVLRJUHns0TxIrQ7xGVWY2db8ZqC6uV0SR5pkpsnuZB62vhNUjAXWwd8+iRKurc9XeszBDkCN9TUldGKHA/PTOAmlDbm9XS7cwF8bLMAbFdujjfrYaxIIuu/aBSpI897TMkUs0MfkwwhMZ2jdiOiTI0ZxHLuGNoVFxyhqWLjkZarUUJ3WLFC8QaQ0KAlzd/9CEfXDiZrSb+bRnyK+yQRENmqVvVmqmrYnoM1nV4fUbCNyg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(11063799003)(56012099003)(3023799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YQ9sqnwAkT0ppP1XHn2bbJwkiboINPHVsTla/7BMushHu6jFJMlveQ8GirFh?=
 =?us-ascii?Q?fHj0SwE8OIt6vUjwUVIPLFLyAxtROJdFYDtPcDhkYuwiEmdQTZLxEfj2ASlI?=
 =?us-ascii?Q?8LQbWjAySrb2kD57wG/ipbYzRT3EAUJ2n9nvwCuyIG4GCp60f94nuWbrrwSH?=
 =?us-ascii?Q?PzLunQAD0wBTFIwrbkLI+VjD5BadiUq/4SRWY11T3JH4j1KEWzmR7D7B1+27?=
 =?us-ascii?Q?qLuEgwoitC1jTgLjTaT0kMQSQUOZqLfKiuHwPoBXrFL4HPL6o3gKABJW5VCk?=
 =?us-ascii?Q?MUTfuxKiBQLFle0HpQU2K/AzhDELAP2gVPw+SinxwZGIG1JvHV/ghFWQ31vg?=
 =?us-ascii?Q?eh6G4heDfhwiB5DTbRzwUGf9PrepS/NpM5dij3McABLc8FCkgsWDCcpZCUh4?=
 =?us-ascii?Q?2TcVO5tj1kwr/69BJqjxbQKNnDZHEwJQ0vrKaszA7+ekUgwF0i1sBwN0FVZx?=
 =?us-ascii?Q?brgeXMrLcy6pDLei14ZyxQvDW/Ldpz27D+Zq6OjQSKRBjIGoZSj2mQNFehZc?=
 =?us-ascii?Q?T90snpM3JnUgLN10TwDwGnD6/1ZOntnJkSdeG4MQ0nhqrO5geXiorgTkJR9n?=
 =?us-ascii?Q?oSjrg9w64/ixzeWi61mEKdixqGemXhtMSVaG4hiJ5UHWWfsW4+dG23pBLzv+?=
 =?us-ascii?Q?knPnF6//cH6pMwKG1xTE9901tYQf6q3PggdjRn2SG7uMEc6+ZIL7w1cb+kTd?=
 =?us-ascii?Q?MqeHrIcwW77Z9ZMN7ObOty7sqQfm0SmeIkxgGqgaRjqH/2Msw1KVX6DMHg1M?=
 =?us-ascii?Q?C+VBogXMz1q/Cl6gELTVTCpFW1oFohyp4v/64f4cewJVChos2rIxATGdafPq?=
 =?us-ascii?Q?cIDpJxga5o5lEz4sDEdjr8T4RfMuEZHJ7TDAAtjz00hEZM5wSbp6f6G+/UEc?=
 =?us-ascii?Q?1/HCZ0UfLGKitC1eBu/OFzRZqiuYkqYZth1tJPo57nlY5F22RrOdIhHg23ZH?=
 =?us-ascii?Q?IGscSBw+//OEyC/ep0Q7pFUotJwPqNOjaynWWsRzTrM0e0w+vf3EK5QfMOby?=
 =?us-ascii?Q?Ize8UwiGGWK6lnybKk0bJGsenMTCMqp4DZxjl63+fR3Pd16k58WnbAFDyGum?=
 =?us-ascii?Q?+DT5qaC9V3M4KERA3srn95GH9ruXMC4X6NLw2cXglkL28gNYOsQ6Fv+bwz/m?=
 =?us-ascii?Q?93pE+JU0vtAGvpBLYiqVRfhvaXIjcS3r1BJ1cO0iOBHXo6Xi52MSxcFix6V9?=
 =?us-ascii?Q?BC8me7PYNkPvCRzb0xyOAVJTYfdK15lMQyddiyttR/yugmaXQFKHOFmnd4R8?=
 =?us-ascii?Q?LZEUF9z2No2WEmomhdIplM/kVslosSLcU7s+/0dc9AtTkIj/onv/LOcjYwCj?=
 =?us-ascii?Q?W/TaaADq+KAWwzpFZ3gFVWIRGI9PSBBvDdFjsHdXa+ZDLg1FQR3HVQLuEWXb?=
 =?us-ascii?Q?T0pAMZy94665ix5aKlouZ7xt5m5T5QLkXCq5chZSX2/LNr1cOEcdJaK9L8UO?=
 =?us-ascii?Q?kzVU5V8meElJ+sK8YumyH5hSmVsml7HCnlbr4lPHN7rNoBXbKUofQjbXzxtT?=
 =?us-ascii?Q?XqXmSA4qFBvCaLAL8WH72cP7K46iHnoIupnpbv2HURSrKUCzViZFHRZT3anX?=
 =?us-ascii?Q?wUD8RvHCCUBg0oNWSQ1Smb6OniwcVBYotXERVCBMd8la/kv8Y5O4DD8OeqGX?=
 =?us-ascii?Q?h/C80DQksK9OhyO0pxslvA2Jl3Fv5fWnu69p2u26Xd+RZJIEPpWeHlwOkgm7?=
 =?us-ascii?Q?1QDvVu6f2PEilFOik3L0WjYouQlYZTky3SsYrYUz5XLSZAyL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e470c4a5-13e2-448f-4642-08deb14d542d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 00:11:21.7100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAKiOXcUG4vIr0N/RaD1huhXtSndH8CFleDKg+Q0rVn5gfx+WksLLLWF0XyuzNGw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8764

Auditing this path reveals some unnecessary complexity and some
confusion around end/size/last and types that may cause issues at the
ULONG_MAX limit.

First, fix up the call chains so that the gather start/last is
retained faithfully throughout. This avoids converting to a
start/size, and avoids various type conversions along this path. Fix
everything so the theoretical cases like start=0 last=U64_MAX work
correctly.

Simplify all the calculations for alignment/etc to use trivial bit
maths instead of the complicated versions. These are all intended to
be no functional change.

Finally, add support for PDE=0, deriving it from the gather. PDE=0
allows the HW to avoid scanning the page directory cache and
supporting it should improve performance.

v3:
 - Rebase to v7.1-rc1
 - Revise comments
v2: https://patch.msgid.link/r/0-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com
 - Use start instead of address
v1: https://patch.msgid.link/r/0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com

Jason Gunthorpe (5):
  iommu/amd: Simplify build_inv_address()
  iommu/amd: Pass last in through to build_inv_address()
  iommu/amd: Have amd_iommu_domain_flush_pages() use last
  iommu/amd: Make CMD_INV_IOMMU_ALL_PAGES_ADDRESS match the spec
  iommu/amd: Control INVALIDATE_IOMMU_PAGES PDE from the gather

 drivers/iommu/amd/amd_iommu.h       |   4 +-
 drivers/iommu/amd/amd_iommu_types.h |   2 +-
 drivers/iommu/amd/iommu.c           | 176 +++++++++++++---------------
 drivers/iommu/amd/pasid.c           |   2 +-
 4 files changed, 87 insertions(+), 97 deletions(-)


base-commit: 255c710c89f92be8db1322c992600c1663eafda3
-- 
2.43.0

