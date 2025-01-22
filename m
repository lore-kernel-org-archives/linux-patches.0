Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0631EF1D
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737551367; cv=fail; b=c5PRHjD7IuAzcXEGNyTUHdhQoDP/MxumO00nMcrfM+5ocqW3axzLbPCkQKJJ6mqa2ClBQy2sy2oUZ5WWWt4UkWUS/YCIFiOx6cgBHZtjEdMjzBfLKVdXkx48tOBC/sfSHI87wws7Eqmy7Ed9k5tT9qHn4Nwz+KuhkQ9A0egydPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737551367; c=relaxed/simple;
	bh=nV5ffH9RnGOB1YaKIMQhUb74WrZ3fr0S+ZZRD39wZWU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pj6+GkN35fD51KO1qtD6pxd5EiEEG/4Oqggp0q/qi6RSteMfg/4T4VJYwLPvpT9K6Mqxju3lATJQXn8KAc2/chHz7AkAc/8yOv3zq2nXzXYcZV+6oWzSbTlbgeBv5ZGH5n76Oi4dI0pfPyRboTBoGDb6tbChi91TzSQ/NAUn1Ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JhMIKDAl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LK/dtq3u; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JhMIKDAl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LK/dtq3u"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50M1NF8O020027;
	Wed, 22 Jan 2025 13:09:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=WOkKUDY1jHEc7jyKXFcQIgnQDRs+KWw9ZPLmP1TjYJk=; b=
	JhMIKDAltqa3wi2977jD3OTGOOF+fOoulCSgGEs93XWsbI+93KeZJhYS0izCsTQ4
	aGA7vCF/iQ9F3HXR6tt1/tSk3sL6gHUi4Av0FRz5ks6axLv9lAO4EKI6fE2UzGst
	dN45yNhRDUdmtPr47Z0QrR8SoEYPgGNdpmcdzdAXjTpFk1MerCC5rQ6EXbLZNt6c
	tGpQqSXCbLBpuKCtg0ptnw5Fk21W6vtuPhf0ZSc/RPs1CokgWkgJxSyDgjWRcmci
	pTfxGFraNdTH8qB0WOldzUqPmqFEiG9An8+atVJ87YHiTQ223oNI0x8XjHHMd1Sv
	dlXJB3Nm4QURl+O3Aqpf4g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485qaqqhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 13:09:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50MB5Juf036416;
	Wed, 22 Jan 2025 13:09:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44917qtnk5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 13:09:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9RMNP46nhwap3zx4Z0wTWW8LCqdXiAbgDQFERRQxnelGvTbVIEfI1OnYncAve0vlnyxXfqwE58/DNfHcXftUVhMvwFu2SuaZvX/jhOrfdAj4ghljzccD3s77aFqY2WNTccWB1I/Kg/eLLfJdVKPEWzSkdNYYh24TkBt6HEh8knbK5IYGY+ziZ+zBroE3V3WfruXKwJkTEI3NbjA4eVRyqe986nApECpZa8KpWEY0U6aX+D6URX1mKm6yi1e+dNeRgxENpkM2TM4jSFJbSZJd8/Tat8dlzR6R141pEMmlPixiwnz0OnAsL7eHLajFWw08sU0p1D1FTJ6omaYOl4wOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOkKUDY1jHEc7jyKXFcQIgnQDRs+KWw9ZPLmP1TjYJk=;
 b=eKBVKYhaDq6CswuhN4k6wAjfPoWpsAUWyvh51aHQuPN6G+1VsNSRrJmOFCq7Nts6juzFSThDEIC8lnuJTRPIkM4OnpnkfzedFbeJJiTK4Q7JwimtRQMPaqhENbRiWXyDcDxKUUydsqiI9RZATGLKKdLDX+ANp0kSBxZTb4COZoEIjiIVC5m5fhmmHzrOw6h4AzcpbMXLsUIZB4t4XwOAg88/TsvizsNTdYQh7Ks9Oxro3cB4Aj71OrtUgQC7eXPRbkNJDeqCI1aEv+svpJzgnULaXCoSDuiDH0U7F3FTVc4uAuhIJ6LxTNW+AZU4Fs6oeY3AWkiVb0faybpF0FMyfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOkKUDY1jHEc7jyKXFcQIgnQDRs+KWw9ZPLmP1TjYJk=;
 b=LK/dtq3uzbtffRxBedNc7mPo9NrDys3XLx2K+gvXJuUlC6FIrbkplOO5nEVE/ttuASnHgXX0M5GbG6wY4yJrYShSAnYai4LkHv12cgYD9hAcBKIGvg7wuxITkGvEXxW3afG6yvwO3zITxf3aV22eP/5ZajQ19xI/0DOmOWxDj5s=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by SA2PR10MB4794.namprd10.prod.outlook.com (2603:10b6:806:113::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.19; Wed, 22 Jan
 2025 13:08:58 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%5]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 13:08:58 +0000
Message-ID: <91a444a4-a187-4e78-9be7-4199368b2a7b@oracle.com>
Date: Wed, 22 Jan 2025 18:38:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250121174529.674452028@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::9) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|SA2PR10MB4794:EE_
X-MS-Office365-Filtering-Correlation-Id: 40435a85-6a29-48e5-5137-08dd3ae5ee44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXROY1RTNnUwOU9RNGFCZDY2Y3dxaTh4Y0d1OHhIQ0tlUjZnbzdqVW8ra0U4?=
 =?utf-8?B?UmQweGF5N3QzcFI3NU8waEJvemJZamZqdzNGOFV0VU8zUmVjbEhpRWMzQ3RV?=
 =?utf-8?B?NGtSampNV3dtY2VIU0lFZVIvMWg0c1JPN1ZJUzRURkVJOGJvT2dDZ0hUUWxs?=
 =?utf-8?B?NjZBd1ZrNEZ2SG5uQXQ4eGJZWUZKSnYrUW9ZZGtCT29aNzdMQk9hdmJrUEdG?=
 =?utf-8?B?cmhkcS85a0lRMHBaZnMzSlZ5UWdXZytJOWxmODdGMU96enJTeTI1bS9DR3hF?=
 =?utf-8?B?QUQzcjBKd2sxNktGVkRkYlc2YkViQm5MaWhKMmJUMDNJM3RDZ3FzRzdZelBp?=
 =?utf-8?B?SjRQZ3RJWENGNFljc3kxTDdlak1TUXR6aStvWmJ3OWI1Ym5nV1hrVVJ4TXk4?=
 =?utf-8?B?VmF1VzBaYkVNdGpjYzFyMGg0RTNOa2o5dTY5VHVTdnNEOVErWjNHSTV2cjR0?=
 =?utf-8?B?MjBnWGgwdWg0Nk1lSzJhU2lUSWJiSmcwOUJXc2xnTnRleCtOZUZZOHpOcXh5?=
 =?utf-8?B?RkYzTk55bk1VRkdEOWU4dThWNnlSclRHS3FiQ0dvVThNVUxWOVBUV0dlMU5q?=
 =?utf-8?B?T29zamlhMGRpNUNyZ0QvREk1UzdiMXRBNW45ckxOUjE5MkxpbFI1WVFUNmYz?=
 =?utf-8?B?YlFMbktReUsreDF2OG5RWE1zUlU4aFp6Y0IrL0xieUtKaWVQa0x5Z21qbGpy?=
 =?utf-8?B?UE54RlJhdm1USXp5czRJSVBGYW4xcUdzUjBmRHFKNTliUlowNS9tR2pQci85?=
 =?utf-8?B?ZWtieXg4VjFXOVJobXZTd2NLZkxOM1h1cW0wTmhrQktqZ0dRcDBaM3B0cDVv?=
 =?utf-8?B?MkZPbjlrYWpWRlJ4eG42NFVpbDVrenhNaDl6QzRvd1d5ZGdWdmcydDYvTFpM?=
 =?utf-8?B?Q3hGMklJMmJRNFhyOE9wV3VYVlBtdlNOcEtlN0NuWkZkdGFUU3RWNDRiNFQ5?=
 =?utf-8?B?c3dlRi9VMEEraVdIRmEybUpxRnc5Wm1QbVZKYTRWTDdwMEdaL3Q4VCs4Q3BK?=
 =?utf-8?B?eFVGb3FnWUlaTUJIVjZqSEdwNnBaN1IrbWtkMEx4dXNXRGJkR3VIMUsxbVlu?=
 =?utf-8?B?ZVdTSTJTaVVDL0tWcEVPdnJQdkMxbXd5MWkrL0kxdGthOFRXdEVWS2dYbGFo?=
 =?utf-8?B?K2k2Ui9BaXFyckVwSVo3WjJ2RmF6N0JBcmhSWXpXR1N0aE54Nk94cjlTUHow?=
 =?utf-8?B?K0hDRDBSRkFOS05yUm1ERWo0ck9hZmxrek1PaUp5djJyN0I5Z2cxRUwzdkFr?=
 =?utf-8?B?dHg4T1RYQ1dHSWw3anJFemR0TG1MS1Brdmx5TWFmUGJQRTg0V2d5L3ZrSmRT?=
 =?utf-8?B?QXJXL2NwMEQ4Q25yWG1hTVFCaWU2YWtyend0YkFqeDlXQ0llWHBtOFRBdTRz?=
 =?utf-8?B?TDBvdGdNbFY3V2V3eVp2QmFYWDBoOVM3dHF1SHQzTW5EM2NpL0R4MFhYRjla?=
 =?utf-8?B?TVh3U1FyLzRUQnR5ZDBpNW1PUnBmRXF4WHBuTTRudk9CZnFKdXNEUldPNGZI?=
 =?utf-8?B?dk01ZjBZZHVKb05DRUNwKzNYVWNROVRtNmFWREZoTHIwMkl1eGxVZVRZbWpG?=
 =?utf-8?B?eHBEWWowQ2RRNUl6WnlJOTlNc2dnREJJK1NVVzNwVGtmR0NTYXNpTW1FaTZm?=
 =?utf-8?B?azhlMFJCdWowYUNIRXhFTCtDcWNCUnRYdnJKVFpQOGcvQlRaV1lwWE1vWEFP?=
 =?utf-8?B?dU5EY0dWS0dneXZ3d1ZXdUNUSWpDNFBFbE51OXFMVDEvTzFHODNBQmN2Smxl?=
 =?utf-8?B?WTd5WmZqcmtjdlEzQWxYMVkzNC9MM0tUMHZvaE91S0hvczJTdU8rZEJkYnZZ?=
 =?utf-8?B?STdhVHg2bGozOFZ4akZJUzFiNWFtWDNyeklFRHpuMXhOL2xSSlM0WEFhTEJU?=
 =?utf-8?Q?4SG8pzGD4eVXt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzNML21aVE5Wd3FaWVh3a2ZCTlNqeUhqQzNwekNzbGV1M2JuTWoyVkdDVWtk?=
 =?utf-8?B?WVBnOVIrTUNFMTYrUDJubVppbUVjTFNoU2E2ZFQraS8yK2dTMG5MN0RsZHli?=
 =?utf-8?B?Q0dRZUsyWmxqNTJ4amNiTDAyMUxRNkYySU1aTGZHcWVDL2RIOU5HdHFBVTI2?=
 =?utf-8?B?bi90V2trbURXS2FUWjZXQ3pyVUVHYTFYUkpLekdDTHZJWkxFalBGTSt2NXJK?=
 =?utf-8?B?RnJ4UEFRMG5yU1dTU3Yza3BQcDNuemRpNGtNbWptVzkvdU5LN2gwYW5CUEZu?=
 =?utf-8?B?anBodFgrREsrc2Q0cWJzMlZzdmp3elhnczhjcjRiN3NwZmZwU0l1UDBXRnhk?=
 =?utf-8?B?Q2k1aklaaU1FbW5yY3VDM1l3NmhkR1VjanJNTWVpRnRoZHZkNWpkTnl4dEIx?=
 =?utf-8?B?Rzg4RmlTVDBwcVVxNkhpdUE1ZG04Wk5nNjZHUW5EcW5LZ0Z1TWMyTERXYnJT?=
 =?utf-8?B?WGRuYWx6M2ZQc3dBRzJ5R1hSNUVsOVAvL2RWb01XdWVOZTJ6TCtWNWY0Y3Vp?=
 =?utf-8?B?RGhIaDJMYXY5TlJDNkZoeXlWZDZ1TG82OTN4S2VZMGRtOE5Ha0N4WlMyd1BI?=
 =?utf-8?B?NGcwaURXTWtXTFFlaEZaZkJQY2ZsTC9HM1REeW1iZDYxZWNoNlRvYXR6MXpG?=
 =?utf-8?B?M0N1ZTRyeWpiYkt4YkowT2JWZlhMQm5rWGluTDBDaisvdnp2MGxPTXRkSk9G?=
 =?utf-8?B?VWxYVGFIeVA3ZWljVSs1enB3U3JiUVFwVUdEMFNuSnh2VUlEVEJRTHNUeURS?=
 =?utf-8?B?OEVwUHhGL2JRMTNYZVdEMWc1NmlHVkJEdU5qNWhsQzl1TVRUdDVlSFd3SE9L?=
 =?utf-8?B?b0NlOWFhaUh6RlRwYyt5bURaUTZFakc5TitCMHRHb3dwdVdEeFA2dXVPYzUr?=
 =?utf-8?B?MVhzWEVubGorZmJvTW05R1BteWNQVWU5d0JPODZOR25tT1RGdmk0akZDZ0Jn?=
 =?utf-8?B?MlRWam1ydzZ2L0RSWEQvRlFKL1FtQlM5MW5wNnBOaDVGTzZoSnovTzJ2dVJJ?=
 =?utf-8?B?Y3dCUTdoKzZyMlRmcG9rd1Nydzd0NTdJUUZndXhQUE9LQys1KzZESmVubm5r?=
 =?utf-8?B?bXhTZ0l2SDZuVlNHa2J5aCttNVg0bmhuaStYN1orTW9Ea2pMQzdRSnNZZldJ?=
 =?utf-8?B?U1FJY2JHNEhRYllhREZCSnE2Mm5jNk5PbGVSQ0Yvc2NFdElTSWd1d1h4MklS?=
 =?utf-8?B?L2svOVJDeDlXekl1eFYvRFl1UllrRUNWbXhwc0ZPeEl3dE1EZElPS0ZqQmlK?=
 =?utf-8?B?ejZudnlqUGZ3bjFRd2tZYTNUVTZzZGYvUWNXYjEyVysyaWpUUU00Q05rY2hm?=
 =?utf-8?B?ZGRqTzdyVDJzazMyVVZMVFZvT0s4dmRKREpvNVppTTFGbFpkV1E3VHJwc1NQ?=
 =?utf-8?B?dEx3bGlnK0s4aUNIQzZWMi92Z2xCVFZIT28rc2pCUWRVK2xzM0ZySEJxMloz?=
 =?utf-8?B?Nnh3QmZrK0NSSE9SOE1Xd0tNZWNnMUV4ck1NREVMZXJXYUMyWHNiSGNHU0JR?=
 =?utf-8?B?eitjUWR3VXdYU3lrYnhRMk5yMjZ1YzIxZHEzQmIrd1ZuZzZDUXlhaU45NGVP?=
 =?utf-8?B?cDhOR1A4M2Qvb0oxeEFidWRRWjVmb1U3REptanovUi9TVzhLVTNIMFQ5TGlI?=
 =?utf-8?B?RUZuUkp2bVluNlZxZkhXb1pGajBuSWhEbi8xOG1aa1d1V3FRQlZGc0JiQ0E5?=
 =?utf-8?B?Zlh0SGxIZ3Q5SkZMTDRodi9wNWErd3VianYyY2FKc2cwUEdDd2F1aFR4RFZy?=
 =?utf-8?B?K1gwb2MrQWVZWHlpM2p5UG1jTnlmTjNkdDFOZG1SbzZHMDhoWHpnbzd2NmF5?=
 =?utf-8?B?ZDJNS1RrdnZ0dGppYVVRSHBrZDk1VmtiUDBiTXNqa1NvZVRraktSVjArYUFv?=
 =?utf-8?B?bG5vSms3dlhrSnBwMUU5RGMxMkhvZWp4SnFiTkhoV3NGRWF4Q3FFRmR5dlZD?=
 =?utf-8?B?V0xpSTJMenRjQ3NUeEVMdElJTGpKT2ZWUGZFSXNqandzM1puSkhQY0RHQUhK?=
 =?utf-8?B?S241cFd2VVVDc25uanR5czRkVnRuM2YxSkU2bkJxL1E2VU5rRWFTWGdpUzht?=
 =?utf-8?B?SjJ3Y2E4aW1zd3h2WmJ4WXlIOXc4YlZtTXUzUSt6Y1Y5N2ZBcGIzZFZxOTBE?=
 =?utf-8?B?bU8xLzc5R1JQUER3Z3ZDdmV1anIySlRjTUdkQW5MUS9hTVU3MUx2RjB6Sld4?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LzsFfRz1lElA9QFviHJb0q0kM6jOn4vw71VGXNdM5er5xH0ZYq7wOla6A8g8iLXUA3k3MS5GiTFTnKOhcuNL9rt11Y/y169Iw/1kI59THxK9dkKiDabg9iWA4bXHwnAiybhS/nM/GlzkHNhErRkSqfjeZjlzpMJzMX2o6DPrPO/4QNY5XFXN5FEWOb2rAWhZHdCsCqm6qk81NESJhcCgOfJQdxBnG4+9iQmHzHJ7tpuPJ3mQpYPUIOuN5k1nojLqALyRKnKT5uBw6hXrMUKu0cfrMkP9GxvSWuGkbSVuqog45jIwiTUSJLInFMXhoWc/cRDNFgJOvTKZR/W9E7wrDS9bXXHAN9WS4gMfR3Hsz+dPg5IbthP0WfdElmEJRYsN23xY8SKzwh+TjBoDm/ZnOQ+7a/VTTUjy0yX94mRNjJB6MI0yQBxQ6CIOwD6uNB8ancdozuC4Tku/UNFLc0FYOiyFGWgq//UwQ3wAPbIthy6+wr8SkxZGTXSfBaKXIWW3u3LZNWbfvv6tmz+QywlNLAUxbU+IO+fnsb2d1MnuUZJxvPsI27ELda363yELBauhjgcYNPvGaPetSqhQsEBMiubUuJ/S84AySapKIIMQ94o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40435a85-6a29-48e5-5137-08dd3ae5ee44
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 13:08:58.0134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hc7V9AGU2gcYuCFrHB6z3iEWd4ZSny/j/E0yVFeg+GgzXf2t3t3gow4NpqUYYhe+fgwF6nj4sFYGZJwgDIAxzETyNMnE84yfRpeH79aQ01g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_05,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501220097
X-Proofpoint-GUID: 9tC93jzOOceiko6P3M-NrCKl11iNHb-C
X-Proofpoint-ORIG-GUID: 9tC93jzOOceiko6P3M-NrCKl11iNHb-C

Hello,

On 21/01/25 11:21 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.177 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 

> thanks,
> 
> greg k-h
No Problem seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

thanks,
Vijay
