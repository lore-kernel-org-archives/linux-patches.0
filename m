Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012033.outbound.protection.outlook.com [52.101.53.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F031E4AF;
	Mon, 12 Jan 2026 14:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229358; cv=fail; b=tSBPOKiy5XhSU6dLFouQYOhh1RPw7cGfBcGc7AJ0GSV39fl35sjuy++m7WEWsu1rvalhI5pDIHqVpX6hETg+jCfPjdFVP5CBy+COlnkecJPq5Z4C0QYUN4miCUzZaiguwbdLB8Jj+9SWahJfQ20DUlD6Pk5wygok6TN1qGi5WmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229358; c=relaxed/simple;
	bh=9hOH9bUT5qLPC2dy0/Ao52/wieGB50HgRtngOjexTO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AoWmDm0fOnlfLkGU9Y8Eltu6UziFRFbmKX1iqxq68NhAnowt1wPDvj9j/0Xyc4qzRQa4G7LzQSglJpMyjSx6jmXOAm0uCXmN8hXK3Dj8xuHKeKkrEaEER9xIXp8KzlgGP2Nq4JIczVx/7hq04P7+40AeKqHZFp+W94QbRnGh/EI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YTPrvXM2; arc=fail smtp.client-ip=52.101.53.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YTPrvXM2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epKey0cTCQ0CnBuacv+k0kuny+juUwQug1qYy9P6ux3QOqWNdBucpYRAUGJPWNwEwi2UIhK3qTJd/KPp+e5RT2Y3JDK5LJXNkVl1B0qrMkvyBaLvWjzST4tbZoTu3CO4xIG+dU0PDvm0uLYP9jTg/tnDLc8Lcg1QPI0QGtpOsQ6F8OFauNsLxutnm86FZoGFNCybMKTx30IwNTE+Eis+UP6kedid9HHV1gnmreJXKWf2sP2m9fNFCDvgFvetbd/W/vgT/oSYjIX3Bw7n9GZT71peGBrSLVAJHIG3TpYu3nCnvnStLPwOL5p94fX1yjENukvjaAIEomNWGV05PUzJeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfjDx6INad2pLfE5BsCHlG1b3wX5leb1VHW0Hr6O2/k=;
 b=PKvlzFMJJI4BVjIQEvaSVeJFycL0QYk7Iisi+EQU3CQVyhmwwrSue2iyQNOi8Yhdl4NOGYN8V8f0ad080y3uKXVFT6+b2ZU3SsWbMOUE8iZO7JAULIrCJDYbwjRhf6U28BoIiN6Zo5JMsRCzHe6DQkdykrk0aMssn5ohrdyPPPaRUQ6Z0id7fxHcMmJMY8j0rKe3rwyCymK3QFPZ37sTOVLb4QgwmizUOu7YL3GivLfkcGzgGNK8T9YoZ9HyC1V0xPbQVYQAlx/obmLjcYZfr+OocUp8BO+vaySkgzAWghnbDGNKb0HLQERAwrwF53z5M8xJLtHImWyXZ0qhfy13YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfjDx6INad2pLfE5BsCHlG1b3wX5leb1VHW0Hr6O2/k=;
 b=YTPrvXM2SWLezQnONuRPqo9zGI9IjFHJ7xqiIIjudrBDYr1bKrvhD4vpMIL/FDrSlOgTmMwKk8riIUPPGP0D7FHR5pI5OjVqMngMkfNovhok7lfBvInVaNlh+7DIA5lLOFgVWlQ7AzDXosBGyPJ4+/63fHcsp8uOFO8Ft7ICcc9s6iqwVfyf6cdefuhJqi3lgmdglfMqGK3Me0LOMio+WLeYUY3dGjLzwFx8R2jlHya8SvcTuCvqQ+e1P7Gt7rD+FbPy2/Z/epFJ1aKEubV00Eg9QOE/djuNYP47LHPT0PgrW+SveGQVPbkVPCCWp/FHHt6dJa6UU1u2oxogWOpkAw==
Received: from LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:49:12 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:49:09 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 14:49:08 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH 2/3] iommupt: Directly call iommupt's unmap_range()
Date: Mon, 12 Jan 2026 10:49:03 -0400
Message-ID: <2-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::35) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|LV8PR12MB9641:EE_|SJ0PR12MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: 802e1f9f-68cb-47cf-8cea-08de51e9bbd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/khC5VJnsN2lyysIOU4RUKxoC6Yv7D1YioZenGfX4W+elP98xSKuCOlxCnlx?=
 =?us-ascii?Q?98ckJS5xPCe7g+KwPQ6qkZTUjSrFekk3vSzpLTDLZk11y+g9ISe082okQtVS?=
 =?us-ascii?Q?BNyfY++pf5EOSWDJ0t+16QaqXwkTUuGksDq3saTXae6DhM5G7f4zyhVlzZyP?=
 =?us-ascii?Q?OgJhmeEGxm4KQHzyeoFmskmAYut5pcWBcKUGuFrXJLvq4ZjChM1GozSz5nD+?=
 =?us-ascii?Q?H2v345h+wFSOoKk90rvr0bXlqN8UNg36oR6zBjXAa0rXrRHmX5rge26cdAup?=
 =?us-ascii?Q?+2XdjL6qSb7WzH8hiqqn3Ui8lBnn3aAc/pBFqdyaPM3PT1QWUHCR1baMSyRw?=
 =?us-ascii?Q?0+kNeCnDjC4MD2DnhVy7dEfH//le6P5AqGcQTW2TVivhaiaNLvlbcCkFKkfU?=
 =?us-ascii?Q?hjOoC6earDZxr6l/8pwc4tKh36AvcfKt4y6l8vYfqeSbS1MfFuN6MRJkwvtv?=
 =?us-ascii?Q?Vrw6sHv/4g6h4XfWWpF8WUji0DXxBf/+AjBhDVvUSr6JOAzaQOSRylx1w5/B?=
 =?us-ascii?Q?yDvWi0UZAMzJetgB00Yyz5YP5f3YTQ6I9PjsbyA3Pc1mxxIO3mGmA2W/Esfw?=
 =?us-ascii?Q?Iv2m0MfAIE/JWOo6O33ngxzIInTPLuq9MP40PR2B76JijH2BTg7r2PmxFFGX?=
 =?us-ascii?Q?ivJiVneJsrpoDM4QIg/zOBcbWDcUFl5c2IfMgQtAFzpVnHt/nMO588Ah9oT0?=
 =?us-ascii?Q?CWLMvUf92H4r8j2rI+RRDC5pj+QIHCoBDUSnTXd1Y/2iWnAy8e16tY42AzqV?=
 =?us-ascii?Q?ijuGUlljVbUIrBgjvVjxglTpzS4c7B6g1wzZQ5ZHkGTzCHV5bAgV4/UrneZ+?=
 =?us-ascii?Q?mcWPpFYXSTaGBXqGI9s4YWy5zx07OPYRnk+403ORXXL0xfTwPIuTx7pSLvqO?=
 =?us-ascii?Q?KRVjLb6DkxmNuq21J0OYsBOnviRtZ1Rmz4Bamfwl6wp7eb3Zr5U228fDW533?=
 =?us-ascii?Q?A1l6/d2NszjLCCtBmn5s8KxrzFT1hqApTeYuTAx3jUMC57x1gJFzCz1e08dn?=
 =?us-ascii?Q?F79mi/ZUaCKUGztL31OkIdTZgioXQOEinA2Nef3OEzEzlm30WcRokfzFLmY/?=
 =?us-ascii?Q?8Z1i38nwWrQ1EepmwojIiGymBKukVPMUTqQ+WEVx2smTPtiAhSLHINMk9mXz?=
 =?us-ascii?Q?36LZYmUWpbXyGvoaCUcLHXC6W0CxFsh+L2aMmgskFeu5Y5zni7UOSYH3BQjp?=
 =?us-ascii?Q?mTl5vqum/VrhF3sagwAteE+WZOBSV3fEUVDm3u8QZtEmPp3bIpBslKLwpDq6?=
 =?us-ascii?Q?yltFI9bstm1bs8rB6Du0OTTxMBADCbmtGPMnBuZ6aA26auRfryXM3mtHCIls?=
 =?us-ascii?Q?j0OOpnyTU53tYI0rvy/WAbJvGQ8Nuia2RfH8Mpik6sGLNOii2NNhixKRgXxY?=
 =?us-ascii?Q?Psqk/WE3Ysuq2GZ7AU0GXtnak7BZHFm66axo/yrdgWFQ13v/hnJSetigITO2?=
 =?us-ascii?Q?epIg2zc3zWjGG8Bfh9kTQLh03mHp8Ggd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z9fXzcguI1Ab7CgZc/kcAeTvUMbqMMIJjDRICUiogk/cOx2Cvsa0AIsp1kH/?=
 =?us-ascii?Q?WIm/ClLorusaUaYqSVhr6w9bOVo7vMt6ti6D3IlzY8gGxmyrhe5hvm/j/IsS?=
 =?us-ascii?Q?H05CmOxcDodp5Ww04FO1b+4qcwVidDiI4xGCMvJEeUrORgeUzC3t1u5msbI8?=
 =?us-ascii?Q?wpMStmpeuYmEtgDYuMC6TvL79xX20cbHY3LiPuUwqk8dHm2pRnYeaRuW5yz0?=
 =?us-ascii?Q?WxUrNFs8kfdfDibO4YT2mrC9kH+zk7YT9we/2j97TLBzSwNJStlfxPDUIgTk?=
 =?us-ascii?Q?27N3//b3wrLBg5kbVHHuCqIFD3zXh3lM9fN4NxRhqUVxEoTl/bAPgZcQ7CaG?=
 =?us-ascii?Q?q7083P8h4FbyjpdWAo/UUJhKtmjRgj0oNRFNjE3Qn2EI7nbaccLgS39DToAb?=
 =?us-ascii?Q?4i6Jr3KI0dP+m0U4C8wQhm51Hg0Vg45HaeiqsMqGHiKJkUznWb3V3sRdxNXV?=
 =?us-ascii?Q?S07mXIIqGbYiCcHxD1Cv4SMVOADc5wrHAeNJuRtyjG/eFhfcezojboNsLkPf?=
 =?us-ascii?Q?8dkiJPpdtutkp/khzlMZ9C+7wskeDdDNffHnvkhfntaePxNS9Lr9g1IhX5d0?=
 =?us-ascii?Q?UiCoqUWg0hk+XQCm7icKSOGqHekb+1siNaSFj9W8iNeTkXKDOU+LTcRGLvpY?=
 =?us-ascii?Q?NYU44Pa0Bnke5QZK/5bVjINvsDLOSlDft9Uci01rHRGPFsZItjcVx88bZFq/?=
 =?us-ascii?Q?zFLX3I+0JZYYGOVgO4TCn+BVGlw9QUpyjRviqZ3fytipdNxc+oJy/ZG+MDac?=
 =?us-ascii?Q?XekUAOHggvPjFSeI7nSPY6bePl2rWPWwWvkSf5arL30wtvOIIcYnYD2dlHAt?=
 =?us-ascii?Q?TDzuFpbrFqeUxNXPjHtMEPkLId9xoDi2N50RAFwhqZLXDEDim2PoKDmgDVSF?=
 =?us-ascii?Q?Gp7AU7kxdhvNRUErc61CTOTduJJaO6qnzyPkUIMnfCVeUh2vzkZrIsRwX66R?=
 =?us-ascii?Q?6V5pjlzSiea0KRNOGdH2MYzDwXMDTNhsPE6ieruQf8OtqTr0ShQ1/LwbFGIH?=
 =?us-ascii?Q?8OakLjwuY0y4fPBeG7TLJ69EJmhVbvRLjWtsIm44kiOqA5WlWE0FivOfLO+x?=
 =?us-ascii?Q?18fEFrDMZC/Wt4gpAZoAF3L1NOzQgHGb/LliOOr1Cgi5egj0M5YsrJGfZwwK?=
 =?us-ascii?Q?HUV/BoP4a9Jojx6QqAdHgXxhKTRTzU3GjlOaJDEJJj3V850czIPEPuKKFCr0?=
 =?us-ascii?Q?rCRmiTm4ioAA2RVnSaQUZt6iIcVj5b8WeCOdFDMDsHU3qS3vE1mNmEzw3Vtv?=
 =?us-ascii?Q?DWfyEr6AFPM+g/uFO9K1pEVTqtkMpJWiMF+NTWPWDEWdiRJMwYWgvu9ZKna2?=
 =?us-ascii?Q?Rk8t4xfBYCPctH/f4UjQLDN5ixScNl1r/rleYc7z16cbU18/OtoqLg+LbF5/?=
 =?us-ascii?Q?5sCt3L8Z8ksza6pQ7LL543YecrWTyDg4iWVHYm047k9Z7NHlinNmPo9Mw/H/?=
 =?us-ascii?Q?sw128GLKpjCQsn1BfgIFWHZwKTeds/w43OpGcyZQXxRu4LzsB1hctqId2w2+?=
 =?us-ascii?Q?BR5absNQyWH3II6+gne8i044Q1O3QuEXub/O/rreNECytejvTCayUzfVtVLw?=
 =?us-ascii?Q?1X4XfBYCCpWLdxg4tsTTbXu9aEC9eWJD0TTRGw8pNFCqatcM35/IT9D/z4AD?=
 =?us-ascii?Q?awbJpWWc5kBDT0bJhQ+f40018xDUfGcZxdFGfz5UPtSKiQ5ydDFxybOVv1GO?=
 =?us-ascii?Q?5/PAjq7eNLwe/Xq8tauGoMnZ54oFK/PzNuiDz/a7ymopKXe6Mcnp70bZ++3E?=
 =?us-ascii?Q?EXQrgGwX2g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802e1f9f-68cb-47cf-8cea-08de51e9bbd6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 14:49:05.7454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+LgPKU4+qtmEhJMEqOqtDTzv8Y+Mwqpfg5M31IJsYGzojHy3eEf9T9QIXaPjKHZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066

The common algorithm in iommupt does not require the iommu_pgsize()
calculations, it can directly unmap any arbitrary range. Add a new function
pointer to directly call an iommupt unmap_range op and make
__iommu_unmap() call it directly.

Gives about a 5% gain on single page unmappings.

The function pointer is run through pt_iommu_ops instead of
iommu_domain_ops to discourage using it outside iommupt. All drivers with
their own page tables should continue to use the simplified
map/unmap_pages() style interfaces.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 29 ++++------------------
 drivers/iommu/iommu.c               | 18 +++++++++++---
 include/linux/generic_pt/iommu.h    | 37 ++++++++++++++++++++++++-----
 include/linux/iommu.h               |  1 +
 4 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 3327116a441cac..5c898c01659798 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1012,34 +1012,12 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 	return ret;
 }
 
-/**
- * unmap_pages() - Make a range of IOVA empty/not present
- * @domain: Domain to manipulate
- * @iova: IO virtual address to start
- * @pgsize: Length of each page
- * @pgcount: Length of the range in pgsize units starting from @iova
- * @iotlb_gather: Gather struct that must be flushed on return
- *
- * unmap_pages() will remove a translation created by map_pages(). It cannot
- * subdivide a mapping created by map_pages(), so it should be called with IOVA
- * ranges that match those passed to map_pages(). The IOVA range can aggregate
- * contiguous map_pages() calls so long as no individual range is split.
- *
- * Context: The caller must hold a write range lock that includes
- * the whole range.
- *
- * Returns: Number of bytes of VA unmapped. iova + res will be the point
- * unmapping stopped.
- */
-size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long iova,
-			      size_t pgsize, size_t pgcount,
+static size_t NS(unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			      dma_addr_t len,
 			      struct iommu_iotlb_gather *iotlb_gather)
 {
-	struct pt_iommu *iommu_table =
-		container_of(domain, struct pt_iommu, domain);
 	struct pt_unmap_args unmap = { .free_list = IOMMU_PAGES_LIST_INIT(
 					       unmap.free_list) };
-	pt_vaddr_t len = pgsize * pgcount;
 	struct pt_range range;
 	int ret;
 
@@ -1054,7 +1032,6 @@ size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long iova,
 
 	return unmap.unmapped;
 }
-EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(unmap_pages), "GENERIC_PT_IOMMU");
 
 static void NS(get_info)(struct pt_iommu *iommu_table,
 			 struct pt_iommu_info *info)
@@ -1102,6 +1079,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 }
 
 static const struct pt_iommu_ops NS(ops) = {
+	.unmap_range = NS(unmap_range),
 #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_is_write_dirty) && \
 	IS_ENABLED(CONFIG_IOMMUFD_TEST) && defined(pt_entry_make_write_dirty)
 	.set_dirty = NS(set_dirty),
@@ -1164,6 +1142,7 @@ static int pt_iommu_init_domain(struct pt_iommu *iommu_table,
 
 	domain->type = __IOMMU_DOMAIN_PAGING;
 	domain->pgsize_bitmap = info.pgsize_bitmap;
+	domain->is_iommupt = true;
 
 	if (pt_feature(common, PT_FEAT_DYNAMIC_TOP))
 		range = _pt_top_range(common,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2ca990dfbb884f..000dd6c374877b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -34,6 +34,7 @@
 #include <linux/sched/mm.h>
 #include <linux/msi.h>
 #include <uapi/linux/iommufd.h>
+#include <linux/generic_pt/iommu.h>
 
 #include "dma-iommu.h"
 #include "iommu-priv.h"
@@ -2596,9 +2597,9 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
-static size_t __iommu_unmap(struct iommu_domain *domain,
-			    unsigned long iova, size_t size,
-			    struct iommu_iotlb_gather *iotlb_gather)
+static size_t
+__iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long iova,
+			   size_t size, struct iommu_iotlb_gather *iotlb_gather)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	size_t unmapped_page, unmapped = 0;
@@ -2650,6 +2651,17 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 	return unmapped;
 }
 
+static size_t __iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			    size_t size,
+			    struct iommu_iotlb_gather *iotlb_gather)
+{
+	struct pt_iommu *pt = iommupt_from_domain(domain);
+
+	if (pt)
+		return pt->ops->unmap_range(pt, iova, size, iotlb_gather);
+	return __iommu_unmap_domain_pgtbl(domain, iova, size, iotlb_gather);
+}
+
 /**
  * iommu_unmap() - Remove mappings from a range of IOVA
  * @domain: Domain to manipulate
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 9eefbb74efd087..f094f8f44e4e8a 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -66,6 +66,13 @@ struct pt_iommu {
 	struct device *iommu_device;
 };
 
+static inline struct pt_iommu *iommupt_from_domain(struct iommu_domain *domain)
+{
+	if (!IS_ENABLED(CONFIG_IOMMU_PT) || !domain->is_iommupt)
+		return NULL;
+	return container_of(domain, struct pt_iommu, domain);
+}
+
 /**
  * struct pt_iommu_info - Details about the IOMMU page table
  *
@@ -80,6 +87,29 @@ struct pt_iommu_info {
 };
 
 struct pt_iommu_ops {
+	/**
+	 * @unmap_range: Make a range of IOVA empty/not present
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to start
+	 * @len: Length of the range starting from @iova
+	 * @iotlb_gather: Gather struct that must be flushed on return
+	 *
+	 * unmap_range() will remove a translation created by map_range(). It
+	 * cannot subdivide a mapping created by map_range(), so it should be
+	 * called with IOVA ranges that match those passed to map_pages. The
+	 * IOVA range can aggregate contiguous map_range() calls so long as no
+	 * individual range is split.
+	 *
+	 * Context: The caller must hold a write range lock that includes
+	 * the whole range.
+	 *
+	 * Returns: Number of bytes of VA unmapped. iova + res will be the
+	 * point unmapping stopped.
+	 */
+	size_t (*unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			      dma_addr_t len,
+			      struct iommu_iotlb_gather *iotlb_gather);
+
 	/**
 	 * @set_dirty: Make the iova write dirty
 	 * @iommu_table: Table to manipulate
@@ -198,10 +228,6 @@ struct pt_iommu_cfg {
 				       unsigned long iova, phys_addr_t paddr,  \
 				       size_t pgsize, size_t pgcount,          \
 				       int prot, gfp_t gfp, size_t *mapped);   \
-	size_t pt_iommu_##fmt##_unmap_pages(                                   \
-		struct iommu_domain *domain, unsigned long iova,               \
-		size_t pgsize, size_t pgcount,                                 \
-		struct iommu_iotlb_gather *iotlb_gather);                      \
 	int pt_iommu_##fmt##_read_and_clear_dirty(                             \
 		struct iommu_domain *domain, unsigned long iova, size_t size,  \
 		unsigned long flags, struct iommu_dirty_bitmap *dirty);        \
@@ -223,8 +249,7 @@ struct pt_iommu_cfg {
  */
 #define IOMMU_PT_DOMAIN_OPS(fmt)                        \
 	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys, \
-	.map_pages = &pt_iommu_##fmt##_map_pages,       \
-	.unmap_pages = &pt_iommu_##fmt##_unmap_pages
+	.map_pages = &pt_iommu_##fmt##_map_pages
 #define IOMMU_PT_DIRTY_OPS(fmt) \
 	.read_and_clear_dirty = &pt_iommu_##fmt##_read_and_clear_dirty
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 8c66284a91a8b0..0e8c9d31796bfd 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -223,6 +223,7 @@ enum iommu_domain_cookie_type {
 struct iommu_domain {
 	unsigned type;
 	enum iommu_domain_cookie_type cookie_type;
+	bool is_iommupt;
 	const struct iommu_domain_ops *ops;
 	const struct iommu_dirty_ops *dirty_ops;
 	const struct iommu_ops *owner; /* Whose domain_alloc we came from */
-- 
2.43.0

