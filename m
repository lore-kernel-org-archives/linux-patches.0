Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC0A24A049
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 09:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526877; cv=fail; b=hjSbd6C3k3NUfUWh4GyGsZzGufBTDAEaiowNwHlVBrZ6o8XI3Wj67t7q4cfT3kZiso8xIGNdVVnUEeJk0VK46+8itcbxN8e0q7s1nDxY+YJECfzpIzt2BCjVg2gRhiq2E3+ZXmdOQHOnrXzaqo7vRWggGAmxfBFXoBEEdU8hz20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526877; c=relaxed/simple;
	bh=+8oEnSPVyNwfLLCkvk0MtHuYtaEU7TjhEXLmQPnNTV0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oRDkVZmWCma9SHmexKvy2HZijRV3biubCm5qrg9zqn7A2gdhvkuUQJInsLxd8vE+wHWXvKLFXT6Q9xbGLw0NLPwGLrcn5zKwTjsVH08e3aRYfmHq+dssZ0FQpqGMtQzEOwOEbCRYRMSaBv6MlIT6iuaqFku96Iu266fSVQntveQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l8TK0IlB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g2OLmdWR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l8TK0IlB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g2OLmdWR"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51E7gUfV001483;
	Fri, 14 Feb 2025 09:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=wTe5XVa1/nEHhZv8OXaV8wpimWVAm+jJME+7V4Tugn8=; b=
	l8TK0IlBRmLtHXGeXRTXEaCzeK9LiOZ9fhcbM0509f+0XKsVh2Qrfaew2+wrAtsp
	nk5HRHCZ/Bgc/Z3jK1u3wBUhYNt5m5hp7xSX/cyDEsubMLWw56PpDPJYV59cXENl
	1/6lpjb+7LY3sDvI6QYWvw71B2qXCkhqo+vXCL/wz2ZghNny2U5keb1gY793aIwN
	Gkc/Ynw5Zv8TKYisiHhgcfC5uqVm3v8Hmib5faaHncd+edns49fLgo4BZoQL1khr
	jjFKeTg38k7zoLU0388osEjscfangNsj3BkxFC1iZHw3Rb8Tm0KQ6iZKIphn8IL/
	2Voy+Ak4ur28tcSKIg9tnw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0q2kdjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 09:54:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51E9dLL7001193;
	Fri, 14 Feb 2025 09:54:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44p633d0fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 09:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjvd2cU8OCuUd2VYaLFgb1/n6IST4CQbIwqzdS3f2iKyHT6+wKE11ATHUJ+NxhpvbHDa/aOY51BXrQY0eb4KicyA6m3wRiUo5mgv1AEMvqXBI9AHBa1WTuRpu1mbhcGTu/3681zuQxcXPqkEXYexpO99+5WeqaWfaVeqbhTVJjH1BmPmEOTalivyF2uwIB+LMGn3zfkJ4iqyWXOleTj4VzdnBVh9GbZFjhlD5SdX3kJMZLYJYOg8rsCyQoWt0trJHNiIdHDofsXryuhw8ry+/m3xpp3YZMb+AHV/6fDwuxgvk9+OYIpseGPtnkpKX9u/qeP9c7KCkItL2yNG+4uA+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTe5XVa1/nEHhZv8OXaV8wpimWVAm+jJME+7V4Tugn8=;
 b=kvFqanGHNyHOborZKkQfkdFeK9CqozUJbRUEcj/+Ej6SyIZ3UGC5zmL3ggIglOYFzTaWUvE91nJKhP71Ng0tGihI+vH7ubCWSEiL2rDA2XtiYDqsogS7xsmwP9FRckWvQgCOcIuHJ72g85RZzqq0CtTpVtOX/6B9S03dcmA8/WPWa3LHers9xx1e/0tjQQI2jaLZUXPN6BOLrQ69o5UTAZwTjd/MAhy8K6w0jmpf5RhuqIyAMnZrLlZJbAe0H605YwHhQFbiOfzwinx3QXK5pJPuDpNr02IWr65JHovxymGM95oK0+qGtVq1Fa3HoKXJyYLDJc74NqGban6dBCaiOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTe5XVa1/nEHhZv8OXaV8wpimWVAm+jJME+7V4Tugn8=;
 b=g2OLmdWRYOiwiXSwx1TqaENwo6yMEv7/2QcFU+rdXtR4SnctafTPM+IXEp0rU233QDCPQs/Ny1lW8jaNkHH+VDJlS8wj68+MP9mIIp2YWW3gKwuH8VngN4q7YXez0tVepmRf8Rn3N7hP1CJaSQZKuza1BNUXEza5LDSpvYONtu4=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by DS7PR10MB4960.namprd10.prod.outlook.com (2603:10b6:5:38c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.17; Fri, 14 Feb
 2025 09:54:18 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8445.015; Fri, 14 Feb 2025
 09:54:18 +0000
Message-ID: <f25f0369-bbcc-47e5-8668-ddc8177ea02c@oracle.com>
Date: Fri, 14 Feb 2025 15:24:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        hargar@microsoft.com, broonie@kernel.org,
        Darrick Wong <darrick.wong@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250213142436.408121546@linuxfoundation.org>
 <c6c19838-dfa0-4e94-b7bd-1dd49449573b@oracle.com>
 <2025021418-provoke-trilogy-2d6e@gregkh>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2025021418-provoke-trilogy-2d6e@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0088.apcprd03.prod.outlook.com
 (2603:1096:4:7c::16) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|DS7PR10MB4960:EE_
X-MS-Office365-Filtering-Correlation-Id: 03bb7204-f0bf-4e2d-b9a6-08dd4cdd8c4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yms4SDlEY3pVaThDN0JlT2xrYnBtb2c1WjIvRkVUOVYrTkQ3ZUdKeEdpcmMr?=
 =?utf-8?B?MElxVXYvWUM1TlZySnFnaFlhMTNOMUVIWUVMbHBncG5SZTBydjl2OTQwOUp0?=
 =?utf-8?B?b2FrWFFpbDBDTDFoZDJiajltWGZNZXcwMXdua3lqZm82R3dDZTFmRXRNeC9s?=
 =?utf-8?B?dDk2TDhZU2F5WGF2cElhZytxT0FMNHFiWmpXVFhCRHdYMGxNMDZzbTZXdU5w?=
 =?utf-8?B?VHo3NFdHQ3k0djRrVHZyU2NpN3dhcmgrTVZBMitmVEhPYmVDeW9teGFVc0NQ?=
 =?utf-8?B?MFNzWE5HQ2wwaW1rMTB2NWxIdnVMcm5pdE1PTlhoczc0cHl2L3RITlYzUlVD?=
 =?utf-8?B?aGpkd2VXeGo0M005UlJDeUM1UjFFSVhrc2hsSkFxVUYyWnYyUEdZUDgzMU5M?=
 =?utf-8?B?YWR4UFhyYUdtMmttSDg1c25LaG92cC9mam9jdEFiU04waEFMTEQwKzJiNmx3?=
 =?utf-8?B?QjJ0SDJQN3NTZGs3dFdHUDlYV3FpZFpjUmN1ZlF1ZnRaMTNNM3RPYWVJdUpl?=
 =?utf-8?B?QlR0WGpCNGlDa29ick91cHc0WE4wdDZ1NlVGOTZKZWcwN3B5Z0NpcDFRTzha?=
 =?utf-8?B?Tk9NOFI5TVBTcXExYkFWOStHYllCZDM3aE5YcHpCWFVPL2YxTE5KcXhNeWo2?=
 =?utf-8?B?RjYrTmRHT2lRTG9uVGwyVU5WU3NZYWp3ckJMeDl4aHRqaThET2hlekg4Q0Jk?=
 =?utf-8?B?bW9nTUZaTkdTNTlzVElFTUxDUEIzZ2VxSGQydXlxL0RwRkFJSVJIaTFuNUFY?=
 =?utf-8?B?Yk5ILyt3SS8vK1RicXZBbWJlaWxkbWNNSW53Mkgwb3UyUkN4clBaTjBid3pM?=
 =?utf-8?B?cWJXQTVHa28xRm9hK3NVUThXQkgwalVvNU9LalFwUUVOdVpBaHZsNm53bnFl?=
 =?utf-8?B?NGgxT0tOQjhnaHRyb1NqVGdwSXVpK0RNT2tua0M5bmFDQkNkUTJXQ2NCelRF?=
 =?utf-8?B?TEN2enR5WTdyZmFHZjVQUmhTQzFDS2o5SlhXSU82REN0QU5pZkNxYVNTRXdj?=
 =?utf-8?B?MjBPODQzaWd0bVVBb0RacFlqU1dOdlhta0xlM1RaUk1ReVZ3UXRTTHVLdWpm?=
 =?utf-8?B?VkZBUW1uNFNOM00weTVLSUZoaFBJU0E1MlhES1ZZWEJhMXVFZHFIMFVvVGV6?=
 =?utf-8?B?MFBYcGRCRDEwR3JEazJnR3k2U0UyNnEwQS9CY1JKNmxnLzh0OWhhMWJaQklh?=
 =?utf-8?B?QUhlOGdDbWdjY1NEKzZNa3pGY2hZRnR0S2g2SXZMWkFvT25ZR1I1UVUxZndx?=
 =?utf-8?B?ZnVmYXArSFhSNGVBOStNSGdSNmxrUTVwcWNmekNoZy9HWWNBbk5QSEkvaWpn?=
 =?utf-8?B?TnVjYytmK0IyU1UraTBBTXBGSnRNczViamEvUzVickpCV2srU0t6TjBxbzNQ?=
 =?utf-8?B?dEd0a09ORTNGdUdyUTRrWk4xWHIraUJuZ0pvZThBTk5CNFdWcktYRnRmbXBS?=
 =?utf-8?B?dFpoZnpjNitGVHJwNldXMnNRZndjQitHdTBTTkVic2x1VWgxMDMrSE5ObU1u?=
 =?utf-8?B?VS9DR2trRUZOaVU3NzZCMHF6LzZzWE8rQWVnWnNoSGF6UFhIZ2RadmNXRnhx?=
 =?utf-8?B?Z2R6Q3dSN2x5RHdDNktDRG9HNFFIakxlVVJtMHIyZ0tDaFV3K0dsZ3U1dUF2?=
 =?utf-8?B?cDdSNXlVT3REZGQ5b0NuZ2hCazZXZ0tVT0VvMGI1dE94T0dwQk14SitBTVFV?=
 =?utf-8?B?TWFBRlpIRXZBTzNkbjRQaHAxWkU0dHZVOWtwNTRiSS9WTWg2ZEVORmhPdG8y?=
 =?utf-8?B?citYL2NnSVJtLy9LTDV4NzJkK1hxT3RhOENTWlVQd1FCcmN4bFM1OWtzbWtr?=
 =?utf-8?B?cXJma0lIdXEzeDA5UVN0ck5yS3Ezekh2bmpoNEZJVXduRDlVRlBKbFRCYzh6?=
 =?utf-8?Q?Y9fSX3+egChXV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGc3YlNJbjF2T240RUZQVkhrbXNMNHZsakpuaVQ2V3BsVU0wdFJGZXROelA4?=
 =?utf-8?B?aHlEeWlqeW5kWVM5S0RwNFVsSWszZk9jUURrQzlLMDNjRy9RT3BoZVZvV1Jq?=
 =?utf-8?B?MDBpc2w1clRuZDZhcE5nQ0VwbWJPQzVZaE8zMFZxMDhoRlIveDdTRnZSekIv?=
 =?utf-8?B?UDRYQU5oRW1rZ0p6d1ZhM1czOFZLcWpnVFFJNkZOWlAvM2FqVExidmRld0gr?=
 =?utf-8?B?eWM5NEJyV3p2WGJJWmV6bldJTnZjWU5OOEkwbjZ0NTYyNFdyUEdYWmU3dmJN?=
 =?utf-8?B?dDNaSVR6RHNoajdzNmlpTUQ2K1JUSnBGa2RVT1BKVDFaZzdsYk1yVElUTFdL?=
 =?utf-8?B?ZGpCTk8zVzlwbUNldzVZNjVBSlhnYlByR3ZwU3R2ZzZuMnVuNHZ5ZkZ0bWtW?=
 =?utf-8?B?ZjFMUFdTYnB4eXF3Z0M4bENLWFNvcklCWGR4eWc2VGJRMjBtc29QRWdKZUFu?=
 =?utf-8?B?cVM4ei9ZcE9SeGdnVCtiNFdXQmhaTEE5UEFYZmdpWWREY1Q1ZjRTK3ZhZVhP?=
 =?utf-8?B?eXJHSTVpcUkxMW5TaXRIQlRiVTUvMUxCYXc0cW9pOFVwVkpVYk5Tbmo1N0hK?=
 =?utf-8?B?Z0xPWnJwaUNlaTRwUXJ1cU5oV25DQ3ZHak8zSVFNMTJTcTBDRDdhUzBMN3U3?=
 =?utf-8?B?ZTA1d0xkdEQzeDFnNlR2Q0N4bjRJZ2lFSnhYMGY0OG91aE4yelAzYmQ1ekdz?=
 =?utf-8?B?blQ5VXRzRmFrZko2WnYzblEwZnAxc1VxNDU3UHY0dzIyTS84bnlicUNhdFhW?=
 =?utf-8?B?bWdjVzVNQVRJTngzMFZraSt3Sk51OHZGZUhtbkx2NlZDUkZkclV5am1jNW51?=
 =?utf-8?B?M29XQmpWUEhIYUJtbkw2U3BORkhpb05FbHdLaFpJNlkwSER6VkhhdjZJbE1I?=
 =?utf-8?B?T2d0NHIrcitKaWZRbzRJS2QzMmxRekVqYWlVeXRXVmxRckxPK3E1YTFnbExs?=
 =?utf-8?B?bWk3cWt4L0w4cTNIcXd6THUwY2srdkVSWmlTRkwwSjAwSHRuTnpkenZ0Rnk1?=
 =?utf-8?B?c2NvNnNBdGpHWDRGYVNXaW5nRklGQnYrNTE2R0c1U2liWXVPOGNpYTd6ckl2?=
 =?utf-8?B?VWtOL1pHZEZkbEtLTFdiKzFKUE8zaytZL2NsbWlrTWZ0RFV1Zmsyd2F1Vkkw?=
 =?utf-8?B?UG9pUzd4YjlEbDVJSTNhakxXR3c1cDdtcGtEbEtZOVU0UFBKZlFTaUlVNm5s?=
 =?utf-8?B?WnZYaVRmMFRhTURoRlVscUhsK1l4RXBYcXdvUENDQXlLcUNLMzczT1pYSlVF?=
 =?utf-8?B?ZVhXZ2QrRGkxRlA2MkZpUS9iQUR3d20ycU0wcGszMHRSSEREUjdmWWtRUGlm?=
 =?utf-8?B?U0ZMRGF4RDFVSDZmcDh4MjR5NkovVHdQZ2ZQakErREU1amF4Q1NGRUtKaEw5?=
 =?utf-8?B?NkdnR25vbFlsSlRIVlJPTW1YTHBMTmpHNHFhM2xpOTYxRlBUN0xleHc4R2RK?=
 =?utf-8?B?SDRjZU5LeDFUY1I2Ri8xdjBCcVUxa29PWHc3bGs5WWFSTHRFeDVJdDJZWEt3?=
 =?utf-8?B?UEw1WERhTFpEaGxoL09vd3cvWXJxMzNCOElUaGdkZkh5MkpnQ3dRQWRUeUdW?=
 =?utf-8?B?YWdMYVFHRk05OEFyWmtsQ3daWUpVUjZRVlNWNnprTDZIR0YvYWs5dVM1cGw5?=
 =?utf-8?B?aEhkczB4bjJVVTB0em1sakhWWDhyc0FZbmVOTlZGcU5kdm1adEZMbkZaS0E5?=
 =?utf-8?B?VzhWN1FqQ3I2ZzVJUHQ1RCtRUW92ZkczdUZWWmpLK251Y3diUitDb2lMeW5H?=
 =?utf-8?B?TFFuVG5kejFLUm4wdm5lZ1JJTWNyVzdIbFpmTHFvaFA3M1R4TTAvWm4ra2M1?=
 =?utf-8?B?UThRbkExRjJ1WlRKZ0JlVVJQeGNnY21iK1BTcThjWlFTV1lsbElITXBPWGRR?=
 =?utf-8?B?YUt5a2pCOC81U0U4MDJoTVRNbTNKWHovTFpSWWZ3c0FOZThjS0V5UjNPV3Mv?=
 =?utf-8?B?aURId2xrZlhMaGdCSXZZNjduaWRmcFNxSlowMjJwQm5qR2ZNVjRJMG80SU9m?=
 =?utf-8?B?ekZUZDNJazFLdWNUVDF2b0k2dTlwNE44eGF2L3VXb2w5Z2FPRmgxQVdGUFc5?=
 =?utf-8?B?MnU1Z2JIQmUxVmF1Q2NmZUJUVUIvdGx6ekkzUDIzWkFGUFlLUHNnK3hsdTJ4?=
 =?utf-8?B?dTVJQVhRblJXMTBLdUwvWEQwZUplYjZpNG01NTBuSWRncjNmaFZWNmgvbjlt?=
 =?utf-8?Q?WPkzmc5wzQo1PUCHEtU84a4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7Rzy8On3B9Bbzh6Gvxv37CDDEjzDgkmygakaqwPxcmloV+UbkJPehMEOYpNxWBzlZ+3BUXEyp2/1zgA/tCRHy2QnR1zVdD8HOw4lxBqItXpQKSMovT84J5BQCAAVHJPv/9VhJDeufOTKAubzQY45qmquKJZA/3/yHrypBoo1KjK1EZxYyNr18/wn6fHZ0R0poX5Yc0cq4prwdJAwLdTzQQ4fGnd9TrPa5pIaB1W4awpLNS0QyrPF7BnzkgU3klgJXC4p/PFATYHTRNnvj7Ewxtem1mpfVotwpo00LW0zbgd0gVN3mgslzuOvX0eKEF+OHruaG+ESJo8CE8nXwBBKlJPzf6SOawQD//WvQD3W+WARQ81MOYGFBuSA0lRtIcnTzhudCPv+HYuxkpS1ZVSaIkAwdXYEM2bY9bzhvBko+fy++6M+pH9wAyTJ8u2/znGy/Xzf0bxzwVOuYYi1G2wt5SkFkyZ91+4S/xbik3cBh7NLnA3PU3AYmR0v5DRShEQ8gUsERLcabc+1DUHnavzFdzF/HX7n41c9r2K1PaC7N3O8oISHJS/5DWhBsyVo1tMZHkNOkMrUDmkIfeEhrUKVI+pG5gkuvugPDQ6Y1yauD7w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03bb7204-f0bf-4e2d-b9a6-08dd4cdd8c4c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 09:54:18.5070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2K5nnC403TxY90Cu2pAu8UnIE7ZDIaf0ZpKVZ2zYeT1zZ021HRvhflC2tPCkxhTlanpJprCNEUWZMg4c1sG1NFgNGVoGc4yaFaNwg2eF2+L2Y3BjBjA6wK9D9y9BxaPD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_04,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=893 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502140071
X-Proofpoint-GUID: Pq4nDxLxCuppNBYkfFGYGvfRS9aJsMAZ
X-Proofpoint-ORIG-GUID: Pq4nDxLxCuppNBYkfFGYGvfRS9aJsMAZ

Hi Greg,

On 14/02/25 13:50, Greg Kroah-Hartman wrote:
> On Fri, Feb 14, 2025 at 01:23:23PM +0530, Harshit Mogalapalli wrote:
>> Hi,
>>
>>
>> On 13/02/25 19:52, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.12.14 release.
>>> There are 422 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> I see these build failures:
>>
>> fs/xfs/xfs_trans.c: In function '__xfs_trans_commit':
>> fs/xfs/xfs_trans.c:843:40: error: macro "xfs_trans_apply_dquot_deltas"
>> requires 2 arguments, but only 1 given
>>    843 |         xfs_trans_apply_dquot_deltas(tp);
>>        |                                        ^
>> In file included from fs/xfs/xfs_trans.c:15:
>> fs/xfs/xfs_quota.h:169:9: note: macro "xfs_trans_apply_dquot_deltas" defined
>> here
>>    169 | #define xfs_trans_apply_dquot_deltas(tp, a)
>>        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> fs/xfs/xfs_trans.c:843:9: error: 'xfs_trans_apply_dquot_deltas' undeclared
>> (first use in this function); did you mean 'xfs_trans_apply_sb_deltas'?
>>    843 |         xfs_trans_apply_dquot_deltas(tp);
>>        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>        |         xfs_trans_apply_sb_deltas
>> fs/xfs/xfs_trans.c:843:9: note: each undeclared identifier is reported only
>> once for each function it appears in
>> make[4]: *** [scripts/Makefile.build:229: fs/xfs/xfs_trans.o] Error 1
>> make[4]: *** Waiting for unfinished jobs....
>> make[3]: *** [scripts/Makefile.build:478: fs/xfs] Error 2
>> make[3]: *** Waiting for unfinished jobs....
>> make[2]: *** [scripts/Makefile.build:478: fs] Error 2
>> make[2]: *** Waiting for unfinished jobs....
>> make[1]: *** [/builddir/build/BUILD/kernel-6.12.14/linux-6.12.14-master.20250214.el9.rc1/Makefile:1937:
>> .] Error 2
>> make: *** [Makefile:224: __sub-make] Error 2
>>
>>
>> This commit: 91717e464c593 ("xfs: don't lose solo dquot update
>> transactions") in the 6.12.14-rc1 is causing this.
> 
> Odd, I am guessing that you do not have CONFIG_XFS_QUOTA enabled?
> 

I do have that enabled.

CONFIG_XFS_QUOTA=y

Thanks,
Harshit
> thanks,
> 
> greg k-h

