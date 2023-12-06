Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B7969281;
	Wed,  6 Dec 2023 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QV78DX+S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnaykiL+3V0CzPouXW8rypeDadb7UwXS+onhhrc+kHFTcQu9BSpcYjg5kgRkXdH2sf4qKSolKl3RFsvOU5m9xS/oXl8+a2qItlWJRuvkPGA/sFKQWbl/8oY4gAK6DlHSnyWdMpFqzFfn3EuxJk/mviEzzbUCInBShhxIDyZdjYYjxTSAG2WMfRxfcxYrgrLLckdbSeHEiHAyMRkcKpqkXftQFucrZDDs96EzpGTds250WuvkW+RHN/2Suzc8Jr/rA0TGysg9beJHeKcw1gIbIxFP3iNTdnbe+KQGRtQh0OmdV7R5bMi60zSx/jqHl1A65yf40kM8mRAPaKE+3FHkJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDzepfs9lFCdgqCgl6iQJZ3Z0CSeZIsWdVTnV/y9GA4=;
 b=EXrhXzUqVYhzb6uWcHKm7dueNoqb4zfCjWQtupC66cORQpda3RHB3/ZFAIVfTv4gQj/NkORib78rOeYzrCXAP6cJN4zgfoY7vk9fRfuoZ2ioynYQFy+rqIJrYx3XRUFEGn3Rz3JOA69n1f9yGTJCjrZJzQnr35ncPNEMTK0yzYKy1U5jTHBQub47hrYyAScASvDoFiUWmctyXaKvf/ozUkO4/Wcnl2fFu4lxyJ9t1o6TVh/3DMTxB5d3QBMpzIrWOxSw7E9bmZthwN/s4/88v9qpjJqsuCB19H+9PL8I6rpbDU07k0fdrcDw9F6hJ/4K0/OFsUY115ZgOG5OE6NPfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDzepfs9lFCdgqCgl6iQJZ3Z0CSeZIsWdVTnV/y9GA4=;
 b=QV78DX+SceRPJcA1u5kpgSQGYyr2ORdLw4XPKgR12gmOqM1IgPUmW/WBwzHIUSpbsRH8uCGF+XUP29q0VG4LTv7vV6Wuj9v+UOYzC9NLOF72itVgnw+ffyYFmHpeN1Tnvb+wDPRvzvuLNE8huqaCOzH7A/iE+RBd/Lmy0o8inTJM8n5QVK+GKYI1IyCh4KdqV7/5jt/C9sexqZFPZcegkx9fccCR7kAge8HFkzCSzsThhbeAH4vLYlNoezSRtcmQa1kK8GSKTkBbI5CvdPnixxS16LaOpFIyM8FzkbygE6qbiyBrhQVAViyBnvo65iZdephiZUhHPd+Ol8xC1DFdqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Wed, 6 Dec
 2023 17:28:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:38 +0000
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
Subject: [PATCH v3 03/27] iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
Date: Wed,  6 Dec 2023 13:28:09 -0400
Message-ID: <3-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0024.namprd15.prod.outlook.com
 (2603:10b6:207:17::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 60f13c85-ad6d-45fb-707e-08dbf680c614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EvUj6DwVkhYM538no2SmmWC57KtSSLptmAvN0K9O651gZX8bpZBWWc3pnEZ4si/pK2CCk2gsCMdiZZKMsXzEVAAppVNmT7utIaZ9fM23p7pmHQEWxjqsRlt2SkG6jgGoEhq/kt4/pw5HtGn6IWIghHxWLcaLUVdn4rw2+2RTPf2RGMml6NLQvr2UM01J3X+gph7gdHp7H8ABrS/A0DpjEBvruj+RsAgUpxue9bfv5ioiuzu7ThBbY8GhNf63AfiFNSr4puYPYLU53dRxomJKEPN19K+30j9pktClAsCN0QOUsYd+9zS10TIms0D6AMBfmTHDkJh03vnZhZGwtPXkMa8VOnUPrNNA/ylAg1JM+tYo0Tfm+3yzPGkrMWDAU7Gij+DDuILqB2Y7FJ4bDJmOxbvTYQhL5PVM9KpNagJdMlY8manssCdG9cTt2WyqzxGoBPeJP9tAoX87Xrs4hhwjYC7FFaH4QBtTFw5f8g0fH6hIGd10FwDrUw+hYxRob7aSFemhHv95opF2wUERIm4493C5mu2GXszedFI4pCs6ioOIRCF+NJW5xAdWdJ/bixmd8P+Ij10wJYa8PH+lmEPwjbZgpANOm0+Gti8b8vX65x0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(8936002)(8676002)(4326008)(2906002)(38100700002)(83380400001)(7416002)(41300700001)(36756003)(86362001)(5660300002)(6666004)(26005)(6512007)(66556008)(6486002)(478600001)(2616005)(66946007)(110136005)(54906003)(66476007)(6506007)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yKOxg5zv/0eYxFz3TIti8zS3Le4Zs0XjsF8FV5m8aBMaaC2Acm2MV7PrbH+u?=
 =?us-ascii?Q?mIHtQO2Jfq4S4Z7bMcaBzBb16QwZdw6h7HJ3lhlW0wBVbOqOUpi+5nZARwmg?=
 =?us-ascii?Q?AzeUJMlpwAF0ZpMQ54As4piB+R4V9Ur5FscZPICnJU5YKrlmKuPLLPkA9+aO?=
 =?us-ascii?Q?E2YvPY0Sg/JTnj9dvrbk46v/MmVfQ7+V0pACFBYJir93rjTOhO5LiHAYs2Sm?=
 =?us-ascii?Q?7R0fyifSnEzqjrHeZF/SYL48GjOpaSE2PXqEOCRkMZV/jWtSWx1oZTNFj8+s?=
 =?us-ascii?Q?E8IIYjXPg6S8Rvdvvt+5Hpj9J0zzJx2XW5njGMZHPi4EFHi9Nw5z8CmSQObe?=
 =?us-ascii?Q?1vnBQZeTafhYXkfW5Y0x/HrVhtRXMxCYNLEPDtsbXvoQ9+9uVcDiNFgyuxv9?=
 =?us-ascii?Q?Ui4LOXPJ5nKhQlJFmxjLsXxhzTJUEqxeZiYWYvgKFj8XDgY3Pc1c1qDzxYZk?=
 =?us-ascii?Q?73b1ZSa3MSkyEdiAQl4U4Mtp4BQO/S32UG4OxjISQKoSGB9MHvxb5ST/ByBd?=
 =?us-ascii?Q?TsdIS/x8X/ZQuM7oA5OJHIQZQmstiueit+iIqzTp0m8/7j46p+WPB933dTL4?=
 =?us-ascii?Q?0ePyFTH8D3a+6yoiDyRMxDTk68BQZvuAEK/BbkyCJhNYbpsgj6MsOc6kN0UC?=
 =?us-ascii?Q?HlE+ylWDjvaFsjBmEAI1Qo+mMoqMm6qlrc5IduUn1rJcBJ9kepTcsN3b87gt?=
 =?us-ascii?Q?6oKSWS7WRTTeR9kWhoQnviNfaIFOsGrxiZ0vT4JS8g0+ectHPU9QGlnFcLWQ?=
 =?us-ascii?Q?RVMhNoKF+gaDFH/LUFlzHlSOaLKePq8CkOVTSKdh38syGxELy6w4aObpe3PI?=
 =?us-ascii?Q?vJh7nPaD3Af/5Xfto6oe2rirJwrNbCWBkLBkplrPdU4a+5ogcNVDOcoUaV54?=
 =?us-ascii?Q?2AIRGXc8yO4BDwYQxjmqrFRuAaNlITBn7TCBEtGpLWGUgboJaQbm/fWo1Tcl?=
 =?us-ascii?Q?nQ+pnWDHSWXI2f6B8HioLnjFx6lhxK+Lxfb+TH9XooZvcIeK/nTbf9pt2wIT?=
 =?us-ascii?Q?grsU5dgPn4aLa2gQYkax+GxU5m9sJu+CglhsoqSE7fpTtBah8Dt1d8mbYSe/?=
 =?us-ascii?Q?6xoo2FSAO6SWbmcRur51bDzpQey/oJmQwcnlPcEs9EUbEXMci4w4o+TWh1Sx?=
 =?us-ascii?Q?kjf6zpltvpuEqd1i/311gP5YPNzOq95TB11hQXPbokk2C7VRVyVBo64hz5Fs?=
 =?us-ascii?Q?TfMvarp2WUPYEzcTzyBFTIj5kzFy7j0efA19WTEYGbnJ3Ei3mVO1Fvvt81XW?=
 =?us-ascii?Q?9lkhKFBQkGXpib/yZ5yhhglyISM/P1/iwJ0eA1f5x2zi10hr4qMIyyObQApR?=
 =?us-ascii?Q?Wha+hY7zXWOwPavm4MwcIg9s2eIUdIvzR+sajHfIxeDmB8IPnnofwNUyw5Dp?=
 =?us-ascii?Q?nlXuq/Lybbiy04URlRTBR61BGq6wQ3Z3Qk3GghjVDq2IoeiYXkTFzYrCpFed?=
 =?us-ascii?Q?J1PzXw+cgMyF4VX/hS73CmlfZnUzxVQeNIyYexYXhLv/A6aMlwnS0KPz02CK?=
 =?us-ascii?Q?GDf5w6rSgYgXpb6KOv/gCVRVtRx3WK26DZf/RXLaH65Eb4K9hvsYY3YSLlvL?=
 =?us-ascii?Q?WCdPDi9OhKT43U22cy48JobHYaWkjKZ6mPgROSnf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f13c85-ad6d-45fb-707e-08dbf680c614
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.3872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfpuS48qIyimOQbC9H7PT3crChRYEgjs9+5CUF5mp0cvh+kr6XIqeRJMerdaD96R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

At this point we know which master we are going to change the PCI config
on, this is the only device we need to invalidate. Switch
arm_smmu_atc_inv_domain() for arm_smmu_atc_inv_master().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0f3bbc4a2addc8..39e010c838b1c2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2416,7 +2416,10 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 	pdev = to_pci_dev(master->dev);
 
 	atomic_inc(&smmu_domain->nr_ats_masters);
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	/*
+	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
+	 */
+	arm_smmu_atc_inv_master(master);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
-- 
2.43.0

