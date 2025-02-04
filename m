Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2407F15252D;
	Tue,  4 Feb 2025 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694109; cv=fail; b=Zk/VX050UFy0gMDOHavU4kVUDh4IbrzIz7kIJE2uSMo7XPLlGW2IVNgIyJ0ywyJXAS1lyh4zGponyJ5U4DBFWut9E7sy+lgrB/ZAoiuLcmEAl9MUJvFgeq4QD4qwt0FbDiQrenv205WAQQNU5WVJt5RrJOAwjrYx1b6RIN1E8rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694109; c=relaxed/simple;
	bh=QnJA1X2KJKZGLVQMnaZOCDjL6w0NeBhzN7oWYPvo70A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DMyJviHoXqMBXkyoIF/QHmFMD4fbooncgmzgm9q5q3DddfJSIGJeu8J0z0re4q7FjlDWlg+zhmCC5P4G7pXw5tsYplmgfgocFOdnk+by9a6SZye452120h/e+iyBdAIL5P1HM49UpuZheQWjjkmqDUzKfayfYcSkoWqGo12glok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gSALZEGe; arc=fail smtp.client-ip=40.107.212.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gSALZEGe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TrmVtE4zLmxO4y2eGFxW0Qy5R/dVa8XKbszmthIFHdiWRcMmvDTKXXZwOKblr5UE4waTf68N4YcMWg2RvGCAeomVzgt5mnN6fRKG0L+1hf5Tt4Xh+U3B29xEuE46XyWaADd/nSPwGwvtiM0YtYBxVS3jKwE17ad3z9QN1y/u1kwTRJHhXUl+17cW6DwSLpCt84EUbKSX7vfnGrZC/RJJwnpHwMmYrQXY8FoCSYeF48Wg358ywDGyZCc69WoCQbe0je/tceLtb6mmiFXnNvIn6XvqrhXXOphWbs7cztG6d6YIF6QRqNB1D3SGIJQw90qjc6cuut2SxdV1fecNxfiQHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WELpJiWBt9FPkBmSH9Ivg+v+ohTp7pdAXlRdIJkfMpk=;
 b=homeURRK99ScBJLAdlH0xXJfz6f8F+PBZytYha89eKLrugvx+IviO/M7K9edntoZh633sX3jhDWbboytk4J6qRthRebH866+iLlwtMvxxq19FLZzm0diasjAOwrWorN9P8Z1KuFLTcbAQknQ5bhYOF7ljV9mUjY47JbRdpPPYFmodLU9b1wRidLd1hdqCCi1Wt5IBsyW/ufJSGZg0TFeTE644S6i/h/kAqXwiwX/LgqUmPNWfgVqXUprHB8mL5WH07n95SmQN6/ULXa9+3UAlNLOXd9Ar5n2A61zhzw0bdtoqL2dILEDNxObc8t6Ktp8mt5tC/JSwwLuP8Dj9llPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WELpJiWBt9FPkBmSH9Ivg+v+ohTp7pdAXlRdIJkfMpk=;
 b=gSALZEGezIZ8t8+gzeFLpXhEnIAr4MsHNBXmna1zWxy/3nRGaCY0kOIuZI3LSFHgPtq6UDhPPhcX5fXn1q50Da9wm1+iPpxQipt42/os72bETNSCKq76bIrih82HJO1bbyOVHx0s8NQk1dV4BUbxCbU5MjHhVEdn/HqoFO/ck1CMTkmnWDJUiXYHsCgK3twFnpG5OaS/SsXQUSEdZTCTy51DY++ABkwLVJHfuhPWWTYNHXG2igkrRw2UGawTlk9mbxzNoy8yrO09rxVretOaC2mvR72NmDSOfXZ3oUmGodqiCf7eCUgHOVCtqfu/sQiAew4hMmqB002PyXT/tJ4Yxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:03 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:02 +0000
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
Subject: [PATCH 07/19] iommu/vtd: Use virt_to_phys()
Date: Tue,  4 Feb 2025 14:34:48 -0400
Message-ID: <7-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:208:23e::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 636475ac-49b8-4009-6e92-08dd454aa2f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WQXcRJ5mA0vrkruIN03bSpgrG4qAaUWisnjs1chgJO7S/Rzi9l9/vK+IZNZL?=
 =?us-ascii?Q?8umrHap+ykN0Yry4NKmJhgO0YCIVho/olaHiFxYBoUaXnQs8yL0ZYx724PWk?=
 =?us-ascii?Q?ciGRB9OOEe7n9Jjvupa4mOzJLRkg2D7hu+W2Q112ZyqJVITUPOBnq1dlG246?=
 =?us-ascii?Q?HVyUx5MMSRYE97n/KxR13f5ZjIxYXqMFJ7IxqfT93XpfLFoAAJM0kVrgv0j1?=
 =?us-ascii?Q?MQw8oKYTIv7QOAJEK7RwtljJHJNGr0KTNKFFCi9spu5YrlBoyjlRzvS1/U6C?=
 =?us-ascii?Q?2li0cL4O1emUOjuQeCR8lP0iRu5l1AuZKM64IBBSm78pSFyf826evt5y6wA0?=
 =?us-ascii?Q?6q7OSIlLa/37l8NKeJvrT9S9XdRbQSUhvC29NOyX8pf+tcJxGfiKYBoBTPEf?=
 =?us-ascii?Q?AmUHDhEKUj0wbYstXYOPqL8wTC28KdQNl2y5/QIhbgG19QHFmyAtuELWR70n?=
 =?us-ascii?Q?3/Tss3DabjH2HDuAjvjHIcLBEYCxKHZfQMSbGB/wtEhNQs2qKNiOCPnoLbaL?=
 =?us-ascii?Q?tNvdZUO3v722TL4U7v7wB7b0lK0u45p08FBfSnOTjQ5kwtTfHfE3VNOYlv4M?=
 =?us-ascii?Q?vgz+MTu67Oqoy0gk2nwXQA9O+iKHX+ijj5oZtO+StFS6IWpt6jtOwW8JxJCg?=
 =?us-ascii?Q?xKIpPEmpkJOY/66vo/4zZy2RRpa9R6PaRZjG4f/lWivKUkz9K054PxLqwmOa?=
 =?us-ascii?Q?hHMLLExWoUkK2sChNv0OdsVXdQsyx06SpC2/vntV+St2A2vWNo5V1/M1c4xE?=
 =?us-ascii?Q?I6jiz1JFkj+ZrFW3N4TPRQFSFsVZvl2NChEfA+72BZJC76n83CYqHsrCkjnp?=
 =?us-ascii?Q?JF1IY5r/vaXGeJC0iCBvySZ9XHZXIj7l7ZWJ3xMJZFc71NuXI9+WrzitnvZb?=
 =?us-ascii?Q?+siEuP7m50ZTtbnE4QSzvRw9ynj4JHyU5dchpsOf6H2WbtXy0+idJNVaXl/S?=
 =?us-ascii?Q?KW81aszIeFXg8tyhOHqCsKHymuM/xcwXBXU8f93Z8rvb6UBXInbl7WFbx1+Y?=
 =?us-ascii?Q?Iam+aj7wCeS5r8aI4v1sW9YvZpJVEoezkeUT5L6Q/QqmHFut7uO48zzRvkGp?=
 =?us-ascii?Q?gA0BiuWMFNOIcLxhpP24kuOtTfw8xue2HmKooY9XDXRLCYzpKBnFC1YqoUUZ?=
 =?us-ascii?Q?KOmf4JjuJMbWozns2+YuWThC3zAOuUGFlPlE1zKXjw9d59eWpxkk8jD8alxN?=
 =?us-ascii?Q?mey9qF0tq/zLOhfUwyKh4FpHpilmNTGs5Sji/9icvFl+f16+cZf7gwwfAdl9?=
 =?us-ascii?Q?9D9dueQCUZqWGfDJpYhWF2y4Q5P1ZrCAeT0UjMWbVhi4JvwYWNDNCyHZ84Qq?=
 =?us-ascii?Q?9SOX07HqMpWcBV2VFHP6SUUr+ejqqPquIoo2qpp0iDkMaewjy85EbFtL4bjW?=
 =?us-ascii?Q?rooA+7qqpsoJDg9hfGFoiMWaLtwRWIofsfAHieHcEFqvb07WEIaJLsaKTHLN?=
 =?us-ascii?Q?NT9JTc9M1UA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eepJ3/PLtGi3mV6UqS1lRmnKQ0Ydr9/mxcFh4C7FrPf8/St54Ad218JEo14Q?=
 =?us-ascii?Q?plVY6xbgsxYFCxdsmTKRMeqo0VGnEKIu1K1D490OElhdbIlP9oXmxyVbobWY?=
 =?us-ascii?Q?yGo94sW/fLuU9wFMjLFyCltZs/oi86rIAXAyDZsS3cZz4FVf6CzwzBW8BRty?=
 =?us-ascii?Q?tLYOrYmKUJDZpk8wqiHci4KuEXhNG8NwimVL/8i+xVOGsSKW9nb/xnGpQzdC?=
 =?us-ascii?Q?03SQ7RteqJcmO1LK4IT/arRi1LR/Aw7cpZ5aDnrTpdx7qsTL0pJVqjfLHK16?=
 =?us-ascii?Q?ICVXrp+Vyts5kZeJ0bDrdnZyYxi3Y8dWZF/a70ASJrLFc8awozzyJB0OaLR/?=
 =?us-ascii?Q?MW8DMqm2ZeQrSkKFEjSQZfTK6ewriOo8wKdN7Vq94OnAcjrHA6IeMMUUW+LR?=
 =?us-ascii?Q?M/bJResopie3tlpAHCo0isPctd462TxTtLniZmyHy0ivM6T9xjHYFU8JKBQ5?=
 =?us-ascii?Q?OvhaOWjTNOz30krXIT362Q2YrbNURDofqB42pwLTnm6ZHhZRl7iNMqOHOpD8?=
 =?us-ascii?Q?fvrrW01GAOJiTmJMmkHkDDvP+MSGnyofmUtfxCcqo8eNGKz/2WTjeYtZfvb4?=
 =?us-ascii?Q?Dc/OEEshM+gTlWSeFLRyxyUFh0qfkOmet0EmHFY6q7/4/OVcxETtEUNhmtYs?=
 =?us-ascii?Q?/SmCduz9dfV+MCndnIyzWmCwolm8Ziw9SprqjjJwY7quSJnRg2bUEKbft7CT?=
 =?us-ascii?Q?GDGHIN+7nuleulIvwQmN0wcL1ZmIgVMceBFA/RkrVYWxqUrcBMQSfQYJ+ntD?=
 =?us-ascii?Q?3G3eTY4AclDnqfL+Y/aHzpUhh/hOOwaI28ize6+OfTkfscwHS6VjBBl1CmGM?=
 =?us-ascii?Q?RareGcoAJrs+I0FERPxi9yqug/r3cAlEUqdgeod+QuDVmj307P7mPM0C69XZ?=
 =?us-ascii?Q?3oOLZdhRosWrhBqCuJM2bzPCFcS55pynevyaz3vQSiIplmwyPeUUhqxuyKJX?=
 =?us-ascii?Q?Y94jxXyPLjiDX6iojjoaLwPIasz9AXXuyAY9Y6VvAgRGI0mLxihGjF1BZTpZ?=
 =?us-ascii?Q?C0B3liX45u8YugXaYJn2f4ZRmZ2KU3kjxyBAB7sb7+QDSvr2PZ5vvTTjr+/F?=
 =?us-ascii?Q?4AKEpoUMX9igx8zOSH0un5RmKvCAuw6aHXSILiHyMHIWXkaesLnk0EKDnppS?=
 =?us-ascii?Q?l/RUm0KlQQZrRy03xV6eeXkMek1cvB6djAizNLtktH3bOoXBW1gDEH/r+yUZ?=
 =?us-ascii?Q?bJp9HlAXKAu1eB1toaft5i7aThIMXfrvk24rrETtPHIxWoWC+X/AkdcNzrwc?=
 =?us-ascii?Q?IJNAbXNYOaunSqZV8UbJ0RbQYAPX61B9Eg/aOpo9bQWNTi/tMKWcGhhtthPj?=
 =?us-ascii?Q?/G6DxI1qFL9lph1qvGNaaS4WrxwP74EfIsZ8WPpk6NUn9dm6bYIAoKg+gmTQ?=
 =?us-ascii?Q?ecyfHWhr55wqucn9f8iAP1fpp7nA6xDG5ggVvU1UVWyx8GqmRGrvv+bWQ2kk?=
 =?us-ascii?Q?JsfJXpL17GtSZKsh2XDC+zMFcYybsyOK9wjQu1Il/FAGDuXJjr5NDZtEDKCE?=
 =?us-ascii?Q?DilfwX+uwGaTHsNWC84z2EsK1ef5J2t2TmrXZoR9X88p23lTymCKBxM2AE/Z?=
 =?us-ascii?Q?GzXdXQole3zfRtqOuf+7DAa2Z2tpf8SDdSlSzKXf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 636475ac-49b8-4009-6e92-08dd454aa2f0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:02.2507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XQt6vbnvCn2akuZAsLNwJzTjojaXYmv96rzmGvBXuV3MzPChfO8MdpUE9Jgfexvx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

If all the inlines are unwound virt_to_dma_pfn() is simply:
   return page_to_pfn(virt_to_page(p)) << (PAGE_SHIFT - VTD_PAGE_SHIFT);

Which can be re-arranged to:
   (page_to_pfn(virt_to_page(p)) << PAGE_SHIFT) >> VTD_PAGE_SHIFT

The only caller is:
   ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT)

re-arranged to:
   ((page_to_pfn(virt_to_page(tmp_page)) << PAGE_SHIFT) >> VTD_PAGE_SHIFT) << VTD_PAGE_SHIFT

Which simplifies to:
   page_to_pfn(virt_to_page(tmp_page)) << PAGE_SHIFT

That is the same as virt_to_phys(tmp_page), so just remove all of this.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c |  3 ++-
 drivers/iommu/intel/iommu.h | 19 -------------------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index cc46098f875b16..688c0e86a8256e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -737,7 +737,8 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				return NULL;
 
 			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
-			pteval = ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
+			pteval = virt_to_phys(tmp_page) | DMA_PTE_READ |
+				 DMA_PTE_WRITE;
 			if (domain->use_first_level)
 				pteval |= DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 6ea7bbe26b19d5..dd980808998da9 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -953,25 +953,6 @@ static inline unsigned long lvl_to_nr_pages(unsigned int lvl)
 	return 1UL << min_t(int, (lvl - 1) * LEVEL_STRIDE, MAX_AGAW_PFN_WIDTH);
 }
 
-/* VT-d pages must always be _smaller_ than MM pages. Otherwise things
-   are never going to work. */
-static inline unsigned long mm_to_dma_pfn_start(unsigned long mm_pfn)
-{
-	return mm_pfn << (PAGE_SHIFT - VTD_PAGE_SHIFT);
-}
-static inline unsigned long mm_to_dma_pfn_end(unsigned long mm_pfn)
-{
-	return ((mm_pfn + 1) << (PAGE_SHIFT - VTD_PAGE_SHIFT)) - 1;
-}
-static inline unsigned long page_to_dma_pfn(struct page *pg)
-{
-	return mm_to_dma_pfn_start(page_to_pfn(pg));
-}
-static inline unsigned long virt_to_dma_pfn(void *p)
-{
-	return page_to_dma_pfn(virt_to_page(p));
-}
-
 static inline void context_set_present(struct context_entry *context)
 {
 	context->lo |= 1;
-- 
2.43.0

