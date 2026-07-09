Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013004.outbound.protection.outlook.com [40.93.201.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09753F9278;
	Thu,  9 Jul 2026 12:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783598873; cv=fail; b=g8yH7w+NZKWtYyLMNDOCbrvgCmnVETFQfO8WaYTr7B5N/ehy9PdGoM+s5bGW5Oh7cTNhn4NuVWzgv0ozjDVO1sO+wC5LxNg6BdG7MZ2RXgC4DqB6JKvYYXoucEcGel/exYgSMDPwe+VcvfKOtyYelYeJawlRVJ5T6rxZjpq4yhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783598873; c=relaxed/simple;
	bh=fcpp0I5eCTs83H82mnTRwK3Dv06v+jvk4jlGQ1/hX7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bjlnZgjElxnoH2ENbB7t7NbNX+h6Bwh25TuDOw8/k0hCCXZidXiN64g+0BoGo9v2AimlD0cRB8WXlduRNumOGSKeSHccu72MD7IHm/X7mA9PSytPo51kuIottOsjlkE07D2WbQVJDfIuNTI8mPkBSj6zAW67ts6IMLwX+Opp6Lk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uYQmZeTQ; arc=fail smtp.client-ip=40.93.201.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uYQmZeTQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwWNtAX/KCWiNToyPvueq2ScXcOv9rdwHfd9v8AO63KJ/H6ZqEGhXfR0LgdngiSnEGaISgjEp9LOlAgh5FLJiviTLjajdWeKrtQ709dQSgGtGFMuTlIynSYWkkT+WxJbVKdeHo3wX1ED9IavJhhRFmzelFM+Dx810xJySEX6UxASTMxgFoV7TvFTYyg/G+jzKLAVGegjXaSU+ZFtBfyQ0d9EOfxrYqsnO1CIndh+HfeGUqXhmZ0kjbThqljpp0IU9Ka8sGejZ7FxIEx8Tj6DNkTjNJwptj5sKAhttVQb9cao7l7mVPcCHhEOOM58UWLF1SnFDA7HpzXZFN67+OMOAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgzaHHkVMrTeFc6N/HiFXKPEOgtv96vPn9AUoM+0Tjw=;
 b=Z059xqMpgTDMsg/tmgwK3j5LdCdrYeQ/j69s56B/pN1LFUb4jht12H+OKQXqMIKFVIIwgeYfjlyv9wOTAoVugq8y8KasBn1rRc2IMTKZYigqxC05Eug/36IFA0KumHhYxdvfs+PIuVhW+C4UNlCCXbMlItk2i/uJ49kFQ9El0FwwhhPojK8Sza0hlTYPapVKUFBKszByL73Afs3m8i/TuecZR9s6KL0BHIxV4pvs1j5asTkgv1Wd8JraLrxTIJAZny0bJqubdnihtqXNrrPJqZn2Bf5U7inEMO2AotLYS79X8Doy0YqyFSNT4YtGPWYvUbifmw/EK77wh0cdqokXeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgzaHHkVMrTeFc6N/HiFXKPEOgtv96vPn9AUoM+0Tjw=;
 b=uYQmZeTQysNZw+BsliFR7BGApiefCIFUSCaLzTB7C8Yuwz5DscbFgcXRzkmRoY5cwY0DGCUoAVv+tARtmdtiD+LUS0ECVlVEGpbbBY+ybsonJAUbElQ9OYQiAZBNxVFN9sycL9T3VHfGKmQp38at7tk7ZctCLsZsIHoGP0LERA6BttMNoyQmuOqdPaYVLjrOu4m/N12678iYBAWYuXZGS6kBtYkjDW5GPQSJ3Y9XxAmboAokhXrN4UH7C2UTeMu2hpV16ReqsUw3CwE+vOwpMgxwvZPRg5BqHTqgo5r3Vz4gQrJDNqL3VKRhlWCVU7fHMCo7nvRpiddWVNr7LsSWjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Thu, 9 Jul
 2026 12:07:46 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 12:07:45 +0000
Date: Thu, 9 Jul 2026 09:07:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 5/8] iommu/arm-smmu-v3: Precompute the invalidation
 commands
Message-ID: <20260709120744.GF422027@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <ak1iOWrvLv/6ACsP@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak1iOWrvLv/6ACsP@Asurada-Nvidia>
X-ClientProxiedBy: YT4PR01CA0392.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM6PR12MB4106:EE_
X-MS-Office365-Filtering-Correlation-Id: e5ff6b9a-8702-4fd9-17aa-08deddb2afa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	rts3xrVjp/V77QnJ/gG5JsiCcH7vbEFYbF6a+xfrdwYfvMGLNrAHYoHbFTDqvcOHx5xTRDjhJi2d/7qEffqlNyldaXDcw1BK7twzcHdZFnSmOaaPEQZXxT4isRjq6Mvtq5WaF5IPPrcHBJsl+JLaNYDrk2w2vt4SmW1tMFqoGdiT3dDj7eF1lKTfA25oGr8rUNDR43KuGQI9w1fHEI/ZhjfueBwAkt9ZByDn9m4nzfLIDtStVu8yCiPNgVhxyuuY4XrJ6XsaIUSOQBu+9qLiBM5vqQR7auCVmZl/A9mpgqAi6vo8BwigOz2YwkQkPucNHOjfpidW3cZfnHcLR0aqJKziInBendnzbwIOu5HC+szOTtJ+cJ93YoPYffv4T92A/FCSQWeETQzHgXCE/mkG+Jc4bBhxIDwhFT9YIAOibrGdw2d2m0awGC87qzjSgxhdBLmFj15GlpULWGNKdFmSB84wqLo4dkd0SiFBFLR9cyb9ZuwjZgGjEQZYAgpQdk7LDUzM77YtTeRzekd8+jXap9qx9TMo5tl1L13H1Wa8J8+4brh+R9dd6AcFbY4VInM4sCJdzDdduYKp7vJFSWCjJuzXbv32btmqReJenJ8HMMRlG1DfeXFOiYNQzWxaPeFvw3jcGx+3WIE2YupiX0hfj2NF0ke8yp9jPtsNUhJERVU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OGBmPYU0I8dPPyg4+XCfqzQ7EvphWosuR1RvHAibrZ+ka9esvUuG3okApVlE?=
 =?us-ascii?Q?uEOROZmexkO/C7vBh5lHELAylbZnJsxxGxmgSvE+3EBrL1PEaD6ZkiHyA+Uu?=
 =?us-ascii?Q?d492Sybb4KuD41xRXOU0M7WTr9XV/LQtZNEa+jrttBIkeQo6C2Uzk5lStwPe?=
 =?us-ascii?Q?606v4yHro7veJ71HBgbFjCj5UWIaVHvmZKQjjxktlnlnW/vYpg/eSofaH1uB?=
 =?us-ascii?Q?KUCbjy3O/8Aj5OBagEONAVmhx8Z4lXfDIdlRWOzGRiaEUpBE29NMl9aluHAQ?=
 =?us-ascii?Q?o+Si1HtloobPtPhZFB75GdLZ7fVitwWOAbmr5+jFV38lgcV+DrzEj5aQMX66?=
 =?us-ascii?Q?qnYymFORHrtrVDY4dV4glAE5sT4Qk9KUPEp0fiY+orQ7IcgpODt0mVmESL6S?=
 =?us-ascii?Q?1zDF/TJ/b6l/DXi979U57lDDnm3n0evHs0sDoaF+UxhizBaxVSnIqnueeBF7?=
 =?us-ascii?Q?ZMDubLGmNCyo8UrP9ZzZDdaZJDULa7EO2HMciwuwrXAU/obNh9iU/FH1PgT5?=
 =?us-ascii?Q?y6oNo9x5GAf2qUTaEjTJ3A0eewq2h7XbHrezUBabnQAMhF+FCJVoti1D+Bu1?=
 =?us-ascii?Q?a4UC2hVbjdC7+gv2DV326uinj6G6U0vWRVYV3hkmSXeahqgLB/QVQfpCsP3s?=
 =?us-ascii?Q?XQ2F+sqGHwAktaYZI6tOq/zoQnWUHQH12edGsxqIOVKaphqNvoKht2qFpKRI?=
 =?us-ascii?Q?fwZTORuFFQm+ROqBsh5XfSQx2M3DJiKvyTnscNFaKsbYLp3CCsn5yoEOPtgr?=
 =?us-ascii?Q?kBPaKWJKThKhHYCU+PNklQnRxo4M/JhGehm99tgK+Z0apRnZToYL+/MiZXtX?=
 =?us-ascii?Q?uDBUymsCkV/40LIvK3bPOMpqqHv0BdP4WF1aaGd9RSSPVceOhPaz5obhPXvx?=
 =?us-ascii?Q?wxRXB7+aJ7FmA5BOO95TFoEJq0mb3IgrTlYsJG+HbIaqIG1gO/BxhFT4CSaF?=
 =?us-ascii?Q?M7VxOv9duaO2BJhSWPG0EBpWnnCz+4Q0doTOk5Jm3I3BTuEUhB71bKCkIHM1?=
 =?us-ascii?Q?8gwYF2RDY3A49zgIrVsLEioRrhEBJ3eng71Iz9k8Yq3jM/EdoZ//vnsPcyeh?=
 =?us-ascii?Q?uCG97Mo79TCVn9YrzWS3ycUp9iO5dJ+IWsEvNYhQl4Yl8ap8Zi9IoBJX/076?=
 =?us-ascii?Q?X2THo7tS4w/p1cS42pSSiq7mpogBApzs23UpDhUt6obDEO1f5nHtwfRxOwmj?=
 =?us-ascii?Q?khcMj8kbsVDeQAOL9/yGDmFy5aquwO9n3cJYreLjSCrUY4LbYF5FOeYqt4ON?=
 =?us-ascii?Q?C8AkAkiszMTZAyjFPYHtSkWmoIjLlaxx3oPN/v1gC5aU2z52F3Wff0jfguJn?=
 =?us-ascii?Q?2hVC3ZPLWGGeQwGko1VQZCUHz2fn7PXTXC/y4ufzHDFcOgElhIKila5gUUIx?=
 =?us-ascii?Q?XYV1TMetGRePa4TlTQhIWqnMIqrvWNy9txLdgEGDC5P6G2rroW8dgU5nB9ns?=
 =?us-ascii?Q?uotrsKMc8RknkQTNFTr+LCUtZeBIivllET3v0U4WWoE2w4BZ4uoLxWBt7F0y?=
 =?us-ascii?Q?u3KdXhKQUWhzWXha3AV7mE5JaNARnAye84Csev3CaGnUaXPmR2X9ZFQfb84W?=
 =?us-ascii?Q?C+BtJSzOF5YTugCjpDmdHns0IyVxzgShsA90b8z53ktzkA9EFI+vwmoz5VpJ?=
 =?us-ascii?Q?hPML4aGtOR1vUXkrubCYfl9c6cViznDgqhN3RZp8dyknu/9/UqtmxpCU6znG?=
 =?us-ascii?Q?ZdRlqZttEmhfxhXV0GJ5aXEzA0Ce/Fdh3eL0SiPsX3oQGbpM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ff6b9a-8702-4fd9-17aa-08deddb2afa4
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 12:07:45.7057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Klx6EyY+WrjJQQSJKvJ8oJSpeGGoMS6Ua889TQY/zP4njvCVhnRhs+va7V1G/d8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106

On Tue, Jul 07, 2026 at 01:31:53PM -0700, Nicolin Chen wrote:
> > +	tlbi->range.data0 =
> > +		FIELD_PREP(CMDQ_TLBI_0_NUM,
> > +			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
> > +		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
> > +	tlbi->range.data1 = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
> > +			    FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
> > +			    FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
> > +			    (cur_tg << tg_lg2);
> 
> Could this be slightly cleaner:
> 
> 	unsigned int num = 0, scale = 0;
> 	...
> 	if (num_tg == 1) {
> 		if (!ttl)
> 			ttl = 3;
> 		goto build;

I'm not keen on gotos outside error unwind, but how about

+       tlbi->range.data1 =
+               FIELD_PREP(CMDQ_TLBI_1_LEAF, !tlbi->table_levels_bitmap) |
+               FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | (cur_tg << tg_lg2);
+
        /*
         * SMMUv3 H.a Section 4.4.1.1: TG!=0, NUM==0, SCALE==0, TTL==0 is
         * Reserved and causes CERROR_ILL. Single page uses NUM=0, SCALE=0 with
@@ -2472,11 +2476,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
                if (WARN_ON(!ttl))
                        ttl = 3;
                tlbi->range.data0 = 0;
-               tlbi->range.data1 = FIELD_PREP(CMDQ_TLBI_1_LEAF,
-                                              !tlbi->table_levels_bitmap) |
-                                   FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-                                   FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-                                   (cur_tg << tg_lg2);
+               tlbi->range.data1 |= FIELD_PREP(CMDQ_TLBI_1_TTL, ttl);
                return;
        }
 
@@ -2513,11 +2513,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
                FIELD_PREP(CMDQ_TLBI_0_NUM,
                           DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
                FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
-       tlbi->range.data1 =
-               FIELD_PREP(CMDQ_TLBI_1_LEAF, !tlbi->table_levels_bitmap) |
-               FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-               FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-               (cur_tg << tg_lg2);
+       tlbi->range.data1 |= FIELD_PREP(CMDQ_TLBI_1_TTL, ttl);
 }

Which removes most of the duplication

> > +	if (invs->has_range_inv) {
> > +		if (!tlbi.range.use_full_inv)
> > +			arm_smmu_tlbi_calc_range(&tlbi);
> > +	} else {
> > +		tlbi.range.use_full_inv = true;
> 
> I am a bit unsure about this line since invs has no RIL entry.
> 
> Is it set for a defensive reason?

Yes, it should never matter but since the has_range_inv and per-smmu
tests are disjoint I included it defensively. I will replace it with a
comment.

Jason
