Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2263E176FB1;
	Thu, 14 May 2026 00:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717495; cv=fail; b=bc8RH6kf8vVvMrow/U1gIG/q+62ookLLdloriIKISxpwvo7YKLAY342Y1555ONGwFSIAfHpN1DA+1DOnbxXTl4ZCSnqi5FdmYZ8jIEL1A1YxqIJNR5ufkxqVH99WbfDyZx7k3M3Pi4sUVf53rmsnHX6Iv6WCtSjgoDyMkcZfe8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717495; c=relaxed/simple;
	bh=OCxkK9V4qncVdgw3c2CEApimYcecwB/lCV7vPSxwuFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=baaxZJF9trKTcLf4XBOO+qwaZEerUTkExqYnffaKPZzHBrUHqKJF0GQQ28/r664vstC8O0gOBtEI7CKMDDfW6iLDcPdgPEj8ySfmlOD+F3KK+UzjItmIXo/pnRkexFDoTU3emR5JhmERliHxpUwpi3slkPulYtQEFBVjdAuiYn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ihW1hhAI; arc=fail smtp.client-ip=40.107.208.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ihW1hhAI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D3iHIIrXjZC0DfUB5o9noKpjq4Fj78hTIkusLusv5GqN9bMBzunmLnKE6STbHNg4BXqh4BUPBi+bPjt27Vk06864rP/17T/YTv5cstzu3dkJs0GJlXXQF132hneNuPeMenDttlVDLj0iFEb2IqDlBm0CRs+j6XJzQiuVujsoDQAZL0ARKmvUMgcGvNOJeG8ShkLZWXgQEGU4MiNPpqIfJJfW7wl7QKAc1tBxfwauCP0ds+w89MUTUkwQT2ieMzrWOrYGV9XMRKrdUum55l6BrkDBviSTzkYFhZwo1l5WF7/OM8yQdswXUKuoIkxg4/AjkyZZETbdI4rHBE75oejnUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=08a4ZxgTsIdAtJLrGm3ug6ERbH5tGnMg2u9Efvum5gQ=;
 b=HstsDKGZOCiBjPnVq3YkM8z138wtRpoRX1sSCkh/r8ypkcBZm+1APSorzlbp83l43GfoLYez6a+B2W03sKSzo7nrizsUE981hFGDahbXBg98v6mPSImRaZq3PUBP6gbEVpt8bS9Prvt9EB/N3h3DsS6CdYtXm5PC0EYHR4EIXOFguq9Rx7qE3qmKnY8Q/15XLJHc53eOgesl7R/k16FXCbW90h4CWbYebL+52rPHiFzn2d3Dilw+P/PDrOtuMGB66r08ctGjI4Ov2SNXM2NgVtLP/CZKMBNtzo/+bJtfK10NXJ6spBAm4lpu0ERn5wzGsTNzvpfZRKDIxoh4uKyBPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08a4ZxgTsIdAtJLrGm3ug6ERbH5tGnMg2u9Efvum5gQ=;
 b=ihW1hhAI6NOdCjbRXOuU5WnPH0eaHNLy71xY91wXhrgTJTzegr5m0UWMjvZB1anAYZY05M/GesWDRQJGPMl1OiUCTDVcF4/FkHNeSR37RCBS220oAPrdvotbIkPlhiWbwUTxH3eY/+Bdb0Ahxm85iGiftzWnaTh9Xp6iLpuFAt+kQiPLGi+PVapI/0lNbjeofZakeexX2XnW+KjgGCYMFsMsDvN/httkK29HxAAXb1OLlooQ1bhVkvKCBbK/UfSb4nEcBCv4w1T3ZXyMhy3L4cMhU+jnRsOGitwc3s65KytzuBptTHL6a9HcZvb4Pjk65XUMBhPru5SO7DU0bryaQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA3PR12MB8764.namprd12.prod.outlook.com (2603:10b6:806:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 00:11:27 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 00:11:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v3 4/5] iommu/amd: Make CMD_INV_IOMMU_ALL_PAGES_ADDRESS match the spec
Date: Wed, 13 May 2026 21:11:19 -0300
Message-ID: <4-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA3PR12MB8764:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8eca7b-beb7-46c0-0bf9-08deb14d5459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|11063799003|22082099003|56012099003|3613699012|18002099003;
X-Microsoft-Antispam-Message-Info:
	G4XgG7pmjsYZjB/BGPS9qQV+axxFoTripT29BHGBIfRMnStPPDA+MmQOwMYkaxS7E7wpW17Jr+49bZ9aOzZSXJ5dVaH1YbgB/scGtieOF/ctsJpL4iyKDX1Cz5YOrmEHx2V/otBnaYDiZKkefmdCotNiS6nkpnVvZl8tYZ2b3LJixSANo9qyxTsP/XGXWbw0bzgD/Iu/wIA/njkI6nYlcibThea+KxbsAJdeAsAOHl+kjN8wvtxOaOUkvkDPHau6xy3lZOifwgFHOzO+vWdfqRFfefGTsAWl61wMfij+3Cv1bMM/NfTWJmWIrHkQSrMUqKxrlf4Cl957UO9PQiin9XGuBKxS/XHyDm2Bj3n5AX2ss5Zx1F5tBvRxrTDnCBgfsuckQlUdbpfUqet7lffhM4LF8b9FOMlzBKHaKt3WbRgIuzmZ1OOx5ePsmWoGvM+re9ZpXYcX4xtu87jei148422NAPcfWViZl5290xZ0Z51/DfnNVuLw5FsnJ6UaNaFxas4ouxtHhoirKIJFb82bIdAKQ1zJt4YClVN+c9us+2+X6tvdSXt15umGRmNd0/zdjFz9J1JYhIgzaj6/vR5MzvtQPayor2gDMKkHZWAVuPccJ+Ef3M5oBIwVCKwsxYpgi/e8lwCk/weCXV4076rkUfz1zOTjud52qNMe1Gan66wODJxpYhTc5r8GL5+WMHCJh/RY1RqRRt3BilqYM15NJ2QxxwjleKsj3tObH0lvvdezzfXEVKPJWrQ2vI+sDEkc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(11063799003)(22082099003)(56012099003)(3613699012)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZJv6Zj1btXV/efX5muIFcecntXnLxMkvzoZZiTkBu9Y96RZMl3HeLrCXg5Jh?=
 =?us-ascii?Q?cleDavihV9oeVxVyM570eJT5CsztSI3MyreKySHNpStX+5HviF5EZtMC2dvM?=
 =?us-ascii?Q?W9BljnoqI/rwe+riMG5nMQblyYIUfQX9G84BR2dh62bwP3ns3O3vMbtiaW5P?=
 =?us-ascii?Q?jgoXaZVssTDHuk/vENVpuCCWcPYon+ByqyV3OTlb5Z8fI/la6wtXYhB3WBxf?=
 =?us-ascii?Q?GpmSkbT9ut8gSPFGzaTwGIi7DcXNeMV1X4PjwmJlNc0eZ77vrrTYYE3cvfEA?=
 =?us-ascii?Q?z8qsaDHd4Y/Hgkvi1kAXpVFPLXXIlbja9FD9mh3U1fQ5e0q6/LF/YYRKigr/?=
 =?us-ascii?Q?EmgqlWEZS9m824tZiwZvK34kr/OWvAKGagUN6G4q+0uyMJn/brcAhP0Ol6y8?=
 =?us-ascii?Q?+ej0qmln41NrZu32PQp5ZxqLE0o0Zcy6LuGWsefKVNLT3MLtzuXseQllvqRx?=
 =?us-ascii?Q?uuV2RX9ALqNbq4B0iUesjOvgUgWUna3gJ3MSAH748XqiSYduOLv0Vsd6q+9l?=
 =?us-ascii?Q?49wgp2m7II3gInptKuodRcLyU28VucFvON+QQHh/wIygFfwHXwFeqkXgZ99Y?=
 =?us-ascii?Q?C7NTJ0sUzUSZhKbKsuPDiJbu0OARZqihEVaUf2mpyevdGim2VOSIw6pPFA94?=
 =?us-ascii?Q?hUUCeqr7TKxNiERAy+D9CEEWqZC1mIkeW2ELHQek2105BXCOYvWMVi0bYMXJ?=
 =?us-ascii?Q?PhBm3C1fn6A1rVRMQjwx2rxlFz/2KMu2fwonnIuhSqjt0DGSFSv64t7kbrBX?=
 =?us-ascii?Q?r7+mKtkZtv1He7DuNeNVoRijIZJLYYDCTB34zyD25m6yIOUPiWe4fQ+dkMW0?=
 =?us-ascii?Q?FqiPhWX5Y8h4byyhSqf5XsJoMfVJOnLLwAJGjatFXOZyM+qHC7FgkI06M71U?=
 =?us-ascii?Q?ZGxdkb7KoZSMglMIISGmmZHrdP8iatut1Cih3uJii7th87uEvu6e+fj+7Fxq?=
 =?us-ascii?Q?2XhTJ1ZnS7QY9AABaGbvtM6nJo6AHsLdLOfr/6K0Y2OIcPAPfS0dMI2FfjVW?=
 =?us-ascii?Q?588juFV5WMTyjiSiMiNUx6aJzmawzPvnJ6LAaZrjIRIJdft+Xk7LqPC/Fmtl?=
 =?us-ascii?Q?cozqICT8dr2yZItKL5629x1T99ivne6rLVkRPPAbJoj43R6bD0GOT/PBTZnk?=
 =?us-ascii?Q?CJyOQbveUSGewdahFf9wdf4vEpMT3IUNO5xDew7CHQZLOn1I2lrG3jYBQ1A6?=
 =?us-ascii?Q?DGn5qkvmaYFM8eJJeoceSBaaJqQjfuOJg5vBaw8loNGhFZXCfZOHGdbcrOx1?=
 =?us-ascii?Q?UzhQFJ14/hWk573j48Xs/w6iNFE9HVp348ZsK1NGxIHloBr73vzJ6PiiMp8E?=
 =?us-ascii?Q?umDBHHNJ/aVnFU/tT6P46Gpmq2l+CGqXiY+QjEP25cKAIOcyQxBS4gD+41IX?=
 =?us-ascii?Q?S7WF6hYSf5DKe+gdrjpYctg57OAKb36sPB8QmJI4qvecMsUcEa4Mc1YknLdI?=
 =?us-ascii?Q?B1+HDiuv7YkX/d2oeZY1p2yNNxu4E1icUvUd0VNupQ9wiN36pw8kPakl7qXT?=
 =?us-ascii?Q?sjzt8Pk1Yuv/cUoWs6wU+92NoH+vxt0+ZagHbkack28XbIGgPgLwZbbKnklE?=
 =?us-ascii?Q?ZAZi3NEEDM0bKN89A+QHiR79QMXS+LITI1rRcTI1kF8xOIiUZFtsy3ba3eo3?=
 =?us-ascii?Q?eeRv9S25sxF/6VMSoM7tNteInz69REv8H59VQMj+M+cLIkknDddOrRz63gOn?=
 =?us-ascii?Q?h+cm4JwOsINWB+UT7MDmM07/BatmNJkAhByJuOPNC4/S1Mno?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8eca7b-beb7-46c0-0bf9-08deb14d5459
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 00:11:22.0253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KC7Xer/tiCzmHg5LhcmBls7N7s4wiL7rEBTT7MgPWCVVX08FLDHQKITiu+DMEQT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8764

The spec in Table 14 defines the "Entire Cache" case as having the low
12 bits as zero. Indeed the command format doesn't even have the low
12 bits. Since there is only one user now, fix the constant to have 0
in the low 12 bits instead of 1 and remove the masking.

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 2 +-
 drivers/iommu/amd/iommu.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index c685d3771436a2..c239c5fbe47461 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -221,7 +221,7 @@
 #define PPR_STATUS_MASK			0xf
 #define PPR_STATUS_SHIFT		12
 
-#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7fffffffffffffffULL
+#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7ffffffffffff000ULL
 
 /* macros and definitions for device table entries */
 #define DEV_ENTRY_VALID         0x00
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 9a541330f599ed..38cfeba8313b43 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1287,7 +1287,7 @@ static inline u64 build_inv_address(u64 address, u64 last)
 	 * invalidation if the size is too big.
 	 */
 	if (unlikely(sz_lg2 > 52))
-		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
+		return CMD_INV_IOMMU_ALL_PAGES_ADDRESS |
 		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
 
 	/*
-- 
2.43.0

