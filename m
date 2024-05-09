Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBD315ECD1;
	Thu,  9 May 2024 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715269240; cv=fail; b=u+wm+wW2TyeSgGeMjJDx9Y7s0f4kHq7SGxDzL0BeLQbltw3t2DFhk23OUkwT8tMj5fhZ+7DIqkZgDxR5dqKMSRkBaFMuXTJnL4YtRNr/bqJvFKAgDajgs5L9pP25sGHnRKO6dWZX+KKTsW31mrrht7zej3nWiMLdNpBVJt/fUPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715269240; c=relaxed/simple;
	bh=2o+4IWaT0A9h1r2RGNRzRCs2R77K2K3xJnUeK3xC8ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R6tH3xOB4i01E8xyZbY8rrcMeOTxNzSMCUp4XOrUn6kK3rlkEhocJ/whs+M+NpGkeIQI2ZqihQQ+Sk/uKPund9EWei7bygpOujHjC2rDmUX7KVwYyrN0QeGUz+rtVqEcQ3dCgD2TxgqFzuHW8F8aBR/16WM0QlHr/DUOA4zQ/14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B/nWREtI; arc=fail smtp.client-ip=40.107.236.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B/nWREtI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMNWU7mL/Z1nC8B5yYcO2u/sSWIRWclQM+ButueWNQdrdm+NmxvTDuwtw7S65/VIbQoAIfJyiQtVsQiqasw21ngK+5x/+OApbXvClsCvNvpN1Gj71/HgaIX2hGpRYA+FrKuQtvZtRLrpGnDmwEoR9+42zSAeQPRd6WnNAOnbaH2LkkAH3VYHExSBwHyuwitVGviat7U0sRC+i7ukmTYS3CnPFXNjiZAvCsj7OSVK+n9YCYC49wFtWG0prNxD8wK/k761QNONr98L72lmgLMC4+JwCvR6jHvCdicSnLdpfLc9+xskR40xDweXn6fk5N1T5cjXgTmsPA62qeHKSPnF+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Psyv3S791kMXud/lzUDBlJia2IsZ9m6hLHlBMYPEWY=;
 b=kYZuYlpfN4/M8UDrQzpXalAHxqkNJWOVGYSktt3vl+trPsYUbSP9se8hLaeQD/gjJG6VD6aq7rD0wbY9IS+dmNbd0MAaoE/FkiBG3Uab6xIzfDkSGr1rLu3AgYxbvwYQk8MB6WJPgpGjXymaqL1wkg8DOi+xg0sgQfXNw9fru0sOJGsPvtxI7RM3lyMNet5OFj98J4rSjhZtdUsGbk3TwJ7IVnb2oK9t8E1GBVRtvNxrMuc8q6wWK0zfHS3asdzwrEEO6j/DaMwPNzvNUSf5JkT92AGBxkKIsD/kdG6Js67+IuRBxmQzE9G94AtwvSiinBca+6yJrezMNXF+ZGqsqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Psyv3S791kMXud/lzUDBlJia2IsZ9m6hLHlBMYPEWY=;
 b=B/nWREtInvXmujM1b2l63BP4RTwkp3Ptd0JtpbGk9N8kZfKPPYO+yGO4YV4K4R6xD6hUiZcvfDcMUWrUiwtV2NcRQiGayxef+Em+dhpOYJRTYz33zDi/0hBvXgWK3zUtFZFh6WxzIL7JB7Cb/y6cvuCFwl+4Y28KJguLy8B74YEwTRUyxvDTBO+eHyyz4uvCTbyQTRv/CPFulRCU8UjLnpQ6JaWdbUin1QaiNf50BRogTXoortE7V88ro1/iR7lj+cGk2Bh+KpH3xKEH/Xb+D7pfsH2MU+KVyVks1pOwzlb5guF5Ot2mYQLK8Bsci4E6+Kb5uVPohoeApevOm2uoow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA0PR12MB8905.namprd12.prod.outlook.com (2603:10b6:208:484::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.39; Thu, 9 May
 2024 15:40:33 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Thu, 9 May 2024
 15:40:33 +0000
Date: Thu, 9 May 2024 12:40:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	arnd@arndb.de
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <20240509154032.GQ4650@nvidia.com>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
 <20240507135817.GA22408@willie-the-truck>
 <20240507140946.GO3341011@nvidia.com>
 <20240507142248.GA22453@willie-the-truck>
 <20240507143321.GP3341011@nvidia.com>
 <20240508165333.GA23294@willie-the-truck>
 <20240508180423.GN4650@nvidia.com>
 <20240509152322.GA24667@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509152322.GA24667@willie-the-truck>
X-ClientProxiedBy: MN2PR01CA0049.prod.exchangelabs.com (2603:10b6:208:23f::18)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA0PR12MB8905:EE_
X-MS-Office365-Filtering-Correlation-Id: b6c7d709-45f0-4c03-368f-08dc703e5d16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+Z4IFne65HP7l/NpALE36YyJl+wkoamk6Xq1lVagfCxgXMVtpqtsXfMhgr5u?=
 =?us-ascii?Q?pU5euL2SfAg30G3kkvSIaDAagmxQQO7Cp6G5EYvUnBXJF5uG9zV5SngRu1AQ?=
 =?us-ascii?Q?jG1YTC25mLmMRzthzKRlwyU4bKHXU+CA0lkGLJyILnByMqzOXS8iiGZr0CCZ?=
 =?us-ascii?Q?3grUtm5nvQtZokxn0MT8J8PzF85sFAwKiimWMVm19HP+OWw6HfvYTZu1/B+V?=
 =?us-ascii?Q?i2BIMJihwz4UcXN0EKd4q+/7XacQEsfpnHRHNv7t0Pd/zeyIfQogv+CvgwqK?=
 =?us-ascii?Q?bhknlsFU7HMd4JLHaRgpblEXwJR771NzMiV5n399IAFlbKOnEGweBgNeU7ql?=
 =?us-ascii?Q?2+NBP921TV77M/2BImAxLswhK2u3rEapJV9livJpKkK6Emud9M7sHB/Gr1ux?=
 =?us-ascii?Q?SK9oVrd0KB3Xlh6eDOBpJSsEd/7U3KqxoKHEee2CG1SQAm4N4qy6/B1QScaI?=
 =?us-ascii?Q?kQobkjsCJ29EYcoh5pdfgWiuRw1vdXuvwPlUBTwS17JBq2YYcb9/4gsKWN3F?=
 =?us-ascii?Q?TYh48pM09/2bGCxdRHG6/wCeCMXX6Js1nFZfKQvR4kmCWVbTTaU4Ev07IOAQ?=
 =?us-ascii?Q?XcwmhCrCu0R1OtZlOovrWzi9Ll4KH6BT1fUWx3sKLyL8QCXvYvR4nv7ywuYc?=
 =?us-ascii?Q?NzBhUiJsfhvUm50jxzcpGmcUrIUPJjSVq9DJYgl5JHwFXYJ/HZIWpm5CX3IN?=
 =?us-ascii?Q?yboENxJCLGVuFosEzJWK2obZzPfPsN2P2L3c0NcDbLKXUgLmvBjrBUKdbHRB?=
 =?us-ascii?Q?CUqnPorNBabWTfZJXzgy03qodfyZ5yW6MlJnkFBtnK+iAh6P/yGuBszlxmk3?=
 =?us-ascii?Q?ZAUwdYIlu+59qQP98ri5U0FQvmuxCgol7795BxPD3ocLnve62/mTB/z+FkIM?=
 =?us-ascii?Q?K3aM/HSNYMhngxaKclhUrv/eSHutysdWJ0KBH0Nt1puBUpyejBhhh6HDwzGF?=
 =?us-ascii?Q?a7Ab+4c1UqCBVpGEnCdMII6PMH3wuRdneuiMtrHuO1jqAYb2+7BSzZYYCzWJ?=
 =?us-ascii?Q?3h2GpoHRUNdkbKqYL+jV2Qz+DD/xAg4dvzFQK64Y4cB8i7VVvh3BmVOR5R/y?=
 =?us-ascii?Q?nnkhBhm0naXg1iY4BbR3SkXdHLwrUswJoxgmALsgw2fa1I3S0+iViRQWGINS?=
 =?us-ascii?Q?jiUVtycErLaA8Ki6tKXHDpsy5gcAPzhBsGDT0mz7K6FbEkBUN/BU27EMhGS8?=
 =?us-ascii?Q?kX0HY4DW5Q1WRNk346clADnpMHiKKT21gQUAlCBhsqr5xCJ3+S6oao+Xhw7J?=
 =?us-ascii?Q?ALK8I0849YTiF4rGub75WlLn74TozC9VuCExxf2D/A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Tb0ua76C9C68aG6zpunIfSknO4FZ0ayXJ5aYWQbQf6UBwIpjABBQF8B0Us7J?=
 =?us-ascii?Q?peCzT82CEhB0vMWv9dOtL3azr1Lk9uG+ciNqki/kEo2+6jac9VoqFz/AmJuP?=
 =?us-ascii?Q?R0lhxTApl68vV02mnhF8PrTB89R2bkEUr9aZTHZzt0bkPn60gCEqiDpPfDiD?=
 =?us-ascii?Q?Aj5qk3pOfYBzuM4GljSU2hjCnE2zTqURbep180PO9AjZ3kw2zuaViJGH0ezd?=
 =?us-ascii?Q?V4iBGPRWsn0Vu8QkzBfHHpErNfq0l8k2gfAjLQUUirOP5ZjNrOs+KpN5j5kz?=
 =?us-ascii?Q?1G/r50RnzKnyLGtT4nYr10qN8ikbBd+FJufnb9gWo42cMoh/RFHuI5pGX6Ze?=
 =?us-ascii?Q?tZ0scWEtlfAsL6W/3+TIorl0X/TFMubg167PUfYwUXkT6h/cL6xRn+ws4s5+?=
 =?us-ascii?Q?6SVo4eYDhoh9hzN4vrBDz6fR78BE7GWaSR7cnRGPWJHo0PT/lM5MwjzzfPXc?=
 =?us-ascii?Q?IVWVwtFUadAbxl9LNUryMm4Z4fOVPsqXwSkOkAn8stHBMjE6Fdqcdg6HjIwQ?=
 =?us-ascii?Q?GT1qDiBIlRPsXUfeOQ96A9qrUOj4Nm5OnvVPcvaoaKwFtkLT5UUrnYIuG6UW?=
 =?us-ascii?Q?xFc1FDosAxzx3cVwOYP/vQudrIUAZhCwUf0MkAJDDLh7iinet3SaWA8SIm0A?=
 =?us-ascii?Q?SLfoIcYV2Ii/5xP6W0D+euDQfSImcl4b08UoPUmoAHEYC3r4e4pIsL7tchSz?=
 =?us-ascii?Q?xtRB8CZyOuxpafm/wSrZmPgYDJoTwwC2OY2DmGO/m6D4ZYF6XAgim1sJkqUK?=
 =?us-ascii?Q?xvSJnFwTwUVZlVaUlUTV0Su+IEOCFmJ4pc9PLcRJljdqMp1UsfGpSHpi2Ksf?=
 =?us-ascii?Q?pb+jvfpunaLN42J3KYH81nXsH5AmvEYlHsC4VP8lomuOMMie283SUPnIkJq8?=
 =?us-ascii?Q?Yax1T81AvlqSmKQpp4XrJEeb4MGhelzigNAWfw9WRCcFBFNLLlv/ZsoZ58d6?=
 =?us-ascii?Q?Nx6Ze2B8DrhcVeoqjCwpKRGgg1IvRPwGIV5UXq9WrwG3dG06CGRKp6sQrQIA?=
 =?us-ascii?Q?q+2gajUSzJnNxuEcw1pLRmsvwZ8FLPmb9/j8N/0TlssyeYLUxlAsz4bWQ7Tl?=
 =?us-ascii?Q?T93PxrQNeIswovxh1o7YULiER0MHrGp45XilFpgOjYmSv89VJnkkENUGgCjV?=
 =?us-ascii?Q?6C7FDSfBbdQNTAVwvikq6S7oiPlP0W04eD+ay4xzHYVqERn6kad0R4poK4UH?=
 =?us-ascii?Q?8NCC9oh6uinXQvNfKlWHNtT2g6QBT4CDZAOmdlEx5zgFMTPhcwIu6I965DFd?=
 =?us-ascii?Q?qGeBjzfUdhJc2lsckkP4IjH+NfQkSAJt0+x6zYragMPfZJBfOSQ9TL+Q/OLZ?=
 =?us-ascii?Q?YIDgsXV/HkTCFvBk19nLS6FaxAPxUJn847YjGBmYekExAmMzjgjGGtVfnDIH?=
 =?us-ascii?Q?P9V7IGqMeEvrxJi/cEaFFm4lIVJmlZr+wDzPBvQsGjTl4YY6nUX8TTvvUY7o?=
 =?us-ascii?Q?tahBJKMnL9xna1xnJIIOP4dmGzlxkl/Qjpb7VKjVR02yZxQXio2W2UOHNeV3?=
 =?us-ascii?Q?DZbIoQwb6DGKacuBRfG3KqZAYJF431XBTZVX/QeLCr2TNBPk5Cz9fQtnHoGk?=
 =?us-ascii?Q?Czy+r6gKsm6DJvPWZIIqijm4fg4VA/rOVoQoS0oD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6c7d709-45f0-4c03-368f-08dc703e5d16
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 15:40:33.2987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3oFSwirCJZVzfRkfuIIP9ZFFQ+FzNLTUVEEXo4AjPE+MrGg2a+mZCJ57RkzcC3V8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8905

On Thu, May 09, 2024 at 04:23:22PM +0100, Will Deacon wrote:
> On Wed, May 08, 2024 at 03:04:23PM -0300, Jason Gunthorpe wrote:
> > On Wed, May 08, 2024 at 05:53:33PM +0100, Will Deacon wrote:
> > > On Tue, May 07, 2024 at 11:33:21AM -0300, Jason Gunthorpe wrote:
> > > > On Tue, May 07, 2024 at 03:22:48PM +0100, Will Deacon wrote:
> > > > > On Tue, May 07, 2024 at 11:09:46AM -0300, Jason Gunthorpe wrote:
> > > > > > On Tue, May 07, 2024 at 02:58:17PM +0100, Will Deacon wrote:
> > > The DRM_XE one is tristate and has this interesting variant:
> > > 
> > > 	depends on ... && (m || (y && KUNIT=y))
> > 
> > Yeah, that is one of the novel ways to write the 'compatible
> > modularity but not force enabled' check
> 
> Bah, and it looks like this has its own set of issues anyway:
> 
> https://lore.kernel.org/all/20240224121528.1972719-1-arnd@kernel.org/

:\

> > I suspect alot of these just predate the EXPORT_SYMBOL_IF_KUNIT
> > infrastructure and should probably just be moved into
> > modules.. modules clearly work better with kunit's ecosystem.
> 
> Fair enough. I'll suck it up given that this seems to be the new and
> improved way of dealing with this problem. I'm just a bit paranoid about
> exporting symbols (even within a namespace), probably thanks to my time
> working on Android.

Indeed, this is the primary reason I kept Michael's original
integration as non-modular and didn't want to do this when Mostafa
first suggested it.. kunit is new to me as well.

Thanks,
Jason
