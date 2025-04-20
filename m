Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F31936D
	for <patches@lists.linux.dev>; Sun, 20 Apr 2025 06:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745132091; cv=fail; b=iAPcIkS4LLGZonv3ICHQ3Vq0WGq55JSA6mKAHcxcihxY/A2NF6pi7gGwRE+5NMG7mcwnuBy+bijoMJ9bBS/RRxPuYvrELZASEbmf62/p+2aNYrNjzyBZ1jGajyfR5RS2D14z1sHCY9fD3d3OUoenxU2uFVbg4Zk30TyGLCO0YJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745132091; c=relaxed/simple;
	bh=6trB7grfxY6LQPsugc/iawyt9e7/uTUZbwC0qP8Zj8I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qDY33YWo3X49fYeAca79XlD+yJcLUO6hAE6CuyKqPuPSPTt2Qbp+KKAAqt1TknEeo3jWjQF42tpBSgoygc17A7k2cMhNaEbYDhUIVsqXLEdMpTY1A39+NNIPV9YkQxyApmHDeyV+EJuFAkBfHG00AouPxWXbZ3un5Gc8eNcEoww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MdrPMCvc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GLhloG5B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MdrPMCvc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GLhloG5B"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53K5ki3m010910;
	Sun, 20 Apr 2025 06:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=AuDRpzI/OVrKQ3liPsEFSNE9RPAWqfnzBqn4MeabVYM=; b=
	MdrPMCvcKWXO4gbnE+Cl6J1380KxK8xCpBhXxKoat3o9LZ4/TkYLP5N319uixaoP
	l9IBQV7HIiCBGEuRdQfod0dOqx4Gtm/2keN4pg15qaN0J1GFpIEU8RjAkLVurBJy
	bYYYW/0Xrmg/+D8kx8qunKgmaFrwU8O8xO5whtpdapuJYNcOXwL83rG12+6od/wV
	2HtctyadYIXnJ2q93MHMpfvDrUra4jAoreeR86h0dMdzG5C0hzFdR7wjBZlHOStR
	k3If0QBg+d21pPb0gCaFBAls2f+/OTIgY2QdgA24d6yYeFmbrAlD43MVlZPfFdtr
	W+xqrZ7PMuivXbFdXNfbXw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4642ra8y7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Apr 2025 06:54:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53K3whoF002835;
	Sun, 20 Apr 2025 06:54:29 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazlp17012035.outbound.protection.outlook.com [40.93.6.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46429ds285-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Apr 2025 06:54:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B86BWhkQiXD1n4sfvKmPJHl2Izm8dstPFBKBh4kt3u2ByPpUI1XDdUYg4tyby4L/9B18ZYp2YuI6oxWF4EUFmRV5etmvMY9kfB5dgqBU/chnJACo6DuFXtPB4nh3K3MaDtQnEMoFtGHKkFmC2OBb4dRjqW0UvgQLNqB90UF8257XY8dvAYz9iUZU2rvTx5yLUKqC3sVRcP5nCBybErCKTJSm5jb6Qbcsec3p8M/HSGhfqsrvQlAVrswP8zYbOHu0HJZZ4UjLTIyUsg4A3YCSr8Dp1Bmhw/kvi3X7xusUjC+irbYLhL85p5qbiHPMOr1Wwc8Q4FZdjtTupPBrR2QJUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuDRpzI/OVrKQ3liPsEFSNE9RPAWqfnzBqn4MeabVYM=;
 b=qYBmkpQQQHzbjFReIPoDD26gOOPwTtHssez7e3Jk+gEG/3Vjr0par0lCKbBss42X/WC7WhoqbgESxf9cHSJfrRhNlo81V4I17aMo+UxjgxNZrtcJ7yy9MQInu6C7GVE3lkMEFp+yd8rbOa4PItfLw3HANzfilwIQkUbQeTJR6/oFCtbRLRd/8QRUOPKfytoU8jP4LgKmq//06EnrC0tIM1L9kPhlT7TCpv/L47U8JyaL53sXXUxVSsIVtXFv+ov8VDbByd+vqUxzArwrLF4UDxP+rCC/81tJZVTZ9b1Y/r0E3L1ZnBNLd3sk0XnCFMXGKGpaZ72fmevs+iARfMuS8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuDRpzI/OVrKQ3liPsEFSNE9RPAWqfnzBqn4MeabVYM=;
 b=GLhloG5BOxDHH95/k58ZTmj5SVSurUGpm9oUE82ieUVNx4qt9kijixYtn7zgmmMJHsmCfw8fnR+87l2yRGg4j/DCUHdeFHZyO/1n/5BLTMqhCnCDqy6FmVBTjd+gbQi4IeX2UsZFNjkka8JtyfB6uesMPLWlVmq4EHeBj6+7fuE=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ5PPF842B33876.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7b1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.26; Sun, 20 Apr
 2025 06:54:26 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8632.025; Sun, 20 Apr 2025
 06:54:26 +0000
Message-ID: <b0344ff2-4b26-4820-a161-4d44c30da723@oracle.com>
Date: Sun, 20 Apr 2025 12:24:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/393] 6.12.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250417175107.546547190@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::14) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ5PPF842B33876:EE_
X-MS-Office365-Filtering-Correlation-Id: e85b4aba-41f3-4470-0aa5-08dd7fd83088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFY4WWtSYyt2QnNydmc3OE9lbFNVUkU0VTUzcGlmNlozU2FOdi80cjlOSEJn?=
 =?utf-8?B?VXE4VDFMbVdLbFAvTzBGb3VzaTBCOXI2RTJnZkFHNmxOSlkzUlM5eVlvMkdE?=
 =?utf-8?B?M21WOGFtdmowT3JVMEFEZ2V5N1h2M2VKdytrcW9VVGNGaHdEZ0tXa1JFM01U?=
 =?utf-8?B?OU90b2VnMjJYeGFtLzBTNzEySVBlaEJBTk5iamJkYXY3N1VEOVMwUTNYMUdq?=
 =?utf-8?B?eThyT043T0xWRDl3S2dlR0JPU1MrdmtPbExZSEllSTZIT0ZQVjBEUkpITHZP?=
 =?utf-8?B?cU01SGFGaHZSd2lPRzd5K1V3MmFYdEJkZjExVURPQjFPR3Z3c2N0akVqZkMr?=
 =?utf-8?B?bjJnVERQN0RzN3l3K0NWQTRydmtYN3NxaFJWVjRmREh0S0NzOFRnT0dtdWZS?=
 =?utf-8?B?Vms1aEY5TTEzSlROcEsxR1grWWV2SVhmVkRaZW9RREJaNUx6L0IzbEtDRDd6?=
 =?utf-8?B?S1ZTRkRoT0Vna3N5QTNqQU1nVndheTM1YUtUa3hkK2dITllucGlGRUVJbjdZ?=
 =?utf-8?B?MWk4VU5SYWwzZmpjTldHRHAyRWZ4Nm5MK3M5eExvdkpmL2NOR0RQdlRGYXVH?=
 =?utf-8?B?WDRWSGZ0WG1CUk1yTThoR1VXa2dzRUdzeGc0M3NSZklPSnVFZEJxQlAvamUv?=
 =?utf-8?B?aFhNMjhYZnZMbDY0cjdqeXhSY3ZaTXNNRnV4d0RJbXpMUWhRM2xqelRKRUVM?=
 =?utf-8?B?MXY0MlNFazNtTENhUWNhaEhsTDRuMk9TK1VrNWJWWW1YbTRvUkxEYndaNVR4?=
 =?utf-8?B?TDdNUHdMb0NncGFheXg0aFJ3QWY4NVpKckVsTWNYRUxKNG0yK2tjOHZHM1Jv?=
 =?utf-8?B?LzlobWpTajhib0dDZ1ZiejRadEh2KzZvT1MveGtWVWxKZWVORWhFcUVLd3FG?=
 =?utf-8?B?eTRYcGlDRUl0cG1FUkk5UWpLWnZhdHhqdkNwMVhTMHV2YURrZysvZ0NNdFNL?=
 =?utf-8?B?amxVM3Urd2lXVkxhRVBMS3ZielRzdS9tS2VnUndNT3NkOTE1cWM4SFM0VklK?=
 =?utf-8?B?UGZuV2wyMEhHZWRJL2hDUE00dCttUFdHU1FLSjVaMkQ2bGRGeEtvMG04L09B?=
 =?utf-8?B?cVpKUGZ2aS95MHIvcEsxOFdKOGt1SFp3Zmh2RFZ2WlpoVjNBOHZMRWF2OWJu?=
 =?utf-8?B?TVc2WmFtTFRQWWxRZ2VJU1N0QWN3L1pvY3FaMm16MENVRXh0b01WZTRCWVRp?=
 =?utf-8?B?RTBtSnFwTkQxekJiK0E5ZmJHYUJGdy9SRGNyOG5vL3owZmQzbmhmczVFcThT?=
 =?utf-8?B?TU5sOFU0eS8rRWtURXFqaktYL2pIZ2crTERIajB6cEtkakNjamsvVzJlTWxZ?=
 =?utf-8?B?ZWFHZmo5eUNjeFU0ZFpmRXF5Z3c1djMzQmlDTXBtS1NGc2N1MVZrNUpWeEVy?=
 =?utf-8?B?K01ZOUhPa0xjRVRocjY0K1I0bHdubkZOREtRQTk4UnJaK1NBbVpDc1IyYzJs?=
 =?utf-8?B?Q0hNQVp2MHllZ2Zuejh2TnViTFZDYmJCL1NrUVNlMXorTTB6N3liSVc4cWtJ?=
 =?utf-8?B?ZE5ieSt4bnBOT0g5a0MwSTdsWDNKT3lYQUJXTWxXbm5kU3AzVHJzSDZPV2E1?=
 =?utf-8?B?M0Izam5ISUpFckR1Snpjem15MUdXM0NRODlaWmtTbjBtZmladkI4bFpxTUxP?=
 =?utf-8?B?MmdLc294d3FYWmVXelRKendManR1bndIOHd1QTFSSDg5VERwSll6ZDNzaUc4?=
 =?utf-8?B?Yzl0cFU0Q1VGQ0toZy9pNUpkOVFSMVNuMnZSSmxmZTBmQVBaenJNYkd0Mk54?=
 =?utf-8?B?MUFVVUU4YkpITDRDdWtBM1pkR1pmS1orUHFQSTYvUTlRc1VVTnRwT1l3NjU5?=
 =?utf-8?B?eXlyWGprOU42bEpsZVoyZXhmQi9jV0tleThVb0FBZ1ZoaE9iSkY1d0ZZRkVr?=
 =?utf-8?B?bi81VjJZY0MzNU0vYnhqdTZJZVFucFl2eGN5Yjk4YnFKY05yTFNYeUVMbFdz?=
 =?utf-8?Q?bmZEamuFm/k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTVYdEpKQkZmcFFheW1DVThvWWRMWmtRbFZiWkREQ0tGOWNCWFRjS1NGSUll?=
 =?utf-8?B?Q2pMTHdLSDl6b3ZCNWkxeGtmamYxS1VwZzFRc3dpdkFzVHlWVSttbmdabnE3?=
 =?utf-8?B?UGY2L29MSTZlVllpSkcvUkxwdStHREFlQmc3Zi8wbkxJaGV0ZHFmRkZzR3lX?=
 =?utf-8?B?M3JNN2NOVWRkdGZ4SnNEc2ZMdW02OU00UUR2Z1MxeFZIbDdRTjF2czR5SzlZ?=
 =?utf-8?B?Y2NTa2pnNCtkWFBiUkRkRS9vWkk5OWpNZ0taM2YxSXNqaUk0ckh1cmhncmVx?=
 =?utf-8?B?RGJuUFZGMTd1eithQ2tDWWhVRmpTNTViUFpqNDRDZEZBTm1hU1RteXV0TzFK?=
 =?utf-8?B?ZWM1NGZCUmVxSXU0a3I1ZytveHVGeXhyeGl1TzlqMmF3RGx5N0NpNGxCeFli?=
 =?utf-8?B?RGlYMkdXOGxHY3JXRmlWVGw1b3VEYjFOWGhhU0tqbzVuM3RzRVcyandva2dV?=
 =?utf-8?B?SkZFWmkra1YrU0VlNUFmb1Rhb2JYRHQwUjdVNzNCb3FMRnRTQ0pGaGJ4MUJ1?=
 =?utf-8?B?YklTTDlPSG5kYlpReTNnYzd6YzlEVlN3T1hWZUJvWGdVOExMak1hSCs2WFIx?=
 =?utf-8?B?MUdWb0R0Q2JjeUhKclNsRk5nQk1laFJmTm5LamJMVDFEcWU3WitBbWs3UE5l?=
 =?utf-8?B?QjdzeWRZWlZiTXVPSW04YVJmektPL0laRE5pRnJDcXAxc25QZHJ2SEVyUExS?=
 =?utf-8?B?TmR2cVhzZjNwZGNPUjRzcFJSdHRDcFJ0WjEwZkRuNTBjd2loZXd6dnZmRUVy?=
 =?utf-8?B?UVEyNFFmRHh1MHZYTm4vb2tsRjEwckFGT2F1bW1ibkJQTEtxcGdvNTIxRDZK?=
 =?utf-8?B?ZXQrRWltUW13U3hKU2RidWtUb2VrbUhqMEphZURkV2xxTlAvemV1ZXIzNi9B?=
 =?utf-8?B?Q1pFaGw4YUVTazR4d0xYZzl1ZE5hWFFvcGF1YmRuOFJtbmkzc3NDcmhwTXRi?=
 =?utf-8?B?NXBjdTNFZHlxeXdnT1dTaE1EL2NQV3gyZlhjSHAwR0VFKzRXd0N2K2orclZp?=
 =?utf-8?B?aEI4Q2tOaW9FZWFvbzNPVlI0a0U0TDF6Q3BDT2ppc3BiOEpvRjU2NGNEM2VX?=
 =?utf-8?B?elhESTFtNkJzY0hGSUpzN1cvQTZHazJ3c25OSHBOM0xpcWdaR3hpSklQRU1Z?=
 =?utf-8?B?SW9iTlNnTWlQYm96UDRyRS83aHNYRE9ZbFBxSkZMNy9hSlhyOXJUWUdua1Q4?=
 =?utf-8?B?WVNqS24zdDhJeVZLM0ZrZ1hFR2NCcU0rL2ZPcEExUjFHS3UyTTF3cFRtR3B6?=
 =?utf-8?B?OU9jcm0xQUhmc3NvT3FGNGdwV2hVS3JKSzJIeWlybzNsZ2I4OGdGc0xPT010?=
 =?utf-8?B?aDd6OUx4YUlVUjU2Ky91d2R5WmRuNEw0TlFvbCtQenB2Nk55L2kxN3M1YVkv?=
 =?utf-8?B?UHdKUTFaZmp2Z1J3M3pxQi9vVFlmTkdSQlNubmtVSWhvNFA0QzhsamZOa2dq?=
 =?utf-8?B?NzJvbEM2MmdhVmt4N3NFcEcrQ3pRZGZqWHlKSDdhNGE4RmVPZTc2VEdJM3Q3?=
 =?utf-8?B?UkN3QkZvN3dQbGc1ZnJIN0pvaWVNVk5ObGx4L0VVMnNLbWtOU0xCMWEvMzQ1?=
 =?utf-8?B?Z1F6dGFicnc2UGRJZ0xIMkM0Tmt5amJib0UyZlQveHkya25tMWF0K2pjcDVM?=
 =?utf-8?B?TFF4ZWVDQWQzc0N1N2hLT1lGWklBR0xBaVBNMXBwajVhVkNtSWkxUFlFMzRY?=
 =?utf-8?B?SkhZSEdZSmJueENPUTZaVWs1OXczWC9wb1gzNTQ1VlhqN2d0clVpSFBGUCtt?=
 =?utf-8?B?bXZ2eVlDRXp1YnV1c1gvaVIvaVl1UmJaQ3ZkRVRuQnkxSEdydDROMC8xQkxZ?=
 =?utf-8?B?eEExczlWdEFLT2Y2TmpwdVNCbFFJdmVRTkxFdVZ0R0dQTGQ1ZXYva3B3b2Qr?=
 =?utf-8?B?UC8wUHUwOVpzWXpQR2xMSGI0Q2lKb1MvdHhxZ1o4Ull2L0lRcHNCS3lPSTBw?=
 =?utf-8?B?WUR3NVpqYWZ3NC9BeFE2SjFlZHZSb2VJUTJvd2VWOWhIMGd2SUN0RmlEYVAv?=
 =?utf-8?B?dU04enNwUC9lM001ZHFFZVFQY2s3RzZCcWpXUjZIbXpOMXNwME5lS0xwUmd1?=
 =?utf-8?B?dTZzY1RqendoV0VocEVwTjA3UUFmMllkdmNadmVlZDFaNEI2RVg3WkhMZjg1?=
 =?utf-8?B?NGJoQmJNcWtvSkcrTTRnSXE5djlMcmoxU2RJTThzeHhJTFZ0TW1ySzF5TUNV?=
 =?utf-8?Q?j5mWON/chP+oHXDf9FiRCk4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v9R/91xH2vYY8xLCR3l62sis38/FtxWCR+ei8yPi4r7UhQDLZ29lrwXCNbmQtxS/ojguEDGTpNcPNPD6jgVMVGDF9wnbw18Zh+luZOagKByzbjY8xVF9MlUwY0QUe4dX2y3bt6vzksGesm7DoM8rzjL7OrWil2MGe9g4RkJBiQSN7d87TFFzgGui//N7w8824WiVgKzzo0Bb4Ai+N9TmGe37iHatbqA/v8YDSwXp9vLHuUN4FPpiJqMax6WC+8F/XonscuQKAv5cAgyGiAbbY/W+1ZZXN3cgdzJUlSTlemUiktpW5GK6JI6+y4KWKIUXaBfYnXDoCDPF1qzTu6S0NJ7b8p1gF9dF+9RZ3DGGpsOCfdnRnMxxsIrJjuKYCLQ8+j5tX+fRl8yxVsQtOnO4FO69NG9x0xeI8pg8esDFjc61gm9zxUQGrWqggPbdFbsM7BloXqdkpoFxyyr7aaCqidgoWXvjYMXhXm0GJcFWCOsnHXOHBAiJ4tAhBhKTnLS7UAXykU2WcNrkl0QCCtU/QzcgUKbSWJ8o3mdq+7Y2KAd2v1RUZ8kqJ61gqC5pnbZKkIqH8y2AaFcAvMx9cDishcO4LLcx3eDyAHTEuYkRNLQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e85b4aba-41f3-4470-0aa5-08dd7fd83088
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2025 06:54:26.4634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7JYdUtj1EvE+RaYtrI2/6sQS8s2Q6CynwXwcacVRa5SMU2FZYO9UT4z4qh3weQ45poZ8V7v02QlZ6VVnOIH+6GCiPzCmBwIMY6E58HHQgIwmWW/Wj3nxVW0JQhtXFk4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF842B33876
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-20_02,2025-04-17_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504200055
X-Proofpoint-ORIG-GUID: ClnN2GwBOD6jCg7OAVLMeYhWnWLBxVTG
X-Proofpoint-GUID: ClnN2GwBOD6jCg7OAVLMeYhWnWLBxVTG

Hi Greg,

On 17/04/25 23:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
