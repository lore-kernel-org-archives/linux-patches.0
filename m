Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF67634A3C5;
	Thu, 23 Oct 2025 18:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243772; cv=fail; b=ug5NMQr2IeFD9TMrp8sSoxzTTmFQCSXv1GCETkbaimYquMkNmKsCVZLJyGEXqe032JIxHu6cOAc690xuQNC0lFrKj8OCW7LI+gbkNC9xnSi5HQjup13GraVEuobnqj3Mt7UVusEmAAAW4bXJhzT0T1KCHTCAF9D0dgve6XBO+vY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243772; c=relaxed/simple;
	bh=cfbiIS8dbegiVmOEG3hVNdT/o8cSR71DgjB5HFWa8Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T8MK6JEnXCHXE/cIBkh++vFptXJ3xwdjRi03MP64WkO0Hp0pw568wKpBDXmQ98Zh+zwYgcvFGTHya5dh6l0yrq544oA3JW0BcsBAaqpyI6OCwrpMY4IxLKuYDkNC5ayUS+5YbCTbRxCaQuREo+lgkl3m/9dT23foqEq/CzhrxH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nUvI4BkX; arc=fail smtp.client-ip=52.101.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nUvI4BkX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=odx81YKaXswmdrpzmoV6J5FVEvx44RIjfzS8h5EEbvVo91NaOCSgSv7pXth2/351d7V306ikWAtpM8kZeTbLLg4X8VZHZuKAYfJTH/bugipS8+oFlZxkYClWxwCZnbY5XqxOOjXjTt+LO6U7e+nII/BSvK8Q/qSZF/EsFed53PLvucD99Gcpgx3cuprHUXPZ9jOb1o9afXJ7YTawLFkkCsrX0IkyWggWr/IMoph7LbyL1n3i315XhvYTAzBWsG4AKFF9QhySHUILCuHyiRAZN/T0/xBfoFNh9q1HPnNFUG5wW7jd2SEflGR0ggx6DCo8oablQ29k1XUasgrp29RmYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzRjX170uN65ngv0Yuea1d1hmLCmKp9BFd/PCced6/c=;
 b=KGCxjn6Rd5JqWEtRcsK9bWk1BvDIvz4fXuZwjZWZxMjIDzMuwC3muKRywUwI1P2D3/y3mb7NICaU4iok8cnn/nzrunjQfelffUsKGjXXiTmx/J6GdHrXBtBR+RY11f75wg1DS6HslraLMoYYXvBXkWgWeqmqAT3jkXfgtWn9VpyyTcTXR7pKpQPS9US/2kyPhjXKHFjuOAYomy04GEI0JVJM7G5ONjP7MAVDNIl4Dl0c5nXZAXU20kfaP7L61RXe1vya7V8GdFR7WCI98cOfR/xX8sMDljFyFV6Kfuj9cDtQRyIix+TnEKtesBEorC8HCtJKvwhQUyBsh53yWsvqSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzRjX170uN65ngv0Yuea1d1hmLCmKp9BFd/PCced6/c=;
 b=nUvI4BkXNQIgXkas/pwNLdncqvUZGb1ylsz7gYNSniW2LQt+wOkFQ/0gxAsWAX1NPXyhKTtwodszRB32H6r81MI+/8z0q8lsKBE8kZvLEcARYIePrh7+72PtX0ebl0qOtR5zgHGSmvfaIWQ6D9D7Yw/qTmRqC+W+GioPiKuNS+omRucKK5FYg3y3rIxRInTmtzGtrmh4y4u5hnhyRZDN/WUlRKXqEzrhdiXrsc5wk1lgaRUWJFOnMHmIhvPfPX4TeamDFVz1icxBxpfODdD/QaSSI8fC/BhRbXTdiL6gsgjWc887rlT/udS7VqTm6DgBgc/ZB0z4RpNUSv8aIYfBmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:43 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:43 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 06/10] iommupt/x86: Set the dirty bit only for writable PTEs
Date: Thu, 23 Oct 2025 15:22:34 -0300
Message-ID: <6-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::35) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 14b32dd3-307a-48d0-e54c-08de1261289e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/eT2BKh1CV1ihllvUVxnoLj1VHFY6u0psPF1PCjX3j5mE1dJlEpYvQoQp01J?=
 =?us-ascii?Q?dX4qvLs5qTVYWzgjh/jH5dxpV3ULvEpBbgPLD04pOlf7MlzvrjRUbiWGcAb+?=
 =?us-ascii?Q?y4ehwB7dqUzSOcR2FLwHlO7bubu0ToRkh30TTyxhOWWzAoXCsT/PIAyczpZt?=
 =?us-ascii?Q?vhTxyK2r+A12pu9dI5Zyo2zTot2bMbVfsnubeypXnawwPKekY0rrbmFMvpqe?=
 =?us-ascii?Q?9wtRbqA2P6B7ij/ho40fURRWeT8MZxTowtWo0o51u/7Az3Eyitkg6VHUqe+B?=
 =?us-ascii?Q?NL/wVmZ/HSXFrkwcxKoKEu9dlYvMQfALWIzw6YgJWKya5T75Wuca/ES0rTG+?=
 =?us-ascii?Q?/JlGSb6NAGbDvyH6S1nZNWZ1dD/5wfNM89+V7lHtqqYJ7Kyaa37sy6qxGGsM?=
 =?us-ascii?Q?3YgOuWF7kp1M1TNAjLBfw+YyAqfAH+LNM2WCCdyG7Ko0v9sJjHMzzzHl+hEA?=
 =?us-ascii?Q?G5TU5tRE48uulHt9k+WlGS5cOKf+mbF9EWCU/bTSBhb/O2YqjzP+S3spWBHK?=
 =?us-ascii?Q?5tcceUR9r3rQ4wsghmX5rXrU7Nj/jvEMIA6ryTNuOiR/0Px9TJ3MEbw+DqxF?=
 =?us-ascii?Q?hceNF1ET2CKmgPwf6vq3gZSiG2PDpijd8vY4LCn7bZzbxSQuo7sgeLclst5C?=
 =?us-ascii?Q?KDMgDaoNZ4hCrQdLbIySlpwaRG5UZAYxzTsRzQ5rPfanKffPkVjUdvvFBKMd?=
 =?us-ascii?Q?4aTQh4BfdA2l57IcZv1VPYNU/4jzHObyGtLHoMyhOOyhPRlPbESXkCqEpf+7?=
 =?us-ascii?Q?v2Q1p7PZhKV3oryEf5uiGxW2GsfGvvCx/WIZTYzAZHXtH0bfluBRPNzX6t0I?=
 =?us-ascii?Q?wB/wLA/p8BGjB0YpVI0fobe3vIc1gqJ7BHnFoeXx8AHLPj8G5FHmLH7qmOsA?=
 =?us-ascii?Q?yb0tfZjTgRjadTp4ij7shno5sezoIy1np+gX1dbogtCYbQYsVruXdnAmyiTw?=
 =?us-ascii?Q?9/20g0Mp5pKm4VkVmAABlropgR4V/5p4A/UTAcKarWaT1mjVh+35ewcIjUGs?=
 =?us-ascii?Q?qWxbjbuxXgnZuGUX75r34kUsmM8JCFd9OEcoXk+WMG2R6WzdoAABxl51FFzU?=
 =?us-ascii?Q?ZZIs8UKbRNrhq+njUr0czCQskx70bfensSps9JQg9DOujr1/2UW8vxlRUcbs?=
 =?us-ascii?Q?b5kTsTaDTy8Ft+N/ep69CBS3UayvZletvOTYglSgK27TMFa8t4gVKYpHrB9o?=
 =?us-ascii?Q?PfvTfy/3IbtFKoqZN8aap381lYi9qw5yyCI8YsMcxA1XB/qsK+voitvIoUl7?=
 =?us-ascii?Q?+SBVwNOwyjkrMteJiN7mx1kQeVH/CXVOrn7+fCED2hs5kaFOQ9X3Io8KgPJF?=
 =?us-ascii?Q?88LrYh+uZyjpjXR4UZH2S9w72iKGwpv/wPSCJIbt5g8g+1EtcI5Yjx9gAbjs?=
 =?us-ascii?Q?95WlrELc9KKdBIjz5W/96KcJca20YNWeJfJhwnr1JYv11QRcSpJY9Bmcssg5?=
 =?us-ascii?Q?9AgwlBxfXa5a9ygN+DGr+Hzl8hxj/J9L?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KulhdvMAVyM4RXKwrc+SFrNdAHq+UvKbYi9DaYPnGOBNFPgkaLwMphMOCYww?=
 =?us-ascii?Q?fgiVcpYoIMa9ZPMkwuJLLJcFzI4egnZyhjQvK6YutLvtK9PWLvL16VHEK40i?=
 =?us-ascii?Q?8qepgT5fAAxsV8emcllt7XAFTEFSqwHkdG7vIRajtDYFtJOqMkLApkTvhfiX?=
 =?us-ascii?Q?+hHF339lnTGCkZhwf5P0UkvRsw0BTF0oOGqjSl1V/UEKwiDcvi8f9m7AA/tt?=
 =?us-ascii?Q?NLUqBVdeyg1JHzmJ4h/OD7QlE0/wpcWSkRfNDc6/Q0MgQgxR4iGczKY6lUC8?=
 =?us-ascii?Q?tSNiyFJv/u8Lr+WkyHBq0Dl4Jwsu2sgdp5+x0dQ8Axrlj5394bc4pGL4CHiw?=
 =?us-ascii?Q?kT2eyGWE3lLWNCBfEIEyg8A1RoOYyiijTULVpdGIQHMssMH3Y3UPSYTU016J?=
 =?us-ascii?Q?HLnASyGvVkmLiNlQqymG58oLR8TEpRlie6DY0buOl4CBkpuOBuTCNN4n9PCp?=
 =?us-ascii?Q?uRw5paqt/YGegpSiqPnfRhkD/bEBUYlgT/Rj0plBUPjPlXcedSmn7h2LHbLj?=
 =?us-ascii?Q?Jom0Fsmsupx/y7Q+UFg5G89BXpDFcJExp3611LAdLJ/K0TnQ41hEEwYwwxun?=
 =?us-ascii?Q?Cq3BvqF23RkduwkBchpWEaV6X2Uu5stW/EmfGPf53oqr8Zr/WR/eFfVWLHUS?=
 =?us-ascii?Q?iE8id22PqqGTamgeEB54m0PWhUPbr0HHZL8lT6LvmhDMQ4OdTzEPBBLsWH7o?=
 =?us-ascii?Q?lHV6PzkOGIWzVQuAdoXahHBKZhYQmW3MgOVhg5mx2MwBoA2bEDBbjPEovQzj?=
 =?us-ascii?Q?PDAt6IED9i0lbFCTeSIZ34Bu0UxxLnJi8w/UD1cjQ9V303p+aFX9DPAv8TSl?=
 =?us-ascii?Q?E2j1RBEWRcOSuT6NuzELqrQun5ouO3nKOgIlNpKT7L7WxeKdO2uBLEVQdVqf?=
 =?us-ascii?Q?o1DMTrY+IJiLdoMppMHn064GVYDj3JonAdoX6Q6bNP1U08UfCg3PE5ENrrth?=
 =?us-ascii?Q?UFTq/ihrq02WSxZSR40rGLJNETH+2MCC6S17jyNGC9qsStFqqYy+RnvIqFe0?=
 =?us-ascii?Q?JYEk6W1+3x++RIGRB39lyLct+2GS0rc0LRjHUf55giQRYRFbv672Up5z4n1s?=
 =?us-ascii?Q?G/pYSEUwBMU0B2+YdltbCBAueeNypFa3ZBVMBIDakx7DvXHXjOzGGDzPQ4JJ?=
 =?us-ascii?Q?MRjeczeTkup1cM0fuJ3K8KgFZH74x2q9AymQnKw8n4kSh6tyk1RYFDwnnMOB?=
 =?us-ascii?Q?wc5a/HaJ1ImGMIi+i8CqNBc3/MYPwwSGM4I5THETFK7mHBmZWt8cq7tdfZU9?=
 =?us-ascii?Q?rB7w1E+cYSfCPikjk4QcnKALkM+kWioKjoChXwug3j9Mtm6BUto2k84tyUla?=
 =?us-ascii?Q?KFTTZKgyUl4Xm0b19aOXbHY3sL56ylR+t+bH2G/1xrnVTG6tDgkCcdXTu0Ql?=
 =?us-ascii?Q?BNY1RyhOdcWbu67cdFFdtVNv+hriX7aEyScc41j1wfO2CTlivh9hYz+6189H?=
 =?us-ascii?Q?Jnngy8dYP8DYv0hafpyIUE3dTy5RhkKVHlSPrLjF5Q1VxElUWslN5Eaj+xTu?=
 =?us-ascii?Q?8PeJfDKcGcPZdi9VCR8Rf3mheqM2LGMfvzUCkCQdiL2JwlsPJRIY7eUa/KDW?=
 =?us-ascii?Q?cDed0a+op6NYOdfCNYxVO8qngOVIWUju3Tp0IMl5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b32dd3-307a-48d0-e54c-08de1261289e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:43.7527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dHczHg/Hi7/OSqPr1ckXDuQu9RSx2HVz8LPI0OsCguYKYRSezFEydhMgSQqiRQ6g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

AMD and VTD are historically different here, adopt the VTD version of
setting the D bit only on writable PTEs as it makes more sense.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/x86_64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
index 8727e74ab4804d..df1ec7426ad6e1 100644
--- a/drivers/iommu/generic_pt/fmt/x86_64.h
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -196,9 +196,9 @@ static inline int x86_64_pt_iommu_set_prot(struct pt_common *common,
 {
 	u64 pte;
 
-	pte = X86_64_FMT_U | X86_64_FMT_A | X86_64_FMT_D;
+	pte = X86_64_FMT_U | X86_64_FMT_A;
 	if (iommu_prot & IOMMU_WRITE)
-		pte |= X86_64_FMT_RW;
+		pte |= X86_64_FMT_RW | X86_64_FMT_D;
 
 	/*
 	 * Ideally we'd have an IOMMU_ENCRYPTED flag set by higher levels to
-- 
2.43.0

