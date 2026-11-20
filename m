Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795209512;
	b=N2FWL5UOHPyFPdftOUyl4E0ztlDSmFenY2txGDYEY1UMaobCfxBJb+gjUCsqaHc0QlS9
	 Ld+Mfjn23aswWDUX0Qn68WTWxfQjJWqvO/UziDdjIKwFgC106hp+fINsL+cQTOvsSw7FV
	 TAQaoElKyhPoHPafUU1Yl5R5Bc037su//INQMG4nqMa3VpSmROplKhBMnW15GWLVwXnix
	 TIyOaiekqrrNdeFJszPGeu3eBxoCvUXNBZhjM+/8u/BSkQJwKYkMWktM+4HbMATLvKsPE
	 Uur0YFL3LtGWtUoY7fxpCZKcUr2YG9wT/zjQZ0d/5yHBT7SLvINPStq3AL26utMwD/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795209512;
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
	bh=N0TqTD/exguFD9AjunzoqaUayMBbF0+XfhCiaMS791o=;
	b=mLNWMX2iXcalXPPBU4Ye/gQYE6JClDEslvr6wcJ9z09WB0g3h+VEdctc90Pho5ZZUo7k
	 UOynksX8wx+xgHbdnGC987xwvA+BMBEBr/0BQ4LTXHOR7uzIju9GfZhIIIhRKnLZTqhjb
	 2/jczsKyqpD1vKFE2VpLtAfOaqNc7igqJHfyOnOIyDqCPnRVfxrHdmZtoA/0wdiPwOyJe
	 h2Srlb5vL1U1OWXxMUvspPFMgAYBrcTs7+kCATd1FMnT/i4mfFionyipR9tu6Rcme/jHU
	 EHwsF8InDhSTk/O0yIMPfLXb6hC1M6r66hOVt5sFhBlFk2Icw9Tjclg/s1VVXhNs+FA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=IlC8CdAR;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b="P+N/uD58";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E5A606A339
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 21:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9E5A606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=IlC8CdAR;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=P+N/uD58
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKGkjmw3280421;
	Fri, 20 Nov 2026 21:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=N0TqTD/exguFD9AjunzoqaUayMBbF0+XfhCiaMS791o=; b=
	IlC8CdAR1G6dN/hJorKRZoA/orRfIHRGTt9kXB5UspWu2IbjNx2eGLFcmF1bI54V
	XUbYeffp1rSYEiw1ywv+g5DOati8pLxGiDtqGg/3yCCLEHh+cKNGszz4VZ/tSEsw
	kjj2jnk/Z7ajfXfTvM8745Vjmsy4XhiRU/EsipUYOksqb6yVLjiamXGczBlbKEtM
	Pz6198rYydr3VJ9Mi1De3oFbC8OfiXo26pvs3AyqDqfZBqcpZDWCGvDafuwnzhWB
	a6R7YoHhTbpcZMhjepljVfx5Kq8FaBaoAHcMd65sxCvEY+fmY79o8FwdENMZMedT
	LgzmM1IuAT75ApEj0yoM7w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytsda3y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 21:18:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKKEimc1014086;
	Fri, 20 Nov 2026 21:18:14 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010060.outbound.protection.outlook.com [52.101.201.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2tsyf1ee-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 21:18:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UFLsrvSpfL7Cfs312PF+Sw3NqiKMkhu49VKyoFZ+exJ7rOOEfL1dIwbHaWjklWrJhEQ77275XfHRHYZsEOKyrS69SFoT1TLwJTg8CtnesZTyHXPQYR+F/w6hsasF/Q5rc60T1XEKJHreiImJm8pTdsfcyUNkCJN/RmoeSuXU8V72PiA2HLT4MzN6exPhA05QLNghRNHpuAshnwqMQ5caVY1dyRWgu5JxRURKCw0Y08PYIo08HgUIcTRk93os4Ig+z20l19s5zpFwRdxQrU1n/nrp5R55RV86CuFOAMOsSE/q+r4ySuX/2mFCKzgOUyIfcMijtjs7gYiUru6OdUV3hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0TqTD/exguFD9AjunzoqaUayMBbF0+XfhCiaMS791o=;
 b=CGO4Y/fn3cUSrXRIA089EQK5s/OIRph21G2bRhEYY+g2iPm06UHjwj4MyReGHzUfRvl64mfmffpDr1uhIssr5ZdQVt1uu6B++zRdcHJBOP+NVq6oE33DAI9whPt7YeOF+O2U3nvkY7sDsu8d+mGcESv9T+DbesOI7vFkaW2ZdfMUfHznkTZk3kJhMBFbYTRPGb5qtdhhUDBD1MtiNpBq4pGhLZDYh2pbs3JdVFdgLW11JhVTDn9zyWjywu2fO2BshTBuqMlNkHEZ4gXnTStM1cEBvh7Ff+CW8ca408BfSXlyedFBcjHvE8VhQUiAQx50NgqN5WHCUjKJcFLNnD1nKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0TqTD/exguFD9AjunzoqaUayMBbF0+XfhCiaMS791o=;
 b=P+N/uD58uriVsTX7jpTGjqHdc8sqYovgn9rybgcj9AIOyP3n40F6GRV+ImgUHeaGECkbF6Ouq4k+I4UFVMkAn9B3mRTP85JFgDVjr89pSR3X2eDa34ICpB4SG0A7ho1oMAZw9PDGXELg0aHsf3Xm15983z2EojoxAB78SgvUf1E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA0PR10MB6818.namprd10.prod.outlook.com (2603:10b6:208:439::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 21:18:12 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 21:18:12 +0000
Message-ID: <f174f64d-be1f-4576-ba7f-15c76053a40d@oracle.com>
Date: Sat, 21 Nov 2026 02:48:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0313/2214] media: redrat3: fix UAF in probe error
 path leaving rc device registered
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev,
        syzbot+302b9b575a06733ff60c@syzkaller.appspotmail.com,
        Rik van Riel <riel@surriel.com>, Sean Young <sean@mess.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150022.665647152@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150022.665647152@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0140.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA0PR10MB6818:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b80e314-3933-4ec9-9545-08df474bc86f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|56012099006|4143699003|260925021911599003|260925021311599003|5023799004|261021121427099003|260925022911599003|261022105027099003|261021123027099003|261022075727099003|261009223027099003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|22082099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	SQfXrkalPajwMZBo/RnjZqN78TNvXUqeR/sQpy8C/EIhkk0CRZX0BjpHZbctEE3tw6IzD31Tum7+JIop/aLH9Pw0wcqAO7l37+WMGN/cynADC8mA1/JEwuhT7eBPHECsOsH+7lAhb4MvhI0owxEq1S11YBv/67Bo+aqeagkQYf3rPTcPipn2uvyx1pr0o1Z39GPZfU+ZGmx0tuobbtl8Q2jDSMDUdLZgrvCHSvPDdxjX5dstT8g7/sRvyt+AfoD9LBcarseOXoHUgDvGgyKGDBNqRYsP9UFEDVRKqjqPmm3Vp8QQhaK3jLhfz0ZF2fe9ieb0mdLsQC9k1qJc4pXBDyw4f+hzGHrm+L1qURxBhVrlIhKWUaou4/njMk8QnyPecbQ84Fp26cjdd45piAcTGnpcB3zITKGJRPIeNU8d2TvfR5g/HZH6rlyq4UrftRIJoOUo+L52YFuBLyzClPQprKHdmzAasyau/0Lxj1gAN4XwpY4NwmuzvxffFJm9VzbQFSdhACUoaL8D/Q5BXGiDljsKnXyao74cmlYtEhnwWnVBgfwGMkwTUkqGrJRwtu/hbcoZydpWb/FMemGqcJMQr3/K7yHtBb+CkPjsiNMkASaNo1lI6ui2tvG3KBwf48c8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(56012099006)(4143699003)(260925021911599003)(260925021311599003)(5023799004)(261021121427099003)(260925022911599003)(261022105027099003)(261021123027099003)(261022075727099003)(261009223027099003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkFERGFqZVpEeWNqbGhiMlVIMFZVaWtaanFZZlRVd1htR1dFTEg0ZTZRZ3Vi?=
 =?utf-8?B?aThJUTUydC84SDVkcG5zSms2bnNwelVuUXFnNnBiNEY1MkdkV0UvTXJaMnV2?=
 =?utf-8?B?WW9CY3RXbUFaeldkb2NkWmtEclRVTDJIazdmUlk2N1JTVy84R2pjbU5FenFv?=
 =?utf-8?B?cTNlNnJGb2g2YUVBTE1PMG5FMm04bzRuczR6dHRjVFNQWWYyenN0dG90cGNy?=
 =?utf-8?B?NklCMkR4SzJXenVKcmJHenpLWUcxajFXbWY0MWJLbms5Mkg3L3JuTThHM3Vv?=
 =?utf-8?B?WjZYRnJGZjRpeWgweCtCcUF0VGN3N1Iwa3VQN081UGQxRjRKKy90UndhTGk0?=
 =?utf-8?B?bnVJNWFXYUZEand1R3FHckgwR0grc1U2N0ZzTDMwakY3YThQUnFsZ2xHa0t6?=
 =?utf-8?B?TlF0Y25HdjZCMncrUituQ2lOZlRDK3I5ZGdLRzFRWlVmcXdLMS9pZGxldllV?=
 =?utf-8?B?alV4Rm5CY1htRE1UL2ZJWlJLR0tZeHdyb3VrZWRBQklyZUkwTlZydmQ3alRD?=
 =?utf-8?B?L0xrNC9ZMUJPWXkzdk5jbzdSTzFhQ2NnZ0k1YTMwRHBNcDUxMG45dEx0TDgy?=
 =?utf-8?B?Mit2K2xWMEZYMGtUV3htZGdyZ0xMckllZXN6bGk3R08xQ1dQOEZEQXd5dVdW?=
 =?utf-8?B?MC9laEJTaXRUY3ZzVk9WVUZhQyt1c3BsSUJPcDU1aWJjNHFKMkNjK05ZU1Js?=
 =?utf-8?B?K2FSODB1YXlTNzQ4K3FQeDZzMXVQQml0cUdVejB6V3p4QStHZXE2QWdXNy9X?=
 =?utf-8?B?Z3lnSEt3Rzc4MklCTkJMcTZmakxUcUVHWjJNTjJTVWZwZ3NkYWRnSmVBUEJU?=
 =?utf-8?B?U3dKdmpja3U2elNHTUZFUXZmOXdTMXJWb1BBWHh5bVFKNkRPaFBWZ3h4Slg4?=
 =?utf-8?B?STQ2U1VxR2prT2NZTjZYV1MrQVJlU2ttMmNvbXZQZW1oMmljZkxpVmZWOVp5?=
 =?utf-8?B?dm1CNGRac2NuRldySE1hVG1FeTFyM3Q4akxNdXdnTXh2aFZ0aDlZemMxWlVR?=
 =?utf-8?B?R1NVaWVOUUZFVlpxYWt2amtHcC85UFlTWTVtRENQeTdmT2c2SVZDZHZDUUg1?=
 =?utf-8?B?QUhjS3hkNTFjVjJQcG9oZEdOUUZhcFFTd3hmNENWMVIwbUVNZS9NWHY4VXdM?=
 =?utf-8?B?RC8vRVY4L0NkTkFJaVlPc2xIZWtLS2pSNjdYWTJvWE5Vb21ZVTFpU00wdENF?=
 =?utf-8?B?NGsyZG1Ga2MvcE1oT3pyblhDWFhrSzUyTmVsKzlxdDB6Rk1nblhqS2ZOdjJt?=
 =?utf-8?B?TlV4QzdGWjJqaHJjQ2d4MnBnb0RIYzNtUmJEUHpkRmtPa3h4NS9VZXMrMURi?=
 =?utf-8?B?aHZ6MURNNFRWWGxmZXdiU2V0Nm9FaGVHTTMvaDcxV2VERXkzKzlhQ0xrWUor?=
 =?utf-8?B?N1c4MW9RRG5DNGFZYlZNYW9tTWsvR3MwTGZVaVZuWXlsR1lLWUNuNlBvb0Z4?=
 =?utf-8?B?VGEvcmdXZlRsemY4U1o1YzhMOGl3NjNOaXVjcDJlN3NWTHZHa1c1ai81NDNP?=
 =?utf-8?B?cGF4NlJFMUx2UnFnYTA5Y1hTdFkxcWZ0amxIT0FPUG92S0hCQmRnRVQyUWxp?=
 =?utf-8?B?cHFxVzAzTFFPREl2c0Fybk1NYiswMDJ0Qm9FcC9xSVpabnBIYmVDWWxxK2JM?=
 =?utf-8?B?SmRxMFFZUFhydjJKaXQ4N1ZVY1h5RXlncUkwdVpVTFRSdGRuWEg0YVg1ak1S?=
 =?utf-8?B?U2pLUElCc0FTb01QalFNRDl2cWRkM3J6T3VCMVUyMUN0ejgvT3BxeGZwTGln?=
 =?utf-8?B?UkFTY3FoWnIyUjcrYmFOMGljN2VBeUQ5SGNBK0J6bnM5N3g5K1luSG1WSGpJ?=
 =?utf-8?B?ZnNqNjN2K2RIU0hxR2NHMnRSSU9xU3lFaEh3QUxXM1VHajdITm4xQUEySGYw?=
 =?utf-8?B?c2NIVjFZUExQdU5hUUJqNG91UHRNaVBKWTRlMDI0aDhseWtQNU9jWHIzeEg5?=
 =?utf-8?B?a2xVK0FXYUpUQ1FvL1RHVWZHMzdGLzRIbEVnZE1vd00zMk91Vmtqc1A1L0lr?=
 =?utf-8?B?Ky9oT2swODVxMTJoZVFIalZVZ0poVXFCREtiL2JsNFZ2V2RFOTAweEtvTVlm?=
 =?utf-8?B?Wk4xWVFqT3dEanAvZm5CeWxPWmlNMGtsRklvVEdVbzUvdzc5REIydklaNHNi?=
 =?utf-8?B?OVNoQVhYRmtEdzdvelRvcGxyQjB2TkZic0JrUjZBSXJ3RzcyblVZekkvOGsy?=
 =?utf-8?B?TDVseS9mdlk2c3FHY2ZYZzgrQ2ptV1ZOQ29ieVpuRGsxRzZidGZTR203ODVJ?=
 =?utf-8?B?SGlwMUVFQTJzN0djTWlVcFRybGtlc1RoSUtxSDZuTDJtejhJSGZCQ2x4MzdD?=
 =?utf-8?B?MW1RNzF6VHc3dDkxY1ZIRkFXSWdBTTkvMHFmQTRzbGZNVkhUZmtOdHR3ZXpm?=
 =?utf-8?Q?GVdrxjhDqmjMk/mCaUZU/58neevwYanIu44aa?=
X-Exchange-RoutingPolicyChecked:
	lgDyl6AwMWuBpGywzBHHZGQ3tHEiLtbH1jFL3Y/74I0RzaTUPYT940kKTdk4E0wfcCRFGDqbpTxNMaQkwixhoFhlC4iJdw9NZ9NR8vAY1Y1Bi+CBLa1KrmBYVdKBArRoJordUQXoNZGdfOrB1TWwBIwFb7EG1/ghBjzJDGTgi6n6s3L4hxA4alqr7rJz3PyjG5AvGoWtoStRfcgtLl6oknhdhwbrViETqsh2G4aHCOf6vgUBNwp6pWFFlkJrAYSQ8Vvj7BH7dKpVpj+1TY5rjXIze/LaZYYpicgKudE28kxnn23a9yTKJHw6eg2pMp//SHbi2bXfdnMeSuNCaF0hbw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XCJ5z6QzU70ZrCbE/9yyySGa5BqHG9zBrUTU9tMKsnKhMiACd+7GQ//MoQL4ZR0Qr/kRuQ9qRxreJ6w6ekCSQvq6DOxOwHimA7HIt1Xi7+xs5DTmZNA/YUrD9ZMaErJpM3/0/uyVhq/LGD353BgEBzav1gBWBYqbgERWUlRGQZnL8f7BsZ5wZlNS8+j3lrjRCiXj0F7VI+TJYDLty02UfYGJWdteXaIjeTSjXKZ/+RfLVKXjDQHeapeELZhreeUl0DGoFbmGT1j/2NYUZLkhFX2CJvXFYlLt6D+Awn1AW2Jk1XgQwl1UXvzZVPvd51vjtvMCo0xKB7cIz2lS8QZlIa5gEcyYM7LXzLRKy0r5VJQYIR8HjJKwpdRZdi4Lq3nOHn8YBZRde2SUn7EMBqOv1Y5hazM+cxFahzJBgplQbgeiH0BDnc3gcztwl9oipshkp23yKF5y4Nlj0EyHr+jdCCtEfrpbq2pDalxXjzsQLQqdluH10adrxYMaIdblKstn2IHgpjZmw4futqtn+LreZo89cSd2Va8m/45vdB7FRabsQdO+PcQ9yv4g2cVEmWqY4Os2H/9Us7MFWCWfqabt4uNEqEQ8k7zZz6pVP5xn6zo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b80e314-3933-4ec9-9545-08df474bc86f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 21:18:12.2039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NR1S8hjgN+orP9mZPN/WCYnSFSXl/PruHnFhweBt+/WryrRSLlLv5QPC3wjQomBG1DNnsYBPF4pWSe3H7xCzGpbE0IDSvBAeNsVtJFsV3EzSfKVo+sAMTzrTjqMKmXMR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6818
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611200084
X-Authority-Analysis: v=2.4 cv=APpTTis9 c=1 sm=1 tr=0 ts=6b00b918 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=edf1wS77AAAA:8
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=fwyzoN0nAAAA:8 a=hSkVLCK3AAAA:8
 a=xGAvDSoXAAAA:8 a=ag1SF4gXAAAA:8 a=ZU3OVQYHUSHpjjP_CD0A:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=Sc3RvPAMVtkGz6dGeUiH:22 a=cQPPKAXgyycSBL8etih5:22
 a=I9AbH5bZuplaqbmfSwNo:22 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532
X-Proofpoint-ORIG-GUID: bExTQDlTVJC2gWb_te9Qt5Sg1WHJ6Z1G
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA4NCBTYWx0ZWRfX58gdfl2tmDyk
 PnpP+abxEGl3rCFTfkzFs9VET9uoqTDON1KCn1Mw2Et83nJl9iiHAtg5oFHA2H59Xp3fBJEy41T
 jVkpCxNsi1OeeT0iWWn54qU1kH5bKdxkefDeKY1p5vlP5glhTq8p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA4NCBTYWx0ZWRfXybRug1Giof3Z
 UuFqfZGyIToYHqZt7ZoGLMmDfkheZEYelwDEtqSyIfjdMmm9T+0tYNFXgIrqeD2lI3h/nPgEKS2
 xjT+rZ24kH+k/cNkVjtqTTLKBlksj1PPT0omkkZj+CjvyyvingIZjwaqK0wXq4iqNDGt+wD735V
 zg0rex1p3F/bVJjlhdHRhfvuPn7vJvkf2HSRp2h9vuXVrv8faiOOdbLTHeKHTDte2A5uvI6ZLqe
 17h+6wVp50ET2V8fuuf0tHu0PVi1VD884LHydott91kFp64+vE1aDsmgxXc640X8dXpHLfwSnZL
 XTbwHrBh1o0uJjsDFQ0PEOlWY04z7h5kqz+SzOKVS6yqbrUydL2ZxfJ1xc03UdID3M5+S4IBKul
 R4DX+MN8qFz6hZLOSeWOhLvPx2ctbrq/rT8IBnX3jH0mc8BkXCuvPlmn7PWZ/+i6/0ltvDqv2QB
 HYHvMQnO45zEec1KLHA2i7/9awIahL1X+iFdIBkE=
X-Proofpoint-GUID: bExTQDlTVJC2gWb_te9Qt5Sg1WHJ6Z1G

Hi Greg/Sasha,

On 18/11/26 8:03 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Rik van Riel <riel@surriel.com>
> 
> commit af452b9e01331b5338a1e5141624f17607239207 upstream.
> 
> redrat3 stores its device name and phys path inside the main rr3
> structure, and the rc device's device_name and input_phys point into
> rr3. When the RC device is registered, it keeps those pointers.
> 
>    KASAN: slab-use-after-free in string_nocheck lib/vsprintf.c:648
>    Read of size 1 at addr ffff888051fda758 by task udevd/7464
>    Call Trace:
>     string_nocheck lib/vsprintf.c:648 [inline]
>     string+0x216/0x2d0 lib/vsprintf.c:730
>     vsnprintf+0x74a/0xef0 lib/vsprintf.c:2945
>     vscnprintf+0x41/0x90 lib/vsprintf.c:3014
>     sysfs_emit+0x10e/0x180 fs/sysfs/file.c:761
>     input_dev_show_name+0x58/0x70 drivers/input/input.c:1282
> 
>    Allocated by task 10:
>     redrat3_dev_probe+0x477/0x2570 drivers/media/rc/redrat3.c:1023
>    Freed by task 10:
>     redrat3_delete drivers/media/rc/redrat3.c:466 [inline]
>     redrat3_dev_probe+0x1bf4/0x2570 drivers/media/rc/redrat3.c:1124
> 
> Syzkaller triggers this via usb probing. It probes the RedRat3 USB
> interface, which calls redrat3_dev_probe() in redrat3.c. That function
> allocates rr3, then builds an rc device whose name points into rr3 via
> redrat3_init_rc_dev() in redrat3.c, and registers it with
> rc_register_device().
> 
> When the detector enable fails after the RC device is registered, the
> probe jumps to the led_free path. That path unregisters the LED but does
> not unregister the RC device before freeing rr3 via redrat3_delete() in
> redrat3.c. The RC device still holds device_name = rr3->name which is now
> freed.
> 
> Later udevd reads /sys/.../input device name via sysfs_emit() in file.c,
> which calls input_dev_show_name() in input.c, which emits dev->name which
> is the freed rr3->name.
> 
> When the detector enable fails after the RC device is registered, the
> error path must not leave the RC device registered. Make the probe error
> path clean up the same way redrat3_dev_disconnect() does.
> 
> This change should be safe because the RC device is fully registered at
> this point and its teardown via rc_unregister_device() is protected by
> the input device mutex, and rr3 is still alive during unregister so
> device_name remains valid until after unregister. The URBs are killed
> before rc_free, so no completion can run after rc is freed. No new lock
> ordering is introduced.
> 
> Reported-by: syzbot+302b9b575a06733ff60c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=302b9b575a06733ff60c
> Link: https://lore.kernel.org/all/6a74a76d.ec7c9571.3ac9bb.0056.GAE@google.com/
> Fixes: 2154be651b90 ("[media] redrat3: new rc-core IR transceiver device driver")
> Cc: stable@vger.kernel.org
> Assisted-by: Hermes:muse-spark-1.2 syzkaller
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Sean Young <sean@mess.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/media/rc/redrat3.c |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -977,6 +977,7 @@ static int redrat3_dev_probe(struct usb_
>   	struct device *dev = &intf->dev;
>   	struct usb_host_interface *uhi;
>   	struct redrat3_dev *rr3;
> +	struct rc_dev *rc;
>   	struct usb_endpoint_descriptor *ep;
>   	struct usb_endpoint_descriptor *ep_narrow = NULL;
>   	struct usb_endpoint_descriptor *ep_wide = NULL;
> @@ -1121,9 +1122,12 @@ static int redrat3_dev_probe(struct usb_
>   	return 0;
>   
>   led_free:
> +	rc_unregister_device(rr3->rc);
>   	led_classdev_unregister(&rr3->led);
>   redrat_free:
> +	rc = rr3->rc;
>   	redrat3_delete(rr3, rr3->udev);
> +	rc_free_device(rc);

I ran an AI-assisted review of 4ea783d0eb10 in 5.15.226-rc1 and
checked the cleanup path against the code.

This backport can free a redrat3 RC device twice on probe failure.

redrat3.c, redrat3_dev_probe():

     led_free:
         rc_unregister_device(rr3->rc);
         led_classdev_unregister(&rr3->led);
     redrat_free:
         rc = rr3->rc;
         redrat3_delete(rr3, rr3->udev);
         rc_free_device(rc);

In 5.15, rc_unregister_device() already frees unmanaged devices.
The driver uses an unmanaged allocation.

rc-main.c, rc_unregister_device() (spacing adjusted):

     if (!dev->managed_alloc)
         rc_free_device(dev);

Upstream (af452b9e0133) ends unregister without that free:

         device_del(&dev->dev);

         ida_free(&rc_ida, dev->minor);
     }

The extra rc_free_device() is needed under the upstream rules, but
releases an already-freed device in 5.15.


lets drop this.

thanks,
Harshit

>   
>   no_endpoints:
>   	return retval;
> 
> 
> 

