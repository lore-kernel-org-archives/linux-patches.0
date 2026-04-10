Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2F63DA5D6;
	Fri, 10 Apr 2026 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775836645; cv=fail; b=I4WReJI/16Tk6tZ9KlJa2IJwwfh9uuH49wJ4GLEgbojb8fiOD79jpWDgfyb/BdXKFtQZpWn37u+yQYksqZfrHw1dtMev4lC+MlcKJvbQC7VqQsf8nOeTiy5fGB3LKxZwa7OEmZ6g3zJIfVJSri8MpiFpYRNvjRzKI5ALTJ6dTHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775836645; c=relaxed/simple;
	bh=HPSvoK6d9BmXFQlvfZYXV9fXTIL9P4hNoKc+bHG5VdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fmPFPLKR76Otzf83TVMSLtwSQdjLQB6UL/kDOpm959mskSsbJOTNR23VWZfopjcCS81Ah886tqKbM1pQUPt7/f3/S65vw6Th+WPyQ42o0kAOw8X0Wli8+wh/7agDD+pojP/JXLw9GbwSHuXm8uyfmbHWrrmtxY8dHGB4U25zCog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H9rpLRio; arc=fail smtp.client-ip=52.101.48.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H9rpLRio"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IDnDNknMR1BOlFuVPNSjBvMEX5qAnpaAqGm//m7pOs9AVmOMzYu3Y00Lo0axuxBAaoF/drWZpY+LNq38UoJmua5X4ldMwKfneJG7XZ3f/tswxCddPpoKtYabb9umX4LqNqXgDHqb3Xna0grK/cORrJ396QPlf94SLXoAAjUqOvAVCj8bWCdpx9E1mZrbTQKBh3bLrepysElsFPzTap7WyOyDBN9Frr74TvwxEMByVuzsv3hczmTLPAGTDAeGNo2KGdBQ62TRSTcTkmCKlRFG+Pn2kK5V24e21bioramEECmqQFCzXltpNgWpBGLAz6BwRrIO+rsHPb2L+74Bncr+sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMsf6lCpQhRPuBYFSdj/r39Ly0AMS/rzyuqjHV5+PL8=;
 b=x3DZn7wavNdHCli4JC/JGGgQ17885xH8jrJ8creBKUFQFCDOx9l9MF6FcgFI41H3+CsT/TnVDG1pjIlWixhE9JEy/+Nx7Le6GAr4zZz6CdCaGYmS5qbZSvD+njzZcwJPqVglSIJtrhYkVT5P8X28V4Jp+piHDZyZCB+DJUpVCz6vg35ajt8G8EOaRcincfnQlliuv+zdvfJi1HkWYlPJD8JZvEn2lAxphGfPi0A9CuJoBiEteGuMTbS4fxVPUIJyUCRk8foOO/77ZKP7SVAB9p7TzMXOTiE6/Ldlq0ZxVYBHf87L4B1obaUX9EpWWGHJJBDsMOWUSmcy+zFnoC57mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMsf6lCpQhRPuBYFSdj/r39Ly0AMS/rzyuqjHV5+PL8=;
 b=H9rpLRioMieXF/LEntPxauK7NZGHoXis0/oqC2/XC4wXLjrjhtkMygFgfG/UKcGrwIATphzpGLmQUemT85QrE2fcDn354n2CTAl6FTZVzIqgn/fqwKN60HY7rCWfvxg7CawSDXgv2U7B9bdmaHSMEFcTBTozg2GfHT7lyisKMXhDicM2JaY4CRLU5+gsj06pewAMi4MR6zKZ/h0w5y3GBcDrw9/PiCUZXGv5Yc87whYxzwdOJXPOVVtRc6ULjIp8D0uEz8OFEcj3bg1Q2Y0NBBUo7aVp2GXDP787l+m1TAXeZYlDZCsd8ZTxxD74NPfzM0eLGz7rnaQDBhjJLt5WyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.33; Fri, 10 Apr
 2026 15:57:16 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9791.032; Fri, 10 Apr 2026
 15:57:16 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH 1/7] iommu: Split the kdoc comment for struct iommu_iotlb_gather
Date: Fri, 10 Apr 2026 12:57:02 -0300
Message-ID: <1-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0105.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ0PR12MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: 043059b6-4c2a-474d-7e7e-08de9719d435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JdRSIOW78jQE7JzgbYCymKyaUbDAwOoCGB+BUVdBIGUwj/pS3n0IX2hEGmr2QzzEkf6GioyGPDk5B28t4FlZ/ZuoZb4kp1TYIt9zUd+/C9JQr2Ipr71ZPaFYQH848CqufVjAQXT+3OJKjCC2UiiYH/i2I5qveCkC08omIMtdOtfACWBQBLpq8HfpmZkbGrtf1V2N+fVIiMC/PZWSu0LUtTjR8Dg2Cqf1FR2K8xYPDSgudJ7ZqdQxMBrk0E7HrzsdcXFi//E2h0bkLH8hQSImaufAb75fdKuR5nJyNoKKBKFYcV+g+aDPlCxVZVqLlgXB481rOpUyiqATRW0LQeJSdlugZqmszujr0lhhJqNfPqpg4NbzCjGk1R/TlRZfNS+bM1xMixUxLQ+lGa/SJVZklCOyPjvzmQnC4/9PyXM1jsLCJI12f7LJ+Yt4JN7O/DRYTwxXlCOPZEGmWPzxnbXLHvwBXzvA/JbmZasnnI+evC8l/x50LmXDFFBhPtVLU3J4Aeb7FWLE6LZ2YbCQQmPk/MMt3+QICYqkO6i/9mTVE0vE25Crr6sGQRzsxQ0M1A0tzu0SUnfVQb1f3oW1zg2PdV2PCwjSwwhzPryfbn3dUpmteZe3GqO++pLV6CKK7nQ23MtYhdswAUyRG9bZs5gipjVwDgsnuPkK8FWBPWvAjUXXY1tRsM3jjRSty/5yox2Ox+sGK/96/fjzyirO+NriAjd3fmSywN9cM7TmlRnuWTk6/AhhR0LjLZq6P2t+FhePgyHXLU7TiqBc2N96uMse+Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WB17MeoJqavL4bmCtuGgeS9C9fTSPGz4v6Z7zl4kGwB+SsWpxWUcJpm50xXg?=
 =?us-ascii?Q?c7H2N9G0OZPmeeSoNHi6RWESVzhtvyHibgfanklSgDGhYMzaAEW+x5UPQ5Us?=
 =?us-ascii?Q?9K8aJXRREwaEd+rqsAhU7OWimnQSKWXn+TEYM/Xc9CoD+f4jqZc7XyrxbSsB?=
 =?us-ascii?Q?YBTavOYpk9MMBuDIsp+Nws+BzgXqBaqnWAiaInj5K8FCZ592Z7ShuDHPARt0?=
 =?us-ascii?Q?mEtZ887wqEZvKwzg6s9YiGrg5DOmF0+nqi2fOYoRd0XkS9pCXhIYEk4dltfj?=
 =?us-ascii?Q?oFvqva8SvivYg0HssZnsPNH196pMQAQ66RmJq1nEGKiMiYAud9YQU5AHzoON?=
 =?us-ascii?Q?UyTlMkzTJN8x2NgI2rEGgWhX18YDidzQME6ZNrSkOR1lX3l+J9v7RWw+AQ2x?=
 =?us-ascii?Q?jMmWaOMOm73V/99q2ZZttE4MJqc/Yrtyxjh13Qe9dROuU+wh4BQPDSMXGVTt?=
 =?us-ascii?Q?Cevsfado9fdRf5x6WbDI/WLPC32MhaaR345a0wbdV9E0wq1RIgCJ8fXuSakj?=
 =?us-ascii?Q?pcKg3HPAu83FC9YVk8RPhqKweELTXfTlzXeGQ2WYD7L9NX+FWBVbw8M5Lzdz?=
 =?us-ascii?Q?LzvCMNZPMSnSsXP/R5ZPZsrQc07MSfOPbxZcWIgsVCtwd1AW8CAK9s9Jmg4e?=
 =?us-ascii?Q?zv2OYqy8kXPHbXa++f+S0TdTfs7aeoYDfy7mOsRALEQZEXZlkVuR7SNcExVv?=
 =?us-ascii?Q?sC+2nu5fhgxHzM7n0gkRY3E0ep8c9hDxXIExm0eltl3b7j9XB1ubKVBoG6NI?=
 =?us-ascii?Q?47QL8QioClwAbPBp41h7089t8nkCpeyoQoxTKj4dkcoSs3LGKIO2x2q/yHZu?=
 =?us-ascii?Q?4Pp06erifyWctyQ3wz4qzgBraS0vfUd2fETWnCKGhMefAFP9AmkCm5l9E+3+?=
 =?us-ascii?Q?R6O1RljoyQmZPWxY5DeQEuZzWlYclcTUNbloi7gr/fanUh14za8rT7GHEJ7L?=
 =?us-ascii?Q?dptdPp0gLNP9+uL15u4pW8q89BKlDt8v3cbELU2PJid21xwlI4C5EcsHSO3J?=
 =?us-ascii?Q?HIbajrQQHiLh7lXiFEUIhBPOaUXEqIW/dtHR9YfRo2jBxiaA2WLl5JUxJkC0?=
 =?us-ascii?Q?KrYzJ9JCGSjUgCzxRWirDw3xZTl0Y7YCavCJXOH6o4+7mwAuiZCrdkFyRPMm?=
 =?us-ascii?Q?CZrFXhC9+gnkjE1ZnpGkmJZWc8PD2ACWJyJlsfPFW2RSI1f1PJYvPufxMYlW?=
 =?us-ascii?Q?U0sYhhyKC3Nzks77k6Qr/AF8FhFem5M1bOJFKC8ReuYJTzyNGlO1Y9Us63Yx?=
 =?us-ascii?Q?x4BZJijrh5h4dgzKruE9kJmyDOZHNmWX8pq3AbtBt7sQvqoWc4obXNH5Du67?=
 =?us-ascii?Q?g2gOZb91g6xqO9QbFfWEh4JXJeV29E2KBnbszyY6mzOWeq8FrQiBGX8lC+Bj?=
 =?us-ascii?Q?QKsn6aCt/WNFP/mhnN9jjNwnXZdFDbtf2iJ98ZCBbFyP4Bof7FCbxWqK6FhC?=
 =?us-ascii?Q?OwXvZtqld/509ZVEm7dCXj0gzBafM24PP9Ip3Yxn4lt2Ja8f7URugeF9zCWZ?=
 =?us-ascii?Q?a0h0vxV8wuSTwaSsggaIkNvTO238jVPNDKnnpravo/Lr3FCKHh/a/il3+q4U?=
 =?us-ascii?Q?F8kdkIyUFJ3aWD1N0BSGUnbs9BlnnAeqBqYlhTIMzBQlQ0mWlvSxk+oYEOo6?=
 =?us-ascii?Q?BoQoH/gJWwTCxj1THUG6kZlHC7wogBtKWIF5HozsfWGF7nY1qF5I7hkYl/hn?=
 =?us-ascii?Q?JEyea4QrOr0SBvjiucypWHxnuTZEcTSCKAzPu+2f87PmvfKK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 043059b6-4c2a-474d-7e7e-08de9719d435
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 15:57:12.5393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KnPqXup0E1R4sCMwPw9S9PE6ErDqP237MhA+HC5bZK4mqY+3g9I3SXeyGrk83tnW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674

Use in-line member documentation and add some small clarifications to
the members. This is preparation to add more members.

- Note that pgsize is only used by arm-smmuv3

- Note that freelist is only used by iommupt

- Reword queued to emphasize the flush-all behavior

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/iommu.h | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d8fcdb61e44c42..47a559616706a1 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -345,12 +345,6 @@ struct iommu_pages_list {
 /**
  * struct iommu_iotlb_gather - Range information for a pending IOTLB flush
  *
- * @start: IOVA representing the start of the range to be flushed
- * @end: IOVA representing the end of the range to be flushed (inclusive)
- * @pgsize: The interval at which to perform the flush
- * @freelist: Removed pages to free after sync
- * @queued: Indicates that the flush will be queued
- *
  * This structure is intended to be updated by multiple calls to the
  * ->unmap() function in struct iommu_ops before eventually being passed
  * into ->iotlb_sync(). Drivers can add pages to @freelist to be freed after
@@ -359,10 +353,24 @@ struct iommu_pages_list {
  * later instead of ->iotlb_sync(), so drivers may optimise accordingly.
  */
 struct iommu_iotlb_gather {
+	/** @start: IOVA representing the start of the range to be flushed */
 	unsigned long		start;
+	/**
+	 * @end: IOVA representing the end of the range to be
+	 *       flushed (inclusive)
+	 */
 	unsigned long		end;
+	/**
+	 * @pgsize: The interval at which to perform the flush, only used
+	 *          by arm-smmu-v3
+	 */
 	size_t			pgsize;
+	/**
+	 * @freelist: Removed pages to free after sync, only used by
+	 *            iommupt
+	 */
 	struct iommu_pages_list	freelist;
+	/** @queued: True if the gather will be completed with a flush all */
 	bool			queued;
 };
 
-- 
2.43.0

