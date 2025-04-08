Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851111BCA07;
	Tue,  8 Apr 2025 16:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130159; cv=fail; b=gV4N6mxAMkWQxorJdxnqqMngQ1Nu/qbQw5cxeNnHAIo03hb5kh8+cU+wUYDcr1q7WMr6rHonlEg6cVYDzpKwGGdunQOB/4icrwoGZbEgN6a26PkiGEhMUqPcJC1i+g/Q1JUYW78kiItj9+U8mjDaF6HaGWNDbUqsudasAp/4kGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130159; c=relaxed/simple;
	bh=TsgkbrtmCbagJW73fre2blpnLF9DtHm/ozDzDF2fE7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VZ8HDkRVGB0qcitS8QcX9OnJRKh/LcOp2JYzRJC/2xr53ly0x8pk4B9GKAUJ2j5RbzYPdw1abeJnVqbZJS0jG5fCqCtIi1yChy1DlcYmoAbN6P64Olcw0is8nXLAGos1vCzcAk6UNq7seWtCGcUS4Xty9NCRSNl7nzBaokxqtkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Fu9LI63V; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Fu9LI63V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpycvEBzOA4EizdfrwG8uwPeWpydf9WIe9SVNeHkH0jN0e8b5rEn2yeA2NlAGBsVYH7TFJe0uo0z8+LgGc8qYusOBGAac51ZKGmfVvpF1yKy5IUvrGhNZSI+cdBkPY8385YgvXI4cKFsP5x4apTldBi2k4JxFZ7mthjL6KlRw4iS3MIHimK+oYjb1AskOWcMPIWeHIq6UMzibXFrEwWOBqVtNSKw8P91Sif5xAwDCrBfAuxNHjZcx5P+8vXvEyXxL9XnexcR8tpiAMPszmNKc4URLvbZjt3hr5JAk0PP0xvUSrR8k3dcNL5JbsAHbV55N2meABAOeNb0YQqlG18Jhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sG8aprM1EJfeaQsQXIBu2eoceiQlnBXf+Xdq6lNqQQ=;
 b=dXD6iDdObvMKgyXhlViU7VkhwhgswaAyGmU0CaaeOsJkDteyfBSUN7++qxfhd8ianXcAjAkJo/rULDwTw2G2n2A/Mx1vu4wgh8mwpDQgn2J6wBzRZR89YOe0Igitepak+HwCDAw4BVaMtXahGnVNnejLgT2/TXcGjmSODYDILAGyPTgiYe713apD829sOOCEYNDcwI2ePdMK3nm5Wlrz5NNGmK35UXFKxI/jpVGRZ4pHKvcg1qAxOcagTsXtrrZL8maYiXRMZ7ychdMMk6xxTjQPs/wYNxk2H/2bky7r9ijMVVaWb7lPI+wnJib3SUkZkZaq+hn0/2xVFiQHdPSpsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sG8aprM1EJfeaQsQXIBu2eoceiQlnBXf+Xdq6lNqQQ=;
 b=Fu9LI63V8EJfOPYcVbjKgvZr4tF7TXGu59T10jaVmNJlMGY73Uu6a4JmvUuEmuCE4a+/x91inhY4LeDfxUTCbeGexuAuP9pvWZhSFo4iV0gtki2kJ5ltBhW2gPFv8V7OCnLDKSNvUjlVPGMKVcICbIz1SU/m1Fo8gOGnhsbY3VqbGTtgwu3FlxN1FOcwDo/48m2WOQhKWaiN56DDymfUXcXLz87+QYc0VGzXOl8aLr8mj+jOAIbslRyeDMWKUYZnPE93RuGLWBMSEF6YyXLtOKoQ+h7mn/LL8Q+6AZjMU1pCo/9/Li3/QFcvkq2FvSQv0zi0LU1KBbbghDzmAB4gJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB8001.namprd12.prod.outlook.com (2603:10b6:806:340::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:35:54 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:35:54 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	patches@lists.linux.dev
Subject: [PATCH v4 4/5] iommu: Do not call domain_alloc() in iommu_sva_domain_alloc()
Date: Tue,  8 Apr 2025 13:35:50 -0300
Message-ID: <4-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0279.namprd03.prod.outlook.com
 (2603:10b6:408:f5::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c72765d-578b-4d47-4cc1-08dd76bb6e56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3qjIEedU7kJmsM0+ghIjnVxTT2k4o68md6nuySQE6Nxgi8byQQM2S54DrRRt?=
 =?us-ascii?Q?8HjsUTpOSHU818d+lerSCUzS2njEuZRc9Otg+XWd9JMt/XtzyVvSOUlwGocn?=
 =?us-ascii?Q?lByauN9V8ts5oKYF5qgORp1MgBK7ggBAKrB45O8Q3D6roiDgP+C1e/rKeSkS?=
 =?us-ascii?Q?UjN6P2iex8VMW1E1dNuCGHFBOcVJhJbRdVDrCFmjfERDitfOo9yY9YDSxJPJ?=
 =?us-ascii?Q?fe4iAl7Zn16s8/eiFbZ6uKjr7zWNeHiNaebNBR5RtkA4i8qUeyKi5muRdT93?=
 =?us-ascii?Q?wUgUDut1054vrz2xYaixtn0NWKdCNKAFRNzmRGgZihP1PEN0dbXY3HjR/cH7?=
 =?us-ascii?Q?5aOelR6wvfcourRhZB++a1D0WoWRQdLTRv3jn6Ly8zs5YSxFap9v7pusRMEM?=
 =?us-ascii?Q?BhEii1ldfPsIMs1HHuj2gGpsrRxV3DnAqPLeMiscbgI0u13IRuIDETgTeH9S?=
 =?us-ascii?Q?7P9oCL2bHV7TtTU7mqGc/2zObdbLTkN/TDUFnbLiO9Ui5EP+/Yg0QZoucouk?=
 =?us-ascii?Q?WJGTV7tef6E+re6ljRb3C/INZEVdVtD1vWmhqQAviho9YVQaBDM6NiI0Vxv7?=
 =?us-ascii?Q?5INIdXj9RDIMa6t5uQjDK8s2MyyNbigAOEfjMOZY0uBbuSvv8mvVcjMQ4xiZ?=
 =?us-ascii?Q?6rrYYsGlMKobjBtVeDa5IHCO5KUPqwayvEmEgkO8rmJGz8rJ8BBTOQOpxsgu?=
 =?us-ascii?Q?r+FumuigVncY6QN2OqSAWTo/LIYicVKQbSt1j4thaFZ4hU7SsC9PitPLHUOl?=
 =?us-ascii?Q?0VTn34Ra2cOdIn1zbqZ1LPWl+zsdX1kTnbokaGfx9urAblVD56D8Q/9MLIo0?=
 =?us-ascii?Q?LvVmSAvhno78BjfxxonXLVt51RBQa/Pj9tTQur9CgSwpVNCvoIpGOHsUq4m1?=
 =?us-ascii?Q?+Zeaf6Uv7m81vBDQelqQZIr0nLgo4HMTRE5NAPviaNM7TAF/bn8R3OiD2f0h?=
 =?us-ascii?Q?vaixHFHUs7Lis/hExlh9VYOXqWV0nQuVpzoxVA9B0eENAGngzow1nuc01Rkc?=
 =?us-ascii?Q?JSwst/AWlM353dDlLrCdKcnTItHr+T70UmSNJFsFVaWpvjLQdM6cEGLjePvh?=
 =?us-ascii?Q?lT/QKFOGrFHomMrhuv/qSIsLrPKPEdJbBz56chEdMqf7UG4tB6BdBKc9UIaR?=
 =?us-ascii?Q?28y1zZBnD+9IUC2x///GX+J8lzvc+FDlS/Hu3ed9fZbFQKFHqUyS284N6sz8?=
 =?us-ascii?Q?27CUxZxZ4/9fCVTk/a96XiIVXb6DYGLUjcMle6DADzBekI3QLfaVIm9BemB0?=
 =?us-ascii?Q?Pp7txFT8byYScLDrtlhY8mHFMK/RqmzdXtr6H8wCXifKCcdFeg0LsSgopi/w?=
 =?us-ascii?Q?4FrTsLQ79W7Wfh2fSEJ2rw1bHtZ161ke41d/Ga1bg1JrpoHtM7xGwEeVoy7Y?=
 =?us-ascii?Q?xDLmujLZAA643aO/YSwC4xEhK+5TySnFlC7DVZfx9rEIJ6cL0+T4HRuXI5Kf?=
 =?us-ascii?Q?aK97Kv6aCpg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VJ7DfKA0XoqQdiWv2MER0X5zC/i3fi21QcfCHsHinzTNkWbH8yB3OW7yvU9j?=
 =?us-ascii?Q?THQB1WVqDAi8eZ5k2sGSjk85oslxaCzwu9/QMMRe35ZFxqRQ5c6EbDIV/XBu?=
 =?us-ascii?Q?Ot5novIc2CPqBPznN6dALiICSRDD8EwB6bIE07KlYFzL0is5uRxwXUL6pxWf?=
 =?us-ascii?Q?1EuwUB+qYVIPBcEqceSBetl9miFNiWlyW8kkqCHIhpWkykf+hEFII5+7EGx7?=
 =?us-ascii?Q?J5Ca1pub3d7NohtFQQ4AF8lTeqNSy+it8N/kxhfvEWKswbyuFV4xxjE6EZsp?=
 =?us-ascii?Q?IBjHmNoIgbWFnndcP3EhG2X1YGiuuCTxEf9dcAQA4dYoK9ZzC2NvC3BHs/g6?=
 =?us-ascii?Q?A2xWZmb1XyKcqb2UuSbmKFHvFzpj03hppvdmaFaqaPOaKcVsnhWAdJQWig5w?=
 =?us-ascii?Q?9BE2eyQlLb+1bYMLHh7taAaNJIBQd2Zw4eEdxKY88J/xJ3e9YfqSxP8Fx1aT?=
 =?us-ascii?Q?q9j8jPEG59MLnoFU+I7XUMcLmQh+FnImMf3jYddttjZF3hYQjwWD77bLD3iC?=
 =?us-ascii?Q?Cn7nW/OmWBIgMol7a6ye8O5ziP7gfIZh9tsvbJyDxBz4yC0p9CG9UOXEzqmP?=
 =?us-ascii?Q?FIEG1kSVsdw/fy4hrVwQo0O+ZYSCnUp1KtryvZzqIPaz/VwzYoEU6pD3JvjT?=
 =?us-ascii?Q?4QR03Xz3M7dInCJfARW7L3mRLTOdXg0FyR23lEUUxecvQHz6Q9JrcCYCC/hs?=
 =?us-ascii?Q?zS/oSbP7ifnihqO19A6lBcp3Zt9v2is1lJCTf3oiVnCCWetq+CV4r4/8ShAc?=
 =?us-ascii?Q?LKGdWDI31AE5oCS1TH4fGdS1WSS1pg3rXSfLMIr2E9FAYJbXZRQAh+Il7HJc?=
 =?us-ascii?Q?Xf9yksLDDJ57WiRQDHMeGz/y9G+9Z/OpuhhXF8XzME7sFUpZ23EkPhZFjqQm?=
 =?us-ascii?Q?isB4bY51sX+GZaP+ThiPnUQvjadNyVuTPyqbKDXulR8YmijiNgdawAgP2bt9?=
 =?us-ascii?Q?DTobKfLAz6Qa2ovJDAhDZSWjDWF+Aqu8cPr5PyUxmyltahE/k7zaJgqQ11MQ?=
 =?us-ascii?Q?DLf8AeVom7Q0AARaCc7qTJZ6pL67e75qtwmq5Zx4vckby2P5aCHVkfU1Y/4n?=
 =?us-ascii?Q?mSv93HLYyt2+w3z33wFTnbPlVftEAwCuDm1iXVf10Tg95jusTcH5C46tI5Pc?=
 =?us-ascii?Q?VZFuZmfC0Bdv5Q5FJLFtqeYLlF8ivsOKyKkyRKktB/UfYyyXp8lzXmCyAbWM?=
 =?us-ascii?Q?5Qjv6uNB2xhmgHKbL2YTsjBHIhVcRZ7N0LjQ8K7WOUUdozoKM6ksvOazGHBb?=
 =?us-ascii?Q?S2GBGCV+X9oThI1ZfRY0trSxIzSNxeUHojl1xFepAyAjkXiBuGt/N+zExc/6?=
 =?us-ascii?Q?mSsFAbRSXkdiQ4+KJjTkYY1HzoMplebLkbCa1mbrU8lIv/adBYggXo1QDfKx?=
 =?us-ascii?Q?clgePI27SeFFmhHey9HezNp+zR0HDvAm8WwYHcfYUe0RhSWr8dEQCLcNSJWW?=
 =?us-ascii?Q?umWwaJj1Ib6dmlLX4aenpduTuA6TlpQCr74A55FUU62vlECldeYnw7YvY0lX?=
 =?us-ascii?Q?/8R+zgpw1kRHNW/SywdUIL55vAgXxp8IQvOQTVTixiuzaTva6LCZ1RLTmBUm?=
 =?us-ascii?Q?AziCFpcGNEf1qYqiN3t2vGz6kbDcYoBYaLDPmxpL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c72765d-578b-4d47-4cc1-08dd76bb6e56
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:35:54.0643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBezcia7YcDH1c8TsG7Sg8YQlc1AbOzbH/yxw3dzKwqk9aZOu01yVrGldwG04uTa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001

No driver implements SVA under domain_alloc() anymore, this is dead
code.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-sva.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index ab18bc494eefdd..9dcf2014da4d95 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -299,15 +299,12 @@ static struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_domain *domain;
 
-	if (ops->domain_alloc_sva) {
-		domain = ops->domain_alloc_sva(dev, mm);
-		if (IS_ERR(domain))
-			return domain;
-	} else {
-		domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
-		if (!domain)
-			return ERR_PTR(-ENOMEM);
-	}
+	if (!ops->domain_alloc_sva)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	domain = ops->domain_alloc_sva(dev, mm);
+	if (IS_ERR(domain))
+		return domain;
 
 	domain->type = IOMMU_DOMAIN_SVA;
 	domain->cookie_type = IOMMU_COOKIE_SVA;
-- 
2.43.0

