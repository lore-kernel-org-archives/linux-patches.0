Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793277706;
	b=Jra3bN9sXbwo/wEZbJNBO1IuEDw11m0gwakb9I03rLgJEl+uVw9K8schMSylcJ3mb8TR
	 WvkuyBcFeqfKI60f/yXHakQTGJerJKJXBWJmYBlIgvefTuOUh2zftSEAA59zveuH/x5w4
	 fn1+pNAxOfiMW5p0/lTePNHo4VCmKKmeUv+tMTmh47jgdJXTYWr/NQZKlH7DTtdW/lTST
	 oxCUhUdXYNdaDCZB+mCSerxl10WvyT3b4tjMPTz5j3+ePj1DnzkTT4Nmienmm4GRMrz1H
	 eYiFg0z6pGgWY403ikEsc3z+4UT7aaM0w1Lzq5kH6K20eaYSjCW3BmvxfWYli6aXvtA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793277706;
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
	bh=b8QmlNLBeDcg8Kp/Ovo0Oj+5LA3wZO0luEv7R7PSwv8=;
	b=UwIotW5f2KmQKVtN2U0hTBuuJbGCpjfhF0DcCOR+x5Ayp6sNEBMXIt1xLa74dh7VKWex
	 A7GC98Lyvj6ma+C70IpieRpWjRndgTwxBKsV2XrFsXFTQ45mg6sHSHia3E/RAgfoyg6Vo
	 qNd6f/ErgMgxvoIJZmN3rSlR+3DtspCGd4UENBuNrnLfVYqgGOGxWHYLqufvFL5rnkoir
	 bqGG/ei3XIv8aXvaTy8VQjoMUYeeB6Y3q+CxWoVd19JkqG1RKJ03/uBIxLhPVIwQQ9rP5
	 YqeDZ+tqNxWoAwI7SJXaPtHA6sJ5N08p5HIFoftRn8BbcQYndrhJGv6laeaWOvFiULA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hWTv4y9Z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.45
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2773F606A31C
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 12:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2773F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hWTv4y9Z
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VH0/g9Da7q4+GV7fKuePQjOhritkHFwubja0zwf75+u4l+78kJ208jOnyCE0t3qtCWjaXf0HvCyl6nTKdUQL+h+PhK5yDjPOb+8+i5Zz8UGzyNU8MB2YPfm+5mHErQ7HFRrw/NvKQbl1J3ef8tVdVpANRZaH8aYND2MGgxSl23iQhdeWYxmtG7WhY0XhSkC6R7p1xu1YBGIdH5y1oUXfrvv1riBUu04m2yYACOTLKpUdyJ76K0/g/X84dVwV4vjGPwlmgZYkJaEQy33fuGQfrFml/+bXANx4rWaI4JsDMJDd8qUPjFoi0QmW2caDhjZdx1HZJmnP4IBmiHEsHczBLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8QmlNLBeDcg8Kp/Ovo0Oj+5LA3wZO0luEv7R7PSwv8=;
 b=wKgJhh9q9ywNiYnxYPl94Tw8OBh5ilfz7IVFGNph6F/fxIxLIddsMoUw7EuHkeTncwO7DqagEgXiJJT85SBKMguz2J13DCrsShYOrZs9P2elTpb9ALJD2E612iUFKvXkxedpkWhfQmel4JCZ+Q/A9Hw4OCN+HbyoZrgepi4D+gQ4E/0GzpkRzdhBwuRUT88MijbbT81rx4HLC24jCd+8iFjHV+mJ2sabZ9iMaEuPUyBjo1yAW1VYh3IXkLJtBL1j1auPw2WbIYQ7sg7qPAnLWFgTuvu6AjYlZtcGhay9zHBMzc7plfwM/ZqndoaiRxXrXQBg2QORB6VUMnVUTgrwzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8QmlNLBeDcg8Kp/Ovo0Oj+5LA3wZO0luEv7R7PSwv8=;
 b=hWTv4y9Z5WQkUyioShHWGDq9OxB11Jp5IwNUFnmsrxVmqC0qiKcspobrsX6uuj0ggFV8z9z+21uOxmzTYAIL655758MZ3+VRXLsxd/5t2mBun+BtC+Hnb+BCcm6iK7IcV/fygvtpWlvvcOlBms2eb/n0etUWGqV8rJm9N0/zm+dtQ0VbwraUhzN9eIbffDnixbxOE7j1u7rnyAUO2EBuog4KUpwC4imvosPGL0KuHoYVV7qPY9exrjDiFOd8lq7HTF9l33jC32g8HWCvOfe48nVhAJVXWZsdyay+h9sej73k7agxN8FGeZN16SQLN226GsIXlqMrZis48texG08UIg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV2PR12MB6013.namprd12.prod.outlook.com
 (2603:10b6:408:171::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 12:41:38 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.007; Thu, 29 Oct 2026
 12:41:38 +0000
Date: Thu, 29 Oct 2026 09:41:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-coco@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
	Kevin Tian <kevin.tian@intel.com>,
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
Subject: Re: [RFC PATCH v1 08/11] PCI/TSM: Bind CTLV attestation to connected
 and locked contexts
Message-ID: <20261029124136.GE3040767@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-9-aneesh.kumar@kernel.org>
 <9ff72d51-3933-4f2e-a854-c0f9695c0c04@intel.com>
 <yq5ajyn1axb8.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5ajyn1axb8.fsf@kernel.org>
X-ClientProxiedBy: YT4PR01CA0416.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::15) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV2PR12MB6013:EE_
X-MS-Office365-Filtering-Correlation-Id: 238e5b20-7b79-44bc-3a9a-08df35b9f8e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|261028144727099003|11063799006|4143699003|56012099006|261009223027099003|261026140227099003|261026121527099003|261021121427099003|261022105027099003|10067099003|261022075727099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	6jiq933u2KHDKisjmdJUvd9npDAiteYeSdzcSUZ903tQ0Rbx+LO8wTzrqvgnb5ysqVPndru24IUccZ8GOcB4FJsFgfMR9Dv/HrqaPbdl53raAEmGSTGGMTeouYZDR7Xk/8k4mXcHkiA6iwrTccMwmOneJrbrYZDdi2Fliu6ifpgCI+oQ+7JMVYgQhcW83bPgqq6PCvKHenkVHqSeX04MiGO5rC+5vxV9fYX6bWt+Gp/mWgVc3Em+i0DvRwGZy3Gpnhtj62SLs6hnvBtSjUj818FoUWOP1zXm87VTqC+retTimV82aKaNq7R8bRWJUYDJ3VX2ZKMYAFnw5cTWKmZs+9/80E05ISMKIGmMyZtJdg/8V3T5vSwk9BX2NlNrHffZZGMIZgwiArafgeu0iwL7uhy0PUgu/oPf6cDQLSnDGPKphgdmapK3+a7CGFYKnBL+u5Bx9JzwtM2GrPRQbWeeot0p9FphXgCmUqXK/nItU6MUjl3ZUxARALLzoQDos8KoHlWHbW6fbDBTBHUX5K6x154utTOvrRBN3SseZX73BO3WsX8ejS0lm3IgTm2W38xMeQIhXUIPxNDZ/BXECDmYoKQgAM24BxYt83cRzNUwDKIXiyVcqtZfFR6ZuVsndy4v52a9KPaXFlst/oTPaIe12tpudux/+JwTcPKr3pB2Wdk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(261028144727099003)(11063799006)(4143699003)(56012099006)(261009223027099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022105027099003)(10067099003)(261022075727099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/ZAgXwDP+nc/7E5yk+ghWUOO9OYkzel9pZgeE9yCec67SUUmENtdmkEB9pSA?=
 =?us-ascii?Q?hOYo1aROITSJGqBdZsBOR0qkUtJp0IUUImPqcc6TkynmiSzBhabzXA0gmK2Q?=
 =?us-ascii?Q?a4KDfMipPLpj/Tl2gD8qlNfVIjfd6kQdOuMbHZrevzJzqJGtw8ZlAIAzfoE/?=
 =?us-ascii?Q?+Yhm06BlvGAOGBBKek2LKtG+tnQkbsArLxGehXb+P2Z+Vu6xmkK+BB3JZ0uU?=
 =?us-ascii?Q?xXejKTEjMLZOMpn4hvIPbASsaTM42/15WtL1VWeY16p2GZXvc5wxYt+eN22D?=
 =?us-ascii?Q?biNs7DadlXOiTbtX1QhGmHsHcPXhr3f/cRFKkUorc5IG01EaDA1/D61SKLyV?=
 =?us-ascii?Q?UqcIYnz2r0aR3eGoaDyXTfYNiweuVDJ/jxj3a6MZXZEK5p4RrE6Mc7T3IcgJ?=
 =?us-ascii?Q?UGu4lkw6bBOLVhCae0BWKqtdOdX2oNG/ITAa+8Bpc6yJQmzM9r3AdpsjPxtF?=
 =?us-ascii?Q?zIqCJhPLRVTYxeP/ZXeQspZP3BHzE0C0FZ2j6s2AjKY+OZIe4r5A/W307UNT?=
 =?us-ascii?Q?wi2xSwZ+opw8tJoiXQsNJscvttHcfox9w5EaYRRfKUy/ga6n1mjJFoT+Bf2z?=
 =?us-ascii?Q?86PZsnAV2ZdRl+E1nVfVEn5Apv8Myr6jY+WzMjruFodDrvxBa0ky4FoYVXhS?=
 =?us-ascii?Q?yk7+hiaceSuK9dkO5JZtLWx9XynvTz98YjDeQsBeLboYQr6ypovn9gbpMqJ/?=
 =?us-ascii?Q?/v7WSM4pYGNDAET/o98FLifrud+fiG1v3ctu4uJYYplFi+TfC++2pANgBGyC?=
 =?us-ascii?Q?i6iZ1ObBVU4+HvR/71YN7BZvOCfFQY7sm3bMOUz1JKuvAnBT+kHylY+VCNsl?=
 =?us-ascii?Q?BxAmmMVt9SxwlrhnuHkprHgs+8u1edA9bcqWccuPZP22qlwHkJ3CJcEh7q3q?=
 =?us-ascii?Q?oHQGqPABe34x9GIHd/uWitDRJB6L//gfW+bh61VlnPfNH27/FHnCj3rLdWQi?=
 =?us-ascii?Q?s+2KQzZ72B4mmq4U7z8H3bq3NCxCSkU3bmoYHo7pPy6oVVWprKIlPtHoAA5Y?=
 =?us-ascii?Q?GLqVDknqwde3HpSmCNfVMUA9Fq/JS+HJ8ytQWiZ29TP36GDul6js0nWVKwEz?=
 =?us-ascii?Q?8uOKyjv0/dVlm9tG4iYXsLohNEAYByxXjlAwt9MLSZ8AVECKaPRYN4mfEzrr?=
 =?us-ascii?Q?7m8NmcqqVf2B09iUaSQb6hMb6Z9Js6i1+JJ6vI7bZPQW1LkDHrL4HCs1vzIk?=
 =?us-ascii?Q?0YPeNkyTqQWF3oYzdY7gigEfUammg2zzUlw/N7GIy3M0vey89xduDDFjkntg?=
 =?us-ascii?Q?XGHaVS04SkuKIv0xl2tPkdVcbMQr6f9SlxCthTCLKL7KYfuY6yIRmiOEKBGP?=
 =?us-ascii?Q?cQgPaEKu1/S1Opj2y1C18vpUtDTl4lhkgUyipJ+cG1zuKDCaMKhCasZB57r5?=
 =?us-ascii?Q?81cmVl787ce1OoaKpsKA9TAArmDsjei7hie8GCDHy06kK9u1zw/L2SvLzSCe?=
 =?us-ascii?Q?Cp3sRO9mcuoGTFM+7qWmtJipHZC0yoVjF8BPyhsKpK5PPD1c745GwW+IFU5c?=
 =?us-ascii?Q?cHUjmQVjlvYg2YrYAhFTvftIerWhFopjb1SJJiYA6QkoaPfXRCsh7XjvfAiZ?=
 =?us-ascii?Q?APMtkx4JCfD8KYfvQ/yPn6Y+MCkoiUJIxr7gEZRrG3rwnaieX+kyTc4xbIZ+?=
 =?us-ascii?Q?tuPTXAgZ07CwajsvXl1OW+inBKBZuZ/fEUJN7M7MsRBPN3u5tFhDyWS80Ogz?=
 =?us-ascii?Q?WLGeRR/sE1bKWa2t85YT2fPZR4strJt8TtNC+qwgyjTaZPWj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238e5b20-7b79-44bc-3a9a-08df35b9f8e3
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 12:41:37.1407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /JBZoy12hfRC3DeOyHsOpOYx0NluZkZeNAlLUTkReEB1aAyMRa6Av6WhP4R2LIiv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6013

On Thu, Oct 29, 2026 at 11:00:03AM +0530, Aneesh Kumar K.V wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
> 
> > On 10/28/26 8:26 AM, Aneesh Kumar K.V (Arm) wrote:
> >
> 
>  [ ... 232 lines skipped ... ] 
> 
> >> +	ops = tsm->tsm_dev->pci_ops;
> >> +	if (!ops->refresh_evidence)
> >> +		return -EOPNOTSUPP;
> >> +
> >> +	ret = ops->refresh_evidence(tsm, type, 0, (void *)challenge, length);
> >> +	/* Even a failed refresh may have changed device state. Retire all verdicts. */
> >> +	if (ret)
> >> +		tsm->error = true;
> >
> > Does this make any refresh failure fatal until unlock? The CCA refresh
> > in 11/11 says "failure preserve the old cache", but with tsm->error
> > set I don't think the cache can be read or accepted?
> 
> Yes. The generic layer treats an evidence refresh failure as fatal. The
> backend can decide how to present that failure.

The locked generation scheme should fully protect against any desync
issues though? Do we need to care here?

I also continue to dislike the use of the word 'cached' here, why is
this like this? If someone wants evidence they should get the fresh
evidence with their nonce returned. I can understand hanging on to
certificates and other unsigned data but then what would even trigger
a refresh of that? Something you can't refresh isn't a cache, it is
just the immutable data.

Needs some more explanation I suppose, or maybe I haven't found the
explanation yet.

> > The cached evidence is still the lock's evidence, collected after the
> > lock. And per the cover letter a failed refresh already invalidates
> > the earlier generations. Should the backend decide instead, and set
> > tsm->error itself when it can't tell what happened to the device?
> 
> For the CCA backend, evidence is replaced only after successful
> validation. If validation fails, the cached evidence remains unchanged.
> However, we could instead discard the existing evidence cache when a
> refresh starts.

What validation?

> > Also, this builds on struct pci_tsm_evidence from Dan's March posting
> > [1]. The TDX guest RFC [2] and AMD's SEV-TIO guest RFC [3] both use
> > device_evidence_create() from his July posting [4]. Is the plan to go
> > with pci_tsm_evidence and drop device_evidence? Would help to know
> > which one to build the TDX guest side on.
> >
> > [1] https://lore.kernel.org/all/20260303000207.1836586-1-dan.j.williams@intel.com/
> > [2] https://lore.kernel.org/all/20260924041032.1096569-1-zhenzhong.duan@intel.com/
> > [3] https://lore.kernel.org/all/20260916115159.1938195-16-aik@amd.com/
> > [4] https://lore.kernel.org/all/20260705220819.2472765-1-djbw@kernel.org/
> >
> 
> The include/linux/attestation.h do cover
> 
> enum attestation_device_trust_state {
> 	ATTESTATION_DEVICE_TRUST_UNSET =
> 		CTLV_ATTESTATION_DEVICE_TRUST_STATE_UNSET,
> 	ATTESTATION_DEVICE_TRUST_NONE =
> 		CTLV_ATTESTATION_DEVICE_TRUST_STATE_NONE,
> 	ATTESTATION_DEVICE_TRUST_ADVERSARY =
> 		CTLV_ATTESTATION_DEVICE_TRUST_STATE_ADVERSARY,
> 	ATTESTATION_DEVICE_TRUST_AUTO =
> 		CTLV_ATTESTATION_DEVICE_TRUST_STATE_AUTO,
> 	ATTESTATION_DEVICE_TRUST_TCB = CTLV_ATTESTATION_DEVICE_TRUST_STATE_TCB,
> };
> 
> I am still unclear how this will interact with generic device trust. We
> can only determine that after reviewing the device trust series.

I don't know why attestation subsystem would have an opinion or
interfaces for device trust?

Jason
