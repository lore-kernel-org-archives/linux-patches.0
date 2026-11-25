Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795577691;
	b=fdbZN/6AyhS0hdtYDa4dJMA4KYl+2LSREoZSFFJn/UmmjMlFqP2pvj9BrBZ0pNVB8JlW
	 jER4exYs/3ayaJSCW7STRBE6/6W3JK7HMpog+HvEIFXsgPNtiI0xdehJ44HnXrsfZ8Mp/
	 dCIb4Ax7aXIfGGcRr50H7TcMejfNbGJvf1VuM3waCB0yx/xKEvFvlY/U/VLEBO9utOIz8
	 5tCc+0/Bl07aEcLGkfZpnjwjwQTAwHgWFE4eJtWqjXjQM1p93Zcae0zg5VrWgKe/Zy15J
	 R5eZNeQEfhLXhIA1GTfSqxnx4db9dLAjjG0XNkGiv5opMEZzQCD4QeDHrmWfi+4FsWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795577691;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=2pufGv2KCoV+r7SFcBlpOWFLx+vdfBVtTAKF/Q27aqo=;
	b=vd0UbUL0HDhq6k1kPvX1dc5CMQbEx6H3j/9idlQUScJ8VeGfbhCSDAnsuTz5FaRV8ftt
	 ixP90ytkxxk4jar6lC8xa/OvjI4Y/PV6c02Pe8MIXva0qmsa6U8WD/AlIzuzF/y/qsM0w
	 hiXkzU7lvKbrF8XkPscjYMtiFm5cKb8UooMgD9X3530z2T2rPi9TslR+gVfhyhL96TTAt
	 eqpg0Rdj36hidG1GsNk9TONmg2UG5eJnpryGooF56rHxLGla/ccKlfSgaDxIHNM0W+Ba0
	 SfkvMe69+yh+Ngcxhc51XzBLFRQN24vtXOvLNdGuMkr19JgxWOSjTBRUrOKWy8RcZHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=nbzYozps;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.41
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011041.outbound.protection.outlook.com [40.93.194.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFD7606A32C;
	Wed, 25 Nov 2026 03:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BFD7606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=nbzYozps
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZnXzwshwHXoQjdjMO2AhrqW96QDIgZaA6je483JcL2CJrGWOFAetq0tQCco66gd/Hypxc0l9Pdq8DdXDmcYhII/QEW+IEKkqG6OeXCoD4T4tmgV0QBmkDY6WNzrXOS3CGnY54SxLmnR+yZdKb5yGqTKizqP1Vgt2E7f46JtNjzFkA2eCiCfp6P2Mp/6pE5/r4QbJAp5S0yavHYpm0ZlK5CaYh3Q6awhPMFDFGBl0e7EPOKwDveu3Vqt67HPKRjaWkJrhMidqVH7RLCDsIxnzi1UMurvvTzJN70JZS3PSLF3OeHVoOvwAy3f84FJC5FYorSCJDuVv/MrUPcIpEDtgOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pufGv2KCoV+r7SFcBlpOWFLx+vdfBVtTAKF/Q27aqo=;
 b=U9uzjD3gU64dhrUsE6XeP9w38qPSA36IJsUyvSeHFsj9PXrjW1uNA0G59ozqdFlotSiSlCGh+MXrd284ZLyo4nMeMNO4KUidXmiggk2j5FOyZBwnGzYXukdFiybloJwq0DZrJUkQawF6rHaryuZFWeaElB1ieyCAmxRp49p2KGw+wvyfUUI3AmQ4HhXtH057oCabXj4/Fb9K1JYpaItzIYVTNdIBNeJLrPSepGfmCMfXc8pq5Zs72S1wKxEjpkizcH7mCgLIEycsmJJG9WM2h1U7sA0/SwhQgN2orqzL4n/F8+BhYX2Dqq0Zo2S4Iv5ZVm9v8n7DmnstoE5PdLJLhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pufGv2KCoV+r7SFcBlpOWFLx+vdfBVtTAKF/Q27aqo=;
 b=nbzYozpsFHcG3jvfoMNTEoltt1Q0MlUd6MuVBnXsANeBRglgj4rtdqyvmYiDSD6M4CwU74QMj8puOOy4Gnr5ANt9Voh7V2BX+WUIWZpoYpg+7wSb/rMCIxLnOWfX8BAj7d14IYkYSDG6CVNXx2omEX64T0COG9HKNHz1CarAzAU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CHXPR12MB999219.namprd12.prod.outlook.com
 (2603:10b6:610:2fd::8) by PH0PR12MB8151.namprd12.prod.outlook.com
 (2603:10b6:510:299::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 03:34:47 +0000
Received: from CHXPR12MB999219.namprd12.prod.outlook.com
 ([fe80::da19:941f:da0c:2408]) by CHXPR12MB999219.namprd12.prod.outlook.com
 ([fe80::da19:941f:da0c:2408%6]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 03:34:47 +0000
Message-ID: <17ee3598-9cc3-45d8-b068-31fafa06268a@amd.com>
Date: Wed, 25 Nov 2026 14:34:38 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] coco: tsm: Register the TSM class before device
 drivers
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Steven Price
 <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, driver-core@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-3-aneesh.kumar@kernel.org>
 <20261123152903.GG179082@ziepe.ca>
 <9f92f7ed-5198-45aa-9cef-515ccbf98398@amd.com>
 <20261124170754.GB114530@ziepe.ca>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261124170754.GB114530@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0119.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20b::16) To CHXPR12MB999219.namprd12.prod.outlook.com
 (2603:10b6:610:2fd::8)
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
X-MS-TrafficTypeDiagnostic: CHXPR12MB999219:EE_|PH0PR12MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d6a1d59-379f-4962-de2e-08df4aa50dae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|18002099003|22082099003|261022105027099003|261026140227099003|261026121527099003|261022075727099003|261028144727099003|56012099006|4143699003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	rPWJzZGQqHe0d5NuDcMx6TwGjPv7TX12m5PumrzsR4EL0N6shSYy+xuvjOQrB3YiceOTxMbpUW0RbNueF4/pL+qSYCGtmVcoWZbhVrVE2+y1QU4KWF1EpRjnwkebIUzEYWcMYDZLObTHZqnzw5RPOQLe0EsTRsPsPbFS+GBbVSA+QOyfhsPS6p3hLnyGX3qJYYY/ULQWrzFYkrU7bRTeO/zf1CIgZ9/YAYhXm0GSsSWp9KFTnW00qS69zna7qTjvhjij/MFKz87kPbAkHFwrDdc2BsiGVYtsTdPELqFU+6wK1NVBI9U4jSpRocGYz/53fvyOA+KaTcwvbfBmeUx1ITxrwHfuE8Zc43QV2L9cuiWH4ukOczq3hHlSvCSfwkM9s14mT3+0gQAwjQIvCppj/93a1DcjgaKsXdJ3l929jMKkCFrdzgEZjt4SgIArPpmwhJqCWkjNEj1FXB8Sc24tPf1S1QCkv2fEcTo8kvBPcu+xMwYRcsYNK0Vw+5nhhKrC9zb5c7L6s4zDlncGDmb+pG+YI5pR1J+/3oINViCyP771u/++IkaE6V6xxIp9PdKuHT4sX03ta136oZJ3Es9BOsbDrN/BpscqO/BUUd52rsUVNyP85EJewOJJSZIlIh13QTQvi/f5E2oophCTDOIqA4umIF+Y/WZBIOFP4aeXlBI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHXPR12MB999219.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(18002099003)(22082099003)(261022105027099003)(261026140227099003)(261026121527099003)(261022075727099003)(261028144727099003)(56012099006)(4143699003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFA2bnJZcFdRZ2RBenRpbUt6WXR6UDc1aGFnbU9qNHVERC9hNVA2elVoS0RH?=
 =?utf-8?B?V3N1UnRHbkZpdWhiejdESHlacWovNzcyMUZPbUdGRm04aTg3YXV2SjM4bTBh?=
 =?utf-8?B?TnR0cXRmb0N5LzNSb2xlVzZnNUJraEJRdEYwRG4yYllPUTh5c2RyZW52OWQ4?=
 =?utf-8?B?OGZjYW5aQm9CZUhlQVJaenIycWZPS3VXdzY2bUNtRDZnM08reWlKN0QxcUkx?=
 =?utf-8?B?dDhDdzR6b0VtRWVXbzg5NnFEOGxTVWVkOXYwU2dYRjhjc0xzbklWNDRhOU1y?=
 =?utf-8?B?SGJ0MlZTVW5WdkIwODhtMnhsNzFMMHpGN3pVVlVIdXhQTmVTT3p2L1Nzby95?=
 =?utf-8?B?ZnJCVmVLTHd6QXRjdk9maHY5TklkVHVQRVMwSmRaODhER0dyc1d6Mk9ISjcv?=
 =?utf-8?B?Q3p6Z2pvNnVhdlphUVIyT1JCcEFsWWw3S3phNFZiSHQ4cEZpSThDYW5UNFdl?=
 =?utf-8?B?WG90MG5LMlhldTlUdEVCMVhuRkZ2amUrRXphUEVHbFB0Nk9YZ1RyV3BVdGU0?=
 =?utf-8?B?c2k1RWxkRDRRcUlZVG9xSExTU1hyUUZmRVZJYU5DWko4RVR0Szk0ZCtyQmpV?=
 =?utf-8?B?WTFha0ZwNmJRR25KZHBHYndPdjhuRFYzZ0ozSVJzQ3ZHQm0vOXM2czlwZzY3?=
 =?utf-8?B?b1BPYXZsV013SHNKTit0akdHZ1YrRCs3Q0FzUXh3dXkvb1RKMkRMeW1EbVFC?=
 =?utf-8?B?cEdPV1VGTG1ZR1lnb1d0OFE1OU5hQUR5OFJmZDNqRFBTNWtCR3Y2ZjhESUtW?=
 =?utf-8?B?dXY3NWUrbGhnbE9EYjBKUzkxWmlVNFozc0FJRVJHNTQ4SUtMWGUzUGNyenJy?=
 =?utf-8?B?d3ZjRE8weTRvMUZHdlBpWGxkOFhyT294NlByRThtUVVDalhpbnJESjNxQXIv?=
 =?utf-8?B?b1crcklmR3NSSHVLaUQzWUU0aTNIMnIrOGF0cGJDcWFFQXhXK3FPNE5JazZT?=
 =?utf-8?B?enVKR0Z1cjNoWm95WUNHS2xnOUlLYWUxeW1tT2RZcmNOOGNBYi9MTk5BTTRW?=
 =?utf-8?B?K1RtQU1XdHlFd2hXUHJnNWdWSnJQT2drc3hKVTIvQ3NvYm81VlFwVk9BUmhh?=
 =?utf-8?B?VzBlRmcrODE5ampYWlpNL3EzbDk4dG02elJRWlBvbjcwZFVYYzVqcjZKVWVw?=
 =?utf-8?B?VUxUcE5NTWNGUk03VmZSdkNYdVcyb2xvUVBYUi9GRnVKVUg1WWQwT3djR1Jq?=
 =?utf-8?B?NS9MQnNoYm5WcEZYNVdnTnRXS2tteTl0amhqSFZONGwrTVpySnlHcUNLdjNI?=
 =?utf-8?B?Qi9DN3JoeWFMd1lsVHluTDZwSEdaUXl3aTF0blk4VGF3VXZBOXhOSXJVUjN3?=
 =?utf-8?B?TldLZnRXUDdlNnl2OGd4YUJzRmtSSW5PN0pwaGY3SkdMV25BNWhWWlJtSThl?=
 =?utf-8?B?QXVXdXArWklvdlE3cnpGSEwxNVMxOEQ1MUdoZzNoL3RELzk0VTBCVVRYQnRn?=
 =?utf-8?B?L0ZNdDhhMHhzTFc3bU5XZjNyemIybm9KLy9zUWNtbnBRWlhmdVJwTHo2R21B?=
 =?utf-8?B?V1V6VzgzdmJvRXJmcWhOaWxMUWdGeWJxTWhGQlVsL2hXeDdkZkV2ZnhlK2Yx?=
 =?utf-8?B?L3JhNENjMnVNNjFTUm1NMTBMSjhHTlV0NVFKTnVIaFVQdStORXE1L3M5bmN0?=
 =?utf-8?B?TUEyV1N3MUUvSmZOYzlmc3ZOQklaQms0UW5BazB2cjBIWkdFcFN0dEhtRGhS?=
 =?utf-8?B?UkJuV1kzY3djQzlrNFpiWk5zN0Y0YXIzS0g0OFVsR3hxVFA5NEcvUXVoYWNk?=
 =?utf-8?B?S3B4OXhXMjUrZVpWekFldGdIOEdYWlN1c1V4enNEZFQ4TlZUYUFVcVNvdHpY?=
 =?utf-8?B?a2VORXNaaXZ0RGhlaTJwdWJ2VzYvN0EvbTZtSDA4by8zdUJsSks0eG02ME13?=
 =?utf-8?B?eGJ1Zy81UG94SlJlNnJCdjQ1bENraUgzeTRxQ2FyNVF1bU1QRDFxWTZ5U2lL?=
 =?utf-8?B?Q1NwdHVTLzNLZ0JNYzEzYXpwZUxUak5DRzVVdXhBZ2RGRHExNC9sSjdyWEtn?=
 =?utf-8?B?RW1nUFdXeHhEQUdtd3RVUWpsZU9KdWgzRzl5eWtubE96VEN2ZHZTdVc4aFdq?=
 =?utf-8?B?ZjdRcC9xdkZnNjVXaERNNGJEZ1lFTjdwWFhDRGhqVlVnZ3VteVVyQnFoRmFO?=
 =?utf-8?B?NzE2cjdsT1pQejE5TDdVcG43cTZnZkdmekNJcmVUR3g4dFBOalRtNEVCNnYw?=
 =?utf-8?B?S3JuZE4xOUpKcHdiaFliK29EYllDd0o1U2lvK2RxVHRGcy9LVGQ3RHpnZXFV?=
 =?utf-8?B?UDNNdGlGWENZdHpMQmh1dVhTelJPMCtyZk5mOXY5dW93VGxyK1lKUjdxSFNm?=
 =?utf-8?Q?eqBlPEIJu8iitn30eo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d6a1d59-379f-4962-de2e-08df4aa50dae
X-MS-Exchange-CrossTenant-AuthSource: CHXPR12MB999219.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 03:34:47.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iTqoY3tAXJP0ySPfqEN2pgA3ZVZjVe4y8D/BLBkB5bNVCN4L/PTodIGSrYMqRWK7SPoLIOAQDN2JX3eOxywEpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8151

On 25/11/26 04:07, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 11:40:16AM +1100, Alexey Kardashevskiy wrote:
>> On 24/11/26 02:29, Jason Gunthorpe wrote:
>>> On Mon, Nov 23, 2026 at 02:03:29PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>>> Register the built-in TSM class with subsys_initcall() so it exists
>>>> before a platform TSM driver probes, independently of object link order.
>>>> CONFIG_TSM is boolean; remove the unused module exit path.
>>>
>>> Why isn't it modular? This is going to force alot of stuff to be
>>> non-modular.
>>
>> The TSM core registers a class. The platform TSM drivers register
>> TSM devices of that class. If a platform module loads before the TSM
>> code - the class is not registered yet so it fails. We could either
>> teach modprobe or have dependencies in the module or do this:
> 
> I understand that and Aneesh's patch is fine to solve that problem.
> 
> I'm asking why it isn't modular. They don't conflict, using
> subsys_initcall works just fine as a module.

it "works" because it is module_init() in include/linux/module.h:

#ifndef MODULE
                                                        
#else /* MODULE */
                                                        
[...]
#define subsys_initcall(fn)             module_init(fn)

and then the dependency problem again. Do I miss something?


-- 
Alexey

