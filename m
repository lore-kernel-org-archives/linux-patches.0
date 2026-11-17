Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794922132;
	b=VwhW9HuOgQU6O5BkI/RvoXFO7RNKpqTB7+ndqVIewWtzl+s0mLCQNwJT977Psq/j523h
	 c6h/KVAj4jmoTJ/0Q5v8uc2bEjvCSLN3Y/U7bNRZ4kLE71F/AQQPhFhxeMJS5qIW8rYSl
	 PFD56V5YYuOtwlgini8qbXuPGVwsC+maox8SSAaHeOlsWwks/CoqoBWptj5h7FGlySgw1
	 R3aDvQDXpyvKQVZOsqCsgwYa868EF//8NNgLFa7F6cs+5gcEE/w6P930B/Uy9itXOkp3B
	 R6avzY8/HxwPhKgKEaWJSyseWXoWaQYSDZoQ6UqNo1spIrIhyFmfi0f7mU1GpJo34zw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922132;
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
	bh=RR8wOp948mDPqPY6f4GsNJmB1ROnnfpH5TlfF86gxK0=;
	b=cC4s1igoL7SXZdxMOMa6mFlgAog4IoL4M7KyFbj6KvHyN/o2kd/S6DdHk2cxd2BiRhpP
	 +dgIcG9MFNHrjgG5DGbdLmMSvXvtTpijNPIx0Z/lEcIfHhK8e/Nq+GyTUQVJA/2cVWnP6
	 OTRMwjvC+LIzwf2FbDkP1Jqycoe6Tb9jiCNuk5SderyEXJioSp+LNYtqv6LiWKXTZ1zYz
	 kqM9kRF/Ur+bIuvukasRnnBXsvI7EIJYo24xK/XLbkVEPqu1JQOusZQnzElb2sv0glSI5
	 qBVFjIZ441tc9o+XEqNSN5l4th8q17ny3QvhxnHRZqlWKIWebtHvMPXvdvNH1wkarzQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eDbgA1Dg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.35
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012035.outbound.protection.outlook.com [40.107.200.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476F8606A31C;
	Tue, 17 Nov 2026 13:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 476F8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eDbgA1Dg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y7SNOWtC3mNVtRWKnBDD/Vr7nuHofLL0Tdga1Z66HJirGqRQ45jJJ8A1Lk6P+kBatvfta+rvPgFX3HfHi5+NHEIfgX7qTvInT3xYKHQ14G7Re6IgKPg3gbq1JKuEVY2bQmEbrzm7BxBBBgUMkvVosskMN5GAdrFMoIEk/hejN0ePqEbfKda5YCRYUBz2+dxkgswrFXjnIEZTqwJUAlSjlMCszTC4FOzP6Ri4na9SS01Kw9roMj+UdhPFnpg+5NFIsCTQgkNqXX5tfQFkhyHPT/l4WPhSrbagb1gXwTB/QLZNLNx8SDM3WfAEPaV51l12DgMrk1JZg1NttNqOCU0udg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RR8wOp948mDPqPY6f4GsNJmB1ROnnfpH5TlfF86gxK0=;
 b=vX626qdVI41zqSt71zQAaEAUgV9RwYkP6RTkMAUcqYqYOfNepsTSsRXfN14uQr6petxPFXlgyhmLeh11JFRfAPhF6zDnQw5yTC27V46+1k1itcgxYKpyd3OzABhqzMyxFOoGi80O9F3i5TNFnTztXHkwdVedDuOXExgdSgQHWxRjmc6INhqDvXlRa9mo1AiVHHgjTihORIEOW4zpRls+OSAmJ0GWOAwzzKgeTvfLg+u7oJYuZLJBVHmcFL+BVrnPod+uc2EZ2+MYxVEIrrphFuYxIiGaVbv78KTMa24hdtN6u416QZW07jiIA1r/m8S8RWvsZwQGY4LUeZaI+H9HJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RR8wOp948mDPqPY6f4GsNJmB1ROnnfpH5TlfF86gxK0=;
 b=eDbgA1Dgrh1Cfq1Jd4iNtVV31bGjmwhtn7DQFtL0FES/9gD8l+OiQxWXP50TAI4qCBGGybGscmDhCLIL+v4i7tvcTeFZvR5G3TqT2Qcvw08FoKVCMUEt7sU1CYM5qeJP5H4qFb06o5BItnu8KPF/z3wmiks+XN+YgNM4vwnsP82Ev0OeJaHRp9HbWg/Lx53VmbjT8tdYFEPZcCacpLM0hLzDBF0BG2t+G/3Ti91nAbMwZC/2AGcxxfsng7eDtBeW6jIECPhqz9S2io3k079X6Sdcbemgqi/iCTekmb4RjkD6ANfvbQejjtvY00J4GTRArJcxxgv10FHIzJscMFWEBw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB5721.namprd12.prod.outlook.com
 (2603:10b6:8:5c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 13:28:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 13:28:45 +0000
Date: Tue, 17 Nov 2026 09:28:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
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
Message-ID: <20261117132843.GH2245175@nvidia.com>
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <53ab900a-8a6d-49e8-ac69-3b2d1130b2db@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ab900a-8a6d-49e8-ac69-3b2d1130b2db@amd.com>
X-ClientProxiedBy: BLAPR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:208:329::30) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB5721:EE_
X-MS-Office365-Filtering-Correlation-Id: 72d60821-b0ae-4d55-c414-08df44aeb441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|22082099003|18002099003|11063799006|56012099006|4143699003|261026121527099003|261026140227099003|261102123227099003|261022105027099003|261021135927099003|261022075727099003|261021121427099003|261028144727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	6oSakKuDG4uOlMUM6cxDtbqz12MeJMm3q3yAVrNs75f4tG3ebC4R8LBX/psMH19jtA84OeDTx39CE4hox6I83JXrE0fPAMaI2y+ADVg+kjYbZkscg4HIkcucgCYcLiaijJMjwGTPvDeSQ0wqfkg3N7+M3enebpC9ZXm30hYoj3mDD/wIQcTMvLK/w+05YpgTlqrft/aeBCBOiD8FBKXxhXRwETy6HrgCE7x1e+OJcPGummWqsyVfGq51+wnJGa9cnoQnHoKUSDfm8B4XjHatoZ/IAkDbFa6dKj/4lx/gSok+KnqtFZ+/gmnmhMJoiYXrvBPcPC6wCnn02VbAEot4aiYr/s7ME9EWptGqPjRJDxDmNwQdL1d3+lN1KrO0AOD+G26nbLeD4Hm5DAAeHFqvOHl7a7cVtazOVtnhTRiW54b5x5dRW73tOnyTLjDx1b39vHY1s5pAJvvxVZVn+1N/HiknUnWE4uf/S6VvNsSbuhvtY4LvI7shHqbij2rN/KfIEMaxXft74jFQF88hIjkm2yMxQIEbXv+mzPoM2fgXlv7+eiedVSA62vnP9KhFuKRRHW7xHHoJrcx4PaAxrIilxi2PIp310dfycTgaBQ2G4CiR8r/w57utyf6i29D9dQCS2efGJNY7ThuBTbfBb5kv5aUHO4fkFK6K1r2hYzrOBAU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(261026121527099003)(261026140227099003)(261102123227099003)(261022105027099003)(261021135927099003)(261022075727099003)(261021121427099003)(261028144727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aOKibP2s72LQUhpZfPzhrXaZpfn8j57AYHlaiBrWn1hUzYw1/RoqEqzG0DWS?=
 =?us-ascii?Q?Wfeto+jt54Wsj8Hm7bg7AW+FBBmFArLAIcuxsIFMNisP3VkU8HWxQo7+ExtO?=
 =?us-ascii?Q?ecTVA95Ndj4gPMytow/AVSyD9sXVpgrVWP5txlD+I/d1IROqWUDG2+s4tJoT?=
 =?us-ascii?Q?uABGwFGgGIqSVsOJODf8Rer2jKuAG7BfPhfpn+4plaBd8/nuy4LwW7ngzHl+?=
 =?us-ascii?Q?a68XqngbX08Q6JMEPLO3lWnVTiUjzxGMRX5d+FFNFp0qXzJMhRjoVwPeTlGV?=
 =?us-ascii?Q?9bGNqjTy+/BEwUJFUbI7TrOBuRKMOmM/eP7su47JQIS4WRZuFXHO4BXXfbX1?=
 =?us-ascii?Q?TcMyFTjjSi9SPk69OHBF3eizBTuBFYwPMG5SgPeNJw35jgBdI3POL+jK72pu?=
 =?us-ascii?Q?fAFUYj/oTwKIxebel95BRO8CEMv4xKrFLv1hRGA6Tw8APdq9esqgwelfq8j8?=
 =?us-ascii?Q?9kfnK9ZT9+OqayV0SoQPQCNdxYUZxrhRrFAnFEebWssb93m7DRoSzJpWe26P?=
 =?us-ascii?Q?Va6oc97zfLSfi52GkLMhF8F5BvardmYTqTu7pvncPr4R6OlRYwygRY9IRlUG?=
 =?us-ascii?Q?Svbjruc2wKwSlRJBZ4Wo9VFeD5K6J0j6jncGPzts4xUgOYpNO9oCsiXwQJxk?=
 =?us-ascii?Q?YYDxy1NwC2VQmVynbsw0W7dz06vlylmRSn8yVgouB+kNBUEnhacChfhqu+ml?=
 =?us-ascii?Q?p8fqeEqCoNvgKQIIpzlQOQgX+UrXWnVemD/zCLtnKZAa43NeGdb/ZT5T3Cxw?=
 =?us-ascii?Q?cOTpPi+9dIzjqhg/hzIF18TbtwU4mRzagD5JLtNU05olAJvhOu76gkbYh/3i?=
 =?us-ascii?Q?+KNlmkLbohnqbss1Q/L22u4e9JWMpYl9pUgpUdJm2mGgMO778G1noqguGzx7?=
 =?us-ascii?Q?2SLQzLXUlAF2ixSayQESVcE0bJNkh7NZL3kw2ZOvYClTcUGlTT6FVLwZQ82r?=
 =?us-ascii?Q?XCVB5WDsBVfdZwA6ssVmMhK3XHuliujLst17hhiew+//EkSVILSgL/pQ7vZc?=
 =?us-ascii?Q?4qXdVUIubJCBfErHjVPqkSi8Mqi0hefG8K3pl+nbYBUUYpndaG4JD6is/ae+?=
 =?us-ascii?Q?3z0sLAWA6MzhAs3IjGE/+0uQfGv3OzO9tZPw2JgI5oLfQh/DnXANLy9v8O2C?=
 =?us-ascii?Q?iWSlEQbFFRHRR5MTfdzIt6f1B/VxMDz9uTVqU6LrB5ANz0sVi4H5RpN0ZMmj?=
 =?us-ascii?Q?HznzGi4b4Q0mPWwVdsQqo3V+c8qsX4ZFyzIWTGuKo7oTetvQ9y1vS46JK6aZ?=
 =?us-ascii?Q?q2zpuXwF3NDiJOXacG7fi7nSTNV09UzEmJ1s4Fo0NWhwJLfBWpqBznrtYeN+?=
 =?us-ascii?Q?XeyQqCXbedT0VEndMKU29G1aw6VRKiYwKgrMsomeIIjA/j+jR5sj97ZrN51x?=
 =?us-ascii?Q?BCJwZLTKtQgUU3pYvxnmEozkDviQO4/cIyz3z5UYpkLDsyWOnxRhM/6t6Htl?=
 =?us-ascii?Q?phjdB2/DOuRzkkqV2G/iM7kCQjWHcp182uNZmPO9TOlL8NgknDGPJ3U7gkMb?=
 =?us-ascii?Q?oG8o6aMNzpfxA3AO9snEoj1KU48Om0D3bdALcug1Zxi/LC668wF87Nu/8qZS?=
 =?us-ascii?Q?llQnfmoAlfyabfgTlsR5jkGGYXZwktN7l4hGEmOHjR4v5b3jy880wFg+iAj+?=
 =?us-ascii?Q?3scG1uZ4XpM90LuUODgpC5umvuWS81STqn6O9DbzJ80CvvrXaLsrkEYlkQH+?=
 =?us-ascii?Q?nNicgekJAfm2kl9MBGBxkVM+swArDnVdDASFBDQJ3F4ZZ8kT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d60821-b0ae-4d55-c414-08df44aeb441
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 13:28:45.0721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcC5XCNAF61K/hxQFR6xB/LJytYbp5UoeFYiWLiZUz95L1QhRUpicbaNMdl6w3og
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5721

On Tue, Nov 17, 2026 at 10:17:14PM +1100, Alexey Kardashevskiy wrote:

> > Userspace gets to see KEY_EXCHANGE which means the verifier can prove
> > the certificate binding, this is the ONLY way to let the verifier do
> > this proof if it wants.
> 
> Say, the guest userspace can see the certificate chain and the
> measurements signed with the key from slotidX used for the
> session. The PSP promised it is the same slotid. Which part does
> this verifier not trust?

In 1.2 there is only one device public key so all PSP knows is that
the public key that signed the key exchange is the same public key
that signed the measurement. It doesn't know what certificate chains
are actually in the HW for the same reasons nobody else knows.

Further, from a verifier perspective we don't have any crypto evidence
that the PSP was involved in this process, and we don't have any
crypto evidence that the certificate chain was bound to the device. It
is not optimal.

> > Further with capture we have a nice primitive to pause and do slot
> > selection before going to KEY_EXCHANGE. If we know the kernel has
> > capture then the ideal FW design for 1.3 multikey is much simpler and
> > clearer (more like ARM).
> 
> No CHALLENGE, then we read digests and certificates before
> KEY_EXHANGE so the digests won't come signed and you stated before
> you wanted them signed. I am confused.

Without challenge you can get a weaker version of signing by fetching
GET_DIGESTS again after KEY_EXCHANGE inside the encrypted session. If
it is the same as the plaintext fetch then succeed KEY_EXCHANGE.

At least in 1.2 there is only one key and slot slection doesn't effect
it. So you end up with the 2nd GET_DIGESTS indirectly signed because
it is in the symmetric stream.

This is inferior to CHALLENGE or 1.3 multikey since there is no
evidence of GET_DIGESTS binding in the transcript, but as part of a
compatibility option so 1.2 can have the same flow as 1.3 it would be
helpful.

> > 1) The uAPI presents a transcript interface, every message and reply
> >     individually presented to userspace. Perfectly future extensible to
> >     include GET_DIGESTS with 1.3 and whatever else comes down the road.
> >     These are consistent spec defined message blobs 100% the same for
> >     every single SPDM implementation and TSM.
> >     The kernel will start with a partial transcript, but the API
> >     can carry a full one as we improve with no uAPI change.
> >     The guest will see partial transcript until/if vmm/guest changes
> >     are made
> > 
> > 2) The uAPI presents the x509 certificate chains in a consistent spec
> >     defined way that userspace can hash back to GET_DIGESTS
> > 
> > 3) The uAPI presents the signed measurement result and tdisp in
> >     a consistent spec defined way
> > 
> > 4) We have the four step
> >        Start
> >        Get certificate
> >        Finish using slot
> 
> I am trying to think of a simple DEV_CONNECT modification.

You'll have to do the full picture to support 1.3, I don't see a
reason to do a half job right now. See my answer to Aneesh.

> Then, if the userspace wanted another slotid - run
> DEV_CONNECT(slotidY). Slow but simple.

Oh? Since you setup IDE during DEV_CONNECT I'm surprised you can tear
it down and reconnect it? I thought there were significant spec issues
with resetting IDE?

Anyhow, assuming this somehow works for you and interoperates with
other devices, userspace would have to do it and you won't be able to
present the same interface as better drivers. Start -> Finish has to
be under a single SPDM session protected by one signed transcript. You
can't split it into two sessions and still have things make any sense
from an API perspective.

> The AI tells me we cannot change the slot in SPDM (1.2 or 1.3) after
> KEY_EXCHANGE which means restarting the SPDM session so we cannot
> just change the key on the go, right?

The slot isn't used in 1.2 once the connection is up. I guess this is
correct in the sense you can't change the key being used, but in 1.3
you can get the measurement signed by different slots and thus keys.

But without establishing a GET_DIGESTS binding this is not a good
idea. Part of the reason we want to ensure the verifier sees the
GET_DIGEST binding is so we could use a different slot for
GET_MEASUREMENTS and the verifier can tell the cert chain is still
bound to the connection. Especially for auditing after booting when we
can no longer trust that the OS is not lying.

> >        Accept
> 
> I keep missing the point of doing this on the host (in the TDISP or
> CMA case). The host "accepts" a PF by enabling IOMMU for that PF,
> not the PSP's (==TSM) job.

This is the standard SPDM flow. You do all the measurements then you
ack back to the kernel that they are OK so can it should proceed to
the next security step.

For IDE I can't think of any strong reason why it *has* to be setup
after accept, but since other CPUs have split things up then they
should get the right flow. Not doing IDE setup during accept means you
are committed to and stuck in IDE mode during finish, which is not
really the intended API design. See above.

However for something like NVMe OPAL key release we *must* have accept
and it *must* gate sending the media decryption keys. Pretty much
every other use of SPDM will have some step that follows accept that
we don't want to happen before.

Remember this is intended to be a general interface for all SPDM use
cases in the kernel.

> >     Except for Intel all the guest defined digests can be calculated
> >     from the common spec messages. Well, maybe AMD has an issue, their
> >     spec is too vauge to tell exactly what bytes are digested.
> 
> True, I asked for some clarifications there recently, the new SEV
> TIO spec update is on its way. Thanks,

Hopefully they choose to digest the right things :\

Jason
