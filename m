Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562101862BB;
	Fri, 18 Oct 2024 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729271546; cv=fail; b=uCLs8X7APQ8zFAzCfF+OysEO7gTCTUB3I3Kly2KMVbRgkP6wj+8W1LikyhmyrbMHCjoeBAGs+Hk5q90wtp6/gM1s1gGLHLU/aG1PjQzKpstYch78wKT/wI6wM+ICUvgOq8IUP+cpirLZWFYUwv3nHvLafMDY50qAo7shPu8Nxek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729271546; c=relaxed/simple;
	bh=Q5TfYvSIuSVbPPNQwIKhjEkOilzRQJKHBDpJRtlHROI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=h0g5WXh+gYfpaAvhTRL2dYX26wzWCNUJr3VndEJ3+3e9+sZ7NNMy7Io9FT35twhLPTH0Sjis7rXXPjf+IM9HHeYUNA9cVRJ8lfv9I38Db5D6ZZhQafXb1MkUPUONa3F2uVfoIvlbMe+4ErFca7hDr0Ay1HyiSJ3gtQRnGgmhYx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RKXaytyc; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RKXaytyc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5/1lSJWt0F5EBO4WecMSCSqPKEqrXjVfIgpYX6/na4SBmMcgIhonQDh0W/RJIxDnzB2QFHtJ3Wa5nBMTt7PP/WO6xaOf9wMwSRkkiCJ7AmmLfueN48R3qGYQzpHCEuw2eNSHYXvdGlgvhKRiZzr1JEZ24c1p7/koE27SjeaoA5hUQf1m2swjBUfY8kHhuYuRGHLjBi8P7UxNZINHaUPlLBco8eqcvXOhO5UfHR/bir+sUxO27vNHcMadinnOl+H6PaqzZqIgM4aPcUgmcyHMmL9D3H9BD7ZEYaERyXTgFHGQwzactLGb/xp6NQECoSqw3tTrpX8XWiMSNQzSK/WWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SXbTUmANPQF8rQlM1elNp6Ka+O83Yv1xcw04YbBu+E=;
 b=aQ51/tRjEvRWkpgV/UX5DoLa+neUua1RF4o6htTUsLE0E+xYkX3jYeQZim1yiw9sAlq9MrT3sOsM/NXwKDtnTKmWltU7BmhrDVAoinzYEWhgOapcqxtg5YT/tKE3r+PzH0Wrwgx/Bfn8v3cJ2/I1mV83m9Osr/8zzRAiAtBZWY/NfbGHt6urKf9HyIQen6CDqAm0AwpkbfYvCTqRHTzu96lz3WrmOuqN42tVnrxX/OY6LepGTvR3QNs+85qtlqei5TwvWYcuoefR1if08IhXz6Jwx3RMMpLBcK1B6q1B2H/swjxO1hsV31PJr604JAD4EdDKECP9q0VKkHWWDX7haA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SXbTUmANPQF8rQlM1elNp6Ka+O83Yv1xcw04YbBu+E=;
 b=RKXaytycE3LYYmkf76JrgjibCYkuCjyjeaTcu/M5zn5nx/Cye19lvRAWvKDZ9zztYc7cBBRyXqxfLvLu6TVB1/72i0UojMCgWDCG/UJ52j0cCrF10hYOuzF2QAYqvqdzg0Qoc3IaRvEmMtf7YnvXV7lZRYIri2/OthM+2U8PUrOk9SQmp5DFSWJi3n15H3GTmNY2OoLzkN8fY8SzfGOf42BDyqnNBg1Ju4cW1cYgIziYXuYNiASP5ryIq/vReBh+Pzn2CmTNKdDUmo9Gzhdn2SU+HRJwpfuQdqICHiiMKlU9dIvZxQlhjhU9uk/YftafL4IxfrGH1eJcoY5OQCO/Fg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8479.namprd12.prod.outlook.com (2603:10b6:8:155::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.24; Fri, 18 Oct
 2024 17:12:20 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 17:12:20 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	patches@lists.linux.dev
Subject: [PATCH] iommu/amd: Fix corruption when mapping large pages from 0
Date: Fri, 18 Oct 2024 14:12:19 -0300
Message-ID: <0-v1-27ab08d646a1+29-amd_0map_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0010.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 38036ca2-c130-48ea-a033-08dcef98068f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3aUScHe6IRRdejTWEO9ENpr+kGWrAdmCAGMgg4G06FKVefvCzyQnXnJjPFnk?=
 =?us-ascii?Q?EaumNiwU27mF1m/E3VIO+5jtHZi0RyYQWQnjsiHPC+ULgLOrX32fcoPI5fFE?=
 =?us-ascii?Q?wartAYM2lecZjBRGf3eY14BB+zQl+ZYJppCQGPLtgGafcOcivqj9ritZWmn4?=
 =?us-ascii?Q?8AFmqh11PswQ0lfBAtVQZXpQmYLXDAJpdoQu87+rUQeixmFhXvMaFaQBaxlh?=
 =?us-ascii?Q?R8ERRNdqdx+y3iCUOnEp+7JLnAH7AtYJswAxY1PWtKQ/rJ+YIr3ABQ9b28/9?=
 =?us-ascii?Q?wRSOCN9q7oaj51vwtaSOXwM7uZ8H5ivP1dU8Wmb6gYo6i8KkPUnzoBFAwZ4v?=
 =?us-ascii?Q?GUb2iiQO3YQoUUINAR+Rz9NiyYFxyM+KCdyX7nj7W/9pxaO8KQmiFsE637l/?=
 =?us-ascii?Q?DlyDMRgCXmlRQ9fkQFgb/F3LELHYyqKumHiL1fdviXjonrzM59MPSpAXRT8f?=
 =?us-ascii?Q?/I1UA8hZhz93Bprs/Qd7ELvKlUMIL1M8mXD9PS93NLG6L3MRu5CSCDSfsONJ?=
 =?us-ascii?Q?/lyJqLAMKcotU44rxuR478MpcuibT/UI9Unlk0FQY03nlCtMHuBwlAKoTKyA?=
 =?us-ascii?Q?ISoTJpwjWj2v2+iOzpHMeaPKYDerVQSGVKnRXXPAEFTqhteFL2OIrkdA2ZC2?=
 =?us-ascii?Q?75ETvaN4U42pjmSdSrOmkxJsM+e88lFyNjnZMGCVI8twiclRGOdy4KWcPORY?=
 =?us-ascii?Q?RLdwXj2hNPRoNEFFGSKDgtcrUndy5Fg6ZHYRpfOdDafQn1fL22VXjhso0QC9?=
 =?us-ascii?Q?uR5H0wI1PlVkIEIIBLy50QFPJmWRjjfm0rAEF1mOKZHxCI8s2/ymV33T5bzX?=
 =?us-ascii?Q?+GO4S19Y9SBX331NgUVY9jvL0ibnk7zNMSfLRGx7amWlbJDoEuZyeBr9oPT8?=
 =?us-ascii?Q?Rvy2WbeLWCdMSxueNXAf5BBjazJv91ys84qSru+9DhvK96chiMkhsU0aX0Dd?=
 =?us-ascii?Q?RaKghxzjepR50pMsz0J2gVbMSVO2U5FX1jO/wG0lf73CZD3YJ6rXQ6VErnE2?=
 =?us-ascii?Q?h/CKGWWsdUnW2cgu84ywHVt3YrvFWjN1ATXvy6P2iIBECmdzcGNaycPJ2Xe/?=
 =?us-ascii?Q?+wAIaVRjIvNgUiKj/XYlkFUyoJl3tsyDptTYIYZQVyUAxrXTCKo1F1RnA0gW?=
 =?us-ascii?Q?CLmcEJRQo4y8e2fkvl/0VgRJZUarvHSJF7Cnx+WQqnnQHYCX7VEcSP3st2D8?=
 =?us-ascii?Q?fQGyFwSWz25zXLWSjoh/FBHLBGid45+BdJWrMSzEQvjnHQcogo6xQCy5MSQ5?=
 =?us-ascii?Q?ysxXHt5V5qApNqaSJ2VL5YEPoKkK4fo9tjdEn7XDMn8Zs24gvEBAUPNOUOxj?=
 =?us-ascii?Q?w5oB2DZ7/Qh1t720Ks8fVyq4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nFh+Sazu9afgdfQcw9C6Kc7nKuMof+W6vYj9dpse2fT07kqNEh+55ZbMeXO/?=
 =?us-ascii?Q?LbS1NXK3SdqVGyc5PzPUf/opEFxn9i1QWYMKfkydciTlPCGreVeCh+Lf1Q+V?=
 =?us-ascii?Q?gVb9DLbuoTAeaZnxjOcjYSleziULVg0UPEbuIRyhBUUI4pUl0wf+yfh4mIi5?=
 =?us-ascii?Q?MJ4UfmxEZKHg3m3gb34ogWtkxXcsfLqoOlv3dyog5FpgbYiupyKCxDcD8e+a?=
 =?us-ascii?Q?qrMOJJLul2y7N5je18OeaVZt6Qb9Ge3n74ypqtcGqqJExRQIsinQriQmPZmn?=
 =?us-ascii?Q?oM9yvjdRXhkWZZBuJiM/CPP9ZFONcRElzoO1ULcyowQjcvH2UffeGvCZrZXN?=
 =?us-ascii?Q?suZjVJcxRRDhVj0V7vDlm4fB1mvBNQ64gYJaOVSwsjKLrpZa10rru5tNU34Z?=
 =?us-ascii?Q?9gGyVIKKT3Vov/8vh3PsljzCusD3q+uU37olsiAj232zywO49t+B1Xuus5V4?=
 =?us-ascii?Q?uExUlQbwKnGdIhqqroFa4cODM+cxVHoFt3eZI36BfA4yVMFPiTOR/xEX2ukX?=
 =?us-ascii?Q?8m77aRfUSYeuWQhJgWKKIlAmUl/fmYG0x+CP08BjPtxEe6+iJmuTkL3S4sbV?=
 =?us-ascii?Q?+dHvp7mHU00F/z2PNkElbwQJu+4H6fwWfaQ5B+xK2JHNMU3EgwBkZZ1tT7Yz?=
 =?us-ascii?Q?YFsgk6qnuZeJ3WW997EHbfcAN25LSNwBgA/aAnoaZ2WxtIA9ogzmdvbCPtNu?=
 =?us-ascii?Q?9rLyo4dDAAPxK9D8EdtmKlkNg3/EspfExo16y0qqtsdcoo7DCPpXbcKkPaF5?=
 =?us-ascii?Q?bSyzwUeDq2gL7B1nkGT9Vm+qXcmH2uuA0vvwbv6SMn2SLPVhjJ5klIeM7pWB?=
 =?us-ascii?Q?Vx20yxDOfOoax53vouaPBwXnvbbwZLSKqXFLaCkySaf0fLdKozxA6U6zzxgk?=
 =?us-ascii?Q?CaPXAXujSedM6/RhNQwWfAOFXGul8MPKUGO8M4mP29LggkYatR67ZuacInaM?=
 =?us-ascii?Q?NXxNnfblLTDX/KOnepsNwBZ09sbldXKeML8GgofS90pPnR2nwzEqN4rhQ2x8?=
 =?us-ascii?Q?qdBDWAIHo9eu1vvMgPr6G1D4TJQkvBacYUV9fiz/lyMalRFkYl7zllFLKXE7?=
 =?us-ascii?Q?q8mt//56KUECFqhQHMN+0lWoV8todXkpqx5t7n77u178vs8BO+WDCNVUrPfu?=
 =?us-ascii?Q?R0tYzd7EzNyPucNQqPHuAbbMewd1ppM2jr99SCtXEaTL23dddZx5sNbgsEwn?=
 =?us-ascii?Q?cdjJFKVrLw5W7g50E5/FDarV7b3nmxPNlql7D7ib0lMWa67sRv63GfQZTf9+?=
 =?us-ascii?Q?ji7MR9YujcT4WUBJ6+wJwL83Z/iiw4mGxkS9OC2GFemnQ1/348PsrpnF24Zt?=
 =?us-ascii?Q?kLxxiB93k/bw7+BpFvLVWkXdcaebZsvuaMoQaMLinm+HQODMEU5qY/TApUn3?=
 =?us-ascii?Q?jK37f9omyPG1myADu4Hf7HfT5+7cA0EUP1FkiiEfnUJwoazpzzftySy16eq6?=
 =?us-ascii?Q?L2LhPr2eUB3wiqK6OqyClFjaD76OvH7itbbmH5DARhyVCSmNi5G0TfaFw9gM?=
 =?us-ascii?Q?DQhQ9dmYnz542E1oQzfgIah3woR3TFSF07cVEm0w/1XZW1JEr2S1PDc50r0U?=
 =?us-ascii?Q?jRY/uslQ940KFy5jQGbOw+ZSX633okP0Cr7Ip4Ou?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38036ca2-c130-48ea-a033-08dcef98068f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 17:12:20.5999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hcbAeyQGFTGtSveaSJC6VuKbHpjbm24nqTko83uNmbi5Sk/2MAKdiy0tZo0w3tet
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8479

If a page is mapped starting at 0 that is equal to or larger than can fit
in the current mode (number of table levels) it results in corrupting the
mapping as the following logic assumes the mode is correct for the page
size being requested.

There are two issues here, the check if the address fits within the table
uses the start address, it should use the last address to ensure that last
byte of the mapping fits within the current table mode.

The second is if the mapping is exactly the size of the full page table it
has to add another level to instead hold a single IOPTE for the large
size.

Since both corner cases require a 0 IOVA to be hit and doesn't start until
a page size of 2^48 it is unlikely to ever hit in a real system.

Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Found from more generic pt testing

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 804b788f3f167d..f3399087859fd1 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -118,6 +118,7 @@ static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
  */
 static bool increase_address_space(struct amd_io_pgtable *pgtable,
 				   unsigned long address,
+				   unsigned int page_size_level,
 				   gfp_t gfp)
 {
 	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
@@ -133,7 +134,8 @@ static bool increase_address_space(struct amd_io_pgtable *pgtable,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (address <= PM_LEVEL_SIZE(pgtable->mode))
+	if (address <= PM_LEVEL_SIZE(pgtable->mode) &&
+	    pgtable->mode - 1 >= page_size_level)
 		goto out;
 
 	ret = false;
@@ -163,18 +165,21 @@ static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 		      gfp_t gfp,
 		      bool *updated)
 {
+	unsigned long last_addr = address + (page_size - 1);
 	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
 	int level, end_lvl;
 	u64 *pte, *page;
 
 	BUG_ON(!is_power_of_2(page_size));
 
-	while (address > PM_LEVEL_SIZE(pgtable->mode)) {
+	while (last_addr > PM_LEVEL_SIZE(pgtable->mode) ||
+	       pgtable->mode - 1 < PAGE_SIZE_LEVEL(page_size)) {
 		/*
 		 * Return an error if there is no memory to update the
 		 * page-table.
 		 */
-		if (!increase_address_space(pgtable, address, gfp))
+		if (!increase_address_space(pgtable, last_addr,
+					    PAGE_SIZE_LEVEL(page_size), gfp))
 			return NULL;
 	}
 

base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.46.2

