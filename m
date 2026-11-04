Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793800087;
	b=QDEGTOQ5XklZVoVKO7QntHJQzN3ygggjwoZ1P+HDXCyPzH3es8QwTVN5hTSCoyD+Dhkp
	 IwIlZ0A0jAtiOGe2OuVTAjUBjhrC8n0MDoaR3hhylPM/4kEb/Ynms8YIKp25mVvq73vvJ
	 /fFNE27Ahq+IK0huYvvQVKXdn8HHTB1LmJoxkM8HeyyBBkuNWV7N7P3OXr3F5+NHWVpel
	 B8ghTlv7gI0YcM9aasn/RDEIq9f5tMKHdOn/HEb1SKzQ8vRnbQJCZnSFaTGmxjlEZiOn+
	 hUArx2i6+lC2KEeHSmQTLT84gkGjWs3s41otiB4nuNaO9IFLhlOKqjcov2fVouEqOrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793800087;
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
	bh=svPIroVdCUaHgkci1AuUvKmou8kDsT3HCTYLpAj6fbQ=;
	b=JZIDnT4SiZiFrMecA8D4+ErVeGBMcxRVcDN/Iq5ql8q2GgqwdPfFSGjbuHoORmfJARVs
	 VmU9Vvkn5+XueqgfiTd9dKo7lx8wxBmsjLfA5seurlnvWoA95ecv8ARQbl3FGfPovBKXo
	 9C/ZGClgu6FQLKrLL0P2qd1Gxkg1dxSEsTdeo/IrhsFbxGNaQaSwE57HQiTOUIcTI1DXS
	 0IwYwrHjDY2Vb/XE4Ul8xA36IZgQQe+JfiSNj1EY1UD1Lcr/ye2mP4DYB95W1P76Xng3z
	 1+FhUTC7OHn6HLLfxDDZJkvqgxz5M2i2mhLP0y/DN2MPdcxft/zQEhYCz9tC0pipxXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="bM/5QyFK";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.2
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012002.outbound.protection.outlook.com [52.101.43.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BCD606A328;
	Wed,  4 Nov 2026 13:48:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93BCD606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bM/5QyFK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRH7Cka8Gfa7j3JdovAum1VaJZXCbBAB50PLZv6xxDS/aDLTZjNkI3xy2qrsqIVPsouQRrnl8Y9Wz3txQVNbrgMeik5XFcDxvh1t5h1V5O18U6UEpoERpTMzOoGz5nwTY/GjM4ml/7e2VkQnJiOdF5/RUBgspHLHUAlMZAQZ5gBJKMNyvHM9KNMHX/RFsl6P2rqlPiI3SaLVud5xsTwAhA5xCics6N8a9HkIXbfTdzcV8d4Jj3Bb5i0C2P4SY/8szxyKaoRJha6GyhkdyO4NCnrHHF2IUIArkQBJBuN+tcA3EtgI83TPlbnN2LjHucA7Oc6jTgsbB9D/b0pLuKF41Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svPIroVdCUaHgkci1AuUvKmou8kDsT3HCTYLpAj6fbQ=;
 b=UJ/ihBjOO0xqtfQRsYtvTyDN23aGs1g+lvy727MuTpijjavA1Z4Jyz1XeyNDRILIdBcCpGyDKL9iDMA1esCBK+SwZTmbsuvtqrUV5GNo1p84GoxFC76mt7rdcqPZGjO71mov9p4VkxX82He9Jp1BNgjHQHHnLtS3AKNwt27QKvupdG0oh8alCLua4UqFPMbS/vUB/NRSaKm4DwL3Db4/4fYKrpDoHqxgx8YTL2AQTo7c84AnbGvRJI4No9TOt9uAjX72K6S7vAX/GXq5RQLwULq7mYrJTabTuXzcX1uZ+wF0qfUnpq+uT2w8xfUqscg9USVbE87TROO0o6yuZAC6kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svPIroVdCUaHgkci1AuUvKmou8kDsT3HCTYLpAj6fbQ=;
 b=bM/5QyFKJx/JPBkBY+INtNfxQkHxQLCXk/QVpAeosWmXtRZ1uxJVkQgHGSURm8knHuRSEf/BeeBtKrmYkPfXVbz3YK50NrZsiP3rz8U0RCSpmLCfNkVbtFff2BhAqA1nhunfmnZX7IM0LZaUA7hFgGQlGh9MEbtwPZI0BYLcoUM15k0FfyDW72kEivnQmsU6JFpDfbkp1oYCuuHL431NtO6GAcich94g5xy9FEYMBPsTJejDvJ/jcAxnuXVsVNdnp9J7HkWqQZCdO02Nz1XJF5C4KNJhhIY6nUAstq6yc1XN4QCyN+B3eB0G5yQsi1jXaJuIr5t4harv7jwiibfUVQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LY0PR12MB888806.namprd12.prod.outlook.com
 (2603:10b6:404:234::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 13:48:03 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.009; Wed, 4 Nov 2026
 13:48:02 +0000
Date: Wed, 4 Nov 2026 09:48:01 -0400
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
Message-ID: <20261104134801.GS274202@nvidia.com>
References: <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
 <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
 <DS4PPFA84FA90FC858A44B5D42AB80471B0E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FC858A44B5D42AB80471B0E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0485.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::17) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LY0PR12MB888806:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d3e58a2-480a-411d-2912-08df3a7a3ee7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|10067099003|22082099003|18002099003|56012099006|11063799006|4143699003|261022105027099003|261028144727099003|261026121527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	EqCol++rTLBpTnQdEshTe5BGZ+zy4ry3GPTlMMC89Q3Sj9KMzx4OFCwE+OL2wR1EHrvI5JpkKLuDXTUO80yx/6cvVIA9kyhS00JO+G2O7ZX1O2gICtJGgqk8BC0xhI9DLy0XwLDaCgYbs5gK+MT+Qg7Ar7gl7TczmaWxPZQzQ8uqdv/fxvtiW1bdlmLv7p6gOIkn5eYHNGTQRHDObHjojv3aAXZoHxMV1Rci12dXJbFrrr2q28vVpNEuRWP5ya2PyChqC34gDdNDJRSpTtbuKnEM0o4Wp2IbSH9cmNHudcjB50ZjIS4/19FFsvrBrUXy0JXyLJmPH0E11VYQnnj+QGm8/otSS9JIoPVZeDnrwkVkmyna2B+Wz9XWi8Vq5MzIKANs0v5yNo/JBvfyzIu57hnGxeFOgTSY7EcTWQw7xAVujAUdV4Tr7ipNGDz73IjoNLcbfTYu9sYPUDIr0wRiIUAIEMa+vPPAvcScVNcU7KngYb0JCfLR9riic12DxXxzKrFI+f9QRtv0z9DvORtK3OhTBq7i6G+rn7XjGmU1+4epXl2/t9Y6wQSOoWiK+DI1WR9SXhAtpchc95pP6PC9/cWR3N2Phsztl3JxjGZ9yEwczl0zy1kZP81b5cdl7SCoS//mK6wOmBuYusPAdu6fw847j+4dk9PJ56INa/qC6tw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d2uLh5zZd91CdzDibE1yA/A+ns5EIDcPg2FuVRNkCdBVnuEHv/dChLYgR+ZR?=
 =?us-ascii?Q?TaEKI8lUD3/ySb1IJrpnhOxLZh95fkS3g1WtL7+tWmk7m1DILdAR7d+YJttU?=
 =?us-ascii?Q?oBIB/7pPtgSTP/R4aNJOVfZzWm8nxk9pTULE3Slq9xkpav6/al4dBBBHACDo?=
 =?us-ascii?Q?TsmzaYFQXZWUYMIK86Ww5kPDkSRGjSptVnJoNN5c9XiJzk+cKzd2WzCUzjjg?=
 =?us-ascii?Q?1MU4aikN7872FUw2cwC9chQcfzeDu89aoW/zzH5Q4VhTrUHywafOM5vXK+3Y?=
 =?us-ascii?Q?mg4K5tQR6Yn/TyyyolGfxEHUeP9w+zUWrfXiaRQZnj67ZG7YslUqg547t2hw?=
 =?us-ascii?Q?WWAbJh+fjj/FBjpvRTfvZvisUIZRHScp1zYd+naJjkAIz2o9wBWBd2QygvqQ?=
 =?us-ascii?Q?zBJgN118YxHxfYhS4hMKg2oYyZKnVvZunubW2EI0eTS/tyQNWQaPLpSIaIPD?=
 =?us-ascii?Q?tMW1qgGgA+gfe1OuH8LqJv/ngyTJu/azxHgt08z/8c9M2z6HtGdrUoV9cVKO?=
 =?us-ascii?Q?/nh202i/HO4xJuouBObRVQmZSNbOgvtZwsAiudg+AhKbVrWJNvYdLAnZp4Wz?=
 =?us-ascii?Q?t54tjUYmrv68dUAaV+hBWbVBaZ3pAqMI/N20T1ul9rY0/KDHsMWXcmRyaXcd?=
 =?us-ascii?Q?Iiq3zoCs1Ta7EyTYXOhyoTqCpVNtR1lc1M2teOS/9pUUeh1Aywn/3qHpMEMl?=
 =?us-ascii?Q?1bkg50uqMggXWWHVBrttvGufwXbPYpp9fcAm3Mn4yxvuQ4Z9Uime68T2ZdAC?=
 =?us-ascii?Q?9/KBQ6H1BweDEi9Ks8Rt2iWTHvBX+ATBrL5aLQBnhN5k5t7hKZQ8W9J9nMOJ?=
 =?us-ascii?Q?uXsDXsx41YQnp7w6py/SdviXD3z/iN1Vp2v+E0BK2V1U80zNEDgOkIO1StiG?=
 =?us-ascii?Q?VApKgjAUnKq+SzUZlgjGXXA2Msw62NlEQtiTsi4uPw5LWOWmTqWo0NHfH4kU?=
 =?us-ascii?Q?b3C8oz8rwFTtRbNEWE8vksk9vYjS7VPaErKGsQfuDfA3Z2yWhAFHtho3m8pr?=
 =?us-ascii?Q?BI6gWagehqwV/qR+ILO75uf1CvkXaYGduY9P+D4o2vaLUfwOYeJ4HfQCm0xM?=
 =?us-ascii?Q?hlyoAUOfnR0Ah7cMmaQo0NkTOM8tQe5xhov8EAB0vi2/g50sR9GrXtBgxyxs?=
 =?us-ascii?Q?X3EA0AHyOxQgJpxUwc57ptTThlewpM9a9v0KBR8UhyyXuyGW2HEWerIWJzJt?=
 =?us-ascii?Q?YPUC2O7KuO6YM8wcZoCOVvpojuyAJO4iWrC74zZMiUY+UrEkiEprlKWaQdFP?=
 =?us-ascii?Q?i5DRPJsahadEDL7N0gMQTPXJEvdSk4DjW1esm/g0JjXW47KXtQG1oHnbvjAp?=
 =?us-ascii?Q?GrG9TTDcHG4WgWCByGEVFmey7EIB7NWprwm2LdCMxkmPz9kAk8bIh6nyzILf?=
 =?us-ascii?Q?4ZlwgGrFjTWkHJoBiRwpIC3Z3pm/V91ioWZTKHqLgdb9ma50H/3DjSJdWFFT?=
 =?us-ascii?Q?b6+LEo4i30jIjVhdTx/XDj5YTZlto0cgxrH23Ue+qsrYJxmJorOMV0Xmkx++?=
 =?us-ascii?Q?xreb4Top9MuVnYh2JnOs8Yh+M5uRG4zW0je74dqVes5RVDBmtXvhQ+qMTerv?=
 =?us-ascii?Q?eVOxb0yCNmbVTTcuGapURYRvXubB6j54AdnwaQsmM7YeoNNHRVrA1cmtSdKK?=
 =?us-ascii?Q?D0j6yMBBeXRw7TPEklWyfGcmKMvtoLSLWKdavucnFqsuGZ3B4uKyUYoLXVIx?=
 =?us-ascii?Q?LagylIuaJh64f9DgXBQ5dTJMrTFvH3zcudZyO24yMeG4jVSo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d3e58a2-480a-411d-2912-08df3a7a3ee7
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 13:48:02.6462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: coySdfkzo5yisTVrVcCvG83yKJ9xCuXqq5tbz2303f0M6WRR2IwlbT8nf15IcDAE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB888806

On Wed, Nov 04, 2026 at 09:03:20AM +0000, Reshetova, Elena wrote:

> > There is no signature covering the slots in this case. Userspace
> > tested them blind without knowing they are actually in the device. It
> > is not ideal.
> 
> Actually you are right, I re-read SPDM 1.2 now and realized that I forgot
> that the final key exchange signature *only* covers the chain selected for
> the authentication and not the whole message exchange (including
> GET_CERTIFICATES).

Yeah, exactly, I was rather surprised by this too since it is such an
modern obvious requirement in crypto design. It got fixed in 1.3 when
you opt into multikey, and you can patch it with CHALLENGE on 1.2

So, unless anyone knows otherwise, my feeling is we should treat 1.3
multi-key as the target/goal implementation and make 1.2 look more
like it using CHALLENGE. Working to obtain the end goal that a
signature covers all certificates userspace sees, and userspace does
not see unsigned certificates.

Jason
