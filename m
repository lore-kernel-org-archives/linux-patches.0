Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA1618452C
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 07:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725264000; cv=fail; b=ZampMKERtUAxeaKchJBhzwgvPVpScc5TitdaSti8s+G7HgGdNOi/N2J4wRRxSx9mk5+egxCjB2rAn9vcYsweJL3FjMkv3lsEhjrY5nyNVUtJkUpHrvLdRnbhs65uNSQCnzhZz624IkyITNq5gbtEM9SyisN2vbOHpweIXmBivvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725264000; c=relaxed/simple;
	bh=au42zqiibKZK3G56wZDlJyKLmg3pHlyqPvE5WaMqFwI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VfAle6kfjxoGo13DtVSTtPe3lcJarNTDoROuP0Og3enRoOwrA5WjNZKKD5cAoYh8hKicXFkGSJlMqcBlc3Et3JMJHV+EKQRWGzvCgrDMtqAI78x59mDeYDGV8/yMZW+0RDIOrw1BfyibPir4L5XfkdyqUCtQhsHfHmac6C/DXg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jcrfrXHF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EeSXDMbO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jcrfrXHF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EeSXDMbO"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4825Im9f018611;
	Mon, 2 Sep 2024 07:59:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=L1BZ/Sb729DCHmQm29kHNX8ZnvOtVmZd6addmufljOo=; b=
	jcrfrXHF/QAacaQ+ATBw4RmRn6y4PJaqkG/aplHzRPIhhWFvMWXmLOEB2jfE9o9q
	0KuUrTSpiFQDHI03+WRvfAsJos3DtEcMpGh/sQ1e0QRlhjgoJ9OLNzDKBVsDiRmO
	6O5Jkeruvp8M/D7LtiP8Zy9CUiT1kd4i/n9NnbqhcANv3iZt59M1NoOMDQplb2JQ
	vsj9Y7u3NzUoS6dUbJXiuyhcpN2v9rfl07U5uUMuEx3ELJAzAew6oOnq4OotKJHx
	FfA0mp11WsPGj+Dp/vwnhHSTXXOAKB8B5BCKYcdwyDUS612obEIQniFa+REP8+8N
	F3EsOsJvLXwsvSVlkvfaWA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41d73j8a9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Sep 2024 07:59:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4826X2ec008926;
	Mon, 2 Sep 2024 07:59:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41bsm6wfpf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Sep 2024 07:59:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QccBksbFLr0NvJTgpSNniHcMVob8uHcGWD17QmO7cxFlSz+ZSljNwbf3/Ma7OiYrtZ/P0EBcRAePYiiXlXE7aVo5vfL4PqwbbwInq4EJy7KEtbEfWGFUUbNjuUWXVGOT3+bi/8GAbCmvtVveYpY/JbLaoY8AFXzJARTFBcdXFcoRxrzOSvkcqx4ZpFIY/brrr4N9YaW4CKYq3WThswrqKw8s4q7JUQED8me0mMNyc77ZtTyYnJWK48zrIKpYfUuGvrZY6OocNachTQPC+llxFQOcM0otmGYLwLa0P/QoUbmCt7wK7CZDQU25WtzBKnZOcDe8xdE13LODmoQwadtNoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1BZ/Sb729DCHmQm29kHNX8ZnvOtVmZd6addmufljOo=;
 b=FQ2XzMpQXx/6qB+FnioTxOmwRXpa2xc2xpLYvno5XzSBWidwBhTJJ2n2r1n0nYuZng7A0H0aLxim2TqAK6E7DAlvQUFiM9sHBR0RiqLHqkIag5pI1iNv6/tCLG49YLeLmKkR5NSmHrt2sqwjKpq13YOinWPnldvdnIFqpBM6ntWqoDg35y32BeAgGnyBG1PsRv2A7fYeZhTOceSxsC71EW1nq8n8WgvkSeCVXGwUStLOueBuBDWecX0ylr2L+qWqShViQG558C8FtKhvI2j8Nuj4bjrxoUGlnboNoRSSIPI2TmbU7MFMhkV84eL3GFPd+Hj2Q55UFnEsPrE8ei0q9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1BZ/Sb729DCHmQm29kHNX8ZnvOtVmZd6addmufljOo=;
 b=EeSXDMbO2Vdu4UYdUw9htdWCbplrT1WUE4gVo3N5k3SNg2+P+BFrv0ORCBz8/EWqgAxHm10fTYEAG/xUQz2HAdu4ALR/dHCe8Fh23dlr+TNFsvzQUwVMZhhlk+aDv9JBNQ6CktsCJ42+9Kc70nkrZJWxevxCI+IObD9ZLr01oWA=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CH0PR10MB4971.namprd10.prod.outlook.com (2603:10b6:610:c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Mon, 2 Sep
 2024 07:59:33 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 07:59:33 +0000
Message-ID: <c6f28cdf-9ec9-4e11-9db2-b3df56d96de2@oracle.com>
Date: Mon, 2 Sep 2024 13:29:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/215] 5.15.166-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240901160823.230213148@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:4:186::13) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CH0PR10MB4971:EE_
X-MS-Office365-Filtering-Correlation-Id: a64511e8-f8a7-466f-920b-08dccb252e2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yi9YQlNWaU5YelNwRjdUdFFGU05tLzJBOWV5ZGdna3MreElWQWtuZWRDMThu?=
 =?utf-8?B?cHVJS2g2SCttd3FsaWx1b1pkT2dTd0dzRUJlRDNLYVBVeWhsY2FrQU9OSVpy?=
 =?utf-8?B?RG1wNFBhTTZWdWQ5VVBpcjduNWk3U2xvNkpGdWNQTzN2UjVQQkJteGhLMXNP?=
 =?utf-8?B?Zm9wM2RSNHQ0OUY1S3o5OVg4L0E4SVZPTElocmw3MkhzdUw3S1Jmd2drb0pa?=
 =?utf-8?B?ZVp1VmVCMzlOWHA3czBDV21JN2VBR0thZ1UrTXhwaks2alorWi9zTW9GaUZr?=
 =?utf-8?B?bkxpbFBMQTUvMDlxUzFmd0tGM3ZwSzhwNFBOTXFLeTVlbjRpYVdjU0lPN3ph?=
 =?utf-8?B?dDVyb2RQeXJwNGd2NnlqR0tTU1RyOGIwdkJka2lCUGhkTXQ4dXlHcG1TNjE2?=
 =?utf-8?B?V25iYUF2WWhhVUkvWURxRWdUdnIwV1oxRnRISmIxQW91TkRqWHJYQ1hBdG1B?=
 =?utf-8?B?R2Nucm1JZHBMUGljanBLSmtnaGl4UTFUalJWUmdqMDR5K0JPNXNLbXhNQUtt?=
 =?utf-8?B?L1I2a1VMUFdHbk01WGpPLy9JdGFUREFJMVpjSDJYVTkyZ2tOSEJZTFd0RUxa?=
 =?utf-8?B?SUppOUdIM1ZPUEJXNm9ubmNuNXZxRXlPZGY0L1NpTmZwTVhIYk0zNEVnbGxU?=
 =?utf-8?B?NUFJVjg1UkU4WFNGaHRnZWx0bUJQYmk4WnFwZDBVdndwVFFRbUova2Z6QjR4?=
 =?utf-8?B?ek5kS3pubEJEbGxzdXFyZlh1eHZrWGtFazNwWi8vTjBiWWdkTFEreDVQd1BT?=
 =?utf-8?B?K3lvemxmdDB0aEhoMWZNKzNlMjRZSXhzWTJwUzRqZmpxVHVNSTg0SE9WYy9y?=
 =?utf-8?B?QnhjVE5aaUpzdDVFOUpKK0dSNmM5Sm54ZCs1SUVyS05EMVNWSVdsSGwyYk4v?=
 =?utf-8?B?QWlQRWVqTHF2U2lJNS9QZnUrVWthOXpVeTdTVUtrOG5DTkp5YkdMcDdkaW04?=
 =?utf-8?B?MjBFaGJHWlQ3bWhPVGwxcnpRalFXU1pHZStXQ1loeFBYN3plTDRrMElONDM0?=
 =?utf-8?B?TGQ1a05HSXFqcEgzLzl4cVh6Wkh1eHpDY1pzSWltS0VoaHg3bE84cWxRdGZu?=
 =?utf-8?B?QkVzaFBTaW9wN1VIS1pqdkZQM29TdTFsTkI5RTR0TUZTSnBqWjFyanhLaEZO?=
 =?utf-8?B?cUczTFpRVDFpTmVLWXNJZjdHNTNGcStiTTJiZyt3RXJiaEZTVm1RTlJJMW11?=
 =?utf-8?B?R1VhN1piNVFwVkZXWUhWc3pBSEFQRzB0ZkRVZlZoRDdqMzl3bVlhamJKY2hT?=
 =?utf-8?B?L2hSNnlFVmgvcVBtdy9VQ2t3dFJ2MUJVeVBMUE9JNTdPbmljelhWTjZjcXJP?=
 =?utf-8?B?WDlJcGJpdUZvOTh5T2FRYmRzNXFpd2M0WStNaUMrNjhrWnFnaTRKQ3NPTmtk?=
 =?utf-8?B?SEtvRU9nMytVanEyR1RQNHl0K241YmhWQm5ZcGR4M3NmMDk3N1NpRTdsR2Z3?=
 =?utf-8?B?Zm1EQWFzZUw4OFExTTdEN0c2M0grKzkrYVZOTkZ0dGhPOHlIWU0wei8xSWwr?=
 =?utf-8?B?bFh5NmRFWEFRc1hjOVRZWHFYeEpZek1OL2RZYm9wVFY1NjAwYytkY0NCVGVs?=
 =?utf-8?B?S2oyNEV6WGtBNXQ4MHArSWR1NzU0RTNHbTV5Ujk1SmVlbHJMZDJtNWJaVUN6?=
 =?utf-8?B?TUR3MHRQYWhzQzd2N2oyMy9TNEhGVjEremthSE5oOEZLdGxHeHdhbGFnRWVR?=
 =?utf-8?B?TytKSjJLMW4rTHlBZllRMnc0Wm5xYlNlOFlEYlMrdWhTYmJWY2RLdzUwdnlC?=
 =?utf-8?B?NS9mL3pvdVpBSk04QkNuRGViMzJMY1ZKVml3d3BpUVpOdkgrUDhyYktEOW1X?=
 =?utf-8?B?V1pxQ3lUa0hTYVVUK3Ewdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ay82NGQyU0xIVDFxWStFNXZGdXRHK281S3BIY052SkJYYmVNQS9GWEJxcDhj?=
 =?utf-8?B?eEhHdGpUMlYvWE1vNmMwWUQxcTlHWmdHV3VmbGVBUUQ0ZG9UYldPSlJmaXpI?=
 =?utf-8?B?SGF0UWRsSC9nNXJLNi91K09rMmNYRXZMZFBqbGxRc3A0SUcrc1hhVnQyYUl1?=
 =?utf-8?B?OUFpbmhQY0V0U3dVbmFQOEcyMW44L3c1MGZqdm9XVWU2SjI3V3h0N1dvOE5G?=
 =?utf-8?B?S2k2UnlmMVI5eWtoUFRkdDRYdzF5QzMxZ2crcVZpbWcrTGRpY2tPU3RvSGhx?=
 =?utf-8?B?Z0RXODkzOFpiZHJKa295M0VYNGJYcFRuUXJ0bWpjSzZsNFNiSXdPeHF4Rzdy?=
 =?utf-8?B?NHZxTnFDd3k4OHJ3SlZWRFpYZmowZ04xWHkzZnRDM3Y0SGVwQk5YaG5ISFdk?=
 =?utf-8?B?dWhjcXhXM2MrSmpVWWI3dkk2TkJHN0hsa1dXNklBS1IzR081RkVlWmd6MGdG?=
 =?utf-8?B?M0x2M3ZnZ3JFcm83MHZLNkp0ZC9aQ1JnWmsvc0dWQUp4V3BMODIrSXlBZEZs?=
 =?utf-8?B?S01XY1hEbGZTYjh6eHRFNk5wK2dZYUhYY2lVRElFaksydjI4c081NlJ5L2JV?=
 =?utf-8?B?RlB3Z2JWNGhqa2FiRzhNR2lPbUhHUXcxVGxNQ1k5emppRlNuQ1dvWnQwSzJw?=
 =?utf-8?B?S0NCVWRVSkZQV0xLTkFDRHZUSVMvWkI2VVZvQmROSXpMRHJxdTMxdFE1RXl6?=
 =?utf-8?B?RnVoN2RNNE1TSGlxUEU0ckZNM043YnB5blJiYlFOZjNEak40YzlnR3NlSnc5?=
 =?utf-8?B?UGliNDdkcHhwRmI4anNTNEMyV2gzSk9HaUsrZEVQeFRLVE5Yak92alMxVklu?=
 =?utf-8?B?MTN0M0wydDZBOWwxVHYvaG16MDg3b1lVUkFSWCsyYUdGSDY4UlZRWDlOV3Vp?=
 =?utf-8?B?Z2FLdEJONllVZHhkalk4OEhOY0lZQnRBb2JVRXJmdXRSYTlQcnFITXEwVDE1?=
 =?utf-8?B?NnFQNlBuamtFWkRyd3g0c3RZQ0JwNmxndGZGYVAvV3AwVFFWbms2N2drZDNm?=
 =?utf-8?B?eTN5Z0twKzJiTStZeVk5RUczbFdhcXZsMHlnbG9CM3F0L29tbXZyd1g3NE9p?=
 =?utf-8?B?dmhxeXRLUWRvbGo5d081V3c3emJ0TFJhWmtmM2lvVGloSWlDRC9xSEZZWDQ0?=
 =?utf-8?B?TVIveURlR2hFZk5SMllrS2tVRDdWYm9ONnAzNVVrQjQ1R2FVYTNNcVk1TmV6?=
 =?utf-8?B?d0RyT1ZLRUh3eno4TlkweThnaWNFL0FtWWVQMFk3ejZ3U1p3SEhJWFROMWQw?=
 =?utf-8?B?UTVYMUlkOVc0b1FOUkYxaEVZR2ZsQ2UrUFJnS0tJaGdpVG1XTk9HMjY5dTJR?=
 =?utf-8?B?UDh2N2YxY1M0WW5IVHVRUmlJeG5ucyt4MmxpNGtmcElwdW1sV3BEK1BFTTBk?=
 =?utf-8?B?ZmJHa0xyZllpaHUwZFRMMlZ4MjlTcDVHVDBXaG9vMDBxRWJlM01ML05ObjJR?=
 =?utf-8?B?bFQ1Z241RHM5S2t4d09uN0xLK0dPSEFranNCU0k2WGNMM01vMXovZmlRZzJK?=
 =?utf-8?B?ZytUMlpQR1IybnBmRlJ4Qkd5V3BISnZ4ckJhYWx4dEtHeTYwMi9IalZLdHUr?=
 =?utf-8?B?Tmp3TUlvN09qMmJ5RXNLRXNhQmllUjJtVXBCWllQVzZWT1ZIS0xKd3lqVkhy?=
 =?utf-8?B?Y0J2WTllNkYxSks0bnMrVVk4UE1sWi9zMzBCSlVFREdMZ1J0cXgyM2t3THFs?=
 =?utf-8?B?NG12YU1aN1dmamFvT1dlYWNGd0szNXRIWDhUbjRNRkZ2SlB5c0VpT0dmMFV0?=
 =?utf-8?B?MVVVSVowQUltcTBqWE1PemRFRWsya2Nqd0phUm81TXFrRWdGd1I5RGx3MEo2?=
 =?utf-8?B?S1N0RHI5bkNocytIWFdPam5mc0Y3YjNTZG0wUkRQMTI5Tmp6aWV3OGc5YkRV?=
 =?utf-8?B?SFAzUWx6YndtYmQrbzMxc1hWcnV6akhKM3lhcFhTc1AyZUhjMkovS0hLSUZt?=
 =?utf-8?B?ejhUNUQxcUxHcEZMajY5Lzlyd25yaHVNV3Vvd0FrN0tneWtaazBOVGtzN056?=
 =?utf-8?B?UXFUQVhFWUhZLzR5U1g1bW0vZU00MlNsNXRFTVlLUFFNTVRqdnpWTHdZY05D?=
 =?utf-8?B?U0hXMFVLWWlFODNoZ1E3MEJxZ3lHbTVhRDdHS0k3NEFPeGZjWHdNOEVvdXlU?=
 =?utf-8?B?U0ZkSVJ0bDh3T0puQm9Oc1p2OVo1eEVWdEl6cjUrajQxSXpMMkV4VzBJQlRm?=
 =?utf-8?Q?RpEc7YLR123vy6u06GiR8dE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iD6WEZYWjUqnjAlsk+VD546PYiXJpQ4Ot3SECwwGaVybQusgvJ0QblqsTjcAd/BOglxIW6Z+XFJpXPJ/vMU/uRloF1lwbhpbgJd1YuW2TGaiIkY74kYCeB70iFpOBnHMIPKuD+Arif8tsR/6HqDWHlpG9ur+7Z1lJ2rHdTqFVm+18qclzpS9HGUzMxAstUmH1xhvKCum5y+NLWja5KgIt+lAmfb32DIt+tC/P7hhZnR8iV5NDoW9hgsz/L53xulAvS3aURplUTJywVD7vXv3mLC91aLkCzosnY4CZybiBNleMVpSDYhRPf972gZ+sqByuxdDRRlupQj9KFr4nKy6jp/kClhhx72UTFehYEc3gAZx86u7jZUn22adW3gH5PeBdsEHBUu97yntfpYJrkSwJXhn7joh2subifeS9AqDez0+7pwiK800gDWU+AeE1tbWghEjZ5z9cDsmKa1tMJFQGo/cwSEI3RdmVM1cUPiQdpYXDysSvx4WMTrJ334G/TlZ7iEqYoyStyAxFQZe/PepZBZQQfwGsIPwNF6KMz9DRQvI3xe+HvgDbnAJqmym5S3cSeFeLMg8XO+ss9sH7O9zSx0W77X9uGuhoqCfrfZvkxM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a64511e8-f8a7-466f-920b-08dccb252e2a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 07:59:33.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7efdqPS98+k+tR5qr/C9LpNS0iSalFMt85KquWFEBFn9bFM5gnvmppxJohsgxuQXWGgGoYzkEQuuin1wYh5QaIef+jfESC9rDnFDkB92fPAgOmFfAzbsjKl/2NORr1zb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4971
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-09-01_06,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2409020063
X-Proofpoint-GUID: wmm4WQlNZXgpOF1GdhfDeDdHwI-Ns7th
X-Proofpoint-ORIG-GUID: wmm4WQlNZXgpOF1GdhfDeDdHwI-Ns7th

Hi Greg,

On 01/09/24 21:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.166 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit




