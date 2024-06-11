Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895E133D8;
	Tue, 11 Jun 2024 00:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065898; cv=fail; b=QD9iMRkRRGCGhmtVmkrFfr2xpbQvz2CX4bL1vjeztK0vJSoi6xl9C99tI4G4nTfh9Fm6NWqZI4cnPkrsCNNoUd0cxxq7KbytzKMh+hZZnrt63aAzeU2kvH8BaNxOnA7HiyW14iheUWoccYrOjf2G1P8fHBj3g8LdXe9oSgqhpm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065898; c=relaxed/simple;
	bh=+PtqLZq4LP7U8uNiCZKeU8V/URx5urvugImuVnbGLo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jfm30w8ePKwLuI/qfBHcf6AIuYs0ACrj6OBhk6Wh6SSXgchxI/Qm91XZphyA5dKD2DZWdnuYdRUKUVnRN0y+Wga6dkYtVZBal4jKbnwU46xUn8OFwOrDsGu/Cs1OxhmiR7+YBlMD1TNMykq69qweyzwhjhqqtbgkpLzqrK831uU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VLZlJKHL; arc=fail smtp.client-ip=40.107.94.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VLZlJKHL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gsg++cFRZYpZp4OtmFVaUKMhfTtQ8KvLp67MTv+w1MiNChF/Ud52tojXc4KG25HslAWX6YmQVVCN+6VGYehdVdEb0p8Ytr7Ut8YTZQDMHns7iF5Aanj+cKDB3FSWjI5Vz/idPx31P0IyDNVRenyWTunReOUuj+7ofxnYlcH4Zupt9Q2EKgVzNulH76MHcosuwqogJjwO/7NSfn4HzpHqRpGJBeS6fOn4mqlv1zn4j5outJVJAv4sKyDcAGE6bPTnkmc0n4jnV6WQYKsq+/7sd5ZHD9TvOvgIz9oF8HAJuFl3gA0lUAThB40fnXYFQXk2Og5L2ue2FLLZAO3GESf4WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lX1QUef6bYyb89bDk3ithjEsdCoPn97OMfpZsr2X4Y=;
 b=dzKubjcSPtdOvkxmGzz2hBIxxOA4CGf2LKAHtOHJsWV7wfSCEcdjuTN7PnR7ipKNJBgs69/PVVzVgr+OhqvqBr1W1/iR1ydM0RIa1pecNfFqVKl09ILcKrxh9HTFtCT7UOWx3FCEMFh5iRIsBrd/sFbPR/zn8Nc4NirAWlxx4GzxIAz5CzTzSqhTsAGggTBBGDyJZaibS9JJbBeCEi1LOXjctMRc7TP7MjegVTXO47p3XKc96uP8FWH7T38e16NJ9GEiBY7E60q1r5Br8/gQZg8Fsz1rN6Y95rJJJsuzsuJDsI6ICsMghUj2OYJXp0lY3z9T228XT6XYllXnifQoGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lX1QUef6bYyb89bDk3ithjEsdCoPn97OMfpZsr2X4Y=;
 b=VLZlJKHLneXHG83kk30VYEs9UyaEKFSCiA3Ij9xMVaqK5xlT1Uky0LIK93z7rtfJrPPWNvjg3AiY+T5MeEIXnq8uChbHtIBIQS37m4T24mdu3xtqB4BjhLtZp+PeuRWbB+OXMh4gQjSd2JCFKvRRAWyWjfHbk6GtVHS/UV2j2YUcBGriYU4rqESv3LG7gZT1a0fjiFZRAmNAiZ3PRHuJb5m/Nx3uLq72YwIU6DP6XjrIW6NK6REdp8jTInhgwBwI4i6/RerwDP5x4hhkAQhOcfTzDyNvkLES5dVB1lbRlbjHYDE/1F6kf5rAlS7gMOLK+g32bZNtQjLSwDCIy634+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:25 +0000
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
Subject: [PATCH v2 09/10] iommu/arm-smmu-v3: Add types for each level of the CD table
Date: Mon, 10 Jun 2024 21:31:18 -0300
Message-ID: <9-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0015.namprd18.prod.outlook.com
 (2603:10b6:208:23c::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 87542964-ecb9-4dfb-4fc5-08dc89add18f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5wqXbaOZNn07PovzCG6SrsvAhAVREg7YZ3Gs3d948Edad+q61JcDpt1t8Mfo?=
 =?us-ascii?Q?KyYnab8WcUufc8phxzfSYfyPFumH5MxuS1tmRP64Bwvn/frFv+T5MI8Pd411?=
 =?us-ascii?Q?w3FXGrbhRysKmb1Vp7fyZk61ogTIcup9U57b4Tn+kVHdwRl7gGyt9nHwMoCa?=
 =?us-ascii?Q?uaHnHOcb7jNxByd9zpuhOa/OBWe+5bQH/bFzk9Ckda73H+NsNvB+/Gi6vZ1S?=
 =?us-ascii?Q?NIynmQqppjQRwwi35pRfzf9ezvbzvDMwKW0Km04DiC8+8AelV9r+zvMxnL7s?=
 =?us-ascii?Q?3yaUhdIDfp0K7dwC92LUnpXxzlXOY9/TZeaa5TWdTcoD400IERQyYOy3onem?=
 =?us-ascii?Q?yImt9XPtqarFFcdIG7Bd+zS74JG+HklaMVtHU8GEwk1AOBcIauM2jLNeHkW3?=
 =?us-ascii?Q?jTs19TwA8eyXlfhb8kQLX4x4pZum9ckZwkjl7w/MFJt6F/ZlCzPeczxb7bUn?=
 =?us-ascii?Q?QOgrkW9zMaAQ7yoa1rn9GXMWgdbnzYdTRwdCUmxMEY5SP2AtxTt98fUmQ6GX?=
 =?us-ascii?Q?uQ98thzGubUhHETe5Ji+DptCd06rtA5CAYNWeQsdsOI8FJD0MC7zmxsghTzx?=
 =?us-ascii?Q?3OHExu2h/KRXzvCtTfIGCEd2P0oXKtMYYkrCQUTOmOdpBq/uMNtmgIBSVjtX?=
 =?us-ascii?Q?gwP/o14SgKNbiW1DeRKDWYmbkBAmtGbIXkbWx40r+FLxk6HssymgNS5sQMjE?=
 =?us-ascii?Q?fAX7gK8B3zDtXitHZFz4cOvrRcNNbqvdawNO8PisVhOmOP6KHMraok63jzYq?=
 =?us-ascii?Q?uUVe7eb8EGKvsR4cwyxsNUnxFwFI+/z6B1rTNJrvnjn9O432WaApKVQK1DsX?=
 =?us-ascii?Q?aesU0Uc2K3xAMd7Wo+eGIr/9sa1e0RLuFvg6oGjX4e6TBsX0bRNehyMd0jDA?=
 =?us-ascii?Q?ztAz/EdTUQ3W+O3y+jNURZe9wn2HReoXs5ioMMqqwJWENuzVGXtWY74GqPuQ?=
 =?us-ascii?Q?J9yieBjBfzv7+qlbEGnHx2Rnqvk0Kc1Kvd0eFPfq3JPvv6aHLs1dV6NCvYa0?=
 =?us-ascii?Q?phKXpIMai45hmGkU0MgTc9SYwGymE88C3N1Lt4zUnsnQmfLxmR93Nx88jJuL?=
 =?us-ascii?Q?PO0R5ShjBgvVYCZPGVo43cxTWbWlpBVeIGrYD7Lyqhxz8beZf9lOj/rvQ99u?=
 =?us-ascii?Q?pv3FXgK3XETqthcWrhHjA/KRymtEoqeOqBQinEGMh/MJlYCdI9TEGj8Lbhva?=
 =?us-ascii?Q?QgUrrNAgNHj0le0at8zk1o5uzhsrIVG95AwYGmamSGoof1PpZgVld+eC76xg?=
 =?us-ascii?Q?nV7fspGDoIvsk3Ykjasg71GOA61lfSMcgc1ctDAQx2SOuS5AUPYcKiP4/GnQ?=
 =?us-ascii?Q?Ppj14Kq6WtjpzKy29ewUZFSb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wQ4n+yiEwPi9AjkaHumwd7clUQaPyD+Gb2opWMaT0zuOCvfXSDnPhjRK/cYG?=
 =?us-ascii?Q?E0zszTzdlI54Gt7diQ3zrwNyR1TI8OfQFJ1SouI4WRvTfmTT0jbh7DECp1oQ?=
 =?us-ascii?Q?1vRoomXqpa3/qjmUYXuoonpl11qIqs5nIKAlFyYjl9ike9vC9vP4VHmuyFIx?=
 =?us-ascii?Q?+21S9wps8sLBkW2Yl9QxWx9uT0jW80N3jsf/TE2SA5hMQCuOBA0ttADFnrpn?=
 =?us-ascii?Q?YtynKtPVF0coPlwIcHvQjcZ0w0AjXrGs6yS439MMu2Hsb4av3oGUN6ZLTWni?=
 =?us-ascii?Q?yGxHy+nG3A+zRGCpUK4pTlQJov8ilIePKEeCLTtn0j28s1D5FiVSZbiyq7d0?=
 =?us-ascii?Q?rJp6rvG3UbzbBjN0f3plJGoJzXG7iDXF+vpijVAHwyI3mO3erUCxlBxquQUt?=
 =?us-ascii?Q?3dvaaZWiAdXw3VrP04PbcBO47C3KPC6dq8vSJDxn2HUwiNlwHVR+lK/XJXc6?=
 =?us-ascii?Q?rHxUH3NKGsnbcNmFPsOCGdVDpxOVy2/0ArRiqixN3xsGRN+cvN888iSy+T7R?=
 =?us-ascii?Q?VLvJrcqI8r775yDbSY4Kc1K9L7ZVf9fz2Z5qFjP9SBukIi1dvbtuv7ZAKlAl?=
 =?us-ascii?Q?UgKWa6NfXGyqiEtzZhm9KhCo6stya6rQ7qtq/mDhZZOGA0lCZ84TUAwBC8ZX?=
 =?us-ascii?Q?P7W+pt70kBnoX1xm6tn7VZmw+Q2/kwZXm/59I4MDORYLUjmNrvIsLi2N7NZr?=
 =?us-ascii?Q?7njJexeclK0RklmpUZC4xlwNAGDBPV0fkkU621m5GZ/988dEaR32Jt7JiN83?=
 =?us-ascii?Q?bf6ejaEsdagkA90uTNjBwP0Ll7IT0K7teNvmJrSrE1Jn7sEnHCehVugZnzf/?=
 =?us-ascii?Q?cjiRXwmF11PC3zKRlbeGMmB5DxZDdmAk2rLz1XgKeV9FgxyAP8/a8UeVOqTQ?=
 =?us-ascii?Q?aftLulyvOIx5qpIFvg4mpdRcwWUTtWV7PritgEbIVAI8fq0v8Pi9DN6gpEfV?=
 =?us-ascii?Q?HsjJ0uBJcXohiHQxxBMqnm7OO0hiGLyM4XNnPO0SOtekxcadf5S4BSRpo/hO?=
 =?us-ascii?Q?RbIomUtPTP+ezDiFuysCXoVhGN3aE6c+2n8kh0BeI4tb9xYmkj7tvvh1znB1?=
 =?us-ascii?Q?TrkF9+H5yKIfdFYm85BgHwQDXftdTEUGp4KCDJGTDIAF09yLu2VlL+seZrNj?=
 =?us-ascii?Q?j84fRpaUOOluYLN7JXGBWhLQL+uG/ILJdLTv1O084TLkgegpawupz+FNt7QP?=
 =?us-ascii?Q?btmsJdpU+ZQrBBnw947XDihSHbnU1SB5LCMaaz9bCoK1VIjzMe7MgtHF1/kg?=
 =?us-ascii?Q?Mir2cDa9+1hIpa7GgrrDEur5hmugO7Ux3mptIDdKkNLERDP5x2OLZL7j2GTt?=
 =?us-ascii?Q?dMkxejyt4yy7WppukEPRJncEhclY9W8etFfMnmLrc+ZOsEUk8xe8XA2aUev3?=
 =?us-ascii?Q?9fkPyrMAKGkdKXE8iuu3eSMDaYamjtuj56g6lvhJXnlUC+ayzs6EhwQmFEX1?=
 =?us-ascii?Q?UUma4ue6VD3OEx8r20YJ79wfthFOXVpfcHiA2wfkPhA0v21tGRsBVeDYCy0b?=
 =?us-ascii?Q?K8P/QSn3sA7MjDE04BYg/w9R4+cXur/9x1XwiWZnwy+Fx/V8C34bhFGInpwY?=
 =?us-ascii?Q?vzfoL4n5R325haQMu+I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87542964-ecb9-4dfb-4fc5-08dc89add18f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:21.8992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLYqxjqYnZ9R48NDYUGsZIbQcTSj4ECytqGtxGEbcOTwfM9wQw/FDzfCn8xA52Ms
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

As well as indexing helpers arm_smmu_cdtab_l1/2_idx().

Remove CTXDESC_L1_DESC_DWORDS and CTXDESC_CD_DWORDS replacing them all
with type specific calculations.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 46 +++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 27 +++++++++---
 2 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index dd65e27aebafd4..49e019131ef3b5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1167,17 +1167,18 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
-static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
+static void arm_smmu_write_cd_l1_desc(struct arm_smmu_cdtab_l1 *dst,
+				      dma_addr_t l2ptr_dma)
 {
 	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
 
 	/* The HW has 64 bit atomicity with stores to the L2 CD table */
-	WRITE_ONCE(*dst, cpu_to_le64(val));
+	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
-static dma_addr_t arm_smmu_cd_l1_get_desc(const __le64 *src)
+static dma_addr_t arm_smmu_cd_l1_get_desc(const struct arm_smmu_cdtab_l1 *src)
 {
-	return le64_to_cpu(src) & CTXDESC_L1_DESC_L2PTR_MASK;
+	return le64_to_cpu(src->l2ptr) & CTXDESC_L1_DESC_L2PTR_MASK;
 }
 
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
@@ -1190,13 +1191,12 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 		return NULL;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return (struct arm_smmu_cd *)(cd_table->cdtab +
-					      ssid * CTXDESC_CD_DWORDS);
+		return &((struct arm_smmu_cd *)cd_table->cdtab)[ssid];
 
-	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];
+	l1_desc = &cd_table->l1_desc[arm_smmu_cdtab_l1_idx(ssid)];
 	if (!l1_desc->l2ptr)
 		return NULL;
-	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
+	return &l1_desc->l2ptr->cds[arm_smmu_cdtab_l2_idx(ssid)];
 }
 
 struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
@@ -1214,7 +1214,7 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 	}
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
-		unsigned int idx = ssid / CTXDESC_L2_ENTRIES;
+		unsigned int idx = arm_smmu_cdtab_l1_idx(ssid);
 		struct arm_smmu_l1_ctx_desc *l1_desc;
 
 		l1_desc = &cd_table->l1_desc[idx];
@@ -1228,8 +1228,10 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 			if (!l1_desc->l2ptr)
 				return NULL;
 
-			arm_smmu_write_cd_l1_desc(&cd_table->cdtab[idx],
-						  l2ptr_dma);
+			arm_smmu_write_cd_l1_desc(
+				&((struct arm_smmu_cdtab_l1 *)
+					  cd_table->cdtab)[idx],
+				l2ptr_dma);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
 		}
@@ -1358,7 +1360,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
 		cd_table->num_l1_ents = max_contexts;
 
-		l1size = max_contexts * (CTXDESC_CD_DWORDS << 3);
+		l1size = max_contexts * sizeof(struct arm_smmu_cd);
 	} else {
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_64K_L2;
 		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
@@ -1370,7 +1372,8 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		if (!cd_table->l1_desc)
 			return -ENOMEM;
 
-		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
+		l1size = cd_table->num_l1_ents *
+			 sizeof(struct arm_smmu_cdtab_l1);
 	}
 
 	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
@@ -1394,27 +1397,28 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 {
 	int i;
-	size_t size, l1size;
+	size_t l1size;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (cd_table->l1_desc) {
-		size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
-
 		for (i = 0; i < cd_table->num_l1_ents; i++) {
 			if (!cd_table->l1_desc[i].l2ptr)
 				continue;
 
-			dma_free_coherent(smmu->dev, size,
+			dma_free_coherent(smmu->dev,
+					  sizeof(*cd_table->l1_desc[i].l2ptr),
 					  cd_table->l1_desc[i].l2ptr,
-					  arm_smmu_cd_l1_get_desc(
-						  &cd_table->cdtab[i]));
+					  arm_smmu_cd_l1_get_desc(&(
+						  (struct arm_smmu_cdtab_l1 *)
+							  cd_table->cdtab)[i]));
 		}
 		kfree(cd_table->l1_desc);
 
-		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
+		l1size = cd_table->num_l1_ents *
+			 sizeof(struct arm_smmu_cdtab_l1);
 	} else {
-		l1size = cd_table->num_l1_ents * (CTXDESC_CD_DWORDS << 3);
+		l1size = cd_table->num_l1_ents * sizeof(struct arm_smmu_cd);
 	}
 
 	dma_free_coherent(smmu->dev, l1size, cd_table->cdtab,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 2f7d70d92b1f31..7ed8d53423cf56 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -293,16 +293,31 @@ static inline unsigned int arm_smmu_strtab_l2_idx(unsigned int sid)
  */
 #define CTXDESC_L2_ENTRIES		1024
 
-#define CTXDESC_L1_DESC_DWORDS		1
 #define CTXDESC_L1_DESC_V		(1UL << 0)
 #define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
 
-#define CTXDESC_CD_DWORDS		8
-
 struct arm_smmu_cd {
-	__le64 data[CTXDESC_CD_DWORDS];
+	__le64 data[8];
 };
 
+struct arm_smmu_cdtab_l2 {
+	struct arm_smmu_cd cds[CTXDESC_L2_ENTRIES];
+};
+
+struct arm_smmu_cdtab_l1 {
+	__le64 l2ptr;
+};
+
+static inline unsigned int arm_smmu_cdtab_l1_idx(unsigned int ssid)
+{
+	return ssid / CTXDESC_L2_ENTRIES;
+}
+
+static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
+{
+	return ssid % CTXDESC_L2_ENTRIES;
+}
+
 #define CTXDESC_CD_0_TCR_T0SZ		GENMASK_ULL(5, 0)
 #define CTXDESC_CD_0_TCR_TG0		GENMASK_ULL(7, 6)
 #define CTXDESC_CD_0_TCR_IRGN0		GENMASK_ULL(9, 8)
@@ -330,7 +345,7 @@ struct arm_smmu_cd {
  * When the SMMU only supports linear context descriptor tables, pick a
  * reasonable size limit (64kB).
  */
-#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / (CTXDESC_CD_DWORDS << 3))
+#define CTXDESC_LINEAR_CDMAX ilog2(SZ_64K / sizeof(struct arm_smmu_cd))
 
 /* Command queue */
 #define CMDQ_ENT_SZ_SHIFT		4
@@ -602,7 +617,7 @@ struct arm_smmu_ctx_desc {
 };
 
 struct arm_smmu_l1_ctx_desc {
-	struct arm_smmu_cd		*l2ptr;
+	struct arm_smmu_cdtab_l2	*l2ptr;
 };
 
 struct arm_smmu_ctx_desc_cfg {
-- 
2.45.2

