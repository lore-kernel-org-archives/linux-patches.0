Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E767B433E9D
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 10:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518085; cv=fail; b=ialEA3QL+dJwRlOP6q2JlW0JPLBdCgven+y+UVY1mVFk4IXSombmAEg0Gn2slY5Xsi0bQ2qHTCJ9g+zSoDNAtdXX2ZbyXLArMKO6q22tNbqCkXgqEZs6/eTaRF9Q6LidUf64esAgKUbYSxGVdGOdDIJX+jkjHeEn2M1E8gSKF1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518085; c=relaxed/simple;
	bh=cNfAe2FdeebffGhgqCSZVKKV+NRGF8Z5pg4jdJVQ3Hs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CPfev+8igWsgNwTus9w3wHzgrhgqCQKD/rz/qn8yixvZm4nbK5j1rTP9obJgiV3BR/Db1OO51hno+MEh/wP2sjJ1Vwqa87DCjcxIjZWPMgESp+2Y4GsVlSpIiJ6uo6MZa6S4WtqmxYEvNsP4ehqLSjvIeH9TyQUB/2K0XEriaVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JTEYnbkJ; arc=fail smtp.client-ip=40.93.194.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JTEYnbkJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nWN6M4DCmAztd66F7C6K/iYmuMDH+RVvmC9aVF0JayJ7gsW8UnSJ4AoDyC/p0DNkbShjKtpKydarmFbecys00YSt0AHwX9+fyRw30aYFC/Q9moEkMJOsCgHaiUdQx5N0xa53m1b9TDOeDmbqE4/aaGmZPl0UQ+62ld/xeGAy0CgDm4QCqjLhib9p7oCm6NcIpfjSYSuCDyLVuXumyNBE0OuvDTKwKPfGcE1MEdGXjJRK7eWuHlWY2eV2i52Ra5TKc1QbgNEaaBfMMNorVl+Gec1bISLspFfpo0GY0pQlCWmMy3pK4WxAQi3RndupPWeXfRmyIPbl8QpWzJIZ2Lmfdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/UIXL5Rjvorm6ajOZLeKf3D0FFIJld/akrQEPd67Tg=;
 b=FrtqKQt8vvrnG+POyMrWdNDEb7U5Rm/Up4Iu+ULu7NZqqXkvEjYKhra+ETsmJmkWQfNYFHdHldi0VJdNkPKbniK/aXq8R2O1Rzy01sWSUr9jUkB1zUcxGHcm9VkvsFsJxECgWGD8sUDXf024cfjNBqrzZxwNLjRRZdmGCTazAVlS6qkWrHwtw0y8TyayHekEPK1hCVYTc1MUheKqzQC+3QOEUP03GXbYaSsExHR/Deqo/F+EH0fbdEqJo3SW3ulP/wpEK6kO965Bv6+lXuk/jZmePEg2vYiwcH+LfCtZVLS058lzLYZTW6G2elSCkhAOHScktX+CrQ845xI2GwR5pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/UIXL5Rjvorm6ajOZLeKf3D0FFIJld/akrQEPd67Tg=;
 b=JTEYnbkJfWh31CQ/QLpIkhvDzD5a1rDwPySA7hwXmlAgsl1249WB9QWZtFDb1YPaHvr8mLm02r49RDPY27ZzRmjdGUlgMV38yjtWnmnV+fRIy4FBW1OtD5LGeYbe1PkqQlKO7AJke26hC6uDN2+Eyhbwo8cBgm/He6kmQhk3BsKwcC7sH+q0npLbPp0k1i/DMSSd+/Lj5Sh+FSXU59aWkJjEf4Pxa38cqd20IlUX5OTQyhX3VEBjGRbHr0IKfPbKIDE08SEQTGlOq79cofMHF5ZtIkwNs4KMN7I6tRvJTrKgRVs10FBtl2AUpsVhdfAFLcQpiKF0UZvihMkWxsi8AA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18)
 by PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 10:34:38 +0000
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9]) by SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9%6]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:34:36 +0000
Message-ID: <88e9b4e7-284b-4943-b0f7-97795d63991b@nvidia.com>
Date: Fri, 4 Sep 2026 11:34:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/403] 6.12.109-rc1 review
To: Dominique Martinet <asmadeus@codewreck.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260904045734.806166532@linuxfoundation.org>
 <apqKYeQe-78JWI3u@codewreck.org>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <apqKYeQe-78JWI3u@codewreck.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3PEPF0001DBF0.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::315) To SJ1PR12MB6051.namprd12.prod.outlook.com
 (2603:10b6:a03:48a::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6051:EE_|PH7PR12MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: 583c8d71-849a-4784-bc1a-08df0a701d8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|10070799003|7416014|376014|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zLfsABwvoSa8reBLMe2YBzBYzy2Lv73iDTWCgnLvzQRtDPm/fknJxoKZiaSfLfS+p5VCqarbqmdn9E42elCVgO13/NRrJCDlcwvgbsQsRVPkshwrhwO7Yodqowx/XrGWw2HdG5NlD1a1rbO0B2uXRXbmO7i/WXO7rE2fbyrb1cEhfOCs2lETyRJwCqRoOrfdA02YReVBvDp1Xv8dDeGNWsEYKWgYW2wEhZTlEcuunpydysGC6HUz018TC7RGRIPwEgqet/ssGO1+xGl8iaDPP7eskk8NvhO+Ry2YWP4HtSyNe4JblJ1A0rr+naVJ2snLf5smwQY/KRti7E3UxOPMjf8nfgEjGsWNaGkNLw9Hk0dr5l8DvmdgM2RnmpJx5iQ1CLSrlQZSWIA05vM81dgqXUlYuz0r0Sxz4byHSFudFD9stNVIt92B+va27kIzaVISCI/5wgj2qbYaXCY61VZPC1HxVs1/7nfnDb5s79yjWwyt7x01geojJ6xbk1NobNWvGmEtUElqVhT9JGIwO/jAqTKPM4nka75uf41C2eWdypBc9R6SkkFNQwDqPgxZ1D5onAaOF04svYRCos431T/ML9UFT0dpcGeH//oB/D2M0BeVmjcCE1oGKcBJXf+imLPt4kgCykUC4J6AEQid0Ue8F3Ubw94xJJrvMdSewCnh3Aw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6051.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(10070799003)(7416014)(376014)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V00zdXM1YnNoME11Qlc1NEFNVHh1ZTk5UGJpL3orakVHOFAyeGJhWTRTVGtX?=
 =?utf-8?B?N1pXMkxUTTRJRUJxOFlHZnlmS1pXaGpocEVBTW0ra3NSNis3d1NxVXVvQ0cw?=
 =?utf-8?B?bEJMZTBJcVFNNkIzK1kxYUhPQ2xGemp5dVJEbG55Mjk4T2hybGZPL1dsTnhp?=
 =?utf-8?B?alBPcXpMbmFEa3hxMXFnV2VhUTBQUXNpRTFyNW4rSWpLVHAwNG9oYjNwcHh1?=
 =?utf-8?B?dzBrcFRieTN1bG1lVlloWFE4Y29IOWRUREdsQzM3NzlyUGxDZFR1dkJkQjRp?=
 =?utf-8?B?K000ck5HU3JncHZ1M0lsRHlpdUNiOFd5ZGVsWm1uYkhCQXloTDEwaTI2UGtj?=
 =?utf-8?B?YnNrSlpXSS95RDhiallybFJqOGdLZ0RBdVBocnQ2THVYN1ZKaU9XMERQK010?=
 =?utf-8?B?UERqRjdyZCtLOFZZN2RNU2RoNXFaNm1hQUJmK29JSG9EbWp4QzhNQXVwd2d1?=
 =?utf-8?B?R0pESDlpeXhyMEV4S0xOM3ZreHI4MENuNURoUm01TktxWHFZMzQ2R29kcmM4?=
 =?utf-8?B?L0YzVUl1Z1JiZE1Hak1aVDZLYjE4cjJnMGdTSkJ0Ylh6RWsxUzdmazQ0OE9i?=
 =?utf-8?B?VmhWYmtWcW1CbWxWWUJJbmRSeVIycGdSRGVBZXRrSjNEZitzNVRTLzUwWDk5?=
 =?utf-8?B?UHdwaDY5S3pEa2xkYkhVUlJSSWFXNlJkeENsd3NpVC9wL0FEQWl3b2ZoVGE4?=
 =?utf-8?B?aXZ1WmVHZm9DTzJRWWtlSXNwWEdYT2xRVXl4TkdON1plUmsza055M1lHVFZI?=
 =?utf-8?B?R2FkRy84dmQ5MkFuQk9xVXBKKyt2TnVSL0dKNDZGdmlPWjZkNXpDcno0M1hT?=
 =?utf-8?B?VUx3b2M5UHlYZi9wYWtPRk81RldVRHRxQ0ZaWlhJOVVYU0FFUVRoVi9LNmJN?=
 =?utf-8?B?b3FLRHlXNEdlVlBFc3NkaDlKUDlaWm9TNVFKdk81ZWJvQ2VTN0hmRjdKeFlN?=
 =?utf-8?B?ei9zeTE0NDFmcUl0dUl2V2JpNnRoL1hnQ3VZNk9KRm1HUld0NXgwWmV0ZVJ5?=
 =?utf-8?B?VVdIK3JsTGFReG04a3lxc1kvekxBN1lsdk96czd6MG1udG5QWXRiSTRsUkl4?=
 =?utf-8?B?N085UDlGelRQQ3J1ZGVITDdIbnltOHVTb3RCY1d1K2ZRVGMzYml0RForQ0w0?=
 =?utf-8?B?MW9seENjUjhsczlhZThGTmpYYmpoNDQ2S1V0UnFNSm9wNkV2RUg3N0RxdUpB?=
 =?utf-8?B?SGp2RUNMS0lzQ3F6QU8vYWxjZmZMLzlIUU5CZnNEcGcvdTlsUWlqYWt4OUFv?=
 =?utf-8?B?TExvMHdocXN4cVkwY2Zvek9jbDVDamtmdFU1ejMrR29ncXVFNWd0aUx3YUpo?=
 =?utf-8?B?Ykx2SVNjcnM1R1hHb2dYSElpdy9teXRUMU10cGpYdUs4aVcvd242QnJZZTkx?=
 =?utf-8?B?T1RJWUtxcmFZRlF5eUI5eXp3ZUJCOVRHQm15czZ3bmM4dmw3OU9IbXhrSXNP?=
 =?utf-8?B?VU1vRGcvMXdqaU4xS1VKZFZmVWwzTHNGblgrK2djSXg4b0trMFNlMGc5RzJI?=
 =?utf-8?B?Q1AvMkJ5TitaMEptN0JuT1V1Vm5LV3Ywbi9YQjZvNTNnV1FnUTYxWHNPa0U5?=
 =?utf-8?B?WmN2V1E3M2tOc1Zqci9DNDdUOFJmbGZ3R1FKTEYrTE1nbzJZbUtoLzFOVmpv?=
 =?utf-8?B?bDVibWFoVXBGMW5rV2pzdzMyd3F3MVJBcGV2VVE1bTV1cjIvTzJLN292YmQ5?=
 =?utf-8?B?L2Q0Mm82RnpqQkJBRWpNZWtiaGlmdkpubGw4anRNRFczcHRPVkl3VytRZmQr?=
 =?utf-8?B?OXdzZzJQQ3NZRHc2RVNUK0R3NnBPSDhMcXY3ekpwYklBRldDNUk2cWNRZU1p?=
 =?utf-8?B?eE1RUHpldUhTelN0c2djTkRQbCtoYmNpTXA4VUlMYWJsVVB1TGNIM3h6UG1n?=
 =?utf-8?B?SUNuQmZ6ZktCT2I2ekV0ekpNZlMvandlM1hqZ3luT3U5NDJHeEJoeXUvN2cz?=
 =?utf-8?B?MUlhUnF1c1UxbzNGR1ZQQS9UMG5MckcvbVMyaGxqV2JwZ3I0ZHhSY1VVT3Br?=
 =?utf-8?B?UlpXTWQ0cE5wbzJlVkdPdExzZk9KNEc3Rmx0aHE5WFUxQlo0bHdOWk5kT0tW?=
 =?utf-8?B?SVFGbmlvVDBnV0lFOGpoU2tqcWs0MXYrd2tCUjJtUVFsZDhDTEJBWnR1cjd4?=
 =?utf-8?B?NnFEODJCYkt3MElaWThUZ2NQQjlqL09kc2ZjTWZwWWgyWFcyTVBTTTJvYjZn?=
 =?utf-8?B?cnAwNzhaRDRSWVpCVXpJS29hZURWVXl2VGdsTytiZFZPdGtLZVFJZmM0NEVq?=
 =?utf-8?B?ZzdZMTZDZkYrd1lWQ29LODRBYWZWalVyVGdJVkZUZDd1T2NwdGtBc0VFT3gy?=
 =?utf-8?B?ajZSOUJRVll3L2hWNzhXSUE1Uy9BazdCeitCNnJ1Q0ZSMzA3cUo0Q1c1WFB4?=
 =?utf-8?Q?yWDTi7Flk6qhNIJ0wuyrZUO76kD9MbHArstOy0gD1VCWe?=
X-MS-Exchange-AntiSpam-MessageData-1: 8JSKoA78CaANkw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 583c8d71-849a-4784-bc1a-08df0a701d8e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6051.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:34:35.9447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uzx3bjjtWxLHKmozqoXHGQgO69toIwgY96guh/CZiJeMpW5ZXCZBTUzJ+lj5VfgN+kYdxWyjzu/yCCeccMkQ0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805


On 04/09/2026 10:07, Dominique Martinet wrote:
> 
>> Dev Jain <dev.jain@arm.com>
>>      mm/page_vma_mapped: use huge_ptep_get() for hugetlb
> 
> This fails build on arm (config attached)
> 
> CC      mm/page_vma_mapped.o
> ../mm/page_vma_mapped.c: In function 'check_pte':
> ../mm/page_vma_mapped.c:103:25: error: implicit declaration of function 'huge_ptep_get' [-Wimplicit-function-declaratio]
>    103 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>        |                         ^~~~~~~~~~~~~
> make[3]: *** [../scripts/Makefile.build:229: mm/page_vma_mapped.o] Error
> 
> 
> Don't have time to look further right now, might have a look after kids
> sleep if nobody beat me to it


I see the same (appears to break 6.18.y too) and bisect points to ...

# first bad commit: [25fb3e9ad3b665b57e218dafb58acd13b1a672b7] mm/migrate: use huge_ptep_get() in remove_migration_pte()

Jon

-- 
nvpublic

