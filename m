Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8D0136A
	for <patches@lists.linux.dev>; Thu,  8 May 2025 12:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746706903; cv=fail; b=AcM5bkT9oMYvfxVLMGaaUCU/L/YI8EqsrLzBQD+ABM0uu+woAvDawR/wosDo85YOYixW8e+oIwTNv8fOLb5U4WL2PGCgac5cbc1v5wXGaRX1C/GRKyUePeiOhte0KxE2/59kjXbTbiodIGw8sfDLHwYAG2YVhR0+S/Hw+tzUMH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746706903; c=relaxed/simple;
	bh=ZH3ZhaAQ5QRZpwwnfrRr4vVAvUfW7JVutxeH4R1Km/U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ge20pAs0Pi+hZQFlpPoPaTHk7e/qodNvyUKK4oA7u0Cbd7CS96WTHCiZAJ3rauv1Ts2pUmya8kF+KvvxmqSkk/Gm9OCIqomq7fY1pPD+iyXMKf6sN241q3FwxzKIKZgtzQaudakhpwxacpsyY7K+KT+FdjIqKFqkNWa6XeZDNBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wr3QonHA; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wr3QonHA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mfk7MAbA1ID5IL7XU9keEFAWNBZCkTKPYNKQMTt/SsQS5jt/VBAj53FEwSvNoKsBR5G7J2YVSjR77psILdaY8nsnDTII1OXRuCWmb5djJPaqvw7eI5b5/NVGnG3mfBv+Ee+OzJx+YTDL0SP4APT/R1uiLytiUrymm7zWAnEQ9+8seYhQNrB1D82OW+gvlsn2NJ3DNa4vqAPk1Kr+S/ln8VchWmoDCpYY9vruA7f1snd0vyaFmOXL7blNInRzWWSpboFGZNjRw2eKgJrRr4nZqqyVjknfv0k6q8iGSZE9xCoSiRuzjSy1S9SpG6HRmvSbHAgj3jp+JzecBjm/Q5D2ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pp14etD8rlGNWx0qnC7wQ+Lxi1miN9iDvkmNCzx/Gek=;
 b=Ty2hYmtq/7YY+edI62yPd2yg8itKjvGpqd7BZ69udFSfYrR4DazEO4j4Zh64uWDnP+T9KHuCCOln6AsocKuyhrZV856eY5yak9srklGny3PSjrTSAhNWDMi4D8rmWsus1Ix20a5CAsgRIlKJylRIClld8G51fMUIaQzP0ykAQDFii6dxCgAb7gUbjSpmOwbpM5kOrGxnemYl0rCapV0o1LDZt7Eqs79mC+ppcIqU+Z+mmp+PmDIsJh8tJYRaFNJadGJSAzKWz78aOPynl5YTiyn4G//MLT7Be8FCxtMBo8EkbsCpJUgtT2GHRYB8neV5RWis5EHGbacgG8H78VPY6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pp14etD8rlGNWx0qnC7wQ+Lxi1miN9iDvkmNCzx/Gek=;
 b=Wr3QonHAWTDqTvq6dA3aOhf+AXzAKM1wYm+NDTw7VM/WmulPzbTcLBB13/Wjeye/csNlvy91Fs7+C4TP4rLayHL1Fs+jPXbvXyd/uVBLQ42PPGPWA9IQQLrwMUPFJqpMZ1ltGvU22NCwFyRjkmlFlupy2jSNSRjuS3tQ1IvpZUVO/dUuB8rKN2qvDhSTiV/2yDfpgyrMgmc+XCfQzcAPgS/q58e2c/nLb6DrAb2RiHY5BnBgMpAalLsjB3hIjMtLoxHBvHqYbtIaDpehr8Tgdo8kqJvps1u0FGsviowbcoFxz7w71c84vyWG0rFpS5rGHxSCVCZmZd447SHbVr91Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by IA0PR12MB8373.namprd12.prod.outlook.com (2603:10b6:208:40d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Thu, 8 May
 2025 12:21:37 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 12:21:37 +0000
Message-ID: <7fdfbbf7-cc9e-4a3c-a41b-c0fe161dd8f4@nvidia.com>
Date: Thu, 8 May 2025 13:21:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250507183806.987408728@linuxfoundation.org>
 <864a7a10-ed68-4507-a67c-60344c57753a@rnnvmail203.nvidia.com>
 <2a83d6a6-9e80-4c78-94a6-5dedd3326367@nvidia.com>
 <55d3cdaf-539f-4d5b-8bf1-a2c5f917e81d@nvidia.com>
 <2025050819-acquaint-guidable-5e97@gregkh>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2025050819-acquaint-guidable-5e97@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0030.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::10) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|IA0PR12MB8373:EE_
X-MS-Office365-Filtering-Correlation-Id: b7549724-a55e-41b2-c05f-08dd8e2ae10f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHpjVW56RG10SWJkRHlYQjN3eEMyTHUzeVEyMW1iWVZScFBGTUsrVzQ1c2JE?=
 =?utf-8?B?a3NoeFcwak10Y2F6eHdtRHBTeVo4UlBtT2R4eU5lQVFVTFZBMEUyVWMzKytn?=
 =?utf-8?B?eDRJSVRnaWpDVFowLzR5c0ptOC84WEYrQ3NhLzg3eDJyUXV4NWU2QnNrTnAy?=
 =?utf-8?B?QS9jWHYyS2FHcytuWlVBT1R2dFlWWUFPY2I4U1F5S05VS2VGZFkrSWRxMlpW?=
 =?utf-8?B?dVlYL3BCN1J4a0NXL0JDU2Z1b251cy9jTk5xYjJtWndSOEdvK1hmR1RZeDZi?=
 =?utf-8?B?bzRYaHltaE5ISGVNbit6ZnZ4c0Y5WEVEalVGR3NpUXRoN1BDSnhWZDdLbDBq?=
 =?utf-8?B?RmxBbE9QdFRHc1gxOXZWU1lrVFNNcW9oQm1oa2NIU2VkTWFHS3dWbGVnTUx1?=
 =?utf-8?B?TVJvWDF1WkZNWENLQnMrcVk4ZlVxS3RxTjRsSUtQTXVzNFJ5TFB6NjR4Z0Fl?=
 =?utf-8?B?M0ovNkwzTnd3MUxwTS8vb1huV2pScHllam15Z3dCK2hlWFBXR0ZNZFA2bmti?=
 =?utf-8?B?SGR5d0tUSWtuMTRpZTI2MlVGNUlHd2Qzd3VyWGVjZHN6T0FhNG5ncGRDYUxu?=
 =?utf-8?B?ZEgyVUEzV0t3bldzMXNObWpteG9NQ0hXUmFSTUtHK243SldsRkNGTEhlVGkz?=
 =?utf-8?B?VHBaK25oTE92TGJydlVlUjVYZzBlSm5BSjcyaHFBTmtBbzJodXIzQytTNExz?=
 =?utf-8?B?MjgzdW9KNTZILzh3dzQzK3gvUjRTeHR2bisrSHlEeUltWFdKNXluZmNMa2c4?=
 =?utf-8?B?NndCcGl4MHJzQjFhbEhZTS9YdVJneVpydzlDeTNtS3dBaFRQWDk4T293cFNi?=
 =?utf-8?B?WWhhMEd6SnQ3N29EUjNXOE5laERmeUNRWEhPTjkxUkR5SmtSUXgxcjdUelRw?=
 =?utf-8?B?WXRFYkZ4VUs4NTBidjcwV3pTMk0ya2ZuUEljZkdtWHU5M05TSTdEcldyeEs4?=
 =?utf-8?B?Ty9CUjJWVXhKbHptZVlMRVRWbjJyV2NCQ1IrYzE2dkQ1OUswYmNjUTJrVWQ0?=
 =?utf-8?B?aHU4d2ptRTlidVlFLzRKdjVTeW1vNHZpTnFyRW5TaitqUEFlbjk5OGQwR1ho?=
 =?utf-8?B?Z0NxcVRUbmp4VU0wY2pSUEdPeVV5clRNZEozWTg1SG53TGhxZGRhSGpwQm8z?=
 =?utf-8?B?Qk9vdTBrTXBsRFdEVjk0ejkxK1F3YVgwQklXODhnYk1OeUxMSUdENEhvR3Rk?=
 =?utf-8?B?eWhvOW1WRUd1VUtabVFjZklaL3cvaTFScllkVm1oaGR2NXdIaW9Ca0llSDFZ?=
 =?utf-8?B?WFdwZ0k4MVdQbTNzUkJldzQ3SHBWTGlOVHJvYTdOZzBpaE9aQWZWcXljWGlK?=
 =?utf-8?B?bG9neG1YOURrcHlQRTBNQWFoSEh4SHNTKzQ1TjZkSjhiR3BRbTBTS0gydzMr?=
 =?utf-8?B?VVNsdkJPRHFYLzZkK2xlYTBwazNiM0JBcHJEVjJYUERUTDY0MVp5Q3REaWY1?=
 =?utf-8?B?c3hNN2dIako2clFTQ3hXandWZm04OE81NW83R2krak15eXYyRGpzb3JRbUFa?=
 =?utf-8?B?dURKTHRZb05VaGJBY2dMbkdSem9TK0pTVE1QWkhkZ1E2M2dLa0JLWllhb21n?=
 =?utf-8?B?RU1VcmZaRWtrY3lVU0RaRkpzdkMrUkpERnpwdXZ5Wk02bVpVSENYWjUyYlRY?=
 =?utf-8?B?VEJkUXhCNTRMMHoyMHZqWmZrbDdNaHpoODRZUGpMOGcvbHd4VzJmWmJkdDgy?=
 =?utf-8?B?YnFUR2FjTnFpQ0FIK0FWa2cwTnFxZHl5eGNaM01XSHVBVnhicHZXRTlDUDVv?=
 =?utf-8?B?dW5vUGFtMlh2K0VBNjYyVi9IbjFWYUU5RzRJM09PdE9MWWo1TGVETnpxdFds?=
 =?utf-8?B?WFUzWlZnWGxObit3blhET2VOZDNlQ3FjYWpYSWVvZm1wZDRzOURYQVMzUG41?=
 =?utf-8?B?N1kwUldQdXhoeFVndVFiaHlsMVFvTVF4WjRpMFU1cHE5emE5c2d4N0JubXZz?=
 =?utf-8?Q?Dhm10+UUfAg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0FoSDQrNmt4Y1c2aFhmNUdPZ2pmUlphRzdYd1dPdU0vcmJOT1dTendzWGJ3?=
 =?utf-8?B?TWR0VTNXSUw0dUx3bmlVM2hQVzdYUlBHbHVOckc1Sm1oUG1FUDdjYVlsSExL?=
 =?utf-8?B?UkV0dzA4QzJhV3hmbG1SVTFFcnQzbHF6b1loSVhMSUgvM2hlNGhJSk4wUzJz?=
 =?utf-8?B?TWxvRDd4eXZvTmd5Vy9KTHRLMlV2QVc2TEJYMXpvS1d1ZjN3amtNQWRwSTcw?=
 =?utf-8?B?Z1hjZW5sRC80dVhGWTc5VFhqMDNaSUlJclB3aUw2aWNiUkdCNkF3UE1FMXFT?=
 =?utf-8?B?YVRjcG11cGZaRGhuRDB3cDB0bi9PWEJCYlV6NnFuNlpMN0dMR0FRU0lJSDdh?=
 =?utf-8?B?bHJHUE1PekM5Rm9uMTFoREs2bnJZQUg5dkladHR1TVhkc0pRUzRodE9OTzdy?=
 =?utf-8?B?MzZKcC9YQU1qOVVaL2Q0U0RTMlMwQmFwanZDREJvL1pOdjNBUjFndGovWHVC?=
 =?utf-8?B?bGpPczhoMzhMY2s4c1BSMEFWdy83NUc0dmdlRlBFcHFXT256d243RFl5QlVD?=
 =?utf-8?B?VkZzZDcxTVlZaEVFZngxaXBTUk5zU2swWnNKZEYvell5Mzh4d1RjRW5PSXR3?=
 =?utf-8?B?ZVdXemNKTnpod1NUVzZla1R6bVdJZEM5UU83US8vMmFDQTZjT0lqR1MwVVh6?=
 =?utf-8?B?S2llOVV3VHE5LzhLU0cvOXJmYk01WmcrOXJhRzZXMnJ2Q2tjdWtrb3dtcjFo?=
 =?utf-8?B?TGN3ZzFFcCtsVzFyT09mN0tuTllKWmxSd2hxbGZyMGFLOVBrTXVENlZmSUxi?=
 =?utf-8?B?dUFrT3BJMG5TcGhLY25CUnJyQktDN2RMbWsxVFB4d3h1U3hneWxMaUR0ZG03?=
 =?utf-8?B?TWpVQUc1b3N6b3hkL252Wk0yU0g5SklMOUxrUmhIckZUUXNmKzl2enpGRklI?=
 =?utf-8?B?eFc4RnpYaTIwUmd3VkZIbXI0aEdsYUtUU2FwQ21PZHJRcVN5SnlHZXE0ZFJR?=
 =?utf-8?B?aGNWajRMekNoSzJpUXZ4SDU1R2wrTHJtdEFVVWhXbktOTHhadDcrN2c0Ynlj?=
 =?utf-8?B?Ni9aZmVFQnlhcjFJWFlJeGlIQTNTYnVVTXhOT0MzbnNFMDJKakhrZkNYZFUx?=
 =?utf-8?B?a2s4YnQwcjVpTmppN2p3VEs2dnp4QWw1TitQV0ZKMEFxc3crNTY2dUZoQnhZ?=
 =?utf-8?B?VmJKSUp4ZGt6bHNDUW92QWRPQjVIcEdDNnZTQTZEN2lUdlV0Uy9GNWJGR3NJ?=
 =?utf-8?B?bUgvVVN1L0hZeFQ0T0laUmJEYzZKZ1RWOURHTlMrVXBsdGdtbFdmREZSdXkv?=
 =?utf-8?B?a1RhV2x0UlZ2a1Bxd1lleHBoZmtCZ1V2ZGYyZVFoeFdYS0dlSWlPWVpZeERL?=
 =?utf-8?B?cW9HUy91UUQwUkY2S1dxUjRMVDBZbnpQS1d0U1NqRXN3eUVvWmM0Y2RkUDlz?=
 =?utf-8?B?VFdGdVJUZUMwa2tiL2FwVFRlUHZrQ1h5K21TUGJDQmFXemRSMzNpdk8xSExF?=
 =?utf-8?B?aTh3cUpFQjVyY0VyYVJOOXY1ZW80RUNvN0JDandGbU5FZXhqRHpzY1ZhQjRk?=
 =?utf-8?B?d3dJTGR3UkV1SmZEM0ozZWtIakppNzJUaUxkZGx6MkhuRGg1ZmZJaHMzbXlN?=
 =?utf-8?B?ZEhKUFU3czN3ZVE3UmwvbmZML1dyK2JPRGh6ZVRMT2VNdmlLVmFxb2dkcmJm?=
 =?utf-8?B?eUpiS05KbmcyL1JsMHBxWWlaTkUrOU1LcSs2Q0g4bkFSQnh2UENqaDFXd0Fw?=
 =?utf-8?B?OW9vdnV0dkhtVEpCVFdHdkVDZk8vWVVRcjVlTGdoWkVqRjltY2hYWU9ENmFV?=
 =?utf-8?B?ekFOempTUENqMkR2eTFaRlAzRGFNV1FNRDR3UGkwVkJ3SkNubHNlT2w2QkM4?=
 =?utf-8?B?c3RSSkVpQlh6bmp3blRQenZuSVVLY3hPMjY3RnZJdFlzTjY1Z1NOcjcwSmY4?=
 =?utf-8?B?NlU2WUZ0Nzk5SjlPbjl6dGFXRGhKSTVFY01TbVpvUkRhd3VoM2lEdHQ4cVdn?=
 =?utf-8?B?OEEzWkdmRXBrWmx0bXNJMk1xRWoyMjRqcUpZWVhEZFh6Uk5vSDZWYzJMZVNm?=
 =?utf-8?B?Z0ZwY0d4c0w1TWdvdVJ3WVp4ZzFIdHRuZ0JVdFlwWnN6UVo0cElGUTl3WEZa?=
 =?utf-8?B?RkdMMUNUUFFSM2dXdXJZYWtPOHdIVEdRT3RpVzJxQndxTWRySGo5YkJFVjh4?=
 =?utf-8?B?RzNtSDNxRmxiMExCZ2hUbEZ5VVYvQWZxY3Z5RkttNXdkd0hLRU92bGRGVmxQ?=
 =?utf-8?B?Z0E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7549724-a55e-41b2-c05f-08dd8e2ae10f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 12:21:37.5616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wex4fOZz4PHZo7ljMvGY+njARIpjUOd4e99GZ00nuMcL/x8j1Zgo/l0eXhTtTC/b2AmwKeeQ5mCQFt4hTyAV2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8373


On 08/05/2025 12:24, Greg Kroah-Hartman wrote:
> On Thu, May 08, 2025 at 10:52:59AM +0100, Jon Hunter wrote:
>>
>> On 08/05/2025 10:48, Jon Hunter wrote:
>>> Hi Greg,
>>>
>>> On 08/05/2025 10:45, Jon Hunter wrote:
>>>> On Wed, 07 May 2025 20:38:35 +0200, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 6.1.138 release.
>>>>> There are 97 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>>      https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/
>>>>> patch-6.1.138-rc1.gz
>>>>> or in the git tree and branch at:
>>>>>      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
>>>>> stable-rc.git linux-6.1.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>> Failures detected for Tegra ...
>>>>
>>>> Test results for stable-v6.1:
>>>>       10 builds:    10 pass, 0 fail
>>>>       28 boots:    28 pass, 0 fail
>>>>       115 tests:    109 pass, 6 fail
>>>>
>>>> Linux version:    6.1.138-rc1-gca7b19b902b8
>>>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>>>                   tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>>>>                   tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>>>>                   tegra210-p2371-2180, tegra210-p3450-0000,
>>>>                   tegra30-cardhu-a04
>>>>
>>>> Test failures:    tegra186-p2771-0000: cpu-hotplug
>>>>                   tegra194-p2972-0000: pm-system-suspend.sh
>>>>                   tegra210-p2371-2180: cpu-hotplug
>>>>                   tegra210-p3450-0000: cpu-hotplug
>>>
>>>
>>> I am seeing some crashes like the following ...
>>>
>>> [  212.540298] Unable to handle kernel NULL pointer dereference at
>>> virtual address 0000000000000000
>>> [  212.549130] Mem abort info:
>>> [  212.552008]   ESR = 0x0000000096000004
>>> [  212.555822]   EC = 0x25: DABT (current EL), IL = 32 bits
>>> [  212.561151]   SET = 0, FnV = 0
>>> [  212.564213]   EA = 0, S1PTW = 0
>>> [  212.567361]   FSC = 0x04: level 0 translation fault
>>> [  212.572246] Data abort info:
>>> [  212.575137]   ISV = 0, ISS = 0x00000004
>>> [  212.578980]   CM = 0, WnR = 0
>>> [  212.581945] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000103824000
>>> [  212.588394] [0000000000000000] pgd=0000000000000000,
>>> p4d=0000000000000000
>>> [  212.595199] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
>>> [  212.601465] Modules linked in: snd_soc_tegra210_mixer
>>> snd_soc_tegra210_ope snd_soc_tegra186_asrc snd_soc_tegra210_adx
>>> snd_soc_tegra210_amx snd_soc_tegra210_mvc snd_soc_tegra210_sfc
>>> snd_soc_tegra210_admaif snd_soc_tegra186_dspk snd_soc_tegra210_dmic
>>> snd_soc_tegra_pcm snd_soc_tegra210_i2s tegra_drm drm_dp_aux_bus cec
>>> drm_display_helper drm_kms_helper snd_soc_tegra210_ahub tegra210_adma
>>> drm snd_soc_tegra_audio_graph_card snd_soc_audio_graph_card crct10dif_ce
>>> snd_soc_simple_card_utils at24 tegra_bpmp_thermal tegra_aconnect
>>> snd_hda_codec_hdmi snd_hda_tegra snd_hda_codec snd_hda_core tegra_xudc
>>> host1x ina3221 ip_tables x_tables ipv6
>>> [  212.657003] CPU: 0 PID: 44 Comm: kworker/0:1 Tainted: G
>>> S                 6.1.138-rc1-gca7b19b902b8 #1
>>> [  212.666306] Hardware name: NVIDIA Jetson TX2 Developer Kit (DT)
>>> [  212.672221] Workqueue: events work_for_cpu_fn
>>> [  212.676588] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS
>>> BTYPE=--)
>>> [  212.683546] pc : percpu_ref_put_many.constprop.0+0x18/0xe0
>>> [  212.689036] lr : percpu_ref_put_many.constprop.0+0x18/0xe0
>>> [  212.694520] sp : ffff80000a5fbc70
>>> [  212.697832] x29: ffff80000a5fbc70 x28: ffff800009ba3750 x27:
>>> 0000000000000000
>>> [  212.704970] x26: 0000000000000001 x25: 0000000000000028 x24:
>>> 0000000000000000
>>> [  212.712105] x23: ffff8001eb1a1000 x22: 0000000000000001 x21:
>>> 0000000000000000
>>> [  212.719240] x20: 0000000000000000 x19: 0000000000000000 x18:
>>> ffffffffffffffff
>>> [  212.726376] x17: 00000000000000a1 x16: 0000000000000001 x15:
>>> fffffc0002017800
>>> [  212.733510] x14: 00000000fffffffe x13: dead000000000100 x12:
>>> dead000000000122
>>> [  212.740645] x11: 0000000000000001 x10: 00000000f0000080 x9 :
>>> 0000000000000000
>>> [  212.747780] x8 : ffff80000a5fbc98 x7 : 00000000ffffffff x6 :
>>> ffff80000a19c410
>>> [  212.754914] x5 : ffff0001f4d44750 x4 : 0000000000000000 x3 :
>>> 0000000000000000
>>> [  212.762048] x2 : ffff8001eb1a1000 x1 : ffff000080a48ec0 x0 :
>>> 0000000000000001
>>> [  212.769184] Call trace:
>>> [  212.771628]  percpu_ref_put_many.constprop.0+0x18/0xe0
>>> [  212.776769]  memcg_hotplug_cpu_dead+0x60/0x90
>>> [  212.781127]  cpuhp_invoke_callback+0x118/0x230
>>> [  212.785574]  _cpu_down+0x180/0x3b0
>>> [  212.788981]  __cpu_down_maps_locked+0x18/0x30
>>> [  212.793339]  work_for_cpu_fn+0x1c/0x30
>>> [  212.797086]  process_one_work+0x1cc/0x320
>>> [  212.801097]  worker_thread+0x2c8/0x450
>>> [  212.804846]  kthread+0x10c/0x110
>>> [  212.808075]  ret_from_fork+0x10/0x20
>>> [  212.811657] Code: 910003fd f9000bf3 aa0003f3 97f9c873 (f9400260)
>>> [  212.817745] ---[ end trace 0000000000000000 ]---
>>>
>>> I will kick off a bisect now.
>>
>>
>> I wonder if it is this old chestnut again ...
>>
>> Shakeel Butt <shakeel.butt@linux.dev>
>>      memcg: drain obj stock on cpu hotplug teardown
>>
>> I will try that first.
> 
> Argh, that one keeps slipping back in.  I'll go drop it from here, and
> 6.6.y as I don't see what would have fixed it from before.

Thanks! Reverting that does fix it.

Jon

-- 
nvpublic

