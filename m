Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413DC28D832
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 09:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749031059; cv=fail; b=lShjIpAch5BxUfBfuMIlB4crAIbZneKK/motdPeFm/q1DBhzjYrdOzsheIH4OK/oepnmJRW0dw3iC4YQaIx37faVVNd/uP68DM/pj6EgMsvjOtg+Fn0GUA3xiPIgCincfi4y+kgcdGwKdk7jK68rauHVnd54wX793kGrDOhBn5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749031059; c=relaxed/simple;
	bh=d0gkLhF+fWFFNKD6Pv2y8MNkkhYVwHc9ejdBumeIUAk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cXQG22wobLaQrx59R5uEWEW0dCx/FUfMn5qoVKnUoWbc/WBgAYI25YNCD6ZIQDuXkcgRp7wG+rWuVcJLcnQipysl+RoC07w0Mp6ghlB6KOfQ/HJdVO4or3RC2uPEUXbdGBJCIvDUrdWJUpI/6HdJg86D06wZuR1NeJa6kkcLLLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=urTbpm6r; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="urTbpm6r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PB8nTD89rXHAry4XJIWhPH0k3BlByiuTZakvVReyACYBVEfynm64AbG5oNqs9y82RlWYNhsPlTiUUhF8lPpHOl3IRVPse8k/g156Cr+0oqyYxqwajA7byGTqyTyZBtYxODXe7NoAyvI/HKcpP2eYK8ZgIpzLsFy6Yn1LuyELjBoYW353qj3Uo7+xwqF7B4Z9w/jUe8B0VpqC0l5eE/lZG1nBDeQ1WnNvrGBEjkEfi0dRG1NTQWiNvTHsSdGWVLS0x3pYUhh4X63FTLgjx9xPqvOe1dlkQir1u5CkShgLKntgpWtDFTdATFNo0SGNPwhy8iOKIPyNqYWjTcNkZBFfGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIP9iaPyzX1lsuw62CnUqlP2AIDnjzEDxk6PvyVa0gY=;
 b=Q+YaVUSD2LheO5HzuNHdsxz/6Sx/Xsth4XipCO0hp62be0nZCApjRyS1Ae7wEDl6wKRjVBWhjs0137e+K8uovqyxMr/keHSbjIxdZNUEwN81gjOGp2LGQi1DcgS1vIZ2Q54Z0oEtJJuewUkAftde/Kx8wwnEWKRJz31jljU3bp20y4Pt0pZRLjX1H0y02qzgTop8lH7gAUQkbCMb6AA0sqCajbWNe/QHq5EDY/bO4jb4SchyFI2nY1Yq0kPG8vTnZ7wNzak5dgDOYhFxUd3csjCmmEnJrtt1J4JgyQAnRgNoN7CCg+r5WeQMztCL7OWt6LbD9G82dpNza9yXOCEMdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIP9iaPyzX1lsuw62CnUqlP2AIDnjzEDxk6PvyVa0gY=;
 b=urTbpm6rzTXiahY66kxgdHWx8GTgeIrbTgEz77GrrnA7TosOvuNaAG+TVedDNdwkQuHdv+HFmL/sOzziAfiFw+Ak5wonByG4YiizSbLSyUoEfjr41vS8GOvD1encZAwylZ/RhOAZ9lXvowmwUDiymGyXCh4Su0EwbEOKrQRZylMuRX8fwOdz4mok2T5crxgjxGBVXMwDuDVCycydLOme7cATKN8o/fcueeO2LHZSyFaDN3JvhrFJ5hv2d4QOGbRhs7ccqTJbVeD0qpS54GXVtWHhJjqBI+x5bFeELKZTaqZpxoa1TZmefJJbpXX/mgh3ztfy2mdRPj/SimW6zBbPdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DM6PR12MB4138.namprd12.prod.outlook.com (2603:10b6:5:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 09:57:35 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8769.037; Wed, 4 Jun 2025
 09:57:35 +0000
Message-ID: <bf1dabf7-0337-40e9-8b8e-4e93a0ffd4cc@nvidia.com>
Date: Wed, 4 Jun 2025 10:57:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org,
 Aaron Kling <webgeek1234@gmail.com>
References: <20250602134238.271281478@linuxfoundation.org>
 <ff0b4357-e2d4-4d39-aa0e-bb73c59304c1@drhqmail203.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <ff0b4357-e2d4-4d39-aa0e-bb73c59304c1@drhqmail203.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0030.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::10) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DM6PR12MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d8725a6-92f4-41b1-0d57-08dda34e3b23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWM3cmtDaW1yQXNYQ0d4UjdFWkpwcmx1WTNPcWp5SDJIZHZ3cVdOMVBTZnFh?=
 =?utf-8?B?Z3g4NkdLbDVOMUdreGpDTm9ERXU2K2dzb2JNd3NkRmNEMlVYWlFOS04yTENU?=
 =?utf-8?B?UzcxeCsyMGwwUDNaelNFMWJuL29XZjlIanBBaW8rL09Xd3VqQzZzV3JIbzQx?=
 =?utf-8?B?YThZKzlTWW5hTTRMWStIVkZuVHA0cFhCbjdqSkVYelkvS05rNjB4RExQNGxy?=
 =?utf-8?B?cWJqN2ZybEhvQU82NG1CSkpXNVNKOXN5Z29wb1ZXQ0RhUFFyNFZoWDdmL3Ux?=
 =?utf-8?B?UGpBT1Q5eWVyQTJQOWJqaFhQVzhaNlRtUDNLdUtFdXI4SXdHVXgwZ0dmcjJN?=
 =?utf-8?B?RWNUMGRHYlQ3eEpXVUYwb2dSdTVNUCs0WGFXdGV0UDhoWHdSOXpLeDRhdFV5?=
 =?utf-8?B?blFWUW1QRkRCaHhETW1LaXVtSVZiblB3NXVlT3prV1NPWjVPb3FVekQ0UkZN?=
 =?utf-8?B?WHdtaDZoa1lPdDcrV0ptdXV6azVLRk1qeWxZNE03R3ZhZU5lbUZEbmQxZ3F3?=
 =?utf-8?B?NENLM1d0bDNsODdqcWZKYjNBVjRmeUc3eDlrdkhZYXBHbnh1ODZZbHpQUEZI?=
 =?utf-8?B?TkYyOEU0WU53WDlrd2U2d2orQ3U0K1V5cTlxOUhHMlgyOW5NSjhxTkNPakpv?=
 =?utf-8?B?SThKU0xMMmswRE13SFV1ZmxjQTAyV1c5QXM1ZVo4b1J4b0RnTVlHNEJLUUJt?=
 =?utf-8?B?Undna3FnWXpTM20vZ0FPNnVwU3pYNTVYMXhCbWlBcXZWS2dmTjQ1STRJdVl2?=
 =?utf-8?B?ajdGcENuaHBPOVgzbENZc0FMb3lVTzZPTG9TVFNRZHJVa2J4Y1VWS2xNU3Zj?=
 =?utf-8?B?YVgvM0NZUGEySG1WM2VwOHpQVVduVTNqQjFaWTFhekhXMlp2b0s2enZVZG53?=
 =?utf-8?B?NGNpKzJ5eW1aY09FZURyMSs1R1dQQ1FiVG1WWGpac0k1V3VIZm45VTlqd1Ev?=
 =?utf-8?B?ODkreWkzRVlkbkw2cTNyQ0Q2VlR5empEblIwbmYrK2dqdVRNZ0thQjRYSjB6?=
 =?utf-8?B?dlF6NE9aNWRwa0Rmd3pSa3F5WWVBU3o3RDljSXgvb2o2UXVsM3NscHl1M1hz?=
 =?utf-8?B?K0xjUjBKYS9IOUppTmErKzFBdHp5Q2FaeFFYcGFlMmRZSTE2eVhmOTl2WnJG?=
 =?utf-8?B?aUFSeFZwLzcrYWtNNy9Ga2JaNDRvcndNcWxQa3ZxUWd2QXRLbXVFKzhVZHl1?=
 =?utf-8?B?VVZIS25GNXREeUV3TE8zK0VvdklQVng3MXRpWGZmRFptSjJBM1Vqay9mc0Ry?=
 =?utf-8?B?R0VsYXF5TjlUSGtROHN3T1RuN085c3pncS80enZFSklpdGhuT1prZWR4bGpE?=
 =?utf-8?B?eHNFSEJEZW5KWDc4VCs2ZDd5S1c0YXdWNHM0T2RMUWE3Z0pKNkQ5UGR3TTZB?=
 =?utf-8?B?VVpvdjNSZVBPTkNzTFllak44aDZEKy8rZHkvVENtT3pmVXNWeDdjTlc3bEtq?=
 =?utf-8?B?aXgySG1PY09XU3VCMnJMZ0NNK3kwTVA5VnFhY2FySWF4ZlB5aTNBdmM1TzZT?=
 =?utf-8?B?UnY5aURidkZySTVSSVhZdGNtbHQrMHdKTGxnajNwUTJwZkVLM0NTZm1lQzBx?=
 =?utf-8?B?dWtoR1NGdDFiU1JKM0dHRlhpTjlsWjNaUEM4ZzZXdC82ZDNaSDRVRVdBWjlG?=
 =?utf-8?B?eWduWXVDTnlkZlNQazFZSytyamJ3cC93bFhRQnpZNDlZTXJmdG5Xdmh6bzFk?=
 =?utf-8?B?Z1lNdXMzWHFBOTBPME5ab2lZckFkTFI3SHhMcUJUcEtHbVJwenh3dHF5K2Ex?=
 =?utf-8?B?R2lMQkJXZU15UkdmQVJ2ejNaVStQTmpNVU5jZzhjRU5iYTVha2RHWElDTUow?=
 =?utf-8?B?NFowMGcwQ0RGTkY4bWxYb0NQWThiNFpuc3VRaUhLT3BrU1RDVVAyc2VpbDZD?=
 =?utf-8?B?c1dBVXRiQ2JhZkNGL0taakJBMDhOQ2VpOHc3RC91aU85dWNuMENvQVZ3aWlI?=
 =?utf-8?Q?x08JdcylxMs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THJsVjBrODl5QnBuOTQrcG1CQXVMdktPY3VSczFUalRUOW1kdUdRbTFPZGlz?=
 =?utf-8?B?WGhhYWNkbzY1UHlkL2d1Q0lnMThzQUVVZ1RIbzZ2Tm1udUY2aFlENTB0YXlw?=
 =?utf-8?B?bmU0aTlsTUpmOXY3aEcyWG5tRm9ZTWtwWksvSThwS2NhZkFuOHh2d1lKempK?=
 =?utf-8?B?SHl4ZjEyQ3FYYVlkanZwdUowb0dGQ0lzMS9xR2k5dythYUlIVS90eXVlWmxx?=
 =?utf-8?B?a0Jadk1aanFqTzNVYnFZbmZUQUJjK1V6Z0V0WlRXbm1wamxheHRISVJZZ0E0?=
 =?utf-8?B?MzdxRUxQZkpoeG5ndTM0OTBLZlhEUndDYjU3a2VpQjFHdWJlU21ITWVaazVs?=
 =?utf-8?B?cGY3VGZmbHJUTU9VcG1BcWNyQTBtSEpXYkRFTEQ5ZzZBTjltTThyYzlabzZQ?=
 =?utf-8?B?K1hwcUt3d2w0ZjRlSTRuWmlndXpHNnFZWWtIc3hLVitxNmZDN3FOU2JJSkZt?=
 =?utf-8?B?VnZWS1J5anF3ci9YSk1WaVIrby83VjF0bUs5RkNsOVhFamJlWnhFTm9zRThW?=
 =?utf-8?B?MmtCQU1KayswaUt4T0JlRXhYZ05XV2ZZZUo1Z2ljMU5PVkJyRW91VVFOYW5T?=
 =?utf-8?B?YksvZ21qNnB3cUp2WFRMWUJsdzFkYlV4UFduYmlJUEVLL2owWVROSkZDVW9E?=
 =?utf-8?B?SWpSN3dEbmQ3cGwrcldnMGl1RWZMK1pJOFBSWUU0VTBMTWVLRmdkZytsRkY5?=
 =?utf-8?B?d1h3ME9YcDEwejB3ZXlPUUVQYVd0MUFZa1J0WThFcE9lQ3pyalIvYmllVTJX?=
 =?utf-8?B?bE1GTDR6b2R2T2l0WGdTTDZhTlBZRGxRRFZrMzNoY0w4OWJMT25GdHhOaWc5?=
 =?utf-8?B?WWVucnZaOVV0blVCQUtmZUphMVR2UFk4bHFUemVSRGJCUzl2K1NDaWlxU0Fw?=
 =?utf-8?B?RjFraXVYZ0ZnTHhxai9jazVkVGRBUEk2UEhkbWtSclhwNDRSektGOWNOVkxj?=
 =?utf-8?B?TWFLUjd1S01pbjdNdUZIVjF2cHkwQnJtWXAySi9IeWNaTmd6ZE1QRDY3NG90?=
 =?utf-8?B?dGFXbmhYNDU1bGIvaUhRMWl2TUR3NkxFN1FHVnJoS0gvYmI1NUFaUGlHZ0FY?=
 =?utf-8?B?T1RDZis1cnQrMVJaS25jb2tHVkh6T2JxeTFwelk2clh0Z1FUWWZIc0lxdlZT?=
 =?utf-8?B?K0hvV3IreFpGbDdudXdCVFgzbWpQVFJkcmp5T1dEVE82Zlk4MjUwejYvdEVt?=
 =?utf-8?B?bnBhcjFKbEN3N1E4a0lSY1dkaEZ0czJQa0p3TUJnQ3JFRm81SVRYeEJyYVhB?=
 =?utf-8?B?VFUrSExiSjRMLzhpYklONmYwNkU5TFNVQ3hHd1dFc1Nock1Jb25pR2xoNzlv?=
 =?utf-8?B?aVFvL09rOHlKTmJ4M3doZkordy9ibnpNM0Z2cVo0V1ZPWkZKSFErTW1WM1R3?=
 =?utf-8?B?VEFWOG9HWjJmbFV0UDBUemNqVzV4RGpyT1ZOd1pIWEcvMFJzNkhpdDQvTVNO?=
 =?utf-8?B?bk1MamdCMWpjeitlTWVWUmRMeTN4bTV3dk5ydTg3NUFsb29vQzJ2d3VwSW56?=
 =?utf-8?B?ZTlqamRiWVB5T2ZyUGJXYkh0SUVQaFF1SVNjdFBoT2lxWGNwN0NjRElGSUJF?=
 =?utf-8?B?MmhCM1UwN216bGJNaUZBN1BlVVgwbFU5V1F6b2NjTmk3M0FabEJRRXVTNlds?=
 =?utf-8?B?eDVSTTdjOFBBZkZlQUoxbXV2Y3RRMUIrWFNabGNWSWJlaGRrMmhDWm5jME0x?=
 =?utf-8?B?K005M0tacXFnMWxxMGZwUmRja05BbkJFeU9YUkdaQi9DcVNwVjYyZ2xuN1NI?=
 =?utf-8?B?S2p4b21VMXBCcnltZ05pcXZHVGNxZW1DRHUwa3B5T3N5dkF5aC9OWFVuREIx?=
 =?utf-8?B?bW9Ga3loK2M5VllheGIyZHVWdWtMMTFDaTNjQXFVZ1hkWkRrT1JmeWk2a21V?=
 =?utf-8?B?MGg1ZzZYeVRmS3pRSnkxMDIzZmUrK2YxSzc0ZjU0Z0ppaWkxdHJMRDlhcXI5?=
 =?utf-8?B?YnVVcEtGUy9UKzMyMkluL05HVkh0Vk1MY09QMURoYlZSM05kYnlpU3QyUzl0?=
 =?utf-8?B?S1h5alNuS2d1NVlEMndoZEoyMmJxRlJFbk1PbEJjZGxvWlR6dTRwek4yUkJO?=
 =?utf-8?B?RGV4TitIaFlTaXIxR3pDNm9XUXIxcjJlbXdybWl2OHU0R3RBS3dHRmc0ajFC?=
 =?utf-8?B?d0dZZzRESWJYWHJKcWRlRHZiMGhMOFJuNnlSSTZKUGdTeTc0SVQ0U3lKV2Jt?=
 =?utf-8?Q?Qr+3PJFecSsRiWwuV84Hxz2I2b2YD10Ol+mwMTVZS+VO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8725a6-92f4-41b1-0d57-08dda34e3b23
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:57:35.4166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66C7gh9HLsVtU7UgPn2muxZi2B6X8aFPafIOIrBVpwmz5hzvSGRMhsEm4xVWdxQRxYocXaR2lgqdqD3JU1rxcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138

Hi Greg,

On 04/06/2025 10:41, Jon Hunter wrote:
> On Mon, 02 Jun 2025 15:47:17 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.32 release.
>> There are 55 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.32-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.12:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      116 tests:	115 pass, 1 fail
> 
> Linux version:	6.12.32-rc1-gce2ebbe0294c
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: pm-system-suspend.sh


I have been looking at this and this appears to be an intermittent 
failure that has crept in. Bisect is point to the following change which 
landed in v6.12.31 and we did not catch it ...

# first bad commit: [d95fdee2253e612216e72f29c65b92ec42d254eb] cpufreq: 
tegra186: Share policy per cluster

I have tested v6.15 which has this change and I don't see the same issue 
there. I have also tested v6.6.y because this was backported to the 
various stable branches and I don't see any problems there. Only v6.12.y 
appears to be impacted which is odd (although this test only runs on 
v6.6+ kernels for this board). However, the testing is conclusive that 
this change is a problem for v6.12.y.

So I think we do need to revert the above change for v6.12.y but I am 
not sure if it makes sense to revert for earlier stable branches too?

Let me know your thoughts.

However, given that this is not a new failure for this stable update we 
can handle in subsequent updates. So for this update ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic

