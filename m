Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E0B3CF58
	for <patches@lists.linux.dev>; Sat, 14 Dec 2024 12:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734180438; cv=fail; b=i1tU6NhgJozdkMDET5FictOSSKdH6vpvN9hb4HV3qd0VIiU/xPr9l769RC1/3RrCCe0OvPN3yw5TlBTaxZ2M3cm5WFd9TWna5g9wPtHuDcgr52AmBp/NxYgpUeWnxo1KWsBQh/ObaK+co0Z5T1aF5JMrENufoP4AZHbB7sTk9g4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734180438; c=relaxed/simple;
	bh=LAw62TCbNp5EMghNxze5NX22GhJYn5QtDaZsdXq+YgA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K9Xjl+gEWxfy+PBwyTb6fvyHsMhbNPLjUSqUercxW5g0OK5n/qNjoooXkeS5RyJSbZv9AAd9bts5LWNC3to/GsYj80trZCWLtDg2RVX+c+7V5P7N1NdfbpymmVw3hsVWehbQrZ2JfA8iWVtGW/k2JMqgdIQ5Is65+vtZC8xXZmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b9xV4MCo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=boJfU6s9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b9xV4MCo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="boJfU6s9"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BE7rZOt018822;
	Sat, 14 Dec 2024 12:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ooJoDPOnG6gl2QnLlZ2TKjS1heg7uEQMG1GhngatNy4=; b=
	b9xV4MCoYPsZa1x2nlRaXFLptpUTnP27uccOJhQP8NAlp5GMut6D+VGD6SZkLJJ0
	TmTb/Muj87XZXvC+i1StnqLNkcyE+0oxPo/7YU6TBBv0kaSn7U/K136ChuAdxWzU
	kW69FEaQKYXiPZA3hAU/2UO5UywwBJZGntNI/3EnLeD1IVZ7KdUWN+gUxUcK165G
	BejsUnaPA20jkef3q6tDlUTw/Yul+xNyh5rnnh5mKLsXFVS8Eh2m1kL+pyJy+sp4
	H6JAR3Epn8SPCsrHwKlJIg9jfwRIgDWBnxf81rZaW/3BeAQx3F/cdUISMuA/jRWe
	bGYAk31d1uhIpYyj2UD2FA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t28ett-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 12:47:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEAKeFX010942;
	Sat, 14 Dec 2024 12:47:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2040.outbound.protection.outlook.com [104.47.58.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f5j2a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 12:47:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dL4w5mMP4M/G1WGmVIa77HhQuQSn7F2as7rqUd9Mpehrn5iPJv1JUoR27l7RFPBOKzc/P2CJ/0CsgcxgeB9rV6dueQjW8nAHpt14QSAlCgWeMXg3oGsYnfVB0ziCaiyhIEIuFm10ADHYv/YAgHzWjDi8pBgPfYXLNsQqGhNrg2W+G4lmjOsFRZnE8RERU6F17UWUy1lyJxDaPzhAMxCeF15HaFEBZf+3mmHkEqz8CKuRtTOx/+4Lfkq0DZ/1je9D0l3vsZToy5IOjEzn/73XT7IBZ9/mOX6gEQ6x46Etcq2xktnTNBE9NQiU5dZkLFTxgSRSH5akZ5dROeloTEq9vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ooJoDPOnG6gl2QnLlZ2TKjS1heg7uEQMG1GhngatNy4=;
 b=KakIp1AgCRCap0IxKYdkMZkmJmM0HuecoDLiWBNoulEmVjPainci4jcFySAYrcEmRWqyEUTWCimzGufNCOLfg3xcjB3s5B8slLqs91mk++nWWoJ35D9VGSfR7my9cSHXH1X/XZjdZrUEmcrGidXhv67qOORPi5rfq7bVtLjCUs10RbCAaOx8147p4XBwTm6/Eenrpkw+PglaJ/SrKq9UJs/c4v8y7jZBGfzoismVImfVTrZ89iOCaL10QbbvUQbWjzt3/4VdHOSPv35ESq6V2kKne2l3oRJ+xe/OH3NifUp1iMCNEhEKML2DJ2FS3Bj/D7m85qXbl678Jb2sKxvcZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooJoDPOnG6gl2QnLlZ2TKjS1heg7uEQMG1GhngatNy4=;
 b=boJfU6s9/VBmtwidGW/0Suy9mik0LHMbrbSMhesee0cHB2DIILllxVcEE/S18KdLVy8y1AukU/WSYKJvcoYuZkiQWJ/ASo0nSye77Ktp9EC/mYtZfwsqMy40pUa/uBqXtGhJnqMxJUYgx9zZkG8B5A0y27gk/nZPIYvSfmS4d/I=
Received: from CY8PR10MB6873.namprd10.prod.outlook.com (2603:10b6:930:84::15)
 by LV8PR10MB7967.namprd10.prod.outlook.com (2603:10b6:408:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.18; Sat, 14 Dec
 2024 12:46:54 +0000
Received: from CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0]) by CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0%4]) with mapi id 15.20.8251.015; Sat, 14 Dec 2024
 12:46:54 +0000
Message-ID: <b8e8e473-b704-4dbe-9457-b75fd69b138e@oracle.com>
Date: Sat, 14 Dec 2024 18:16:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/565] 5.15.174-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241212144311.432886635@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0045.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::20) To CY8PR10MB6873.namprd10.prod.outlook.com
 (2603:10b6:930:84::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB6873:EE_|LV8PR10MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: f8a66fac-6345-4f32-f558-08dd1c3d6349
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDRvWllGWFU3V0lydkI0bm9xVlNudzMvWGFFemJsQThrVFlybDNYUFc0cU9v?=
 =?utf-8?B?ank4Rm9jQ3RTam1PNGtORUpFZGxnbklETGNqWFdaZzJzejFOVjMzSStBM1Ix?=
 =?utf-8?B?ZC9nWXV0MDNXWDhnVUJNemxmTGc4WnBDeHlsMlpDbnhMckF2a3QyM01LdFNj?=
 =?utf-8?B?YWJ0dW9FVmxRMVdqcXJhYTUrRjBkKzB0QjBuTXRSam5DZ2ZKZnZmWlYybml5?=
 =?utf-8?B?ZGk1aXE4MmNNeDFvZWJRL2JCaUovK0F6ck5STmdWSnJQRVpRT055QTJDcThR?=
 =?utf-8?B?U25lTjNiajg0N2pLaTNINlVIN2FTeFJBK2N4VUdtY3RpTXdkblg2OHo0YmFp?=
 =?utf-8?B?cWFFaUlydHZ4Ymk2cmFDbnpMOW5mbUxLVmRQMHlsTkZxU2h4QVhsWmNqVjFt?=
 =?utf-8?B?aTVBQzZOMTRYU0JtMGthaUxCamhuY0FtTUhtUTNGWlRYWGFDV09EU1crOWFo?=
 =?utf-8?B?TE1EcEtTMk1OL2FtdlBhaDg0Y1hmMVRsOSsvM1grOGhmOEN6MFIxWEhSQzJu?=
 =?utf-8?B?ZHJLNkJFT0p4TEtwNzErcnc1K1hPNVhmc2ZlNWtwQXc3S3BrTk92c1RVWHR0?=
 =?utf-8?B?TWVsanFwM3lXRHp2VXdqZUxBK25ZWlFEdnFydFZKRWtab3dMR2dRUUphQzJz?=
 =?utf-8?B?ajhXc3p2cTBscngrYVZvcGVZSXlJZWZEQ0toalhHanVid3VQbmZqWCtlK0Zz?=
 =?utf-8?B?d3JkenNBR2dUKzlZQS9jclgvMjhIdlRwY2dVR3ZIbkY4QXVSbFdQMHRGQzBU?=
 =?utf-8?B?cHJrTE1PYXRxaHU4WC92WXVuNGtmUjljWE5iUEFmclJaSEw3VzQrUUJWTlgx?=
 =?utf-8?B?UkppcmpsZTd1cTIzbk1oU0k2ZnFPd2I1djlhbHFoU28wbTVSa1VUcmZaZjNQ?=
 =?utf-8?B?ZWo5NXJ1TjRBYTN4bHFlU1pvbWFIN1VJREc0ZWVmRm11NFhCM0pxVnZNeVhJ?=
 =?utf-8?B?SlZHY1pJY3BHV2w0dFI2aTRnUFhBUlRMVFl4VFlSNitmaUYvNERtYWZWeTlL?=
 =?utf-8?B?WU8vTzBjRmtsNERHQnYzcGp1YzdEWDJmblowQTdzenVLQ1VGaFFod0ovMGhj?=
 =?utf-8?B?cndaQkNLMmFvdTJmVEQ4M3JhWHBhZmZKeWFRUndqSTNFVmtUTE5QdmZpMmFn?=
 =?utf-8?B?OVppdTFFUWxZNlB6TStRMEQ5dmtEeUd4TkpoYVVpSkhyd0pkOEdLSDU0UEYv?=
 =?utf-8?B?aTNRQlJ4RkFxVHEyWVlodW1raHVFNGhVaXY1MVkwS09Oakx2WFpRZWEzb2Nw?=
 =?utf-8?B?aXFlTVBwTG5VYVVOMEErR29MSUgxbGFxQmxJNGEyZU9oaEY5YW55WGtmc2o0?=
 =?utf-8?B?SmFrOWRub2ExOGFrL0dnVFdvVERWMGUzb3dyb1A4UnRJam12TXlrcW5BaGgr?=
 =?utf-8?B?S2R2MXJMdzhGRU9LekJCamdxRHIweENLUE1jUW0xWllMM1JOQkVuQTNWSW9I?=
 =?utf-8?B?U2NISno5RjhCaC9qWndHbGpXbzdZeHZia0JhTTRDNkVuWVU4UVVHU2tPOSty?=
 =?utf-8?B?UWFNSkxPN2JRcFNUVjRPamdyLzBRRlpsRS9waUxHSTlUNTdRVHk4OWpKRFpp?=
 =?utf-8?B?Rm5JMEdXd0sxV29RMTdRTXMvYTF0Q2QyMUZRcVhKNHVqcm10SC9YdDZSRVVT?=
 =?utf-8?B?cmdUWUdZMXI2K21KNUlvZTZUNzN5OHUvL3lFRjBaSXNrNTEzOXpabkh6VkJM?=
 =?utf-8?B?UTN6bTJTOUQ3QTVFblVQR2JPaXhzdkJZNUp5czY2YW9GanFMMUttSnNBb0Mv?=
 =?utf-8?B?OVBYaGxQQkNpaG9IZ0FjUE5kSVFNa0NyVm50UExtUXN6NExNUVVYY2VtT2lI?=
 =?utf-8?B?Z21BUzdFaE1Ddk4wSk1laTBEenFZcmEwRytxV1RDYWsyWWxjQ0xQeEtNMmRU?=
 =?utf-8?Q?akTpHeUQ7ydrn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB6873.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVVEa1ovWVhhMWFna3QzQjdqVzNMVXB3WUE2N1VRUCsvRDRtSmZWL2hwYjZN?=
 =?utf-8?B?VmtpdDVkNFBoTWNBMEttZmRwb2VkL0p0alZ1U2JMaHk2MUc3SzZqYUx4ZDY1?=
 =?utf-8?B?RWtHWmIxOVBwREtXME9BU09uNm90cE1HczlNdW5qa3RFU0Q3QWYzMzVoOFhm?=
 =?utf-8?B?d29WUUlzSnkwajBhTVYwdmtoRkt4djROdUxxUU0xbVVyNzF6eTRuNHdWVXhr?=
 =?utf-8?B?MzhlL3VFRU04Ti9RODNuemx3MkJ5dWdveldlZkI4WWtDSlMwMFpock1OdHFk?=
 =?utf-8?B?YlFSVkkydEtlRzlCelNubXZmU3F0MVZSU1VSclE2K0xCdS9LcVNaYjQxbzdT?=
 =?utf-8?B?L1hsL3hZeEFia1BiMEw1YTMyZit1V3cxcVg5YmRqM0l2YkNScnhVRHNvTlUv?=
 =?utf-8?B?MDZ5cmJlbXg2bG1md1A1S0NjVUxNNGdmd01qaUN3TTlzREV6V0t6eEMxS0Jx?=
 =?utf-8?B?S1FNZWF5UTZRTTdYMUVoWjZkL09qam9OWnk0NHFMZFU2WnYxbDJhN1hQN1BX?=
 =?utf-8?B?V3RNYVZkaTFBOUZIYk9VaWJhcjE1S1dJUG9qTE9UOE5oMVU0bGFZQWI1ZEpT?=
 =?utf-8?B?SkRlZk00MFVtdklrMnM4L1doU09iUUwySHc2ZGxIWXlVck5NaWRtcmFVZWY4?=
 =?utf-8?B?Z2VwZ2RKMGZVSEY4MnB3aWNGT014bFRkNmVTY0hHei9BNVlTaExkUjg1L1cz?=
 =?utf-8?B?SmNZTWpDQ0l5akVwWEdyVG80K0VIM2psNE93ZWRsTjFiQ1QraFVTdllMZEhw?=
 =?utf-8?B?dEEzRDgvMDFmY1VITkY3KzY5cGxzbmJTaklNc2RhcmplMmtlQk96ZlZUQnBV?=
 =?utf-8?B?bEg2dEtkZ25wVlVpZXVYOG9wcTRzbTBNS241MllqcUtEUDdjVjB4aGFpMklL?=
 =?utf-8?B?REVHK1dFUmxRVSt2eVFZME5DQ01RR3hhQ05DcXJ3WnppM1VpQ3lpVm5GVmV2?=
 =?utf-8?B?QzBYK1JOSDNGb1dLQmdPQU9nT24zdUNaYzQyWVhPYkVlRHVjR2hJNmlHU0wx?=
 =?utf-8?B?aERUN1d3UkZiSlgxQVpFRk4yQk9BbFhHL2pVNHMzdzhZd3pLOW1qTTlPaURZ?=
 =?utf-8?B?RXZhdDgwUjd1d3ZhV1U2U1V5RkVxT3VUb2lJczc1elQ3b3kyY0xwbksvZVdD?=
 =?utf-8?B?QmsyK3BlQ29MdHlpTXN0c0hWWUp3WENUZUdwbFAyOEVmNHY4QndoUnFDaGk2?=
 =?utf-8?B?K1VQK0xFaW9NZFZFdEpLODI0VGVuTXI5VmxuQXlaZVRmQlZUR2VTWUkwR09Z?=
 =?utf-8?B?OHdxT2tRaGdPNXRJbFZ0Ym1ENlVxT3o2aWtrWi9DbTJoa1l4aTdackdUTWJo?=
 =?utf-8?B?ZzVyVlpDSGZrai92WlZxdFdLOTExTmVFYVFGVkdPZUJiSjNmeXVsMUpGa3M5?=
 =?utf-8?B?SU1GT0l4aTNtL3hKbWNlSjc3YU9XekptbjBMd0pvY3hDWnM5ZjEvbnZSdGt0?=
 =?utf-8?B?d3dSZlpWQTdRa1lqb1RRMFNPT2FJM0N2OGlaWGNydC9qTTJaTkxIN2M3aVho?=
 =?utf-8?B?S1B1RU1BbVBlb0R5RnFvek9pd2NtaUdSMitud1ExN3AvVGlUMm42RG14UWRY?=
 =?utf-8?B?MjJMMlhMZ0hreUR1NmxhalNxR2ZkM0x1UEJKM3RpVEZpVEY3TXh4MHhKMklI?=
 =?utf-8?B?YVVWTndMSGl5bGlpVGxJeVE5dVdkaklNNHEwMWVmWXZ1WVV4K2tsR2cvOWtr?=
 =?utf-8?B?d3ovcGg1Y3BlL0ZZczVsQkRabDliQzZYQ3FkTVNXT2VnL2FyTGtVZVJtSm9E?=
 =?utf-8?B?SGV4WDlOOGZ0UVp6R2V6bDR2Q01VMFczVTJRajFzclBFZDNJVkp5M2hHTmZY?=
 =?utf-8?B?SUsxbEJwbkxEVDdySW9EOUpCWkxIaFRNV3Y3RDV1RGMxS1VaVEc2MDgvMy90?=
 =?utf-8?B?MVlnM21YdFozWjRlaU9seEhEMjk4TWFLNEQ1eUpTY043RHJWRk42N1hlQXZG?=
 =?utf-8?B?ODkzeG1SYyszaVl6dWRvdVJBWjlTdWF2dkF6ZXFEdDVhb3l2Z283b3VVMEZm?=
 =?utf-8?B?dFR1ZWxQZ0s4bEJ2clV6NjhONzI5djBDU0M3NE9RQXpkRWt6bHJPa0NDOGZ0?=
 =?utf-8?B?WE1aWlJPcXQzWGl3U1RwVXBQWFk4cTlqSnM2dmt4L3lwYmx2K2xwY2xldnJ0?=
 =?utf-8?B?TjNNWlgreEVVcjJWajB2Wm1teGQ3S1U5YXlGR2dwSkgrUzdZbytianRLTjdS?=
 =?utf-8?Q?9CqT3EGPL6XRGZJy1+nGtlA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vmTByJKApP6ESKpbd7ATXpykimj0Hgd0K5Y+3A/+KQldkfJIPR0QgctalG4jCvCaRpP+90hebdftQeAjHZTxpKWrr7XhUoVw5DOif2/bq99qHTg1iCxOkRUR5SbmMPecymtlzHKFLh91iD9QDI4L6Pq8yckT3bilEEFPziax2R/1ooCXgxhMxg+/UjDDKZX0zjKGpsnj9/6ytsnJj6ZMKL0jXhtVnvrpkhTXv6MfoaPHNQkPeYeFtL6PQtJPaKbOdPjMCKi4y4lS00URjrzitjfrQhmwhQgl64ZymdncK7cpUmGuOdzlUuCtOqHW/m1e9iKpA+aDTeFmUBD8vktF+tjdWxgbXJkQgbNZqT/tbEws+1CYOGZRf8IIhTe7ND5wXYCLkwof0nHoYi7fCyhSHv7mwjrSD3VaZP2ykGPnUUsFN4X+YAd2N47/6YsI3VdcDTOiZIGbMXuTipEzTvHSJ6Kh2pn+2qK1+/k+r3VyhWq3gPqZwP7wmHNbWBfr90OXBpbiBFfa4xgaokR6kBoK6e2ocfYzT5ckzhLt7TdyuM47kBacKLGbs6oSqgbG/AKq2CgRV3kmu5CBUg/UMp+GfQawUzpi52ZIVhsfc2EFGLU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a66fac-6345-4f32-f558-08dd1c3d6349
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB6873.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2024 12:46:54.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PLgbTe81RKM0S8pAWixrSYCCoWLymyzJY5B9OIbQY/5gilGDucQjlrG4UXf2h2wMvAzhmKzREZOL09oTGvXovHmOHSV82iNVEk6gCyj1JA94Wmdeiqg2qHte8TX5z/8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-14_05,2024-12-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412140105
X-Proofpoint-ORIG-GUID: 2L4S9Ytky9TiXOdPwj4qQIgyUka1rwjj
X-Proofpoint-GUID: 2L4S9Ytky9TiXOdPwj4qQIgyUka1rwjj

Hi Greg,

On 12/12/24 20:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.174 release.
> There are 565 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
