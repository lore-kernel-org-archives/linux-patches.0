Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793993548;
	b=VT1p2sk1VmjlDyTeSi5DqGXTx1vWXLgIyVO2Q5EHenD6iAyDTS5vj+BTcOzkiQAemC+o
	 Qns/EMbfKD7+RyamxV3lOd3E6croc6x7/PA3PV9LBGW8qPvQbEbsYY3Is9nuDs82KrKKX
	 Kkef3v0Hv+7GC3yS5kho5oNUirVlaeucv3ZB8y731i8afm5U3FH6fqU9XufuDBqQPtPPv
	 i/jhc58ptSMdiewPCVhWVcj4ZUTRYHUj2h0n2oNJYtLxYCehs4wbm4zK9I6/394KpnQLl
	 NKnvbtPTRaD+iSovX4IgVO92O42DQSxAcwCGjoZZLca5tfo8GLeKodQOaHzfTxuyDUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793993548;
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
	bh=bpb9mmUmwM3YeFma6xZQumd1NtdzztmTPhkQyYvjRz0=;
	b=cJIwJk8YjqLPZV0sC565BaSdsmRF8LVueCCh5/Uh+L0bIgvkdjxsYj0s0wD8TsMt5XJc
	 gPGonmI7scV+Lii6rN8E6TMbF3rDr6P1lm2UHIxe1wdFUiqhk614bQWVLhe0zCVq+KDON
	 Tf9M9maNs1f4Ku+aTrqRRMA2Y8M0zO98I30UmKf94DxojztIfG04jR5D9iySh4NMNgTv2
	 7rye1Sd8a99uSmB6FCWlbAKG/gOycsumIXLYz5Ngud/Y8uOUkgrCPYRFOPzXpxMamSR++
	 0qzUGAELy6iHoWRLQiFdiavdC/UnfNthc2LeU2f7H2iD/iQL1ODVIhVbDEuhOaB8gQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YAgZuiem;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.7
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011007.outbound.protection.outlook.com [52.101.52.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529C8606A333;
	Fri,  6 Nov 2026 19:32:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 529C8606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YAgZuiem
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XXlIlxBnccjqOtHGsRoyL7prnmIDAw9FppgvUAdV5SmEHKDKsYRwyXCuxTOd20jJE+dY93SiuEDyUJEV7yEBI40MEITTdJF0vITWt5mnUjJCMo3NE2fVhoAxLxzchZLR7scLR43wn6w82dKrl7skQA2WO5bREwnu+RdkRWzkjKmD6QHdzFda12nGLmCdb5C95VsbcttUqmIFmcnJWBP9c1lBWlE/3cwoIzen77+HcoFBfuj2PMbtFRltDKQPQi5nsY9Pr+T7R1E/HurlSLxgGYtwr9wbv9LAfMrY60QD+S9e5vtWLQWAkx/qaHgRp2bsbwrZuuIru1sfBF4aQdDCfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpb9mmUmwM3YeFma6xZQumd1NtdzztmTPhkQyYvjRz0=;
 b=JNrIjN2vQppFH+NBXBN1Nb2xtA55oCn8CS/HQVvRGKmEBwyCWKz24n67seyp4147NyikLwX+6i6YLUm8iCSsyPQMtNzSF+uBU6qFYGukWm9wReoET5Pn/itn39Qmzb154eJc7DADm/QsVumRonKmsIyGzr1lFstl/b9GK3IR4KzVBi2O6twe8E0uFw1HNlmzr588tZfSVjqPNS6x6lza3z4soc1JjwfVnbRl2qfc157dPcZfR4XtdeCSh9EfQdncshd8Giss4kNszWMLouc85Co20WsDMwhYElXYs2fXluXEMNycHCR+sJgL2bTvEd4kPNOj/Zl+6vJ/v5QH0FEPGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpb9mmUmwM3YeFma6xZQumd1NtdzztmTPhkQyYvjRz0=;
 b=YAgZuiemrO+6NqEPW9lSN/djmyUXpZULRCfJQIXc3wDlLqQ3DNxglhI3qkuX48FtSv9/ws5n0ZhoF07ynARfZqQ04Bwv+gaNlmOaeA82NwL5bE3VXJve2sa9GlU7iMN4QhpLGKbcMy9lc6TTkuDyFy20GfqcTNw9Au+XX7CTNshFBaruko9E/X6vAnGmOjyii2YQ1DtqyqnYnTsT7lr7kn77f7U9l4QqEdl8tSrjVB4lo05qzMuATum29hzG5ujuO3AGZiOBFv7YOHBqssBcldOe4FQQ1MzBbGJcnlHRKuX0MWzXZHRmJtdFp65KPl/9W/hTCGGvJb3sE7wX/xoQ8A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY5PR12MB6574.namprd12.prod.outlook.com
 (2603:10b6:930:42::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 19:30:20 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 19:30:19 +0000
Date: Fri, 6 Nov 2026 15:30:18 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
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
Message-ID: <20261106193018.GK770409@nvidia.com>
References: <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
X-ClientProxiedBy: YT4PR01CA0455.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::25) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY5PR12MB6574:EE_
X-MS-Office365-Filtering-Correlation-Id: d1867a1b-4567-4e26-5ec6-08df3c3c64a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|6133799003|22082099003|10067099003|18002099003|3023799007|56012099006|261028144727099003|4143699003|11063799006|261026140227099003|261102123227099003|261022105027099003|261022075727099003|261021135927099003|261026121527099003|261021121427099003|261009223027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	RdoQCTrhBvtPH/1cR7wn0H/Cl/y8bbUSKGL+Sb4MnNGAtFY8Hm9OgQGdgKsk/yPWYlr4QSojtKKW8ow1U+llhTDzGMRjxI8byUxZ2bh5lerRdpHdW68FKMngOnyEwdDVwJekF461sMiBMpDktUJ20WWGCaAbp63UJRISX5BcMCQn6DZu1rY3880oN+sh+N6zRfksyW/FFHMgedUjtELAe2JBFDK/MoTCWReavhCMpUOC0e4o8OR/y6dl5M1Mvm/p8aXJHbhHWw4Y7k1uuEQVsPWrqNxbFjHI4iPusqMV8A6a5VjS9ouaCGjNFeLsCqT0hfUKJJ8foPdIQyZz5mX30T42y9rDGnk+wuz8BZl/9b/7qmrz4utGMZUGTlP00hgAkLn2A2aBdOG+DEPpzxnoeZ6uemAP+yWgB+O1nXrx74tQhvMvPROH/HggoezDSjCvGG0hSekjuwVNTcax1K3WcBgbDi4zETgcw2CCYhTpO2HjtkPkO5fm4daycA7cGbDkt73AwPTWzMeyxnz5zlEKe9gy0ozMQX8iOBfzhvybLwVVCVc0vpVPs1D6hqIyMBHmZzy/Qt8A7//0ci1o6OvBWNPkA9UVqlS1iA0pZ6saIBiZ4DC+Ju9TLt2N/YE8AGFobOoXnSwb4nagWwdzvHW43jRAdyRyQNiM+G0bOaKbFjY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(6133799003)(22082099003)(10067099003)(18002099003)(3023799007)(56012099006)(261028144727099003)(4143699003)(11063799006)(261026140227099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021135927099003)(261026121527099003)(261021121427099003)(261009223027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wJQYAIeUpxqwUeQBfvBhYhOrwEQyd9Lql8wU3mmuqqcdBS8lEEg/onGvF74T?=
 =?us-ascii?Q?T4spLmTxEyt5aENfFmadNJWRzWGy9QNP0LT4kLLnPaabozd2aiy6oYIq2dPG?=
 =?us-ascii?Q?pRYeDMqlWAWUM6N2ZwovA7+1UlY01oWWXOLreQ6NvU5RcRDtfJ0g3+ryNT3L?=
 =?us-ascii?Q?4ns1w8OzZpCUAOA9q6ng4xIV4KNySndFBowh4fUg68lljQ4/wV/C3/mNEmcz?=
 =?us-ascii?Q?9jOi+LdSuseUfRzLZyF+tnLzgDMPe2DkEgzckAe572fFF5YTdpv0sdIStuIt?=
 =?us-ascii?Q?8D38eWBpucDeg7UDOsMpqsniPfk1Qo1pakIeTsngxtpQnF+58u4WmC/tt5S1?=
 =?us-ascii?Q?qYA9K+vIYeHckWb8NCU8yUgZBInJPAX9JZIiowt9+NtlV1h9YLsZSIXrgQcd?=
 =?us-ascii?Q?F5cM+1TaltfUQz2mUMOHkcZXNWAVySiT3oXKQcI9v7CkLgSfW7c79ck3KIT+?=
 =?us-ascii?Q?+SsqG4+7IkBgG007dX98gsM/VtyPBhFZCUbFCF+JgRrUWocp4EzADbMYiZ9b?=
 =?us-ascii?Q?RZ+F6JtTJP9u4yCB/iu+FCzUrz3VRMEP7B/bX9r8YJpc19rq/lkkeSaikD9w?=
 =?us-ascii?Q?mg+aRIS9PE0ks+GeTivVbIeMDaeOkH9Ehu/0b14jT/PkSe51b7z7dMlQX40+?=
 =?us-ascii?Q?VInjkMRs3mRxP569cfL/KEEJDCHTqAngJfJf3x5hzJDpagfWhYE3sUGsG6Ms?=
 =?us-ascii?Q?nCecHZwopQYrCPTpfFs7kIT+3228v9MhTaUUg/lmLtDRgItadUo7OMwzWl4K?=
 =?us-ascii?Q?DMPwSIPH+sVludR/2/uXLjRjF+Jsf3RQE2mEzRzL3hPAYTOSo1yheltNMiVX?=
 =?us-ascii?Q?dooQWAv+9eKab10qhXjX9PfN5nAsfvGdSGHNNSpwI9hfwj7fUdU+uNlQGe+c?=
 =?us-ascii?Q?m52pwzdo8dCduhV44SYkz0m8QNtBh2v7Xxda1WfkIe5zkdiIXRj6fXHZvz+y?=
 =?us-ascii?Q?OREueqjwaAmoaAOFEmaw2lz8haqUEuKCwY6CztGKbAywKQiMR3ho2C6SxIj2?=
 =?us-ascii?Q?YTyY+s8orehSGHIUb96K/mQpSNQaYy9V000v35yGr0wRm5+INZ3n1NOvS47N?=
 =?us-ascii?Q?pQVhcjafOYaS9EM/8Azee4ZU2nQ+3/8Ag7r6DFcpQ9ll+qPRjwIBGw8t8+vd?=
 =?us-ascii?Q?Mc138F59ca2wZcnMayNwrbF8IER1pchTxIsMH/ST9ZMniVYPc1oG3vQf3/wx?=
 =?us-ascii?Q?Q7Q1LIKGYeBI0krPJyjgwpMzS7r1b55UHX786eRADpWT85jWVS9TBGlE6chK?=
 =?us-ascii?Q?Jyy5mreZXBXuq0JBBdruP4VBGkoBpuBReJY+7gCwGtfXv7N6sUV5SCC36gME?=
 =?us-ascii?Q?+EWc9qF2IdBEgLBkJAeh1u6N8XCAa0hzsKVoSCq+29YKPLKydydusczRRITB?=
 =?us-ascii?Q?fIkxJUtBWMv/EhBPckcC1yQ7HMhlaOaEKUm1Odzk6TWfXuOnaT2pOeni6DJA?=
 =?us-ascii?Q?syqRVTXQsvUMP830tQjAi9T2f1MaiPCamyGfh9kBHo/Nwf/5J2M3j1LFxb5G?=
 =?us-ascii?Q?Oehc7iGGHob38T52J+8dO6DFLNwW+zTdDbNGwHWIP+iV2psoYM+mOTLh8EKo?=
 =?us-ascii?Q?S0CnGWBey3fIJaoFIrRqEPGghsEo1obN5GV6eNcVmhvI8UcP3byDn4bSg7ee?=
 =?us-ascii?Q?xzeWQNhM63sz4gU+NWUkNrUyQcL/sApsyGJBmBehh7bP6y8UEVSeBVjmdUfZ?=
 =?us-ascii?Q?4m3qvdVsl12MIxWqCwc8E2SDh8YK4i+TJl7vZ6l1kkturbqi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1867a1b-4567-4e26-5ec6-08df3c3c64a9
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 19:30:19.5905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yNG2XgYfJPjmPJtQKseRSwTJKq9tzlekmXU0vl9BPvRm5CcoRR+JD/oX8ibL/1R7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6574

On Fri, Nov 06, 2026 at 08:53:39AM -0700, Dave Jiang wrote:
> 
> 
> On 11/4/26 9:54 AM, Dave Jiang wrote:
> > 
> > 
> > On 11/4/26 6:41 AM, Jason Gunthorpe wrote:
> > <--snip-->
> > 
> >> Is there a PDF for TDX's SPDM flow someplace? I will try to draft a
> >> more complete document
> > 
> > TDX connect architecture spec
> > https://cdrdv2-public.intel.com/862706/Intel%20TDX%20Connect%20EAS%20354629%20004.pdf
> > 2.7.5 Figure 2.6
> > 
> > TDX connect TEE-IO device guide
> > https://cdrdv2-public.intel.com/861654/whitepaper-tee-io-device-guide-v0-7-0.pdf
> > Appendix B.1.1 Table B-1
> 
> I generated a diagram that hopefully better reflects Option A with TDX better than the current public documentations:
> 
> Option (a) on TDX, with the current TDX Connect ABI: slot 0 only, no TDX
> change. Numbers in the left margin point to the notes below.
> 
>   ---->   call                 <- - -   return
>   <---->  SPDM request and response in clear text, relayed by the host
>   <====>  the same, inside the SPDM session

It looks OK, thanks.

I have a few thoughts

1) I would very much like it if the core SPDM code in the kernel
   can snoop the DOE messages from the TSM. If we do this then the
   kernel can directly capture the full transcript:

> (4)  |                    |                       | GET_VERSION            |
>      |                    |                       |<---------------------->|
>      |                    |                       | GET_CAPABILITIES       |
>      |                    |                       |<---------------------->|
>      |                    |                       | NEGOTIATE_ALGORITHMS   |
>      |                    |                       |<---------------------->|
>      |                    |                       | GET_CERTIFICATE slot 0 |
>      |                    |                       |<---------------------->|
> (5)  |                    |                       | KEY_EXCHANGE slot 0    |

With perfect consistency on all vendors.

Further, it will also be able to capture the GET_CERTIFICATE during
the preamble so again we get greater consistency for everyone.

I'm very interested in this because it frees the uABI from any
variation in choices the TSM may have made. I have the full perfect
transcript in the kernel and I will ALWAYS present the same uABI to
userspace regardless what the TSM offers.

Like a whole bunch of TSM FW API just to do this:

> === Step 4: query certificates, query final transcript items ===============
>      |                    |                       |                        |
>      | query certificates |                       |                        |
>      |------------------->|                       |                        |
>      |                    |                       |                        |
>      | slot 0's chain     |                       |                        |
>      |<- - - - - - - - - -|                       |                        |
>      |                    |                       |                        |
>      | query transcript   |                       |                        |
>      |------------------->|                       |                        |
>      |                    |                       |                        |
> (6)  | device info        |                       |                        |
>      |<- - - - - - - - - -|                       |                        |
>      |                    |                       |                        |

Seems pointless to me, and could cause uABI variations I don't like.

What do you think? Am I off my rocker? At least AI says it looks OK
(always optimistic!). Undoing the chunking is annoying.

This is close to what ARM did with CCA, it seems very smart, but they
seem to have provided some help to the OS to locate the bytes in the
messages, but I assume with some work (and we have Rust SPDM) Linux
can decode them autonomously?

This would really slim down the TSM drivers since core code would
build up all the SPDM data and the drivers just need to do the
communicate loop and little else.

2) I do not like the idea to refetch certificates:

>      | nonce              |                       |                        |
>      |------------------->|                       |                        |
>      |                    |                       |                        |
> (7)  |                    | TDH.SPDM.MNG(nonce)   |                        |
>      |                    |---------------------->|                        |
>      |                    |                       |                        |
>      |                    |                       | GET_CERTIFICATE        |
>      |                    |                       |<======================>|
>      |                    |                       | GET_MEASUREMENTS       |
>      |                    |                       |<======================>|
>      |                    |                       |                        |
>      |                    | new device info       |                        |
>      |                    |<- - - - - - - - - - - |                        |
>      |                    |                       |                        |
>      | one-shot result    |                       |                        |
>      |<- - - - - - - - - -|                       |                        |

That's just asking for trouble. Our general security statement is the
kernel & TSM validates a signature over the certificates to verify
their authenticity in the HW. Re-fetching defeats the whole point of
this if the responder can supply something that differs from
GET_DIGESTS. If it can't differ then it was a waste of time since we
already have it.

Further it wrecks the point of the transcript and the 1.3 multikey
signed GET_DIGESTS.

If you *really* want to do certificate refresh it has to be a
dedicated operation, it has to be supported by the TSM, and it has to
get back another SIGNED GET_DIGESTS. All that would ideally have to be
dumped into the transcript again.

I feel it is alot of work and not valuable.

I generally feel a 2nd measurement is not a valuable activity in the
first place. There is one meaningful security measurement. At boot,
before DMA is allowed. It must be logged into a measurement register
and then after you turn on DMA the device can replace every byte of
software on the system. (hello ATS). Only the logged measurement can be
relied on for security, any post-DMA measurement can be fradulent.

It is OK for auditing, but not for security, so why would you even
look at the certificate chain for audit? For auditing you should check
that the PUBKEY is stable.

I think any device that can loose its private key while an SPDM
session is open (ie with live update or something) is fundamentally
broken. If it wants to do this it has to break the SPDM.

3) Obviously TDX and everyone else will need a 1.3 multi-key upgrade
   I think they all look the same. I would like us to settle on this
   API here and then we can describe what a perfect TSM would look
   like and people can go write their specs for it.

> Notes:
> (1) Creates the attestation endpoint only; no TSM call.
> (2) TDH.SPDM.CONNECT has no KEY_EXCHANGE slot input.
>     CERTIFICATE_SLOT_MASK, the only slot field in SPDM_CONFIG_INFO_T, is
>     the "Device certificate request slot mask" [ABI 3.3.2.2]: it picks
>     which chains to read, not the slot. So userspace can't enumerate
>     slots by repeating step 3.

Boo

> (3) TDH.SPDM.CREATE runs first. The kernel sets CERTIFICATE_SLOT_MASK to
>     0x01, so the TSM reads only slot 0's chain. It could also read slots
>     1-7 inside the session [GUIDE B.1.1, Table B-1], but no signature
>     would cover them: KEY_EXCHANGE hashes only the chain of the slot it
>     names [SPDM 10.18.1]. So (a) doesn't report them.

? this is confusing. KEY_EXCHANGE slot=0 includes the hash of the
certificate chain in slot 0. If the TSM doesn't even read that slot
during the premable it is impossible to validate the KEY_EXCHANGE.

What prupose is there for this configurable "the kernel sets
CERTIFICATE_SLOT_MASK to 0x01" ? If the kernel sets for slot 1 then
KEY_EXCHANGE must fail?

> (4) The host relays each message over DOE [ABI 3.3.3, 4.2.20]. No
>     GET_DIGESTS and no CHALLENGE [ARCH 2.7.5, Figure 2.6]. The guide's
>     session setup example also reads slot 0's chain before KEY_EXCHANGE
>     [GUIDE B.1.1, Table B-1].

Yes, you have to because it is necessary to do this:

> (5) The TSM verifies the KEY_EXCHANGE_RSP signature [SPDM para 630]. The
>     host trusts that check, so it keeps no KEY_EXCHANGE messages.

Yes, but if we do #1 above I would keep it anyhow and optionally give
it to the verifier. I agree it is fairly pointless, but it is really
cheap to do if you have #1 and simply capturing the *entire* signed
transcript is forward looking from an ABI design perspective.

It might even be useful if we want to use
GET_DIGEST/CHALLENGE/KEY_EXCHANGE as the sequence to support
multi-slot.

If people start adding more messages in later spec revs it simply
flows through with no ABI change as additional transcript meassages.

> (7) DEV_INFO_RECOLLECTION puts the caller's nonce in GET_MEASUREMENTS
>     [ABI 3.3.2.3], and the TSM reads the chains again
>     [GUIDE B.1.5, Table B-5]. The device signs the new measurement log,
>     nonce included [SPDM 10.12.3]. That signature is what protects the
>     new measurements. The verifier must check it with the leaf key of
>     slot 0, the slot KEY_EXCHANGE used, and must find its nonce in the
>     log to know the result is fresh. The kernel hands the result over
>     once and doesn't store it.

Yes, but in 1.2 there is only one private key so the slot doesn't
matter. There is no reason to re-read the chains. Kernel would throw
that information away, it already has a signed copy that it got at the
start.

Jason
