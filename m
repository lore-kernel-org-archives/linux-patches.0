Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8167E3A382D
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 07:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787298182; cv=fail; b=bYJbS+/4TMOPRDyNSIWgLG7BwRSndu+Tlg3UdpmSi/X/9zP3E4uHisGO4NdpqUpL+FnCEtLCT0AtJlO7Qk1e41oeFmePCKtsY+crEmKEC9mz7wn0/YnAeQsDfWu8ny0s4nqemyST9KyUMCUp/Sj9fTReG/+uR50nR/BYpT8hGWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787298182; c=relaxed/simple;
	bh=ImecG23HtQKZbIfwpUsXgt8iVHxQulVH4wIXU2pB2qE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IYFEViNihBF/ysae4z3/xD4V9oXt06co3fbWQ184mtBq0YvxnYQNKHcOWIvRg3nOX/lwT5ZC9JF+44f9qNEQwtkuutsdybu/ZrktIzKmOF68FfEFlPpI8rBaoj3LfWrE2O+PheipZKUgTALNgIA1k5yid4acrjcgWt8M6t9/PmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W7ujH3xE; arc=fail smtp.client-ip=52.101.62.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W7ujH3xE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVCra8j4TgmHGIA0V2V2KqV0J+zbh7XcS+d0QcA94g1f/e1VU+XR0v7O8HSy7xjyGhm+KBvya3j51RiRu8QWWLb+u3pWfEuJGmDYltZ6RWOQ53PGJlQ2d+KwCnE4PnnR+Qx1eHPF5l662x95jEsx9++7Ygj0sLre3SA2qFq7CbmTRJv/7QBRSAdr1DboKXjMjc4rLaXeSFk5yQKcOPLffR1yi4H7n15TT+kMF/EfQj1OsBtTn2dmBAPQapqRpBaKlrkGo6MxbMi7Zug8EukBlkF8PlvD735kQgtwt9qn55oNQ76jlQ5m69Y7jqg/byb26/yn5aKafoLDGmnfmjhdgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XONVukxxaFxi0SUgeaVEXLRmzppgorVsPS6lq3PpnWY=;
 b=WFTMZGDiqLO2b994AvYNSCDi392vB9dejdRnJfYqtHnvDm7XkET313b5Q2YpFsxzDDi4Z/8WyCxz4jbGpcisJf6Rla5wS8hjyRxILHom3OHvTu8/U5gMe0p+sSTOIcf8gxc+6gei+Eg9k64dpLkwqBP05GU97kYS4saOqnrGcry9SFbHERiVSbDSMLyJAYoEBTUCsrAbrx3dU9SyTZmeBRutrjfsSPp7fZj6TVi57p5L2cOoPtve8BruVsjaCTVkI3ZIncNj0DJAuvwG0TwUcWafDcCh268wwUXStRbL3D1ikUXnPliQHllh8dnrruuqWx/El4BzCzAlkdI4OQ6A8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XONVukxxaFxi0SUgeaVEXLRmzppgorVsPS6lq3PpnWY=;
 b=W7ujH3xE1+IjW2AtFm9c4wFmW7qniO+D8zgHXmeiVkPN3x30YG5hTG/aTbi7Ld7A23XQw1bSBYdJxKHb2ifC/F2NynNaUvrvugARRBzeqxv/mRZ2PmgAihQIUwr5h5zvjB++ZLx8ZNiijSHbLNUieNod7V7SYbjOzgSGWnt9UF1KMXRDW1Qoa7wTJCjYJQCuQ/IhAShP9NRSk5alWnDiw0QgmYfQuOBzCqbwFsCGl92nTh671IUWi8BunXCnnUATODILot+6rQkwnnWawap+WWeSngLz5WtYduK/O/ktXY5LgcFHL/SmwUoTCXH+KPcs0QLt2I64m+zW00qofYa4Zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18)
 by MN2PR12MB4391.namprd12.prod.outlook.com (2603:10b6:208:269::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Fri, 21 Aug
 2026 07:42:52 +0000
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9]) by SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9%6]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 07:42:52 +0000
Message-ID: <10b346df-ea44-4723-8a7b-95468f4e7be0@nvidia.com>
Date: Fri, 21 Aug 2026 08:42:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
To: Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260820145211.194104353@linuxfoundation.org>
 <aodHyZFV-AzZTbnF@duo.ucw.cz>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <aodHyZFV-AzZTbnF@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0130.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::17) To SJ1PR12MB6051.namprd12.prod.outlook.com
 (2603:10b6:a03:48a::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6051:EE_|MN2PR12MB4391:EE_
X-MS-Office365-Filtering-Correlation-Id: b4889974-4ac2-4254-cb5d-08deff57ce1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|23010399003|366016|376014|7416014|18002099003|10067099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	b2DoY6b22XctWKqac2SFKKdU4kZhIK/LuxVf2rkifxWyWFNMjFgzIX9aE51329RVcgPiHi94+JseDEiUyTAzQkh2PP5nh6UXwlggB0zVFiqVc9UdFfFsGtsA3iACqE3tYmop6D+Si4Sl2/TVdazidNLZ3znVNJwlRJW5BWqEyWyTnGr6SFbDOjPghGHpI8IATydCw9Vf9JhTFOzklypfPTK9qPYoZltot/atxD2sR9J39GZhQ+FxxuUHAJ0Sv3amhdhwFDGczdRI9HwiVD1Cp6/ICDMXfRFZyI3tQlGGEkAYNwBjhFxhBlyF8PV32V4TbH+v81Zo9vkKLwDxIH2Pw5w0a+zFqmqqmXS8iud386oc/E14KXRqBh24cIcCQnfN0n0un011C4lSL/DctliYD0O2AUvKkQUZIAiCZy+kWO9qI1XNadxNMht0XcppFCDv1YSZ4AinHIIlKSoibm0Xw+iwpZqXRsexcBrAvc/2xdT08iDcdV1A5RiR+w35mVsOfa+//uIKwbfh4IxTPI85Gb1ZCltJCtanNVzpNqtoCJseKaD7PSZVQb3Ji45HyhBB3yQJHGRkQ7ziI2xc/wggIuYummxeWvB5e6YWsFWeVFfILv+/Fg9fgG97jUIZLGgD8K3zwaqJ2lOtXHYqtSVGjYYVXvHp6fHsdXepUnzV+BM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6051.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(23010399003)(366016)(376014)(7416014)(18002099003)(10067099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2JqaFVGZjNGWE5qRUxYeEtqdWI2ZDZlb2dMMjhkQkZKdDd5c0dkM09SUW1K?=
 =?utf-8?B?SHBUc1JNZnduSVpHL2dpdkc3VHFscjhud1kxOEN6L1VnM2I4RzQ3c3p4U0N1?=
 =?utf-8?B?eVdNNENBQ3ZmcWZlbUJWOG1lV0hVWlVxQ0lWRlM2UVkySGFxVkc3ZHlxa3JB?=
 =?utf-8?B?cFRjU213eEdCZVJyZWZYMW5Nay9keUlEbnMvVTlQYUVHc21qT1pYdnJBa0xT?=
 =?utf-8?B?WmRFQU1rYS8zVFlsRGdiL1ZEdlZXRUpSL2RObFI1aGlheEVOZGtQTmhqTCtV?=
 =?utf-8?B?WlZ5cVBrTDk5NHUvOG5udjJHUFRMbVlmcVRTRCtLRnZUbzRyeEdmTCtXODhP?=
 =?utf-8?B?S1NmZUFvcjdOKzAyWE1EcDRyQ3Vpb3UwQy9tNTFjS0t4a201SE9ySi85QnNn?=
 =?utf-8?B?bDFLcnNNM0ZKUVRKY2Y3RXZaRFh3NlhrWklHRFc0QTY4a1diYXViT2k0OCsv?=
 =?utf-8?B?VUhaSkZ1YTVzUGlJVUJFb2tYY0g0NmNLWWJZK1RiVEpZNWtKajNQays5RU01?=
 =?utf-8?B?eHU1S21NbWhRbjVISXF5SGdGa0w5YnBuVVVlcERTSFY2cU5FcWhSNFR5b1kv?=
 =?utf-8?B?YjhDU296UU9DOXM1OWFZNlBiNVdoa0tjYWdhZEVDeHZ1dG5oWlgrVEtQRDJa?=
 =?utf-8?B?TXFONzlYWGdvbzgvM2tjQmlQQTluN1pOS25tWDZpRU1vRlhFdGdHQXk5dUZl?=
 =?utf-8?B?WWs5UjNSQjh2dUh5WVVxVnhlZnp4VExpektNVFFEdnMzQnphYW9TZVVCSzNB?=
 =?utf-8?B?YXRWN2htNnNQSHFNZjIvSmNINkhMU0M5SitvczhKUHgvNWRKWTZSM2VreW1u?=
 =?utf-8?B?ZVE5dXZyZmk4SmZWUDE5eVpGSXpFZk53M2ZjNXBBWlRrWnNuSzdWdU1qYTRh?=
 =?utf-8?B?Q09mcW9abkVEOGdDSXZMaGtubngvd3hBakRZdUV0Q2s5Y3VoaFhEY1FtQkd6?=
 =?utf-8?B?ZEg0eGtjQ1Ixd3dCMlJOaWpTNFdWcENlaU9QZW52dkZEMVkyOHU2RGlXK3hh?=
 =?utf-8?B?SDBPZllEVUhSSnp6akZrK0lLWnpuQUFNa2lkQ2RibFZtR3lBKzZreUZheC8y?=
 =?utf-8?B?S004Z3ZIYkNNSU80UkhUdCtQVm00bG5OWGRxTDd1aTBLMjRrMFNiandCV3Rt?=
 =?utf-8?B?SStINDY2MVptMXFpdTYvYkFjY1Z1cHVSSS9oU3F1M0pESnAvTS9IdXp0V2FD?=
 =?utf-8?B?T3J1cDJSWWZKZG1ORHFvNXN6VW82VXpMa2cvZWVNYlZwaE9ucXl6M0pjSUk3?=
 =?utf-8?B?OTBjbWNHMFZ6YzduUXJRWTdVclgvdDF1RUROc3ZJWW1EYTk4RUo2WUlXelY3?=
 =?utf-8?B?cVZnK3kxVjdpUHhUSU5PTlhEUTBZc0xndzQyci9ra1FueGlnVWx4bnBJckxM?=
 =?utf-8?B?aUs1SnNPWVBPSUJVUU1sWHRhWlptd0FGWlRNempCQ0xWOHg4NGlCb2pETW8v?=
 =?utf-8?B?UGI0TkZUbXlTNHdOVXoxSHplMXllMENJME50dC9ZU3NIV3hBcllLNTBFQ3Jl?=
 =?utf-8?B?SVc2UlU3Tk82aEZqbkhielNZdCtFaGdxUWJvbi9OcTBmZzBYQWxsUGFMNWVn?=
 =?utf-8?B?SUlxdXBuTzRabG5lbTUyWXdONmJ3YnFxdzIxWE04aHRTakVnTXI3YXhXSy84?=
 =?utf-8?B?SHRoSG8zWE9kaUVZVkovbDl2NXFTUmFXQlkvNTYwV3FsNDJacmlhYXhOb0Fj?=
 =?utf-8?B?WGNDNzlZT25pTllBZ2pxWUFNODIzai9xczMrVlJnYm9GQ2tJeDRRcjBhTktN?=
 =?utf-8?B?ajhYK0NNNXFRb05TcndQNXN3dTZIQ3pZSlMzN1pTZEZxaEIrRElrSmFwYmFM?=
 =?utf-8?B?QXZLOUNLdXl6T3lZbU42Qk93NXdUekYvaFZ5eGpPMHFLT2s3SVNHY0h5QXgr?=
 =?utf-8?B?WXBUWnF2amlOdytjakhPRlQ1Y0JlR2pDSHk4ODJ3TWZaeFNKdU9pYzNxZ1Rp?=
 =?utf-8?B?ZEo5eTM4QVA0c0ZxcXFxMCtMNXZRN3hCc3Yyd1NCUWlxYjk3dkdvZysweW5C?=
 =?utf-8?B?L1E0dThqLzQwb1VsYlR1ZnhaQm51UEx1b3hQdVkyNzVyR3NIRUNHdmFmcnRP?=
 =?utf-8?B?MjM5amlxWUxZT0xYT0hhMHdwSFQyU1o0SzU2amxySXhidFZHbk8rYW54WjJ2?=
 =?utf-8?B?QU9JeHBrT2M0Vy82TU9RZ3A4YkdMNndJZElhKzZyb1BDOUVyaGdSb1R1RkNr?=
 =?utf-8?B?dGdQblBpRFVPR2tGcnFEU0txT3oySURYS24xdnpqR0tWekRoQm9KMVpTa3hp?=
 =?utf-8?B?Y3VMM1VkU3loVXRybzBEaGlFNTNKS1gwOXBtZ0pvOXIxemZFUlV6NEpoVHg3?=
 =?utf-8?B?MWtKQzJxUUJrVHVxU1ZsZGNOWG1aRDdCZWxJbjIrTG9JWXhmVU04bFNXZm0w?=
 =?utf-8?Q?gJkMvKqPzXvcbn496FwYbNaNVXs+OiEXYflX3Bf/Yd98U?=
X-MS-Exchange-AntiSpam-MessageData-1: 3xPWZI2ngIT7aA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4889974-4ac2-4254-cb5d-08deff57ce1f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6051.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 07:42:52.1113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9KgzH8PWsVxBoo1ABHXax3Y2e17sJoFMP/O7ScYYKJV/BTpDzADE7okqqVDMkD/oo7A6oLE+aA2wtAJj7rREg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4391


On 20/08/2026 19:30, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 6.6.153 release.
>> There are 166 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2776656726
> 
> I assume this is same problem as 5.15.
I see the same issue for v6.6 too.

Jon

-- 
nvpublic

