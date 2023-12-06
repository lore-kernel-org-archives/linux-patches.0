Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2207168B75;
	Wed,  6 Dec 2023 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fZ+jrTxl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZOuaKdeJsWxyc7ZCRGuwOpUjEGvDRLw89KVAakO/xJW3pprApqjM+ijAmDnXLaw+OLn16cbcI+gRdyFBF84g3nGfUzSZEZjrJ15JX2HyQ58cdibm2IpKpoXQlHCQXjmsH3WlYjVJ/zoDRh8LFM7KXsC+lAoY+J2Fe2NjGe222Wa7/pfQGj1BntYysjcvguHPf+iRm3Hl6r6CS4h44r0RBDbc9SzaVpuLSLdVwvOCWYMIPX5yhaIpefZzNK+Vwm2MTZ3aBkut7UzWhBKfJvto/p3fsXXNQjAuVJeMVPkIV1HLsbDomEq3VXDEFFyHPWfUcZuWC0ExvpSC/4bMd8SVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtrl5dtWYNbmQqQnStN45gQKdSw1hWTiwRqlc7s1JAk=;
 b=g/IQJ8hFMhUE0djCiFv2gPq0DAc0Mp7e31bQFiRwsYueWdu0G9GA/QAHkLdrmZcLZSuYZQtu6wDpInob41dTRDGpWGD1OxOIx1/++7ROcVIAoCeJVHOK3L6XytHFxfm6bdYMQb3pQH2s23fjklZ+N4CF87pCUBI+4eF0NjkZEHgpBraQCQ3sCnlXpmm3kBNHisTRFLP878A+PUJyfiS85a473on7anQnjBmPhiB5ybhifa9nEU8flEjjhsIeEzGkFP8uOWKuAarAIehvt+v97ytedWW2BI7A4MbK9t5X+rUFP7w0x9M98IIOiXtchk/5ZvbnWu1HEShT88GAqO3uOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtrl5dtWYNbmQqQnStN45gQKdSw1hWTiwRqlc7s1JAk=;
 b=fZ+jrTxlTMJxIJeGYIEovE+7TO9qjdHDJUXTLCdfalLyMlXOeW3BounAZsLGAMpY5dEqgsdj2MxNwA01wHXLzbDF4/Ijc6UKrUZIg+y2+vNUAA0GgCmvuNoYhDWw1Ik7wLm95FNtlVl4VNXRknSiSHt46tRUhlVR+4LsYV+5+3B4F5I5AISS8sV7K4hz/Ut+uHh0YRTqx1VnZIapPcm6bZk34TbjyEISTbccUoK3yCQs9YbYaUluLgouWhKGPv5VZlId2aFrG5e0gBchNnemoBG157k2itIjJZieGn0v5p9jJEN16cRnBjefa8dJZiJH6Ibw0cnR2oxrZbI1Ds9oug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:40 +0000
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
Subject: [PATCH v3 08/27] iommu/arm-smmu-v3: Move allocation of the cdtable into arm_smmu_get_cd_ptr()
Date: Wed,  6 Dec 2023 13:28:14 -0400
Message-ID: <8-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:208:238::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: ae7fab7f-ee34-4ec4-1f58-08dbf680c644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/oMlTop4DS4zUuizuvzH558I46CHzDScbGaWueR76pF514BnMprJiPc1ov79sDXXcJwLC+G6KikRGRmIma7QqT9lhxOvyvt7ZEYfklWuXDw28H5p9Sfh+svkS2Usnfxp+gkoFFhHz9F5hnaoBDyv8VWYCML6nGV120VmpYueHvxSuzbQpbIOsT6F+CBLCYv0/F4sVyfnK59PsnzYIQFvSBQxAj2JqyU95o7iR40u+OJa9Duftle1RRWaop6U0bb1Y4IyYopuvdzego8hl2MbIfAUZas0ZT6xxzQGg7sc7TBvVZLuDgKtLQIv6CxFt2KM4t0xxnsnZxPR1gRm/lYuLzyayg0sZy+Neq9QkyjkiDjpvFjiYlApeGywEJHxdnjq9UbbhjSmdbIis+8L1F2gaGYIQnQXmnZaqrm7uoAhd/kayTE+sTd3rpzYJqFo0n6Y24d0RaKdj2XcHD4OcfFFnvHLFnuwwdASkqbGJbjHJZ/bekZXu9chmzAg9DnWwfRzSScD2Tzg4mURihSN/Lm0E+VCLHZcgHc5LMV/TvbpPgv6q7xaLbidgCsj4e3d7rSGyYER9SOnqdG3JjNd3nQNCx9vcZPZFFwBHgpQaXtxhe8MaZ5V8dGKRJeF0BAJqsvPyLrGqPZwopJ2h5oK/Ywd4Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005)(4216001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/bmY6TupidND3Q/lL9IkstpO+q/L+aIHskeYY71fh2yh/ZyYH9WqrC22Naul?=
 =?us-ascii?Q?TbOBouVf+oIwP306MxmXhaBEqDVK5HmhiGDULk8j3t1q32NGngxLWhQeuH8N?=
 =?us-ascii?Q?MTTihWSoAWjOOP5FxaYHtHIk0cRXMrpVWYfum//qixfOHwjSRmJDgvbbJMxP?=
 =?us-ascii?Q?2IPZM5Fxdf8knMvBgHg+h4baEZIaJpJfNACBmxeQGMC6tHXQOXHBDQBqpa+R?=
 =?us-ascii?Q?sNE8ArqQK2ZclzjNZg5IVgEyGvM55ToMQbRfvFshF8FA3ZoRsJ6GdlkGc3Qk?=
 =?us-ascii?Q?GykRd8pTd2h5WpVjt6tJ3F+/0xq2/mQA1NHC/RGfeA8bYcpbEqCfLYf097aZ?=
 =?us-ascii?Q?eGBrDe41oBrFxC6plzmpih0fvA3VXlmbkZf/kaphLCvP3sjfqmq+k4/vi+ns?=
 =?us-ascii?Q?omMYeokEZctM3PoyUl8hLD9peJybaCl1dLn+Apy2e/Q1JokDtKVaobtJ6A3v?=
 =?us-ascii?Q?feF3fCBM9TAxWnXtfZTINGM7iSi7WzmLpdnoxD9PWxzBlj5M/QW2wnFz03uk?=
 =?us-ascii?Q?KWBRtSlNjGv8iZKFax7Afb9jR72R3kSYT0JBPophU1XnG1y7f9SHpi9g2cZd?=
 =?us-ascii?Q?UrdEg0WvwKvUwmu9s6XDtcHrALP5mAQ9id6+XHfT44sSHA/3thI1rxI2Z30Q?=
 =?us-ascii?Q?obTJ5S699YPaahLAXZrADzYA1eLpZh/G6MLQVSllxp+clKKtUQ583emNYSdy?=
 =?us-ascii?Q?ZHnhEGFRg5kYrdh7uVGeI9WV6eT6T3tTe5UbJx+OjNCKD/2NUKfJghEWV4Y9?=
 =?us-ascii?Q?/NpU/Cmm8YW0Jsc1ZlYl/WuiC0k5xuU4XrHJp0RLb1eBRqgE8iHEXf9QgE0+?=
 =?us-ascii?Q?Fy/BqWRtALHDf6njfg1F1PEig5y03syPm3OYRc2OEEFLIuwb/f9OZy5ccOhy?=
 =?us-ascii?Q?6Juu/cYJFVjaflDORybkRGSRPR/B7HN740mhdvpIUdZ2VYLpmmPcwdhG77tQ?=
 =?us-ascii?Q?XqyNy/rT7aebECbWSs8+en/KkKxMWINPBOcApuySn1f20qozoufvvSGOlozM?=
 =?us-ascii?Q?Bun2l4zoyCJeMemD4I1ZuXomXqupoNbbVB+z3FXsI9C/f2OTEaEA0kcyE7Vz?=
 =?us-ascii?Q?V10C0WPOhG4UJmt0e+KwsF3Jn8BpChWziRjgW+qhJ6L6l1rty+8Xeq0ZFO9g?=
 =?us-ascii?Q?NGuhoIu7cK2bUQ3XsZ76xBjJUOPqHwDT/gAo8B5De96o5BuTcTA9nZj8rGqu?=
 =?us-ascii?Q?j0oif02xHnl6maRc0EzuPM5qMQ2JqqSKqpM8q4aRY2ouSyruyry5Q497Q2HD?=
 =?us-ascii?Q?UbpJ5hp9DkOhTA55WZ4z1VTFbofw/r/jm9ocdTLISj/y5AwGi2YWC/ulzerK?=
 =?us-ascii?Q?9Qe7z4DYsneE6dGad1ChyO+QrpW7MqSLiBbAoHTpaUAzgxLnqnvdxOTtqrrb?=
 =?us-ascii?Q?tzyZvdxJuZ2h5JeU+fmvX21HIVZ8cYl5t54Gwmjz4JO0wDMVviaAaWudO/F7?=
 =?us-ascii?Q?QMY+Gf34taZsdu6I4ZCPPzmjoXRCDdGbWR6JBi25Qw9cliPoFS/rNTIIbzdE?=
 =?us-ascii?Q?6pc9raRKrBlMJX3AQy6eJeaAeyBE08Z2x0qeJaaDjuPQrxHA3/9WK6Z1mukr?=
 =?us-ascii?Q?PPftI5+cp6UVSBaYaZmMlpk8NpeY3oq16De2yTZS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae7fab7f-ee34-4ec4-1f58-08dbf680c644
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.6973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VgJyL88QKSls1CNoArxT9E6BEGw21vw7KDpfM/6X0GjXv7p10ZbE+8ul8fRzLY4c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

No reason to force callers to do two steps. Make arm_smmu_get_cd_ptr()
able to return an entry in all cases except OOM.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 696f837015771f..a21589f8729176 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -89,6 +89,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
 static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu);
+static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -1127,6 +1128,11 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
+	if (!master->cd_table.cdtab) {
+		if (arm_smmu_alloc_cd_tables(master))
+			return NULL;
+	}
+
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
 		return (struct arm_smmu_cd *)(cd_table->cdtab +
 					      ssid * CTXDESC_CD_DWORDS);
@@ -2639,12 +2645,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		struct arm_smmu_cd target_cd;
 		struct arm_smmu_cd *cdptr;
 
-		if (!master->cd_table.cdtab) {
-			ret = arm_smmu_alloc_cd_tables(master);
-			if (ret)
-				goto out_list_del;
-		}
-
 		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr) {
 			ret = -ENOMEM;
-- 
2.43.0

