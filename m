Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88CB1A6832
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 04:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774326923; cv=fail; b=Atcjaz//vfvN1+I8OFS9e7HqgJ/bg4bUx41bqasXD9I7w7CzYHCuBlA7/50vuoYk0mGn+tYCHrHPYHUNrHXxy1hEy9FOXdGRdYpcfNs4AlHnL0Ftfi6Tr//FQYlrs03g8HMg3KiV2fWIRHlhaxKNkjSG2pXiLyn1cw1pQNr3w9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774326923; c=relaxed/simple;
	bh=xJwC6Y051hObPC2IDgfOShg9Qq/UV+CBbznXaMQf+Vs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DDyAECyCiFf90gMbcQQavLfq04MzKg+sE3CIZx8Q/w8/ckuFGoHhQ0vkKvGbN6xDY8TQzgtEm6+woIJTejY84XvRwvxnvkk2WryC8x4/kt3czY8IPO4KuHwCWaI0gMv9mQWKVSXpEefqjCnqojYKY5Z+t+MbzZxX7iFLm/o9yq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TdIQS5Hx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HN7dufNu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TdIQS5Hx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HN7dufNu"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62NKu5lC3706027;
	Tue, 24 Mar 2026 04:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=g6T/RCCrnG8x0M3xgCbAoZ+pBbXn1GLtokvLAFA9xYg=; b=
	TdIQS5HxZyMlFVsCGXNpuzTT0AzUPP9IKFyA/d8Jgvtn49pYYZ8HZXav2JSyoM3K
	PfHoAesNfwsyPlvlAcoHVU7bUJiMkXhwkcYH+1cREAZe83J6WHeXb5c4CnZsAdPQ
	Zvv4hWaagIFonlGsUPAFDB8zrpPa0otQtqIwWOdj1cS9BELjPZCIp1fIU/fdhAyT
	LeC8a8DDkmSh/7YExGl89zISi4J+Amq5n9I+JZQVSnT8Qx2r9kXEYT146gYN0ilB
	bgi0E+itt81H9mbH+kzui4txaI2KuTI0MDPlifvyqvoM9cVyTDGj/CvsMJcLYLnE
	Y0Vnz9di09WP35vyxSp/sg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kfpkgvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 04:35:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62O22qSE038469;
	Tue, 24 Mar 2026 04:35:09 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011052.outbound.protection.outlook.com [52.101.57.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d26xp02y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 04:35:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yET1Jt96EMTbAjF9A4uOVBKDYAR2iogN2+ObQCv8jK6agJsKxb7/+WHnrGfpsd+Vi+TPGtcNbhiOBZDb6F4T14F+YUhW6RC7aTimTh7iObOM/+tAltK3m/NordKaJcVP73SRh2OfPZStx5ae/dYuL1C+IovPeKchs4rU++OF+I1R+gBCmubW3gpFHLaZwD/G6TBS4RoboQBoD6NMS88U1Q9Re+y/P6X2u4Op1KwFUXomQ38PWg8ecCm3aYBfP0mlUrBqH5cU8o/9VBek+GPzIWKbgD/2Ee9qmNES5YvdhE7t1gjvIatGLZ9oLIiY8pmwzhfUnwkARx6q621KIoBqmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6T/RCCrnG8x0M3xgCbAoZ+pBbXn1GLtokvLAFA9xYg=;
 b=XPmJS44KVND8H/Zt6L0ZcKPXYCYde9y1W0TcYCIh9XLAUQU1tEn5ocDUpncct8QB2ih1awaLDtJStaOZay1GvFyru3WAHaEJEx/Dz5eSdk38LUyOotJypR510IEU+7tRrmw41nGwc3yNHfrUsakPls9G12qcaKur/PHaOrVPNJHvRPOtyeJxpo4zIQfMeEdaOu8+dlgIW50euEeigL+UC6B7aCjkTO8w16Jmxz7BSkG8t114l+Y8MMfopoGfCOZeA6eI2IaPSRrTqDmCINuJbpKB6bO40ZO2GA1SUfiXwyT+nl5HFvqouTm6smmj9/29BLM8YWHy4hiEJ4f2WSHEsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6T/RCCrnG8x0M3xgCbAoZ+pBbXn1GLtokvLAFA9xYg=;
 b=HN7dufNuWAseHpQFElBXs4Z1LON7b+W+w4f+mq16/DpWzqy6Z4P3l5y7n9GD9MT3suBOQeC2VpuOJ80+V3TzvbmxgxkI+AeGShm/NyMhTZMQrLRc6ML6F7y6DNVg3ZpiJsI+er3E7Zsj6xUg1NCB/gf1v2vA8ya+oMFBEMelMCs=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS7PR10MB4896.namprd10.prod.outlook.com (2603:10b6:5:3a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Tue, 24 Mar
 2026 04:35:06 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9723.030; Tue, 24 Mar 2026
 04:35:06 +0000
Message-ID: <91e09934-38d8-45ac-8f7f-17875065ee43@oracle.com>
Date: Tue, 24 Mar 2026 10:04:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260323134526.647552166@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX1P273CA0036.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:20::23) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS7PR10MB4896:EE_
X-MS-Office365-Filtering-Correlation-Id: d6efc29f-1e58-4d2c-69dc-08de895eb902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qfphAyFHt3XBxRSY64IcpprshpLaLL29R82oNyo3tgw5q9MTacc8I7Ckwk0ZqOPDn12t+a8bMszFHStv81UuWnqfu2LBDnbx/VeYM8Vt9j74Hy1v+n8bY8ehCMhuzJJVkOj+ISnBOyX6DwwHWwtgfVCrPcbQCHLFW2LRPjPcqzJZEaIa+eXocqhEAwkqIuFiJ4drRnBH2JjLpUC5exMN1R/SE9RzqRRiGj2Nx+Jf0criaNe+OPOrMWIL3EL/PHPRksQnhvMQLjFze99pLnCRqHQ8iFFN6j8KhLY7ukIeP2F+IyPJhlrnLqAKjJWlf0r4WIOLkw/OTowl018Z7a/AWrEQ3SoaKv/iBvrfRlhBGQRIEdw0yNl9U1vo+0lW8icYeAGOf+KvKkenT1NZeL6uwzJZNDVX4FSHDxZ1FAIG8NE/xYaxaGJCI1TOFzq3ri1GGGug46MC9onF5M0QxTT9dPVxqaydKVgI7IzOuUbqiZCzrG7kjhdciJOPw+F5nNCVz52vMIqoAL5iALwIU7TD1r3J8Ho2pE87D33INTPQMYlasklNhvTJxFw7dt0T1wPKR6iscXP7Mh4UkyTyt7LDz8sLS63KjvD6Kh1grBtZ0hjUbCW8zMLaeKNTs6o0Wo/UND9ltdf9XWsUPC+MUTQxknWGIVwMOf+QeqdxJHdiYzcgnlzyntdArFFngzwAOpVK0sYXowubgZ+c/+icwRmYzqfOpjpHPUftkM42tL+8S6w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nk5Sa0Q2ZklSaWt6L0E5K1NLUHVhK0V5UFUvR2s3YUtLN3gyMmUyNElaVkNs?=
 =?utf-8?B?dDFYcFJWY0ZLTEQ2S1MzdmNmQmVOR0l0bDZHTnFIM2ZkMmRjcWcyK0xoVmNp?=
 =?utf-8?B?ZkJ3Q045dzBTTTdUaWorNjEvVkpEMWdyWHhvaDVUUDl0K0lTMGZ4a0E1VkNz?=
 =?utf-8?B?bTFjTERGYlFPWlZkNDdvTENVNGtHYUlwQm1pMGdYMjRlNENkQ2xnZXhCUkJE?=
 =?utf-8?B?UmZVMGNrdHljR3dHbU5DRjlnY1NoZEk1TmR6dmQwSDlFTUtPSUpYNjFDMzFI?=
 =?utf-8?B?TUQzNnpJeEZReUppc3NrSXl3WXRlWDE1WFFQZXc5b3FFSm5uSGp6YVFuUE9i?=
 =?utf-8?B?cHZlTkVIUEYxU0lLNTBMRFpXdlFvb0MwalYzWk04dHRQLzM2OXljOW5NaUc2?=
 =?utf-8?B?OEFvZUtuOUZjMDEraXdPMk43a1BheGpXd0N2YXVncExucm5LZkRJWXdTb1Rt?=
 =?utf-8?B?WW9JY2laTDU0M2RUQk1aaDA2L25JN0tlU0dmUlpoRUFKSmFwQWxRU3NIRFBS?=
 =?utf-8?B?bkhVOHp3eDNOekZNL002Y0JOSXdMT05jL09BVDMzc0V3NUtXMVhERFlwb2s5?=
 =?utf-8?B?Yi95QzU5eWlzQ2E0RU1rTU12ZUpRNjJ0WFB5b0ljZWVHRkRxM2MwOGcvLzYx?=
 =?utf-8?B?MlZweXNlM0UwWVBjNklWY0hSMXBrZElEUExsZVJlS3RpV00vSTRUenNHRS9I?=
 =?utf-8?B?TXdKVm9wN2RVWUZTenNSbDNxMjlhU3FwWDYwZ25ENm5IZGpaTHM0bkpJbWc2?=
 =?utf-8?B?aWU1U0s0YUQxV0ljdi9MTW1YVE8xbU96VW1VZ294dlFTd1FWSGloLy8yWU9p?=
 =?utf-8?B?NTZNNW15b3ZkcUdqWmdSeU9aQ3FqK1FMV2VJdUtPdWJiRXBiV0FJK1JnQ2pm?=
 =?utf-8?B?S2U2eDJiUzBlazg1TElXbE5VT3VVOU5SeEdBRGNKZi9KK1VYdTIrK2lhSmN2?=
 =?utf-8?B?ZC8ydUN1OU5OYldMQ1hSZStIOTVsQ1gwWFpla05hS0pIZlBQOVU4V1dMN0Rp?=
 =?utf-8?B?aW45Y2QwZkVKa0lSRFlwK25OUSszbmZ1cFhnem9RRUlGMXhKWDRBVk9yTDJG?=
 =?utf-8?B?VlNnZjZ3RTF6T3luelE2UzlmQ0lpVFhSMDJ0ME1RZlIvOG56UjdzRWhkbEdH?=
 =?utf-8?B?dTNKU0VFWE8zdHA0dC9zWjlkSlhja1JMdGx5djE2ZUorUkwzNGI5N0FnWU5I?=
 =?utf-8?B?WHFtTkdnVUQxVDlOSmxaSnJ3RFZUeUpHOTZvUWoxTm85S2svb1ZjRzFpb0dM?=
 =?utf-8?B?TDl4cUxKK2hOZUxNb1Viczd4aW9nTWxKMkYrRlBjTVJnOHhWUm9WcTJ0b082?=
 =?utf-8?B?V2NheHdMYU1YWDJYdFd3T2VYZ3Q2UmMyUG1INkgyTEtTNHZCUDJmekEreDJI?=
 =?utf-8?B?cmttYTh4WldwNndDbk01a2ttUWprb0R5VFAzMXhuTzZMS1RwU3ZjSUZXRlNl?=
 =?utf-8?B?T0J2SCtJWW8zWk0yYXBQSW93Ny9Ha0dRK2dabVZSUUlJcHhCb0dRQmNjcHVR?=
 =?utf-8?B?ODNnT0I5MzJDcjd2aVc1dkJqV0FCdHB5SGhCTVc0UHhlaUhLeUswV1NxTXlx?=
 =?utf-8?B?STF2cFVnOEtvQTNWQWZHRHhFY21vdVRVREZvVTRFdGdLQmU5QWgvcUd6QXFn?=
 =?utf-8?B?Q0pRYVROdm1Pd3J2S2ZGZ1BaQ0w1QndHUmJGVHlJb1JOZHU2WWVDNjZIUFFW?=
 =?utf-8?B?MHJBWExwamxDWEtKU3lSNnBLU1RYUUl5c2ZNeWpLRkxQNHU3cEVOQUU5SHJO?=
 =?utf-8?B?aU13Z2liNEZKR1J6M3M0WGtlMmJoYXlQbk1wcG5zaklGVjFrSWhjSU9xZkRN?=
 =?utf-8?B?dUkwTk8yQlVnVXFHZG1PL2xVZzBDdzB1clZpT05KZlpuSlZ5QmlmSVVNMzhi?=
 =?utf-8?B?QzJsRjE4ZnJNM3FMTHVLNENBUTY1RVVNUlhHcnROR0o3MEFJRG1HenNoNGdY?=
 =?utf-8?B?emVlbU02Wm9YTDM0M3dmczBYMDRNbzFhaUtqNDlzZEh5MW4vUzRDLzhrMys4?=
 =?utf-8?B?MkE5QzJ4em9zaTB6ZHdDSDhJaGpUWUNhQXdGcm5pVitnNGJybUNVUmdsclJZ?=
 =?utf-8?B?aUN6VzlZRG9jUktjcitFRWJUSmg3TWZ2TTZWNjRJcmV1OHVCZ1JwNHkyRUsw?=
 =?utf-8?B?UXk4dHdtU2ovelpSeVY5bndjVGF0dVYzKy94L2F0MVVpbzlQZ1c3QmlKRTdV?=
 =?utf-8?B?QnRHbnBFMHRPT2xEU0dPT1gyeDBhN2tITUkyYlhiaEFmbkt3OHBGSEltS3Vy?=
 =?utf-8?B?cTN3cVdMSWtXaTUvZUw2MWhES2o3T2NkV0dSbkdDd2lZekNMdXRpekxCY0xE?=
 =?utf-8?B?WVluU242UFk3eVRRT0F3cU01UFZoNkNqakhiWTlsaUs2bG81S1RYNWFmL0xO?=
 =?utf-8?Q?AaCaol5V/40IebcRLrGTKNoL2zoIBWm3Wjqil?=
X-Exchange-RoutingPolicyChecked:
	gOI9UJsxZGJRUP/yyrvgbvy85mlqdjSGpQh0SAsJ3xrHxMMEbxBerlWmK1obRpe3k58VwVtWSbLzy1AIQz9THFmv8g3MGHV92M3bDbdOOsIRlM+NvbULWMSZtCAo0VQi7H2YVHBBj+DMPAGtR/CQvK7ncbjPxo8PLu7b31A3BbwL30R8OLfb+pf8F2uUNm97Y1IzGu8XSGdFltDwPwbLwU6wIioaEp08ajd6R4SWjXdtzYUXSEN919zDfypQQDZ+QvzLXcx/+YpsMq2z1qb3vC3wtIXTCukAwRBZb/ljeu1WVXUHC9Q4w+QezbdpnP+F1HkmNtet0rIfZ8+KvoyncA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7DKjq6Zl/TYtmDMHr+Rg9bpIPuO+1tfUQozC2omxBADpyfLptv1LvyGOuASYvytZMWEAD16VS3ngTevAVU8oNVgYPO3XKPY9/6IzT/8E0t3M1UVHtd0P7pMRTl4r5EcZBj1b7Qqr0Hg1XyRwr6Q+eIo7ExGAjyGmyvfzTURN6K5idCIKCvB+aV7CsbVJ31G2qrLibwTfdkFQhxyUhFBXA/ozC/5ORHQ+F8Enu3n8qKKER2gGzg0MThYOonWsefQ4FRcIVgqjAGbHwqmJy+IuckwjpRHJioHzIcKM47bij2I3D1Kw+hD/QiFCoePBPnL+8kUQShjBR7svlP/UCvPvP5JexJti+xgadLRABchso1XP1PUbhp2OUxA6iF1tbc1oNXBS32BWWfSfV/KLTpR+dNxshntj9sJzFbXGFLpjiUxu1T96W/5dZnTz1poX6ipocmuQKvH4NVwxVndKubiB2OkK1ganYVBHrgkRsfbXwvK2UbEsbDR7i/lsRvkuWURnkdo92c3n+Ty7lzjfkv7YpWx9Cg8n3DTHShbGtbioBSTTimHNCNO6F3pBh9dxgdHOAOM71XmecugmiFmmyUZJ+2yLTW4z1gzTn2eS44PrPJU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6efc29f-1e58-4d2c-69dc-08de895eb902
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 04:35:05.9944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6OLYuUaUFCbjvqdLW72Njyt4fbGVE1Zc8c9hKJ5lPSP8FdrzsFVYZSioEFvfoUigMTR9nITM5+HCT4DQWy0pr6s0HcRIinmkFnc07cDpnU+g6YkrAjP2WsUMkzhDQKVD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4896
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_01,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603240036
X-Proofpoint-GUID: u5xgytvG2T3MOlJ2m-cZM40e1_WXPXPo
X-Authority-Analysis: v=2.4 cv=VKnQXtPX c=1 sm=1 tr=0 ts=69c2147e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8
 a=UlE0iww382u4jLCPTdwA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12273
X-Proofpoint-ORIG-GUID: u5xgytvG2T3MOlJ2m-cZM40e1_WXPXPo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDAzNiBTYWx0ZWRfX/xVyUoeutkOr
 HocZ0ieM5RrP1Af85RGw94k0LPWm3B2g0AmHCPWIB1RcSt3Z4GLoms+YKyXX7xfZFAcZwoZ+ofo
 1e/d0AacJrPw4n7EAXp7qv0ln7s652oa4N33kKgGEICxmCPl26lDlrr/6Kpd5LeGDvh6H3epaB5
 lurLjGh0Nr9ka+mTXjp34j9QSmhAXhhjb0Z5oq7wFC1mSqMEhsycUOUGG3d+lEQA/aCYnwTXPZX
 WRiBITZYpGCwXCgqtqQpW0hUjWpSM/P1tI5pgWQHiFhHimXELFjYKyw+WR05aMiOIUG3fI74cra
 b8NLzGEaWHj0uO3vYCecrKYg41y3kUa/vpzbM6RnbDFwULr7S2cwRsxPEQRPIrzlYgnb0fuB9Te
 SOvBtsDaEiCP1mKaE4RAZu+sK2j/WneewBOdsqV3b6I8L51ba/WOA8JH17Nfe1qWEKO7kiyo0BL
 K4YxV9Adau1UKe6iRS5Rj03lxHbKnSDfR3JHdUd4=

Hi Greg,

On 23/03/26 19:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
