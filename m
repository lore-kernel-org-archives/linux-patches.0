Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794876519;
	b=F1mftpI6Fg57l2EZoXzQAooR+D6T4PFMYMRinELUiN9pM5nu085oDLb2fOjSFvwGx/S5
	 g3ZhN7ncJ2+6gZL9XESLYjFGWCC/jayfsKzmlHkIWIqhtgt6zWlZrxF7ZOWojaar/5FVi
	 f1YPx3xV0XI3qq6yWvyZx0zjRqleBmMet64FNB1Xhm3MZixKGfJVqwAJXCvHHYfHy5WLl
	 fpGYiABCyRkGjlgtoM3lw9Sfe7nhULsHIB0z0NH5lE1Pj2Z8DcNO1ejLQ5x7So3dS1Im4
	 0P0w0rnfA4PO9F7hVG9afiSS0NdHb+DVEAHPe8IQs8+E8Ur6wfycV0oSbRCbdmrnAJg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794876519;
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
	bh=XDYWAh5XOgyuZRSIZtJheW0+MJqf6d8JE2immUuPZb0=;
	b=SfpT2+ABTSSL5OzWF7jedUmDJ+pPml/68Jl8t8JbvFkjulLRAxlEYKnpJE506qU2HsHc
	 6QjrwnwyjnWC29DMmAyizu8CkINQHKbWYiHkKFVjRfPBqLvdwBNMKJ9O7nPx9l5grN2PM
	 e3EjfXCMr2gGtV7gCdFRJBNWxHAuiLrZPfYEobtfCTOHUZStq9Wsdnf8UPsA1wbxI2hvC
	 6s1ffBv2RhUX87RCQwGoFTooWFu3Ex1G5uKhQMyq6EQyNBEZERu9763lGTIxw4c9gsluF
	 hgVWWI4hmY8/3DB5N7GkSOAuJTX2VaNxbWGxF7V6F1aTkvu81m8ob4T2IkoMmfpop8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=CpwZICzH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.19
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EDD606A31C;
	Tue, 17 Nov 2026 00:48:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85EDD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=CpwZICzH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IPi2wh3PCcGPLe6K5wLrnW7bamtvnhPbGWVPu0T5kISKMj76uLr88Jb+asrwdK3GU8+AUdwLdfilkZCvSebmjpQLBdlFg7+O8sWfzwR75nKKxdcgSHsy0LDXJAlpEN9aVoY0wt8JZHeBFMXwQUhVsnPH1DVtgmkaE1d3ifAg4EwKnKcKCeaB6q8MFSoEChCRYTqU8QydMYP2YeEEqnogk98capDWOS5W5rurt8KtU3i41XaVKQ2jRv6ga1iTaHxGN81LyW34s5mdsyD72gaXhDzbnZ2oFwFBbwucJhoIteqNNd8yjnmUB/2wB282vzPwHz4i0Ui2YhENmbNH7Rr+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDYWAh5XOgyuZRSIZtJheW0+MJqf6d8JE2immUuPZb0=;
 b=YJIbdQlluUzyg7G2JpMQGf8KGZC2gxER6xWxoo363Z3/EfIIyHK1yxhf7B+FK41J5l5EoiuaqDT9wppOqTaV9Ur0Y8eQ4i1m7LZS9sEor9KNcsFoLzLaQ9iN5G+jnn4F5b8bRr99R89hvtI0faahnPBUXthbK3aT9A+UxLIDBcYrlOB8BG6onQZHFaOxjIkPHwi7xVRb31YAsJNRXa+CqL5ekSpXA3rY9woIJ20R/B/4UrJXG7r0MckXLRSAF71Z7+82saSGdzQcZABE07WzFjAkXpJP/WUj6Qtk5TY7LwANqH/WDwOmBfwcg+Rdj0sIGHgEjDAGQyFYqIKwdaIXBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDYWAh5XOgyuZRSIZtJheW0+MJqf6d8JE2immUuPZb0=;
 b=CpwZICzHGRKFzc60nKOqAPKQOZoe1Jy5gtqpCcpr3w7cy+UNAXXppksPRFPYtVU9SqkWZvB1Dqu1lFNRaHPqefYmzfpWs9smVbUduZ06hzm2690ermOfWkt3zKWYagCswOe57MYw9YZ2C6evdxFnTpZ7EjLza3uhMmppQeDeWsc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 00:48:34 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 00:48:34 +0000
Message-ID: <b0efaf47-5a94-4922-98b7-2000ae9a405f@amd.com>
Date: Tue, 17 Nov 2026 11:48:26 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
 "Jiang, Dave" <dave.jiang@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
 "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
 <20261109234032.GT770409@nvidia.com>
 <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
 <20261110142038.GE738765@nvidia.com>
 <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261111141315.GI738765@nvidia.com>
 <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
 <20261112123127.GK738765@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261112123127.GK738765@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0152.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::20) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|CH8PR12MB9741:EE_
X-MS-Office365-Filtering-Correlation-Id: bbee72ae-2c0b-4f73-102e-08df44448219
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|22082099003|18002099003|261013131602099003|261021135927099003|261022075727099003|261022115727099003|261022105027099003|261021121427099003|261021123027099003|261026121527099003|261026140227099003|261028144727099003|56012099006|5023799004|11063799006|10067099003|261102123227099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	fWZd3MK6DLWlApRQgFzn7CFwSUR+SgF4vXXWlgXobk1NVW/IxDBBnFSo80TxSQKTdZY9SDSNPZG7PoWJvUCTCjdKSC3WvDmFteN+QAGxCmkTLId91eswE9CkODTVRIMSzaKkxr/UMjYBFhj3I7AujBIn54WBrmyNPJyG+VcxfqtTZBjWDndzDTeumjMY8SlxnsAEn446GkOpRYYdblauZlS9TcEsCCD8dw1IJzh4+8vJq7AIYHwV3vaaYTSNDqz4Ya6ctnBWjC0fh0MDWBCxy6ZpLrvw2ZJQC3waQlFo4qoOt6FuHQosh/Sz5nYTLsBD67SY6MHHImtSOyWZUhODpcwTitm0add3b64pTAai2T2duQcJ2/nfHLGDlaYsd5XdHCBwdrwrm0OjgRX53B88jQcq0vqwnXIeIzcpuuSEBZgNNJ3fTmA4ITew+tqBJ+nhXdbCoRLgAuvz8VzOcoP1xe/YGm8+xqLJUOGzMi6iKJLpG85gW3wXmnaCrhikeN4bkX1D6hrg+/nDlYlc9L8oYLs71fJ9ZoX3gBqqPaKDy1BQZ9lObPfVXrOQNhoYj4OCBgo3JVALmuCk3bfq4fL2OebZS79RwK0II6M0xsT3d1g4yYmCD3f39XBQZBMY4G9nLZwvo30yIk59K5W+T9fVa3I6NvUkDFBEt3nu7W1N/Gs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(261013131602099003)(261021135927099003)(261022075727099003)(261022115727099003)(261022105027099003)(261021121427099003)(261021123027099003)(261026121527099003)(261026140227099003)(261028144727099003)(56012099006)(5023799004)(11063799006)(10067099003)(261102123227099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zjk3VWFBMVJvNlR5N0w4cHd0ZDEyaTlpQ1kzTDI5SmJYbjVZall1SDRhb2JJ?=
 =?utf-8?B?dGQ0bStwTEF1OVVZYmRBVTlqRllDT2dKSDV3KzJIUXppM24vaU5TUFJOT3Ja?=
 =?utf-8?B?QSsvQXJhTkdySW5XT3F4MVJqTWdmVGNGWVNoYkhxQjFZWFdZN0F0ZkFPNU9L?=
 =?utf-8?B?WWo2Z25iNjRQbm83bmV2ZFZpQzU5ZWczUDNCREVIbGJnU3U2RzNjbmZWcThZ?=
 =?utf-8?B?WFp3VVE5T1psVGhYRVpuZ0lkZXZXMDZMVWgvUnQ4MEErYmdyMHdqU1p5SzdT?=
 =?utf-8?B?V25wdDRoUGFhWnZQaW9hWWdkTFB4akdJaFBzWTFKV3dleWZkWjZhQ0cwa0xt?=
 =?utf-8?B?b0NIRU5zWG1PRTQva2pXdmJBK0daa1BCbkZoU3hnVXJ4TCtyM1VrY0t1aXdu?=
 =?utf-8?B?TWxNOWthcEozaU9Pb2xIc0o3UjJDSDdOSWdNVUxtRUw2NlhDZCtGZktCWHZn?=
 =?utf-8?B?WWNqVW1IUFhOR211TnNITjNLSEpvME9BRFJ4eEQ0Mno3eEFaTlg2YmRUTEhR?=
 =?utf-8?B?TTNMU3RzUjZMZDE4T2NYTkJqL3RHblVPU05NcUQ3d0Fic0JHd29OTWxwQmhG?=
 =?utf-8?B?TVo0UVlmL1BCZWRPRVdLODRsOFZIYVIzeEc1bEFtZnIraHZFZmxRTTJTR0RF?=
 =?utf-8?B?M0tOMFBQV0hBZVRjQjZCL1g5ZUd3eVhJOGxGOU53RXZDMEpHVm9SMzVWTVF0?=
 =?utf-8?B?NWZaNTdXWjdETVVKemw2UjFwcWJ5TTE2UWZPc0xnbWNlRTI5Rko4VE9pK3Bv?=
 =?utf-8?B?WXpKdW94QmdQZUxvem15NXE1alFTNWRXMmxObDBVMEFqenlLa01hU3V5Tmtu?=
 =?utf-8?B?YUg1V3I1Y0NzdW5yTWJZeW1JL2ZHMjNKUDZhL0ZZRHJNaFdBc2ZHSG5JN1ZC?=
 =?utf-8?B?UWVHbGUwdjR2ZnkvdE45VE1PaDZaVVNVcjQ5Y3U3S1U4bUhta3Z5YXoyZ0ty?=
 =?utf-8?B?TGdOTnIvZng0MmxnRFRDalRDV0NxbXB3cm1jTXZPR2VWRCtMTmZkRFZ6aTRm?=
 =?utf-8?B?QzRDRFdTekpSL0VYb3JlYStjazFBUy9RZ00rbGY5ZldLY1UrVHdMQU5uQkZ0?=
 =?utf-8?B?bFMwU2lMU1RDZ0loZXYya1c4K2JXdEoxMXhoT0NsL0d3NS82NEFGa2I5VTky?=
 =?utf-8?B?WjNsdWFxaXRrVjh0dmFBYXhqWXRoTjJZRVdSSDJZZXhnOFovT1RjMlNEUDZp?=
 =?utf-8?B?ejRSa1BIT3F5b0Y3dElvL0JZYThLOVl5TE1PS1VaMVVhdVh2UjAzUnRRSmI1?=
 =?utf-8?B?Y0tGQzRRTUwzYWtiYmpxa0dKZFV5eHJMcEVJQjU5dkdZbUFyejVMZ2lYZkdu?=
 =?utf-8?B?L0JEeUNaQWRwSU9JTExQWkx6Tk05aDU1L0lsV0hKZWxzZzEzTXExZVRRR05E?=
 =?utf-8?B?M3B4UWxBaU1uOXR3ZXR5eVRuRk56UXFSZ3ZURnJxanNmNmtZVms5eEMxL0V0?=
 =?utf-8?B?aWJJdHFwbnpyYlA0YWtNcGZ6Snppek5acHBEU3R0V1NwNDRkVWNKVXl1Yi91?=
 =?utf-8?B?bmZZNUpRY0RFUmhIbzJHSEJjL2s2SW9OOXRDSkJZelZpUlE4a0swdkVmVXlH?=
 =?utf-8?B?REdTUENWcjdWS09qamloTGdQUUZMbHArdWRxTGU5VkNvNGszQk9oVHFsNXJO?=
 =?utf-8?B?MDZUM1dKaUJKV3p4d2FaVU9IT1B1OWZncVppQ0FDbnZyOTQydUlvUVExalNO?=
 =?utf-8?B?UWdMaHd4cFNFY2s2aWtiRFo1alZicmJld3NRS2Z3aEwraXRiSEVGcGR6Szcw?=
 =?utf-8?B?eXQ2NG9wMlhXaUxkeWhBek9tMmZMcjI3Z3gveklscHhnVTR4L0c3U1gwR1oy?=
 =?utf-8?B?ZERBUXpVNCtJMWZJN05qZ05jT3FoOG5TeXRSeFE4aWJCQWl3MTRPRWFVSW15?=
 =?utf-8?B?ZXV4ME95bGJUbHI1WnRyd1NvL0NMQlRhQVRTMllDK2ZPSWRaY0tvZCtPNXFn?=
 =?utf-8?B?aDhPSkhWNElET096UUc0UEJRNmxZNngrSTJRdzZUMmdXVmUvQ0NyQUpHNTFw?=
 =?utf-8?B?S2F6cXlGenN0QkRnOUZZVVovNjFDMGdIa1Vibit4aXpBWC9ZaWdkTEd3TnNF?=
 =?utf-8?B?cC9RSG5FbytXYTltNDBUaHRoZUwrbzkyc09HOTU1OGFoM1N6N0locUJucC9P?=
 =?utf-8?B?NWRYNUExQzIxSm5jdFZ4ZDQ3bzg4ZHJQc3BSV0gzR3Z4K1J1bDlRdUdyQkoz?=
 =?utf-8?B?amZqaEVuTTd1bGxVQkZMUnVzTWE4aWZKUDEzT3ZIWFJ4ODMyL2owS3pBVEZo?=
 =?utf-8?B?TVd5MUwvK0IvSHNVSTlhMVp3QU0wZDBTQ0FsVWF5N0RYQnpFSnFFaTVUNy9N?=
 =?utf-8?Q?ah5fi9pgbIttWnJFf/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbee72ae-2c0b-4f73-102e-08df44448219
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 00:48:34.3743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rMBHmTreuBTiZSUQtEVqXwxT6fscSBYleM/ta4gGvsH6N7PwLTuqQLaU2z5EBSJw1HADfbcyqHxPaHvcUbp9zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9741

On 12/11/26 23:31, Jason Gunthorpe wrote:
> On Thu, Nov 12, 2026 at 12:48:42PM +1100, Alexey Kardashevskiy wrote:
> 
>>>   It revokes hypervisor access to MMIO registers.
>>
>> TDISP's RUN does but CONFIG_LOCKED does not so MMIO and DMA work as
>> before, until RUN.
> 
> I mean the device needs to secure itself, whatever that means for the
> device. Obviously the hypervisor cannot be tampering with it while we
> are trying to accept it. So the device might choose to fail all MMIO
> while LOCKED or something like that.
> 
> LOCKED and RUN both clearly mean the device is under guest control and
> the device needs to respond to this by protecting itself from the
> hypervisor.
> 
> Again, my reference threat is the hypervisor programs the device to do
> DMA after 1 second and then tricks the guest into doing DMA
> ENABLE. This must be prevented by the guest and device co-operating.>
> For a concrete example, imagine a RDMA NIC. The hypervisor boots it up
> and establishes a remote QP with RDMA access to all memory. Passes it
> to the guest and the guest does DMA ENABLE. Hypervisor suspends the
> guest immediately after and rewrites all its memory via the network.

Then the HV is in the guest's TCB, no?

I do not know anything about RDMA NICs but there must be some access control. How is this different than giving the host an SSH key to the guest's root account, for example?

> Devices MUST have protections against these kinds of attacks built
> into their LOCKED/RUN state transitions and verification, somehow. No
> spec says how to do this.>
> Pretty much any device that does DMA can be tricked into doing
> something like this :(
So we basically want guarantees that bus master is off when transitioning to RUN, is that right?

A TDI measurements could include the VF config space but we do not have TDI measurements... Huh.

Sorry but it sounds like the device driver is the one which has deep enough knowledge of the device and, upon transitioning to RUN, can tell the device to stop/reset (via encrypted MMIO) while keeping DMA blocked.


>>> Exactly how LOCKED works is device specific, but from a security POV
>>> the device must implement LOCKED in a way that excludes a malicious
>>> hypervisor from undetectably tampering with the device.
>>
>> The device fw updates (if permitted) during LOCKED/RUN won't be
>> detected by the VM but it is not tampering as we trust the device to
>> not accept a bad fw?
> 
> Yes. If you allow live update then you have take the position that any
> acceptable measurement is going to evolve into other acceptable
> measurements behind your back.
> 
>>> Broadly there are three device implementation options:
>>> 1) A TDISP device MMIO is simply entirely inoperable by hypervisor and
>>>      only works under locked. Trivial
>>> 2) Entry to LOCKED cleans the device so it is quieted down enough to
>>>      be safe
>>
>> We run the attestation without a bound driver now so the device is
>> quiet but so far PCIe TDISP did not require this.
> 
> There are many things the specs don't *require* but have to be done in
> a certain way to get security. Enabling dma and binding a driver
> before taking a measurement is obviously security wrong.

Well, I meant that the driver can start with encrypted MMIO (or not encrypted) and untrusted DMA (SWIOTLB or vIOMMU with only shared mappings) and then, after the attestation, switch to trusted DMA (and remap everything).

Say, it is a the only NIC in the guest and the VM wants to run it as trusted but the attestation server is outside. Reloading the driver is just easier.


>>> 3) Measurements record if the hypervisor did anything with the device
>>>      before it was LOCKED.
> 
>>> Yes, but this is something else entirely. We told the device it is
>>> LOCKED so it activates all its defenses against hypervisor
>>> tampering. We take a clean measurement to prove the hypervisor hasn't
>>> left anything behind in the run time state.
>>
>> But measurements do not include the run time state (the TDI report
>> does), where is this coming from?
> 
> Who says this? The measurements are defined by the device, they will
> contain what the device needs to prove it hasn't been tampered with.
> 
> If the device chooses #3 then they must report some runtime state.
> 
> You both seem to have the wrong idea what is in the measurement
> reports in real devices. It is not just a hash of the running
> firmware..

ah I see. True, not just a fw, it is the things like "whether any TDI is locked" (?), not crazy things like "hash of sections of the device's RAM" :)

Right now my guests request measurements with a guest userspace provided nonce and the PSP talks to the device to get them.

>>> Now we trust the device
>>> itself to only alow measurment changes that meet its own security
>>> model and the hypervisor cannot interfere. (bugs excluded)
>>
>> Opposed to what, accepting any fw if not LOCKED? :)
> 
> locked should have nothing to do about firmwre update. locked is about
> taking a clean measurement and preventing hypervisor tapering.
I see what you mean. Thanks,

>>> Updating the digest means that the guest nonce ends up being captured
>>> by the hypervisor and presented to the next VM as the 'initial'
>>> connection measurement. This does not seem like a good choice to me.
>>
>> Does anyone actually _present_ nonce to the guest, not just forward
>> the guest-generated nonce?
> 
> Yeah, ARM has this option and Intel made a worse version..
> 
> Jason

-- 
Alexey

