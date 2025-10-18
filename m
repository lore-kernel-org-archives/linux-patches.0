Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC961F418D
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 08:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760775453; cv=fail; b=uYhTUTm2CX95eiBrrFLTtUYxoEsSN49BMPzcCxadRX0O7oNfKrUv+o7QADSmqk8VE2XOCyb2L2A3Y4ZFAURxM9HLcuxlanHC3KpIx4LLYhtDMj0AMjXMSoojYDlAoyT6QwWyn7fie7/l60bu0DMEeQ2/m6ldRqDFQ8c+omD22NU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760775453; c=relaxed/simple;
	bh=k+DgIGwfSzZgwRw5mRDSHqwCyLPry164lsJZglwGe7s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kKdNfUeuBMFIFf8TMUjnJuvUPTEJAIE9fOobMKENlw34EjEXSzwJUeclPUVjK4TrOviwSmN8lTtGPHn6XrBpoahLsx0F45d9LCb3Cd/8cGKwvtXPfu0QscXFAZBSjewXB4rCiOWI2qubed/oi97E6yyURh7Gi8C1vo6l72xdVQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R4MBqipU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aB4WrvPX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R4MBqipU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aB4WrvPX"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59I5AMVo014502;
	Sat, 18 Oct 2025 08:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Lxbmb71h+ht1+bb3q82/ZKNP4ovyP5JP1tyi7B4OUz0=; b=
	R4MBqipU9KVEwxqngmx94b43UUersdUFwxkskhMm07UjIv8dejk828lSoQG+u+eY
	NzshTldjkC0EqMk3KgOfFPIjUX7T5Lpt4IGIeEkRUXljtvtaJNF/DhHKyy6EGN0g
	xBGrRaqmGIhrSfg81/Bp6q8IQK0IiGZ4BUJZlO5jio7zElu/dA7jfTTSehmOAREw
	J4SkBYlZ0NoitnHesUaQDQmU4AKf5aQkzsRhhH2f8vYVsVbk5dVlTQEWyWDe7Sra
	H57U9rvyAQUca8dFrcvyO0dZ+RdSHa761pNIgAJ6WvVnGpKm1cyECDEQiaHPomzh
	3xZyHXBjBXHRtvFYKx7NnA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d0472-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Oct 2025 08:17:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59I7TRx9032468;
	Sat, 18 Oct 2025 08:17:09 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1ba62es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Oct 2025 08:17:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eo7zV8+aAgR2TNXBtwn3N7MhBhfCx/84sPSGKf10/W3ndpTwuzbYhEAuifPXVRvZdsDcmO5TAzB0Sgq02ZSaBHoRvYshvI0uR614AzJlM8Cc0cIpuzuC/DPtsL3GnQAkrn1XOABWQQ1OY48lPbjolDGGR9PjSatI6CihTKL+fubZh0emDojClUjQ+JhNavPrU6UEw2gs48wdtYPPD+zVpetHlW9Jmm3W9BqpOBNerdP3vhfMbGnhniZSFOP28iVJMTQhrYGhW0R/dt4O46lTjPrCucJOy9l+oTEFE/v5GaPPpifnn3c9H75DiLZfoiNToDP06ALRJOFmDxw8PgKAgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lxbmb71h+ht1+bb3q82/ZKNP4ovyP5JP1tyi7B4OUz0=;
 b=fLr+/x4LsE1IrTD2qTbBn32mfZhtaauE5MHNwVNPfUuX2YN+a1g0CGk5NFFXG1KJpjJqjxjOYbiMFGnAFisd2Q4w2U1gBdx3O2h691cVwBCOqtrMmUYPdWNf65CApIGufZB6Ba1jkk9ER9Y8HRjZtc7rO7KMV92vRSfJeKpqk/1WQ+QLggMKJvehJy2lT3zXrjGDyHXRG4WK9RFDi3IDKH3ftpmI/xL2tASG8hf3TYPP6uWHO4iQQMkjfQ0L+P82Qs5XMju0rRaDPJCZQxUvmP5CXif+lFMTgWCSsagJEEP/x1qThJQjJ5SzGyfYKdXGQilFe9diffYWYtR5gBrrWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lxbmb71h+ht1+bb3q82/ZKNP4ovyP5JP1tyi7B4OUz0=;
 b=aB4WrvPXwndmvQX/0m5Y5x8ZfaxTh45aLHKgkW5GfB2G8qpXylMtKSIFG7YgIkyY4tp7zR1IJO/QFD79btPKqTfjgmPU+otG3zg7Gu2VYJaSGRF5M2ICifVMhbn2VXrFNzMAMRXDayGo9tvJbQNiHMY143+nSwaGbIikoCoY4Y8=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by BL3PR10MB6187.namprd10.prod.outlook.com (2603:10b6:208:3be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Sat, 18 Oct
 2025 08:17:05 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9228.010; Sat, 18 Oct 2025
 08:17:05 +0000
Message-ID: <48afcd4a-01b8-40ac-9c14-d2e63bbe3a0f@oracle.com>
Date: Sat, 18 Oct 2025 13:46:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20251017145147.138822285@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0252.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::24) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|BL3PR10MB6187:EE_
X-MS-Office365-Filtering-Correlation-Id: 710db333-e44b-4a3c-4a3d-08de0e1eb94c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDE2NU5yOHhEdUJFRC9ueGR2V3BNZ3dzRHJrb3Z3L0xSbnpRdXdSS2hQaFpt?=
 =?utf-8?B?TTNQN2o3MlRTVUVHMkdaL3crdUZFNlJwRFNkbGhsN09Nd08zNFltSlVZQnJv?=
 =?utf-8?B?eUJFeG1QMnRPenhzZHhoRk0xbGR1bWFYeTlvRytGUXdtQ0RqZXgvL0wrdUEy?=
 =?utf-8?B?NzBiUmZvNVh0OEE2aWhhMENRSmRnb1pLRzlUV3RRRGU0VEJUMm52aFQvSllp?=
 =?utf-8?B?bGxIbThRejNxaHBjamZ4WkVoMEpib2dqRnFkZDNCQnFIQUlmUEhQRzJ1aGNX?=
 =?utf-8?B?Qys3eUJiVlVMaVdOaUhodlpIQnp6Qm9PRDNNbG9JNjRVWXE1SVJ1SldOQ1B0?=
 =?utf-8?B?QVROaytDaHVHUkp5SlU2Ny9qVUlnbHZNUDRGSzhWOWFYQ1ZlTlZqYXFtTktZ?=
 =?utf-8?B?K2xkZS95bjBTUmJpNkhqOWtkUGhrSERHK3Exd3ByVklobHZZRjZ0d3dYRXNV?=
 =?utf-8?B?WUR4RG9zMDhWREZoQUFRWnFLYTlOVGJHRXNqdDRMZUZVclNybjU2MkpFekNF?=
 =?utf-8?B?M2NhQUxIV095alBRMWhNYUNYK0lULzgwdE16STlkZEdCTFRCTXA0eVF1ek1h?=
 =?utf-8?B?a05xU0FvNHhuRDhldFIzejRXRC9mQ2pnNmJLaTF5cEh1T2tXY2wvSThVUXlO?=
 =?utf-8?B?RlV3NllMcHlxNXRnZEhleGgrM3orZGhnYm1JUUIwNmtPYmFWajJXZzVpSWhH?=
 =?utf-8?B?SWRsMDk0UWFSQ2RnODQyb2V4aXMxS3l0S0VydTF5ODBJYWlyY3Vkemd3bDRN?=
 =?utf-8?B?VFZRN3dKWjB0eXNFelB1QXBEMnpkSzE1RDhCM1B5dmVmZGthdkFYcnZpVEM5?=
 =?utf-8?B?OTZpZ0ZWNVVZd2hMczJTY1NWNWQxL0V3V0U4Q0s4S1o2V3ZjUllQa20yL1R0?=
 =?utf-8?B?WHJ2Ty9iT1Rqd0xKWHFqbXFRd2ZRNHNsNDNXbjlGUnBBUk9HYnExWjJ3SDBZ?=
 =?utf-8?B?N0EwdU00T3BoR1NMeTB2VGJDU1g1d3FIU2tEaTYrS2lNUjFxZHRiMXJ1YVRD?=
 =?utf-8?B?NGtNWXhvRUJnOWRZUW9BL0lZcjJySVYrUHB3bVRMejE1Uk80VjZOQXI0ZXp0?=
 =?utf-8?B?bkRzRlZScGJZdTNtcnZkWENodklDK1o2cnlqTnFJTGx2engvNFp4bUk1c0t5?=
 =?utf-8?B?Q2VvczJYUTVIa0NWU2pzNjI2c3dDVm9tdkphNWhhVElqbkFhZmJTRXJaYStW?=
 =?utf-8?B?cnRnbSt3dzJ6OGEvaGNadjVxL0M1Z3hqQUEvMjhaL1VnU0ZHT0JiM1Y3NzhN?=
 =?utf-8?B?VnF3dlRsT0lkT1FCU3l1ZWZtMDExMkJUb3FrU3hraGtoNkxaK3VZY3hzRDFq?=
 =?utf-8?B?QjlFOTBTcklKeTd6blJQRG1QVjIxS0dwaFJwejZrc2p4Y2NsdUIwZWxVMnNi?=
 =?utf-8?B?VFQzU2xJMkFoTncvbFQ1RHk2aVMxSE5xYUV5UDhOSFZIS2doYU5tYkNsQitJ?=
 =?utf-8?B?Z0NKdStISW9TdmIwS0xVcURsblFHT1RHdnVWbFZpbEJYZTU5WldHMUFCMFF2?=
 =?utf-8?B?bGJMMW5sNUtwa2VEcitnQklhZmN2djZjVE1oZkVZblRONE50UUE3NGRIblZo?=
 =?utf-8?B?U3Ywem0zWFN6Y05ESEU3ZEFpWFZrdjJVUnBYZWNuWUIraXVEVFVReml6Zm1J?=
 =?utf-8?B?L1prZnp6ZnNJRXEyS1JlVUsrVDlnN3hESzFYTXRlZXVPRFFzalA0eWRIQmNh?=
 =?utf-8?B?QUdxN3ZxSXIvaWlZWGhPYmxaTXZKVmlKM08rY1FnMGdUckRhRHZKeTVRNUht?=
 =?utf-8?B?a3labkVTQk5HOXMvdy9FaXdkNFA4S1EwTVlxTUl0R1ArYVVLazgyRG1WbVVs?=
 =?utf-8?B?UjdjT3VtRDBiRVhqdUF3V09ZTU1ndWxySEUvYnlYK2MvTW1yTUkvQmkrcEhE?=
 =?utf-8?B?N1gvdGFJY2VQOGxtdFZvYmpKWUdiMFBJMXpIOFdUYkVMR1VjaGdhODBaQ2gr?=
 =?utf-8?Q?8VRE7w8QAIUCWbuQUnV3axDiDPORYcuR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUt6Q3FsYzZBUmg2eFBvbU9LSkVTa2NnV2RQZFBFd0NqODcxMVRCanVCSFRi?=
 =?utf-8?B?UmprYTkwYUFENmM0bHljeXpPa1VBUzJ4c0t0Y3JJZlpRN0c2YUtoQXBKQzd4?=
 =?utf-8?B?WGNja2JScEl0alJSQzFscmVRYkVwOFd6RFV2OW82Rmt1ZEk3bzJWcUt1Zk5Y?=
 =?utf-8?B?NlRBZkdDdTBhNVBGY3pFZ0hUUXUyS004R2hHak9hWldLK3RwVTdDU1pPdGhY?=
 =?utf-8?B?SnljeXc5TkhnWlR0bnovMXcyN2JXenYwMEVuK3EyTTRxK3pRK0dqZU1KNWdr?=
 =?utf-8?B?Y2tMZW1QNGE2YlJ3YlNrRlhXNFp5TUI2YVhjejBGVElnRk9RV3pZeHBHems4?=
 =?utf-8?B?ekZOaTNFa3llWFNnclVNa3RDZGJVbUJnUGxuS3dCc1gxSG9ZTzVMaFdsNWtE?=
 =?utf-8?B?OUhOUDBTdWdCaGY0d255MnBsWngwR1N5YXFWejdiY3ppRWJqdmI3OW5lVDZL?=
 =?utf-8?B?dDk0SlJQb1VQT2dkNExYSlFKeUlDN2NoSTcreHhoN09Jbk1UQ3FZaHJtY1Q1?=
 =?utf-8?B?MEJxckFJUnc4bzN0Y1BFdFlIdkF3YVpac3VvWFR3QU9pQmMxRlUyU2NmSWRH?=
 =?utf-8?B?QUlWOURWSnJzb0VzTjBpd29sd0hZS2t3Sm9VZFZvL25KdUdoM3d6SnBONTdo?=
 =?utf-8?B?eVZyTlVTY0ZPV1pVQTdjVUg3dUJZNHpWYUsxMGdkVmpDWFo1LzJXams5aUpn?=
 =?utf-8?B?NWlaaCtWMWlOL3JicDZsNHZnNjBLUDZWVTVxTFZIVmVUNnd5b0Y3VmVieVlD?=
 =?utf-8?B?T3lHSkRtc0E1d2MxK2lZZTdTL2NZU00xWkd5MHkyMCtoUzJvZG5ScVhaMFVz?=
 =?utf-8?B?Qk5ISldRaTNMZk1Edk9rQzlIM0xDcGVPRVJ5b3ZOYWdjVW9wU0xpY0QxQ1V6?=
 =?utf-8?B?TGMvai9MaVgzODNWQU1QWTNzL3VvMmp0dWZlSmZvWHY3NWgrRmRlYUhsQktI?=
 =?utf-8?B?SS9BbnlJbTdPdjdBZXRFdUI5dEFOR0pSdDN5TnRja1k3Nm5RNXZ1dnZnaXpl?=
 =?utf-8?B?UXJpNGZyWkp5ZXArb3BkdGQzZC9ZMW05NytuRnJpVHk0RVcwVGJ5M3hhVSt5?=
 =?utf-8?B?NVA3UTN4enU2RHdYOW96VzFtUnI4MlkrOU9KR25YTVh1SDhDU09hMWM3UURY?=
 =?utf-8?B?MmovVUZyM1VTdm9QUkp6WmcwRWhhRU1IQW9JdGE2TTdIKzROSGs2bGcxMWlv?=
 =?utf-8?B?UDBjdEtsdmJDSmxvM0RkYS9QeXhTL0RGTWxIVWlLK0lhM0JjdmVTVk1SWW12?=
 =?utf-8?B?cm12Q0krRTM3TFpUOUZ6Z3NvTEErY3o0WHdLQXF2ZUVkNlRtbWc1N2kzS3pY?=
 =?utf-8?B?MGNoSk9oc3lWQkJsUElrTHlqcUJxRnBKdDBWVjlySUpIZytIaWdIRDlVZnI1?=
 =?utf-8?B?dUp2SEhrSThKeUN5SWVITkJpNVdXQWpDbmFOSVZ4WFNVK0NXcnlNUmQ4ZUhp?=
 =?utf-8?B?N0JDWVNQSU1GQjM4MWVINFFnVmNQc0d1WlVlamcwWG5CdXdHSTEyQlhZcWRW?=
 =?utf-8?B?Y3pUSjgxajU0bXkvUGE5by92emoxbEJYU3dOZXZ0QXRlUWhQcEdTNmRJdGNT?=
 =?utf-8?B?ZmswQjJqUHdiUHlPaGI5K21UdmtwQ0pqemt0ay9rY0RhZmJLUGtsMkJvREw1?=
 =?utf-8?B?ckFvV1AxZHlnWlZScGltVjdUSjY3TFlRR0pUQWRibVVjZDM5Q3hsWnIrdTdJ?=
 =?utf-8?B?RkJlOTZzaGt0UFUyK3YrbjhheDMwTW9WK2R1R1ZwYmt0MlQyV2VjU2NmUkJl?=
 =?utf-8?B?WVhEaDVrKzdpeHlHaUVDRHdEa2lWaVk3YjVkOUJFTHgzakM4bmcxcmhMY2Ra?=
 =?utf-8?B?dzhyMGRYZkNtQ2FNcmFzeWZXM1QrcVM0d0dHNDJuRjlIM0hNdnE0T1dHbFpv?=
 =?utf-8?B?Q0JYaFYxWHdWeXRkN2FJMkY3WUZOMWdMT203NW1rcmdaVUZvYXAyQm9QQzdC?=
 =?utf-8?B?NUpydldESU1WS1A1MklQMFlSVkxCL1J3NllYRjNnanVnRVZ3cVRpOHlYcFVk?=
 =?utf-8?B?ZlI1elhPV2YxS3Y0WlU0YlVVcVRueGF0OUVEZkZ3TmtYMWU0djlESFZRc25K?=
 =?utf-8?B?UDNZNTNhSjg3clgwK2ZVemZqZTVzSGVhNVpPQjVrNHZiRGJLM0dBZ3c4dEJO?=
 =?utf-8?B?bTB0MGd2dFpJWWJ4TmZWdFBFZWlzRW41WjQzYndHbnkwdVhJcVlxTlFDUUg2?=
 =?utf-8?Q?N6bJ6OqS0erbQY16unTlAes=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3z0sFjM6BBex/hKr7IEKegLu8OgmwK5U3T7W7cbbGDAT0ib3r6LciWsESYAsKiW3NhMzf5Zat8JF5oupRvf/c7+gGdmj0fJZj14HesSwhUUf4+cSoEnWiXmm5cUn+/apKSElvdT/kwiDGbbxXVoug7Gqc8jt1IjNDbY+yGfnhCkut267EfYL98TBAAQnMuM2QwRn+0rnc9Rzgt+g6/gdn5r11x7hiOMrXLfRNpcZBXiM+XNORDJoZ2lDwf7e2YDKanfXaaBvS5Y41+dR5ueFcO/7vKEh23ycsqkW9IrBbZS0EAuN94FbPDm3HJJHcdwZROZZMnXunGuTgTw7hugKa5Arbf4FgOfDlmMYBmjxPWy/rDrAicIQcYc14YPIgXq8FPvAV5Hn8958CIrwO5o/a+CrYyuEnxluOhRHjzovabCGo87cJNStZC+7VXxntO1Hf23COutoUXc2o60Y+hMxMKyWqVAGMw+h1a1HJwy2ZVCY+cWCSPF1C5i9sElhLh2jDfQ8b48RxJxz3cH22QcMcPolsFjcPhHWjJUQSxbgfDFS7Sckp6IcIXxa0lq86OEgFtY7rj2y9gpd7EGZ3Wl1dGMtgic/hBkxZ9/m+Z/vTR0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710db333-e44b-4a3c-4a3d-08de0e1eb94c
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2025 08:17:05.6458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZY+hezqhwhZ10qjnsvjJmf13LGxKRbLa4rK7IHtDe2H0Hxh+BZUjStNNqFcSpV5c4ZWmGcRRmXDg+ET8wqmv8cTJuOX+sXbWRNtrDWz0QgAJ+eRPNYgALNOFJ6n9CYPY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-18_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510180058
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX4HxXuw2GT9Qq
 CBx1WrqjX80A4kOR5Z/jgGKIqzNAzVbGU+uMwoI1t2vx9LHqrrPOGLFZ0SGcgsxaTsmlKPApdCj
 IvjiecN7vrcTHsKhJxMBXR6xo7VJ0Csbwb2Pr3Wbzb7zbKokm8uLDIIQuKrajVrQASspFlOhJfe
 CalyUrMJiUbsEEdPdMvRbYyfyZ9DgcAaBxHZ5Re6MtvgxxotjS/3qToeCPTVn0YsD7239tqK7rM
 BFLN5max0/B6+pyJSd4FdPdwRejyei6Xj3PRqeSPCU0HoRqegm5FjtVJ7vjc6Rjk21i236+fXZB
 3Hu63AkamAzss+Scjv/CC/Ckxsxe2Pg5ryYsSK3Z4LX5/2fGepspC1s3Vtlru3zvVQ+UmpBafsq
 5WD794Zz0Vu0KdASSjSMWjxtlVUwSmgvICOj3TqsM7ayM76jaoY=
X-Proofpoint-GUID: nQKIEKCaZx6nH39ds20KdEOcw06gbRcp
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f34d06 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=N2P0mlJ2mN5yeyYX4H4A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13624
X-Proofpoint-ORIG-GUID: nQKIEKCaZx6nH39ds20KdEOcw06gbRcp

Hi Greg,

On 17/10/25 20:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
