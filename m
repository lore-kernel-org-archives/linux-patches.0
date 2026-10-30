Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793374399;
	b=ci7DFgIZ76ehk8+q59L+qP9QHRAxifsX4yK00dIHt7pfk6Z4U9/dawgDuJDvzvWj0f9X
	 aKp3xMr0/7IL3YtvBomxOSSHuJa/7Dy8u/CVj8zUT9E/mswAK6hLYJ2RBBeteLAAJN0tw
	 jMR7jRyFudgEFVqyQRRm8dhTu1feDGUR7Qd/XHz7AT4a4iVJPUWy7aheBw195hK8bFM76
	 PpagotX7AbtqatL2zjh/bvW5tMHFm7gwFpf9Uym4NUYBlNonzWOaQKxomYilKZhna/0Xs
	 8gcqQy63d37eCO7EvRDKBzePCUTQ6TN6TVmpdLeyvSUVskpzjORpxmTSn450OLfpNfQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793374399;
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
	bh=xA66QDN6hxciJOqw1T/rgyGTADymWuEf+N0YENuyPCw=;
	b=qwEKDjCZcqcwagj86+4ZnUWEiLat2+RsUM8z83Q4eGDRj0Bm9GqLPetPj8v8PsghOBFq
	 YmwwSizEqrGSgDaD9SSJGU70M4aYoTYqM9juTM6caLAVDNeSQfLrnuWdQ5zJiZLQTTjis
	 +1G+3WhWdKi3y7pnRylXxik8BXNqbTj9oZt+hePYjqsQarZDl5wTsGHfymck8+829EPsV
	 xkU/YKlMDM7GfTW/nBe5AFjfmEBW3OlChEixo5Ssdlcnu3cKx6RrOtQ9YsvD5ghmdPwsw
	 hCUulXMHAX9TyiEIF6s9jSuaxxjTDp1KMlBQNkw6YW38t44jNLZFH2mommeG86EiOLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AehqpuPO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.55
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013055.outbound.protection.outlook.com [40.93.201.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF88C606A31A;
	Fri, 30 Oct 2026 15:33:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF88C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AehqpuPO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bF9jI2U9pCZFMmSzitOCFTpc2irOgR91bM7ZiM308dgSztJ9D7ZLptiReUulfkzIwxqAHB7auIrzqxvNbV/RcqT46aeOGPuqKoTNc4BNGPvs7Si4ur40GtDCI7DjVecUl5ffwMoZfK8Z/RDCAXMnwX3j5jGj8o0n5GlYq+B1w5kF+q2uhZpdxkTo3t+QwF3ebUF5AV07maKL3T7kgAFT+BtOKAB9NWA9hHg2jzqDtLcZrK5TT0iBrOw8j6FVGGvhvSmw4u2YzlTuFz+Qrv4qm7++Xdn7wV3vq1ENur7pY2PFd1HdRHkJghv00S3M20Ctm0nKVCg+ONYkoI+rhEo2Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xA66QDN6hxciJOqw1T/rgyGTADymWuEf+N0YENuyPCw=;
 b=C4vDJYyLdUfJF2+QF6CM9KZyKZKbPJ2R1gTuDaRSpxIQ/sp4+FMgvz3pSz7rY85m75ejrwvoRyWiZNLtpEsVF50GYR94lg8zQLEpWfkzz6CDKdoa4schOkVx4vFDJup4lZgIJkhNf0LsrebV2NjVxIvstxHRm9kvn5AsODnKru80O1fkSOVPFD158wNfWalxGG33OXf3jZDAw3Joq727C+91BuCUotfy8xo+d+kBfluOqS5fhfWBx3BNTiXarKkSety2oqNzocZusT1VQOActfX6iTlnBF+Fon438t/sZqgVzm0kUtXn9PjPZ2N7FWaAuddmz/36+AZcMajQ7WMMHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xA66QDN6hxciJOqw1T/rgyGTADymWuEf+N0YENuyPCw=;
 b=AehqpuPO/rBJSMad8u4DJwIi9mc0dukqUIT8zTKe3EyBQLdFH94v778Ghh3T7xkrssburCvkreCkdNSLHyPpyg3B8glTEtHNGmvxDWj07QGLRY7LY8aDa1PYT2YYLe9EO3zfcC16Y5/bOaG1gS+XnrDmvGPld1WvWrXxiFcefW4Wz29JX70G+ldP0VpJGFplPXy8HibxCjFWZyNzm5sY25E7r009ofgihbRjiuraNTg9Kr8sa49T8ozqsDHzv+kW0ezG9VqY2H8CGBvLQO2hqLpxtpvo853f0dM/zOb2goAnWtqpDzEPuFMAx+/5X5Y3VKbRjhyBrxv6I3tCEynxfg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB9453.namprd12.prod.outlook.com
 (2603:10b6:610:1c9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 15:32:56 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 15:32:56 +0000
Date: Fri, 30 Oct 2026 12:32:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>,
	Kevin Tian <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
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
Subject: Re: [RFC PATCH v1 00/11] PCI/TSM: Add CTLV attestation
Message-ID: <20261030153255.GK3734323@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <auSO1IDQ8iN6wHVv@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auSO1IDQ8iN6wHVv@yilunxu-OptiPlex-7050>
X-ClientProxiedBy: YT4PR01CA0421.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::23) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB9453:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d6f4956-6091-43f2-5287-08df369b125f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|10067099003|22082099003|18002099003|56012099006|11063799006|4143699003|261028144727099003|261026121527099003|261026140227099003|261026130827099003|261022075727099003|261022115727099003|261022105027099003|261021135927099003|261021130227099003|261022113327099003|261021123027099003|261021121427099003|261009221227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	wDi1qvOykFJVgi0ga7yGo/4MIbGPctl0vgIMmAJsBNAnZaPYzo9M3GxMw3U/FK9NhXuhmEw6goNsuZDyQHr+EbHY51NR1O6oPajncJE4HO2jAKE2GV06JpJOziwQ46UInLRbX5OripVJSxAED60GYNO3Jgs+bXfsHAqZTdkaFsOrVmhVZgR30jaYPgYxnZkZxa4/xJQd7qxrqBOWa35TAvkpI9axlxVji4GW4809SvMTpHnGvPSopArQmk8ZZNGu+w0yjRwu1xqAgDHa7SQWqYnHfRygtoAcYjE82jNDmdwxBuhrMj46YQmS+QKTMJXpLu4ArLDmNql9+lg9zcs7kWSG8Xk2o5cuzoZLIFupNdVhDERzlGyS+2XbH+SuxOLoPAE3kC0KWwlR7q6XBT3L3SL0l0yuwEURhQ/DfYlFNjwSgr9YhkEPrJ7o423Q3BDOx3Zcdd4WfzUH6ka1XpedKoTUsL1fYWtXIEyLdgUzBpB3zBstU6MRf0YM2NfN3X/6Rd+EjgkDLsipv0xHoDkYLHl0yRp8LxW6AO7tixu5kr64mXtfsZ1vpaehAtH9CVcv++3Zd1WOcWir2TYjTWudaY+hzEFyUBzaV556nuWro1HGV3QpQmckNa3c9+x8D5t82DqlFm0lgvznoI5HnWAtePDzLU9N1+begGcSgyi2wDY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(261028144727099003)(261026121527099003)(261026140227099003)(261026130827099003)(261022075727099003)(261022115727099003)(261022105027099003)(261021135927099003)(261021130227099003)(261022113327099003)(261021123027099003)(261021121427099003)(261009221227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ytjJsOB3deXmqk/+cE3lFCc0Gu50TGXAZcbCVoqC7pcGP7fptsOLTNgYrYq+?=
 =?us-ascii?Q?tHaqRKuEKTR0BBZ6CasaTokBq8GdbohYom3aBpbe+4HCqd0VHbsADgWZARJy?=
 =?us-ascii?Q?OxSxOqsCneaqg4WsxwepgjlwqATZ3NiD7M4St1h3gqMUjNlo8SYvmk7QPgNs?=
 =?us-ascii?Q?7hMa6v4DXbpo2aJGoyHxDGBCdEWkm7TYtytTfLmNlAvT0+uXmSij4dPTXQzl?=
 =?us-ascii?Q?1Wn3JzrNTAnZ6wgnd9Biw7vF++RL25H3BOuPT8ZoEPxJdrUeU6mjlHnwYokA?=
 =?us-ascii?Q?gWNVwu7h3tERFE1xKWNG7khK07TR8MmTEGeQp9zNPrzCAZGhyPwkxg0ErGJD?=
 =?us-ascii?Q?fLpbglSJSJNk9V6lKfGUsCQ6vz4LLj28p7WQO2QatTU/nPy3gpV4T/V1e5m7?=
 =?us-ascii?Q?OJnZQEfd6DUoQZZnrkySrUXh32DFEQz8DipCb3H15ql/JcmUlbFUasGWYUMw?=
 =?us-ascii?Q?kKYrkmKVhIZSBZW48gx2kdX1FfV3+lkTme2l0o98/MQLPYdl81S99TolwRyn?=
 =?us-ascii?Q?E6c50P4RFlQgYa/VJ20Mcg1S6sgIfxUca4HYDABJWQ2Qx+JB14K29YQ4Qv7Z?=
 =?us-ascii?Q?wE9GOSUlp/bKfDvgUvqxnPmMbvDus/sgpIxkcJ7pTwsH0sqJXfIL+7RLrz38?=
 =?us-ascii?Q?06czfTPLrlahdPZi5doT1SY9NWipmP3UFtuhQ445rEw+MPEO4Zt+dZx2yWWI?=
 =?us-ascii?Q?yjdD9LFYFSiBGqKTgK3uptKM3IbnzYwV8i4YP6QtftunnFAl2QTbd04BL1Ab?=
 =?us-ascii?Q?zxpsPHqLipjgiHPwg5+7gpwyzNf/z4fcWhoBoi1vSMMUra9d8rLcQJEJGxG/?=
 =?us-ascii?Q?2YamH/I8UicOKijh8tpqTZirMW4Mbe6wxitX4aeC3MPQjBPfMPQTsjCN5YPs?=
 =?us-ascii?Q?LJDbocRRMphS/+3kvO8R7RFrZQWgmTIbLkbouQOShQqHfcVDfEDYmIVjMitA?=
 =?us-ascii?Q?TJro+5GCdvtIoHK9ch8k4M9SYqtMQ07+F/OiZxn5mLHIUkdj8+HDMSI3YWIU?=
 =?us-ascii?Q?ij3xdNAG0J4ps+yn1otMV7xFtlbP65RoLRWt+KyaN7USJVBojJiPbEAwtWn9?=
 =?us-ascii?Q?93wPx0IbBW7K9HlyJZ3JbF8v+zzjA94QeCE286ZXXpAx1AAam+s+BRdBiDYn?=
 =?us-ascii?Q?NoVqPLPaWTlBfFQmRnbJxBJJ9n3XGAoD1oHkZLhciroxzpHCtXU2MF394U7y?=
 =?us-ascii?Q?VQktD1zDi8ucxbGNjX/Q/vT0W7aXrelqjtX24TkaCrGfSOhzP71PvrE81b89?=
 =?us-ascii?Q?cvQ/Ml7bHtFMWDm3yJFgGk0wbgFhl0fJzBmi+JOUEgn86SHZcpMz8Da6xf9K?=
 =?us-ascii?Q?GuH7Rx5F/WJJ+YmYD5n2um9B8VfuPrcIrOK16nkhQn6k+D/sHod0VrEiRMzM?=
 =?us-ascii?Q?yjV9jwdX8ZQPQ6+RMhcRjpXavMusa/WnzSz9zJeItjfiPcgbGvedMoCjZ8/j?=
 =?us-ascii?Q?knJWr6t+FDn0pPjSO7WNEWJxWZ+kc/UJuqqBCyTxWAYlkoynp5F0gL2pk+kA?=
 =?us-ascii?Q?liNoN2ZEYzBO++LwtwycCtZXNMb0nMd83gNfXV9YrEM5s1VwHgPaJW2URW5t?=
 =?us-ascii?Q?V/Yd16c2Ijn5qdhIadRlzH/HSPSKT9iDV3RQC8us2y5KM1LF9tvUDrfJ+FQ3?=
 =?us-ascii?Q?m4mIIcldpPlF0xQTrv10YYXh9OLI9AwaUarXrzXahSmcMhDc4oSpykbaKy20?=
 =?us-ascii?Q?HGf/rk1Zi7zUWca3gIt1u95hp5KvHUKRghIvU+Kgy2d/7Qk4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6f4956-6091-43f2-5287-08df369b125f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 15:32:56.6836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qo9P4sbKe0ATk9RsyxqYwf0fyVG8Uk1zsrK0ew1FnxAjSs9lSXytR9evGTVXVEEE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9453

On Fri, Oct 30, 2026 at 08:34:28PM +0800, Xu Yilun wrote:
> On Wed, Oct 28, 2026 at 08:56:07PM +0530, Aneesh Kumar K.V (Arm) wrote:
> > This series connects PCI/TSM to the common CTLV attestation interface.
> > Userspace can discover a device's evidence objects, retrieve them, and
> > accept the evidence before the kernel establishes a secure link or moves
> > a guest device into TDISP RUN. It replaces the PCI/TSM netlink evidence
> > interface while retaining connect, disconnect, lock and unlock in sysfs.
> > 
> > This series builds on the CTLV attestation series [1] and Arm CCA
> > device-assignment support. It covers PCI/TSM attestation through
> > certificate slot-zero.
> > 
> > The development tree is available at:
> > 
> >   https://gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-attestation
> > 
> > That branch also includes the follow-up Rust SPDM certificate-slot
> > discovery work, generic attestation fixes, and CTLV tooling fixes.
> > 
> > [1] https://lore.kernel.org/all/20261015145053.3664509-1-jiri@resnulli.us
> > 
> > The host flow separates identity collection from session and IDE setup:
> > 
> >   sysfs connect
> >     -> collect and cache the certificate chain
> >   DEVICE_GET / EVIDENCE_GET
> >     -> discover available objects and retrieve the chain for verification
> 
> Is it possible that these two steps combined to one? They collect, cache
> the certificates, then hand over the cache to userspace when requested. Why
> not just use one user interface to collect and hand over the certificates?

Any caching needs a careful think.. We should be caching globally in
the attestation subsystem things like certificate chains so we can do
GET_DIGESTS and then skip the GET_CERTIFICATES if we already have it..

And if we are going to do this rustspdm + TSM stuff the certificate
caching should be shared between those components too.

Other stuff is not caching, it is storing immutable data about a
single SPDM session. Like the transcript.. This needs to be properly
lifetime bound to the session itself through a session generation.

> Could the flow be:
> 
> 1. DEVICE_GET/EVIDENCE_GET
> 	-> collect and retrieve the certificates via native SPDM
> 2. sysfs connect
> 	-> establish the *TSM-based* secure session and IDE streams
> 3. sysfs disconnect
> 	-> release the *TSM-based* streams and identity context
> 
> This way we don't even touch the existing host side TSM.

I don't think this is a great idea, ideally we should be seeing the
TSM world expand their APIs to support slot discovery properly and
securely. Injecting rustspdm to make up those gaps should be seen as a
temporary thing. Thus the uAPI presented should be uniform between and
old and new TSM..

There should also be some continuity, possibly in the kernel, to bind
the digests/certificates from the first phase through to the
authenticated phase to avoid downgrade attacks. See my reply to Elena
This is much harder to do if the tsm driver goes away in the middle of
the process.

Jason
