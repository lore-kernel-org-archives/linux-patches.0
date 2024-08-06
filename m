Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5243612D;
	Tue,  6 Aug 2024 23:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987094; cv=fail; b=cry2yL6mQL7cjF/7fWK0Pe1eq8uc/YCr7V03TNOAyqt7vN0eH1j2gKNecScmOhWTtpSFItEM32lZ5AbsU2OzHlReAW1uX0Gc9jIuOe25ZGzAprlIr0CFKQPVfbyM/ec6uHnvhL1r+Mc+/fyhJbOEJBIMWsG7gA6PxHCEwGF8ohA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987094; c=relaxed/simple;
	bh=uEQwn/Mx+ClIKhHzuYrj/fSj2FN6ysKcwr0e4TOUwTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jv823EORPEpPGh8DwR8yi7hJleFXJRdRIEXxH8vvsAu+I2AHD/d+MwoeyHhtbNCBTf28SbFU/eV8gLWk6WEa84v1dOY0sDMcw/4FOzqtXT5YUN+lJazvhojrhq68dFPw1/ozVT7BO4yeA8q1DFR6IXg9jEEmpDqBiWVY8GRsJlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lVewv+O6; arc=fail smtp.client-ip=40.107.212.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lVewv+O6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oDv8QBYvB9npyub9rpag1jaB8cIEIoD/L2RwQye7Osc+AEa+LFpEeOFY77OXF7uQWZVWqhSZaIRxGaY5tFZcNXe0bxfPMAXaHF59NeoGdckNPuBlCn0ycwmimp7z4A1a3cnaDoF1CiGjFHm+pMPog1zOHwxn1VBWik/Udm7e1bjLJnD2HitTwwCiRuSWuP2cWIig1o8eUuntlRTFwA9WQTwWyccnO+tffuOFBL9XpQAXXI819f63YMc+1kgA2Zt7YplRDjP9++na1arf76ceGdL4wHHm8uD3Yx7irRRewGm2lsUdUelfpJJs5JI8v0wXkP366fHfznAGvE4/AidhRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prsWV50SKiIwgOQZkGv6ZIkbClrt2zSdiRSUQUzexYI=;
 b=SRBtkmdmilU7mmNol6/P5RvIu/mYcqPUd1kDRpRdCKaJPgFrYslcGMdQkCPu5OeEOnQdwp/1MXCl0vI6ReO71KVO/6bktiUwkFMu9GRu5q8gj1xY+x1dfsIRB9PXdYuAUpF4xaGTjMW/LlHHllmRBIr3rJz58IRmGnOA5GsgZo3emjdcBlzNYRHLXYxR73RXyBERLlTIoUbzakw2AGJoRrXD1Nkb8EI8S1XyXIEtTvUvDIwvLd1Qg+s+55cBIzgCGqMJbmbH83wv5Gjpu+uoztpXHVwyzbfrmEPgWRcvz7dVib2CpDYEim9HIrsnby64OAYC80rBa7pI2EJC0cqDzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prsWV50SKiIwgOQZkGv6ZIkbClrt2zSdiRSUQUzexYI=;
 b=lVewv+O6liAIMlipNmL2FmWN0dhyoKJNx0o79Yfjaft4vDvQKmdlAadZlRRgHE8+5Mv3rgrvIpYjCVn53CmxdjAvroOaImpbTjiCdn4CurWUAh6DyyHOs2GLEDDC9vHKfDxniRDXVGtwP+RjoAU0OGl3kGPTaeIR2dVAvZ8FV/UhNg3l6P7aMsTUJ1GX155wJCNz3a8WSgOWUOJg0+/OEhYY6hKk3/TD27aBJG3vSazXU7ZJq+tFn+NEu6MPOM7w8iyinI/tDIQI9IKkKyCLTzSPk7Xe3AseHWZovWcDVgEZ1250FU8iDYN7t0jNeLGgBnPIQEzjXLEnPKDEZVk5hA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN0PR12MB6248.namprd12.prod.outlook.com (2603:10b6:208:3c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 23:31:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:25 +0000
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
Subject: [PATCH v3 6/9] iommu/arm-smmu-v3: Do not use devm for the cd table allocations
Date: Tue,  6 Aug 2024 20:31:20 -0300
Message-ID: <6-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0394.namprd03.prod.outlook.com
 (2603:10b6:408:111::9) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN0PR12MB6248:EE_
X-MS-Office365-Filtering-Correlation-Id: 3995bef0-3dd3-4a1b-706b-08dcb66fe32b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tE52CdduFYyFJABkDz3FK7vLLDshxsu+CO/dvRC0ETybEZHO+8SwDfmyrBc0?=
 =?us-ascii?Q?axGkSHqIdxhC5Aezrz5yb6Syd7Dxxdoz1k88xCd9CTIhobDNa+lZFmxu5h8n?=
 =?us-ascii?Q?PBRjwqj7AhtrhLelA37q82okModVJKpjW56/Qh19FUtO/HTRDuZSlqG4wOpz?=
 =?us-ascii?Q?TnNUmyEJRUIb1A7vZ8n+mHfEjMmrrTSNO/LeNE9Z6dg3fEpMmffuJtlCgnAk?=
 =?us-ascii?Q?7H/fTBrFjb2hoLzGiXyFMvdwoWekFgwCjGo2UHYiU2Fr4BlXNUNa6/hb0FkY?=
 =?us-ascii?Q?7S1U3AqpixZSAamOGoG2h4Is3QwzcEMNT7QHI1IILBK6CdXVa/2pp03eJ6Vv?=
 =?us-ascii?Q?gvTkWIAyiXyYbtJSn5sAmAxqzhJzT8ZktrzH+ljPl1SMv3H/aY3P5D9j07h5?=
 =?us-ascii?Q?hz43ZqRlB+CA0vFuCPjbbizRR3Eby8xga8WibfrR5jsLlI/bDjg9IVBq0KwV?=
 =?us-ascii?Q?Uyr/t6lZML6hurd8TzSS5xCTOffhx4RJQEbVjd658FxDzLL6WadEuPilC3kv?=
 =?us-ascii?Q?73REKNL16dJ77Yj0RizRS3pa9BHLaLBzRaPZYfJ03vaa9jIzL3cF32zrWLgv?=
 =?us-ascii?Q?jLFUPG1CHkvaGgIgrtcXq4kGKF1tC7YrPXwpx6VSRxDvxeGcUF5ENsl7FAOJ?=
 =?us-ascii?Q?Dgic20/mwhJh8m8AltOCn9tFLlyjO8DwM7KGklKGPDAUvgfElTHbaEZVvros?=
 =?us-ascii?Q?aLMoZF573ZpgLyDlFknnxoNNW6o4/AlcM2TvPtW7pGcGsxrb/U3nk/l88RdI?=
 =?us-ascii?Q?r+V802dP1xR2/mgKdhyfOy+rTDropaNvA6kQQKYNXX4608NQsRwKkYIoOYMP?=
 =?us-ascii?Q?waVZw9CQyvEBXvbDFNwkWrS3xnXKIcmZv1CLjXO/aFVzL9l9Th8n+iG+kst0?=
 =?us-ascii?Q?IepE3u6x0PPRb/UYqk4MPNavVsYqV0JlwvpA84vckZMiZbewytJK3n2aautJ?=
 =?us-ascii?Q?vTVIO11a193+4tv6ZgOrJXoh+0YCkMgjMAQJMxLcCaVahb2P0wd4nuB4OXzb?=
 =?us-ascii?Q?SZww3/A8e/Qr++3uQ/3Q7nsNEsQIYiOGaYgqCnj4qJv6eOQL8Cr0+aIIJdCI?=
 =?us-ascii?Q?lVLuxZmiwLQsJkxnGSREVnm2v7xKrUF+k0O5e0LR3iIAyBPnJDDmxjvqy53o?=
 =?us-ascii?Q?IX5K+ECbePGzLpvrlKf6oRrPCud47rKLakx3ayxVBESXRQcl34yIcBfdZ6Sx?=
 =?us-ascii?Q?/gipctAlEb9X3+aBndYW7Iy7CRAJyhce5G4diQAJPza54XkIa+V0PpGqrYdx?=
 =?us-ascii?Q?fbJlAWpd0EuZTBJbpK7bwPMb4j/eTAyLVNrHmZF10vT8EIKi8TwL/ZAWJBNw?=
 =?us-ascii?Q?DYagypYQfFTTNA8JVplAJrITEUlhlfcFc3D0KvwexotfEQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FBjXTh8kvuuMy9kFI15wjiiqM2oj5f5lvUeNvgQSX32DsiX6H5TK7KG0H4D+?=
 =?us-ascii?Q?/12vpgQbijz+FszlZKGLfq2LxFrrgWe12FRYVelIUzzYmsDbD7z3G1PF3NEw?=
 =?us-ascii?Q?d/IP0X2q6LniF/tol4ci5+PRzRo8556gPZwaMuYTd+ULVpkrlhr0vN8fzCB1?=
 =?us-ascii?Q?xU9Mw0MUDGLHMRTTI6rCoeGosIepEjl4C/apH8RrNyAaskmVc+yfE9E0mhDv?=
 =?us-ascii?Q?cEhYbRaau3o0O82E17SHGnI7RatvaaIP4mYbinIW1IHoc9oRBKb16A9w1dla?=
 =?us-ascii?Q?2jsSFP9H5UmWv/bDbroTj3ge2h8tg2IEGAp6EEFmOcf2UNyYptoeymNw7KS7?=
 =?us-ascii?Q?Q1FCpYnmaxzJ6bRoPBvMCiF2ycH/vHUTftVMjco7Xduj9jRDGtlraao+3Il5?=
 =?us-ascii?Q?bY5avH8yUWCaMy6GJA8qxw42wQPcRUqN5+GvdYJp2dwEzLDzNpibRUkpFNA/?=
 =?us-ascii?Q?/G9mBY5EkjFaOr1zVOSy4YIp1WEOx/uT371hdCGkQjHCgaYpaxKmXTfk1bAl?=
 =?us-ascii?Q?yZq6N32PBSzNb4oUduYinGyAWACnDkKUcSDWMbNiSeMYgX91v+GigWEuv0tx?=
 =?us-ascii?Q?f/dFAf63w/B2+zphgK4DaamriJNxS5rdgEsIfW3oICFfdrBKIch/e3FzVWEv?=
 =?us-ascii?Q?52ccpBzT9bptgUOc6xwx86r0AV5adP0Di0HNuaHpPW8AyFXq1l82mXNYN4S/?=
 =?us-ascii?Q?KUM7y88LZH/XPq0d7kUmy/5gLGSqEBKKMPl++QwUF6x5J6xmcLHUTfMI7uCX?=
 =?us-ascii?Q?MpKpnK5c7VMgEyfQyYsRCOFCUMyjmSP3v6L+hC3GLwiiOuBND01F8JpC3Ucv?=
 =?us-ascii?Q?JI3wA0zz+7Za9ocyX6u5IWxa255CM34bgx0iseeuDCqNTYBY+TH+OfzMqHwc?=
 =?us-ascii?Q?9rc/dtMZbxTv4xZgEjvyaSgC9pKqx72mGgj2NqYsGPVOe3xmmteDlHghso/E?=
 =?us-ascii?Q?JE17n+bD/xn5jK5xIOKPWptRTDPTqwcGqMR9l0ZNjPMUMTC3FQMLrDmxh9GK?=
 =?us-ascii?Q?pUhrlAQ8k8rV93Hzoxg+cW8zAyy4M+zRx+IMsCdmcvJPQJWNIXAiHux7cWM4?=
 =?us-ascii?Q?eNQrnXHfqrRJAmZHu6gaxnGr+sWx662q2SoV0FmDN09TVwCZy2Ug6NMneBab?=
 =?us-ascii?Q?E2pcNJ80X1lU5mqx87DONjNloKSj4VjB1cElZu9nR3czoRtp89kdiONTQTVe?=
 =?us-ascii?Q?JdeUMRvp1ubnSCLNYH2w6wdw9OAp2WwwvpBHhhaOkbv9FP4VFUjntigiTbHx?=
 =?us-ascii?Q?+HZSTTTHxUQFPPhiGtQHXfJcwSLwTe640ctQNjwhiFi2+zEn8oiyliMvTd3P?=
 =?us-ascii?Q?/tpL/UhAuAETmeeblbwwYQcGch7n8CUY69H/qU9p/CPUiddOLH8U6fm+csyw?=
 =?us-ascii?Q?a7eCzrCHm8IUEAj4HVR3HiMgzrY+QpiBuSqsuMP5ZjQQIugyDlTau3vGw62h?=
 =?us-ascii?Q?HfFZwBeNUAXadSns/ed/Dl1TD4/0xA5w7ccvNroaLuOQu/UzEgc1c2Aii0Ci?=
 =?us-ascii?Q?4a1zTsOsji+yTSO1Cpp1d4auaEaKPFYrqN5GSZpRhD9oNL5Sc8ofIXIAe8rT?=
 =?us-ascii?Q?d/9KAU6jNsSQ3lJd7v9d5DxwJCFeAIsetR/uKv3j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3995bef0-3dd3-4a1b-706b-08dcb66fe32b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:24.9847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HWHkMujcjC5ibGpFFpLFtgeBDtY1i7DEPRNOtk/QRYagYPsBYyzrocA0wcYk0/sP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6248

The master->cd_table is entirely contained within the struct
arm_smmu_master which is guaranteed to be freed by the core code under
arm_smmu_release_device().

There is no reason to use devm here, arm_smmu_free_cd_tables() is reliably
called to free the CD related memory. Remove it and save some memory.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 30 ++++++++++-----------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 95bd4a36268c00..e6607d9d590c4d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1184,8 +1184,8 @@ static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
 {
 	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
 
-	l1_desc->l2ptr = dmam_alloc_coherent(smmu->dev, size,
-					     &l1_desc->l2ptr_dma, GFP_KERNEL);
+	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
+					    &l1_desc->l2ptr_dma, GFP_KERNEL);
 	if (!l1_desc->l2ptr) {
 		dev_warn(smmu->dev,
 			 "failed to allocate context descriptor table\n");
@@ -1399,17 +1399,17 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
 						  CTXDESC_L2_ENTRIES);
 
-		cd_table->l1_desc = devm_kcalloc(smmu->dev, cd_table->num_l1_ents,
-					      sizeof(*cd_table->l1_desc),
-					      GFP_KERNEL);
+		cd_table->l1_desc = kcalloc(cd_table->num_l1_ents,
+					    sizeof(*cd_table->l1_desc),
+					    GFP_KERNEL);
 		if (!cd_table->l1_desc)
 			return -ENOMEM;
 
 		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
 	}
 
-	cd_table->cdtab = dmam_alloc_coherent(smmu->dev, l1size, &cd_table->cdtab_dma,
-					   GFP_KERNEL);
+	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
+					     &cd_table->cdtab_dma, GFP_KERNEL);
 	if (!cd_table->cdtab) {
 		dev_warn(smmu->dev, "failed to allocate context descriptor\n");
 		ret = -ENOMEM;
@@ -1420,7 +1420,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 
 err_free_l1:
 	if (cd_table->l1_desc) {
-		devm_kfree(smmu->dev, cd_table->l1_desc);
+		kfree(cd_table->l1_desc);
 		cd_table->l1_desc = NULL;
 	}
 	return ret;
@@ -1440,21 +1440,19 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 			if (!cd_table->l1_desc[i].l2ptr)
 				continue;
 
-			dmam_free_coherent(smmu->dev, size,
-					   cd_table->l1_desc[i].l2ptr,
-					   cd_table->l1_desc[i].l2ptr_dma);
+			dma_free_coherent(smmu->dev, size,
+					  cd_table->l1_desc[i].l2ptr,
+					  cd_table->l1_desc[i].l2ptr_dma);
 		}
-		devm_kfree(smmu->dev, cd_table->l1_desc);
-		cd_table->l1_desc = NULL;
+		kfree(cd_table->l1_desc);
 
 		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
 	} else {
 		l1size = cd_table->num_l1_ents * (CTXDESC_CD_DWORDS << 3);
 	}
 
-	dmam_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
-	cd_table->cdtab_dma = 0;
-	cd_table->cdtab = NULL;
+	dma_free_coherent(smmu->dev, l1size, cd_table->cdtab,
+			  cd_table->cdtab_dma);
 }
 
 /* Stream table manipulation functions */
-- 
2.46.0

