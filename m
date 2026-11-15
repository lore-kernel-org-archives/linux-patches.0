Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785455;
	b=qlyUQh61tQQmSUCPFX4n/nKFEXttv2A2fDMrw2cCxXEbSrGB1HkvJDHbaQp9yvz6qjPU
	 uD0ECodeI5uoEFJPwtxaiVOnfrxFVepYwNhazDJcAgzmPEArqxRu7VSRgtj78IrcuuOmr
	 bVyS2l3Dbgp+kwYHJELK0FiuQXV3LWiD0fUv9MWfK/33OSG1vBv/TA4YJD8lyIg4FaOv4
	 13/VA9gN2UXqF2qDwzNEQmYi1G+VXxWB870eBAUnNJHUEXSdNmNV3rkYObffpu6/IxHXf
	 LJG0oM5gvjfnAxkI4XmLDVsUMN+pPbkqLCCicWfXJv706pxFdT9OvOersdgji50GQEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785455;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=LYlZUYl1AnSZWIToRQLCKk5ZPPa/0KhlPLsjXNkCb6M=;
	b=sUNwVwBwMcOuTjcMm8UfKN+NQLo9bIoknor063t2t5JZisnzvfWPoKxoEq9kHfZpPUO5
	 s0o8n95+JicICKVHdWW6c/BLX3JiiOgUgywpXWreQ+03yYDH9oBpPvE8qgUCT3h8QrBjQ
	 slZpsqRVpYA0lj6oaQA7enD/ZiZU0txwo6GaSn/ZNRp08eURFAP69hq1TZIalx8F5M+rV
	 V5+fB3E6WH1I6IApW18TyRpdQf0K398We2j6GOPzLZl83j01fND4mCcXzrOI5w2kj1eJs
	 dKFhn2UnU7xhnIguELsyKWCtgzX6S+lW+2H2dGXF2y7D6KtxI73dDXFUkCdooLk3Ecg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="iu/Outgp";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.60
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012060.outbound.protection.outlook.com [40.93.195.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422CF606A331;
	Sun, 15 Nov 2026 23:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 422CF606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iu/Outgp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HshkupdDfPCALXq5d66l+FjtzPlCGo7vhfYvWfVQWLzgucQ0yft0fDRkvtcTWE+nWkpcysLewIw4uidRH4E3fN6kH0j9JhNGK1pTD3h9TG0hUJePzhKhGQ9f3uYUneeekGmaZZF8xjsD5dIlb1+jTaEHLZfjq8G497I7YcqBo7gDAVAATEI9xNqQVjnwulzIk2ACbVC7Jb7U3eOo1hRknSzfQC/CR3R+gl7hLl+AigcsyegAilSUi/oy6XhKsyELILblRneW8RXAEbo7DxxH6x84Wxwlgh+q7HFAmtNxgRuVEz5xe9tXhBvWEc927ymJJdP/75lRRYR3OWn5FRWu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYlZUYl1AnSZWIToRQLCKk5ZPPa/0KhlPLsjXNkCb6M=;
 b=LyrUOy9+E0PY2NjrSr+HkJ0gHIdFwYWzbSk8LIYsdjYQ+zQGIKaprl9ZiGzNMryiolbwpmqATyQAD6mbptSnM7YmssWOLxqbIhAgRpHO34b9M3EC+N0J7atGmC6Txxpn8c4rt3Li6JlrneXtcgnlVfNUBDgLNU/ExLZjwgkpYXFxsXTt/DOATVUPfvgUkE2RAI0mUw+UZJCfuLNpbeF4EgRJknKEFWhLZCEW/hK1QkQmD3vTEOTbKM9xr5W6SyPorhYkNDmwlA4pOZ7sC0CY9Q4e671v0/MoZvfyplsh6a6Nc/znU5GLe++oT0HBRjZbRxtHMJPseljM6fISz2nXsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYlZUYl1AnSZWIToRQLCKk5ZPPa/0KhlPLsjXNkCb6M=;
 b=iu/OutgpXeT/6Mza4CxbEYdIIEnfeHO7L6NwJRm9mAK5Z3at2zYIs1wR0eoUM55hpt1ahDZAKXvJ3Wqll04e0Z+E+Gja9mDExoq3RR3twZtDmHyRxwzNqdDi1I2x48MgHeXOR0avZfhVOG9glJ50S1oK5doeKbKoXssiQpzlccJ1javcWETISErtT7t7mdlhav9gAQpDg/USeVilSlcBEqNRBx04QJpT4olyD8aD9wu1f+BBT2pXr8xaLq/WEjxuG1Qohy2c57VSjYQHwBIspDvR8476A9FcWgaDRQUajYtReSgEo8PPObjJkm+ulCQe3fFJOQrGstjGTueiPxn+AQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:46 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 12/13] iommu/arm-smmu-v3: Use the generic iommu page table
Date: Sun, 15 Nov 2026 19:30:42 -0400
Message-ID: <12-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0441.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::26) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: d0248607-61dc-4fb4-dddf-08df437078a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|5023799004|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261102130727099003|261009223027099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	q1K+w8j93Bmra993VA+eeJTTvfq9bp/mGnzSNK2Dx0vLwquvcOLjxqzRTGMInIy3+YB0veMdPBuCzsejE6PxLmTRLUhMHmA1T68fYShhoHO/ueK6Sbg5GsAEicp7CVLXNHt3uEq3ciQWFvWESYRCA13MC8Hk5M1LcHb6rlyhYde7Sf3wgmazKGtl7vWfrTp/30zArhTzhg9xUsbN6X/kfppTw/n3YZVUVAuchz3TQIJV37VmwpxxLo6h0AtUr2cGragXSBmX7U7xtFJOZO09NVbpbZA+iiCvhhcmdjqeAcRdCWKYW4ANmazTSbInrNJolC91mLI0czgpopQpB6oIAzjZ6+EkBVgV7XsWb+3i+oFq1cMgIVd26qIYoHyev8tuPoyzeKEvZqup0kpqF4qkyeB6Q9KGCzICBWh5YoQWDRWz6J4YQmETuCj3zq+IFPya5P5bRdobs26Oh/D4yrsR443ud56gZFBRv+XQqM19aTXThH+xqvmDGgJI9wwPtgKLy/2/Byjw1Gbmal2GWaLc8P+jNv2BxLxDAi/TBQFuC102mZtLcUdRQWbf+/M8N2KhqQWRJErq0oNX2OjJfmNQ1yha//pjW7For9Bb5iZaE8Rr4pVcm2O1DCnouIDEbjJCsy/LUtOJVkc4BjD2G0ApDPUbh/raGitY0rvpsJUXUt4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(5023799004)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261102130727099003)(261009223027099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iEeHKenSxw+jYZDWPvQ2+fsXoEnp3eyTNFM01XqIYUVPsShf9Z6S3ONpFIYV?=
 =?us-ascii?Q?C//JfTU5qLT22rkSrhe3ccjIO79JfLSuHab2cOZGr4RBKB4VPZqLUD9/A3ZN?=
 =?us-ascii?Q?ihNCVrYWC9zmzSNdRx2owSHAFgXMiQ6NpQjx8AHidjxFitS83PQR1firy19J?=
 =?us-ascii?Q?OHSUeM8PzskTCnoARsqF97ig0PpWwU2T9Ias7TFhdVtPxyUefdsO5xFpEGkc?=
 =?us-ascii?Q?McS5RNcZuhdddockFjhNlL/lEkjgcgFvgJ8SIY2geWW824wVo9IsN/untMLw?=
 =?us-ascii?Q?vvjWfiRRHUVL7r+U6mnrOVDduHgJz1fGHUsygUKOSVr+AgTwCyJyc9idk61n?=
 =?us-ascii?Q?zIZ4ZRYhRvCuWiyc4QiqlYOPmAnfM1wJga34dPjnc80y8NVWUF3kidwa9B32?=
 =?us-ascii?Q?hV8y/7fRrX2i1e6iF1UlLveMj4FlU9myd2S36zrkqoeZNy2rit27Qcjw0UhD?=
 =?us-ascii?Q?xTQmdXz6zc4QxbSMacoSWeMUamQF6hb1Jk0RRgV15W5my+FwVzn8oYkPtlL9?=
 =?us-ascii?Q?UR+urOAs9qWtM25FkPuq9Q+b2HAGcoiJdx7BVOmcpOYjp3P0PsDRe+qb/E7k?=
 =?us-ascii?Q?G6sD5WK9o6uWOmxbKkU/KPwjNZNir/h2mEUekAj167rS9KVkv5N0igT7TIUA?=
 =?us-ascii?Q?34yp+abpDuCThmbb4U7ZJWsHIpum3Is2bGfu/b/2FtjzjST4IJ9yQUC7JE1L?=
 =?us-ascii?Q?TTzJns+mbeMxLLvyxGLceWFl1PC218arvTvGB0PjP7+WGZlH6aCYUelgVDuk?=
 =?us-ascii?Q?BQybEDaax53/PKpVuFBlC0dOMD8vV3/umeBsQcNxnd3nLcbHFllfizYYcT1t?=
 =?us-ascii?Q?zZkUdH2vEVkxV4tVdjGf7f1dQj0gKyXOr047RfrzM9zeD7m5w5jiqj0DSiTc?=
 =?us-ascii?Q?YHjDcOnT89149oprnHQq1c9fwkD4pvFM59NLngLJMTQvCkDOOIi89KKk6N4z?=
 =?us-ascii?Q?FxhTvVEdk+V4tSbm9Ia0rfd1z5fYmAlq5iO+iyt3B56hIqzPrOzOktGNKTfA?=
 =?us-ascii?Q?vyz8uab3RnrUJyN8WhM4/+v76MZLvUYczvIwz5Zp+NLyDuCbb8sMLqMPfkfT?=
 =?us-ascii?Q?NjkJXu7B7mb4/Uzm0wyiR53AK9ZOzS9AHFdfh8SJUAHmCSKJXWaCfrWGtMUV?=
 =?us-ascii?Q?xNtM9tA4aVI1aBNUMn9ztPTHyQiIQ5shO7xinqzyHNILEs2Il1TnHNtT22GQ?=
 =?us-ascii?Q?QMsKhsUmrycZMJiPbWH+Y5RdFo9E4B+Aq5G5mb4Z2Pv+gqBrdH//p8MhJzmG?=
 =?us-ascii?Q?OluRaVRbUdOPeQGdh8dLvp64K2af5F3AnoT4XafchJB4sUKWRKQKArmxsd8T?=
 =?us-ascii?Q?iRuxQFmQ77+YMjX1hSzuSqOKyiPbTL5CBsWZcBRQeslK7FmnLA1713Wqp++/?=
 =?us-ascii?Q?I9DjBLC0S5fgG6tfLSzrZBMfuMGnFSnxFJkZzyzZ0ADGo1lF5EticgloRqBt?=
 =?us-ascii?Q?YU2eDNDqGaU9cSmacJCT94+COnlgko6mBk/3r/N7xg4Vgckh05SUsrfjCk+u?=
 =?us-ascii?Q?1KcmMqHUNx24Xj0vOZF+UxzPypkOrrzUmK011jg3lC052fPqKzq/G4pJCWJl?=
 =?us-ascii?Q?KDrG/NcaXjPJiR1S78PgqUvbSenU2ENdoJPZ4FWvIe1PbnsR2TU6SW7n1txr?=
 =?us-ascii?Q?oBFVR4Vlr4RY1qrchyJ42p/PkH3Bg7LVO3P1V142qK/XCVvuNuNWpbgTPTOw?=
 =?us-ascii?Q?vpsS+JNIoFLHmFnVL43tFxJFjlSWayKRFZL409hcWeQ5Ckbb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0248607-61dc-4fb4-dddf-08df437078a3
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:45.0928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6BBbAdPt58Nduoyjlgxjy/WsApPbuGDCxPEZMi6xqI6uJQDWzGUHQjist3BglhN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

Switch to use the iommupt provided page table. This is fairly
straightforward now since the page table construction and hwinfo are very
similar to io-pgtable-arm.

The struct pt_iommu_armv8_hw_info is a direct replacement for 'tcr' and I
have a kunit compare test validating that the fields have identical values
for identical configurations.

Quirks are replaced by features
 IO_PGTABLE_QUIRK_ARM_HD -> PT_FEAT_ARMV8_DBM
 IO_PGTABLE_QUIRK_ARM_S2FWB -> PT_FEAT_ARMV8_S2FWB

SMMU features are mapped to iommupt features:
 ARM_SMMU_FEAT_COHERENCY -> PT_FEAT_DMA_INCOHERENT
 ARM_SMMU_FEAT_VAX -> PT_FEAT_ARMV8_LVA
 ARM_SMMU_FEAT_S2FWB -> PT_FEAT_ARMV8_S2FWB

Remove the iommu_flush_ops entirely, iommupt only uses gathers for
invalidation. Wire the tlbi directly to the gather.

Remove the trampoline for map/unmap/iova/read_and_clear_dirt. iommupt
directly provides the domain ops. Domain initialization is largely moved
into iommupt common code.

Change the kunit to fully create a page table to generate the tcr bits for
testing.

Compared to io-pgtable-arm iommupt has a number of key differences:
 - CONT support
 - Unmap yields a single gather which generates a single tlbi operation
    * free_list is always used to free after invalidate
    * walk cache and leaf invalidation are combined in cases without range
      invalidation instead of being duplicated
    * the cutover to all-invalidate without range invalidation covers walk
      invalidation now too, umap -> single gather -> single all
      invalidate.
    * Range invalidation flushes the walk cache and leafs together with a
      good TTL hint.
    * Range invalidation always generates at most two commands from any gather.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/Kconfig                     |   4 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  45 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 260 +++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  17 +-
 4 files changed, 108 insertions(+), 218 deletions(-)

diff --git a/drivers/iommu/arm/Kconfig b/drivers/iommu/arm/Kconfig
index 5fac08b89deea7..495b03ad3cf6c1 100644
--- a/drivers/iommu/arm/Kconfig
+++ b/drivers/iommu/arm/Kconfig
@@ -77,7 +77,9 @@ config ARM_SMMU_V3
 	tristate "ARM Ltd. System MMU Version 3 (SMMUv3) Support"
 	depends on ARM64
 	select IOMMU_API
-	select IOMMU_IO_PGTABLE_LPAE
+	select GENERIC_PT
+	select IOMMU_PT
+	select IOMMU_PT_ARMV8
 	select GENERIC_MSI_IRQ
 	select IOMMUFD_DRIVER if IOMMUFD
 	help
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 3a0fef761daea8..721a35ab73715b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -3,7 +3,7 @@
  * Copyright 2024 Google LLC.
  */
 #include <kunit/test.h>
-#include <linux/io-pgtable.h>
+#include <linux/generic_pt/iommu.h>
 
 #include "arm-smmu-v3.h"
 
@@ -345,21 +345,21 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 		.smmu = &smmu,
 		.stall_enabled = stall_enabled,
 	};
-	struct io_pgtable io_pgtable = {};
-	struct arm_smmu_domain smmu_domain = {
-		.pgtbl_ops = &io_pgtable.ops,
+	struct arm_smmu_domain smmu_domain = {};
+	struct pt_iommu_armv8_cfg cfg = {
+		.tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_S2) |
+				   BIT(PT_FEAT_DETAILED_GATHER),
+		.common.hw_max_vasz_lg2 = 40,
+		.common.hw_max_oasz_lg2 = 40,
 	};
+	int ret;
 
-	io_pgtable.cfg.arm_lpae_s2_cfg.vttbr = 0xdaedbeefdeadbeefULL;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.ps = 1;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tg = 2;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sh = 3;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.orgn = 1;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.irgn = 2;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl = 3;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz = 4;
+	ret = pt_iommu_armv8_init(&smmu_domain.armv8pt, &cfg, GFP_KERNEL);
+	WARN_ON(ret);
 
 	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, ats_enabled);
+	pt_iommu_deinit(&smmu_domain.armv8pt.iommu);
 }
 
 static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
@@ -497,24 +497,24 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 	struct arm_smmu_master master = {
 		.smmu = &smmu,
 	};
-	struct io_pgtable io_pgtable = {};
 	struct arm_smmu_domain smmu_domain = {
-		.pgtbl_ops = &io_pgtable.ops,
 		.cd = {
 			.asid = asid,
 		},
 	};
+	struct pt_iommu_armv8_cfg cfg = {
+		.tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_DETAILED_GATHER),
+		.common.hw_max_vasz_lg2 = 40,
+		.common.hw_max_oasz_lg2 = 40,
+	};
+	int ret;
 
-	io_pgtable.cfg.arm_lpae_s1_cfg.ttbr = 0xdaedbeefdeadbeefULL;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.ips = 1;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tg = 2;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.sh = 3;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.orgn = 1;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.irgn = 2;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tsz = 4;
-	io_pgtable.cfg.arm_lpae_s1_cfg.mair = 0xabcdef012345678ULL;
+	ret = pt_iommu_armv8_init(&smmu_domain.armv8pt, &cfg, GFP_KERNEL);
+	WARN_ON(ret);
 
 	arm_smmu_make_s1_cd(cd, &master, &smmu_domain);
+	pt_iommu_deinit(&smmu_domain.armv8pt.iommu);
 }
 
 static void arm_smmu_v3_write_cd_test_s1_clear(struct kunit *test)
@@ -834,5 +834,6 @@ static struct kunit_suite arm_smmu_v3_test_module = {
 kunit_test_suites(&arm_smmu_v3_test_module);
 
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
 MODULE_DESCRIPTION("KUnit tests for arm-smmu-v3 driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c0daf5102d88a5..149d5272edc35b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -16,9 +16,11 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
-#include <linux/io-pgtable.h>
+#include <linux/generic_pt/iommu.h>
 #include <linux/iopoll.h>
 #include <linux/jump_label.h>
+
+#include "../../iommu-pages.h"
 #include <linux/module.h>
 #include <linux/msi.h>
 #include <linux/of.h>
@@ -1678,25 +1680,24 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
-	const struct io_pgtable_cfg *pgtbl_cfg =
-		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
-	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
-		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
+	struct pt_iommu_armv8_hw_info info;
+
+	pt_iommu_armv8_hw_info(&smmu_domain->armv8pt, &info);
 
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
-		FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
-		FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
-		FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
-		FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
-		FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, info.tsz) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_TG0, info.tg) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, info.irgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, info.orgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_SH0, info.sh) |
 #ifdef __BIG_ENDIAN
 		CTXDESC_CD_0_ENDI |
 #endif
 		CTXDESC_CD_0_TCR_EPD1 |
 		CTXDESC_CD_0_V |
-		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, info.ps) |
 		CTXDESC_CD_0_AA64 |
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
@@ -1705,14 +1706,12 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
 		);
 
-	/* To enable dirty flag update, set both Access flag and dirty state update */
-	if (pgtbl_cfg->quirks & IO_PGTABLE_QUIRK_ARM_HD)
+	if (smmu_domain->armv8pt.armpt.common.features & BIT(PT_FEAT_ARMV8_DBM))
 		target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_HA |
 					       CTXDESC_CD_0_TCR_HD);
 
-	target->data[1] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.ttbr &
-				      CTXDESC_CD_1_TTB0_MASK);
-	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.mair);
+	target->data[1] = cpu_to_le64(info.ttb & CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(info.s1.mair);
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s1_cd);
 
@@ -1977,13 +1976,12 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 bool ats_enabled)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
-	const struct io_pgtable_cfg *pgtbl_cfg =
-		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
-	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
-		&pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
+	struct pt_iommu_armv8_hw_info info;
 	u64 vtcr_val;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	pt_iommu_armv8_hw_info(&smmu_domain->armv8pt, &info);
+
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
 		STRTAB_STE_0_V |
@@ -1997,19 +1995,20 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				   STRTAB_STE_1_INSTCFG_DATA :
 				   STRTAB_STE_1_INSTCFG_INCOMING));
 
-	if (pgtbl_cfg->quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+	if (smmu_domain->armv8pt.armpt.common.features &
+	    BIT(PT_FEAT_ARMV8_S2FWB))
 		target->data[1] |= cpu_to_le64(STRTAB_STE_1_S2FWB);
 	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
 		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 							  STRTAB_STE_1_SHCFG_INCOMING));
 
-	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
+	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, info.tsz) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, info.s2.sl0) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, info.irgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, info.orgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, info.sh) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, info.tg) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, info.ps);
 	target->data[2] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
 		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
@@ -2021,8 +2020,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		(master->stall_enabled ? STRTAB_STE_2_S2S : 0) |
 		STRTAB_STE_2_S2R);
 
-	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
-				      STRTAB_STE_3_S2TTB_MASK);
+	target->data[3] = cpu_to_le64(info.ttb & STRTAB_STE_3_S2TTB_MASK);
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s2_domain_ste);
 
@@ -2480,14 +2478,6 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-/* IO_PGTABLE API */
-static void arm_smmu_tlb_inv_context(void *cookie)
-{
-	struct arm_smmu_domain *smmu_domain = cookie;
-
-	arm_smmu_domain_inv(smmu_domain);
-}
-
 /*
  * Check address alignment for TTL hint per SMMUv3 H.a Section 4.4.1. Address
  * bits below the alignment must be zero, otherwise UNPREDICTABLE.
@@ -3112,47 +3102,6 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
 	rcu_read_unlock();
 }
 
-static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
-					 unsigned long iova, size_t granule,
-					 void *cookie)
-{
-	struct arm_smmu_domain *smmu_domain = cookie;
-	struct iommu_domain *domain = &smmu_domain->domain;
-
-	iommu_iotlb_gather_add_page(domain, gather, iova, granule);
-}
-
-/*
- * Called by io-pgtable-arm.c for a table level it wants to remove. This
- * implicitly includes any table levels below it as well, there is no seperate
- * invalidation for child tables if their parent's range is fully covered. size
- * is the size of the table level and granule is the tg in bytes. This must
- * clear the walk cache and any leaves within the range.
- */
-static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
-				  size_t granule, void *cookie)
-{
-	struct arm_smmu_domain *smmu_domain = cookie;
-	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
-	struct arm_smmu_tlbi tlbi = {
-		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.start = iova,
-		.last = iova + size - 1,
-	};
-	u8 level = arm_smmu_pt_lg2sz_to_level(tgsz_lg2, ilog2(size));
-
-	tlbi.table_levels_bitmap = GENMASK(level, 1);
-	tlbi.leaf_levels_bitmap = BIT(level) - 1;
-
-	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
-}
-
-static const struct iommu_flush_ops arm_smmu_flush_ops = {
-	.tlb_flush_all	= arm_smmu_tlb_inv_context,
-	.tlb_flush_walk = arm_smmu_tlb_inv_walk,
-	.tlb_add_page	= arm_smmu_tlb_inv_page_nosync,
-};
-
 static bool arm_smmu_dbm_capable(struct arm_smmu_device *smmu)
 {
 	u32 features = (ARM_SMMU_FEAT_HD | ARM_SMMU_FEAT_COHERENCY);
@@ -3172,7 +3121,6 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
 		return arm_smmu_master_canwbs(master);
 	case IOMMU_CAP_NOEXEC:
-	case IOMMU_CAP_DEFERRED_FLUSH:
 		return true;
 	case IOMMU_CAP_DIRTY_TRACKING:
 		return arm_smmu_dbm_capable(master->smmu);
@@ -3230,7 +3178,7 @@ static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
-	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
+	pt_iommu_deinit(&smmu_domain->armv8pt.iommu);
 
 	/* Free the ASID or VMID */
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
@@ -3283,66 +3231,69 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu, u32 flags)
 {
 	int ret;
-	enum io_pgtable_fmt fmt;
-	struct io_pgtable_cfg pgtbl_cfg;
-	struct io_pgtable_ops *pgtbl_ops;
+	struct pt_iommu_armv8_cfg cfg = {};
 	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
 				 struct arm_smmu_domain *smmu_domain);
 	bool enable_dirty = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 
-	pgtbl_cfg = (struct io_pgtable_cfg) {
-		.pgsize_bitmap	= smmu->pgsize_bitmap,
-		.coherent_walk	= smmu->features & ARM_SMMU_FEAT_COHERENCY,
-		.tlb		= &arm_smmu_flush_ops,
-		.iommu_dev	= smmu->dev,
-	};
+	cfg.tgsz_lg2 =
+		pt_iommu_armv8_choose_granule_lg2sz(smmu->pgsize_bitmap);
+	if (!cfg.tgsz_lg2)
+		return -EOPNOTSUPP;
+
+	cfg.common.features |= BIT(PT_FEAT_DETAILED_GATHER);
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);
 
 	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1: {
-		unsigned long ias = (smmu->features &
-				     ARM_SMMU_FEAT_VAX) ? 52 : 48;
-
-		pgtbl_cfg.ias = min_t(unsigned long, ias, VA_BITS);
-		pgtbl_cfg.oas = smmu->oas;
-		if (enable_dirty)
-			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;
-		fmt = ARM_64_LPAE_S1;
+	case ARM_SMMU_DOMAIN_S1:
+		/*
+		 * Historically FEAT_VAX maps to LVA behavior in the io-pgtable.
+		 * IDRs should be decoded more completely to select
+		 * LVA/LPA/LPA2.
+		 */
+		if (smmu->features & ARM_SMMU_FEAT_VAX &&
+		    cfg.tgsz_lg2 == 16) {
+			cfg.common.features |= BIT(PT_FEAT_ARMV8_LVA);
+			cfg.common.hw_max_vasz_lg2 = 52;
+		} else {
+			cfg.common.hw_max_vasz_lg2 = 48;
+		}
+		cfg.common.hw_max_oasz_lg2 = smmu->oas;
+		if (enable_dirty) {
+			cfg.common.features |= BIT(PT_FEAT_ARMV8_DBM);
+			smmu_domain->domain.dirty_ops = &arm_smmu_dirty_ops;
+		}
 		finalise_stage_fn = arm_smmu_domain_finalise_s1;
 		break;
-	}
 	case ARM_SMMU_DOMAIN_S2:
 		if (enable_dirty)
 			return -EOPNOTSUPP;
-		pgtbl_cfg.ias = smmu->oas;
-		pgtbl_cfg.oas = smmu->oas;
-		fmt = ARM_64_LPAE_S2;
-		finalise_stage_fn = arm_smmu_domain_finalise_s2;
+		cfg.common.features |= BIT(PT_FEAT_ARMV8_S2);
+		cfg.common.hw_max_vasz_lg2 = smmu->oas;
+		cfg.common.hw_max_oasz_lg2 = smmu->oas;
 		if ((smmu->features & ARM_SMMU_FEAT_S2FWB) &&
 		    (flags & IOMMU_HWPT_ALLOC_NEST_PARENT))
-			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
+			cfg.common.features |= BIT(PT_FEAT_ARMV8_S2FWB);
+		finalise_stage_fn = arm_smmu_domain_finalise_s2;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
-	if (!pgtbl_ops)
-		return -ENOMEM;
+	smmu_domain->armv8pt.iommu.iommu_device = smmu->dev;
+	ret = pt_iommu_armv8_init(&smmu_domain->armv8pt, &cfg, GFP_KERNEL);
+	if (ret)
+		return ret;
 
-	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
-	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
-	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
-	smmu_domain->domain.geometry.force_aperture = true;
-	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
-		smmu_domain->domain.dirty_ops = &arm_smmu_dirty_ops;
+	smmu_domain->tgsz_lg2 = cfg.tgsz_lg2;
 
 	ret = finalise_stage_fn(smmu, smmu_domain);
 	if (ret < 0) {
-		free_io_pgtable_ops(pgtbl_ops);
+		pt_iommu_deinit(&smmu_domain->armv8pt.iommu);
 		return ret;
 	}
 
-	smmu_domain->pgtbl_ops = pgtbl_ops;
 	smmu_domain->smmu = smmu;
 	return 0;
 }
@@ -4390,7 +4341,6 @@ arm_smmu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 		goto err_free;
 	}
 
-	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
 	ret = arm_smmu_domain_finalise(smmu_domain, smmu, flags);
 	if (ret)
@@ -4402,31 +4352,6 @@ arm_smmu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 	return ERR_PTR(ret);
 }
 
-static int arm_smmu_map_pages(struct iommu_domain *domain, unsigned long iova,
-			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
-			      int prot, gfp_t gfp, size_t *mapped)
-{
-	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
-
-	if (!ops)
-		return -ENODEV;
-
-	return ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot, gfp, mapped);
-}
-
-static size_t arm_smmu_unmap_pages(struct iommu_domain *domain, unsigned long iova,
-				   size_t pgsize, size_t pgcount,
-				   struct iommu_iotlb_gather *gather)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
-
-	if (!ops)
-		return 0;
-
-	return ops->unmap_pages(ops, iova, pgsize, pgcount, gather);
-}
-
 static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -4448,46 +4373,23 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 	 */
 
 	if (smmu_domain->smmu)
-		arm_smmu_tlb_inv_context(smmu_domain);
+		arm_smmu_domain_inv(smmu_domain);
 }
 
-/*
- * io-pgtable-arm.c calls this function either under
- * arm_smmu_tlb_inv_page_nosync() or via the normal iommu code to flush the
- * gather. Due to how iommu_iotlb_gather_add_page() works the gather will end up
- * with a single uniform pgsize leaf. If it has to change to a different leaf
- * level then it flushes the gather and starts a fresh one. Thus this always
- * targets only a single leaf level.
- */
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	unsigned int tg = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.start = gather->start,
 		.last = gather->end,
+		.leaf_levels_bitmap = gather->pt.leaf_levels_bitmap,
+		.table_levels_bitmap = gather->pt.table_levels_bitmap,
 	};
 
-	if (WARN_ON(gather->pgsize < BIT(tg)))
-		return;
-
-	tlbi.leaf_levels_bitmap =
-		BIT(arm_smmu_pt_lg2sz_to_level(tg, ilog2(gather->pgsize)));
-
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
-}
-
-static phys_addr_t
-arm_smmu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova)
-{
-	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
-
-	if (!ops)
-		return 0;
-
-	return ops->iova_to_phys(ops, iova);
+	iommu_put_pages_list(&gather->freelist);
 }
 
 static struct platform_driver arm_smmu_driver;
@@ -4749,17 +4651,6 @@ static void arm_smmu_release_device(struct device *dev)
 	kfree(master);
 }
 
-static int arm_smmu_read_and_clear_dirty(struct iommu_domain *domain,
-					 unsigned long iova, size_t size,
-					 unsigned long flags,
-					 struct iommu_dirty_bitmap *dirty)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
-
-	return ops->read_and_clear_dirty(ops, iova, size, flags, dirty);
-}
-
 static int arm_smmu_set_dirty_tracking(struct iommu_domain *domain,
 				       bool enabled)
 {
@@ -4849,20 +4740,18 @@ static const struct iommu_ops arm_smmu_ops = {
 	.user_pasid_table	= 1,
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		IOMMU_PT_DOMAIN_OPS(armv8),
 		.attach_dev		= arm_smmu_attach_dev,
 		.enforce_cache_coherency = arm_smmu_enforce_cache_coherency,
 		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
-		.map_pages		= arm_smmu_map_pages,
-		.unmap_pages		= arm_smmu_unmap_pages,
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
-		.iova_to_phys		= arm_smmu_iova_to_phys,
 		.free			= arm_smmu_domain_free_paging,
 	}
 };
 
 static struct iommu_dirty_ops arm_smmu_dirty_ops = {
-	.read_and_clear_dirty	= arm_smmu_read_and_clear_dirty,
+	IOMMU_PT_DIRTY_OPS(armv8),
 	.set_dirty_tracking     = arm_smmu_set_dirty_tracking,
 };
 
@@ -5578,7 +5467,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	/*
 	 * Translation table endianness.
 	 * We currently require the same endianness as the CPU, but this
-	 * could be changed later by adding a new IO_PGTABLE_QUIRK.
+	 * could be changed later by adding a new feature flag.
 	 */
 	switch (FIELD_GET(IDR0_TTENDIAN, reg)) {
 	case IDR0_TTENDIAN_MIXED:
@@ -6183,4 +6072,5 @@ module_driver(arm_smmu_driver, platform_driver_register,
 MODULE_DESCRIPTION("IOMMU API for ARM architected SMMUv3 implementations");
 MODULE_AUTHOR("Will Deacon <will@kernel.org>");
 MODULE_ALIAS("platform:arm-smmu-v3");
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a59b17679e6716..17ad696ed69305 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -9,6 +9,7 @@
 #define _ARM_SMMU_V3_H
 
 #include <linux/bitfield.h>
+#include <linux/generic_pt/iommu.h>
 #include <linux/iommu.h>
 #include <linux/iommufd.h>
 #include <linux/kernel.h>
@@ -824,12 +825,6 @@ static inline unsigned int arm_smmu_pt_level_to_lg2sz(unsigned int tgsz_lg2,
 	return tgsz_lg2 + (tgsz_lg2 - ilog2(sizeof(u64))) * level;
 }
 
-static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
-						      unsigned int lg2sz)
-{
-	return (lg2sz - tgsz_lg2) / (tgsz_lg2 - ilog2(sizeof(u64)));
-}
-
 struct arm_smmu_tlbi {
 	unsigned long start;
 	unsigned long last;
@@ -1094,9 +1089,12 @@ enum arm_smmu_domain_stage {
 };
 
 struct arm_smmu_domain {
-	struct arm_smmu_device		*smmu;
+	union {
+		struct iommu_domain	domain;
+		struct pt_iommu_armv8	armv8pt;
+	};
 
-	struct io_pgtable_ops		*pgtbl_ops;
+	struct arm_smmu_device		*smmu;
 	atomic_t			nr_ats_masters;
 
 	enum arm_smmu_domain_stage	stage;
@@ -1105,8 +1103,6 @@ struct arm_smmu_domain {
 		struct arm_smmu_s2_cfg		s2_cfg;
 	};
 
-	struct iommu_domain		domain;
-
 	struct arm_smmu_invs __rcu	*invs;
 
 	/* List of struct arm_smmu_master_domain */
@@ -1118,6 +1114,7 @@ struct arm_smmu_domain {
 
 	struct mmu_notifier		mmu_notifier;
 };
+PT_IOMMU_CHECK_DOMAIN(struct arm_smmu_domain, armv8pt.iommu, domain);
 
 struct arm_smmu_nested_domain {
 	struct iommu_domain domain;
-- 
2.43.0

