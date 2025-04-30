Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93874189BAC
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025617; cv=fail; b=jyQ2gb5GKd0Pes0RZTqjv0HJFG/OLVefUKNM9enMQcAbks2TXpBaXzF+iiL34Z3Yo0O1K0XhW8aqD74Z1Ahlo57MbDV7R6xRn3or6+oyc/lv2YcBugNWrwKKDJj2OlxuhM70P6iDiOmpeolG8leG+RyKxEGUwb5xTqC5IFZ2bWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025617; c=relaxed/simple;
	bh=NDoqU4VKNUQ7MZe2YDAl8GOwpoymnYFpaP+5ykm/9PI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Hfftgpcelz7kJj02NuMjQ80zEoYDep6HgM5OYGtnB9DIkPovy4wgCMKINadb3Gh5q3TFdLRbqtMAZTPi2kFndyUnCSC/spJYfP8VtazLvdGD45OH76nAKnr9ic4JNBSy3G+5yLG9n7iqQqRYmAcOL/2lyx3khIllv6EjdK0B4Qo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kgqb35ME; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kgqb35ME"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UN9IixiE8nSB12j9asuHglabC61X0I/LAXHZnHnOQv7U4k2CUD3PlvKi0k3nV3LyRam9T59UXpOqoEz4JhRmUYzir8r3ewylt8SsbKHcUYO0IBnLHAp/oN7i7zJP7Xk4vkHNgo/PeuNtfslHm/0In9j605gLJiSWzoxriQ+u6R3A+qIKOQjiUKBYSyIfuIKlr26bJGeXkQA1Wd+0/9uhyTCIh4qukP/POsEF9B3YGEW8lsaTGEPkjxfm338SZGQnx44oNjiVcFzqDIIgwHfMmImrbXKJHstVft5e0AZXvq7J2XGv1ZVHnn9xCd0SoBjHgLb1DMu94VOp5TNoP+YaCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJjmas2+D6/eX1nA61xCrOJHwsiai+Bot3rcXmLj5zM=;
 b=faVhrTJnpYUwHd9hEoKM3aznSaPMyFM05bLENMqqhZE+YREnQ4eIvzhGo8Gow1D9T2sY/6iWNJZFhB5Qk2YWJ+36T0KD4L2qSP+zJJvIkvVHGX7qq38q+OTK5068MSwrJEBDdPslMHFkOAU2yHBrJwtwbiV4NVzQGfvmaIyWtMJphyROTgDXvw6FxRsUomNyjO2v1uPtsayr8c4zF75FI8tWLyi7Imc3WJ/TeHOkC4LNs8EMMgVS6j7zw9YLa9FKCystRstBxmZn7+ciQbXnipOTd/OlHiJDOJc8Pxbre7AQ+s9m/LbPHAE8vDgCpf0At0DvosbwOug7N4dLwuLwtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJjmas2+D6/eX1nA61xCrOJHwsiai+Bot3rcXmLj5zM=;
 b=Kgqb35MEpcbkBKOlXfPgEZALvNlWXYf/bs2H8Bt5u2Sw5TdvzQjffxCQN7+PCamTEsHLGoLen3l8XhVKqt84ntVKSwFrnl9gkNrpQsQlmf5otBq7T7IR8QOmZRDvNDf+Gn/kEowJJfe2j8IDla3TdOWFRBk1btkSn8rU0rpEo3FIFHXELl341wWIW+uOZ2bz8KMDoLH5cAKIzACFUa9T2idALFcQl5dB8GidExIG3x5L6k+PqaNssHOcjgiwp3kGgdxBloOuTWnNqAVf2MXc54Yo33Jz2aFEmXwH/4CIaQBkJ0X/eURtTWekthPXP5VmlQsFFkTzCDJ/TTUNJijjoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SJ5PPF0C60B25BF.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Wed, 30 Apr
 2025 15:06:48 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 15:06:47 +0000
Message-ID: <49b6dadc-3fb3-487e-8dbd-767515877197@nvidia.com>
Date: Wed, 30 Apr 2025 16:06:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250429161051.743239894@linuxfoundation.org>
 <3403e756-077f-4a6d-b26c-72fed355d117@rnnvmail201.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <3403e756-077f-4a6d-b26c-72fed355d117@rnnvmail201.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0131.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::10) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SJ5PPF0C60B25BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 12afe5e9-6c65-4e05-0357-08dd87f8a0a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEZjYTE3Y1czY2lGU09pUlE4dFBRUzZPbElrNjZEVFhyVStEemFlR1Fuby9w?=
 =?utf-8?B?QlNEMlBua3JZVk5LaVoyQ1U4WUNUNzV1aUkwa3hWK1VRc3FWQ2VUUGdVYTZI?=
 =?utf-8?B?UGpiREVEWlZTSHV3dlhQK2VoQXQ0bUxoQ3BSSStJV3d4T3VGeldPWHhyUkdi?=
 =?utf-8?B?UEg3b2lldHY1OFZTNkw1b1cwNnJ0aDRhblhFcU1ORFdSeFdITDJoTS9ZUTAv?=
 =?utf-8?B?Z1VQeXIra2xHWThrUy9kK1dVLzRWYy8rdVRKbENZeEVvYzJBNkVjYVZzSFVi?=
 =?utf-8?B?dGJnWmtNT2Nhd0o4ZU9DVHMrVkJ3NjkxcWlKdkhmZmJBa0dXYnVnMjMreVpY?=
 =?utf-8?B?WU5mQUUySFMwcjFDNEN0clVsZjJoVlZMMno0dXh3N3lDaE5Dd25xYzVNZzFh?=
 =?utf-8?B?RTlKRitVZTZxaGlGU2d1QVEzT0l4UUJiOVQ2YlU3ekREYnFuUzRhQmZsWFho?=
 =?utf-8?B?bnJNYjFxUGpaeDJDTHozOTVNRFZGRElFRUdmaVNLRDhPd2pqdDYzcE1rWkxB?=
 =?utf-8?B?endwMDJvclcvT1NFeHY3b21VZk9GajFsNkd0T1lqWmlUTndFNGpuMmh3bS9S?=
 =?utf-8?B?dHA5dlJ6YSt5OFZySFludjlLbnlaa25qdEtHbFZ2dmxsZ3Z6ZXJqdWdobmVH?=
 =?utf-8?B?MXpqMVVUZlJEbTQxRGp2Tk9sQWc5Tnk2eSt2VEJEWjVQVTBhNjB3Nmxhekpo?=
 =?utf-8?B?YzJjZndPVjQ4UjAzSXJTdXU0T1p1L2NSQnl1OVNIUng1QUc3M1ZvZ0I2bS8y?=
 =?utf-8?B?M29pYTlseTdOa3VFajZqVlQzTXdjdlAxOTFqM00vYUk0cTVSYjdCVWdDVTZK?=
 =?utf-8?B?Z1MwTUJqN1pHc3cvZzBHV21NZkU3RERMSGxlTjFIdVI5N04rRVhWYm5PWHZZ?=
 =?utf-8?B?bUpoOE5NcUd3c1BweW1yTlREcGx3cUNuQjZnM0JlL0lhajA0aHZaNFh3eExx?=
 =?utf-8?B?VWtwckptOXFMNWs1d0tQcEpJcjhCRHVqOUFqT1JVVm9QeWxzK2UraWNVdWt2?=
 =?utf-8?B?L2d4T1J5Ky8zOHlwVEd1NWhkL2ppOVpTQ1JsMUZNM0RFc3lUYlluNG5MUFMz?=
 =?utf-8?B?dTRoRWJBRVQyUUtNaE1qME9mUDg2d1hQNnhOZ3NHVDFxOG9oUmYrUUJEaWI4?=
 =?utf-8?B?VHhOaXV4YjJjNi9TT3JRZUV5Mnk2TlN5d1N0aDJHZzExVEtYYkRVNFFUSnlm?=
 =?utf-8?B?eXJuNm95RkpKV1BDM0Nma3ZhWW01TnhvOFdXalo5L3hHdnNkN1l4eWh1VlFE?=
 =?utf-8?B?UUNmK1VucHZsa0F2MmQ5UkcrSlU1U1dyQUl6STdDbUpXaThJaFNSek9MaHJ2?=
 =?utf-8?B?MVgrcmJ3V25LS1Bpb3JXd2lCVDBncWVEeVVRYUNkZ0ZOcGQyNzE3VEw4djhY?=
 =?utf-8?B?SXBEbTFJRE53dnBCV3RtTkJhbHRDUGU4STNoYkl2MWk4bWZJUXUzTGdVMUMr?=
 =?utf-8?B?S1FIVDJWelY0dDRweVpEcGRydU43YitWbUZDb2lhSTBuMUhvNURwMVp3L0pp?=
 =?utf-8?B?dGhhZ0NwWUFwMkttZ2FCWW8va3VOa01LZzR0ckh1RTZuY1pHNzhsc283NDRy?=
 =?utf-8?B?ejNaMzA1RUl0UjlVaHNOdzQ5R29MbDh5dGlOaS9iSnpPYko2RnlZWHhpLzMw?=
 =?utf-8?B?RDNGVnVuZGhXVUI1N0tLNnFoUTRQVEw0MWpLNE5Qd2dpUkJ0VlNQUkxqbEVX?=
 =?utf-8?B?dndSWmduVm9ISEhSZEc3VHVKVzRkYzE2VUhYdCswd1Y4b1c1dTMvMExpQTBZ?=
 =?utf-8?B?MGpVRkFRaDMvcEJUN0R6aFVpYm0rTWlJOGJHWjZIVlozZksxeUJyVjlyQ2pv?=
 =?utf-8?B?bGIzaElUYkNvRmt0NkdVZjVuSEJ4ZDUwaFI0aWdqVWE0dDhSaFo4Z2NhVWky?=
 =?utf-8?B?VHhTUWRhNTZMUHBpUVo3VGUwUGJQZ3Y4eVJBWnNMWGRoaGFoK3lXQW1LVTV4?=
 =?utf-8?Q?naFN7s5vkHs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjBrOG5ZQ215OWdpdzF1bjIwM2N6MXljd2c0c0hBekNYTWJWNkM3VTFEdWYw?=
 =?utf-8?B?ZzRLdUdFc2NnZmJ1K0Nkc2xROUs3SkcwTDlkenF0RWNvT3YrZjh6Tmc5NmQ4?=
 =?utf-8?B?RE02NWYyL29yMVprUlpuV1djV2gyNXhSQ0NCSkQ1TVBGTS93QzZvU3hESnhX?=
 =?utf-8?B?bHdYSHc3RHZmdTl0Ym1vYVd6MFZVOFFwTnhqakl4Q2JXZDFTR3VCQXYyKzhh?=
 =?utf-8?B?RVJ4UDBsaW5WalRNSXJBc3JKZFJCOUdmSFhHSENKbWcwcTEvWHhyb2s3WTJm?=
 =?utf-8?B?S3VXWlprRktHTWNRSG9PREQxUWxualZxQWZkeTRYVkpDOU1SMlV6VUh4Umtw?=
 =?utf-8?B?cGd3QUZTdVdwcU5Id01uMmszTkFlVHY0aVEvckFtU2hWSCtGb09nL1AvaEZF?=
 =?utf-8?B?WHZKLy85RnNueEhsd2ZWOUVVMnJtOGxybkF1cWRsUmE3N3h5ZXk1RUo5R0tJ?=
 =?utf-8?B?THFUd2NBbWlwNnBqNWVMMmpyVWlUSitqa2hHbDVMK2VMdVpFN0pTS2lkekxo?=
 =?utf-8?B?WVdXRVZBQkRIL1RmaW0vOTB5UzkwR2h5SXF2eUV0REtVV1ZseWFIS2NTV0ZC?=
 =?utf-8?B?VS9wRVd3MnFkTXZxWngzY280WFNRbHhoYzVraVpraUFLUDNhSVdpVXp3ZEND?=
 =?utf-8?B?UCtmNHJjNTF5WE9uV0o5SHlYajkxM3R2Yzlad0RaVXhwWnB1UkpzbkVteU00?=
 =?utf-8?B?SFRLL04wdkJGbEJITXdjN05ZWHpzY1ZDRGgzL1lmLzRsUUJtc3EzTmVkbHpG?=
 =?utf-8?B?aG1GakExcDhUS1BrcUlFeFZWZWt2TXIyQTZKVk55NHMzNzIzc3JWRXpLRDFO?=
 =?utf-8?B?djQ3N3hJVGJrU2swSEE2OEx4TEFMb2tWWUJ5NkFUeUJmUW1jeUR5bkgwdSti?=
 =?utf-8?B?bUI1SlFuaTVOcEZKZDFHSU1peUNSdmVRbElDOFlzSzF1RXZ2S1lpbnJuUDJ0?=
 =?utf-8?B?WGNkZHhpY05ZVi9aRjJPT3BoRG5vU21GY0F2U1RMZFJoY2lQMkJjbHZzR2dH?=
 =?utf-8?B?OGlmUW5vV0NtUGdkbXA1SEdua1NEeVNpUHlZMml3amdjVDg0cUpLM1FvbjN2?=
 =?utf-8?B?UDdoWVRlalRueU5mV21aMEwvWVBQNnJtRTgyU0hUaWp3L1gzZkE4ZFZTMG5a?=
 =?utf-8?B?L0JZNmlraTM2Y3ZZL3VicUprRHBadWp6d0N0TnFieXFaSU1LOUlqdGJBNXZK?=
 =?utf-8?B?bG00bVJNMjJ1MVNrTEVjSXhnejVESzZNR0c4anJvTlB4TUdlZmYwamQ4dDlP?=
 =?utf-8?B?OGpiVUptNTZOczRzS0srTFY0clVBdWpUdTVpWDYxYUh3ZytPZHE5NDQwVGN4?=
 =?utf-8?B?eEg0OTNHc0p0NTI4UnZHR2N4R0Y5SHNIY3RYaWs0Z2Fkb01UN2hPQk1jZGRJ?=
 =?utf-8?B?U1J0Mm14TC9oT1pMWTZaZXFwMG1Wa2FhNjcrNDBJVXh0NGN3R2ZwS1RDZnIw?=
 =?utf-8?B?S1hHUjJ4cno3YzJNZ3BXNHJLWkF0SlpjVEF4SnFPVUpPNGtrRTA5Wm94Q3dl?=
 =?utf-8?B?OTMvRlVwS2hpejRwaGhDN1lpSThzNEc5SUZQK2locis0L0VtMi9zalpHcXQ4?=
 =?utf-8?B?Rm81SFVGV2tvb2dXL2VhUnN2YWdDeWg1TUl0TWdwYVdWYitIYi93aC9ONDNx?=
 =?utf-8?B?TGJUNFhXanVVazhQcE0xMmdOS1ppZUZzSnNPenV3Z00vOGRtUlhaR3NjSXdC?=
 =?utf-8?B?RmxQMTVSK2FtbVNPTUQrNjhKVlBSUDVhYnpCKzBDa1NYNFlYS1VKN2llWSts?=
 =?utf-8?B?MEIvUlZRcmR5MVZXeE4wZHMxWDdVaXpITlllQVdSZzdFQjV1QWRmdDgwa204?=
 =?utf-8?B?YjQ4QjJpWDRndDVCczVGYi9FQVgxVnJEdjB3Z1Nhd016YnFEaHRydFdmcko3?=
 =?utf-8?B?ZCtRdmphMS81QUtKa2V3alYrVFVDd2lLcE5WL1pNMGpCY1M3cnFhdnFPUVBp?=
 =?utf-8?B?aEtvdCtsamM1aVlrS2lVUWVjcWFxMXZjRFBkMkErMkphZExDbk1QeGRrV3Uv?=
 =?utf-8?B?NGl2clo2bnU5ZWZJRTlvY1o5V0llVnBhd2U0OUNYYWxEL0F2bWFHd3ZFQWE0?=
 =?utf-8?B?SDlvWks1Q2hVTkJjQURvdTRwMy8xcE9iZ1FNdlQrNnNzUklZZ1lKakg4T24z?=
 =?utf-8?B?dUhDVFY4SUdkK2Zyemc4U2xHSVBQVENjYXBqTTM2TllWQ2hudmNyUk1PdkV6?=
 =?utf-8?B?RytHd2RGVWpuRlBueG9IY2pOd0tnMXpWdjRJQ2l5b2FqZy9JMnZZVkErQkpU?=
 =?utf-8?B?U0pFdXR3OWF3Sy9TU3VhbG1jNyt3PT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12afe5e9-6c65-4e05-0357-08dd87f8a0a1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 15:06:47.6728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mY64+jEqNcWYhiBlDNJeZjMy3rirEZRM+QBdRHmN4fKcbqYaHTroXhM7mKtW6JxMBNTw4171AzEhQTPitWWYJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0C60B25BF

Hi Greg,

On 30/04/2025 16:04, Jon Hunter wrote:
> On Tue, 29 Apr 2025 18:41:48 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.136 release.
>> There are 167 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc1.gz
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
>      105 tests:	100 pass, 5 fail
> 
> Linux version:	6.1.136-rc1-g961a5173f29d
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


Bisect is pointing to the following commit and reverting this does fix
the issue ...

# first bad commit: [d908866131a314dbbdd34a205d2514f92e42bb80] memcg: drain obj stock on cpu hotplug teardown

Jon

-- 
nvpublic

