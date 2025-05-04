Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03A9849C
	for <patches@lists.linux.dev>; Sun,  4 May 2025 13:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746366452; cv=fail; b=IufsLJAyzfpu3Y0l3JSot26UwszTkMgn4BV3EAYyGP572hF5kv3ucwo3/rkyzvZLYJvmeC9p0pMZjJJFipoqSvyXnkjS4hoYVhTL3+pwwF3Sc1tzIaxJlhUHWUfq1Jafb3vs7WKizSdm6jcTGskYh5YVBZA2y+J+E8rjiSM/+9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746366452; c=relaxed/simple;
	bh=ocoVqmuov9YSzidHIeY/toi47a369YCqaFgYD0WIsBE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ixuo7wkxFSYwCGqntWi0lfNj5+TRdQWV5mY+k0hViyemub3qvy696pztsGpIITjbQUl5/6HK6Fh+CH7fGxDB6c3mkW3nUNKgG5F2ZtQYNcxTLqW7LFebIe0261hb5ZhavOnuOHKB3bppCrTfJqEj2KZoC5qC3DrX3RswCpMKPUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ercvLvyO; arc=fail smtp.client-ip=40.107.101.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ercvLvyO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FHZ1GaxQXBl1sjAg5JBAPKHA9We1jhgv2d6Pbi8iteYWm5Q8l5jDcnh883D2UmhUIF8dcDLERDe7F9p6gxJoLfTIEp/JQbgfwPvLQb2ZcxlcIpkxQCefn52t/fCv9BeTQxvIHErt42hzOqERol+o75A8Xg0QHld/mWuLnHuqSRvRJ7mg7MeROau6ltQSv8onohF0vUXs6l7iBGUeYnJkPz1hWVN2rmcvBluyXAHljLqt/oOcBL9vFEjXc0KGA2vmfR2Ayto6eE5KDxizbKzFA1Cyp9m5TCvbY4wAASO34PP+YRxcblKnBqqy0PtdkP1fvoJq6uz2cTkghZKBvA86MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8llK8V1+iTmecKBnN2qt8iKmaZIS5945+hTjaM8fIFc=;
 b=QjxOcZTXsUH7xzHvh1citphHjXu5A0BDaIEUmLw8g2vhNOcx55gb85s1O1tV4mtCS9cQ4Gwcx64JzyMbtokwSjxcJEY1P6bGXuM+QAUPjE609ewKjb8tas99ptzyrVwAIc0H4eztwvdFdGyDX7tSXWaZ2NkdUdSuiTmd3B9gkd9vytKovJhDOGReaKCvB64ZrbJn2giHdUb6cfOPAqWJcgqFEI9czCAeP+kYdp1oPiNNHKiaYFICPjPY6uTj7YLpszs4GNrfPxWhIltH5KVm/tXSJqmrh1e495+zQu2cqbRJ5uGKfqHMeMuV9e308fjjRz3jn1VRfbneK7mYThi6yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8llK8V1+iTmecKBnN2qt8iKmaZIS5945+hTjaM8fIFc=;
 b=ercvLvyOEdk1NQ+XSVWLZNskNrw/4ctusi0PuLTTD0b5chgJQGV4snLkcJjU4ZMBbPSjAxjxAzO4PBQzby6f2yZA6Bzs5+AQ5S74a62R3+Bh1u+BPJLDvJ3774Djp2eTeItXYPhLG4TsTN5/1gHfKYU0YZzfU3q9mmPEF3Ej2/vjur9IA4w8QZ26T38gkrxxgf3HVAjDMft0oul9HPth5VUct7FOF97nb+9Y1x43/QSOJHu+FEBa3h2WmiMgkb39EhZpYilp6/PuNlNaXAATeIrLQtvw/xqbCWjSG8xIaTrJAgmk3cskXrfCE1F7gcYBsxbWqNiFaTFy9VBw5GNC4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com (2603:10b6:a03:453::9)
 by IA1PR12MB7664.namprd12.prod.outlook.com (2603:10b6:208:423::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Sun, 4 May
 2025 13:47:26 +0000
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b]) by SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b%4]) with mapi id 15.20.8699.026; Sun, 4 May 2025
 13:47:25 +0000
Message-ID: <744b4d9b-24f3-487c-805f-5aa02eaa093b@nvidia.com>
Date: Sun, 4 May 2025 16:47:20 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 092/311] ublk: call ublk_dispatch_req() for handling
 UBLK_U_IO_NEED_GET_DATA
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 Sasha Levin <sashal@kernel.org>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161124.815951989@linuxfoundation.org>
 <830759ad-243a-4fd5-9fa1-a106e6e6bb0d@nvidia.com>
 <2025050455-reconvene-denial-e291@gregkh>
Content-Language: en-US
From: Jared Holzman <jholzman@nvidia.com>
Organization: NVIDIA
In-Reply-To: <2025050455-reconvene-denial-e291@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI0P293CA0005.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::19) To SJ1PR12MB6363.namprd12.prod.outlook.com
 (2603:10b6:a03:453::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6363:EE_|IA1PR12MB7664:EE_
X-MS-Office365-Filtering-Correlation-Id: 820e78ff-562f-41cd-a964-08dd8b1233ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NGgyc002VHlNYzZHdjZmQnpkU2V5RlZoTWN1ZndRK0l1elY4K1N2U3dwRE9w?=
 =?utf-8?B?VGJrZ0dMNkhDWnlFQmxsdHNrcUl3YzFnWEZsYTh4MlZPREdab0RnTFRhV3Qx?=
 =?utf-8?B?Mm9iajdsTlQreGJXNUlCM0k1OW91VXRMam5XVWwvc0tDMFRLTkFIMUpQK0lj?=
 =?utf-8?B?RnNtN2x5cjZOTU9mbGJLbVlTeGhnWkNUOHkxRExjbjlLYzRkZlZRcEtuTGZE?=
 =?utf-8?B?RmZOWUtYSGpvODBnNGR5eTQ2VzgwcEhiTG5kQjR1TnFKR0lrOW5JRFJhT1VZ?=
 =?utf-8?B?WFliT1RCWmZFbjdQR0NYa3Z6SU1aYjFiT2RLc0lyb2I3OXdnZUtiV2NFOGRQ?=
 =?utf-8?B?REtndXBzMVUrWXF5ZHlPeEg5RUNBVnh6UGZ1M0xLamdyNXg2MkxFUm56TG1s?=
 =?utf-8?B?MFRuSnVIODlLOHFvWjdoZUExaGlreTc4Y0ZWRnJmUU5EYlE4cEJHZkFNbUlW?=
 =?utf-8?B?YjlHdTU1bXNSRTJiLytPc2k2QlZ6T2ZmWldmbU1ueHNnMVk0aWVzM1FCdkNH?=
 =?utf-8?B?cXArRjV1MDFOOUExZHU2Y2dyVGFzUk9uWXhpb3JFODVGakhxNm1OMUJGSzY5?=
 =?utf-8?B?VnBHTmRQVWhNWUFJdUt5VFB2cGttdU8razdodzZJOXZycjJ0RHZVOXNjckcx?=
 =?utf-8?B?ZTdLTE1tbktqSzZQaFlWSDV3RXhCbkdCM1N2Wm8xWTNvT2NzNGV2MmNaREl5?=
 =?utf-8?B?TzhxNUZuajBwQW8zRWxNMUcxY0dDZ3RwY0JKcksxMUFpQzVLSndrbEdZSjho?=
 =?utf-8?B?NTJRZ0JkN3hIQkxtZXBHdWlBZGpyK1JlMmI2ZmhlVDZ6SmFDa0RXem5CTHRE?=
 =?utf-8?B?ZlUranpTby9mWGx0SGI2QmFLWmNSc2VDT0tJS1NSQ2U4R2hxS0tZRUY4a3lC?=
 =?utf-8?B?cGhjZE84MXJEVWVmVVZyc1pmVjQ0SnZ6M1o0dUd1OFYreHNsbUVDMWh0OVJE?=
 =?utf-8?B?eTY1WkVwYXZBcTFlRHpLZ2YzOUM5c0NTdWdvSk1CcktmMWxKZG5IM0dzNXVp?=
 =?utf-8?B?alY0citxanpSNmQ2WHZpWHhSSHRpaUcyS3I1dkoyMXNKYlNSOERRUE1kaVY5?=
 =?utf-8?B?aGVJVngyNENvZVZyUXhnWTBxa3ZraVBlRzA0Ri9KUDk5MEE5aHRHNGk0YlBP?=
 =?utf-8?B?K1BnMTVRM3J1SWlkbk1ZQi8wN2xyNndaVkkvaVFuV1BIdS9mdnN0MDBaZ2x5?=
 =?utf-8?B?TTQ1UjJEU01IeGtEWGhkTGtnN2p5U054WVlwS29EQ1g1VXc0TDliNzVZOEM3?=
 =?utf-8?B?Nkg4U2FRZ1F2dkUxazUySWkyVFAwR2lZVWFYRWxsVkJEQ3Z2c2hEcjlDd3By?=
 =?utf-8?B?Tis0UUN6Qm1UT2hnRzNlTWZxUUVWbjMwTXgwWkRKSEFKQ21kaWpyQmtDc21w?=
 =?utf-8?B?SThKdm9JcG9UekRDYkZmYmc1cG9HemFZU25wZVltVUQwd0lYZ0QxTmdyajhi?=
 =?utf-8?B?MnB2dVVOUGh4bVhiYXYvQUFEZmxNSGZEeW9yL3NlUlByallsNENoQ0lXOGRI?=
 =?utf-8?B?RVBxYUlBeGxXVjVRRExxVEZ0YTNBbDRXYzBqcXdMNkNkUG84eVl4ejlHYWpX?=
 =?utf-8?B?Y1pPZG9POXhCTmFsWjFpK2VtK25KSG93UVNVMmxMTUhtQ2pBWDZpRkNqeW5I?=
 =?utf-8?B?OVV0L2kzclFrQTRnV2YreVlpTEJYekZrelF3UGlLck41emt6WCtNMnVNMmJD?=
 =?utf-8?B?bE9wbUN0S3IzUUc2b01jSmNEUHB3dHR5cWpadlkzekF4ekZyejV2M0dkUjhn?=
 =?utf-8?B?K0pVVnBrUkZxZ1JBWFNUY2tWVEtBYUZYTlcySmI0Qmg0M1kwd3Z6Z2lLMFpY?=
 =?utf-8?B?cGN1R1BZYlo2d2ljZ3MwRlVFRzF6Q1RjMnQ2OVp6OEFhaG5EOC8vdnVvNmtR?=
 =?utf-8?B?V01nZGdrU2wxTGNtL1hkU2UwT2IrRjdtZ2RFNTZYQ3FaQVBlZlFqdnptcFJ3?=
 =?utf-8?Q?WfKg1ej0YtU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6363.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rm1DVys2aERWc25RYm9hK0Nud0ZYRFA2SDRFRk9KWmJWR1RONjY0QndTMS9a?=
 =?utf-8?B?RE5WTzVZaGxyWTRIVEMvcXlYTmhScGJvaDhxdjBWUTh4N1lZMU4ySU80RlJ0?=
 =?utf-8?B?VGtTVlVIWnJPQ1hBMmVVRXMrbnFxRVBGa0pmbXdVUzNJOUIxWE1HQ2pwalE5?=
 =?utf-8?B?YVlENkl5VFVKVzIvVTNtUkF4RWNhcmdBMzd0QXRJNEVkSDVhdmNPaTBqN0Nj?=
 =?utf-8?B?ZnBQeWxhY1VWR1l6VmNIRnF6cGI4dWU2Si9tdzB1OHZaZWlqY2ZETmlweHNm?=
 =?utf-8?B?RXNlb3hZM0E1ZXNTeVhhTElvWUxHczZmM1JNclBzUjZ5MkVUNUVIcURMTjI0?=
 =?utf-8?B?RFIwTlhneFhJUUtHODZCbFVaU0V2UFdIdXNyWXRBaENibHFsMWs2QW5IVFFX?=
 =?utf-8?B?M2ZJZ1QzNkI5M1JoVGlpcXdmbndKdUVZTjN6bkpETXhVTWIxM2NYQjhrdGRk?=
 =?utf-8?B?c1FjdnFyK1g3SlM5Smdka2duWFVYeWVRWTR4UnRiajMrOFBQbmFPL3hHeXlX?=
 =?utf-8?B?clBCekpkaFByL2t6VHJGNXBFc1dRMFVrTjBmTmN0ZGZQclYxS3BWd0o0VFFD?=
 =?utf-8?B?dVlOM2dJTnJ3aDVvK2tRcEVWU1ZGbFJwUDVpeUdLQ2c5eUVkQk9mbm40bldQ?=
 =?utf-8?B?UzJ5L0krZnRGSHM3cTF3d2kwL3VNWnNDdndBUHhkZzhYM0pvR1dyaWtZcFRt?=
 =?utf-8?B?QUN1R0NIUmU1WVl3cnBYZkJ6N2E1dy9HVG5qWlIxbUtrbGpjTkp4U0E1QWdE?=
 =?utf-8?B?T09INGFFUDhremtJR0pNektxamVneHQveEdMU0VsUVFoTEJJYTBKQWdFUENK?=
 =?utf-8?B?TW4ra1I3bGcxbGxXSjBCOUwxQzhXb3FsR1JGUDhBWmlJK3cyS25ob05uV2hv?=
 =?utf-8?B?RlZ1ZmRvbGxlOFBuMldiTHI0TXpnTEtXUUJQV1dpWExwNWpNbzVtQmF5VkI1?=
 =?utf-8?B?bGlqYXIwRENSeFEwdHEzM0tTRmFPL1k0QnIvV21jY3o3VlByV3lMdlBZQ2dW?=
 =?utf-8?B?dVdUcVNOc2NGaHB0Vk1XeUZSc1dIMEpkdHIyY1hoK1RqRXpldFMxU3hnOHZt?=
 =?utf-8?B?Nk5ISjBkbkpFeEQ3ZTRjMTgzNDFFUFh1d0FmYk1ZcHNhOW8xSk1lMnV0b0JL?=
 =?utf-8?B?UHFadFhUSDVHZjZJenU4Vy9KOGY3WVlzOHFRbkYvRVJ6VnRpWE1xTjVHNmZQ?=
 =?utf-8?B?UXpaanpzWXd2S2Z1TFVKMEZ3U2ZoeDFSdXFtbWFyWG40RThsL2JhUUFqMmU5?=
 =?utf-8?B?emcxUC96S20yenBOZFdQWVZ5VXZCSGpFdi9VOHFoeW55bXRpR0tDcXVlQjBl?=
 =?utf-8?B?Q1F4aTJ2RFRXWmxZZE91ZFlGbnlld1JwSGJGZWVQTHc0K0ZNMFNiQUFuRGM5?=
 =?utf-8?B?Z1ZMSFZ2RGIxb1pTd2dSVTJYaW1Kc2VkKzRJVDZqK3Q4TzQwbGJ3TFkxZEtS?=
 =?utf-8?B?YVErRXcxS1ZtU2xrallxZXdVRmxmbkd0SnU0aU9BTElYQVhtcTY2UmVXK3Jy?=
 =?utf-8?B?M2NKaEpXbTM1ZWQyZWxwVllKYTNGTHcyU1drMC9vQmR0SmxONnJYdkdpZWE3?=
 =?utf-8?B?UEZBN3U0WThTUzE1bVBvdHlwYzBVSTFqR2RLZlBJV0tWNi8yMGREcFU5aTNq?=
 =?utf-8?B?WjI5dXkvL0MvSklYWW9PUWRRTjRoZGI2c1FLNlZ6T3FJNDZONkZVTzc3bFd0?=
 =?utf-8?B?b1V4TkpHNEI3ems3cjlncGI5SDZyOFJNSnAzdG1BOFRmS3VMaGZHSSs5b0Q2?=
 =?utf-8?B?VlNkREUwMzdLUzRQRUNGZCtpQmgydmNBYWxvc0liZ0ErcUJ1OHFrTjc2SVRx?=
 =?utf-8?B?VVRSNFJveWxTVVRkRjE1WnljcldmSGtBazRFemxWUXN4Q04zTkU3NDhVZGtY?=
 =?utf-8?B?akEyYzE4cTNGcmE3NUl0UFZCdzkxOTVtR1R2OU81bG93K2paMm94RlRMdUlh?=
 =?utf-8?B?MFNHN0ZMMGVGWWhOSmNPakkyUmVwem9mbzB1TFh2UGErTXBtWHozWWdocHl6?=
 =?utf-8?B?bWlOS2RuaW83MUp6S09EZGp3eFpSd2JLMFRqbFFyRk9PVUh3NDJyNHZkbTVm?=
 =?utf-8?B?SFVjRU1SbzZyYVJLaUR5MElwb0dJK1RPWFpyM3c4TzQ3SWxBdGcxeG5zS1VC?=
 =?utf-8?Q?BJurSeaVaOSGQpbwzQ3VDg9Wj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 820e78ff-562f-41cd-a964-08dd8b1233ce
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6363.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2025 13:47:25.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MV3RihHx7d4Oelhp6PXCbc6c0TrCf/Bgg9B5kRZLGAFmdHiAVtuR5bHOevB/xxvos32hlirRSRKHgAVDRAoVrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7664

On 04/05/2025 15:39, Greg Kroah-Hartman wrote:
> On Sun, May 04, 2025 at 02:55:00PM +0300, Jared Holzman wrote:
>> On 29/04/2025 19:38, Greg Kroah-Hartman wrote:
>>> 6.14-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Ming Lei <ming.lei@redhat.com>
>>>
>>> [ Upstream commit d6aa0c178bf81f30ae4a780b2bca653daa2eb633 ]
>>>
>>> We call io_uring_cmd_complete_in_task() to schedule task_work for handling
>>> UBLK_U_IO_NEED_GET_DATA.
>>>
>>> This way is really not necessary because the current context is exactly
>>> the ublk queue context, so call ublk_dispatch_req() directly for handling
>>> UBLK_U_IO_NEED_GET_DATA.
>>>
>>> Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
>>> Tested-by: Jared Holzman <jholzman@nvidia.com>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> Link: https://lore.kernel.org/r/20250425013742.1079549-2-ming.lei@redhat.com
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  drivers/block/ublk_drv.c | 14 +++-----------
>>>  1 file changed, 3 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>>> index 437297022dcfa..c7761a5cfeec0 100644
>>> --- a/drivers/block/ublk_drv.c
>>> +++ b/drivers/block/ublk_drv.c
>>> @@ -1812,15 +1812,6 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
>>>  	mutex_unlock(&ub->mutex);
>>>  }
>>>  
>>> -static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
>>> -		int tag)
>>> -{
>>> -	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
>>> -	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
>>> -
>>> -	ublk_queue_cmd(ubq, req);
>>> -}
>>> -
>>>  static inline int ublk_check_cmd_op(u32 cmd_op)
>>>  {
>>>  	u32 ioc_type = _IOC_TYPE(cmd_op);
>>> @@ -1967,8 +1958,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
>>>  		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
>>>  			goto out;
>>>  		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
>>> -		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag);
>>> -		break;
>>> +		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
>>> +		ublk_dispatch_req(ubq, req, issue_flags);
>>> +		return -EIOCBQUEUED;
>>>  	default:
>>>  		goto out;
>>>  	}
>>
>> Hi Greg,
>>
>> Will you also be backporting "ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd" to 6.14-stable?
> 
> What is the git commit id you are referring to?  And was it asked to be
> included in a stable release?
> 
> thanks,
> 
> greg k-h

Hi Greg,

The commit is: f40139fde527

It is Part 2 of the same patch series.

Regards,

Jared
