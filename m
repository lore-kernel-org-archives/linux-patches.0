Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795283061;
	b=kUMnz0BXbSBskCXqZkj6XDf/mMw38o47VU11kcikdaNBz44c4bLO41sC8AzABnKFzj9f
	 JXIt1ZzLJedjCWR1wQFfrkVA15arxLmie2ZO/gh70r8stdhVG8k7CdRSVFLSGfuggEh3f
	 NniZ3c+x6Wkscu067OLBVAyb89oaFRpK93nWd/Pa39sbMrPA+Kydr0MFTpxDUMNacN+V4
	 jhOiUYlPFGiq67EyRhQjYMs3t4ipkul/RV/1AyJHBi5y5Cg9l6Hek+NoPPHuZ0WX7hmLY
	 KKGm6NZsJjsoWYeP9IkzzwQDZvE1t1Myqgj0il48odChDcPYG54REHCEvZqDIOKhpmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795283061;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc;
	bh=apa9byoloIqZmN0NGZL4q10l2t89QK7uryqIZ4uM8Wg=;
	b=f8DvpTnVTACG+QtxB6qzozEOP6aXP+ujp94jQ3ww6RGW1EKge2meLp3GIk5ZmxV4j282
	 nwnDWx43ftBepEiRZB5Dfl0/qJf6es8uPk3sieU/2G1/R843lA2F7XP7scly1WIlf7DVp
	 zjEQeXNn46LCfDE20yO1HtGFhFSnB0Y95yQXKh9c8VJNj8Hb8gjuGYZhVJlqLaj962CVc
	 MF3/zGBYE9ESRWjFaXxGFsTvLoIETTmZ4lwhuMwS/1IS0ifzGEL3vAjnBO9+TuZKcf/SM
	 80ArMktJSdt52nIRJiRVid9UtfYA1w19yXVZJFEV2H9ML4oWGMBsDrKkZveusgTjMwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=XU4ZKJYx;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=hTH5Edqy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE59606A320
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 17:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CE59606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=XU4ZKJYx;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=hTH5Edqy
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALHUS3L747489;
	Sat, 21 Nov 2026 17:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=apa9byoloIqZmN0NGZL4q10l2t89QK7uryqIZ4uM8Wg=; b=
	XU4ZKJYxmFfRyHGcmbNdwkiuZbfcQbUx3IhGjENvp2+qtKvyFGbE8tAvzG2i+1aQ
	j1Wk7JvBepysWjEeIW7M3Oms7HXERCnwW9LSAOEd4QJ6sVgbqMDsW2MlSpZwiUlu
	0V7u+dFoJsEJ4oL2EOoDFyQxzyagMOFopqNHHCT6xHzvu+W9+DOO3MWdAfLNsCI7
	JUJnpQ0Ur7UmHsUWgkpqDfq5bZ5jDrBXFJ/5mSS2bJ2uPMExCXkoHmvszwZEqrAc
	wsjNYQm8NNgTYZ+nUtZ2C1AL4IicC/nQpJsVPK4GQZRBFNG1hA78P+ZaDuBRJvdr
	O5rXMp9abtA0wUVnZF5rSg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34ts89nm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 17:44:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFX414571134;
	Sat, 21 Nov 2026 17:44:16 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010054.outbound.protection.outlook.com [52.101.56.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j38rfpnaa-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 17:44:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lyz6e1jPdc74QjQe86XlvBUf6n+0dfRBngHP+eJ92m/jU5wOoZMDhuauAgm946c3WfWsiGhsXi956qDw6HHzYiXMb/euNd6psMz4tFOD3rSqM+olx/hO9ttLnT7zhUS/lHg69XcRpJEVbkMB1+FjPrjIR3axh8q8IvZSPPeE/5mLZlTxlWMeDTRxuzcOBwgFHkTWOI4Fr1auuqMr11+ulCZ0Uv6Oks/N/oON1y4ChWT6CPAiYrN6FXEA7mFY3Ma0hubo2DhHJQmxiR4Ifj6MA3skJozTd7v7AZ95srwYDYg08kjqSAPtrw9MW9PDH1YwVFj65kNTMQrAUXRoHyDA0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=apa9byoloIqZmN0NGZL4q10l2t89QK7uryqIZ4uM8Wg=;
 b=dmOSvjuYHXZmUsi41cQq9yhFnPvhiGDEnkz+2WqZ2ryTLbcqoYoRz7x+rc5bMH0DNa/0BnYwdi2q6hBZydL1RvusdpCmXPvFL99IpBuFIgdnQB+OidVk8Efyij0FIg8kN5H5DkV8tYRS6AI63T9vf8+cQH2HH8Ny13rvpBNd5zLsHGB5gb3xh095iJYAT9KAaSfu9oiSs5RHOgka23UvbciAl2IbUGTsFd+CJOc2zINCD6W6duUvRshwoAeP2B4kUewN98artEc4azJ34uqokq4vLneRUnoXYxKE7keabKOSWA4kZb9xK6mGXy1k1VS7Cw1Jy4krYSMO4nk6egbDmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apa9byoloIqZmN0NGZL4q10l2t89QK7uryqIZ4uM8Wg=;
 b=hTH5EdqymaGFMWmVkVkV8fKw5IH5PwsuX3tBgtXLUKPTq6lchoXh4Vax1O0vdYKI1oNNhA1LdQXNIgpfJFmTdv2z3S7bf5CtLyrebikD4PBM0TPSU3L34h49sg4hLiOhjXaSbkCUr2AuMovrD60RmbPC9AIkIOXz4fxhILfUl80=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by AT6PR10MB776698.namprd10.prod.outlook.com (2603:10b6:170:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sat, 21 Nov
 2026 17:44:14 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 17:44:14 +0000
Message-ID: <3ed06a31-d1c9-4a14-82e1-c66df4acc3c7@oracle.com>
Date: Sat, 21 Nov 2026 23:14:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 2025/2214] bpf: Dont take an extension for an
 iterator program
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150131.765556631@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150131.765556631@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0258.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|AT6PR10MB776698:EE_
X-MS-Office365-Filtering-Correlation-Id: 939312a5-6de1-4543-0eea-08df47f70eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|18002099003|22082099003|261009223027099003|261021121427099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261028144727099003|4143699003|56012099006|10067099003|261102124527099003|261102123227099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	5FtLo61hUG053x3AQEOGHE40wBtr/H99co0SQZSE4tniVkPDJZCQ1AOkqeF6bqLGmTH7VHdi7ZeMFwrJ4BESgOuJ8j7jycp2/jUGUvAxN7prm4WTOKrl9sBwmMw1vBRlok9lR6T/jmHZKTSfOVcsVCmOxRfEAvo+EE1fzKxVMaLt20B+OJeOCm8iYtHG3nYXdovStskt/lUDB2fCvVo3ekTWbWBVdrwctikKszbLvGVoxYY/fBJvCIhSwibgxrXgpH9o5uiKQHqmyQIG8+Kh9nP4+FVI2WF+0yrgDLt0CbaP1Q8Pc9t7c9ASwYAHpSM2ATriRM08THIfjv55hWawAoh185UcUQc1hB7cpgXfyKFQ2c93N3aBzUKPQy5iuVirxHy2UFhRQcO2eN9GvwJIa2PXEubqJxsLOZYZHDSH9xyvFKxCpzeDuJHqYbVeuhgubYuCkFTlmX5qxCzlo9zh7ZDNPu2/D86/RZ6HlAQlskvx8PnSnIPyK37n0sHfXRWfcrl7V2bql/mZCKRnjHkVbjwK0TQi6qiRoSm7P1eXFExNFC0bQGbXgPp8BxOiKfvR9rG27TapCT74Rg1+i9aKzeZGxe+q703Evo9fvzt1lnCgXFxiPny7C3gBBTz0boIF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(18002099003)(22082099003)(261009223027099003)(261021121427099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261028144727099003)(4143699003)(56012099006)(10067099003)(261102124527099003)(261102123227099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1FqNEJ3YmxjcUlNM1N5a2cvMWRNc2VlcWZqMEtISlREZURFSzNSaDIwU3VO?=
 =?utf-8?B?SXVXKytZWU0zZmVFOXVTcUdXRGxMSkpYcnU2Tm5nZnhJaDFyVDBFMjFnd25T?=
 =?utf-8?B?dy9ibnFDRWxncy93dExYSnNTZk05T2ZEVCt6TFZNM2w3NVBaUDNGVVlhaTNn?=
 =?utf-8?B?NVJ1RjFFcW4vUTlWMGs5bzJnWGJzbU9XNTNhand0QlNIZ1lDdnYwWDVsSnYx?=
 =?utf-8?B?UmIwSGNlazRveUgvd0hRRGZEWi9aUnkrN3dDTW9kOHBHZ3EwQXlrV1JPS0ZU?=
 =?utf-8?B?QnF4czhCek8xb05mcGNHY2xwY1pObkRaSmpoZmhLRGwwWUpJbVd4VHh4eDBD?=
 =?utf-8?B?ZC9LVFlrUnNDUEJRcnQ1T00relNuNFlOeEk0bFp3OWxkZmd5MHY0MnZzYnU0?=
 =?utf-8?B?a2V4NFFSa3hZdXFGeGttYzhLQ1lWcW5lU1JnTURqMDlwQTBQb0FPUWVUNGsw?=
 =?utf-8?B?OEo1dHVyV0o4UVBPQ3hTdmJxVDh3Tks1WHI5cmlrZkEwWWZiOFY3M1hSZGM2?=
 =?utf-8?B?cTRVbmJ5KzhZM1RCYlU5RlU2eHByYWR1bkZvOUY4NFJnLy9YOFZ5YkhrWEo5?=
 =?utf-8?B?NlE3aTk2YkQvQm9SaHBZVFI5ZEdacXhjWTkzR3N3MWh1eTRCcVlCaGVRVTN5?=
 =?utf-8?B?Z0dmLzdGdVRJUGhTb2ZSeHJoVjY1eGlzb1VFbmtYc2dPR2xiSHNXY0o2eStE?=
 =?utf-8?B?SGZqLy9IY2N2YnRidFE3aERERGlPb2FpSnc4TmE3SmdJYU1BeDI3Rld1VDJ4?=
 =?utf-8?B?dDF2Z3k1SCtodmplMGNRZVpycERJbXRoeGpPbGZTTHUzSmkrVHhWMHBCOUhj?=
 =?utf-8?B?ZzQ4aHNjKzdkMXRKcWlTY2NvemFPNzNRTTlQMG9PUFdtcXZGZ2MvUy9kRitE?=
 =?utf-8?B?Skx6dGpYZEcxa2RlVGthQU8vOGs1MmZRc3JFZlRVV0JVWTFGY2Fuck4vdDhj?=
 =?utf-8?B?RE5idTVyT2kwcEVKemNWc05ieHZqK2ZkQzkzYVFqTDRqdXVGU0pYM1d1bDlh?=
 =?utf-8?B?Zm9aRmdubjhFcWxTaUpLUmlZREFDd2wxcHFzVUFYT2piSXhLcGc2NkxHdVBN?=
 =?utf-8?B?UmMrRFp3VytGWmNzcVVVVVFsR2NPdHJ1dzBkNkhwZzlLUExIMDhUd09obFBM?=
 =?utf-8?B?ZlZ2N0RETldqY29Wbk8vemhYNmJxYVczVEw3Q1dhMzFsd1NvRVByQlRXUGF4?=
 =?utf-8?B?a0RwRFhvSzlEd0dCYm9NSm84WEJvb2ZaVTRGSjFNY25QTmttT1N0TkJ6NWhK?=
 =?utf-8?B?OXVrS0p6c2NjT1Y2SUVFL0ZVa2lnYjlUTnlHRHhwZ3Ezay9pZzZUNUdETUVu?=
 =?utf-8?B?TW9FWXNCVFd1YzBJbEVtbElGT2pEeW52ajMwN3lPN3E0alZBM2tOZ05Nam9S?=
 =?utf-8?B?V3hHWlRaSkVIcXgyVG5lS1c5QjhoSm9XWXRzRVpoWWdoaW42aHYzMXprWVpE?=
 =?utf-8?B?WDRhSW5GRHdyUk5NVzdqSFIxcTZxc2FGRkFCVlRIcGRtTTBhZndyTy9IWVUy?=
 =?utf-8?B?bGtWVDBKTGlwQ2Z6T2xiZjRDbGNtZXA2T3NqejVmNEZsZC9QeHVRdHNySDJL?=
 =?utf-8?B?K0hPOUplemc5Vi9taFB1UzlmUmhTLzI2bW5DZWJ2TDNYckZPYXhMQi9WbExT?=
 =?utf-8?B?WXlLaFFMNkJHbzZpSllwd2xQUkx3aDJrOXNSQ2V4R1JpL0JUdm01d3JWd3Qx?=
 =?utf-8?B?bHRjVyt3V0QyU2U3OEFnaGEwNDVlVC91ZVpCblBzdU9Da2xSZU5jQ29RZ2lI?=
 =?utf-8?B?OWtqTFUxQXIxaXBtRTRCakw0Y2I1dlJkTU9RanJHaStTbkdvcnhYN0gwMFRo?=
 =?utf-8?B?ZEEyN1JIMG81bjIxT2UzK2pPTFJQcGx6b05uTkZpTXpRZzBYbTQrbThoT0kr?=
 =?utf-8?B?VU5rTkE4cHpwSWQ0OTFjV3pNdHBmRHA0RkhudTlpT1RkelM4Q01xQnByQWh3?=
 =?utf-8?B?cmlianBUM3NGRWNwam5WSDQrdWVHdWMrTGVVV1RuSTZxWWR3VlpOU1QveXVT?=
 =?utf-8?B?ZXlVRDY4OE9SQUVKbUZVSnJoSy81ZVQyU1ArMEVNdjhQcmZVRC9DQ1o3cUxG?=
 =?utf-8?B?TnIrK0RzU1l4TnZBS3o3WGFxeW5kNS9nOXQ1MGluM3hoaDlxYy9kNDRiWnlV?=
 =?utf-8?B?NjQ5RG8rejJ5S2lwQUJMbmFEY0I4aHFUUE5wVEM2UTZLVFFjZ0NFN0JVQXdG?=
 =?utf-8?B?c24wMGNYbUtFNW1rUmh4WHNaTWdRWHpXcFRhUy9wZmdNcUFNaEFVVFBabmRa?=
 =?utf-8?B?bXZveEZMNU5QSWhuY2VIYVVuY3BXaVlBVDN4K2xmTkFZMnV3N0lyZjhJV3hu?=
 =?utf-8?B?TWdNZjFMS3BNem9Xc1R6aTBOdlAxVVFtSnUvZE1XSEUxOFIrK0FMRWlWNWdL?=
 =?utf-8?Q?K7nI/DgHFjdCdJJkOlEEIse7pePKs6dAGW2PL?=
X-Exchange-RoutingPolicyChecked:
	jV4z/Z7B0PVzsapH1JTn4LsAu80RWizd5j79wqIrvRWMky5JO6Zmwf1Hjf2Ee+XGcU1XHalOa1D4Q5gwWO1WuKZeC8A3c+FISTcmodZ9FT4Xpb9sDio1i6D+bbANebkcQlEFhSBrreN9wMLC0e6aXcYzGGI02nbxBAQ4khOo6BX++5SO+FJFovql+yT9D2/+Ci3BdzC/w1k+1RcUmwRgPNjPEAGPbBmrcT9v6yEvPxae6H+xp0aBGLTu3MGfwrUIfw3rOOQvl2sjc4QlKDsbUChT/7ALheVuG80P+NqunFX35V8vCVIyuWJ8NRnM9Uopb/F09GJWyj0p7ABJRYGhYA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P+HVKmuGHb21odP5ZeB/m6wbLpMWKoa5KzxrurtCdbHzZRUb8dgiyo+Tc4yYhYXCyX52nAJGPoc+24646EmngYa5G6IIBiwBfLrb/FUhLch2nK3A5KH7Mk7GV/n36guPzUU6jzblpwSmOsI1PSKBkShkOilzjcz/JBeX+95a9sPFgb8saoo4DtIliHg5hDA67rzAl/o/GGg7Z0vi6w325rVhXXs7GZCFHFq8vAYoyBhfB9TfvtKf3KiK5Y0Vj6uo6+9wmqpJ3PWYzys58MW5nJbpAz8WWQop+vf9HtEwRKqXbpQ8gJhzUHZkVgp7trlQduCEpQstxsmYOQJygUJDFCz9/Ok75gmbhmaOpsyLsPxJEQZp6pTtSxI48qYaWwF2+E/bPz8az2Nbjm6NWgtJEXg+5fOpaREm5TOadsA1/8kxStHrvk3S3fEPgfu012F21ukYIVCEq9edK9v9hym++7UXY3Jf1o0jkgT08QFW/qSqYnidqWNHUBDjJSmNuDxjyJzFRQ1xfr1GEwCYpVTSCu3u/pklmU+iJ/vnBjiuojxg39LywezinL0e+bwBaa+7d62dLUFoL+HTzbAvBZT/kNi6SyNKi46EYxSAs9BDz8s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 939312a5-6de1-4543-0eea-08df47f70eff
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 17:44:14.6260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RxpoI1YI05vAaBsPoskvPeKsYD7BqLqIVMeiV0TyyhEMmUeazAuQeoXmVQfstcaVb2PGqrYphSCKXJN/HUj07Msus3DGb0EmoUlmTpv1j8FHQ964rOzF8db7zJusU4HJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AT6PR10MB776698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611210070
X-Proofpoint-ORIG-GUID: gthN3friZ4q6xWdXkabA4wBviHdII8Kz
X-Proofpoint-GUID: gthN3friZ4q6xWdXkabA4wBviHdII8Kz
X-Authority-Analysis: v=2.4 cv=YP8KWhGx c=1 sm=1 tr=0 ts=6b01d871 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=pGLkceISAAAA:8 a=maIFttP_AAAA:8 a=VwQbUJbxAAAA:8 a=ebi5sSK-EAb6qiN28iQA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA3MCBTYWx0ZWRfX7L4NAt5Zy1qL
 3OE4tkFPPyNTLkY230nROef4HogxbbvYjBW2j/xZxFpIWMwQnNqjQGbXoJfSps6t2x6eAf3wrMC
 WQ66vrqtHSJDtU1Z9MsFYdkgzcmgJjOA7DVzz/be2CVzx1dEQtn4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA3MCBTYWx0ZWRfX1RC6G8C2ZcKG
 qi83Vu1+ayejz/Hs6QuHbfPhm0iD2za9hKEfVU66Js+/b/OXnpUIxMljViKDYyTY/En3sCmLFKq
 M4kgR6x1npzOmIog1zNIHHteSu5DxguZfbP2MJjdLEAU4Sb/LuBg/7BDUzpftnT9OQjoYft8z2d
 XXXSw6rIa2QLcsmGwIODpTFtX8FNfF2FgylzGRZdwrQKwvtIprNeghbQGw7CvEAF2nstLd/yszT
 UKD5MuEvrIYhyme4ICoMap6pjRhImae6yBX+l+zvbDizkr9F6/Xw3VovBdMgi0OuBf/arEbzBqP
 OfDicXHkhkjtKLT3/Pffo7ELcq4W6jZFFFLf67sN/91tIogKLZ6OmqSfmyrCdj47mXFLNOQ/fHr
 ahKpt3GEj8+GlXVGipsSszczdq+S9NMytdd0bBnV1T6sP0XmAlyvKQVfEQMaOKUEox8iOtWRBOL
 IbV/9go++HmN9IsJMdg==

Hi Greg/Sasha,

On 18/11/26 8:31 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Josef Bacik <josef@toxicpanda.com>
> 
> [ Upstream commit 7cc639dc45c5d3b69acb2a2fc834e9eec51e0214 ]
> 
> An extension inherits the expected_attach_type of the program it extends.
> If that is BPF_TRACE_ITER, check_attach_btf_id() hands the extension to
> bpf_iter_prog_supported(), which goes by the name of the attach function.
> For an extension that is the name of the subprogram it replaces, so the
> load fails with -EINVAL, unless that subprogram is called like the function
> of a target, bpf_iter_bpf_map_elem for example.
> 
> Then the extension gets the context of that target.  If the subprogram
> has as many arguments, it can use the key and the value as buffers, but
> how far it reaches is noted in the extension, where the test of the
> iterator link does not look: it reads and writes behind the elements of
> the map.  And the id of the subprogram in the BTF of the program is cached
> as the id of the target, so that programs of that target which are loaded
> already cannot be attached.
> 
> Refuse all extensions here.
> 
> Fixes: 15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://patch.msgid.link/20261017163745.3341787-27-alexei.starovoitov@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/bpf/bpf_iter.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index b2ee45064e06a..d7345a3eda04a 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -335,6 +335,13 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)

^^ bool
>   	int prefix_len = strlen(prefix);
>   	bool supported = false;
>   
> +	/*
> +	 * The attach function of an extension is a subprogram of the iterator
> +	 * program that it extends, whatever its name is.
> +	 */
> +	if (prog->type == BPF_PROG_TYPE_EXT)
> +		return -EINVAL;
> +


I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this and PATCH 2031 add -EINVAL returns to
the bool bpf_iter_prog_supported(). They convert to true, accepting the
target-program case at this check instead of rejecting it.

kernel/bpf/bpf_iter.c, bpf_iter_prog_supported(): (Code spacing
adjusted; comments mark omissions.)

5.15, after the follow-up afccf8fde60a:

     bool bpf_iter_prog_supported(struct bpf_prog *prog)
     {
         /* ... */
         if (prog->aux->dst_prog)
             return -EINVAL;

         if (strncmp(attach_fname, prefix, prefix_len))
             return false;

Upstream (b83bacf2161d) uses an integer return type:

     int bpf_iter_prog_supported(struct bpf_prog *prog)
     {
         /* ... */
         if (prog->aux->dst_prog)
             return -EINVAL;

         if (strncmp(attach_fname, prefix, prefix_len))
             return -EINVAL;

The 5.15 caller in check_attach_btf_id() rejects false, but -EINVAL
becomes true. A target-program case that previously failed the
name-prefix check can now pass this support check.

I suggest: Return false for this rejection while the helper and caller
retain the boolean convention.

Thanks,
Harshit



>   	if (strncmp(attach_fname, prefix, prefix_len))
>   		return false;
>   

