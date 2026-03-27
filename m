Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337CE3016E0
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625046; cv=fail; b=VqJ71KaSqb4J64NVXFjdVlzqo2x6HfzUsfz9eIog5P0oGn2zfZ9Kb2rk8t8jyqbiyzfTuwjQwvxlN14W/zItkS5K/5wLGEwstWZN3SvQ6zjrxYtMoWe5cHoqfxpX9gIBaxRGTuFBePgyjg9w/Dz7+NtoCkzQH9kXSJa9EuSBu9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625046; c=relaxed/simple;
	bh=2Oe8siKN38KUW/K3fkIB4HnalW9CEMn9ROPxqE8Dru0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=j6YeaGj0jTkVZ5oZMeuKXRGXrXMDeHm/gWItaX7qJEQKi7W0J9IXmNNTdqTtwokCndQGDfuehHsniAtxneHtPZfHOQEPS6yraoV4AZpMlJbIy1nsNlFC64VetNuGbkwreqylzrjHY40yfCSALLSwtbVULKhA+RgwUTL2ny1sL6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=egI32I2M; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="egI32I2M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BEW2xkq9/FjjrtsAEi4Ny8Qv5VIZBEB6dSEXkEoSNtjhnc99b18Op872CafuHDxJTJsSBdcpORTnJyMk4NCXgSmuhevynAfrWY2byhtFWPA4yS/ddB9lGNP2wnTTBBrL7x0e623Mb34eqIiyX5O5Hn1fB1Ouen1OhW7BtiuStUyFSUN1rfKQ6auZMMz7xaY3iy4f6E9dE+ZUyMCRcLrf1zDpY8KkcblFtYr8cVxlcr5bGa4yMUguzW3QDkEISAAZ0H7BnO+aMEA8BpQgnjgEJssF6KlbUFflj9Y8KkvP4Hn2F/th+//8tA9nwAKX3g4h7RAwat0vj+OEwRONaT7OBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdCrpZYc8TEqqK+DdWwfH3ISDo7OB+SGVfYyEtfhydM=;
 b=e6Ne3jhTNbtj6nmNZgxRU1EVWoY254JimtGnLMHS2TaCRC/lNxMhHRkhe9KBOqCti4HWsUfan+GXGoE7Fq12sB3HQoakRWNykpNmk0dQsIU0km8DnjiddzXq05Mqy7iceGTmH/Xb+/2GqhG5aXEvft/1QDKkj1p1qfFeNmyYT7dAqgmj88WuI6xG2OimW3z6bwZzApaFrtaYE7vYP64ggYmyue4wR8Yo3JnZqWcpTKud07XSbKUGYio102qi0IRSMUQoctRE3QQDbwSLHBedWJnns7o0XwezMujn1v/VORwSX5f9KI6vaYDm0g6zxlWOJcQHCYZ1G/hvGcPmAISoRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdCrpZYc8TEqqK+DdWwfH3ISDo7OB+SGVfYyEtfhydM=;
 b=egI32I2MBfmM8SmwMeUKZ5lHQxBd8KYLvfqLSKbCDFhelX2adOmqYp/DT5SDxiRcoEjYqjkYTJP9g3GA6/OZCHJ/26RWlWCkYfVP0rOYFF+y+C2IqhwwYB6DNs/vpl2NrYGQRDE8s0+uu41XDumg0kSEbxv70UqhB91xbKNUdD0rOmJvQDLTyODQecmGuKAhzFvStJK4goqAzOf/igU4b8ss+6Q4lEo2Il42rTP2jQm0P0skkb1B4y6vtTyZSQzfXeH24qPhympo0BxLp9cSE9UPVFNJnHWIkZp81LK+ZMkdwwaYOuVj3xuHwh9cPuLYwjGsoFG+0l94bAIWn40xEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:24:00 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:24:00 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 0/5] Improve the invalidation path in AMD
Date: Fri, 27 Mar 2026 12:23:54 -0300
Message-ID: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ba763c6-47c6-419a-7082-08de8c14dedf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6eM1nYXy90gAWS03AKZYXsroRBZ8wof99c/B8s2kdTWNVLjjHpXkTNHFAXRBJH+3hwEyTilZltwePe79shz0aoGrR2KxNhQa5uLVdjZL08e6SuJH/mA5geYDrza/u5FaQS+YbLyE0o146YsXBt7FgbCUFSknHmOWQGFKZGFzylL8z/QfeF90ZQ7GLFU8t2eSOgsMBXuwxQ+Ik+qw1LPAqKdYLnFgZd44NH/w1ijs9F3eF9wsHp+SwWm/PoNFmhsddE/Z14KWT1cuFWrmJS0gj172l0br+wBzv4NYwA0bBM4qcGSEkwQ9LW0fMfTNxxN8VocY8hZwULPqCCEcVTt+KP31/H4Z+ksJwRDMYYlbaHiBQruzGZ6XNLXLOJsU+LChEUVqqFtk/UU5AR1WESCFUQy/nUOfimht/AYYEf7qeR6J/qqQ6KTQcZHCt9xMy3bZLXZ4pOqXIEfVfLxd4ZyAtBt4wwwu9RBjBRNLK7zDJbL1gJGleeI7ULXb/t2KU/wMCD5flrHAmt63Y+q06seU/djTVJ0HtM2MYtQ7oKqlTN8X16RmX+E1Ubi96xjToG5QIuMVoBj/oveJJf7lTs9GyiVY9CxcvHhWLaFkuO/Xm4lgPTlqiaaUl3FOk9SqReStkM+yLOOnBJ3x0mbeS7G1G8HwyTHjGaMQcrN2iY/NiGvbgG++92wROD9R8upZnucImGDHd5Kdx7tGffQ1oENoZyrwXkVwqT6HnqGoDGgfDeM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D6Ok/H2WIkUtIiImbcxQOjqaSdGobiW/qdz/IcEaRrEOVBc/ykNzDkCfU3Xc?=
 =?us-ascii?Q?3F7D1U7i4FOYt+Xvcc/hLXveQmeMZHnsXbvKtG0bHUqklnbIBhPCCYbvMWDK?=
 =?us-ascii?Q?1BjkM/N8Y6PKr6sy07HWo3cCFZ5ofun1ckpjru4t46xOamA0w7+WVVUpNVKM?=
 =?us-ascii?Q?ajbP55TZvv/vIJq9bXKzCEm6OI3bYq1HWsVcJ9xDko3RulxAYAB/tNEqp19v?=
 =?us-ascii?Q?0ryLbk/WUP68u1eH97dF9sDFNDRK9u1jRviWKftxGskcTvu52vs/mKHVlaTa?=
 =?us-ascii?Q?L74OZcZB5VIU8p0Bh5KWJOdn1WhYBzgAybIk4ESnrWwlMczqQGmBsmQ8DfDi?=
 =?us-ascii?Q?lwKs7Y312m5kOwexWsEG/YbmQRxasP6B9R/i3LgM918m2QjzlzotcaR7f1TG?=
 =?us-ascii?Q?lYSZFb4eL6gb6vNxdiPuE+RPfocVNbhGJ1nU4rTCcmgkBlv57g3kLSXtxT5u?=
 =?us-ascii?Q?5WGMxQRba2c4tRBr33ohhletajEj/y/yUmROsYFgxk8R/vb8ssf+fyYEd/pU?=
 =?us-ascii?Q?6Znk5SVmUhsXoqt6aY0EFoGA+N6rEZPcGxH+0xxCk6whUt113YRSafJZH8wa?=
 =?us-ascii?Q?CQZGJ7tXIPtj5RjQRtErbdMW2cAwN4UdXHfFLfa8Xs/70tKSuPOUk4RW7GdA?=
 =?us-ascii?Q?4M3QGMxlaDdnr/HkpQw5GNxzglrZ4ew3ccPH0vpBt+ebm4rsyW5dlkfUJsqq?=
 =?us-ascii?Q?v6tqgA8YtPYpmTCNlupLie1BO2N/F7owSOPzlFoCETJSkZa2TVUQ8NFQcVEw?=
 =?us-ascii?Q?jz7oL5O0o1X8l4jf3zyATqlxCW5LvFcw2eI6XU20iTzmyo3BiemF2pmqBkxv?=
 =?us-ascii?Q?M0AbaquwF4LAvAobISdQxWpR/KA5mSqzds/I44nDen/0x0cOSX5T+nwopP3K?=
 =?us-ascii?Q?IOyxqKn8+ibJdFkBkh9sBwdQZHfXSM95lwHaqgXsNp7/ZXtZ/uIDiFN5/3K0?=
 =?us-ascii?Q?O/I5nMe3SZyynTBl1eVZ1jnhgihjGBYUfQU1YoDpnmg86AQ/+DgbIc6wuYrg?=
 =?us-ascii?Q?HE0a5DCpdc8Jome/jWiDuWKHTGV5FOUCPgPBYyRMK4sXnznEsRZl8mOGFB+f?=
 =?us-ascii?Q?ZWisPED900ULVkEMprCsLb17bLuKXjzWcEuOuVb1AnCRjmVIELZ1nEUzHmct?=
 =?us-ascii?Q?Q5Zc5X9Sr2/cGnr4SD8niQOYEcsCX3j5lDUehNkOuEbQd/0+w/0kSF5BxfP3?=
 =?us-ascii?Q?exzyYdU+tm6uqrjeMb45wDQ/ASpIOgrPV4vPTSQM3/tNKq+X0ZzD4fOyw2u4?=
 =?us-ascii?Q?uk+gM8Pd6mhULecylwI0Bpyehx+olV0wM6zfb0rw2xJblpjHDrfvba7U4GSQ?=
 =?us-ascii?Q?E8KWuDdG50fvJptvhHtamjVX5bmMqZ8tDuzrS3rqot0Nn1xU39TBqo+3RDLU?=
 =?us-ascii?Q?27XRJIfbFT4dxhmlkjHzJkbYZuhjlyDUV+wYEsQXfzoTQNdesFxs4gbYF45i?=
 =?us-ascii?Q?BxEBqVQnp/mc1RFP+IxhcrHA4ljIMN4P3CT+5T8HhtDT7y5Q8y2SjavHMQ4T?=
 =?us-ascii?Q?aeJqpZFs1z2qDXg9tkeAFLHYzK0ei2JMY/MHcrel41i4AlfjnbAwxvbaD2Y4?=
 =?us-ascii?Q?jss3gtRIfvb3ePYvLmzk/cIs47tUKDSaBk79OCwvp3riPggzkWk9VYGtZuc8?=
 =?us-ascii?Q?kAAjlrhoyCYnoj592ei0iHEpKqJh7wltZx9qwf6HSwBMgHCc4y3734B3IwdB?=
 =?us-ascii?Q?EMsbCBcfHnG3491SacSDPgBSFdevT0XMx4k5Crr7co12qIgD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba763c6-47c6-419a-7082-08de8c14dedf
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:24:00.2029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QyhCWxjHApnY8ukQhHf/CzHg5ga2u8cP9oK61vgQn0g945ABsX/wzIoF/8Tf2m6C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

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

Jason Gunthorpe (5):
  iommu/amd: Simplify build_inv_address()
  iommu/amd: Pass last in through to build_inv_address()
  iommu/amd: Have amd_iommu_domain_flush_pages() use last
  iommu/amd: Make CMD_INV_IOMMU_ALL_PAGES_ADDRESS match the spec
  iommu/amd: Control INVALIDATE_IOMMU_PAGES PDE from the gather

 drivers/iommu/amd/amd_iommu.h       |   4 +-
 drivers/iommu/amd/amd_iommu_types.h |   2 +-
 drivers/iommu/amd/iommu.c           | 175 +++++++++++++---------------
 drivers/iommu/amd/pasid.c           |   2 +-
 4 files changed, 87 insertions(+), 96 deletions(-)


base-commit: 6c8f61b36b7efec0f8bc284142f998d30f0a28ba
-- 
2.43.0

