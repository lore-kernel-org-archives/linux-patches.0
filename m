Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977B21C07EE
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 15:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731686390; cv=fail; b=VD+hNFoxYgNasPY1CgsFCd8PMLfv1SY6vo19CwAPSbSCH7ZiVuAG5O6HLxCUyNDwxC7wHTWAU5nQG52hq8M8QOEgo/HIgpwXzxNuW0skDm763oUNYT8sYURhwKL+8nArbiY+tg53to+Kn/UKKAmePVhS0bhqUkr/yRtvsY2F5iM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731686390; c=relaxed/simple;
	bh=wbv28shInCJnpMO/HCP9Ob2X6xUd9uhzQUJXtE/jzmA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KEJkGlJyy3bzGMey3q8I6v0fJMX8g5TMhC6sGC8lRy6QDT9YPUYdNsElPnBCw6tRHf2OZ8mbyvJ68Mi0s9y/pLZDYphaS6F+IZEXFLjlSVRKJ1TZKZjmHLRn6ctWjt0So2pUHPO/MLT1V6BCVk7pCY70HPKBzSGDin2o0gi1azo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QKL9D0OO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0T0XZO6l; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QKL9D0OO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0T0XZO6l"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFDCXXL021006;
	Fri, 15 Nov 2024 15:59:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=o9JCOnnE4U4ntnRt3y5PCSvjA8N0H7RtdHQJ9oiiS7U=; b=
	QKL9D0OOG4j42cHzLYDwNiUmRdzIzQZG3mXIGLPw7+kftF/0JBHIr0+QXhwuHIb2
	39rt91cejBQ2D96qiEXx7s6H3b6fv9cIcbd/U2izkiQ/EZQZyAd4chY8HQGJrEQ6
	x65ROwXD/XC86ziLSfOGMDFT9KSYiCjXJeu3JA/skBOhVPCHpB+XBdIx4TZknG79
	oaZqtdXg9QE2eoXIfEVg5JYt1+UnXuqQylXfHlS3bQJfJeChNVHpo5tbu1v9juzC
	52ga8KPguHNGJlxuxe3oLmcK7wT7NV6Tz+p1f6ugdq7x5gpd3mB9N3j38N5zeIhh
	nDdIfTFwV3z2fuMFG8qY2g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0kc3sc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 15:59:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFFAYY9022850;
	Fri, 15 Nov 2024 15:59:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2047.outbound.protection.outlook.com [104.47.70.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw2uh9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 15:59:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aH106A6B1Wp7mn12MCbJ7hXjvbw3tv8UcFIEKSOfAj+EjLSNzaFyoHpP8SjUPtnHpfuCl6XXdVXYl0QpuyOSy9zHSzGnmtFHqM0aXI4hKOhDBZckKNEN7xmoCKRxnvq1rmLHnFLO3xB8ZzYwRkN+Vstf60w9Z5TtYhyAan9PWBIhGZapvVrg1hBgK5Od7aGQcfCNjbGnl1QvVPvcEOfV9eoWQeSD8YYl1hR6bUh5Bq0WwQ96U9drqCcPF9ULK+xfJ+P6fC2sRIY9+CpsSp3pEdq8xTwgaJRrxill21CzFmwIpRCAxHbf32qnSjShGwYO/e5/PYXXybAhYTydin1n5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9JCOnnE4U4ntnRt3y5PCSvjA8N0H7RtdHQJ9oiiS7U=;
 b=L4hvNN6IyqRnc5aqwJgak1q1RKfNEEL/i2OTVeFxYzCi11S+1Z+S0Ty0d7nYSM/w5iMoJ+LzfePtdHIQ7AZTcCWk5fm6p1+A8O1WIKtf4FyZbiYBO10UT4sY4hPXfvdx9D1b1c9YQ86D6O/+17ND9s5vSICHAjMd7OqRdrE2yNXfVkxsv44iPD814kttXuIrthA1ZBLu/+vGfNh8jr2yXh7ubjQoFMvWkaBNRZ60cwk6/LitoSFwPzbv2hoj3xfnoWu9WTgPPc9yvAewze4rH08jVQfbYVKumWC9oeCBeCV7c4aikNNzyblC0d3Qe1pusKZK2r4fKQsyyLCeaDpozw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9JCOnnE4U4ntnRt3y5PCSvjA8N0H7RtdHQJ9oiiS7U=;
 b=0T0XZO6lAN4aflBUUxP1mJVvEfTuykmJ1tYdqVEB8ryHRSajzu6fgKSlSfSueJhfztfgkteLivpsmwGVGfz6JoQB5KSsv8pzWg3OeQ+/7lwVIP6LZ6sT+QgOUYLlwSQtd/LIJbLIDcOzBMhfQVj5EZkLUgL4GCx4S3TKnMVSLZQ=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by MW4PR10MB6439.namprd10.prod.outlook.com (2603:10b6:303:218::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 15:59:25 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 15:59:25 +0000
Message-ID: <3567bc07-3ae0-422f-bf42-913082bb0a4f@oracle.com>
Date: Fri, 15 Nov 2024 21:29:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/66] 5.4.286-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241115063722.834793938@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::11) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|MW4PR10MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ad4677-c5b3-419e-a2c8-08dd058e7a86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGtzQmFwSG1FWTZhQzdwWXRzV3FKQyt3eWV0aFZRS2ozTGZxZVpNYkkvNWZR?=
 =?utf-8?B?bDZlZUhwdnNNa3o4V1BZL0taV1ZYeGxGMTNFeW1iUlQyMmtUQ04vQmI2Wk1m?=
 =?utf-8?B?VktzN2QySFovbzB6TUp2Skd0YmZHa1d1ZmxnaTdaSHE1eGt2ZFRXMFJ4b3hI?=
 =?utf-8?B?WThmclNpallmNFEwU2pYd2VReWd0YUpOS3ZWQjRBenllbTJlU3NMNFo3U21W?=
 =?utf-8?B?VkhpTTNicXEzNXNsQU5BTlBQeGxUODdzYVdGRjZuRDJ1eFBBU0MrK1YrMG9T?=
 =?utf-8?B?VFg5VHgyQmpuNVl3aEJ5SWlBbFdEaXBvQktqUnpINEdzcFc3azk3TjZ6Yjl3?=
 =?utf-8?B?OEFhV1RwUnc1akNYMjdYalhLZldpTWNHdlhiMVdCTEpXUTBnZWFXdU4zYjFi?=
 =?utf-8?B?eTdlQXladTYzRllhMG92RTQxNHJ2emFsdGovTjFCRDZJbVBQYzROdHVjK0Z4?=
 =?utf-8?B?aWZjby9xMlJhL1FsVFNXd3ltYWJYcEhjdVVDUGIwNlRpOXpzakhRZVRVOFZm?=
 =?utf-8?B?bUU5dHY4a1pKSEZlYjZpbDJqS3FTUXhsUFYwK3d0VVRvV0ROenVIdVhWQVUw?=
 =?utf-8?B?OXVqVjJvUTZleU90RGc3d2NYR2ZqN2lZS3ZaUEJCRzJ4cVRSV1laRE9HbjJh?=
 =?utf-8?B?L1g5NmZVTzJVNzV4d01KSTg4d0ZsNkxLSFFUc1JQdmRibWhzNzQxS2ovMFNu?=
 =?utf-8?B?VkMvS0RXSUxqY0I2Q2liL0N3Z3cvOTNSTk1vMnNxdXNYbXRKREFDYnNxaGlw?=
 =?utf-8?B?cDE2TldhZCsxd3dFci9MUDlWSFg0WldJMmpzby8xcnA1ODlTVnFzN2tHNGcz?=
 =?utf-8?B?d1ZmR1BWRGtUU3JpTmVVSCsvU3NnTTJFTkdUb01FZ3dOSzFIK1ZLQ00vemhB?=
 =?utf-8?B?UnRHeUJvMmdNLytybDlab0pVQ2VEUE94VXZMemZpTFFFTkpZcW0rMWpCNXM2?=
 =?utf-8?B?bGdNZXJXSXQ5THdhQ0ZUWXRCYjVaZlRFVkRnNHltOWlkbnRJbzlxMmU2ZVg2?=
 =?utf-8?B?ckVWVDRrMEtPMC8yY1A5cEpPVmFsSVRjemRvZzdKdVo1OW96V3ZVVGY2UVNn?=
 =?utf-8?B?TytOd0V4d3hMNnY5dHJ3ekdjTHpEQkRla3dnRTBCazFuT2ZKb3pldmVmakZI?=
 =?utf-8?B?dFlPVjlSc1N1Sk1kblNxSTNRa2ZPalc5K0JZTDZmUVlQSXhRbWhvU0ZqU04r?=
 =?utf-8?B?ZDl0MHNEOW5IUXZYaVJtWWRiWjh0bkliQXJ3R3Q4S0JwTDhaQWFHblp4NmpS?=
 =?utf-8?B?OTdCTkFpOWFDZEJVRDJJdnE0UDZTY0o3d3o0R3p0bjBKYUFDQWZ2d3ZWam1F?=
 =?utf-8?B?L0dDVTE1Q09idC9GbWl5QmJZZDU2UGpqRUZtRis4RjloTXQySVR0NXB6NHZU?=
 =?utf-8?B?WGtnZzFIT2RPc3FVK1dERm1MREtPYXY3VDhwVzlBc21ydldQM2NCdnFvOEZN?=
 =?utf-8?B?NktGTEFPNmdBVmg3SndiZFhob1BZVXkvWWpVaHJ4OG5uVWg2dGtkNlgybU1D?=
 =?utf-8?B?OEMyZmxiTVJFZm9QcUtMWTF4bHRIS0pMejFaYWxTZ0VOTDNidVJTTkJvWTcx?=
 =?utf-8?B?VzI0a0pTQ1FFcllKelpkR0VqTngvWHUxTlRoMXpBYkZjUGRnSlhGTnBkeVZ2?=
 =?utf-8?B?T253S20wdGpTcnBwU1ZhVWoxT2JxL1JKbXZrZlpMREo5Nk54aXFjOTB3ZE5E?=
 =?utf-8?B?bHpQWHBYWDVvQlc4MENGb29aNFdqdEdhMSt1dWxHeWdZc0Y1aUVPMEJZWmhr?=
 =?utf-8?Q?Jwd4/ezOd503N5Hnt3xVn0cJeJAxZjbpnzM3skr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVE0Y0VtMEYwayszT1Mzenh1dHgvSmp1VTJGKzBqUFV4WitpYS8xRlBLd3Jv?=
 =?utf-8?B?Rmh5c3kveXpZdjV5Z1BGWm5zazNGZ1VTV1RUOGV4QklKdEZ0NmlNM3EzcDRU?=
 =?utf-8?B?MDhaUXRVZzJWTkNzVHN4YVFnSndQZVp6ZWNLbHNjNStOWWhSS25xV2ZWNisr?=
 =?utf-8?B?Nk5PRkVQQ1UvaDNGMnpEc0o1SHZ4N1dBTnlrQndBaEg2cDlZZmhoeFRoeW9v?=
 =?utf-8?B?RGxBejJQdHJ1b2RJV09GVTZrOTFIQjVvUlkxcUs2SzkwWXM3VUM5NVBvdzJR?=
 =?utf-8?B?MnJ1V1lrc1ZZVXBLdmN4eDdoNDlBZ0xzN1hHSkdSYmltZGdxTGpwelJjOFpH?=
 =?utf-8?B?cjI2Z0krR3UvQkduaEt3ejhUZk4yRW9yOVR2S3pBeVY0L1UrNlU3T2pzZmh4?=
 =?utf-8?B?YjhCSGR1bnlDSXFhRVZWbXlPVWVuU3NWRS9zcDFBTnlNOW5rUVRRUkxDaEh4?=
 =?utf-8?B?WEtMT2JWY1BoRC9mUjBoUG1ZUFEzNVFQd2gzaXdrL3NiTkdKZWt0bWh3cUQx?=
 =?utf-8?B?ZjIyelllSjZmTFp4Nk96Y2tBdUZ1OVcxLys0c3FaYnVmVUJqK0thOTI2ZVFu?=
 =?utf-8?B?bHV2WTE4WjR2cjNuZTlWOHI3TDRsYW9KR2RURzlIYWhyVEh3QTcrcWV1bXhC?=
 =?utf-8?B?eExKNjFydTlUYkFUbFZoNGF4WjNsby9hMmVOTkFaMmh1TjN6bmM4SUdTRzgr?=
 =?utf-8?B?S3F6MjA4VmhXcWZadjdzeWdrZXV3Wmc4TlJsWXY0ZzNSYUZaRU5zRGdPNUJI?=
 =?utf-8?B?YUdPZXZyYmpsQkpxY0VtVHNKbG5nN3pUKzUzNGdpQ3RpYjhpcmxUKzdsNlpS?=
 =?utf-8?B?dGk1b1lnSHFIVXhveXFKNG5oNE9tMXV2Q2lZZmZhSjRKeWVhQ1IwTXBsc0Ru?=
 =?utf-8?B?ZkVSaW54Rk1RK1B6d1hDKzF1Wlk5aGRhLzV5bjdLOTZKWFJVbDhTaUs2d0hs?=
 =?utf-8?B?V3B2K2dWQzI2QXN3eHFwL2YzeXh4MnFkZkZVdjJyVDVJSG1IWlovTWJBYko3?=
 =?utf-8?B?TDJocXMyOGxpaXR0ZG5qemtJYkxlNnpEQVdDcmYwakZIVTZlNitlRWZFeFpS?=
 =?utf-8?B?c3diNDNTSTJCajFyNGZoaTBUeHdCOWM4WFNzSlVwUXlsUXpzcFE1YVAvZURt?=
 =?utf-8?B?MWhZTzAxa0ZDdWZ4aFl0d1JSQXhyVSsvTndhWmoyaC9sWEZ0K3FySGlEUDdJ?=
 =?utf-8?B?eTZKTlBUV0RMVVpkV3hPWVlGN01Ndk5RckU4a21RYVp4SXl3RGtXbUVVRUx5?=
 =?utf-8?B?bVcxOG93aVhmQUh0QmlnSHZpTkx5cGsvRldmS2xZWC9HV1dodWg4U21DVXFJ?=
 =?utf-8?B?dUM5Q3JOWGdlSWFFM1RxOVJETkhOODNnMmJRcWRqUVhSRS9yVk5xU3M5RkFh?=
 =?utf-8?B?VkdrR0tLZlBMREtkdmg2b1cwQkI2Z3JNSVJzSmZMdG5sYnNTVytHZGcwa0tR?=
 =?utf-8?B?TVhZWlZZTGQwaW1BcnEvZVFIMWp0bnR3R2Eybi9mRklIdU5hQjJwemxjczM2?=
 =?utf-8?B?NkNybzlJVlRHN3UvMDl5N0s3TkN5eVdNWFBVcUtLN1Evb2pBdzhOcFVZdGdu?=
 =?utf-8?B?MUJ1OVRkT0lVM3RnczJhc01IYzEwOWQrN2J6SEFFTkVGQUFyODdNUGk5UFAx?=
 =?utf-8?B?MHhWek8wbnFYU2JGbjdXTEdOclF3SlZzdEpabEVpb3B0K0FoWmtaSXdwMnRr?=
 =?utf-8?B?eGg3M1IwenlPTnZDOThvOWNwSW5WSW44NzNaWkp2VFE5M0FpMEpuc0o2a3R2?=
 =?utf-8?B?WlZQaEptY05nWnU5Mm80blRLODhIaXQyV1Vaayt5anBzY3d0TENFY2YvbWUv?=
 =?utf-8?B?OU1ncCtzZG1PUmVvQ1l1dHdPUzYxN0pwYVRmMk1XRzNzTXFDTFJkenE4YUsr?=
 =?utf-8?B?em1ISy9VZUYzMnZtVEVGa0VqaWxqQUhxVy9wb2x4ZVA3TGVIYmhnSER1UjVK?=
 =?utf-8?B?WXIxcHkwUnlSQldnKzdzTU9iOHdpSEd1eXpSUCt6VXlabVRnN1B4WFNVOTBp?=
 =?utf-8?B?eUdFSkN4UnZXODlXb3BRTVBGN2JDdTB0TTZOdVpiYzhvVDJyUS9GcUo5QU9m?=
 =?utf-8?B?TWlDS3FUVEdzTlZCcEwybzNWUU5UYVBzVWZoTStTcGpEeWJWOGRIWHlYVld4?=
 =?utf-8?B?a2NTcGtEd08wNm5vL2RrZE1mQ2FoNEFpd3d5MU1LNXR1WFJwK0NxSFJJOFZ6?=
 =?utf-8?Q?2dUCJdLv73bzC9OhnAHNPFk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pO+I2h3iNuy/vVr6uoReotRsMrBHNN8gQJoLxjXzMD5hPMCbF8hyZNAOZ0s+NLFPPo52NEPWpAjN//+uh1W0zxv2/nToEnGu/whqT1Z2Niu+BUbadRNMnMimh23i9hQuaE28e+UDd/35gR2hHBXpySNOcRTImnKgYWQt6P3DHKqqQw0NJP0Aq/xjKq0rTRTiYk1gB9dhX5LdtQ8LIF2wYV4J4Du2Bc2052SiSiX4yqTdRlwGPs0yYMPx79027Qw4+ojkUbtqtN0XC7ilnGB1FD6VyYEhPXkvRqD0TfSWIf5EJigcPj9/AwvN6y14Jwrw3VYLq2dsQ/pkf6t+mFK+tMtsIAklmO+wMSE5dfQm32XJNbpDEbdyPBdAy2Oa427wfFk8e1DT+1+eFHiSFmobKJihmN851WdboRg4g4y/JxKpt7XtUKp9ViIWgS4hIggdDtkrDKnn5IAjVX5T8Mz5szYhm7HvateXzmD8bgRpYyhabEUPvTkXEWIPfzVR/6g6QS8huCjYQT9LO8ElebIv+IxJfg2JBShS0ycaC0HxZRB9mOcuhfjRnM+Bph+cJqy/u0qOU/6WtOBSDlf4TZdi62EbLyg4rEw4tF/Z7AuMtuU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ad4677-c5b3-419e-a2c8-08dd058e7a86
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 15:59:25.8954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ouoCOzL01i45dqyw3A4Cy91x/Wo7xHYrJw0KzYt1hIM5aKqhvGyKG7HTwsKP5w+luQpWEHHIlopkmLWeh9AeQ9GaOMFXWaKPnow6pfo/wQd4R57yfn6ZmnX700WOrnTl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-15_01,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411150134
X-Proofpoint-GUID: EUrsy-hEyX0WS12unH1isGoFA3BAGZUU
X-Proofpoint-ORIG-GUID: EUrsy-hEyX0WS12unH1isGoFA3BAGZUU

Hi Greg,

On 15/11/24 12:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.286 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
