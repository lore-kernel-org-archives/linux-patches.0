Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794223359;
	b=FDHSMgpsEARx+1PcwjGA01Ovqoi79jFgiGFieb0e0riqKrzqy5kYV4LX0FVbwrP4itRj
	 ERKDabiR10DmWrUIPwXaP/yjSp2lLMXl0sKTAVTkMoaYBRkx7qM96Q3I4ICfnHOqajHP8
	 GjOP4VkTlC9fjJkV0KnPaEt4Qg7W7rsCPbGIyfEevj5tVDM0KMTgHbzdcctD3R7hLIXFf
	 HJEq7u2kl+Dc9lNUHqc42/a8B4B/FVadSiU0+XE20LUu0QbN+x1OouLNEFZk4z/VWyxPV
	 cKEn9PPI1Z/CYknVyUYvld54ZNw2OUvAbZ8grJcBX/cCReJFtu9kBJOPh2gVvXJaq0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794223359;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=JjBXpe0KdFPKejnpWaZtnhed9E6HNLPQzaWogJHVOfw=;
	b=Unl/6UxjyHtw9hRWPpnBTnkr/ZSND7s751zlBY4bl45O+/FG4b0wzEJPggI4D4VusDq0
	 knmfr+cw1cJBvnVudoBQaCoYJs0+jMZ4KejO3HWA2jA+x0VpczegwSfi0PyxS5u0FWfos
	 tfTg3/UPjGUTg7k6ddN1ziZgxZ3ai6ljkML6TW9GvjxrMGqtwcT73u4WHDI6SgHHS5RxA
	 AQ7D7OOPfg4Onc3Q69zps9r1detlJPpbiWol0hRn34F8rWeIzhDpuEq9S8YQHR95apVLc
	 6xs+Sa0gcQNJqSiYiPHgrNccT+OXNLSQx5bKNoa1Ac+1P8eH8MmbjQizBX62nDu2HXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="B/l+1HOV";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.6
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012006.outbound.protection.outlook.com [52.101.53.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C593606A321
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 11:22:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C593606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=B/l+1HOV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J+m0PJwXtvl8P9DHSfKMaPr+j8EL4OQmuAWuTgBsaUMXQbQJiNb6fuy6hcPfCrQ8AiTc6OdofsYl94TRaTXVyAEUyfRFoFzkta8hHQEZzSUtduN/tuqVKLpknyH6bu0hy4qK+t60moiWSdtMqHpmfgcuSK/+eYkDuzq7amD8bKqqXiUtBF+nTPRIc1+0BZTtq48Ug8DAxVBh1pcZCjp5xg6f8nf1JhqwR6CrUh/ubJnkt+Io3D5jzJ/TslRC3+R+V6w3yB62YK/5EdfI9jHLSC9FrAdD+BmgfTLGmWJrWCLprSNxzkX0tP4R4RD96GjM+D75CbtVNoz9DcV+RS0ICg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjBXpe0KdFPKejnpWaZtnhed9E6HNLPQzaWogJHVOfw=;
 b=vxllmiakqBFhI/MIylaB91X/DfwgOkuK1AmOs/QUDgbMYYKJ9Q1F8VXu8djcI0b/4UfFxRiCcMXaIMhat/lhZfRZKecd91hHfGLGWaGCOAH7jrs/aj/0v0gsPQaWTI1IAOa1YfE2bfRUjxEsup7k1iuOgDs5xqzC0uTf+7E8jUkFYjdEMCccQhiNN4Y1VMMtUw5JDhOCYESlN3Ke8oa7S7RIaX/szR1DwFcibnlWXvVl/v2LTSWvOd6OWiX+bKrtSficujBpfdI5dTp5vlu5mqr+m/b+3xwMShaLWatcVGGwLMwPH34RHqbuIwsK5RHfqibebeK/vg2RsyfI1tvDUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjBXpe0KdFPKejnpWaZtnhed9E6HNLPQzaWogJHVOfw=;
 b=B/l+1HOVNp58Go9qg5KAQhXBIDiyyNJ/qZ+3mBqpX0eGnUzPr13hI4DxZyLOJ5Ij8/1FykeqpQjTwcmB5CSdMXdTWyYkjoaa4ECVCK1EcwAN2E4pvCsVQxYxvxyahfJ2xp/15MsLMagX8Uh0qkw6MQRQsHC/Xdr+OYAE/UQKVuxn/bhOru72oXHJc1uGUJZwAn9j+72FwMkpcEKE4L2BB/GvVh8nYVGHj90fvoqrxOSbefOBuFWRAdFRk0kaw8741AKKmtwlAScZVeJ1nNIUHkBruDKZsU0EfuqafswHxh7jafk9AwZFo7foEPGWvuJf6zPoLQxftK/NS5F8oPpgPg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11)
 by MN2PR12MB4456.namprd12.prod.outlook.com (2603:10b6:208:266::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 11:22:35 +0000
Received: from PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740]) by PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 11:22:35 +0000
Message-ID: <e3ff8145-13c7-4282-925c-b4196bef6337@nvidia.com>
Date: Mon, 9 Nov 2026 11:22:26 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
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
References: <20261107134957.653319350@linuxfoundation.org>
 <avGXNkyWQfNqN46v@duo.ucw.cz>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <avGXNkyWQfNqN46v@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0015.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::20) To PH8PR12MB7110.namprd12.prod.outlook.com
 (2603:10b6:510:22e::11)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7110:EE_|MN2PR12MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 243f4ead-fe33-4b53-b105-08df3e53c0f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|10070799003|1800799024|366016|11063799006|4143699003|56012099006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MGeMGWkAFwsos3z7kZyMCDgxOoCF5GfHjy2pJ1jsrDfwHx53JaBw66t68/CREI+WE/JozjFhT/by/nTVVs0mCG1f4H1SX6QoSLu4+MS9JB5MKDZCeTWbLYHhBC3J0Aq6y/tt/vvINRr+sAcCsEaDPpPfnmgvKqIxCvwTAVOy9ZnyfBlw4v7UyqSzPejwsL86RPF/t31J+gNygAQIR51R0buoO3XlNrfmxxUqiIZZvPui8lT6EkVtpygoC69FbVaf3jTPByg59ewn28nL2eSTQJb5zBn5Ii/Gpbj/aHFuO9j4d5UTbYojNF7sJML3j2+ygvZmM0g7kp7BKEK7q7PwYWKo0nfUhY1o5f5cH1ZWdXlB1TET5oxJC98DP33T0jxLqacbyuEUeF6Hi3+HwDDjMXR2OXXmbO1ASXkEVBFtFPmlFudpcDk2vCS0mjZAih7FtXE0NeaNw+1O9Z2QlbDHpKc/KgzwiWgdMmfYllkWLpH/tVrPMAKJRQodig7fHP/PS+0qK9/8KDl0eExO9balOFfQ8mgoFNdM+ekg6SWE0d68Jh5660PZiRVpRfEemhnPum7wgIgF+aFZGUA1UX8KN54qLnqH6+MKp0mvUOT7KVrN71YIlKM5onQt3E/DoScAlVOwg7ey9JD2Ud3qybqwE6QfRr41nMLIG0GCacQMSgE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7110.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(10070799003)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjRBUEZ6OHMwRU1kMmxyM1FkbjVjZzZiVTJqRUlUNmlWcDdTSTIrN093djhk?=
 =?utf-8?B?d09oMEI5ZjlGR0ZJb1N6bkdjSDM2WHdQTTU0Ly9SdHZQem0zR0JLN24wL0hx?=
 =?utf-8?B?M25VQkEyc3RXK24vbU1QNUt4cUdKckM3WG50Yi9iaU1xNnY4RWJBNkZUbTNz?=
 =?utf-8?B?UlgyYlAyMTRDVnhGOFA0T2tMSnhoNEIxeFh6UkEzVzVIay9kNTV4bUtYd3lS?=
 =?utf-8?B?dWovZ2ExQ3kzVExPRXRiZWJIQWxzZ1FFT01RaHFLYlMxS2tja2lYaFZNRytP?=
 =?utf-8?B?TWNuS3JpbmYwTzkzbk01YmVFRkl1azFHdFc4UllHWDRMaGRvTTA2NTc0UitG?=
 =?utf-8?B?TFhnNmFjb3BHOGhDRldTV09taGVrUVdJUCtmTkczeGZxaTJVN2JvaTJPSW1T?=
 =?utf-8?B?ZGdubGZNRWFubUhtVTdCMWRSSjdMU1pCSlJsNjNXRm5QTU9hLzl1Z2g3M3A5?=
 =?utf-8?B?WFpFeU1IbHl5YW44dkRSZEhRY2JGSksyWEgveEMvL0RwWmJLM3hDQmdoOXZD?=
 =?utf-8?B?Y1ZiVjlKRDVLYmcvK25WanN1bDVZaDlyRnNFMy9sREJvbTBXN3B3ZWdUSG5J?=
 =?utf-8?B?YjdFOTl2WkFPbXZGdzFoclV0WDVkdHhacGZDTFF4VFAyYys1Ynp1WldMcFUx?=
 =?utf-8?B?TGQ1VEZ0bGJrcHVpd25DbG1HWW81bDYrMmQ0dUMxVUM1djRRNmREK1RFdkhp?=
 =?utf-8?B?RkZuaEc3dGowTFhid0F0VkhIR0d3YU9pUnlwRmphWHBScS9OMGJuS1V2QUNu?=
 =?utf-8?B?clBRdkxYZEtLNnp2akhqOTdyZUZVZ1RIMEhGcTJPWndmUC9CalNPUmh1RkR5?=
 =?utf-8?B?Q2VrNm1oUWZtYVhtNnJpblM2QkFES0xpcWdmcFZqcVM5N3pBTlp1WjJLQW53?=
 =?utf-8?B?dHZXMWpJQnNIVHh1RE9HaHFaSHl2NWhOM3RnOXdCYS9BTnVEYmgzenl1Rm8w?=
 =?utf-8?B?TmYyMWhPNkx6NXBzSkFMUXdHVnpzQmsvVW5LVHFTdVBaVXZBejdaK2YvOWFC?=
 =?utf-8?B?TjRVSUpCRnNKemdsK1BqL3I3UDRYNUZLeG0vTDlXVHV2ZmpiY3p4QytlSWNo?=
 =?utf-8?B?V2xYdkhTaEdObk9mOXFaY1h1cHYvMEtoVGFYOHpBdXhEdStwMnFkUFVoam5m?=
 =?utf-8?B?Q1c3cFFnVm1NbWI4YkZKYWx4VmFJeWp0THdIRUlWOXdOV0NSOGk0NndITy9z?=
 =?utf-8?B?U3ZPdnkxcllVZFVPNDQzUWI4bm5yM0NQUURNRkd1MnlDTWNLQ1l3WWhoVlVq?=
 =?utf-8?B?dnVuUVFwZERCWU9YK0pqTzZaWVhUZlRtQjRTS2ZaZUJqZWN5L1NMNTZCc0VN?=
 =?utf-8?B?amFxR2E2dllhak5IdnBxUmkybkFId1RzeXdkQUZZdmNQcTBNRVBNYmN1RjJL?=
 =?utf-8?B?TmwyQkQ2enFtWmxTTDVQRmdSTmRRUWpXenl3VHJwcDJXS0hGdTBWMXcyVzJM?=
 =?utf-8?B?S2wzZERsT0pJdEJwdm1EK3k2WE5QKzlxd1ltOTEzVmFjcFZ6WHp0N1M2cGhi?=
 =?utf-8?B?TjQ3Zmw3OXl6N2dacHlmK1RzaEIzMmVvR0E0bkdjbDJZeWUyOGlTOHVSVHFG?=
 =?utf-8?B?cnhkajFaWkhSZGY5d0s3SXl5YTlzNUJKancwT2JmdU1LZHdWZERubXg5THZr?=
 =?utf-8?B?TTVYNDAyeS96SlBiY3BsMGQ2OEcyZEdoMUMrYUdUMkUrRmdCdHpDcmhCSWZT?=
 =?utf-8?B?WitzM2plN3I5by9HWHZ3bW9sMms2WG5DaHZHaExJaXdqc2o5bDlwc0Y4UXpr?=
 =?utf-8?B?aGsyR3lYUWppb0RFOTUzbFFaWGRxRGIveEVsbk5LeFBRQ2txL1lwMDVucFda?=
 =?utf-8?B?RG55N0tIM3VhcjNtZlFuZ2hqRTBoQWVjYXBQckN1QTZUeGZxTmlmd3gxd1Vm?=
 =?utf-8?B?Nlg3cjU1OWpFT1BLK2tPU1R0bWxkTUMwQjR0RUJmU2VzQXVsVktHU3hOWk1z?=
 =?utf-8?B?NjZ0bUE5aWpvYjlCQ2ZlVkplQ3BNQWxocVM2R01QRkh3YVZTSE1GWXRZbHVU?=
 =?utf-8?B?eHJOZDhxK1IvTmVmRk5hVnNtMkhxbDFBOUpNU2tzbTZJOExSYXpES2QyUThr?=
 =?utf-8?B?RUVsT002Z1Rldlpremg1Snp2RHF0ZGdaRjI5ODd1WFBRMEpNancxN04wWnVE?=
 =?utf-8?B?a3BxQmlUa1VocEo0bkFla2FBeTRGMHBuYmJVNXhvTVU3NjNRSFQ2ZkVnTy9m?=
 =?utf-8?B?TDBYaG5sMUZVWHVSamVBdytqMDhXemJKTEZMa25NTDlWRlBJdGsxM3JtUGxC?=
 =?utf-8?B?UGVCM0hNL3RuS1NlUndrVFM2Snduc3lrb2kvMGtDaUtLSUxHNHVNOVJ4WDVq?=
 =?utf-8?B?V3JiZVJ0VnlkUTF3RDZoQ3BjbVR5RkNaWHNLUVR2ZFViUFowYm5wMzNSYU9I?=
 =?utf-8?Q?QPeDBxKTJ+DpI3eYYikWkxvMHfD+IRmFvv6kslOzAaE/o?=
X-MS-Exchange-AntiSpam-MessageData-1: jcpFNCdxujw4NQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 243f4ead-fe33-4b53-b105-08df3e53c0f1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 11:22:35.2780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zsDV4x/mDc5Y3QIYh5TeqkBYWzRWjwx5w1ZTZbNg6R9TZvfmj509XInsyg/EqhijIF9yFFCEVBqP+TUgMUA/+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4456


On 09/11/2026 09:49, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 6.12.117 release.
>> There are 1536 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> I see build problems in -cip testing:
> 
> arch/arm/mach-imx/pm-imx6.c: In function 'imx6q_suspend_init':
> 618
> 16:02:42
> arch/arm/mach-imx/pm-imx6.c:589:17: error: implicit declaration of function 'cfi_get_func_hash' [-Wimplicit-function-declaration]
> 619
> 16:02:42
>   589 |                 cfi_get_func_hash((void *)((uintptr_t)&imx6_suspend & ~1UL));
> 620
> 16:02:42
>       |                 ^~~~~~~~~~~~~~~~~
> 621

I am observing the same build issue with this update.

Jon

-- 
nvpublic

