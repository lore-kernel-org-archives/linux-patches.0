Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62B2185084
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720027785; cv=fail; b=H2cylrQP6fEEz1RhfgJkp420UGe5UoE3NtNhJ+Fq0tOPvcfKonqtuAfQ6TB3kP9leI4QK8Sg1GesoSGqcfEP7sWGbkqVXMfDG6RXH9YHR48t7D/lNiJ7nZpS9TvU8MYdU7qSfvtQ3d8M89dqqTtB9H3z8XW97funliQyZocbwt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720027785; c=relaxed/simple;
	bh=qBA8H95kWi23s1ZL5olMDbCTte/8uhM2xeLhEjjJkEo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BsR9vG3WICcQLoIluI0a8S9oBLYUrXwdGuIzbMBGd+WQ3iCWPUZbEgbnntmGM72v3UEFMdmyRC0MohRjltPh8B7pq/fX5jQmuLwVUZ2vdmO8ph9RFtC/qdszvkgqcp3cpTTXg3Do34tbgYRI3yq4PJxdSTXgfHbBDToVVY7Ps0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VFxR8Bfx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zq+Yz2AZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VFxR8Bfx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zq+Yz2AZ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 463FMYF8005093;
	Wed, 3 Jul 2024 17:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=UPJVs8gFpgnaRZntcqHVzjYMfzjjVR5Q+0/MNkZs9Ro=; b=
	VFxR8BfxOrabjC2YH02YjFIyvNDzkDjoGtY5EWdAWNTj/3rEGbkO3KEqAuO9xSXU
	DhkmP0QoTBOT1zFacdysx2lXi+2ijQJ0zu4xORAdCpzTM6xfxP5q0wDpEKJHroku
	BUd04UWtJuEtc2fBIxJmnuVAqQh+nIQIB4eoBSzEpHlaNzIl9Z0HTYeCjvRh3JzU
	ZlR6y0DSzJ37wQOUjeAoX2YegDX8Qehp0JTGgqhQ8wMsWX9CySecS4pvpSEipUqr
	nXL4YQYwLnJDnMQA/8+t9A4bzJJxuk/MasUbucC1NIsFoQuY4N7f86tYoO1+RHWp
	D11pHXKAY9AMEwoZX6wUGw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40296b0re7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 17:29:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 463HLAWL024738;
	Wed, 3 Jul 2024 17:29:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028q9twxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 17:29:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqaAXxhCAm4ijhKyRs0RLnguyhmshAO9SuzYyoJoHyDhLzPFo14F/3CUHt+cjFyYyDnDhDldu9IpMBYYsbnKdrADSStCgFKEd7QTHoPeDZZwmS0o1aWtp3q4CNNrR7/ckp9ZD/CIiUE5bt9XoQJbqYknIuKbb2rTHZmBIvl14nQlVP7/NBXc3krwOTsRk+9XKS/ct8X/8Zdqey9c3oTEollObT0gJkwDJvU1foA+RtY2qxmrWBNV8YFFPyIZYRoqMNMdt3X0/KGru3GBYyHznlouTiFoZcFNx/qCOGuGNwlPyG8bCz+4dLNmZzdEKG+T/1UYdCkuUrOhajpHAkRKhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPJVs8gFpgnaRZntcqHVzjYMfzjjVR5Q+0/MNkZs9Ro=;
 b=mZTry7Bj/qdllOhh/klS9nmPYgnue+rvN3HblYdSn3uZpeahg8o5tzxTIshIYgfCRuTWT9yRabCXl/m+TpnNqnHqONhmnzG5LIdetaZ01bltVJ47GM0Tv7bw1C9Y5x3AW4cX2dd+1Y2NJUI//jMTDi2BJ4nN6F4zFZ5jcMNW8BpWamJVjVo0n21dgFY2/cO2N127XJBB/V3w0fqo2wiOdDgtSSMShFc4THgkztp6ZQfkHI4abP1oJyciFix9wpen7LuMR7qriNZuZEJIwSj5y0I+Ex260Qe4PihOIbryhTgJqTN8tzuGOJrXAGudhWijGVPwqwhG40mzJCMSqApHkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPJVs8gFpgnaRZntcqHVzjYMfzjjVR5Q+0/MNkZs9Ro=;
 b=zq+Yz2AZNbKX1evHfTZ5nPyDMpxYAmGsnTheHpBMumd5DtqS8yu6sC2SEJi1dektxxaqSEBFNOSgOzBdoBiprk/Tr5p0dYShNswO1sPneeYmTq4ezwXMT855b+DGJgUiMKpYRFvlMlM8cg+4sgZbRwEfykBVz2y0pU8n9lHeHTc=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH0PR10MB7006.namprd10.prod.outlook.com (2603:10b6:510:285::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33; Wed, 3 Jul
 2024 17:29:28 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7698.025; Wed, 3 Jul 2024
 17:29:28 +0000
Message-ID: <1d5b5888-d9de-481c-9473-292f5ab2b0f2@oracle.com>
Date: Wed, 3 Jul 2024 22:59:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240702170233.048122282@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0160.apcprd04.prod.outlook.com (2603:1096:4::22)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH0PR10MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: 8441657c-0f38-4b02-fb96-08dc9b85b100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?bk8wVlRBRVpIOXhrZG9pbDdmTzJRRE85WFNhL0hmVkZGV1BLWG9JMzlyaWV4?=
 =?utf-8?B?ZWZWTWVxWFN4eDBaVk1RdlkxYjFpdXpiRkhkVFBkRHBidWFJeGFqWDVVd29B?=
 =?utf-8?B?RXhJY1Vickk0YVpKd1RMNW1NZ2oyS0NxUHZhR09CaXBGYnFTbERnaHVCZUpj?=
 =?utf-8?B?Skovd09tYmp5Rnptb0x1NU9lZndIQWc1c1BCV3g1ajZLK0p4MTA5bHFiZGR5?=
 =?utf-8?B?b3R1Yk8rV0wwei9mN21IUDJjMnNzNEJTS2djVmlibExyajEzaWRNUmFHTXNF?=
 =?utf-8?B?Y1ZxUW8yL0pUV2M0Z0lsMDNYeEdXZ0FQWHIzM1V3c1lKWHloWXcvOEYvVmJo?=
 =?utf-8?B?ZGs2UkdyRkJjOFN6d2NkdWRSK3QzWlNNYXA2d0pBM1l0bnFZRkVjcUZoWkFz?=
 =?utf-8?B?WW5OeDhqQkU0dlBPUHFiR0dRSjBLK013ZXZUVWp0bDAza1UydnBubVUxNktS?=
 =?utf-8?B?WnBOKzNLVXBoVGNyT1VSUGc3dVlVZ0l1eXpxdmw2Z3duUmNsd2dobjNBZ2xj?=
 =?utf-8?B?N1lCWVM2VHdVTGJCZW9RUmpXSFEzQndmUHh5NHBoYWhLWmM1MFQrd29LQ1d0?=
 =?utf-8?B?Yjh5bTNEN2t3UjRTbzdIbDQwQjhhWEJ2VmxLWUxHL2NodTh2ZkNLa1F3ZjF0?=
 =?utf-8?B?a1BadDJFdWdWREgxQmxMOHR0clNwUVhDVmNSTmVOeVczUm9lNks0bTlNM013?=
 =?utf-8?B?bElMTVJPKzNkOFlqNjE4MDB1em5BRkJ5NzJLZVFSTDNUeWx1b1Q0YmdXOEVJ?=
 =?utf-8?B?SHF6bmVWczNVRXJWTXRZZDlaejhzOGhGRitZVGZhTHdqSGVJT2NZb1AvazFE?=
 =?utf-8?B?RE0zRno4Z3I4Vk13UUw4T1BTQ3YyVVJRb0RpRm00WE1LWlRsZWo1R2dUa3pI?=
 =?utf-8?B?ckhkU3VFSFl6aHpQcGYvY0xhaUR0T3ZRaVgxSWNSZTZ1VTNkQXFyakdNNW1B?=
 =?utf-8?B?ZDlXVUx3Snc4Y3FleE1iUVpXcTFZanhCUmgyYkl3ekNsNzJFaVJZODVQOFQr?=
 =?utf-8?B?RGVXUXdiNkFHNnJHM1ZES20zSVp2UTl0S1FxckRlY0VEdThaR09wWm9QOTQ4?=
 =?utf-8?B?aFVsOXpWT05zeFp1NHppTGlFOHcyVDNGYXZlc3p0MWN3bndiLzY1TlM0bG5m?=
 =?utf-8?B?WklnVkdQNjBaTlQva2hFeUlUb2RCSmRmcW9OajU2U2M2T1JsYTQzUGNHWDM1?=
 =?utf-8?B?ZTF0QmRGdnl3U2VoeCt5YmdUeEJJMXJ2Wm5BZVA4SXNBS1dkWGJNalk2aG16?=
 =?utf-8?B?Zys1bFI3VVRXVGJBb1FGYVRyajVqQ0xOVUVTbnNMZi9hZE1NdVQvWGQ3YW1H?=
 =?utf-8?B?b2drNWRFMGVwbG5DTWVxbDV0UVRFa2lKZ2ZUZVNzcmhDMlEraU1rbWhDV05o?=
 =?utf-8?B?TXNnT01Nc0Y4N0VYS3B1dlFWaitLMU9yOEhwK0hoZU5SY29kc2lnOWVzSnFq?=
 =?utf-8?B?YWVEeUlsMERaZmhGOFhsUjlvTVk3YWlSV3RJcU1TVUJUbVNnUDRlVHljSG9P?=
 =?utf-8?B?ZndmQ2dvYkMrTzFXWm50UGZ5SFBMeDZLOUdiNjRCM29oS2dwNlNveWlqWHBG?=
 =?utf-8?B?cEMzcXR0bTZteGwwcEdBbWZwa2V3emIyUGFGeVZyZDFiTkJGamtvaXVTTjVQ?=
 =?utf-8?B?eFF1dkY4V3hyQmVYak9DcVB0c3NjdGFrNmMvaGdwVzNlcU5yVzRtdzd4RG9q?=
 =?utf-8?B?ZUk2dXY0QVFUM1YrTW9Sc1IxMUhzSEt1T3M5K3hvNlN3Qlp4Mm0rZWl0WE5Z?=
 =?utf-8?Q?ySmBJReMdSJ81mnNoE=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MWtSRVhublJaRVYySEhOa3VFYnE0cUQzS1hvTVN1U1ErbVVMcStQWnN4cGZP?=
 =?utf-8?B?VmZJRVZzUWFrUkMwdCtidHZEaE42MEZzZ2dmbkFlZllVeFZzeWxWRTk0amNj?=
 =?utf-8?B?RGV3UGovdDk1b1RSNnBzRFpjRzFiRlNyQStERHdEN0xRTXptaytyM1hwbnhW?=
 =?utf-8?B?d1pRanh6SGZlZEtGSE9RSXhYWVpId09Cb0dpaGtOT1pCUElwdW8zWXdBZGhM?=
 =?utf-8?B?czJRdXpkZG1JRXlvN2JmaGx6WlViNmd6LzNFZUExZnpwdkMxRkc1alYvaHZq?=
 =?utf-8?B?SFBDTGlzdWF4QTlJZDVwc1dwZjdBUUgyeFhyYUN3SUhCOUZ2V1BaQm1JaHB6?=
 =?utf-8?B?QjNlQkUxMENLczBkRTIrN2lyV1h4Y0V4akZJMnpkU3NuM092Tk5yZVd0d0dR?=
 =?utf-8?B?SzN4Vm82TzErSFdoZHpkZ3NRMkhxdU9XSnFOM1c5RTdaTVhvZVFiOE5MZjF0?=
 =?utf-8?B?bGVpNHlEMnJiZk03RXVleHZkOEpUbDNSeEpuNU9HMTM3SW9oUFk1aURsNkVL?=
 =?utf-8?B?MUxScmpaQmk2VVcwaTFvMVVMdEJ4bDBYOFRHMFB1S0tPZkpwcWFaU1R0aEpt?=
 =?utf-8?B?WVc1b2xPUWp3T085ZnhwTjg4TmN5ejRqeDlUd1o0ZVBkTVZhamVBQnRQZmpZ?=
 =?utf-8?B?bUxObVlQNC90dW03L0pSSHREWUg3amZOZWp2Y01tUmdVRXZxdGpuUkJia2wr?=
 =?utf-8?B?L1lvRkZZT1MwWHNRWUlzZHBwM0cwNGdYeXBQdjVDN3NORGlLZ2NSNnFFT21k?=
 =?utf-8?B?L2IxRjVVUG0wM1BJbXNsT2hTZzhzTWx2SUtKVWlBNEFScE1QZHpWYzh1L1Bh?=
 =?utf-8?B?bHZKMmY2VnFGVjk5MjZFYnBFSXZjUU9pZUM2N2JEWjg0Z0pDb29XTk1ISlZr?=
 =?utf-8?B?dFhPcHFyQ0IzM25TTTJlVjd2ZkFMNkNiM1BCOFlQNjNIMFl3b1FYd1RwTXVR?=
 =?utf-8?B?NUVRMEJ1SEsycVluQ21yVC9oMDJsN2V5YnJCcWtrOFBnYjRRdHpHK280alo0?=
 =?utf-8?B?TWJPL3pad2hjQkpSdUZKMVp2QnBTWVloOGtPMEhudUNoUzNpamgrZUNXdTRT?=
 =?utf-8?B?cVFPSmRjc2hmNjBDc3ZBNzljakFLNnFUSk9XMm1RT052TWtseHJsTjlpdWlN?=
 =?utf-8?B?c1hFSmE1WDJqM0owU0x1QnRqTnBadDlybERVQ1ZnYTdrOWZXbmFpa251ekV6?=
 =?utf-8?B?Q0pVQ0hFOXY0SnRmazFjeGtSMVZKTVRGa2JoWWFrS2pRZ2ZuamRXYkpKYUFR?=
 =?utf-8?B?OTg0ck9SYmtRM29iWlZKdVRMSnYwRjNyNHlrMHhwS1lGUVg0a01Tb2Q5ZDJQ?=
 =?utf-8?B?THJaQytjbFppc3VFSEozUUFOSk1DT0N3cVUwbGJqV0lnZzBDWXpXczZmS1B4?=
 =?utf-8?B?VmE0N0dGVllFdEZwMWJreHVEUkpkaUhSY2U1QTRhZUFhR1NKRzhBM0h4b3dC?=
 =?utf-8?B?M2I3TGpmdGVXM2I4NXNOaWRmMXpxeTFQR2VlYzB2Z3NrTFVOWUFpUUo5aFFE?=
 =?utf-8?B?QnlDTStFSndKU0ViNXRaY1JtdnJ4cG5sL2QrV3NvN3Axck9FdUg2cWNrb3dG?=
 =?utf-8?B?VE1JQnVhWURaK0xzRUlqdy93ZXlla2N0RWUwZHloV0Z0eXFzUVY1S0ZjcUg1?=
 =?utf-8?B?SHlYUmdFNzBtSjlwU0I3bXk3Y21IWnFLRXRrbTBMSWxXZzhMcVpQMHZLaUgv?=
 =?utf-8?B?WHNKQi9MQ1BlMVg5dHNVbkF0T29IWGphdkhuRDhsb3NuWEtMNHhLR3ZLV1R1?=
 =?utf-8?B?OUpSVVRvNEFpS2hUTWFTN1pJZENHT2JXTHR5eC9tTFlSbk93bCtwUXdtRHNj?=
 =?utf-8?B?TVE1VG9BZ3NGeUovMHAzUmlLRitKT3NQOEM2OTdUQ3hNZXZhRDV6bk9WeUNy?=
 =?utf-8?B?bTR6VnZQQXRGTjdMQlFZcnBzQ1ZWN2lod3F4K0Q3RnVIM0h2amZkeVUwNFFC?=
 =?utf-8?B?aS9sN21PZmFKVWN5MnNReTBlK3FNaUZHcjZ4K1NiQ1RrSVhqMzlRdmR1ck1j?=
 =?utf-8?B?M1lYbWxEMzdWb2lFRmRDNWYxTGVmZ0pHY3Vkd3pHM0p2dTdiTGFMdjM2bWN5?=
 =?utf-8?B?dldraEhjOWtBb29obGVIb0hoMWJoeWd5dVlXaFI4N1F4Q2Z0RFlLbVRmZDJV?=
 =?utf-8?B?L0U1cDlzUDgwWWZXNUJoSnFLTStyZnl4SUFySDE0SHo2STQwdDJrTHYyUnlZ?=
 =?utf-8?Q?iEjAuEIAgBv0BwQp3SyIEYQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	yxOVULJpybLFMe+Y4rVVQbWdyTGYY48kEjGEr23d0DPxZiVhxafiTBArrCLpRdXjEjAEow9zzb2qKWWa8EfdQgzFsyxCHw6+3PdrqCFTbxKtNdQtpCK6OJfEPTKErUeroVNWTMeHPBKerdXhNEsD+elcheoQUESfUJzRWwbbm3KN0N79/c77i24YcK2lcAmtJ70KjDFd7n1x41zTakKdzqUfOLt2nKspb5z4b0pGBQrfKhFUgRfbtX1uESDNsSJN0LCsulvBZpquadW5hcgN0PDoJigNoYHyzTWSgUIaSAb/76gS2IxzOwh/G4/PmR3FaCjSVuugEbqBknQF+EEgHvfBT5bFBkQ9WliATfFZGwBHnH3hu+zZsjkSLTkEOnua3qoV9IwWqjGeigvkqP+FohyDQN/kuj/abU476N6wLyVbjgzV5fMIl58Fxk3MZJpRQlku7cU0lomtg4kOEOiu23nhRCcXV7yVoXRa82CYT/SvvrGeUHphXOzmp3JHSjHJOvankeF6moovGmuQUSb+FPdwD1sc8p1EyP00zsUKPcjjhBf53IqTePynHK6L24FaFn/J57fuSr0oC+7gec04ZYStPNyRHfPrUXyhJabsK9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8441657c-0f38-4b02-fb96-08dc9b85b100
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 17:29:28.3705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JY2NtXNPioCrb/ZrKUUU87b1uekBPy6JYIROLf4sAjPLT6ob5YDszPMefD02bCpVFHT4xmeE+6swMOUW9JN6/4yG5qrz7nZfk30/jIspUJDPy503YorOpNywSLcGWkS4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7006
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_12,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=959
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407030130
X-Proofpoint-GUID: 9I_qMxRpJW32A79eXzYqJAQuY6yHHH2V
X-Proofpoint-ORIG-GUID: 9I_qMxRpJW32A79eXzYqJAQuY6yHHH2V

On 02/07/24 22:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.37 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 

Hi Greg,

On aarch64 we saw build failures:

BUILDSTDERR: arch/arm64/net/bpf_jit_comp.c: In function 
'bpf_int_jit_compile':
BUILDSTDERR: arch/arm64/net/bpf_jit_comp.c:1651:17: error: ignoring 
return value of 'bpf_jit_binary_lock_ro' declared with attribute 
'warn_unused_result' [-Werror=unused-result]
BUILDSTDERR:  1651 |                 bpf_jit_binary_lock_ro(header);
BUILDSTDERR:       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BUILDSTDERR: cc1: all warnings being treated as errors
BUILDSTDERR: make[4]: *** [scripts/Makefile.build:243: 
arch/arm64/net/bpf_jit_comp.o] Error 1
BUILDSTDERR: make[3]: *** [scripts/Makefile.build:480: arch/arm64/net] 
Error 2


Same as what Naresh pointed on this thread.

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
