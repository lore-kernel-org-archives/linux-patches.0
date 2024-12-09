Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D9C374EA;
	Mon,  9 Dec 2024 08:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732330; cv=fail; b=Ayn51CHnyX9okSLi7bP1vEWIM5U7cq1y+WGP0Axn9ansjqhgQLaJm/9Bop+E9va1Tydi4HeZhm9eyqfU0gzEUi0A3MlolpWVsIAlqxPnDoWussyHaOwRr6uLV/9HDU3/mgcUZ6DCsoUGcGMkDzZhbbSkxA+yikBpPC7ZzeckFxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732330; c=relaxed/simple;
	bh=zAX/3zSMB+t5OhtRBdfyLs5iYRaEgfwvV2RNyrQBB/s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gr7BS3TIcIBsRL4hg3B04EJRGpiqERkoLeGCMZKI9Jfe9lBtHExaY7Dt4nmwtATcBXdVxbkp3ANIyeUbYrQ6/kHrnCNHoeBm5xqOmlCkDBFLLcl/Ml4ePQfMppf0i4GJdo5zBwA77lX3KeGc/QK0cM7drjck428N0a/S/uSlJLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f19awuMf; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f19awuMf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jIt/7ISsnx0dojTclpd8q8ScqUMfDg6ci8PO0Mbv/3P8Ask+VEyeNmGonov6Un6YiC9yqSdsc2zoxoMKVlQvt9FNITgh7EZvbcsoOOT0LbuVSkBXsoZY65AZOgudYGTe77MHU+DAjAUpfzuPXF5gEwRBOTuREo0/Fyx3oVwEt/v3hNT8i+qOPOVx49pw2H245j58vjlwu3dqhQIWXKYYJY2Q+XK0YcKgU22c1TrKaqR3v8fjknD7k3RtDpl8xel9S8EDM/3vkLi1+mMhZ78UCZ1DldvOfGY/7eeWnv8LhCV3MBlw4c9AEd/OeE14WfLI6KMWp0/nQNm2ZbDuBY01JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOm+TolG9zZr044uwpqxSdUjTWnMFhXTaQMhP0hXdTQ=;
 b=XBD1EubsUDBg6XIffxR2RgOcnXMY2OTNIQjy0VimFj5tHoA2GRNzNoE7HYurkDqSSV+GPxX7OfafOvtiaFvgAZ4y+9Hg8J7ttYnvlpjVVSsse244pnVireuyROkqWmkqOV4bJcUt9PlVl4GFAv3afLoe1Nyk0v4vE89jewMyLKHcsqjzIDEQFsKwDwy3c1sX1UIa1cB3APeFK6VeDq8as5Ndq7mX1fbRDe3luDq2wT5Dnia0Lmu8ZIvq+oO5V+yjd87K4f2mbRo9KaY9d/Yh57btqWkLAKMOiWYjxXMoyqt/GRY/D/9ZLEPheLFQqVAM4Z1/AUt7/Pp0V/m5V2AO5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOm+TolG9zZr044uwpqxSdUjTWnMFhXTaQMhP0hXdTQ=;
 b=f19awuMfeMcRCcqOojH4Cd8nlX7STBqm91mt5m8jojW6Be3n0hyGzTqvlxj+uisfelClwvl+xaT5jkaZzVqdv4bpEmYT2WONsETryh5yCtTIoOVaZimIBJxzVP7tJLl22xvPIYpDt0OMcNrWbczfR58b3lmdLbB5hENuYXSbICI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 08:18:46 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%3]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 08:18:46 +0000
Message-ID: <86b5147b-71ce-4015-927e-b420c3e05624@amd.com>
Date: Mon, 9 Dec 2024 13:48:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc 2/2] iommu/amd: Add lockdep asserts for
 domain->dev_list
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev
References: <2-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <2-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0049.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:23e::22) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|BY5PR12MB4227:EE_
X-MS-Office365-Filtering-Correlation-Id: f1b51cb9-e9e4-4fed-3491-08dd182a19be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjlxR3MvZjErV093SGcwU2xuVkJiVzB3bDl6TEIzWXNxSHdyNFFZUVZhVDM0?=
 =?utf-8?B?L3gxRmljOUNQM1pzWFU2R1g5TTZTRjZSeFg4TlBhSVpaWDg5U1dGUzJ3U0xH?=
 =?utf-8?B?OTg1RWdSdlFCcGhzbCtsWm9CdVgrRkNxRG4rTTFEMGR0cDgvYjBWV01Vd0dm?=
 =?utf-8?B?cmhhVlVUMVFEb3d5RFMzSnVQd29VaHJDc1h4NkdFNnNWWFUzL3hpdnROZlF2?=
 =?utf-8?B?cVRpTWlsWldyZ2RweVdNQUh1a1FOYjBjcmVqZ0VZcUVGRFdMSEpHaXcxTm83?=
 =?utf-8?B?eDNadTBzVkY3Z3JlT21yUnRLNlAwS0RPSVR6cW5NLzdQUTA3a2JGRGViZ1Ax?=
 =?utf-8?B?dm9jZ1JhcjJoOWFlWVRUbi93MEJsWFFkVnlYVnRvZUNFMVBGN0ZxVXpPS2VV?=
 =?utf-8?B?czg3MStJSTVGTlBVcWx5b0x4RnZkSkpzTDY3S3hxMVE4WHVJR0tobE44M3BF?=
 =?utf-8?B?bTZNSGU5SGNyelZ3SFRZOHRuZFJGQlhMQThOMk5BSG9CZ0xtanlCbTY1QS9O?=
 =?utf-8?B?UHdZVVYzZjdLR0RzcUVpNzh1OER4OGZoeEU3Q0RxNERUWGwrdGtNem5ad2JJ?=
 =?utf-8?B?MXMvSUIyaTlpWEtLcU0xWTFxdjF6cmRrQmVWOGppNXF6ZUs1cE8vZzB0Vk95?=
 =?utf-8?B?elZidjVSNkcrRGNtVzk5dTl6S05NeVhCNVdyWmZzV2YwUTNUTHNsNFZ0a0xT?=
 =?utf-8?B?emhPN1hEVnBuWUt1cU1hVmltUGZMRlJYcVpNUEwycEVvT0RicGd5c04wdmZW?=
 =?utf-8?B?ajVtd1JUVGNGZmlpOW9tM2dBNG1XRkYzalJFSGE3eU5Yci9ITUJuTWM4aDV2?=
 =?utf-8?B?QXNFckxjRjAydHg5NDAyRjR1ODMvdUNFRWV2MWROdlhCN1FqUk41TkIyRDg5?=
 =?utf-8?B?SHB2aEZUcmxXOWxGdHpmM0pPbkFZOUs3YTVIWGlQMzdnYk16TnJVU0hEb0dt?=
 =?utf-8?B?WmNSVThuNEQxVmJNR3ZHSitKUHlYOFZrdkEvK2FzemxLNkJscTQ3cjYyMnJt?=
 =?utf-8?B?cEs3QTVLb1ArY3g5bFVIUUhZSVpXckZ2K2ZpdGt5Unk0dlFhdHJSeUN2Y2pa?=
 =?utf-8?B?NHQ3eFJJcGhMOXRmektjdTRMTWVmWXUwL3ExdFd1M1JJRnp5YS9LK1JOdnVV?=
 =?utf-8?B?L0dkWE5oek5SbGZMeDVvdExIc1NlVVFlOHV0bVRKYjh2UzlNOUQ0TnJPZy9o?=
 =?utf-8?B?ZzlIKzI3bWpPSWhJUzkwZHQ2ZXdoaEtNWlk1RGZ2SWI4eVBuSjR0MVpzS3Jj?=
 =?utf-8?B?YlBJVEpJby9YYyt4Y1F5bGdYRGNNSkxKamdZTGZucnJtSzFEL1d0WTZLSEhJ?=
 =?utf-8?B?Y0o4ZEIrclkwajNVTms4Z09ycGlMNWRUaEo5Ly9ORjFwY2tXKzdteUhscEZq?=
 =?utf-8?B?NWNYUUpmT0JyL1FHenBLdjcvcSsxKzV6Z2FFNkM4SVVUenNhb3NOK0gwb2Vh?=
 =?utf-8?B?c3hxTGJuZjQ2eUpqbmsrRDVkNlNpZTg2aUkycmowczB3OTVCYVlXb0ZJU0Rh?=
 =?utf-8?B?QVRjVXlRYXM5dlFBby9VWnZIQlljTHZncjVVUG1ZQmprN2VOOXYzZDlEU0VR?=
 =?utf-8?B?SmVtZi9KOXAyZmpWY0lrdFRIbVNIVk5QMmU4RHdMUHAvTWh6SG90aGhqL01Y?=
 =?utf-8?B?NGVDd1pCUmgrQTNuWGQ2UEFvMjFidGQyUFU3Vmp4aEFzeHpyKzYwblpKN1Vz?=
 =?utf-8?B?MEVaOFlESG1ubmlSV2N2TW1pbzVtS2VNOXRqM0xWZHJVc3lYdzFpdHhoa1Fq?=
 =?utf-8?B?cHNWcnh0QVdEQk1SRFp0dFVhc2J4dTA0aloybjFaejRhQjlzaVVWZzgyOE9z?=
 =?utf-8?B?L3haRWdidnVzejY5d3ROZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWc3bkV5YmNKLzZTelVMSVBJVitTcXVXc1dJZ2U2S1VrYW1lVnhaZXF3bFM4?=
 =?utf-8?B?bnVwOEVaQytCVWNQNnMwY1VzK1dQVkg0TGk2aWtOVWRaRWFWYTJIVE5BcGI3?=
 =?utf-8?B?VlBTckFhcHgxK0tIcFQ5T0pueEo4ZVVkaHF3dmdWRTZpY3RKa2VIRW1ud3hC?=
 =?utf-8?B?VC9UOUNNRTdGTDRkREhQSEU3dmhkK2xVVmU1bGduVEVJcHRIMjhFTVlBUjM1?=
 =?utf-8?B?eE9CRGN1TU5EdmVrd1M0SXIvc0JsNU56VHlMWENRWEsrb0FyeHdKWGVMUHlj?=
 =?utf-8?B?T1BFUmtYdTlMY095K0g5UU04cWpGMEczZjBhb1dVdlVBaXFYM3pBdmo0aXZE?=
 =?utf-8?B?V2FaYW9EejErU2JiQ2lUWnpLZDB6T3BQTlk4RWpnai9qcGpkUytUdUtRVjhr?=
 =?utf-8?B?ZkNMSGUySWFkM0Z6QS8wUmhTSzNZTXVQb0pVbmdhWno5SEpRRGoyZzM1bUoy?=
 =?utf-8?B?SkVHWFJIR1MySzVGVUo0L1FreE1CQkVyRXhuV2ZJS3RFQ3p3NWZvQUladjRV?=
 =?utf-8?B?aDRJUHZuWVEyU0xCNVA1Rk1GUmRMaWtoblEyUlRMSzRHUkttOXhIbzZWc2Rl?=
 =?utf-8?B?MjdQQzhVK0hoTlVuYm1HUFNDN3VHYUtFYldoOVUvSUxDaUJ0MXQ1bkd5V09D?=
 =?utf-8?B?Wk44Rjd0RHNnbS9HaTU1Ui9oVStra3k1bjFTcU5OaHR1Rm43Z01jQjIyWTYx?=
 =?utf-8?B?aGRRamwwSGkxaUhTcWowZDFLYjVQNEhnU1VlS3VyeUc5VVJ6SWsrSUtMcXhC?=
 =?utf-8?B?RWM3a0hPRDlSU2NWbXplSXFrR3gvWTdubkxxdFRWLzRNVzlMY09aUjhSaHBC?=
 =?utf-8?B?cjl5aDMrTHp2b2ZpSkhVRzg4aW9BaDJMWHMzK1p0QmxkWVprU0NFcVVRSXMv?=
 =?utf-8?B?dE9PbU02dVJVYzY1ejg0Y2o1cUx4REhxbkV6cERJMXlNRUVHQkVDMk9CZG5k?=
 =?utf-8?B?Y1lhUzd5TzFOeWlGM2htYmxFWHVaWjhSMitMTmp5YUJhRm5VV0dwb1M2TjFH?=
 =?utf-8?B?NmRFbTlnWVVVMVJMajRWR0FYay9PazVmcnlhQmdsNWZtaW5BaFZhRzd3TDls?=
 =?utf-8?B?WHdHRWhkckFnU2lSK2tWWHNDMlJ2OXQ5YTFEWmpNTnZEbVBaYWxlSWd3b1lD?=
 =?utf-8?B?eDN1NzZGQnVva2p3UnhDVGlYMkkxdFdibDF2dFRPdDVxYjFPdE1TNjhEaVVF?=
 =?utf-8?B?b29MTm0reC8rcERPOXNyNHcxZHNXTGlUMTBnVUY0UURwQWhjcDk0bmpsUVE0?=
 =?utf-8?B?Wm1zNUVmZjVpNDcxUm5xU3dEREtqaktvblNGcGhkVTlIdDhwY0dPT1NyeE4x?=
 =?utf-8?B?V094eUZDR2tBZDhFMTlQWit5L2xaL25PNEJjQnhqaGFDd0d2ZWxqcVprc0NE?=
 =?utf-8?B?MkM4dkJBN1NLblU0dE9Tc1pMUW1qK2NUenZBSGMvem1DY3VIQTgxMzY1QXJR?=
 =?utf-8?B?c3libWhyK3RJVk5tU2FXVzBJVDlSNUIyZjlycHFScXhGM2hBSXdnTUZzc3Qw?=
 =?utf-8?B?M0M3YmtwNURFL0dwaGVWSXJTUGsxQnR3cHhVZERyS1E2V3JiQkNPU0hsM05h?=
 =?utf-8?B?MVhUWjdMaUhGcHBJVHdzdkF1ckJtYm5PZFc1MkV1aE9uVnhmTzBvRWtpWG9j?=
 =?utf-8?B?bzhqWHo1VVRkblAyQjRPZWo0V1ppZGgvN1RnZDZTWUZHZ09CbmJmMkwwVTNq?=
 =?utf-8?B?WlFmTmwzdm9lcStoNkhaSEtXc1FWY3Q2MEhKNURzMXlML2srOS9EWEFWUjR5?=
 =?utf-8?B?L1RCNXFiT2FLVXVOaU1pWWVHc2FPUjhZM2R4dUdJTytMWjhTTHBwYm10RmQw?=
 =?utf-8?B?VVFyS2ZWSnh3U3JEMEs3K0JXNkxNbzFneTQyc3lDQ3VwMThZOFJEWWgySUtz?=
 =?utf-8?B?bEQzd3J4NFE5NlNVWFpmU05icmJjdXZnVjhNTjlhTkF0M3dqWWZtRTJxUTdJ?=
 =?utf-8?B?TjFDTTJNNEJoTWtNaFZ1eDdFWXBUcVM5UHlJTUh3WFNSU29ob09iRnlJNU1C?=
 =?utf-8?B?ZktXR211TCs4M3VBTXNOaDRna2VoNURLY21WbUdGSGNUdEFPU2MzdWVYTjVF?=
 =?utf-8?B?aDlvMUxGKzF3ZzBzb1U4eDdiWitRbzFpeS96VUdqT2puS2FncDY1aEpLdFdo?=
 =?utf-8?Q?ZXfayyO7JQqwKkUnrNh3h00oz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b51cb9-e9e4-4fed-3491-08dd182a19be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 08:18:45.9717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DyDTLEUNAK7GI7Es+Emr2jiPxtIZdvPX3UYdoSTWPZQa6JS9cIRMWCHYAM1EVv9VKEdtFuoUt4lQf+EJOYmUUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4227



On 12/6/2024 5:43 AM, Jason Gunthorpe wrote:
> Add an assertion to all the iteration points that don't obviously
> have the lock held already. These all take the locker higher in their
> call chains.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks for the patch.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

