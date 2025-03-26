Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F179FEBE
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 02:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742956768; cv=fail; b=FQLMeSe9UEvPhY0KFPDo3Y6voFA53Aq9CRZYzFIrvzXR34VmlvuXlVbBx8HMqoTmTP+Y6cgY0TnUn6FS/9c6r3LnLVYJzd3Eq9WiSOCn1Zjv5u2O9y9fIUl9zr1C9dPMn//vW7nTVcNEgydVTNbR71K+w1bgwyoTOAXCqb1A244=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742956768; c=relaxed/simple;
	bh=z7TZSXNZ70L4VdD0RjlyXO4oDJ+t0wu7oeA/C76CfQY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oNvi3H1Y35T/+G3XpEu+IUGc53T5fP1jj5z98SGOre0BspssoS1Z9ocQWX+mdnnA0OUftBEYtGOTkitF+8NTt7mQlv3+d1fbnZrpsRu1PxgQbRMeQEnviFBYMteYh+zLJEY3HsP/+EnjPEVAk/kPizpUNY2wSwPSdYiKJwskMjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iwXpFzyn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vmz/KU4y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iwXpFzyn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vmz/KU4y"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52PLtuKe001328;
	Wed, 26 Mar 2025 02:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=oDHH/jv4865n1Vq+0imtXPBkXglzoaRH6EkSK8HHEgY=; b=
	iwXpFzynn7g62pUt/W4isOrT3+kOmAdjxl0RG4MNkUBHxjLngXqqm07D4iepZN22
	WG6XBlav9qPO59o0jxKo0HT4/GIpqRSGHttJFGHq+xh+RAqkpFz6xm2JwFqGdhbR
	8FeEIgMJPVn1gcfnXB5LvtV2zqBkgOuPULJpkJaPqgA5jEWFj9MHTEht4tHXhlWv
	CUR9aUir4AcR972SYglljUR54cxMdMOXkHX9IRpPbZwjoBRu56bjV9FPAfDJiHTZ
	fiHUechVsuTZdSYlDaj8C8TprS/dJE4VxQfE6X+DIKImVsjpMO/0LcEMnz5Hp6sI
	O1msE7jHgKeT+A6tkY94aQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hnrsghyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 02:34:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52Q2PPKX015911;
	Wed, 26 Mar 2025 02:34:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jj92smrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 02:34:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y5UJXZaApgw0DADEro4foWu/cbclmVOu3OMyZNWInXMJpEcxrlfAhGB+VRJGRe5p0k6eDf/BDKARnXhql2KkAUwgtMCVuiSv5JPbziceDj7qq4hVX/Qrf8h3JysbFh+MDfNYW4F5L8XHq5SwQgvA4ehZ/KKA12Sm1P06oDeKrJbbJ0ch19MujH+6GARpmnAtU4KoOdV4FcX1G4xXgE5zin/nx7rf4GFvSAOAjitaFP2ASYNSby5r7zU3qhwawnwtVlV80sXwdpnL0AL+k6TZK2Q7XXccLp7Kr+/MQSPvcvitwXcFWZwSZi1e4chgyWp665d2hFJ7/82oyp1Y7Wnm8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDHH/jv4865n1Vq+0imtXPBkXglzoaRH6EkSK8HHEgY=;
 b=hzcN9wCts8o8zUb3hcm+XNdmEiO7t9XMAcQJ6WWyniFWcwrSCIf6BuSD/0fKMKnpwESETo0w5Bxdpj/iASTRcAoWQGh2PZih4Bm7+QgQPPmVId4HuF7Pt5ss6F1CulKd+I78j/SamuFcyvJ+qZG6hs3MdipDazbS2nzyGCxmUcmUCB/e3qCckMBYZ2t/WKnHgYL99dpZcZMAiBkJt0povYW0JKr2Cdss016oZez4Yi0hE/AZY08qN8EzEg3mlnYI7ovzi2hwz2EmxLtUDVw7mE5pMfNgt//ew+v3DpHc2p22zqAr+U5szeZbc18IwT0S+1/4HqK5teG8EjUtlCmWZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDHH/jv4865n1Vq+0imtXPBkXglzoaRH6EkSK8HHEgY=;
 b=vmz/KU4yj262O2VRn+ihq/4zYDEZSPfMkqt5olqr30YUznu+3D0ZII/XqMfRPg8uFHbOcg9c+3HERyXL2BNF9Fxdu8HPG7TqE8umj2p1adG1NTGURAG/tm0uGxFtiR9wCKtCsBYJiTbWARc1Iuys52jbJWPtlrk2DHTBfftSsZE=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ2PR10MB7109.namprd10.prod.outlook.com (2603:10b6:a03:4cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Wed, 26 Mar
 2025 02:34:04 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8534.040; Wed, 26 Mar 2025
 02:34:04 +0000
Message-ID: <751cf2c6-c692-4595-98e9-fa3ae4dfd10a@oracle.com>
Date: Wed, 26 Mar 2025 08:03:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/77] 6.6.85-rc1 review
To: Dragan Simic <dsimic@manjaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        hargar@microsoft.com, broonie@kernel.org,
        Heiko Stuebner <heiko@sntech.de>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250325122144.259256924@linuxfoundation.org>
 <CA+G9fYvWau1nC8wmpWkxG8gWPaRMP9pbkh2eNsAZoUMeRPgzqA@mail.gmail.com>
 <a823454af9915fe3acfcb66fd84dc826@manjaro.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <a823454af9915fe3acfcb66fd84dc826@manjaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::20) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ2PR10MB7109:EE_
X-MS-Office365-Filtering-Correlation-Id: d93477fd-b845-4aaa-08e0-08dd6c0eac8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkEvbFVudjN4d0tqMWdpUDgrazBsZU9pV3hCU25mOHRMcFhUNlBhNHkwckRz?=
 =?utf-8?B?WFkxZXp5M2JPNklWdXFWVFBlWXJzK0xjNFpKRFdTNjRmdEI4dHhhdGs5Z1lO?=
 =?utf-8?B?UHhxK1FVNERyajJJbkVOcU95TkhkcmR0M1dSUU9SbmdGRWF0S0hFajFXa0Q2?=
 =?utf-8?B?cWRIUFZzMWR3ME9veXlXYzRhZERVWXNRYVZ4dEdWbGI1dSt6d0ZHaU5pdGZC?=
 =?utf-8?B?U3VzUmtwbTNNN1N6NUxvdFc4a3VLV2lvR2QxTGVzcy9uamhpbXdaZ01adzhS?=
 =?utf-8?B?SlZScWdwZVZ2Q2JjbUlZemx6S0NNay8yT0NWQmEydlBZUFVxTG1WbFFlcytZ?=
 =?utf-8?B?UisxS2xMaUJSWUNqYkdKdU1rTFN6Sm9nK1BMVHdyTW5BQkRpMTdDaXRjUGwy?=
 =?utf-8?B?a1dpRHBUM2ZlMW9hYmoxc1NVU3RKVlhBMFFOTDdkUUxYQTZ3K3dLSi91U2tN?=
 =?utf-8?B?U0VZT3RmeXhBRlZFZXVYL09KUW1sQnpZdHdOTlhoc0R1UzhrbldlSkRyVDFL?=
 =?utf-8?B?TnRaQmVVTzJQQ09Ccnk4Zjd3SDBlVnJxT3lkMy9VOTBCTHBXU2xTUGJZakVw?=
 =?utf-8?B?U1pWWXRpN2NkbFBQSmZIZWdZNkxrVWU4alo3L3dTalNXb0thVmhmQ0d2SFkw?=
 =?utf-8?B?cmdWYmc1UXIwUW04K2dxOFhaN2x1aUd2VnZNdk1KcHNwN3QzT2hHZWdtOFVB?=
 =?utf-8?B?a3hNMnF5TmhGZ2IyOXpFY1Y2dGs5ZzJXVUw0Q1ZhZVVmUzRUQk8zUTNXUHcy?=
 =?utf-8?B?YlAvUDdNU1R5NzhRRDRIRlhEOFRYbitlOU9IWUpWcGxJWjhQdi8yRklVY1NT?=
 =?utf-8?B?NWQwRlVmUnBjRzFXZGVzMUpoUU82eWVRTnQrRkJKQmcxOENENFNPK04rQTlC?=
 =?utf-8?B?bldXZHNNU0JrNWtDdldwUzdLc0hodC9RWXg1a0ZaWVcyZXl4YVI0akNVcGd1?=
 =?utf-8?B?VFIrMm9RU3l6R2duN2JzMXMvZjl5QXVkQURKc1ovTzV1SmMyQk9LOVZiOWMv?=
 =?utf-8?B?M3JUK0VMc0thVjJ0R1V0ckNjNVhpR3FlSlBGNUpkc21EMGVMdWhGaTg4RThn?=
 =?utf-8?B?REZkSFNxYVB4RzBXYnVoT1o1enhWUndXZzlKMnFJZ1VSRTU5RTlROWtoeU95?=
 =?utf-8?B?cXpkaEFzbjhlb0Q3dzRvOGFhTVF2ZDJ6UEVKSitMallXUmRqNkU3OHBxN2g5?=
 =?utf-8?B?L1d5bW5QcnNFcS8ySzc1Rjc4UHVXNmRDbENBUHhJSTU0NFRCRVY1cnZ3cEZw?=
 =?utf-8?B?dFRtbkM5am8vWnR0Yng5UEtqbjAvSGZXYk1CZm82YkZPRnpjS3BYaUVFcHo3?=
 =?utf-8?B?bnlad2ZBd1ppcGdQM1pHa1FNZ1JFeHNIZE9COG5oWmRNVUxXd3kxY1dPOUl2?=
 =?utf-8?B?dHFsV3Q2d2pQNUFLK3hhL08wamFnTURGVjM2UC9FQjhBV0dqODhwYit4MXpE?=
 =?utf-8?B?dVNIS2szalAvbEFqZEN6Wk1FTi91UlNaODQ4Rm5pMkl3U3k5eUkvUm9qM0JW?=
 =?utf-8?B?Ti9yNDJoR0dVcWpsY0k5VnN0bGZCWVNMV0MzdjJibFJjZ09rdGszbmNjYXZD?=
 =?utf-8?B?V3EydVRnZ2ltY3ZWMkpSOUlydzhHbDlNdks4eko3ak9OWHdFNXYwK1YzZ1Za?=
 =?utf-8?B?citybUd1eTh4R2V4RVRraDdBNFBZNWtRcnc4TGZSNVRSVFNaNlhsVGUxWkk1?=
 =?utf-8?B?blBLMXhUUVhsK0FKeXl4ZXl4U2dUdnRvVGh6d1g2Q05yYkNadHo5Qlh3VCtL?=
 =?utf-8?B?SHFXN01jbm45d09BUVBIM2c4alVudDRBaFEvK01idkFNcWltVFNzalljNDNz?=
 =?utf-8?B?b2M1aGdiQ3FRVWovaUZOOHJPQ05zTEUyS1FXeDlDaVdvUWROdEJoenYrTkE2?=
 =?utf-8?B?Qk42T1NDQnFWWktNZXgwcGdEVW5GMTR1N1lOZEtkVHFaYlQrbzFqSVpDUnhk?=
 =?utf-8?Q?vCJN2Dvgiw4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V214RTd0dnFuNnFwNWtaV3B0LzVTamJYWjNhcGdEMFBJdjhhaE5QMGRZSWgw?=
 =?utf-8?B?bjR2bXNQdVdBb291a2N1S0dTSFNhN3c2cU1wLzhsME5XOVhySnJFNmcyT1E3?=
 =?utf-8?B?TmhPY2RKWGk1UWVBMUh3UmJYemplY01INmYrNkl3ejJaSnY1Z3dxdFkzZ3JU?=
 =?utf-8?B?UitpaVpGWFRwamFhbnBLYUhTUk1pYUhiN2NyUzE1VjgrZzJsbHZaeFAyQ0dO?=
 =?utf-8?B?VGR6WHZkZjhLeFBSUEM1TlFoR2ppM0ZVWm45b0JiL3lOS2h0Q0llV0VBclo4?=
 =?utf-8?B?MkcybXFJQVhZYXptMDkrb09hWGR3K1ZVS1JzVVpMd2QzVmdVQzA1amk3SXZM?=
 =?utf-8?B?SmRicTRUdGJ2NUkyQndMY2FGT0Y0K2h6cnZFUHFWQytlb3pqU2JhL0Z5blFR?=
 =?utf-8?B?MThXTEdJVVhmcjFOeWp0U1VkTVVMaW5iY1drSlVqcmJ2aG54K3c0WWNlSnNr?=
 =?utf-8?B?RXA3SVBqWDZwM091a0tWMG9hbGsrQUVrVnVBNVh5WlhncFplOU9lSHRoQkNi?=
 =?utf-8?B?M3MrcnYybkRLc2VXbWN0dUxHYk5FTy80eldpdW96TW52UC9ZMnVnbzB6Umww?=
 =?utf-8?B?Z1RiZjZ2TnlMbkFRZEh2ZTI3ZWdIZkZ4NlpPcUhMS0VKU1MzbjlCMFpXeVBE?=
 =?utf-8?B?S1N5c3ZmTDFTYlU5NmM3TkJsMU9neWxGQ3J4SXVrRXlyelh0OFN3TzRnY2ZN?=
 =?utf-8?B?SlI2aDV3cXNETDhxVmxLSzhNdEJKZmF3RUJJNlI1dUNLVlpsdzk0dEhUQUdG?=
 =?utf-8?B?M3pBUExDZzRzUzFzSFNzYWVrZ3ZUbWhkZlZ1c0p0Z2VvVElUU1EwMFdEak5i?=
 =?utf-8?B?QVYwQzhoRjdCd0ZKQW83VTg3NTBWYjRnaVZISlViT2JVenBXYWdic2dNYW9l?=
 =?utf-8?B?QUlnbnc2UUN5V1hpaDhacll3QnpnZVNtQmg4b3BKM05ycWpHSVlRUElCa2oz?=
 =?utf-8?B?cFpqY1ZuTjNjTGY3cDR3VVFjVlZJd0VHYVN1WWIyYVdSL0JyL05GUGhKYWsx?=
 =?utf-8?B?NitiRmprbThGaWExVlUwRFFRRVE4ZzBVM1VlTi9LdU5iTEtFbFNVbGE5bklQ?=
 =?utf-8?B?Q1Y5OTA0L0E4MmNTQmpMc3ZudFFkT1k1VTRmTmRxU1Q0aHhQSnNQT1FGS2lO?=
 =?utf-8?B?c3dlM1YxdWpDZWtSQXN1S3dHU1Bka1RGWGFVU2Q3MU93QXBFc29yeCtZeFpC?=
 =?utf-8?B?VUR4QnEwY28weGYyL0N6MjM3ZXRuaW5WUkNPbkxFYjNpNEZ2YmxsdlBJQlJy?=
 =?utf-8?B?K29SQlYzUXBTNld4MFRtN1BuTjB4ckFvMjcrTU9nR1hLU2NiK1c0LzNIaHJ1?=
 =?utf-8?B?T0czT2pyWjJyaEQ5b25pcjdEMkhUM3AzZnc5YVFjTm5WU0J2T2Yrb3ErOG5k?=
 =?utf-8?B?WitNWjJqMmJIb2NZdGhPbVN6NzEvM0ZwaGZuNW54Mittd2d6bVFieGRNS1FL?=
 =?utf-8?B?a1pucy9KV2RlTTBTbE5mOHNra3ZUYmppSXR1aEc0MHp4MEdwNDNvZWgzNkFH?=
 =?utf-8?B?YklXYjNud3YyY2dyaEtQN01lWmowNVJRRlQ4STZ3bzFJbFR4MTFZYkJKNWJM?=
 =?utf-8?B?YUNXT2ZMcmxIMzRleCsxNk83WGRMYnhJekx5UW8wMVh6a0pTVmRxVndnQmlY?=
 =?utf-8?B?eTdCaU44MGl5bldpWU9MbklGWVBmRDVZOUFmR0JSWDVhRTN2OS9nTHRRVUc2?=
 =?utf-8?B?UGlZTXNpR3N0YzlDY3RSdDArQ0xHNkFYMGR2cklLckM2VXBEWWNlUG9pTFpz?=
 =?utf-8?B?Tlh5Q3NXUk9BS3ZkK1dLQStLZ01pbW14b0pnTzNObDlremtHQTVLUVIveUkz?=
 =?utf-8?B?MzhZK0FSNm9aWW5jamtYQW1WS0IrT1VObVZyODJxbjdnMklDYnI4bGQzM0hZ?=
 =?utf-8?B?UXArbmEwL216RDBXN3VhYVFpaERXRVNLY3FaeHhjYVNjK24zSVIwcndnREF4?=
 =?utf-8?B?RnNmdm5Zb3BNa2Z0N3RrZ1BTUW96NzdsVTZKdE1ZSkhoYkRDWWZ2M0lWRlA4?=
 =?utf-8?B?RFhrMlhWWWdYR0pxYlVkRHRBaThvckFrT2R6N20veTFMakkrS3Y5S0xNV2VM?=
 =?utf-8?B?ZDY4TW1iVkR1T3YwN01GbDJEc2FlZTY1NE9zTzF1eGQ3d3BZYkE1dTVEdE5H?=
 =?utf-8?B?dUYrOHZMY3YzMlNPWkVpTXVXa0lCRUQvY3NuZ2tMRnZHdDVlZmlnN2lXemdX?=
 =?utf-8?Q?R48L8L7BqhYXvyGP+1CTKIs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s9oEmBq55yUXx3RaVH1q0Tp6v8LqJ3NxK0+lMWbQpmSoB+3Oo8dhc5x1KFkwRbPQ8Q6heFljcIu2X95urLg30PSNBFt3mwl5MeuAzyg0jQlOKLLfV/0M2PZ+9nQ2R2CMiBYvAfD0xkfQnz2Cb0LylGCIOHE83ei+CngYoTKdpBOPXDRBD2ljgIMWvZXzQ2eXscWd7/UHWcqlXAgZ5IhNbA/WGdDQob8IeXzbzoRZ4422eDG7ddxrqZUeII5iR5Fh+Dxer18ymboDEfyxm/zPUWSpmRyRQNHXyBsXkLxv/t+VGzUnJiuxPKEPRdjDITBIJSJLQVb4IFzwE9+OM3C1wv/4OrOBuzCu+ZcX+tHu8j3UmQN6L4OtIMsPhr57KlD3j9hR0ta9aYBGx5uBjAZNlz+zTCxK0YeNzG1CFxvffC++x41jnn2GMLGVc1X4KZ70R4IIdWFzQ4u+Pifeq5PHAOy3LYG8PVSuBDIqAdmnpvuOGb3zK653BQw6by/Rvx9L5A9ZMeY0re1NjFiutl5rqzhyONQYWEhx2JMH9PL/rQpbkAY8cMpgpMBVlSB5N7aw1a7iKKOWA1CDncPKcKI+pI3MRgCblFuf4QFqd8OvqqA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d93477fd-b845-4aaa-08e0-08dd6c0eac8a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 02:34:04.0745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9eaNeHNEGE9KcIn0MvjShGm0/1SoEaQc6s4WB2zYG0k8q120B+kDon2DKHMIA8KajyddrMXT+Z5dnX95O8zBSjWZO9ZDWi2nQ25CC45Dxq80Q15nwb3kZVSaVId6Gx/H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-25_10,2025-03-25_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260014
X-Proofpoint-GUID: gH7AeCZXTESY9ZKhtAjzpx5mXvHxYjCy
X-Proofpoint-ORIG-GUID: gH7AeCZXTESY9ZKhtAjzpx5mXvHxYjCy

Hi Greg,

On 25/03/25 21:37, Dragan Simic wrote:
> Hello Naresh,
> 
> On 2025-03-25 16:07, Naresh Kamboju wrote:
...
>> Build regression: arm64 dtb rockchip non-existent node or label 
>> "vcca_0v9"
>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>
>> ## Build log
>> arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
>> (phandle_references):
>> /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
>>
>>   also defined at arch/arm64/boot/dts/rockchip/rk3399- 
>> rockpro64.dtsi:659.8-669.3
...
> 
> This is caused by another patch from the original series failing
> to apply due to some bulk regulator renaming.  I'll send backported
> version of that patch soon, which should make everything fine.
> 

On ARM configs, we do see the same issue that Naresh reported.

arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR 
(phandle_references): /pcie@f8000000: Reference to non-existent node or 
label "vcca_0v9"
  also defined at 
arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
ERROR: Input tree has errors, aborting (use -f to force output)
make[3]: *** [scripts/Makefile.lib:423: 
arch/arm64/boot/dts/rockchip/rk3399-rockpro64-v2.dtb] Error 2
make[3]: *** Waiting for unfinished jobs....
arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR 
(phandle_references): /pcie@f8000000: Reference to non-existent node or 
label "vcca_0v9"
  also defined at 
arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
ERROR: Input tree has errors, aborting (use -f to force output)
make[3]: *** [scripts/Makefile.lib:423: 
arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtb] Error 2
make[2]: *** [scripts/Makefile.build:480: arch/arm64/boot/dts/rockchip] 
Error 2
make[2]: *** Waiting for unfinished jobs....

Caused by commit: 1e4bd0ec5a47 ("arm64: dts: rockchip: Add missing PCIe 
supplies to RockPro64 board dtsi") -- PATCH 42/77 of this series.

We see same problem with 6.12.21-rc1 as well.


Notes:
-----
I think Dragan was referring to upstream commit: bd1c959f37f3 ("arm64: 
dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi") which 
will fix this problem but fails to apply due to regulator renaming in 
commit: 5c96e6330197 ("arm64: dts: rockchip: adapt regulator nodenames 
to preferred form") which is not in stable kernels(6.6.y and 6.12.y)


Thanks,
Harshit
