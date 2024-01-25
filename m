Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341511AADC;
	Thu, 25 Jan 2024 23:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227060; cv=fail; b=Aom45eGbTa7SJEVqWUUN32iPAy6ea6G/HaOPvW9E5WH9NXchhrOv21zyeB+BpLpwoklByGKUhyq+L0+tPrd+BgM/buRATsTHBF0EjscUToJESPHY4peVmCCv+ekwZ1LN5hEjx2InLVqH6vKIx+e2CSuNpribiDISy4B2dIhAucM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227060; c=relaxed/simple;
	bh=T2bXudamdLPyU3/OgRD0br3DdepSkkQQgSn23hIXhro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UkmIpRItRAlIbKEZq3saMbxjn7UMerzo/uDI6wU4lRGx5mW//4SuzLUohH4nM2XbYrFi21+Uhd3e/aa4VD6BZ/pAv3L1NSfDhWkLofuXscR4FqqTLc55P9szJrSbkDXPVG3RepeXvoUCiG7dbyuy+u2sCvWlFirM8WVeLUV89dY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZGhLZyoq; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZGhLZyoq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaeARnS5HmBYyiKM/3zRknW/VMWIhDd8PaHBxQN0dNfv+S8jZ0zSKpFAs85CirPf4W2dO4GxG+TFBCm8/oc1er05EJOyZ3S9im7ESmzfNnxfyG7OP8rnt81k4RedqlGbvcTywWSi7+ADPPg5kdVvd62iUgD23EouKTvBrHD1ENErLjopx3YlGRt14JNFxVs6aNFKTRmwoVx3lkZc/RMXAtL6N+oUg3JVOFw95B1vCCM7VGSC7qP+lLIuKm2JHbyBNgQTYda0oOkdBwt9KyH3ejOWuzp/GfzwKmmpssCGzjESzUqndAEqOsj+6fVApLL6UoKGowZE1jdSIgDBW1qMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T12PIwERlMo7T8nGB+bo6L7ogb91OoG9qKs8EBtnOM0=;
 b=QC1G71JcQeVh2QXnzpmjhjRcW2kupNzECu8prmPECozCcuKFM9OhGvORbPu//C+zy5/wVwE2mzyw0UhXRa9xR8aozRnnmdOapnWJIcMlVZRaiYr5RnOuXs2OOSibMrIWikwD5kRstQ7BERAxWLY7ZN0c1iKiH8SSjMZr8D0HoSQ02PXjAgi5GprMXBEw2VZdIIh5CMl+fPZTORKZKLzCV53OrobrBYJYGM1wr/h1NOAmDF4detLi6z2+3QuRWcY8hMedBmvac38HhtI3WXf+Qs++aKL8lomuuglwG7nI0O8Wrdh1LKdioWrE+BYadgjaxYrwwwkygB5QyCMQzHNHWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T12PIwERlMo7T8nGB+bo6L7ogb91OoG9qKs8EBtnOM0=;
 b=ZGhLZyoq4KeUN+My8Wy1DJi8H5wuJCR6Tr+vc0/DuYZ4HuiRsXm6eN4K+JIcEC+QT0Y4s1rOM/hRNuz9F8e3SFAMafhNHeZE9pCRE/uLdJTM2U4Ub70eqDxJtU9Xj+CzlV8TvUnU1wTUDArrOkrlWLETvg/+YqyHQ6xP/k6WD8+DHMqTSZDaWZyaKmp8GIkjocDfpqelfAMWtNV44YBexWXbpb3EjYz8BX1qDh529SDWCr429eCuNhJk17Figi5b1pGNiwyWkhzb/TOkFoWD9zNiPdDNlPohRjGi2yYbSZ64KxxbJubhapK8AYCMi4pLtvlQPjvYewVNwVmAz/lL2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 03/16] iommu/arm-smmu-v3: Move arm_smmu_rmr_install_bypass_ste()
Date: Thu, 25 Jan 2024 19:57:13 -0400
Message-ID: <3-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0038.namprd05.prod.outlook.com
 (2603:10b6:803:41::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: bb67fefe-ea0b-4a7a-7332-08dc1e0162f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mxV6lMrNpVIq5BVNnaNU8gDAcUOsDscuSblPtWNWE2GtInkRgBjQJLytskF23uK+k3rMVDevNMLSbjad81I6+tkPnUf2k+tZKuVpz9UyzPf26g1C6M7SmE0MIHTHII/y8a4VQZ8WEJskm6vH3ZwcYBUaROnSoTJHsY/DbARPIA8WRu/Ce5TeIaaeOsDbDABaLEKCRAYM91Rrd6nT980RSnfkucf7oJxjEk9GqHs0Yr+VKhYzIp3yyMgQ3Rf2SlwaZnvoQaZ0NCjbmwGjnW1/COGFPtBiicpecQseRWervBgN72TjDazMZh9wZ84X7Aeb9khN6OJ2lGoNvv5s/05yX0QGUGPqpY1OIcyxgXNZ2ye5PDo2YQTaKYMyVi2d0vwuF8duddb/Ty+RmwBSWAOs94y+25EJvPR5FsqDEHBQNTPdK6Kvwr+FVSm7x2O39KWv9XNtqelcZFcbiFnXiu2KQs1kL28ltXxTwULOWQzfFmiAVJ+ibuznfGVsIiToVfQ11yiuEDC4//U3IXpRdTxgT5rjHWYhRkmS3Ti+hn1JIs40tVLmOX2uiZHE13vdekt65PtRSeRX5yKdoWzw75zkeWDrcEPze455QmfgKn75Q/8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CPpmfON/zgDqvstTJbSyPm2vzfXbOxfwIzZDusCpz+BmdW8jHI3CRF0WU4DS?=
 =?us-ascii?Q?CW9XRZ51MRTzairpus1fDrJGMnoqFRjxFqemTBAHzHcTMDuijkH0Mk7md71X?=
 =?us-ascii?Q?BjWJJ+fZOvuo/kSYfXYL+PPr/WldJVgdMToW3acCJX/mYM9vuJuKdk95GIUp?=
 =?us-ascii?Q?sSgXt3A/hx93M3xJ+I2bbgzZ8XubSfwgSkIGeDgnHvIsCzvUivyyLcgreLtc?=
 =?us-ascii?Q?RNFchygfu4hv6ORfojftPSi3/cU1xl0kn5LPvgV6dsTQflCOd6gmCF0ry/Ds?=
 =?us-ascii?Q?o3ne3LvE0hOzGH6dtj7xkOJ3dDQxkORNVWXs0toC/TM3tvKKRPwc+5DdAWpA?=
 =?us-ascii?Q?ngXpwruPrF4oAa/2yVW6pXtr3Rn7qjVwg2MvzENUOAEPYL6s9ZPB81tTw6Yh?=
 =?us-ascii?Q?zvkWGtLbQOAjJapv/PDI/e3uczgQjozBOUfK/Lsx24QnrwKXNLfacNFrNgKp?=
 =?us-ascii?Q?GjO80hFAKDK7fcYSsvy35y30scahh8KAUvxRPQens5Efdx5Og/H6zLzM8VJA?=
 =?us-ascii?Q?6LHDUhlDTDk8vdfqkmQOryS3BpZz0znIU6EI3GpjoB5VmRQbtMbn+BbZY5U3?=
 =?us-ascii?Q?pPNv66dg4TKTHk5RXreATfaxG78T5pv7DKs4dDFgunzhvLt5RHAQ4Q0F+VND?=
 =?us-ascii?Q?zSstujqWCYH7QiLw5v4VyWHuJZadc/31ktHgjdklM6TdvdDg1WFpY0M00xZ+?=
 =?us-ascii?Q?OuDDVZ3/+ZHYolpXAirx8tmRN+/Ph5JV5iujuWtcJ1Dy4YfMOaUuw30CKToq?=
 =?us-ascii?Q?JCoZ6fNlF2HJJ0gziTXTz51UsUXxS8kmHSIgEznVPoQ226SMuztMYhPQ4Idn?=
 =?us-ascii?Q?ZBpuS/I6Nv/hofCWJRkFESqD8KwjxlmgWgtn/K7uutd4XO1J4SDxEpQZ0hMu?=
 =?us-ascii?Q?fybXJrFsSEdBqsJZZZkM9pZSJc/9RI6IAw5eTKAn75rWxCwRxUuS8KG2b4vd?=
 =?us-ascii?Q?RPwntbEO2qo/WhCWznZ7r00FWZpCsDxwmGER83JhmrYX5xL27plm6lE4xhs8?=
 =?us-ascii?Q?KumF+rcQtewCYjSX0cRxQYVoki1y0m8idd3Hc3l79b4XffgXzwFlaw4QvOzs?=
 =?us-ascii?Q?fjdJNArQfTRWIu13zR9WmBGiOkQH/9wBBD+WDlqQDbPRP09u+D6aJxlMJ+7E?=
 =?us-ascii?Q?3bAEl9XEUQoTsdN7y0HwOFC9nWuCaoYdzaj55IPHe0+I4QgQbpaN5sr7kT+G?=
 =?us-ascii?Q?FQhgzjr7QUWcoA9T1FhzGth3nweb478GCEazcM4uhrWvjOS69NjgocPRIK5U?=
 =?us-ascii?Q?e0PCYThUHSnAYyBfBq5MCBfMSdEWd3cS8LOUtSrAlIMicwFa7Ow0PHaHO43X?=
 =?us-ascii?Q?xXzu/D60d5oDSG7r+/LsGscMOO8uUdpVv2glBVTirMRYDBE/kP2P28QCJC8Z?=
 =?us-ascii?Q?D4RqnjTh/EN2YgX4GqT6x9qblbyQ2exyEIL9yzxQgwa48076qf6pADDuXSw0?=
 =?us-ascii?Q?cka3aEAAqBW4O4sb/uXcqqfPM2Q9GRECF29XWJ6+acHqAlANHOKiqIcNHSiE?=
 =?us-ascii?Q?dX1qTMG4z4FyX9mTDvLTN7gmkIQfO3CmC8OQcB896vmWO0Lo3saleYS7gdEw?=
 =?us-ascii?Q?GJZYXV5wfE8YB12ixhx33nbmHfKUnvdvlUj69mUi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb67fefe-ea0b-4a7a-7332-08dc1e0162f6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:28.4902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8iesmqBIo5BWWBaUCVV+q3+6PKjXJInJo7coXua5m0EX90cON4Zhtdohh8Walwd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

Logically arm_smmu_init_strtab_linear() is the function that allocates and
populates the stream table with the initial value of the STEs. After this
function returns the stream table should be fully ready.

arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to force
any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
ensures there is no disruption to the identity mapping during boot.

Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab_linear(),
it already executes immediately after arm_smmu_init_strtab_linear().

No functional change intended.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 38bcb4ed1fccc1..df8fc7b87a7907 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -102,6 +102,8 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ 0, NULL},
 };
 
+static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
+
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
 	int i = 0;
@@ -3250,6 +3252,9 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	cfg->strtab_base_cfg = reg;
 
 	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
+
+	/* Check for RMRs and install bypass STEs if any */
+	arm_smmu_rmr_install_bypass_ste(smmu);
 	return 0;
 }
 
@@ -4063,9 +4068,6 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	/* Record our private device structure */
 	platform_set_drvdata(pdev, smmu);
 
-	/* Check for RMRs and install bypass STEs if any */
-	arm_smmu_rmr_install_bypass_ste(smmu);
-
 	/* Reset the device */
 	ret = arm_smmu_device_reset(smmu, bypass);
 	if (ret)
-- 
2.43.0

