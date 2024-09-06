Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390791D174A;
	Fri,  6 Sep 2024 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637698; cv=fail; b=DrnV0nMNcKddejZWxR4e0Zk/A/mqIQiBoafZZ1tfpu4bFTUmWwVeWb1DnV+0XhwUrXiZq6NQvRt+TL4Gk9JiPGoremy65kxMxC8Ma+ONhB0veMnME9ZYrNyzFf9x1WMuJJ4FyTOrdhQhHCBU2PuoOIB0aAriP4ZEywfQbNWh/KQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637698; c=relaxed/simple;
	bh=PtLw0KXCiu8dcPbXCNQs2gSq4snm+0C+G5HTFaLHUC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UhVtCOiY5YZTtgJdyzGYL9mTQMsHiPCjDW9/YLmmu7WxArwW1fvVoK9+n2iNK8W0MXq/3PwQjtJNq73NhzRRMgVZjZTJa+EOFxN0WGz0mh3XzYhisYEAbbtx0OcCLOjq4A+cTnQ42ZiLE4krtwJFQfV7iZVuS1uIJpbRC+hw2kQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YljRv68L; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YljRv68L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tNVX97K1RTHc8CaqLbG+oX67fa+WjAjiigx1D0bFAawZQ+fL14zrt7qcMwW7yKl4XP1+PXk3tbd8AS7tJSkfOzwI5HzwyOvyPq7cG90dc34eaRx04M5v9tpccvAOAb3Zy3BhILTswDkqNLO39Xg0gupuH/IXMN3T/uVhiXbuTPAy+LbWU039FL2ouEy+/h7Gf5Rnm4EsKz67n1Vi+fmOqrAwyXXctxHIBT20h+NaIxIeqKzCbXMareCEOIYcyjOXqYz/ZYJJF5UCe2GM3Iu4LAuEXSin3qCqjEPE+osIW4Zd7zxLPD/lrNY+T/VsLOgiygOuFLlfa/U5Hff2Ma7obQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aacp5HoyRGiT+Z0OoH6Y8m5l4yd97f+ZUML7XVgZoe8=;
 b=tvZd8SZeaDTB/TJeiHIZVvuEuhr0CmK/Bqnc3AOMFPmpnitBrYS1GoQXu5PdVt7T0gJFR6TrU45YdXPFQwnV/Trryg2pzIZCwRLzhFfCbQndHqz1+rqyc7K14C1HX6ON7SB4omeZ6Yv19dVaqeJA59hfFNsUHG60LFAfhWoSZh/kD0o9QU1sPIbKYqt+Ra682vjC41hqC2Mi23cwUvVPEkDVjSS2VZ9/ZhS8mu15Vb3e0GV33Go0UYYQHwrilYY6VBKL+nTqytd9w/+aNTyvTMCfC7YO7lSSI7Vw4XSnENG6iVJCmcv2dZZV1H69gXplsfF0I3VJiyZ2g4EiH0Eqcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aacp5HoyRGiT+Z0OoH6Y8m5l4yd97f+ZUML7XVgZoe8=;
 b=YljRv68L8dR/64PLmA4R7ARMivn503ks3aSngX18rxWs8UGdkTpgmVwGym8vVtksKjAy+YBiapAY30p6iNp3imXrmT4jb0+7H+IHiD2+ZZ+GliviUJmaJhbOj4yNhFSL6LOHdr3zioQTVgGRoC4kELb8kSqFUcvvfVKwLbMRiwPTJvZj9s7cpT2nokiO2cIHgLPjAFk/L+Cjqy1KpUkowp9Ib07DOboylHiZwgeKIau0yLnLr4l90Zlyn5w0wkcsp+cezRcgOlqWhC/5Rx6HHCkDYEH7pn2FzNQIy1kKLieA5RdGmdvbu8FAsLnGid+Wv9fIuc9hiPWtODanVszEOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 15:48:03 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:48:03 +0000
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
Subject: [PATCH v4 5/8] iommu/arm-smmu-v3: Do not use devm for the cd table allocations
Date: Fri,  6 Sep 2024 12:47:52 -0300
Message-ID: <5-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0031.namprd16.prod.outlook.com
 (2603:10b6:208:134::44) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: e6d5c73e-92c8-4f4d-8038-08dcce8b4715
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OuIYWEn1uBg11vl3yr9vvZrhFvPzp/oy2KgbKhFKJEQbkxc2NOZieNNLBpWH?=
 =?us-ascii?Q?9DQHAOJHhA9ye/BQlNhh0KwamuOsiB7M+/l358TzGpA5BmlPrs2VH+J+Ziao?=
 =?us-ascii?Q?HWbtoihRHaEMJjDDmbP9TRw5EQ1uc2e4wp8CYF6pdF7i5v8o6KTXIO08bd7R?=
 =?us-ascii?Q?9RWgiqB6F9KR/7v+MV61AYweRJy6QaUSBO0SN+SbSrqu9Dy1yzICp8aS59MO?=
 =?us-ascii?Q?a25J2GrCDMkKos5+W11Kb600eVYCXUZIwoXmcPYfMCznUJiKLMKZ+U3PltEw?=
 =?us-ascii?Q?oBTqXm1xmCK0HKBnePupFZdDrdt5NbRFTohzSTol6WETtMXDdqAddxRZKZT+?=
 =?us-ascii?Q?JB2BsXHGj1YyfDNfUyMfF+5rslMaHshOMjslyWHihgCkNapju89VqpB+b5G7?=
 =?us-ascii?Q?fSoD7vkTonmLD6da2oArBj2jhKRHJ5lOaPiHb9VHj4UrHkbt7GYh+SHpKNlt?=
 =?us-ascii?Q?HM18eCZZOBZgJU6YTMSqOVP4rjNXRgv1wr1fwcAbS73CzpZHSRV0c7jrsUSi?=
 =?us-ascii?Q?uYT4ut98uQ6dQ4JGkJ5L14gbYPce95sWx91uR9LgCQ0ie1RzeralGW/ktfU9?=
 =?us-ascii?Q?I6kIlaykC6Kh+h91azDmcJHV0KEYiD1vrsG1V8XE3LZg+jk/od8QnQOPexGe?=
 =?us-ascii?Q?F0z7SQR1ss4nX6C9oJZ0CzqLKOIFn6cTXl1dgEJbFf5VMl4WRMw3tjiQ6wRY?=
 =?us-ascii?Q?ywUYRtu0JIdXU1nopkkS+pmBlHFFcWpmkRMPP0z+ZMG9yO4E+coJiI+h6ABQ?=
 =?us-ascii?Q?k+VtN+5RS32BqxUeUg1NF6cC9pFDpAFZkjUM9zPmvtM2FsTHmqx3x5HdPGmv?=
 =?us-ascii?Q?rQUjQM99hqcl2ZAyCponbPjWsx1F6tJDvntyk5o+qP0KAqseJ52jkG/RMMlz?=
 =?us-ascii?Q?L8mivk5plRO1qv1uxGV/WVuWqfWyAxCltuYxa+3xaMNUvgHHaT/4KI0gpyCT?=
 =?us-ascii?Q?MScq85RnX9TNLEWlaQyxovKDt188Is3hkLzyOc83NWzgPLbX6Ut6RVGXrKqa?=
 =?us-ascii?Q?cBPLtCSizPl65JLDkE4EkSLh5EzJegi8PKNtNhH0r9j29ShPrA6t2Z8e2s2B?=
 =?us-ascii?Q?vEK7I2bdrJyCg4hFkmd7ZBx+soazi9f9V57csO+HfIVXnN0+HKcHGePZutUg?=
 =?us-ascii?Q?/msE/dIGgeTYzJf6fYlL9fNpeJaBQOj7YmZ8dVuP33/pnh4mE7TRpIGjuXcO?=
 =?us-ascii?Q?Uocu6dfoD5k3TJdNcRoY95w0gT6CNm1zLwEYw0kfa4EdL1awnGAPSC3i9eeC?=
 =?us-ascii?Q?dBgUTAnI30AjmIQCri2T+AeEllcKHiLpzcVHwDxm604m4ceLfhaiTUyvVgRb?=
 =?us-ascii?Q?Tcy+ZtjXIHoVGuPxie4fRj05TfWoza9TI8EfGHZmjvd2lQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RlrMu5nxUPJr4Q16x0KhrxN4uJEZ5y8MdRxRx6ca8fIxWJOLFRJ/p7kVeXGA?=
 =?us-ascii?Q?jca3iq/ft/xj+pV5VFURHfpDf8IR0pTJ9gWAS/AUJHNlbVh7L8CCA4wBst8G?=
 =?us-ascii?Q?6GmOWId6Nbt7x7FbVNmxF+Yo0bYyZakBvcKV839Ow95sSsZvtEVfiDpw7smu?=
 =?us-ascii?Q?K6g9/cjLwwEr1SDnXJkF/9/r5Y+JzThrOeNiGkedpBoRN5/M6IDNa3fpjVQf?=
 =?us-ascii?Q?RSGSss/L+cOxLoDBXUnSkU5hu3G11+nU4IrCPxiqvlj2y7rD9NHfJSOyXtXM?=
 =?us-ascii?Q?9Wnb3CxEHQBkMG/XrWdQ2rrztnUtcjvM4WtXHHeK3IMwtgDARTzWPUahTaBA?=
 =?us-ascii?Q?149rah6pN4J7qRimImj305DslvHhuWLrLrGr//Xg23l5RjaRJZ4aF6ZUcPiZ?=
 =?us-ascii?Q?1DT2kiLNi9Zj4VtPWRiBxe4fMk5fjjPj9QNvF1MBmme/QhztgatSoJfFqXPI?=
 =?us-ascii?Q?hstjCKYFuYy8+cHFePWvcQQj5vEETclveUv3WbqqWSIczZ5W3GGGTaolCEis?=
 =?us-ascii?Q?Z6eUY0HRUOYSGr+Wmw4zQL1augS5gbwJrI9LMEvn/hDPWFZNk+TSb+H2U/Sw?=
 =?us-ascii?Q?gGKMG/D6vgxrLtOl7yc0T8Eyf+uIpObazX+WAtpmYRa4fFs6jfA48aqQ5IhL?=
 =?us-ascii?Q?8OVP9LZm57CsbbkYVC4j3yx3IACpEmIqH7xFGs2bqi9JM5uGJs3DABnM2ZpV?=
 =?us-ascii?Q?njW4DHa7/g3QCz9F9vT0q+B9E1jUedp3bP7QuLgTIQvrA+d6tpOvtPVLS/gR?=
 =?us-ascii?Q?uYcB4fGIivvgNTT6O2xWILfXCrbZs3OLPwPZTjrLkGLQTux+s1H+EOv11rqx?=
 =?us-ascii?Q?27rNbgn++FsvLhVL3u7yiU0XJnEu2Ub223x9ldPvlSYj0j3FyZXhw+gooKoN?=
 =?us-ascii?Q?268pCwA9yiiyeYFjaz7bcDZ9fX83E0wPtLXWdZhbWcf8hL01N6W+wF8LHZVA?=
 =?us-ascii?Q?SzeN1aw/yg1Trs+dAUzgvgcFH9Ngo3BPrQZdG8YYFoxOM+Z5BdpQzWpsf1GS?=
 =?us-ascii?Q?FgDuIUHCTEsBoGzCoq85903Gpq1J8rfBNGMNh32+XdNiiej9eozEvutQBWom?=
 =?us-ascii?Q?3n9nFwU5/NxBWSbbCYOKjuRYaYbyL8/4/nDqPMco34bP6hNzDMet2MSDNJrq?=
 =?us-ascii?Q?fM2QDk0ozD1GEavVzt2hnARQ3S1nVID4Cgpk112AALu1ap7wAOigEdP2x3b5?=
 =?us-ascii?Q?99rhMnoCMInHnoP4Zc61LRK/dEnAvNkWmV0kaWP+zYeggcdWpiKpWoga3hDO?=
 =?us-ascii?Q?OP9amhDIFTYu9gWVNx0j9hfDgBCciFI9WUkEmr+e0Berc2eUpjiWWrqMmz9B?=
 =?us-ascii?Q?+lvkKgPwXc1yfBirDNMxS9mxNNjsLz1ckIuIROqg2oa+D0gsjhroW/+nOw1s?=
 =?us-ascii?Q?VpaBQeE1+GXMQVk++2Tlp8N6KiRSUqHGBIaHlYfDwQ/blVzpxIn3ZsKVxx6u?=
 =?us-ascii?Q?vAJ7RZI+yoeHBqRvp/nAIOvdaWx6V8AwFRYFa4gKeJPLLGsINThSk/GFihtj?=
 =?us-ascii?Q?6q6Kb37jSd9/6F01WS9oDsqiOwdtFcZC6UHs9mdhY8qv7eQX3h0kDGCnQqHd?=
 =?us-ascii?Q?lYxSAta6Di3pHNURjrORT3/Tjg3hIJqqFI8rtxYj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d5c73e-92c8-4f4d-8038-08dcce8b4715
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:47:56.9403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGCNCTKXWWcJ5CqSCFyOqBY+/wJSctkNNSus8fCuUVAWedf3V6CATfGNtNfJKaCQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

The master->cd_table is entirely contained within the struct
arm_smmu_master which is guaranteed to be freed by the core code under
arm_smmu_release_device().

There is no reason to use devm here, arm_smmu_free_cd_tables() is reliably
called to free the CD related memory. Remove it and save some memory.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 +++++++++------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bb6c556995a7a7..c69d50e39b21eb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1222,8 +1222,8 @@ static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
 {
 	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
 
-	l1_desc->l2ptr = dmam_alloc_coherent(smmu->dev, size,
-					     &l1_desc->l2ptr_dma, GFP_KERNEL);
+	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
+					    &l1_desc->l2ptr_dma, GFP_KERNEL);
 	if (!l1_desc->l2ptr) {
 		dev_warn(smmu->dev,
 			 "failed to allocate context descriptor table\n");
@@ -1437,17 +1437,17 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
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
@@ -1458,7 +1458,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 
 err_free_l1:
 	if (cd_table->l1_desc) {
-		devm_kfree(smmu->dev, cd_table->l1_desc);
+		kfree(cd_table->l1_desc);
 		cd_table->l1_desc = NULL;
 	}
 	return ret;
@@ -1478,21 +1478,18 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
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
+	dma_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
 }
 
 /* Stream table manipulation functions */
-- 
2.46.0

