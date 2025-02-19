Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF451DED6C
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739970773; cv=fail; b=b6RU25SrOeTG7Grv7jtm1yWNf910D+3RTC4PNw5B+G+RYe0Wr62ZSfPsSuSWgDaK4lrJampYut1uK1zVJNP+pabWtMNR7j7SXI9Gvzj65yLc66T/fImeK0TFtViyPOLufT4o25Jk1S2RBLUcdHwY745sHdGxbEW59Ye7Mz0Dquo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739970773; c=relaxed/simple;
	bh=/C9XADiq+jJwjkf4i1yOW3J5Lc7AZiki3W5IPXu++KE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=od8Xr6NMlLRxy7JXlT7pOhfd7hOIZqH+ryn3SurLXTbyzP07StPiwvlkCEQ6Obx0zIieMG4KCxzMd43eIkr9eRs2epSfRe8cnBu412DkIGxMGmhpL9fakZQw7XiQ5rxopQs4pWS7KmMMM4HYDj3oYrt3ZD4kcOsQUIlO2otwBOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UCXWrOdZ; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UCXWrOdZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FNLWAxW6AoTgXHzMVxbAzjUYAaP2gg0oc1X+6NcbAG+fOUV18nHqrYXGo9Vw85Dfu+y/lw0oM8T2dGj0wbkYeUG0pnd8XpiK36gxZsLp2fXSHzs72/qJsuWxAebIw+Lyl4pEbGpAg2Erv61Qjd2KOEXb0Rewh89sxPnV7SUJ/U1RfxGFwYPR/cwvG0UXP/GFE6icQhYNXa8JClGB9y9Blvi/a52e8jjHhh8Yxb+Yu0WaJ4OHZZUh3UqlLY4hB4hWS0J/hidkPXOal1LbGHjEEzMBfX/fRedbgyGewn9DbkLrITaKVNhC6phDT/lPI0S5T8I3/NUaatLPw9/v/kbDpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgKe+wjZFox1IwbMZYPfw7JXrwb8YKrMnDgWXnoUPzo=;
 b=ZGAlEG99J1YbB27qFEVvln3ok8/W0stgkkcDzljT9jz0TCxiNY+woRL+iUfKYj1My80VXV9qaqoEvgMNKtwWyTaC7JD+Q0d13FU0o/D+NvJJ2GhkW4cNpw++J060SsJ0bMLoQKP2nsLmaX95RtCtaNyL7b1u3+j4Iu1mQgRgR05qwxsWoeATwVTarVKsI2BFKV8ipwQ3nZqbOyfvV8br7MvOxrIuAsgC9tDdL8xoCMndD/te3MKKOjWvvQ3l4nYH+hBULepRxQST2UQkPe2pqZsUffLXepsnEd1flSKY4MJJmulpfqU0rc6cLPOSp3cOEtOxVs8d7If6HNpq/tJTtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgKe+wjZFox1IwbMZYPfw7JXrwb8YKrMnDgWXnoUPzo=;
 b=UCXWrOdZefh3dU5YyyCABRlvmpeYfT5QJ5VKKys2zZinEBqbqacwzXNBOAefAlae3iUalh3Y51bmVUXnyMN04xdeF0teET4HDqac12PuR072ZB2srvH2hLGK0bFufCX1kP8mu9VOCiy3P5hIJW+TXy5EX2X546AquQJ4ikydxsVQtNu/o/iWhHwhFCle9iEMKkkIReVSYecPyY3WK8nKBESB8+MhD+ShiV4g/RLi7YJ+Kn6WiGgJwUKQSpg5d7bJIhaGEkwmtRpNrFDs6HmpnWRpY/pV3PCUrVLjOYqBY81MBylX2rqvtwwH0dy4f3eA51np7EMD2vJ30Fmm7nQUag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by PH0PR12MB8049.namprd12.prod.outlook.com (2603:10b6:510:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Wed, 19 Feb
 2025 13:12:47 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8466.013; Wed, 19 Feb 2025
 13:12:47 +0000
Message-ID: <9836adde-8d67-48b5-944b-1b9f107434a8@nvidia.com>
Date: Wed, 19 Feb 2025 13:12:41 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250219082601.683263930@linuxfoundation.org>
 <b5a72621-a76a-41a1-a415-5ab1cabf0108@rnnvmail201.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <b5a72621-a76a-41a1-a415-5ab1cabf0108@rnnvmail201.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0356.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::32) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|PH0PR12MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: a682d953-b951-41ef-b208-08dd50e71ac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N085VE1sQXFiUDE3TUlnV0Y3bk5lR0JQWnoweW1EZ1BRS1VBMjdZSHZxMll0?=
 =?utf-8?B?akVuVXNnVkVJSi83Zk9pVStXRjlUQkZ5L2hsWXl5dGFQZE9OTW5uN0V3SHFy?=
 =?utf-8?B?M0YzenR5MHNvTGE0SmVkMUE5cmp4S2dOSTN5UmhxUHg2NnhkZzFkU21YV09P?=
 =?utf-8?B?Q0QybVNiRFluWVNsY21hSjNNcU9uTU9kdHZHYlU5U3RUVzJOK1JTeCs0YzNx?=
 =?utf-8?B?VmdNeHRERUJ0b2tHMnFiQ1VLYzI0TU5jQzk1aXR5c2lmNFZZTWUvckZoK2Vl?=
 =?utf-8?B?MXl3aHBqVzgvNURmT3hRTlBZRUpUVHQ2d2NQQnZ5MGdQL3FvS0RzcWJTaUJK?=
 =?utf-8?B?TFlUdVBKdDBzdXczNnhIQXJ2Y3h0elNKK3ZqenBaZ3g5aWQvVkJzaHA5UzVP?=
 =?utf-8?B?aUJ3QmUvcnZ1VkFGZ09Sem1YNDUvMDV4VVBGQThFNE0xRW1rRngwdUlydEFq?=
 =?utf-8?B?c1BWcUh6ZjRvR1NMWHE3NkJyKzZwOVFwR3NqWTZBNGpEZm1ESDJsNzBhOVkr?=
 =?utf-8?B?ZGxZODNqLzNQcGlMMDQyR2F4d3M0bkVrQVREOTA4ZW9TMWprM3JrcEJobDV4?=
 =?utf-8?B?UkNST2NEaldrV3dFbmJNamRpSGNvaXg4Nk1zMGg3OVRNdUc5U2w3QjdIRGRC?=
 =?utf-8?B?azIrc2JmY2l5VnNlZkc5OTByV253ZmU1ZjUwa2tXNmczajI2NFREZFBuSks2?=
 =?utf-8?B?R00za2VsbGlxcnZEVCtZWnJWanhWdHA1NXUzWGZDdXlnUWowVy9UUGFDZUVD?=
 =?utf-8?B?UWw5TWR1WnprakZ4ZnNaNzZHQ1NSVnBLdkkyQnNTUDFtNUlPc0tCeDNIRHJY?=
 =?utf-8?B?OENvWXB5TGhMRk5XSDFhRC9malVuek02aklEOHl1SWtZcWpsMUFxOTRjNm82?=
 =?utf-8?B?V2pORHdDSVZRY1F1SmVNQXhzNEFHOUtFQWMva3JxVXVacEtzakxLS1pRb00z?=
 =?utf-8?B?RGIwMVpKK1B0Z2V1WVIvM0pxOGU3cmpoZW5TN3hDNDB4dHIzSDUwS0EwajJ3?=
 =?utf-8?B?eWIzYXpvS3dpKzBKcmNURVhpeUl3OWxKajlOeko2VElKdDgwOFFVa0hwNjUx?=
 =?utf-8?B?K05MQVlQVWF0L2tXVHRyM0NneVVOMWw3KzR3dlJCUWVaR1hQQzF0bU05Z1Bm?=
 =?utf-8?B?QXFabGE1T1dFbmczaXBQbzNDaUZPU3N6d1VpcUpoM25Yek9qL3NKQmJFT2Jn?=
 =?utf-8?B?NUlLN1ZkQ0k0d2RZNjJkZENIb25kTWpuVnBraVZoeTF1UjZ4Y0NFRTU2STM0?=
 =?utf-8?B?b0UzVHJBNlpPNXVpYkFvV1QwV0cxNUdqeVRsRGJxcG1uNEw0aXhWSWlGQ2E2?=
 =?utf-8?B?QW9sUUpWTVNZYkdDZldHMU5LREtROGIrM3ZZeVI5ZGJ3cTBtR2ZGUFpxcUZH?=
 =?utf-8?B?cDY5S2czOUpyU0krUEhrckVUdmRUUmo0OHp3WERsZzZ2SEdWZGdWcVY2M0Vm?=
 =?utf-8?B?ODlZc212ejIyOUl2MU9WcjZnbnMvRXZ0N2dtdTIvbjlBa0VYdktXWkhhR2E5?=
 =?utf-8?B?U1Rtb2U0c04yS1ZtaktURDRBNW1tVHd0ejRDM0RJdDEwNTg1cGlvNjRDa2F6?=
 =?utf-8?B?N1lHbjNhM2V3RjJwcURUNlZONWxvUTM0RkJ2ZXhmblJuaGhHTlBDL0VEYmN6?=
 =?utf-8?B?NEM5R2hBNStXelFsc0ZnZnVHaHdpTFNmMy9RbTdGS0c4cFo3WVlOVWZSN21v?=
 =?utf-8?B?TXpDTHQ1VHdyWVJ4SFowczV5cWdHZmlqM2hqZHo4L0dDd2xDbmxqVWY4Slk5?=
 =?utf-8?B?UE5Lc1BTMTlDN0kzei9VbkdBOEFPbm5UeWwyejkwaGM5UytUVTh1KzlETXpI?=
 =?utf-8?B?SkRlTXJuSEUvM2J5UVBGYndrR05kREZUWTZ4VHNLYXFNd1FRQ3J1ejB2UEtR?=
 =?utf-8?Q?gFRnSQ+EZ6y9c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2VHREY1eXlYWTZTV3lxMVNwcHpCS1VyNlYyY0dJOHFvZERxR3czS1NPT0xJ?=
 =?utf-8?B?U1dMVFMxbnNHRFExZE81b2E5NmdTWFRTWW5Fc2dhV29KSTZHNjVySHdaY2hw?=
 =?utf-8?B?aFphMGI5M1UyR0tHazN3U09weTcxTElGVCtVaTNxbVFSU2dnejlta0lDbkhW?=
 =?utf-8?B?ZVZjUjFHM2xVVW84UU56R25uRFJkZzBtM3gyakx4TVJRYUpDVnl6YldsMXBQ?=
 =?utf-8?B?ZEo3aE5rbHVkTlhibjg1dEExOTZOOVpiMDBUYmFhUEZIcDZWZ09obVVWZUJJ?=
 =?utf-8?B?NmtpTW15Z2YyY2lHS3YwZVJ6QVV0QnRLQ3ZpWjlSUFVld1M0cS96Q2FuSU9m?=
 =?utf-8?B?bXRGRzBya2tpRXdJcUU1eTc5cjBTcUgxMW0yTU8zSGpZUEtvTmlIZjlwdGFP?=
 =?utf-8?B?aUVuZW1xRGpBeG43d2UyUWVOanhVZnRCU0g3T25JZERGQVJCV3ZxeTdJU0Yx?=
 =?utf-8?B?UDNFQjNreDFIUXE0VXlTTU02VGdDd2NpNVRCTDlJNGllSCtkTm5vMVNRRnA3?=
 =?utf-8?B?eXBaVlZCT3BtbWZIb09ScFBnd1lOQ3JhYWtKN2tQMWRJekZxd0M1OWxPNllW?=
 =?utf-8?B?RDVYZUg1Z2prSWNNY1RRcXpwT2djZWx2Sm5jazNzNVRZclVaWXRaL2NTUVl3?=
 =?utf-8?B?SzVIWUxUdklVam9USzV5RjlJYU1DUVlKMlB2RzQvdlhEWVRxNXRXR2RxNFlj?=
 =?utf-8?B?T3lUblRvek5hRHl0cDY3Z081M1VUTURKVmNLVmpPZUJkL2hIaEl1VU5zY2hq?=
 =?utf-8?B?MnJYNDR5UklWbC81UXVybjgrVFp6KzM2MnVFbGh0dU4vQ1hOQ3NsclMwNHVM?=
 =?utf-8?B?em5FdXliZG5DYW9uQmdGU1J2aHN0bWVlbUgyeEhWcUZDNWdOMk5kUE1scXVx?=
 =?utf-8?B?WkJmVTBHU0Q3c2RnQmNJb05UUGJRZlYxVldncjM0a0hFWjFPZzFuOVpaT0NM?=
 =?utf-8?B?MGFqcE9PTWVQNGxWekFpSlFRbFNiVFFsWnhhZTlqS3FzeFgvLzFWRlBZODkz?=
 =?utf-8?B?ZWhFc0VQYm02KzBXWnJXL3Q2NnBub0dhNTFVZklpZjBlUlhUUVh6Y2FEVExH?=
 =?utf-8?B?WmltdTJ2VitxYjVJZUgrWmhjQVVrRi9qRE9MZG8rTVFyYVp4SitsSEM0RlI4?=
 =?utf-8?B?a2ZZTjhFNHJYVzRxcm5wMDgybmZEVTVsUWtGVUhNcHU4TjZ3MzF0c2w3NUxF?=
 =?utf-8?B?M2dGYmxQWk5neEtCU3ltQmlwVFA0SHJjSlNYcGI2Wm13UE9kOEhBNlREQ2Ni?=
 =?utf-8?B?YnpqSU5GOXpMUEsrRUc1NGRETmxMSDhtNThzMlpQNm1KcXlyd09SUHdDTlZq?=
 =?utf-8?B?cGMydEdudkFCWWpPMkUyaDVmeUVXZUI1WFdEVDE0TkU4bTk3V0FiSjhGZkU2?=
 =?utf-8?B?WE91OGR1WnFDMEQ4cnhKM2gwZnIvaW04QktqWjRHVlQ4MkhSaW1MUzZhZDRj?=
 =?utf-8?B?dWgrRjJyb0JEUDFFaWdjRG9JdnN5ekJXTEd4OWJDYzdJdTlWNHo3U2xCOEhz?=
 =?utf-8?B?djU2Uy8wSi9rVWJjSHR6cUR5WTl5SXVRQWpWNUdLbzFlOUhYRXBGOXplMm50?=
 =?utf-8?B?OExISXVCUEhKSVR0SFpmUlVvRWpyMXEwQkF2b3paUWM3cUFaQTJLZ3VGZnNT?=
 =?utf-8?B?V00rTWJJeGhsN0l6anpISmNsYWNLZ0JtWElqcm9DTTZJNDBrOXVnVTkvUFNP?=
 =?utf-8?B?d2tEYmx6WXcwSjVIcnFIenlVczZsK09TdDl5allpK05xSm5NMmdmaytYSUJW?=
 =?utf-8?B?S08vTXE5SlplQmlqYjJsbU4xYXRqS1lHZzB6Z3d6RndoelZ5WVVkRUE2WTBs?=
 =?utf-8?B?Tnh4N1Qrc0g4dEQ4TEIrQmdWOXdXYVFocEMyMDRUL0Q5RlhlMTROVkk4TnQx?=
 =?utf-8?B?dndPb29YbzJZK0RPN0VvaEV1TWdXVjVCdTN5TnF4b1F2ZUNvU2Z3Y1k4eVdq?=
 =?utf-8?B?TUlKWnBqNExIaVRlRTgrM3BNYXQ5ZFhRQ2NrNGJmczE5SnpGdW5YakwyeDJq?=
 =?utf-8?B?MDdXY2JlcXR3TmZ4dU0vTXZPbXlKS294UFFUdkYrc3VhaGhWS1ZMNW9BdVVN?=
 =?utf-8?B?UXplYjMwT0RTUFpWQkNSK2NSbGtSYzJ4eXM5VmtxV0hQQ3JXZWRwYWhUYTIw?=
 =?utf-8?Q?RTYzI8bUY4ww8s+9A/Q5qGFxN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a682d953-b951-41ef-b208-08dd50e71ac8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 13:12:47.6386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whv1HrIFPgVu83PlmaseCWjSwFL8+2Mxi+cku0yz0h4bfTmnYMWwKsgD/0PsEamn0OUthyosTc4xPL290XcuKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8049

Hi Greg,

On 19/02/2025 13:10, Jon Hunter wrote:
> On Wed, 19 Feb 2025 09:25:17 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.16 release.
>> There are 230 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.16-rc1.gz
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
>      116 tests:	115 pass, 1 fail
> 
> Linux version:	6.12.16-rc1-gcf505a9aecb7
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: pm-system-suspend.sh


The following appear to have crept in again ...

Juri Lelli <juri.lelli@redhat.com>
     sched/deadline: Check bandwidth overflow earlier for hotplug

Juri Lelli <juri.lelli@redhat.com>
     sched/deadline: Correctly account for allocated bandwidth during 
hotplug

Jon

-- 
nvpublic

