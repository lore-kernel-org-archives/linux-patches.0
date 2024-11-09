Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AA11990B3
	for <patches@lists.linux.dev>; Sat,  9 Nov 2024 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731168414; cv=fail; b=kQv0/vxy/dQZEU4cBha3NTq0gHJSc+niQdVPVc+DayB0BcrrDUIMFIcQRV39vsLmhRqpC5CT4iD2ZqcNqg/u8wMActv3rcjeSB9D5XCQcPJeKHibhH4Y5jcVxYUFZYmwUhLMkzboK6ZrD2B3YfFB2cfHIg3cJm9Lfsvf90DqRVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731168414; c=relaxed/simple;
	bh=wWzbRP4na3KHPjzJSB8iV4bqdVx/NgQWnlm/sKlgJE0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e2bny6qjsL5dDIIitLh0DRX7hhY7DTv37WJzfM6TptKSm2aepwGiOalxqHNtDjb8pUKx3XZXkCosF84N45CwB/oCrW8SaIxJ1HB4ycemBA8tTpKZEKEzcM/Dqj5nIR/qaGdSp84wwu6IwaDDre9/g2ArCm6pSIwsGpkva2Et6Kg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eB+9GJUr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dOl6KpW2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eB+9GJUr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dOl6KpW2"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A9DSjoi000558;
	Sat, 9 Nov 2024 16:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0GG+DyeSRUsTU9lWkJE3H7NKH51lajvBqaSXlyGync0=; b=
	eB+9GJUr0ApjHVkuCjiVvr+GBcWDcGg7YEF0RbqlzmMAdJEJSkocDSnm0ozJyGCz
	arfjo+d0hhKWuYPmTyeZ8Js3WXTSCm/36sYQzsBzFdJ4Lcca3gJOcd0Kac4wyFqu
	/XKTS268mnWGgOCX4KsEv1N4n/8vUR9uDyMpcwWKF6pfqu8lq4j7kgBgEgjWCB+t
	F5O/qTsB3cKK63HPIlvkEJ8wzQuK8ys+0X7xmaL56a+Fdwo2xMoe7gVqabIVHpBj
	2bVqEbmC+RI2S7p46sAL4bKiwKrg0m3zryhvE+qdNsh2vwHaBXqkqiMxMXNj9e7e
	RKrJtYAj8PxoAOj4h41nuA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0kbrc78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Nov 2024 16:06:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A9EvAr7034311;
	Sat, 9 Nov 2024 16:06:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65mrsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Nov 2024 16:06:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oUfbdiOQirjkrKsgWUhunc93ZYcVTLPH3rTtnBnedvMY8KAxJMBd9usYw/U6SVwn5PR0UoyKqk6RW+Ltb6eivqFZHsZ/CM1XMmeBD9FuYGyVDs555pJ9SMMLtwjkIlJamObzu045M2kuq/r7Ib4oUM29slsibQrA+HiOaGV/2btpQg8s6se7js2gbO3GMQQfNYK418FUh9Ha3Uy2bW8pRIgRff4JEyjWhC2ji0GC7vwvfV316y3+Tzkc5Fq/qpFtpQ3g7Ibccn/pwHEEHSsWu/yQBWhJ/wxtaMowuV43xNNpKMSpnSrayeFqQyIOmPIqb9n61jj7rV5pegaSeWG/4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0GG+DyeSRUsTU9lWkJE3H7NKH51lajvBqaSXlyGync0=;
 b=iXNV439OzfoURUsEJzeVCwUdBRETaJuQy1LZItWDXSVeNc0rP5l55bKupnVyA/lMN8dEmvYh2Ch4OZcY0e8JZK3DwYzw6pFkicoRHpwWaM4YOsXLnRmc4TOw5EqFYiGQBEhpj/rdNf5YreUNq2p9ZzBxM7H8K/Xw4PzAbg45yLXmQn8c8ckq1EOmtv1XIPnzq2hyba+wMx4/2plFgYEPuOEQVcuCtjrL3NwEhHc80nHhQfDVsGGOxvOZYrh2bz81tOqNpG4a7Gq/Wq3AwwvVF3ucb1hJzOxZ66LkZI12BbTET73SwknAkV1DS1NG1k0nl9+xAjqgC3uw7GhQ4Ky1Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GG+DyeSRUsTU9lWkJE3H7NKH51lajvBqaSXlyGync0=;
 b=dOl6KpW2aeh05sc95iFAUEG8OMkYgpTCNKHRwT7oYKokH3L5MUjKQAOedB17EcyNScPMtWBZn0QxvjbwC0phpAjBvv1OvtFqZofTfBsWlvZsxIJcZ4idP8BG9kEs3nC3vFaK3Qh114Kn5/BFxochK8uyGeMF2jqvC/5BQ24xle4=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by BLAPR10MB5042.namprd10.prod.outlook.com (2603:10b6:208:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Sat, 9 Nov
 2024 16:06:27 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8137.022; Sat, 9 Nov 2024
 16:06:27 +0000
Message-ID: <73523bfc-3e16-44a8-8e9f-de0c44301524@oracle.com>
Date: Sat, 9 Nov 2024 21:36:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/151] 6.6.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241106120308.841299741@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:4:195::10) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|BLAPR10MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: e497feb5-f47c-4eca-80b7-08dd00d8774f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1FuQW5neGFjZ2tRc2VpSTZRQ0lEdXBLdlYvbHg5VVM1RHhZQWljV2tPSmo0?=
 =?utf-8?B?N1c1N1JUTHdPclRzTTFJNHR3dTZpZzArR1gvNG45N0Zmay9CNklQVnVick1w?=
 =?utf-8?B?eHh0RmNaVGlVSDVkMUdGc2wrMVRXVFdlRXU0UmxlRTRUdmJ3WW5QcmtoR3Rr?=
 =?utf-8?B?Y0M0L1dQRGQwZnRLYlNOaDlQUndRaW42cUNQZ2tpdE1USXp6dVVuZGRweU5D?=
 =?utf-8?B?WW5ldTdpWjlYcVQzTTF3eHd3b1BYMDVWUG1WZi9ENUJlU3d2RFlBaTdYamdm?=
 =?utf-8?B?NVFCM0pDaVJjWFhaTEJHMVdmWUVhV3c4UnYyNlo3VHpleEZETERpRGZvQTN6?=
 =?utf-8?B?ZVoxS2tjTTFYY0NKV2JYcUt6TENaSk83NVl0d1lTS2h2bEFxa3JYaUpXUHg3?=
 =?utf-8?B?M2RnZjBkbVpSU1V6QXhuTjhBMWp4Y3dqTHI0SEhZejArZ1ZHbHBycFA2VVRl?=
 =?utf-8?B?NEt3eVFGc0F6VzA1N1NWZjlJL2xMNE5PZXFmTkk4eEpLWUdFNVNWMTl6amZu?=
 =?utf-8?B?aG5ZMUNGdHNiWlVFWWVPdGx4eVIwcHJvVy9jbFlQcmJyM3R4cGpKeXNJQXNM?=
 =?utf-8?B?OUlrY1hwNXVLaitxQ2o3SlQ5VXFvTHhtbVQ2VWZiVHNtWTdWYXlzbVJBejlY?=
 =?utf-8?B?YmlnODc3dDZRZTRySm9VeWE4YXZ0K1JZckRvU2lxYkVMMEwrSFdZa2VuamV6?=
 =?utf-8?B?TzhPZ2JYRWhKMm5ndERvZllJdE4yOFZNUnhtZnVTajM2VnJBTlNZSmxLaXg4?=
 =?utf-8?B?b3J2Wkl2VjdrVkdEY1lnRGIyRHh6MWxNS0RLK0JDdWYzc2RzamRITGlyYnRn?=
 =?utf-8?B?VVFWeEYyZlFURnNlVlVTVE0vcS9SUkp6a1V2Q2ZPNDQ2dHJVNW1SQ3duSjZj?=
 =?utf-8?B?TkhGb0ZkNVVCLzF4Z3JORUNqeTV5QzZMd2tDU2crZWJvMS9BeXFvMlduQUo1?=
 =?utf-8?B?U3huZGQ2RXcxSlQ4UWZ5eG85Y3d6eC82ZjgxZW5TajkrZENjd2dQb0NTUXRi?=
 =?utf-8?B?OXdia204bWFubEdoeVc1WmpnMDc1VE9BM3grV0J4MEpsQUdLOTZ4VGwyTTZz?=
 =?utf-8?B?YWxSY3BXTUUva2lSczVkZDJnTzFMNnBoTGxGbWpLaDZBbVRUQmRaNk90ZWt5?=
 =?utf-8?B?NEUwZFQ0SURrWmM3R1d3WGY1Tk5JbnFDc2lNZ2F1ejdwYmhURUh2Yi9YQ3M4?=
 =?utf-8?B?cDNEcXYyb0huVjJXMW03T3QzcHhraERGa1VOTDJxUFlCWWpnNmRrdHQ5VDFt?=
 =?utf-8?B?QzVpSVZKc0pCczdOZE5YNFdBWlVLL2FBekxPeE5OenZKR2JCck9LVlJ3SUhz?=
 =?utf-8?B?ZVU5cWtKMW9uMjZ0TFlxK0hJUDkvci9yMjdaYUZITjNQL28relI0Zk5iUXEy?=
 =?utf-8?B?T2xMNHlqV2RibTMxbUM3V2p0OFhDS0RHUUVOUTF4N3FIUzZEODViV0QySGxv?=
 =?utf-8?B?dHJUc3BtbkRkVVdHaTJqNjRPdm9Zb2FMY3BJUFQwVWh5VE9SM3hWeUh0aWR6?=
 =?utf-8?B?QUNQUHI2d2l0R1U3bGc2eUphOEVyTUlXMm1QZmgydGdiSnNDcy9GOE5NMVNX?=
 =?utf-8?B?KzhVa0YvWnVhYloxKzhtK1ZEYkRaSGhlM1A5ZGpmZzA2eW82L2tlc1pUVlJa?=
 =?utf-8?B?empSdzlxbWI3VklTZHNoT2xLSWYzWWJFZ3FOZnp0TkZCbVNTSGpJbUZTRnZ5?=
 =?utf-8?B?TVJIVktEbkNlZkpyWkJrMUU2SVhEeklsNnB0bXNYZDVjVFhXYzBMTitQa1Jm?=
 =?utf-8?Q?HGvXQpBF9Jxf2cUBqw+sEKY2rP2UPi6nVT9v6l7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFlpUk9FLzdMSm1yZEVubGJMck9ZWnNSWk9qWkJPYy9tNll3SUlzYytWKzYv?=
 =?utf-8?B?Uy83Vk42cU8wMUN1a1l6MU9VTHZkeGNoa2xNMlo1bVpSMm9YQ3NwbXhIVUFq?=
 =?utf-8?B?NzVLU08ybStYVWJ5ZHpHbjhRTXhjQkRXV1JDVHNXOXdjcVVjcFo5NHp2Qkhp?=
 =?utf-8?B?d1R0cWFBbE83Qy83UlRvZlh6UzEyWVQ3b0tMNVZ5ZUlPSTl2bktHUGRLYkFR?=
 =?utf-8?B?bmxwcmxlUXp4WS9Vc0ZYQ1NzdUVVZlFNakR2VEZEaTExSVJsOW9tNk0vSEZG?=
 =?utf-8?B?Vktia0Y1SFJFVHRCT2xSRE4zZnhrYmhscjBHQW9rYW5EeVh0WVVkc0JmY0pw?=
 =?utf-8?B?eFdSRTJiZ2lnREdWR3BzblIwNE1CVHV2cnFrNjViK1NoTnpmMFc3MWZ2Kzdv?=
 =?utf-8?B?S1MwNnVjcHpOUGFyc0tlWE5Edk9ZQjVTSzlsWGNUREhhaTdOcUVWSnRNQzZh?=
 =?utf-8?B?b040Yjg4TXZBNkpGMHpTcmxNZWdBeW1Xcm4raFAwd2wyRStNbjYwa1lDWHZa?=
 =?utf-8?B?VFhTdzhGMjZMK2dVWVZVU1g5K1g0dXhsZUpPb2ZrYnJqZXJ1MTVoTFhmWk10?=
 =?utf-8?B?dHVybUZFUTQwL0NTWFVDcHhBZkwxZ1ZNQjJyR3lJLzRmcDRndDBvd20rajBl?=
 =?utf-8?B?SmhmOHB4aWlsb1VxME1KMGdpSmZGdUNjNU5oVmtMWlh3dkRNNlBzZk5jcE9p?=
 =?utf-8?B?WW9Tcnk4ekJSOGJNN0xKbklpRWNaa05Od0FwWFh1WjRyYm1yVDN5VEhPelpy?=
 =?utf-8?B?bGhxR2o4VGRIVGt4cDlMUWt2T1lpb211ZTBCUXBCTVY1VmNFWnliSSs4bThW?=
 =?utf-8?B?Q2gvbEJDMXVleHl1WC9YSk03RlZIS3o4cENjcVVrNHlwMGJpSHJYQUtqN0NU?=
 =?utf-8?B?bmxaN1k3aFFCeVpZQXZLVVlzQkMwRzkyQmMrUUxHeWViUnVaM2gyajJBUlFS?=
 =?utf-8?B?Tm5QbVZvSUZjd3krL2NmQkxHZ2dJbWdpb0Y1ZkYwZXNzK2M5Nk8yVnY1UFU3?=
 =?utf-8?B?VGxXdjBycjFIT0FtY0s0NU5DOUhtY3ZXS3dVVWlMUnc3SExVWVJzRXZETlNZ?=
 =?utf-8?B?VjJCcG5UejN2T0c0V2Vza2hhcVVEeWE5K09DY0hNYUVUcHZIR3Vib3FMWStF?=
 =?utf-8?B?RklWZWhlZVp4U3ZXbVhDT1N5VVBLRWpORzhaYllDcFdDdWpOTHIwdFAvYit6?=
 =?utf-8?B?d3lSbTgwOXkxMGl4UnpkUERtVmxOWll1VllXcUhmcXJ4UDZ4TDNrVXgxTm5t?=
 =?utf-8?B?dzN4TXZGRkFOVmlxdmhDVnNSOWZmeXhZZjROMlJMOHBMSG9JRE1tL1UyN1Zr?=
 =?utf-8?B?b2FhZXl1UHBrT3dBWGdOdDlmdDZEZTdLeEY5Z212MzJtam1DS2RnK2ZzVnZ5?=
 =?utf-8?B?aWVaVU03UkZpbUtuditrQjY3L3FGeDFjSzN3V3ZFY0FUNUxtOFlqRk0zaGg5?=
 =?utf-8?B?NGJWajJJMjNYTzJUcnJ6cGhWK2xkcEhuRGNGaldDTHZBNGV3b1VmNFprc2Qx?=
 =?utf-8?B?aEJNOXhXNEZOYjVZbVplZFpMc2I1c05RRS9uZ0kycUVNT1pMczIzZnk5ZGVv?=
 =?utf-8?B?akozelFKVlF3N0puQ0p0Nkgzb1RxWXVMdnJiREJiYnliMzdhdDNzSTB5dzZL?=
 =?utf-8?B?TUMwaTlxYXhPaTFPWjhUS2hjN0RsZm9ra3oxR0lZZGxaM2k5Q1VIY0ZMRDkr?=
 =?utf-8?B?aUJ2ZklzdjU1UXY5dzFNaFpLQTRuWEE5VWt3M0Y2MVdOSVowVk52ME9RZWhJ?=
 =?utf-8?B?VDEwTE04c0tRZi9mSGZlU1hvNy9pN1NqN0JEU1dhNkJFY1dYZUo4NnVpR2dt?=
 =?utf-8?B?VjZiV2UwVUtJSmlFbmJpcU54RUhwS0FYQ29LNVBVMXlWTCtRaURCU2E5ckZS?=
 =?utf-8?B?dkswd2pOZDRHSStOWW8zaFcrNnlzUnZrRHZjYlN3Zkk3WFlGb2lCc2xqckhC?=
 =?utf-8?B?bVJDbmVEemxSeW5nZkJDSERXZ1BCT0JJQUlxZTZlMitNQk9RR2hrOHVJVi85?=
 =?utf-8?B?TnZpVUxZaWlnWG5VbHpsdjRCYkpUNjJTaVUwdEJzcmVyMHd1MnRRbEgrSnJJ?=
 =?utf-8?B?NmVnNGNmMG1qNmozbU53VEgxODdEUEZESUZvd0hiVE1XdGxUdmYvVFc5aUFq?=
 =?utf-8?B?VldQOU5JOFpBcTViZFgvbW00eWIrZzVnQmxIbGdPQW1VZVh5SmtYbG5qOVdV?=
 =?utf-8?Q?ulRoptXJNVzUl6rGsNniFnE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hnR2NO3zcjt+EFTD5VpUMDqSEaUZXQegYKxJB9IG0xS/ljkcREyxnZhnzFC81CRK1EgBXKQTrAuqWovL3N2aoScOJIprai6+2bSVestkTD0KN+wMZBJnf9LGCTBnPsf9m8th9CTc577q83JtoenQsDxfVl+0F1P7XgoTBtYyvRWy3UazBuI1qzn0EomBtxWbxoY39kYJ4Ak9owo5TcpP4fjnrSUKZ8OnGl1PxFhRV1UuR2LTz2+wQzvtnVyxBlbklwlE6a4tvz4f+7BMuoIuobKFdfbds5H63EQfOjvdpN5Uo2T5m2coRZe/Lgb3cvcV7I62rPZZwGh2/TtaZwOUrMrxbxNKGoGVEt5AMCLJytxOj5y7cpEA+nk0VVBfghv8ItTN+7bR4iiyIyEGp6bkdpDOKX7np01EtIe5LlyQy7LcX9gcwUIEIHxaHqHBt3EWxzpAjRCu9hJ1r1Ps2GrS7dVv1daeBI83E/SZuNW3Ca2ucrDonLFSsgxVuGUw679Qhm/URtM1YT7qE9u+1kUNgseWGshfCiYHjdiQ5beCnZkFmX+dhQqaw0NrwW/nDl3pFljw/emUtqQYdi4KjIaqNvmZ30oIKttMMz9D9EN4cx8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e497feb5-f47c-4eca-80b7-08dd00d8774f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 16:06:27.4387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDF0Yb+ZV8YU2GZPmbnpXzh6NQOt1KAaK72Bn3balRlhmwteZ3mTZ+Hpaejx2qn34ezkOXHcuqX7DqgZY5xuXUIz8Xq+crUdGPIzBTk2UNa9Zo9wjRkq8NBIqgwc0SoU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_15,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090138
X-Proofpoint-GUID: SpgCeZ5lh5VQrxapJq8coEsZjxoc1y7R
X-Proofpoint-ORIG-GUID: SpgCeZ5lh5VQrxapJq8coEsZjxoc1y7R

Hi Greg,

On 06/11/24 17:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.60 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

