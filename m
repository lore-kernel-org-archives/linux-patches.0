Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.29
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794495184;
	b=smv8fdWawpGh8TKLgvVU37+f3y9+Vc1a1KSa2D4wQnbgzMydXJyJiA0MKJVi1Z1PTdjX
	 ECgnFb2hBGk4Bb6VIxpppvEewOVRWmJs/vhFUuD765+d6HTDbACxy+te3kvOL6LH5u1xk
	 K2SEaX99gaKijLhKm45c034TKJx2V507SBPp5EKVcuy0i1q4TN/ldeLq6nHPTAsE6A8c7
	 4loAlHTiaBeUX+fVb7jiTSUuE6JNKjsb1ZBAKrtzYmkN3KeOOWKYNkVoDPEzLxKLAYhDJ
	 aXZ/K2QXTLIzAOf/LS/ZcM61pKk6BVZpQdNQGtOrMWF/St5CQ62caCxM0jGOmcE7aYw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794495184;
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
	bh=SZrSvziaPmftmXuTysW0VadxQk0HcGaO2VaXe5C0QS0=;
	b=aIxuvkUjxL5lIyLBD2mAw2QYA4bpAYn8auVZ93RjXJ3HVGEjZPx6/CTFzmzX4W9+fdmj
	 GrC6wVC7U0ip0aWUPAMe+GH7PCwSlfTGMWyYWhOJc4J59Ow40FPR91iG8WLHfn5yO2KNi
	 tcYbN3gda4oi05BH5QjqogEXWmtFFvcj7434IxT3wf21PCeERtKZyqwlDF3iCQyOwwyB0
	 yg88RnJpSUEHRmW0bApSB/eNNueSmeSS6k3VO0ESg+C31ex6lG0daL17QoVKBAQLeL4IH
	 tPo/S6HUTarfnf8YMx4O7O54MyA3M5cBmiWEcLr0W61jbEFMS6zugfcvgDDBA1QM+Vg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=sF9mtdqd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.29
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010029.outbound.protection.outlook.com [52.101.193.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1973606A321;
	Thu, 12 Nov 2026 14:53:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1973606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=sF9mtdqd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s06tcG9Mi6LzmRkIVfQuUnIHbFacH94hHR/A2NJJ8liWHVr70wQQ+Gdqrx8XlxiRvnQEzrp/jNHg7+GTtji0TDaJuWnU+9IU1xXmvXRKa29sdQAZg4oAvEPL1/pKHTf4l5hL9MlmEHXV2XTMadb+7ecFInW+MNMSvk9iAyzlj1o65n7QRTktNpmPtEeRC9Cxja4N1o8cTveCOkU/ojM3XVJVj74CrdHT1yiWjZnLNRSS6UBemLEwzBtm3t3+hDfF6l/cIXlHBJL47SsMTeAtQaqqzuPuk0wicF6N+b5yQVDBW1X/U1QshKj4Nintjw4QoaptxnjlgdnMQow5oFqJ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZrSvziaPmftmXuTysW0VadxQk0HcGaO2VaXe5C0QS0=;
 b=iW4OJbopLVqdcf/jxWpJi0H+Ivhe/nLRaxVeKzkOgV/hZeLdTITnSXoDG8PVM3T/onMkZWGd1VJKdC5VRAgVt/ybzdjw8F6Km6P83+SmkwF88Azj0icxAzkiCyrnZH2Ny2F+aO7YLfQtZ7foLL1Yatg4cwvt8v/xCo+J9YOO+vaEF7DiXxKZBwiRhxSvIt7mUZF9HDsQsG6XRBSUF/FGPL1d1G1+uFKOIFlGwTLcS2EQm+J57SxUra1OaIDQ+BwX3IOW2ku/g0y/sRkUVgH4rX2nVrdK1db8uH4Znt9pLychUMODA5MPKiAOKP0748UWUNn/XhRoyzq76ar58Hetww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZrSvziaPmftmXuTysW0VadxQk0HcGaO2VaXe5C0QS0=;
 b=sF9mtdqdmJ5JT4L9VX7aIp9F9TOxIyv4iv8uBCWTe6/mX/KHrDQvkJA3vHWVpLm/C4A5ybffdkhKb2w0b4c318umWEevPgXdyrIJvYIWBSxicwjQHwPSsCEoKh1b/lIWKQrEW2gD+4Qp04iuzvxPqpD4UWTYoexvGIBRSuwJvBB8lYrjizecmC0zXr63Hj8oPb5W+7oMIsteqHe8iij920EyajNuBtXeq/vyx7BFw41CTygHoT2L5NoJPe+OL5D3rLdhPi4BKJpNwfYFlqNgyGmGBfBpXTYRFiVRVbGeZSIrX3zJ27bKXS56PmBGmAlo33zcq8Zn+aB1Nq3yYh0JSg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM6PR12MB4354.namprd12.prod.outlook.com
 (2603:10b6:5:28f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 14:52:55 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 14:52:55 +0000
Date: Thu, 12 Nov 2026 10:52:54 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261112145254.GL738765@nvidia.com>
References: <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a5wy2qtjs.fsf@kernel.org>
X-ClientProxiedBy: DS1P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:44c::12) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM6PR12MB4354:EE_
X-MS-Office365-Filtering-Correlation-Id: e03ad63c-e221-40fa-20ae-08df40cca248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|18002099003|22082099003|6133799003|4143699003|11063799006|5023799004|261102123227099003|261026140227099003|261102130727099003|56012099006|261028144727099003|261021121427099003|261022105027099003|10067099003|261021135927099003|261022075727099003|261009223027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	aTa0IwXPHPOIP7el0+4ROMwkSOC35WnDR1TX98I07ZkaZJ4LftUBdAuxxa9Z0IWE9crbut/rzMJi2X+bcpKgbqjtzLDUqLiFC54qViPyqHOQKfbQIG8CvZ0JRiSFOIuW7aHjbAKtzjPgdexDeb6gUD9+5J6PEZyWJ57xfcDIcG15FVxRXjcFwEmy/TLFl8gUkhM/agCoZywSQfs2dSXuIPUgQk9ciiATjEcg91Uab+0J3EytwAi13PLcK6vn5u8FhtewOzKO9QNmtlRsh5Axj+wVIkxWiW4WLZkDbPAjoZd2BeHp1q/mGi2bo7AbIHUMM3Xr9zOr2brDlRRbplVsu/ZqHko58K6ualI/vlhWoYDap40CegyT4exwzE4q/Qu/db6tRhiQR/zTtyBGuFQNaoEOV0zNusEesN8Ico9LwT1Wf1j8a0+zBWhq3LonxZ+/lydPnMX4/qSsURbQQYzzFn0KqXA7V3ylnmo0reppQaLqBoyiAzb9SnTEOLF8WhqHIsYIrnDnTQwN7hlLcm5tn5PhMSLZG5Yia3AqjgQ3zxWro5AHQqeQjTCsKATtKdlHTjWS4pTEHr3wYRC0KB6wWeLEjuBG6ONgXkU2JgzMUSXpIa+9ZJvpKKFEASRyZgVCECsDDD+QXwUQIi5C6yPNQtt8Ui/dbBidtgCQEPs6ZAg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(6133799003)(4143699003)(11063799006)(5023799004)(261102123227099003)(261026140227099003)(261102130727099003)(56012099006)(261028144727099003)(261021121427099003)(261022105027099003)(10067099003)(261021135927099003)(261022075727099003)(261009223027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j9lQpPtXmLFQe05OhS5HBLLi1ENmPZn17hMG4INieaeI/131bcHQDNJuxB2k?=
 =?us-ascii?Q?5narC8Fdy2/Gkd6+O93Tqr8tc2HK9x4cj5aLaxrKKdWvbEkHDw922Og4VPyg?=
 =?us-ascii?Q?RykodjPMbcDuG+IFVjDNcuvJWFbGJaubAZkFWrin2uJfIWLSxcC6UxAHJJx4?=
 =?us-ascii?Q?U19AC7rNGP/wW4AF7f2b6RyU1fk/msZc9vQkBG6dIYeZmaXydtrl2HXLCHHy?=
 =?us-ascii?Q?XTLRR4FO315jKRxMw76lTmGXzypPiGsmdg9oH+B4saU+o4LkjsB1OziGJzFN?=
 =?us-ascii?Q?2VsQZd698iX7bMjoFx8EfkzHjZDX3evm/wk8N2EKv9YLZ0uxAVcrYoRdibNN?=
 =?us-ascii?Q?QpEl5LXpGvCvQgHgnHptIiYzdxJEC++RvoxfKDCr6qzh0kZI00Ax4g/WV8Np?=
 =?us-ascii?Q?hXjh9c9Wo1PF00ZJkd1NvrJ3odFBlsJ4WYZon+MytvFN4hPzEdhjR+QyMPyS?=
 =?us-ascii?Q?bKr7t7+6V3M+BTyZW9K6x3RTC7nhW2QGGKszfJHqLkAd+Vlhh5A5Z4ZkrtUD?=
 =?us-ascii?Q?h9ZffQlHoIIE5E1j8p6oe2NMO94j31DJcNY21jxzUiGr4XxhSOc7pTqocKCO?=
 =?us-ascii?Q?sXE4vcQqN6ai4WufCxTxr/1iENEzAgID2iWK1wZ3ePtLVzL6kydAoIjbXj7M?=
 =?us-ascii?Q?CmHoRXQYDpPvyrf8/53PGm/OInmN6oTbia6C1jNl8b0gdmZ1dpRbU7Kxe2MS?=
 =?us-ascii?Q?wheYpSoWxNLSmmr5VdWWSt78lh1e32BFrUU32QPR49k89NuFaOz19/Wx8R+8?=
 =?us-ascii?Q?BS50tuq5oQVjN97hTi6xN0ToE4OmV+O2u7p+B14k1pUHV+FauH1VophKKNb8?=
 =?us-ascii?Q?LkKPldTeAfmvbr+WqtIbqZiyRmBpdfaSjKWTARNJW3j6DlLHxj5TfyF3Jijw?=
 =?us-ascii?Q?TcqStHzb2QAuTjUawiuCi4XEVGal1cIyCX10HZ28ugeJGMyLsZ2Ei7+m6/5i?=
 =?us-ascii?Q?4k326QPXo1ALZZWGsocuZT9n8X7lhBWxXGm74+l7mmSBjGHyOY7b2Ouvf+3g?=
 =?us-ascii?Q?YK+L0C/wBBKMz+HlJHiPKYQtGgRsMo/3RBGA75ji/HuTb9J4GjJfTzgTg39A?=
 =?us-ascii?Q?Lhej4rt37whENcChgTQroWlpROIRgG+DmRB1iE28oi1vIZWPoI+3ih0WBMah?=
 =?us-ascii?Q?1yJ5MbG0uOt48+K6RAQayyr8Dv0vvXJdgKBCz8f5UY7/Pt9bmETZNWCqYu4D?=
 =?us-ascii?Q?bYFfXl8FsUQvUeNexbwHedck90ia+3qbTy0EjndPGuGRXM1cmTMRJvLtSbUY?=
 =?us-ascii?Q?TX1ZD9ikpJelgtqw3iC4uQOGd733mXA3Zh8nkgnfvXxWfuGTC0E47I8u2B40?=
 =?us-ascii?Q?VMgVpwjmwHzBr9lZ3EcH/78fVkCKKCCMibgC9rvTKyqeU5MCsWm7T5PD/nHG?=
 =?us-ascii?Q?ic9pdnx0HmtSXuGIj0mjd2nJB3h+CDnqZryjp6niQJgnTYMo3fCNoQf9V75M?=
 =?us-ascii?Q?CueO49dvz9vJMfeGrV36ltUhpW2Ti7Q53HEgKMcZ/NSfKvD0mFXQZuis0fKJ?=
 =?us-ascii?Q?WH5jEcnkSY/z5SmgE+e8GtwS73WkJCvuk82LJwJtU6CQoAyC3na+MegCqher?=
 =?us-ascii?Q?bLH9xXZkXgpuDXI4qmEfUbrZkDsoEXkOfVaFsddA8Rhs5GcGzB/FInJQoBRO?=
 =?us-ascii?Q?7ag0I8eV5e8DBgswYLv1D5XQgyah09pPltiHY7jTDd/I7hitMjhAAmJOAjD/?=
 =?us-ascii?Q?ZstKyPM1lUNnP37jM5boGAKppT/rYaoRVtiTMoniJ/nf54Kl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e03ad63c-e221-40fa-20ae-08df40cca248
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 14:52:55.1802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNq7ISTJNJ972ksTsz9QnCXrj6qhU+MlTEWnK4ZMKUQ+vdp5stayn13ClOaFEriP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4354

On Thu, Nov 12, 2026 at 03:07:43PM +0530, Aneesh Kumar K.V wrote:
> > Like a whole bunch of TSM FW API just to do this:
> 
> Can you help me understand why we need to snoop the DOE messages? IIUC,
> the earlier proposal for 1.2 was to use Rust SPDM to perform the
> following:
> 
> GET_VERSION
> GET_CAPABILITIES
> NEGOTIATE_ALGORITHMS
> GET_DIGESTS
> GET_CERTIFICATE for all slots in the slot_mask returned by GET_DIGESTS
> CHALLENGE using the slot 0 key (At this point, we can also verify that
> we received the certificates for all slots supported by the device.)

At least I wasn't proposing exactly this.. CHALLENGE ideally has to be
connected to KEY_EXCHANGE, ie they use the same nonce or get digests
is hashed by the TSM or something to have the full value that 1.3
brings.

I've also been told that not many devices are implementing CHALLENGE,
so this may not be that useful to invest in..

But the main issue is we have to use the TSM to initiate
NEGOTIATE_ALGORITHMS because that defines what the contents of the
slots will be, and a rustspdm has to follow the TSM's selection.

So, any version of this flow would require capture as a building block
anyhow, and you have this awkward version where TSM does all the
negotiation then rustspdm injects its own messages according to the
TSM selected rules.

It is possible but very hard, so I think we should set it aside. This
is something to reach for if the vendors don't want to agree on FW
changes as part of the 1.3 upgrade to improve things.

> The host then select a slot and use it to establish the IDE connection?
> (For intel we can only select slot 0 here?)
> 
> What does snooping provide in this context?

Capturing the transcript makes everything 100% perfectly consistent
for everyone. Userspace sees *the transcript* as defined by SPDM not
some mangled, truncated or processed version that the TSM decides to
provide.

Userspace gets to see KEY_EXCHANGE which means the verifier can prove
the certificate binding, this is the ONLY way to let the verifier do
this proof if it wants.

Further with capture we have a nice primitive to pause and do slot
selection before going to KEY_EXCHANGE. If we know the kernel has
capture then the ideal FW design for 1.3 multikey is much simpler and
clearer (more like ARM).

Also, ARM decided to do capture already, but directed by the TSM.  I
think it is the right and best idea, they just made the implementation
too narrowly specific. eg it doesn't split up VCA, it doesn't capture
100% of everything to get KEY_EXCHANGE, etc. Trivial to fix while
upgrading to support 1.3

Finally, Intel actually seems to need Linux managed capture (Seriously
Intel, WTF?) as they don't have any other way to get the VCA, and
without the VCA the measurement signature cannot be checked. I hope
they still have time in their spec process to adopt the ARM approach.

The ultimate goal is to get *consistency*, especially a consistent
uAPI. The second long term goal is I want the guest and host to show
the same data out of the same uAPI for attestation. The guest should
not have an inferior view.. It will take some spec changes to get
there.

I've now gone through all the exiting choices all the TSMs have made
and here is what I'm thinking

1) The uAPI presents a transcript interface, every message and reply
   individually presented to userspace. Perfectly future extensible to
   include GET_DIGESTS with 1.3 and whatever else comes down the road.
   These are consistent spec defined message blobs 100% the same for
   every single SPDM implementation and TSM.
   The kernel will start with a partial transcript, but the API
   can carry a full one as we improve with no uAPI change.
   The guest will see partial transcript until/if vmm/guest changes
   are made

2) The uAPI presents the x509 certificate chains in a consistent spec
   defined way that userspace can hash back to GET_DIGESTS

3) The uAPI presents the signed measurement result and tdisp in
   a consistent spec defined way

4) We have the four step
      Start
      Get certificate
      Finish using slot
      Accept
   Flow I mentioned earlier

5) We start without complicated capture. ARM will collect VCA with its
   in built capture. AMD will do a measurement collection during
   'Finish' and extract VCA from its blob. Common code will transform
   both VCAs into a truncated transcript.

   Intel don't get a VCA at this point, so no signature verification.

7) We implement common direct capture and throw away the VCA code from
   the drivers. Intel can work. Every host driver has 100% perfect
   transcript.

8) We have a nice think and Linux sets a recommendation what the FW
   TSM interface should look like and try to badger the TSM FW spec
   authors into something more consistent than this mess as part of
   a 1.3 multikey update.

   If everyone can standardize on ARM-like TSM managed capture, with
   the proper breakdown and data inclusion then we can get 100%
   consistency without a complicated capture process in the kernel.

9) The VMM uses the above common interface to reconstruct the
   RHI/GHCI/AMD. That mess doesn't leak into the kernel on the host.
   I checked this and everyone but Intel is fine to construct their
   host/guest channel from the common interface.

   Ie fetch the x509 bundle and reform it into whatever was speced,
   then undo it and put it back into the x509 bundle for the guest
   attestation subsystem.

   Except for Intel all the guest defined digests can be calculated
   from the common spec messages. Well, maybe AMD has an issue, their
   spec is too vauge to tell exactly what bytes are digested.

IMHO ARM has the design that is closest to perfect, a few tweaks and
it would be excellent and support 1.3 multikey.

AMD's is weird but at least what they have for 1.2 can be made to
work. Will need to be rethought to get get 1.3 multi-key. Copy ARM.

Intel.. Is wrong IMHO. It is still unreleased, is it too much to hope
you could just copy more from ARM?
 1) No easy way to get the VCA, no easy way to do capture

 2) Wrong digests design for the guest. SPDM_DEVICE_ATTESTATION_INFO_T
    is a terrible idea since it is not grounded in any spec. The other
    two have multiple guest digests computed directly over spec
    defined objects.

 3) Even if you like SPDM_DEVICE_ATTESTATION_INFO_T it includes
    TDISP_CAPABILITIES for some bad reason. Nobody else even
    exports this info from their TSM or digests it. Thus Intel would
    need unique API for the VMM to even build
    SPDM_DEVICE_ATTESTATION_INFO_T. Not nice.

 4) How does future extension work? Oh you probably have to pass 
    SPDM_DEVICE_ATTESTATION_INFO_T as an opaque blob through to the
    VMM. Lovely, so only Intel needs a special Intel specific blob
    uAPI? Bah. This is a very bad idea.

 5) Several unnecessary collections during connection setup.

 6) Confusing/bad implementation of 'TSM selected nonce' and
    "recollection"

 7) Lack of an API to do evidence colllection for the host, the only
    provided API always changes the guest visible information.
    Not nice.

Jason
