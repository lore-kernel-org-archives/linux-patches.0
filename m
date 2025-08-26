Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BBE22128B
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219609; cv=fail; b=UsXeeOQQp5aSvSzQLPgcrrQa3lJoEgvOLYyUtymiSVkzlOdHdtbnPeX8pRUMMpzNjDoychJv27AXbWnDKKtwSTfISNiURX5Nv+FsXm4ERB++0yLEUWgenS6Zeg3d0iJA8dd6t+7w8wykSfDLnSen+dUVhGJS4W0BPJa4nd7JZc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219609; c=relaxed/simple;
	bh=9euU7a2I3AfOLNf8gJ1TBWrvKj2IGf7LwsF+qBcUEzA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IWSqiI+cvSnlLWWI0oME0YzcXZtGJUZ+30+GPRzINVUuD5S0mrF5epZ62RcOdtYoBOUupj2x+aIZqtNQOuJ0OXZ1KlFUKiHjYGBMgp5/JNXGHlDllr1vJ++jBjt575px/JBD1MVQL8hWNu2jNG5r6AoZT0zGdm2mXeMtpvjr/U0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XdPCvuMt; arc=fail smtp.client-ip=40.107.220.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XdPCvuMt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lf09ElO77VMu48/7gsOFb9es+WKWxMV+Xsdxf4etLr54rxnzgVCr+gJL0jewWtSjW5/U7l5nmfC1D+tQtFhZ/ZXBESPKgLbJcOC8a0XOZIMTO3VE5hQV5MYfKBPyFjHlmawYnsgLBZaYW0qPVzCK9YNB6MvSuKrxmGFJS2hkyL+NpBD9PeCDtNKWtQt0Y4aHCzVOX+p6mj+PHH8LBNg1LB17zTm8zfvzl3vDhpNMyqq3Ym9enGx3IvCzKHPO3ctM3ySegXLecT5IIjZlPDpBqDpFs4jN/FDw6Qh3ULfnBVZHCr+TUWCgQsK5ZrSiG3ONCuksR2LpaVumlu/PN5el+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LbPHeuD4p672+ynr0yYcJ0HTaBOqYPcsce35r1N/xPw=;
 b=e3mYdvmVltCxCgpibiOtkFKiKWrg876cbldukYNxhHz7enqPoJBtuSbxabHNatjQaUIUqGJQoBP52aVDqSqUgHNd4wdUsbDly7jCyqsC9ElPu1BLWmswIE9IgHsszKVKXVo/iS8ZmXW0G2dn52gcXY5V9cz4rvdbug1GR0OVj6w4JxVAcjLDG0pKHniDlaB52ZkE+zIPybLQbUnENf5GpzDxyAqYIw3oPHXlrw3CLLi/yd+rXKG4pQXpz2w4zmOE1rtZEBAXVQWS7//UnH0RDFmOteMt+oWmh3iMTGEs8KcXW+SrI97rstUxkE+3yja8DT/R86vCtERCNRw9MBy4lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbPHeuD4p672+ynr0yYcJ0HTaBOqYPcsce35r1N/xPw=;
 b=XdPCvuMtkpMYtZs04LwDEAjxfswa0rg/JNRfjy5pDKuxqRbs3Kel1JtSOsxkf3bkcu2h2K1AKsWer6Cbfn7tZBOXXxMR9BRzQ2vb+aF4E1MNFSN1iU6KvPO39po5tg3JL6ohQtaw1b+UpleEbYHKC1FJvyqx7/F000iVnyo/cYgTiAt2yKlAN+eEJWR58kWvCswi+hBzWLbKUd0X0SWQNkS7R/wA5OL1eqmDDCkovJb/7lEkJAQJ58PJQeqyGVb/giMGYyAVXvdDf+m0Lgf0ebXIhZXjV8WJjvyTCp1cyilYnSYd8+zEzStolsrtedIwGLrlOegqSIkrC0CFrl5p3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CYYPR12MB8729.namprd12.prod.outlook.com (2603:10b6:930:c2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 14:46:44 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.9073.010; Tue, 26 Aug 2025
 14:46:44 +0000
Message-ID: <ed898a83-48d1-4cce-87b4-b67ee4fdc047@nvidia.com>
Date: Tue, 26 Aug 2025 15:46:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/403] 5.4.297-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250826110905.607690791@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::25) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CYYPR12MB8729:EE_
X-MS-Office365-Filtering-Correlation-Id: df1a38e4-2966-4be2-5814-08dde4af606b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2NpTFM5Ymo0QXVhcVIzMzM0emM0N3JRSFVvaDlJS1A2N3BIUTN4TnFCSSs3?=
 =?utf-8?B?SC9xVTJtRU5lZHdtSHE1a1FYd3oxcWdvdCswM2ViVFIvN0V1ekdaVFBRZGhC?=
 =?utf-8?B?S2pUSzZXUDA0YUxoekJESW9VT3VZbnZUVXNpb0lwSXpWeFZhN3d2eGt4eUNV?=
 =?utf-8?B?R09vRkdrQlgzaiszclRkeVl2MFpzY1M3Qm56d1BOTHM4djNEcHBFbUgvMHdz?=
 =?utf-8?B?bUVLSTQ4MDZhVTJ0amFBVXNxQ0R6ZjY3azlLZjB6Y0hseTd0M0x6UTFvalJ5?=
 =?utf-8?B?K2Q0V2ZESnFyUnF4T3Mxd2ZqbmhtTGt2MUcwcHN1MngyalVwKzNSalloM2lz?=
 =?utf-8?B?d3U2SDErVmJVYTZ1V095UWRUamZDb1BsSVp6NEtDU0FpTHhiYS9TeHZ2Vk8z?=
 =?utf-8?B?b0oyZmcvMEsxQXFpNm9LaGxOK1lvUWZxNFpsWmJDeEozVjM4Y1JHRHVOb3lS?=
 =?utf-8?B?ODBJVkJ3K2V1MVFqeGVqcmkvbURQNG94U3ErSEFKei9qWDV6alJUSHB6TmRT?=
 =?utf-8?B?c0hiK05OR0J0dE1uNytBYi8xcVk1eWpveU9NN0lkWUR5SzhUMkViVklqQU01?=
 =?utf-8?B?ZXBmTVFRc29Pbk1OZHVsbU5NQUhjR0ZBYmdzTUFSRlN5TXJ5YU00VlQxV1l4?=
 =?utf-8?B?Nm9WLzBHdFRMRjZJMXhOcis1Wm5TbGw5WkZaRjZsNEJvZlZFaU9kUVhrY3lj?=
 =?utf-8?B?eFMwK0dWbjh0ejVYZGNTZlpYbW8waVE5NllGVGUvRWNTc1ZsTGpNYXoyVWIw?=
 =?utf-8?B?ZERqcXhNNnl1Z0RjbVprb2Rkd1kxS3dlNFk3cDBSSWR1SHlLN0VkNDNyYTFS?=
 =?utf-8?B?NGthM2JhdWRPZms2OXlVVFpGTUw3SEZ0TTI2ek5lUG1WQmFtbytyTkExZU51?=
 =?utf-8?B?WThYS25wV2hsMkVkdk5pRmRLN1NGR2RRNG9nM2x4Ylppa292UGJaMFBJWGt0?=
 =?utf-8?B?ZTdCckVBOCtVallZY2FxdXNmWldFdkc1Z2tBakRTN3hNYXBnWVZKV0dpck9i?=
 =?utf-8?B?dUtWWU0yaitPb1pMNXlXZmg1RmxpQlZMTjlVMEVuOEp3Y0pkTWJPTGZTSSsw?=
 =?utf-8?B?azRFZGhrNUExS21XTnlBb01tbnpKY2t4UXZocFAyeW1WZCtxbWxjSWVWWENS?=
 =?utf-8?B?V3UrRWVSWHlxWng0MU1KUjJZTzh3bWNIbUI3TlFJL1pPeFNtNjRkRGFVNjlB?=
 =?utf-8?B?K2p6Yzd1SGsvd1J3eFpGR2YwSHhEZG1mOXNIMmpwSVRrcFJyUnlmTE5iS01L?=
 =?utf-8?B?RkJmRlJCa3dOZ2U5MGRIZGY5S0x1NGxKUlNoNlNLVjJkQTVIOEt6czN5MElx?=
 =?utf-8?B?ZHJuQkNjNGV4WWY1MHJ2RW5hWkp0TDVnVXFxZWpSMnF2VHdNUlpsUTJZVU5O?=
 =?utf-8?B?WTlzbTVZY3U5ZHFwWmpIUmNFSjI4VzNab3V6ZmhOajc3S2RTbVFVRFVraU1s?=
 =?utf-8?B?SXlRdzBIUlY3ZitBbkhNRHFRanZEMGczSEFOY3h2cHZNTVZZWnR0aXI3dS82?=
 =?utf-8?B?dktOalVsT2ZndFBpUVI5WlNiRDUrUysyRnErZnZueHpCcXArTUcvSk12TnR0?=
 =?utf-8?B?NXBNQitDYTM3bTVGT1BoWlNiNm1mK1c1aUd5UnkyMWNiTVpCbWRaUGtTUHps?=
 =?utf-8?B?YnVDeEdDVzN5N3AvYzJtMWpPU2pYZ0ptekY0T3c2SXU4bEZKT0FvcGVScXBl?=
 =?utf-8?B?RlpSVkYzQ2NTQ0lqdmc4dEtuYkx0RTVKU1p1cmEwL1ZYTXdqbGdMcFZ3SHVP?=
 =?utf-8?B?U0tjTnVTakQ0bjFoaEM4b09EN3Q2UnJSVG1WenhjWjVHUzEyS3ZVMEtTd3k4?=
 =?utf-8?B?U3hoczI0eVJ4M2liZkxkVXFOTys3TktRMk5aQkVMeHNTUEN5RGJkVUtqcmRF?=
 =?utf-8?B?QlA0ZFZ2WmsvU3NxMXhUMUNRY3ZyUHlmVURJbjBzSmRrcjAxeXlneVB4YVkr?=
 =?utf-8?Q?nFMskFhdsmc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEFjNGFMR1JTY0Q0bTJYTlFpMHJ2bmszd2xNOXhPSFpVcVlNT1VkbnhBNEd3?=
 =?utf-8?B?MjRONXlBcDNFSmNpeWFuSlM4QzNkbkYzN1BQN1AvSEs0TVVETDZHbVJYVnYv?=
 =?utf-8?B?d2RpMUlFdjYrTUlDcEdHZ29ER3VaUXlPTHlBeGFMSXBLd0d3M1RjYkJUR3FC?=
 =?utf-8?B?Rko1cXRDZjlMcml0NnViSWhXWFFqaEJRSE5BUU9kL21RRUJHRkRkTUNJdjhD?=
 =?utf-8?B?MUd5RHFXUnpQRnpPUWErcFhsSkJPSXBxM3E2Qkk0Q2FTTTR3TTJ6ZVlPdk1J?=
 =?utf-8?B?eFpCa3pZeUZmK3dTdUJwVGJjWGJKUlk0QWV1NnhCaEg4OEpSVkx1VzB4ZG5q?=
 =?utf-8?B?ZFJ3TXREaDBPZW1WYkdUM1I4SGx6YkdWZnFZTjJsNkxDTXg4S1pJTHcrZ2Er?=
 =?utf-8?B?ajJLN1JkZHVMRlJrVytPb3NKYnFNRC95RVRxcjhzVTRNVnBLSFg2TDdSSWxR?=
 =?utf-8?B?em9jeGhDeFVQNWsxWnhqdVlzK3RwZmF4VzJGODg2NytLM1cwSHhVcUVTMlMy?=
 =?utf-8?B?L1JQbDNhMGk5dGYxREFnWWIyZ1pVMU1YdkxMMnU0RDE4QzdybE5kZDVaNFg0?=
 =?utf-8?B?SGpkc3FJZSsyVG8xczNqQ3JsdWQ0Y3ozRHhmY3ZuOWZkaXhDREpmVml0WUR5?=
 =?utf-8?B?aUZyNzNHYkJxWlBRcU5OS2xWcER1bFZWU0UrWXhBaWNCMkNVdFJmaWI3L2hp?=
 =?utf-8?B?SWgyekl2UFpTYzZMQWVvYVR0TUY2eEcvQnZZQ0xJWFgwbG9YMWtJdmg1dTVt?=
 =?utf-8?B?bzlzc3g4YmJoNi80anZTdVJIc05SY2N3cERkOHMzMGg5NDhxQ1A3VEFOWmgr?=
 =?utf-8?B?RktmbVVzSVhWWHAzOUk0dWJXc29rNWN3SFhJbEtNNDg4ZFBURFZickZWT2xZ?=
 =?utf-8?B?UXZXUHpZcEowdGRXWWIxc3BpaVo3bVdndnZhUGxJaXBFTnZNeGRtREVrWjJ4?=
 =?utf-8?B?ZEVsdFcvTFlCbm44RFhwOEgvSEtoVFR5L2U3RVFnQk8vcCtTMUpnMFJhbUQr?=
 =?utf-8?B?d1lvRkJWa0J4UVFOT1licmVsQWg0Vk1lV3dOYms0MDVXMEJBbmdxQ0NGWm5H?=
 =?utf-8?B?VHVlbWFoVkQzS1JsamczS1RtZHQ5Y2o2MUlKZzVPRXBVQjF0dTNFWm4wMFRy?=
 =?utf-8?B?MmttR3hEOGIwY0lGWkkvbzZxUXpBaXQ5ek9oVHBDM0FlUjloa2Zwbll5U0VJ?=
 =?utf-8?B?WVg3Z1pxRjJmZHpzVjh0djdSS2FoaDVvaGZjL1E3OWRmQUF3WWk1eitkTTl0?=
 =?utf-8?B?K2ZVa29MTXloWkt5KzMvWFhJV0NZTzk3OWpiTGQwanZZMjYyR0ExVytlQ3JB?=
 =?utf-8?B?RnBtZ2xRQzBlQlFXVXBpdXZIbGF3eVo0YUUxeDNGeXpNTjlPejUwQldDRE1T?=
 =?utf-8?B?amJsbUdLeEV6RWpqMnFuVVFpYXI1SDJRdUJQanVMR0w1RFN5WjdrRkU5MGRm?=
 =?utf-8?B?VEVCbi94VjljZGlRelBjeGtXcWRTT0JoaitVN2ZmYlZJZENydWJDWWhZa3cy?=
 =?utf-8?B?VjlhOGlaTGpYcm5FM1hkUXlCSTE1Y2lmd3l0ZzgxQ3dPZnhScndQZWVxQ3ZV?=
 =?utf-8?B?YTJQYm1lS2JqM3Z2RHpscFZpMUJMOFU2dCtNdWxFZDV6S2tLUnR5MXBYdCtF?=
 =?utf-8?B?bWl4SDlQcUpiNFR3ZW9qR2wwTW9HeUs4Ti9qRG9aYnoweFcybzVCTXllNlRw?=
 =?utf-8?B?enljTXhLUmNPSHpmd2RNeFJPNi9iTGhJaW9CM1d3Rlg1YUZyNEI5cFNpVkVD?=
 =?utf-8?B?WU5RR0JjZmtTLzBnZ1Nvd3BidlNyaWpEL0FsSCtSNlhTcTY1UVVjOVI4WGU0?=
 =?utf-8?B?eFFUK3ZaZStkMldCejNhbDExMnd0SHFtc3ljb2d0TDl6VkVUNlZUalQ2bzhM?=
 =?utf-8?B?QjQ1QyttRUkyY2JxRHZNMWNyRldiWThHM2Q2VjB0OFY2cVNCbkNBTzZLOVBB?=
 =?utf-8?B?Z2tXSjVqUHdIVzlGOXpzWEhaSW5UR2VQN29PdVJxMGhQa1psaWtXeWJld0dU?=
 =?utf-8?B?U3ZBWENNNTBKaFkzYlk0RTFiMCtXbWNIdXQ5NVpXOUgwQ2JNNGdpR3BKQkxx?=
 =?utf-8?B?aFA3UVNlMmpJRVlGY0JMc3VhenFvUE9zc29GRFFsbWRZcEpGK1dsNzJmRDli?=
 =?utf-8?B?UGl4NjI2eldGVUt3QmdEZXdNZTFHUzNqWFd4RmNkQ281TkJQMDcyT1hlQlZw?=
 =?utf-8?Q?EZsyadm/77mMSbj+YdQ5HiLulAs3/p7UXbcXDjWIw8BF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1a38e4-2966-4be2-5814-08dde4af606b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 14:46:44.7037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWmhiD4At5PzWRzpq0fRshQllfl8ocQ2fyo1VymUuUSkRWNv7JIjOjuZPk7Xxr2AT6WgUjb4lD0GPKZK5M6w/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8729

Hi Greg,

On 26/08/2025 12:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.297 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.297-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...
  
> Prashant Malani <pmalani@google.com>
>      cpufreq: CPPC: Mark driver with NEED_UPDATE_LIMITS flag


The above commit is causing the following build failure ...

  drivers/cpufreq/cppc_cpufreq.c:410:40: error: ‘CPUFREQ_NEED_UPDATE_LIMITS’ undeclared here (not in a function)
   410 |         .flags = CPUFREQ_CONST_LOOPS | CPUFREQ_NEED_UPDATE_LIMITS,
       |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~
  make[2]: *** [scripts/Makefile.build:262: drivers/cpufreq/cppc_cpufreq.o] Error 1


This is seen with ARM64 but I am guessing will be seen for
other targets too.

Jon

-- 
nvpublic

