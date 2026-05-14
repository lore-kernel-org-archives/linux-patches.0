Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEEE15FA81;
	Thu, 14 May 2026 00:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717494; cv=fail; b=PpTIrGt9upsaz+KPzdPF7IMAPXhQ0xH+C0A7zN5JEM7bkrKrzE0jm2WCqKAQkJFTSNxemcdmGensFzF8zOmPL5Nf0UXhkM3DwTgkdQ3HAoTfH7SSFUfRhdoEVTpOncIKzJ+7al507ESDmS3mXI+XOtnXTsAo8thp1aOBMaAUfGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717494; c=relaxed/simple;
	bh=hamPuJA2tgPHTjTVdHuNWkv4rrd+MbpdIB8vUtGWyCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VX+e4PdtRvgOQjsJ+tXZBxeJRZR022W0E2MV5w22e+XahnZjLW+yIw4QIqTe638hxBOmCw5J8NXq9Q/Qn054CySxwWC239XfszYlMkJ/HJjfbSI2A21uwF+zTYVciVR0eUpfdKzxlOW85kx1iC882wPgg+Gx7lO005fv01focDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pMpF68Qh; arc=fail smtp.client-ip=40.107.208.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pMpF68Qh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WM0J5NK/I9GctD7bZYtjhMRmiB+Y+E2JVeWqHhsceonAwntnoFbFKMle9fN9K9IgiyI9k8H0EO2N34lgaQLKuYrttNHJJLl9fTbwUSGjuRM6fT7phRaqzb5KCCS7c1oze7gThs5xUlaxm6AZzyqrbfXqFZmGsuVJUrcWWzZFKE0OFAOA/0bbOfhhB5MA8RkVQwjyC5AIS2At5QfuDOOakK2aVpFsQLX9x1kHfmvN7rbs14hCzWr2ww9nP4gpHSpPfM8lBJN40NZszOJhDiu89VQGo/CYfra0WbQdR5bkISwyEKWqGunza0guHfRJsXJ/op8XKBXOXZq+L9k8qMEcQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/BhIiEQzl37IKpm/3yV0gO9nycqO2JBtJPDtaAbHp4=;
 b=o1Zjw8rWk/rmnHYURZNAJ04L/ikFRBQ9v4ehiZbH9AjyOz1C3wYH0DET8u7F54vszdb6HL405CdDrlTW0i9F5wmfBFLAyTRAX5ozxKq28zOSmprn4EUDAY/MXfQr9AoEXNfqQLIfoYAeOx7y4N6CSmCwVbwaQtz4hnZYc7eIuxb/GtoVi6c/xEG6sLvax+QO8SmCPnF/D9J2gsyPvziXIRoDxLTEbA33pOOPrbi9r5g4qcEYscJjUBcbcQO8RvO/M6o65XBnybWh8wIqCBSomTesiiS5R336qskoxiWhckTyBOTw4SZbvAGabYiYe4enaYg+YbPoInJYnUoX/41Keg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/BhIiEQzl37IKpm/3yV0gO9nycqO2JBtJPDtaAbHp4=;
 b=pMpF68QhzOwpMEy3twa96ATrd42Qr4HN94PIRjW6M6gjaA5xNeGQOe4dJOMTbgpoknhqD2+dciybWQCn4Ej5wzOzR2/puzKS/ExFLoRNHPs3OJxXplRFClB1/D82eNsYO33AgHxRCsYVpTp/bT6YsmYYIzoDupoU3Ip4H6Vkn2ale87XTvLNJWD7xD57sTZrgNZhTN4toYeEEPpJ6ihfwkJDZI6QSRP8JXJCsKUfBnJAq8n4Zy/zCdLmCsgcX+Q5mROKyJR8C5qRIQn6ZnqRXFxYX917EiPmhaJ6fyBx/EboNeQMUrwnksgjTdF1lmBqNoaClFfnv032qne6HFCB0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA3PR12MB8764.namprd12.prod.outlook.com (2603:10b6:806:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 00:11:26 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 00:11:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v3 1/5] iommu/amd: Simplify build_inv_address()
Date: Wed, 13 May 2026 21:11:16 -0300
Message-ID: <1-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0096.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA3PR12MB8764:EE_
X-MS-Office365-Filtering-Correlation-Id: ac3f0d6f-cdca-4308-f554-08deb14d544d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|11063799003|22082099003|56012099003|3613699012|18002099003;
X-Microsoft-Antispam-Message-Info:
	YqJuRjvwhg7iJYGKtd5BXNY7uDDZyxpxVk1NcyWbXChTL7VnSwNkkKsXVIFbgFdrjREXf1eVd1WEclXO1w3Ty2/fCecNK3TyQROCE3X+UpHgHLPLfqYnFBUnxm+6yyzvj5Ep7+uitaVr6TwhEyZ0lu1inRlc11X6zafxJ3zQ3Y0SQxyq1sYKL+GKgl9B9KGuGdNCIvJTCTfC8g+ZQC+FBdVWO7wXazb5Ui8CL/91TyI3ga2mldwhw20rADASxzAuHULQrC+KgB0BBSp41uKfhJ4qV5+zJezPQcIjWM7Df6h7YVqPCRrGjOf4m3N/iJ/TM3AYQkrMh1cr9EeAA3UUUgsTqf5t1S3IBbzwjK5TLX4H1BfjepFaglgFfSmh5EMIOiFGh7+YaoVkKzxj0je6mgt8YhsmgNmAuvvBhlbhO6deYgt/xbYqSokaXonUUuIcBA4KChUzu3lCMBsZg6ZlowPNK1tMtFnF3BqbyWZTm+wwWH8GlSI/OEN4fhM1bi6jMGjGwOqToREiItULqEq1lKpnN6KOPjY+H2xnRdgdjQ/rPTHpvx0f4eUhxLi6CTNe7yXa2ySB1E3reQiDJ7FJFRHJ+Y3PCeVFafB/ohTBm8ReYBEnu6UKDflJhR5cLalIRi6QfCeCuDgT/j1+fMxm9E0GMPOALYrcO38gnat/Q3yKIZi8GfeGQTQnQVMa1w+hvVTH1Kd+eNywPvlUrEOg6qxXzcz85XBy/gUJl4OIfg6+qBydjmNsOV+KdKrstsjM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(11063799003)(22082099003)(56012099003)(3613699012)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fQhKAUAHOyhx/1fLvx6KJEUWQcO3uWuHglIz9Z6vzi9dwCS43DhToa6HMSro?=
 =?us-ascii?Q?pTH1MjG2ebMcLXC79wYhjmvuKImUopmLvXSsSwl7/SsjUpqoPNwr2yGysX62?=
 =?us-ascii?Q?RJq9kXTJkh7wFQpnEjNUgjtdfPh/V7EO/341cZxyeiwBObcaCg5Nwv+9cmZa?=
 =?us-ascii?Q?5K4+kBvAT3BHHZ7STUtCGFSYkvKbl27pQ2Tuj68Q5rb8D6pybVxA6ZOH+g2S?=
 =?us-ascii?Q?43hETgrywOJszQEvIMj+Soc6AAcqC/qIgW2UOPPxMD09oqqAx9Wce36mvqOx?=
 =?us-ascii?Q?aXK/QbZnMP/U8sP04cQt6WST3pL5KKo04vcVN140QKExmT//oUb4i+OMAohI?=
 =?us-ascii?Q?eaEFJQR0TO71RBU0sygslb1y73Kky/YAO0JuBRDV0IE5V9dCggWYY54NU4eG?=
 =?us-ascii?Q?XRcsCsLkJqysmt33LgAnRE2WHJIWCF5JYn3zwKhCjBgfmGtVr/mjwXiZ37Jk?=
 =?us-ascii?Q?upmazOuLFvdlTc/5ip+drHyWUugaoXyJ7OjJo/28EHMG7Lv7y8rWvLbG9w+Q?=
 =?us-ascii?Q?QijEkxcZLWldSste3ajUq0CtEapL9kMMzce9nNbLmiymEm8Eu1FEGIA6Jpq4?=
 =?us-ascii?Q?SCrfrX4PM16NIb4uesw85a6vpPVOr9Of+VCvqOzap0aNpKmr0h6/+eL2UgOt?=
 =?us-ascii?Q?j0Kn7z+5JKk/iyNbFnTDnuFJ3yI6o9uS80dcsiGa2oy/Wo78NfV6QYw3JUXk?=
 =?us-ascii?Q?5QFtxoJAdGxB0XUdE5Uh9Vz2LZEMH4dbQ6y1ADYNqDZNv8Rlg6bRXuVKdLKu?=
 =?us-ascii?Q?R8mDNNn42rVBS23YLVpd7lmQ+xnW5EY5wVSP7o1mWluu3U1N8fSC07a0d7rn?=
 =?us-ascii?Q?puXvcDBYwUsMR60Hg2Ud8DFNqSxkfRXWnIuALo8JxJXfpDjaU3lR/GHAEtK6?=
 =?us-ascii?Q?D9rZMEQ8LXtSPd0EjWyb7OrMAbC2fcUqHJeuZDOk/rLQ+VYL9DouQw6cfsP4?=
 =?us-ascii?Q?/qflxNFEoJH3NUOqyNE6Gu28cQphxzJD/Au6XZFkgWRFxgeRfwhqtLu9jg5b?=
 =?us-ascii?Q?1CY+UGdeC3FB9oBG8jaWPjphzhMVsNRvLWEIV0m/iIYGRJAPbSxe5kq665js?=
 =?us-ascii?Q?LqKirrLkxEEQlkDt18oJSAUkwb2/wXMNelF0Vi1VZoNSfsAmkjlAR/fUCFQl?=
 =?us-ascii?Q?HkIJaVg4Wb/Wto+Vb1il0InOzX93BLb1OiN/jiPa2ShMKZy0NBoKRniRfAaE?=
 =?us-ascii?Q?hfskM5muhqIAhVhtcDCoYa4ZwPlYL8o1fL7f2mq1Hj222cfVreIXNlxgFfWb?=
 =?us-ascii?Q?70HdYZ6fHpZIgpARuUFezt0PwRUE9wt16LuJp2aVygZtESXOi+tXSj45ZYnL?=
 =?us-ascii?Q?N/3zbCtRiZKtlwJR7OYl+Ky0Mapczy/7FR022gKW1TpEG0lh+rUqr1u/Wd9/?=
 =?us-ascii?Q?0O6hQCgT13N+BcG9MFFIsCEhorhs8yyti9olXov+XZxFQ3YoaY0h8x5y8urV?=
 =?us-ascii?Q?T/shyhUb8gX9KzTX5pVNPED01JaM4QNZv/Lz7G8X/M5uL2UE2jJdixMbaVge?=
 =?us-ascii?Q?4A7w3UfFd0pG85XygsfPlOVmgjbw7Nyw3eyGwTlbyGPXIpusuc0WMS0W/6SV?=
 =?us-ascii?Q?hOrrwsYBJPLtVbwk4x5X4m/+BWMV8xJPlqNVOFqdk6hshKQ3cs/+S2B0nWo+?=
 =?us-ascii?Q?y4hhhRC42w720su/PMISeyxtO1UHKDjtZsl+v4KtTlqYkssavEPv3iDtz8s+?=
 =?us-ascii?Q?5lYTZkhF3GJAZFrRyDAcfLygGwFW+yXThjebPq75sj8vrttZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3f0d6f-cdca-4308-f554-08deb14d544d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 00:11:21.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JymrKn+JKYaUFlhLbolSx8weK8kHTEx8eJBRKsV8Ou5zIMMQhKGYlH4T8FIn6cc1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8764

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

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 49 ++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 01171361f9bc22..24374c8aa853af 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1268,39 +1268,36 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
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

