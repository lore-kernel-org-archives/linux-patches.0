Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDD122F3AB;
	Tue,  8 Apr 2025 16:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130164; cv=fail; b=LXknfUTyXjydgv64ZVlvh5aEZFmmSwhzqYUxuhRmFYp3eD8t1uKUDPcPDZvmLs9Ashf6aqdLDwsdB3tMImC67ic2pVK1fBVj7rX0gmadvJnnrKR2IxUpludMzPid0u6nOjeJyFvpKmjtwc2TbYPJz7Yg4KfZs0qlSou17tCMlLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130164; c=relaxed/simple;
	bh=tIkF5AgsQzif2hEEUS9SwqUZ84efTgJkIDTvVqGjFso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eU62FJS2mUxjGlSwARGlUdaVUV+LB37l1rSiAgT/tT5TmhelNFL4zAu9FIZkge2JjLNJVC0RBZClMponHS4xbHAMaRJoNLQqXsqShVxyjTotF8U3cIDx+EBXz2R9Fuf8qYapXfG8Lp38sANS5YU6yHO0iCiSqPBWCV2PHA/gjQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EUaCuFAd; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EUaCuFAd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HKfAO86nDcbYfntLh1YHcgGOhU4rB12DnjM/g02laMk6rHmqP+Pfzqp/iMHvi5DyRpay3ZSAZqfRlQYT33xPiF3KemfR6bag+SYVS8chg9V3wsfCxoieGeTjVAlxCFNnR3kvJgZshgo/tms8fxEwBrYCzNW7tapOyOxip8j/7oeb972N1Wr6zUKtpsm9S3K02wbgIXndkSi+sR24k0P6cObFAC9i1yIqobPqEF4oflUn1wWijNkTQyEZ//kPYURI0XhULOKFqR5n8dJLyc2RMxAnSK04OBZgvpPyrqbZy0Le1rGffkgjsW66yoC0+gfz/p4knXl/Id8Z2ha10P9sQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FjD0MYV0S6T4FbkZxZanNPDdAIgFtmJ+gA669ys+R0=;
 b=Ix9QXOP87rbzyh72gy5jOMZQc4Px88GTv/+z+KpoYFthoOlStebqBkKlc1DOg+sKT7RiRdW+i/qUiIXQls0YqlD6ACJ80FeQsKPw9BlICBq/Dmjit7VrL9V61Pa2cp/7NbflICHaPhKdYo6uLSlfDdtRdCvni8Yo3LAqOI/LDjRDNfqHtkvfWdnA6blnakMst4D3CLRIpz48V6UutE2oXAnLTu0BywlqqKSCR6Sb+8DDKoXABUzH7QYRo/HH2quSan7jFsmTpHVZ4SblOL77u9KfjurGjw0WtQcPJkzHjPvvcvWmsB1Q1wesSDmdD/MAGLiIPiFCmpq3rBW+Be7mIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FjD0MYV0S6T4FbkZxZanNPDdAIgFtmJ+gA669ys+R0=;
 b=EUaCuFAdCVIA4NrVARUD+WcwgNEsHp+6XiFEipCP+w7+kS8N4da2ylqQ2+yCroUQKotf+UnRRHzNE6DbyaWFIc3xFvZbVJAYFdNyB8Gwgx+B6w9rnCxNVfn9FpPmokltm1nSEFEFd9gNa5fND6xixDbyd0FpxQSyCbGqaOFeno3xrHBSv+j/Qj5r9NTV3OBYlGxzQZDKh9KvGnE6mfKpvK1CDPwkWoMSiIbSfh1eG8Z4hESPW2XQI0f5WTK8sJExdQ1kM1l7Rj1ZtFvuaSj/KEuon8kXno82r5Kg+qWjJFA/zf90LRBHu7pkX3CjsLhABzbPpjDApdNarLRgqz0Itg==
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
Subject: [PATCH v4 5/5] iommu: Hide ops.domain_alloc behind CONFIG_FSL_PAMU
Date: Tue,  8 Apr 2025 13:35:51 -0300
Message-ID: <5-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:408:143::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ab796fa-a7ad-4e0a-9b2a-08dd76bb6e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uXSpIIJ1qxFXtLamyA+gf5wEk+F5fFJB6c5++D7Kc5wAGoK4hs7FGCtXgDus?=
 =?us-ascii?Q?RSuurTW/9Wq8FcpuL+pTtbYJT2K4KeSUsg1doyYOm5lq5ZcKg9noOiIqwSIj?=
 =?us-ascii?Q?EvKfOleUoDrC+eFwMWVkUBM2iqywsbg2GR5e1+1aPgGn+wMDr0LTiSPXaxNi?=
 =?us-ascii?Q?+xn1SoX/zsT8dICmoq/Ncv47IFU2KGwMVbNSqdiGaSmFx73AZwXW0+LZZfXp?=
 =?us-ascii?Q?nt9TMErwcuknUWHzCkbr1anvhJsWRfTtoBgxR1+mr0CHJ/DmbXsMB7GMImdm?=
 =?us-ascii?Q?/vo3qdRoM2JCBLOpebx4ukyPkI6PnAigYUKGM0KjQFcylv83MJ5+5cd/MDFQ?=
 =?us-ascii?Q?z4IxW4LBG5wbcZ0hKWA52Ir1raYboxdIXCUMaZxxABw7sTpBAQKBysZeRH3q?=
 =?us-ascii?Q?20d4WHC1GhTyYtJS/76SxY53F0BflVqnAVg1SjPwlyaotvNLtSpIHCsTUC5w?=
 =?us-ascii?Q?snwFrUww9Vn5Rzk2cavZ0iy0jhGWoLpvEBZcMqlCCa/rh3K9P5Fn8a9n/zb0?=
 =?us-ascii?Q?7+HOE91fppUHLTdIyraORgK706mVMIGZIZncCcSKrArd8VvP1+JrmgqWN+Yh?=
 =?us-ascii?Q?kGBmmKHp8qRNSNs7ljUS5OyWzOaFzsSnGmRFSA47/3i7cVwtRphDyX1SzlbD?=
 =?us-ascii?Q?ftu3EP9+Gm6170FMzv0tXXPkkZ8dpAHmxeY3wJTkxwir3pMqJb7kgt7PycBZ?=
 =?us-ascii?Q?vubp+df8iHBKLMqiP7D/JOp672jJEL70V9Sg9aIrUWgCOmlJoXOHNmE7Y5ZX?=
 =?us-ascii?Q?oJYDC/ChJndOE6UN6MUh8f+KDsxIek7XQ8F1NVENBAeZqM+t6xPsNLGhkgnA?=
 =?us-ascii?Q?2fH2YFHe+9f2R4bD6NsI2KPC2UvwYdm/ejJvFbCGGtIGoeKxQ6rxNcjSg4Xu?=
 =?us-ascii?Q?Gery+umXUm6uUMH+HsyP9ojGlekl9gmXa6lNb1yvMzAVrIiYsa0DfapBVuEH?=
 =?us-ascii?Q?7lPRESxkASJMJqVk7twUyCFPj1m9/GFZ/gtoXlpammWI+58owMCYQzlcdsGD?=
 =?us-ascii?Q?C/hLlO+MtbrZ788E/Km3bAlpnfO/diAglbXpianJ+Hf8sjAtGM8LIOZViLjy?=
 =?us-ascii?Q?9VH1SLLEyoWWmEl9lFgU0X5an7ykz8JltfgRGUatPWFtaPWDLq9sujzXI79R?=
 =?us-ascii?Q?aC9zca4dlcmdNJKKoc8oxmKbEq0oWy1juR7wtgPnF8z11cwCthwbKLJTkewh?=
 =?us-ascii?Q?nWbwx0/+xsHDXQummIieGCiEUnqOgtNWxfB9N/IeD3BtY+ws164nxWbqT0lu?=
 =?us-ascii?Q?7mwL5i241z2uDAqHsHpbYAiRfL1Jdg+iYb65NqgGeT3Q9sfbSF0vDPmQpORL?=
 =?us-ascii?Q?lpxHq2KLhrG8CBqjomB9s0x67609RVEqN9y/xzg5MA0mcQ3DBWamjZiGaIn1?=
 =?us-ascii?Q?Q6HOWVuGdkWlylnyvp8B5XZN6i48p2Ng5fXHz3AVmXuYJIrCJ/jMLFZdyzFh?=
 =?us-ascii?Q?+kW3i6TJ23M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gJmUCk1aKr58DlevirDSCR2UolxJdpF1KALzS9BY/UsRAT9OjduhO64JvSb2?=
 =?us-ascii?Q?O7Fx1HYoVkDaR5JJkfWFAeGKqUlOkQSqhs4/vmFUVPDiCyXU0SNCnmxtlwNS?=
 =?us-ascii?Q?C2IKsQiqTIZGfwfcPqdLv8DhhVJWdZ/dvT7Wi+2op4uKIgiSQC4vttBiyjkw?=
 =?us-ascii?Q?lkpqBcba20o8v71w5Yi+plQlnKuiAestjLPVI2XPWweeDinbMP8lkwDOD1j4?=
 =?us-ascii?Q?35GqrEs25B6l15can1o1gnaa1jerV3Jiv17PPbEMr+W5T1WB776Kx3Xx/odE?=
 =?us-ascii?Q?6QaXey/2TpQdjz0Cy+9v6787sCvtsEMbeFK/IuXD4TMAvdlgZlS7hgsTyueh?=
 =?us-ascii?Q?Xsof1CK0pS9qzs6RJ6niKJ9Ns5cvdrdh9DZFfMx4wMvg4RKG++fri7lh5Y4D?=
 =?us-ascii?Q?iqqnYthgHUMcv0CDaPc8QGAGDLgB9WRYzWkIFr3XUziqmH6k0+xALm0FJUQ2?=
 =?us-ascii?Q?l+BZ/jp9Whol0s1Hdh6Pk0ru/PzOVPd2gEKXUk9ehZN7quNiezXb11cHhh95?=
 =?us-ascii?Q?Y3OarTedCsO9vfd63za8uAsutMIXNuf0y1eUwa1p5ApxtPIp8pCSdfryP0kb?=
 =?us-ascii?Q?qVgFKKRjZFV4Bixlmk5FC4bT44FGSGQjm6DjUQSAN7qmr8JQspd3XyOX4gfG?=
 =?us-ascii?Q?PKNcyUy/uHf8WP5ZKjKw5+QiTs2oOGQ3JkfFqT05GbBUeYOpBG7fcm3TWwYB?=
 =?us-ascii?Q?b1PDXox6zHlXy2OkCZ6dFrTaGGw635ARNixyuLOyVjxfQpQYR2xlqB1l8Kn+?=
 =?us-ascii?Q?RLsWu9lnDWVhJIPME6QzBZdxS0nXKbm/KSprWfTZOWh0Sc+cwYDdhIZ/sBi3?=
 =?us-ascii?Q?sCYQH3uGAkZGJA9sVgAOz8Gf78JD/RvNgSmSO62kmYakuV9vHuNrnDAVpHKh?=
 =?us-ascii?Q?xLMY0aDPF4XkKBjynQIlUBk51zseqgp0IeMVA3xFbFjhini3p+k4WOV4xxA/?=
 =?us-ascii?Q?2a2+29IMtP+FfKJE8iDUScQATxMh6cQxv18d1iFV3qhhaUPXlDxOuJN0e0qb?=
 =?us-ascii?Q?XRcoKnHpmvcAErTXXsXLdbly3gPsFZQOnRUnAy345wMAL99QQjwLebPnx7rz?=
 =?us-ascii?Q?1Rf8trvUfm+vU3HH5/SG1Zckqq3+Mgtry5IjArCN95YAIz51J9aElqF6/RhQ?=
 =?us-ascii?Q?kWXd8DhtUf77qXF2TQcWckh6tpnOF4iDam8eQYmBPXiuBqfbRVHuH3BJiM4N?=
 =?us-ascii?Q?Y2lFlC0zJkoU6xHAr9fx/GfTBhAklYWNzlf7Wf1ZTxQS+8gSH6jwRwBL8Iq8?=
 =?us-ascii?Q?pFgMZC5aJ0bgFZkApdt1IT5Zt77mGKuCRU4oq/2cPtGzBtmPO1nbAR6Pgv7k?=
 =?us-ascii?Q?ML4FeHOm3tRlGFqWnP4EYlv2SjXP4+GVMNpYfRf70XEkLwdtlPCRaRSfuOOV?=
 =?us-ascii?Q?MQ2e/wEKjWQD/QQF5jyHbF0aCpk+Yg1pqxs2eLy/iZkZxUkNgwXgsqR6FJ0v?=
 =?us-ascii?Q?/m/Ueb9tw9g8MwlBd+McJyVmAXwU9eXUjv6YwxrNkmCiCB63XmBzhYS/nTEU?=
 =?us-ascii?Q?9SjVeyOUex9toc/V3R0/hTB4fe/F4bHGdnhJtfUORVf8KrGCqnw5Bop6GbVn?=
 =?us-ascii?Q?aEPONJLivpn2MydoMtM8ILXZopaTJGU0asc/xOli?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab796fa-a7ad-4e0a-9b2a-08dd76bb6e5e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:35:54.1696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjNuCsiyLLKAZENNJCMCLdCbZmoB8w97uuoU1MBAI5S0tLDoSKN8DTeFwzmgJus1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001

fsl_pamu is the last user of domain_alloc(), and it is using it to create
something weird that doesn't really fit into the iommu subsystem
architecture. It is a not a paging domain since it doesn't have any
map/unmap ops. It may be some special kind of identity domain.

For now just leave it as is. Wrap it's definition in CONFIG_FSL_PAMU to
discourage any new drivers from attempting to use it.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 2 ++
 include/linux/iommu.h | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3c32ca2d1aef10..990b932af9dabc 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2020,8 +2020,10 @@ __iommu_paging_domain_alloc_flags(struct device *dev, unsigned int type,
 		domain = ops->domain_alloc_paging(dev);
 	else if (ops->domain_alloc_paging_flags)
 		domain = ops->domain_alloc_paging_flags(dev, flags, NULL);
+#if IS_ENABLED(CONFIG_FSL_PAMU)
 	else if (ops->domain_alloc && !flags)
 		domain = ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
+#endif
 	else
 		return ERR_PTR(-EOPNOTSUPP);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 0f7544b4da9e93..a28c66a038ce91 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -569,9 +569,7 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  *           op is allocated in the iommu driver and freed by the caller after
  *           use. The information type is one of enum iommu_hw_info_type defined
  *           in include/uapi/linux/iommufd.h.
- * @domain_alloc: allocate and return an iommu domain if success. Otherwise
- *                NULL is returned. The domain is not fully initialized until
- *                the caller iommu_domain_alloc() returns.
+ * @domain_alloc: Do not use in new drivers
  * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
  *                         use identity_domain instead. This should only be used
  *                         if dynamic logic is necessary.
@@ -632,7 +630,9 @@ struct iommu_ops {
 	void *(*hw_info)(struct device *dev, u32 *length, u32 *type);
 
 	/* Domain allocation and freeing by the iommu driver */
+#if IS_ENABLED(CONFIG_FSL_PAMU)
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
+#endif
 	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_paging_flags)(
 		struct device *dev, u32 flags,
-- 
2.43.0

