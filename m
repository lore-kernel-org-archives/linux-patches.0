Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE0822FF32;
	Tue,  8 Apr 2025 16:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131261; cv=fail; b=uDqccSCgTO3X8AEloRKb+a7GrN9MDS8+xG7q4cmh9jKFhegbuL6wt8qR1UH2zZ4mDO9iWvcP1NVdvjnhhflLKS/6tJc2lQH2S3DyCuc37nN11gc/jv8cnHyZKNDYbWe6kxF112/C0cS92LLLv+vz/frjdAEBxOtmRMD6G0ZhjTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131261; c=relaxed/simple;
	bh=Pj98uWU8/aBqFXLf6U44nb4QAic+SncYWee6K+ipXdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SSXlfg6Iwwdwuhl0TRTTkcBS4ZMYbaq8FUUvHp0Na14vZwBqK3NcR3EkarP+LT9tfxaZDDRWjGeJYwiJQfX3ktlQs6d1lgpxVkKh7raOCZKVO7U2uCg13GoOPteeh7ZCLaSG7gUsd0oNfNEe3eha8ut+KSTR+MfBVoF+JykAqzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b6iAFueF; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b6iAFueF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gtmq+2JsOF+d90CuS1KP+gOHv3TpTDDmb2ggsdBuH1jO0PFyiNCnR/Ca7SK0r9SQHsqgIrwqmsCN90davKl6WjVhClEUdAafqtQZcKBFiVm21gd4oILkbqd76FJs32MiiL9QJMksxLpVFlvlRe9BgvoeCm6CSShfXr1GWb0Ggs03ltK7XCvanG7zPSS/diI/VP10s4CH7zEo+QTAlqSplb+RAV+IgzJHE4j9Ewq6pJ+1+r5J/mL5fdxu+XfsaZYscs9cA+ZdPYx6sOxW3+IAShrBQvv1M98DCETMQD0rygBzU3peoB6ZeaGa+q028lgzcPr1PyWwj7scwLiJgXCWJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8Sx4u+V1hmtNT/5wI7YFShWV6OQmD25KxCjs0xg2Ck=;
 b=bMRPS7CCVLPIvSUJsis9VUbHLfpigjEmOrscwrqpoDXeDOY2yQrtZRSPxXVlh6VePLPyXxT7Plc7j41/+9XlcB6ptn3Q0/3OSBYb6uxe5R3NC3IFT2KAxsilIsSri/JiYA8cln6RIgsVNi7aFjbgPVx/u5VjprlnRWDZqOElNWaxT42hIPYKvfITMtvn+AWOWMdzlkwiw38H6/4kiFKdlbbR/BXkvRpuh3zNI9m1zmqlNyBHCJ4xFA77VKX9N7yemx3y2OuXtJw5lVJQ7jJHlRq3vDybBpVaSXq1i/0UNQlxZswWbyBF5iAjAJ3Kd02rrdv3Sb5JXi+fSBp+axTPiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8Sx4u+V1hmtNT/5wI7YFShWV6OQmD25KxCjs0xg2Ck=;
 b=b6iAFueFTvKBap3K3qfZNZ9jQiEf2h2tpAPstxTfeHc7ewJvqvvC0rxUhS7mRgf6tOQziXJSuR7YB61b2gx43kHX5jvIImvjqBsCf7K/2kYatR2SQxDYnuA0FuohpVB0aGNg9+cX1qmDIhqEUIHit09QSmC38zuaqSsv+heHF9ZBENB7vmcirw0hVLAlsN2dugNlx/4qz12pNHx4wO3pJ4jqtv2/3VXsxGKfeRbmGH1Cbg56wRAWwfeRxVA/XrvrEPn4tvFiibFL14G4kL0lI712zxolLVx8IECT+4C+rhcG7Ud8CncyjRt7uZBMtbrjFgB752HJlck3uWuNwkOSUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:14 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:14 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
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
	Neal Gompa <neal@gompa.dev>,
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
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 01/23] iommu/terga: Do not use struct page as the handle for as->pd memory
Date: Tue,  8 Apr 2025 13:53:49 -0300
Message-ID: <1-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:208:32d::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 2465f73e-60ce-423f-8654-08dd76bdfd83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qt7zIo5lfqz4sbprk+J14DHhiwjq0LRxE+TDV5Gkj4TLkNxQ7trM+PyZcf4a?=
 =?us-ascii?Q?SFrFYCrhVIjPMguz7VzmlrYmtAJkSOjqHIW80nVvqJDobTakUg8RiH3EGLF1?=
 =?us-ascii?Q?yxCDmFX2gDmqO8cXnjvbQmMD+32tgrWo+1i16UI4aLoK6BrvEPCB86UZ/nhu?=
 =?us-ascii?Q?4J5Gxn6xkB/nUN/+oywkxHBrA9Iu8mfCL4fA0gDi+lI/XZKI+LEh7EJahYyo?=
 =?us-ascii?Q?x5CUpH0TvpE54ra6QvvJoAvEFya+F+Q3uWckkMqAxBJs84x4p1qk6QArWezT?=
 =?us-ascii?Q?JVRwqZYFJ9n5dzzOO2KUtixDQPEeBmRtNDPhgBfnOPbZO/w7Nhg/5ZW9T0hC?=
 =?us-ascii?Q?DWTdo4k8qtOM8T+HmoxxWeL4QSt/MVF+qBVUdDG7V4oBLFK1oHWrbKDMFX8y?=
 =?us-ascii?Q?OB0JPhScWNA6I4KS/6xeWOOsW2DKrTlWy366GMpuCu8cMGnepKiWytKPYfS9?=
 =?us-ascii?Q?L/xrKsp6ZdbbSNiV+s4lrKNCLyOCr16El/xJyt98VNLHcLND+JzQDchYSZlL?=
 =?us-ascii?Q?ftsSS8yhsYAC2DFi11EoGiyjrlIzXN8nN976FSnEfWuTqQsKLGc9W5eKFcDT?=
 =?us-ascii?Q?uqqMt5c7gQi9ofpUF2s0u7PQNnBqFKdtb1LZ6DUN47cKMpuBzJ/nh9ReV9Kf?=
 =?us-ascii?Q?OMzm75+lbR0Cz3p/uMUMeEemBU8e+/+wY3oo+QWceKZ06b+j2TRRDVliV04S?=
 =?us-ascii?Q?BvmuVeyxwtkTb30ypimrTA7eldgSu9cH2FJN3BWnlFbXGehnPgIis25k3Z9H?=
 =?us-ascii?Q?4z9jOazA6Bg7ZGZdZMQFtP3kw2ymucPEVlvO86UTg4x70SGQgrfc+/UY4oUR?=
 =?us-ascii?Q?J/zwhJ94jybCZkfgOX//+a9e3EwJE+fdDUAmdkj0zYEO+pVDFvRBLzeS8od6?=
 =?us-ascii?Q?/oTMb5hUGQPDcTUTPlFjTM5r8hXUHQt3Wc+CdZbK8PjLY7stzX80ORJzoS3N?=
 =?us-ascii?Q?GGsJXCOWeZsLCa39hQtmPqHgvZcidaCsvWJiaAtWlXyXH4PxFp6CddIKkMdY?=
 =?us-ascii?Q?gQ3otaKYjUgyB50xHnY2VoJsSIUr3xkpYDUZME2vyjHMqBH9/7oQ6LeKei5G?=
 =?us-ascii?Q?FIrNU/Otx3lbMnPaiJddc+Ib5/+u9oK1r+d6IpLI8N9G5q6cR2sg2AOGfCVH?=
 =?us-ascii?Q?MorbLUbOOYhW4XSpDtxNopU5DLLGpnIkeo84qDPD2oWkpLPy70LNe47WO9+q?=
 =?us-ascii?Q?TV8UOiJLZjqSj8Sc5jU+56oNHMxFWpMi+2IWkg0mf2dLrBH33mmZ3sfyi80f?=
 =?us-ascii?Q?c5KIne1S5Z9CrfSYa47/W54idB8KY3nRUlCaIjlguMVD4zWZ2nSliHvxQtzo?=
 =?us-ascii?Q?K6DGyQPFpgi4foo5xopn9W+oPwLBvmXOe3LNSYnG8IKYya6oRIHzrn1YTSaw?=
 =?us-ascii?Q?fo+l+XyTD14pkgwH0tJyVoZOYar3FkcAWON0rluc7WhDtE0yvtXBPdlrT1Tq?=
 =?us-ascii?Q?pRHgLS0KyWwT5CyKZk+bl64Rnjel6kee+YA/qJGuCSs9Cz3DJh81+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wDjEcW406VLo2KuB2eh1LB4u4JjbEwhGVTfbQ4Q4XGU4szMcZVTkktSBd8pK?=
 =?us-ascii?Q?xe+53CtOXSFBk04Ro/Ep1T7hRD9OEashpJqwcOJ5ZkQnKLJXwLHOpRQY79zJ?=
 =?us-ascii?Q?Q2LmIhe5LHhHWMVmMp60+GS4D4nGfhQnhpZA7KbxY9G2eF7LNxfkPGBw2Kqs?=
 =?us-ascii?Q?CRt2j/+XsOCNu+nlquGtFfigEEaevVFYOTqqSVCesr1mj152xk8yFfsbu0w3?=
 =?us-ascii?Q?R5oTRukJeKaaOcnwOj2ScwJzsrr7opNvx1E1upDpXhf0J6MTdvoXeS4XcRfS?=
 =?us-ascii?Q?JSuvGtWzviqbuqMhLxqchvsmcgZg3K01YFHInWRzVueDxpYRGQln7zHvFcjt?=
 =?us-ascii?Q?mcGyVODx7gYITYrUbdwWp+SJ+9iuAACfuammr119rYivv1R6LuosP4+cC7d8?=
 =?us-ascii?Q?xtOmCXRHndoJYl+L8TPqkzBell758EHAdYmU0SdffvLmm2bOp/1qOjVD3doX?=
 =?us-ascii?Q?UiZrjXAPcyzghDQH/62gxStEpNXNzbQe4/Ijit5lFjySjXT0m95gdXAwqtaf?=
 =?us-ascii?Q?POcG0cWCBfMITClLDgQs8dxHIQC24kqsjOKDn8/v+wDYMtHoMkZSYvOmRTlt?=
 =?us-ascii?Q?JHmOf/MgQsADBRFaxAIIyjfdU/HNFgzTkAPKruyD09mQtKYqffIQCkTaak53?=
 =?us-ascii?Q?RSWLd2eqLhM5kR9bvAPv80ipzk6gRJ/hHarP4HvR/0/1iW9HP/9znjhlIMOr?=
 =?us-ascii?Q?kbL/71BeEJeFF0rZIZnG3jtJGjASHWcsEY5Q/Ux4EXNuJZu+jqWdj9trH6nm?=
 =?us-ascii?Q?QD5/rVzJBGwW//8pIT4IC1imUmfFMjGoV01es0xPWpnJ+tpExFRnEAQgFi0K?=
 =?us-ascii?Q?duQYYNtY3OOLsYrfc1/yhulLqqiXxYHoNVzctzCMbnoOm6X+oFw8L8144iWq?=
 =?us-ascii?Q?ewVae6nxTW40wPo0FoO0jlt8HPynbe3PxbZ57mQ0kZDyKxGH73Nxvul1sJo2?=
 =?us-ascii?Q?XDt+zqdqSy8jqxpuTFMUykYo0pBMtmbAz5rg2h8HVeoMoe5PigMqu4fDSXbQ?=
 =?us-ascii?Q?dEdvi5MEpv3JFTH/JnJJS6ZgbnxY9IVBeYLnLduXC3UY+21sHBAX81mvauSS?=
 =?us-ascii?Q?qVTxEF34aRMXu3MgLg5/IS6h+0qEAELbmHnAdgpBJm9IyWvCVz/gAFiuGGns?=
 =?us-ascii?Q?jIxQtVfXTtMlmVIbjbwKXjALNC/E0MVibs7RgcA0eGlxEgs2KgjV0KQZpHFl?=
 =?us-ascii?Q?5H/8ESNQAvL23zA+5LZESs9zIe97XO0kisacizilJAq3cdO/AVcq/lgxBiEP?=
 =?us-ascii?Q?FWHt0zhGceKhhdB+csT8s3TD9h+ZpJlYEd6v3sj2LyFZzGeqjcakcWjAe/6E?=
 =?us-ascii?Q?jv181bsUBvgRdbBRNy/DTe/v4gkgErk1pW7xU/oQNTFz2CnM48aSlYIuUgst?=
 =?us-ascii?Q?KJ80sUb57DXoOhtuadUsDUnN9eM6+KaSedYBz3mbQjeFQjrA+Nb0dCrB5dUT?=
 =?us-ascii?Q?+EEKVFe6F2ftUgrz9R9xdIPZJ0oMQLCceHZheyzPjxfd8tl/ndzZy+b1s4mN?=
 =?us-ascii?Q?tXPkVjBgiiX0nuLpH831KbA4kSYaLxQnPK78hvW8PVAA0Rlhbr/kNQnlWM87?=
 =?us-ascii?Q?EGy/LldvyXHWCJdiebxqA+yfmUFFZ3YE+QipKfvU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2465f73e-60ce-423f-8654-08dd76bdfd83
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:13.4155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VLkCWqcRCZNj+yyZS6y64MhXyc0hyHmlOejSduq9M6zpuQWbw4/oUwRbr4VJdfQg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

Instead use the virtual address. Change from dma_map_page() to
dma_map_single() which works directly on a KVA. Add a type for the pd
table level for clarity.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 69d353e1df8439..d040400ee34ac7 100644
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

