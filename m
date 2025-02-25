Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DD02673B7
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 11:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740483941; cv=fail; b=dT+vZm/J6ipGKBZxM+1zzK0gR5/kXasrpG4ukBkOB/YC0OOYTRm19PhX0nOVg0/2l4Bf2jBwdPrCKvxBRuwjEzunKhPHd5lzhCW7XbVKIXaE6gkOHk9F/r0GQG2F6CWPrzCUdAuBqHXuF6uY5mBd4BrlIJTP0CWNWhvfz0vL4oU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740483941; c=relaxed/simple;
	bh=EJnvSATVtkjwW6bbNQ+YhOK8n7sBi9LorYF7vtoqRA8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ELziV/gEVZZ/8pnetsXMtWaceOD1hipxlaamZQGskJqvqXFVbG+cGV0j90FK/KIkkm30xXNvxKUoJcHrdirVMpPqGkmDmLLNKNNhcEA2hiMkSj3ch/HPVu38xWqfpN1mP508L5EpknOVwafZwE5Tf4RiM+KnkaVOEWcsOWa+mQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NDD0yGxx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iPcha9G3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NDD0yGxx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iPcha9G3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PABhIw012892;
	Tue, 25 Feb 2025 11:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=73FJIOABvwQ9KeJM3W98XxFTLlznHxOxpaQw2V2aFes=; b=
	NDD0yGxxBFw9tRuS5BqiVXeJ18n/D727ztnSKyGv61bEXr5Sj25CPx1KfOAhsAsH
	2fnY+hRoS4wNtOpH57qnNgqXw41n6of4aLQ2YkuK8+XXjX5wXTzxOMrA2AF1gSyQ
	1FKfd1kN1dA1M+pxQ3QXrLuiN8Xw/m9gH0M+v7QHyE5Tw0/y3yfZy3mw1Q7YUJS0
	o6m+Db3+HbEkr90ROcyfNqANsarnolQMAuXA/wxFzlMyEG7ezteS3g7lH7iuPpP5
	Db9jzwst+KTEkeznASgPfWdODWNjdH4LqYfIVKrsOHBq1TB+AsOthHUGeVhwBrOT
	73DeqETbk2xrYm9Lia1V2g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y50bmve9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 11:37:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51P9Z0GF024389;
	Tue, 25 Feb 2025 11:37:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y5191qam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 11:37:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KlkZXdGZf0Q1xkXEUCeZzPcq5E0aVSnEYYKs2o1jR/c7WkOhXfty7NhJmVGOxXzAd86i1OjuhC8WTrVQ97+47VQqOjeHU3nKykl6HlEvZJYOPNH7DbhhNx3aUT5wdA/igl9f0GT4exMHDNrKD0eLAavUBQOapHLCUZPQ7PA+r5DFZs5PtoGUaqLOlGCWNncKeNbBKO4G49drX7E2MWVTxugn+I29qtLC/DjW+w1vTc8tJ72MMtGtRZMmZWiDTUgVujaqKzP23HeXTIyOlhZq0FcxxtyjTmtXqEIkWQO/Lsv/UAdwvMyMxOc2e4Kl8nHiwX8twUn78jaGEZ5SQng9Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73FJIOABvwQ9KeJM3W98XxFTLlznHxOxpaQw2V2aFes=;
 b=fcRFV7WLaypeTw6ZRdMdWT6OsMDxWhOMdFs/spFTM1bheE4Fg47vTSPZrKoKTt/LqQB5jIQ6J9eTY/lh7D0/86UN2wR6dTZy6WMhaozzfTBSz94RU28AnZYTm+eUdhyQuyo7tkxr17NndcSySwjHrAxe2SRin5RIkyepzYrF8SLjhvNOw2HGN17jbuN1m1851HTKcOAcH+b2BIFA1Y7/YvSs72zqg1G0KHq8lMBY7NnuO88OJJ73RSPK7TSZndXlxsAjjnodtzhoFvo5wdQjKW7yaelofVYZJEfciWPyZwod9o6HM8YyNNr+FUKrSwAp5HFB8J5ARh6fA3ysYkj1+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73FJIOABvwQ9KeJM3W98XxFTLlznHxOxpaQw2V2aFes=;
 b=iPcha9G3UmmyXqz5dMZinuAMVPZ9jfIf1ibcR/xR06rbjVm4qWzOBafR/VZNw8uh4sLmOZE/zj3G+wKvNlief8CfQKqOOOx2l1PBbUtjAlB+ZU7TCHc1WowNoC5HtHxbcU38ZGlpi+wGNtIMjwMpxYnqKr4MRCaux60onmj5ha0=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by DM6PR10MB4331.namprd10.prod.outlook.com (2603:10b6:5:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Tue, 25 Feb
 2025 11:37:22 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8466.020; Tue, 25 Feb 2025
 11:37:22 +0000
Message-ID: <1d0d6fc7-bb11-4a57-b4d8-ce8e975861fd@oracle.com>
Date: Tue, 25 Feb 2025 17:07:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/140] 6.6.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250224142602.998423469@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::15) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|DM6PR10MB4331:EE_
X-MS-Office365-Filtering-Correlation-Id: 412abec6-1b2e-4d63-1ed1-08dd5590c4ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTNlQ2VaS1MwaDFkREFYSTgzRVhjRFJZU0N0RlJzMmtnTm8zRGM3ZnVUczUz?=
 =?utf-8?B?Umc0ZXZGTklsVzBxaGt2dkZYWW1hei9qQmd3eGovek1pcHIxSzhVV0R6YWdz?=
 =?utf-8?B?ZC93YnRjMDlSdDFmaVRVblQrK3RhblM1d25QQ3ZMc09WUlFUbVdIREw0OElY?=
 =?utf-8?B?NE43SWNvejF6Zk9BUThDNGxzQy9CZ3gvaktUU0VqOHFPYmVBM0lSSzFyQlRq?=
 =?utf-8?B?ZlkrM2xpNjYxN0pLMEhQb0F3c3NNVmt3TTR6WGVoNUhjRVQ2dlBoMFlxZXgv?=
 =?utf-8?B?bS9uSm5maWRLcUU5dGZLUXhOaldUd2dtQ0VXLzAyNG43eGpuQU9XeFN4dUZq?=
 =?utf-8?B?Wk1Fb0lOaXFlWXV3NFliZTM2dHM2OXllcjhnejFiQVBzWStOLzB0L2E3UkY5?=
 =?utf-8?B?RmtDQXpOYlZ2blVWczNiQ2ZWaUppbVlSWDlJS2JINFEvQlR0RU0wa3o1NkJZ?=
 =?utf-8?B?c2Y3V05ZMCtnbHJkaWwvWkxjNUlaUjI3bk85aTBNbjRKTk9LLzFlSUlIZ3Ra?=
 =?utf-8?B?eExpSUdRcExPeXVtMzdUMHQxaTZ4c0t5amx1NExTT2ZnYTR2aG5zUUkwM0tJ?=
 =?utf-8?B?c25wSlV4bmwyT3d3VS9uYlJlQ0gweExhblhMNHRLYUthSTZMSEU0ZG1lamNU?=
 =?utf-8?B?T3ppejk2ckVFblBydWpmRThLU0dCUitvVk1tVnJTMlpMbnNCL1dhR3RCZDFm?=
 =?utf-8?B?RC8wYUJIOStzbFh4WUtpK3VOaWNYelJ4OGltS1lKb2g3Y25WOEM0ck1kNkpo?=
 =?utf-8?B?RTQ2aHZBejUvd2Y1aVdOOGo1aVg4RjNNMGZiU241WTIrWUF1V2VoMkhTVnhn?=
 =?utf-8?B?QkRBcUNkMkY0ZWloclhOanNFNU5TcHBCcUFaWENDSDExek84cGY5UjN5eEFy?=
 =?utf-8?B?clYyUnRFbjhidWhsVzNIYkwrN290YkwzZnZiYXphK08rdmtDVGIvNGRJYTBX?=
 =?utf-8?B?WkpUVHc2Ukc5cDlGeGgyRThtUHJrdjBrVFV6TU5YSERCSFFxSDRLbVlrY0Mv?=
 =?utf-8?B?RUtvOTBvZS9mOXBQZVZJdzJxaUVteDhpNEFOaHBnL2lGR0k1U2ZNYkY5V1FK?=
 =?utf-8?B?bGJEcWx2SktjRXdZU0dPVFp4dFVmbG1mZnJGdEFoeVBNTEY2MytZYlJ0SGlY?=
 =?utf-8?B?ZUhwUG9KZFV0TStzLzN6ejRSVUdYeWlEMHNDYzRaZzFjZ0JaRlo1Rm5xZlpD?=
 =?utf-8?B?dm1wdXB4UjlRTnNNcmQwUUlSUFhMYTcyYy9oeFUzSzVaODNsUG51TTBMNVEz?=
 =?utf-8?B?c1llSDBHeG5ncy9QQk84b0pySlhkTTMyN1FyWW0wSzUwNzV0MGxDYWZFVjEz?=
 =?utf-8?B?WEFRR2JSYnBjZml1eVRkZzRETVdzbEFzRTFiRU93SVphTTlmNzBKQlpad21L?=
 =?utf-8?B?VFhWQWNRS0NpcmlRakNTVmlqZnNtYm8ra0xXcGNLTEY4ai9RdHN0TGJmcHpT?=
 =?utf-8?B?RlV1ZjZVUDBlOEpDRUJQMVZGQ3ZNQ1MwVjNFUUtwZGIwcExqTW9ITTh3RUhm?=
 =?utf-8?B?L2l0QUh0ajIzSVZ1Q25JL25pQlVQbEhPK24xM2xlc1hSbGNxS3AvLzZKN1ZS?=
 =?utf-8?B?MzRzbEtxOFBYYlhuRUFPbUFlbnE0ZDQ0d3RZOERXcTdkQzY1M0w5QlFjMGU2?=
 =?utf-8?B?K256Y0VsRTYwWEJ2VUZaWWw4YTk2dEtaUnA3T09OdzIyNkRNZWYwNlpNYW5H?=
 =?utf-8?B?S0gyMjZIcmlqaHl2SXEzWWhlWEFENDBOcGFtd3NGaHk0cElNT1dPa3kzNm9r?=
 =?utf-8?B?NExSWHB5cFJYNjFDZzBIRnVKdGhneDVSQzdyanVCV1ZPY2xSdS8rNW8xcnMv?=
 =?utf-8?B?eExwZ1c0YnV1UlI0TWdNVk9TbEl0LzRVejRxV0lrNS90MDlSaXl3ek9Gc1VX?=
 =?utf-8?Q?Hx2UbyqC4EMCI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dDgzcmhDNU44SFhONGxsUENneE01QWpVV3hsa1J4STcrLzJoZmdEdE1kZll2?=
 =?utf-8?B?cnVHSi9jSytPMmNvbkFhMEF2NDc1c0xvZjlydStwZkNxbkdtUzJlV094cDNO?=
 =?utf-8?B?MXZ5RUV2YW5mdEZpUHJOM2YzaXBCalpkUHlGNGFRMFY0cjRlbTQxL1dSQUJP?=
 =?utf-8?B?M2VtcnVJODlreXk3c0x1aFVaQllTd2l1amJXQ2hkNlFjdXJ4UVl6UENZLytv?=
 =?utf-8?B?U1V2ZW9WQmRuVEx5cWpZYXRwZUFiRVVjbm12dVQ4emt2TTZYWis4bjFuT3Mv?=
 =?utf-8?B?Y0czcjltcXozRUtKVzYzajRUZ211QTUyblV0R0VEMy80UCtQaEptSm5MVGN3?=
 =?utf-8?B?dDljV3dwSEtmTi8xZytxL0E4eEtoamQwblcraHVTdGRrN0IvUzZDSDc0UWFW?=
 =?utf-8?B?NnVjQ1BQYVpKaFVxV1hXZzdCdFZHbUFxMDJ3dWErR01rcmtZVzU0cU9icHhr?=
 =?utf-8?B?Q01xY0x3dlhHc3dMbWcvQ2FnbVNiRjdEcTZyazFkU20yOVM2YVNKZlNkU1VB?=
 =?utf-8?B?ZndRbEVZdkNVYVdkY3dqd2JaYUFlb3p1dW83Mkc1TWNCZ0loMnhJZkpBSVJ0?=
 =?utf-8?B?dkNPY0N6dHc1YzlCRkozOGNUQXJSRDZkRzluQUdhWERoVEtHRnR1djR1WFdh?=
 =?utf-8?B?aHc4MFk0WVpuM05UeGRlRTJTeHVHYmwzNUs5dGhxWW1DZnIvWTB2UUc0VUM5?=
 =?utf-8?B?UEVSQnBkYnY4akdxVG9mM094QnIyVDA2cXhJdkx3NGZlcjNlTTZ2VEVBN1Bv?=
 =?utf-8?B?Sm83bHFuUTZ1Q0ljTFVSSjVTb3JxUjQxajN6UzBha21mYlZaWXBTTHBjZVRC?=
 =?utf-8?B?bDVITytjNmhwelNhRTFDamhCbXg4bmVheHA0RmJaS1FqWGI2MldycVlEemdh?=
 =?utf-8?B?aUF2NnFwVlVJZkdQQWtoUzdsM05tNC9LR3V6YUlyYXZMOXE4UTRRM1FOTHJB?=
 =?utf-8?B?QTZPNEx6ejBHYlBORi9jZUZ4OGx1c1JKWE4ycWVDWC9IWFU5UFRicG9NNmRj?=
 =?utf-8?B?MHZJSWQrS0JCMjU2N1pYQ0xhQkRhdnVDSGJDanBzVmJiYVZaL3pBNS9IcWhH?=
 =?utf-8?B?ZkUvZm1pT1JhNnlFa0ZRc1BxcDZIeDZ1OVdKRnlvVUR6Mk04ekNzT0w1V28w?=
 =?utf-8?B?djlCTlg5LzNnblpPTFpxRTdiUkRKcVY4WUdDUkdmVmtGT1poNjBLdXRIelNI?=
 =?utf-8?B?TjdHVzYwd3B1NFlWTTJualJ4QVFqY3M2aEpjZnA5US9LNFpUWUZXdGtXbWpw?=
 =?utf-8?B?YS8wOUJCWlR0dUJPUFp1NkdQUUg4UVNPdHNUalZ1SStCRmc4N1ErUGt6UzZV?=
 =?utf-8?B?N2NrMTVlalZZVlJ3VkhmeEtadFBGQWV3eWR4ci9XME15RVlFcStHL3B4dGtB?=
 =?utf-8?B?bWdkZTZOWW1DSllsbGRNbW0vemNYbGo4ZFFBYS9vVG93Z3RVa0o5N0JWbUhO?=
 =?utf-8?B?L2d3NFdrekowcjI5OUFWd21WOGJtK3NFRlU4NTRLajhLUHE4Q3pWRVlwaktl?=
 =?utf-8?B?bklxQVhTQ1dlZjNHM3hhb3ROR2RMa0ZrZjh6bWxEOE1zQm1PenNUSFpWWnFN?=
 =?utf-8?B?cGZMSmt0a2RiMkc1ZVVrYjR3L0pzc05Gbnc0SXpseE1LUU9nV0hBbU9jNzFl?=
 =?utf-8?B?ZEFlbW1zN3pTemRkUkhrQ1pNbDFUYncwVi9tV1NMeGpZWWUyT2FEUDlmQVZ4?=
 =?utf-8?B?U1VHdHNlOS9JM1NRdC9pbzJMQjQ0cUtRS2hzSmwrK3ZvNGJ0N1NhMElYL2sx?=
 =?utf-8?B?dDFSS0JOdDZNMy9IL3cyWmFFdHJyT1duWjh1YVQraXVRK1FXdmoyVk0zWkRu?=
 =?utf-8?B?VERxR3VzZDM0NmxZdUNVSWo4RlhvZmxwYWJXbWQycWl2QkFXenhuclJ0ZU1u?=
 =?utf-8?B?SEFQSFBIbU5RMFR6WnU5V0hPREt4ME1La0ZCVWxubno0Q1FaYUlvL1NHOHZp?=
 =?utf-8?B?VUJhUXkzNDMxR0E0ektHT1VxNXNMQ0d2eGFya3ZuUGdCRnFqQUVoNEF5ZVdC?=
 =?utf-8?B?ekhZemJIcElUL0N6Z0ZxV2NET1ptTU10Skt1bndlUmpndnQxQ3FBWVgrQmhU?=
 =?utf-8?B?L0NGMFNwNU5MMldiOUJPMnF0d1pHTmFpZFFhSDdyd1ErVHUvYmZVeG91aE83?=
 =?utf-8?B?TXduWW1nUll1NkZoWER6R29JUHo3YThqc05TM1R3dG0xZmpUNlZEVUg5YmZi?=
 =?utf-8?Q?9lRsHKNb0/3G/sY5tZRsCYE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KKC/TBQhBu9TVDLBcq/QqK99mlIb3ikvQxydPCkvDQzjH+f8HYbZk6Irg4mzf8Yd6lEDxknYSOUzJEYz2QKM+VwePAVsWf3KvqXSOor313QKTGJFEgdoIij/V/2v7P3hMl39XMweVgv6YKkBDn4h6Gy0HAS8D46nehJrgdW/6ry5GkppAQj8x2gKynhsILfW/XzmTLpExK5U0e/Onl1nCl07XTWK6xF7xZUaQp/MsU7vQ3D79c+vpD+pnScoYugxcyvV9OEU58325TNGHKcEbAI/sQcTuS1x2McOX81QvGeKREsTftJdnOrk76HR4CHBNuymYAzF3fi5WSPFY45adlw37qlTYCt1b1bnGwzBD6YEMpuntUPa7WsCgHdMzU4RXcqVmpMYtU8f49VgVT/NQ80lrd39mrE+U4ZJCFDaOwP31JE1aEhmj8Sll0IA6wa7+oaV3faNsHbZASehMIT1sonhO3tXkVPZtg0Gyu4tasTWgSN1MU9Sr6c1mcFNl9UMnthZd1l6JfGKOEJrWs5VwnVbLi7UCMXdA3w+1nBVjP1qXI2EH6Tx6ElKMFSvPBDpHNVeVO3gDfWYgmcQuxd3nJqtkqErraXsut14Xm0cN7g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412abec6-1b2e-4d63-1ed1-08dd5590c4ef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 11:37:22.7594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tveds7TtKyiavQtEUeSo0JapkkfhbUGJ0L4k69xm7zX0mVSCjkDzM7S1ychapPHfRMT6+AgIoF5UfprV6c4J7YfNpfHVMoTsHdtoHThEl0yjiwdVj8BVuqnDF3BKaZ2H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_03,2025-02-25_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250081
X-Proofpoint-ORIG-GUID: wYX3-gtG-dhfNh8bIQHeznPa522tZcNT
X-Proofpoint-GUID: wYX3-gtG-dhfNh8bIQHeznPa522tZcNT

Hi Greg,

On 24/02/25 20:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.80 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

