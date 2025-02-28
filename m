Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0BF1FB3;
	Fri, 28 Feb 2025 00:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740702012; cv=fail; b=GCVg5eqqlpMflJVLdpCfkUqjEMI4VKGQGAvbGX+suhZ6JA2JI56/QilCcBK1Ne2C0QOpemKRcQahV34FcyX9KG43xbHkXzCER8/wqhIJQ1PyE7JlVXmvRBc1pHB2ctBY/IRiRVjkCXQsQLNUFhMYCB8gx+niDqVR1NUG+HUCUvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740702012; c=relaxed/simple;
	bh=tEMW0gncoRPq7KJuxZjnrQ12NIwyXFkjCGV/s0b6EwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jZ59i5oQPmHZZTgzHSIj2u9wCWOB6LqkeMBwZmSbvm8zPNChwYZg2E8ndpq/btpkQvBSex0ApZAV7BmOYOmw2fSk6GCMJ9gZ2l2gwoo/R4UWg0MA7BH/9PCR6GNYcUraoVE2xSl5lCHF1h8M0kEUuZ1qLBxSyqI8jwyUFucma6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qQj1hIXO; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qQj1hIXO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S28BObMcDJuZYTMkb84zr7c3c65fBVh/wcZVsnoakoqEhgOdt7e75alqyGHcnnuxse8u8Nna4LTSxdPp8q7aBZkJYKwbFB5marT1riOueOwrrjC6WiQZ/yso6mTCRc946Za8Sw8Z/b9OrbY3othjK6VexrWZwj9okGAcvbUszhAPGSrZlU9DjcVgwYJYb6gfGUyoiu+MMinL59bZpzatelLo4gey00omwT+acd7E7kPcOMvYsyLCpPQ78l0NAtwzFUWS+0H36ZhIQHJvOpQOPzU8lIbaPyXZWPjVPq1djSovo/GzjPC4rWSTtNgNgSwcMsoojLihIvYlWJRMkFamwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pavGPDksNveDZZrz7m1pCDGCooo6ysoQEC6JratOmhg=;
 b=l/zeRvn6O7gpkoweXnO9DMFm+uQFGCuzRpSF5sVO+fWNxzaqS6Y4M8YwoFqoSc9IriFQmCNJvufOqh3i/g5l8gdLDfdwhHa+CkUQ1r+wSJtA3/kca7mPAgnKuAMObiVZBkUgX1na5hlxM2NHr/m3UOn6AFh/xbucQ2/8XhHENWHiRCABwk3W4KMzNnGSBClQiqpBwTr2PqEnbOyWF5W1Q4IpipHR2ME1UF0DmVFJTLyyKUQ28tY7jtFXVXFwCFO049xHlc6mZAyLWFS423QsxiWW0Wu6BGbWK2UxilcnpPs/4VeGxme63sfRAqr75eJqQsZZsWM6gmsFxTNIKt2YGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pavGPDksNveDZZrz7m1pCDGCooo6ysoQEC6JratOmhg=;
 b=qQj1hIXOeXFj/sPurBsFnU+bh+mZdfhxEMMyuBY/gLabuU0KXWokFyOeUJwgADKktIAegqO90NEyhGDNzP1If+ggDKpJTtSzDO/Hagg8b7WHrwhfyGbx81I74A7uj4J3sG7INIuxKhCo5puAb8DzL2qDIpQH9/SbkdDqZZKiDt1abwkH+NRjXivfkPt4XNQyhgi52CT7AjYlcjpg9Ok5lm95/oGD+L7+G0BGjcxk+AEMPzJTStnYAFYnI+BxKVmLKfaoZCgY6Hq9lq5m16IP8tYMPi7/jMrKVuiaxLffvYMVMU7rEw3ErQk14arOQieYV6Gpue3+YZK5mmTnLlUQYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 00:20:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 00:20:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 4/5] iommu: Do not call domain_alloc() in iommu_sva_domain_alloc()
Date: Thu, 27 Feb 2025 20:20:02 -0400
Message-ID: <4-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0203.namprd13.prod.outlook.com
 (2603:10b6:208:2be::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7433:EE_
X-MS-Office365-Filtering-Correlation-Id: b83fee84-d3eb-4d2d-5b96-08dd578da636
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wQzwuJIeE61uS+GFlszQ0PwVE7G4/ny+GJ7TYnCR+SdCBiX7VoQKRag+NPM7?=
 =?us-ascii?Q?ie13nHtbL7Uv6Waq+k+xKdPoNcMO/jgCwOc8Hli7AxAs0MytMfbvPtYDzGq1?=
 =?us-ascii?Q?++OU2/XAKm8P37aj1fJcJXDzbbn7RFy3xG4BA9FMNs1WrAMoWP7IQL1Y5dGZ?=
 =?us-ascii?Q?jzOh5NY4aQMo1+3bLOZpp9Mgx7A7/v2R8Keh5IuCTiwdHla2NJwuNaJKuPqU?=
 =?us-ascii?Q?E6lWWlCWEJXQECsfMLUslhY40cJRDfVSf8T+F1kgZduNkOW8tUlt+L5EnVjG?=
 =?us-ascii?Q?2HsK7qGIkEDPK9EOyjutW/U5Dg8Mzg0IaPjfdnnxtT/amsTtN1mBwB5fUMbp?=
 =?us-ascii?Q?uF0OEHbw0DxsRJJLw9nyUk9EKfZlkbYZLCFULqpnCRMARs4ONIbGTj06wlNF?=
 =?us-ascii?Q?JGsu8wiMvc2xUftOykgPyLcMmAacvyhexBosdp8P+UgkkX7y517H2ht78MDX?=
 =?us-ascii?Q?d/qUXJsWZLJWL7XJ2hpggAPK+jVycbrRTRYvEJaFOkzxs7JElyAhVjAifel5?=
 =?us-ascii?Q?d25tH04oy08PLGfRc0rZa3pTlboh0JZD/wR/7R00/rsNgQROiKtw4BiSEVpb?=
 =?us-ascii?Q?WKIvcoASwiYgvWYMBTWmNJjmSrvNhbih2SVnQeu3rnb5JTy6gRa4V+dfKTTl?=
 =?us-ascii?Q?rB+Ov/ArNdz20+mOYj4r+Gdvf0rTZITiRP50Gp/deISQ/NqBOn5ymTeTXM6q?=
 =?us-ascii?Q?ttLB8GLNSjpx8UiGzvwtELTFXihAd7gSuxKX/MyW83uOQdky208mCVP5P/Yb?=
 =?us-ascii?Q?U3B9UcmIC3b9k1sz3iUc0xV3Bv5arlEKsu0ZJ1k1U4Hyx0NuFg20Fjr7evb6?=
 =?us-ascii?Q?H5cxzMAPCGNL5qDJ1dc8c3QvNLTwTgFxFldc1vMT3fW3GmFPKNGvVzojRX00?=
 =?us-ascii?Q?yiRQ9rbAxyoWOkv3r4XAbksnN7QStmpf6Ll2dgD4oo/+5hlkqXZXkO3VL7tR?=
 =?us-ascii?Q?0DUQBJU/wcp2iYztiCDzdinC6ZLWEFmlS/Bt56M5Qk0bCqttY/482vVsLRMW?=
 =?us-ascii?Q?bGKcCcS8BUzvmB6Vqmw9OfYuT3DqLnrDiyGXMDXOI+7GFmPg1oft72HOfyDt?=
 =?us-ascii?Q?oXaHbC7bTyYWCyUhUqL1DpIxq6LOhcv9W04c72NQ2Nfs8pZATHQJKAaa52vl?=
 =?us-ascii?Q?ktjvJwRbfR8F2BEJgz0/8Gx0OiUA2t5+dlr/+7OWFMXcG5KuR+Sf8VSgIO5r?=
 =?us-ascii?Q?jB1LozpYo/QkQcL0EqTgx/bt/ddg2ZaEx4JUFwe61FdZ+CvGuYtDRXvBRYk2?=
 =?us-ascii?Q?9VtVFQFyRgH4FJ9d09pb8kGQw89gGgczBITaJT+0KTQYgcUAEdDaUKL0xiAG?=
 =?us-ascii?Q?4OKQDjSHL9W+qwVVPQ0gDppc9AIvUHo0uEiGFnLUmrg+bs/C47/TEtYg2y7M?=
 =?us-ascii?Q?GTIs7slgVfNGIOBpM+CqN51Vg/zN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x83s8YRHLGhg7yl4tqT6mLpDVwk0Lk/y2hS4T3cyGzHce95hHVbekY4CQ0pG?=
 =?us-ascii?Q?zTtPgIadwM9qznqWyRRInfBezbyBsjVSvBzIMSmVpi2cXThega24st772HVL?=
 =?us-ascii?Q?NTY0dhqvWHyALOiyBLb5gsbgTqP0VGIT8hrewqc1TxiRb2mS+RAwV7Bq5Xlu?=
 =?us-ascii?Q?WlKWvMkdZ1+mJm7WcWR0stQB8rLJqN/v/RfTEWo3HMkv8vUx/x2LIBpGSRFK?=
 =?us-ascii?Q?Ms2BQQYsT5qnx7T5TRl4Bmr1H2Z1nvVm+nJTCGCFT7dtiWK3Hy98rVerRGz1?=
 =?us-ascii?Q?DYxOC6jfKRIlfONP9LqDpA7hqYP4IkT8ev/hUnAxsoV1S9x6OskW5cGaYWhj?=
 =?us-ascii?Q?U4ZyQIcXF72WysTfKacWmc6o+JLAcctryj282Q+4E50pJOgQ5X5gHxTweS7b?=
 =?us-ascii?Q?8c3QmchtRbeixd+4HX3z2exVKJ3g+7ZHBsjdPNNrvalsRi8uenQVlTIAtwPO?=
 =?us-ascii?Q?QQuagMYBIjZ2NazBCyPPlwG0BgAqTyqbuh9AuTJECDYKAsQLyjRto6bscxKU?=
 =?us-ascii?Q?n18Kb0m+EspfPOYsK62nkkSSu6suYm9gxWOJUmo8i82ImE71GURCI/OFgtkD?=
 =?us-ascii?Q?sJnZOhjfX6onRkpG9Ndxevql3+TpFc1pzxRs5ujO5ZzpnYTAup/W6zxFTz0F?=
 =?us-ascii?Q?i7SVA+cKGAsWmZWBoVBvMD7P6W3c4g/LPl+OgD6aAxDA5tg5WqRfdCHNt6lm?=
 =?us-ascii?Q?CJFt99ExvvAv+dODDf+9R1tOI0DX3dVELbEFGNPGhpQFTJkiyaNOfnDrciCg?=
 =?us-ascii?Q?SKbU4D6puj6UGnBTnVEZLp96gsDJx1YhNRA/k5AsAHRyJ2rr15PtdwG0tUVH?=
 =?us-ascii?Q?BeNWAqdsG0LYIAgMIATKfyL72aeZtkapVsjfn/5OjVgGjgAoe+EnfLTVylVq?=
 =?us-ascii?Q?QGc8hf2nWYZX0QziX5m3JkL2hPFb9YKCJekJ2t5ZSMyA2moOD+jvUu7mWjWJ?=
 =?us-ascii?Q?JuzbIjElvhO/UX6pcB+kC98BtI0jaos2TWkJ4fonag7rJyYsbfECu+n4CSWK?=
 =?us-ascii?Q?CDI4/QmWaVA/oSF4JEAtuJptazKk10OKcQKNIvYEX1hILehJETafhX/gtBTg?=
 =?us-ascii?Q?D44qqJYv6rKHYOrg7WF0q2fm98JhP/ogB5DWPuxSSnCJBDu5AhhmOMrSKSPv?=
 =?us-ascii?Q?ZwyXss94cUIxJOHrWd+r94S1QemZF6GSuCiQPrKM33s0VVDvt2X1ykibvXnK?=
 =?us-ascii?Q?+bBKoFteW/xWEGXcDczp/2jZBNAAhq/GeLlr5ypFYUWZrJxgzsM6R+HoJwK/?=
 =?us-ascii?Q?VF6f7zrb9BPInZmUAxWHyuTgglz0X67+IEmNo+HC2OCz/N56/F67JeMMACD8?=
 =?us-ascii?Q?jUiARQUal+UkeDfHBLTw0ysHZw6y2YzkpRk+85cSHFeb66esbkgUIhXIZiUG?=
 =?us-ascii?Q?9Z22EeqzZT8wKh9/W+tYY2AFC3A31z1ztQnnX/9mZw/RHKOgjuBvwJw1lP4I?=
 =?us-ascii?Q?mjguEN6iKQfXDXWfHu5qvr4kSO/tBjIfpkYtv5ugMgJIh6REXGQngHZp1AlI?=
 =?us-ascii?Q?ckFskUDjYOS53pgk4cflTMmVqcY0Lqe0RxSaMqxTF8awguf/eZS09z9b4c0G?=
 =?us-ascii?Q?7WvgLx43Azx9Up+5qsgtME1dle0F5Ojr1qhzKPQD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b83fee84-d3eb-4d2d-5b96-08dd578da636
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 00:20:05.0042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqA4GE+0mX+FYpPblavFjqvFi5Hz5KdKAkV2FT73X8MHmCN9Wv/Wk27JAXFerhUJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7433

No driver implements SVA under domain_alloc() anymore, this is dead
code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-sva.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 503c5d23c1ea27..b1cd32e665b61c 100644
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
 	mmgrab(mm);
-- 
2.43.0

