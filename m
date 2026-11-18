Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795000347;
	b=LWW33dzZ/D7atbEJPSokaBCRUu2urA93Q4ZpfuXY6pjXfdpoinSIMN7LFGcmLzEc1N1U
	 Q9bHrH5F2JHm0w05V8QlDBBgZnScHExoUgeGzKBLSbAeaqn1BfMnWS3fTlPLmHqhUVh6d
	 Bm3v0ppQhISeFY3tN5MXF7M4qKRbNVAKDEIsoS+vavrRu6371L1dUz016GNn7JyUwISzo
	 QnTuAGBqvlMTCJaRpxYm4ort7doIac9W1yWKWIsXzH/Mrq9sAMzv+04K7gAhp/z8kdNr9
	 Ufz1qhpn0ZZ2yrMH22mtQL7m6yZweHpc4fMAbx8hlsqw32LEkmHXcmr5kk4lLk2UTtw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795000347;
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
	bh=+eh2cxGFPQm7S8ZHGLYlf1oqhCefK+TongA9j/n+6lE=;
	b=Cc3nzC+3qQRuAnfDXNKtiohaFlE8yQfgRKszAgwngdR/asqGL0de0JJy8PTEUyakFT0p
	 8G+NL/14saVfzegtDmMos3D5OnAlCCR/2E4Ivmoasvspw1Y5e9nIiPl9kVI5qlu5Xbk/T
	 FFLsNUnb4Id2XORAunkU3Z/pHNkjiQyu+zuL3rAgZmWdYhHZ/GWK3IfIcEKEqthkdROwg
	 gk9Arz1DEG1IM3wr+5iea1GzyTjqINkYv1+5/1ML3Nbg45+6gLxozF4Eolgk0iVl58/BL
	 CORZlqVkLLpOzNx52qILGBHPqJ/jfm21YVj2+Xwfq8+AXkWLZq8junUefYemYSGymbA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=JXmXA8XC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.28
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013028.outbound.protection.outlook.com [40.93.196.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2FE606A31C;
	Wed, 18 Nov 2026 11:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF2FE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=JXmXA8XC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w/x3OqQLK+/O42OgqtMj9ddysJXttqJVRCMF/dLqKl2nk9F9ksFnJg2ggyyBECC6pC/bU2/hxcRY5TGJ861FlILtCzyoQjjTGt4Ko0Gl4PID6U4iAVDbRqwcxNzqW5cBgTYr2q4FkT5QtD8q4R2zQtQozKhe/ciKUD9WVGms56aXWZCDegbZ+F5/LpErLfWgJQbIzBetuZiGiqgv/awHL/K1mLf3KXPjKh1xQgjXC1I/lvdW2nmnANSlU8c5Ylb6h9dwWoDE7yR/q+zRvVi1j98AbMD678FKPnp1L0qKotT59EoUmFnWppJQZrKnGZVlDS2RkCQWzXaKuYNZK9Qa3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+eh2cxGFPQm7S8ZHGLYlf1oqhCefK+TongA9j/n+6lE=;
 b=pUkSkP1PGKEnjjDcaMWO3QiwWFYAlqUgBEmi6sNeHlUOW7BdlKCGYRnRQxfD0ZXtusW9FxKsf7BgYsNu8BoYUYWyrxeWDLBWxqVzoVXOKSDukT/RlLUailFWl/Rtjvvz3+vmPOiTBJ+gQXNux1cpDMpeftZSKvFWME2I9WGJukepDOWBuyPPKBiDyzPKqI/zF7PXmzuL/qWIengh9Sga0D4fGSz+dcll/1kgTuusqYOIgj119vb2d6sqzZWjptYFwMjmQHmR433NRNM+9vDFPUgmW0Fg72QWcaxBmqkdCwNEzRmg4cLYYh8OG49KwpLz8C+GHF141dKDYKWwYLpvxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eh2cxGFPQm7S8ZHGLYlf1oqhCefK+TongA9j/n+6lE=;
 b=JXmXA8XCDOh2C9lPtflsSB/lKrojIkh6zT4UWuSNhrayL3ETJrl+ZoJFyRqPSKOsOz4f/96UOgexoQswYPDqxM5SUH2BJCwSPpquSHTF/T2Wxf1Nuy44obW20ZCyKpvSRazki0M5+FXsrtj+Xnfx3vMXkZ9dh1rPuZddaqRyMB0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by DSVPR12MB999286.namprd12.prod.outlook.com
 (2603:10b6:8:41a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 11:12:22 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 11:12:22 +0000
Message-ID: <06d99ff3-3fae-47df-a27e-f2b45d8d3852@amd.com>
Date: Wed, 18 Nov 2026 22:12:17 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 "Jiang, Dave" <dave.jiang@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Alistair <alistair23@gmail.com>
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com> <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261116143319.GA2245175@nvidia.com>
 <DS4PPFA84FA90FC9031C253514720694AFBE77B2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261117142027.GI2245175@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261117142027.GI2245175@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0077.ausprd01.prod.outlook.com
 (2603:10c6:10:110::10) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|DSVPR12MB999286:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fe67a80-55df-45cb-342e-08df4564d160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|18002099003|22082099003|261009223027099003|3023799007|5023799004|11063799006|56012099006|4143699003|261026121527099003|261102130727099003|261102123227099003|10067099003|261028144727099003|261026140227099003|261022115727099003|261021121427099003|261022105027099003|261026130827099003|261021130227099003|261022075727099003|261021135927099003|261021123027099003|261022113327099003;
X-Microsoft-Antispam-Message-Info:
	w2oBIJNdzroznU2rjLthHiZk3F6zMDIORti1yHLHgfL15w8xcQiQ5NPgNjvpp1MlI2S+/HyQQIN88xt8Fmo7flDS9RIa4LTTdeZAtvckUKpdZUEVQmxcrrtnaveJO9PoE41mUpkF8CZEBCsG0/XV489xxSYt/po80xq6rAN02lS+9/wEawAVBaS2uEds5LbHcClKpmZxa2wDUiIA+gxG8uKBgG927pHekiNXt5LnS4R2gavBj8XUbeD8bfe2radNssC+NPqW+xq7hwEza90qzo4cwuZSSTGKumIPcglck5tu4vKFz7ajRb/BHbFXteNO25oosYVl09WLNepXgj2vQZF9jvKWmUO9/k7uJKltx5f9WbH9zyeaUdMdaFQ7Txfaj1j3CZXxOxBFHnjEEA+tIWSuqzOzZLl7izCqNSqj5E4H8C37GYiv7VBN6RyYahFv0NS6u+rJ9Ziw+ChTRPR6hENJUgXClBFExXyl2U45QCEHhsVYlcfa7Nj3MaI1Elnpx7qPZtEYQGNJupFsLOOLa9WrpDFkoQHe22mP07dCF7mJtYELsnO9KvHstMmcduPgTTQNBetYM8d4ysrmn6X/RksVwwLMiHiNtZUI7EK1Uv2F/dp722VCcNdy628K2qI/7MaZlpnODg786qxApdbOhA6dWNFI8CNalMR8gKUyXwo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(261009223027099003)(3023799007)(5023799004)(11063799006)(56012099006)(4143699003)(261026121527099003)(261102130727099003)(261102123227099003)(10067099003)(261028144727099003)(261026140227099003)(261022115727099003)(261021121427099003)(261022105027099003)(261026130827099003)(261021130227099003)(261022075727099003)(261021135927099003)(261021123027099003)(261022113327099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjdwMUUwRjRUbHZIU3FpdnZpQWNaZTdFQXBBaWdtaGg3TGNCRFpNWVd6QkVt?=
 =?utf-8?B?cVhpZS9qSkRDNVVSbXA0aVIrTzZtR3E1S1g2Z0pFTE9VUnBlR21NNkNlS0hh?=
 =?utf-8?B?TnhLQ3gvQ3FJajVLOSs0ZThEYzlWOW1tdU9ZV09UaUptWCswdFJxdHRsK3kv?=
 =?utf-8?B?T0hSdmFmV2xRZmFRdUthc001R2N1bXdmZGRzRzk3YlMxYm1LMGVFZitHZDlh?=
 =?utf-8?B?K0x3OWNGK3gxSk5vT2JlM0RGbVdlOEpEQzBIUnovdjZ4eDB4d2dJSGVIZVkv?=
 =?utf-8?B?TDVEZkFvSStSTDhwV0JaUTlPVXhsenVmSUdOSWtKWVljdnVVY3U4UHVUTkFK?=
 =?utf-8?B?dXZFUnh4VFdYL0tBZmZaQzZQUlRCVkV6bHpGMUxBbFc4SWN4cUNkYnhlR0J4?=
 =?utf-8?B?SGlTOUtadDAwYUphMmhWN2hBalhiUWpsN0hmb2xYSjV1Qyt5UlBMb1M4UHJB?=
 =?utf-8?B?eTFjRndFUjRFVTNLbGRhVmhVdHVsNHh2c3pFQytuZmxOcWVmMEF2NnFOTjU5?=
 =?utf-8?B?L1RjTTZWZE12cVNxcEx0R0R0OXlvK3ZZemZrSnNNblJLaEFHbk9RdGhsVkRn?=
 =?utf-8?B?ZHZsV2pDQVNwaUZKSDd4ZFU4aG94bWNHbWcwVzMvVkhRak1vTjIrdTdON2Fs?=
 =?utf-8?B?SHNLeHB3RTl4VWN1U2tkQTBDQ2dISHlyUFRuajdhK2tuYVZKcklPM3NLakRX?=
 =?utf-8?B?djErZlYzU1lSTng1ZnpEZjloVGx4RHR1d0hDb2NoZXlBUVVidkFVMXlZUncv?=
 =?utf-8?B?WVMzb0puZlNLczlIOENJVXlmOHRyV2tVbFNvRE1wQ2F1TS9Ia0VRRFh5bWFX?=
 =?utf-8?B?VXBkK0ZRQVhhdzR2VEZ3SWxkMW5VZk5HbHdiRC9oaE9veUdGeWdtMzJtUDFv?=
 =?utf-8?B?MEh2NHJJVXRBTkJPVzVWYk11Z21IbFBIMzVZZUJPSUhDY1N3V2lhek1aWGxx?=
 =?utf-8?B?TUYvdXJWM1BnWlNJRDdXakZ3bm5aQ0FxVG9yN1JlNmtyUXRlY1RNOHZzSnRm?=
 =?utf-8?B?dzk2a3lTWjRVRllZSnBkK1VHT3BvY0tCSFZWaERQUFYzNW4rQnZsbTdKZnhM?=
 =?utf-8?B?SlAzUm1lbXZlbTVHMzh3dXBkRHpqL21tdWo2N2ZSUjF5eGtEQ0I1eG9WbmhD?=
 =?utf-8?B?aU9UalZRUWtpWG9hUWg5L001WExjblcvaG8wNHY4OGtwUWdGVml1TkFKbEVa?=
 =?utf-8?B?SjQzcTNWc1JzZ2xJSlVaOVV1Nmx4bTJhWUVmd0RUSklGTE5xY0xGMC9QcFNP?=
 =?utf-8?B?UU41ai9OekhsZEl2WG1HNmVpa1VGNkZENThEQ1k2b0YvdTZJMDlUZXRFK1Jr?=
 =?utf-8?B?cDA5c0lILzFTN0hldUpNdnp3TGI5WHVDZUR3L1RYRG40cmFBdmRyM2JCVVgx?=
 =?utf-8?B?RnRaNjlrbjZDZVN0Wms5aFE0MndjY2ZIWnRKVmlIYjkvTWkzQmpWemxOdlVq?=
 =?utf-8?B?ZkY3L0xEZFRBVlpFMlpicyt5WTBINjFCY2VxY2p0cVBnbmxXKzVPRDlpbHZo?=
 =?utf-8?B?QzgwQzVxZ29tSGIvZjRSci93NHlwSjhJZUVsNHhFT0dndXJva0JmUDdNUXJv?=
 =?utf-8?B?VHA1bXNXN3FCMFZWUTVyY2UvVENyQkJpdGtITFhsdUFkeWhWemFtdUljdVBS?=
 =?utf-8?B?MEwxZTFPUi92OHptWXRlTXhvUzFGdno1eVZCa3UzY21ReFdvamo3WEJSSVZ4?=
 =?utf-8?B?MUY5di9BYmhaZDN4SGtRdEhpclN2MEJkaWdMWXo1SDVUcTBIZ1pxWVFtK0hY?=
 =?utf-8?B?QXJKNkpXRjUwRGZDTkc5cVZpTjltYWxLU1JPRXV5RFpZYzVyVUpweU90bzBF?=
 =?utf-8?B?Z3FXUzU3U1NiNVZ1VE1kYk8wSXVLZTNVejFGZVVxWWdCWlZIQWdHUkpwOUN4?=
 =?utf-8?B?cExIbDVxdjlGaUIwTnBuUDNSWktxQVRaeENyYmo4YzJwM1hqQm8zaUZwVTY4?=
 =?utf-8?B?dWFVOU5DYXh3WlZIWFJKc0cwbjZDLy9hb3NPV3RRM09HSUtDVzBNRDB5dmla?=
 =?utf-8?B?bGsrbTU1S3BZbjBzTzFIdUovMGhaaVROOU90ZWV2VURLNmRlZ2NtbEpCUGty?=
 =?utf-8?B?dkxBOFVPMnpvWDcwR2dab2t1UGkyQzMvZWM4bXNZNlI1dk93dnVGNFZMYVZw?=
 =?utf-8?B?dGhCWHVDYkdwMnBYN3NjUGpnVFVKZUdPa2JVcVNDOGhKQTR1NndXRDZGV2tR?=
 =?utf-8?B?c3o3YnQ4aGpXdXpUNWFBSlBTaEhIUFpTTDNTZUl4c0o4T2h3T3hlelIzem9w?=
 =?utf-8?B?YWwyQkhpdnFIOWN3cHNOWlpsVDJjWitVTEd0bEY0WFJOdk5LSFZndllFdGNK?=
 =?utf-8?Q?wC9jWX1hDi1ZXCPTuA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe67a80-55df-45cb-342e-08df4564d160
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 11:12:22.2472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nysz6+cY7Wc3KxRKrVBeps4NLf6Y9O8OVXXq0dOXHhJQ0Th+baxo7IEyBdvJlx0B4ak01o5/muTnOkxsbSEKOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999286

On 18/11/26 01:20, Jason Gunthorpe wrote:
> On Tue, Nov 17, 2026 at 01:00:03PM +0000, Reshetova, Elena wrote:
>>> On Mon, Nov 16, 2026 at 01:38:50PM +0000, Reshetova, Elena wrote:
>>>
>>>>>   1) No easy way to get the VCA, no easy way to do capture
>>>>
>>>> My understanding is that VCA must have been included into
>>>> SPDM_DEVICE_ATTESTATION_INFO_T from the beginning, it was omitted
>>>> by mistake and we asked to fix it as Dave already pointed out.
>>>
>>> That makes some sense, but it just makes this struct bigger and
>>> worser. As I explained ot Aneesh I'd rather not have a VCA at all but
>>> the transcript that includes VCA (or is maybe only VCA) with preserved
>>> message boundary markers. Userspace can compute VCA for the purposes
>>> of the signature hash.
>>>
>>>>>   2) Wrong digests design for the guest.
>>> SPDM_DEVICE_ATTESTATION_INFO_T
>>>>>      is a terrible idea since it is not grounded in any spec. The other
>>>>>      two have multiple guest digests computed directly over spec
>>>>>      defined objects.
>>>>>
>>>>>   3) Even if you like SPDM_DEVICE_ATTESTATION_INFO_T it includes
>>>>>      TDISP_CAPABILITIES for some bad reason. Nobody else even
>>>>>      exports this info from their TSM or digests it. Thus Intel would
>>>>>      need unique API for the VMM to even build
>>>>>      SPDM_DEVICE_ATTESTATION_INFO_T. Not nice.
>>>>
>>>> I dont think there is an expectation that there needs to be unique API
>>>> to build this structure (I think we can hide it in the tdx-specific code), but
>>>> your point below is valid: this SPDM_DEVICE_ATTESTATION_INFO_T blob
>>>> needs to end up on the guest side because only using this blob the guest
>>>> can currently verify the evidence of the SPDM connection establishment.
>>>
>>> Right.
>>>
>>> Any every other arch can build their digested data in the VMM using
>>> the standard APIs because all their digests are over standard things.
>>
>> So, yes, if we dissect this structure, then the unique fields that Intel has
>> are:
>> HEARTBEAT_PERIOD, TDISP_CAPABILITIES, TDISP_VERSION
>> (I am not listing SPDM_CAPABILITIES, this must be part of VCA)
> 
> HEARTBEAT_PERIOD will come out of the transcript as a field in
> KEY_EXCHANGE_RSP
> 
> SPDM_CAPABILITIES is in the VCA
> 
> TDISP_VERSION is in the data from GET_INTERFACE_REPORT which needs to
> be a common API. Though this is probably the selected version not the
> offered version.
> 
> Only TDSIP_CAPABILITIES is unknown to userspace. I don't know why
> anyone needs this or why it needs to be digested. Nobody else did
> this.
> 
>> Here I also have a generic question: does Linux plan for the host to
>> implement heartbeat (can be very useful to understand whenever
>> the device is still alive and didnt silently terminated session) or not?
>> And if needed, how do other coco arches expose this info?
> 
> I don't know. I haven't investigated this question..
> 
>> TDISP_VERSION is more interesting.
>> It may be security sensitive, i.e. assuming some
>> problems later on found in existing version of TDSIP, new version is
>> released, etc. So, downgrade attack is possible from the host
>> side and the guest wont know, if vulnerable version is in use.
> 
> Huh? TDX module is trusted to negotiate the TDSIP_VERSION, host has
> nothing to do with this? The selected vesion is reported in
> GET_INTERFACE_REPORT and that must be digested.
> 
> AFAICT we don't need to double check the TDX modules work by seeing
> the TDISP_VERSION from earlier in the exchange.
> 
>> TDISP_CAPABILITIES are harder for me to judge, but I can imagine
>> a scenario where a guest without this info can be led to believe
>> that a reason that a given TDI is not locked with certain flags is
>> because a device does not support such TDSIP capability (while
>> it does in practice). But I think it is still guest decision to either
>> accept such configuration or not regardless of what device supports.
>> I will ask around more for potential problematic scenarios.
> 
> Right now I don't see a reason to even expose TDSIP_CAPABILITIES
> through the UAPI since no other arch will implement it and it isn't
> clear what it should be even used for.
> 
> Again the TSM is trusted to do the TDISP negotiation, we know this was
> done right because we will attest the TSM.
> 
> I don't see that we need to double check its work. None of this is
> even signed so a malfunctioning TSM or OS can simply lie in the
> report.
> 
>>> So if you keep this then you have to get a uAPI 'give me the intel
>>> blob' to build your VMM with. It is not impossible but it seems
>>> unnecessary if you'd just digest the right stuff instead of a giant
>>> struct.
>>>
>>> ARM keeps several digests:
>>>
>>> protocol_data_digest = H_rmm(VCA)
>>> identity_digest      = H_rmm(cert_1 || ... || cert_n)
>>> pubkey_digest        = H_rmm(<public key>)
>>> meas_digest          = H_rmm(GET_MEASUREMENTS || MEASUREMENTS)
>>> report_digest        = H_rmm(interface_report)
>>>
>>> I'm not sure VCA is strictly necessary. pubkey_digest is because RMM
>>> does not parse x509, since TDX does it also isn't necessary.
>>
>> Per SPDM the signed GET_MEASURMENTS || MEASUREMENTS transcript
>> actually includes VCA.
> 
> This is the hash of the message bodies, which don't include VCA.
> 
> You need VCA to compute the signature hash which is why everyone ships
> it around.
> 
>> And this is where in our original SPDM_DEVICE_ATTESTATION_INFO_T
>> struct VCA should have lived instead of being a separate structure with digest.
>> Would that be acceptable?
> 
> I'm not sure what you are proposing?
> 
> My concern is you have this digest over a struct that isn't a protocol
> struct, so we have to make a special API to pass your special struct.
> 
> Unless we can get rid of that I don't know if I care what you put in
> the struct, but the kernel will have to break it up and your driver
> will be more complicated than it needed to be.
> 
> VCA is immutable. It should be made available once and not repeated in
> every single measurement fetch.
> 
>> And yes, in our case pubkey_digest is not needed.
> 
> ARM's version of having the host parse the x509 is better, IMHO :)
> 
>>> What you want is an API to retrive measurements for a vdevice
>>> triggered by the guest that updates the guest visisble information
>>>
>>> And another one to retrive measurements for the host pci device that
>>> doesn't change the vdevice at all.
>>
>> Ok, so let me re-iterate to make sure I got it right.
>> You want these three things:
>>
>> 1. No implicit TSM measurement collection at the time of SPDM.CONNECT
>> (inside SPDM secure session) before or after LOCK
> 
> Yes. Host and VMM can manage evidence collection through the uAPI. We
> don't need to slow things down by doing collections that many use
> cases will simply discard.
> 
>> 2. Guest-requested (with a guest provided nonce) measurement collection
>> that collects only SPDM signed measurement transcript (that includes VCA)
>> and not certificates.
>> This collection refreshes the guest-visible digest of the SPDM signed measurement
>> transcript.
> 
> Yes, certificates should be fixed during the plaintext setup
> sequence. We don't need to refresh them, or at least if we ever do
> want to refresh them that is some other independent activity from
> evidence collection.
> 
> IMHO devices that change their GET_DIGESTS output while a SPDM
> connection is active are broken.
> 
>> The purpose of this collection is for guest to obtain fresh device measurements
>> after the lock in trusted way.
> 
> Yes.
> 
>> 3. Host-requested (with a host provided nonce? I would rather not, because
>> it feels we need a clear way to distinguish collection 2 and 3, so I would keep
>> nonce fixed to zero in this case or any other fixed pattern)
> 
> No good, it must be a host provide nonce. This is a host evidence
> collection and it must have a fresh nonce to have any security. If
> everything uses the same nonce it can be replayed.
> 
> Collection 2 and 3 are the same action. Anyone who can make
> measurements can provide the nonce and generate a replayed nonce. The
> only difference is if the vdevice digests are changed.
> 
> I don't see a reason to tag them, the mechanisms we have in userspace
> to ensure the nonce is legit and bound to the VM are sufficient.
> 
>>   measurement collection that collects only SPDM signed measurement
>> transcript (that includes VCA) and not certificates.  This
>> collection does not refresh the guest-visible digest of the SPDM
>> signed measurement transcript.
> 
> Yes
> 
>> The purpose of this collection is to allow host to discover device measurements
>> by itself and potentially make its own independent security decision like
>> it would do for native SPDM case (without TEE-IO) where host is a decision
>> maker.
> 
> Yes
>   
>> Btw, does any other arch provide #3 today? I am not able to see this in ARM
>> spec at least.
> 
> It is coming, currently ARM doesn't even allow the host to see the
> measurements *at all* which is a really big miss on their part.
> 
> AMD is probably broken the same way as TDX is right now from what I
> can tell.


The PSP always takes nonce in DEV_MEASUREMENTS and updates the digest. Nonce comes from the initiator, the updated digest is reported back to the guest via encrypted VM<->PSP GuestRequest mechanism.



> You probably also want
> 
> 4. TSM controlled nonce
> 
> A way to put the vdevice into "tsm controlled nonce" where the vdevice
> evidence collection no longer accepts a guest nonce and the TSM
> provides its own random one. This would be a permanent choice when the
> vdevice is created.

Is this any better that the initiator's nonce? Thanks,


> You may also want a way for #3 to run as "tsm controlled nonce" and
> set the initial digest for all future vdevices. I'm not really sure I
> understand how this "single collection" flow is supposed to work
> though to be sure.
> 
> Jason

-- 
Alexey

