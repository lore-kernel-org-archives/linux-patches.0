Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53E91C242D
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 17:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729619948; cv=fail; b=fx8dXbtFMqQQ98NtRq4hnM/0um8qWxqfsD6D84yy3ASCmsGs/Vd7ju2WKP4CRswb+6OnQbcS8/sPwhQvowmM6Bq/3mkauqC1c1fB5YgdtmSvNDIKyi1mfjXixGsCzjUfmvO5ItBP/ugiqFKvWZerV4wCj4fTwxbTkC6RpFrLucE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729619948; c=relaxed/simple;
	bh=LCIkdrXTukbBMGm8kDzmE3eTHZH4tc9hbyvyW7jyv1I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UaG8TDx9lmvY867LkWwHuBAH+aEyW4lFcuf8fI3aO0pHYI967n0LhBeySW5Fj3vxAxuiJnw42e07v/8Th5fvusaBnn7ruo36hM0yrQoYTV6/ySWS5XTfZWhd7B8JyoI9NpHInMvEKp8o1Rp5kLtHR4iBbWMqv5hamLMpLcQFqBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=somhzxMx; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="somhzxMx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tHBaCDXTjIbtEP1oCRDzPvllx4UakUqyn2n5ep9tGFsqaQ29c6PWBE1h2eYXoe+hQlNG2CseHSGUVRlCOHPJvksGtK9ufu6pW5350dPmzlj+TWzV2v1zFY70q4lp8bTNK8ljK3KMiLqW4gzm5Wtjd+djmlWvFRcm10U3bj7R582aIZRAvdBOYoO40ZqeIbzJkRZGN4SHCO7iyDSq1IIju32J2bs7/fIHAlpxiW6y0OyQiNzFlbgey0vmuZt7lyohxjNeCd+1BMsT2I8DSS9/yADkFsMJf661rBuLa9YGaTEe90a+12qvTx2iwCsew/GBw1CDh20qZVnhLxjSlQkXVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkvQWE0BPQuC+Lcq1F8wkIjm0lZo/WkQV1YyNomzb9s=;
 b=QeoYC52STqm4fppIFbFhAMRI+0nfFr8D5uJTu5D1VwBWtzpPNNfJl4fGjdocqQiRN++WHCfKmfGNg8KPushGEDDImfFvTk4J/WtHtvauQ/MX7+dBU+ZlgVeKrMydGAytgq4t6iPKfNsb9XjQaq1XPV2ydVyqbSetVwpEwx0PHtF/7AprHEPQvxf5ZVmhSoAfFxAo1o5+fowYxZaf54Y8IAnoHTo3emRg9UBuwrBUmNokKEB7yVLCVXLcd6P8zUVUWOhuHg1xwgVPQyxnejDD00+Zc9ZcD3CLR3u1VAEwyWlukLa2yHcXpoGEdQsD9knhz+eQv2JJMJYRYJVTIYuytQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkvQWE0BPQuC+Lcq1F8wkIjm0lZo/WkQV1YyNomzb9s=;
 b=somhzxMx5xzZN1rcNV7SaukTcD/NE5FoWqrMgnkUMhBq8qK6O31/vMJXCWkTFAzwQOgZghhM8c3hM/g8Lr5fUqKJk130PX8akhuysWQ3wABQnlGjbKGVvRfN9Xzz9yut9QqXDboScQcqYQOH+DPy/BpxZmd2d7or0TDG9kanWUaqxW3K9IszP4YI7ToblDoaQO4/ESkzEV2jdDb/POQxWXssSCfcqAEYqIhiRbf3R6iETdLlL+tdvyNy9pWEvZvFGXEfyoNKP9QTss+3grqjM+xgMnRqX4XdpJNfZ/D4xdYyZ9pgj2d/j2mXz72nOAtoG2IMvJFo/50R7/o8BJ9hLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Tue, 22 Oct
 2024 17:59:02 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8093.014; Tue, 22 Oct 2024
 17:59:01 +0000
Message-ID: <225ee26e-e157-4f30-934b-e7a902d67257@nvidia.com>
Date: Tue, 22 Oct 2024 18:58:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241021102249.791942892@linuxfoundation.org>
 <23d85d2c-553d-40fd-a1f5-3356e12160c1@rnnvmail205.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <23d85d2c-553d-40fd-a1f5-3356e12160c1@rnnvmail205.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::14) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CH3PR12MB8728:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aa3bafa-4ac9-4bb2-9948-08dcf2c335d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dVBKQ0dETVpWTlRjSExKUHNLNUk2a2NQUTlSTyt1QjVNZ3FucFNzSXk3eG5S?=
 =?utf-8?B?WHpWbnJaS0pCcDhLQUlRcVJTQWhabW94bUhzeUw2cmdGSmIxTlpvVVNJeTgv?=
 =?utf-8?B?YkJNWXJZQ1pmd0YwQmdZa1hxL3ZtY0lZL0ttY01yd0FQYVBMeEJHWDB0SHRm?=
 =?utf-8?B?d2d2aFpjNno0V1NGaXcvUEhzSEZHM3Nkb3VjSjkxZFZVd1VvS0N2T1pVZGNR?=
 =?utf-8?B?QndDSEpXUVFBdUdHZWJwVVpIWWtQNGVCTE1Ic3RKSVI1T0gxM0FDZWpISVBB?=
 =?utf-8?B?L2NBdDh5MUMrYzEwOXdUZ0lJUnB4UUwrTlF2bU1pcTZ3MkVLWTFxbnFvMDBC?=
 =?utf-8?B?RDA0Ry8rc0hpZUgrSGJUY0U2bDJoeXFFdVRzT000NThJZlpVNTYvNHVGcXNF?=
 =?utf-8?B?bzVIVnpteWYzQW93aGtxUys5RzVRaStqZldwSWl3Zmk0Z3lRdXNZamppOVVq?=
 =?utf-8?B?RzhWSnBVMHc2Y2tNVjlBNkVXMWtmcDVnOEdqc2VoTjU1Z0tjajJ4WnFaZkdq?=
 =?utf-8?B?dERIUmNSZ1VOZUhRWmNRR3JvQTNIVG1FZ1lXWmRKdVBxbnlhdlRTZUxDalpv?=
 =?utf-8?B?b2JTWGlUdUczaGZsOEJ1VzBQU1k2TDFhM3psVmhMR01aaUh4N0JCbXBabUZ2?=
 =?utf-8?B?eno3YnhXMW5Za3ZiYUZTQkZWUWsyQVErT0dxdU1KeElqRlFSQWpEUXNRZ3ZR?=
 =?utf-8?B?aVZ2S3c2SkY0SUViM2k4WGFWZUlwK2hQZEsxMVkvbUpqZlpvbzRDSGNncjZI?=
 =?utf-8?B?K3ZHdGZ5cmsvZ0g3RFZrSXJ1R1Zxc3VUSjNtM2xmeVFRWE1GZy9uWElzQkpI?=
 =?utf-8?B?VnpscDF4Vm9VY3RRSWZZd1VadXg4YjgzM2g3RkJYdXJtOWM5UFZqdjhURjZz?=
 =?utf-8?B?U2U5SlptMDd2RzN6cDZZRTlxMnV3YmdRYy8vWW9STTVKV2RzUEs5UFlJcXFw?=
 =?utf-8?B?UGVvcHRPTDF4M0VGUjYySTFpUXBFcUd5TXZWUyt3VVBnbGs4QSt5Qjl2SWdp?=
 =?utf-8?B?UnAxdUd5UHJtUjZLVFViZmM4SW9Ba3VieTNVd0MzQTNsZ2V0OHY3Z2tZazNN?=
 =?utf-8?B?Y1lwRFlMUTVvQlZiL1J3Vy9rYUF0WS9jRDRsc09jZ3JNTGtnNWxqTkwrV2tN?=
 =?utf-8?B?bXdscUMyaUxLYmMwbXZkUktrYzlKSG02QUtkckxocFd6V2ZVcm5scnJzRmdM?=
 =?utf-8?B?dmNvSkgxU1pZZjdwRjJURklCdHFTbUU0NnZnSlo3Q3dKYWNHNkJncXBLdC9Z?=
 =?utf-8?B?Ung3VHpHMkxldHkwV0ZHSmZHT25id3pxdCsxdDFNKzJBWEJzNWVyR0M1Z2J2?=
 =?utf-8?B?U2pBOVQ4eTg1dE1vSkxzUy9jdXE0T3JjRDlnT0o2cXEvMVhmaEx3ZXlPT1FT?=
 =?utf-8?B?c3MxZmZHRVIyQVE0N2U0ano4dW1WUjl5NlU0NnFubnh6V3VNa2pzRFdSVjFM?=
 =?utf-8?B?NVZPL2FjQmdvRktiMW1XRUxRQ01QbDRocjlUTkpoZzFacW9qeUhTaWVYK0pJ?=
 =?utf-8?B?Y2xSQ2czZEtldytSYmZCWkkzOVFzTWRnYjVHbjFGcWRHQVRCUzZyeFpOZEFF?=
 =?utf-8?B?RHY2aGp1VFRycHdTTmhaVnh0b0Ivd2RNZHRLallRSlhCRmlPRGU2YUljeHVB?=
 =?utf-8?B?Wk1uZ2J0OGtOdTVnbkpFeWhuazVndUR6cHlkbmlHL3NTMVROTWtBVU1Pb00x?=
 =?utf-8?B?Q3ZHUDVqU1gzaG5oMmY2NnJkMGQzWEtSeFgyMG8wcmd5eGQ3bWNBVEZtRnor?=
 =?utf-8?Q?TAK2GFf0iJYGkslnFigDUd9K2g/kYmVNfzP6ftY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STBuYktyT25ocVhydVFVeEN0bGhkNHc0S3Z4MDkrNTF0TUkyOUprZmxuZ3Q4?=
 =?utf-8?B?eUs2ZUdLeGZxNXZ4TWVhdWF6YUhEbmltaG9PRFRhcnRTaUcyRDBBZ1lQdnk1?=
 =?utf-8?B?UjZkbCszV29xSFVmcFFvQlFGa0l3WDZLTTQ4UHBlbmZ5c2lEVk9KcEhmUnJJ?=
 =?utf-8?B?RGwyZCt5RTk5QXNyZ3NvVGxYUUZzbmZrejIzakxPY29kbzVRSEY1R1gwM29W?=
 =?utf-8?B?elcvK2JKUUFQdElnSG1UK0Q1Y1BwOE91QXBhWlJ0ZlFWOE1Wc2s2UGw5dHVE?=
 =?utf-8?B?a25vZTR0SzZnbTd2NEVzd2NlZUZVM3JxRndGNk9qQk12TDRYYTUrV2g0Y0sy?=
 =?utf-8?B?RFhXZWhBd2pvTVZFUTNQZWN2V0xuZGZRVnUzR012b3FFdDRzTW0xblEvL0dF?=
 =?utf-8?B?TWVOemxzK1FaOXlnazkzalZDb1dUc2RPbHg3TnZ6SHlUQkc1RmN4T2owTGFW?=
 =?utf-8?B?N2IrSEZWbEZrYnZodHZXcmtlQm45dVFwRWFCQWRPVFMvQkQvVS9pVVJYQVJG?=
 =?utf-8?B?Y2R0aE1UVFNBMkovN2dyMjdtNTQvSXRPZDd3Ri9FcTVMUGZaMEwvMmhjVkRB?=
 =?utf-8?B?WDNnUWZrby9ZYWhMUmhjZTNFOWlnVlNPT1AxbHg4UEJPcHV0VUFWOTFCVjJq?=
 =?utf-8?B?R3kySjJsL1VCaDg3M0UrSUtKdWRWSHM1RFNyWnZ5c0l0T2hOczQxZ052T0Uw?=
 =?utf-8?B?dTIwNEtIemdtbk8xU3o2WkhXcDFPM3laSytrdGFpVDdMMTFQSjdCU0VZcWFk?=
 =?utf-8?B?Yld0ZHgyUmU2RDg3Z1hZOGJEK0hON1ZUeXJLOWFtcDd3UHg3SHNtUENKeHNs?=
 =?utf-8?B?RXVXcGNNQlZyMnZCWHNvWkNPaWV1NlZUb1Ztb015b2MrNFVWaDNlSllqb29I?=
 =?utf-8?B?WGNmYkxlTzJMNWZRWFZDMFllR0hEejc3V09vY09QUHBkbUhHZWFRZzA2ekJD?=
 =?utf-8?B?ME85RGhOcVhlZzlyNzZBTUwrN0w5MEhsaE85SnlaTGV0UXQ1TS9SM1BqUXY5?=
 =?utf-8?B?cFIzZzdCRmZ0WGFVS1JSQVZHT2E0c3VEcDhZR3dnRFZsbVltaG44VE1zS1Z1?=
 =?utf-8?B?dldXbllTMTB0TUFWY2ZPVXNXaEM1QzF1akwzR2lwZjY1S3lYMEhjOUppRHBw?=
 =?utf-8?B?TGRuMENNcjNQOEtRV2NkQ1BoM1EvOWlTWU5EV0lURmZpVUl1K3ZXblF0NEJt?=
 =?utf-8?B?aDlIdzNSY0kvbHZ3eWJtb2thengvVERZNnBydkhMWU4rTFhnOFpQWHA1c1BT?=
 =?utf-8?B?UWhMWW10MGxBdEttall0dzkzVHk5TC9QQ2hGQ3k3eHp6UDhsbDBYbytWVkxR?=
 =?utf-8?B?YVFSaVUzSWVmODM0akx1VlgyYmNnS0ZKK1Q2TzU2ZG9SSnhtYm5kME84eFRZ?=
 =?utf-8?B?WE1hUGR4K1E1YnZqeGkrSlFDY3BHbjZQZXJ0aDVwckgwd3dzbVZ3ZXhmUVVm?=
 =?utf-8?B?WWhReWVQeWRoOGpxdDVuM1BvSGhKUlVta3JsWmZMTHd3UU96WG5HZjZtS0d2?=
 =?utf-8?B?VktnbWd4ank2a3FhS2lKWjJORm91dThNMEZtQVBOUmkxVXpYUkpzQ1ZwRjFq?=
 =?utf-8?B?UjhUME5odmtDRGM5MCtBRThQdW5UaGRjakV6dWVYZTA2S2M5UFNRTlZZcS9y?=
 =?utf-8?B?RnJWcFNVSUJ1VUlnN0F6cVk1QVhiWThRNjB1RXhyLy9kS1RROHRnazZ3NE9Y?=
 =?utf-8?B?d0FJR1J6WjQzOXN2WHF3a0N3RjNlV3dHaE1lSUZsanBsVmZTL3p3N2VOeTRl?=
 =?utf-8?B?M0lwcjR2YncvMXZLcVRjZVBCTlhXd3dGL0lDSGFzZ3dKWFVjRklHM2tkRG1H?=
 =?utf-8?B?OVdvQW5DSDliNWZpRHhjVVU2R2xnR2ZpN1VXcWpnTnA4NjlKQXAydXJ6TElt?=
 =?utf-8?B?UlFVbWthbnlvNUo1YWNrdzRaSFlCSm1qWHdZZVZ4ZmQrMXZhUFZtVHc0OUVK?=
 =?utf-8?B?cXNwY2VBa0dWbnczcWVaQ3pUWWwwcXJ2OFpXVDUvL1lvSGY4MFh5NkJlWGdP?=
 =?utf-8?B?UVBCdGhiSmJjT3pwM0dRbEx6YmJXN014dzRqTnFYZ2xERzNoaUl1MWVJaWRQ?=
 =?utf-8?B?aG8vbmp3VXJPWGx1aUl4M0hTRnZqaWVGMmFJVjh3TVBZYitsNGxTWlNWN0Z2?=
 =?utf-8?Q?XoHlHXKV+M30wKqFBP+R6czpx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa3bafa-4ac9-4bb2-9948-08dcf2c335d0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 17:59:01.6525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KuZFQMKoWh3UjlH7dZiGMGWj7CWTAxbxQ523Txa+00hfy5wZhoreMJ3MhHW4fxjFjAR1IIwt1KUd3DY+3wYYvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8728

Hi Greg,

On 22/10/2024 18:56, Jon Hunter wrote:
> On Mon, 21 Oct 2024 12:24:14 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.114 release.
>> There are 91 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.1:
>      10 builds:	10 pass, 0 fail
>      27 boots:	26 pass, 1 fail
>      110 tests:	110 pass, 0 fail
> 
> Linux version:	6.1.114-rc1-g6a7f9259c323
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Boot failures:	tegra30-cardhu-a04


I am running a bisect to narrow this down. However, just wanted to 
report this. Appears to be the same issue on linux-6.6.y.

Jon

-- 
nvpublic
