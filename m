Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BE3A2D;
	Fri, 30 Aug 2024 00:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976399; cv=fail; b=QdHodgTOyEMOXul7HFEieMCESay2M/ap84pporwB6RfQ+DYEA4OGWqF7bZRPHjWQ/g6cA21KNliFKlL5U1gYNytzF24U25wQI0LW0L7Twz02zMxHyL6G2cMhhGSG606e6OcliM2f1Pi2M1n9t0QitLa418UyY2koQsQNZOuzPLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976399; c=relaxed/simple;
	bh=89c1AHEBuUIaJehrV4BB85tGq4jMu/P5cwmFkPcipbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oU4flbMdtaUgQlg9qcr6k65G31DcbCcBhANRwdXmCqB/CDFP/Bo0QxWZfUJx5NMLYknj0cglq6k8QMs5hG9JsfbLyD86NaAGLp5ylk3zmaCtQSQNfDAgC4EXkAeVaTXXUEPmvPKnp7mVcephUP3fFbaKIdX/xGwksWeJ7acCLOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PPRhy5UL; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PPRhy5UL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MgS4c8j59whBfksCWBM9RervGc5JlHhcxQKtYxJaiVjtBumHpjt4jLfKe4kG6tS6FbqKDivKSKnJQaAAD4MnTj9UkaDzY+rBrqWQHjBWZLOsC1+PNE+Q0WwTkjdgNpZmNNTSnVqUm6GexBCllXLRo5XcQnl1ZdYnk2meTgzcyiBC6OfIacFPMrKeOLxTB+VV/hT+7sniZHLMY9UwkcmSFuLn0Gp/JaOOHrlL5UICz7Ea9iWaatbqd18ToDJ62guL2zSSCArHa40z0YQUp/YktVDQGC6ZmJeiDFLIU0F2I0CWbExwuHv0C/45U2fXr34oM4tLsgszmx5Pl+qbgIDJ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gu7Efp4yrUiSGrrZP2u41TGCrJg7Og97wDaEtaCMZEc=;
 b=UVfSdGQ2ZczTKy6hZ6M/e4yRukieOCyd+RqzFi9aVHUH4smovQLPOcoBZmkbHVLs86vYc8X8ucPDGzRnXaXtZksPtPXKr+YO0H0uVxB7W717BaOL48pshKueyllOWeWsHwU5k0IKbYeiNeBWuEx48ZanroYjB3yHtDzanaRqgbmXG3muEa696rshdsoprm2j0vELJKaUD76BQIm48IyLRV9XYcnWCMi6LTMIeN3Ax63APHnreizM9EDV4ulwHlWEtd/VE5OmMIPGMTsxcWrdvPuaYUqtMJHLpAHIOBCVY0X2rBgGEcwF4y+KthWf3+pr9bcZCyUYAhgGTeoGkzAznA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gu7Efp4yrUiSGrrZP2u41TGCrJg7Og97wDaEtaCMZEc=;
 b=PPRhy5ULNEaIZyMXAKM/5U8PqchruFoBSPzWmQfiDb6rO4/MhLLgxY/pu3/xP+TvXVdwIzQXDCXdkrmICUc5TJbD41jdAbwaWlVlbI166/mWRm/L3WXSQuBO7xqweNOmdlK4G4O4lEXqyPjcgrt66YFH9JsKGT2Xcn7WIxKWtvxXgWdwZZ3Rpg/nWQd9DHXiCxyvqdzQzrP9797H2zBi4kSqgUEIU+2lMjEC4sc9O6Tp3hRF9xO3z7IwIM52pxdnn4gtrc9DUxqUweGK6gcGQM3xmwvDQMjXzaF44QB2Tgd0S0CiiRekQC9NmwyIRyygncJB8OgaqMYZA+8ttC19Mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 00:06:30 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 13/14] iommu/amd: Correct the reported page sizes from the V1 table
Date: Thu, 29 Aug 2024 21:06:22 -0300
Message-ID: <13-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0795.namprd03.prod.outlook.com
 (2603:10b6:408:13f::20) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: 14b89ca2-5d36-4b6d-1a54-08dcc88796af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+Q5cJTGXaqojSi//GYTcE6S/TLLH2KkSKwMu2oI6nC9PCk8SCp7rTYUGvWsG?=
 =?us-ascii?Q?Bx49pOBgcMjxQhPknKnSGSxCSlx8m/5Zyjcr9+Mf9U0RUNUda/WUy9TxlBjt?=
 =?us-ascii?Q?JHZnmBhuihWJ6sNspDN9P1L7tTYqS6QKLsxvDKMkRmQsVr/AifmyfKrMlmCm?=
 =?us-ascii?Q?3nwFolKDKy9pDPoigRDe58s2Z5YCKHux2E207woXWMv/5CvEckszoh5gwBp/?=
 =?us-ascii?Q?QL6rm0R7hQOaJI5LOUiJdLP3Ai49sMr7/UE8DnEhz/fXBs4ZSUNMT6lUoNCw?=
 =?us-ascii?Q?LrPL9d+MzbFChuPDRRs4ZSYfKc10wwen2RN8CFTFmFrrDPLglnhFrelCWhmk?=
 =?us-ascii?Q?ByuPIrQHZbsqbiNoWRdijThJbuG9+7/B2dWnlYOyMbsX6Kme5ZjJPJ8yJNn+?=
 =?us-ascii?Q?B7AAsZpGT8IzRkSZWhJj5VlwKet3XogT/zTY9lCBwbMyEi8LgLgDyOdKcwav?=
 =?us-ascii?Q?cvUAFfTEAlc0NGreBaOWtvOOLVeG+31iKBRtlP05nTJcnV3EC0EZyeROjDQb?=
 =?us-ascii?Q?Zs/tMYfL2LfcXiLPOnGYLAstVn4z+GgaajoCbB1SQEUQbku2STT2AJ6efYcJ?=
 =?us-ascii?Q?Jj4o1YK2q5oHvxRzd/NV/BFegkjzPxJVWldz3H4Yw9BhZ0+2rmay3FXcBfmE?=
 =?us-ascii?Q?wESltLq9ibQiB1nmTm8MK6M2EsgbAQSEMzskqpa5iBLFQxFFAotIQ/mgOmrJ?=
 =?us-ascii?Q?c7OPaTM4B+wEB8kzqdApZr8WlyVUzUzLGZyEcYIhYJZ++jmzD3lb+bzpaodp?=
 =?us-ascii?Q?YqcmkqMwgpqv7UKW655NbJTMIKxNnB1D/VanveV3mr87VMiwaZ9NZtQEv3nU?=
 =?us-ascii?Q?r2X/Tx08insbxc4hoeW0YXN7FdVzIJqEl/ZhBX6Fs/EUPfaF51R3j8O7D8B1?=
 =?us-ascii?Q?lsW5NIrI9zHNJWLCy3FHiYogptITebFO4mUr8QnjKM/cbWNSJ920gWwxLbpx?=
 =?us-ascii?Q?fIM3B34kvOR4vtS0FKAZjt+tpCvhKqIDsfXDhP7+1WZOyKo9viddPJxGyLtB?=
 =?us-ascii?Q?ip0vnoaTfCExBJCjkNJyKn1V4Zx2dLNm8fBQhMdLF+3nHtYclI4qR1rg0WDn?=
 =?us-ascii?Q?SbaZHj0UZvqiHSKIsQPaon2ksBSH5IfAHd0HIArkjCgpDBBVTrsov6XhCllS?=
 =?us-ascii?Q?uZePpalcghAtVRnb4T6T5YkVyKNEhYE6OfTWae606X5LTs3otx4CWC63ytkS?=
 =?us-ascii?Q?/rV363UcudMXWtX63Mi5cju1vAwamGLQJpH4GPCVQW/bfRIIgFkkPe/8G95m?=
 =?us-ascii?Q?WbGDV5VsWIJxh9+YSl/zISTeFFtfjSdeb4jkxvUgFCJHFwKQM36NbJ17rxmV?=
 =?us-ascii?Q?+DdxLE3mLpT+RgcB3vpu40FwoDTd8otgUzglj03ZqNZhSw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XNHRJcrGVIXtgS2yS+1Kg2yF3v3W8Kdu6l4DBFF+n78g3jvfrpp8COW6XzHH?=
 =?us-ascii?Q?abfA1MB2AK8rxSsxzt7BXqSxAMY8BexBoNPJKVs9+o7R64zMB2b5nn5Rfx4m?=
 =?us-ascii?Q?mHyG0IN+7SkqiNVBor5dhUA46jMYVHSz3E01e9S/J+Ft78VLzLrTd/bFPO2f?=
 =?us-ascii?Q?cAiJALwSZ4JLAuOq+4dqU3gSvjzNr5pgCRWMmcCIQEjX9I6hKDdufbBNUbdV?=
 =?us-ascii?Q?ydHq0a35S4nos6oBE0wVc5ps1vvT+mgqHK2+ipuPEifp+Ul7nygcNFFe0Fa0?=
 =?us-ascii?Q?uygnxWcYl1MJawyxStnKxEo60QK/cZzHw2QijR+pJGQuBt2rdJCNkibBlswr?=
 =?us-ascii?Q?gLD4Y1FmVqc23K33/YDWn7xBlGocd8LGgeqX7GvJsSwV+PrwrYKXp852xoj0?=
 =?us-ascii?Q?4D6GOqyx6rrQhcf1dyEyelUsgk8Jl16L2hXJBO0mTFsGV3xLsGuN5+9yQq+8?=
 =?us-ascii?Q?7IwgFaFBNfTfXX4AsHR0ovaybpq0OHl4U9TlImR0yJbAW0faqmcsokOPa1i7?=
 =?us-ascii?Q?ZDAF7iYErLuwYxacpTE33hfnaLyOd0aQ7QLl5jLB7B46SBfExabZ/2JrZIFX?=
 =?us-ascii?Q?3Zvq60YyLn6GKihltx1hxGFW6wru2QSY5VZedx0c+3VhQqAVuDYe3ocL55Zs?=
 =?us-ascii?Q?gJdxrUfI/dpuhuYyhGA5VQS7JOM916euHlM0mYunyuBndIGDWouBe2SPzh3N?=
 =?us-ascii?Q?JT86s9cVjpR0FWIq+Vs5HAAd7nUp0+2NWsGq+1VxcFD9yZ0IYZZyMZl5+KYP?=
 =?us-ascii?Q?ZWaN/AsV8zRZwN5d4fNbE2+0a3lG7Ef7nVlUuo/ugTIUeEdoFtIiCFyDcdrP?=
 =?us-ascii?Q?CKMkxFm6mTlMO5hjDs1Gegc7ssp/3CE1tfeZ6IRNV9ZCFjsZZKYp9E9DfHvx?=
 =?us-ascii?Q?Uy4SdKSmZpt5HvVs83d8a3msKm7I92SuP8fkGEOOs3odc4/7gi2Zbg0HIxnD?=
 =?us-ascii?Q?RmDiKeR0UVU0Lg8NKulL4D8ZIIuIgMVcbKiVXpX60ZWzBrjRwVWFWYjV7nax?=
 =?us-ascii?Q?i5N3PnyBac8d3K5mncJtl0oeCbe4BehEs4igZRxtVPfkpr2M0Ve+1SKzhHBr?=
 =?us-ascii?Q?W+2NlaJrLu0sU04Aav0h2UU690N7w0RWQmiScgKrwH12y3MdzxrBuutd1oay?=
 =?us-ascii?Q?f9vssyTzXqS+esdNqlgE3gCosHH7hW090z+UOwGG/E+RDuAydO0JupgdWgNH?=
 =?us-ascii?Q?95TJx0lBBNi2y3Qx4QEBY+ja8iimfRq/oeqthNHFB7aRhn5XhTdbqP5MwXS1?=
 =?us-ascii?Q?Aj5El/vtRXaN37APqihdD7gC7PLD67RzA9+dRVsGW8grVdI/LMmon864Pu2D?=
 =?us-ascii?Q?h/v7bzxpveqmwDIrQXn1pbOhYr8Du+hqY7+NMcHAH5qHWkL5HBttWBP5ARSU?=
 =?us-ascii?Q?flPaAeOIeWDNcVvy3frbZPuXXyXbuV3W9NGVfgirbiAYNtAjtpwTp2neINu8?=
 =?us-ascii?Q?W95STGduJZcg3gBaUcB5MtpGTdXbSvchyOE5PsfBJJoxNlaUOkti0rCq7Lwu?=
 =?us-ascii?Q?EIfcoiXscrG9B87ZnviriEX4kqvtL8vCDeLWlFOqYMZSi8aNoeTJtcUU5yO3?=
 =?us-ascii?Q?O3n5M6QHhZEAcg944L5JJN3hGsZ/aU9fgYl59yfE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b89ca2-5d36-4b6d-1a54-08dcc88796af
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:25.4900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4PCg7NsCgUb89EfF6hQdFG4rnhwR78dj/5h6QN4uWuTkzLx9PADgaQVkIVWWYM6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

The HW only has 52 bits of physical address support, the supported page
sizes should not have bits set beyond this. Further the spec says that the
6th level does not support any "default page size for translation entries"
meaning leafs in the 6th level are not allowed too.

Rework the definition to use GENMASK to build the range of supported pages
from the top of physical to 4k.

Nothing ever uses such large pages, so this is a cosmetic/documentation
improvement only.

Reported-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 74dc003f5b7815..7eb546af8944da 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -294,8 +294,9 @@
  * that we support.
  *
  * 512GB Pages are not supported due to a hardware bug
+ * Page sizes >= the 52 bit max physical address of the CPU are not supported.
  */
-#define AMD_IOMMU_PGSIZES	((~0xFFFUL) & ~(2ULL << 38))
+#define AMD_IOMMU_PGSIZES	(GENMASK_ULL(51, 12) ^ SZ_512G)
 /* 4K, 2MB, 1G page sizes are supported */
 #define AMD_IOMMU_PGSIZES_V2	(PAGE_SIZE | (1ULL << 21) | (1ULL << 30))
 
-- 
2.46.0

