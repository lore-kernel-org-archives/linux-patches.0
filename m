Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795267288;
	b=iH7b4vD/q1fUb/bBl8hvScqs/w1f7dii23be6nasTQR7DSmRuzJY7/9/Gr8XJ3hPi/1v
	 oCsAmkrAKLTqLOXdF+BYG0nfpkOp/Vtqpk6B09UdlzpOcaRmFHsfn9VdSteiR9rih8zq/
	 LhDufMLxVWXdc231Wzpu2Xpymdyk18NN1do8G4NPJTdyYNbdtFaUbTrfR7d5phqGzi+Ji
	 9VlkSoUOVOfTsrzQFiuptrQvuUOGriFIWrpMM64Qm0T0icU6vkL/T/FzTynUEOMMDLIZB
	 OgynBkpQ8GC9jZgvDc0uAXNc+Bo0J5eo6KXD09GBc07s6JMHj6luuwLt1Vv6xk1URiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795267288;
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID;
	bh=IT070gueYR/Y9PREj2c4oU8jX0PUaVcNMnllrBSw+R4=;
	b=DToRHUya7gyBbLyYp/IxF1fLpEbXeLEkSNKrlidiWbzO68eS10j/U10viz7fPa7HNona
	 hkmJkg9PVSB3/K+bjm2MW6AA6tJYVv7cBr6OuuXFTm16bNF5Yt5rgKvyJUlMQEDuf0QAf
	 KHJ9wSdGsHpJxqzTjjdR4ID6MyjISJY+XXf3ot15L7XAjKTs9eiIeOUCYO6xuL4nSrP9E
	 Z5/C6yz32NJUdLW1Jp9flrg0bccc1aHtKrLoPrfS13L6xupNKFu0yj48JK71OWAg9dg2f
	 MpebfXqWYL7Q9+6k4ad22XjsKznbWxVbQUfzCFeIzsYDdjeA5q91Zti16khJ8Iq/oIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Ym0KIA7s;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=HVvnJhPU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189C0606A32A
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 13:21:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 189C0606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Ym0KIA7s;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=HVvnJhPU
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALDEm6s2790072;
	Sat, 21 Nov 2026 13:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IT070gueYR/Y9PREj2c4oU8jX0PUaVcNMnllrBSw+R4=; b=
	Ym0KIA7sWFE39C82gcTvxaRnCLDb7fClCp+03ICFuAPj6zMR0ZitbW1fPS4B38AU
	g7c1bTIonl54xvE8K6B6taHgXpxwpdIokqzrwaRgPwX4cUdqeJfUMe+jwArZZ6QB
	XZELFnoSNHM84Pbe+sUD1Z59AfgM5yuM8WdA/iDmywL0exA1GCRHTkI2HUxG87RC
	zeThrBovWQTPs1qtAoBDjGO8tlZlUTuHAeKz2hX61TuHabU/urFQuwX4Ff2fgM46
	GGVY8L5jB1h2LKrVtrnICDcLzdB+mPeV5n8jBAaFZEDBZvsgg9nIoKiU2Cq27ncZ
	h80clo4OBjTuFiptdqSwbQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t7g6e4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 13:21:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALCHrmM252324;
	Sat, 21 Nov 2026 13:21:07 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013060.outbound.protection.outlook.com [40.93.201.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j38rfkbr1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 13:21:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7sTnhu/p8RxwYqtlf26sDNd4S+bY2Gu8CaIHLC//CSjQAfBBdtpmvOxLahnUImDpGYTCNo/ozCE9UshUKwQ5EE1Ez2N5vJ7dLHIURmouH3FRlO1WzSXWVe1XINoaySDFMDrTnAmwV3fQzzNKnoMhI5ZE4stR6Fm+w5f9GkIr1V8bRqRJH49EOe1LigGiL/Csd7XkCvQX7NxrxCtoqkTCry61Y/ypBabYxBggKxd5hOLSREizkPj25HCmqZxYWOVtcSA7QwL5bASUBgV9CASjhvoXlx3oEwtFUlbM6BgBv2sNv3lifWhgKBdKcHdJjABz1L6gZCC0QJF2ht1HVcI/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IT070gueYR/Y9PREj2c4oU8jX0PUaVcNMnllrBSw+R4=;
 b=LS39wJIH6wvNE4QwHxfgWh7o7ILdtnt1DQrzBlpTUJN/C7U26GT+V+5rHOXKGTG8bWunqmN1oqr/tteyP9KsKWHYCSea2UR6TXSZhtPRtg2Jog5pOE14KpjpkkRwyynDVY9OuSBmGxqaIHX3Qetp6KoVwpYREhjHNfeyfpesYxLcn862qUrmDjdVnVZ96CNwa1g/qVXGColmTYDDHSNVf6TXhEz+beXMhTxxWnd3KgxqeCMo8kF6L1UnBJIiyI1w1yBQLZ5yg5mJfBS2gmwUG06W2RGJOy2gJCORyZYi17WQBcUsC/LdFG8813lj2/o+yFJS41bNWl3OXhWj18Xebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IT070gueYR/Y9PREj2c4oU8jX0PUaVcNMnllrBSw+R4=;
 b=HVvnJhPUTYbAyguaj4jlP3+uqzIC6EyqKKOADDQehxwmgSsQyFGdOS9KLLtBjwtbhHdZlWaXql4m0DthSbBvLyJTVDcALr7Ib3XX/S0OnxReKrKEUTKXD5jeFyxbBOeQkwp9p8fXbbZOO9TtebWWsBq2BQrO77pOY1njihw0aa0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CHAPR10MB997746.namprd10.prod.outlook.com (2603:10b6:610:2f3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sat, 21 Nov
 2026 13:20:56 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 13:20:56 +0000
Message-ID: <eb5fd1c9-8fc8-42e0-bd1f-f6d180ec31db@oracle.com>
Date: Sat, 21 Nov 2026 18:50:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0600/2214] ext4: dont report delalloc data as a hole
 on indirect-mapped inodes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Alexander Monakov <amonakov@ispras.ru>,
        Jan Kara <jack@suse.cz>, Daejun Park <daejun7.park@samsung.com>,
        Zhang Yi <yi.zhang@huawei.com>, Theodore Tso <tytso@mit.edu>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150034.962331414@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150034.962331414@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0177.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::13) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CHAPR10MB997746:EE_
X-MS-Office365-Filtering-Correlation-Id: cf179476-2f9d-46c6-6d5a-08df47d245f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261028144727099003|261021123027099003|261021121427099003|261102123227099003|5023799004|4143699003|56012099006|10067099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	833V+RMlpS2a2oRO6cdnZp8K6O1QIuQkdOXpjerwurWZ58Se86co23Dmu3rykHoqCc6U9YI1sYOcYHYEiVPNBGnlDOhOhu/XKf8i5o4EwSI4jDsYoTY0lUax1jfTaokxeUkxR1y7mkj1lW3+86RCQtf5MQLl90UNVbRjPci0Fg5A+stUXECEXY7xh2RXkoJsHik8PwpcKyxJTp44IGZHayxdrHZ8mJ9A7PKHJ/cJ7pcUZQyuKbIWa2ECXrUTvIWd7sXst7hs6RoVmBp+C17eda1/eSb5Anan/Sw3buL9XeLJ7iWCNHOzU1k8KcCXCwtKXtfoiSVG1ZyU8XwgBU7OpYniyIFVpW3MpuCaU8FEEDQt86aoxCJVJw9Ds82oCx9CrRi0B01b6UMkw2s7fuvzJT6GkVXurCnS/8pqTUJ5VcVLyyRZz5OMeiz1s75+8pVbvSNHEgAQZ73GeKZPgS6FJRajNTP4MKjHdT+3selJc4vE+vmwhBMea9/fLq6FffStDfXmt0Ms5EB8ktlfoIO5UFAD5lwbiKCxZ9jE8OiEJ3MMBacWK4O0meX9OflqLy3C7vdHJmCN0jevjJnk4upChYaEk+0nDnWhWOTcK57NKujeEYrFP7d1zBlgrgfvwwnO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102123227099003)(5023799004)(4143699003)(56012099006)(10067099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmlmMVBrNHpnRmx4RXQ3emhxa21jRDFyYWdUai9Kb290MXppdVdPa0VkczdW?=
 =?utf-8?B?aitsWm4wYVQxS2x2QWFXZGpoY0YwN2NBVjVhQU4rbzY5UzJxNmV1RmdxaUh5?=
 =?utf-8?B?bDJWTGtyRHovU25wSU8zSFVGZWFRZURhNExCM2JtbENxcXRWL25qZUxaTVNx?=
 =?utf-8?B?ZEhwUFYxNk00UmpXU2VvSklQWXkxY3VaNEFreGk0ci82NnRlYlIzN3Rhcngy?=
 =?utf-8?B?Sk4vSTlob3BONWhuS3pWeUYzcEFIa0JwRG1aMnhBZ215SmRWN21FMXRZaXoz?=
 =?utf-8?B?dE9jNklyeE9ETDZ6UUppY2NZRnpqcWFrRVdldUd2RmJMSGd6bmxXbUk5dFhS?=
 =?utf-8?B?bnk1a3hhY2UwQXFQNHl1eDhBaEY2dEd5WE1KcGJ4WTJzdzJDcFZDMitjT0lD?=
 =?utf-8?B?TXNsek1HWVNmUUdsVzZkT0haQm12Smd3dXN1clphSlpmcTB4Y2tkQjlNY3Ir?=
 =?utf-8?B?azRHSTJBM2ZtUGgrVy84SXRUNnpxZDUyRS9iSGQzcit2MTNtV1lSNkZqdEVK?=
 =?utf-8?B?R0tJaHhYOGdBZUd2Mjl3L3E5c0JUcHYxby9RUi9oa0p3NzN3NjNuQU1OQm1m?=
 =?utf-8?B?MHhkVitXbWpsak10cHR5b3poVEgxUk81WmZBZEdxWWg2dytJdmVaS04yTG5U?=
 =?utf-8?B?UlpManUrVlJnVlBUY0hVZGhJK2pWMTY5b2wzSWJQcFA3UlB5VUN6OExkZmVo?=
 =?utf-8?B?a1ZEWjNFdXRQeW9meWhlKzY0N1I0WlJGWEs0b0k3TkJ6Z1FaYXBSaFQ3S1I4?=
 =?utf-8?B?N3JwcW11cHp0bjVvazJGWndmZkxPeVdTbnFBcTljZDY0SStsMkphSUdsbUFJ?=
 =?utf-8?B?WVN1a2xidlRnNlhKd1RpYjduSzE4TXQ0UWRQWUJNWFN0VmRLWTBxZ1k3UWF3?=
 =?utf-8?B?azhlaUNWdkFjdXZpSUI4d1N2MlJyQm1GcmxDYUMxUTFUWFpNRG1iWGtSZUhM?=
 =?utf-8?B?ZGxKaElwMEl1WVdzVnQrM0d5YjFwc1pBeWxWcUFpdTYzQTF4UkdaN05WZDNw?=
 =?utf-8?B?amFnY1dmcDFscmFMSHpXVVdsT04zNDZJaEVoT3N2Ri9hSDVQTkJieGk4cldB?=
 =?utf-8?B?N1pyWHpjUlNRU0RqVkdQQkVmT3pCdXBhL0hKMUdMTFhEcVExQ0VIYnU5ZGJN?=
 =?utf-8?B?WFVYaEo2eC82UElHV1hXRVNkOGVXWWZSZzJ5SXVrY1hJWkowVjJESWErQis5?=
 =?utf-8?B?eHdGcnJsTjZTU2JwQmxna3pNT3haTzVyT2xRdndaNWd4NGIwZjNPMFI4YXBi?=
 =?utf-8?B?eWZtZ25QUkpoNEJEcE00eWFQdjY3ZjJGSTBGaFhlNDNvS0tlYkZzYnJUbTFT?=
 =?utf-8?B?NHVzK2xsZmJYaXJpaDd1VnlpTVZBL0ZXanRCejlLamkrdGU2aUNTd3BnVE42?=
 =?utf-8?B?QktpbkliUkhkMDVmSlZRTFlVRy9EblRJN013RStxL1dxSlFPd1ptUThTeHMv?=
 =?utf-8?B?KzVMUWFTVzlkaTBKVkp5RSs2UlQxbVBzb2RlNGF5eXFtNWZqck1mYmVXaGJk?=
 =?utf-8?B?VG5GNWtFc0tyUDBjdzZKV2R3aGVMVGNsc05qWlp6bU84WTBmYU80YXJXREFR?=
 =?utf-8?B?UWV3aHoxSi9Ja2FMdVQrT0JFV2o4T2NuZFJyaXJpUEZrZGdlVDc5cDc3bkVH?=
 =?utf-8?B?ZTM5M3RNdkNQOUp1OWdZNldpZlNqZEF2Y1BlaUJYOG9XcDYwd0tUaEE4WDY1?=
 =?utf-8?B?Z1I0NjVkbGpSdW1PenBkWGNublJYaUU0aDZhWmVsQ0RucEhrT2ZySEVuNHR2?=
 =?utf-8?B?TFNuV0dEVDZsYUhtVm1acnFMc2xVazlzcEJxU1FzNHRDeEN1WFJGb0ZnYXd0?=
 =?utf-8?B?bkNvdFhVampTY1g3U3pIaVRDME5JZ2toQldZNEsvN1E1VU5FWjFCZEczdDV6?=
 =?utf-8?B?T3UyRFUwWHNrNjU5ZTkxbGR4L2tMUDc1NXdCK3FLU29vRUd4WWYwMEFCUm13?=
 =?utf-8?B?akZESmdPUmtTcmxjMDczdW5rNFhWWnJhS2oxYit1M2hxVFN3c0JpZ1BlemVY?=
 =?utf-8?B?QmlRTE94VUE3a2l3SmpYUEhWRUQwTGFIWndWZkVJL3AzazFzeHlDWTBEejA1?=
 =?utf-8?B?eUg2RTFXLzhoaVRreGw3UVFoa0V5YUdXMmFJdVpwNmdBbU44enkydGhqT1Zj?=
 =?utf-8?B?Y1lpTEVtRTR4R2lYMExsMjEzamo4cmhFbFRpMHZvVlVtN3VlVUY5Y0o3KzNW?=
 =?utf-8?B?T21EMGY3OHQyNkwyVDdtbXZod3Q1UzlxTXhIK04vemhwYlBHS1dhaENqV2k5?=
 =?utf-8?B?a285U0g2NCtxUVByN2x5SFZqblZ5MWFFTU5TK3lmQ0lhOHJSMkNpaUNJaWJQ?=
 =?utf-8?B?cnhXZkdseXVBeGR1b2lUNUFkSG14UzI4Y25sVk9ESnlFb2VQTzFjc1JTZkdy?=
 =?utf-8?Q?x+cPoVD1k2WKr8S5DbWppNO8bKOxzNKtfevK8?=
X-Exchange-RoutingPolicyChecked:
	d/GJ4NRlm79c5vSVTfjhbi2ammBLgz2PPHNvU9SWOUK+9ESq9Nrl8O3Q7ANBJvuDGU6Y30nFJ/dvAmMIbnHJrfdXNRRP6Jw/NN1XDF7KvlHFnhWKeDr4aR5JQZF5kbME9JJ143Wj7m8KW3eotTe2jH/EoAmLot+GoezJgljsXSUa03GyxKm/MaLZwLpRgzaiOMG/ecTCbTlwUIkEF/MKKWDKVa0ICfE25m5EOnuJbCRICI9fresPIudR3XpUE8Wmbio3ULdqKK/OdbGB1uBh3pjUVGHDhlojtR/h5SqoUdybzSga3DIcHCAN1ozI9cty+6luRfyplcxhXjb4GEY6aw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ylqEgv5L957HePOzpa4wlHaU9WtJnuweft65TEO8cRX0bQxKqIzTvg2Jp29EL/FozOtpeD0fFIGbOd9iTSKVy9m6ik1uOV22kjTiyt05NjUhPC92VxvQYTPIYQbK1R2CrAxYaut4SHbIU2SxcYRJ9dCmf5KpYtrPJMgBjXJ1VEyK/7DQA/o5VjdGfLyTd4s2qioCLKwBEHv6jeEcNftNLTsoksjjws1ksM4DCFCoQN16SiQNMEEVp2XU1wlm9/DY/xiUnpFsmqAKbb+GyG89u/MOokZO5pksS9Fjpob9UmGyND51oPznbkxfMi8qQfZLDCeh/+V/kWmR63b5D1mFIpdqVemcNf9VIca8ogaGyohdhNWTitSDgarlCNHmHoLbVtBd23C+/Q2TukYOOUcXUiauz8DenPdcZsd9uHJIO/zP8eRNy1/Ov0XGFZdaZJOXYplgYmmsP+xo5Nw1jCTO8fpQZIj9oFh7+pNeli/ZQhP8qEhRvh8YeNjyj/532oE74cNpfw7NM8uyEKP3TeFOmjoym99bmAesrKHJfeHTiCfHdMTkPJnpdRefEqVrKV4fvTsIFzziAe9EiGcqb7EXzHGqxtcxv1eT1f1dzzAYCW0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf179476-2f9d-46c6-6d5a-08df47d245f3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 13:20:55.3954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mb5hSiVcWDreWhj/g22jGNfmXBkTv2e4Tq5cPH2kjq/juBD3FEGkrKx3pxuO1zjOdOtno3Y0v8GXjE0nZ9Wf89bS2mx9D+buVgFjpsNkJprh653OOjXUiTvogGZ9p7an
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR10MB997746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611210052
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA1MyBTYWx0ZWRfXw1R+S+XnF84V
 i/8BL3nHinhi5Dbmw1+6/7j1ZmmbOW1++GlX3fwPRrGdSpQj0iIgZm2WMZFsrVcu4pwhIoHZ4lL
 2N0PASeVsLRd9EzItcQS8xSnwuE3GN0P8wEGtucJtPis+hTa9ypr
X-Proofpoint-ORIG-GUID: X9vWxiDz8FXo8BfyPuMcR-afhZYGJDqp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA1MyBTYWx0ZWRfX4REeli/b7yX0
 UqyjMZDBDhiquWtw/H3aBLVd0Pjru7JkSg1PlPMqU8sfkFCOjhRhmVyN1CppUzO7P6/pj9EHf2j
 Yu1LpLoqnQDgW2GGkYd3csLgWNSnOiL0Tln99UJ9r8ypcl7Y46xUEs36ljegUz3kmbmxiFt0i24
 HyQHvuS9FWs0MzEW6I4xpaPdfgjibQXg8AbA3MkcdWXJYaHCBZtHQtWSlov+vZHMg8NOVgaRaB4
 PnalfkU8ew1hooUH/6uV2b2dValSNJ31SFrHfrjUVg8iOl/qthqnlF0qYiFRqK1G7OvWQ/HseXl
 Oj2KjMmKpuE78mTs22s6XzeHBdn560AGHC4BwrZDyksD4XXAkV87ySKqIJCwMnzS68oot+KfnBu
 HscTPKN835bUO557glX3EdSf9LhTGX8CWu2yFEWJrVjVdtuL7UGATdxxtoaIeWRS50zroyWvbbP
 rDJf/ylfYi0VjCOXe7A==
X-Authority-Analysis: v=2.4 cv=Cocq4X4D c=1 sm=1 tr=0 ts=6b019ac4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=xjQjg--fAAAA:8 a=bC-a23v3AAAA:8 a=hD80L64hAAAA:8 a=i0EeH86SAAAA:8
 a=5ipqZoIu_wbsR-GaDK8A:9 a=QEXdDO2ut3YA:10 a=L4vkcYpMSA5nFlNZ2tk3:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: X9vWxiDz8FXo8BfyPuMcR-afhZYGJDqp

Hi Greg/Sasha,

On 18/11/26 8:07 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Daejun Park <daejun7.park@samsung.com>
> 
> [ Upstream commit aed43f47e1edeee1454eea86006a8c09480e5ed3 ]
> 
> When a plain lookup finds no block, ext4_ind_map_blocks() sizes the hole
> it reports by counting the empty subtrees under 'partial' in the on-disk
> indirect tree.  That count knows nothing about delayed allocation, so a
> range holding delalloc data that has not been written back yet is
> reported as a plain hole.  The extent-mapped path does not have this
> problem: it trims the hole it found at the first delayed extent before
> returning it.
> 
> ext4_map_blocks() consults the extent status tree before it calls into
> the mapping layer, so a query that starts exactly on the delayed block
> still finds it.  A query that starts earlier does not, because the hole
> reported for the earlier block already spans the delayed one.  On a
> 4k-block filesystem, lseek(SEEK_DATA) from offset 0 on a file whose only
> data block is at logical block N and is still dirty returns:
> 
>    N = 0..11      direct blocks                 N << 12
>    N = 12         first single-indirect block   N << 12
>    N = 13..1035   inside that indirect block    -1 ENXIO
>    N = 1036       first double-indirect block   N << 12
> 
> Blocks 12 and 1036 survive because the query lands on the delayed block
> itself.  Blocks 13..1035 are swallowed by the 1024-block hole reported
> for block 12.  fiemap loses the same data for the same reason.
> 
> An ext3 filesystem mounted as ext4 hits this during ordinary use: ext3
> inodes stay indirect mapped, while mount -t ext4 turns on delayed
> allocation even though mounting ext3 with -o delalloc is explicitly
> rejected.  install(1) from coreutils uses SEEK_DATA to locate data in
> its source file, so installing a sparse file that has not been written
> back silently produces a destination of the right size holding none of
> the data:
> 
>    truncate -s 1G img && mkfs.ext3 -F img && mount -t ext4 img mnt
>    echo | dd of=mnt/src bs=1 count=1 seek=64K
>    install mnt/src mnt/dst
>    cmp mnt/src mnt/dst        # differ: char 65537
> 
> Reconciling a hole with the extent status tree does not depend on how
> the hole was found, so instead of open coding it a second time, split
> the delalloc handling out of ext4_ext_determine_insert_hole() into
> ext4_determine_insert_hole(), which takes the hole the caller located,
> and call that from ext4_ind_map_blocks() as well.  All the special cases
> and the comments explaining them stay in one place.
> 
> Two things change for indirect-mapped inodes.  They now cache the holes
> they report, as the extent-mapped path already does: ext4_punch_hole()
> already puts EXTENT_STATUS_HOLE on such inodes, ext4_map_blocks() and
> ext4_da_map_blocks() already handle a cached hole, the latter by
> replacing it with the delayed extent, and consecutive hole entries
> merge, so the tree does not grow with the length of a scan.  And when a
> delayed extent covers the queried block itself - a race, since
> ext4_map_blocks() found nothing in the tree just before - the hole is
> now reported only up to the end of that extent instead of in full.
> 
> The indirect path passes hole_start == lblk, so the "delalloc extent in
> front of the queried range" case cannot be reached there:
> __es_tree_search() never returns an extent ending before the block it
> was searched for.
> 
> With this the sweep above returns N << 12 for every N, while the
> nodelalloc and extent-mapped controls are unchanged.  generic/225,
> generic/285, generic/448 and generic/490 pass on ext4 made both with and
> without the extent feature.  generic/286 and generic/436 pass on
> extent-mapped ext4 and are skipped without it, since they need
> fallocate.
> 
> Fixes: facab4d9711e ("ext4: return hole from ext4_map_blocks()")
> Reported-by: Alexander Monakov <amonakov@ispras.ru>
> Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru/
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Link: https://patch.msgid.link/20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/ext4/ext4.h     |  3 +++
>   fs/ext4/extents.c  | 26 +++++++++++++-------------
>   fs/ext4/indirect.c | 17 +++++++++++++++++
>   3 files changed, 33 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f8de0cc489529..d38abcf66621c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3734,6 +3734,9 @@ extern void ext4_ext_tree_init(handle_t *handle, struct inode *inode);
>   extern int ext4_ext_index_trans_blocks(struct inode *inode, int extents);
>   extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>   			       struct ext4_map_blocks *map, int flags);
> +ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
> +				       ext4_lblk_t hole_start,
> +				       ext4_lblk_t hole_len);
>   extern int ext4_ext_truncate(handle_t *, struct inode *);
>   extern int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
>   				 ext4_lblk_t end);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e6dbb2dfb3318..33624c68a3d75 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4096,21 +4096,19 @@ static int get_implied_cluster_alloc(struct super_block *sb,
>   }
>   
>   /*
> - * Determine hole length around the given logical block, first try to
> - * locate and expand the hole from the given @path, and then adjust it
> - * if it's partially or completely converted to delayed extents, insert
> - * it into the extent cache tree if it's indeed a hole, finally return
> - * the length of the determined extent.
> + * Adjust the hole [@hole_start, @hole_start + @hole_len) the caller found
> + * around the queried block @lblk if it's partially or completely converted
> + * to delayed extents, insert it into the extent cache tree if it's indeed a
> + * hole, finally return the length of the determined extent starting at
> + * @lblk.  @hole_start must not be behind @lblk.
>    */
> -static ext4_lblk_t ext4_ext_determine_insert_hole(struct inode *inode,
> -						  struct ext4_ext_path *path,
> -						  ext4_lblk_t lblk)
> +ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
> +				       ext4_lblk_t hole_start,
> +				       ext4_lblk_t hole_len)
>   {
> -	ext4_lblk_t hole_start, len;
> +	ext4_lblk_t len = hole_len;
>   	struct extent_status es;
>   
> -	hole_start = lblk;
> -	len = ext4_ext_find_hole(inode, path, &hole_start);
>   again:
>   	ext4_es_find_extent_range(inode, &ext4_es_is_delayed, hole_start,
>   				  hole_start + len - 1, &es);
> @@ -4275,9 +4273,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>   	 * we couldn't try to create block if create flag is zero
>   	 */
>   	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
> -		ext4_lblk_t len;
> +		ext4_lblk_t hole_start = map->m_lblk, len;
>   
> -		len = ext4_ext_determine_insert_hole(inode, path, map->m_lblk);
> +		len = ext4_ext_find_hole(inode, path, &hole_start);
> +		len = ext4_determine_insert_hole(inode, map->m_lblk,
> +						 hole_start, len);
>   
>   		map->m_pblk = 0;
>   		map->m_len = min_t(unsigned int, map->m_len, len);
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index f1d514c881a30..ea9abcc8fe5b6 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -586,6 +586,23 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
>   		for (i = partial - chain + 1; i < depth; i++)
>   			count = count * epb + (epb - offsets[i] - 1);
>   		count++;
> +
> +		/*
> +		 * The count knows nothing about delayed allocation, so let
> +		 * the common helper reconcile it with the extent status
> +		 * tree.  Only when the lookup really did find a hole:
> +		 * ext4_get_branch() also returns a non-NULL partial when it
> +		 * failed, and caching a hole for a range it could not read
> +		 * would answer every later read from that cache instead of
> +		 * retrying.  Clamp the count first, a subtree can be bigger
> +		 * than the logical block space when the block size is large.
> +		 */
> +		if (!err) {
> +			count = umin(count, EXT_MAX_BLOCKS - map->m_lblk);
> +			count = ext4_determine_insert_hole(inode, map->m_lblk,
> +							   map->m_lblk, count);
> +		}
> +


I ran an AI-assisted backport review, and the finding looks correct to 
me. This introduces recursive indirect-hole lookup when 
ES_AGGRESSIVE_TEST is enabled, exhausting the stack.

The new ext4_ind_map_blocks() path calls ext4_determine_insert_hole().
In extents.c, that helper uses:

5.15:

     ext4_es_insert_extent(inode, hole_start, len, ~0,
         EXTENT_STATUS_HOLE);

Upstream (aed43f47e1ed):

     ext4_es_cache_extent(inode, hole_start, len, ~0,
         EXTENT_STATUS_HOLE);

With ES_AGGRESSIVE_TEST enabled, ext4_es_insert_extent() checks the hole
by calling ext4_es_insert_extent_ind_check(), which calls back into the
indirect mapper:

     retval = ext4_ind_map_blocks(NULL, inode, &map, 0);

The hole has not been cached yet, so this repeats until the stack is
exhausted. Upstream's cache helper avoids that check. The parent did not
call the hole helper from this path.

Maybe we should drop the backport because of this ?


Thanks,
Harshit

>   		/* Fill in size of a hole we found */
>   		map->m_pblk = 0;
>   		map->m_len = umin(map->m_len, count);

