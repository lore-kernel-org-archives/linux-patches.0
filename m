Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C1628D8DA
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781801736; cv=fail; b=LsqLuzi958jshY2YHJVe/TKX/QQVlZJ2bQ7pOsk0zoFlQMNsnj6XXtZFPzzgVYW6hLdq1yp/GOIJN8bNQKb339S2/F8W3ufR4GPWYQmOcmvmJPiUKw3p/zLm+SI5c9QQxku+tliQRd7/xJ9fVPXCZwGUMXC8GvXEQI9tKKa+nVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781801736; c=relaxed/simple;
	bh=3I194jIvWnvSvgBAPYS6OfFD9JJtRJ4/mn5zdNsHdCM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VMcVYb0RZZxjtkGJ4Lim28Xiu2MK5TQJ0kW9HIujVDHOgQlPaEdg3GZtdDeC/KS2mEOcU97OZjf8E4RjGFPA30nuqT+teti8kbO+LYLCqK3gKgtVYJbo3oODb03FQaREbzLHDBkWbnLA19tgizhL4Sf2JEzrZFOt8f8vZz1YhPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g0WK8XQ7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EIYfvrdi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g0WK8XQ7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EIYfvrdi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IGC9co776803;
	Thu, 18 Jun 2026 16:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LDcXvjjuAg/rWFiF4zIMGQ9pCsWsZCYue1uc+tNbnEQ=; b=
	g0WK8XQ71Xf447gELULrluvKcK0VfnxIjmCC5YOBYC/LhbbGeMUfH6sR9e1TuqyU
	SlVf/eNmo4KjIrrtuTiSWEJrJhAx5qpyyAR2JhVRvAVzTHTKLmgKBQjkBUdk/xH0
	GNxm0zJeYJYtpcd3nC93T6MzZ/gbyMtS0aeV2nSKFT9tN72CAkZ0Bcirk8+g/pxj
	nXzL0Zs17BDiCD1mddRZpdcz9EKoRySz3NvM6rS49E/YLQIutLsFjzOMIQLfK3D8
	aNL6q3nnhec77UlYkfnJ8t2pn7cDS2LAqjFE9BdSDJt4O0jVAXn02GW2WEpHqDiA
	KFjUqV8y7+aHDA1PeysPFA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euefujy15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 16:55:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65IGr24g003149;
	Thu, 18 Jun 2026 16:55:29 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010001.outbound.protection.outlook.com [52.101.61.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ev14fd0n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 16:55:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=onR523VjQynLc9/QWeNGoV/brV29RkyVBhGQKEMyReeybC95xFRTK5u1CleEjHd1pBZ3BCfY0PpiOGEByGyMiSLUwqiwcIQ2iA7xS9t93/RpU/peNM3RAxaL7gRXmZmvcsyoIQA00foYY99fqh5e+K3kffRA0Pw4J1X6JE1JVcxg1M1zIBb+qzXPLO2TA06UGvGMM4QX8tjuZkO7gmtDrQcqRNEVi6aqYuie2Er+Lpy1bKTl+m07jQRF5Ij66O55kB5N2z05zeQLdDGMUKO0wTFqbzezwiTsXTlUBizXg4iygemLl2c+VHPPvxIZV9Y7//Q/37hj17lYmKa83ugJxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDcXvjjuAg/rWFiF4zIMGQ9pCsWsZCYue1uc+tNbnEQ=;
 b=e7xtWHerd+llq+M4L4U0N5f1FjOT4H9OjgJAPGMYW9YbkgDqpKKJUSArefCuhcf4tlTgXht+bFsx3Zi5FmxxjhXP18jKJR2jJNLdMXDHjJEspymi812zDMtgRILUzaIU99KgoD4J97f2W91RZBVOy6d3PDaatz5qyKFE2ecteJybOr8bEWacjEsE8+/zmLdm0BBDmSWqWVF7EuqPgeZIkvQI7oBt/mdmoClqIXVAdK6wqWd2pD+ynLraMA4vGq5nHtGVBVwVN6PaBaTIde/zw2NmtYm6+hYerr9hg1Vru9qIOsgu8Ro7ML4Wo4YoW3lPSUDoHlE6otFk4w7DcbO1zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDcXvjjuAg/rWFiF4zIMGQ9pCsWsZCYue1uc+tNbnEQ=;
 b=EIYfvrdiy/SEt/CGZxP+F013qNk/AiAmhcg9hGLQe7IXYnKC0oH6YhxG5n1OfnMxF4ekGzwfe5zmEHp4tgwAh7n2BwJ0M3E+nvnPdFjwE9SSHVYacD4nC+SB8B2x7J99KoQNOH5oZZ1XNFW69+jzo1ZhjOE+r3cd3AKWl0qbpcA=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH0PR10MB997640.namprd10.prod.outlook.com (2603:10b6:510:386::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 16:55:26 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 16:55:26 +0000
Message-ID: <68af1e57-23c2-4f60-b57e-fe8bba079e10@oracle.com>
Date: Thu, 18 Jun 2026 22:25:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 100/261] netfilter: nf_log: validate MAC header was
 set before dumping it
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Weiming Shi <bestswngs@gmail.com>, Xiang Mei <xmei5@asu.edu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145044.869532709@linuxfoundation.org>
 <20260616145049.667194632@linuxfoundation.org>
 <ed09740a-561f-41e4-8d7b-ade8f6ae0763@oracle.com>
 <2026061823-film-pastrami-44cf@gregkh>
 <9d7e82ba-3f92-4ef4-bba9-c62c019252c9@oracle.com>
 <20260618134208.nf-log-mac-header-a84b6fedbc97@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260618134208.nf-log-mac-header-a84b6fedbc97@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0172.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::33) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH0PR10MB997640:EE_
X-MS-Office365-Filtering-Correlation-Id: 702a3dc5-2a29-4324-1538-08decd5a6559
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|4143699003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OUMZfYlhm6wAupeKyD7PcvgvUNbBi84jNHyDD1bCBzlwyhcvdW78qMZZoHTbUX1M1WXSjdMOs58PG+vGx3BCHdL355xsntWpJi84SKp8nqTzEOFfMoytA4RWBBgYiYtKfxtQA9xUtgLXsz+J0lEHYcLZORi5nAi08/yKwe+EflDojpKDEaPndaRy6xzpQRRpSl2ddeqooh0Iht0vEqCyEIPJEaV8NezUP/uBYjSCYzMZts7+dOdj/wh4UdewjqGoGW/ivn8y3JQT+eEflMqg5IZbjyUY9tRQ3nV10tcKBNa3fybw8AZa3WLZn9USZ3GXXXw0IMRqB951CzTAWjd+jS90L/tNzC1hflULADmn03+6DKgKCy+MiVs/JiKCmkoexa4V5iacvIQO4BPeeYjspBdOHCfpKEwja1/+1GeZ+puoQgOVDw2Dphk4rR0G6bXz+Ez6TkEtaYPqtbN2bFhuAGRjKyiUhgB9GZVBR8nP74xDFhtCVMHBcbdC1HUoncH9y3bFOnKljqXnu4yH7E92Ud9rcd0Fm8KNBhyzZotOZx0VmxrQDXb4tLl9/TS6U3UtXTbXRWWlIE8TdPs5B0v3XGevcIKOs+d/ffguTnDhmkSFr9kiD33u3TvAzoKEVGHY8UPnLMLcXgQ1nWPw9E9j7BZ9a6Q9x2zwE4bMIpgJgAQfcCoEx2+qUIpDIdv5Eafl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wk9CU0dPMEVFeUo1UGdGbEd1a1Q1Y1JsYTM0ai90ekE4RkpJRVV6d0FrbmZW?=
 =?utf-8?B?WVJ6OTlwQlljbkNVRElHV0QzMHk4NEhWcUJjM2FoY2ZDbGdjRzd3enVaV1ht?=
 =?utf-8?B?eWZjS1VLYlF0UUFUQTJkcTAzb0xpOHR1SEQ3U3FsNTd0Sk5NZVh2QXpmY0li?=
 =?utf-8?B?dE11UHduRHkxWnpKeVlKUDFXR0lEUzN6NndQWkdkMStWWWFOTGxTOGFFRWJG?=
 =?utf-8?B?UW8xV25aekRQOGJHRXBabUJDSzhLcFdOcGw1bGtOYzlZRU55OXJ2WEp1MklM?=
 =?utf-8?B?Zk43UStUS0EwOUlWTFZnMGZWUTlRR1NNdldoRzhXcEsvT1pLKy82cFFiMDFZ?=
 =?utf-8?B?V3o2bVRsMS8xMWc3dThLcy9GVUhUaWdzcDdyVUJGMmJjdHFXdExOU3J6TFhV?=
 =?utf-8?B?V0crMzJtenQzN0IydFRvR2dWblNMMnhLSkFvWHIwZ1B2aGIza3VWOXAyK1Mz?=
 =?utf-8?B?cFB1SDR1TXVGYnNLM0w2eFRyUS9kVC9IZlNLdEk0cHdZcElRYWpUOW9NblQr?=
 =?utf-8?B?VW1xZXZ0T21GaSt2KzVleUsvNGdjeVdzTWxZeFY3NCtWTnFEeks3SWxwTDlM?=
 =?utf-8?B?NnFOeVFhM0Fqb3Q4eWlPT1ZqNGpyUmJvclJMUkpzb00wbWUvRUVoVlR2UDY0?=
 =?utf-8?B?YUI2Rk5qLy9ocmFWNE9CQi9mVnRsLy8rR244WjdpenNGdnlLQytWaC9wSTlQ?=
 =?utf-8?B?bDcrd293MWFwVHIrVFpSNEtvS2tqNTNPaU5wSVpSYkNSYW1hRW9oWktMNURH?=
 =?utf-8?B?Vkc0YTFNUUM2U3VtWGlEcFdQd1RFOGZUZ29semUwSFYrajRpbmxZVjEweE0x?=
 =?utf-8?B?MjJ0WDZ5MXBXZ2NXSUVCbjFPTlV4MEY0L2QyK0F4Y0V2SUVEMEthVmMrK0Vi?=
 =?utf-8?B?Mjdod3ZNNi9kbzFnVy82WXU4bVRRSzJFMDNDaGkyRy9lb0dUbWFsR1Z6TFRy?=
 =?utf-8?B?R3NoQjFVdGdLL1c2UkI3eWU5TmwzcG5xQWl0VUpJS09kanNWeld6MHpXZnIw?=
 =?utf-8?B?OWM2WFYwYkUrQ3BpckRUcFN5c1RnREdlbUNXdHVsL24rMmt0d1diVGxETzBX?=
 =?utf-8?B?RjlxcDZncGp3ZnlPMmQrNlFudHZKNHRIQloxU2ZNdUdRSUFFRVN5VEIwVDYv?=
 =?utf-8?B?cmk5bWRtUThBMCtIK1QzOFdiN1g0YS9JL3BhSDdQZGdYa1JLTDRkNXZnZXNr?=
 =?utf-8?B?TFp4RVVuYUtiQmRXNFMrL01nd3lxRk1xYnlNM1pMd0JJaEFqbEtrSFEzTGZU?=
 =?utf-8?B?NjJCbnhqYkNQUThUM21waWJXeE9EY1JDNWY5cmJPZVE1TStVQ0M5NmRSNWpo?=
 =?utf-8?B?OC9MbkhXMDcwakg5YzlvbjlBWXlVQ2dFM3dOeE5UN1pYLzJIelM0Q2MrR0ps?=
 =?utf-8?B?SEtHYkNoYjRPc0MyWWxaOFA0WEx4dldhQi9pTzVsUzJZMXhaeEdwUytxWGp5?=
 =?utf-8?B?MVBoRlI4M01KK0hvenZaTVlIaXV6VjkxSVo4Y0pDTGRnTEEyZGdoeWM5cWlv?=
 =?utf-8?B?OUtCTGI4bGN1bTB4VDBiMlY0SjBkUE5rNS84Rit4clVZMjdldERyTldhZHkx?=
 =?utf-8?B?UEtlWXFTOUI2dHFSdnBiYTlXdVpIcS9JUk44YzA5czN2OWEwRmNEcHMydUFl?=
 =?utf-8?B?S2NESy9oMEVtZjNTZTN2WGxmaFRreUE1TnB6ZlR1b2ZyUUVzVTNKdThXa0pT?=
 =?utf-8?B?UlNVSDdKNGZEcmkxZjNUU2FVamJsSWhOOEdRZTd3bWNNcTFjbnlESnByN2U1?=
 =?utf-8?B?SlpRdHRKTGpWaTJXTlFkcng2MHVpVndycmZOcnQ0SEFXWU9jWXh5MWtvOEVR?=
 =?utf-8?B?V2c3NSs3OTA3cENsNG9ablFHc1QyeFNpZTZjWGtJMFBWSWVOOXVyWERsNnFT?=
 =?utf-8?B?aDdhSWN2K2U2N294T1htZVZZelFURlIwMVQ4c3Zhd3A1Q3ZLRmZsa09IdlV1?=
 =?utf-8?B?WmZyUkZIQ3Q5RGg1MnNLVzQ5QitValdiQlRrcjZOWkcvMWFmNytSVHpjTXlr?=
 =?utf-8?B?a1pjOThnUTBWbEtqV09jQVc2RzRLN3F3OWxmenp2cEgzaU40MEF1eXZEV0FR?=
 =?utf-8?B?dkdMeGcvN0l3bWQ5OUh2MXZyVlNJdDVCUlhSS0FSUlVxVFZvSWQ2ME53SGwx?=
 =?utf-8?B?ZUpoRS9CNzR5a0lPQW1Md2FxSTkwdWFnRVZ0Zi9zTG1IMmdxS3FKbnBQUkQx?=
 =?utf-8?B?SytDbEo2bzV2YmJpWnhZczRzQVBjd0VkQVJZTFNOOVl5ZS9JRnVRMm1UUkVX?=
 =?utf-8?B?ZUIzQ0hRUWpmWDBHU3RFajM1Rm1Zd1FzMSthb0RkYTZLMFdkamMzenZKRERT?=
 =?utf-8?B?ZDY5MXRhazhUbEplcUpsOG9IT2M4QlNqZnMxOGRqd3phWEtuSEVaN0FBUVlR?=
 =?utf-8?Q?YSdYltS6pwlXGvLOri9wU8qSaXvRF1NYlQZ2f?=
X-Exchange-RoutingPolicyChecked:
	eXR3cA90vQk20+MJl/1DGI6pZdltS/R05LIdOoiHss9Hu7tv9YRvdtxjkM78yYy0FbbreVsdGd7lPBx1b2N0M3NPKkEg8uIAcZfvEsqzNDiFPDp34a9NE+YreM76uX2De4rZX9JxQ/2o+pCj7uU5CKqmi9Gy3wSOLh6lfgHL0QazMKNMYn7s2w9uo+IB5q8D1gkQ4EqMlDHWtw2w3ilKXLX5HH6WHCxjIjoFIR+p3765ziz2/OF2c18SW0CpltoyUlBPlnipcNVzSrrlOgLJ+gDxRjfEyW6QJiBSq+JnZkCwHViWgsus+3VibsSh0PP0c0VlrN/OQeLW7ZnDDbRi7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3dbV7mTaFiJJ50n2n0y9+DZ3DCqujkEzqpjcIUrHCDyTnY9bEib/+faKi/OuQbK+kbNy+ADrCwTobKYfRVrsYyNINubGDVInWFGeRkCwPWBHGsK1exoqj1i4gNqm4mF3juVj8B2kBuPFAIZ9kcY3Eu4vGb+L5Jgr8KF5BxAPzq+ZBivILg7/K3dAbiE6ICfc0sSP7AF8u300NOYJWJZwEY8N5nMp+/s/ugVOSNHcEJ6z6dTInMW+xZ2iaBirJTef8c3NLulhO3MhkT+ZGqqVbX/9JoUJ7LNCozopP9XVJhSz8JeqmZm+oVn6v+zauYifYv73YwCOx89m35j8hvsjHSX0xt9o4QQ0DAcHRUzJVyQ1s5b9HWu+dH/80IyTGOkE2n4Bn98auxdelfitMkVjSH7XzTEMMdh2yrvCCmzUb7v1b9OVINBTjWkJj5caXt53YXjaQf8jPv1VZWAYBXGX95Od+0EnUQsVvCfoV+vh5i6wSyvdynQnm9cNw4gUqTe3bhsvhnUoemPARtyjk3kn3coxwB+Qq3poQUYc4hreFtw3nKRalP9W6zsq1ow90h02XpEk5B6d+7+6zzfTX7zlWEVz35xUv+33R/aawRJncMY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702a3dc5-2a29-4324-1538-08decd5a6559
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 16:55:26.6450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkt2BPmIMYNonZ1SkBm3u1lgAe1vxTHAhtmGzPPtZ5q86gM7uy7MiKGHifkTRJsoZ0UsOc9rPwXIrWsKNKF8KxC8t3oTkueZXmVE0U+iw7sqlCkFpQIM6FWf9zHl2knI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997640
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_02,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=922 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606180157
X-Authority-Analysis: v=2.4 cv=S4XpBosP c=1 sm=1 tr=0 ts=6a342302 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=cdEpwlII9xpuPfPT738A:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDE1NiBTYWx0ZWRfX92KrnZV7ozRI
 6XQvAomeubVoWqA++umTUgkXo71+QGaxO8+C41GkL936Rn5u49sA32zI0AUz+udotqBKwZRcl2j
 tEtWvD2w2mDSgdpaobNfYeGzKzO1qzzYXqgW30OiSyk3VUeKEKsB
X-Proofpoint-ORIG-GUID: ZOxftERWpcIDvVcQa5P3LR4CdwGzBJNT
X-Proofpoint-GUID: ZOxftERWpcIDvVcQa5P3LR4CdwGzBJNT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDE1NiBTYWx0ZWRfX4uYP9+A3NMPV
 xsWqnNJJlh2b6Hnn9cJKiZ6AysZPwQuwQ7XVL6x0rBpFY0+mdWXl2VNckLzTOp7vBjfUh1cUROQ
 nThETXsniGlkHxMjLnObSzNgvQ2O89A4BOmCv9/ij7/X+rR5UTn/kVZgbymvy8Kfaf6pMajP9uQ
 0fn0ZBBLKTbfvqW34L42Of0HHs8zPBquEDQxqbcExCNmDM+tVqxrRqTOJMxHRwtCEmDv+zU1EGE
 3Tfs57sILl2+/NKbU/QDxM++K/xyubpq+NNV/2zu7zlhDkWEJT24l6QFK+B4KgYIbw+OMiNgtno
 da7q54qgpdyrE6V1I+uXOsmtQ5oezjQizj43oYM8xemvl7visJIZrd/S2yo2A4LGB53qmnIihES
 mSmkPDOc5jOgT51PCqSp1CRlSYQf3hiVTyCzi5tVX/dQcsAA0uwyYmJ3yExhg+isXcg8Pp/CGk9
 8rOef811tLR/p3JYVZA==

Hi Sasha,

On 18/06/26 21:57, Sasha Levin wrote:
> On Thu, Jun 18, 2026 at 05:08:46PM +0530, Harshit Mogalapalli wrote:
>> Now, this particular backport "[PATCH 6.12 100/261] netfilter: nf_log:
>> validate MAC header was set before dumping it" assumes that check is
>> already present. Not sure what's the best way to handle it. Drop this as
>> well and backport them separately along with the prerequisite:
>> 62443dc21114 ("netfilter: require Ethernet MAC header before using
>> eth_hdr()") ?
> 
> you're right that a84b6fedbc97 on its own only covers the fallback path
> and leaves the eth_hdr() consumers unguarded without the prereq.
> 
 > rather than dropping it, i'll queue 62443dc21114 ("netfilter: 
require> Ethernet MAC header before using eth_hdr()") on top in all the 
affected
> versions (5.15, 6.1, 6.6, 6.12, 6.18, 7.0) so the gap is fully closed.
>

Yep, that would be a best option, just wasn't sure if its easy or not.

> thanks for catching it.
> 

thank you!


Regards,
Harshit

> --
> Thanks,
> Sasha

