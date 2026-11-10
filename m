Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794315132;
	b=vU7fgrLtNO9HskQA5PxcutDXquYOWewNUOyp/FPk15YnBSC/G+zlvub0hZ7rHocrchaV
	 tDy1fjsyZB+T3KpHc64Rytqd/VPLZTfc2t015cQmpR/Ip+l7jxyboaobzgWxSt0d3wiSj
	 z5lwALU8jzhSgCgyQJXjnz92Oec+vOG8WN1Z/QSI4rsnpBJjbsUwGgnBJLkE86UtEaxLN
	 e81a03xOOKrHgBL4QctkuFygzdZgG5qcivPHJ/606qr8YmNbTaR+Sg7nPvU/xqd0Vs77L
	 eY3EyfHPZ8QlBMQX/TOEdbkAksFsD0pFo4KSCe4FznFE/mqmn38TZRcA8wNsoOJFl+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794315132;
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
	bh=9I0xeswwBdqrwibxKz/d10ZlPqT7/D97azmSSIROrv4=;
	b=PCPMzfoezVLIfrx7jiaAGsz8gqRqu58tBJssCeQ+IEFsGWteu3IIyXZuLosOQxfsndRr
	 IG6fI6UXtiq/KAc5nbYjG0ZM1b/anAXy9lHedkENw9OUXyXQhgiPxNCKbsPt+S+odYjBJ
	 5JZ1x27HVjvEU9XO2GSHjU3yA7cDYI1vyB1Pzq5qd69vPWFXc4Fg+ONVZhPp3kwcwYrpY
	 3a7+VnLnWLr0BevjYGRrolfwFnckp9eGf3oypNrGsrfdum/h8WeiPOphdiRdfILA3SOqN
	 ZE6NfZGzOvGiIHEZppOjR6tD2p42EUTq5LwzVlRycK5yyLwSp5CFZLbmXNg4Yi/rnyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CPhbaE8H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.23
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012023.outbound.protection.outlook.com [52.101.53.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F30606A325;
	Tue, 10 Nov 2026 12:52:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75F30606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CPhbaE8H
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WRr0rumEKLcmQOgghCNWpOQOEWwCU96lM8N4ldOR7gjOc1FXTF//or5TR412Kp87+hWCREzIstYUVxK0I8Pi9MxqFtcA+4Em72wfZJgqqBsdz3/dUj0VQqEe7JqC51nIhFI7n6WYNV7PXDkBvZmOvat0M1zGZiLpWhuzfiLRICWuHDQkj4Fhe1wM2y2lP5oIJ/yOYsjYHgzUA9V638QzWuxYQTNAJFvIzUL2fj7X8knnOimXSDYupWtO2hlQMn+tOL88lwVCDC+iN90sS8qwYA03glj3/AD23QiLuXhZvxtaHJJqFiEVqkmq1jbDjqIypmuZNqJtRX1CN0Djl39enw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9I0xeswwBdqrwibxKz/d10ZlPqT7/D97azmSSIROrv4=;
 b=hoRO6TSAfjwqBtVyffF4L6IMQSdiLyQHUItQ3e9M3gR8rChkDecs8SbfXc+6yvhO/pUwVkWvy5aaQnv3XB7A+3LzYqoFkDrG9NyjuClQRVHewewLGPr7MH9N9078am2mKmTMFcw0te0rfqC1exTpx8qkMQUbqWtFmkxdaBa8DBHLX0+6IIbaXL2EbggXP5DmpbupTYyDPK1f2AewMp8Qj7kmzvsdkNmDLmC82A0++6tesFVkCHjPD7W89MkobWAhzVjKZXglrccAfYs9vqQgJ41ylRFGAicnP1n7vmAIqb3qzzkxVLPmOtO1xt43ylN3YuY4Aqo3B0+MVgcqdKkAHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9I0xeswwBdqrwibxKz/d10ZlPqT7/D97azmSSIROrv4=;
 b=CPhbaE8H7hZr3fcBsw5BpCdvfgMB+iSF5C3qvwTQHUTOnF5X5ySrMz6EstKH6HHMOpUlLUrmlAu9LFcCk6ETjuFtYYypJUNTW0m4XaLOZv7JeFGDODcg5c0Ynd2wBKyBLEa4yBVZobY8Kw4wVyZDbt+LTK2w4ygw0fxFm+pw1KY1TE0DLWubMjsE3sFhgzlv5GaVoVTQpTd6Zj1y1Se4vF/KzDku2VQOkp0Gf67XPADjPw9YJbmS5V+cWkNTTnYjmtd3xuQVirb3rIHMYNYUcFXF6IpS7JoKGDgb2fwvV+4DYq/WoxEhWyC/rM4OuU8F5xFO0/GHr0w2LbmWZD1TWg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS7PR12MB8251.namprd12.prod.outlook.com
 (2603:10b6:8:e3::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 12:52:04 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 12:52:04 +0000
Date: Tue, 10 Nov 2026 08:52:02 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20261110125202.GD738765@nvidia.com>
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <9cdaa99e-4a1a-4fa4-8fe7-73b9bf48ecd9@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cdaa99e-4a1a-4fa4-8fe7-73b9bf48ecd9@amd.com>
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS7PR12MB8251:EE_
X-MS-Office365-Filtering-Correlation-Id: 04602657-f328-406f-391b-08df3f296b96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|4143699003|5023799004|11063799006|56012099006|22082099003|18002099003|10067099003|261102123227099003|261022105027099003|261022075727099003|261021135927099003|261021121427099003|261022115727099003|261028144727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	7c1wVjkGiWxZxkSr7pydOh1dCPMpjwaslhAdX7MDotEPmgJbgmSptVl8W6/le1XfIQedPtVLygso4snrOU8zryHYx7zYCvE4wi0VE4Dl5FmWrUpRO4QLgjTjW+Vj2algg09TBRr43yFup8VZsyJFchFoYzRY5LlXz3VPXu63F9ZeB1argvabP5caU3j9sqpDomWM3UHd1CIqGvzMz0Wod+HHQNiu9zomO6OaMFw0fWTnKrXy1yen1ngLX5Y6gstKZsQ5/xdTfJpv91ToYReRCOzceqRdnAFFShkeguOuu8wdAN4kR4D8rJSfdSmYTdHZzdN8UkPofg0m3ja3pltAQgZDOCYOASQeDXvXG0/Jxpl5XeDYWkHMR2TyXxulxbXuvCRvRBpmbxVb7ar0dh/sIfRRv6XXUwK65sLAnU0/NJ9nOsOaZkXErPxPrvOZMqe9NRJux83HG2UEf+PUe5aavdD3/pHaPWoiTUQEiMuy6iM6ns3ywxJFfb00fpBzxNGmzNqEiBSXbuBXzdqK6k7kcQoOFjp5T9n1Z70Bc5oObFpeMaOFgNybS+smIA4CfXL//xqV8Xv09qiYCQsZGz4Jq+/xhFXlWUG0Hs2Ul8Ppf8tzXlV1xEc0MUKUbgIuF5cuJTL2iF/CH88DMDYxLtjL4hjDLjBTO+4VJ1CGBQDO5FE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(4143699003)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021135927099003)(261021121427099003)(261022115727099003)(261028144727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BCDESZnOCvkas8jPyuKTJUFERpsHyFDTeVMCCOFqwqSE5wZiu8BC9lsEFpaJ?=
 =?us-ascii?Q?oJS5sEVkzOm1kwvxHEOvUaafKzYc+tCs6kG5/xImWqrjt8J4nSrejWXbSx4o?=
 =?us-ascii?Q?LWC0Ea3FzrdxICpHLLpe1Vk9LrBFeFY5+ZEHTs1m6eDqmJB9xy6vhFlEThtr?=
 =?us-ascii?Q?WsofMyNWDfRtuSIwFnCmXlV1DEWrxLJcxTuucTYJMfBvbu52+W5hDiEsi8Yq?=
 =?us-ascii?Q?vjf81cw9+MPpIFLaGbWVWzSbwkOrREJSttN1O7DFpIBscNsnh3mHFLre00XA?=
 =?us-ascii?Q?UjdSqV9Wbz9XAOjYZ81JTWv64o05Jdk4edO/cci4WReFCPSL28Rw9cVyondS?=
 =?us-ascii?Q?T18PazIcCraJnrykH2VyS5PxM+sKevY8fAd2Ef5SJ6HJWDVlIR7ArS37Wazm?=
 =?us-ascii?Q?bWct2w4JyCk59XO5NGOySDm52lVd4OOCfOxdVJVDQDeppnFkHlBjScNtOkrI?=
 =?us-ascii?Q?NZPACuzuBCmptQRosj9zeHA9Cp+PSnTZMSru81CRd0nVlJ6zwle0zlXI9pXA?=
 =?us-ascii?Q?NSrM2km82YyxydDEobg3JcHJ2ooH3ULDaUpgFwPF5qJyZUPVjqNPq7TILnKA?=
 =?us-ascii?Q?hXAGFGwdUvQRA8yTQS+KhvsVnsC41PFCXNL/6Zoc1sA5SX1JL68OOiQ6155I?=
 =?us-ascii?Q?juLLEbtJkM2yllWwkskiZHNF9UDLH6CLbDSF+YJNLxTdKvOO4790MxZj7QZU?=
 =?us-ascii?Q?OPo6wMfHYxDvCWwg40GLdyaRl7oh5PhfzSfoEg+aJXeLyJiw4X6sqpyEE+G0?=
 =?us-ascii?Q?nuTZL+GIKSdXGtxN/PnU46UZBvvDxYA6VKfcXhUndMNyRuuDyWU/SwV1BWEH?=
 =?us-ascii?Q?paZ6Dlt0DfjMPvfzx6K/60yCkjZQyJsvtIIbVaiCCxC6+MDfXLAzJMwkKALC?=
 =?us-ascii?Q?uaKOzNeaOJrcme9aRG3Frqv8235pUhQBqIZzBhmYR097Iku+7xiu5I/VW8rn?=
 =?us-ascii?Q?OFqOwj7T9ASlFWWseVauGlT/z3Bdyf3h7ggyIXwm+nefJm7QxZf36nby+dBE?=
 =?us-ascii?Q?vsS9NWFTlEvI6DjDMKRoCuOWr7D3OY8s2pmkmnX1ya4/ob0kTcWv0Lzba6QK?=
 =?us-ascii?Q?LJHgeljmjXjioBQtcko+Ms4W3p7jCrqlybSjYnRCS9WXNkkUzIQ896GRmjjE?=
 =?us-ascii?Q?mt2G2w4FzG+Xhkm1CDNHL79Cp9kzyL/Uoaw+Zqp1sbDTb/bq9XX+J980v6wC?=
 =?us-ascii?Q?GCfb8XjyWopn8dOdh4Hr9SGQrLypmzuFE7+VZQRje4CdH2b4DHLTRulIttGC?=
 =?us-ascii?Q?lJttoksg/C3rw72KV5x5v8gxsK0ZE3vsRuyCsYuhwBOvXT5rNcxIBQ2Iovkt?=
 =?us-ascii?Q?3RrvwNE5gKDF2oDMGt7+Vgk/HDfL0LUDICbO35g5UDqQwAgfqBrUAGf6tLQH?=
 =?us-ascii?Q?hEzqR5LABY9URPila0jMZgNg27lgdeSp1UUTjZ0b/i3vzBd3UlBdO/JjwIXI?=
 =?us-ascii?Q?cAHz6uhhF8JfkjvJUdUWvnxhysAs5A/PE5CM++VvLIerpjNlKSjkyKU8e+Y1?=
 =?us-ascii?Q?z2RyQvjFamTBESQ+MFNpWZhw9fwg/UshlvR6zmPjXA4n45NWoDBUg0c0vRAZ?=
 =?us-ascii?Q?0bF26lmMoPHdJAznX/61e0UYKeFzjJ8RYAzK46W4R4mAOFeJVvXSezOdaNRf?=
 =?us-ascii?Q?HnpZqe5J0VDy2XJS1YzmPTKccWE/Qg3grGlo0gVoaZIx7pFWTrwaExFRo9PU?=
 =?us-ascii?Q?JOHhlOKPwc7Wmdpe+mDfar0BaoOPK4v4x4oEoGFh/249KmVX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04602657-f328-406f-391b-08df3f296b96
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 12:52:04.2046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhdDIXcxsnNz9jSy0WtQ8w+HF7MI/mTJ2d930kCMaxPKM/fokt0gzYbUlRZcmHZn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8251

On Tue, Nov 10, 2026 at 04:32:34PM +1100, Alexey Kardashevskiy wrote:
> > My AI predicts 1000-2000 lines of code very careful spec derived code
> > just to remove this padding. Such a big spec mistake.
> 
> Out of curiosity - why that many? There is only a handful of SPDM
> messages and secure SPDM has the size in the header.

It sounds like there are alot of options. Since nothing is sized in
the message you have to parse the negotiated algorithms and spec
version to figure out how big each crypto field is and manually sum
everything up.

IDK I thought it was alot too, but it is just an estimate.

> > 1) I think this removes alot of code from the TSM drivers. All this
> >     stuff they have to go back and get the data after the fact, or the
> >     thing that is almost like this in RMM, goes away. The TSM drivers
> >     are very slim, just run their communicate loops.
> 
> It is already like this pretty much, is not it? Well, on AMD.

Not quite, AMD doesn't have any way to return the session transcript
to userspace, and it hides VCA under it's get measurements thing. It
only looks simple because these issues haven't been addressed.

In terms of presenting a consistent uAPI for SPDM AMD is the furthest
away from the rest and probably the best reason to do this design
since it would bring it into alignment.

> > 2) Clear uniform path to 1.3, stop after GET_DIGESTS, let userspace
> >     inspect the certificates, continue with the slot. Again drivers can
> >     be super simple, just need to pause at the right point in the
> >     sequence.
> 
> 
> The AMD PSP calls SPDM_DIGESTS first, then SPDM_CERTIFICATE (just
> like the PCIe spec depicts). May be stop at SPDM_KEY_EXCHANGE_RSP?

That's wasteful too, GET_DIGESTS before KEY_EXCHANGE isn't signed so
it can't really be used for anything. This is also after the OS has
told PSP what the slot is, so it can't even help do slot selection.
 
> > 3) The data collected and presented to userspace is perfectly uniform
> >     governed only by the SPDM specification. There is a clear path to
> >     adopt newer versions in the kernel with in-kernel SPDM that
> >     instantly with nearly no-code works with all the TSM drivers.
> > 4) This is about half of in-kernel SPDM, the receive buffer
> >     reassembly, certificate chain reassembly, x509, padding stripping.
> >     Each a complicated topic on its own. We always imagined having
> >     in-kernel SPDM, so I view this as effectively free code - contigent
> >     on organizing the in-kernel SPDM implementation in a properly
> >     modular way.
> > 5) Without AI this looks actually fairly scary. I can see why people
> >     wanted to avoid it with different schemes to have the TSM do some
> >     of the work. Yet we planned to do it anyhow for in-kernel SPDM so..
> > 6) With AI this is probably a weeks work I suppose to really expertly
> >     polish and make excellent tests.
> > 7) There is clear overlap with Alistair's work, I don't have a sense
> >     right now how close some of the parts in that series are to fitting
> >     this shape.
> 
> You want the above just to prevent IDE keys from being programmed
> into the device before accepting the device in the host os, or there
> is more to it?

I want a consistent uAPI that is 100% the same for all four
implementations. I do not want ARM to show the VCA before measurements
in a transcript and AMD to hide the VCA in an AMD specific measurement
blob - for example.

I want a uAPI where the user cannot tell the difference between the
four backends. When they operate the same PCIe device they all give
exactly the same uAPI experiance.

Jason
