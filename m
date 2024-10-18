Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B779B370;
	Fri, 18 Oct 2024 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729270886; cv=fail; b=uuKxF2d1jJZh11d+/tf7RtTwi8wsPv42ZP/6wUuAolgvEXN6XOGnbiJTrQqoIWfeDCeEMvOQP056mO96QksUzkBRf/XHtbWkHU/13LZ26KfVhfoWzpsjpBxsswH0R8DxxXe3eQhJz9EkwAu8kdBRk5Tm/by7ib0jmolBNtTQSoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729270886; c=relaxed/simple;
	bh=7872D06ch8lL7H+FvPu3M0LtP56RvYWJjE7gZtAGwWY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=iGMGiAU5ShTgZEzIeBjZ3u2xUV9qUmzcqHZjMm31ZYW5v1Zljwn/GHAjZeOyMtqWt5N1MMucLpwLUuQcyCz0fZSfP/cTqfQNJT7SxNC0FrUi4AuNshkv4MP4e3vMnnkbUffeaGuYJ7HdE73ISk9SYxesxoXgLQ7rZclauvL/K2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j59Amvd0; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j59Amvd0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cgpKBtMXEWTqiagMk9fcjA7UPvBITVN84LcaNv7uQ2CAcMKQ/ZoSElZk8w/lV1iRo/Y1dhYyJjfU4h+F9PborJxkvfbEbvItwtw3yzKzNDjIqnnUdK56oSbkcIQnngawOTXVPa/tASWAe5vN9JdGvgmL0uOolERfd8hSfto8QqRUCBLV4K9By9CWgeNRRnseWstB/TRfAtXxm/DPryrjg5vIvbw2uHT/Zs00g1QUHkCzx/LW8JzpBaSN5hjuSKcwF+ur0q61ZGfZhhftdrFR87walM5J5zqMmfZFOYdjoIrbW10oaD0wZAAD13KRwA3HeRvKe9wgnfiBMRSTBdlvUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxKSgrymDed8e9/dh01MwcYRGvmVIUWN0ma9wj84h/E=;
 b=buH7enmHr9R8KmwGS0+sBGx2JQU0d4E5zp5OS6edjMzLgG6khZ7lHf2vxBqFmPu4qq3DDX49lGI96WPa4KwPTGIz4m65BRyzRabo7lr5KyCdlU//BxGTbHLvd7wwZMgEunvDuYYGzkKgUrAceAqo4sDg/tmsRqMcBhcvuYz2UZp1i6m/eGQRdLwjDtrrnaHBh5E30fB+8+2iosGmWXDnq8YKF0J1mhVXsGmEG1iv83Qf1A+6svcnf05wnA4TqegtBoVBogR5F8W4xdwhqahPpUblN6h0MDPFMree4CyPKxy1iIRqnvwgBdiJcK8Irh8IQ8vFylFy4BNuMWotnuZAfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxKSgrymDed8e9/dh01MwcYRGvmVIUWN0ma9wj84h/E=;
 b=j59Amvd0bSrMavIPlCjAc5WDbzX2BO1mGyY1muJ0gRfVQY4SRLUCAFq+qK/C90X8VwuNDwK1afW+vXhCXSOIU7BQnglUg/4sBEYlf1EM20H/Y1cHnApNhupCP6vzZgkctsS9OvdiqyL34Ad9dshhccXVAAoHD1F3eXLUBBmK9ha8hzp2c43EyF9mpa6QcJo1WYMx2Har+Gy/r6Kumwe/69Elk05Yd7TF8WoN4RHPs3jJVUuwaXgDDZL/w8WubIqPxe9kvgtQlS46zj6UbrtuQ4SCb6fooqmeH2kdoOlaLE74D/adXzywjSrAWJAkrRoNoJWusWtQA7G0I7xXU6rCqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4466.namprd12.prod.outlook.com (2603:10b6:5:2ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.26; Fri, 18 Oct
 2024 17:01:21 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 17:01:20 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] iommu: Remove useless flush from iommu_create_device_direct_mappings()
Date: Fri, 18 Oct 2024 14:01:19 -0300
Message-ID: <0-v1-bb6c694e1b07+a29e1-iommu_no_flush_all_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4466:EE_
X-MS-Office365-Filtering-Correlation-Id: f6fda3cf-dedd-4413-a4bf-08dcef967d55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GcpGg/qOcvdmIoE7JNlUZ0Od9BokPnRnFisNQBW97Z1ijbs+S/MrAjZJqiAm?=
 =?us-ascii?Q?LBAjUaXjUgTJskba+/IktHGoT3AwzoZF44vzte1+W732avto5g9B9ZFuh3Ua?=
 =?us-ascii?Q?gwvgo9g3D1q8eA3UDGFEsRXTzCs0bPuDDVc4inISiLtr+RvDZvYNW1KjLKJ2?=
 =?us-ascii?Q?M06thPp5jxfTiu8uIR5c3h+4J4xpv5gQ8oI/9raja5vOiEgy+Y4PHYIfv/PI?=
 =?us-ascii?Q?9alrRWVXMBeuIPdRzU6Thy6PZme5Zq8sVObObGHBHZJXzJfD/a1x1ZejzUNX?=
 =?us-ascii?Q?9z3Tc4NNxLZQEMYMcOHmjKuzJ/0iLWntBUg9zS9d/nhT/9dcOT9jt+BnzplF?=
 =?us-ascii?Q?ypJz7yXo2kWF82KCLSd8FBiDSPibG7iharUUIYhPFyZKDS5Xbd6Bz9zZBGqj?=
 =?us-ascii?Q?1FOYceVVD8UPZBtvzVtl8hcdFsX7ASWayhlms1f/a4p5m1U819PNCKZNgBeu?=
 =?us-ascii?Q?BynB8I9tAHicRlbRs89s4OiTvP9yyWODgFpntpNFq4D8zJ5toj+iibPYvW1O?=
 =?us-ascii?Q?33dk6fn0/8YYTV7sOf7w1Jsl+f2DacZ1DHQhnlpFuou4e6CtWJimRIIqcGaW?=
 =?us-ascii?Q?H8HLGe9Bc6oMjZk8pBESYc/PfYbYAbtYKnJs9OKw+cEqJ/WAJR2a7mxLaJCU?=
 =?us-ascii?Q?/q3pnkbJshPuBhW1/rk4aEsWO0OST0tykQHDOY0sftLd4bh+2i9Soi7bBifw?=
 =?us-ascii?Q?TZ/a3OeIlvooN/kySnVk7ANgNFLzuvL5+tNzF2Mc/DvVabnMTdsfiSP8LSKY?=
 =?us-ascii?Q?nT8ODFjm4UlVUvny524gdOVc0ha9S8Ttye5e3YOByzAKx4kcteXVwLkYZZiK?=
 =?us-ascii?Q?KcAy6GY0kCnnXPXBZ92hBAdg8RN+mUy1AENF6NljCunX0enlRNbNdjynpBfT?=
 =?us-ascii?Q?JpwJSogMk1f12xNj6Bb2gxR4mIx3AkotJh/vs/9BKR1OMPPWK+69kTYMwrEp?=
 =?us-ascii?Q?qgTShwp1tIwu8ajeQVuOjJseVBxpJ7WlNXSJvX4rRr6qp/w87GVov8lj7fsP?=
 =?us-ascii?Q?BbC8T879Ugqyex0MJ3WVyWg+aPMTUKATCRLKaGjNqDLDaiCwbEIhLFxfWjFQ?=
 =?us-ascii?Q?9zv9t0TTXipc4Wf87KcKKBPwtrsjjMbIlMcR/JoQhlFsyEcD/ebcAOtqAf43?=
 =?us-ascii?Q?CY+igM3ov5w3UaPUgQFYVnZA10yYFcc/cZn0NNV5xWgQRlebLshMb+K2nl3N?=
 =?us-ascii?Q?GmNYABB1zhBXu8rGPISIUAP2RUTxqsrVZjyKUecRyBjRhvPeVtGkmbIHfIfO?=
 =?us-ascii?Q?eg5WQHCVnnLUSZAGszo+mUo6Q/MyXgs+p4LmFjCQVm06/WS+e9DfJsUlvnGP?=
 =?us-ascii?Q?DHN4cnWJCRdl+1Qhfv5wHEJB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R9RtYQepV/O1BijGu+hxexx+EKOUN7IMFMSF5cZ+DycF+Ju8aD8O3e3BFQM0?=
 =?us-ascii?Q?7MBKf61nRR/64UjaMdQVQbG0+6GZotSzil1lhVMOtAeNG4m+hdkJZwdkhVct?=
 =?us-ascii?Q?WbScty2MBTdfpkw5oMargy8ABDvx8U0facWOpZ21V5tjD/0mVnKT4fPq/C09?=
 =?us-ascii?Q?NzSdobxFMS0dsoiQmEW+ylE5Y9bN/HbY9LZMpLCnP3VGjq5DV1OtFHnKbpGe?=
 =?us-ascii?Q?HNWb22VN4lkT1yn0O5o69DEAvQwb829sjEl2vqjq4n46FsHaDG/B0iWFgYTA?=
 =?us-ascii?Q?/oxLshEw2dpimJrCENRs8hBXWAga/Pf2o0FeBpGRBoAo3fMJxNO/EmFYWWI1?=
 =?us-ascii?Q?6CICmcToiqBbxH9sMYurXlBxkLK41mbPZs/QGC3KlTMBznV5mTzPYLqFL4vu?=
 =?us-ascii?Q?V1rm1NiS/2xbrgfwvRhRzxd1b8Lpj5/MkWcELK/0wLGbQxSPPkYLWyt4xbQX?=
 =?us-ascii?Q?oR1j/0DBjD/tlV46nFnceMI3kifRw7XI0cyKFaqOxYID6AwWr3PD4TAk+D6y?=
 =?us-ascii?Q?eysdYpxDv2SiDejERPShqqWletan2Snnx6dwvzVlnNf/2MJHKCKjnNkRkUeZ?=
 =?us-ascii?Q?/AQ0bgrMHwf06yRRJODLFW2SPOzIyGR3Wps2ChsMWKTPveCF7B5p6u609jit?=
 =?us-ascii?Q?Wg7VDmySK5bTcoSWARgi5nLsGdZN1o/2IGb4zryrKtHIHQJu3j7W8WhGYz1e?=
 =?us-ascii?Q?fzZ9htAq5kaXFEOiR/m5sVFJyfFM63Gv5Ubo1G1azl8hJ04WV3FqvXBxoGVy?=
 =?us-ascii?Q?i/MrHyibVle4g0KkfFoIB9GiVEDEdeRiANX3Naq5nc3K5lL5LbW0g7NQNfeo?=
 =?us-ascii?Q?2NYg/BT6RQJpKI2+yVdCDfOtdi8NeFeZzwMsRFKjArxdH7vTNpjm1pb8l4K0?=
 =?us-ascii?Q?dlEoWPUlLjNQmLFu49APdGGuW1W8cB64+oWmvXaAvqfau9mPE+wyHJfKi59B?=
 =?us-ascii?Q?daQQCUG+e5dreR4tuE87S7yz2asQolawiAeTSdtMI0JRBa/YVgc/0Dcfp51W?=
 =?us-ascii?Q?Q8eQyF1rcnaeY0T8/4sSuaZOc6I5X9iN6Ahp2LDims7fyh1I6zgz3ahFan9H?=
 =?us-ascii?Q?fh9lrwaeznCHgxUWku8s+nbYiE/JPfliWT1jdQx7yWZysQhbbP8q4JC6TRIA?=
 =?us-ascii?Q?Fu6KSYj0CzwZUQ5J5OyNiGllgRd5yKHQSJoLZ09FkM//2sOpcUX/hHU1jp0n?=
 =?us-ascii?Q?b3xTnAiGjeBUou2lKL9PT8xqhjC6zjMEB3vK0KClUFx4SEKhJ+33pB696vwB?=
 =?us-ascii?Q?WULRIv3l37O8dyt1r+DEPg386IsNTjvJZob5BO9/977x4Ef4Cxq1YImy7iwW?=
 =?us-ascii?Q?m//Tkl7RO8+n+enaa/LzllWn08RSY8iV7vS9gHfB4jcAAORgw5DcJzor+9ox?=
 =?us-ascii?Q?4331MQkxXlRH+gDNR9xxUfs88A9dqe9kRiwsw9f+NPBJ752sizzLxHAEuYsP?=
 =?us-ascii?Q?c3LOfrsHJZcBGb8ZYS0i00IApj7rFAiyKb1O69bRnCpuwhXkDCgrsycRsUhu?=
 =?us-ascii?Q?e+nkNuEk2VV6mzdlq5AKFd8vM3OxDcwPzqm6H88csiVOfAY7Ltp7NTIypta/?=
 =?us-ascii?Q?Co2SyEfa45W/OAbP2YI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6fda3cf-dedd-4413-a4bf-08dcef967d55
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 17:01:20.8450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9Lr5w7lvIcBCACKqqx/UJh1IPDduwzqKj6hPcP7MBSbjsywbIS09oTUOx/KB5Ya
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4466

These days iommu_map() does not require external flushing, it always
internally handles any required flushes. Since
iommu_create_device_direct_mappings() only calls iommu_map(), remove
the extra call.

Since this is the last call site for iommu_flush_iotlb_all() remove it
too.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c |  4 ----
 include/linux/iommu.h | 10 ----------
 2 files changed, 14 deletions(-)

I looked in the git history and mailing list for a while to try to figure out
why this was added, and it looks like some mistake. It appeared without any
changelog in v2 of the series, and at the time map didn't require it.

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 83c8e617a2c588..37c080cfde443d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1141,10 +1141,6 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
 		}
 
 	}
-
-	if (!list_empty(&mappings) && iommu_is_dma_domain(domain))
-		iommu_flush_iotlb_all(domain);
-
 out:
 	iommu_put_resv_regions(dev, &mappings);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index bd722f47363520..6288d29141bebd 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -853,12 +853,6 @@ void iommu_set_dma_strict(void);
 extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
 			      unsigned long iova, int flags);
 
-static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
-{
-	if (domain->ops->flush_iotlb_all)
-		domain->ops->flush_iotlb_all(domain);
-}
-
 static inline void iommu_iotlb_sync(struct iommu_domain *domain,
 				  struct iommu_iotlb_gather *iotlb_gather)
 {
@@ -1147,10 +1141,6 @@ static inline ssize_t iommu_map_sg(struct iommu_domain *domain,
 	return -ENODEV;
 }
 
-static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
-{
-}
-
 static inline void iommu_iotlb_sync(struct iommu_domain *domain,
 				  struct iommu_iotlb_gather *iotlb_gather)
 {

base-commit: 55b733c04008097dcc982aecc87174a43670d2b2
-- 
2.46.2

