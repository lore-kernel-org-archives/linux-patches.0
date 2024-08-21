Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9844C1B2518;
	Wed, 21 Aug 2024 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261849; cv=fail; b=HGe08mMJbRnwIvdSCkhbBHnF4xapRyAcKmaUYZ75xqsrkQpIGH+lm8SOt6odpiBTMd2K6L4s6bqNAs1cEAaC1UuKWw20IJ0iwdv6w7xpHFRDRfLmbm5t1BcyxE8MsxYeWNONLljPUJFQdGrCqTBgVnrEquR2yOULvOuVY8VO1s0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261849; c=relaxed/simple;
	bh=0tB/+1/Qx3vJb5/f8Onfg/ADqpJxsmyEt8N63GJPwxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nQNIyms0g1q6Jx9oz1jluZ99aoHM4MtfLo72xQ4m/xbucTqRHpLa94HXWC/+jTAQi5GNdybfzoSWl71q9jPIrq6T2UT6un+9NNA4eweQPrq/5x/x8AIqGvGBEh+CApxIcK6et8ZqB6aqP8Umgj8ZXuvG1MUG8G9s/ELcsKxpajQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V52wGkax; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V52wGkax"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WOpoen4XeZ2j+ZxTLCBgNFUVQL2dwX3di9oL2WZXzpPxU10wft5DXZPBfXyQA7ZHEzxKG1KWCfU1rG5Yy4djgHkCcAmaIJ7/rAEs7/yGFAhY14UvTZ93OBtBm48+PjnbAAKTy4pZtNBpbAvFmBRoqX/lfdK6bVMZiZ7BPrHf4oCmOgbz8O9tNylmY9uq5xnW2D5rMy0K/t/y94ha1ltLjDvpTVYS/aiR5F4VrDuhC65UjEPHtA39cozJiynS41hvY+lT4mstHkpSq73GV336FZjkigsLEKWzgLYwXVukLD4v8EoMcyFUtTyHgHmdy5mFGuCzGcAVWwejxYJi7Da9cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBPXAbtivZpehtDjgnts1x1VwI+dejcXorbsZuH0HvI=;
 b=Xiy/q7MZdrT8IdCqP0nhajAzLepe0D5YJEv3lNjPe7sI4hBbHoc2fN1dXA0R3biOPaItpRRe2Sav+7poKgYtLZO+PyS+nAq/LjuE4tF8qoFZuoybs8YKP8JKT+eg//1oEmCoBoGxFhI0CkHo32sZY32t0BntA1uLtflnlRYcEA7a4OyezwaRmEos/uM1nCJkjiSmX6x+FE6Du+Sl26qMIi9ZTqssLGTBvhYXXMJmZyctxn+JqtR2nQ5XLj+4Zx+OaIjKpEuuQDSkPcv0O2C94vFpXer/LVOQKlM3HZRgbSnoZwq1DuPO3Wa10X4v1pniCaw750KmbnuUmQH+jLb6+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBPXAbtivZpehtDjgnts1x1VwI+dejcXorbsZuH0HvI=;
 b=V52wGkaxYdU/dG1wWanI+riW+MbmA/CTcBSU8RR0ybVBmeiMBCXjT9s71PXQxzsyowjRMnXTdcDa0EiRGNqNHulF8q4TTHFryd8DAiaJvo/DU7ia/WjNqQmmRX7qCBDo6Jn5PAiuTCctEenfZsinXvaX6ltOZWadAAx7L9FjRYG/qFb4EUoUDcAtR98BEwqEh0QCyxS8RBfywKEF5N2ydandL9UZuiyHPt/OZpI503nOyFlva/OfB5iRaatZxF9sZU1ohfY2rmmN63Iqjjhlersigj96UPnoAMAwez/qnyt1ems8g6etEBMZVQlE5dlqty6vgXNWY4K/OvmkpphNMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:22 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:22 +0000
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
Subject: [PATCH 14/14] iommu/amd: Do not set the D bit on AMD v2 table entries
Date: Wed, 21 Aug 2024 14:37:20 -0300
Message-ID: <14-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0012.namprd22.prod.outlook.com
 (2603:10b6:208:238::17) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: bf19e16d-57f6-45f5-f1ce-08dcc207e95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TymEls88xWSA323N1ZXfchKJQCRRxntCfxo6O8ct1qu2zQlKdLttkQ7pf8PD?=
 =?us-ascii?Q?I7Ltvhun8Qbpt1ry1Js0Zt74f9Z4b5YNLnB2+xHoc+1BNBFp5ratKHFkcCQe?=
 =?us-ascii?Q?v6MxVOSS3Qc3osiFF+KxiqtD5r6trYtLcHfyftFENTL2yYvHVLj4PvyI0zu6?=
 =?us-ascii?Q?ZHGWUzMZxNuJKfVqmhhA38gI/rSeLk1mJmVTSxcTyrT9+O1nkMoCLADNAC5L?=
 =?us-ascii?Q?LGOjfwhJhL7X+Axvx8Daf8Y7trwi0qgIFMIB2+TpRKSMsb4QmzZNJCBi7ddj?=
 =?us-ascii?Q?WxCH0GpFgIWFvopphGIHaDlIPU+p55oug3M3p0MPN0ueOXf8+Wgu6EYbL0xE?=
 =?us-ascii?Q?SeaSJ6OPeIu5bmf6x54EPgrE/riIcFyrB57ZwWkFGUAS49Q/hcCNb5BAFbIX?=
 =?us-ascii?Q?3nPhux62D2Qtl7Q1j9CsQpSJDe+HgP/Ev7h05a7RNjfgAZKJDY6IlEvfgb3i?=
 =?us-ascii?Q?Nrzdu5usI3Ac8V4XBAvok9vsJS28md1RPuGtww/bbnEn09QZUNpgk3lUSPGf?=
 =?us-ascii?Q?D7L0YYTIO52S3MGzVzbzHVlIOHO/GGQCmI2vv9MjQMC0iJnqEc1852c0oxwq?=
 =?us-ascii?Q?xgaw1SlfoNnHr3tH1M8fzi9b7a3PsFn/kwggbDRHTwVK7mkVJ1F9gsyXcxyT?=
 =?us-ascii?Q?z4YtJV/1vung52Js33JgzyC1gPKVFQI7TJ3kmVePt9nmZf971sP3XOERdWVc?=
 =?us-ascii?Q?TrZiloH+9UdD848XCM62vWdfomaA4CGOqsted/1rwt1ng5ygrPYuGnDOmRp5?=
 =?us-ascii?Q?Vd4K4KHNGoGckfG4P9J1ZHGt9UBq0d/mlzyCatJVJ0Wc+6Agi28tEI9PvPze?=
 =?us-ascii?Q?3PFGL4nGgdbseglt87fJaEDqw9xDo6GRxTqcxDhhmGXJhM0IWIJITVX2ozQN?=
 =?us-ascii?Q?ZMGZxAnSGc7ZdCfSAPryOou2OQVUt4O8tLUM1k5ZWGd4oqiInzH36CABWwt6?=
 =?us-ascii?Q?NX8hgDBuWhvO0+YlGxMNSbqbGStwVoSnB2PAVlEevJ1gRgUUNubI/mqcrB9J?=
 =?us-ascii?Q?JW0EQ4/9PG1/Sh59wnc5GYrzgbUCZjOHmvuveKpzBzUxp2dhZTMR0JHZonk/?=
 =?us-ascii?Q?pzSBFgyh+LRWcrM7tX51xrJNHViWHlWbvs6FqNeaDJlFen4mdh3QtsAkLsmN?=
 =?us-ascii?Q?HCzeNk+QYtP/gX9ggCY1GRMTK39YYSnkdn7U3cLeO9RhSU7XbzktYdEijsN8?=
 =?us-ascii?Q?YcASfzNNhwxUXYfeN8tQ4DATsM/kM54nPddp3RhuY33XlJPKzDrhigtIVAgl?=
 =?us-ascii?Q?cxNsY5fUFmWWvPETzvg6SYDPwy5YgD2NYd/0BeF3LjXaM9+l4zcLv2hNzI8a?=
 =?us-ascii?Q?WnbtLoDhRICvF/sqv0mkiyvBvsEaWGvSNT3sl/IEAqS+Bw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H9OW5SvSlz3xA3Tn5o4dbQCtumkElmIN2bGga5B4f73t7qpaDifSc9alC7tN?=
 =?us-ascii?Q?YrY64rnaSsn4j2nDyCdg6Uhnb28iV3lMNEew3QvbivS+L2W1VdEvtZzi0A9x?=
 =?us-ascii?Q?Gy2cBX8ZDjH/9C8N9wHCcF+ZjTfbYmm5E6MANA9pQzg7jK5hDwmVKIhSt3W6?=
 =?us-ascii?Q?vINEk+d8l40oiTPtW4erEZ7cHrV/Ob34cAI+PvZh/Rq7NzaZX7Lo4iwd1sLf?=
 =?us-ascii?Q?QlS8LFFgiTJgY/1x+k21Lv+Jm3657r9BFPr3jLlIFxfs/gxwPEqhHyBxiVaO?=
 =?us-ascii?Q?+PDNkqJx48YTKWnhO8JWSu7m6DU1sjGxPDjyGUSJQGFH6bqmT6OrrfSVqLrx?=
 =?us-ascii?Q?HC14j1iW5NmqB7XWTBeOVuFvtyNBQYKp1IN2WBruG6uEKfLbxhkVo52t6AJ4?=
 =?us-ascii?Q?Y2Jp1IhA25eYSdMqTcQM7qifkf3MBZZXYmQdhyt3cFnQ6N0lCfkivApjP1xG?=
 =?us-ascii?Q?4y/f2P/KDl52H6DoaFmljN20TGjvh6aCm6Q+4d++kurwVb+am62qvMjZUZs3?=
 =?us-ascii?Q?4wbIjvq+aSFHxCJQ5hy6qxE0jB5sg7X58hTPygtjVQ7mlqzguxIAHBqsgWLd?=
 =?us-ascii?Q?CA/Pie4jTZysT/WCydtz6UMtNlcJpTncn/DKP1+PamTNzjjEDdufc05eEg/j?=
 =?us-ascii?Q?06hG2u67tTPZMB3retiWq87jawz0i9VbfcthVSYrJD5zrZau57EpU7gJRBzT?=
 =?us-ascii?Q?S1PHXH8wHFKyn/ysPnjx5I7mzSBvlAEzzaIIYe9ukgcyvGmHtzz03ofL/Xef?=
 =?us-ascii?Q?657SCCUa1af55n3w/l6P2FO0ZD/qi0eq6OFqMF6wk/6U+iG11+GBvSDSTcof?=
 =?us-ascii?Q?t9mxMTeL5t8m3zBhRmy5BMWkYIKJg9ToAOqy/zjSVJSNuPwEhO5V+D4zFPul?=
 =?us-ascii?Q?3DDHCF1LZUbNAOWWl4RQY3FDniWkTRo6JQhEX3QrTjv4GKL2zSDqrJzC9opN?=
 =?us-ascii?Q?5/Ihcu6HmdDY2qUbUdGgaxabc5sjyBI3vjjn391p4l2dIeSzfPdCk4mOBKs0?=
 =?us-ascii?Q?iQR/XkdLoQPmJRzU/5kbiG35bs9gVJHyJFURsqavbhtVrY6zqszF/BbtuH+J?=
 =?us-ascii?Q?39BYme9n73w9EUTY2EhR+JV9qnbQNWbshPCJ3U55wY5PH77ZhepaQjOqUSqK?=
 =?us-ascii?Q?kbrC0mHQQRwiZWToUTxCRj2gQbdPdcQlKzLzdjxhl+DirrQhM9eQHN2mGH9X?=
 =?us-ascii?Q?jbesAhzfQTDY7QD1RuWKw5km59oC3AQqZ1zgm2hgH2oCTxA07Ko9NefdS1sr?=
 =?us-ascii?Q?wva6O1fCu3FAW4cNrjuT/vdYFsXcaSS8X2IMrH+fjK9mq8ubSW0DqlUgkdki?=
 =?us-ascii?Q?CKD7NIYLpT8hQpVq02wYb0WF6ucQFfNelJ2dlcnOnxQFvhWtz6gD9b+9a3Jg?=
 =?us-ascii?Q?P11bnaVtXAxG0hITlqfJlsHV6VMun+bpga3QeUToyqayfxMf6+yZN5kCTYsS?=
 =?us-ascii?Q?fA2rsMAmaEUQh0jlzJ/1MOdaFO/IHXfyPUkPULHqkKz+DpCCn82Od1siijsZ?=
 =?us-ascii?Q?AvmDEts2KI0iZTZHjvy/Kt41yAL5ClbJqsMxpFZ8xSgK6sBmfhm6jTq8w9Gp?=
 =?us-ascii?Q?yg3PXcyB7Eb2iUFJB0YoHrynex5klQE/BDjyGKvV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf19e16d-57f6-45f5-f1ce-08dcc207e95a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:21.6276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cIVgqPy5cdA37foMUvTeIlgo+09JYX5IsKO7R/HivgcVVogQxQ4Z6sHrorcxf6s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

The manual says that bit 6 is IGN for all Page-Table Base Address
pointers, don't set it.

Fixes: aaac38f61487 ("iommu/amd: Initial support for AMD IOMMU v2 page table")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 77cc1b4a3f0225..25b9042fa45307 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -51,7 +51,7 @@ static inline u64 set_pgtable_attr(u64 *page)
 	u64 prot;
 
 	prot = IOMMU_PAGE_PRESENT | IOMMU_PAGE_RW | IOMMU_PAGE_USER;
-	prot |= IOMMU_PAGE_ACCESS | IOMMU_PAGE_DIRTY;
+	prot |= IOMMU_PAGE_ACCESS;
 
 	return (iommu_virt_to_phys(page) | prot);
 }
-- 
2.46.0

