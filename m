Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335818C004
	for <patches@lists.linux.dev>; Tue, 20 Aug 2024 09:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724146530; cv=fail; b=A3fXTmOiK7dM1J+Dl9J/lSzRyWKFnGThsjV+pni0Pl99hOMQccHemWFApFvGTA8DffA2VZsgYnyPZqjV+EQgtVaNUkxR7PVprKVA4Hrlq+P0XzyH0/FSfU301S4l9F2h8EsTgBlrSqWLCMOgQ2Q8C7bR0RHQKlEgArfbaf/ORes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724146530; c=relaxed/simple;
	bh=dToevaX6g+d1KMo9nodfBVfaoPuV/XQQ7VfqBydmbRA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i+H8FzNnJvDE9XkX714Sn/s4rLKfvJHOKxXkabYi0ic0c4GJ1C6dVeC3bzTIpKBMyY1YwvHwH3LMVD2YEGCLuVT+EZCvpccVh4QRVHmo7px1+NsRgPJf8kLBCFXyYmTbZjSvHphhHCj0YO6cuQaLquKGljNFEEvio+KE0CruUBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=ey/Zqfnx; arc=fail smtp.client-ip=40.107.20.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="ey/Zqfnx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lB1S9iTyLFbPuBNC3eEzWv18bJL8uTCy2MkfQ1Hm1J6wJT8QzkhAK/ulXVBgM4MGxOiGbHCzwA18vCADrPGzqz+kt21v/S62MLcos9ZnwzQZQcqsqCMf4GeDYMDA42xjSHHPSKiSfAHUkXxA9PQh4eL7jONXLWTDJEx7M2Sim9S0/IPxzaL48jcbNCXfQY4fQPSS16WmK/ZCokBJzoI/kvdJir35r0G7w2rzReNGrEvbvinYnnRlY/XsahDpAlzjGdLocO9VsNEPjJo0rX/yKqVSu3m91JZRwT4Lm4DWUuGpySwg0UjMJhHL8JtLiuYV+I2UGPvAjsY43B5/CAJw0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0AnwRRS0utxzXXi1u4oGluNKi7onavx+bfGhMCajUvM=;
 b=bvepxJXYRLu1wL8iIIGq0yWB3OUBUj6gmnuXNrpfx0bREQ7PnuukerMRFi5u/6JTS2d2iVR+RuC7FkYzTG9LOlMminCAybAkwAK2q/tGUp2bA9YntZ2uFwXvzc3oxonGltT03t7k9oBD8zG/WbmOjst9zOCXZcU3X47MfVyF/sqTchS/SrY49EaZCwe+gSXNGdUrPAwyj6HPWq/hF772JP8anM2THV+oysrXDDjNyd9AZ3UbJ0M/LEtpT4Ab4Uv0x789gYlpca8v0DaFU4l/krviiUp9zVyPVEFgAWBqHCy+LTb0jhTrnCCncnlZOmh5+zUc9V3kfDB9298GEjHH2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0AnwRRS0utxzXXi1u4oGluNKi7onavx+bfGhMCajUvM=;
 b=ey/ZqfnxyQa/SMEtRPJEJeILN2pO088lX2TCaMHWIqHCbMx5IvubsI9AOgYXGQ4R5l+9iSr3pBnZ5ctHoXlraQidoFxFCArQR+FqnHfWLEOVn0Qb+fCsR9bwK81nQGsMt5r6c/T92Zs2afuejCrffGm00rmsubVgmj0B29ijVjx2fmc2Vx80TdKWrJS3/FDmTdEHEfmdH4up7NZN3Hx90TUdMUVTfZwaXi5vm3SltdSvxpOm9OosUKGRT894DvInR4uD1BM/pPZO3a8W+YNYrs+DGfRzhSvRV/yhvgw1DMcXlbE/P1QzOb5nKShUjdHdon84osHSsIaZ1GOrbRuuaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AM9PR10MB4085.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1f9::22)
 by DU0PR10MB8024.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:404::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Tue, 20 Aug
 2024 09:35:24 +0000
Received: from AM9PR10MB4085.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3087:c116:dfed:1ca2]) by AM9PR10MB4085.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3087:c116:dfed:1ca2%7]) with mapi id 15.20.7875.023; Tue, 20 Aug 2024
 09:35:24 +0000
Message-ID: <230fb0a4-812f-4898-8dc8-898074882466@siemens.com>
Date: Tue, 20 Aug 2024 11:35:15 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 00/25] 6.10.6-rc3 review
To: Florian Bezdeka <florian.bezdeka@siemens.com>,
 Chris Paterson <Chris.Paterson2@renesas.com>, Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux@roeck-us.net" <linux@roeck-us.net>,
 "shuah@kernel.org" <shuah@kernel.org>,
 "patches@kernelci.org" <patches@kernelci.org>,
 "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
 "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
 "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
 "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
 "srw@sladewatkins.net" <srw@sladewatkins.net>,
 "rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
 "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
 "broonie@kernel.org" <broonie@kernel.org>
References: <20240817085406.129098889@linuxfoundation.org>
 <ZsMNYtjBBUE5Ehqy@duo.ucw.cz>
 <TYYPR01MB12402A34A443D1F3A6556D902B78C2@TYYPR01MB12402.jpnprd01.prod.outlook.com>
 <0e62552b7b9c1cd1eca6aa1af64006c53230c4f0.camel@siemens.com>
Content-Language: en-US, de-DE
From: Gylstorff Quirin <quirin.gylstorff@siemens.com>
Autocrypt: addr=quirin.gylstorff@siemens.com; keydata=
 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
 XSdq0hnpafc1V+voPJq3LMxUvLNrwg==
In-Reply-To: <0e62552b7b9c1cd1eca6aa1af64006c53230c4f0.camel@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:610:b1::6) To AM9PR10MB4085.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:1f9::22)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR10MB4085:EE_|DU0PR10MB8024:EE_
X-MS-Office365-Filtering-Correlation-Id: f44be525-8664-47ec-c932-08dcc0fb6aae
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RDlMb1pRa21ETW5MR2VoLzdjeUFSMER5d2dNVVprMWJuTXBYUmorN3B4N3l0?=
 =?utf-8?B?V0tvb0hiNkd5R2ZuWlpTQ0YrL1V6T1BYaUY3eFBnOUpEOXdFM1NZRTdXZ2U1?=
 =?utf-8?B?V2JwMGJlUm5jZ2xVaWR5eUVybFUxczRlQW9odlhiWk0xQUUrWUdPU0JxWW4z?=
 =?utf-8?B?SFRvK3FYd3cxT1h1UEVDVUVoelVvTFN2WDQ2WWk5bUhTemYrRHRxU1pVckpD?=
 =?utf-8?B?dCtQb2lPbkFZdkIxNWJFSVF1SHpYc3prb1lIV3VoNFZma2szVGF4V1IwaWVE?=
 =?utf-8?B?OE1CTDUrTjQrSTZ2QmhKM1pyZzlmNitiOWFtTkNCSUo4Znk3OXczWWphM2lM?=
 =?utf-8?B?cTZVMm1zYzR5eitETGIwWm1tZFYyMUtVM3grVEJuMlhvZmhNVzI5SUg0Nmsr?=
 =?utf-8?B?TXpXcTV1STR1NnNSU09raE5YM2M3a21PWExHK1dsN1I4WlFhdVFxcUE3T3dW?=
 =?utf-8?B?d1dJbzZpRVhLL2dCdTBJci9obGlUUHQ2ajRaYXFqSC9zdWd1Mnl3Ylh5d25Q?=
 =?utf-8?B?L0NPeEd3eXNzekhwSElpcnR5SEJJRVdKQXM0VjZjOG15dkMzaWpCejR5Unk1?=
 =?utf-8?B?VVNhUEF5MWRaWXBEdHhEYjMyVjE5WXRwUHpJd0NDWXc2V29lcmdKSU5HenA1?=
 =?utf-8?B?WVRnWDArbWNmbFFzTnh2TEdLZVhMb0dDbytWSTdBc0xQQ2pvakhDMzVxSngw?=
 =?utf-8?B?cURIZGFxd1BtaGo3WWpMaFFGTmN2MWRVSStadGFCQ1g5Sy9tTGlSd3NOWmRs?=
 =?utf-8?B?WldOUndPL2VnUlYvQk91MGRKQ2s4cmRtMDcwa1VkU0p3K2JSUlpMRzFTMHo2?=
 =?utf-8?B?VmgvOEh4YU1nL3d3R3VyVm83VjNiSWZpaHdoOVo3OW1tdmpET2dneWNKdmdI?=
 =?utf-8?B?WkpySjMyMUJLMGhCdGM0eEhXNnNCSDRsVU10WGR3bWk1djVEMW4wR2krcmxt?=
 =?utf-8?B?ZUErY0xveE56b1JUNzJ4SHY4OFlOamdMRkJib0NGeXpsMGUvaEppK2R4cmVM?=
 =?utf-8?B?OGRIaEh4S2dGYzlkc1hQQUM2Y3VSalJPU3RFcWU3YlJucWFtNDl0a3lzYzhF?=
 =?utf-8?B?NEg1YXhNbHFSUEdGajR3cjNsdmdSQ1o3c1VhaGdwckhZTCtUb2l2Tnc3NGhr?=
 =?utf-8?B?bDM2WXBGQTd3ZlpidEJCWldRTXFGRkxVK1I0UDFNcUZkTHd3NWtCRWhsZ2s1?=
 =?utf-8?B?Wkdiamd5V0hleFFOQWtOWjE0b0tDWkFiVGw1UEF6RFFFeHlPQjhpSmlNanNK?=
 =?utf-8?B?WDFham5aYnByV21JdmtZcWZTTHVhOUhjSEx2WmZ1QXVBU1VONzdaRHdKNzRl?=
 =?utf-8?B?QURaTXd1ZTVNVTEvMFdBaTJHMlg0bHNCeU9odm05ckxnYmV6bWRrNFlSMUxR?=
 =?utf-8?B?M3hmb1k4OFErMVMzQlN5TDRISm5lMmNhNldlVE56ZWtpUjZSNURmTkUwS05B?=
 =?utf-8?B?K3FIVXhlQmJwcDZ6cFZKV2phTFh0dlBFSDJlWG5CREZ3dUwzTnlQYUEzenVt?=
 =?utf-8?B?NVZYUTJwS1JCWldMbzQyVE9IMy9RMW4yWU51eE5sczRaY1VsWVc4Ulh3Y3ZK?=
 =?utf-8?B?MHlPMTdkT2xmYk8xQWVhRzFsVkd4OUpTd0kvaG9lSWlTRnYrKzRFaGZmc2Vx?=
 =?utf-8?B?dE9qSlY1ZG9DMlJIT3IrenFTaXhIV2NsY3Vmc2NzbVphYW94ejJraE1QYjBK?=
 =?utf-8?B?U1VEZnhIQWF2SGs4U1BoQjQreDQwQndrR1MvQ0Z0MEFhaG1PcUVrN2t0UGli?=
 =?utf-8?Q?vrtfygCNb0W7ptI7Q8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR10MB4085.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkpGajlNa01sbTJUbzYvRldmUlFMaUl6cVBoZWxTcnFTTExTNk41Y2ZwMSs2?=
 =?utf-8?B?OEVJTi95dGNKRVB4MVpMaG44eDNBRXBrWk5UZ1NNN2lMeE5rWHJrWEpjZWMv?=
 =?utf-8?B?M2VKQndzdHpSWnVlNWhibnI2dmRWQjh5RWVvdUNPd1hOdk1FUU8rOVFZeG5D?=
 =?utf-8?B?eldiQlpVK1hXWTBRNFJiU0RLanBjWWJzdzFqTE1wSkFheURvUzR0dEJNTU9P?=
 =?utf-8?B?MDBlMXIyOWxjdHBqUk9GdENlSUdkbXk2dHlOVWtIVHluYXNBWDJhWjRJZ3E5?=
 =?utf-8?B?VFhUSzVka3JuNDFHSnZZekNDdG5PejlReHh5ZDVsR1h3Lzl6KzB2a1FqaFZ5?=
 =?utf-8?B?Lzc3dzI1UjVBMGJxcGhQVHd5d01SeUE5c0RpN3lKSUdSaFlHZVBDa05rZ1Jz?=
 =?utf-8?B?ZmlIcUdVZ3lpeWtsaC9BUXlCNU0xMjJvTGlYUE9CdFc1czB1NmIwdGpCSWRy?=
 =?utf-8?B?Q3FDZWVWamg4ZmtFLzdDY0k5THFjNndHcmxwOVNuK2M4NUZUaGpwUHlmcjdU?=
 =?utf-8?B?S1FXL3lUUUFVVzdRcU8vVVF5UXZIYW5GTFFGRGcySVVSSS84aFlHclRuWkR2?=
 =?utf-8?B?SHh1Q0xicWhlaFpwRDlpZTVUcEI0ZzZqMjB0UWNRQXppSm1rQ09KRHFkU0lm?=
 =?utf-8?B?OCtNa3ZpVStWZUJrSnRIWGpPOHFISW1TeHpieEZEYk5VdzE2bFpjdS9TNmxr?=
 =?utf-8?B?UnphMlEvdDhjaVBFZzhMUnR6Rnd4M3N4dFQ4L3NpVlhsT1ptZlVRLys5SFRh?=
 =?utf-8?B?MU1vUGU5REVjRHFwYi9qKzVvOFY2R1FsVXRHeS9TWEtJVE1lWEluejZqTXUz?=
 =?utf-8?B?bWZ3WVQxQ212UDVaY08yVlQydTI0U3hmUWw4WU8zb1RLMkd1ZCtTeXBiRFBG?=
 =?utf-8?B?R09PS3IyN082N0VteU1qTiszSDBuMkpnMWdjUmVybDFKNEowVEp3TTQvYWdU?=
 =?utf-8?B?UXFENXVyQTRnTGRMZEJyUE5EeWdBUkx2YURrdjNwbDNIdzVOS2YzYWcyV0xy?=
 =?utf-8?B?YUtPZ0Z0bHlFUDNFQytGSWRyVkNhTGx6R1BUTld0MzNZN3UyYlVYd21ENFA1?=
 =?utf-8?B?NW1hVDlCcnVtZWQvOHFkalV5YTFUUUxBSytBakI3VmZWV1Q4R1lPeDNYRzFl?=
 =?utf-8?B?SHBFeEJ5VkxKcGY3clRSN0Z5amJpMXN1S2ZDY0xlMmtScDBiVUJIUlJwUE5w?=
 =?utf-8?B?UU42T0lLakdsREwrRUQ0aU9oWGZFeVNJa1g0anRpSm81SHdRK2tBbjloNHB4?=
 =?utf-8?B?TDhwZ0ZaNmtiR0pJeDEzTlhnYXN3ZWdwczljZmFyK0g4bUU1clBodFNnZ0hl?=
 =?utf-8?B?bklScW1HZkRSWTlvaTNUck4xbVIwU3pqeW91aWozR2tJU0gyc20yeVF1QU5W?=
 =?utf-8?B?UEVBZzRFUHpVK2ZUZTBQdnVwRG4xRE8vT2kxSU91WHhKZTNsTXhJZW5nZHlt?=
 =?utf-8?B?NjF0dTdHTXRTeWNDUWhtb3FxK2ltQ1hGUHh1YnVYdFdPWEpXRHNMcy82ZXZL?=
 =?utf-8?B?K1RoU1oxNHJiZS9pczdnWTJKc2VCTnVDa0UxVkFQZ3R0eE9PZjNTOFJSNTVK?=
 =?utf-8?B?RlJCeDBHN3NVWVhYYkRzem02RFN2c0c4NEJqb0FqanNYWUt2dDBJTytURXhK?=
 =?utf-8?B?aVpMclVTU25Zb0lMMUwrY0ZDRjgxM3ZDVTU1M0tEdCtNaUhlWHpZYnN2VjhE?=
 =?utf-8?B?QXkrejhndCs0YUo0dE9IR2k4akp4K3phaUJyUklGNHFVM3ZwR2hKN2U3UEkz?=
 =?utf-8?B?UEk5RndNUW9DTlNhbUI4a0I1YjdOWkNTVVgwdGthVmx0VWV1aVZocUkzdFd1?=
 =?utf-8?B?T3k4elVzL3lzb08zQ3ZWdGFBZXFyK3VJanA1QXJyakl2dllRVmRZUXRIRDNv?=
 =?utf-8?B?QitiMm00UCtLNkhsM2srMWFTemFZUm5Na3dxWDJDLzFrR3pnVTVDdkFSUEN2?=
 =?utf-8?B?ZzBxeit4ZnNjeXhmVkl1RDJRRzJYc1lCQUNZQllPTUtpVUhESmcxTTNVTnZl?=
 =?utf-8?B?NFN2WnhpZDVyUjV1YlJxSk5YUEUrZTBianhyZlprZ21lRFpTU1lSSnNZd1Rh?=
 =?utf-8?B?ZU1rU2x5ckxydVA4U09OdXBCbVVHUzdUeU5KRFRIUVV4dEQ3Q0xadzlKajN5?=
 =?utf-8?B?ZWdNeC90UFFwV0ZSMEhCWk94dnNZZHpEL3R1ZHJ4V3FkczA4Qk1qelVkNEJq?=
 =?utf-8?B?ZFE9PQ==?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44be525-8664-47ec-c932-08dcc0fb6aae
X-MS-Exchange-CrossTenant-AuthSource: AM9PR10MB4085.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 09:35:24.1234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFkAWXD7IX3Bfja2S03UF6zYoDWYQ5YmAuCsznm3WahTO2CNlm6Dc0vEfMM6Xzq7LGX1Q0AXhfBErrxa0TA+YktKYU/2MugB3xQ7Pp3+mI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR10MB8024

Hi,

On 8/20/24 9:37 AM, Florian Bezdeka wrote:
> Hi Chris, Hi Pavel,
> 
> thanks for reporting!
> 
> 
> On Mon, 2024-08-19 at 15:18 +0000, Chris Paterson wrote:
>> Hello Pavel,
>>
>>> From: Pavel Machek <pavel@denx.de>
>>> Sent: Monday, August 19, 2024 10:16 AM
>>>
>>> Hi!
>>>
>>>> This is the start of the stable review cycle for the 6.10.6 release.
>>>> There are 25 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>
>>> This one fails our testing.
>>>
>>> https://lava.ciplatform.org/scheduler/job/1181715
>>>
>>> [    0.493440] ThumbEE CPU extension supported.
>>> [    0.493646] Registering SWP/SWPB emulation handler
>>> [    0.515073] clk: Disabling unused clocks
>>> login-action timed out after 119 seconds
>>> end: 2.2.1 login-action (duration 00:01:59) [common]
>>>
>>> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-
>>> /jobs/7610484202
>>>
>>> Failure does not go away with retries.
>>>
>>> Now... I believe I seen similar failures before, but those did go away
>>> with retries. I guess I'll need help of our Q/A team here.
>>
>> All the failed retired jobs from this pipeline ran on the same qemu LAVA machine.
>> I've rerun the same test jobs on different qemu machines and they have booted okay, e.g.
>> https://lava.ciplatform.org/scheduler/device_type/qemu?dt_dt_dt_search=&dt_dt_dt_length=100&dt_dt_length=100&dt_dt_search=6.10&dt_length=100&dt_search=6.10.6#dt_
>>
>> So we could blame it on the qemu-cip-siemens-muc machine, however, it was quite happily booting 6.10.6-rc1 a few days ago:
>> https://lava.ciplatform.org/scheduler/job/1180857
>> 6.10.6-rc2 was also okay:
>> https://lava.ciplatform.org/scheduler/job/1181017
> 
> As Chris pointed out that this might be related to our qemu instance in
> the CIP lab. We had a look and found the attached kernel splat. This
> seems not a guest but a host problem (which is Debian/6.1 based and not
> 6.10).
> 
> I think you can continue, ignore the test result for this 6.10 release
> for now.
> 
> We will investigate further. Let's see.
> 
> For completeness the kernel log of the host is attached. LAVA runs into
> a timeout and marks the job as failed.
> 
> [CC: Added Quirin, the operator of the infrastructure]
>

I fixed the issue on our side - the test succeeds [1].

[1]:  https://lava.ciplatform.org/scheduler/job/1182103

Quirin


> Best regards,
> Florian
> 
>>
>>
>> So it's an intermittent issue, however I can't say it's with the kernel or the qemu machine, maybe not so helpful, sorry.
>>
>> Kind regards, Chris
>>
>>
>>>
>>> Best regards,
>>> 								Pavel
>>> --
>>> DENX Software Engineering GmbH,        Managing Director: Erika Unter
>>> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> 
