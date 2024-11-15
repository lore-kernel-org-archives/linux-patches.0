Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391E517555;
	Fri, 15 Nov 2024 07:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654065; cv=fail; b=ZgOED50KSShWIiEqlI1GBv/++jcbOT+q1Uq7jhYNU3zA6OaGxenwwnljLk+8P5maKyn1GctpehkQJvgatilyp5U9HGziTtkWW7pbSmtcvqxCKe72f2+NxGcreOs1uvdqy3BZfF37dJFqFVrCEJr4Iu6Xkq73XzqU5QSX7yZqv1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654065; c=relaxed/simple;
	bh=0LaIV6KFxTKtkhlKL17nX5J3iH0I+vEv72kJeyjvGG4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G2mWOLD7h371xUw/mQg1RCG5ErJ0M0Ukyfdphr9NqxL2eJoo4jyG3AOv+Fx5dweSboqeSe793xsjljcKjpu7D8nmaILl3weWrf6GgpccRF9/N+Am7CJlcFhJc+nvdqlUlq5Xlg5Oxsst9xVMn8E1rOk64fhOdJUYzj56oA/P/qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I1Nx6pRx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Csnd/hZF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I1Nx6pRx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Csnd/hZF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF5XmUb012534;
	Fri, 15 Nov 2024 07:00:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vVPonNpFxDmqJKjpRER0SkxauFgi4byZPa9CtV7VIjQ=; b=
	I1Nx6pRx4ZAsHseZlDMJ9cX62SBgWpbtJ+ZDZ03NOqzsmssZZ4figMGWu2Q3c6zy
	vuqCcnGqYHfADTnWhqKrSMlkP8goFxV3w4UDRZrWgJC5p5GBYp2KV4FCh3+RPTKo
	t4G4wo701GVdIBCTjuGwwnCKcI6jcASEtCgAiXCQnB3YULpvmmaf+Je39vu6IxCm
	MIHSo21AnesF+llrKSeddp/rnNTGX89Vl+k4oNdkKkOkBx86wRiarHgy4xkjzfak
	xwRAJK3CdRYVTu31d2cVba4WXYTcrUzbg1jAg8wkYsp/Wj4Hqp2M4X4dD9VxS6tx
	ZIFQN7e8GKXbRCPgOOcD2w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42vsp4mgwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 07:00:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF5tYsu005652;
	Fri, 15 Nov 2024 07:00:56 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6c9bdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 07:00:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MP8Kwj8LxsmgcDCE8PcsK/NkDE/2umBYsIAIC9l9Xu11PZCabGQ4Y8dGKyi1DuHtk7Wcwx8WAwXboFjByRzRAVFJ3H6WQ4bGcEOp0TeuZf4oLRhUUsllVy4b53hYXPl1gikiVsSVdjn9W3KhsLOjcaY5r+cC3W9NRmT2HtHsqsyTwToEqfNpUMeSQ/4iSEuAzq8Hp6fooxv7OUQOVHNGA4ziNDAOu3DzdQPCM34Yh8G45uZ9X7ow9h33kg8GZ2kJR9YtCihxd2q8yzDJovmQL4ZaRoHY+vucMxamTjcLfRxLMN0NV4R6WZKPs0HwmF9VvRZSuD/3xmL6ADAa+n5hXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVPonNpFxDmqJKjpRER0SkxauFgi4byZPa9CtV7VIjQ=;
 b=efWGMZCNtVn8i+ed7mwvIxVGkgFcXj+/hAm8uZXnSV1VgcNHGmVujlxY9k6tKGw8WDp5yFUOhO+3RNy9iVtZNYTk6vzxdWDeKF6hhVY9iUm+vvIVvXgrCjHl7Y9Dw8izVSigYXauB54rgq08Fz38rhUZ+3oLecbLT3rWzeg/4vD2I42b3vudSxX8Z02bN3p6tbXRlX16p9z2mQeyOgw/gL/eZHm9f6eR/FSWJIEQf1wuQeSuXhScl07yfljxvD1a9DBy57IGP8zMDMa/6ylXTIzCIWE6FP2oDSObGaJdcgszgGiT7BTGetZrPl0Xj0CkEu2rSO5cvDK3BnV4U+L5IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVPonNpFxDmqJKjpRER0SkxauFgi4byZPa9CtV7VIjQ=;
 b=Csnd/hZFmwAicHycFKU7Hmm/dLhsJcNBqImzkB4JnresbytCAS0qheFqTuD0Cye3/UDrn1ANQdCBGaCJAnpUQAXDv2ya55yIqq8yf3ItOvOpc7u/71Gwbk2FPr58mSELNLbhu7nLmrvHfmngfyvZ0yeDe7hk1tJIyfcOMs2em5I=
Received: from PH7PR10MB6505.namprd10.prod.outlook.com (2603:10b6:510:200::11)
 by PH7PR10MB6354.namprd10.prod.outlook.com (2603:10b6:510:1b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Fri, 15 Nov
 2024 07:00:54 +0000
Received: from PH7PR10MB6505.namprd10.prod.outlook.com
 ([fe80::83d9:1bf1:52cf:df54]) by PH7PR10MB6505.namprd10.prod.outlook.com
 ([fe80::83d9:1bf1:52cf:df54%3]) with mapi id 15.20.8137.027; Fri, 15 Nov 2024
 07:00:54 +0000
Message-ID: <4537b145-3026-4203-8cc4-6a4a063f4d96@oracle.com>
Date: Fri, 15 Nov 2024 12:30:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 62/66] mm: clarify a confusing comment for
 remap_pfn_range()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, WANG Wenhu <wenhu.wang@vivo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
 <20241115063725.079065062@linuxfoundation.org>
Content-Language: en-US
From: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
In-Reply-To: <20241115063725.079065062@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0049.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::13) To PH7PR10MB6505.namprd10.prod.outlook.com
 (2603:10b6:510:200::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6505:EE_|PH7PR10MB6354:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aae305f-5846-461d-6b89-08dd05433f75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlpjT3ZyWEFUZ2lucDdQK2lVYVVCd0MrbTBhRjlwVHZ2TzdlUCtmYXF5NGJQ?=
 =?utf-8?B?Umh0MTBIT1BodHp3TXRqb04vZVdJRjVYUWJrTTBEWGhLTlcwelRFSHArZCth?=
 =?utf-8?B?SzJpdUMwVmRrYUM0S08xUXJtVFhUdDJsd2NWVDFRc2RUdXc3TlNEWEFlSU1u?=
 =?utf-8?B?Vng4eUNCN3VhL3VBZHF0QTNVWXlZVjg5emhSc0hLTG5yeEhrSUNvZVdYRWZG?=
 =?utf-8?B?M1NlK1pmOThLcVJJUjY3ZFA1U0w4TWJIN3pNTFZlUG5nbkhEakRDYkFPSnFj?=
 =?utf-8?B?TE4zZEdaeGJLc3VHNEpnMU1DVS85T05zMWlFVFBwVlFDQUMyK2JxSjFXVng5?=
 =?utf-8?B?TlVwcWwyU05oandoL1BOck5wdW9ua3laR3ZOVjZEemIvQkhyNllHdVg1K3Ez?=
 =?utf-8?B?RVBZbzBsZTh4SXNBMlh5QUMxYmpLdkd6QjRER1Arb3JYbXppT2FLRmRxS2FT?=
 =?utf-8?B?bG5SdnZHY0tlcmJqbU9RT3J3b01hUDdGRWoyUWlWNk5OQnVGNzBoUkJJN3Z6?=
 =?utf-8?B?TCs5MjZLdTRjcGtBQjdvZnlhN0pJbGUwWEpmc3pLZk5NMkNwdUpra3Q4TnlL?=
 =?utf-8?B?WVJQK2J4OG5RQU1tNDUvYTg0YTlYTy9KNVNNbGhEMGdMc3Q1d1FYVk1sL1hW?=
 =?utf-8?B?bVpsMWFpODMycjFHdVBiRklRSDZpTHVQWGhFRkV1QTh2L3BvUUZ3ZG5Lc2RE?=
 =?utf-8?B?RTA2RUxqTmd2cFUxb2hUV2VTalZPbXlPV1pLVnVFU2tSOXgzbGgrVkpENWUz?=
 =?utf-8?B?ZW9Ib1hjVkpzQWFTdC9vdnFDbVdCU0J6THhhUm41K2ttMHVQUE9UQi9uamR2?=
 =?utf-8?B?TEZDWm5lSENiTVZwM3lPWFVQdzhZVmoyaHA1dWNadTljTWV1SWFYM2dOa0JE?=
 =?utf-8?B?bVlIWkpYQWVGcFI4QkN6R2pjY2kwZGZyMUJOVlIrQWhYOHVnck1IK3pGeUor?=
 =?utf-8?B?VHBhYmdwdWZBZnA1WXVUNFM5eDZpTHNSV1BpMG1kNXZORkVtd3VIWlV1T0t2?=
 =?utf-8?B?ZzFmaDRGdUhDZDd5dUpCSGcvWmgvTnlqQ2xTUGRleVFxZUY0OVhLVHNwbVpE?=
 =?utf-8?B?Vko1djExVlF1RmViZjRYZTl2TEx6bE9yd05RTlpIeVlidFl3cURvZDFKMis4?=
 =?utf-8?B?RktzMlNSTU43M1VFZWlVNzZqM2FObDNsZ3VWWEVnbEVqbnhUdE01OHRubXpF?=
 =?utf-8?B?NkozT0FmckJUQ21RSnhGWW13YU54ZUFwNElwZEpONUFLVkFSM1VLSXJ2a2JW?=
 =?utf-8?B?V2NIb2hWRDc0VU1iQXBHcDgrcVpscDZ0ckNjOHk0ZUJsbVJqN3czb1cxNkU2?=
 =?utf-8?B?RnVvMU91bXMwWGlLbUpvM2k3d2JlTjd5ZmY3WHh5aXRHdVMwREJNdXdsbis4?=
 =?utf-8?B?ck1RWnM5RVl1QlZVa1lLUGcwUkxNTDRjOTY3RlIwUXVlYXBKdy9abzdNeWZP?=
 =?utf-8?B?N2lSYXQ1MVB5RWZ1S0FRVUtwaXFmMXV2T2FBMWsvWkgzbk1xVmdFZzBMYVpL?=
 =?utf-8?B?a3ZPbEQ3NnBqN0lOODJqdVVsWmhmSWdVV0FtaTVvZHYyOWF4U0VwcEZPUllB?=
 =?utf-8?B?U3VLQ1dES3BURVJucUVCNFNCUG94WkVxeUJ2UkZEa2t5UVc0a1NZYW56ZlVH?=
 =?utf-8?B?bUw2VnkydFYzamFMRXFseUhsR3oySWcwMTVPZTljbGpYWEU1MkdmWDJTYWhv?=
 =?utf-8?B?b2t3MXd3MENpNk85Q25sZTlkUVJOWlR2ZFNaYlJZTzh5cXRWNlFYUkc4KzFM?=
 =?utf-8?Q?9aZyJrH5IiT8eL4o9rhL9L/AEP/g42X2jlkjpIY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUl3bW43SWVPOEhhQ2dDWndSemtodnY0U1ZFK29YaXJDZUFheG9CZWpaMit3?=
 =?utf-8?B?S0pKZXMvbkdXQnZIUmw5azlMYnpYelBtdWs4Tzgycis2RFlSdEVlQkZsNHBu?=
 =?utf-8?B?MENON0FPS1BSUmJiT3ZlVnErWTRtWmV4cGo2WTlEbHZLMHdON0VjOUJQTmhZ?=
 =?utf-8?B?RW5pQUplbStaa0VVeVBDV3VmRGN6N1pXRnBrVmJaOE9EK2lNLzBMblMyWU52?=
 =?utf-8?B?OFYvajNvNDBGSzFPR3NDQU9oY2xob1hPMG53eGQrR1F5VjhWSW93dzA5WmVp?=
 =?utf-8?B?Y0RXRThaS2V5RGx1cTA5WGpPV0NhN2xiY1NVbi80OGluL1l5ejNlOHBuVjZ6?=
 =?utf-8?B?RVBzQkxDUjEwblJnSVJNMXczNWZxb1RMRkV3SlRTR2FTc1ZZQkU4NzQwTFlC?=
 =?utf-8?B?Z3hZUlZ0UThUb3lHZFI5eXFCQTEwUEc5Smo3L0dkeGpuQ1hPcmlHOTdYQU9D?=
 =?utf-8?B?UDJ5eE5WeFlVVWdNU0I5dFhaSXpZTnZHM1dzUC9WNmR5a0FhQW9DTHRiVnFa?=
 =?utf-8?B?QWgyNXg3OHFDMk90WXFiRW9FVE9NMmFKQk1CYkNmeWRITTd2VGkvdlBBMDV4?=
 =?utf-8?B?bVBzQllkRGxaSDhQNmdMVUdqdlBJT2lLZkFaKyt2RTFIbVNKOXQyaGc3WXpC?=
 =?utf-8?B?TjRXM2lnNlFxYVc4VVNVVTZqL1ptYXZFd0x0eURRT0JKNFZDd1I0R0pwU1Jw?=
 =?utf-8?B?OWVkbnpUa0tHNWQvelJYS2FjVXZ4OHYyWm8rV21Ub0MxWkRRN1hUWnloT0tn?=
 =?utf-8?B?NmlLbkp3ZHVzZ0EzdGxEYUE5bEtoU0h3L29DMWQrNWtIQ09yVFJSUGVBVVRv?=
 =?utf-8?B?eUoxUWlCclc2TlM0dXVzOGZRRFlQVXBBMkVVNUpleUVZNkh1MEQ1dkt5d2NE?=
 =?utf-8?B?YVJ1aEIyUy82TmRMSmFQbFVoTkc0TVRPMkRsTTJoZnNTSFlTK25xSmJMM2xM?=
 =?utf-8?B?RktLaGRwa0I1VUVyc1BJakkydUNwWGh2Ukxaa1RHN2twdEpKdGtURmpTVDAy?=
 =?utf-8?B?ZGs2NmU4Y2s4ZGdrdTRvMndGM0sycDlMcmxOUHdrekhSUE5BL0tZZ1dJK1ow?=
 =?utf-8?B?dEc5SmtFYU1uckhmWkRXTjFSTlVzSWJhcytlQTkxQXNGN1JwRThIaUNBTHdo?=
 =?utf-8?B?dm5tUldTeWJBTkJmTk53cWtnMytqUG9JaDlqN3ZuYmRtc08zV3VrUWxjZFJ5?=
 =?utf-8?B?NWJpKzZPQ2lOcTJZUHp1YnBCaytsV3RHTE9WOXRLanM4VWVKbzF5bUhhOVVE?=
 =?utf-8?B?c2xUWHcxUFJNRCtQS0Y5NUpqWXhHU2xCUXlFR2ZoUkFGVHFaYUt3N3RvaVM3?=
 =?utf-8?B?R1ZvQ25TN2ZkY3R4b1RrQ2NBUElMQ0dIYU83a1hibWt4UG0vYlR5Q1VMSlhB?=
 =?utf-8?B?MTJKaXlyS3FHNmRIK3ZUL3ZiNm1tNjZFZ0I2OG94S3o3RGlpNDRoNFJ4OE9M?=
 =?utf-8?B?NWZoTFVkclo3QzU4THRWNXpwVGRrbHlZeG8rUzQ2Qi9JWVR4elJXTnRyS2dH?=
 =?utf-8?B?QTArS3dOa083MFlzbVNkWXpvb2IxSzQvSklQNHBpMFVVNDhjS2draW5KZUoy?=
 =?utf-8?B?Y3BvRjVkVlZocmJTMkw3Tk0wVnAzQkRZUm1rS1BOTytBOFZnT05oV0lBU3Qw?=
 =?utf-8?B?Vk9xSjRqNTFkTlhuK1RwMHBkMFZZL3ZBeGo2aEZBZ2FHV1dOb1lvYVdlUGVy?=
 =?utf-8?B?dmJkbThzV0tzYWNRaVo1MlFWMHZpcFVHTHRWckNRL2lyR0ptOTdaWkNTZ3Bl?=
 =?utf-8?B?RWJ0ZGF0MU50WXgwQ2ZKckVJa1c2M3d2Mzh1SFg5MUJDd2lDSGVhNGN3YlRm?=
 =?utf-8?B?NjRMbnRYQ25YSlZEOU54YWlPbHJYZTFCQWxyaWFPb1crQUdlU2ErR01SRVhn?=
 =?utf-8?B?aWlDeWlBZGs2d0ZuWnVnMkNsV2o3WkRNTjdrZE4xTWRJeHppZjVIVmIyeGc1?=
 =?utf-8?B?MXplekY3a3lCdXcvbE96MHIrQjRHL0JNc0lHcG1ubDRWN05QeTRHWlFWZkk4?=
 =?utf-8?B?VmIraXVPOTRHcDI1TmhGNFk2Ylk5SGYyRjVQdmxHVndFak4zQVVlWlJyYTU1?=
 =?utf-8?B?MlpIbGQwdGJ6Q1hoOXhkTzFCbTJ5YWZ2M2lzQzhGYUZ5dkkwd1JEcCtaTlQz?=
 =?utf-8?B?TmJPSjQrMlowNlVISnYrTTEvS0RpSVhDeDJ0eU9ObFYybUs3M2U4SnJMb2tS?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CelDgx+YPsa2jEv+yVHuZ8wcKEUwGL2Q7gUf35yHNwCpFpw5EoB/cbycIMTuuoU3wMnt8HcYwNJe/j3hBXwrpaEQd0BjppJ33koSX+gk3k7Oc1HNk3upF4R0e/dm9sB48KiAIRTxBG03g5qdwLjo/6B813IYZ1nsNGzFVXtV2Jp1mCHfROYfU9miNyiAbDzCsiMCgpOfNMhuVX+tI110LQlbSxLS9+d01Gf2D964VTHEYdgcuoYfmyrSgKCWNxXOEA6fY5XkYQc6F9eWRkkNFelpUHlA9Bl3JuLJMAhXG02v2wiobmWFCB7jPHHvHo4dP0XpHvyfWBMF2IMXPrDT4Awtcj3kf2Hmd7s4epbyZEigYyYpyRypDtCJ/A344ARAzhI0DpNk5uteERG1RbfnTRQSLWkkDwS8kwCvX0JnqS3eyErZjoAahDQqLCNx6xWypQUAcVnek1kx5PAXMdCAcR97OLXI+tAqTL7/k55qhv4G67qkAARZE4JMHfegbOzMAwPhIXLe1CWwCrt8UR30S7ku8uNFws5YVzIrTORB5pTn3AfebDoNDR2nprT/DM7P2Rg4bQto+0jjT9bZ9uV6+mbQjYWs/mQ4eQvOpaP/SAk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aae305f-5846-461d-6b89-08dd05433f75
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 07:00:54.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Msy0T2N9Op3aae1gC4FBASWCj1d0wQ22hAKS8o7nGx9On7azYHPYe1f5NWZtiiAY1EONsqftfbhnzqw2bR4WimKrZX18cFzFd4NR98DTdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6354
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_05,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411150057
X-Proofpoint-ORIG-GUID: XwMTJsd-Gp3-YNmu-htVfRD_icIV33nL
X-Proofpoint-GUID: XwMTJsd-Gp3-YNmu-htVfRD_icIV33nL

Hi Greg,

The patch series is fine but I missed one final patch of the patch
series. I'd like to send a v2 if it's possible. The series is missing
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=35770ca6180caa24a2b258c99a87bd437a1ee10f
unfortunately which is the fix itself. These patches were required to
get a clean pick when backporting this patch but I forgot to send the
final patch itself. Sorry for the inconvenience caused.

Thanks & Regards,
Harshvardhan

On 15/11/24 12:08 PM, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: WANG Wenhu <wenhu.wang@vivo.com>
>
> commit 86a76331d94c4cfa72fe1831dbe4b492f66fdb81 upstream.
>
> It really made me scratch my head.  Replace the comment with an accurate
> and consistent description.
>
> The parameter pfn actually refers to the page frame number which is
> right-shifted by PAGE_SHIFT from the physical address.
>
> Signed-off-by: WANG Wenhu <wenhu.wang@vivo.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Link: https://urldefense.com/v3/__http://lkml.kernel.org/r/20200310073955.43415-1-wenhu.wang@vivo.com__;!!ACWV5N9M2RV99hQ!KIWd_kui8J754PtgbyIkIgs5FO5lVNz7kLCkgbvI2fyaF0L12Y-unOmAYPsYWyr-RMIYHLBN4M2PzFgU9jvCBTKGJyg15w$ 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  mm/memory.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1921,7 +1921,7 @@ static inline int remap_p4d_range(struct
>   * remap_pfn_range - remap kernel memory to userspace
>   * @vma: user vma to map to
>   * @addr: target user address to start at
> - * @pfn: physical address of kernel memory
> + * @pfn: page frame number of kernel physical memory address
>   * @size: size of map area
>   * @prot: page protection flags for this mapping
>   *
>
>
