Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D8C1586EE;
	Tue, 25 Jun 2024 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319083; cv=fail; b=GW/DqMBZkCTm8uxmF2ZHLmreaJLTKlWDf57nU8JHJBkIn0S2J4Wc2vjzzw8ejXJBq7EJibg99HWvAIJqaB5eRdS8Cdnc0uaKnkxxaStmPXezxU5c36swBuYecUjFMop7SlPG2dYiK0hhfN6xU7dnC4POBXBmJ/cA8iiu1QzcyOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319083; c=relaxed/simple;
	bh=I6TbFx18aTSJ7+B+N8oDUXb8upoDG9jpOnHXowY6PWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nk+8Ylnn4m0+84EDzqvoXAeAeH2Fagnp8DygOj0WCLexj86GLC4o1sb3Xk1HZvLdgATsAqrIbkurr9gY5zQ74jHl9Q4Y5mp23+MrRmiMh/WcsNcACuykpKnrLAeRr0u1gk1VBdKQ3h7MX0oobqtIWdanlw4nhEEvs7tI5rkC2Bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lkchFCSo; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lkchFCSo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcEFPhu/OXwOTFxy1B/MiV9P+LHspN/bk2wmFNW3Lt8opmvuWutcl+SC2aKoYz1dlJW2bR58vWv90OsvxO5V2x3928WyFYwFboaWJsx3/Q2bmKwTNIvP08ybKsdjJLlOaMQp8MFoTu9Qn/uvmGui47eU/Ol0fFC5qXInEqXwuw28BnsJyf+Ozb5Wc1iLLoutFWilRlJ1KI9ZyZfGzzA6cxI1XSRwqXd/L5UWJHtGvHMa5GmzNxAqjcNDSlfqD/YHCj6efD1qrbl4KGuWdTxtHLD6vbr8+1ggLBh9lg4PXHoOemjXCrP0QzL73wZioG+/IDzIBwJCJMSNGzmryfTKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZBGtwPpp3fcnbTHEZr175AqPgn1a6tgFjBT16keTNo=;
 b=IfQdpOi88MZCAUXMotqdSLtzVyt0v2LgT/p3a/3b3TqBt0xiULlmhA6oVzQXKonWo4q8kzZZF94Gw2Sr4uivm/B9y25YI8etBTgVfCE/SuaNSEx+WpYQcQP2yQi5eB0Mo8wj3RJdvytdpr/KsWCRI4VzhKGdK+g5lvuP+DCDKfEOnhXqyVFcO/sZ0fvaOVQY4MrQnJc6NxFJujBiYB2AjJN2VLg8NEoo/rt4waT9IrHIT6lHAb356K7HiCLQpRXeL1AcQ/wTijvZYLHBMHw3oo0W0qqyLKKfU8TPvM+1iSDtDApkirk8ftyXUNaCCVV5OE+a7pI9umEe/0Iq10JUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZBGtwPpp3fcnbTHEZr175AqPgn1a6tgFjBT16keTNo=;
 b=lkchFCSogxIzq22wOKPUq+tMycFgJ2xstiLlgTWpGlEjLbku62e7Q64XrtmVNy/U8II04cRWBw51iF4xbp5cdM/tkEjpwnu7zpGc3XiEMIGY7m3ZIz85QocAgc7x/sj/1YMZpt393FkQfx3dmr0wQhWMEDbYajQnL0uu3zbGhjUaPNT7tnSY2bcHUl0SsLdfocBXjBiYHs8cTBh0nbqB0IFkS6Sq3h7C3z3KjseTrXjzl2Em043woHXaejrgNf8hkHWLYhtutJ/UIbUCmLNbSerLgrdT2EQsiwoXLmqzuAA1Xc6GQYWj9adk4GhMp/+fjTAXSqGJlaVhC12mEa/x7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:49 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:49 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 01/14] iommu/arm-smmu-v3: Convert to domain_alloc_sva()
Date: Tue, 25 Jun 2024 09:37:32 -0300
Message-ID: <1-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0154.namprd03.prod.outlook.com
 (2603:10b6:208:32f::28) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: f01a293c-a4d7-492d-2412-08dc95139e4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IEv/8djGNtq2geRthekr27ObunvVo9TH7jilzisqUzoLVsr7ZfHAALmmN8cL?=
 =?us-ascii?Q?JRNxHD+6LBcyQlJbEUVXSNdWvOeU2dOIxb7wCcMZxO/3mWcSxMuwKXIpYqUm?=
 =?us-ascii?Q?XGTO0Mgb94rFoqsSQINc28SXy1jIBKzpxhrgroiE8Ym/pvnG3F1tPghAwifW?=
 =?us-ascii?Q?VOYuz1FLqw9Mr1rMMjs+4YTXBy+9eK7SC4bOhCszXNiKACfqJ+/SpIiip2kW?=
 =?us-ascii?Q?rlWHYmM+uAggTksyFL7HBm5pD7tVffv95GNnhXFpqTL5NG1AgIoyjpbdwOEJ?=
 =?us-ascii?Q?C3D6IjO4jU81w8VwviXGn7Lw85FeiKDpieT5GS4l4l9ySEoZIxgwHoncAdLV?=
 =?us-ascii?Q?gF8etAqUEUVZ9KvKPw416T0uWX7yEmGqBgJr/VJsXQYznKY6VTlx6cdJVlBF?=
 =?us-ascii?Q?pe8xTk1YuiNGP85vFemHfTkyJluC331pKTgskuAy0PqyyfTw/BtiJOk7GnOF?=
 =?us-ascii?Q?7pl9qaX+Jj4oOGj5Auh7bxA/+O3qUx52pe5IXWB2KHxES5wBFbw58YMODYVe?=
 =?us-ascii?Q?hNwe0eiAxkFnuFm5X0kILZo7i5F7BTif0WR1NSF78jYptIl9VyONyQu+pQj+?=
 =?us-ascii?Q?AM1mM1a6UYqOHcpLcuIw+qI7ZOt9ENlJBjD+buaTZN4bRBbwAS1UQlxPPQgF?=
 =?us-ascii?Q?01DjdPklrUp7LDl5p/Bwk3dXCkqdLZ+I5G95UJ7jk5J7ETseWs+lEtc3VHif?=
 =?us-ascii?Q?SJbXZmv8XUK/6TtKZv5znUADAqUpsU0kc3oltvH6RX3Q6bz62gSM7u9KP0ya?=
 =?us-ascii?Q?Z4igF9IomXns9UfvZCZ+K6ZlGrKTMYFOq7xekkSrHXJ0wxole29A+A932tra?=
 =?us-ascii?Q?JKLfLRVBu4BoL7o/GcfCsczhwlaxeH6SXjC1MFePRC1l8MY2hvGiP3MRlZw1?=
 =?us-ascii?Q?kpZQ+Uj6I0zNwuJd2ac/XhIyx4tF62BZtDimFDcdStCoqBf1Dfg5U8vNZRR8?=
 =?us-ascii?Q?8jasm2YLfET5qoYlio1W9oIIaVO/YUNhJBfHAMfy1kyMBph48ik5xKS6PysN?=
 =?us-ascii?Q?5OlUTTm8Ax9dgqsV/lGiCsU+peVlJ2K1YjvyD6Ea7B2xZsAj6wuXZpqCOQPf?=
 =?us-ascii?Q?UXVTDWn4/zeu+whFirmrBbpSlKGpO+XcB0LJy80c+Paj8jURZfIpEJ2gg7A5?=
 =?us-ascii?Q?x3yQ++CRmNUwFAIWgdldRb1YbuTnfumM0acwdVodE+qVwuyQjLyKj50c4eIl?=
 =?us-ascii?Q?08bjK4X/esJmROmr+OzPnhXCRsjWTBK8/TrzGWGIN3T5tH5YoopxUTRV/PxL?=
 =?us-ascii?Q?FIsUN8NnuFNYj6i687NP6DEbRrLJBGdn++m+slkIWXSYa1h2EDm+JsezdSeQ?=
 =?us-ascii?Q?XGohPF9SarFYtRRGq3YDfXtO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o9rbU1Hpo8VrUxy5zlxbRE3XryubdDZCbEKXQ9j+VQEX+RvG+d16DJn/fpRD?=
 =?us-ascii?Q?uFk1jKn5IFong1olYkml83LmdDi+YnwHDGfnlMzEEbpqSPp1mbp5TQ69rSWW?=
 =?us-ascii?Q?FqGj6PH9iwLtPZy8Y/2eoL933leA3J6dPDX+e2W2wr7XfarGe1nbmpKEISpz?=
 =?us-ascii?Q?Y047gvYbkbtkILGuFffunfXzz6CLx3sTr8xhGFjF2qnP1R2bUrhkFBwP6cmK?=
 =?us-ascii?Q?qZyBslcOKClUbhK2A2Unftv6Afhw9kki6iyLRwJ+yBVtRKG92f+2/FvKEesi?=
 =?us-ascii?Q?6Ha6wyXAD6eGtKVEH4zwyWrivHfMXMvWjUfXA99la2UrbgdYB10c8QFqh/Cz?=
 =?us-ascii?Q?k6iZtQ8K5KhGwZaYoBEpXrtEr5RbbUbt0k5sQdk0mlyppmx/vBMb1R/Kx7Y3?=
 =?us-ascii?Q?6HFpcOQH0PEAoDZ9kUhsjzvBn4EiofOFbhRb2LoRZIQGpEu+9yfoWuF46PSq?=
 =?us-ascii?Q?DgxWRI+n+b0kKz0hNctoeO4kv9b6CUshcXlJZVshPpnfe7OWo0ubfTsNIQDP?=
 =?us-ascii?Q?ydjJPgZfcP4xzHd2uv9VQsr7Xa4geih9Uz84S4v1ZwCCXzNbaiLjtFiSlf/F?=
 =?us-ascii?Q?18i1ROxHKpYmjyAJSNUlnBvjSL+JdmeKwIVAK5+zJCYGTjXHDSjBBFXpi2TG?=
 =?us-ascii?Q?GiIeJPdhdBV5rDDH2IC9H5T3JPECSdjLAOcY1C4t5/ZmP/dz52i1WmA/xxnY?=
 =?us-ascii?Q?5rBpwNMqrrjFKJUpS5L2yNG/x6dH2lWlFvSzdiuhemH3P58hfm+ayBIvEPOE?=
 =?us-ascii?Q?pXmRQeoQJQ5t7mNb+wTYMQrBWNATgFiZCWdnkK8K3IyOQ24mt3O+g59LqCXn?=
 =?us-ascii?Q?su5WIVR2foR2dmFwK3umU8wobD1Kt2rhZHRkq6FoU+5J/LcPKvtsz04y2c8y?=
 =?us-ascii?Q?w86jjyLj0D2EZqV7ymNhQ0emx5agxDTLUmIhzRMpMwPziULkgfzqhrJPq+qI?=
 =?us-ascii?Q?eJlwPQrWBSSaMt8VIhZIjn+mJiGtjULVf7OETPWSD7FU12zQDP5IpvH3JZa4?=
 =?us-ascii?Q?4YSK8SCKjXn+Fd9eWUxiWLDZLMdmQr0hVGbElr/wF/ewnfqWrOz4N+X8thze?=
 =?us-ascii?Q?mHfJQnodExVHztTGuf/O4jI0jCwH+GhjnYwtpWTfoovgfy2Jkj8PDNnDCWce?=
 =?us-ascii?Q?wKL+UH8Y6KiI0k3q/gfpQxEntBJZqEU4Xfl1jRJdT7hMUOynQRljO8j2/AX/?=
 =?us-ascii?Q?9X07E2w7AgYO66cxNr5WlnDhKEfCS4sorytKQzRbEfhT2f4CpgNi7vtTzQUS?=
 =?us-ascii?Q?b5hgsaYYEq7zIZGVtCdCdbE81PTGcA2mRYh5Q92pJoxz4XURJP0qsle32lN+?=
 =?us-ascii?Q?v0fCQY/bO1xzURpZfI1brg7pQaFgleF0e/x/RiMh0CnmR3AltTm2bA3VYO6e?=
 =?us-ascii?Q?nGkm/UnIh3YM/9lQGw0Giv+9dWrpkaiIebOLuJPhHqmNw4Frc7XoBKxuiJ74?=
 =?us-ascii?Q?PESRDzWwKYgC14psloGMP/m5W/Rr93uu7CwElFphBazsWr/AZPP0b3hQwtOV?=
 =?us-ascii?Q?LwI9yshnX2CYK3yhaHK57ZieHeEYyG4tDaTCHQSykCKQxeWXfHjelgGvKD+6?=
 =?us-ascii?Q?yD6Jsf1EMeZguEsjMtLgOBXEZroHikmOcI0AEDRm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f01a293c-a4d7-492d-2412-08dc95139e4f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:47.3789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: siTk4aJvrQsZ3ZZnoxVx0affdx0AxYIqnBP5Y9y1xF0LVez77ciRmONV9ktEzv5k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

This allows the driver the receive the mm and always a device during
allocation. Later patches need this to properly setup the notifier when
the domain is first allocated.

Remove ops->domain_alloc() as SVA was the only remaining purpose.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |  6 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 10 +---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  8 +++-----
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index e490ffb3801545..28f8bf4327f69a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -656,13 +656,15 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(void)
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm)
 {
 	struct iommu_domain *domain;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
+	domain->type = IOMMU_DOMAIN_SVA;
 	domain->ops = &arm_smmu_sva_domain_ops;
 
 	return domain;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ab415e107054c1..bd79422f7b6f50 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2237,14 +2237,6 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
-static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
-{
-
-	if (type == IOMMU_DOMAIN_SVA)
-		return arm_smmu_sva_domain_alloc();
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
 static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -3097,8 +3089,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
+	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1242a086c9f948..b10712d3de66a9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -802,7 +802,8 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(void);
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
@@ -838,10 +839,7 @@ static inline bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master
 
 static inline void arm_smmu_sva_notifier_synchronize(void) {}
 
-static inline struct iommu_domain *arm_smmu_sva_domain_alloc(void)
-{
-	return NULL;
-}
+#define arm_smmu_sva_domain_alloc NULL
 
 static inline void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 						 struct device *dev,
-- 
2.45.2

