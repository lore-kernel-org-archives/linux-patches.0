Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010071.outbound.protection.outlook.com [52.101.46.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FEA2264BB;
	Wed, 26 Nov 2025 19:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764184897; cv=fail; b=cQ8vIBzRNTQbfBlk4+G7DotUdlBydYLdfQsVqO7YRzJqP8Wt5rRIl1/2Etd3rCJ71pbh23O2YbQiNz4XqTGniJrzwEWgVCs76DV0eGIEb1Ov/EWLeYHy47/x0+IayaSVHAikvHOxNBpKq4JdTrp2dy7q95jZcWeDecePO9v9weU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764184897; c=relaxed/simple;
	bh=EaSfB2oAWGjPhAhQJOQvvpxl/1DZPiXmymw5SZ+Q94w=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Uirn5FlDU7snC9iFJ3X3plvZftkI1NU7JtyDUedRqYRBhBhD3j6pMfTc3fkmBHjXUa12iW2uoENjrCpaBznsDevfia8/2gEALB/vqJAV4eHCfRqta8UEbUMNWZFflgFKql8+YQ+9NaqwBFMbJSaFd3iEWDxiZro3kRurM4fbUoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GImAbUM5; arc=fail smtp.client-ip=52.101.46.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GImAbUM5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C4xV5s3YK1Si8XYudzV/RgfhuLQbw9GGyOeqmnY0RKySz7wHXM88e+jlJLz+qLYeKXnzcOuk6IaH/JfTdUgi+FJZ2S13Knhut/AT9J2mtx9r+1L1l9Fv4q5c9l1v56koTcshRUv6/6Np5BSdHREtTfWcEWEwMFHoQtBhsZQyTuthgEGbtNf0vAqLpupjzqw/80Gn0GbqURE0neRilo2nHag21OWVC/bDGZRbnn8zpFZTAxtPeyzGbf24UFLgXuW77zb9e1IRLyxBhVzIpYjo28UMMMKyxAfBNg/eIUES3hh4/qbXWhWh+Cems5eyDq4/R/mXbWkpZxPBmvM6uF8H9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7K4sP5hSW94b3t+yzvKqtAId+eL3RCjgFzVMw8xHaY=;
 b=jyKUM2V9xlsWl7FBeHaFZoUp3/dQ4IE57UPeQCzSENXqD/f0Vpu5i7ImKPTB3HWnqpQ4HaIMnYbltaAkHyHexcJP88E621LiDWSXQe2Z9lqksDqkAtlfD9Y+lM8FYwUBUfkigHVOeSC/fURVjzhhtZZ+hlsuzqOwm5YgibUQihFyY0M2yJ8D0XcOdVuLWp/DjmCHW1wKAE0aOd0NRfvVPY+DHqLBye330RPHkEUDn9w6EAAZA42TwaUy6fPmSmsJKUlscyjH/YCCwBfWbbCkk7QxzrTFSzJ/OKK/VmqVxWE9MAy6QIiQHnGWAibRZfT+FzXNEoxsEQgVYiSKt58rlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7K4sP5hSW94b3t+yzvKqtAId+eL3RCjgFzVMw8xHaY=;
 b=GImAbUM5NTFdEI6PL9KnuZg4lzhmexZWh8BREPLQBeWs46601mM2d2DmiLxttXgBUwlESA6fa1HFalNII3bKLt7kKM02ha53kOwrGh8DhpkCxw0O3ZvAhJUDTm77Vq3e5x1OWkereaygmqUlUifuoJalwo8hVF1kkFwdMeh+hHjzHqUVKYN9JLo9f7Max2JCQAHDmIZsBXi4n/OR1TXbOpqV+1KqsZCNy8PTfhJAiTfgRY5cMZPWi3hbwmrIpvdPEe7Qwy3WRfim9I85TnAVsbV2RAEj+DTR2ze2q9hV+cOnvK582X5uAnovPbtxSvSGtXc2dER3xEzrY88RoOPMJQ==
Received: from LV2PR12MB5967.namprd12.prod.outlook.com (2603:10b6:408:170::14)
 by MW4PR12MB7334.namprd12.prod.outlook.com (2603:10b6:303:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 19:21:30 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by LV2PR12MB5967.namprd12.prod.outlook.com (2603:10b6:408:170::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 19:21:28 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Wed, 26 Nov 2025
 19:21:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH] iommupt: Avoid a compiler bug with sw_bit
Date: Wed, 26 Nov 2025 15:21:27 -0400
Message-ID: <0-v1-2e3b97d2d9b3+13c-iommupt_swbit_bugon_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0255.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::20) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	MN2PR12MB3613:EE_|LV2PR12MB5967:EE_|MW4PR12MB7334:EE_
X-MS-Office365-Filtering-Correlation-Id: bdec025a-fb5a-4adc-aa37-08de2d20ff88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CfNxJLUcO2ASQ7fINPELh7M1w7FzQ8BzoFaMUH3NhapOtp7JyhiBV6qjIkV+?=
 =?us-ascii?Q?9GM9dbXi9wy6KV4h/Y0ug1PwkWz4YqzqUYish7+AVK0oxtBE/Y2dQwbkzUAl?=
 =?us-ascii?Q?ilCr1aRB92SbPRtpDSrzSKNrwaOQccPAaBuXtBJWhy/dvwWDKhwQ0K1HTAJA?=
 =?us-ascii?Q?jw1C7aXpU8m1T/mEKn4kUg/vUPg06QSQU8CCEBSDqVix/1qqBlxXlqkKVaXG?=
 =?us-ascii?Q?7j2WwjsKwn0fvGbtntazdwwFlxUDWBZBgtRnhls+2r29y5CDdaWHXGlmwJuK?=
 =?us-ascii?Q?K4CrJx+kjnNUxTS9qRT9yW8LlFmhWb/QyVR9Vx8pm01tszxjs55NrV+hzQ6T?=
 =?us-ascii?Q?X9tgZo7nhh0bAXNqxyDlZbCHw4Xo7wUNOVQlX+/ESi4d7zJM3IWO90LXay1i?=
 =?us-ascii?Q?7/qBjqf6p/kwj48S4T/o6NmoEEORyx1eC5p62POv45seqPgP2yAGsd49tcCz?=
 =?us-ascii?Q?7WaqU7rOcfWT7iTm3mn/OeXnwqw451kLIZnQdXTl0huTvbVON+w7JL4CNcv9?=
 =?us-ascii?Q?GQj69A6P/f794lZacpF5Km0Yz7s0C32oSnzXAGv3WJ8kmsDbTPc5/GMuu8yG?=
 =?us-ascii?Q?srJY7iPO3gzfhzocI6f6KzQ6cIofVsnCrLBSWevoM766GaCEH0MxzCVY2ryI?=
 =?us-ascii?Q?HJ7c2GBe6tdvdoqly1qp8tac17/pO1ClJ8jyftqvfZjzPRGHfcaeO2R4Iia1?=
 =?us-ascii?Q?oMXqvORaTJrwwrdPG7sEAuqgp8Bs5ls6PD1GGmxWY1b00lueH8a59Xxw+BJ1?=
 =?us-ascii?Q?tEbuJULxLlfHyFQxUqVnDiH7GUvLlWfD8BQH9PHoDSIqHKMfcUwxKcNdlnk8?=
 =?us-ascii?Q?ZxiaiOnRAhCcy/cmxRoJd67O0/5A6omKfRKmtRS9mMQSELktJunaKz65onJg?=
 =?us-ascii?Q?g54zA1RdjXw6hF4o233dpqFCsMutS7Ox8aDEBDnKhBUeO1ZfZIhRsT9s7LuM?=
 =?us-ascii?Q?TFE3XzT3yko7HLNJWqVZvGQ+8ltmuRX9DKlTXoAfiADsMOZIZb9/vyc5RmHd?=
 =?us-ascii?Q?rNVw9PvFlahuckzwcKbdYkptJT0akFkprJxDXxNcl6ZA3CnHsjtRfr0W1Ns4?=
 =?us-ascii?Q?fkjTn4ymJTgPUHWO75cA8D9xrSsK7KPiIZSK4wRDD/VBxpkGPsInTR6LpggW?=
 =?us-ascii?Q?UeH8sEMA5mPf09pHuXi24Xt6cAKdOBPBpP/eWnn2nMiNM6FMSBJJ+6pLP+hR?=
 =?us-ascii?Q?o4iJxjRZvIVXb8BNglWqnVNj4g/VkpctcWLxo4LkkVhmVdisDKZZiYCqcuWV?=
 =?us-ascii?Q?P7udc2RymoimedesDqdoCZ0HCMjmEpy8fM9GzDv/ICIysHSeayWGK7NnbDh/?=
 =?us-ascii?Q?bhP8Xec67zNHD8MESyysbpTw8GZG2tIpzL+lSJeX/2KYDdHCki13wzsXwiDb?=
 =?us-ascii?Q?FjnfSL6OymIp5YqUadWqjwmFw5saOZYTIKGKc0jQP9WAlsAP8gIH+43L7j83?=
 =?us-ascii?Q?z8J7iUkTnhWT8qUMutqN4jx6JQBAst4D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5967.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bozFEQMGaQrctn8xl58P3qkQ/HTre+QudwWQpIgIeSRhM0qBKdP+EJC82lYn?=
 =?us-ascii?Q?lHdsRghfLgDygSlcNgYPkskh9A3KhRm/SNgNc1X/C9Ra6MgnczvXa8gkol2M?=
 =?us-ascii?Q?QYGDFZj0l6rTJYOypw3soi9//N5t+uzzngXmjnp65Utp3qKQKKnohPAJQBSQ?=
 =?us-ascii?Q?EzI91IpqJo/pgyOQiw4odUh09Rs3TIEZlCSTqs0LcICnqBST8UJ0CPsSM6DY?=
 =?us-ascii?Q?qqcDOFMJc/2xurZfn6Q3onzisuQcBzDq4HXjfQQEvorNzfyoOrpD6DN1LMqF?=
 =?us-ascii?Q?XvJGKt6XjdKIYWZrxa4LR71S6zuh53LE88bTehQHRpFuis6JPRioZhLOqB0O?=
 =?us-ascii?Q?2e+UETNmHRhKcVAVuaHiwNammD0k/Zx4qWKe4qCM8F67spM07VdUmHgDL4gd?=
 =?us-ascii?Q?VeLGybXVsRWFMhV3pQxBA8kVGLN1caNjXMNE83AOiSf12v5qHQ6B1Rw2ew4B?=
 =?us-ascii?Q?rmCqbcVF+Oqhm9WPCdhRCoKbreozgkHjB/u4S1sw2pIGGhkIkYEy6ZeMVvQg?=
 =?us-ascii?Q?8TR6vzDb8EmazGJwtF5+kru3X5d5vXRcN87ZzNGab54HS++MAP2Voal5kdHC?=
 =?us-ascii?Q?QUGBMrw+AWCSHFNbF3iB3fz3X14aCGcXwtNypHaBA+sH94D0ouEB2cjIYVYK?=
 =?us-ascii?Q?z8GKkEZao7UvNBDpIg59hLvUcAvPmZW58a79O1JK6wfRQzs4UwM7NQZpP9pt?=
 =?us-ascii?Q?6yBe5+Z9FQRPsYOPn+LyXs73G/Py8Gt6JCZrzLPORXheJ+ZiHHA+RGd9TkZC?=
 =?us-ascii?Q?QFBOIaTbX/qIKKHp5MupfUYJ6esoBg8nwgX96eBxctS3irK/tQ3gEynVOOI3?=
 =?us-ascii?Q?RYS3IUYATsRd8iuSAZNG/piOC/raBL7pHh5DVMIz9SGD6clBMX2Sv0ma3E2R?=
 =?us-ascii?Q?FiS7iPz8yDwzJq74Rffu00tcme7k5Fc3KW8PlYJ76UaUgSvB9UcSoZ6lOBc5?=
 =?us-ascii?Q?VTOmxOefrF5KoT09H3MvztnrdFTMoD7PxJUwGWs0J0bZVFRGVbfvT9sJe+kh?=
 =?us-ascii?Q?W4MtHjaS4myPHWJxr9fIcCmUaNrAcCCinDSDiitg3BPVnhwci6n0CzuiGV8y?=
 =?us-ascii?Q?n8KrYqXZkD9pKyIe6R1aj43fvixB3BW09GbdtsNLrav5NmeBVwAQ3Rp/cuKw?=
 =?us-ascii?Q?SZ7o6i4Hs55tV0EvLp9ywseSP5Uuy2N0RhpxPuczRoFTI+JL0GJ1D7rhe44a?=
 =?us-ascii?Q?MowvBsXd12+FY/f4mkOomkzRPr/68s6dITCEpggYTpq72jU4nlBRHISoPL4X?=
 =?us-ascii?Q?UO/2ay+OP93tN2hQyseg0HlrJaZjNibKns4Q/PkidZlYgrWYQ302XQBeLSKo?=
 =?us-ascii?Q?VRorIBPwRET930iH8RYeSzLFu2GLvIsUW44eoycSHDz8DZRJpwmp5qbflbMk?=
 =?us-ascii?Q?DgpM8LRBa+pThXS0M/ATyoaEna/Y+OPsTFJ4z4oREK2CCmPY9YrtlyD2/czB?=
 =?us-ascii?Q?ySgSmDyQZamc2pfE1K30oFneAh8LDJYoEtjH/2gkDuZvGyAGBECWM/LSbMVA?=
 =?us-ascii?Q?2ZZsw66d9Eae9SK1+TZVWEFWTQP+EEQ2K4EFIPY4IHpB2NWiaH2UU0VBXqnx?=
 =?us-ascii?Q?gto5y2fQaomeyNdgTjM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdec025a-fb5a-4adc-aa37-08de2d20ff88
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 19:21:28.4111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ArObj2rsN1gHCA5zZxcf0E1FTBU6UInIL5KCWOVPeklfgDeHzp3xQ1B7QdZuZM0f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7334

gcc 13, in some cases, gets confused if the __builtin_constant_p() is
inside the switch. It thinks that bitnr can have the value max+1 and
fails. Lift the check outside the switch to avoid it.

Fixes: ef7bfe5bbffd ("iommupt/x86: Support SW bits and permit PT_FEAT_DMA_INCOHERENT")
Fixes: 5448c1558f60 ("iommupt: Add the Intel VT-d second stage page table format")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511242012.I7g504Ab-lkp@intel.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/vtdss.h  | 8 ++++----
 drivers/iommu/generic_pt/fmt/x86_64.h | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

Seems to need a specific randconfig to fail, my normal ones don't, nor has 0
day found this on its randconfigs till now.

diff --git a/drivers/iommu/generic_pt/fmt/vtdss.h b/drivers/iommu/generic_pt/fmt/vtdss.h
index d9774848eb6f7f..50ffed9d0e508f 100644
--- a/drivers/iommu/generic_pt/fmt/vtdss.h
+++ b/drivers/iommu/generic_pt/fmt/vtdss.h
@@ -174,6 +174,9 @@ static inline unsigned int vtdss_pt_max_sw_bit(struct pt_common *common)
 
 static inline u64 vtdss_pt_sw_bit(unsigned int bitnr)
 {
+	if (__builtin_constant_p(bitnr) && bitnr > 10)
+		BUILD_BUG();
+
 	/* Bits marked Ignored in the specification */
 	switch (bitnr) {
 	case 0:
@@ -184,10 +187,7 @@ static inline u64 vtdss_pt_sw_bit(unsigned int bitnr)
 		return BIT_ULL(63);
 	/* Some bits in 9-3 are available in some entries */
 	default:
-		if (__builtin_constant_p(bitnr))
-			BUILD_BUG();
-		else
-			PT_WARN_ON(true);
+		PT_WARN_ON(true);
 		return 0;
 	}
 }
diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
index a86353f1481e5c..507abf2c934ccb 100644
--- a/drivers/iommu/generic_pt/fmt/x86_64.h
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -175,6 +175,9 @@ static inline unsigned int x86_64_pt_max_sw_bit(struct pt_common *common)
 
 static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
 {
+	if (__builtin_constant_p(bitnr) && bitnr > 12)
+		BUILD_BUG();
+
 	/* Bits marked Ignored/AVL in the specification */
 	switch (bitnr) {
 	case 0:
@@ -185,10 +188,7 @@ static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
 		return BIT_ULL((bitnr - 2) + 52);
 	/* Some bits in 8,6,4,3 are available in some entries */
 	default:
-		if (__builtin_constant_p(bitnr))
-			BUILD_BUG();
-		else
-			PT_WARN_ON(true);
+		PT_WARN_ON(true);
 		return 0;
 	}
 }

base-commit: 93d0836a0e54f678a3814cf07fa1339fe6cce4d7
-- 
2.43.0

