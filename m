Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E2A13BADF
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736345575; cv=fail; b=nv1VmhDwhhZJ486lCaBqc9R3fT8YN6h4eLBonzXny5dILcc238vuREruR9fJP1F4tn2vjNlz4DRY9AiWLqH0krOsKtT2cVtkYVXB8xbl/8HZaMp2eDtG0fEXmhmJlPtYITW8+8sHG9fkwwOJTbbUa3dSVa+qMOjOJVOL6VmQR8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736345575; c=relaxed/simple;
	bh=VO/yk1O7Z5/jrSXESHdDdDSuyrTp8FDQSA5JmbYtQoU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BKcEmdGmP3en7xEuHUEqk0OPx9KQ7pPPgNLY2zg/8W2R0Jhl1eNgFprMmjX3vYIHqfel7J10+vYQmajbb6TSN7I8pvjnwlNllKuiOC7nZv2kFHdTibPIrmMdLEhAxlzi+AQTVTTY3B3hOx4NGnybbpML+JCYoMZ8IIM+ZNwCBXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A/3TvUPt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UrMwkPYS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A/3TvUPt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UrMwkPYS"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508EBpj5004245;
	Wed, 8 Jan 2025 14:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=x3s1vLX7RGxQkF21PVN8Z/uS1Fml8Pea63m+oTtS+58=; b=
	A/3TvUPtrNQzRM6bbtJ61Nsybasts8/cbOSgjJGrrP2uuxaAPdzNAw3wArdIEAHM
	EAGKpHGdkzwEvaWmZgLW5cc5Sd3iNnBlXfUGObJe8WsRgFoIW//l8YfQWJ8kgrvn
	2QtGhHPITdaPiR4hgA1iE2b8B0xpx0RjQHmMhmMa21T7rNa6oXVp92+q3JhDQ1im
	dGzKq/1tBElISVzX1Pjjo9nnzxSeiep5XGsbqB6xJ8kB/8GTQtlNdfoYhkVJMEx5
	TgTVs1ntfhegE2R0nvwfQaNWyZsFVjpBKdtYM+69CfHcTv+02pA9TTB+g8x163p9
	T+/pgcMs59huQWQb191Oqg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuwb6x58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jan 2025 14:12:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 508D0RjD019961;
	Wed, 8 Jan 2025 14:12:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xueg4sdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jan 2025 14:12:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FqdORuCNaHnVHJn5hs9n7vKxEE+88JGpoLJlOuthBfOJ+6bKIRTushEJU1tg3VzHAiUIoQjnf2F/pSu4pkvxn0a4FPsNk2qUZhG4U3hCgjuMV4s10IVZSpOM7Mggtb+A94hR1CNEkNUg7D+kHyEkCZ+fqp2jgnLPfPWFOesDuB4OfIYqJpUN5AkGjAv48WhmEhJU8bm1MvJKq075oGloITQ8dXlN3I+gP7eu4cF0mPMUM1gApPdIs31REbXtsG3693VRzLqnOHndW8eWOgDVsPIuK2n5YtNrCL6maYrY7hsxtZIHJVWWOIxvKzuw3nP4ZGuVTL7cZoeCwD3lGpIcwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3s1vLX7RGxQkF21PVN8Z/uS1Fml8Pea63m+oTtS+58=;
 b=X8QHTvqY6vpRXWk5ODx88qhGxOJ2Bt+YuEUstX4LpsQ4rFvomzjV2F2a0mpMZCPbDH7rDUA9rurJMUlZOVr1hY4MZJi4nIQ2BNBJfIeWZmw9Ap6dECR8NDqYUrzzlnjZuzQ+JGWARuOtZFzdgVBm2oc39Tvp+bbeXJFM2Ig//7w40QO8oXMriMcTUtzDyZZXeGrVcZJbRuKUpLRrQYkWsCutNU/SxkhxCC9Ixw60qJybv+WWKFT1pAtcxF1a7HzZoU7i88dTHnecQE+IH+sO1qrKbp3RbuxwSFrMjH8pQHH+H26FpBGsUqRtn6tk20/gocpig9hqi414uy+QLalYDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3s1vLX7RGxQkF21PVN8Z/uS1Fml8Pea63m+oTtS+58=;
 b=UrMwkPYSBMXakmuHAS7pBThzDAERzvMEXfqukFFdDQTbEAuBwRYomX3rWAFpkQTY2hQPjTfAZl5tnk9aUa3FCVGMAK5d6OMNE6AX5b/J7ski2KkcCmLXMJlXufBwbWcv0+zPeRII19FH+bOb/fwlAQ82PwStbdWadsogm1s7fIw=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Wed, 8 Jan
 2025 14:12:36 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%4]) with mapi id 15.20.8335.010; Wed, 8 Jan 2025
 14:12:36 +0000
Message-ID: <ea7733df-e66b-417a-bd96-421b0623b2d6@oracle.com>
Date: Wed, 8 Jan 2025 19:42:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250106151150.585603565@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0019.apcprd04.prod.outlook.com
 (2603:1096:820:e::6) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: cc9a27d5-341d-4ef6-7b0e-08dd2fee8096
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkd0MDFvUENhNkxhSjFEc2wwN1M3VERLdW5YV3M5cVFsVEJ3WkhEUWtLSHFY?=
 =?utf-8?B?RlVKelo1OTY1V0ttR2s0aXdiMmNINmxsbk1TUXhJeDdabEk0T2wxUVJJYzhr?=
 =?utf-8?B?Q1M0RG52WlJJOGw0Ui9YU25LK1FzakdrWk50TFRWdVI4bU5QaWNLMzJraUxY?=
 =?utf-8?B?SThZdUFiNXVsNkhGSUpmc0FjYTNrV0FYWkdnYlE3ZmZicjM1Y1BzRmJBZjVB?=
 =?utf-8?B?SlRZWFhnUURoZnV4VXgvVlJQRzdBQnFEWXNWREUwTjcybGZVSFgwdDVEK3Mw?=
 =?utf-8?B?VzVqckE3alkwWkROYjlRQjk2QXNlU0tzdy9YRE1vNUxtbHNUWVJCT3paUGdY?=
 =?utf-8?B?WUFFVERNYWdwdmhtZjVXVE5MU1ZNY3NXVlQxcFVWK29EOEMxclhGUWYrUjFG?=
 =?utf-8?B?R0hxZlRISG5jN1kyTFlsUFVNNE9rY0V2Z1h6VFZ5am5aWkFCRHNaRkxhT1FF?=
 =?utf-8?B?V1VyMVNGZit5R3phTVBZTURwVjA3d3dwRWNHaE5tZEYvZllLUEJCbjBzVGtK?=
 =?utf-8?B?RUJzY2VZK1JlVXBpaXhzbnlQY0oxbEEyaTE0RC9FekgyUE9RTVpLSUVqNmFN?=
 =?utf-8?B?aGlweFdkVVBmdEVvbVoyeHZnTlRNOG1Wcm95NmpIWDVjUUNGUzc3L1NQVUk1?=
 =?utf-8?B?MFRzcSticytMbGJCZG52OVRqemNaVU56NFJtUTZSS2pQOHIrOE8rY0hMckI5?=
 =?utf-8?B?WTQ2ckFiNm5jbG5qbDNTallxenRDWlZwUG9CNG11VUYxRWJVNEJiS0hqc0N2?=
 =?utf-8?B?a3VsZVF1VHg4L3haalkxOEUwUlhCS1dCa2kvNll1TGJ5b1BQcWFBaUhGNVU4?=
 =?utf-8?B?b1ZZa0hUUWNQTk9Wdnd4RlZ2Tm92OU8zbEJQelpCeENVZW9QSnNGVFFyRGhU?=
 =?utf-8?B?VmRHSk5wT3JhL2hoUWp0OHEyL2JHL2swUktCQk9vWkUzMEdORlNPcXV5YmVz?=
 =?utf-8?B?aE9hMDVsa0d3QWpGMitlQTZiWEVhUXJGVmhnb256ZXhxV2pXbkRuQ0F6anRw?=
 =?utf-8?B?d1RuZFU4eHk2clZ0K20wNWVydkFodGliaURwenNtZDJzQ0R3UENwWUp3MEtQ?=
 =?utf-8?B?ZGhRVnR1TG1RZjRHRGtNMFhJNlN3U1A1STBIWXN3b29HVGk3d0tnRmdLNFVG?=
 =?utf-8?B?Mmg3OU9xR2lLSmVKUys0eTBUS0Z0VnprcGk1eFIzUy9UUncrOGhNcVBFd0tx?=
 =?utf-8?B?djRTL3A5ZlpaN1JvTzRLdUpBY0x3UE5nbUpXYzFSUzkwUDVCZUZmb211YkVO?=
 =?utf-8?B?Rk84OGhoeUpGLy9SQWNEYUVISjFGTTJIODZBZm9xc0UwM1lTazI5VGs3UzdV?=
 =?utf-8?B?dGtqdTIwT2ZIc3RhNTh0bUlHeTRJTjZFcVkxREpSc2xjeFQwUkMxR2Z4U0Uv?=
 =?utf-8?B?d0dLSHpvVWh2dTNaQnJnZVVmSnYwMEEweE1Zdk43NjFMMW1YOEtXVTJYTXlx?=
 =?utf-8?B?YmVZUFV5UTNDY0g1MlZqMXEwWHFWVkhGK0JVNGo0WXZDZDlSZlVZWitMN3I4?=
 =?utf-8?B?eXdWSTNPZ2tKUk9FSG5kczVBZG03V2Fxb1NDMUVLaStLRHJpeEFlNEU2QXdB?=
 =?utf-8?B?TjcySE05RDl0am5KbGNBdmdCeDFYRXZZL3JrcFVuOHFXOGpHcWhkVWRKWTBq?=
 =?utf-8?B?REoxU2Y1cUR1QzBTRVNOK01zNENJaGFrN3dnTVVzUkdCb09adXBCUVlDQ3hn?=
 =?utf-8?B?MEY2WnljT0lwMGVDNk5PcW1CbHNoVS91VDhuZzdlYWw4U1hNOEVRQnJqZElu?=
 =?utf-8?B?UjRSWVJlWG9LczVIYTVEWXcralJVWmtBSk1RcGhNczVuclhFK3FoKzkyM0tw?=
 =?utf-8?B?VHl1MCtkSnNROXpJTXU4eFFKTWdHZG9ucWcvWDg3NTNKQ3VqMjBiVzQzNFRw?=
 =?utf-8?Q?ra3gP95LhHlta?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHB3a2srZk9Ka0sxekxCMHNhd0diMXBVdnQvallWT2NRQjg1UnQrKzYwMzRO?=
 =?utf-8?B?bXViL1BFSEhLVG1JMTRDS1dxcDN0K1ZJaVJpVDVmcVBLbmZLNkZERDdEb2sx?=
 =?utf-8?B?ZzloM2E4cHdrdWloSXI4Zkl5M1M0cEVVanV2a2VVOFNKdHZrV3k5Q0R3amhF?=
 =?utf-8?B?ZGJhSlFaZ3NyRXYwRkZTZklhU1MyUGxVMXFzeVJtM0xRcFBkMVhMTEJoUFdo?=
 =?utf-8?B?bjd4eGE1bXVGZVozWG1ua3VNSEVzVTJ2SWdqcktaTDMwQk4yL012eWYrOTJn?=
 =?utf-8?B?UERjN05NbHZ5N0ZPcVJJSC9XWGZ3RytuS3hUSjZEczNJM1Rrd2VEeGxPVktS?=
 =?utf-8?B?YWVMQTIrcmtLbG5hVjBHZFhkc2h1aUp2Z2dDK05qWCtQblJJcXRtR0d0ajdX?=
 =?utf-8?B?cjBjNDNYWno1Y2txV2dSRUlXdmcyY1dtc1d5QTNBMDlFaEVPNjBqTnoyR0VQ?=
 =?utf-8?B?WEdwemtDTSsxVkV6ZEl1MW1sQ2RlY0ZXMjdZQmhuZEsvUmFPdFN4enVSVFo3?=
 =?utf-8?B?RDdHaFE5dFpLK0x0QTQzdzBzdFQ0d3VxU2MvcW91WWtEemJ0ZWVUTlJqM3RF?=
 =?utf-8?B?Szg5YVMxb25jMzd4Qk5TQXl2cGJBeHh6Q1ZlOG0vLzhGZHFJVVF3UEF4eHFr?=
 =?utf-8?B?WE1HRmRoYm5vZmkxSG9Sa1NYbXVaY1J1eUdkZjFjZnJnVnNBREJrTVZMSEUv?=
 =?utf-8?B?RjVSOHVNZFg1UkE3dFlTWjk5OXhQWDZRWFo5MTlPVWR4a2s1N3RUcDN1TG1H?=
 =?utf-8?B?VUZqZzJHcjVCd2ZncU1SYkYwUm1qZDlXb3N3MDltWFE3TXlVdW1yWGEwZ2RV?=
 =?utf-8?B?MVJhQlJvQnYzMHhTbXBaNVdVNmJGcmlnS0l2c3puaENUQk9hNjUwVjZ3dk55?=
 =?utf-8?B?YWZFWGZOdHFPNGx4Q0pHYWM0ODRVRGlTNTFYYmlvc3VxWGlPblY5WWtmY2tO?=
 =?utf-8?B?VFBsME5aemxNaDdTbFVtRUlLSmFDY2Z1Q2lFQlgxZ3pYNU5QYTRWcVMzbFhT?=
 =?utf-8?B?bnhXdkVZS0NZSXJtZVpMTjl5MENRWTdzb3VNYTZnTkZKSkVsQlM2eTE1Vm1G?=
 =?utf-8?B?d2xFQm0xcnRwWnRLZnJaVW9TOU1qcXVselBmbUtNeUhDUVlnOVAxd2d0Z2E1?=
 =?utf-8?B?anZ3S2dYbHloOFpYSHNnODBmUWZVNWpzRDZDOUwyZ28rQTVITmpPdk9ObzJV?=
 =?utf-8?B?VkU3MVRiQlZiTkdIMTJrRmRINXNRZE9uNXA0V3NWUzRvN1ArT1NrNXlrU2Zp?=
 =?utf-8?B?eUlJLzA4TFNWWnh0UXRNNHpROUw5c1Y5RTNZckp2N1hFeDB0Q29YYUV4YmFP?=
 =?utf-8?B?MkZUd05MUWxKMzc4YVM2MWVndjRoYUwxbHhrM1ZwVmZ4VFdNSlc3cHVrUEpZ?=
 =?utf-8?B?VEhkbXFZVkp3cHlHWFFhNWlsc3Y0UzZlNXRjVld2Q3lBdThPNmxYUU11QXpM?=
 =?utf-8?B?K3F3c2JBdkNvdGZQSUFWWExVMHdCMytUM1VhOHEwVDVoU3FBWGFyemtBZ2FU?=
 =?utf-8?B?Q0VITkpIeWd3ci9tbVRsUmw2RkVrNFM3ZFVJaTFaZHNvVXdQOXl6azJSNmtn?=
 =?utf-8?B?NnVvUk1zZWtUWGdSaC9saUwwTGR2N1RmTlV1dTZHTnp5c1REeEdCL2F0ODN6?=
 =?utf-8?B?Sm9LdDZvZ2dkbkpONzZLQkxnWGNDNVdCVUpTWEE3cW1yZDhtQ3NORUh3M1Ry?=
 =?utf-8?B?T1pGL0lLK3dNeVViNFF0M3VzWVo2Z3liU2VTYmtzRXBZYkV0OVpjZCtIWHAr?=
 =?utf-8?B?b09BQWFkcmQ2MFFQZ0ZCZ1NmblVvVWVyY0w3SGRsd0tKUERTWXduMFRCK2Ra?=
 =?utf-8?B?Zm03RlMzRkVmRHhMQnl6bWdOUnJTNndFbmpOSGtoTW1ET2xZWWNORk4veDdi?=
 =?utf-8?B?ekJVYlZ1ZVZ4aDNuZjNpWURpL2xSNW1UZVRCeGdQS1FPRDU3S1JzeXdub1RV?=
 =?utf-8?B?RXRTM3NsTDlPWDVQOFdndzkwTU1kMkFmTnV6YmVDUUxtbFdnY1J1TjkzZ0Y2?=
 =?utf-8?B?bllvaUoyc2hROGhXRXJDd0t6VjIyb1hmN09vOWNiYU9DSW85TGJudHV5K1N3?=
 =?utf-8?B?U2JuZnRFMEozcWxKRVhmTlBzbHo3QUp2VU9XUHB4dmNzNW85QTJGdW1hZ1Yr?=
 =?utf-8?B?cUVnb29qVmdUM3JieXV6Uzh6TXFmUUgwbmVDeDNkOEh6Y2dtMEFhaThTY2pm?=
 =?utf-8?Q?soZET8lizJ3RD4n1Hj1uoU4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	90HxVfBsiKOoPbnp7AAhdp7z/qa1i0OvMeH1dhcNO2G+Sh7fjon+r5oy4KvnMAqewtnJZCr66qN29lywxyatalsO8r8bjUF+/XusvlNVQZye4EDshqXBHC1QfKTWk1h62aPa8U2bk1M1jlGvdbVwGgWJTfniQCnbmE7kVmUPwpDuLzsDDINLS7GzeOelBr/x1sCy0+O1lief7Xqy86vN8NHnq2vDsaHQGUF5KydwYYM4YNW9aoitYO43xrsQE64oN9tKTWHXPpyXDJnTXdmzwFZUy4fLgbnz0qqLe58TlunFqwQDByCDoDaOX5ddta5jGnVJ1ZylDqBboaCscRD8fn1sLCCgg92zk02pjjGtTlYMAXqmMRdPdAxkWgKRrB1Xxu4NAq4Z3i4St2bh0YYXPGiroHKKnj9im0qZKf3kA68wVbvRy6/A8uDpo36zusp+xn9hmU4Z/bEHzsUcPkTW9nzxb4S1WJhHBsGzT6waU5ICVoJrNYKmom78u3Mwz9Qr49pZX67L6gLvepwb45m1sHZkR51z/ZzU9V7qb7F1IfIkBa1uU4ieb7J6XjMbv0uJbkaDpK6VlJ0QtxGWELlJUwSazpct1JVZ+7y1hOqQVJM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9a27d5-341d-4ef6-7b0e-08dd2fee8096
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 14:12:36.6618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZk1gJwYbJEJ+2tuXsBxjwXDzt33slctyzT7PvKAwkvfluhSlfW4omPhzbXfjV+g++3xWGO8BZWcOwwJHJN4nA6gulV4dkxeujUwwRzzvUOZXBmN0483anDWALjrqkm1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-08_03,2025-01-08_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501080117
X-Proofpoint-GUID: qKYPQEZgftMRgkvaXL6pVE2so6XqN0_h
X-Proofpoint-ORIG-GUID: qKYPQEZgftMRgkvaXL6pVE2so6XqN0_h

Hi Greg,
On 06/01/25 20:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
