Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0D83FD1;
	Tue, 29 Apr 2025 06:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745906626; cv=fail; b=bA8X/VkBxaa8TgHJEHQUMRdkynj0RgSNgfXnWkqLOsb3u/Cqx4bf62InsNrXY3zqCM1LnmRKna8Z6mQHy1Y8FGIvpVqjdvC6e4T7It8VslVGstYNH/3r2KfJmutGpf1sQGAAJo2U08mzxLsXIj5hWn4yFbMw+GN7CHzLWOHFx2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745906626; c=relaxed/simple;
	bh=Pez/gol1BpNckGz1Nus65eFQvBdsWNzZGCuU6rVhbCY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QXxhNH+U1+bdAQSEQJKw78OMcQeplR/LYpIGWLj9i9qwfwz5TUXCOOl+QRKE0HI+dKCa4GIhkymgjLIzHf/updMNlLBSWh6bZspcLvPFCoQreDMgwvgDz2PjOJ9MJIAdjsmZYTj7hGATF6OjeCHDtx0NIDYrSK3/ZXJjmsAa4C4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YZdAmato; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YZdAmato"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n2JfmGHxxUY1IJqUkV51UVHVKqF15l15GnHLlmV4UD24RWjVC4uKW+KyvI47mC9lKgUtABFK8l5wZTP6J3J7ZxD/DCpeB5gvdTYeOUBQNPb31V61zt2NTc1UsBv2Dn4A+FSbJ5YDGdayjZqVwGV+x6AxSg5/itBqEONA7Vv8+Y4AY7X9YofO1x1E3j5QeQL+u+alvjiC5uiUgxjeEBHQSc6nTNnIq233bFPPX1vU/j+3sSsw7kYjVd2LdIPYd/y+/9NtPQWbbGRDR+8p6kXNR40h95SIT78NQgFw1B6Hb9gWUGbvSpWbeqStn4RGoB5tyFYgX8W4x9ZP5C8xznf6cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrbHkz/I6Gz8eEKfdjqcGcNrMZjVQtGzfdxoAZvA4Xc=;
 b=jOe90mYteuewcUasQhJpIUZOT0U/Z+N+qy308GzymQjLyN5CQ9gLk84Ar0Plw3ogXDfn1fqMoYEERZWNX5Rt9P5IGxz/e8S5E50/+4//qi61vQ42WO5TfIa5AX/6KIGwVcCQAl8c9cBQvK4hcQNtTMWzq1YcZSH7YwUg8vMl2Lb8jkPfc6Iqn8mQ8r9VSOftKhdcYjx4IHHPCrhEJVTG5aukb9KgQD5t/TLyWaWLejiWgmJmsvAQafCE4JoaMzKqQIpjJjWuREkrF++2pBXquV1pR+/ikpZXZ+zpIkr20RFSOWBRq35mPGKXgE9x7scPdVwrR74GXwOsOcVf4tEU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrbHkz/I6Gz8eEKfdjqcGcNrMZjVQtGzfdxoAZvA4Xc=;
 b=YZdAmato1mhTxpBfqG9Ma5DBuZbpUmE50Z5dA+5FVgrebQURbFhY3OdMzyq4xk1YQwrcUrzgUzIGAM8S+cahdAY62RYdfi4RdTxoerFYb9Twa/4+IoUdMnnenXaLhs5DDZLRg/kFe8ZcIe90zjoCVa3L6K8jRcXkLL6eX5bNxYQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS7PR12MB8418.namprd12.prod.outlook.com (2603:10b6:8:e9::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.31; Tue, 29 Apr 2025 06:03:41 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 06:03:41 +0000
Message-ID: <fe9d5895-006e-4d88-9861-67f77abe0785@amd.com>
Date: Tue, 29 Apr 2025 11:33:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] iommu/amd: Fix geometry.aperture_end for V2 tables
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Joerg Roedel <jroedel@suse.de>, Jerry Snitselaar <jsnitsel@redhat.com>,
 patches@lists.linux.dev,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com>
 <d5a653df-9b43-4f13-8b1b-c3268c356592@amd.com>
 <20250424140613.GR1648741@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20250424140613.GR1648741@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26e::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS7PR12MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: 3df131dc-0842-48e2-7d2f-08dd86e39765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWJsQUYxdVpZYTQyU284dllqYTZjUUcwSVlVMHFEYVFSR2llTkd3QzJZMFpH?=
 =?utf-8?B?OFlpSW9zTzNwTW1zUDl0L3h2OTFaNHBwV3VlVFNyNi95eHZidTZCOEJscTl2?=
 =?utf-8?B?bUhOT01NWGV0QjVEdXg4Wlh3YTNobEpMRStUNHhjbWhURzRSV0VDa1JOblpj?=
 =?utf-8?B?NVQ3bXB1S3ZWQUl6RmZMSm9GMUtpTmJQVmVPZTR5aFI3YVlVckR1TmlURnJn?=
 =?utf-8?B?bkNwRGIvVUNqTDNKYithYjZvVi8xdC9vQzgzMVpLaTBhWFB5T1JYQU9nWmhI?=
 =?utf-8?B?U1AxWkRwOVB3S0pSU0krNUVUK1BrNzlxazdad3Y1Qk41ZVlRQmFkKzdvT2JS?=
 =?utf-8?B?K2dZaXhrK3ZnRDVCVFI2dUFPMzBnRmllMHU5MjEvM0pINkNCTnNLSkFZZW5J?=
 =?utf-8?B?TDkwQ3RsSm1YS1FzZ1l3N3RiMEVGdXVubXQ1ckUySE9RdzN2SXBxL1doWnBh?=
 =?utf-8?B?ekRKYjZrbXd4TmUyZjZaY0FXZlBrUy9waVBsbndhc20wMWxwYjk0elM0bFJE?=
 =?utf-8?B?S0YwZWJOWTFHWHFBV2Y2TC9qRDlBam5jdWZ5KzFuVDhsM2ZydVhlZmVDTEx1?=
 =?utf-8?B?bWptY1UzeXg1d1pOSXI4U2RRcGF6d1hOSm13cWxtTmRsT3hlMkFCUlVLV0tE?=
 =?utf-8?B?cG4rTjhwQ010a0I0Rk5UQ2lJamg3NmZ1NTAxWFNzWDVtVVlyaU5nUUhldm5t?=
 =?utf-8?B?MXBmaXlESElHSGlSY1ZvRGY0U1locXhlVGRMczVTKzdEVkYrYTBMMGkvVTRB?=
 =?utf-8?B?VDFHY2xwdE9WbEZ5U2U4NFhUYWZLQ3Z4dk5BakNJZk9JTy85eXozcHZzMXRS?=
 =?utf-8?B?di9yTlRFaHg1RVdiVmdIZVNWZHVabE91UURwTkltS2RiZUl0dm9wLzNKQTBy?=
 =?utf-8?B?VUpjZklxT0FYR1dDQ1NIOXhpc0pmckZ2b2J1algxRFVRYnJ6WkJPcEsrdEdt?=
 =?utf-8?B?OWQyalBCNlZmclkyTVM2KzZicCtMZE9WUUgvYm42OGlhS0xMWG8zdDU2VWg3?=
 =?utf-8?B?cTZzU0IvVTJhMDdVUnZWbHpZV2YrU0VQcE52blZJc1lkVXlLeW9jZE5BdU55?=
 =?utf-8?B?ZGZOMllpREdlS0RiMCtMMmlaR3RzTjBFZFZiemNRbURTUlJ0TTNzRk9uZ2lz?=
 =?utf-8?B?RUxGUytscDFZRm9rMDFDZXpVNThUYVFBS3kySUNsMVFpNlRJUXJFakJJWmRr?=
 =?utf-8?B?UVhYeVRQZ0J1Njl3b3F1QjVIL0VnOUVURks3aVZ4M2NzdmkvcHlnTG11L1pZ?=
 =?utf-8?B?SUJzc21wTktQc3I5bVVBTWNQd2FVZFc5WjA0RXc1Wm1qL2UwUXhWMUpVNGs3?=
 =?utf-8?B?MkFENUVlVG9qZnFyZzZVNmk4M0dWd0RxYTlMNjZxZjdQMUpTeHFtMmx5V3JT?=
 =?utf-8?B?SlhCR2FGYll5UHpzSDVIOVV6UkMxMjlPWWF4SGd5b0JMVDNXRDR5WkQ0ZDFW?=
 =?utf-8?B?VHVyYW9UTzNDTkE0RjZ3Z1JQSlRNUFkyaG1zZFYrNDJGeXdOcVAra0tJOGlR?=
 =?utf-8?B?bkw2bWpmVmRvZ3ByMWUwU3ppeDByVzFMLzBFdmxweGtwVWpmNDZvR0tBaE1l?=
 =?utf-8?B?ZU1TcjNaZkpUQU5mTEJFMFljb0t4RFhZODJuSVQ1RGRFM0JUWFRtcHJIQjdU?=
 =?utf-8?B?UldJbzZtalQyVXgyNGJTdmY2WE53ZmdkOGl2NDB2NUx4b3dlRDJGZGYzTjRG?=
 =?utf-8?B?OFZqNC9kQVVtaU1LUmtIdHBaT3o2cWFhT2pTOGl3OERuNmY4UVNaQWtxaU5N?=
 =?utf-8?B?eUdYYXk1MVVqQjhIVHlveFdDM0tSWHltRzRXcU5STXdWYURyQ0pFdkpHeDhD?=
 =?utf-8?B?VjFyN1ZrWHhsb0tGNjhnQnNvNk8wL2R1Q2RSTXp3S1ROUmNKa1dVQUhVek0v?=
 =?utf-8?B?VXR3KzZpNlhmUVFwU1lCZ1doaDM2aVNNY1dlUTkzZlkvMEZJQnpuTkRCTXNZ?=
 =?utf-8?Q?I/xBNEy8DNA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmxSSFZKVWEzU2swYS8rYWRwRGUwWTRwMHlqMXcybHU0ZFhxOS94a05nRDFM?=
 =?utf-8?B?cGY2REhFeHIvdDdTc1YrTWtRSDVTUnJzTGxxbk9hZ2x3alZkMlpGemM4eXdq?=
 =?utf-8?B?alN4bDZtQWRwbGdsQ2k5RU5VMUdpWWJaa0xNNGZSRkNnTUpyRUw1VExGL1Yr?=
 =?utf-8?B?UWFHdktDSUR4NVgyZjlFZlpab0MxZllxZDhaVVl6U3NSODYzU2l3WU04YjBu?=
 =?utf-8?B?azBvcU5EUHJNVnI1UzFnVjh2Y2tUSTJVS0RrWEF1VGU3Z2tZRTZQa0UwMmlB?=
 =?utf-8?B?WUJsa3BZNktaUjdpemxVZkRJdTROcWJabUVoT1BsUi81MVFxbXpaZ1RNT0Y5?=
 =?utf-8?B?dnM2cGdWbElwMm5tekdVUy80OExPYTJYZU5kQXN6cjZiR0N6aVBQS1pHc1h5?=
 =?utf-8?B?NzUveVl4RW0ycGQxai9TUHpYK1BxS1lPWEpqV0hsVXhlLy80RFFZU1YydjVN?=
 =?utf-8?B?VHkrNmJVcDZ1azBJTEVKSk5ralBsMXp3cnhzVDIzZkVpNlU1T0IxVVVjV3I5?=
 =?utf-8?B?ZlR5SE9PNk5qdWVldEJpQitKZU5ETVlPeTljWnBRK2JRbWJwbENkbFpUT0d2?=
 =?utf-8?B?OXd4TEVGWUp3dmgyc3JvZG5nV2E5Yk9wZnRFSkxXWU1SdkNDWmc5YVY4blhL?=
 =?utf-8?B?N0Y1U3JWelU4MEFQd1JhSkNPcXk0OG5iVFhhRVhwTzNrZlp6MWYxV2hQZ3hB?=
 =?utf-8?B?VDlId1hFWTFrMlFQQk5KRVU2NmdNOWpweUZNMVd2cHFKUVEybTJWQ0FYcEJ5?=
 =?utf-8?B?djJPQUdyMmN2R3QxY3pKclB2cG1LNFRZSi9iaXYxbzZ0SEo4bEtYNlhDMFM1?=
 =?utf-8?B?L05VZHBIYW5BTmhreGFpTXNlN3pPOE9FdHZxNHNEeGVRSjNqNUtCVlhmdHpD?=
 =?utf-8?B?MEVyWGozRS9vaHhqRFBkVkFBK0xGRUZ2dG04SjNhTXZUR1RNcTVpZXdpZlo2?=
 =?utf-8?B?TjNaN3JMaUprOFdtMEt2M2ZLajQxR0hRVXhjby9iaHZNeEk3QlNUZVU3ZGpW?=
 =?utf-8?B?SmxmUFI4SWJDSThUdnBCWXdtVjhMRkRnanVVUEhkRExiR1lyUDZ2ZVh0YlRo?=
 =?utf-8?B?RzVoYUE2dlFRd1lDajk4VVFnVlFQL3pFUUtzWXc2emsySlAyN3BDcFcwWVBt?=
 =?utf-8?B?YzB2TXBqSnllcXpwUElSOTIvblhpbFpvelVrNVBQdkJUekVVS0k0YjFyeGxi?=
 =?utf-8?B?S3N1R0llQmZxZ25qQUU4RWV5a284RGc4ZG4ycVFHTWxuTVcvOHlpTnMyL2g2?=
 =?utf-8?B?LzFXK0duNERCTHYzL3BiSGV2bGEvWkUra2grczVJNDRwVnQzVU5RQmVTUGlv?=
 =?utf-8?B?Mnc3Vk5ST0R1QW1tTWlCamxYUDl6eTJBdE9BN1pLR3VOUU16Y0RWaGNyS29a?=
 =?utf-8?B?cUZ2QlZhdWxqYXFzRE53MEo5Y2kvZi9CMGIyOFJXTkxmRTNvYnBRdStuSHJi?=
 =?utf-8?B?azAwOEZvZy9pMVNWSVpDREZzQ09ndUh1d3U0bHdhKzlkRWpXUmxrWG41aGxi?=
 =?utf-8?B?alM3TFh0aVZjZ2JzREwzWEtidE5oOHdDSlRBZm8zR0FxU1ZZWnBPVUZ2TWVo?=
 =?utf-8?B?bTFEL1p1VFNVMm1QYmdTekIxeWY4clNlUnhGSW1WVURsM3hKUldjMjBuUytJ?=
 =?utf-8?B?MTNhaVVDZ1F6OXg3UU1qeTgvbWhPdGh0WU1UTkt6b25LSUZPMmp3Z1M5dUtH?=
 =?utf-8?B?Qi8vbUpjSzVHZnJrTVJtcGx2THdRNmNwRWxuNGt5UTR1ZXJqMEFEZm5Vd0tx?=
 =?utf-8?B?QjExSDBSWmN1TDd4NE01RUlPK2hVY0kzZ1Mrbk0wc0FScnJVWlEySGF2dlNN?=
 =?utf-8?B?TlpBMTA4UnBzNmJBTFZlUTZsNGNNSjl3cDduUE5UWXhhVU9XTXIwVGJNTGFk?=
 =?utf-8?B?Rm1udVhNYlRyandlQU9VQ3kycnMrTkN0TGc5b3FLcXEvRUp4aVh1Z25qL29Q?=
 =?utf-8?B?cjBoUi93UVhBWHltd0tHemR3b3dhUXZiUmJmdnBQM1lmMXJkdTRzWWEyTGw0?=
 =?utf-8?B?RzVxNGpWcFdZNmpCeGQ1RUZvbU1uNElyTW1rblFCV1lUVGVoSmUzTFFEd3hk?=
 =?utf-8?B?NnlISWxhdnptZ3FkeGVOWWIvMEZ3UTZjZGdmSWt4Z0hXeXhzb3dZTlVuc1px?=
 =?utf-8?Q?YLthSs9Gh6YQK5XBUYM0q3UlX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df131dc-0842-48e2-7d2f-08dd86e39765
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:03:41.5609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uA8sGCEA/UNNDy2++AdH6OTG+Na5kthgbsaGJLXPhUmu6/PUnagIePJtLDuA1oFxs4/uxBnjaNWZt2aedHkWyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8418

Hi,


On 4/24/2025 7:36 PM, Jason Gunthorpe wrote:
> On Thu, Apr 24, 2025 at 01:26:21PM +0530, Vasant Hegde wrote:
>> Hi Jason,
>>
>> On 4/17/2025 9:51 PM, Jason Gunthorpe wrote:
>>> The AMD IOMMU documentation seems pretty clear that the V2 table follows
>>> the normal CPU expectation of sign extension. This is shown in
>>>
>>>   Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation
>>>
>>> Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
>>> would have three regions in the page table: lower, non-canonical, upper.
>>>
>>> The manual describes that the V1 table does not sign extend in section
>>> 2.2.4 Sharing AMD64 Processor and IOMMU Page Tables GPA-to-SPA
>>>
>>> The iommu domain geometry does not directly support sign extended page
>>> tables. The driver should report only one of the lower/upper spaces. Solve
>>> this by removing the top VA bit from the geometry to use only the lower
>>> space.
>>>
>>> Adjust dma_max_address() to do this. It now returns:
>>>
>>> 5 Level:
>>>   Before 0x1ffffffffffffff
>>>   After  0x0ffffffffffffff
>>> 4 Level:
>>>   Before 0xffffffffffff
>>>   After  0x7fffffffffff
>>>
>>> Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> ---
>>>  drivers/iommu/amd/iommu.c | 10 ++++++++--
>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> AMD folks: I'm just reading the documentation, it would be good to confirm
>>> this understanding. I'm a bit surprised nobody hit this, but given the domain
>>> aperture was wildly wrong up till 2023 maybe it never gets exercised
>>> carefully.
>>
>> We have tested this with 4 and 5 level w/ some bench marks as well as w/
>> forcedac=1. It works fine. My understanding is IOMMU uses bit 56/47 as well for
>> address translation.
> 
> Yes, it should use bit 56 for address translation, that is part of the
> page table architecture.
> 
> The question is what happen if a device uses IOVA 0x0100000000000000
> with the iommu. This is a non-canonical address, so I think
> architecturally on x86 it should be rejected. I would not be surprised
> if some HW treats it the same as 0xFF00000000000000 - though that
> would be dangerous.
> 
> There is a significant correctness issue here with ATS, the IOMMU
> *must not* allow address aliases to exist, so if it responds to ATS
> queries at both 0x0100000000000000 and 0xFF00000000000000 with the
> same PTE then it is security broken. The device ATC is only flushed
> based on the canonical IOVA, so any aliases can remain in the ATC and
> trigger UAF issues. This can possibly be triggered by userspace when
> using VFIO :\
> 
> So the question is not about if bit 56/47 is used, but if the IOMMU hw
> is validating the sign extension. Assuming it is validating then we
> must not tell the iommu core code to use
>  0x0100000000000000 -> 0x01FFFFFFFFFFFFFF
> as IOVA since it is not legal IOVA. This is why the bit width is
> reduced by one when computing the aperture.

Got it . I am checking with HW architects on this scenario. Will let you the
behavior soon.

-Vasant


> 
> Given the security sensistivity with ATS the sign validation behavior
> should be understood because I do plan to come with a patch to enable
> the high address space for iommufd and if some AMD implementations
> need to block that we should know :)
> 
> Thanks,
> Jason

