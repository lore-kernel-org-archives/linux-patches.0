Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91243268695;
	Fri, 14 Feb 2025 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552903; cv=fail; b=qIzEzGfvKJGgZ9EXgKbqBVtviVqip9ouNHoQFJKGAAHkCeOOsPggOuUgR8Tihx1rxI3aECEhTn9VLDHb7y2ZLsxj3wE8eb2BgT12yebQoZKVL50fVYth61Y7WBzyRtyE6VR3sxLjDJo0DRL7AQlZwZD5ut5DIiCSn64Ubeu23pY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552903; c=relaxed/simple;
	bh=CtW5/CifOx9yUhMy6oTr/wrdWvqgq9sRFZIUUo0XUj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=caAkqkD/kaeFLCbXqRlFnfb8FG2ycwKb1eAPkeo8DZEJkp6B2hfLNSwk80MRdWs06kOhfg7QSpIHCcQhc/vKquF4tBxnbKWdvcpGOJOaJ6U8QhvhElfXQDEmbHXoQlEjISjf9s3LtHcLmINNorvLJWCja8QKl8LpubR42BqkgHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ACnlHIdj; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ACnlHIdj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhwZyLpUqZCyWtjI+GT9tY8Xs0cFsmBKECCRGY7Ogb+KtR20S0ulfQuAM+D2tV1BJmFHabKWFzIoG3wcO2JWrNU/bjk24+DHXhfUpMgPJHqKFuodV2rF4OnYpa2Q5HXjJreaLjGO4CkVzZpWckX94dXBTP7h5u6jjwBlcNUYHQsMSIehKQfpP4Xg3V9o8vvZaewhHTXui0jayBdxdv7mWW1mh1KahkkPZ/QSAnrpb8s5eJkRTkqAf9hW9Zm2Fns2PywhQU+glL1q6MeeDkgKCjI2OCUmyLZDf5GH3x+7Fy4R1Xe9IlAXBfuWjpjGv3YW7n0cNC1piVHGQYFg/e+xyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DZWsvdTAy19EE7VrKBkVg6EJIK7tqUPMojrqwAdEJA=;
 b=Ie2LjFDwWz+m+ULf8NtEftWgti3QaEYWdD3DUTV03+2YViEIv6Ro29XOSBytG7M2LrnW0nti6cyZ9e3Z0F/K+YMNrF5xReV/hta8qaginb0YjIAiJJIpcrWKt3m3tandYKoO7G11M03QLMK5ifqdqk3QPhFeq3q+exN4gJi399lMLEtIh0XTFfl88Z3kdIxtzia5QqYX5wO0JlVs10S4b02c0qQ6kkMh6BqheZqnSN+nXzvcMzcfsCNb4Eij6/r+eiVJN6l7bX4UlMkGo6nEKPlew3nONW94hFW7kMYKTsH41cOCXWAQSEhmGnTFpVOUQM3bcacbJeUDWz9Z4P3ORA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DZWsvdTAy19EE7VrKBkVg6EJIK7tqUPMojrqwAdEJA=;
 b=ACnlHIdjxnJpg5WxplYJC1wj1+XmrXgKyjUvepuei+4Vs8KHkciDsWaYxzGX/SyZr4utYFXcRCEdvEXWPcJRUNxXACPy985qKsLd1FhpZh2i94RwzxOHOvdB7zORWM7iAbU0OgG4d++EYEhGA9eYAGaoec3GHJKTaKXhriZJ5aMePTkNya3+Lui0iehlEHshCS3fhkzDS8KRpGh4Zm+3E0JI7x7xVaxEubZFpFG7vz6VUd8h/47SUXmAd31cTu4/TENKk9Trt6YLaSevNl5Z37cEnQQLSrJ/rzFTcYDVE5lk+obTL5+aNkvBYTRut9+Ta4kDDEI3rTxlgAyHSp9rxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:07 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 18/23] iommu/amd: Use roundup_pow_two() instead of get_order()
Date: Fri, 14 Feb 2025 13:07:51 -0400
Message-ID: <18-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:208:237::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 068cca1b-2a4a-40d6-3ff5-08dd4d1a2227
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?orJBJtDk++BGevZO0Z4m9tXDvATrF5FY8IyisfyYNCvt5JpqBStMoXKwFE3g?=
 =?us-ascii?Q?L7NLhpHQyB9rEAnwkzc8P89yc+wnIqkmb/BAdrzlvY6E9bSkA+sQIRyKGy0e?=
 =?us-ascii?Q?vJvEGbP7nkgiJ1w3UlO6SxDem1jniquvEmnQ3KeUoidd+wXQyr1dupX1h9nd?=
 =?us-ascii?Q?U+MfQ74A3n3gRWWv4kaT9jt5ypyVtkqTXh5TdOB5VJjIUhyELtapeWpipPn+?=
 =?us-ascii?Q?+0JCxVQDGwZoZl6lIygOyVIDixlOywl+XoI9O4RyXfSTJnLpSjHP/rB+8xWq?=
 =?us-ascii?Q?E9iTHUeC3oRxkHIuUZ18fSWXvxdVOORC/9vEmEZqHEu1zxsGrF6jzIyqpfEW?=
 =?us-ascii?Q?NxEq4CHrQuC5KtqsqBlEtrgAW0T0j2lpPuMCxHJZKhVut9MOwpvPj0Si+GIy?=
 =?us-ascii?Q?ecE4xcbuVJmh9sZJpTflARThGZ9Pvq9tMx9slEC9JmOTUrkaCFM093i/CbSO?=
 =?us-ascii?Q?MZDeBs2cY/cMaC7ZKUDs1NZ8K0UTA5lzQte9US2nVaao7xMNmZva96dWJJTm?=
 =?us-ascii?Q?FIupuEf11iLnXAgzt5bxwGdUUmU4u2zcBfrsRbC5IGpoDxYwq3E/EofG6fNt?=
 =?us-ascii?Q?6iVkDbG5FBFbOE2MFlvvrxAlQJwFFIrxaskbVxRVyHghPQ/wBRPpcdXXTRMo?=
 =?us-ascii?Q?+NfrD4i7trbKfGu6P+LRYCPs/4HG64HGtkqwfuOS7AlIfuprncJmu5yd7xyc?=
 =?us-ascii?Q?os0cCSVAxPLszN93ekJuW7TqjfUpCbunXQZVag/Xk7dsTylyxBzapdrFFywn?=
 =?us-ascii?Q?Uy+bpEXzbGx/ZItnOGtj4u8gIoqdaXkmQo6eYLOztUazIfS4H6BVoMyBXvB7?=
 =?us-ascii?Q?x5/uhm+zsMNH7URTM/hviK5KQpkdI8gbMjY7bwNXyEGzl5Qd9xfZn8jpC6QE?=
 =?us-ascii?Q?PN+rvLKe4bmhp1SMiG6kSZZL9G3xsYbMRdW0TjmIagKzBnJMEn0aJO5q7b1x?=
 =?us-ascii?Q?/eBdUk4046Hnj0ps+ETdxFze8uCkTmVd1OZRJ6s7vy2wV0QdKcogId3a18nB?=
 =?us-ascii?Q?CvcCtI6qMzCHQTF33QwBBZmzLrlOH0HpUdNknKESsyk6JVynmusfK7TJtMpL?=
 =?us-ascii?Q?ryGPXgIC4CRg3LUho/OsPWvL7cbZxbCFrNScdyYhlPNaWA6uLQmm8Q9wi3Sp?=
 =?us-ascii?Q?Uilnuv2PGSWzVS1pFIQes2k2dF1+iGZHmd8wD7i3r1X8XA+6sEU3K2xr81CC?=
 =?us-ascii?Q?XmT7ufQE/obKTBOKAM5gca0jGXzl4wPnpEerDxGaOhegrfkud1uqYCTkIbQF?=
 =?us-ascii?Q?nw2M6tRqgYRkrfyvJw6YoRSL2GzlPR8oG21CpOPN4ZKMw0dguIePrh1uunk+?=
 =?us-ascii?Q?BIT5iBlieESyJ2dLF8P5IeX0wTKkzIDllE4frSn9JX7JPUjCJ72d4Grlj+xe?=
 =?us-ascii?Q?19QG9GsMuGK1QZQj8FMOQx8m6S5lB7SK60Z4Adq/mTHDPkUnVIohmuKprRni?=
 =?us-ascii?Q?uxTY8ZVB3gs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ysdf6gfHL96c54TlckkA0O3MjxaQ4TXDoXSw4NZepoHp++qtj6uKiWTN14MY?=
 =?us-ascii?Q?UZKqGqNlV9OHrg8BDG2xZzjRZdo6JUtoy2K7D1fXBKcom2y6VKHP0anxvMDr?=
 =?us-ascii?Q?FSuOf+w2xwImHFKOChqMLrXEgGgtIIPi+8ZqUHKKmAN/5F1LFQs3TsezTaNy?=
 =?us-ascii?Q?4jS2Pe5QUtT+TMeS3MZNb+ZOUtytTcdrUbI2ZmDrNEQ6dd7bRIuRcO9KY0KX?=
 =?us-ascii?Q?GHO6PGNE14v0v/Z1fret+QYpimSAx32YlclirCBiueWlzabj2tnpPQOQv7Ao?=
 =?us-ascii?Q?HoxuSs7UTFske759xTdOvl8teJjPUdcr+32Y2DHnG3uVhqM0vIpeCLqA4VGp?=
 =?us-ascii?Q?54soJMRBEr8at4L5JIFlADze35p6/OrRme4kbPC/dM9FdXGWCLIouL9J767b?=
 =?us-ascii?Q?+X63QW70dgeolQmwzw/42QfYYBG8XVA4l1qI93Jxhvwb5N6JPKoaRCcQPUKX?=
 =?us-ascii?Q?tsLnuNeJT1HYa6qtIFQ98i3AUHldo4DJ00PAPdxJ6rekGNy3159LrbDaIHB2?=
 =?us-ascii?Q?IXOEZTzBTTXtdb7jyZBZwhz2xIqknKRLlR9UIDR8btJNbg/n93XlTAZyJA/U?=
 =?us-ascii?Q?wbsTQsTljnqelqKF6I4iPFBTp1L80WUGBq9KNXbq0QZBkBgL/z0sCby+r3Gd?=
 =?us-ascii?Q?7MzysseZu4PMuc/BwiaxttJssCIAT4JghflJUv5VujhOK59n+e44JZ0OkEBW?=
 =?us-ascii?Q?BTI/MgS4KloCMZUY22kbUW/xqHQAMmez2yziewsGStaOHHUuEo5J9aYOUNTA?=
 =?us-ascii?Q?tJeoPxe6LomAI0byaU4nCYhpbXVTOJqOWWqhpCjC4XLHgyaRpbcW+S+lIYue?=
 =?us-ascii?Q?02xLCGqPx02ljLIUF0jx28zOs6LaSuD614GNs2Dvtv7Pxr7BN++IRTmq6uT3?=
 =?us-ascii?Q?+calqTx2TPb9zJQA2ec2xSUWFGSs9jDrkTm2fZX5Ukmg/y6tU3MAlOv0sKmT?=
 =?us-ascii?Q?C2m52RFRRILOXR5EIxPfAGgo5OAehuYfC8FGC9+Yt7iQxcR1oJFy7TzpvN0c?=
 =?us-ascii?Q?lh43bhOywHfyONmkRQMDNYagtVi3cqyBzArGnLTsIxM1nfl+n7HSNxZhHK9R?=
 =?us-ascii?Q?VjiEeo8Mz3CA8IOwPRLfZxpygtNUfTz+Ct1rOTQjx7bN5Whx1lVOgg5R15KQ?=
 =?us-ascii?Q?1njHFMgrzl5hHPVsEz3X+1C3IW8PqeOnVrdTEa+UXJsp87/SgMfdHptFoCKq?=
 =?us-ascii?Q?T2GB19LnVP9TcI4ks1LRiqbmZS1yXjweP2a7dUydDHFKckfH5wsiC/KUJGIi?=
 =?us-ascii?Q?8X2LIu7LO0/hkEq+aNbZgpJV7HRegvQN4YSbNG0PizSacIaS+05cFsZ7qyC1?=
 =?us-ascii?Q?03Ocqp/BO6PIcgPpnEZSjP8Hn3YDi1XJR9f2QXs/zOZir4hUxNZPqild+x1O?=
 =?us-ascii?Q?QqW4YYalj/ze3WZn8t2GWgdrtGGW9BPFNjts2JhYZn1V4IZHgifJKBhq4dcS?=
 =?us-ascii?Q?U+/lYMPa9qcU/ol+mIM5MTBRqCka2oNPSi9uPcHVshbL39Vi0BlLT0rhyuun?=
 =?us-ascii?Q?jvWtLOxLNmyOi84x+dsrmMlx8zy16C6caL4m2Z8g4h9DuT8k0UE4n4yO1wvm?=
 =?us-ascii?Q?WfJewzKBXio0gHnpRik=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068cca1b-2a4a-40d6-3ff5-08dd4d1a2227
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:59.6543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iugj33D6zIMGql/sHkazJ1SslFskRKbbRDMMDNKtwfVQ9t2zaZrWC/9xGqs1h3cW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

If x >= PAGE_SIZE then:

  1 << (get_order(x) + PAGE_SHIFT) == roundup_pow_two()

Inline this into the only caller, compute the size of the HW device table
in terms of 4K pages which matches the HW definition.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index fb3c3d17efc167..e3f4283ebbc201 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -245,14 +245,6 @@ static void init_translation_status(struct amd_iommu *iommu)
 		iommu->flags |= AMD_IOMMU_FLAG_TRANS_PRE_ENABLED;
 }
 
-static inline unsigned long tbl_size(int entry_size, int last_bdf)
-{
-	unsigned shift = PAGE_SHIFT +
-			 get_order((last_bdf + 1) * entry_size);
-
-	return 1UL << shift;
-}
-
 int amd_iommu_get_num_iommus(void)
 {
 	return amd_iommus_present;
@@ -1603,7 +1595,9 @@ static struct amd_iommu_pci_seg *__init alloc_pci_segment(u16 id,
 
 	pci_seg->last_bdf = last_bdf;
 	DUMP_printk("PCI segment : 0x%0x, last bdf : 0x%04x\n", id, last_bdf);
-	pci_seg->dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE, last_bdf);
+	pci_seg->dev_table_size =
+		max(roundup_pow_of_two((last_bdf + 1) * DEV_TABLE_ENTRY_SIZE),
+		    SZ_4K);
 
 	pci_seg->id = id;
 	init_llist_head(&pci_seg->dev_data_list);
-- 
2.43.0

