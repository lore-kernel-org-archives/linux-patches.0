Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56F61F1520;
	Fri, 25 Apr 2025 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745586524; cv=fail; b=oEg90LMOyhdAl4KvvfrezMQvAKJxN9nuobtg2nI+64bUpTtcuL8+Q8pN6FxJzJJjzd9QBMMm+XNlfSqtf3PMj+k+dgLc/+M1zSZkBsii5QN9OxBTxHMOoZmdOmqVgMVHU4h5iF+kwXOXqr6gBt7TbGlX8jkjoeNXgSCy5DQRp2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745586524; c=relaxed/simple;
	bh=8friq0zW0qwZey6GBFS/DnGq2avvFgCZstk3RoX2sfg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=D1I1+QysZ2kguO2HI1LzywauzGNBK63VQrnoREYQV+UhIsHxvFqM3RjNxTCmb608CNb0mj9DnTA7STkdxfL1HdX5JXOcpixqooMmMD6LONXCuAZBWkaPtEV3FpybdI6Pc5SjwDHYvm+ZjPJgy5kdO23x0DEAq5ava3KjIjX8Cm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lCx+Qs9X; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lCx+Qs9X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OG39LgzSvWmWFQL3e24YkjwntYu9y9dI/+e1Xa92gm2SBV18ZLF6FZ3rLMSkS6/YHQXgfJ2Wl/dtRo3+LLvM7GQxE+3FolKXNvKfEtP6XRDI6UoWFdYekzgVZ9z7z9YS7iQF5amnog0wJLe9UOQ7DlgN1C62BMdqF92gRltjgohz62/edBSpQRbxfScH6HYqhlw8Z99Kdwt8qfa9RNIYgE+22aW62wGlGZnRnCGW89VgCvxTlVsWViWQrwxDp5B72T1si8gYi3+HTLPDJQWjk35Xs8BBVT43X4USwbmQCB91rNxEfE2L/2sKse1iK9bmS0YqK+wpc/IX7+d1oLQdfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KW8qsIukFEVxW/x+5WPOtCiGPzWQcertRnP2YmPaGo=;
 b=AgQC/VGTNQS2Gd1jxGPolKOmWi+YTa7r8ZUgttMFJ+1yaGl3HOLkN7ojfR9s65hAMQHzLQrfFH6RPHs58u5DVPIUSWS/8ZHLu5OFTRubjFxTpfWY0xOqGmBi/KEgpPzQYqe++bK5h/iReYpJuOcWr0/p9xiUVV6TZ6GWd5F3SHf7RoZmFykZ/h8ySQnG+qq9EYDNAoRiXNBk/pW9Tr+pMbiXCXNPeC/qo8p4xl76Nx3baJeUUg6D83flIIuCmRL+lTN3TiLVhvSa0FcEWvUqP5oQ6vmYsV0BKbW9c1U80pw9dNiK6Su0sfeHyJ9kZCsyAKqK2dBU0SF9LvXmXKFzkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KW8qsIukFEVxW/x+5WPOtCiGPzWQcertRnP2YmPaGo=;
 b=lCx+Qs9XQhWqOibRYJ2A4RNktuOhAoZj+JOWWxPMUQWivNay/FePXXwawVAWyThH+0xodqAy3EX+N/ECzkQFQ/CJEEgHrnZIorFw4V1j42ai1rZRSoC6Ww/LCuhuhJQsgunWNOPhFrb0Wq+EUl4KC7Qd86RmDEyqVseQC8C8AryQp1f8Ex6PexBdMJ5H5YYWHtJhwGThhUu9DYvzd88Q5y20ZKyCFHqz6+3/Z4TZL9EM5WVR6YYi2eXAZCt/7STbhCO12wAKdXGm4ROGTAlvO1VaMkH8pxXfd6dx6zA6UhNREvZTSZUYxcakUpomu/ltyQ/YveVlWMEjh0znwGKsSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB8585.namprd12.prod.outlook.com (2603:10b6:208:451::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Fri, 25 Apr
 2025 13:08:39 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 13:08:39 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	"Isaac J. Manjarres" <isaacm@codeaurora.org>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Georgi Djakov <quic_c_gdjako@quicinc.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH] iommu: Protect against overflow in iommu_pgsize()
Date: Fri, 25 Apr 2025 10:08:37 -0300
Message-ID: <0-v1-3ad28fc2e3a3+163327-iommu_overflow_pgsize_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR10CA0028.namprd10.prod.outlook.com
 (2603:10b6:408:143::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB8585:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e6efa43-156d-46d8-8709-08dd83fa4baf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q2dO7NV4kH97KSB9GOFYww8mAscxfvmKc/6bExMZF/bARs9t23eq7bfK6h9f?=
 =?us-ascii?Q?LBJ2gxYpypelFNRTCWT8ynqYk7AxP3SEY3Hxv4OvO17FXU1mGqQkpnkbDAJ5?=
 =?us-ascii?Q?iX6c+ebkb8dY5GH5u6g/1DKCDbZlSeQJCNefSPnvYThiPje0/7VdOgHonMt7?=
 =?us-ascii?Q?Le9ubKVGtvyvqP1DAKqhcaKpYDIuY3vOHTlQBEVRutCxmKLD5J7qzE59Zz5q?=
 =?us-ascii?Q?uGmF/kjmxmc4CDgA54rfOiNIkgzdsxDNm5v3XLrL1zu6Ce5biBmBgT4ZlkIC?=
 =?us-ascii?Q?5JByUTsOSkIFna/0Xd9YdNXe5q6xYBwCAkwNPHMHORZRrWbkDHT7XaPJ7qEZ?=
 =?us-ascii?Q?u7W+kyUgEmW1v2Gv42e+fbLeW3yOJQbl+1sCwm8i2X6enE7VqBDppb+GRqXK?=
 =?us-ascii?Q?Udn66NSuf75uiZadbFrkVLClPGjTTMV/nGyynONZN8+1xGGnJKOU3oH6yPz5?=
 =?us-ascii?Q?yoLLyq+OFoYeA7eC1VY3Dn66AMPUJKcSAHlzrDOehVT7imLg8F/p1HTNwKxB?=
 =?us-ascii?Q?I5SsL1EMgWPd6icmnNFQGHGdck4dN5RBMhZkmsvCLch3i9zIENrEODz+6EbU?=
 =?us-ascii?Q?shy3tDz/HHiPJZo835p0K/bEb+H5pgCq2VkTK7GBnMzqu8iVp9NuDVz5vTXw?=
 =?us-ascii?Q?ljyV9A0j1ukcHX8m/OV+mG1jVyO4Skgx123O5n87MjPylCtffdsmf29cxHmZ?=
 =?us-ascii?Q?Azx1YGoeBxbGeWzuQYCW4FKZbyrXKuaTHYZvPlYruLDS9Kbv2Kgt9u/IEwXk?=
 =?us-ascii?Q?HcdQFt1kKtctcZiNtsfFuqhPV9YpySxDK+KBJ1qe7VI9cFD6sZr2q1BkR5NE?=
 =?us-ascii?Q?70aClWladokyCTktPOwaaruSMRHwK2vBPcaqAqMgVLdIjf9Q4sILic7q8SXk?=
 =?us-ascii?Q?OXEvi3Zjqk5jwyVs3UcnEaUQaEgHUzs8Gxx5nc9k5nODJloFJbjkpFJ+nm/7?=
 =?us-ascii?Q?7A0YF/NiM0HnzPdaNVt9RxzFDz+4LtKXWxGEq+9FmstBtMsnoV5z41hCjyRG?=
 =?us-ascii?Q?/rxleiK+Wikyt2BN+zNMW88+J39/vQlqAZmXQxRUO9jEuCUbJsJe2CfFgb6a?=
 =?us-ascii?Q?/xwj5NvzeKgTdqDOzdmmJ36Mt0jf38ho8WPCrRjZktvu1RWo8b9A11JExFJ/?=
 =?us-ascii?Q?OV/C32drfnJ86Wxw2fG1GZCltlfy1WgclaSeuytch8nwWguS/8jg3DfagO5t?=
 =?us-ascii?Q?CholvdSIvQsFcU1OE0Oy2fKTozC9Shcy4ve2xGNEHV8Idzj2wpiWKVEjLWOV?=
 =?us-ascii?Q?2YSsKbQtD1PMV+4VSmRv1Eic6xYUj2QXDt9tx5UAn6RUV3JhTKPGdPX2aP2k?=
 =?us-ascii?Q?DE1RX1up0xfogc7moaYU/VcxA/VOtlZrFaNQAMdeNkMBCitIXOstqgl+fLTs?=
 =?us-ascii?Q?gOOLaCSf30tlJ2mTRNmuv30nrlbVsRpfFEdhuZVwckzCRk9WyKAHJUxktOv9?=
 =?us-ascii?Q?NITZHjHvxfg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nyk9KCWWw+RCchtsgOStrRJz79Otg407RqCovvr4bKBZ6MpVzHFu/G6nXPuu?=
 =?us-ascii?Q?/XKV+HlnJEwzKkKc45tJOpE4+J6z1pzWlBHqiRIvNVxa+4Hre5ZEqBk71b6X?=
 =?us-ascii?Q?OsGPrtO9DycbuIOOJLVDBeOf29FsBH5Qyk/UGqWSRViRWGGvku6m/Y8a93I4?=
 =?us-ascii?Q?AeHBXvoNj082IUs9noAlhJ3d0dpFtTEtEFeJ6vONGMbRz9X7ly3d0Ae2pKu3?=
 =?us-ascii?Q?tNwoe014H1/LRJMh7+UH6fM3sqWwcZa/E7KDD/TDPrX0cU87+5++mKcnTCRl?=
 =?us-ascii?Q?M0Bn5qKgUBP5gqfBQ4JcN9dJtPIYiPIkdIG1tMzHlqE1De0iHXwZC/CH/8Jh?=
 =?us-ascii?Q?WkREf9NlFS7DOQ6wQSk+/fVtX8dP74HtS5i+q3Ny4pkSZ8yJBFwODo2Xx5Uo?=
 =?us-ascii?Q?T8F57rnkpF8nybrlwpRoi+MVwRcZ6Y7H8MB/MLxvH3gXcoiapov1Iq3pV3iZ?=
 =?us-ascii?Q?C4yFsYDAkOIVS2ga/S6T8YJDFHaQym6dY1eLbmEs4eAmAdz6nWIutGouDsK9?=
 =?us-ascii?Q?xUqYZqK2V6bai4bu/+IlnqEqGTpqqT9a0McbNRndwRfOA5cUO1TMS3Z5XSFF?=
 =?us-ascii?Q?w6alr4G6lPEZRTicxy1I8VzU6Olo/8Jl+KgvpQXBGlTXFhX7bGwHWDnG5n2p?=
 =?us-ascii?Q?iKEQ5lWzDohYXMCmch5emNv8g2NYWA6vEgUv2Y+IgUjcv/suGtI58oXG7Nir?=
 =?us-ascii?Q?CGeDO3Ppvz0tNvEHMQSAClg78KRgwyEz8jGOsgfp6fWCNeuxU/6E+JMaAUO3?=
 =?us-ascii?Q?yVQm+5ad33GsNZl11Shjk4Tt9Suu9eDRg1Vs5RcqfuPtiwMh0qy1lkAklWed?=
 =?us-ascii?Q?f5e9aIR6+OTST5slI3hprwxP4VIt+/WsH5RCmfTedfR24NdI/4a+C1x4nJUz?=
 =?us-ascii?Q?iQgXwL3Yvb04WJi9ifdPSRi0MILfJER/isJp+JsmhYETh9uvW3vrDL7+Iqf/?=
 =?us-ascii?Q?CF5BbPpAIh8xwo0zvSR7jFaxq6KRzbkZLD+HFaDGIhcg335Rc09oNuyk49eI?=
 =?us-ascii?Q?4+xldrtg46oJmiGtsaUhq9l5Z3E+VtB8e7x8VRSdhFbtnrtvSsnUBhy357JR?=
 =?us-ascii?Q?4re5bb7GecaLNnKkO7SmAKcFFu1YHTYA91GuOx4QqEu5/EgefliQ6Y/vk112?=
 =?us-ascii?Q?JxJuA4QpcmkfPw1EB2yFdxIdSM6ATnBetCb186fPhbuJOP7a7BCpr1ZK7a3N?=
 =?us-ascii?Q?RG/HCzfpBFcxUuGABV3oEY0yx6Ags8ebDlgp+EkFnpnvolELmiMkWf/2cqTL?=
 =?us-ascii?Q?AHLuAXDZtSWqAgHmSsNezwTrDFxkpP0SUtRIwk81uk00E+CT7TibNSG6k8Yl?=
 =?us-ascii?Q?ZkAGK4n/tS9Moyc1QpV4VmuRY6t2oP2dDN4OLnXfvLPHtaHfL7x0WdPLllqX?=
 =?us-ascii?Q?EsnM2xx8yPXfQIx7PxpSSLbrwmhvR1yxvsipDfsVPjdHYMbANDAbe32hrui0?=
 =?us-ascii?Q?RN1tLzi0jHlEq48njwdUsozTs0Wq0iXsDXrxtZLEuTHbP4EtFtJF1svYL77h?=
 =?us-ascii?Q?5QrLWg3Ibs9XOIbIbEY+KnkrMSpa8On+btssQFh7j8JEQaK3pP2oVHsNYpgp?=
 =?us-ascii?Q?wc52PsLWOq4s5SilxIb43zvwctszY4IzTZZyIHTj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6efa43-156d-46d8-8709-08dd83fa4baf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 13:08:39.3077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJpjp0yJ7F36usg8XjS/iJz30l+mVQOPY5zYbp8mP7fxxvP5MWlFpJOBcS7PH7Ct
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8585

On a 32 bit system calling:
 iommu_map(0, 0x40000000)

When using the AMD V1 page table type with a domain->pgsize of 0xfffff000
causes iommu_pgsize() to miscalculate a result of:
  size=0x40000000 count=2

count should be 1. This completely corrupts the mapping process.

This is because the final test to adjust the pagesize malfunctions when
the addition overflows. Use check_add_overflow() to prevent this.

Fixes: b1d99dc5f983 ("iommu: Hook up '->unmap_pages' driver callback")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

The iommupt test suite trips on up this, I don't think anything real would be
able to trigger this. Sorry for the second email, I typod and the mail lists
did not get included.

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c8033ca6637771..642d0a03172b0b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2392,6 +2392,7 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	unsigned int pgsize_idx, pgsize_idx_next;
 	unsigned long pgsizes;
 	size_t offset, pgsize, pgsize_next;
+	size_t offset_end;
 	unsigned long addr_merge = paddr | iova;
 
 	/* Page sizes supported by the hardware and small enough for @size */
@@ -2432,7 +2433,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	 * If size is big enough to accommodate the larger page, reduce
 	 * the number of smaller pages.
 	 */
-	if (offset + pgsize_next <= size)
+	if (!check_add_overflow(offset, pgsize_next, &offset_end) &&
+	    offset_end <= size)
 		size = offset;
 
 out_set_count:

base-commit: 2a485c0aa33a8cbf224d92667d2b274e1fd3b300
-- 
2.43.0

