Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011037.outbound.protection.outlook.com [52.101.62.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEE83F54C7;
	Mon, 18 May 2026 13:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779110597; cv=fail; b=Ici5mPklzo1Lo4opevYs3s3qKqhG1/GHmu1gwUvggDZVT5/I9mEaohR73CyIKEv59ZBvsuc6mqWhtGnMbw7oM836yLtXWz76soispdsmok1V1Kt4WZ4KQ+R8I2gGXV5xCMlfGcjoxTTOv28+7oIuu7lGli7/Qbbqh8x5H0nS+Gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779110597; c=relaxed/simple;
	bh=ZxfrWJeHGUjYHmWBRRitpSnL151uAgNA3PnftIgu0T0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EEWXRGsDZwyikGRAuRRJ0a4sMMitohqLCIagcAsQ6Gz/OqqVCpY90hweUHTo/Gew9wYELceAbN2rC5HkeQh5EqfaUKNVftINfWnM6l7vzbKH0+i4GKlp2QHasf80udLFJqYzzupj95g8FG/MXMJmIwwjSiriUdoBYhAt5KSTnLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BzjK2t72; arc=fail smtp.client-ip=52.101.62.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BzjK2t72"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h93JVVnA5oyPSksPodWh1LolerZ/gihgsGolvyF5lIOZBx+8p7qNq4MjSXmGvJdhuf1D3lKw7OnEAwbonUdpHog2aGpEumnmuH8r05ZvPU/Kr4n4EFPWRW5hNbaHIv+vN2Pob9YDCEbLYpVWmwzFsjyDTXLToQoex0+WT6ZLykogoi3WPXhmspTuvSV2SxGJsZwPh1p/UFIrbuCl7Gh8pvXhEcHkM8NnfDV9RDxNA0bQzX8NqybusBnT8xm5mR3ppEFRz6BU05VyLgkABPnaM2fVxpvPs3oo0H27np0NDoKgGhWa4maTGWPlJkuDfjm1XKs3zn3blVZkZGFpoxRumA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxgTGn2UGPzs3R9hEnApQQFF803ju8gKa2p5R3olVUQ=;
 b=JbwRaEb7rX3FPAkHdd8cvK0pE5rgRKKcdazSJG2Ax2d1x6Oj7sRlV0ipfq/PVPgtYhGgnOw7ZfCcEnVUuzhfVHI69Zy4EPONG+RAYMY959HbNmh38TBV6UjMvWniSfarMPuEOsGJzuv25HJBL4SzELIxioOqPbTb8kTFwu3o5702+rRqQw3X9qA88HpZOfkHicXrNUSPQZJGgWZhohCE6196ecAwefCtZ6dDDFf0/Rc+EpOrmrnkha3PaaImXcBpR2JmsS7hz76FzbVsu86xq7j5IxuzF2daGKsXNnIh9ZCN9eBDyWucw6NyevIUyiDI/XH42JTFcFHX1yJK1MzAgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxgTGn2UGPzs3R9hEnApQQFF803ju8gKa2p5R3olVUQ=;
 b=BzjK2t72WNW6pLxGVOzBkPthYBi0mpVWc8OCwFnLPAvb1r23f1sh81cA2qo0LR1VKpxD+kQNM+DxLMJoRrbd+S8QKjX4Lqs1QbbtNYv2Nbho2YJ2z64V/W8uE54MMnFCXtVFhMiuKgpjAtRLK9XQG71Ayo4zGNdbttrotKf0cvaxri/Q7iBlZwlAjEInadGDnBMKNemW/kC3LynrJFaBHuScwapoJNDV6w74cJ3fPfBhDaxjMZS+ZSGswLh/6mkdp5cnHgYrdOda7pe9yrgERLfzFX181SLX6AYR0qq/PDR9ee6p2aGh+XvSBLZNrQMB2kKJSUotA6vHdFNQuqRbjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB4055.namprd12.prod.outlook.com (2603:10b6:610:78::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Mon, 18 May
 2026 13:23:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 13:23:08 +0000
Date: Mon, 18 May 2026 10:23:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 6/9] iommu/arm-smmu-v3: Directly encode simple commands
Message-ID: <20260518132306.GL787748@nvidia.com>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <6-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <agqETancvNtL0lXc@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agqETancvNtL0lXc@Asurada-Nvidia>
X-ClientProxiedBy: YT4PR01CA0182.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB4055:EE_
X-MS-Office365-Filtering-Correlation-Id: abd06da7-5c0c-45e5-a059-08deb4e099b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|4143699003|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	9N5jjR3y1GBQ61e3aYGMDCEms/fMDCC3Z3nWy9EuspjEtdgfkukNx1oaLGejKGVmRNJcTtH4J1Cm7uVFAVzW2iYVdSqc3ES9vJs/StS741y9AikLGKYtWvWpmj8K1Bm+C+XJz+sriYMeAU5Vt0dd80squwoZEMpTes2jL8h6A0Xq+LhjVsCAuixYaZRbjx7K1F9wSSESDMw1DAZcXenfqzPTzGMb5OvC81j2s/MIAtPt8hdTNy/ENtaLga0MvFyUNHo/LYw7yX9Y41iRWh3D7wKkRTZGRnppNhhuqfoqobYRqrrK8N/A0DfPyn94JC9VJ/zUX/I6++0V2GB8T4cmgCLV/c0Yx2F9+fmoquwwq0+HAlQ79VD5D3f9Uc8BZfpGZhM4zzzRkD3UhslodUpjwiDkkZJWl3rXq6E4Cu2k32SsSheTS+qRrkxN4/F2n10MHelTrTeWtc/1kEQXQzKSUo8I9FkpZhwoAFGu6rJaYv5iDkTx3RVMUKpcVmQu76mFvvmE1pU+EY52tNoPS9lSM0dIs4Uwi57GEyWKjx/KkDRGXFcgjUPa1mrqFHN3m/c84KwNiP6yFbdZ8AJxSzmXYnR9OvYTiSjRMjqaFmCALZsvcQRgGyL2JK0Mhep/ZcRXf8FV6TCjnESyqbdQoSbRfBqow4XX2r3mTJDFDeKR74VBN5uRAFFar9D51+CLRnj5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(4143699003)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cNepZeubWqCPA8Btdw6/ZFXj+KqUQWlnZrxzoJ1fZAsg5U6r1iUqbcOfCwg+?=
 =?us-ascii?Q?z2oo1wcQzqvBAOcBQ3o1BXGxN/SeG2S61EJ1Qx1v9Cy/esA5JkyhgXiVUM7J?=
 =?us-ascii?Q?c6TskmEcQhZB6FcKLKza+xdG5O8298V9zkbLPSQ/MJW3Y40vr5Ujz/5ZafV5?=
 =?us-ascii?Q?M6q87CTeoxGYL47Q7FklVkbofJTvydbO5d57jYWpoxudKfIO+edA9L3oe7fW?=
 =?us-ascii?Q?MwDRf6S8ffYHWAj/ZG2n67X+uTyJKa5u8D1eGWRchlkGxfvM2g0xV2TVu6oy?=
 =?us-ascii?Q?OD4xIetRqtrFyEoTjFQg0uYgIJAxOZKwOOJOUE2YFy/LSrE2w3LO1kDLbw7k?=
 =?us-ascii?Q?ZvN9Y5wClaYDlZBbaRzP415jWONQkuW5rj8BwXHCM4DWQWPbdt8CyPfttxXO?=
 =?us-ascii?Q?taM9rAwWRQe5OcGCgl6pEdqWuhcRhiN1i2NeU6E8h03gX6MQQ4WdrR34Al6w?=
 =?us-ascii?Q?xRztMXleDfvuq/JL9wnqhB9+O7jAJ/VCyloNkxe7k0PN8OcH6TykjgpgQisc?=
 =?us-ascii?Q?BveJFC2hGhcDO7jz8dXUiSTnJyIP+Z/fxSJyPJv0zUz9YfC7RBbkFsBJqzzN?=
 =?us-ascii?Q?L7Fh5utSmcpqLhTFhhHwAGcyubUAlRtO8MkElquHz3+WdjE3UhgPacLWjuLS?=
 =?us-ascii?Q?kCoQDqIplcjMB4EJ/fuoTPLiXhBkx25Z7fW6S4XOM4sn6sRH58FAyyTveuH3?=
 =?us-ascii?Q?qLo0HCpg74gwLHCwSsArYYS5ttxNVxL/ZZ+QHhQ82wRDRzGX+ep7OlGDhauv?=
 =?us-ascii?Q?0GF4vW5kaDk4dMeQnesq1BFsWtjHwIIy0ZbRn+yh8tNUgmrLyaXatmvs7p0v?=
 =?us-ascii?Q?pOXWw9/p3nIv/J3KAlwrCfQAOMrJFskzqQsD3F9y1PxnBtjpQe/11WFKtNyA?=
 =?us-ascii?Q?vvvmdk7Q9+ULpputPfbI7uD6NKs49lToDcjp5fzqaPN6wWdTRCg+dn+OHghU?=
 =?us-ascii?Q?gZd4XLV5rgNyNRbuXURrv5tfmJSCveILpFTafjL1spB0rmJ2PVixeP5jdnMA?=
 =?us-ascii?Q?DhhWkPRGeYwBuFre5F//UISECGaDuJXBsOfXRxHKuvkmlenc79IrGBSs+69R?=
 =?us-ascii?Q?LBiCQEq+V9ru5HzPfItlmk9yaRAKz9JtL6nS6lDIe4/jg5KlZoR1EbUxvOa+?=
 =?us-ascii?Q?nVJnJChY4EeRdwEooUEdwkHnt2PoIIwB2J6CRXC65tTojWDB55Q8DXyuo/cx?=
 =?us-ascii?Q?bbu2ovU3s1idg/OvzYTMbUgK5zV3pzST5EAzwjIEU+8Gj3AKF2eL07dEgORf?=
 =?us-ascii?Q?U8OBBfn58UTyKNJfwD2FtH8dLDQN8gJ9aPuH6QTbqWnEYTGprSSGDh0ooRSk?=
 =?us-ascii?Q?ytgWQpjLP0udEE+FAgEDv/jRLkmN7QRHrx0BvHQsN47deQSOgXal9n8wvUvo?=
 =?us-ascii?Q?+4WIXp51zDFtdDruHccZtICE3HTDqRWNGD16AOjM2qtaPwLWE63ojgdIB3bF?=
 =?us-ascii?Q?vjKtPVWJSgonmO6pHkVEoEpSBJJQ+Av0x6Lgk57jys/V7iyFgc8GUocn4GSi?=
 =?us-ascii?Q?NZzn/+kW6rZfu8Ju5ME2LtCpUmV0mG3Vr8+TPkUlTZWd8jjUmticDQJ3QaGW?=
 =?us-ascii?Q?fE4oTz4p3R00GKwHedJQ7VN/f7HSQhImqobsdTkdKBv6vD1UzlknrO5/ZMw0?=
 =?us-ascii?Q?hPiH9pcQ5NdGryS6Oerm9ad9wvoBpmp6cRCXLUazlbdk4kw7rXJaH0Mk8Hy9?=
 =?us-ascii?Q?TA9pbcABnPde6nWnfemN1EzheefZIMvCR2ClGuaEjxVaXIX8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd06da7-5c0c-45e5-a059-08deb4e099b0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 13:23:07.9730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrG6M1bZoHRhEQdZof5zEvXmwLYusmQJ24K1kiFeike52cQLh+WjzltbbT/5usOl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4055

On Sun, May 17, 2026 at 08:15:25PM -0700, Nicolin Chen wrote:
> > +static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_all(void)
> > +{
> > +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_ALL);
> > +
> > +	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> 
> Optional, might retain the note:
> 	/* Cover the entire SID range */

The spec doesn't have a note like this is just defined cfgi_all as
having this encoding.

Jason
