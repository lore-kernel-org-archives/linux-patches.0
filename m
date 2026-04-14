Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81313E5ECA
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776177094; cv=fail; b=CSgxf3mvVRmnVjzbfE8im/5uQUsr+zDEv4jZ2cDaJ5eYZ2OwolvVD9Duy+YVPJy1YE6lCs9cOONstSel4dX91L0vAjFWOo0U88zS9klORelP9S9UMyL9ygsjHItgk1y4BtoSV527LHbSSoKKECH2YY5IR9xM1LwE2ZYJqpBh7cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776177094; c=relaxed/simple;
	bh=WQ4WlzDUObT4ls+/zhER4qMMDBmB5M/SrvbDlYiA4a0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DyzYHc5SjFS+149E5NBQTkbHyZJepT1zqPH59J74umInQY0vNsOYtuAaCz42iLgJoaKrDPZLajXPIKDW1/Tfn+6U7tsIDtUReiV4v2laBNKG1zffdFk4v+2qq0Cc3+lrspGrqhel5FdUabGYG5Y50il6m+GKOCmQnknPKvn+ZtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T9k5tNZN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qS4pybPf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T9k5tNZN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qS4pybPf"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EB15Fj1674022;
	Tue, 14 Apr 2026 14:31:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Wl+v2LwlPG5IyMUNF2Uf/mn7pJOeJ1/7f+GYE02OarA=; b=
	T9k5tNZNqXNvOKWJ57GGwvMEQhaa0CujdQl+9Ot/DJTmaT0nMfGog9nMLzVQQukN
	FOwsID7MlMHAB9htJ/zxehEfT0xHLxCcyIOjE/5kEXp5InE6/xJ9Daz7oj6MlY/V
	A9vxnVUdoAWaNR0wDjhhSsLIXo76x+BQk1cXmY5irs9Bg+YvZ5+5+KZhLGC9D3S8
	C0w1z1K5eN/JoiNOpNrSLgIZNW1ui3nfyPK/YHnbO+GS7cNMbWM9Be26I+acujDk
	McmORcb7USAPG5VCtCGtDONJ5a07DaV3VQL3OsVcU+HTSoLaMIsPsbh2UyeB4oOL
	PeWW/3tn8Va3Rm2jQHfYUw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85jjsce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 14:31:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63EETLnL011693;
	Tue, 14 Apr 2026 14:31:11 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7njsr1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 14:31:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ldxmsQOM1XSaYnNPYkyaUS3zz+UJXZqsNfzFD7LFIURalCWhRa8lXMm6o3OZBt2A9d1Sbczfx1533FL8GZ1hs8VuE6LMcLqIAuwGWnc9s8wBVBf30soEpSA0ojRNK5/2RvEDyfnLv6CPFQzm8Qg8epgKCuhsBAqIUMQaXYE9+6/BF/LbNdzNsQHNvWtMGvNX51p+B1D9ns4s0XatdH8K9/Ey7O6RGg8VJYpgc9SIv5k9Qsa4HVWJ7brGdw49A4assqCpNbFbk2RAfFAr6Ibs6PYnQ7CkYY13n4TPkP60UMpQKJ6fRvL3eJ15DX3Fn55Mf5hGUSGSGmbaHUeCLOfCWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wl+v2LwlPG5IyMUNF2Uf/mn7pJOeJ1/7f+GYE02OarA=;
 b=wV4Fnrh0cbRx8yXNJmTSsiqi92mEkIXci6gRMsw1fTG8gEC2EuMHo+BAVL40zOOPb3i6rSx5p9pMMeIa18BjJlHPPcNSknZXm4bY2lRrqs+auFO9UcN5T8es6CaLEHwtlKZbt6vxQR2oRpRDwrvIP4fkHpSN1phat7WFL8YFayM/ITKzS+LumFU3WIqZvAlzdAzAUcCF20zoB2TmLAJ5vl/XTTMJmxgt0x1uCMgWZCmtqk/Up37aWEUOImit9DRDyLEnnVDw/xKOi9DT1zCzsKnWXYqVRAv0O4HS+5CEj6xHGsr1g+YRJL+EvtDqRi9x5HqlAPs7DBuSyvWAUMlcnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wl+v2LwlPG5IyMUNF2Uf/mn7pJOeJ1/7f+GYE02OarA=;
 b=qS4pybPfj/O2o7EKzlr+rH+sgM6dN6iBZSm3WpN/p2uuzsGmvOYpmADF+2AZc1eZpZVLJNcycVYHoZ/3ng4cB2RpmLPLu6Nwu+UfSjCG4+5OTK3hecK7Ojh3NU/XKUi/cgfrXzQFXx3Sv4lG5xuKtnTPapu+v3ZT6n6VpRD6E58=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by MW5PR10MB5826.namprd10.prod.outlook.com (2603:10b6:303:19b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 14:31:04 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef%6]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 14:31:04 +0000
Message-ID: <79919d7e-ed54-4c87-ad0f-5542c111a086@oracle.com>
Date: Tue, 14 Apr 2026 20:00:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/570] 5.15.203-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260413155830.386096114@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0087.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::27) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|MW5PR10MB5826:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d14e93c-da6e-4dd9-16a4-08de9a3274ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	zfSbO9IAqtTIbQXyCZpwZXjSwj7/hYrDEFvAsRQijXMh+HN4jLs1OK2TuRyNFd/toIxFCQprxJAKyOprDt9/2mvlrRK/afl8wnEvJ+WwEecFu6q6IRGIRiFHHjvUKYdRAZEX3oPYrgEmM/gbVDGl/J4Nirj0fFN8xxqSYF2n/i/+TMz1NgjfLj6WRSKNGdKOKK+jI7I3mOT9spirzI5jlP2JnZ6tpgqwjVFBaiBIKvePScQoIImptQ+CSPXHgkQveHLYkicPvYDDfIv5uHkdpnGEUr6Nd1KRN6zBvud/eoJhipOKYLRyfvBMvWdDvGl/Z4hYLDjAKWM5L+Tm//4hqfYScNp2j8rbLgGZwaFNS2IrniRcrTvjLDafWDPysGTQUCqGu0mpP3s1jl2qEx1xCmzszDjDnPXvqrj4Di9RIfpjrnEqbE7TOaN+A1AcQAEX/GqIx4SPNnFN+1XyH8QRUPdGsPZSAlHbxbrOh2uLw11udjOFKeRbLptJPINQ8XJvVFHP9Dt/poXYCeDFBM7uUROHHiXkluHwCysTtrTWu/cjq7tQXXn/o01vyqCca3hpdHqxe5G0Ny8E27JDPChfiiC+YfI0R3yQpqQLnxlisv7zALRUYxTG06e4M/fayqeMQnXQ3MVg7DJ6tsA7E67Ksdi8jOeHXYBmt7uMB4MbzYEAXnKcGoa3Wi8K+sNbGhAJ7rEBUTSYzeRkf5SARF/jM8i/Qeb+ARLcd0rhj7E5pBrtGHxwYqD68f61gEOjVJg2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGRXNGMxdGxqN0R1dVVkSEFTL1JTQllUbGdRY0E2T0I1N3VQa0N2VnpCN0Jx?=
 =?utf-8?B?UFpUVlA0Q1A1ZDVjc1BNQlRvZloyRkRUNTV1WnlvMlpQSlFWbTRaeFdyem5k?=
 =?utf-8?B?Q29OMktIWk5Rd2JXeVhOK08ydWpwbG5leEpvTndQWmtoN0ZybGJ5ZFBCVlBV?=
 =?utf-8?B?R0o3YWRLaG9CclFIVVcyYjNZTUJ5V0k4bEd0Ni9RVTVGczkyUmg1MnVXNUZJ?=
 =?utf-8?B?dnA1VzhvMWZYT3BNcmxnbE1zdEpXSUlrMFdaWDU3YVBzVnZreWIrdmFIbk54?=
 =?utf-8?B?Y2laZzBrczFRdVhvV1ZrY3ROV3VIczVMd2JNdGROb09zQXpqT3l3YUU4NTha?=
 =?utf-8?B?aE0zbERCcHdLclJuK1RYWVo1S3NuQlNydXRJeWphaHRPdFYvVkFZRDl1S0Rw?=
 =?utf-8?B?WUZFOHZuVll3ZzZrZlliUVkrS0ZOa05IbGRKOU1lcS9WRlQySmpLVTdEWnFa?=
 =?utf-8?B?ekRwZk54VG4vUTlPZXozWWVOdkNRSTBodlFoQllMdkpBU3M3V2duVXE4RS9T?=
 =?utf-8?B?UzRsU0RMekxTTURzOTdUYnpBdEVEckV4bE1IYk8yNlRkbFdlaXU1bEhzZFpk?=
 =?utf-8?B?M0paZVI2UVBIdVBNV01UNVpOZXRRYjl3ck9UZVhySk8rSGlCTk9TR0xvOWJF?=
 =?utf-8?B?VmlUWlNGRWJheVNnNW00ZW94N3BDVlF5TENucWVDcDh1M0pDVnJKYi94d1Mw?=
 =?utf-8?B?Q1VKSDJaWDJ1TWVHaVlxdmptci9KQ1RjZGk2cW0ybHViY21NSG0rbjVnbGxr?=
 =?utf-8?B?WGhwUzlXVFFVeHRTQUQyZXU2cUI4Y0R2UlF1VDMyZndweXdSTFNIQTdFVE5s?=
 =?utf-8?B?VStlY2cxQXJYNXpBL3lRMmpSeHdwY0QzZHRjWDAxN1ZlL3oyVWZ2L25iZ04w?=
 =?utf-8?B?cXFzL1dVNzJORXkzc3dhNGNtVGhOOWk0a2ljYjlwbEZvSnRwa08xMmI1QSt5?=
 =?utf-8?B?S2NlZjBtenhqaGdWKytRK1JvcE9ucVRxYTd5NnNVcVlWTGpReWp3OWZ6d3JB?=
 =?utf-8?B?bXFkWWlkZS92UVIvVnl3eFJVdnI2RTZ2dVZHT0kwcHYyRXRIUjZzMVFRZE5R?=
 =?utf-8?B?RkMvYkRSWkRpRFV5NG1Xdkp0MnB4R3BDZHkvVm9QNkthSUt6UnhSSW9rUHFB?=
 =?utf-8?B?K2FpbWd2UTdMZXdrNE9OZ2lUZm5KUUVBalJNTmEySUtnYTQ2WUtuRnljbVd2?=
 =?utf-8?B?QVhvaTZDVk1NV0hPZTJENDlQbFNGVEZEQTBNUkFTOEJyQTZBejI1YkErc0NF?=
 =?utf-8?B?bjBhZEtlVDRSeW1QdFl2bHJacUcvUEpnbUk4WTA1VHFFT1lGRXltZTI3dEND?=
 =?utf-8?B?b244aUlnZk85K1R1L1RoM3NUazBOZWphZjY1QzNTMlZ6WjV5Q0hIaWRjclMv?=
 =?utf-8?B?L3NYd3MrcWxXNFFBYXZwMmd0Z0Y4Rk9sVEdYQkNOaW4raXc1WjJxaCtQYWRK?=
 =?utf-8?B?dXEyZElheDJaTktyUzRoalpQdTNUaVN1b2tPbFk5NFlYTW1IOVE2K1RuRTZH?=
 =?utf-8?B?ejVTZWFpbFEvb3UxbmhCS3dzL2hJU3ZmcXJOQW1OdmROVC9sZlIxZzlPa0Ur?=
 =?utf-8?B?U050OXUrTXlCSzJlL0xYQVAvVlp2eVZVQXFEbE5RRjljQ2ErL1FydEFQVE9L?=
 =?utf-8?B?Y1ptbCtMMjlVYVFIWmJvLzZVNW1FaEpYR0l3VVFXRHV4bU9zb2hMWUVhbXpT?=
 =?utf-8?B?eUt3dS9ldnA0UXZERm5IMEVqWDJ4QlJTNnRYYWE3bUpsZkdQRmo0Qk12a0tG?=
 =?utf-8?B?LzdZSktaTkdMNkFUYTNZcGRuTkVxNHpuZU5EdC9VR2NxMUM3bzhBYVlHWTcy?=
 =?utf-8?B?a2kxR1ZRNEk2cHhIVStKL3UyWWlVdVlIQ2JKUFY3VURINURiOVdMM3ZYVWJx?=
 =?utf-8?B?NzI3aGxaQi82VGRveUdud2l4amxJY2JiakFQU3M3YXNWYU1sejhvTFljczMx?=
 =?utf-8?B?YlY1N3JDNW5vZ3E0ekhLWS9rZVZTNU9OcXZOVHpvcVF0NVB5Wmc0K3RNdE9x?=
 =?utf-8?B?VDJUYnJyMGRWMUdPL3gwTVJlYmpBNWJjL3k0L1Nuam52TmtaU0xTS01hdXda?=
 =?utf-8?B?Nzd4eWEzNUx3ZTNMaWZPUU5iK2pnYzhwTExJZHJVS2Y4RWFxV0o0OE1hcXNN?=
 =?utf-8?B?TU9NUElUZlJGbkt3b3dZOHZPQ1ppbmFMcGlqdTRvWkdsdGh5NmprbzdEQUM1?=
 =?utf-8?B?SzArbmVGTksrUlR3bWxpNWdKbmIwVHl6OEVqSXZUalpic2VkR1RtYldYM2hy?=
 =?utf-8?B?M0R5djNQNU5iN0lkL1JVSWFacWdoa0JqQkRyL1lGSVJXSnhsbFBuQVRUTjlO?=
 =?utf-8?B?aVFVREdwZkszUE5qRUNMZVQrWXQyTjIvOTdlWVJTOUpKRmRiM05DaDQwTnRG?=
 =?utf-8?Q?jA8uckUJ2U/h+ODM=3D?=
X-Exchange-RoutingPolicyChecked:
	uWfHrfuyaJvsHzIbejKd/6GJmjrztZRsi7XOXYv4oATGr/MCg4dWMgqk3wpOkSxF2S1U3vOQq59hi7DJflVqclSxbY8weMTFwlE4UARNbJLfZGfHDjA9SmUfMBMA8uynqtsS6bq0ly1Rf+GE/06OBRI0mECQNClMmQfko/5JZqEK+XOhZGG3ZoVtdcan2xOc5a11yUboFwtyq3JKR0Il4H2EHjI1gFSYvF5VSuyRpf/cnRtVmQMGHc6bQHsmj7J/ToeWNLO/Va0yUUXceJma+djsyDJa2xhC5kj4R1TI2Iv7hkXBf5LwUYVcwNrmosSMpFd6OWYJJSJoYYgbVi+Nmw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p0m6deyvff3nFIXK40avUsFMJcnCIHt9jevNatgrAH4b/29SDFXVmCjVFBRzA5frxTvi749DWtVO14dFn7B9qKZEFYFdoTdiKGTgnySqFVd6LKmB3suA5LnVUqlzcjwPcRvBmGfCZeFZAjabaPyVkrss+UgDmEIJW8R4nqQVCmt0/8khCEaSXSHzu7arVg71lzMN89NT38XMqYvL+ky6IhYitX/gAn5mzRH7K5BHk7giR/MIS8tdAYmOvfMvmDJGF4fSUuS5ybvI9fyvfEJDhUNaJoY++mwvTlnwjkDxL0gQaT/NPAxifLPDd19CQyfPXf8IUsv1rjmGB2XgeRb1K1LJZ8Tr0UHVjeDTEZaYx0Z4CeRAVqwrs0Y0jE4IUwWtcB+ix3oqr5SVdlXcYYiiNpjJgC6NV4az2znRlRE8esn/SLF9Fn8cJhN8Xz3zX7NC/dnoUpn2mmirNuthLz9daP7Qb85CXct1K+GR0SzPqN3CHLDzhv/4zDuxaA9HK86fPLduI0L8hMWDIttZ3k0/lYx+8nGfvDVh1ZY12oXfk/aBkCGTvs2bo1NB7d7LMuyUn8dZ2KTWcDtb8gG0rt6DT9fI56eP3ntqXNOMLAAIDNo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d14e93c-da6e-4dd9-16a4-08de9a3274ee
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 14:31:04.8414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LnwfzF9PV4qC2Q2X7q+IbvdvVSrf1O2/suiYGTo0Z5j/Wlki9TtIoiLgX1trmv3WVTC6vJnQLH3JqPQV6wcYRpefAU0HJ33uJX3qsIaYOZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604140136
X-Proofpoint-ORIG-GUID: kq__ArGv1Q_AOhH65tC4JxEbcuXJff3I
X-Proofpoint-GUID: kq__ArGv1Q_AOhH65tC4JxEbcuXJff3I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDEzNiBTYWx0ZWRfX+zD8XSYzIHEy
 vnp6Z5WDZRCaB6fuqfdKlh+pzl/ewVUrBGyI9vWv73N0xkHiYo3AvlrPyhv9FnqrLGvJxEQymTE
 6wzxssjMtDArQ6Ck0VW8fZlKqo1ECrVKazD0A9N5sHMbcCErrqeiYhlvris46/i6Eo4vPMkidn1
 qCP1azFAukLRemGBBETJ982Ld8M74GlvRWwgh0sffAYS9oEvC/IvcHa3wFs7h1PnaBkXXnHwwT2
 z+QqV468/QaHtqxDv/c5iNM3zhVrNyHt1/kNG4BTI78fHRPp+3H6Nv63cdUpYlZ+49kEPhqbeXi
 lej+f12Ub5Np9SCOSUTPFCOGhXCUmBPVB7fj7s5dIDZSMUYG+M4OrRUpwXKhFMSfLEPncfaZ76Z
 XI2JUocUvr3A+uZ+lTKlPODEgsDSuO+A0my489rAJINDyDFp73xwlceHIaN3lyt6fxoZw+3THHY
 idaezTZ10PiaSCnjcCg==
X-Authority-Analysis: v=2.4 cv=Co+PtH4D c=1 sm=1 tr=0 ts=69de4fb0 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=8-vRK6DNSD7UNujOA5sA:9 a=QEXdDO2ut3YA:10



On 13/04/26 9:22 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.203 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.203-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
Hi Greg,

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> 
> thanks,
> 
> greg k-h

