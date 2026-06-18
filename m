Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A07237C0EB
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781782748; cv=fail; b=JBn2lH5kgrRF5XaodObrS8se3Hx+GA6HJfxUI6f06iF2qBWQMxd1+3HpTPzuUAc4gfzhcJjPG31TDU7m1fQVJ2qA4BC5yPPdoLH/kmcQh53WT3bjQiNQ/Ok2WypzlNrgkyzpfRmi+4Ac8EnWS2fIPPCTLr/TzwuoZTGGd58hA+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781782748; c=relaxed/simple;
	bh=JyJtyU2KQKBCliE7mz+GnoEsvBCJEPuKCJmTMIlxXqQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l2ANcljFk4whTqIfCT/AeNJqlsoLYYunK0UdtQsnyMFu0YD40tYOJUh6DTC72bxY/caqT0nXoOuF6k4q6Inj37McbCvIQKXIRPCKNR8LX5B5tTuZvENB39+P8Es3ByRxupvdGYSxcyNmT5acqUQ3FE2UzUrmz5s1llBwF/oEBC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jRW3Z24O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uFsw4YqU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jRW3Z24O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uFsw4YqU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65I5SmsE2354906;
	Thu, 18 Jun 2026 11:39:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oNgTUp2mkgNSshSHfBe7bskkFU5nS/qW2PHbH8nARA4=; b=
	jRW3Z24OigAne+nokiUNMCUxrIwsqowppQ3mK+6IPGxkM/j5oKYKZjrt2kVNbvwX
	UUkH//rRX61oCZUe5XpyRWKeQWPHuYczzR8rWhMF7hVaxnjTObv0ZJLrxVk0elQY
	Jq43RESriGqz8uKmbTczP5wJEk3e+fOZhppvu3l1tFIUPm9eDQEbx5II3rIvskdE
	CPDa6p8v6huzyWH96NXSolS8+nO595YTz+y6fPiYYYylmBJtcXmUYmGiPAn/5ON/
	TWn8XyJX8zoDG4wX/nsiGz98bz4d6fWHttZi9PT+uqskk74U7QsyaboD7rx+yl62
	FtXIU1SVB+SuG7FjPw97rg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euefujcj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 11:39:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65IBcf3H015557;
	Thu, 18 Jun 2026 11:39:01 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ev1bqs7yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 11:39:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZccjHmbfauvR/SuESbJ5IqhHxGIyWSUYk+k/HY93je8AdJBMpFpmTBOcJCF7Xs0wcWypDlyfkFNX2DjuvnUW65FWdnRQF/xXiFq11RpkLyzt8Fkoq+V6Iy0gqqbQNwIfIG0z2GYxxk1Z+ItpM5yzY4grkZnCbyQmTIz7LL4PPWah+9KwvVek7eI3xTVsGWv2owXOLuBtYKqh+od8xq1w4sEsSeMRFaTaw5+v9jO050yNsWkDa1Jb5DaF6C5w2zlb42bk8qGGN2H+pHhFTxkjHCcLhEJd43NlTwwVjKmd3I61a75OMP+t4XDh4t36zUiQaG+dFvCmhX7lBBcvTgswJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNgTUp2mkgNSshSHfBe7bskkFU5nS/qW2PHbH8nARA4=;
 b=XBrXisIoeIewv9F5LQZ+X81YFB2OXkDqr3Ar5PCrRsbtqgpkhL7dlmv91RCdexg62qNlA0LB88tS3gM0czQHz64XBj7mXODeZ1gOS3prxM0lyV/7meBEehV5IEDCNxVLCHcrFRgh4YlyDmZjiegVefL3jlCZ3etysK468pyFlIUCtkkWf2MrFV+MSoI8WSeSrn7mD6OF1Xl5hrh8K03atqUbmAz9FvnjVwyRgI7z9WMeTJw9oL10YI/ne7RpFlhzZ6nleL7PKxcTn5kYaQYTplawfE021u/jY6mnboQQAvLVb8RNWYFihnR36htptykrFLd94Qikjx2F43uHctFRYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNgTUp2mkgNSshSHfBe7bskkFU5nS/qW2PHbH8nARA4=;
 b=uFsw4YqUOS+uPDPchceaGRdY7rdO3vaY3+iv2aivKvJ4xPpxxX2kRb91VAzkQwlsqmkVUuFbilI5k8lyx6n8n85in+Zt7S7W+YU7jFwp9QEfGWFqgIDdx/8vVt503aAkQbDhzERfjcdrgWikg8fVvw5p+ONVodx02Hr7pxLokco=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH8PR10MB997767.namprd10.prod.outlook.com (2603:10b6:510:39f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 11:38:56 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 11:38:56 +0000
Message-ID: <9d7e82ba-3f92-4ef4-bba9-c62c019252c9@oracle.com>
Date: Thu, 18 Jun 2026 17:08:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 100/261] netfilter: nf_log: validate MAC header was
 set before dumping it
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Weiming Shi <bestswngs@gmail.com>, Xiang Mei <xmei5@asu.edu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145044.869532709@linuxfoundation.org>
 <20260616145049.667194632@linuxfoundation.org>
 <ed09740a-561f-41e4-8d7b-ade8f6ae0763@oracle.com>
 <2026061823-film-pastrami-44cf@gregkh>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2026061823-film-pastrami-44cf@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0055.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::30) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH8PR10MB997767:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a99177e-5c4f-47b9-18d0-08decd2e2e20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|4143699003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rLgyEP9dCjfS5J82o54Wjzqz0frQqSLk6FrmDzHO/rSIC3pfqinSsN4ZaYyVOG1MOBF39Z48r5dTz4SJhNMug0trWfdlCExAxxTRDbdrZLvmc1QSx/6t03dGK9kbhjpNLwGSJL90ah1wEG9TpyS2sLIpFwticaVbuEGe1D4TziRcVnCbEiLIwr5yFSJboEE6DPZjo93V5jzUnnL9EZK3mZr62bVYvYMmDGaJsIjn4qtjXHjanOglpn3CF2HmNU9Nnx+dxB7R/4m5ZvTP6rt6ccXfeS4XCH1VepuCNjVVS0PUOA+EwHMytB77jf3aMi1avwuHWZy3Lp3ZfpTNN6AgzWoZCKTNDT+9m54bOM2ECbcS93BWC0kYaEwuJjM0urJh9qFb4/jBd4t63jLIKp4B4VRMVZlRDHS1hqCMa1jhW45eG7o1ZyNfZsBpXvPj+wQVJOlax0LXI2cnbm0Izt3lltGjG0RwD+r4wQmxoq0q9itBr/k1i9HzaQE366fADB3tLoYUgjyx1Mt97nzoxq4bHAxxHRtr1KgFNm/ixRGcV0B0xdLgJjJtZz+23S6BjsB71dfsMu3pybzZqBamq0m3kTeJQFXTHC4FERJLnX4ggC/SiULmr7FotTj+4VIAgWv1yvGcGzIigXeIOEO1cHdJCZ6rAjII43Ar18ClSYToGivcBpPjD3Y4xj1Xq1c/6A0V
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3prdHdXamtUdFRDY3M4RTcrZzk0T01Gc1R0VjFQc0VxZ3BIZzU2NVJJb1kx?=
 =?utf-8?B?UTV3OC9pbktxQXl2WUVyZWJQNHBhR05nMkNxU25aQVJoa0lKdWJOaFMzdTda?=
 =?utf-8?B?MEJLOEVQZUNYamdQeTAvVWZPSndUTndTOW1nUlNkSTJuZS9vdEl1dXBHcFF2?=
 =?utf-8?B?Q2hQaTNuSTQvdkdhQnJaUmo3Umw0VFlwN1hUdThJYUhLV1VIc3RRZ3E1MVZ3?=
 =?utf-8?B?MWZFbHFTNC9kWkFsYlFac2xKTlZ5UVBXYy9WMWkwSjJkeWk3eTJsZHByWHRh?=
 =?utf-8?B?S2lKZmY4UGhBS1hzVng4MTBIaVBpM1AxcDdnbUNaaTd2cnNhdFN2akVXSEJY?=
 =?utf-8?B?WGYzSXVGazBvajNmcDhCMXd0RGFCQ3phenJQYnpudWtLMDkrWm9UOFE0enhS?=
 =?utf-8?B?bVA2ZDhRTkhpUDZqN24zaUtXSnk3eHNoQ0dEOUdMMHNnNlpQY3JzR3QyN3h1?=
 =?utf-8?B?NHlGQzY4Snl4a29UL0RkWkZSZzNPUVB4OUNqdENTZnZ4TE9aWE5FQVEvQkR2?=
 =?utf-8?B?S04zZTdUTGo1enA2RUVscTFvcFA5NTJHODdnOFhkTFVkbzNacDk0UjFBem5J?=
 =?utf-8?B?N0d4WmVoa3lQemRFaXpqdUlDZzJJUXF2UGQ1azJFNjRMUzU5SEtLWjBkeXVC?=
 =?utf-8?B?NExiNGxjdXcvNUo2ckRPNzFIZnh6d0F0dnFuZktBS2RmaytGMzV3NVNTR2p3?=
 =?utf-8?B?V0xCb2FnbXRxV1psaGJkSGxPZzFJdHZ4Zm50VnZwODIxdThVZ09UbXhlbk4x?=
 =?utf-8?B?aUpLeTNpcG96YXRsWTRBaTI0cjFLZFRlRE04MWhtc01RcnIrRzAzSUdsdXow?=
 =?utf-8?B?UEtaUTRxREFKdUg1a2QwVHNZUTFCUVR4WDhWUWNzNUorM3BrK0wvZ1o2RXJH?=
 =?utf-8?B?OWdSR0NKeVFLYVBzZWtScTF2K0s2clB3MWVjSDgvZFZ2ZW5tVnAvQSszUEhk?=
 =?utf-8?B?S3lYSDNzNlZZMG14d2p3TTdrQTRQbzBhUUhtaGY1MnZZWFRrSWZaUzVoMlVD?=
 =?utf-8?B?WmEvN2ZQYjlWNVVGTkV3NG5oM2t5WFdzVHFPQUxWN21WQnlYdzhzYXpNeVRl?=
 =?utf-8?B?YWI5SW9PWVdwSUY4SWM4SUNDbWEwSndGUHpqMlFacWVLRGIraVExd2ozSk1t?=
 =?utf-8?B?RzJOcGtNckFsMW0xVU1vOFpoM1BvTXdpV1pRRW9zdTk2TW5MWTlQd0dMSm1U?=
 =?utf-8?B?L3cwM25RSWFnaHd2Qkl5Nmc3aGlhWDVaUEQzQ2ZqL01zeWRJRHdPUDY0b1RT?=
 =?utf-8?B?V1Bqb2lmclR5b1BKYVo0MVFJNUVyZmZaSzJaVml2WE9XSENFQWIzSmN0N0Yz?=
 =?utf-8?B?dlA0Vk5GUVZlY0lFenNPN1VnS2grRWMyZmpuT1psSjNHdnI4OEoyclRZaEp4?=
 =?utf-8?B?aFNXYjdTcjVMNWl1dGRzQVZ0OW5LU0psazdNZ0lmZW02QUc1TUlFNFZ2d2c5?=
 =?utf-8?B?WjZDbDFlYjFiZ1JYOHd4MmNNU1NqWXJjRS84c2M1VmNoMGczM2p0aENPbTdJ?=
 =?utf-8?B?L2Q0dzkreURBYUwrMzVOWHRHWGpsdi9oZFJjajVSWUZMeXp1RVY2UXc1RUp3?=
 =?utf-8?B?cW9kSWhVdk8yc0tYRWFMUERVMXBmYmIrOWJTb0lCRElqM2dYdWFCQ1hrM0Q4?=
 =?utf-8?B?cVdTa1JtakRxYW55M3VSWkl4aGVGMVJEZEZqeDlHUUpodThsK2IvangzeENZ?=
 =?utf-8?B?RjdkU0c5WjVGODEweUJ6Z2ZWa05VdEtDbVJyYWhqaUlNTTUzM2Y2RVVoV0pW?=
 =?utf-8?B?MExmMHIzWFRwbm9wSmt4bkwycmVNRUREUWVhdlhxRnlKKzRIZnc1enBEOGtQ?=
 =?utf-8?B?NVhyZG9TeEVzcmllbWJ0N2NJTjQxbkNXVTdOdW4vMC9ySE1idjg2aThvNzRY?=
 =?utf-8?B?R08vRWVEUEc5aWtPdENvZmNQbTJNNjg2cVBqY2YxWDFuREtPSFpycmRBdUZ0?=
 =?utf-8?B?WFcvWmFiZ2tPNmVYMmpBd2FtbUphUzBiNzRPVC9oeUI3RFBxd1Vydk43NlZB?=
 =?utf-8?B?dDZsT3U5dkhXSk1uMGtlbEVpTlQxZU1ENzFDVUZpdjNJZWJUS2ZWUGRqNDBy?=
 =?utf-8?B?WlVBaU5PMENSSEtuUkV5aEx0K0N1dGxLMlJqNjNzdWNjVFhTR3Q2QWgyRVRt?=
 =?utf-8?B?emxUREhRRDErUkY1aUhxWDl0UWRhQVVQWUNqU0k3azM3VXQ5NVNnQWJsSFZB?=
 =?utf-8?B?ZzMxd1RlVFdQVzArcWQvbHVyZ2ZqTGZkampMeXNRSGpFRzJibFJJcnorSDNn?=
 =?utf-8?B?eEZ3aGtpVU84RDdsZEpzRGVacXJpbVJIY25jYmczbXBXeVFnZGtQUHJTNEU3?=
 =?utf-8?B?aVErdnAzQktqRTRVSlJaNEk5a1lLQWlKWW9qb3NZVFlud3NpUlZ4U1ZBbWdY?=
 =?utf-8?Q?HRRVwh5+Nrx4EcQCF5WS9a1tFeQvILrlIfP2Z?=
X-Exchange-RoutingPolicyChecked:
	fA/134EWrk3JFr5D+yFKYiIthJDAppH8uiy+d88UIwjN7OtWVS7JzOm7X1bKu0BHhhUUSFJ0hD9W+um3PUx+Q1Xxp6lqbGtdhhb2tMP8t3GVnwVLa1Z+83fPdXUVcnu5P2zv/+DgdVpapvzEp2s5XF0psEL1hcqAA/CRKDWJrj5BG26yEzMDaR2ma9UJID/i52VMpfok8d5KLYN/L5QCpMIsoDrDYmRXpv12/LfwMZJO2Jc4p+yC7BzTnhStt5uYMoL8wAlcGjH+QeE286GBzl0P4L5LGJdJZ5DU7vNDKEGMFEQhConHKz7/+wTbsixlMeUv0ZS5c5lW+FK2aFwJQA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qpm3c5pCFEYPuoIwFUCZ5GST8wT5S8jgqXYYoBaH/sOTjJrNPkULbgcUlfh0r3essz1Et6TZ/JBaMf1kjFBpFNvkLOz53nMtKfHyOu7qnRDJbT0hN4g768gV9XjIEpO8wRjQuDjKfNh9yfUaG6RHK34nZCY6036JljefcbKpcM7YNe+xQVOuW4Ta0HVvcqUOmcXWB61bKcAXeoYR5iwb3SV1LpDiyDgZZmbXPG3z8iaft5i9c4KkmupjwwYbuEVLMWxbkZmTYELhBWInQo+6F430WsqxpHJnfaX56nXcNa5KrnMCr3JIv9+eJWTdss8d+dZCAiKevkwebS560XytQD0XmOqgA7KTmiTSoqMit0d4N1Fo20zbRcFfk6YBANRkKBqiiEITAqGg2ybw019myu+71YeJmdkm14N6vyghM4bwWsz4MgTKQ9u7TId6MQ/k0UaJDGIMOpDg0At1zY+GXR5CZbOrqkHMY196ylgrR3Mj7YWnYLVymQzc4hBd1n8GY5D8QKD806FwaIf7CRtZ3ahel+VKjJ6vpuAtjQg7f1O6qsxKhN49Ihf0o1vNH8/UQ/2k1xTHh+4JAT7/wbp75+Ml4cQSI+JscsuBCWvyMO8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a99177e-5c4f-47b9-18d0-08decd2e2e20
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 11:38:56.0323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UVrQtvvBdGAvb82zC8aGxO+GwNkYH4CVx79NJizNBhk6t4Ef2BTcfbtRvqkqDfb2PQ31wh+XPY4zNTqB2R9VXRI3abcqtrOEqaE1KQi6Iv3WcgT43KtkugDjnYFPd6i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB997767
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=417 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606180108
X-Authority-Analysis: v=2.4 cv=S4XpBosP c=1 sm=1 tr=0 ts=6a33d8d5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=q6QsLP1BYBS-U5lR-CgA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEwOCBTYWx0ZWRfX1RDIhQCrLF1e
 SYJgH42DKg4NYqD5kJFb08hLl1XFWzV+qzBwoweEviHOu1v3E+0ik69V2PpACxuyFuYFrzZ811k
 JdHcFv96DP4DUgzi8yzf9Q8wii2ProlH9SF+J+ezzhUxAd2cDoba
X-Proofpoint-ORIG-GUID: cSeTwSmg1ftzgIn-EfR_WPAdE6RwM0qX
X-Proofpoint-GUID: cSeTwSmg1ftzgIn-EfR_WPAdE6RwM0qX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEwOCBTYWx0ZWRfXwKoD+O82PNz7
 KP5B+CCslaR+eBUuClleEHASWW+uKDD8wpsipT9u9eug+bgh39GXRNs8bDkdvEVWAkfH4gV+WWK
 +3KfTFrr7/2mhHeWUhu6nXTocJQ528KqYTcKq7AWo7irGt1M1IdYrqkZbuQxpIkjGXcomabdNjN
 4zltqNH9e906+i9MWizZfTaQn/Qy5KQkeWKAh3ZRTV9I3xAdnaaXre8IA0UWWlRZflHOOimU7jX
 ER47bcOlC1n1NL6IIPAeYsI6zDb0Au3Cc2A9HuM+xKcBi76ouKxJCHpbSLUSitZW5kTkInPhj5D
 TAIcGldzgWoKK/vAkXYfXqidZPxDWluBWTOmOPBnhhICQ00AIR56lrKLSpn9bTZEaey/LJvXjVC
 smgn++tSlpazbrQh4Z8jnNLfrPV2ND7cfwH++UeWg3i1fMCidDHC0xKxId/hbVn15gC5g+O/QAz
 7Aleb+3KMA4A57IeduBwE/+Ev/xHHUYZkMIt2ZS0=

Hi Greg,

>> Upstream has this before the eth_hdr() users in dump_mac_header():
>>
>>      if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
>>          return;
>>
>>      nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
>>                     eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
>>
>>
>> but 6.12.y still has:
>>
>>        nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
>>                       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
>>        nf_log_dump_vlan(m, skb);
>>
>>
>>
>>
>>> Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
>>> uses, and replace the open-coded MAC header length test with
>>> skb_mac_header_len(). Only skbs with an unset MAC header are affected;
>>> valid ones are dumped as before.
>> ...
>>
>> The posted backport fixes the fallback MAC dump path, but upstream only
>> assumes the Ethernet decode path is already safe because of 62443dc21114
>> ("netfilter: require Ethernet MAC header before using eth_hdr()"). I donot
>> see that commit in 6.12.y, so NF_LOG_MACDECODE can still reach
>> eth_hdr(skb) without proving the MAC header was set and long enough.
>>
>> I think 6.12.y misses commit: 62443dc21114 ("netfilter: require
>> Ethernet MAC header before using eth_hdr()") so this backport might not
>> be complete, thoughts?
>>
>> Maybe we need to backport 62443dc21114 ("netfilter: require
>> Ethernet MAC header before using eth_hdr()") as well ?
> 
> So that would need to be backported to all stable queues, as that commit
> showed up in 7.1, right?
> 

Correct, I think that is the case, but haven't backported it to stable 
locally to see if it applies or not. Looks like the fix needs to be 
backported to all LTS kernels.

I agree with Git History presented by AUTOSEL: 
https://lore.kernel.org/stable/20260420132314.1023554-287-sashal@kernel.org/, 
particularly no single fixes tag thing, some code paths have commit 
1da177e4c3f4 (ip6t_eui64) as root cause and others that are fixed have 
different broken commits, so I agree it needs to be backported to older 
kernels.

Now, this particular backport "[PATCH 6.12 100/261] netfilter: nf_log: 
validate MAC header was set before dumping it" assumes that check is 
already present. Not sure what's the best way to handle it. Drop this as 
well and backport them separately along with the prerequisite: 
62443dc21114 ("netfilter: require Ethernet MAC header before using 
eth_hdr()") ?


Thanks,
Harshit
> Note, it was part of the AUTOSEL group, but those were dropped en-mass
> as people were complaining about them.
> 
> thanks,
> 
> greg k-h

