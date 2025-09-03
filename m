Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF6817A2F6
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756925429; cv=fail; b=ucYoSWp6HqHDLglQV4vh29a4fD0eqJ7YfHmPg/Ufq6lRlPfJ+LX/M48jPCfFN4bj3MqKyqxl2qXUNdj9ZlAEfA9r4KfwL7aFBuz/ADpi9AMfG/lZdttCJYfxB5DVnITToTqg5P/bviKVrb1ErzhB4vu46p7/RRSYdypS7bg1Otk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756925429; c=relaxed/simple;
	bh=DT1PSIryNPb1x2UFVm1JlScWecvhC5FYtOyrYOdtvb0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mo4qk8k2CW4Id7kgXGo+ktTapHfjfoB44vJN/wNuwMJT7EDTHQya7jkv/eN4x25gddYp8jz4iFkCOrLHTURf9p9ZeTOSGW2J+Z3nBhxH2jJMK4d/ueA7m0CViqe+TdtJybJ4jQTe+VxWB827crLA5AuruWhOEwx8fxEyMc9LtJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j0rFFpzJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UnjgCJ6K; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j0rFFpzJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UnjgCJ6K"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 583HUk1D026778;
	Wed, 3 Sep 2025 18:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7IB0ocIt/r/Mr5F4NqCFuL+hk3UN+RXhXvYHFYJ4/A8=; b=
	j0rFFpzJPsV/FDf1T8xwGAJ4HOEk96LSwQn2XM409fAzVCeSZCH23bopg6S1Eu/m
	obeb3esOmvdSkLE33Ou2Ik/QRrkboJ3ol/nXjJ0QfM501pobcieqsZoIGE9B7LTT
	W3LgMak4rEjqbSNT/KuuvTiOa1j4Gyk5BqrnX1bxZHGvlmwbfEoXwephlEd5ZzXU
	Swp5Pwl7eg7ibKXxf8muTL3cPVXCV5s/cGmthcgGRvH29c9TuJzIgJaMH9GvnFu5
	3fWV7NUX7dY81+0BK6RBJTkE2opF51ooqS+wVBHo+SmNG8HZiy85ED7Zylj+8F55
	HimMB2lI1/An1NB7ldnyrA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48xt4ur5pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 18:50:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583H4lX1040046;
	Wed, 3 Sep 2025 18:50:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrgrqrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 18:50:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KPTNgyhuBnpQnjbYoT8PIZg4Cvw6O+cf/NbHYd2K3EVXY8WrNy25V2p8vPwKD5qjUU/34WqZYa7129ILeuI4LLOlkkyErEG7lH/2IRtSg7SlgZjXAAzXwDL9+13nvJN3Rdmu4SLzJzx1wXDqeq2gbSPXojZAhIM0xdsmSC2YHlMKuLZSaz5+4WJbCabUjQeEhc2FwNdiiizvbCAM/Cy6auoiHUbUnxvod80DYkOdw2RPgos/sb6If0NCDa3Cm1IgrXn6ju5WfoxGuxyBZN/BslRKDCnoxYrhLzdAiibS19i51DtWefmbOMT7RiYvhTMmbahWcynLLcRxiJgO0HVEeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IB0ocIt/r/Mr5F4NqCFuL+hk3UN+RXhXvYHFYJ4/A8=;
 b=HD+/hwuP4Echgu3kuoKatEqlswSmFNd+Bnykm0sSGrI4sbeEJDwrRSc1FeEAS3kkv4FMlWrjvRj15U2koFxzCjtZqj/LHVyrS4REk9YGjxHHJLEECqpXy+u4lK35ZdnlCcK1zI+cqG5JpYM89T4BHcqRvg1KS3inebGm2vghWpwEE7WAvlCpbqk3xTwG+xtepxJFc0cdeRK2THWff6m/QJUrc1kNaHXq+9eBr6bFuiaMLf+hJQacGkp+qTkFzoSKkXKAbi715/GEg1s+qJ34m8c5a5dk4LRVjGHD/7rjYmY6gob/JanUhuqAvfAoMH1Bcch7SVNnKGkUT5D7Y5a+2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IB0ocIt/r/Mr5F4NqCFuL+hk3UN+RXhXvYHFYJ4/A8=;
 b=UnjgCJ6KwC6BHgw7KdjuMsqFqxq1cN54HT3OvJwt0KKivrHkFpDpQVbFScPhJ2tGvly1+d2SyeLHAXO2tXVGdu6JjhFvzZEAUSMbKif/TqFnMbrXOFEZ4NFZqaSKOKe4ofNQFRXjM6VLLqjtdYi1b2fMkrfW7I/Y/pUZhNRjJgU=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by SJ5PPF7F0BE85A1.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ad) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.29; Wed, 3 Sep
 2025 18:49:57 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 18:49:57 +0000
Message-ID: <fae50ca1-4217-4559-9796-9a044797ebeb@oracle.com>
Date: Thu, 4 Sep 2025 00:19:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 5.4 00/23] 5.4.298-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org
References: <20250902131924.720400762@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0409.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::9) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|SJ5PPF7F0BE85A1:EE_
X-MS-Office365-Filtering-Correlation-Id: fd33e922-ad82-41d4-a166-08ddeb1aad9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWU1Q3pZSzhMbHVCUU9lMlVtWFJqaDYzc2ptVzROejA4cjVaSlNSQVg2TVBE?=
 =?utf-8?B?M2RVVGRHdUxueDZGazA2ZHB3WW9ZcHJpbFEyd281VXh2Y09mZ2o0dVdxa0gw?=
 =?utf-8?B?NlZMYjZBdjdwS1RDVEdnaDM3NnpBSWtNMkJ2MTd1ZE1XK1VJeVAvbU5GZk5y?=
 =?utf-8?B?QjdwNlV3ZHBDMi8vekw5UVQxL1Zxd2puUjh0Q1ltVldITWJWeUVWR3g5WjdN?=
 =?utf-8?B?bDVPVW5UL2VkRklMbVdsRFpyd1JLS1Z4Tzd3cWJMeGZtMEd3T0dlNzRsWGdQ?=
 =?utf-8?B?WTJNYzg5bHh3TERrem0xREJCRWhmMDlzcG50VGFhNUN3UVArNEQwalZzeXk3?=
 =?utf-8?B?WVcxYWc2L1hXQU44MGF2cUxWU29GVmQ4bFhrMU5QSjk1ZEVTcCtvVzFOd0dz?=
 =?utf-8?B?Rmt1c2V1MnRLaE12ckQxSEp2YmRZbE1GbUxzN0dZQ2htUzA4V05lcHF5TnBr?=
 =?utf-8?B?d3BvRlc4cVMxeGhxSFUwYjBRclg1R1p3TXllc1RmSm1LMXRHRVp5RzJuVjV2?=
 =?utf-8?B?dGcvQ08yNVVnYm0xV21vMDNSVkoxenRQdzA2ZEs4WHVibjdwZ29YZ2hSUjVW?=
 =?utf-8?B?RzFlWTBNcWpHeXp1c2VzcTN0VFRnTEY2S015c3N0cEdtc0tiYVZuRTg4M09x?=
 =?utf-8?B?czY4cXovMzFuZjB2dlVQdDZlNW1rS1BWSllkZDJ5WU4wL3VtYTZKZXkwLzVj?=
 =?utf-8?B?ZS9mMG0zZG1lOW40UjdrR21hTWxQZXI3VjVNZVlBTHd5Z08xeW9vTjJkaVZn?=
 =?utf-8?B?dGx1TnQ1WDh2blRBSnVoZHRWbnhDem5kV3FDMk5rNDRveTdBU0wzMTBjbStR?=
 =?utf-8?B?Yktlb21QSFVvKzhwZkN2WXpBcWlvNTJqYTJXZGRWSUxuOHBNWURwNWpKNjg2?=
 =?utf-8?B?RlBGa0x5YnNQeU1oak8ySk5YWG1xL0hqZ0J6WG02c2I2UlU1WVgydXVwdUtC?=
 =?utf-8?B?UkVvSTcwYWlCUStZMlRKSmlySmxrRXFzaUM4b2poRU9pUnJKdFhmdXRNOFBQ?=
 =?utf-8?B?ZDJUU1dRb3NCeUlhTDRHWnBUQUd6OXQ0Ukc1VC9KTW0vdlNxV3M1MjRoejVM?=
 =?utf-8?B?K2kyKzFvYTRHRk5td2UzNXhkU3FsTE54V1N2Q2Zwa2Y1bXZZc2RRZDJWalVI?=
 =?utf-8?B?UGJCQWhGNGRoUEo4dXZOR1IyTkxmVkVicUtXMVFvQ043OHVsTno1b2JzN0lx?=
 =?utf-8?B?RzUxWEdaakpwQ2ZoQWFZdXdFeUhBcnhqZ2NxbnhmRzc5dEtaaTYvaG9sbS9T?=
 =?utf-8?B?M2xpNzhncDNZOTRYMlBqeTZBUDhUaU5NY3F6cVNqMGZSdTJRUUt0U2xMaEU2?=
 =?utf-8?B?dW84RmRsZThNSHQ2ZFJaNi9GdS9PaXRZQStxTVFtSTZHcXpxK0RmQWhUSzFy?=
 =?utf-8?B?bVRieVR1VHN0clJNanpybEpaNjZidlduMllzT3lmdExWVmZVdVNxV1BlNFZ3?=
 =?utf-8?B?WkF3SHg3b2wxRlNnVnJuZEZ4OGxUUFdpQTl1TXdDTFZxT21PaWpnMy84amlS?=
 =?utf-8?B?YzV6Q0FnelpTbmdxa0xoc3Z0TlpvMmVaelJjR3dhVnp2TEpIaldJSDBpMTJY?=
 =?utf-8?B?bEljYWliU1RsVVQ2bnAvK3Q4QVlWU1V1L3JJZU5YeHBqL2g5eGUvUmU3NmdD?=
 =?utf-8?B?cy93MFp1WDVJUFovRFRucGtOaWZzRmRReUtzTHpTeWNYaDcrK2NrQWM4Snpy?=
 =?utf-8?B?Q2p3OFgyYUJNUzk3dU9xUk9YbmgwTkgvOFNqVEpuWk5tejFZUWozRVlpWHRi?=
 =?utf-8?B?SlplWWo3UUkzM3prTFlzWXJCQlpJYzZjMVJYaC9IWTd3ZStFQVJlcmZYMjlP?=
 =?utf-8?Q?t2tJY3D7Yo5ejrVEYi9rY3OhLXCg8exa6tzyU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzcrYkgyZ2pOWjd5ekp5OU9waGQvUkJybGNyMVMvV3JvTDY4eFZ1YVRUSUdn?=
 =?utf-8?B?M0RMdkJsVDZDNU5lbUZ0NXVJTzRKdHBDU3A4NUFSY0tQd2d4QkwyVy8yNFA4?=
 =?utf-8?B?ZEgyckVGSmJpSEppVENrYVFrazRFZU5ZY3BYWFZIZFh0Z3FYQ3V2UEN3cGQv?=
 =?utf-8?B?OFUxYzd1bis3bmFNMkxYbGZRY2tmc1hzeC9vRnYxRm52TWg1bTdNU25ZdnhR?=
 =?utf-8?B?UitRdDJaWDV3b0tDempHODdjTkRUam85K0pSU0t5SkFCTDdvRmg5emtmZmpE?=
 =?utf-8?B?VWNaa085OXZTQVZhQWtMRzBVSERtOFFnMlFSRTdpUXZ2MGJmSWNYYjJYNUtU?=
 =?utf-8?B?L3BmOGp6Zmp6bEhQUWJIY25VMHJlOGQvMExyNUIrZjRmWE94dWU4dDU3VERo?=
 =?utf-8?B?OTkzbUM0aWw4N0lJSEEvbEpudi96MThuRGxTV0FZQTNnWjR0bmROVmlTOHJY?=
 =?utf-8?B?cmhGM2RYTWVMRTJJTEhRWElyV2M3bjBCK2VPZjlySmtET2xDVTlBY2tZK1ZW?=
 =?utf-8?B?SWYxUE5NcTZmSUhYZFdsUDZRd3p4TFlhNUg4aXhXWTcyYjVFcWlSYlc1Zytn?=
 =?utf-8?B?alF3QnJ5cUdlbW9CWGR6OGJ4MzRxdS9hYXRvYm9lamdudXRDU09PRWkvUUxt?=
 =?utf-8?B?S0w2aG9RSGt5amNkTWpMdjFKd3JFb1RuUjZqanVJdWF1RzgwSUN3S2ZxRnE4?=
 =?utf-8?B?MUJPUEFxZWJjUEZHYmU0d1ZNa1YxSS9lejZDcGlrSUoxQWJBdUEzTXFyaUdW?=
 =?utf-8?B?dUY1Z0NWTXBKL0lVZ1I0WGxYYUpBYmpVZTA2TEhNc1QzQ2pBaTdkd2ptY21I?=
 =?utf-8?B?TnRid3MyRys0KzdiVUd5aHVRcE0yVTFPUTdOTTRRZE01eVJnMUdEUWdVUVQv?=
 =?utf-8?B?UVFNWDh4WnpyUGpZd0QrQjdFSWhrUjV4ek1kT3lGVzVYL090emRlRHVtS0Z3?=
 =?utf-8?B?MWNHcmt4R0VnZkpPUVd2YVh1NmN4UlloOHFUUnJTNVUxY2I4WlQyaFdaOTZp?=
 =?utf-8?B?akMwemhCaWtmNFJySWgyN0xJYjNEblRRNk9EejYzM2dkaVV2aXJ0UHBHTTY3?=
 =?utf-8?B?b2wxekdDR2lTSzcvaW0ycm9UNHJUUVExZlg1UWl3bWpLT0pyaGZySDJjdTEr?=
 =?utf-8?B?OFZteEhJZXNrOFlqMUttV1NZbi9vbGFJVi92MFFqUXk1dWM4L2dSWEl6Y3hS?=
 =?utf-8?B?U0hGOXhwWVFQNy85V056RXppY2ZERzhBWXQ4b1ZuZlo2K1pWZS9vQ0FIUHVv?=
 =?utf-8?B?WkpwTC9sSGVFTXRGbWVUeHdYSVlwMFlHcHhZMWdLZWpnd3BmeSsvSFRwYUZN?=
 =?utf-8?B?UThnWll2UGRiT2FrMHZIbEFQdit2TjBtK0VBY216b2RkK3pkcVR3NnQ5VUxm?=
 =?utf-8?B?ZmpiMkFoM0YyWjExd1RvUlpnUGxCTXJxcFRsV01QODdzWVV1bFE5aDFXeDZB?=
 =?utf-8?B?NFJITU1MQ1pyMjIxbmFnVXNieGVjSVRaWkU5OXRzd25Fc3VKRVdwVGFQVWYr?=
 =?utf-8?B?MlRIRWk1Vk1GYW1RaUdGaXVhbUZrZS9NRTJmZVZPSzhsOVJUUVFjL1pyYWpF?=
 =?utf-8?B?SjM2MXhxUlUvbWR3cjlTMDVUMUpSd0U0aUxsZWVhQjlIVVNlQS9PUXFKMnNE?=
 =?utf-8?B?TEc2RFVCVXdhNjZjZS9JWU1FVENlNjgwVHVQbHhvdGM2a0U4cDB2dGFPRnRL?=
 =?utf-8?B?THhkWkZUd25iaGZUT1FXbjllOTBqVU5IWDZRMnZVaUJtRjYrWVE1M09GcFF4?=
 =?utf-8?B?UmRVTWZ2cGhYZHk3T2JacFdiZGNjT2lVTG5PaGRLSmczdGFrUUYzejEwbDlE?=
 =?utf-8?B?Ull3K2M0QmJ0RWRteS8yaHBFTGNEb2tVZ3k4dXN3ZUVoekg4VnI4NHBIL2Jm?=
 =?utf-8?B?Ykp4azRUS2prUkVRaThjUStzWTFzRWtTaWt6QmczQ2xRa0p3VEFTc1RQT0hQ?=
 =?utf-8?B?ZG9ubVZyTGJTbEF3Q3hMUTlndmZrbXo3cUhTb0lHU3pkb3dNT2RkWkludWNK?=
 =?utf-8?B?RVZrd09tOTdXRy82ekhFRXRuQnlGL1pFMzhTWW9uNFRRMHJNdy82bER1WDZm?=
 =?utf-8?B?bHhOc01BaGt6MXBXd1pUU01tMm8yZk04M29ZWDFXZmdFbTBqWGZzRGd6b05X?=
 =?utf-8?B?cnUzSTBLaCtiWVhmRWZrZUZlTExRcDJtelhUZmVTVVYvZWpkSDdGcCswYlQx?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X9A0Yjs0ZP5Azk1ZOJ+RQMsIm7qdZ5oHZCxYN/CE3VmCypsf49Tcxo8OwlmuHIo6oyDeBASGvpim89frN/N1ZIR592bGWaGL591S0yZQkE1Rqp/lC5+TgdT0z7AwprddAFkQKlM6nQGz4tptAjmK1D6ZINo6FXq8L1Pu4JhffODZU4gighuhl5HhySNICloSVgk+dkMrlBfOOaaYqa6XLLKeSqbvVkqxz6FF0GehQ2ZLhi55bduoGjQzuls0HBFjlege5ULZSwvkYtyYrT8OmosUOHT/oXVtj+kjCJ40ixCjU0v5hpI4z9kNB2OrQi3j6RtKilmBOJUubFICqYDSt97JcjK7bKJ+K/46e/pLpe/ceYhQv3lQgAGzhLA6dM8jpKKWhcTnAmbRZ2l+1W4gxbYhzUUmRr3FCKZQ9FgyXlQn1YbC/U12fw87sNsM57zK5+5OdHZbIMnkuMmG7CHxIDRcKcRJhT8MunmrvBYhWjDwGCXiIf/eEWt3ArFnSUUDS3HKn/H93nErj0r00L7e6tjCuSv2LLW0No0SSnnrz4H0c73FBzru3KdWMG8X293Oz226umfkYXBESs0eDxoOz9Ke12fy8lplPBNVskjKNZg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd33e922-ad82-41d4-a166-08ddeb1aad9f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 18:49:57.3660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCKjbutsJjWoEg7dkC2VweFoYYPTmxFlg0xUFWgus1gP0dSW2qOSNSSBx2nWFBG1m3MqtB1NpHW3WQRW/zHr8QIg1uBaXuA3asEGQ22jM4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF7F0BE85A1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_09,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509030189
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAzMDE3NSBTYWx0ZWRfXwdHCnWmLOvUD
 LeeZu7bcuECRZQ0SqPOo29XQ8SxgGNudn1miTbAoN9krJxEjAjyfYnSH3UjOJYMhWfK6XPpPb72
 3jUoWC6CvFnfeLV5XdSumwGEHZSKQnv+ZS7IE/RbAnhbmJZHFl+7tugomZONoodcmG5TTzF7WEc
 RTeX4J00u1pEMKlQ+Bj81aywzq0Mtf3ORphuh6ZE6V5GnyMttAEobA0iYY9sq2t+Yty9XVjBuVa
 6DGwGqseJHGGfefyYQYKuOpE/j0EStYO27PBAY1oEwzkHHJO4OSc7T5MPcAI5fWFtTH2Nd8JAea
 Z76wpjsm3weyYB5e6gABWx3SEnrxdAQmyxcs0lVPm1z+UAY34/HE7UKIRKfOg8m+jIwA1jhWIwG
 3KbZip2mX34Xg5eZjAv1mXxwEJ8c6Q==
X-Proofpoint-GUID: Oqh2yGA0AH9_WPz8Xcr_ZUZ-RFlMqILl
X-Authority-Analysis: v=2.4 cv=H+Dbw/Yi c=1 sm=1 tr=0 ts=68b88ddb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=GlXC03V7Biz4-D-HH7sA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: Oqh2yGA0AH9_WPz8Xcr_ZUZ-RFlMqILl

Hi Greg,

On 9/2/2025 6:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.298 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.298-rc1.gz__;!!ACWV5N9M2RV99hQ! 
> MWDhCla56D8HkyAAm4CBeNdLFan0vRy4dAycMtfqFaf_VQIVzK3dbCrTWuEmzYW7_aa-o- 
> JmonbZlCGZiVHle24_WQ$ 
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok
