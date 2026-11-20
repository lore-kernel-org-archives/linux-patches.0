Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795172565;
	b=XakWLxFchxzlN9w8crF4kF+cPyXN+4pMw+HvuS4/ozfghQfScGQOfEYCmm/2ow9MDIJ4
	 qHmiSbiOy1LKy9LvVimexi+d3rWZAr0oXPCx2AGpaJNuWkkIz0YvWn322YMr6kA16eW1u
	 tAc07u2rJy0qWr7FajaGK5IxiG3BuCRf49KL28ceWm8aZt+GO1zYu8/baJ87zdBuZyW7c
	 yBjdCPHtUYp6XkWMPf8EEP1dHJdd9mzu5BRsdce9UMmbio652Qx+eQcIF3beFHp2HXlIz
	 q58DvK8vdHKraOYUvYKIXO3XrRIkkhR+wI1PNEHlfDpkISRoeywPQWJNxhXTyC78iVw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172565;
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
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID;
	bh=cqfRAB+8/Us+1Fi1alT7IYhqnF+SB1N/sWAXsTh4lXo=;
	b=4ODFEcdziRtl1RJKoAxZhEhL6W+nRlGgL5D7CjGzwdHeEG+9ejzu0/0auXS9Ukc5XCIC
	 /HjcI/cYXHXVIYq0jNBlKleyyB3dgLDkpVA8+L9qJaYE6d0jLIoRudPTfA7VGhA+nrfCl
	 i03isDJs1dN5pA64Gj7W3NPsxd70SsQea4IYWSmz5ReGQ/MUWl9Fsy4CDB1BSWSUOXcq/
	 igcqT2YDenS42Jhsh91D2OaP+UqFbwvO9XD9PbroRPn0KRMl6Ve01h1vlPDTHF/ubq2qS
	 //rhdvSV/EDS8bpRTgfZbVkz9zsPJQtUk8manKBTdfcB9dziE7268FnD1tYUQpwALmw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=NHqiWfBI;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=STvckMXm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075F5606A320;
	Fri, 20 Nov 2026 11:02:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 075F5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=NHqiWfBI;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=STvckMXm
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK3hZr44078308;
	Fri, 20 Nov 2026 11:02:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cqfRAB+8/Us+1Fi1alT7IYhqnF+SB1N/sWAXsTh4lXo=; b=
	NHqiWfBIptVhBzXonWxLW0qiHAb4y6HKzIGTZn81s8W2Jo9s2u+YQiTK5TkyLebr
	E80Ch0dj6xVmZ7szlqr0S6hnsw3plPqES0AZ+Er7d3FznB3gtPrhJhyWysdBGqhm
	l8+aiS7Oicq3teAiVwVKiLPwbEnxZyDJ8oWjY74c4/ZYdLQt2zweAzh12xAgVEbI
	hxrvKDzVECNVu3XVBHTaOF6Fx+O6CqIH8RsMZlZLPAK7hHT6HNhrZIcs1867GJoX
	s0ylSzuwLRLjKxWtVOnoxYyDEJzAndyCXyHExhWKxMVoUSRVLvGoR9qkqLON1alm
	fLvXy8B2pji65mHY+K31iw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytrchca-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 11:02:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAijqP1220944;
	Fri, 20 Nov 2026 11:02:28 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010060.outbound.protection.outlook.com [40.93.198.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j2kwyjb1u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 11:02:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6ApK0d2mCjXtY2k9ySxXTJl7Phvtpuu6pIfxoQeqVNRNdmfwLWSDZ2kOmXlvUEcH/Z58wH9wj/aCPjs+Zm5XhWqI4/RXKFk/ZEp8YEqFKcJAJiSHMX2k1JnrsjdZ34rXRcV7tnKX8Cf5N5MXHFj4xj8qEoJo97I2i22mKM+6hCU+5mH2LS5SKWCyeOJKpKoj7hIyI6RBBmOVvlDtBzCY7W2jLbWQoIwOdOFOwLm+mw+C7NlOEJJNpr6IiuBdr4zYa79TNQ7riKgN42OkOAUcgUESYjtV+SADv8MwkqqYszcw/OhbW5jX464zb0EQeHTY9FCXi2qi/Z2BjCqRNPAWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqfRAB+8/Us+1Fi1alT7IYhqnF+SB1N/sWAXsTh4lXo=;
 b=j92I2RsA1XpzWVHkVurtczfrGtL95tgHJ7c8P40XJphmB6zI4tAXocIP9HemYbZ7iuL17CrIRx1c4qm6M5obF/SjPjE+dkhN4FDtR6IZo0g4jDz9HhnmxYHYUrGJUuYcFLfosCH27tOjBgAzkfDpwS5CIH2Xr1jvg0d9ITGVKf9p+PajrBhJ9Xn+XMWQrqgLdBYYIXfD3L+5XiBRHPG9Of33d+PGkudLej0H3GdJ71X6yb0/Wc6TzJIShUwflmt8YbsUQNjZfQhCNQC+HA4iZdk8bmszak7WIUo03DkTDPZJMxItjPmt4M+dYO5vrRfT1+wPxhgGVhLmWPteOUQYsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqfRAB+8/Us+1Fi1alT7IYhqnF+SB1N/sWAXsTh4lXo=;
 b=STvckMXmZ6mVGfuacZs0rzKv79vH8lwiKwm5ZjNUV0XtVZR3jf1ul6MMAeRLRI87S7N34hifGuc1VKOvTMBnj0v8n+LYfnvMOfFjB+QajOaHiqIg6CaNYdH4nXvu+7TSl5EzR8tp1246D4PxP9zlpjJ7mXTxRzNLkZxuYmmilW4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA2PR10MB4779.namprd10.prod.outlook.com (2603:10b6:806:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 11:02:22 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 11:02:22 +0000
Message-ID: <5066c2c3-653a-4865-bef8-e031504e04cd@oracle.com>
Date: Fri, 20 Nov 2026 16:32:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1515/1756] tg3: Add Datto SIRIS 5 1U Server to
 restart AER quirk table
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Travis Howard <thoward@lafayetteinstrument.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150109.186630931@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150109.186630931@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0170.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::13) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: c6eed448-2809-4de6-6439-08df46f5c0c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|4143699003|5023799004|56012099006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261026121527099003|261026140227099003|261022105027099003|261022075727099003|261028144727099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	9aO+6u7W6Z4UoA+J8TtEqrAUzY92bv3UU+crkGSS9aAkHIO2UNO6AL9X6DF46nMicseMwz3maLVXhCX+IhTxWAhGfA6WrCAPykKUnqY+50A5QMfs/n5heFz6v/fQnmxvlZlloGIJ2px+PGlfC/Nbr+yTMMKOkQhWvX41QxSe+ejXya9lCjPlcjblgb8BZGToHgXUAi6qIa9sjHQLaQtaYJ+VUxlubl+d1mtn7cc5o66nFWH293fRxdTi7ZSyyNSCXcv/zijCo71YudXL6MjOujmP8EmPsuCvf7IgslBZjRs24aRkW8Py5M+zUOvr/4XYzmw0Csli3hR5DodUu39uAt3WBMZ1t+Zcu8Fxd4NSQ/c142RJBJF0Bw89VoDoMi6zbkDMM5rje7c0M3KAKeFRlgRlbzKnEhtGO3jEpHfgr+YmEaYrg1MGDv7mVZoTnijCCHON6hFaoRGgySorCgKggP1Ohroyp64a1SldE0tj0/CxlZSeIRcmsnLaPC23tGhTkeyjtGjL3e4l+sS5H2sBYJe94bhLeUWHYJK1BZwiUhQwenLwOfO6V/OL2CjyHKs5md3r1Wgz/ek1ErI+jsXEQe9k2DynVPJQoPOwWWXeW2gp5EQUwF3mMPzbzFQNFtzj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(4143699003)(5023799004)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261026121527099003)(261026140227099003)(261022105027099003)(261022075727099003)(261028144727099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEhEeTJHWWxScnlYMUJvcGF5UU5IMmhiZ0U4MlovUHIzWmVUazNqYmowUVo5?=
 =?utf-8?B?UTBoNEZaVDJDTCt3OVBLcElqK1pTWFlqSDE2UzFIL3dEQ2xJZVA1Tk5qaTNW?=
 =?utf-8?B?bzd0SUlZb2NCT0JDRWdHODc2YXFMN01FMEIxa2ZrVU9XdXU3WlRZdEZjOHBQ?=
 =?utf-8?B?WmVUVmFBcGxvczh1VzFUUkx1aFJ2MVFoWTIvQ3JwZERjWWFadVNqRXJnTi85?=
 =?utf-8?B?TXhhcjB5cnA4UXdRM2luYnpqaFM5T1Jsd2xOM0JJSVZEZFV3NExFUFZMTDBE?=
 =?utf-8?B?cGpObmRzRTNVZ3VyaHMyRmVpNkpJVnk2QkhrQU9UYnZDRE9aSFN5QjlWc2Ju?=
 =?utf-8?B?T20welBJeU1welNPL2NNNGpxVkQ4TCtLUDRVekJ4eWc4Yit0NW40VjFSeXlp?=
 =?utf-8?B?R01sNGJEMjRzUWphK2R1TFZFZlVtQ1dISFNuUWgxMVgvRy81U1R2aXFYcWNJ?=
 =?utf-8?B?TERlMFhONmZ3dmU1UUNoR2FUQ0NKNUxDTFRrRDBCc3VkUkc5SjNqb3ZjK1M5?=
 =?utf-8?B?VGdJRTBIUmlkVWJ4ZUk0dVBlRjlvUTQzUHYzc0VRdHpXOUV6QURzdkwwbFMv?=
 =?utf-8?B?NFdOaThURHlvMTlLQ2YrVURXTkpPUUtOa3FFbTVRVGpWOGtwYlZ3MERROVZy?=
 =?utf-8?B?bDVzSVhPNWVWNytaZGVtb0lWMzMyQnBDR0I4SkZSTFUrVjI0RTAwRkM0dVNI?=
 =?utf-8?B?alV2dkV3bnAvYW42RVMvY20wS01FUldiMUNzRU1Gc24vbFpXc3hrQWJJTURQ?=
 =?utf-8?B?cjFzUUh5VWFoRGEwRnB6QUV0UDk4eC95bWVRN1NOWnJ2aW9QMTJ0MnYwV29q?=
 =?utf-8?B?M0tsRXNMeG1ZWEFVK1NLR0ZjV1ZLVUFiNzNoZzE2cDI5K2RRMTZZcVBmK1ph?=
 =?utf-8?B?VFcvODdtWlFNbW1RTzJRK0dvRnY1cUhOejlXb1dwMGFmRWVIaURhK2k4RUVu?=
 =?utf-8?B?dGJka0FqMzJOSTQzdHpTd0Q2THFWR08zcVhBaVVaT0NyeEl1SWF5aHl3b21W?=
 =?utf-8?B?bDd3dnFtL3JhRk5FV2hiK1RtL2hPNkQya0RKNkRCOHpKdXYyNkpnSkprbTNY?=
 =?utf-8?B?YkNCdlF5VWE2emk2VWxzWEJSTW1ieHdrS2JDd0d6cGdRUWZtV00za200bDhr?=
 =?utf-8?B?R2VVcUZOUnBqUWxXMUpqK3RSSE1ScDF2Q3F5R1NDSEFENVBwclNzR1ZTWU4w?=
 =?utf-8?B?eGk5REZZRkU5YUQrTFZlYmUrMEhoSy9yL25IRVY5MDhveXdqWUdpOEloL1Q2?=
 =?utf-8?B?c3dxTW9ELy9EQnV1Y2JFYUd4UDNmZ0ZvN2VoY0tVR245K2xqaUxsWTQrSGll?=
 =?utf-8?B?Q3NiSCtSYXRBTkFGRjZWZzQvYjhqR0ttbHFOeFlYNmVYU2RhbVNZYzhndjlD?=
 =?utf-8?B?QTU1WG9uVGczbkNaaHViUW90aGF2RENPSXlEQStvdU4zUCtVakRXQ2lsdS9m?=
 =?utf-8?B?bW51QllaWkcrWm42RWRBN3UwNUdhVHlnNkdlY1YraG1PeXNheTZaODlRc3Iv?=
 =?utf-8?B?eWVVVkd6Y0Ryck1iTmlGVVFxL0MxRVJaRFB3Vjh0bXZwYk54OTJ3b0JmNVFm?=
 =?utf-8?B?UXdwWHVVbm9ZNWFTeUxSaEQrMk9BRWs3YjVZNTd3U1RNeExPclJ4VHVySHM2?=
 =?utf-8?B?dDlHNElMeEx4dTZjTVhGODhsYmlvSGFMeTRVQmVGY3kwSVp6MlRuQ1lTU3ow?=
 =?utf-8?B?ajM2eUllOENvWTJuVzRPTFBmbGxUNXE4ZWZlOGZ4d21nejQxMno5UTFWN0hy?=
 =?utf-8?B?YkpheW5xR1RLd21UQ1duTjl6cFBBZ1diZWRaWWVDTjdwMFhRbWFlV1R0bWJS?=
 =?utf-8?B?Q05aanVKS1QxckxPdTlUSS91ZVNPMFRxQjFzcDYxTk1LNDhTR3k1U2lkNWp1?=
 =?utf-8?B?aFd2VHZVVkhuMzEwMXBxVFl1clBpTXp1cE93cldSZE5sZHRwM2dkdHhwYU9t?=
 =?utf-8?B?V3NQYW9oMUNoc0dqV1NZNW8wMDg3SFRFY2wveFlveURTb1VSZUdRUUphUVJS?=
 =?utf-8?B?MmlqRzBBVDB4YmNKUkVSQXA1cnk3VVF2ZVoyTjc5dVdUSGMrdFd1L3FlWWJw?=
 =?utf-8?B?YnkzYlZjVURrbWdoMDFFTXBJRU5nZnBrRDVvZXM0NW94KzFrdlpkeVNTQ0c5?=
 =?utf-8?B?L1l0VmI3VzJUbHFWTDR5a0FBa0ZKSUhvVURYcGsvUUpic2xlRFU1WG85WU94?=
 =?utf-8?B?REVjeUY4blhrZUF1WVMzQUJZMmM2K3Urc0Zxa2FCMERwQnZZWU9yMEJTQWtQ?=
 =?utf-8?B?Vngrb1NMZkdQRm1Hb3NFSnJHYnlWWDJiNGxMeVQwZ2FYQWlKTW5YRE9YVTgw?=
 =?utf-8?B?UXhMSFVFYnhFTmk0d3NBaExRazJJU1EwSmxGSDVDN0xFWTZMMEdxL1VJWnpC?=
 =?utf-8?Q?U8GSOlOAWKnTUa6PS9N7j1AiBRP4st514bHbP?=
X-Exchange-RoutingPolicyChecked:
	cUSLEB6xaC851EypNV1MvqJOzTA/BdWofvS8F04qh4rsRcWttVrljEE11nGda9kMdFBGmEkM1irbz96A2b6CHZCoqpgdDKy8g5tVus1/WmAxZTlLguG/0xYN87H/+XzBu30JMEdAf9oS89fRIHNwZU06XYpbaEM55h9Cx7Mj8+pUTX8ke2tFsszjmX55c5N3hOWm4kfnEU1sQPkDS+k9QIM8dVu7riTlostCHdMqVRyZ/YQugM9vrTfjyXxBwypQ4vWFC77S+GCRyZuYrCL5SQ//qkAGHxTsmUYI4mCEeHqWPSlsbg5TToOiy4aZuDLAnoZnDKaaC0n5PU26NenSGA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bt50QGP74RSA7EW1NM0BvENuAeSnIG5QMkYX1Hj7b+aNcpPlwrl7LZl3XA18q9+a2s+hX/7Gf56C8Gg8eWV9hTzy5fWFoSRakuVNpKKqfcBsQ52rSCLzsXyENj/SdI0q0+f56BirBBFqyfKEZobpmfdfgjnySF/LPFnroEG7tLG7zP2MII/QXjx+u+2cz+DcfvY7ygp7HAMHG/Wudnt2pKajV7wg4ILmVZ2toHG8YYngQsyNWKn+rwHZn948y74xCVsNF8ZMCayEqSmy01bsnuB0JXpMc16oMY7e2j00pTPpHunzCskmnmSGQJd4YFP02vaFa495/QKll0mqWlPpR5I4EKYLHrQPo68BjISQqsF9iUApOMo2HQsnCWbiUNyso6u1lYSL/nQKcsCst+AAzCi0Zu4C4d9h5GY+4YIdZ4lUb8iLd5B0ulSkQNSL4Evu67Cszjc77CIOMHm+OBCE5Rc46kWodFL/dNx1AzglNwLGo6pzLoHYK5THvni2iIL8DBYudPNXg+xFoTNL+mJIYAPTrNCmk7HRI2eTU/YpxXv1wv6F7JMpTnTMheUnpYjaI9oApKmj+inNqXk+h4WqsWMbAHMsfGn04POWoSX+KVU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6eed448-2809-4de6-6439-08df46f5c0c8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 11:02:22.7269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SCTzkQv3eAd8gX6gQANf8Z4oftH3yD+4emxMYj4zoOVkLif4Z1x1bY6/lDRgX/y7KKzrxU/qKvJxzZjqt4qoVUVNEBYZsy+mBO0DPMaScOhRDkZlawEI65Rk1OUElasc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200043
X-Authority-Analysis: v=2.4 cv=f+Ldl+yM c=1 sm=1 tr=0 ts=6b0028c4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=-EU9D1hqAAAA:8 a=VwQbUJbxAAAA:8 a=7pCD9BIS1QlCj9wFw9gA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=FO4_E8m0qiDe52t0p3_H:22 a=f9NmyOiT7z020xLJ1t2L:22
X-Proofpoint-GUID: kRFpAtxnpAp20xPgiiGZOOu30m37nqF2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0MyBTYWx0ZWRfX6IdyqISVekf2
 /YrwcmEx3sZLHxJ8zRrf3qmRuaNiSTXAeyDfscdoiQ64dHkxAPx7kwh6KF3Ywh9mEwtlxuC2RVP
 amGwqeh5ID8IADp5ZEWCz0S4SECdhXhhBJpZ0AWYX6jJrYZmGH5T8Nw3ByXKVAJrx9GSOP2Q2g6
 2vA/TqTWeNWJAvWqxuLSLnHx8a+FmKmXm/VTR+XEYDIzwkcLV7lGnywOJqM6S5DvA8Jn15G3pRQ
 rXO5V4MOLz+PVgyJkU3fF9zFLompnHaTc41CyraU9bGFXO2pXFtsmbDX3dBPG+cutI3+OG48Xxz
 f56+CwwPF4P9Vk4v6MSNDSWE18R8Y5loXKrFGrEzwzAZigTVdwGZYlRMQYNfmlvEqWFjMtTD19k
 fFwiRu6YTKTcCB42rq8tCiKUZYqNQQ5GGWaDFs1RzOJpyXuS4FsYjVcIe/oqNmldL1M8KowA5ck
 OA1w6V6IjMOlbbcK33Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0MyBTYWx0ZWRfX+vW9L83am5Hl
 MaMg8//7T/qaOyo67Yup5wIH5eagKrBoSspRBMUtYx4KSpuCiovYf+KHghhu4TKGUMP8anka32T
 WHzm8sGWmOzM9VgkKBN2BnmqmIqt5MKlZKfHwtI4KLHoLRFewHvz
X-Proofpoint-ORIG-GUID: kRFpAtxnpAp20xPgiiGZOOu30m37nqF2

Hi Greg/Sasha,

On 18/11/26 8:30 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Travis Howard <thoward@lafayetteinstrument.com>
> 
> [ Upstream commit a55eb6a622141352131aa6156bbd6ce5da79d9b5 ]
> 
> The Datto SIRIS 5 1U Server is a Dell OEMR XL R640 (Dell's OEM-ready
> variant of the PowerEdge R640) sold under Datto's identity. Its DMI
> strings report sys_vendor "datto" and product_name "SIRIS 5 1U Server",
> so it does not match the existing "PowerEdge R640" entry in
> tg3_restart_aer_quirk_table.
> 
> As on the PowerEdge R640, a system restart triggers a fatal PCIe AER
> on the BCM5720 during ACPI _PTS for S5, which the iDRAC logs as
> PCI1318 and which hangs the reboot. Power off is unaffected.
> 
> Clearing the same PCI_EXP_DEVCTL error-reporting bits on both BCM5720
> functions from userspace immediately before restart allows the system
> to reboot normally, confirming the quirk applies to this platform.
> 
> Fixes: e0efe83ed325 ("tg3: Disable tg3 PCIe AER on system reboot")
> Signed-off-by: Travis Howard <thoward@lafayetteinstrument.com>
> Link: https://patch.msgid.link/20261019-tg3-datto-aer-quirk-v1-1-f0eccfb2ab5d@lafayetteinstrument.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/ethernet/broadcom/tg3.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index 190e7f622e7f8..d95f94e52214a 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -18187,6 +18187,12 @@ static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
>   			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R750"),
>   		},
>   	},
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "datto"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "SIRIS 5 1U Server"),
> +		},


I ran an AI-assisted backport review and I checked the finding
against the code, and it looks valid to me.

Verdict: lets drop this ?

Upstream a55eb6a62214 added Datto to tg3_restart_aer_quirk_table
to disable AER reporting during restart.

But 6.12.y already has ccbf0e078b4f, which replaces that table
with tg3_restart_snp_quirk_table and removes Datto.

This backport adds Datto to the replacement table, which controls
power-down in tg3_shutdown():

       if (!dmi_first_match(tg3_restart_snp_quirk_table) ||
           system_state == SYSTEM_POWER_OFF) {
           tg3_power_down(tp);

Datto now skips tg3_power_down() during restart, reversing the
behavior established by ccbf0e078b4f.

Could we drop this patch? The original AER quirk was superseded;
adding it to the replacement table changes its meaning I think.

Thanks,
Harshit

> +	},
>   	{}
>   };
>   

