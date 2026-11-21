Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795268594;
	b=qDJTE/BotVzzKvHGY5j/J7xgzC/Wz0Zol2NxBoxWlTw/2t0vXuZLm50Y3IMB4/6tNPo9
	 NWw0VZOz9HB0XcmB7ZopZwnnEhGxsEkNhEpMw0aY2q6mHKI+ljh5beHrsyIEILjL+/RCv
	 cL+18OGlhnISoG7aRWbfyiAKcHdkoiqzu7Sp2qep0UcvgwyMDAiLRm73eZkXlRdZ6ppZW
	 Pt54EoBFkG/90hHW8hRnRUepXxA8bMdzIK0HXk4As2+EFzHFfOry7tpeKX8KFWx2BOOv4
	 2O1oejkFQPt3APsI55yJRX18SIAkmfeW6T857h8MM6FeWMX7NK2GHrHGMnZZIYhm6CQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795268594;
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
	bh=AY/bUgRIJ5kQvaWogb9cZR0rDMepgQoRQgaNUWD6Ebs=;
	b=uTbZKaV+itCT5QdskHrr1Bjd55Iwesr2te1nAFCAbI1DMz4Q4UUal0GupjmTG0g87mQv
	 /wYVi7DlzOgauVAPGBps6S843I8qbiHmICXUd44fq2rYL09K/YshKrdl/aGdqTkwHQglu
	 NU5p8HEoz/s4cRNLl119pXHhMdCluQksDM8PiPVUoMTEXBsAwhtKng425DPub2Y5NnyaK
	 wnBr4KY3MdCEwQX1vgfeIUqZRxJ/P0y96eTKS5KMoL6eU2Xe0deIuBQAPsD3cu8HsjLHL
	 DJeEBz3mEiGefRb1tLstSI0dOece96jZQykCyY86lr9X5CcTLsHiVW8d5oe4HEqsuVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=hk553Umd;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=is9Znuc2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C74606A320;
	Sat, 21 Nov 2026 13:43:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9C74606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=hk553Umd;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=is9Znuc2
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALDhBBq378088;
	Sat, 21 Nov 2026 13:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AY/bUgRIJ5kQvaWogb9cZR0rDMepgQoRQgaNUWD6Ebs=; b=
	hk553UmdC6l4nfh0u8IFFas1nHxjKHDbEUNPXYV5Btnlf5FV2Caduw5Y7Bfs0yYn
	LGdZXQZ7u+NzJdASVUNqP/xwdtsxZoX+UQBlRjTwQwwlrL5AY3H0sPPIfEdp4nmd
	uwrL2hZtT/z7QdI7n5eMxulwnAByKh9c31nSDkGaq5uZM0YOqLJVHg7Ise+mPQuK
	DVa4YkEgDcaUPsophwy8PaVm9tjaXx515zZHMHWqG54nyWbjcD+t3lFa8Fp/FWB8
	QHbpD3XmcdxbAlZ9H0JMYgUix9sYBKHS95RG41XBPTS+Z2a91to5xykLdNEOHa3N
	zdXvVKlHcoWgmJNa17svZQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34ts86n2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 13:43:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALCI0fB2582066;
	Sat, 21 Nov 2026 13:43:10 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j38wf3gqq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 13:43:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YyMO8ri7EiEvtQ1J9WcnGjwvE28b1XwsJBGu6chhEkTmMz+G1ICSm3gjMZXngtV13IDeMvltf1lIJez3Y75ZCOUvWLYlLW4A0Zt+iw7M4GFfDwagorJByNJxNzffHDNVV9M79x5G6fqipLR5eB8235aGbHytmDaMV5i0uADguS3DXlpd6oJ7yhshvzKEOqhPvbIikYGPlzBn3nfUMNzcU5+GGWkdEotc4tLhjZV2+2j4HEIHo7Zccb3mUH1V7Efu9Xp0kKuu2/JiSmuKGw63JLdP3CgMUaLeEsH4mjWShXxbtpzp77IPGUQQntXo+vywDSyqkZNlrinGcCbLJqPm9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AY/bUgRIJ5kQvaWogb9cZR0rDMepgQoRQgaNUWD6Ebs=;
 b=L3DM+C62YV8tG3eTBjJZymIbxVSA+pLUk8LZvnc9EFBizosc4ptO3AybkRtVG3jKg6nOO9nhBS/MLVSIuDLlGrr5+HteC82bhda2VXhY6rWyGWGRPMTw7nYXkHCLssMV4zNseuG9qDjLoWEQknUVq8X7lBmsnzq/4bFTZiCMGPWrkeB925vMt1xsoWNBFlSO1buxGVV8gj2r2yK+hynm7A0IOzqMvQGoZ5zzCWmuBqLYlJhKQYPIb5npqLBF0NyE0HXNZ7lpCJT83F7slmMg/najg+GfmjkUqkbD4wHgieHRtZvvle6l6Aj1oWnq+OwNVcLAYSkQgDpn6B6vVnNivQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AY/bUgRIJ5kQvaWogb9cZR0rDMepgQoRQgaNUWD6Ebs=;
 b=is9Znuc2BD8BKfEKL4vmNQnWpV7r44F9CcexHrcl+HogPq8C8HJHZcFpEbvk2cOi4JdF/LvlJfX+4KrZZ/AwT7SUAWmiek3MgW2ygU3XjfoBdfCKerCOx6KJwhWOOe5zlldFgxPmjw0jryDkkSH0wMxDFMn48+nYh19Sv+99HYs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA1PR10MB997556.namprd10.prod.outlook.com (2603:10b6:806:4b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sat, 21 Nov
 2026 13:43:07 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 13:43:07 +0000
Message-ID: <c9347c65-780a-4676-973f-a6dc8970574c@oracle.com>
Date: Sat, 21 Nov 2026 19:13:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0756/2214] NFSD: Set nn->cld_net before registering
 the cld pipe
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Chuck Lever <cel@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150041.981632372@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150041.981632372@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0091.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA1PR10MB997556:EE_
X-MS-Office365-Filtering-Correlation-Id: 5685afd8-1e0a-46cc-4d18-08df47d55fe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|4143699003|5023799004|56012099006|261022105027099003|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261026121527099003|261026140227099003|261028144727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KEV8fa8MEdrlgZCDHAywLSYdgnZDhB5o5Z83U/lXLQuhEpYGaDZ3u094RrHG7WSPQMnRLPSyYxhJaMrfCLAzB1hjAj2qhAM/OpVsWFnKXrM4NPZKbxHYjTnnhdrCgAQ80o1nKdyA7JTnTWo9jzTex9RuTCAvnI+J80+LJOyCSaZfSb6rCvmQ7Ozl4THFMaLi7kSqf6HA7+jsaMfh/4UVIIq3LGBaLRtf0vcV2krxPCZiuE+m3lKfBdOVz3FM/++1VhJOqGI8Ak2fphMadgNpL/ON/ftB3SaCP79Pg8vFASZDF+JN3U7BFHWqlevl9UXOkw87S/S9DTeWqsHPeMuimavS0CenUP79tUVgZ91zarXp00LRFCBdkMfEyKt/uzPv7BK52MYRZGhFdca2Xf7y5UG7KQbwrCi+cQs67e/ebQXQgNUh3/RTyJIJpLq9YBLmOk1QCcqomW4io9OW1M8X+nf8ly4jfisXCObb3cpban0BLsS/kPV4eJewFaQB32LxwhboYg3BcG7VZ0LUDqV4CoheStNNmWTQOo3kUAOpk/sp9CuTWfdSUOG3f19kDoyGt9sGnxE60JhJSXG59UFI6A3g3YW5OXUSno2hUyooONVS79oZeMb6BeE78VoVzJxp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(4143699003)(5023799004)(56012099006)(261022105027099003)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261026121527099003)(261026140227099003)(261028144727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTNldThKYmNLMzA1S2NOZ0YzQVFpblN3TmZvWmhLTEdOYzEzS1hTWXNLWkZW?=
 =?utf-8?B?RWFOcWxmTXlTQ2R1UnFOajJKU2c1TGZlU2VmUjdSRFNXNUtIOTJrcVRNUUJk?=
 =?utf-8?B?dCszYjJwQm1VUWdqTVZncTlZSUZJU3B1b2JNRU4yV1o5VFQ4K1lNL2M1dExz?=
 =?utf-8?B?QTlQRjN2eUs2Q1FqeGlHS3dTUERzSFFuN3JEZ2hreFlNOXF0cWFWNVNaRHNh?=
 =?utf-8?B?cVp5REVOcGdnZ25yU24vWEVicUh4NUoxenBjVGRhK3FlZU0xVlp1aURERlcx?=
 =?utf-8?B?d0twQ1dxaGplRFB0K1dZcDlDMFJYb1VCanB2VzMzQUk4Z3grbUM1dDFseXhj?=
 =?utf-8?B?L1l0NjZaNkZIRGE2NTdmdXU2WVRFc2JvM0t2TXFocCtpTTF3WVJCeU1Lb1FN?=
 =?utf-8?B?dkVqL0lFOU5NYlhIYm5rUnl3dUlLVFJERFN4RnZkc2Z4WktOTXZVaUFDVEd2?=
 =?utf-8?B?ckFLM2QvSnNFTUk2WVRnZk0xcHJaUmV5WUhNdjN2WVMvcWE1ZzFiRzNkd0ho?=
 =?utf-8?B?WjNGcml4cVhWMkVnbkxTdXIvSW5yZkpRWkdQbnJLc29YeFBKMllsTDJlSkc4?=
 =?utf-8?B?VFZkTk50Um1QY2RxbXBvV3FPSk1ReXFrM2sxUUhuOGxaK0s4Qks4OXBqOTVr?=
 =?utf-8?B?ZW4rY3cvRjB3azVjd081UzVFV2FZMVBnMXEvMzJaTENrTFltWVh2SFBteXNE?=
 =?utf-8?B?Z0E4VkpvUkEwT2JpR3E3LzEveVo3NUpnZVpvUjlyb3pzMERza1Zla0tobWZl?=
 =?utf-8?B?RkMzcUg2Tlg1clFFYll3eWwxR2VyaVRhY1ZOVkhmeDlXNHIyZUZPSUk4cmJx?=
 =?utf-8?B?dTYyUElDeFBiVjhGb1ZrQ09WMTNBeFd5OWgrak5lWVhtQnM3eG9iU09rNmha?=
 =?utf-8?B?bnphM0NnWEs0N1JQd0FMVXZhQUMzdlUyUmxXdTJlenVpNGpJYzBSU2xpdHVi?=
 =?utf-8?B?aDByMDdzSzNBQUZUNTdET2w0c1VYellKRTh4RThua24vdzl4ZmdoYlN5d2tx?=
 =?utf-8?B?NUZrTDdqVkRvd2Y3MzZyejY5MjY4Sm5ibnd2amFGcnhCWE9xYTNROTZ1b2I1?=
 =?utf-8?B?WXc4cVdUR00rWFNKbnZjUTVOcjFhYWVlWStqemVkY1R1R2ZHWThVUEFPRlNs?=
 =?utf-8?B?MEw1QkZaNzdoMFhzY0NQMTk5Wk1PMmU1UVRZL1lPRFhFMlNlcFNJeDE3S2Va?=
 =?utf-8?B?bU5SVVZXWm9RTzBSV2tHRFpxVm9HaXFqdmhEVVFmeWlKaUtSeHJZaWdoaEJD?=
 =?utf-8?B?dGY0QXVvTXZpYllrMFhlOW5VWWVZR0lweEpFaFNFYXhRUE9Gbnc3SGpDT3dJ?=
 =?utf-8?B?WFNNN1ZIemNoVHdoSFdDcjUxK3gzRWt0LzhrOEcxVWV0MTc2QUR0TFpCaFdO?=
 =?utf-8?B?MHVvUUc5QkpDYXpZWmIvRTd6bHExakRpQUhwbzNXNmg1eHdQUm0xRGZDMFdS?=
 =?utf-8?B?ZlU2RDhTSGdERE1pQVE3OWd4b1R6b3czYURZTU9sMnlza21PbzU0WXpNL2dM?=
 =?utf-8?B?VXdQRzRIYkFkRkF0dmhVWTVRVEN0alBIdXZ4cTdSQ2lWajdOSFlTNnM5U2Ji?=
 =?utf-8?B?bm9EVHNGa0F0VGZBc1ZVaDhMU0JNV2FRdjN6bmJ5RWwvOWEvUzBFcnJrL2ky?=
 =?utf-8?B?eU5BVkVPR0ZZZHkvMXNrMFJtaFlqNTYxSmtmUFhFSU1IQ2JOZE01azFlZk03?=
 =?utf-8?B?WlpKcGRCd0lkM1hiUlJWZ0UvOVV4QkltZzRjdnRQYndpREdYVmpIOXVHc0FY?=
 =?utf-8?B?QnZWeWtWSDBkNzlZTHhjTTdHSUZ2V3k5MkxwdG1QbjBoRyt4RG5GUFFkcW43?=
 =?utf-8?B?alNJYnd6eWxTRnJtMno3aEgxQ0s4ZE1vNUV5Q1hPZVBmUHp4VytsdDBkYzlK?=
 =?utf-8?B?dTRFdWNxU2xocHZTV09ONTlRNWZkL2xJS0ZtRW1tRkduMGJzamVDNmkxTXVO?=
 =?utf-8?B?NFJiNDNIUno1WVFPUDMwNHczWkRxWFRGMWNqV1dqa0ROUjdzSFYrbTlwSy80?=
 =?utf-8?B?UFZsTnc0Y1dlSlAzV2VoK3haU3NHVGxrcGliTDRKcHJwblRiaWh6VWI5c1hG?=
 =?utf-8?B?NWx3MDZZQlljdWx5TjdQOXRaekgxU3o1RGZKdjVBRWhKRlNkS09uMUxSS1lY?=
 =?utf-8?B?N0ZHSGs1TVpuZXRyNkQ0VG95QlhRVGZRdnRxdmN3dm1oZmJSd3RJQm5GV3c2?=
 =?utf-8?B?b1czSXNoOFh0K29VMkYwR3RKcXdPOUtiNUhoWXlOZktUSko0UXJYSnZpcUpV?=
 =?utf-8?B?ZWlHSnEyY0R1YjJqK3NSM01HYm8vUFNibDF1Q1pSMG94WDJZVTlvc0l2SlBL?=
 =?utf-8?B?TzVwZU9DbDExQ2V3eUQxSWJGeTA4Q0U3RVJHZDBBTmhHM0JHUzRoZzkwSm9C?=
 =?utf-8?Q?Pd1G/Ft0zHoPgGvANWA0Q5wzOYij65NgEuETv?=
X-Exchange-RoutingPolicyChecked:
	EpLSY7x++dc0oKR/RMvRxce99TL5fyykli9nEGHl8GsoJkaew2mVmhre/kXBtaBZmyg2z2247CzymdLQjxqHbpiWEf38cf7HlsbBBA+u7sD7h8Gk7HIBFcP3RyhpKgFD9IQWX/g1OTc7HS06Ix6hHeUX7amQnPL4a0xgJdLyk1dgYE7iw82cWq16hnLitGS2rJFEh16Oq4io+BAQKOtibKDPq37EhLbGfLxYYtHN3OwQmV8Qyi6dXzzRUZic3JRwLTWymt4rkPy3kJ+Nppp4S0VQTCsgmc6sEYfphYsypLUB4ziqSRDJIV16sfNrQ8bmfPYSqL4623cMrv7yanqJQA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uin4D5fZwwFTKoo7VWqtOFe1f/jRoqrJYeF3oYUfL7lEf6DqBHYSYo4kKYEol7sGpuwHm/s2xnklmycr34kTosqqhopsh1x/omnMrx938fvJ2PK8AuzYKmDokB5h8SX/08CXvdik6zIVP+vb7m4Xj/xhxoEVx0PYS6A6SBbutx62xMbquicjMq35apwKak+ywLQkQZikbVzXh6IGy5N8678aRqy7QxnVR1xhmhXR4J+ibe0tuCCPgbOCwHMGd7vAgznyhEyHuz5X/WU0WK28cnNoncrm0Fstqsuu7MLnilSLVgKfdegP07N0OpOB67yYO/e61IRTfwD28h6MVuokuTXVu3bWmyVwBcwWbYOSHaYW0CkqXHS61S2QkgKRp2E4gaqF+D8jOboKt/ZOR70E5GY2kjURlnUw9UcG0nRevE5ull/is+FEYYh21TtxC0yMTXAG5vXm0aIxxgSEHfY/ez2H/wF2rUhLhXQit30NYE1cBFC2rQ7D4RZf6Zoe/UxbLZLFyPhz5Z1MPr8/wtC5qf/vCFKoyMxQHvY5mCmmozzwbN4BiUOBrfvfF2CJyEscrW2FEHruV0ntPfGb3hjZ7/MGyP8/Tjc6AuY792RCEUM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5685afd8-1e0a-46cc-4d18-08df47d55fe5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 13:43:07.3251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jw6PPZ21ftiNO7TKqlmPgHrLTeERP/ShHLA2pH8GIDZIFsvK4jjQ1zhz/5wbHfPSec0hF1U8ZlZnzbpyLWJKFcx0buBCOBj7PE0416P6zvR30ILELmZkr5EP1u+CVVMU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997556
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210054
X-Proofpoint-ORIG-GUID: qIjgqcnMmQeRaIfZH7sZJWMtuZTrOLsQ
X-Proofpoint-GUID: qIjgqcnMmQeRaIfZH7sZJWMtuZTrOLsQ
X-Authority-Analysis: v=2.4 cv=YP8KWhGx c=1 sm=1 tr=0 ts=6b019fee b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=6TNuU9ksUjpCRJWRISYA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12101
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA1NCBTYWx0ZWRfX3K6GwkFprawj
 K0ouNIHaNYlIEij9a/nmz1p+AZcZlCI7D50u3jlHhH+vl89uFI3ZZV/o2dOAB2rXzcmU5uaHmu7
 7+8H4gGRmeYRl2s8xu7WGSwp46nzACwqR0ZdWWMZqGoFZ9VhG5Mz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA1NCBTYWx0ZWRfX6R5GlmbCmrok
 Hff8fJv90wfr4W9NyuG3wpogLpOOurp+ZQmrVeBBiH/PEWFQMB8ffzsNGbts14SAGQB+aAIHZ8x
 3Qlr/cmJsVfEayeaxdcDMOeh2HJQGMh1p1KBeJbemHWzEN+Ze5xbridjJBx7g/Lq2ycJgtwJhYv
 FJHO+y/tIs7vgAiRy8LcXaB71GPMfHO7uyvMlshBVOEXzj7z9hxaQlWkOIPQDMDFeuidk0rl3L9
 kMlOXvSOyUE4XKmkUtTVZK6HTRgyq+l2qR2G8TezxZ9xhtjS02noT2gnC6dotzEqelvNbul3XIT
 OEfGFsPdYE+ou0VgjXxkrd5tsNB0yV71MtewkpkrGbpElE88o/y7MwJJzpdKzUWnlHhUfdA/Jwh
 lJHRl7XAuLBEUBTiqQO+VQzqWtJw7LOZaJu1eno1Y1dRZMwBSGLTHU31pmxORz3GlniIgnzPBQt
 0mDiYfeVIeAxpzdGXYQRc5han+iED3CTSMkCaciI=

Hi Greg/Sasha,

On 18/11/26 8:10 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chuck Lever <cel@kernel.org>
> 
> [ Upstream commit 14996e662f3b734427e2d645cacffc27b779f7d1 ]
> 
> rpc_mkpipe_dentry() instantiates the pipe's dentry before it returns,
> so the cld pipe can be opened as soon as nfsd4_cld_register_net() has
> run. __nfsd4_init_cld_pipe() does not store the new cld_net in
> nn->cld_net until after that call. cld_pipe_downcall() reaches the
> cld_net only through that pointer and takes cn_lock without checking
> it, so a write() that lands in the window oopses.
> 
> Store nn->cld_net once @cn is fully initialized and before the pipe is
> registered, and clear it again when registration fails.
> 
> Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
> Cc: stable@vger.kernel.org
> Link: https://patch.msgid.link/20260901-alemi-v2-6-e163f94a3a6e@kernel.org
> Signed-off-by: Chuck Lever <cel@kernel.org>
> [ sashal: adjusted context around dentry-based pipe registration where cn_has_legacy is initialized unconditionally ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/nfsd/nfs4recover.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
> index e0cb4856ca565..21917c024fb20 100644
> --- a/fs/nfsd/nfs4recover.c
> +++ b/fs/nfsd/nfs4recover.c
> @@ -1014,6 +1014,13 @@ __nfsd4_init_cld_pipe(struct net *net)
>   	}
>   	spin_lock_init(&cn->cn_lock);
>   	INIT_LIST_HEAD(&cn->cn_list);
> +	cn->cn_has_legacy = false;
> +
> +	/*
> +	 * The pipe's methods reach @cn through nn->cld_net, so set
> +	 * it before the pipe can be opened.
> +	 */
> +	nn->cld_net = cn;

I ran an AI-assisted backport review, and the finding looks correct to me.

This commit in 5.15.y publishes cld_net before registration but
retains the later dentry assignment. A concurrent rpc_pipefs mount can
create a pipe whose dentry is then overwritten with NULL.

In nfs4recover.c, __nfsd4_init_cld_pipe() now publishes cld_net before
registering the pipe: (Code spacing adjusted.)

     nn->cld_net = cn;

     dentry = nfsd4_cld_register_net(net, cn->cn_pipe);
     if (IS_ERR(dentry)) {
         ret = PTR_ERR(dentry);
         goto err_destroy_data;
     }

     cn->cn_pipe->dentry = dentry;
     return 0;

If registration finds no rpc_pipefs superblock, it returns NULL. A
concurrent mount can then create the pipe and set its dentry before the
last assignment above overwrites it.

Upstream (14996e662f3b) returns only registration status here:

     nn->cld_net = cn;

     ret = nfsd4_cld_register_net(net, cn->cn_pipe);
     if (unlikely(ret))
         goto err_destroy_data;

     return 0;

Upstream leaves the dentry assignment to rpc_mkpipe_dentry(). In 5.15,
losing that pointer makes teardown skip rpc_unlink(), leaving the live
inode pointing to freed pipe data. The parent published cld_net after
the assignment and avoided this race.

Lets drop this ?

Thanks,
Harshit


>   
>   	dentry = nfsd4_cld_register_net(net, cn->cn_pipe);
>   	if (IS_ERR(dentry)) {
> @@ -1022,11 +1029,10 @@ __nfsd4_init_cld_pipe(struct net *net)
>   	}
>   
>   	cn->cn_pipe->dentry = dentry;
> -	cn->cn_has_legacy = false;
> -	nn->cld_net = cn;
>   	return 0;
>   
>   err_destroy_data:
> +	nn->cld_net = NULL;
>   	rpc_destroy_pipe_data(cn->cn_pipe);
>   err:
>   	kfree(cn);

