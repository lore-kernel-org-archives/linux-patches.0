Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CACE1C3314
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117591; cv=fail; b=OY+GiaGb8kgW+p3OA0ikO6Mtl+F0KM3BztbpHT4j2g6OrXQYhPkNzXc5ZVD1Yew1BKdp9cWMru20UElxagN6rqNompQQUAC6byAhRLEQRjY5v4eZtMkVVvK/iNWBelqV6z4fvR3PmovJI6LK1zEQypglOaymEkkjTgPe7Xo3li0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117591; c=relaxed/simple;
	bh=cEkCPCoEKej7DX3XIJl31On36uRbMGbi9jzJzxGXUL0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nnk5OETUXqdOsSxS/xuq+mrtLhS7+YYK3P4nLXB0qfy+VrqHih9fq7M8M7AYs/6aidTsTpHRA/S5ySBOaTrvuggCWF3rAPDPUkh7mM4cvHPPpnCMrx6WJ9UBA/b8Mx3uMRf//a0xx5CyX0ECa+vZj+FNFIUzJZ0SCjI4orZExbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ldxo/KQm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0KMpVspf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ldxo/KQm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0KMpVspf"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 538C6lfu032512;
	Tue, 8 Apr 2025 13:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=bD4jrbr9TUKvwuV+wyq8qft55vrsR6nxCg27BUsuK/M=; b=
	ldxo/KQmXgQf/l2sE21eXUZbil6u6wquB+fn3QAfIQyjVEw8UzAtHfKxM3cLw4rO
	n90nK3PWhhA7MpqpYUjD2u4oxKQGWjhNwl2sFmD9KnuP+EqG2LOD0kGZlmNw3TOg
	QUNJz254WnXdwutfaILeQLXMNV9s5WaPq97QIsK/2uKD9t8hIIoJCz7hohSnR0lU
	3DdH/aoDoJqYCa5W5vH+nCbTxW9HwqYfJ+v6sBTtZl3K0b5uJNWwbcePf6O2VyQK
	G8+aiOXOBzuTLO3AsydnwksCCi3RUTU03hklZOgq9t248eoKrqOjio75bjByka77
	iyYMTSqke5CsPhtnmGUoxw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tua2vqkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Apr 2025 13:06:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 538CHZ8k002089;
	Tue, 8 Apr 2025 13:06:10 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45tty98t1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Apr 2025 13:06:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHVhuoqXfPcB7H2TOIGZKrB5AKuLxLjsU1H92+KFu2OO5KuIa98Wyi1gFQpMlKP0RxifoYczzCz34L1K8RSkZ5T+ICE/jxkp36b5hgjeINQCayAC8ah8scEW+FeVb12JFCd4v9wIQCffMsKFUrlmLXqHkjRjkRJUgyAji7imMVDX/uK0tmgXp9Tge3O+Uty7ZfUJ2hSmxjiXztjz8BNYahbyCHsnVHeYFi3gCkuL10CC8m5BRdpsELLCX8u7YoGpJhEhsfd9j2Y2n5925habjNgCTmvH7mRF8654rrz1raNUP7443wACkYtLnm5ZJhT6JowdCbiMrNeguy0rTAtAfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bD4jrbr9TUKvwuV+wyq8qft55vrsR6nxCg27BUsuK/M=;
 b=RwauvQV5q+q06s5Yh8ATX3y9v2xdtr1fhUWdtgiASgoAd/9WMlNBr+H9PP38o7Z0kMlMz6GSg+fk5EeIjADG0E82G4ZtRqne9EXeYGNwPZfPjM4znhtAp/eZVuPPhOuyYslniw8H2HfMBzGUbGlw6rWWh2guOw9xVDsw+LTL1uqYZvS5Gre1g4sNjVFPfS1S4A4QE6rWb30ySmcKrqnFqauXZukJa2lLTxDRbUv+mlaiFFmHVZaswUcDucEfSFjup34rQ0egjSg0mXECaxCBjdWXK5Ye6jE/0wwlRbCoos2+1typG4BLdJDH4QIGx5ZowKrIR1UGtdTx9bCSssLxOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bD4jrbr9TUKvwuV+wyq8qft55vrsR6nxCg27BUsuK/M=;
 b=0KMpVspfQpYsVL8BdX5ENUXBnld8JcTliTTCvlR7D62faVAecMLXPXEUQEFCHoAv+pjtUxwv/yu8RUyFBqwSwngKDLKODyb4xBhuqh7gA3iif4ZMnUi3kKe7xJ1YoKJhsmd7jtax2nznDbOLc+jrgPkKVBPPz+HTOk3xE4HeXws=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by IA3PR10MB8275.namprd10.prod.outlook.com (2603:10b6:208:577::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.35; Tue, 8 Apr
 2025 13:06:06 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8583.043; Tue, 8 Apr 2025
 13:06:06 +0000
Message-ID: <683b5bda-0440-43d0-b922-f088f2482911@oracle.com>
Date: Tue, 8 Apr 2025 18:35:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Dragan Simic <dsimic@manjaro.org>
References: <20250408104845.675475678@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0062.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::26) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|IA3PR10MB8275:EE_
X-MS-Office365-Filtering-Correlation-Id: 23dc6f6c-b8af-49fd-9133-08dd769e1f41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0U3YnlXM1VLNjVWUzlTYmpZcHpPMWRaQ2F3eWZ0c2ZOLzluaFJjZ3g4RVQ2?=
 =?utf-8?B?SVBYRHNoanpvVFdGMitjZ0Z6Tml4UWRXMDNqMDdMRDZPYjd6SDI0WDhDWExU?=
 =?utf-8?B?emlUcVp1R1d4WmdlemZoM1JWTllmNTVCdzNkbDJteTM1SmdmZUZRRGpISnl2?=
 =?utf-8?B?aWhDQzdsbUE5U3o5Qkl4OVV6MExWZzQ4ME5YckpocE9HRDdFUzdWNDRmK2dP?=
 =?utf-8?B?VjN4U2p6MGFFRVVQN3h0MTRrS3R1NXhkeElhWmIwanlUaTJSaWhQMFJZc0N0?=
 =?utf-8?B?Q1EwZG82VklaRGpHbkhkY21JMWdSek9xWS84VTJnRzFOd1Jta3UxSittZGZt?=
 =?utf-8?B?OUx3Tk5rck53ekFOMVNRamtib2pWVGJoUzJIOUhOMU41a1hha0h0SVVGRE55?=
 =?utf-8?B?MjlyKzVKb1RqVVR3QzdEQnlkOTg3T1NsVjAwbkt6a0daVXV2YmVZWDlYZGpu?=
 =?utf-8?B?MitkYUtVUXdiUlQ4M3gvdHpiS1BWM1pEZ05USm1qYzZjS21NS3MrZmpSL3Vm?=
 =?utf-8?B?YUsvdFZZTUdLME92dExVSndDMm5Yc01oUEg1SWlWTEF1bmZMckNqR2NHK0o4?=
 =?utf-8?B?MnhmUThsa1ZBbFdKZmNTZzhlWjVuY1FMazVxTUROOTF1NkVwOVRpcGZ2bkF6?=
 =?utf-8?B?N0QwcUp5SlU5bkJ5TStWc3RLNUNQZXg4YTdkdEl4UVFkckt6Z2I5dUd1S3JC?=
 =?utf-8?B?Z1JHT0QwT1llTzh3RUhwUzVDZzFqKzNxbERwM3pPVlExVkRQTjhFRVdSRVdr?=
 =?utf-8?B?RnN6TjlZd05TYXkzeTZzbWVwTTdNYmZhSmdWT08vUUhqektlRit5SjUwQ0JV?=
 =?utf-8?B?ZUtBWDVPdytXOGdnSFhIZDVacVFqMEYrRjlxdE52dXVKNEhDeE9ubVZaYWhY?=
 =?utf-8?B?MzltSlBqN3phZ2xWWlBFYjYwMnAvYUE2NkEzaERSRVN2VU1CRWlFQTdDWmNh?=
 =?utf-8?B?MGVha2UyVU9HbmgrYisvSjM5VnpiTms3UG9LTHhsdEV1TEtQdkJaeWtsMXNQ?=
 =?utf-8?B?NHNNa1dYc0ZkMEhqd2NET25jTzBuNmJxRzAveEhvTFVkVTIzR3E0SXl1c2RK?=
 =?utf-8?B?ODBESVZaK2pQOG4yZnMwOEFqTkxDS25RSHhlTkQ5alN3K2ZqWHFhTytocVVY?=
 =?utf-8?B?aG03M2cwUjNET1kzWkVxMVM5TjBtY0pMSHZaamowN0R0N0dsR2tIOVJheGY5?=
 =?utf-8?B?QlhrbElPY1ZRRXIydklidHFpVnY2U05abVQwUVRWQUVnNEd3NjE5UnluVGcz?=
 =?utf-8?B?bUtmWk4ydUQwK1RvYzRqRVdVcVYrRHVjN3h1QWV6QkNtTG1tOHRuTEdMdkx0?=
 =?utf-8?B?OXhpeWczeVFjdWU1ZUZ1YThEZDdYSHpTR1huQzgzVlQ1eTQ4UTZEcDROcWVK?=
 =?utf-8?B?cW5vRUNpUDFKQXM3cTc2OStRZ3Mwejd3STliSFZoYzA1TWJUQW5iUmhHNEVN?=
 =?utf-8?B?MjAvTzlHdGdNVjRFS096a0JBWnRCVy8zcUtDTEVyMnFCK2wyZlA0Q0xRNnFu?=
 =?utf-8?B?KzMxVG5nd3B5NXpzekY4c01QeVFvMk42YUlSdXhKQUpncDF2b2p6RmY2QWdS?=
 =?utf-8?B?VVUyU1VhVXBXNjI3VERYTStvYjBmY2ZQa0lTQk5hNHMxajlHdis3ZHA0K3hX?=
 =?utf-8?B?TU9aRGFEYUg5bW5lNTVtaktBVm8vTXJRYXY4cWNabmxZWXloWVlBTGxmdjR5?=
 =?utf-8?B?TVRkSjZhaUxuZ2w5MlBWMjgvbFlXa3FEYnlMSmFqdzFmeFdTb09YRWFRNVEr?=
 =?utf-8?B?R3AzUnk2clJKL1UwTlVWdGNvRHRLUXpKb1I4aDd0QmxWaTYrRnprQkVFdEcr?=
 =?utf-8?B?TDMyV1dFK3BLQ3dma0M5K1NKMkVwSUwwejJBVDZ6ZTBJTFlwTm1Ram1tUU5n?=
 =?utf-8?Q?DJtnWUOO8UW9h?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1JRd2JZR2FJT2FFQTh5Y0dJTlc2dnJTbmNleHZkVGJxeWRHTVQzTUtIVFZk?=
 =?utf-8?B?WldmK0lmZXJpRTk4eStDYmlBcU1HR1d6Tm4yRTdQY2dJTkZ1eEdUS0dOb29z?=
 =?utf-8?B?SlByYUhhV1VBaUxnWEFFVVQ0eEVwd29oazM0cnVsb1FCaGJRS3hsMEtMUmwz?=
 =?utf-8?B?YmNqc2l3S1k2YVFqdzBPTEduUDZ6c2FMWHNyUGFkWWxubG15NUJodjBXYnR1?=
 =?utf-8?B?Z3dOZnZuamdBb0VrOGFLczloYjlKRTR1TVNSZWwyMHJ3ZTJoRXdhN0REaE9P?=
 =?utf-8?B?NTlwd3pmS3lVUGU5Q0plMHBDbUM5cVlqTWFhQ0p1d0Ric0Y3eGdXeTI1NEpR?=
 =?utf-8?B?MVVRekxVVjNlWWhDNkJSUldDNnBpMU5HYjNFWG5LZVg5S2U5NXJieU9kY3ps?=
 =?utf-8?B?S0V6Tmgvb21oSzBKcU8xdEo5MXZXMThsTHlMZkpxbUxmNHZDM1U1c2ptazc3?=
 =?utf-8?B?MjVLQTRCQW9HSkFhV09POGtYQ3BIREVOSEZnTHo2TkdxUHJDRkp0bHpwRUdZ?=
 =?utf-8?B?dXp5dGJuTXAwOVcxS2orL0R1MUhxZ2pTVVU3aW5PaXJ1MWxHYmlnYWFUd3J6?=
 =?utf-8?B?T3ZVKzFMVis2THpZZmRUU0Q4alFaRlVHd01CQU5MK1BCeVhLZktnZGlWWnls?=
 =?utf-8?B?VzRMR3FGTFplSy9sdXdQRzlUZFJ3cGZLbSt5ZXpmaFcxS3hBUnZ0MnpFZE5k?=
 =?utf-8?B?dUUrT2tQVzRzVS84cSs2SXJrVXV3Z0FjblNRb3dxSmtSWWNWc3Zqc2k4Smxj?=
 =?utf-8?B?ZkduTFVXbVhHQWxjZGdYK0V1c0c0d29DQ3lXOERHQ0tVMC9aVHM0ZVF5SU9m?=
 =?utf-8?B?aS9PSGJWakN0bnJZbjZ0dzN5OXQyTW1kdkczRmVvWFJZMnZ5ZXZSVHJ3NThO?=
 =?utf-8?B?ZkJONEp4K3JUaXZ3bHhxL2FtY284TFJ4Q2tZSWJoaHpyckJhck1QQnpLcEdV?=
 =?utf-8?B?d2Jnd3RWV1FWR0hzM3pyRXVTWW1GbkkwR0JIVlFGaDQzTFpEN2ttQ0YwMVdu?=
 =?utf-8?B?bmE0U2FWRXpwajE1dHdmRVh6bVVKbWJ6Y3ArSElURFdOTCtoRHc5YUxrb2ZY?=
 =?utf-8?B?SHpQU09yVzdlTlRYRjFiMmM5enFORll5OFF3QmpPWDlyRVJ0NExaZU9PaDFI?=
 =?utf-8?B?eThlVmtMeW1jR3ZiOWQvRFJkNVdsSGNHRVd5elpBSkRXeUtoa3ZHR25QQU9Q?=
 =?utf-8?B?MTBSQmJabE9ORUhqVlUwbTBPY3hnV010MnB6c0FTYWFxcnVIR2Q1clo2WUcx?=
 =?utf-8?B?OHlMdkh0WTZCWDVtd0U5a01aNDg3clc2dHJtTk52dCtBVEVZaGgrbFByUWZG?=
 =?utf-8?B?L3ZwTUp0cHIzRHg5enlZdkZISFB5T1EyaVh0Z09mN1pwTitvU3NNZ2dxRzdL?=
 =?utf-8?B?OGxibGE3Q3dvMlNSUEJLdE1oMW1KYWNyYmo0RWhhZExudDRFZHhrYllnVlRU?=
 =?utf-8?B?c0ErZVZtZmxpRnhlalc5VFQ2UkY2SmIyTlN2VmpORWtxaWY2UDliMC8xOTNS?=
 =?utf-8?B?cWo4b1NOMEFnRittSUR4cVF0KytjYzJNa2J6bzcyZlRiWDZTZzRkMHYyZlJG?=
 =?utf-8?B?YzNYSDhBdTdvNXRyejNZRXRCejhpL2ZYS2NBaGVjbGJlc1QranlKWm5iOG0y?=
 =?utf-8?B?OGhqTndmN1l1MkRuY2toemlkeGpqWjR5dDYxYTNHSkMxQ2d0OW9HVVBUWlgy?=
 =?utf-8?B?L1h5Tnc2ekI4TkpPNDFxNUlGaWxDWWt4QlNYd0xVU3RvNEFGT0ZUQ2UrOGhM?=
 =?utf-8?B?YktQcGlTVi90WklTNGNFYStjMExUOC9wU2IveVpiOHNxUU9tdHJRTGtmTFpT?=
 =?utf-8?B?VlNuUE0ySVhVS0ttRXZFbVJCNkhRaDJlbXUyYVFrdjA2aG1LWmtPTHhGUDJJ?=
 =?utf-8?B?c1dTeWFqZ3NGa2dpbTRTRlBCVWoxZ2V5NWVSVVJKNUFnSDBXdElQaTVqaUV1?=
 =?utf-8?B?eXV4RHo0SlBic1RMNkhSR2VTWnZvTlFVVHF4SWMrTWtoTzZ0b2cvc3MrbmUy?=
 =?utf-8?B?TjU3Y2xpelhjL094Q2hEVGtlQUQ2OU9XRnA1dUp5SG1DdEJiR2MxWWk5bkVW?=
 =?utf-8?B?aVFpUFpjcnVyMWdaM2xYNjlXemlqWGE0SzdGR05mVXRSUXc2L24ySzU2a1VY?=
 =?utf-8?B?S2wrR3FCeS81Q0x6RDlubko3Y0o5N1hPQ3VtSUkxSEZ6a2N4Sk04VUdMdDdj?=
 =?utf-8?Q?hFTUC6eMCapCcUZS5cEXaqc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tzP+t6YyQ4PZY4bHDuRuSAymtsgtoxu+Jy/s7TOk8FJQ5P3tAyIZcvsPjSfZspDoNa6HNYPVT03l5U3OKcMBD3JtjpK1+XP3NInfGIWSgOECOG5VtNVuVoNFEHWlM0MfFfMnSlXigtZdn6E6zHsiCQHQuctWPV+oH+iyRFQS5WAmnfHBSzevu858yu0jR7Ta+1ecEVWUxP5MOcAhjWn3v+cfLZf0glWVuRbcHTeslOlbrTq3Dl/fWXFtJKCE5uEkjTZR5rqHldyXYeiZA1oX5YF+Fo6FRb3SnB0bL7KY4QHHE8bYFMnGrlgJnxwFsrRfUAJo90fC1b6/Ung93ekMK46tzFnC1ZfjmkDSi8CMQ7Se42aWBiSyYuWd0mfiARICmNv99JQYkHo1P7nWgSx05jJ8ZOj0qkRAdfPKjN0j52e0kCD7DPA1wkQY119xGGp8A5hJ7nXsBBX3aTZu0+QKxUJ2EBGnC2W0hvQ3QYCmEbd/bO2q1Cr+JaZl3dccBfHDty/llUFpdesCTFQIFc4dEonDltXcgFzdfELK/OuWzKbFnfplxcZBTS42O5MEHLglQc6XJj5FmKYHZclR0YV6DUvrClioLRZsIcVILkgbt+Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23dc6f6c-b8af-49fd-9133-08dd769e1f41
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 13:06:06.1733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o+MBlbV1roBQpKicDWk3gzapfMKrYk7I4X/vN2pcLc0zXctGnxHD3Y8YrMbJRSWpNlGTDPmcEN3NnCx3NvsluKEHFdPjEUK2CQk4uli/6M3D+lOIZyRyhEkfsU3f4ArI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-08_05,2025-04-08_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=976
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504080092
X-Proofpoint-GUID: wahurMGQQ0GiwmWOulhOJz2cMhRrtc1F
X-Proofpoint-ORIG-GUID: wahurMGQQ0GiwmWOulhOJz2cMhRrtc1F

Hi Greg,

On 08/04/25 16:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 423 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 

We are seeing the same build issue that we have seen in 6.12.22-rc1 
testing --> then you dropped the culprit patch.

I think we should do the same now as well.

arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR 
(phandle_references): /pcie@f8000000: Reference to non-existent node or 
label "vcca_0v9"
   also defined at 
arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR 
(phandle_references): /pcie@f8000000: Reference to non-existent node or 
label "vcca_0v9"
   also defined at 
arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
ERROR: Input tree has errors, aborting (use -f to force output)
make[3]: *** [scripts/Makefile.dtbs:131: 
arch/arm64/boot/dts/rockchip/rk3399-rockpro64-v2.dtb] Error 2
make[3]: *** Waiting for unfinished jobs....
ERROR: Input tree has errors, aborting (use -f to force output)
make[3]: *** [scripts/Makefile.dtbs:131: 
arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtb] Error 2
make[2]: *** [scripts/Makefile.build:478: arch/arm64/boot/dts/rockchip] 
Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** 
[/builddir/build/BUILD/kernel-6.12.23/linux-6.12.23-master.20250408.el9.rc1/Makefile:1414: 
dtbs] Error 2
make[1]: *** Waiting for unfinished jobs....


Dragan Simic <dsimic@manjaro.org>
     arm64: dts: rockchip: Add missing PCIe supplies to RockPro64 board dtsi


PATCH 354 in this series.

Thanks,
Harshit
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/ 
> patch-6.12.23-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

