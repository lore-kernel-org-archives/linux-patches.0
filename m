Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB8E28C2AC
	for <patches@lists.linux.dev>; Wed, 14 May 2025 19:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747249219; cv=fail; b=ozMGWlCC6jW4g4OnEByE+kk+yIz13UKsAvI8Ct+EA1d6F8rJhnPWGrpwQuGMX7TlpZ6hlj5X7/M2/jwuJsyHRBQAtKgFJhBdAQVfGVXerokrubHgRJbit1ygfMEE132d6B/PjfE7tYjkGpLlBu+FypDOB6LJ08XlOn4Npp+xgMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747249219; c=relaxed/simple;
	bh=gpm2WgB9G8LmCkmJwPUDUP5MQrVXqIUKekdGqcYZmZo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=du9xu7P5m+ia3z8Vq/PggwnQaEciu75z/rsuGtxbB47b7BEa0KqFaVcgOFPUJZO6TYEpK8hhpjIzFZJsNAZFk8rclgRb0KMqU70TVoUon+dhUoiZhLHxGeiYNReqbEqDpZT0+jHKMahZe1TNr08XtTBKW2nRRBenK5DKHCh/aVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O8kkXDzn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N7M7KfCd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O8kkXDzn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N7M7KfCd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDhx42028372;
	Wed, 14 May 2025 18:59:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=f9Jc7FKEeHBwqSJA/y/xLDYD4ajT3YGPLHjwI/nbK7g=; b=
	O8kkXDznqgAvVmBgaklD/2jel1ZEda255WGwyRyd+aNrv8cLRjQsN8djUQNJ9WNH
	e1fhujVeshH46wSdbtukfzcNKj/jNZtrjilQJFl2kkpHzlSlXllKbk4+GaHFh0+l
	jzWSap+x5j2B9CxOMvfoxDyD+5kGI7KQYx8axMqY/YYxw2pU/O2hf1r2C4vU/jBF
	whQPBeC8TWqOi96VONwogpGcJHFeJqz3u0W3B2tbI3TdJT2fbFct6MkdPRk6Lfh7
	j426u8NTYKCELtJuVV7aiP7s7pAIzt7k3wAwcNN2sbaZ+0t3C+SxyZdQSvUlE5uc
	OwsZnLlaD/jNpKoINWEbaA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcmjh63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 18:59:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EHnMP3004265;
	Wed, 14 May 2025 18:59:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2042.outbound.protection.outlook.com [104.47.58.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mrmd5wue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 18:59:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2WR8jXPD2YV5RzA1yzGimeY5ihuKAgdHgfZsJFxe7sxa8yzNYco6wheVN1n2vC9C4KlDU/grw8sskD+BxgOE+GxERbz3TMpmX8IfN3OkoJipivoQGOc/apXyqgpn4VNX3PdsnFunMA+5m3MUH2mGEsOr4ofSgH830tJKEaNPbal5JJcsQzTgvv+gRKVu6XTNvoaZpE+/KI3aR52lTrzKYBfIR75U50bISKtlUWjGJBApe7XVdoZ0Zv5y5gPe0ZY++vXe42Zm6FDARccXNwr18MfQTckqFTC3T40ZQKUnKbSsoSnjmdACw3EcmxsiEJskPOpOB3j2LskI5/uELMoiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9Jc7FKEeHBwqSJA/y/xLDYD4ajT3YGPLHjwI/nbK7g=;
 b=YPo/g7yNTPkGjnnpVqnWeRFnBVnwWJlEjYucdR7GFvUYb6hnohCivQ/3sCXtHh4reA3K2xOii/jFXBqiFGU6Dt5ZduRHu5Do0pe6zGd+SkagAVAsaZDR5W4lmlY9C4cHiYqPNUDj4v2gr8FKdz0in9ItR1YqhYfr8ztLmN4NoXWzm5kIoHFTvZGuuj88nJznaqmX8Guh3pJoxxBpTfFXyqLA6nDWNeEBL2jzfKA01uVOVfMPglAXavzciAlPDn/ZvzCSCjEKhKZYMV1Q50UypJaji7gfY3VeES6oA3NXRf/NeQwoQ7yTM520x5fTEQmSJyzXIm8HjsQB8l5oaWDfBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9Jc7FKEeHBwqSJA/y/xLDYD4ajT3YGPLHjwI/nbK7g=;
 b=N7M7KfCdpI2cdDT8UBNFSUQMrY7iu4hIDy1De6+TCdq++DyX+Pq5anuwHUhNtO4KNdvRQgkqgFFrNodEE2g/dpnx08GNJbxSrWTKf8ErHbxaLJqeAJQE4JSiXjQRC0KXzY1Y7JV4G5dxilvq9WVuAgPlYFSmOMlVEqogkJtsVbY=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ0PR10MB6352.namprd10.prod.outlook.com (2603:10b6:a03:47a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 18:59:52 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%4]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 18:59:51 +0000
Message-ID: <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>
Date: Thu, 15 May 2025 00:29:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>
References: <20250514125617.240903002@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250514125617.240903002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0238.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::34) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ0PR10MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: c22cd00a-d7d9-47bf-3277-08dd9319814f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y2JEZTFBdWJHTk8wY05qaGJkcE5DTHNVNHFnNWFhMHFubk56SnJrbnd3MmE2?=
 =?utf-8?B?RFRpNVhFdTdNRWR2TDh3RmdHanFyYmxvSTc2OEdmTitubEZuMVk5RS9FdzE2?=
 =?utf-8?B?dUpROGtQTG1IaHFWdVV3OFJUV0t0TmkyaElTdTBhN2hZNFpiMkswc1Z6cXBp?=
 =?utf-8?B?bE5aMXlzV2s1Y1JVWS80aW1vblF0dlM0Slc5KzA0TUtZVnY1STd5elBEVjBE?=
 =?utf-8?B?a01FRFNRQXVLM3NFcU9pV0JPQUR1Z2FuZmZzTFhUZTJuRW04NlVteFN0SlJQ?=
 =?utf-8?B?b0JOM2orcXErdVFnSkpUbkRocjYvOVhxN3c5OWlMd0RBSmZXTWI2QWZtSXdS?=
 =?utf-8?B?NXNuSS9oOFhOR2lYTWlqZzBwWDUydGxXY2dZWTR0Tkx0dHdhcDZkMkZmK3Jq?=
 =?utf-8?B?MGtVZW5QblljQTJoNEQwb3RWS2VmbzEyR3QyMmdkb25ZR3QvZE1saWpmdndT?=
 =?utf-8?B?cW5kOHBzdFpOWHp5NEFSMkwrN0VwUG5EY0thSWRaMVB5c0oxNUdjaENiMXVQ?=
 =?utf-8?B?ay9xYlJ1RUJkb29UazBtazFXNGs4TjZYbW5WRkY4L3Y2NDEvVTkxWU1FU3Jl?=
 =?utf-8?B?VVVFZU5NRGxDZ0N0bld0bVFWUnVyQ3FaMy9CMTRKc3UzU2NxdXpNTVBSMTYx?=
 =?utf-8?B?am1rNTB0clhOSTlSQjVhYVRKN3kxMlR0RnF6bDlIUEtiVHRGSmM1VG5zdHVm?=
 =?utf-8?B?R0o3UC9NWXRSQ2psVXh6U3ZuQ2s3M01uK0ZsaE9YTWhjSzlvNE9DOHVvVkRl?=
 =?utf-8?B?by9ncTZMblVCZnZzWmpZWCs2djZ5WWZ0YlhDUk0xbGFvMEpRSXYzekJCZzZR?=
 =?utf-8?B?UWdLSGw3dVZGMnoycTdmNWdPc1E5TlJnSytQN3dUV1hVNFRadnFNQko3S2pw?=
 =?utf-8?B?Tld1SUxGVEx6VEU5RWlqOTdJMjRKVytkTzFabGliVUVTTzdndE1EUGF0Y2Mz?=
 =?utf-8?B?VWdYeXVoUHZJQXZ3RHprNVNYN0JCUGRvWGZnSWxjZ3dzSU5PU2crblJUM3BP?=
 =?utf-8?B?aHRINEpJOElOMW54a2F4RlB1c0xxOTNTeEtwMzRFeUFvbm1XMUZMV2hnanpR?=
 =?utf-8?B?VkhkMXhyUENtNXhobEFzOTVveERpbEVkdzR2TnVIejNQQzN5aWZva240a0dO?=
 =?utf-8?B?V1h3RnZ6bkQ4TVc2SlN5Y0JhNTgvWk5ZbGJhNGsyNnZPTnU2d3R4ZHJxcUJR?=
 =?utf-8?B?UloyWHRzank0OHo0eGxoL2tDR1JZRVJ2N2hnT3NKSVpNV0syZ1NJNEcyMXU2?=
 =?utf-8?B?U0dEeHpzN3U1R3JrUEQ3cnk2Vk4vTGYwNnZ4K0YwOXpQRlpGUU5WeU53MWJB?=
 =?utf-8?B?TjNldDMxa2FXV052OVBIdG5qMHpBaXNibFJnVjJLbndCeWlIVWRFeklGbS9M?=
 =?utf-8?B?ZU1VSzFRL0xsbHlWVzZmSFBPRU1vWmprdW1kTW1uN1N4NGlOd0kxeFp5OFRW?=
 =?utf-8?B?K2N0ZzczUFF6c1Jmb1NzcG9HbEVoNUNtRnQ2dTc3VWl0UjVRc3hXZDRpdW1x?=
 =?utf-8?B?VTBSUUY4amlQYk81QUlxZ0pYUjB2RmxLa0tXNlVtRzc2L2pmbVhaYUFHWmlk?=
 =?utf-8?B?ckJWeURua3EzNkZnbkhpY2RxK2hvUjgrdGhzOVZwRHZkckZhWi83S0RWcmpj?=
 =?utf-8?B?UWdmdHFvT0JkOXNqUitjOUphaEwvS3JVQWVwVUU2dkpjcm5xNTB3bVpEemQ5?=
 =?utf-8?B?TUtGNkxrK3pVS1JCbjY5YUF3aFdlVCtzZWdQR0g4a1EvVTFqcFJpVWVLOEdB?=
 =?utf-8?B?TVpRdnJIVnorNC9TMGRtUWhmd1ZyYkxydExTbjNmL0R0cEVFM3AyMWRkaHZx?=
 =?utf-8?B?Mi9OY2hianhQZWU2RWpkNmkvZEJyaXpuMDZtVU9NMXg3cUgvV0t1Rm13SEp2?=
 =?utf-8?B?cHY2YUlHU1QvS2g5eUdYelRZbGo2by9Vam5GaGREbHU1czl5UStheWZTNmlD?=
 =?utf-8?Q?PTSSKC6jNgI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDFJNGhtZnFadkZQNURGV09SN2JxdjNJSHplU3NWVjRRQm03YjMyd1NHWnZH?=
 =?utf-8?B?bVBNL0ZtSTkvY1k2SmVuR2dVaDdhUGVrOVVaWndGWTNWV0MwWlNPWVdKdVly?=
 =?utf-8?B?RWovNUV1QWNzZjdNQitTODE5WmJzSnM4d1NYSmM4cXhhTWViQ3MzRGdHN1A3?=
 =?utf-8?B?MVlRT2dVZFBMQURqbk53Q2V6Qkd3SmpsMW5QK1ArTjBFdUJNV1BQT05aK29O?=
 =?utf-8?B?NUtuT3FoNlNqdmlCM2ZMTW54ZFUyVVdTcWZ3S3dMK3JtV3BseFpmUlQ4cWtG?=
 =?utf-8?B?L1FRTWk1Wmh4WmFDcDZSWG4rSXpaNmR3UE9xZE53dnRMdnFiSjhkLzUvOVpV?=
 =?utf-8?B?c1c0L1A2RjEzQXVuNUFJNVF3ZWlTZWhLSUhwWERReG0rWnlpQTc5VkkyNmx5?=
 =?utf-8?B?a3htTFFtakIyWjVBVmMyU2pESVVncUNNY0xDayt6OHY4REkrT1ZMaGs5bUNR?=
 =?utf-8?B?OU9lcGh4SmVQQVFqR0gzUWRRWlQ1UlJuUnF3T2k0Y1FpbDQ3YUNSQVg0Mmtn?=
 =?utf-8?B?YzROQnNrZXllRmZodWpFaU9KNUtPTElyTDQ1U2ZZdVBLUUlnZ1dlN1ErRkVX?=
 =?utf-8?B?Wkk0clpuZyt2R1d2UzlFS29idGltZjhTWGozNkkrV1lBelphTUJuRHFDRDh3?=
 =?utf-8?B?RmN3cVdzcytiV1lPS0ZTOTRpWWV4dXN1SEZSa0VrcWxKamRYOXJCMVV3Nm43?=
 =?utf-8?B?ckZFSXpia3NDRmJTQWh6Q2xLbXU1MmJ5bkF5aE43SzNwQ1NaR1ZSdDM0dWtK?=
 =?utf-8?B?WjFQbC9GbDJpL3JCZE5Xa000SlRFMzFnTUw5eHd4eTY3Zks4RGRWRzI3MWNH?=
 =?utf-8?B?WW55QVZ2c3FXRzE1cHo1RzhXNWZTc25mcFZHMnQ1dFVZMmZTMi8yZ2tEeXNG?=
 =?utf-8?B?RDlsQVNsL3hzVTRpQnM3dU12cUNJSDg4NGtTYWZYZzZtMi9VY1NJa2NTY0Jh?=
 =?utf-8?B?eDY0YzJsYVdUck5ZMWxQRnNsMkdlclpRWXU4dmNMTG9zdE9kRjZaU0N3OE96?=
 =?utf-8?B?U2VwdTB2WWZ1MitIV3ZiN2FQTGdEeVgvMWJKZkI5Z0VDcmcxYmQ0NUo3ajZm?=
 =?utf-8?B?V2MvcW9UdVE0NkU5cXdNSFpnS3pWeVhrOFhyeFMvdWtNRU9ZVUVsN2QyL3RL?=
 =?utf-8?B?Q1JsV2dCeFl3bk12TkJiRUlYY1NWNy85L2RnUThDaDN6ZTRlbHhsSmU2eTBm?=
 =?utf-8?B?RlRKbWRZc24xdHhUS3hiRVUyNTdMcWVoR3VEZ1BWaStiWm5xMVRwOWlWb3lJ?=
 =?utf-8?B?NEhDYkF6REI1RHFjZlZpUGl1Qjc1QkR5ZU5QWjFCZlJHTURvRjdKL2xKbDJv?=
 =?utf-8?B?YjZLZ2FTREsrWXl6RW5jQlgrWlRRMFBYNlJHb25YYzZVVDhMNUp0ejFnNmww?=
 =?utf-8?B?azBUbnBqRkhzb2VZRlVieWM4Ymt3b0V2bXBsb3ZxUXhGTzdPK1dFNklZOWJY?=
 =?utf-8?B?NGFxY0RydlNEcjJFa3BrcnJDd2FTNE9scGM4TVdDbUdNeVh3OUxRU0xpTGUv?=
 =?utf-8?B?STFleHI4VlBYa013cFlXY0tTMVF4RlNna085MEErSmU4M21WeUlvZjk0a3VJ?=
 =?utf-8?B?RGlxVXNGRmVsbmthZjNWeEhpVU5DY290L2VMZEhqdzVvL2kzS1gxd05WTmNS?=
 =?utf-8?B?U24xQ2pha202c2VvSnQ2ZDU2Q1NlYjJ3OENTMGhVZHRkT2w0dS9HMVc5ZDgv?=
 =?utf-8?B?cGd4dUczN01qdXVDY0phM2t0a05vYktGT1pXZituUURsZGZNQ08xUWdDc3dS?=
 =?utf-8?B?ZmpoZ2JDaGU3R1AwS1RCU2kxYzdjQ2E1Q3c5UlpjYjhxUWpBaUhJZnNEOURK?=
 =?utf-8?B?S3pzU2Y3UU83ZDN0Zzg3T1hjTm0ydzlNc1pYc3l1eGovaTB2YXpoTERTbzcr?=
 =?utf-8?B?bVdRVFRJdG9ySTNteUc3ZHlQaUt4MkZLVXVvQjNWRXN5OXJNcnlRWDM0NEhX?=
 =?utf-8?B?MG1Ienk2WjNjQXVjZHBhbDVFTFYxcFVhNzU4SGRGMG5ZSjFhd1M2YnlwYXQ1?=
 =?utf-8?B?SmloNGZ4NWo3Ynk1L3o2bVlRZExMUTdaNkVYNDRwOWIwSDNaUjNoTjNmSjFY?=
 =?utf-8?B?YWREV0grK1J3Rm9Jdm5SbkpvelhqYTlOSjdHdGFsZlRLSnlDYkppdVJxL1dv?=
 =?utf-8?B?S2dtQzNmOGIxSHhSK05zbUtBL3lUcERUQ2hZejlUMERLeG1sRlI2U2ZGbThq?=
 =?utf-8?Q?x476qjV6ByBhPbqDyMY+CGA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sWglg74ELcPftbj18WduH4EOAGITRuPQ6CrnAmLSJUAI3/XXbMMpYwHDsaiLymklbg7M7vJeQwzRXLvWTy+MF9GuNx9aEP1rtMeGR9UpTKwyK+6cr8Q/ZpbYM/N8/EeLoFAenQ9Gl12m/OEUsM5SCVTN6REZvYV5T9WPrx1NX6lTKW7lCroCF50lc+XVMxV436ItmIwFHRi5GBfMd0yWWYpyBSCZL4gr5s+9r8jkI7nlSw3y5vf26XfgiC3lkop/JBnKUB/Ry4OXNKH00yf/6ygnC8o79Kygyute/2/9f9aqe8C6Ud5BBMN8RHt247uP8FvW0ravQdJhjLNfP4VpOpI38Mep4xkmGscwb16cW+P/ApVYiV2+RMfRejVNu2ii/KtyBqhgylaBcm/sjDEek/7VCydkVqB7xrMpS18c59T6E0a9i+7pEPaJTCBtm8PXrSOnF7ExRLNPo3j3UtrRlURyd2FlfiwHs/MzahJMN3P2d8WodSRVAZK9Vj08TAXB1cD96BWlywGnOPdOf3Nhd8XZeeJV/WqlMlx2I5BFUvaFrBaYA0JQS2biJHNjI+fNk0Sa5qtkl7MUVUm9dzxb9qJsc82nXcUrO/GjjFGs2g8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c22cd00a-d7d9-47bf-3277-08dd9319814f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 18:59:51.3202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IbsqmaL+E1nT9nC6sJrdM9HpQ+qRLfB+7YiVwYNooBiHqGlpQssSiFPQZzBDnkMDDu8P5TBAxmcMnpX65CZxJryqAsYsJsu0BvcmBF16fFRFiAw+u9TKRLANvl3Hm9eV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6352
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140173
X-Proofpoint-ORIG-GUID: 5OThCvOUXuxWXfQC3TniHDOOM2VFr_iV
X-Authority-Analysis: v=2.4 cv=f+RIBPyM c=1 sm=1 tr=0 ts=6824e82b cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=SquU6FTJUu4YZNhsXOIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE3MyBTYWx0ZWRfX4t17H+oTOT7a rpT05CG2wG4n8bLnawBJnO3s8hQ5r9LbkBrk7XPaPu46+gINTzqEAjHlHKMN8OQLPn7QdV4CXeg o/ianQ1WMGofj90UYCtSdV2uvYI9YRVe13REvmKT7TYvz3Ly7YNnMpugMqGC24Fu2jMFjyPtv6l
 /wVj95oDeQQPbTjq6ifIVq3gP4sm+ZpmUVPq/QhstCRcAdRsNJ6oXV80bgFuIWefGtlD6u43cir gUThPgWFQgofds5gkGPQ9eGx4dPEEPwnMHYQlamZlI/Jd7bBS1MmLbr2/qx/zYhmG5cFQogTReU 4lXG9zh+DSescS6RgDIw2mjIzwveWfus/kDg0s0bzL7gTf/4ESLfjs5LeJi9c+hCcZ0U123G83c
 iFhCgWcwIeS5ajBzrX/NJ7LPBp13QPRqzGB2AlVOvWPjq46T3roKg/TcQVuRdERmoNjTSTlp
X-Proofpoint-GUID: 5OThCvOUXuxWXfQC3TniHDOOM2VFr_iV

Hi Greg,
On 14/05/25 18:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.

ld: vmlinux.o: in function `patch_retpoline':
alternative.c:(.text+0x3b6f1): undefined reference to `module_alloc'
make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1

We see this build error in 6.6.91-rc2 tag.

This is similar error to what Pavel reported.

Thanks,
Harshit
