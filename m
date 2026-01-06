Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010070.outbound.protection.outlook.com [52.101.193.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FFF34D4ED;
	Tue,  6 Jan 2026 19:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767727341; cv=fail; b=U0hnMpY/fkLTnGL61ziA5xZjIu8f1nDyT4sSW58/jM5FUWhpeuKqfTR2jFxMlFopkpqpR9K4kI1wSqZl2OwZ/OpS6TtGDacObh6yod7xKv9tIF5f0b+92Wbxuce7ESgzv8ntQZ4yugw5WDoIEHLPBNxbqsa0gMyx5zD9pBBwM70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767727341; c=relaxed/simple;
	bh=u2pMJTLmvOZvkmzmkYEh2yz0K3Wl2WmgMl5vXkR4B94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UeDF7haJT0qvMjR8HIZGz4BSMN92HDmJu9J2j0Aov56ZmdUdw3srKjyWPUOoDnzJm8TP3a+A/bXi9wE0o9W/LzesNQ6gIb7heeiFb5fcxWNZga76rDcRCxubNAkLT6W3uE2d8yv9MSl9zXE7uafnXLaPz2pDtdjnH/J/hPG48fk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tpNejLlh; arc=fail smtp.client-ip=52.101.193.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tpNejLlh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wOgHKjeNfqudVFBMsSoaY/+sRqyq/AdqYQ43pu0bDxYR1fdocC1V38qMCxIBKb75QjqXQnvaPFpOEhSv5YLZqJxcoctype0AvhgF7w/iJoyjW3ifHAHPigqI8v6kSB965mOt8q88U32/3vXIY/js/CZm8PPek3F3HcDUKTxeeoZdmoo+9OHKRGnfZ21sT3h24nlmxjgUMyDi94OCaaGQOY6wCZbt44Ej9/fqj1l5Qqp8RPomLzDRoq0SutmNdprnpmpUJaK1tNLJTRhxPWKXo/k4Wcgkj+66juvCEg5fqvJ+P11r0sH4D7uX5csS0OQnamvEeV3owFGq0z31Dbqo9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2K8NJHvixe07z1Eo+Ck+7cAO/8F4UvIwlyGJWNEdqvY=;
 b=XsBUzkht9gy1vCfyItScmdYcZYgNbyb1bKJOy0B2sU+rr/TcdcMmmy0IfHEAmFcSE+Z6J2O5dnK5mkf1HIUJ5wqHgcVab4MCO4FAxW7kTItSJt8l7gs4MtCvrtSHbNAofm9tucmHD6lgbg+KTIJrbnx6ssplBJjMvfm7mGIsqTGLn0Ndjm+hCjJGhxGBbFumvIN2GDJOg/Zgdtx8r5to7DPsSwNghEAfjI5Px/3PFY5f/wOKCOcf4ykA0tql/7LDgWvkNTvuUKFapqa7f230YAE4t9/73hWRlcXm+sj6x9MA/1Nf/EWj5Fb2kFnuFuUTfIhMSLewaeeGezWCHVUMZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2K8NJHvixe07z1Eo+Ck+7cAO/8F4UvIwlyGJWNEdqvY=;
 b=tpNejLlh1Ca2U66ZyqouFp2KDD8LDzNNLfH5oXfNONyMidJ/cvna9GK6VCWKIuqX/lKS18IrziTxsZuA8GWsfA/AbE9pxXcrm4jQBO2KUdAVGdOV8zqWzQ18yULDBd4MxRFlNnNtxhkBynbY9DyTZwQxly7ODnwhY/WXaJ3lHhEYwgATdi6AC54O8nYpgQSiumTRFwk43lxHqSTRZVbvw5JIMCH2ANfbs3x7pTt0qwmxkcWkObufMe8nechty6WYA4/c+9x/7sFUDQTU8Bvs+q2+dwZAl02T5gN1aqlBwLmOlPC5GnLeCuq5ouv/iT6TWrVitMb703XP2E6W+f3/lw==
Received: from IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22)
 by DS7PR12MB5981.namprd12.prod.outlook.com (2603:10b6:8:7c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 19:22:16 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 19:22:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 19:22:14 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH rc 2/3] iommufd/selftest: Add missing kconfig for DMA_SHARED_BUFFER
Date: Tue,  6 Jan 2026 15:22:11 -0400
Message-ID: <2-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
In-Reply-To: <0-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0318.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|IA1PR12MB6209:EE_|DS7PR12MB5981:EE_
X-MS-Office365-Filtering-Correlation-Id: 77c92f98-0dbf-4f8a-3133-08de4d58e544
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ncGfM2e8Gy6IpIR7gCPO/nPyelnrd91S1rbsF8cmK37RctnJCBcI9qIWg4az?=
 =?us-ascii?Q?lmQtKGAzDMIs5QBAtC9du8nMHcQqdAADCZHd6ALAcsZkWES5jcw+mfWU798g?=
 =?us-ascii?Q?ZilI1Si/qmuioWmRhXD5T7GZgM0hdUx2+odlYfAmjgcwgE1fyZxM1Oq7ky8w?=
 =?us-ascii?Q?VCXYgm0o2arNwXv3jXPApeGmFvUW1sc1xI+jgv6NSJT8e9ctPXEVQ2v7NkSv?=
 =?us-ascii?Q?QKdjYPKjUAZyfcQE0DlVuS9yykI0Gtg58c+bZXFHCmTD333nn+A6w4gMJ+9v?=
 =?us-ascii?Q?EBydEqCEdZ1T+zqTB/QaZk9VOD/gq7tsY6lOIyxlvzjK79fycgzja1ZLrT6Q?=
 =?us-ascii?Q?jqFcSV2zrWAY6bFjDL/6Sqa9bZd7mKnCSGDUjm9Pt9Yst2QKQb7de4U4+i2N?=
 =?us-ascii?Q?SCFD4clYMwSRmXz8R1/ETAkNzxYt+ekr2egOprtidTM5EpLVacSia1fFFjGl?=
 =?us-ascii?Q?pJdp/P7zv5CvtmGjbtLuEkv3dx3N1zsq9CaBkkkowbpPZaPgb84u4aPQ6OFP?=
 =?us-ascii?Q?tuKF6+SiLu84c6/IDQ0Yjc28Ix6NsrtKqI8JaUn3U5UYgtdIwu54MGOP+GN9?=
 =?us-ascii?Q?+64Wae+xFxvOnPe6pd2wa/2yfKmeAm2w/FpApSVsVjftBRqUw6NSmGu66/UB?=
 =?us-ascii?Q?kycUaA+9lZ+MovUb4Mip8+a/I5DrbkoKiW8qgAsxsJkeQguRbtu4REBSqaxv?=
 =?us-ascii?Q?Loix4SZ8u/sM5B4lintlnjzBAjF507or0FhrbkSDp1L6gxMVrCPbMXIXSqL/?=
 =?us-ascii?Q?+3h6KJsYERGYOqC3LN9ygGFRW595aKrFrNniesuD6YIzU5BMtXyGThxh3oX3?=
 =?us-ascii?Q?0NUVZwuXfWQLfjtO64leXIY3rzAgx0zN1KYfzuj7cskbM16SGX/n140QHBMw?=
 =?us-ascii?Q?QG7+Q5jAJUrptt8LhWNicJZgXd9iV16J79dVY7vFbjktpOVz+6CpNwZXqqQF?=
 =?us-ascii?Q?tb0qIhIxECInSxR3vhOieUWAnHR7c9NhzcUDY3s0uCtDaXLAPXHV3snCG/bw?=
 =?us-ascii?Q?ygxfdKLrSdF3+hBmtW2AqTiQJWLcq/7DjoBWLQLRCfttXSjc+EbxPnsiWeI5?=
 =?us-ascii?Q?c9n02L5u9IlHw+ZOpuBXEvjTDaM6hpcbUJ+se1pF5xLSkSFspSFA71WRdoRa?=
 =?us-ascii?Q?0lRilNcmgPxntd+4Kj2Nmw65Us7Ja4wZrd36JoUz6KfJVktuuXsBeQtLwwVW?=
 =?us-ascii?Q?R94R8h+wej0tKJR68eQ3mxNlQMXHfFIxNyV1n81K9UTeYNib6Kgz52y8VEsE?=
 =?us-ascii?Q?2OSKggp/UzJF6QNCuQScz00Z0Fao9YVgNilSWMtbSId4nls3cXdNZrK5L4n1?=
 =?us-ascii?Q?u9RR/4dOCkHh8V9VGBdEVSf9y0BhME/kVFH9magS0Uz4xtaREc9Hc+hugM29?=
 =?us-ascii?Q?/PsQVaRbn28O2vca1jjS57U6r6b5dVgPWQ9R2g8JShmNeoZnrgpKchCX7Jr8?=
 =?us-ascii?Q?MNQyUPJzBF6dGQQDFvdH9awWeLYjMCqH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V+GUOUzzyvMr69taMCh00KEP5Z+9kOHnY3wprF3dzv/p/SSyarlLYpyaIT7e?=
 =?us-ascii?Q?dsRGXVw1SfZympcFpHjQyjs1elUEUc1+au+mFhaNkrL0KRNLwJTr7fMQH5Nx?=
 =?us-ascii?Q?z/Ry9FhXn6dnOjUUalrJD+THmxdZD5xJP0IEp5MWSZHDyxZwvYQiC3JNnzhh?=
 =?us-ascii?Q?flnrXy1o2azuJME7emutoBByBFi8jYWrM2t4dDZk66noGslyRdy3qz7vYqxe?=
 =?us-ascii?Q?PJn/DYDsKU8pAHqinJXMs0Lhv6dg5nCLbC9l2W1zdSHZyuBcwOYFHAON5cP3?=
 =?us-ascii?Q?nn2yhiynhqt5wMV+ZlRfHvjnwrO9afEw6sFMzhatYBzt9X/s0Zzsszpwj8L9?=
 =?us-ascii?Q?zT07lRVVyEj90ZMrRc6BKp92YVjFD3gySTa9/UHYPjCRCLc4pCHSNC/G1Uah?=
 =?us-ascii?Q?/mpVeoHaEYTCjFiIXddfdMcRq/PYWTGrkjyvNWANeBTKMp9jAdYcFTnrFMKK?=
 =?us-ascii?Q?pm/Jeodo98wC7bBuQDsYCe3I9gMTXnwbGq9oeTXdM1CIDJNUqf3qsnydadFh?=
 =?us-ascii?Q?obapxARYQjJDJcZouaX5CH5/XNo681Lr8pdOCJ/79mxdpJyI0Nw8xCiF0UMy?=
 =?us-ascii?Q?y5+vDJAn1NymnRrvM7zvQEefEc4vUa4DmN1393vfStVDNFyvhBsOpX85k/S6?=
 =?us-ascii?Q?iokSRm06OBdBcijo85xgBmXi8De2mphKRRmBt37SukYj557vr93X3GwTK47J?=
 =?us-ascii?Q?jL3Ttb6qTQK18U5VAcA9hUU9Z+sa3E8c5tvDTMr+HsORO9I0Ywr3Pzl1Tc2k?=
 =?us-ascii?Q?tL/QP+EujTQOuQM6x5KUMWfrWetrFotBBrXvnvv0YypitdPdEZ96DwjyK1ES?=
 =?us-ascii?Q?XCdN15r9JMkEOiTJgrFAlmaU5l9PjhSllzc2u772MV/7JAgqEmvousdkgHNf?=
 =?us-ascii?Q?dkfgHD7Pmco9UoTBoeokcm/mp3whDY0JvCmEYuFQvHH5ij5dfuIrfudkPeGG?=
 =?us-ascii?Q?GMG2C9/0ez5R/TtR5+LOofCcVmegS8K+FfL67uAsXrTtL57LjnppNL9auzGm?=
 =?us-ascii?Q?XiCIxmlxyxwPbp8Xo9TseqOQxtYnPHdyPNu+KA8QRHcmZ9xkMgyrZHrAVaL3?=
 =?us-ascii?Q?NREkxEcpiexVyEYYoueAZjYPR4jim7KeqSTHclczLHmhzNgNLHlHngmjTKYk?=
 =?us-ascii?Q?XIyS1BR64wrQSlVZ4dFFqUODVh4Qb8lTlfoV8VC0HmoY0Gq8dnmH/gJDzWdv?=
 =?us-ascii?Q?B5ZTh/+DtWZjtB+ijBksqvRGOC6U/htOrCV7llf7WMIZQOZY7yyrEjrCcNVU?=
 =?us-ascii?Q?9e/NQ05DBZYmTnEz3Iv1MnqKuocy6JBxNJESQsBe621X1MJCmI2LhlA7s3ps?=
 =?us-ascii?Q?DcCmvFdjQKkwCqR1adTNCvd5pYHuYXCwfSm3XU7g9ch0TpdwMLFgys2nAGRM?=
 =?us-ascii?Q?JpWI1uD1sfLKZOXrk5koZpE2LVeH49+OHivDTVMMtYpDJ707tGa+a3Q44Stw?=
 =?us-ascii?Q?VyL546CoqDibwVO58eI7mDn9fWD3b026ahAOYWe4behGDr/3ncEyAosfjzDz?=
 =?us-ascii?Q?1yFitToBX+kvI1ws+pKLqz1BqpoM8I2cVKFDwTEIuTDGpPr96t/gBXfsp8EI?=
 =?us-ascii?Q?qKAOcBumbL8iQMetJDpFtI1STY3A7+mynCLjK9zH9Oi7QT1F+H3Hxv690UpY?=
 =?us-ascii?Q?/259sVWHsAguHOHAvVvWNl0dLVq4xw7k1xs/0v+eejQtn4Y9YuV490NupkGo?=
 =?us-ascii?Q?MefgK2lbTHANm2SMSWm+u9Jlrx6f0xdCYGV8RZx3ceCdvZ/Gia3IoJWmeMm6?=
 =?us-ascii?Q?jc21M+OcoQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c92f98-0dbf-4f8a-3133-08de4d58e544
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 19:22:13.7476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzMh7mT7BC2b8/zpJVgkHd82PijNyw7donWjjI7RLdGYSawgLKxcTqpCEXx9MRHK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5981

The test doesn't build without it, dma-buf.h does not provide stub
functions if it is not enabled. Compilation can fail with:

 ERROR:root:ld: vmlinux.o: in function `iommufd_test':
 (.text+0x3b1cdd): undefined reference to `dma_buf_get'
 ld: (.text+0x3b1d08): undefined reference to `dma_buf_put'
 ld: (.text+0x3b2105): undefined reference to `dma_buf_export'
 ld: (.text+0x3b211f): undefined reference to `dma_buf_fd'
 ld: (.text+0x3b2e47): undefined reference to `dma_buf_move_notify'

Add the missing select.

Fixes: d2041f1f11dd ("iommufd/selftest: Add some tests for the dmabuf flow")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index eae3f03629b0c1..7e41e3ccea7587 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -42,6 +42,7 @@ config IOMMUFD_TEST
 	depends on FAULT_INJECTION
 	depends on RUNTIME_TESTING_MENU
 	depends on IOMMU_PT_AMDV1
+	select DMA_SHARED_BUFFER
 	select IOMMUFD_DRIVER
 	default n
 	help
-- 
2.43.0

