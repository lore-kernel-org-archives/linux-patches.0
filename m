Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2061.outbound.protection.outlook.com [40.107.212.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCD5178362
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 05:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728971755; cv=fail; b=N+xmnfMDj8c7nij6aXmDIqa/G+KfodNfTLrG6UHi2+PGvuOZj7ji+7wV5v2tOnzihl9GlyYbdCCYNyTp8NRuMKZi56bLs/NZgdPn3IF6sMAjLzLrWShmoiHF8DeIs3u5t6Bct++TGMdf3UDAaZ1a9PnoEwVo77CNO6tmZKllQS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728971755; c=relaxed/simple;
	bh=OXkF96ju7aT03IjkjC1nHgffo9nh+lzZ39R51qDU2zA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t+5/Wfs4wF0T9b4Af0mu/TE72zFU8dNRv2gJLMx3BKXDzFl9aDcc0PADhPO+wmxk3Jyjxm4+xiTlZ9i0s5sNO9zBvGSp41YXxcmBOaKoNX5BNnBTDnZG6Q2m2nuP6BkHyvdpOukaS+n1aI8CdpAu9yNDLwMhOWaoRJk65ycCsB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=duif/86e; arc=fail smtp.client-ip=40.107.212.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="duif/86e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZvt7UB/5E+tGx7kuS1T5O79+R3n39L3dLq0dp09UAV2kn+W5MFh1h+4lt2Zsm5tvleywP2m5noN7Ad5dh8tIwDDzROsMjGrzslw+Gye1FzMuwXuztq3rgzKXda/pcMuQ93WslhbB3BGQT9nue9NTZc+ySoU2xpkQ+xcxwk3MJPjXEA3KwWz0fGIf6EtA7Mck2yE3b8dT8+JF05XO1asj6CyOjGEE36cwDQU/Trm/gJAa4kqoXK/Mif54z6EKz59hGwYUwm93UnMCc0/bK6DRdnxL2ebyLHd8e0ByjmeOf6Np77/ini5vW/tWMhX3rUGb8TYRPhhRp2laeWbnzr4ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DlRnqBHZod/UXqiIsq+Qlirdn9dcT05I3xg2cxJGdo=;
 b=RUhNA4banw0N+Rjh2JiQw2J37Uw0g6saqUwkddesi1h7sW+IzCaKjlw9beEBCbh1kAebbTj0H0VfAuGFvVBJEMcIWBv5hly17i7Cp9R9cR+yxCocr5wymU+w9nUcmE7cTAjfzpkol341e4XSdOjc2r3lQAPrWVhiYORrEzJN4xEloxIzipxrJylMdoxPGAISP7Fbna1E1CMSginhCleEGvpL8kS3WdTrJRbxu7qVl5uqEDH7NxuZJvmbO5K8bYlM4n8WhRHBxWCRXBoeouHv0+vI8liguDtzRYxt5J5z+nCgrgBy9d93fH3XOeJSJfpwtYQmVTdXx4ABBK/7S4Fk7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DlRnqBHZod/UXqiIsq+Qlirdn9dcT05I3xg2cxJGdo=;
 b=duif/86eZHOPajm49CevVQ9U+/9HUYWqXkXJBUrHVynUR014Q6mSDzqDt9ChObBpD7j9Ge3nuiV0wSCepoopOWnVAbQqW8uGjaH7zM0bq8CWkdhAevTXlQLnca2NiQPQwEkdr2Ir4hoqX75tXgW8VyK9MLkgMnOJq+uW5xU5kDI+oFpyd8HIm5aKPC8uvEdBPxxnuqXlq+jhxyAMyTyIPbNd3AXqOCgWOPguB3DadMkXa/Is2+RmSzQmlXxttLg0wEuZk9VL7hRfr8UdA1JDEmuSZ3OL4+fg1MsqC53qo78OJxU7A+gCZmWZIdfbAeR+biT6Sr1G/eAJ+hp5drERJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by MW4PR12MB7240.namprd12.prod.outlook.com (2603:10b6:303:226::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.24; Tue, 15 Oct
 2024 05:55:50 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 05:55:49 +0000
Message-ID: <fd1b56c0-2136-48ea-b3c2-5b2cbdc20994@nvidia.com>
Date: Tue, 15 Oct 2024 06:55:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241014141044.974962104@linuxfoundation.org>
 <1d31b7f5-6843-406e-98d6-6344e39966e9@rnnvmail202.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <1d31b7f5-6843-406e-98d6-6344e39966e9@rnnvmail202.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0312.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::11) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|MW4PR12MB7240:EE_
X-MS-Office365-Filtering-Correlation-Id: 83963b70-c842-485a-ac74-08dcecde050b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZENHcHhHdGcwQ00xa25sUDhPMlV6NElaSlE4bDc1RHFDME1HNzdUeEZ4REc5?=
 =?utf-8?B?WDMrSFJ4ak1vd0xvTEwxdkVaZG9HL0VHSFh4WWl5YitxQ0cwMjV3ekZCdzhP?=
 =?utf-8?B?KzdLZytMeGpRRmVMOSs5L2hzWmVnSyt2akJqYTNHSVNKS3IrOU5Yc21WN3Za?=
 =?utf-8?B?WWdYZnFRMGppZFoyM2RLWCtNcWQ0c09WbndsUERGU2pFWjM3ZXV4N1lJK3g3?=
 =?utf-8?B?bW1PMmh6NnhoK2ZVNS9RMzBvUjhicGVtZytQRmlQQ0E2ZTRsVk1kQ2MvT3FZ?=
 =?utf-8?B?UHNzNFV0VGtoVEJldTVSUHBNWlVwZG5FVnJiUnVjaGQ1WUlmR3BuWUdlL05k?=
 =?utf-8?B?Tyt4bERIZVBYMHpJRUZQUWlNTUg4UzBGRXZWc3JjdjhNcjVZQ09paWlVaUZ5?=
 =?utf-8?B?d3FFT0Nwa3NJN0MwNjMxd2NSYW5vZy9KblJia0xoTVlwQjdtdUh4YWpMN3Br?=
 =?utf-8?B?YmpFc1k5dVFoYksxVUl2dHk3RFZLcEdIVFhkRGEreUhpcUFkOHJEeDBESUs3?=
 =?utf-8?B?dXFhbUpteDRQYXk0amRNaDBQWFducjcwSUZPNGovOXJ4OVRrZk1SUDAycDZP?=
 =?utf-8?B?OERDNnBocmZvbmNRZUxZdWpmbkg4MzYyeXJUc0lBS3ZLdEVrQWVyd0k5TVVj?=
 =?utf-8?B?bWFEcTQ5WkRDNG1JNWNFbUxwVi96cVdkUjMwV2VMQUpiS2hqa0RxNFB2QnFk?=
 =?utf-8?B?UkJiN085NXB0TGtrU0JBYTR3cVRHaVJrdUhnSEJyZ0M2Ky9PZGhpaWFOcTV1?=
 =?utf-8?B?aWdoa29RRG0rQjB6NjJNcG9kZkFPbW9lZHF3d2V1cGxxQ1haUGJjN0Rveld0?=
 =?utf-8?B?dUpqRy80YUhLb1ltcGN0b1BtMzA2YmtTWE1SRm1jc2NXRXBOYnNJeTRZWVZM?=
 =?utf-8?B?ckRNU1M2Q0JqSzNZMTlxQjhQMVVnSmFSYXR5RVJmay84WFdIYWVKUEdGQnNI?=
 =?utf-8?B?THp0c0l6R1Z1aDRTQWxYaFBEVERGNm85TDQzdnJJdmI2aVhIdDVCUWJ2anh4?=
 =?utf-8?B?TUVvSk9RRk1JOVY2bThGWG1zd0F6NjJ2WnJIQllRREtjOUhsbDdtTDJFckJn?=
 =?utf-8?B?cXRBMndJeFNyQU5KV1lvdDZOQkFNQ0N0aVRyOUQ1L2dNTmxtZmpJTDRHWGdE?=
 =?utf-8?B?UlNoR0lkcWZCZWk4eERDU0ZaSzZSbWFSd1RPcG9UVEpNYjdWWmhkVW0zb2E3?=
 =?utf-8?B?eHprZ0Q4SlJnbTVuVmpIUE9vaWJhOFZOemhJMWc3eklaQXlXKy9HRUdzdnZH?=
 =?utf-8?B?YTdPTk51bEh4SVFPWE9tdmJsRG1xWGhkaWFqZGcrNDQ2cmhXMkNpRmZFaTNW?=
 =?utf-8?B?ZW5mQnZDM1BTSVB1K1A2dlhJMndxZjNsa3NQMzdUQzV1OWozMFZ1U29FTDY0?=
 =?utf-8?B?RER2ZHhrZmpXSVo0K1M4V05Ha290NUZBeGRJQU9OTU5TbE9BMS9kckVBMDZW?=
 =?utf-8?B?OUpIa3pxbkNKdlNCNjVjQW0rb2FOMGtQTE9nVWlERU9kYXc1ZkpIZHQ2RCtS?=
 =?utf-8?B?VWx4NjJJV3FzWXphZGpJeTFHSGNTZEtFWG9ENldmbnZQR1ZCTXIvaW1heDl3?=
 =?utf-8?B?OUdFL3ZRVStJTjhmWjAxVzAxdTI2eVFwcVhKL1ZYem5jWmJrbHVoNExjeWlw?=
 =?utf-8?B?Yzgra0tPOEt0YytHUGxVakxRKzF3WU5XTGcyc0EyRyttdW9WKzVrK3NxRUlI?=
 =?utf-8?B?d1VrS1RZUEVHMHR4aHcvVlNXL2N5NnNaczFEOTNSTWxKSmNlQXQ5OGJnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEdNMjBNQWZ2T1dpdjlWWFhtUEp1MEc4eVJGMWozMUhNczA1WEF2d3c3OFRN?=
 =?utf-8?B?K1lzZmRRdWlnazlPR2FSeXg3bzh1Q3RjNDY3eHNCVGRsaS9yMEtINEpxczRx?=
 =?utf-8?B?T1dCQ1A0Q0Q0cFB5NXdSZGpnNWcrdS84SXM1YUc1K2ZvWGVOSGs5MHV0YnlL?=
 =?utf-8?B?eGo1TkF2eFM1MDM4VmhEd1JKSUpLNHRNdEtWYnVtR2lYUFJyUERmb21BdnBX?=
 =?utf-8?B?UDB1eUNkWHhoeGtJMDQxSkFkZ2ZhZ1l2cHdRY1g0cXhLTnFMNG5oYndDdlVT?=
 =?utf-8?B?dVZzbmRkblZEcG44VUg5YjhWL3hDenNLdmFIUk02Z0pkRUNnOVdBQzBDZ1Nm?=
 =?utf-8?B?T2h6Tjc5dFRjM0FvajdYNS9iamJ1bloxNDRtc3h4SVhLRUl1YnFBbkV0WVdD?=
 =?utf-8?B?TTBadTRORTIrUHc0YVYxbGRzMUFXZGF5K25OVXRveGVKSTdFc3RzRDd4MTlp?=
 =?utf-8?B?bEVRWnVLeFdkRHNjQ1FoT1BLSHRuSjZZMDE3NTNQQVdqR0RaSTk4VG1uRExw?=
 =?utf-8?B?bGZQWThhdWFNRlorMTZLR2NpazE4Tmw4VSt2aldESWFzVHh4VXozQk1ucXhW?=
 =?utf-8?B?ZEZJRjFwbCt1bU5SN3ZJR2Foa1NIYjNzRjNiNXRhSXVtWWJpTlR4RDBWODl4?=
 =?utf-8?B?THh6Q3F5NTgwUnZ4K0JTN1JZWmpoZnI4RFNtV0hXS3F3dVZ0NWNTMlFmWlkz?=
 =?utf-8?B?V2RUcGhONnd0N1FSSWdOQU9EaVA4aVpCd2N2Ynh6cERkYlZWZWJLNENEMHpo?=
 =?utf-8?B?SlpZcEtYaHdGV1MyL21ndTE5T0QvSVBRb0tIRnhhWXhjbGFKZWQ1OTlEbGs3?=
 =?utf-8?B?WWxJeUdRdUJKcFNEa2FjakpvUmlTcS9GSERuSXZkYUhUQWo1NEFVanFJb0V3?=
 =?utf-8?B?SDUzeGxaem80UXRzMmVSTzBYa0dUY1N4V3ZKS1VFdGJxYlB5ajdKNVlRMGdx?=
 =?utf-8?B?R1l0TTN1VVJ5b253S3B2RnF4anhDTFVSb3J4T2pzWkxFWnhqcWt5SEp3a0d5?=
 =?utf-8?B?Ym4rSUJKVjVNV3VqRWNHUXZJQ0tNWSszaFowVzZZa081WlJMUjY4VEFaZ09Y?=
 =?utf-8?B?c2ZON2NuMWpaM3dZckQwMVI0amhuYzRFTTNQaDk1V0E4ZkQzVkNZQjBPdlhQ?=
 =?utf-8?B?UDRmL29UYjlSYXdzZ1padUNobm9NRHFRVTZyZ1BzMFBKcDBSRjk4UExqS1ZT?=
 =?utf-8?B?RzVqd2FaTFFWRkd5aE1HYWtySXBNdEhFby9hbTZQQXJ0QnlwU3NqdThJNXJj?=
 =?utf-8?B?YzkyWmN5MkZ5ZmNpanRycWdFWmwvdndyTFV3bFdsbk9lelhuclRaeXlCWHB6?=
 =?utf-8?B?N0tPSmF1TXFqWDd0WXlBaVRMM2pWRVlvUmdENFNHQ2hMUGl0YkhyMWxleHkr?=
 =?utf-8?B?b0xIeWlTK1JlbjRzRTF3NkRhMWMwTy9NWnBHWTZsaE5GaEZqa0xzUEdSNG9k?=
 =?utf-8?B?WDZ4VE5FYWNSYU8vS0dPQXFjQ1pZNllUbWdaRHBEbFhwb2lvOHZ5dXpGemYx?=
 =?utf-8?B?T3Frem5qRGhWdWUrS2JSVzAvcXhWTE1kOVB4Uk5RaC9tbXhDbTRuVEdTQ0kr?=
 =?utf-8?B?aHVxbWNJM1BhL1FlYlJQSWdZQlZnMjA5N2pSRzNYUDh0WDRZbGpqMVlmNXVC?=
 =?utf-8?B?cnBiazJTSnFUTU9Nd1YwMEJReTZBQ05Bc0txZllmd3FqTW5rdDNIcTh3MVJt?=
 =?utf-8?B?b3VKMk1uZTViTitlaFNrMXNsVVJmYW1ZSTlERUlCb0ZVV1dwOWQ5VkJQSG5v?=
 =?utf-8?B?a1U5MWhsYm5RRzdOSC9tSTllclE5KzZ0eG05cWJmRmpMZHY1RnZkazB5YnVQ?=
 =?utf-8?B?Y1FOOFk2YTdKRy9uMlZQM0xZSFRhQjNsNXMyUmFsb3B0QkRZTFF6SHY1c2dl?=
 =?utf-8?B?T01VVXVKU0FRRHRUaXZIOTdtVGxxc2lvaDFhcCt1WHpsNlhQTFFLSDFEZEV6?=
 =?utf-8?B?WnNzVXE2RnErMmFmUllYVDlvZjFWTkwzQ2UwQ3lEVDVOaC85WmovbWVNazNJ?=
 =?utf-8?B?cXdGbGV3bk43MVBWakhpelZlMnZEMkZHWExuamFqVFlFTmN6dlFUcTBXNHpG?=
 =?utf-8?B?ZTZ4QkNjQzBidW5qWnpNWkFTTVIzVyttTW1Rek1OT2RTMTIyZDEvNzhQMWJr?=
 =?utf-8?Q?HfL/VR9SOLPWWTgrQR5qDpNgb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83963b70-c842-485a-ac74-08dcecde050b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 05:55:49.2045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NL7NOBvtDfiscA0HGx2J+Ovimhvaw4e4hIq0xRWw7BnlSm+AZdNYOlq8oxiD29LgRL5TSxFrH07pZTkJ5UoRAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7240

Hi Greg,

On 15/10/2024 06:52, Jon Hunter wrote:
> On Mon, 14 Oct 2024 16:17:43 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.11.4 release.
>> There are 214 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc1.gz
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
>      116 tests:	115 pass, 1 fail
> 
> Linux version:	6.11.4-rc1-ga491a66f8da4
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py


I am seeing the following kernel warning with this updated on the above 
board ...

  ERR KERN ucsi_ccg 2-0008: con1: failed to get status
  ERR KERN ucsi_ccg 2-0008: con2: failed to get status


If I revert the following change I don't see these warnings ...

Heikki Krogerus <heikki.krogerus@linux.intel.com>
     usb: typec: ucsi: Don't truncate the reads


Please note that I am not seeing these warnings on mainline/next with 
this board.

Jon

-- 
nvpublic
