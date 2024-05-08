Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6A312D203;
	Wed,  8 May 2024 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194664; cv=fail; b=EEOplnRx1xxlQ18NYa3i04vIR2g5vfqc9MSL37tKBSGJrg+eQ14ZC9/QO9zRJMHj62Y2j9BacMqftU5tKrcaR7nIX7XiVtCxU4vRAv+v9o6O2PVUvLjvgpaYyvR+YE4O/4t27KLCFjYvE4dPWmM7fYIXI7/obVD9HCc+gNSF/6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194664; c=relaxed/simple;
	bh=O3HW54ZnoEvzC/YBM1uDIxh4tjiITqcTM6rTwD9zvns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N9Un9K68PScExUwdi8rBsKNskYTSdzjM+iG4IJBKK6eUA1G94Gr0U+eAjBqwKZweN9Jw+3t9J7dtK+H6YCqJataWOt1ar7AcE5FFRmGFwzTMYBl8cQrm6XSQcxqVXkYvxpWM3+78/e8cJcXdrqn7USHInGF0cQ0BzCtpWMqUZVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e0BkymJL; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e0BkymJL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCWlreo8FStuQmulBElM2FLAe+UHmQSYCU6Zo7TmxyF4oLkOL0Ek5AxCqjvWU6OceN50k1pmSpGs03LagcZUKLsIL0SdfY0LIMD0AfDj8psXsqDfMyW7U8/mggRsoR1BFQmpBjH2SV2yfDdJvJkUd6mPrZWOwm1ZXrcc/g+SmGFL7bAAPq9NMrNek7V5aJJSdg6q/Wm0KnBhOS3pN60GLRVhvG43hZHyEcaAIf+3b80Cxzc+OHqpF5dpg9CZGipntF5EaIs4+E+EK1HJ19Elg/Kus7JbLNes1MvXlHJA1MbjUVbzLC/jEOvHAdGMYdBOb24ihb/geqvhOPjlV1Iy0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUodXpyO7aK3vOyswz2aXpOEtIdXRX+5P/d2jL/C30k=;
 b=n79GpPPDC18KbHgqHUOoM+t+ywVHzqw86luw9hFFllAqLrbMNf8qLLv1IiqG7T4I5gKuC7qDf7Ul86KVHDqMuAdmOUHs1D+gKnx9c7FLa/aE9U9Z//u7OUtCwXWKoIeJqFTuTELvJRAJgUt3uvVLtWDJKdsp+HQzJ7vsDZuM1IVFs2lKAYQo5fDVR0PhejRGXZc8IUyyjzbbaR1sOyqn1lVOIx1qUB8mQJ8X4vlf7qSKX8glGvqyRcJSXrZUisfsmjDc1WkKMVo8XJrkO/fZMi9Io3/q6PnA3pfSQVqEkHdsbqyLVzQR/4Y3WOC5wkbnsL+EFliC5V6ppCfiCcl6Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUodXpyO7aK3vOyswz2aXpOEtIdXRX+5P/d2jL/C30k=;
 b=e0BkymJLeE0a5DmGrHPYzmtMpy/IeHnetyHT7vqMLerkR8kFuAf4EA37eZDzKkaE7ObNh7XyZXMv9KcH3pXUM5sWv6geghgtp9tTq4+ZtVx1WOUMYVz8phsbt986tfH5dhdtatZHocOuml/+hIHtJSNMRK41hfqHhYPoUG6ORFYwO7o47YR9O+4RfYBrq9U0I6/lSTjJVVfZHRiY8noKOZM82s1Ktr4FHtmPuAt0boJNv0Gi6RATzYSLbTD488G/xGw1E0MKcbae5iwEkYfRBGFFvUgadvaHHinIwB+F9Qmqqt/nZml5PNlkbm+p3GzitoKmXz/eIJS/38Dcb+v6ZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:28 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v7 06/14] iommu/arm-smmu-v3: Do not use master->sva_enable to restrict attaches
Date: Wed,  8 May 2024 15:57:14 -0300
Message-ID: <6-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0079.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 73381cfb-5aae-45f2-97d1-08dc6f90b3f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XNQYvjHvhjL0DdAumGVUyb+pLky+zj2toFbNrALuinS6yv1yDcM/xrZEvJCg?=
 =?us-ascii?Q?Y5mdnvr/JkSSKmDnLKIa3GXhU738jUT14oDfMXeMnzpOPb/YCeXLdhQaFkxO?=
 =?us-ascii?Q?bv57+7IPJ0EPba91ZUo7cxI71rMj+GEwXkP+0guzIvXVy25PJJgbdeOALUoM?=
 =?us-ascii?Q?pb4itaIg8oYz3LJrvimbVxZ3xtC3wYb8WYlXtlFrcUqMolQi0b+gIg9C7z+/?=
 =?us-ascii?Q?r0wSr5ZA4gQyAwvLoTh80cm2Vu6Vf8DPtVwvS9HCpIspmHPf1FkQHlAkI/gm?=
 =?us-ascii?Q?Vh+uRq7hVGpFTBKacTazbbrWJMCb4LD+EvyTJV/TTQrzCU7XlF/khO+qescB?=
 =?us-ascii?Q?Z0kONnD9T1vUsZMRlyNqvv8wkDb8efIs6WT3jiH28oOxC9pIHLkqjPFugPeD?=
 =?us-ascii?Q?p6uW741ZnTWK/X2/mv71i/0xWxKNtHCOZyHY3Bxd6k5HbSTfWCz5p0z+tqau?=
 =?us-ascii?Q?p9rCOwfKUl3ORZxo/kzDurNG72ta3v/rU/C7zebS9mWEoGCfFpjzL/GSn4Db?=
 =?us-ascii?Q?e0Tc1JhgOCyJkLwbw+3YA9zYxwXN7mgEutNTkrejpxY2ECek8yWOS7JYx8Se?=
 =?us-ascii?Q?1kCAeUT6cAg5s66BBVIVYcnDF/m1zvbm0NPBORNFlHpCsIzAenhNz3/xiBOB?=
 =?us-ascii?Q?41kAjMXRlfl3tZqEpPQjdnkIBpFgdEk8bUnQReOcdjfDDktHch4WhDLuCEbU?=
 =?us-ascii?Q?M6oA/91CcoisyjNcrsf6qZjCeEWMXgMn7tHZrQbfgeEtWtd0tuJZoMKcAf8G?=
 =?us-ascii?Q?hrKZFeDsMlYIAs30fadcAcRqPe9/nBy9mHXxEIpGlaBTFhBvYYE0HE/yB/Jm?=
 =?us-ascii?Q?cLCEyyK+pR0lyWi2SLvk62uI/vqZuVMTG8qdyR4gXz1olk0CTjGNI1qdLhAz?=
 =?us-ascii?Q?sEvalPUE4ytsRdIf01sJd/7d01P1+MNsBe/XYsnFL0CRFELvR62Gs7cybsxF?=
 =?us-ascii?Q?VoSr8UNAdYoDca/zf5ZPl3tWJAbCUKb8V/R8mTW/v6L6fmswQGzvyjMjcwOq?=
 =?us-ascii?Q?7ki86R6+7DuvHAXuxF/MYcNq+8m3IJ4JLuswWgvwd/E1YNz6Q/XuyaAS9b6L?=
 =?us-ascii?Q?zlZgLYg92UPyQBmPfujQLmzwsLf9dCcjf2ocvDYMKXjirsBgNuxI/q8689aH?=
 =?us-ascii?Q?qJ+6yWeX5Ur8aMjIw/NvXiARHGpnrXu7rNu8guF5a63chUR5Z487vSqS292I?=
 =?us-ascii?Q?YRSjt0JQwa5Hpsii1QivqzFAodZjN5n/o66/rk1oAIDSajqbQbQ7rW8bcwCR?=
 =?us-ascii?Q?o7YoEZNu2cbTa+nahXpR+AR++RW809QV5xJ0tX/zFQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?czmip6XJdZ397HnE6HVQvSHChFgF6F+LChVxHOAesSZ0gqyPjuEBiakCO8iV?=
 =?us-ascii?Q?J+P4sG8Kdq5rkLDLUH2o1i31D092GIcfaxQ8iNztwjJXLofIknHg3LiHSj4w?=
 =?us-ascii?Q?Hba8aKgi/dSTLVvmry7tldgFY3toDwLpd6Fyhw44Ui51zeXFujV1i8Pqpq69?=
 =?us-ascii?Q?zKozMIiWpW3ptfU6KShjnIrGDNdW1mElpudXerSY1r68vbCrS/UWpQhwJP5q?=
 =?us-ascii?Q?yTnnOKliuYrVWVxTaR0011tgDrSelixWYvsIr4oGw0OLTn69BTqOeS26eCIO?=
 =?us-ascii?Q?X96TTh+fjQ4Ez2J5kOeQo1bLfCfbWxcLxAvAv3NFxLEH0SVDnO190rxw9aHb?=
 =?us-ascii?Q?Ze0FOfWTVCz0bgRpGbH2rbebFsKMH++u+6TAvFBxE6fkVd5KuZHBHkkrBZOA?=
 =?us-ascii?Q?Y0dJFuiY8oX5UpGRF3/q8tHO4nn0XezHdlxOyZN5kDLG6d6gBBA6faU0qmAo?=
 =?us-ascii?Q?4dOgXTwAYAQ16HGYVtcAPizno804WC+nNC3eD32a7IObdjLPv3eQniJ/R++d?=
 =?us-ascii?Q?/IpTxl4v582BRh7hZ0WVS23VBXeOehpejvelxtT9aze6YksVB+/C/u71VHtt?=
 =?us-ascii?Q?tp42m7FAynWeUaGdqqDjzHf7eh43N9XBo3lXPgmIw/YbR5+/ocPQ/RROwN7K?=
 =?us-ascii?Q?UXlptKoSSLyINF1SckaJ/sng8MunMMtXl3SOzUwHGce7PVQv00ts0GRxVl6L?=
 =?us-ascii?Q?I1yPvG7+QO9PhMKU3qvioiRp6kzGq8f8z3oPUz+yd8NIr1i0J9nEyMFKfL11?=
 =?us-ascii?Q?sg33kQ4GLa3LfFthZyPbAQTAgb1VdCHb0cNHgOE+Pf7uWkxmahgaCRzuCVSh?=
 =?us-ascii?Q?CPBd400EHygnhgXs3HKN1PXiDST/YvdkzGNcpRWRaVLN/XmIf/YCTNh1wnCa?=
 =?us-ascii?Q?Pd4eDs/jhWRVORIZS8GWtBGJJXlT0kAAoP/m1wwEMTjQjUC/hUgZBJ3+ITeb?=
 =?us-ascii?Q?EKPHRNq/pa1otYDVyCscwKibGPOsFysMpUJUoDCWIUVUUimgGiyJ+ZCF17yJ?=
 =?us-ascii?Q?gxthum5N+EW9rKo/BEkjRnUOQUfgXXihXSIaq9B3EUXIwdNHx+uuL+nZfIj4?=
 =?us-ascii?Q?B7kvlqpV6uIU7KZBb6G3qVlfcWvQJ014HFny93Mv7ktAZpCccZ1Rwaq4ePNf?=
 =?us-ascii?Q?8rOwdz0yJNyG2Va9SIyYrdrhK6ePW0PWIvEzMki9wkz6LHRzKdtCT/I0y17b?=
 =?us-ascii?Q?7VCILFBd51kuwnx4+6rTa2hfOnE1qVLz6bhFfkYTnAPbD+I+jQYNLxxRA0+k?=
 =?us-ascii?Q?EqILUu+td6wZ3qPNEWnnQ4wQv///YK3S+OtF/1378P6Dyhx9oQMvIcKmfT9d?=
 =?us-ascii?Q?OV0lkDeQBij2kGZK3Td1ZUlNE5rQ3l3xqcP7ijRTppyv8Siucu5Vg4xSvLJm?=
 =?us-ascii?Q?7TkMncLqT085mjthNZSaejcod2tnJTNZ2RuSk8a5z4xyKZSnvicJDVMe5H66?=
 =?us-ascii?Q?UJFwjocnDCpeHuXD5o0eliu4bPEJBFh8HcJeQTflB2fvQp+0lQBeBjL8voBY?=
 =?us-ascii?Q?AoEW6e/cXuEeuNaoptU1yLsO0d3QbbjZHNzZ3tQpo5PWjxytTwhpvqsyh01Q?=
 =?us-ascii?Q?fI8ZNAY2RgeLRJ1K/mcwYqHKDolZTwoZ7KkHexzJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73381cfb-5aae-45f2-97d1-08dc6f90b3f0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:26.6219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sc4ctNaRps8esyauIF3svT+FzqcZR0XoePpvQGZO6ntQjaq9PpmuLhjaW3H39vI1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

We no longer need a master->sva_enable to control what attaches are
allowed. Instead we can tell if the attach is legal based on the current
configuration of the master.

Keep track of the number of valid CD entries for SSID's in the cd_table
and if the cd_table has been installed in the STE directly so we know what
the configuration is.

The attach logic is then made into:
 - SVA bind, check if the CD is installed
 - RID attach of S2, block if SSIDs are used
 - RID attach of IDENTITY/BLOCKING, block if SSIDs are used

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 24 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 ++++++
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index d31caceb584984..7627cb53da55b9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -628,7 +628,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_cd target;
 	int ret;
 
-	if (mm_get_enqcmd_pasid(mm) != id)
+	if (mm_get_enqcmd_pasid(mm) != id || !master->cd_table.in_ste)
 		return -EINVAL;
 
 	mutex_lock(&sva_lock);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3a7ef73994b57b..5f418b96679c88 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1289,6 +1289,8 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target)
 {
+	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
+	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
 			.ops = &arm_smmu_cd_writer_ops,
@@ -1297,6 +1299,13 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 		.ssid = ssid,
 	};
 
+	if (ssid != IOMMU_NO_PASID && cur_valid != target_valid) {
+		if (cur_valid)
+			master->cd_table.used_ssids--;
+		else
+			master->cd_table.used_ssids++;
+	}
+
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
@@ -2706,16 +2715,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	/*
-	 * Checking that SVA is disabled ensures that this device isn't bound to
-	 * any mm, and can be safely detached from its old domain. Bonds cannot
-	 * be removed concurrently since we're holding the group mutex.
-	 */
-	if (arm_smmu_master_sva_enabled(master)) {
-		dev_err(dev, "cannot attach - SVA enabled\n");
-		return -EBUSY;
-	}
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2731,7 +2730,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr)
 			return -ENOMEM;
-	}
+	} else if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
 
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
@@ -2803,7 +2803,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 		.old_domain = iommu_get_domain_for_dev(dev),
 	};
 
-	if (arm_smmu_master_sva_enabled(master))
+	if (arm_smmu_ssids_in_use(&master->cd_table))
 		return -EBUSY;
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 23d8a5b7912069..e850b7913e67a1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -602,12 +602,19 @@ struct arm_smmu_ctx_desc_cfg {
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
+	unsigned int			used_ssids;
 	u8				in_ste;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
 };
 
+/* True if the cd table has SSIDS > 0 in use. */
+static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
+{
+	return cd_table->used_ssids;
+}
+
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
-- 
2.43.2

