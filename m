Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE052E7F21;
	Tue, 26 Aug 2025 17:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229212; cv=fail; b=VCnEoUtUZ06bboP3efElGetcLnAxBLJhnJJJyKd9how7+xyCH1WOpJC4cAdc2bYwom5rZoOmWw1MI62Lxjb/d+IjXMldnm1zIzUyY08/2kPxZwp1x6ufos3Qk8ngeh5OcZJcY7fnB3QzxbHI7X2a7Ck3fE6lfKLqu3cwtZPLNw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229212; c=relaxed/simple;
	bh=PpmldwAA5p0U6cMTL6KaQ3do0nHOlziJJ/tuVxDmK7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uypbka8FzxYyef27Wtf8wqyMkJMt14PY9mm3e9/o/ARsEsbx6WeH+9dWsp9iArhAoM6bRt7o+PU1BtTfv5RmrXU1/MtgPSo7Zbx/BgzL0RhuKNqRK0zWA9lnGHKgqHfsigVciFW1EnNVH9gS3wTzWM49dUNonxkNMCPVbDVqHZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pi0QIBGU; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pi0QIBGU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=povzHxDzhfz562TrPe32Iuoop61fgcBLgpiUW0gOFwyPs00OBRDGAkw2i4iHq7lp3DzDikb9h3Qs0YTNzLEPHDZ03pF4qxNa65ePc7rI6t3Y7a5aRU2VksZQv7HDuxCA+Q0DrEqRMQuvr3B431JLurV58iq6tW4L4llN28eEgkbayziSHxBv8Euua+R5MGMJ+PWohuZGUjENmksKhXKdC1JX/evShA3PXLhYNd/ggqy1oROYDUqkzE1FCjsdj0TI9UnigFFIndUSFeys/JhcMNIdUzGfpoVSGhtv586WAuJuG/0OfCmidGTjP0WE/x519aJoX+KfJg/IvzrtvA8L5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHuGXll6goLhV6js2dn7b9X97d8CWhsMGBkMRx9ilDA=;
 b=Muz5OvEZBnN+KY/zvTqFuw5RqtPPGJ2mkV/R+cGKP7befPdDMod3rfv5QIr+mG3EhrcaADw53ezUZHCsCdQQ2kmqxfazS3SqpHoX32/PYHfw0sfm0A+ladcKkh2LAcfePAXImh28UkvcRb6ll4GE49wHa9cBv21LzHIUTUbFZIQRMBJkjhncTkmfPUEub7pwb8RyVru0Jo3fS+sq7SC4w3Xz/uc1va60fa2YBpYi1pnEbhGLv6hyWB5/UnHsikZViJeYHYU1v3NpxOAcMRv1TD6kLrAq197A8j6pwAZ1RglBZX0APpATcOmQwd8yhT8bl4hde2BHOPwr3zAwYPb1zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHuGXll6goLhV6js2dn7b9X97d8CWhsMGBkMRx9ilDA=;
 b=Pi0QIBGUZpgvv+KnJwdaPLyqKsVe3YoWgwiML8j6gRuF+bEWyp91gy3xGMrior5Bjd32f6qv3wCp9gpJxVRPSJYD2DKVY31ELvlN3Tfa6mZMP/Aqsg8bHQkixWZP7bZrf7Nc3dedEOe91OVLByT7W73zfe/2ZOkxBQ5/qVWd+9hOzvVujjatxfYFGmF3tKrUXTGKok13ebTzNqaqtAsMWI7Gm/eSndOYekAI81HYsXqAoWCnwE2Upj+qwuDEz6RtKuRNlmkJ8MKzfzIGozdEdAp8vf6YOZTFrsVRJM4jR4myGJ9asQiQpSR86WKp/M8A6/nhhjNc2vxVy30gC0Hdew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:42 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:42 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 07/10] iommupt/x86: Support SW bits and permit PT_FEAT_DMA_INCOHERENT
Date: Tue, 26 Aug 2025 14:26:30 -0300
Message-ID: <7-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: 782397b1-8a35-4040-da4c-08dde4c5b854
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M4p+fn3bAh1sfbvi6nSCTdr+r3eoWozaIHbv1uXPipDA7Atr2SgFA+TP72ho?=
 =?us-ascii?Q?M5nIbT0rarw0sDTb3nhocZexrr7w1evyZQQbOMI9OMU3s8FRrahaMiG2G9oY?=
 =?us-ascii?Q?8yJkSQ9+nWv2ntFvc8AiWHcXlUEW7JdJdnGtwF5WqouplZux74VbA9mBvs9S?=
 =?us-ascii?Q?6wW4ge+Be9xnO89XKJfkWQI2bP6OM7OKQJglHf2kljK3yNAFU+peBiOcXOEx?=
 =?us-ascii?Q?3NAWivfcpFGiE1hDJo1YYBFtNGrpQXZq3RKA0pv+DfGreIn7HlqXnf4XsaCu?=
 =?us-ascii?Q?XtViYd0oWcih4/8yIcwksbZk3BjvGy9lgYWOGa1+OPvAk5tqodsCa7r82Xyk?=
 =?us-ascii?Q?VG3nrCtaYg4fu+A5Q7E4xIiRXzuDdFJODT1lofoBRjR/rfAwDtuWoaHGJfqC?=
 =?us-ascii?Q?NW/0loIMjgYb3gJ40mKuq14Ks8N2QLtwKp7Vjz15VjsgKMuVbgFWYvMuqjoC?=
 =?us-ascii?Q?97Dib9MLMvu9iIagrUKLBmCj+2vNyjSE29vUSNG6a8pQZ6wJIfUdSZQsiVUw?=
 =?us-ascii?Q?Zhk7Al66pUQ/oz3SzNB71y4CooIPDCbzI2YnU2rZcaaHIYXuuGloJFMuOFjc?=
 =?us-ascii?Q?h9wO5YwzYhcFqj1QO4QT22EBmC+JMMLx9wDnEx4WVVReRqCr9bNKAoipj+n1?=
 =?us-ascii?Q?szZUAOWb4sdkITRnaoiT2WCwpw7g+ES7zOg1spGhsy7sootLRv4FJb1OwLXC?=
 =?us-ascii?Q?QPWJrXZE8Ykn32vZBjnWlFINjTr9QtaggOBSWyc+RL9theVRteG/ETVhAto6?=
 =?us-ascii?Q?1sfiMXP0srTNpg7RkJnLlxBIN5Wowz68rBnAyt1Ezc/61GrpUulhOi7HLP33?=
 =?us-ascii?Q?83qJL/N3aQZDwJ2D6OCqbcwizn6x93J6758wddGfB9xtrH1CaNJ2/Y4ls7tb?=
 =?us-ascii?Q?6IR44cW5pNeyXECqdTklmh55dA/LBN4PyCbG6s8qtGihzAvfhWghmX3DJftN?=
 =?us-ascii?Q?ps2Wb3flyF+AfHnYUp/44Lp3TgcsbPavGbZJYnezaEAMLh7kF1rv0MWt6mkF?=
 =?us-ascii?Q?2AWbSwoXDScqft2mlkr0kiHzL5g0tfRb6suxtevkUxnnur31QgeDhtlctUSB?=
 =?us-ascii?Q?n5ZfsfAdGOmFAQb673HIt15CjTMm+M65OEQUEN3oh8ba+Iv6B4UUcpgDeJ7c?=
 =?us-ascii?Q?owQZ1ReNyLtd/5Rcj68uXwC60H6YmMqAG9EqdN02/vkIsjVxPTKC36a70Y4b?=
 =?us-ascii?Q?F87NsXYsboLChLu5gFnmvp3ANCmdx0lEy0H5yC9j6ArtOwsEpJ4iJ2u/ZLjp?=
 =?us-ascii?Q?HtVunRwbbh6szFZnX6fxWZlOJnIWyRDDxUBY1WvQ/1aC8QkUDOv6WkgSwVUM?=
 =?us-ascii?Q?8L/Uh7Roym8s0L0dKb4aWLT8FOxzxXvubB9Oto3bmwJSUf0pPLjsUYZk1lXK?=
 =?us-ascii?Q?qwo9Cm/ffz8rGOG3/mg541i2L2m+UiLugTXhzFVEfEEYSfyFi3V9c0Ebr4aO?=
 =?us-ascii?Q?ga25GK5Ds4I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sIk7Z9HxY3X/ZqfrvkbES5ov1CuZjaiCCIxSMDA5QXocyFTPsVP21/6BGzMM?=
 =?us-ascii?Q?L9Ss1IdrCe5NaWbWN6yEDBRUc+vWc4smvBnDQbLAB+C95Ag+ewzYPwugNuvm?=
 =?us-ascii?Q?e/0egvkwDuyAFvDy7RgIFPVvHD24XCbe6fDF5535Jccec7FgbrWHTsVu7XEk?=
 =?us-ascii?Q?txqi84xH8P0WlPPET6aax/e9/W7+0NH27LBjc3MDqbWVYZ/MFTVaTYYhv6t1?=
 =?us-ascii?Q?IASMhnhs9scNpRw+j+7OGu7/PIpGRuD/VTN/AFRSLkb5fem4PTgNt1oi5m4I?=
 =?us-ascii?Q?oWqPxinBSUUTu3nvt60DN+cz8goMGW/7vlG9iKmTt2aSFKuc/bOSClSjr20R?=
 =?us-ascii?Q?BVNGhfMkXRLF+5YVNzOsfTWJi41S6oRIM+CUyb1fnwG6tJfKmAHiYR5bn2My?=
 =?us-ascii?Q?Yjq7T0fyc6RNR4GdLNyMFTTxw/pI/doRYtZlOJ/GBDZKKFiIu9MiCw8jYyw7?=
 =?us-ascii?Q?tZMs7PCQoRWU8lPEuZTvBpqd63lR0p41ZQbdsBeQyYeFy1N2LPZUBjNohsRm?=
 =?us-ascii?Q?2OhNggk3u+w3I1Jq41nZ03Z0xTp3+RuukijoYtnr/C7XBfD9tWZntUGhF3vZ?=
 =?us-ascii?Q?uOjdIdfpyC/7eA2byLDDofWgUqvKFHSsqx1JcM+RSBdL1mmaAgfSp6L3ismS?=
 =?us-ascii?Q?+0y/OO06RzpYsO7lYVo4nTIXiQGfdnTASffJrNPBuPJ5yLKoHUAVFO6rlyPP?=
 =?us-ascii?Q?1BxEt2r7RGPL+NiKPJN7qIEw4Clvi3KR9isO02OmU5f+b90AJaEjxFwSXXxl?=
 =?us-ascii?Q?A/JS51Ln2nIDCRwJkfw0jKPtdK3CnIzDqUgNRGtQjk2zFbEMypYokPzU7jKD?=
 =?us-ascii?Q?I1ZZsHWb5WOV+jzKhyeKdoRFk3UyMqZs1Gb5H+Bj++Pc8OmTHLSQbeYc4Q7Z?=
 =?us-ascii?Q?0E/SnqeFWlnYbiHHjYe9Gi3k+Poy95n+7ZNBIBfYKb/dPOUsY4Gekmio6diZ?=
 =?us-ascii?Q?LQabyPv3dc/JAep/NNgTAJgxkTWQEqGSflNSg1n3N79yWsPZ1cS3m/O6VZ3z?=
 =?us-ascii?Q?+SGjzGNaas8wuHS4V759vZVhLOBDiHRVdKk3VaWFGMonSEgNbfOCcBfcnvLe?=
 =?us-ascii?Q?8RUxH1Dex18Pw2cktzs7ptne8BOe3MTCPyqEL0F1hPoJ4fE50QN2auDJjSsv?=
 =?us-ascii?Q?djozzfmH5//m3rO3GtrsgeYxANgTBxYX/n01qCtUukHDHcSEUaKh0xKkqpku?=
 =?us-ascii?Q?xTF+po5CU89ykiYhnNxBWzRPAL4lht4M8w+ZUdTj2QAStfeGP8jTuMexaREe?=
 =?us-ascii?Q?c7XJSCGWB8RnFYSmVCuJYVZmw1G80JyIKXo3Cx8uhB1h10NsNAxwT1f12qcJ?=
 =?us-ascii?Q?wo+mrE7zuKZSerOaGDfKajFNJvNGa+JL+cLSAJoaZtDPTfh59LPINbEcy+Sz?=
 =?us-ascii?Q?XdEzUt/WJilQJGNkX2DJMBa0k7RBaJh21Pk2yxupvbzAkgIBtqp0kI6CV8qX?=
 =?us-ascii?Q?9dSKABv2NNZY2EBMF8OkmVnqibXJRtEFbOGo16x/4hhO9jLX+S4WJiA36Hw2?=
 =?us-ascii?Q?pxppKhcOSMpSrD76HrE9sFARaBdnCUUbzBZdnbygH4ytHyw6k0r+9MXp2VgP?=
 =?us-ascii?Q?hueT8UdKBubd3j5ZFJAmy7K9TlXpbL78Ce0b/oyS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 782397b1-8a35-4040-da4c-08dde4c5b854
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:41.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: teaGfRNp4BQnwd80/DE7qFF9uxnax0/mLcq/dSk5IJ8Nx1eC8NEGdtqook31dyXY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

VT-D requires PT_FEAT_DMA_INCOHERENT for the x86 page table as well,
implement the required SW bits and enable the feature.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/iommu_x86_64.c |  2 +-
 drivers/iommu/generic_pt/fmt/x86_64.h       | 27 +++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/fmt/iommu_x86_64.c b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
index 5c5960d871a32f..5472660c2d7156 100644
--- a/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
+++ b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
@@ -6,6 +6,6 @@
 #define PT_SUPPORTED_FEATURES                                  \
 	(BIT(PT_FEAT_SIGN_EXTEND) | BIT(PT_FEAT_FLUSH_RANGE) | \
 	 BIT(PT_FEAT_FLUSH_RANGE_NO_GAPS) |                    \
-	 BIT(PT_FEAT_X86_64_AMD_ENCRYPT_TABLES))
+	 BIT(PT_FEAT_X86_64_AMD_ENCRYPT_TABLES) | BIT(PT_FEAT_DMA_INCOHERENT))
 
 #include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
index 60f8bd6b164b54..0ebe77c6fda451 100644
--- a/drivers/iommu/generic_pt/fmt/x86_64.h
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -160,6 +160,33 @@ static inline void x86_64_pt_attr_from_entry(const struct pt_state *pts,
 }
 #define pt_attr_from_entry x86_64_pt_attr_from_entry
 
+static inline unsigned int x86_64_pt_max_sw_bit(struct pt_common *common)
+{
+	return 12;
+}
+#define pt_max_sw_bit x86_64_pt_max_sw_bit
+
+static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
+{
+	/* Bits marked Ignored/AVL in the specification */
+	switch (bitnr) {
+	case 0:
+		return BIT(9);
+	case 1:
+		return BIT(11);
+	case 2 ... 12:
+		return BIT_ULL((bitnr - 2) + 52);
+	/* Some bits in 8,6,4,3 are available in some entries */
+	default:
+		if (__builtin_constant_p(bitnr))
+			BUILD_BUG();
+		else
+			PT_WARN_ON(true);
+		return 0;
+	}
+}
+#define pt_sw_bit x86_64_pt_sw_bit
+
 /* --- iommu */
 #include <linux/generic_pt/iommu.h>
 #include <linux/iommu.h>
-- 
2.43.0

