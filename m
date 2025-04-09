Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECA11BD9D3
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 20:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744229464; cv=fail; b=SE1QB0HMOgrUS39Uvu92kzbLPyhVyqa27knjad1bXstulC72vjvFu/n4DvGVatDy4xXfO6fDkV9c64pOMXhk3n3JQUO2oDQr4AybfTF8m/boSz+Z4v/LIzouRj2RefSk+EOr+e+jg7CjW8SWXdnHVybFcp3jmncKk2ZK+Z+ccFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744229464; c=relaxed/simple;
	bh=aRvIl9La1f72inLVmM97EgnD5VOxw2nDBiDW+CGaA30=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nBzxGcX01ZIy3QJezRBfHqNmyayLDNA87Z93wq00FUbfETH+Z0RkYAZZg3CzQWJ2jEP/uqTHF1yoAwzTxz1b7FybJBSsLXs4GuuA/G5swIoXotPVCWMFxmaR4j1pfvnN2bPk931HRTLmivPAWb6a9L1/O6GQHsioTq340S2NikU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JNundYSH; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JNundYSH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AeZv1aib1bSrfn7nOAhbPMRtX8l00ffi3f4rQkGEW6pOF+LFyEYVAdV4ffB6qnFhDcry67GPa/cl1xSuele0879Za4Vv9QbBKkUUQWgg4EwXZKB5wGS9oSPRtP+1nm8choHxW5dKzbSgtAvauk/HN6svZyQv72Ow6vxNq+O4DAJRvPuI4QEl7gPBKz4NN3vy69RbQBJt3VbGKlCLlrA4TvQgYUP9X94aGNaCDZfamuYFcNb7D6tl5FmkjqmXHTIMH/C5IAz3bBD5+YQ6+Ae04UfviadhNEtjsCYNmVnq3mIFE7JW0vEFFb6MyZoGEfgO8Fk6tJ5dYdYU9FLnhsXceg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAn3ByIlbFt5AkJYsO/RREzJs74Tx2xmORMSlrQsVMs=;
 b=bPPPxO9ITrPbEBmBnmaSRIhPBd3y29DH60hrjyNmFTIJRM7ghz/uQwD8c2vSoR2cLsxEIMMHKPJRUtjT3vy+6fhjqHYVh5uakwZVbNpbdS3ZvHdXxT3Wrxzf2VPESGGrysQzLMA+DaDxtdx8pQP1EltxdogBPXaBONPwGNSRfSDhxftuanaAihBhERKpgJ+RfbbI7kVWvJizXaAVRF3zgNZ2aj6JCMwfUqrZlFgaFyjvkg3WOSHFu/aK8A6bDECbcBhGjtPU/wPHQ7/5TzZcxPO6aNoNgEmgU+Ulq+AIreVrmI1F5grRJo+REnVRdTEcgy++gzHTZuLKkE/F8FIkGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAn3ByIlbFt5AkJYsO/RREzJs74Tx2xmORMSlrQsVMs=;
 b=JNundYSH3jOjhlsz6wiVbsVqCJEeP9JoxWKoHMiCQl2NiU5i2TQbgGjXAUjazYMtEjRN4XmI6AWHVHMGR1NFDP35F4Ruqvb8fcLb1czAJ4tt7+hYJwnE7pY9xW2Alec1d1usOu754nWQY4Sjwyf7lIIJGm2WKwEXXG7VECNMgJTppSa5BvGWP0tkNGjFpr7LHxqvO6U6uENm/VkSJ5bC3VccUufcA5+1HXwYRySNxmlYoBiM5rxtfzOnqhyEAo9/sfwimLNymBgpqhARxLMwCXBfqf7V4VZR3CkBDcExY3D7lC3i9AK9nN5cdcSELGN3FktV0ETyf0JMPLU9wy3foQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by IA1PR12MB6649.namprd12.prod.outlook.com (2603:10b6:208:3a2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 20:10:58 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 20:10:58 +0000
Message-ID: <df598a60-1819-45d3-b278-87d9419dc456@nvidia.com>
Date: Wed, 9 Apr 2025 21:10:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/726] 6.14.2-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250409115934.968141886@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20250409115934.968141886@linuxfoundation.org>
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
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|IA1PR12MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: 930f692f-e0f1-4b96-d16c-08dd77a2a45c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmE4WDhPT1JjUHpQYkRSak9vb0w5STNPRm9qL0FUZ1NZY0EweHk1aWp3OGd3?=
 =?utf-8?B?WFFySlZKYWphMFZPcWZkcjlUZmVocC93NDZud3VYbFRWNWVLWDUvNjNkWTc0?=
 =?utf-8?B?TW9aNnpJVDVybWhEZXVjWW95bkhnaTNQUWJIdTJTVU9hRjY2ek1xdVdMVG8y?=
 =?utf-8?B?QUZDQTVoajdTZW9PRm5IQzQvcXV5aG9PQVlGQmc0UHNzWnpOTE9CSVpETEFw?=
 =?utf-8?B?bnhBeVAvYXZHMUNHVXl5eGlGQW52TjZNaTNWVEMrV3BRNzNsRHI1ZUxwWXpt?=
 =?utf-8?B?blprekNkdEgvWGZacGNQcDJ5QkFUb0dCdXYrZ1hSc2NnRlZDZ2NtNzBTSStk?=
 =?utf-8?B?cFMvQnlvck5YOXkrZVJ2RmRlakVMa3MxZzIrOUswMVVXd1p5Q3hVbVdYNjJC?=
 =?utf-8?B?amVmRy82c2FSSG5HTjNsUkIxRXZVRHAvNzM4U0ZhZXpjZDBmM0crV0NyajJU?=
 =?utf-8?B?ay9uWk9SVk9Dd1lXSXR1MGRzVzh1NjhsNHVPVGF5NW5kOTlhVEF2TWFFVkI3?=
 =?utf-8?B?MFlNUEMzZndtVVN0MFN4ejlZTy9vOWVGd2xaVFZCTm1DZmdSNEdzZ1hnL25t?=
 =?utf-8?B?bUtRYVpiSzg0azRRczlCZU5DdEh0dDJCMVpITk9qRDZNL2ZpRUdDVG9zdTFL?=
 =?utf-8?B?NWJlcnFOb3BTOVhTS2M3WDE2cU82ckFBS2hSWlIyTlBhdThHaWF3UFhyTmpX?=
 =?utf-8?B?cXFJN0g4OUNVa3RPeG80RHdET2dLelI0ZFJnRWt4Q2dOYVM1Y0VaeTBmSGh2?=
 =?utf-8?B?ckZJS2h2SUtZcS9xdFJQY3R6djEvbDJRSDZITGZLTVc0UFVFWmZCTUlqNEFD?=
 =?utf-8?B?TGJ2dXVGRXpxWWNGV2I3TFQxbHpmYTBjKzFNMDF6ek5PbkpKOUo5QWZYWW5D?=
 =?utf-8?B?T1dFU2dabm40RHNGVUlFOXMxeW1pK3VYSEJ0VjQ5QVhUZlE3TmFVNzE0NWU3?=
 =?utf-8?B?dllqSFNVV0FJNk9TWTBzTXhMYWxUbEc1OGRyR2hzbE95TlVjVmh2UTB0MDB5?=
 =?utf-8?B?SzUxcDBxU1RDNTl2aFdTbmpzTTdWTEJvWFJzUGpQa1c0ZXF6TG1PYXJNbXll?=
 =?utf-8?B?NFJjWmdteE9FTlI1ZXZKQXh6cmZNeFozQXNlcWdLQUNKRXVPRlYrS2dXUVFa?=
 =?utf-8?B?aU5nL2NrbXMvNUE4V2x1ek5BQkZXMXo4SFlGVHczV1RRSEE0VG5DQXd3Zytn?=
 =?utf-8?B?ZlZZM0t6eitvN0FZZTV4Yk4zRGhybnFnSlpNVjNhNFkvZFJNWkw5aWl2K1Jm?=
 =?utf-8?B?WWdQRlVXK0tjS3hpNGkvbHVIVXJzcUhKQW9tcS8yVitQV29LNlNrY1lYNW1K?=
 =?utf-8?B?NDlwbURkaTA5dEhJKzNYSmV0cFhiUCtIdVlMUzFrbVZHdk8yYlR4cWFTWUVP?=
 =?utf-8?B?SkFlL0JXYmtqb3R1M2xWc1dTblkxTk1zdXp1NVd6cTNMVzA3UzJ4TnJxcWgr?=
 =?utf-8?B?VDlwRDBLbU1LK1Qya3lXck42Z2U4Y3Q3MUwvVlpocmFXNjJ3Z1NHT2h3Y1d4?=
 =?utf-8?B?cmVxdUdkOXZ5eWNJY0FQWDVvRXNyWU5INzh2RnQ0T0FhVXdVVnU1S0lFOVlx?=
 =?utf-8?B?enhDc3ZlQ1JGY0E0UkNLWVhPOHJyZnZadjVYSzdSVUZQbTFCa21oVlppcHJI?=
 =?utf-8?B?bmlnRURNVUFxSXVKVFprNDVlQ1I2WnlFOVpqYmVFamdnby9oV3g2Y1RwNW4r?=
 =?utf-8?B?QkZUcXdUakZpRVhsMDR3NklzMGNlNHhhNnRLL3ZZYUxpV1BsV0lDTzBsVThp?=
 =?utf-8?B?OGRHVFRFVDNDMmZRelF2RHJaZ0JBWXUrRGYrVXZpRm9kNzczM3ZmQTNaOFZi?=
 =?utf-8?B?Mm5BZEIvNitIdDE1ZjNOMXJ4Y0dYaHJDYzVUSmFnQ2JqTEc2c0VTMDhqRmJw?=
 =?utf-8?Q?j0lv76/ZiiaxB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NllLZHpwRXB5emFXd0tWZkFQeFRMcmhRaDNLWlY5ME9PVmhKdzZzUU1zKzBj?=
 =?utf-8?B?MFlJRXBDcDVjaFc2L1JyVjVPYzJEOEF6WEhLU0lvb2xvNm9zMGRLU3VCSkpG?=
 =?utf-8?B?em9UOFQ3SjlzQ0pJVTdSMjRCNU5oaDJXenkxWUNPZFVwbkVVTWNUR0ZDZmhE?=
 =?utf-8?B?SUhFcWRlT0hEL0FzRXJsSDV3VUc2b24zS295bTMxWlFtVGNyUDVMNGV0WElv?=
 =?utf-8?B?TE5vWHFSc2d4VDB3bjF1SmlpYkdJcXhXblROWGZhMzZrakxHTk5MQU1xRHhG?=
 =?utf-8?B?eVgveGRJSGRSOExQT2tqTVltdllKNU1TczhQUW04RWliTm1OelV0QXZGM2Vi?=
 =?utf-8?B?ZUFiUzlsQTNEZVVoblA2eGdOcjYyQTR4eDFVUWdlSHRhTnhMTWRsTlQzNDJ0?=
 =?utf-8?B?Qk9NeVBsSVlkYmxyc1N4YWNVTXZQV0lMWlJOUitJa1JMQmpEb1JlRjkwQmFz?=
 =?utf-8?B?U29TYTQ0S3dHZ0JsZmd2S0tmRW1aeUpxUkZmTXJhSlp1V1JxR1g1d0JZZWs4?=
 =?utf-8?B?dDg0STkwS2RibVhkM0kwdkR1TXRuT3Q0ZlZGRW5lNEJHQ3VVUktxSSs2emxt?=
 =?utf-8?B?NGdRRlI1UHhSRUJjZTRxdGlWbGJYQXl5bjVIZnZ1cFlUN3VTRWtUU3JNYzdL?=
 =?utf-8?B?cWhxazFBaUxRWmdvdVRqMk02WVg5cWhGS2VqK3Z5VHE1K2tRVG5RckNNdXJ6?=
 =?utf-8?B?YkZtaTRSUXRWaGdoZmtzR3JmU0YyVzh5cTNkSVF4WFJuTHJzY1JIdGdSam5p?=
 =?utf-8?B?bjBYbkUwTUxnbm9JbldmWnlvTVFWSHNJMDhySWgrcGZQKzlZU1hyQXRpYXNv?=
 =?utf-8?B?TVRkWTF2clMzVmpHeGhVV3hLNmNKNVZSdFNYUmpuU2NNdjA3T0dvL3RxRkRs?=
 =?utf-8?B?RFREWDZ4SjVVbUZmTHFGdmZFbTlndW9Eb2U1dmxRRm82SnRoa2F3elFZR0JU?=
 =?utf-8?B?TUd1Z3Z5UHBzUk5vZHZBbmpWSDMveGJvZVpiZmEzOTM2UVZyTm1ncVVzL0li?=
 =?utf-8?B?VnNETEVOcVJRMUc5TE1adkFMdHNXZWVMeXVaOG40bE5mdHl0a2JOc0hTN3BX?=
 =?utf-8?B?QXF4MEljU1RoeGYzaGFLVkhsMmIxRmgrNENadTc2VG5MSnU4SGl4WEVSMmNB?=
 =?utf-8?B?Um9KRjdnS09nMEVpRE0wbVFOdnNYN043bnI3bzZ5RThRaEFLRWluOTQrY2pX?=
 =?utf-8?B?NFM1eE5kMUpuNDVsaG9USzFsTUZTQkZZRGovbkR6MUpFVisyalpOeWdxMVE0?=
 =?utf-8?B?T0k4ZHBaQmgwMlQ2bHRHWXJKSUpEb2tUV093bkp5Y0NPdlNDcnZuYVVsajJV?=
 =?utf-8?B?T3p3OGV3UExFb2FuZ3F1M1hRUTZ5dDZLREpRWnU5bUNmeHVhY2dKdVEyUENF?=
 =?utf-8?B?RTNCMEpEM0lBSjdUZFBzR256aW9NcnQ5QWRpU0RFbTMvbmIrU0FQMDNTaHJl?=
 =?utf-8?B?WG5ocFFtSENVYnAyaXUyRGJLamtnU21iQXNpbE80Yk90TkMxVmVqMnBYektt?=
 =?utf-8?B?NXhqS1J3czVBbk53ckc2eThtd29KaVpVL0lwVDVINkRsUlpFT0Q2cVpoems1?=
 =?utf-8?B?UUgzRmpIZlFlcE5CdUVYVUhCTU01aHNtQWtDWkZGY0taRXhJS3V4R1lROHJT?=
 =?utf-8?B?UTVNVU1pd1RhWTV6UVl2T1c4V3F3Z3EzWm52WGFnSFpIV1NQKytsUWNlNnlP?=
 =?utf-8?B?anR0N21iMUtMTkpNWFVQcjlwMCtudmdreEtPUTVwR1VsTGxUSmY1WGdXUEZs?=
 =?utf-8?B?bmpBYm5FYkdkdHJoZWQ4WEl0NnoxdU9KaXpHQU1FanRFMWZuOWR4NGZtZGFi?=
 =?utf-8?B?TFRYYVc5dTVHY1ZxME5vLy9BcDNDSnVSRVl4SXZtTGRBZEx2MWdaWGdHcTRB?=
 =?utf-8?B?OXhBNFpLa3k5YW5ESUVOcWV3Vk9aNThlQ3Y2ZjJRSXVGRFBNVXY5MEU3OXFC?=
 =?utf-8?B?TlQyblZTcXFnYjFZem9SclhYczVpbWdkL3hTNHA0QXhzMFoxOERrekIxV3Rx?=
 =?utf-8?B?cUFubFRualpDbUI3MzJHV1k1TkxJMFhlaitoTWRHaWFiWGZndXVSWUVYbE1q?=
 =?utf-8?B?VWtnWXdza3hVUXdPbzhJd29rUEFCVzg0YXZqSmI5TlpsYWNDU3FKL0xFU1BS?=
 =?utf-8?B?Y0V2OUlBUmszUy9ULzlWOWl4dHlSa291QkF3RjVidjZienFQMmZyTGhmcGdy?=
 =?utf-8?Q?jNxK5FPHTKVWj1j+PhOOhYIy/k+6lDNthXTy553yoHsD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 930f692f-e0f1-4b96-d16c-08dd77a2a45c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 20:10:58.5232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsFTI3bOjuyoCjpgIUHIxFrFLq/PhpNYplpLbo81Gjw/Tbdkjih3/5scG3pRLU04VtN4SoigxLiNleNSg2hIPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6649


On 09/04/2025 13:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 726 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.2-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.14:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     116 tests:	115 pass, 1 fail

Linux version:	6.14.2-rc4-g2cc38486a844
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra210-p3450-0000,
                 tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic

