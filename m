Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012051.outbound.protection.outlook.com [40.107.200.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D16C39E9D5;
	Mon,  7 Sep 2026 19:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788809673; cv=fail; b=PhMEaSNYiUrTuSBvqyYmaV4H8tT2l6OkMtGwObWJEe7Mp8z+FQPTYEzRl2eMWSQ4/WfWPR05aCoO2iY+VFkIO8YzVLUgQHgYcVbrwfSjlORTstONRN6fkPDvDrEz5DoNIdfXRTv4eWuS+4zll3iSb42C3WnYqAkyoPULmszin/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788809673; c=relaxed/simple;
	bh=MkNtNrB3bltsATUVfblt69UC99p/M3oakVLq4J/YMqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J8nCnh29Bz+9Gh7FTVqwLUiaXLhDexhSBQgWdnv0ZR9dPkLGwmGJ4uWmXiHd922WlnZKD42j13Bm9M4EAOIklQvBMrvbTkwYAha6H/kZiHWt9XLeXHsWWCVTAKkz7jv+ZMpgyBvrgPknvgJT87DbnRhupWJg4WO6CZzHy20hep4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aS3F51Kd; arc=fail smtp.client-ip=40.107.200.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aS3F51Kd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s0Y/HO2ykwhMBuWktzqPg0lswYNSP7rcyz4JG0b8zc4I/sDxLRXC/Q19+ZnLDs8fd6dXYgAo+vIzx4aqdkP3dCWfRUtm2InXkF4Ze47tUn2TTJMAkajfRiBSbQn/Ar20ZYB8f+cMdWZoYyjAgJUiMqIWRmlXmfJ57WBM1qs1GipxIgUYWz7p3wFLVXOAnGabag9rY97Y/lk7WW/+qZRoIV+PUtTwYzn/rhcUjZSMQqhfju2nYOTJdFJL/waLzAQxQwjZU1sFbspJTBfORhnoXL3IjLFsvhj4Kk1NJ31pJa9YAUgPabeB0b587XaHLD3raIT+CxaYJmmwWobZTwMcgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ziatc8YI5wFhvGyXii9wbqkMBTvZ3UhN8EcK20xOdUk=;
 b=D6htnNzHx2JP7EgsH9XRtiy9T1cMjM9zMeUVqjaxfo6eOjwnbEwRCfRt8iWTt/hU/CX918REfQC0LQU52BmAZA7JZXVh0YLsT3QE9H47c35+mIkXRpPJkfNTF4v42Po5WjYRKpMaTBDKNNISryqSUSxiHA/97HP6mqoxMTszIYWnRQzRUS3qaWl8xsY05EhbAdg+O7lBFoYx1x39z19cyhok2+n5EkMXe3N5cc9ZkfaFMCcfSUUCSvCvqXkd61kDzhuoHUUttoYaO3fzTpSz71bdiTEgXlrOAFrwjae6XmxLkaU6UxQyroTonK0pTmQBFfkYmDifIW3K3Fxjmh8FXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ziatc8YI5wFhvGyXii9wbqkMBTvZ3UhN8EcK20xOdUk=;
 b=aS3F51KdiCm6DRezCsXHaeigROgazN0QSSCvf467AVQwobMC4+b3q6qUAIg0gFq+LJc6QrXrq1qFJqPXwBEczWY7N49yVKSyxa+EDC2xAhygqVLnhjGVt0xbFRlXKkSEamv5a+gKEo7PY0Nznvoqyaj5e8+yYvMDp2rLl4Mb4kwhMI/2z7EiQ1UfhXeUIIn/VSQnU1n8KcJmmdhctBZKaEqYTVkhjLaO9Zg3qGh8Y+Ke1ApVLIRkRtDuMs1gXxtKHwAOj57cK7DNnqXaAwt0L6/Xz3qPQ/j1Fve5OA80IOPhdnCtamM7J0lalmX1Dm8afRhezCzsL58Ngiy+/8JRLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS4PR12MB534619.namprd12.prod.outlook.com (2603:10b6:8:50a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 19:34:26 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 19:34:26 +0000
Date: Mon, 7 Sep 2026 16:34:24 -0300
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
Subject: Re: [PATCH v5 4/9] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260907193424.GA2774068@nvidia.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <4-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <ap7JiB36YSQOaV9a@google.com>
 <20260907152305.GA4157646@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907152305.GA4157646@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0388.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS4PR12MB534619:EE_
X-MS-Office365-Filtering-Correlation-Id: aefce4d2-7998-4783-e91b-08df0d1706ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|10067099003|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	bvDXqFyp0eqdhbXBMT3O5yyzEATLUwyXb9PG8yCoWhH/VMWln2xI7D8ZjelPreJddRV69Rc4Ni7mAdD7kIdOOvolwkHNUgzr4HxBuGCSzCgwEc9aYVB9DN1F3f2JtWy/tIT//1nppCyrVbyQzSk7+AqB4bQAgDJWRAJ+u6TW4S25oAQB4XlC6LJQ0WEt6JhbnLbng3PTrIMlB42KJ2tx07PyhXQLUrYsVga+7nUTIu2OURLGxsqMOt7ZtpjNy12Bpbc5YaVqLAmz2/EyjX+3kgQy00yHe6f6V5NbLm7d1vm+UjNCE3Qf1k3ZRLNRYuWAvpvKJ6R2mL8rBYQmAlTgYFqDxgigmzqaPHi/lYLoXV+i2eFT3+3AMqv/UFXgGvPQHwvxYeejcHiXc+MzLFJ9L9JeJb9UgqJ11ta7xYd8G/Qvnwol30wF827LT8QF6DoXdzakXmPhDDxz3CIck+/L8ugV5dozvA1QlUiTR2Mc2YYmzyfJIhw4nbPHR07I1zi1M3ZgkIXHWX9yjcp7TeJ7Nr1k78+YvVxjnnfEMq+3GSgXd1o2Uzddx8O0zkPM4AkdG2QrcIlH0ziH8PiN/+rmEtfGgwThRGtFAsx3fdEGHV+ywnWmK/BriDCa282lv9Lqr98DbpUEoFB7+kX4aeZGEQYDUttX6hj0yg0sdOxnxv4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jIOUi5YuTvQWkMZ2keyh0xsXFryigkGgwlQ2A/EBVkrAAWtNk33TLuPzKFhI?=
 =?us-ascii?Q?At5t0Lrbn+PNjE77OyDh9nZ7OerEzdysiYSPZ6kajjantZSg2LVS+Jo67UHL?=
 =?us-ascii?Q?h0iWb0LHDXJLSpnGWYt/KqlMau35u8128bD7MiIOS9k5U/Zh3Nfjmy1b7IAy?=
 =?us-ascii?Q?qNYDXhh7m45zMg8PIcmviY7uQ8/evBdmcWqRT5Pta16O7zgJzKAPtunOT+fv?=
 =?us-ascii?Q?yd5jOIAKd4n9Yp+t2NyUfHAyivLiK3P/K8JubGVISRTOnSZ+iItsHUthzANI?=
 =?us-ascii?Q?WOd0Bp4RZJH6WJAxT4Jd/aNoMxCuoHKE0hjITKksNba6gE5M2inZkiAUKE+y?=
 =?us-ascii?Q?WBjhi3AsJ2ZErDLVSqRZFQpXwVS0HNVdEd4zXR8gLiVOCSrRNGnK0eVy4S+Q?=
 =?us-ascii?Q?mqY5Xm9BMOn7aTOqba71qh9gcgXwstgi1yC3Xr+dMRQ5qDT58OY0F/knnJBN?=
 =?us-ascii?Q?TK3cfdz+wgZOTUlAUB2/UYxljq6EWyqItk/Zr2zCWoamsf11b1MZUljMIUbg?=
 =?us-ascii?Q?Uu3oRTZL5fPKTrabz9EmnndWPRJlqZmIB8rNnfl3MI1pigAjhqAOLi072Ksu?=
 =?us-ascii?Q?wAuIb9D80ZKwMf4X3LyP98IUg6Vf9nAtEwHQeo4/6GxxMEE+PjXrr4ylNvWP?=
 =?us-ascii?Q?lr8lq9G7Gjs0J/T8yj/ChXPtGTr7Ge0Os0k9n1fpNY022JBl5k2eqeRC9ZhK?=
 =?us-ascii?Q?kBMFQgybRWIfo48pDP/OuPssLJPJATo029zuYcmuf2sCNtQ04fEVmPEo6K1I?=
 =?us-ascii?Q?tgkexYiMOrRjKY7XZDw6//svF2vJ6tIkCs3nQ5SJt5/lTy4MjHUvhic/SQ+E?=
 =?us-ascii?Q?rMNvAt+vFKSrT3NNYs81evy8uyu1ofOnWz/kC1oWqKYqVG452OvfsEnQiy7B?=
 =?us-ascii?Q?FAoZQaDFMtdR0F+AHunzXgW4evjk9mLVKSK6EMyr/z5CFiWq8FDo3QPirSmP?=
 =?us-ascii?Q?zONWf5yp2HsmvxKjRs45DnVLQrFbarod8s2d9j+BTmhaJvKsgGs+FvJuSXH/?=
 =?us-ascii?Q?dPLtXqUEGv5rVGtqb8wbFX3l399F+svOKpPiB58WCg9kwMF7yJ10OJU80GNe?=
 =?us-ascii?Q?D5ZTOlSmfLby273bWg27R3u393l5xxXSqN+oCtVelTjUFd+oUVO+hQbkprUX?=
 =?us-ascii?Q?IeImP+T/Ey64lF/T3tG2023rhJh/EBTUPHpt4qC6mCWfcemqw2cyFoG2ARNB?=
 =?us-ascii?Q?l6evhsq717h/rMZccbW4us5tpxcJzSd597jk1C7PladRvY6XC0rBKMYX3WAd?=
 =?us-ascii?Q?A94sIGkK2lEGNi2Gz+F4gztuLRAD8lzHoAlBHkyhZd0AzV8Gk0/88YspNdVS?=
 =?us-ascii?Q?L77UQ8Vnm0lMktAl3+3N7bQc8poGKRDaYRAsh7pFmWnvNFvkNp+WtVIp860q?=
 =?us-ascii?Q?lOD2r260F7mNcFPcA8Sy1K9TxUD38+Ug0ItGdiwUdiJBn+And5xXL5udHApT?=
 =?us-ascii?Q?8L7RZgCOJjeuwBgY7Ggv9HZPgVIJhLn6X2b/UvxeTBWO1udBvLaMcQLRZ2HH?=
 =?us-ascii?Q?X8pxfaVs9jFm4NF3wr+ssLThbYhkakSw+k3Oh9okHtb/l6eosdqyaqtI6vOX?=
 =?us-ascii?Q?zO898vtGWC7RjTEcxbL8zMB1nUIdLfIuRZZtRtLIlPkhO5I2MppdGoetjDv1?=
 =?us-ascii?Q?imUrbnMFnMdTuKqE+QejGo3vDLz64fh+c5z2glxo46sATzXJjBxg2pa0ge46?=
 =?us-ascii?Q?OJjKi/oW/DMf9ZphtjepoNNqy4SIwQgx8Tr0V5pzbhuCnBLP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aefce4d2-7998-4783-e91b-08df0d1706ee
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 19:34:26.3424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISIakLkVWZsu0uo/KD1yesjStT3lveh6Ay8h9A8QZWYux5Ax7rzA91RkWUkTjUQq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB534619

On Mon, Sep 07, 2026 at 12:23:05PM -0300, Jason Gunthorpe wrote:
> > > -			/* Determine how many chunks of 2^scale size we have */
> > > -			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
> > > -
> > > -			/* Keep the pre-DS 5-bit truncation when scale > 31 */
> > > -			cmd->data[0] = orig_data0 |
> > > -				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
> > > -				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);
> > 
> > That just deletes the DS code which was recently merged.
> > I see that is added again in the last patch, but it would make more
> > sense to do it in the same patch I guess.
> 
> I missed it when rebasing, I'll adjust it

Actually it is correct like this. The earlier commit 773f2b9e3670
("iommu/arm-smmu-v3: Support IDR5.DS and widen the TLBI SCALE field")
did not actually support a wider scale it just widened the field and
added this protective truncate.

So this commit still does not support a wider scale and we don't need
the protective truncate because this version directly limits scale's
value.

The later patch truely is the one to add proper DS support and it
doesn't bring back the "& 0x1f", it adjusts the new code that limited
scale.

Jason
