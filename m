Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AFC4D7976
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 20:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789590873; cv=fail; b=GnFGeYWSZD59ImJoR4roGub5AX5infFBoLc7ykSdNT81w+Pvn8j/i2C2DOl5mmpy+caQiU1EJOTi2L1EkqHHmEXFk99Sy5B0ZDC2SnCnph+vVDtpCWjktD6ayM7FqiBB9wxc+4xdD8XSZvEVPej6swzfAhj98Gm6WYAJq5F4mRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789590873; c=relaxed/simple;
	bh=BFzOPfYuMhuWa5T44NqiL+4lD281F5cIuAi3KWvuwYQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VGRWyNEf/e0G4f6biAwR/xw3KgLqGwBc+Bjv5x408rdw7Ehhdc3Gfgo+Su4LHrY50JLu50oLXSlz2gvxjmEBESA6pU46E8O6fp95ns5kq0URZcvEzRt65QgZ01SIoImqL0JejyPDKb7YF9rsXnuvoQ/UWhe403BdygXmppFrYak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U+zYeCXC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F/oeUg8B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U+zYeCXC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F/oeUg8B"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEBch12190098;
	Wed, 16 Sep 2026 20:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BFzOPfYuMhuWa5T44NqiL+4lD281F5cIuAi3KWvuwYQ=; b=
	U+zYeCXCcM/lgSCqpbaBMvt01h/l2tarNYDgK7Tky2KGFXGLH9seEvtPG6iYTZJ6
	V0qGTzp637kfsFs6ZtUaaAHEZzgMJnke7WGSdbTVonB2BtgbvepM9Z7fDGOCXEWz
	8Qf1QzQW2ehMQJmWHRJR6pcA2zhtOmiXVQLl6yVdFURXuZOSfhfc5kqmo9n8gm2Y
	IGwa6mPmBGWeXK7dXicsV8nEW5jPddAe+8V5fSfxE6djfyEBisay3PFFTZbPYvbD
	Nn7/M/UbSaTq97pp3XsFLR/0g4cF0ag/U3k0tS7qDDh5lYgA3o1aOkWVZHLUiaRe
	IIwbKmhxaZS0K9A0q5YgPg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmy9rxc0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 20:34:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68GKUTgH028011;
	Wed, 16 Sep 2026 20:34:14 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010018.outbound.protection.outlook.com [52.101.61.18])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6r0q42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 20:34:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KhvXeFPpiVmJYLhmYjfq2YRyDX5GFYpvqTveK59VvFI9Tf9RuDyiM+iabESQk0crN81CIfvqnn4xmXbtEF2sDAbBrGvg3OPYI9ewH7ksgAbgHNRpVoqJyG+xkG2ZSd5l6b980KNf8SVl5NLSwtwWszLq5k29cndGEpXBR9UQkp98zNYX282HKLql8ZT64J6dcLySDe/p0J9rQZ7dFu0tUNV2WlRc8Ntq1a5CIO7UqkOzIqA11ibfXor5NsRW7NHtLbYCXGxZNV9DXmJmXVr6SPJrjJ5LUQpHHWe5Dt8zxeDLejHPYUZJ0U/8MDoSSE/9iKlZa//FnEcOOkN57qP1AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFzOPfYuMhuWa5T44NqiL+4lD281F5cIuAi3KWvuwYQ=;
 b=sDOqb0hNt1RbYV2w3B8PQSgh/EtqbKLAcGH5+Apgf2LDoOCGHxq+M7ZOtI+28p1hvIyf4qG8OgBbtScOqX0q1wFUnW2LVDdUThMVslhSxyxGfRQjpQ2/+30bYwPYqQI5Eas+4TSpj1UsO8zwPyYUnQje4U/uKMGVxtruy8O+NfqG6Jx1VjRT2F19iJ6zw2M5poQDm17yo0VU2lNS7e3KBofNKn16CBMfTG4N0ECEB84atx567DDCoOskjS1JNUWbHtc3qRJzl0/qYMU9yUf0IvbosQcbwccAseSyQCrU8mN75urILBcjjTiqSK801aFy6un2Ik/Cd1O49q3ql1NL2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFzOPfYuMhuWa5T44NqiL+4lD281F5cIuAi3KWvuwYQ=;
 b=F/oeUg8BJYqJH6E+jPi2riUPn9Z7vZ+C9tJs0CGelwOMX2RzGMqDxQon6cvLkHpkm/JZ+/kSqjEq5ZC5kVomz5zDuaGicyq9LMzb6aJprUXxGnfBMzhBY4o67g8kIpra61QJyngt9ndv151d2aKktuqZeupnX/0ihNtVyWdP/3c=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA3PR10MB8707.namprd10.prod.outlook.com (2603:10b6:208:571::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Wed, 16 Sep
 2026 20:34:01 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 20:34:01 +0000
Message-ID: <462e82c5-4dff-455a-84ab-41ba573d2fcc@oracle.com>
Date: Thu, 17 Sep 2026 02:03:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0505/1376] crypto: ccp - Fix memory leak in SEV
 INIT_EX path
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, Atish Patra <atishp@meta.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <8552fcb3-e14a-4485-9f86-52a0c5f6119d@oracle.com>
 <daily-reply-20260916-0003-re-ccp-sev-deadlock@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <daily-reply-20260916-0003-re-ccp-sev-deadlock@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0043.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::16) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA3PR10MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: ea07934b-80f6-40af-cc6a-08df1431d748
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|10067099003|4143699003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	j2yFtCMqPkuI+pf6g/Wqm13nvSa7HD3TzZRmPVBHSbRR7NdXJ8/j8xfGFZLYDatYSBnNWj7qyVwyU/HiBQKAsBiJ/oEwRrEEy/hlKXKZ+bJ8TxgucpoeUr+f2XEw01JLLMPWz6PpHQngwjaMq1NZ+af/BROOXrA2RbImcDMazR9cYXrl98kna5Uld5MS8hoQsy0mmtNmxuoduVLnKr+/QLqIy2rZklDEXBZ68nA3SomiNxurlq6G0aD0NZZ7547ncYMlTNFzATwhJmcvwTJB+GIxc5q8pu9iGJESg2S7LXyrY1l4uqizYcxQzQtOSU0RwkbDHArTstmkpNsJPqNiSqaI5ZOafXORzF+q2AA8ysVIzG2ZLrfnUFpcf0ozptGdrz0ZrP0W75OSiBPaxQf1DM3Fuhn74+OX0P99ZgtVeCNCtaY+qP5yjGIDx3qQ54gLvI0TWCS5sR/+ASsyANDuUrbUD2UlurXrw7faTW5ChpRBTIjphuWZ7Ru38jfqbDjXtNAWKaD5huROhKULFgRBqPJd/nt+9V5yy64IUl/2Iy+cvPdXEppT8dDE5g8JtQgLtYSS0FyZZtTOaCKyvtwzFV3OVaWl3OMEwtjuxChcrm2Bk6sG7xgVFkTkTlkAzW9vyugomc8dHzSQSEJmOuUjjMC0RAv1bB9vddI9a8CsV5U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(10067099003)(4143699003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q05nSi9qbkdrejkxN2lvanc2Y0RkNkZrcUxkQmJjMVVUSGRqSEUxZWM0Uk42?=
 =?utf-8?B?VDlFcCtzVWw2WUl6NHd3UURuRG1oVUhpK1FiVEhJWmZKVTloTVgzc1JkNHRs?=
 =?utf-8?B?RC9JVVBaVk95ZmxObExOTkJuVlVINjZvSGVESmtBQ3RYYTdDVGwzRGVlNElz?=
 =?utf-8?B?OHMrQlY5Y2VPWVMrMlFlR2t5SU9iY1ZIVWx6bkpXZ2cydmFORUVrdFdSa2Zw?=
 =?utf-8?B?VkxrTG9WVGdhbGZPUE1zaWNSWVdwOSsxbUVBbmU0MXl3WlJWN0hlSDVGQzhl?=
 =?utf-8?B?ckRCaURkemkrVzJSVkVuclk4aFprcGtOQ1V6MGlPVU9ka2Y1eTRQdlN4RDUy?=
 =?utf-8?B?RnRoT01VY2VmaDA3VG9rcnZyYzN5a2pMOGZaVUNXUzJ4akNjbDRnSjkxY1p3?=
 =?utf-8?B?czd0YWxhbUljTXlRazlSWml4YUZDUTQvWE12UWhjVGs2eUlTWm1iYlNUcmVr?=
 =?utf-8?B?ZGh2TW1nMTBDaW1Fa2JtUE9WOXJGQjVYa054YUxpb3ZQSmhpNGhocGxscmxP?=
 =?utf-8?B?WEFMUGRWWEdMelZ2WFp5bTI1UENCdGVMUjViNW1EOXVVQ0lBS2JHcDY0TkdS?=
 =?utf-8?B?SFptbkVvQjYrUFdsTU1adWNYUldvSVhKSWRaNFhVV3dpN3Nyem1rbDd0RHoz?=
 =?utf-8?B?WGpBSldPK2R5R0JIaFJ2YUxDNnF5Um1zMVh3aDRBZVR2WnVzMEg3bkNzMUhB?=
 =?utf-8?B?clFvSzROKzRncmNuN0xURkptYTJoczQxYVc4TzVJeVFRaHQ3b1d4MUN6bGJN?=
 =?utf-8?B?ZWEyRHFZemNtc3JqWG9lWnFNS3hyOW1QYkxYTHJoQVRybW5kMS92dmVqTVkz?=
 =?utf-8?B?TVo0MlI4YWFUVjA5OTdieGJwamFUQkw5MHJReVFqTkE5S2hNTlBkWW54cWs1?=
 =?utf-8?B?RXVtV3lKL1ltZkVNUTQveTIxYUdEcUpuWDdRbVZtbzZNVkk3M0pZdkxPTmhT?=
 =?utf-8?B?eDVpMEJTcDdFTjdrc1drM3I1UXdxallJZHhPOTZVM1FYd1pkaWVhWWlwRzg5?=
 =?utf-8?B?TlJOdXN0TytXK3lLTGhxV0FQWHhIeEMrekpCNkFzb2hOMlBvNlRkaGt2MERn?=
 =?utf-8?B?TFp5R2htUGZVNDdybmJGelM2SnNoSU41bXppdVdub2FRaTJSVzhWSXN5YUdD?=
 =?utf-8?B?Y0NQTS9raEhoK3VMU3JMWjdhNTZOU1lJT0RMeHlwZEtIMU9RbUJzaDUyaEF3?=
 =?utf-8?B?aFlseG1uNmYwdzhEL2JFb3g1RHE5bG01L2JGa2s1WXlTQjJrRjhGM01xcWZK?=
 =?utf-8?B?OXAzUVVYd1FiaWZaaVcxTHlidWFxZ1gxYnoyN1JURmhEbGFsUHZQem1VdVk4?=
 =?utf-8?B?UkZObExVakcrQTRwcjAvemNxQzVrYUJocjZlK05vZE9qbTlWakpYUnZ2WVcw?=
 =?utf-8?B?b0JLcDFtaWVPQzVGZGxaUXhzaHlsYlhpQ2R4bC9Rd0F0NjZ4QW1idG5GMWZ2?=
 =?utf-8?B?NWpQbnl4SFdDdVozbSs5cllqcGlLRDMrU21XcmlQeWFtOXpQRTdLclYzOTNX?=
 =?utf-8?B?bXVnZlVmL01wMUVabUdDOHhITzBUWnI1NkNiUkdTWEMrK2pyeXhEVUE2QjJO?=
 =?utf-8?B?WlMydWdlWTd1eTJEZ25lejQrYlo4MjhSV1NnSVJhaWZtcVc3dTJYRVhVK0R5?=
 =?utf-8?B?M2dBS3JUa3lXMUxha3d6TWZ2bEV2L0hXWUttYkpFdkRnQ1BQckp1VllOSXcw?=
 =?utf-8?B?STk0azVQdVp1S0lwTkgyLytQczBIUHRpZDEvc0VsWkNTako0RWtGM09IV2Jl?=
 =?utf-8?B?a1hvbU9Lbk9zWlBDK0MvM3NCQzF5ZFR1RC9NWndTNHN6eTVRUktiWEl0TjZF?=
 =?utf-8?B?cU1mSzVWcm9NalhFaEgyYytNZUszQVlITHQralErcXYxaVAvaTg4Q2NhV3J3?=
 =?utf-8?B?azBYYnlEZzAwVTk3VkdBRFB5ZXpFSDEzb0Z2Rm5NSUZIbVVWaUtaTnlrUkJ3?=
 =?utf-8?B?L1ZleFlqNUVFRW13bVE3cWZDbGM2d1F4bUY2VG5QRDFPc0w0TTVlQWRzcStq?=
 =?utf-8?B?S2ZoNklKVWRQeFovMEpxM3lZYjNJR1M4SmdDb050bkc0bmIzelpKejB3UU8y?=
 =?utf-8?B?Y1VNY2ttUjdIR2tZeXB4cklaRmp6YlJ5dXNGWStweGZtN0pEZXMxNkVrdUJi?=
 =?utf-8?B?OTMvQnYvRVRleGxTNE5Ua0ZUK2RZaWF3Vm9paXIwV1pWTHlqaFFQdDVUUEx5?=
 =?utf-8?B?T1d2a2R6cUtPNHo4cTdXblhxSHl1Y2QrOHFKUXBFOE1VZ2ZSdlNFMStCYzRt?=
 =?utf-8?B?L2tiTlQ1TWd2b1lJaWxad2VmdDJoOHlpUkRKcFRVNThXVThNSWthNHBUdExh?=
 =?utf-8?B?UFFkdXNDaGlpelZSREtLNXgwZGI4U3UxcmR4TjM0TWlybU43NW9hUUhrNnhQ?=
 =?utf-8?Q?19QnwYbFvQnckKpTDmuMtbM9v5eTyGGO07wN0?=
X-Exchange-RoutingPolicyChecked:
	TG2qhdv9LOeWDfM27IpLujGTqP12uRt0RQtqGMBUiuMCqjabTPMViflNd5z+0inBldKFF7agQm8qPf/1/3TsXBmSfow/n6rgX3iH8U+staqAIvN0CvEppTlA8vsxse9npdz6PtHm9pTntxEcNwBEkjZWmCvDX/kSYOlrmLYW+m2d7vCIG9F3SaqEhxNLqIQUW1CiBasTSkbHLiVpLIZFno6tdEnwPr4zM4+iKYoeHBKsVmd4vG/jgu8pr1s6ucIdsOVnl9e9yh9/fUvBKByigTDbbD3eEBRWrVt7PMWZpN+W6G1KuO91zkF0eldsm09+O2gIgSI3BmCpZPZmK7ogpw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	scJGNyCPPQPrqmspzTh275JpvQVAKdaF945lo06Q7OhlAqjCjBQ5Y5/7FhbsTDbaFg+VaL7X88m7MMIQjuTEBugFWefUlAlcb0g5nHPStns1IcHQVh+D4bj9uwUMfOoLCl9+9nG9FmQX2/iLGweA/Lf3W8kncTHlQh5Tl6FppfEpUKXXUDy2Xm5eUMquVq+JInsfZhc10nVwT20fbVu50U9Z2pWXl9gwljYdFlUHNgXD9eaxcgAWyuRvSc2e/HVzZj0FOS+MbbR4M5/kUt941OCdmRNf2spUWbvGMwJ2P1m7NWWoFsIjWPN0PrDhXNK03oMLf+7ARt+YsMWhrho+8udAHg/NJSfJhi20UMPWJkXoP+mtrcvmEfJhrMeVXkfjt8oSSmPRqGLxqs5WlnAx9n2B0YZ+x5RArDaQabTPdQFciaeIs+tPkuDKdQqfTQ3c3RjQSvv5KrOuKJgJf1pOUqIuD/TOu6QqIISu5fiPfwcxJkMtTYlT2mEWu/vDzPgWLBFT/7RNGhj47X4Aw638Nm1BgQ3GfU3o06D26Uanywof12n72xyrEsmVv28Ui2FavhwGjwX6agZWmnMmH0m06rhUA6OboiZ+kvcjF/7Rxa8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea07934b-80f6-40af-cc6a-08df1431d748
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 20:34:01.1695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/i4z7Ppi8e0pNDdRbqpfsvRbY3UUGGbssLIX2ns98jy2w6ALCqV3vrvH3rxkicBunNJwc7gQJprwFOUI792iEeNIE7cbFE8QKz0bbfS2M1JOTpkSH114bnhIYXM3le4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=918 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609160284
X-Proofpoint-ORIG-GUID: CpAN-dQDHoY9SdmGa6aaP9ZmPUQynkPr
X-Authority-Analysis: v=2.4 cv=MuvHeGae c=1 sm=1 tr=0 ts=6aaafd47 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=gcNM92-u3oWex93Be-sA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDI4NSBTYWx0ZWRfX6KNQU7PUD0mZ
 UQjTQVpmwWfAcz/5AFpbwXWBj4N7qNEL2Y0XuLaID7Vmq8bBqBqowO5GMP6JAPTA3FycCMHlBw1
 /4yjeiJXmX8rZ4nubTdAREXLAplRkmCJBPctTH23pVuu6SKc2QZl
X-Proofpoint-GUID: CpAN-dQDHoY9SdmGa6aaP9ZmPUQynkPr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDI4NSBTYWx0ZWRfXwT1t90C9ts90
 ufv1BzZD6QXyJ6Ljh+MHG3yvd9Ru/WYpA6MuaPW0PBseUQ2mg98hz7b5n720h5L09H8fjajtcZB
 s6dovlseCo1jQumwBXLp6WTnZvT03QF0UBoR8V6dBW5i14ukgRSwOv0OeGpfo6D6f2ZaKxik4A2
 CFjTSTbxSthfkrjo7IGxXXE3JF2K8qk+o9bTxDES17Klx5KiEL/Fx62IExP6VslfWaPP4ZBPP36
 otXDzwDrJJgaRxCdDKFM8P/JD5piIicGNdAn0V4qVNbMVolid+NcBQPNZYyHccBM/tNTVaM5uZh
 PF7UNNWRpCrLSwa5PcA1MjUViXtA6pFW91YMOwopIyJ2Eb6F3hGsITTxMjmvIkfcxBtEp0t8ltD
 RqxIP2shqLOX7/mfwITytAEEWlMCifw0IUPwcA+DFUTNK2QHVWbT6C2fgKiMdWW4ZiMvgI8mp6d
 R/YQqRyoJ/LSK8V+9rBL/tVgNvEXdrn8CuX8orWM=



On 17/09/26 12:57 am, Sasha Levin wrote:
> Queued for 6.18 and 6.12, thanks. 6.18 had the same gap.

thanks!

Regards,
Harshit
