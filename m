Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082663F54B7;
	Fri,  8 May 2026 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778252006; cv=fail; b=S2q6e5PTQG+3oqy4hlgYiQdv3IAbzRKWMA/jcFPMJ4an17QodLyB9nTof5fTQGmwgS6dhgPHKQbpri3yHL3VA1ybJlOONuErxtctUS77sP3p3rB2W7aFajShKYGgoqC6MBJhv71q2zQhgY9qFI4ZqDiIt0UE8u/I0q0eJQZlcZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778252006; c=relaxed/simple;
	bh=W5psgq5Vc+PMl6cYD3W0hyqe2/eoI4U2YUpZLaZnBTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j9WJVCnJCSlM7BVhN4R238bTwSt/fnKX5NJ/rTdIL/6IADhi+bV8Alsxf5+tj909bA8o4n+bNg9JSyrPbUbiwt4+q/aNP7NmUDXTJQXVHwxsYDZnB62H9WjTck9KpTMHJSaFfByw3gdvDO3/jIZx0lzlCFXgLnvI5Bm8SzAq4OE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PtAGWmWQ; arc=fail smtp.client-ip=52.101.48.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PtAGWmWQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GOwRHUW3jMRCeM0yh79zwCYKCUl/P/IQZzxp07rmLB2f8LnaLMNoThf1dyaYw2UC5+HE3rFLz0sSIKkDXJcUgbXs+tyzAPF7CSRT9Rekms/KW4pRyA7+i/zLP+4N3JiURc+H8V/yrlMBVzkafECPSJIkjzksjJrdnw/nEDAZACmTZcjbcU3bW3irIiJvLvVEudwtbE2/ghodGFbE7C7ZAHPtVNgX0yGH6rIz6UDsJozBbKy478CEaNOl35obYcKxxREW9znH2zaqz23bCdJp2NI8ajuHKbfua148WecByZC7dpuKXQyTNHiBqFelifVYz2R/EubF605BH0AtBoYksg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3mGAKwkMhNAXIjBNHk5Wxkc7CvwEzqhM24gJnuGj2vM=;
 b=DZtQIYvRqhaXTAtdjr75Xjli9+M5Qp9oUZKc6FuhauTSapmmtmF+kK73Atz3r4jlBerE6SRnNVMwdz8Mqeuu1Ktb6YKHQdc5WcGtUT3SsZK3u4mANMP1CegrGI6LrGsSj6Y2FQfXEWws2CPblhsjm3Jt8TeVQwujqVK8N/EvQlMFhzclZB10obXIVhe3/iwY7l8wPH3J6pZySeeLq7TpfJDwc/9XOs4AE1CJToJJ/phts1uVGqeErPI2Qlqt/Auua0hRa1saAaIjzRa/+AZEiAyBwgYUFCuqEUHh7iLSmSWN5HubQF9zuaEHKbGgSCU+gMXzzzx1YGqRu3Pc4uqo0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mGAKwkMhNAXIjBNHk5Wxkc7CvwEzqhM24gJnuGj2vM=;
 b=PtAGWmWQU0Cq9yGCV5lagJbm64GHCtykWWq+1tOPsGXq6E9HY/kGKPHSpurra+G8UfsAgbWTmbviaOgTa28Hr7VxGkeBf7cUS7peD/Mxi/FQEukegVTfP48d9e9xPpugsAFEmgtpcrx+VUUBywk+MzH9gUHv1v+W5u4ESc1CqBHOEZ6g+P7ItL4hs2mZus9n9t85ZCemRWaNaLRj+rlFztDv0FWp+gAZG7Qr9Xs/190HMyrOaKXcvsYc7evGNguwKx2z7X/LJ6fsypw+1kD9asfnGMXg5fvq/RdTynX4RmuaGSn3PXq53lBRS9Uc4WKSEk3jZpemGnVE1ZT2BFc8zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6224.namprd12.prod.outlook.com (2603:10b6:208:3c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 14:53:10 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 14:53:10 +0000
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
Cc: Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 1/8] iommu: Split the kdoc comment for struct iommu_iotlb_gather
Date: Fri,  8 May 2026 11:53:00 -0300
Message-ID: <1-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0109.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: 115a67b1-65a5-426f-2b66-08dead118555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	byj16/3RbFfpgDUQJlO/csJAGSstgqD/v0+BrRbosB3eVcezyeIsz13Fo/t3Yj8HG7QhqTQtZZKSpRIBMKHl8KakQXv69fvihKj7Y6vU4zYThWMTBp30VD/DYm+spMQTNH5n1u1JKnJmEMRC+MWWQibGpGRWugMCEgx9QR4Vog0ZUAEuijDMSlZtzUE2PEIaHVFN6bWeai0zTdig30DDbLtCm5g+cISJs0uXb7lLrKgKXeCNTJH6CdV8xv2jG//OLzxVJMsZyvjtgfPf9TiJLJKVtvpGaTf6mY2ssIh3Ir0nYJcpz/WEjpw3W1xEPgATn0xkU8ruEidChk5BeiSmLq1kytx1tTJTWzs9RNRE1PyGFbdOUyUoupf/IRwTsbCP3c5nVJuxwHP6rXuGvvIMOCCXHGNK9ykPKVcI/gdNwtTiFEHAdOWDI1Yh4EfxjKVgW9l5QaitRnurCt96sjU5J6tltie3eatS2WVaBZIBXWcnJkeCpikL4Q8ujM7AbJZr5hPVNNouIT5peTe6V83R8+SH3mOZBnEN1CKOFwtDObhUKowK/bpJogG4ozRdBHfrcAMfDNmtog5pKeCctsaIBUMtL1+Qb7XGGWtkVN0ZefsEtlzD6GaA+YFfRye4w+6Vpf6PE5OPhft2gpTm8y2N+De5csXjXzLis23kASqf3kv2fLh4f2grujV8p1NUXGwGz2O+ADAe59P0/JuhGhof/MvEKQMo7w2RfTPJFaccljT39qjb2VkDc50lxXTrwRLJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B8BRc9rSChCoEX+zW/3MZClxYPkR8+faLIpUuIMW1INOjXtzonZfzdNPrmyA?=
 =?us-ascii?Q?6SG4hB17RPsUy8VLGMhvAvApJahbOwJzLpF8b4FxUregWZbVwQed2vWGCH7+?=
 =?us-ascii?Q?yK+bO+afmVpRwAQyr0ML3cPdOpBXxEF+fWyNHGSjD79UYQeHRN8PFnLEReEf?=
 =?us-ascii?Q?+gkcln555LbSTxJZgzql9zZ8uq77F/loOLvZxghiqrpJQ54czG1Jo8MqkRMX?=
 =?us-ascii?Q?jlRArxJZXFJbigJxXO4jiW7g/Es+zd12axK8htPOIAptmL42jdjkYXMtfv9b?=
 =?us-ascii?Q?sQkWiJAFV9xyosQXRyu+VdF3t32R5N+1kz0Q/tIMO2zwLdwidfXTNeAxZtg3?=
 =?us-ascii?Q?An/krJCtQA0ggkOPQblX6vyQ9jX4UKTm7+X88+wVHkpBadZPz0Iqy88xgv2T?=
 =?us-ascii?Q?Jf0v9jZK48XI/HiVpeaxqwOsGCVzlDsCcEUfRX/BqzpN8hmq02umB8GQQTXB?=
 =?us-ascii?Q?UuWx72OSoXkNj7foG/B2D1ylbswRHSj2OHkzUyOIlJqXG4rzEGCHqrXfIsuO?=
 =?us-ascii?Q?ORbirnJEm25xbki3wgIAdEcrBYV6ilGfe1Nzyg4V6M3pobs6ZfVKLlyzLiLl?=
 =?us-ascii?Q?hUSny0qJ4vhDr+E5Ap+pdHKvSvK3LIZ/4SyZe3VcYbIP9djWYaHjL92stMsc?=
 =?us-ascii?Q?MkerrmLhPea2wa/3lM3rz/JuuYCNmomjxm9dmFsezSQIqj7eVJekS+N2akcz?=
 =?us-ascii?Q?b2Bsz6HSEjtBO94ZAL65fPGcQTk7WKai73mkKKfbHooy19Gi1M7lC0XPh5vl?=
 =?us-ascii?Q?Z/ErvXjemyaOmwguVvAymnlZlMWKv0DAxLK2YUGaa8f4hP4dgntlmYyc8N1X?=
 =?us-ascii?Q?furW10I6J4u2NUVU7VR+o3LUC1N4P0wQ9h7nwqwYVp4++p63IaiZQH1nSKJ1?=
 =?us-ascii?Q?pVE9kxyeKDCKX/nV3gSaPtZW7jDhK/lWrrKJFcMxuUmdH5tiHAxklZYERN8B?=
 =?us-ascii?Q?RbbPaEJL6XkqUcCTwD847ZEBPT+lPKQB5IeuVaWQgmL5/aNM2G3wvip1+adI?=
 =?us-ascii?Q?B+6r9k9QtyfRiOBKOKwKt/L14y+2X79cofYsfhWCgz2eRWuYBeJ2U8mO+X46?=
 =?us-ascii?Q?D0MKEVIo0hFP7ggJix6tchlw7LOrEJUHz45GwU7npQ1T1r6IxHvWQWUkUAwQ?=
 =?us-ascii?Q?VDnvlOt1yAbBaUi2nSObir7uIGeowkhbfrPWmTqY3csni0hAcC/8xz/zQ3VK?=
 =?us-ascii?Q?vZPHAlZBl6kg2lvQAoa7OoGXKkfQDJAelPgRvL80icLpw8oZCT8XZiSQ4QNm?=
 =?us-ascii?Q?3KrMV7YTyNLRxX+YEXOIPWo2wlj3C+6KL2NQkN7+FmrTQQVnzizhiG2i7L13?=
 =?us-ascii?Q?QmRIz/ZLYIHIq+uJul/JeOkfepEOivq+0nr2T0RM/S+z1vgEocbL44KPF5TQ?=
 =?us-ascii?Q?t791ojOFd4zEP13Lflm1jNQt5IyPYVxgiX6MVcc1ITThS8hOatzRxjswZfDX?=
 =?us-ascii?Q?2cIkZXCT7+RKlz9BoP76as5GTTRG2xFSdM+jh71JTJDBpOgmY/uUzALpDC1O?=
 =?us-ascii?Q?41YEpQJpgQC9nyDiwKkMllQgg0C9wodA1+MkBgQMaQyFrw79Wv8Yejx8yybI?=
 =?us-ascii?Q?mMKu6ipFRQyUVYzDfQMxICJteqLnjHbTxcxsRdr1MjEaaK3vtaTsMU5SDDEw?=
 =?us-ascii?Q?YtqV2dtIEFY2QSCGVwJt0kCSEouB3w/YyMg7qNxmEcfBHQp+ToP9ZiaA9r5h?=
 =?us-ascii?Q?eYC11wAPn+C4+BCIEKM9nlR/W+sDR/DthRAf+5swY48kQ5Dq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 115a67b1-65a5-426f-2b66-08dead118555
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 14:53:09.8751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DkFelUS5Z4hvxuf1gJM3hP8biTtHGkmqj53qZ6ztny5nmkHSh4nClylF/ttZ3KFD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6224

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
index e587d4ac4d3310..a9e89911c90f24 100644
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

