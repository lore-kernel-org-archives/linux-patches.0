Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C09B4A35
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 06:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748931047; cv=fail; b=BeXebul184dDjJp7JlKwgXwpZ/Osu9h151tW0k2gn45whCH4ABboNulBEAwQwzn0tLZVhvIb7v50x9/t9UW8IWouc3vO1BTz5jKGhLBEicl2aEfcLJYCRyh5h2mKekIbV4JquPG8/OK907hrSZVUP4C1qIAyz+Sxesa852JodNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748931047; c=relaxed/simple;
	bh=rYBVriLUtz8g6GChMYeLsC38D1sQL6nhFcF2Un+RdRg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Koz78O9mXdftSPbnc2mZRMxSh9HiUr13iIC4c99X+9RpVPe++PsvaeFThgSDX0tqyHFPNwgJAmZs0WDRXVzO0ZDV1G0SlqAPDJ1Wf/1Q6gmaNw4B7B4+6hwuJPSh5k/ffvXoGPbKA113R5SU39BYg6GFZNZkm4jsFV+AK/rkKH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gK9k8NoQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WZu7Jntj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gK9k8NoQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WZu7Jntj"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552LN1Er010956;
	Tue, 3 Jun 2025 06:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TS+QwoqEcXpxcngsaICcjJEhB6nvxq/QnedVTrsZLIs=; b=
	gK9k8NoQ3u4rKdC96EfYDqHTegiYnhJED2q0tFj6qoOxUKM3xbfUA77NmAf2mF3/
	Dt7uizkXRGHSYsUQq38ukWJnOGuauS5QFzIG/MEcgzfMuPWyC+4BM4bprTrD7jdJ
	hsXJEfobKpyLzGjXsHis2UvGpmV0aoh2R7Njn+jQFrcCrdvJ85lOWjSp+dhq92+s
	nsRgSpklGAk59KsPQoCCi7AtrokNPHtHIJUQfau0eqQOcVFtZR07CIZZQ/6bkjPL
	m7sIkRvBGdRsfqUEqPMNcv6EDsqkmPWzj282AoBM8LLClKPcXf+7pY43ENk5jAF+
	WvRtH9bHJDA615AJtiXRHA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8bh5mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 06:10:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5535kwDd030831;
	Tue, 3 Jun 2025 06:10:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78vqft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 06:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qNXja3MBfog1eijfUwjm/jcP8VsrTxtV7lyn98L7rzh+q7P2cZVlyvLLo/3x+XUWNP7x6mixX+3jptL9gMnUYQscEHVoLSa/g8qq9jEKCEsJOnYT5My1gy397d2peWi8Gje1UvBLr6z8X6kqjYKtAIfmJBUy3JWo/e120Q8mur4Zg0su+BO7V1e+15AJADOG7is0OhYFeRmJjq7PFgshPcDNnHTdl/1gFkP3DEWjYTFnuoXKpQjLStHyIPqUJ87r83/+VHQ2MoxdcteiFqe+fpbc1QFvW3Nq7zN81L4XFG3tC8heVXw2DY2angFiOt8jAca3jbw/c6cK600NS/OFCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TS+QwoqEcXpxcngsaICcjJEhB6nvxq/QnedVTrsZLIs=;
 b=iTl6R7btv/n99JkYqe7TGN+Dt+cOvnQW/aS1bv0O74pf9q2GHmpY8pKuO1UUbkA61zQXGJ/t+34frZF1BKeM6z7nDgJNsr7PlnqPrSuvUrfh9jFbhs+pmUWPSg6srmdKsu7ksgibeRnx9RmqWD1Ro+EbP05EI5GEyNS/+xVI8Vbd61V4jtdMrbxZrZJyneGHr+tclkDjH4V77kuDytNw3R4YlfwJYQzMPGcynh2oemusE8SvKwMSPEygBD+RzljxQGRw7PVWNm7KeiwJVg0rbrAIUlCO5rU1JhriaKdDqrZAL5hxNRrNZ0gbSxHDfDRUQXKljJ+9cpRHfDSsEDitMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TS+QwoqEcXpxcngsaICcjJEhB6nvxq/QnedVTrsZLIs=;
 b=WZu7Jntj6Yl4J6e8bxpvv/wWi1UTSFs+70pchWaHNtSWgsLd41wsg1P9ljelrL3aYfIHS3pXqqvaku5LxP82zwFr1oDQHpyi03ZGQBBgnsNY0OKhyU5dwHq4wd4NLXbY8PpvXV1qL8ptMjA23Xn2vgK1sZROiKA2IUdn9CW7Dgg=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by BY5PR10MB4371.namprd10.prod.outlook.com (2603:10b6:a03:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Tue, 3 Jun
 2025 06:10:24 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%4]) with mapi id 15.20.8746.035; Tue, 3 Jun 2025
 06:10:24 +0000
Message-ID: <1cbb59d2-08e5-478c-8a6f-97cb7b428146@oracle.com>
Date: Tue, 3 Jun 2025 11:40:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250602134238.271281478@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::20) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|BY5PR10MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fc8ab3b-82e7-4154-98cf-08dda2655420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUROelNqY3NkSVE0RlRHY1hTcCtzR1E2eTNhZ2c2Q1ZGR0lDMk1BR1BjcFFK?=
 =?utf-8?B?YmVzRFBib0dvY2xySHNFTUh3WDVnNy9PT1JkN2pOdHlCMCs0NWptbWlqRmV0?=
 =?utf-8?B?enhrcHJZY3JqeS94WWJQaGZidkRxaEdnamQ0dndqSW9zR2VWbzNpSkRxWkFu?=
 =?utf-8?B?MmFZa0dUNGVmVTlSWnZ1TTlLKyt0VFp0aGtYVlJDbzdSbW50dXNxL2NhWjFF?=
 =?utf-8?B?RzNJdVBHYy9xVVB0OEFiVHp2am9nVHBDTFB5KzRlNWJrZU50V2dEZWVseksv?=
 =?utf-8?B?Y1pTZU1oU1FJYkpldVhrZitNbnF5UDRnTkFVUWdndFdwRXlyVmhuT211cTh4?=
 =?utf-8?B?RjQzd1ptZ2p4WC9FazQ1Um9zdDNLL3ZCd0NnWHhWTnQxRnBSS0RnTkRZV0x3?=
 =?utf-8?B?T2IyT29odTZPaFlQZjh3M3kwZVdkQTU3S21oZi9Eb0xSdG9lQlBvN0xLczlC?=
 =?utf-8?B?YzBpVXc2ZXY2SmgveUFXSTBsRHFsWGZ6TW96RFNydzc4Qng1YWdVVjRDVEVq?=
 =?utf-8?B?RVhYWEFFazd3Z3UxREhIak1la3ZrN0cxcDNTNHAzeWgyZkQvYjJHQmxkMFB1?=
 =?utf-8?B?UzA5TmRwOGtJOFpRQ0kxY2xKZnVqWVRPK0VscVkzOWJFUkE3Y2tzNW1WTzRF?=
 =?utf-8?B?M0NPcjR5bkZ4OHNTeHJFNmtVVUxhYjVPSjZlbk5QaEZTL1Nqd0hXNEdTck9l?=
 =?utf-8?B?ZVhZejBBcjgyeHRrRjViNkpHbG9oRHp0TVRCVG9ORWhHUkMybml4SGV3WjA2?=
 =?utf-8?B?YzkwRzZvN0t1UEluNXFnS0tScXRpUThWRXByWURYUTEvQ2hIaEZaWk83Uzhn?=
 =?utf-8?B?RFFSZTA0Tm9FWENMak5tdGtzY3FoNEdpYk5nRWoxZ0h6KytNRTcrUE9hZjJv?=
 =?utf-8?B?YVorQll1TnhtOHkzQS9JKzU3c3NyOEptejNHYlJObXBOUHg5WDV5WlFLS3NU?=
 =?utf-8?B?ZkZ5aE05M0hnbXRPWW96ZURDMVV3cFRpVnd1M2k5RFlXWVRVdVA3SFlWbXlM?=
 =?utf-8?B?OTl5cng0bElKTitvcXFHdFBwdmpvYXBnVGlsWnNvSFRhMGJ3K04rV0dwUzMx?=
 =?utf-8?B?bGJOcndXYTlJdTJMeU5aOHIva2Zqa0lsR2Q2N2FkdGhDTXV5T0dwVXp6N0Zy?=
 =?utf-8?B?QVU5RHg1U0Q3NjRqYklpWVpDbUJzbTV5NVpSS2I0VEJlNHUwQUJZK1N4QnJU?=
 =?utf-8?B?MXRPMlZObXplVWs0VWYrMzYrMXRRWU5LMXFEWncxa1RxQmdPcEtJTitiS0Vp?=
 =?utf-8?B?cERnVEZoZFl4dkZDQ3EvT3BudU1nTVZhNFFtUURLc0FzM1N2aGg2WG80TGwy?=
 =?utf-8?B?S0RrWmVUNE41SjQ5WFp4UHBGUXptT0dpeS8wMmN5bVRIc29DWVM5Mjl0d1Jl?=
 =?utf-8?B?R2lMS3VOSFBmQXUrSnVKdnRNeStJWVVUWjFpekhZb0xZQy9JNjlNTXIrMHUr?=
 =?utf-8?B?N2diVWNpK3FkUitBQlJoOCthN2ZaSW1aVGNIQnFKbVd4MUF2aHdwV2pIbFVJ?=
 =?utf-8?B?SnZIK3JpQ1RsalNUaW5ERUsxWDZtMWNFSURZMDRhOTRKcTRIOEhKOGtuN1RY?=
 =?utf-8?B?VVVhMnlTYkpnTkkrZ1Z0T3NGckgzTTBaQlRjREI3Zk9taFphclVkWkRtbGJE?=
 =?utf-8?B?UFRGa1FQa1FyU0dkb2w4VHVNdG9Na0VTVzB0ZlZWOFk3N2xMVjNmVzlrcENU?=
 =?utf-8?B?aUZjTStmWUhFRC8xQ3pHRWwzTW0rbitmT09GZGhnUVZoZXU1OEc0Z29rTlpz?=
 =?utf-8?B?cHg0aEdPZ1FMMURmdnMrNjA3eWJjb1YycUVLbGM4YjZBczBCM2duRXlOUVpn?=
 =?utf-8?B?SWZLdDJpQUNvNDVxTlVzN3h3ckh0dERPSytQYUU4NGF1eHRRODdBdE5uT3Ur?=
 =?utf-8?B?RWZsa093dTFFSmsvSEhjTlRTQ2QyNVVZNFJvWEl0Z3lKM21FSVc0dmRMNmFS?=
 =?utf-8?Q?tHk/JZSpEwk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUVWNGZpRklYSDhTaUhOZklJYjg0dzlqV2lEbU5uNVlSZTh1UFJadWMydXJk?=
 =?utf-8?B?Z3BFdHFGSVFRcmFQcGt3SEJrY1c4ZnNzYnlobnpPR1h4YWIzTnRoOEpqWTZs?=
 =?utf-8?B?cFFQdUlESnlUQW05QmxNZkxKNWx4a25MZFJlQjNrYTlGZWowRlhMRlJzSGN4?=
 =?utf-8?B?VENaemxHQWl4N3VrNXowQnVQeUtqcDQxb0c4cWl6YTdLVlhucGJ4SkJxSlVX?=
 =?utf-8?B?QXR3OVdKMmdGeWZpdW8zbExQa1hqNlV5ZDFqckpGb2FiTGMwKzdyRlJKYTRp?=
 =?utf-8?B?OWJVMlk0L0p0WllHSjJpb3owdi9kTWtNUEE0Z1U5Y2tZR3ZhalkwdWF2VGxB?=
 =?utf-8?B?WkYwVjRwMXRydHBkbXBQVkZiOFBBNUR1d1I0VVU5WlVQU3NBVkxrcTl5TU15?=
 =?utf-8?B?MExudnBIVGFXYlg1ekNBWUJiYVRFMUQzOEF0OUJRMDE0ZWNqRDZyS0k1RXA2?=
 =?utf-8?B?L2s1QlN3NnJGck1NT0c2S1krZTloSlVIOU10RW5ieTJidEdFc3I0SW5zN3hI?=
 =?utf-8?B?YVl0WVQzdkpjZHBpcytwT0lJLzZLL1lta2ZYNDZraFBBM2RSRlRScFcxaFcw?=
 =?utf-8?B?T3dtOXBnNThCL25KVkowcTJjS3pSKzBhU01TMytzVytrUVlYLzlIL25ab3dv?=
 =?utf-8?B?R1puMjc5dGY3WE0zUWhYekZMVmZDZDJaQnQ3Wm9FSHRjQTNHTjJMZENxcmJy?=
 =?utf-8?B?Y0FEMVFpY0JFWFU4V1ZkL2dEWE9UUk5DQjczR3J0RlhudTRmUFFxc21haFdP?=
 =?utf-8?B?bG5TeGlTVEE3UTc0WmJhMXVCWUlXalpJcGVNdy9ya0luT0VNaVc1bVVubFRn?=
 =?utf-8?B?RURMVEZYcU1rMUlnMHBtcW9JWkhKN2l3MXZlRzdBbTdKZ2Myem1RUTJRMXRK?=
 =?utf-8?B?d0pRL3BYN2RYQXhUMUphYUV3WDNSS3BJdmhyckpYVnh2aGNram9zU0lpemdD?=
 =?utf-8?B?UW9LbklVTHlySUtCNlNSRW9DQ1Y5R252NXY3ZGNaeURib0lramZseDNKZVcy?=
 =?utf-8?B?eWFhRE42aDBpQ1Z5THhQRDA2bk5vY1dab3JjeENpRUFEaHo4KzJ6QnJ1d0F1?=
 =?utf-8?B?L1A0LzVRYmdkanF6eGxNWEN6T3BNRUl3ck9naVNpRFJpb2daTDdIelF5L2dw?=
 =?utf-8?B?bE1KUFZZZXQ4ZVZ0emlBbVV3ZTljZHkveG90WFFQcU1vTDFpc1pMSnN3QURL?=
 =?utf-8?B?dEhSNWZGaXU0VHptcDIwZDIrTk91TzdueURYYUFqUHd6M1FaWTdtSTl5SUNy?=
 =?utf-8?B?U3VwNUF3ZThpYWN1WmZqNy9ha1VWaEVFZ3oxUCtLK0RlUWc3QWU4bWdpcnVG?=
 =?utf-8?B?eTJhTkpUdDI2aFA5ZGdSUWFRSU05MEU1dzRsOFNOL0M1ejVtSXFtakhyZVJt?=
 =?utf-8?B?cWIwTTF2NWVDSWNDRnd4U0xEWGFpYS9kcEFmRUhUSlVGRkpqekpXeHBGbUta?=
 =?utf-8?B?UGNwVTdmRDJBeXlxbzdSazhKQjdpdGxFSG9TWFhycmR5STN3T3VNZ1k1M1Z3?=
 =?utf-8?B?Mmorcm1TM2QyUHE4dXhtWVZlcjl6VTVsaXJwSzNCeldTL3YrQk9MSm11aG1h?=
 =?utf-8?B?RjZZSSt2TmxycjdLTVJ4NjJyb1dzMnRCUXFHOWZBOHhUNGJyb0ZOVTlkMHdP?=
 =?utf-8?B?NlFJZUVNSnRHU05CVk1oaFU1THdrZGhSaFZrUUhXeWw2Tm96SWdneVRuV3VS?=
 =?utf-8?B?aFB0c3ptOHYzK3ZIRTFQRUxkWXkxODZPVmFudVVIY21CYU4zMklWdWk1aEFS?=
 =?utf-8?B?M2EyVmE0bjVGY3FGUDJIdDlONjQ4NlFXVFV0ejlvamdpenN5aC96eStSWGZE?=
 =?utf-8?B?WFFSWEFpUlp4RVU0ZnIwSVIzYTlDeFRkSnZpcThnUUpJaU05Y2syTDNvWUdn?=
 =?utf-8?B?cWo0d05KbmhPZTBrcjNIS2xUZERmUmlIdjNWVWhRMU5LU0VaUkdEbW9qeVE4?=
 =?utf-8?B?cmVSRXRLYWlpYmF4Rml4ZXNiNFcxdjB1aklnSFpacnRYczFZV29XUVZ4cmZJ?=
 =?utf-8?B?MXN0bzlYVDBxNDg0M0xWTzNxdVhIazF2SjRPMDArUnUvS3VoTDkvNDE5bUI3?=
 =?utf-8?B?blppRjl4bTZOS0E2R0dPUURKendZb1B6RXdYVW1LSDdEY3NRTUNrZTd6Wm41?=
 =?utf-8?B?NVZ2RkZxRGFzRG1UNGFlYnp2cWdVUkNDSXpLRmRwMFdoSDNsNTB3ZHZCSFpR?=
 =?utf-8?Q?DvHlN5k2/8UAe47yYYqBhkA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/c+EujRAe2SD2iDaoxnx2x68F+/eEvxzcp1FJpdiR0L2tWSyLvrLqzYNyLDfeei5wtemoKQYs9zNoMUTXHjG4FG4dNjp+NxDmrTFLrc8i1YZfc2EWw8yuQHq7zygkd7JKvQPqnznpC4QKl1rF1afj/2jRuCuBwMTMWyGmiSy75GcJoY0GvZdLU+BFxVp0jKZBZ/Vb9iI72FKSWR8vTqoevrO+J5TVJK3uRFD81yYT2r/pc9hYdQ8LTMhEQTvauPadAQJ1CfiYhU/XG1sqFtgbdxxwON41bcQU+fZKeJyh4VMEmAip9fl5fM6UU5C8oTe0WsjcIcBvTUqNtzBZIY45vYhO8g/oBjc3FiwI4TP5jc/YrBirLlPy9HojMIBZFDHytl0pHd2N2UWVGX2scEmisdScYmKWWOVi7W5AWap2gx4BlTb+t6uGQsUqItwSfLV4cAZGuJcb1vEdx0uoR0D2/h/3kLILgTiwdZafiLaXkohy0oIRTfpbJs64Tjx8cpcq8y2K9ZZQ2KTlQoo3s1KA8eAsrW2qA+tcO6+Hw/keNXgy+GlY3zktUYbZnv7sjz56T+UuPZwM6QuF3wu8FpWLFUl5BTYro4DwgBI4e1ruF8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc8ab3b-82e7-4154-98cf-08dda2655420
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 06:10:24.7473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lua/WdaKgdDMalnCtG5S5wkqx0xgAhXVKtkn9Vt1m5H5zcE+Ys8atTN9/avhXeJahQL0JXWrsxhfKAFIMPdzyhdQ7F7zQqP4gL0ggju/zURQmnzas8r2PhYuWgxyWNMG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_01,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506030051
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDA1MSBTYWx0ZWRfX9iiYYNX0Q48O tQEaudFyTzWoLKuQtcKzlCbz+XWIXzO6pDsggCyHtkJKWJ236Pn92iuYAzvHXVnD6c3pXqis+SG Gh5mPll7HWXNOy/ByQ/V3r0fOg/+2swZFAf7u0M/xCMoUcB2h4fB5Co3ZrH0ALisrjQuL+DqWJD
 /cuze83QlWgQyqe2Gk0Un3GwJw+MXwVgqDBKVXIF12Jg6/2UNd+Jqp2YrR2u6HcL+lwb6oLtyEg o4I85eIUwBDhQ94PRgp3D1uul/2Ebr0GraPOK/TQ4+DpljzA99l/xj5v77FZINPUTCGbD09V5kF R0NVD5mGYTqr0CS3SX43S5lkGGQN0tpK7lrwV/V5BixAN7/JfyRe3G+ynoJwFKIFxmq/R1LTXJc
 MPZIUdZla3JgGQR81/B5roPLINHk3UvtjwAOXTU98dYrjFo7jBWuu0nJFsMWH5AYba6U4Jvu
X-Proofpoint-GUID: Y_y0Y9_BJcjoKBq55S5w_n7DPjGUC1oJ
X-Proofpoint-ORIG-GUID: Y_y0Y9_BJcjoKBq55S5w_n7DPjGUC1oJ
X-Authority-Analysis: v=2.4 cv=H+Dbw/Yi c=1 sm=1 tr=0 ts=683e91d5 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=cKehCjhk2IfrQodDBDEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714

Hi Greg,

On 02/06/25 19:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.32 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
