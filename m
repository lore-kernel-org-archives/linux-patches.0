Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795172384;
	b=ypPoAKnVN1i1wBPzayjzwatWke5tXhvaaHWKTpezHhqXjaUR7FHWr/6qNu4L5njfgE8a
	 Hwrwz+EBxlp/KU6vS9Ge4UH+/nTgHkWRwMUB5YQe7TSq68e29CPJwnpniVY+WNmEXZwxG
	 /kaQS3qVigKALkOybE56rdbSP8ZyRl3f9vMa/cloKqFlQYjkRTLaT9MsrEeCe5LTRcvGv
	 iSOGdhyi4zH7ok9DhR7pHbLIQTUa1WIirbzgKsPHSg0dlBYjDMX6e0GsN451Ldeee8KB1
	 ERGwV/LQuhE0Mp4aACtHEClgEZdHLWdopsxTlPUHRBpZh3ywK1iJnAQ+WbRisuF/q+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172384;
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc;
	bh=kX6qAIye17tvHY17XLTGSkxC7jdH2dpRlum45+70N5o=;
	b=QSXstNHeL0JdhKX1QsOf7x+bWi92iO08FOxk8jAepMoIzfvvMNFVYixPP2pJkpDt7gEu
	 U4iQOdqi0QldK5ydI+Dn0cJZv6aM3eUkS31d3BQqDMSvn6g/ERzO5p0KnpPYLUPbXxvo4
	 56SDxr7u9j4Mrf1btd7ks4hcA5p5BwMOGIHIC1TuEeGqmi73dqKnESRGzF4XMTpV++lJ8
	 /4K9FJsOAUz6s+G8JUh6MCrZZNLsixp1/E75+KWgQE5vymAWYGzQVk/RrQoUdBqgSm6ed
	 0jE221QiBDm4NSXd1beHtPowBFOjqC39OVACWAMGpjWcK2J93JwW8ID57IMKmuONiew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=gtt+s9YJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=MPkmxnat;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152A3606A337;
	Fri, 20 Nov 2026 10:59:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 152A3606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=gtt+s9YJ;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=MPkmxnat
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK3ZlXl2333346;
	Fri, 20 Nov 2026 10:59:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kX6qAIye17tvHY17XLTGSkxC7jdH2dpRlum45+70N5o=; b=
	gtt+s9YJZlW22ts8GtiKSz+kg9TGSoONaycQIlfP0g+SHmF2MyjkzyI1yASkhGRG
	ujuBX/e0dv2mASxCHtCzG7k6HXcGJZ/B+LAlEBVIBBHaHuVKegl1Rap5a3uwZtrS
	GmcIU1V7a5M85WVdWOB3WRymFMBvMi6+zUBZsqvb+gq31bkUfNTQGg/kELrGam5h
	IAg82a8ZGO0/zvy9YqPleUYiJkQBO14oicFaHf8JomuGBsoVAaH4W/UxPHuJBarF
	lo84rKPAyOuoF0gL7vUwd5hkntP4K3qaoK+emKpHAm55zIk74+5p4mTo1KMv9Mzj
	URRw3E0HSrfCcqLnxjiEIw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytscepp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 10:59:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAjIKT3420982;
	Fri, 20 Nov 2026 10:59:25 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012049.outbound.protection.outlook.com [40.107.209.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2hksqdyh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 10:59:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KRsRZgySAEnMOw0z8oUSUOF7NJSxawIaGefWc1YuFad6EVaWEvbmMXlPO50osA25vOkuBToIOPBeBehuqoKP8+H1INSmLXS4GIzRtWR9eq4gP7wDkZy/Gl1i0zHcN722JgZzBN7GUsKOHprFbLMjWFwwX9bibPo8jzmw7ya5Pm6e0cAkia0eBnTXFRvG9sysrH6DmDVFAYB9edOYOxyZZTmSAPbDppCLb0HMaKCh69/nwfKAUfLaIfOhKTyxWZmQbtZ3BorSL/27WV7KFqmui37kBFOhAZOw1pgZjW0sv6Sx1bCjbLdqms3sQPdZ8K8a2XjWQWtNtgKrM19trnaxnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kX6qAIye17tvHY17XLTGSkxC7jdH2dpRlum45+70N5o=;
 b=Rs1NQxxKzLBaZBlZFqZjjOGRtr2z6o/c6nOiQuSGuiQaMU+Dg29UNNkduQ3kV3kJUdu9tmgOtkCzpAJ16+4c7G0Lw9OBGQRwORP8Sb4SOe0vyLBNUPyKmiRqhPmXzhN8DZ8OF+rGvJ4yizt3Vuh2KfOHoZToZbEohzNb26nyN+9uMyB2ZtCKMmU2XPlHi11/mtQ40lvytYGbMRu8fri6n6yseauis1we9ADwohVLdlF+nvk5KGEkR9XmJpmGCbGiEIoxqEkIBAR/UrVaVgb7kLNjPKXUHC6RMz139suAT3vDTAjVWry8I3wECXP6AHiitfbUOzqV5KA6Ku7AVK47yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kX6qAIye17tvHY17XLTGSkxC7jdH2dpRlum45+70N5o=;
 b=MPkmxnatqEIbzgIKJv57Pf9zZmkyDh7ySixy+FBGJ0Ms2UWyp3d27KYWvOGGwAx/mUT1/Xc2dhgQZ+/9cYuXiZce82ob07OUYw8bdWeJs4YohnfRSLjq2RZuYK3ICzBPvuROlpnLg9XSBFDJl39msAvJYY0d2Xv4rRci80euiI4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA2PR10MB4779.namprd10.prod.outlook.com (2603:10b6:806:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 10:59:21 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 10:59:21 +0000
Message-ID: <e454c187-a5ac-4662-a2b4-d186ad3777d4@oracle.com>
Date: Fri, 20 Nov 2026 16:29:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1363/1756] bpf: Add show_fdinfo for perf_event
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Tao Chen <chen.dylane@linux.dev>,
        Andrii Nakryiko <andrii@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150103.535221836@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150103.535221836@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0100.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::15) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA2PR10MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: d1fd1032-226f-4ee6-87d8-08df46f55495
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|4143699003|5023799004|56012099006|261021121427099003|261009223027099003|261102123227099003|261026140227099003|261022105027099003|261022075727099003|261028144727099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	mznWetrxzF0jRa+zVaEvMAxWiP6xgrjwxgggplzAAEQHVR5R8Xwr5i7+2pPuuhgitF0MIBkqX0rn36FUtfD3wLquEmzamP79yeXwbDvCQrl0JJW3mfBQkJHF5yMvdl6nDdweJZUSeB40OKsz+urZIAarSNbVp7j8IhsAx9auutP13hWwHQB+sjhU1lDCPXaPrJQbipF/AcKD3xZ++rljAjtR4eqNKcJRqDFvJ1IovwnelOvvhW6Ay9HuOjaJJDHRMxbQWOVIMzs1jkIZflfrJlV8cuEtjurjnlAXdEqXHln8tT1CEBta76lM32zqzgPDIl0qwrx0FZN8b/czZfVJRpqF5SosGMpJ4J5RasOHaXnxfaF/MJStxS/FNTochTrEVaOv6yIw49WWI7VfHeDa9FCzfhp/y4TDVbmmLMPyDzPJfJXN+Rpf5EJTbCv6wQT43whS5emGRfYzwYubd1YX/eh1ar6BV3cQC1NN8ErJle+pjmUBfgvMqunCrvL+O2W58tmMgKIoHrC4Ns1jKOBBvIpuGHrtJwXDC1OhqzY5npref+7KlMBkKMtVETNRUjS4omavcfhdJVgBa6uX+P+4iuKfpEJmZAq8vzvO34/gNmHTkqX7BXJ4NWbyKV0ohR8NGdohBE8USCYS+HnzNmU81YytGbUZ2/tXVXUN9iw8U3c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(4143699003)(5023799004)(56012099006)(261021121427099003)(261009223027099003)(261102123227099003)(261026140227099003)(261022105027099003)(261022075727099003)(261028144727099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUpUNklTbW1hdG03RFpqdWxOcDZXQkZwbHdUL3FVcFdVNElJNjcyNW42NVMw?=
 =?utf-8?B?K1RDanJURmNrSEp2S1BKLzJpbGdiVHgvRlhkWWcxTXdoUldCbXM2VUR1TmlD?=
 =?utf-8?B?clNJeGVTQmJUa1VtbC9RUmRKRFFHUUt1djJ3Z2Jxbjg1d0lQMEpzaDFKVmMy?=
 =?utf-8?B?TEkrZmlLSXR3Yk95dEhMNjI2R1QwTmxSSm8zQi9neGpmb0l3clZDWDFKVFN3?=
 =?utf-8?B?WVBMVDdRMHFobEFyRE9nOEdRSFNuZnNRSlZiRjdKMVpuOUNESS80RVhWVEpD?=
 =?utf-8?B?OWVURjhDRjd5MDQyYnlaV3FmSWhwSU5jSk9xamluZ2ZsSE96WjhaR3FjZ3hi?=
 =?utf-8?B?RjJDOE5rdks2MHlGNS9xWGs3NkRueThENmJURVVjUkJjV1RxMm9lZ0VWWnZC?=
 =?utf-8?B?OC9YcXVVc1NYMXlTYzd1NmxraTFaQ0k0enlOTktnblAwd1lJamhkb2YzMnJ6?=
 =?utf-8?B?NHZPOHY3U0lqWWh2NmV3eXp2b09yTHpIT0dNQ3h5N3JVRndHUTZSUDBKWXZh?=
 =?utf-8?B?TmpHQU80M3hDS2VNSzBibXhLVFRXaUhUWEhuWTdidk9nR3RSOFZvQjVDV0NL?=
 =?utf-8?B?MW5EZmZpOS9nTVpiWVV6Y1hodHVUU3BTTCtMWEZzRWVVMzdvVDV2TDdIWjhH?=
 =?utf-8?B?c1lQZmR4Z09Fc3NhelJJOVU2WUFoMnduMlZjOGxKQ2g1QW1RNkl6K29rNVlq?=
 =?utf-8?B?R2lQbHdKZ2RlTGtKR0djLzVEMkZRWWg0TE5Ua0pzaE5DSmdvMnZkZVNKNjIz?=
 =?utf-8?B?QndwL1ZLbEpiMjdSN3ZLR2hrS2ZiVHY4ZVJEYjZBK29HSWRoVndZUlBzcSsw?=
 =?utf-8?B?SkJ2UC95TG5CUThKNm5GM2ZURDVqN3JsLy9yYkk0RXhJZ1hZOUpqRUVDSC9z?=
 =?utf-8?B?WmZaWUUyR0hteldKVjU2Mnd0c3M4cFlteFhBVzBXNkpvUGZXcFZoM0R4UEVv?=
 =?utf-8?B?MkZLTWpBcmhpYXpQWDNFelRRV3BITzJiZ1JBdkpMOGZUZE5Bai8rclQvMXl3?=
 =?utf-8?B?RFovQ2dVdkZEUFhvY2gvbWtwOEg2NUdyOVNuVmpldmV4VU9SaFY0K1hhbTJ2?=
 =?utf-8?B?Mm83bHMrQTFGc1pIREk2N2VXL2FEWjA4SEZ2Tk1SZlhnSkFjZ0prQXlDZWlm?=
 =?utf-8?B?MTNTdEltamdvOGt5alNFc2pyQ2VQZGV3cXcyQ0txOHVHVVVtbGl2aWVuTHJk?=
 =?utf-8?B?NXBvRktLN2duTFRnSUFBTENjRWdCNnBOSFljbHpxRk5tRW5TcnFscURISWNO?=
 =?utf-8?B?QUx2QUN1a3dBcE85VU5ITEFUUlhnQmhpK1E4eEoxYklvaVIwcmFsMTNQVnBi?=
 =?utf-8?B?VThVaWJEVVVXcFdVcWpiWTdlTVZ5TGdaZ2ZZVkhkMEQxbVhQaUpSVGpBbFg3?=
 =?utf-8?B?V2JUdVFpbGljWVBqNVpaME9GYmd4T2xzd3hCR1cxcEVwVjhZeVl3NnNheXp3?=
 =?utf-8?B?aUJ1Ulo1dTlNTU1kb1BwR1Vya2ZwTndmR0V3Y2VXQUhwcTd5MzNNRUdRbEdN?=
 =?utf-8?B?ZGsrbU82SHI4d2ZRY1ZsMlM1Sy9panVoanVMd3JzMEZqUDF0SkJabi9pUVJO?=
 =?utf-8?B?SE9hMHBJdWJSSHM1S1ZnRTA2S290YU1OcVZBdFdKMUZmR2F5TkpPNUxIVkZI?=
 =?utf-8?B?K1dJdXJUbzlTdmk2b0g0dUxmZkpIU3U3cjRtb3lvMHZpd1dQeU1IL3dhV0pI?=
 =?utf-8?B?b1hHZ2ZSYU4rVXBsT0dwR1BqME5tZC9pWEY0UHd1WDcyaVZFSmxCdDd4SlVI?=
 =?utf-8?B?b3k5VEVYZGNDQVpFcEdJR3J1aks4VmxzdkRBZCtOZVNGZy81S1NqM3J0WTVv?=
 =?utf-8?B?Y0F5NXVTNnBaZ0V1VHFiVktMd0lYQWVTN0gwd2VtRVZEbDZWSmlUb3VVWTdh?=
 =?utf-8?B?WmZTSUVYaFpGZ3pIKzA4Z2ZYdlhmK0FWVEszblc0aVVSVThwVGtLR09zcEV6?=
 =?utf-8?B?cVhlaERVU2J0OXB1YXV2OVM1ZWU5Tk5KMVhQdWJVOUFhcm1TTmVESHd6dFZh?=
 =?utf-8?B?TFJVWGZuaE4zV0JRWUh3QzBFbldDa25HV09PbGlZT1ZKNXNNT1drMHZhVlZj?=
 =?utf-8?B?ajFVNnplbVVud0JFcGRTT2dTTEpKK09SWHZlYzl3SzZlakE2SEZoZVh5dHRo?=
 =?utf-8?B?QzhYM3lLL0NYQzYyU1FVckFxbk0wZGptdGxTb29scXVMWXJxeUdERnBrbUVq?=
 =?utf-8?B?TkwzKzl0aEMxZWVLb2dpS0s5cGI5UVhrYWUyM0lHZUxrcWJudEF6dkI4NGJB?=
 =?utf-8?B?VDdaV2ZvOWxrTEpSSE9YTFoydURoVFN3aS9ZREw2S0k3Z1Y1YW1hYVhwVW96?=
 =?utf-8?B?VXdKS3ZBTDM2L3BIa1pIaVMrRytuMEZleFhNQy94OEdOeUk5dnBuRzlXQjZH?=
 =?utf-8?Q?GCnvZxObmtgVQ0eHKdSLIGDu2LiyC3pRgs9xh?=
X-Exchange-RoutingPolicyChecked:
	QemRPg/6Q/DnW/lHMkPgU37zxOd0Ycz61gDwMrnlXBfKnF4ZYSoYyfOYTXVy9ra4Yq5JVDtdWDFDUIqwMMrSigol8SLgVP5BVxVZ4ody/Xy/cscmjAGRewikYFC+UQ8FG5ym/LMb+rqvbn1Sh3zWrYkwLooYbFVkwiGkqSjUBfkNM352qQtD/YNZFonFoXxir1QEKSsclZzdAJcPLTyA4SySCDdgRv5uz/JF5e2H/c2Uba5w0pMXIfTHan6uw4BJb6fruAsilnhYuIEG9HskuQRV8lvD9kj6gjCFOxZazZHccyh3UvunVQpizBnJgx/ZNPUjMFCfsudhoHsp0uZbQg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B6k8QfnZN3zXcY+tPZvew3Wto73UHyzVoEQgHwLMqsuPajeAKchjrqMBt0Y0UZDRwm6hCyBAJn/+ZK1HYVUFZGov8hmGWnHJWsjP7EusVd7thQkz3k5bFTZhygkEOEgtk/lM4JO2gOVWgvpHCU/NWqL4DmjozospRXJN6Q0z1WkwdXnknVW+poph2bhvJCKh0loki/j3uqM2Z2QwrC72Vseb5ZAYe+mUnn8yCqOoTbO0+X5Qgt1EumfU710LRF1IcYyPgc8ZFaofxo06Rhn5P3y+WKyD5ElZKhyAeMCvLRNJMVdj8IuHOlsAUXpQQeHOQ/MTVpuUVUleWnQ4SILiiWeGKTg2V9pnQQjRAnXdOvqA/jRUmvi4uxDY1qODyDDMlkxr0k1ZOpk3gks7fEvmtTwBVnYTAe6XuSeDCUyGCiewGBKvnpBVfqIB2AVcr+xHtOt0eNr5OpIifTUMxVD0bmm7a44J0zbZeSBAlzgf81J8CO6Elr3lEztrvDzL6ehf6zoioqhCovow5erfPi6Owx4M532+txXGAlLm8DWZiRyBbEgJ6qivR0RDPTmBNYSqzrsneHSvqOv/Dnc4et+huV4uNMUi4SNo1VPs2DRqolY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1fd1032-226f-4ee6-87d8-08df46f55495
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 10:59:21.2276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uj+x34Awbm0iU0gCIFhZiarIvG7Xrj1W0iefftgyi/UorxP+qydZLvJQn9qg+j5HHkxF+pJKQ9T6Rue5VJxaS8uqwpRZR997ENMbRIKQK2qe/Kq961lYEsb9hqMT1Cyo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 bulkscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611200043
X-Authority-Analysis: v=2.4 cv=LIvz05W9 c=1 sm=1 tr=0 ts=6b00280e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=jLO2ctW4sKeA7a4IGuoA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12100
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0MyBTYWx0ZWRfX3VA6X7Zx3BFu
 gcIzMrSL6b/TNxMOWVeg/7Cl2jlN6OhAuA6ljzWMxWycd1QLvBLCWMOTMNApO+WeqV3pOq/S8Tr
 eKBYTMb/rAw1TVOqopBypGSXyx7k5HNRwTueL37TEIsDQ0Zqh3Hk
X-Proofpoint-GUID: WnLRk9uT-OCggj_87eUPjm_zEB_eNWZO
X-Proofpoint-ORIG-GUID: WnLRk9uT-OCggj_87eUPjm_zEB_eNWZO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0MyBTYWx0ZWRfX+VSc06DUrP8z
 GbMEqV4l/d8x7VwfJpzD6/m58RshlOTDDulNHosC2BmutIcwA8HniWLVUYufwkPGJAJcQxLApT2
 vakuV2dPPE9gIROAZSmWMpSmIk7qUp4UOwE9ACRrk2A9shYoTI3KGLvCjFOSF1w/osGt8YLYjIk
 i/N5XqWOdoUhsZQg3Lsk+IOpxuVfCivTp8torO7JH//fTw4HtGOemAzmcCM7RP/o7eTUHA6cZ9Z
 j0KlYJ2idFZ2QVd7wQl/gWCULGgzPiZ5TQMRKW8LKrJTG2j5uozr+MO4Q8Mxx9NN8GKdKLMcIWf
 rUzclpKytnzlVZpKHWhSgUKjrgXLB/tX8fJ9Z3RmeclxZlYi2F6SiemDqhzSnbzb16TFCGIr2gu
 cBH6NROeyax55jqmgFLXLfAaJm5KL8D1EQpsciOqocFBno2GXsh356B/vqR/ShaPpZYz/UzRlqM
 hDZ27SFVpjBweSLPzVEZr4Q509s6RvF/QGzWMaVk=

Hi Greg/Sasha,

On 18/11/26 8:28 pm, Greg Kroah-Hartman wrote:
...
> +
> +	err = bpf_get_perf_event_info(event, &prog_id, &type, &name,
> +				      &offset, &ref_ctr_offset, &missed);
> +	if (err)
> +		return;


^^^

I ran an AI-assisted backport review and I checked the finding
against the code, and it looks valid to me.

Verdict: It is a minor reporting bug I think, so we could address this 
later.

This backport adds ref_ctr_offset to uprobe perf-link fdinfo,
but the helper supplying that value still returns zero.

In kernel/bpf/syscall.c, bpf_perf_link_fdinfo_uprobe() gets it
through bpf_get_perf_event_info():

       err = bpf_get_perf_event_info(event, &prog_id, &type, &name,
                                     &offset, &ref_ctr_offset,
                                     &missed);

That calls bpf_get_uprobe_info() in kernel/trace/trace_uprobe.c.

6.12.y:

       *probe_offset = tu->offset;
       *probe_addr = 0;
Upstream:

       *probe_offset = tu->offset;
       *probe_addr = tu->ref_ctr_offset;

The zero assignment predates this patch, but displaying it as
ref_ctr_offset introduces incorrect output for probes with a nonzero 
offset.

Could we include the helper change from 823153334042 ("bpf: Add
support to retrieve ref_ctr_offset for uprobe perf link")?

thanks,
Harshit

> +
> +	seq_printf(seq,
> +		   "name:\t%s\n"
> +		   "offset:\t%#llx\n"
> +		   "ref_ctr_offset:\t%#llx\n"
> +		   "event_type:\t%s\n"
> +		   "cookie:\t%llu\n",
> +		   name, offset, ref_ctr_offset,
> +		   type == BPF_FD_TYPE_URETPROBE ?  "uretprobe" : "uprobe",
> +		   event->bpf_cookie);
> +}
>   #endif
>   
>   static int bpf_perf_link_fill_probe(const struct perf_event *event,
> @@ -3758,10 +3809,79 @@ static int bpf_perf_link_fill_link_info(const struct bpf_link *link,
>   	}
>   }
>  
