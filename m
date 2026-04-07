Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013087.outbound.protection.outlook.com [52.103.74.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62D31A9FAF;
	Tue,  7 Apr 2026 01:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775524551; cv=fail; b=fVzKrJp24Ww5rVDN/beM3JqFQH5972shZwhvZp15Umz2wZ4uUEyHllN+ZTqcFUPpHq1LJTNbOd+MYtbPmM3VOBG5MfbUH4BN5Y54q310+sWNiCYO/mmYyPIVmYYk1TOIkExcr2e2ttOsCL/xinBn7LDrViQpOCfpZFfYmTrEtic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775524551; c=relaxed/simple;
	bh=+zxdzIlcZi2XtNEjFifeaIY4yGEzKF8CxZmqDm94v9A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Var2zSnXxVorgUo8meSE53tWZj5CH5BFVz8j5MHKJZZbmDbu0kwI+ATJ37gp4vFuS8dvyZdTc4DRoLjgnmOFVKEO3fQCP8eYwRraB5tWYcQyDE1lz06m60hWZWRsGlHio6UOn4mLB6BZsjhQM/HylIJOo7fQsKaOOEmwrDa9qE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=ltWCGopF; arc=fail smtp.client-ip=52.103.74.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="ltWCGopF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jc4Zzd/w1okC9Yt4ngEZAQULG7zlwW/2H/HsyvuY9CmWmUTGG6G1lq+vN/t+riNLazKQjsCYtQIXs3/Q4e+T0gPY3eb6mkmgJILjJl/GksbdwTXP6+185oin6Kkra21dTt+JZj6f3PKltzb3Kb7+akfeB0eRsG8XHurZI20Fdkh76o9magb+WfgYdajbe+exvGlNzsSAVVVn52qdqSUQaG9ctqRgTIBzdAMO1KUpwwsM3mZ0sXyj0o0hmyPZs9rjhVmqwGdyQZEZ1b+30jv9VBsTg+TgtZblteL9qgWhcMG7tQv7lRYZAR3+Bii8S4znUHIJDf0U+0Ag9Hz+pdKKPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/qnUGmlzBaoSJeDZP05QjddulWBgogzn5S8RyltRaI=;
 b=c1VxOq7qhFoyRG5k/umB9LW2SQnYBpu5V9gjjwvUugOIKEhwJc2tZzRM9DIeNXEYooWTALurzyWpi6BX6xFd2tnde2iif1uVGxLPw4PSuJN6pAi5DupnQtswn1b/b0SG9/NklGjSPBizmC/Ii5oDpC14H6Ssfjc+rR6+Qty0y0rvmM6b6K6sjD/XQHBzjb1VshUTFvd11OQY0oQmh4/sYDD53qyR0O0fkhwdJrYqdzK3Ztgv8b6rUkqkhVbOUe+nwW1SZprWZCAPScas1yt2VnR4LrJnFtA8XJSEDowoyuabSYlKCPmFilFKd99fdRjq6/q1TYEsAmdSui83xHLoYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/qnUGmlzBaoSJeDZP05QjddulWBgogzn5S8RyltRaI=;
 b=ltWCGopFDXa17O5vMrS+ETKdIyhmQPyHO5S4B68DqzcyEVZ+xvxLElVB2n4LosOKaWC8BNRf3qZ/JweO6N96bqzq1Wyzm3PRUyx2AirnqGKjuYcJK5H+4dUg+ZnlofqLnHuZRchsD2hlGrmGJzU/jINCfw5OqBmWYN5LkXy16RfWsLw82alsPLvMnxQU/pITSedbWB6su3P3xYSMpyNyWoWbcM1qKj580z8p7dLHluDO9gK0/5nHbuR0f09RxThGaY5Xsyz6kFrjsjc8s1IPmWtyd/KwhNGzb39MYANCRwCHs12UCndnuGdr0yeGkbvtb/uU6PYD+CsEYJxptiqQFQ==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by SEZPR01MB5047.apcprd01.prod.exchangelabs.com
 (2603:1096:101:97::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Tue, 7 Apr
 2026 01:15:45 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9769.015; Tue, 7 Apr 2026
 01:15:45 +0000
Message-ID:
 <SI2PR01MB439366DBDB7EB03CC3729C03DC5AA@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Tue, 7 Apr 2026 09:15:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] iommu/amd: Simplify build_inv_address()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, patches@lists.linux.dev
References: <1-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
 <SI2PR01MB4393C1FF5BDB413E68BD018EDC5DA@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
 <20260406133047.GM310919@nvidia.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <20260406133047.GM310919@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TPYP295CA0020.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::10) To SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <8977d581-a5da-4cff-8c22-6f138169ec97@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|SEZPR01MB5047:EE_
X-MS-Office365-Filtering-Correlation-Id: 47b572e0-47c5-4cd0-5f56-08de94433159
X-MS-Exchange-SLBlob-MailProps:
	ScCmN3RHayGKAlIIivN7fIKgPET+ZtPoeWXLU2g9EXcgBYpkhFc+RkJ5pBDQ3pmSCyesLoJ8WLeHQqD650/SdvrecEDHbYwakP5kfckSRU+dXJEUnNDZfnnzwCeAD8cH3VLZ5CFiGV1WAb2DPTB42ap79gMAMWh3/VneYcC0SkPjKauoozTflGOYjJ1H2GEnHd5lC+1D0tWWIwQvTsddisRGhJ8xr8KRaYCOEH7w1ACwAFIYu2UfH53nMnToE+f8V7uQny4BR8hpvaPULhzncsNl3HntUruqHRpezOzzBa+IyoQrFkwn+vD02W5Ho23i10lgoGR1+Ogp3g2vLFwXKFxemefXkECN+aGvXVQpoRQ5tFvt0h0f+KfnQEwsdT0ZGRmujmBdJ7F54mRVoV5KB3BnXa8DvC2BjXGG6sqVYVvVfpteW0SYJB/C5oOd7L8UJZ7ONH/MMQawe2tBzwOk+vCqSrHCQBt6VF7yNTZYtI0hTQUUzj0XSn/ijU5g/1XVrjNz9ZADbfFJv5wvtNkrnZbUsH67V7G7HdgOLg7tZ6JDXKHdF+yfWHUlZagRfALPXVW67INOjQQQr8lTtbruOmuR+biUeQXgCK4vUAai36M8/oa5PgBKgJHL39QZfnKQUJ4Nx7tkjoF7hjk8SrjbfNyaZoolVo3mk7xF1drY4wxhcPoJuzgVXyHS3/F/drLKzCIYcLb+SuaCNHN2sQLvJ88jMbH6Cj2KF+ghP8hIhgA=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|461199028|5072599009|37011999003|51005399006|19110799012|12121999013|23021999003|8060799015|15080799012|7042599007|41001999006|13041999003|40105399003|3412199025|440099028|26121999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVd3eHlTWU1HelFTMUFHdy91QzdsN0hsVGN4T3JLZjF4WXV5UDV5Y2c0SVBF?=
 =?utf-8?B?ZzVmaENjckt0SzkrOFA0ZmJyT2YwSjN4dlJoSVdmV1hEa0NhRG1iYkxFSG1T?=
 =?utf-8?B?enNYM3F1dnFOejdDRTlpZkREaU8xS293bmVFRVhXUVpLMFo4SjZFM1lCSWxW?=
 =?utf-8?B?VDNlMkc0ODhhMlk5VGFua2MvajQvV3pMcmdDM3h6ZTU3TnJSelRtN2thU2VG?=
 =?utf-8?B?WkdnL1ZYNFB3d3ZLZGw3a1NwRVFhZmxZL0xBaUdna2Nza21CNFFKTVB3Vkdy?=
 =?utf-8?B?anZLMTd1NU04ZWF6ZDkweXprTnNYZnpDbFRCRXNTOTNQaUZIclEzd1JuNTZx?=
 =?utf-8?B?UjV2MUJFWWRyNW4rK3RXQklVYUhHVzlhY1UwWDVhNzZLbEs2N1Zvb0xWT0tD?=
 =?utf-8?B?dFYvUE1BOWx3WDFtQzZ1S29PclF6V01FRitRT0VEQnVkdmM0S080cFZLNVZU?=
 =?utf-8?B?YURpdEQzUkNjNkJVLzhiUnkvdG51eXVYZ1hGYTZld2QvTFFIQVFtZXhlVTNZ?=
 =?utf-8?B?YzBCUGFYbUs5S2dwQ0hWamRXc2NCWWYyYTc2M3MxMkYyLy84eExhWjNNY2Jn?=
 =?utf-8?B?MW94Q1hRWUxNSGVnOHdHOHV5blpmYlBoSDRCSyt2TFlUZDJqVGRLY1JVQkIw?=
 =?utf-8?B?UFZhNVNETmdUb3ZkR0Q1bjhFNks1K3VIanROdnUvV1R1bE41R3BtVzdZcjNF?=
 =?utf-8?B?NnRKVHBVZGcwVUdBQUt2SDNrQTNlZ1A3SHMyY1RlVGFRVmdIQ1phZ3dCOXVo?=
 =?utf-8?B?WkNIOUlxMmZYc3dnYnRjd05zR0JaWWtTelFYUDhFMFN4aVZ6ZTc1ZWRIeUVI?=
 =?utf-8?B?a3ZLNVJPQnVPZlNVTGVBajk0NFNGV2ROdWVpTzdhbGsxVUc3NWxTV3hiMVdL?=
 =?utf-8?B?ZitzcmhadjZlRldPbU1GZ3NrdGFHODdZWHA0Rm1Mb2ZRQ2NTekdQbS82STNz?=
 =?utf-8?B?VEo5YTVXRnd4WTdBOEFybDBMY3hVM3lGdFZ0U2hHaEdlRmhZQ1A1VVR0WTJp?=
 =?utf-8?B?OW1EeHZJOEtOR3UxRFkvc2l1Qk8wT1R1VnpzRTdCQURtMExmN05qbE8xa3Vx?=
 =?utf-8?B?R25CWDYzUEZwbGUxOTg5R2hlUElDdldtcGF2WkxQRDVBYml4NzkzRHJwM0RE?=
 =?utf-8?B?eU5WdVVCL0IvNzBHY3lHenVtY3RtV2tkRG92U3ZISUpYU1V4VE9DcFF3Z1Ja?=
 =?utf-8?B?Z3U4SllycWtyci9tcm4rQytKQlp2bHc0aldFTEdGNFNaK0NaVWFrajZxZFpB?=
 =?utf-8?B?VUxmeDVhVXorMmZqeHh0TXh3TE93Nk1Bby9LZjdmejZYNE1Dd21qYTR3MFBE?=
 =?utf-8?B?ajNUUE4zR3hJbFZKdURXbVBnSlZrQTBuZm1GUU9SeEhxc1hwUGZkeXdLbGdB?=
 =?utf-8?B?MmdHcUQ4emVQWHRHcHpVVXFtVnQ3SUpPd2tod1pWYnR5bXdOS2l5b1pHaXVD?=
 =?utf-8?B?bGJJZHRMTkViMDl5WkNwU0ltU0ZCaGZ4V1VDVy8veWJYM0laQmNRejJTeVYr?=
 =?utf-8?Q?p+W7057jFuGjdyPS2XpOgc+yrO5?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3lpTWxiM3JUenNONTYvWm12Q2Q0TldkdThRUGVWTEQ0TU5UTjNmdzc0K1dR?=
 =?utf-8?B?c0UwREUzOU92Z2oyMWprNGRuNWRKdHM0ZHhBYm9nT3phaUNKTHhhSXo4MU94?=
 =?utf-8?B?QlAvZkQrSnpCMmlOd05uZDBON05DRXM1cEgwSDJmZU9HVUpTWkhzeGtCQUwr?=
 =?utf-8?B?dW8zWlFDK1BoOEV2K2p3RmpvalpwZkl4bUJhNlAvT0xJQXFQOVZjTzcyTWZL?=
 =?utf-8?B?M3Q5Z3cvaE1NY0dFbUN4cWRMMFJ6RUtBaHZCT2dZbkg3OUM2bExLWGV1THZa?=
 =?utf-8?B?dmRvRUFPcm9PK2l6Y2RJMGZQUlJnSW14a2xmbFF1NjJlM0c3ZHd5cjdaN2or?=
 =?utf-8?B?djhaSW9IQVR2eWZTUTN2VFFSdlpNZjREeTRYd1N1NEx4UlVETVZiYlBVRmNp?=
 =?utf-8?B?aCtTTzBOV0hxM1pNc3ltdXNjSVhPR2lrSzZSeGdyRmg0T241TlN6VllOMzMr?=
 =?utf-8?B?d3JMVVNraFVnOWNybDY5MmhLeVNwSGhuNnN6L2tlYkdxWnBMVkN0MjZlWmVO?=
 =?utf-8?B?UnhwZDh3SjBzS3A5K0g5Y2FFLzhWODkzcnpuSjQ3aTBaQU9kMWFPdHhpdXNt?=
 =?utf-8?B?YzRkbFY3N2d4Qm1nM0hDbkhvbTJsdU4wV2RucEFPNnhXRlFmMWVqTkdSMFFB?=
 =?utf-8?B?V2JpOUlrVkxUMHQ2V1dXRXN3T0JaWTFydHhyLzdOUFFvbmpIdUh2b1RpN25X?=
 =?utf-8?B?NlJzUW9pbkttT1RkZnFuMkFIV1pGN20xUmlwd1dMdjdtaXkzQjQxdTZBaHdh?=
 =?utf-8?B?ZHdJaTdoNVVzd1VYYnJtOWRmRmJSdVp6bVVmd1Nvby95S2J2MEZkT1o0YjQr?=
 =?utf-8?B?ZzZiLzZscStGMHZhSnBaVStmb01pZ252cHc2S09iMTQxTytTTk85dHN4Smt2?=
 =?utf-8?B?RlZGaUVCcldJVEpTVEp2dmVyc2R4UmhQb2VYU2NZKzBLOUVZNHhVeXpiQm1O?=
 =?utf-8?B?OXhYRTFoTStUN3dHUFo1QllLb1lrcnhSNDlseFVteFlsNU91c2YwTmJQR3Yv?=
 =?utf-8?B?K1hIeVB3NHYxTHgxR0lCTStIZ0ttcklJNTN6VEZtRWlxclFLd29ieVprV1Iy?=
 =?utf-8?B?QXV3S0ZRUjhtQi8wODZpYUpJcllHWjR0bTBVT1dSVnB5NWh5RHJHSW1RU0dQ?=
 =?utf-8?B?ZUJDMG1YdktGUFMwNHhHdGdEYldJb2lIek14YW80cnBzRTI0cGt1ejAwREZa?=
 =?utf-8?B?QmtLb1NKS2gxK2JKWUorQmRXSElSZlNLSlpieERSMkFVUUtvWHBFY1NZWGxR?=
 =?utf-8?B?UC9JZ0ZuRnZsNmdjcERnNUpQbkZYTVJGTnZSSzJvOTk4QktCa2pjeHMzblBV?=
 =?utf-8?B?cHRrNUlienlIQVdSZjM5T0g5TDdUM0hCL2NXVG5memIwVTZ5YWdoeVZmSko4?=
 =?utf-8?B?NXUyUE5LTVgrNWdzTEVDUjE4aTlwN3ArZUhWekpHMUhPWkttcXR0RytEYUcw?=
 =?utf-8?B?Mmk5ZnNVaWNvVllRT3JGbjBaSXAxNGRPWXNLZEhTVVM0NVNoVnBPQUE0SGRI?=
 =?utf-8?B?OUhFVUVkM2xmMStOc0FMcFArMVNyT1dHSTFXaXk1VjZRVjhrYVF4VC9URXp6?=
 =?utf-8?B?Ymo4SVFINjQxZEg5bWp2L04yZWFicldQb0dLNm1TZnU2MGtzSmxkbmZ1UUpz?=
 =?utf-8?B?WHJUOGRvYVg5WHFnUHFzS1dZU2FwZ1NHSytxRGJLMkhoMk50Q2dOdzJ4QlVH?=
 =?utf-8?B?WnUwSHk4VVMyWkJFQkYxcVZ5Wm9vUVRQc0FxeEhqc1l0UkNZbzdud1NaRGtt?=
 =?utf-8?B?MVAyZkNwRnByZUpQNTlPK2EyZzJ2LzU4MUlWdHVJMzNza2QzN2VVMVNsb1BL?=
 =?utf-8?B?OXJaRTJYZ2MxeFpicXpHRWREVDdpaFErMm9nOTd4cnVKQkRLVUdPc1Zzc0ph?=
 =?utf-8?Q?9R9ahAYwxogg5?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b572e0-47c5-4cd0-5f56-08de94433159
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 01:15:45.3706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB5047

On 4/6/26 9:30 PM, Jason Gunthorpe wrote:
> On Mon, Apr 06, 2026 at 09:18:19PM +0800, Wei Wang wrote:
> 
>>> -	msb_diff = fls64(end ^ address) - 1;
>>> +	if (unlikely(sz_lg2 > 52))
>>> +		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
>>> +		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
> 
> I was looking at Ankit's series and thinking this is slightly better as:
> 
> +	if (unlikely(sz_lg2 > min(52, BITS_PER_LONG - 1)))
> 
> So a ULONG_MAX gather will trigger full invalidation on 32 bit as
> well, though it shouldn't be necessary it seems a tish cleaner and
> matches how vt-d ended up
> 

I see the value in matching how VT‑d handles this. I’m slightly 
concerned that adding the BITS_PER_LONG check might imply that AMD‑IOMMU 
supports 32‑bit kernels.

Unlike VT‑d, the AMD IOMMU driver doesn’t build on 32‑bit at all. From 
Kconfig:

config AMD_IOMMU
         depends on X86_64 && PCI && ACPI && HAVE_CMPXCHG_DOUBLE

config INTEL_IOMMU
         depends on PCI_MSI && ACPI && X86

Given that the 32‑bit case is unreachable for AMD‑IOMMU, keeping the 
existing check might actually be clearer?
