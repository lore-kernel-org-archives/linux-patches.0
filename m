Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795096833;
	b=n0aRiUF68WoXagEqcT2qYrQToh8Fnk8q/xU90g7NNoqEvN+nXgj5enlb3xC5snzo/lwN
	 ZBqRfOAFEonsBgoVxB/aisiB3Ldqt70pfpTl+wCaIk3k4ynWVgWGrJORQKFCcGwoWQYLl
	 6vWyAiBtxuvftmq7+kkPwalrH9zP8P1eAJUp/roQVAPm6oFB/rm4zwHG+aN2LYuj3gY0V
	 PhqQGX+gm3hjasJ4cvADRsWTZmW/j3QmtzZcWaP3inCRcm1TltCumLho3AKTerCndRCdW
	 hW2H/zJT1gA/z0ud6pLguByUi1Y7OHX7EFMUFsM/Ket7aSk1cJweZKEI5LdSbz/FRuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795096833;
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
	bh=vZav/CJpVBlHxvTP4h/ER0BcxhV21qZiiV0qRwWPsAI=;
	b=ZhSiMy9XLpkbylTm098TqlprbfWTDuRkeUEz0OaUEdZJzymafe9nu6rPsAJOupn3MA+0
	 kSks/B8kG0BJV/N58pcz50tksSH8bZ6XA3KRwiKgiWti3B6+c3MZgwYjYLik6nnHKQ/7o
	 pDPFDfcSQg8EEVbWRqhd32XPh921UKn1rp6Qs8WAswpPmBkU3Q5rKKUdWM3kPflhnDyNL
	 ahxoEMnZp+lUoX4cMz6S6gGPSkk1YBlNCqewvyeC8EU7b7XsDPqBKSV+Te2ANWnDQaJWu
	 M2H/GYt+/gSbQ6P1+YiOLtC3H9HAA1YBJpxutTCgIgoEFfKHacwpwTFHZLc9wA3fSsg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QzzqAaNq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.53
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010053.outbound.protection.outlook.com [52.101.193.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D63606A324;
	Thu, 19 Nov 2026 14:00:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00D63606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QzzqAaNq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hG8GfbD9c1YsvoTFSHXk77ZQNgbPpC9iduY/GpBrOU1+80OpQTxpQpV3fNR1iJFUcMQSB2baxwtUgEQ3bDMcIJf11uulBQXrRzLyuxPh9a1KHh3stLe/9rgGDKqVCLyfHHkIvmcZ/RZrwXkZ2EuYfh9y41dqXrZoXOoRDT+ViwDuh64XI7p+UInNLwiZLit3YbaP7ziHq9QSFE2lyT69ZX6qQhdmS8Ec0FbWuxRcqrIlXG7XERLrE5ELFs21udianIKyKixLDiQ9bGZw85164XMEtkFY/eB09mhDdLNYnTW0scnC8cxmH5am8lzo59exrtkn3IQWBIXg0Dxj/LkmPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZav/CJpVBlHxvTP4h/ER0BcxhV21qZiiV0qRwWPsAI=;
 b=USKchZTHOGPDJpEnsor+f7w+icIsMYG8zoSiWjtcn1BJZzQCFK1bezWehY8LVRBYkBd57nJ324yNzmF53xCRh2V3IZxmFe8fV9MgS/BRYBozyN0RLIvgHhHngnfCmN60Igwy9vmsi1dSzd0pekk3MtJj2SbORpIEwKo61K7indHlFM8D8a/0g+Wk4x0mK+wmBUV2FT23aJxcEWBtlDBOeYMdH5l2gL1qss82+JQlC8qDcrAO+S7kQsdnn1eXZlGkV0lpU3/xH7VPoTU2EX83WM+kY84eIfI0Hr6X6zxKr0/5xtxIgMcXXWetF5B2a3utdPZwlMN5sRdCYRusht+KfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZav/CJpVBlHxvTP4h/ER0BcxhV21qZiiV0qRwWPsAI=;
 b=QzzqAaNqlfQw7ODCyjW8sGw+QcUXfhC9TWJCAk2rCPIoABGnl7ILTh06k3GpZVFusCaHo99sFqAjUH7ujX+iNbGWDJkMGZOEAW/tfkyq5ak19empKQ5d5RLytfcVZJxl7k5qjX1B8HPVr4m6Mk41B2Oe+w/uNGEIbR9oilge/ppffooghT4PqSDSIhdsEMbinBMQGI/r/cYCXkslS06x8jshSxm60z2PuFSk7SjAI8WnBVW6DxknEWR/s05yk+i7rJ6iREb3hKrqvZFPRCjxeP1NS7gYb5YvdW4BghlNxJ8NHz74KYNz3OYoHJqcE1wNP2ASnJ0/89HrdM8k7DV3QQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by BN5PR12MB9537.namprd12.prod.outlook.com
 (2603:10b6:408:2a9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 19 Nov
 2026 14:00:19 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 14:00:19 +0000
Date: Thu, 19 Nov 2026 10:00:17 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261119140017.GS2245175@nvidia.com>
References: <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261116143319.GA2245175@nvidia.com>
 <DS4PPFA84FA90FC9031C253514720694AFBE77B2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261117142027.GI2245175@nvidia.com>
 <06d99ff3-3fae-47df-a27e-f2b45d8d3852@amd.com>
 <20261118131636.GN2245175@nvidia.com>
 <d8a32937-059f-41ee-9e11-2036002149d7@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8a32937-059f-41ee-9e11-2036002149d7@amd.com>
X-ClientProxiedBy: CH3P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::12) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|BN5PR12MB9537:EE_
X-MS-Office365-Filtering-Correlation-Id: cfed466b-339a-4321-b154-08df46457209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|7416014|10067099003|11063799006|261021121427099003|4143699003|56012099006|261026121527099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DBgpp4XNy2ADe6qACU//Q+cTc8bn4DQsj9MxS7nEpzOou6+js1lxWc5BYjKKZx8joyzQG0i0914N/VacelkxFx37odlUCSyftfTHWJbYQOIyMKsX0HgY5gvy3Z4EzrTJyXPjmW8X01SfWQ0I+ZIwSAeCNadfFMOghFOY7xnC00HSSK1uKdYLgHMNc74VcuqaPZyUWmV8baXeOi8yfAzfyf+I9FPkyp2+suva1BVndmXrF3r4N8sPz7CE0ylX99bPDw3q03fKWLzTQ5qX8LLyobh5Yzec55k6gO1e71UNNGUWbFmJUZ3gNPQwiQs61dfEgkp3PjTkTtug7zB2XaaRu1L4Z4nEXpM/BUt5aCcYaa8tQqX/Kep6sdRR7bx0UcU5mr2pFrS3yqrUlVx8NgTCTHPHlKj3tKtI1WXgDCGooDExjf8QlfETHqz9JrwAwQGZvAb6oFuoFOMjt3JRotXVQCDLRXazeDUXf2vHagjVc0VH+Z4YbeBvG9/uxf0u3015cLhapMSNMeg25qdEcHXz6VriJ6dIzuWJ30zlEN/h7CdTW/kO3KwnK6s5KMw502whtIEqcwPqdXopF9HVGykxjwv46fJAFn/SUQQzDHpC3Vpp7MMBAiWTRFklsFvBy7X/OT2EbQNxcfKnOHtkYNb/UME5bE2/RemiBCbhZD+iRQ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(7416014)(10067099003)(11063799006)(261021121427099003)(4143699003)(56012099006)(261026121527099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?um0/RetWwB8RnzPEjkPIPILBjKx/RmWz0mdJxP6azSM/CveOHoSIQ073Rm78?=
 =?us-ascii?Q?FO50oA6SxAs80+8O/leCIhOlOIExRNzUbN3ZaePO4LJn6lYQlAR+fWy3tRAt?=
 =?us-ascii?Q?9sjRcRUSaEsD3tV3L6L7O3hhB5gbVGXolsi9myo7jFNfUObuCCacO9ACjIiF?=
 =?us-ascii?Q?EiKjbt2xAM2ndq0mlHS3vtgY9v199T+VfRXzLgc3XxYlNZiFauEC6s0oYBbf?=
 =?us-ascii?Q?nWSrNx+MGdn7iuBZMQwuKZvI6xSNgfRx7CtiksItozrYDIkegCt/yPCEBq2r?=
 =?us-ascii?Q?01Jkl1w/4qOcNURJG9HVCM0NfxMGdr/VyqF2im88QGpuWjGam0dMONWI9rP2?=
 =?us-ascii?Q?/LoIQMWNiR+6/fn4g0UEY3CvoSrjU1frSWuoD/ZdjExdix0PyBhcEu0HeSxl?=
 =?us-ascii?Q?k7QAzmBvcRiL1mzxMcirXgx8iNryCme9X849yULe2RQP2dL7rXi8S7f1t6bG?=
 =?us-ascii?Q?SILjhfDndc9RP9i/xfTTmzPGkeqH5ghQ0rQZbUA9q67owSHSSG866mL9uq7L?=
 =?us-ascii?Q?fnb7v+4jp7DsltsF2btSRGIoE46xtfxMHQNeUgiPG1oBVkXuSnycy3JIar04?=
 =?us-ascii?Q?0PyvEqhG5vN7Y9R+SN7rsiJrQ3dSReCqwii2Kli9jhbCJbhFi+oNVJgKOj4N?=
 =?us-ascii?Q?m+OxVMF8OY+AOkHE1iRRoW6nPRink2FV0xXUKfkYY6vwldSCPz9H/h7OAT9v?=
 =?us-ascii?Q?l+AdSL/Kpks9eMUHnP5tX10pRY9f2HM8KXYhdu4eN9to+JqaA+aQpaQeYQ8p?=
 =?us-ascii?Q?SulY34sCxkWz81qh05S6Dtqoo3PuU3p2WqDJ2ozCKCA+Cx97BREj+r1RTmuK?=
 =?us-ascii?Q?76Qypynswr3MgSntCPQrrgGvZj3QRljaHwmfQ/dPFf7c2UP/HYhdxoe2aitL?=
 =?us-ascii?Q?Pho2nkKueUVVDFmkZMgqfcgV9688gju+oV5YI1GxzbvNI83pimjfX92ZCIb5?=
 =?us-ascii?Q?NnuhT0cd7ueRjIifDsdFjd9pSHFv5hTtH2Dp3w2jWitHi3vaTdNpX4SCr8Ba?=
 =?us-ascii?Q?sfqaXHsXbGm6pI+6JawBKSsKlCYsHBBoFbuYAgRZ2YomIYrHBvLA2ki4b5Kr?=
 =?us-ascii?Q?E4/dAHk6KKN4TCF1rNIIFVNhOL8wjdUWqdJQvaVtvTk4A+mR8p1uqZkMtxt7?=
 =?us-ascii?Q?iSQCX2vxB7N3xSH+2pQ9uWx0wOJB6wXY1a6fWhIpnX088pv2yWagUIiXfJup?=
 =?us-ascii?Q?k2/np4jPHixZ2/L63FQr6pojVHz+tZaDdczUtNEOqB7mnujQxTt7kSZah3ge?=
 =?us-ascii?Q?JR2B1oJ1VQEUdN1JGcFRA4tzjKlhJ4FIf58xkDdC9rcafB3qCDTH+x+XxSoL?=
 =?us-ascii?Q?av5tFj+pdm3EJx8tyo0uh3tCq3awLylM10UD5CHYm2Yn3DYCRoeha3xVpGFE?=
 =?us-ascii?Q?mKhwQxo1+qM0GDKOjv+1JfYg8+oalPd5NsKxQC3lD8X0TvihJzeYhQDpXfMU?=
 =?us-ascii?Q?kPzq/jS6EaWSRCgw80ffZaBDwGup3oiEIOUuus3AKrRI3YJy8D6hnUV9lsp5?=
 =?us-ascii?Q?eb4mZKdw99txhbtypH2lD1LWZnK6kcbOeP3nOy7RTkDMMGxtnSbMoowGwBqL?=
 =?us-ascii?Q?jFyet4I6+BR4u7g1bQLJKoAhvGuIT7kGWo5AeHLRf1Uhep5VQJ/3A1rZtouc?=
 =?us-ascii?Q?Sl8Q9IoloqM4nPpYa0n6eHpXATSwXf842edrUgEp+CD0MfaEXrDJ+3XgFQkN?=
 =?us-ascii?Q?KcTCQu7Vk2mp3EpPnMwhR/iLM8k1nX2kDF966XZBjomyE3bC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfed466b-339a-4321-b154-08df46457209
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 14:00:19.1296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8H6wosCMdTKRZiioWkiX6D5mAt5pTSN13L3DxN+DBC0JdRXix5Fzc6DQcQ80eQG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9537

On Thu, Nov 19, 2026 at 01:19:05PM +1100, Alexey Kardashevskiy wrote:
> On 19/11/26 00:16, Jason Gunthorpe wrote:
> > On Wed, Nov 18, 2026 at 10:12:17PM +1100, Alexey Kardashevskiy wrote:
> > > > > Btw, does any other arch provide #3 today? I am not able to see this in ARM
> > > > > spec at least.
> > > > 
> > > > It is coming, currently ARM doesn't even allow the host to see the
> > > > measurements *at all* which is a really big miss on their part.
> > > > 
> > > > AMD is probably broken the same way as TDX is right now from what I
> > > > can tell.
> > > 
> > > The PSP always takes nonce in DEV_MEASUREMENTS and updates the
> > > digest. Nonce comes from the initiator, the updated digest is
> > > reported back to the guest via encrypted VM<->PSP GuestRequest
> > > mechanism.
> > 
> > Okay, so that means it is broken too. You will have to disable host
> > evidence collection once a VM starts using the device.
> 
> Why? Because of concurrent DEV_MEASUREMENTS from the host and the guest, or something else?

Yes, host measurement collection cannot impact a running guest in any
way. If your system can't guarentee that then it must be blocked.

Jason
