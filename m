Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8086E2C21F7
	for <patches@lists.linux.dev>; Fri, 15 Aug 2025 06:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755240598; cv=fail; b=OzlvFlQWdd859uVhEI9yzTb+ITNygSKmgMTPUPLP4j0be0X9GMu+VNRKjgBDCQ7Le/rPjX+CfpE8PI+Or21DPRCQnSft0Xw3h0FMUJ6Dm+bjk197B2jXLtB4MtK/dSQr6e6iXpCcQzfTU831B4VLNjFExgtG1Isws7mDbeJNJbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755240598; c=relaxed/simple;
	bh=9zThknvzkWJzDSe9Q2Q8GOVNrbrTox5M+Op7MKWjazo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XAv6g6uGrGKcH3slIwxjRakPIlSCCLIsu4KwOnOUFgxbygO9xPZYOdUZZkzE3kickVfCe0UMncmkH8/Y68IsW4zax+dAlHaWifsnHlIiU9l0eWcocd4vPaaNpMrS415s/UDDg4Zf8w5iDFTZXWshibqWXEK/rGYy4BVYOWx5QIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MF0JAYAN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hqd5hKYu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MF0JAYAN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hqd5hKYu"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EHfqwW011976;
	Fri, 15 Aug 2025 06:49:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IaezOsUKOFwGxtULvju15SCGeDz66sSSTGD4ifLb3mY=; b=
	MF0JAYANSR0ws7LkWfhy4L+TC3N+dF1fUa/UmfuhHmLt799StZ5WGOlNwTZsUKGe
	WuI0yGyfobbtj/ZWZuOF0m5Bjf2dIXN9Fr5YssHnDSoDV7HphF5NJKtXckd1hDGp
	8wq4fpD8ROg0NvZAmplcpb/uFEFnB/WudNdo/bT3pKFeoB8QipKr2Cd2NUID6Zc5
	8OTKkXe5xVKMkZmCCM4CXSqztxHi9Dca/mcWM4yFaNaN3t1ObdVevB7qKj+u+h0f
	9yE4CGXS7IUQdCdd+lTYxXn8rr1mPPtFo6RYUIdLe7gu3J/W6PScJkqSWwU+zN64
	SCsJT6a9dpc5tDOSeV/bag==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4kgd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 06:49:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F4e2DF017619;
	Fri, 15 Aug 2025 06:49:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdnym2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 06:49:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Quw3onO+FMgs6BLogf0dhoWWPQKCJ5hjYvTI1jbyFEpRhOBxzzBzfAeIOGE/BjDO/uRmlTN2cgVfFMj7PrNZrXfUKKi3IXmuRUezLG/TrAicyC1NtqRoDK3rzbiTEGcZLBHaaZS4lbqiKxKiq0d+7kqkBSUsSJJ+PHo52yvPvbWXBFfZAQNoE7oQiKEvB3co/IzEM/QrJkH/HfIpdazCejxZecIz6t7uaQTYrCAta1mdjRzoBpSYcIu0Dve374uIPTmy+4S+emiNZTNpC/uXNBGWjpzoKBezrQUFcitbXOv4hbDuRzLBRN2uP/LGyprzqvV1BgA8OjsPVM9DZjED7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaezOsUKOFwGxtULvju15SCGeDz66sSSTGD4ifLb3mY=;
 b=B94eZZgQCy7DUYnl3lEeW3HsjIK4peSUWg/5By3NIlL2Y9gZgfaw6D5DMVix6o2GNTJpm6Rd83n8NpKlvdgjuyZrQd/F35cItwT1yznNNkwsCbecGPTK9qOc9c3B5OQ8cKNHlGnSUOd3lLTTHYruvQjgTksQSm79GNwx3aYlvOc8xdukkPhIZO98MQMuiQ8ViqaVpcK7b7o3DJwTVg16PguVX1QRprKiMqAMV4QROY+PhZG7pSodIZs7TNZ2jJDfDvnqXLwAab3JM8cAkGGg2pcEJ6JXNAm2gURxmUC5F8gXxBYeabkT9xbpmftz8Ld5xcy2Y0qbI3WuBoLTfgy5iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaezOsUKOFwGxtULvju15SCGeDz66sSSTGD4ifLb3mY=;
 b=Hqd5hKYu65iyAajHh5oeBBzAz3kZEsCjjftpiRVUp4Tar6WA53WP3qMygwgouyolTifFxPmq5IEKf1ChETLWJ6kkdF6z1nNdDh2ZEfnnKWm+yB3B8x/rkwJAp901THtqEP5Tg0wAJgbUr/Jr5Ou+jKltkDrcyuaeIMvSfctaUG0=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by BY5PR10MB4385.namprd10.prod.outlook.com (2603:10b6:a03:20a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.24; Fri, 15 Aug
 2025 06:49:24 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9009.024; Fri, 15 Aug 2025
 06:49:24 +0000
Message-ID: <4e5f2d2e-2b00-4594-9a2e-1b151f3e4183@oracle.com>
Date: Fri, 15 Aug 2025 12:19:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250812173014.736537091@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0095.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::17) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|BY5PR10MB4385:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e407efc-bfff-4997-63bc-08dddbc7ded4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVhqTXJtTDNRNmZtUUZjSkEyQkFlVGgrWFNvZEZCM3VKampZemllczlrSm5s?=
 =?utf-8?B?VXFCblZMTGIyTnhkY0N6Rll2dkk0UjJ3NlhIaHBWY0pFVjdoRmlrNHFQV1Yv?=
 =?utf-8?B?TjBLdkhrMEhUVGxka2tFRm54RERXaVpDa2FrMWx2cjd1ZDQzQXdnSUFtcXVO?=
 =?utf-8?B?SlUybWpWNFVvUEpQSHJKWmlKbCtDay9kcGlUM0djWjFyYkFlQ3dRa1BHT216?=
 =?utf-8?B?SU1hYU13TDk2Nlo3eU91aWFFZzYwbVU1bXI5dlZzeWVQb1MzRUx0TTg4dFJL?=
 =?utf-8?B?ZGwveXhhQ2hYWGpsYUFHeURvWkh5UmVjVzMwc0M3ZTNHdHNHNUFFWkk4YXgz?=
 =?utf-8?B?bWZUTE5qZGxPbzgyM1dDd1JOSENyVktIN2NETkgyaWdmcTRnN28vQWxlR083?=
 =?utf-8?B?Nm9wUDVZR1BXeVBRN25zNmlPVzRYMzBwL0lJY2F0L3Y3TmI1UHF3SWdFTnlH?=
 =?utf-8?B?SEFXTzlWSkw1RmczNytZb0RGZ3M1UjNFV3ZRbGlEL2FHR2JwT0JHSC9ydXBQ?=
 =?utf-8?B?SFduRE1PNEhxRUgrZjRVMW1tMFlhNUJxVnZQUlBBR3J1MXFZRkxkWEN0a1hK?=
 =?utf-8?B?ekY2dnlhT2l4YjZIUkZyTGo5MWg5OU5YdU4xU0lzZ1crMlh5MzZnK2ZKNWRW?=
 =?utf-8?B?N1RIdGFBOWJiTVRFNFBobWd6bzZFdUptekxwcEtBYnZwTzc2Q0FPUGhzRTE2?=
 =?utf-8?B?NEFIb2lWa2N2RW5WZkRjQVBvYUl5cHFSazVMWEVUbXhRMTVSVk1hS1d1Y0pX?=
 =?utf-8?B?OC9GY3MyOEc2dDd0TDR1MGMwT2VGTUZVbUVvYTVWQUdTNzN6dXN0ZURoRVlu?=
 =?utf-8?B?Rlo0cTFqc0RyNUhGWlRLWHVnRENwL2xTWk9QeHRhaE1lNE9JRlRsOG1HQUtR?=
 =?utf-8?B?clQvWGlPaFBma0VycS9YUFQyNzBwS1BWOVFicVlwNVV2S0pPVWZkbCswUTNC?=
 =?utf-8?B?Q3lsY0J5QWJKT3JjZTFPNzkxVnNsdEQ2d2cwZnNsc3V2a0pXM0IzVFFaSUt3?=
 =?utf-8?B?UXRwSGRHbHByZEFiZkxwMjRQM0paQ0l6NXloSTlVK0JHYW9mSlB1ajhFbnk3?=
 =?utf-8?B?bExrQ1hNZWplbjVPSGFGRXFIeEg5T1ZnR1N2QVNqM016TXk2cG5QdnJMWGNs?=
 =?utf-8?B?eGkwb1JjUC9jU1AwSklhbWw5TVE5cldlTzhMOFlONWpQQ1RzbkZ2UExHQVI3?=
 =?utf-8?B?VXIxdTdQUkRsZ3VlYWNUYlBLdmliYmJBTjVwS2I5bnZwalVZVDFKUnlSRzZS?=
 =?utf-8?B?Qk8yY2d6VndVWldaSklVWjlxeTNJTVdVQ1hYcFpESEcraHRxTmQ1N3BkWUgz?=
 =?utf-8?B?cDlDVFVnR2g0MFk1YnBYOVlGY29kejN0a040S1lJdzdudklKdFVwTlRGbS9u?=
 =?utf-8?B?dnI2dnRuUkJSYXBOL0Nrdkd0bmNBZk14S1I2cm5ZNkdsZE5JckxkTTh1ZFV5?=
 =?utf-8?B?bm1mTGVWRUIrZ0JhV1pqWEZ2clZTeXhWZm1rZEVLS0lOTWU5UzU2RUpiaURx?=
 =?utf-8?B?alZIdG13dVdnTCtvTTd5eU1aWTNtZDNxL0xyM214ejhGUHFRaTdiMmxmRGZD?=
 =?utf-8?B?T1VpVUpyK2FpaHlTSVlGYjFQaEREWk1WZG5CWEZBRzAvR2I0eGpTbDJFRUpY?=
 =?utf-8?B?Ym9EaWpsY3htY1JqM0Q3ZlloQkphQXJsc1g5SDlQcWREc1l4bWRCdXpJckVN?=
 =?utf-8?B?T2tjZ2h3eXROeDBzZGFFMU9PNDI2U3RWZGxlTnVRT3pVNU5qRVVaRHZGcE9k?=
 =?utf-8?B?NTNnREx3UnhkWUZiNmFRYkRhQlgraW85eGRrTXJGa1k5ejE2RTB3ajJBR1Zx?=
 =?utf-8?B?a0owN09lR0xJVEo1aXdJd0I0Z092YldOK20yOUozbUFvRUVNVG85Y2J2OUY3?=
 =?utf-8?B?cXYzTkovdHJkaWxIbzRKY3cyQVFlYW1hbkk2ZnJZZThzMExBUVdqZDB6dTZu?=
 =?utf-8?Q?5RcsQupXm28=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXZvYmFISEZWQnFPTUt4aE1BODBwTUlZWGFDcFNLTXN6RnBxdlo5NmZ0bE52?=
 =?utf-8?B?cGxhVG1oT3d4REtVTWNiL3E4V3AyOHNkOC9JRUJ2SVk5WWtrVW9ud1hKQlFL?=
 =?utf-8?B?Ri8rZUUyNjNLUEwzT0R3YW9tUUdTN2M1QnlKMzIyWU95Y05Na2ZkaVNOa0tl?=
 =?utf-8?B?ODJzU3FmaGN2ZUdkbDY4cWFGNlNmL292RnY1eFdQUnI4dE5vT2I1cDVoZ1h4?=
 =?utf-8?B?U3NyVU96MysrVEVFQVFiNGhqTEh4RW82Y1dmRHhVNFREVUoyNnVBSlF6Zld2?=
 =?utf-8?B?Vll0enlWNmJqQVNYMEplSi9rb2lYOUJnV1RtaWNGSy90aDRucnJ3MDl6QjJC?=
 =?utf-8?B?WEhpRUVCOUJiUFFSODIva0tKZXgwQXgrQ3FIYlFnSlJ6a1FBNFR6dC9tWi9l?=
 =?utf-8?B?Yjk5SEI1YmIxb2FBd240OXBsNytuWDA0bTRrNHo3TDltYVozdG9yT0tYSEpt?=
 =?utf-8?B?L3psRDQ2Nmd4Smt6Zkg1aUV2SVN6bDVjZStRTUFMWi84ZXhiUE9qak81Rml1?=
 =?utf-8?B?MHFQVmRGNGdZN2VCTFZLTjQ4ZExIc1k2ZXFvOXF5WnZZTEYyUWM5NFU0QXI3?=
 =?utf-8?B?NmMzbDdLN0dZNEJ4UkhURDV6SmdzVDNGUVIwcTR4OTM4SUM4U0twQjFSdTN3?=
 =?utf-8?B?R0E4QTJlRnRhZHhaa0lRM1lBdHhRTEcxQ0sxbGx5eHl4TG5URDF0K2JZVWRV?=
 =?utf-8?B?a00vOSsrZHJGaU9McVRHeTh3eVYrWGlyeDArS3RxbkI2ekMxS1d4N0h0MFFN?=
 =?utf-8?B?RjBHdDNnRldaVUpJdkxDQnNPWjFWV2RpcFBTZWljWVBiQVlwcDBJV1M5UmV6?=
 =?utf-8?B?UU96YkpNSDhZL3RkUDZaMjgxYjR3VkRid1NrcTFIZ29taUFyWStQeUJHWWxr?=
 =?utf-8?B?V3UxK3dsVkN5Zm91MnoxdnkydW9BcnhxVFhlTGQ1L1VqendjREpUbDZyNi9o?=
 =?utf-8?B?RStRL2w1dlNiZVFKZE9nbDB4ZGhIOE9BMUk3UlRZeVcwemRCeTRkb0taM00x?=
 =?utf-8?B?ZFdHd2dkTzFqY1BiVThiUzVZdmd1UkJ2dVZqeU5GWDV6T25qZEp0K28rTldu?=
 =?utf-8?B?NFJnelcxSXV6N1lOU0pDb05jT0VFVTIrUFBTZHVVM2pIWmxNbUplZTJkUGNK?=
 =?utf-8?B?UlQyNWFnMnd3US9KQWZRdzRZRzcxeEYrVTZHcVFTakpuV0pZY3J2Tlp5K3Zz?=
 =?utf-8?B?NUhMTVZrUCtiOEF6OEk4Q29NQUFYZEJ3L1JTektHK2hsT2ZibXAwUUVvMWk2?=
 =?utf-8?B?SnRENU1UMDltUXFDdkUwb29DTmtKY2Y0ZFNUckczVFZLTTdoK2R3MDNaN1pN?=
 =?utf-8?B?ajQ4aCtXbjM5NmYrY0p1eEd1L0RyM3c4V1dFcTUxR0M0Q3BYWUkyT0ZPWU9z?=
 =?utf-8?B?UTdQUjV5R2pEOUF5SGFxcmJCZ0U1a2RBNWpudVliMG1pUDcxT3NyaXlKemVH?=
 =?utf-8?B?ZElXOEptOFdKOFpERXA2Mm1sYXJBaW5QQkRhdUNDVGZVa2JOR2xkcVBhSEp5?=
 =?utf-8?B?NUFWOUdYam5JUDJhMW9seXJRVjNOblV3MklyVExXaWNGQ3RPRSttcHhPa2ZF?=
 =?utf-8?B?enZjUFZrek56N1FLNzdGaXJYSk04aHlFVGY0YTJYc2JrUU8yWWRvU1Avbm1E?=
 =?utf-8?B?R1ZDakR6UnpjUUFRYzNqaXFrOXNoc2dub2NBNmozTkdxVXlabFBIYkZaenl0?=
 =?utf-8?B?R2RwS0tHSDNpdDN2R0ZoUzR6emd5MExMcjhsRnI3QkVTRDlBaTFMWlBoSlo5?=
 =?utf-8?B?elVDL245TEpJS2YveG83K0llRzBXYjRCcjZ6Mi9LY2FsN2hQb2ZUNHRrVk1S?=
 =?utf-8?B?bGNFY01JV1ROQXdHMmwxbjA2QVBUcHp0TldKd3BFckR4d0JsTXp1KzljNlgy?=
 =?utf-8?B?bzRuWVR6elFMdlBKNnV6VlRyMkFqQ1hLblJ1TGREYlN0RndSSTBEanNvYWsr?=
 =?utf-8?B?aVY3QTBySXMrTTlpK0VBdmFOYlpMK3pEdFBScVE3b21NMWFHbFJxSEFWQnJr?=
 =?utf-8?B?TTlhZGRKOHdFUkVsY3A1MDVHSXhhVVIvWUZycUI5UnE5MlVUYUZKdTk3UVRL?=
 =?utf-8?B?RmtZOEV0OUd2WHRiWkh6SGdGL2xFK0RRaUFBVGFXc1dOS3d2blNOOHhST1hC?=
 =?utf-8?B?SEUxaE9xYWRrYWI4ZDAzV2ZOSk5qbzcyYVJJZk5GcnhaK0swNFpLMkZsNWJH?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6S6Dbdiv8ZRKund4iJW+uk2Mw1Yyv2bP8qC4cbUSxDzNee6Sf2po4OWAG5CRzP8Y8x+7UZAKYMO/D20HKMSBUAgKmgczCm/zTmcnDiUERpshmf18svl0/QS0y7AugkUuPFQrnvndKySDWdlj7gypchnJY+bVxccMN8CLD0LWNxG9IKDiQIB4y0nl721YLNcd2W02YsXLZDEkzj90X9KxRW7lG/jL9IuJaYsVV5nZh3swr7in0f8scl7js6HT+PsHziK58DH/HmdMUOmef3U02sG7MR5Ofd0V1K9rtz7TkVXswvwDLbTEIif7VN09f600XOpecNi0T8dxFsqDNgB/ZecvYc1c2UFZsgoPVsGr8aYTOFj+Bm5pmcWnftI8ic6vYRBi5UKyGrEOtshX+e3++3z1onZmuvuXliwlM49yqztwUsj6zgV4lDu8fJX/I9CLzvt4dDlfUKc2sfDsxiFheLm4SPoIGWeTl7+b39COE9mMhRh4vdV/d6ye6QUssd0AnZwb3iBXujaTeNbT30NpCwnJNUfGW5L0gWxv4SRwJs+tRZyBtOk1Y9LXpYbatu30j4GcQAfoRhfGlrMLxEc+CFz1lYelF4u6b8PstY/Hap8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e407efc-bfff-4997-63bc-08dddbc7ded4
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 06:49:24.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3JJuv+at9+7CeC2f+wCr6B2NC2fFrRbZ1ALy7TQalay2L6bS16ImLgGnb8UppliNp5vfR9Rab0/GNi8soOK0HvCYpD0+BxH7FtS2ur+JuA6LBXGId4uAOXZKE/fJKyJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4385
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150052
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA1MiBTYWx0ZWRfX/y/UJbhS6g89
 hWCjTgBRnq6N6q8ZEOBQMtQwLPyU2v1CAJ8bI+NyiB5e3326gCdlsLEjth0nkhwhYz1cf52B4xo
 YEcWETZVIvfmIW8IhXLIfRYeCAPp/RVZX510SWY93JSBtKpDGSS4hxppuRxHlquJuCyhyr5Z7o4
 tehnxjBtG6o9dsBxEc5DYYrZVNb1hv6comaQeN9iIqgeKGc7jrOTTOHuoyk44el+nCKzp9+Bz1H
 sRoXbjyltWZDxVGywHUhHFGiZZnPCxzrmdJl5yqFbH55XoOSEOCXKv/x3QtVC60WOCzK2pb1cYF
 2HBFB8ykET+wWzyDaPrtBkRWd3SPneehExnRUAmgCuh0fxvEl414bocs/7zBK8iVJMJF8WXBLJN
 TeOMfk0DXOET62MA8j5qkQgkh9dr4LFyNhr0MQ/cFZGfloX04OZ5xGkhfOiNxHRkcG98o5i3
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689ed878 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=aHXbAQ7li1hnrysWXWcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: f6A6XYlEoDjirnMOUFRsPh5A68CrnF1D
X-Proofpoint-ORIG-GUID: f6A6XYlEoDjirnMOUFRsPh5A68CrnF1D

Hi Greg,

On 12/08/25 22:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
