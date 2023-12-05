Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BF16D1BB;
	Tue,  5 Dec 2023 19:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OjuJjdEC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoRNmYdPD+IazFYmteSkmKZ7WTWtc/vEhoYOdV88KxITvfhAOK9cxjtB1JjdQ/xw5Ptr1kYe6DfV7udP16KlqXUN3YdwTRxRNz4HFd4YChStAx53jJgb0eCje4vBgRkwzMzsogkW2UNROTByw7WumxKz767uPfm0VervuT2CU3iUPXjcsosneG5L8gY156dA+8IKPaUyjwNGsWUWv8F8rszPh1Bq5B88L8J7pB7IkTRRjnJVzk0bgn7QVtgZYkAu7D7v26n/B3EnS28SQJi4lnZAb6r9nkX99/V+68N3hY8t3n5jsvkJL8XHM8oGc5mHo1DKP7QZh44J4YJTMMWp5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JgqZodjsMJIWkVS11kkTyequax3Pi/dUFMNUdrKtzks=;
 b=laraFFCpXhS72GkV5H3g49bWngmukxPKSXi1nRxwhl+hTk7NxBJKrRa9e7M3PviCmUvbGPH/+7AVsCTwFqOzczLEVfE7ZW0LO1xxOBbZq7ikDdfMbewOjyDeyxwhZXXk2vJrcNFVGY5y+EgDddjO0DcXPYPDf5AjzAULcbf30L9Va6m3B3am2Z5Q5M/B000ZBvygjB37iQ1sbuibeDFMQ1Pm8Xb+p2U77BB+xfJiOi5fMYWGmhPhx+6xeZA1HE+jX5eGopSYgU/3LJpFEWnOW2SsDMvRBxv2cIiwt0dlkrQwr8Uhvq6FxzAifH7vd5hBgTCyx/OweCy1NlGeG0/oNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgqZodjsMJIWkVS11kkTyequax3Pi/dUFMNUdrKtzks=;
 b=OjuJjdECGRl6WLPjM1xWLjmtQZndZ+yfEZo7iuXZ7YucByEUUrmKWbkKHen6R1bqZNBX77iUUnxj3+0kmRGXuoz5mdWCKykNOtx4HAYHINcM0YSI9BVTCy50LD8u6ahRLEeJyYw8Qm/0nlSCz1EtlhQ0qFz2esqPGBiLt+Va7eqWWRVN9mQ5hqbOO2Z6mDWt/OrBahvmPOa5+TiTN6ZRKQQ2w/9fqg5rVpJNnAX/0iGGXY7/zKonOaEc2vWT28DAEseT8MS8HwM3NBjqA32lu1JYWb++kFCqNoI/3BDKFwt+PdYZPjmMsDNoJnwYnf7QHsdaBKcmpzXxIkP5OuntgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:55 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 03/19] iommu/arm-smmu-v3: Remove ARM_SMMU_DOMAIN_NESTED
Date: Tue,  5 Dec 2023 15:14:35 -0400
Message-ID: <3-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E12.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a9e1051-5c1a-45b1-3c10-08dbf5c6752d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1Up4ptouBW9KXl8CY4KvzGt4F8AJf6DbQ6nTcCs9thbt0iJtfYYTj3CEaQRZHgOgrE8l8hkI1lMW53w72dsngEU59eO8LVfz9W8m7t+I3TL3Wy2LPj2trXzIzmqY3/3b43fJOH30J9M81tzGHLXEziX9kERFiRcOdJ2Gbbz1JXbC+5W6Pu0H54gGvydybT02rnbKdzZ49flnPjPtxZQquph5K2oGaqd0tUxdjat/PPJV87BXYQRhL+nW9QhwyfQOGnB4Oc8yVu5qHH7c3PeZgR01ZgxIknA9HcHIhfPc1Cbn66sIDiix9SbyNiNl9i+m7V/fGc/raK97y/Vh/EeQRgi544U1OxZDB/uLTUag6U7FIkVhX6azSmL79XaIeKLHL2JSvPmlw7LhCT9rNAbor3lpFPUz26rhxLE6RHk/NZan0EKKsuds+b978jRAfGBs8wFUE/wntQep9y8Z7g6NaYP2Kd3I/W9sCSGf+/+e5DpETKQzAb5K0VcBQ7XP5JZ+ScOlERRyQtKEsAL7CWabDSaVFAcAhfUegg5aqEnT+koNg4LaeVmZf4o22kayF79TZOUylySlatdKQ/VKiQEXmsKVguYGJjshyyb6cs3MUZ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UriF5U957T9NhieSkUpRacvo3cThEIV/QJZ75wl9m2HuSd6qfSoDa2Y0wVqg?=
 =?us-ascii?Q?pXd+oEw3K2Kmvaqz8YJuY7mv8FUX8WGtWq96c9ORJOO5Tdn+fy4sNqI32Qql?=
 =?us-ascii?Q?Ft4mz3YqyKH7kkZghwLt+GCgTBHT6DG0EoragOgYYbFAwYbP3UKtqwVRd8x1?=
 =?us-ascii?Q?ZJPwnU2BrkTQQAi4chfLajCJ0Df4+YWY5EWkNhrgaIARnDypfOw1EM9rPNXQ?=
 =?us-ascii?Q?hSzEmXFAsLWeWj82h4FRSIoA6G/sHHhNA4L9CRcDTjdbS8F8+pIzSlqW3EIx?=
 =?us-ascii?Q?JBmjVgT4PX/iqcdBkQzmerzZm8bejIeLdHUR7f81iMXUMI51Os/8xZmcpfQi?=
 =?us-ascii?Q?Z7aT1tQAudArSkwHY1ryEHjkpXQ7guDitC6lwDXrH1cB1aQfaxGdyExY6Sv0?=
 =?us-ascii?Q?ceCguQHPI/iQPDReHLJp4Ev+P7o64ntaRfo3sFF92faxPojLnnEDYFfnYIFZ?=
 =?us-ascii?Q?BEcX7MZ/kLYdbczn9LbN4Q8g09JPj2rW9aAQcgvkqzUj+73/TmwAz7nrzcxo?=
 =?us-ascii?Q?UhuL3QP4qZ2SPtUURHOUJ5nL+YCaz3X238C8/ZhzynG8qzyMWtqncB7jGNCj?=
 =?us-ascii?Q?OACyCNzJDXjEyc3Ff0p4eS+ctZlDhjE4LzB7OyblqfwOQXivRYzwz7MsRupp?=
 =?us-ascii?Q?MIm+cMoWDS2ddRh/TDo2yeNG7TVVvEMsE/kddaAJvseiDd8y8FGjD09fA5GP?=
 =?us-ascii?Q?zEONPM5x6eWQAbD+t6TuaVrfD1NpSGZ8AhYA2Nj1a1V4IwHPGZG72dpMYdDA?=
 =?us-ascii?Q?8fWvd2Hbl/olXPyAYA/HtgFx9hDX0u2iOxBOzxncBacK/YEHzEwFKcr4xfFc?=
 =?us-ascii?Q?Re98j/QoGqk/pVe2bekr5c4LIqQpOpucBW+kkk6540z2SPZo32vjKQUx/Tfl?=
 =?us-ascii?Q?8nxb6462cbIKOrdYsrEJ7Cjmpazr2lTth7IQG4a8++pP6YsvbhTMWRM4ITl7?=
 =?us-ascii?Q?w/gtKc2rMOwP5d159wo+qR/bscrTfMJvv07i1Abu5cDfGsS1DqxT2G/Gm74W?=
 =?us-ascii?Q?1h1DVtI4euZC3H9ullIbZ8b/sh32I6aDvvr8yCzh7kzXJk6d66s59NTcXREu?=
 =?us-ascii?Q?5qOMU7BrtbiHK7sKagNMvVo4Mg82j1K/DsKLpH8n3VHVjI86gKzRvK1bpp0n?=
 =?us-ascii?Q?kg1XJUpbLa2+xQCOrF+DlL4Qq6cyj04Xq5pi+Jqu3miOHqzxS3QkP2ueLhhj?=
 =?us-ascii?Q?9J+9Tr2VWdf83EyaiWtBAky6ecTc4PFhkpa07ShWnIY0JSBUQvFbmadYAWhu?=
 =?us-ascii?Q?wvvOd98cvlb3DMfBThWdVR2MHUHfpkiEQLMX0Qt6FGgg8ZNL8bmo39NJ08VQ?=
 =?us-ascii?Q?FTHuBDKnF3MGUT1QYoTQ0qYeC7Lxcb09SLfOJjO9ZfVz3GUqKUNanwLaiIKS?=
 =?us-ascii?Q?aUZ3H6sngjFR/n9f4fjt0R6g8d9cDhiMvukkkl4b3UgXkHD5KGzY4TZv3TxI?=
 =?us-ascii?Q?FO6RQke4PSLKmhKLXu7bDR2HYD14ggNmF0CWZc/+NGm8cAyG1hH1ST1hHzhB?=
 =?us-ascii?Q?F1FPuovryXH0QSKXEmPvCqnY5ZnwtIl0s9L+dK/isO2yChB78++OD7836QZ3?=
 =?us-ascii?Q?sUe56DFryxmdLAO+YxQ2Ci4C4f39O7nOxuyDaty0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a9e1051-5c1a-45b1-3c10-08dbf5c6752d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.2472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6TOJLuzF7cLZ4OY2vWGQI97IhIeshBB2ndKEYZZPTfglETfQyYAKDcuwNBGA3EK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Currently this is exactly the same as ARM_SMMU_DOMAIN_S2, so just remove
it. The ongoing work to add nesting support through iommufd will do
something a little different.

Reviewed-by: Moritz Fischer <mdf@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 4 +---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 89e9c001faad71..b120d836681c1c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1286,7 +1286,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			cd_table = &master->cd_table;
 			break;
 		case ARM_SMMU_DOMAIN_S2:
-		case ARM_SMMU_DOMAIN_NESTED:
 			s2_cfg = &smmu_domain->s2_cfg;
 			break;
 		default:
@@ -2167,7 +2166,6 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
 		fmt = ARM_64_LPAE_S1;
 		finalise_stage_fn = arm_smmu_domain_finalise_s1;
 		break;
-	case ARM_SMMU_DOMAIN_NESTED:
 	case ARM_SMMU_DOMAIN_S2:
 		ias = smmu->ias;
 		oas = smmu->oas;
@@ -2736,7 +2734,7 @@ static int arm_smmu_enable_nesting(struct iommu_domain *domain)
 	if (smmu_domain->smmu)
 		ret = -EPERM;
 	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
+		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
 	mutex_unlock(&smmu_domain->init_mutex);
 
 	return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 03f9e526cbd92f..27ddf1acd12cea 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -715,7 +715,6 @@ struct arm_smmu_master {
 enum arm_smmu_domain_stage {
 	ARM_SMMU_DOMAIN_S1 = 0,
 	ARM_SMMU_DOMAIN_S2,
-	ARM_SMMU_DOMAIN_NESTED,
 	ARM_SMMU_DOMAIN_BYPASS,
 };
 
-- 
2.43.0

