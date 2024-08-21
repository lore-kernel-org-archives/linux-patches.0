Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1933E1B2EC5;
	Wed, 21 Aug 2024 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261855; cv=fail; b=XykbpK93kHvDwFAfidHv5iq4tHWtA85LDQU9AjL1krb7kH1vMgKvc8/fOhh26iQxwnNj2EwM4vVYsqkgzki2HV7GxogxN7SFUo4GEBSO+YXIfns3utPtnuT/TYF3k01K9zP3q3BA4OFdEd1mHt0IwTIogX8qFIcD4dNTkFcxI+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261855; c=relaxed/simple;
	bh=VoTeLMeipaFRN2wvXMJ7Nck2UW2a+19+Ukm1eAqZcCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tuRKwth0K7SlSNwqF8Tlti9BUvFpFW3zmxKDXQdBidhqeixK38KL+rsZbZNdI4XkZgoA3ARm85r9/FqIg4H2tw7+RJjjeuLoSzLiWiH/SRXnHxMgmJWmdQtHZNSDSbb/3XO58NTGXEKcv2UnhTNbZ9np77IsaCVvLsqTSio6TYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KVG4FQWV; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KVG4FQWV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nPBOphrtVT0lQdvcx9f5eoi6uFOxk8kuopmJQP7UhWDxpo3d9bp+n+aU2iIBXgJHeZfwFrThM9ykGysqQDTeDEUNmmcB6P2tXTpEmmrhhjmimhAVR/wtNQT2tS0awiZSZUFa2Ym9uma8SDL7LhRIoXSKxgH1yMdf5qiin48FzgpF54KrcU0DiPAAWrKb4oX6gTWKzAeBE4M3ozldEMnOUlaFyENcOWTtrkgG5NTIG3aGMIu3QhJxR6v4jtv12XRXYYVW1TFmIkng/I1ra0kOre3EKlqmJoLuUmtkPULXoC27Di6fMDRbpCbVYIKCbXJjLjjLRXtUTRE+UIzZauw6iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svwQVvAI1rMoovCjruQtnpYhqH4Cu7GVZ2qt5/s4bs4=;
 b=VbnGQs61dVmDtG7mwA/BYStpvaFDh+A2/urnDXTTQiM26GXhimUx5XvFJp8RcLnCjN4dNoU9CsrqpKycfsoYBLFv4V8fVyOtoTJj/09w9AaiAVrEeMd1nt1hXXFK0LXnTArC6Uqnat1+r3J9bBiZECTrn5/1dSu2OiFQoJ6TvEAl53dURwuxOP23l1ipBQNE3W1EPY1vtCOFRwmtEwPLy8zI3SVkhx7BMsZXkjcmWwo5k7OQy5VJUfVAO8vPGxfCBxvp4M/Cpcb/Ko6eMeyqdzhretSl6r/8kU7X8+7MgRxPJ6K9RocaB4EthqSAOxUvRaNdT1ozTxLWJSGI5T2Wog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svwQVvAI1rMoovCjruQtnpYhqH4Cu7GVZ2qt5/s4bs4=;
 b=KVG4FQWVFubjjd5BYlLoBybwKO83NiZHDp/LZ78+unOVImMiKiudEbz+3CCpvAJMwyjANHJq2KuBcrvkj09dVqa+zdP62wjQbe0+GyODewu/a/3Ok/J0IzvQn1kNbXdeYByiI82VdGP7LICE8Re3vbuvQbKLnXOgMWdxSXs4cri0cA2PoOhggsUyXwGNCixA3cO0t6zqpWK4Qo0dVLBBuEvrkSa9NiQ2/WIq9byIiUWILFdYTDLNMU5Nazm9UWmgroGwHc24m7msx4yhjiYv07YiBHj8iVrv40LJZMHYEl5Hy9ZFI1NqS9oRWavKf28tzby8uPoS3xj0HPbKsDNVrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:21 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:21 +0000
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
Subject: [PATCH 09/14] iommu/amd: Narrow the use of struct protection_domain to invalidation
Date: Wed, 21 Aug 2024 14:37:15 -0300
Message-ID: <9-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0023.namprd22.prod.outlook.com
 (2603:10b6:208:238::28) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: 8504d97d-b1dd-475d-ab1b-08dcc207e941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wPFLusHYKS7LmunGAWgvDqqdU8qgU+gzZ2V9atghXr2t9VyKFb5V4YMZvc+n?=
 =?us-ascii?Q?uqJa/P3yD+31GNpxA2R41R2BuiTPrf5cTtxCs6OjQp5GxdeMCWRdtW0ConTv?=
 =?us-ascii?Q?AXYZL9QWEnJcn2dIvfu98c24n2eP91VfoXLhTzzo6BsUJXY07mZ+AvsDBQ65?=
 =?us-ascii?Q?JtKmK95MFEJJW4wYZKLpv0g0UAXX7aMBLyRcXqKO7YrJIkxZdxLzWSnGs402?=
 =?us-ascii?Q?Z3iWHSjEdZO3hQ1uABws0sBtp7PPe3kiJYOt2x2pn7YbO2ysdXs2wud3EPHq?=
 =?us-ascii?Q?i45pMMT85ZB6XMZsNRd6udetITZjHKI8kT1UsFlBGKLMx8DMOhc21omAiAxp?=
 =?us-ascii?Q?CdlC8ExWdEXm+MKa/h12eubM6mYtyQXH0BXEI9gZsfy3Ffb7NKLqnna9hfUA?=
 =?us-ascii?Q?kKgbzyhrQKM0mz8dYqhxVC/kAm6682/3IH1RhB2ZYJk884PlE4YRZsvmn8bF?=
 =?us-ascii?Q?LnA/uBP5hr6Ga1qQ+7aohLFIQ5KnEae4onwTvo8ehG4uq/KW25PBEk7d7hE4?=
 =?us-ascii?Q?oCtQMYOe8oabUYQT8t4PgRU0ORf5H9OZa8ucIJH/dztig71wPnF687OVE8JJ?=
 =?us-ascii?Q?byoc1MZhoufZwiArw2X7mtGxJAGJWMc2OoOKUKTL47NA6bwDhl5Pw+RN5KL1?=
 =?us-ascii?Q?AqxqeCeda2xccxH6wfGvVXWr4XevH53dojg4ijws/zCdWbqrVVqwv6bFxHXV?=
 =?us-ascii?Q?ZnCRLTQktGC0rIvdXmo6O8CU4WBlsVIpTtxtUQ42XDKyKt1D09P4LeK1w57G?=
 =?us-ascii?Q?nMeJpkOKo27fvvM2Wn3lfjEUrvsjLwUZgMCCUkXvMtZXMHOOhO7tQs/vvJK0?=
 =?us-ascii?Q?Fa+3IoDpoTxK4rr/rfoXClJz0T4G/w1B8Ro+5sZ5QKo37jgfG0E1gGJ10bl3?=
 =?us-ascii?Q?GmDi0ffRf0XCSqbDJOOK0NDG8ZRGylHcXwe1plOJVeicdayZ/tZHD83kUck1?=
 =?us-ascii?Q?Gvxg62/hJxjQErJmy0/UnhHyVrCCBFCIVa01tEXdZMYIACC7FUkXybWL6ZWh?=
 =?us-ascii?Q?Z0s+oFJYaNsDxI0sXzFfsbcDTAHBGp3aw2KhQ8O1vMzpEobUr2Wb3wqucVfm?=
 =?us-ascii?Q?SsZQD4/7KkJ7lMpU0zM1/wOKFhiVQH0Xt/gmbQZUMsum2S0B2XkrGGEiaFuX?=
 =?us-ascii?Q?sFWvhkpmIay+JtIHeqobJdLGLIMr1D9bm1zhM3Sp8nfd37M0J6WoEScPO/rK?=
 =?us-ascii?Q?NDeK1jnTgtfOAlBeOSMy+IBFuSUn9cABgVHRjuqnbv1rkeG+99G7c6scGPWf?=
 =?us-ascii?Q?AErXZsYS50hE5bV/lra2rkAX8P54XlbtSdUo0DwP55zwaX9FvNp1AFBosGYv?=
 =?us-ascii?Q?WcudwH0wZbwtnbc8NkUy34sBXeoCxhLFnn6VnN9SrFXttg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cdp8V3EGBD6xqdzRYKf+fKMtwVa8LCojHJBlBDNYi8Z+zOFgzknxvIg9CpMN?=
 =?us-ascii?Q?aDBkAN4QaSyCLSQhLB78Us9RH76qtSpoB/ffiLyyBJ4SMqyTuto/KkhQRbTd?=
 =?us-ascii?Q?ZU9REgnmajiMUzxB7ETqTg6dBc+y4b4mEgwjoli8wnZlXopokyeS224s6+26?=
 =?us-ascii?Q?cgZAGkiGFgpKEMQNHA0ekPIt6TOl7fp7FKDTdSf527Ig+xLpdgvsL1JGYerL?=
 =?us-ascii?Q?+4l4RSK7bLdlhRH46jj6O026AqAn5GYxN4ztwxsjQ8rqZzBGacCyYZSR7UnA?=
 =?us-ascii?Q?LesinVIJeO5XTrLOa/PNTpJ2pKhEngFIsoys5NXgLdTr5TViXNnTFYstRwNx?=
 =?us-ascii?Q?ROvWdsF8jgb5V2CKjCc4cAxq46IIywp0Lp5OXpQPFRY2NEhAheO32fLbKWzu?=
 =?us-ascii?Q?gBvvAp5e1fJbzxthL82+Gh4DvvJaPuurUsAgJHWMli779wAoV22vBoFi3Ovc?=
 =?us-ascii?Q?pS6E69AIoAS1ZqQhqnSNMHakEDnGNR1b2CPTndIrkTskmY1zWTPNbxYg337A?=
 =?us-ascii?Q?sSO+/ubUJfWwsE27NyJEqpzPPSZNJ15NEQWPElWoYkQjHby4Vz6kyZSrEahn?=
 =?us-ascii?Q?c0j6Pd2F9IDdvKb/oElRAA7heUhn+CZE54s0IKBVv0UcoDPwDMCw7E5F44Je?=
 =?us-ascii?Q?0qbc5fDT6v2vSBEe0GrpJJdnh/iKlOBn9DsH/SAMI+src9YJ0DuwDdFVXkaw?=
 =?us-ascii?Q?83BH4mLtjY5RVFPzCIfC8TIQUtpsAY1BJUO6nuWroQgHBz28azgk+d8TkV80?=
 =?us-ascii?Q?gKLdd8TahuKmWdDk76pUBu10c9BdueWMyur0ZEnkx0aieii6UhoxhzVwqzCL?=
 =?us-ascii?Q?eXLV6BGp3HfZ2BMxMSWc0S5xxL2wc/iOLiXwfHxrVS3JpdXyGYRV4Kssuy/D?=
 =?us-ascii?Q?XBwniX1OeJV5xydGdsi77t+hrF1czBIrdLm+7fzOUbJMKv7zZ3x4pA7aVhJ2?=
 =?us-ascii?Q?wqo1HLkHYc4LFsNZxNmOzz2hoqiO7M4hBMPYBMeSkAIklViZCCRx8LnMTPOk?=
 =?us-ascii?Q?Pq8kYhrLf8i/RUkwd52unEhqseOMdfgBdeVvUBuacEwswCQaFdRfeJ0HYG+R?=
 =?us-ascii?Q?8opBJoNhtOFz7Kr+fg5rpewJNs4UTDHY/Q6yK1d4zA7d3WUy8UBgk8GqwJck?=
 =?us-ascii?Q?rH0VsD3SFOxFgZdlI5LfFERy7kgORnzvjcvOJhb4dchkpICRn/5Pqpmt6rOY?=
 =?us-ascii?Q?HPa+ZFS7tiKz0DjZujtyCj2XUjmOAM49nwjjk7WDw8cUch976sXfT0Gq3Vyz?=
 =?us-ascii?Q?fCbkYSPmzEt8HxMFY1VqdL78SmdTjPk+wmT7YZ7e2fUSlxft0+T4jlDYqs9J?=
 =?us-ascii?Q?/1a3W/9yRzB2/w85MxYOw9bxKvBsJUTnhNL/WmZbVE1gcG+IZCJSgyguk+ZX?=
 =?us-ascii?Q?5oNHTSyP0E4zg3FXuxBTz3p12VxckuUZ/TMiwUU++oTaYKtIzBq319CwX3ry?=
 =?us-ascii?Q?5bZt1OcJszi4Pn7EKHKC2dLXaupw7B1HEPvcdDCkTsnCbG3Whrh9olY/ORRm?=
 =?us-ascii?Q?Iqz4kCWdTUaf1VB7LhtdtxRaUl4LxofMCmj3kncKdwL3BBbdTLzfRcCOWFJ5?=
 =?us-ascii?Q?m3LzKLUEVL2Ln2lcl1WgyNiw/BFpKlpy54mSqgog?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8504d97d-b1dd-475d-ab1b-08dcc207e941
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:21.4910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nh2cGzwsDNN8CW9iWlImj7/fKg8GhCKEt74O3HI0zGR4QU55p4Cb78/mK6fvuxG4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

The AMD io_pgtable stuff doesn't implement the tlb ops callbacks, instead
it invokes the invalidation ops directly on the struct protection_domain.

Narrow the use of struct protection_domain to only those few code paths.
Make everything properly use struct amd_io_pgtable, which is the correct
modular type for this module.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c    | 35 +++++++++++++++++--------------
 drivers/iommu/amd/io_pgtable_v2.c | 11 ++++++----
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index d56be842c0b71e..cb8f23e878028a 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -137,31 +137,33 @@ static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
  * another level increases the size of the address space by 9 bits to a size up
  * to 64 bits.
  */
-static bool increase_address_space(struct protection_domain *domain,
+static bool increase_address_space(struct amd_io_pgtable *pgtable,
 				   unsigned long address,
 				   gfp_t gfp)
 {
+	struct protection_domain *domain =
+		container_of(pgtable, struct protection_domain, iop);
 	unsigned long flags;
 	bool ret = true;
 	u64 *pte;
 
-	pte = iommu_alloc_page_node(domain->iop.pgtbl.cfg.amd.nid, gfp);
+	pte = iommu_alloc_page_node(pgtable->pgtbl.cfg.amd.nid, gfp);
 	if (!pte)
 		return false;
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (address <= PM_LEVEL_SIZE(domain->iop.mode))
+	if (address <= PM_LEVEL_SIZE(pgtable->mode))
 		goto out;
 
 	ret = false;
-	if (WARN_ON_ONCE(domain->iop.mode == PAGE_MODE_6_LEVEL))
+	if (WARN_ON_ONCE(pgtable->mode == PAGE_MODE_6_LEVEL))
 		goto out;
 
-	*pte = PM_LEVEL_PDE(domain->iop.mode, iommu_virt_to_phys(domain->iop.root));
+	*pte = PM_LEVEL_PDE(pgtable->mode, iommu_virt_to_phys(pgtable->root));
 
-	domain->iop.root  = pte;
-	domain->iop.mode += 1;
+	pgtable->root  = pte;
+	pgtable->mode += 1;
 	amd_iommu_update_and_flush_device_table(domain);
 	amd_iommu_domain_flush_complete(domain);
 
@@ -175,7 +177,7 @@ static bool increase_address_space(struct protection_domain *domain,
 	return ret;
 }
 
-static u64 *alloc_pte(struct protection_domain *domain,
+static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 		      unsigned long address,
 		      unsigned long page_size,
 		      u64 **pte_page,
@@ -187,18 +189,18 @@ static u64 *alloc_pte(struct protection_domain *domain,
 
 	BUG_ON(!is_power_of_2(page_size));
 
-	while (address > PM_LEVEL_SIZE(domain->iop.mode)) {
+	while (address > PM_LEVEL_SIZE(pgtable->mode)) {
 		/*
 		 * Return an error if there is no memory to update the
 		 * page-table.
 		 */
-		if (!increase_address_space(domain, address, gfp))
+		if (!increase_address_space(pgtable, address, gfp))
 			return NULL;
 	}
 
 
-	level   = domain->iop.mode - 1;
-	pte     = &domain->iop.root[PM_LEVEL_INDEX(level, address)];
+	level   = pgtable->mode - 1;
+	pte     = &pgtable->root[PM_LEVEL_INDEX(level, address)];
 	address = PAGE_SIZE_ALIGN(address, page_size);
 	end_lvl = PAGE_SIZE_LEVEL(page_size);
 
@@ -233,8 +235,8 @@ static u64 *alloc_pte(struct protection_domain *domain,
 
 		if (!IOMMU_PTE_PRESENT(__pte) ||
 		    pte_level == PAGE_MODE_NONE) {
-			page = iommu_alloc_page_node(
-				domain->iop.pgtbl.cfg.amd.nid, gfp);
+			page = iommu_alloc_page_node(pgtable->pgtbl.cfg.amd.nid,
+						     gfp);
 
 			if (!page)
 				return NULL;
@@ -348,7 +350,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
-	struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
+	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
 	LIST_HEAD(freelist);
 	bool updated = false;
 	u64 __pte, *pte;
@@ -365,7 +367,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	while (pgcount > 0) {
 		count = PAGE_SIZE_PTE_COUNT(pgsize);
-		pte   = alloc_pte(dom, iova, pgsize, NULL, gfp, &updated);
+		pte   = alloc_pte(pgtable, iova, pgsize, NULL, gfp, &updated);
 
 		ret = -ENOMEM;
 		if (!pte)
@@ -402,6 +404,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 out:
 	if (updated) {
+		struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
 		unsigned long flags;
 
 		spin_lock_irqsave(&dom->lock, flags);
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 1e3be8c5312b87..ed2c1faae6d580 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -233,8 +233,8 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
-	struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
-	struct io_pgtable_cfg *cfg = &pdom->iop.pgtbl.cfg;
+	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
+	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
 	u64 *pte;
 	unsigned long map_size;
 	unsigned long mapped_size = 0;
@@ -251,7 +251,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	while (mapped_size < size) {
 		map_size = get_alloc_page_size(pgsize);
-		pte = v2_alloc_pte(cfg->amd.nid, pdom->iop.pgd,
+		pte = v2_alloc_pte(cfg->amd.nid, pgtable->pgd,
 				   iova, map_size, gfp, &updated);
 		if (!pte) {
 			ret = -EINVAL;
@@ -266,8 +266,11 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 	}
 
 out:
-	if (updated)
+	if (updated) {
+		struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
+
 		amd_iommu_domain_flush_pages(pdom, o_iova, size);
+	}
 
 	if (mapped)
 		*mapped += mapped_size;
-- 
2.46.0

