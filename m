Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5592ED141
	for <patches@lists.linux.dev>; Sat, 19 Sep 2026 16:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789834250; cv=fail; b=d4dFJMbkfDUBb1HkLgjD0HTR2h+k3w0OnTUbW/dyK+sGcq2Ui5/q2y2BhSgK0+9Jzc8UQo4P6Qzdw9Sbz8zEaTSVwT9MxyZf3wtfSKvvOuKxz+NwGrctX2TUvS9wzY2103OYboOqvpKjiblKpBsUg6fsqYQYUL1kcfeP680hVf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789834250; c=relaxed/simple;
	bh=TFKduN4UYRmGxwGeARIvpqu4ZGT5Btsm99yqtEJqkGk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jLtIUmmIA27XPCt9ByO4/v6oLfpg67R0iQMxW1utXrJXt3hH3atO68LVKhF1sJGmJHeVQHfxhKZ/2rCFJQdFJLqT62sJtnscjf3Cm3W2wrRgVfkq3yyPrkfwAnxm/zXjJH/e2pHOHpXqXGExF/hBUoXAjUbOZ/usrrmlzKLYa14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C9iUDgdg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ft2i3FYm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C9iUDgdg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ft2i3FYm"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68JFjduF1336162;
	Sat, 19 Sep 2026 16:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qu2Spr6EooteLirBENX1m5/0ImUINyZE6R0sWFlQ3iA=; b=
	C9iUDgdg9cvTw4WJvO2P2bx83T9q6pr7RxaNZWEmd4eONmS7RmOxyluKHAQTxY3k
	8UBDm19ENqZm7hcnTVmI8kSDoFYdSocUzrjTIn9eUtimpO/Qg8Sa30Z0gzxc//aB
	93+1BuqS9jUd3YgA6dc5UCySPUCRCcc+NXw096TdeEdKYLqfq728XGBvpZZpeVOl
	hyRiiiyNL2cWUxuVweosdNNN3b8Orrb+7dMCNFWS4gZSl26HIMTztgePquZJ5tpQ
	hCe9ARtKevZY0K+76CprobChlgohAN7W24jT9UIA8dVB7S8Icc6tbyBRsvbkIt25
	f29Tvhr4voF+i7nAyzfjNg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk1dr8we-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 16:10:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68JGAfn5030670;
	Sat, 19 Sep 2026 16:10:42 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gsgumrdv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 19 Sep 2026 16:10:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cs4cgF3J4d1kdZpYXVM33e3NFDjJFF5EjWKunI3pO4mBtU592i37bbnYdbyM1XfDXaYHCGRH1uzVULpAUS3cg8J/kt/PbWU532Eg06+p7Tz+I6HuTn+ghEQTPjANweRXki2pvsb9ieaJszljIigomx8Z/HNg/U52vZwlVvLtPe9+TIk0No8VnyCZxIrkRokVtXsJNCpwbwpaw7wOZ+T7TKV+PdfLA9BG6C8nnPi/R3fLV+PcZOKdLYfQ37wMvpWZav8kRaLXa3U4Z8yGu1YYS+KLM+lka1s21Ti/tJ6WIh+9DzeGtOlufXupBdQJwVQ/YBB0Ak+cQziTaYK8piBPqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qu2Spr6EooteLirBENX1m5/0ImUINyZE6R0sWFlQ3iA=;
 b=hXRza1D2IxdV8cty+KQT3tfBYHyYw1wqpcIXVHelrZuMoZ5KUp7OKWI7APIlH9MyAT+qQS0LvqT83T6kpwdO2ZN3nPOGhQSHIPINHBBnIBtG0rz69XNcVqpOnaDE0NSEcnAxo4HyU3LwvjQfcZi73UDTQX9LMVusFDl/5Wcxe6h2HLPeIHV49GNwZ8qJpM3CUbJC7FQiQezXpcSniLpgVTibXeVNAA4N7UVwpSbiBZ64oQrmRH7kKI2CZ6lYYJ5Im9+L31T8zM0PecC4C7F0zfCwAGwFk62IzRBPxwB46NAB+LNcJZ7f7n2f1Hituem2/lP7rMCW1gb4gQnOMRHuWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qu2Spr6EooteLirBENX1m5/0ImUINyZE6R0sWFlQ3iA=;
 b=Ft2i3FYmmRmZdE80hlG4o7i/na4XLA37oB1nuiIzsB3nNOZ/eolpW9bosChYRtokmV0pfpAIOK5Pk2zPiZLrzk9epeuQZCydTZepG/qlMUy+nZ36NwAFrzZ54N9FCvpu89jE1JnyDMQ0XYg4zuHf7/cFaTb1ra8u88x7Bw5pvJc=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SJ0PR10MB4717.namprd10.prod.outlook.com (2603:10b6:a03:2ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Sat, 19 Sep
 2026 16:10:02 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sat, 19 Sep 2026
 16:10:02 +0000
Message-ID: <275530c5-71cc-4dd4-bb00-d39c236c9edd@oracle.com>
Date: Sat, 19 Sep 2026 21:39:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0991/1102] nscommon: simplify initialization
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151605.594963317@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260917151605.594963317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0286.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::13) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SJ0PR10MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: abef7497-581d-43d1-e1de-08df166875ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|10067099003|3023799007|6133799003|5023799004|22082099003|56012099006|4143699003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xqN1/G1jmTsvjdM/7GE+KMjUCNp8ELeGYKDHOBtSUrfR85WT99AQsG1LOa5DMdofzKYnq6lHHx/IGQMBH0Q7tSDHDDaM57pG/KtQF7RqZBPUhrkg/YDn3wvPz1PwgPNJF3Mxur3M+HDRZPpYBL4dDaFFrOW99eEkekj5Vl8/9ZsehWLLYCDvn80VlTSMX1JzMW/2iJ+aNC+mWaITDzg5wQzQ1z7hSGJjX0loQsTnJPgp2ykc0Htv8AEJfCGhXbbXxz7luOnZ6slwYRPS7z6mGg92FPGOxGSJCc0qUTgr18sOX5Bum/UD/C7lMgAPuQhBdxcpiBfCBnGLLmkBvZoW4Hx2vfcfTi2xgi2YN1SegTAxOe8m/WQs7bRRg5iLLDNbgDicn+XnPfstkpi/ZTweCg0KZcVJbZ6T6MLpRk9NvqRpI9yqIcE2jKvJhzx6nCqlhWB8CJWo2/3jp8GO0MgOwCvkm+6FNgTake0F6iguH/0/lHTxgTn2u0D7O10DEuqLDQmt55FJ6GyVxPjeWysviY5vAEYZ8zB36//CY8nv13n4lhex1N/KlMcSqbInsTqTa1tm/SyPIZuyoDxY1at5r/VMqUOC9M/7eSjhdGxkXMv6ZC0JSjVTY7X2qVKBVpanfYfbsqDwc3U/wcReqAdRVp8UgkFhM9BnWlBRQS+y/r4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(10067099003)(3023799007)(6133799003)(5023799004)(22082099003)(56012099006)(4143699003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3RhUnIwRnAvTG9CR3NIWmdsY2VjY3VPaU9nUzhnM25za0hMUTRWUERMSTFX?=
 =?utf-8?B?WStrckJ4bmxkTkdYUi9XbU16YkIrQ1gwNUFXUVJncVpDQitQdG9BbjJNQ2gz?=
 =?utf-8?B?UHpOUGh2clozQ0pVVmlwUERzNkFzQkRTaklGUUZhbi9XRjlGdXc2MytYTmdI?=
 =?utf-8?B?Q3o0aHY3N2JaelV2ZFE3bkQ0dVgwYncwcVpCZmdSR01RR1k0bzJ3ZWc5Q2tZ?=
 =?utf-8?B?VXhxSmlucEw5RjMxTWFzNjZxSytXTzFxMVZvQThXRFJrMHZ2T2NaWTFCelkz?=
 =?utf-8?B?U3JkeFdSdFZyU2duK21OUTZiTU03Yk9sM3B5cVVxZ3MzdDlDVUszcmtOWTlt?=
 =?utf-8?B?by9hbWd0VUswSjNEWlRiV2FPU2pUblZ0Vm5NT2JNaFdZMFhucDBjaUh6ZXd0?=
 =?utf-8?B?TkhUSUV4TVdTcWpsT2lyWEdhUWtVTTVzMFRYMjM3bm45ZXpPSUZCN1cxR1Zr?=
 =?utf-8?B?K1FZYlgvYWlqOWowZHNORnUreGtTTEQwaU1pVk85SXJjQkh6SVkwdGtWWTRn?=
 =?utf-8?B?YVd1cDRmZ3I0NWgrUGlna1lsaEFQK0NKcGVhanVmbCt6T0dXMi9jakZUVkU4?=
 =?utf-8?B?UnljREh4Q2ZzR3ZvZ0pQU3IrZlg5YjNHZk5TYjhhaUQ4b2t2R0hNZ0pOeDlT?=
 =?utf-8?B?ekltVlU1amdpajlKZkhaU2ZBRS90Y2E3b1BEK1NZZTB3Vm1sVG1JckVZWXlt?=
 =?utf-8?B?N3FUR25tUnpzVE4xV0Jad2dPZWQwMVZFalhTeVBmSWpVc0tzSGd6K0ZVdTFH?=
 =?utf-8?B?c0tZcHFsRk1Ib0l3dHA3UHg1eTlrUll6WVB1Y01ZMXd0S2RRTEZ5THllUlRQ?=
 =?utf-8?B?UDRHUm84MGgyVnRnbnpybTcwL1IzL2ViNG5QaGg5ZlAvTlJ5eGZEaG5GTWI2?=
 =?utf-8?B?c2ZhcWw5THBmY21IellZZlYxeDYwMTZyTlYyd2l3MlUraXhjengvRGdYdnow?=
 =?utf-8?B?V2JaSmtTb3orZmVKSHVaL0FHOWszNWxZM1ZvYnFtdXMzZTdvUWwraTB4ZGEv?=
 =?utf-8?B?Wkd4MEpURUdLQ3EzZDZVNEpJMWFwSTJYc01oUC8yOEJ1bFVMTVpUVjY3U3F1?=
 =?utf-8?B?c2NxL3dwQ0U2L3d0VFRvT1FkU0N0VWNqYlJYUmFxSWVSRkgwSFlhR2Jtamsw?=
 =?utf-8?B?MUo3V1lkY3V2U1Vpc0RLZEYwRE9KeU9DbTloVXd6U0twcmZqM0dNYUtueXNY?=
 =?utf-8?B?VFplN1dCNzdrVXJCaG5NYlFJT2dRZWlkSlRLc3JHbHF6MWpCU2NJSUdWSTJi?=
 =?utf-8?B?eWMybFZRQ2ZDbzhPZmFvMzI3SThNY0pmZGhqR09URm1UMU9MME9jL1JXbnE0?=
 =?utf-8?B?cVVHeEdCMUxxZHdRZjArVStGckJHenl0dEVhWTVsa2Y1cTNxSnlsSE5hc3ND?=
 =?utf-8?B?UUhSc2ovL3BjVzkwZmhma1M0MHVQWWpoMmdHelNEV1JQaTVVSVI5T0hrV0I0?=
 =?utf-8?B?V1RseHQvYkxNVkxYejJ4MC9uZllObjdELzJHeHEyRldCWTBIeXlYbU1xSWFy?=
 =?utf-8?B?RU8vU0RndDZxY2ExM1NrNm4zb1RsNE0wZHhOVGptN01Sai9lVnVmVGR3Z0Vh?=
 =?utf-8?B?NzlwOG5GUHpwOU1CbHJ3RDhTRy9sZkdNempvdVkvZE1ySWxhMWF1UVBReEZD?=
 =?utf-8?B?bHFjWFM5TUxISUo3cGt1cmhFRWcwSFlxUm9aa3VReDVIakpTMlFaK1RSWnZ2?=
 =?utf-8?B?ZEk5bC83emwrV1NGYW51NFgxQ0N6MkVSQXhmbmhNenRTSncvaUlXaHYvaHF6?=
 =?utf-8?B?cCtaWWo3YzBReXFXV000THluckhKY0djNUlLRXlmS3NkSWVseitmVHIvcGhY?=
 =?utf-8?B?Q3RoZzlZbTlWTlYwb0x5Z0xNSXdDWkoyOTZoeXQ0aWszSElBaHpLT081TDFM?=
 =?utf-8?B?MDVPM2FCR0N0dm9EMk0wU0ZQOEVVZEhacnp2Y3hhMHJCa1hBZENlOTgyUkVB?=
 =?utf-8?B?MVBjeEhZQys3RFgycEllWng4N2lBNlJ6VGcxTmsxY3AwTDZEd3RNRjFEVmsz?=
 =?utf-8?B?QWFrZXUxQWNpSnRsaGFGajlIUE50R05hcnNESVZxeHNOaVc0bHZER1B4azla?=
 =?utf-8?B?VUsyNWtNUDc0cnZNb052Wk9LRHR5USttUjFqQXlnbTN5NE9kNk9NSWVjU1Jz?=
 =?utf-8?B?ZDZtNVR6bkp1b3B1TW40d1dwRTFrTVRidkJTbldtNEV3NVhoT3dqVmRLeGQx?=
 =?utf-8?B?QjRiSzZ2c2Y4KzJTV2dlcUR2OFBmQS85N2VWdzM3VDNORGVqZlFkMGdVSWwx?=
 =?utf-8?B?cjFvejVSbkNIMjh2MDNMQUpjZEptREM2REh5QktuSHE4Mi9FMzh2dEptTXlW?=
 =?utf-8?B?ejFtKzNrYnpnUWlxdzUwQnJUa1pyVktGWE1NQnNKckF4QUxFeVN6UVE3VW1C?=
 =?utf-8?Q?ee6rOky+UG9i9lwqDq+hj/iX9BM80uahXn4Hx?=
X-Exchange-RoutingPolicyChecked:
	VRQkcG+CC05fOFEjvaocYw3k2X8gxYDAwhD+lxzYEG07/PmQk12KQB1OoojsmTRgEK58OVm0Y2lvbG2VGkJXpU2mOi7DMWdrDZr5kZim9dpggtUb65xL9UKPEcZXrCxE7dZDcq6iIhBbQc2HdARIwcqgvlJuRbRvJrdai5b6gOdcBt3QGTt6txfkHWIvPDWg+yVgau+J+XJ4//Q1EsF6vMf6tr/aCEIc9UczLD9aUoSnI3rEpfLbrwF/GLS7Ca04TVq0XuRMstdD12IglbF450nR98YKiqTsr4IJuWn/+T/Pn6umQfGnVeIeWay5i3p6ZrJ+9LmK+scyZ3abi4Y5iQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0atwUfIkyt3lHKDkskBz88pZmKlh1aOGGVIEjaPKempkTL9HiDwhFusgbRtN9EcdsYvTMzthY9YQkWFhOY0eR5wJPcAEsQgVzj3pLJzuXj7GNAw2m+ze28V1nMsl4ndcHZSo7zhXjMrdoQShJXrCX56tSjRu2X/XJQSareQQmKlhNWwLHYbykUURmxHnkiqUynX2bQ9cMU4io94rtJiIAOHJ4iG5Jt8MRuHxyGGnaCWq1PG/MbDNV5x+tUblpDa+ZUHAtEWR/1fDxFSFfeUhawsCELitcO6OHM3wm14kCgNHDItrLpQh/Jh4xrk7+267iOwVLb8ja3IaXOcxAN2ur7nHuQUAlng+Xbu5w618ZphkK5F1oHXXUbCYpeJjIp812vDLiQn+BmVE48ysav67jAuEH76TMWbd89KzDm+sqKw252Z8NS8x3BTXLpH6rwv2FuXxYPBQ+STkFRcPyVqhAjE9BRUUWy4wrpb1SmmKv+vXovJjEpEXXgjG2gW9x89I6wwEm9NzeckR0VYwGzbQXJotj0B0oKE7E8pXmog5mbnxIhFPtfUeD+bqGaLv55Pr+01JGtUmJEIDjZW7IFp2qOKnqfbxvUquXZyaYaKI7ko=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abef7497-581d-43d1-e1de-08df166875ea
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 16:10:02.1606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K9Czban1TnPEehT4gBlLFooOfM+FkJJHCAHdbxfC1l9UsUfh65joVHfIkLWGUE2tmLy3GM4BWloiIvFRTUz2qbLFBTa/VoIuwZ2rhwPBfB1fr5aSkgIs4dmv980IhVIG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609190236
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDIzNSBTYWx0ZWRfX7aXVUtqrTSQJ
 BRMzR3zSOscVL+v1cRuFaDMKnuf8aAAzDfBSnmKatdOkSUn1HFm1hKZboAbkf+5F17cODRKTXek
 UpoSAaQrWJo7yLX4u5Ukxo9uJf4TRMQg41yClMts1IvOqEUkOr18jqK3mLGv8sEsrmw00oHNlGb
 tCoVEeIu7xaX+aJyP2uFdF95jBil0suhZU0RL3BR0I+jFi4nwrlHFW1NE3OPN8QlnOyzNZB/9Yw
 LaD7ptByi56MFJzEX/Kxey2apoDocKSTtWpbsXdSwFMjR9c7OW7AnliSONen5vcNYWwDkT3nsYL
 ywVWkbDIF5v8GSilf0GimiARFUD2IZtpT525YKbDUGLIktCF8bO3JNz+iJ2rJH1u7gmyv3tYKu8
 1V2tuTsf59VOccOv/ou8U+Pm5Ej13HhDflAgP92pXKQ8GLesLO0QDPAl6W7+bYivBh6XN9eMO7U
 6ANv3AyHlclR5Rnn0V4XmN4uAA7NDTTiHJReFnHs=
X-Proofpoint-GUID: 0nfScMbSdjz3t3IMgQbho3ckegyKfNkz
X-Proofpoint-ORIG-GUID: 0nfScMbSdjz3t3IMgQbho3ckegyKfNkz
X-Authority-Analysis: v=2.4 cv=eNqGH3p1 c=1 sm=1 tr=0 ts=6aaeb403 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=ag1SF4gXAAAA:8 a=_bFojVGeSFd1RiKcJBwA:9 a=QEXdDO2ut3YA:10
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13532
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDIzNSBTYWx0ZWRfX5SIIxNU7Uq6s
 l0Hc56rrC8nn5M4sru2lvBjHp2P+AibuJYoAMXS+wWQ8U6ZmRkCPGisn7FYxse637gg/7W0kgwc
 AilpXeX2TrPfLhBQkchZA56Gea4Z2xpNAQ2FfZ6g+o3J+bPBwGlg



On 17/09/26 8:45 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Christian Brauner <brauner@kernel.org>
> 
> [ Upstream commit 5612ff3ec588be09f11a9424db6d1186bcdeb3fa ]
> 
> There's a lot of information that namespace implementers don't need to
> know about at all. Encapsulate this all in the initialization helper.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> 
> [ sashal: Reduced backport -- upstream 5612ff3ec588b touches 10 file(s), this
>    backport carries 1. Not backported here:
>    fs/namespace.c
>    include/linux/ns_common.h
>    ipc/namespace.c
>    kernel/cgroup/namespace.c
>    kernel/nscommon.c
>    kernel/pid_namespace.c
>    kernel/time/namespace.c
>    kernel/user_namespace.c
>    ... and 2 more
>    This note is generated from the file lists only; see the resolution record
>    for the reasoning. ]
> 

Hi Greg/Sasha,

I ran an AI-assisted review of 0f71b995d44b and verified that the
recorded backport identity does not match its payload.

Claimed upstream has changes such as:

ret = ns_common_init(new_ns, &mntns_operations);
err = ns_common_init(ns, &pidns_operations);

The recorded 6.12.y backport instead has unrelated pidfs code:

#define pidfs_ioctl_valid(cmd) \
         (_IOC_TYPE(cmd) == PIDFS_IOCTL_MAGIC && \
          _IOC_DIR(cmd) == _IOC_NONE)
...
if (!pidfs_ioctl_valid(cmd))
         return -ENOIOCTLCMD;

The commit claims to backport 5612ff3ec588
("nscommon: simplify initialization").  That upstream commit changes
ten namespace initialization files.  The stable commit changes only
fs/pidfs.c, so the two changed-file sets are disjoint.

The pidfs code resembles later ioctl validation and CONFIG_PID_NS
changes and appears defensive, but none of it comes from 5612ff3ec588.
The nscommon refactor itself is not needed on this older branch because
its helper framework is absent and direct initialization remains valid.

I think we should drop the change. Thoughts ?

thanks,
Harshit
> Stable-dep-of: 9688a4680293 ("pidfd: hold exec_update_lock around namespace ioctl")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/pidfs.c |   22 ++++++++++++++++------
>   1 file changed, 16 insertions(+), 6 deletions(-)
> 
> --- a/fs/pidfs.c
> +++ b/fs/pidfs.c
> @@ -115,21 +115,27 @@ static __poll_t pidfd_poll(struct file *
>   	return poll_flags;
>   }
>   
> +#define pidfs_ioctl_valid(cmd) \
> +	(_IOC_TYPE(cmd) == PIDFS_IOCTL_MAGIC && _IOC_DIR(cmd) == _IOC_NONE && \
> +	 _IOC_NR(cmd) >= _IOC_NR(PIDFD_GET_CGROUP_NAMESPACE) && \
> +	 _IOC_NR(cmd) <= _IOC_NR(PIDFD_GET_UTS_NAMESPACE))
> +
>   static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>   {
>   	struct task_struct *task __free(put_task) = NULL;
>   	struct nsproxy *nsp __free(put_nsproxy) = NULL;
> -	struct pid *pid = pidfd_pid(file);
>   	struct ns_common *ns_common = NULL;
> -	struct pid_namespace *pid_ns;
>   
> -	if (arg)
> -		return -EINVAL;
> +	if (!pidfs_ioctl_valid(cmd))
> +		return -ENOIOCTLCMD;
>   
> -	task = get_pid_task(pid, PIDTYPE_PID);
> +	task = get_pid_task(pidfd_pid(file), PIDTYPE_PID);
>   	if (!task)
>   		return -ESRCH;
>   
> +	if (arg)
> +		return -EINVAL;
> +
>   	scoped_guard(task_lock, task) {
>   		nsp = task->nsproxy;
>   		if (nsp)
> @@ -202,13 +208,17 @@ static long pidfd_ioctl(struct file *fil
>   		}
>   		break;
>   	case PIDFD_GET_PID_NAMESPACE:
> -		if (IS_ENABLED(CONFIG_PID_NS)) {
> +#ifdef CONFIG_PID_NS
> +		{
> +			struct pid_namespace *pid_ns;
> +
>   			rcu_read_lock();
>   			pid_ns = task_active_pid_ns(task);
>   			if (pid_ns)
>   				ns_common = to_ns_common(get_pid_ns(pid_ns));
>   			rcu_read_unlock();
>   		}
> +#endif
>   		break;
>   	default:
>   		return -ENOIOCTLCMD;
> 
> 
> 

