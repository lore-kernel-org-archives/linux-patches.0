Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B39521A422
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409641; cv=fail; b=g0W8k2o0hj3DW6FxUwiGyML9rYleP1rYoMrpns1rrd+9SCSSuqgQ4w/fOu5r6Pek+QK83lhXz1p2LID+69JMbNdbVmDXwb0lzfsD0Mkmnu4u/VTNvXyMaQBiOlopMF1Si9GGEJjmT4YQTu3OrYiGcIuOSUOHKusNSW6FCnuXagI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409641; c=relaxed/simple;
	bh=a4sMGugr63KEjhBXJqsPSfvIRXCoErLDBhEA/TRL1vQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=krk0f3pPi8DhS06cj73mgczTOX2pKKrOD9t7FO8objWl422PxfAN8FYPFeJx1gjK0+6SL/bvrJ+ScdCECbPYTuwjrMGnFMAxoenbO3jdr3hoAZxtF6AgodGQuGe9pnWODUHjX4kYEH4rMRWKefdn9gd59V5iMdTLMpLUpAe9yfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iJaWm/Lm; arc=fail smtp.client-ip=40.107.223.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iJaWm/Lm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RddfNI2+Ul4Rau8nlF+ClD5J5k/nmIQCowCkOZVHjmpw3mK0U4qK3q2axFoHFDNTuEX62nIs7z9D3cIihR/mOc+UKtdz9pYJQJuGLFWUZ/ZPJZB5p9yHkClxuU6WUgxU9u/475ej6ox6sXZdRlEZTo7e2OpdkDYdV5Bwkw9qKBVczeAOfO+rFdkuAVi/gc/esgT/hj4WIZYVciOrfRoMgeYeKDHOPgyG0cHxFP1lBQMfnJi8kscOnRdxfg54caJ5Z14A/XaSBpwyXNtipQ6ngL20s9/ufb6G8cBTPlPHNy/wZxWeMJ51H+dQM705Qf0R7HuFoZMdnOFD8ER7WnpxUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZalpxfVzXDp/vR4uy6M8PO7K4sI+ja31x9IX9zspxo=;
 b=fxW3wlpBeFb1u0oKJDVLydFbtETerOpLrsb7P5ABuqI1hXvJRzKg662L1sZGN9haI/+ulyUZPqecbgHqDPsuYrNOFB4w6FF/twq2MJ2Q/MtaVc+w3HHjtMkImZCx/heIIQD9PJ9Ypnbh56mW9QA67xwMZWhYakd5gyHX19x1aFGxlk4HVKFTpzaBR/NjFwsqljkNBEVCHi9R2NlbaI8jMbW6SILk86Fae+zcnUzQd63zG/HHnwc9risdGO4dc3nNmpDtfT2Q6npeRyxRkfMUQIj6CpuEFUT1Jb72Vo2e2KxN292XuUmnvWigXfvBGn2cU3cg/1SzeurzfjtkgMGlGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZalpxfVzXDp/vR4uy6M8PO7K4sI+ja31x9IX9zspxo=;
 b=iJaWm/LmJbT0smOkmZ8D1S3it34cgmLMiwDN51Fmc6pu2ibqigOFeE3a1YoteWrEaLc8w0AK70pbEl/1FSJK+vw2XoBd9yULIkafJbtKXtsqClnidGPnP/H+tz2GqYs33IBAUHx1lnJ5WKYP6YiMmZ6fSsbrAcBdZPlz2XZja29nzoXD1+joezvg0IS3KFeaO8mZkR4J1KtB0+4UrgGn6qvs97K3KadGv2np0XrWWrKEDk9P//1oOd7/NgkhpumvrYBfruZcXJ5gbJbBLAN/DOHzJ6DF+ZfvlPcZYM+2yUpuvKzkjnjNAqSNze8N6xukAyNLJpvxixD6grkbsy3YyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SA1PR12MB7343.namprd12.prod.outlook.com (2603:10b6:806:2b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Thu, 5 Dec
 2024 14:40:35 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%2]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 14:40:34 +0000
Message-ID: <5a174c4b-fa2b-4180-af6b-ae50d76fef4d@nvidia.com>
Date: Thu, 5 Dec 2024 14:40:28 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241203141923.524658091@linuxfoundation.org>
 <71fc98de-2f61-4530-8c03-dcd7fa3bf470@rnnvmail204.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <71fc98de-2f61-4530-8c03-dcd7fa3bf470@rnnvmail204.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0040.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::9) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SA1PR12MB7343:EE_
X-MS-Office365-Filtering-Correlation-Id: e32fa3a8-025a-43fc-5934-08dd153ac6f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWQ5RWt3TytMMEkrSzdEZW01NG9XQkZsK1Z5WHVzSERlSmFiWGUrZXJNTHh1?=
 =?utf-8?B?UnUyVEZDZzg2ZVdHTVk2YndEMldyQ2JNanRHd1dFMWZnN0dUTUFraHAraHJn?=
 =?utf-8?B?RTFKNktyeWxQdWdhWndDUXllMkJmQ3NITUhvWEt3bi9wL2ZQRWp0VjRLUnlD?=
 =?utf-8?B?Q3JXM2V3TGpZSGZFcjdxTmdWMGlxSEZrRmIwM0pOVElEU1dlQ2V2SEFydVBP?=
 =?utf-8?B?a29ZQk90OFhMQ0JRR2crbU9TZEtnYmVuVlVOM2o1QVcwL05Ob3VwZzNmdlFx?=
 =?utf-8?B?UmpWakJwUzd0T3QxSGh5Q2xGRnVlM0VCZ2oyQXZJT2hwcTdVVzROdXpPMm82?=
 =?utf-8?B?d1QydU8vS1NBV0tnY3lOdDI0d3dwV2hLVzhPajUvQXhaeUJMKzNZRjRSTVp5?=
 =?utf-8?B?VkszU1hvOEdUTlIyRjNuU1kybU5lTzRwWjZUdDBSek9acWExemhQZ0Y3TXdI?=
 =?utf-8?B?NEx2VDU5V1huaHJPR0FRcjNBWVhxMVY1TGVNYlBlZk9SVkxGQzh4T2o3TW5m?=
 =?utf-8?B?S1BPU3AwT3g1UFZ4WW9GVE1Vdjl3UzY0cUJTUitZUVV5QXEvZ0JCOWlkcXY0?=
 =?utf-8?B?WFBWNXlaZ3J1ZXhZSzYrTXRxd3plNTlxam8zVlVNOHF1VnpEMHFkNmIzb2ti?=
 =?utf-8?B?MnFUaUN1MnZQeGxXT3kzOWpSZ0poc01yTHVKUVozSWhPS3V0c0JIR1F0RjJT?=
 =?utf-8?B?YlJlbEdNNUdaUE1US1B2eTYvUHRUalJ5eXA4TEVJK05yU3I2OVZaYk9mKytH?=
 =?utf-8?B?STJzTENjMVhSRkduUndqNW9WdmpFZkJhaGswZjhPU2JibFhnWmFXZXFTUVA4?=
 =?utf-8?B?Tk1DbzhqNFZ5ZE92c3Q0UnlBc1EzS003ZEo3bnc2SlRlQlVOL05pNjRCcjMr?=
 =?utf-8?B?bkNSK0hIZUJDZ21xY0traWZIZUR6U2tGTHBsRVE0VFdWT2ZtYVgzWFplMG8y?=
 =?utf-8?B?YU9KYmJlcTUxTkJJN2djbDRjQW40SGZkUk9GRVYyS1JNcTZyRHdtK0l3ejBN?=
 =?utf-8?B?dkEvZEhzTTQ3Slp6SzNtalRldndRMzhReDJJRnlUV0F3Wlk1TVlmaGlUVm5J?=
 =?utf-8?B?U2x5ZSsxVTlmV3pzMFlYem5WMXRJYnN2emU5TFNVZUN6VWpSMjdwT1M4R0Fw?=
 =?utf-8?B?UURpczRrRm85OHVlU25xSkZQMzBOM2drWS9iMXhETEIzeWp3TVZvcStaYlBU?=
 =?utf-8?B?bTdwSUlla0RoSlBWbXFFT3pEV1U5THNWZmt6V0UwN0tTVlg4R2Z1SDV1SFc4?=
 =?utf-8?B?ekFsR3ZhSWkweEwxajllSy9jaFNRbzdiaWFkcnJKUlB6dEZlN0RVSTAwMmdU?=
 =?utf-8?B?eW1XakJSYjJ5OUVIemIxdmtSMmFYdC9jcDV5NUh3bS9ZeXprZWFxeGRIUjUz?=
 =?utf-8?B?cnpOSk8zbThJWi84UUtiZHZYZTh5YzVpSFRMVGxhZVhXcmNpbGk4VWQ1WUhF?=
 =?utf-8?B?VmlUOG5lSkI0a29la29EZGJ2S3c3YUN6WU9ldFloWFVWeWV5YmhUWWt2d1FV?=
 =?utf-8?B?U0Zjd1ZlZFhkK3dyb3lMNG5QS0t3SDQyZVNycVpZeDYxTjVwQjhzN1FucXJQ?=
 =?utf-8?B?RVJCc3ZzWmVJaUt2bWNVcjhpNzNkOU90dzdXQjlWOUdISUZWRVA5VzVxNFly?=
 =?utf-8?B?ZFJocmd0UXM3SWxnVm5NeTNpSW9rVGhQZGpTeFhZVU1TVFllMmNZYUVKVFFO?=
 =?utf-8?B?SlQ2TG5hVGpZaHM3Q21VREs2UTVVZnZOVDB1WUNPMG13Z0VNLzdlV0RWQ09W?=
 =?utf-8?B?QjFyMUxlSDYzZzRDNUdoS2lyMmoyZkVrUWFRd0RORzQ0QWtQMUVRdDJZaFZM?=
 =?utf-8?Q?gnMDqjgA281ImZkLHFuGB+rmY/6HPnipL1lcg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Sy9DdW5DOERjQnUrMVowNVVRVnV5ODNmd2lVVnEvRWdtY09zRnVuVzROMWRQ?=
 =?utf-8?B?RG8vbm5Odlg5ZzQ3VWx0YUFZUVhSdm1QVXRPWCtSSm45VkNtZVIyQ1pmWUpB?=
 =?utf-8?B?T0FYNnh3OUVhVTJwb3RVRW5xOE9DZ1NHTm13a0Z2Nko3Ty9VaXNnSFNqK1Mz?=
 =?utf-8?B?Kyt0ZXJtUCtqbCt2ZEgxN05icUhOSFRyWDBWNHZWbHlSaHZLVUJGSTJURS9I?=
 =?utf-8?B?OGo0YUJrbnp4Wmt2a2tCL0VMKzRDczk4Wmo0UVZhS0xYM0RFdGFzVHF4R2JB?=
 =?utf-8?B?UlFxRVQ3ejlrTFRnWGdMZ2VHZmJPSExVczVuTzRoZ2hiVW9Obi9wcW1ObGVD?=
 =?utf-8?B?VHlubWhPTEx2VnlodnJRQTkzQk9UTU1OZm5wSGdISEdxUy9RbmllcXlvOEQr?=
 =?utf-8?B?OUU0MWxsVEZiT1FXZHFBYmxCdWhEQVVqMXZPTlJXRzJaYS9hbTRFZUR2Y0Ny?=
 =?utf-8?B?WUVRTDFZYW5VdTRCeFQxNUxHUHplYmcybkZ0Q3hpTUM5MWlWcHhFV0pBeGFv?=
 =?utf-8?B?TEdiMWdjOVFsem5lMVNpWHhPb3Y5VHgyZUl5djhNOWhrRW45SE5aUzdPQTBE?=
 =?utf-8?B?N0tmcDJhcDdud3lZcmZHa2luNlV6L2pmbzdRYm5pYmhURUxyZW92TEdYazho?=
 =?utf-8?B?blcwTmtzQWlVbXBkVUdMVndhTzJPQkhwejRzckw1R2YwZngxK3phcDdhTnZO?=
 =?utf-8?B?cDR1V0hzZ3Z6TFMyTmNOMC9XV2EreGdsNUVqZmZjaE1iV290aW84WFBmdjQx?=
 =?utf-8?B?dndoMmM0ZEd1VUhIbDVjaXdnYUUvSThUV3lWSmpoMnFsUEthS0hyVFlZTmha?=
 =?utf-8?B?Wlp2SlFnVm9KVlFPTGdCdVlRVFdYQmQ0R21NU1BKQSs4Q1ozaFpQOExybVpB?=
 =?utf-8?B?MzlCOXpFM3V2c1YrcENxQjliQndwTXYxRWJJQWR1bzBEN1YxdC9PWDNFeXlQ?=
 =?utf-8?B?UHNSc3NDQzM4aDUwU2VSN1lSRWdMUzZidFNEVjZLaTNiSFRzUTFyWnl2Szd5?=
 =?utf-8?B?ekJFYm5mdDNXV1ZneWptTGIwd1VzRnJJektlTm11eE9ZdzhCRjJVR3RkQXRX?=
 =?utf-8?B?Vm13TmRZblhicmZwNjFncFB0RkdDV2xyeDVUOWxMOE1FVWlteG1LMDhBcDJQ?=
 =?utf-8?B?czYyZTBwMkV5UGlJa0dlRE5xTTNHNjdMbk5VS0g0c0xlcDRlbVlQbkN4RHN5?=
 =?utf-8?B?NTNEYXJUd2VrUldqOVhraXlxRmRjc1RHQkJqOGlMWGNJN0VjTE92TDJ4ekcy?=
 =?utf-8?B?MVVZVlBUZzFNeCtMYUhCc2FHaFN4dWNTRUduV2NVNW5rdE1UMGowYkJ1bjVh?=
 =?utf-8?B?WE9aT0F0dzA4RnhZQlp3bDQvNGNNRHQxUVJMNXBmbngxQ2Rld2ZZS0NiL0U3?=
 =?utf-8?B?ZWdJVDd6dWRibUhnS09nQ1ZETVRNVWt5Nkx1bU56WlBTeVFaYUlFNkMzaGVU?=
 =?utf-8?B?Z3dBZENQK2Z0OVVXUEdDV2ZjWm8wcU5BZklzeHdkM0ZXK1ZNdFNDRmZicDR6?=
 =?utf-8?B?TmNvbzFxVFVoNXJpam1UNFdETWV6cVJRelg4em1wblB6RTdSV0hacWtIaTVX?=
 =?utf-8?B?d3VFU2FtYllwVGVRYmduUzNUeDFpMkNUR0d0cnhsOCtPaDhXUlI5czhHb1Na?=
 =?utf-8?B?U2dIUkh3RmZBQkhVc3NoRTRjc2ZjbkptdDNqMFNjYUdQb3RFc2tMeW5Cdm52?=
 =?utf-8?B?Q3NiQkcwVDlIVFk5Q0pqWFdUcHlBVGs0b1UvdXViYzFOUjk4Q01DOG4vU3li?=
 =?utf-8?B?ZXBlNXJGVDY5bXV2NWsxV0s2anNqOVVMc3BubnNSTUtGR01YVGh4dW9zLzJp?=
 =?utf-8?B?a0VUa1NXVy80cWl2R3d0MGJxaXpBL1RQcTVueXRTTm5ISmZBeGo0OGUyU0Zo?=
 =?utf-8?B?cXJ6ZnN4QTlaNlhmdmh1R3lLbHBtU3lscUdrd28yMGNiZ3VXbTdaS00wUWdX?=
 =?utf-8?B?SlppUEtWNXlCb0NNVHZGRjlIanA2Y3dXazAvZzFDTm1DY1paQ05HN21GSFVE?=
 =?utf-8?B?cnBWN2p0RGt3Vnh0TEptZER1UGJkcmdEWlkrb2VyNHRzaHduWUc2djZQS1BC?=
 =?utf-8?B?Y1psYWNGTnluV0NIRzFOQzh2MzRkMDQ0alFNRndzdDBkeC9tZ3Q5YVh1TGNy?=
 =?utf-8?Q?TIB0c1T7bk0wWi1q2CWI09d81?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32fa3a8-025a-43fc-5934-08dd153ac6f6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 14:40:34.8107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xOTGiyLzQ/WEq4lkv0PfiOWspsslfCrh0uvAfZDioUrVZZqzSFtmZ3OVXXiYfTArL3z6lY4Dq19mGiDqjP6oMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7343


On 05/12/2024 14:38, Jon Hunter wrote:
> On Tue, 03 Dec 2024 15:30:29 +0100, Greg Kroah-Hartman wrote:
>> ------------------
>> Note, this is the LAST 4.19.y kernel to be released.  After this one, it
>> is end-of-life.  It's been 6 years, everyone should have moved off of it
>> by now.
>> ------------------
>>
>> This is the start of the stable review cycle for the 4.19.325 release.
>> There are 138 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 05 Dec 2024 14:18:57 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.325-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v4.19:
>      10 builds:	6 pass, 4 fail
>      12 boots:	12 pass, 0 fail
>      21 tests:	21 pass, 0 fail
> 
> Linux version:	4.19.325-rc1-g1efbea5bef00
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra30-cardhu-a04
> 
> Builds failed:	aarch64+defconfig+jetson, arm+multi_v7


This is the same build failure as reported here:

https://lore.kernel.org/stable/Z09KXnGlTJZBpA90@duo.ucw.cz/

Jon

-- 
nvpublic

