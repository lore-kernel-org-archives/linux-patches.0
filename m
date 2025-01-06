Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5031DDC36;
	Mon,  6 Jan 2025 14:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736172316; cv=fail; b=nIxvoI9P6jodX6bIX/Q7XxByCrS+7BOYyJumkEQSWikfvLyBfLlP5OhaE2duNmSgsi2ZeIacnQYAlyK67semFM7tIInUT/UH8cttLFh0r+teLt+VS5BJtSWQJb3RFo/Gbwlkwcxcc2lLAzr7ddsL1l9q71OP5ws/BTFsSPfkFgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736172316; c=relaxed/simple;
	bh=6ip+dVX/AgeOAiFy2npLHaEHXZiAlqaoMYPPwQxEvM4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=In1k0RIEW8UDNyMjvUX3av58JzyrFR7HIHN+Nw8O6h7rV9Uvbv0WvMd/onBCHP4HKL8ffk5vuP+Tvd3qH8kk1D6lOqttJs+wrN2zx97bQN+QAvIE+SXDgxx7djnPh+LcFTS8dq+Sa07IcjWeG28g9Ww/4fXJ59Ap7Dtt4bnFOeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SZ9xnjj/; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SZ9xnjj/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5/96OHv7tQ8hjPoiHvBwIxEQcPgqv07yABDkdyJncYrMILMN1kKEzu6+8KLu2lHfec1m4XEK0OM3CzkKNrtmNMfDYf1kvMFUoz6P0lgqmswDSoBE3SKt6VsmoGs5CFfv+uyLJqRKPB9YBYPyIVnFu3uz/yzD6gxQd5TGwPe61QxGGU0F1dGqaHjrgzxb65jqr/iFieHeWGMuemNW9xOnhYgkg2Unp1PQT9Fua+tr2qZLISjoOD7uEWMTYL4vVpXELTw3kCUQFFiIfOXQe6twhXSHxMYxOjZNgiAKx03rDd6ovoxM+vQpVirQ40monoOWLXvhsEZlJ35s6vpV9STww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyViYIS5lXyJc6yu5dcABGi/T7yiqqO38Yhq8RBnG7o=;
 b=C6Q5iQgGl/Zvo6LPKpCRpnZLm5Ra4SCRu+Y5KCha0JGz+TGVSvMx/1Y1OhAid5SAXMlqd0j8dXEOEkQiV959Qpnw94HCu+lX9WrgBNxvkGbSf8oi5fpRQiFOP+Q8GKRX6JZ6YRlsJh7wUY4iZE/+m0c5QTlti1nDMv9PYmIGViz1rZT8CfzzLSFvrW9fO/DQJimUr54ndZUBDY+wkiZIBL260n65KLL6u6dJzv7C7or/74DZJRc53dJ/TLgo5YktPG064qQad1mLEHMQu4sRwn6K5TTsg1KPK8B17Em4NYPj3C7pas+yprqo79uiGqpftYqq7OODe2+X1TcPfRLIpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyViYIS5lXyJc6yu5dcABGi/T7yiqqO38Yhq8RBnG7o=;
 b=SZ9xnjj/6lXxs/Gl3RKmd5IKvzgmUkyrjncUk7QOEMgCuPOdwCgF9CMm5jybm3hW7gZP4sJ8wm7w23r9no9FzLwtfDDQRqTRaJr4qeSfOH4tuexlbQAjpV495cmbT7NJGPS2/kGzzqo9TNcK9Gh6NcOFhOynphzMWffqkKrdX40=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SA3PR12MB8047.namprd12.prod.outlook.com (2603:10b6:806:31b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Mon, 6 Jan 2025 14:05:07 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 14:05:07 +0000
Message-ID: <20f845ce-83f0-4765-b938-748e84803297@amd.com>
Date: Mon, 6 Jan 2025 19:34:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] iommu/amd: Remove domain_alloc()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
References: <2-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <2-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0033.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::8) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SA3PR12MB8047:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fd19d33-dc39-4770-500a-08dd2e5b1fe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUdPZ0tFQ1lMZ1NGbzlTQWdlT2lGTnlsc2o4d2ZTQjF4UUNZYmNQVFVXQ1Nz?=
 =?utf-8?B?RlVBeXV2QkpsWk1yRmNtWDJMdm9HTk90WmRDanU5d3hsM3dWeVgxaFFPM2s5?=
 =?utf-8?B?czRSMzlIRXRIUWI5MUcxbnBBOVd2b2grNXhVdnliU3lmU3NLa1Q3OWpzT0hM?=
 =?utf-8?B?Lzh4bnhjSUMrRVc2SEovTGJ2OTRXR2FmY3dnM3dWekNjeStKZS9xc0RQbEJM?=
 =?utf-8?B?d2JXMTl1d2xvbDVhOG94azhMalpxQTlyWVhCTy9rekhSWnFZTFJGc2pORlIr?=
 =?utf-8?B?UjUycUZLbXNNNVVZNG5nN09nOExjcWgzUFJUdXcvZUtZOVBoQXlBQjkyeWQ0?=
 =?utf-8?B?VEg1YW5VQW9VN1ZBY1djSkdsUWJGb1lSZm1Td3FkcEp2di9Ybjh1WWFJZmZJ?=
 =?utf-8?B?QnhGamZ4RWZ6SUtRYWJ0aEVHaWRPZnZyZ2ZFQmJYNEJxL0huanlwdFNmY3Jy?=
 =?utf-8?B?MGRyakp6UTZmd21iQnFhYWozWWl1R09jdVJvY3lRc2lib2J3WlZoWGNBbks3?=
 =?utf-8?B?WTBmREY2Z20zM3NScCtIaVNWSE1pL2ZNYm9GS0k4aXVGbzhVNjRKRlQxSXAw?=
 =?utf-8?B?Y3ZCcFFwdGd3Q21sNDhrL05tcFpTUXZraFBSbk44L2gvdHhQTjZBNStxOVcy?=
 =?utf-8?B?cGt0c3QvQTFIRFpZU3JsOFN6TzVtRUhaK1FEREo1TWZidTJDNDFuN3Z4SkVZ?=
 =?utf-8?B?QUpTQUIreUdUMkxac2F1R1pEZHJWWmM5bDNLd0VhajE4TmVkMXhOaU8wSUxt?=
 =?utf-8?B?cFYvN1Yyb3JZZFoveWdHd2JlVERFQlVFc0dOTjVudUNUMHg3MzB5VWFuT3No?=
 =?utf-8?B?bjhkeGN5NE5yT3pTUG5iWnpGZWFUajB1WUZ1Q01nTUxFSlhPYTRjQVdBYW5z?=
 =?utf-8?B?MlJoZmhYTnc0Tkh5b05naUhWT1lzRnByam5rU2lXU1d2c1JGWk05VThycU53?=
 =?utf-8?B?WWRYTE5GL1E3ckdmTEFrMUova1l4S2dnczNEMHhVZ1I5Z1VBL3ZNVFNYNSt2?=
 =?utf-8?B?Q2xiYWJyTjdmWVY0Ky94MjYwWi9qNGlaWFBIN3RrSEpqekdyUzgzVmRDNk1x?=
 =?utf-8?B?WkFRb01wWDFKMzNNWkttVVRteDdwMTR1aStVcGpLY1g3NTJML1krVk5RMjNx?=
 =?utf-8?B?UDFQNEZaRUpyai9Lb2J1U1JqbWlyU0VDU1hpSnRhTE4zZjRsZVcxWDMxV1lw?=
 =?utf-8?B?eGxwaGRmUTNHdHpSdGVFalpiMmtRWE8wdmhWMWFsUzkrUFBlQ1NlbkQ0QW45?=
 =?utf-8?B?SGllL3BmTS9IeXBkdjlYNEdzNDZMVFN2K0JJV1NJN3FmemVpNS8rY2JDTC8v?=
 =?utf-8?B?azl1VlNpUEUxUGRIUDVwZlM1NmRSYWtFYTVQT1JDMWRuemhyZldLeW5Jd2dD?=
 =?utf-8?B?VGZ0TnlNTEVzWTA1OFN0VEFRWUlhMDBxN3hJR1cwcnF0cGdpSG0yWTg0U3p1?=
 =?utf-8?B?WWl1ei9ydXZWUVptMWVudE5scDFBZGhRZ0QrTXM4THZsazFYOGlRZndOSjE3?=
 =?utf-8?B?TnF2cnhNZUg3d2R2eEUvQzhMekM2d3p1Wk5UUHZyRzVweENqVHpZa3p2b3c4?=
 =?utf-8?B?M0d0OUpUc281M0dRQVBWOC9JLzVQWllNRVhSc3V6NmkzNGJFdDh4L3dYOXZN?=
 =?utf-8?B?WVJGUW9uaEhITWIvcjBsd3ROTEk1ZEVIc3RWbSt5TjJXM0lNSVlydCthZ3d6?=
 =?utf-8?B?UW83NWt6WTl0WElpa1crdzRiMHZUZ3YzWnlQdHZjdTBlZm9OcmZvaEN4R2lY?=
 =?utf-8?B?ZWlHSVRyT2xBbk1Ua20xOGRWYUlldmhKSjYrZHBJMVBtNTRmTHZHZXpuQkQ3?=
 =?utf-8?B?NDBudHR0cEdKM3IvbHl4NWpnc1dXU2grOEZVeTdzNHpUMVFkVDFjWmRmZnhQ?=
 =?utf-8?Q?cJHfLy2jBWz9A?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUQyU01CRzRTNGxNWS9RYmowS2pJSXU3azExdFJQa1VldE8wZGRicDYreDFW?=
 =?utf-8?B?cFVYN0Rtb1NlZE9UdTlVNUFTYXlBVWJQa0d6SGVQazl0M3BPUVJTazVTcDRj?=
 =?utf-8?B?U21QZzhNWG12YUtnbGl3SklRQno2UUgvVmZ1MDVySWNDV0t3VG43b3ZrRHZQ?=
 =?utf-8?B?OWdrdGRVUlIvUWVvQmRpRS9Oa0FrM1IvQ2JUMEtRQTFLVVFId3Y3WFhmTEc0?=
 =?utf-8?B?ZTJwbzAyVzRhTjdUdlA4enR1TkxQRk1XeVc0bUdRSUR4cjRLOVRCNnE2eWpH?=
 =?utf-8?B?MWpSNUd3MHZCZGc4bVlCaEFlTld6NUJ3THA4WDcyLzgvbmNiaG5iWFFGaXMx?=
 =?utf-8?B?eVBVNTcrajduS1NFM1VtZHFGdUNGamFFcVNUTWt5RGsrUThGZ3NMeUt2Z3ZV?=
 =?utf-8?B?elp0bFBjUWFDdjFEamRhL2lmVWdkQWtWN2J4L3lEeUh5NExnRzVYdE1ZN1Zk?=
 =?utf-8?B?WTZ2M1graGZlY3RFak5ua290Szg1VVlxOG4vSFk4c0ttVXlxZjhyVDNyaTRF?=
 =?utf-8?B?emdyY2RRVEUvVmVCdVZHYnIwSlBZd1FZenIrcDZvYlE3QnZzRVY5K3V5N3dz?=
 =?utf-8?B?VDZ3c2FNNkcvdEdsZHh3MDZMelZMWDJ2ZXhNTklESkIvbGJISDJ2U3d5c0dO?=
 =?utf-8?B?VjhCbDhNVzNDV1FvWUgrMmdZTWIyTU05UTZWOTRHdjYvYUw0SkwzemxzR2lj?=
 =?utf-8?B?UGJVcEVkc1l1Y3B5ekM1VDYvUlRDY3dIaHBDaVlJaVVSZE1vVWF1MU8wSUcy?=
 =?utf-8?B?UnBiSHN6R1J0andpSkU0bWVCTUVYaWtHRjlUUFRxUCtpMUJaVUY5SngzQWNl?=
 =?utf-8?B?ZTE1RlRzcXFhTEpGY1k2NGcrN09iRGhJUjN2ZnNGS3A2Uko5UEcvUGVpNUtC?=
 =?utf-8?B?U0FTa0dFM04wUCtheitIcldRUlNvUzNxTTRPeDkxZWtNTzhlallhNHc0QktO?=
 =?utf-8?B?WWZQcE1rU1F5czhxUUJuc2syY2pUcjdaejN4R1RJQlZMZlo5M3RBZi9OSXoz?=
 =?utf-8?B?cTJ4Y1hnUlNlM3M4REdyOFRxTElDODkyRVRSeWhMaFRrSkE2K2k1WTREVk1P?=
 =?utf-8?B?c05zdkljVnd1NWRvWWgwa3I4b3piTWEwSGFTbkM2bDc0TW8zMjA4d3c1cm8z?=
 =?utf-8?B?SnJEbmU3Nm95UmNmUHlwVDlMU0Z1Mk5wVndORkJ4Y2JGN25EMTZVYlBsU1lM?=
 =?utf-8?B?OVhMTmR0RGZLSmFyZ01jKzFIK1BCL0g1WjM0bnBiczZ4azVIQ2dnUE42WVNt?=
 =?utf-8?B?WjVCQkRFdmk1U3dYRlo1aXE5VnRRRDc5aEVRVnlGOGhWZlVvOHNqV3JaS0pD?=
 =?utf-8?B?OHhrMUQ4ZGxnbjBkZHRYN1R3bDFUbmpNYm9RdUdwOENBVU14Z09mcDM2U3ND?=
 =?utf-8?B?WFVYdysxbWM2TzNiazliaXVpTjJ4dXpLS3JmU2JMWjB5ekdjUFN6ZndWTFVu?=
 =?utf-8?B?SXpMZmxZNVhuT0o2VG5INGNoaUVsUGZzTmJkZHNoM1FzS3Ric2FUMUlWNkZq?=
 =?utf-8?B?SGVoRUcvT0lsN2tvd0RkMTJtQkhJc0g0Z2tOWUJJdGxsdjBUMnlxRmNYbE1S?=
 =?utf-8?B?TUM5QkpkOVVPWUllU0c4RWNycmlvOTJWOXF1NzZ0Z2RXaTh6cUNzUDQ1MXVX?=
 =?utf-8?B?WXZCVXNBL3FYRURkdDlKUGY3TkJ3Sys5VzRiQTlYYUJxaUVIUlgxeS8vazBB?=
 =?utf-8?B?K1VrUnRNNkYrRUdVVGRoVzlObzN5cUxpVHlKRTFGeUpQeWdNd3dmMjYxakor?=
 =?utf-8?B?dXd2LzZERWluL0ZUcDhsU2U5bFZOYUJ2ZmlCYkw4NzFTbGpHc01tem5XYW1X?=
 =?utf-8?B?aGV6eG45cUEyKzJMRjF6M09iMzBESUQvR1Z3Y3lBWjduM2c5R1R4bmFnM29p?=
 =?utf-8?B?OFJZL04vdlErKzB6Vk5WcE9MWlFqUzRUMEdCYWNjWlp3cEEydzNCaFZUL0RE?=
 =?utf-8?B?V2pjVGtvVTkrbE1BUFdoU1BrbFVPSStoRUhRYTRVdXJ5cUUya1dLQWtvU1R1?=
 =?utf-8?B?Q2hEbEdGSS9wNno2aXhBNVpYcjBXUlFpclJwd3lMc2c3Zi9ISnkxeGM5dS9m?=
 =?utf-8?B?ZXdaKzVKMTYvSkMxUW5OeHhpallrQzAzb3EzSjFoc2hTcGV4VDR5cmZ1cHc0?=
 =?utf-8?Q?UBK0Mont6BaVa0FeAvOEo/NrO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd19d33-dc39-4770-500a-08dd2e5b1fe7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 14:05:07.2507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/lwRmNGZFpz6y8cVZfc423Btqk1gJinZ+Nf3jUELOEPmRHbqZf75WVgZ7yZDNtyHVoz9D7pVICME9p7RbxLMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8047



On 12/6/2024 5:53 AM, Jason Gunthorpe wrote:
> IOMMU drivers should not be sensitive to the domain type, a paging domain
> should be created based only on the flags passed in, the same for all
> callers.
> 
> AMD was using the domain_alloc() path to force VFIO into a v1 domain type,
> because v1 gives higher performance. However now that
> IOMMU_HWPT_ALLOC_PASID is present, and a NULL device is not possible,
> domain_alloc_paging_flags() will do the right thing for VFIO.
> 
> When invoked from VFIO flags will be 0 and the amd_iommu_pgtable type of
> domain will be selected. This is v1 by default unless the kernel command
> line has overridden it to v2.
> 
> If the admin is forcing v2 assume they know what they are doing so force
> it everywhere, including for VFIO.

Agree. W/ global identity support and domain_alloc_paging_flags() in place, we
don't need domain_alloc() ops.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant


