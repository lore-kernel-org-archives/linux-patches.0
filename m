Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A286A011
	for <patches@lists.linux.dev>; Sat, 17 Feb 2024 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708176295; cv=fail; b=uTxRfB+RBQNN545TYXVDMlcYwSd0GJ98PLXNc4PXOsvrrsEKM3PxA9rza0fgM2+1BdiXyKbpzouwxTCvfB727YbNRz7Nuj2drC9FXFlILvzWlIHcNn4GmXin6GjmtHE7aINqJMQJOdqGkSubI5i9glUZVo8VXgDv7D1Ac4vwACY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708176295; c=relaxed/simple;
	bh=Fi8zfjGo5kZhHfiTSOzSPgyu44BQbFeMSZDjXbYfwys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fXZ7Ynvn2mgtzrshVEudBCxKBqRE1fSYpxYPCooLKoYerlHWdQ7xO4m8pC/CxYsCLXjTqXFAticO7zcpkW7sjorhntONxNNnzGRQWP2EIAnrx5A7kwoShAc+hmvULjYSgm+HCm6TSKl6tCsmzXWUbt4c+WOcdZO9Dktz7wFtsxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h1JOwI4G; arc=fail smtp.client-ip=40.107.220.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h1JOwI4G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UX1ty3XF9yYiWuwtkH0ozEJGPPwC3UVfXz7xJ/3tM+1gEYksAxqUg02VFeuoZL2iHr7kZxfnoibiPlpO2gTBPwLBf47b6W6lxCVGvuhlSF5T2yyUbJaebN8RHtLiM4rxzc8tfvYmyV8Lai06OJIB/Of/6RmWhsHqFA6TZxZEfUB4+awwSDKO+7FPzJXA2aMDX1nCDglvhlcEl9JK8SE2JA2pcX6mAgsfi+TUAyesKKGZ6oJWSKMgSfTk8YMdPbDKxYbef8EawTlW0QVCAvd6qGdtjn/OHqNVh4gp0KznddAGgPbUebHdO9S4nvKi799c+xqsBNZ7toadchxG9Mmsnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0Y6J1FN9ihvHUfQc3JwMajkzGO4Cbtqrlyh3WGDW3I=;
 b=E6D6z+zrGlGnBVmiWKCSgSAQLiXfi+VjzoZTmbbuOKjPWepvqkIhAnYO7145LWLKLlptLEcOW/L/7teevVgkq+ppXGcIi824ZY4jUlwY9mPLDey1UYQrXAKG/XVrqYrY3qId6Ux9apMyJxdB7hFGYWhbL4bmIQ4shqHfCGHRXZyyQk80nbmARkJgsxi7/+7FkTpdLwHvxnhUS0nTrPls22QDaoMwhQmNNpWf5e06LkBQZzgC1nZTZQVnrBtOc1I4HQoc0O+oV8BvyonwR2jV3lO6HHowyktDD4NKFuA4rKqk8R+jDUk/xwHzVq73u1IjKP8pwkLQ2mqxuziOuXk1/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0Y6J1FN9ihvHUfQc3JwMajkzGO4Cbtqrlyh3WGDW3I=;
 b=h1JOwI4GMlHatfhY9joSY9MsZAMdLlVLQ+Bj/n54QBDf3vAwZgsc/lMpuEtgd3y9LjP+oB0hvpjAKA06l3606QzSgIgnFPlS5KRzD2i3redBrFHLMRgRhXbFb887bcweFec+ynpT0hFDvTFABXcwEdDorRmnNmpRwgV6dDwLGOmyUyg2+ERsmuUrwjqEk2ycyJHA0SLUjFk49wonAyjqyJ7HLhFQT7bjLQGKTzgFVMJRVEpNJz4ZSVa7ByJeNDgnDLc9H4f7ETLRfAHlfKgmBuw8dIpkw45kJXUWUelSQmmN68kiGqp+gDWIW68FwyHb6cWps65igCUSjAXRkhl/Ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7427.namprd12.prod.outlook.com (2603:10b6:510:202::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Sat, 17 Feb
 2024 13:24:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.012; Sat, 17 Feb 2024
 13:24:47 +0000
Date: Sat, 17 Feb 2024 09:24:46 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc v2] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240217132446.GJ13330@nvidia.com>
References: <0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com>
 <20240216120512.GA1841@willie-the-truck>
 <20240216123606.GA13330@nvidia.com>
 <CAKHBV27eBnCrnXeaoqONWksh89tfX1b0=yvLfTkxviU_wKG_mw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV27eBnCrnXeaoqONWksh89tfX1b0=yvLfTkxviU_wKG_mw@mail.gmail.com>
X-ClientProxiedBy: BLAPR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:208:32b::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7427:EE_
X-MS-Office365-Filtering-Correlation-Id: a5eaaf0b-d797-474e-cbf8-08dc2fbbcfda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JuWFGkW7zVZcpjPK07Gclbpa/GjWGgVEmfsQb65bJmHnsmVeMIOdjTBSIzV42AthUo8W5TjvTm2TwYISlb2sJiW48cKiyPgKW4FieqmKt/wsrLJtpZ09XbEG6YJEn6sY1R7+LkSZzBxhNKRmBwE3EJtThH0cHIPHbT+IDagy1PAyMTEkFuhtRHIaOlYccC7F3uOfT0vmIKpKvS8E4qAZFxkxup7ubYSUbr+408nbB2pv272HlU/kHmoKk5r1bDYCfMK9BwqagBVmGglxTH71KSLT8rxAgzUjFVrgZeNBE9HVnqB2g265TyWeP9/BJuNEzqE6FGZ6jfTb+oZulx5PgsTKlmSr52lfT0ORdUQo556BOhJ/XiF+yhd7FinaADz/3gowwoTMlykUe0tl/NRNwWlptIPswjVMDGQ5VAtj7MRzVTxPmZnGI3wKBDSEWxRuOb+4csYY24EWr+9B06uGeLGUQcmZP5AILSFW9nh+GhVEp/IuLq7bAYkRtiJ6ahyjLkKab02Mg2t4miuylW7pdqUfJhfNeiBGU3Gf239Hj1DWKmfilcDYbwFVJnBrss+5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(136003)(366004)(396003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(54906003)(316002)(41300700001)(6862004)(2906002)(4744005)(8676002)(66946007)(38100700002)(5660300002)(66556008)(8936002)(86362001)(26005)(4326008)(2616005)(478600001)(6486002)(36756003)(33656002)(6512007)(6506007)(1076003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?26j87U+M0iyGEyWtaBqyI43/kTi7mj+ganrZaKRwEcrjd+YKoyy+5Ieq1fPN?=
 =?us-ascii?Q?mjCYBwzQWqUyrED6Iz1azfltJL+yHu5HM9QtDXTqD9J9GsxhHKmD9uiRwyt5?=
 =?us-ascii?Q?sUpMY9KRMkqUeJMidl1c8VnthZNZYfSe6s5c86ACXH3wymrQj0RFXpesH7hM?=
 =?us-ascii?Q?XHKY14cT3UXOMROJgLFeYeDLFIb/XLoomIpSp+fgxhADpy+lah2UV3zuFmcV?=
 =?us-ascii?Q?1qIfGOV/DGWUAfbP83ip5jK1AaHtq1vIfKe6VmnWcX+oapEqNKFIebCgjBe8?=
 =?us-ascii?Q?sxaATpYjs+gTziATrZsSu4CB3AeLWzYUoH0WQwxOAjXwMUTA5voapYgIhpFj?=
 =?us-ascii?Q?HBuSwbTpAXks49w3x79vVbAezrwSnPr54EfUywTlQ3gWSVJiNvjqWKoWg78J?=
 =?us-ascii?Q?ZK+gu5HNWsc+SwZwVD+5kSn03hQZt5YwkDNKnZTu+rKbnbAwcMsOrmuqXhXo?=
 =?us-ascii?Q?K4nfNpkCAiBHFhAZ5ypNU/j7ihq+2nIsqJtW8Tn5/10xcD0h1/+BR9AOmw3a?=
 =?us-ascii?Q?QDR1XIuNsLy9HA7GVu0byXoF+KYRpAqFa9yga1Ht12O7R9Mg68ema6+aN93w?=
 =?us-ascii?Q?72WgN7JNJi684kgeaJtPoFrlGt3Wmm4/APZbm8uml36Q4ylkVDNBW2g8kUIU?=
 =?us-ascii?Q?d7MNjHKcfr1q9ft1qvSjXbmMVekPQqZf56fxn/LYssmWLMTg6qr4WsQTSi/U?=
 =?us-ascii?Q?smybZBHU9WWdEtq5Ri58XgaTZo53HIpWDEb7zi1TP2o9Xty4UbLfjX1c3sTs?=
 =?us-ascii?Q?jNwW0bLSjwEmvARNtpLIHSxhAeXEdXYRN6EqEH0IBM/vajYxEd6ZJhmV6mGv?=
 =?us-ascii?Q?JYkQE0EiO604do5FxNKUkS+zC2OgxKpZil6UOXHAAY41B9TQMCOraaaBaw2B?=
 =?us-ascii?Q?fjOlrDT3i3ZKMxHc43ZlwUNkNrnpWt3pXjyywoCsIhaagrXJIHvBTT3reBkl?=
 =?us-ascii?Q?+rYkaxOaSVjonlHGHEQPNIceZMRXvoyJ5E/6HSznO5RzAlUw8AG/555/+/fo?=
 =?us-ascii?Q?Nb+Uc1RIGN5qte5tWRxbJqclaVAwNoE+ybhGMbskp037CMFkiYpP1DpdqdtQ?=
 =?us-ascii?Q?Vy3sH4cq2b/tPMYuor5oR7WwjeEXeATbreEbJcwMDwFWTR3yrM8ezqXU7bTL?=
 =?us-ascii?Q?abMivDuBUjJPoap2JzmKOG7ZmGAGxNUVxvLRFKVqDxUQ0lNBN+3VVtrw2QEa?=
 =?us-ascii?Q?XsfpvEx+NhlcA1JKdnvkWzI+NEus6XqH/wlm599C3htREZx+ZwqSppQn4FFP?=
 =?us-ascii?Q?rIBEI8acyT9jkk6ViSN2oB4M97YVptCqvuelQkNPnpy2U8Hdfi/jzqpzcyqO?=
 =?us-ascii?Q?/mcLmsnefBvBRU3SmMXl3EF0xPYcIZ2z5bpa3ztUWh8A1ij2Dy6O0Jvwe20W?=
 =?us-ascii?Q?JoigBt2lhuox2UsnLzMjcyg2SxwjHrXSsbkR0mMiwZ/05IR6wcp1clKsbfC8?=
 =?us-ascii?Q?MOlUrsskMJvKaZPdM2nFb5LPDENHyY3Q1b47Gf+0w570YALkm5aSNd1YUjmX?=
 =?us-ascii?Q?MCEzjihXHfvJdwknQS9FV/cN4WzB9Va0tFjCACR33QDfGQtWcGum8uuqyoYu?=
 =?us-ascii?Q?5i99cHmO8KnlE4qRe/J1qin9dU6+QEWSW8SjBJZL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5eaaf0b-d797-474e-cbf8-08dc2fbbcfda
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2024 13:24:47.4143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQM52S5kBS6RMPYQdjUdrNQEOoaveTd3J9pFHuS8ZCFBphZORgCQ8L/GWFe7gA5n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7427

On Sat, Feb 17, 2024 at 08:25:36PM +0800, Michael Shavit wrote:

> Calling arm_smmu_write_ctx_desc requires the CD which we get from the
> mmu_notifiers list...which makes it a bit more complicated than
> that.

@@ -404,9 +384,15 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
                goto err_free_bond;
        }
 
+       ret = arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd);
+       if (ret)
+               goto err_put_notifier;
+


> > Also Michael should look at it (I recall we talked about this once)
> > and Nicolin should test it.
> 
> Just to make sure I follow why we're pursuing this instead of the v1
> rc patch: in the non-PCI multidevice group scenario, the first call to
> set_dev_pasid would only have pre-allocated for the current master but
> arm_smmu_mmu_notifier_get would then still write
> arm_smmu_write_ctx_desc to other masters?

Yes, though noting I have no idea if non-PCI exist but it does make
the code clearer and removes even the possibility of a non-atomic
allocation

Jason
