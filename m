Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795209957;
	b=fOjyEgXfVC6Mo3sy/bbhH8+C4WHp4Q/t78J0iVEEXH5A7eyrFhO3J1kfDK5mFi6TucWA
	 1XATCqjer74ZyMlLLabJ6bbpqXA3CHYIcsVNYzP52apgCJ9ZzwJZFWF2AcAnbEHR4+zS9
	 llkwqXsjhGY0OpZbp+AJqfbjjklAu3CCM+pGJbQypSgevd4dS8t07IlSHnoZQMC18HaBi
	 XSUknlHhnL7eJDOaWpxDWeq5W/opjYUPJnZ4aAAmkoaOakIKsy8vQ3LvcYL7SRGMcNqzG
	 ZPpCPtzSHQ1G1LFmf6DLbmwxHHQDy/FiExfhHk1QKFH26ununlzsxb5uCmicq4QEnaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795209957;
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
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc;
	bh=+VHV7iwRsaJ/73e0ioZVbbE5n0dwVGok9a7fJPIiYZY=;
	b=DrLYoeHNcE15n4gcc8M01jtS3gT6+8xAsRJUt14HGfZPIP3oLvzai1MxNw4xC5VCFnCk
	 gDxzz9O7PxcT+e0SnL5rj1D7lTvvE8lnWE81mqrZh0T3hsTOCXIgfDC8KU+rqEQFRH8h6
	 uqpKbgGXv/ARulIK65QON6DW8D6pY+g4JzSX+9XuGWXRduAmWXCfO3yRNip0rqyCKPzqw
	 XeffM+1GVaFyOeB+kXMQEkubhueqlMI7DCeqgZtaf+V91grflTs2lJZP1vceCN0lcct6w
	 blsm1zvWhf6Zi/Bi/qv1tSPDw0UO29QHKbTwSRx0f3jIORuRE3V38CEgoPvXj94dB1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=g9NzAvq6;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=nAHr7mjb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD33A606A69C
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 21:25:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD33A606A69C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=g9NzAvq6;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=nAHr7mjb
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKGkl9S219619;
	Fri, 20 Nov 2026 21:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+VHV7iwRsaJ/73e0ioZVbbE5n0dwVGok9a7fJPIiYZY=; b=
	g9NzAvq6/XeAMPTJiIiDJ5aFwJ+eXqa+TUB1HT1y0WvsnNKd+KB/3MtoSCBURaby
	U6OppuQWkguXwU/MgDvUT5wRCj5bag/88fglHklc1P0KPEHKfTX7XMm7++RhUNIY
	qNs55Mmfb0hCR8qieGbITozryxW0A7cAPBeVlG/ybPFuqPNrf9NRW8UTfdwkrwuV
	d1MSw5YkXorvqvI7GGBtROcYG83v1yiRIhXMX60Lt0sLdCB+G7RpaN3IixP+0IjL
	T5dN5JTyGUseguc54R6WK3t+alkpqotmpGaB/egsahAvrN1BxdfSLNQXWrDrNy+7
	Temv+SUV4mFDuyiCQI3zlQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytqdak2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 21:25:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKLA4Tu1846041;
	Fri, 20 Nov 2026 21:25:41 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010021.outbound.protection.outlook.com [52.101.85.21])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j2vdr3m6w-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 21:25:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QmJGimRHH9mTngfnA7a3Bx7oGR88KrOPM3Wc1ZozRpgMWw4DjHv5fe3WeCJeIo7/Vzoq3bh7u/r+32WSQj2pagKo1L3NOlvjIOqSP/qVWizdAfskzZS8PYvEnsXjzv2gEf+CUNGKhbszkXnSED/14ZL4QoJFv+BvId+1UAdnMgk44d9ps51z98FKbfhSxRDuyhMoKGV9dlFqjNZXWWw44P+S3cVfdXRGW/GGJXrPgUVHdXqyuNGlZninvDJUuS9la5qKq9mUzU0x8inli0gvfES3p28/2ucrOX8VIJiZXb2MS5BVCmCQU68BGo0QZudkmilWWHy+vZmkJdqsFMfk8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VHV7iwRsaJ/73e0ioZVbbE5n0dwVGok9a7fJPIiYZY=;
 b=IY4R+F57/r3zUaysbnlPr88uRLO1IqSoDLuYAilOxizqeI4Q9Km444HVvxquEl2vMnQW/L4HPbcT7GJbE4qJHcX2MH+ElRsSvxLdVspQz9hcOJ32HpNmYQwny2foWFOtVyhRTutOi70jPAQXi5nhp83JSU8zPtJZkIElH3esITKjjqFcE0dL5WRHDWuip5+zOdF7JrAjhwdjXkq0vwsdKqdUpoSz6WlDC8ojuHcnzim9FkFzP3u5rlslAjN1eWZ0vf2fOk/mrH0hhQId8xtq5zBeFsxKrXktSfMPt5BGe1A0W/MG8wAqZFMUjTZRYnh3vHqvPWSXPqkDtvTm3BpClw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VHV7iwRsaJ/73e0ioZVbbE5n0dwVGok9a7fJPIiYZY=;
 b=nAHr7mjbcJP/Ep/ADS3HuS6mm1TtPtsK8OkwYlPfEcp1bvykN3MSdQPAIVaggDQZVIHNvElbHLIEeiC8G5G1IUTLWVpmR0yqGYkKUT7OR0qvGdMXxvGBBK+AlyvZl+LvW2GupXqnxhKgkM4jKBU01nFCRFToWHEO9BuJQWhMsGY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DM4PR10MB7452.namprd10.prod.outlook.com (2603:10b6:8:18d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 21:25:37 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 21:25:37 +0000
Message-ID: <7ba937e2-8cb7-4e87-82a2-878b06f88478@oracle.com>
Date: Sat, 21 Nov 2026 02:55:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0591/2214] wifi: mt76: fix memory leak in USB TX path
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Devin Wittmayer <lucid_duck@justthetip.ca>,
        Eason Lai <eason.lai@mediatek.com>,
        Hans Buchheim <hbuchheim@gmail.com>,
        Sergei Melnichenko <sergei.melnichenko@gmail.com>,
        Felix Fietkau <nbd@nbd.name>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150034.535885474@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150034.535885474@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0045.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::14) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DM4PR10MB7452:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e926ba-5aee-41db-49f4-08df474cd18c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|22082099003|18002099003|5023799004|4143699003|56012099006|261102123227099003|261026121527099003|261028144727099003|261022075727099003|261021135927099003|261022105027099003|261021123027099003|261009223027099003|261021121427099003|10067099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	btsQQr9Vxai3UOOv9z3qwYNAai+iSX5t8ykpS+W3lIoHK5juP6CWtThI8WLpQx2zNtqyI9M1CYql85ZvJbcHXj0nC8tS+B2ZDa0lsD8cEyFjoJc1s3o5ZBbfv8JovYcsPwknkuGZf7vAKvDQ/nQgDgtP5+hbXl5KKWTZe6Frrv3X/HOh4TI0841rASO+VGERPQsDhVbhvjm97ClUaFT3lc889wrkrKRbz2n2n6SVbQ97FDNoXwlZ5QcFb++1QKVXGmvbu3qUAtqW3kQDhyz6gC0wmnsPQ6IDhE3wokg8C4N6A3V8yf0ZZBx6QlOVoLol2PkmbtZFCOoHCBOvLsXom+Mj7Yhdp2hHZd2AOnx7VxvP4wP9W+3SEtdKtXtN2btKS6Iv9vILuuoc7W0Sqgqs+nyDEZ+kgUq47hU7tWTqHXJRk2fyNkezUuoA7btkC4rL9pWh9QrZW54jjnaAJQnKyksB99uyuIGiDddId3gUzTBrAOhZ+oPz7UhpXD7ePjW/KR1bHYXR4tWngALk1Fnh8fMq0NDdsQ4DPV63zRi3wwM31RnbML8961iA6QV68Cgo1qmDhT2fLLvLaYQMbnFkiTYnF9AibJ8owCLahffrO7/7bZAb2hVtgZJASDveGgW7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(22082099003)(18002099003)(5023799004)(4143699003)(56012099006)(261102123227099003)(261026121527099003)(261028144727099003)(261022075727099003)(261021135927099003)(261022105027099003)(261021123027099003)(261009223027099003)(261021121427099003)(10067099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OE52Wm1lYUcwdG10dHRHY2hwYjRhYWZnMmtGWndyRW9Dc2JPKzFndExoVmRU?=
 =?utf-8?B?aGlPYk9UU1l2L1NVTG5iRUpRQkplTnRjNVo4OFpZY3hmVHZLU2F5WEgvSnpF?=
 =?utf-8?B?S1FzeW4vdzI1L3lxT2xLcjZFaWcyK2VTYmxzOU15UWJ0KzYwTjlnaEhQL1Iv?=
 =?utf-8?B?dkVQSkplaXlzaTlRbGJrSDhZTjM2V0Qwbk1nT3crSzRJZzY1MUxIUW44TTRk?=
 =?utf-8?B?RC90VEw1aTlsa3NBWUV2aG51WUU4d05kNUF0a2FlQ3FJdUpGZ2tGOE9vc0pI?=
 =?utf-8?B?OEhTeW5GY3hKNlIzcnM3Mlh3QnhyajJPS0xwTmlLUk9ESEQwQW5WWEFZMGZU?=
 =?utf-8?B?aHdGclFWMG5KZWZiWklPenZoZHVYZm40TXpsbEc3NUYxWUh2NkhDRkZKdGdp?=
 =?utf-8?B?WUdONFFpdHpzMy9JOFduSWpMakdxcFNoYnlnSlpQMDBFSy9NVEgvb1lhUklT?=
 =?utf-8?B?QkxQd3RodStGN3RQeWpVWmtNSE81djIrWFFMRE9iem5IaVR3Yktta21nNFVJ?=
 =?utf-8?B?SUFPSFdIRzVOV3M2aXIwdEdWUlRrZm93Skdxci9ZdERDZmszaVUwdVQwRVNj?=
 =?utf-8?B?YkJRVzM0MzVZOCtkTEJ4RTJyQjJaaGlKaFZNWHdVRzdGYzVhQjNUYUZYQVlL?=
 =?utf-8?B?eVYvY2FkNWUvdmFsWlVDQ0tQOTZCelM5OE04NjljVUtKeWlCM2docCtFZENo?=
 =?utf-8?B?aU9IbTBhU3hjUUFINUIrUk12RkNiQnZaRjA4WnBSalIzbzExQU9jeHVqNFEv?=
 =?utf-8?B?Qlk2d25lcG1hMm55Z2JNWHp1SjBMQ1VkWm1lVWRKalU1N3owS0VBUzFUZ1Vw?=
 =?utf-8?B?NEcxOENBQlVoU21IVzNZdVhSdHZuTEZZVUxFUTNWWGJmMnJqS3pqZXdyTm5M?=
 =?utf-8?B?R29rdXRzeEhwWDB4dmRwU25ncHZJOStWekJZMGwxM01HRGhGaUZFVzF6T0w5?=
 =?utf-8?B?U0IyZkdhYm5YQ0czZHpEZ0gxVWVHc2czUlpCMjVFZDNPdHFIUmc1Ulo3OWdp?=
 =?utf-8?B?LzZEVEh4b1cvbmZYZ3dDRFQydmFuZjdJSmNHYUVpODA0aUdBWEhIR0xMZURu?=
 =?utf-8?B?WWUwSnhGUWpVb1BRUlkwTmNzbnJUTzFjNW80Q2ZvdjFwU3hjVEw3Und6RFBE?=
 =?utf-8?B?QU5yRytodU94REh0Wlh1bER1RHBGRHRoSzc5NUE2NWduZWRQRWY3TEI2YjU4?=
 =?utf-8?B?TGJqb0gzWVFGZ0M3b05HSjAyWS9MRFdCRno4QVB5OC9XbkhmbE10N0ZQZXhD?=
 =?utf-8?B?TFplZkxDRzU0NFZHaCtudTlVUnZUeDdXT2hhcXBzRW9FYnpKNllKT1RyL3da?=
 =?utf-8?B?Wkl3aWhXNzE4S21EaEk5NkxDNCtEZFFIRUxHbEFIQ2M4YSsxckpOMTRNNHhk?=
 =?utf-8?B?YzkxcTNObi9JbUpveEpKNkl5dTRFUXRvQWlkM3lhS2d5c2hzNy96Rk1PdU1P?=
 =?utf-8?B?Ynl6U3V4ZWo1SjFCZWpDei9YMjIyNnFySDc5NVBxeXc3Y0FCOFJqc3pZcEVB?=
 =?utf-8?B?L3g4OUw1aGIyUlhCS0dxR2s5R0NUT2ZWTW92Z3NhaGp1cmJVS0QxTDNDd0Uw?=
 =?utf-8?B?SEN3Q08wTXpWa1c0MUF2SGZ4eDI3YjFKU2V5TVpFcis2V2VDdXBMa2o5UU8v?=
 =?utf-8?B?LzNtUU1EbVdHS1AxcURJamZFT1FYUzRoVGJJajU2Q2dkYlVkcVo5YmJBUDNL?=
 =?utf-8?B?b3BrUEFycm92YStKTFVHNVJndjZLa3E0MVRNdFcyNERVYzJZRnlwMjhLeCtD?=
 =?utf-8?B?MlZ2c05odG5jK1J4ckxOMVptK3hoUWpzeEsxbDRvamlIeUJ3aWY2TmYxQmdQ?=
 =?utf-8?B?RWxUb1dqOXYwYnF3QzRpZjhWQk5Vd0s3eGVDVmNqdzhyV3prS3dHbkhBUDBr?=
 =?utf-8?B?SWhLUEpwK3lTdnVYcXNaTjNuZnB1QzJYWWdkbGFlQXJEUzJEWmtBclJkTTlR?=
 =?utf-8?B?Nk5kNitMUCttcjIyYnBSWXdmL3h5dDVneFNSR0prSlZCK0Zocm9NQU0rdnV1?=
 =?utf-8?B?UzhpM2RxS3l4cUpJWEFucm9PeG10eU5Bc0dyR2RxRytMZUVyVVdSWk40bnAz?=
 =?utf-8?B?NW5FdHZqQzZNY0pZQ3ZjeTAyRFZqK0pzbE5xZHZqWVp0UGc5OVYrU3RiVFBp?=
 =?utf-8?B?dW9haUs4OVorOSt3R1R4cHJzYVZPVTJ4SG5EbktXemZXUGt6QXhCZ0FSNHM1?=
 =?utf-8?B?OExBOFdDdVdveUs2dU0wMHVQQXcwN3FNS2txcFVldWxkaDlZaTlwbXczcWYr?=
 =?utf-8?B?UUVQVXB5Wks4RTVMa2w2SDVvdmU1Vnk2dENQZ1dYeGJZUGpaSE9FNXlZWjh1?=
 =?utf-8?B?K3NQUWFBQ3N6c3pBTUpLNklRVjBMUXBMMjNJTHNrMk9HNVZsSEF4NExzUnJP?=
 =?utf-8?Q?HxLN+lgpraQVhG9TPZG2w5oQorBS/e6YSgCYy?=
X-Exchange-RoutingPolicyChecked:
	EQ5rxWK8Mikn0k71XbGxBg30uSX24Nuca7TSmPQdQTHODPprQ3XvM0EXaD3TuJByxbbdSgojVZoWA7+ndjevLRLk29qDscgu/UL6P0V8VeFs0A8Ko5PJ/LiCzF5tQ8VrlJwGds/RyGaZiaeSd6UNlqVxkMAvoP4G/FJj3/cCV8o57gV6/kUhzmAdmJX6xsNUc9NN8afAVrn/a+aL2sYP2Gnb8cJQr6XFXWytoDq++JfTMKv+Q6As4bIL37CoAq63tozVEvrMrc3oOd1N786ommn4RHokhB+VNO66NCiKdE15J/QLMhKS+3L/3WlRZLPSK4cBPw3k5TEr6wCN98iOhA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PTuEFahL2/oS8JswpIu3FvXPFEbvxz23I+11INZttu05FbYamASZ9peqtnTDAfmn7GV9XtXgkAT0nygxRN681NMuKaQ900Mgpgxxo5WEOxRiZiLRWJmRmwl23Qb2igWmykaUku0UBe/PVuK+zz+eamT7ZrItuwBAm4wlXz9qHPg7N0PMlH8744lRe56BXwJtK9b7J7pLp4C61i9V5MYfRiyWJbqKT11cT5M/ff6OHdoHY16aIwwXu4ZQwrrJdw2a+x9o4ZJvzGVcTQ+EBp3PenxrrDx3kgrlXruYzmiMkazGIY8T9S4qpjBqwDi7AZH2cDitbnm9vtBEIIALgXo84QyE+/VVRri/Cm4XUc8j7FzHXye2BmM5VkD+711wpL2Lbpd/0FAxvCaYe12AExd5Q+jOy876jyVL8BAo36JsVmNKFsWZxu31W74ihoBoUsAp3lQ3SqXmqSIaTzS/DwSsOpYzRLu9LaxV3j5+XISLvGh8M42KyHdJinTqbGNuBl2S2B2VtXx2x7E9IC76ZGwAe5lV07F3jdpgloPPydeDHqp7jhTQxU+BXPgs65etrynzauIl/a1+bRxby8D7mrE4Imprq1Sygd+8Bf6gF1Gglss=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e926ba-5aee-41db-49f4-08df474cd18c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 21:25:36.9431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYrKp4LqicLT2qyW8KVd63N2Ce2bunQWcQxKBOCR+hm1ZzVG1ITb1j63kmAFrMmRz1QoO0qP7TqcmEFm3FE5EhHxhi5HhiL0Wp3kbq4qF+VQDtRStfJPvJOGp+NfisDO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7452
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200085
X-Proofpoint-ORIG-GUID: LfX2lTJmyjHW3PMmLEdcAtfsK_OuwfMG
X-Authority-Analysis: v=2.4 cv=RNkmjIi+ c=1 sm=1 tr=0 ts=6b00bad6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=NEAV23lmAAAA:8
 a=bC-a23v3AAAA:8 a=mpaa-ttXAAAA:8 a=VwQbUJbxAAAA:8 a=ThxqNdz_AAAA:8
 a=pGLkceISAAAA:8 a=y5KoBH6N-Iz4PtQLNsoA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=X5WbqfxFh8zCdCUNm0Nt:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA4NSBTYWx0ZWRfXzWm7XVZH57VU
 ixMJ8I1lUEV9NIhTBir5twPVEKnP/lP+Ujqm+BVdAU4/rt05A5eF/C78pBhQCZM4Q8DLZ13PTTd
 pL1pzLNM25cdthwnafPfETiv2R51ZypXeG8wP3Mj7Trl1tkmtyYX
X-Proofpoint-GUID: LfX2lTJmyjHW3PMmLEdcAtfsK_OuwfMG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA4NSBTYWx0ZWRfX3W8d0svfh4xg
 pmvlH0seF2ufJi5Y0/snwuyu+kma20QRfv70vi8w3tMaDl+bCZNOYxDn84B+NoA0er5QxgDiSpR
 t8tP76kwEBmnFJHYer/xS+dUlYDFeKHuZYKPoaxzoLsjEDMhgKGIhfpteJTk+gPFrQdEq7k7x1j
 2kN73j8VuW364oo/2Rv+06Hsb17pkebSwkbJasR40zyWfiSgjdETLpmvAkp/2SZh3qC+LF3VMJF
 5lZZ0Kd8Ko61CSk9v48SFOvH2qyZXfk1qU9+CtYVMaMtJRCUAWjjeyKiMDpb30zFstufCS3JRnP
 dxG2ACvL7+1YU/6sgrRhtYQ0+V2sqMZY0belByxPCL6Mcg2W+9DCJxLYk38ANLE7aOE/iHl3ZLa
 gvEJBnKsPzYNb8gY9D5sckSZY6nO9PTwunIZs4WioAFLzFy/JY94Mwim72igz6nWBoqaIphyHQf
 RrHDa4Nf8ItmPDdFv0g==

Hi Greg/Sasha,

On 18/11/26 8:07 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Eason Lai <eason.lai@mediatek.com>
> 
> [ Upstream commit 82856da2d3b6a30011f4db6ea5f34c13484e0ef8 ]
> 
> When errors occur in mt76u_tx_queue_skb(), the skb is not properly
> freed, leading to memory leaks. This happens when:
> - The queue is full
> - tx_prepare_skb() drops zero-length frames (such as WMM NULL frames)
>    to prevent hardware TX hangs
> - Buffer setup fails
> 
> Fix by properly releasing the skb with ieee80211_tx_status_ext() when
> the queue is full or tx_prepare_skb() fails, and using
> mt76_tx_complete_skb() when mt76u_tx_setup_buffers() fails (since
> tx_prepare_skb() has already succeeded and may have allocated resources
> that need cleanup)
> 
> Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
> Cc: stable@vger.kernel.org
> Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> Closes: https://github.com/morrownr/mt76/issues/83
> Signed-off-by: Eason Lai <eason.lai@mediatek.com>
> Tested-by: Hans Buchheim <hbuchheim@gmail.com>
> Reported-by: Sergei Melnichenko <sergei.melnichenko@gmail.com>
> Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> Link: https://patch.msgid.link/20260914021920.32246-3-eason.lai@mediatek.com
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/wireless/mediatek/mt76/usb.c | 31 ++++++++++++++++++++----
>   1 file changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> index e40569fc7edea..8510be7f95a98 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -904,23 +904,36 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
>   		   enum mt76_txq_id qid, struct sk_buff *skb,
>   		   struct mt76_wcid *wcid, struct ieee80211_sta *sta)
>   {
> +	struct ieee80211_tx_status status = {
> +		.sta = sta,
> +	};
>   	struct mt76_tx_info tx_info = {
>   		.skb = skb,
>   	};
>   	u16 idx = q->head;
>   	int err;
>   
> -	if (q->queued == q->ndesc)
> -		return -ENOSPC;
> +	if (q->queued == q->ndesc) {
> +		err = -ENOSPC;
> +		goto err_free_skb;
> +	}
>   
>   	skb->prev = skb->next = NULL;
>   	err = dev->drv->tx_prepare_skb(dev, NULL, qid, wcid, sta, &tx_info);
>   	if (err < 0)
> -		return err;
> +		goto err_free_skb;
>   
>   	err = mt76u_tx_setup_buffers(dev, tx_info.skb, q->entry[idx].urb);
> -	if (err < 0)
> -		return err;
> +	if (err < 0) {
> +		/*
> +		 * mt76_tx_status_skb_get() walks the idr and dereferences
> +		 * a freed skb. This SKB is not counted in non-AQL counter
> +		 * due to error return, so using 0xffff as wcid to keep
> +		 * balanced.
> +		 */
> +		mt76_tx_complete_skb(dev, 0xffff, tx_info.skb);
> +		goto err_ret;
> +	}
>   
>   	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
>   			    q->entry[idx].urb, mt76u_complete_tx,
> @@ -932,6 +945,14 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
>   	q->queued++;
>   
>   	return idx;
> +
> +err_free_skb:
> +	status.skb = tx_info.skb;
> +	spin_lock_bh(&dev->rx_lock);
> +	ieee80211_tx_status_ext(dev->hw, &status);
> +	spin_unlock_bh(&dev->rx_lock);

Hi Greg/Sasha,

I ran an AI-assisted backport review and checked the packet cleanup. 
This looks like a use-after-free on a TX preparation error.

A packet requesting TX status is already on dev->status_list when
DMA preparation can fail. The new mt76u_tx_queue_skb() error path
then releases it through ieee80211_tx_status_ext().

usb.c (spacing adjusted):

     err_free_skb:
         status.skb = tx_info.skb;
         spin_lock_bh(&dev->rx_lock);
         ieee80211_tx_status_ext(dev->hw, &status);
         spin_unlock_bh(&dev->rx_lock);

But mt76x02u_tx_prepare_skb() in mt76x02_usb_core.c still returns
the error without undoing the status tracking:

     return mt76x02u_skb_dma_info(tx_info->skb, WLAN_PORT, flags);

Upstream (82856da2d3b6) removes its packet-ID tracking on failure:

     err = mt76x02u_skb_dma_info(tx_info->skb, WLAN_PORT, flags);
     if (err && wcid)
         /* Release pktid in case of error. */
         idr_remove(&wcid->pktid, pid);

In 5.15 the freed packet stays on status_list, so a later status walk
can access freed memory. Before this backport the USB error path
leaked the packet instead.

lets drop this and fix it later ?

thanks,
Harshit


> +err_ret:
> +	return err;
>   }
>   
>   static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)

