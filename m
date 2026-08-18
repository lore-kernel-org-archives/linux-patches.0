Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD4433C19E;
	Tue, 18 Aug 2026 20:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787084474; cv=fail; b=TXx7Rt7pkRU51mLstI5x7IFXbCD9f8mEr+c291/KMeBxn1M9A1JMhS7h6IpPrz/cFZTWVo4QA5DFaHyaAiCHuuSQ52clfZRYz3Q7sUH4GDtAOQKsO3Li2LreLIx5FNKvAvz46RKwZL0HybFWHQ3sZUHo2oRjA0ElWEG/s+CLFzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787084474; c=relaxed/simple;
	bh=cnY5Sn5kq+L27B/QZi6/0kSl1h4ZV/47NH9PDghTkBE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kN16qNEWzysdCzGlF6CrYSwc5A7iaIh6kpkJJgt+DxVN1gzIZDvHfpmIgzROgc2yp9VuxRzBt9YgHkwaIwIl9cyaDTgCsedQodu4JYWfY3bG4IPK8rl0NCIyfUeAwv1bIqAe6OqleCFoKpzjXPyvQui85PIAfz/8FUkJEziUUEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S9idJERb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BE3QfSF9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S9idJERb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BE3QfSF9"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IEqLlk3311584;
	Tue, 18 Aug 2026 20:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=c6oeU+93YManZS1W84Ixv0KeOs4s3GY0Cl1KpVVralE=; b=
	S9idJERbBBPjv2tyzX8EOgqLeVIqlG8XHFrDamDqE9Qghgze70zBiLgqK6VHV3Y2
	cgQ1+QxvZwDHDG1sbCvY7OSLuDzOtsawPKDFoDW4fmzrQPXtHe+f4WvjelQWhAsm
	v6+10BllxMy+0xPLlgP70LWgpCIUaI8AII7KAxbNeMtMq/5q+XuVuwBH6P2xVvEB
	OO/4Hmi6GD5Cl4gsJ/kylaoy01yazun3y9zCY7wdimEkeAs3xyiEDh6KXlE9bcxM
	gDFNs8bkxqUffI6nhhYv+N42glIC2PKj82l79fg1CPpKvaCkJjWYBfl72aW2iMZH
	gLd034odmv+oBlvth5sI2g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2ew55nsx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 20:21:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67IKJxtK026873;
	Tue, 18 Aug 2026 20:21:01 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010063.outbound.protection.outlook.com [52.101.85.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejdcfp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 18 Aug 2026 20:21:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uc5tixvVdwJBrZLO4pkOCa/YapGi2e8MpwH5AcOBc8O++VHR794+kYYWVeI6E2SKXRvx4uzgGQsHH2etDiLfergHxGRQCGhperHDpXZYnr8wZhn4erZtO1aDVIJXI1CZvbm9lOLwFyfAUYb5flOEdKGqWdyp/+KJvN0fxeQ5CsVACSLZsOEtt2g7Mbn+gW56JhRSWXa2Atmfg5SgKSPFo5PAqsaNcJjPC8bwMghogcaMTdPkf1VYm5GrM3nL5tR1Q0LJL+sVDz/q2nd1tHv6XqewDsLuMVWJaSUuWPq7U1SSYRHMsxzA0UQHcYGf8XrFBQvz28HNFT0HeekqzAwMmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6oeU+93YManZS1W84Ixv0KeOs4s3GY0Cl1KpVVralE=;
 b=pl5YjRU16keYDO4RGkxuLuvP04it12cS7OAXnLJaEs6qsSI93kOwKbtLgl90GPyusGJzPcBLRCFNiM1fix/nlsKc7mgMfvbL3QqdvbNtPR7k3HZ+JhxvzzSftlrGzFnjt7WIxb4M5YJutKN3MiV3hdhAdoR61zz5ulAWX8rSfAd4q8v8/MnxuTgBMTG+5DidE493NDS4Ye5EjZ+tNKthgp3XZXy7Ru84Vai/AXnVVo+Awmr9oe/BB39A1CoC+gO6Z/trwHMNPkDAEinxO0bco9QcTipDxVE1bZfy/GTfX1hmJN5V2d37+B5J5jGtdumJ7rnTylfMaGffp3jjIqkbWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6oeU+93YManZS1W84Ixv0KeOs4s3GY0Cl1KpVVralE=;
 b=BE3QfSF9UtovefJE4Ey+tSZYK7uvadj/IHhQWR3D3c96EmvJSuFtxY4qJZ3mlGP9vgohLAWrw/BDUQiRHdhcahrk6ehwU8KuzpnqO+dw8C3Q/AmoNQKjllqUUovNu2yj/dHvV6WNdIs+OXtWh7g7CgcH7Hp2SBmpOcLjtwLUylk=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DM4PR10MB6864.namprd10.prod.outlook.com (2603:10b6:8:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 20:20:56 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 20:20:56 +0000
Message-ID: <70b7ca30-be03-49c0-aea9-840d734011b8@oracle.com>
Date: Wed, 19 Aug 2026 01:50:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 166/181] ring-buffer: Use current_context for safe
 per-CPU buffer swap
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
Cc: patches@lists.linux.dev, Tengda Wu <wutengda@huaweicloud.com>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20260817132535.394764707@linuxfoundation.org>
 <20260817132542.216680403@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260817132542.216680403@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0103.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::18) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DM4PR10MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b8280b9-039c-4217-cccc-08defd663583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|22082099003|18002099003|10067099003|4143699003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	AuJyzy2rYPM/D3ihKMMX5+CP7HaPVFT9qbacjLmxI9jz599acVpdbTYuN6NM0cvUNiymVoHZqrAk/XdH5xLMV984PNIQhZg29j9sDvaOuKv3tY5ohZJwe3SFq2KSZ064q0UPk9IcwiKH8wB6hlDRigT5lVyfNQp0hmfxqMAte04s80pOwRJWygVyCevq2c71vB68OdiTtCSX2owoowO2mnsIr1pm+tGzEUwQ6TMiwvE5feJ//cQTGGqvrHhc3vLs1lU5cXlAM6WDzN19Urnf0sv1ddGNlWXrCm+R7TUQrsuHxgmpWvdUvuKR0VhzH++lgCLzz7cR8x6NXcJPRzkbAyBYoBQgYTlaXdrjhjdUetDKlpmOjp5+wHj3adWXBLKZYXBBZUlik2qk3PdpJphmat/s3kqAfaty9cnVjBNKrzdtIuXVVUVrAko5fEQ7tNxHZoCbUdrDUDbwni9V41eij3XAFg6HPWVlc7+Q4pLdu40RTP3MYVD7Wg10asTy+HZfMn/ryB2utiQhxXm5nk8IBSJxkBq0RVjmYK42n96GOm1Cj3nGqaao3yIWQy1PEer8Oib06d9Y6quKdzWVVqzmVxp9b8p8pWMgHsL+uhP0JrbDWN2JnMIih6cbmvAI7+7O
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(22082099003)(18002099003)(10067099003)(4143699003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wjc2TWplWFBvT0pneUtUU0VZUW9qVVc5eU44bjRSY21YWjAvRkI2M3doNUJI?=
 =?utf-8?B?djBuWGxMa0grV2VxZVFlNHBwTUozR1dvT2VidnZnZ2VTRVQ4OVRFRTcza2Nj?=
 =?utf-8?B?cWttb2Q2NU1JN1luV2hSYTN1RWlyRG5iWlVuVmpHRHBQL0orcVBZbjBwaVF2?=
 =?utf-8?B?eUJuRUQrdzNDQTVQN3Z3M1VQS3ZBVUFSb2FwazFJRHgxZ2FTQUI4NE5yZnhq?=
 =?utf-8?B?dGg0OTJwTzFrdmhmR2tBYVR3RkVKVnNOM1VlZmt2cCt1T3RnR3ZzWnV1a1Mz?=
 =?utf-8?B?UDRiN2pGWGJIRE1HdmdGUzJ0V0VxQlJLVlFud2dFVFB6MkxTSXlYYjJYdUo4?=
 =?utf-8?B?ZDdkZHdOK29ueWRVNzkyK3dya2F6bFJHWDNVeGtkaDRZKzdBdnlLYWNFQVVt?=
 =?utf-8?B?bHQyYUlyM0x0b25PV1cxMnd2QlpQRnFHYWpuazRua2tnVDFUT0tUUWlsVy9q?=
 =?utf-8?B?ZGpnR0RpK3p0RWsyZHRDUVJQakh1Wld6a3NlZmVPVXdtRnlqZ0NUWXFycm52?=
 =?utf-8?B?ZXFmblBXY0p4MnhIZm03TzhYUmMrdlc2S1Q5aVRUMlhpT3ZFNXRRbFNjTXNk?=
 =?utf-8?B?cG0vaDF6bHRRWFk2cmVCbDV1RkNqTkExblBNU1FkOUtIMmVQQkc5NWxWbllI?=
 =?utf-8?B?VXlGeG0xbHBmMm1hUjlCWFU4aDJXelRXWTlLdUhBdWxXOUVIY3REWEJONGJY?=
 =?utf-8?B?c3haUndrTGd2K0lUdlZ3NXJpRUlMUCtIN0JUeDlxdHplZGJibTZpK1lrN1hQ?=
 =?utf-8?B?TVhHemVrNjVFcDFrMjcyMklaSjFzTzFYR09VS01Gak5QcTdHQzVybCtQelph?=
 =?utf-8?B?Qk1mKzl2dEtSUEJ3OXhNVEFhNWQ4L1E2STlvS1ZKZmFkdmpqbFgxQ0RmU01t?=
 =?utf-8?B?RlF2SVh4RzFzbVQ2QnpGeWVmZktvd2Y4NnpoU3dreUZSZU9pd1g0Qnpuem1F?=
 =?utf-8?B?cU5rbkxQTHZVRXRvdmE4VGYzMU1lRlZCY2EvREFXaHhkUm5aTXdXYVRoV3Zh?=
 =?utf-8?B?SVdyL0pJN2lrcUNhdU9nNXQ0UWRqaDZ3K2hYOVNRb0RWUXA5aDVoRXdwRUFO?=
 =?utf-8?B?WGMybVBMTjZrdUJDY1pmZEZzd2NldzA2dmNGSjJqWnhJSUxKRnpQRUw3QTFq?=
 =?utf-8?B?ZVFhN1d3anY4aENiMmFpWWZMUnd3ejBOaklMNEhvMzY0MU96L0VNTUFYQ0JO?=
 =?utf-8?B?RVR4S0ZxWGZNYzRJeE5zRTlmUVBkR1k2M0NOYThBYlNmbzREOXJaKzZ1Z3Bl?=
 =?utf-8?B?N1JxWXFkRFdJYUNNWmNNNDF2QUtzOFB0QnkzQ09Nb2d4b1BrKzVhY1BrOGJp?=
 =?utf-8?B?YmErTko1SWg1RnFXZTFSVnpqV3lUT0JxK2p3dS9ydnFKeXBWMVFmL3JBMEF0?=
 =?utf-8?B?KzVBbjVZWWVvUlliaDZKWWdoeHBxa09UVlhNbVRRVVc2ckxNQXZEUjBFdFNX?=
 =?utf-8?B?LzUwL1I1TFRXVjBnS0pQQkhHbWdwRXJGbUxyUmdXRjYwR2VaenpyL0VpdWlx?=
 =?utf-8?B?QkVhR0FHOCtaVkJuRWcvTWpPclFBUDRRM0tpRGNqYW1DVGJGdnBEZXBPb0hV?=
 =?utf-8?B?ZzFWWFlaM3NwZ0x5UkVhZkVNNEt1SDlzYmJ0SzN4QmNjTWU5SmNhT3BIWUg0?=
 =?utf-8?B?amp4S29TcWNqTEoza1hUak81ZHBwNkhBbFkrQmljSXdscDNSNXJvOHNlSFJB?=
 =?utf-8?B?OE85bklpNlZtcjc3OXhJa3laVXpydXYrTW5VMEIrdC9jdkV6SXlFWWtMU2tI?=
 =?utf-8?B?QjNPcTgzVzVNclNvRWJxTnFDc1NzOHh5cFMvS0E3RFRBek1DYXAxVkxYajNN?=
 =?utf-8?B?Zi9QRHJKUEc3NG1PRENncjk5ZUNMNHQvMXBPRUpJeE81VUVTYy9leXBwMHdS?=
 =?utf-8?B?cHQydXVmZVBMZ0I1Ym00YWRteUlYeWErcVVYN3MzWnJpclFDc0xqVnJuV0k2?=
 =?utf-8?B?c0FrbEcvejBqdnBHOWlEejVBYjNHc2QzSHZTSUlmU2RIck1lbkpPZ3E2c3pW?=
 =?utf-8?B?T01ZSERnTEJLMG1jdCtmcTEvQ0hrR2hYUXlJMWYyRGU0ek9mM0lqZlhXQmVD?=
 =?utf-8?B?SHUyVEtIK0V1VTVQbGpBVmUvWEM5UDlEaXBzMDUrN2g5VjNnZEN3dW53Q0Ur?=
 =?utf-8?B?cjB3bUFpaG5tSm9xbzkxZU5QcU80aDFUZkFmb3hUbnBrd1k0ZnlIbllpaHo4?=
 =?utf-8?B?djVvQlM1cmxGVXdTV1FNZXY5ZEhXRHhnb0xGaWxXK1VHSUVWL1JTTW00TWdC?=
 =?utf-8?B?b1J6MUJZN2hTSVZjUFF3eHdKOXdWTHNtRmR0bmNzY0hrR25EQ202S0l5U1Np?=
 =?utf-8?B?UFBkc2tyTlZJRWc1bXBBNWtoVi9PWmgra01VRGM1VDJ1M2luR20rS3JjaG9p?=
 =?utf-8?Q?MhQaAKSguXptLNzHZ/DehvkR+FfdziLrT2iL8?=
X-Exchange-RoutingPolicyChecked:
	isZgulIah0Q+x+gGEsgSF1lOt3kdnJ1pE9qaYQJU0FI27KdraPj5q/8J1Z8rYCy/Lk7M/lylVILe0AVqZNAcXXl+qtKAngJu9Jj1pIVOknveNWmsF0EVrkOFtnWRogMklsH/fEl4pkMDretVxyb+PfUUcIpQ6X2w5g6Kbai80r9m7jDhJ0zpzprgfAeRK7M1T8IB1T3lYYXiOvYQ1OYmmuu8SJ+g9ekq9xqyRHy+WW9sPaE2V9Spm8mQ9/WYWFj13oylLqPbNB+T1m9r4qTYoSk0LtKCQ2ljcnpcidlp/R7S2BdjdwZOhyOiWu7wTH8+CAy1lm0XEmxGY9bewnXqlA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wlo0MWQi5lgWDqmYFiD6x9yVN9c9NEyRhEjnqyOordUIwEFUH1jA9zka1lCxokCG2cu1Q7XGC1fi56ksuBqayYlH2fOFqFbIO+2CV8OYE1d9XPoWaxF/xOkEnw7OyoXAP3Km9lCqsK6J9tPXfeUkSoIJHfzYYS02/gUyysXFF9BYkeIp1bnxgVFBLvoMczG3yrUAzbENBNM30nNzrn0Ga6xx/CY2r6WB23o011G3nACsFax8xGXj7FkTZ4mj34F+6KZ8Id39gN/0pRdQyXNMzRqss2UHzro8WsVq2DdA3oI1RT2xNJ8tr+dm0nasuwZ2f7O3GgF8mQYipbN8HsD0X4FQOnUc40XUNkuU0fZzsSdJWIoag8A0cEg2w+cjDi/2uldRfo9XdKuGWhh2K/dayrR1D2QLgFVaXAAgA1DrKQcJQAA70mUWp3FRVRhbHRS+i5IY11RRjI9j86u3GJ1FpEon4qZYoxmHzQw8V7YeYauFUK9qK1l92WrknwQgX6c9Wxlrux/Yl1nAEszyev7eaEMcjJG9BFY+xOq73cic74M8F8REWhbmdCO5DjDxxF3rfDpFHHVPZCSu5YGSdK3cxccpCoDCQKZr+h81IfkHNA4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8280b9-039c-4217-cccc-08defd663583
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 20:20:56.0746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+zPHWMJxrYy23B6MtMjncsbNYg39NxHq4XotGSg4NduifEh1CG1aZp/vjyGMOWJbfJGspELynVUd8BKSbVVYn+/4SJmUhRBjaUE6PzYvx5IVT2eZscycdtklUkdLZ4R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_04,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608180149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDE0OCBTYWx0ZWRfX39J+FjZu9tTP
 omdyKZKq0/UJFbI9Pjcm3Ohe7l5QC0KoW5JeB0zlLGizoUVnXtlFZgxcX1AkUNsgm153j/+meGc
 +Gx0uBHmHNj80QFDwFebQlICayo5QNmRazHRgsA75SC8ICFSKtA3SIc3Rt5Hy9wp422uqUbHhSz
 ZZjVwX0GNkLImdzI4OHzmHGh3ZEBhiZLtY7kSSBxl8PSN9q2gJehl33sGSpI1pqlwSXlL1iK40t
 zYq7Dax+L6rso00Gxx2V4t/Jhk9VWE8U4ttta8tqF1lbm8tUYd8Z00D9MI1c95DHorPR0bD9IPl
 R3FtjnGFdTYRHwJIloinT2RCa2jQADw/gR1MpTiRwRvOrdRUPdmqpR1ldUv+YWEKOR2dMHmu6NA
 ApIAJzDrV8vAojvchJTVzDJuMoeOD4+BTueZTWufTwSvkgunnIHY52IaUzSk0O/ijNTzCaXCb3t
 dvC/pcZPoo/BvUYbQrQ==
X-Proofpoint-GUID: pZ_mEoi6yXtRVIMmilHQORZ8nvVVcI48
X-Authority-Analysis: v=2.4 cv=cYbiaHDM c=1 sm=1 tr=0 ts=6a84beae cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=bC-a23v3AAAA:8
 a=AiHppB-aAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ag1SF4gXAAAA:8
 a=Yh_hc5WkxkuZ3mby-R8A:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=2JgSa4NbpEOStq-L5dxp:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDE0OCBTYWx0ZWRfX73U9yaDgxA7k
 LTyGAUUNSHqIP+39rhuesPStfX6UTGfYVVi8X98ifQlnr2ioJixeoOJueZLmOchMhfW77RSmp/w
 HGwFCaf9QFFHOPh02X86yXs4DFOMVtmaWjmgYTbwD/6xoyaSokDf
X-Proofpoint-ORIG-GUID: pZ_mEoi6yXtRVIMmilHQORZ8nvVVcI48

Hi Greg/Sasha

On 17/08/26 7:04 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tengda Wu <wutengda@huaweicloud.com>
> 
> commit f27bdc43077e4fcb5557dfc315ee8d91e741f483 upstream.
> 
> The ring_buffer_swap_cpu() function currently checks the per-CPU
> committing counter to determine if a buffer is actively being written to
> before performing the swap. However, there exists a race window where
> this check can be bypassed:
> 
>      ring_buffer_lock_reserve
>          cpu_buffer = buffer->buffers[cpu];       // cpu_buffer_a
>          rb_reserve_next_event
>              rb_start_commit // inc committing
>              if (unlikely(READ_ONCE(cpu_buffer->buffer) != buffer)) {...}
>              __rb_reserve_next
>                  rb_move_tail
>                      rb_end_commit(cpu_buffer);   // dec committing => 0
>                      /* interrupt hits here, successfully swaps! */
>                      local_inc(&cpu_buffer->committing);
> 
>      ring_buffer_unlock_commit
>          cpu_buffer = buffer->buffers[cpu];      // cpu_buffer_b
>          rb_commit
>              rb_end_commit
>              RB_WARN_ON(cpu_buffer, !local_read(&cpu_buffer->committing))
>                                                  // triggers warning
> 
> The committing counter can temporarily drop to 0 during a single write
> operation (within rb_move_tail), creating a window where swap can
> succeed even though the write is still in progress. This leads to
> inconsistent buffer state and triggers the RB_WARN_ON in rb_commit().
> 
> Replace the committing counter check with current_context checks, which
> are set at the entry of ring_buffer_lock_reserve() and remain valid
> throughout the entire write operation, providing a reliable indicator of
> buffer busy state during swap.
> 
> Cc: stable@vger.kernel.org
> Fixes: 4239c38fe0b3 ("ring-buffer: Process commits whenever moving to a new page.")
> Link: https://patch.msgid.link/20260803005640.2445666-2-wutengda@huaweicloud.com
> Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   kernel/trace/ring_buffer.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -6253,7 +6253,7 @@ int ring_buffer_swap_cpu(struct trace_bu
>   {
>   	struct ring_buffer_per_cpu *cpu_buffer_a;
>   	struct ring_buffer_per_cpu *cpu_buffer_b;
> -	int ret = -EINVAL;
> +	int ret = -EBUSY;
>   
>   	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
>   	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
> @@ -6298,10 +6298,10 @@ int ring_buffer_swap_cpu(struct trace_bu
>   	atomic_inc(&cpu_buffer_a->record_disabled);
>   	atomic_inc(&cpu_buffer_b->record_disabled);
>   
> -	ret = -EBUSY;
> -	if (local_read(&cpu_buffer_a->committing))
> +	/* Do not swap if either buffer is in the process of writing */
> +	if (cpu_buffer_a->current_context)
>   		goto out_dec;
> -	if (local_read(&cpu_buffer_b->committing))
> +	if (cpu_buffer_b->current_context)
>   		goto out_dec;

I have run an AI-assisted backport review and it spotted an issue. The
current_context checks themselves are correct, but the return-value
change does not fit the older 6.12.y control flow.

Upstream has direct validation returns:

	int ret = -EBUSY;
	...
	if (cpu_buffer_a->nr_pages != cpu_buffer_b->nr_pages)
		return -EINVAL;

6.12.y instead has:

	int ret = -EBUSY;
	...
	if (cpu_buffer_a->nr_pages != cpu_buffer_b->nr_pages)
		goto out;

This changes invalid CPU-mask, page-count, and sub-buffer-order results
from -EINVAL to -EBUSY. I think update_max_tr_single() treats -EBUSY as 
an expected commit/resize collision.

Maybe we could be retaining ret = -EINVAL at declaration and assigning
ret = -EBUSY immediately before the new current_context checks.

thanks,
Harshit



>   
>   	/*
> 
> 
> 

