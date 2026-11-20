Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795163453;
	b=B6D1Z2uRcXFEzTO1wBQwnQecr9NzVrfBXWfjJ3HdAWlQeoZe3DADN6AgvGFIX8K2ZzR6
	 qY9Z32pp8t2QU/NVU9irFdTaouf/n88iOOKCUb1SaGXUbwyhsZYa3PLBi2X8iC7xV2Pre
	 M8DRqyQjgTiQcIiHUcYtrWjO9qlG3ofP58kVPsjixT/gucCOy3bbqXleJ/f2Pj5AiGFdX
	 e514sbpNK9xeNxxxELfwQ28TA0uoajy2Tu7yopKZrbWG10tUXOpxl1QrUtL2HeTqxRyCt
	 3o6h7IoK7QEb2UWnCyzcmVEQyRU7BInIzGML83Kn9iTKpKg1Vf/vHGD42Sb1ZuMGZ8A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163453;
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
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID;
	bh=Egr/B88YCuRL9SEMczlKLUcQMOzQN7+OewL8KALG0iw=;
	b=TkMaduW8r2kRKxfDwwnJuQyYP+jTlxcONjrz+coQtNiD+3WjFQV8BFEvLAzrX92uuQYe
	 7xpZbMbQ1o0yFqW3H86JwkRERnDEI3S7u1JI40xnn8Kz1mEKE3J/1TB6pHnDG88dANOtA
	 1FAaRCbwJO+oRnFo96acCWTCqTuwfROpy8G6PEqOMDW7iKM6gMQ1AadcJCO/P0buIPWZl
	 bGabsJFjAT6LNOkYJR8CwYTq7/89YxVDgHniHaxb8emjzmT46MMcx7Ajz2xsMJr88rsxz
	 iXct2xWUTIuUyazxTkJgsjux8VTtjrrCNNc/fDtZ2js2h+qhBa0EzDYO+rWcoY2THbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=hvRx4Ok5;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=q3jD9xHt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1289F606A32A
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 08:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1289F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=hvRx4Ok5;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=q3jD9xHt
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK4UOPC708256;
	Fri, 20 Nov 2026 08:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Egr/B88YCuRL9SEMczlKLUcQMOzQN7+OewL8KALG0iw=; b=
	hvRx4Ok562GRXrBTbIos/uGg6OMhVEoYlGWqw3ERsfAL6sUjkTQNpjMsrGJbwmwm
	USOgBGAXfJd+1feHwQl7bxDADcBlRSX3zPYeLfkt2zfWr/32y8gOBwm1bL8DzgTJ
	jWlVBZS11DQqIo2B3AKS1P5zN0KgTT/k5ApFplomx22dtF1KGoLhGMNVk9ck+1l+
	KQcDhK+0pRBKJ8HlG7Yno8/exQ2H2vUAGuIXXRuZhA/ZBki9mZYw/22VD6I2JcW+
	Ctk2Hf2G2lef/0UvEJtTLvcu95u7Htegi1DLDgYiUAAzWGDC62JW4BKzeaopkcND
	0uNqMz50g3nbEz1/zShWlQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytsc9th-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 08:30:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK7e5b6770219;
	Fri, 20 Nov 2026 08:30:48 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j2g8t5vds-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 08:30:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GgFru6XYxL0IZw5wbOOMBipVSXMhVhWQ7ON1sp+ZqfOLs4Lhw+bp8l0sdM5bnuh8Dtu7/vOK2h3rd7JH9NAZeC8Zi8Z0H3DZbMW0g1gZwS7Did17T2Dcytn65tkN1V95E8PTQrUBVYwVYhcj6G4SNXZo2+RTFkms+LiQQeciWMHtJrA3AF/iiNqpFj/QDd8ln/GcxM8cTpKxEJdFEZ6y7/5++V2b+sa/bcuErIlYjMcdCmBWQZFQjBl3Qt0rDOwl/JelZ2qXwf0GdMw+2SvC2m0IHbGD98YjM3tyHidqGjnOj16tzAAShRDYgnwK4+rAye9wqJwkdWbw+Sss/VfBkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Egr/B88YCuRL9SEMczlKLUcQMOzQN7+OewL8KALG0iw=;
 b=Y7IHqdoIyn/jIeBAlKNlLbJv2zyg/9EGQ5mzHDd0C0+QiZDqA6+KyM5IeOI+L5+9FZYUW46zetsIJweG5H5TaY/RM7V08P2oe6eL8mj1O1afsd99XI8KGoOYquILqDWC06osMWIOF5HeC9zbdCw3ioTtc+cbz2XgcfnMwRPbllLAZh8W1+Ji+LzCoEBaCicLJGtcXSatnoLWQ4nvZ1dV0l8Gs6u0imQnAApPcAa2RqlB3LCjUr4EMb+PgcDoioucO1ufqwdH5/59L9jQmkrwkzyebXUzdw8lm7Rsio03k++FxrpqQAUAJ2IvG2ulB0IThuoAXOfNWBtJjTETwdESEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Egr/B88YCuRL9SEMczlKLUcQMOzQN7+OewL8KALG0iw=;
 b=q3jD9xHtfw2dEOkU0TrJMNJZ2RCw9wH2lZJynzuP2h0Wz+nUylEJnXikBrKs4PtfKf0qQbs79gl5020zN7pNlNpg1GlnvU/AFZn9XEZH47EQmGMubxG1nX9vkFe34VVtAfq8y0Kn3Kykzi5XfyhSJmmHhWl3DxnYc6sxQc7uTJs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 08:30:44 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 08:30:43 +0000
Message-ID: <417bce40-3566-4079-8241-2704cce5f7a4@oracle.com>
Date: Fri, 20 Nov 2026 14:00:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0450/1756] Revert "rcu/nocb: Fix rcuog wake-up from
 offline softirq"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Usama Arif <usamaarif642@gmail.com>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150026.718525267@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150026.718525267@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA2PR10MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cec44a7-4ea3-4fbe-ae77-08df46e0912e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|10067099003|5023799004|4143699003|56012099006|261022105027099003|261021123027099003|261021121427099003|261009223027099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EOIa9+hY27B82Yk4xkvPFLINl73BJfFIIEUF5Mc6PtLI5q06mcRrNHniA8684jw9+O1IqyAo9/Ttgm/jf5u6Rl23q/9q64KXxQOYwToV2a20iH9xjx5w/X9cX7hVhGtzm511vNRxW8oa474Q5mlAxaUkIAvmbDnoVjkwrXxxkLLvmep5am2zRJdVVvJnbOTWW2lMVPHJLpUoCXwUECofci8VpD33+gQr00PSvnQ2rMX00ZG4vSP+8SPMyzSmC2fbcDo1cZZdes1roOCDkrat5jujitCjnZUeBi/03q395p7H9PZnC7lAieg4ExCvkwLFaSeca8pOngeMG6Xo5gh6gWNHWfLx4sEV88kcZaYMvPQSHS7Amta/pFdX95dxzGoW34D50tbEhPxR2DXBDOBRteSsfu0E0ykAinTdz/NTF/IsN6so8dmXvpAp3/S70NE4GQKlSTRQ28dMZLx78iXfTTM+0CohFk7TKL/JgnZHsq2evTJgFC0TdSC0lGFfGBDKTspdmwbuG45sliUHBu1ya+1JFhN9i59wY3RV8SI1vzQglb/7+8Pa6G2r/ph/ErbgPen+0JAkUat6dd5dIoamj09CfJpH/7JSygFDQPG4kNgtc6AKRu8C18A/ua5HDz6h
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(10067099003)(5023799004)(4143699003)(56012099006)(261022105027099003)(261021123027099003)(261021121427099003)(261009223027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cndDby9JSVZQS2VUNjVNTmV2bkVZY1MzdG9nUG5VcWpQb1gwWGpyNCtwMFQ3?=
 =?utf-8?B?cjBySVAzNElnSHRLMlRpdW93U0VxbTFaZ3NnekpEVnlzcHJyS3orZkhaelRx?=
 =?utf-8?B?L0Q2ek01NVF6TVpQOVNZSEZXWDlXUGtmVkludnd6OGlBdVNwL1k1THhlNW1u?=
 =?utf-8?B?cmlOMnBGblhDRU1HYmdIRkF2M2t3VFcwa3Y0SWNWSk0xU0FFL2pTODlEUzhu?=
 =?utf-8?B?Ukw5bDNxVjVpRVVtSDFTMXBESEU5VFlNdGdya1cxZWN5a014M3ZvWmhuWVVw?=
 =?utf-8?B?VG5NMEFjRnQycVBtak90TUc0T0VoRG1wczBqekJSNFdrUm5Bd3ozUGVLSGhP?=
 =?utf-8?B?YkQ2SlRIUEVKMGoyRlRJZUVtR2ltWWxaRlo5YTFMOFl6cHhPM0M3N0VNc1N3?=
 =?utf-8?B?cURVNm1vSUFCNmdvbktMWEMrajdxVHJGSlVXUXRKdkd2L2tRTFcxMEhFeWJH?=
 =?utf-8?B?YnY0ZHZtOXlsTWY0eU9leEZmMHJHb1M3RVVCRVVTUWV4VHhCUE1Cd1BOaWlD?=
 =?utf-8?B?YVdCSEZLYnJIVGU2L3drSjlwVW1CWEZSZElSVzNBR005a2NLZUJkbFU3N3Zy?=
 =?utf-8?B?bFdlTzRPRXByenQ4b0RrVlA5M3lIOFBaMXd0RElxWGpuUnNsT3RjZEhvcS9h?=
 =?utf-8?B?aUVnVXVRTmRGZHpRRlVQVVQ2R09zL3JIKzFreDNrWHJXTWJHeHJtY1B5VTY3?=
 =?utf-8?B?WWZzMytZMUhqSFBZdCttNGFNMzU5VFJ0eE02OW5iRGNoOEJHOXpaUnZ3aU9T?=
 =?utf-8?B?dTN5WEZGVVg3Y1pWbjE1MllncUIvazkrMytkUHpMRVNaRTFGWkhwaHpyZGdj?=
 =?utf-8?B?aFhYdkRSb2FEMCtjY2M2emx2ZncxYjdrR2tNUllLVnEwTVJ5ZnpaTlozWkg5?=
 =?utf-8?B?QUtvV1AwMEtaa1g4ckgzc21RNWVWSUtlaUN4K1g3QU5aY0tlZ0hodmZtbDF3?=
 =?utf-8?B?TWZYL0JBeS94aTdUZWE1dTd4USt6QklScmt3NGNaSDJBcDdXaHpTRldqMkNu?=
 =?utf-8?B?OUY0cWpua1VyR2hFanFwc2pHQmZ5a1lFWDh5ZkZ0RmJJRkMwbHBEQ0RuUUFU?=
 =?utf-8?B?ZDFZZWQvYURpWk1LektYWnBoemJqVlExUjVhLzBoa244N05mSzRpM2NDVzNS?=
 =?utf-8?B?dVBoYWJYYWxlRWtJTWIxQWVLUWQ3elYzMGFSQXJzeFpRc3MvdzFHSWlMMlN2?=
 =?utf-8?B?c1Yyc1VRRGVIazNRdlBDdmJuSW9VNkpHK0FCV3BYTFJ3Qi9WWUpEQnRwbnhs?=
 =?utf-8?B?cDN0bVVLelRFNGlvb245eUdoL1BFdCtwNnZJcW9EUzN3b09DWFFFeWQ1MXNz?=
 =?utf-8?B?cmlzcWxoWEFxc2JWQXlDUzA1Nk9MWkpublovZXh5UzlOTlk1TUhPb1NjOGk4?=
 =?utf-8?B?QnZMakliYUhyMzFwRVJGR2Jmc0RFK0hFeGlPZ01ad2FnanZkNzVKcG1DRmxz?=
 =?utf-8?B?U01kZzgyYllJcFJKaWhtTktZMkZGUW1rN1BMKzI1TFhBNWhkUnNIejlxTDlC?=
 =?utf-8?B?QzJtNnMzMThueDE3K21PY1JCS2V3cGNxNmhOK0lmMGhEL2c3REJKeWFSdkln?=
 =?utf-8?B?WTI2Q3J0WUcwRVF1RVFMa3J4ZzkxK3dxbHNvbERiVTc1RXBONDVXMFQ2a25w?=
 =?utf-8?B?b2FKeWFSTStOUitkbGx1OXpMS1FVZXY5eUY3THhRK3Z2ZUFjZ25XODA3dURl?=
 =?utf-8?B?dkZVdzk5TkJLdlpzSW5RZnF6c09DV1FQbUVGWU52MEFDVkFTYlduclp3UGkz?=
 =?utf-8?B?VFQrc1BoZHd4TkZIWVFXNEJnbTVzOXpzM3RpOEJreFVZVmJjUWhPLzhEcFAz?=
 =?utf-8?B?TDNRRjhQOFhIOVRUNllXWTQvQjllTDhWTkRzRHJrdmZXa1J1NVFhUk5aU2ZM?=
 =?utf-8?B?dVlWZlFCdUNBS0pFR3lxUGdKNm1xSnplOHdQZ0l5YkM0Yk9CaDVSckxBRmFI?=
 =?utf-8?B?N2c2M0RVK1orcDB2L0x6VFVKOUlhMEp2NGJFM01GdWVBUHIvT0ovelRTZWE1?=
 =?utf-8?B?ZFd4akFnRFQ4eis0bUYxR2lBaXptRlQyMUQxdzM2Z3pXVmh4SWFCL01qVGUv?=
 =?utf-8?B?SkZWOVdndTJIYjRVWVBNYmhjZnhZSzZma3VsNWVsTUh2bjMxcmVxb2FZbVg2?=
 =?utf-8?B?aFNybkNkTm40ZEZwelp2bDgzRzFmTFpIZmppbTFCNzRya29CYkRnT0UxZWl4?=
 =?utf-8?B?RWxhay8rVFZseVRvanB5a0pTNG4rKzNqQ0I3WnNHZ3dLNFdCUWEwYjhVaG5M?=
 =?utf-8?B?bVBsbGxFemlHeUFjSGp0VTRWaW1CTXpJRi8xTVNkdThNS2owZXVRZXZUN1pB?=
 =?utf-8?B?R2hhd0RPK0kxaDk5OE91Vzl6b0F5WUdXNVVZb2EvUjFHeHJuOTUxaW01VG00?=
 =?utf-8?Q?MVrHaA+3KnYihiI8=3D?=
X-Exchange-RoutingPolicyChecked:
	Pm9enJvxrwDXj9L3RGI4syvwTjPAB5bCxPERnXbkXbpp94UZD9XqH2gLyibJDkIYu2DMJck1r2PTW/uuGuf29HLh93CPB2XMXaW0fq2K6Z7LLcRXvqJ2D55U0a3PgcUUTw6aZymrVDfUXH0ymGPTqDqONwMZzI/2VjH5lCtWwr56/nkrNZIvYSh2iIvXoLL+thwLcr4iZDFlUaogtqCSYGw3Dy/rqGaC1HQYcDsL+3jwY0vhuNMWzCCwXxpbCPHeRfrkTJOkBGtWop5Rql+UqXKavb5dvgkoXJk8XMDPwnfuGDmiHa8fLWdKz0qT5wpwEqM/x6F6MwgoIEzsxmbwPw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A22enPVgrOaE4E7dRUrJh6DfRJlaUAV35DQr/wGgwTBptae/dB+9hnZpTmD4Bd3FwTNIXdInNbEEsIVzrRJ/lqt7KaB5T561c6amaMzGrzdwXJA13MddG1MEnb6VBvAFTW65Pay1JtNYIRUEn4l5RtUHYCVSSrTYlJOkSZDB7yMP5WcOd+2EtGJZo/U2iuNZbQ1tlqgSmxVOCT6CUpVWcEToEZta95rwbv96t3mnk07Y2RqsMq9brba/bdx9MnOZPcVAecRxosd/3NE5HbNjc19+kCmfj4lf8qF9WXhIEG6mdlboRDuJxsj9RNZNZnSyEpoSM/0yub6GNWjHj4R3j1hyXld4fKMNAbuE7Omq6cPUVFj8VS+eaP1GFyryXTHSOtmILYBmga55koiC1zD4ZYwwcbhA+Zx1/rnqGhONbWglamiVWI6bSptM3Qnt1HdRXu5vIAyAMMT7nHL4ALQLnSf04HcC1ZoiCrbw/2BOwwEeBa+/e+WpCfBuZu4cGRA0iiEl0jQmg6aDCVulCBWyWNN0n1+4KgXH35hv1llYXvJ2/cU+W7ymvlbKr39AvlDcp0YncKUyB1bAUwc+qkvulR36vRTPSEo02ovnsuCsWZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cec44a7-4ea3-4fbe-ae77-08df46e0912e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:30:43.4957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /RN2bGGK3GoV7a0ItJkMzs9VdHz9Imiz04qL8dk3eT4MFnSSpRnHXEBodzcC3vCLfczGMG4pp99kJVxX7ceW/0QVvp/sKXGi1vjooulYL9u+EZByhRqaWiGdafAxghiB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611200033
X-Authority-Analysis: v=2.4 cv=APpTTis9 c=1 sm=1 tr=0 ts=6b000539 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=_CTZHwbFEcZEOeS61CcA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: SKwvrRybvRqUPgAQB4F0YS6pvl8T2n4l
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDAzMyBTYWx0ZWRfX3+Ky4gfO+JgA
 k5Kww0uIHQSzl8UoDU4oe1saA7DYOzsH7cdTd8TFZUCBHzVkOWtM4IcXKBqQixsVTFmKrImwQiz
 duZgmAzH+L/HT9BGtATHXR+m1tNbn2N3Gv1vRxkBJzoLY9odUyEx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDAzMyBTYWx0ZWRfX5OykpxLG27Q1
 lgYAQ5g5JdWgvyWLSssMm+NY4ubFOpJvTCUTILEFBt9ACx6/FhVftOk4Y99KZ2p0pJze9pEdoh5
 nKyYNAYRHBPB2sGz0JT+46SUKCGdIeqNV050dBKHN4LafesOw+/FP/g1c2zawl4ge72nCvziJMN
 4u589eE79GVihpxTKfVQPoVaSHg0PSBRBRxJt6uu3NYf9IVaEl4j8SWWQ6MpxqN2MlOwf8rHnst
 O4Q0i03ajBoEEFtkXXYs4Dpo62BA32s0GJvCbVgbmfqCvtOecMBfnJG+RwD203K6Pgm0zjKuxKc
 2uKSPBlfDHV0vdAgFPSAV9feSoAxLbNaoD5Mh+yw4zYe5+OWYTNEPmSHRr061hovc86SuATHEby
 ZOVlm27YUWGoVFH8f15kAr3zPGnMUd/9IHGJchgz5NsX/OvYbXBD8ZTj5SMAxQE6Kc5kno7KvJ5
 TpFE/D9u5tsBH5gryLg==
X-Proofpoint-GUID: SKwvrRybvRqUPgAQB4F0YS6pvl8T2n4l

Hi Greg/Sasha,

On 18/11/26 8:12 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Frederic Weisbecker <frederic@kernel.org>
> 
> [ Upstream commit b95d15980a0f2727a421392ebb50fc6338e43b02 ]
> 
> This reverts commit f7345ccc62a4b880cf76458db5f320725f28e400.
> 
> swake_up_one_online() has been removed because hrtimers can now assign
> a proper online target to hrtimers queued from offline CPUs. Therefore
> remove the related hackery.
> 
> Link: https://lore.kernel.org/all/20241231170712.149394-4-frederic@kernel.org/
> Reviewed-by: Usama Arif <usamaarif642@gmail.com>
> Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
> Stable-dep-of: 4c714f015d9e ("rcu: fix shrink budget underflow in lazy_rcu_shrink_scan")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/rcu/tree_nocb.h | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
> index a1a5942d70170..9db8a88e9e6dc 100644
> --- a/kernel/rcu/tree_nocb.h
> +++ b/kernel/rcu/tree_nocb.h
> @@ -554,19 +554,13 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
>   			rcu_nocb_unlock(rdp);
>   			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE_LAZY,
>   					   TPS("WakeLazy"));
> -		} else if (!irqs_disabled_flags(flags) && cpu_online(rdp->cpu)) {
> +		} else if (!irqs_disabled_flags(flags)) {

I ran an AI-assisted source review of 6.12.y commit and the finding 
looks correct to me.

Verdict: lets skip this until we have a reprequisite

This revert removes the offline-CPU guard:

   -   } else if (!irqs_disabled_flags(flags) && cpu_online(rdp->cpu)) {
   +   } else if (!irqs_disabled_flags(flags)) {

However, the destination still wakes the NOCB GP thread through:

       swake_up_one_online(&rdp_gp->nocb_gp_wq);

On an offline CPU, that helper calls:

       smp_call_function_single(target, swake_up_one_online_ipi,
                                wqh, 0);

An offline softirq can therefore reach smp_call_function_single(),
which contains:

       WARN_ON_ONCE(!in_task());

This is the path that f7345ccc62a4 originally guarded against.
The existing hrtimer changes do not remove this IPI call.


Upstream b95d15980a0f follows 0999f6156013 ("rcu: Remove
swake_up_one_online() bandaid"), which changes the NOCB wake to:

       swake_up_one(&rdp_gp->nocb_gp_wq);

Could we include 0999f6156013, or retain the offline-CPU guard until the 
IPI helper is removed?

I think we should drop this commit until then.

Thanks,
Harshit
>   			/* ... if queue was empty ... */
>   			rcu_nocb_unlock(rdp);
>   			wake_nocb_gp(rdp, false);
>   			trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
>   					    TPS("WakeEmpty"));
>   		} else {
> -			/*
> -			 * Don't do the wake-up upfront on fragile paths.
> -			 * Also offline CPUs can't call swake_up_one_online() from
> -			 * (soft-)IRQs. Rely on the final deferred wake-up from
> -			 * rcutree_report_cpu_dead()
> -			 */
>   			rcu_nocb_unlock(rdp);
>   			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE,
>   					   TPS("WakeEmptyIsDeferred"));

