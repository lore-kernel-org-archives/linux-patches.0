Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51881D318F;
	Fri,  6 Sep 2024 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637695; cv=fail; b=eMnNo3LpPqGTQ77ooPfJM9KPmYTtaQfWrwrwOZcQnc0r+PNlgec1eWAipWEIX4D73G6/WAoS2iM1wAk5qWzmkZN+H1PnbqFqp/905an8u8GvibdXo+DW+m7E+5UAH3ic++T/VDZIhBeifFdZsmV1t6whbJw3Ri5u9wHZWuI4SWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637695; c=relaxed/simple;
	bh=/A/EP8ddUZ7jttI4ed+1Xc5ZZwuVLodZCGPeRdJvp0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TjmEJBakyCeLo9DbyH7DngLCVPNAs9zqWY7cJSydevWSmL/Am5lLIdiVuicb+2/wurVCNthvck1R40eXGHPzlQBp3E7ytoBbYiZc0JKjvO6O91ObHcEQh3xzfFLu9KFyP51/gJeL9Y9XykfTtMDPd2iwIcc7MjCV2UfeLw0nWY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LrjwMDae; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LrjwMDae"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ISOr/zRsqTLnlXKXZjcmrp6keRJfymdWiFavBJEvmpX8l11tgVmFoN17r6Yj5tBWQGkd232WgTUqmhkkQ8emDvX315OEXmOo9NvYV1RXvaOoQSsCSjmEodtmbbUpIxUpHTOS1qVW2UFjCXXkf0SSCL7hbeOi6UjuK6z8GbRxvLKQYl/Y+HI5L7ex3MdyscHUauP1d2JMPz8cf3lYEQQ+6PfPwXuSG2jzSLcTxHm/Ar/Ei9QVywuGwpeXpdVbsoAOV8OA9wuzVP8S+OAU2k0R74fqa93145BVpR5y0n4qjsDl0mpbyfZd1ywH94W77ck12wtanfolPYfl1uyGoLvaNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VSx7GJjByykq3ngj6XltgXHh4Jtvz7TnXubglStN+s=;
 b=W7Eb/q/FG1yFd9z46QUVn1uCbmLk+gCI7ejm5iqbK/Aa/yVdzXDr5HwRQbNRruYD+a+6EMQ+oO8IbDfZ8ceI3CJBR+mcvN2GnAePOwvIRBph+w7th0wgvLgTKmhRvQgFDlG1z9fOIyDxwV2JTXyARQg1YfSdYt8NM+ZHsw10Pwcfcq3Ggn8sGd+X6XRZCsDMx6nwaYVsNySxTQY4AozGkqMCDZRwMevCYcxoRNeDWmddehlFWoB/8/r0wVE2FE1EpGT+VC2eCeCvWHiuXb821Nq3FpKJ6RA3WKc5UGiZ9LauIHMfHDwfz/by4LfOj2v1ggn8CQ3NTFD+RnGbN4duog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VSx7GJjByykq3ngj6XltgXHh4Jtvz7TnXubglStN+s=;
 b=LrjwMDaeoMeLcspnCpTs1pW/qMJ7qWRkbWGw25dqnGL/jYwblQnqYYSHywrQbwVYq77dtBIZWhwWiiUwrt8tlCP5dAA2XGwsz4kAVpXOcqpD3/YN821gsgFFeKt8jGsNA3cuRTtS6nV9Era02me0oelqW7f2BTk77vtxU5nWbPC+PDmPMeeQn4mLGWnAfritq93kDu4t5VB/QQHvha7QqLssw5vyLAhwa1DH+ZFbcp5MmKmUsTMJ6FU9kgTW72FnRVVdOFeDQJUY9HllnAfLOs+ENR5vzfk+xUjNcS5PEYdTPriMAyTpeRAy67YAytRNETgV80uLtPGP7ger6lLK8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 15:48:05 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:48:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 2/8] iommu/arm-smmu-v3: Add types for each level of the 2 level stream table
Date: Fri,  6 Sep 2024 12:47:49 -0300
Message-ID: <2-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0008.namprd14.prod.outlook.com
 (2603:10b6:208:23e::13) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: eeab2ba3-4536-419a-4a44-08dcce8b4791
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pOtZYJH9AAQmzTeBisKdy3H+QuY71utvSknuAXwUZWFrl8dTj0z3zti59AfR?=
 =?us-ascii?Q?T3BgWVlcvjrNWWRhyzfkcjOAAJ2YyEXkTdGdAcpMCa0Cjv4h4oQ8YKIvwwCt?=
 =?us-ascii?Q?/9+zzeJ0ptKOsi9Zm5bd0TPr8Ojvo9gfHXmRKkyJku5J/fDwjeojKMezeXiX?=
 =?us-ascii?Q?eSwI11fr7hH4+Fav0UtJQULEWl4IUif3zi8Wvz1sboBwaRKFkU/tL+kKd/p1?=
 =?us-ascii?Q?u0lBhW7Z5ScVtnnnKB6mSwZolFYgwKHzafsPKotU1zJD1JGohrQ2HSzZG4fM?=
 =?us-ascii?Q?6kl85okLS26i3NRyzSx13I9FU401YcUWmmSuvS8QeJzQp/XTf3BuwA58LNe+?=
 =?us-ascii?Q?7lKVrGD2+Z68XZ0b0jsljRMN1UCkLuHfNx05jQldUQDACInSgCusn8RqRLEX?=
 =?us-ascii?Q?PkMOJ1JFbJHgf0Cc/ZKzLXehsDAFMEf3RLfr0achQ1iE2WKzxAaaNaM+87jz?=
 =?us-ascii?Q?6rPIdmJPoWGaDyU8cGRY3zNXJH/wrFVFg2ZVI4hsIAGGvWWyQG3kZc4AmDPE?=
 =?us-ascii?Q?3TmeSG+UYCUaU4XGvH5ueVyfBTRNu1aLvbQ9GXlvT+peQlBTzyztGthmsG8c?=
 =?us-ascii?Q?I8AKbFHxpC9tAVQGHjAbIlbEP0tfL4utCGwC2Cog6Cu0y56kfaImldGboVAj?=
 =?us-ascii?Q?O96e7a88AJmYebIluM/JKZMsR0XFVhIo1IVsOsoMdMR3pkfaWMC7rvlNMN2m?=
 =?us-ascii?Q?p2DE/FTem2Dxq8IYn2uP91lIBzO9TlQVbdmaj2Sz4JoUMApI1lV5LB4pVesi?=
 =?us-ascii?Q?1MMWvaWAAemgkV1gwutYq/5+rJ4PaWRV04fk1fGhIrUOL+bwalVuPc89oZei?=
 =?us-ascii?Q?Z/fnY+G4pIfS6iw1UDEkgF3OBqOSbluGU27h7plks8B1OtQXOoiAzoeWVyrg?=
 =?us-ascii?Q?JUAvknwnp+pMV0itkGRT/VrKTZvJeOVzOPl2y6fRfDVwfjdwv0Y63VlXWPFG?=
 =?us-ascii?Q?/Bg+Ws2ykfpGHu4o/9RCx9XMTCnP503O5jX0Ozy2IHYKy5+ibFgkVqCWbx+R?=
 =?us-ascii?Q?7LGoQCKVB5gXsU0i8+JlAGEnsqe7ZeEP07F+CJD0kk4r98BUgcbE1iGfgvIz?=
 =?us-ascii?Q?+1qjUzEvENrwZM6zd0t6zqyXG3LYbAU6kmzDCrqyjuCRIwEkuoQVG6/ot62k?=
 =?us-ascii?Q?E5DTSdSPTjP4Kp87rwJB2ipIrp1kSmGeQ44dl4SbC2dq9P5vXeG7KIrWxseO?=
 =?us-ascii?Q?A+D0iidIqYv+8/DUh22EwP+Qrq6QfhC1Yk0zdQhwds2+om+xWHrDHs7bFM2Q?=
 =?us-ascii?Q?Q88IvGLJvh8rlL8UvgF7LD+5Oq80rIhBD0Wxtm4bbU+K0ieiHlgaZ/PmIT/c?=
 =?us-ascii?Q?X87dTczYM7IEdo8HAD4MRO19Gan8AR7Js82fpv7vDkvB8Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jRGkbliVUwliP2b0B1hrkiyI2op8TG4+PYZHwk5SfobqM2O6rA16EFn8KzoB?=
 =?us-ascii?Q?sHir0B2fkouyRqehrIAI4xUSLXKW7KRfGZ5eWuY/3NBeRUAhuioGZUm5pfGR?=
 =?us-ascii?Q?tjyL2HSqeRltQjFVGWYuFz2HWo21HSdTB6C2D6AKMURdBISyVEDSmzsn7gEF?=
 =?us-ascii?Q?9AQN0wjnsIu8RMoq0Ygrveb71ROQT8g6ZeCENyw7IYZ6zizE13UEMYxtGcqk?=
 =?us-ascii?Q?0PY08/iVANH9Eie8d/b/3SY+qh9TzmipdD1KmwPBJs2fJfdldrP7O8n8V5fk?=
 =?us-ascii?Q?1FUAfdFotA2v44geLSiLUv5o3HdvawetqLw7Mmw/YkXq2F1m4OCKQnp5QpsN?=
 =?us-ascii?Q?Li6MyhLGSbFnqoolAMhY4YXUoS9V+oEodUhmAcyqMGB+9elHscL52JMn4S2e?=
 =?us-ascii?Q?Sn+z6UdD0piBZ+PRqfXIrnA+m7EiP4W/puCet7ItUnkPlqnTiY+sIfi2DgZg?=
 =?us-ascii?Q?eqjAS2QlwtJqHTXgjVJIdTiAQIkgBWMZ6MqgsMlGVLgYVcvj/A/v2tpkQ6nc?=
 =?us-ascii?Q?02SkjnOX1CvwPu/MTu7nwjYpo+nltzNBrWNptzeW+1XpqF2AqQEsUNBEiT+G?=
 =?us-ascii?Q?JZ8xz20ygz55Rv//VNayO1AGAbT4TRETpSTcXzbKjBnZHTgJWpvzdbVrM8S9?=
 =?us-ascii?Q?KvZE6TRGgYRlgXWaJzlC2apvMqSPlNjRNRqCieHKAsTmrcsOYjhkWdZAdXOh?=
 =?us-ascii?Q?ORWP/u9150IAHlNQl3PgR8doBKxn3Ifxv14fcpz6Ret5K2kuNqe3sQEWq2oX?=
 =?us-ascii?Q?3xi+hstBrKveSx+sfAFb3Qe2ffDtUP+3/bxM5MEaVjqmOVRzCmDgSM/FOnSs?=
 =?us-ascii?Q?xucxdt/XBcAg033MXQecOLDv0cnBjwNbCJ0QRTS9kNxOpmiupG8BS1vifRNr?=
 =?us-ascii?Q?ejrDuIpjhXWhPZ0XAOGnlbx8j0AmCE59Ce/MTsFXVQawB5X60noCFD1kK1GC?=
 =?us-ascii?Q?Kg1Ny7T+eVdXeSQJ8bEoTRbpRqFN+gM7rVl6Etfe2cjQq1K2bZDGiA0wFcvU?=
 =?us-ascii?Q?RNaG+jWKfnWJ3/XoqLFfFurweLn3J53fHWCc3nNBwJMN9AE5FFfOQbBhuqmB?=
 =?us-ascii?Q?+Sx+Qnb2Wy79S5gJsaC93Mh7lZiFSeJxYNiG3g26FCTqTUlAeL8lZJ/PSIEr?=
 =?us-ascii?Q?JLwr5zD5oKUTMWAcXvVyzpTT/dnja0PhPJdHXSLSm/Fmm57RExapypArD8eW?=
 =?us-ascii?Q?g1dkvAczSD6sQaRI+EsSfLRI+7Woe8lc7vPWlgndPs4/Xcw+z+KYaqCkCCqv?=
 =?us-ascii?Q?mClkfxAuI/dmjSv1SH79D+bzConVuce87ftyQu+xQ+LU+ac25jYCXvt2E8Lg?=
 =?us-ascii?Q?Ry4WvTwbPCDxlfn2BHE5q+xYDsFJVAVCqxxoMWDunKoe5NyisZaKklrLfcYA?=
 =?us-ascii?Q?Vy96xX54XAxLRD2X/7dFMVWjfYpTZRnIw54dDBbyO+ite9r2uvVAaIqPzl0B?=
 =?us-ascii?Q?vO7CCIVVmqnVsm8mD792z6JJBthdIyDn5H+gyzih+0B0cMIxlK6oJ+Wacc7l?=
 =?us-ascii?Q?XHH+yC+GIcQSLyJHISAFsFV61wWD1wuXdOhYGhbWjruBCuA9F0xXpwmoNzLD?=
 =?us-ascii?Q?t2qN9jLxsKNb4muw/oKMqs7W7sHxhXTPYqKjcl2+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeab2ba3-4536-419a-4a44-08dcce8b4791
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:47:57.7368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kF+U2D2lUfHQpjFZiEv/vpZ4r8ZsAFEvlWIc7P2QhhEeS7FINkBLjMT/6y3uuwOS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

Add types struct arm_smmu_strtab_l1 and l2 to represent the HW layout of
the descriptors, and use them in most places, following patches will get
the remaing places. The size of the l1 and l2 HW allocations are
sizeof(struct arm_smmu_strtab_l1/2).

This provides some more clarity than having raw __le64 *'s and sizes
computed via macros.

Remove STRTAB_L1_DESC_DWORDS.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 21 +++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 10 ++++++++--
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index cdf146bad5bd24..f9faaec946c294 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1496,7 +1496,8 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 }
 
 /* Stream table manipulation functions */
-static void arm_smmu_write_strtab_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
+static void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
+					  dma_addr_t l2ptr_dma)
 {
 	u64 val = 0;
 
@@ -1504,7 +1505,7 @@ static void arm_smmu_write_strtab_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
 	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
 	/* The HW has 64 bit atomicity with stores to the L2 STE table */
-	WRITE_ONCE(*dst, cpu_to_le64(val));
+	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
 struct arm_smmu_ste_writer {
@@ -1709,18 +1710,17 @@ static void arm_smmu_init_initial_stes(struct arm_smmu_ste *strtab,
 
 static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 {
-	size_t size;
 	dma_addr_t l2ptr_dma;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 	struct arm_smmu_strtab_l1_desc *desc;
+	__le64 *dst;
 
 	desc = &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)];
 	if (desc->l2ptr)
 		return 0;
 
-	size = STRTAB_NUM_L2_STES * sizeof(struct arm_smmu_ste);
-	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &l2ptr_dma,
-					  GFP_KERNEL);
+	desc->l2ptr = dmam_alloc_coherent(smmu->dev, sizeof(*desc->l2ptr),
+					  &l2ptr_dma, GFP_KERNEL);
 	if (!desc->l2ptr) {
 		dev_err(smmu->dev,
 			"failed to allocate l2 stream table for SID %u\n",
@@ -1728,8 +1728,9 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_initial_stes(desc->l2ptr, STRTAB_NUM_L2_STES);
-	arm_smmu_write_strtab_l1_desc(&cfg->strtab[arm_smmu_strtab_l1_idx(sid)],
+	arm_smmu_init_initial_stes(desc->l2ptr->stes, STRTAB_NUM_L2_STES);
+	dst = &cfg->strtab[arm_smmu_strtab_l1_idx(sid)];
+	arm_smmu_write_strtab_l1_desc((struct arm_smmu_strtab_l1 *)dst,
 				      l2ptr_dma);
 	return 0;
 }
@@ -2487,7 +2488,7 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
 		/* Two-level walk */
 		return &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)]
-				.l2ptr[arm_smmu_strtab_l2_idx(sid)];
+				.l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
 	} else {
 		/* Simple linear lookup */
 		return (struct arm_smmu_ste *)&cfg
@@ -3643,7 +3644,7 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 			 ilog2(cfg->num_l1_ents * STRTAB_NUM_L2_STES),
 			 smmu->sid_bits);
 
-	l1size = cfg->num_l1_ents * (STRTAB_L1_DESC_DWORDS << 3);
+	l1size = cfg->num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
 	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
 				     GFP_KERNEL);
 	if (!strtab) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7d8ed274af40e5..b25dd72179415b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -206,7 +206,6 @@ struct arm_smmu_device;
  */
 #define STRTAB_SPLIT			8
 
-#define STRTAB_L1_DESC_DWORDS		1
 #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
 #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
 
@@ -217,6 +216,13 @@ struct arm_smmu_ste {
 };
 
 #define STRTAB_NUM_L2_STES		(1 << STRTAB_SPLIT)
+struct arm_smmu_strtab_l2 {
+	struct arm_smmu_ste stes[STRTAB_NUM_L2_STES];
+};
+
+struct arm_smmu_strtab_l1 {
+	__le64 l2ptr;
+};
 #define STRTAB_MAX_L1_ENTRIES		(1 << 17)
 
 static inline u32 arm_smmu_strtab_l1_idx(u32 sid)
@@ -608,7 +614,7 @@ struct arm_smmu_priq {
 
 /* High-level stream table and context descriptor structures */
 struct arm_smmu_strtab_l1_desc {
-	struct arm_smmu_ste		*l2ptr;
+	struct arm_smmu_strtab_l2	*l2ptr;
 };
 
 struct arm_smmu_ctx_desc {
-- 
2.46.0

