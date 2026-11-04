Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793799688;
	b=UAWcnsiEQmu/Qm4ByZ4y/Xlb72Ojz/YpcdJcyhR2fLHkznyneBJzfNXeqDNK+HUmWFsw
	 qhrJGLgIl6dUgFuDOZ/5ZwIeIoIos0rbfGq6elViH27bn8VHyki3qH7lZA1aAhmJLktzK
	 49C6pq1kZOaA512vjpur1RGpzm5fY/41k5+s2ZfbMZyJ9nsYn3ktt1tvmMf0riln4vmHh
	 SDLPT1+4V1BzcR4TeDmYIZKACxHPa++30sF+49Oj0g/0/0s9RrpOZr+L9k1CnWAjiILQd
	 KMw4KgFetKYwKjE/OP81Y9nsS7obDXQcPuUlyrTdEEuE96h8OjBG0kBMWqJUwB4Bu7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793799688;
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
	bh=SLe0B28dHw4lbmv74NjIKmV/SzGMcZCRBVKMQWI8NEA=;
	b=yE+73b/YTy4V/zI5tme6CKL77sIU0HouQcDpkI9uB4MvMrpagC8UNz0qLNnldDLuD5LL
	 E6OsSHMPzYwVAvMH7NW4X/N0MHWcu9m8wi+zsvcnAk9ZQOdMW0vq3GbAqqrQNY+UQ1Qbh
	 XZhizpaT9T0AbnxLFvM/yUX4syYFAKq8DfXgiA9x3fXYh/Yu49p8t9bt8s/tFhM0HTnHg
	 OKwgI5iudwNNDUX3ecQNeA2ZjvYtmeeqx286DPn6RVmPaub2zSsTmQjieSa/J2AIcIEXD
	 UM3Ki+3xX3o6/3iWA9VuUbtvvFxuiVPwSoMVTdgiEtuHUq78GwsJkexcrGdd2VxfuDw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uC1jygQz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.1
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424D2606A32D;
	Wed,  4 Nov 2026 13:41:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 424D2606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uC1jygQz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvlSGvQyvrSt8NVu4fA+UjnLDlWS/J8UK9l6WAQVukjd/G+8sv74qQFICPPzSij8M7UQyQJjCWd0878coXRGvfubOEQ6lGjuGOLhaz1Pc22QNmmRRyiKakHViqJwvvXJiuvyTzhfLDmI/bUW9hzoZFWL6coWNPlwBERUFuwsvrlCniDROmMr3HwSZYzgh57Yho2AEoqjKx7Ptu1x4p/qY7i3cq7nYsR1375G6g/hv04/LwhA2owA6E8c6zMwMzTxLRKTPokfHy+Jk5/o2KexOEcZznarLMuI1EmyiM0vX+Jn2upIA8AuPjfgV2wtXRYZPuh8H3KHZUR2fHaW9K0n2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLe0B28dHw4lbmv74NjIKmV/SzGMcZCRBVKMQWI8NEA=;
 b=cTg3TPn/C7tkl4+D5T2DuheE0n1XjA04quQCvfPDZ9MJOHixaBNfNcTYXhGU+9EfFuHJoeB/XC+s0xaWdHerM++oJjZ1T72wB/IMrUM48ovelF+rkYoFyxIGsV+7kZrBA3qZTSU0m7L3wSaJzMbSiyqAT86lyvOQMDrSx5Bx0GHZnXzmc7NWi/QOiZNYkLiJiJTW12ll7HDJ55xeFJhVky6N4rS77a/FvlnVBqDWDIIfMc2PLDyJsQcA0hNh7cAK+BlWArvVUFRKFJpHp1IbjzYq5gc4U2wx2hEZ0rXPue2O05WtlwwA+OZa929FowA09N0UYESq+smHzCfsTkwWcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLe0B28dHw4lbmv74NjIKmV/SzGMcZCRBVKMQWI8NEA=;
 b=uC1jygQzFbLO84ZS0J6438mYo+9zRcuUUESUQiXigoRP6w33CEDhzBmz07u67X+kwerRJm5zKOWbTQB1yV8KAdVRKzF0fa+yboxBjMnt0vaKu/Ga755tawHXRckbe2I8I2JedDgrvKA6FgFj2+X5HVjBWtYxCiIlHhmeIycXB6VVeIz4KCwr+wYv9StMZoOLCCJ2cUvP2tgT7g/RnFs56AMsnBtlq8rSa/O38sxt1K+Im7VfHKIZZr68dqJA8gfCoJwORPJA2FktQA5yNJB1Gc1wuzwCDFPhnvPsS286LcwL5OOveKfQKhQGPkSYGkV/B6B0Jo5hlVy0Y1Y1MktwXg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS5PPFFF21E27DC.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::66b) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Wed, 4 Nov 2026
 13:41:21 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.009; Wed, 4 Nov 2026
 13:41:20 +0000
Date: Wed, 4 Nov 2026 09:41:19 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261104134119.GR274202@nvidia.com>
References: <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
 <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT1PR01CA0142.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::21) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS5PPFFF21E27DC:EE_
X-MS-Office365-Filtering-Correlation-Id: dedf7418-d44a-492b-658e-08df3a794f24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|3023799007|6133799003|10067099003|22082099003|18002099003|56012099006|11063799006|4143699003|261022075727099003|261022105027099003|261028144727099003|261102123227099003|261026140227099003|261026121527099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	R/2KdQ8oqgTJDGdE150cWoXYn4ss+fasPsUmQECiokvJmnWVIuh4OF/THakjaspxD21FRaUU+Rf0BnyW8/9TNjRrf7fU9FMzi533QHlGf77SdYJP3gR6uYBt8A9zCzFlvi9fItVgP+X3S1CHn4Zxn93QLcZ7tCPvv57Lw273w5sPqrWkaPI4SkKzr0/4M/Z49KObZe/HAuH9x8xllDAhXoTkyhkzwDML1J8BZWXDTbQWIng9bslk4jK2oMajb/yZk/H6iDApaLhxP4HJBJTrTSStTEmUXUm2O5Tl5tN+xYKSQkia1LawhezeWTV9f9DbbgJny/z7h70qTqA4BMvU1TOyGqpo8GK9ASk9en/OMc8SHktAcHWSyTB+G+rEs8YZrjwsrmxYIvxGBXX/i9aVbNuGPZYgdNVBoNg+1UGsAvAVH+hTdEAaFUm3BUH/xBfF8ZkNAv6GEOak49k0X+4HdWACHO9h95pQc+/jUv87Bo2lNxjhiMnR+vg7FIim5Cxat1JTuT7nlPUn5mNWAG4d8MpYn7oiDfcsnGLnW4hpLc8sjj6EyYP5sR9A2UmyH+V3FhqjbTJ2zguSbBpZ2WuPSdnE2kHPwHDhRU4dJTiC+v0VnyK5mZlvgabN4v7HWnhkZF0JltjxrdlsVJoscw7ddvZvd04qzIKy6tr/ODBCA4I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(3023799007)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(261022075727099003)(261022105027099003)(261028144727099003)(261102123227099003)(261026140227099003)(261026121527099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wj9sym6YN6EB/IXNHChJTqU/F2Dlur4NPqFflx5QfWxVxuq6gfrAqVH53Ru9?=
 =?us-ascii?Q?yDGZtwFx52pzBecLM4Mj4yBaG5vham2xKLQXqcfBPzPS9ZqbXgGU7M0zK7ww?=
 =?us-ascii?Q?ko2ssdqXhs/DfLXIRjPQSiJvgQNvcPIvCdrj+BU+stcb8yYq5jDmVy/XPArN?=
 =?us-ascii?Q?c+Sqpdqib0AyMDD4XwyO1VDhrbwnXcxDHxgBjQ/2uyui/NtC8C3Ghcrfv1rh?=
 =?us-ascii?Q?xwyuOe9+1oNosQANa/nLMeERfAViHGUT26XK/ZPAsrEO4SAhRzI+YVTd/bG4?=
 =?us-ascii?Q?AL4NL/IYkxro1Jee9zxodB2qiV26v1/kQuJAg7SgdrWbr4Wq3RNgY6vU7nk1?=
 =?us-ascii?Q?b5wUGJ1UGwKURksO6PjRPptW4YSxpcGsijPM82GmG0hT2VwHYqqM3v6lVZ87?=
 =?us-ascii?Q?dpxJn+nUPSO/T5BlzhE9TZqyOrcgbH9VZ9eQh8aErReIu+hT9/cuylYYC/oz?=
 =?us-ascii?Q?grXnol4mhbANEJNAsTdRo9iXNXtmXtXLiEvmY5nlI45tUt5gCZkx3UeJ7Wsc?=
 =?us-ascii?Q?xrKGbRValvTfeko3k8Q0eTo2A1c7JrnmWqBQNWsb+PWoqY7QgWKOrav8V6c8?=
 =?us-ascii?Q?SxLl3aRw8sAiIT+5PkOWngsjK+sTbXir7hsiy53uPL5nYhJxtGiRgWwYm7mv?=
 =?us-ascii?Q?KvLLDKzMQaRz/KTE162HwW7lkWp5iTDyypBR1fd9iZvUPs24ifE1RGmqinJJ?=
 =?us-ascii?Q?m54WtM5ur/UboPdCx9EwyDY459l44K8igoLK9IG3eAJ6QT3r5U5UStRa3MtS?=
 =?us-ascii?Q?m91rvCq8J6N00tWeGPWgwJo4OjlRqLLqzMkSVM/f/mNRIYBS9ulr0bo2LfBA?=
 =?us-ascii?Q?KCIo/tYIjRi9EBOou6p29pFZ+me3bKEc3tUoTgYJfgYBgyWgjTgK3MUNIVAh?=
 =?us-ascii?Q?Ek40ciMqnslMtV/S6oNTxtC1vRPtaq7+3KM/DtHx60cneHfmytPBR6AXIeqL?=
 =?us-ascii?Q?LFj3k1qBOoyHTWX2AD+niJCy5OTn0KFnzwB+2mo81c/TF8YUk0p7bo1/Kl0m?=
 =?us-ascii?Q?rpIP1kw7GunLZ/7oKeTkvC7FPNEMMGnOPD3AJmnRuTd0rmR6hAlULJ53i1SV?=
 =?us-ascii?Q?FqwlwDiwYkCA/woRzO+25ALSS0xzwrf7vbMcxFXM/DBy6BdI4iO50v5q8yaj?=
 =?us-ascii?Q?y7iqrKVN35NAC+7s3pn5IRzrYSr0yMyAovK54y8/7Y7CyZ/UI0yGA+SD5V2D?=
 =?us-ascii?Q?HEUSdzoCGRh1BbgaL5vat0Mk3paFAueKc9aQL78Ca5vx0tJLJqRblU1a26AM?=
 =?us-ascii?Q?CCr/iut0+k4BXE17mxetSNOT1llrsvZamvOb/cEQh5CZpvWQTZ6QlAmjk1qZ?=
 =?us-ascii?Q?LUnO/VumDycLec2fjcmoSUXtz2WavQehVO+YMg9zFrxGRxMRQYEo2Ozy2pFG?=
 =?us-ascii?Q?QNTV5qbf227w0DA2MuzYjP39v3BRCKpne6dbZQauLVskJ1qCIOTI3XDRCGps?=
 =?us-ascii?Q?9Sj+gPSzOTAZpNhjTCbalO/cwVz5jbLwFCZxJFf1qSyc92TZUqR0z2R3JLz9?=
 =?us-ascii?Q?j8rFyneuLGj6pTWviLKfBAZxHg8jDprFFUyfgs432Bc6IxZTibdA6FOhGw0H?=
 =?us-ascii?Q?fy5LywSvs+n9Iky4fL5tT7/9b6+eQpA8OIIsqBq4VdxXS5DxvRgOE8jmcBf/?=
 =?us-ascii?Q?y8GLzhwCBRBFqnSpUpiXC7BQHV1/8/XnO1ziHHVI2XMlOa9xgMsz3I70nVP0?=
 =?us-ascii?Q?X3ewc5zIW9fff5j55jl57LjNfnW49r1scx4E831yMiE/jV14?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedf7418-d44a-492b-658e-08df3a794f24
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 13:41:20.4130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tehzvWRXXqKudhuGXsuUKDEpej9Kl8a+h47k3un8r9QSlE7HCkA7aDg+8EUnhKvO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFFF21E27DC

On Wed, Nov 04, 2026 at 09:49:25AM +0000, Reshetova, Elena wrote:
> > > We will need some multi-step sequence from the uABI perspective:
> > >
> > > 1) CTLV command START CONNECT:
> > >     TSM does:
> > >      GET_VERSION / VERSION                          (VCA: Version)
> > >      GET_CAPABILITIES / CAPABILITIES                (VCA: Capabilities)
> > >      NEGOTIATE_ALGORITHMS / ALGORITHMS              (VCA: Algorithms)
> > >      GET_DIGESTS / DIGESTS
> > >
> 
> Why do you need a break here? Why not merge 1 and 2? 

Break gives the option for the OS to ask the TSM to transfer the
certificates it actually wants to speed up session startup. Eg if the
OS already has all the certificates cached then it doesn't need to
fetch any. Or if it only wants to use slot 0 then it only needs to
fetch slot 0.

> > > 2) CTLV commands:
> > >     query certificates. TSM will issue on demand:
> > >      GET_CERTIFICATE / CERTIFICATE                  (every slot in the slot mask, all chunks)
> > >     query VCA items

With the paus we can drive the certificate fetch from userspace, on
demand.

I view it as optional. The TSM's implementation choice is invisible to
userspace, but I'd like to gently encourage that we think about
session startup performance :)

> > > Then there are five implementations of this:
> > >  a) Today w/ 1.2 and current TDX/RMM/SEV specs:
> > >       #1 is a NOP
> > >       #2 is EOPNOTSUPP
> > >       #3 does the full flow from GET_VERSION -> FINISH
> > >          no GET_DIGESTS
> > >       #4 returns only the slot S certificate that was signed
> > >          during the transcript
> 
> Again, agree given the current limitations. 
> 
> > 
> > I see Elena's proposal [*] for current TDX:
> > 
> >   #1 Does the full flow from GET_VERSION -> FINISH
> >      no GET_DIGESTS
> >   #2 Returns only the slot S certificate that was signed during the
> >      transcript, this is my understanding, not specified by Elena.
> >   #3 If user selects slot0, pass; other slots, fail. Actually user can
> >      see only slot0.
> >   #4 Same as #2
> > 
> > Seems same to me, any preference? or do I understand correctly?

I think it is similar, but the main drawback is that userspace can no
longer detect that it is running option a. From userspace it looks
like option b with the device having only a single slot since this
makes #2 return certificates instead of EOPNOTSUPP.

Further, we completely loose the ability for userspace to specify a
slot at all since #3 would be the only function accepting a slot
number, but the session is already open.

Thus I think it is better to stick with the a above where all flows
consistently issue KEY_EXCHANGE in step #3. IMHO that consistency is
easier to reason about across all the options.

From a definitional perspective I would be very happy if the uAPI
specified precisely what part of the SPDM sequence is performed at
each step.

Again, if userspace detects it is in option a and really wants to do
slot selection it can run through iterations of step #3 to enumerate
the slots. I don't see we need the kernel to be involved in this, and
that is a strong reason why option a should be discoverable.

> > >   b) Improved 1.2 TSM:
> > >       #1 TSM can execute GET_DIGESTS and pause after
> > >       #2 Ideal TSM allows the OS to request each GET_CERTIFICATES command.
> > >          Less ideal is TSM pushes all GET_CERTIFICATES then pauses.
> 
> Why is it less ideal ? 

Only performance. It means every SPDM setup is forced to transfer
every certificate bundle even if we don't care or already have
it. That's all.

> > >       #3 TSM issues CHALLENGE and verifiers the signature.
> > >
> > >   c) 1.3 Multi-key flow:
> > >       #1/#2 is the same as b
> > >
> > >       #3 The function of CHALLENGE is absorbed in the updated
> > >          KEY_EXCHANGE which covers GET_DIGESTS when in multikey mode
> > > 	 No CHALLENGE issued
> > >
> > >   d) RustSPDM flow:
> > >       #1 becomes a RustSPDM session and includes CHALLENGE
> > >       #3 starts a new session
> > >       We have to solve the issue with ALGORITHMS mismatch somehow.
> > >       There is no verifiable binding of certificates visible to the
> > >       verifier
> 
> But why we need the RustSPDM flow now given that we agree we 
> should handle everything in single SPDM TSM session?

Right, I'm showing it for completness, I don't think we should
implement this. Maybe if someone strenuously objects to implement the
FW changes for mulit-slot/multi-key in their TSM they would do this.

My feeling is for now we should sketch out option a/b/c in detail,
everyone should confirm they can implement option a with current TSM
specs. Everyone should go back to their arch teams and reflect if they
agree to option c in future as some discoverable extension in their
FW.

Agree?

Is there a PDF for TDX's SPDM flow someplace? I will try to draft a
more complete document

Jason
