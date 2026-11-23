Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795416168;
	b=baA7T8U+LEZw02FcqVEXohbaezMMvxWIo6Q2vKb12BKzZAFo7S9BPzPqejFufhqZyuiM
	 vzkz9Y0ZD2vUmoy82WusqZxNQfhonJ6Ep/BZUbl9XPBlwgJ7uJ14quXUZU52TZTilo9cp
	 1r465TANJYgengBw6XXUowa/4UvoPxvSnwDeeT5mUWS+EKOGVQsHTWD2ukbx42KxOQTt6
	 x+57x+J+Ox/r+lpCzZHqKJN7PGY6h3IJK4GCLB5PYM0jwgBOCSu16x+f8ZE3SjRV/3tg3
	 NsMTG8WROQxT4lM+u+s+G+/zyXb75GuH9LQU5KM1zOaPZO7FH+eDrZExrmyiunNVkJw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795416168;
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
	bh=pHh3X6JJdHxq2/niH+3LtBoYiZJY8jH8742cfNju9Y8=;
	b=lfuCd2GnoeQLUyVV7BRFS5AEN4OnWpE1v5U5GpHMdCyDQK4uiJH4OvrDbqj97rtxYg3T
	 3A+iBY2OP0BtyPvazuKWElu/n0NENHTuN091LgKt0NYXXANi7gxb/mT2pZuBUvQZF6TL7
	 XKc/OoGN4vqSspz0RFOSguIWJdgFe2rq7oT1+Tyj4vf8ubDuVcABaJG3AzJ7GxWJo+6+S
	 4123yUOg7/yZEM75mERIs7xSMYZpmc6zYRshSESumKa1HBNDJtsm9v5xKnGJHCm0RYtqo
	 iqR46FDUschB+5fROeAXGz1ehz1cgLftAwaJD49Lyf7jXCMw1SSa+18/iyauD+BhaUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=FcHquteg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.11
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79184606A33C;
	Mon, 23 Nov 2026 06:42:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79184606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=FcHquteg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fgmJnXjBwwNHMDnBGp9m+62XzUtXTfiubqMLdqaZtxN3j8tPHVajyWzAanLZ+EM/LH2tNaacjNDlaqRVEqbRatAPNVelkQDFeqRjUfWAZo/lWYpkUAUAxGTqZLKi7hu1a8NyLejNxq5M4ZfQiq50hWBaXa8LiEQ5JAGWu+ZoUEUmNVwnDv/Gyy08zYlibvU9wnx7QIHICue4JUInJK6TgnPlEwkPaW3RuhlFFTXTWEiyE5DyjbCYb+Gsxrwx1UOaF5j6HruhZWN3/Yjz0PSzQz/TcXAE7KNHlU9JaKBzSDIOhQAqSUR3DCdQLycvKWaQppuRS+5C/Ao8PWlGfkunxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHh3X6JJdHxq2/niH+3LtBoYiZJY8jH8742cfNju9Y8=;
 b=h3tIi2kjqy0n0MJZHzeEa3IU2IkgXxztrIMoCy3AdQ6ZTrAvJObalCLVEzC06/zFuh31yJYM+ymyITZTzBqTraK2IMWAhPr7bUzGPJJF1xV+133MTk7B2Z8J2pk3ft6nikFoHHXaiMCmKALzKlx7lkDMGgms4bLgmzQH0U5d80KBbdg7uWAgQB0Q7VL17DxUzYHqfzUNs1eiqoA1YmDgrAw+LYNEFtPpx43WVuNgp/fjyhv9tLzzDZ3GwptoXsjdQ0cf8U2PA+lQOwDuNszOciH/B91NeJP/zMv8BasrQpLLD/AqeS2GwA2xJFhHELxQsSG+sWvf65QC/rtsOWiA8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHh3X6JJdHxq2/niH+3LtBoYiZJY8jH8742cfNju9Y8=;
 b=FcHqutegGO8tme1DGpYUcyZ+6Ko6mgZBHK25yXu3epws7I8771OtAcolgfwTFcBtljmqHRFhTnWwOODiM08urnfx5QrsrJ1mPNoXLtGEhtob/+o5b3A9v2FWm4GiJtoXEeh3Nvnf6w0GxG7M0URJwSBl8ormQjdPIADzKB7yeTc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by IA1PR12MB6409.namprd12.prod.outlook.com
 (2603:10b6:208:38b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 06:41:01 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 06:41:01 +0000
Message-ID: <3573001a-24b8-49f3-97c8-7a414c88deb4@amd.com>
Date: Mon, 23 Nov 2026 17:40:48 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/13] iommufd: TSM-backed virtual IOMMUs for
 confidential guests
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
 Jonathan Hunter <jonathanh@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Krishna Reddy <vdumpa@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
 Nicolin Chen <nicolinc@nvidia.com>, Robin Murphy <robin.murphy@arm.com>,
 Samuel Ortiz <sameo@rivosinc.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Steven Price <steven.price@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, iommu@lists.linux.dev,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-tegra@vger.kernel.org, patches@lists.linux.dev
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261116081935.85372-1-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0026.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::13) To SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10)
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|IA1PR12MB6409:EE_
X-MS-Office365-Filtering-Correlation-Id: 62dab75d-3ff5-4728-73cd-08df492cbd15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|6133799003|22082099003|18002099003|3023799007|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261102123227099003|261021123027099003|261022105027099003|261021135927099003|261009223027099003|261021121427099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	1WrV9HONL6/KVp1tNng6eEZaXVtm8YdpybbLARDp/YaoiRwfeO1mVA6+nUC3rT4fNWURDdM56+S+LnmaTUOVP8fprJ5HGGyNFB+lLTuUWmXjLJG8KNRLqLaeyEHMWHRPVrCEzDxPUbxYwmHRG6YtiQo2+UYy6aM1iZvZ7DvcmhdrQQZy7V5cO4aQdXOnp5HqBTM7a3yJ/+ybFdE5RwZhaTU9Mq3zozbW9GsNVzk1uZT088gTHuxa1LEYomMTTUoJ9d/77Ix/80xGxjjwxSjycf/bdGF9ZcdFhQVCD76Mp+n+BmMtEpLfmie3YG/uG9IEvvBsik2oQKJHrW157rsEGZZBvmEOZf3B7AfkGCAWimyTiJuKHSJp1YuibZLc1wd7QsM3MYUrN8YSKRcwJb7scFsGW9YZWwRF4Q9R1TLGMVoGnhhmpn54sT5eI1URVFTVFPxA3lCa/fAqpxqHpFK/umUy1kA2p4AfkunJTkZWwToODM7IrxPdUrNvBvEU4PhQgT2Az35MEw8wsnu/2jU/TPlDRYwM9W8FN+T7a8HRUJ3IOK+8OkmbD83HLYscsMgh/QY/nQoGDj7l6aCGzFgaL/Ql/BcPSaMugznI7TDrH+UDTHJuu4CR5guGcTSKwbwp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(6133799003)(22082099003)(18002099003)(3023799007)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(261021123027099003)(261022105027099003)(261021135927099003)(261009223027099003)(261021121427099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDg4Vkp0VjYrK1hmbzI4b1JycmFLS2JPL01ObEZscEZ4UlUwNlJ4RUxxMzA0?=
 =?utf-8?B?SXYwdzJKa0Q3ZmgvbjJGQTBYTGduUjJZd0w3bHE2ZEN2Z2lybG5ybnJFVWlR?=
 =?utf-8?B?cTZXenNPVHZoSnFqNnIyVkdvbzNjOTFZUFhsOXBLNzhzZWdLaUdNVVgrZVpo?=
 =?utf-8?B?cUhqY29ETkRzbjlVL3Rxdy85Tm5hT1JuYTJBK2RCTmgrT25pR3hjenpiVXdy?=
 =?utf-8?B?cDRlRG1LRVRtSy9mU2NNekIySEhRSjBrZjRDakVnQm1tTUlXTThRNmdqSlNY?=
 =?utf-8?B?WW1JaHBRTW1oUU1tQmhNMlZlUnpVMWN5a1JRTHJ2bU51SVVZckN0ZXV1bGhH?=
 =?utf-8?B?OUdMbWR1VDVDMk9lcXRJZWs3eUVNQm4xT1RpWitJL0t5aGJ2WjhZMmk2NUhL?=
 =?utf-8?B?cFlOSUY3OW9TazlnaXhjN0FYN2psOGxUc1NpLzc0eHhGRzJDTU9zbjd4SXU2?=
 =?utf-8?B?VGd0am8xa21jVzlOWEkrUGZjTHBldFFwOThlREFwS2F1S3paQm5VQXdZdEpV?=
 =?utf-8?B?RVNOTHhzMDd2OG5MN2txUTdTcXNjYzdFRmRDbEw5eWFJZy8reWhtS0syZVky?=
 =?utf-8?B?SmlhVTk4NFZOOE5tNXJTU1hKTzNBU1lYTUs1WGJhOFpiVCtuMkR6NWYxdEJR?=
 =?utf-8?B?REwrYW1GSXdwcWpsMEc2eGJmSUR0UnQ5VW9rMnlYMktkTzZmZC94SFo1aWcz?=
 =?utf-8?B?aDk1cDdMZTZockgzWWZUT3BKaE9IR29sWWxQK2dEbU9VWEJEcWNCelVsV3Bq?=
 =?utf-8?B?Zzg3WDQ3emRrN0MyY3lNeThrOEVTQzlKVUZUMEFacDhvckV1ZjVzUGhlK1Ir?=
 =?utf-8?B?YXN0ajBYUXV2ckVteWFWV0J0OThna0tjRUtNd2xReDlwNEV4ZHVQVTZSVGxM?=
 =?utf-8?B?L1llY0VyOTI3TjVuVFNmT1BsNnZWZmNDaHZXNHJqZktDNHhBaFFOZ0xWRGZH?=
 =?utf-8?B?M2duNi9NRGtPSklWaXpKYjBkSkpKSUppemEzWTBXTy81WkJaMmI3cTFXdWVl?=
 =?utf-8?B?Y0E5SHI5Sk9QSEQyOUhKbzRKdE1ldFFwalB1SnJlalVNcWEyaTdSMUhRNVFt?=
 =?utf-8?B?MW9xL3l5SjVhK1h1bkM1cnpIamk2bGV2dkJyVDRUbXRHSlhzNVdmckxUalM0?=
 =?utf-8?B?Y0h6Uy9vcmN2ZHZmM3JuS2gwekhrbkgydC9GTUVtWlV1T1BjeWdjc0JieHl1?=
 =?utf-8?B?RFZIZ2p5V0FYVHpKbzRnTGpncUY5WVlGMHIxcDhheVNrdmlLVjNzZGFUWTJy?=
 =?utf-8?B?MzNPaHYycjlNR0hjdTdSaDhpUTNZVEtPTVhZTXdXOERsdEFWc0pRNjRVMFF1?=
 =?utf-8?B?M01GVmM5dS9iOWRTVGRzWGhrUUhYblFvb2IwYlFXTjY4WHV2KzdpM0RDbHJi?=
 =?utf-8?B?YXJEb2o4TmM1dHl3Nk10S0l4aW9OdC9PZmI5NDdUR1ZtckI5THRjQXo3NS9D?=
 =?utf-8?B?OGV2bDNFM0JKMjd5YjlMS3ZGY25Lekc2cFVvZnFVY1QrQWNVRC9QdjBoNEJq?=
 =?utf-8?B?cmVxd20wMG9mL2NsNnhIQ083RStJSGhyc1B6VERlUEcxKzc4emg1Z3pDS2J3?=
 =?utf-8?B?U2pmWXhZREliajhjYXorOEdzUzM3d096Rm4yNmlnVTVXRjBHVzU0TDhLOVF5?=
 =?utf-8?B?MXZJaHRWVEZKM0ZmZEJDUGJGTzRXdFlwSWxMN2RTaTBpNUZRQm1VRGhvL2hP?=
 =?utf-8?B?c1pyTFR3bUYwVmhkdHdVa1lwSjRhN05yVklYNXNWZ0JUVVRYS3hkclA5VHcv?=
 =?utf-8?B?YUpWSER6dkw1akVSQzV6MENvc0JSY09MNHJLemQzdldtdFRkNHBZZnJWK05B?=
 =?utf-8?B?MytPR1U0SEIvanBsbEJhTEdpaU0xRnA1ZHd2akc4Tk4yaTRTaERXVlJ6WVdF?=
 =?utf-8?B?Y0Rpa2xCNURDN1BUSnhYUnFYcGZFV1Zta1l1a0FaN3NJZWowUlJCLzFURHU5?=
 =?utf-8?B?S0QybzQyZ0t2bWhZVjZlYU5tRkVoU3AvODBJckg3ZVBJVFBGV2JROEg2dmFu?=
 =?utf-8?B?UjFyZjhYa0lUQk1yT09ycGdMNVp3Nll5emtZdFZJMk0wRXR5Vm1SbzNUNHBw?=
 =?utf-8?B?VGsrbjkxeEVDSENDd0M2ak42elFaRzYzMDJHdk5yK2hDYm5vZWhQS3MxcVhZ?=
 =?utf-8?B?KzVOTFpmYXdFNHVGZEE4TVJ5R1RVUjY2V2g1cXpzYTYvYmdVc1d4dE9lbXNL?=
 =?utf-8?B?ZEtMNTVEWE41KzJRTEFlNVNnYzBzbjhKU3ZuZTlJaU43WnlSdWJTRnJjY0x6?=
 =?utf-8?B?YlNiTWQ3QVNlelU3RlUwWnNHd1FtWnVCTWF2N3ZQV2k0R0Fac3htd2dFWTVt?=
 =?utf-8?Q?JWU4RJoiu2j9fHxgaE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62dab75d-3ff5-4728-73cd-08df492cbd15
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 06:41:01.0584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VH20lg8cUnmIBPd3OkOBF6aUnncGiBRw0lvbI/f/VsJ4DgI7IaJdeWkYj/X9dTcC/kwPpT4zN1NvL6Dv1KZrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6409

On 16/11/26 19:19, Aneesh Kumar K.V (Arm) wrote:
> This series adds IOMMUFD and PCI/TSM infrastructure for assigning PCI
> devices to confidential guests. A TEE Security Manager (TSM) can provide a
> virtual IOMMU (vIOMMU), and an IOMMUFD vDEVICE object represents a physical
> device within that virtual IOMMU.
> 
> The series adds a common framework for operations on vDEVICE objects and
> updates lifetime management to keep the VM and device-security resources
> available while those objects are in use.
> 
> The Arm CCA backend is provided in a separate series, together with
> operations for TEE Device Interface Security Protocol (TDISP) state changes
> and access to cached device-attestation objects.
> 
> The full series, including the Arm CCA backend, is available at:

nah, it is not :(

> 
>    https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/7.4/tdisp-host-rc3
> 
> Notes:
> * Codex was used to assist with commit message formatting and code
>    rearrangement.
> 
> Changes from v8:
> https://lore.kernel.org/all/20261104161632.3547423-1-aneesh.kumar@kernel.org
> * Drop the patch taking an additional KVM file reference for the
>    iommufd_device lifetime.
> * Rename the IOMMU_VDEVICE_OP reserved field to __reserved and return
>    -EOPNOTSUPP when it is nonzero. Keep the ioctl table entries ordered.
> * Collect Reviewed-by tags.
> * Address review feedback.
> 
> Changes from v7:
> https://lore.kernel.org/all/20261008055955.4014342-1-aneesh.kumar@kernel.org
> * Replace IOMMU_VDEVICE_TSM_REQ with the common IOMMU_VDEVICE_OP ioctl
>    framework. Keep operation definitions and callbacks in the Arm CCA
>    backend series.
> * Replace architecture-specific request dispatch, TSM result codes and
>    buffer-residue returns with operation-specific request/response formats,
>    a zero-success return convention and resp_len for response lengths.
> * Hold a KVM file reference for the full iommufd_device lifetime and
>    require matching device/vIOMMU KVM associations for vDEVICE allocation.
> * Hold TSM device and user references as well as the backend module
>    reference for the vIOMMU lifetime. Make unregister reject new users
>    and wait for existing users before tearing down PCI connections.
> * Coordinate DSM removal with TSM unregister so the completion used to
>    wait for users remains valid throughout teardown.
> * Complete PCI registration before publishing the TSM device and roll
>    back PCI registration if publication fails. Require PCI operations
>    when registering a TSM.
> * Move PCI/TSM core code into drivers/pci/tsm/core.c.
> * Temporarily disable AMD vIOMMU allocation while its interfaces are updated.
> 
> Changes from v6:
> https://lore.kernel.org/all/20260917140159.1163281-1-aneesh.kumar@kernel.org
> * Replace the IOMMUFD provider registry with per-device TSM operation lookup.
> * Move vIOMMU allocation size and initialization into the selected vIOMMU ops.
> * Select parent HWPT policy from the vIOMMU ops flags.
> * Pin a vIOMMU's TSM backend module through vIOMMU destruction.
> 
> Changes from v5:
> https://lore.kernel.org/all/20260525154816.1029642-1-aneesh.kumar@kernel.org
> * Replace the TSM bind/unbind interface with reference-counted contexts.
> * Add the IOMMUFD vIOMMU provider abstraction.
> * Route TSM guest requests through vIOMMU ops.
> 
> Changes from v4:
> https://lore.kernel.org/all/20260427061005.901854-1-aneesh.kumar@kernel.org
> * Switch VFIO/iommufd to use struct file *kvm_file instead of relying on
>    kvm->users_count references.
> * Define TSM request scope values globally in iommufd.
> * Rename the ioctl to IOMMU_VDEVICE_TSM_REQ.
> * Address other review feedback.
> 
> Changes from v2:
> https://lore.kernel.org/all/20260309111704.2330479-1-aneesh.kumar@kernel.org
> * Bump the series revision to v4 to keep it in sync with the dependent CCA DA
>    patchsets. There was no v3 posting.
> * Drop [PATCH v2 1/3] iommufd/viommu: Allow associating a KVM VM fd with a
>    vIOMMU
> * Add two new patches to associate a struct kvm * with iommufd objects:
>    iommufd/device: Associate a kvm pointer to iommufd_device
>    iommufd/viommu: Associate a kvm pointer to iommufd_viommu
> * Address review feedback
> 
> Changes from v1:
> https://lore.kernel.org/all/20250728135216.48084-8-aneesh.kumar@kernel.org
> * Rebase onto the latest kernel
> * Address review feedback
> * Drop the TSM map ioctl; the KVM prefault patch will be used instead to
>    ensure that private memory is preallocated
> 
> 
> Cc: Alex Williamson <alex@shazbot.org>
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> CC: Jacob Pan <jacob.pan@linux.microsoft.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Krishna Reddy <vdumpa@nvidia.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Nicolin Chen <nicolinc@nvidia.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Samuel Ortiz <sameo@rivosinc.com>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Thierry Reding <thierry.reding@kernel.org>
> Cc: Vasant Hegde <vasant.hegde@amd.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Xu Yilun <yilun.xu@linux.intel.com>
> Cc: Ashish Kalra <ashish.kalra@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: iommu@lists.linux.dev
> Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-coco@lists.linux.dev
> Cc: linux-pci@vger.kernel.org
> Cc: linux-tegra@vger.kernel.org
> Cc: patches@lists.linux.dev
> 
> Aneesh Kumar K.V (Arm) (11):
>    virt: coco: tsm: Require PCI operations when registering a TSM
>    virt: coco: tsm: Remove the device from lookup before PCI teardown
>    virt: coco: tsm: Complete PCI registration before publishing the
>      device
>    iommufd: Add a vDEVICE operation ioctl framework
>    PCI/TSM: Remove the legacy guest request interface
>    PCI/TSM: Keep connections active while device contexts exist
>    iommufd/viommu: Select vIOMMU operations before allocation
>    iommufd/viommu: Allow PCI TSM backends to provide vIOMMU operations
>    iommufd/viommu: Allow vIOMMUs without a parent HWPT
>    PCI/TSM: Wait for device contexts before removing a DSM
>    PCI/TSM: Wait for users during unregister
> 
> Nicolin Chen (1):
>    iommufd/viommu: Keep a reference to the KVM file
> 
> Shameer Kolothum (1):
>    iommufd/device: Associate KVM file pointer with iommufd_device
> 
>   Documentation/ABI/testing/sysfs-bus-pci       |  15 +-
>   Documentation/userspace-api/iommufd.rst       |  44 +-
>   drivers/crypto/ccp/sev-dev-tsm.c              |   4 +-
>   drivers/iommu/amd/iommu.c                     |   3 +-
>   drivers/iommu/amd/iommufd.c                   |  18 +-
>   drivers/iommu/amd/iommufd.h                   |  11 +-
>   drivers/iommu/amd/nested.c                    |   4 +-
>   .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  37 +-
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   7 +-
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  16 +-
>   .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  24 +-
>   drivers/iommu/iommufd/device.c                |   7 +-
>   drivers/iommu/iommufd/hw_pagetable.c          |  14 +-
>   drivers/iommu/iommufd/iommufd_private.h       |   3 +
>   drivers/iommu/iommufd/main.c                  |   3 +
>   drivers/iommu/iommufd/selftest.c              |  33 +-
>   drivers/iommu/iommufd/viommu.c                | 155 ++++--
>   drivers/pci/tsm/core.c                        | 448 ++++++++++--------
>   drivers/vfio/iommufd.c                        |   3 +-
>   drivers/virt/coco/tsm-core.c                  | 213 +++++++--
>   include/linux/iommu.h                         |  20 +-
>   include/linux/iommufd.h                       |  29 +-
>   include/linux/pci-tsm.h                       | 154 +++---
>   include/linux/tsm.h                           |  41 +-
>   include/uapi/linux/iommufd.h                  |  36 +-
>   25 files changed, 880 insertions(+), 462 deletions(-)
> 
> 
> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3

This is v7.4-rc3.

> prerequisite-patch-id: 121492d71cc22b2adbfdedd668868c5a449ad764
> prerequisite-patch-id: ed31fd728f0adba3d60dcd6f3bae8da1a2193bcc

What are these two? Cannot find them any tree... I really want try this all but also trying to eliminate guessing...

Thanks,

-- 
Alexey

