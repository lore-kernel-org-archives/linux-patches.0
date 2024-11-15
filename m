Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297331BF37
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 16:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731686406; cv=fail; b=h92xO/nEbj4RVE9292ChldhZ+MREFed4EowAgVdACDq4If4aWGg6YZFJLKyaV+kp0Gr0A94BawMKXaIDVdkDIKmNDRQ5ZTgxncy6qJ6ARVEXFT3n/jOdtubaQyNsehfzGO1EScxI+qqDO5hQNPbAy9WLS2RK0TyyoML29fxlhZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731686406; c=relaxed/simple;
	bh=xQvKXQpYuXPd+FFYW8LKKtS/Rr76UuXQQad+ARH1SXI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TWDJtbJiORKNj10yv8VNJQAgr+tZmTvD/sgQAVp6Ozyki0lCwHK+F5jnkpsiXtcqgwY14Y1HuBhL5WXWaiYBb/voY3wTeov+wiFSSkAo8sZtxwrqb2ULx7DcuZRlu9UgOc8iu7yJxxSlgFIY9Er034KX7zimT8zEM+4TJXhLXmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DGlFSKrp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YktFNjTI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DGlFSKrp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YktFNjTI"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFDCUPj020935;
	Fri, 15 Nov 2024 15:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=efndscyMab3SYqOMBOOHFtmfiDNGOMXVH6BMcxGjMio=; b=
	DGlFSKrpJA0hS6wwv1VPWzN8BIu8kXDK/FuS1HB9rAo8X+HFadRH063Z1qEKwO6/
	3MdBXa1f7WbhT1sidIxRY/FVKkh1ypmTyKMsYQz4p1jvZr24MX+vc5EgSnP2rJ5B
	ejdIeUxd07a9CUWJMvhVvojObLM7NUj1I90b+52PRtalwi07pWB4L7H3NwdZ16eX
	bhIqC//1gmIM7U3S0cHQhvcYccVU1EV09qHRzqSagZxaRont3/2S/7h4ZDU1airx
	Yz4cLKLuffh2vwSSGfiq4zaNt7SJG85ZQ+yCf2hP4IPWpGuAH15bX29asLDxKPGq
	EIft6/VyMPLy8JyWU7Q4Vg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0kc3sd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 15:59:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFEp6O2000347;
	Fri, 15 Nov 2024 15:59:50 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42tbpbscdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 15:59:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DG1dSsoNPU1471DsmLHXoR70aGhS4FZgzVL3p9Vtn0tKOqHhmJCXkkKSvZofFwGYjyBuzopKj0a/2ZS8nXHRAZTN4PWr3+CAbXy7OhoNtw9x+5IDT26rBkSfgWGvPvVgwBjd0uoxl5JkYqz6TkLJdLxrXrMwJJ1UhLH69QkZpWLAKOWFihWz6WZ8itr5LRLn7WtZOaZvE0+X3W67ztRUO5dpKOskL28QYIevYW9UpXMF5ttMvkmY7vXBP+/uFlcpHWg5+Rix8hjQVYBueaOHgw50AiRsjo9XQpGW7A9tMFS3yDKmBNUjii5T0e3+026ewhGFHGZb9J4GufGDu6ZoyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=efndscyMab3SYqOMBOOHFtmfiDNGOMXVH6BMcxGjMio=;
 b=DV7NupJk5ZUi4W81p+C0VQc5PbKP8SdKRObn5bIQeMBpcAChJpoUb+W/0AwQHPG1czvDkP37RNATqExlZ7wCAUrGmyAOtzXJZ3s+Eo9A55V4HmO41kyZoeoL7SqDS2p6P0U7MGkJwTIx71++psIwr8o8kjYhas6sZSmOfzDMpDiYWB0FNVX825ZcUGf23YRZry5R1BXa10cio5nbpkg+Yd/aYRWlBHbxQPF3vguogv8xqX58zOoSCF4gR5ifuhgriwY7jJR5wDGa+nP/euA2Mb6vFr+BX2LeWACSx+rcfIVCrvPoPvmNHxDACXTuev8IhVfV1ci53NhUR5RNdyui3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efndscyMab3SYqOMBOOHFtmfiDNGOMXVH6BMcxGjMio=;
 b=YktFNjTI4TSjMgjp47J9Ro9PlMfNtvInL8HkCffawY+eCuUh9Ap6KHSNWYcrUgEXYW75btimSyGWhULvNG0BEpaq/Nu3m4f7Bf9Uq7qLjmoMmON5s4hVabAakHrMRmRBOYCxkpSlsE9rbygSdrdOzBVUfXdOcxYRvoUYCYlhnJI=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by DS0PR10MB6055.namprd10.prod.outlook.com (2603:10b6:8:cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 15:59:48 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 15:59:48 +0000
Message-ID: <7ff5f4fb-fb20-491c-98b1-a1d349e93183@oracle.com>
Date: Fri, 15 Nov 2024 21:29:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/48] 6.6.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241115063722.962047137@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::15) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|DS0PR10MB6055:EE_
X-MS-Office365-Filtering-Correlation-Id: bc52530c-af80-4326-1e30-08dd058e87c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NGhxQndicFA3TXBkRklZK041UzNleXpKcVc1eHVoeTBxNGdtWWh2cHBjK29l?=
 =?utf-8?B?SHVXbzNrUTExK1kvU2FuaHlBK1NJa2pOWGVNM09KZnVDbXRYNWRQRklhQTFQ?=
 =?utf-8?B?YzRwM1dIeVZZMlNXTXFBWEZGbCtvNm5OWWZKWXV0RlRVYmNqYVRTcnZlQjJD?=
 =?utf-8?B?MEVCSEFITGhrRlRKc1R2N2w1WHRocE93aGVPU2tacVM5VERDOG55TkRTbE9R?=
 =?utf-8?B?bng0WkFkM0FJVWk0SkhBamd6TVh1dDB6Wjg0clJnclFZczdJQTVOVnlrV3dC?=
 =?utf-8?B?SkEyVWpsc0VWL29sZ01CMEhtbVRKdEJWbWZhbHR2Zi84OGRHNUpCMEw4Q1NU?=
 =?utf-8?B?ZTVGaXJodUhHN0w3UUNadHBTcmd1MXdDSUw2c3QrbFQ5YUpjcWNCLzVvRFV0?=
 =?utf-8?B?NzBJZy9ja0g0aERMWHI0MXRUN0dMVWtVL21hQ2pWVFFZaUxmaG1IRVl5elFG?=
 =?utf-8?B?UnczcWRLcmFMMmU4WDVUdVJBNVlocmdweERHdm9oU21lSE4rZkRNSkxDYVlV?=
 =?utf-8?B?YlZzak1Fdml5aWZhMEN6MkpxdDBCcVBFbWcvYUxGYWFoRUs0TWRBOG13RG9V?=
 =?utf-8?B?U3k3dFNTam91cnMrd01ReVh4RVIzZURoUGM4cmVqaGkvYVUzYmNpNnRxd3VO?=
 =?utf-8?B?OVp1OXl0RXNUbTM2bWtLOHVFblRTUCtVNVVYbk1RRjdFSys2TSt2L3Z4TVMy?=
 =?utf-8?B?TnBmL3U5SEJhY3JOb2gwVkZZOHA4T3VKSVppemFKT2licXEyMHRPUWFKRHBM?=
 =?utf-8?B?a2xiVHFabWFuNjN4RWhDWjV4dWFST284VC96YTZZQ0RkT2laMEpKakNGb0Nk?=
 =?utf-8?B?VWV4cTlhbEJnRmNtamVlSWZiR2w3ME9wRFpRVjN4OFA0QWV4a2ZaeHFlUERz?=
 =?utf-8?B?NEhmVWthNmE2bTVtVUZKUk8wWitDUlA0M1g5USt3UWJDY3dGRzN1QStZN2kv?=
 =?utf-8?B?eFJxdGVwM0dObCtwMEZRMWpPVG4rNXllT3p2ZFdHRCtrakhCOUxYYzVidjc4?=
 =?utf-8?B?d1ZzUmhUSFgxSFAzb2o1dUZXQjZkREdEa0Z3OWdhWkIzU01JUG9GRldOcXQ0?=
 =?utf-8?B?b1NFYjVtRWgzbkVtY1liY1lzQXU2N1Blakc0UWVzY1ZYcURMckNsajBpYVFJ?=
 =?utf-8?B?WWwreUFrb1psNlpKWUVpWXZGcE9yeklNRWI1UGlEMGlJNWRzMXM4VFNvcHRG?=
 =?utf-8?B?YXpLSmEzVTA5a2RpdVp6N0wvZHQ1R1V6bm9YUGlOVWtCaUJyZjE2RUFXVmNs?=
 =?utf-8?B?cGdGK3JxT0svdVhQdWU1cHA3WHVpd2hRTWZkTUM1dG5OTis1OUJwTkhGRDZC?=
 =?utf-8?B?Wi8yYWxKL29FTFpWbWszWVdtaHRTTHhZQ05ZNXF5cXpJTnBYb3hvN0pVTG8r?=
 =?utf-8?B?U0dWb3o5ZS93ZENjYjBjZ3dKRmpPZGdWSVpjZFgwMktLYloyUEtTcEdJcDU4?=
 =?utf-8?B?OEtuMEJla0FnZ0R2TnFlUmdCc1VIYVY4eENibjkzenZ0aDJtREVFQmU3SFdZ?=
 =?utf-8?B?dHgvTUtlaGtEUU5WU0lxa013dlprWEhLNytWaUs2UjQxaEE0dmRLV0MveGh5?=
 =?utf-8?B?d3BUUFJEc3NHSkF6RGdPT09IMmJES1hZMTgvelBPNk5HNWRNL1AvZ280L2VE?=
 =?utf-8?B?K3FjTEw1dU96MHZTQ05CeDJxbStOSWgwQ1cvem1zVWtrRGZZM3hZV2dxc2p5?=
 =?utf-8?B?WFYvREZnOTNkNXVSN1VTckVJMHpjZ2Z0Rzc2RUxPOEdRTGRydXNHcHVZT09Q?=
 =?utf-8?Q?ntoJPW0h4XW7ai8Zd1IqZyAnnwBXHRNQD1R+073?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vm03aUhjdnlVZ213anIyUFFDeDhEWFlVTGJJNnpEeGdRL0hINDBCcXJkZHRo?=
 =?utf-8?B?QnNNMEs4N1hNOS9IaWZQMGVRL3JpeTZqSXd6c21sZ05GZjFXMjVWQnpFbTNr?=
 =?utf-8?B?VmVaWC9OdTA0TEtueHgrTTAzN2dQWmpVdzkrbTRuZVp1MFkyQVEyZStlMU5S?=
 =?utf-8?B?NmVCYTRrUnlScWlZRnh5Y3VydENkcHQ5d1p1dmdEYWFwMmtVNitLTFR2YU02?=
 =?utf-8?B?ZEIxMTdHYUE3dDNZd3FxbGdJejBQR2VENmJ5SjlRZHl3d2hyakJVL2VoV3V2?=
 =?utf-8?B?WWZBUitmNnZXWDdJZ1VVQmxySG53L1FTNHByMG81a3dyb0Jra0RubDF5K2lV?=
 =?utf-8?B?enNVQzRoc0JkRC9pck9PRlkzVFQzM3FNcFFONEFsb2ZqWDd5aHh6VGR4Y0NG?=
 =?utf-8?B?Zmdkc3V1cGFrUlozUmRDSEhFbG1HekgvZ28zZVJIRVp4SGhibWZQNER0REZh?=
 =?utf-8?B?QTIrUVBKZ0w5UVBjTTI0Y1hrVkp5VHByNytJNW5pRDhSRko3QUtaYVN5N056?=
 =?utf-8?B?SStLbW0vVlMxNXl5eHVIcEI5RVRxSWx3UG9vNWxnYVRvcUlxQWNLbVR0YzlS?=
 =?utf-8?B?VmRIV2UwcktsU2RzTUJ5WStVNUVIV08wd0VHTzQ0Tk9LOHdYZWlyeldVcGtZ?=
 =?utf-8?B?M3J2ZnNQTHFmVk1mMnpZcFhkaFRGU3FXQ2Y5cGNtRndmUHZDcmM2VWQvT3hy?=
 =?utf-8?B?dFZ6M2ZnQUlNZ0dUNEdjeFFPdjdTVW5CcDJkbGFrZDhlV3pzdURKS0pVbTZ3?=
 =?utf-8?B?d0VXaXNYcG5FbURoZnl0Z2JNblY0QWFPZi9jQnJOZ3g1Vkk1RlVqakgxYUxy?=
 =?utf-8?B?M1c3cW9QbzR4RGdjWFBFNjV3TkpNTmZCZEVUVkJBK2hJYm52N0NGcmNsMi9j?=
 =?utf-8?B?UkE4ZmE1cWt2QUppZ1JuMU9YS2FFdTAzREd4Vk1oZXEvek5BVGh2M3NjSC9z?=
 =?utf-8?B?bDJTM1BmajRWS2JxSExlRHdNT0VUSkIrN3d5WE1PcE9qVEFOQzAxYXBGS25s?=
 =?utf-8?B?TzhrYjlvZndqcFNXeVkybnZpaDFkdk9ia1lpYTdXTk8yRTlKeGpnZ3g4ZmNy?=
 =?utf-8?B?MFpCWDBaeVlPMkRjYTdqQU9TeVVYM2F0VUxUWURCQ1N6NG5RamhkU0RhR1FT?=
 =?utf-8?B?RW5jM2VjZVM5Zk5mLzA4K2Q2Q2RSZW5md3hJQjZLNFV5TjlTUkVPb3FWYzcx?=
 =?utf-8?B?UzlxRnVSb1RHck9MNjlOK21VVW11WU9Lcmpua1BqQ2VVN0xSK3JzdS80NW1y?=
 =?utf-8?B?ODErV3dqME92YW5JLzlwaFAyRWtlMkRSQ0ZPNjhKVGRYVWZMMjM5TG82VHov?=
 =?utf-8?B?aXdIL1NybXUyampFOHZRVTV0MEdRaVpuanY1cFRHZVBHTXFtZENsVEUyVzIx?=
 =?utf-8?B?ZEtKNDlmN2lKMmdHOGhQWUkvU0FjNWg1UjVJUTRTSDdPNWU0NGNDcWVVRWdQ?=
 =?utf-8?B?NU95NE5SZnlaNW5veFNNQW1CQ3lpa20wSk9YblkxL2orc2tJR1lBdFVkWk9y?=
 =?utf-8?B?WDlZaXVoT3hiOU9MWm1GY2FMZnZpSzFZSzBlY2c4dU5wMmJ0SnZxL3pLUU5B?=
 =?utf-8?B?RUYxcnY1enBINnJjY1BBTEU3RUc4MnBRVUdJR2pFUWRtazFZRkx5ZytpSkxo?=
 =?utf-8?B?akVLRmhKcEloL2xIN2dWM1IrcFRIMFNzS1JqTlVHU3lqUmxpcDFEYUs1SXRi?=
 =?utf-8?B?aFF6MmhrUkM1VzJyd2M1TVJpdU40WW1KckNJTStLVS9DWEFzQnVaTFcvamhM?=
 =?utf-8?B?Mi81Vy9uajJBLzJ0QmJzNVdSZStCWm1JTllpLyt2SUQwbHFDSldMVHh2OE0v?=
 =?utf-8?B?TDhsQjhwUXl4RXl2RGFJZnpWV3RTQU1tY3lWeXphL3VtQVhmSFdHMmN3R1dp?=
 =?utf-8?B?cHhZcGlmaElNTklDdm5tQVFnL2ZFUjNDM21NVVc4YXhCV1NCK1E1ams0MnBi?=
 =?utf-8?B?M0pvWjBSZFd2cVJUMVZhRDBCRGlBc1RCQkxmVWlxVFJyOTVsV1VOU0F6RC8v?=
 =?utf-8?B?eDU5MEJZeXNpdmU3ZVlSb0svQ1dkK2U5OWlMMlE4eUk5Vk9wTkk0cFRqSWZo?=
 =?utf-8?B?Y3BhZTRPbWlrQy9FRlVILzdpSFJwMlNmM1FPa3Q5Wm9JRXZDNDhmN2FBWjc1?=
 =?utf-8?B?T0lDY1lKNFJVaitQallsMmdCQ1U2c1lDTTl1eGhwWm5kVHhYcDVvTzgwSldU?=
 =?utf-8?Q?NtlRgng7PIAXCiiOOIwZYhw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I44ati+FLPIFkiux4Li45+fAU1DeWkyByWAw5V1fM8CFW4shdH+KnZ6mab9NsKPxoDGkEpagqbasKuRU3KQVDObp7mYfR44x0JOQMxrt9p5H1Ynzp6LGGZ1sF6sJKO6T8ZZHRSJ1Ah+bn9xi1Y29lZgt5/4loTEuPo5SI45JrHs5wWn8GAx49xJmuTr+CiUYvpFgz4lfTdts/8/2TAQmFcwSzX/QFaUhTbI9+vZkFFkNErFaxrrEZ+cRTTf7+n3FaZuhS447dcEoqLIMJVtkcmYvyS+9YQ7K6eILaP1Hgc8ecb7J8La638sDkJuFyJ3cE9ygmCJbUCeDHzfWLpqjVR5bLDMcTESKGHHPQt4rlI34aXxkByiWOVGmBBsjUTCcq00n1SGhM7rdmfQX0y5dTeQUDTifGtYzZ7Vz+FrDhMJu1PQEVhkhGW3wp9QkuAHsPjupVJMOEaEPIGA/EV4jAACwCTE+WeWlH0oM3EmwcIo5/WWATQsQ0yvxTHs0vRRVRhOm5kAop7kR9Yzp18PnOUaoln+NjqwIofEtcKgahWWvtlbo5T3KzVS707y1m3hWzYluiFdtCoWh3a9LKz95XLZLoDuALy5+pJ4FwsI0D2Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc52530c-af80-4326-1e30-08dd058e87c3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 15:59:48.1407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fC8QJAL1pOCjloKDSCNh3+jIANoTzP9/4gEVjkPz9/bhLZTpfneyrL7j4KGx7xbKdEAfksb9a53Pw1qir7S/e22KnLHmVGlOPyxxYnEVC9T6lQ4NcPACpIE/pAxf4RYn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-15_01,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411150134
X-Proofpoint-GUID: tPTcL2VTcpvl8nwNTRsiP4shqg9yJdoe
X-Proofpoint-ORIG-GUID: tPTcL2VTcpvl8nwNTRsiP4shqg9yJdoe

On 15/11/24 12:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.62 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.



No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
