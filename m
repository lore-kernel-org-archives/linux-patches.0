Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795440442;
	b=e3KW6ULjeEprj7/uP/SR5IQiH2RA487Us5PQYG52iG3wq+CaZ4w965zhlTdVMeUCpqpO
	 tpN5IlRV1ktm0OAS+HcikFxuKycdFKknmTgFG6Qdg43VDHtVdEB+2q33DqGGOXg3g/Vna
	 kYqVHrNzwoYeuyEEd+vD9qMEylyLqCSPIIQqpjlpTToKO6kTbAXtZsNVF8ekqpqnvIl3P
	 12vrg54FXqDOY1qNEnOREZ/BQ0UaaSMRfQYryd8CgWQbouGi/KIp7BgxU8jm8knlQBtSQ
	 o5tOa0qdSFxq/g17TaSOqA3/5rykrdEd6RHpnSQ5Mc1zUP9NHlrN2w4eQOqFhkkw7DQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795440442;
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
	bh=EBieDEUl8juRP+Re5kRW6HCW2ekpyinYTn7WAHXkVPU=;
	b=Qn0YxW8m/g8o9jJJaVCkqe4KMkQuXtwxM8gW/Xz2Y+WLylFY+DCWS7zOaDmYPpK55xc3
	 7daCg9PE3jK/ZQXIN0i5+5WLShPwk4/bIV1+llOSm3KKNV1ozhbu/8UPZIJpn6NFw77Fb
	 X4V94k9UJrL/1Rw7utZs5acF+rFvJ7hKVTVfdvFW+9cw20+2tpRGAv0gy/55k2UU8XoqT
	 5k0RxxBC7am7DzXDlAOxH5pgOUxNiamqILpribjXFAafrrBJ4m/1aFbSodsQjPAryrQNX
	 wyXuamp8GwUYWmtbceTd7JVlcLHg89Ybn84srhQIVEypbVZckR8X9vQx3/J6BaxuuoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aUxqba48;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.16
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010016.outbound.protection.outlook.com [52.101.46.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335B8606A31A;
	Mon, 23 Nov 2026 13:27:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 335B8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aUxqba48
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h/72J6iUCquUnxQyp8FMKdDWyNDZQpyxSxkMo1+YiT/yMlhDTpKkYU+q1iGuG8ysVvFyjPF42srEmPSFgpUOOtPM25k49dtEJZLg+vTU9SJjXXZXozrQ8aB71XypanDIOFGkuyzDAf3LnSEv33VqLiGrEbwgUWWaYuHFNoBmk2PUEmKwZhQoD0wbkCoiQgXTMhtUwdundlU6MPFUML9Ut35uNrU+wfo+2Kry9vPv85YoyJbQXqaFscgSApyKex4twHnj42Lauz1qeGsRuKD794wGskdh98v+PMhEyy3J/HGZKEC3UKn4TsxBYBoR28vrii+ToYAHiYgGJuL3VlS3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EBieDEUl8juRP+Re5kRW6HCW2ekpyinYTn7WAHXkVPU=;
 b=vB9ZJZh6zu0Jd9URfd+uHlJmehHo/UQlmsnwBNrKO+6MWIozT04hwVSwsrIt/thRXUgyWd5Ju1deUWhcXFb0BTp3JCqQ14p586ZxHwVEYlfc7VYerqmY6PT1aeeBZdRiQtp6pM/q4ebURoy1ZZIQVtrlmbpY69duZyZXar5ZEhv7OEi4olnFt2tSK4+hTpt1C1lYdoc39oIJV9fF+BorYVEMM6Q9PmuWwE8n+L0UI6BCdnYK8bt+ijPEUTU/Bo/eITkiJFkQ4dwdsK8ozFtNfpH0v3qEE88k03WoPF/enl3ijFh5Igv+jHvHhCbxFumCrIu7fylET0iyxFT4E/mmlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBieDEUl8juRP+Re5kRW6HCW2ekpyinYTn7WAHXkVPU=;
 b=aUxqba488TzFMRafPc4ECwaPtfPh65SaVRdjC5yR2bMyCk2QvB64mzFd3Iy9emUZgJSb1Zgv7gCCyf4eeNFzg/ndGjO7plpb5tqETZAfaQzV3oevhqbbYgMpob5yDeD25HTRLV9cEOZAMYJZGZwFcrLotc8QI1BLe/8HV63Ojcfynb1mVHLTVManKTQ94kypOioIwMzqrddOxkqgWFyvh+UWdKPNQhPMfkckF2rXSZMEI1hv+g48wassdJKgQsSCBmvp1nW16fa/uJFwBCBNOy0Nxm1OQQGK7ZjmOwdRLnEHefvAir1+bhXErT9YUbY3bAWk0WNeHr5YCr7SBTfJag==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ2PR12MB8112.namprd12.prod.outlook.com
 (2603:10b6:a03:4f8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 13:27:16 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 13:27:16 +0000
Date: Mon, 23 Nov 2026 09:27:14 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
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
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261123132714.GA178955@nvidia.com>
References: <20261111141315.GI738765@nvidia.com>
 <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
 <20261112123127.GK738765@nvidia.com>
 <b0efaf47-5a94-4922-98b7-2000ae9a405f@amd.com>
 <20261117011837.GG2245175@nvidia.com>
 <aac37ee5-03e0-4a30-b22c-0f7f20e58cae@amd.com>
 <20261118134155.GP2245175@nvidia.com>
 <f68e71a1-4c22-433f-91c7-064f419ca7b7@amd.com>
 <20261119140348.GT2245175@nvidia.com>
 <8fbf4262-5e6e-4bb6-a7d0-ebefca7c1da8@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fbf4262-5e6e-4bb6-a7d0-ebefca7c1da8@amd.com>
X-ClientProxiedBy: IA4P221CA0005.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::10) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ2PR12MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dd06a60-6892-457c-6c71-08df49657da6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|22082099003|18002099003|3023799007|4143699003|11063799006|5023799004|56012099006|261022075727099003|261026140227099003|261028144727099003|10067099003|261102123227099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	DfWnHHJi4XTySsYkhGUvMNpoJbCUtsjoBs/hujN6UMI1TV5ytinBpgGwv1q0kCmezRuLOqGkUDfHL+Jl/0fY2hF/5YKUCLugUPqOyjraHd6ihKqGHQRl7yQtnn4KIvolnRF6Z4tH/wqxUY8w0ckwaHqPHUkPz7GlbftW598qo2xunKp94V7UvvbUgFbCSVqEoSPCOd4WlHMDN5UeXv2fVQFvyPdqWW0vyhdfgO9v1aomK3olVkaTj7MELdzop/F5g1DbNUL8YyXgqiGKYv2kt8UgRCqxAL4j5eJ4YJcxt6wtxkaOWSm3l+Fn5syfPBBTY+jpHkzyM/+K3XFbyQg9q3P7mJhUDrZ5ZBs2LBEzxmh5YK0kQk7Txs3OevGJY1HUjY9BIOgrUNc2Ycaznwe+yVIaT0ZNBAy2eAGReCE0QJPH4J/hqe34tQJZYK8vfByk9SK87MkAGwcS4MiELgfD1Tnu5qI6SWAQ4ZGdENmHMUabn0lSWTxHiMzMcgS3ApxCyI/ONvi9/Vjlkck+xPjUuQ27K8+e5k50iLeXyFGOpQwq7RbdXNLlT/TJecLvf61p29UoHS/4TZFKY3jd7pxjncu/IYA0R3XFZMyyjeaeS3L+04lXQV0to7UNT2O26eiWvdMzp+q8UtNaRYBZP46h4n8k2xdqadM7fGjbAz+RMrI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(22082099003)(18002099003)(3023799007)(4143699003)(11063799006)(5023799004)(56012099006)(261022075727099003)(261026140227099003)(261028144727099003)(10067099003)(261102123227099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FxObzY9M/6+84UNKt1P0kv0F0C2lyxBzveozjVzdP1xfRc3d78c+VbVfXWU8?=
 =?us-ascii?Q?KB1+FZpIP900XrXD/t6v8/27K32AT/Ivel9qV+Stg956HNEMzaZKXZ5j4/oM?=
 =?us-ascii?Q?wDbRLwa/U62eZPh8Odq8cYLbOAyuaz2vXMUpvRhS2SHWGV11rqer5rktlqEN?=
 =?us-ascii?Q?AsFV8Nz05tS8H35kNDgR95Dr0ebe9ep8BC6NLRZzOFSrw34xwB3ycs7VQhsJ?=
 =?us-ascii?Q?gulnjJTuJls58eb0ZCqwPwQm+4BPvZKIjPBYEjEZn/+H/hQEJ9mbD7JQ7Fr+?=
 =?us-ascii?Q?3n+/8ubhCLOqpivi0moAF+VccxZRgfsrp2IhjWjimdhhH9ejiV+BIIK9LqZ1?=
 =?us-ascii?Q?P29tuUpW4OpxjyEVlchaEgaS7fWSaYRS54DO3Yw4jPLBJPzr5ainEnXjOF5p?=
 =?us-ascii?Q?Ii9euaP83MxS+1Xz0BjCmaj4d518BJQ5XT4fybu1n8KPYj7z17Nzv+rzV7iI?=
 =?us-ascii?Q?9c9FBRILb+QIK/ZJpp/tXmhQgX29Qu4cPnhwCRigUeUkloxMhpQ1PjeA/SFt?=
 =?us-ascii?Q?sGh8NXKR8G+MFwNmaP8YWUpp4ddgWjtI6x+Oststty4JdWxWxTTDWBYzzkpe?=
 =?us-ascii?Q?Ew5Vfv0ML1BF6yB6H6amzk7KiwAMKD9wVdsGaoV9pwARNyrqx7eEtRp7rpph?=
 =?us-ascii?Q?Abyoa1R8ag2fEwFtvHCRdFK0uuxfdoBEekiemgozoofHp5OQpQeLWsNdZ54m?=
 =?us-ascii?Q?fja0XmEzdGWrKK+7yap7YOsx/n7Qg+iY8/YYMpzpTjv91TSXnx14J6vc0cgN?=
 =?us-ascii?Q?hkzJADwTg43UU1yacBkK/izBZkSweWFc2gYIionuXnExnKJ/LJ4Qqye1/dzs?=
 =?us-ascii?Q?25V228O6BVnnvveJcD3P0Uav9IZb6wvqAM12PMlE2GtE3JMzP7T50fxlt3fx?=
 =?us-ascii?Q?n6jzXkagqr5COV+4eh367fc4qoLj0BuCxl/+z9VPkuAyJWKwpAjI63+ipH3W?=
 =?us-ascii?Q?sRVmcMtsKDIcaaqXKJcd3MtH5RqjFimuT8SCTol2rWRg4HNtXsUv0OlqJ7Kw?=
 =?us-ascii?Q?l1+Uo39rR9xx6mcd1hmV/HXwbp3Ntx0WAC16MVj1Tf+UGAFUpJG9h7RQUZgO?=
 =?us-ascii?Q?t8YSLf/M7iTMZNh8VzmLPho1SmbrOfKgTsuFD6NGpRbmEoGzq6SQjeeZ/DtS?=
 =?us-ascii?Q?hJrB99gPWFtjBlI3WiRqZeLRvCg7xHzbHq8S5/IFrhxfQ/MMmou3R9+Lyx3q?=
 =?us-ascii?Q?+B//gMjLKfC00BmzdrOa5z3KCPM/QGhi5qsTjLbTVE1wQgc8M7P1cI9A6r9J?=
 =?us-ascii?Q?ZtAJD+DdhP53cPKfY4icvcnJ2n2XWTlB/wrPJ1GN/cm3oVDv05P9NhFySZDR?=
 =?us-ascii?Q?DRQ+wgLbq2SXMrzDOgOFUna4biwGnXZuHmWrfuoZhtL7YpJ4D2fC/YCq6Mks?=
 =?us-ascii?Q?l25nCr9006yAw0QgPSo5zzB1jUyVrOmP5D7a+eOoNZbSTne/9csx5BrCR42j?=
 =?us-ascii?Q?QSgA8VS7cN7tFPH/0dB9XShXfdCsCmtMwaXlj7J9vODV4z0d393zYh0Ptxt3?=
 =?us-ascii?Q?YKdV93sTZaA7se4jKuc9tMfrqXzGKX7KiwLu3HWKUmvS+LrUVhIzBx7mYDMs?=
 =?us-ascii?Q?Hjg5HPnKTCkAHFFcHfTEA15VBExwz32+zFAVcecGtYe1TZC+OZhmIzKE85+t?=
 =?us-ascii?Q?4R1q5ZzKCOD84htAtvywGCaFe0WFPrWb3S0Sqi7wwkr5gM/2o+StIDrfkEFc?=
 =?us-ascii?Q?pRI/JEYpOqtiv1ga7R33TbLC37/nzFkiCxTHIa2pBaK5b7e7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd06a60-6892-457c-6c71-08df49657da6
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 13:27:15.9821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qug6MlhvrjXpdowV2oIhkBpq62O+V4pSmO6I9RKGbl8CEn/79c1jM+HYa1w58wLf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8112

On Mon, Nov 23, 2026 at 10:10:05PM +1100, Alexey Kardashevskiy wrote:
> On 20/11/26 01:03, Jason Gunthorpe wrote:
> > On Thu, Nov 19, 2026 at 01:19:22PM +1100, Alexey Kardashevskiy wrote:
> > > > and worse as soon as you DMA
> > > > enable a hostile device with ATS you loose all security.
> > > 
> > > ? I'll set vTOM=0 to make all guest RAM shared and observe IOMMU RMP
> > > faults if the device attempts accessing outside of shared SWIOTLB.
> > 
> > A T=1 ATS capable device can access all guest memory by definition, if
> > it ignores the ATS protocol and directly issues translated requests.
> 
> If my IOMMU is configured as I said (vTOM=0 == treat access as
> shared), it is still going to check RMP, notice that the actual
> guest page is private and fail/fence. Only accesses to what the
> guest made/left shared will succeed and that is SWIOTLB.

Once you get to T=1 and DMA_ENABLE the RMP will allow all access, by
definition.

Jason
