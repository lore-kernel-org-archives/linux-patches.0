Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793366150;
	b=sz5/6Y9K7kho3IMVTxs8fR4FqKgj37Mq5RyHOCMGhrt5+T1JGVKbnkFhRTzbrFkirnYO
	 R9Ie0aztbMLwDWSeoq1PboMeTD3xPuHRP/HzPbO8E4pD8uTOBXHhud8jqMYCAEhe7lDMO
	 Yk6FOhP+UWKdmKZX2YphcgeyAuXSrRCQUQjQhQPyMhYCi+x6Fdp2uSkaFjcOjgc2bhuhN
	 g4F6UybsQniYxfLROnjqqp/Aq8sImQF4klv3PdbG9Jpi+peJ+v94xSsdSFXy7uT5dO5c9
	 ron/vUbmyJn7qnJ+Aee0iSYWZDgrBPJ5JPh3HW2GDfsxR28gsBKyBWFQkqAbRqcXoZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366150;
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
	bh=7hOOpjVoBDj6NdoSaby34FzKo7i+iKlBHK11oxIgdcU=;
	b=KMhAFMnVBA0fqCH29pAypxN2drbpI3HcdKXZ+QcYvruS/Ee8rR7EhoVgO2TXHTne9NvQ
	 zw+fL8FZnzr41/NSxBMvez+idDgMw/d3clDlSfLKs17UNL5WLfagLb20SEzjDEEdMtCQV
	 zdQZl+ADiqk/kwhHP0wppwCanB8vFrP6fep1p1hVYRVXspO3KBWy8T0xTTRKJNzrAfryy
	 /K4UOC2LVcRxq2XqHNzXPKsjWmjcch4DUJWL90kHiw9O4lOW0FK8aLnqckFMs76n/yKOS
	 NexQlghUXNJaNjsCd9QMERPWTEYsIzgNXPdZmqVC8/WQ+bOAWXTjvSUk0ofMhjNOIew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CTGLev2Y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.31
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010031.outbound.protection.outlook.com [52.101.85.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8363606A31C;
	Fri, 30 Oct 2026 13:15:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8363606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CTGLev2Y
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i0RSIiKA2dGcW8apDKPe0WdyX3uqvAydVYBSohr3/M9X4N7Fqp1U8YD78MWPBaBf/oY3wHeYMjaI0uGE0oaezXjF92SFSo9Vuu1JODIjzRxkkQ+IV5HGi8Ad/VAqVHyXMIM70YOrim86wR1wjChRV6qjiZIrglCdN/V4BWU/Ouj6PehwV1EAzJw8NZOhc/yVGiy1Y3H6jczdwQ0Jve9ky1AionCTE2ySlf/W2iC9JLrhllnhKD3D/ObFjhZ6p21SKYfQb8JsE7S2dFi3zmPCVzOYd62n88itRzHgSjpejIBLNZqRkJrII3zVtuqwxwcFwFV6BeCCQpmjI5i387tAOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hOOpjVoBDj6NdoSaby34FzKo7i+iKlBHK11oxIgdcU=;
 b=tXhRIPpaejKDfz+FrblXMU/6yhoueWRs32ZDGCPGqG+i7uKTMe8PaJlxuc66kGZ9iJ9y/kwOOBboc3wK/Qq/0M5kstSDVbDgLsVD/u2SdF884Pd7UWxC1ijqPj4mHaq8jJX7nY/sRlHeLwphdKI/my+SYlJPRk9BGvA/Uz4tXeUnWXtJjK6vfDDZFdjVebeux8Xnd9bc1ehe4QzUdxwByVvyFAKbpReUnYyPSJqdZkI85tNcUh9MZx2aTfNB18Lr2bz1l0NZX5gO1jcUIOZnD9DbHSczhqzzyCzaGXTF4rtOlj7r9ZWJ0wB2B4/vxzH4X00XdjmF6bLgkNOj1AxI8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hOOpjVoBDj6NdoSaby34FzKo7i+iKlBHK11oxIgdcU=;
 b=CTGLev2Y9xy3Q1PxdS4TQbN6+ZllXYz75UR3VC4slkI1U+CqQqLASY0wE2xYceAIaVyabfNv+URXqA/agNjmPPHh2MpWeb5OXIQ+BMa9cct1AYrUu3t/d+D6t/ETu3AgBfOeNNh3cvLRm84S0dcbblo48uCqzO+JudNctPcvjOG9lrgApzzD7G+fV1PLmvl7PgYrKkJ2ECaT3ReY5i99tVb6tqHqh1omhKuVqfjATqmfuq8wZc5hYpPGvoAKiWs8I0pbesl0RabwpaTaMUaroc34kIR48j6RP5SlZPEJtu/Ls571NR792eLYLWEoSqIfhEMcFNsCiXh6dM0jMtav0g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB7916.namprd12.prod.outlook.com
 (2603:10b6:510:26a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 13:15:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 13:15:45 +0000
Date: Fri, 30 Oct 2026 10:15:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
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
Message-ID: <20261030131543.GH3734323@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0451.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::17) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB7916:EE_
X-MS-Office365-Filtering-Correlation-Id: 51b41835-76b3-4d9c-7251-08df3687e7e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|22082099003|18002099003|10067099003|5023799004|11063799006|4143699003|56012099006|261021121427099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|261028144727099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	InOoW44j3bVLFfdWh2eq1ZM7mfwFX5YKRYeZGsJwpGkaVewZ4vYA8v2Uyp3HiXn+MdduE9ZNM4P0pYCQrfntQ0qAkrV/WGptoKEHdp7YFTWdkBov7+HYbBdBHG8r7K4mYmbk/NWXQZxmKOp1/QLdSQ3s023BJjEXwLa0kxvctfrKhNlAYTKGFVUJPxK+JR8+tyEvOo3B/t//LR+JXK7P+eKtt5ZoB2hRH2KB3wFYlF+Wq8mkKV4zEvv2hnmJAcYPAzP0F6ldG7Q+8sAhBJQ2RPjlpuKmDvqk9zZIDHiWUwZshgNjiltymZj7XCw3tPeRSYBGtnry7T2j3bT01A+rOVH0Djw2ElSV0dJfiwdqF05FBxfNk7dhxOneV3GO5vn9qHPjRYJBQFD5UsG51lYkH/ONny5gbd8+klwyGf8nBd619voJgMLg3R8ommLB7zUQkTIDjkZeWq20Th4bP778XEPG3LV+KTCAYh7Ru94p3qsOMQBhHkQTG83gOX3pOdjZtOKJx9FtUlkEwEWgSm4idw3WVVdSnj8dMVdpUYK7MpgMtiZ2YU6TabbbzNjKOEKutN/WOh2VJgiwKJhGIkcbJxYDswCDFOjnPl5vGQEBsdZEe3SIlE9sR8Z01w4eGAP5Ix2lTZ27CT9htL9OEOXKn6gYjebfVBkzHD3Y036rcaQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(261028144727099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QU36ZadDEOnYRnHZjAEhebMFXYfYlhslz8O5AyNi3LTzV012i5THiEjiuNtN?=
 =?us-ascii?Q?3MNeSfrlmN8PQ/8DgDteXrSmHaJRZs6O0M21LoIoBxHTu4DCERgUlPNA77nk?=
 =?us-ascii?Q?X8XVubnhyUdi7OSnxBpi0yNZWod3id0TGJbrfJGs1o9dtu9enp0svXN3jZHu?=
 =?us-ascii?Q?uTx3kr3KuQ1nroVSOLc0sUctXvs3tbwKS22SynXVZXRjx/Ot/kjf4wtk0q7T?=
 =?us-ascii?Q?9X1pwBuhKmnITzgUT0lxd6L80Xfq4mt/V8NfssDCvzHX+gVgHZVuiySKuOlb?=
 =?us-ascii?Q?R3/JAkVxZn3P2Y+WsEkiloTUTY/e1xRiGYAjt9xtTn0UPihX2SSEjBB29N1f?=
 =?us-ascii?Q?IVyG8wckaSwnJeRb12KDrBHSl5cHI6AXFLkoctITNnJ1ZnJP08ffXN6Tql+w?=
 =?us-ascii?Q?4XiuxDQavSddCBG5R0nmKU18dj5li+nrrVYEYYBG9/EUj/SCY6P/Tp6tgCpE?=
 =?us-ascii?Q?pFy6czo56RsafL7268fdYL+ApcDSSu7z5/3exAA+cZkTCJpP224vEdj+F3C5?=
 =?us-ascii?Q?8zwdeb3snPpYO3Net4AKzk1ERnhgsn0SXxQN3Vb+dGxO/nLCro9hssATEtaf?=
 =?us-ascii?Q?YJwn2cvmPVGoMpvfQ+ZLEtoq50fEW7/IKX/rEJ2K3QUsBEv6m2pr2FO0ZqQg?=
 =?us-ascii?Q?x7xx0eWFROzYcKRLF9Vwks0bXVoGAqYs/Ad/RT5HHozh2Z2SlBfbRXFNABpq?=
 =?us-ascii?Q?qn5UVsL9vqtnowkv1PhOBKEV2fxcF4aPxu1FUuF5Rb9r/VmJEG+/WNXp63Lp?=
 =?us-ascii?Q?OeNtujgzo8Jn+mG+bgOhC++6P43d/49K9EYJeEVlp4B78o6UV2Kq8HH3Ytry?=
 =?us-ascii?Q?QXE09X5TcunAFu/M2fWtBmtSWeKvYUVLXdhWfrkk8RfF3wKl9Mr1AMiVhdxD?=
 =?us-ascii?Q?ZePuYPr8zxsMEqEgEdVmBpkECwrhqBmrvZOGKjUE1YHwGqfE0C0DIjJNPH5U?=
 =?us-ascii?Q?5x54eayX/RILuOrJwAqOj0ErzBQmpf8c3nIB82jXmw62sWJQghu9ewIPPW6c?=
 =?us-ascii?Q?TrB+Xh5RnWbfvamreMmoIb8xyqJu0tLN3VEGbgOfSTlPxH5iU6iyQOTDL3qK?=
 =?us-ascii?Q?h7YCeuM8WZP2kwlI9HVjdtY0lTqREqpya8P3OLg7VYPkFuNialmppGDS271o?=
 =?us-ascii?Q?qDWvWeOzP0Eun1DrdW5SmCq+GgdfInCdbzmlyHb29C5piviHg1nF3GtlKzfa?=
 =?us-ascii?Q?mpzu9RApDAoY/PKEAhLzMle2q1g73a4MplG84BbpplXe1YUFzQWYQupYtHHd?=
 =?us-ascii?Q?PYTKsaRUGiUFQuks2cpW03jH8wWtACoH3EZPv+odr3lKRehw91lioyioVMwH?=
 =?us-ascii?Q?1HJ7cgrVZIpdGMtOLr2ZA5qtrbhiTZYDTCDe2r6nstrmLWl9E0n7KjoL1pFg?=
 =?us-ascii?Q?xwVo/v7dLWxV3XhprLKWyYzUuJN720HpOa+IyGKvVWurPGYtcMKk4t4n1OOP?=
 =?us-ascii?Q?4F7+p3XpDUoRUDsQoPGu+njFLikimOzLrhHUuVAPck1DwXmyVVYI2l1u+rZU?=
 =?us-ascii?Q?iXIINUWwjtV99y4gSJFyrPirjmf0Us7T4wYz5U9D5/Ie/zbtTMCjYbXZLnMv?=
 =?us-ascii?Q?i8Bl4doQyjDhe5Jsz/ucOm9RsxYmLCCmLI8iHerVUPgyck9FdcbXgwQl8pVd?=
 =?us-ascii?Q?o7t2wUy5dHc1wsY4nI9UUWABky0Y+yZP3zRkfO9SV9S9johfXT+laQIVY+tg?=
 =?us-ascii?Q?ZpVZ8pcw+HzMfQj5G7t+diYK2e4855M3hXf6ipc5sDmaHLON?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b41835-76b3-4d9c-7251-08df3687e7e2
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 13:15:45.0234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oNhZMkUeBhgN7QzNX21AF/NGSxBp53NxxMsjv7jlUQvQY9FYtagrDwL0WRME0e9r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7916

On Fri, Oct 30, 2026 at 09:58:03AM +0000, Reshetova, Elena wrote:
> > > It can't defer the session. The TDX Module runs the whole SPDM
> > > session setup inside TDH.SPDM.CONNECT, and the host relays its DOE
> > > messages without interpreting them, so there is no defined point to
> > > stop after the certificates. The chains come back in the device info
> > > only once TDH.SPDM.CONNECT completes (TDX Connect ABI Reference Spec
> > > 2.1 v0.66, 4.2.20.1).
> > 
> > Yeah, its fine. TDX will have to do what Aneesh proposed for ARM, and
> > use use the Rust SPDM Driver to operate DOE prior to calling
> > TDH.SPDM.CONNECT. This will allow discovering what is in the slots and
> > passing that information to userspace.
> 
> I am somewhat confused by this. 
> 
> 1. You are saying that prior to establishing a
> secure SPDM session, you will use unsecure DOE mechanism to discover
> available cert chains. Here you have to take into account that anything you
> get at this step is not trusted. A malicious device could send you any cert
> chains from another legitimate device.

I poked at this with AI for a while.. While nothing about SPDM slots seems
particularly clean it can be made to work. It looks like 1.4 improves
things meaningfully.

> 2. Next, you will choose a cert slot to be used for SPDM authentication and
> secure session establishment (slot 0 initially in this patch) and allow
> everything to happen.

Yep

> Now, who guarantees that a cert chain that you saw
> at step 1 for the selected slot is the same that is going to be used
> in actual SPDM connection? Who is verifying/ensuring this?
> Kernel? Userspace? 

Not sure, it would make sense if the kernel can do some of this with
rustspdm, but there are alot of details here that I can't guess what
is best.

AI tells me there are a couple of reasonable ways to implement slot
selection and avoid downgrade attacks:

1) With 1.4 match GET_DIGESTS and MULTI_KEY_CONN_RSP=true
   1) Do via RustSPDM:
        GET_DIGESTS / DIGESTS
        GET_CERTIFICATE / CERTIFICATE
   2) Userspace selects slots
   3) TSM module does startup and also issues 'GET_DIGESTS' as part of
      the signed transcript
   4) Confirm that the digests from #1 match the digests from #2 in
      the TSM transcript.

2) Do slot selection and use CHALLENGE to prevent downgrade attacks.
   1) Do via RustSPDM:
        GET_DIGESTS / DIGESTS
        GET_CERTIFICATE / CERTIFICATE
        CHALLENGE / CHALLENGE_AUTH (using slot 0)
   3) Kernel RustSPDM can check that CHALENGE_AUTH is self consistent
   2) Supply the certificates to userspace
   3) Userspace choose a slot
   4) TSM does KEY_EXCHANGE
   5) Confirm the certificate of the selected slot signs the
      transcript from TSM
   6) Verifier confirms that the #1 transcript is acceptable

   I think this is weaker than #1, but not that much..

3) Do slot selection without CHALLENGE and then do it again after
   establishing the session to confirm nothing has changed.
   
   Requires TSM to be able to return slots after opening the session,
   CCA can't at least.

It may be we simply don't securely support multi-slot until 1.4 spec
support in TSMs. Per 1.2 can be flagged as less secure in the API or
something?

Jason
