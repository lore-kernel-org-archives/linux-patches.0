Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C082320AF62;
	Wed, 12 Feb 2025 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739369003; cv=fail; b=lMiKvHCISRzBsOEzNt3laK23If5kemawrnjShaf9a2XftPkWyxCTQiZCfAnoFoA1HeIeE7t9P/2OK5GVCgkisFhrPh+mLGS4BHiDLXM86HTI9FyZF6Bhb+0CJiLgcsqFathIuGF5bsxLkiS1Nhxl8W4FG99pHkK/D23suB7OUlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739369003; c=relaxed/simple;
	bh=3Uqui7iG3Ml5OmhxQ2yUiBuM/Vzd3Qz8GFI3ijocn3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dbQST2UrjVpiJVzWyZv5V+eJINLQ2qzUN6Wq1ePM0swousCQmOay0GQxwOT7rL19pVVoEHgvRnBWOyR+yjpF9/vCxOQythDi0+xYG94Yxf+IEQYSKNLbF2NPzyrXN3LpAwvkLv9xalinz6zHhI2Ph16EvmEOSQvUYP7CBbQeY4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NXUrQ9rQ; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NXUrQ9rQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sYdgofOkk8zYrtGdfZygGNMNd8VyQnYolHhoixTUxZpJ/Wmy/Pe6FS1P387i5T5suyp/Ew/XU/kyuxHqSicJFqlJyG8EWqECBKAfiKNiK27cKVaPzLFcRDk/DRWwfSozC4VdvAk0x97ta2eaVsoZYdI/x5Vl9mJDsv1VNo+knkO6V6nnIENlI0JZ6z/tYZ4BJOsO19cAE2e4+shPVFkjwq58KgSzBjOPn4qH0kKMUpEPc37RvUJbUHR+VIsVcN9wKEBvVXHxLHZnjb0BC5BNN87H8ICvgU8IbwPtGgxt40f/uS2fXEqaG95VZ6cn089AmESwqJGJOsNsA1wyY7RhyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZeudfJ5c7lxGATRgDUI/4ImOA1z+GjT3kgT2/c2apkA=;
 b=O5Ee+82Y4b9bby+wmp1urSW1qkVbacwrIBVkBcLfAdo7kovfLSVyNsQe/XdEZTq01+fcLOodLtg6N+3M0nrR9mCTUkLRkZ5jWcw//5+nXG/U+NYGE6GwC4/hlg2nBs8L+cQi8OF5IbFOWykaFXhVMO7fIzMbLn0nKouwhzhTsAASpI+iH6sCaKO+SDdbw0C09YyNWNnFXthe9PqJznAHa1Pv8BRW/+zmrGTY4M1hxJa+o0WYpExCGnHXMm1mDpFubRlZmR4Zl3JjU6UJtm6l6b+BvdtejcgPPc/z1AveV9YX1eksji9wzJp4lH7+FFH0CLLQVEtB0P15zhbqTwvjlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeudfJ5c7lxGATRgDUI/4ImOA1z+GjT3kgT2/c2apkA=;
 b=NXUrQ9rQKSydOulBHFN3gUebYZ8jhqAysv7pYFQHTxiXmwFbbglPjWFhParHfT8rv4CGuOQl/k1zMlgO1fq1umMkzofSgG0EQaPmSNOaUFlOssD7MD9NNFKLsYvI+iXKTD4Zke7ZfLgoGCEnnRre0b2fwifw+E6OF3pXQP7yM6jbKwJK2+A7HtF1YY7SViXK7aALD8lDs8nwaHKuULaGGJ3CrAOfarFCJxVddwbxANb+X4JtZYLYJv49GIhpUs17aEXpaSlGaSk2pNFOUK3FCK2iegxfQ0SgQwOHjU8U17dD/QpbXrCAVIdbNv5L8uRXy+PbhUpccs8oVlSSM5avuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by SJ2PR12MB8719.namprd12.prod.outlook.com (2603:10b6:a03:543::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Wed, 12 Feb
 2025 14:03:18 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8422.015; Wed, 12 Feb 2025
 14:03:18 +0000
Date: Wed, 12 Feb 2025 10:03:16 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev, Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 2/5] iommu: Add domain_alloc_identity()
Message-ID: <20250212140316.GA3844591@nvidia.com>
References: <2-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <f0164c18-9ded-4c41-a8c5-c225a978973d@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0164c18-9ded-4c41-a8c5-c225a978973d@arm.com>
X-ClientProxiedBy: MN2PR01CA0066.prod.exchangelabs.com (2603:10b6:208:23f::35)
 To MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|SJ2PR12MB8719:EE_
X-MS-Office365-Filtering-Correlation-Id: 64525aea-723b-4f72-9215-08dd4b6e0088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KVD9t6Uh8kBbXTrmM14kHUwQymSCqHGrnb8yfyntxWVaQfBKBP7CxkCReyS2?=
 =?us-ascii?Q?hOZN1s1iSs6Gh7Ve6lmrJQR3pSBSgcTOMAuPamLyBLHpmspFSMS2e2FuxGGr?=
 =?us-ascii?Q?36TaFh1WcO8LUlUZBrspJE9ZGJkF9ubxKABvf3NoIxIWAbJpP7APl8Hlj13H?=
 =?us-ascii?Q?MVSW/Sp6rPb6fgu2bSP0/t8dsZu3S25PBbV2ZVR9Z+zcH3H9WFRG3DdnCgM1?=
 =?us-ascii?Q?61V/TAw8HUNmF2vpBJoLdhmHK0TRrzKHZL6Dzu4g0tfZ+eOwRf3G/AEdMAAj?=
 =?us-ascii?Q?OE+IaF1DxYrOsM21gJXtN1z0wZ2LJgyd6zX1wUrJ5lHxp+YI8GDLJKB8RJ/J?=
 =?us-ascii?Q?Tzfe1tu59PYLIxLMWOQp2bzfQ99MeAcaAAeBm01v1BhQoAMv0zyCVTQa298q?=
 =?us-ascii?Q?sEXalDTHaqBtHHM1KkKsHd5DKF3weIuyGZmSDaUysxG6XG60Gp1szk5+PLpU?=
 =?us-ascii?Q?yQlvSVSAFU5hQsjuz2PQ1KmA2eVPuRGagrmVr2RXhoqv3NJIlC7nkh7DIQFn?=
 =?us-ascii?Q?FWAUx43q+yYVl/tyWdAd4LBJsAb6MavDO81UZlpGVK/Trh4FLpJn8KWEQpe3?=
 =?us-ascii?Q?xu+5bsMSYonqv85OHhy1iWz5iMQFiBSOIZRYUnxYzcqfVnz+Fe+7qX/2W6NL?=
 =?us-ascii?Q?ktPGlD+rMzKQEeAlSm77kyhqvR6EzShyMfmP3nSqBPIUPKoFhMEvIoGxbdkY?=
 =?us-ascii?Q?7cXSfr3NvsyE9v3p2xfcqNNvwtk64jiOrCtXTuqAVKNifSqI9WuM8Zbx5gHK?=
 =?us-ascii?Q?6JS8cpP5PCaEjhSnb71lAawEAlblSsd2ZsHulRf4TdFu5wtBW6ORzSI0NhIh?=
 =?us-ascii?Q?hhNRXsqmRUQEhdOavTELyMUKqDO6Sua7ADRsm+Bnsv0evhdAxsv4YyopsE1n?=
 =?us-ascii?Q?2+8C9Yy7bOhau5N7TS7EBVuJaTakF08dHmnkGdxqjC84N0vw/G9jZieIDvan?=
 =?us-ascii?Q?oCYrxpx2arcSF8EoXkWkDs2I0iiSiSbsUEhSTMK3VNBVqSi49S7ZunJ9YGfm?=
 =?us-ascii?Q?uHKFZR535cVIrp6ESgX2b1hxAKzOojWmwkKeWGGHukKhcn+MaZs62yxCDI2t?=
 =?us-ascii?Q?rDFxD43S1dTjzQ/7JzQEJRfOWKyF6RAY9m/tYQ5PKEumpX+tbog/vU6UrKjd?=
 =?us-ascii?Q?98r0xDnu8+F3m4PGoTZW5fqFhHdp1hS2mH4DYAqzXE8pZGEs6j0BqVmfGsW2?=
 =?us-ascii?Q?o2FHkmqe0UIRALpfe1m25Tlca7JNx11JEqECgi2W6qp4UDVn2F3BgkspLr+P?=
 =?us-ascii?Q?vUaePG4h+Glel/1u1FR3JToqQLQDLuAYVriDWVaY7AtJ+BSZ8YfCr8FmXfIL?=
 =?us-ascii?Q?PXUmRByoKVrcTTaJ95OqQnN2tre6jHLU2+WoXitHHPuOGEpR5NhGh2fZvW06?=
 =?us-ascii?Q?k+LG72ke5d+GB73viDwfyUpgXNZt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mu0C8L7rRnw+QyTBvAhXxUy9fVIY19ZOGSFZEceey8RL5V+MHGl/oadHq/Hu?=
 =?us-ascii?Q?DZGCJjlvETJuC6Zh0/8HnNgQcoqRjgcGC8pwKod5O+Cu6JyCAx4QEi6uuJvh?=
 =?us-ascii?Q?ioIVf1PP6g+YOwpIGSt3ewOxHXbTYyagxW9a+fp3bzZYawCWEELLylH0Q7rD?=
 =?us-ascii?Q?xcKIfFpul1gYNxpW2W6xhU7ufy/khb7tnMxdw7tEpW6LxbkCB1DECsPtLMHa?=
 =?us-ascii?Q?EVb5nBQJzC3+o+uDdQb8tydl0pC71VS/RKPjDCa8Aig9klQz4KKJMX/VPeZz?=
 =?us-ascii?Q?YhcGVXlrSBdAiIjDBNVaB/Hp9GcIUdRBZLW/3h0nice3Vh6DO0goG4CfIrlg?=
 =?us-ascii?Q?/y1UBiflIzKlcKE8FDydgoqXEZUWXb50XmaSQUJ5Mxxfwc8biAqNHNpHUQTe?=
 =?us-ascii?Q?znK0ZE1Jcr3fuLAhOy3bP1edmbC8PrvkMJ7/H76Cuo4FuJxuVsglKV+1jGlV?=
 =?us-ascii?Q?2Ia2j7b+E0IIeVgfLqkC9aVkBhrSqehNVGnXo/4C9WucBswhVC0j4PsCB4s3?=
 =?us-ascii?Q?96DdajdbAxQOu5IKIDmzJYftMwr0e+eFlFwqVFpTA89uuHmWM06YxB3YIXst?=
 =?us-ascii?Q?Ru82quB+Be7u2cVi64rSChYXQoM0J7K180Gjfi/9bAlbPkYVzMkqS27mH5up?=
 =?us-ascii?Q?O92e090/3TmhwvBXE/GxQwB6Inhqj3XPscrVRzSlKMscD7jd6KtZWPSstKpV?=
 =?us-ascii?Q?NCKCRBn1A5qOZEh/jmNSR78jal2BJWZ8yqQ+7NKpYposdt0jPWH3t5sI6N25?=
 =?us-ascii?Q?7X35x+8up8459C3ah+ZTxml4qqNXv5sfWlqTuFch6MlnZjrK66FCS7BSVUgs?=
 =?us-ascii?Q?J0X6fG3jVw1PvPlB39xXnrLSOh4xAPxO2ofTI95UAzwu5R1HSsmt3/oH9Dtf?=
 =?us-ascii?Q?yEksdYKC8fx4FROPvuZbRP8bfUYhrhCpwR/im4nQE7S65q+U5pGJcqxFRfal?=
 =?us-ascii?Q?qDBTUs4lmf4D+80ifZeX1Yai0WFNOLdjiqAylJlr55kSwhjzlqKOLmF02tZC?=
 =?us-ascii?Q?fYebUwYh2orRLp+KuRO45tYRLLTNR8+cyY+/RCd9k1PgWXVM+POJI0FVL5WH?=
 =?us-ascii?Q?emAoEdcxlHTc40wWs0EEskv7jgsO2WhfVsho0ABf6PF94cRUce0IQu7x6Gap?=
 =?us-ascii?Q?emiwSE+zbEiQzP5rU4W/d1nkJ38LWkwSc+NRnAm+qSwwjym7VNU7a/j0fwB4?=
 =?us-ascii?Q?hLcrEjQlGNNbUC5gKURcJfr9AYf523fnHHDn1Ih31uazz/ud1VTaBOMF6LCe?=
 =?us-ascii?Q?e5Bk9G6MzuqkmL5wsxFT+fwLPLg6qUUFqAuRG54B4RuxjsAgDqeQ1IY1+dvd?=
 =?us-ascii?Q?IYW0UkU80Bu+PywJwlIvbX0PHqEsz9yUDSFYdgSmFcGch0xtGWVmf/7cmXp8?=
 =?us-ascii?Q?2vNsqrlTM93KOoyYHhODgKpGdna1mvQJ9O12cVbkuwMWZCHrjObHcN0JyyWl?=
 =?us-ascii?Q?J/3mRjbrn5KJAmF9zc5jVgDFZMJKSifrIPWSzYIHd5SF2EVSaf2bHv6if0GT?=
 =?us-ascii?Q?6AUc5im/RqxI1MCgQ/C6SnyMGImqZd9+lxucXnxCvOSA9iTr7WHqjFV2vZvX?=
 =?us-ascii?Q?IYyTdBAQRhDc4kTeYEL7BmVoSm0h45whDWI4vhEg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64525aea-723b-4f72-9215-08dd4b6e0088
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 14:03:18.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TP6++hhSNQsv6rmFsw2/b0HC5fC6t/sfHTUZ2/ogY/OJYFk93k3eRgZvlLV8Mj4u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8719

On Wed, Feb 12, 2025 at 01:56:55PM +0000, Robin Murphy wrote:
> On 2025-02-07 2:46 pm, Jason Gunthorpe wrote:
> > virtio-iommu has a mode where the IDENTITY domain is actually a paging
> > domain with an identity mapping covering some of the system address
> > space manually created.
> > 
> > To support this add a new domain_alloc_identity() op that accepts
> > the struct device so that virtio can allocate and fully finalize a
> > paging domain to return.
> 
> Oh, I'd already managed to forget this idea - this could be convenient for
> DART to implement per-instance identity domain support as well.

If we are going to broaden this someday then I suggest the core code should
implement it entirely buy asking the driver for a paging domain and
then mapping all of system memory into it. There is nothing special
here that needs to be in driver code.

Jason
