Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A887267706;
	Fri, 14 Feb 2025 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552888; cv=fail; b=adeXgLiDy75tgzPCmBRTmW38hClViXbKlih1sECgTcIm8G73D7UEr5b3Eu8bndE7ecxwdV0UtTOhyWp2dFdNK/k+WaK7xX+nMRFQIqgG3WfsuXDLAhg8n/94kstpc1Df7yMZnRM4gLtfKL7FsrgCRRqJRCpJ61l0WqaPYse2Lmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552888; c=relaxed/simple;
	bh=cS/fQvQwp21uiRWTTCOlcqZtVvZAFcp+RQx7Cu4g7sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qeeP0oAkEAPG/pSG+VDdDMiXFiK7/kXh1VL45qaNHHq2wFqSP2AxrmwMb3P/04vFsTAcFc7fc1wx8rhAOiA7lIMtJO4YLFVcmlq6rvRp+SXfeDAy2yjaoECUiWl08AXNgQG9b1puvTNn8PaVoHnbM0SMWKMyO8mytP3S1SE4+bE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=seTskewT; arc=fail smtp.client-ip=40.107.100.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="seTskewT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DluILxajuu3lPGQtcjU/qJcV8EekKWJyL8veTRUKt38ZJiwiXIzrnnehZdiV2keTB1x+B01jDUGdElK4e6GpDBDMT+dnXKfDfVpYw+g3wuu29ocs+Jvvh/YLwZOw9kQekS5vUSybCST7u2FwgszLQWkBhr7IrXR7jKwHGV6YGeIwXRcIHxosxLIhh19S6SD6t738cxFbbQ4jC14WgjOxG/Kzup+rw34kjvMhj248OZelzw0MEmJdDbOguLxYE21QHKzmV1IYVnvjIgplMYJfU5H1H3EqQQanSDS7BL2y8c/Aj6UMJ8CJoBFMO2omyvPkmyBfewipgIEtKDsKM5f5Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGwJ3YgQukhYeal/8M+gwSQTj0rq/d0cUCKaozR2WFU=;
 b=S0L6yq0LrXAYoYm0w3ujdhqpHHY7f/K1amOR+9u4SbZPM8vhDSMGMBAKPuKeO+irRot2GmqOgE1KoBx+D5Rr6AL2wZzfE7PyabNFAFQodanuy+9gKl2p3IY/8GaKRk82OK5ajsrkfhxejMZagE/QPN+XVHj5PB58HK9aJiBmyYxVoGqTZWgIbt6Cjn/aKUY+1E8BIR7oK03io+x3XwKlNzIKJ93U0YnaCgIcWxqT8wBpiNBXBIbFREakk3ylDU+dsr3XpdVsfgXwk1wClDX44NfHayDYodQfyj91S1Zo8x2/1s28kA5W2y7LJKfo0tQSGhgIRA/4GOHLvMTpWPgiDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGwJ3YgQukhYeal/8M+gwSQTj0rq/d0cUCKaozR2WFU=;
 b=seTskewTT8Xon6p32laClSS7b4Vd5wIvcNpzKvpuz34eN7PbFzv2FbkuStqsRh3gxxrtkj/qZE7mMoVJ8snvMpwi06XeUs3XmvPchmmeFGrhmEYIXkhhQ+bmL7lvAiEB9jiB20rXh2L9lR9g4aMmzNc5zsnsewhgTQ/5M4/CF8JDUMlt06YYJlVGY1iy8e8XxpvYlQS1FYrqjU8o1Rph6DubM+eu2NUOgSjmWBQQO/rnAxj6YTPdN1ymr7i4EppHiUgP7uH35NjqqambrH5HmlUykmq2gsP5LH0gFzz7G2sm1ttbqCwu3Thqo5tyGuAox0QWRvliff/KgC5AuAsJbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.12; Fri, 14 Feb
 2025 17:07:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:07:59 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 01/23] iommu/terga: Do not use struct page as the handle for as->pd memory
Date: Fri, 14 Feb 2025 13:07:34 -0400
Message-ID: <1-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c30761f-b386-42ac-956b-08dd4d1a2142
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?noEc48lsYqrsW1P4Jhd74YooDIVJZWFAaYZoUj/6H0Td3H5R1JHDx5jacwGu?=
 =?us-ascii?Q?N6xVajmOzdc9yA3CyrJ/g5ACYlJ80vrF/cKg97A5wvNLKK3Gu6B2IBAwpLgf?=
 =?us-ascii?Q?SvulCm8bBJRcVrGVrdiM8dZcANV0pFf8j4tpaaI1iRGs/VtZ/YzqOm1Syqxu?=
 =?us-ascii?Q?3k5Hoyxxr3WGlBma9NYcuw/7X9sofFkVkt+Ud4OaBao6qm5GR3o3aFo9vDRU?=
 =?us-ascii?Q?TUAtnNxNMWNUn84DyKAm4NeTKg5286OHVm5MfYUvZS9JJSSSncAnlY/8XHki?=
 =?us-ascii?Q?p/4dPT049WYCEyCstn5HgmqGnGnnrsFzNko7yjLfA5RYYGvHhiAC3ta0dO67?=
 =?us-ascii?Q?9AXiEpUs3D9sl53ky7T3u2F2r3lQuZMG5pYVLztGtvsmESbPYJ0fP29kjZsg?=
 =?us-ascii?Q?8BQYaR+OSc5FZd1qfCXUkXLuPqYYbDBjScKgqL7vsCaNyKzurRr6zjxAEPlN?=
 =?us-ascii?Q?rC5CEUHwGv9qPQ2ccBdIJ2Uxqk1BjB/vLNiqHQBEiQg7mJCuSgyg6d5a+YDW?=
 =?us-ascii?Q?eF6HbE5TIrUFUJL5WCNci6uV/F+Y0VvnUrwDKYgAlpolEki4NRmmHPaDot0P?=
 =?us-ascii?Q?uWG7LWtigbkRdE4cNesK6zLLrjTEEh0/dIMtKGHqBNbgsnfDyAKb/nLWBkat?=
 =?us-ascii?Q?5S7bSZk7RP8myj/8p/7FfVC6t6epDM4hVy/ajXxZWj+c5E6eT2hjxSh36HOu?=
 =?us-ascii?Q?zpRcrlgPwzteeE3AGNFgcS9uXr+hBx/nMAPYVU/tX8939D2huiQkJiJQQWyy?=
 =?us-ascii?Q?Wv9F4LkV54m4mPBo0WkbZqbWrCrSjy5ucyVa7c1wYp8ZdmRystLtWvm5h4Gu?=
 =?us-ascii?Q?NDvOZ1ptMiIBO5+osva/fZsul4hw7lftAKs5057XJPHaf9YOTahn8YCXxmDB?=
 =?us-ascii?Q?XFtNO9Mod+vRDdqP8ZwCiM1xFaSX/m6qa2wWmnkr4y2H/09hwY8AEYoZSAMU?=
 =?us-ascii?Q?BCNQzXuHNohtqLlMN9Sde673e8bvoy3PI2StvLQ5IMhUuZcQU9/kmT3o/hkU?=
 =?us-ascii?Q?KBs0X5MuixHHBsfXJaXUOO50CnMA4E61u6ie+oWwqzAcl8LvTqK4WUZn0usL?=
 =?us-ascii?Q?gJ7lom76/WX6mxTxNrQwI2m/NfXwVPjmkPnyYVHx03+0BHTQtd/Y+2m9FWZb?=
 =?us-ascii?Q?x+Np5TGvIaB5C6iA1BejBJzNl6IBIGW5pZB+5ytMF3mlAYhSAwlen9ceYRpu?=
 =?us-ascii?Q?cqJ5F/b6B1I+xMqV38OnbVnSmbi4ft/HrNJ45ZEPiBUwfZ9Q6GihUL4ur1hZ?=
 =?us-ascii?Q?e40ZqgOUvuYddWgqcL8JSGd1bgJ/BSJxXKOYMYLHXPqngXXntIJvUfrFYhW9?=
 =?us-ascii?Q?r3GP9qyC+Z1hdANnCUbKNn15rpokcm9h/Onp8Tsfah2ZR7IpuiY8a/bt8QzQ?=
 =?us-ascii?Q?1NlFu0MJn90un5dLTC4Qvzsg9n/gLI4Z8in76XmTkbkdyimJSPo94O/FaDj0?=
 =?us-ascii?Q?t0c/1Hj089E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tqYecxMeCDRiMfag43aNiq2KkrznceXu0eurbdXR2Vp/7Q9OYTSaddaNHh0c?=
 =?us-ascii?Q?e/eUPfDWJOPPjCYY0XNIFN1Bjd5o62jusH6quQvhDP/FtN5dr3zn3QBw5pHJ?=
 =?us-ascii?Q?RFawhqWMCB1/VuHzsB6m7JZbNAKRCeUnEb20H07kMGAbSF6y4hZmmNiir26H?=
 =?us-ascii?Q?Hvx3HYNtcwiBYKPwUORJIzInG84/ybjz3XtPmisW418yKip0H0xg9NF3iBaU?=
 =?us-ascii?Q?g6NPwMk4fu5OZfIm5liaqnY1vJuXARUTt36Rv95TK24mO8eSuYVkdzusGuJN?=
 =?us-ascii?Q?nLQpW+ZY9tbbozah+rxk/mgucekgQn7Cb0cxQ+snij4Oo68cRn8vQf+BKX9N?=
 =?us-ascii?Q?dWwLZM90fhQvnhiL/kpwIC6VkToTlLZsGaKtbHr5iTevW7aZi4m6E1xOv/GX?=
 =?us-ascii?Q?bu3CM17vE1ARAvEdN6UI9ZLgWbVct2aurlVU2jAqoa+wDgFJXnLIR3YvFeV2?=
 =?us-ascii?Q?IT0r073ae5zVEgNYrzuEFx2+gaPO5ZaZIGLRtcOayLlhj/Hpdp9Wo7/tWvhH?=
 =?us-ascii?Q?EjUHrStKc4T4mpPxrj8usBb01uVMUKLdYAuUSf7VHpgN4LwU45cWZOUuYTcL?=
 =?us-ascii?Q?m4ymee19ozidmNvCbDOVwJ45aevRdAZtSyPK1QOpL5V8gM/2ulFN3SNRSh8v?=
 =?us-ascii?Q?ktCpAkQlXSTHK4DSIQGndCUNATKJE+FUzub+grYlSVXCwX/IwKSzPeuA4221?=
 =?us-ascii?Q?iBNOEoKSzsUzAtZ2mO1qke9ZHRWhflqezkh9qJTAx/sndFpEXYZlgpvVZe5/?=
 =?us-ascii?Q?kT0h/Tpqssm8OGLe/okYcAgUmwIy/TqEG/eX9uEIEz02iZ+FG2DJsqrqoeEH?=
 =?us-ascii?Q?JQ00Egu7vxa5FoGOpaIFKLzIW+dQgFmbnGoCoQc77rbpfU+6cpUSysGPxrTM?=
 =?us-ascii?Q?8A1CmsvStYM+2Hr7CM/0yP1VF/+Fiew1etSzlMJg28LmNIdUegYLVXEdmwhE?=
 =?us-ascii?Q?DUx3knhhrrnmdvn0jJJjxA7G562Z+Spfd+h0GPTBJYMYF09ebA3n/8u3Zp56?=
 =?us-ascii?Q?Dk8HMK9S/C6UWnyim+rYx2TEiXfiv9ofDcVSprmuJ5HcS38Qd8zfoRUQhTvq?=
 =?us-ascii?Q?lNoeB7W1RO0mIZdBY+yRi6LFeKx9/6vhVEDMw9BlEnx8w5wc+qQrVOY1Jw83?=
 =?us-ascii?Q?ppeKW/z1iG3M/c0RDK1UqgsZR99G0eoPDVL7Dl35IneziTiDdnmXQHhPRoMk?=
 =?us-ascii?Q?wLF4bge43k3RrZh2lLry93zvGoWlc7XZmNBsz9W6er/NjYWjNwTlphk/Gw6u?=
 =?us-ascii?Q?CG+kCh3xsH7daDEeoBLDiNQf2i0M3hgN7ERUQO8Iaa+JmOPlHSkal0qWlpbS?=
 =?us-ascii?Q?6b3So6ncj0FcLJ+UcZrEoz6Ba3u9kpkY1NDc3J7s/mqzQel6I/qyGJv429rP?=
 =?us-ascii?Q?NxGyblcB6qa5cKREtyvlEvvFaS2sBk2xK4Ut1qt1rnxozSOYeWgVP9aDm1KA?=
 =?us-ascii?Q?0or3Wls08LUhnsPk9NH+r+Np0pdCi63xMZAfBFAgpTqGSSx0onQrXUudXywM?=
 =?us-ascii?Q?9+X6m/Mzh/h1Oi3z6Iw9xYCdgY3QnPMYcYg0cjrQk2NUfOl3HLoqPSv6gtAY?=
 =?us-ascii?Q?95ICOff2cX/OGFGB8Myzpf1b4avrR3CYQCwKkbzK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c30761f-b386-42ac-956b-08dd4d1a2142
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:58.1252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/Qes4V9dT5MN/EAI4dygzauWPgpccm7HPCIx2lSde133myYve9Crr8L3Kj7sv9h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768

Instead use the virtual address. Change from dma_map_page() to
dma_map_single() which works directly on a KVA. Add a type for the pd
table level for clarity.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 7f633bb5efef16..b6e61f5c0861b0 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -51,6 +51,8 @@ struct tegra_smmu {
 	struct iommu_device iommu;	/* IOMMU Core code handle */
 };
 
+struct tegra_pd;
+
 struct tegra_smmu_as {
 	struct iommu_domain domain;
 	struct tegra_smmu *smmu;
@@ -58,7 +60,7 @@ struct tegra_smmu_as {
 	spinlock_t lock;
 	u32 *count;
 	struct page **pts;
-	struct page *pd;
+	struct tegra_pd *pd;
 	dma_addr_t pd_dma;
 	unsigned id;
 	u32 attr;
@@ -155,6 +157,10 @@ static inline u32 smmu_readl(struct tegra_smmu *smmu, unsigned long offset)
 #define SMMU_PDE_ATTR		(SMMU_PDE_READABLE | SMMU_PDE_WRITABLE | \
 				 SMMU_PDE_NONSECURE)
 
+struct tegra_pd {
+	u32 val[SMMU_NUM_PDE];
+};
+
 static unsigned int iova_pd_index(unsigned long iova)
 {
 	return (iova >> SMMU_PDE_SHIFT) & (SMMU_NUM_PDE - 1);
@@ -284,7 +290,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->attr = SMMU_PD_READABLE | SMMU_PD_WRITABLE | SMMU_PD_NONSECURE;
 
-	as->pd = __iommu_alloc_pages(GFP_KERNEL | __GFP_DMA, 0);
+	as->pd = iommu_alloc_page(GFP_KERNEL | __GFP_DMA);
 	if (!as->pd) {
 		kfree(as);
 		return NULL;
@@ -292,7 +298,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->count = kcalloc(SMMU_NUM_PDE, sizeof(u32), GFP_KERNEL);
 	if (!as->count) {
-		__iommu_free_pages(as->pd, 0);
+		iommu_free_page(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -300,7 +306,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 	as->pts = kcalloc(SMMU_NUM_PDE, sizeof(*as->pts), GFP_KERNEL);
 	if (!as->pts) {
 		kfree(as->count);
-		__iommu_free_pages(as->pd, 0);
+		iommu_free_page(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -417,8 +423,8 @@ static int tegra_smmu_as_prepare(struct tegra_smmu *smmu,
 		goto unlock;
 	}
 
-	as->pd_dma = dma_map_page(smmu->dev, as->pd, 0, SMMU_SIZE_PD,
-				  DMA_TO_DEVICE);
+	as->pd_dma =
+		dma_map_single(smmu->dev, as->pd, SMMU_SIZE_PD, DMA_TO_DEVICE);
 	if (dma_mapping_error(smmu->dev, as->pd_dma)) {
 		err = -ENOMEM;
 		goto unlock;
@@ -450,7 +456,7 @@ static int tegra_smmu_as_prepare(struct tegra_smmu *smmu,
 	return 0;
 
 err_unmap:
-	dma_unmap_page(smmu->dev, as->pd_dma, SMMU_SIZE_PD, DMA_TO_DEVICE);
+	dma_unmap_single(smmu->dev, as->pd_dma, SMMU_SIZE_PD, DMA_TO_DEVICE);
 unlock:
 	mutex_unlock(&smmu->lock);
 
@@ -469,7 +475,7 @@ static void tegra_smmu_as_unprepare(struct tegra_smmu *smmu,
 
 	tegra_smmu_free_asid(smmu, as->id);
 
-	dma_unmap_page(smmu->dev, as->pd_dma, SMMU_SIZE_PD, DMA_TO_DEVICE);
+	dma_unmap_single(smmu->dev, as->pd_dma, SMMU_SIZE_PD, DMA_TO_DEVICE);
 
 	as->smmu = NULL;
 
@@ -548,11 +554,11 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
 {
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
-	u32 *pd = page_address(as->pd);
+	struct tegra_pd *pd = as->pd;
 	unsigned long offset = pd_index * sizeof(*pd);
 
 	/* Set the page directory entry first */
-	pd[pd_index] = value;
+	pd->val[pd_index] = value;
 
 	/* The flush the page directory entry from caches */
 	dma_sync_single_range_for_device(smmu->dev, as->pd_dma, offset,
@@ -577,14 +583,12 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
 	struct page *pt_page;
-	u32 *pd;
 
 	pt_page = as->pts[pd_index];
 	if (!pt_page)
 		return NULL;
 
-	pd = page_address(as->pd);
-	*dmap = smmu_pde_to_dma(smmu, pd[pd_index]);
+	*dmap = smmu_pde_to_dma(smmu, as->pd->val[pd_index]);
 
 	return tegra_smmu_pte_offset(pt_page, iova);
 }
@@ -619,9 +623,7 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 
 		*dmap = dma;
 	} else {
-		u32 *pd = page_address(as->pd);
-
-		*dmap = smmu_pde_to_dma(smmu, pd[pde]);
+		*dmap = smmu_pde_to_dma(smmu, as->pd->val[pde]);
 	}
 
 	return tegra_smmu_pte_offset(as->pts[pde], iova);
@@ -645,8 +647,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 	 */
 	if (--as->count[pde] == 0) {
 		struct tegra_smmu *smmu = as->smmu;
-		u32 *pd = page_address(as->pd);
-		dma_addr_t pte_dma = smmu_pde_to_dma(smmu, pd[pde]);
+		dma_addr_t pte_dma = smmu_pde_to_dma(smmu, as->pd->val[pde]);
 
 		tegra_smmu_set_pde(as, iova, 0);
 
-- 
2.43.0

