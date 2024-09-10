Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2073.outbound.protection.outlook.com [40.107.96.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B445192B84
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 13:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725973702; cv=fail; b=hsolxkf2QTKO+AsKKL+w/9Ou6corZm8u0FK76xPurUKpvNOHMc+Ffx/HA70oaEJTW338VNHdCr3oFkEKvTDSKdcZJbglJ67FRPR6j/LtSv9on42gMW2D/40f4Q8C2To59wCkPF+gMYfhiyOmt22aRlg/9J1a5q5rPNrKvyl6H+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725973702; c=relaxed/simple;
	bh=iKUBl94EtnJ3yVe5/2NmYzmX4kZFeL9q71r7bQwlywk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kQl8F4bc+0YjbX6vM39lp8SV0cRJAnLquIYBykBIgHGKCYHbkf/xy+WyavwTNTpv8xiJUeyt4wjyOSPBUfuEZiMvekOrhR+nJ16VcY2/FyNI0PxqfxFKhD9BD97OVufchaAywDHVN6mJ3mWrIQIjNYcM0mKFz21lL1O0lFya8Kc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D9qxWeFp; arc=fail smtp.client-ip=40.107.96.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D9qxWeFp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W8Ux/xBUKN3NxBX2aelEaOkgIIF2nwcMSxYbf+ZnaM/CrmXWqsZuT8HTKg/ErtIAJ111p5c3WqTCay655Labn+GQQfMIwbS44136qgyiVmXayAwf+YvF9lFH8tno7L9i1JffxCVfOmfU3wXlQJGbbIpgU/uk6dzD3fupWIRFC/F07U57lw7Me/Ho8NufECueaI/A9o1aB9wRsshmFVGZjM4eColfD1k4A9UeSBoQJT8zeDTUxWGnq/3ltKfyKv+wku5C8/I/bcU4RasqdTOZTuB+jxyXSdb1w/sqCeJ0TmWsXiVjBbVJ8AwHAziGvjQ6DCOHQbJTWMh4R7obGdjApQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8eH23K9cPX3/gm/mCNYI0EFahPonVbRCNSZRCVxSUbI=;
 b=Tj/9Dcg6guIcW3e4+7Ij3XgeLszarqrrFmoHDT3dpzYMy1VtyrUWbptfKOkrCaec7IK6uLcVSygfkgWaNg9jKFqm6XgW3lEkIhYXk/Hq14TmAjKLS0k08ZwrorQso2dzBokuchUdWPrYHEBLK059zPd9Bd8Eri+ZAaDhswYsYgBmSB3QOjinuUyp8AWlHrJFCte8sTCxck3DWEnfvjzUzN6Wuk5m6yjOdpFLKUU5x2OGmOJ2GIv75msj6kffyuBwPmVQKR7+824bMcNsMRsEGXJrpEWNRTSD3IKkFujewOYTlCa+QQdEdoE3CX3cJqyH+4pJbquotN7xiXBTxeANMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eH23K9cPX3/gm/mCNYI0EFahPonVbRCNSZRCVxSUbI=;
 b=D9qxWeFp8+V/fscHy42UQZgqFp1Dr6c9k2AE2OKu2D85LkHxqBq33N02bPF9zXSMqQ6c5sTNH9fBOCGwVFDygiO1II7/0fJUk16feOXGL4CwQJNjSu17KfZs6+V2awZbtouDXilPSC9v5IhlWq+9EkQX+HiNNDn6SvsahcgDbOnfxXGReA/xXNDcOIL2fTs4VGGdctmgY2zcvQHlXM+7ySBudjT9o4HuzifA+WYi0d52BqvViPc9/Rv92IqqthW63JWpQVatRx1dbPVSgih2XH/KKPJ4YCKmgTS7Sjr+J3XyNgL/CQnq6lpeaKZOFmuyc6aeGlDZJBBKB3hAsUr/Vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5447.namprd12.prod.outlook.com (2603:10b6:8:36::7) by
 PH7PR12MB6761.namprd12.prod.outlook.com (2603:10b6:510:1ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Tue, 10 Sep
 2024 13:08:16 +0000
Received: from DM8PR12MB5447.namprd12.prod.outlook.com
 ([fe80::5f8:82ee:7da9:219b]) by DM8PR12MB5447.namprd12.prod.outlook.com
 ([fe80::5f8:82ee:7da9:219b%4]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 13:08:16 +0000
Message-ID: <016687c4-2cf0-4c12-a1ab-7b163aef6762@nvidia.com>
Date: Tue, 10 Sep 2024 14:08:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/214] 5.15.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240910092558.714365667@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0485.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::22) To DM8PR12MB5447.namprd12.prod.outlook.com
 (2603:10b6:8:36::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5447:EE_|PH7PR12MB6761:EE_
X-MS-Office365-Filtering-Correlation-Id: fdb2c1aa-176c-4e92-2665-08dcd199a202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUsxRTJTd09mdGZXbVFic2p1QlVkV1RQS1NYUS80RGNPYVFYSWtnVWlOVkc1?=
 =?utf-8?B?MUl4YXJGVEdURllhL2dXbEZtWEo0RHo1Zmk0MEdWelR4TENBQVkwYkdha2Js?=
 =?utf-8?B?dFlKalY2M2lLUDhOZTlqWjdiUDZ2ejVhT1pWOGdudC9YYUFFM2JZb3BmQVhR?=
 =?utf-8?B?NlkydFZBaWtPRy9mYUhDNFVnSHowN0d1QmM5TDV5bjc5ekw1Y1hKOFZWeG1t?=
 =?utf-8?B?MWd2TXFSQWVjWjBJVitlZ3NZakd0ZGdiK2ZwUzFqUVVBZGhacXJTWGVSY2ow?=
 =?utf-8?B?TmpEVkd3aGlORysvWXdmKzNTck9OOGJZWTZSKy9zMnZVZU9kRDBETk8rRzBk?=
 =?utf-8?B?a3ljREcraEJLZUliQVI3TGdRU1hMN3diZGdlYmNIK1EvMjBPTDA0bDZybkhH?=
 =?utf-8?B?OVcyTlZnSUU0cW1WT2FWYmg5WHg0Zjk5YTBqOEUwYjBUR1dKSkcyeEJtdFZU?=
 =?utf-8?B?MHR6b053V0ZxbTVWOHUzU1NwSjJKMWZuK2Y4TngxMS9BNGlRVUxtZDcrV3oy?=
 =?utf-8?B?RHBMQnFhWFpJUEJpK1BWRVlkZk1TTVk5YnZFb3p1NkxGQmh0bm9EOXNnZ3pp?=
 =?utf-8?B?cmdrSEF3emVKOVlBejF6cVVCcmpGV3U2dkVrTnI0OGkzRWpjL0I1aW1YTkFQ?=
 =?utf-8?B?SGN0blh2L2w3WkI5cFdHWTZaSEFOaHo5aGtFUHJtVTYrZXZ6blBjNFFhendy?=
 =?utf-8?B?T2tkYXREZll6bW9ZZlUrTXlNYWplbGVaYWFVdDY3RGxYanNyNk0xVFN2UGpZ?=
 =?utf-8?B?bis5NlFpa3YvZlJ4SGREd2dLbjJ5cDhnc3VxZlovYnl3Ynk0bmF5SEVTVnFl?=
 =?utf-8?B?eEsvMUloeHNndHppQVVmazV3TUIrK2VsTWw3c2FTcUFiV21hR0RyeGRwZFla?=
 =?utf-8?B?NHgrSDg2dy9zUzZ0TUZPU0o1czI0aGJNM3BxcGY0aUg5N0g0Q2tzZG1kTmsw?=
 =?utf-8?B?aURjNWRMUHYwZCtwUjBEbUVTa3E4UWE1WUJxY3E5ZDJZS0tFOEIydlVxZG9z?=
 =?utf-8?B?NWJ5end0NUZNM0duSVZRcnhyR0YyOWNLTGY1ekg0YXoyc3p3bHlEWHUxOGI2?=
 =?utf-8?B?enBjNWFlSkdGOGVtY0dpL3dqZEhsU0dkSWRKajZIa1R4eFp4aFVacGhGZito?=
 =?utf-8?B?eEJPbHhUM0crRm5qMlIwemNPOW0rSDdnSEhvKzNQOWZ2Q29vTFVidWpKSGhS?=
 =?utf-8?B?UjVlYkpncnArUk9IYk1Oak90ekZZMXM4cmRGUE9EZVIzTjJISkJaMGhVQXNG?=
 =?utf-8?B?ZjhKejdsSVJOVGRKd2JVOXlZQ29oTXp1U0JURHNKZTJlNktXN2I4UlRoenJN?=
 =?utf-8?B?ZXZLUTVCOXhaTGo3eEhuMFFxTk1IbklIWEVQdmZrdDBLWHJXZWJ4SHpKRzlq?=
 =?utf-8?B?MXpvaTJGT2NjRFQ1cStVOUxVb0V1NHNZbklDcStoMGdNYzlUcEduZDJmcWM5?=
 =?utf-8?B?K3FNc1ZWYmp0S3hRRjN4b0l2TDEvbXg4OVFQQ3RyS29WcEFJdTRWei9Zby9U?=
 =?utf-8?B?NmxrTlArSFZoYnl0bXdDWm1BbjFuSk9xYUNoVjcwdHUza2JFam9kQUVSY0ZO?=
 =?utf-8?B?RlJzNUFtT3p5SkVBcy8rbzVJdHJTUEhwOG5MWG5ieGFMaTBZaHJYSTRkOWIv?=
 =?utf-8?B?dDNIZWMvMEhBNHRtSkJhRkV2STh6SnpCSVV6MzhPTU41NkIraE12RHJZbXhz?=
 =?utf-8?B?LzM2Q2Exc1prVmpmN29lMzRuOVQxaGNvei9hSnY1MmRzbWlrbkJUS0dmK2FV?=
 =?utf-8?B?V1FUK1pmNmlqT1RqNGV0TnVpNnR2aTJ4MjFlaFo2Q2NIcmMrNWkvdWVlWEs0?=
 =?utf-8?Q?KgIi3ggH4GiN7FCQYiNsHZ6U/B5DQIaW9zGwA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlFBQ29mcllpUm1rWFlySiszWEZYbktwRXUyN2tHVDhYK1kveXRMWjFlUVV2?=
 =?utf-8?B?QkFUMVBvU1lOUURXaEFDbFozL3dIZmhKVitlc2ZzMW1kVEhDVWdDS2xTRmVt?=
 =?utf-8?B?V1lXZ3JPdEIzNEJjbFNrSGx1RERRK2JkWWRtUDIzREdTNGViVjNOeE9qTERv?=
 =?utf-8?B?OXlQeVVoTXZZbjFZV1JZNU5BOE5wdWNDL0R4UWtzYmUzUklCT1VKQ2F6aHpH?=
 =?utf-8?B?OUl4MERYM1U0VTdkSjZSM0JhZHlLNmVBb0V5NXU3YllPZ0U4L211cy9PQmRU?=
 =?utf-8?B?VlhZakFKWkJHSWFzMlFIT0UxbW9lcEJKVUZaSE9BVHE4dXRtdmp4Yko0b3Bm?=
 =?utf-8?B?c0NocWlGeVlDM0UvTXAwcE95d1h4cGEvckFXamFkeFc2SUdNYzFMK0xMd1VC?=
 =?utf-8?B?YWplRmdTUElrQnlmcFdaZm5tVXpZRGxPekQ2d3EyVG5nREwyTnN0c29IWTZM?=
 =?utf-8?B?WDAyRHJaaUk1SHVsQVA5engza3A3b3QxMng1a0VBb1NMNm83NXFzK1ZpL2ph?=
 =?utf-8?B?NDJiQ1dRNHlRalJKQ21zTUhSc0E0c1pJbkxsRmNRd3J0UndhV050SVJxbXRP?=
 =?utf-8?B?dVVnWUFoS21nWC9yTE5KUytyQkZIMG9ROExVbUNNVVpoQ1V5TFN3SHBNTVRZ?=
 =?utf-8?B?bmdZNDJma2JlaXN6NEI3REFWRE5OaHpHcHQraFpBenI4eHhCZ09BQWZxeFpj?=
 =?utf-8?B?cTMvMFV5M2lDZnZVbVYvM093ZTN1anR1S3lmTEZKb3hPeHF4Ly9OU25pZWRC?=
 =?utf-8?B?Z1lWYlQ0emZMb1NBZWFBa1VNK3QydFkxU3lJalRpL0trU21Ic21YdHdWaXpG?=
 =?utf-8?B?eWVtVVQ0VHNyM2txRE1UZkZlVHVaRWVSQnJWN1MxTVFUNTgwZTZONytOeVN2?=
 =?utf-8?B?dHR2TVEvR0VXVXh3M3V0UUZMRmRJSDQvTHRZT2NndU9yWnRGQzFSWnlIM1E4?=
 =?utf-8?B?eG5Wci9uUGZsWnB1YnpQVnZxbStBelJ1YjQ4ZW8yK2Jnc1JFcjNpSHRDVUVx?=
 =?utf-8?B?SG5mWnE4UlhxQlV4dUs2VmRTdmE5Lyttb0F4NGxadSt6QWR1OHZzdnhlaFNO?=
 =?utf-8?B?anRFR29kZDhQRDdkWTd3c09UWEw3Y2VDZUQzTjlhUDcwS2lkbFhKNk1YMlpu?=
 =?utf-8?B?c0dhWTlCRmxNRWg5UDVlRW9TUWVlZFlaZENmMEk2Mkd6OEhseE5Fd0xIQVMx?=
 =?utf-8?B?T2c3VTM0SXhyZVlBcHdsL05UMUR5MGo1b0lQVHEvNWtjcjZ4bm1tcGIrTzBq?=
 =?utf-8?B?SDk4c1haUmY4NFJBRjNUT1NFMW1WYUVhZzZKRWtZNGl5Z3Q1UWkvSDVYSmk0?=
 =?utf-8?B?b014anVXN2JkS1JTcWg4RFRrS2h1ZEtpcTNmMFdkcDFkYUsxYnF1SlNIMHpD?=
 =?utf-8?B?U3Q4K2ZCR21uUHA3OTMrWVNKeDAzQnhqekhUV1kwUnFLYUYrdHdIYmdrV1JS?=
 =?utf-8?B?MDRIbm5GdlJmWDg4bllpQ1Q5VEVOK3dYaTNTZU5JSFlyYnJobURRMmRiQWZK?=
 =?utf-8?B?dDc2elRBZU84TlFLWEREbEgrek8vYUlqL0lvTnpVbUNiL0xmSW9KMmpYblF3?=
 =?utf-8?B?K095QS9ScUM4alU2Wm9odXFUMGc3TTRPbUdSR1hyYnI1MThHZkU4R1JFODRL?=
 =?utf-8?B?TlZxOFZzWFYvWEMrd0lqSTZaNU1lVnA5eWVqdzU2OGsrUmFGclcwMTFvbitI?=
 =?utf-8?B?Z0RpQkxGUzFGOGtmbVZnWWpMdTJWSXBaaGdxZ21vUExHWHYxamwrdWlpZVI4?=
 =?utf-8?B?Y2xHby9qZVkrMjlSbVlYc3hrV2NBNUxJaGgra1VXeTl3eFdYcy9rZXVNSVh5?=
 =?utf-8?B?RGlUNFFBVXdvbUpmMFcwN3dXbjJOSEZLTnB6aU5xdTVNZkRxc1RBZ0M2QSsw?=
 =?utf-8?B?bDZ6aDRpS2VKSTZsTE5tTFR1R0dodzdvNmRUR2V2bmVzaXNXTExRUmxUTHoy?=
 =?utf-8?B?TExJZHVhc2dsSjBjM2tLM2p1cE9CakZZYWJEbU9IRXJQRnV5M1hOWmNTNkVy?=
 =?utf-8?B?dzJpbHFZNjdCYWpmYUlzUWN4UGNyMTJ0ZFBlWk4xMjJLeS9DK0RpekFDcTJG?=
 =?utf-8?B?WkxoV0dpb2NsaStwMUw0QXA2RWo0T0NGUWZkSFdMNlA5TVlsN3dqdThLTkhS?=
 =?utf-8?B?Rlg4VmdZQVFvOUxMaEpMa3EyYkNMY1JUcFdlVFNHMjJLaTlhU0sxMFJIZEx4?=
 =?utf-8?Q?ny8uFA/7+gPwnWHrGilcbt1pZC6qSQCpcR7KUB8IJi1o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb2c1aa-176c-4e92-2665-08dcd199a202
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 13:08:16.0568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dL1hBTRXOLEmfZS+flVFVgkAEG5O/OyyiWi7yws97/W0SjncjSU8p1KQFoP43BWxhk5SY9u3R/lp8JVkF68yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6761

Hi Greg,

On 10/09/2024 10:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.167 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.167-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...
  
> Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
>      clk: qcom: clk-alpha-pll: Update set_rate for Zonda PLL


The above change is causing build issues on both mainline and now with
stable. There is a fix in the works [0] but has not been merged yet. For
kernels such as 5.15.y where this driver is enabled, the build fails for
us with ...

  drivers/clk/qcom/clk-alpha-pll.o: In function `clk_zonda_pll_set_rate':
  clk-alpha-pll.c:(.text+0x2f90): undefined reference to `__aeabi_uldivmod'

Jon

[0] https://lore.kernel.org/linux-clk/20240906113905.641336-1-quic_skakitap@quicinc.com/
-- 
nvpublic
