Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794320445;
	b=k4iUYeYh87caGHIbQuJscSWN9hBAYHN1DXvKvq/pXIXrGycVpfK+vSZ++s/rKznBcY9o
	 XB1YOglEW6/2kg1uppU/2zQ4gR2rq6zUBZBzXYeKHa6zGhKjX+ZZMcZdnvKdf+9d8F3V7
	 veaMg78gf6R6yNjtHXCESfNnKQ00kt9ImZARVFwDh1H3Ss2m7q6wiHAGD6H/7ZW5F34UI
	 fdUESlEDN/GgBfaJ5JoJaA/sjeZfoTWLL0pU0F2lls3WoscFdwfQFOyAAMwZ3MHcVx8RQ
	 9LmUcv/FTvuVTxf+7qobgKbx4Q04YF+HTEItWkTIXTXPGIgL7EPV1URv7V2DIt7a/iQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320445;
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
	bh=DcboQKe3X4PGGiSdfwFdSh6x4mYmoedPQBq/azTM0JQ=;
	b=I+gJk94HviFds2NppRidw6xEFrxG/Kf9R0xAq1wajzNmnLpEX+A9hwBCE5AggeMN2zNA
	 +tLVg909b9RpfNlrwGteRjH059Yyrw3yq1tDnF5anPsfad6PUbzBO4sgsQLfg7AfYrCeZ
	 7OxfkRuKqdUQFo93GyiAwNb839qI9HRkmvuyczenvsUa4ERU/sQF72NNZJsaXWEXfwQ4k
	 c7diSxnnMzutp06arYttK9btgPZG8TvBAjw76fkmYAbbJOd+rOFFo3pL1dm/9GDeKtpAs
	 r/7jT+HcIUP69xrxc0z0OGBb4FbNGIevLuYwkIT9vpQWJ4YmnecXiIyZEKO1sjeQnug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bcxdXMoY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.22
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B533F60A2605;
	Tue, 10 Nov 2026 14:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B533F60A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bcxdXMoY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qV+KleeGo3vCbDLV9rfExvKGEi5TNWl8Udw01WjMC83uy44YYhYJSuX1ncaDwtUnSozb97tNrsU1xvbAnBNcQ680V2hidi4Zm0j6I2UmkdGzahag2+gmfOdI4EowuNvRE5BKhfjSG4o6cU5axRm8teHpDo6kGlKROu+t0fWwcDYTxItBMzCy475/OC6LNbPVTm8J/Lv6XVJZ0FvORzv5BIHw93C1xIMrZKSJmtWZwnE1oiLlHrgOaAN8xUN/cAckEjs1qaGKjNiCdBDJANyq5cAl3STiTph+oKxFlGssEcV9DgvjmlhlV6dEqqGnL3Fz9BNCyI1e2J1JCkvkJF/u0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcboQKe3X4PGGiSdfwFdSh6x4mYmoedPQBq/azTM0JQ=;
 b=tr8Q/a3nRyplArPMLqcrbyhK/cr0eTE7mTahhV05yW2AxVWeIh4Nx/WA2BYbsI3KUuSsGkXnNt0UfAh8uilfKyEuHhaek7PgWHUfpchJA3F7KLOJ4KZPg0uAWVBNs3SLTA7vjUhAsy5hKlAReAyZBT3VY+2q8Xfgsh7WW2B72lsEUgOm2bC1s1jVAYA83gWxOMb8rgcc9X813XRlxhOtcHkya/9fx4ggwpSoqgUIDpS1Yk9XeIiWZ5Kbxw7Yamu5X9T+za/BwKpmeNbDhcbRWyxhcttuyc3RFAcNtpGeyU/jl/OaMm+NXPOD/jBNfI0neQHbNUnDlXif0Sitzre2iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcboQKe3X4PGGiSdfwFdSh6x4mYmoedPQBq/azTM0JQ=;
 b=bcxdXMoYcXkmq4CqSv/x9LmFCH74JO/cEMUCd0IztM19dbLKuQ22aCKiSWeMEbUd+/CkJRJ6aHFs8Refrv10ejqlBrTpKbn3c9W3qHOILC5cA7kcLMHYgksmpPYXl5OC3S8TO2N4+e1xFh3n2EOSQktOEYbv462LICOLPy3vYlOmmLvE+vVBCHRlIdri9HZSXl1qRrAHTeTPyhqYuUMaQF0Sd8/QI30igKglEQjxvMII5HcpIGwK57a87aHEQObBtlrvBRolCszrZZvTq3t1VmvTCMCWJQq5+C+/y2dto6FGCXTtRirdsiqt0RehcYoORamwrsm9aCG21rLtL0k+NQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DSAPR12MB820198.namprd12.prod.outlook.com
 (2603:10b6:8:51d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 14:20:39 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 14:20:39 +0000
Date: Tue, 10 Nov 2026 10:20:38 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
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
Message-ID: <20261110142038.GE738765@nvidia.com>
References: <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
 <20261109234032.GT770409@nvidia.com>
 <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4P288CA0089.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::26) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DSAPR12MB820198:EE_
X-MS-Office365-Filtering-Correlation-Id: a6bb3814-0a91-4c23-78af-08df3f35cbbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|11063799006|4143699003|56012099006|261022105027099003|261022075727099003|261021121427099003|261026121527099003|261028144727099003|261102123227099003|261009223027099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FuJ6KDyKxexh9BOWg/bGMRmwg7TYCuiTwiCLfz20BDYdUl7UsqpRoQpvdREqkg2G3rzR5i0KRBR0NG0ZJJwsMN3DFT0DfA02aXRRcC9Qhgoj2ivQbjmeGgGJxmDTSA+R+0oDqL804EaNqalK+4ZIMZqztgifhYrTdKtYkzpcvLdmicO0lfIuQHgZKm9LwEYi7s+A+YEu7hQK0jvuXW3ErOcVOqZQQvSb9oa8jFihvGtukDcEKZft+JrX7ahRBpaePYsV672TQ7BXaPXr+IACH8uN6+vAHrUjf5RJ4Jfx5HEQTNDkP410cjCvVHAQF2pqmcmfRyZzBiGRvHaujj4IaQZ5qNkRlFoC86PYqAamULedE5u4xIWJZID65Ls99Pv+1kVPgClYMKj8Uy29CJpIvkKgs/KZjLqPsIOPh0CAXySyXkZ5o36FMvHnVtbMCNuPX1pdwU/ciEb9QmM/LMmhS/WahB3fdXceHmyaiLsKSjXMxKmeX/wcGoJqPIj17rcjj6tE+BHrG96gQTlZmZ+J5FDTZuOblmIJ0NIpgZXSrcRouqv7W/LkpFdzW2hWIZ1yeEwWQNMWo0J2lfNH7wcrueWiV4EzMvrxwIz0kpRbzc9aVTAfURviyatBIPWvW8PDeapYcnnrjPVl0gaC3ulAMSP5EHRT9NodahOhnctQ17I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(11063799006)(4143699003)(56012099006)(261022105027099003)(261022075727099003)(261021121427099003)(261026121527099003)(261028144727099003)(261102123227099003)(261009223027099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wukkj4FZ4zxVwaHM+UUuuqREohOcIHDQdy2q0M4/avxd8iyA2oMU/pEmxJgf?=
 =?us-ascii?Q?sfS0pwiaZqbRurjaXC/qd6v08FPOevsarWKvEkO99CNWRf3T5HpWONbUvhWh?=
 =?us-ascii?Q?bPRwNrpEC2gxG3QoUy6x06QAw2tpKbuXcS+1lo0OjPW19D0E4SEcxRwax1wJ?=
 =?us-ascii?Q?YzviUeQUni3RZhOPfMTmtxzCQ/TOjZJOMVdqoClgFvlEBF5Ac26UuTHY84NF?=
 =?us-ascii?Q?I/BigpuoqGKrJvIRNzp7OjEGLdtvfa3Q5eH+CCDGLUdU/ctP7XbTe3xSpSog?=
 =?us-ascii?Q?7gyeYuVvi6dpsgWWqY0vLUe3dY+Vc5dbMUJ6xSAGbf3+hV4XGYgrr5VlkLto?=
 =?us-ascii?Q?et6LiEmY0YAaq6wBEBRLeGGXCjyRn6GTe5oKFBG7Hr0h+qOVY67mXXMPePSL?=
 =?us-ascii?Q?VH3wyQ9m2h/RsFgvqtxeYbRlpR60Fd1njmYwICtcjQ99qN6NXuwTNpiga5mi?=
 =?us-ascii?Q?sr5fDoxy6PUjKBcIWHag0USOgo7VG3nuffWUMcy3ci6yaROr5nA5Ygf1Ia4d?=
 =?us-ascii?Q?PMXF9q5KF2DwqsuONdTJr95jBTLI2xP2ejYKJBtKpcpq8R01Z5sUvzeOxvL8?=
 =?us-ascii?Q?OSE4XPbe/pKtcIeOEA9rmXce+TQF/ZHfObt3P0OKeUT4VoygeMgJWi+AAxwN?=
 =?us-ascii?Q?HydXYkBdiXvJ7ZTPaHJ/Z3O5Nmda8wtJPaSoJhTzZkcPi+bvNN4Xtk2zApyQ?=
 =?us-ascii?Q?WGmq+JpB6g5HLZL0oy7yuassLCeFn2mmD/1/ZpfWkvm52woMAAr6VJlpv5ww?=
 =?us-ascii?Q?SHJIE1OTrCBI4PS5JJFzLG0zhjAxq5u8tu28ReruRe+/ybcpLcdIY2IgxcUN?=
 =?us-ascii?Q?KyGAaTL2VGBWZUdJ47OP48MWPRwJmVVEhxi8B+KaiJPMxsSb7hiyTYMx32pS?=
 =?us-ascii?Q?5w3cmnFk52ZsO6YoC5is5Yd2LH0rLO6vTrKKZa1a2Kne5seOFFlm9yUU9dI3?=
 =?us-ascii?Q?CQH+JantLtK4Pk5x9SFoLjsxNFUzOFu5IB0jozT7ihdcgcnLQVh0yaZfV+14?=
 =?us-ascii?Q?zEkTdB0KHi0Yx5CiwLaZJ6WGwNB4p9udmQ1OaEuV7PEn2WVI/tIFLYF1Sw2J?=
 =?us-ascii?Q?EiEMN3ykYkJFFwC84YiTHAFSKylVo5110GKGAnqaZ5b6kK7WmBSQ6eb9zGWf?=
 =?us-ascii?Q?bLAwS3WnXvddckVmmhcJiDFaTJzGWeRQApKz9+5kAGZksUCd5aRWGwC7L5Fi?=
 =?us-ascii?Q?y2Q7uVgIYhHonLCHO1kzG54O8nG6Cz8wBzDmjFMR7NTSpNHA99Is8olJuu8D?=
 =?us-ascii?Q?FQfYUJfnensVL61kNP4DOFBySdgmEndYLgWtnHGV6i+tAV82Lbti8R4/f/QF?=
 =?us-ascii?Q?kzN2LV0q432AWLkErB2SiyiaQJj13t+Q5yoKoxBdLPZUrHQ0WVZwAOVLSNkM?=
 =?us-ascii?Q?37x5bIBtgueo3VpSQcb+1m6LKP+WoR4C2qQSv6bmG7+ANh5vcRekJc2yH6GW?=
 =?us-ascii?Q?MU26M93gdREJQ96URqXDKLszLP7eYTgZLjICnzlCCDOnwaqT9IJsX6Fb9HSd?=
 =?us-ascii?Q?IDeP7+MHOuxX8O820Rzcr/1bg8NQr84JvKWlrXaxAvwLYCjT/BIKgpU/OA9K?=
 =?us-ascii?Q?qAL5cNzHCbI4lscSnvInCCtfyWF9kQlCn8ekhxoJ0rGRSmFl3zvtWihr5DLM?=
 =?us-ascii?Q?0aMBIa9Yo8FwazFxh94NzV+XHy9EZpEiRgics3cLVA+ERJ0ddFZoG/foX0w8?=
 =?us-ascii?Q?FSUKOolXyJboPW31efWU75ULrtG6mgzZ79QoE178PCDdE9EP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6bb3814-0a91-4c23-78af-08df3f35cbbd
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 14:20:39.4957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUGMzB+avqwlZml/7uS/sPvhvWYJUx1hCYj5Oqio2d/2Zs58IhDGETiMo79ibJGj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSAPR12MB820198

On Tue, Nov 10, 2026 at 01:15:06PM +0000, Reshetova, Elena wrote:
> 
> > On Mon, Nov 09, 2026 at 01:54:57PM -0700, Dave Jiang wrote:
> > > > Why? Seems like another wasted operation..
> > >
> > > The TDX module runs it as part of the connect and with the current
> > > module the host can't skip it. I'll discuss with Elena and see if
> > > this can be different.
> > 
> > Does it come out anywhere and become visible to the host or guest?
> 
> Yes, it is visible to the host kernel as part of the initially returned
> SPDM_DEVICE_ATTESTATION_INFO_T structure. The guest can get the
> reference hash of this structure from the TDX Module/TSM.

That's security broken.

The guest must never see a measurement from *before* the guest did
LOCKED.

The entire security argument of the guest is that it locks the device
so the host cannot tamper with it. Collects a post-lock measurement to
show what state it is in after locking, then makes a policy decision.

Capturing a measurement at SPDM session startup, while in unlocked, and
then using TDX module to trick the guest into accepting it as a
post-locked measurement is *entirely* unacceptable and I will oppose
anything like that in Linux.

This is an *attack vector* from the host and the contract between
guest/TDX must be able to definitively close it.

The guest must be able to affimitively say that a fresh measurement
was collected after locked and when it gets the reference hash it
needs to know it is fresh after locking.

> This was done originally this way (as far as I understand the design) to
> support a single-step attestation at time of SPDM.CONNECT that a
> guest can get all information it needs from this single structure, and not
> required to ask TSM explicitly to do GET_MEASUREMENTS.

Someone really misunderstood this requirement if this is what was
built?

ARM implemented something similar, they called it 'RMM controlled
nonce'. In this mode the RMM itself decides the nonce and the guest
cannot specify it. This allows the host to avoid recollection in
certain cases.

However (AFAIK) the guest still has visibility into the sequence
numbers and can tell that the sequence:

 LOCKED
 GET_MEASUREMENTS
 CHECK_REFERNCE_HASH

Absolutely did a new collection and the trusted CHECK_REFERENCE_HASH
is returning a fresh post-lock hash.

Again I insist that the Linux guest can tell that the measurements are
post-locked. Nobody is going to get this 'TSM nonce' feature unless
they can strongly prove that from the guest side.

(at least for PCIe devices, there is some other situation for platform
HW that has to be accepted by platform firmware before Linux even
boots)

> > > > In practice this means all the TSMs will need the kernel to tell it
> > > > what SPDM versions it can go up to.
> > >
> > > TDX has no input for that today. Will discuss with Elena.
> > 
> > Nobody does, but I'm interpreting that as meaning 1.2 doesn't require
> > a flag and if anyone does 1.3 they will then need to add a 'enable
> > 1.3' flag from the kernel, for example.
> 
> What about when it is not about SPDM version, but about capability
> (same what Alistair pointed out for kernel)? I.e. it supports 1.3, but
> does not support multi-key?

Things that change the SPDM flow in a way the kernel needs to interact
with will need to be feature negotiated.

So multi-key where you change the flow to pause after GET_DIGESTS and
allow the kernel to specify the slot later on is of course entirely
different and must be opted into by the kernel.

But even if you just want to do 1.3 messages then you still would need
to make sure the kernel can parse and size them to form the
transcript.

There are other options here, and I think once we get this built
people should take a careful look at how they design their 1.3
multikey API upgrade to do a better job for what Linux wants overall.

Maybe Linux side can recommend what the TSM FW flow should look like
so we have some better ideas and consistency.

Jason
