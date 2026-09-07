Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90968443A84;
	Mon,  7 Sep 2026 19:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788809973; cv=fail; b=fozeRehi7xItOQPmh/V5lTybeGSBsrurRbrnepXtvbpuh+AWkFcsIpFNnVSlS1TKsWd0B2DNHJAkAA0TjDCOhkJvqwYgxro//fUc6leRAhrNBstQYTKiafNzC9plrKcm7zH7ACZSP6xjJvh1mfca4uireukZ48g/aFzMJuqkHkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788809973; c=relaxed/simple;
	bh=nRcIxh7z5JYkMaB8SapBca5xkBX5ilj+9GhDjgxcp/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o7CpZn2s62dTAbNotK6oNYMQqXUpPTnEm6rWcDjkjwfctTF+hTdVmXgbKyJFX+gV5aBAuiKELIlyLeCmf63oN1mPVQhiYJ2FRtpee2HQKzN9dk3bvchywdXvL3Ajmqnbd69zm9YvhEVJSh2bpCN4PUFwEOP8rSDUVRyWZMMNdYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GRr8/7nO; arc=fail smtp.client-ip=52.101.61.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GRr8/7nO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cka3Y3x9x4HQz8F/pzPlFZnK/PPcJOKskFoGZjddpQFvbKn1lcK8lUIjssJqFaDiL/z0oOop773xlr08bPySKl09lIec52zpUEYARJZEaOWWgkeLeF1V4igP0HyuuIf78ebkguGIUgcSWtr3oP831koc7fUqz3jeCvepoaV3z1WwUUngjyccW6hyIVJ2p3JBqg3VGPbR66xg5WlD8T0N9A0IsPctusBLEivJW/AJYVzzmcUPv5Cy9YMxaC3wp54XJ5WhzloUu4VQuRL+nAeLl0ormmm57Eb90KSR/sLNietTIOh1t+NML5TTvuhgVm1auQCSEjvFa3IyBbg0mZCurw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvyvCEHH4Ej6zTusJ5F2zgGYy3etkWu+F+6zU1JWlok=;
 b=Jsk/hmzX/iZEAIN2fbq4oXdJ575sB591BpOegYFmOYMPL0NYsPPuLudxJ+2oWV/l2KOjq7oz7JTA9jWuSLP50CzJuu50KJa00x7CXC1Mreitzywnm8BsoDMV6iG2T5Z3TJBECo4KqoMjSoprOC6n4dtrEtdCdOH9nkAPkCTo3jpkNCLgBC6A4qNrvHbQvIlTvYJrqHpimqbOAHYItJH0G3ixIlG0jdAQx9PRcqM6+CmMIBDON55QM36TUl4rBd1Vw9LPRPpmATgTRQrNTu+w6rq9GN0K8RjRHn+6WDaFOO1IHtAKUipW7VXQlRAEiuzqbdgabNRf/rdo/BeaG4Cjzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvyvCEHH4Ej6zTusJ5F2zgGYy3etkWu+F+6zU1JWlok=;
 b=GRr8/7nO77kJoUTLRgJvjvFpJ7XD6eedLY+stiPwBlFc5OXgPilpbHcAd4GbOo8MOosz0//maTTj1JIUcbKs/D1CIMUV56u60K/fHKFaW56t9oDj7EiCfm4HVu3XkxNXSQ1Uk53yGEabegBKC1jm04EHqTNGgSHjiXDWp6NlYHscX71cEr8lF8lmefABCtSVsgPdn9wwaYx0pMAGkkDRp9DMBkxWY89bJ0t9IljYrLfFFUWoGYCiEcDUuGRPIxkCYSI/fwsZOVgGY57hUAa0cmDRJoBEVaMiMYC4UDsB+FppRUAiAtiN9QUtJuW7dey5n3j44kfd4fsjo3ftD8MKDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SAVPR12MB999169.namprd12.prod.outlook.com (2603:10b6:806:4e5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 19:39:27 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 19:39:27 +0000
Date: Mon, 7 Sep 2026 16:39:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v5 9/9] iommu/arm-smmu-v3: Support the DS expansion of
 RIL's SCALE
Message-ID: <20260907193924.GA2779763@nvidia.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <9-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <ap7Nxijs1xq7RRs_@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap7Nxijs1xq7RRs_@google.com>
X-ClientProxiedBy: YT4PR01CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SAVPR12MB999169:EE_
X-MS-Office365-Filtering-Correlation-Id: 88e28600-5701-46a4-fcec-08df0d17b98b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|1800799024|376014|10067099003|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Q3NVbOQ/wd7mXAiID9ov8Aq5mR7dkHsRCmR1v225UFUlr16fb38iYGZD+e7Sqr4TgPF1iitiSUAJy5H9GGSzQOFu0CYgZQl2eQEuhY/H4Ciitn0z5WfKCFFwcKRY9IlFiTxLL7qqf9xzbk0A8dLxs6z1f/upyVCBBqXmBeDxVVqb++QsHdIEju6pBZ0zsxis5c8OdIWCIn0Z++acYANUZw2cABpQUg7U5zrSLxAQKQtUIov5DXvY42U0TdMdnCOhmUGiBFYS+0gQ40CP98AJe7qataQCo9mCsF66yimxW03cAY+AU/hC/1DX7CdtlVB5S156TsAHNuYjujL5/xk5HCNGgVYwVBl2me0oVA9oimiIqknBUQWB0ueughjJbnB+5eMHS4p5DwNvmbxBVaQTmR/igb2kuwsADiYUp2QTelvE87DzOI77D8yvhEKrqQpr+nq6avBPcPijLEBv2YrC2nJGvgwqvIGD3WX74oxo9M8fECekjgP9Yea1nfnfnwehSvwkXfakD0b1KOr2cn+YzgM6BHP8SfWf8+CYhcWDnLDDuQzWlTQa8PrNhT/zTBnFSVfefPRNwdIOUWtYnL3kbZvmTjaL38EGwCYZkFIqcnHarSymCYuO8p/bGUEWQ/ydFGl4njN/GtoNtqEIEkXoMw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B2w3HhKtZQil793PQAbb5LH4akOEI/ldnxMP2WXfVO3hXJ+rU+PNks6wGqlH?=
 =?us-ascii?Q?B5736Isu/z3rcvFzLh8hAf+gMKZxtBiSmdmsmJVkDur6IUiItriEU6ECEPuD?=
 =?us-ascii?Q?6s9UQCYwWxAI81ZxOeTEyHXW3iI9af2+i+5jhrDz3wNPpNG4X5G4Z30a4a0M?=
 =?us-ascii?Q?1ZAr4r11lxn8267X1A67uUt8jQujadwrilWK1NABSJ/9TD2sGnfHgKgiC+bS?=
 =?us-ascii?Q?gCxACTmtfOiGFaY4e1KtKWAfCW6n4+vhr9ajiXVSqB0rwnt0zAkKf+afLwFI?=
 =?us-ascii?Q?cmc+dkawXlEWWCI4rUfqTh6VPZgByFtvJyHAnsfT/y4dxRxIEPdRr7efvAg/?=
 =?us-ascii?Q?u7lSrLSjvx07UraoT5hZW3dxz0Twhhi10+mJCU1aWdYGVwZldh9isvYLBafx?=
 =?us-ascii?Q?vuGl8EEbpU7i3AWUIAWPnzope0EkZAwV7wJRKZgOV30kAvB0brVpmd4/lKrI?=
 =?us-ascii?Q?nT7rOrOtEygj+W3VTaOKJzTeUb3+k63FnT0Y+2vs6MRs1c+4R1bjRxMdEU/m?=
 =?us-ascii?Q?2XpHSi4ogmGPPOeWL5/vq/0p6EKeUiKCGXLknkBTAKJYL3RssZALhS15kyEv?=
 =?us-ascii?Q?aq1thBbi04+m5XK29on/19ojKCzwUUjyJrJBWFWwHhMM74pSW4nIoWdoaG8U?=
 =?us-ascii?Q?TL5keZrZNRmfRz8xQmEiwTCWMZhbukRXwTa69trlYRBSE4JGCZoEy/c1rig6?=
 =?us-ascii?Q?oMDyrshvsL3Wlz7BZysEPiA0LyTxOk+atayIouKo2Bvfcc2js9q4fK+olPGr?=
 =?us-ascii?Q?JwylNpHd7onMPAHqE+3Ikqa3Nl5WOQZQ5npdeydJC+z086Wu74LBbGv3ViKk?=
 =?us-ascii?Q?hqX+H+BIdQal5f5xEALodZPiNF5O+IQvKAqmsIRugHlJRn1UKIQK0eGUTS5+?=
 =?us-ascii?Q?hgAHs86tj7wIoWHNaSzoi8jL/Q/MjM2TgG+5OC6pQA4t6BtkOQOvmdGB3FFG?=
 =?us-ascii?Q?xG0TLVBzhSFtO+ioh5Nribywf8EqSepucEVSpQpb0c9R6UCzzcP+0Ndz3ahO?=
 =?us-ascii?Q?5j+heWNL/lS5Rk8hqtE7vBw+kNoHmBKebyFlHQjLkB6Q6n/m98I2+V+K2nLz?=
 =?us-ascii?Q?EorU4ryJaEwYJbI6kp24a1tN3jjR4LOQsFM3u8uVaW2fBDKRKUxht2drx5Qo?=
 =?us-ascii?Q?emS/UubmPcEp5YwRcvLZG4pJS9qbHfogKMdaM9lUh6YeCEUh467fvDbhmWtF?=
 =?us-ascii?Q?HgwMbMRnIcSRgeyPBmr15ccFTj59qWT8wYOfgAAXpCEqoJ119nWIb/hxfuZI?=
 =?us-ascii?Q?YkQl7f+GJ+kbYJitSmcFoIpRcgrdlCBE+brssq3CUmZ/aoElDm3JkR6rDzp2?=
 =?us-ascii?Q?mG4J0lGoNIY0cB8XSJHyurLQLrxr6Nvv9vnQdgLS9C2wOJCO9m4aijUFsLz2?=
 =?us-ascii?Q?7cuxcN3jQTYXj1UmbXssM5SmWWABuU/I+tWkKZcmYEf53gwC+W6S6dyoLioy?=
 =?us-ascii?Q?p/jBlZvCkb80GfEiATQKaP6hGZpFvRVhXr5JfD3NBNfJ3+f8NdEoJz5tkzNd?=
 =?us-ascii?Q?OCPkEk2Lbf+LZ4v5fNJShQQMiUhTklT5uvk2y7KXlKdNZ8vUCE5zryAi8wMz?=
 =?us-ascii?Q?9r07pmGdNyS2zKtYBu5GCvWXT9Au+pvBSVOPA37/xk/umCi6YTtwFijTcAWT?=
 =?us-ascii?Q?a/q3U5Go82GXG3+57VeuNkbWz5ULM8rwAtsPTC1iSAACygGLkA8Y0ZB4usl1?=
 =?us-ascii?Q?QiZvJwx7uu5soR7c+5/kdAbqxp3dZQFI4JPyr5cYRijVo7Z3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e28600-5701-46a4-fcec-08df0d17b98b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 19:39:25.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KrhnzoOZMOfKMgC4JsDRo5FY51jJYxJdKsL0eIUbcP5UoYuG+uqPrBJru3Y/QsvT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAVPR12MB999169

On Mon, Sep 07, 2026 at 02:44:22PM +0000, Mostafa Saleh wrote:
> On Tue, Sep 01, 2026 at 02:49:58PM -0300, Jason Gunthorpe wrote:
> > If DS is supported then SCALE can go up to 39. Compute a scale max that is
> > compatible for the entire invs list.
> 
> I see in some places scale is still assumed to 32 as in:
> - arm_smmu_ril_init_end
> - arm_smmu_tlbi_calc_range

Neither of those are scale, they are the range of NUM:

	first.scale = fls64((num_tg - 1) / 32);

ie what scale do you need to fit in at most 32 NUM.

I will add a constant "MAX_RIL_NUM", it will be clearer.

Jason
