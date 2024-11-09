Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9281D149C69
	for <patches@lists.linux.dev>; Sat,  9 Nov 2024 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731168279; cv=fail; b=hyVNdRs9ARbdxn7/L2OFpc6xnP4AN2OGmGsQft+Dkj8kAt/+UCAbX9yVjxwiLCVSizP5qzRm4VuOwKgQq6MBmo/N657EU6OQ3joK0pgHPOt5v7E+I1gwFfIko850UutR/8ISJUFxGV8rGmXSwWmhCQ7vLN/QT6+kvhExKLs8pZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731168279; c=relaxed/simple;
	bh=4j63zVZJi4DKBOdlMVtlpR3w9iyAeUmWr0G8tHoQrt4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jdlt7+JDEYclO4dzt9hj/caUnu2CE2mHB3m6q0l9HFxltWjZ4D6km4HaeJWZ1J+jBqpGpdMRow5xJHE4jOx7spoms97W/pSX6w20Hb+ukey6zRFtCk+XPYM5JQl96X+aO3R9eRPGa2qN1dTQWmYSVZgkSjfDx8kJDUUGiXGVDSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C7T278Wb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dLgvGCUY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C7T278Wb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dLgvGCUY"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A9Drmea014620;
	Sat, 9 Nov 2024 16:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=iuUPy1t/yVvizspiUuXZWaW951/PM2dpGIWh2ou8iqM=; b=
	C7T278WbZWN91TWp8vXOXa+5unZ0Dm6yo5Shr3o6qu0yTUgtqAT3rlrRzMO0X21z
	9+Q3ihaw9XVDonSkYGrPwniW4DsufsePcL14hxwJfSVCOiSZP45SZmQ2FJ5u8lUL
	Wl09pHUkDxYDxmI9XaV44UPF9jMlULBX58OMhIcQGJ+kNLqEuma9DK9hEGVjdnRp
	YXTWweTe7NlCxqb2GcomMFmPZAxfgoY5wB/Te7qUN5IgwbRBjZ3HndJ4/Qs8Ilx0
	iVZNwvyzVuGGY+bdrIVzf0+GWRpT5f/8B/o3D3aYVFWq5dEHMUpLP3DxZw4B5/HY
	vldHAroLITUFwbDTIeR3Sg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k20bwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Nov 2024 16:04:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A9F3tS4034312;
	Sat, 9 Nov 2024 16:04:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65mqps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Nov 2024 16:04:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPdOOkhXl7gicAEHYrUpLrKw/4kf5+CM1W6TTrzQjPgjQHIbJEWQ7no+owHVXLowE1I7STdGIrtuPKnFQo1t0EjBCV4e1NPey5W+WFUOqKdnXXfkvh2hy+SYh2P1go7QDWcDRiDm0Lo5HKQBCLLC1PAZDigxChLpHJaARj8kQztCZYT+ltVLmZ2/z1xI3zxn/gLEUAJA1abjaal6vGWSA6of/TBjJoMX6OuoMk2TzCCICRyYgFQiq/HTZPz748YHNHV6LNBslod3kyKKmHnQtRq7RUvOuSI0VyvI4QCnO1wEs8rT8YRuN8yp0pQmNQYANKrekM70ef6NTTGLFwF23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iuUPy1t/yVvizspiUuXZWaW951/PM2dpGIWh2ou8iqM=;
 b=ttwUGXtHO+3P/NCHNxpOibjq1LmgH792L7oghV8FxqrkCqx1UqordiX+eEpwK2lBr99vyaCqMpgi/N7IlyExVyLUMKIxN7pBUN40jwZwVwVdlrz01NYjXa13AonVkPPlQs+dnsd+VjMQh+BqeX0EGCeWcOCrgaA3CH3ItxwJbUzKnS1eVIvRpb+kzbzgqoqckJIapZzTnOH3EguZSk9nNJXCTmsnzVjwU8Mv2RYN8LsAKVU69yY2z0cezjX5JAHs20Dfn02jqDkTvKgisPGsX4hzrdSW1w+WObmOEKzeAL/hSzWKh/8cCB+Yjc9bZLzUyXpz0rEvR9Q5heaDVJaMpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuUPy1t/yVvizspiUuXZWaW951/PM2dpGIWh2ou8iqM=;
 b=dLgvGCUYQ1zgUKI1RKpFRKGy4Hd0uYl51yXplg/fYuWbEnvY1ZJzsfYBomnEuVHWiu0eqhk3+brL0U8x9Avci271ojwmC8E4qdpnYry/c4K3yXZE8UB9F9SPa6L6SSOmlRgN4DhtudIZseQ0SBQlKtOzjwKeJ/lAecP8Eu/gIUc=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by BLAPR10MB5042.namprd10.prod.outlook.com (2603:10b6:208:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Sat, 9 Nov
 2024 16:04:25 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8137.022; Sat, 9 Nov 2024
 16:04:25 +0000
Message-ID: <e0e8be47-470b-4e13-a152-be795aa92907@oracle.com>
Date: Sat, 9 Nov 2024 21:34:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241107063342.964868073@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0225.apcprd06.prod.outlook.com
 (2603:1096:4:68::33) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|BLAPR10MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: 99ec7dcb-d863-41e4-9cda-08dd00d82e65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnBkcW04aFcweXoxMU1wMjRpT01URzhaNGVFTUlFSkhZNW5RUy9zVGovVUU4?=
 =?utf-8?B?TmxOQ0VqZGljOG5sYjR3YXFwd0lxRlBmWjZrLzA5NFlYZ3luYlVXUXd6WDla?=
 =?utf-8?B?d3RHM0Q4RGI3ZHNCNVlxSTNoSFFZYjIwYTl0QTVKZ1ZsNjg2QkFmcWlyd1FT?=
 =?utf-8?B?OVQ0RFE3MlJrakpQOHpMODRmcXVqNDRhVDZ4bkk3SGorZGpaZDhPemFaaldn?=
 =?utf-8?B?OWlBditVdDNqNEdqeWYzeERLc3JJTmJqYzVtSExkdUpYbFZTQUxWQkFYdCt0?=
 =?utf-8?B?ZEZXdytrTHFZSVJ1WmJwd0k3cGh1VzRsZFpja3JlOW5xazUwRER6UXV6TnBy?=
 =?utf-8?B?MmdlYjRHNnFZUFBKMUkrN2RYdnh2T1VJSEdwd1pjdDNtUXRZeUVsNElzK051?=
 =?utf-8?B?SDFaR2JqTHRxR2NSL0FBcGNxK2RDVnRDUHJjQVhUdSsvenhCZGdjM1pFOGln?=
 =?utf-8?B?by8yb3FlNWhySDA2a0hsc1d1QlByTjU0WjIyQS9Jb2w5VlRrdkMzem5kclBj?=
 =?utf-8?B?b2RMSEYwbG8xQzUwR3gzeXgzbVFFMWRHYWpWRG1GSUhJc01nalFKWlh4aDNy?=
 =?utf-8?B?V0ZxYWJLcXI4Y2tCQVF3ZVlOSXNDUlRLVU4xSDJpVm1tQ0FBZkZOd3YvZkhM?=
 =?utf-8?B?Z0dTbGdsUmtLZEhxczJpckNza3d3eVQ0czlFeDM1VG15cDhxMkpqcU1uSENP?=
 =?utf-8?B?WmdsYUFCK2pQMHZla3MyM2lQeFA0clBIMnhSemVoMkIrMkRMaWRjR21uTTNF?=
 =?utf-8?B?UG5ySnZzVEVaTHFpc2tFMjg5dnRKc0sxY2ZxdCtXZkJleVlkMEJTMzliOElJ?=
 =?utf-8?B?dERNTWVuc2ZEZWExWlh4ZWhCaWEzU3EwTWhwZzcwNG83d0RIV3M0NU9zUVp5?=
 =?utf-8?B?YUZ0MHdLQ2FJek1LN0RrKytIVHVPQVhEcENWOE5acldnNkltWUpmSkVWYnF3?=
 =?utf-8?B?RjBIME5CektvSnYvWHpSNnJmeDFOanRORnVIUXdsVXR2OXMzSEdBQzZQYzEw?=
 =?utf-8?B?THp3SzQxL3ZHZ05Fb0R2TERxNXI3OEVwWjZSTDhmOGl1NUVHbTNGbDdKNmIy?=
 =?utf-8?B?YzBxZnVKcGJzRTB0dEJNbTBrWmdBclVXMDc1bXUzZlExK0hnbTYxVVBRY3Uw?=
 =?utf-8?B?VEd3MXJDS2hIUjJjVC9paWtrUEhFWktZOWFQMkFqWmllTEFsME9OeXlnYzVk?=
 =?utf-8?B?aXpSRFRCd3h1clp1NlBkZWN4K2NnZzVVMWFpRXdkbUNBWnBjOTk2SWoxQ1V3?=
 =?utf-8?B?blRncVNOYXZxRUZ5Z3BndExKSmpKSEVjMCs0OURrM3pFelJUL0JMWXNLWmtr?=
 =?utf-8?B?dzZOU0dVejVCMUJLMVdBZUhMSk93Q1B1ZHlmS1Z5dUwvRXhQZzBJcjA5UVBR?=
 =?utf-8?B?S0hhaHdISHVHUVJrK0VzcFdNeFFwRWtRejg1Y3o1ZERBd0puOUhvNXZRUFIw?=
 =?utf-8?B?OGhkdUphWlhyaGlyMC9pYjlJd2UxSjBpN3VWOEZnbTZWU3pRWkVYbnI5Vmlm?=
 =?utf-8?B?VHRRNGdwRU9PdzNaZm9KelViU2lMNmF5NWpWWXUrYTVqTlNHZEpOclFjWTlX?=
 =?utf-8?B?dndiUlpJYUdzRy84OVIwTnk0cmZSY3lUYm5nTVVjbE9RQ29tcGNaM3FEOHVO?=
 =?utf-8?B?SGFCZlUrdnRscGUwUGg1c0F3a253Z2JYYi9jYlJtMUdOV05BNkZqbEFaZzdD?=
 =?utf-8?B?ZHpobnRGUm42bkN0QThSVTIrL0VNLzZacXZ5Qy96MGViZ0RoMWVST1RGMFp1?=
 =?utf-8?Q?xjeUlOyogEVZ1EQ8rDV0JZdY/VS8ysuT/irZuDX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjVmM0hhTXRUeUpsQzZLZjlRMFBwQlZKaHQ1UjdTckJyU1VWQitGQzVPWG5C?=
 =?utf-8?B?OTNEZUl3WjRYb1lqaVlsQkszZ3J2VmdFSXdFRUlKMnNNOWVPYi9NUk1rTzRX?=
 =?utf-8?B?TWVPUFZ3K2x0K2ZSbEhvZHBQdjJwZ0RtUzVvVWZZSHp2Z0tmSGNMekVvVUpw?=
 =?utf-8?B?a3hwaTY2a1cvQjFTQUpKMG43VUpVZkxpczNhYUs0ZE5lb0t0bGd5WEp6Sk5V?=
 =?utf-8?B?Q1pKWkVPQ055T1NtdFZzbi9TK0drZ21OOTFSUmhISzl6dVcvcUFFWWpSWmI2?=
 =?utf-8?B?WWhOMzNwWi9PUTl6VkFIcVBMcGVvODB6T1dwSjY2ZTI2Ny9xS2k1OFZSMjd5?=
 =?utf-8?B?TnRwc1pFTVZ3bDJXUm5pa04wb2xFNHo5VjBrbC91aDV0RkVXcWk1bGVjbk5o?=
 =?utf-8?B?NDlManJkME5YeTgxNDR5d01LOHV3T2c1LzJqank5NlNtNWxqTjBEUGFCbm5v?=
 =?utf-8?B?MldaQWloNXVZYUt0ZE1Hc1I1SkVITFdnSXNQdDZKTk9OMWpqbVgzMG4rKzhl?=
 =?utf-8?B?bWlnVzg1ZFI3Sys0Q1J3MUNBK0d3czl4eDM2RUJObU5zN0IvTHZaNmNwaUNI?=
 =?utf-8?B?ZmdIbDNKRjJCVW1NWFBEVDF1bVQ1OTJSZFV5LzBjTjd3czlRajRUTFo4NU9z?=
 =?utf-8?B?SUlqSnJlbStDNnpHYWZiRm9ONitjK1dYNmhFVzRLdEJZODlKbVRZOVpXUDlR?=
 =?utf-8?B?dmZUcFd1Q1dNWkFYRHM3cFk2SzNWNmxjNU1nSktTZ2R1Vys1WVkrRXQ2RENs?=
 =?utf-8?B?L2JrVzEyNm9WMi9UUnNSblN6b2JEdThrbkEyekJOM1lFUS81M0p3cVp6dnNF?=
 =?utf-8?B?RkFFUDN2ZmtmMlVrcjBBTjVoeXRqNmRla2R2ZmtEbi9yS0FSSmJIUHJUYVpM?=
 =?utf-8?B?YjRyTGt2THA0UGt6VGZQWHBucWl0bnRTYTBPY2NEaWJnd29ZUGtZOWVjTEZO?=
 =?utf-8?B?ejJ0amF2MjMyVnhEeXBPOGwySGZpcng5SExFWjJOcW9NckMyZyswTTZYRWlM?=
 =?utf-8?B?MEVGWVhIUHdkZVpnd2tldUFEc3VUY3dYZUIwRCtSalgvcGV1MGVaNFRla0hJ?=
 =?utf-8?B?NGpaaytoL09oMFNTKzg3cTN2M3ZyOERTQ05XdDFpUkZxc0I3bVFYYitmZVJQ?=
 =?utf-8?B?cURLMHBnOFhrTXcxdUZVSmQwQ0hoemJqVE8wYTNENTJiK285T3VzMWs4NVJz?=
 =?utf-8?B?VExHWERFVnJIMUp4cVlKaUdjalozTDBjY3BrS1h2NE1oL00vM2kvdkRaenJP?=
 =?utf-8?B?NmVmQjFDMkdHTEVuWmlIT3BiVHk3VHBaTUYxUWJ5UHhUcm8rWUdNd0o2QlBm?=
 =?utf-8?B?eGZkVjVXcXhYb3BFMWtBMVZaTXM0NFZUWmZqUUQvakNtMVFQbkt0OHh6NjhV?=
 =?utf-8?B?alFDWVhRMTFrN2QwczZEUHlNSzBGc0pCN2RXUVgvMmNGNTQzaTFMSi9NMkpL?=
 =?utf-8?B?YnV4VEdjd2d4azh4eVhsSjZUdEo3ZVphL3lLalVMdjMvUGlmbTR0UXVvSXlm?=
 =?utf-8?B?cDl2WlU1dTBZV3pubTUrbVNQdXFmODl6UFNzSldFWHJBUDFtM09YYkJrcFJU?=
 =?utf-8?B?UHJnT2FUdCt3WVZrOEhVQUhCd0k3THFnbXlneTArTXNGeHBSaTMxcFRZeHJP?=
 =?utf-8?B?SGtlMzNFWUVyT1ZPdGQzdzg0V3VvLyt6akl4cHV4aEZvUG1kTDJlRlpCZkdT?=
 =?utf-8?B?K29rNGxSZmYvcmRib3JZeDRyenJKbVJGbzlTVnFmdEE3aWtXaUs3WEdDVHpB?=
 =?utf-8?B?U3M4ZlJsdktQTUtxTFp0ckhNMnVVeDlGYXcyRzRVQ2pXVVNGNWFZWmIzVC94?=
 =?utf-8?B?Y3daUE5pZEVkd2VUenBaaTFQelF0VTM4RnZpdlNobnU0cjdKcWczUlNFdlh5?=
 =?utf-8?B?WjNLSFRRT2VVd2VOVmRxbHg3NnVDN0lVRFlpSnM4TEhkQTFlVFdJQjNxaExU?=
 =?utf-8?B?QjRxTHRLWlZhY1Y4bkM4QUgxNlNOQUlBcFlVNkVoZElQNFN1M2R5cTdqQnd5?=
 =?utf-8?B?TXRCR2IwQzBGUWhJWkQzajVRMlRqMWRCWitFelZuOEVEWHYvMmVyek1OaXRl?=
 =?utf-8?B?cm52QUxKT3p5NnF4SkpHYkVINjZkSnI5VkdGbjdMUzRDY1huNy9qVjhKakVq?=
 =?utf-8?B?dTMwckJEcytacjlOZVNpNDhtSnowcWxUTE1wbWxYTVlWUFpnTytZaWIxRTdy?=
 =?utf-8?Q?X4AzP/Lh7Ca10Ra2QtpAyXE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7RqsaGL1Jt+GqdW+0YKBm7OCxC4h/WceRG7pa/pKwzamfV3vEl/VLnyhyLxKz0MTQb0X2qdZHXHt1mxcSNAzleO4y6VVlH+yI7tqGToWaIjMEq4cWGQ1jhRF//8vyEjFHMvSEnjVik5JfnwS9fKn19IezECmp2jDCi+hCwI36yIuOwtcnPYTo8RuXaKMBa+UBkUUGhiAYRAhEADliPSyCbAZMpYqed1nk9xd584/rXFYM+PS0wZ2t0a28qgsgt3aO1HEKVm1HDMwi4SbJgOdcFpsgwA2O/hYtVBaLQXI4qPiZhXxS/MATpdDW6bD8mDp972ZeHwC7ijenLyibC3s7aqXwXqjrPWs8eugEdVqsbF21yI9gqEtNQz+M7M2D6LK+8kg3q0A9yjxsvC3B8p+OuPm4Q2vZ2+X6MnpA5I0WhsTFWEEdu7CzMONvW0U5f3XQI842bD/joZYtCaCSc8432NwuAf72rb6nxLwMKhoupNRS/z4+yCCpWJ2UFb3l0Anslht5e6Umw8CuO+iSh3uwuEJe7g+MXYbFGIfXC0x0P5Cb5yQiXjNNQnuq0ihRaTvSpoyf4Yh+3qC/3MlF5V8EHRQYfmjzgS8JDs5Kf/YyZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ec7dcb-d863-41e4-9cda-08dd00d82e65
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 16:04:25.1638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4A6CTWA84iQJs2DMHbjL4MumPACvIJmdMiVyTke5n0bhA5XZ4U97AFOOKKjfeb9UgEe5Hu0HS2PbGzS9nuWcesxf/RfGOy7HKANv+8gT3tJLLJuX5vQObRm/MsU9Dqzr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_15,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090138
X-Proofpoint-ORIG-GUID: Vbwy3Qz7gyCLRBrvnJcKD6N5aToF0J2b
X-Proofpoint-GUID: Vbwy3Qz7gyCLRBrvnJcKD6N5aToF0J2b

Hi Greg,

On 07/11/24 12:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.323 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

