Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A249620
	for <patches@lists.linux.dev>; Sat, 19 Sep 2026 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789827493; cv=fail; b=PBobBH/fHAiD558isx8t5A7tkMmQxEL2SQ0+PEHX2oq2KO6zQn/30lUj7+RjxY4qbtbZfwgx0jGUhoCl/AArhE2C6AngSXSdlvgN4uplEwrIUHbpO5YtyhFtHPwdfsYQlDsr4FiBoXEBkOfKFExz0gwLCvu3KXbEXyhOqE13BeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789827493; c=relaxed/simple;
	bh=VwbfFGe7Yy3IYDWcX7IHfDRYYdLO2kFMc4qcw23kLAs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XE6l6DaiC/0fBw7TnvWLSFU7bIlC8KdWstnLDVEgJmHvctop35furVpDAiVx7YCVyD+KxZgak5AcOQk2wWMMUqjkkO4rI44UNbPpoheFcsc1wlshu4TYlUHbOrbOTpwdXQeK/jP1P/O88Uakmp6fYM9ucVQOe2PyEIDh3splyzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=newcqgAY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MRRYJug4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="newcqgAY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MRRYJug4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68JDj3JN1142183;
	Sat, 19 Sep 2026 14:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=B27Js8P5mvI8vfBq/1rC5s4k3AdnnV6XHB3nFlvt63o=; b=
	newcqgAYxGuXa52rGINcjAUmi+314jcFmXpkVV8CbCL6BplwH/Bth7NewpuvvR46
	gXAs+j493du45PYArpACW9OW62cpagnvo1cAODWVTzoHjrsDW//BBTSsLAO1qeNR
	Ig0Vzsz77zTNM30Caf0nuclpruxIlfb0y+XVuKlpBEdwodRaA7p3tI6B3iwxW+YB
	XUeLFjAu2sbtbFEAjNXoduK5XlxLR7SSDaXvCbfXIHmmhfMgiuLQKYVg5QOdS+Fl
	yxkC28o4mi47Xm1XgXINQV5UdEqRAuGqZwZ4CKZe9qS8kJCwUAqmjmLPMu09opMa
	wCWR3xeRrimUgsVv8logFg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk0xg75w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 14:18:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68JEFMfJ040531;
	Sat, 19 Sep 2026 14:18:07 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011070.outbound.protection.outlook.com [40.93.194.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gsgumpq5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 19 Sep 2026 14:18:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e8XK0JsLq4tPGVvT29qjHi7w03XWmwgGiReTqSGeinxQhEea04/O4NtdXP+f2GExW5qP5oHlxxw7IrdGqv90iFnxUQ7rvEyM0NAXAyMOK+YWN2K0npYchYiN3NZA+B0kAwpYBkd1Q4OsFURNxIjgJ9DM/vwraa+81qGnBt87QMUBKCKqqcOWM8m07boXX4jw31lPQsBmrT11VvCojLMfr2LZN2rx04U2w39wkglkHtPvZqaCTO/9cVoBuKZACmY8leJAI0YCQtW9GUlJZSMXsfpo8oDVx8s4zaWoS6kBbLjhe5/ainfSBWMXigSd5P5PncyeTVqt2uYV/kStffGzVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B27Js8P5mvI8vfBq/1rC5s4k3AdnnV6XHB3nFlvt63o=;
 b=yC4FXTePTJMZ1jwLNbr4EUxbRQq0eOJNtAbWikaJR961OzO087ekF8iihiAM6uoOndsG8cUSBUCOj/T1w6f+BRFtmiig4YKgqjP2Bq8rbZYbup9NV3Ch2QDsfT1HE5C76q6bQomBmHAj2mgqFJvMBsYHD3LWG+DlcTqwy9882Ap4hJ7CaIjDm8himv08kD863A2kATp678F3XyCJxRCEzb4RZURhYrsb1mKSLVu0RA8Szvd75I3w25ytMTTGERSTCE4i3wBSsNzVJdRkf8tIbuedEQGKAeS74tvYVrsBEE4ZD45OZHXLvwo2PfODfnNx1kM0qkUfgXuYtLL6AEXLeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B27Js8P5mvI8vfBq/1rC5s4k3AdnnV6XHB3nFlvt63o=;
 b=MRRYJug47dppVRM3Vy8AGlv+sWamtwst0NiuTUzu28CKSIMUzYReAIwdFjkIdRPFQXC6tsQy/NPv89Uo6pcrsn58no+aPvpxKeDCrQofhoGkmyJQ6Av2jBmNeZWaYQ7hDklRvCKK6XiUkhUmvQv2nYdBu4TplNYAE5mjelFt0c0=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA1PR10MB5686.namprd10.prod.outlook.com (2603:10b6:806:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Sat, 19 Sep
 2026 14:18:03 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sat, 19 Sep 2026
 14:18:03 +0000
Message-ID: <8ba23b23-e7f7-44fd-8238-1df3756e0c28@oracle.com>
Date: Sat, 19 Sep 2026 19:47:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0303/1102] ipv6: Honor oif when choosing nexthop for
 locally generated traffic
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151547.226407448@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260917151547.226407448@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0024.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1e::19) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA1PR10MB5686:EE_
X-MS-Office365-Filtering-Correlation-Id: 18a37859-7510-4438-d1a6-08df1658d112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|3023799007|56012099006|5023799004|18002099003|10067099003|4143699003|22082099003;
X-Microsoft-Antispam-Message-Info:
	izl18GM/m/RB0NfwSMG1LDtMQOUDIsgZ+LqR1uCxiqb4awin+qqWN8Mg9kdeehKKfImBqHmWDNvmNbBb2x21dJdwW7lvdbjnOzMQ4SyL//eL3MedSdg4Qt55ph9f+RnmHW+cKU/+OI6OLkRlO1MBSBvF8AOspeuJyjtxPpuiityqdA8oYwitdQAWy43Gy8zPwZMdoV2eKiqPggoECN3K5f8135SCaSa2n5CGfNrmuVlFYk/Hl8rTpMaDVLlF5C1rRK86jH4s8gHPS5omqkK3R9QXmy4JjzhvwocoxH8BfhdW6V8zhP8T9ofP8QLwmozwiBtIwkJ0WIz6baOU3ANu1dAiO3jaBPa0xfz5xvLxGPMdEbiBz+xBm3EjCDOTgNVDgsA5Aut7/sAYdB8fqYasWDIsBP58PCaj7z+1cduC8B0u0vYjuesUGfqawbJ/Kz69Rb5wH1dNSdERXbV81TID0LBT6JRP0TXssEfWp8IKZXCf6x6FGM8pP+PywpGvgYjNWVVq4MC3R+IahKcLQ7bCtUNg9tYB4RLREpWtLCS0KaSMK0aCQmGNkbej0cpGePghzblM0dhYCgsy4QQrG2awR2IW40s3TxOqHB+5N84L2VaWlbwzFgbHD8dTNMZoc9xi
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(3023799007)(56012099006)(5023799004)(18002099003)(10067099003)(4143699003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDBZV0tBdHpudjJKWVZoVUF6WUhVL0hmMVg1Yi8yNmFnTU1xMDErc1ZLT1V1?=
 =?utf-8?B?YUZVV1hQOXAvZno1M3hhRXYxRWEzdS9sQXRaVnArZWZMYkdYNjhzdzJmTHV3?=
 =?utf-8?B?czkzbG5EWWhvV3RwNm9HVTlER2kvS1ZXSWtoZmJNdnI4RjdJaXkyNVZydFdn?=
 =?utf-8?B?aXVkaFZzTG5uNU1jR3FtYW9scTh4V3l0THBYNldQTGhaWExMaDk1SzRVMis1?=
 =?utf-8?B?OVpOQW1PbGxZakhmN3BMeGpvVmhlcGJ2cDV4SFg5TXFBejNiYlN1NHM1ckFk?=
 =?utf-8?B?L24rSXpRYTIzUm5aNHNYNnl6OEV6alViSnBSRmx1RjBlaTBNZWZQc2hlYVF3?=
 =?utf-8?B?SXNEeUFqNWRRZW83TkJzQjd4VGx6ajFJN1U5NWdHNnhzYmlpNUlpTDdFVUNt?=
 =?utf-8?B?NTlYS3ljMDJtbzlGSXFwZWJ0TDZwVEY3VnBNRElvWWZ2eGx6b3V6WlYrVFAw?=
 =?utf-8?B?Yjd1aFRSdmljZDRWR2xwcE1FQWJxWU50dDNpR2k4TFZ3Y1lZTFdneDJ2ZHM5?=
 =?utf-8?B?OCt3aHV0aGJrKzZGazRWb0FrcHJWakwxSC9IcVRyUmxuODNiSmczVEQ5VVAz?=
 =?utf-8?B?K0RHWFdkbTdkYXF2aFV6b0JkMzQydld6WHQvSE5md01kWUwwVzA5aDVwbVh6?=
 =?utf-8?B?SGJqQkZVemFibTg4bnRnNThBRndWc3diSU55SEY1RlYwOFpQMyt6OXlnTzR3?=
 =?utf-8?B?VEdJcDQvUTMyYzlrRm9CUVJZQU5ISkFhV2dtWTc0K2lPTDlJOC95eU10UHQ0?=
 =?utf-8?B?TWlEZ0d3eU1uQ0tDcFJ5dDIrS252RXRkT3VFL2VCYWtLYXM5TC9KSVhWTkdB?=
 =?utf-8?B?bks4QnZMRVRoU2MvY21Rc283QkhSK3NuZXdMdHlidmYxdWRGck84M2NQU0xC?=
 =?utf-8?B?aU5ZVitPaGxWT2JuTCtqMW5FNjhBOEtadVVmTVh6cjgwSUlpYWpPN0FGaUtl?=
 =?utf-8?B?US9yd0dZendocU9kd3B3YUZCUnpGeEZHWFY3NTRNejc4bVdJUzlMbGNBTEpa?=
 =?utf-8?B?MUVyZ2xGSlRHcHdLcDZ5OExrUUZMQ2hpVDVqUFhFNFRYdDlPeWs1UEUyV2pS?=
 =?utf-8?B?MG1NQXRub2theHJKczVidmlaVGozT1NTQVUveWhZMWptVWJ0bklnZERwblRD?=
 =?utf-8?B?ZFE5SnZRZWQ5VnlFdjJCMHlPdGUyaGNmT1Via01JdVNBTTV1YTEwbEd1SEdP?=
 =?utf-8?B?THIxeWR4bm1mMGhucUVWZUZ2UnpSLzQxQ3VFKzdWUU5GTExSRWVlcjBMZnJp?=
 =?utf-8?B?c2ZIUkl0TmNibzZRZVNaTTN5OWdXc0JPL3JaeXRuRWE5MGVoUDc5RElWRHNT?=
 =?utf-8?B?ZlJaL0NRSElWaEhCQlhiZjUzTVFVM3pIOXJoa3V4NGxac3FYMUF3RnQ3a2I4?=
 =?utf-8?B?TERrUWk3bnlYUHRqSDFId3pCejdIOCtzdlV4cjNXVHJTT0dabDd2MUJ6T3RC?=
 =?utf-8?B?V3NvMXhoY1RBSStnMGxUcC96ci9vR055aTFEMjFoWm1VQTdqMWt0SnU4NFU5?=
 =?utf-8?B?UVN4RXdGSzJheERNZ2pLOW1iN200Slk5R283NzI1WU1wMXdkUzJsbWJGOUxo?=
 =?utf-8?B?c29QcFNvQ0pZZTRJMnZUVWdqVFc3MFZGZHZmTXdNM2FpNnhHQ0FXbzNFTENm?=
 =?utf-8?B?ckhJVVBQY24wUVQ3M3pwNEtlQU9pQWJIQ3B5SStFcTJPUHIyTVhqdHUxUnJ0?=
 =?utf-8?B?UTE0Nm9TU2pFYnFXUXRtMk9BeG5sSXJhTDJxczNxY0ZoNm9LWjNRUUVKb2NZ?=
 =?utf-8?B?cjUwR1hkR3NoTUEvcUFITnF0WjdhTUlVcFJlZ1habGxDQVlEc1RiaGVXdWN4?=
 =?utf-8?B?ZXNveUhDc2lsOUl3ZnNqQm5odmlrMHR2Qjc0bW5OYVpoT2NtY1ZjSEJhYzV5?=
 =?utf-8?B?NGlqb0ZkOFZpQ2lhSUE2Y3FBOC9uNHh5c2Y4akZCTlpHaUZXTFlYc2JvT3cx?=
 =?utf-8?B?WHlFZ0dLUG9LUkEvbnQwUEdzL3RKcG9PNWgwSDhDNW94RmJwemhrNXV1bnFs?=
 =?utf-8?B?WEJmUk1vV01xTEUxL09rdG00LzlYZGhwRWVUQTgxSUZuMWVDMy9xVlFiS0dU?=
 =?utf-8?B?cjMvKzVnN2dXc0VHV3FKdENxT0ZDclJhUCtWUlhmVmFVdTBlamQ4aEhxYlJP?=
 =?utf-8?B?NUhhV3NQQzZmM0ovczhEQVBnVVBjQlI5UGNXb0RzUGRyK3VlMG12SFdUQjB1?=
 =?utf-8?B?bWJvZlF5OTFLcTVveWJ5cEdMQ2pRSTN2SXhBbVE5K00rOW1JbnBNWVlSOTJx?=
 =?utf-8?B?bG1GS21hcjIxcGc4RHdUaEM4QmRTeWM0NDBaaExSL1R2K2JibHNmamU3enky?=
 =?utf-8?B?aHdpR0FtQTFsUWdrUGdHbzdrakQ4bTBWVzR4WDJnSVJWaUNRc3dRWXp6eENE?=
 =?utf-8?Q?wWPGo00dm4NzpW9ogXgfhSN8kdDtrC7pT/T/3?=
X-Exchange-RoutingPolicyChecked:
	4nbi8tPcbygyiRvRUkytbDaC5oqmBjw01ux6m4IflUqDcbyOnRwkfMrh6k2/kR7hb2nByshrmh9UARtZ5zflqnWG5hPKJDyxgFwfI7x0OtCJRwjYklzZJFW3pGCWvcUA/ksrmEcOrVrytCVTBPMhguQ/pCf8f5kdK8R9HEFnXLZjnrG0T59XKG4VAs0HMRvR4IGaRTUSO16BEDwt2TsxF+Gj8KqqShS7RWi7FMapV6sgeepRiMcSzHoQulh83ffzWp1UVQq1ejbQ2M8x3ayLANIZS8FV2gxyiRMzlY55SheGJ08wwY+35O1FZJ5a7rc63AhEv5cF0eMTsCu0DeVX3w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M+H5CJmEJ0MRKRT12jTAlXhcDmG7E/Stmh9Os5keKPS62nuclheYHDrduzrYyV5UyxC/QbU9l3e1BAYVF3aesr3ZoRGrQVVNbB7gUkl6aMmF/yrmia2ddz7Q757OxXkROLRf5QROGJd90jfVhPfLUB9JfUhZuegJ9qzZlkgtMO+BRN4kjBTfWw5aRDjbZA1v94tQ1rCUWdPwq7oigYGw6NIq5zOas7Z0v1Uomn1fH7jpFH+MjXciB8XvS5ERd0bRddKEjv9CBZJO9IkClc7Bl1hse4aYsytyh+/c5zIbdKgszd36PtlA/6JowfcbVwz5Ykfquf8w/dCyETfdkr7evLNcIT0BrA8Bq24YWnYWulsp5WgabC+ORORvvq6qfF4pdI2nWj9G3MWltMZyiKUmGTMFFGhzIPvgQtAqxBO5ii5OuPcacToyvpewUzODYMdxlznklsRpCdeVmVzKtvAxzo/ba7P2kMw4WTNTcLO07GxMMAOfijwYj8TbK42DACrWb1fFcX4hQlDUiphLqsHQRcFrww1jb7saUMtiCaHzn0ea2XuE6eduZM08WTQ8N00OMCBYZUgDAPhZSFCDNJTFJwxn4++1sFrsbDP2/K0SBdY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a37859-7510-4438-d1a6-08df1658d112
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 14:18:03.2135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmPkNn7DbL4wHMIykscTaI/iGCROi5ak/8GoOdZEHhoy7nFfjOzEXXJ2Je3p1ZwTVRl3kYABz4QDNv18ZpAVvKR5KHzv1NevONoYNWMLpf+dFdvpvAvFG7fE14nwk1oF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609190207
X-Authority-Analysis: v=2.4 cv=F/bC5ahN c=1 sm=1 tr=0 ts=6aae99a0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=A_rfZVKuJZBW1DfWQiAA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13532
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDIwNyBTYWx0ZWRfX3MXE7iTPmcDv
 mS+TnA3gyyyMang1aBvlrdNGIGjRyrtoRzv3j2nrcX9PRzhJW5EvWdC1KhxmDFkHEpFAHZAHgV+
 QPVRcT/s3QHIz+7HJzyo4uLLChBwQ46V2b5ooAFnnuuUiWt7cUK9
X-Proofpoint-ORIG-GUID: M9aoVTBzTnP33pIY5nmQnlwFT6Ofeotz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDIwNyBTYWx0ZWRfXy9TzK82m4scr
 G9eVX8jY69Isdkp73lnC0DKqDxkq2FT7S3nsK4LK8vaSHu3Z0smZzM6nisbeljMY9eIEDI7tKX+
 5WgzkIrlrA6KE1kwXumKHocNF69sc6EdCRcWyYLyp3nYOgZkMUfxvP86Yq3ZtAWQXyvZjL6PE10
 8uoL36B9GBtogZF7yvHunvGV6gl417dOGBQvcol3F530JwRTCDvQBHz9IbSw4S0fcRTG3btplTW
 vu1U4NSIsJtpzsIEO0/eC3JhWfWnDFHVg1H0BD7AYkMkGH/EuZP7b5ap+ncN7DL4nIXetwI+l7L
 mcnxbSKMdXDOKof7uEoVNHmLGG7AQXmfLkJHVfe2U5uuPO1DyeeeS5eDtzArSikkhvPZ4xNM+x1
 YRLrsOIbcTFN9wXJgDAOFU1npOAPmW5vATxZu/eCTYBYe+ZgXTj4cnTYDfP3XdUeolt3Hg/0tCt
 oZI9xPB9pvNxf6Q5C7aGFZHQ00kkF4bce2lrhKBY=
X-Proofpoint-GUID: M9aoVTBzTnP33pIY5nmQnlwFT6Ofeotz



On 17/09/26 8:34 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ido Schimmel <idosch@nvidia.com>
> 
> [ Upstream commit d25e7e9d8a6c1e2afb854613e417c6aa1a28ce6f ]
> 
> Commit 741a11d9e410 ("net: ipv6: Add RT6_LOOKUP_F_IFACE flag if oif is
> set") made the kernel honor the oif parameter when specified as part of
> output route lookup:
> 
>   # ip route add 2001:db8:1::/64 dev dummy1
>   # ip route add ::/0 dev dummy2
>   # ip route get 2001:db8:1::1 oif dummy2 fibmatch
>   default dev dummy2 metric 1024 pref medium
> 
> Due to regression reports, the behavior was partially reverted in commit
> d46a9d678e4c ("net: ipv6: Dont add RT6_LOOKUP_F_IFACE flag if saddr
> set") to only honor the oif if source address is not specified:
> 
>   # ip route get 2001:db8:1::1 from 2001:db8:2::1 oif dummy2 fibmatch
>   2001:db8:1::/64 dev dummy1 metric 1024 pref medium
> 
> That is, when source address is specified, the kernel will choose the
> most specific route even if its nexthop device does not match the
> specified oif.
> 
> This creates a problem for multipath routes. After looking up a route,
> when source address is not specified, the kernel will choose a nexthop
> whose nexthop device matches the specified oif:
> 
>   # sysctl -wq net.ipv6.conf.all.forwarding=1
>   # ip route add 2001:db8:10::/64 nexthop via fe80::1 dev dummy1 nexthop via fe80::2 dev dummy2
>   # for i in {1..100}; do ip route get 2001:db8:10::${i} oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
>        100 dummy2
> 
> But will disregard the oif when source address is specified despite the
> fact that a matching nexthop exists:
> 
>   # for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
>        53 dummy1
>        47 dummy2
> 
> This behavior differs from IPv4:
> 
>   # ip address add 192.0.2.1/32 dev lo
>   # ip route add 198.51.100.0/24 nexthop via inet6 fe80::1 dev dummy1 nexthop via inet6 fe80::2 dev dummy2
>   # for i in {1..100}; do ip route get 198.51.100.${i} from 192.0.2.1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
>       100 dummy2
> 
> What happens is that fib6_table_lookup() returns a route with a matching
> nexthop device (assuming it exists):
> 
>   # perf record -e fib6:fib6_table_lookup -- bash -c "for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done > /dev/null"
>   # perf script | grep -o dummy[0-9] | sort | uniq -c
>        100 dummy2
> 
> But it is later overwritten during path selection in fib6_select_path()
> which instead chooses a nexthop according to the calculated hash.
> 
> Solve this by telling fib6_select_path() to skip path selection if we
> have an oif match during output route lookup (iif being
> LOOPBACK_IFINDEX).
> 
> Behavior after the change:
> 
>   # sysctl -wq net.ipv6.conf.all.forwarding=1
>   # ip route add 2001:db8:10::/64 nexthop via fe80::1 dev dummy1 nexthop via fe80::2 dev dummy2
>   # for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
>       100 dummy2
> 
> Note that enabling forwarding is only needed because we did not add
> neighbor entries for the gateway addresses. When forwarding is disabled
> and CONFIG_IPV6_ROUTER_PREF is not enabled in kernel config, the kernel
> will treat non-existing neighbor entries as errors and perform
> round-robin between the nexthops:
> 
>   # sysctl -wq net.ipv6.conf.all.forwarding=0
>   # for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
>        50 dummy1
>        50 dummy2
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Link: https://patch.msgid.link/20260611154605.992528-3-idosch@nvidia.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/ipv6/route.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 3e5bf8a5b32b2..61a4f4d763c93 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -2266,6 +2266,7 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
>   {
>   	struct fib6_result res = {};
>   	struct rt6_info *rt = NULL;
> +	bool have_oif_match;
>   	int strict = 0;
>   
>   	WARN_ON_ONCE((flags & RT6_LOOKUP_F_DST_NOREF) &&
> @@ -2282,7 +2283,9 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
>   	if (res.f6i == net->ipv6.fib6_null_entry)
>   		goto out;
>   
> -	fib6_select_path(net, &res, fl6, oif, false, skb, strict);
> +	have_oif_match = fl6->flowi6_iif == LOOPBACK_IFINDEX &&
> +			 oif == res.nh->fib_nh_dev->ifindex;

Hi Greg/Sasha,

I ran an AI-assisted review of 436d8d6c4487 and verified the issue in
the 6.12.y route lookup code.

Upstream has:

if (find_match(nh, arg->flags, arg->oif, arg->strict,
                arg->mpri, arg->do_rr))
         arg->nh = nh;
return 0;

6.12.y has:

arg->nh = nh;
return find_match(nh, arg->flags, arg->oif, arg->strict,
                   arg->mpri, arg->do_rr);

The patch matches upstream d25e7e9d8a6c, but upstream first applied:

484bb9d164df397a53e0f533b262b27b1590efcb
("ipv6: Select best matching nexthop object in
fib6_table_lookup()")

That commit makes the nexthop-object walker inspect every group member
and retain the best match.  In 6.12.y, rt6_nh_find_match() returns the
first improvement, which stops the walk.  If that member does not match
the requested oif, a later matching member is never considered and the
new have_oif_match guard remains false.

The fix works for legacy multipath routes, but nexthop-object groups can
still select the wrong egress interface.

I think 6.12.y should take 484bb9d164df before retaining
436d8d6c4487, thoughts?



thanks,
Harshit> +	fib6_select_path(net, &res, fl6, oif, have_oif_match, skb, 
strict);
>   
>   	/*Search through exception table */
>   	rt = rt6_find_cached_rt(&res, &fl6->daddr, &fl6->saddr);

