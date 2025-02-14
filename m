Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A3D204C0B
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 09:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526389; cv=fail; b=Jl1i/7AOrqR9o+hcUHft3R2k0eoLt6MlO5aaxttyd6jxmRmR8xVUaKcGWJXNEMApRSEy1p6wcnQcq006d8ahxoB1oSZlZXtOIEMwFBRDvZx08GFOutNHqt84auWvukvCl0ZEzT0cbqOWECPjm4Dnh6G4R3rDgCvrAB/rC+XiQfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526389; c=relaxed/simple;
	bh=uYBk5IA6MtvKxIu7Ko5uCpMDiifzedYkOK4ZpsFn8zY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q4rlFWusmgB/tQ5IMoHNUqxbzoO2NswSDmG26UkS52wIebauNiVYyAlPnWJXQonuRI5+R+Z52c8WYuZuc/la/61+N8Ovnknfjzda3PrdntfFouALSdOrUQ+bXsadz2j95WmH94ZWWptG4APH+bzMDbiaX23mvYMtfhA6pExRmEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qcqxn0sN; arc=fail smtp.client-ip=40.107.223.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qcqxn0sN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t7i86KHi2SZRaytmRN6aVfXvLjC98kK7GyIRspCOdcPKVY38ofRf+6kYVIgyLSDULy25P1HZ5X4YqQfst/2HrD8lv8uYhO4BulgbIvKPta9W/1i/iv1xedzZcgriXTvUQQvSG0jVKeAsxdhNLMq4C6d5lL5bkbAd1yHpopQ50Z3aR/BlBJFE/D0F3cNR/Y8LcIeF1RV3uMwQooVZiemRDHX8BKGY6Ty5ilbN8WggnsLbRGufr7uzni9tm/rNVP8E1j2gmecblVmzI/Mg/q16nQjEiBJQ97RoH85Tq+l025UO9UuxzL5pLmOzr+9VM2nTfPdwZHTqu9NWppUJ3AEeXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pW2iZ/ULWgsX3t7z7G8qPaIiODWcEKlI6j21848p18c=;
 b=arpR50J16EoMmd5oKld+XbqLUwK8T77gaBg5g1kc+8i3eoaCjIbq0RYFzRO0l7tBjOAkETPg7UNOscHJu3TFT2SKHrLv8FqYk1iPnoGCdBgro/8t53qmrsjIf/nysu2+7JKyF3HbvzEHpc/jsC3sX84V3v+rjFsTt7rc15DA15s3DM4zg214aTdG94EfPIlp67eJaeGns4J4q4Q4kyXGde+i2C4JyxYpIZrzgjA+p+ICXnIykm92fkUmNXB9CoEf+i+lEUMipKOEHkcjL0I9fecyg4ciMFZ26t8pn1foQT2Xxg36iNjlXeOnJnMo0rDj1SXFqsqyOiuvGzrHA6s8CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pW2iZ/ULWgsX3t7z7G8qPaIiODWcEKlI6j21848p18c=;
 b=Qcqxn0sNBJQHCRj4xOPcdMGaG1R/tRfc+g/tzSoS+S3Z+9arvcx/iP4XNd7s5ApdeavIbO45C51/HBhT0mGP3VgbbwXXLHoEz9uaNodsYrBiDojWNBNNFqR1P3BGk9qq1SRC0vSAq2ERK0pC4psN4pllF8BoDmKe92j1R/HIQcl34SgD6749JQYFc41OKdhRvGqfjLsjPEkfQMovYvjCd3UJ+4sWXdbecA5TmGWWRIgOOOvy+mdCbLI3vwNwT6NzJoqHCGmbQ5hZ2iKpW9xg9mb1hmK8aJ52rLQGtWNjYg1mpObHTO3SQEAb+RKPjcWrhMEBg+3/ApX6j8NQ7+Wqaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SA1PR12MB8164.namprd12.prod.outlook.com (2603:10b6:806:338::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 09:46:24 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 09:46:24 +0000
Message-ID: <d6b9039d-1253-4207-899a-e0ba3fa23a0a@nvidia.com>
Date: Fri, 14 Feb 2025 09:46:18 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250213142436.408121546@linuxfoundation.org>
 <fb0ad22b-3777-4ef9-b478-445da3524b39@rnnvmail205.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <fb0ad22b-3777-4ef9-b478-445da3524b39@rnnvmail205.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0167.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::12) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SA1PR12MB8164:EE_
X-MS-Office365-Filtering-Correlation-Id: da05b276-739f-4179-fe85-08dd4cdc71d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1VpUzE4akF0WnczOHlaMm9XKzdYV2JONDdSblh6d3F1eHVidzkzZGVPTU9O?=
 =?utf-8?B?am0yWlhva2lXQmIyRHF0RnVQOW9Qa1NJaHRFSytxU05HLzNrU2laQWJRNHBD?=
 =?utf-8?B?UGN0c0pXeldvaTNRRTh6K2VjYjZSSDlHMHpmdHdEakxkYXFWWHp0OXB1TWRa?=
 =?utf-8?B?emNqMDc5M2xQNm9aNk1KbWNRQXRnWWI3aExmTkFhWWtzSnpLSGVuWDVVWCt5?=
 =?utf-8?B?TWY5UE9Vb3QybGw0c2J0TGtIbjJhQ29JN2hPNU1FWERycjZ3djVqdnJwNG5K?=
 =?utf-8?B?TmEybVlZNEp5M25DTXZ5b0RVZExHbHBHYS9SNk1zVExvWW14MFJQS1d6YnhJ?=
 =?utf-8?B?TVliT2Vsbm8zVUowQUY5RlNBQ0lJZUJNdW5YTzdUSUdQc1MzMFFOaGcxeWtl?=
 =?utf-8?B?dnNzamtqUmcwdVdQckVQQTJPOS9SenRTZE9OYU1ZeEN0TlpWcFhwdDJzREt4?=
 =?utf-8?B?TU1kRTBRR1FPSSsyVjhBbkZYZ0lMYzl5TWUvVFhadEhidCtUdGRDNmZQL0sy?=
 =?utf-8?B?ZkJYOG5GbnhLTlczT2pQcHNOM1dDWld2dGZGWGsyR3B0Nmt0eTZVNCtGZVBl?=
 =?utf-8?B?V2NmQm5PNzJSZ0hWYmRDcGtLeTdOWjNYQVNxREcyMnpLZDBFVzVLcW1GbjV5?=
 =?utf-8?B?RjlyWE1GblZEd0lYSEtTWkFxb25Lb1VZZFhnaWM5NlpONU82WTNUb1FpUExy?=
 =?utf-8?B?Q0F4OTJ4aytocXB2SjhmczJ3cldpVFY5eDY5SnhzdEtpVEVicVp4d1FsQUsy?=
 =?utf-8?B?dUg1MHAyNk5KSTJRdWxhTkg4ekFnT3JDbm5VZmprZG9CR0M0c24zd0F2QzE1?=
 =?utf-8?B?dTNQNm5zdVc1QUJFTDhMQi9KZzFuN1phaHFVM1pnK3REOUdJWFNGbkFBUGJL?=
 =?utf-8?B?dHdoaXhDUUZZeWI0RFREVFVpOXh6WmliVWJ2VktLeVhKSHdramU0Nm5MSmhp?=
 =?utf-8?B?emY2dmpKSEtXbjJBY1Fpc2hiYlZhb214WnRKejNyQlRVN2tsc0xGOFVtYllQ?=
 =?utf-8?B?U2YyZGxZbHJDUEhadnkxckh1dk5KUkd2YUE4MXVHZkoyMnpxclFwZDhRWUxD?=
 =?utf-8?B?RkoxdGhuVTlHVUVxZW1hY2s4dU1wZm5OZ0hBTVRmNXY2ekxiMit0QjN3MHFT?=
 =?utf-8?B?T0NaUUQrckl4RU1wOUlRS2dGamJ5T0pvWU55T2VlM25kNFBmaCtWOS9YOFZQ?=
 =?utf-8?B?MFZ3MnRCUThySk56bTBEejJCeGh1TEtuZ20zZ0c2dERxeEI5RTZaYmNHMDE4?=
 =?utf-8?B?N01ucWRvZ083eHg5VWF0UjFpeThCRlpHWEMrWHJxS3FNTGZ0SWt6akFDUWQ1?=
 =?utf-8?B?b1Z4Z0Z3L2Zpb2pLcHNDU2VNUXpNVCthREFIRWtvOXVHdDhqZ1krc3ZDbnVq?=
 =?utf-8?B?KzVrd3h3Um9ZN21OOE5ZRmRYZUZNZFl5S2NuRjJ2RGRJaDVJYzMzVUloNEFm?=
 =?utf-8?B?TFVpSG5hdUEvWGdMd1RuRDJVZ1R0TjZLZ1FidjA1cFZ0QlBwWFdpYnk4UVZO?=
 =?utf-8?B?aXF2MGJLSElraDBZdkZ4NDhzNUxkanB1OFhPejFIQUNOZmlnRDY0bHJKUUVN?=
 =?utf-8?B?aERabTFFSFFDblloVWdnTWczNUxmcXZzclZFWjNFaU9GTHA1R1hsZzlFSUJS?=
 =?utf-8?B?em1ZN2lia3dLWElMQVZYcEZ4VEtUVXBJMkMrdEZPYjc0cXJOa0RQaTZCLzFL?=
 =?utf-8?B?UHdpOUVuNkliSk5jOHBRR1p4Z1U0ZEdJWDBqcERCWmNvQTJMeC9FNDI1NEJY?=
 =?utf-8?B?WG9XKzVyTWh0VUtNckxzQnFEYXA4SnVPU0RvU2NMUk1IOFo5a2lKdTYyMHdu?=
 =?utf-8?B?eVgrZWJZS0J1bUpsemY2Ylg2SXpTS0dEZVNrZytPd2JDT0UwdHEyNC9Vby92?=
 =?utf-8?Q?Lf9Zlyv7qjOeM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWZMQW9Pa2xVNDVsWnJxV3BId2Vwei8zMnlSRlhOWmdpalppY2tQUHczZ3hT?=
 =?utf-8?B?ZkFybW9YeHJpYmV4WjBOUTVtcCs2ditXWWVBR0lITnBHdEJpYVg0QVpNZTRj?=
 =?utf-8?B?MVJBRFlmd1JScFh4T3BiQkhSUm9RRWxhTThoUFpOTGU0aE53bWM4Y2M2b3Yw?=
 =?utf-8?B?cWZRa1lkZ2NFTytBREd3Q3BSZlJmMmw4d0pGREFzemlHTjZPdzhQVU1jcUJ3?=
 =?utf-8?B?cnU4cllpZXpOT0tkYlNoTmtUVWJuUm9Udkh0Y04yRTJLSnlvV2NXbUV0ekZN?=
 =?utf-8?B?RFgzdFN6SUhQRmV3TlhmS0tlVTY0emhFa2w0QUJpWGlVRFlhNndWUkdHSHl0?=
 =?utf-8?B?djFjVUdKb1EwTXRzTG41dmwzdjd5cXBjbkh6NWY0OEFyc2JSd2U3bWNzN0p6?=
 =?utf-8?B?M0tqbElSa2ptYldvT2xjTERRVmRvTU5Qb1dFaFQyaG5TSnROUmg0c1RETjIv?=
 =?utf-8?B?bFZ0S0p3QkMxTUFzcUlFQlN0cVh4RFQxUmFzRUgzQTJRMXRYTXJ4Qzduemhk?=
 =?utf-8?B?QzI1VVRLOEdvUzl2NzFBQVkxMDc1NW81akZkZktVdVZqdmZ3SXY2aEJzbWdX?=
 =?utf-8?B?clU4bFlhcjhLVmNCa3djeUJHY1lKeVhMMzlFVEdXOVM2aDhpbHdJQzk4R2hi?=
 =?utf-8?B?RjErSXhUNjN6aGpXQUUxTUJSUnhtcFBBVjY5ZitFL1hJWmxqM1FWenFMOVZU?=
 =?utf-8?B?WHZXVUU2RUhVb2FUbEhtVHVFRkEyS2QyYWpISXhieFUyU1ZXbm1rM3BKMVlZ?=
 =?utf-8?B?YnRXa1B4UkZoeUV2ZUhkMm5Lcmg2UnBPTmZkTFYxeTVtSmR1MlgrUzFzbXRn?=
 =?utf-8?B?cm1UT2FDQkFMcjA0VlNBbkQwV2hycXp6SmRBd0ZCUWxkNXJGSE9aKzBsdUpB?=
 =?utf-8?B?MmdoOUIzOTZZWGxrTkdVNVJlcTJMcVVUZTM5Z0NhWVlrWkhsVGRRR0hYNTNJ?=
 =?utf-8?B?R2NHNEpaSzcveUFSSVZqUi9scmJ5YzBUQlc0Y1BxTmJPREk4a2Vhai9MNDJ5?=
 =?utf-8?B?WFhnYno5a3RVSlJ1MC9Wc0JIV2VKY3RudkVEUjNSeUNHRkF6ajVrRFZMMVVL?=
 =?utf-8?B?cS9HYlJHTlYvK1puVXFieVRnSjBJRUh2WXo5aHhsUys0ZWFnZTFHUXQrR2xZ?=
 =?utf-8?B?Wm93QTJWelNoQmVmSlRVbDNNS1dhU2FRbjZPNEUvNXd5NVFWbE43U3hjcDhw?=
 =?utf-8?B?cURTNEpmcmNLejFNek8yQ0ZCN1l3U2VYWklVUVF2TGd5S055UlFncCtWejNi?=
 =?utf-8?B?clZXSFNKYnZsZ0E5ckl1dmV2b3F5QW5ValNYdXdyL29VT29tNXQzc3lqTDNB?=
 =?utf-8?B?aTFWSzI2bFFNVGlNTi90WCtoS2pIajhOMFFqelY4bGRUMFZtMnpsUno0ZWNM?=
 =?utf-8?B?TDR2NEpSaXE1YnZGNDdTbCtnQjJiNElPbTlqVDluZ3dWeUdCWVRoQm1HQmRV?=
 =?utf-8?B?MTdGaTQ0T2F6WDUvYXpHK3JjT0FyNnlOd2xRQk9yemk1cHVoNUV2b2VpSEVx?=
 =?utf-8?B?a2srcXZqemNrSys3KzFWSDVMWWR5UEhaNXJoZWsvMHNKZ1RpblhWSkd5Tlgr?=
 =?utf-8?B?VWQwUjRDVlBLWUduWDQ2RWt4UC96eUhEWDMrWWcvWnA1QU40bldSeEhtYk5n?=
 =?utf-8?B?UmhzTWI0a3F1RHBraUcyRWlaUWZFeDk4cUtsR0NkNGlocFluVDYveHAwQnhz?=
 =?utf-8?B?b0hlZzVYb2VwYkRyMzg0MFNBYlZaU1JjOS9MaHlpSysyVEtReE95NjhSNHNW?=
 =?utf-8?B?bUM5VFByWHFhSXFwY1RMWldXYkdVaEVMdTRDNmVtdmRPTnVmbFk2Nlc1Sm56?=
 =?utf-8?B?VVNsc2N4SlRZWkFWaFRYYWtnV0dQdjVyamoyd1BTQ2ZncG14VUNDMmVpOXFT?=
 =?utf-8?B?S2hGL3BaTkswZEVPRFpXY2ZiYlZGd1VFTzRpcGI2d3ppNHVIVk9IcGtsT1pJ?=
 =?utf-8?B?d2hNMWNkRHp6bFQyazdacnNuRGhWdFVXc0dMSXlZTUF4cUhPTGpPbDNobGtU?=
 =?utf-8?B?WWtjd0ZtdEI4TWJ5Vk1lS0h6YU41Mkh5elpUaEF4ZTlnU3NxTERWSmF4dDUv?=
 =?utf-8?B?Nmkrbks4WWlkMU1FUDJBTklJanV5aVdWd2E4TkFFRStVeWFaMm5DZS9pcHFi?=
 =?utf-8?B?Rmx4TElSMmJ0NFRDcUJTNWZxQmhlTlZkTVM1eWN0TFY0blBrMnlRQjIxZG9F?=
 =?utf-8?B?WEl6VUtMZ3hhQ3RxZWdtNGJzcGlINWRoWlpHZ3kybVpDOVF0cmhDbFg4NmlX?=
 =?utf-8?B?T01JNUNsSnloWXpJWkhoSGtFcWpnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da05b276-739f-4179-fe85-08dd4cdc71d3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 09:46:24.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8XhYFoLK5K9H4vj71RSVTJqQq3ieXp4YCuQlMCSlEDTwZ8vnnULb4pzraZPp8O3juS5E8x8gHmcycEq/M0Xpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8164


On 14/02/2025 09:45, Jon Hunter wrote:
> On Thu, 13 Feb 2025 15:22:29 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.14 release.
>> There are 422 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc1.gz
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
>      26 boots:	26 pass, 0 fail
>      116 tests:	103 pass, 13 fail
> 
> Linux version:	6.12.14-rc1-gfb9a4bb2450b
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra124-jetson-tk1: pm-system-suspend.sh
>                  tegra186-p2771-0000: cpu-hotplug
>                  tegra186-p2771-0000: pm-system-suspend.sh
>                  tegra194-p2972-0000: pm-system-suspend.sh
>                  tegra20-ventana: pm-system-suspend.sh
>                  tegra210-p2371-2180: cpu-hotplug
>                  tegra210-p3450-0000: cpu-hotplug
>                  tegra30-cardhu-a04: pm-system-suspend.sh


I will kick off a bisect now and see what is going on here.

Jon

-- 
nvpublic

