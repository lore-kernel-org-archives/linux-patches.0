Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED34F282E5
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 05:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721971469; cv=fail; b=lXkwR5QAAzK/g6rPpgV8B6Gh0DgSHDjFNnl3EqGSJXH5IcHaWU6rptO33dMZW4nePuTnZZtLUBoIQilaoSwnmMbgfFcFHNk2MMI7psEaMTMbWb/sf1vIehtXOa+wkp59LBkMZ0t2/T2p8tKr+s9ewHDnVAPasz3vjyky5eRuFa0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721971469; c=relaxed/simple;
	bh=TskCJM8lgdEfLQpSsOteqslxVwKH9zq/SKjc8wezZkQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aXj/lYyEqq29lFu0Vss8WkmMn0kmuCQ46Uz5jQQUYMVozG9a8aKJKGQVmxea1h5T8rD56nXzEMDe3U5kYKQ63R0A82QmQ9kczEBoifpLKK9PCxnSqPhzGCLK//cLj4orgxkA/MPIo5bBk41oOsmHNLF0Cg3bTJrosAoz45uQSzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kKRIGjUq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FzG3P8fV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kKRIGjUq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FzG3P8fV"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PLhNDt021964;
	Fri, 26 Jul 2024 05:24:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=UVtFOARKYkRUBjusx1x1fPZMWloOGpcMwLxqfy950zY=; b=
	kKRIGjUq8voPg8a5iXlnGrAHaAECIv1JHnUPWh9YDPOl6hqsuIq5ROMkmvh3aMeu
	4V0s9XgjQR8zz04oDlehz5QjS0AZK69Q/gQky5m9SzMlP8RJYuDmMTG5VJnjaRWC
	EF563X9GsBgnmvEdr2+x/7wqbHPsrYcpDsTVvHpM6hU0SoNzLAhkl3LraMqaGRWP
	hbv3wLD0Ej3MY8Oe70QTHxezyUXavBdw3nIEpqbGs26mOT96YOucZEaBcROAIB4o
	Kn+enzHOTKIRjhlkrpfQtMbqZE9h/WAqnmMC6PX8xxwOdWwLpItlDvB/isLP3gks
	QOsO2Yl+YCyUkguZZFRjUw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hfe7n0af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 05:24:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46Q4DO5B013503;
	Fri, 26 Jul 2024 05:24:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h2a57uhb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 05:24:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WO5guDne8/5ceUMQ4H0UyzucCubje7Wkl5RPVa7+kHcioxWeX9c0ZL+3SHpHUdGm5MlyWNMhdjKfeSi1yoYiZ6lifO/XwSRSVD00y3hmjdCC5BwCCPMbBlA+qlFjVeV3LJys4yvDefgiFzfK98nItROZXodBKtORFJ4jnv7zMURTfM8wEUoWq1hO+y13u0Y8nxTId6kqUguJxo5BtW4Da8shMsXlCqtyArIln2diAYh9uYjFazvEcXlsNVU48X3/OfMoXHccQMW7thMDMdWR24iU/Q6dsZcWqYCg0se0YOX9uJV/+wNVZS+F3vDYz9UGEzruQHXaMzvIozUp+L0xaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVtFOARKYkRUBjusx1x1fPZMWloOGpcMwLxqfy950zY=;
 b=ysHMvAGEATlh6SVSw9mCyrp+bICkCxRNGTho1wMaIUKcuzqtOtAmRukRJYkiKM2F0Mqwt+USYo4NSrb4wq2unj6JCOSpXvXvJYkpN4LLj6pRDAzNEYpT6cWse7Ns2V3XXbegOslvyOvYoJvBC1CSmc/jBr2rWlGKmUsAy5bVSlQlHT37QJcZnYoDoGyYgP7bxcS2k3pgocksGn/CTLHTcPoudPIN/CXyO7QdhEVjAWYEuK4HqBrdKYCBGENXLdxyef0xcPM5jz+ZbfRLhVMuGasNH4NdeLtQ95WUkpw9e/KKQCaMK7P1DFZFAHYKP1EfkhvRaWPguYrskih4kMuXcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVtFOARKYkRUBjusx1x1fPZMWloOGpcMwLxqfy950zY=;
 b=FzG3P8fVLRiQKwtk3bIV6GcklEtjQCHUhNrZeCKxuOyDzmwTZjFFt1Zv0FZGsW8mmxs3OcrXvb14hesFIWN7xu+7+aXrbiZl1nKwEZXaDs7hFsteM7QtloHWy64fZwC2TpXjqlbCym2TySMEkWweg8zp2el7rLDv+Nw4E2Rxo4Q=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by BN0PR10MB4904.namprd10.prod.outlook.com (2603:10b6:408:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 05:24:13 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7784.017; Fri, 26 Jul 2024
 05:24:13 +0000
Message-ID: <90c3dca8-5991-43b4-88ad-77514466c8ba@oracle.com>
Date: Fri, 26 Jul 2024 10:54:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/16] 6.6.43-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240725142728.905379352@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR02CA0005.apcprd02.prod.outlook.com
 (2603:1096:820:c::10) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|BN0PR10MB4904:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ed8141a-dc68-40d3-b20f-08dcad332f59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEdnK0k5MzNPdnpDY09maEpTVTJpNjkxM0Ywdnlqa2tDZWZzN3Zqd3o1UGNT?=
 =?utf-8?B?QS9Hc0dKSER2OGNrZFRHVVQxaUhXU3c0KzgwdXAwa3RJWkVvUmNvRWpQbUFo?=
 =?utf-8?B?SGMvblM2TW1yRXVRcFM4MkFpV0lLN014VEE1RlUrakJVR2lCYjY5dHhlUnBv?=
 =?utf-8?B?QnZmQmdoeWJvMFJBUTlXNjc4aEJqYTZVUTNDVHhLZnFsVE5LQmR0Mk9rNkRC?=
 =?utf-8?B?eFlPSXlCRVdteUdEdUc4T1BGeUNOQmZZSUMweXV3Z2lwK0s2RFRqM3RMVzMz?=
 =?utf-8?B?VlRVTmtnWUVEREh5RG1LdnVWMnpUQnNWbU9qQTB0b3A0dUllVFRLSE9haXpv?=
 =?utf-8?B?TWVUYTl4aFIvZjZxWlE4NGpmbXowelpabHBoMFpLTm1TVDFkbE1xNjFBWlBv?=
 =?utf-8?B?TVZickZTd1REQnNaMVF3NlltRDluUGVzRGluT1JCaXdhckkwYlFua2pmQWwy?=
 =?utf-8?B?WGQwTEd1QXJvTmRkKzJERFpRMlZoREdPUkRMdjdLbEZjajczZXRuRThwbTU0?=
 =?utf-8?B?dThBYnBKTDB4eDdEUVVBdkxQanhjZGgrRHRPeUlkaHpFalFubndXaWsvRkdY?=
 =?utf-8?B?N3hPNzFuSzI2TUpZNFJIcXNnUGdPVG5ja0VoR2tQWkhDaUJNZkxYSE9zSGQy?=
 =?utf-8?B?emZ4NWNrVWlJUE4xdkROY2xYbnBDMGRpdjhMOEo1Qk82Q2hlNUgwNjQ0bkNK?=
 =?utf-8?B?MnZNV0NaVW54b2p2UVZvUEI1YkNNUWJyZ1hYR1pFTjFyYTJmZ3F4dTJISVZ2?=
 =?utf-8?B?OUxaejhWVUxvbnhqaTNDQzRGQjFlQ1I1WTBlYTZwdFR2U2laZFFXSlFSZDRy?=
 =?utf-8?B?RzgvV1lkZ3FIVFFsVUQzK2NncFdVdlY5NjJUbDQ4MUtlQnlrQzNjQ2t5Ti8y?=
 =?utf-8?B?aUQ0aWRXZzRyczAzQWJVYzhHazVCVHFoZ1FhdGxIdm9KcHZvMDNQWGFRU0Jx?=
 =?utf-8?B?b1pkMjU5cFRCUU1JcXduaDh1c1k0a1llRy9kV0N6N2o4OXBDclNnV1BqQ1Jm?=
 =?utf-8?B?TlNaYlBWTXZOb2FPT1MvNlF6Z0hNY0hGZFpibXFrNmZMSUZwL1Jja3A3WElU?=
 =?utf-8?B?KytIc1U4eWg2SGhLWTUrenlJZ2w4SDViNEx1ZlNXVmJDdk1WanBmUjVOTHVK?=
 =?utf-8?B?c1gvYmhtVjJ1WTFOK2kvTzIzNWhOSlZMOWY4U3VOVkFMeHYxc2pIMjlCN21Z?=
 =?utf-8?B?cUJkc3ZKdXNQWFEwZ1lEVEJDTVBTSlYzTm1uNmtRZlk0OWhwT3dxMFZzbXBv?=
 =?utf-8?B?c05HQWdqWDR4WFB2NHREaStDcVRnS2RxNllkeFptRkcyeXNFWmZJVW15U0F2?=
 =?utf-8?B?ZUtGWnc4SXZBZWRmNHpyS1ZrdGJYaWZ5RS9IWlFUR09telNseFNjckRoZC9S?=
 =?utf-8?B?aTUyQVVBRnhXRVl4T01MOFgrNEhRbEFEaFRFVnp1Y0tTNXpGSi9HdmMrZEhE?=
 =?utf-8?B?ZFBPSVFWbVQ4VjJTNitXZ01tb3hRME45UkxTam5ka05TbnVuM2NCUFhNN3FJ?=
 =?utf-8?B?MHo0SGNRNUVNejdRb2RHaGYyY0RlSXNSSE1UdUQva2N5dEdEM2t0N1B0ck8z?=
 =?utf-8?B?cGVKUVFWNGhIVEswWHh6R1JTV2xibWdheUVydGhBWjdFdGJraTFEZlNSY3Uz?=
 =?utf-8?B?enA4amtnYTlMQlJ5WGJtRUQ4QVIrVlQzRE81b2tSZGs2MjlnSTE0UXZjcXZN?=
 =?utf-8?B?R2owS25XMHVVeGQ3V3pRK0REYy9hRGlYcVhvUW83a3lXU2RQNFR2L1F4MzhJ?=
 =?utf-8?Q?Rn6pHbgBVZFxgVUluQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDV6YXgvalFVaU5GTmtKakliQk9hcVRhUjc3NWp4L0RTK3JWS3o5VUxNc3h3?=
 =?utf-8?B?QTIvekhqTFhSM3NqZGlQMXJYZVFzMzlIcEx2M0p5ZktFM0ZCcFVudGxCMnVs?=
 =?utf-8?B?cmw2eU8rUE4vcW5JbEtOSFhSMkZ6ZGZxR2ptTzR4RTBiOXc4bDRBZGpOQmYx?=
 =?utf-8?B?V1dNSG1IVXVSZ25vMVptdlJ2WGc4eGxQdXhFWjhlOWJ2TkZRcmt6SjYxWEVM?=
 =?utf-8?B?Vk11dlAvZDhRdnhZSDV3bEJnVzhpV255bUExdlJzY3FnUGxRenc3OTZDWGcy?=
 =?utf-8?B?dHUyelVEL1JJM1pEZkJPTUJSTk82d24rODdEaVNnMUJjWExYenFkK2dpS0lm?=
 =?utf-8?B?UjBwdUNPTjNSdThrM0Nha1lRRmVsc2tmUTFiOWpkRmRHNHp3YVkyRldPOEdY?=
 =?utf-8?B?WnNaZzdYMmR5bVVIMW1oTVZTeUtSSGFxbkpMSFMwUC8vNGlCbGhucTlwZ2RY?=
 =?utf-8?B?SW9TOTJ6MDVRM0JLQzVkK0YxNHVnbU9OUDVLUVdicTVXekRQZ2c0MWlIUHdp?=
 =?utf-8?B?bUdRTXlUaUhCZDJ1SzJwN0dwU3MzNHN5THNBNmw0ampRODNFbURWZHlCTXQ2?=
 =?utf-8?B?OE5xSmhodUdsUjVPbVY1U0FhYUVtK25YZEZxSHBGd2dBSG94Q2FBQzdNeHAw?=
 =?utf-8?B?YlJrdzhYbDdJbGdzQVhoZ3JpL21jdmVxdDg3K1Iwb1RSMDJsMjRHa3lqNjVG?=
 =?utf-8?B?aUpaRDhIa2NLMnpZOWkxTWdkNzJWeEV4b2ZnUTRyb1lCL1dRMzlCN2wvN1Js?=
 =?utf-8?B?WkxIUytwU1pJeXdEb3o2SkRrZE5jck5nalZ0b3VWazBSQUF1eTJSbzA5dDkr?=
 =?utf-8?B?UWZwK3hScjBPcWtRckVFUkJid1hIaVYza0o4Qm5tQjExWEJhYUpYeEFiMjRs?=
 =?utf-8?B?SmdUeVZVUkdvUlVXNlNLOUNqZXZ6aVBSU3BJOWhxRWlId20vdXhCYTFSdjRC?=
 =?utf-8?B?Nld6TmJDSmQxWEwxZXRocUZZVFBTZ3cvd2RtWkdzNnliWjJTNm8xYzJWcy8z?=
 =?utf-8?B?NTNhTXlXOGVWMmdXeVN2SWF2RUhQSytDY0VpWjdHZ1dmRG5wSndSYW5aMzRs?=
 =?utf-8?B?bmRYQlBJVmxNWFZVK2hpZldZUldFNzRyVHZybFNjSVA2YU9oRm81K001T0VN?=
 =?utf-8?B?YU5jc0c2WGZqbFdPckVzVHJTL2hUK1JCZDdPc1hKNDdKdTE0UlJwNmhGcHNW?=
 =?utf-8?B?eHlJUm5QaVhiTi9CZEZwbUx3eEhqQUZVWHBDQkJOcW5KZGRLWHQ2K0xMTzg2?=
 =?utf-8?B?dU5ZbURJNkIvdWRaSmEwRStGT1lUYmlLQXlJZHBQS0w5SDVHQVpMSTlRT04w?=
 =?utf-8?B?SkQxTHV0K0dJVlZwY0ZoTHhiYzhjYS92aHlNcEhDRkQzQjFwSWFMUTFzKzZM?=
 =?utf-8?B?TmE0eDFUUmJIRW5hdVJmbWFYVldZcGIyNS9RWFV5VnNkSEhZdTlNU3dCS2Q1?=
 =?utf-8?B?c2hVMzZoYWtJMUphaUJHeDZhczlwNlRIQTUwWlNqaHcvT2NVTG03R2lsak5W?=
 =?utf-8?B?VEdRSGl1VkxiT1QrTUJQcGkxSDRmZENOMkJvQ3lXYitZa0FEVG13MkZRVlFk?=
 =?utf-8?B?OTM3MlhNMFoxbUdsaWlyclgwc2dZaytiUWxuTjBpa2xod2hEei9TYzZtcTNx?=
 =?utf-8?B?N2ZYaGRvK3hJMFg4VURBbVRlaHkxMHJxYkk1SlI1QUMzSllOTmRDLzh4d29C?=
 =?utf-8?B?K0RsbEplZEd1Y2xVdmk1Z2twN3VCcGJtV3M2cndlVEhrUWRFZjhQQmV0RTNW?=
 =?utf-8?B?ZGdyc2MvSnd6K2lzUUREdDZGUnhjZVg4Z2NNaklkQk5ZeldIdzVXM2xzQUZy?=
 =?utf-8?B?YzRmaFUybExmT0lqclFFb3h5N3Q4aGRHQTlLc2JsMUhnRFRLT3ErWEphTXh4?=
 =?utf-8?B?WjlQV09pQzBQWDFDTHF5cU5yc2ZoQmpONk1JVE4zTFNFY3A1dHdtbW9XSDFa?=
 =?utf-8?B?UERBWjB5ZkZDY0Y1Rm5DVUp0MUd0c3J6TWxPQ3U3VkE0eGVUelBVblJVVlNH?=
 =?utf-8?B?d3JLcEdkTkRmQm9GYm1yMlZ5ZEV5QmFBOHFudGxTcU13Z2tMMGdmdURYMWg2?=
 =?utf-8?B?TytKcldyWmhWYnEvOWJIb2dTa3o0dDZHODZ4L2VDRkxzSllYdU14VCs1MGNG?=
 =?utf-8?B?aVZnUGhZams5ZlA4NnZzUmxtZXJvVHFrMHVQNkxZNk01K05ycmtQc3lrZUkz?=
 =?utf-8?Q?39vJUfV3H8iMP5lCF/p0oDI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L/USNvvK0VAQOSA02PnNq7Cs6lU2dZ1e/H24YNARK1qbiqR7WkSYHX8XguhuANImxmCX+NJVD5KCBBKKlqutx6MikrrRzbbXm58OUOdhd7NvPOL5NklitTbAiGT1EAnJhs20D268LGCdlnMzAg7lILLWqyKGLYv6rknnLWZ65Nd3EakSL+pM8Ydtx9kOBe5Qq0+K/zzTQlONOdtiYVoU3/RjGicu3pS0QQ1J/CGJo3kPSptiOKZUS6y21Dv3+N8S44bp/RTNBUHXSS8xYX/YdPrNzyvO3VJHbzW+xpaKkdlIsyB3Z+FEKwMwTyimGxwVspzPBNn2GzfxTJ6ZX2jWZ1hs4B9Tbvm3lLUjJNn+/iwa+4w8DRHhX10v9qFPs1EwYXkVzZaRytfhZaYq+OlDBw9whRo4/ep0gWcyhLw/ET1qFBBABNNGZeG+Vfv+tVa2TL1S4r9rgwbTFS9iCrqq/xQBgn/D9okYekVeI3OmqOnWjk0pYkrytslhHcmlNAiXZb7fiV0dhB4nxYt2wMsKa0fOCWcSOpPSmA8/mBRdf7o5GzMX6NgwRqD+KcZWz28iIzhWz7+VwqCid7vXFst0g52VmEByNSMZIPNTEGa0JuU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed8141a-dc68-40d3-b20f-08dcad332f59
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 05:24:13.1942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ykfd+KX52TQvqLG9pzKTsk0LJawj69M6JZWaW5sZLsFint1bn0lWPbN9Rh7FfvNVIYQc72hMKHvNk+S6RxRYJMkyOpDiLLAjq/RStkGl33J10AWU7Dpy+aqaJheDhpIr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_02,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260036
X-Proofpoint-GUID: tqMsuraYhadIz9XeNm7Pf9reFLTMEZf3
X-Proofpoint-ORIG-GUID: tqMsuraYhadIz9XeNm7Pf9reFLTMEZf3

Hi Greg,

On 25/07/24 20:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.43 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.43-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
