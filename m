Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793374590;
	b=B3qFXS0SErVwzCWch5lrLbjpIegU1COWzf0lNU6UonKMM3n2KorL5U8qSLKNBzvb05Zh
	 +nQkXeb9uAAF/pVEhBowJJ96Dd/3h5ggRpmwvBJXW1+0wbs4Svyajh7xbpqMA0Q1ik2pu
	 GZ/KW/pJaM4uTBZt3ALPiPv/NB08vgzlfJ+Mw0r4PFFvp/M4XKvWDlsNjvdzsCFC1/wVe
	 dJvCcQRbFYlCtNx5ToBt7jXQnRWmDZvizjbjLsPYbRW7ImXk1KLMibV5Cdg7GE0BRif7V
	 3Zep2+LS6mz48VEtkgWlvxy6ohsh1sNhQfXs9jbntU1NMr/P2CGc0Pd7tyHRix761QQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793374590;
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
	bh=mFncTuF6V7lR3DkkwXF11FY12uW1P/zYwU00pAYjXRQ=;
	b=uQuf7s3TY8k+IjKPsZRMpqAkvN7hAhMxzKniEX+EOy16IEwf8qBZL1Jf/fkcnYuwXhyu
	 UDklZwkheTGCNGZ0nrCboQm/xytZ0y3Vwwaup4Bvqi7VOBhiNnmbdk/x9eEpCJxEfoGnm
	 5sNZj8p2jBsUE0OYGF14HKNOL827sr5v97xR/NuqKn9P5XarGUSJBYlw7uXWnVz37bLtg
	 q2x/aGdIIgoxvkJY9wKWvyqwXKmRV2Si2nkek5LEYeGBVe8wzukMNvoDB7Z9KKgbMTae+
	 D11SwacSFHeg64k1JaseW4hUnMWSSDxbMZ0bSEPLUPr9D85Xi4ENUu1zPNPjg4PJE0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EqtvMmXI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.48
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010048.outbound.protection.outlook.com [52.101.56.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DD1606A31C;
	Fri, 30 Oct 2026 15:36:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57DD1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EqtvMmXI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qqhlf2amSxw+Ntn9Q3r9LNCM9drxcfEEVfQez+UDF9EoKQctuawekV8gnks6HhSUgTR5jAM+cLzidSMIvuK9ajCSA9kbb63mZ4eK/V2haR2YlH0x3VYPhDs94KT6uwXaufLoQMDZ9DWdzrRbX5v1rkO6IlOheQ1vCrhPutynm/1Gd/cOb2QPr7woOjggGzaBXf+hXkZwbxgar/2VasSrYYNIsVuoh7bHeod8FQ/XXYk20gtdYrXw8A8IAIvCXrR8mDV4EA5tBP6TBY8acj75Zrscq2GpVHyBbfT58XcfUkeXWBCUFUvsWO7Q3FWjpQAYckTNYY/3DhQIoH63J9rAdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFncTuF6V7lR3DkkwXF11FY12uW1P/zYwU00pAYjXRQ=;
 b=EaYa9Xujnsd52h2WxglRpgZZ763HDvvlYJTW9mPOfpZJpMvHDRm3p9mIXh+RUmDC/g1SqfVg3ECnOqHBgkzVnhHxYCBEc2ErETUaXOMs2GeLVb4g21Mmkpwdwn8v5ZO3VWRdG9wemNK7nf/EtPu/UtGLGIPFPJLHUFQRkRq7pKgTUIiq3NwBhlzOED4UjN1MLTC6AXoZ+5NkG6E9upi2mbLTSWMrDrMsNrLoTjMuO+diOzjpQnBmxRAlpJ5TGCjEwQGZYenD8+MWil3ZXXKWSZ8lLmlllbOpT5AVbHiiUZdR3EAME+6SxTToJiPjK0At1Rbj586dJvDIE3yvpcgN0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFncTuF6V7lR3DkkwXF11FY12uW1P/zYwU00pAYjXRQ=;
 b=EqtvMmXI3UcAaK8bCP/hVgvMpbS1zSU5nqzXLhm5Ruzcma8TS3NpiN9oQU1URF6txsnPhCKAdta9thFwWp0ThoGPMqXDplYPve+g6xUWVJTpgaWCUu67vbtk9nxgJx23vO/6Bf2JltQ3qw3h81eU3yHNeu0fBrkuKjMaQzdq48a27wZW0GsDa6874/96IgTZ08KQ+FbpSGyqu5Rqfelx1BwbMI4uqGAbhM77fIHiFqxpZ5R7cIMXzOcGMUd16CZKmpNNamAHNa7egV4IXa+9X0fsIdL9ZFVLuIUf+BiYnBmJwcPHenuoF26eM+V2oO7Y6Mq/G+9yZhg2FV9fBaouXA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH0PR12MB8175.namprd12.prod.outlook.com
 (2603:10b6:510:291::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 15:36:18 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 15:36:13 +0000
Date: Fri, 30 Oct 2026 12:36:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
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
Subject: Re: [RFC PATCH v1 03/11] attestation: Enter secure operation when
 evidence is accepted
Message-ID: <20261030153612.GL3734323@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-4-aneesh.kumar@kernel.org>
 <auSfroz-gNb62nMG@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auSfroz-gNb62nMG@FV6GYCPJ69>
X-ClientProxiedBy: YT4PR01CA0211.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::14) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH0PR12MB8175:EE_
X-MS-Office365-Filtering-Correlation-Id: 075ed781-ee46-4933-526c-08df369b8756
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|18002099003|22082099003|10067099003|11063799006|4143699003|56012099006|261021121427099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	nMSd6+dmMBVQAblYi6skxf0rca5WNZKtnyW7YqsWde7JYtDccwlkIuttTSTHKekofvjCyU525oWHON7E89iKrGXFQoTLAnIRj7czd6iASbiY3ibaAf9KtyqlOsShMy3RYMrDdhXMF+wGsGFT5Wr0QfKIdhySzxXHPZDSEayG4oCa2AAsHVOAnCLSoghIPNySnToKDhyoWd7Xib7rp0v0i/j2WHmaSaIbrwbJBdBw4R+4qg2RLumZjCIum7Q/XkTEBUD1Q1fkP0Y2xKQoLDQQ2jnxExGtgPrf6LOyGcJa385p/rMzy3vsyEDI9Yce7Pj34mh6EmJBZfdDNrYBr+XPctAvYcesDzWk9Vg8c1vqbkMo/1qs90V1JAM6eDAbv1dqlpWVfwflTUf9G5seICcW+SxDiq+ssErNXSA+r+8ToTUHt/O/ag6ht3txqg7Jw2itrnGqSMPvIDlgrK6H7o6BkIWfVM8GEKtz5ZOvwebittbtpfIOHQ/l3o4zoMkm3HTdfRZ8bCjx1a13+uUqLvaRuo/aUKXoE1rE3LZQHZHkRtjp/KT9DI5ZvovJAnXuijq5ygd/lEHbZ7LU5XQZNaHIrnZlAZ3PS/88Pn+ma7gENBuFwwrPnKiDLHb8h4+IK23hUFPTZJkB7pI++vuZRxRmMbvK+KVHP7u+hWpbDg6Y9PY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nHI9M3DWACxw+SjAiIUxJvmFlj7T3WQB1Wow041S8mOf4u8lBgDiJvXQegyc?=
 =?us-ascii?Q?8/e9OZ8WcIfEjGqHiArWm4lKHvEhPC7sa4nLljo8401Gb4vXXnNmxUOl3rHr?=
 =?us-ascii?Q?VgKHjkMffrgVrSlgnA71sZGa630182CzYb5HSh8xASrpdoLa5q+vPUKYIYdq?=
 =?us-ascii?Q?1cAt4ruUWgp+lTQlr7a24+yUcChI96vTK5kLOMJOTvrU/KvK/1+GyLhqgKpg?=
 =?us-ascii?Q?WB0DEA2IcZwQPPFh+m+dcvs8dP2RGaJSqUmkaNe1O3I3eTb+TwXSO75dU+l2?=
 =?us-ascii?Q?WO70mg06FhjWiepD+RlX9F8x4xQ/YG1Lkr9zLUFlfAGjrNXnfWJ+JADluX7Z?=
 =?us-ascii?Q?5nUaDfE8i2EEQOGkgbS8E5lRrwADesICjly6HTS+07rEjFYmtkvhu7i3Ilwy?=
 =?us-ascii?Q?JIIUIrpMN/Pw6hC/wp3Pl5jTeicVlPY90HLCxbUvrg0NSHSsDcuiLPlsAoyl?=
 =?us-ascii?Q?VsR6XUa3E6Ugn4h75T6bn1/6vB1cwaaYMhQHv/SaimHiJRwqVmwvQupFe6zK?=
 =?us-ascii?Q?EQa1c0ikMPQe6ilqwMQyKLpBQ1xMZ2+crystvVd/R4gpOhh/bGdnrZ/LZcDH?=
 =?us-ascii?Q?d9zI5XIiapn8YTS17LGc5ZbOXhdvKRE25WU5nKurx8ou+crQkuYtzf87Qlki?=
 =?us-ascii?Q?vSL3L9Lcf+Qa/IwilNYZ46VXujzLbOKZVvpl244aCGtPxpWIOsOnh2YbR/dD?=
 =?us-ascii?Q?XqJnshGmc7oQxxevgOey6/pf4WUlATrRAAqMmBLzfevfVYnlA+btpHixMt15?=
 =?us-ascii?Q?flvTeFKu+Ptg7OdBggtQWIjoXyWRc46CsO+//Z3daYso6U1JMfb++ke0Jyuk?=
 =?us-ascii?Q?dCCeoIf9PxMObhFIqpFTRmIK9CqKasjQmebTQ4SFype/3E7RRugIkkKvpyQS?=
 =?us-ascii?Q?TC/+a+7bNyqETOvOvd6F05nj3/tSKOSPO//pK5P9ix1jqFldAxw29F5hGAm5?=
 =?us-ascii?Q?hJ3EQ0i7iC3zQ0BZi9yhuGNYcIsM525XwT2uI7mBoSd95DTl/7kPZh7DQPzU?=
 =?us-ascii?Q?dANTD6StBzlj0pwKFtEp5venxK8tp0hNao8Fc1rywEzbGz2+J0hB2qzNa589?=
 =?us-ascii?Q?XfmA88mr01wxSXGwhyRqlZGC/diGeh8vvq5jSxlJ1g2sior7qSjVEzXNwOd9?=
 =?us-ascii?Q?4hBJOaxzLso0/MY/oVUs1g8YLt/6I9dwbm/qJEmpob9XAVLL4X2uQgShDhDt?=
 =?us-ascii?Q?sF+Hdv2gq0eXuLnsFsnq02ZU4GGllfdw+USj2RVubUSqJWB/g/TimaMbDud1?=
 =?us-ascii?Q?S1fL5Q0pLc1Q4EOAuHUDXwuCu8+fIvzMqkeZu+RrLUFGWcTMD1h2+e30+Zzg?=
 =?us-ascii?Q?DULB1+Igw8iNIgSRhAv9ly9O3TmJ2cwvk+fVSE8eDCOHGLuRgnl7M38xR2Lm?=
 =?us-ascii?Q?x9vPT7+BAcl/bPkrVf99l50pBZcyTMwTPJKTEqXKM9tnK8P8rNcoYh4WRUjP?=
 =?us-ascii?Q?1CIGNf4Rm32U1mgqz0yTl2ezQygWqmTiLgqGWqtq97QB0DnKOx8SkzZ1IPdD?=
 =?us-ascii?Q?Cd/1vuEenDCAiob1wdiyhY2NAf9/aZurjG19k/EaWm+wghldtCdHebK6hxcE?=
 =?us-ascii?Q?GPgTSTwglsIGffGuadtS7ZBKtoa3epbQhDYab1/yy5OjxwDediW5FsqbOiok?=
 =?us-ascii?Q?2k6ByFBG7VpNOUY/RrHC5CGZnKZz/JQvOmakphrNXboADjirC2VuhAElIjSQ?=
 =?us-ascii?Q?wtdNjPBiY7HpQYzjd985H/l3xj04JZ2usp2t5qEPLPVrLtb+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075ed781-ee46-4933-526c-08df369b8756
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 15:36:12.9031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U2PP0poGBF/JmzoJqdxYp7fOHKYIr1SLMWZutJlgspTs4YgKy36IRjOAo//GUkRs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8175

On Fri, Oct 30, 2026 at 02:51:37PM +0100, Jiri Pirko wrote:
> Wed, Oct 28, 2026 at 04:26:10PM +0100, aneesh.kumar@kernel.org wrote:
> >Use EVIDENCE_ACCEPT to enter secure operation after userspace has
> >checked the evidence. Check the referenced device and evidence
> >generations before calling the driver, and record acceptance on success.
> >
> >Remove the separate DEVSEC_RUN command and callback.
> >
> >Keep DEVSEC_STATE_GET so userspace can read both evidence acceptance and
> >device state. Clearing acceptance does not undo the device state change.
> >For example, with the following PCI/TSM patches:
> 
> Note that the published wip_attestation_all_1 baseline still
> has DEVSEC_RUN. I am planning this merge into EVIDENCE_ACCEPT for
> my next revision, which is not pushed yet.

I think this is a good idea.

There are many use cases of SPDM, and the "ACCEPT" is a generic point
where we say the SPDM Session is not authenticated and Whatever
happens next should go forward.

This could be setting link IDE keys, or TDISP RUN, it could loading a
decryption secret into a drive, who knows.

But the thing that instantiated the SPDM session should get a hook
callback op when userspace signals accept..

Jason
