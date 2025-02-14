Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC21621518D
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 07:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739519635; cv=fail; b=UeyrgwUJCuPQyIihL/8BuQyxwM5nNo9rykQ4TTFhbr8GvPXxqOwrpbqf6Yg6P6SKEyf2DYAi+WZojOny151wMk7J5n0fZVHgUEC+GHmS6l82AYb/g8++x41y2wiKyMZ12tbP2PTRsM1fp5Hi6L0CPQ3hn7b5JP1Frgw2/bxp6WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739519635; c=relaxed/simple;
	bh=bXkfLL8I/qAmxP1q2XFERL3iK+LDcBbgkaE1w2AJGzI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cw4De7xM5XW7GSs13qZNY4nPMvLJEInFfOmnZ+8N8ZgVCC1AoerZEjFaKGxHKRO6slrDHcyu6VYZDNWBM1vbAs03gQ9VPi7q8S50uRV69DLkBR+2i4wR4eieOLP+exz/iMn9kjHEVscPweYM/i0QFgSUteuDMqkKP+2SVi97moo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BpezDvzE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iTPwJvmG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BpezDvzE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iTPwJvmG"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51E7gNZF001457;
	Fri, 14 Feb 2025 07:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Mr6iaHuTTRuwmPfMo09ZC4VLYPMb2r/VPbqs9SIFBzM=; b=
	BpezDvzEIopxyLgFLV9KZq1tULsqYMYqTj0+mlG5pKFBUDwxPvkchDehT6ZMD/bb
	5JOj4aLs7oaBblmStPgXjQbRQC2Y9Cb41RwRNvGwVy0euBP5YR0Khzu6/HnoT4jP
	cyXByrnQ2LQ41wfJxb7QtnLw+l24Gzg+KDMkSxv2QIOM8wv3PIHDiSHpaLi4Dt6r
	iF6g506ngFLclaOS0D12aWm0l8AZxTEj8rz2FUCMYp1b1aPeyVNf4Vm0VTuljU5N
	NlefhqlDgF2cKvSNHiA5Pe+ATIrZP4uJAucWFMPlUCuLaZzqkHCXhmoZR3kR2aXz
	5i72nUXoI3YBISnz93eQfg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0q2k7rw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 07:53:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51E5intN001120;
	Fri, 14 Feb 2025 07:53:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44p6339hra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 07:53:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nPUBkcvmFSDbf6GARsYmQRVOkXnK0EWKLMuwsZbyctc5ox6jadvw7WblMQTxphS586X+JIzdtsa/L4x8dDCspDSQND522Xc3LfLGN8wkeMVP90JCN4egyMcIBUf/Qb3TUyhZBCIslatNULLJXobaQNu+kRcDNaFIjg+NgwdfZnGAvJub+xbnAn+WHjEu367A3JQrVBW1Kh8vW1boIvmIhbPI1AenSRlucGiEGcpOO84b4nMqxsLOB5ajeKls1Vc2nH49o/7L0hMziZW52sRFgJZdx9sOGf2TgqTm20o05b6/eacK88onWFritjNzRDM65ZLDJx6MfqHwTwnxirIymA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mr6iaHuTTRuwmPfMo09ZC4VLYPMb2r/VPbqs9SIFBzM=;
 b=Qrl39mRogl/x0MyLj04an0huk0KBUB2Ir41vLpnXTA4LQ8qz7aZXAuZsyAsmxq8G/XoJKu5T7qTE7FzRHLmnMaD9Cwd0XdYIAtttmp2VFKHEOzdZQudZg6a+LZaXBL39Pfn2wZLOKzRNIj36RjynV+mh3Qt/vyMA5Rzi9rzqxCNTVD906SY/6uV3JtF7NK8w6faYdgDInvsoRdy9DZ7etdrPltCRN3m47D84YjuAtCcBWX33jbv+Bs6IB+Z6Hn/jiJNrWyK21PW3IoDcXtLxsnIG6x6BuJc2LxkYLjBSs8VnX80UfHqLvnGwpweBT6sYmV0A94Twe6u1MYnjJNiqfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mr6iaHuTTRuwmPfMo09ZC4VLYPMb2r/VPbqs9SIFBzM=;
 b=iTPwJvmGdrSCA1AFUZUntnqAJIyAQgkWxKtt3b0ex2iytFJA8dlhotuTsZ5DSaiv6sDo6aa091I7WlmI/q+e5DFuXOHbpt1uF/gyM/B7hQO/eHgQAbTrPjZLBUTyo5mIgPgPuvYEDvowaaMHNTa1K+eCAkeNSCYRLn40aMdyNew=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ0PR10MB4512.namprd10.prod.outlook.com (2603:10b6:a03:2dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Fri, 14 Feb
 2025 07:53:35 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8445.015; Fri, 14 Feb 2025
 07:53:35 +0000
Message-ID: <c6c19838-dfa0-4e94-b7bd-1dd49449573b@oracle.com>
Date: Fri, 14 Feb 2025 13:23:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darrick Wong <darrick.wong@oracle.com>
References: <20250213142436.408121546@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0021.apcprd04.prod.outlook.com
 (2603:1096:820:e::8) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ0PR10MB4512:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b7dfa6d-cdc4-4ad2-8077-08dd4cccaec3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWhraDFkRy8wRUoxWkVlY281UUhLN0hOQ1A4VE5ZUmZIdlg0M0h2NEx3VzZT?=
 =?utf-8?B?Tm5SZnJ1elQxWXYxb2F5M3BaeFdaK09tRkFzbTg1R3BQck4xNG5QRU41djdB?=
 =?utf-8?B?cEdtTjN0bktjVmlmMnZvMXNScFZGaXRzVTNQemQxM3o2V0RxS2ZPS1hLQTA0?=
 =?utf-8?B?Z1BNT0dBandDUFhIOUVjWWU5T25rZ0xrNnJDSVdSVmIzdG1iQ3NONEdNVC80?=
 =?utf-8?B?Y3N2dnRvNWkwNjAzVU1HcWhibWwydVJGYUpXTUl4NzZ6L2tKRHE3SHlYLzhO?=
 =?utf-8?B?VkFDTnA1bmlIVjg0a053aGw4aS9sQXBHWEF2SFdxOTB4OEpIUnk3ZEZzV1JT?=
 =?utf-8?B?U0QyY0p5MXpkWWgyWnhuWXcwN1REQllUSHMwTTdRR3RvKy9KTm5oamIrNVNK?=
 =?utf-8?B?bTF3N2RZQzUvWU5kU2drbjllc1A3RjBrU0l5TTdmWlBNaG5LZFBXc05LRHMz?=
 =?utf-8?B?UHU5MWp0eVMyWmRyN3Mwd1ltTWNtbVpqNlQ4ZDEyd1MxT1JMeVVBenN2WXFD?=
 =?utf-8?B?c1BGOHpzNmh1NnNZZHp5S0c2QTFUd1RBME5vUzh2Vkp6N29qTXZ6bHJkdzRZ?=
 =?utf-8?B?cXFhWVMxbXNQdjRKOHlYeW85dEFHZ2puSTE1RHp3OE1Eb0pRUnNDQjFtYmFT?=
 =?utf-8?B?N2Vpcjh0QXQ0ZHdRbXRRclJxZEdRRFg1MmtxMFZDTzdMWjdvRTY3bGFBY2lz?=
 =?utf-8?B?d0M5RlIreEhkREZORHVweldZeEYxb3licFVQYUZLbnJ3enRma2dGZkZyRTFm?=
 =?utf-8?B?QXU0Y3piL3p1czMvSEVFdzA4YUl0akE3eGYwR2dHT1QxdlRRLzEwUGpQK01S?=
 =?utf-8?B?UzZhaG9hNzlDK1VxNk9IUzE4Tm5jQitlSllqQVpvMVA2clNkbktYWUYrRU02?=
 =?utf-8?B?cHI2R1B5MWxycVhtWGd6blZXc2NwT05yRmFNK2N2UjRBZ1BSMXBKcU5CcHdR?=
 =?utf-8?B?ZVo0VWFxVW9FTm1XUDBEZnpCV0FzV213WVFMY3BoZFhLZjJqQmdTOG1EMHJo?=
 =?utf-8?B?WjlBVjRoU0wxaXVOZnlKeTZxK3R4TldjTlpzUXZCUDY1M3ovcGhTeWNld0Nq?=
 =?utf-8?B?R1VIcFZzRWpDZDBCaFBCWktWczhPajFXWEFBMU1OUkdBV1pmclE1dHhnQmxa?=
 =?utf-8?B?UUswS1dZOWxBenZ4VUl0UWhWelBzcWFoZ3h1UmNTVEMrWWp4TGQzdlprdDNs?=
 =?utf-8?B?MTVkMDRGc3dJVnhiSTc0WUNGMHBXQzN6WmkzZHk5UGNUWGc0SnplcTU4RHJW?=
 =?utf-8?B?ZWtYWU5Ma201Sm1CalNwTndyTkQ3Zk9CR0dsTjA2cG41QWh2Szgya1ZUTHBw?=
 =?utf-8?B?eThqVHZib3BYOWkrajV4UVk2VDl3bG10eStmcmpjWGFIaWo1b3g3WFl2cjdN?=
 =?utf-8?B?bkdtU28yN1pocVpueExqZDJ4azhrOW5HT3NHZEZ6RER1ZEYzU292SUNNd05y?=
 =?utf-8?B?ZWxFR203eXJyMkRiVHhFRDRTWHc4UnFReXU0am12RXBQdDlzcU9zMDkzK2JQ?=
 =?utf-8?B?d1pueXdVTld3S0p4QnNibzREaHEvcW5lU3E4bkR0cUhkRVgrb2tORUozZ3ZJ?=
 =?utf-8?B?enFqMTZqMkFGOFhySUwrRnpjbWFKKzdZNzZrVUNPZFJYcG84dzY0N3Q0Uks0?=
 =?utf-8?B?KzNub2dLOEtpMDcvckdzeTEzUzczdkJBMmdBeldKSDVSMXh4K05hSFZ2dU00?=
 =?utf-8?B?UGFrL2xyZHBPNEcyeDRJRHVLYzhOVFg5emVFUXd2UURyTHBYeWtXVTVNMkdk?=
 =?utf-8?B?ckdQU1dtMGdIUnFpM0swOTNnSzFTcnp4dVR0empIOWRLcnRCNk5HSVF6S2xw?=
 =?utf-8?B?Q0hkVDFBQmx3NkZneTdvUHhIOGNQbjF5d3lhT2ZOQlFqQ21PMkM3UzU0OFhx?=
 =?utf-8?Q?VmjSNJITA6e2a?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0ltK1VHODA5U3J0bVdnWWtyZmQxYUpDYkhaUWlGOUYwdkh2MjVIUVRsUnN0?=
 =?utf-8?B?MWxVdlMwU3d2ZWdTVVhWYmlsSkhoSjI4akVUUTBuc3lEbXBrN2JSUFhlNnVy?=
 =?utf-8?B?QUlxUFRDMGYxR0RCMlBmZExaM2g3RXU5VXh4OW03bmdXakVpanpIZkRWWmlZ?=
 =?utf-8?B?RkVtVGhub2toT2w1UkhRSHI3WEE3RXBQZnBHbE5iWjJIQTNaUWgvd3cxc2xp?=
 =?utf-8?B?TGlES3BVZng1WEN5eGdtTm1xa2p1VWNtb2FVdEEwT0w3cGdWUlZHN2x6M3J0?=
 =?utf-8?B?Yng2Mi92T3QzTXdzODNFQTB1V0tkdExQc3dLSU0zNXhrZFB2VUFBQXlML3ph?=
 =?utf-8?B?Vk5BcGFRK0xlSkFoUEoxSVArdlNlTGxXek54ZXNta3F0NFlGNVViMlFnZStK?=
 =?utf-8?B?SG83aXRaWXBYTGZiKzBmc1Bvb1NXYWxpMFRGc2I3enJhQTRsc2VBZzVhdFJ3?=
 =?utf-8?B?WmFJUTJEYlZ1NU5JZFhqcDlNM29DbEpETTVtZ21JMWNtWEV5ZFh1SGthS3Bl?=
 =?utf-8?B?TFdBT3lLZ2lOK241OXJEODFpeWRnZjBFdWZ6eE9NY1dLcFJFS3BRb0p2SWZq?=
 =?utf-8?B?SmN1aitOcVE4b0tOTEdZL0VBOTVQNXBxVEIrVTE5dThVMEVwcmRwUEVnZGM0?=
 =?utf-8?B?QVB3ak1Sd2p6OE82YmxqakJaZlByK3h3R3k2RVZqTVhwYVhqKy9YWUNSUlVk?=
 =?utf-8?B?Q0ZRTzREMVdjQU9OdVRvTmZPcy9oQjdMRFZjRTF6eVdNd25zRjREb3J3TVZJ?=
 =?utf-8?B?Rk9GNTFoQnM2aUFCNWYvZWlnTkdxbjUvb1NIeDYyUDRRaXQ4NVhWZzErRFFF?=
 =?utf-8?B?eWVUQnZ6N0JvQ1lEMXlRaFk5S3V3UG5iS1NkYkdIajVlVlRKK3djZDcvSUNt?=
 =?utf-8?B?NVFvR2YweERUNFVESzZrMGxEUVdzK1dYZ1l3c0NkZVVTM1REc2JqeUhIQ3FC?=
 =?utf-8?B?cHFNOVM1cUZiL2pRUm53WXo0SXg1NVNHU0RscE1EcUIrazRadlVtZit0SWYv?=
 =?utf-8?B?VUZKN2dNYW9aay9VMGJwbUlTOGZjYk8weG1idmFpcUdFUVdmUWNtaitvaEQ5?=
 =?utf-8?B?eU9TcTJQVnU1RmFnSmI3R2tsbXFwV2lqQVRnVHZDaDRxQWlqbFBEMEl5a29F?=
 =?utf-8?B?aFRabTR2TndOMnNLSmFpMUdYdTdnYVBvaFFmTFBSajNuT2tmK2FpNHhQUkFn?=
 =?utf-8?B?QWE3ZDZrRjlLaTR2YWNSTFZGbWJTek1oRDF6aXpWQXUxZGh6em1JT0ZPVVhR?=
 =?utf-8?B?Rlg1SXRuLzdwYkhHRFlwNFRKSDcvUjZCdjdUQ3lvYUFkaTVyek9TVjdXK1hk?=
 =?utf-8?B?L0dXQjJhaDVneUZmWmRDYXMrS2p1R2ZMck9BVEZHdC9xdEVLOEVwOEYvV2JP?=
 =?utf-8?B?NW92b3c0T1NPNjMwU1A4d3RiSHNQdE1oNWx2dDU5TDNadDhQVVRIVUFia21J?=
 =?utf-8?B?dXRLOWhiT05KdkNBQ1hpM2pFZTBRYzBNL1l5eHI4Nitwdy8yVG8wSWF6UUYy?=
 =?utf-8?B?VzB3WlQvb3BkK2NCY2FsRm9lL1hxUFY1Wjg3a2JvVVg0WHRBajZxMExNQnFM?=
 =?utf-8?B?R3pCMkphS3pIM2F2SGJ4V0x1eDZhd2s4bHhVNC9VWE9sRitqOWp0UzZHNTFV?=
 =?utf-8?B?M1JLVzB2MmNJb3ZCbTVJOXFpaFFRZVA1ODJpM3FndGVwY001QnBiaWFSRnpw?=
 =?utf-8?B?bytTODdrL0xyek9iZDBaVm1qRUdzOHV2bUMvODVCWDRiOFlyUmtSV1Z3M2lG?=
 =?utf-8?B?c0dFODFqb0xBSy9tTS9HQWlyQUQwTVVFN2RQZ3pRSk9rYUNDM29VSUNZQXBp?=
 =?utf-8?B?Y29FOTB3dDR1dDMwVDBXRVdjbU1sbVpacHZtcENaeldKK2ZqZzVsOWZBaEk1?=
 =?utf-8?B?V25KMDdMcHZrdGpFZWR3dUpNTUFjLzBOd2lLbEdFUWFiRkZ2SkE1engwU2pF?=
 =?utf-8?B?SnVmUVByQWZBbTFRTFJQME9EMWgyTHRWYTJHNUJrMDJ4d2tpUGZnOHdKOTBm?=
 =?utf-8?B?VG5wMURxdUVKRXZNZUFURThYanRNczhxckZKdE5MNU8zT0ZaNFZKOFUyMW1w?=
 =?utf-8?B?OHByb0NhMUo3ZTk1WTNGa0hwRUtKZXEzdVJwNER0QzF0OUxkMytYMWMxVElU?=
 =?utf-8?B?QTZnVVYvVVA3cEhFUHRjYWFDeGVQREtrRXpTYy9iTS96UG54K1p3K0o4UHA5?=
 =?utf-8?Q?cviyYNskvxRb4pmN1NF9aaE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CBzreJx0lvocKZFLEBE2aUmBLph2E6yf1cDba/9Wpf5zvfWNuwsTEzlrBbWAMOKbDQiWTLxSsE8XMl0aZcd59yBMRu2m8kzef+ujgskktbtW8FGkyscEO5CaRSNyNuTZRDe1Jey+yVVTepam6iOOe2l2XpnXembkM0bGwBCb14n6SlOeAnqughjE/Sz/lk/2uoMFnM+FxVw2PaoHEk4ZzSp0BmqOrJes81DKU4gry5le4y6rAo6T93bXeXa03Zn3R82LcjYI/iLm8cJmc2b1RHtMCPo3RBrXReSlJmmdyHl/9+YJMc6jyjzhpJDawOn1JdVd1Ax6hM61jZPEI9Yk1aDiHMiQzi+MxPuAMAav12HQEbubqBJEl0tiuWzG4Hd0lx02lISOef+T7xpRRVDSGno9lIlNB0MU/+PXqANirH5tFJqJS9OV3OlxlZtCzfGkXpHBecwWkiDZ/yNXlhr400CWMj8ybgwuLvrwZEjKm5WDh4IuqnnCqCd/5XeVnr8n1vdi0CP9p5IErawXKX7vDbtzTwLj+5Iyb561d+xg2te95Fbp5LY2CaQnHRsVyKcFxJBuIEncVumqRBjUHP0gQZVg2GG985aBI8oMOL79ZZw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7dfa6d-cdc4-4ad2-8077-08dd4cccaec3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 07:53:34.9350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EE4rPwHC/Oja/8sPNaExC/Dq8Ug9A5idUFQ/rSFAKxtEDX6F3c6zBSQpUMWTRwV1176hlGAsIcOJoLmE7DPi4iTlJvCujHLw25stb+XuRVo1UD+WtxTd+ES4x5kTYsUk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4512
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_03,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=852 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502140059
X-Proofpoint-GUID: nfPP4I6Hcq3r9gTFLXq-b19oMeE8d6Yb
X-Proofpoint-ORIG-GUID: nfPP4I6Hcq3r9gTFLXq-b19oMeE8d6Yb

Hi,


On 13/02/25 19:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 422 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I see these build failures:

fs/xfs/xfs_trans.c: In function '__xfs_trans_commit':
fs/xfs/xfs_trans.c:843:40: error: macro "xfs_trans_apply_dquot_deltas" 
requires 2 arguments, but only 1 given
   843 |         xfs_trans_apply_dquot_deltas(tp);
       |                                        ^
In file included from fs/xfs/xfs_trans.c:15:
fs/xfs/xfs_quota.h:169:9: note: macro "xfs_trans_apply_dquot_deltas" 
defined here
   169 | #define xfs_trans_apply_dquot_deltas(tp, a)
       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/xfs/xfs_trans.c:843:9: error: 'xfs_trans_apply_dquot_deltas' 
undeclared (first use in this function); did you mean 
'xfs_trans_apply_sb_deltas'?
   843 |         xfs_trans_apply_dquot_deltas(tp);
       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
       |         xfs_trans_apply_sb_deltas
fs/xfs/xfs_trans.c:843:9: note: each undeclared identifier is reported 
only once for each function it appears in
make[4]: *** [scripts/Makefile.build:229: fs/xfs/xfs_trans.o] Error 1
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [scripts/Makefile.build:478: fs/xfs] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:478: fs] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** 
[/builddir/build/BUILD/kernel-6.12.14/linux-6.12.14-master.20250214.el9.rc1/Makefile:1937: 
.] Error 2
make: *** [Makefile:224: __sub-make] Error 2


This commit: 91717e464c593 ("xfs: don't lose solo dquot update 
transactions") in the 6.12.14-rc1 is causing this.



Thanks,
Harshit
