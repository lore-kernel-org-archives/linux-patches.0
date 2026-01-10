Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012025.outbound.protection.outlook.com [40.93.195.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F642D1936
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 12:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768049489; cv=fail; b=AYBKbo2vX796J598AQFUcqg5fMPV28rebzcU2cAkU1M0luoFnBPZlGtmvparcRy5TZfNtNW7QMKOdDWDQ/YvkbpWNUonFPW8BVrZzhTCWR5y2wpHO4xD2jgtoZahQB300f6hiO1wmzGf6AK+5TeV04bSUGbvAoM77JPnFCHwFWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768049489; c=relaxed/simple;
	bh=+EPI43ltAihM///NXjPBNU3JKJGiBBtV35YiTh0lcDE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FxZxik+Q1eeEQmKGb6KDMFLCEzVRdsEsKQLpzD/C3k22L6W2AQcfzMmbVTu32jjp526riCjYNc6gD0gKXiuJm/BWzeg9yN6cPrLkq/XXXap8et13V2LNUKEG5pBYfD/zdtUkrU+5jOZPsWx23yMBjFaY5k1/8/Wl1X/fSt/7llk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OCof3W1D; arc=fail smtp.client-ip=40.93.195.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OCof3W1D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hBieoCwUQJpyw6V2lVkEhxDF4Ymcl5mTFmegzpJFGMrURiv2uDqqvLoAcrgsuKKk0XVJBbe7X6uBSvaCw2ZABC3F8ZkgQGNRuXl8kLQoLvl7fnD1Ur58sMwI7yPD6Y9C9sADPpw/7aAIoE4SI5GpBB9fHrjQHxStKzpbbACL+vi+GWKhDvL6JVbRgZJ2GDiT8B/HlifoA0w+/n6Ou662m1IbX6OBGcvFaFKdC8A+BSrBfdiv6xBhDMgzKiL/NYz//HFATm+u7TxQV65X8c2ajKGugYSUOl4qiXYS7wQ0taBjJocWHEnbkorcpezX1GfzEXQXELgFzjvY6KWs2NX3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HX1S944pAt0MSbxT/o5sPj6LmnGOqO2AZxUv7Gdzu5Y=;
 b=au4IzJigqfmggpPkiDETsCWpweRQpg94LG9bbgF3MY/hwi5gOqMRnGhYGfbN6d4tZdnvAu9RnTaOpf88/tEL3m4vNvwAJI0SP+KIiNrDIO2Wy8bKcwEDPoIkfu2oAPq06s4EqgXC7r48Fah46E3fLRwyXTVFFzncyoSdiSrjHYoDattAv+NP09T7/qfBOwoDR73jxSlGNqsiRpdcutULkFWQQW+cwxaARBh1P4fGfQpLKlCwJxG+C578d7x8ANDJhkolCfVQ065YeaGtEVik2POBNVox0ftlP2HhxEuidQyYqIk+vfuMlrhwO1xy2aFx410BYULtgvw+CmLMHO+KwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HX1S944pAt0MSbxT/o5sPj6LmnGOqO2AZxUv7Gdzu5Y=;
 b=OCof3W1DSpABYR4uJKwCVzDwMafo8DrOKkAbYXJhK1tEtTJkSd8cKFRyJKS/EUcjOWiBFWh6MPBBFzQLt+XlyJqkIAWe1Zzth8xC/3V407ZpIjEVxrt6M1gtlkSHtZOHAPsfe2iB19taw7z97cw8pyhzo4QMMClFGDf2SwtYXcdDMnWSQtE/+4/G+u83yPE9fT+3Fp7F7V0R3QTJyygBfy94B0Dj/1rbTSXk4fqFdxABqERpDvNfttRrIjZQoWz8HThtMADj0i827lgrYXswQOLzDsZ4zdz/F89hha3OUhaXOuFnXytjRG2dvGr9iqp9CLfzZl29YFyk2bnyTgb6Bw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by LV8PR12MB9109.namprd12.prod.outlook.com (2603:10b6:408:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Sat, 10 Jan
 2026 12:51:25 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%5]) with mapi id 15.20.9499.004; Sat, 10 Jan 2026
 12:51:24 +0000
Message-ID: <c019d930-d565-449e-bfcd-a4a5ea3a7b0d@nvidia.com>
Date: Sat, 10 Jan 2026 12:50:49 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
To: Mark Brown <broonie@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Francesco Dolcini <francesco@dolcini.it>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260109112117.407257400@linuxfoundation.org>
 <20260110084142.GA6242@francesco-nb>
 <2026011010-parasitic-delicacy-ef5e@gregkh> <aWI2qATUQXAW-Bxx@sirena.co.uk>
 <aWI43lUAfpKZWSx3@sirena.co.uk>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <aWI43lUAfpKZWSx3@sirena.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0047.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::16) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|LV8PR12MB9109:EE_
X-MS-Office365-Filtering-Correlation-Id: 30645110-e543-4960-af07-08de5046f679
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmxWenZhbUdvYkpWT0hxemoyU05jQXBMR1NXdmRoUmdld3FIODF0NDZHREgv?=
 =?utf-8?B?VXlTdzE3a1pLeUVPV21UV1dQcnJLUmdobHc2bmpLQ1lBYjQ4UkRrTjRocUZC?=
 =?utf-8?B?d2R0Sk5XeVI0RldqcnpucmpQS3RMZ251dWxvdDdoVHJrY21FeEhSZUZnWFdP?=
 =?utf-8?B?TlpjK01Id3pTL3d4dHBkQ3hXMFJqNG1sUUlZUTFPdCsycnR4a2pOdW93QXZW?=
 =?utf-8?B?c280bjJNOVNCNU9URUxqZk1JSitsL1huaUUrMDdBd2lvV1pIZFd1QWFwNnBn?=
 =?utf-8?B?bnFodXU2NXROaWZIYWIrUjd5TkNza05sSVVzZWpCOW1iakhoKyszcWp5SDQ3?=
 =?utf-8?B?TU83bm4yQmhPdUxpblpGQStpSmllK2FpOGNGMGFWeWpZTm1iNlEydUdFRndk?=
 =?utf-8?B?VkRWSFZubjMzaXN5U29TQm1jZlJJTTdiKzlYR3oxUmNJSU9rWVNBWkVnWFRE?=
 =?utf-8?B?QzlvbDltL3ZDcjdjd1M0ZCswNm5CREVjS3FicWUrd0dzL0I0R0EwNE9XQm9i?=
 =?utf-8?B?aEV2WjhLckQ1RkY4aklWbjYrMlJkeDl1alIwVFNHd1lSalZmajJSM0FjaHlV?=
 =?utf-8?B?bHZtSGFTOU5qOU0zV3N0N1NTS2FzMXBGM3VvbElvaFNVd2hxeTczRnY2MGk5?=
 =?utf-8?B?bVFCOUJkalpoZ0wrUVMvUnAyWlRWWXdUMDlwUGRGVjhtUnZjSnJ6cWowRzFC?=
 =?utf-8?B?SXQraDJKUEo4UDREWDdUQ2hiWkQxcU9kb1VhZVpNRVd2b1libEhZYTYvckl6?=
 =?utf-8?B?azFqMUIxSG1TUno5S2huWGtjSmFiVVpURE0wVGhiVVM3dm9oeG16RWpQa21x?=
 =?utf-8?B?N1hIREtITHgzRVhHUEJUaXZlc0gzblViVndmckNkeDVDNGV5NUxLY2Y3OExJ?=
 =?utf-8?B?bnFpTm5yR3FBcldXTEJJbDc4aHkvMnlXeUJuWnJQK29hdUxLSGxmQ0hMek9O?=
 =?utf-8?B?MFkyVGFoTktmQmtsRWVNN1Zrd0gvZTkvd0REWXRtdXBJZEUrUkd0YnNIVmg4?=
 =?utf-8?B?R3Faa3FPaWJmZHg2SURBZExScmZocFRHZU5OSlVqczB6YUQyLzFEOWZpbzln?=
 =?utf-8?B?OFJNZHk4bHAxWWlJWVBJZ0NtbzZLVHprb000WnhEZ3pQWS9WRUtlNTQveCt6?=
 =?utf-8?B?alAzVTRjZlBuY3pCb0FnNVdpbVlkMWFvVjB0RVRaWDV5anZtS1RUUjZMei9q?=
 =?utf-8?B?bGNhbWxITDVmL1pHQjNRTFdlRElnankvUHZ1YjM3Y3JjUm9yd3Y2N3hJL05Q?=
 =?utf-8?B?TnJTTmlpR2pFT1V2SU9LVmIzUGY4WW5iOVg1dUdaUjFreHNHV0VVVHBlN2RE?=
 =?utf-8?B?Qzhza1V1aEF1emdaWnIxOWZQVHZoUUhITWc3YzlLTTUzdTRMay9KT3VTV2VU?=
 =?utf-8?B?RWRNeFBYWTEyTk9kcGQwSGIvM3lKN0hyQXArdHY2VFh0SVZpZ3BUanduN2lx?=
 =?utf-8?B?R3dhNlRnVitoNUlaN0YwMWZUNk9IVlFvUlppQUlZNllTck5FU1FxV1lVK1d3?=
 =?utf-8?B?Z1pRZXpKV2xqUy9lUVJwRW0vSEQ2NkVLdzBDcnBUSktMbHg3Tlo1OFBjbVcv?=
 =?utf-8?B?S2djdmF1UG9LZHcxTHhFNjRWcWdnc3BTM0I5amc2WjdCaUZkZjF4SG04MUNC?=
 =?utf-8?B?ak0xOEFWVUFLWDdPS29VSWk2dmpFNWpPczhFcGpyenRTbGNNais1QmhjY2kv?=
 =?utf-8?B?MGNITHpLVnN2WFRiTjUxVVlrZGZlcHZBeGxlbGNXbXIrdmlQYklMRVhRL1k3?=
 =?utf-8?B?SHdLQS9td09tRzkyYkdNbXF4Q0ZrSkNvZHVhV0w2dThXLzNRVnBoNzM4N0gz?=
 =?utf-8?B?SU1MNDY1QzdqYUF1UlhzNzlHRkp5dk4wVHpNS0RCWDdKdUVSeXhBVmFNOU1j?=
 =?utf-8?B?ZDZzcXdPZk9aS0xRUVViK2U0K0NJb1VWajQ0WW1MQndNbmZPY1gzY1RoNVh0?=
 =?utf-8?Q?6aDHWORr2Us6CitQYZoG2panT9ledN1Y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmkzcEM0WVUvS01CVWFnUkNEcXBYYXc4NjI0YmpFTnJaSm9vSkxtU3JzS0xk?=
 =?utf-8?B?YVc3MXJ3ME5qQWNjWG0rR2ZjdGttcjllc2lEbU5BaDN4Rk1mRWIxT2IvaFhI?=
 =?utf-8?B?SXVCNWxjem14NTlnS21VdTlWSk02bXpmek11QjMxV2p4UHlGZWxIa0RvWVJV?=
 =?utf-8?B?b0lxMGFEVE1yTjQ0RmdCTTdpVEVDYUtxSDBBNzhoUm1NMXNDenlFVXZmd0sx?=
 =?utf-8?B?Q2s5WFd2QktNZkpRaXY1SjFjOFJ4UlFxTmpDRTV2NWFLQ1hscHpuRFU4K0NO?=
 =?utf-8?B?ejlOYjAzWWdzSHNUTWpjKzQrZ3ZsQlN2SnBUUkJqRm1xWEY0bGdIMFRQWUtR?=
 =?utf-8?B?Y0NEdUkzOUNKZHIwU0hpNHZkbG9XQVN1RGVoMWRUdXBJZzh6REJ0U1p1RkM5?=
 =?utf-8?B?YnJWa05JZzVPVVl1eGU1cStxNStRbVlMWEt2UWt4d0p2UEt1UGs5Ny9sQjN6?=
 =?utf-8?B?dW4xK1gyZTRYYVNYa1k4TVR4T2diOVBXK0Z3M2xoWnA2Y3JXS1c4NGFNNkJF?=
 =?utf-8?B?a1hpeEpzV0dwQzdiS3V2WkE0V1lVU2NtaHQvYXUvRkVHOTVKS2VOMld1akVF?=
 =?utf-8?B?Y1V0QVVTTUNZREhKTTdEajJMRnB4dXZMVGNDaWRzYUh3SFpBWTBWL1J2YkdT?=
 =?utf-8?B?YkhYeVpOVk0rbnVqNXB2NjdHaDdzbGMzN3FKWUxMSU8zTThUVWV5NVMwcWJo?=
 =?utf-8?B?NlYyTWNjS0dOM3JNQjh6YTdqQUJjcEVKcms5WXJ5N25IOTdCU2NrN2Z6UGVE?=
 =?utf-8?B?RjBMdFk2WVExRWFwNXNNN01wT1V0RVdScXhWRElWV1dCanBiN3UvTy9DNlpa?=
 =?utf-8?B?V1I0dElJWnlLNVQ1N1Z0U3U0djhKR2J1V3VSYmgzMDMvTEFXMnRST3YxazBq?=
 =?utf-8?B?VDRZS2xhQWdkK1ZOUHJUTTNDOUQvWUljVjlWL3ozRE5Hcmovam9jdE9QSWJ2?=
 =?utf-8?B?TVlTdEVTd3Y1SjF5cEVIc3hQeGxHbXZHdFozNkhjWmNxN2tYdTllZDkrZjhS?=
 =?utf-8?B?SjJFbjFjeDF4dGN5QzR3amgxRUtUckRsZUtvNG5JTXpKSlc2N3N5M2YzWDFh?=
 =?utf-8?B?RVNURjV4aWFzMmF0U1VTQTlJUTdQTUVELzBrT2lqTmRFKzRmUG1GZWZQZG5R?=
 =?utf-8?B?Qm52cExMdVpBWkJTTGlWdVBLMFgycEFabXNreGNuUTNsM0haNnhaTlJDUm9T?=
 =?utf-8?B?QUFORDdFZXB4cUxwRVlKMURlTmJJMk8rd1dHNEFhNHNxR2VNVHY3SmJaWHlO?=
 =?utf-8?B?UGRLbE5pMkZualp4eEFMRHFwNnVRNS9LSk1xUk5aYVdGaW5zcWpjWHRVbXBQ?=
 =?utf-8?B?QkYzck1mb3dzR3cwdmJCTnh0eStFU1NWcWRrYlFiUDNENXNWaGlTMFFhZWdj?=
 =?utf-8?B?U0tlRy93MDZ1bzBDNmZucEcvTkVlRFQxQVU0b2ZWMlNzOWxnMCtVT2RDZTU0?=
 =?utf-8?B?VlNILzREUEY3YzYvM3d5OHp0blNVVG5YVjA1dnpGVWQ2c0U1Wkg5UGZTTHVj?=
 =?utf-8?B?SzA1SmZCMHJyN0VjL1VFSHRoT2hoYlF0UWhUOGV4REFKbDdmRHFMWExxM0Qr?=
 =?utf-8?B?cWVQN1FVOUk3Q0RDQ0dheVVjczZvTG5oYnNkTFR5QjNvMm5LTjhVditSTk9K?=
 =?utf-8?B?UFhUUmFWNXRMeUY1NkJPNzR1b0V0M1pFUWsyb3NBLzR5ejFxQ1dHRDZhN2lt?=
 =?utf-8?B?QjJ3SkhoeUd6UEJ5aXZmNVlQdEJqb2ovRUNwWUs2ZUtDcUVJVzBQdGVmODdu?=
 =?utf-8?B?cnplSGE2amhrZnBiZTRSM1Rka1Z1NURRamY1dUpJcFo1YkRiUkVDcXlHUm1H?=
 =?utf-8?B?eC9ibWFRLzF3dlh1dzZvNGd3UEs0Q0RUMjdXQTBZdFovNGxRSld6cXR4YVBa?=
 =?utf-8?B?cjNVODNNWlliQjhQQ3Zyd1pPckRleWQvK2gyREVod0w0akdmeGdUVDdEdUlq?=
 =?utf-8?B?RytDUnZBQ214R05Tblp4ZVlBak1hSjNTODBVQ2VXZ0ZncG1wOThkTWhUeVBB?=
 =?utf-8?B?T0hSeEhvd08vaEUzOXBhdVNRYllSNVdRWFNDTnBDc1ZDVnpCbmZicFM4ZGQz?=
 =?utf-8?B?alBUdXkyQi9WUk9EcFFpSnNCbzlrYlpwS1M0RWExZGd5VHc2UnR3V1FjTEdJ?=
 =?utf-8?B?bFlTNU5VaVBPQXZISUl3dHRXZTdZYUNCcTB5SmZncTR3N0tKU2ZQK2htWEZl?=
 =?utf-8?B?dHo3UjdUQjZUQzROZm9HaTVqbldnZS9PQURFQitzaHNFTFFnczlidlZ1RVZo?=
 =?utf-8?B?RVRTTWovbG9PcEdYMmJVUzR6WGdUdjVQeVA3RzFySjlTcGZvVEpqMmYzSHhF?=
 =?utf-8?B?MWFiemRqU2UvUTdITUxUb0NFWi9XN1RYYy9zR3NKUGRsM1FDV0xpQnk1WFhz?=
 =?utf-8?Q?MHyUDh6R2SuEPGhUCREOb5fbn0UFLwyL+ADTpEg3Nd+ce?=
X-MS-Exchange-AntiSpam-MessageData-1: JYpR1QhqBxzduw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30645110-e543-4960-af07-08de5046f679
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2026 12:51:24.8318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3YvoAdtRIka5SLyXbjd24JidiUisPEevQvJ3hMXaLLhCfQK20tnKo16uRWth1a71Gjh00V+oGc9F3C1QWUE4PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9109


On 10/01/2026 11:32, Mark Brown wrote:
> On Sat, Jan 10, 2026 at 11:23:20AM +0000, Mark Brown wrote:
> 
>> I'm also seeing bisects of similar boot failures pointing to the same
>> commit on at least i.MX8MP-EVK and Libretech Potato.  Bisect log for the
>> board Francesco originally reported, the others all look the same:
> 
> Pine64 Plus, Aveneger 96 and Libretech Tritium are also affected.


This is impacting some Tegra boards too.

Jon

-- 
nvpublic

