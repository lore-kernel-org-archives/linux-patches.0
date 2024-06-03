Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A2D137927;
	Mon,  3 Jun 2024 22:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717453907; cv=fail; b=m2bFrBGDgAcuDPR+TXOgBRB2n/uXl6tBz65XMRk/OyUY/ioSqO7r767phgvfWqO41hduGXVPEk3AjO19feKF7ZfAFJTn8cKZubTqSa32Hj6d874qZ5gpknPiarhD5e7okyNogaF0fsFuXfLCCBJ1WUfkTvI3NSM/o8ub5cfo/+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717453907; c=relaxed/simple;
	bh=wvDRklfLRCxs1w8CQQ8z64Po21EWJ2289Dd+kRvOOR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L/w8BbqhXR935wlCQAQPXczVv/aN1V0mrVse4YhX1dpq8DwxQXbxB63JKTUPig5XZ9G+6UrzLMV5xR3oqr9xuTyy7L3PuMvFSjHxGp18k5c1cjQDmcOjrvN+w8S7uWyl3SWTSnzoHobw9oeKIS6ieieUHj2qz5SGuh85v+8n5EA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oO0a8YYO; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oO0a8YYO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iinEgzqPB8phoY7yOXTonus0BnDIGMt5TjUp9K0tkglBZekRZFfXKJeJ2YBH/blio0TJynxeSw+GSd5h6lBQKXuE24O3bys23CoIVrdosTqDtS1YMPdyEEPsKn4icywBVgvLRCT5yOvlVEXA9deIHkWgDOB9z/rhtOS9kB30XeRc8FwOlnqc5VkpUv6C0pDzZQQl22n+KA33FCkcwBh7sKKrIwrUkeE+cXJe9gfcWaU5ytbGWw7w8ZCyFO8VcjJ23kjP9cC0hhXnDTMbXF/kLXODYBic3wOjH9Gii+bi8+YaG7o3esxPlYwifDMseKSzpkJjrSFdVdAsmu0PiUXeOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRJjIkOu38E5kg3xINGR6FAcRVFKme4NhlxHgbMJFDE=;
 b=Qh1cGvyLzCqXzLMStMcgYv9HeUP8jtOARsr628P6dR+oXY/6yHWigRJbRPCY2R7NNlVnJw5uW/8aice59VFCAptlruYIGjN0wkOBQs1hCBtM7ORxeDIZGJTsAGfgxGvH5LKZx0BScyOzoqMZlBGU5cE+EQPEERfF27ibZyalRHJD67usAVkgMOniTyWEH4By7LjsJ9jB0zG65tFs5+d5Pkpn53JzmPdfhVTx9Y7oK27cYYUENho7XMvBVdzF+b89pH0g8cusmb0OzPI2GnejJJUva4BcSTsH9dmKlo16GMSbh1Jkym13KbZkSp6U1NidYSVKdQGMR6D0e343kXmvBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRJjIkOu38E5kg3xINGR6FAcRVFKme4NhlxHgbMJFDE=;
 b=oO0a8YYO4TlR8HxbjMoboDOGiww8zNdqpfk/WcLtJWA8zh6w9cCDpmaVCMMZRz4IwBzzV0wEZE/AMXFt0yYaCi2CLJ6cmOyyLXhFUdZfHpGFoKCCrhlcbtbnr0tOXGY0RIyfXY8gW+PN0c8yayy92L9Fc/U3XIqCq/Egf8kCZ8O8H28rMxPI/3LwbvuVD5Tyx8sIw1+WAOWHBQQqefnXVgUaUoZjRT0seH47Cao8s0GDproGsOMpcO8cp4a+3fTsH9l9kwegKjlQxnBf5TnuprXPfnYe9wsqN3XKB/tG8SCwSrD05RHFX0IQxLzJ5JfhwXs/5X2P3vLEi8/4OL1Kvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 22:31:39 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 22:31:39 +0000
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
Subject: [PATCH 4/7] iommu/arm-smmu-v3: Split struct arm_smmu_ctx_desc_cfg.cdtab
Date: Mon,  3 Jun 2024 19:31:30 -0300
Message-ID: <4-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:208:c0::35) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: a7297142-cac4-4418-1191-08dc841cee07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iy1LqQZLKb49E7SKbz5uA59h3IoKhSCQ+5JvDPzoo0o2Ixg/e0oy+gPkhTAK?=
 =?us-ascii?Q?snz5KuMeGXL6KEVBnRZmbUeXJJqQDNW3D4/8jwtVlz72bYPk1jqsM16g5b7F?=
 =?us-ascii?Q?YFmt0bDXh0c0CDIwG0ssoTxrQMQLlfGEg5orBImwCIpXKAoZS81NWOCGzNe3?=
 =?us-ascii?Q?JFb4ebCAVczi04u/fLalxNYmkZqjMdnMF6yzfW8Mz1lr9TdGs4d5/s9sCN3t?=
 =?us-ascii?Q?yypiSa+BgQh8TFqVRSI9n0zytRTNhAxm/VmLFw1aPNqHbaOoFOckp+OWGVh/?=
 =?us-ascii?Q?38fAb8amZ/C8W9K/VJxsfAVPyZzQOGWjJei+vKXRQ4TT+9b9OcDG4mAUoMhD?=
 =?us-ascii?Q?B9A1Uo/1wsj7x40vk1bSpUD29n1s8OH6HZ1d2dx98mXLuUU6aIC77zczZyaQ?=
 =?us-ascii?Q?dlQroQNgfUSVPU9Ak9c0oPaPVrgh3ATZTu0V7wK/+wIyHX4zigX7r2+vVicN?=
 =?us-ascii?Q?DnbG9JJcHVuEARL/bp0BDQnd687TMB5Z8ggveQsIznj4nzZnzTMaaQxP4VIR?=
 =?us-ascii?Q?gduHn+4W75xGNNxAhwYrYwVOki5xCY2IUOOM5RucuPuIqL1Rtpo6UrtGxcZE?=
 =?us-ascii?Q?dmZBfD7j8fFbd9dCzPBttcKuNcY2WlzVQH2uZ3OGeBUJafueLYQ09JAUU33i?=
 =?us-ascii?Q?yD91MmF387ytWRK10CG7faav1M8ESU8ot9r4FodEJge9WQQvSvKMYBAoVGD+?=
 =?us-ascii?Q?gtweXGWaFRjrljdBrMhv7FxQnHReB0GJ0KFm4ttGw2Gx6vYFbad64eR0w31s?=
 =?us-ascii?Q?CRF7aJCZulR2CxIK558o5irGZz0ryYN2fwthO4vCPdlH3DF95sYvEVvwoCh6?=
 =?us-ascii?Q?9iwCVeSjRZyRACp5CQYyXAzOgVOUyi2yQSj+4qpCGb3+RfvNYLYiwypCcBA6?=
 =?us-ascii?Q?34EFhwNFodMznd8J+iynkDDocrYRWdJVi6uFa18NOHGVwO9dS2WznJf809A1?=
 =?us-ascii?Q?jRH23y8GIQkTvRJFdnUlWFMnA+tvXje5f2QFDfC9beaXROq4D3YjS/2uyroc?=
 =?us-ascii?Q?EfVESgmIU95LoqAD0GlIY5uZCQ9ptBgWlCaS9CCdOCSC02JKw0lYuSATe7QH?=
 =?us-ascii?Q?2KqtYsjM6A9teyKD9UdhKIJ7YydCNnogysbdcws1q+tp/UxMpgWAFH1n4+LO?=
 =?us-ascii?Q?oOS2li/KpSp7TvRtjvroPF8YBHiwhwGqwhhnx46In9J+MqnOaLL/oze+leZl?=
 =?us-ascii?Q?zO4VW1yrKOCjG3HOTaWMaVFA13Tidffm5dFk70NrWuEpl6EPbwl6+mbPRJJz?=
 =?us-ascii?Q?bSYDFLNiRb1v6grLnQZBi8WrXJZrl1LseWFdlo2x8A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mNZDtq6+5lXgKl0nr5z0pEjPZFIqEPEHZ5OfmnrqM9MQZ3n0MNeGHjCudLEq?=
 =?us-ascii?Q?AJtov6E5NIJ/vyj/NMwf9mRXV5z/RVSZezXYDTNZR+66bfH0+Tgsdd7EWO2p?=
 =?us-ascii?Q?MtV93e+gxs1vN0d/fJEilvkWdi3BDjnUQC2JJgk8pwH4IyUYrM2ULe6wn2S8?=
 =?us-ascii?Q?9S/BbLW/M8ZW6KeK8S9kOv5dgduiIYPP6Mc+GntfxmBJDH6E+7qyXxgZuR+v?=
 =?us-ascii?Q?uLEH/HbZEOo8zQe8wCoj70I3a7GTibTuXB0vdyPcmTa+LVSnQk4a/goTFv14?=
 =?us-ascii?Q?SykvcQzoqYmu6BWAxzxH/Q6r4uHiMt/E6k6Avv5NE/m8EHJ8JSR+l+29OOkT?=
 =?us-ascii?Q?8cZsbJNiD/S+KaOtK5N1WF8jgqjeRb5LoAfia0WtfUmWp0Urz2cCosW9jZpc?=
 =?us-ascii?Q?IOfkjo2qw7EfyG1qac2mpPHK+h2xAygNlksBs4MY8Ur7lMbT6N3ggCGeg7gB?=
 =?us-ascii?Q?Bm3VKSyDvexUBfaEj/Doruq5CUSam4Gr2lxO8DoDVh4bDMQPZhGwnm5AweAc?=
 =?us-ascii?Q?mlnBOlgopZZDG7NKpyqZBxABEzsEvkwPeQF6NXTlMQk5RfEZuyVMDwVSeedN?=
 =?us-ascii?Q?Zcg3PRKBiZelCzawNSfPOmf2Sc9IPm5oAvQZP10yJspypbb6wkDycqeM9590?=
 =?us-ascii?Q?m0/Cn6vDAzeZu2AC5t0Ez+IZwzrEczZBucWINk62/RO1kpqcrhxGbBTRGLHA?=
 =?us-ascii?Q?bDQ/GJhkyjtnML0zG3SzvzXLN4e8wB7yRXV45/UMFxW3ZjF90J4mHff/Jm00?=
 =?us-ascii?Q?r3Ip4CcWv9qKuq/EA2ubhukKlgn0f9Id9UaN7Cq8jLhScPKxr1AShvGqaoPK?=
 =?us-ascii?Q?iVmCx0UUR7XloNrroLou92nLDbTMCO1pWiFjrvJuV3XE+qIFCMDRRlDEfu71?=
 =?us-ascii?Q?QsXgIBtJwbt6xxkoe6LQsHmM5JwxSp0ASIadn8b5A0xvupbwJ3WH/fxWST5c?=
 =?us-ascii?Q?3cws7AKF0faeLu+H6LSvKICChSBOExXXvLQp9Bz3Ws9lrJ9lmNdoAjnNM8Ax?=
 =?us-ascii?Q?v5Bdr8ou+FTMXP72RuRgYhMi/dWL+ojx+GJkIwIneJm+do/OUL2dz9gwtNl2?=
 =?us-ascii?Q?RKh9iOZqHArcGyd6iOYlEZ0omEmQ0h9FqUZwmWr9DBfWsi39kYAnAfosHF5z?=
 =?us-ascii?Q?V9jSoNvDIHE5BZmfsKKb8dlK6r+TU5MaZCTJvQrf5Oe4mbbgoYEp49Ww7Uz6?=
 =?us-ascii?Q?WNqbzNKTwunqcQsKDDd22YxWWBHqs05Ejb5VANkmg9eg8JZG1Qyea1Q+nvyp?=
 =?us-ascii?Q?8z50W45OcIAQyBru4MtXSUhQVLNlv1C85Mohs1fbY3Lmo/ZLCixGtvnj0PTR?=
 =?us-ascii?Q?uFohgFGIrbnbgjFrDBjV0jJEp1U2V+nQK3N1LeJ1BIL32GEOz0V6xsQpy2KQ?=
 =?us-ascii?Q?9xGlAIp3UIwemgYpu1O6IvsLVgZCYci4jQCdcROHQc6AWY5Rwz3QF/Uze84/?=
 =?us-ascii?Q?iDJ1GspJ6Tnlp/KG/uxbz4QKCYt9eiL+4woPvherrmnnHEP1pVhzmM05I0rU?=
 =?us-ascii?Q?z0g1WcdgbYrB0HoyNsGx51ll68nsIDSKPKfQqYj7zyzTQSYwDkqc/+cAiSiW?=
 =?us-ascii?Q?5DszHrEpPLd2wSWgmcU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7297142-cac4-4418-1191-08dc841cee07
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:31:36.9460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76bmWAdTzhZSGF7GNYA8A1ptnX3N+5oG2BXt2vpSMTJr+M+oDvC34Bc6PhTLXwUM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

This is being used as both an array of CDs and an array of L1 descriptors.

Give the two usages different names and correct types.

Remove CTXDESC_CD_DWORDS as most usages were indexing or sizing an array
of struct arm_smmu_cd.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 60 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 17 ++++--
 2 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 735dd9ff61890e..24c286a0834445 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1170,7 +1170,7 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
 					struct arm_smmu_l1_ctx_desc *l1_desc)
 {
-	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
+	size_t size = CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd);
 
 	l1_desc->l2ptr = dmam_alloc_coherent(smmu->dev, size,
 					     &l1_desc->l2ptr_dma, GFP_KERNEL);
@@ -1198,12 +1198,11 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	struct arm_smmu_l1_ctx_desc *l1_desc;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	if (!cd_table->cdtab)
+	if (!arm_smmu_cdtab_allocated(cd_table))
 		return NULL;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return (struct arm_smmu_cd *)(cd_table->cdtab +
-					      ssid * CTXDESC_CD_DWORDS);
+		return &cd_table->cdtab.linear[ssid];
 
 	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];
 	if (!l1_desc->l2ptr)
@@ -1220,7 +1219,7 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 	might_sleep();
 	iommu_group_mutex_assert(master->dev);
 
-	if (!cd_table->cdtab) {
+	if (!arm_smmu_cdtab_allocated(cd_table)) {
 		if (arm_smmu_alloc_cd_tables(master))
 			return NULL;
 	}
@@ -1236,7 +1235,7 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
 				return NULL;
 
-			l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
+			l1ptr = &cd_table->cdtab.l1_desc[idx];
 			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
@@ -1342,7 +1341,7 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 	struct arm_smmu_cd target = {};
 	struct arm_smmu_cd *cdptr;
 
-	if (!master->cd_table.cdtab)
+	if (!arm_smmu_cdtab_allocated(&master->cd_table))
 		return;
 	cdptr = arm_smmu_get_cd_ptr(master, ssid);
 	if (WARN_ON(!cdptr))
@@ -1352,8 +1351,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
-	int ret;
-	size_t l1size;
 	size_t max_contexts;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
@@ -1366,8 +1363,14 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
 		cd_table->num_l1_ents = max_contexts;
 
-		l1size = max_contexts * (CTXDESC_CD_DWORDS << 3);
+		cd_table->cdtab.linear = dmam_alloc_coherent(
+			smmu->dev, max_contexts * sizeof(struct arm_smmu_cd),
+			&cd_table->cdtab_dma, GFP_KERNEL);
+		if (!cd_table->cdtab.linear)
+			return -ENOMEM;
 	} else {
+		size_t l1size;
+
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_64K_L2;
 		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
 						  CTXDESC_L2_ENTRIES);
@@ -1379,24 +1382,15 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 			return -ENOMEM;
 
 		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
+		cd_table->cdtab.l1_desc = dmam_alloc_coherent(
+			smmu->dev, l1size, &cd_table->cdtab_dma, GFP_KERNEL);
+		if (!cd_table->cdtab.l1_desc) {
+			devm_kfree(smmu->dev, cd_table->l1_desc);
+			cd_table->l1_desc = NULL;
+			return -ENOMEM;
+		}
 	}
-
-	cd_table->cdtab = dmam_alloc_coherent(smmu->dev, l1size, &cd_table->cdtab_dma,
-					   GFP_KERNEL);
-	if (!cd_table->cdtab) {
-		dev_warn(smmu->dev, "failed to allocate context descriptor\n");
-		ret = -ENOMEM;
-		goto err_free_l1;
-	}
-
 	return 0;
-
-err_free_l1:
-	if (cd_table->l1_desc) {
-		devm_kfree(smmu->dev, cd_table->l1_desc);
-		cd_table->l1_desc = NULL;
-	}
-	return ret;
 }
 
 static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
@@ -1407,7 +1401,7 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (cd_table->l1_desc) {
-		size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
+		size = CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd);
 
 		for (i = 0; i < cd_table->num_l1_ents; i++) {
 			if (!cd_table->l1_desc[i].l2ptr)
@@ -1421,13 +1415,17 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 		cd_table->l1_desc = NULL;
 
 		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
+		dmam_free_coherent(smmu->dev, l1size, cd_table->cdtab.l1_desc,
+				   cd_table->cdtab_dma);
 	} else {
-		l1size = cd_table->num_l1_ents * (CTXDESC_CD_DWORDS << 3);
+		dmam_free_coherent(smmu->dev,
+				   cd_table->num_l1_ents *
+					   sizeof(struct arm_smmu_cd),
+				   cd_table->cdtab.linear, cd_table->cdtab_dma);
 	}
 
-	dmam_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
 	cd_table->cdtab_dma = 0;
-	cd_table->cdtab = NULL;
+	cd_table->cdtab.linear = NULL;
 }
 
 bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
@@ -2955,7 +2953,7 @@ static void arm_smmu_release_device(struct device *dev)
 
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
-	if (master->cd_table.cdtab)
+	if (arm_smmu_cdtab_allocated(&master->cd_table))
 		arm_smmu_free_cd_tables(master);
 	kfree(master);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 280a04bfb7230c..21c1acf34dd29c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -279,10 +279,8 @@ struct arm_smmu_ste {
 #define CTXDESC_L1_DESC_V		(1UL << 0)
 #define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
 
-#define CTXDESC_CD_DWORDS		8
-
 struct arm_smmu_cd {
-	__le64 data[CTXDESC_CD_DWORDS];
+	__le64 data[8];
 };
 
 #define CTXDESC_CD_0_TCR_T0SZ		GENMASK_ULL(5, 0)
@@ -312,7 +310,7 @@ struct arm_smmu_cd {
  * When the SMMU only supports linear context descriptor tables, pick a
  * reasonable size limit (64kB).
  */
-#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / (CTXDESC_CD_DWORDS << 3))
+#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / sizeof(struct arm_smmu_cd))
 
 /* Command queue */
 #define CMDQ_ENT_SZ_SHIFT		4
@@ -593,7 +591,10 @@ struct arm_smmu_l1_ctx_desc {
 };
 
 struct arm_smmu_ctx_desc_cfg {
-	__le64				*cdtab;
+	union {
+		struct arm_smmu_cd *linear;
+		__le64 *l1_desc;
+	} cdtab;
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
@@ -602,6 +603,12 @@ struct arm_smmu_ctx_desc_cfg {
 	u8				s1cdmax;
 };
 
+static inline bool
+arm_smmu_cdtab_allocated(struct arm_smmu_ctx_desc_cfg *cd_table)
+{
+	return cd_table->cdtab.linear;
+}
+
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
-- 
2.45.2

