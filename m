Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F973A4F46
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 13:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780319761; cv=fail; b=IVU8JbCEM5S3+TOcDj9GUk0kbKgprdcaA8DxpM57jXq84hC0XLfgtifRWdn/Qx/n2T+W7gVDQawBoQyfrFMMAfG2R4J+W1i/tSuVTjonIB046w/t5CiHzZ+hSYHKvm1vy5NKYpwYFWSz7uOD1WZ35JTQBTXfBY9j97FUg9lzRgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780319761; c=relaxed/simple;
	bh=KGCMCMAMiy4hFDbHrrbmYCANo4w2M3Adx02NhOJ7DA4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xli6edAbvmyfBh3QBKFr2hiho9bNVMxRxx5idRlWeN+bchTr26FcNq9Mmw9m6zUqMYukXJh97Vzyqbi/BR+E36/Z0+IPGn8JOyEO9ZCM/8ulMpV2x2J0rN6RUzr1tlkpJ9F725GFpocTmkkTCzeqibFTn7BX9OXLv7c16RSBeD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GY3oJW0A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nLbUMX2z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GY3oJW0A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nLbUMX2z"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6511Mo101893928;
	Mon, 1 Jun 2026 13:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=saCoe5Q0htMPZ0isr29mSP1Fpp/q0IfYqRSC7klmzYA=; b=
	GY3oJW0AfgkUnE1WBwCz2xGjFdGCn6k8gte/9QmD73ll9eVtYhUnY+I0LuNhzKyr
	3MIloj6LDQZx2+EhZkgJkxaslcEMckHrWgrMyytvlSvIM+C/VmU9CIMNz5CgyUOs
	b29N/uPO3zB5DWC7xGbgFZVGdXJ0C0h0LSPqni8xO0VFZAGm+jVTJ/zJlXi4+s7w
	CGiz8Be0hMxeJpBXlqkoL7KDGccGxEJGOZV3PBKM/IMx2QK8XhFed7TMaIpkaoEP
	OHBOevjWe9XUyLMtexCsal4KLuy44+lUp2GWKtoyFoB/pXK4+vU8eMIfLVixbt4s
	CBGO4E+ZaFw1RAuHU9O99w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqxda5sb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 13:15:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 651DFNmk015187;
	Mon, 1 Jun 2026 13:15:41 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012057.outbound.protection.outlook.com [40.93.195.57])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbpmwns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 13:15:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UcWWtAuwZG1LwfwlI3Op4mCe/jJ/zMRxU9DCWIYmsxyeqJJN02cApHtPvPB69g5bppnqY5Yg43mFU+JNDkJHJRMEW5PZqeV1c8FpkbKcQGLUoVu2HjldV+YmervpSDaW/y52skvrtwEW13Eo4s8Fq7humWQUmUuuwn68KV/sfwPGH/seumkc60LDJXWJ9SgLUM2NIKhef2izYrmH+DB4C/NCAfSP1XxISo0AMeFqUs463DGTBhz6msbeaxVAlomxY7mk9M/tFYBTzga6/vMvtaDu7k6oFlCr7/Z+XejJNbW4Ljo2kBv2KEqRXwn6c8pYgrT0YgpRABntHA7FeDStiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saCoe5Q0htMPZ0isr29mSP1Fpp/q0IfYqRSC7klmzYA=;
 b=U0GTLzBsbW9QUsIb9xrmi1nvNiHnDNmVQKMUHnq0xTfrDIivZe3zztdUcUiLQHZbapToO/9C+6gznZhGrP0fNE0N65gFAdo4zISPzRvEuKXfYlH5FttDweCfJgWclwUbVN1eHanDEBNVCqfbox0KqZXsaEmDNRes901ufE7WbB4v/vR+N8IgBAm+Y1btasUHzLE9LTY8FfuoxQIP1hL3TLj1FdxryQgs/7h1bIYxdoG0LVt0ML7FJppAlGQM3xyW3gZ6DEVd0JbddvJGrxQD0yxATlYySO4IH/1yAUePA9Fxrfv9awA+tw4ObJISEPDORli8PzVFy6CrP+WUissX2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saCoe5Q0htMPZ0isr29mSP1Fpp/q0IfYqRSC7klmzYA=;
 b=nLbUMX2zInAWKUg8Qg2Wpv77Orsnhpy0ixnuaPi2S5IZ8/cafNeFqJTfphBYpWOHWxHZlGyK+F+7jedoN23UtB3OgxelAffKnoU/JG8+lMY6cYJfvySWZ55Mr6x+Hrtd+aD/s5hwUyJAHswCFjhOSMti+QEOQuvwmsvwR3g02tQ=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH0PR10MB7097.namprd10.prod.outlook.com (2603:10b6:510:28f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 13:14:46 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0071.011; Mon, 1 Jun 2026
 13:14:46 +0000
Message-ID: <c393e33f-dd81-4e84-8c26-98f865bffc9e@oracle.com>
Date: Mon, 1 Jun 2026 18:44:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 017/272] sched/deadline: Always stop dl-server before
 changing parameters
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yuri Andriaccio <yurand2000@gmail.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <vschneid@redhat.com>,
        Lukas Beckmann <lbckmnn@mailbox.org>, Sasha Levin <sashal@kernel.org>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194629.863626682@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260528194629.863626682@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0091.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::31) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH0PR10MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 8848bec2-549f-4220-77e0-08debfdfc0a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|3023799007|56012099006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	6UV5957BwHUnS64A5kf3c4HNXn+YBc0coDwO7UCKdddzBg/Xj87OsQQO7aJE1ij39BDxZsM4rcKtobXYRyGUHAA7DC12zMDyW+wGBqSSO0J7FSV8NuVgx3D9i0zpYNtFn5XzmZISsWzMfsc/cHpwH7D8BFCMxK5BdhjQpRAXhPbEtEdyM+NdvGPbiPuqS1VMNzOBEUq0VwXniEIsgbjlAy1BGMwCYc3OGTy7a3EzYWnYSdbriAMWfr+R6tZAMPA3PJvy5zff17b00DoEmTx1aL7fuDXe4kVEaNWyam+NPzXg5nW4IIATStgRiC3oicptC5AqvI7sSXQljHSKx7THiX05D5N4oPYjxyZk7DdDxDEGAfvyskO85bSKcOoaqxL6XNKZZugxFOgOZE8W5Zo+/cgp89Tf8UAx7utgeMHBxey6QNaeVdRFfpjBCNdVdLJr2HhKfQqZgcWZgk4nURKhHL2T3BZCHAR1NuMDtoYH3VvdzeTuMOiH0WL65wfwd6tIebVq8ioPAZ5NbRSfcUnB7L0h1e0qbRcnfCxrsj59oADykTCH0OyP4QaNebF5xAy0XL8qTs9WdVlEXlU9XGi//yJ3PcMa6y8ziwMNe80KrWSkMyivGHeQHGNpahYqZQl3CW0somqOQVWzZnOjE2BxyYOhP/xXJtggJ7ziIpDzQg2tfPiYW81KxHG4bGyqYceIlJnaLb9QShcl018Y5BXKOQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(3023799007)(56012099006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3U0aW5GTkJtQ2o4OTZOVHJkWS96emRTdFpSQkN1NnZobWhXU1FGZ2dEby8w?=
 =?utf-8?B?Y0pFdkJpRGRvNFN2L055RGhmSHFMRG5XSER4eUhNZ3FjM1JHTW0wWm14N3lL?=
 =?utf-8?B?KzlLOGUrM0M0Q1V6MHVjM004QXdnWmd1NHI4NnFxSnh3SVlQaHhIbHFzUU9v?=
 =?utf-8?B?YnFqYkFsTUp5eEZ6ZjBnV1piZFN3M0srbXNnVHk5YmhVRFFsclBNUnJIc01j?=
 =?utf-8?B?cG8vZEZVSlFBZm9PRFZOdU93U3dlTC9UVSt0ZCtiUFdrdzVzTklzRXJBOVhx?=
 =?utf-8?B?NGNnVk0wWERGbEI0TEI4aEMyM05HbXZUWnFzdkY1WGdlWTFWWDBwTFdoeWtK?=
 =?utf-8?B?SU5BTFFhT0pULzUyOFdWKzF6TzQ2bFE1WE5zb0hHZldCNUxjR3Z5VFl3RkRW?=
 =?utf-8?B?bUt5ZjlpM0JVckQvcGluamgrZ0tKQWhlUEt6d2YvbkhMU29yZUlQb3BBcVdJ?=
 =?utf-8?B?MXZpUzdrT0lrL1o1QUw4dlg3R1IvV1d2clMyOUFiWjFzbVZoOHFUYkhsVVNK?=
 =?utf-8?B?emN6SnV0WVRrdXBCQ2tRVTRnT2xGOVBIZmhzcDVUQzI2bWozQ0h5VDZwUEly?=
 =?utf-8?B?OGpENW1wYVlRL0FwS3JWNVpqZ2hrcjBOTEJUb0xZOXVTNnd4WUZDd0k4cjIw?=
 =?utf-8?B?MitnMnc2UE5zMGc4RnVtYUZIaGZvbjRjcFM2ZXJpcDZ0ZGlKVUhFWTlvblhW?=
 =?utf-8?B?SGJpLzh2VTVOMlVWaXA1L0pIeERtcTVzWlBEZWplZGQxUHNRYmpDa29aVkxB?=
 =?utf-8?B?dE55Q1JXYmpPcm9UeldMd3NHQmRGRndIODcrT2sraWRZVUpPY1NtbitBb0Zm?=
 =?utf-8?B?Rko4dS9meWxCVVA5bG9ITFBnRVpKbWY0ZGRXQkgwdFdrSXdvZHRiZVczdng4?=
 =?utf-8?B?VkRzV1dKRFhxR1k5ZUhzNHRIbEZyRlVmM2t3K2Q0MEQ0Qkk1ZFRwdGdNVlpv?=
 =?utf-8?B?VFdTZ3dRNXpjUm9QbzVvaFF0S0xZN1RpQzNLSll3UVVocEVJdm84NWpDalpq?=
 =?utf-8?B?eEMxd3VjeGVYWGZkQVRzRVZyNE5WL1MvZFJMWi9nQm1obWFHcUdEZGtyRDR1?=
 =?utf-8?B?YkJISGd0ODJuTEg5M3lOZUhUemsrZG91V0RzV2VXRk5pZjBoRWMzNWZVa2hR?=
 =?utf-8?B?aktodU5mRnkxM1F0c0x4SXdmN1FnMXhHVkVzVTAvQTY4akxEaTUzU2xBTzlz?=
 =?utf-8?B?MVFLVmxlODJZZFE5bC96ZnZlNXBnVmVqekxSbExxejZOc0t3SXBPalE5dTVy?=
 =?utf-8?B?UFRMR0pXZkMzeUIxMklSTUlGd0VHVnNmbWtnOTl0NTY5b1JWcThwdm92UmhT?=
 =?utf-8?B?NkJ4TUtQWGw1eDYzN1MrWmt3d0xaNERBWGszZjIzK3N0bGl1WGxjUWJ6TExO?=
 =?utf-8?B?VExVRkJhS0pvNEE5Z0pnQTJQRzBLSTllNXdSTnNFaHdQVWVOUjIyQXVmUUJL?=
 =?utf-8?B?TUhSbE4zcWpGdEdHalBveEtvU1dEUVZSaHdZV2M5NGFjN1p1ZUR6Q2xIWE91?=
 =?utf-8?B?NDd2Q3JtcjlsYjZWUm5NT0hTN0RnWUlnYXFJMjA3ZHEyQkxWeCttdjNxQlhz?=
 =?utf-8?B?aUE5dUp6Tk53RTJUdlBLeUxWWFlMQVQ4RTZnNGdvaExXbWhHelBMdFVTQmxj?=
 =?utf-8?B?R1FQcnFrWmVZTlFxZmtuWFBub2E0Q3NCcm5BUStFRlBDajliQy9BMUpZaXhy?=
 =?utf-8?B?c3dIbDF1dFZ2ME9GdzlVVkFDY244MUUrSFh5dXF5SVQ1NmNTMDZDTTFjQ2J1?=
 =?utf-8?B?SmR6QWx2U2VhQko0VFZFY3JhKzVhUFlLT0YyM0RqQ0RaQ1g1d29uamwzTDJP?=
 =?utf-8?B?b3IyblNnRjhUcUhTTEtqemt0SjJySDdhWjZwTmwrd1A4dy9Qc1g3dkV3MWFN?=
 =?utf-8?B?VngzaGtUMVFBMERpMmw5emRDaVo1bGxEbEtJQmNQZStjZzcyZmFOaFhndXY3?=
 =?utf-8?B?aEVkUjhMOU12eEd3OWE1b0dMRzZ5UmlrR2xUY2l2WlhVWnAzNkN3UTk4Z0RT?=
 =?utf-8?B?dURyRnQyTy96VEs4SytkVGxPdktKc3E5b3VEOGJNZVNQclIrUTVOSUN3RlVT?=
 =?utf-8?B?V0szMXlrUDRCRkE4RWsxNlhsdExTZE5NT3d5WEZaWTBYN2w0UEpVSEMwTDFq?=
 =?utf-8?B?dWRFQlRoZGcwZGsvbmZZTnh0cjZHd1hGLzFQSjJKd3ZhNy9PS0dhVFl1VFRV?=
 =?utf-8?B?UUU2VGk2dHJCUm1lT1d0MUZ4dEhtcVJURnNrZndIYVRRZ3hQSE1neldUbXNz?=
 =?utf-8?B?c09QODBLMGZNUWQxdTNKMUd2SUpkTkNsUnpscjNmWXRNOXl5RWc3clp5WFcy?=
 =?utf-8?B?UVhpZ0ZXZnVraE9ZOVpyZVIwa1V5ek1zVVJBbVl0RjlmbFZqNE8vWDVNV2Ey?=
 =?utf-8?Q?csQWWMI5zJmRDfhzi0QgPWRiLcrJa0i/xUTNJ?=
X-Exchange-RoutingPolicyChecked:
	ZLW+qGhzZHkYVddcba8toab25VMV+yk4kUOh2WpHHX4DimZZlkooQ0q5tYnAULkTGZCJ547nbVf+PIF0MtXPRsBTCo/hCOivyIsTeWtvfQ44SSbeMTPWYnF84Pcv42KJYhDVh0P7SmgdtF40L700ofTa6SxNEU4XqpzElADam5sTuqURaPihqMFO53n+2DiIk+WI+WE1CN50JWj+oqXqgTbIUyCrkxbtnq/MaRV8pXF+c+RJgZbUtk09M5uWYuyF2ESPAiEWUqb6fA9FrLcA/P9Wri2jBt9/C+zs3pTbttpNNZNSc3iWZQEVAtsRh30XPTeMlKHwfHYUitLO1gFSGg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RMejz63ikABSz+LnxKDWTSPtKLR9oy3wW8j7E2wAliIqBgcBbb81jl7EYAtl3V2MkyljvA524wG5MVNpLdJvh48g0iHqufPOf47sURxepcNk+8n2M3gheTD89Xu96cRYK65ynzYNkpTDfoZKATfC/C010uczWw0Qg2WoywWAHhmS3e3am1GBtm4ficz3aUbsOfYO6IaWIrnOZqyvV/O7G0+Kz3JhIikfbhznsKHgkSptrHaGNAzpKbuAORuF5P5On3BRBEKrnoxx4sWinSS1xUkRZ2SPCcDndAh6soL7qQlgpaYzyzPucuhPT3dxWzGp2cF2C+sfM2yf5g4hW8jO26Gn8F8YOMUcoYAJARBm8ClCYHWVZxxXqiP8hTMxAPoZieomX//tVeZdMtN+AttGUt2rCfSzVVa7mW/qD+hHOgYsrNR2TOYMtXw1vVCIv7uSzmGurRIxwqHkvG6JwFc3/v9rYNEXSoKLRtTFnwQnk0ovOYBTBHAQxjjaYMuPQd0yxPPAp6V/ThILv0R/oQQ4bAVnOV2p2qMtCRH2z4kM546bMWjbHcETIqYtkH7/xFg7m/w0BifLDJJbxhe+2yffw/1nI1lW/Qy8cEeLVEo8GeI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8848bec2-549f-4220-77e0-08debfdfc0a5
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 13:14:46.7824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9C1WeuQe+mjXenh8gv04zvZJZx/ZrYCJIRpy82AT2oPMcdAQWpumkHdgBmwRsi282CQwfpvwyV1BD6EVM6vPomUmz3o7tqjFlT74nqSgRiJ/pux9QUAy6fEtpdltnLjF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7097
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606010133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEzMiBTYWx0ZWRfXzINSKa9Wssfz
 aaG4Emgr/I61sEjYUZzWo7a6UXfk3XHGBedqNFNjpLkt7LpAukxVfvHqN8KqgVyjp2mptSUclRB
 QSXdzuRa2d8loYYUkYeM8IzSBtX93ue26R+gIaKgm3K7ba8Z7vaN+62JfhAM0mstbTJm+7l/Pko
 3+noFsrRz9csOcX5GIhzWwI83kEiK6X7nG10I/WFO9SlrtzPfFNgHcdp0oO2aAPu1yiu++23dGD
 L62l5oGSysIraa5IlCcfGug52MecVzj9/V4YQme+8DwRjoOxP71LiFRVzO+5aCNTLMSz9Uz9oh/
 7XcidaQUmD4k9UxmUzXpNhyLYfHRrDwBfnslpzaVlmSYMhwU7Cr8XR/XLd2rqhFqj5h3H23/EWQ
 oTpa9nWJ5Gv7BnzDqlfeOPZ7bteciBS4YqzRhKlTv4AnE1o4NITZKViz6XdZ+pGxzbbIQicxXlX
 KYCAPwnilkl5ONV4tjOJQi7+UR/Nqik57CWAmdCU=
X-Proofpoint-GUID: sX5INBV6UDM7N9r2kM5LejYldyvgCV_Z
X-Proofpoint-ORIG-GUID: sX5INBV6UDM7N9r2kM5LejYldyvgCV_Z
X-Authority-Analysis: v=2.4 cv=Po+jqQM3 c=1 sm=1 tr=0 ts=6a1d85fe b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=b3CbU_ItAAAA:8
 a=vG02D5rHudgGQ-sFvuIA:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
 a=Rv2g8BkzVjQTVhhssdqe:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12303

Hi Greg/Sasha,

On 29/05/26 01:16, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Juri Lelli <juri.lelli@redhat.com>
> 
> commit bb4700adc3abec34c0a38b64f66258e4e233fc16 upstream.
> 
> Commit cccb45d7c4295 ("sched/deadline: Less agressive dl_server
> handling") reduced dl-server overhead by delaying disabling servers only
> after there are no fair task around for a whole period, which means that
> deadline entities are not dequeued right away on a server stop event.
> However, the delay opens up a window in which a request for changing
> server parameters can break per-runqueue running_bw tracking, as
> reported by Yuri.
> 
> Close the problematic window by unconditionally calling dl_server_stop()
> before applying the new parameters (ensuring deadline entities go
> through an actual dequeue).
> 
> Fixes: cccb45d7c4295 ("sched/deadline: Less agressive dl_server handling")
> Reported-by: Yuri Andriaccio <yurand2000@gmail.com>
> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Valentin Schneider <vschneid@redhat.com>
> Link: https://lore.kernel.org/r/20250721-upstream-fix-dlserver-lessaggressive-b4-v1-1-4ebc10c87e40@redhat.com
> Signed-off-by: Lukas Beckmann <lbckmnn@mailbox.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/sched/debug.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 7d14e9fa53ac3..564ea17ae405e 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -378,10 +378,8 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
>   			return  -EINVAL;
>   		}
>   
> -		if (rq->cfs.h_nr_queued) {
> -			update_rq_clock(rq);
> -			dl_server_stop(&rq->fair_server);
> -		}
> +		update_rq_clock(rq);
> +		dl_server_stop(&rq->fair_server);
>   

I have run an AI assisted backport review and took a look at this one.

I think 6.12.y is missing what upstream has:

The backport makes sched_fair_server_write() always do:

update_rq_clock(rq);
dl_server_stop(&rq->fair_server);

That matches upstream bb4700adc3ab, but upstream also has this in 
dl_server_stop():

if (!dl_server(dl_se) || !dl_server_active(dl_se))
         return;


6.12.y only has:

if (!dl_se->dl_runtime)
         return;

so an inactive but configured fair server can still go through the 
deadline dequeue accounting path.

So it looks like this backport is not very safe. Thoughts ?


thanks,
Harshit


>   		retval = dl_server_apply_params(&rq->fair_server, runtime, period, 0);
>   

