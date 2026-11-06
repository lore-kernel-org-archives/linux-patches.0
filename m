Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793951238;
	b=XpbPPiRKZUlilV7pzDI5nDowccjdqzp1sDKR5ZpK37Hr/daywDvWdAt1p/bRzdqC03nT
	 UaklXOTgGgb3l69+Soz3eqx/kC48BJGX/azKHjvX+fUEst37/NfKKZr+fAYNuzNjMKIi9
	 KmKtqCdG20mV3/PTgr1xq19fGh4KhXr3pwV6LmlffNbs2zY5EaAZht3drFzDSFgqy4Yvx
	 w3Zt09R7T2kDfTUDd3S8tHBICmVS7Zdw1Q+y08jR9iEFrTM505V0YCnmSe1bsHmRdTq5R
	 HEKi4Wg6GrgNlyZHUu1B8xH7+tjgm7zlLMnVHCnEhJBEQorZ4IBHH8T8fPwdUbEvrjg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951238;
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
	bh=+61+tsaj7aNNKtMxxiHVHxkhUgvxn4ElmPh8bjHeT5I=;
	b=NJsithxMFuOTC2OgJnVNpH7fEbDBznDQMiOlt5osx9Doj2b8Q7vBniCUX3gAQIpijuIw
	 FdIuLxMrV9WZP/hSZnPD6mwPLZt28vyoSo796a+VjwwvFa9ty0bKG63zxCmyNyYFhOXqJ
	 IggVUJg5U23MK8UuGkOL1KaFnb1zP2fn2HIHFYCL4lnHG6GhIWPj2XfFHHonLFt8sn2WE
	 G10ZZsQod7XTky/tJ7EAwSweMTU9MxH/o2Gz8L78BWVcYjnST/L+VNUc3QOryniIl3e1S
	 E4HOVaSGpfzqmVIrD+ZyjamzEkKE9SR6lTfa3NVVYx24xySbOn2mHJGmPQUDZzZCGTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TvjchUt5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.37
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010037.outbound.protection.outlook.com [52.101.56.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9097606A326;
	Fri,  6 Nov 2026 07:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9097606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=TvjchUt5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ob5hfRVL544T+oEiK5cfe6sBoBGrstVGJGPn7U8TomqU7lbfG6z/cqbF2XVh1wHL5pjhjwQiAY2Gx9K0OUuX3zgeM3oxUAK3+MzPSvPQ8U4RxCqWV7XtH8iULO4AzrlmX8W5WVkNhEpjDTnLqajNA+T162oZKDDgxNv1TnXna8U5mEENoBxK8ZSKN/amRtEl3NkyFxabYpxU1m9hIcPHgQg5cumU2cyDMoc0H57MLetkWslGmXpavYHavIeBOAx121ENGDCfuX83foOV4P2HRpGjeM6V9aPide9CTk391okgPknmPS6V6MPaqg3CE4oH9Oz1k3//xbRk/n3Bbz1ziw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+61+tsaj7aNNKtMxxiHVHxkhUgvxn4ElmPh8bjHeT5I=;
 b=RhelDQ+SJcJaqiqCNYa/hhNqJPZ4LBtDO+fqHNN0MbfhVBKHt3QIKNVsGEqLkzHwXOi+GGn3Uq5YblSBpG+E0Ry0uzNiFoDa/wUT28QAfypBU29pBbBkQbkdexrRE6pIDfnA6g7BVYubgsWAY+ikNvkuqKIws7tAdFgnDh6iiD8z5hcdjlYIIfauCOjRjAL+OdE/sHjwChF2qI8LMr5fAVBcVc1nmjdJax4yRCfxkpHQzJ/WBFz/1LAQV/FCK6Tz6XLItgaaA4A22p7qrq+iIxaaHfrtlmEX5OAqklhYCBojlyHcF9yQiWI7Oi/ezw5LBu+Qgr25nxeI8gJPcogxgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+61+tsaj7aNNKtMxxiHVHxkhUgvxn4ElmPh8bjHeT5I=;
 b=TvjchUt5sXzvojkcLbPEg5EDLQOSoQRNpv/nMYL2dYr5oDK0mZU4x9oZby3CHPHvVu3QKNS/+SnBq9b3ISN2PVAjK7RUXLJUKGK4kL+Z+K4noj3do6fDUGYn7VXRjQHnvro1Jhpos9zOSWYKa+4H7kUl+7txmSVDOlLeH3Pf44w=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by MW4PR12MB8611.namprd12.prod.outlook.com
 (2603:10b6:303:1ed::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Fri, 6 Nov
 2026 07:47:12 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 07:47:11 +0000
Message-ID: <e8785bcb-45ed-492f-af66-deadfba6ac25@amd.com>
Date: Fri, 6 Nov 2026 18:47:04 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 09/11] crypto/ccp: Defer SEV-TIO link setup until
 evidence acceptance
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Jiri Pirko <jiri@resnulli.us>, Kevin Tian <kevin.tian@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Jonathan Cameron <jic23@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Bjorn Helgaas <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 patches@lists.linux.dev
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-10-aneesh.kumar@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261028152618.1356860-10-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P300CA0068.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::10) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|MW4PR12MB8611:EE_
X-MS-Office365-Filtering-Correlation-Id: d533052d-f1c6-4a08-75c5-08df3bda2a57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10067099003|22082099003|18002099003|6133799003|3023799007|56012099006|261022075727099003|5023799004|11063799006|4143699003|261028144727099003|261021121427099003|261026135527099003|261021130227099003|261021133027099003|261102123227099003|261021123027099003|261026121527099003|261009223027099003|261022105027099003|261026140227099003|261009221227099003|261022115727099003|261021135927099003|261026130827099003|261022113327099003;
X-Microsoft-Antispam-Message-Info:
	Ce3RvF1yXOCOFYjtUUyia0APmKkkm+RZ9gHMvdG0A4l7n9jiJayic8c5nLLSnT4S0JJEVjgP7edMK1NNJ9TZ5smGsW4gf66FyjCG//VO1uR3Zb0PeipAjViP+s4Bhgcn6CyOAmZO/cYwMh3N6kL4ZlWuQU7mhs4krftjkyZizrYjk6TqSkfuA+RW04+GmkQLBH73JU97hXtCic4HZMpBJzGksKIQu198wOOmj+7/INui5G7xFJSTgXYpKMJAcKLRu4837WjUgmSekwUhy1v6N3wYTaYOb8gr8a+5LNs2FBT+l2cnNW16MB7BD4wIREagiKxKQGhnISaNYtBGAi6m1V3D6CAiXRIVJUMYH0z4JDCLXqHh5jxfNaQiSop0XSq1moi7iGaMCAqOqwcXC+dKGWP3pTrB7zQqWp3QaWWzNw2eoPxFL66xkKHRjF4UZSCF5yoArbZfG/zgye1FZrU2r5sVtdeTz187A5X5OiEbAGiyohZf5M/sCNui7D/RnGcTrTgmdEWX9IsbUvM1phSbq4cgwMbpSpJ27nfkwBoweOPvGw3/w7AcWYgSR65oofURtM8H4o2BVStHA7qV6jvb+KT0lG868Z5QdFHGxrQmNIT+7HGs16IapGRpImzuUXHVwUKMv4T48kRh8THkWBfzWJ2ia973cvaALWYUqIcOw58=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007)(56012099006)(261022075727099003)(5023799004)(11063799006)(4143699003)(261028144727099003)(261021121427099003)(261026135527099003)(261021130227099003)(261021133027099003)(261102123227099003)(261021123027099003)(261026121527099003)(261009223027099003)(261022105027099003)(261026140227099003)(261009221227099003)(261022115727099003)(261021135927099003)(261026130827099003)(261022113327099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXc1VTJGejR2RTBjMnhXZmRpTVJVZXJhTEZCdm1iR2NEdkloZGFlQVAyTHBI?=
 =?utf-8?B?QUplWHFWTG80aVMwQjVsOHlvamxjU0Zxa01IY3ozUDBlNTVKQWJjRkZZT1k3?=
 =?utf-8?B?RXJlTUdPcFB2UlBTRlNmZFVZRllPdWY1RFAzQ0FhMEcyem03RG9LYVZ0Q25Y?=
 =?utf-8?B?L01oN0d4ZlJnZGpmdnFqblNuaEdlT0ZSYk81bEk1aFlRR3NpV2l3VUt6bm54?=
 =?utf-8?B?RldvYnlzc1BCcWZyekc3SzZBS0RaRjYwZlRnMXJvMXNEaFBpYjQ4NU1RcEw3?=
 =?utf-8?B?N2VQTUhFM2F1RDdBeDJLVllLRDUwQm1jNmVISWE0MUhLa2haRXFKL1YrMVB1?=
 =?utf-8?B?YkpCdXNVZlJONS9xVFVRQmZOTXJIaThSUi9pTStmRGZPTDEzaTgxa1VLaGRV?=
 =?utf-8?B?cmdDYTk2TnJka1VuZmtxODBYVGZSam5XSTBtQkQyNGhmZ3IxNFQ1WkR6dG5Y?=
 =?utf-8?B?ZWZXYjJvR0VXTFZVWEJ1TnV1OWhmd1ZvN0lnM20rVWtyQmRSMDN6aVBteEV3?=
 =?utf-8?B?SHRWUWZtMFRWdm56K1dBSnljSmg4dk5RMlRma1krL1o3SzhWUW8wYitmS3ZM?=
 =?utf-8?B?SkQ4bGNGbDdIK1NZY0hkZEExZWl6aFB5UXMzVFhmSEd1UWZqMzdXKzdoSkpr?=
 =?utf-8?B?RVNUNy9oNnkreVIyMjNVZllEWm9HZDVraVF2L1B0VFNLYXc3dnB2bHVhRktB?=
 =?utf-8?B?U3dMYmc5cnoyMk1mREt0aTNHZXJZZ3kxZnNkdzFZOUtWS1J4UU5aelNRWHRX?=
 =?utf-8?B?dzRvY3JlMGM4MGE3NmQ1UkdWK1lUcm9hd09uRkRXR2o1Rk53V1lQR1JzR3pH?=
 =?utf-8?B?NzcvdzJYWHMzRFhrcEhRN2tXUWhnVTB6emVJbCtma2pjYWg2UDE4NlE0M1lZ?=
 =?utf-8?B?K0htSzR3RkJsZ21RanhaVktyQnVJc2k2V1AzK0NnL0l5cGxUazdDQXNWb0Nl?=
 =?utf-8?B?NTdhL0JCcDRFOXQwd1g3SW41N1BUUFY2NW41Rzk5V1d5OVYvaU0wRjNCNlhC?=
 =?utf-8?B?RGZNSDZKaDF5R1RWemRjcEFoSFBNQnowVlNBbHlYTmRGdW9sYThhVmZ1aEhQ?=
 =?utf-8?B?WDllVGpkYVZUcFdjWmlQUnZOa2piUy9wbW9lRW9DN1BLNzQ1WEY1eTdMbEc0?=
 =?utf-8?B?L085Yy9HWjBpKzJEMlhaT1E4cjZCci8yNlI5Q25OcUhzT25ncCtqYnVWWFQw?=
 =?utf-8?B?Q3BQcGpybDNDYmVjb0xHWTgvOTBVMk1EcXpsSWhvelQyV215cjhwSlA1bWtG?=
 =?utf-8?B?aTgyWDdWMlAxb0k5S2pONEZYNFoyc0JtaXVGRU1WM3QwTjhidnNseVNFR3U0?=
 =?utf-8?B?REZuT0lTWjNaUHF5TnJNazdTa3RKSGtmbi9jWnFNdFRhcmVBRURENUgvTEdC?=
 =?utf-8?B?RG5TQVlmR0w4NDJFK2EzOTZtYXBwL1N5MmxnT1RNczdWa0tuQTZFdlBqZDc3?=
 =?utf-8?B?T2hjQ094R0kwMnFsUXZDN0haaEdmSU9uUFcvYUdxWWxSVndPeTJudldqbWYx?=
 =?utf-8?B?YmNuN0hvTzVldTlFeEJRbUVZMFJOelJEOHlQbGxhQ1BSU2ZhMXhPZDFtREpZ?=
 =?utf-8?B?MWhZWnIxdmJIWnErNU5OTnNkSEVYYWJ5eGJraDRHTGxVY0hua2w3WDRTazQ1?=
 =?utf-8?B?ZUtpNXFqUHZFRytFeWRFNzJXYWJ4RGVudDB5SFVNTlZQSnp1ZXpJb2hyMldD?=
 =?utf-8?B?QkIwUkowdi8yL0tPK2JtL0loNFRpbVNYeGRZZ0s5K0szSExYU0JCQ1duQWFZ?=
 =?utf-8?B?Qkt3ZlcyaTlQNFBmTmozenoyYnNmRXZqV1ZwQStQY01DWHk4WUNJODlkS1Nz?=
 =?utf-8?B?SjcyZG8rYmpCQ0JYcHFTb3luVHJPaVBudlg1WktzaFZ4Z2xSV090ZC9jcnFo?=
 =?utf-8?B?dWZsL0pIcXh2MUZUR052dndjVVhrV2Y3djhiVmVlbXFib3QxUk85V2R1aGdY?=
 =?utf-8?B?MEd3Qms5YWV2VXBCbzlzL05VKzN4bGxrN0hTOFYwQTR2Ri83NkV3MjdTcGJH?=
 =?utf-8?B?dktOUEE5cTN1TDNNK3piVTdJaXZlUExIb0RudUNGMnNzWUo2bkpuRlBrU2Yr?=
 =?utf-8?B?NXREZzNBNEpkTGhMOFdQVktmakcxSEZrVHo4RlNpTnB4a2pGZmN2L0lMN0Zs?=
 =?utf-8?B?bVpNVlIyVEYwcGt0L2pRTEZRbjVweEltYktiMDNtclpyc1ljZlBxSjMvL2l1?=
 =?utf-8?B?dW10L0lUTWN1MmZBTWcrWmFPUURJQy95V284Y0IzWjNGM01lNGNzUzNrMDB4?=
 =?utf-8?B?MUJRTUV5bXREWHJpWlh0Z0d1M3h5VTRwVU5RUGgwL0xCbnVOY0xDNkN5NDl6?=
 =?utf-8?Q?NYn37zhkqrjJCBKBpu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d533052d-f1c6-4a08-75c5-08df3bda2a57
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 07:47:11.0047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LwzCY6jWDhu1VjgnsC04SRxggh9vBNG7IJPQ9LLyKjZYORIhpC1pUKo05s7xmghrPOFPdljjLY/ujznAfRXW3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB8611

On 29/10/26 02:26, Aneesh Kumar K.V (Arm) wrote:
> AMD SEV-TIO currently establishes its SPDM session and enables IDE during
> connect, before userspace can retrieve or accept the device identity.
> Move AMD link setup behind its evidence_accept callback.
> 
> During connect, reserve TC0's stream ID, create the firmware context,
> and forward only unencrypted identity discovery requests. Cache the
> complete slot-zero certificate chain as firmware receives it. Once
> firmware consumes that chain and yields its next request, pause the
> exchange without transmitting an authentication or session-establishment
> request. No IDE registers are programmed during this identity
> collection.
> 
> Keep the generic callback optional until the following patch converts
> CCA, the remaining legacy link backend, and requires evidence_accept for
> every link backend.
> 
> Cc: Ashish Kalra <ashish.kalra@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>   drivers/crypto/ccp/sev-dev-tio.c |  17 ++-
>   drivers/crypto/ccp/sev-dev-tio.h |   5 +
>   drivers/crypto/ccp/sev-dev-tsm.c | 189 ++++++++++++++++++++++++++-----
>   3 files changed, 176 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
> index c84e23982b43..ff51f09961c4 100644
> --- a/drivers/crypto/ccp/sev-dev-tio.c
> +++ b/drivers/crypto/ccp/sev-dev-tio.c
> @@ -639,25 +639,23 @@ static void spdm_ctrl_init(struct spdm_ctrl *ctrl, struct tsm_dsm_tio *dev_data)
>   static void spdm_ctrl_free(struct tsm_dsm_tio *dev_data)
>   {
>   	struct sev_tio_status *tio_status = to_tio_status(dev_data);
> -	size_t len = tio_status->spdm_req_size_max -
> -		(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) +
> -		 sizeof(struct sla_buffer_hdr));
>   	struct tsm_spdm *spdm = &dev_data->spdm;
>   
>   	sla_buffer_unmap(dev_data->resp, dev_data->respbuf);
>   	sla_buffer_unmap(dev_data->req, dev_data->reqbuf);
>   	spdm->rsp = NULL;
>   	spdm->req = NULL;
> -	sla_free(dev_data->req, len, true);
> -	sla_free(dev_data->resp, len, false);
> -	sla_free(dev_data->scratch, tio_status->spdm_scratch_size_max, true);
> +	sla_free(dev_data->req, tio_status->spdm_req_size_max, true);
> +	sla_free(dev_data->resp, tio_status->spdm_req_size_max, false);
> +	sla_free(dev_data->scratch, dev_data->scratch_len, true);
>   
>   	dev_data->req.sla = 0;
>   	dev_data->resp.sla = 0;
>   	dev_data->scratch.sla = 0;
>   	dev_data->respbuf = NULL;
>   	dev_data->reqbuf = NULL;
> -	sla_free(dev_data->output, tio_status->spdm_out_size_max, true);
> +	sla_free(dev_data->output, dev_data->output_len, true);
> +	dev_data->output = SLA_NULL;

This is a bugfix (thanks for pointing!) and does not belong here. Want to repost, or I can (and should, really)?

>   }
>   
>   static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
> @@ -674,7 +672,7 @@ static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
>   	dev_data->output = sla_alloc(dev_data->output_len, true);
>   
>   	if (IS_SLA_NULL(dev_data->req) || IS_SLA_NULL(dev_data->resp) ||
> -	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->dev_ctx)) {
> +	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->output)) {

the same.

>   		ret = -ENOMEM;
>   		goto free_spdm_exit;
>   	}
> @@ -773,7 +771,8 @@ int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id,
>   free_data_pg_exit:
>   	snp_free_firmware_page(data_pg);
>   free_ctx_exit:
> -	sla_free(create.dev_ctx_sla, tio_status->devctx_size, true);
> +	sla_free(dev_data->dev_ctx, tio_status->devctx_size, true);

and this. Is this codex? :)

> +	dev_data->dev_ctx = SLA_NULL;
>   	return ret;
>   }
>   
> diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
> index 67512b3dbc53..237da723483c 100644
> --- a/drivers/crypto/ccp/sev-dev-tio.h
> +++ b/drivers/crypto/ccp/sev-dev-tio.h
> @@ -58,6 +58,11 @@ struct tio_dsm {
>   	struct pci_tsm_pf0 tsm;
>   	struct tsm_dsm_tio data;
>   	struct sev_device *sev;
> +	bool session_connected;
> +	bool certificate_pending;
> +	u16 certificate_request_len;
> +	size_t certificate_offset;
> +	int pending_spdm;
>   };
>   
>   /* Data object IDs */
> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> index e905ed9de9b5..14d7ef84ee36 100644
> --- a/drivers/crypto/ccp/sev-dev-tsm.c
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -9,6 +9,7 @@
>   #include <linux/pci-doe.h>
>   #include <linux/bitfield.h>
>   #include <linux/module.h>
> +#include <linux/unaligned.h>
>   
>   #include <asm/sev-common.h>
>   #include <asm/sev.h>
> @@ -163,7 +164,7 @@ static int streams_register(struct pci_ide **ide)
>   static void streams_unregister(struct pci_ide **ide)
>   {
>   	for (int i = 0; i < TIO_IDE_MAX_TC; ++i)
> -		if (ide[i])
> +		if (ide[i] && ide[i]->name)
>   			pci_ide_stream_unregister(ide[i]);
>   }
>   
> @@ -253,6 +254,7 @@ static void dsm_remove(struct pci_tsm *tsm)
>   	if (is_pci_tsm_pf0(pdev)) {
>   		struct tio_dsm *dsm = container_of(tsm, struct tio_dsm, tsm.base_tsm);
>   
> +		kvfree(tsm->evidence.obj[PCI_TSM_EVIDENCE_TYPE_CERT0].data);
>   		pci_tsm_pf0_destructor(&dsm->tsm);
>   		kfree(dsm);
>   	}
> @@ -283,12 +285,120 @@ static int dsm_create(struct tio_dsm *dsm)
>   	return sev_tio_dev_create(&dsm->data, device_id, root_port_id, segment_id);
>   }
>   
> +/* Only identity discovery requests may leave the host before acceptance. */
> +static int dsm_identity_request(struct tio_dsm *dsm)
> +{
> +	struct tsm_spdm *spdm = &dsm->data.spdm;
> +	const u8 *req = spdm->req;
> +
> +	if (spdm->req_len < 4)
> +		return -EPROTO;
> +
> +	switch (req[1]) {
> +	case 0x84: /* GET_VERSION */
> +	case 0xe1: /* GET_CAPABILITIES */
> +	case 0xe3: /* NEGOTIATE_ALGORITHMS */
> +	case 0x81: /* GET_DIGESTS */
> +		dsm->certificate_pending = false;
> +		return 0;
> +	case 0x82: /* GET_CERTIFICATE */
> +		if (spdm->req_len < 8 || (req[2] & 0xf) ||
> +		    get_unaligned_le16(req + 4) != dsm->certificate_offset)
> +			return -EPROTO;
> +		dsm->certificate_request_len = get_unaligned_le16(req + 6);
> +		if (!dsm->certificate_request_len)
> +			return -EPROTO;
> +		dsm->certificate_pending = true;
> +		return 0;
> +	case 0xff: /* RESPOND_IF_READY preserves the pending certificate request. */
> +		return 0;
> +	default:
> +		return -EPROTO;
> +	}
> +}
> +
> +static int dsm_cache_certificate(struct tio_dsm *dsm)
> +{
> +	struct pci_tsm_evidence_object *object =
> +		&dsm->tsm.base_tsm.evidence.obj[PCI_TSM_EVIDENCE_TYPE_CERT0];
> +	struct tsm_spdm *spdm = &dsm->data.spdm;
> +	const u8 *rsp = spdm->rsp;
> +	size_t portion, remainder, total;
> +
> +	if (spdm->rsp_len < 4)
> +		return -EPROTO;
> +	if (rsp[1] != 0x02) /* CERTIFICATE */
> +		return 0;
> +	if (!dsm->certificate_pending || spdm->rsp_len < 8 || (rsp[2] & 0xf))
> +		return -EPROTO;
> +
> +	portion = get_unaligned_le16(rsp + 4);
> +	remainder = get_unaligned_le16(rsp + 6);
> +	total = dsm->certificate_offset + portion + remainder;
> +	if (!portion || portion > dsm->certificate_request_len ||
> +	    portion > spdm->rsp_len - 8 || total > U16_MAX)
> +		return -EPROTO;
> +
> +	if (!object->data) {
> +		object->data = kvmalloc(total, GFP_KERNEL);
> +		if (!object->data)
> +			return -ENOMEM;
> +		object->len = total;
> +	} else if (total != object->len) {
> +		return -EPROTO;
> +	}
> +
> +	memcpy((u8 *)object->data + dsm->certificate_offset, rsp + 8, portion);
> +	dsm->certificate_offset += portion;
> +	dsm->certificate_pending = false;
> +	if (!remainder && (object->len < 4 ||
> +			   get_unaligned_le16(object->data) != object->len))
> +		return -EPROTO;
> +
> +	return 0;
> +}
> +
> +static int dsm_collect_identity(struct tio_dsm *dsm, int ret)
> +{
> +	struct pci_tsm_evidence_object *object =
> +		&dsm->tsm.base_tsm.evidence.obj[PCI_TSM_EVIDENCE_TYPE_CERT0];
> +	struct tsm_spdm *spdm = &dsm->data.spdm;
> +
> +	while (ret == PCI_DOE_FEATURE_CMA || ret == PCI_DOE_FEATURE_SSESSION) {
> +		/* Firmware consumed this exact chain; resume only after acceptance. */
> +		if (object->len && dsm->certificate_offset == object->len) {
> +			dsm->pending_spdm = ret;
> +			return 0;
> +		}
> +		if (ret != PCI_DOE_FEATURE_CMA)
> +			return -EPROTO;
> +		ret = dsm_identity_request(dsm);
> +		if (ret)
> +			return ret;
> +
> +		ret = pci_doe(dsm->tsm.doe_mb, PCI_VENDOR_ID_PCI_SIG,
> +			      PCI_DOE_FEATURE_CMA, spdm->req, spdm->req_len,
> +			      spdm->rsp, spdm->rsp_len);
> +		if (ret < 0)
> +			return ret;
> +		spdm->rsp_len = ret;
> +		ret = dsm_cache_certificate(dsm);
> +		if (ret)
> +			return ret;
> +		ret = sev_tio_continue(&dsm->data);
> +	}
> +
> +	/* Connect must stop before session establishment, with a complete chain. */
> +	return ret < 0 ? ret : -EPROTO;
> +}
> +
> +static void dsm_disconnect(struct pci_dev *pdev);
> +
>   static int dsm_connect(struct pci_dev *pdev)
>   {

(indent)

>   	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
>   	struct tsm_dsm_tio *dev_data = &dsm->data;
>   	u8 ids[TIO_IDE_MAX_TC];
> -	u8 tc_mask;
>   	int ret;
>   
>   	if (pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
> @@ -300,35 +410,54 @@ static int dsm_connect(struct pci_dev *pdev)
>   	ret = stream_alloc(pdev, dev_data->ide, 0);
>   	if (ret)
>   		return ret;
> -
>   	ret = dsm_create(dsm);
>   	if (ret)
> -		goto ide_free_exit;
> +		goto disconnect;
> +
> +	/* Reserve TC0's stream ID without programming or enabling IDE. */
> +	memset(ids, 0xff, sizeof(ids));
> +	ids[0] = dev_data->ide[0]->stream_id;
> +	dev_data->cert_slot = 0;
> +	ret = sev_tio_dev_connect(dev_data, BIT(0), ids, dev_data->cert_slot);
> +	ret = dsm_collect_identity(dsm, ret);

Cannot librspdm do that collection, directly via DOE? Ideally in the generic code? There nothing special for the PSP to do and stopping SEV-TIO's connect half way is weird.


> +	if (!ret)
> +		return 0;
> +
> +disconnect:
> +	dsm_disconnect(pdev);
> +	return ret;
> +}
>   
> -	tc_mask = streams_setup(dev_data->ide, ids);
> +static int dsm_evidence_accept(struct pci_dev *pdev)
> +{
> +	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
> +	struct tsm_dsm_tio *dev_data = &dsm->data;
> +	u8 ids[TIO_IDE_MAX_TC];
> +	int ret;
>   
> -	dev_data->cert_slot = pdev->tsm->evidence.slot;
> -	ret = sev_tio_dev_connect(dev_data, tc_mask, ids, dev_data->cert_slot);
> -	ret = sev_tio_spdm_cmd(dsm, ret);
> -	if (ret)
> -		goto free_exit;
> +	if (pdev->tsm->evidence.slot)
> +		return -EOPNOTSUPP;
> +	if (!dsm->pending_spdm)
> +		return -ENODATA;
>   
> -	streams_enable(dev_data->ide);
> +	streams_setup(dev_data->ide, ids);


I kinda get the appeal of not enabling IDE before accepting but in practice the host still has to have a knob in IOMMU to prevent a malicious device from DMAing T=1 trafic so accept() would trigger enable_dma() hook.


> +	ret = sev_tio_spdm_cmd(dsm, dsm->pending_spdm);
> +	dsm->pending_spdm = 0;
> +	if (ret)
> +		goto err_session;
> +	dsm->session_connected = true;
>   
> +	ret = streams_enable(dev_data->ide);
> +	if (ret)
> +		goto err_session;
>   	ret = streams_register(dev_data->ide);
>   	if (ret)
> -		goto free_exit;
> -
> +		goto err_session;
>   	return 0;
>   
> -free_exit:
> -	sev_tio_dev_reclaim(dev_data);
> -
> -	streams_disable(dev_data->ide);
> -ide_free_exit:
> -
> -	streams_teardown(dev_data->ide);
> -
> +err_session:
> +	/* Disconnect owns cleanup after firmware or IDE setup has started. */
> +	pdev->tsm->error = true;
>   	return ret;
>   }
>   
> @@ -339,14 +468,20 @@ static void dsm_disconnect(struct pci_dev *pdev)
>   	struct tsm_dsm_tio *dev_data = &dsm->data;
>   	int ret;
>   
> -	ret = sev_tio_dev_disconnect(dev_data, force);
> -	ret = sev_tio_spdm_cmd(dsm, ret);
> -	if (ret && !force) {
> -		ret = sev_tio_dev_disconnect(dev_data, true);
> -		sev_tio_spdm_cmd(dsm, ret);
> +	/* A paused or failed connect needs forced firmware cleanup. */
> +	if (dev_data->reqbuf && dev_data->respbuf) {
> +		force |= !dsm->session_connected;
> +		ret = sev_tio_dev_disconnect(dev_data, force);
> +		ret = sev_tio_spdm_cmd(dsm, ret);
> +		if (ret && !force) {
> +			ret = sev_tio_dev_disconnect(dev_data, true);
> +			sev_tio_spdm_cmd(dsm, ret);
> +		}
>   	}
>   
>   	sev_tio_dev_reclaim(dev_data);
> +	dsm->session_connected = false;
> +	dsm->pending_spdm = 0;
>   
>   	streams_disable(dev_data->ide);
>   	streams_unregister(dev_data->ide);
> @@ -357,6 +492,8 @@ static struct pci_tsm_ops sev_tsm_ops = {
>   	.probe = dsm_probe,
>   	.remove = dsm_remove,
>   	.connect = dsm_connect,
> +	.evidence_accept = dsm_evidence_accept,

I saw in your branch you are ditching the connect() hook, is that the plan? Thanks,


> +	.evidence_types = BIT(PCI_TSM_EVIDENCE_TYPE_CERT0),
>   	.disconnect = dsm_disconnect,
>   };
>   

-- 
Alexey

