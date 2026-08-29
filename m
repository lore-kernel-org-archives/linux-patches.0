Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502E8314D34
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 19:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788033444; cv=fail; b=gIhnkp0oZbHvuocDUYr86k0Xp6901L5YnzhlLet/BJtKQaljV1iBZVRDYkXDXRh1p8s5BEMYU7IXi1XeG+9+YHpvXC9a1oWcYP/qf0BGL8cUbvQWRe7n8eWnrXIiaK+AeD1VQxuzC/M+fcagFZcRgcPUY2RZmonB1ohnOjQN0ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788033444; c=relaxed/simple;
	bh=usKYLY3WT+EpR3FMjXSNmIkzIEElrYxKoh58XFwlAMY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jgrCJaHXKz+bnKXAPVWh1ZZY2tns5JC6vc9IN31caR6VpLwTNrq9SmHS8O4kBute2Qe7jvUFbjgdHTjlvzNh1+/COIbhslsnC2nTh3aplqMz8pg11NtaWLvLyhfyv+Zfj1APrd6LW8VXSQ5a7+Qe/EqwdLZaKt1nh/L3ttbnk/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AhVYxWG+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PQSOOVJD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AhVYxWG+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PQSOOVJD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67THZmEo1280580;
	Sat, 29 Aug 2026 19:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nKUIJpJA1I1RwMJyrUfHXHmBvFcPScYvX73o2uV4MVs=; b=
	AhVYxWG+JNuSglfAqi6InEstmNb9d7Fr79SG2sC7m1PONKyVuqirBLSH3YbIEhFd
	2bmr56cRRUGT/4xj1Ur5UJjRsJPF1IMBm7d4/mqwwYsBGFa2BnZnR5/eiLjYmmCj
	l59r+k6s2ICr/wP2+AdM8l3JdZKUCA1Otp0XqfoHhid41HYo5f2hs3DipkmoM4Y4
	7zKQkP090FeGzSm4twXsVyZZdE4+u0sXuoVNBy1evG3kKyipEDkZ23TKbDExad5B
	z3JbvJ6gtVdrbXLmEdPkTxETqEf7DsqzPpVLxBVOzZyXE81/E8qlCVwLgsG6eStr
	FiB+6ptQ3DrmfV5UzEXBYA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqyrrhqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 19:57:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TJt5RA006303;
	Sat, 29 Aug 2026 19:57:12 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvbqbac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 19:57:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JrALn2Cxht2LJGSLanXKfbpjDAAF8TsPCFIhA1Zdv8epYBOSY277M8+d5oPYvKcRMuWp8GKNz0XfHi1Fmzw3smexA6FOarZE6r/t4RH4JFfRXwUu6P7eOhLdpKm1qSzeL+M7ybHUvCWYlPpK6bDCknsC6jNzEwj9Wv8tisYGjMb7g6BlumWGbB1Ihkb9EWNEqx5zaFTQF8quWJt7BtcQEZ2aF1IQlegqeefa9XQ8KKdfCtKobgN6yk9BrQniFzTgk3MAF3eMUknl08Zd2KcdJKIJK2HYv2vqhxXw0Xpn/6duYofUa088IXhlZyye8hL08jLEuFICx4nDgdH9Q1/05g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKUIJpJA1I1RwMJyrUfHXHmBvFcPScYvX73o2uV4MVs=;
 b=RJfWRitRJM+g4ORcPdZ7L/Lyc742lWYJooeyGAeJBDIbCx5mvcKhYkak8nrXQ2dZk0nBj4x7fXcmD1S5Cziplg2n4gitC0DjbMUR/IMrfU7WuAVlK+6h597XfT4zyePwFob+y+7hk9h+qIfC78UVx0sVVuKKzlaa4K34h3EOlUqmMH5m3N/iSf3qarcyI+HASQmEUf4fMISkLYjPH/ltyd4gVq+TBeL5LFNGcPckKM6XABaCtOSRePgXPNGV8d4dPvceDlj/SdziN4xlul2AGdHFMlW/ftn/NAwxh3QhiZLMe9zLl0gSaVLtVm5xhSd6g0z9leTe+ESBZjJGB5G5rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKUIJpJA1I1RwMJyrUfHXHmBvFcPScYvX73o2uV4MVs=;
 b=PQSOOVJDDTBFJ9lcvgxlhxvzrpUKRfqZOIp+WVDNgS9KJzLabjdQmH0NS3D/y1dPG+0RuB8KJ7Q7Kx4gAurt97EaWpZgeOnQjYcOWpKHMFK3OQ8PoMA4RwhCfqu+IehrIIfIwIOczzha3pm5xuWrZkixg2LbwmLneWvlsfxCfqg=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH0PR10MB997666.namprd10.prod.outlook.com (2603:10b6:510:382::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 19:57:08 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 19:57:08 +0000
Message-ID: <6b85c1b8-99b5-48f3-8e27-8ec339394f19@oracle.com>
Date: Sun, 30 Aug 2026 01:27:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 013/220] net: mana: Fix EQ leak in mana_remove on
 NULL port
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
        Simon Horman <horms@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260820145223.480031205@linuxfoundation.org>
 <20260820145223.893784336@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145223.893784336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0065.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26c::10) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH0PR10MB997666:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b690b4a-b46b-42ba-fd77-08df0607b4d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|56012099006|5023799004|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	m2zNmgYVuNldulz0mlym1FuOtp8PLc6uP5CFJJBapH8voUKfKcNyoExnYQZwtyoph6kJOMQSIjegQd7Pr53nv639l03ZpCcofrheRYVEFoMwkcsIfXGk6GqyMMlvjxqn3QhgA1VE5fXLHKVaADSCw1kZLQ9bDErcuGgd+QQX9Lf5gJpmec0rycibGkHDYtQ1DIunGvYOsjd/lQ/XJcwkHUwK7aHOV0m//QYGjjuielRFieawCEwu82s1rjCe4oJLTc5MIfq6dkOF93LR1naF6Efapcta0d46uToBk1FDy3vd5ubMKqq8Vlbj00oOOVV7q/+3+kXSUvf/V9AQ9ydzZBwLaIEmDntK0fcMhPHS788IzkpVrIcIe/peFzO2Fir/458L2v8A5u9jeytEOVOq+lz0pD97wrg3xdx9DNp7hfPgvTm+34e8TPYhRee7HkRbLMEf8ohfX8k22flBIoHGd8ZXlBSqBe5c2g+r2V3V2g03lkFO16JEx5YKbKn9Bl2wq1rhzvUMNnNmXa6je0FBmS1+Jh0shW/C/EMyLtikuQqBZCCrPXtq2uRRHYJd8+vTng/2zdyODIePgOnJmkzjNcgk05y63yIj5Zr/uyXJKeei+6Z4+B8sP1fBI9tyTBGA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(5023799004)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzRaRHNpTmxkOXFac3FtVFpnL29hRkNoazUwK253Ymk2WFA0S2hxNXJtL2Fu?=
 =?utf-8?B?QytkMnhEbnVvNC9YWlE5bmJSakMvamVuM3JaN1ppZ29IZU5nM0hKU1NDSVZQ?=
 =?utf-8?B?S1o4eW9FYWgvWVdZUVFWa0JCaWE4aysxTDI5ejV6cnZHVVBrQnRSQ1RwOXFx?=
 =?utf-8?B?cUcxU3RPc0FGVTVPcFRzakI1N1pNSDNMazhEV0UzeFRnWTlEdmlaTkRidFJ3?=
 =?utf-8?B?VDFVNkRiNFhsOW1JWWY3NWV3Tm15MnpGQk1uVDJVZk5IY2xRaGRNVWp3WGNQ?=
 =?utf-8?B?cWtmR2VCcHp2bEIzY0lTL3dyTzlHU3NSZWMrQk9TNVhVeVVqSWRQQkJGa1ZS?=
 =?utf-8?B?U01tMlFsdCtCTmhoM000Mld2YndDOW5tOXRsajF5NkVGZzhGZGFzdGJYdXFS?=
 =?utf-8?B?SnNRRDU5QndqS1h2dVpnaEJ4Ly83YmFQNDN3Qy9iRHJDcmt3MGcvM29tYWlM?=
 =?utf-8?B?UDdVeThiQk05RnVZMFNCTE9ralIwQTk2amR4alpRQUpzRHdKYlBYNzdHQlBH?=
 =?utf-8?B?bmRqcWZzWDI4UkNNTzFrSWJmOElnT1MwWGY5ci9LUDBVSEYrRXVURUZLSFh6?=
 =?utf-8?B?WU1PdS9uOTltc1pnaHVHN3FUSHdWczBPOHg3eDVTWG1GQ1M0Q1VJYUZtZ0k1?=
 =?utf-8?B?RnRhOE52RnBKSFZZOThkVldxL1hPZUd1YXAwNUlrbjdoOXBJb0lJUDRUNkFT?=
 =?utf-8?B?alRFaFpzV2V5SVhybXkvVFVxNzZiSXdTb0lRbG1Odk90TnZQcnZHaVV0Rnlk?=
 =?utf-8?B?QUdwdDhNaFhRUktiQWF2SzBzN0R0OUozK1plTlBGYzBpSzBNVldYcFBkRHNj?=
 =?utf-8?B?a2w2MjBhWVJzbkdzTFZJaVd1azFFNGpGc3pFNUpKTVhlMis0WGQ4T215RURZ?=
 =?utf-8?B?SHhVL2dCSEpNUi9uVXlBTnhzS2lOSHlBNDZGVGhHbFY2dUJaSEtlZm9OeWpv?=
 =?utf-8?B?d0tEU2I0T2lKdzdBMUpjV1BmR2pkRTc4WDZ3NWZjeWFHdHR1eFlsQy9vd0FX?=
 =?utf-8?B?ck01MUswd0VZTzd1enIwdnNDWDJ4OFR0LzJFK1dxcUVGWGlqQU5KTnQzUEF3?=
 =?utf-8?B?bnFRMmRtelcyYzBBa0pRWjFFQ2tlcFQvT2wzUlJIK2xjRVBPQzVpd2JaS3lY?=
 =?utf-8?B?cFAwTy9sUXIzMU9wR3paVC9ETk1lUWxIMTY4M0laUUZ6TXVWVGlaSzFMZU9q?=
 =?utf-8?B?cERZelJYUk54Q1V2Y1Y1Vm5BTkVlZTRwTnlHT2dhVWQwNWxXc3lTemw4RGli?=
 =?utf-8?B?UXFDUWZEMk1wb2FMWG9rTnc3bTFIQTIweFk2bXpVWmhGN3dIUXlUUTNBYmF5?=
 =?utf-8?B?L1JmZ1VyVWU1Mkl3SWhVUWhWMXlxWHV4bU1RaEJjdElrZW5nYmhDeHNCN3FD?=
 =?utf-8?B?QkJlMnhKK0hiNnJnbUg2YnI3RDRmMGg2dXFIWnU4RWJxS1RxT1ZKc3pFZ1Z6?=
 =?utf-8?B?NWlYQ1I0V0ZjV3J6dVRMeGZyNDhqSFhjb1pVMnBNbW1YTktMdWoyY2htZi9p?=
 =?utf-8?B?eVVtZmtrU3o2Zm43SURYNjcrY25yeGREc1FnMkd6YXJQV0kxc2FvQXk5Q1E3?=
 =?utf-8?B?ZUZUWjhnbDE5Qmd6dCtRS1kvZVNjNWh3bHhGOEhsVE81OWNmb2lCejVXY0dI?=
 =?utf-8?B?T2tBdkRLemYzOU5VUm5NZjJuenFQRnU2R0xiTVBud3FWVUpTM3NLK2FHVnN4?=
 =?utf-8?B?L2ZCM3M0c2IvMVhveVB0WmxNQzhudVNXaU9nbVphYW9wUFJxbXNzM1VvQ1d3?=
 =?utf-8?B?MkRTa0d0cHRzOG1jTEdOZmhsdUo0bVBqRndWdGFQWlN5UnJVcHJla2xzTjZm?=
 =?utf-8?B?RDRPVEVuQm5qOUxRV0IwMittTk5ndDlCdnljSkZCMkdLNC9uRkh5RWFMaFF6?=
 =?utf-8?B?dTlrMnM4UW1GSk5LZ0dVM2E2Z1lwOHNieTcwaCtlK3diN1JFZjNKSW5ZQXZp?=
 =?utf-8?B?dzZraG9jeDdiQUJNMlVrc1VTdDhVcDRtVG8ya2VESFkyVE5KS094Nko2QVdh?=
 =?utf-8?B?NTRJVjBoUWhUbUlNTE9sbDZ5bFZvUHQyZzYwRUVrZ1JVUlBhQktXQVNKOVBw?=
 =?utf-8?B?cEt5WVNrU0lWVFMrZGsxRWxjWDR5cE04L2tJM2xGTUlVaWxBb3dwSStHNE1G?=
 =?utf-8?B?Sk03dG9DekthN3VYT0RMd2lqNHJIV1ZId253R1ZTV3FaL3lDcXo2WEM5RlJ5?=
 =?utf-8?B?ZnI0Y0tMRnFzd2dGcUZCRWlTeWZVNTVaU1lrZURUcGE3M05mNkYrZjlEbno5?=
 =?utf-8?B?eE0xREFGaGxXanIwdzhYVkRyN2VZTDVWcFA2Vmg3NThpTEkzbThSa2tFM09Y?=
 =?utf-8?B?T05US2pmVmJkT0ozWGprTEVXaHJCYTRBbDlJeDNYczRrUndXWXduWU5HWWFU?=
 =?utf-8?Q?USyH6nqpuy93m1nER61Ots52qeLeLmGeVxM/t?=
X-Exchange-RoutingPolicyChecked:
	ZyU3oBWjVn7vLRIEtcLXw2LHkNC5LxEi4gh99qgJ7eoiPTkCi7WCyQ3ON9yDlKu1a7KcT2uuJ0tPXh/Xj7KEPgGRsRxuZAFTRxb4O9erQjvRJvSxnnEDHdvKe/OasaxLDOVmxM9zz2X12Zm53TIETIwqO2zTlCvnjy4EexgWviXZofQfL9aciyVTG7+FFRKjIXjZBmDO3E0/FoE2PPfUwdmwJ1CoxiSqrMEVbdozmVOmH3C6opIUzRWxMpguZjiEkSrMTLPQ7tEHIPcBKtUpkociT3O9RdyfeWU6YszDrmegq6O5+cFPMQgibQX7aOcWSouiRvu6PmRlonkotNdvqA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tqMVPno193Mc3sBnKlnh7/gP2KFvN6RElJIcux9Kzt4XU2jhahULIDMt27HhUSPp5AJZxGB9AAQF+cL23wOxm/Ep/EX2wKaiF+p7lAhBozNoU3h/E+bZlcSesMtZ3jg6MR/fk3B0aGTq/mOhs+6Fp9Y0UCP5dkUzbWPegp97j5DXt5hz/R83/aciu8di+iWM+Ng8qBf79YL/5AVnhSwFH8//ru7UQFID59qVVMG7RIniEQLnG1vrea/ZiDexqLjFLfUwjrCLzI9+J1RNa9sgH+ITA4LlaGH5gFRKqCQBCbC6bfUsypFfv98/tMabyYhO9z09HKcati+k8hEqbyvZEdbfjT5WH6fRU0HMxDnglRFfiaD33RkLKCnIruLQmM7eX6w1gqE8TR8cLXFc8/+0TBx0Xa4R2R/RUUNqhyZJGSVNG7IpjxwNfI7ITPA2Go3wkjxdFb0Ktost6W3VbtJ8VsUjtUhgzV+4HioIB51Ch/7T3U5hedWuRt1zDbsZP9h80w+vSdcIpfklSg+RBV1WVKKt/pncicldiafwZWPE93urQkBMxqc4r7kGet2L4YMCNAOa7pmdxrbMwN6msXxmfWYCoCC3JkjTujhF+nma63U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b690b4a-b46b-42ba-fd77-08df0607b4d3
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 19:57:07.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTcvbrLwIV0oyiFd6Qkna7K1f+kcaHGCqQp8LBw+j0VLlw+k15B09u/8d3OkXGvS6zIs5C2oeZ0S3R5NY5rUSdzTTEwCxQitf8CzsazA29CPuQqY8g2gSk/X1++Ynwdp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997666
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608290173
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE3MyBTYWx0ZWRfX9ttzlKRU/Mcs
 wpVW0g2z1BfwZ7bQdHHWsImHVFqv/DKWxRa7KBD+WH20W+CZJ2b+nR7eyBjWx7TPmaPeGqdaefE
 if0cLWgHjDlBqwbnXoe6+zgKGurufIg9DYkVRLLMToadq9q/vyhBXa2boDRFRnkEk+Wq7qsTFRH
 ySVeR9gNB7j2pCBUSWx877QJC9V2vgS40DFkGQb0TeCsm3qtGLxYRFuhiUkeoBV84gZMFcXJkvh
 cD00sw7O9JY3xxccnL5r8k9wtKwvWXY8ejQxVcdShokpeqhMjpj3+VwM1BeyeWbWNdZun6n4prG
 0RZdN1fCkz6OKDJqpVgnY5BaiJNN2o3rE5nshmwYSTf7jU+5Q0ZIZjWvrfCEyjLbukyMJryCHUI
 98x9D3HC17rZjz2+q7Q/P+d80Sa8a9pO43KkEj3ZoXWOcqp5MYnIHEevc+hWiQ1jqNsltOtV00D
 SEd4o5SEi4S86TfRT+Q==
X-Proofpoint-ORIG-GUID: cYVRjOE6fMHq39hSccNPCYTBPnYDPgwE
X-Authority-Analysis: v=2.4 cv=fbCdDUQF c=1 sm=1 tr=0 ts=6a933998 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=yMhMjlubAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=zPxnlO8LLdWS4P7WZOMA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: cYVRjOE6fMHq39hSccNPCYTBPnYDPgwE
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE3MyBTYWx0ZWRfX37fEvDqY/RJy
 bSTH0ifIfq3S1chOxhIe+Twnp95duWeesVnrpvW2G3f7vThBrAvqLoBrw89BeWEzc7sTBkT9dKP
 H1FMcTGINqfIa/HPaRVLXO4G2gXCkZVorL8OhYPopO95/yG6eTtK

Hi Greg/Sasha,

On 20/08/26 8:23 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
> 
> [ Upstream commit 65267c9c4f28199985505977bc2c628c82fc50ef ]
> 
> In mana_remove(), when a NULL port is encountered in the port iteration
> loop, 'goto out' skips the mana_destroy_eq(ac) call, leaking the event
> queues allocated earlier by mana_create_eq().
> 
> This can happen when mana_probe_port() fails for port 0, leaving
> ac->ports[0] as NULL. On driver unload or error cleanup, mana_remove()
> hits the NULL entry and jumps past mana_destroy_eq().
> 
> Change 'goto out' to 'break' so the for-loop exits normally and
> mana_destroy_eq() is always reached. Remove the now-unreferenced out:
> label.
> 
> Fixes: 1e2d0824a9c3 ("net: mana: Add support for EQ sharing")
> Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
> Link: https://patch.msgid.link/20260420124741.1056179-6-ernis@linux.microsoft.com
> Reviewed-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> [ hmahfooz: resolve conflict in mana_remove() due to missing commit
>    3b194343c250 ("net: mana: Implement ndo_tx_timeout and serialize
>    queue resets per port.") ]
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---




I ran an AI-assisted backport review and then checked e257399b7eab 
against upstream commit 65267c9c4f28 ("net: mana: Fix EQ leak in 
mana_remove on NULL port"). I think the conflict resolution left an 
ordering bug.

Upstream has:

         ndev = ac->ports[i];
         if (!ndev) {
                 ...
                 break;
         }
         apc = netdev_priv(ndev);

6.12.y has:

         ndev = ac->ports[i];
         apc = netdev_priv(ndev);
         if (!ndev) {
                 ...
                 break;
         }

netdev_priv() reads dev->priv, so a NULL port faults before the break 
and before mana_destroy_eq(ac). The backport therefore does not fix the 
EQ cleanup path it targets. Upstream commit 3b194343c250 moved this 
lookup below the guard; the rest of that queue-reset change is not 
needed here.

I think we should be moving apc = netdev_priv(ndev) below the NULL
guard in mana_remove().


thanks,
Harhsit
>   drivers/net/ethernet/microsoft/mana/mana_en.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 476f7ff0648ea..70fe4d837a0b6 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -3011,7 +3011,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
>   		if (!ndev) {
>   			if (i == 0)
>   				dev_err(dev, "No net device to remove\n");
> -			goto out;
> +			break;
>   		}
>   
>   		/* All cleanup actions should stay after rtnl_lock(), otherwise
> @@ -3039,7 +3039,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
>   	}
>   
>   	mana_destroy_eq(ac);
> -out:
> +
>   	mana_gd_deregister_device(gd);
>   
>   	if (suspending)

