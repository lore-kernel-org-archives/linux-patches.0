Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAD6393;
	Wed, 27 Mar 2024 18:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562903; cv=fail; b=Ot4gryclG6L2wbITGwkOwSqOxkNvWeGcJb0El4jJ1lOn3gMNWdJ1sGE5G8L97+fLmsfdEI8Z3G9R/29iMOf47kUrJCcuFUH4MZABvqUfC3OBVtmT2+9keUw4Mf+K2t1RI5uj179eXumM5N47H3TbzkcmRFxbl1sVpUMNQa+CYz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562903; c=relaxed/simple;
	bh=jHv/9ghh9CNMvGIFnC9yC0H2MhZwyEm3u67KIYFwfyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UFwPqYqr/qPjirjFock9Xd/jNwAeEj003LZYZFvDnSClDyL/8Htfm8/MNqe4Tz1SyXP3E0GxsPOzGpQfbbXUCJq51XIumrs8ozK8k0nJFyLydlbfCQzOsYIICCyusRwOo78DzOjoOqeaDg9iYft6BoYGVN+S9j4v43bKovArDqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m5pVj1mX; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m5pVj1mX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MR9RnnUUbBwhP2aCyt88wUCoK188q7NfCygnXpgNVmH/LcyMwHTtm6b0K9JuhbI5qwAFmOT9ATMS+6Exax4dyex01fjs7hc4E/f9AkJsli5kxDfTyUcOXiH3xVP3nZ0RMbDu1x0h5VFKM4iyGKPhdtrj/p2wJYLGgRhvcLBgt3rBKsjB3z5cvJijtl1juBN2lzS21U2Q2ATNZCVCR1n1xH3iUvK74QrSncmdC+PZ3dnjlgXoRds/Ft5BSDQ4+66UWp+XD+dqYg8JwjoA996XvMBQsQFh2R7XHKEdD8Utt9Rm43ubT1aIXakx2vW8d/WzPxXDpV1SE8hv1VXJ8/JvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yfv0ZAW0JRpnvf+9YtpH+CzkLMQq2+WNeiPASvI/ZE=;
 b=WERMPZ9VKEMLVNS6vGS4l5Gb1toyMayB4a+O66m0Iz1G/2dMOh8P+hkpJijpQQzRcKCL2U9EIssTtL3DL9t8nx4Rg/nE7fwOeCIIIcSXipWzIPyEDEtz4qXShkiMAVFAV+BhnuYhJtWijcEMDmCm0FqlNUTlPMw6n9KjV03BW/ZMlqwT+EYc1Kq8eOoZrVbuI+pRebnd4uKEHsAnQSEZpUr1t6P9iclQCam1g6Je50kLlcPYFfyPJRRUi3v9EeAiIKWhxDzGrFGLUHaWrA/fSYUUEV45o+q3xjQ19HSZfFnuhuVK44lcmG/uzmBYMZB+jSMXQ8T0A9YKBjCvi4/scA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yfv0ZAW0JRpnvf+9YtpH+CzkLMQq2+WNeiPASvI/ZE=;
 b=m5pVj1mXYmCv/kJ90rxwD7LGW9z6phpFnQxLJLpyEJ/+ddmrbeQzoI5sxk0TH2HEqiNMuJTJssciPKVaV8R5GYNuEpiyqi4UndXsD2UecCkC+GywfHf5MyBQQWkU1RWgwwZkDmxfsSJzFI7dUaXUGo88XXqMr9WVlZ5BSQF+dzmGUCKHLR2uh6ZeVRgRMkMMeCZOxJyNiYGWmJOIv/Rv2qPKG98Z0RDGCtNXu5UVXKpt3l2bP2w0NGkXZBiW1ze0yRUMuKkpBMKjueGLbS0fKuvycBfrP5lLPNsrznXtMHMBJaMVoe2E53/D3as4e53e6d51m3/0LW1SvZSVX8Mhpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:18 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:17 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 10/29] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
Date: Wed, 27 Mar 2024 15:07:56 -0300
Message-ID: <10-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0002.namprd20.prod.outlook.com
 (2603:10b6:208:e8::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: b592a4db-53ad-4fcf-7355-08dc4e88e0a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KY+v5blNwPmKdbLQW8EkWSo276nIAdx4WXUXUTdwcr2anhUinpjgduLx5UzRd/+Y9WB89JXUc08fHP6Qcq9v7toPwxRnoV3SB+jwEAy0ZXPsZpcDVK4sau9jQDtvKPp6PDEN5sFdaBwQuS/48iYEBmwST7l4lkqhNduS67x3S1JHPlZJLKP1vZUoFLM/tVvA49Yb69SYAwOE9iWjdIEJoRRxrDU6FznWJ/4ky77ZcKxSDioqDYfcUYzDAXtIoW6tQKg3xF+iB/9WiCqBxQXaNWNt1jemZvvqKiE9p9CfTFPsg7DchxK3AS9XuoT45PbCsQFTXOyK+Zl12BPaDrxgb8fJnOPpYXLsCaahYxRGa7tDE+Jf1qpUAZ9o3dO9YRssAzH4SKubAuUHG6ZryLDLqnYLUWs9MKVctcT850JLHDagZL7NPvKQhurBGedPY45YyNKDQW/njWYEFvUwq6LJjwgEJ+92NsU/QqaHVjbW0TU2bn4shKT8yzBXvbh+q6ZHUcTUhe1cEcqBcD3WvWLtmcD20Ji4gGOZXjuz4UeWLC20jgXCliSlAz8rmJOSnPOKWsdO5XgJu28KcDZ+dRazxOAA2f4SdXoCmWA/kD/roP2SiaaN8eCRrz5/8YbjZwd6Mn7oFoyL6TdV50Rb38ibtXD+vtV47I43vOxPamqAe04=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JWQ0cPi5UGdiW4AtPGdC883W8SMi99/P23hofy3cuz5YFhPKqZU3A+bTABCr?=
 =?us-ascii?Q?7QUtQTtIcu1Dh7rXd3UX6dQ2XfLmPeOK/V+yLH+9lwGYg6DrIQzuTUGNz7R+?=
 =?us-ascii?Q?FRep2e2/28a1a4DqLLdykx8n8alMsWs5o3/U6xzYKkmdsD4Plb60ntLf4Pfr?=
 =?us-ascii?Q?S+qJSHr7h4cElVjshMdZn/jogOhZWucGNlhtP0iywwt+LVO7omBfdxASGpAX?=
 =?us-ascii?Q?PYKaV54ucCJxnDtziSvhmCULe1DwlX3GbrKcNp3lRMu1UDK1q1x0pTU4Q7ca?=
 =?us-ascii?Q?9ytXqLK28vKVopH7JvoKN5jEH9mdx2FQnjk83nYzF8AiCAgjES4zQXQFbbs1?=
 =?us-ascii?Q?IfMj6mybf2uj14ixl6giPsolD9BU/jkD8e0FQfP7JntFu+eKuAmAuM54/3A6?=
 =?us-ascii?Q?MxV6KgUVjNgCCKxL2+c88G2H+R+cABePzc/0pidTC8yomhKbylVymSsy/IPz?=
 =?us-ascii?Q?bYegeVUkbBmHP1GiRuhadYhb3Yii7+nNJ9Pj4kRvvkSNJmHVgi/e7WcwhOjW?=
 =?us-ascii?Q?LfmV1JNba1WBJ2wYm+eELw8jDIM2KDKLbUjpubE1c1CTQwd5yQ0W5GFo9yPa?=
 =?us-ascii?Q?fMTyZxd1qTTwLurPnPN3zOCEAvXE5aVYvoDPu0dBR4vnGSmQ/j7DKWM/VfQ8?=
 =?us-ascii?Q?wMNjkeVczsTTTsP4nFiUYSjiudtpAGWI6zi45hTXCkEFWGSyOOTPci/pUbQQ?=
 =?us-ascii?Q?RrmNkflghnY27dvA2bCs54sPZoiyOyMXNFYHUNIMJGaqZQ7TskO0H22yV7M6?=
 =?us-ascii?Q?sVKa5cXv86TAm2NCeAdwMtF1zqIhAhEHUhIDisxSLn4Tn2YTqGk6wsukA7t/?=
 =?us-ascii?Q?08wkbKowCkb/aCcbDtnQLG1TlKFE0YUEwx1LjPBMvWCrnDM4+aoQSzJu9lrj?=
 =?us-ascii?Q?ktEWU3BTEm1BkZ4xW8hw2tZqr1dhdln+T4vfD+g0fYVnrd2yre1OyGjtj5NO?=
 =?us-ascii?Q?ZErvcpAbP+bUnzahmChcJP/5H5/LPDF3xqDYC/zSSkMXdc3O/5HY+QyWvmgm?=
 =?us-ascii?Q?RQwZN3OZe0ch1rvimmL++I+Z0dap8CVmGxSxuoeAGmH9W1KC1E39HkDA5WGi?=
 =?us-ascii?Q?BAChxedTVLpm/0F5Vya/48wBfMIqAWFVH3p4YAOJiH/Fw+zODJiWjcapAtAa?=
 =?us-ascii?Q?+b/Kim9bBn4yMMaqJge99ku1hWHC+t5UMD/GkS9D5x2QBR8zQNT912iXv3Y0?=
 =?us-ascii?Q?JBnAQnD8LxQIIe1bebXnNV8txggbE7mz7FMQtc9AcjiPl3nYQ0KsXQJCWO8C?=
 =?us-ascii?Q?ZSecmnyk1hLJuOUOntZf3Rn8WMNnQdU2D+i0OyFqicMfipwf3D6+SrSEaVYB?=
 =?us-ascii?Q?OHO3ByDAnAeuz7DkLhHUFiClCE6PL6EKKo3fUImXwztuaN59EH+r4w/vl7up?=
 =?us-ascii?Q?Ac6uUWXKmgirOhBvNpdISFnbXMq2Lm8iOTdS0yV2SAPLfX87A3ZRub/HH9v8?=
 =?us-ascii?Q?jiLjT3MpvDbyu13+o1mxsmMhI9Dc3SVBF3aZSewSVqts7/VGi7GKgMv2WdPn?=
 =?us-ascii?Q?NAG4nP/gIbr2D8zJELy/FbtQZg6g0ZHGEI6WdaF7VtAHzCTxK/xXl86PvfqX?=
 =?us-ascii?Q?aCUk9bfRN1cyXwaBGEFd+Jw9uxV2QQwmox8OHKGj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b592a4db-53ad-4fcf-7355-08dc4e88e0a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:17.3149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dcGZkdvYAjERiHetleKvzTQz250Gb/VzC3ZD0Eqg2NDsW0WlIbOt1UnVzvjDMWWa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Only the attach callers can perform an allocation for the CD table entry,
the other callers must not do so, they do not have the correct locking and
they cannot sleep. Split up the functions so this is clear.

arm_smmu_get_cd_ptr() will return pointer to a CD table entry without
doing any kind of allocation.

arm_smmu_alloc_cd_ptr() will allocate the table and any required
leaf.

A following patch will add lockdep assertions to arm_smmu_alloc_cd_ptr()
once the restructuring is completed and arm_smmu_alloc_cd_ptr() is never
called in the wrong context.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 61 +++++++++++++--------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 54571f2a4acd5b..2ea4fe9d6594bc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -103,6 +103,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 
 static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu);
+static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -1212,29 +1213,51 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid)
 {
-	__le64 *l1ptr;
-	unsigned int idx;
 	struct arm_smmu_l1_ctx_desc *l1_desc;
-	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
+	if (!cd_table->cdtab)
+		return NULL;
+
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
 		return (struct arm_smmu_cd *)(cd_table->cdtab +
 					      ssid * CTXDESC_CD_DWORDS);
 
-	idx = ssid >> CTXDESC_SPLIT;
-	l1_desc = &cd_table->l1_desc[idx];
-	if (!l1_desc->l2ptr) {
-		if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
-			return NULL;
+	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];
+	if (!l1_desc->l2ptr)
+		return NULL;
+	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
+}
 
-		l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
-		arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
-		/* An invalid L1CD can be cached */
-		arm_smmu_sync_cd(master, ssid, false);
+static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+						 u32 ssid)
+{
+	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
+	struct arm_smmu_device *smmu = master->smmu;
+
+	if (!cd_table->cdtab) {
+		if (arm_smmu_alloc_cd_tables(master))
+			return NULL;
 	}
-	idx = ssid & (CTXDESC_L2_ENTRIES - 1);
-	return &l1_desc->l2ptr[idx];
+
+	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
+		unsigned int idx = ssid >> CTXDESC_SPLIT;
+		struct arm_smmu_l1_ctx_desc *l1_desc;
+
+		l1_desc = &cd_table->l1_desc[idx];
+		if (!l1_desc->l2ptr) {
+			__le64 *l1ptr;
+
+			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
+				return NULL;
+
+			l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
+			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
+			/* An invalid L1CD can be cached */
+			arm_smmu_sync_cd(master, ssid, false);
+		}
+	}
+	return arm_smmu_get_cd_ptr(master, ssid);
 }
 
 struct arm_smmu_cd_writer {
@@ -1362,7 +1385,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
 		return -E2BIG;
 
-	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
+	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);
 	if (!cd_table_entry)
 		return -ENOMEM;
 
@@ -2689,13 +2712,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		struct arm_smmu_cd target_cd;
 		struct arm_smmu_cd *cdptr;
 
-		if (!master->cd_table.cdtab) {
-			ret = arm_smmu_alloc_cd_tables(master);
-			if (ret)
-				goto out_list_del;
-		}
-
-		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr) {
 			ret = -ENOMEM;
 			goto out_list_del;
-- 
2.43.2

