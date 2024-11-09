Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8A019D892
	for <patches@lists.linux.dev>; Sat,  9 Nov 2024 16:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731168173; cv=fail; b=IGXddVx5L3kziMjHZSZ1gi498XyK9W3VzQ1miCgHpIsxf7IuRmvVXFI0ZNA5RnMAX4+ypJe5h8iu6IFIUNL4onnLSn5URLFaRZeqsHcEXphc+6S3YJ7MheJ+je1ZDfww/mo0Kby80cQJ82JC5lm6KdQI+5k21oSxOz+5Qy02bDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731168173; c=relaxed/simple;
	bh=dMk2t5EfmOZk8IaubFHhJRyUnLP16R9ClDeeRgtWG0E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rIMohemSPAgP1gRAZKWCt1fDzsxYN8QFq+tZgNavCtOM5ILuitMZfD3gZ1/4gjlhWB4nrhlSIzPQ2KwO2nS46EHE8Cn4a+DUgr2lxhbsbYE2OGw40BolkqlJm1N9D1+SsZPaNMaCAnAaKuhOSwcUgc4NhkD8Tqa1KdjGZUC/fVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lujEL87b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YBsXUdV+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lujEL87b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YBsXUdV+"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A95t1Ix003433;
	Sat, 9 Nov 2024 16:02:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=57tf8lGlP0AEJtT5oMj/NqKqh/R2nd2kw4nLMRXIMVQ=; b=
	lujEL87b6CUosV2LwHBxI0ycicSR6B1HhckIlPnjOxZPxYyt4Snj920jjbP4LSeW
	YI/mPgrcmEfmSAcGYa4fM/xD5j4Njy6/cq/tzqG2NgTY9tL/BFLmTb04SE1yftKK
	AnReDkyAkel5KiH22XI5/6xkuD15N2Km+oEsnrokwJXQzLUj5Yov5JEhPuHsd7js
	IINbvWHhoafMVnoviwN6nMz0JmTBc718Ql1fRMczcRaThPOh7LjKd9mKrSV+NO1k
	AznVsESBv6Uz2Idny5rdvGOttLrplHHMEOh0CjOF7eUnr/lNxEyJFFHIJA+viYNn
	iS1FrxJv1nBxui/rZP306A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k20bv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Nov 2024 16:02:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A9ELPwB037228;
	Sat, 9 Nov 2024 16:02:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65mpqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Nov 2024 16:02:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RNxw9XPdiYqtvMllGhn/nCsTIU02QAj5pfodoqieNCUSfLO9sBKSUw3bfemaDfD5MSjdnEPpKYMnhyASCYo69AFPXQ3P4XqIleZ2hBXJDKN2+jF47lHTeGcovPeZVM7u1bsQzlfca3MndsXdWiizqiG/AmP9lu3Hy7VzPZnm3nTYlCgMqExgW0ZS4tK6g6vZrintVs3cAMF2dvx0BzH2v31XRT8kkRVlB4HRs9oncuBiSQomzpVHIM0V3vkdej2fLBmcdHFfXVxdzlEtfwooC4rpmkHFLJLkWGtkkuFjWWlROav+6x5NJX5LJRyKot65skYqOszdtCoomUgZLQxXkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57tf8lGlP0AEJtT5oMj/NqKqh/R2nd2kw4nLMRXIMVQ=;
 b=CBjacmhtZLFBRzH9IUzOXlco46KeyYsHULnanfAs8CiN5UAq9frBMnhP+omn0y28EurYJ9yx3gYz+XZ6ITwuSlCMSJA2ct0jq9Dct74n7vWSzfuH2NHvDcw7HetCyFNBBOGRYfTDtxSoxy3nmz98fU2iiAmrYHOo0bJGN0rj/ZmdXgWM3MO/coFB0xzZ8HFPCXMW58jhMG37vDqP/78DVcfxdwj7EVIbafvagJOCPSIfROC3VIoAsvkbuLn/9AJORYCeEvgiJXwj2z3zvkqHd109uSbZeRI4P20kz6SHKTE4j/3jzeUTtaFV8MBeTsg/fd97hHbxDT6aBVF5X/Yzjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57tf8lGlP0AEJtT5oMj/NqKqh/R2nd2kw4nLMRXIMVQ=;
 b=YBsXUdV+0UjKVubDpcZSCpCPmPQu9lDuqlTZVCXp/SFyYEW0U4r0xD2OHMcP1gjNIpHrRAY58NDYPSsy41PZcUnCmb77iPqKskL/ONG7OoGwmF4YsY7mhkrp79Qoyqy7reXgWWKMRpVmtIt4CCeb6HvbRlRCayqGpYPKwHE96dg=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by BLAPR10MB5042.namprd10.prod.outlook.com (2603:10b6:208:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Sat, 9 Nov
 2024 16:02:37 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8137.022; Sat, 9 Nov 2024
 16:02:36 +0000
Message-ID: <0490b34a-47fc-4d52-b0b7-3d1405b27157@oracle.com>
Date: Sat, 9 Nov 2024 21:32:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/461] 5.4.285-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241107063341.146657755@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241107063341.146657755@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0219.apcprd06.prod.outlook.com
 (2603:1096:4:68::27) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|BLAPR10MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: 294d03e8-0303-4e61-f56d-08dd00d7edd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rk1nZGcvT2Q5UytUSVJQNXdFaVRzOWRxenFpdGZvaGZpNk9FN0NrRUNnQmVl?=
 =?utf-8?B?YXBUUUkyMzZCT25QWFpZeUdCaDF3M0lRczFlVEVNTnBMbHRoSW1aSnhUWnBn?=
 =?utf-8?B?WkRpWHE2TWZDNFdXYzM1R2lFOFNqQzZBU0g4M0h0emZKeWk1MVJ2SS9yRG1J?=
 =?utf-8?B?ZUZ6ZVl5N25Cbk5ySUZQdjhSU0I1blBFNmN6b2M5TUdCTDlxbERZcUs3M3lQ?=
 =?utf-8?B?czNiQjNhZlZ0WU1ZY01KdmlrWVU3RjR2RUIzM1k1aWc2SFk0RlpEVjQ2L043?=
 =?utf-8?B?MTlSL0FiT0dDZU9NdDhtenVrWUM4UEJTYmhtS1JOb3M1ZHprdkNRa1hHQmdG?=
 =?utf-8?B?YWpxTVRpNktGUTBHek9Jem9HMWIwaExXRHV2QmZUN050ZDNqaVBaUGdNWkFN?=
 =?utf-8?B?a0VFbGdDd2lhWkhWM0lrRWlWaUNsRjYxY2NPWWZGZkdtUUtHczJBNHpBUEpu?=
 =?utf-8?B?cktpVEtEV1FyWUR1bGZWVGkwZHZpa2JZbnFXOTU4UzZ5U3VLdUZ5QjUzMi9k?=
 =?utf-8?B?NWlweXllckp1enVHc09QSkxOSW13LzJUbUc5NExIa3FjNk9FVTdHejNFSkVs?=
 =?utf-8?B?L05ZOXRyZk9iNFVoNlB5RHdmdGVTUFgyU0JaMU8yK3ZUMktWdGU2eEY2Mi9k?=
 =?utf-8?B?cG85MXUwa2tFc0llcjNVRXpnZjg1ZHpzQmU3U2lIWmtYcTJSTHRpNElCWURG?=
 =?utf-8?B?WHppYk5IVVdCUExaNmh2aGNaVUl4MnhlTTBBNVBkbk1pSjBobjBHNnEyS0Ex?=
 =?utf-8?B?UnJpc0pPL25wbnh5TU0rWVo3dVVKTVhlL1V6bGN5U0M2bUNUSitBbVQ5cHlu?=
 =?utf-8?B?TytDTkppeVFyVE5RYk5uTEx1SHlIOGFIb2NmbXQrRDNBSnQyV1JEN2Q2TlFY?=
 =?utf-8?B?ZnRhV2hXVUM3Rk9TVmZ3Q0g2M2QxaE9ZcVVyMEtKcHJqdlJKTExZWGV4aGN3?=
 =?utf-8?B?MjhadDcwUU5VbUdVdTlkUThXdnVSUzdOTG8vNjBqZUJSTzJuSi9yM291ZnQ5?=
 =?utf-8?B?UnU1cS91eWc1T3ZpdngxRmcyWWh3K1FTRFppNG1GRU5oMllhNGxuSDlRL3g2?=
 =?utf-8?B?Y1VVN1FraGdrT2xnV1NIZWxvWURLbVczaTNBOFVaRmJEWnhGOVdXS0Y5eXVV?=
 =?utf-8?B?ZzFRdHN3R3ZJMGkvMnA5TXd5TUNPajNHYkxHYzViRTdoN3RIV3lKa0Z4WDAx?=
 =?utf-8?B?NUtxZ0ZzcXFoYnMwa3pSSUlMbjdZcElpU0NoRWw4SHQ2MUlTMENxMCtqL1A0?=
 =?utf-8?B?cktaMll2Z2lCZTJPTnJnb1Brd25wQmJ5SjdWaDU5WUZOWlBkd2hqNE5Nem1l?=
 =?utf-8?B?MEd1STJ4czNhMzVCY2hVNmROdERpa1NDSE1hYUxhTnN4TnVMZVJDQlpmeFM2?=
 =?utf-8?B?NmxpcDlUekpOaTFwZHVZb0FoUUY1VHU1VENTdndhSS90YzU0d3ZlYUhaK2x2?=
 =?utf-8?B?aW41dlhUU0EzRVhmREhCZGREKzFJeFd6T1VmU1dNUGs0R3prVjc0cXJqZmIv?=
 =?utf-8?B?Sk53UVVwcFkzMWVWYndRdllVNFJPenFHZXdnKy9GOEZTM004OWdZRkk3ZTZt?=
 =?utf-8?B?SzNYTE1oZzdxNWZJdHE4emdjclY0VzMzT0poeWQ0dkhmWXZUVjc2d2pHSC9V?=
 =?utf-8?B?ZUgzS0tVUVNWRnNvUmpRTk9XcWRsdmRYeW9UK2ZDRGNDb0hHRUNYWkRXRjUx?=
 =?utf-8?B?QjN0eHRwbkkxWU9Zd1hPdkcxdzY3c0x6MlV4S3gvNlJVQisxVk9JWTR2MitE?=
 =?utf-8?Q?9xX9vStOmrbOuudw2cZ8CDkVLiXD2eCFFaZ6PUy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3IzTGx2MDVkcHV2eUNrTFA4Wnp3OCtxY1VJU2tMV0RBTmRTRGxuRnM5MXdJ?=
 =?utf-8?B?Um8vUEZOWm00UFljRFBCeXV5TnBWWFM3aUNhZm1abWU2dGo2Y21qUWpGZk5O?=
 =?utf-8?B?dnJvYTVDUGN1NXMwT2pocTZXc1dObXk0SjdzTGxkVlZIUCtMaUpSOVpPRFpZ?=
 =?utf-8?B?eFlMQ1lnQit6L3RaM25mTVRvSkZZUEt0RStKWHFnV0dtK0dGU1YrZ2tXNUhU?=
 =?utf-8?B?SkNjcTc3M3A2MitudnVlVlVNZXhQb0lhZnJjQlFVWk9YRElEVWlSK25UMEdu?=
 =?utf-8?B?dmd3czhKOGphZUlkSmxMYmRHckE2YlN0bC9vNDkxMURSMG1SZzFpOFQ0dC9a?=
 =?utf-8?B?OFRHTTh3c3NBZ29YKzlDSjUwTjFtSlNjL1I1Tkd4OS9xZHc5SGw3OHc1VGpk?=
 =?utf-8?B?djJpV2szTHc1ZENKdDRpTUpkZ0pZS2UrNVBuL3ZmdXdmeDVhQzNKdmRJVkpJ?=
 =?utf-8?B?bkFLU2s0UUFiakc4TWFXNDFkdVdoNjdDWU9DbzRCZjRzUXJRU2xBTXQxYTho?=
 =?utf-8?B?ZjJyWkNNSlIzYldSVEJZT0lmNXRSdXoyOXpOTTVDREpvd0ZpNWE5RzRtMlNy?=
 =?utf-8?B?NjFMVnIzY2oxVzgwZjNnZTZ1SVFBR092NXQrdm15ZVZCdnJPRVlTd3V0WVF3?=
 =?utf-8?B?N3E2cWlsc0dYNlJ2bFh5MnkwSXBPVVAxUk42ajJLWTZvWjhzUm1WbmJISVhK?=
 =?utf-8?B?L24wMG96VTBIOU40T2pNUUpiRDhEcFkrU2FmZkh5amc1T1o4cDBhb2hWM3VX?=
 =?utf-8?B?SkE2b0RjaWJIeXdiN1VkYVJLT0tqWS9uRCttWk5XQ2czUkR3UU12Q2RtbnJv?=
 =?utf-8?B?NDRJeVliZG5kK2FiOGZRV0czUVFEU1hNNEdkTi9iMDBtT0prVjdoT3FyQmVU?=
 =?utf-8?B?Z3VFb2srTHFwTENOT0dhMXNQZjE1VjJML0E4THdrQzBHRXd1a2JONmlaR3Er?=
 =?utf-8?B?R251VW00KzZCN1NnbDFQQnQzWkxGYWZNZlVYSDNsSFFRNnVQUmdFb2tqeXFi?=
 =?utf-8?B?MW5DNTlDZVpQVzFNMUhqRXdEQ3lzbU8vNUM0U25uTDdYZldFblZGTGFKYzJu?=
 =?utf-8?B?NHZMZXY4Y252YWloRkR2VHlDbEVxRjRsd0tUY05WaFJ2bStYTjBaY0YrUm9R?=
 =?utf-8?B?Y1VzRmMvMXFCL3J6cmZ1SUdBNS9DbGhlSW90ZHNBUDliNzNuZWlYRW0xNnFK?=
 =?utf-8?B?OFc2L2tBVmNsL3U4c1UxNHArRW0wTFpjbE9DU3Q1UWdrTVArWmF5MXIwejR4?=
 =?utf-8?B?anRaSGY1RkNlT0dLWmVzcGJTaWkzcTErVjRORHBINHNKMUp1RmN3dWhZL2JL?=
 =?utf-8?B?b1g2ZW9peXhTU3ltcjlOUzhCWUJlUjNhOGNOU3pWYkdpWmE2WkRrNkhjVWRz?=
 =?utf-8?B?ZS96Nit4LzhMWDAxOXYzYjdqeGVxdjJGVFhWL1pidjc5MjdJR0pYQ3Y1MmJ4?=
 =?utf-8?B?OEd1dmkxVTNWQ2gyWXhYa0FnZVJ1eXhDeGhicDJTTnJaRTc5Mis1eDdDK0VC?=
 =?utf-8?B?YWlqL3dtWHd3cnpQdjZZODdiZXBHc0VkTnZiNWp5M1A0UUZ2VERGVzZIcjB4?=
 =?utf-8?B?cmdNS01nNWtuRUhjSkZ3UXFhSjJ0TWNlRnZPVUJiaGxscVJJcGVLdEJZTnNm?=
 =?utf-8?B?QVM1RGZTbXRkdVNldmw4ZUVEdll2cktiTjdMTnBScHhiMVgvYWszZERMUnZU?=
 =?utf-8?B?YlJFalZQckxlOHdDMDBxamVBbEE2RHZ1UUYwK05ZampMamwySE0xa3hhMm5k?=
 =?utf-8?B?c1lwWEtiOWdPMXB0Sm5qeWtMWUl3YVBJbS8rRzlwUEpwRDFQbjYzUzhka2dh?=
 =?utf-8?B?SmRnZDBVMmEyQTlSSGh4empnMzlaVHhoNW9GS3R0TWZpUEthSU1Yb3ZlRTZv?=
 =?utf-8?B?bDRySnZNa0R1N1pUa0kzWjg2UHY4NURrYTdZcFI0Y0lGdHFYeFhuZjVMVkg2?=
 =?utf-8?B?ZkdoZFBPRFpYeDVvOVdtMVdSRm5CS0VDZzZuZEVoZ3JJUEdhKzdXTVdEWkZV?=
 =?utf-8?B?b0pkU0Ztbkx1VW1mQnVBRGdXRkNoUjVRZi85dng1SldIU3VwR2t1TFIvenFj?=
 =?utf-8?B?Vitob0tNaW15WWQwdkxVVStMLzAzUWJOWlhPM2l4L2oxRUhVTGlPVEtIdFBh?=
 =?utf-8?B?NnM1aGJYRS85UXlCbjN0S212NS9OVEdzM1hiUXdjV3kxUE9kVjZHakxEakNV?=
 =?utf-8?Q?i/Xcv1sRaWxM3lAF8M5jAD8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4R3vj6KqaOiubhPzCPXfy+dFISk9+lga7HdzxJm2mc2Qq+OXt39tuA/OtqffgPTpDMgj4JBMEUeVeWiwEKUypJt5/b7Z3jzLVdhphO6YQTor5dT580F7Pm+DRL6SqkPY993mhqSS7Gh20rP6QUIj0h6gVpRTw5ayP5L2YLA73oUbQ45CDMujFRbUG3pJGOzcqUEBk/nS9YEf0YTtvO6UNEXk6HxeDYYRUXzxnOf6kjI/DyC/Yz8X8m54vFVMxG9c7hzfZazq7zoHNZR7Py25rxEIxG8DZnHZMuGHxu2laDf+GWBg64BsuSTf0YpTOWroixT9+5JajF8DhAR/O290Y13T/GizAqpj1/oFtFUhcj+vDnoPnNKQS7Nh//Fc6oD/Rw14flwJgFTVSYs5gFkB/PFX+E9N6MkVuScbhmjoP+yt+LhTkH790neQlwaQVykZZtZO4IX3GTCHjWIV6npRUSpXYYgBKLPnEGOJJmybJjy+0f2MKV4TPwecmibgrecT3pV29MgStlk5pcTVu6SHrbRb/PpYXQHuDyYmrPmqFVVv8929KAOTmE/fgpwwL2NlLp9J4iZ8m3rlhHQUsvEjla5ocNhpWEJa/EVjqUgXxkA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294d03e8-0303-4e61-f56d-08dd00d7edd2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 16:02:36.8313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/8qfaPglbhyW0TVpVwkhn4lAgwf2hKjEhaE8WohPCLUIyjDVH9XEllAES8hISpXt8gWlOdYSYWVJu3w8Y8G6bFOufBswEQtT75zT/7dYoedS+dL32Ggfw9sKecxbpZL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_15,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090137
X-Proofpoint-ORIG-GUID: 507BRGbq0ortqQFZK7PMTHbSXUGEGBWI
X-Proofpoint-GUID: 507BRGbq0ortqQFZK7PMTHbSXUGEGBWI

Hi Greg,

  07/11/24 12:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.285 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:32:59 +0000.
> Anything received after that time might be too late.

Our testing is too late this time, but we would like to let you know:

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


