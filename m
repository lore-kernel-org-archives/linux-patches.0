Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2083.outbound.protection.outlook.com [40.107.101.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC6A22DFAD
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744993080; cv=fail; b=WTh/gfibbHxNPQNvBjvDG0jRD6pqybcvvDo6r3QPXl8Z3WLWhpRixlv564XK1yvkgSru/k1T18yGvRQpt1NrVBW0vji+NnJQeSWvUsbYvnw2uB/Vq7jJxsUDR8TOl8rJPyxsfBL86IGP9b5b+h4KzA2X7j9kOXXXpAUjFW9d4Dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744993080; c=relaxed/simple;
	bh=JFjXW56ZqCBly1PIQ8tofVbY7lSHK4s7PFsLE5vpJKM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ay9LbAxlOYUXIaPs6kn/QkMcA6XYlJNWa2PzFnB84bGuJVV+BbWX1zgvlsH3ct49SICe9QWWzUsP0WMdCGm688dwNnd6LaoBh31y5bNTsbRHuMBlNQmfGMXFkdNV9ldNC39ad/N7kJjsmaCKYoECscwQ2DE+U+Vkjsg4lwVPKf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V9gnn0/l; arc=fail smtp.client-ip=40.107.101.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V9gnn0/l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zHLvbqPxa0x27IgAcd0iKDaqVK7UWHUdUl24htSJwG9zJFKRfjbVLEWV6lgEUk85fsoBVzoH7qRJNqKmsxaCL4aqLRmGpL79xm0G91aKlLPRE86s7j5tL+vm9iHl+oFVYSc1i9a54scMdNdKb+0WAGwgvcL5MD8SnkLvqhkJSmmYoN8rQGUan9FY30CUpN4L/wuqdlDoYJa+mYS98F/Z+60+X3vfewnAHdJ8nXQWXrK9m1TZq3wDK4vP4bd2ILwQq3eB5V2k27ZlVcjY2c/WgGBCO4kZX/gSYnd0pspjKf5t6s1C1Bf/6/SY/m9JGyR2q2LO7f45VaPKdO9SBKhLyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mUnxEhRsxGq60xIqJHc73DRKrwcl/4WGtIKxmgwXlM=;
 b=SYZGU+fyIiu8eRf7mPj0FAJEInYnNChgpJE1H2UKpqim7NSjjZgZAc6erTMd1LF3U55RNFTcgunnRy+HIV0ClqQ6PxMh0sk6nPBCqwoGkNPNj2JDknIwfN3D8BO5bJPm96fh3ah2Ol09lLSj3TQb7qcK7RQLPbQ2KHwgoiEni37Ho/8iLpNV+nfuIq3Eil6d5hSXREU5y4tsYcCz0/JUmCwK6c77ijpyF9FBngWAp88smxZEO+4E78iyS1ZyBG4YDqM7ZHmSYQKH2nyyeZfK3NJ8glLh9yhapQLZAz+UNRQxWBZcrPOH5avOXAUUhVFHrkCDyIbcZUc+lPI3VEycdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mUnxEhRsxGq60xIqJHc73DRKrwcl/4WGtIKxmgwXlM=;
 b=V9gnn0/lVUuFUmeqwqvb2CW+831PzJL19zDu1hFf8cTgN4Xbl75bnRaf+MZFv1+NH4AfNt1YeZ+VFQYHnsm0KkAXiq0ioO9Mty2LX9u/PkIN3xY4oFqsDuMhmkjhNEv6hhcA17YYnGcjIsjKhIBNuKmF6bKVVJUKFoN9Wm5zfdXIz1M7lzmmNr/4l5/2kJYH2W5hmZLYOYhf4+3CsfpYkmiLIJklB9+UxRyY/ZCCehS8EpDU5EcpWyxWR2ZqksEktp1fszLJspOKxhGtfhiJzI97yVmpsLgrOfNl6ptinXewSs+8xs4WDXxLwN9DfrmgoT/T02WGC/JcXl4GHoJoFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.31; Fri, 18 Apr
 2025 16:17:56 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8655.022; Fri, 18 Apr 2025
 16:17:55 +0000
Message-ID: <cc8c8629-904a-436e-b634-5607cedd00e9@nvidia.com>
Date: Fri, 18 Apr 2025 17:17:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/392] 6.12.24-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250418110359.237869758@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20250418110359.237869758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0192.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::17) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a193a75-5e27-4407-9f02-08dd7e9493b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bm12b3NvZ0FjNitoYWptTjdwRDNLVDI0MlpyMkNKYWVoWnRUa2dyMmhDUG15?=
 =?utf-8?B?c000aFJ3UXF2NGxtUHk4NjNxN2hvME9ZZDdMRm0rZ0N3S2FGcC9XSHlGVmY5?=
 =?utf-8?B?TlBXa1I4RHRIK1l6OW9hRVl5Q3ZyUXU1QlpoOWtuZ2d3RFRGcUJESWVnYjk4?=
 =?utf-8?B?a3R3OUhIcU5WcDk2M0VsamJEN0NsQ1g5VHFiN0U5UUNwMkphT2dVQ1U3a1FN?=
 =?utf-8?B?Vm1TSVlTbGo4eGhkNmNZcXNxZytXRmVTL0V5aUsxWXlDSzlJMEM4dGVTZEVH?=
 =?utf-8?B?U1hnMUVFbWZndjkvR1VuUkdRRDdaM0xuaGxPVDUwUSs1ZDg0eXJvSnZENXRQ?=
 =?utf-8?B?amtPaGtISXJ5dXI5RXdOVFUxSngxSlhBN1lQLzFUK2pubzFuNWJ1alVBeVJP?=
 =?utf-8?B?eVBIbEVkaGF3aWRSWjY0SXVKd3IvWmpFcWtNUXd3bE9qTzV1U2Z0UENrTUdk?=
 =?utf-8?B?SjBTUUcrdjVsMnlPbko4SnlqMzFzVnVISVZYcTVSQWQ3bWlRRU1zZDIrdmVj?=
 =?utf-8?B?ZlM4ZG5UYmZiL2JTL053SDN6SjA3MzNQdnFHV2ltQWM0U1h1RVJ2R3lYK2Vm?=
 =?utf-8?B?N3g4N3pJMG5oRnNqQllHdUlGa0pWc1BnRndpOWtxeXh4WGRhb1UwZUJhVFBw?=
 =?utf-8?B?OHlVajkxcFZKYnFTd3JpdTlBd2djZUthSDhlanFIVUEvajluZTAvQUEvY0FN?=
 =?utf-8?B?Y3g3ai9xT081YUltaU5STlc5N1dVK3VRaEVRK29DOEZBV1oyKzY1QWdnUzN6?=
 =?utf-8?B?TllaSTJrMXlUaEZXVVFVdHpYQnNQUDJQalQ1MkpoL2RVY3Bna3A4Y3RMaExO?=
 =?utf-8?B?RDdMMC9rOXJGekNzWW1wT20yWE03L0oxUWc5UHF2anoxbGxSWDRkTmhvbk81?=
 =?utf-8?B?SGFibCs1UWoxc3dBMlFoRGpZWEJ3bmxzZEdqR242QWZzM0ppTmdrZHdWLzJm?=
 =?utf-8?B?VU01eEhDeFg0bW10VkFTcjhpZGtDZW1jdWlYckhzTzlhM29BKzI0eTYvMXNB?=
 =?utf-8?B?UHNlVkEwWXFrMzNYVnRlbUl4cUQvNjFwOFRlSlFNTHM3OTlWODBmaElUUmxh?=
 =?utf-8?B?cEtaNnh1MkdSdUk1NnZ6bWxicHJiR3JuQWZEVUVZVXJIeDFlV1UwS0NqMzk4?=
 =?utf-8?B?Z3JzM1g5R2E0dTd5ZnFmOVpkNW9FTW16b2lyYUJqcnNzV0JEaXpKMmVqUjVC?=
 =?utf-8?B?dzRMQzVSbTIrT0JLUHpnMVo2WjY5cWI1cmRTV0RoaXRFOVNGNXZEODVEVi9X?=
 =?utf-8?B?dFdaUmtab01YT0tIT0xlMHNSblBCS1JzVUtIbi9jbkJEVFpKQStkNUpKM1dN?=
 =?utf-8?B?UTI2aFJyaFJGMkJ4SStFQTlxZlQ2TzFMSjQ3ZFQra1F2U2JHM0U3cEkyOGFM?=
 =?utf-8?B?NmtaWjh2S2ZTeUdEV0pNcUZhWVNSUGJxdGQyVk45NVNSZEhncGN1REJMUyt4?=
 =?utf-8?B?cW8zWWQxQnFOWUx4WFREUHNuNHRrM1B0Nmp3OWdwNXlUZnZ6YzIvRXBDREtF?=
 =?utf-8?B?WEI2Smxpem9UMlNhdU1LOWV4QTl2MVVnSVFoZ0tXWVJEbUc0dWl3NGwydURn?=
 =?utf-8?B?NmtRTEpLU1JGVGsrWEhsdTI3Z1RXZDBndmt0M2ZrMzF3U0VOaUZnejRPUjZE?=
 =?utf-8?B?eU1UMGZ2RDlTQU56UTM5b2hzTTNDOE1iV04yTk9NSFpSVitheFd4QU14K2Ux?=
 =?utf-8?B?eHZRRDJnUUFTRWQ3WW1RRnE3RTdGNHNiR3pBTzBSR20vSTg1cFdaZUQ1Nlgx?=
 =?utf-8?B?Nm4zdm5QM1BicEpuY242RmRsMXFVNTQzNGo3RFJaWmlKUmdQalN2Z2VPV2k3?=
 =?utf-8?B?L1ZYSTVtUTFmd0ZnQkN1cjlCbFY2emJBby9FT2RqYXI2ekpQYmdIOVJWSFpM?=
 =?utf-8?B?UjlXRlpta1NGSCttR1M4bmxEdkoyaEI1SGRCQ0lqcG1LdCtKazVhdFVZZEVq?=
 =?utf-8?Q?5a7xqQulCh0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFRFcnMva2w4MjJxNHBnVmttUitWN3ExdUFtUWY3eTVBb0E4UWREQnE4NERX?=
 =?utf-8?B?VzVMY2ZFcGxyTll3cUt3SXBGTU9uV2ZEVVcvbHZRNDFWaU5VeE80Z1IzTU5a?=
 =?utf-8?B?N1NvZHdNT2xGcUJ6TWhYUXh2NmEwZ294OWtJZUc0YUV3b1d2bzhJbUw4Z2tT?=
 =?utf-8?B?WlB3WlVQWjJTMXRPRERYdXhCalJPbjhLKzJLd2lRUk1UOFRmYmZEdm5wR3Q3?=
 =?utf-8?B?cXBrUWp0NVJab0ZYYUFKY01BZjBaWWF4QmRVSkI1MitJVWxPQ1FkZWYrWTFH?=
 =?utf-8?B?b0g3YUpWTkUvU0ZCT2Jqa0c5aXRQQmJaUkZpWmxuVkU5eUVRcGJBVWxBelA2?=
 =?utf-8?B?ejhoYUU0anZmNm5Ib1cwTkhxVllKMnUzVFg4Ymp2emhsdEZHa2pLYnc2TWFi?=
 =?utf-8?B?TWVENE5aem41ZG9PaGtabUVtSlBXb3BXRzlXZy8rNWtmQjhsWlJqSEtoV1l5?=
 =?utf-8?B?Nk9vc25PNlZCUGcvSW0vTFFpYmRUeHJTd0VzeFRGMmZZbVZzN3l0UkM0dXZV?=
 =?utf-8?B?dkx1R1NHYy9mMS9BLzBjU3EvWG8zK2o3c1JHcTJlZWIzZjhkakZZNUFZUWtt?=
 =?utf-8?B?SHh5M29pUXV4TmFuZzVWYjBjZkJuTWdBWThTVDhQaE5uTkNWbEFEYUpwZ2s0?=
 =?utf-8?B?TUZRSDNQUU1GRjlka29ZSGp2RDA0K1Y4cS9XaXJ3dUpRRUNQY0t4VFArUkQw?=
 =?utf-8?B?RlpKS3o3Y0JtcG4xL3RSVHJHWkhLRGxWUlN3YUp5MTBBU2p4OStoeGFEdjht?=
 =?utf-8?B?bjM2T3hxU3Q5U1duVDE0djlIdllHbU56MzY4RVFhbVBJZlJpNXpiUjc4NU9v?=
 =?utf-8?B?djZrS2lnV1IxbnEvZWNwZ3B6bU1IaUJkOU4zakxZVjJsSDlQdzZMSnFacVhs?=
 =?utf-8?B?WWlsNU9oMUlhazc2cWJWQ3FVVkg2bzd2Vjd3Ylp4cjUxaCtQdWo2M285dXRr?=
 =?utf-8?B?ZGYzZGxjcUpvalJwR09idjNLR2NSd09YOWJVWlN6cE9menZCSklMSCt3czRh?=
 =?utf-8?B?NnozVHBPV0t6cGNRakJnenZoRXNRRnRERUVVeUFoeGlGQ2plekdiTm1Ha1dV?=
 =?utf-8?B?M25VcEVqV3RaSzVoVWFoMDFiY1pwK2VJN3BpMC9YbGRjbnJwT2N6RWdsb1lP?=
 =?utf-8?B?Nnd2WmYwNUY4NlUzME9IWG9YbzdRb0llYm12eENBZUJoLzNqRVc4YmloUVNN?=
 =?utf-8?B?dnk5MmhickJJcDlUM3JpaU4rdHl5Yi9aZm5vRzA4aHFFRFVVam9janZ4MFRy?=
 =?utf-8?B?MnlPc1EzQ0cva0RXZk0xSGk5c2JkTzhZY2VjOGp5czRpSXF4Q1JDVjY5dFlF?=
 =?utf-8?B?aFRDT0tYL2JzT3hpSGtVRnF1U05YeFM3MDBER1lrck83RnVGdGpXdlpPdG9v?=
 =?utf-8?B?NTJaTElYWVJHcEdzVmJ0TUZ3RGtJbWhhZWN2akZXK1RhNUtCMlBlNmV4Nmx6?=
 =?utf-8?B?WFYvYXM0dzJQU0lSRzdHbVNJdmZsT1RyazNJaFUzN091VGJBV0MvK0syQnU3?=
 =?utf-8?B?RjRQelpjNEV4WDZkY2ZydDJHQ0J6SEliallYcFdNdmZZa0ovU3NCNkxuTFI0?=
 =?utf-8?B?WFdJTlFMRnUrOEFSbSszazViZlNHQVFlMVZFMDVqTlliQXdoQXZITFN1d0Jm?=
 =?utf-8?B?Y2xMdFFSbGYxSVdJLzNIVmx4SXlCb05uVGZLT3dSQ0dpRmV3M2owdEhMYjR5?=
 =?utf-8?B?U3lzYkdNT0tjMFh4aW1wd3lyUEs5cUp4UjRoTkJ6Ykx0UHFsNGN5Y1RGRFRW?=
 =?utf-8?B?d1IxbHVOZXFkU1pWQmpoR3lEOW9sK3lBaiswdmlJejZpV0pmdlZTSC9wYjR4?=
 =?utf-8?B?MXZQem1tQmk1Um9kOXEzTHlaVDJMckZSVUpPZ2FCZy9tVitUdlpNZW5PTWM1?=
 =?utf-8?B?eDd2Y1N2ZEk1VVU3MjRUOXp6dytNYU9pN2x1a0psOUJPbGozdE51eFdUWTVU?=
 =?utf-8?B?bWFIcDF1KzAyaWRMdDhvek11WlNub1VwRjNGTzR2QmRZZ2hDTFp5VFRKUTVl?=
 =?utf-8?B?VGhCUTJlWnhjSTJpZi95bVhQMW1YTnZCbXhjeVd2T09BVWp0cHY4S1E2amN6?=
 =?utf-8?B?MjBjVGNhMUxoMEpvVzNIVCtsK0hLK0d5ZHdQQ1IxYkVhbW0wazY0T1VjS1Zw?=
 =?utf-8?Q?/XKDQGclXSXRO2b8x1MbACdHl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a193a75-5e27-4407-9f02-08dd7e9493b5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 16:17:55.7710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vVhm9jjaxiajYDU3ijvNHUZNclwdiOq2RxXc5TgzArODR7pb5oZNUBdqWHkY4t/YpdmmlOGGFU3AAW/2b4GoMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624


On 18/04/2025 12:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 20 Apr 2025 11:02:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.24-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.14:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     116 tests:	115 pass, 1 fail

Linux version:	6.14.3-rc2-gfc253f3d7070
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra210-p3450-0000,
                 tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic

