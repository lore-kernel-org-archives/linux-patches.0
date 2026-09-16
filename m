Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC0534AB03;
	Wed, 16 Sep 2026 06:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789540735; cv=fail; b=j5+ssLPzPTImRetnZBC7No8dqgsRwtdtGyiTWk7M90KfXnghUZIG0tBRekcRvaUVN+nYtxQkYdWbNg277xIdYDlA7oScXEl5ahT3QK1sK9j2HJfK2ZImLju/NVGyD7BTapZbL+brdya9OIbhpW7JpW9nyLgy2hXEjwVGCwk31JA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789540735; c=relaxed/simple;
	bh=/HLIYhzugVEHnnsDJMy9yHGo1Ww06UQz0ZkXkCXl40U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JwQsGA5bQirUNDMalmEVZH7Lc/DK3EqfKQmAYzm6Xtpn/fA0800lskWRapZ1ImOjp6ZbVpe5aW13H8tz2Bvdy8wJYfC9Rz+nImX5BqgsOWs+yro0VsBAN44RpiRY6mz5HjKwaYGdtKewtanzRxJsA3TEsdettuuFwl1ClqkYuwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IUvBh74L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pE20ujKH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IUvBh74L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pE20ujKH"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWTv7641180;
	Wed, 16 Sep 2026 06:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=A/l8MRZvAxTABUd/KLIzOwuL15tnaKyXUPBfqFPwBgE=; b=
	IUvBh74LjryZyvL3FTV1/X5dl5Dkn0/tljqghWkZ4zeP6PKzxrxC4ZpNwaRSzgVh
	33FXynMfMa4dW0pnU90+ygtfWwakZvl34XMZz+1tMaYsgIRPhOV48oL6NOTNgkbd
	v1vqI7JaC1Y/Hd4HUssd0gNAj0gMWuh3/2KnMVctxQpJGxJFP9sToxxmj9QF3EhI
	946pZyvbS81nMMyFREPgToud8rhXQRoq7gPxtsRvI6Re5pdvA3cVk2a8jI2xn68W
	gFKzccPwz/RbaPXEXgVV1xGxrCLoo4jVj8JUi+3hWstCU9Qtjq2ptugmk9WhR2O9
	vTLcBagVJVodLF4bO29yfw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxbs5223-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 06:38:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G6ZZQV014202;
	Wed, 16 Sep 2026 06:38:44 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012007.outbound.protection.outlook.com [40.107.200.7])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q03j9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 06:38:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JmkAN992r5nPwdic1qE/1PdS6f6dmhp5Aa3afHlj6uc7dNIHFlJpyc+6FClEeP/+tN5sYTNKD0cNmWRgX37fz7jRijBS5eFH3QWlyaYIDwafwqXTmiKk6UNVMvupfiL6q1KDMPU5I8eMBq10H1jKKsfFBqw3kd9Q/KL7/bsTayzc27CZxFNSyOtv+/8sj7SVt14OZivm5qcSv3f1c+17qdG0iV6T569oOhCU1GtYmvRNnO92y1yqq2FRiz85XDfJXrYu6HuNkGro+GvGtmqBot/E9fkU2BwslE7VysyG3bkVvZlk80QACEVyXhxU/4MeUGBTNnwZWAWcv0WG0hk2eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A/l8MRZvAxTABUd/KLIzOwuL15tnaKyXUPBfqFPwBgE=;
 b=IKsjNWM52NdFndebPbCtY1wZZqk1lATPboZLhtqo/PRRjGY32fDvgXXlYPCDStRQkjujYVG4oB5w3MNaF3I0sTVgUsq2D6KxKFQOsIDRctZYUu95PF16hOPg/rNDclWXUQTX2TT0j5708ry/3G4zIIsroM+/BCpnGPURut+k5rQntg8gx0ZqvvwnJ1kZs00bi3XImYxzvMrCipg2iNjbpRduTXdgb7Ymaklqv+zyxjG5KWtsaP+Cx34qx9fTrtcjG2sG0LgsIDgUwfp83jMtCwu78klnhouB38vZXDgcYUT78SeyzjZRXv/nyFOeYcTK3eKtMlpGArawCjBF1QtmnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/l8MRZvAxTABUd/KLIzOwuL15tnaKyXUPBfqFPwBgE=;
 b=pE20ujKHeCi/OArv7HzOIL/6VIrfZIBVtFKpE4tifDMkjj+IDb5C5wCN+1A9PXlv42J1NjxyVWotWctNYooQuh+2Llw0q6suYDYSQGNCzTUsDUzOOooD3m9LSc0/mFImDLr6Y6crKzCrcBLDq/k6SN/M+9Bs7QM4o9h9C15mEwI=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by MN2PR10MB4141.namprd10.prod.outlook.com (2603:10b6:208:1df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 06:38:42 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 06:38:39 +0000
Message-ID: <1ed99aaa-4f19-4339-8043-31999e0381e3@oracle.com>
Date: Wed, 16 Sep 2026 12:08:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0078/1376] perf hisi-ptt: Fix PTT trace TLP header
 parsing
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, James Clark <james.clark@linaro.org>,
        Sizhe Liu <liusizhe5@huawei.com>, Namhyung Kim <namhyung@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065609.298072894@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065609.298072894@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0010.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::18) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|MN2PR10MB4141:EE_
X-MS-Office365-Filtering-Correlation-Id: 821280d0-0abe-496b-99ea-08df13bd243e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|22082099003|4143699003|10067099003|56012099006|5023799004|6133799003;
X-Microsoft-Antispam-Message-Info:
	HmQ5G5E1R/H5bCtzRYkKRagpNUzqYzb1WXd71pYQWzlO0pMEPB9W8kkjfqGC0oELyLtx9VeU4AQdJ8Vs+pnrZF/O1ZJIFwGwphEbUQar+wgehsT2uENWhjOPOpdZZLGj+KKyijh/g7Z1WRQ3gtkRgzAl9WeCpKVd8AEzUy4U2UuS8v6ErEEiBKGg9u3jNcfcKCoY+RnDuCLk+BAnyimURvCPIO2CpTpYbbNWbEUfhhi4ileNndag1jTVjuO+x8dy3GgTq1SgogxA3b+Pwd4yfumYOPSFjZfv6tvV2bLna2m16AxU9EOsDS4+gQNEQQg+OX1tTw6JWgEld6OJgmrGu8jmb6wsYpDe0xfmd0AqnONMDWS3NTBGpf1rjwYMsDk4BBF0mgnenmLdxktJGHYODSLq2fmenkvS9BsYkWppkfpj1vBhD0OZ1ddOTUaq9I/kdOAm1cjGn14wRgOI3R9l7XMEqQcsj+/X0/13/PLQ5IWs+eP1L5mg9iOtseULltiwCCOBJgU+t1CLug0BrS5zwCG4JwI8MJFROTRY1xMNRzDXj5TqnbReaxT51xadyyVrxBp6pxTsmM/fDwmT1pHqplEq85v78JhPyx4yofI9pfDAzkrur6igF8067p/xbbYwCvqjUGdZ+ToJC2s8OOABxh3Ap8E64NVR+Gcz5gg6Y20=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(5023799004)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDNuTnc1em9FZm55YVlRU1dhZ0tRNHBQSjhkSkd0RFhWMU1mMWpHUzVWWjN4?=
 =?utf-8?B?VmgxbGhsK3A4aktubFIxS1Izdm5HNDNaMkNmd2YweUVtbHFET2M4RGtqcGVh?=
 =?utf-8?B?VTBlSjkreUM0NXNmY1BES0lNbFl5YXkwR0hkaHVHaFkvSTh4UnNFZHZlRit2?=
 =?utf-8?B?VUUyYnZ3SGNtekNCbmZPTUN1QTk0SS9nVnMydnNxNDJFREppZGUzM3VPVmRL?=
 =?utf-8?B?Ym50bzhFZDhjTGVrdzNCaWlpVnVodDc0bDNJUVNQNjdPck0yMWJ1MVFJOFFI?=
 =?utf-8?B?a3hDWGxva0tkNkVQQTNVYkxVNVZUS09OdkR6QmN1T3B1MzFGQ00yZ3pJVlR3?=
 =?utf-8?B?cUpkZFJhcU90WFJFaXhNbzlZeVRKOTZjbG1OQVl0ZmNMUVlFN1hMeWE4T1B5?=
 =?utf-8?B?RTlKdUViV3BtWEdzaVNHaW51UVB0YUhWcTZtalU0dVY5aHFVQ0lhQUkxVkFs?=
 =?utf-8?B?OHp3VVJFNUFhSW8yT1hEUG5WU0xwZkRFcTZPekpwaVhrODkvK2pXME5HYXN4?=
 =?utf-8?B?bWtNZHBYMEp0V3hMMVF2VHZFSkZHK1p6blNEL2piaHRMTkwwKzlMaFpCdVNa?=
 =?utf-8?B?cndKS1JqZzNENVExNDhFNllqS0VOekU5U0hjWHg1bWFIUlJMTVB3V29LVUxx?=
 =?utf-8?B?U3VNTldKQlBDNm9vR21lS2NBK09rUXZlSEZCNnlZbGJXTjl3TzNESGphS2pH?=
 =?utf-8?B?Yll0bXpUY3pHWHRiQzRKSzROVXVKOWs0R3p5T2RjZjZjWnc0TmpTdVZ3bHNz?=
 =?utf-8?B?cEZNb2l5NE55VVhXTkk5YVAyVHQxSWhWbS9YSC9PdklmZXZKblM5SXpVeVhI?=
 =?utf-8?B?cDVuMm83Y05oOWEzanhiczAzeEtCSUZHY1Bjc0RtVzNGMXprY3BxVGg3ckVk?=
 =?utf-8?B?dmlFNlY4dGdSY05yRjJBUTR1Y1ZtTHV3T2FDZzRVZVhOUmsxUlQ4TnhSWmRu?=
 =?utf-8?B?ZGR5M0owc3ZVRlV4ckZFZGpGK3dkUENTY0dqZHpjcjBXK3J6YjVVYmwvS2RR?=
 =?utf-8?B?V09NQUszNHFEdUVkMlVIOFVIMWZDMUUyM3ZibmhCSCs0TWhoMnk3UmR5dDFi?=
 =?utf-8?B?Mlkvd29Ea08velhRTVRORUJsOXZZc3AyMUV5NS9aT0VvRTcvc0RPWldVZWpC?=
 =?utf-8?B?ektMWXFZTitzRUI2ckZZTkdZbnB6cU5IdkI5N2xkOG1GYjdnQk55ZkdHMGcw?=
 =?utf-8?B?MXdSL1cwTkV2S1o0ZWtpMWxnby9rbW9xOTlmd0ZJQndUWG5pV3lqS0ZkbTk4?=
 =?utf-8?B?Mk1adWRPREJDOWxocjArSGpQd0dQT1I3VGZMaGc1YU1HVTBlQnZ1d1RMRnEx?=
 =?utf-8?B?TlZ5Rll0Sm01aTZ5ZmY2ODNtWERxckRvcjZHeUYwQmNWbEpCV2I2anMyQWpy?=
 =?utf-8?B?ZlhsMVp4NTRSVEowa1JFdTRSUzE5a0kvRUkvQkpueTFzaUZxZ25CbUUzeVF5?=
 =?utf-8?B?dG9ZS09kUDNENXRYcnVRY0V4MjRzUVJpTGhhRkRqSTVWTHBjcnl1MlVrUG05?=
 =?utf-8?B?YjgyUjJMWDg2Z0N1MnFKZng3NncrdHZ5cWZjRFpnMS9LUEh5LzNBc3FPaG5W?=
 =?utf-8?B?RldlTjFLZDFsWEJPL3diRCt6Mm1zOWV6d3hHVmR6RXA5ZEZJYlBmSlV5ZHpU?=
 =?utf-8?B?U2NRRm1mdTJSQVlON1FMMDd6UWo4eHExa3FGMG1zdjF6L3AzZWI3bDdQR2xQ?=
 =?utf-8?B?Tm1ybkFETUpMdG9nUkNmS204R05pYzhwUFc1aXhMaEExTGdwUlpFTkh1K2dK?=
 =?utf-8?B?TFdmZjJ2ellVTDhJdUdqN0E3dkFweWJodDNHd0E1d083UnpnNC96RXhXbXl4?=
 =?utf-8?B?NHNFT2tPcmIyS0J2d0x1K3RScmt3Q0ZodnpiampPTi9rZmhsL0VaZVRwN3ZK?=
 =?utf-8?B?YkMwbHJQZHJnU1hGTDlqOCtrRHhhN1k1RytGaGEySzY5M1hoakN4ZXB0Zlh3?=
 =?utf-8?B?UW0zdzJERzFCTVYrVkhTRUgrdzVaa2F4NHdsaUs0TndnZ1F5N2RTSCtJWWli?=
 =?utf-8?B?dXVMaHBHSGl2dXVsYnpFbTJuYitwS2VIRHJBNE9CaDdYV0trZDNtODErd1Fs?=
 =?utf-8?B?dzhZUG05clBxbzUxZXVHOUNkVHFqcXVKTWxOb1BJMHZpK2Q5KzBuV0J6RVVU?=
 =?utf-8?B?Z2xVQUtNVWtuZWZqUC84UnJUYWlwaW9Ecm9QU3pWTFVmSFhod3dlOXppZkFZ?=
 =?utf-8?B?b2ZoYlBnUTNOV0RQYzdlK3d1MkhKbjZpR1FuYkRoWkFITk1XRUlPSmYwNUdF?=
 =?utf-8?B?NXhpNnI1ejZNM2NwRUNRbHhQL2lPKy80UHlqa0xYdlVkeldDNHNQL1daRDRh?=
 =?utf-8?B?K2M2aUtyY3BhdE5DUVRYeFIycFg4SC90c0FLZjlOWkVvM1Rhb2RyTG9vNzF3?=
 =?utf-8?Q?i7bxRlBvm8XcARTfhluyVzGYbtxq55WzKrrcF?=
X-Exchange-RoutingPolicyChecked:
	niipUZHEUmNj+djn1qt6TBq7TRpAcIVPc54V/ftSyRxsAbAzY/wh/afZNfcuMCxD0JjYjeKgneFSkFOvUrYnx+6/ITxpU3xan+wroRBlG9t+p8addqStWjuMm0oX5m+v/rH+EMijHOaTHd26j/InQNjngHsYJi/saUbGGZWMJhQ/lwneywih3Fi0qxgpcBzQiOjR7lhnsgTjH7tVFPJkPA3nEKC4Z4ch4GYFC1kW/SbxL0wTBC3TOK3jZ9AIwZvzLqARkr+bN0Y55ppq7GtPRsT6t2SCjRBYF8x8sbjTlSn8WWMLxM0aRrR9bMofCccHzlUlDP0A5w1hAPvLSP60dw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N/oPlgHqN9me3Lj2QQyz0oR+aJuAfc944RUGa8cReWjj0CKPYlfuYNqubD3MpL/UrZ5HCBuPXrDOo3ARrCeILzYDjauDRYa62aEhgRVAtfmlvOET4CrXJcp0n3j7R+pWK8K1OL63Xg3xmP8Rp95tVWcX2QNl/GIPwRdTJzPOiEmyvPqbZEY4rvPRGSedivLeQ6hOixlMpcImzEM5U2rMJyZ2C0bNfr5VdXsZJOaBD/B/rrlHWMqYo/JfxDexHwEiegpaZXyB5QbqOEcSN0hhi+yrVxawu+JfDWrL5U2JE8JGH6qu7CH7WJF9Vo8CxHVExbFs+i+kk8fwdClT0XSgZV3Ql3Ij5oTBHpuuy4gboyEw0YpgnjDVvh2ej+2gX8WRnqBT50fnCOTfb1BRnWss5gjvtvoXCctxjUv/KNfC5D1/e7G4f0YlWnK6dAabLInrOKYz6m0Adb6E+CKjk0rJ8igMPwntn2ycFvbDsrdvmDT4e6cCtldM39TmdkLiRRBSn9GQifaiXJ1RV5E7CqOJ7omjDYykyFZ4tCNpNZrDj+qz8Sc5z1uQrS6KAbsqTZVIVgAsI1dRUtLo/q5b+OB9ZpP1DxuLlXf0FExUrzKJriE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821280d0-0abe-496b-99ea-08df13bd243e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 06:38:39.1804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HpKvHOQw2X3RSxZk0pgG979m06Hg+Xi11LZ1X13mimycpumnInfCD6dQLsA3ARMjrAgrB5CXe6C6pwwb7WzgFQXnjbHP7KSfgURFIlhODMfPgaB9Ye4eUbEMSnLm4XTS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4141
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609160083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA4NCBTYWx0ZWRfX+jDiVyTFsPpA
 bx5O+cM4EDakB5MgttOQbwOoNqiAYS/eak0iP9PrwVNh3ih6E21mT4I2P+OSaRNadFfQoZyqlUc
 0WIknDvIhnIytdfh+wlCmPSTA2MTLfkVJSls8nDgyMpKVO7bypXHNHUDbN3Lv+bAY6CbCk1r585
 sACJgaVsCyrGz940GO5yll06SgebzzHMhHY+Q06UuXFuAymAo3poANshsd+j/GMXoCnBW1KBUFA
 2fCL3JWu9ER3F/WH6tqasLrgvyz1hr/jRpP2d80JGVbkfq1SHZEkl2QMtuXClfEWelgcT41YtEx
 yKV6y12nEK7+WkGTrjDbfW6bGAVf/Ep/ZowM5NkDnmgIgaHQNsbcCV+tfbwaoTz9gOtDw3YmACa
 TtNOg4v24JGDSTUuNa21S/eJwK/vFKHVtb+duJerxBLxxnmFYUyyW8fAFw2yFBPZzZubYMbA5ME
 asPX2i5/whMk8Mp12ZQgF5ul/2ueuP1OyS5lmgjE=
X-Proofpoint-ORIG-GUID: BwhI4M7cKyJTE1mj1YtaGo2fmxqgX_54
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA4NCBTYWx0ZWRfX04MxhGC/tCtr
 fSt57XADdyVRPeHZtXJXgVGG2L8SXKjuy7+OD9p0qYBIXuXifIP5hqRdsAzccvKZurXYEnir9jJ
 zZkevpeLCmXBCgcmocUuJ3z6drYLjxPoOaLXaJg6kibueBDKi1+X
X-Authority-Analysis: v=2.4 cv=DIYacCNb c=1 sm=1 tr=0 ts=6aaa3974 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=7voSmOrmBegaYXcgTSEA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12107
X-Proofpoint-GUID: BwhI4M7cKyJTE1mj1YtaGo2fmxqgX_54



On 12/09/26 12:11 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
>   
>   static int hisi_ptt_4dw_kpt_desc(const unsigned char *buf, int pos)
> --- a/tools/perf/util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.h
> +++ b/tools/perf/util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.h
> @@ -9,12 +9,24 @@
>   
>   #include <stddef.h>
>   #include <stdint.h>
> +#include <linux/bits.h>
> +#include <linux/bitfield.h>
>   
>   #define HISI_PTT_8DW_CHECK_MASK		GENMASK(31, 11)
>   #define HISI_PTT_IS_8DW_PKT		GENMASK(31, 11)
>   #define HISI_PTT_MAX_SPACE_LEN		10
>   #define HISI_PTT_FIELD_LENTH		4
>   
> +/* Header DW0 fields for 4DW format */
> +#define HISI_PTT_HEAD0_4DW_TIME		GENMASK_U32(10, 0)
> +#define HISI_PTT_HEAD0_4DW_LEN		GENMASK_U32(20, 11)
> +#define HISI_PTT_HEAD0_4DW_SO		BIT_U32(21)
> +#define HISI_PTT_HEAD0_4DW_TH		BIT_U32(22)
> +#define HISI_PTT_HEAD0_4DW_T8		BIT_U32(23)
> +#define HISI_PTT_HEAD0_4DW_T9		BIT_U32(24)
> +#define HISI_PTT_HEAD0_4DW_TYPE		GENMASK_U32(29, 25)
> +#define HISI_PTT_HEAD0_4DW_FORMAT	GENMASK_U32(31, 30)

Hi Greg/Sasha,

I ran an AI-assisted backport review and I think AI has a valid point.

The patch converts the HiSilicon PTT decoder to GENMASK_U32() and
BIT_U32(), but 6.12's tools/include/linux/bits.h does not define either
macro. Perf uses that tools header, not the kernel copy which already
has the definitions. A syntax-only build therefore fails at the new
FIELD_GET() masks.

Upstream prerequisite code:

     #define GENMASK_U32(h, l) GENMASK_TYPE(u32, h, l)
     #define BIT_U32(nr)       BIT_TYPE(u32, nr)

Downstream 6.12.y decoder code:

     #define HISI_PTT_HEAD0_4DW_TIME GENMASK_U32(10, 0)
     #define HISI_PTT_HEAD0_4DW_SO   BIT_U32(21)


Upstream has prerequisite fc92099902fbf21000554678a47654b029c15a4d,
"tools headers: Synchronize linux/bits.h with the kernel sources". I
suggest applying that prerequisite before retaining this backport.

Looks like we dropped it based on build failure report. So we are good I 
think.

Also, I wonder if we shouldn't backport any perf patches at all, as 
users can use the latest per.

Thoughts?

> +
>   enum hisi_ptt_pkt_type {
>   	HISI_PTT_4DW_PKT,
>   	HISI_PTT_8DW_PKT,
> 
> 
> 

