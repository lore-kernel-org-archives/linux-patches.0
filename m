Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794501593;
	b=xUe1O8zR2bRS6HYP4qqTddXrx0EJrNUis6AJt5Iib0mG8sSN8lSBhLJ26eeYTc6dRk1g
	 +dICX2rBwN1/m46KUTVhJdIqi7yx6kNpxCVCg5RGqXLeYkvMht1xkItnVyS1MtasPY7PJ
	 tfMOpo+RkwDDOmaELUNdXxmtIDORkimYSHi1PCadmnehjxhciJbhE2yMKEXmZfwdQlxFu
	 otV/nSERgXH9ivybfGRwNYm0Y1FmXMqtdoI17QhtN/OdBge/MjBwolm0KycDlSDYfZbRu
	 UdVwFKoDViIlLq+JFPbqmrewdQ5CGz3w0RBmREiQaInt8NI9mixnC8GVCPtMiArt0Rg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794501593;
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
	bh=nAxMera2/pgzRsJ94pDwrUuNpVahDO37Q3lRePQeqn0=;
	b=1TlUubEWt8AvQ7/ykud2HxFZZQAIIQ3hpk1l5DnpXfL8PoEdP/GDvvjayoEbLnq62v/p
	 lzhZofnjtpHJxeDIDvb+ANPwU17p6SwBapErYC6yQngxYRikNUw2PrNFPIPRv9zxn4mjs
	 I7Riq7hj5dk5/WDNMh3AyGt85NHttO0QByzequw7YiHW3ZOz2n3rOhAMk/mlRn9fCRzkN
	 SRlrKkgpfp37yj1pbI9s9EUFgYRhmOB04/bwZj7kq7+v/RhnvkN152QZyWT6NWebH3pGO
	 GvDE2OQcCzRsxHVOX0FCVNcj66Y7VZKroSUE2l1GvjBziT4QMhawMTE3Dlmpmg869/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r+9GnoWh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.42
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E031F606A32A;
	Thu, 12 Nov 2026 16:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E031F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r+9GnoWh
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=scBt+DF6KJXkxzGUiDKO3dsTkZ8IFUvo+/EcuE2kuXUyHbSdSzO9GJkxMe/1vgyyJhjwhHMPDku+eFPF9MVvEKtMTev/VTxANf0pE0P1JAA3ZHLMff0pUl90ahL/vak2le76mJNm2a8NV9qPaCzC66KDe+rYgAjP7U0JgwEadm7m4Dkj6/tAHhQoMtxs9CdqY+CxJ4SCaI43xUZjHOsdHzwV7wwhBad6sPCAjkth65MBaDShorH0d9nvsHOVSvkwwI1ITd01qGck7lZmdg+6y8rKc7yI6a7J0F47GA7yEdFHaOn6iZdN2Dv58si4c6wNntdb2Zp3UKoMjbKXE0puiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAxMera2/pgzRsJ94pDwrUuNpVahDO37Q3lRePQeqn0=;
 b=jqb/mAk13qqGkE3vlSJtQrIIoCNC1aDEVWjbSQGIxcs0crcH1GZEwZQp3MSND5es5NeHFp456sCxG5LUP+qeSvBRvg8uhXWcAO1BGQOB2XCoO7rYgXgeIO9ozm9wWkOE42pnR1zqAiSung1jTs9ykx/ap4kDB4qiHMyC1c311yoAoL7Ef8PTWKEBF1ItXfbL+wGNCbYJHazdb4Svj7ywVBZEd6o950jU6iT9QJDSsMGUZm7uEHlRHg8mC0OoR49ORteYS/FZ6OKdzteVHvyJBrMI/ZaynA3vhXDwKv9LZWunanM+yJHdNytM2DreB5wSRWsNoORVCL0dEl37oEUpDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAxMera2/pgzRsJ94pDwrUuNpVahDO37Q3lRePQeqn0=;
 b=r+9GnoWhnDKsWCY3xYGCi0liyHL7lM+pDfDdyVfvHF+TYaPlsAEDcYG7OIAvXla7HOJ8v9YcikuxCPMsn7TJydK86vI5sd5VM0LifNQJS44x4QAE8FgeaR+ygrluStjUgyR4yQaks1K+d1mENx0UHpLN/O9eUorNaCLh4Hz4n172Li0i2VKbINCOBA0rVU14Mp7+BVhW3nPsFrq4rU7N2DI/jnamBgbpmPLxnYS3h9jn0qswKCIBNAxmHcFA/1QV+L7C4c/Be3EQS2Q4X7oZhFIhMwMj3Kph2u2YxIdKSz54f/cTlsTRCak1gIQVXE8XkTuBoptYW8MjRVoRQHmDvw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH0PR12MB8151.namprd12.prod.outlook.com
 (2603:10b6:510:299::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 16:37:38 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 16:37:38 +0000
Date: Thu, 12 Nov 2026 12:37:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
Message-ID: <20261112163737.GQ738765@nvidia.com>
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <21bd5c40-7d32-450d-93a9-7d5ff6693c34@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21bd5c40-7d32-450d-93a9-7d5ff6693c34@intel.com>
X-ClientProxiedBy: BN0PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:408:141::33) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH0PR12MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: 357a5f89-2194-4c18-306b-08df40db4358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|18002099003|22082099003|261022105027099003|261022075727099003|261026121527099003|261102123227099003|261028144727099003|261026140227099003|56012099006|261021121427099003|10067099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	VNrvdOM6yL7ggI8OETlba9N/aKUhjeD1VYmQhnxYpTkr3dq7zmOsLOd2FaCgv41dXAZwVtKPeS86Q6kc7wynI65i0Pp6E/bBb7JJ7psYpxVh5cGdPj3OJgUFFQ1u0Qak+82O1/UdlxplL8fL3cUBjFy1Sx8Gw7U4Z7YSVjhzlSVBGbcveXBWZ8VtbvFBhY+Kkn1DjpnGwniD4QC8i9Co0qJ2aRUj/f0+/gA9fhmQafb3T1WsHG436n/cUJKxqpPcnhrchb+SGSWQmpf4xQO7xhMML0fqjN7ZR7IfpdHhGVOQUID95e6Ax1mUwrXtch89ITvo1Rfut8xjdgHAVG1W37KJJiPPUWmwauZ1T3slwY+WN57jJJ3WMu56LntMPulYB9x8UXCYwwO9OU1jhgZ1DAXOyMNCXYMiSuinVlSsVZ4KqQUJ9GCIqNEcAMuQCbwuaG7vCw061fe/w3PYWGi4loYUp01pJZ4sl2cGfZW9p3UA0qU7L9OK1y8weyctwDNrryy93RintnFimv98nd9ByoL9/75fTbTV+PXAZZzy/klysIitUxN8x1QYMeXnBdIeQovapbJIPjiu60w5Nu2q4lEJb5sHXMY3QI9QOIXAV1r/7URalvMSRQvVHd9DIFncx4NTZ/jQ8uYTP8r/9SS+Ofa4J9ScQRgcJ7uCMGhIgRg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(18002099003)(22082099003)(261022105027099003)(261022075727099003)(261026121527099003)(261102123227099003)(261028144727099003)(261026140227099003)(56012099006)(261021121427099003)(10067099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c2cTfOeT3thGz4sqRs/AFMGQ53LTaIyThp15NogqS6RIIVTXw/G5YV9MK5V9?=
 =?us-ascii?Q?NrvfQj7QzIyrLRtNgWrCk2+5+IwG/zEfLOACbZM0jp43Ab/nGiyh9P4g5PGw?=
 =?us-ascii?Q?5J5B29bV3dRnLY3CiprYybJpqkAhJ8xqqBrI65vrDS7GSvxvlcizrmGfKeI9?=
 =?us-ascii?Q?zt1vYLtZbrviCwF2U83m1gP1VpQEQAD0fpXx6Pq7CiLSv6X9rQAOPNPoHDPU?=
 =?us-ascii?Q?W2khg3FbKE5yA94AetYnjF/obRnwfxFDYspPnyHqrI5dxZ4eP53Y6cC/Xv69?=
 =?us-ascii?Q?Qwe8xmDuG9Lp0U94bzfCoEjDLPwONWXhqho0hm6yLqpxdtnJbdckwk0SaVmc?=
 =?us-ascii?Q?SbtWOE6m30aIWmLmjzo4o8/a3GS+sfFlJ3Hkihg2xWcksy2pW/VZyp8xotZD?=
 =?us-ascii?Q?5+GkeC68/uZnUb8nboNfpBSTUjpOk3+SlH65DEUGESlNMwRayQW1lp7tubpR?=
 =?us-ascii?Q?3kskshxjSHeI6gbeUQz8J2asfHLmNGz2WQUqidaebYxjt0wvEaJAGBKdmUZ+?=
 =?us-ascii?Q?4ES6jDHicrFnji3YySSax2WaMRPxe/zwP0R7jOp98a0IbD4gjJAB46dG20Qx?=
 =?us-ascii?Q?6oa3P87EMsMwLf/y9kbJoFy+TioCQmFOMp26gzFIrzhfwYCMuxsHtEwrCIdT?=
 =?us-ascii?Q?Lclh7Ll7hnQBXLbnjiVlkfo1ZGCefKZ+xMksXz6fQGhY2kXgSL/jtkaLff45?=
 =?us-ascii?Q?UrXUXqfMGfTkmwrzN/pQNQ+vxHvO9qbLCIOvX9HL8wHTnIWHbysdPFiYQxCF?=
 =?us-ascii?Q?3zUOZ/vYHjlkHm832XwgkUHEwjMKd/RXyznsBGOQDog2TmYnuD0iYMbH7Bg7?=
 =?us-ascii?Q?YEU7Y9XXV96T8/D2kUlp4SqFMw2Yrytuc8QJ5V1dbq+Dp8g1V7oSA8CTPDPX?=
 =?us-ascii?Q?3RzQkDVIrqyneq3aFmL+8RtqQZvArSeahtFmNJjul8g02CIM6nQFk6Smms+H?=
 =?us-ascii?Q?ANNELm2xUZX8tzuNcST495b2GrCBqwUpBsHODiy521A9EzrrVoTFNrbflcHr?=
 =?us-ascii?Q?FIz93GGNjSNrXEOB2dcTdPELvXyilc4pEyx97t1X1PzzsUwa7DYkjkEgL9IA?=
 =?us-ascii?Q?m7TZykAm6vK0v+0Ko3kkDxTnM/pRZFMmZlLAegewvFwzKahT74MuTTt79sgS?=
 =?us-ascii?Q?RobeDCSvvhv9UbM7ehPFPMSPAGKp7ReUGlAQpqTNCssVHcunMGu/vKvRLFOw?=
 =?us-ascii?Q?coC5Jm4jnV95YXPabP9utmlFFz4siRMhNpEYrWWliohGTwM6ohMDjYrEom0Y?=
 =?us-ascii?Q?yi/jSPdr0Or/5VwRLCHqugh/3p9Wy7slVEBN3Czp0iGEcOTk3hpdHinrIWOR?=
 =?us-ascii?Q?q3Ld137ZRbuaElbYhgvL/wrP8lczV2OrzqlyTIysnMDRggwb2Z3mR2uEtwSy?=
 =?us-ascii?Q?Vj5+K3dDraa5bpjyJrZCA4wUuTysuBJ45xYIJIoI+sip0JROc0c83FnYkuKH?=
 =?us-ascii?Q?cI3cYb9onzAnussVXZvuLTxw16kpXT3kmJYqr8ivnCEfq413AaOo5KPpT1b2?=
 =?us-ascii?Q?kpD8J6ns0ZB+HJgYZ9UVsLdWfHivdHzUsOv79l9XkSrcR7mCNIKDSvN1VrQN?=
 =?us-ascii?Q?ceq7eWcnyB8YbPRHdvq5eFWhCYJNbWSVPxdtutSE8+53CMG/d3QdaRaEFbTQ?=
 =?us-ascii?Q?ZkqhDfBVpPgVr+yY5vi8Eee5I75Hf/LFomP9zOeShHOA7CzNwT4SZRbkd/GN?=
 =?us-ascii?Q?QgOphPucMOLzfm0WlpugQicWn6crdl0UNXXXWIJJ8KDBflGr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 357a5f89-2194-4c18-306b-08df40db4358
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 16:37:38.3088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1W9H6/9swtGiAgIhYmcpCd2h0+PIz6kgCEyKtPaRXikqrP63HsKwmCkv517dcE5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8151

On Thu, Nov 12, 2026 at 08:47:59AM -0700, Dave Jiang wrote:
> > Finally, Intel actually seems to need Linux managed capture (Seriously
> > Intel, WTF?) as they don't have any other way to get the VCA, and
> > without the VCA the measurement signature cannot be checked. I hope
> > they still have time in their spec process to adopt the ARM approach.
> 
> This has already been raised internally and will be addressed. The
> TDX module will return VCA with the measurements. The host will get
> it in device info and the guest through GetDeviceInfo.

You'd be better off to do this via TSM directed capture like ARM does
than to store it in the TDX module memory and retrieve it.

Jason
