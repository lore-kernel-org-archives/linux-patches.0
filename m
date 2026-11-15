Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785455;
	b=OMz1DT0ySGARQLHQ2XF+brwgjUvpDEmGtysFTtMYpkqTzgYeCkG4vu/tTNGicMA9NsK0
	 Ld+TdHHoXxeKIhi+0cJpErllBN3kf+2gVe0n3wuTUAWAEZt917FP3+5exdzu9XLuN2BxU
	 5myFzfVM1lgqlUrElTLOzOBs43BmSLSE7sUVLe52OycPeMdYjPuV4N1whdLCGBkKKCSan
	 xTVzq29yRh9m07+e+IuHG1C+TFZwGkxUUsVkQI0KyuUkPYRKSlE43Jh7Scj55Dkg3IvT7
	 8EMLnVDeh0KW6TiwUowtVk2chrjWvPfzcPrKGjMsZUVmrKw4Bi16FGxiqxuGJ+0hOIg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785455;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=sNCjvoGtX6vFzCMCwYP/EL6WkBotG7FL2h03cr5uILU=;
	b=VxwcpSminZI1oQQuZq5V5Y9x7V79gzuRQXJ62j8py6he5PyVcEi2zsV6K75F8eeQkHy6
	 AQpVnHRS+/OaD6NgLyeDl3qS84aqtmO9gzMANOTgXKSj/YDjpmibzVOgvSEXoKxC14hOe
	 TGfQ48iqmZ2XZuQC3YAhwagIuqFnCRY0EePLVOzlrnQlbsGEA950ULMSNUenwQ9h/7/O5
	 BFwObTCUuEnHE17n5rAvwoxHg20BLspkzFsnkIUDswluUlWckzi3Ny1EymD5po7W2zy9L
	 90aLHswVfVOo/jBxZLWpifHkoD/mvTB20jqvrxJfMzBXFr7dzZt/+rhDgS7vqQp3dhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MsYGa9RW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.60
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012060.outbound.protection.outlook.com [40.93.195.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40259606A33A;
	Sun, 15 Nov 2026 23:30:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40259606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MsYGa9RW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=McIMV1qCdhXmdFTUCj8bmpCnOVumvLvRkajRvg5106hs2IYzVw8rhtuLQ08kkdPWLxEon8uJcHsB1Z+61ro0xermWq01/525pZf8KHQ8IHj1Q820xqv+7ns0kDZgMDqTy4Q/jvMyL+RHNMqnI97H+JpVYm04y/HIrnotHP7fYIiscfhU0J2u2T9g8nB+WJDPy5Q6UBU5H9bZLzAhkwWreW5iXMUYmCequInStZulVaf1n5uDfZUXfKZy8heR+SHrNKERDB0IrdgrJrsjUQrk0k+BHBPkN1xvl++v9+NGccwgBPm86iUfwx8jrJHnPQCIcPVpeNPTrOmJxN8aMPqKBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNCjvoGtX6vFzCMCwYP/EL6WkBotG7FL2h03cr5uILU=;
 b=tvy9H6xhH+HHvC7Tomx30kKZFYUReCh6fTu1RfvnEch+hukeLjXFgtFmgeR/9ri3xnXR4Uim/7oyHMTwkOEPfCwwpFvRuxCP6Q07WSU0bdrRVuOvs9v0TgBJ0Be/9MrYtSFI9nDFwlehMwLjsViqvCeF7Ix1QFRolQEfjysl11LKW6/n1u8v2+m7z2Laf2An7YsZnItpJ8CdPPLYNIr/BBeSgStEZ52BmOREb7OVcd+ZhqUM0er4N1QGziUD0zUeMdzC8fHFj+AU2EjcjeDu/ftzNDPysYc6iFjq4o6km8Suvdki/dqiVrFUCeNS2VB9ebWPZPwjs8W9I8YA9VDYeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNCjvoGtX6vFzCMCwYP/EL6WkBotG7FL2h03cr5uILU=;
 b=MsYGa9RWzxIuYSYhfFgWa35oQc6vsoXa6yhqVBcZIIbEY+PxwS/iF2CjqCGQuMQ1ypGbVA3ZbwJ8a+xJLkjzAO7DHv0KQc6+gbSQmf35LZRVwbxNrr5vzlz7cei2QYzzKDtMq18VQxkZuvLDajhpD/ifAntsYfnHaanRHLwA4Dh5F+zHrYWniWX9qHPCtE90rQVpD/fHHmPBMCfPsaCx/ZgSDeU73SJ/1dLysxvI6VyuCX7Gc0GGp7xbOeIMvZM9CVrd4s5VmdlIw61yRREZqu+lS7f6c0EM3tMfdIy6UbSJmKquu52WTYdzqUveU4ivCkJ5E+V9E6zftj0Rc9XD9g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:48 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:48 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 11/13] iommu/arm-smmu-v3: Support CONT in paging domains with errata
Date: Sun, 15 Nov 2026 19:30:41 -0400
Message-ID: <11-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:208:32b::13) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cddb170-4064-4162-3407-08df43707905
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022113327099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7tQ3heEURrMLkDTJGh1nqlFwctAqY3BbOTE44pODC56TGzXK4LhbRVeXAuobrkycq1zWHFwz8E5Qmlo4UJnZbhSjPZCR0UiIjRptLMhVosJGqx2b/PHHng+SH5Ml46SJwqlSukLOTHtICCfHeWONYLmVI8dd9fG3uB58kZBumNrEBrQ/gVOa67DWOFEEbaxP0yTL7SbyG/EfSqTFWgo6wDGB3gBWurxATZRC9pejrInZeAGKyKvE2VavDUc8rBT6NDgcaz+uIDNB1vs/FGhcoFmptbQBhcW+o56lZmdfwngzWbk6a1cYA8HNuFUXWBbpMYhY6/48U8/9dzCpIJ+C3YakpfSh0v3U9bif1aENxZQmrvWboeSjbu18Ji0nKdi+PaoQKg0h98bnGkpliAdwkUxoZIBS0EokJR0VT/2IDTzDk4/wJMp2quY6qoH2gWmh8qvMD6Gn9e1++odHWV3+UdnXr4/yqXoLDQ1R4w0u9gqDLv4IkhZJdBqgJYxaZdYVUK9zSsLcV/0Gw1Z4nmtpQBH72pS7sapOGCCMICeWcMhpYLTU0lmYrGzpBKV488+6/XaQWIYsS+d0Mwa4MuxX129qudyHy1/nuGRHOj77KJYyx9VpETS1GXr6Linlc1xzjYFTBrw2G4tKKj6IQhNRScNwvrU3kOFccuBr7J2liLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022113327099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i/U81s64xyuZ6FuEn29QB4ojdAqVeVabwaIXYo/fEqJ9c98jdfSjko9WSy6c?=
 =?us-ascii?Q?bPTcpo4HhSC/lSMoJzgMRn/0IAzl8o/QrqFFKaAqz4VWiq8oNvAjegZklRN9?=
 =?us-ascii?Q?McRJdZqGhBFoCA6qcVdyvQDxgyWU+JWzrKem8h1e0I7swBnumWrXwl8F/Xyd?=
 =?us-ascii?Q?c9txIEkQOXAC45n5a0IW2AitQRlL2Hg55yynrTZvRbuVMZQTQeS0fmzV/+7J?=
 =?us-ascii?Q?DjPJ9SBlultllzKNmKEkxFiqdtB7j7+xjDA09wm6K6aILKea36/lW0cv1K9x?=
 =?us-ascii?Q?ZgX2Mn/abd8xG3T9RRlWvmll47/mDQwA/qhM5KNE4qTXajXWPYfgiBV2W4CU?=
 =?us-ascii?Q?DT4EUr0fOl6X57dqtuRU/mpa7HAGRNxe5dn/LBeHYYXDVhWqX81u9dLjkqlK?=
 =?us-ascii?Q?uVSJDYMAj1uvEgnBmz3KtuFWvbWfj/KRvzSgdJdcwJVKoDSSMRYOkujQHXjb?=
 =?us-ascii?Q?FWqoKjW+FpyOwtWbIUscEjq3oIYxiKy5dPPvZXNWruiRXXoaSmkkXTCSWQ1V?=
 =?us-ascii?Q?923lGE+YuPErQYmUnZk0RayC7uhOolk3sW76XbX9FM/sQMIy4TF7E1OAt6i0?=
 =?us-ascii?Q?FVxdTZkzpFtKxgXs82LsSKFh8Ln5hIydEeuFbyss70WkX70qrJY6KuyejZnD?=
 =?us-ascii?Q?sC9O/X0zR0yUeyzXIfvRqRzHe8vRBxCCuijdHxE6usqvWrMx4po3zdShRR7E?=
 =?us-ascii?Q?5uc0lRPL9y/tUcI7rVqnEBRxVm9Kzm+H421syECGN8cbTLoryijllQccJ+7/?=
 =?us-ascii?Q?Q2g0tb7Fy02br37QnXSbpon0hG47mS8Bnxlp7RcSONqWGNvi9EvGVMr/d7tK?=
 =?us-ascii?Q?cm4D4DRA7z3oAW7gRLmGr4poQljrvxSJIWo7vzh3NqdWr5ag03Dqz2rC8XXQ?=
 =?us-ascii?Q?TRI7eaIOJrhf9rTh9KkU12fC61ty6Fqylsn8IeUlvkGLInko6XQgu6p7J4g5?=
 =?us-ascii?Q?fePl8b4r3p/5TrX2TdANYRbBD7vQVkArwUUVSpT3lEW2FtWMFcVgkTo/+psR?=
 =?us-ascii?Q?Di0Uu9toKZIwRWTdAnA6CWt9qC9u45kboWtTjg3QEBQyY8tq6bXSvchHdFLq?=
 =?us-ascii?Q?NUNncecnKbBgjgVzRY5aH8Gp8NxrDJoI5eQ9VDLizKdVbJZBB7Khko/2X8pZ?=
 =?us-ascii?Q?7sJ8oZSQgnbt6obE8fMBrJ9iYk44waeRscBTheyujuoYVwY3k1NoKQNNtOsW?=
 =?us-ascii?Q?PJ2BxQnae4tJ+YZR6YTNlxKuARalnoxs2rxr6IgL7TPOZf+DqUTksEThpLS2?=
 =?us-ascii?Q?e+HOcr1jIDtVxdocn6+d4sWFsy5donRCpUhrhfzLvfNZC1hnfsQV+Q5O33sQ?=
 =?us-ascii?Q?9LZIaME7Kb0uOVDJ3ukvePkf06hv3HExs8frxD3FzP1uJC1vuffps2QGeT3C?=
 =?us-ascii?Q?qLyxQGb+qpmCE0fTw5DdzSKhl35qLopfRFWZ7ZLEJ/S10xhUgYrwn0UMb3H8?=
 =?us-ascii?Q?mhbbVJy2Ntz8dba5Vyq1Mhe+NrxgeapMFc8s0KJHw5vwL6JbZPfxsa+5QDvw?=
 =?us-ascii?Q?Pw1GjCNygOFToHaMFa00L33Ocb6aI+A+UrhrYcLCvPFvtdmEgK0Yxa9d0wz3?=
 =?us-ascii?Q?bGt4ywAGdL6tl9WfQqwcMryl348vuJpWN2+6xcSCPrsJRKSNwISoMK74jZPR?=
 =?us-ascii?Q?UuS6BaeBPD9jDzsNVS1PKm7SJQKz9paM4P3B2jJJUWodyQorAK8p0OQuw3uF?=
 =?us-ascii?Q?ypV65NOyf0XUJ2lpjMXNSSdBZSLdOZE0Gl+pnMydJ0QwXZjW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cddb170-4064-4162-3407-08df43707905
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:45.6974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j59wDXn/LwzfzmaMzJHjJJb4M5LAgAvpEhPmGrH0m0WCp1ddWpJ6KjH3cQRKURX/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

The erratum (MMU-700: #3777127, S3: #3673557) deals with under
invalidation of a CONT PTE grouping in the SMMU. The previous fix was
simplified and just assumed the paging domains would never have CONT.

Extend that fix to support CONT in paging domains by making use of the
leaf bitmap in the new gather.

If two range invalidations are generated then the middle overlap of the
range invalidations may slice a CONT such that it will be
under-invalidated for this errata. Search through all possible CONTs in
the gather's range and find the largest CONT that could have been sliced.

First try to extend the existing trailing range invalidation to cover the
CONT range also, if that isn't possible then issue a third range
invalidation that just covers the CONT.

Since iommupt will record what leaf levels it is changing the search can
be limited to the the CONT groupings that might have actually been
effected, and this in turn reduces the required adjustment to the trailing
range invalidation.

This allows all CONTs to work with HW that has the errata and requires at
most three range invalidations per gather with no over invalidation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 165 ++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   2 +-
 2 files changed, 152 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3eb61eb35d0b38..c0daf5102d88a5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/pci-ats.h>
 #include <linux/platform_device.h>
@@ -2516,9 +2517,24 @@ static u64 arm_smmu_range_inv_calc_num(u64 num_tg, unsigned int scale)
 	return DIV_ROUND_UP_ULL(num_tg, 1ULL << scale);
 }
 
+static u64
+arm_smmu_range_inv_last_tg(const struct arm_smmu_range_inv *range_inv)
+{
+	return range_inv->start_tg + (range_inv->num << range_inv->scale) - 1;
+}
+
+/* Range invalidation A encloses the range covered by range invalidation B */
+static bool arm_smmu_range_inv_encloses(const struct arm_smmu_range_inv *a,
+					const struct arm_smmu_range_inv *b)
+{
+	return a->start_tg <= b->start_tg &&
+	       arm_smmu_range_inv_last_tg(a) >= arm_smmu_range_inv_last_tg(b);
+}
+
 /*
  * Initialize the smallest range invalidation covering num_tg and ending at
- * last_tg.
+ * last_tg. Returns a range invalidation with num == 0 if it cannot be
+ * represented without wrapping.
  */
 static struct arm_smmu_range_inv arm_smmu_range_inv_init_end(u64 last_tg,
 							     u64 num_tg)
@@ -2530,7 +2546,9 @@ static struct arm_smmu_range_inv arm_smmu_range_inv_init_end(u64 last_tg,
 
 	range_inv.scale = arm_smmu_range_inv_calc_scale(num_tg);
 	range_inv.num = arm_smmu_range_inv_calc_num(num_tg, range_inv.scale);
-	range_inv.start_tg = last_tg - ((range_inv.num << range_inv.scale) - 1);
+	if (check_sub_overflow(last_tg, (range_inv.num << range_inv.scale) - 1,
+			       &range_inv.start_tg))
+		range_inv.num = 0;
 	return range_inv;
 }
 
@@ -2639,9 +2657,109 @@ static unsigned int arm_smmu_compute_range_ttl(u8 leaf_bitmap, u8 table_bitmap,
 	return ttl;
 }
 
+enum arm_smmu_range_inv_mode {
+	ARM_SMMU_RANGE_INV_NORMAL,
+	ARM_SMMU_RANGE_INV_SINGLE,
+	ARM_SMMU_RANGE_INV_CONT_ERRATA,
+};
+
+/* Number of contiguous entries grouped by CONT at an iommupt leaf level. */
+static unsigned int arm_smmu_tlbi_cont_count_lg2(u8 tgsz_lg2,
+						 unsigned int level)
+{
+	if (tgsz_lg2 == 12 && level <= 3)
+		return ilog2(16); /* 64KB, 32MB, 16GB, 8TB */
+	else if (tgsz_lg2 == 14 && level == 1)
+		return ilog2(32); /* 1GB */
+	else if (tgsz_lg2 == 14 && level == 0)
+		return ilog2(128); /* 2M */
+	else if (tgsz_lg2 == 16 && level <= 2)
+		return ilog2(32); /* 2MB, 16GB, 128TB */
+	return 0;
+}
+
 /*
- * Generate up to two range TLBI command payloads covering [start, last]. Sets
- * use_full_inv if the range is too large to represent.
+ * For the ARM_SMMU_OPT_FULL_CONT_RANGE_INV errata any CONT group must be fully
+ * enclosed by a single range invalidation. The algorithm using two range
+ * invalidations in arm_smmu_tlbi_calc_range() does not guarantee this. So if
+ * two range invalidations were produced we may need to extend the trailing
+ * range invalidation or add a third range invalidation to cover a sliced CONT.
+ * Search for the largest CONT that could have been sliced, extend the trailing
+ * range invalidation when that stays inside the gathered range, or queue an
+ * exact third range invalidation.
+ */
+static void arm_smmu_tlbi_cont_errata(struct arm_smmu_tlbi *tlbi,
+				      const struct arm_smmu_range_inv *first,
+				      struct arm_smmu_range_inv *trail,
+				      unsigned int scale_max, u8 ttl, u8 tg_enc)
+{
+	u8 leaf_levels = tlbi->leaf_levels_bitmap;
+	u64 range_start_tg = tlbi->start >> tlbi->tgsz_lg2;
+	u64 range_last_tg = tlbi->last >> tlbi->tgsz_lg2;
+
+	/* Table only invalidation cannot slice a CONT */
+	if (!leaf_levels)
+		return;
+
+	/*
+	 * Iterate through all the leaf levels that were changed, from highest
+	 * to lowest iommupt level. Check if a possible CONT at that level has
+	 * been sliced between the two range invalidations.
+	 */
+	while (leaf_levels) {
+		struct arm_smmu_range_inv cont = { .num = 1 };
+		unsigned int level = fls(leaf_levels) - 1;
+		struct arm_smmu_range_inv new_trail;
+		unsigned int cont_count_lg2;
+		u64 cont_last_tg;
+
+		leaf_levels &= ~BIT(level);
+		cont_count_lg2 =
+			arm_smmu_tlbi_cont_count_lg2(tlbi->tgsz_lg2, level);
+		if (!cont_count_lg2)
+			continue;
+
+		/* A NUM=0 range invalidation with this SCALE covers the entire CONT. */
+		cont.scale = (tlbi->tgsz_lg2 - 3) * level + cont_count_lg2;
+		if (WARN_ON(cont.scale > scale_max)) {
+			tlbi->range.use_full_inv = true;
+			return;
+		}
+
+		/*
+		 * If the CONT is fully covered by the other range
+		 * invalidations, or is outside the gather's range then it has
+		 * not been sliced.
+		 */
+		cont.start_tg =
+			round_down(trail->start_tg - 1, BIT_ULL(cont.scale));
+		cont_last_tg = arm_smmu_range_inv_last_tg(&cont);
+		if (cont.start_tg < range_start_tg ||
+		    cont_last_tg > range_last_tg ||
+		    arm_smmu_range_inv_encloses(first, &cont) ||
+		    arm_smmu_range_inv_encloses(trail, &cont))
+			continue;
+
+		/*
+		 * Extend the trailing range invalidation backwards to cover the
+		 * CONT. Rounding may move its start before the CONT, but it
+		 * must remain inside the gathered range.
+		 */
+		new_trail = arm_smmu_range_inv_init_end(
+			range_last_tg, range_last_tg - cont.start_tg + 1);
+		if (new_trail.num && new_trail.start_tg >= range_start_tg) {
+			*trail = new_trail;
+			return;
+		}
+
+		arm_smmu_tlbi_add_range_cmd(tlbi, &cont, ttl, tg_enc);
+		return;
+	}
+}
+
+/*
+ * Generate up to three range TLBI command payloads covering [start, last].
+ * Sets use_full_inv if the range is too large to represent.
  *
  * Normally the first range invalidation is the largest representable span which
  * does not exceed the requested range. If necessary, the second range
@@ -2652,10 +2770,16 @@ static unsigned int arm_smmu_compute_range_ttl(u8 leaf_bitmap, u8 table_bitmap,
  * For SVA on an invs containing an SMMU with ARM_SMMU_OPT_FULL_CONT_RANGE_INV,
  * produce only a single range invalidation and overinvalidate so any potential
  * CONT is covered by one command.
+ *
+ * For paging domains affected by ARM_SMMU_OPT_FULL_CONT_RANGE_INV, extend the
+ * normal trailing range invalidation to span a possible CONT group sliced at
+ * the seam. If extending it would invalidate outside the requested range, issue
+ * an exact extra range invalidation.
  */
-static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
-				     bool single_range_inv,
-				     unsigned int scale_max)
+static void
+arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
+			 enum arm_smmu_range_inv_mode range_inv_mode,
+			 unsigned int scale_max)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	unsigned int ttl = arm_smmu_compute_range_ttl(
@@ -2683,7 +2807,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 		return;
 	}
 
-	if (single_range_inv) {
+	if (range_inv_mode == ARM_SMMU_RANGE_INV_SINGLE) {
 		/*
 		 * Produce a single invalidation by rounding up and disabling
 		 * the trailer.
@@ -2701,8 +2825,12 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 	}
 	arm_smmu_tlbi_add_range_cmd(tlbi, &first, ttl, tg_enc);
 
-	if (trail.num)
+	if (trail.num) {
+		if (range_inv_mode == ARM_SMMU_RANGE_INV_CONT_ERRATA)
+			arm_smmu_tlbi_cont_errata(tlbi, &first, &trail,
+						  scale_max, ttl, tg_enc);
 		arm_smmu_tlbi_add_range_cmd(tlbi, &trail, ttl, tg_enc);
+	}
 }
 
 /*
@@ -2950,11 +3078,20 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
 	 */
 	if (invs->range_inv_scale_max) {
 		if (!tlbi->range.use_full_inv) {
-			arm_smmu_tlbi_calc_range(
-				tlbi,
-				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
-					invs->has_full_cont_range_inv,
-				invs->range_inv_scale_max);
+			enum arm_smmu_range_inv_mode range_inv_mode =
+				ARM_SMMU_RANGE_INV_NORMAL;
+
+			if (invs->has_full_cont_range_inv) {
+				if (smmu_domain->stage == ARM_SMMU_DOMAIN_SVA)
+					range_inv_mode =
+						ARM_SMMU_RANGE_INV_SINGLE;
+				else
+					range_inv_mode =
+						ARM_SMMU_RANGE_INV_CONT_ERRATA;
+			}
+
+			arm_smmu_tlbi_calc_range(tlbi, range_inv_mode,
+						 invs->range_inv_scale_max);
 		}
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7106bd3a8bd7f6..a59b17679e6716 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -860,7 +860,7 @@ struct arm_smmu_tlbi {
 	struct {
 		bool use_full_inv;
 		u8 num_cmds;
-		struct arm_smmu_cmd cmds[2];
+		struct arm_smmu_cmd cmds[3];
 	} range;
 };
 
-- 
2.43.0

