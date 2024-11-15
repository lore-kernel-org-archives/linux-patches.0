Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16BB1E25E4
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 16:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731686464; cv=fail; b=OP28Ns+F98AURHgbuec/mLKGcx7EEuB8vltYnUrC9pbCVmkmVviHBX1cUqaf0vgmMnng6Wo/Zq/lXm/wpPc7wWhmHeiSlJNI8zuRj6NMWe8LwTC77gRZZ9fg8D7LETMstpCLhSwXJZQqcp2Mv6spt3QYbjBnxnm4wPh3tKz6GD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731686464; c=relaxed/simple;
	bh=8Hyvym2+fhV7RmKjHi/KB4YJBE4V/7OzeHHfKibHTyQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k0/ruUo+bkXVewbDTARy35HWmmhT8Ruwt6iM88rtOnFRslzOweiYyebHxSfBkMwmIKrgbLRz74Tn6M3wejmu/kWJMrKF4prZwUE2tN2nhCMAkGqyjEsD3wgZRFLauDa8KVfovy904TS1rofBS5gyevs1AhFIBHSe+Kd3Dzv4MkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E/gSB6sM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VFFatENj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E/gSB6sM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VFFatENj"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFDCTTM005669;
	Fri, 15 Nov 2024 16:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6IesFpaNB8ChGzLTlqjgnkytsjuSMbgtje1vihe2Z8w=; b=
	E/gSB6sMc+fFiwygCbW7iB3Ox2leFwi6JkqrN2xShrFsVvjYeand86Ew818RWCXD
	EPHu/3nd278Oe0IXRuGG8jP9gRB3T7uxwrXMMBGgiWCQsjfGQhQziUEf/+ToYS7j
	79unX9VsDExQplptKHcF81UaapKMbgT3D4QNq7AHiealpULmHMzcwNeHecscvZO+
	PYZpkXTq1fi+tA0CiR2b8sCQhK3hbnW25fWSz5eME6vyzSkkqFAUOpKbmEqIk/z1
	PyJ4xvx+f38x2CXwYfkGU6qFrX7KmbQimVzG2eNmlgrRKbMxDT/zQosXx/ke5dFv
	ac03onXGug+xGas9WUYsjA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbksbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 16:00:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFFb3FF036146;
	Fri, 15 Nov 2024 16:00:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6cbxrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 16:00:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DYYGJz2OtAK49lELHd+64Ta9zY4Nn6KgS+jJMJkbiuPg+5UnCaJ3SkAH+4PeSfHds+vQxf1nSOsbsU8zvZ1kjfLQkA5pwUOAAKSshOAabMekfkykbhU4jf38cr0PXK7cL+E1ZsAnMRyY3+nNnNBVWUYtCY39KfvSRsxbVNDGPwMRgOM6xhhPFAIaUCee3T93BOCWtijPUDIkiNfU0Uf17XmJGS0ZTBjZTo+0ZSr/oqGPl4VB25OnIdjiz6UKgJPs+sJvoKq2VIls1OOlSprxJmnkrzBNBV9dqCPMM/QUhmXq4gpyJi8EpmjUfkQVaVf8Q+zyJQakezYykO0pfxHN4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IesFpaNB8ChGzLTlqjgnkytsjuSMbgtje1vihe2Z8w=;
 b=jaBAvH0TROmpWXpkhUXw40uaXxbpx+R1W87UPto1lxSexV/GulS0sXgLFdhPvzfhZ0bh/E4EuKe0bnBqF67cjJEH0vdo10ths1FoAEckVe3uanoNX3bxY/uUXDG/6UL5IRUoXzV4HBE22hFAzwdMOYhk6t5Z8WqIX5A84b2TYHwjXnIOEaWiWw3JcgJEuU3CQymsEQN9cwSwytfYebFAoKQDVpucUvOKW1ZgA2f4TfgSoXInBBUjhN/1F/wj4vrVZ/lTi25ZoaXt05cdrpmQDdRKJdUn7RerBQuxIeEGKnrzjM6w8xRxVdYRn9aObvqw7cH6JsesUBfJkQSU5RuDTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IesFpaNB8ChGzLTlqjgnkytsjuSMbgtje1vihe2Z8w=;
 b=VFFatENjrJFvVky1oDeUJx/G2tMBAIIDcoeS+qmkAH6WnsLaQfJBR1cWQXtrDGuaTTzYF7I/T3KVmAn9PdR/WfMIVCbZLVV8ZsB4oKG5cmFV32u0ao3tdBAWYMgEOK06XivzMkQJw4cfnhLvNBE/oY2+1IrmSbFWtGD4a9PpOQ8=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by DS7PR10MB7249.namprd10.prod.outlook.com (2603:10b6:8:e6::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.18; Fri, 15 Nov 2024 16:00:47 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 16:00:47 +0000
Message-ID: <18c85b93-2fe3-4db6-a8f7-508071d80f42@oracle.com>
Date: Fri, 15 Nov 2024 21:30:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/22] 5.15.173-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241115063721.172791419@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::12) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|DS7PR10MB7249:EE_
X-MS-Office365-Filtering-Correlation-Id: a1f5a5dc-a244-4e58-1ba8-08dd058eaad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDg5cUZFajFReE1DMmZETmYvK3hHWEMwdVpVOVltYjJsSGo2QWdxTGZGeGxr?=
 =?utf-8?B?RWtFK2grZytXZWZNcWYyM2c1ZkdoSWIyRFdSbDVxU0I1QURyMUFUY2xUM2Yv?=
 =?utf-8?B?ZlhYTzFRdUdtMHA1OVhzejArNHRxb2VqZEFiUWo4amVMYVV2VVh4bXJZSTda?=
 =?utf-8?B?QklYRmhIeWZWNHlGQ3R0YmJFWHJmQmFCbk9XOGUvWWJwTUNhSXAyOEpvOFhI?=
 =?utf-8?B?bkt4VkVQMU9YdWxBbzFkNUx1N1h6OUdWWFZmaVl2L0syOHZ2cmhIcjFJcHpH?=
 =?utf-8?B?TksxaXdhTGYwZy8waDMwZlJ1SkZuUzgxZWl5SC9NOWdtOXhTWncxc011S1B0?=
 =?utf-8?B?QThNcXlaMCt3M3MrUStHdFg3TDcrSDU2dHBvYk1MY1k3a2pHejlRL1J4S3Bi?=
 =?utf-8?B?OEJCbkNwRE84TSt3Yng0dmw3NTh2SUhvU3NZV3ZMSW5UU2xqOCtqN2FTMW9C?=
 =?utf-8?B?eXlxS2sxV21yRUtuaEY4SjFvOVVKMXk4ZExGK2cvZ2ZWNDVwckx0S2lHc2s0?=
 =?utf-8?B?YkUzdnpDMHg1bFRrc3JneVJzZzBjMHlVQi9qemgyZ0kzaEVNQWlFbkdsOEtT?=
 =?utf-8?B?M3Z6eHp4aFcwNk4yNENuV0crcTVlZTQ0SGYzNXJzR2dUVWlicFRTa25UMEtN?=
 =?utf-8?B?UUtBTXdmV2QyY3V6RVBpZzZTZUdqTUU0a1JiMEpBeXN1YnhyMEZSVERVTHli?=
 =?utf-8?B?MW9BOVV2aEovMVIrd3RTdG9aNmlrVnIwOFZoRm5ORDFZTUJJQm4rejIveVFD?=
 =?utf-8?B?ajB4ZnB5QzZtMFlRSjFuZk8zdWZSZ2gzU3g0MWZIZE0vbEs2a3laRGdteG1z?=
 =?utf-8?B?QjFQV005dmV0YVJpcjJyNlpFb2YrUWFBcWlIQndPSjRSMUlHZ284U2dsNG1o?=
 =?utf-8?B?K1VwZDVocG8vZjd5cllXbXhBQnpvcVBJR3E2V0l2RUZ5QlpsbVVDNVc5OE1m?=
 =?utf-8?B?angvUkZwb2ZBOXFnSTVmeHA2RVVjUm9LUFAwanFyR3Q2alIvN2l0bEFLT2xM?=
 =?utf-8?B?WjVtNzh2a2ovaGNjZUdzelZud04yd2cxbFNIZjlFWlZ5U3ZsSEV1dGpEOGxV?=
 =?utf-8?B?RFdBaFdKNjFWT3RCYWRJKzNGVVp5TFB3SEhFaVpZS0VzR2gwM3hCdnZYNVc0?=
 =?utf-8?B?QWU0ZkdFVzFITzJRaW4rdmpjaFNqa2xYZFE1NU14TTlTa3grblRGV2VGN3Nw?=
 =?utf-8?B?LzM1Z1ZzZ2tNSVZKRkp2M2wrWlFMVUF3MjN2a1JIcExjVzQ1WmtzOUJwalRu?=
 =?utf-8?B?V0xvWnBYNEk5OVJBejBhU20rK29Nc3FORGVyOXg2enQvbkdveW1LZXU0MWVw?=
 =?utf-8?B?L09zY09jL1BxVGlUazNRNTUwUjg2bDJabFNDaHZFaCtwdXpBK1RkWFBDOTBn?=
 =?utf-8?B?K2lrSHdHam1rYVBzUFpTNHF1aGlxaTlOSUpXYTY4QmdrUXlIS2p1VUZTTkZv?=
 =?utf-8?B?MklrZnpnQ0VSalNzbitieGtvdnRkci81ZFMranhQTDRQaFR5T2lhSTFvWGd2?=
 =?utf-8?B?TUxHRTVFT2grbkNuVThXZ0dvQyszQWZRb0tIRUM0NmhSdnVSWTM5YitJZHdy?=
 =?utf-8?B?NHptZTRjRm5qMUxPYWZMYjBBZU5lQi9OV3l5MXpNTTNQNEFaU2dqUGhKS0RB?=
 =?utf-8?B?RXVma1BhdXFJeU1oVlJGUXJhWlFGWUhTVmtRa2wxTUx3enpIZVY0YmlyTW1k?=
 =?utf-8?B?cmtkMHpLaStyYnYvODhmdjFBOGp3Qk5FdjNMKzE3cVhpSlF1MHk5WjkxZlQ5?=
 =?utf-8?Q?eVM4rvlP7Jwx1dH61DVYxvaz/kgcnnAQFtc0eGv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXIydDJDeWVxdkk5WFkwdHRLdzBJRzlPNnI4ejFDQS9IYlBvQXpjdExhY0FN?=
 =?utf-8?B?Y0xlaXF3TlhKcUlrYjdIMHRwMnh3UmVEeEVGMENqczNJdUF4NFgvYW9IWTlJ?=
 =?utf-8?B?MnBJaTlHajVadHRtdFVUM3pVSWRUU3UwZ2swZTQ0VGhIV3B4ZHZLUlNBTUlr?=
 =?utf-8?B?dXA3azB2YXI1dGd6VFFXZHNnc0wrV0RIZm05L3dwME5ZWUVOWFNWbWhVQUJJ?=
 =?utf-8?B?Q0NkVnJSdTQwRmQ4RmNOdWU4dnd5SjlwV1daRmpMdUxMTTV4OXFBaS8zbHU4?=
 =?utf-8?B?cDV6NTFYaFFQYWVUQkpJVzFoNWtjdlR4cWZnT3dFNEV2ZGc2QzRwOGJOVUlx?=
 =?utf-8?B?VE5lSDdtMVI4dUQzeFd4OW1lMWtCZS93bWE3SllsMERzTnB6NEhTKy9GV2JC?=
 =?utf-8?B?L09nYTRNZHFqNE1xNG1jTmJvRG9wRHg2Ry9DR0dJMnhIRFNlT3dnMjBhdXZT?=
 =?utf-8?B?R1dVTE9YVm1qTUVUeUxQN2NKbkpCdmVwVm9QS2I0UGJsWUExVW9BMU0xbmpT?=
 =?utf-8?B?V1Mwcm9aeWxVaTZHS2pTOUt3R3lVdDZpdEgwTUxvbFRuTDF1TXJWa1MvN016?=
 =?utf-8?B?MkhlaEc5WnNlK0pUY1R0azZvcWhKTUkyMndWOEdERnRzekx0QTlvM2lzRUNP?=
 =?utf-8?B?T2Jvd2UzSHQ1dmJKb3R5anQxZEx5ZFRRcTZXZVBqQlBXM091N2FtNGc1OFlX?=
 =?utf-8?B?MUFOZlprbTRwOWtnMGNTMFJ4WlBIV0JoZkw5U0xSVDBFYXZHc3k2S0d4eXRI?=
 =?utf-8?B?ci9IbUFCVFhaL1BSZ3o5cFRjT1MxU3Z3MTVDV2ZlcEMzM1BaK1NaOUVVUTR5?=
 =?utf-8?B?M0YxUko1bGNWS0RjdXNXalk5VE83T3hvYjQwZnBuSE1ySE1EZkxwakp5cmRs?=
 =?utf-8?B?SEtMNVpRVnNIZXV1MWd6bFhBM1lLTFVYZU1CbFlVa3hZMkltQjdVVzVzcmFJ?=
 =?utf-8?B?Z0JnU2Nqdi82emdBMkxzSDFYTXpNdUJndVJqSVA2N0JKUGdPc2Z2dXZzU3Nw?=
 =?utf-8?B?RWMrclFpaVdiSFI1QXBBUm5hZUZVZDR4ekVYeGYzZERwMnRvMzlpU2hGZGYy?=
 =?utf-8?B?MWJoVEZvaEltV05Idk1UUkZOdER3UFJoN3FlTngwQUhGUCtKQkJpcFcxMEFz?=
 =?utf-8?B?akZzODBCYUhOZElNcTZmTGVxVGhKVzk4ZmN3bEtCa1g5QW5wNHVDWjU2UkV5?=
 =?utf-8?B?T0kxSFFHWmtuQzh0aktYZEZxSXZsbStjdng3YnBLSFFUaFd0UzQyN0JncGZS?=
 =?utf-8?B?akZKNWlyZDZ3RXN1S21NV0VCYnBuQTdlakp0NkszQjBGSHpVcURWUGhGUVhM?=
 =?utf-8?B?WkxaeTRNdWwrY3R5aG0xYzdPWHFsU0ViSytTUHVWVUxLeXhlZUFVMkVBcWxs?=
 =?utf-8?B?c2pKQjFRQzJRY2ZxcXpzeXNBY3JvRjFPUHdXNjVabzl3WkVpV1RLeEN0QVZ3?=
 =?utf-8?B?V3cxWlUremdXVTZURmVuQ3UvUGI5aGhsSHVtT1hEUnZkdEFmQkhvVTZOejFU?=
 =?utf-8?B?TC9YTnp6K0JuMEprMFdKZkxDR3dTc3llbFlYL1M2QSs2UTlObnNPdmdRZkZm?=
 =?utf-8?B?bWxPY2tNa1laenIxaHd5citEL21IRXdvYXBDNUtzeXpyUyszV0V0QTBSRVBq?=
 =?utf-8?B?d3YvVHNhdlBBV3R4ZXFTand6VkpuUFRGaWMxalRNZEVpSTRTUzY3MEIxWVVF?=
 =?utf-8?B?TjlYN1hLaktpVjNCVEJ4SVd0SUwvMWlRbEVQeXhlVjB3NFJwQTIrNXUvdFhn?=
 =?utf-8?B?UWZDTkhrb3lRZXVqb2xYcWZ2eVFSQXhSbGpCYjBIcUpBRWhUNGJncjNpOE83?=
 =?utf-8?B?U2d2SFVTU1hoOEs0UFlicmRkZUtvSkxWcUF4bnBxUmlSYjdIMnVLR0M1MWUv?=
 =?utf-8?B?cGNCeXdWMXRDMElUUGN6dkkzT3NCZzVHNFRzQTcwU0N4QVlKZXlWcW5HUHN1?=
 =?utf-8?B?ZFQyK0g2QkFzVXh0U2lyaGJEQ1pUc1U3dnFscXJlZjYxcWxZWnM5ZnJudkJx?=
 =?utf-8?B?dUx1b3NiMVNza2picDA2dXNtbGE3WUljd1F3TnFaMHI0ci9wZlhLZXpTeWp1?=
 =?utf-8?B?eWw3Mnh6ZVFYNHgzZCt5MWRSeDVmTUVMK2Z1eEZWRUR3ZHc0cW1GTi80MTB6?=
 =?utf-8?B?ZG5ycGFNeHAxTVRqVGFaZGtYaUxSaklQb21oZ3NhL3BsSnRnd0tVazVXSXhr?=
 =?utf-8?Q?wHB0YKo3lmFMYQ9PJElLIz8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3op7cLdD1XXW6HPwMuoTvnkpXAXkdu2YKo4CpYVMm/84SJFYMVNCMVRJ7By/ToWyrX6HZoZup2XAkPfjFG2HyzAUkPmgldc1y5k5n/jYvPY2oQp1HXiez4pQNY5aAWDiZzHMv6IuWI7dO/KhtCnXNhArTkI58619dBA2jwHgNbpyMwaq+cj/zgDitlb8WSrZloJBgq/xQMNYK86UphDIXWiZcNMxTk9ABW9q0xkAxnSawbJcBQge/sWTR5b3fgAPQ/OLC5rfBEikuSbv5+BEtu86ealQ2I2v+t+vEuc11lT0mGACDKph0ajPeBtZ61AKRb73MDNIc/MS0E69MXGX28vVow6YvbMvhn4cCX1oryU1cgVPdkYHQv7BKrhXwzEqwsNVOpQpRsBCr2smhx0ZXUZhN3eSzJDCg26N9hv764DM4Si81XnCLRpwqwgpDhtPkzxlqZrwl4toDJ7lu/UEJMkTHjtSrqCYWLnkxpP8RM+61yLHrYgANGhMBJ0NJf+sQQuALbUDvQwjWkTZF1jaT2gUdb94duuyWCd6ZzKyNq5lK7R4MwlRk8t09cv6w8xiKXvpkmqTkwVoR+kvzbmky6zZOv4u8dSoPE5hMFZZH6E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f5a5dc-a244-4e58-1ba8-08dd058eaad1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 16:00:46.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCTMlRgYCiiebv8OUS5bHqHArSfWF9SkhZ7Ap09VpJ3stIy72CHVqXCBQg6uNIdxxGDT/L9VIn3xOVYMFl3nOZjVuMN6Ji5fetdBLlRJYPDD5TfjkR0MkhKgA3PawaKX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-15_01,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411150134
X-Proofpoint-GUID: Dfs-OJeBhMl0sRsF3i368344ya_unpkX
X-Proofpoint-ORIG-GUID: Dfs-OJeBhMl0sRsF3i368344ya_unpkX

On 15/11/24 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.173 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
