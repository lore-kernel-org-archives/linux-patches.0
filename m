Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCFC1D2F67;
	Fri,  6 Sep 2024 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637698; cv=fail; b=qGDNYlkeA+YjvSAZ/N2tpFcPfF3MwYJglRJGXUBOQdy4k3e4NqrjHFIxP+jC1FYO8D+FdP+didLZsmvFuMMOuz2K6ohLwjFtwcZMR1uZb0koNeEJbrHzN2IwK9Me0UJZ1Ti1v2L06vO2ebi+GPw9mPDnQmyTh8mYz5ZKhVUD/QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637698; c=relaxed/simple;
	bh=vRC6qsJgTSCq7L5qW9WI1Ht9UlFHY70yQE27mZeXHOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s9ZipXJ84yHw62IUalJFS1RL5OpvZkL09IuXJ9EBpNY9ECjlEb2j1RQe4To8W6RChPE1EHsJYJ5g85n/H6R/1DehE5BgWKJEMDdcQ2ZbyALzj/uok8ApTnpeTiuDVlySPUUDGMyIpsPw62tFRZSUDEoT/8rUObSntUZpVLm+lOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tg8ZM871; arc=fail smtp.client-ip=40.107.244.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tg8ZM871"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhAv9CKKWYgKGc846kjefHK6awZUEX0BP3eIDXH8k4UQEc3hnr+Of/Six4Iu0t+09DDsc8f1kGgwPmBzsfYD3UAlDChJkLvKgvJEVD5FRHrEe3kjt3TsMy/eRUkf+srlBwZ2yKxOETr4I2s5fRKcrvutr9a273JOLWr9inNNGfRDeuOHynRLMAEjbkM9lTB5la1HF9hleeUkIGON0lWRpJVUDbT/R9V7aiVbmRRhyZ6SWoOTCh9ICa0wtCsRfMi7IhdJwO8Hbb/HfeJcfjGkaCVgQtsxlIJigKeEQJXnnEs9TxSecL4K27MgyK+usn5mhYgcIHrg2liPx5UzMM5NFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P316tRtlrOLdt5HtyClAs/IN4iJX9Drf7TO6fbVmHAw=;
 b=QT41/i9KKcuKd5FBtLMJh5UXsY1ff9FqQE48THdzWceBuy5OdgNbBR6DRKOiwn2oH1+R+ykMNz1vAdoi26s8YhpBKLMZ6DcKhxVP8cnD5yGwGGJNfs+HOezPlfvW0yUxJUyqXJXGwsQGysjPdJH3oqHlZ/G18yvZqu+/hDem2N0UeZK38UOysOTIhHi54V0JK3KwlnksekahldeWxpWNxBWyiCcmbEVKqnBWYdMGdKH0OYokEPvJZyyC0pGz3deBRagedLg4wrqql8ZARkxMlkf2DGTPq18Hip2kc2+VSZKPiO+pkejGqy20hRcADQhsJER8TvsJh74NmisjZuptDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P316tRtlrOLdt5HtyClAs/IN4iJX9Drf7TO6fbVmHAw=;
 b=Tg8ZM871qZl88PS2CRWPOZ5oWRmN3VYV7AkwH4LrJ2CYGsc0TIv5v80uhrsVY720YxwdcqwPX4ibW1k4+IW8Obdus+qWJArIF0/8QB2GQCOkI0/VwcWWTonEqfb7AFPEGbj8NHUJr5kyz50V0WVsD8O1mHAXp6hFHFfBHvHllYuuMvSP1TrCdZom6uPNM2ruDoPVnh4yOQWBc3PxqHfFn9lpPTe9lk9MOCXTioADAshNo4khYYFXRsmpSKUHSlLcXmBrhTJMzTCn/iVQHdXFMeZevU2yjnm4+YIaAoFRIwSu+aae1xU/CP0dJsk3nhZ2CBE+TZjSzqs0SQ5ulm4aTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 15:48:06 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:48:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 8/8] iommu/arm-smmu-v3: Reorganize struct arm_smmu_ctx_desc_cfg
Date: Fri,  6 Sep 2024 12:47:55 -0300
Message-ID: <8-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:208:134::28) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: 07f4532b-353c-4386-b019-08dcce8b479d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8f9mdo9030G/186NcaHd7P11EsnnfAqitYknNEFZSwxxpiBMU+mBh4/mOzl8?=
 =?us-ascii?Q?9KdpeoeqPNSiIjLbSGN/lH1iH0OO2BxJl5ZOPogxiQqJKvYvFGIPEBVKYBye?=
 =?us-ascii?Q?oFUsUZLhTHx4wOVgVmbLvgLO3lJPmfbjG4mjeiSUk4klHeSJe160N8idQcQz?=
 =?us-ascii?Q?4/eNGaq7poHrlepaxByEcVInz0cNt0QzdDbe+gcUKbZOJVmNfCHcGCFdOWO4?=
 =?us-ascii?Q?1MoxNsaZdVQrI3SEWVuNDEiw4z2LzvAb/VVMUhRQFizq1ESU++yYmYbNPYrq?=
 =?us-ascii?Q?SpI9CR/36x/diPjrY7TPZuwZVNCwznpVwM4NvHibyNA0I91xzqKW7ASC1Qg+?=
 =?us-ascii?Q?fRT8pSvd7xyzOOlqXqYae36nsUkBzCZ1mavGJsLXHG3GesksyPnfpuvxo1pv?=
 =?us-ascii?Q?POF9Ff8Cu7wKVvCbb+uO96YP4S/vglwCP14c6QbYoxKmUHqur9vE8Xj7Guxl?=
 =?us-ascii?Q?nGYkdfuTeR+mAaKjXFX6r6N6IxfGsksB4YMdGIdWBkCFUBwhMwvSa87AYn5q?=
 =?us-ascii?Q?vk0N/AhgKTwncfJ/gWvZijs8JykxTlwke9BWAX26A9t7Pe6tV9VBBU+lE8z3?=
 =?us-ascii?Q?7wO6fdq0JYi40U217MkdfRUXgKTfL3Q9BGLIRdX+mIVdAM5m75hx3mzQf9I1?=
 =?us-ascii?Q?/3pJQSGfiGk5cUV7E7fHucOtqMv89SQGyAz2Q12CYQ25Dn5/g6gQ539xbZkG?=
 =?us-ascii?Q?FGuXxZHR4dxCFi/GFJ0WSUCU685H7cvNYUkwmKgmgkBZ2HEJ2VZyV/2Wrhom?=
 =?us-ascii?Q?r+HiO/P0tIhcxJBzdyXFGshPurOodki+9dMJHkihxQAVveuR5XCXkBwSQIYK?=
 =?us-ascii?Q?zuqx7v8fRmuJXOk7JgiBNjYoCKDyTVl1WJTXCwDulLW7F20pRjK4Xvmm+/vm?=
 =?us-ascii?Q?T2TlYWhf0ggcxPQ8LWzdgG67a7mkP1ZdetNPd/OCQmINO3/6Py2qJ8JHmV71?=
 =?us-ascii?Q?yP5dZ4gA2w/fLgSnViDoYI0OfrL70o1YndKf3k660wqgtWZHTvv0v8mSENJY?=
 =?us-ascii?Q?ULt7ZLXIP1+HN6fOgvp9L/saI4T1IOEeUBGJEFcAgLwtNjditXqaNsMOIYwn?=
 =?us-ascii?Q?u+xFKrAcJkxslpbeR4G1VVUXidGMLcnEHQOGSKWFs8FDX8Ynq1f3hMpVUe2D?=
 =?us-ascii?Q?WmTJwn1wzFRlAT5YuS+qlk76Yke/RqKAfcYllsGShUuYpbW4mtfZvLqzi3nO?=
 =?us-ascii?Q?ixnPitbQhI65WVPsDjQnHrG/idHSM5OjPfcqjpLF0o5q7E9nMWAWok8/pQBB?=
 =?us-ascii?Q?gRMexpsPDZO5KT1wxdSeJ8BL4vRKXTg2+B3OJmPXfysj4fX6q3CXB+VZA55Y?=
 =?us-ascii?Q?vH01g4X/shtcZhHMpXz2OBDXi0OZdPZH0LVSY1y5EI7yFw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SjIVgZaq6uRu5FCfJ6SOz+EnEs44lMmtrNzKKoyJodnPV2TmXwKd0bQxGE1a?=
 =?us-ascii?Q?lCZePlS90ir+tn2iHv2FrveXANwLWbI0VT5azY+qdAS6kAismbD6VsEVkp7k?=
 =?us-ascii?Q?k7FxG1VYy692YBFldn53aw5ay1DOSd/WnFB0lwz9nyDzN9tw+1J334y/si6c?=
 =?us-ascii?Q?IdHsJOBabTdsbT9NsjlIc/0h2q+45rt5k1LdXUIuSOTOomR2bEXbu4Vcccvj?=
 =?us-ascii?Q?ZtvHF/Itzzgv+NAQQk8qwptTp7HYIu6m3RdqTxE2Y2zP3gS4PBT4nCrybFc2?=
 =?us-ascii?Q?pXpjtU5hlrsffNAqVi10Ukwq9y+dP9Y0qKo0z95TgDQKHf4aZpPyuBzKdZS5?=
 =?us-ascii?Q?Bm7+Kwv/m64wHudnoWO+gErfXXvaEgHm3AYpuTlz/PMFk8dgHoSBbJAUdzV9?=
 =?us-ascii?Q?j8Ei1Q1ydOz8bLDcMn08iI/oOzloS8WNVGlbMij0Hwu0EyuV0jezRl9YdlCy?=
 =?us-ascii?Q?hDzptzoZjcAmGjJ4D023PBePwECxoeeHHpg4WbRL8UTQbJs3FY5hWO/BcNJJ?=
 =?us-ascii?Q?Hbr1LjIGmW4NonEfBb3NJhTHH6UjbtcwsyMqVCL6e2JqWjLTc886GJS2jpnS?=
 =?us-ascii?Q?wmK7tfgZUrBBIQkL70R+rY7QUcjmgDX0qC6o+1pORHlRpDmsxPi9CCxEjzBS?=
 =?us-ascii?Q?pgpQq8foTJj3sZC8TpOhYaszZXhxJBoWLXerUSwzQc5zn77jO90UT8c9yx95?=
 =?us-ascii?Q?7xGWNBMfKP3mot8g2Aukx2ffuLCOmrO09TLs0FbLCuR6QtHEHb65HipuAvLd?=
 =?us-ascii?Q?oOa6muYk1amtXiTeOOgxqOZrqPIUhEXFwwePxrfB6+3MFF4T1yASiN/pH2bP?=
 =?us-ascii?Q?wjaWclwTXnchHxuEOE0kxk3p9xL/bNN4w+7IpWO/MMS3AElCWIO7DRb8XJBG?=
 =?us-ascii?Q?VFdDTIPnNVN+6/OnaQLcHm2ki2eDj7BMiaEnUK0LA9mbPQ1XHKlC37Evi8Pb?=
 =?us-ascii?Q?0eS6a/JGJojU1YoHFQw689XxtaU2/M3cYaySeOKADVQJ4XOOgXB7Z7NsEw2m?=
 =?us-ascii?Q?QqALq8S4PrHuZff5djy2crQWbbHMlgb2AbySgTMEekZFiwY2pAiEfcYSqHtm?=
 =?us-ascii?Q?58EkTSzOzTjP6AUx5zCIwGFUqVuiUyCaH5uJPmrFkf06Q7PDXret6Fr0YsJS?=
 =?us-ascii?Q?0RFVZiizFAdhzzOfsQxxxY6K+PKf4cVeX3CYdJWip8YqVYQjj4x5HgaYHz87?=
 =?us-ascii?Q?3LKuSEI534OeIyJERBxILL/h61VlDoPF3O5pY9WQFQ79MaYDikBXPdMLlt86?=
 =?us-ascii?Q?ahHunKo8/MY4HOqx5QDBzd9W42InVWC/JOrPllghCG2WKWRtBk333OLXx+yt?=
 =?us-ascii?Q?qnpYBVCTgGqgS/WOsCUw/Qu1FTx9R/w+mKq5gPQ7jIfytlm3tldFeX3IIfjQ?=
 =?us-ascii?Q?kYT0PW8lGckGvfhNzSzwHD5TS9BI93sxgAKdawgy8lb7QfkPpWcraVKMEyF8?=
 =?us-ascii?Q?IPJn/8+ncOIcshu7px/kij9K7UgD4zzNpmsQWdot/ApajSZOJcpSHT0ah4P5?=
 =?us-ascii?Q?8124JaaBBR6vfKbYyBa0riPHwNP8EYk7P94mceD5sl9R3+/bVivqoAm1gAfr?=
 =?us-ascii?Q?Nf6u/ZaYLtnSzRgCq+sc/GfGo6GD2+J6P+nnfmtd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f4532b-353c-4386-b019-08dcce8b479d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:47:57.8953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rDa23uBxklvtz6WCB8gQE501C95Itpid+91y1Qej2zXGTZEQ+xEBIPu2O+4lLp+n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

The members here are being used for both the linear and the 2 level case,
with the meaning of each item slightly different in the two cases.

Split it into a clean union where both cases have their own struct with
their own logical names and correct types.

Adjust all the users to detect linear/2lvl and use the right sub structure
and types consistently.

Remove CTXDESC_CD_DWORDS by changing the last places to use
sizeof(struct arm_smmu_cd).

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 115 ++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  24 ++--
 2 files changed, 72 insertions(+), 67 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 534a2141445647..edc625ec261dd1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1234,19 +1234,19 @@ static dma_addr_t arm_smmu_cd_l1_get_desc(const struct arm_smmu_cdtab_l1 *src)
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid)
 {
-	struct arm_smmu_l1_ctx_desc *l1_desc;
+	struct arm_smmu_cdtab_l2 *l2;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	if (!cd_table->cdtab)
+	if (!arm_smmu_cdtab_allocated(cd_table))
 		return NULL;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return &((struct arm_smmu_cd *)cd_table->cdtab)[ssid];
+		return &cd_table->linear.table[ssid];
 
-	l1_desc = &cd_table->l1_desc[arm_smmu_cdtab_l1_idx(ssid)];
-	if (!l1_desc->l2ptr)
+	l2 = cd_table->l2.l2ptrs[arm_smmu_cdtab_l1_idx(ssid)];
+	if (!l2)
 		return NULL;
-	return &l1_desc->l2ptr->cds[arm_smmu_cdtab_l2_idx(ssid)];
+	return &l2->cds[arm_smmu_cdtab_l2_idx(ssid)];
 }
 
 static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
@@ -1258,30 +1258,25 @@ static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 	might_sleep();
 	iommu_group_mutex_assert(master->dev);
 
-	if (!cd_table->cdtab) {
+	if (!arm_smmu_cdtab_allocated(cd_table)) {
 		if (arm_smmu_alloc_cd_tables(master))
 			return NULL;
 	}
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
 		unsigned int idx = arm_smmu_cdtab_l1_idx(ssid);
-		struct arm_smmu_l1_ctx_desc *l1_desc;
+		struct arm_smmu_cdtab_l2 **l2ptr = &cd_table->l2.l2ptrs[idx];
 
-		l1_desc = &cd_table->l1_desc[idx];
-		if (!l1_desc->l2ptr) {
-			struct arm_smmu_cdtab_l1 *dst;
+		if (!*l2ptr) {
 			dma_addr_t l2ptr_dma;
-			size_t size;
 
-			size = CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd);
-			l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
-							    &l2ptr_dma,
-							    GFP_KERNEL);
-			if (!l1_desc->l2ptr)
+			*l2ptr = dma_alloc_coherent(smmu->dev, sizeof(**l2ptr),
+						    &l2ptr_dma, GFP_KERNEL);
+			if (!*l2ptr)
 				return NULL;
 
-			dst = &((struct arm_smmu_cdtab_l1 *)cd_table->cdtab)[idx];
-			arm_smmu_write_cd_l1_desc(dst, l2ptr_dma);
+			arm_smmu_write_cd_l1_desc(&cd_table->l2.l1tab[idx],
+						  l2ptr_dma);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
 		}
@@ -1401,7 +1396,7 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 	struct arm_smmu_cd target = {};
 	struct arm_smmu_cd *cdptr;
 
-	if (!master->cd_table.cdtab)
+	if (!arm_smmu_cdtab_allocated(&master->cd_table))
 		return;
 	cdptr = arm_smmu_get_cd_ptr(master, ssid);
 	if (WARN_ON(!cdptr))
@@ -1423,70 +1418,70 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 	if (!(smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB) ||
 	    max_contexts <= CTXDESC_L2_ENTRIES) {
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
-		cd_table->num_l1_ents = max_contexts;
+		cd_table->linear.num_ents = max_contexts;
 
-		l1size = max_contexts * sizeof(struct arm_smmu_cd);
+		l1size = max_contexts * sizeof(struct arm_smmu_cd),
+		cd_table->linear.table = dma_alloc_coherent(smmu->dev, l1size,
+							    &cd_table->cdtab_dma,
+							    GFP_KERNEL);
+		if (!cd_table->linear.table)
+			return -ENOMEM;
 	} else {
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_64K_L2;
-		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
-						  CTXDESC_L2_ENTRIES);
+		cd_table->l2.num_l1_ents =
+			DIV_ROUND_UP(max_contexts, CTXDESC_L2_ENTRIES);
 
-		cd_table->l1_desc = kcalloc(cd_table->num_l1_ents,
-					    sizeof(*cd_table->l1_desc),
-					    GFP_KERNEL);
-		if (!cd_table->l1_desc)
+		cd_table->l2.l2ptrs = kcalloc(cd_table->l2.num_l1_ents,
+					     sizeof(*cd_table->l2.l2ptrs),
+					     GFP_KERNEL);
+		if (!cd_table->l2.l2ptrs)
 			return -ENOMEM;
 
-		l1size = cd_table->num_l1_ents * sizeof(struct arm_smmu_cdtab_l1);
+		l1size = cd_table->l2.num_l1_ents * sizeof(struct arm_smmu_cdtab_l1);
+		cd_table->l2.l1tab = dma_alloc_coherent(smmu->dev, l1size,
+							&cd_table->cdtab_dma,
+							GFP_KERNEL);
+		if (!cd_table->l2.l2ptrs) {
+			ret = -ENOMEM;
+			goto err_free_l2ptrs;
+		}
 	}
-
-	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
-					     &cd_table->cdtab_dma, GFP_KERNEL);
-	if (!cd_table->cdtab) {
-		dev_warn(smmu->dev, "failed to allocate context descriptor\n");
-		ret = -ENOMEM;
-		goto err_free_l1;
-	}
-
 	return 0;
 
-err_free_l1:
-	if (cd_table->l1_desc) {
-		kfree(cd_table->l1_desc);
-		cd_table->l1_desc = NULL;
-	}
+err_free_l2ptrs:
+	kfree(cd_table->l2.l2ptrs);
+	cd_table->l2.l2ptrs = NULL;
 	return ret;
 }
 
 static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 {
 	int i;
-	size_t l1size;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	if (cd_table->l1_desc) {
-		for (i = 0; i < cd_table->num_l1_ents; i++) {
-			dma_addr_t dma_handle;
-
-			if (!cd_table->l1_desc[i].l2ptr)
+	if (cd_table->s1fmt != STRTAB_STE_0_S1FMT_LINEAR) {
+		for (i = 0; i < cd_table->l2.num_l1_ents; i++) {
+			if (!cd_table->l2.l2ptrs[i])
 				continue;
 
-			dma_handle = arm_smmu_cd_l1_get_desc(&(
-				(struct arm_smmu_cdtab_l1 *)cd_table->cdtab)[i]);
 			dma_free_coherent(smmu->dev,
-					  sizeof(*cd_table->l1_desc[i].l2ptr),
-					  cd_table->l1_desc[i].l2ptr,
-					  dma_handle);
+					  sizeof(*cd_table->l2.l2ptrs[i]),
+					  cd_table->l2.l2ptrs[i],
+					  arm_smmu_cd_l1_get_desc(&cd_table->l2.l1tab[i]));
 		}
-		kfree(cd_table->l1_desc);
+		kfree(cd_table->l2.l2ptrs);
 
-		l1size = cd_table->num_l1_ents * sizeof(struct arm_smmu_cdtab_l1);
+		dma_free_coherent(smmu->dev,
+				  cd_table->l2.num_l1_ents *
+					  sizeof(struct arm_smmu_cdtab_l1),
+				  cd_table->l2.l1tab, cd_table->cdtab_dma);
 	} else {
-		l1size = cd_table->num_l1_ents * sizeof(struct arm_smmu_cd);
+		dma_free_coherent(smmu->dev,
+				  cd_table->linear.num_ents *
+					  sizeof(struct arm_smmu_cd),
+				  cd_table->linear.table, cd_table->cdtab_dma);
 	}
-
-	dma_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
 }
 
 /* Stream table manipulation functions */
@@ -3334,7 +3329,7 @@ static void arm_smmu_release_device(struct device *dev)
 
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
-	if (master->cd_table.cdtab)
+	if (arm_smmu_cdtab_allocated(&master->cd_table))
 		arm_smmu_free_cd_tables(master);
 	kfree(master);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6fe68f8b38408f..1e9952ca989f87 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -634,15 +634,19 @@ struct arm_smmu_ctx_desc {
 	u16				asid;
 };
 
-struct arm_smmu_l1_ctx_desc {
-	struct arm_smmu_cdtab_l2	*l2ptr;
-};
-
 struct arm_smmu_ctx_desc_cfg {
-	__le64				*cdtab;
+	union {
+		struct {
+			struct arm_smmu_cd *table;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			struct arm_smmu_cdtab_l1 *l1tab;
+			struct arm_smmu_cdtab_l2 **l2ptrs;
+			unsigned int num_l1_ents;
+		} l2;
+	};
 	dma_addr_t			cdtab_dma;
-	struct arm_smmu_l1_ctx_desc	*l1_desc;
-	unsigned int			num_l1_ents;
 	unsigned int			used_ssids;
 	u8				in_ste;
 	u8				s1fmt;
@@ -650,6 +654,12 @@ struct arm_smmu_ctx_desc_cfg {
 	u8				s1cdmax;
 };
 
+static inline bool
+arm_smmu_cdtab_allocated(struct arm_smmu_ctx_desc_cfg *cfg)
+{
+	return cfg->linear.table || cfg->l2.l1tab;
+}
+
 /* True if the cd table has SSIDS > 0 in use. */
 static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
 {
-- 
2.46.0

