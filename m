Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A77134747;
	Tue,  6 Feb 2024 15:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232386; cv=fail; b=KktKwt8usnu6wQeY1uDnX+A/NhP2noxgjRxpTm3ut0ghuOKG5emzoY1O824u75UHAmFgiJV08OP36/HFashAZWdYbuFlWI7YVBWUlgW5yGt4lHTHLfO7RGbU2GT7PXqWzBn1cZLkpB1ErLUlBMgbqztJ2KiP1IQpLemskQ1q5eM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232386; c=relaxed/simple;
	bh=x63BhODYjROKbz1HsH3vIJ8TrKiYMjP9Y2nLYVLlkDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j32q/CYXbyQJ3T7uae/4TRMozyT0LSfltgyV72fwfDYGTWHdyino13evq4ZEDvBkRW7IRnIb0xWoLgAJ+uoUgchhkNyfNSfdL0GiIIMZ22iUvkUDlqKgQX9qZlcB94Dfxt031HThseCaATGztIkuq0L7m08p7Da0O6XkJJz0iGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WgtjBNEM; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WgtjBNEM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H08100+VjsbtXQ4mz+DdE1SoVzOJ8QrLSIV86Pg2TFZjftXvvg7Bag6i0LLTS1hixT5h/Klm2GLlJc9QfoXjjPwrmHxcA2NaQnXL+MT7Hmz9J4vjcPhAskww8726DMnT+JU+V4ujnxzD5c0YZz1OT1rz0SZxNHn5i8zMbcSujejuBC5gBrqb9f+k7lIhcBLjqt3Z3rWeUx8K9WoLBplfHIbuoTO09OIfPMb1YZSsr+0mgOMuRnYdtF/4eCusOlgMLOQI7pQhwx9Iym9bLLizru5sPr84jbfEiXiWbiS5Izuyl88ujFxEyhomTq/On6sHkPf0s1XWzfVM999xV4ymxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jelnYfSZtSukW9U8Ez1I9xV3Nrrum3dHvFOiJLjtmCI=;
 b=oEnCF4e8alMwEXrkS3031YMijiCPOxBawMXMECjzkcxmCrVStFU99xUbdsaxHZUwiI0Jdv4BLmgxi1VJGssaNdm0ynUr1p3ZfgIz3xuCdv78IDKQgvd9SVSedjp2nrDSXBGgJXtVYRXD8wMxnzssIMMAgmsAyK/2LC2Wuyfrac2zXJmQ9i0mL6KFG3RXTEmLS3rU6tO9NcZGK7J6pZQL0m3di254sME/CH5bVH1bQ9z8z5MeqGx7SaOyrWZYU0badquubXYL78OEMlI6wjwMtOrJglQlUH2PXgfh3ToiTJbU3YTG6WQzoVA3g2VjC+lZzlMCxGx/31diy3MJ0IX6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jelnYfSZtSukW9U8Ez1I9xV3Nrrum3dHvFOiJLjtmCI=;
 b=WgtjBNEMJUSTq5K3FfgE31h9vaAIFkAcV4kY43TYdZcbSHsByESQplWetNb3qkdZE6O4Cs9kGwk96C/ExlNUgBwt6J1qmuQaae+BrirCozcyNX7hjBG2fCNp2aNk3fmXDNX4Octit7FLJi4ftRWP2ahzuXd5rsAk6gHDCtQ/Hc3ea1DRMD/EUnWnwOHSmmSA43eV2CLqR1RxpMELhuRaux+DIowofBSJ8KsDiyT/FS/igmO4yQtk/9oa5pEomO7Tbblx33gOdrvmP88gHxdB/rETc+2JMIJAJQhBQWzmzevk8pvddiq0mLf3i8O1+3U7so3jgN1mMxv0AOjC1rkW9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:12:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:12:58 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 10/17] iommu/arm-smmu-v3: Pass smmu_domain to arm_enable/disable_ats()
Date: Tue,  6 Feb 2024 11:12:47 -0400
Message-ID: <10-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0001.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ada73d9-c9c2-48bd-d1d3-08dc27261873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NXxnyge+J66xwiRsOExetgromZ65I8koXHcafpStaYjTvn9ZpSjhxo2fZGglYJQ+NBXIEbLHEG3b5VJVxuLK0VOqF+h+djJyaGYuR+xNGqCC8HdaarCjG6PRGOpH0c9MZ/PzNlPvq4CAaZRRov2BkLoS/piuTpNRSEqiQPFvaVvhZ/GFDSPz8I5G/JTejfCdFdVqOYQEVTghTtoqmhTC0T1Cr/8kntTvzxKOShXLo6qxIB98jqeSQTlhibqtxrg986NvjqhA6Arl6Ftse0VlTljsFkYS39n0AnCRQx4b87cTaFPmJAnlGiIRVnhccbMH3YA2uEPr3WavnxPSl9vUPPna0Lf2ukGA70nNyKSmGD1dkZUXPAJIE+TA6GpLW6G73NprKYkmK7EsZzksgbVXApr4gw47EkVD06a0C50oYZo7rdiLmhv/kig0F3TAMgYTN+W0zaAbKdFpMSerbXywmBO7YKQwFM0pmhrv7agluGvgkY84XPU8Iky6p/U0Iboy76qlD3zPyOxigQmzzJ7abf08tHv0bNBy4l0nqVE4SUP3YTlyMqXoGXlLbRv4/PJf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BK6OBqmcVp5D7XgUddth32oThnV/VdK+kuIoMiDx7VxQD7BAqCnzOB7/fa4u?=
 =?us-ascii?Q?DCtrLit98iv3sEgacaH85u/HmQDzGtbzj4I2d32jziFyLL9kPBRD3PU7pCOs?=
 =?us-ascii?Q?TfKt30Nb7uYmq7geaioaTH08SeUkHBL55NEM9Ehs8IMu7SZhox8o5frBfvKH?=
 =?us-ascii?Q?cg3XlsBXy/gBYBF3QsaBjvIXL7MaVDhHxFOzsxyUfZe7fN7OO+CEiaTsDb5S?=
 =?us-ascii?Q?JHDccxgIu8ZgyYe3/yZVp7nroTs1yfCjfViZdobPQR8xEL/Cp+32o2Q+YcD+?=
 =?us-ascii?Q?ujdPWgxzNI/vcWi6/4onm61fe9EbyEhQd1tW5Px7nh+z7SnPVVBCfhkGIN1j?=
 =?us-ascii?Q?cGCMcho5uhJlletk/XnFI6UHSeEZghSjVAR7Wb20oJRJ2S5DLWOYPkIMACE0?=
 =?us-ascii?Q?f4vQ391PlzHDlcWaAg1/160DnoGDLvpqP0U0Os8jJl1BB1v1UCbw1x4LjWLK?=
 =?us-ascii?Q?Sb1BBEUSFcp+wqoDIdeU8v1hpFQ781W6DVMPGBDmEVYX8vwyUsk/SW98uExD?=
 =?us-ascii?Q?yTxXuoe+z/JV8f8YWn+q2ylAxUG//JsJv+J/6tsgE5sM2dBPVbHHiNVl6QI3?=
 =?us-ascii?Q?E4ry7PgVuu281msb+c6oQjyMD9RaZwD5xLNfrMRWmMl+ZP59auW5ZMnZyazM?=
 =?us-ascii?Q?r1m+J18G2ViDWxe3v6cefm67UVI0QL6CauNaHLldpYoa6zE1GAFycIqYRC1T?=
 =?us-ascii?Q?E3VTfAn277xszFjqnIJyVhNihON+mOLaWipvEpAtcTJ4He+wCEuGWWiP5qIw?=
 =?us-ascii?Q?kJgEHIkXmWZaFht536rcIw9wH524NYZU2wmxEG6Gzl5rQDP52YTVT34iIbOz?=
 =?us-ascii?Q?z5pv8QkI/RkijsrJMYQhtfCs2E+Nv/55vbHoqUDGXddjdKk6VAWrJlyxmL/+?=
 =?us-ascii?Q?tfu+16YlHQcdNF8ZwEURAUU0gZidh1Qcz3QB1IX+XBoinypvpifImkE/IKEO?=
 =?us-ascii?Q?W56yV1qqFKCwIXyUIMP6JkWrTR4QJMJbB3PjeDvvE/U21Kg280lOF4wiRt4A?=
 =?us-ascii?Q?/a8Bos9wyyTp6C17HwLstFTJJT/92toDoNNB8yVFclGpuK1pleAnDUbnKSOl?=
 =?us-ascii?Q?2XPSuDXWY1gQdUx4AJH495SCjDqpBh6Wc1F22qnx/vwh+pXvE/Yp1d01od/i?=
 =?us-ascii?Q?VZYXiSnuC5V8ahUDCY9A2d5tEtqHgcYg8w4vGn+vSF+uGCkaFQ7HJ4PKq9tl?=
 =?us-ascii?Q?Wv9CBK8BC+l8IkzWCFSeaS3TqGyIRrKraCi7DurF50AoEGdtlPret1yEHzH5?=
 =?us-ascii?Q?Qc96QnJRnWm+ib4pgNYBRTR/nUHmcseVYjSpThEYOx2zP7T99FWZKPs7E0Eu?=
 =?us-ascii?Q?h1kjPcmOVEvQZBJdZvlQn+Ohv14Civ5K+U/s9x8We3sTZ3bbmpu8sNi3Wi44?=
 =?us-ascii?Q?yKpW9KHrsPPrbZym8Fa9LnYcKi5GmvY1/nOg6NyersbtDJUjTwTWcDltMJly?=
 =?us-ascii?Q?RNWxyTepShTNOUhYuNR0uvYrKgZTvmPUA7yN5q+Lzp+LjGmKFMfhlQ8yD+hC?=
 =?us-ascii?Q?Sdf+X1zywXuCaz7Hc2i1nq0x7XgutuplMc8F6gsNhATyX7L12xGn4mpp2hUA?=
 =?us-ascii?Q?LuFwiz9eEZc5ZmEG1TO+lFli7AZEd/X+N8R/HuAn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ada73d9-c9c2-48bd-d1d3-08dc27261873
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.3336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ptccVQrFt62fjOXCfDhE09ACaQJilwxJHRsr91dcrSt2mxanNM24zdA+aVnC5DML
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

The caller already has the domain, just pass it in. A following patch will
remove master->domain.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2a6ac0af932c54..133f13f33df124 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2474,12 +2474,12 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
 	return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
 }
 
-static void arm_smmu_enable_ats(struct arm_smmu_master *master)
+static void arm_smmu_enable_ats(struct arm_smmu_master *master,
+				struct arm_smmu_domain *smmu_domain)
 {
 	size_t stu;
 	struct pci_dev *pdev;
 	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	/* Don't enable ATS at the endpoint if it's not enabled in the STE */
 	if (!master->ats_enabled)
@@ -2495,10 +2495,9 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
 
-static void arm_smmu_disable_ats(struct arm_smmu_master *master)
+static void arm_smmu_disable_ats(struct arm_smmu_master *master,
+				 struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_domain *smmu_domain = master->domain;
-
 	if (!master->ats_enabled)
 		return;
 
@@ -2567,7 +2566,7 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	if (!smmu_domain)
 		return;
 
-	arm_smmu_disable_ats(master);
+	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_del(&master->domain_head);
@@ -2689,7 +2688,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		break;
 	}
 
-	arm_smmu_enable_ats(master);
+	arm_smmu_enable_ats(master, smmu_domain);
 	goto out_unlock;
 
 out_list_del:
-- 
2.43.0

