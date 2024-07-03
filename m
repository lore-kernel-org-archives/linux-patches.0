Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FC5170836
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720026014; cv=fail; b=uA0kwXqLfxbgh29g1iCMX4E/qQjoaITKWw/0S5e+c6bXzveJMa8Q90XF7ek093nuioXZfbHkQGBBLKo5taNTOHxy/k83UmRM+qXF+yWbynnfG4DNhM14t8zsfZdoTOD+Zr7FDVonPkCGlytBLpW7IgcE5qgrT/Dt3WA1V0Fbn7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720026014; c=relaxed/simple;
	bh=gSay6mOZG2bMPAoqk5a46LVivYikgf+59EeLbXtckSQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FFNY5BYd/qMvLukroQeQUy1JPtqeN4LfgQ0u3CF6ovo4VKQf2dAm1V5Xi9oJSiOD/TgMvgCiFmNeZeSMLN4EIqOen+AUfYsFUZt4qHnKRyDGWG/qjxpk01C9LC19/qikVePasRYoYEJESWRDTawcsMgCcl4kZupoUUt0E44dztg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WX4TbWiv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zaGD99kl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WX4TbWiv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zaGD99kl"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 463FMUwa019759;
	Wed, 3 Jul 2024 17:00:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=UzbzMZUqFwifzilem3kxd2uKK+NJrOZJcBVXlPs2W3k=; b=
	WX4TbWivEKl3XQbY0ad+DnmUm/GkVWjyQnd1kbNzcaIaSOiSw5HxZePFx6huizGV
	1eGC8VF5wjzMmzC5qx/+57YlvFpqbYk/JWUH8JLHYy74D/vcEe8mqUpyvwB6Zzdp
	6/UkOSq7o+JlTZFFN0yXcxYwLAEUDw2N0us6GxHFTXjTd/wDqhwQDeJgfPQHYPpA
	cc431U98B/jh0JuSinIJ5YL6pwn0200LVbNI35bpwAicVksLqEes70jSJEgE37hu
	lQsXvoVT5hR+O2IB8dY2mP0eQkMXKT2cpvsd1PoHWvJAwiD7zAL32v6jyyaUXavJ
	UM6qtxW6m676S45RJDMmyQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4029vsrhxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 17:00:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 463Gxgvm024630;
	Wed, 3 Jul 2024 17:00:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028q9ssay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 17:00:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThwpJI7cvxih8VXilIBDOlNJMGhV5v+Lj8guW/03hIcWFaE6OG2WXuRoWbO3YcSsIEj9Neq2A9WyRnqRulxfySCsLY1e9jKWu6BU7V1eLAJMNurls+9k+xNV6zM+0oaVP03DWxQdgvuFrILjSrbt+4G6r6T15gHtzqgIZ+LweGyBHq9x8tinLiegmt4rlTwzFApAkpOzEDicEksc0McXgd6lEOwKdXa8a8Pbs4x8tqsDEKA25fF2Mx8NDCgdpgBZ+iQzKCV2QXHNdia0jz4LPxGuTOt7m+1QhC17rLkLlc+5jcQPLRjkdFllK2qdu2G8xKXuAZdhTnk8VwvRKCv0jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzbzMZUqFwifzilem3kxd2uKK+NJrOZJcBVXlPs2W3k=;
 b=CYrxNo4ZzDZ2AWYlJjVzYqQmuYR8zuALNjG4AsPIhTn56s0AnkL5E4o3lnt2SstligqjH28o20UKRjorTNbr0xYzqOU1IwPSN3/HSeZ38hOhKh4wI6J5E2iTZUM8/HiAVXpmiJRE9r+Usc9ZICvMI6IWLSPZRaN0ZyblIMUIocx6zSQoRR29lS8b4UaV9MgwTMv9SE6UOi2ZYIhYPqiAcKxKqMBcjUJKxZ4PP2uNXL6u9+/5d+WJgVjm0dK+DJpDnN6Dp/mLKYe8XtVPOm93HkxPjaW+r+NAjycYAX68yckOCRgVYUCf5/0sr5c6woDyOS+xgg4UboPsvZjn1ThQPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzbzMZUqFwifzilem3kxd2uKK+NJrOZJcBVXlPs2W3k=;
 b=zaGD99kl0eoPzzuBOqTj1h2qLjgooNwCmNqcVbIDSU7BitjGGYPnpxzqQoz7G6BUfW86GdGdR3kW8ruYx/ZsT4D6379ARnTwxX2+6cXq6OKOoFzlij03XU4DYY9tL5eV9v1X1elQ+wEpoRmCMnIxJnEXktbZ02Q5c4F7dvaiCzQ=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DM4PR10MB6840.namprd10.prod.outlook.com (2603:10b6:8:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Wed, 3 Jul
 2024 16:59:57 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7698.025; Wed, 3 Jul 2024
 16:59:57 +0000
Message-ID: <f55c8999-5e69-4631-9cf6-d858fb9002f9@oracle.com>
Date: Wed, 3 Jul 2024 22:29:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/139] 4.19.317-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240703102830.432293640@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0046.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::18) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DM4PR10MB6840:EE_
X-MS-Office365-Filtering-Correlation-Id: 01946ef8-39f8-4d37-66b8-08dc9b819192
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?T0xXdXFoejYvSzM5RSthcDdDdFRIaEVFc2pCNmVaRG9raHNFMC83S3NXMmMx?=
 =?utf-8?B?NlN4NjdnKzFINWI3MzFENXA4M1Bia2tBVVRWRFVQeUh5MGFVZHNSNHlkcExX?=
 =?utf-8?B?cnZlTWhGWlFoMERvS1NoMC9uQ0tUQkJyem41MmkveWF3L1N0dzVmMWRDWXpC?=
 =?utf-8?B?Y2xuMmUxRFBTMmlURGFsclVCUU5xdzVDLzdnaGdodUExMlBxNDI5a1JKNGR2?=
 =?utf-8?B?U01ZZTc0NmdtWUZMcGVXQ3NJUnozeDNFMklZUU9qdGVzcGlVM09rU09tTWpN?=
 =?utf-8?B?WVBhWnkrVUhJL1ZaVGNyNDlWZlVRMmo3NmtKTVVVRHllVjBYZWd5UzRHS1Iz?=
 =?utf-8?B?QlBJdW1vekIxbjFjMGxZQ3IyOGoxUjhjdGNoMUluS0o4eGdjRzYrcDlvVEl5?=
 =?utf-8?B?T3RvVEh2MmFMR2JnK2x2MW4wbDc1Qkg2NytSYnI0MUFIbFZxZ2RzWmtVNXRT?=
 =?utf-8?B?Nm1EdUsyVTFCQkU3aklJa0syUlAxWmtKVzhPTTV2RkpTbXRrWGp1K21sNTlR?=
 =?utf-8?B?R3l3OHExT0NkcDJSSXBBeEZ1aHBQdFB6MVhUOStzZCtRdjRRM09nZC9Dak9Q?=
 =?utf-8?B?OHI4Sk9GTHJSUE9nVEF1WTJrMUR5TkgyWlBGOUhTdlBZVHdBR29ZSVo5RDV5?=
 =?utf-8?B?REF5eFhjbkg0RnprTm9qVnppWkkzeUwvREVzZzRxdGkxR0tCR25pOUh5WXJ5?=
 =?utf-8?B?dzkzc2NpS29ON20rM1lYVmtkQlZqeGQ0eEw2b2RsV2N4SFNVUmVZSFNubFE2?=
 =?utf-8?B?c1NZeHo4Z0RyelgyRStSR2o5SWFGK2wzaW5HZyt2ZEpXS25BTHY4d2ptUXRW?=
 =?utf-8?B?c3E3dzNjU2NVVVlwV1hwV0VLblpBbFdGNkZzVFFxeWNjMzdqL0xhdnpQZGEy?=
 =?utf-8?B?ZUVob3BmT0svd3BRa0lJellUejd4Q05rcSt4bCtqQ1BPWUxuRWpKTERnNlNs?=
 =?utf-8?B?QWQ1L2RqZE5NVmJIUkRSUDhPcDEyZk5YTUhvSlN3YmtxWVoxQ2lIUFVyb1ll?=
 =?utf-8?B?ei9SVFJhQitZVEJrSCt1cWtKVVFiNzkvd211andBbko5MzV1dEFFc1l2OUhF?=
 =?utf-8?B?d3FVeGt3YVhsMEpXUUFPS2FCUy9Vanl4NHdPcnY0WEZaVkFEcStMWTI2QTFJ?=
 =?utf-8?B?SndjMXg5UTgvdjlxWGdYZTRkMk1PSVFZbnJ4U0tuYTA3WVVkVEo2VXRrMHkz?=
 =?utf-8?B?L09jRTlweThXaUtFc1RqVWF0QzJiUHhKY1I3R0wvWFdJRVBjOVlXbHFTWktP?=
 =?utf-8?B?enB1QkRETnZJZllOallZQklQNVpvV1BmL2xLNHVoRXFhazdMYTQ3TzdFc251?=
 =?utf-8?B?cFR5bWp6WFJEN0hieUphWUJSVm1adGJTcFJOS2l3TWdvMUc1aGUrY2NJdDN1?=
 =?utf-8?B?TWVTNUtLbGlDTHpWV1pLRWd5by9rbmVwZEE2Um5XL0Q3Mmxob2hSN3lwV1ls?=
 =?utf-8?B?Y3JRTnVRcXNkbkJIQVZtakxYTUxEUU5tN0RPMVB4djMreVVXWm5VUVdUMXd0?=
 =?utf-8?B?SS9aM2UzVWdXdExIcGxWeGJFc3V5L0VnMUhkWktiaWF4QW9qVi8ra01LY0ZX?=
 =?utf-8?B?U1BhSFJ1c25YVU1CMUZBRm00Z21mSklGcmI1NVRVbjFnRzNFWTBPbzJPTUZa?=
 =?utf-8?B?a0JvZnMyVXdsQVFKZzlqNC9QdXRHeWNKWW9XMXRqbmsySEpaV01ZWjhEZHRT?=
 =?utf-8?B?VUorM3JtOXc1aFdjdnMzMk4xOU8xUkc1KzlCMjRaWWtXNThzT3gwZlM2bkVa?=
 =?utf-8?Q?/wh5hotQxXa6xfCEgc=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SGhPUGM2MjlMWWNDQmEvbVVBOU5kRzlwbzJnc3ozU3ArSHQzR2oyUlIzRWtD?=
 =?utf-8?B?WVljUVJkNit6bFAvTzZMc3JiSlBsejF3ZHdXNm5heTJyYkVKbHByci9mNEQy?=
 =?utf-8?B?SGw2cjZwRUxzTTNXbllBUmkwejZBUUlvR0ppbGxSQUt1MXB6cnpWcUlBYjQy?=
 =?utf-8?B?dlpuK1hMaDF2cVpCampZTHZraTRRakMyYWExcW04VVFzT0ZiYU8yWTF3ejNR?=
 =?utf-8?B?V1dOVit2THVoZjZhVStpaTRIWEFmNU9oRi9uTjgxRUx5RldKc1NvaWdDYnRP?=
 =?utf-8?B?TFZLRzcxaWhsTTVxQkVuYmR5bGcvVkczeHdDQ2V5NHoyQWFrbkhrME5vUk13?=
 =?utf-8?B?dUdyc0U4cXdrbW85YkxwWnlXWTZHZjR3cG1XeG9wSlNMYlBqWStpNHZOdVBp?=
 =?utf-8?B?dGNkcW12M1RmbHVsQWJ2bFlaRGlueW5CL2VjeWJzMVRhaG9SaXZ3YndyclpM?=
 =?utf-8?B?blNqL0FEN2VscVVSYllmaFQ2b2NyVk9sK3lFNTJlSGlieEFNNGp6dEpvdTBZ?=
 =?utf-8?B?NFQ5TGVTOUVoT1JJdE5wYjRhNWhjQnRSbUxYbHNYWEtlSWhjMUMvTXQrd1Vu?=
 =?utf-8?B?RGQ0ZVN5U2xDTjFXTHJSU1EwRFpjL294WVZURWg3bDh0bDF0aUZwTWJjQnlK?=
 =?utf-8?B?bFZKaFFuM0wwc2M2ZmNIT0ZhZFZXajBnQXZXaXhncHd2eWNQZU5meitVRUNK?=
 =?utf-8?B?V3BvMUNXUklac3B6M0xmRkNxdXhpUWp5RE9haGg4RGg2MisrTXQzcmFqVGR3?=
 =?utf-8?B?K2QrbEdBUmJjK1pNUzFyLzJWcHpnd1RXNVg4cnQzM1JKdHRDS3h0MDBGd3Ft?=
 =?utf-8?B?a3lKNExPdjNOSTBMbDg5d2Q4RVBvOStkS2duNk81Mld6dFRCQ3pJK3k5NGhI?=
 =?utf-8?B?K0NiUU9nRWJlVjkxYS9meTZDTXFGdkZRSTBFeW9jVG5iVG1QbzdnYTBQQXNh?=
 =?utf-8?B?VGl5N1R3ZFA0YUpFc0tkUnF6M2xQQkp5TjVscTkvRUF5NVFSa2I4NllJckpn?=
 =?utf-8?B?Wkd0c3lyRGhYdjJpMWFRSFZxeW9iNmNENWt5VkRIaXJKb0dZYUZKZXFiVWJN?=
 =?utf-8?B?N1hQMUhNQ2FaZTZlWUM1TjJyRFNDS05sTzhSRG44dFRrTThodkVuU1NveXAz?=
 =?utf-8?B?Y1NackwyejE4eFd6NzRLc1BjWFJaZmdFYzNhU1krYWc2VS95aUVPWmZubkpR?=
 =?utf-8?B?UUs5WG1YSVZJQTVNWUQzbGE5UWhFbXlpeGhrdmFDeEVBaVdoNVV5YSswN1lO?=
 =?utf-8?B?YWNpQmlhVndQZDQwcnRjTGplaFVSSVZjN3ZVTm82SVJXWmdIblVIRU85eXNu?=
 =?utf-8?B?em1GTzhZKzl0SUlWNmMyM0dncHE2MVlCeExuUGJGdXlleXc4RisrQ2sxQkVh?=
 =?utf-8?B?d0syZXFBY1l4Q2VGdFphZW5hd0wxd0YzMG1xc0hTOThhYmpON1VLdGNGU3lo?=
 =?utf-8?B?K2s0S1ZqK0VlL29hU1ZpOVQyTE5yU1g1ZzZzbHpnVGVmRGFVUU9zdkEweG93?=
 =?utf-8?B?bU5IcmxYZTRQZUZNN2hCZURpRE5EMjh5UEt2cndUYTY1N0dRVk9sQTlNKzZm?=
 =?utf-8?B?alp4VHU2RUNwK2dlek5TR3JwaGFiY0RXN1Nvci9MUmJ3T2o3cFZnRTcybnlj?=
 =?utf-8?B?Z0pJR2RVVmgwaEc1eWp2LytrRldzdFFWUU9HbytCUWdpRzlxTlhuSzlIQ2Er?=
 =?utf-8?B?RlpGdVg1Y2ZMcGg4SHFUM1kyY05CeHppK3E0ZFVhVjN1R0FYK1g3Uzg3VGxU?=
 =?utf-8?B?QVJFK2RGL2FpdmhQS1ZDTUl0d05TZUtySUdzRlR6ZWRIcGlmeGtJQ3NKb1cw?=
 =?utf-8?B?WHRvVU5UWnpjYTdydjd2bkJDK3IwS25BYWwyZzZDazFIR2I4S1lBb0hyZkZE?=
 =?utf-8?B?V3ZjbjVsaFpQeW5sNjFWcHgzQURpMEJTR2JyTWRzbnZHTkpUYktjM2RXQzBs?=
 =?utf-8?B?Z3hzV1lGTUZBWUcrRXA0eUtYQUlhTEpaVndlWWloYml3RFNrUW5pdkYvS2tD?=
 =?utf-8?B?UUIvcHluS0tNaGcyQWdSVjR1c2d3VG5sSFo4ZC92OWdSbkl0S3U2bU5MVVEy?=
 =?utf-8?B?YTE3NnJ1UGxxeXFBQjArWjI1YUN1UTVHSEhmY2JiU1UxQUtYVFdrWGg5TGNO?=
 =?utf-8?B?WU4wLzIrV1hqQVdwdEU2eTV2WkhDTW9nMlVPL2hMSEdleHQ2T01lSHY5VDNn?=
 =?utf-8?Q?qjRBEyFlcnuI5VJFriVx7yI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tBBWwQmLXEiSaubLx1NrWBwqZoEmuOALE/B+gWrF5q8/hmXNspT20sLRlGDBuywGNuzcd7aZ+Ao5CoIM1n6w6T/EQOA8uCtR+jhZqIpXhNF8GUutAz9jH6xZKgGKmzz/YnPr/jF2/fXmlLDGmGt2U9FZ7ocesiqFWh5LMnBtlaCgY4URKpUvCmCjs22LMpQdNCJjI94s4HTOmFf1y3lUHh+cz7mFCw/2fg831gMYrD6/4YowG3h2rVC4YYJtGTnFG5uUv7fD9J7XtKZtN6aZ7dEVukjeD4yPyZr/hFN7ZmMMhs3bzgsoxsxtyf19Ni9TpC30mV2LLdY61Sx+gUo4K8lezo5EnKvyaLZH5N4opZBJ4rsNvaHAjnVty6iXScvEDAmqgw9N/JgVxTtWWzrQQ05asdvHijGpkgo9/rRebHoCzzzgxDJJ+GRcNsjw4+YzpWUri+sOr1HdKETJinrtIzAvcSJFgeBXMaXTNKq1cSMdW1GLUmFvmPCt4qmY3YKht6wUi+X12+cnlCLlfc+cSChqJx7CXKzW5BATqblQO+XeFgFHjidE/aLC8j817AfweJFc4Bxnkv6/wPGBLsyXUnyB1IuKFnFFJ3DjcHV01yE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01946ef8-39f8-4d37-66b8-08dc9b819192
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 16:59:57.6474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjKKwB9AWbiTXtLrfXU4ACulUttfonmE006VDdAiy17PoX/hIYI3digMG8gHqmo05i3VoRyFodfE9hu4VmlNDYj4vxALK4P70XY7/rDhydZ7JGDRqT98SHOr27IF6PCV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6840
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_12,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407030126
X-Proofpoint-GUID: Q-0tgIq78lQQP6KImrB9jORR1DbEh2Am
X-Proofpoint-ORIG-GUID: Q-0tgIq78lQQP6KImrB9jORR1DbEh2Am

On 03/07/24 16:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.317 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:04 +0000.
> Anything received after that time might be too late.
> 

Hi Greg,


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.317-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
