Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E36C13A88D;
	Wed, 14 Feb 2024 19:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707937801; cv=fail; b=dOussoQM6Z+we7qUs9I+PW5wtt7HfnouWOYtx8WMSnizetq6SCJG1rJ5v0quhC/9nADbOZIgtiuzyGw04d878wuxLp7+ucKu5Gc+CX//L3uxyfcxgpqgXZQ8P6j05bP/qzuvAn1MXZC0TktS89dhxnJnWkVvADTThFUvjd06nP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707937801; c=relaxed/simple;
	bh=TWnNY8a4AqR/18YdwQLRxGaly8OoOqguJfyyvRVM0n8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KiOtnBfb/d0lIeFYAWGfTMFdwxNvvZufOqfSFh69F2ldn2FZx6QSGSo9e9gi2EdCWi6yji4RDGx575wmwtOeu5j6kq+7sZqleRys2aZXuuVon1BjJDhCPyL9WgkX9NtoxE3nAQMVl5bmgiDgoy/IgEmiL3UMpxY+an7Xazoa/Ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MfP2/axN; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MfP2/axN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzJVczwP33ccGgeZwbDCOJKTjf/yJCCYowMRFjryti7itM99JF+VdPhYnp8nsKhPGcbdNpXVl95zS2emlkoTJ5dqiGzmV2AtKvH00Tg+ImvGmFOkcWVu9CGjY5vZ0Io1T26ly6NcvgWTstiul3FOZFy2KKRcJqQFYOZVFtcFjAJlsZGxrWvLtEOghDfpEX0NwtQZ2uVp4AHAq4mVxyljneluBtJJTXX9lg5s7I1PRfQ/fOMQsOCxRdgluAXFUgNH0GGg1ENaaGcJYWhxx8ijNCAhht8rFzwy+pm1nlHX7F+1VVEFsi08vlXvMZVTwIg+VAjhYUdN5GUtRcfEt+CK4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjPSRiOL4c5LtIjw3rKiQB0Cdo5AcMviM8MoRZN16As=;
 b=IQIoznOkLSjvCJP8YVnbovSyr5EujeZpIlXNF92fg6jcU8SC2PY3u1H3K/v6cl2WtccP4V3OVDRo84U8kwoaAXmigdlcEcwFHq8MoXYbvWYgVFYcIqOl1D5xySpzuizVl700rThPMe9kH+uA6EUsjI8SdiK0uJjnDOdKMtuab2aoDd7femra0qkLeoYfJpt6g60z4L6K/gPSPKXjCkUrZdu3fdwul/9+/lQZHZum37BLsJkkrw33Fb0Vl7PyOdNP5XYo+U8iLMopvqvmI0XRgPKSXJ21+GBficlNGmNPoAz/q0Br8AB0fxblFLrgUZjTNWKqWokt3iDP/H6qj79eEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjPSRiOL4c5LtIjw3rKiQB0Cdo5AcMviM8MoRZN16As=;
 b=MfP2/axNLfQI+jA7UGCzjuIcoX0OJo09a0J8nWkzFTAGxkAucKJX1651nSxg48k/aL4QBu22MoOf2INxfAX2dkxi3PDu5bmznMXQpxUM4y22jzz86TujuSksN59zDqvXFU543csqi5CPkJrHf7PMY8susNHNluyfvMWCXfok5GRMa70xI4524rz6Oykb2obv/5oFZ5F0576UWFxvNSaxypHY7BqVgHKMH9/E2xkQvpHgHXd876b0FDXUClHUTdc+O47O2wc8uhFIh/ttzosTYzQNnmzPx5pP4FsGuu5uBGm9o6P5OJiNdqqBSQBXVulrldpyNaIovLLGkU0QBGT2rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB8765.namprd12.prod.outlook.com (2603:10b6:8:14e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.24; Wed, 14 Feb
 2024 19:09:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Wed, 14 Feb 2024
 19:09:55 +0000
Date: Wed, 14 Feb 2024 15:09:54 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240214190954.GI1088888@nvidia.com>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
 <20240208125846.GA23290@willie-the-truck>
 <20240208142729.GH10476@nvidia.com>
 <20240213112015.GB28517@willie-the-truck>
 <20240213121850.GH4048826@nvidia.com>
 <20240213125456.GA28844@willie-the-truck>
 <20240213133045.GA989297@nvidia.com>
 <20240213135627.GD28926@willie-the-truck>
 <20240213140033.GB989297@nvidia.com>
 <20240214170030.GB31927@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214170030.GB31927@willie-the-truck>
X-ClientProxiedBy: BL1P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB8765:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cc56067-057e-4950-8fc3-08dc2d90877a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1WMmZTjYsfrrOpW8ExdryzNRKaNmixq8T8pTbv8+SMFsWVdzsudiICryxIewl7HI3c3MjZr8oHZmHC+cc1PABhZVL3/D9WyxYmxlauvZp3UjfrHWA+3U2p+e1pvgmsnpfchBLJBI81duJEyJhfGOKDTiuffIJasgkvoWMINY3l1MSMZ9OvQ52CNyDE1GuXqhZiOWOc1BWGWlgbAkCFIRKtcc+0rgHSfYzZETbQpUtV9a8FJxd6m7f9eDkElPMN64pnna7ZPMKDHqIdqfOIUl91Qa7xqjgxGprE3EDcc5yFw3Or0M1zIq9aDF8Ae5ZIT+sUmI2lu9WDjU1PjUT20N6sWxH1gUO93XsfrAfgLTFfj7pROVhIo+M2xKRhGoYKNR5MLvWPTLof19s7z3ofloBchALzYoFMz9D2PGdnL8F9wxU1Szk8KNL4b/mketJ/ll66iHWY2g0qEeO4me2nMMO1tgwj+FGxsFnA32GXMBQT9i/bt3cBz4ZZA1LuicuS1I5mVORvTtdAaNjsCk9o8LzwElkDbCczOw0MmOkSXPr+wTwkJcB+UiIGnps8KO9ra6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(366004)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(1076003)(2616005)(26005)(83380400001)(38100700002)(478600001)(4326008)(66556008)(8936002)(6916009)(66946007)(8676002)(5660300002)(2906002)(6486002)(6506007)(6512007)(316002)(36756003)(41300700001)(54906003)(66476007)(86362001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A2kRSZIBix6mD42UjgeQAglKz9eh9bkBz5O/5HFLl/gsOr1LT4G8YgigzI8q?=
 =?us-ascii?Q?n1benItyOVrz2bhXK3f0XlPAT0nLNEeMcvVLJN4jaDdsa7j9PnePlqvEE79Y?=
 =?us-ascii?Q?x+GgjOII1iK7CmzPcPnnA/uc3SpTZ3SaRLuJUHIwIb+xT0fBysdlwb9Mt2He?=
 =?us-ascii?Q?m0W+kC267x/aMDzRV0RqdbWz/YiqyQ+6DtRw1wJpOqBFWgybW8QkhgeBmNTa?=
 =?us-ascii?Q?cj6GhZVGsp1PIxentyVYpqn8QARub1K4HuWxP65vQmUJJjhVNlxRcBTBCOMn?=
 =?us-ascii?Q?UJvBcffYr+AVShJNFCBlhiDdff2yNZdb84zXVd9LhbZNLv+Lbk20to0o7WPY?=
 =?us-ascii?Q?azV9w+z2Suvu48QH9jObUVQaYliStEuTQXej7hU6vvCpzhop+Zgh3YQZIhQD?=
 =?us-ascii?Q?pUApLhvfoFhRanHdX3jFEUnbaeohujKvqkndVIA2hV5kWJ/tGKQX2b20erI5?=
 =?us-ascii?Q?anHOvHcubr53AYr2Pv4O9xq4ewEPRNUY3/hJG6wkco5jblf805Ho2CUNh2JK?=
 =?us-ascii?Q?irhL3eP1avxgjXcYMOTgdmQSsJk4CZEjMZpb2AvCViJGRmm6JuCe4D9uvEaz?=
 =?us-ascii?Q?/NdXWdIDV/E+uWKntnOlN1ZliMdwqbE9ZqWial7Z7HO6qzv783Y4xCEuvooa?=
 =?us-ascii?Q?A7kEXP7cHqAYah+0lPAd+CLWnOZGlCbrdI/NcN1AZN/vPYr8Jfi67JbSzBU2?=
 =?us-ascii?Q?Z6nAf9S+UgMq9hXepV3FPys+TEu/sC3j9xGtWK4KXtSz6rDcZVkQIDWKQ37q?=
 =?us-ascii?Q?NU3stt6rkCvf8i5EF+MHBDC4OHICryNUe7f3UQuilAQfz80kxFUui8Qs33pp?=
 =?us-ascii?Q?6RdNBwLmZ0eFvkxagmk/Ty7AlcWC+6RMt8ZpdBdqAPoQ73mUraDzHoepW4YT?=
 =?us-ascii?Q?U1n59n6FoKGWKyhsR0RXdueV1NtEwFbB/rlE02h4R6xlyYPopGXXPIxIwf71?=
 =?us-ascii?Q?n0YbKsmIYq93PKm1E4bA9+aY7RLPgohXzcPvB78TPVGRP4qNHu8dRDDEShdR?=
 =?us-ascii?Q?KAmOQySptudz9BvK5neblUw3kpCIawq9CBCC/4jOKgXgRFY67jo5quhsS2uj?=
 =?us-ascii?Q?y9kELsddfIzW60rEIdvCZtT+L2OFaLXbP2GcWjQTL8//iSyEN7gzQHqJdOOc?=
 =?us-ascii?Q?iqsN7r4DOXXlFW1j3PUxX5Pun+YOfkByH+7E44eKwjzxLeFwrrRo3zlHnJk8?=
 =?us-ascii?Q?kDsAAov74J+KQWIaBw+AFS7veM5RwiMlgUx+M686SWMfRFvCuGQTv6Vxjx40?=
 =?us-ascii?Q?uqpY1VaSyztm4KooSZ1H+tndQcsaPzsSvcgtok7jthHbYyrtS0ktNfqOCPmh?=
 =?us-ascii?Q?SGeItxjktHwU4IBegatOlleEbLu+OB1cHlTS485RzALiRTON2GM+nkIXuWV8?=
 =?us-ascii?Q?ZDSIuc4bFxymV0OXPyLQwkIIJPn7keNvVCadyvcEhei0wB9jCm+XVd5uOxt6?=
 =?us-ascii?Q?XQElcZ8t31FKXtYn0rxqkJ6N4NAbdk3B8DEJuT4diJPAuLlL5L0JMmErhJ8G?=
 =?us-ascii?Q?RDhugePlwCir27Dq92Oven7yFDEsrDrBfDI+jsQahunQGLJPQHPbcs2Q72CE?=
 =?us-ascii?Q?n5YC1LSXEjuwQo7dZBo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc56067-057e-4950-8fc3-08dc2d90877a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2024 19:09:55.2361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7prjt6HsJul7tcJiZAuydDJbtKHUFqdu4DhzueGgagGlMbRUsJNU4O+lDmnZIos
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8765

On Wed, Feb 14, 2024 at 05:00:30PM +0000, Will Deacon wrote:

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 0ffb1cf17e0b..e48f2b46f25e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1019,7 +1019,10 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
>  	WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>  
> -static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
> +static __le64 *
> +__arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid,
> +		      int (*cd_alloc)(struct arm_smmu_device *,
> +				      struct arm_smmu_l1_ctx_desc *))
>  {
>  	__le64 *l1ptr;
>  	unsigned int idx;
> @@ -1033,7 +1036,7 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
>  	idx = ssid >> CTXDESC_SPLIT;
>  	l1_desc = &cd_table->l1_desc[idx];
>  	if (!l1_desc->l2ptr) {
> -		if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
> +		if (!cd_alloc || cd_alloc(smmu, l1_desc))
>  			return NULL;
>  
>  		l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
> @@ -1045,6 +1048,19 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
>  	return l1_desc->l2ptr + idx * CTXDESC_CD_DWORDS;
>  }
>  
> +static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
> +{
> +	return __arm_smmu_get_cd_ptr(master, ssid, NULL);
> +}

I think this will break arm_smmu_write_ctx_desc() which requires
allocation behavior to install the SSID0 in a two level table?

> +int arm_smmu_init_cd_table(struct arm_smmu_master *master, int ssid)
> +{
> +	if (!__arm_smmu_get_cd_ptr(master, ssid, arm_smmu_alloc_cd_leaf_table))
> +		return -ENOMEM;
> +
> +	return 0;
> +}

And this does not compose well with the rest of where we are going. At
the end there are 7 calls to arm_smmu_get_cd_ptr(), all need
allocation except for two (clear and mmu notifier release)

Better to add a noalloc version. Also 'bool noalloc' would be clearer
than a function pointer without obfuscating the control flow.

Also I don't think this should go to -rc, it is not fixing any
bug. The preallocation is enough. Making more clarity for this
confused code is a nice to have at best.

How about this instead as a -next patch:

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -288,10 +288,11 @@ static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
 
 /* Allocate or get existing MMU notifier for this {domain, mm} pair */
 static struct arm_smmu_mmu_notifier *
-arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
+arm_smmu_mmu_notifier_get(struct arm_smmu_master *true_master,
+                         struct arm_smmu_domain *smmu_domain,
                          struct mm_struct *mm)
 {
-       int ret;
+       int ret = 0;
        unsigned long flags;
        struct arm_smmu_ctx_desc *cd;
        struct arm_smmu_mmu_notifier *smmu_mn;
@@ -327,8 +328,15 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 
        spin_lock_irqsave(&smmu_domain->devices_lock, flags);
        list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-               ret = arm_smmu_write_ctx_desc(master, mm_get_enqcmd_pasid(mm),
-                                             cd);
+               /*
+                * A limitation of the current SVA code requires the RID
+                * smmu_domain to be unique to the actual master.
+                */
+               if (WARN_ON(master != true_master))
+                       ret = -EINVAL;
+               if (!ret)
+                       ret = arm_smmu_write_ctx_desc(
+                               master, mm_get_enqcmd_pasid(mm), cd);
                if (ret) {
                        list_for_each_entry_from_reverse(
                                master, &smmu_domain->devices, domain_head)
@@ -398,7 +406,7 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
 
        bond->mm = mm;
 
-       bond->smmu_mn = arm_smmu_mmu_notifier_get(smmu_domain, mm);
+       bond->smmu_mn = arm_smmu_mmu_notifier_get(master, smmu_domain, mm);
        if (IS_ERR(bond->smmu_mn)) {
                ret = PTR_ERR(bond->smmu_mn);
                goto err_free_bond;

Thanks,
Jason
