Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9948D31F991;
	Fri,  3 Apr 2026 12:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775219215; cv=fail; b=mt0oZqCga1RF0FC+Z1DRKjY/E567KOjOdMfvXVLxBNXlWspldJwvUffqLIKEUsndMk1GMvCDBgBiae6C9OhB8NxL9DNumm9iu9xtgxV6PMZgfq5+QlU9ipmPGlCebjVexTMRWRLi1oFiLw4oIXwfv6aexE8wrzY9Oj+a4wqGsJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775219215; c=relaxed/simple;
	bh=hAV0izaHEaclC8djrSSObztIA7iFSH4JKTPGrkOLSFw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=AaG1EaOwjpfeKlnV2dReYk8aBkLccjiD6Mehstb6h0goFcj6kCp5W0ndRHNGf7TY+InmX2pZxQFbXmt7KqCFIm60SMJ2S/ViowrJGId1kvAVXjKxJTkmoNGBazg/JIF7qR+BaZ0RYyV0KmjBCwRTwb0mhGscNef2WS+zqUpV68o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gj9W9lSN; arc=fail smtp.client-ip=52.101.193.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gj9W9lSN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mZ4OFj2oBxbTtkF/xbM0RQW8/rw+ohGXtJ+yAWTrV1DkFqmrMd2cXnzWgMTUGRM5d8dNsevN5ILTaf9SBEhB90vBlxoVBImz1LNGpiVEyp90uHnIUyT12mV/M4DPDtS5jZIOXQsLA3LDtfsoc6AyTacbDbCO8mMut6TlJ10Z3H4qwUqUmFJ0P8ZxUxyxghhNV9FQ+NSXFQUX2cgcE9acHF2mJlj0Nt5Pt+mUtMw0Xw6lA51CN8fH00w3wGNq8TJP5T8+LC0NWVz3UwMhzDoS1x+6HBH7Y8eWBUjopnWi3bnEGTk4vz2umQPTtNIkOz6yfdhqyy4iEEuAfJan2mLSXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2y7KDNx1zbhcZFDvlbW3F5uLqavguaFHPzezmANs+zQ=;
 b=VfUlJZbsN2XDfI+ILfKfTiWuedI0k4yEY8InVP5AMCBCaqEbp71UYMzwqyEXpAkSuX/LElrKdmZZCBuMRAsR5jDuYk7haofVZiSpH1csjKAxMheM93XuSXdXQiMMqVKI+/LKFUjoRi4dEklmFLX90qogQ8nYYeLSO0z4K0KZVZwkB8RqRyEG151zuxXaGuRaQoJ9cUXZOjXlKXZnfajfaZDMNbKi1ZFzgcc5ZGcPJxdES94/kEfvUOoRN8gGBvmgTypsktoimLzQlxp27FMS4JS9ZLUE83IcJMrSzCryKORzLHrRorZRfDqkhPCCWBxTGsF8dC9vZcGWpz6NTqlIaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2y7KDNx1zbhcZFDvlbW3F5uLqavguaFHPzezmANs+zQ=;
 b=Gj9W9lSNPIO4gkzzuHA2yMfQN0WTtTLwSOtWGP3E6Vu/MQ0cUHukPO5iyT/xTf4iV24I/j5SlefiwIJZX39CuRZVB1I5+05BBHgmGtOh0yv96Gkctx6KUVyxqxhOiO/R0Oo6RnKvX/djYRx80q1d50N2usMQ7YXkzSvBtPq5eJOnBDX0Hd32drSpJ4taC1IYQBGbc+8dKvW9IoR9z95XHMtZfiNmTLGswV/AXCp9n9FZhAUGBdzS5deGZjUndZkLt7kfFLiHNY38FBJx6FlZ8yl8ZDHqde/4+Wyk26VDOlkjKo6RGezzz9OL+ZaQNJoZwwlgFo1zgoD0thXcOR7Cvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7278.namprd12.prod.outlook.com (2603:10b6:510:222::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Fri, 3 Apr
 2026 12:26:46 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9769.017; Fri, 3 Apr 2026
 12:26:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v2 0/5] Improve the invalidation path in AMD
Date: Fri,  3 Apr 2026 09:26:39 -0300
Message-ID: <0-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::17) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7278:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a03a99a-7685-44f0-bd50-08de917c4501
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	eWW7EqCD8Jr4/rLynulDlb0Z41x32i0pF7eepQPJ2Ix+4sK4ujQNJUld8N9tXko7XHsbRa9Q+nGkduy2XS4iPEvuCUL+J6G7PIneViRyRprMmOr04qP1PSknQeNBkankKlzQe1HOgabFEyMCkRjhQ1bW4R/onhSarreAViHDvUd2x0VS8JLsoPKchXLRPdDPbohmKMdymM4tTS8qCweYmsuRwfcY7O0APLELL+ECbZ0EqWZejvUr/meB3VyKj9eJYzuXCu/XYrowno4YmKkox17GqymWhPK/aKM1Bd10Ou51BwgmQ+ZKJe3IoM4ksBxtaorlMP4E1SVqxUTT+vEdJ9U4BGBqsrNfVn/1ClUw5WfH+fN17ozezqRjil9H8SusdJZeJd0XdbZEC3mpnuneS24WrzVF93EBVl+fNUSevCBBx9zsgE8SSv0WNtmfV7LTarHbuRTrPc52fIP8LPUi+Uw2lq7Sgf/ejs1pT2c2JikKGZcenYkhuGLSU8OWF9ZptClXV+3xTg9ZqEodmQZG4yVP4/FoE8ERth0T+vwf+lPS3AUU/a7X+kHPdmHYphVhFUZ9NtZ/6rd/Jdn4PMd9iGcQdZIkcJYjDkNdWnlQuKmyJvQ/xpRS1njFKT5Sc9+VwxGGgyAeSdgBuKFHeKe0P+5pFXGTz0JP0727FcOdEf6J0/ojplwuH2qEgV7cn9AP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6+/Eaw9L78RuL38mauNTHDMvQBCaNCRygMZailmvyi3rP/6oeHH3UT8rYRal?=
 =?us-ascii?Q?V9MVGBcjBp4eZmxhPka4xc8EeRbvSZFrfP0YagrJp92G99QwvQ4Agw8bhpBd?=
 =?us-ascii?Q?mHOameRaCtoM/l0jC/6SSJ3wvImeZ2dfgSQ1IuPcOboOaE5p+lzNgq2yrTAY?=
 =?us-ascii?Q?Ow0NjXZYwINlm6rJ3MiK4MPaMX53+9Y/rdKfpbH1krBA0YzgYorvI4cpw52A?=
 =?us-ascii?Q?AsYmaxSM0weB7hKf1TthlJ7PVKxp61VTCv3jnjXU9MmDRd8Yf5GSlmOCtvYm?=
 =?us-ascii?Q?bMjcHoZnb1R5Uh2RAXUh64G6GjVYm8fXAlq8Wbmj1aM6K21tVkijvLj2bbam?=
 =?us-ascii?Q?3tKYiLnEmhuwXKbC3NkTn2VG9KmKlzxZC5V18txllBlnmURt5/puTzi5WOf7?=
 =?us-ascii?Q?N5+NIfZRWMkgydVuKWw8ySMnZHPuCtDN6vZ+36bAt+5zJp5AozDm7fjRYgIs?=
 =?us-ascii?Q?/t/Gi6IEmF0Gh5JmrQ1yBcN2jdduYmOj3k9p2C5TmBxWObPkeQ0J/amffiCG?=
 =?us-ascii?Q?QgTJcy1dIkclZEV1tz/pg1FQuEMaY2foR8kPVtjvJmvpm59rSTzJXBelfR8G?=
 =?us-ascii?Q?sMh1jltagh92F5nuMZOcwv4+XEdGwcVycxIoFoTEeiAwH2QOpOLkptSmcpHc?=
 =?us-ascii?Q?4KU7pZIQpU9U9IVQ3hJeWL5SklJX6O+wy7FrdB0Kk+FaChXwjs8TSGYepr0S?=
 =?us-ascii?Q?+QX+rbI6XohvwBFn4srlEVdCHNxcfKxAl4sRV001SFxQiY0Tytx81zt+ieK3?=
 =?us-ascii?Q?Ua65UQ1T29Oa1dXn2VzIRYILJG3ltBNVkk08oMQMiEaAzhQyeXdvyi7rhOHK?=
 =?us-ascii?Q?pmr/84SRB/6E7eiBQscnt06BEjnFGheOM4uTHjyDpnsUrTspYkItKh4Unabc?=
 =?us-ascii?Q?quE6ACGNpSSWgbMgPx6Auwqblmrl1RhNsbRwmD7utj/UPKIyQy2S+aYbAS7+?=
 =?us-ascii?Q?laonP8PFgu7XZYQbgoNaUlLH9eCXuevCzM6FZFgeG4EFISWzj4gS/UFRcSUS?=
 =?us-ascii?Q?4YBMiq+eQz1nNdvRnjg5t1xwKH0jAwVl6kimj8Xs0iqKBQEnv0nMaRSiS19S?=
 =?us-ascii?Q?4SDhzRzxhkDzmfunNmE4RKk1xrfW1gc9bLXzYGzjreGjk/OtQyUy0EQMr0fn?=
 =?us-ascii?Q?WLBWWkCfsB9jdcfTPYICAV125q2ggJHywDrdgnSvMTO8lGwh3ii9TrC/IuJi?=
 =?us-ascii?Q?34/nXqEz7AWgdaWC1DsUHC0NW3yEJQqy14Pz3UFiNWrPbInIwmmp1KawD4OF?=
 =?us-ascii?Q?6si1/loU78VCPTm9twSWh3FAWtmMfd1ll0aY9Zo/QgD8yAaX1zkZuQptm9TZ?=
 =?us-ascii?Q?CuXEESZh1ZcP134PLDDZdYltanqhCTrioyyCE1loy1VPYLQKerTUbtx7ECHG?=
 =?us-ascii?Q?bcTUW/lQEAoFRdzZTTvc/TfPWH8jhKzZRRXc6HXBjT2EQ1vgK7mfbwWjG8mo?=
 =?us-ascii?Q?sSzYrpt2E8pfIofw5pmD6F7+smxQGarOHMQdPKOtb5SElsD1vFyCRohnXeO6?=
 =?us-ascii?Q?BwDFOIe3TAy1BRdB22eNO7sE1hcg3oGUyjppM+N3OAQ5GsxoBkM07DNdDCIg?=
 =?us-ascii?Q?0WMwcOm0+rrrrPmXNVVodIRAvEcRfG09GwnAPvpVG6RcOKYMs0Vre9YaA6/l?=
 =?us-ascii?Q?snyJnjXDQICLrpFkAcVdVQOCruttk4NPhWBbb+2xxOaBesBcN0fgCMo8SZl+?=
 =?us-ascii?Q?uBc3W39D5Ayl6mkLYNTi3123fmNsGG61Vjaws+YGaT84TmXK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a03a99a-7685-44f0-bd50-08de917c4501
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 12:26:45.6572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zbgTpe9LbLJKDoXhUcUQ7VQSjmH31fNAn2LvY/bmu/VkDEelIF68307Il39uokMi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7278

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

v2:
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
 drivers/iommu/amd/iommu.c           | 177 +++++++++++++---------------
 drivers/iommu/amd/pasid.c           |   2 +-
 4 files changed, 88 insertions(+), 97 deletions(-)


base-commit: 2f8407f149b2763146903649fdebf2cc575c3ae3
-- 
2.43.0

