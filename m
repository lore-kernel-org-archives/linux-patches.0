Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E693717BB1C;
	Tue, 30 Apr 2024 17:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497709; cv=fail; b=uejBLc5P3UaLYhzcl9HqrvB3cExLQWKf3BgPZzpArQKZlT6Apn1r9vJqzdv4IsdeXu6na/aUKz/tZcU85PWn97vA0yrMoYax9K+BCDCl0cgmiWT0lSFkiRKZugqOYWvp99Bh6cwWG6p/l1HRBkNd3fsxflyY4Fmo4fO8mX/h3EU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497709; c=relaxed/simple;
	bh=y+vmmHz5ul8yeES3RB+esruQxEXTxOyzulY9lKCYuuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=arQEqYSTJ93lVPZHTHmiGBJvUBQcJC4k0cSSHO+F41QBFpGR59jhIIpvBH7ZNVatcDg1oQuEceOfhGHHYh0pHXVzVklWBOeNOXjWucJ1tjWhYYfgJTltrAAgA12Vn0/keD755H2BDdK97lwTJ0vMTLpQndsNIMGmSHmxaVTX5T4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TdYFce/v; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TdYFce/v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvX8dat27HkB8X2m3pq18HqyF6gqBFXJhwEDvGvZJfu5KYHp+JGhfM0elluuMWLC1JZs5zua8pYFOyHXqyGHtmx8qGWjVIY0yktslOqk0EJ53tnLfZfcg4mRw4uVfP7UitR6RZzXYAAGFBhNihhNbkXvH07odKViYZZa+m8EUbP9imrw3ZQQ87vssSFD6dZnApwNfdu8wOJ6ImXz+xKFF8u4zOr5pBG20iSSgBtAEFKsLkLxEDSa74CwK5ApEOgsqe/oA4dHXpKEdUIz1yx8ycbwDFOul8Ln/WjOntBSgqro2FRJmMD96VaD13z/x+qJNZn7CvxSu/PazCi+I1vEXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGze6D26bkOaVaTHFLcgfCu+3JgXqXg1DoOzkI1N41Y=;
 b=OvFQxZ+gRFsJZ0o1Komml80S9PvUfvONvrurg2TcNhrELZo+2sNaM381CCowPl1vJFGgK1DD0JDbLhXvN4ZuTlq18tFS5+IGvo5LegwSQ+kRf2CG6JoE+2mMSSHoRkFJzUDa2/ln8t/JI0I177o6mbuvvFPH0oKVsGiO6eSuosvQrFAEXWCqw+dHpmAqJC2XTj06EjqQEdqI+F5V/PCI7Rpv2Yqh+wxROr+POHO0TwkTsn+AP8aPPLOPJbG8RmNHKAJ7aab5Ug55jJr4j5sWEVjG2NsGB8I1p57Q/B5Cav+gSjPWeKpYhmEMdimae9JOsJkQEdoSWsIrVW0KT4l8bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGze6D26bkOaVaTHFLcgfCu+3JgXqXg1DoOzkI1N41Y=;
 b=TdYFce/v4IQX4GKw8lYWrwJgSotqTOZnLbS1bSAN3DCrv9eQQ7NwCD21IM14KCNp5ajITUfOu6u5PeTOBUSaJJlRQDbnygeuvMSCxkgbVUxfSnZjDFG9tS9gluk5exjKGbsjR0QbNUfezBsuV+ZG5cdVY5m+qY9xvJrlqv7ky+NgNWIYfRLMJ82DEiEFtoHS09YM6eDjMLmO0YpCvK3CiaA3wdMVkegfCslYNVxVNYve5vIaXzdvUft0uN9PBSqD1/+JCD74dX+vCFCW9PHnuoN/d/sb5zZUnYeQA4e6PKlM7BCiwyDKWIYUO6tIGsDSR/5143kEDymLyfblZtjHWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:43 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:43 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v9 5/9] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
Date: Tue, 30 Apr 2024 14:21:37 -0300
Message-ID: <5-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0046.prod.exchangelabs.com (2603:10b6:208:23f::15)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: f2177a4e-fb1a-4a58-4024-08dc693a010a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b1fpW/ybhoyNvE15fULq+m+qUA5Go0NbgkRUAGOgdZHTL1J50nkRipBJ9L2r?=
 =?us-ascii?Q?pJFLBLtAtf7azU8K07jDbN/jc2HJaDj5vFs66kv80ojzPb/5/FG49C2ul4u8?=
 =?us-ascii?Q?JSmKybOnOFGbmHA0NFbPmbCB17LAiq9l1QjQPEB+z4ugpBdQFheD8wCap/bZ?=
 =?us-ascii?Q?+RLZp1o4amkFxWeHxxdWW5KKBaIwCLl6KdocFJQC5+FAQhGnPN8IXqrAD9Dr?=
 =?us-ascii?Q?kH535BuUzQnPfmjcgOQ6U3Iu3eq6fJlSQD06bCf5xBfgwthzpZmYl2mhzpWp?=
 =?us-ascii?Q?dAx/kCNHUeMvocPGQ2f3X/Wh8GcixvLrrKUj50fveLHt7G71EhdhFB5hYDdE?=
 =?us-ascii?Q?rekvC9TD4NseZQs02vO3O4m1ol9553SxqwkROkPmzn+qrTkRLY5FCzpDfFKB?=
 =?us-ascii?Q?Fj5Fy7fpbZbuPRE8AYpGv4Xaf1SjwOUHHfXK//zHKJLTWkEHfc9Ymil9kVul?=
 =?us-ascii?Q?CcQoR95F80SXupsgTSwnNk9xh+dmSfBAI6JpVTLuiZvDvka6B2+mArX5W7hi?=
 =?us-ascii?Q?82w5FGc/+KvaQxHEeCsbRfdhMbvZY7wTh9by+SCTjtAiezMlQy9+CTsnDIaz?=
 =?us-ascii?Q?6zqzyLyLpbE/H8nbGDo4MLrEltFDYHegEDgHXvzNsvCWMESIAAqLVBy5yEl1?=
 =?us-ascii?Q?Z+cSYOl09ApsWoHf6I6Ri0fHEPPMvPFL4F2x1VBCP55/HWAkvqIj+nqo8V1k?=
 =?us-ascii?Q?kTixd1e+BIOr0KZ8e5+EIXBWdlpgLfmlh07mNaUeWkAAe10U2sMFr70OzTdS?=
 =?us-ascii?Q?0RU6GjArK4nZroylZl69BedLrUsQNQ57eM4QNtdcWkoMYhGwIASZTaxSmdMO?=
 =?us-ascii?Q?FPOjAnZjcm2eZOIxfyIZgNAxDhYdz+5xqDEWKZv+Uk6OiPX6pVew5SKdg2fa?=
 =?us-ascii?Q?Vsq3S3Y5MYHu4LkpM9a/4PQWWtYGJJ0qktG48gVRZdSI7eBfflfZNMbvjyaB?=
 =?us-ascii?Q?LIEpW8zL+cbTVoA+hjqYJ900kbXnlnipKRIceZllYEko6OvTGbIIPf2TJbQr?=
 =?us-ascii?Q?49p0Ab/VOYxuigA2SbuPCKf1RCfXKtJnoMkAfivpl7XrrwIkBB5PmqyLzcky?=
 =?us-ascii?Q?H73StYhn+HXhltMs4cC5vARvVC15IPzhlkTLVPPcUuQ4UuxxqfuKCZbRpQaf?=
 =?us-ascii?Q?Py8wSksfwBWTkADuCcn4JlVW7aaFkljaWcV0seaWSHKGSvHHos8Rr4+ZUEbn?=
 =?us-ascii?Q?uH2ZBF+refMAxG29qsoqhPqsciqlIiGy13CMqQyJcqABIeMjzQ7+XwmPs57O?=
 =?us-ascii?Q?9hr9IbuP1QE5hLQ3iDhlxbvm2bwlXpxiHr14t4WdFQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dqRlVkrcG+mSBso8HTIed/UMFQ9rjaLZ1PVDkHbwL25wMH/4eaKr13LY/5p5?=
 =?us-ascii?Q?OUcb1yUGgrfe61mGC5UBgD2ZblOgnu3wrhVZkWO6JFm0yLPyJtVJnDf9fDtT?=
 =?us-ascii?Q?IMrodlF+hfP5HWtW4qFVF4PE8usiDie2UBx/XLlXFO67MEOSV5Hj4j5Vz37H?=
 =?us-ascii?Q?b85eiaRaQeDChAQ8EwRXfmLkPMOuYOXr+fpWD/+h0/RoY5Ff8qiSmLCvvEtU?=
 =?us-ascii?Q?IZoVgWflQDJEvo8AC3tHNC/iyMBHgUZiGfdoDXh+4cQBBjZ+1/HDcLWTdL9V?=
 =?us-ascii?Q?NPRtEi+rVRNbRJJBcJ39CcWvdT1f2gdJptIsRVaCJx6uCgIYCWhNH3+Yvzqs?=
 =?us-ascii?Q?qpTG2hsMEGtgpGI/eRUJZDTdfmjKja1RWO+wye+38PA5tlMCWajwga+U8ong?=
 =?us-ascii?Q?xRNAddPwQvrLQaEmVE58k3/8ori05WzVjoBg7aZMrJHObwsJCr5IAvxU70gh?=
 =?us-ascii?Q?ayps0Hxfzd0B1x9CUQsgp03gzXss8tJVHl8B8HWiPhWuE8/nqQVZJOQOXF+I?=
 =?us-ascii?Q?HMXLPU2u05ze3Lc7P0F5iIV2Kd2SkFKCZv8nRlmnTR+MMZgLgR3xOsCsDs9u?=
 =?us-ascii?Q?D1bc6eEnkLyeXmYDT9L+A9sjNb7JiQogARSAxFzdveLBrOAB0SSWbNHzqE1T?=
 =?us-ascii?Q?UycW+03gdcJxUYdwYJB+Nh1at0g/ujgq4/3/pr93Qbxg0VESj8PuT3ywolli?=
 =?us-ascii?Q?1uNPidfD06/P4MCmH15zqh/xgydcUyepki3OpoB9cljvEkkH8mMrNVTM8L3h?=
 =?us-ascii?Q?ZWJmZX+bIwx26rH0I+N85XRqo/Yr4k1quM49HjZTLynrTIaJeKuTfpwUc5k6?=
 =?us-ascii?Q?jeODIUPQLo7yFANNZYVzzX8dYPz3pmJ4J/N08+R1SlYKzVQETyBGPD+4wuBv?=
 =?us-ascii?Q?58skEP3PQm/TSMmyzuJnQYcryMlRa0UxmG5wIsrv9OLrvCEhpQKM8FE5augs?=
 =?us-ascii?Q?8bDyCgyKyMcWUG8H8UJoGVlyrcDR4WrC/RHqzOHH0HTRkKtQZqBObYv7suOS?=
 =?us-ascii?Q?fSF8QJJjrBnXF+H87HxdB/cRltFCd5F+PamxEeX86ToYWwWWRF6BtLcOIYXZ?=
 =?us-ascii?Q?aom1DYG5p/ZQBPavOAaCCGx1H7gRJv8kj+mv2Qsb3fV1mGrU78RgMQVzCD5h?=
 =?us-ascii?Q?x4YJGfHESvxNTLt0ZE7S6gP+1t+ULxixSojJRlHIPQgmI5+QDAs8R1lTazuZ?=
 =?us-ascii?Q?wTF6Bzkqt7b/DRfIahsHcd9gZFrAtmn8HMag6JSY5H4Ti0gLAdBRTJIe1WDv?=
 =?us-ascii?Q?zcm9e4J1Wga3PngJErGK0F7DMae4v94EdeQgGm3nbcxPduH/EtZZSkXhGblO?=
 =?us-ascii?Q?IrMUjEVtJaor46bEvjQobmNwqGe8AshI6Q50uF7F0Ys82inyahc+zMZGFsBw?=
 =?us-ascii?Q?gJeoJvOu5pzDQqTtx/tuOvmhQzMcrFZAHFDchiYqKdH1LtOlTUYivUSVZgM+?=
 =?us-ascii?Q?1cXrkSZzJrloT8cyqaP0A6ktccc+OFsZqEyE1KJ8PQM/Su8lLXAo0N3yNBQD?=
 =?us-ascii?Q?I/Rg3faGBXxwnZcWIQiA52Siikc3UH6YtUGIhaBa2IH58gMlfNGomTazoi72?=
 =?us-ascii?Q?HJ6O17YwNcQIJPRsGuF7u5D2pXgcrXJtYAOEGEUj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2177a4e-fb1a-4a58-4024-08dc693a010a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:42.7648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0baSJfp/LCwWXZj6QunsQKy4yWHEUUm28mbTFSOzXpjOI9XKrpsbnChC7SynyzKp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

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

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 61 +++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +-
 2 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8a6c8aa247eb38..7dce9cf52ee37c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -97,6 +97,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 
 static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu);
+static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -1206,29 +1207,51 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
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
+		unsigned int idx = ssid / CTXDESC_L2_ENTRIES;
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
@@ -1354,7 +1377,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
 		return -E2BIG;
 
-	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
+	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);
 	if (!cd_table_entry)
 		return -ENOMEM;
 
@@ -2671,13 +2694,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 99fd6f24caa818..c5c55d3e281865 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -275,8 +275,7 @@ struct arm_smmu_ste {
  * 2lvl: at most 1024 L1 entries,
  *       1024 lazy entries per table.
  */
-#define CTXDESC_SPLIT			10
-#define CTXDESC_L2_ENTRIES		(1 << CTXDESC_SPLIT)
+#define CTXDESC_L2_ENTRIES		1024
 
 #define CTXDESC_L1_DESC_DWORDS		1
 #define CTXDESC_L1_DESC_V		(1UL << 0)
-- 
2.43.2

