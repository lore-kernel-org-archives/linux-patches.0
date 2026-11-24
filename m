Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795478930;
	b=V62bLdIJ2nl5ju3XH5Hc9UmHnB4biHa+rIut5t/FoC9X7XuRf6Oi2zM6m8nUGeqWB/y5
	 B6D2oUFasMvO5rS5GdXUhZXzuPaMNgmKNkfHT0JxMDINqnWvDrOcKcDilvz/EcLNCbF/l
	 twuzq7xhedWHZNfyaRzq+TrXzypHk4+P4+eF+x3r2hlRU88jf2UZn77jEwDjliLwqqHsh
	 tbU0OCvF1SP3a7Cxj+P5tIfiSSWaO8mhgWede1EGGyzqICbEi4uvBa8x/0JghH49rRZOg
	 vJmpz3abr7OM1Ogas53MbVsumJnmYUpwr4Zsnrra50BrHGkfJd0VMqkeyOLL36hwZWw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795478930;
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
	bh=qTpwmJF69Vu0IXiSE4JiaEspffh+Mp0i8K5AXS9NagU=;
	b=Pf859OUFDrCwrSmiOX6FsoJQhSH+MhkLC0mRXFE/YUbAw8ajGrHMSLLgHPF7TvlJrwjQ
	 fYAETjkS9PAqTuSh/YofWDkkE5Vp6V0zBB4saIJuBv02DkKYlev7cY3Q2VbPR+Bo/ljCd
	 UCtH2b1TtweC9MJSpJMgOZ21UDDGL4ofjHWKr4hygYq2Q14ydBdOCAKtQfSe+iDYv882w
	 PFHfqTjVDcbvcee3+Uo0qPh9u4s22DpV+RPh2z8dpnemfJLbIG+bYji5VCb9NRLkhoyKm
	 8xaYE2rR4L+C809G3C+YPyHwpB6i9bJrTngSuL/GJTfW5AVtoLnLxvg1b5xcNIeUcyg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="cY/lX2jO";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.26
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011026.outbound.protection.outlook.com [40.107.208.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DBD606A331;
	Tue, 24 Nov 2026 00:08:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63DBD606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=cY/lX2jO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FGEqROW3gXnPDjpnKI5e81X3Vov3AdnOXFQtlObZzX5u+P6+3WOKbgPsS+YeRkZc0gvY52GZdlBCGSuIWD8uFVS4mLUDKUCpzSTU6RcIiKCSCCCnKKAiAq7moAGRYK//GBYEuhbnejNSfTDi6NvYXDpqeLUPDYiWON1tIk8o6qm7tJGKK9h/hZybgB0I0hb8/mz35BcWTmjP77RedFuB9hS2l4TbwOeRCsGD+EftjjF5pMFenosL9dMfOhdYcjW77CBoVBfSXWTPUp6y1y9QOb2CG6VNOJY5Ct7UN0L8IyA6/0ngfTSTzJ3QAAg/J3/MRn6+MeerbuN6a24um3vuug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTpwmJF69Vu0IXiSE4JiaEspffh+Mp0i8K5AXS9NagU=;
 b=jAALlmDLIyLQajA1Gok0HVo/vz7E3Oyy60TxmDKNcJuG1A6TyOk1qVsLYkA79JDEdrXKRJzJJABTid0DqI1CkkmfqpH+jAlN9p9t3gSkE9c3H9udAdctcnBD0H7OLJKwvtNxKM0mvottj1HXNSzo1lj0rn0RZNPHnJuxfR6dM7oYD1J9KEN+fG0eHY/2TGmGDEPpM/4xPpLGxAPm+mTMT9kRh7uJRVf5m41Hwe9dDVO7owz1qkXJ00JGzag7AX6oMitWExgbUYD4pizUu4QBbA+HL9uyq/rpVDMbl0bdU2A8tatXYocLHt1z80zA3Rwxe1BhyduKacswOwKqzjQIww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTpwmJF69Vu0IXiSE4JiaEspffh+Mp0i8K5AXS9NagU=;
 b=cY/lX2jO0wVOWXkgz/q8N8b96TcLOVMzfkVZKv5CrLOxzmfM26unFL3R/J/9VX85NbvnvMU5m/RLuNfdZ8aaM+9VME00rZZ5JeF8BzCFFYCT0yh72M8qV+e8DZzOtVk2hQoXZY4gjnyQOpToneN6H07Rrcj9qFdm9k0SuRv1A70=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by SA3PR12MB9090.namprd12.prod.outlook.com
 (2603:10b6:806:397::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 00:07:56 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 00:07:56 +0000
Message-ID: <4279cc50-0e05-4d86-ac12-398adcfb6091@amd.com>
Date: Tue, 24 Nov 2026 11:07:48 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/10] PCI/TSM: Let TSM drivers discover the CMA DOE
 mailbox
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
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
 <20261123083337.2731019-4-aneesh.kumar@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261123083337.2731019-4-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P300CA0014.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::34) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|SA3PR12MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: d381b61b-b392-4ec6-e101-08df49befdb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|22082099003|18002099003|6133799003|261009223027099003|4143699003|56012099006|11063799006|10067099003|261102123227099003|261102130727099003|261026140227099003|261028144727099003|261026121527099003|261021123027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	48L4M72CqKHss7ACTRC+4A5gnqbKPhymU9aaWTQkeb+xQAzboo3ARzv4YH2Db8JhOcUgNnd5ZkQUnjIZXplg+IXKdumasPsZlvm5isb8TDHt30ihKfFoppBDwBuQmB4htkAy+4ibFToxflmsgaiQJTdBqt5MsYbCp7WXFVpyvsJr3WlvMrWZpWhzzZdiZCtMlmK8qjITOmDPULGVKwtsbtDpoyO5SPlHsrqCncQBHJWQqWor3TRQ2zRyrdosEKsnIUwHxFCUccwzUqDIgbnHKIYbPoRUsZfkKYdHpiroJc9WXRJK3WbVmKkF6qX22H8ZIyhH84DM6US8qDWmRxqhE6aH/wd9VOwUgHriTr40UujqZk4e/VLR9jNGcDI5Rwo2nFZjgPUIKfogEdrctEMAEUUMcJprRytPqe3koJk2M1oq7Hchi1FnsbLhqX68hO/ST1DhWhvJKPbGIGkdH8Sfj1CTC3HgvZKPCa0n/lmpsJCnbTyzjx++Erl0rE9SWhui8tg5YnaM9xD2GUmQROTr5xxMKDYPRWropx8oPgDm8EbNpSjtXGfmVKtUFZyjlfFLCx7jViNpaTllU8gvEFKHxEiA7TfvTaXVBkCNGbbudOYjjhRfoLlBS2xQvrQcKaFWHnJd9bt36sQk+hBg3mvsX0vFl8DrXG/Zs+rLr9O13ss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(22082099003)(18002099003)(6133799003)(261009223027099003)(4143699003)(56012099006)(11063799006)(10067099003)(261102123227099003)(261102130727099003)(261026140227099003)(261028144727099003)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3BYMjhoaVI2WXVMZ1Z4cmdYazFsa2I4Wjh5Y05WTGFkTWhJUzZBK3J3aWFy?=
 =?utf-8?B?eTg5QXYyK2EyR1NSSXR1SHpLYUxtWTZsUm5kTFpoT2dheVJSdGFWNm9GMzhZ?=
 =?utf-8?B?bml5b0xPYWI5bEo1UlFyUVdYSlNhdWsrSG81OFJyMEF3dUhZWUwxRlRseXRN?=
 =?utf-8?B?ZVQ0WEpsY0RVVUxURlhtc3lKNExhUkNKeFhiUjFWbklDY2xjN2xlV21OV1lz?=
 =?utf-8?B?ZjdWUWxmMXFYL0JDQk1VRVVjb0o2ZXAwaUNqL3kvZmpJK1ZNU0FQdWlTc2JT?=
 =?utf-8?B?WnZtUXVnckZWM2xlcE4xdmdZaFlSNVhSOXVNL2F1MWZJSy9qbkdwWkxCak5S?=
 =?utf-8?B?UmRRT3Bwc3hWRlBPbG1DeGtVRUw1NllTanBESEhacTFlUkhQbzA1Zm92dXVy?=
 =?utf-8?B?aDdsM1pxa201a3Q1c00vQzVXeEFyNUUyVHI3THZWR0RpTnQ4N0cvQWhsN3p2?=
 =?utf-8?B?ZkRpdGV2bUVGL1N0L29hU1VYMy9wLy9vOEtGTFhiWi9vTEMxNGV1Ri9xYmts?=
 =?utf-8?B?VXQ3eExhbFI2QlJZWmZxYXA3NkJtUENWMUhCNlkwVTljcnlSc1dIelBPRzhi?=
 =?utf-8?B?d2Y3YytRQkQ3RUxCYzlhaVZKdTYwd0krbXBMeHFBdlAyRTRiZU1HUlN1MHFR?=
 =?utf-8?B?M21ZT1VEVjhDeUQ1bHluT2trMVFncm5NT3pIblUyVzk4anRLTW9YZXpNamJB?=
 =?utf-8?B?Q2pqMWJjS1pValFwUUVOVXpSY253M0JINlNRdzd6OHlVeUtmTEs5U214U1ps?=
 =?utf-8?B?OEw2SzZiSEdiOEQ2eTVRRExSMTZLOG5LTjF2MFdkYkFxZ3VlWW82ZXdtZmQw?=
 =?utf-8?B?TW5xRS9MR010T3NGMDVtQ3VFVDB5VG1WR1YrWDREL1ZVRGJ1M3pFWUhWbWd3?=
 =?utf-8?B?VVRCcVhadFJpMEdnQjFCUmZ5STYwUEErZGZ0VmlJcytsYlVGQ0toTlY1MHMz?=
 =?utf-8?B?S3JvNWhBRnA1T2xaQWJPeTNFdXJXbyt4OGNsNC9CRFVDVXpIMSsvazhFVUhI?=
 =?utf-8?B?WE1sb0ptSzFIM0c4SHJ6Q3BNQjVMblVmMTFHSzNRRXBEbHBtc093SnhpVU0z?=
 =?utf-8?B?SnpzaDVqWjJTd1cydW9tbjdOcFc1a09MUFNVOTFRK00vYzVhY3dHVTVoL3JF?=
 =?utf-8?B?VnY0cklBZlh6TlE5VHR0cWdVdHRYTzBjUHpIQzFSS1QyZXJ2OHdjQndGTEh5?=
 =?utf-8?B?L2l4SjZheThEbEh2UTNreVQxeHpQczFSSVhFTmcxTlNkRTRwTWMyQmkyQWpE?=
 =?utf-8?B?cFI2SGhmY2ROYWFib3ZRMmRMYU1YQmxoM0pUMlNyUEZDelNkZnV3TFpsdVNk?=
 =?utf-8?B?RnhLSDNKK3ZOYm5vU2xkVFl1Qy90aEdnZFcrcGFKQTFsMUdBNk8wZ3Y4NHRH?=
 =?utf-8?B?S2VYMXdmVldwbU9JSXRaR0x5R1ByTTAvVW52TEV5VjlqQ3pjNXBTcDVnVHRN?=
 =?utf-8?B?SnN4MW5Pb2ZMcVlxby9GZHV6RDBJNWZPMWRUWkRsSDlzaTdBQzY2OGU0NkVR?=
 =?utf-8?B?YUhWQVpXYmtZQVVYWVdNZUpRTGtWeTVzQ2hHQjM0akszZDVLSTR1YjBZYisw?=
 =?utf-8?B?MTJlazlpbS9WaUMvMXNyTjl1c0JnZGxyMkJ1MHlVVFJ2Z2o3UWdHZnZ3ZmZV?=
 =?utf-8?B?b05xUk5palFoTXgraWxzNmd3Rkc2Nyt5ZnZHbWtZQmZDb2NDS1BZQmlVZHQr?=
 =?utf-8?B?SlNCeFZEMUMvUUV1ejlLcEttMUhnWVlTT2xNc0xnVmQ5K1dIYTNpWkt4OXR6?=
 =?utf-8?B?QXhpSm80dDlTMENaMzh3TytSdmNRQ1pXWVZqcE9MdmdCRTEyUGNTN2dOSm1B?=
 =?utf-8?B?R2dSYTlTcnNPQjFpQldRbUNzT2RuU0FwTTUrVWs1bDE2ZnVpOVVGM09OWnNQ?=
 =?utf-8?B?RXdwWjloMlNXNitobWFWa3JWU2NHUFYrOW1Oa2FjMlNIMXN5T3lSYmRkNW1K?=
 =?utf-8?B?bkpoZytOdzI2aWF6R0JZYTZNT2hvZHVaK1g5a0hIRmJhUS9hdmRHa3ErRkpm?=
 =?utf-8?B?Ry8zbXN1VXBJWGFrOWNPaFR1dU9pVnN0akRXR2FXN3ZKL0JzUTV2akVPTXVw?=
 =?utf-8?B?TlBUdUNVbkZZdENZREMzaUVaa2VpMzNxN3dueTFUQ2d3eTR0TjhHc2NSRDJS?=
 =?utf-8?B?QmxUeS9IUHIwU2FSeVUwZ3ZZMVkyWVYweE9nUC9aSnpCSThNSitzTmR6Q3NJ?=
 =?utf-8?B?WHFzOWNEdWlSTFpOeHY3TkxYa2gyeXZOdS9hczdsVnVPTG9MQTk5OWtoZkor?=
 =?utf-8?B?SEZjVUUzNmJVQVE0M1prK0VvelBrYlRoZDBicysvWVA0SXJRYjRZeTBENjg0?=
 =?utf-8?Q?IpufETvfDiY0w3e63n?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d381b61b-b392-4ec6-e101-08df49befdb8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 00:07:56.0291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dpegQm+iJfD6T4Lm3WX/uEcpnTEYsS0E+EMnk/deJnkgxNiWPZQLOTQ0oRLK1WCr7+ptY0WFbLsni0DzrnuRYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9090

On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
> Move CMA DOE discovery out of pci_tsm_pf0_constructor(). An external
> Endpoint requires a mailbox, while an RcIEP can use device assignment
> without DOE. Let each TSM driver enforce its own requirement.
> 

It is DOE of a PF which will be passed through (or its VF).

The AMD hardware has such devices too which are still PCIe so I'd think it is the same TSM driver. imho this is quite common and needs to be handled in the common code.

And the patch does too many unrelated renames, a bit harder to see the actual change.

Thanks,

> Keep SEV-TIO requiring a CMA mailbox and reject devices without one. A
> later patch adds the CCA host driver's mailbox checks, allowing RcIEPs
> to operate without DOE.


> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>   drivers/crypto/ccp/sev-dev-tsm.c |  7 ++++++
>   drivers/pci/tsm.c                | 39 ++++++++++++++++----------------
>   include/linux/pci-tsm.h          |  4 ++--
>   3 files changed, 29 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> index 5c61ce74ee0f..af22f36a2318 100644
> --- a/drivers/crypto/ccp/sev-dev-tsm.c
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -213,6 +213,13 @@ static struct pci_tsm *tio_pf0_probe(struct pci_dev *pdev, struct sev_device *se
>   	if (!dsm)
>   		return NULL;
>   
> +	dsm->tsm.doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
> +					       PCI_DOE_FEATURE_CMA);
> +	if (!dsm->tsm.doe_mb) {
> +		pci_warn(pdev, "TSM init failure, no CMA mailbox\n");
> +		return NULL;
> +	}
> +
>   	rc = pci_tsm_pf0_constructor(pdev, &dsm->tsm, sev->tsmdev);
>   	if (rc)
>   		return NULL;
> diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
> index 5ff1265714aa..2be92bde8780 100644
> --- a/drivers/pci/tsm.c
> +++ b/drivers/pci/tsm.c
> @@ -714,30 +714,31 @@ EXPORT_SYMBOL_GPL(pci_tsm_link_constructor);
>   /**
>    * pci_tsm_pf0_constructor() - common 'struct pci_tsm_pf0' (DSM) initialization
>    * @pdev: Physical Function 0 PCI device (as indicated by is_pci_tsm_pf0())
> - * @tsm: context to initialize
> + * @pf0: PF0 state to initialize
>    * @tsm_dev: Platform TEE Security Manager, initiator of security operations
>    */
> -int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
> +int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *pf0,
>   			    struct tsm_dev *tsm_dev)
>   {
> -	mutex_init(&tsm->lock);
> -	init_completion(&tsm->dsm_context_drain_complete);
> -	tsm->dsm_context_users = 0;
> -	tsm->removing = false;
> -	tsm->doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
> -					   PCI_DOE_FEATURE_CMA);
> -	if (!tsm->doe_mb) {
> -		pci_warn(pdev, "TSM init failure, no CMA mailbox\n");
> -		return -ENODEV;
> -	}
> +	mutex_init(&pf0->lock);
> +	init_completion(&pf0->dsm_context_drain_complete);
> +	pf0->dsm_context_users = 0;
> +	pf0->removing = false;
> +	/*
> +	 * Note, low-level TSM driver responsible for determining if it wants to
> +	 * proceed with a device that has no DOE mailbox. TSM may have an
> +	 * alternate method for coordinating TDISP.
> +	 */
> +	if (!pf0->doe_mb)
> +		pci_dbg(pdev, "No DOE mailbox for Component Measurement and Authentication\n");
>   
> -	return pci_tsm_link_constructor(pdev, &tsm->base_tsm, tsm_dev);
> +	return pci_tsm_link_constructor(pdev, &pf0->base_tsm, tsm_dev);
>   }
>   EXPORT_SYMBOL_GPL(pci_tsm_pf0_constructor);
>   
> -void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *pf0_tsm)
> +void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *pf0)
>   {
> -	mutex_destroy(&pf0_tsm->lock);
> +	mutex_destroy(&pf0->lock);
>   }
>   EXPORT_SYMBOL_GPL(pci_tsm_pf0_destructor);
>   
> @@ -954,16 +955,16 @@ void pci_tsm_unregister(struct tsm_dev *tsm_dev)
>   int pci_tsm_doe_transfer(struct pci_dev *pdev, u8 type, const void *req,
>   			 size_t req_sz, void *resp, size_t resp_sz)
>   {
> -	struct pci_tsm_pf0 *tsm;
> +	struct pci_tsm_pf0 *pf0;
>   
>   	if (!pdev->tsm || !is_pci_tsm_pf0(pdev))
>   		return -ENXIO;
>   
> -	tsm = to_pci_tsm_pf0(pdev->tsm);
> -	if (!tsm->doe_mb)
> +	pf0 = to_pci_tsm_pf0(pdev->tsm);
> +	if (!pf0->doe_mb)
>   		return -ENXIO;
>   
> -	return pci_doe(tsm->doe_mb, PCI_VENDOR_ID_PCI_SIG, type, req, req_sz,
> +	return pci_doe(pf0->doe_mb, PCI_VENDOR_ID_PCI_SIG, type, req, req_sz,
>   		       resp, resp_sz);
>   }
>   EXPORT_SYMBOL_GPL(pci_tsm_doe_transfer);
> diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
> index 68ebe774121b..7e91c15ffe3b 100644
> --- a/include/linux/pci-tsm.h
> +++ b/include/linux/pci-tsm.h
> @@ -160,9 +160,9 @@ int pci_tsm_register(struct tsm_dev *tsm_dev);
>   void pci_tsm_unregister(struct tsm_dev *tsm_dev);
>   int pci_tsm_link_constructor(struct pci_dev *pdev, struct pci_tsm *tsm,
>   			     struct tsm_dev *tsm_dev);
> -int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
> +int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *pf0,
>   			    struct tsm_dev *tsm_dev);
> -void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *tsm);
> +void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *pf0);
>   int pci_tsm_doe_transfer(struct pci_dev *pdev, u8 type, const void *req,
>   			 size_t req_sz, void *resp, size_t resp_sz);
>   bool pci_tsm_is_configured(struct pci_dev *pdev);

-- 
Alexey

