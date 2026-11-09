Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794218599;
	b=LJ3n6ucEdqHIpfoncLEPCC+wjA6VEu+F5bTxY4w90TrT0LGaqN1soev5Ox3jCUdAov+K
	 zHKMP3Mf9norwaVxea5bBCXr4Q/xWupVv1UDKqQiXDRvrTxoJLVcLMt7woCebgXODeKpO
	 qONJFmoOVSkxJ6QfGRbxn/Zz3vOUUIEf582iIj8EI5gVFqNDb3/2kpHbGyUgVN/U4g6qx
	 WG94AvZKdcgF5uluPqaUNHedTSvPmJTmFdP9a0/idG0YL8Nx7wAsRSBxVcYyc6oCGTIUl
	 wiq7mY35N/207q11gwxU+SC3UNW9V43ElWNv2z2YV/HZiASFBFdNGUbYzmFzWD4VmIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794218599;
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
	bh=XT8PSqeyjCqjd0fH9b/S9+CNYa1M9vIi0P8wlyuar4M=;
	b=edTCNlAOvIQvX7cZZOizGZCOXeetmmaxHh74GfhrtSwSVLKRklcLthZxPPocbxg2hNM6
	 X2Utgz8LZw4191RJb7Nd+uAcCW45TEkdP2ELBNrJzYonXzTn5w7QD4KCuVVq0HiIoVgTJ
	 theMvX0dJo2Qi+BqofFlHYCKLEykifSEqYDPyysnjbU7BtzkQGL6rotjNUNS0Wg0BlZlK
	 pIsRQsnHEYlj5zh3zkgN6WNZttirqh3vqCU0pCEpmXEsNB1ncuo+DH0hA5d1Qi7sPd+Dq
	 4w2+6tHKtVvqyW7yLbO3QaCEYlelTLH2u+8tbpMqgZuyCazWZYA7oeQUDx/gl6/M1dQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="SF6h/Yx4";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.68
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E24606A321;
	Mon,  9 Nov 2026 10:03:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47E24606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=SF6h/Yx4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hWCUcfXwe0sfLHfQdJni9sIp+tq9vrNqRRJr7VGSHxN+ah6LHM1h1KXYrZuowAVUHvQtFD0OgumTvH232QIUyChX5WrHrtuBym8KsmdaKdBmaOh3zIbRd7DFeRV2BFuUbxkXigqQvUrjWlstIj+QoIST9Gz+1sHU7FoyA1pk53V4gN/WN+jXPjvYfV6+zULu1q8ZR0ZUgu8k++kpkAG+SSokR6jEF+DZ67iGbornwUqOz/k+om4BKNiBr4K8gr1eBY2rZxZU9ZbMnvdqZwmSZF+UGdA74n2lBSrjNY8hQdlAWg7oeMz+HvcjLufRw71Pdwp9XH9tGYIhGffZ89TUHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XT8PSqeyjCqjd0fH9b/S9+CNYa1M9vIi0P8wlyuar4M=;
 b=jJVp4dJ9ZU1iuaXLePY6bl+biII+9rFaCEUBs2ZjozHV4xiGGVVsEspDyOoyyHjGgNupzo9IKwvzR/9y8kpU9RSGW0H8YgRiV6DfNWSjPcKcC0GDYjDggxeUCxEu+z72u4pxzgNXkUEdC8Lb/f1/XTSqvb5oR6FQFmm7o4UyWBqgUQa3BZAWPwTYmJPQsKuUUy8odmUeVtZOc0icRGgT1YqkSo0Sf/6dsth0wg5R7AQq4Y9UOgRBTCm2ieukgMtzpIY45/EUwJUlKB8ifm4hJsBsxl273RMfGJ+LQH/l1Ex3A66IxXWkPfDzQPDdK339quyjO8z6Lc7l94nAvynHvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XT8PSqeyjCqjd0fH9b/S9+CNYa1M9vIi0P8wlyuar4M=;
 b=SF6h/Yx4vepHZ1eR0mGqMrQ6Kr2Vw6/RxhzuRUfCrEIzYnYjQ/oU/4KJbTrXufNfsWpU5LjkP5Eo4euXQXyAaMDvI5BCDVEo5d14DsYBr0+ob/hpbFvgGF30iA07SiebGoHIPEqdjxtNv61TAwE0RFP5XJyExVLQHjXNfPM6+qA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by MW3PR12MB4348.namprd12.prod.outlook.com
 (2603:10b6:303:5f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 10:03:15 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0592.010; Mon, 9 Nov 2026
 10:03:15 +0000
Message-ID: <066c612a-057d-4f32-93eb-a9bf7d2ff372@amd.com>
Date: Mon, 9 Nov 2026 21:03:08 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 09/11] crypto/ccp: Defer SEV-TIO link setup until
 evidence acceptance
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, linux-coco@lists.linux.dev
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
 <e8785bcb-45ed-492f-af66-deadfba6ac25@amd.com> <yq5ao6c2p0ek.fsf@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <yq5ao6c2p0ek.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY0PR01CA0013.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::18) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|MW3PR12MB4348:EE_
X-MS-Office365-Filtering-Correlation-Id: ae910310-652e-45f6-be2c-08df3e48ac20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|6133799003|10067099003|3023799007|4143699003|5023799004|11063799006|261028144727099003|261026121527099003|261102123227099003|261022075727099003|261022105027099003|56012099006|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	FFD3be8prqIMtkmPTR2svMqbmzIocKimgsLn0V5N9IaUAD7nslxrU/nsPzg6XEbvyoiIAfqPQTd+PrO1POPb60AidH6G4TPRwzGeAdovkUNNukFJrzlbjeadolir4g44THOgZhmCRP7cpA1zIzNo6I74GJ/CJYbhlXg6q3bVj79yWZ8Mz0iTSlp6HGRNxtaAlorPUNnblniBsFpzjVQju3uiz4lRdrrg0nKItf63TLXaHTz39FLbYcSI4GjwSj4uhNxntnTQPSejXIav5wl99ck8D+ogVCcS1QQTKhWPMDj10dMiyfQbdNJ08Qqvgl7dgU2NWN4auvh3NSMnmQ/i4fjYbcVdtSlPQyC2OIKBY8Z9/oeN31Qq9iSSiXoN3idApNAPoVAlZij5OlFzGNuTk720uaNlUekXomUw7Tc0N9qPcaV8LZy3Z/OOQvpGNipuxJW8iXnDesgXziadlMKRNAGM/26yWr9LvY5ul+NHmJFUuqJQrqqta9OzVaymWQcXzxvx3gMmrrryYZYBqmajBfZ98lYylwMu+6fE8LKq0Bkkahb4QlqwoAiq/j/3zMqyReaGTjb3CMwndpz26HPmLXoV+8qZIAcgVMxoRoMb3lROl9nZB9/A8FX2obYbAYjU7s2xnMNV0VLSjwJNrC3AduO9iLhf6g4n3Du9ZU8uP2g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(6133799003)(10067099003)(3023799007)(4143699003)(5023799004)(11063799006)(261028144727099003)(261026121527099003)(261102123227099003)(261022075727099003)(261022105027099003)(56012099006)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXcwL29OOHIwelNVazF0TVZRcjFjL2F6dmhYRXVnUEU1RFl6aExmd0lLTFdw?=
 =?utf-8?B?UUJ0c3ZoTUZ4Y3VZVmdzckYxbFk2R2JRWXJCbCtFSTk3UjR1UmU4cHczdXpX?=
 =?utf-8?B?RENIeHhLYTNsaytRTE4yNEpNY3V3VnFkV01jVGtFcnZFSmZHUmlkMWVSeW1O?=
 =?utf-8?B?d0dGNVNLZVo2ZFdFM2VWeFczbDlKbmR3WlVhQlpOcnlDcWhmc0JnaWx6TVFo?=
 =?utf-8?B?dmpTUUFEa3RwNFpteHlPeTM0U0h3L0hCcFBhSmpoaVY3aUE5WnYwL1p6L0to?=
 =?utf-8?B?UVk3MW9aMXQ0RzVJVU9SZWVaakkzS0NvbUorZklSZTB1M2JyTUNXY3E2ZTk1?=
 =?utf-8?B?dFMrSW80UWtHME94RUFmYnQ1aDNUS0JCVUFqdlFvREl3K0daQnpmL2IyMnB2?=
 =?utf-8?B?ZTFaZ2o3a3Z1V1RLT0c1RSs2OG1PNm0vRG4wR0pNVytrOFN6VThZaU9odjA0?=
 =?utf-8?B?M1FYbW1pSEZPcUdkZW5KZk5FQ0tvQlE4eFR3N3JxblJHN2pSTksrWlk1STNZ?=
 =?utf-8?B?NjJPQ3Y4NjVnWisxdnJOZ1crTi9uWE1OeUpQOFRNWEpKUG9oV0hmUUdVSUFz?=
 =?utf-8?B?UWV6N0FZYkZPbk1RYWYvYjNYWDg5ZCtMUmJreHhiQlJyR1Z5SnpzaHJIcytq?=
 =?utf-8?B?R05rcHMzelZIKzdIQXhFRWs3QXgxTFZuUmhzN1h5S0hyVFFzNTFzN3M0QTBi?=
 =?utf-8?B?djFqanA0THFPeFBUZ1BEcmJGM1Bwd09QU3BJTC9TclhzWFlsQk9pY3doWENO?=
 =?utf-8?B?RTBWbTJDTmY1SU9EQ1ZzVXY4QmthME0rcWxGYnF1c0NTNUpITzVXR0RrK0lO?=
 =?utf-8?B?UklBemdRaUV1VktBR1YzQ3E0dnB0akpoRFlqd3c1S2xvekdvdUhHQWs0ZlR5?=
 =?utf-8?B?S1h4dkNmcWExVVpBd2xDNTEvcVpoUGRpQ2VwRUU2T252R3NnTytIUDBNVVJK?=
 =?utf-8?B?SmxkNDJLUHZVODJvYUVvcEErU3dRZDd6Mis2SHFvVjkyM3I3QjFKVHptUHBD?=
 =?utf-8?B?b1YyN0hjdHZ0dnJBSlk2MXBOUnR2cWhxVUUvclFrZHRVR1NKT3daZ2x2OWVY?=
 =?utf-8?B?Uk9hc0lrOWFIaDRBOUtrMHJYYTNnc2VibytuZDRSRmYyZXVsUEc0clpiUkcx?=
 =?utf-8?B?TXkrbGszNjNuUlE2cXNYdSt5OC9pN2ZrblVPUEFSUUEralZzZlRxR3owaVlK?=
 =?utf-8?B?VFk1MlQwMENsTlF2Z1dNTEtCb1l0RjUxMDJkQUhxcUcvRUQ0YlZGeWlKWHU5?=
 =?utf-8?B?SENVNjVwTXNiQnN6MWc4aXlQRlFSbko2YnVsRVJXVDlhZVNDK3dEYmFkUGVL?=
 =?utf-8?B?RkJweDRob0ZzY0FFNGtWbFR1di9vb2czckdmZ2VSbHp4T3VGRVpnU3o0dmkx?=
 =?utf-8?B?M3dTaHZ5aHZoK3BMQ1BBNVFuQnhrOEEzRkxQMkJ2RkZiMXVMVElGakpGd2k2?=
 =?utf-8?B?amZ5V3FwUzFsK0x1czFWclBMWTkrSUZycExOUW1GNVJ0ak1IeEx1a0VBMlM2?=
 =?utf-8?B?VEZ3bldOcXEwSU1FdUhoam9WZ1Nqano0T3FSbURmUmRtR2p5TzBqakp2Q3NM?=
 =?utf-8?B?M1dUV0ZaK2Q1UXNWRkFlUDlwcjZySW1DYkl3d1pESWRVR0NhQ29xUWI5dzEv?=
 =?utf-8?B?VElCYjlCSWMxT1JocS9zUjBJTnNZa3U1NFRkTE94RTNrZzF2czdSclcxSnF3?=
 =?utf-8?B?VEpyK1NSNjBlTUowd2lzam1oMVNvcTFGeFFWRFI5dG1DRXRwMEZkL0hpbmpt?=
 =?utf-8?B?cU5jQngxNjFJcC9vNnhvQzJUMTVoRVlObXpNaEw2T0Rvd0lUQktwK21mVkM5?=
 =?utf-8?B?d2U3WnZubUlSVXY2bnljWE5ObGtxRE9wVG5hTExHb2FiME1KdnBHWnE2bmhU?=
 =?utf-8?B?V1NBMWpqTDZhcFpYVEZlUFl2bDI5UnphMGRPWk1kK1lqNTNZWkJhbjhMa0dC?=
 =?utf-8?B?dkNZa3JCbi9zVTRtTnpub1ZpajVlZkJMM3JaMGVzK0oyY1kzUjBONC82Lzdv?=
 =?utf-8?B?Smd6UUNZOC9STnFDeFZ2djFadTMxSTJhVWZTZHNabmhvU3lrQm1LTE5VSEZs?=
 =?utf-8?B?Z0w1a0lTaFM2dmFnTmY4ekNySFlLMzZGdkJQZ3kxaHF2NlNER1JBUDAyRDI2?=
 =?utf-8?B?Nzd5OTZUVkhYSzdYUTl1UmIwajI4bGgycnRDUUV1L3o0b0hZNmhucmhGMCtl?=
 =?utf-8?B?emJoU2o4TEZlN2hoM2hKS0dpY2YzV2dOZktoR204MVpOajZhMWwxNXlNblR3?=
 =?utf-8?B?KzJ2UVpSeEsrK2pOTEdxUjQ3Ris0dE05R3lnSjRqbkV1VXJTVlV5NmFJSk1Y?=
 =?utf-8?Q?nq8qa4pvBS4XWGeP3k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae910310-652e-45f6-be2c-08df3e48ac20
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:03:15.7163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TBVQd2vZ8Eipb4xuso/vxa2jMTGeUiqlQfQOVB9pDA8czLjRtONjVB9zN68tRC1o9Lql8X8N7SHV3LO0BgdxvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4348

On 7/11/26 00:14, Aneesh Kumar K.V wrote:
> Alexey Kardashevskiy <aik@amd.com> writes:
> 
>> On 29/10/26 02:26, Aneesh Kumar K.V (Arm) wrote:
>>> AMD SEV-TIO currently establishes its SPDM session and enables IDE during
>>> connect, before userspace can retrieve or accept the device identity.
>>> Move AMD link setup behind its evidence_accept callback.
> 
>   [ ... 49 lines skipped ... ]
> 
>>>    	dev_data->req.sla = 0;
>>>    	dev_data->resp.sla = 0;
>>>    	dev_data->scratch.sla = 0;
>>>    	dev_data->respbuf = NULL;
>>>    	dev_data->reqbuf = NULL;
>>> -	sla_free(dev_data->output, tio_status->spdm_out_size_max, true);
>>> +	sla_free(dev_data->output, dev_data->output_len, true);
>>> +	dev_data->output = SLA_NULL;
>>
>> This is a bugfix (thanks for pointing!) and does not belong here. Want to repost, or I can (and should, really)?

still ^^^

>>
>>>    }
>>>    
>>>    static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
>>> @@ -674,7 +672,7 @@ static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
>>>    	dev_data->output = sla_alloc(dev_data->output_len, true);
>>>    
>>>    	if (IS_SLA_NULL(dev_data->req) || IS_SLA_NULL(dev_data->resp) ||
>>> -	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->dev_ctx)) {
>>> +	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->output)) {
>>
>> the same.
>>
>>>    		ret = -ENOMEM;
>>>    		goto free_spdm_exit;
>>>    	}
>>> @@ -773,7 +771,8 @@ int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id,
>>>    free_data_pg_exit:
>>>    	snp_free_firmware_page(data_pg);
>>>    free_ctx_exit:
>>> -	sla_free(create.dev_ctx_sla, tio_status->devctx_size, true);
>>> +	sla_free(dev_data->dev_ctx, tio_status->devctx_size, true);
>>
>> and this. Is this codex? :)
>>
> 
> Yes.>>
>>> +	dev_data->dev_ctx = SLA_NULL;
>>>    	return ret;
>>>    }
>>>    
> 
>   [ ... 179 lines skipped ... ]
> 
>>> +
>>> +	/* Reserve TC0's stream ID without programming or enabling IDE. */
>>> +	memset(ids, 0xff, sizeof(ids));
>>> +	ids[0] = dev_data->ide[0]->stream_id;
>>> +	dev_data->cert_slot = 0;
>>> +	ret = sev_tio_dev_connect(dev_data, BIT(0), ids, dev_data->cert_slot);
>>> +	ret = dsm_collect_identity(dsm, ret);
>>
>> Cannot librspdm do that collection, directly via DOE? Ideally in the
>> generic code? There nothing special for the PSP to do and stopping
>> SEV-TIO's connect half way is weird.
>>
> 
> 
> This patch does not use rust-spdm and avoids introducing that
> dependency. It uses slot 0 to initiate the session, retrieve the
> certificate chain, and return it to the host. After host approval, it
> resumes the session and enables IDE. Only slot 0 is supported, and the
> host can reject the device identity before IDE is enabled.


What is the plan now? Have only TSM do DOE and use rspdm for parsing DOE trafic to keep the host OS informed? I went through these two threads and got a bit lost :)


> 
>>
>>
>>> +	if (!ret)
>>> +		return 0;
>>> +
>>> +disconnect:
>>> +	dsm_disconnect(pdev);
>>> +	return ret;
>>> +}
>>>    
>>> -	tc_mask = streams_setup(dev_data->ide, ids);
>>> +static int dsm_evidence_accept(struct pci_dev *pdev)
>>> +{
>>> +	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
>>> +	struct tsm_dsm_tio *dev_data = &dsm->data;
>>> +	u8 ids[TIO_IDE_MAX_TC];
>>> +	int ret;
>>>    
>>> -	dev_data->cert_slot = pdev->tsm->evidence.slot;
>>> -	ret = sev_tio_dev_connect(dev_data, tc_mask, ids, dev_data->cert_slot);
>>> -	ret = sev_tio_spdm_cmd(dsm, ret);
>>> -	if (ret)
>>> -		goto free_exit;
>>> +	if (pdev->tsm->evidence.slot)
>>> +		return -EOPNOTSUPP;
>>> +	if (!dsm->pending_spdm)
>>> +		return -ENODATA;
>>>    
>>> -	streams_enable(dev_data->ide);
>>> +	streams_setup(dev_data->ide, ids);
>>
>>
>> I kinda get the appeal of not enabling IDE before accepting but in
>> practice the host still has to have a knob in IOMMU to prevent a
>> malicious device from DMAing T=1 trafic so accept() would trigger
>> enable_dma() hook.
>>
> 
> This enables IDE; it is not the TDISP RUN transition. Am I missing
> something here?

Correct, it enables IDE only but the code prevents IDE key programming. I wonder why. Is it because before the host accepted the device - bad things can happen? What things? If we suspect the device - then block it at IOMMU level and unblock upon acceptance.

This stopping DEV_CONNECT half way is weird imho.

>>
>>> +	ret = sev_tio_spdm_cmd(dsm, dsm->pending_spdm);
>>> +	dsm->pending_spdm = 0;
>>> +	if (ret)
>>> +		goto err_session;
>>> +	dsm->session_connected = true;
>>>    
>>> +	ret = streams_enable(dev_data->ide);
>>> +	if (ret)
>>> +		goto err_session;
>>>    	ret = streams_register(dev_data->ide);
>>>    	if (ret)
>>> -		goto free_exit;
>>> -
>>> +		goto err_session;
>>>    	return 0;
>>>    
>>> -free_exit:
>>> -	sev_tio_dev_reclaim(dev_data);
>>> -
>>> -	streams_disable(dev_data->ide);
>>> -ide_free_exit:
>>> -
>>> -	streams_teardown(dev_data->ide);
>>> -
>>> +err_session:
>>> +	/* Disconnect owns cleanup after firmware or IDE setup has started. */
>>> +	pdev->tsm->error = true;
>>>    	return ret;
>>>    }
>>>    
>>> @@ -339,14 +468,20 @@ static void dsm_disconnect(struct pci_dev *pdev)
>>>    	struct tsm_dsm_tio *dev_data = &dsm->data;
>>>    	int ret;
>>>    
>>> -	ret = sev_tio_dev_disconnect(dev_data, force);
>>> -	ret = sev_tio_spdm_cmd(dsm, ret);
>>> -	if (ret && !force) {
>>> -		ret = sev_tio_dev_disconnect(dev_data, true);
>>> -		sev_tio_spdm_cmd(dsm, ret);
>>> +	/* A paused or failed connect needs forced firmware cleanup. */
>>> +	if (dev_data->reqbuf && dev_data->respbuf) {
>>> +		force |= !dsm->session_connected;
>>> +		ret = sev_tio_dev_disconnect(dev_data, force);
>>> +		ret = sev_tio_spdm_cmd(dsm, ret);
>>> +		if (ret && !force) {
>>> +			ret = sev_tio_dev_disconnect(dev_data, true);
>>> +			sev_tio_spdm_cmd(dsm, ret);
>>> +		}
>>>    	}
>>>    
>>>    	sev_tio_dev_reclaim(dev_data);
>>> +	dsm->session_connected = false;
>>> +	dsm->pending_spdm = 0;
>>>    
>>>    	streams_disable(dev_data->ide);
>>>    	streams_unregister(dev_data->ide);
>>> @@ -357,6 +492,8 @@ static struct pci_tsm_ops sev_tsm_ops = {
>>>    	.probe = dsm_probe,
>>>    	.remove = dsm_remove,
>>>    	.connect = dsm_connect,
>>> +	.evidence_accept = dsm_evidence_accept,
>>
>> I saw in your branch you are ditching the connect() hook, is that the plan? Thanks,
>>
> 
> 
> Yes. In the full branch, once rust-spdm is integrated, this entire flow
> moves to the SPDM accept/evidence_accept phase.

So now we are teaching the TSM driver to stop DEV_CONNECT half way? uff...

>>
>>
>>> +	.evidence_types = BIT(PCI_TSM_EVIDENCE_TYPE_CERT0),
>>>    	.disconnect = dsm_disconnect,
>>>    };
>>>    
>>
> 
> -aneesh

-- 
Alexey

