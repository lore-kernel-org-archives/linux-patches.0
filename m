Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656051BBBE5
	for <patches@lists.linux.dev>; Thu, 10 Oct 2024 10:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728556852; cv=fail; b=BtxFCgGhGlAJfsHM5LFWP0wjUIcPgKyweHFCySDt9iJ7HQBJqotpBboPo3i9oJUz9mhNsVuqlnWcOkZS7ihz/awqkxIrFjInbjxSVDMHBEHVKvTO7otDQJEkCLQdTpuOQB/m+i/8Sxslt46O+Ft4u03uI6fS/EbSmyHLaFuYXdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728556852; c=relaxed/simple;
	bh=fup/uH5L/m65+xYIkDfqXr3K1CUNqV61cpf14gyOzcg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D/GyD5I2nVb9foog6tNCh8xWoT98Fg1ONHWj4eohu5S5VcK6rPe1xdpBv9afZSG3arqHC+IMgA4KTeY4c3QDNy9VIChifD0ed7KfvSuu6NPEywtInq6NTZ2ao6HwaqGPgOmWF0uUJ0XPf8zovL6GouPfPGgn0sY+JPL/28ZR8IY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GX5kUoT0; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GX5kUoT0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i+hqcYdJ+sS6LdSRasdrQ7D5BiLXlXzwBu47Oa5tImhwuk/o3MfrTFGyLnh5/droBABtNSYyDz8f4U0VC0O4uQFpmYBnRdEspAQxZDWnzbJGbtO3yJ1QR5Af9W3x5xA18AUHPr9hV+v3Ey/YafBgkrEhOWg0GA5SYInnbOefWczNz4laP+ZP9G5n4UtoHVJNlY8++QbyCqEsdSNlf9ztBvjrvl0Ri7ePxPfyTNFHeNweLtroEwD5LhY3lk6jCFyC0sgT7H2CBtWa2itfmSEEkSNmqU8t4YSzHZFT2GOSVC6Kt0rDXqXp5xZHwhKD9GHvtNqYTs7cCQAP3kc4Rb2XKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEqUttHxMCtyGB8bIzNaaDG1qRNay5lYLuJZa1cF5PY=;
 b=w1agm5BNZIBFw27L1DteqS2DuEync6QE4UNm8SnWbHJ+4LOZYErV4Qj/VpoGoWI9z49Tg/sSGUqIf6rFBZZrBPgFqILp6WnCL/VuaHxrYQsBQIX3ebi0HSVUWCxEO6eyFlNAKDE3PW9pkwgYYEC4eem4GBwahLFxCXD8xOwbd2FoZEgjxF3Z+LOMhRGQJ1fAbLVKlmHpaRVMH8Sm1DFl3Vsgb4wD7rIbacop6ihfJjmfqQCVKaG4u48ofJNF0qalY9GjOioZs/0/C1d9lmCafmjfsjSkaFtpBU+foN/da0VWXxNAGLHo8Ei4X6/2SrHqj9lDrSy0cUaeXyecongrdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEqUttHxMCtyGB8bIzNaaDG1qRNay5lYLuJZa1cF5PY=;
 b=GX5kUoT0f6gt47sroYArmkzDWn1NOGd+ZCReU/DCyn+R4a/8wwX6fCZHgBnD/8pqVf2UNdIoStecjSeQbGkDnPJO281xTyrgOp9l9OUc0XKoAp1bSmNoE7HRoZlYiippniE791DBwzbK6oULQRWjsJ32KN9pgbekuIV1Xhv2Tv5SaK7+AtEa+TG12r5R56qkijME5wsPBK70/1f9FaaPqd08bPr8XLH+f5h9unFdpiF6EHvP0x6T76fQ/NWPHsBWvx5lTSV8Ms//A6aPBOAIxlUSiRzsQEFmc6zoze0se/uCRrsB4G/RIN9M/qrOREhQnFZ9/Ch2VVloKO/YyBbrGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DS0PR12MB8072.namprd12.prod.outlook.com (2603:10b6:8:dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Thu, 10 Oct
 2024 10:40:48 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 10:40:47 +0000
Message-ID: <125a37ba-095e-4149-b65d-f318fc45a085@nvidia.com>
Date: Thu, 10 Oct 2024 11:40:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241008115648.280954295@linuxfoundation.org>
 <50b64beb-ba52-4238-a916-33f825c751d9@rnnvmail201.nvidia.com>
 <Zwb8t7ngmnVYV9_m@sashalap>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <Zwb8t7ngmnVYV9_m@sashalap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0060.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::20) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DS0PR12MB8072:EE_
X-MS-Office365-Filtering-Correlation-Id: 05f1a1bf-8b7a-4da2-cf72-08dce9180058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmplRWdSbGlBcXphcFRUTUZ1ZXc3TUZ6S3RXamZ3QVJsMm5DbHE5cC9PbGRN?=
 =?utf-8?B?QUtTV0drTXFQWTFTcFdab1hSMURGSm9rZWo5T1ZKcFF5ZEtKQy9hUERld0g0?=
 =?utf-8?B?TzkxdmcraGV4TEx6NGY4eklTY0ZlSHE5aTNCOEVuNEtwQ3VMWFlkbVRyWThZ?=
 =?utf-8?B?ck9rdVowYVdMaUM1bU9kSVVuL2tJSDUwTzJSRVVzc2JVcFVuejR5aVdyTmxT?=
 =?utf-8?B?YlI0YWxvQWRoNXRUUTZmTS9HTGVjbzRNM2ZPYi8zaUcrU0wvYkJTNFkyaVhm?=
 =?utf-8?B?dmJhb0lzekhEUnhxa1UvMHh1Tk1NL0dUVFVNWFRxYTE5SktrUHFUTVprRnN4?=
 =?utf-8?B?T3B6R25UOVRmRkNXL0wybjgraUZGakRGKzE0eHNTTnE1b2Y5ajRqdFpiSHlh?=
 =?utf-8?B?SE80b0lQZ2JUVGp2NFBjUXVFUW9lNjAxWUpKWG1hZ3JNajdhSUlXMkNibmZq?=
 =?utf-8?B?bENUTlVRZGVtN2UvT29IRCtMVmF6Ni9tVDl6ekE4TlFXVHFBdzFUeExoMVM5?=
 =?utf-8?B?bkNDelF3R0JZbUN2K1EvdU5pamY2ekRqWmcyc1hOV1RiVjYxNll2QVJrMUlm?=
 =?utf-8?B?L2ZHVVVJdmVQbGFWSndSa1dTUkVqL2c5NC9WZjJuRndPQ0x0WWxGY3BWV1ZT?=
 =?utf-8?B?TUc1QnppOVdvby96VE9CMmxjTkpNMVAvbkErTnhBa3cwOU1GRU9QVSs5c1Ax?=
 =?utf-8?B?dU11TUlzbWJUYUduS2ZuVDAyU2pvRXgrZGZFVlVXMjBuZEtWOUZpTVZ0QmJD?=
 =?utf-8?B?NG5UbkIwTFJoZyttckp1OGE5TjEyeFpZMnFIVDlHNC9rZUtaTm50ak1UVTdO?=
 =?utf-8?B?WlNWc24zTkVud1ZMNEs3MjIreldVUFpXYjYrZnlweE9GbzYwODE2VTlLNWxS?=
 =?utf-8?B?QXp1RnJ6Zk9YZVh3R2RYT3pmeXFVeFNTNlVwWjVjZStZU2drRHFzK1Q5bjRN?=
 =?utf-8?B?cjcvdlZXZWhCMmtyYnBDalRnZUtSeG5nV0NEMnZFa1V2RVJBd2ZUT1BLanZH?=
 =?utf-8?B?R0QvcTdOb2J2alVPNmFEbDZhSm9IdmN1SFltN2I2K1lIazl4VlY3Ykh1ODFn?=
 =?utf-8?B?QmhEajVtR1VqMXloYllnbDlVVG4xc2xXM0xXeW01cDBQMlZ5N05PdStxcC9E?=
 =?utf-8?B?eHNncUtYbnRweVR5aUtzS2E1c2dUS0tjMVhXc1ZkTmpVU3lwSE1GQ1dnQXFv?=
 =?utf-8?B?Tms2ZExuUDExdFJLcmc1Y24xc3lnT2t1S0Y2RmZHaHkxZzNwSnloRUwzL0dC?=
 =?utf-8?B?REtKRWM2Q1pETmFYUEcxVzVYOS9WMTlnMzFmaGtSSDJpUUxNQTV2cFpkTUtt?=
 =?utf-8?B?UzZ4Y3FFK0k4M1h2NGJ0UVF2WVpOZ3NabW5tTmo0L0ZFUFltRjJDallHakUw?=
 =?utf-8?B?ZmNvMTRiL2tsMmZmaDJRODRoUC9tOHhmY25nUEZGRm1FRStMdGZZeXNmb096?=
 =?utf-8?B?YjR2VXRFUkEvc3dGd01kOWxNS0J4dFNiM1hZakJmcGlVT3dKQmROaGdrVWdQ?=
 =?utf-8?B?VEI2bi9jMnJDdzludmlqamxVZzVDeml3bmpWaUZuTVF1VU5kWUltNGlNQWdN?=
 =?utf-8?B?ZkpVOFpGWFArRlVTRHRVN2N6cVU4NG1xd1Y2RUpUVWV3MnYydS95ejNBL0ty?=
 =?utf-8?B?OXl1YlhURlJrNW1MVkY2Uzl2cnFnUFRONzVRS0Iya0FROTYzYlYyVG80MFM5?=
 =?utf-8?B?c1lBbmpxbU9EYnJBbGk2RWk0VlAwUDFjTVZ4N2dDdFN3WFlJMWkycDJBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1BPQmQ4MzNyR1RSTDVNVnkvS3EyTjgrU1FzeEZxZkVtZHVzSFpZUmdVeHFW?=
 =?utf-8?B?anZzcmZTVGN5RmZYRmRkMTFoWW1hVG9sSURmNHhEMnZtOUVJLzhqai9Ta0dz?=
 =?utf-8?B?Tkd3TUlac3EvTXVscUpleVU2cDFOZFJqZXFycXNXV0VBR04yVEY0eWJkUWpD?=
 =?utf-8?B?dXZPZUltaXFLQWlJUHo0M2U5ZXUwRktOcWFjNlIzbmltcWdYSHNUK0UrLzJq?=
 =?utf-8?B?U3NSUlAwRHVmQ3d6QUpWdkcvUFlaa1ZReWQxSWk2NCswbHNuZEIzbm5FMkRk?=
 =?utf-8?B?VGoxcUExenVLcFpJRkVkRWpjL3prZTdKYStkMWdPYkw3S2xpWUUxcnpETzFo?=
 =?utf-8?B?dW9lZlN1Z01wMmdSSi9Sc0xYRUZKU1J5eWxnTGlPeElxTEwzbGUwaUt2SVFv?=
 =?utf-8?B?eDZWVGo3dW9wWE14MUZzZ2dTeG9QQWh0VWM5N2tVUjdadGluZzZaZm1FU2lQ?=
 =?utf-8?B?NjdHYVpCYTRZVU56Rlc4OGpPSTFMRldibkxMSmRzbTJYRTFuV2poV00wU014?=
 =?utf-8?B?YzRNRGJpRG1uSkVpVUJFc3hTeEJxQy9aQjF5ME05b2JkMkszVFBWTUxlcFFM?=
 =?utf-8?B?eFEya0NFREhZdU5vaXRGU0I1aUtNNVQxN3hVVFU2SEMrL1pSSXZSRy9ldXR4?=
 =?utf-8?B?cklSMFphbXRtTWZPaGtMd1pHS09Ja3o0MWFDZE1LcXZEaWdCZGRTVWljQnB6?=
 =?utf-8?B?ZmZnSnpzcS9DQmREcCtHMDRnTDVEOG9VMmNqczNENTBCM2V3YUtSZ1dmWTlV?=
 =?utf-8?B?VEg5eHlRSEVnZjNVOWU5OUFZTTNuTWZseG80SU9Oc1JHWDc0aVV4UUNLOTNl?=
 =?utf-8?B?L05idklHTjdqd28rYzFVMjhkbzEyNGxOVGh4NkdvSEJDVGZmNEFxL2htUE9I?=
 =?utf-8?B?Szg1a1I1TWJiNkg5VGVFbVV4elJwbjY5Um1WTWFrV0xPNzMwQWJmcTduLzU1?=
 =?utf-8?B?OVY5cFVkZnBYUXNiTVNQQklVSG5mTTFKQnA0RmNSaDBTc1Fqc2p3NG9kMFFO?=
 =?utf-8?B?YVRzcndYbE5aME90WUUzMzl1NWtQcDZISHB2VnNSNS8xTElPNTY5dGNTNWd4?=
 =?utf-8?B?ZXh4Yk93dnJwNy9mQm8xeGg2UjF4Q2VLVlNmRVJDc1JZSDQ0eUxxN3M2aDJK?=
 =?utf-8?B?SHFTaExmbDJiTy9POHJoR1gzNUxWY1RuR3N3UE9iSEhhN2JqUEc4dlA4dDhs?=
 =?utf-8?B?NC9adHVKYzliTm1IQ3gvREU2ekVOSnZpeGVoditLZUxGYm1FM29pWHZoV0Nq?=
 =?utf-8?B?anZvUFJPWVhwUC85RmFmeG9kMUw4WnpvdlRVcUV1cEJvR2wzRm9LYjlKb25a?=
 =?utf-8?B?L0JMblhkd1F0Zk9WVk9NQWhwd1M2TERhODBDdy9tbDdqTDRabmV5SENUQito?=
 =?utf-8?B?T2FqeElWbmwrRkt2S2dTYjJ2RExKNm1QQ1ZkTDBsUnREMGNVZ05Wb3ZZMFRy?=
 =?utf-8?B?ci9GVUk4WnRJZkVDWm1ld29FMG93MzJ5UnZyNUxUSUJxNnkwVUdET1JveDl3?=
 =?utf-8?B?NXhCMTJ0blU5WS9uVXI0RldwZ3huS3ZYcTNLU3ZtTnFlSVloZi96S3d6RFZx?=
 =?utf-8?B?V2VVemRBbkRyNWFZcVZFYXhHK0FqajVCUGx6aFI0VXMzK1E1SkduTDNyZ2la?=
 =?utf-8?B?bmgxRVF3YXBkUHdlSk9VQ2FaVi9vWFJUTWNDR29HVlU0UVNvb3FWMVlsSUJX?=
 =?utf-8?B?WEhKbXpkSE96dmMzVEl2QWlsNktMZ0VjeDhYcUZJdjVFc3krcDdodTllRzhu?=
 =?utf-8?B?b0pOemJnMVBmNjZPTHhSd2tLRnBIakRseUFXRTN3Wmo3c3JhNWJnbE13MzU3?=
 =?utf-8?B?THV3dWpzd0hlT2dIL3RCUjRpcFVDN2dGd0FKZlBabElFMWhLNUlpWUFpc3lN?=
 =?utf-8?B?MHdodWN0ZXAwUy9vSEJzSDFIbVM5TmFpbzNzYUlmUkFJZ2x4T2d3YnUrWGx6?=
 =?utf-8?B?UFBKaVVrWHhISUEwVjk4N21BL0FEWUVvNld4YkJDMEpwZ0IrTW9QbndFQmtV?=
 =?utf-8?B?UmdlUlBxU3ovNkZ6VXVqQXY4Y3RoZmFDb2VaRlQvVkNQZXlaeHVUM2hpTGxP?=
 =?utf-8?B?cUVGRUVsSW9LcXBXRERMY1BKY29zbUMzZzIzcW9KSnpYa2NvRlJ2cVp5VW9J?=
 =?utf-8?Q?GMowssVT5NLuDd3waZZnr2njL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f1a1bf-8b7a-4da2-cf72-08dce9180058
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 10:40:47.6578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2UmxSJ/YZrcPNiLaiGT8QUToX2TqkZM573CTpKwKZmnkDeaLA3oXU0VhPPgCJgDxjvWOED9IdXkhO6m6DWrYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8072


On 09/10/2024 22:59, Sasha Levin wrote:
> On Wed, Oct 09, 2024 at 07:58:55AM -0700, Jon Hunter wrote:
>> On Tue, 08 Oct 2024 14:01:03 +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.10.14 release.
>>> There are 482 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.14-rc1.gz
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> All tests passing for Tegra ...
>>
>> Test results for stable-v6.10:
>>    10 builds:    10 pass, 0 fail
>>    26 boots:    26 pass, 0 fail
>>    116 tests:    116 pass, 0 fail
>>
>> Linux version:    6.10.14-rc1-gd44129966591
>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>                tegra20-ventana, tegra210-p2371-2180,
>>                tegra210-p3450-0000, tegra30-cardhu-a04
>>
>> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> 
> Did this one not fail on the same cgroup issue as 6.11? we had the
> offending commit in all trees.


I did not see any failure there. However, same tests are run and so it 
should have. I can run it again to double check.

Jon

-- 
nvpublic
