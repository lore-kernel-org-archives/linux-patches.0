Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888F2218AA3
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409971; cv=fail; b=Z0H6ppDiVuXojVRrhpmN4z4Onx9/2goFwFUZWPYAbhvtqTfFC/AB6ZL5YRT+DAS4Q4vCUfsCfwJbYVvq5YZgjzkPk5bp7m1lfIe6XTHySn1Wjh06bmYgZF0dT642ioPxmvU6a371RLRKHMnVY5D/nMfltwmtl2JBfqHhQVfLNhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409971; c=relaxed/simple;
	bh=EHHjFYh7qMHfWzC1EYePAFQkjOmOBASDcAB4OCWnsgc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XGgtRKWmOV/6+y7Vtf3d4/b56ctfPam5UFnXK8QVO/SEwd9rj3OPkFq64UN+kKOEyx/EdCrHHAnLyF+kbHOMtMZu4hMXUDSCa08u5qxFI5MOnO+CEItNbd5RITmP1ktDo9gELOBkM12ocA5l5TMWooAmeHkCWB+1PiIoIQyz57Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P4Z40a5Y; arc=fail smtp.client-ip=40.107.237.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P4Z40a5Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RGRevFje2KYpYY3oNYKlu3x/gYUGiwq4vI9Er0bCVDiPeqWL9uI66z3f1EKrMj9agDpgYAkse1JfhzYMg+YurTLFGh76uroRkKSWXJwcX5QZml9aYeALxiwEcQ5BvBf3+bv+Vq4Fv4gdmLkjpSPyjSmUPLPXcS5956LE23VaXFdV+7PG18M2/58fVVC1V0HH0XSrISevy32esl1j1SeT5aTrIS9eZX1y6VJHXFSEOmLiOA8BoCTu5WB59hhfEcLnk7DSOQ0f1Pk9GYfjwNdWXcRLoiIDlsKtZVWvgaR/TIWM6egIeGcLjzEJMz0d4ZKCBqOLddvz1d618qiWFa8ilA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uejSUKhqCKx9uojTcGi7PXZSpcUWuZit1BhiZVEPAak=;
 b=v5itCeU1ZJKBeK9ks2RUaa0dn2soAdYsxn/exDzQJpvEqMOP46Z5ZT+b+uqpowre3uHklpgNhmdYyiebAhCT2yA2AaJ2c6+2pVu1CU/j6GHQMktmHM11NqFJcb1S8cf4TOejaRj6kA1G09BKksLv/Idz0EvEEG8PkwL//NDBxYE8g2QO9x9I8icbzE7IipwSbvTAd8liGTTfBLWINEUnXjMabQGv2gilqW8AwamgTjAFDctoda3KuHwxtplckAvckf5aV/QhJlXgZPpFMB4KjLHnbSxc0ysk4rVe1Otq26o0nyNWuerV6IpKlyxIqJnlG+/VvBKFsf+NYHqXLnJL8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uejSUKhqCKx9uojTcGi7PXZSpcUWuZit1BhiZVEPAak=;
 b=P4Z40a5YrvcTYBgEnqcMuM0N+X5kN8KMtnHBqrraBvf0vzE7seQdBN3NK3zUSOw+wN2IgjoPg7/LrKk1DtD+yRKzEa2luNWUDAnQP2Yntof2Z8VqVVL+sr/oTroQcBxXiWyO9gbnnXXrUB4PSmVAY0i55pgAYRZ0lPMqCMfH5sABlPXHMQ/D+Yuw7BzR6x1GtbmQmrUpuT8jLyzHIVcAgIEXNDl53ZghdS6fZ0e2DwkRJSSI6m+1SMGEAe/DKj6el6b2a/j5kq8Jg41kKEE/QUSXiqQ6V4fPqGlyRbY5Y0gnLlaXKJi5q+lfhM9/SALNk/Nd1hYGvPPV/HvEL/TbdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by BY5PR12MB4212.namprd12.prod.outlook.com (2603:10b6:a03:202::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.15; Thu, 5 Dec
 2024 14:46:02 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%2]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 14:46:01 +0000
Message-ID: <97b972f5-e368-473e-81c0-d241e9ceaa92@nvidia.com>
Date: Thu, 5 Dec 2024 14:45:55 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/817] 6.11.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241203143955.605130076@linuxfoundation.org>
 <525de045-eab9-4346-b4b2-b2111eac38ff@drhqmail201.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <525de045-eab9-4346-b4b2-b2111eac38ff@drhqmail201.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0025.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::18) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|BY5PR12MB4212:EE_
X-MS-Office365-Filtering-Correlation-Id: b0ea26f7-37d5-4888-a4a3-08dd153b89ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEVUSGE1VFlra3IzSC91eFhSMStXSEdHeUFsbk5tR3Q5b1lxSk40UFJUVm5l?=
 =?utf-8?B?VGV0cEF2bmd3bHRTWWZQa0IzSy91TE1aMFhsUzhEdDBucEVhRUpSVHFaYVJq?=
 =?utf-8?B?SmxlRmR4YVRGS3d5WVRQY1ZSa0FpckVDY01FLy9rNktwU3YzREJEWXFHMkFz?=
 =?utf-8?B?bCs5SFJvMVFLNFdUWkZIVFkwRk14Y1QwZnRvaDFiMVp4WWlSNUd4cExoQkhz?=
 =?utf-8?B?MkNwM0pHbVd0Y0pteFdKdHJ3dndxYlpRRHJhZHIySmxsVXJoYzdhNzVMVzBQ?=
 =?utf-8?B?aEFTaWZHWTN4bWdlTEpNcG15MWJ3ODFtRGhlRlBXeVNoR243TnJRZWh4b1Vk?=
 =?utf-8?B?UEpKd285QS8zZlN0alR5RWZmQzVUR0VxOGdmK09PNWRaMnN6OC93blJ1TFNU?=
 =?utf-8?B?T3VCUTRKQTNpYjRJcFdGdlNEdHk3UVQxeVp2VitrUW9XQXc4L2M2ZHNjcjI1?=
 =?utf-8?B?VlBHTHVYM1lwaVY2RmhpL2xGS0FGTzg3aDUzS3ZITTVtNlh1cUFOb2F1L2N1?=
 =?utf-8?B?elBTdjlkQ1M0ZTlVT3VXUkVWamJpTzFUQWdXSTF3WnB2Y1RhQkhhaGErKzV1?=
 =?utf-8?B?MkkzRmNtajNjY2IrbU9uMTJIM2FxWkRDRTBXdUNhb1JsVXZ2QW1OK3h4VENw?=
 =?utf-8?B?Y0R4OTAvQmMvTVoyMEFzYUpDekZ6UkJSWC91RVdUWVdSa2JJb2pLQ3dudkli?=
 =?utf-8?B?ODhyc2RrTTg3NDV3N1BzYmxFS1VVN3YxaitVdVZ3VFhhaDZweFV6K2JqNDFx?=
 =?utf-8?B?ZjdkczdHMHYybXJBdHpzQjhBQXJzRVAyVTJjaFdRcTJwZUY0ZFRDWU9nM1lp?=
 =?utf-8?B?cGFTdTZoZnpLZUJXK1JUOTEwSDZGODlNZFQyZm14MmZLV2cvaGpocjFkbkJ2?=
 =?utf-8?B?SC9leHpHSVU5cHg5c2NZVDFNc1JFZEh5cEFnUXhHOUJBenRmeTRaS3VnYmZR?=
 =?utf-8?B?Lzk0RExYNWUxNDNUc1o0L2xnamJ1U05zTnZaZDVOUGtkcHpQbDN6U3lnejhG?=
 =?utf-8?B?a2doYnRId2o5V0UvcHp5VXAvWTRMQklWZ0dFZ0FnUmNsalp6UXNWaFBySWhY?=
 =?utf-8?B?Z3c0SXhUNFE2c09mQkQ5TEtUV21hclNKTStFWENRTlNUZVBRRU5jcFZqQmND?=
 =?utf-8?B?OXArUkFyV0lZYTlSVnpZayszQW9WbFMyb2hzZzRKK1RqUUlOOFo0VVBXUkts?=
 =?utf-8?B?QjU3TGsrcmcyTElYTGRkeVZmK2tiek1icGxMcGdwbTVUN3ZGaGMwcTZzUTlW?=
 =?utf-8?B?dktmbVIwVVJvUWs3M0xSSjZ3UlR3eDVYVzhvd0duVDRsSTBBbGp3Y2VjcnJO?=
 =?utf-8?B?WGU4c21RaWszQmdsd0cxdlN0ekdSQmE2bk93NlZiWkJSOTU3R2NZSHJuOXor?=
 =?utf-8?B?R0hGazNvbzloQkZ2WlE1bGxFSzBhcUlRSisyWksvcjg5UjlscG5SLzhQT2E1?=
 =?utf-8?B?bHJoSGluZFFZOGQ2RGsrcFZ4YW1yYTh0eGhhcWg5eVpHWkN2dWFkMkRZWitp?=
 =?utf-8?B?THdZSnc2eTdySHVKdzlteE1zbHFtckcramxPbmFZdlBwdGlKcDgrR0RCQ1dW?=
 =?utf-8?B?TzdIVW9URmtRYlpvZ0wxUGhWaC92Zm9JbUtZWlhlOEgrZlJ6WnpEZEprMWdr?=
 =?utf-8?B?N05aalY0cFBBZ2F1emFVS3hlY0hVVzhyRWE5SXhpdVcvcXNaUkM3bnpvQ1lY?=
 =?utf-8?B?MWpnOUYxRmg2Q0k3dkx4MXpzZWlFNXhnSDR4MWY4UkUyVmZiQkhkbmIrYWJQ?=
 =?utf-8?B?R0t1MGJENktvYnQ0bm9nMFdoM2ZwRE5aYWJOUDZ0a3l1Zk5IRFE4Wmk2S3Nv?=
 =?utf-8?Q?7KVi2gXXiW6HYYDBPKYefHqTJIRLWHGLpz0NQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U21lVFFUMTdOTVljbjhxZzZOdUJ2T3hXTUUvZ0xWYm5HaXQ1eHoySDQ1RFpt?=
 =?utf-8?B?cVJYU29UVWgyaEt6TWdMajRNTWkyQkViV0wxUURnMzN1Nm4zdnZHWDFCZ1JZ?=
 =?utf-8?B?VktTemI4NVovQ1ppT05QNFNic1BHN0hjMlkweFFTeWR6WCtyWXp0WW1aQUpl?=
 =?utf-8?B?V0VvRHNyZ0d2cWtjQW5pVGZsa3Y4ZmpCK01JaXMwZG9aZ09WU0YxUUJvcWFa?=
 =?utf-8?B?eUV1ZnBpL1lPT1p2UzhrNEFoaFR5VUV0cUlseUd0VVNNUExtUFpRYU1YMTBM?=
 =?utf-8?B?T0c1MUdtY1orNUZTOEdZTmNCenkwQnhlbm5DZmRwWlc1UVdnZnpMQklHc3pw?=
 =?utf-8?B?M0RHc3gzZ0ZyUGI2TmcxaGZKTW80REIvUTc2b2Y4T3U4Z29HL2JHOWdxUzdV?=
 =?utf-8?B?N211TllYMXlyOEp1SzJKU2c3cTFmOUVhK3RHT2doM1h1UUJEVjJ6ckRlalRp?=
 =?utf-8?B?ZEM2ampaWjNJM0RsVDA1OUlPcUlDRk5IZWJhZXJlK3dib0FqcUNBRlFPSCtj?=
 =?utf-8?B?eXZPRUNpK0ZjMmlGcUhjZkJKTktBSDZLcEZ2ZWxnTXJwcEpiaFJhNEpXVmZY?=
 =?utf-8?B?am5TR3RMK1VEQlNFK2RUUzRNUy9UT0cyamlFOUpxQUt6Rjhad0JtU3lZaEZC?=
 =?utf-8?B?WURxbURDTWZGMFZ5YVoya1Q0aldpeWtHbDVEQWhET25LMDRTNy9GYVlIMU83?=
 =?utf-8?B?ekxNbXlUYTFUYlB1VmJjNkFFTzFScWNBSFJsRkZWdUp4RVlzYnRlNkI0NnJm?=
 =?utf-8?B?elU2enJTV2xpK010azBzWTl5akE4RmJlM3FjR1NBclFUK0ZCcDF4TFZHOTEx?=
 =?utf-8?B?VXk3Q1YycjZjTDdzRHZrc3hNcFIxMlZPbGlHcnBSdHMrRjdZWjUvZFkvSmp5?=
 =?utf-8?B?UVYxT3A4Z3NCcnErbFpTcHBGa0RvZjlUaEdqalhXRGg4VkUxSG53M2NVVGZ6?=
 =?utf-8?B?eFZha2JIM2YxdFNnNXFWTEtCcE5yOEpDT0g4ekJUNFJhd2VEV3krUHFTQWZk?=
 =?utf-8?B?WThFb2p2bFBZZmVHV0o0MGV6VFpTZHFDZEptc3pnM21VV1I4SmNzOWNTK1BP?=
 =?utf-8?B?WUo1YzFnS3JIakRXcmZJZi93UHVOZTBsdGFZb3c0SDN3WDBFWDdQRkJBZWFH?=
 =?utf-8?B?U2M0UmNEcCtkV3B6YThTbFBHMVdTR0dTcVNHbHdhTm1JeE5CVVp5K2ZKOE1X?=
 =?utf-8?B?NnI3SWpNUFBoeE4xcnNqOU15cng1d2FNZWh1a2JvZkY3WFBNZDhLUmJJUWdD?=
 =?utf-8?B?c3BPZkJSYjdMOSsrSkEzYkdMbXhMa09nM1hNUjNKWC95Q0p5SnVWZ2NlZTg5?=
 =?utf-8?B?SU9scEQ0VjZTbDVRaFBBZ2lMdWhmV01rODd5R2NQRUU3QTZjNFhleFk0eGJQ?=
 =?utf-8?B?UlU1cnVRSHAvS2FiN01kUFVYMlYxV0gzR3JoeXJMa1doU3lDRVFlUjd0YXls?=
 =?utf-8?B?cEJaMWpoQXk4MU9BRXlYb2dpOHJuR01kMnozaWo1V2wrOC9SZHRQaytjUVNJ?=
 =?utf-8?B?WkdqQ0MyTUNwTW1ibkxCSTllRnYrT0JoT09HYnpQdyt2b2N2ODYrOUhpbWpG?=
 =?utf-8?B?M3hHME1iZ1BlQmlwRmpEVlQwQWIvdEoraUZwWGRsalFCZFVpd1RBRWlLVzBs?=
 =?utf-8?B?aEVNOTlMMG92Vmx6TlVORWEwYXhZNVFXY1BqdkZwb0pPMjh4OUw3Z1hFdFlB?=
 =?utf-8?B?bklIOXM1R2xKTkZ1YUZ2UWtHVHkzYTMvSEtib0hod0RTcXRXdUpJUGVLc0Yw?=
 =?utf-8?B?ejZPMFVHdGZSUWRCNWZpM0RKbTlPS3BBMjBFVzN4ZXlydUdYU2JCU0NEenV5?=
 =?utf-8?B?bjlxbldwM095UFpGR1JwU2RiMkthelBPc1pEbEQ2TWMzN1J1a2k0SFNLNzVp?=
 =?utf-8?B?SWVDNXRKbGxCTUdKWlVDOERMbmtRQTBJN09NeExtOTRGcmZScWhsQ0NWQ0pm?=
 =?utf-8?B?ME9EVWpBaHMwOVMrbUlUWlEzQm5JbDdZRzBsQkUwNnNhUWZCQ29rLzk3WXhh?=
 =?utf-8?B?WXFGaGQ3NEhsT2NFalNNMUY1ZXU5ZGp4d1dyRUw1czNiUkFIZHV6K2piSHh2?=
 =?utf-8?B?Nk01MDBNdDRaK2ZQeE0yTVZFdkpQY1hVVHd0YkdzdXdKQkNLQUdXcUtlRU1F?=
 =?utf-8?Q?aAX5z65NGLqapqRS9BoAmscEc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ea26f7-37d5-4888-a4a3-08dd153b89ee
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 14:46:01.9176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rCggZdres+KvQsIDUmFi5DzFbLS4WBgPosTpG6ydibYhs3bJ90dKdNgV2JJEcQ6Clkorhi05z9TWeyp7xhmU4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4212


On 05/12/2024 14:39, Jon Hunter wrote:
> On Tue, 03 Dec 2024 15:32:52 +0100, Greg Kroah-Hartman wrote:
>> -----------
>> Note, this is will probably be the last 6.11.y kernel to be released.
>> Please move to the 6.12.y branch at this time.
>> -----------
>>
>> This is the start of the stable review cycle for the 6.11.11 release.
>> There are 817 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 05 Dec 2024 14:36:47 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.11-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.11:
>      10 builds:	10 pass, 0 fail
>      26 boots:	26 pass, 0 fail
>      111 tests:	109 pass, 2 fail
> 
> Linux version:	6.11.11-rc1-g57f39ce086c9
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: cpufreq
>                  tegra186-p2771-0000: mmc-dd-urandom.sh


This is a known issue in the mainline that was not caught for Linux 
v6.12. It is intermittent and so not easily caught. It landed in stable 
before this cycle and so nothing we can resolve on this cycle. The good 
news is that a fix [0] has been identified and once in mainline we can 
backport for stable. It is a networking issue that is causing random 
test failures when running with NFS.

With that for this update ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

[0] 
https://lore.kernel.org/netdev/20241205091830.3719609-1-0x1207@gmail.com/

-- 
nvpublic

