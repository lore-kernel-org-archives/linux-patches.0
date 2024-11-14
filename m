Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F76619CCF9;
	Thu, 14 Nov 2024 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731614140; cv=fail; b=rfwwghEHp/lPzcyTNNa5xvPNOIWHRuRiriQvyJhZ8aWlkph1pYGQ1FuNYYKe6ZYlcNX6lYzbQb32ef8fRQFdIIQwxEGggs04XofKmOuvMFi/sDobA577RbyrWqQ/QSwlqEby+CVYHpLjm1PxGUNZ7hLA5mut3QzSR24pCwLKCUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731614140; c=relaxed/simple;
	bh=2G2w1HX63sRw2Z0kWgGG83c5+pM0A8CZ8RaiQwTaLpg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qjru/d/byVRg75RVzuAfBm2I6D7vSUzh5kjooNLJmLlouQJTuE189FCH+JhYm1ny+3lkdB/ER1ywmu9vtrGibSicS0iZEoXxEUwhCTtNpqxBtcE7yr+4ZnMwvgqieFBfllNzu+V42nd0iw0UKz/FUXRy+MDmUbihLl8Tus51bKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aeNqTnla; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aeNqTnla"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZGR/QRyFxybd2sYdVB/ucdgC5ei7HU0/TkXrImCTG1eMA8sPGgNG7Oss1VTN9XXfWbSYBDG/nqDLMDDlL5Zs0EUetS+TLBizT5IZLkw9Og9OE6QP5LoSzMY1ZQPdMa9DWWZaYhangcHxW8HMLJXZt3nQ6tOo6l4S31NsEWdCLeItH7ml/CmFwcVHx8M4zXQdI0FlKmTJhexLoGII1NJeoVJol2tqK+0gREEtF6cI7lLy2aRTsLeqdwRHWI6m9SQgASp8Fj7Pzv4DyxysW34F9JgbMpKzzAT4ML8hliA2akm1mBuJ7mB4acxRypS3iPZhZfvGSDO9ItFO56QqdYHcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8Dtk2wvMGrE937U+nF+QuLqyJB0q+rvMfwl4icTFyc=;
 b=wkO507jUzKgehq42sREseOhbm76NdCTHdA0VZzrCWLtkSi2dIe6MndJgYWA0sW8FrMEBmvo8C8nZOkwksuOcv9xQQ22lJx0ukY2facVTRt6tx/nj2sQpwgMoBUifHsY6xXFvB6nv7J/Dxr+ctsDuxbGbM34C+gqUZYHlQpWJabDvsjoSfNKPZngRTto2oxU2pM4YFX5xXwI5SxBaEX2YbCQpjMoCXLHA0Aw1+GBBhX9tCt7F0RshuH3wO+YPZiTKF01m2lvNeKd3K1F9jdZZXKwR8RVzMab2Q5r9BNn94f7qw9LiRqyM+XD7LazJ8nmtA0u4cM3A2hhX4gkUhEI9VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8Dtk2wvMGrE937U+nF+QuLqyJB0q+rvMfwl4icTFyc=;
 b=aeNqTnlaNVdSqMHzqXAX5SH0ZL1wsbv2EVhA/E4K9raeHlc0ap23ISA6Wtt2gdnKsMsv86SymkgipzzkLLfWc1YWRvM/i1N0CnqUDHT4pzYKMhhzaXtLdSwr2sBiC0ufchqOttoRPrIjLc9V+ptzyVqG0iVNHrEeBM2HCad000Do3EeiYJ1TiqELxLoMDusP9eR9ug5oEi2KCjrqSGZiZtG7N1juSuWstz70wmdWs5yXb/VsqTOEotdlUYF9St1B+GR7lxQNLo5i568+0H1XP7y0OUAuaCSYyjYAZs9y/v5pJsVwoM/Ds2Vei2npZSSEZM4zFDXtpGDBqY3HaOg+Zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB6563.namprd12.prod.outlook.com (2603:10b6:510:211::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Thu, 14 Nov
 2024 19:55:33 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Thu, 14 Nov 2024
 19:55:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 0/2] Rename ops->domain_alloc_user() to domain_alloc_paging_flags()
Date: Thu, 14 Nov 2024 15:55:29 -0400
Message-ID: <0-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:408:ea::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB6563:EE_
X-MS-Office365-Filtering-Correlation-Id: f95316bc-4b88-4a12-0a85-08dd04e64c37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zzVKyC1+UCLwqiPCAPibDi2sqrX0EkjXpay/1SVWzGsPkPey0lyiAJvykwNN?=
 =?us-ascii?Q?f3wMhhYOjQmlZuqoELJ5zHSgCt/QmsMV48k3rFgjXtNR7tFkSMVFHUfc9Slt?=
 =?us-ascii?Q?TkOEHyxtgYs2pzsqvr9BGaiNr0kxQ8/ZG5DxpxSnk0hYVP+WsryvjDW69JV0?=
 =?us-ascii?Q?wLky5VQsDkjs5tm051e6tRhm6H0le7Qxn2HrlhSBbnKPaSJfXmlaVr4apIQQ?=
 =?us-ascii?Q?OUUBfZfOa5VBJ2s0Z/E6Pe+Z1NjehMJ28bMkv77BQGNH+S3TAzUeiCQw240k?=
 =?us-ascii?Q?evIAC0VmH6RxSAApD1AqRFQf+HDztNvKdkaDzDy2Y5Nsk9FnFkEfAkuqxoAt?=
 =?us-ascii?Q?m2iKQ3jnwx15lqu3wAx+aYv1MElXJH4FDtfPVh0LAnMZfpZS26WJZHEV7Mm+?=
 =?us-ascii?Q?1mEPDg8aXVlBpc7WaxIgp2IobFG0xXupQBiqywEKA3k1tKdtpAbWlqB4ErGm?=
 =?us-ascii?Q?D3BgTNnHXpJlXeeD56qSK5CKwLAGsATDAf3gLyqh3rgN/8HyLRlw6IqN/BhQ?=
 =?us-ascii?Q?DgiutSe3qbzEg/IpkstJSZxDfpWRLX3y3m1arSzVF3I/kNXE20XJxlL7vuJb?=
 =?us-ascii?Q?2MMwB1FbExap+IUgJsSzPXAZfmzAaq23Utn1ADdBQ2coCWDFbKVwch2VWgnQ?=
 =?us-ascii?Q?NgsuXrDYdg4CpmlJxnVufCE6w7i8QYDv8cn+O0HRgKlJeJp5QLEtNOj179OG?=
 =?us-ascii?Q?EduFNcVX/UMIjwxDklgSQ47Ohwc4qttEN0v8ImCNIwlHvQ/hFIh7XoFlZ+iB?=
 =?us-ascii?Q?i5753OxWFX2WMZ+gqcC00e0TfJIME3oCan+mas/oFYVoK6CAdYYXWa+2Bb9A?=
 =?us-ascii?Q?TS1djnhq2tAshW/SZIXzJ82bATXAIrwfzFrlWmrB0fwkrCa9N4fokMeTrrcr?=
 =?us-ascii?Q?FUtK95f2T3daxQgIS/vdUXu9oZoAczltKh43R7CZSU7++qxAigf5oSEwzmyb?=
 =?us-ascii?Q?HbFgTYCn/Ot32k6MPp0Az6MpzxT8uIIcnm1Iza0O4ie8QhjZAs6MLMRSAdB4?=
 =?us-ascii?Q?bPUvtoIs4nvrh9v94bqjSVqAJyRVx+6aJNBerY5EOhRS/gbhdC9ME2unjizq?=
 =?us-ascii?Q?brRNrtgNYS7ftee0XNzh9lsZPzemIqKyL9w1YociIHea5LJqpBxqFI0Fbxov?=
 =?us-ascii?Q?/X0GhEuDExbYUlV2M8LjCzjBXXWmc4fR15OToER68RN9zYkDO5LfIsRgyou3?=
 =?us-ascii?Q?synrS6IzpVPeIt0xq1jS+wXoYVawwcVrGCW5u0GgmEWO+voUJrTCkoE4RExd?=
 =?us-ascii?Q?h+66eenbsITbiE7mut4FiHvjMsT3pb851c/iIFQ9H7zDN/2tQDTzkZ06/DvA?=
 =?us-ascii?Q?1TN6h1QmXCgVUhxAEcxAFYI1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Muzu1+KEiZeQvs7ckxLyKlC4zPjHoinQohKd5RUUX/2WOD59NqPIDYXPaEKJ?=
 =?us-ascii?Q?uC29GNiZcRTfzRsiDtAhs1b/wsMOLR6AQDmXRyNu8NGqX4Mwnqmfa+HfZsr4?=
 =?us-ascii?Q?Ni/6ZprkM7W/M5inzlMijQodCgPPyk7cxZshEzvzQqBwOL0UOPTvr70GzMr+?=
 =?us-ascii?Q?PE/Xx4BNnU8u9kneF9sFRo63DdF23THFRIFzGygtA7kiha1/WkN61J8RbaId?=
 =?us-ascii?Q?1sKSAU7ju6kBtwbhDITuFWJUZU9bprWUgy5hUfmm4zrLmN4ssUrP8lcdB8yr?=
 =?us-ascii?Q?nemtwe1LzV/nErq0GHeErRiXa0Vx1F/jOR/D/aDMYYYPEMv3sFN6zLR9vD7H?=
 =?us-ascii?Q?p3NM/FjVZ53tcxB4iGhbFBLoFiA9oYBLM2UwVxRHM/A2m9WcqQSUljFA+gZJ?=
 =?us-ascii?Q?CE/DTRQ60sXvUYwCZ9Lkwquo8Fb3t9pAi2lCHWGkMuiJRhHRq79wHodVUeQc?=
 =?us-ascii?Q?D9EnfgCw1ZJLEcf2LeEzqDG1iE+AXSwAlsCh2KdaASUuqQBjlYakZnAtvqkx?=
 =?us-ascii?Q?BPB3rGJ13mn/WsJD5wz9T2iGmxg5DA9HlHBJoymvue38mKAsT/TAsqePcXAp?=
 =?us-ascii?Q?AF4SZDpA73FqWVIBYLS+kwiDJfSTE3stRUwbSquIA/kv7ddUh9vOVTowxqX4?=
 =?us-ascii?Q?YwJedt94sQuGqL7ST0YGT84nomwEo73J5lry+O7pw7VDZoxLPdrFuPo2rv4J?=
 =?us-ascii?Q?faatiQuOV07kFT+a/ecEJn8Zp8yu7b2HCRQUbbQSj3ozpiooTLjMZdJAFs/t?=
 =?us-ascii?Q?7blmDZdr2Z0JH3Qow8IvS558QWalH+tJb7MUGF07kaMohYRz8v/gsoAlhcDp?=
 =?us-ascii?Q?s7UIKlf48/pP+vCQi9LTCe94svzFiqkf+bb/wEyY3V3GRe4kBaxlDunKCScf?=
 =?us-ascii?Q?8YrDwhFBowzDd3OXWfXhynOO8/i2DSojGaV+4W28EUqdfWQFmtR1blilBH4j?=
 =?us-ascii?Q?yHw3cb9GhUwREqGqklYiwJx6WqYi4k2i/4QXLGwXSW+zL6KB6cgr5HH54BYv?=
 =?us-ascii?Q?zz58wauDjxEvATsEzJGvKMEGSl6V4w3DbV+3XXSzDKuivnVjlDe0ox4qSHkW?=
 =?us-ascii?Q?nBH4/VHDjB6foBsKL2kw1X3xuKqAQqfGURWUd5wp+tZeRK7HHtRUiPQvQR3H?=
 =?us-ascii?Q?ji3E4t5yOz0qgAHbNFJpV1ELsxbP16vWUvU/sNEWwkwbYN5WbSzpsva91sLA?=
 =?us-ascii?Q?KKX/fufLv3fgUoRxVwMgrKgRu2/l/SCxiage7YgX5JrrP5b2iuixJy86Ihb6?=
 =?us-ascii?Q?asK9dwl5+m74BjlfF8MAFhPfDvUdEqId4FqqeO05MU6VZIrY21+BtX1xuO1b?=
 =?us-ascii?Q?01hdIvdlKiDiTIt7T5ygUP6H7hnLXQMT+FJGs7T86JbDmr/y5H60GPy71P9Z?=
 =?us-ascii?Q?4jtU44KIHCXcEU3gP6mnru8jtWzRqJpkXEsZBxF35BPCn0G7pZBgiY/hEu1b?=
 =?us-ascii?Q?wMx2qJqcLeb7md3s3vjqS8jjBdu801JNGQquMkEi58V7lPTOZ8BZ1rQRhpbE?=
 =?us-ascii?Q?QQOlCKXD85bceYlOC/kLpDVSiJcni6S6IV5dYA6avK0tVf5KHVrK3Aj0wayk?=
 =?us-ascii?Q?oOoTHzaKk5+dwx8kPHU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f95316bc-4b88-4a12-0a85-08dd04e64c37
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 19:55:32.5591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YpC3ubUl1Y6W1cqMuebyNzOy6AylLXzAJBCrQu/wOp+kY/LpexKczx9gQVqMBNOZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6563

This tidies some of the naming that has become messy this cycle. This
series is on top of the iommufd and iommu tress as there are dependences
on the iommufd selftests files changes.

I would like to push this into this merge window so that the next cycle
can have the folowup got through the driver trees. Otherwise we will again
have conflicts and problems. I have written additional patches to
consolidate the drivers to use only domain_alloc_paging_flags() instead of
implementing both.

So I propose sending this as a late pull request in the second week.

Jason Gunthorpe (2):
  iommu: Add ops->domain_alloc_nested()
  iommu: Rename ops->domain_alloc_user() to domain_alloc_paging_flags()

 drivers/iommu/amd/iommu.c                   |  9 +++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  9 +++----
 drivers/iommu/intel/iommu.c                 | 15 +++---------
 drivers/iommu/intel/iommu.h                 |  6 +++--
 drivers/iommu/intel/nested.c                | 11 +++++++--
 drivers/iommu/iommu.c                       |  4 +--
 drivers/iommu/iommufd/hw_pagetable.c        | 16 ++++++------
 drivers/iommu/iommufd/selftest.c            | 15 +++++-------
 include/linux/iommu.h                       | 27 ++++++++++++---------
 9 files changed, 57 insertions(+), 55 deletions(-)


base-commit: 6143bfc47c18a1505b8f4cda83432c24c842a6ce
-- 
2.43.0

