Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793974895;
	b=jykBnBxWXGdf6/VLoEes83NSwd6E7xWGYPwHK7k0tWnlTNEGysvNYBGHUSSoLmPk9EBe
	 +TfiGseYrZEp3lF+A41TBjfp7FBGHi4LtHBCKaFamK0EqUzYzPEupq3AyfJI83NNoJyfZ
	 iIpviWBk9yu+hD7F+CHL7lqWH4w6v7bnP6u+4CsH2yw+JT6vV+N46Ixi/5Pkgfe+nObNx
	 1ZNSMsu1tlldJUrtqUhR8TT89U8QXl4QKCh1NNwrNQak0UYCisT2Ymm8foVCDXOHEfMMp
	 mShMn1RglWl2PauiPgYU40T06K9Rer6y1hFIHYiOoi1LLXpbAagiKlSlxdeyQ5oPgdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974895;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=LgazTQ+TfMOC9KhctR7bKf80rTZabzVXUlU5GV1VjGA=;
	b=ZMLYw5gVyrd0kR8G5UHwQSne9PqaMlJDosBewDxrzFkYPj+R99PW+FaneXUuKG1CPZ9S
	 hCA/MootujvGqodJK2sjACdeoI4hWA7u1re/HIV+FEVLdaQVfI1gXCavsD13+jzUGYs5M
	 kg/i1KhjXVsGwDIa1N37gPQ9yIi9YD21joTKyN5B8VaJUtOZsfuEh990byDheO4Zv3d9G
	 HcN11az9kU7x9N+CgXgjzScsBKK3mQYi7D2roXkQ/fyOtZsF0PWWtmJzVfVIVIFtMIHa/
	 nocSJd3cmcMcwjvZ72ebN2txnacfClNPYhpFrAAkYt5wMwDOjGUQuM/tHvcU/89VaFw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="pp/liVqg";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.33
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA3F606A326;
	Fri,  6 Nov 2026 14:21:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BA3F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pp/liVqg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BYoSOAyYJgI6K0WhSqV/QJmrWIlyNuUV7JmH5DeUZWc/WDrUlY0nOK9l+lVWOCF8JamktWnECxzj6hd6efbt93cPZse20H0DdeqR6mc3PprvOFFmuNj9qWqpCdVNfr/3TPtJCLv0ktQOjYIT1O6e7efQ6ITXVkfLzBDg6P/QBIKXodWyTk2i9XUB2IkWvOkvxEa8umH9NFmfQFlqY5yxDJgnrcBblNc2kZNmw+02QdOIDBmGkTiCgj/2mfENsGb7c/Y0p/fKl5igsZCbH5bf0xKcLbzI1bKc+gvoIOTF0yT4R3dV4tXJDSbYlF+nrzI2G1CD/HGB8nocNgAe9OEQXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgazTQ+TfMOC9KhctR7bKf80rTZabzVXUlU5GV1VjGA=;
 b=yJZ/VIUyHuzprJJyIj9b0L7QIBFnGxHWFJvnSyo6aahaX/vh1kDcvonKzPeeWqX6Gy7Rn/Ouib13S7AB8YNIbdLAVsV5mpiP9btJvPHdROuXTNt2IzNZ1Q3+EuHltbDSDjZRkvj0ddlTyXzDWFtD5aEksY8Nir0JjrKTzc/wmTC0XCib/ex7wqbj9zW0aJ292ih2+S3AVHoo4C5pRcWnrOApGsZodVxq4uOdPRNFkORVLO4aYr7HQFPIncwdLSMgIxAw4QAM0aDbuHDyzPa5sdBbJQkr/S5DPOTzUkbcA63PwUD0U1sVDM8EqXeHGSbG/0UNMRl0FQobl1j7gYsxrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgazTQ+TfMOC9KhctR7bKf80rTZabzVXUlU5GV1VjGA=;
 b=pp/liVqg4DxOPa2L+efZX8nogs3EDRpmU+8/C4Bs/aOCYSGeVdaNQAUjJGPGPg52ldzn3Bf/T60gO5paYku4qD/N5SV/IDxHjfigtF81xe0Nlnl4oZzG9Ikln1OVlX8GXLjUGiazJmsj0WXTH8cRRS6gibE0HIzmF/TGixZ0x1FZKzOpsDOODplaiYa5L6G1a7AEgDU9Z3J5Z+wStqAHmKzVLxAZzaaT/7Pz+6ptPjirrNR44wCs5Hwfen5pZMwkF+QVy7ymKkQzoWsWRma0v6MiCnTuY9QtLtsfDrdHIvW8U5EUKe3IdFrakiUz2RX8sK3ngDS7C1M4mdRd1u8mGQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS1PR12MB999190.namprd12.prod.outlook.com
 (2603:10b6:8:495::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 14:21:30 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 14:21:30 +0000
Date: Fri, 6 Nov 2026 10:21:29 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>, linux-coco@lists.linux.dev,
	Jiri Pirko <jiri@resnulli.us>, Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 09/11] crypto/ccp: Defer SEV-TIO link setup until
 evidence acceptance
Message-ID: <20261106142129.GA770409@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-10-aneesh.kumar@kernel.org>
 <e8785bcb-45ed-492f-af66-deadfba6ac25@amd.com>
 <yq5ao6c2p0ek.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5ao6c2p0ek.fsf@kernel.org>
X-ClientProxiedBy: YT4PR01CA0046.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::14) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS1PR12MB999190:EE_
X-MS-Office365-Filtering-Correlation-Id: 397322df-9cb7-4332-c81b-08df3c11404b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|18002099003|22082099003|3023799007|10067099003|56012099006|5023799004|11063799006|4143699003|261026140227099003|261026121527099003|261102123227099003|261028144727099003|261021121427099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	5Eb6Xve/OwRhzcPZGIOMRERBXkFAWVXGSBbrRpt/yaQGMrATVUcthubDseIzSrP9RZN2CdJeKDXMv345qw74xKm8oYC3mitoCthn7wS67PtoeaOorTvr2p5U4xV+jkybvISOHZehqG+We+RXCGOgmji+3WzGBUEQTQiC5YMN86vBZZy49Up5x3oH5d2JxkeiW+EyCGaXuWcLFsq/d7PjhStRmRAsW/CE/bDtKZK4HK905CL2tPuw02biQtXNyUpr4yMiccRS1D60rPYKh9J8CkoS96cv59OCgrbJ+y90jvf75V/zg0CXHv+MLX1d9Uoi3z7kDJvrgAKd2PrL12hyzXPNXpofCLRKFU3CEz7fLjqQ2Q0q0CgUABGO4gr/WBRvNpo+Wx0qAnRhLnJ/8c7iG59egrcB++DHDwQsyVf3UYicdLkk/6m3/hV/78hgZOG/VhB374AF30i+46N0njpyw1hWiU3NEZHH7K/NwrTTOuQVvVlOVw4kWmlMrtfgpc82N6TVVA0aabKFPR+a8CMO0oWhKyLAencn0nLUgrbFbeWwLGwGUmn1aBUzzoHcKRpV7burClZFtprcEgwQjdE7/TIQg0K7zY9RSKpirpqfoGpxHJOvu0Qbom6+Vgd8Nq0k42HTB5Vo4NBaHOB+rFWrLfqi3PKjucK6173D0+D1fuQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(18002099003)(22082099003)(3023799007)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(261026140227099003)(261026121527099003)(261102123227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xCaVJx+0TP7RPFlStrnfDIeKXgFa6kH7/qJKJUqh/9FzdB85vH4k1AIfN6Zu?=
 =?us-ascii?Q?N7qv4mSR72sI+Rl5jNiQjUu2+Rt7pLZ4KMe06oLJE8fGlnGdX5m01l4soH/+?=
 =?us-ascii?Q?bV/9Bw2DcQMR86oGV6MO7tPUfzpA3A2q0xZKBoTj6Kj7GKhXqctHT+C3ywTY?=
 =?us-ascii?Q?MQO3NWHLrpJcpS7tMac6CP5Yx61WaYs+pgozAA7SBHKtjq56GaOxZcKorWNB?=
 =?us-ascii?Q?0FpQ0cMK9YnL+b6oEYZP7qlk1qIExhcQZ9/AFj/34Cp6GyOCqXa5LYWiyEs9?=
 =?us-ascii?Q?zuvdJbFsDZdhxy8H26jlSG/1r+T3rvuO6M+f5iPg2ZUQlXZeLgZ+TpcrOZn6?=
 =?us-ascii?Q?KSucJ6pgTuF4OrduNswYjj32O52V+Gb4s55UzE+PMCIxGM3GypoX6biv7uS4?=
 =?us-ascii?Q?iKiX0Sn4a1GJppIbivGSiD33+OF66NlH3TP9MzIGDpACgceY5XtLdxRpHzd4?=
 =?us-ascii?Q?ELpfGxVYLmzXYLoj2cNnEMJlSFbet/GtgD2WX8Ye7JWUiHzez/8kfww3Gyz3?=
 =?us-ascii?Q?v83QY66DC4ddfwGpDeFvcNlcJRf1gAMLwxHOQhVbXoUhLlALXtmPNkO8tP5e?=
 =?us-ascii?Q?mCoxu7/x5KHtVRXbopL/+w9f8yN1BVmX2y9SuVLLqCqBiliDTI88VgK00uRA?=
 =?us-ascii?Q?xuSGlpOHgvF4jo2Z0BDHiT7qFxmTx3mRTj5ZLNYnuQjQZCt6x5mGZDZHMCUl?=
 =?us-ascii?Q?KCT2YYZmrP0zE1M9qyJSftLZGX7y562lCbUWZM63yTzdDSwrb2k3ATjv5000?=
 =?us-ascii?Q?bEHJL+LFtcSkjK/SXIIQBiR7aI/wKIoyD8rFN5GksS4WoT0gtFHmzouGN2HK?=
 =?us-ascii?Q?Z7nLYedT3a2qs83HfpMqPMR0N3wBEgd6T02h4qjhR28Q35cn+8yWYSSyYNM+?=
 =?us-ascii?Q?f/4xNfrH/R2U9U22FJ/DU+1U5Mb94luNvPGv7Vidzl3xLqtnyMkcKcL4jdot?=
 =?us-ascii?Q?wGGyigCduIamhPQuCAEtyIx1Y+N2M9GwB82HJTUMRzWgL3PjbCISuvw6GVFC?=
 =?us-ascii?Q?E/DNu8kBG+TAYsuE5bNvh7C+7rIRCwLfMCGuj5Lc49POTZqZ2kTLcsYB9fBf?=
 =?us-ascii?Q?20buyW+zQV6EDh5gtjpkngTLxpmZz4N29DznfNGmD4rYKaxa6s/Qu8eAQw1b?=
 =?us-ascii?Q?P2sLDbYgbAnXeSuTrd3dE04so4R8X7GiE2DwlpQcuMe1ztj9RSKABNxMtzIw?=
 =?us-ascii?Q?RCrdxXq6ABpNkzVS5vawxzX6MutUcqVC1XFAM9RGDNFPs4V2uYj/1aClirX1?=
 =?us-ascii?Q?vwb8KCvdLbeSWrrsELc1/NyJCuGIMJ9rdQeOdhh4zYQsmVyHfDHUVgaDJVkJ?=
 =?us-ascii?Q?XiV8RWr/jigALukdQQUe7KXXDeNWb/4SXlwGbEN6VDuCmzm+/t7Zg9qERBUy?=
 =?us-ascii?Q?FrZS/mth2P6CO29fmIYoBWsMPuBNWrygAS6VfVy6F6UYpxHi3Hfgew9A1QSF?=
 =?us-ascii?Q?SEHzj2HFqd93uDh0Nu5IzgwV3HYrXIzASPm0K9sDN3AIV1WTM9qu90gwTTQ6?=
 =?us-ascii?Q?ClVr89nHM7YGfqhKVU8FBVcVcbsvN64+TyswngtQbWFfpxKdqoyfRNpjhPHs?=
 =?us-ascii?Q?6OIU0v6Y86yV704JiAVwpY94ivRK+MShCG5UIvtF7NFFTTzeLUHgBl36nbyJ?=
 =?us-ascii?Q?LxBpmkyuCKZOIjmI12guXBBEoZI2a+22l+inztRMxQPKOV5Bn8WB0GLR9Xf2?=
 =?us-ascii?Q?Nsc/lNZ5RH/2D5lboEzRtEadoPRTj1RpycTUFR2L29ZyZLD0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397322df-9cb7-4332-c81b-08df3c11404b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 14:21:30.1782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNYMJ3+i8PmdbUKyL2Joj466zmvczOD5dXhX0h13DnVI9mDkkxy0XRPsjmNztC0p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR12MB999190

On Fri, Nov 06, 2026 at 06:44:27PM +0530, Aneesh Kumar K.V wrote:
> >> +	/* Reserve TC0's stream ID without programming or enabling IDE. */
> >> +	memset(ids, 0xff, sizeof(ids));
> >> +	ids[0] = dev_data->ide[0]->stream_id;
> >> +	dev_data->cert_slot = 0;
> >> +	ret = sev_tio_dev_connect(dev_data, BIT(0), ids, dev_data->cert_slot);
> >> +	ret = dsm_collect_identity(dsm, ret);
> >
> > Cannot librspdm do that collection, directly via DOE? Ideally in the
> > generic code? There nothing special for the PSP to do and stopping
> > SEV-TIO's connect half way is weird.
> 
> This patch does not use rust-spdm and avoids introducing that
> dependency. It uses slot 0 to initiate the session, retrieve the
> certificate chain, and return it to the host. After host approval, it
> resumes the session and enables IDE. Only slot 0 is supported, and the
> host can reject the device identity before IDE is enabled.

I'm working toward and exact flow on what all the drivers should do,
including the roadmap to SPDM 1.3 multikey. That should answer these
questions. It wil look like close to this:

https://lore.kernel.org/r/20261103151643.GI274202@nvidia.com

AFAICT AMD's current stuff fits fine, and the PSP protocol will need
the same adjustment as everyone else for 1.3 multikey.

Jason
