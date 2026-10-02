Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6137D4457D3
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977768; cv=fail; b=fXX6Z2c0d56sTPEL6ksBWQNCDDexCuuoBL1v4Uu41yQe3VYxFve0OQuTzn0V+GG6BOWcNdtWBsPeFph9iV5QG7BU6Cs2J973+pP7w1nTr8OFvnI96L0YOeudORNpDWTjJ8w2Wl4hJ17Enbu96Pkd28rxzbpWMgtDsWKSWTuedIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977768; c=relaxed/simple;
	bh=NKoGLAbYgIObu8ckIO5PiGrk7xIEofWn28ekLoJNKOs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hs/zvWoyzZd/vAwt2hNr1vqogYcGgm7Q3Uec0iPCkoSKt78eCjHvVcNvhqCS0U/FKl130cvcfCBmoyTnIuptQJawpE406hkYlPlkzkcqDYW4y5VQQLThMGC+43o1AuNcdjfetjZi4Ge8K5poqXMGsKrO0GkL/uVMoGr9mtbNlpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kvepTc2d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gXSz8D9b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kvepTc2d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gXSz8D9b"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692EbaCH3156202;
	Fri, 2 Oct 2026 21:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=V7M4mBlRjFg2gBdSLb5ZBdEqp86ZSuPawuw8ul8OS70=; b=
	kvepTc2d3xgGhhip5V4CEPvpZWbzylS23sBXXPIHXFHomO7iuK1exxfXeyxNIo/X
	OS36LDbaJ559znMMzL35Cp/Bkrf61QaoqV9NQWm6ZyI3hS0NOxEAe/l73lnSIhCK
	W3sdCzmP3BlRyLmI4BlDIHESh1I1p9vESgwQXpmqn7/48iGjDGvKtWW6IfgWYT0U
	4sB3C8BOQmajFJaFsuMUbSW4fwZYX2eNBtfl+RA726C7EgwPdDCjCf50MA+/SIif
	GSbmX8GjNDHoczGjAzygCsQ2RuPq9GQ2rhDrCrrMqehmT0tdKDY3eQvU8YzX6kJ3
	chSO21f06qrJvJnGA/NJyw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx6kscsjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:49:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692LZRLU031319;
	Fri, 2 Oct 2026 21:49:20 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012035.outbound.protection.outlook.com [52.101.43.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gud8qm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:49:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nkm2UYCzLr32tB1Sj2591CQK/slBNwTNbRC//b10+dBmb1XHwT5CWANIVevuWGJLbAnNAd5jazS9A0PCbhWbxbgbbu1P442E7PLmBjdrJyc/v5o0q6DsejfWyXWcMOxldjp4WsYKcQwlz2AsPiVGztk341FAGA8s1VNAdYyiV9iF+Ji8OdhuFf6CxCr4mMOsTPeUzwqRQd5T/sQk0T0DNuV4nc+WbnGP2CMQuAkbsXg1mBMifEfx51s5McmERIbsC3URzT34eXAckqQmrDYDCLagbhuPTvkvnAZe/Wbd5Ltg3CSQQi4COqCFaRrZOak0q52t6WWKOk5rL5niPORYSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7M4mBlRjFg2gBdSLb5ZBdEqp86ZSuPawuw8ul8OS70=;
 b=p3FvrJ+HJsriG76xCqdrIDgtB0XGcyVfdwy8U1xnfu9AOd2yYcGoqGug46zl51xBER4MpnhcfRhkmuYqcAs+5ZKkHnpnJaSggeKXmZY13vqEJFHqxTcjF/m/tvEkBXloiCSb/AZvuCtsGBSZ88XtTACe8RVrc5t2X6/p3m7DdPY7S531zz8i996HvvfTd6JNjW+C/I7l3YxcqKtzU8BFA0YSKz00zVtM+3tfFDsgyFSPwR6pwqlkQVMrGE23KGG+Jp/A5Wk8PyoyZfsKWrA2VHFH7KFidLCuJvG1uk/7ifdwgi7kFgqE1fuvBjrcpKIZwc74KTn8D2ePU8QUiTkEAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7M4mBlRjFg2gBdSLb5ZBdEqp86ZSuPawuw8ul8OS70=;
 b=gXSz8D9bSnPjfDJxW3unOOZhhgUhRmMJnpl4wpvUEeBuJZxU8mCSpgO+KOsASRyrNZrzPKCmG5qXWc31cdzVVWvUcHf5Cvm+IUMV9zMeodxFBuX8HTgJ0mvZGfLY3a7OELlRDTcn32/WFiBjDS0IGkvdCcs9NSclqPq86RQu5N4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV0PR10MB719201.namprd10.prod.outlook.com (2603:10b6:408:3fc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.13; Fri, 2 Oct
 2026 21:49:16 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:49:16 +0000
Message-ID: <dea57868-11b9-4061-8b6c-ee1e2c227610@oracle.com>
Date: Sat, 3 Oct 2026 03:19:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 584/752] drm/msm/adreno: fix autosuspend cleanup
 during teardown
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Guangshuo Li <lgs201920130244@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20260930152358.131179731@linuxfoundation.org>
 <20260930152410.929547718@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152410.929547718@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::16) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV0PR10MB719201:EE_
X-MS-Office365-Filtering-Correlation-Id: 44e0ab69-5d74-47f2-1a84-08df20cf0139
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|260925022911599003|260925021311599003|260925021911599003|5023799004|56012099006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+oJTzVxLz6k1CXZYHwT8hrsWqUMN6ecbwWlcuShOKfg2L36IB0d04pIC+cFN/kmCfm8u6BlQ5rD/eMJlD62GmCIfNujXLnMoUAPKa2y0OJEqwxyLOXmLka1hpwQ81gSi/q57S2pmNwNkomzqCwy/tZC/UvmnwByydZ+F1F1JOGSD0Tx9BaQo7hn+ZwMwADeypwIETpiBoPRTEmge2IQTwqnfq1HMHNib/iNfcIiB1FLMh/qTr5iRW1Pck8Re9h6eIcZE03sV/TuYv6YaExIt8+TcVjJ4uzD2v0DIEHezbqa1T4fQuenvcQTvoV8h3NP7b7IdoJzmWrtRdLMYawO/KOBLOTOm5w268fJ9J1rdeym6Y+iH40qPm1JeLiz6+WxUYE9u0B+eUj0PNnO5boVbTi8eVy+9/31yB/bfox8zZ0Phqe46g1zw1GYsALRiLO+dYvl/gXXsXS1jKgUBkDtwzM7I6jCqBBBuwT3I7jACkCzVoUWilzDjYr89XX+NeOgMlvd/CID5Ysw9+0SAgnuKFYmTAayTMB4iUveL+5Wz7MRJhFRLLLi/PKYtY7MC8CtopclXHKsn2R6ePTzxa2GJasG3NYoeQTjKtYtmcedpX4w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(260925022911599003)(260925021311599003)(260925021911599003)(5023799004)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmVONExSY05tOFpnWVFNYWNuYmxSNmQ2aGs5L01NcXRhSGtWZlZLamVKMlBZ?=
 =?utf-8?B?WE45QlhCTVNCWHdIaEMvVXRydFRiSWhMaVpSVnAwQU1tNnY4a0dBdmJXWFQz?=
 =?utf-8?B?UFVFdjVjTTRTUE41eGNUZW12VXBCMm1UOVJPZ25QZzB5elhZdWszSDl2b3Zw?=
 =?utf-8?B?MlVmQ2J3eWdnQXRBdFBJSHd2Z245UldQTmpQZ1hVVnJ0dGZlMWpFb08xT3pN?=
 =?utf-8?B?RVBXSEZTejRYSXBnSWZmdkxKT1hyTGNjWWdxWmZNbVVOSXNwa29hVDJ1YXRn?=
 =?utf-8?B?MjlKblg4cU1rNlh0eWhyTXJzVVJxZjZSTUt0ZDhXU3BPVjF0VmhzRmdXaTFQ?=
 =?utf-8?B?WjgySmo2dEhPTEZJYUJSUkU4b2hqajJtNkxRTExGK0oyZzJTdXVIaEN4SG15?=
 =?utf-8?B?dk02WEVFSnNGOVFJNndhRDdPVXhDdExZZy9aMnJtaitNdjN1ZWg2cHYvQ0Fv?=
 =?utf-8?B?NzRrMjVzemlDais2VzNwWlN3ZTJ2S1RIelJLTkx6bmtLZ3UrL1dFcytla2xX?=
 =?utf-8?B?RStJMVZPM1k4T0FGR0Y5dDU4OTlNc3hOK2pWbVJRc0VzU1NxeUlKb09YL3lR?=
 =?utf-8?B?SHNZMU94dEszWGNqS09sTEgweDQ3TDBTbWRCZjM4Y0JMUWRRZHBENE0xZGhm?=
 =?utf-8?B?S2R5Wnp2TmtqQ25yUzJRbGpmM3FrNUM0eDIyY0hZY29idCs4eVBYNmxXUmhj?=
 =?utf-8?B?QnZXZEh2dTE3dnROQTNVbFFyY0VQOE9ZZU5qWUdNeVV1Um9MbUdtYmVxdmJv?=
 =?utf-8?B?NUFaL0xhNytvOHJ4YWlwMDFHdnpwK0xDTDl4RUFYaUVmNTBLUE5kWW5HaWE5?=
 =?utf-8?B?Tjh3MzArS0Q1aTZPbzF2b2dwUmRSaU1CUUNCYlA0REoySUp6Sm5OUHVKZ01G?=
 =?utf-8?B?eVhsWHRoeGhuaHBqVHJ6azBoVXI0QTBYZFBsNXhoeWJwQWlmTk5lbGMvdjFy?=
 =?utf-8?B?b3VTWnF1NmFiVzRvTGhpRUFhd0sreEZBZXRSVzk1dVZlV0VyVGkvaHVlT0NM?=
 =?utf-8?B?MWlyU2VRb1p3aEdzZWZiK1hrL2ozQnpEcnFaaCtOWU5MOEc4WUdGa3IrOHJV?=
 =?utf-8?B?TmxjOVkydHJsdTRRM2JQUnZsQkhjQm1KSGRqejV3ODhJS1BWNWF6NzVNUk42?=
 =?utf-8?B?SXFqQ0Z4K05WYmJuanFIZDA3MHZsQ2llZm50WTl4Uk5jOGN0QTJ2Z2FpbW1W?=
 =?utf-8?B?alFkUUtJUWFGcXZRRTVnakZaM0dJY0NEZjVjUkdQQW1hSjJqWXVuU05iZXg2?=
 =?utf-8?B?VTRlOU4xY29wc2tBcnI4SlVCajUrV0VpYTcrZlRqVTZrOWRtM0dMMS9LQjlT?=
 =?utf-8?B?eFl6L2hvL1lGdjBOMlVNT2dVZnNyMjVSYW1Ib0l1dHBMcUp0d3VIMHgveE9K?=
 =?utf-8?B?akZ2QmdScjlHRThOSGJYbHRDSjVTMmVSdGU1YlZodzVjZm1mVUdHQ0pMMENZ?=
 =?utf-8?B?ZzJNWnQyd01DUnN6aDJjaFpOMm5sUXFLUnZaZmwraUM4cGxzVVNkbTdBODlF?=
 =?utf-8?B?Q1JMMUxQL3QxOVJVRnN5endnQkZLTEdWK2lHazdIMldZKzJZa3NpUVpnK1JU?=
 =?utf-8?B?aHVGYm1weFBtYkt6RzFuMHh0NTlKVWxnVzAvbWNnbVNCR2VNSGxlMGpzRE1l?=
 =?utf-8?B?L21TYVFKaHpwUGFzWUVRYXg3dTRpdW1ydlhneXBZMnhPWldoamViNk1SVFFk?=
 =?utf-8?B?YmdjYWQ5dTZ1aWRDN2VZM1BqNWRDRGpQYW9uUTU3VzdTT3dzaGNrelIrdlJM?=
 =?utf-8?B?eGRKSmp5ZWlXOWMrNWRGa3V4Rmd0UHM0R3hoLzNaVTdzZGo0WUtlbzBlbE52?=
 =?utf-8?B?cVNtN1ZTWW0zYWtWUGpqODMxalB2c0xoVW0rYU1JSUhuZDRQS1BRa3U1QU5N?=
 =?utf-8?B?VW5CcGdhRStkclFWVERoV1BjMm40QktrZURXM1pETHBoMkxGWW5xNlVZQkg3?=
 =?utf-8?B?bmdxWDArOWxMSVJtV2hibmpFTUdIVnB0dmZlS1N2WlRuZ09aL3AzNlNqVU9n?=
 =?utf-8?B?Q2R3aUw3cVFPcC9BU3JwYi83OXJGa1hlSUNBeFdlTi92c0dJcUV1aDZFQjdF?=
 =?utf-8?B?cEoycHNiZVhybWdQeUQ5dEFwakw1cW5rMWg5aG80cE4rekZwejRJOWJEekdy?=
 =?utf-8?B?WSsrV3JpYXBuV0JDeTQxK2NacmpST01UUTdqajQzckllN28rODF0Mm91TWE0?=
 =?utf-8?B?ekxaRzB3ZFZHQWd1aHNHTWFaR2t4ZjNoOXJncllFRUQ5KzAzeitrc25Fb0NH?=
 =?utf-8?B?ZlBYUnFEbS8rNlRHNE5lbFNJSmtHV2ZIektSYk9HakdBOWRHOU4xcDVXV04v?=
 =?utf-8?B?YW0vREYrUVBJRVJNYXJaQkE1b0hMak1kZlE3V09IMmNJeXNrVjhoVjhJVk5X?=
 =?utf-8?Q?Fe6dgUtNYLkovJbYDkDXyKUoqurMgKfgqrQkh?=
X-Exchange-RoutingPolicyChecked:
	OkMB1PTAPzT2M/fAEYSFxP23c5bouhPKaxhLruJEztuZMx17b++YUh0qw/8316/gFbx/pHuj+I3DrZ1IHQPuDiNJvLNHWVBKvziuG/vBEdbQgLZ5hl0zEabhEoCpXt/fkfpD9x1Ec/AGkMc2UMc8BpE9Wac6rm2RcVyYrTQnWP+EfUdbcK1JB+XcZxtPv0ZDCyj+qxHtm3XxueYKw2SFHoon9KTZ1SMaejqMYPZ0txlx7qROm/oNbXDDw3DFpvCRzdkE0K6ks0Dfx0IePQ4tUP9RC/Pnla6kSnGyWJbcVlISaRGvQsZuQyLy+hxNgFBOFQ3/eZjBRvkvwYC2k7ipcg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bnb8UcgV2Z8/8j0Mu7uNqqlAMeTmehtfwmbFG+L/9xNq+Cv7NHuidCGgmhXFVn7sk4/jlc5Bp69KsgGR2MRFDGn3XpThYXx0lfkzH/vKv8g9gkpYaKGlB2Rg7udJbqwAAWTcCCLmBdnYF85f/A+iGG4MDjIDV2PyPPOFkTB1KznxsIfLCRwN8ZYo6BMhQ+z3gzLfr8snSqYpubEqXi8nzzkIR8kqdlt92YHpkTbkUGP5Mc4dIJN9huLMlDRWQubs+SDA1mldVOWQ68eBO3AXs7z3IkCiUSYJYgkQdsoskV2VrpxRj5ZeNYs5i/6cEFneCXUsceKbkOV2dYDYNRGfSwKSYyvlZRHnZ/oVE9outbu9h/RkmRWU6QmuOeMJbME3cx9fcs4znmE4Kkxq3QN2lgpCviK6GIO2DXLtzlzeZgNOXxD4P+LeAC0vbQnv6Qrf0ONbIT+se4MGj7FZTv0UFVLStx3vPNMYzOeWQQpPqlrEZNrGZNwTKOAwa5T3+n9NmbjOkAy78gXb0cfbhJvl2a+5P+p0OjwqEseqah9r5GepU8JDxZZI7GoaHIobvNNaxcuQOKflov1CmYLrq4uLszLCnL53LeMl+UGJhakU5xo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e0ab69-5d74-47f2-1a84-08df20cf0139
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:49:16.2855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rktxU92NaVMO6DqF31rrDcg5/EVx8dDk2DzGBNG8CO2q5vkWreP/XeOeY1FwctnmdYiUjLYUtpOaEaE01cXe84ssX25lUNXl/9fbEHaGEJzDf65XGmkRkphjdInpFxRA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB719201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020086
X-Proofpoint-GUID: Kvv0kTSLzx7qdiAYJe9PS-tPSFZLHJ4t
X-Authority-Analysis: v=2.4 cv=U/gHnuru c=1 sm=1 tr=0 ts=6ac026e1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=e5mUnYsNAAAA:8
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=ag1SF4gXAAAA:8
 a=kl965T370PQKU7kpyuUA:9 a=QEXdDO2ut3YA:10 a=Vxmtnl_E_bksehYqCbjh:22
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NiBTYWx0ZWRfX1pzUEHSffI2F
 TtxCtFESvYc12NBSrAfvY4lO+Hlr3QJ5Cx4qP4lzOLdaUDi6/cfssz6d9NOMD41+SO02uZJxf5/
 JWyYaSw+6JHsUlVcpwPHp7DbEapFJlxNuQGxKxjEQI2vwcsBAhGF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NiBTYWx0ZWRfX+EgIQfTtVf6f
 H2BP1NVju8cp+lLLtj9GYRBzUkSCNJGJHhE3dJANztnil+QmTg+lezOpPpOfb6cBR7GYOfLxBXf
 xMu5OI8lv8OViapkhpNLocOUXcSyr7mc36rCVS7PqxlCPCFd2IZc8keSfy2vrsOsY2UZPQdG62W
 ppLTfUyOytR9prDZ36mmPXmB3Y6L9PeeZW3V1p1ZoTw4IgDHglac9XGgNAApSq7rZ7kKA91OIWh
 aPoHQFOYa4bsIjBDAtBSSYfh4UsQAdIbgXBGUltwZaxextaw3NpDHZ8fqVVOyzAHF8sdKrs2Y2z
 HrlGctkcp6pPgCwCQEUS7MajgoUrez6qpMEgRvNIGUWkncQptnz/W7MXsBscZnSvGt4WOEU019Z
 fGAIehwVndnNbIE2phpSgTtY4PnSMg4rHFyNRX2K8lTy6+2X25bAAKdCaflcozQIMbMC3kvzzEz
 Y3jTwGYEPLhD6kRCiKVl86Wj0ia/Azj4gO4DP+RQ=
X-Proofpoint-ORIG-GUID: Kvv0kTSLzx7qdiAYJe9PS-tPSFZLHJ4t



On 30/09/26 8:57 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Guangshuo Li <lgs201920130244@gmail.com>
> 
> commit 6fbbf1e152f34ad3913e4a6476680aba672c5068 upstream.
> 
> adreno_gpu_init() calls pm_runtime_use_autosuspend(), but
> adreno_gpu_cleanup() does not call the matching
> pm_runtime_dont_use_autosuspend() during teardown.
> 
> If the autosuspend delay is set to a negative value while autosuspend
> is enabled, the runtime PM core increments usage_count to prevent
> runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> during teardown, this reference is not dropped and usage_count remains
> unbalanced.
> 
> The documentation for pm_runtime_use_autosuspend() also notes that it
> is important to undo it with pm_runtime_dont_use_autosuspend() at
> driver exit time, unless runtime PM was initially enabled with
> devm_pm_runtime_enable().
> 
> Add the missing pm_runtime_dont_use_autosuspend() call to
> adreno_gpu_cleanup().
> 
> This issue was found by manual code inspection.
> 
> Fixes: eeb754746b14 ("drm/msm/gpu: use pm-runtime")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Patchwork: https://patchwork.freedesktop.org/patch/745110/
> Link: https://lore.kernel.org/r/20260808131624.2854412-1-lgs201920130244@gmail.com
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/gpu/drm/msm/adreno/adreno_gpu.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> --- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
> +++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
> @@ -957,6 +957,8 @@ void adreno_gpu_cleanup(struct adreno_gp
>   	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
>   		release_firmware(adreno_gpu->fw[i]);
>   
> +	pm_runtime_dont_use_autosuspend(&gpu->pdev->dev);
> +

Hi Greg/Sasha,

An AI-assisted review flagged the Adreno autosuspend cleanup, and I
checked its initialization-error unwind in the final 5.15.y tree. The
added call matches upstream, but gpu->pdev is not guaranteed to be
initialized before this branch reaches cleanup.

Upstream establishes gpu->pdev early (6fbbf1e152f3,
drivers/gpu/drm/msm/adreno/adreno_gpu.c:1205):

     adreno_gpu->funcs = funcs;
     adreno_gpu->info = config->info;
     adreno_gpu->chip_id = config->chip_id;

     gpu->allow_relocs = config->info->family < ADRENO_6XX_GEN1;
     gpu->pdev = pdev;

5.15.y added teardown call (d7aa8488b4a2,
drivers/gpu/drm/msm/adreno/adreno_gpu.c:957):

     for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
         release_firmware(adreno_gpu->fw[i]);

     pm_runtime_dont_use_autosuspend(&gpu->pdev->dev);

     if (priv && pm_runtime_enabled(&priv->gpu_pdev->dev))
         pm_runtime_disable(&priv->gpu_pdev->dev);

msm_gpu_init() assigns gpu->pdev only after fallible register, IRQ and
clock setup. An earlier failure reaches adreno_gpu_cleanup() with
gpu->pdev still NULL, so the new PM call risks an OOPS with CONFIG_PM
enabled. Successful initialization is unaffected.

I think 5.15.y needs an adaptation of 16007768551d5b ("drm/msm/adreno: 
Assign msm_gpu->pdev earlier to avoid nullptrs"), assigning it in
adreno_gpu_init() before fallible setup and removing the late
assignment, thoughts?

thanks,
Harshit

>   	if (priv && pm_runtime_enabled(&priv->gpu_pdev->dev))
>   		pm_runtime_disable(&priv->gpu_pdev->dev);
>   
> 
> 
> 

