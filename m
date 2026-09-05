Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C99F242910
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 17:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788627866; cv=fail; b=kurGvaAhfOzzvqHkRs41SFBNHAA57wdpGNd8UFeswo5MDR2JRtHecVgkvR031wxn5BL7bTWq4IvWEHer3IlQQxpASiaF02amxWboyc3B3zCAr983NfvhgJuYymGYtQDz0/xrUswY5x5PVIrs57TQIqVawZtpRLk9wO5ba/HL8gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788627866; c=relaxed/simple;
	bh=dmwEcAiNmnu7xX5agu5pWL2Lc2xqySSGXFjnxzZBfCo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H1y2XO40FLDNMg+n95whA40MM7OUyg1rI771XAspcTYW9bEP3h68dtrN9SCtJTYsn46AnI8X3Gl1co7t5peXjk7s6bR24wcg5CendsXA8Nf59oGr/34UoDDC1WzAlsGhN9rl0SDGnOILIxNN6k4KfGDo2UdyfL/SozEq1ZURG20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Eo79XJjZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B6br8Pit; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Eo79XJjZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B6br8Pit"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685GFRYp1322102;
	Sat, 5 Sep 2026 17:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=65m0eLz4GP/3C4BdB1OaOE4NqMbEvLKtTR1S3xO8/Nk=; b=
	Eo79XJjZeLJgxvnfkKzYNyn2j32z59PBWHDuiVc/PusO1AJeLbn0ohq/N5sqSKpP
	Zah1RNbBVQ9b9gIRaBRVpx3rZ77ju9vNLqK1vMAy00YHjo7ZNNtDA+bfD/xU/Joe
	JPLsfNTl5gqGa6LVFNuuNPE2l3s5KqY1/XgqcfsVnDWHGovFKkW9et9sui4pWrUX
	nJqa6ho5UR1dAVh5JDFg8bUPKXQvNC31Fip2x0V1kMY59vNQecady5pG1f/x02i4
	fyGWk8dcaCR3S3xB7jc8s3DIXf5paoqWnKOhC7CRiPY2OrmTtkB6V3eAh8tqYm7m
	Z7scGMnsUscHvfY3RbWgqg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbg1rbm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Sep 2026 17:04:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 685H03op035218;
	Sat, 5 Sep 2026 17:04:12 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gg9hbmv6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 05 Sep 2026 17:04:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fVs2zlVpxrhNDi4VwFFY8UmBhrxuMK+wrYNdKQkO+JhO2+vGuvyItYwLg4F3ix3griO6QZo+5VqRtfb+MofqFMc3IYFf8GZ0BNAK65CIrOZj1CXy0Y6VKocfe2PHaObWpN1cr9KgcxlPBj1MFzBqP/10tk+ldTuFEAmW+lmhm9cUToGrqZCa8p2EXJn68FagYbJDNNgSyvdB4TUsVZpKY0geZIAaTvhSoBkUaCy+9UgkJ0XqqPvR/8w2oF/PUmssL/zw39zitJ7MJkgvLWjqiWW7jqQQBHzLWiXoYMNsUfwX4iGGg2eByb6fm89DwTRfuADph7fTfxmqjGwg5NfnCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65m0eLz4GP/3C4BdB1OaOE4NqMbEvLKtTR1S3xO8/Nk=;
 b=eIko6gX/mKEEZkPiAmg45tSOxUXcyeQ8pIspOyyP9i+e7J3l7YDAn5hIxHktOO0q3ryWwl63GmiPlcpEW4C+iHTca1+zzzz6pQt8mXa7Q+u/VGngh9wRIKxq7PBaoSF//pooqFQL2T+VjQwen8/0CZmyvxozULSYusrv/XUvS0N34Jt6XpDTa4+cIqqz3TUjIJZgPeRMAmmWkoBrLfgsL47CNjcoEsMEk4SK34uMFROOBmGfhJefm4chFPUlUFW4ihMEoo3ZBJLphBFNrD7uyTgsmulVd0eeGrNCXlrOrY8sC/rq6YbKfzJnFUh6B0NBR4K6zhhWNV4pDcjRHKDp4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65m0eLz4GP/3C4BdB1OaOE4NqMbEvLKtTR1S3xO8/Nk=;
 b=B6br8Pity6Iu0Vpzoxiy01wbxNJue94FT01s4VgtMcaN6WzKQpPdTOTupR3zOVVQu6t8c/8pG5tgdH4ZCgEyJ0a7w86MiT8lZHByhws7baH/ew1c9K5tKGhqxP076LOLW/j+5+kUrmuxxJxhzTQ1MJfGATeX+7eMhkO8dpZtWdk=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by BY5PR10MB4355.namprd10.prod.outlook.com (2603:10b6:a03:20a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Sat, 5 Sep
 2026 17:04:08 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 17:04:08 +0000
Message-ID: <35c4c0cd-3bfb-46d7-8a05-a91820001915@oracle.com>
Date: Sat, 5 Sep 2026 22:34:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 161/403] Bluetooth: btusb: Add ASUS USB-BT540 for
 Realtek 8761CU
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Christoph Zwerschke <cito@online.de>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045738.512064718@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260904045738.512064718@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0345.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::6) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|BY5PR10MB4355:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c67d82-4a1a-4d5f-be30-08df0b6fb2ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|22082099003|18002099003|10067099003|5023799004|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	LHmEH0alVyHOdsvim2b6NZs/g0cbCArBSV7LhC9mEfmSE+7KxEF9Uvr9iKsKmFvBaq7phHNd7lAJ5jnsyToeaKQyLSI+fiYHP9zUelvIq1xMjyOx/j/YZnTh/5Ubqnf1wVYaenlNjDEbVjiOtrg929EnLf9nR4oq+0X0ftyjGifzIRbp545j7L3Qu2UXncw5BTJIPHDLSgLOKn5GOmoRX2dlSKmW0PcWGREm4HI/6uK9J4ddnJiVzB44m6CKw3fxuCTZW6lq3J3WhCoC0Q5wbvYhbdZH7j5hNJhxLxGGgp8YmHUHdrLlKDs9az5BTjdExKMNHCq3KwcpId/t8E4vkvgVjjiq6OnAqsVJSRGhvK6p3xyL1gpJQdwGPpcBorIfLyT8obVEy68UUKyA+yPpZOVBGyGg6RETi3xLHYNSC4/K2CiGWejrRX2E6UT+9Hh02tmoGsyvt6Gsc3SyLOYMwoY1AhAJ7dFd43DlN1uyvoZ+/9Q5CpK+T3hXJl4mPAIt/JzzlT9PpGE9bzKnr6FnGFwlCxw+JWhxAYWC6LfM1L2P8OhY8ZV/P01MpfUrJ8dd181wM0Ib8GkK7thsxFueUned4M1g3PHFpQdFWPf/48pRF/7sFFQOi9alKP8B4ZAyldL71ZJ3tTOm4X9OuaRhPUtON6TPis3blmHjqzdp45c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(22082099003)(18002099003)(10067099003)(5023799004)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHdGMTlhNU9vRlI4Wkt6ajE0VWx3bTh5Y0JEQ2NXVERRZ0VJWlRDRnYxY0tG?=
 =?utf-8?B?Z2dWdW1mRnR2Y2NqVUh4bFZUNlhGNlNmbURPMzhrNTdobGlXWWVOM0NPM1Fz?=
 =?utf-8?B?bWVhbHZkSEREcW0rd1hNMEI3czNTNTJDS0Vnd3JuTlZXZmdhTzk4dDZJMDhU?=
 =?utf-8?B?RERHMzlFWWphRGRnYUZDMHp1dVZZb3JnQnk0Y2lsUk04ZStrdGFGSzFzUnZM?=
 =?utf-8?B?NWxXVFZYT1F3U0JuVHNJZi9jNkFKbytvQnBZRlRUK1BFam41czQ5MHhqeERG?=
 =?utf-8?B?RWJNYy9MQ2lkajdFcnJjUWVTaGNUenRxTkdyVmZhS3A0aGtLT1hIN1hzUUc0?=
 =?utf-8?B?by9qNjk4eVlNQXJqWktSRXNHRUpBME9MQWFMUmtnMHVTS2hWVDk4TTlLSFJx?=
 =?utf-8?B?QWw3ZWdTKzJ1aDlpK3JCT2MzWXBWdVgyWmdPMGNSS1hmSTdlaG1STjlkZ0Jj?=
 =?utf-8?B?NlhuTnZlemdHd3d3dCthYUt2bmJndWEwMlV5MjdHRnFCeTNsbkNMMVUzeXRF?=
 =?utf-8?B?QXNMb3kyajBWZnBVaGRUTWlVWXhyOXUwV1FoaHBjUXJjeVd5Q1JjYzkrMlFh?=
 =?utf-8?B?cGJMTXhsYjdRUmdKb1ZMWkdEcDVqMDhReXhHSEs4dVhVcGRrUC9DRzBJOGNK?=
 =?utf-8?B?UmxHVW1tSkNhenFMODdYVjI0QlI1OExVVmZ1Y3ZML2dpUU5xcnFLQ0NCWEhB?=
 =?utf-8?B?NXpCeDVpU0RUL2RrVGorSjZOck5IZ25Jb3VWbEVCWEdONTV3TzRad2JwVlhl?=
 =?utf-8?B?Z25sZlRKRFVpem1LaTNkVjQ3TnEvMkRSR003bGdLNnZVL1ZiTmoyWW05emFo?=
 =?utf-8?B?VnNJdk1BMjVnamZJMnZhTkdxVHZUdWRKc0tDa09hQnlYNUwxcEY2Ri9PenFp?=
 =?utf-8?B?eDBVdWw0ejl6cjI0d2JoaUZkMmFvMDh2U3RSbDg0R20xRytUYi9lWEo5Uksr?=
 =?utf-8?B?SHRmSWoycW15bU5uWm5OTjhUMVVwL1V3bjdqcWNZdTJTTGhBUVRsK1JRTHRJ?=
 =?utf-8?B?aGd0dXR3NHlYajg3T3lPVzlyS2EwdWdrb0xSbHY2SkNQVnNLekRLSWZ5VHFN?=
 =?utf-8?B?b2pYNmdtZmJiUjdIbHYwZ3lHUVdFY2N3ZW9Db1pLVEVQWDRSMzduRDU1WFI1?=
 =?utf-8?B?Z3k2R0wxY25weDhsdzFYTmhlVytZUjZXVmNtSjBodW1CR2RHaWlOb25DOXo3?=
 =?utf-8?B?TjBLMlBKRUhETG5DU0x4QTM1Nk44V1JBeWU0NDNBNlZIOFZDdWhIOFFRZUVo?=
 =?utf-8?B?U1hqdkJFYkdkRkR5U2ZISVBZL0w0cGhvQzRnaHhkOVc1SHA4ejBZTW9vdURp?=
 =?utf-8?B?L1VxOHE0eGM0SG1GaTZVQTd5d0pud2ZabDM5WTJQUU1xZGFwRlFSbTd0dEdq?=
 =?utf-8?B?N2gzajIreFBqamYvQjFtTVBabmlsOFRDMXdjWEpOUzl6NGZxRExLSFpjQkx6?=
 =?utf-8?B?VEViS2wzVnhYL2F4eWNqaTQyYnRpcVdGNFV6cWxzUzhIdFpFRFcwbGZhUlc4?=
 =?utf-8?B?QWJaTVMydHZSc01qQ2dXeUgveHlTR2w4SDRpVlA4Snk4UGVkS0lwLy9qZmhi?=
 =?utf-8?B?bjJNeGp1QnhQSFhRWFNjYWVoUEtZd0ZqQXBkd2FBQUtCT2pLTGN2azNFS0N1?=
 =?utf-8?B?WUt3Sm5TK2p0UHdYVTFkRThFamxUSFNlUmdhQlc4U0tVRnlBWk9hNGV5Tkx5?=
 =?utf-8?B?NjZiWDFqNnNnTTVnL285cys2QTFYZmErRlRiWGhTY05DTjBFMmF3c1lXRlJB?=
 =?utf-8?B?WFk2SU5WTmlsMmNDeGlaYXJaTDdacHEvaDMyUFJ6cFFiU0plYTN2S2pvREVJ?=
 =?utf-8?B?WXJWY1BzTG1vdnQ2c1lwTXBYVExnN2VvbkFicjZNeHdQVDllYVRIZ0VJVXM5?=
 =?utf-8?B?MzVMdVQrSklwMFVJanJnbS9lZWp1d01SNkxDUUpKUGxpWktvdjVxeW43OWVx?=
 =?utf-8?B?VnYyc0M5Ri94WGdjWTZRWFZWM2lYU2VNRlNweXRtSjFmcDVmR3lHVC9PcE9R?=
 =?utf-8?B?b29iRkRZS2dDWlFJbXdKRmN0Wmc2ZnZldDlndG1DVVBRcXNQdnRIKys5ZE5u?=
 =?utf-8?B?K2hMa0w0MWF3eVhYMWRQV1dKaE5DUndZKzhoZER1TmFYL0JpRk5pWmtQRjF0?=
 =?utf-8?B?aDQ1OGpEc3pLQkxLbXl0VUttUmpNNmdvL0VvMjIwclFzRzhFdllrRWpuR3Np?=
 =?utf-8?B?dlhVclB5R0dVS2k2Y21VTlV0UXZCMzNVU1M5T0UvUlNnTDBUUEoxNUJ1VkUy?=
 =?utf-8?B?eXl5ZXVEWTNxdkZiMS9wWlp0ajRMcHhKMGFJQ2RMSHhRY2NCSUlkWVVmSlFP?=
 =?utf-8?B?RGhFdmZYQkt5eFNOVlBrbThsRlVsSk5HVHJQQXlXSS94RDBLWW45TkpZM1g1?=
 =?utf-8?Q?57r9iinvqztTcyPCBY/OmvokJc7k8U5BcaCJh?=
X-Exchange-RoutingPolicyChecked:
	oQP3yIF7m95U6l6/FggIGUvT8XE6c1NQMlWymGrokjS3U06TNR7ncNG3nIcQ/On4iBFNx/4K0ceJx9u3AdlZRIrRpobg/NQLOs8rEswB5JrEoGB/D4DvLdlpP+aKVmKJUwMHEikQbMG9DdEVsLRYZoydzdvxN14uDBmEY7Bg368YJVawHE2MxkJacRLCkVJkaRDz3bQKx14VW3qh14aIDW/8ZRu2zbhq69yR3jzS+jaLVOcr5k93TeN8+0oYow3IlVA3Ll4cqXizUlHmMOSVUJEP5nhzjJ9QaAvspoOhwWqtaMbMvOJCCBWJbhhi4jFtyY+f15KMf0VV5jNQZqY19w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oQnNgsItKPqz0vuD6ro5Kctmn8fTZm1ehXLwAsCnmxviwgmLQW5R5eHFywL9Ani1G8ZpRQVvDsZzbkgedVGaO7c4UtTQp7fpNSYbI4uYyD7cNFbocqf7F//rD/gLg+AT9Gi0yBv+Du6pcJHYYeV81Mo9WvOYRNNa/Amx8itpC4l5Qi1FJOdJBV0AWoB0k5Abtyf5C8XwZM3D+IbE1ZKEEzKqrF2veYTwJFSU2lpUuAMsITEj85PSY9cy2ttvp1sKH8mH4tiP537BX45QAaOfzBMBSiyHqsEeWzVs8Ff+YmJuwtox9kMZMIN0n5OLkIE+ogOzifh7AHudOwOymFtYazAiSMz6kPhMEmJ5in9+HRnlAEFEBR0rnpC/i7BnB8E+ufKW4ZEFBXhacYntAyuZT4yt6ptIqLPIWBWL9pvs1W8sFznqLFHgDlnauRvxU35rcJR96dFDyVjeN4iS5j4UI9q2SMPyFwlb+eCaGHKHL8s0WuMy+tgICYhhh7V3uc0CWZVOqywf+WIOKLxYOF4f/XDaxYg9rGVwg3aG8oEBZ1zD24pYN00IiKUrIpQ30Tegk0cAlT91WGvPo6nXbuo/xgm/szSZK/+GhtwhqHeq5Uk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c67d82-4a1a-4d5f-be30-08df0b6fb2ea
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 17:04:08.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qylHD4/uVqBGoI7vwpbH07O9/BYWWMiZzsICnu8EvjJxV0h7TVFLmi0dfHxjAw5j7V37hoHi6vqa4pEqXR+TY5g/ED3Y9B1Is3avbgU4os1SsaBUP4OwfLxa+0NyDkR6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4355
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609050189
X-Authority-Analysis: v=2.4 cv=VpYTxe2n c=1 sm=1 tr=0 ts=6a9c4b8d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=ag1SF4gXAAAA:8 a=89Iz_aZFqp2Z0jSRZjwA:9 a=QEXdDO2ut3YA:10
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: N6ty2dpP6aEPAFB806iN97Ad3UIEBb9A
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDE4OSBTYWx0ZWRfX2se4HR+rcHsw
 LoB5QsAq9H2k8GtIzn8eWy6XJi4Xiyo6DBv/EVKF7c7V2C9jNfHtGELHpWZESuZ4N04y75noPlS
 r/Wz6Ni9DJPwu6mUzF/hXM+A7mpRbkBa5RfizhladJm4IRaFY3rn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDE4OSBTYWx0ZWRfX6mIjDNMqZDgE
 oXbCcJIOAyYtShW7jqj4z4nKwsTAiBbnJO8jaqnbWIUImTleS4MywdNa4G9gwi/giOihpReGKRx
 3JYDg0frDHZFXtlsfv5KBbGypYyPhzmAbVscxc6Jaen1Zxie9WX8NLSFHp5IvE5/JjJNGcQZuwz
 bPLsio2w6Yu2rtnyX2hlXaAq7pw+LthO1GSySKRXBBhK+NqK36yjljCAraD+0pzHhIxGp2+O0cS
 Sj0zSWjiXtcxztKWIf3MEbtUpdmqev2lAlabDpI11XHHpynYzSiHb5DhQAvlY7By8iCl3yhBXTD
 URKkQ1pq9jOJYvbnSUT+mGv6SV27ve1yRvz7FS5XMGSHxiuX5LDEhgfHGoj+TzaBCbbzCiZ+oMt
 7mPBvKgDpMNN2Ul4v+c1oVR1JPoahVAWL80w+q3cu/fyZ+IJ836UmL2i3at9DgZqgc3teNUN5Fo
 l7m7Skxv8SpRLsjZjag==
X-Proofpoint-GUID: N6ty2dpP6aEPAFB806iN97Ad3UIEBb9A

Hi Greg/Sasha,

On 04/09/26 10:29 am, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Christoph Zwerschke <cito@online.de>
> 
> commit 980084de4d9b25193398d89a1c0430ba3501b683 upstream.
> 
> Add the vendor/product ID (0x0b05, 0x1bef) to the usb_device_id table for
> the Realtek RTL8761CU-based ASUS USB-BT540 adapter. It binds via the
> generic Bluetooth class today, so BTUSB_REALTEK is never set and the
> rtl8761cu firmware is not loaded, leaving the controller non-functional.
> With the entry the driver loads rtl_bt/rtl8761cu_fw.bin (already shipped by
> linux-firmware) and the adapter works (tested: A2DP and ASHA).
> 
> Similar to commit bc597f0cc44f
> ("Bluetooth: btusb: Add TP-Link UB600 for Realtek 8761BUV").
> 
> Device info from /sys/kernel/debug/usb/devices:
> 
> T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 22 Spd=12   MxCh= 0
> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0b05 ProdID=1bef Rev= 2.00
> S:  Manufacturer=Realtek
> S:  Product=Bluetooth Controller
> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=1ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Christoph Zwerschke <cito@online.de>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/bluetooth/btusb.c |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -783,6 +783,10 @@ static const struct usb_device_id quirks
>   	{ USB_DEVICE(0x2b89, 0x6275), .driver_info = BTUSB_REALTEK |
>   						     BTUSB_WIDEBAND_SPEECH },
>   
> +	/* Additional Realtek 8761CU Bluetooth devices */
> +	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
> +						     BTUSB_WIDEBAND_SPEECH },
> +

I have run an AI-assisted backport review and it spotted an issue.
I checked the finding against linux-6.12.y.

Commit: 0412e718aa75 ("Bluetooth: btusb: Add ASUS USB-BT540 for
Realtek 8761CU") correctly adds USB ID 0b05:1bef with BTUSB_REALTEK.
Upstream had already gained commit: 4a23ce935f74 ("Bluetooth: btrtl:
Add the support for RTL8761CUV"), which adds the RTL8761CU match,
project ID, firmware names, and wildcard HCI-version handling.

The 6.12.y btrtl.c has no RTL8761CU table entry and no
rtl_bt/rtl8761cu_fw.bin mapping.  btrtl_initialize() therefore leaves
ic_info NULL, and btrtl_download_firmware() takes its "assuming no
firmware upload needed" path.  The new USB ID alone does not provide the 
intended RTL8761CU firmware support and may leave the adapter nonfunctional.

I think 6.12.y misses commit: 4a23ce935f74 ("Bluetooth: btrtl: Add
the support for RTL8761CUV"). Should we drop the backport ?

Thoughts?

thanks,
Harshir
>   	/* Additional Realtek 8821AE Bluetooth devices */
>   	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
>   	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },
> 
> 
> 

