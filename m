Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F011D514B
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 15:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343907; cv=fail; b=YoTgKx+A5u1BirpDktZZQ9I96r9Gq0zRoWgxLOr3VruZCjtCb1gyQnMg+8Wns4RELxVXxrwFnZ/TSv++lBHN1sv6XoRgY8OGrm78zcM1NNOVO83kj6pW4g4LsBDffCzokt6druH5K0usBpt+A8BOkXXU8LRwrWWNtw9PBlHbc70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343907; c=relaxed/simple;
	bh=VycSYj89QHHGGKxxJRQDzuyIWqVTW+B8qDs0R2gYDgw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tgG3cBgiX3ftruzDDA9c2VXhjEkErBTIRlbgBwkWpYhzV/NadYckE/8o2Vgq+mDWs/UlVPppz0Istq+pF8eYXscrXHh2yUzpu2/C5G+m6UGszlTDMH+aA/ttpKjYmJ6ER2KF01l4mAiZxwummFu3xhB2vn+LQvzuhgFKkuuQpnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IkllB4Cs; arc=fail smtp.client-ip=40.107.223.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IkllB4Cs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADaomHQz/kWEL+ogXLieRy4cNSlbAlnbHuBVs9HdOZnjQzTCO2dRGGJzGdgXwNAMV43V4CytlORsgkBeoIQhPL7UY9BlvVa6Bb8tKLkKDMY0ANANT88MTG689yoWZ41i1JKiqtFl9GpPYK8PFbXxh38pxinJKWQUJBbZTIG5Kl+BLeYK0es94vTXaaL+Kolt5pviJolrmRU+SbiSt5l7VFbfnCHcs3b9+U7W2coPqbJ475jUwwExZymlVYmclsva3ltJfTeiprmZ0pbZ3IRzKvpz4pz6ziIicw7AEApXk4TMHhxsavS8Skw+4sKGHi70J96/jFPRLJjJOBungN9KCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZeqTWuUlZVr3rDtvoBkFgFOXMf3FVwt6W0oj6xYNQg=;
 b=JxHKJCNaL+tAw5j4dA+PyIWfNp3tXcls2l9oqZv11EOOE0jXIv76ddvRUuSFUQJKIRELmdMUOZNoosGPiVUel7NFb30bcAYEBrquB01nKzPWQlLhlfMiJah1DG+N/xkFACCoBL5Rl4vqtVngApYm2nzJ/ItqxHIamEB/NcIYGP2aN2gBk3nA/Z6GSTXCznQwCpGh9UZVvmLZ1X0izQQ81tx/6r0DTig/pFHBsDOZESu4i2AGs0RqX1PqIfjlu4KLVYbyQP82LWaIESTq22oms+Vy2Ls4rSMlKgSsVVtemTFCrviVblj93BH6JFty8xUsTxZWCS8rKaf7ZjI/LrWCSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cZeqTWuUlZVr3rDtvoBkFgFOXMf3FVwt6W0oj6xYNQg=;
 b=IkllB4CsSlJ/+Fe430u1IuWqPbcGRvWbRAOdoocAJEWNvqdFO8SDrnGGI6H/PJ0W6vJhxPn5Xv5rIn2gFifeKHBYlICEgOJ9w5PgL7SnqUBZHGNJMd94c8EXsNN/Srzhr5krKVOPyCuETnjQpS4x/zaLWRuKwcyq96Szn+rOskBEFN1OzbeV+zLa+1PBQwGexiopjAX6Qy+NbXxcU3O5G5E5sHY2TSCE7HI/lVfnILMpEYmHD/Wh83oiWQR75nhg0olbgdgAquh8D+KO5kpQCCjksyoY/yjbV7GUtb4EbEZV5tFVS//zNYZ9dJh8NZxPJJIEgP0wzTgQCzq0QNr1Pg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB8773.namprd12.prod.outlook.com (2603:10b6:510:28d::18)
 by IA1PR12MB8537.namprd12.prod.outlook.com (2603:10b6:208:453::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 15:05:01 +0000
Received: from PH0PR12MB8773.namprd12.prod.outlook.com
 ([fe80::47a4:8efb:3dca:c296]) by PH0PR12MB8773.namprd12.prod.outlook.com
 ([fe80::47a4:8efb:3dca:c296%4]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 15:05:01 +0000
Message-ID: <62ac3da6-25f6-4432-8b92-8e9ae60aacec@nvidia.com>
Date: Mon, 8 Sep 2025 16:04:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/104] 6.1.151-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250907195607.664912704@linuxfoundation.org>
 <cb958521-10f7-4301-b1b8-54784e3d88e6@rnnvmail202.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <cb958521-10f7-4301-b1b8-54784e3d88e6@rnnvmail202.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0273.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::21) To PH0PR12MB8773.namprd12.prod.outlook.com
 (2603:10b6:510:28d::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8773:EE_|IA1PR12MB8537:EE_
X-MS-Office365-Filtering-Correlation-Id: 6de0a12f-38e7-40bc-ee49-08ddeee91540
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WlQ5cXQrZ01WN29vKzlyUkJwUytlUEVMb0xaNVdPd1JvUGx2SjJVMk9VeXdw?=
 =?utf-8?B?S2J4TGFvUmFlMFFnNjRwYWFCSXcwcDBQb001d0ZzM1BJZys4b0l6L2w1ZEZF?=
 =?utf-8?B?WTYzc2l1NXJXNndNYWdVTVRGNWZOSU0wUi9YUFJaYmdTS3RjY09ERUppampv?=
 =?utf-8?B?RVBidko5ZXpTczhnMkpnWkdTZkFiVldmRDJBUlNyZm9YQlhwTi9iQ0JPYTNq?=
 =?utf-8?B?ei9TOUY4dHAwcE1LbkdJRWtZQzZPTm9XWWNlYi9HY2w5bHRENldIRGc5NTZ6?=
 =?utf-8?B?RW5HckVZZzdQWXBiMnJibVdndGdkN3ptUXlHTDc0aUtrWUpiT0F3SWkvYlpj?=
 =?utf-8?B?MUNXOVlYeVBPQmp1elJUU0twWEFqYmkxL0Nuekw0dmp6SUlnZU0zREc5Sjk5?=
 =?utf-8?B?MXJ1WEdmVmxLQXpSdDdrbHdCaGF0d2dzZXRSS2Vkayt5aXVLK0tGSXhFODAr?=
 =?utf-8?B?RVN4SjNTQ1doWnE4R2FTM2lVcVlWYUhMRTMrZ2lvNHNPeUdQdkFNbURaenpJ?=
 =?utf-8?B?U0ZDLzZUUWFQejVNSUFTM2pWYTJuUmw4UDJuUDRpaENwSnkvT0pXekZVU0ho?=
 =?utf-8?B?UUQ5d0dsOWlnUnJqQWZlYnY5ZDdHK3ZEQ3R2aUk0N0tpSm1TUUhVeGo2akMx?=
 =?utf-8?B?K2t3L0xqRk8rbGxHalVVTEtlQ01ta0pQcU53N2s2ZTExdnFjY1lOaXZvbXZm?=
 =?utf-8?B?aUpvbHNMOTVLU2hpdnF1eExTajJVMHNNM2hYeFRRWmUwRHNQRTIrOWpWRkRS?=
 =?utf-8?B?ejhSS3pIcDYzdmhJeWxGY01CdDFoVFBveVZqV3pMc3JXRnVFMjd4NHFBeHpD?=
 =?utf-8?B?SXEyRFU1c2Z5c2JBT3JDaUJlaUIrNDdtaUk4OGtRbjBIanR2WkpCNmRRTGo1?=
 =?utf-8?B?bHZmTlJsMDhVOGQrY1BuS09Ta2pKZDBja1ludGZyMGwzYnFMckVkdit3WWUr?=
 =?utf-8?B?R2VqdGFjQ0wyY2M0VXI3QVZIUHdFU3BiRFA2ZkNubXlHeG1VMGsyQTdpb0NN?=
 =?utf-8?B?T3J0cWpjZUhuZjZ3SWc5cEtsbzNVeUprTFZrckJ0c0JVY3ZXdisreGdTdjQ4?=
 =?utf-8?B?OGFsLzJYT3czS0JSdzk5ekpoa0FhVWZtS0EzaHJpWjNyQmozbHd6YmE0T0xo?=
 =?utf-8?B?ampKSXg4R3RjSU83NTAxQ0Z2cTRxd3ZLVHprSkcxMi9zTStaWlFPRWlYa0FF?=
 =?utf-8?B?blJYcjgrcHNFS3lOMGNhL3hBZHV4TGJoZkUwRjA2NFN4dVhhZ0E3TWRmMVVV?=
 =?utf-8?B?Rk9hOW4zdW5oV2g1TnA0OHk3MmxxUXNYY2IzeHFabFFWalQzWjF2R0FSenZl?=
 =?utf-8?B?US9KYkYxK0YwMEhtK1dsZVYyV3lUb1VUU1Y3N1paY0s0ekVuTHdiNFg2bFJl?=
 =?utf-8?B?cTR2RFYycVlFU3FpdlpFdDlSSHJSMGZOQklTY3hncUtWWGE4TmVwWlBXZlBk?=
 =?utf-8?B?aXJpNVo4emh6S1dhViszUTJqSUhlSi96WWxheUVCNkdUWWxqVlo3czM1V1B6?=
 =?utf-8?B?U0doTEdZMGFIbHk3Q0RDWGZYRlNkZFl2VVI2QkozRnl0RGZYTkNjdFd6dWlh?=
 =?utf-8?B?UnVyVjBvS0Q2YisvY2MxUlFLNUp4bjhHQkFBZHdPTGRWSm1DVFg1ZnBXeEhk?=
 =?utf-8?B?dVNvZ0huZ1g0Y0Y4Rk82R3ltZUlpUkNOUGxaYlBxc29jSUdYczJQS2o3dHdo?=
 =?utf-8?B?ZmtGUjB6MzRKWjFaNUJ5cnRmODQvZUdoWkNjQ2Z1RXlmcXd3cTNKT2Vnc3hB?=
 =?utf-8?B?eGozTFhmalFybHZrL0xrN1VoT1NYTDQxdXlXdU91cWxNa01Cck91NXZJSitq?=
 =?utf-8?B?ZmxJZ2NocnZTWEZRSVVTTlRqbzZIQmVTYW9HVHE1WmJLeEc5eTR4MGRPNXNW?=
 =?utf-8?B?dWIybmZuOVdkMTVrQ1dnVFI3Lzc4YUZDamE1OTRhcVQxdUYzV3J4QnF1dG5C?=
 =?utf-8?Q?36N74gxBcV4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VG9xOEpVZUJFUTNSa2xrWVF4SFdzR2o0OCtqSnc4R09ZdmI1d3RuTE1udEtW?=
 =?utf-8?B?Ym9EV0NTY3VCYTlYb2xMcTZic25RZmJxYW9XcWtNdkM3bFEwdk9UMGhicEpC?=
 =?utf-8?B?L0RsZUk3RHphVC93OUxWQTR2Y0pCcVhNeDJCUG9vckhXb3lybE9qeVZSenFD?=
 =?utf-8?B?UXZwM0NQck5KTlluU2dWem9hb2wrQlh4TDUvUXJMVXREMkFqaUNiQWF2OTBV?=
 =?utf-8?B?VEJ0YWFnUmd5eXRaNXFKY2p6dnF6aWZUL1FDbjJLU2h5NCsweFE2WFJDaHVh?=
 =?utf-8?B?RjQ4T0pRWEE4NHExWDFiWTJaZjlia09ORTBvUENZKzFYemttUlpzUUVjTnhz?=
 =?utf-8?B?YXZNbmtCMUZRZnJsd3U1aXFoWWUwWFVvK0h2cnFXM3lDd2ZJczVTSmVaM3dP?=
 =?utf-8?B?U1FGTjVsRnR4YXNtbzlaREh2eUNTLytZVEQzWFNjV3JYOGdCaFdQRzdMVmpE?=
 =?utf-8?B?V21SaWVwL3RWWWhHVlBiLytqQXAxMHRyV2ZaM2tHTlhjd0J4M3k1K3V2VGJV?=
 =?utf-8?B?QnhDV0w3a1h6MkdmM2U5UnMyWHhPQlIvNjBlbW1KdjB4TitPZElzNWRMY2RT?=
 =?utf-8?B?VGJnenBlaE1BbytkM1VGenZlQm9sbXpjSmhxdEVkUURCQzR2MkdjTG1iWTBi?=
 =?utf-8?B?U0FXV3VTYUJlajdxM1MwUkZkRU5BdGQxR2V6NDhvMnlIcmVWZm5XUzlqQkRx?=
 =?utf-8?B?UmQ3Y2gyVzhGVGFYNDEzVi90eHVtekdsbkEyS1VCNks4V0hWbzFCTUpUeUdQ?=
 =?utf-8?B?UWpvbTlkYnI1TFl4SUt5eWNyQ3hyaUFBcjZmMUtrcVNGYUZnTmthWEtZeXhK?=
 =?utf-8?B?NFFJNzFDNkZ2SUpoMWx1c1BlZW5oL2pOclppZU5QcTJHYUk5alJOSHNkcE1t?=
 =?utf-8?B?NGU3RjVOL0lndmM4STJEdk4rcmpTYmN2cUM4a2JDSWNtc01odmQvYUVYQVBU?=
 =?utf-8?B?ZnJiVVdsQk5Leng3eVdxL0RiVWF3NlNHcEk2eXV2b2JsQk9DdGFzRngwQ1Bh?=
 =?utf-8?B?UU1OMURjSU9uaFhoK1dRK0hPbVU5dklZUDRhZHIzOUxpeWZTZkMzeXdwQTBG?=
 =?utf-8?B?Z2xWMHJqYVNQQVl3dFEzc1hmbHJUam5iNk0yWlVEWkpEV0puSHRjemluZEpH?=
 =?utf-8?B?UE5QWHdIWnBEa05ZMzBrQTFrbVVKeGJtUUhHRVR1MmdJWHhvZmdEaWdraDl6?=
 =?utf-8?B?eGRMSGJxOEs2S2RvWWtCNFUvdHQzYmNPTW9GTlI4YVZxRjRUb3cxbUdDanpV?=
 =?utf-8?B?N0d3OHJVbmJGL3ZqV0lObzZBOThEZEd2dkg2cm9lYThDOHkxZE9TdkFYNmdt?=
 =?utf-8?B?SFBzVHRkYXlwWWRKQk10RzR0MXZtV0lrZHNKU0tFYUF0SVNqaWJ4N0RRVWhR?=
 =?utf-8?B?bnh5cGZUR1h3Qk5ZcWVTdGdUWm1QVzFjZ0p2S3hNdFl0T0Z3VUs3Rk9qdjRW?=
 =?utf-8?B?M2FrRW05NkxPNGcvSFhmSGduOFJJcmpORmtMaUhUakpPc2NrVGtrOW5DMSs1?=
 =?utf-8?B?c0NvbGtVUDBNUTh1ZlQ0aDhwWjBDTlI3UTlRU2JhZXhFNXk4bjlId0JsdzFm?=
 =?utf-8?B?UzZjQ1hGbHMxUkRCZkVxc1VhN29ncWZDN1Y3dzl3UjJkWXppbHVZMGcwcWxW?=
 =?utf-8?B?Tk04cGVCaUdHYWpYYk01WlI3akdMU2ora3FQRzVKSUNIWmo0MjgrUlJtczB3?=
 =?utf-8?B?YXJmWHkzT2N6bmVqWGxjMnp6NU1XRVpVSU9iNk1RdFpIZjhxVy9oeWllejYv?=
 =?utf-8?B?QVdEUEE1c0p5b2crTWFEOWpkQWpaTHllMkI1US84RXNFSCtBWnpGdlJBcWhH?=
 =?utf-8?B?dkRNK1V3bytHejdlYW5HbnJwaC9JYU4zRFFubm9jZytrNXRGazFQZFdLRUc2?=
 =?utf-8?B?MlNPNDBwRmxkemJ6TEJUbE9ZNFBTRGVvL2hNN01JZWhyUmlzYjdtUVk5RU5o?=
 =?utf-8?B?ZHNSMUlrbm10QUhoK1VjZXR6YTRSM25vZW1pTUFTVGcyQm45c0tFeDk1dWNo?=
 =?utf-8?B?RDF2bEJ3NC9TWk40VDJzZGZUUUdpWms3SytWUDFrVENxNVpUTTBmaERpZ1hB?=
 =?utf-8?B?REZOaldYUkZ5eVg3Vy9sbnhzWW1McTJYTllTN2M0Rll5d3MvQXJjWUd5V2s4?=
 =?utf-8?B?cUtoM1Y1THo3M1lFMkpvODFuOGpUUzdjbzRoVC95dTVPTXlheFFxTmJkUXZm?=
 =?utf-8?B?VEFXUFBOU1YrV2ZRazcxVVdQWjN0d2IxYlJSQW1PREI1Rk9zZnlWSHNnNnF6?=
 =?utf-8?B?YTYweWQ2TFVjSEJKVFlVMXNhUWt3PT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de0a12f-38e7-40bc-ee49-08ddeee91540
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:05:01.0787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bX+jO17sDdrFpTC4ZyIcUzrahrGLVl+x6aaIfQTeK5ug2JJFTbIAOKpcYAbXzTQPsqKXgMJwrj0tjvKfVYo0PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8537

Hi Greg,

On 08/09/2025 16:01, Jon Hunter wrote:
> On Sun, 07 Sep 2025 21:57:17 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.151 release.
>> There are 104 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.1:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      119 tests:	111 pass, 8 fail
> 
> Linux version:	6.1.151-rc1-g590deae50e08
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: cpu-hotplug
>                  tegra194-p2972-0000: pm-system-suspend.sh
>                  tegra210-p2371-2180: cpu-hotplug
>                  tegra210-p2371-2180: pm-system-suspend.sh
>                  tegra210-p3450-0000: cpu-hotplug


I am seeing crashes such as the following with this update ...

[  194.854833] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  194.863956] Mem abort info:
[  194.866939]   ESR = 0x0000000096000004
[  194.870869]   EC = 0x25: DABT (current EL), IL = 32 bits
[  194.876385]   SET = 0, FnV = 0
[  194.879609]   EA = 0, S1PTW = 0
[  194.882919]   FSC = 0x04: level 0 translation fault
[  194.887972] Data abort info:
[  194.891007]   ISV = 0, ISS = 0x00000004
[  194.895004]   CM = 0, WnR = 0
[  194.898136] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000109eff000
[  194.904774] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  194.911948] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[  194.918345] Modules linked in: panel_simple snd_soc_tegra210_mixer snd_soc_tegra210_ope snd_soc_tegra210_adx snd_soc_tegra210_amx snd_soc_tegra210_admaif snd_soc_tegra210_mvc tegra_video(C) snd_soc_tegra210_sfc snd_soc_tegra210_dmic snd_soc_tegra_pcm v4l2_dv_timings snd_soc_tegra210_i2s videobuf2_dma_contig videobuf2_memops tegra_drm videobuf2_v4l2 videobuf2_common drm_dp_aux_bus videodev cec drm_display_helper mc drm_kms_helper tegra210_adma snd_soc_tegra210_ahub drm snd_soc_tegra_audio_graph_card snd_soc_audio_graph_card snd_soc_simple_card_utils crct10dif_ce snd_hda_codec_hdmi snd_hda_tegra snd_hda_codec snd_hda_core lp855x_bl tegra_aconnect tegra_soctherm tegra_xudc host1x pwm_tegra at24 ip_tables x_tables ipv6
[  194.983279] CPU: 3 PID: 13107 Comm: rtcwake Tainted: G         C         6.1.150-00926-gd2622bc051fa #6
[  194.992848] Hardware name: NVIDIA Jetson TX1 Developer Kit (DT)
[  194.998870] pstate: a0000005 (NzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  195.005977] pc : percpu_ref_put_many.constprop.0+0x18/0xf0
[  195.011654] lr : percpu_ref_put_many.constprop.0+0x18/0xf0
[  195.017296] sp : ffff80000b1bba50
[  195.020698] x29: ffff80000b1bba50 x28: ffff800009ba3770 x27: 0000000000000000
[  195.028045] x26: 0000000000000001 x25: 0000000000000000 x24: ffff80000829c300
[  195.035376] x23: ffff8000f4d85000 x22: ffff80000a19c898 x21: 0000000000000000
[  195.042699] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
[  195.050016] x17: 000000000000000e x16: 0000000000000001 x15: 0000000000000000
[  195.057331] x14: 00000000fffffffc x13: dead000000000122 x12: 00000000f0000000
[  195.064650] x11: dead000000000100 x10: 00000000f0000080 x9 : 0000000000000001
[  195.071968] x8 : ffff80000b1bba40 x7 : 00000000ffffffff x6 : ffff80000a19c410
[  195.079289] x5 : ffff0000fe928770 x4 : 0000000000000000 x3 : 0000000000000000
[  195.086600] x2 : ffff8000f4d85000 x1 : ffff000081e9e740 x0 : 0000000000000001
[  195.093916] Call trace:
[  195.096449]  percpu_ref_put_many.constprop.0+0x18/0xf0
[  195.101747]  memcg_hotplug_cpu_dead+0x60/0x90
[  195.106259]  cpuhp_invoke_callback+0x100/0x200
[  195.110843]  _cpu_down+0x17c/0x3b0
[  195.114398]  freeze_secondary_cpus+0x124/0x200
[  195.118980]  suspend_devices_and_enter+0x270/0x590
[  195.123926]  pm_suspend+0x1f0/0x260
[  195.127556]  state_store+0x80/0xf0
[  195.131096]  kobj_attr_store+0x18/0x30
[  195.134962]  sysfs_kf_write+0x44/0x60
[  195.138766]  kernfs_fop_write_iter+0x120/0x1d0
[  195.143353]  vfs_write+0x1b4/0x2f0
[  195.146905]  ksys_write+0x70/0x110
[  195.150454]  __arm64_sys_write+0x1c/0x30
[  195.154525]  invoke_syscall+0x48/0x120
[  195.158419]  el0_svc_common.constprop.0+0x44/0xf0
[  195.163270]  do_el0_svc+0x24/0xa0
[  195.166719]  el0_svc+0x2c/0x90
[  195.169905]  el0t_64_sync_handler+0x114/0x120
[  195.174401]  el0t_64_sync+0x18c/0x190
[  195.178211] Code: 910003fd f9000bf3 aa0003f3 97f9caa7 (f9400260)
[  195.184414] ---[ end trace 0000000000000000 ]---

I have bisected the above failures and it is pointing to the following commit ...

# first bad commit: [d2622bc051fa9f17af1ac06d4169567e8bf8fa2c] memcg: drain obj stock on cpu hotplug teardown

Cheers
Jon

-- 
nvpublic

