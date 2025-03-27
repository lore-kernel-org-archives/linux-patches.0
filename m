Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2046.outbound.protection.outlook.com [40.107.212.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A319216393
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743086122; cv=fail; b=c96Qcka4DXHB1IuJLs+dfgALFCYMqNgLhF0tG39aronxBT4pjbjIrykud7Is92kHzG85oQJBDeKqWqs1+gWF1z/ksiFSr91aQzv3AfneA+bBEKkm+lSauS/qrqur4x5Mc9EXS5qOBXBLrzxMFrLXyDMshn+hJEN7XR7x+uy1MrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743086122; c=relaxed/simple;
	bh=agOiiP4ytaqoMRoQSE9ygSOluV/SlMZJXl/FEz/8dRo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sYUlvtlcTIhGycnXyCAQmMkfMy86QsNs5zlCtGHyCGONlsTYZf0lSQU5Zlw0ATUWmJXijIF/71Y0kGAZ1dmLEJ3nKLQu67+QBUe07u+ZM41w/2Vd7IuRcIcI2dajMTpGZ1lHPJLkUcHNINqzGYpOHAO0eQaftvisZDRoz2BDzIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L67BilFi; arc=fail smtp.client-ip=40.107.212.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L67BilFi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jKQrEdN9W5T0c+lH5Xptr3QUa9z3Kj4SGU9GUtVmObqFcmIlMTd2xaOeHjt4OcQ2k0ZjOm4o78MiyNR/8FmaOeqUxL+IL5ZyF91OQzAaQw6EPsEeZFWed5bB3IcxIFylrqiC2Kewgzm5I94GwZ0pVuD7w4W9a3pnRsHb8VjiooEmmArgkZGcQ6515vVJM1NGNP5ECm1e10SE8D0Isl74HEPPHV2G3nmy0tl/XhZ87v1vPBbDKhHZnbRS2KbHqDrjffkBZNxXQlQjRObPO3Ipy8O1OLw5Wtg2Ev9RnTvDoEDK/nkY6Wl6iC7Wi5h60TqRMdQubH7GjH0VucuTXN4ZtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmnvjtlhgBX+yEtC+oW6zSIQVHzaDEzSrIDYGlyuZB8=;
 b=eLAEuglcLO8VZYkg+YBxdZmqY7Vim4OxZs9+HXQ/tsC9V+vyCmjR7tx50zs/x5YyuO4KwniQrLjbofpl8fPdi1xOJezqHhyjnOcYT6leZHcHxlfDqCFepC7kajvWVqZN+f6GWriEpn/fxPVG9HP+WhoyighCfxmRo86zcfcO8GRDVa0o4HDgKObGp5UB9imBrSBX2N6qzUUowIW/NIMqat2GT9fZEs/YTeQIMmN9IoJgd7XO5hc4+3hoZOowHDqeDh8/U+avoogN+R/g15Nx6yl6fx/qjNzxcRHMCsWh8F9fmkS9vPm4x9EhlDC4AkEad20pIxWyZrki3OHQ5qxeww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmnvjtlhgBX+yEtC+oW6zSIQVHzaDEzSrIDYGlyuZB8=;
 b=L67BilFiAF6ctnJJlnldphgEg5kIG3Kua8NgZtp0W90Ntq0Pol0k5Q55Dpf8C8afzgOX7zbZ8KH/5xV/PGBnQRgIuk1eeHjoZQnDFxj4nNuxwF5sIGwjd+wa8/Mhp67Tlwfi6Q7VnXjl4o2g4WL2FsVXRzhWTTHEVpD9cY0GPIFjE+fjGtgIUhkd+PWKEmMh10zU6SGzml6A6ZwCcCf98xOictqX+PMpLzsZ6bUwZIqi2F3tcMBOhFDU/ANJyrQAyuhFoIspu9qSLjzbY2hbxxvbOCZoy9N2cMk3K1DFtnJ39BSzfDcsTmb55gLsmohaecVNByauXGaWvC4fPc67ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DS0PR12MB6656.namprd12.prod.outlook.com (2603:10b6:8:d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Thu, 27 Mar
 2025 14:35:13 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8534.043; Thu, 27 Mar 2025
 14:35:13 +0000
Message-ID: <a2814133-df50-4251-b397-fbe734df6196@nvidia.com>
Date: Thu, 27 Mar 2025 14:35:06 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250326154349.272647840@linuxfoundation.org>
 <b93abaf4-1dd5-42be-afa3-539172fbdd77@drhqmail202.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <b93abaf4-1dd5-42be-afa3-539172fbdd77@drhqmail202.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0665.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::16) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DS0PR12MB6656:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a0772c9-9f51-408f-8e67-08dd6d3c9552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHEzdGZPTC84TFhTVXkvZ0xRRUJPMWRWdmhpamRDZnY4VUZoc3FITXZ4ZzVl?=
 =?utf-8?B?OTdyOTRqRGdzaytCd3hObkFqTjRPNVZaK01TMWVmbHZLRWdZWTJ0dVhuckwv?=
 =?utf-8?B?dGFSK2hSbFQ0NVRVMG1jQWVqc21ZQnIzblh3c3pvblk3TGhneks3NGhpbzNY?=
 =?utf-8?B?aUNEa0lwcnRzT1pVMlFJcnB6Sis0ZlFqWEZvWnNuM3YzVVdDNTZqcUl3NDFa?=
 =?utf-8?B?dGswUy8weXZWL2lDK1FqU3A2UW1DaE0vRE85K29JOUhLZXErZmZOcWpMTkdZ?=
 =?utf-8?B?UlFXL2pUSUhkZTAxaEc0a21wUGxQSkJ0NkVEQlFFeVpRR1NmZCtNTGpWSkFm?=
 =?utf-8?B?VWEvcDNrSlZZV1hWTTZWdFl6T3BQT0RkMThQYWV6a0RnNEpwdVQyNG1KZitV?=
 =?utf-8?B?cXkwTXF6b3pmR211bWRJUTNKWDlDT1U5RStwemVVTzZRRVdveVI0SEhNQmRE?=
 =?utf-8?B?VEkxYmtYcEQ5dm9uZXArcnJIVGF0c25pOGdJZkdzb3EzU0VGOUgyVlBTeHFz?=
 =?utf-8?B?TmZEVlBMYTN6MDNONHoyeWRCaVcwRy9yckR0NDEvcEEvSXZkTVlCaFlVbmdu?=
 =?utf-8?B?MjN0WSsxQUVaYnJiNXpYNGlTbC9RNE1IRjFsZWd5dlpUUU9rWjlZbElkTFp5?=
 =?utf-8?B?SnVLZklwRGJjSkxISStXeUtrNHlBazlUSXNVejVNL0NkcFpzSVZscytnZno3?=
 =?utf-8?B?T2E4RWJCTENBOHZOYW1tVFM5TjVBSHV0d2ZTaVVJZ244T2VCa1YxSUNZZENL?=
 =?utf-8?B?NTZaYVhQMUpHeDRxNHROdVZ6TjZCdmZvTVpsNk1VTWxHakx2ZmNVNVZLY3Aw?=
 =?utf-8?B?KyszOGx2SVBHc0FBZHFtNk1HaDcxV1hIOWJERXN3N1hJdWFMRGVHLytlaUZB?=
 =?utf-8?B?ZnhDZGFUSE9weXVIdHpEdWF1Mk00U1ZsdGtaTmt0a2FQdXZTWHpHcWdUWlZV?=
 =?utf-8?B?RUFNT1ZvTDZ1WXA1dk4rc1Z5OU5QbUhZUEF0aHdKYjdwYWR5Z00wdFV5MGUz?=
 =?utf-8?B?RmZDTDkvNmJQS3B4Wm9NaDFnOUtJQkMxaWUyTjQzRW1HbWsyWmtUWUNCem5p?=
 =?utf-8?B?QWJVd2c2R2NXV2lDenBadTNKcnBjQkZPaFFDWTFPc1JBeW03RWF2UFhxd0NQ?=
 =?utf-8?B?cGJuTUN5YVl5S0NaSndENzJyUmhCemszR2tCT2xrUlpsdzB3Rm9qcVRVbkJY?=
 =?utf-8?B?UHBNN1J3am5MS2k2Y3hqTXlCOHdjTXdBeHNab21IdG5vamU5TTlzYTBGWktT?=
 =?utf-8?B?RWFvbDNIZkZYTjhSZmRKUmpBMU5aajdTTjVUaG9OYXp4bmFGZlpTQWZVajFV?=
 =?utf-8?B?UUFTaTJzRnJIcjhMRFIwWVhpNW5QblFYcUlJVzVua2tqYSs0cEJKT2ZIV3NW?=
 =?utf-8?B?dFNrSFJlSjFMZjJzaUhOcjJwMi9iaXJyZGt4anlZUnNTZEtGaTBiMHY1YnNM?=
 =?utf-8?B?MXM1TGhIVml1alM0UlpJK3dreWE4SVZlNGNQT0plckgwQ1o4U0RibWUyWGZJ?=
 =?utf-8?B?R2VrTGZmdEZaMDhiREN5UVh3NlNmL1FuM2I0NEIycDB3VDRQZzB4a3ErVHhj?=
 =?utf-8?B?T3p5Uk5aaVRVOTI5UzkyNURWcm91QXRSd0x2MFRzNlhlQjRxVDlSakRCV2tH?=
 =?utf-8?B?bFdYc0FmRGRIbFNGNkxsK0g0UTBMSVo4cGZMc2h0a1ZqMWswWTRtV3lmVmRq?=
 =?utf-8?B?c1VaY2pMRU80Qzd4bUlIQmlmV0JoSXE5N1Q3OENEL0VXdnE5eFMxUkM1dnFm?=
 =?utf-8?B?VDNnZ0p4ejNVUmZaZGlVR1FyRXU0OTZGQUFobnB6cmFMUDhvT3ZwYzVTMjN0?=
 =?utf-8?B?SkVyYWl6ZXdjMVQxVjBSLzBEL0QyNUx3a05jd1JPNFdUYUt5akdCWlRZWEZx?=
 =?utf-8?Q?KWu2C0t0FGd5w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mlc0aGxaRGV3M1FOWWoxbHArbjcvQVJZczFtVE1sRHppbzFmNThLbEhoREJS?=
 =?utf-8?B?VjBRUGE1TmFaNlRrQjdlKzZrOUpZQTFibFJRNEVRc3hnbURWK0xqTGQwSWRW?=
 =?utf-8?B?RFkzbGNOSDcybTdwWTFzZzVDcy8rVEk1ZnExMnFjZEpYNC9EVGhhS2U0bEhX?=
 =?utf-8?B?aUNFSGxOWFdVWmFvemR3RVU1TWdkODZ6aDdUUmo0NzFPL3RHdWtiNDhKMUpT?=
 =?utf-8?B?eHYwQWNiSE9hYVo5YXRqK1QzeUs4RjJWTktwdExMYVJhV0thaEdZWCtIUnAz?=
 =?utf-8?B?UHNIa2JuTlg2V2F2SGxjTXFWZE9ncEJ5YUJjZWZLc0cydlpjWGlwenRxT0dh?=
 =?utf-8?B?R0RES2ZlY1QwNG9qWmFGb2xiNDJaOGNmeFlLR0dST3RZREwza1puL2F6Zlp4?=
 =?utf-8?B?TDl3dTQrNW8wKzlJMHV1Ti80QVZPMUI0bmNvajZOdzltYTlSTW91dXZCd3pv?=
 =?utf-8?B?MTRLaitPS1ZFQkpOMzJKZ3J5RDBZbWhlblFTM3ZpUGRya3VrNFNtbTdJaVBx?=
 =?utf-8?B?UzZNbnBSZUwxVWx1R3pUU0ZVU2JTTjNJR1Zkd3dKT3NEL09kK0l0UGtpWmdl?=
 =?utf-8?B?bDZhaHkrV2NSSE1uVzJBdlRxRE95N0R6VExkSlZJZDlYckRPd041ZE92UU56?=
 =?utf-8?B?Y3BHbTFqcnU5WW5qbUFpUnZuMkNYRExlWGprTC9wNHZsYm9lcytBcGIyR1NV?=
 =?utf-8?B?eDRtaTJYT0ptNTlpY3ZSMjVrdllGcDliZjN4eTF0VFhnVnVCMmhPWEtVcm1a?=
 =?utf-8?B?dGlnY1NuOGVPbnB6S2VUWmdSSWZXbVNnOFZjVDJuUVZQSFdvc3UwNWV0RHNR?=
 =?utf-8?B?Y21UNFh6TnBUSkhCVjA1STZSNjY3UE0xUThrbDVsTmdET0JrV1pqQ3V6N2lU?=
 =?utf-8?B?ZWdibjRiR1FJbER5Q1MySzJMTmp2ZnpCNUJ3Snk5UnhYaDZNNEJjdUduUk01?=
 =?utf-8?B?YUYrUjRvOGEvcHhEZ0hDd2VCNGZFU3ZyeXdndlRwUlBsSnBkUFJmNkNPblVW?=
 =?utf-8?B?bjZMeXQzcnptZFNYMWM3UmZMVzk3VWY1QmorcVpxb2V2aWxQN1JnbXNQa01L?=
 =?utf-8?B?akVaSjY5ZE05cEJIVHVFOFNQUTZmRloxSHJBRjJQTXpOUUJORzdNMExzbjVX?=
 =?utf-8?B?ckU4R1JVckdkd3BQUEVNSDZ0Qmd0UVQwWTdmQ2p3bjJwMW5ocXJkRW11UzFY?=
 =?utf-8?B?MTFhOXd3R0VxYlk3bWhQckhwcWNJTy9TT2dvVE43amtDc2VPRUlZUnFuem9u?=
 =?utf-8?B?Z2Vqcjc2YnVzTmJZL1dnUHRsdy9yTjZtdGxyNGIxQk5HWmg3RjBIazVjakNr?=
 =?utf-8?B?eTA3emQ2cElxaVdQWEhVU3FPckU5ak9BRnNDeWI5M3U3aWN2ZE9QVUZjMmc5?=
 =?utf-8?B?dWtqZkl1cklDZTZaWis1ZlkvcDdCbzNqNUZxS3dxelJ5OEtNMlZRYnR3WkdO?=
 =?utf-8?B?M0hyVktucEVxcjJTeGhySTNUci9kNWJDejJmNzRnc21UNVRMU203YnJnZnll?=
 =?utf-8?B?czU5MzlqbjJOZVlvZE9LN0FpaEJWMnhacCtxS0hTOW5Xek0rU3FqUklrQTl6?=
 =?utf-8?B?NWcyeFk3bHRPSElaNW5yN0w0Y1FwL2ZNSllNaHBsdkhEUkFpT0hKdHM3R3JB?=
 =?utf-8?B?ZlBqSEpIc2xDOVhzeWI5WmZValZOUG1HaWJ2SkNKcFBOc2xHUW16ZlZURGd4?=
 =?utf-8?B?OUhaRlQzZlZBbmNjYmxIU0xEZmwyZC9DNzJKTXBlN01tS1FOUnNrWWJVai8x?=
 =?utf-8?B?VWlNM1JDc2ZrT0w2Ni90ZDI4TldvZTNxaXVSUEZ1U3o5eDEzSFExTm83NEh5?=
 =?utf-8?B?TjJ2MjdpY2tJb3Rvc1hrcGxwQ213aDZjL3dnTGxxZmcrZTZXNHVsWFpRR0Z2?=
 =?utf-8?B?VUE2dmd5MFdSZ0RDY1FINlIwRlJqT0E5R2hUbUZZLytFT2x2RHp3NEw1TU9V?=
 =?utf-8?B?clRNTncyRmFSRmlkVWFmcEduZWRhM25mOXZPRUJyeVVMNGdoNDJNcTYxRFdh?=
 =?utf-8?B?ZkxDYTFnaDBOVlNNQlRNTFBQQWwyc0NyNXhFdFYyYVh5Q0FVTW96U1Bxb3B6?=
 =?utf-8?B?bHBqajhzNU1TYXFVaXNxTlE3UTFyZ1ZPeWdhT0JTWFM1bktJYUhhU090UUox?=
 =?utf-8?B?R1JvZ05xa1JRWkFzOURaVG9KNGF6WTBTZEQ2TzE5cWVhNE9HYlVoWEJIMkNM?=
 =?utf-8?Q?Qe3CXJETGFh0OVxOCZJAMjcNNsv6j1mpqhrdjM6SuNxN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0772c9-9f51-408f-8e67-08dd6d3c9552
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 14:35:13.0130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i20V1ed8MGK42K4VltvqWbd5HvfSU8wg0oYcZCtR1oae+lrWTSpL4Z6h8BoZj20zNDPNWeqZJigJrtU6yk5JUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6656

Hi Greg,

On 27/03/2025 14:32, Jon Hunter wrote:
> On Wed, 26 Mar 2025 11:44:27 -0400, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.132 release.
>> There are 197 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 28 Mar 2025 15:43:27 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc2.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.1:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      115 tests:	109 pass, 6 fail
> 
> Linux version:	6.1.132-rc2-gf5ad54ef021f
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: cpu-hotplug
>                  tegra194-p2972-0000: pm-system-suspend.sh
>                  tegra210-p2371-2180: cpu-hotplug
>                  tegra210-p3450-0000: cpu-hotplug
> 


I am seeing the following crash ...

[  195.052638] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  195.061551] Mem abort info:
[  195.064467]   ESR = 0x0000000096000004
[  195.068244]   EC = 0x25: DABT (current EL), IL = 32 bits
[  195.073551]   SET = 0, FnV = 0
[  195.076604]   EA = 0, S1PTW = 0
[  195.079741]   FSC = 0x04: level 0 translation fault
[  195.084614] Data abort info:
[  195.087493]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[  195.092971]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  195.098040]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  195.103347] user pgtable: 4k pages, 48-bit VAs, pgdp=00000001063b9000
[  195.109801] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  195.116605] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[  195.122859] Modules linked in: panel_simple snd_soc_tegra210_mixer snd_soc_tegra210_mvc snd_soc_tegra210_ope snd_soc_tegra210_dmic snd_soc_tegra210_amx snd_soc_tegra210_adx snd_soc_tegra210_sfc snd_soc_tegra210_i2s snd_soc_tegra210_admaif tegra_video(C) snd_soc_tegra_pcm tegra_drm v4l2_dv_timings v4l2_fwnode drm_dp_aux_bus v4l2_async cec videobuf2_dma_contig videobuf2_memops drm_display_helper videobuf2_v4l2 videodev drm_kms_helper snd_soc_tegra210_ahub drm tegra210_adma videobuf2_common mc snd_soc_tegra_audio_graph_card crct10dif_ce snd_soc_audio_graph_card snd_soc_simple_card_utils snd_hda_codec_hdmi snd_hda_tegra tegra_aconnect tegra_soctherm tegra_xudc snd_hda_codec lp855x_bl snd_hda_core backlight at24 host1x pwm_tegra ip_tables x_tables ipv6
[  195.189033] CPU: 0 PID: 87 Comm: kworker/0:5 Tainted: G         C         6.6.85-rc2-g0bf29b955eac #1
[  195.198237] Hardware name: NVIDIA Jetson TX1 Developer Kit (DT)
[  195.204144] Workqueue: events work_for_cpu_fn
[  195.208499] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  195.215448] pc : percpu_ref_put_many.constprop.0+0x18/0xd8
[  195.220924] lr : percpu_ref_put_many.constprop.0+0x18/0xd8
[  195.226398] sp : ffff800082e73bf0
[  195.229704] x29: ffff800082e73bf0 x28: 00000000000000ed x27: 0000000000000028
[  195.236829] x26: 0000000000000000 x25: ffff8000824aa720 x24: 0000000000000000
[  195.243955] x23: 0000000000000000 x22: 0000000000000001 x21: 0000000000000000
[  195.251080] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
[  195.258205] x17: 9397548220450a08 x16: 010100001748ae3c x15: 0000000000000000
[  195.265330] x14: 00000000fffffffc x13: dead000000000100 x12: dead000000000122
[  195.272454] x11: 0000000000000001 x10: 00000000f0000080 x9 : 0000000000000000
[  195.279578] x8 : ffff800082e73c18 x7 : 00000000ffffffff x6 : ffff8000824aa720
[  195.286703] x5 : ffff0000fe924a20 x4 : 0000000000000000 x3 : 0000000000000000
[  195.293827] x2 : ffff80008249d8b8 x1 : ffff000081eb1e00 x0 : 0000000000000001
[  195.300953] Call trace:
[  195.303391]  percpu_ref_put_many.constprop.0+0x18/0xd8
[  195.308518]  memcg_hotplug_cpu_dead+0x54/0x6c
[  195.312868]  cpuhp_invoke_callback+0x118/0x224
[  195.317304]  __cpuhp_invoke_callback_range+0x94/0x120
[  195.322345]  _cpu_down+0x150/0x328
[  195.325742]  __cpu_down_maps_locked+0x18/0x28
[  195.330091]  work_for_cpu_fn+0x1c/0x30
[  195.333831]  process_one_work+0x148/0x288
[  195.337834]  worker_thread+0x32c/0x438
[  195.341576]  kthread+0x118/0x11c
[  195.344798]  ret_from_fork+0x10/0x20
[  195.348369] Code: 910003fd f9000bf3 aa0003f3 97f98ae2 (f9400260)
[  195.354451] ---[ end trace 0000000000000000 ]---

Bisect is pointing to the following commit ...

# first bad commit: [e56ff82e1e164ccf815554694d97bcd3dec9e89a] memcg: drain obj stock on cpu hotplug teardown

Cheers
Jon

-- 
nvpublic

