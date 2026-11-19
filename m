Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795097043;
	b=chZoC5neJ5BCmleNfXE5ZXHlBr+wZxPWSr+yOXKWcRepXsXivzj58WtzTPwQBe/hBGva
	 V+xGorHszc135aLrs7yAgDz9OJBixnQvtLBNGHR7bRjZ73f4KrsRawFXICXQrhU3Ze5QV
	 7WxlJ4+NPZdps9QvE4uWPv1socOCxRqAoKnk6U90L7ho/zdp8fHi3aW9tKIWOtxVn2SbI
	 GM/ueflIS++dYlDgFp+rZmrt0AM3GKRvyxrqT4fGYILgrzbpXkgj7Ms+38w7q4U0w92aY
	 sCWEpMpWUXhiInTeoCv82xsfQsMlXyQkiT9EyRzQwUtr7N5nsfYteLgVSxZuLLjN5dg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795097043;
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
	bh=16YAJ3KeZ8HyLWxQrYQ+NF7Y7732mtvwUFeig06HqAk=;
	b=zuvNzbl5O2VBT6kF9r/WYtX9X2aH1/a7nUxfJoqntLJWmf6T1sHAMAk1O1lr+2cxcWuM
	 zrX50XKEEueFZnV8sbzv72deQotenNYyCFic9Hf9b1h9c7fPjbjzMoXv3qioaCQzMaIg+
	 KyzIQWPVWVfWd5/YfMDw5KKSM91hs3AUDLI5yQNf0PMyqZMkyQfF0WS81rTqjTLfEpaMy
	 2Nf0ZBmdBxm3et7NMnL5v/itXoNJPZutKIzYlvPo4Z52yfSxlpRuiAaIzW6LmzUPBtrxg
	 Z8+/8pyysjQALPyG7wr7zhBfciwOz/SCy9d/eNGaCZe/GaCzUrPyzeYjxKaPXeWAV9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=i+CZRHgF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.56
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010056.outbound.protection.outlook.com [52.101.56.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5AA606A320;
	Thu, 19 Nov 2026 14:04:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D5AA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=i+CZRHgF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k1jhYyNzUvdqGYo/Bnn8vt5dweDsZVugPC/K7aIop/WCBJ7jrOxEATRlhj27UY2a11AZqm44fHKIOZ+1g6X/H4h4t7X9wiPhDEtu/q8p4HzKZiTXq2ZYiRZfNgUFEGSw+22BYnrsPKAXLRl816jSdxChOPEJM3DVyu51sp0oRHMk2L9nrTdxuX3RJLcbD+bgB0wAeXkmvw47mRqMg1mhF745mFfNSkbEKGlaa9frJzkJLGQeSRL2i9DjhZqAk2AUtJOlKfmbtc1hfp8BTZ5q+Jd0e3KD3LpOjnFTwgDGASXlZN/liwoP8Hsze1cksYI3ej1miSyEKaiL9KkMiCUK4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16YAJ3KeZ8HyLWxQrYQ+NF7Y7732mtvwUFeig06HqAk=;
 b=DItQ7DolmG3vdkzu3MmZugyuiq8yJfPDkMyyJsiI9CY0GyyrBQRwVRr0JtKmft7vY1Bof0JK6wzELOhnfpTkcAWeDxQHSRlmMrUb0v93Tr/7y9eGhNkeK4jP6jnLmZpMjbekHTus8p8Edsta9zNhGsQjYWBPNjSB6jrEh069BIhZElrgsXZ63rKJFHZpFyB9vxeGNH8cJOIdnBWpaET9XlirBlTPRpessTuouGpmnQ0rMh+PL6It/EA0LX/wUgFk7CTbl17YDPerEHnegd17iEESFKXssoHfYqkJ0NH10ehpWbAHNJMaSBnd9ptVg3Hvmt9IwcJnIC+0AJABgBoclw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16YAJ3KeZ8HyLWxQrYQ+NF7Y7732mtvwUFeig06HqAk=;
 b=i+CZRHgF1cLV5mLwIp5Cu+WY8P1P9A+MiPx4kPrrc7aJr/B8mk0Zua3zVrYPxP5u4ymvKeC75JBmuBu2h8eAwMja450rCMPJruAoWlAQeyIDVgY1Q+G8JOKJU02YmgIodg/eucmIkOAXQ1G7Eqe2xXQ6MpaM96zfdBsQuVoqfPJD+JVhuTSjOYMO4TKUcQBohc1LlGVOb2v5yY/vO/3UE1uE2XK0f1iNtNZ6mTP1V1zw+V1anHkdWXwVk+a78vniJQB4J6iPdbj8qZSplwatuOwNn9sK7lI9TlsFmy0C1fq2idMPUjyTP6vPlNfDQIwa8/T8laHiO1VC2IAww/67JQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8220.namprd12.prod.outlook.com
 (2603:10b6:8:f5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 14:03:50 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 14:03:50 +0000
Date: Thu, 19 Nov 2026 10:03:48 -0400
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
Message-ID: <20261119140348.GT2245175@nvidia.com>
References: <20261110142038.GE738765@nvidia.com>
 <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261111141315.GI738765@nvidia.com>
 <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
 <20261112123127.GK738765@nvidia.com>
 <b0efaf47-5a94-4922-98b7-2000ae9a405f@amd.com>
 <20261117011837.GG2245175@nvidia.com>
 <aac37ee5-03e0-4a30-b22c-0f7f20e58cae@amd.com>
 <20261118134155.GP2245175@nvidia.com>
 <f68e71a1-4c22-433f-91c7-064f419ca7b7@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f68e71a1-4c22-433f-91c7-064f419ca7b7@amd.com>
X-ClientProxiedBy: BN9P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::17) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8220:EE_
X-MS-Office365-Filtering-Correlation-Id: 25aa8273-6c99-4058-213c-08df4645efa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|22082099003|18002099003|3023799007|5023799004|11063799006|56012099006|4143699003|261028144727099003|261102123227099003|261026140227099003|261026121527099003|261022075727099003|261021123027099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	eqIEgOedJw/atMt3bSH9MjqaTZwyGJAT2nhjO85eh4LuazuFZEwBnIDfuvYwyCwhaBh5CelunlIo9FXQOa4QXk5rxvyNJkjUMMYA0VjA4ojrLEPustD5mC/MHVpkf2u7JOU16uqwYdni8tiAmLux+ixI1lwL07s1Pu9fVisGMKzrTomMQ4civSryEZamagxLmy5bJu0EVWQaLC8RAdsot/ySiPDOwoTBeBiRzupRSKjpJE1rO82o6zwK0VoXCQ6NBd4DbW6dD6Hxl+Xgy6/m3x3mOaukB3NhXw+lJJwMwh3UA8GV1BY/PHSVvV+/NkJ+A6R5VA3eW3YTMmhGX4GFeaEu0wqhrQNCGOqRO7/DXUTv2p8C8mQknrw5a61XDlkceqFeQpAbcRlMPgA5lnWUhqWPfcTfbwQubQy+9P6rC2Aa6C7KnNQe18XyoHyCLU1Vk9ytPOj1i+phu6euKeLUMYQ/miyjUMOZLpQl9Ln2DaPOvNpEhOezb+00cuDUqWpYIyVp7buqmUsjbZVZeq3c8+Hc4B4RGfjudH3pEbNn5/S/xy6KShqbEjJc94T6BM0pPsd3NdFNYqqAosYJUimCkEqbGtqUF7Pn0C3AkfK9NoYRyOX1TFUDsac6hBtUSxRKDVSUqZakrqQ/4qa9TWjj1PpjwAXbe1i+6YaDqtKaep8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(22082099003)(18002099003)(3023799007)(5023799004)(11063799006)(56012099006)(4143699003)(261028144727099003)(261102123227099003)(261026140227099003)(261026121527099003)(261022075727099003)(261021123027099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gW+U0BAoOf2Wq/SE2MU4N6f9mRvUa3sD3TxizIrjlcpLGD9w2rxzQ1TT8u4q?=
 =?us-ascii?Q?Q+Lv537WdfZmjDREFse12q8EfRZzQsK79SdJXD14yfCgOtgJKeDzgYKs21vK?=
 =?us-ascii?Q?0yQboVg+7Z9fu+pgNF6L6aJ0HCxsDMXL66oDaFLsTsnEmTtzbINl0ZN75UOW?=
 =?us-ascii?Q?2NSC+kj37RxBL6zgNVtBHaucFcbcu9BhVLvWr0+hdTxS9wPtgG/yLMFuhQQj?=
 =?us-ascii?Q?wcvWJR2Yno+ds3Bu+VaTe++nPH6UDCY3f2fxVmCywNgYpdRv5mRWCn8UIfOT?=
 =?us-ascii?Q?qvGuUr/ruexfpKyg2Li/yl7D3L1nV50En5ZCMQr6bs3R133gg1JMulDLmOLe?=
 =?us-ascii?Q?DMFZD/D2abNrUX4aNE52+M1jvQ0V1qtDgP9gY2w9SDpkzwVCFVqoe0vftY0g?=
 =?us-ascii?Q?9LepSW30GuicR4VtOFP7FPMexDVabR6USg+57Ff22dYZWaJx2r2eJdg045s3?=
 =?us-ascii?Q?+sfcHkrcxgBfBSxrDnOLNKrlmZeT+W2J57qLA7OBZ2KnKd+cyLJcV8T5e1AK?=
 =?us-ascii?Q?bIvk6ZzeapWb9iUZtawMA7WnvLZQXzK4kvR6iHF7afaSxEz0h1YcTrmqTpSw?=
 =?us-ascii?Q?3kGYA2hdoL/zQTfMxdDaQpdu43JGBDAf5cjYjH87Tp7QeIWwCWMWXap31qDf?=
 =?us-ascii?Q?hzGK99z3PIfAf0w6/13lBJGA2M4MQXD2MgqrZFlT3uDycORw1xWK/8ef6aFX?=
 =?us-ascii?Q?A1z9Nuvu2THR3miE5IV20HP2DMu7AWI/QqyA29nLS6i20neQxYbpkai2krBj?=
 =?us-ascii?Q?QLpp1GMA3sklGJFLNH/H9kiOsaU30mcz/9wSKx9r7xjmmeRJog7FDUxbLwxe?=
 =?us-ascii?Q?2RGLWdtOMdfhdid1yWDdigLfSgcQrMfphUw1jRnJikVGEiaxA50RuQPVH8Dw?=
 =?us-ascii?Q?C3WOj7+MCs1X9LgqBNtj8p/kCKPuJop355SDFxrcXplhWRQ+k0fSJI9C52gm?=
 =?us-ascii?Q?q7JAPJlLC8kd1UeZ9lQB22WVGDRDi/WKqQ81vQ6+7SWRFo0MXw4lDLx3GCQ1?=
 =?us-ascii?Q?dkziTpQRELohNMK+Hf4uvtXJfuRnOwveOkR5qYyFQwZd4nVcGlTVPK/e6PBF?=
 =?us-ascii?Q?Zf6CCW6R/8946rkTC++vxIjpnRIE09YDlxYLFnWeYTPVSVOqu+/l+88/qbDE?=
 =?us-ascii?Q?D+JUDwYLzWtCpVNDUaA9bC3eSO7g5QhsxvF4t6CX2btfiTcl6JWf+ozbViCg?=
 =?us-ascii?Q?D/Sdqpax4IpZhysAolzamCvODwkT+kZpHcK93X8me52z0EPmZXZCC6uZHdTO?=
 =?us-ascii?Q?DTC8F3k398mOxLMbLq0t0ftIp9w5pyepCHwWzIk3/WtxD4S2QBa6zktmgg5V?=
 =?us-ascii?Q?kuDapfrNyxBLxoKtkrErGixP2LIeFMHmu51GIgtOW1pqDllPAb16H5HILQbi?=
 =?us-ascii?Q?bpmngPrB+eJAnQhQHgDOiJJWYRsXmc2ddHWTuqpeq8H0U0Mo3GqyuCA79/sU?=
 =?us-ascii?Q?8SbPI1mjkQ/SbEjPdFFT2s/tQASVWrzv4za1VPxhvferWpCqMsrcecV41QFR?=
 =?us-ascii?Q?MSZTQKZef6MV6xlHkaI/1l548ZMHdORys9L9HbAYNZuWr3ci5KQiPjDJo8Fh?=
 =?us-ascii?Q?uexUGknHnrL90exUXfZ/y1GQSwYVfNOZVr+PrCp/3Wx/z3c0YbLEf+J/ncsF?=
 =?us-ascii?Q?kKjSeVVpIB/lPNp3KS6dgMAgle146iqvVcHl+7qEbS/xbgwle31HyB4y6mFV?=
 =?us-ascii?Q?Nrc5sKJ0eJxJIyRGzbe/6ee5nPnI72b/wgvMq3jDdFr0vsf0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25aa8273-6c99-4058-213c-08df4645efa5
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 14:03:49.9131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gL/uSw+F8hrPIyHdWRTcSpN0JpoA+AonxB5puuWJwqpIYWPWla+ya/hXT52GQww8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8220

On Thu, Nov 19, 2026 at 01:19:22PM +1100, Alexey Kardashevskiy wrote:
> > and worse as soon as you DMA
> > enable a hostile device with ATS you loose all security.
> 
> ? I'll set vTOM=0 to make all guest RAM shared and observe IOMMU RMP
> faults if the device attempts accessing outside of shared SWIOTLB.

A T=1 ATS capable device can access all guest memory by definition, if
it ignores the ATS protocol and directly issues translated requests.

> > So we cannot have a model where we accept a dirty device and then try
> > to undirty it. The device has to be known clean before we enable DMA.
> 
> SWIOTLB does not accept the device, it operates as untrusted legacy
> device (which has parts of config space locked), we allow that
> now...

Not at all.

Once we have got to RUN and issued DMA_ENABLE the device is now
expected to only issue T=1 transcations.

From the DMA API perspective, and in the IO fabric, this is now a
trusted device that can potentially reach all system memory.

If you happen to have a vIOMMU in front of it then you can use
iommu=strict and an adversarial hardended driver and maybe still keep
it 'untrusted', but that is a huge thing to ask for.

Nothing to do with swiotlb.

Jason
