Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C63913BE92;
	Tue,  6 Feb 2024 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232405; cv=fail; b=c61JPBvNHiDDLQfEqgE6EFMN/yH9e3tEE1MfsJ7l136YVvl0v+IXYDZBTUhLvLUlT2hlbMzAja10TllEY3SNpBLVuwtFN+Ucdz8EJeFUlZtnmIEGGFR14B6ww64Cl3XnicQ3+Iep8AWh0IL6Fqa2jPdMLEGjg/kfkTuqF00vFH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232405; c=relaxed/simple;
	bh=PD6qyuUGBVzQIG3wup9zNsF7Idxaj66qiyakMk7iIoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ekzvv7iJPJ4qaQx2U1MOuNMz+pxlRzDPCk/NbNDFDyBTNEWLRTUlZl6yFo9ZgyLutCXDyo3zxedP7WuymS3cQD73Y+9LujwMaYXqUM1SstFMKhvysKcMKDT71ceGbuVlarYPhJ1oQZuLE4lyoik1Jn8jyHOTrw9zjeOQikRHB+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k9as0WuO; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k9as0WuO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G34fjJSpQ0kduLsXZJ5c84oZvNJXqsRDxdjbLNpynr1tYApV/0zGTCB+Smkn/L4wGLLB7lCuY9ZEz6/CtaxnYWXgltYvGPUTo7GNmjC0JS4qWFrJXQlmRcibUv/ZRKj1/i5tSnIPqYwnWzhWX2Oe4TYXW8cJH5311yuadm2eQrJw1K1/kF03D9ug+k3lWg5Sc5tPIn6SmM4aq5N2Vlc1e4DJqSF7WGubIuyjuwG5NeUhyAGevDfwnK/D4ylE2+AONEzz61tZtsHskJVgsZTqo45tbf9ovzwXmk4kEbVo8c/iZKJSkNH+4usyUjxmeO4ZczYGSXXIWm0NSK2TR1QJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+Dk12EO8hDjmK2ptvYw0ZTw5jV4QwOm9fbHYW3yr6I=;
 b=oR2p/PWEQ9XcEBCPrp5CEzPQEAspYwRTWXcOUOgMgc5pJp5p3xfOmRFA/GALVu+xsaEBFFo4nuyZ84f4C9iNRoCgOHYI0dTvpiACH9aaGnXCe0VtfGVzPVvBVMbtMbDJRQin1BL7ias0OwB48JIiCuiUu2n2yVyxXarrfhGUJ1k8/n3b83cNDemyHCWuYgEz1HzKIHUOTXmV61vhpsm4vKNciH8INOCU4DL7lgiWGQzL8i0NQre8/VChetGw/WOkFCnMzwNuSO1hiv6QMwYiQ+VsIwkhGrzICJahMWXJHHdLM9bqjz5I1VLWo7UueQ+JbqpJq3pCn9Vw0Nb7+ZQSIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+Dk12EO8hDjmK2ptvYw0ZTw5jV4QwOm9fbHYW3yr6I=;
 b=k9as0WuOqCFotxgbT6s+H0BbHNODDZgBl0xvlpQgTm+T74rqQdDhdm1IfJXLRst3/NBKgFJhOtiXK1Ukjo9FwlVjo7yU5PDxsIv3ak6XAJ0AejIKvsGX9kdwI/cn0caMJvLPz17oou0CEWLQgzv8ik8tIOlQN7Aeax1qEtVVDuY5ALvi/mNcLwhsueKflce5U828CnYNYjlBnooqFB+FuA02AkqpkgT/pRC6KCqR06QQ6psRoGwshNqBmTguy39aCWe3bmBqg6jnm0Lec3CMJBYwedGWI1FUIVoJXcSGQWjPJlqNL2/wlSH2JAQfNHsAEsfSGIH6xM4+87dR0Honlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:08 +0000
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
Subject: [PATCH v5 03/17] iommu/arm-smmu-v3: Move arm_smmu_rmr_install_bypass_ste()
Date: Tue,  6 Feb 2024 11:12:40 -0400
Message-ID: <3-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:208:160::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: de6da36d-4e02-4fec-7bed-08dc272619f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jGf6wn1ME46N0JSoZSEtfWdSUJ6+Ur+wUvdOh4qzSOxyysVMlD/xZqJRr7KJ7nuV/n1o5DZEWaOu9cyJqVpwnsCmEFHI0C80YvbMcUa7icNRrVIt7ywzGQ+9aCJlbH4jtPlyefpLTqu02Wbfv3xCHMie+0jDI7K2ieLtfivPJvittUTqPf4Y2luvnsG7Q/PSx37oHoFRBQ+FuVnYgFXp5uGSV3AZxrKmBwapAEmt/RHjMhcF825/NIzkKmEJu2zB9q8fMGZYOOW0XloicdK0A7INEetgHs8uyNAnz9dC35Ph7rKf633btX1slKzrlvcWsyFn5DRdWs3FbwtHK2Zxc7iVyTfUAWAQU3bgjiHDGHtR+923d7Lkh/MSVggdomwQXnRjJBG7lw69LZcBfY4A2Y/ybgz2saENXsLs0HPF0LlWpQWLhOOslI5DZWkd04N3Zd2b+rH+ubDkuqbopWDnBPrK9DInZAnre1onju/GEZ6ZJcQwleRRHyUfk4/7rajQ5/myiog1zwstAhxgX67FqEd/xk9CLmipdCfm3uyNs/qn6AGcN09VTEhPbUIMjG8LJRZaOAxWcz8vE34Y3DDNyNSuLjO2uDJbLW6K1bhM7KE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CZnadTZy/exl7cjmSNwDRV0EjLlHvdpxOyW0GncN9GUeEMvg4tMaY0f+ZJxZ?=
 =?us-ascii?Q?W0MKTJ7BQdxpCL4QccH1jTSnrz2qnq2aDBBOweY1QpI/W2T+r5k3yWT1Bl3P?=
 =?us-ascii?Q?Ih6GPoHPFqRN97vvBDnYTDkaRmznsRcjrWUVFmkcRV5axCEiP2IUPq8830sM?=
 =?us-ascii?Q?tNIOv5z5xt/jBnj02VfLSad5kIdyL44BK8g4tSEPrBJDMqqFfc98z5w91IdW?=
 =?us-ascii?Q?E2S1PqrOgg9V82dRrHjJQanjgB5P4gvtYqVwwoCZqHqCQZd43oau+55G5EE+?=
 =?us-ascii?Q?CUwKh7BsWyM3wEZBAjaB4L1KCwxYB6wzcVtGBfYX5ePIIUyWEVD/vK6+BGXw?=
 =?us-ascii?Q?eZBiOXxwUgoiUIft1ZDxjvrcETZTf0A1oFqfSZrmp/8Pkm4y3dr0ES7XFV7t?=
 =?us-ascii?Q?6yBbfyts7WuhJJOjS77jdLKvyu00VsfvHN8MhccgqX5MNM24TWlMclOnfsEu?=
 =?us-ascii?Q?j+6gknVMjcTDkpUKBBb7cufCcvvxKXvEoToV5xAOCzI8YReBnEdE7cLYmZKP?=
 =?us-ascii?Q?iBF+1OKnZeFV0wN4iVJEXxisoPsTbmpWH6eekK6FF4NL8aEGKKQH+IlTJhyt?=
 =?us-ascii?Q?qQHIZJ3P2/WeFi4vlJE8wjsooJMzVp2Rba8FC0SZVi9HAWC6sJQhaEdBlZWu?=
 =?us-ascii?Q?/pwhjYClO7vnk6P94kSEwkr6jb0sp5tP4dvIdbqAIdFdrlRHja+X9jYoCr9Z?=
 =?us-ascii?Q?cXbLBFxkFYjYmBTp8NcozdnqNxFvYbIPqYieJi37EUuDNzb4jg+/Ds/dFGNA?=
 =?us-ascii?Q?+YXSppmlhOm2svXFe6zTOSs0VzWgb5uVy32NMTybNoh1On65KN3e0lTDYlwt?=
 =?us-ascii?Q?JRcK01FYqHE8E9P95Cq3Qy80Z8KoDf33suF3v7GnOmvmvegIJSRIWQcf9LHC?=
 =?us-ascii?Q?PWLzA56EmL2u0pEqF5OhrJW8Fn7qhh0/iGRRjPpH+jhasBDEq18nDolgga72?=
 =?us-ascii?Q?bg3/CVI2SDPtNa+X4ergQK6AyoumDHA71C9xC7HdWQbTEF9z3IeYoYXty5QT?=
 =?us-ascii?Q?L3OLL/KaslPtvasgjs1Yi46r4ENClvbTXAeb3lkKU4B+CMjMVNKTK4OCuJld?=
 =?us-ascii?Q?xnIbw93Lt/RLlmj+uRw1TRfQKdxZ4Yj3Y2xEnSbQCoOhlKjyo+yoTOUBL+dK?=
 =?us-ascii?Q?8yQQPduVJv5DUaFJ4EFD7BOg/DbWMELJwl12/hNU/7mX48Fh6F8iuvfod/Y0?=
 =?us-ascii?Q?v9xmdJ0IZT2LLDUQKnER8wsqdxvZvoaqmDlKcMyIZ8jaEqZsYiP9FpLo56ZW?=
 =?us-ascii?Q?LgsPyr6rWD9nSmA4sU/2Tj4AJvTnzq8o0suYYw8UMzF/aytaXgFVpKDchiN6?=
 =?us-ascii?Q?OhsPBb4q9cZZUnWu+sTKbmMR3YoyXBzGsB4otE6D06aj6cL+uCc7V69D48zc?=
 =?us-ascii?Q?dlOJHqvp39tpZsGlZvCKTH37TwEnsnOzzbecMzqSSOB+iMuOi/o9uEsVwu2+?=
 =?us-ascii?Q?z+/UNjHBBIbEKKLZ6qDd+OMP2D2Sh2+EtIHF3wWCSOYy3n8bcQZW8bzUD76w?=
 =?us-ascii?Q?RQcPXxb1ph+RUx5uOLHPSSWwYYqcycdgpgmOoybTP00CmRBePNu2UbaeUQGr?=
 =?us-ascii?Q?QOPYX0wzmFv2eMOYBmKE8u/Z5dCPwTRG8rG5lRS0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de6da36d-4e02-4fec-7bed-08dc272619f9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:57.9205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NE7wcQEcB678n/y93kiI5Fc2L3lHYaT2F6CpZHqG4EOCtNZ4sjOxo94yy9s0/hmw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

Logically arm_smmu_init_strtab() is the function that allocates and
populates the stream table with the initial value of the STEs. After this
function returns the stream table should be fully ready.

arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to force
any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
ensures there is no disruption to the identity mapping during boot.

Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab(), it
already executes immediately after arm_smmu_init_strtab().

No functional change intended.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6123e5ad95822c..2ab36dcf7c61f5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -101,6 +101,8 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ 0, NULL},
 };
 
+static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
+
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
 	int i = 0;
@@ -3256,6 +3258,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	cfg->strtab_base_cfg = reg;
 
 	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
+
 	return 0;
 }
 
@@ -3279,6 +3282,8 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 
 	ida_init(&smmu->vmid_map);
 
+	/* Check for RMRs and install bypass STEs if any */
+	arm_smmu_rmr_install_bypass_ste(smmu);
 	return 0;
 }
 
@@ -4073,9 +4078,6 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
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

