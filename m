Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793991299;
	b=qouDU09muLA3kiefrox+WKcUN5kbe6iuTGqFnIKyV+OhaXe9wHRG6CtFKz+JehbNhWub
	 hDIszQr5KhA0i7Jl1Ky6yYAiT1T73PqIQFOaWJvy6VfV4i+4rvvORb4EtmzE8Wzqng4so
	 F9DpF7u6Kle1pCXJjd6gTrft+kAMPOJgpjJCriMMvF6pMn/Dn764miQEVS1005o7RxV3l
	 JXc+UMVitLXLJJwhyby29dfxvnxG1cvCLzEC4GkBx1JrOTjSCw94dNgwwmpqfb86nYRE0
	 S3qayzbmXOAPPxYO1KrR0IEVmL4I0KbVVv/vIfuV/iikGVkBSZaGqepCXLgFSbcjMbQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991299;
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
	bh=M9b5/+7KH0HkUoXRUV+FhAI1FVBIwxjVj0V9r5W6ps4=;
	b=uIgZgJdySbDGs/Srv6ctl+RB5kwBqotGRcBTs/CuUCRUzTk2sRUhDlmWqHXROyr6pYry
	 B3iIdOUer9KY45k7WhTsQeAN30WfLZDZ9UUrvc9q+zg4ffiFtomQHlTkFju5Shn6Nd7qX
	 jWKgyFQMDb3m8sX4O0K/WDHmxAITI9WLlWvxNguUJyThDumtx7Yy+5Cdr4oKzU95enaLh
	 2J6lqfkZdO5V9aZD5setAwPk8hqgRDKlrXHQMvXVyqBYviIvxQFF03OWfzCEzGDCsqN+h
	 kfzzonP03jSKf7Et5FYhxL940lOS9pi4/bMnZUY6rodKeCe4WCjk1yxI7tBjmiQaV6g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=B2kKrxKi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.18
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010018.outbound.protection.outlook.com [52.101.85.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D087606A330;
	Fri,  6 Nov 2026 18:54:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D087606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=B2kKrxKi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fEH6UvgEGusQFm4MWd5qmuVgp+9fhGovAMJLjlcQ7fYa87mv8JJ7vMT26TTzfv+ijDT/vMKK9eOnwwpDeQ6SFD+vn/KoqjUFAdjGrDoP8yFBGJH3b0f/VfrUb5Y4s1g+R8atS1rYgLpbdAD8aAvz+y3KCjVwUjHebsdGoV42HiE5fl6NT/mCpAEm0PlI1RmBiIGyt2frG0qNzxUmvO2WtYZTTkQGil7AJML5xCFkL1fKlMPTRcTegBb9DAuSHTRmu1SnFKLUUaqj8jioH7RqK8SpS96lMtXXXJwowIcMXela2+CPKI5qV/S+gnxYjSRa0xHBP9/i9zrc7XCC+nMV6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9b5/+7KH0HkUoXRUV+FhAI1FVBIwxjVj0V9r5W6ps4=;
 b=rANxH+GAWMcsoRq1mPJqZRQz0/RxsxaIb+tCQGqCKKDtvNt/VQLlPoj+VCCky/gtjfn7s/NCvvUeTn7EnYrBi9aJxz9yJOlDLOHUgzy+4pI4NVDA+4aeSzQ9ew8uS9Vbf9cq5uMs9jUyU5Q2knpOVGmTuBFFZvNh2G1asvYsKwQAOiRgrCTqiwtu4MMbxgQYQfwzx86L1RQCkp3gdYG8ILF98TZ1pAeJzrJ2sCEcB/KvaMaU2zB7JGdnL4kWL/OXM0BSs9spL5GUuK3yPmEhAAhL60SGCjV9u8jOihg5p7zmr94fRdtsN2W3jYu5wdbGw3GrivlRY+AT4CgKi3gf7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9b5/+7KH0HkUoXRUV+FhAI1FVBIwxjVj0V9r5W6ps4=;
 b=B2kKrxKi7q5lNJALHkxFPzqdNIKK5/6GjFoa3fNV+SEMD4qy4s5D1Cr4Pxqc2C+OleInDnCxbaS0FZ373btlET+y2bXgSU0Pn9qHP86DboNob3w+NACVbZS1u7xRtZd7El3yx1yLU0j804fDqtIpg2j9G+pQJ1K9uCaGKNI5VMSYB2iSF3sBDRU5qobn51aOfUrrd3QshUcuU7kczBlejblcgjuYK9bzuHg3MGhPrmc8l8iw+3/qfzjO4nrxcy5sBHi0BfEnzArjxg2T9Hp2G6uvOolk8CdKQoKZwZQJz8oKoLgeMuHs4yh9rVM8qP82fQ86dhv9GHyAVm/nkxeJPA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by MW4PR12MB6706.namprd12.prod.outlook.com
 (2603:10b6:303:1e2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 18:54:53 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 18:54:53 +0000
Date: Fri, 6 Nov 2026 14:54:52 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261106185452.GJ770409@nvidia.com>
References: <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
 <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
 <yq5ay0b6pdu6.fsf@kernel.org>
 <DS4PPFA84FA90FC3969F2B8388087CDDF67E7762@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <yq5aeccyot13.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aeccyot13.fsf@kernel.org>
X-ClientProxiedBy: YT4PR01CA0355.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::25) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|MW4PR12MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e03e3b-f91e-4eca-2a3d-08df3c377162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|22082099003|18002099003|6133799003|10067099003|3023799007|4143699003|11063799006|5023799004|261026121527099003|261102123227099003|261026140227099003|261028144727099003|261021123027099003|261022105027099003|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	BSYwEDyVhIK83tLW7SaMYN/Y3aWwAB9L3ssFmoHNUVlFc673U8u9D3MERFZ/HtQGsb3jhMC4SiiVEnkoh0svoE0DeMlTbdA0pUXsi0W+dvX3umdinL+E8zcmbFWlZk6uwfBh+Ep4+l/eToLHdS8xtWS/t8P9FmDiQEnbu3LQa/xGHvyk/6Epu9RrZ3ccYKNzfKCudheN2X5iQEzs8Y8u/olRbXrhzJsftWljakagljCdVz2+vUS+09DJEtRJUENeLo7A2OHgrA25yeaZb5q56OM4rFsh/FyF9h7XXqGx6I2mUm/mu3oJ62aN6O5XjLszCfzT+hcvWRe6ippIPcXL7568SKJpiNt1D5pBk/R4S5xRowfQSKy9mwUkz84qYzbbMiDBhNn5FGg5CwMrc3ue8SQwbKSXH1LMiXVw/YyRmb6VJRdwW1FSv9xKpRTq3um1LHChldQQlaSIUhc6Niy5Z1pACJWh3xASxt7xJrK34u+NCs0aXcMBGnFphZu8WyEfoQQBvRFWzzoCNNAYHcrxLC7S676IZaa7CZp5fuq4EMbBsVta0Bifh/vgwzCUFpv9MuZY+bmA3FW+w+9rh77+Y3Dw+fVhggLnLGFC6y3my69IXDrA65ZTLfn0cN92s36jd3xT47lQSTkLEl6MTJYSwLjXZMGdx2TpMONLMuCaits=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(22082099003)(18002099003)(6133799003)(10067099003)(3023799007)(4143699003)(11063799006)(5023799004)(261026121527099003)(261102123227099003)(261026140227099003)(261028144727099003)(261021123027099003)(261022105027099003)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/z+qpf+61GdhyU3A6MrrOo2o0JHd7sSYqjRTurc8ArppBb/zdnG/vOX9/H7y?=
 =?us-ascii?Q?0hlc9YZdNLv9gH/uSwZ0GEYI+g3yt9BMW/JCVpFLdm7yfEWwAnsqA97LHU94?=
 =?us-ascii?Q?K6EYO7cUFkRRVNglbli2gilCbhrMwdBUJRS0qOxHBbVy3P7P7IWnYfb19RUF?=
 =?us-ascii?Q?ll6kkK00XxpdTpyPaRqZZgVX46V8nnOQQAhcqwVqwOvFXhuAeE5p0O/2Ks7H?=
 =?us-ascii?Q?y1+bbrKPiPHLL7ma8CHuDpzlJREk494yPZkwA3ZADcafus+GrUyCg9Cpcj0r?=
 =?us-ascii?Q?GeWJB3hlL5LHOh6Xew9Rhl6u8m1YK25ogIcfMdQHCNQzFu5czXEiw6EX1ak1?=
 =?us-ascii?Q?4Fb521JKY78xV99sQP45NlA5qLaSMvKaqykcvnkQ8dXnsUF17RYNeOwQIL84?=
 =?us-ascii?Q?H20FbmJk6fOEQsQgpqZEpureZfr+cXLxNuwiISpjU3ZfIdpRS4d30Xo2c6pj?=
 =?us-ascii?Q?dMUfVBF44rhdCoofq4yg7opWujBwAGerRZX5SlgodcGkoP/V4vK11yIB2f16?=
 =?us-ascii?Q?DYw6Xw3ePrtsWAWkKcvnj7om7HprSyWfPMSDmc1cTyAW0SJD30bW2lPRVZfm?=
 =?us-ascii?Q?80WSwnhbKI3F6NtdmT2dVrF4FtriNuR3cIjiE4LGuuGPKsN3LHe4mq6uO51o?=
 =?us-ascii?Q?8X/QkLJy75ev+NKkvaodExvk5+Qc1DmfQKsNH6cxTYHNiVearfYNdlFTl+2b?=
 =?us-ascii?Q?n2LkbRTTYVVSaPEaox72Cc0X5NlIFnKAh3C60XqiRIVivQ4ug7k4hI+dw0XN?=
 =?us-ascii?Q?AboKZEmlukDeoCPNSsPfwElu9fGBWl6bV9B3RpEeNj28VBxthUPVKjatIPYW?=
 =?us-ascii?Q?CXLIV1cpKFqNSx8W+8mgpm9csmTDcmM3EbU2gPAU1dOM6689IWwRJJgRwwcj?=
 =?us-ascii?Q?udCJ3TyvYlXGlHQ76I0ZSnxM3UYF0YygbMQGp9L9cl20hhGRwup/XAFEWai5?=
 =?us-ascii?Q?ZmIv19Mu7II2egzFaM/JSyXCY1pyOEIRlaCGLlo1Tof+hK+PWxbkLgjyjdzp?=
 =?us-ascii?Q?wAnHW0WJJKjcaXHJl6nxRGo3sTx+O1Hq6yOPLRlNjPcNLB67f4q2Ih44P5sO?=
 =?us-ascii?Q?ta1n0fUDpaUWrEaY0BdH1ETkp+fn4CnUcs6KpNC3sPyvRJL45Xd6Yzm7zAOU?=
 =?us-ascii?Q?MZ/QuQNw3VaoeIGJZXfmTDUskjlWoeD6Ejl9vZokAD9lhQH6VnMTftty7L7h?=
 =?us-ascii?Q?DIYgzTFd6kjnY5nHhSnFDbvsTAGo0m1sF2t2c1D23unXjjxsbT06TW15xWqz?=
 =?us-ascii?Q?51C+fS7RjdUemN57WFTRhOzntDlhb0JgKKZch7qvnuzi6Adm8elVY3e7Psb7?=
 =?us-ascii?Q?EYVJrovPNN+GHBBs7cXt88aZLwwdbxM5HZbpHRVFMzZhX1txQHKYq5mx7qzC?=
 =?us-ascii?Q?1TXNmF94svZYmE3jsWj36aT6nH3sQVlWvqR7o+ejZEHahT8FwG8Dtl+VzkRp?=
 =?us-ascii?Q?jmmEaUu68Z+Rk6s37nDVwDkQyCv0+aPPgKd4nWiEV8sQ2ZEMwx+YlDEqdegI?=
 =?us-ascii?Q?zc9nmzWH6YHY5Ib6uu2nRb3aL/H9wa3DEj0tck1MMzdv2lWlwTrRwODcjGpi?=
 =?us-ascii?Q?qhQASDnBjXYjaSIc5JUg070UYlPydhhUKsXGBABTA5/IxyKCcqU1kHqfnOT7?=
 =?us-ascii?Q?hs1xN1CdlMwYspDhdUCZYercVYzK74FpriCcwnGnK+3rhT2Gv64VgbDAspaI?=
 =?us-ascii?Q?mk7J/xZ61MeXY5Jlkcs4fgAaXh5V1aCwvWqi6vJ1f3da5vew?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e03e3b-f91e-4eca-2a3d-08df3c377162
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 18:54:53.4448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dCZieCQtqUEFhHIB1ff/2qj8pRYarMX+DK5eg8ISIayIF2rTBqWhWsYpDUtC8nMf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6706

On Fri, Nov 06, 2026 at 09:23:44PM +0530, Aneesh Kumar K.V wrote:

> >> Does this split require us to guarantee that no GET_VERSION can be
> >> issued in between? 
> >
> > Yes, in my opinion TSM must enforce it because as you said, GET_VERSION
> > resets everything.

+1

> How can TSM enforce this? Another subsystem could issue GET_VERSION
> through the DOE mailbox. IIUC, TSM would only detect a transcript
> mismatch when KEY_EXCHANGE_RSP validation fails. Is that correct?

Firstly I think nothing but the attestation subsystem driver should
operate the DOE mailbox, certainly not the SPDM flow inside it.

Secondly, yes, the KEY_EXCHANGE should blow up if the session is
interfered with in some way, that is one of it's critical security
tasks.

Third, the kernel needs to keep track of the SPDM session 'generation'
directly and expose it to userspace so there is an unbreakable
continuity from START CONNECT to the final ACCEPT.

> I suppose we would need to pass all of those parameters for the host ->
> RMM/firmware interaction. I had assumed that the algorithms were the only
> negotiated parameters needed for SPDM session establishment. Would validating
> Kc and Ks require passing additional details from the RustSPDM exchange to the
> firmware?

This is just backwards. The TSM should be in control of the session
from start to end, and the kernel should be inspecting the plain text
messages it sends. We need the TSM to send all the messages we need,
like GET_DIGESTS, GET_CERTIFICATES and so on.

Doing two sesssions is just an inherently less secure idea. We should
not do this unless we get really really stuck. I prefer we change the
TSM interfaces, ie in RMM, to work optimally so we don't need to try
to do this.

Nobody has every done any of this before, all the specs are copying
each other with incomplete implementations. Nobody should be insisting
they can't change.

> My main question is whether we should avoid splitting the context and
> relying on the host not to disrupt the sequence. I wonder whether that
> would be a poor API design and whether we can avoid it. Is that a goal
> we should pursue?

The host can interfere with the TSM's DOE operations, that is part of
the threat model and countered by the KEY_EXCHANGE sequence. I don't
see any reason to worry about this as a problem, and we should take
advantage of it to make the flow work naturally under a single
session.

Jason
