Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577A2224F6
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 02:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743129533; cv=fail; b=NBMNpvGLZ3kvw5uPSgjJzFG9xYTKCDIHXj2hHPXYdAp0kb8KXsrjirkWwZmFT1wEPznV9UerCoe2rJxf6NIs9XByHCqgikxbP8teBWFTYInBjuAcihzWMsaJ6LKixl0mdRNg/yYIXtSyT4prj8zh5s6Dj0DIM2yvgS6H4F5UyLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743129533; c=relaxed/simple;
	bh=GjAJdZ10wGHLimOP55TY9lrQ+c+Qj80K2g+fec8hc2s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TGfsLbdeUYW4b2UkVKSepNesr3/jJSg6X2k8y+qHioeWTm7yNBojRkzRXhf3HiC7P9/cun7gdT5YNYV52QDNdKu1BehC6jkszf4yZPjUSXLnkdy+JyVIhqHMO21U/y9Y1BDMbJgkNjHtL34pVMjUzH9wbigWmy3/mNoOqvOyTN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ciCgIBzJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KVUGBQrs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ciCgIBzJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KVUGBQrs"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52S0uSIu001539;
	Fri, 28 Mar 2025 02:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=bmkGnHvbgcrTGJMyj70M/dy7HxDn6Z11DhxdTySaxLo=; b=
	ciCgIBzJPQoyFgRvgGDtbly6N777lqK9TzbfmyPjf6HiflFdgqUVMw0p5lT0z+IK
	l0+y6ANJDdud4j/w9/bxi4DLfgDVN7F3wcRuvZ7kCyeyS8eniyXHSfhtnrKzLoee
	+UxbDbkSf7XkBILJocevWnMbEsVc3g0H76e4ol+ikSTIpBIEGtwxB2N5wxQ69ryV
	O/ti3PSOBTgFALZJmFrbREzFqq3c6UErydA8rWEgj7i4tm1pniB93BUog56dQJd2
	ZljXE143dr4Dj3Pwh3F+HYSBJIHn0MWk1LHzgttd23L6Wy5A5I0bwL/EPCQfan2x
	dD2L+DdvK6VkgnVyJx1GgA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hn8be7mg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Mar 2025 02:38:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52S1aABY028718;
	Fri, 28 Mar 2025 02:38:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jj6w6ywp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Mar 2025 02:38:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EkmNwzeSa91TJo8AmHV2oQ60XBdeWpPjdFjZzR9v2A4ot0/RNvn+wPzb+DxgSJcepHiNrfX7Vn+n4fOHffnwhWEhf+ZUEKNwi0Cl50KazQnG3e24g5DKR6If/TNkqZoQunR5Ekt+lakbkkk8X11BEh1ccThGD192OW6vT9gXNxxCVxm9zX//rJX2+ZKzsZlh+eL31YX8LdTCv5RqzWugR9Uq1g4hzuykKFnT0zLCtkQmUCdfi5LK+DOwD+ELqPKUArOWjIQOp7NW58K3ZusgtWF2qF/vXJkSYvwzMOSen0TvR83UycanH5RQnQCSidgLlrM1hAjZehCvPniRr6SpiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmkGnHvbgcrTGJMyj70M/dy7HxDn6Z11DhxdTySaxLo=;
 b=CfzXr0wYaGGMYttPeJnGs8npaC33pgszSUc4cGUIIWJPLOWcR7K/ePv7mrwIi+EheJpdBt01nqmYBE/n6i0CgryiEKacDrs+uddElrFEMUOKw5QVJ6olGu5BN7LFld/drG1xjVlZvXMnoLQfUysK8pI7t1hIWa64m+bmqz7i3HZr77NTDu56WgRIKEBR9LRfVA3094y6bgaQ1pwpeM7CJZkH3+vAWQA5MICnFBwzbB4Tw1+v9EN3+XjnRVOZ2FyZudTvgenHQglCHTcDPSnm2Cfi1unVHLaPI5DqlDFX1Q1v2jFe6ua5oC5/mlnjCIIcc5zB+3e0JG8srcPCJFcW3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmkGnHvbgcrTGJMyj70M/dy7HxDn6Z11DhxdTySaxLo=;
 b=KVUGBQrscOIkkdoWyX2puf+GVp1YsuGZw/NHHBMt481HwLCt9/Q+mHMK0j8JVX3MpNFqKilnVKVZfzNIu2L2IL10kftjxRTA/u5WCqi93DyUnOdfWuufazxZd66oNMo9mlrudZVUEO6WXbehUuAoLkLP/cM+Gooak4Il94h+wgI=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ5PPF4B2F62DBB.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::79d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 02:38:37 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 02:38:37 +0000
Message-ID: <9d75a665-f5ff-40a1-9a88-f1de857d4328@oracle.com>
Date: Fri, 28 Mar 2025 08:08:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/115] 6.12.21-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250326154546.724728617@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250326154546.724728617@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:4:197::23) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ5PPF4B2F62DBB:EE_
X-MS-Office365-Filtering-Correlation-Id: 9426a464-4cf1-4d56-d4ce-08dd6da1a429
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDQrek44NXgxMTRrYTNCVFZXS3Q2WnRwNVVPN0YxTnZHYjJtSmQ0OUIwNldU?=
 =?utf-8?B?QStGMVJPRk1BaUZxcTdpdEw3RFEvdzhaQnA3ODdSVW04RXdldVVscG9GRmlY?=
 =?utf-8?B?QUNsSTRTbi8xYzRkNlg3aXdtNTN3dklpLys3OUIzcFVPYTJubUhCR084ZEg5?=
 =?utf-8?B?emhIUGZPeDlBOU9vRXZrZnFCZ3hWT0xYOFZHZUdqVUdQVmExQ0VTdGlDNm1H?=
 =?utf-8?B?ZE5zUTZVd2NqTkE3Qyt6aHk3WWg4VUFhckttYnRQYkFPa0Z6dTdieitTVTlH?=
 =?utf-8?B?dHRkTDdsOGR4ZkZuVkN6aG04Q05ybnh5a09lWEhSNzdhREwzc3RHenB0Y3Iv?=
 =?utf-8?B?dUlRdHhWUjlCeWNsUWNhUW05Qlh6WEQ0WkhRbzA5bFJ6UHdKcG1RbHZxR2l5?=
 =?utf-8?B?NFBJSUlEZGdqNFhrQTZQSmkva3JCcHA4bzc2dWtOVEtESUk4RmZINUhCUlBE?=
 =?utf-8?B?blhjdnZJNGhtbWQ5MEZ3a3hSSG51cjdldXF6ODJyWG0zMFVjcHJsUU43TDdC?=
 =?utf-8?B?OHE4a3J6WEZua2gwVnBnanFFbnQzUlZ0d3FQMllGaVRmY2dmb3pGbUxIWnR3?=
 =?utf-8?B?ZXVwQjFFMEFOOUlibmFYc2Q5WWFyY0lRRnhORjBwK2c4N0IxUTZaTWZqK25O?=
 =?utf-8?B?UFpmOWp1c2pvc2wwbFlwejFIb1AwNHFhK1BpSTczdkVLZlBiNlNDVzVNLzIr?=
 =?utf-8?B?OVhlRWtxanFKdnExVll2b0F6QzFYVnJYQitRU1lhYWxkOHlNQThoQlZpdVVL?=
 =?utf-8?B?dThGQXRaZEtqcFBmc1l1UUgybzFxSENOM2F5SVgzSW1IUmE4T2xkemk0a243?=
 =?utf-8?B?ZXZINGVZN1ZvUllKa3ZwQVdNVElRUEpmYjEzNEkzZFFMS0g0ZXpZOWJ3UW9S?=
 =?utf-8?B?dWlHQmIrKzdFWkFtODJ6eFRPZVR6UHZuTXdpRkdQRm81cXVXN1F4NVZIVVh0?=
 =?utf-8?B?YTBxVlZLejNoUmp5dHhReWhueXVZaTNSM3RWWlZSQ1FMM2I3M0doQXNSWjZl?=
 =?utf-8?B?WFFsb3ZMSVkxd0R4ZjJjMWhURXBGaWZhRHJocW1FVjZsNFh5MVk0UDl5clNK?=
 =?utf-8?B?WVhtNWJYNG5LWGVKakhlVDdtbVFXSCtPYzBaM0M4NVIyY0hTUTVzREtseDBR?=
 =?utf-8?B?dlBpdnB6M1NqTjdxeTVzaU1vb3ltSG1QTnUwQWlMVW9YSkw5aTE2NTlmcHhl?=
 =?utf-8?B?a1hGdElQV1hNUGdYdDJXc0swQWZMbUsvaW0yeFIrdW1IVSt2VFIyaUQ1VTR6?=
 =?utf-8?B?bmtGR2tKQVkxYjJHalVVdkdYMXpUWjVGbHJIdm9PTE56Vks0Vm1td28vUHM2?=
 =?utf-8?B?QzBIbVlhZldPQnJYOVprMzRpN0pRZHdxUkszdWRxblhQRGxJWk1oSFFCSE1m?=
 =?utf-8?B?RVJTZ1pIOUw4WGFBQ1hoLzZWT01ZNGlSOXZQdWVTMkpwODVIcld3dFBsaHh4?=
 =?utf-8?B?WGZXZS9FcVpVZDZUaEROT1BiS0FJd09mV3RJSjk4UTZ4eXN1bDJkV2JWWHlS?=
 =?utf-8?B?NllVYW55OGRUUDlmOEp6RHF1ZHhPZHo1dVQxU2xsTloydlpKU2d0V0M3TTNL?=
 =?utf-8?B?bjZ4SFFSUTlwb3ErVVM1dGVYRXdqeW45K1JMbnZCK0RYeEsrazZDZ3V1Si9K?=
 =?utf-8?B?UFZnTEVZMzRWT3NEd1Z1b2F3Q0wya0lDdHNFUy9WN25jN1ZzNjE0VGFxVjBT?=
 =?utf-8?B?emFmOGtvM0dpVlEyekdjb0FIY0FzTkNEVUpMT0N3Z25hZ3R4K05tL1A1WjdG?=
 =?utf-8?B?MGVYZUZUb3FhRVBXZDFWblo1Q0FVcUFKWVZTeFYvVHd1TTRPU3FCeHMxVmh1?=
 =?utf-8?B?NFF1eTVpaTlvSmhlYXNNRGZna09rZm4wUXdleVdzbUthSytxaVQ0OVVVTGVq?=
 =?utf-8?Q?NB3FGSySuZffG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0JJZEE5V0dSQm9oWnJwZWhEVVVLNWp1elZYM09xTGl2blpTb3hEU3Voek1S?=
 =?utf-8?B?dm9mSTRKS0tIS0hTOWJMZDBqT0VqOTVoSUVWbjYvdnlmYzVOb3ZsUjBrTThL?=
 =?utf-8?B?dWR2RlM1aEJjOWl3bGNMSmhoVGpocWEwS3FaS0xzRnB4ZWlkNzVodGZPei9j?=
 =?utf-8?B?VTJjRkduOEc3ZWw3MG5reE05VkRLMEJXK09BQkRQUGFUWHhENVU1QTBkazRk?=
 =?utf-8?B?N2M1MHdLczRnUzVscGh0YUVrdGR1TUdraDRFek9US3RUT3FrLzJQS2xyREhV?=
 =?utf-8?B?dUxDZFJUYWV5R1pML2czRk84RDY4dGhUaEtJb2N6QXdQcENQZGpmdmZTWmJY?=
 =?utf-8?B?QUpHWlFBa2l0MmE1UWUzZ0h2L2lZWG1Vbit3Z0VlNlhDeTM4aFJqRDZBMnlZ?=
 =?utf-8?B?U285Z2ZldEFPODlmSHIxZkVXeWhCZCtWRHNmNU1kdWU1OGVZU0NDWE9ZUTNH?=
 =?utf-8?B?K3Vnb2tLMHM2a2lEQmp5R0liRERkY2w3c3YwSjB3OEN4YzBCd0JrV2E4bGkz?=
 =?utf-8?B?eDM1dVQ5TzM0TnZWeGF1SzRpbW9VWGJacUtoaGxxZlJDOE83UDAwaTV4ZkR4?=
 =?utf-8?B?Z2xBOXJIdUpHSUdteDc0VUZvMlo0Mno5SHZLV3BiU1M2SjdNa2YwVXVKeGZw?=
 =?utf-8?B?eCtNK2p6clFWTTZBS1VWM2V0QVFtYzR5cCtpUjFPVkR6Ym1tRHQyQVNGbEZD?=
 =?utf-8?B?cDFsd2hyMHovODJUdEdwMjZ0UXJZeHoyTUhyemd6a0U2bkR3dytGWjlmOHV2?=
 =?utf-8?B?TDFKL0w4N0pHNWtkSVFWYms1Nlg5QzlqdnpMQUxMcTAyTkUyRUlNTGVzZVQ4?=
 =?utf-8?B?WStWZXE0Sm9OdXZNR05WM1lJUlBvNG9KMFd1R3ZXWXh5Z1hrUDVnS2k2UjEx?=
 =?utf-8?B?Vy9mWnl3NUlnOFBvM3JNam1jYm9OL0JGSUhwNjM1MDEvdVRwWUQ0QXp3UXFI?=
 =?utf-8?B?aEhyYlRxek1aWjd6aTBtaXowUVhJbTN2eUMveEhpR0F3Mi8xZHhqQldpY1o3?=
 =?utf-8?B?K0ZLbFJVd0lLNTRxeC9kRVJMeUttTVJTU0N6dXpiRkdpQURzY1FkSTJYVEZm?=
 =?utf-8?B?ZFozY0wyUWFyV2VBL1hZc2NVY2w0UmU0OWdxN1NMZDFmZDJLVFo0R25aTkdp?=
 =?utf-8?B?dTVxL0M4QnB5eHpKNnk2SEs5R2RGMVkxUk4zZnZEc1VkeTBGcDRLTElIaHdv?=
 =?utf-8?B?TkhNRk1vQm41TitmT2VhL0dmUzlUbkpRT2VxVHFNT29BWUxRdyt6OWJXOGMx?=
 =?utf-8?B?R1ZWMFBScTdjODhUTWtobzVUUzBVMDgwZ1lpS2duTDBtejdPc0hsdEtwcDJa?=
 =?utf-8?B?WkJTV2tLWTUrTy96eHNYZ1JXS1grbkxNL2NwY2d3YjhYc2tYVFNvM3hHMGRD?=
 =?utf-8?B?UHRBRE1PUWhjbXlCUjJOMG9MT2dyODAwazEzTjFqZjdoTFNqL09jeDMrZmxy?=
 =?utf-8?B?V3AyaW1FaWpxVTZjUHVxOHUvM1FpMnhoNkZlTFBId0hMclM2M0QwbnNtK1hL?=
 =?utf-8?B?NGhCN1NOMFlHZkNlREp1d1RtME5GM0VBcGRoVWtMTTU0K0dlanRUaE1YTzRo?=
 =?utf-8?B?OVRnYmNyVG5DcVJDTzExalhWbkx3UDVBTEVZbCtjTEF3V2tZdTdsS1o1RGg4?=
 =?utf-8?B?dzdMdXpMa0d1cUR6WkxiTWVYb3RaVWR3YTZRc1cwczRoNWcxbmNuUVJ6WGhv?=
 =?utf-8?B?ekJhelJVc2M0aGNYYWlmNlNpUGNLQTlaYkluN09wVk1SQllLUER0ei9jcGpK?=
 =?utf-8?B?TVlIZUJCejhqNm8zYjB0SVNBSDFFWCs1eWdiTXNTS0o1dVV3TWwyQ0NQUEx6?=
 =?utf-8?B?UnNPQWpWZmdyT1VIWktXZ2UxMTltVW40My9LWUVhYzJXYlI2YmY3VnI0NkZn?=
 =?utf-8?B?RzZEWVRrdmc5ZE9BY2szQzd2QTdzZm5keFlXcHVrVHRYMUZJQk5TMTJ3dGN4?=
 =?utf-8?B?UmEvOGhrVFBWMG1ocXZ3RjlyWllNT0pJajVzYzVkaDNoYWtHVExERndvMTg3?=
 =?utf-8?B?VTk1a1hxMGNuNkIzak5sR0hnK3lGWlpQRjMxbkErQ21DN1ZZVE43dnJKcFMx?=
 =?utf-8?B?elo3cEFnL25Hd3JwNmxOcEhJdThuOVRGamt0ek5NYnpqZ1dYbnAwcWV1K3VN?=
 =?utf-8?B?SmFmdW5ET1NVamY5MmVRUDUzaEdwaTJjU0lZb3lFNVFHVHc0d2w0Vy9jZzFP?=
 =?utf-8?Q?yL7ihHPHmV7gHNKZyZ2AvLE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c/WNCBiFqQnx2I5mf2ZX0wRYmWvPwL518awKHe9nesAUdd+6gjQ1Id4qaiqFj+zjKsAkpqd5+oLY1CwyT4G/cpKmIRXNphD9+tbh+AjfaNtsfjxV0ZVx1ZtDvVJ9aHc3azk8RGkwfgEnK/ZJfonnSBG/E81cq6kG1GitihGUkuiHOGunvNf00QiKFROlm0ALtTiWDoGS2BAAx/BxvgCZ09qBkEyJy1nHnR51LXal4viQ/Xc7sWqoWCJA/nvp8dL4Ka71khuFI2LZyN/zmTkpWWlq6xcdHLa0cRsefEPVrUDPCkgBN6VppUEf8i3Yn0IY6Vh/87vG1jzJU6uIowG8iRxSGAbAg2FbiI7MWylYaJy5HB3HbLDR51YB3GGguLN+NLNHHyB6A62ocHDir9yT94TDE1Wz0TUGU9+YpBMJr48FLSxv0krunKPf7xKBkNoAaqVQf1IoDSKrpWBUbA2mKj09CYasRyXZw0Y8fPB48kj643ny8uMvCOqs7Mat53u+9SpzI0mq5Xw6nyZWa+6ZSmDRFxXIjsBGiEBdXMsHNW57i1eqrIKaTXhtMMez5RS4pEZ1v1ThbX/3sy05mA+uGyZmM9Z8guOiZ2pJcmFMG44=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9426a464-4cf1-4d56-d4ce-08dd6da1a429
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 02:38:37.2412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehjVZh2jVLv10y5Fe/HvnW1j52pT5iSzkTexBXRqbocOZLGyiIr6PW1tU60YPYQ/Cf+f72vyOoEqsypwkZUkyoN5C0PCzmPvaZN7AiOp8vwaBZtdE/jj/KXXBCf5Ye+p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4B2F62DBB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-28_01,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503280016
X-Proofpoint-GUID: C9rSbdd1w6n_Ot_-DNgp5WzxHrRX345C
X-Proofpoint-ORIG-GUID: C9rSbdd1w6n_Ot_-DNgp5WzxHrRX345C

Hi Greg,

On 26/03/25 21:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Mar 2025 15:45:30 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
