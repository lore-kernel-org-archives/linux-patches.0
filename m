Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C744020A5C1
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 12:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741263266; cv=fail; b=S3o0NpDSaoVAn57iqu8G0VyJmpmAcrxPaERcNbXXc8xUDrysRcu52P5B75pxNqNGW+VxPLPWH3yq9al5RylNOh9tTeeH6dkUAFXgRv0ZbF+8ofTwPTo3vTM0jRFLj7HQCiCD0nNHrXdcfJIf86MX1ancTQ8r5G0XeIjxF9Dtn1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741263266; c=relaxed/simple;
	bh=aJ0M2Ck7cecnBtKQbVI8eoHcuPYy06brb5yAY2uTptU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pu500Tly5r1xGYq0Ljrf/7kbrwyQoqjrF8u4RUNpeNKSOwoBEAFzO28Dtix3EhHsEWTEacEh82a7y/BXdee1i3n9SmI3RXUOaGCg2bHwKgE9E3fK7Q2XssqMzfl07PnC1OVw9vtw1mTPvSGOTT2v/r8Dr7mZE/sWJqt2+12eCH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jVuN7Qah; arc=fail smtp.client-ip=40.107.95.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jVuN7Qah"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twp6iOm2IvwmfHBLb7MMB9OiztOu01jxGMt9QnjdMr+bog4dkRB3IrOLbA7u50fZ+x+hf2V8WDL2+qf4uQNKuWi5OmI7Pi80G1v78cbLetLx7pbLARe5g3lIwYAsEo/r0TVlShb54ZYtgRsh1s2DiEyoAxTV6nC6KvPOSjRIP+RAylj4lN8Ald45vycyGMxlA/+GqRC/ghif4vVEtN5hTnCBCT/NIl04LVUQ4BKicrHEyJjUSF0i1wmfhkEG//+1jo4gh3TDWvyLqmmXIv4NkEgFAKPeIi2hJx2hnPWBesmhwmwFCNYSeI2D1Pm0N7ijrmuIU10wpC6PKtTP3NFflA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5lpfwThqP7R2HdBNvG3Uv/Fc4xd4nV7Nsm6RZZ8ea8=;
 b=LIRIlV678rWg8G5ju33oy7G/e8Odw9TMFzPxXa5YQR5lGPdv+qMicJ+oXKv9xqvRU0MdNV7kHiR0QtjmIbJlYDuRycoItnxRuEGJHTS6SeghtEGPh7gwpiPwvlMFpWimHMCwQ5aafi6dWWvznsPLFOa/mDsoGebPsTAD8sgL11GKqo5cCKnBh2f75Oyj//3k67kOf4XekQ0Q2ng+4Yp6WNT76LM4Y1u7rT3NOy6g5PR69IG1Trp6QMagF9xFCvfexC19t1Kmj4WOh65RXqVKNKMxlqe/3imE1VaxliDS0Fm32iE6YhQaMnloHj9f6rZve/d4lfqzT2eyTH8qAGYwww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5lpfwThqP7R2HdBNvG3Uv/Fc4xd4nV7Nsm6RZZ8ea8=;
 b=jVuN7Qah8DNgjTiLc9DG3HgHMXCorEB1xImSpYN4i+SZ6S9h8fN7yR9L+giT7lSY28ub+lxJCHg3O1nEi/uQcIUJmnfUTMwHKjNfjqrwUNDfkGNdiyTScm0lQaa5AjnekTIKdwfhFulmI3hxjkzSWsPS5yL32SG69BCnU1sbGvb2Y+bObJe25tD5MRYFfICP+5CyE5DHh39Xr9jnWsR0NeYRiGXWWctPNMYKnIo2lNhAYZ6V2LoWgLc8PO5miyf9OP86tSDXT9P05CAiaMgd54hv349bpOahjfGSSmOghxL1Z+cCJwB9+ukgQVAMcm4lVRxomXV5fuyc3UgzxXwq3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by IA0PR12MB7722.namprd12.prod.outlook.com (2603:10b6:208:432::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Thu, 6 Mar
 2025 12:14:18 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8511.017; Thu, 6 Mar 2025
 12:14:18 +0000
Message-ID: <c4e06dc3-86f6-4a3a-89a6-d8671a47680d@nvidia.com>
Date: Thu, 6 Mar 2025 12:14:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/150] 6.12.18-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250305174503.801402104@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0099.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::14) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|IA0PR12MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: baa517c3-62e5-4172-3dc6-08dd5ca86b55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?akxyWUFBbHhsUURYemhRaVB2MnU2eC9nWHNySDVZckFDQWpmUnRwM2RxR2pj?=
 =?utf-8?B?TXpXeUxtYnhBYWthcjNEbDg0S2ZOVUZGYnk5T29Hb3VSaVJMZ1lSRG1EczJa?=
 =?utf-8?B?MmY0MUl2ZWdtTkcrcGJKeDdnRXY4MStJWGluVFExNXZzN1poNDllcDFIbXA4?=
 =?utf-8?B?WGxPaURYNHZDZVNPelRsU1hmcnEvUXM4ZmVPRnZPTjVQK2wwdzZpZm5KRmVL?=
 =?utf-8?B?Z09vdnErOG4xa2VTVmVHb2ZVTmVKMjdDZ0Rvd0JoSW5CaUtiampuZHNWWS9i?=
 =?utf-8?B?NUxGTHhYRTJiTmZ5Z1plblAwTEhLeU85Q1lIVEUyTzgrMTY4YWFkUXpkU1hU?=
 =?utf-8?B?QUhHTngzbEMvcUg1a3Bsa0VBRVNvL0tkRlk2RkdVZEdkcWpvTEZNS0lrTTBy?=
 =?utf-8?B?M3ZoYjhpQnVSdS9icW5mSkFnbG40U1VGYTNmODM4NndpWE12V3EyeFdiK0h4?=
 =?utf-8?B?TE9ScCt1eUoxRW1OanNETFJPM2JGTEJpWnVZNUNhbnZqcVFBaTd5aWo1blNX?=
 =?utf-8?B?R3psZmo0d2xMamZtcTJqUlFZcDlpM3BzZS9nNWdvVjRnbkRCN3VGdmxOWWh3?=
 =?utf-8?B?UXhEWUNEVXZ4VWJMTXNFbEtMK1A0SzVyRGxlZGdFYlR0OU1zMDBKSllxWmhE?=
 =?utf-8?B?eGJxN1h6NGxwKzlqVFhvRUVTVFp2YWd6MlM0cmhxclJMRkZDOHJEZmc2b3Fy?=
 =?utf-8?B?a24vb2VQVTFQRm5CRjNtUG9VZm11YWJDY3MwV3ErV3Q5bnpzMlJHTWkwUGJw?=
 =?utf-8?B?TGp2ZHZBNmRJOFNjcHlyUUhSWnZKOCs4cUU4UlBYRkVzMnRGVEVuMkpQTVJK?=
 =?utf-8?B?YlRSSVkwMDN3TlJqMExmeWpZeVNPenFGUFQ2M3dNTkZaMkVXd3ZONTJMc1Vu?=
 =?utf-8?B?NlAxS0xEeFZMU0RiRWRRYzJKNzhudGJzQzdJSGZHajlWSDVQeE1za0V1QUZE?=
 =?utf-8?B?RWJOaUIwemVuZDFaeVYrT1FVMHlac0tsUm1FY2UrTFFZUWNrY3BhUTVyYjhp?=
 =?utf-8?B?YXFWM1hZcERQUWV0TklTeG9LMlFhbXNISG9MbXNheTlWY200d28yVEZlTzhF?=
 =?utf-8?B?bjA4b0plcHBQOG1kYWxrRVpaSVdVRWsvcytSMzloL1JRSmFzS1BnRThUcUNJ?=
 =?utf-8?B?TjdUeEJ2QWI1dlg2R1EzcksxU0h4MUk5NzgyMlo2a2lPcFhuVUs3U2ZINkRx?=
 =?utf-8?B?eG5XdkZjNFh0T2p6OFJJVVVYNElaN1IzZmljallPKzVwNm9wWXdIWkg5YWRr?=
 =?utf-8?B?QzY5OThyYTBBTXlUS1hDVWdJOXlTWVNLckEzNHY5RS9TbktrQlZQZEFVTW9X?=
 =?utf-8?B?M013ZmxlSVJEQVlacURJeHNZSS9waUw0cTl6K1NqY3hnaXI0eUVaMlFxeU1J?=
 =?utf-8?B?ZUlqcWdVdkVmK0pSc0trdjZ6U0xPSFBWK0ZLOWxCT3hFVHBGUEJDczAxWDR1?=
 =?utf-8?B?VmNkZE4zOFVxd0ZFU2piZjZaZlgzUFJQS2ZMMWc4QTkySnB1MWlYbkhySjhX?=
 =?utf-8?B?WXkyb2tHTDduZVFyTGV5UHB2UGZFMHZ3aW93R24ydkdsckk1aUNaVVlXdlhH?=
 =?utf-8?B?RFNLWVpTZDVjL0M2UFZYN3BzVGdGV0hyc2JnVU1lYk92NkdnSXViYlZPTFNV?=
 =?utf-8?B?OXlRRCtTaU1kb20vcXdXK1ltdzhnNlJkbHpzaSttN1pVYWE2eTV1clZyT3FK?=
 =?utf-8?B?dkx4TjNzYzQ1ZkdDMlYzU1hJaUxONWFrRmxWajZLTzNhV3h1ME1kS3FoMjVt?=
 =?utf-8?B?Q0hNYXBzKzBDT2tSdUE0UWJDTEZ2NEZST2tiVjV6c2c1c0FEUkpUSFVCOS9C?=
 =?utf-8?B?bkh4N1lwNzJNNHp2dXVjUmI4Nm9FME5ramhhZk01bFdtMkUrcnlWbTYwdk1a?=
 =?utf-8?Q?FYlI0uUXCBLh2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VkhjTFJsMzhEcG9ReDVIS2dsWEN0a3MwSmRMUHBodXpyeTFtL0lHYzRGZGxL?=
 =?utf-8?B?L1BaNXJ1MFo3UEpBS05WT2xnWWFVclB1YkFjc2pWczBUTkwycmtJYzB2OXhQ?=
 =?utf-8?B?NVh3Vk9mc1gyVTVEbWVYQWk0M21aK1ZGQW5PVHUrREF4UWN6NmN2dXY0S3Qv?=
 =?utf-8?B?emROZVRYd1RWMnU1VTJDVnBIV0xNbkRNSXUrdmtpQkJqQ3c5Wis2NG8rRTdo?=
 =?utf-8?B?Vnh2MXZZMkFuOFgvYU43NmxmSXhQSGczdnQrTi9neE5LMFVRNE51MmhDdmw3?=
 =?utf-8?B?OXJqdlNGcnZQU1lzRHFZVjVXd2diRzJLdlBQcmZ5SjlZcG1HcklDWFhZMEF6?=
 =?utf-8?B?aTIyeHBGYTVPUzBSRVVDN1lqV1Z5dzc2RDRtZk5PT0ROVHJab2NWeFIyYktJ?=
 =?utf-8?B?VGVJLzFyMDFTN1gwU1B0eVNlQUI3ei9RanFWTThMRGdpSEt4STRpVW5TSzJl?=
 =?utf-8?B?SVZ5dTlVN0tITTZJSnMxSEtUWlRaZ0pQSW9Felg3TURDTm45S2k5UWt4Y1l3?=
 =?utf-8?B?UGcvK0pZMHg5VTdPN21weVBOeGZVKzdhVU1XeHZzcjFzSkc2NWEvVDlLNnV4?=
 =?utf-8?B?b3RlYUpkV01TNDFWVlFjZGJ0R3loQzZ2d2tKbnNKS2hKd0piL2FPSk9iNy9v?=
 =?utf-8?B?NExWTEpzQWpESmxKZ2NlOGZ6U2FmbXFORVNmV2FQYndlZHIrY2k2WDNBQ0xL?=
 =?utf-8?B?dFBZWndpOWMxUFFkem83dFJMeU1OSFBUU2tGM2lPOGE4NVUrS1JtU1ordFVJ?=
 =?utf-8?B?cExUeC9qbnhtU3NiRlpPWTVrRXdUT0kwQXl1NlY1c1VqK0ZXQnpoblZvM3dV?=
 =?utf-8?B?Tjkwa2N6bXM1enJpUVR0aWNic2gxZHdHQ3h4WW1CUHFtNUNPdEJFWmRXM0hZ?=
 =?utf-8?B?ajFaTE9KUFJXUVEvckVtM3dCajJydzZ4V1lISlkzVHpObWdQVVFqdVhZMDl2?=
 =?utf-8?B?bEdZMGVIVVVJMlU5c0t1ZjVkQzdEczdLRkJlYVkvVFhIMmNLSktCY1YwWmYr?=
 =?utf-8?B?cG8vRHhJMTJFUy9TZjQrZkUrcnZnQ1BsZ3Z6bTh0NGc2amdBYUhsc0lKOVlt?=
 =?utf-8?B?SEZla24veisyaFNZUWtIU2VqWmhLajJJSmZwMlU0YkVzOG9Rc2laMHA4YnJs?=
 =?utf-8?B?TERjRXcwZEhJNG5jUkhZZGgrT3FLbHJwRzdxQUEva1NnSjdYWDZwV2xqcEIr?=
 =?utf-8?B?b0wweXNiWHp2UExoMEYwcXJ6M1lVd3dHQzlmYUhRNDU3UlJTaXYvNkFjeU9I?=
 =?utf-8?B?MWJ3MnNiSTR5NmVOT010aEp0UDcyRVhnVUdJRHpIWnlrcTAwSHJ3VytYK2RM?=
 =?utf-8?B?Q2ZBSGZyc25zYzF4MEl5Y2NQQWtCOWNLV0doTDJSampzWjkraEJqNndtVG9Y?=
 =?utf-8?B?SnJHV095bkxtM3F3VEUrdUtWTXJvc2F4ekZrdzR5VzVVVGJjZzltRVgwcERw?=
 =?utf-8?B?aGRmZGdLamFXa0FkSm9mRFRKNkl0YW5vMURLY0NLbjg0QzN6Ky9jRmR6MUVZ?=
 =?utf-8?B?dU5Wd2l3RmNralcvRTlnN1htYzhvbFY0OHVWQnJQVDJQeXo0WkMxV3dpemQr?=
 =?utf-8?B?NlE2cHhoRURsUDd4NzJYdFhyVU55UndmUlRCZFFzV2NXOU45dWZNSmpTeFBL?=
 =?utf-8?B?NjQrQkVFRjFONTlBeVF4ZEZ1bjRFL28vT1hiZ1lpUU1oWVFXeDhCSlNSb0Fm?=
 =?utf-8?B?d3ZKUXh1NGt3WDdvOHVPYWtDb1BER2srbkw0QTMxUExUMnFVeURHQzZOOGo5?=
 =?utf-8?B?Q1MxTXJoSXlkOHR4V214cjc1MVdEMXk5K0xjUmoyc3JhSjdqYWtzaEtWSFUv?=
 =?utf-8?B?d2k1b0g0Z0UrcTA0VlF4TFVaYWNrUHUvWmxBR1hCV2JXZlROdWxVYnRFNVAw?=
 =?utf-8?B?RVdYaG53Y2xEbDhUV2lQdUlIZ2Nmb1UrK041dWwrdkNlL1VIdGQyV2p3anJD?=
 =?utf-8?B?RDZ3bUpLeFpIOVpBMS9CbjMwM2xrajJydXgyWWt1cnZHbUNUU3BYVll3RXNu?=
 =?utf-8?B?Z0x6c1BhbnRqQUZrZmtPbWwrQVlhWCsyNkhiOXRmdGlkbFlIdTc3cDIyS3U2?=
 =?utf-8?B?bjNBTVF5SmFHalNTc3VlOWx2UVBjOGowQzRwWXBaVW9uZ05wMTA3QUJ5US9U?=
 =?utf-8?Q?s5nA7K1arZDOyOa+ygHA14Y55?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baa517c3-62e5-4172-3dc6-08dd5ca86b55
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 12:14:18.4329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/WZ1XfHjU5A5AlpRyUQT8tK610Dt3+Z/zDtB0JifUho7bcmN0h0w+6oARVn3FRk37c/Xir2AT2brg2BbkyjZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7722

Hi Greg,

On 05/03/2025 17:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

The ARM64 build is failing with ...

kernel/arch/arm64/mm/hugetlbpage.c: In function ‘huge_ptep_get_and_clear’:
kernel/arch/arm64/mm/hugetlbpage.c:386:35: error: ‘sz’ undeclared (first use in this function); did you mean ‘s8’?
   386 |         ncontig = num_contig_ptes(sz, &pgsize);
       |                                   ^~
       |                                   s8


  
> Ryan Roberts <ryan.roberts@arm.com>
>      arm64: hugetlb: Fix huge_ptep_get_and_clear() for non-present ptes

Bisect is point to the above commit. I am seeing the same build failure
on both linux-6.12.y and linux-6.13.y.

Cheers
Jon

-- 
nvpublic

