Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E822DE6F3
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 08:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756369613; cv=fail; b=qsllzKajrOPgZ4bvBzu54MzoTUvy73wElYx5hTb7IsNfjDscPBkw5nepJBCjuY3eZZde20Sh2VtRV5ZozyRwv+9XdoDW2IeVjn8YEBI30YpwyIAlXeYeUPKrfjjHJJ0x0iGWLwPJBCCAYclZ1Prg7dNitzTsCPR2HzckD24CaBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756369613; c=relaxed/simple;
	bh=s09iNgRI0wajNtTwgxzpdxfFztIkT0Ad1EvQI6jBbEQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZVhi6o+LyzUZl42dwEMCe0vZDYD+N3GgLZWptVEIH8gZw8oLP+8w4BgFGbSJUZpR9z+LgzHFu/3Q0cvpPdyfSwQE2xnvxyUQH+dljKRv9D3W9qJ+/dl69gZjOHKHuq4VmVRdJ7f123b3iF1jIh1RuSjz9NpAcVEVf1zRBN23BMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pkW51BDt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dXNUWQ9w; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pkW51BDt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dXNUWQ9w"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57S7uPVt020931;
	Thu, 28 Aug 2025 08:26:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xo2bVtFmzjB3WqxZctLxlVP1pFNELQI6PV6drtbm+tY=; b=
	pkW51BDtbU7ZUeRNvHh0471JLCtYkvl6dXvJNVu2VyIqZqhfJeGI/hhBGp+N952E
	mtnl0RM0jdQ+ABagWFji5/yDQyIHY7Q9YNk+Yz5byOREyVWUOETLHpfGQc0euYa3
	2+nORj/94ZqF6x+egq995sWPqm6XwWl4RPjdE1iVcZsZXH0rO8X8NbRTYSCB5DP7
	OlfSf3zvIE69epqwZPTNEQpG99TYV7efYfUROghY94ThgdTUQ46pgvNUtWsGsFJu
	o3CpWCSDNsaQiEKwTDrpUqvLUIA91BlqsHDZEEaXFkoYmTG/SZMt0KAl/mBNvMfS
	pBhyLFf00qzQyhd6S7DviA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jar1kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 08:26:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57S6rmvi005309;
	Thu, 28 Aug 2025 08:26:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8burw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 08:26:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GELJRdYBsKRI+kt1ON2KXrd5qItcr1sk/z0H7bykn++xLqYMjVIC7I3zzGLiq0wAogoPXDqMOVw3qVzyQZSQUNJCaQgo6bv3/GyQQuVpSflUbiLLCzDzhYbT68xz9I2acR3hAyy0kMvLG0JiikTO8l9FRwO1iJ/AgduLkIehFyMlfjxOorznmkI2IrkPwmK0DOW5RrNU/2+L3pqD9iuACvbHplRliXcZwqd4xzvsqABzFOt1RbV6v6C07G9kiEVsiaxB4s4hxYtNUqF14BhpkY4Wok70zDHFLAMnwMI83tNjQPT0lWcpTX0+2sqryamPS3gZhJQ7Y4aj8OTMsXzNRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xo2bVtFmzjB3WqxZctLxlVP1pFNELQI6PV6drtbm+tY=;
 b=rNccC4mjHAqEOrtObvtDmxSwe1iBlYh/slzemeUbFX2wsASRrgO+KN5e8Wa/A362phXJdMGJSefgASLQXVjRgg3jx4GgnkNR5j63zl3ksdKW4/Daxr3tokOx6fwuy+oq4p9noyV1CB8PevgukruqRL2IxcsoYSzjierYl5zJQWpFC1itDPsfZg3Q3+K8m06IaYt57AUP2ymWwzG7N+ShHSS58ya7hfD45wjLqJMOvbtcXLQzWaIrmYusKxKDTi59/rRCii0o0WlOJFCY5V3JgnYMAMHDzKqByQQLTtTlmAnNWJBe1R9zos/UAaOSnzaHnOp0ErELSKFPoqrKfQPaow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xo2bVtFmzjB3WqxZctLxlVP1pFNELQI6PV6drtbm+tY=;
 b=dXNUWQ9wwpuonNqJ2VjrctZzGnfyu/IDuOyS1ODzeTscDDNjVShWWXN/CmQEQ8l7rqMVYbyNjiznrHHk8OSWVbl+IQjKiicI2gwTgu863DwHl7HCYNKHtRVGJIMLztN7gOK5gBzdbL3XFZGsgv49s0BPmZOeoEoCV8JCpFPwsc0=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by SA1PR10MB5887.namprd10.prod.outlook.com (2603:10b6:806:23e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Thu, 28 Aug
 2025 08:26:21 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 08:26:20 +0000
Message-ID: <9b4c3742-f387-408b-995e-78b3eaa784f7@oracle.com>
Date: Thu, 28 Aug 2025 13:56:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/644] 5.15.190-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org
References: <20250826110946.507083938@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0089.namprd07.prod.outlook.com
 (2603:10b6:510:f::34) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|SA1PR10MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 71cf7f3a-a755-43f3-1fcc-08dde60c8f89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3pzQXhGRks3ZHVZbXplS1FCQUl2Qlc0NGZVTjZlN2E0NnkvbWRHL2FSZWpz?=
 =?utf-8?B?eXVaVEYveExCVFB2Tk5zNEhvb2JpL0tFVVFEdmNWSWhOMHd2cjVkU3oxZ3Fq?=
 =?utf-8?B?NHJ5aDNaTGNvL3FQR1lrY3pBQXhZc3ZKckt4WWNrNHJDU21ISnhOTDJWMlBw?=
 =?utf-8?B?THFBa2Qwa2N2M3dxVjRybVA0U3lHMGRmTnl1MDN5QXNMK1IwbjB0UXJJV1Nt?=
 =?utf-8?B?aTEwWDJSY0tHWnhZWFFTWXdGWk1IZXhibFZZSmh6WXhuSC92eHBNT3V3dEdB?=
 =?utf-8?B?K0pTc1ZHRmUxejRvYytsMTIvVUVkRGR4b0RvTkQrbkNFYkJsQVg4QzFLc0g1?=
 =?utf-8?B?cS9HajZNMWtzRXBrbVVHQ1JMaXFqb3FjcE9QY1ZkV2x2c3hpT2RyTC9EUk9I?=
 =?utf-8?B?ZTVYdnhubnBoUFJnb0UvSnRHZ2ppQisycGI0QXZadFRVcFJBYnBRQUEwaHVz?=
 =?utf-8?B?WjFkWG42WlZKZU45Y283WkJlSG9pUUdyZHNBUEt6a2pnZ3c3eEE5aHVRQk1a?=
 =?utf-8?B?WVY5R1BFa2lOMmZuTWVIQmVKdkVia0tsZ3lOM3Z6Nlo1ZlFvOGhvQUQ1VGFZ?=
 =?utf-8?B?Qm1CUVVidGtMaEZPTnlNb3psQmVpKzhCbWJnd3lWNEc5Qm1MTXNqd1FwTWsw?=
 =?utf-8?B?a1l4UjJERUVURmFqTE45ZTMxMk42YTNJNzAxd092YzVoYmpQT1J3WUFDNEQv?=
 =?utf-8?B?dnAzU054M3Znd1Z5K3BTN3pUWVQ2U1NpdWUvQ084MVcxRjdqRWxRM0tlcnVx?=
 =?utf-8?B?QWVLZiszbzhydldVUkdPSmhFdkxjTVJRaFY0ZjJyZm1Kakc3KytTRVVuaDNL?=
 =?utf-8?B?ZHpBMHZsSlBzUVVPN2xzY1piQ3lUNy9TLzlwcWRHWWtJNXNTMUVBcGpvYmk0?=
 =?utf-8?B?MklXdEI4dDBBNk9IUTVLMW1zOFBaWjZ1M01yZHNSNkIvTXV0RmFubVRNUWFi?=
 =?utf-8?B?aGdkTEFRS2dBM1ZtTnpsRG9wTmowZlBGdTZ5eTdDY0xoRTNKSWtmaGJIdmtW?=
 =?utf-8?B?V0xnTy8wYUFvTVdEZ0RYQlFpb2xYTXZGR3lWT2p4S0pMWWJZRVhXdjhOaHE4?=
 =?utf-8?B?UGhPM3gzK1B6ckp0bEVKaUFPL3EreHcwZ3ZsYVB1S2J0YjJ0dE14OXpwUURr?=
 =?utf-8?B?bGtidjdySzlrTisxYTJXTXlZRlVYN1FsNHJRT2tnWDJQZU9DLytsNkFHMVpP?=
 =?utf-8?B?WmZaMFJ0VUtjSFBIeFNVdXFqRXBFN1NGdTU2MUhVenE1U2tOTko1MjNyemFJ?=
 =?utf-8?B?UU5LbkVjdDZnMGxVQ0J2TTBvdUJ6ZXpsdjk1ZU5vSHJLaGtTNUlNZlY4OFRy?=
 =?utf-8?B?ajAzU1F2U0VRR29KZCtqLzl6aGQyWDZaRzAwUlorM2FCVjRtajlieElZS1Jw?=
 =?utf-8?B?QzlXZ0tsdWJaSUhBMSttMFVkcjJEYUd6WlNZb3ExRVk1SzlXS0xLdGdnRUp0?=
 =?utf-8?B?bkpYbHBtZ1craXgwaW02b2IzMS9HT3ZtTTlheENzZDh6cFFxVFdMTEIweng2?=
 =?utf-8?B?QWNNMUR4K0w3UVdtU2NiOWI4QzZsWHpjdkJxM0RzRHpWOG5YNWdxTTFkVmcy?=
 =?utf-8?B?T3NKdk02YmlER0t3RUJyU3Z6ZStGUTBLVU1vbHp3WnJKY1ExcDRud3o0NWJG?=
 =?utf-8?B?U0UvbFlRZitidDhIT2dZcnlyanRmWGRqdWxtMXE1MlBNb3BvQ0NZb2pkRHZG?=
 =?utf-8?B?MFBGdm1xV2RKTXdEb3ZGaXpjejBnSEpHMmJXZGdtejFWSUUxT240TXNkK3hm?=
 =?utf-8?B?ZWR6cWdCcC8wQU55OWF1blVMM1U2czRjeHlqZ3BTUFB6RUJTU296N3ZhVnIz?=
 =?utf-8?B?bER0MWovRGg4VGVOVWp6OWMyMmJVN2VEeDRmQkJKSVVxck82aERBN2t2U0RV?=
 =?utf-8?B?amIxTThFZUJmUGpPblZsZnQ1S3I1ZW0zaGpRTFFZYkM1MXdTZzdZRHEwLzJC?=
 =?utf-8?Q?hzK5zcuYYTQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1BRcWladExxcUNPNTRlT3FtbW9HYmpxczMyUlN0Ukx1a0Z6YjRKcDBENmcr?=
 =?utf-8?B?R29hKzArMEwzNjdrYkdXN0Zab09XWmVmS0ZXRUduSVZhdm5abnpvNys4RzFJ?=
 =?utf-8?B?d2hJOWlzMEFWam1IZDdIR2tQWnRmZkI2OUw3SmpTRTRLWkF2QTlybnRkd1Zq?=
 =?utf-8?B?akUyempvTHorejVhbUVneURBQ0JaRUkzSlR5L1lManZ2TkJ2L2p1TkI5L3My?=
 =?utf-8?B?OS81Tjh3ZUU4MDhJTXhMUFd1cTN4MVRhWHlnakZlQ2o0ZTJuckgzUTJ1bWxP?=
 =?utf-8?B?ZDMzM3VOczJUcXY1QmVvR1hTZmpxWlNzWUVDN2orNVNHN1NoLy9HTGtVRVc0?=
 =?utf-8?B?OVNQYmJBNGFoVGhkdmNJZktVN0FRUk10dnphZjF1d1Mxa0puOVpWNkY2NnRu?=
 =?utf-8?B?M256K2l5R1ZIR1ZvcjdFL1MzWGcydTFyVWtJOEpJSHRrWXlPWmozL0g5cDFQ?=
 =?utf-8?B?d2VUbmhwTE13Q1k0RklPRGE5bW9WNkg0QnlxVWF6ek9tQ1VhVW45MDR1TG9K?=
 =?utf-8?B?N2ZGcTlBSUJSZVhBMHNKaTUwR0s0dHZ1bkJrMGZNNlU1aHZWYlVMVnh6aElX?=
 =?utf-8?B?RjhQTXB3T0NHMXJiUGIyeEdxMlYwYjRaMUlSaVQyZGZyWUtKOG9SZU1mNjgw?=
 =?utf-8?B?NDlnNU9oYnpldUlkZE9QRlZHOFpVeUF0Sk5MbUltMHdGNzdQalJnTnZ4Nm1t?=
 =?utf-8?B?RnZUZE9LckZDQ0R0Ylh5UTBrYit0UHBOOHgxZWhZOVpCNDFDYzVPS3pVTDdj?=
 =?utf-8?B?ZG80T05zeGdtV3R4aEY4emNaSktkRnlYRmhBaUxuYUliRVl4TDVaZHltVHE1?=
 =?utf-8?B?dm5DR290YWt1UTNpOUlWeUtxZlhVa2pmVTlJQjRzcCtrb1ZsaHg5am9FY3Y5?=
 =?utf-8?B?SFY0Z2l0ZkRDZmpkaGxOSDJQenZkUHVJL25lNFNTUFlLMGZ6TDZ0dTJTcFJw?=
 =?utf-8?B?MDJHVExIWmtWTk94czFIV2I2Nmp4OGp4aW5mRFhHdllzS0dwc1Y3TkVwQjNZ?=
 =?utf-8?B?T2JZNTRFVEs5RzdsaTJvQXp6TFpRQlVvMjJaNEtRemdKWkRycmdOWW0vR3J6?=
 =?utf-8?B?VTNudWdqNFMwVXpBK1RqYWl1NGlKSHBUOERRVEtIRFFOS2VKVEY0d2JSNW1o?=
 =?utf-8?B?K2NCQ2JPMmVoWkYwL1hvd2g5cWVzWVlWemFlYmM1SmRGblVLTmFMbVhaRlRM?=
 =?utf-8?B?ZS96eFNaRzFMS1QvVHhqS2s5akVYREZzdWZIRlh1ZUJLNHhoL0xaVHB2d3gr?=
 =?utf-8?B?K2JBcllSbFhPbkgySGVSay9BVVdEZk9zanV1cVVmR25hK1VsZmhXNkZVdHQ0?=
 =?utf-8?B?MFloWllhZGM1ZkNFcWtHY0pUVS9HRkIrQ1ZUQ1N6NG92YThGTVovUFRVVU5m?=
 =?utf-8?B?QmxQTm1mQ2hPakVTc2VPZmpZTFVZY25hK2JUaVBjYkNndERSZzdDVVRYbmNP?=
 =?utf-8?B?eWxoblcxZ094WGtXQTFiVnVaRFpVU3o5dUJadkVORHlhcXUwZVc0YTZPM0Yy?=
 =?utf-8?B?bXFqT29MaDZETHFKc1BtQXQwUDFzb0VwUVhDWlh6R0t3YlVkL3pyQUJjNWZz?=
 =?utf-8?B?MysrVFhDVzQvdUxxQmNkMDgzOEs3dXdSZ3BrSktuTDBkN3VjdjgzVms1OEd6?=
 =?utf-8?B?bENVL3ZlWlQ5emlpRi9IbFJwZndVSy9rOXBVTFVHZkNzOUp4M0owVTFaOE45?=
 =?utf-8?B?TFI4RGMwalI2c1YzckJlQlgwT2xNcFk2L2ZwaEQrMGczM2pGZ01PRWxuOElv?=
 =?utf-8?B?cXMrbi9QNHBwbHQ4eDZONFdSTnMrd1JWYU1YT3NRbGJRT3RxNTNUZnU2RVhz?=
 =?utf-8?B?eDQwalFnYkJOa1pyVTdoWm0vL2VZcUd3VVpuNDljYkFLZGVsVzJiSUlERnZq?=
 =?utf-8?B?eWVTbFZ5a1VpQUFiQTRRUDJ5WWVKc0FnYWRQNUVoVWpQSkpHMHVSV3NoRnBz?=
 =?utf-8?B?blhNa1ArelUxbFhvNDdHUTRISStGZkYwOVdPcVZFYkxwSlRMaDJ4SGtzdEto?=
 =?utf-8?B?SG95MlRPUVdXNkhjcHp0NmphTFlxdFN0QTRRMkxXV2hDN0tqS1BaTjFaRHhO?=
 =?utf-8?B?VFc0bWY2V0VSQmh6ODUwRGxJNVV4WC9mWC8ycHZNS3Fpa0swdllkYzNSNzAw?=
 =?utf-8?B?aTdlb1kydmhaaVhtdnJqTDRUSGViVDBaK25xWDQ5S0lBR0JuOG5MbHduZFJX?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yOQ+ra7giuc0ixGCqyhHYVkTjxPC4CvGHiTdtvHhLmpqBCe7kdDgFo+1WSo+jZgGf3f+3hSBhUo0rZWmdwAe1NhUok6h/FTKqwEvkB14U7asx2x9zyxb6R6tnw8q49Pr1bsNHHyiF5mk/a/mxyrN6UWkAnJjaRSjBakiiiHmdr++18nIrT/gnsvr1p9ELHPfHBDeV+YkF1xnKukRbb7yDi0nf538En1KwIJ45q0+y1NKPE4K85RyyssEV2JM9qzVRZaGyqQLq2WVDouETApPG+kQwB8uyUwD2bAFxoMQHguITczjAXR80R/iUy0b6/hvPPZixZnFZQO7X8gQZQHAtl3g0Swb1SlwRam7A2+ARD6fIANNbDIN6QXh0vzb5MiBD31L0NUh9P7ZobA+MWjMWTrtUHPQ86+ebfEgk5vNhyOB7reAw/FQmdIwjrqvbE5yGJafLK+IcBMHGPGIjEGolsvpkogqcJTX91aKT+MvVwifrMaUUc8O1BXBPVJbHdjoZS3r5PH9fMOs//uBTDe1ah8+9NObLO8/8Hx8ZbLN8jpOSktXPLdKWgijwMx9eSJDUE7Iw41wvFqdr6d66nT+H781R7V8U3VWsaSZJ+JsG4U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71cf7f3a-a755-43f3-1fcc-08dde60c8f89
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 08:26:20.6845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNdREeh55LRNR3jyOqw6kxNfELnwRENP+b5VSYeXOhXLw8m0vLBl/5/2FgYa1JXaRZbOBDwICMToHEYgdOrHJ/O8XBH90HF4fHkn4sFwfCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX4sBadoIV2sJM
 Eh4TSRKNH8Lfsfwr9G93DNnNJrVEanwSEb2+WQmnjyhb1mGPwUQGSsazS9PE6DQHxx1/gp9WGey
 xkuV+UX0iU+/WxNFdJxyq0OTEUw02gh5Kn4CaVScuwl4tjRxbc3NyX8DFqTtjGU9daH8CDvNXKs
 4ZM4kZhGtXGaxWfWdPbbWnG/qTvl4us/QskqWnxf9JJ3b/T736XhMhCRbex6Cgz/yDLTpM7CaIt
 6qbKabiO4coLCqrj+tmCNSgzOAfnZqry7Bxx4qRLb6r4RsNSNElTOQoFANyHijsAUK5hFvg0DX5
 wna+mbaE4YAeBpo2Dy95vJ6ZqWQ7RAHWZqWp1Z2OE1ixN2tfY6BTweXol/l5y+RoNF9FWUjKmO5
 to+wGU7T3M7rlQdQRy6CB0K1VpRGCg==
X-Proofpoint-GUID: _v932mSOQ8k-mawaHxvjF-A9Sr57tZu3
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b012b1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=LA0ryxVzlY9gRhvUUasA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12068
X-Proofpoint-ORIG-GUID: _v932mSOQ8k-mawaHxvjF-A9Sr57tZu3



On 26/08/25 4:31 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.190 release.
> There are 644 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.190-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>>
> thanks,
> 
> greg k-h

