Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166AA36BCFB;
	Fri,  3 Apr 2026 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775219217; cv=fail; b=a5gJkF7RdghKVJPZn9HJ380zWuzzJxZYUEW4n5pm5LOoMoSopXbCl+qNwujcxOA9Mf4hKA00oSwvHwFWgFo8Qqt3B7UCxp/2yRz77XCpGlT17NvI3jiJpeOL7jj2aqw1pJdEAZxuRjM6PZeWwk5NLagv4sjGGuvh0huDdgksCbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775219217; c=relaxed/simple;
	bh=YPcH9HuEjPenygNUNZLUO+cf/K2FkEu3KNvMyP+dS9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gLv9B+U5etI7nURjYSYMBbcfUzqTCIkm6/xjUpT0mToW9Z2zOAUHg35k08Ba9Sg7C+s4SwjeEHAFVPGNQKosS75Mm1cAdZOi3HDf7tVk5TOaC+FNfk/Rolb+UsUz6eKr5Xs0OJGIjW1pRpq3Uw9HCK7gTk91O93QY+DRycLfnNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GQ7KItuW; arc=fail smtp.client-ip=52.101.193.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GQ7KItuW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sNdM548f9/ztF2V0y5WAllbBVvG8Y4eKfgOwOBF72Zx6b+XWaQwmfU7nnm1+YkmnMB04am58l68kzLQ3roJqJVTxT6qHWJ5fVjrDIigfyC0zlaSB7ERv/6ZOofcMCyCGlBXi1e/ChCn+kCvCb7b1T9jyX3Gt0XXxtfMhL8gl4vVO/LyeYBdITqqgebRPvbYRv9gnqqRau4BstTpzK5LaiV8ofXEYYpCqWbtu8CWOn76ECgP50uw/tCLbQW3LcD5zSX77IriLXXs8r2cpu45CMFFOo+M5i4i3uy8TW+mX+TDh/lX37k3ZVV1p9HlaxfLJnR80Q0JKWc0jMopatPLArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Si7Bv2dS14BRixAFHTHReTvliNVW8OMH1+jzRfSX7pg=;
 b=X/P5Pu/+BvW5WIhGCMqp7/grQifkWFet2341CtKqULBHFXRaAIUzKfO6aipUejQKuEBBjDJ156OkfobaBWB3nNl0528xLC4fpqovSJNchyLfmE3/MweoaVc27JJsGi2YDlHS0DrbubhJO8hRWhmzoiAlhaKeclp84IzLfetqf/Crdw8PbCIv6DCI5s/7Pqt1OE5wL93RVDpGAIeFOLP3o9SPQfMus43NAPLRWf1jkjSqP1U56HyEbPuQqmNVESrn/eew3nMRg1pIMw87r9Dvi8PGhWsa65d/cWweDx7YP3o5Yip42EBewTewjP9KDP81O+/6GPsAO73e7R/Rk0WoUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Si7Bv2dS14BRixAFHTHReTvliNVW8OMH1+jzRfSX7pg=;
 b=GQ7KItuWM43EHlT2eU+bw15MbSgyShco01IH7voDUO87L5R0FUzEIjdeEuSVhg6E4VLU7E9XIXxYQXkqJBfnjBXWVSqKR64IaL/Jgex80TA8bZLfs+7RsN+B8y6pO3dzbPvNRSwLqCpRfNg1k9Y3ip+NOujuecDQdYVlIeOBkSbcFX8prPmfX592x+XsMbrNWMJ/Qm1jXS2wuUVTmEGDDSvFVpDWzGntKgxKqdTbh964CIXg6BsSNLEbcdGUsYNI34/Y3fnYJtIIObcWV/lOfhGvLWdtJ0GjvKVNuB7GUJdPzdGPPsatuXRu/cWBPWbIs6Vr5kVCPbwzGxOy//oXqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7278.namprd12.prod.outlook.com (2603:10b6:510:222::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Fri, 3 Apr
 2026 12:26:47 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9769.017; Fri, 3 Apr 2026
 12:26:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v2 1/5] iommu/amd: Simplify build_inv_address()
Date: Fri,  3 Apr 2026 09:26:40 -0300
Message-ID: <1-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:208:32a::22) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7278:EE_
X-MS-Office365-Filtering-Correlation-Id: c07a15f2-85c1-4463-8385-08de917c451e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	frvfkf6Enhu/LKnEyxEde+PZtvN9o3Rl6+L9q48hklgx9FcF6jtnZ5h9XZTSZSqyays+W1B5p7ejvPUwmDFDhssfEKbjgmvJAuJmtRZpoHXiYLJZ/fuMUAYBWAuHg/v3doohNWYSYmIKGLlGQUwleSfQ8CW4DJA6WiWg5b1CEU36ecG9Rmkr6bOF7iTDr7TfqxZ6eIM6cl634WN2+PZk7u8ewPZhkxy7jn+6wnOVViAN6ZlnD0jd2IQ8Zw2zNYtgSVmR6z9kt6g3q/zmr3cGmcjHrzs/+WGVAa7vnMAEBSOGxheNg8tKfOujA1jb94nu0N+UeeZc9aSNFI8BxtGDwfE5jPgiMse7LgG+BnM4jNXXmilS06DPTUkitmvLZYDV16o5W9wDApco+jvN5XXlxJ3WNSUDNhe94mpoNJ1YpqyqNiVBs+uFAU8ZvRYZ3L2vS0Kx3xGghsyNXW7Q99wUm/pvrjkPjqv0uzQbjPLiVTVjTQZOOv92qio1CR1OkhTG8kRnh+jNhxJsYaWzyJmDiaetH9JtVGrSopFJiFb6CPQ+mqWZrLJaiCcqOWe5o38dZ+BasuxXEQFVZN5UfnRYj8Z1dYMWJHvf89Ia7lWO86wvOXj0aezVIsOEnfoi8xrNX6na+iJl2HIwkvkBpy1plp+J6AayYAuDKl+NIk2e8bRDF64xIRWPM9f2Qk/QgtqTp5z5vLoglf5jrhFFow/yRz4p2Q2bE9B3JxDR4yXW3YUZRc5SlFOl4lOvGcUvbJ2Mfxd/SQDSMfWh/I8PuFtK/9V8kLgffO1Iux1+OMx4rOo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9sccfx+JfdKowh80WCV71s9rs3/swx9A7yNwdS8FdsoUMcxtqCZwr2WQk3E5?=
 =?us-ascii?Q?4UPBqKu5tZR/D+OHYjh3PfDDm/Do1J710ePJvbN+UDr86ZU1tS0gEaa3oiHy?=
 =?us-ascii?Q?vUIS5gbqj25MEdWiR6cCz40xboFuvCvK8/uvqtrZfzYGiGS58gNcUFKgYcZD?=
 =?us-ascii?Q?9FQvOUzob2S+MNAJL+yaQ0Ksc5ThLcdkTXEfkGo1SNq5Ju4NogxQMjqj6zMw?=
 =?us-ascii?Q?6nxWOhKFur5zz2DrTLFiDeP3Tht1kj8E50YEDsuxSJpgyoqaguhpWTWtkspH?=
 =?us-ascii?Q?oiILALtqUfUcdbPvTEzIFwyNMVCvrDv5VQ5xIB649e/DvrCyIpynvIgoS36o?=
 =?us-ascii?Q?Y+qAJQ0EZPnfqrtErt27itSYdaSk09nZbOKnY+R9mDyiUSQz/w4dsb/YsZI8?=
 =?us-ascii?Q?Hrrt/mVwJDc/DQxnw6oKDUXbOXSCfT6vvDoFzQ84+/sO1/KbiLmLzgKjDq6C?=
 =?us-ascii?Q?/cp7+395vlr0z2Wwm4gACR8GURoXTPGargygR6ZL63o0mDyVQVwV+kDAm9/H?=
 =?us-ascii?Q?1THN/UErmMTH/CGaLJ3i7w1UywzuLvuMlcJxmE5k7AJkf3/mjEPn/NGwmDo3?=
 =?us-ascii?Q?J/JQJnfaOuOLjzfg+5Kk7L3PTStJ7D1nSbc41vv2ldwEVVMNVi5N7IbxSWUp?=
 =?us-ascii?Q?XpxmPurVWj6bP7zG7IGMd+EfATSParI3nSXmOyIp7r3MPX8W4xL6J4o/Xs4o?=
 =?us-ascii?Q?MgBUFRrs7zQCiK0F/cqk6Vsd4+ES9sp1DvRaLKQTaIWmmngTjJAYudGC6PZp?=
 =?us-ascii?Q?BdprthLLK+SSrN51S7DlJBvGpc2QEgZ6ruQ8Xhz0VXd8tzf1FLkspHToskdK?=
 =?us-ascii?Q?9JbEb2wOYuEqcghdOPIAgHjiNesofPpSxkl7KmRkPjbf3C6jrDJ4lLD6XLRt?=
 =?us-ascii?Q?Y5FSIdNrnjmzm9J0pJGaDPvWrS81Xk1+aLqgfZkVMHuu+V/Ku0Z8UWP1vAyr?=
 =?us-ascii?Q?qVSdWwbIPAcQB76i8NVjMBRsyh6pOwd/lv+5dyqFI35txTj2lQyfOyTG3OJG?=
 =?us-ascii?Q?6wOP4aMnnS4odsbe/zOncNbsloW9WgMzxu80D7e0bw3JtFJ3fi0qSUukmlan?=
 =?us-ascii?Q?mxULQPhXDPh8ZIxhsz0Dy9WjfTbeIL5kmFzsN4iHRjwtzrIb/uyHLP+wBnvS?=
 =?us-ascii?Q?o15P0M9JialH9NYC8Bk5Xu2HtQ5mbIyWOW8E6qVV6JtN3RVjClxS6p0vqdN5?=
 =?us-ascii?Q?SXHJ12C902GigdVMF/4+BshGahIhxug1PsP7NSkFuR2q+BiYxX+GRniPiPuX?=
 =?us-ascii?Q?i03paFNBuoPzPEz1TUhfEKYexHjdS9Ofd8QF8TZI/sPKNqoHqtvvGNzIv1mq?=
 =?us-ascii?Q?XIULLYMaN/77ZvHmdMltjm0rKmm/+5FcGQdHtzijhhOICoW+sWnYCwfkuy3j?=
 =?us-ascii?Q?fisP/cGFuULmDr3JxnYrU8Z34opdjY1KplkOmj9l3z8GdXvlPSJIZlwiiFNC?=
 =?us-ascii?Q?/LMaVlOwQ5ejCK05GtDjdf8DzXqvxxl+tHpgvGQ2/VuwG7JOf2qMFCYKucjS?=
 =?us-ascii?Q?iFjjXhGct+OITB71opXSyABKCATeOt3g/yJqUrkDAP+tmcm7jKa6a01DOeX9?=
 =?us-ascii?Q?Oy/iFh+KzQ699rik+MIWdLbbvgdiGBh9Fkq6lRBS9G36ACoFzqWUn2Rw5CcA?=
 =?us-ascii?Q?93WcC/J28a58OFx3ICBut/ApYfr8EtopasfaF2GMDq3B56qt7JEhtOhL3m1V?=
 =?us-ascii?Q?B8lHViknxScpEvHi8yMLfde1VrokJ+gvibx5dQzArkL9Yh/g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07a15f2-85c1-4463-8385-08de917c451e
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 12:26:45.9300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYY2hZ/xDZFbtQCBIW/dlfIew5/zvXBq6ekVmCcvIiXi58jFxKh5Y3SNx0vSEMSR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7278

This function is doing more work than it needs to:

 - iommu_num_pages() is pointless, the fls() is going to compute the
   required page size already.

 - It is easier to understand as sz_lg2, which is 12 if size is 4K,
   than msb_diff which is 11 if size is 4K.

 - Simplify the control flow to early exit on the out of range cases.

 - Use the usual last instead of end to signify an inclusive last
   address.

 - Use GENMASK to compute the 1's mask.

 - Use GENMASK to compute the address mask for the command layout,
   not PAGE_MASK.

 - Directly reference the spec language that defines the 52 bit
   limit.

No functional change intended.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 50 +++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 01171361f9bc22..e4a88879ca35d2 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1268,39 +1268,37 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
  */
 static inline u64 build_inv_address(u64 address, size_t size)
 {
-	u64 pages, end, msb_diff;
+	u64 last = address + size - 1;
+	unsigned int sz_lg2;
 
-	pages = iommu_num_pages(address, size, PAGE_SIZE);
-
-	if (pages == 1)
-		return address & PAGE_MASK;
-
-	end = address + size - 1;
+	address &= GENMASK_U64(63, 12);
+	sz_lg2 = fls64(address ^ last);
+	if (sz_lg2 <= 12)
+		return address;
 
 	/*
-	 * msb_diff would hold the index of the most significant bit that
-	 * flipped between the start and end.
+	 * Encode sz_lg2 according to Table 14: Example Page Size Encodings
+	 *
+	 * See "Note *":
+	 *   Address bits 51:32 can be used to encode page sizes greater
+	 *   that 4 Gbytes.
+	 * Which we take to mean that the highest page size has bit
+	 *  [51]=0, [50:12]=1
+	 * and that coding happens when sz_lg2 is 52. Fall back to full
+	 * invalidation if the size is too big.
+	 *
 	 */
-	msb_diff = fls64(end ^ address) - 1;
+	if (unlikely(sz_lg2 > 52))
+		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
+		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
 
 	/*
-	 * Bits 63:52 are sign extended. If for some reason bit 51 is different
-	 * between the start and the end, invalidate everything.
+	 * The sz_lg2 calculation with fls() ensures that:
+	 *   address & BIT(sz_lg2 - 1) == 0
+	 * Therefore only the 1's need to be added. 8KB requires no 1's
 	 */
-	if (unlikely(msb_diff > 51)) {
-		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
-	} else {
-		/*
-		 * The msb-bit must be clear on the address. Just set all the
-		 * lower bits.
-		 */
-		address |= (1ull << msb_diff) - 1;
-	}
-
-	/* Clear bits 11:0 */
-	address &= PAGE_MASK;
-
-	/* Set the size bit - we flush more than one 4kb page */
+	if (sz_lg2 > 13)
+		address |= GENMASK_U64(sz_lg2 - 2, 12);
 	return address | CMD_INV_IOMMU_PAGES_SIZE_MASK;
 }
 
-- 
2.43.0

