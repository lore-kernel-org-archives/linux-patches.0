Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D932717C211;
	Tue, 18 Aug 2026 20:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787084235; cv=fail; b=oPyK3RtMwdhFTGq5kHH5lO/3693UlV+7VHF1oJhz9D+qeo0XtwAgiuZee6DlxwjyTiEDUUSzP51mZyyXC0QQGGuXWybleirldii3TSM+5TllJpo7YL5nMu/AN7kJp256PBF93SXfTyTmOukwZYruipocLmxA2UeyJirdEeZWdHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787084235; c=relaxed/simple;
	bh=lgpRnXTtQ0+mJtxvKCpbgEPvxj7GiNJShH22TGrGgE4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B1Y/VsaO+vqaIBwNAZ2Fqgf67jogcQswO+OjgJ8zrggApPpAEWalBqOvXbdNQ0k6zUDGoYeXTPuAYkgSZ5bww+n7wsXJ4U9Xy3KEhTlszx3BPOg2X+E9B/YPF2eYm5LbkyPbllQJtQ6g2uPFAm1UhWUddc2tMBQbVMqoftE7rgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BDQMIFVU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oVzY6Ida; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BDQMIFVU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oVzY6Ida"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IErpTV3799999;
	Tue, 18 Aug 2026 20:17:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2RAG05JCSOfm8mizT7FfR/n+DEfCqjoLzLGh0YOUCQI=; b=
	BDQMIFVUZnIyWOin84YjzB+6AzTBxMjGSKX7B50V9UyKIt4T3X6NBVH2MSPwAEST
	xLvQcUrFI47UeJWJI5EhXNp7gU8Z0/zuq53kBLSDQ+xufXK8JwCAPQQgYEeESLYQ
	AKAs7+HUHF4WowLXMsIbMZxZ/mb4rBBiABpc4hyBy/TY/qvxYzOqVxyLzTgDgsgr
	fdqUW4J2RVe4J0Mbfksc3S4DSU8VSH9yk0DsX3ORhnrchhfYrmRqMffTBPO5W+pP
	e1OJlp8Rvbs4aWJlIQJMY8iopK0uKgCgGUzrUf56QzkQ62K3ZRTwg3r06sEW/MI6
	p0dAH51UCCe+3QHAZfD+EA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2f1bwnue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 20:17:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67IKAD2x030072;
	Tue, 18 Aug 2026 20:17:08 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010014.outbound.protection.outlook.com [52.101.201.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejdcbsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 18 Aug 2026 20:17:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KUeyI97MsJkdc7VbAOf8R6lCPLKiaD7qZ333efTRQc2Zb87dfUm1ZHE1pM4yRhtSQQab5VQ5qK3VMSbZuWH9ngJwIEXyx5AFv/Nns2XWy2oe1/RYm11aAE2r/jIhUrKEa5K6pEU6yQA/KRkc8mtyPnsqJGOpYOKNCfgrChfKkKWciRS1svH7hPi0jPRL1aReOe/pgKrhl3GXVjwM/af2ktbdQIHXeU2lNWH5o1qxHE13xvhKncpobyYknTMUbxDkLKM+G9x+exLgaHWS2o1afW4mVcTfnqihuwehcZxqfCngvvjUvr76Bii5xrzqKas4gqdObD0Ma+M1LDAxEZ3bKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RAG05JCSOfm8mizT7FfR/n+DEfCqjoLzLGh0YOUCQI=;
 b=CARpSL26x2OKW6k4OYzO6BBeV47j2UtBZEYoLKGxrBh/e7jighzMZldfWhJyTGWS5VlDd6bcCuRhkqeEQlQzS96IsXMExp2ixSEGbFofRXvBocJftyrhvVjWHty/29IfU6JlFe8PsvFv/9AnRxO1hQOXrti1pj3vgNzfKGFw97vsOC5X6JGaoN0cOCXwyGrDj566UNx9GVo+w/hMptuQUb30b37pqvji17gFcRsWWCkrMrHCOna3JuybO1xzClQi/b4sO3R46FFOWiox9fCDlRfYYENE3Y6KS/aQ1p5Er1RVpUwQTrjfzkjojb4+lhQO+CNogZglA6qYg4YTyj0gfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RAG05JCSOfm8mizT7FfR/n+DEfCqjoLzLGh0YOUCQI=;
 b=oVzY6IdaJDucbPDeqO9iwv2XLYjXaViirUC2ksiEs2mgVM+gBg/By+vg7lGVkoaWX5drzE9G4iejXddtk9yjHo8kry9tFBWMzXGLrZXKDdx1BL9a/b3j9mu6A/MXtYI5olvQ2BH1lkgZxcMLgnTeCFNoqFIAQ3JSBeI49Mic054=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by MW4PR10MB5862.namprd10.prod.outlook.com (2603:10b6:303:18f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 18 Aug
 2026 20:16:59 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 20:16:57 +0000
Message-ID: <24644fdf-54f1-470c-9183-8f5c420c760f@oracle.com>
Date: Wed, 19 Aug 2026 01:46:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 163/181] eventfs: Use children field for rcu head and
 add memory barriers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
Cc: patches@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20260817132535.394764707@linuxfoundation.org>
 <20260817132542.099906154@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260817132542.099906154@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0606.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::14) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|MW4PR10MB5862:EE_
X-MS-Office365-Filtering-Correlation-Id: fbe58301-c15a-49fe-cc7b-08defd65a708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|56012099006|10067099003|6133799003|22082099003|18002099003|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	U7BAM8mI65mhsHmkc5Aotsl4VggQ/9pkW9TL5MG/7+GxCvKpx7zBVRCtWZXSX8CAruhMdFxG/yHjNsu4YGXrzPetm1ujVhTdol03HxfpphwOH4nqzom3SJOZWzQRik2eaekFHF65zIBxCQtyGfnGykhXNfPJo6KS3uUoUVxBJRfiBfvyE2uFYJ0rhcHFs+mywLj0mXPH2NJvP8kmbd8XFCbp5UzSfa4m6hq1cgR2b9jg/EevwzRJ7jkFwj+pzh4dMneM9W14ug/GaYd4WBP50QWVoFecw2xqkFx+N7hNhso19+6QozRevYU0xiGlyNFt+h0hmMMM3/CSbk37K2bFrw0Vd3jYmnHIMdRAFLbIGvVNg/gcXBPFZmOLJk9qf1I47lNRpGOBfxi9FYrt1rUAch2DW+puZ1kYg5v0hRVPRaZBZSt2RQvTCtv3AvkxCyKJbyM1aRIin2g7xvmfiscIdMgPz6pK5VB3CGoZlcGvgfW6ls3ZRsWKpVwsarRrCVeZ4fCilD9XDSvj2VqpuvpTT4uP9dX4yjtgLB4ECIcTtFYSivP2HrPvdKVZXdR2ROx/y7Q9ldAusFb+IDJBXtwSSI+wdSEIY28zYJtS+38uXgs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXp6aWtpUVE5V0xRWmdxRmR5ZlpENVk5b0dXT1oxV0k1VnBOODRWdmdpTUl6?=
 =?utf-8?B?cittaWtlbHE3MkZUNk5UQ3NvdUxGM0l4d1FuOXdxNnNtc1R6MTVQbDJJUkNG?=
 =?utf-8?B?TFR6bjF0bWlEWEZ1MGhRODlKODZUMEFQQ0tsQVN4S2cvSVhkUDdCYUZTUzk4?=
 =?utf-8?B?ZGFweFpoVTZDTGtFcDhiYUg0TUVkWk1vK2lrY3pPTElmSEdEUmNpQU5Xbmpn?=
 =?utf-8?B?TWFwRkZ5Ykt6WWZEMFVCNGVYeGJGRExXSjRCeUJ6K3BMU2hUR2NIdnNvcFpB?=
 =?utf-8?B?elFPeUZET0RDMU5UNzJoMnRvcU9QV1NJOWMvYk1PMmlrVlBEckRCajdZdWFp?=
 =?utf-8?B?Q3BPU0pIZGdMc0lxZnZKRzg5ZnkzWTVjbEJBd2pteTVPeG1CMW1YMmVaQ0Q2?=
 =?utf-8?B?QmQ3UWttSlZzYmFxNWpWVE50L3FFK0RMNUVvSi8vWHBWSGQxNVhZeFoyVWp4?=
 =?utf-8?B?YWhoNWE5S0V5dUx2QkJCdXBBUWZIR3FodXVKV2pjeTVZOGVNZlRHbjZLNVd2?=
 =?utf-8?B?UFRkM20wQzB1a1Q0UEdPbXhLZ3FoM1FTd0JNcTNHRHFCZ2wyY1ZGS1BTWFZi?=
 =?utf-8?B?alRpSThRYVNwRktXTC91Z0p0K2lkZ285ZlJBcFcwZVJlL3hGNmF4UVcrRGtz?=
 =?utf-8?B?Vk1ma3NpalpNOVF4N3U3SmMvMmhDR2ZGeXBBMXNua1l2UXBxWXBORURQK0ZN?=
 =?utf-8?B?aGFKc0lQYU5KOFEwY1FZTTBTMm0zQWJzLythcTN5RlJYRkJiTmVaWnk5YU9l?=
 =?utf-8?B?aDFyOEpaV2d6UWo2WFlqcHFhTUthMkRyQ0FCTjJNUGlIUDIyV0hIbFBwelFr?=
 =?utf-8?B?b3JFc2M0aHl2UnBuQldvaVFjWW9PeFN6NDdZZHFKVEs2dytQQkRHSUxtN3c3?=
 =?utf-8?B?WVhwVjU4MHJmYnZvOEpHS0k0MTlSTHFvSmp6N3lOVXJ1SWx0L29yc3h5VUNU?=
 =?utf-8?B?dHJTM212V1VKRWJ0ekhSQW9rcTJUZzJ1TUNRbFoxcitsaVVoKzRneHp6bndy?=
 =?utf-8?B?cDBQaUtHSEVnUVRTWjU1VmZZS3BNSGgzd2hPZVJPUDZBNTQ0bzdVdjZ3Wnk4?=
 =?utf-8?B?TEJvZDFlMFg4WnBtRHVXRXVIaStPVUNkWlNxQ1l2Y2FqZUwwcmVxbFFGbEtU?=
 =?utf-8?B?eldreE5QY3NnNmtNa3oxV3NYVS9kTktvV01EYUZldndZalh4OVBSUnhUcEtY?=
 =?utf-8?B?aGQ1NlQwYklYMENXVmpUYjBXWUJzczRSQTB2dEVENEFoUHl3azdKdXlNSGox?=
 =?utf-8?B?L0RQNENJdXl4akJqdUVJY1h1TGtZaVdObkpOTzBkamtrd0FZR3ZPTmhqVkxO?=
 =?utf-8?B?SERtNUNpelVhNmtYbDhXY3o2ZEdPZGoyVjVDSStkbC9sbExpN29TMVFMb1h1?=
 =?utf-8?B?RjN3aWFGcjBVZEVlUzRjVFA1aFk5Qmg0RThIaDlHUU9EQU55UFVmQUNzajFD?=
 =?utf-8?B?NGc0c3hLTTJTRVR4RHh6NW1xcmFRWG02ZFVDMkhVV1JTU0twTk96dW9QZEY4?=
 =?utf-8?B?aGFyUGlmTGltNU9LVHBEMGd2VXVRVXpkV1VTYnlJVzg0V2FlVktzUDlFOTdT?=
 =?utf-8?B?RkMxWjgwZU5IVVFxYUtqYkdvZmtIcjZQZU5yaklaS2RJK2ZMM2hha3dYSy8r?=
 =?utf-8?B?SGtSMUxXcEMwL2JzWklIUDdXcUxxRUpaZmxWM2dTUk9LeTd0SXJnK0lJLzIx?=
 =?utf-8?B?V0tVc3RmTlBISzVlaS9kbHdRV0FCQTlsdVUyUnJybXFLcnhDb1VuNWkvT0Nm?=
 =?utf-8?B?V01mR0YxQTlQVkVHUGRONWI3SVM5bzNSc0xFZ1g1dVc1akgvU1RRb2VFTWcv?=
 =?utf-8?B?OWowaEZYN1RaTUNXdWRWSlZnU0ZuaEo3cU1lZThkR1labTYzV2RIQWl6M3hp?=
 =?utf-8?B?MHU2MVJIbnUvdi9qWDhoVEJhakIyOTlZS3VOdlcvOVQxK1RKU2FiQkZ0b3U5?=
 =?utf-8?B?YXFTSWhza0E0dnczeHdmbC82YnNtdUFEZ1cxZTZHQXQ4a3hMUjlzVWdrdjcv?=
 =?utf-8?B?RkFyQnc3d3pSemRoaUxVU3VockxaVk03UUo0WHRyYmFxdzZNWHg5SmEzK1E4?=
 =?utf-8?B?WXY4RUxFdVQ4VnlRQVR2ZndGSFlobUlPbkVtdzJtL2tFenYrcU1IQW9uOXJa?=
 =?utf-8?B?RXVacGd0MXZ6dGNZdmFNWFBxdjdRMzljVmg2MHRxcWxvVWtncTUzOG9CSFZn?=
 =?utf-8?B?bmNRYSttdDNBQ1IwSzhqQkp1eGNIS2szV2o3ZWUwMVhWN21SWUNxcWhkaWNo?=
 =?utf-8?B?UHhwZUhjVFY2UTNrcCtGWFgra1ZIWHJDMmpKSVRLbmpFME4zbGx3RUZMbkxI?=
 =?utf-8?B?QjM5YkZveHk3MWdZUXhWTzdRY1hmdFFOUU84Yk0xcVNoN2xCaU9MYUQremJJ?=
 =?utf-8?Q?hCsmLU0YwwOcFM/7yNjeFvmZ5nm+85bRnTfi0?=
X-Exchange-RoutingPolicyChecked:
	K6URvzrSnKnNCZ8iRIgcIAsOt9Y1b/WAK5ssr9EmySId7e0KjyA6fira5tPJXl7Yw8prFIXM25oazTFaXaWXuEpx/ham96x59tlufHoPdXol+AyFrfS3/o/e3LFDMj0oB5riZNvte3bCIaj5O9cPBQ/prQViQ13nA70sSC0rG5U00Rmr1iZ5ruFQu8Ed0s2xOowDIq0L+TcaopbQiN6M68SSWxI8ZbZn0bbrnQm+5b7gNi3J3wdgBC+/euZnLfsc4/WQy+PevlMuLWmgrERhwvNQip+8fMhKnDpzcAgWRuWFw7wppIsI3Ve2gnXH8wjJz43VriEWYskjgRE9D+qZ/w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Lbn7AEuq97Sk/Ld6I6ZUqn7FIqwY3LgJdMRbdXJkqkIV5VU+LtaL8wp55qn3hrhh3PVhQpSRMNUv9CMEmitl51PflKG1E2fH7aoEFWJr0LECJ0pnA77DjFJLFbeKjRBi1gIZHZc6ok8XFp3f82hYMudfxuUjqUYF4Qf5zYZIT9b0J00mvZT9Zt8tGPWiJiQZ6gXK6cL4qL+wr83zoA+C+KGsw9c6ghBtN2XA0rBIm9WUZNjwo5u+CxupdLxKboIi5/t0iS7P7Y1by+TSQhurQcqW0Taz6MLFtJh9WDw0/e4bn07BGxVlhY7qUBPlBU11q8f597PMz69msOxja7zO0g8WolKuHTmy7hAekqGjCWI/qWw7Yeqr/9LMnNzxS3/refzQHfS10PED+8AtMDnWDUwgVFTrsunqnmefikR1D1gn42eKagQ/PKBiP3/hGSPNWzPeEb3o0b3viSmriT8Vab7A8to1LgCda6qQ1Am0rnfCL0SzTfWwji+PnIdb2gdP8CMmw8lJPZSzOmJhi1nV/VQv4ogriRp+S5Y1S0yU/gkp/bcpX92Shaf/YbBe/fkxEzVaeVpV7xHbjiRcBCJuultt0nbNlUHMFLvLjg/9eXo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe58301-c15a-49fe-cc7b-08defd65a708
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 20:16:57.0657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hxao2KeyYKAnpxBEy9R1RNHySGUZc1Qroz9voWT7MHKTrkmv4dp2ktBgSiogTPNq4jyD/U/FKtP7+o5ecjb0duvT6Fn1VxlKSHw4a9SZ9WarbhNN8gL1KcQzieIkvhmp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_04,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxlogscore=896 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608180148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDE0OCBTYWx0ZWRfX3/4+s0GaSSR1
 RQQF1RpE2LnmFihDEmLZACC6kNtM8krlZaT+OEOFOuJo8YJpaQArNlteazguMua5XGfPDN2JfUE
 oMaJxtFSK4Bgmv4U8agrSrPwZ8nQX511YN4wYlbuYNX9xQKHTcyY0/4KLRmDAyJ9DNcupEBFXLL
 Y3dYi3VNqIj8uy3EGgCiPgEGczYJI5OaFNDbNzFKPLWfRHLMX21+wvNrcPpOJoQ9iBBK69/Op8U
 TuGSoXlv71tptVw6jljmncmeg06hJDCDwCXsbk98boWmPEqsm4lnGDjLAMNaFoSfsoX4ZjYcMsW
 fRXlaQMx0fIP6VpTYwqQFl88Ot1rTjS8TCXfe37HDieKIciDzfIm4p7W/gCPOzX84g5L13zeMo7
 jiPnwInkTvjh793nUSX5InbpZomBTzIfxh8y59Id1CyL6QwOf9WLk/drGzqggXI/s/9Wey/3sro
 x9tLpWu/VZkd5pe3usA==
X-Authority-Analysis: v=2.4 cv=D/937PRj c=1 sm=1 tr=0 ts=6a84bdc4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=bC-a23v3AAAA:8
 a=c92rfblmAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8
 a=ag1SF4gXAAAA:8 a=AN55hjBDeVdEbgGPGiAA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=GvGzcOZaWPEFPQC_NcjD:22 a=2JgSa4NbpEOStq-L5dxp:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: 6zyGoLuaTola4d-wggpSgJfBIKNdkEGx
X-Proofpoint-GUID: 6zyGoLuaTola4d-wggpSgJfBIKNdkEGx
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDE0OCBTYWx0ZWRfX84PlqYJd8Vf8
 7At+Ed0ZlybYM18Tx4KHpVyHe0+OohEVpH8/v5SHqvlq8rITtas5xpRgWbFyvgm7K4XwLI/zhWM
 vnmgb+njIa++WqqQFPbafkP2d9q7CWE3ax1JNmUlaHIgAG4VKqNi

HI Greg,

On 17/08/26 7:04 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> commit f0ece16ffca7384787b692431961ce202907acf5 upstream.
> 
> When an eventfs inode is freed, it sets ei->is_freed and then uses its
> ei->list to add it to the srcu link list as the list field is a union with
> the rcu list head. As the ei->list is used to iterate over an SRCU
> protected list without taking the eventfs_mutex, there's nothing stopping
> the iteration over that list to see the ei->rcu instead of the ei->list
> and it will read a corrupt target.
> 
> To fix this, change the union of the rcu list head with the children list.
> On freeing the eventfs inode, set the is_free and execute a smp_wmb()
> before adding the eventfs inode to the SRCU list.
> 
> On iteration of the ei->children list, at the start, execute a smp_rmb()
> and then read the is_freed of the ei to see if the children list is still
> valid. If is_freed is set, then the ei_child read is not valid and the
> loop should exit immediately.
> 
> Cc: stable@vger.kernel.org
> Link: https://patch.msgid.link/20260808094215.4252430d@robin
> Fixes: 704f960dbee2f ("eventfs: Read ei->entries before ei->children in eventfs_iterate()")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260806022719.375354-1-shuangpeng.kernel%40gmail.com
> Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/tracefs/event_inode.c |   24 ++++++++++++++++++++++++
>   fs/tracefs/internal.h    |    4 ++--
>   2 files changed, 26 insertions(+), 2 deletions(-)
> 
> --- a/fs/tracefs/event_inode.c
> +++ b/fs/tracefs/event_inode.c
> @@ -124,7 +124,17 @@ static inline void put_ei(struct eventfs
>   static inline void free_ei(struct eventfs_inode *ei)
>   {
>   	if (ei) {
> +		/* The ei should have no children if it is being freed. */
> +		WARN_ON_ONCE(!list_empty(&ei->children));
>   		ei->is_freed = 1;
> +		/*
> +		 * The SRCU iteration has a smp_rmb() to make sure it
> +		 * sees a child (that may have already been freed)
> +		 * before it reads is_free. If is_free is set, it must
> +		 * not use the child it acquired from ei->children, as
> +		 * the list may be used for SRCU.
> +		 */
> +		smp_wmb();
>   		put_ei(ei);
>   	}
>   }
> @@ -647,6 +657,20 @@ static int eventfs_iterate(struct file *
>   	list_for_each_entry_srcu(ei_child, &ei->children, list,
>   				 srcu_read_lock_held(&eventfs_srcu)) {
>   
> +		/*
> +		 * If the ei is being freed, then the ei->children may be
> +		 * being used as the rcu list, which means the next element
> +		 * may be garbage. The ei->is_free is set before switching
> +		 * the ei->children over to ei->rcu. The read memory barrier
> +		 * here makes sure the ei_child is read before is_free is
> +		 * updated.
> +		 *
> +		 * Matches the smp_wmb() in free_ei()
> +		 */
> +		smp_rmb();
> +		if (ei->is_freed)
> +			return -EINVAL;
> +

I have run an AI-assisted backport review and it spotted an issue. I
checked the affected control flow.

Upstream has automatic SRCU cleanup:

	guard(srcu)(&eventfs_srcu);
	...
	if (ei->is_freed)
		return -EINVAL;

6.12.y still uses manual cleanup:

	idx = srcu_read_lock(&eventfs_srcu);
	...
	if (ei->is_freed)
		return -EINVAL;
	...
out:
	srcu_read_unlock(&eventfs_srcu, idx);

The new direct return bypasses srcu_read_unlock(). This leaves the SRCU
reader counts unbalanced and can prevent eventfs callbacks from
completing, allowing removed inode objects to accumulate.

I would suggest adapting the new check to set ret = -EINVAL and goto
out.


thanks,
Harshit
>   		if (c > 0) {
>   			c--;
>   			continue;
> --- a/fs/tracefs/internal.h
> +++ b/fs/tracefs/internal.h
> @@ -46,11 +46,11 @@ struct eventfs_attr {
>    * @ino:	The saved inode number
>    */
>   struct eventfs_inode {
> +	struct list_head	list;
>   	union {
> -		struct list_head	list;
> +		struct list_head	children;
>   		struct rcu_head		rcu;
>   	};
> -	struct list_head		children;
>   	const struct eventfs_entry	*entries;
>   	const char			*name;
>   	struct eventfs_attr		*entry_attrs;
> 
> 
> 

