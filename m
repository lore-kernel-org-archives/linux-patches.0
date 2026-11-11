Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.4
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794387841;
	b=X+nqd6Afsr2qlBFVJC16bknm75jzGnOTdwBUsMYaPYoAIC0xrHBbzjRz5+E4ytaDunlH
	 5cqumm5okWwQLRY7lFIQCRu81W5sM7/3uXapCOC+2hm+LW2CEbQ8ZzB7jtLTMAM3dDW+c
	 CmWb3lQfJOGwCDrv3Y8yRdKkJYdfXjU5MBleFJzYWfwwsTsw/5xWj7agWbuUb+v7RophN
	 TgTc2ztq72acNE29JQpNA80IxzoD7b14ezVBlTUWMSOQEqCZ115Zmau8wHazh184KPIfB
	 0phGkixWZUWrm0p/pAU/f54liUx8ugnhmZsATxDPbxAtGLNC1BJ82+5Gb7zWNkp0SPg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387841;
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
	bh=9h8RsVXT3xVLu1FHQultbjV/xX5LI83ouBCYNz9qmjo=;
	b=A3dpNUCauwlZBvo9NRjHmT/yQ4r8fMIKDhU0jdCmN+LacgBbzt4FtefbeJ9dQmrS4WxC
	 rBC03YZfFr0JzotTGdjo6l2e95l5+9U9PIzYdSd6bzsXeOTvJRHcPk7N15Zeb+ztnZuVi
	 d7JVqYuLurqCpk9oN3gvM4yvhSrAf6oQP2PddG+ygMaYDroktXdOSQGPpuNU4J59sNmTw
	 fDYpOIdSSJNA8bzCFiuLPV4z1u2O8OWuYo10uTcKH8A9HeYjEWo4xkwk27aow7fWi+R7S
	 XQvzBgTrzIRbE3honkCZ06T+Nd2bTazZwqUFG0GkAhj65jos3t8pVrrfzMnWiVcc4Jg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="a/ipwn6j";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.4
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012004.outbound.protection.outlook.com [40.93.195.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BAF606A323;
	Wed, 11 Nov 2026 09:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88BAF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=a/ipwn6j
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sob9os5WgW6WPToQq1SGXo4c6W9Sf47/Fmic8JfZlzv75qGbGC6jhWleTcCwxZfiKixfZMHP6knHxGOicgsQsIKjGNqcWyG7g9hUU38xzEkWxvCdGphWhBIFkhCyibo0Ph7K+mWGIk2y0a1LBnObFYfArTDy3Wt/jI3zFxQuIZPxJ16SsY/2xITK7vu4r+OyQYF8LSCmd50Ibmzt+tvTiLL9RXZI6HQN8jyAOTcFilXaX1JIGRglu0m1qYWyIc13TTfzDxO9mXbxk3XX33Pv0B+cwu1JLLeUAesXVa/WnXfBuxsEPwGczVrmznuNntyA8AOPIiCpc1XVOKSVBBSERQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9h8RsVXT3xVLu1FHQultbjV/xX5LI83ouBCYNz9qmjo=;
 b=miclRhBya+0UgFs3V7y6gi7ZLIh0cM93TgZlaGLFNcrqEWF6OhJ6Sf86VhN3Z8YUp0F8oxxDYahFO/5f2SxIIrsy54HDkP4eQQNIalwhkEu0dz+UboRD0/E0bTT3ylkEOMHgwBqCtjmV0MbGwx/Frdplr2lRZozK8b4UxvdSM4K17bHryCxu+TSacfuUw9DoB3TsGbXXv1d41MABbOIe2WRMop0nI3S9GSqlBpamf2D0d5+z2psqF9P4AqYqrXBAumge0Nps9IwIFPEjFBKO+3u8M/1hjUIhv6CRxbMF0mJkTIhPJa6MzzyJkJaY1l4zBv5FETpDmHAE5qsOGPqvow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9h8RsVXT3xVLu1FHQultbjV/xX5LI83ouBCYNz9qmjo=;
 b=a/ipwn6jijnQ6QVA50dGw5HFjI/6n+qSHcxIBA0KAIwxj5+uHhMmnZsv6JP9b4jvq1tgWGXttVm0FuBX9Is+5GqM+tYnszaRe6AMbFvpqPbbq6nuBnhtawZCnoNaFtZrUtSWSk4NXJL3posS7dh8FwHSvxBNMLdUmwHncErglks=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by DS5PPF18A985A10.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::645) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 09:03:55 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 09:03:55 +0000
Message-ID: <7ddf5f6d-0eca-4eda-9240-3903a7cd86eb@amd.com>
Date: Wed, 11 Nov 2026 20:03:46 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
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
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <9cdaa99e-4a1a-4fa4-8fe7-73b9bf48ecd9@amd.com>
 <20261110125202.GD738765@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261110125202.GD738765@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P300CA0026.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1ff::15) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|DS5PPF18A985A10:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bb82ad3-306d-4383-e466-08df3fd2b712
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|5023799004|11063799006|4143699003|56012099006|261021135927099003|261021121427099003|261022105027099003|261022075727099003|261022115727099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	63Q7OPr0b28yt+lagIid1+iTjPxs1TY88I90kW9NSAXeNtZDapdsxrQIYgaPmLzyyYMqlJxN0RtbhDkTIkbNS7btqwzzYLQ0ExXrSHTk2Pf99Gvxj5EZ9iZNWAMmmI17XkY3OWULEJzt7rMpV+eb4DfP5ZinB6RHMBeLgjgBuVA7mDGtWaGeABxNRZku3L1J5c2Fh7G9atFOgXwbeTlofhyO2KlscYnyqB65u95Koyyet9So2FWZ4wknBZSkLB2OrLlK6CtyjlzAVY4e5W329jK3/g2VmJO4noWsBbvxH5Rcrmi2dCZG3DP2NB3D+WVMhHIz2kOktOt8idY9T89MXHjKNaz7LcQZFhU+gAlAVWAXlPI59iPJcw9k/xkI/VQn+miltTJ6PZnDqI2kcN+WG+K+7W+s77DwYSuXVJ2jv97scHCxGAgEvvEj3FE/VySdG/BbdjjGSZ3yotmYFqNtC6DujEUfVPCDCBBjsKZSCsrGh4ELfzTnan/LVru8m1Od2Z5rYOErltDwVUg+zMhjb5/9Lc+gV5LSO8xHhTjrhZ18hKzSGaQhUgf5oxRI0XSPSmZuKAVhgzhJmhTm1qGFFFC7uYyxjwKFigxgI/plxwjoWu1cxI5NNFhwYdzV41P4T5Wt9a84wAtPw5BeDNco00EwYOuibpxVbzr/FAyxb00=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(5023799004)(11063799006)(4143699003)(56012099006)(261021135927099003)(261021121427099003)(261022105027099003)(261022075727099003)(261022115727099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aktYRzNvUk9oSzZCRDRwNG05YWRZN2Zwc2EzdzhxRXZKK1VQcGR1VlZkOU9k?=
 =?utf-8?B?QU1ISENIQzlqdmRyS0dRbVBvY0dCcE51ZXFtd2l3dzR4bmVpa2tDSVZRK3JN?=
 =?utf-8?B?MzloUzBCb3hDZUN4RWp2U2tlKytkSnpabzhCaHNiVi9ZMVB3N25ObmEvRlkv?=
 =?utf-8?B?Ty8rVXMzYU1qbnNSU0QxU2k2emhqVGY4dWJtdFFyc3pPeGlreVBsOENPZk1B?=
 =?utf-8?B?anBBSUowcGkwOVBiSzMxRTc4VGFGWE8yOFdjTGJwMGxlTjBsTjhZMFlrYlpI?=
 =?utf-8?B?SDZ5bTlrVkc2VGtLWDBhdGtwTDJtcmU5KzJmbWM5MzM1NWhGNTlUbnRwVmU4?=
 =?utf-8?B?NGNaWWticDliY1pTTm5SbHozTFJueWtPc3l1Wi9paWtBUjlLZnlMVHo5SkVG?=
 =?utf-8?B?eUF0cTJ2SDRLd24rVm15RytqWUxUYnhjbnZKdHhkSGNKMGZvd1dYblB4K085?=
 =?utf-8?B?elMrc1ZaTDZqSFNuK1E4bUhLdXVaaEVZNjBoUTZLaXdjSjZjcnlpbUdZVHUy?=
 =?utf-8?B?VFNVMkE4T2dJY2pWcU9RMCtuazlUN25qWGJBRVhHa09qcWRDc29pam5Od1M3?=
 =?utf-8?B?Sk5ySk1yajIzRFg5K0pmNHUyeHQ2YVh3NzVUKzdvS2lMVFFZdWc2bzdjVlBt?=
 =?utf-8?B?Q1E5UGJGQUtUQ3BQaFpZVTZySW5sWXBzUlppWWRFeFhHaFZ5ZGtkcmVHUmZv?=
 =?utf-8?B?WmYvczhvYTlyMTFJa1VJSTRTc0ZrdjR0N3M2VGpTSDlyTjNjUjdhajVSMFlV?=
 =?utf-8?B?K0Q5ZmoyaExGSVI1dHNBd2Y0MGVYRi8wbXZmQzc2WlBlcWRkNitoeHlBajVB?=
 =?utf-8?B?cGVxajkyeStNaHQ5ZTIrTXRlRXZUN0NlOGczY015UWRxYXFYN245Z2R0SVh4?=
 =?utf-8?B?MlNWNXZPaFQ0Z1pGZU9TZjBzL2hWcXZ5ejVhbjdkL3FjcHkyUkxENjM5Wk50?=
 =?utf-8?B?a2ZTa3hXTVlSUEsrTFVQMWx5VnY0VmZrRkRSaGoxN29OZXE2Y1ZMaTlodDdR?=
 =?utf-8?B?L0lnWEtKVjZwQ2FZYzdZeVZxMWsxZ1c0S0VhQ0RQR0RrUlNRQVNDTnpsL2J3?=
 =?utf-8?B?N0hEY043Z24vVm4rOVZZeWRoODJpUm9aWUN5ZmloOUNuZDNnVnd3TUZ6YjFH?=
 =?utf-8?B?NnRaMytQUVVuWFNFOXFjWEVnZVR1aEUySnkybzIxOVJuLzRKWUFxbk1ESFNl?=
 =?utf-8?B?ZGp4N1FaclZBT2NVUHBrTU1oQkFwaU4wcUtld21ENlVkL0FZV3RUdEllK0c4?=
 =?utf-8?B?bUgwTFJlVnNUbGRxRmdZNG1XRFFiR1B0QUExZjZSdVpPbWdSUWdkZldSVy9q?=
 =?utf-8?B?OXZjc2dPZjVjVElPV0hRYXpFOWFJMzVFd2FKU29WYWtZRGptVTM1bUhXZnB1?=
 =?utf-8?B?dEpQZjZpbmlZYURmNXFVVEFnbEdiN0pMMDdIZU1qY2I2RnFIOHRJSmRrYlg4?=
 =?utf-8?B?c3RpTlo2QU9STkp1alJ3UzJGQWRHYmpjem5EY0dNbnlsMjZWQmhjKzdhbDNW?=
 =?utf-8?B?V0dmM2tQQXJuY3RNNzVLQy84ZnNYbk4zZmU0VmFjeklsbUU5ZEN0OEhBcUh1?=
 =?utf-8?B?ckd5UUt1VXFaMC8yMFJUUVhuV2o4RUtVWHIvdlZ6RlNlYzg0UXhGaXlNSWpL?=
 =?utf-8?B?em95TkE0QmhrSmk0RUlSL2taNjRKSlhMcGRxSXB2Qm9GNnBqSWM1TVR1ZVJv?=
 =?utf-8?B?c1FscjdiMGgxelpBV3FKVmErVWJpQUV4K3BsQTFHNFlXRW41cURQdkp5Myto?=
 =?utf-8?B?ZXpWYjRIWm1NN1NKdWJ0SzFHMDIxRkJlbi9lcFB4STNNOGhwNHlZcWxkUGhR?=
 =?utf-8?B?aWxBdVZjVVY4ZWlBemExTVlrdjNWOUpmSnhKUmRGU2d3WFJETGtnUk10ZkFG?=
 =?utf-8?B?bUFuMWJRMWV3UFdKWVVqa0JXa3VMZmN6YWhMa3BTZVVSWEVLaDBPM251TWo0?=
 =?utf-8?B?N09VUy9TcFNKeEZRWFJZcEl1L0IxamJtbkgxekxvNFVTZldPK0VEN2VjNlBN?=
 =?utf-8?B?eEZKZEtYejRNOWhZbndVWERwZ0FHOVI1RE5Cb1dzbURFM25rUUlINDI4OVpS?=
 =?utf-8?B?YW1zeHBna2FHS2VXRllCdVJLT3JYcUczb1hIRzMrSGlqY3ZNOHpzTWdIMk9O?=
 =?utf-8?B?ZU90ZzUyNlFTMlk4dVZ6TE5ua0ltOXB5ODZmSjBJSDhVcUZiVy9UWHRGbldO?=
 =?utf-8?B?UTdtdTJVOVVTZi9jTXlVdEx2UXJROWZweDhVWHJnTW94WEVYZjJvOXpuanhH?=
 =?utf-8?B?cWlxNEJoTEFBUU5SUkVaTUdPTDdXVDF3ZjVOaEQvRHBvQlBFdjB6RXFPZWQ2?=
 =?utf-8?Q?wStuc2VOgaAwW/bYKc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb82ad3-306d-4383-e466-08df3fd2b712
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 09:03:55.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OETWei9mUZV/UtJy5ZYhZzdIve7AaCwxpOkzTTvmYXo5wF8HayZD2REQbE+cRPBowFKv5FPa4tFoQBJ60Q1nKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF18A985A10

On 10/11/26 23:52, Jason Gunthorpe wrote:
> On Tue, Nov 10, 2026 at 04:32:34PM +1100, Alexey Kardashevskiy wrote:
>>> My AI predicts 1000-2000 lines of code very careful spec derived code
>>> just to remove this padding. Such a big spec mistake.
>>
>> Out of curiosity - why that many? There is only a handful of SPDM
>> messages and secure SPDM has the size in the header.
> 
> It sounds like there are alot of options. Since nothing is sized in
> the message you have to parse the negotiated algorithms and spec
> version to figure out how big each crypto field is and manually sum
> everything up.
> 
> IDK I thought it was alot too, but it is just an estimate.
> 
>>> 1) I think this removes alot of code from the TSM drivers. All this
>>>      stuff they have to go back and get the data after the fact, or the
>>>      thing that is almost like this in RMM, goes away. The TSM drivers
>>>      are very slim, just run their communicate loops.
>>
>> It is already like this pretty much, is not it? Well, on AMD.
> 
> Not quite, AMD doesn't have any way to return the session transcript
> to userspace, and it hides VCA under it's get measurements thing. It
> only looks simple because these issues haven't been addressed.
> 
> In terms of presenting a consistent uAPI for SPDM AMD is the furthest
> away from the rest and probably the best reason to do this design
> since it would bring it into alignment.
> 
>>> 2) Clear uniform path to 1.3, stop after GET_DIGESTS, let userspace
>>>      inspect the certificates, continue with the slot. Again drivers can
>>>      be super simple, just need to pause at the right point in the
>>>      sequence.
>>
>>
>> The AMD PSP calls SPDM_DIGESTS first, then SPDM_CERTIFICATE (just
>> like the PCIe spec depicts). May be stop at SPDM_KEY_EXCHANGE_RSP?
> 
> That's wasteful too, GET_DIGESTS before KEY_EXCHANGE isn't signed so
> it can't really be used for anything.

The attacker could steer the slot selection to less optimal, is that the attack?

The TSM has to pick a slot to sign GET_DIGESTS which we then want to use to pick a better slot and switch to that?

> This is also after the OS has
> told PSP what the slot is, so it can't even help do slot selection.

How is pausing going to help with the slot selection?

>>> 3) The data collected and presented to userspace is perfectly uniform
>>>      governed only by the SPDM specification. There is a clear path to
>>>      adopt newer versions in the kernel with in-kernel SPDM that
>>>      instantly with nearly no-code works with all the TSM drivers.
>>> 4) This is about half of in-kernel SPDM, the receive buffer
>>>      reassembly, certificate chain reassembly, x509, padding stripping.
>>>      Each a complicated topic on its own. We always imagined having
>>>      in-kernel SPDM, so I view this as effectively free code - contigent
>>>      on organizing the in-kernel SPDM implementation in a properly
>>>      modular way.
>>> 5) Without AI this looks actually fairly scary. I can see why people
>>>      wanted to avoid it with different schemes to have the TSM do some
>>>      of the work. Yet we planned to do it anyhow for in-kernel SPDM so..
>>> 6) With AI this is probably a weeks work I suppose to really expertly
>>>      polish and make excellent tests.
>>> 7) There is clear overlap with Alistair's work, I don't have a sense
>>>      right now how close some of the parts in that series are to fitting
>>>      this shape.
>>
>> You want the above just to prevent IDE keys from being programmed
>> into the device before accepting the device in the host os, or there
>> is more to it?
> 
> I want a consistent uAPI that is 100% the same for all four
> implementations. I do not want ARM to show the VCA before measurements
> in a transcript and AMD to hide the VCA in an AMD specific measurement
> blob - for example.
> 
> I want a uAPI where the user cannot tell the difference between the
> four backends. When they operate the same PCIe device they all give
> exactly the same uAPI experiance.

That's great, cannot agree more, but what was that recurring thing about not programming IDE keys before accepting the PF? Thanks,


> 
> Jason

-- 
Alexey

