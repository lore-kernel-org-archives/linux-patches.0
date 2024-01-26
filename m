Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7972720B29;
	Fri, 26 Jan 2024 18:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292953; cv=fail; b=FSF/OjFBDPV3tm6XlfRGCvQhyIN1IqR7tEH4Q/P+i/J6Twz6l9EJUtpRBYKPxllG3BsllyJUtuBSs9J9QpdGCiTkHoZX9r1t1YaY0+/lyCuGyhPKaC91/rhxHyNgHkigEyDZPNbX8iN0L+bUNOWR5nW2du1cnunWagFcKQbpcf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292953; c=relaxed/simple;
	bh=z/1t2sPrh2TPhZJbhzUYgNMNOulVi6BNn84UH+YntiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WdqOJKsoQAvd8AMGUWLsTgaeKWUWbhyEYC4/LevWhqGB+Q1Mi8iv8GJEmosG1lwa9jrMS8Z9DTbfDgVfEE5Ddds/HfO5lHydTV/Fm8m54kypOLHSNIjzPTnsLoqMZtKl1TT1I4+njfhYvsgZcuQX+0grYinIWWwSDTWAELlGdjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gBOTcVj4; arc=fail smtp.client-ip=40.107.212.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gBOTcVj4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYsPThVj8DSamUc+2Mp0qTYMWn2orbpyeuM0UKVhWryLWQgmALUiuuXDcCkZ3xtt9V4j7Yit8gzjct9e4K2WfrCA9v9kn7pLTTE21l6LcbfCcL2K7o06GD3ShEjWbA39dFjTSaAA8CxYZOBDZguqjx/+W3yHvakg/3qMLxN9w7BdXSFqK8bWxC/dwKOv+kPrYuzqeZ9CrVtoLCIOhfDVso9HQyBcAAfbjdlHic6s0SL8N+Qv8SNIdqfYvYqXKyCNY/MIfzUxjl+JoaJj1iSFC9qf/rs/v5F92T6hFxqV4hIg3oqorsfvHrlp8VrP/ELvVn7utEdHELMsZFfS0se8Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rraAjs0FYBWA7Tc2rKNs+wC2hlKlBTvC3fi9lCb3Nqc=;
 b=D/0bAR/1Bf1WGWjuBygeJc5ibWjRS8IDnwQ5BC7JQTzV/VDwdNM9tD3Zb/CplWlg3iqrHblW6WhJ8kKwj05k6Hqx0qN2CYECsBi3Pu7rmLVnWGzO8NLDLck3AQg0XQPuqTj3tlgmBPiCBoUe1L+zALGBtsv+LyMgyqM+A7nWIyybVuHZgjDTANZoRbxs6k2isJBH610r+k+AqIj1PPskrTQoO36JqK+0EiTg1fo51w1XymHjp7OkFhWTDxVs1KNqVJcHWuiG1eYpLP2+BS37cI2SlMY8xyuOKeqU53UpV+i8XA6dymlZIRCw0GR6nQ/t1hmgrR6Ibl4wq2JdZbbAeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rraAjs0FYBWA7Tc2rKNs+wC2hlKlBTvC3fi9lCb3Nqc=;
 b=gBOTcVj42xfJa/pJSS3tMaZOmM97EsIOFAzjVvYhLHu/P2N72RWCrSIMdWwZM6J8c1fnlv/WT0lmK4laqinMNGDXfJDtxq9tXwO+vwAhgOFAfx0SWBRzhECm4BDyqM8Up0HwtacLTjCNW2Q/ajqoMq+qrEVxDfnjsHL1AKUVuLRJPpuAlDpcMyYeXLKOTdfVtRaVH3Fgcj7Ev5b9TwBqNR2nybtTLTCrftol9QULm1VDV6WxTYzeZjyJCKpRJ2nyc1MRUYiLSOm8HqzMHAflH67SeoEZ3NFuYddPFCS2k9QRDIFw2OB93vxIIZgfniM16/ZQCdDruiDNkZ/05gtipw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 18:15:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:43 +0000
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
Subject: [PATCH v4 08/27] iommu/arm-smmu-v3: Move allocation of the cdtable into arm_smmu_get_cd_ptr()
Date: Fri, 26 Jan 2024 14:15:10 -0400
Message-ID: <8-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR18CA0001.namprd18.prod.outlook.com
 (2603:10b6:806:f3::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: 279659c1-f9b6-4646-8d16-08dc1e9aca16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ik9tzu26bTr6oj6XMcUW2kz5pgqmAD/R0OuMXCmo9k0Dq5Tj7eo9zO8i1e8LgPyfJJnmte+qA6BZTtxz+/QUgKSMeRDErsLsGiFoDo7YeNQ2eSOuVUVOAof6FHwl457PRcUs5o9EAKRHhXpO2sdAjcmoPx6k/enNnvSaG7ZO07J/AkIRKjZ6j9NLiQzfPtoHLM6Yl4D+2e5mU57mC2OoMvgPV3F8fK/D0LGruljNUkhNlEENDC9ct/ujSxsxasSBMW0wlG80Zkhi2+iGut0hidD3KeFAWSgEdwzpPcZGP3r2FhGcKdYd5ihI08oXZOSvzD64XTKjN9dXtQHifdozmEIuki4B49dzhW+0p+Ajw0VBMNpHcWmdGpkg+aNFz8BVFQhTOE6vruhlW3dJmftst+upln2IksXnXXd0Np+4tN38qPIIgEMGwqnqFeCVg6bl+cDSJOICUNq03IofUMjiWlazq2JXPUKFPDY1L0/vf7amFd1YHmi3MISeodGiYoiFEzxO4hZfWkXZDGicl7COERvnNqTm6BxgHs1l0qf2fKJ1dwq13ymIEqBveOna8Gxb1tv/IjzTCqsriwmo/b6xzevo5KQ7T2e85u8UGwlHRy2o8rrebAztagub3YTtff8fAJxQtBpQa8LHV2wFqgO+0Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(8936002)(8676002)(4326008)(5660300002)(26005)(2616005)(38100700002)(316002)(66946007)(54906003)(110136005)(66556008)(2906002)(7416002)(41300700001)(6506007)(66476007)(6512007)(6486002)(6666004)(478600001)(4216001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5DVaoa/uBSJuwl7vMyspNu13YrcN/2KphqyhOcuuZbRA056HiFBXqKI0MQy1?=
 =?us-ascii?Q?AXwmr53Eku/Rj827Vudub2V3DiPzsYTZUlLQriEth1OHA2Y2Wzl4pghwi3Tn?=
 =?us-ascii?Q?DWp97dMTgEu2d6Hr8ATY52FT28F5RBS+Kq2dnfVfveFzA4sG6GD3n8z/Y+0z?=
 =?us-ascii?Q?SQwn1cL+5HW/ApmJw0aO6O175RxLaZyFB9Q/mHzks/IyOTyELjMlWnhm1ngt?=
 =?us-ascii?Q?LN+/57gmvXWQk5oQywsz+Py4hau/ATV8XRU5uEkew4n5wGQMH1Xr+nDjLS1t?=
 =?us-ascii?Q?wVMLmjwYgK9J+tI3ilxBXqM3v00Q0/r3b5DUKd1EB5rCXOh8jaJIPequTiqt?=
 =?us-ascii?Q?Ss8N9rDS/wN4eWsxq9Yl03ufDSkgQHsAEGIJhBKaC9iHPqOT0ASp3dD44Yld?=
 =?us-ascii?Q?RA+kmDECO3J0eZFyTwRWJzQRy3dALEBemTGeeUQpXNxVs5aue+QSPCb50bjK?=
 =?us-ascii?Q?SXO2D62/UIDqNBUmmae+Vzr7tCsZ3sWt1VGBoJu40CQYbrd/4ic8GV1lSJx2?=
 =?us-ascii?Q?j4r/fwjjjGVIHqxOSCP5+FJcgdXuBV92hVKyZczsUSy1XBqDwAv2Uhyt4W1Q?=
 =?us-ascii?Q?Gej8zfaoh1U5CM/8rFbkXAd7L8DFKJINley9dmSdgLy/a5O9QyvDvaA8RA4I?=
 =?us-ascii?Q?RwlHx42gtRDP+upbPm85yQJUXqAh5DO792/bzaYIi2KMAJlVQiYoUSiYLb1P?=
 =?us-ascii?Q?4XmlruAkgcItY3IFVatkRuchoZM5MENZSSvGGIBLoHFZC1QHS0W9OiDG+5fW?=
 =?us-ascii?Q?G5HCZfCm8ZMgpFSCKe2h2bX1X3uB+A5H9GiazbUp1FD/8VUeadTesGhJPsL+?=
 =?us-ascii?Q?tEEFvLJcmANKZqgZa9h2QOq/2Pm/fq1w7hUNzRsWoF1glppueUM88ShGn4oL?=
 =?us-ascii?Q?lMQUEpnQ9UZnXAGnjJe7n+MCsNji1w+IOJlRuUaQFSqm5Ss67DzU8xTRTlsS?=
 =?us-ascii?Q?ajdhm5aZHhZt2ucc09tMuyNH4R4oXutnDKjigM1dFUeMFKrk+205oUsu4uI+?=
 =?us-ascii?Q?VSORtZVSRjGxHJO/5bLDhcprdBHpEIjZZjCWACu4OUWEHLRIyS+8VTWa5nt0?=
 =?us-ascii?Q?hrSCrYOGwIttnRQ44I918r0cYmfb+pgn0XLSHbxCzAepSmyhOSRe5XL92nBw?=
 =?us-ascii?Q?ngmYSS7zPyaEVasUcEDc+/TBAjltz0fWjxqo7v+Oh1lmFKBFWJbxKldIBa+F?=
 =?us-ascii?Q?CpMvbn407ijPeUDCbi8Wnox1fozFXT4ZoHo/gIZ6h5HSywEN9nYSt3bs/I3l?=
 =?us-ascii?Q?jevSRjeCuRlQN8NWMUjKvIkjCMAn7fbMzw6QZiO4grG0KChdAYY6cQzMNIVM?=
 =?us-ascii?Q?q0q1ffQBXeXxhV0RferZUqS3hnGVIy16F8lX+/3EsmwT9rY21NyOzH6MJj7d?=
 =?us-ascii?Q?NqM3Ck9BgXO7R+BNTWhQcb+mxm7V8Cyu7EEubHPMdIWxPt5axaGrZEUSfKcG?=
 =?us-ascii?Q?9OOiBTYyCJd1qxqpoLUQEx/zXj7uRptDg90I8G9WdEIOfw3NoGWHGawuIPHI?=
 =?us-ascii?Q?0W4tTVIoAFGYkpKv4H4zAy6ZOI5knG2vaDkRjbOAtvJ38F9A25TiPHdidL4I?=
 =?us-ascii?Q?u4cZaxjHYqeuvq8lTidJnjHEO564QcAVGHreYNY8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 279659c1-f9b6-4646-8d16-08dc1e9aca16
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:34.5186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gu3RKLLT4plMtARigqj3GwVbnh0BlxQxgTn5O2Tl2I/+c7fY/bEGA4H0f2er+ver
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

No reason to force callers to do two steps. Make arm_smmu_get_cd_ptr()
able to return an entry in all cases except OOM.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e4e62f598a0859..7562d7577f3940 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -108,6 +108,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
 static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu);
+static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -1190,6 +1191,11 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
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
@@ -2708,12 +2714,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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

