Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795209719;
	b=QvB0FJYTmANb2Vg6XQO1ZLqujGJotSaFCNYUE01fHUgfBcffvaT9Ds++3dSXJb9/mB0J
	 Xp0xcGmeGIOW/OrfHfiwsjeE+MCGSrAkYQ8fQxrvlwrP68oq/dSt13dKnmbzm01wCEo4Y
	 nkoT/emVc7jdngq0dQlTEiGI3VcJe1JixC9324pYRF5OVumlBGoyTt2AIVf3N2/TyH4e/
	 TeM4ponOPdxyOOTv+z8G4PWdcE9BVoDowWQsu71LjE+ht2+57o29+oDRk+rwPIkKRLten
	 57vOaqtvoLJYjrDn/CRaannQVcCpaqsmyQXVGxsrsJE/qX0FsCp2XI9pWOXQs21VvPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795209719;
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
	bh=LtlnYVHtKs7Y06anlwpv0sLOrQJSEaYXSsA3dEHl2E0=;
	b=iCXrt0cUNEbAgKlJO/hcosBXh5iYYtEWT+UAT9WIsRdCc0RWj0bTCXfVQtAcE6IRdjtY
	 NpgdokgNqzZUkKHc6iZdXeemVZJwB+N16YAqa+yFxZy6k5JyqLDA8DaU+C1sunXM9QuIN
	 BwT2dxqU9iW+rvcadU7DaqcmFenA0KvRJPRQn+2IF8N0ntXviRzYfqtwI5WM2c9FF/9CR
	 0g67a96hWOZuVqJYAWaZ0yWB4XB7egF2idD4dtmk2S6xFY9fKNXTD5UqI5MZc+Ve3Kkxo
	 qquQ7rJE/OVdLlIpvjIOxyyln3T9S/GYBYSOfFBhSg1SbBdByBs1ky8zPhcLuWXL2MQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Wt89WgMt;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=nmGokDNb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DB9606A68D
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 21:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9DB9606A68D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Wt89WgMt;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=nmGokDNb
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKGk9aC2450691;
	Fri, 20 Nov 2026 21:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LtlnYVHtKs7Y06anlwpv0sLOrQJSEaYXSsA3dEHl2E0=; b=
	Wt89WgMtkpKnaAOVfk6fbDKMOO2pF9bPi58XKAtIXZgLmrWWD3aHZmyterLn3ZSK
	KqsMv6+F4DlSo63uApee/C7YIeGPOn3tSN9vs+nLRziDRWGm7d0YOGC4f5i5lLmL
	kE82FfrrIUqjX15pnbspkASmH8pNcP4EOkeeBmkHVzFq5ERE3sKRe2oaIp7rSFCP
	jHJ3StkS8qBkYq8mSHfgII5xJ+H2gttRaGlBy6b8g7bNwQpWzM6oM+g+wtGtEdiq
	Uba322JGajXiS6WsTd4kuRp0JCp3ZFpWuDqlGpsmSG3rN3qey3N1qrjExvMFSXIl
	M/MMUD43yHOYGNhHX5G9HA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytrdd0h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 21:21:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKK7GK51014162;
	Fri, 20 Nov 2026 21:21:43 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2tsyf468-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 21:21:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cg02RvakqajXrRRS0tiP6xOMaEjv1C89Ed8rLo/Yy+QEqQ+BJBR9+/kra251sKK2w29NU9aBI5yHzkrDRVR5aEnAvSNYTpddro1S+CZw4S2FgPo22vmH36Ki3sWa/L63hIIm0GuuediHfkOvOoZ/8K+Bxkn0LALcM02Da4wRqZmP3cMz7eGYrBoPxiYy8/C1O34+nZFNnVsxL1ZtRJVnymjo0zcFsTVo8KFAdQadWV7ncqp0824Tt/ROrhr9BUldKh3TePxscEIP3cy6Hqb51p8JpcdRj0Q371rGHcEyxYXs93/g7n4/AoloGM/qTBvOXdetmChRONXfRnckBizINg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LtlnYVHtKs7Y06anlwpv0sLOrQJSEaYXSsA3dEHl2E0=;
 b=YRrPik5loJlh3lkPFuS+OvfbnVBYkG9bSoNrLP4VcJk0TvAXPFeEPvyw8sNa1whGfyeul1D0a9Hx5rGNaJpcC57JVW9cnP9VXDZ+4fAmOJEDamc/cglzeuQUfTn0XU60So6IEoSgefml0SM7Bv9pSZUL0Zo3LPOr+3xpx988pxt98kAH32bUuzrzgs8q2wI+klKdvtzNqwqlOWyOc2uG654aFSpBFbnCfEwMXz6VwF81fl1QUNFPhLydznKNzF0Hl4AiualdXiximy5DETtwRF6lSdfkvdKdFIwd2RyEHbF6H7+hbm0z2jlZO0kNxMdmwwgCKv3ejkuf3h4gwS5GXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtlnYVHtKs7Y06anlwpv0sLOrQJSEaYXSsA3dEHl2E0=;
 b=nmGokDNb4eZ0UPLDRa5190aMcUl+mG04QJJSJ1CZvigz6llC5ugaqmTXeormWcpvNOFBbKMrNsTCjSRZQDkOwlyBsHcTvlpt4q8W4rcdrPebc/IFMELI2IOYbZdebOFMa4EpOxWW6FVTdtZ22Z4qcGP2jLyjbfT/e5eGV8alFc4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 21:21:40 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 21:21:40 +0000
Message-ID: <85a50fb0-0bc1-447a-ab03-6565d657f77a@oracle.com>
Date: Sat, 21 Nov 2026 02:51:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0437/2214] media: streamzap: Add missing
 rc_unregister_device()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Sean Young <sean@mess.org>,
        Hans Verkuil <hverkuil+cisco@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150028.545631168@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150028.545631168@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::15) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac955c7-cf42-416d-e0c8-08df474c4479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|261022075727099003|5023799004|261026140227099003|4143699003|261021123027099003|261009223027099003|10067099003|261102123227099003|261021121427099003|261022105027099003|261028144727099003|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	hDXg9OHkQNrIGWa63RnTTZfO+dpX0QAOdFfGVUpeKuxQsr9r1msx8jXQX6mD95lDBWXhQYKNOhLH7Q01U8MMX6VoBlFiu4V3mDStTtVuQTEDEwiXSWCcnxwsoww5bjZypMY6ub5cJ1rnBm3XfKHADGZPCm8awukpkKOTQVQ8z0N0thlotd/fbe2ffyaDLObBjQUvSZH8XS2E5TEdQFhJ3+KWvq27oCtYhRfbW+MVdMH0kb5+yKKdGXv+rUtsRZQS9h+KJwcI9RksnymQqD832Y1/YjqrgrX0+7WCQyKyvPyJCB/FVCxIUrjBbsc1ZrL5VRGfbXJFV/3Oism76ET35c+9V8ruwHSm/m/Pu9mxxIlxlwIwsWLK/4Y7BLXj8jHy/eAJq9AuTU4HtKTpyHfhB8vcvlIUklI4DmbVuj8o/uayYc3a8P+H3lNj3UpyNKx4vps31G8SB4bGZQChJX6skKazJkfOzenoHs5UnVRmoPtkS7zeR7/bvkWOwBjNND5ffqsBzWp3CaS53dHfED1fKwJvUEzaZTV7IrMYPVZE9KAkhGQAxzmHxmf1KnVKNheAsHAdvhgtc+GLevRBh9Us6LzuwVBzCUk5Y/3iJKjUVqeAsyekrzUmzp/V3WoRHHs7MMEx7LluqpGdTP5hR55DImp27MUfv83oAw14hEDI/7k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(261022075727099003)(5023799004)(261026140227099003)(4143699003)(261021123027099003)(261009223027099003)(10067099003)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWRlUVRRUU1mNGVvbHRsclhuMkJBbUt3ZWtTUng3bmlqZXc3T0Y1S1JZT0NX?=
 =?utf-8?B?UVRUTElMSWJRbU8zUS9jenp1TTBLUzNaTXRpa1NJY2g4UnRJNXZmSjN3MnFR?=
 =?utf-8?B?YU8vaC9BOEV3Q2Z6NWJ1RlJLaXRYK3JrOEhPQ21PSjI2WVk2UmEzL0paa2k5?=
 =?utf-8?B?YmE2aG5pSzNUdG5uejU2Yjk3eVFtcjFDMnM1cXJjQThGN1B2eWV3dThBSktZ?=
 =?utf-8?B?YXNiYytWMkVvRkZmZHNkZUhLdVBvMVdyLzVhb1ZYVGl0WkVVRW9yQlJ4SCtQ?=
 =?utf-8?B?dUQ5a0R0L1gzWlFEQ1RyaVNBdFJBNXQxTnlmYm40NHRvalZKVFRSUXR6ZGYy?=
 =?utf-8?B?S1RPZVFnc3NFdG1VV2Jmb256NDFTb0xCV1cwM2FTRXRRQWNKSk5HSVkyZkRU?=
 =?utf-8?B?MFNvVEU2OG84MzlVRVhJT3VZdDB3UmxjUlFjcFAya25FaGgzZU0yR3VJM0Ux?=
 =?utf-8?B?VDJQMWN4ejlnVi9jc252RWYrVjVEelRuNWZZQ0g1WjlYeVdBYW5zbmpySDU2?=
 =?utf-8?B?c2d3MFgvUWZ2YUE3Z3drRndUVUZnT2psbGFyZEJKQ2NLTFN1L2pTR1MzMmth?=
 =?utf-8?B?L2RsejdkakZHYW5YajFGYTk2T01ubldtNzhtd2ZaV3JlYndRSGdPU0xmQU0z?=
 =?utf-8?B?R29aOEFyUlNEYWkzSmp4Zm5Da2YyV1A5ckhqb0s0V21rZHhaRXhLYlNTOEdi?=
 =?utf-8?B?N3l1cFJJUEdGM1ZMbTdSQzhlNEVPMU5WdXlXc1hkMCtsNzc1QlJXZkV3b0R1?=
 =?utf-8?B?M2t0a2JXV3NRaTRqaml6a1VHSHY3ODMxSUpFNFdJcjFLNUVScklxb0tGZVJM?=
 =?utf-8?B?bjhHU3MyVVhUOVJBT0wrZElXWU8rSXRCY1p2S2o5S2YxaWpxMkNKWXVjSURz?=
 =?utf-8?B?Z3BRT1FoUnJvWFFnamZKV05DTFNRTDVnVGFvRUd5N09oSmlTb1VUeWZTdzJ2?=
 =?utf-8?B?eFJzU0ZjZkpwdnFjOVp2ZkRMTG9naGlkRWJqeDZ6cGtSNVAzRk9DdXdVSW4y?=
 =?utf-8?B?Sm9kaGo0L3luTlBjUnFISkIxQ2dqbWZqTWZhWjI1VlNsRXhkZTY3c25wKzky?=
 =?utf-8?B?SExNNGNMcVgzMGcxRWFWL1JISFlEazRBRE42RmZ3S0tZY1QyOEhJWFM4dTE0?=
 =?utf-8?B?bEZLTFdORTV2Tk1SZ013SDlORFdteU5TOHJUemZHR0h3bVl0Q2VlY253ekMz?=
 =?utf-8?B?WFl2R25nMnYrNWhvd0JDNXNwdDZmb2NZZ1ZTS3hTQ3dySlJnaElXZHZoYitY?=
 =?utf-8?B?OE9XckNPZHlFYUVFa1k0YTNzUTdKbWVtSHczclI2cVBrcmM4ay9DL1dDRERY?=
 =?utf-8?B?ZU5PWG5ZS1hrNnNxWitZcTJ0T0lUSDREeXAzSEduVnZKN3ZKd1JxeVZ4YW9n?=
 =?utf-8?B?N1JFdVJYd0NXV01lQ2xEdTdYV3Z6aHY2RjQ3RWlycnhENGlmUCtmY0d5L2VI?=
 =?utf-8?B?YVFwSFo2Tm52bERlczNHQ0syTVhtbHMyekg2UjN5TStPb1M0MEM1dXRQVE9H?=
 =?utf-8?B?QkFsTkcwbGgwNlhadk1Xc2dyUC9PaXpGZG84OUs2QWpXNTVnS29RSCtHcnFS?=
 =?utf-8?B?Y2owWGpFQXV6TFlBdHo0UytTVjhPMWoyOEI4SWdwOUtMRGZjUG5WbERJM01I?=
 =?utf-8?B?V3JkZi9GWmRoZGtmbmJHOEl4YmdLRjVCcGNLL0I2dzR4ajRDRG1aS0tReFFH?=
 =?utf-8?B?a0EyRjNBRHAxNVdSTC9ka2puSWFTbEJFNXhJbUlpQjdqTkJlSk9qTTZacEh6?=
 =?utf-8?B?WklmZ004UVUxS1UzTGU4UDE5RW1WN2ZPNk9rVS8vTHZqWitwcGNlYkE3cFdy?=
 =?utf-8?B?ZjdpakpzdkRuYldtWlcvR2RtaDFMajM5T0ROT1pIcU5pK3hqRWsvaXhMWllr?=
 =?utf-8?B?YjRSTFhoTU5DVzdsUVZNT21hSk9ud240ZkpTL29RSXBhN0d0b21sd0ZNM2Mv?=
 =?utf-8?B?QkN4VzA3czVCRi9LejdmYW1EMjNKbFZLS0FVd0NqS2RrY0t4TU5zN2lnNWNu?=
 =?utf-8?B?WmJ5NlR0OUtrNDdjRHp1SFI3R2VIS210SEZpUGk2aXhqNVZJMW9HSmNSLzc5?=
 =?utf-8?B?SHR6RDJDY1RmamkvZ3hIeHBickxUUzZDV2lrWmlMTlBrbFpPZ1hScm93OTVL?=
 =?utf-8?B?V0pnbDRRZDRNUXdRbHJsRVdDdlNDMnpTQzFGZXZqVVYrYmZVQWlmQ0puYnFz?=
 =?utf-8?B?a0JnQ3lURHYxQW1zVlpCS2ZQczhuTmduSTFkZVZFNTFSalVIUXFDazM2dXNm?=
 =?utf-8?B?RTJ2ZHVwZDBWbk1WaVRyNXRRVlZuR2UvRDE2UFRMZnI5WkpqV1Q5WHNQcjJ4?=
 =?utf-8?B?WjkrNVk1QzBndktYbDJnTjRoZ0VpeUd0Y0J1QTNuc1pEVkYrREoyRmdKajNn?=
 =?utf-8?Q?AGLdEif/Re9B6eimgR0ynILK6Yw0uFilWdmcc?=
X-Exchange-RoutingPolicyChecked:
	ouNzk2pQFMvu40HwA1EIUXRdfX19GFB0CdEN+VIy+G5fFei3BKub0ZaE00HGNvSxV6XSHEwlzMyE9VCOrGW1w7BYS/3C/ISQbszGkbrdRy+YqP2G42jxR4tO/TN7Vx47rNEMoqvbafIF1Wx6kvaJeoIX3ULAO5pRcC1VXAOCj500KyWJ/fQYFitEYTSwpX04qb1Mq903Sin67P/0v5l3UwPjO3vMd89+XleV/by6iaVID5I0j1EQ/NTxe+qxSbbCV14JgqUyE34tEYGdPigF0f5hN021Sbla1QW/hGCJTvJKqecyBqYLQiCGZo8g4TiElmjj+hdteq9jsGi5JotQ+w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	scDrBcGufmx4W5BgjG9M9WtKy5JgmrQvNtSzBKGijBasECIDKNGbhDrUD5nR3IZ3XJRDZhRIzt6SQGHoookePquxHHocO1UOhwge7Nx2d0pnFU8eRlype9ZAO72A5SHKzc/xZFZXJ9OsKp8HUE+JzDasC1A+2se9SK7ASw4inWL2A81fCBIWJlQZ4Ngx3ZRgJ/uDoTe9nNmxkDtt5IV5R6tPxGMMt9tlOm4RY8jpSIX7OWA+wG4kKn+iXRMl5HSrfOFyjp37JTNFxRWsDrBvLhoF7t0Obi7lpUCw0GTmNbfzQXu9BvazrGZEY2KGQm88B31Ng94FsX4YheQNPgilVdyOn0mb5Zsnb7scUKwMeBJivodxotNv4TJ/i6sD0Blr+tjQWFFRqeoCglKpEW3pEtcwXBdf52ytb7GCgDVYMQX+QWiIxmHSZjJ9kZco+DCqWjRy1BzaFS8wEKshuqMos0u3LU2jUu0Gj3ZyMI8nJ3e1t8V/Vb/wy7CLyAo6NQ9GqOxzkVwdS7usdML3VaYVg2xs5lZhMCVYPR2hKkHNZeAC05O8etOmXHLEadLpYAg6bu6B3b2nfFCJwPHupEHvuWfph5WUyoi4RwEsWF1i1hQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac955c7-cf42-416d-e0c8-08df474c4479
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 21:21:40.7510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwEimp26tr8MmlhoD1itW+H9xOlb3lp15UfmhyUWxF431k4pLLd9APTNJ4shZSH7QfuuQ2Tg13UORea4/UwkxeqFCApmL4aDL7ozaYgWH21FbdmR0o4LRNAW93RnrBXo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611200084
X-Authority-Analysis: v=2.4 cv=f+Ldl+yM c=1 sm=1 tr=0 ts=6b00b9e8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=xGAvDSoXAAAA:8
 a=VwQbUJbxAAAA:8 a=vz6jdDRJZb-oPu18MAAA:9 a=QEXdDO2ut3YA:10
 a=I9AbH5bZuplaqbmfSwNo:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13532
X-Proofpoint-GUID: vpGroUIPBTyaCN-wOOX142LrgxWwsBGP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA4NCBTYWx0ZWRfX5g6h0BgnUiyJ
 YCx7pQisJg1ruvm3l5LCZkwQwqWSS/4j3OHcLaKvlho/1r5T6GjzdkvZ0CvqLhZBvaYIfuaCd7j
 IC0KVOVc9pctl3CiNhdFZEYu8Y3n9Jpw72OPNUXsl5nDVVLXUy+M56sBVXT3ZszsdqTGIc8z3Ro
 9+m4FAwjuy5+qxZSiN2bcuBQp3V0tmsKyaE3bdREXjBQdR0nYTrU9YAB+Gry7Q5dMUyvvLW2dfq
 N94hhlF/mSz1+yKeK+BSV+S27hHAmNtk0UcLPdmLjEhpyGJ4+WZGEnTZw5opRc/AbMdUq1jHlcC
 aWI3UfboG/up2JPmJq550S+gKo9eXV7zt+iHUPAUOehCH6cfuZJG5uS0zhiuHNIn45omNZIbJ2m
 RwRg87S4QYPMtaizNze7wPeNgo/SJ2zn48osdlG8Sa04xiYHIhzzn3hl51KxRHZZxv5W7VXnJkG
 yQTubwLsG/nKG4WaXOQNIFKgGmIZKmufbWyqUMDU=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA4NCBTYWx0ZWRfX3sHHAu6iY9ip
 Vg5FV+mjgrcn5uSF7LEHlK3g634qyKQ5IxOcyjZZuj3ST/eiZn/9/fGReUm67C2g+HU54pXGuSx
 TySrLjbZuau0fvH0nWzKJ5D+6j9qIno4pYeFuEHkAv+2gnUL3nN0
X-Proofpoint-ORIG-GUID: vpGroUIPBTyaCN-wOOX142LrgxWwsBGP

Hi Greg/Sasha,

On 18/11/26 8:05 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sean Young <sean@mess.org>
> 
> [ Upstream commit 3982d2eeb1bdf7a9c14e4ff69015cb456f11da51 ]
> 
> If usb_submit_urb() fails during probe, then the error path is missing a
> call to rc_unregister_device(), which will leak various things like the
> input device.
> 
> Fixes: 42844992664f ("media: rc: streamzap: Error handling in probe")
> Signed-off-by: Sean Young <sean@mess.org>
> Cc: stable@vger.kernel.org
> Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/media/rc/streamzap.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
> index 72f83c09a3d9c..eab405662c65b 100644
> --- a/drivers/media/rc/streamzap.c
> +++ b/drivers/media/rc/streamzap.c
> @@ -403,6 +403,7 @@ static int streamzap_probe(struct usb_interface *intf,
>   
>   	return 0;
>   rc_submit_fail:
> +	rc_unregister_device(sz->rdev);
I ran an AI-assisted review and checked the cleanup path against the code.

This backport can free a Streamzap RC device twice on probe failure.

streamzap.c, streamzap_probe():

     rc_submit_fail:
         rc_unregister_device(sz->rdev);
         rc_free_device(sz->rdev);

In 5.15, rc_unregister_device() already frees unmanaged devices.
The driver uses an unmanaged allocation.

rc-main.c, rc_unregister_device() (spacing adjusted):

     if (!dev->managed_alloc)
         rc_free_device(dev);

Upstream (3982d2eeb1bd) ends unregister without that free:

         device_del(&dev->dev);

         ida_free(&rc_ida, dev->minor);
     }

The extra rc_free_device() is needed under the upstream rules, but
releases an already-freed device in 5.15. This error path did not
have the duplicate release before the backport.


lets drop this maybe ?

thanks,
Harshit
>   	rc_free_device(sz->rdev);
>   	usb_set_intfdata(intf, NULL);
>   rc_dev_fail:

