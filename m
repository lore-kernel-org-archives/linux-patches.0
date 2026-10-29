Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793293862;
	b=L5D+G1cSbb6yGyi83hhjveSX4WFCUUG+lDjQuLkvLTfdinzrrdkx2QAPagEDZkez0Cra
	 ghlBlAoG9V87tn5MULBWzPdL8nNrV4lYONAXBw5g4k8qy2dCFdlbixjE9BnNlcLkeYZet
	 cLpULQ2TLFpto9XBoroXZIXf+BXvu+VWQUngLA+paArDI6Pbnu5VUxNIy14nFrGaQmXfG
	 7eXYl9o7DysIXr9e19kdwILx52l0nAJRQRPgv6v4t/JHgn/tmqL+56posxO26hQmY48wT
	 Y4pZ7KdDF1tTrRfrzN3jOabKxIgmmnGFVuCEZxiip879IUeMUI7iy28ED2+Wxss60Fw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793293862;
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
	bh=ulIBxbTRLlhkPO2q+Ks5G0FbKyxZtAM5GsZr+3ycBgU=;
	b=izH5RjH1fkT2zYXGffQMPjPTRmfskN+BLp6VqLWbJ/Z/SGUQZ79K6EcKj02ELqpOC9r1
	 FKXOBmREMZgTUPi4ReEEH08ad3FMhaAfFIQPHikVdehwUntEJNTMRCCcDMd3CxHwbQKS+
	 gyqa1uaGDOQwIeAscfjtx8jAjmjlArKt0QJZzzFgfttOz5Pq7duo584k3/tpWNGg9X4lc
	 8OgERbgSMbgBQG2IlMo5yYhYeqHiN8OaWNU6Wa336xJdXC63kh4tvTS0Ydd+hTvuwMg97
	 yArRmYs/cJel1drfK5PGLYRd2BV9JHBaCYuP8f2R9Z3HIe3RL5pUlQy4yPSz6EmkGJg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hMubUU0M;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.42
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6109606A31C;
	Thu, 29 Oct 2026 17:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6109606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hMubUU0M
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tgBOtb0iBI63MASq2b/xyWWQ69Y8pdGCHfBob3GVZHVk9/S/dbe+ktBspaJt5i60TfcpictauI4irz6l7pJszCcBrZAC3i8eVfPgiNC6CKPxzy0Am0Lp7DzRlvc1X77KJo6ruUqyEFGBcDvSfYLTvNoDuzYpO4kICtL9dybkk7fHUzcyzG+6lAQnlBdeo1UVbppv3nlamLtF238j1TzcFtuReiUZgRIH/b+qHw+F+bgp85CkQa8gfonYGm8jhVjeAXIJ9iakoe6UUh3eKdaz93H9Z0jb73txYmFsDSsy74Oh4+dtnzAdhZTf5BmABzgXOy7eMOzlN4Q/hyNQlhDw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulIBxbTRLlhkPO2q+Ks5G0FbKyxZtAM5GsZr+3ycBgU=;
 b=sretYZxgVQT4meidHzlX//VWnEaPZBMs7mbNb+s6R4ijmzijFrH6nX6gM/bJRLiUqWBWc+jVD5yh+XAzcxeYOqM3Z+K/v9QHuS+wcjhYsca5BU74s10ak4BUmc30pTjG2K3F2GKQ6F7RZKgy3jZn5/lFq5GNLS1YTCMalyr7VTxdRagfnSOeGY42MT8hFlqxoOGOSAlWsqsBa0DNHNFegk0FvjDCUsei8gCC/0sv9+LlIQAjNKhyZVa2TTl2ZvPAEmMXQQNiuYGp/dwMwRk+zaebG6zFMbdIONqsG2PQWPFmVhuAmHXuz89x+SKcY/hkLQEZrfoM7h/eAiVa8HY+sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulIBxbTRLlhkPO2q+Ks5G0FbKyxZtAM5GsZr+3ycBgU=;
 b=hMubUU0M7N302WvqVf9lbyrxL1MWPhCkkChE5VmbhAkZxSoNee28LU6VU9s1pQHYbHS+cw80AiBL5OJw9tQ16mj+5CRuhgfkCBmNF/vfcGFAQD6lp3uKEj7ZEm7ZtJPByLzIN7JFkYeZwSDe+/sd/iGH5lmU4SILi2DvgP9YhQXgvK9L6TAPj4wTun4O8cv/1oOei5aH+JFuKcH0DeQv253+DY7zuJilt5fJkMro0dqbEnOxgppHDQ3yM3OZ1gnSOBeJOdBOTseWOI0NCREgKBmDd7sW/oDKnEpw/NmFV3p0mairFLcODk8bU7Ie6Y00SFIDueQ7fNunZGmhr16vFQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by MN2PR12MB4110.namprd12.prod.outlook.com
 (2603:10b6:208:1dd::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Thu, 29 Oct
 2026 17:10:56 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.007; Thu, 29 Oct 2026
 17:10:55 +0000
Date: Thu, 29 Oct 2026 14:10:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>,
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
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261029171053.GD3734323@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
X-ClientProxiedBy: BN9PR03CA0509.namprd03.prod.outlook.com
 (2603:10b6:408:130::34) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|MN2PR12MB4110:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c441fd9-4a7f-4edc-d43e-08df35df97e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|22082099003|261026121527099003|18002099003|4143699003|56012099006|10067099003|261021121427099003|261022075727099003|261022105027099003|261021135927099003|11063799006|261026140227099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	jGwFUScuEgo117mbkSCEaK8l0Z++xpidHPeiI+VUHdQ6B78FlRaiNuazj08Y8Hl71Cey0EIce50wtVIusi4AgtKYnJp/hXAPDDtuLC2rGXenupfDVQtSLXr6CEkHQnCG6KVal2hbQmhhGVJ7Jh1YRZVSYQoQjDgNpd8ZVWIklo/h5MT8CewDda6GgSsa17ugLtbXp31j53h/j2cKESjJv3sHMXCgISDbVnzhA81bPeLpBBwLeRkd0l+ldhJNxlwio5mPEca6T3NiXN+4Q4TU43w94bbz/Ud7xROVQcMtiksr67eVa5+KxJLxYcmnKHyF8V2wdwNCE533ZEeljMExQkiKq0DSV+cDPbk0zakZ06G7UgUBpCxhcwCg3GQ6+uzoNFVi9LwepwL6/2z10eKGUT07tMnHvD7NnMmYyvPrWoiSITkiXQR8F3zOELmuXRIcGMwc3EqXa5BD5XdMQtxAnUi7Oy6X78O6Jxf0sD6bhMOgNiT7r6L2D7XPJ9dLkJiTJRO7H6E8zRsH90m3Ulp/xQEKshZeCMGsI+paeuqzct67oR7YSyBsUuQnheKvvQg2ohMjuENUH/RdFh4fa4ICOPhvPYjvtf5xArA3Op/p198LUeEhHPNR19USDhskOO0TXQhBuE9SCg7tN1SB2IadwnOlIaECTLe5Ikt1KfhmDy8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(22082099003)(261026121527099003)(18002099003)(4143699003)(56012099006)(10067099003)(261021121427099003)(261022075727099003)(261022105027099003)(261021135927099003)(11063799006)(261026140227099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iAM0dYUXYaW0NFuIJKPbu8tFYUY2OBQcvww8GKkrpyFHNOBhMhZSFZj4vO2U?=
 =?us-ascii?Q?r6BYg9E49/Vn7MqMacg6A/9WF8IPA2skNPGMN1K/CIzdt/ND6v+ApsyNDvgX?=
 =?us-ascii?Q?DjTIN3r2Dv1RZ02pUtOMfKSOnSannHNxQK9faIT3FRFQXax85euVOzQMGS52?=
 =?us-ascii?Q?a01+Bz3S2xYkqY2PQehWAYMkL5ZPfwEvOtE5TgVJK9TJhqKkFuWQn30hjLcf?=
 =?us-ascii?Q?m/3rtOXSVoN/88sqcP299G+3NJCs0GyA9PEhrirHkwivbstUz3miOra+rh+k?=
 =?us-ascii?Q?iaQixcxBeoKa8Yz4ztzxk2AML1iSLun6bB0iu291veeUrJuJ9Fm8bw8vOPSV?=
 =?us-ascii?Q?fCTkwLllErpJrBUfOnv53GBzuXWlDzYLSvsBpYlCp/xNpBkURYXo/6f/IJ0E?=
 =?us-ascii?Q?At00D7Mfhl3551ipGApT2FpOHt0NirmAOC8Jlu5991xvjiLldISV9m54DjXR?=
 =?us-ascii?Q?a3ZleqfWPTG5AXDDLRy80v7Dn++yNdPy50x6rYtpyY/3N3G71XafIIX+QsVL?=
 =?us-ascii?Q?yk8lqdltxoFNAgZmDF6zO1gNuXtPliMFszAO0Xk702D86Wl293d8nXGbiI+c?=
 =?us-ascii?Q?PXYBcc82iWUaZ62fV885F5yXbZr7/s0H5hSl4/+qitCaqUTgUS9h2wPPO5kg?=
 =?us-ascii?Q?OI/rGwTdT8I4Rqwf2aKoVPRfo+UzEiT6ClYZcjVorKl4rQRJoZLd09oUy1eH?=
 =?us-ascii?Q?A4ju8kN/iphoW6VnD7rAGt2xWuVYyHkttdvLGtxDg6MDOUmImHLy3cmMQGt8?=
 =?us-ascii?Q?SFTFi+N0XdeadwWMJSCh3T54e9SPgjpeS/r740x7STQikXMBtnlJ5WWtmaFN?=
 =?us-ascii?Q?RfgAvPyiB6oIzuTEUZNZmV3duDX1G4qQLZLs293NIy3PTNAl3ITswsQZI30H?=
 =?us-ascii?Q?Kz0yPNjYw+94y4yn1U5Z1v8GhOTQbUqFATd6q0a8EtPLY4vAPw1v60sJU/YW?=
 =?us-ascii?Q?MVhcSN0J7DdmCLG1t9nUsNzFPugO6TvMColXTv3gCclp7oPTxPjQj0OiooJp?=
 =?us-ascii?Q?rvBuoAAfoOxujhh4rzjNRRK/kCOlnSGtBhaJgJwe2+k9y5QTJ3hAL2RRhfMN?=
 =?us-ascii?Q?qsUeNns+lt6x06H/wKmGvRVedq7w/CVZYXg3vojUfiPdW1rccH0SbAirPcUg?=
 =?us-ascii?Q?zaL9Z54YnLtWAjJha/dNJ6keM2qcFa4y2vlOq/vXiLQ1C/Qyl1NwDgh78gum?=
 =?us-ascii?Q?/4t89deN1WNHr92le7wvldhmiscxr6x2JWri2ARGWSMrUxOCE3IWZesQTXNv?=
 =?us-ascii?Q?2LHh6flz+f6Nx+1AhH7NGKtnRoQrgoJTzpNA5BUcH5tjZ6sgZ7u6H5Z3Z1iG?=
 =?us-ascii?Q?s5C6oYEp4+ys5vL07xT4ySLEFv/AfVviWNAKjsnVQUVz7kRAy31Bjj/Bh+l/?=
 =?us-ascii?Q?sq0XXqTpDG3fAyw5AEjQryqzYWK+G3JLTq9tsoepDrQ0vM4WBt4M/6GIjc4e?=
 =?us-ascii?Q?QWt7D8SNdBMTNGJ1Qhx0TeCtOznwZKGyZLxKdIf1+ypvIp/9Si7XRJNWfJgT?=
 =?us-ascii?Q?G6AwydjCDmvW6zJ+SwMUOUFPXxbuz6RFYQWqKEaGSD+I534J2zzKC72za9vz?=
 =?us-ascii?Q?j7sMq8IWZkbD7h6esEP2gusj9ff/sDPalXL6UPBNUyW9iZtnPmkWcQ0oFmqj?=
 =?us-ascii?Q?5WISLhsePqlX/IL4UqcTRcsPhmT5fA6P7VvDubAV4o4+voo1h0EiUCZEbYfA?=
 =?us-ascii?Q?mK3uvcVVM4+P4KThK/VNamWFytiNUt9ClKOJDIUaq6WnL0iL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c441fd9-4a7f-4edc-d43e-08df35df97e8
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 17:10:55.3338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ulssa7o+Ug6FR49tV2SJhvg3aPr7pm7RWktF4+qDkRn1ezasgd9//uvuBxrVeshB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4110

On Thu, Oct 29, 2026 at 09:56:26AM -0700, Dave Jiang wrote:
> 
> 
> On 10/28/26 8:26 AM, Aneesh Kumar K.V (Arm) wrote:
> > Declare certificate slot zero as the CCA link backend evidence
> > capability. Limit connect to PDEV creation and slot-zero identity
> > collection. Copy the chain into the PCI evidence cache before publishing
> > the CTLV device.
> > 
> > Complete public-key submission, secure-session setup and stream
> > connection through evidence_accept after userspace verifies the chain.
> > Keep the evidence snapshot separate from the RMM communication cache and
> > release it on context removal.
> > 
> > With AMD converted in the previous patch, CCA is the last link backend
> > that still establishes streams during connect. Now require
> > evidence_accept for every link backend and initialize newly connected
> > contexts without active streams. Reject link providers that omit the
> > callback, and remove the legacy connect-time session and IDE exception
> > from the API comments and documentation. Connect remains required at
> > this point; a later patch allows shared-discovery backends to omit it.
> 
> TDX Connect is another one. The TDX host link [1] sets up the SPDM
> session and then the IDE streams in its connect
> (tdx_tsm_link_connect(), patches 27 and 30).

Yeah, everyone tried to do it this way, but that is what is changing.

Do not call TDH.SPDM.CONNECT when processing the sysfs connect
operation. The sysfs operation only establishes what TSM driver is in
use.

You call TDH.SPDM.CONNECT triggered by attestation subsystem with the
slot id provided by userspace.

Don't get confused by the similar names :)

> It can't defer the session. The TDX Module runs the whole SPDM
> session setup inside TDH.SPDM.CONNECT, and the host relays its DOE
> messages without interpreting them, so there is no defined point to
> stop after the certificates. The chains come back in the device info
> only once TDH.SPDM.CONNECT completes (TDX Connect ABI Reference Spec
> 2.1 v0.66, 4.2.20.1).

Yeah, its fine. TDX will have to do what Aneesh proposed for ARM, and
use use the Rust SPDM Driver to operate DOE prior to calling
TDH.SPDM.CONNECT. This will allow discovering what is in the slots and
passing that information to userspace.

> For TDX, the chain can be checked after connect instead. A connected
> link doesn't make the device trusted by a guest. The guest still
> verifies the device before it accepts it. Could evidence_accept stay
> optional?

No, it is a key part of any crypto handshake, something in userspace
has to acknowledge the SPDM session is "Authenticated" before any use
of it progresses.

For these combined connect and IDE flows, "use" probably means
allowing a kernel driver to bind. Ideally once we connec the TSM there
will be no driver bound, and no driver can be bound until we accept
it.

This probably isn't *strictly* necessary since userspace can sequence
driver binding (assuming that doesn't get removed), more of a safety
sequencing.

For a guest it would mean you are allowed to go to RUN (or maybe it
implicitly goes to run?)

Jason
