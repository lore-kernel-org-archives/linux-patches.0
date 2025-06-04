Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15591D7E4A
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 10:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032585; cv=fail; b=hiyuH52vy9NHrFHDjep5FOrYgRlZ14mzzISiUKEhSQgGp1UyhdwASbLRIxgrA87XoJkyc7Jj4hxDHudj4G7olljngK66yuNcjuOkSBbXyfpDKDawvTwcQGOel3vML4LkjirpTM1iRp+SYjzV65Fp+g8zvhWL7YeD/+0VC0XL3Ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032585; c=relaxed/simple;
	bh=8e6Q5YGUc4QQFe2tD7dO88Q+flP5yiHC5OQq0sF01rM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g/jwKdwsv5WIu6lgC/+Vx/89k/wKkN/toVQaWN5/xYIaB1tC8ItfCqRKK3VrNpTQzIRZFTXYel6GfLds7E9n82CTBe1iIHhd/TjWXL75c/uh3445CiBLsPzA7bkahvY3lWHp+xJdpNxm77/cjoQffvHyzIXOYbXHRfeFNzuKGxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pc2IsaP7; arc=fail smtp.client-ip=40.107.223.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pc2IsaP7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WYkv/ZYQ2ahn+M4LChzeAQ0kaysC5hIAV+GkugdQmkZByOYYuWu6HtCoHZpnoi5dCyo+zGgx8Wt37iXZPsLQh9GmW3Mwo9wMNLiWQqdFQX9qCnPE5veOFt2XBzxR6NLGZC6SikGCMBhTtlALELRBwAtQxWaom81kg1qgXP1OqbxffiICeHxWXALUJNFBHm1AaRBtu8X1bwCorQvUerLqKuhMkUfVD4IbGtEXHtK98y7Mj6KDnMlrcxeGTPD7VdXrkgpDJL859LfrJ3EKL/D4wK7aexUuV0PIr4KhavILd0YFZu4tL4svITEZbdgG0AHjVFhbHxaPKoNq+VybO2YYbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbd5Qu5ILLbqyGOwC4M5+j+wgFAVTGjBxNZAbVC5ufI=;
 b=dzND92pndBpZHT1pv8rm6CjqV9Dsb6Ed2sgMMOZ1p9LgXlFoYKnSpoHFdLdMJrPxen2NYYFfZYaS4TO8hHsqNz3/TZ8s9NxZMiZey4kYlTupqOO54SnSnfCS+0SC83H+eG+eGqZMPL4lcppc2Y1W5suX0y5qN0810vmR33Hyqof1S7XEu73cBcmzxk6mmK+rXsofFX55ocQKoKq7YZuTLy04qs7l6hG6vaeFlpeCWej55huc70C0juIXMrSRQV1ib6iOlEYx6w0qNN51qb1AmugvEFKnG59Rw/+IjyDrhCHtixgYjFFbE4QRxfrcanBeoHdTJK2BZwF5PStfQSulew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbd5Qu5ILLbqyGOwC4M5+j+wgFAVTGjBxNZAbVC5ufI=;
 b=pc2IsaP7QttD+n7THQLg2qtiIYSc9qCo0SpV6w7Ydc+5TP/8lC57kwIpDo5VRkAfFQwBezSYSkuRCLiCK02gcinqgmLhfzRy5pFmUKNC08MIFVVFSfodsxuuCzKRklYBD+kkq3ay0KTYfTK0XhTjuRl+f+zsvO/StHzCaG9CZjaHrwsFx6izOzGWgI5yXOsiRmfNO39en/Fiu/HC3FtKaPcYFVrWBw5kRyjvtfjLk1ggQV4KDKkQJtvtyuLc2uE5Ms/HOzt7XWyBl8H44HQeJ6lih2aFCtl90GWR/0WRxzvhkAZhCyALj2WsXKr094rXR5MeH39RtTHPf4MBYroB6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DS0PR12MB6416.namprd12.prod.outlook.com (2603:10b6:8:cb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.37; Wed, 4 Jun 2025 10:23:00 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8769.037; Wed, 4 Jun 2025
 10:23:00 +0000
Message-ID: <b103ae12-150b-4b89-bc77-86e256dac7bc@nvidia.com>
Date: Wed, 4 Jun 2025 11:22:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org,
 Aaron Kling <webgeek1234@gmail.com>
References: <20250602134238.271281478@linuxfoundation.org>
 <ff0b4357-e2d4-4d39-aa0e-bb73c59304c1@drhqmail203.nvidia.com>
 <bf1dabf7-0337-40e9-8b8e-4e93a0ffd4cc@nvidia.com>
 <2025060413-entrust-unsold-7bfd@gregkh>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2025060413-entrust-unsold-7bfd@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0055.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::11) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DS0PR12MB6416:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b0a06a8-b122-420a-f4e2-08dda351c807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVpZR0ZrdE1oRHBOTWMxTGxwTUtEZHFpUU9JK1VkZ1o2elhwOUgrVFg5R2l0?=
 =?utf-8?B?VW0zK0txMnRCZ3QzZnRVUkxGdDhoRStYYnFQdXlwSVB6T0VOMHZMWERCOHQ2?=
 =?utf-8?B?dVJxVHVOMzV1a3Y0WktOTFI5RjZMbVNEK0FxS2g3N2NtdDRENkEvbnc0SEEw?=
 =?utf-8?B?VUU3MnBXMmFrbE5PUzRRd2NScHFVREY1SE94RWhSOGloZXd0OFAxYmVkMTNt?=
 =?utf-8?B?QlVBUWlIY2VqMzlWNVkrNDhMblZzMmhoeFMybTMxaklWUzA1cUs3MmRuelBy?=
 =?utf-8?B?MkVZL2dwYnE0SHVFbERBbUVYYjNxTTI2bWRMZDkvcUlYME1KdStiNGpJcnlG?=
 =?utf-8?B?V1FCcCtXVkxyaEhpd0d0RzA1Tkp1cm9oQW93RVl1LzlnR1FId0haSkN4c1lE?=
 =?utf-8?B?NytpdTNPMHk2bEw0MnJGSDB2VTlKc0lBbXQ4RWRieXh2R0Ntb1h2eFBadzNq?=
 =?utf-8?B?NDVCZ1QwNXR1QUk4d3hDQ3Q1bjdWcmhuMzJaZGtCMEFnbGxsNy9ETC9JdDZG?=
 =?utf-8?B?d3l0RmRvcTZDdzUzTW4wMkdHa1IwNUtUR3psWjUxOE0vVngxb0szRk1DbXF4?=
 =?utf-8?B?N1VWRGUxMGJ1QzYwNWIwWWlWODFrWDMvSW55ZnAyeDdtbGNySUVUM2krYWJp?=
 =?utf-8?B?R1R2emVvN3FYKzg3aUtwZzBHZDhVYTBScWxLWUlRd0o1SEJ0bnNhdUFRWTlz?=
 =?utf-8?B?MDRzVzVxVnhFNTdoL0tLbFNLWDUwRjVpd1VvSkNMM25uL0EwalErYWVGWkxK?=
 =?utf-8?B?ck52LzhYWVNWREFRWlhhTksrNjNmVE5nWHNLZVlYU3Q1T3NEbU0xUGpVVHRB?=
 =?utf-8?B?ZHl2MHZrMWNsemlRWXBQTlE2c1FuS29wUEllcldjOERLY3hkN3JzQmNGM1VK?=
 =?utf-8?B?dDJWbWh5SmdhQXlpc0dVeTRNd1VyL2NDZnFKdlVXam9na0RaRk1WaEhwclRv?=
 =?utf-8?B?Z2RHWTVIWVdHU3pKRnJPTXl2SXVPSDdmL29nVytEcjlJRm02TktQb3hMRFBv?=
 =?utf-8?B?TEhkblcyT0N2VkxPRHZOamUzSFF1UzhuZUQwMjRQaHZCLytyZm93aHhLTFh6?=
 =?utf-8?B?NU4yUy9qVXZ2Z2JmQzUzamhNdmZEYlFCTFJ0emozZW9seXRSQzJLSmRuNUNa?=
 =?utf-8?B?WEJWODdiWTRQdGJIcGVzbGxLM005bGFXbElwWkFmUmRVMGlId1A5SDRBR1NF?=
 =?utf-8?B?TThWQlE1cUYwTmZZS2Rlb3dSaEUrZGNQWFUrQ1Y0Rk5NajhYUVJ4L1QxS0hk?=
 =?utf-8?B?R0VKYWF0L21Rb3oxNmhDNkR0Z1hkeHd4SGZxOFNOUHFPelZhOWY5aWlIK0dC?=
 =?utf-8?B?TE5Uc0dwaDZ3cTVYcFRvTjZ3c1d5anpSYkZUbzlLTXZtR040YWIxTysvbmxs?=
 =?utf-8?B?THJmRjJJbnR6YUFiSUI3ZGp6N3FIa1RxMks4YlpNVWxNdk9qc3Q5YStXT1ZS?=
 =?utf-8?B?RHdpVjlGNGZtWWJNTndyVUV3SUIwRDBNQnlKMXovMzJlajl0Q1BGZnZ2RDJX?=
 =?utf-8?B?ZkdoRjZpR2xidDJrQ2p2dGw4eXMrNDh2clZDRlIxYVMwdDN0RlhVNDRHQnpM?=
 =?utf-8?B?ekpLL0kvMDRYZGxxUVVIMERjZ2dNVVA5VXRJMWxmRzN2ZGdKa1VaUUdselJ1?=
 =?utf-8?B?RVlWSGlQOTFaVDQyKzJOUUcwTkdoOUJqRkxqdVR1L0Z4a1BFZnNyc0FKc2Fi?=
 =?utf-8?B?TWRVVWNmNXZQMy8ySXUyNE1TSitDbVNITnh3TEo0ZG9HZExLTW5Ea3IxYlBN?=
 =?utf-8?B?OVpKZjdGUmhabCthQVZMSnpYejgydGNWSVpyRHhVMlFzQ3V5dWUrRmd0dG05?=
 =?utf-8?B?bHlYRUxlckV4TE5zc0dnZ3piekQxbFJMU29vUlJtbC9FazBLaFVoQTJQRDQr?=
 =?utf-8?B?UEdza3MvTHd3RmFveVNPVVBBRjV2Z3QyWVJZTXlSVWhlT0ZNU0xicTR3QTNE?=
 =?utf-8?Q?hbuQrzo9l1A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUpQeTV1dWtHRHFhZm5PVXV1dVpQMGx3QU9HZklzaHVONW96RHVZRVJ6dUFI?=
 =?utf-8?B?TG01UVJYQktJYjUrdmhFRmZ5Uk1iY0VNRG5jaVFXVEtuQ2ZkZjVqb2tpYWlP?=
 =?utf-8?B?VUMxSnd0QXAzQW0xak5RQ01tYkxzR0owSm1DYUZhaTZDbkt5N1B4NHpjQWZk?=
 =?utf-8?B?S1VNeTJYd0x0eVR0TDM3TG1UajdxV3hodmE2YVBOeWI1WHZmV2FhRmt3Ymo2?=
 =?utf-8?B?SDErc1VCVUtrbWtDcGw0TmNsSDk2Wk9zN0xMa0l0bjBCRDhhQnQ1Z2ZVb3hj?=
 =?utf-8?B?ZTBLQjVDck5YdUQ5ZWdzNkZKUExPU1BzK2grVHJmWHRwM0lWeTZINzBLdDNs?=
 =?utf-8?B?V2NlMCt3RWVqOWgzbXhOVFFwUnY5b2ZicW9VOGtxTENFQXlaUVBpcUJUSEJn?=
 =?utf-8?B?eGF2Uk5pSDZFc1ZyZFpuSExlNlhodzJKYnNoQzNUS0h6MmNZekdFenA5eDhx?=
 =?utf-8?B?Y1BqdTA5RE84SnRHMzNzMVozM0pPTSs4WndoNGwwaFZ3aUhDRHZKcWpsWEta?=
 =?utf-8?B?ZEVLMC9CbzBET0dOaWdra2dYTXh5NkxKaU5IM041ZzBJNVc1RnBySjRwek9G?=
 =?utf-8?B?VzNDMk5YdHdsaDF5cFkzNVZ4aWIzdCtJTVNVMDcxaGZOQldFN2F6cC9tT3F2?=
 =?utf-8?B?V1Z6anlZajhaODk5VnNvZDdjRDF1Q2ZGbEhOUWltM0RVcG9HZFBGQmZ6RGtM?=
 =?utf-8?B?bzdaZ2JqNUhyZGFNSDlyQWpibUt3TGlNRUdocFBsVTNDY0NIU1RGNHlkeElw?=
 =?utf-8?B?a3JMT0hUUDB4bnF2andiSUIxLzAwb2NkUWkyWitGZEswYTR5b0NldmkzV1dW?=
 =?utf-8?B?anJSR0VuR1diNG1PVjcvekxkRzlJVnFKZnZYVkFVUmxuaTFGbGZodVB6UXlC?=
 =?utf-8?B?c2xRbWtXWDY5K0hFTXlRRDRNNitoaTFBZDNUZWdkbzUyL1g5NjJuZlp0anV6?=
 =?utf-8?B?YUIwSWp0bHNSNi9KTmlRU2JzMzY0dkIvQWFubFNhK1JuWk15Y0puM1pzRUtj?=
 =?utf-8?B?SjZIbnRQb0tjK3FjejM1MWc4ZThkNU1aQTN0ZzVGbFdxRDEwTk1peFlUS1hY?=
 =?utf-8?B?MVJaZEtzL2hFS0dFSHFxSDBlUXIxaG5sVlVORUJSandPVytDSkhka2RkSnBF?=
 =?utf-8?B?S08vNVQ4ZHcrSSt4azU0Mk10TzUrUTBTbkhTNUwveER6VmtZWDhSREFpZUgr?=
 =?utf-8?B?MXo4bHB2MVl5bnkvcU1uVnVCN29ZYjNKQW8zMDdLTE5KaUVuQzVXak5ZaGF3?=
 =?utf-8?B?ZGVwMlRacDhLRGdwTGVMcDNwd0ZMMkY3TG9kNzVVN3JWWUdKa3JVelptNFVu?=
 =?utf-8?B?SXhYNitTSnp3VUpJZm1RV0pCaGJPRFFLVUp1eVY4WG1aaHNHRlQxSW16Lzgr?=
 =?utf-8?B?bnJmZE1jRTJBaW5haFhBbDVRRGpLUklhdDY5Y1RURUdLQ21ybEh5RmpxRXpz?=
 =?utf-8?B?V3I1WTVyR2ZsK1U2ZzZTckJjZjhEMGpJTmhsQnl4UnZsVUpkN3FPWS9aOHpO?=
 =?utf-8?B?RG1vSytjSXVpelFPQmNLS2dpS2V1MkZwZ09iQk1tazJiVUo0d1lwZ09TUGFQ?=
 =?utf-8?B?S2xLQmRmbk5yVG9UMVVBQjZtekt0R0xhbXR2R3AvdUpkVE1rSG5IMk9HSmNo?=
 =?utf-8?B?em9HZkU3MFhwTE8vUlZ1eXJYTzJFQnVVTmxHdURDSUhhUXFtNlZHWS9PaHpQ?=
 =?utf-8?B?UU9ZZzhUMUE4bDgwR0h0NkViWGdTQnl0eGtldE9zRVlnc01oTGFWZmxjdTgr?=
 =?utf-8?B?ekdkOTUxYnBQcDJmOTFnQ3lyQThDR0t3Q2tPSkhyMUloZk50NjgyWEhOS0JB?=
 =?utf-8?B?MU9neUtLOVRGaU9TYk5RMlR2aU9MckNWZ2k1blpuTVQwWHNrUytiVU5IUGFH?=
 =?utf-8?B?YmJ6L2RmN0VwTm15Yzlnam5KdktWT3NRMWxBZ3kwRE13UGEyN1RCRmNHMzBH?=
 =?utf-8?B?cy9tVE40RktCRXZVc2NnbXpHNGwxYVpiRXBsdXBiaCtmL3Y1b2RoZTRRcytt?=
 =?utf-8?B?VGVkVEcwbUcydHZidlJwNlhyWDZNUnhSVkVyQkpYVGZjekZ2RnhSWkpQSDhB?=
 =?utf-8?B?Q3VkRVg5WTRMcTRwbU5nZk5VRFNMbGVKaXFvTnorNVJrRFJPK2JjVnBZZ0Mr?=
 =?utf-8?B?dC9iRlltN25PZ2R6bHpCODloZ2VxMEMyOWp1R2d4eFdUTEsrZmMxZ0JjVit1?=
 =?utf-8?Q?uYVO7ewo8VAJ81Fe3Ub3xZRVBcmqUha13OzwV1S096xF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0a06a8-b122-420a-f4e2-08dda351c807
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 10:23:00.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HYms0MwUIp945tOdonSaEzWETfYSzgwPJQeWnq2/47uHxGqSx3XDw4KLtcTolmJq+lhtyBs6crD/ohsHmz8qSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6416


On 04/06/2025 11:19, Greg Kroah-Hartman wrote:
> On Wed, Jun 04, 2025 at 10:57:29AM +0100, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 04/06/2025 10:41, Jon Hunter wrote:
>>> On Mon, 02 Jun 2025 15:47:17 +0200, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 6.12.32 release.
>>>> There are 55 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.32-rc1.gz
>>>> or in the git tree and branch at:
>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> Failures detected for Tegra ...
>>>
>>> Test results for stable-v6.12:
>>>       10 builds:	10 pass, 0 fail
>>>       28 boots:	28 pass, 0 fail
>>>       116 tests:	115 pass, 1 fail
>>>
>>> Linux version:	6.12.32-rc1-gce2ebbe0294c
>>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>>                   tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>>>                   tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>>>                   tegra210-p2371-2180, tegra210-p3450-0000,
>>>                   tegra30-cardhu-a04
>>>
>>> Test failures:	tegra186-p2771-0000: pm-system-suspend.sh
>>
>>
>> I have been looking at this and this appears to be an intermittent failure
>> that has crept in. Bisect is point to the following change which landed in
>> v6.12.31 and we did not catch it ...
>>
>> # first bad commit: [d95fdee2253e612216e72f29c65b92ec42d254eb] cpufreq:
>> tegra186: Share policy per cluster
>>
>> I have tested v6.15 which has this change and I don't see the same issue
>> there. I have also tested v6.6.y because this was backported to the various
>> stable branches and I don't see any problems there. Only v6.12.y appears to
>> be impacted which is odd (although this test only runs on v6.6+ kernels for
>> this board). However, the testing is conclusive that this change is a
>> problem for v6.12.y.
>>
>> So I think we do need to revert the above change for v6.12.y but I am not
>> sure if it makes sense to revert for earlier stable branches too?
> 
> Yes, let's revert it for the older ones as well as it would look odd,
> and our tools might notice that we had "skipped" a stable release tree.
> 
> Can you send the revert or do you need us to?

I can no problem. Do you need a revert for each stable branch or just 
one email with the commit to revert for each stable branch?

Jon

-- 
nvpublic

