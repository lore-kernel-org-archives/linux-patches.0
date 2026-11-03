Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793720160;
	b=F/eHceQnAGJsJ2qBDr9vcEGL5KDXn5UyPqs592XANNx76TqHOgkThuXu2kUYyOIg0grD
	 KM+yYMOx6gjeTupm6DZD81uFe5ckSo9HfjLiLnuuHI+hJIA6G8uDVDUWwe0sFDk8ndN1P
	 bkHoQe1W13pdVGBFxpIIp7GK728FredEzY1HxjBML2wZmE9eMw6/G0pU2q+RYxtDcBBfl
	 Y2GvBoir76Xi3t2jwi6LzjZipBIy9RsLgzYqmSPqSl94oieRGbdQAZ6vTmEBKgUAeYlfs
	 DZw5lrD+zYmsUSvrx9UQ6eUb97Nsdkx9/b2OMGjObtF5GOt2lLJO/SPdg2mHUC2ay3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720160;
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
	bh=Qeamo4irrBToBPZfU9g+isG4lZjAtD3wINTaY1K5MSE=;
	b=byjyUu5akQjWh9Z+n3oS+O2zq3hxEcdz96UIuL8O3+pBx4z6qsw1XirfRH0SSwupwncm
	 klJ1GUwO24DWTfu+pLdsGFxauYLshtFJ0KERVyPU89qcFPKDq47CghXJUnl2V83nms8Ub
	 hDxjaJFphjacidsAALLP/cSBncunItxsUqHr8ykaVfzLzPp6/1oWTkorJliuJScUxdkvm
	 Ot296dKokd6P+DxjmIelpKNVHTM38SlbaNP4U6PCCME7vuR0qTsoKyGCr5TOjp1s0m5r4
	 nEwN++JKcPoIhWSXhRshJ4PKSTGEWajjeivxnvyDucZqJnvicHl9tZkH2IBuBSk9/AQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Q8cuPMqd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.55
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012055.outbound.protection.outlook.com [40.93.195.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8D7606A324;
	Tue,  3 Nov 2026 15:36:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B8D7606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Q8cuPMqd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rdhP4i4WEsYCYK4Y1it1p7KlW5srf0zq1N4iYTU/4RuWzR8U7KV+W8MbPz8rWptTjnhu1vmZaBDF9v6FTnCn32LT39McKoYjzil07cBW8ndzLv1FBtkhvgeDsjzY/N10wjNIwE4JBXL3WHB8V7ydR27g99MeBrAn5a+KKLSf/9rl7YWgvec2Ga4hvGQNaUHAmBP2AMfg9fZJVAkgDZit/7uVADqMWjJWWonzCLO7S5Dq2p1oxf7nsx4yg6OME7PyvR2s2fgd2BT9fiJVy+BAefe/GhbSf0w++QkFAJYxkk0sTCE05JUG2RO3zMBDjA48lfhQFctdELYv3Br3UYgK1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qeamo4irrBToBPZfU9g+isG4lZjAtD3wINTaY1K5MSE=;
 b=ELiqtSp80rzPsVcvC74qGoj+GgNYrRv8z9+G/nz0TWX0AWTTcFjIXc/7Use+CkvBsgHfRpt4MsEfM9KmIxyfifEqQfbBoH2Nfi/Z+zHYIczMtkN3BPp9l/+1WDzd4WkY+ANSPpRcaXQXSYWc17GiFTangjnG+2bnJmuNVu/z0NUvPivI5RfoEbqPshpJzqLVttyRo9qLO5fZ1kxlf6rjAy0kLJhxUlOxxENnpme5Eodej6wvVQgXTNEHjP3WKCjx0RIzv3W5Lp00z8G6JkYHF5eNjAKws+qwarQ/clsvJ23SOIzHQrQ9xLxftt2S8b7Vnc790YD2rKX1JnjZqxaHvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qeamo4irrBToBPZfU9g+isG4lZjAtD3wINTaY1K5MSE=;
 b=Q8cuPMqdu2/SfSYz+jLdaebXvhaT8kf4Baor8eDQNTLFp5DdeDZfByJBA2FIpUomUFIc6hwVm5B0CWhU136rO/GM/81hy2rjc1Iv00W6S0gfsNnjiL0SHXqDtGkGO1HXn/Z6sBRk8UhsuRFOuoQlFHFJTCL+DVr21Qa4JZrAdHeBQYJ0aBhwDi5k1csbtszDlrXHEVz+fzkEK+Uh9gLdJdomCpfAn6nf78OrDWjhJUA81ObWvwVwwqyOziFBpQauR9jpfXYgH9UvHyNvUXaxsI8K0Cc+3PWZX49UkgSe4gZpvswJ4SBKmF1RPjctIxR+gZT8M0IGByHTgnC74kfoww==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB8608.namprd12.prod.outlook.com
 (2603:10b6:510:1bc::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 15:35:55 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 15:35:55 +0000
Date: Tue, 3 Nov 2026 11:35:54 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
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
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>
Subject: Re: [RFC PATCH v1 06/11] PCI/TSM: Describe the PCI attestation
 control family
Message-ID: <20261103153554.GJ274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
 <yq5amrrua515.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5amrrua515.fsf@kernel.org>
X-ClientProxiedBy: BN0PR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:408:142::23) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB8608:EE_
X-MS-Office365-Filtering-Correlation-Id: 96dc17c8-4159-49aa-ed50-08df39c026b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|11063799006|4143699003|56012099006|261102123227099003|261021121427099003|261028144727099003|261022105027099003|261026140227099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mqDnTY9WTOvi7C8aRMF0s2Qnql3RVXmQJqpEHL7GE0SlYd1qrwi+DCRbPz/rcejbVMRYyPA4feEVLFGn/e8iRC2UB4CpESVQ0cS6k5/TCbZoLkQkzk9Bl7f4h7YuUZHq1wHPVnCh3hgYRKN12GC2pCtiTvme5r1WjrpUiuqJiU+WHtQ8xQ5GtAkXDIObo4AmYBIq0TorWS5XpFW2H0MHa/MpXiWrfnzph7Xr3gpngQooT9zpTPpbWXHQb8eaXOizlCre7DFlhYnP18LWiVs536VRPTKR4hAjUyZImN1YjPXIgWibnXEWKfzNh25LQcg+zFvwMcTo8ZiOc1TdqTRDOCTPwUZ7/mZ3RWyzRiuEFvegXrQ2PjR6j59ouVb3XhX3r3n/OlEu+mfmEGYywjOjxQelZ9gXn1kk3/cHBXByEgVGzsykp06Dw/XA65padZGfCWq+s2AsUIcrmlvX3CrJ62m/rUkshnaJxLNYF9ibkKKBjye6Qok/zRo7wmsBr1b2XhUdFhdD3xTr7p+5o2pgAkq2ZPf50MTCAJXvdkFQIFP4/0pzVX/qqvSlgDSXeWX++vTE2TthSjO70GyfWOb2CNerTB5JmZnz1gXtzr225qkMHFIzvTJITmZzQjoYfykFqYPjO1SE+FZKQ58xEdkWRb5OpA2w6N76hVTy49m3cGc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(261102123227099003)(261021121427099003)(261028144727099003)(261022105027099003)(261026140227099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sR87IJczl3lHpB4dahL9AW9tZHjurGyocRviCDQu1wgLqHCaLRWnh700ZRGP?=
 =?us-ascii?Q?UxfKkZpC/IxuEDGuDoHtlPzyTCkl7d0XZORyVqe5rlL0VwH1ijKmI6ll7djt?=
 =?us-ascii?Q?pd/VeY8K6PxWvnR+2PUbIU7jQnzkfQIUBRQGESGC3436zwzT0/92i90Tw8if?=
 =?us-ascii?Q?fLMODy5B6P2uT8EcPEMWcjhQ+Vfy4PymTQiB4KKwxiM077fi7kS7fvbOq9Cf?=
 =?us-ascii?Q?cdsp0KSLAJVuFeGAUbzCHKerFG0lnUBa3b99LhxZ5Rr8m6d567UGCRVY5yOb?=
 =?us-ascii?Q?Y25YxVPOou+CR0f0nnmAOx1xOyi3NQhh7WGuMySaVWgnhjL9kUzletNuHOYx?=
 =?us-ascii?Q?aGmKGpSBezxdKYNj0UTYUkP3SfxW+mOq97c8QLq8mI2nkKeJ16Twk6uPRoQ5?=
 =?us-ascii?Q?pB3oEpFotmch7nk2FQwjdYjkQMIYaedGb5Ud39B/otb0CAccKhiF61wPV6/S?=
 =?us-ascii?Q?eBdGXQTnuwlG7/VF6+qIsZ3bIibb6AKrjxmwUKX4MCnhKPmQSmcCyqarjuEs?=
 =?us-ascii?Q?0lQ0I3dP0kShajSm5ujP0yX5lYmgmlKXlvU9RuJAbmn9DP3RNH5tlUQSVUwp?=
 =?us-ascii?Q?K8ds62KxPpjOb/3w+q4xFiqzr1pguGIuRHSj2ems/cRyTHlQq9ARWtaDchI9?=
 =?us-ascii?Q?S2S3sO4XXEVZI+y0BNMLnV0C5NGcskn74YADgwGh/GwbRzInofgqT4m/uyM9?=
 =?us-ascii?Q?8EHGhAnyif2Jhnm4BPqMr0QAqIiIIZ7rezZM8hq07ZL45i7twE2qZpdZMUuR?=
 =?us-ascii?Q?x5ZTmrLaJfuwVmVtmVjyyWLBHu3l+Sm8TNwv/nePqTJsupksm0UtFm/2V975?=
 =?us-ascii?Q?K3BW5+llYvAyNURktGi2mzLd3RGZIUphMbifYLuULn0yLf/mcPkD703Ycu4O?=
 =?us-ascii?Q?KKoQDRozxY4jqbqzWeEP4jmk3fobmF5nh8/shQ0siP1OZnSYTQmhkQ0C9GyD?=
 =?us-ascii?Q?Pd9SIZ5AXL9M9nyFdUfEhceau3C50q+UgyJ94EloElWwl9Afk/bNX0CvNlty?=
 =?us-ascii?Q?bYc2Idu5aTzU4e1h95+xRdMqh2GlAkzlWkfmbmDZR6bTKd/YPxSxVjfn7CxQ?=
 =?us-ascii?Q?PjpnwxxqgrQSfsLd7vuCReThgJv6PxDUENxAap4FBcJuD1A/U2KQ1fVxFiJ7?=
 =?us-ascii?Q?fU3MC6tZcznKKvZOMVCMpY+DyhAU0Z8++w+IVWtFPafmgBWz61gBTs/Av8nW?=
 =?us-ascii?Q?E7wkMoYS4IjRkA74qiz62Hxk+MzfZNAC5zPg/F6fhe4Wu8kzKdv3k6YAPPi3?=
 =?us-ascii?Q?t8zMiOaI8X6rXEnBkpbJvdyuWLK/4AIjHWah+xhLni0FPdlf1WU4PNCesvnm?=
 =?us-ascii?Q?0zx/155Q+kGVUuuPyNrY6z7m4MVSdf5v8xv32pYLLXNTLGr3Jsm12hwiSaJI?=
 =?us-ascii?Q?kT8VIA3vnazv27pUwgKl0lNP2SrqdwAk+KFYbw0oNasQ8+yUJXd5MIdLi0Vy?=
 =?us-ascii?Q?jBJMK8yoN4Q1ml7ygE+7n79x7St7y8UiUeCtW6Pqu9te2tYMuWMIsknvT7AM?=
 =?us-ascii?Q?GhFrRrPH3EI9TBPOeOWll+29YmWLvNuzo4asyWtF3qgbMOGGzmqoeqV5fPea?=
 =?us-ascii?Q?D5DnleAgXwymeFB0o77JIBtpmV30JF2DIiWpydTBqZ+55t7D77695heWaLJW?=
 =?us-ascii?Q?CrMSyVAyh7g7bokfAGfJSNfjtA3B4xKoXRivTVk//lnto2aP4zBaCDtWl3WN?=
 =?us-ascii?Q?W3bKnB4I3IpUTutD9PaYQjX/wV2f1w0KCsYpovVStDqet5sz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96dc17c8-4159-49aa-ed50-08df39c026b9
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 15:35:55.8648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqDJbork4fnW6uXzk0h9dVdZMGyzUyfZfTuLm8iIIL2HTjChoTPO86t6zO7J46tV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8608

On Sat, Oct 31, 2026 at 09:35:26AM +0530, Aneesh Kumar K.V wrote:
> > Would this split work here? It would also allow non-PCI SPDM adapters to
> > share the contract. I understand that multi-slot discovery is deferred,
> > but a slot-zero implementation could still use this family and operation
> > layout.
> 
> The only point that remains unclear to me is the distinction between
> EVIDENCE_ACCEPT and SPDM_AUTHENTICATE. Also, would EVIDENCE_GET retrieve
> fresh evidence on every call? If so, we do not need evidence-refresh.

Lets talk about the desired flow over in this thread:

https://lore.kernel.org/all/20261102172640.GB274202@nvidia.com/

I proposed that LOCK and RUN fit into the normal SPDM flow.

LOCK is effectively starting a SPDM session since it is LOCK that
provides the mechanism to confirm the host hasn't tampered with the
SPDM while we are evaluating it. It has to be tied into the SPDM flow
somehow or it doesn't make sense.

RUN is the natural consequence of finally accepting the SPDM
connection after checking the post handshake signed evidence and maybe
a measurement.

Every SPDM flow should end in some kind of 'RUN' step. It signals to
whatever is waiting that the SPDM session was authenticated by
userspace.

It is a bit unfortunate that the IDE setup was bundled into the
CONNECT, before we have a chance to inspect the evidence, but I don't
think there is an practical downside to that. Though we shouldn't
consider that the right approach.

Jason
