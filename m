Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B916A3DABFC;
	Fri,  7 Feb 2025 14:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738939576; cv=fail; b=FSlf+i7JR8+MOgO4wFZmJG3xwB+XXEz/+fMDP0EfyirZV1SI/YWlDKYoMNACln9jekFoZN8/uWZS+0erhmOyfalajuWclHFC9RDO4VjX71hxu6sVUuFfNJf0adFnNxxH8P1my2ZLuRBjiyUep64XaN7/Pj/oqMPfCteQwALTmnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738939576; c=relaxed/simple;
	bh=qQZnGiEi9gFCmOI/jmcvYAHK2UKTWBTzd9AdZ65fp7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bDKgKcPEXzX24wmfoyKRhRGDPCs4ZVbb81c8D/vCz+lNuk4+ALL0mothtszKL+CiW7TUHP8fbdK4W7hr4sFO3KS8mdNAZWJf4VnlTFFtrtJKTUXBS2rnfMgxeNi0+OGXYbtqHJNdKTn+miycl40TMRFs3BabEcDi2HZabQ5uJis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MAQ04+Cq; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MAQ04+Cq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k2LHFrQtu7xJ62S3C866T5oinLyaE7V5y3fzMT69YMoY6xydcOfbOO5E63GyjcDgCQCk/FBmLfnG3FuI6AwQpSadMJj0/UY1wFJr3H+Yb1DNuaIxWgLjBuVHCuJ30vZ04Hy6ORXdGvFNetT4qO4yBqGyr0GSkCYb0cOUFQjKaHMqNyaViDIHlRiaWdfLsSGOYaSvh5qgXdWlN8xJh26PlYZ+M76f2pLg2NMlCy1iWtPnbgF4djW6Mdp3eSDRMlke09aQC4BG2sFEneKHDH4ZOdUpefuiH7aJMMC0XOEgQDjEuRxss7tAjpI5hxC3d0aV/KEjgccArXAci+2yE60BAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJnP4WjUpu44Fe8BYdDD8ZV2kCUz86ZpZpsOeuHKZJ4=;
 b=VItzP9kbwluF08o5E0xPC+4yjWHYOwfoxYw7wjVHtv2FNtE5HFf6+gdFELlRwDw4Mqrqah04zZQsIRt7YYG5H0dt58DJrjeqRO4IIaxuPEMVcQZrtmRSCvyMXm8MLWHFX7mEj6EuHhtuuS6C9egYjWMvh+jdwlgkVHlfmw6PPpfq2Xk2ffCFotBp2NZjLuHdnn1QYDJoY05O2d0i/MQbSmI/N5bGyA37+xrL4Q0ahVZuIKpaC/12gbWPHHd7YrM9/mC57BFk0Uz+oBfmwwu+EOMBJkXPmSD2ePhfJ7ZWrAYcSpC357PgDXF0sK52Of+oImGLt9boxGcRsB1d5tta5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJnP4WjUpu44Fe8BYdDD8ZV2kCUz86ZpZpsOeuHKZJ4=;
 b=MAQ04+CqccrBI/sz/baXJu1lQ2wMhMSdesOuRCwBPcH5D2IOvAvgfBmhaNnIaLllBhYdHZijOlFEwkuNztpbdAYSvuIpTQBGxyCGUtfYdlWtWPSriLLsaXsWvcdoZR1rLmtZHdM1yGoksGuasMGMIEbss8BwPtLB5fRAXfJJmG42RXegcvFEfOjSKfux3n292Xo4mcE5zD7pabeLuX4zSFQAnfDnPW5fOGE7CLaXkYdQprvs0IF+j0K0IZpppWydxqzPsyqbQQBZbx62oZ3HstQRfYS+SkSz6o8hiab8Y8LE08qw3OwmZF++Bj0cYquGnRbbyBo+HS0h4hbemPwgSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7029.namprd12.prod.outlook.com (2603:10b6:303:1eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 14:46:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8422.011; Fri, 7 Feb 2025
 14:46:08 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH 2/5] iommu: Add domain_alloc_identity()
Date: Fri,  7 Feb 2025 10:46:02 -0400
Message-ID: <2-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:208:52f::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4a6b0d-be39-432a-c748-08dd47862731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jv11eCx1N71Y7EDUfU1uTtspwBsldGX0EbLBdSIlBaCBvdiBazhmFY6gOUA4?=
 =?us-ascii?Q?DTquWr0lKdBytbKr9eZuYQFC3f1dSELz5hdMVbWKSp6VMx0UtQIOvZPyaGc9?=
 =?us-ascii?Q?StuoCpPa2a/I6IW8ayiX00foaonLAkCSolxyjESxLgv5t8WnAiFxRWD9P/iV?=
 =?us-ascii?Q?2iT9QcCWgS7C7y9dYEeeMSHUzDiK9iqCgBQ+9eBaDF2IUSgveuK6d3rwAxsn?=
 =?us-ascii?Q?AN+cqMKBPR5thVn+52rOKEx5HILRistzc9X8PBx2s7/gZ/gBe1648wRVBU8q?=
 =?us-ascii?Q?+mKj1vU32ewkFxHA6bfc8INeBkwjDlxEdQH8+2CzCZwxHt5HLLHtaHYzq525?=
 =?us-ascii?Q?ZxuJc5rHRqZO60ZWGbgUheXDws3VhSYYXPVO7Y0YeJOdNYMQ6qy8zn6hsWqv?=
 =?us-ascii?Q?MK4ed+NH6XQV5pb1UU5rwL11G+cfAy8/K1xceDJXslrom1M62VRPmBKiYYiT?=
 =?us-ascii?Q?hO7BKWhnDx4Wq2wAWr9bfKghyIS6ijvspH3c7dDVn340H57fIfPVA0y9o2mg?=
 =?us-ascii?Q?7SiRVIuek4yfISZ06O4zqPVdTkG4Px56lTQ+lR3ItxRhRU23Jh2x8uqpwcLI?=
 =?us-ascii?Q?C6b0XZUuMPoA6Sd6BHXeArzhJPIOo+t46OdFrwtK3uOC8knFvDkgEoFae2Uj?=
 =?us-ascii?Q?BNYlvrv/6oce0UtGp+hvwB/xtlXF2+D8K2TpgvOBTxMv4wFBrPGTaYxkCizR?=
 =?us-ascii?Q?vYtAqwEhEWBzBq8MsQs1yb5D+eQ9cpNjGYHsABQtQJWvsp3c9bPROnXVRyp9?=
 =?us-ascii?Q?rD3GKPOpCQpJuLa+h8FQnMXfcwK3y/FlkmCBK26gpuxPWwi3bfAkcxJRzPsr?=
 =?us-ascii?Q?b+xDJndx45Nbb90xTri9r98opxDnvHyY59aAKeoZvOJyxwydRr97aC+J3sD+?=
 =?us-ascii?Q?QSBT9PYDVw9wRKiPgg5vCK7wnh4UIbQYFVeNDxeFwok91vdzYOW1+6kmTtV5?=
 =?us-ascii?Q?FGKaJG56o8KjkHDMp+LaHYi2CvKcMxHNu1dAlwgfyounufkcuaKYRIQTnpSC?=
 =?us-ascii?Q?rRG/MMRduSdFWCcONvTRO5A2eLaapFhuXYjnXNC6pMVk9TuPKCAOmFmtT8fH?=
 =?us-ascii?Q?KdPlHjnsEw9OA00Uyj1muoQr+ZcjGyDT2+KgVWQrdHnF9z3HxxTbuUpQfdgg?=
 =?us-ascii?Q?kqz9T3rN2QBWvrq9Rvkc5v55bj50+eVnhrkgJDdeUfHn8geGp5KGpdAQsVSn?=
 =?us-ascii?Q?BDgxGwQyU45JyzyPTta5okxsh/J7f0IHf4KyCEcCd+617FkaBYVwK6xH5E4a?=
 =?us-ascii?Q?BUNsTlTraGhfIkkPZp7XLd25WHJlGxk1WPdP/77TsbQzzWEc/bLMvD4QwM8A?=
 =?us-ascii?Q?dpRCZqQ8qQNieVmn3xp1aHZOJkmGs5vNZXDxnwX0+3bVbMPxDsHTZklGulp2?=
 =?us-ascii?Q?K9EwgYfZl0Kkk+GAzdVOr9sdRmfM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?akL/iUzHMqAUa9WZBiYk+G1d0yTy2JQgITvGyW610a8zVSlCfYVwrY3rj594?=
 =?us-ascii?Q?0iymp9VGfXPBYAcOcKQm3agYo7/D1kMj5lK9oZjKKbScEtMeQ5fR2e56HjjI?=
 =?us-ascii?Q?d7+VKwpJih8bbQY7tfWOO2zH0Dj7y+WEkO+LgkQsvpWT3TBtZ1fM/9q2bQyN?=
 =?us-ascii?Q?kPiNUf5uXb5ZJ7/I08zIXiC/EIpcze3FOPZbDfJbbw/Xw8Xvs75yde16L4jp?=
 =?us-ascii?Q?mWfyc4922DwnQjwJ1WXEUdWPMcCuv3miyWpIDjNlGt1iI08Xb5ZZzgDhgPby?=
 =?us-ascii?Q?qnEPVy22COizIFjCnWheoDeyYmSRECoyoLl2MFfTFH3yh5Ex2W/4zRJstOfa?=
 =?us-ascii?Q?0VL4UFlnAK2hdnJt4naLBJ8XQSqVH8YRK7xAqQRQzoytW1MqXxVrxA31h5Ox?=
 =?us-ascii?Q?djiqEqw35LvS2f6hKmzWQVUlxWn1J8Q2TzY1GTZCpLjYYLECegihgVwrgZfo?=
 =?us-ascii?Q?Rz8q0bsWuxa7U5+1ZgzTPvKFlq2p4a9W3/dUrweMOLUpWNMXE9meKxWqtmV/?=
 =?us-ascii?Q?8FJw16DPyaS55aHh1CLhqVYF68Xwu1TXG8eRz0CRw/pyvpKTq3+BrLr+k+EN?=
 =?us-ascii?Q?1kfbZnw/7brgCFpzHqnjBMcEjrPTNR2KKyrh/w6RdF69JiR9+nEOGM9gMQZd?=
 =?us-ascii?Q?abmBNy71XFgpvxpT+dv6oZmg7LmNfp5W6UFEvxnW3xr6sXEtmQf18lqE4TEQ?=
 =?us-ascii?Q?oqBzo4Q62M4Y5YvSkQm+jtmd4CBn5UOgttt18Y9WEv25AWduvH/3lJ7kXOmJ?=
 =?us-ascii?Q?i/OJ+0QaHuM++2RrtvNnsh7xCyD7PfEie6BeY4VDF+v8iUzrTi7xaC/pTa5G?=
 =?us-ascii?Q?IeZQw2eAfaf2NhjAl2cSN9WymSWZIDB14gA3iBrX0C4/q8mjqCBwMHHFGlkK?=
 =?us-ascii?Q?1csGyixaSs3KK7xGqc14ynJjXSXOWmXK++ShAWIpXDX1JsDhyh9Tny2bhQ99?=
 =?us-ascii?Q?mk2Tr8dfMZsy1l16NOJ1SkuoJ/RlGpvV2ru0qVYJTOKob6ogupn9zCVKDFqT?=
 =?us-ascii?Q?FZaVgn1sn5nK9NwGRPFqO43PhF6pYSkPAVf2ku6dn+1Qglkr3lPTvMX+LaP3?=
 =?us-ascii?Q?p/4pkJ2t/PQcPL14dwuPkJli8fMPPqLj0Tbk+XYoBXGDg2TesUrN1L1LgbIf?=
 =?us-ascii?Q?Pum/ga52ix7pCMDuTo9w8ZL3P7tD45naHfyQTSwbYYfV/xc9V31IbhTwF5Z5?=
 =?us-ascii?Q?BA5KvicM8shL1pJk9TGkUS/WfubcndV9cRKIIsX6C63SRz4R+K1ioY87z796?=
 =?us-ascii?Q?wDRvbwmgQ6RUMSlZQi/rv8p0OsIxbEXgTyB0kiDR7RipPPQsOUxBw1P5U78Z?=
 =?us-ascii?Q?VmTsJomiCQT5Gxe/pkNyMyU0EJ5bm/5mcgHKb62sWLPxHl/Q27JKg9bGQECA?=
 =?us-ascii?Q?IuM4y+D/bT5SaMb4nUEjmGRuYyD4JTNgrJ0UrWYdaMke5/hissvrWqqfQ0LB?=
 =?us-ascii?Q?9MmAeeG+hlBjwYQhh8ggfVIthxHBAm1wbYLM9PEgnyA3y6P0F8bAql8aMDlx?=
 =?us-ascii?Q?uQT586HOWqMS2B1B8gTtOo4e41fG9idjqnJCjSSx7dGFoExn3SN+7X+JslU/?=
 =?us-ascii?Q?DD/R3X6OUScK1iaAS67N+g1IYxxhh4jsGjJryyAC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4a6b0d-be39-432a-c748-08dd47862731
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 14:46:06.7454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: itMw50XWITTJQf8zO2oJoaRgh8mIWbP4gVN0m0atvVyXloGGyHZ3xJm42M/bFprN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029

virtio-iommu has a mode where the IDENTITY domain is actually a paging
domain with an identity mapping covering some of the system address
space manually created.

To support this add a new domain_alloc_identity() op that accepts
the struct device so that virtio can allocate and fully finalize a
paging domain to return.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 20 ++++++++++++--------
 include/linux/iommu.h |  4 ++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 870c3cdbd0f622..ee33d26dfcd40d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1595,15 +1595,19 @@ static struct iommu_domain *__iommu_alloc_identity_domain(struct device *dev)
 	if (ops->identity_domain)
 		return ops->identity_domain;
 
-	/* Older drivers create the identity domain via ops->domain_alloc() */
-	if (!ops->domain_alloc)
+	if (ops->domain_alloc_identity) {
+		domain = ops->domain_alloc_identity(dev);
+		if (IS_ERR(domain))
+			return domain;
+	} else if (ops->domain_alloc) {
+		domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
+		if (!domain)
+			return ERR_PTR(-ENOMEM);
+		if (IS_ERR(domain))
+			return domain;
+	} else {
 		return ERR_PTR(-EOPNOTSUPP);
-
-	domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
-	if (IS_ERR(domain))
-		return domain;
-	if (!domain)
-		return ERR_PTR(-ENOMEM);
+	}
 
 	iommu_domain_init(domain, IOMMU_DOMAIN_IDENTITY, ops);
 	return domain;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 38c65e92ecd091..6389d59178ba3f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -557,6 +557,9 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  * @domain_alloc: allocate and return an iommu domain if success. Otherwise
  *                NULL is returned. The domain is not fully initialized until
  *                the caller iommu_domain_alloc() returns.
+ * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
+ *                         use identity_domain instead. This should only be used
+ *                         if dynamic logic is necessary.
  * @domain_alloc_paging_flags: Allocate an iommu domain corresponding to the
  *                     input parameters as defined in
  *                     include/uapi/linux/iommufd.h. The @user_data can be
@@ -615,6 +618,7 @@ struct iommu_ops {
 
 	/* Domain allocation and freeing by the iommu driver */
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
+	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_paging_flags)(
 		struct device *dev, u32 flags,
 		const struct iommu_user_data *user_data);
-- 
2.43.0

