Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531F6CA6B
	for <patches@lists.linux.dev>; Thu, 15 May 2025 08:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747296855; cv=fail; b=GadVwY04+vZsig/C+vspnNTHLT5EgPqRiOQnc7kM+kV7IH1w/cVUBukN0WWK7IPi6T+GHcE3cjyQd0uIsWuet/4keB3EMrMnm/sfnFfhc7X3GzRp1NcZY53tJJ2k9b1oSK9dkgw7cmtJh6ODh65cwzkDKxgmItiKf3imm5hcBII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747296855; c=relaxed/simple;
	bh=gdLul5bZgWqefaeObtYNzA1GVeCG5Yqp3lE2Z77FCpE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qWPvrzVK34b1hWGZCfULp5SkNaR37a7s4wY4D4LOjwXR8bgK8p9ZhIVdeAotHd/DSu6gJzKbNcnqNT7DXlHf+zbtOkiy6NWOIylfQmDKSp0Tqio/i00rkyWWfYBucUYNQf+ulsvOwJ+Wjr5nyXRjHCmmCq7MWncnkE/sTWkozMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KGzmK99G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jBPB9pcb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KGzmK99G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jBPB9pcb"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54F7Bk4U015534;
	Thu, 15 May 2025 08:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rL/Z78/YdDBwOowvggWcpVRNLNWUMaLV0WylqsZHmPQ=; b=
	KGzmK99GvEMFjpPT9h7MtkGYdMVW4oXfcsJBCSuU8wlie7O1OXpANvWXOhilsiWW
	4h4Yq8g2qm0cAR3o/w6ATFObK6p44oto/m7BC/33rhcfnVKbOgKw+HCXnJgtctLF
	LhPqzX172nmj8Jm0PGbIkRT88qKh/esz2/H+3FIE7atax0oSFOgr0O+mwN4f9Bbk
	Lx6NCMes1BQ2PXRtp7Xc1Skoll6KWWkUsnz598YwZdfilJJTKKquFDjWGlnJWRoZ
	6v9XFtfnWS6mTZ0FM4bpogGsP9+gr5ULw0aI23m2qKGtbXi9SMIJFtml5rSPZYLu
	e92BhnyFfxKDoOQ5E0OyBg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ms7bt967-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 08:14:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54F6ABaB016115;
	Thu, 15 May 2025 08:14:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mc34g6eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 08:14:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HNKywQWcQV7Al9Dls/z8MqcL2zOVWYzrt+6NJvV8reqcasdydFUmLbA3UFhkEEbS/OKltrc0MnspFhHdyI0bJ/IiKY5k9v6CZ0fUJP1UcqIXKI4L7RomoUV8zwgcX9NMdCDSDfqEkoELPrGs1du48BDLyn44gNoHv4vX2S3SbdJf6c55vJgOvJbPSVsxBdNZl4i0fcGBpZou9LqBSu96RYKuQzEgCSrCVh37nQlgmz9Zol5fatrEcO+uMMZl2yQalHU+obBZz/ERiWJdt3fQbsVgp2eBm1mdVmwm4NLIGJD+E6Q0Kof0JNhucAa9gB+M42DEQJxDJCft97U3TY3GFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rL/Z78/YdDBwOowvggWcpVRNLNWUMaLV0WylqsZHmPQ=;
 b=t4AFqsD0dQShI9CJ0wUJh1J2TiCjQ3YXo2sFkE8zpjcSYo9qNzNDDso67QFVdrSx9mMtrsiKerbht5IVeOmrkR8Zq46zIPfwN/l0vlGQzLIv/0lZVdVjn/gPgrMnuZZCfr7raPD14zU05NWsP/1snGDfUAFht8zGlmY/rfFT/Qpw6VLWfLiEyAGVcaG51w34LaEnziduO8q/l1cF6VIaeIN2t/QFYatHPYkoUyRmVliudx2QV8C5fRaI1JiEf36CCSvsX9rlX85IVGjRtX6VkGt14Dcvnghgb1HCCiT5Uri815hbax3eCCemvF4uOSWkzgcX93yBpzQoPrtFhYn4lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rL/Z78/YdDBwOowvggWcpVRNLNWUMaLV0WylqsZHmPQ=;
 b=jBPB9pcbUbc3x/xB16mXGvogp5+uybiQXWkJqYay7bipPWQtbFst2rckcFzWsP2vDGocFexu3MymC+sbPhIzj7waieJ7GwzStAdWUCWcqiJxmPhg2vS2HZr1PDC1tHKun5DIcoS2qw+Bv6y5AOseQ2PvO3M7Lqg/dr5l2d2Ayrw=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by MW6PR10MB7657.namprd10.prod.outlook.com (2603:10b6:303:247::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Thu, 15 May
 2025 08:13:57 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%4]) with mapi id 15.20.8722.027; Thu, 15 May 2025
 08:13:57 +0000
Message-ID: <34d497da-c6c1-4fb4-86d1-6ecbe57f5ea3@oracle.com>
Date: Thu, 15 May 2025 13:43:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250514125624.330060065@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250514125624.330060065@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|MW6PR10MB7657:EE_
X-MS-Office365-Filtering-Correlation-Id: f4553654-f433-42f2-9c2b-08dd93887053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MU1Danh1U2wrYy9ndnJSWHczdEZVTjlPVWtQanBpU0Q4ZGk3SlNDOUE0cU9X?=
 =?utf-8?B?eSt2TWhMcVg3c0N5MVZ2Vld3R1RuWWxsdG02b3l1WmxrQUt6azU0RXY3SVp6?=
 =?utf-8?B?aXB2TzVOZzRzZHVLaXI4TkZTUENZMnpYdDFOYlJicnZISnJUZng2L0EwMFFF?=
 =?utf-8?B?VEhVK0Jmamc3SFF1a3VOYWdKV1RMczZNMWlRamozZEl0S1kxZURCdjRIUUVP?=
 =?utf-8?B?TFh0bm1LN3BGMVVockw0ckdPR3JSK0QwWHJBb0t3K2NNQVVaL3U2NlJkeVYv?=
 =?utf-8?B?RlNoYU43VFBENUhxQmFYSWRucThQZVRsSWljSEl3dmZGeWNWaFl0L2x2U0VP?=
 =?utf-8?B?N1NvZHJRcVJNTmVuMXRjekZFaUhWd0F3cGRBNkEyUUJKd1Fnc0l1cjM5dHA3?=
 =?utf-8?B?dTZQZHJrcmpoVFBUN0RQclo0NkpHRFZEWmxHZTh3WDlVSWxJK2x1Qk5ZMUxu?=
 =?utf-8?B?dVcxbTVDV3ZjeUVueDgwUndOd283bXMweU5Oa21mZWw4UzAwMFp6WWZnL0Y4?=
 =?utf-8?B?SVB0bmZVZ0V1cThNN1pqWTdlWEFTcGhjRlRyKyt0azNvdWwxZnBoYmVVcHJE?=
 =?utf-8?B?SGFCRGF2NmFpeldOMFBlVmozMjg1d1gxVjdoR01Mdm0weXROdjB3akhpcXNJ?=
 =?utf-8?B?WWNqY0hyZERuaEdsM2cxYkN1RmhWWEt5Slg4Zk9SNEE2QWNkaXR5QVgyYUVm?=
 =?utf-8?B?Y25zYXoyMkdIWTlOYlFWU2ZHMnJYNHdDeG5XN0ZGaHZMK0hKS2NSQUNoVzJq?=
 =?utf-8?B?U0xxTDlPWTR4TzVYUWc1ZXhXcUJjTEFTK2k3UWJIbVJpUW13ZlluS3VVV21T?=
 =?utf-8?B?bmdsSGp4dW1Hem02QkxkRkU5bzFLeFZJcktRbUEzSUtlUkNnOFJWeThTbUha?=
 =?utf-8?B?UzI5MWVWWTc2K0RPNlhXMlI0a1pYT1FFMEhEc3RMMDk3Y2xtK0Vpb2FBTGhn?=
 =?utf-8?B?YzgveFl2NkdPWE1OVk0xdTFGNExVVWhQK2RnOVJycHJEUldVUHlxdERlSzND?=
 =?utf-8?B?ZnRYc1ZyaWhJM1VZbURoZjZIY0hIQmVxN0p1ZGV0MTRKMzl4Y0p3K3VTdE43?=
 =?utf-8?B?M05lODlLNklZRHkvZlJpMzQrRHIvYjRzdXJpRWszenJ6QXIzbUMwclprVzJk?=
 =?utf-8?B?T2w3a21iamdUSUZzWERkQ2locG5KR1pTL245YTVSNGsvZ3F3VkZvZjEydVZy?=
 =?utf-8?B?VzkyZFV0U1BZbWliOFY4QVcySGtLOGhHR2tCL2NzeENwRWlEOEZDdGtZc01J?=
 =?utf-8?B?bW5BMFdJcTJTeHRWLy84QU5VSFhTOHVEN2VqMk9ZY0ZuZ2VQS2NWMXVGdEtP?=
 =?utf-8?B?aUFOUno4TEFKNU0yblNnK3dwU1o3d2hUVVN1eE8ycEV6UmJiZkEyUjIrWGhr?=
 =?utf-8?B?dGxpVXBSS0JvNHA0U0hzb2hnUFowVHJuUEp4Mnk0UTNFYzhOVFh6MXRXRzU2?=
 =?utf-8?B?M0x2Y0o3MEorUjFzSmVOWFc5UVVIVnc1aHZ3czN1ZzVjN1JmcWI3Ump2TUpL?=
 =?utf-8?B?ZXhObmpFdVl0dGV3alpvbHFKaVdKUXNzaFh1dmpZZzEwenIwSDc5QjdoZm52?=
 =?utf-8?B?QldXZFFTVjNQWXN3dmFiNllHQUxMZUdJbTNsaUJFUTNIeUk4RUdZNm51THZ3?=
 =?utf-8?B?ZVRVMDh2M0tzRVZvenF3TExJcjl3S1B0S3pLT1V0RGw3Nm1uVHYwbGtkTkR2?=
 =?utf-8?B?STB2T3NlbjI5UlBZUUFxYnlyRFJVeVpIcGRqR1JoV2ovZ2ZETVFoUkFPNGEz?=
 =?utf-8?B?d1E5VzdzUU5mcXNXNWNIU0dQbnNscmhXSjlTRlVML01nYkpJNXRlTm1kV1Qz?=
 =?utf-8?B?cXg4MDRJRFNsZ3VrdHpMWmZCK0c4dHk4RVdKS3UrL2ZLT0FNM3BpS29yb1gr?=
 =?utf-8?B?aVFUZFBqVjdSVjRoYmwyUXNJVjVWWnFzZjBYakVYdHFCdExhZTY3eEdNRjBS?=
 =?utf-8?Q?xqrEfz4urhE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWptZE1tZlZKVi9LenA5Y3RtQXpmeFhXc2JLZEtmakhSK3A1S0JVekl4RU1P?=
 =?utf-8?B?WklXUlJLb21QaXpQVlUxMGZkb256WUVxWjhoNTRBdWRGN3lvWnZha21saGNK?=
 =?utf-8?B?clJTRXBjRUlZam9JY1RUWWs1bDlHc21qY0xiU3FnM1FYVnFVUmxiSjZuaFFE?=
 =?utf-8?B?a2pleWxydEtRMHU3VmM4LzdnSkNIaFVkRE95ckZ3U0d5Z29kYnZMNWNKbWl1?=
 =?utf-8?B?MXJqbXF0eDRvQ3R2cnIyN0RiSS9Kc0pQajZValJrdGs3TEJ4MWQzMnkvbzB3?=
 =?utf-8?B?ZWxoaTJOeGhrcUZnUkhLR2hBZ0h6L3JZL0hYbFgzUkdrUlhsQlNTK0VYcDRH?=
 =?utf-8?B?UzNOUDdnOCthYlF4L0lyQkRtODNUbkE3NnQxa09LNlpnR2F4WWVVS2JoUkI4?=
 =?utf-8?B?RUVpMUFabkNyUU5aYlUvRnFwVXRhdndUYzdURmZRVUpWeEFUTFNkMklLSGNG?=
 =?utf-8?B?d1F3MWpFTndaTUx6b0ZaVDhrTzNQNFdCeU1xSXBqVVkrSXUzN0dCdlVPNFI3?=
 =?utf-8?B?M0ZtcFViRmJlTkNMRlRlM202ZWhnZCtIQ01LSW1Kc0lIY1VvS2FJbDFPc3Rv?=
 =?utf-8?B?Zm1lOHNFSWV1Q3pKL1g5NHZZZ01oT2p5Ny9RQTkxWHdpQVBBZzlSOVM2L2JZ?=
 =?utf-8?B?MXBCZm9INEg0TWRyRUt4ZWR4QTJZdlVRME51d2lQZll0NWFNSWhwUHhqRlFl?=
 =?utf-8?B?Y0NYa1p6SmpZeEVlS0RwZmk2dElmVWlpeEk1bUdTaThJM0FzRTd6UVU3dnVz?=
 =?utf-8?B?ODlwQWFzTmh6cGxyeU1DeklZZFdMUUlBMUJKaXQvbjlLN0dubWE2QnFDUjZ0?=
 =?utf-8?B?YlNjNXZEMHA5dnhTQnVLaEV0V1JHVHJjK0JDeGVVRmd2TDRxcVhpRkZaczdp?=
 =?utf-8?B?L2c3TjZmQTZKNitzWC9PdzlwRTdGb214bC9aeWtSSUxpNXdPMFNYM2crU3FL?=
 =?utf-8?B?OW9VQ01XU0RxcERpM1FVT3U5ZFpUUXc1U0w5UnIzZ2lYSE93ckhHaXNEQVlY?=
 =?utf-8?B?R0RiS1ovdjZBR1pnSjl5RXdYalRRMEZ5elZBTVdlakNFM0Q4a3RFRzhlOXVL?=
 =?utf-8?B?QTJyMnduSU8wdGZNQ3pieG9KQUc3cUZkWmx3aDBlL1hCV1Z0bi9yZUhOeExS?=
 =?utf-8?B?Ym9IY29PMVlJVitENTQwMnpxeXdmc0NDMkRXKzBTb0VaRUMxTk1qd05YQ0di?=
 =?utf-8?B?Wlo2TXBnWVQyNFpvUWdsZUhBRjdlMmliWlhSOVM3RFdZUnI0a2pIL1R1aTVX?=
 =?utf-8?B?c2pMQ1B4cEpPemI5WjRnMkVhYkdCUENldFpYaU56aWVyQ2NtaWhwWDBtcnY1?=
 =?utf-8?B?UjlyUEhicnZMT29wMHpjRXBZUkJpQ0dCeG95MFhnUFp5dmlaZ293eUZPUXVP?=
 =?utf-8?B?dUlWT0N3NXE3TXB4dWV6bElwMHMvRUFYT0czSmI4L1M4bW41bnBCWm9mOHNl?=
 =?utf-8?B?VEpHczJ6S0hRSWVTVHBPN3NvcHBXNS9XeUE2bjZQYjRsS0RYbUpyd0lKZS9O?=
 =?utf-8?B?aUl1MWo5MndIci9GbkZoWGVqYVNQcmxpVkhpaUxuL1dRaG0xTkoxekptczJt?=
 =?utf-8?B?Sm9XQjV1WkVBVWpKR1dXb0hKWGVSc24zRWRHQ1dJcGM0REJqU1ZIVFdmOWFk?=
 =?utf-8?B?NVo3NzJWMjcwOVRSVWY5cFBDWERwSlpiSzJRSGpNR3hHV3hkNDFMZEFzTE43?=
 =?utf-8?B?Z3ZrRjJyY2VvVG1KZGV3amlILzdHMDE3TmdDTHBzbU5ZZDRYenhSU0RHQk1D?=
 =?utf-8?B?aUhMN1R2aktjWHNZTjI1MTdOOEFGZEZ0VFdpTlZSaDUxdjVRYk1ySVdiWW84?=
 =?utf-8?B?OThWRTlacTkzTXpsR2l3YmFncnpzQXQ1THdjYTZ4bnI2U2lMbEpEVFp5bkgr?=
 =?utf-8?B?SmFyZ1duMmZVUXJOUDlaei9wYVhrQmhUZk9CNEtlNkJBc2NPY3NZdis0OU5I?=
 =?utf-8?B?N3F3STNLZWdEZS9Gekl1MGc5YXlaRXVMZzFvSXlLS3ZSa0JtbnNQVUtZZVRG?=
 =?utf-8?B?NnVNbFBaT05vS1l6N3dJV0kxa0x0ZFJKM0ZGNkJPa005UWlIbUhRSXhNK1cv?=
 =?utf-8?B?TnFwRkdTMk1rejhYU1hhbWhoVnZOeEVuQlU1azh1Yk0vUG9nODFaWnZYYVlC?=
 =?utf-8?B?dGE2RUEyTGxETjVBd3Y3NlpMd0dKOHNCVGlnVGxENHNjUzVPTTJFZDAvUkYr?=
 =?utf-8?Q?OWi2vkq/7jefq8PdhqLcA5w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7I1TzLQghu6xEQgvrwTybf9mtUJCM0NGV82ccJW02VPvQX+NkxyEcB7AJpedpfI7dkUDNC7Tnda9Mt1i3e9tuhRAyZFnEPSoBXXkeDRldb5VuKAR9YNBeIEdveDacvejcQf6EJKrxhhrx7f5NFMFFXYtiQR4oWljegmXEf3Sunt2159iqLlfiVsZY3QWdhU7V+jy2WvTrz9qwrht0fNgz6BHVWObA6Svs+ELgDrUAjrHd0XMZcN9i0+yZWJSJG+Mhnv45s+k+VB1zj3Mswvo+idvo5dQ3dBCuKPsLEgP54GXW9brom6te2v/sZ5xqscirabWfufQvpXMkpinUtuf1urFEypdMOLnXLcZMK/prrHJZ46cuib4IFWZODBa0B9cztCpngjNoanc9v3T+eoHyyJ32OfGi2eI1Am6GeOGm2dnBkapToZFE4WHgDkfnqSzwgET22hNnSmk+m1mgzuzEfe2TsdNN5RvQqJpEPwlPqXmW3ek1mhXuZFX8z2JwM8eFq3zFxBgr5bXAsAS0n0S7xO0RjqrQ7WvfG4xGI8mQiEZQH+q6kSR0sIxOfGy5GHzk158Hu2keSZT+aA/LpNKPKLZFPzMG6/1i6MlfY6rYe4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4553654-f433-42f2-9c2b-08dd93887053
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 08:13:56.9313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rRp6nW/ca72Tgl1TyUK2LLcRI1QJY12XMrqqafWqLVmg7W9vG4JDWeIWK3hKz8OfHGhO7JlYxXe93ULaAnNgMayzRgHm8XAtEh40FAigilf7AHgVAc5pqoA1A+6uOrJn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7657
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_03,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505150079
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDA3OSBTYWx0ZWRfX7Kj74Tl2cV2X hiv/KCNwS4+v+O28uzvpOIhXfdctMQksXUpLB2dQm/8UZRhcbLnj+U7hu5YL3qy2Wx/lI1RupMO kk8P2pEflnnJMjMrp3+5Hk2u2hIxDNull6/0nykWVK9PTe3t07aoTVqXfsSPunZ+oJIiCPGx3Xo
 qzVMKiTd8QA2snUc16lAvjVfCBG5saeNuGfS1gMHVkbvxYHoC2VBw8OKIoVXern4izRrtJZM2n5 wmziw76agk4OWxAc4xSPCe3UmoTaholKhQ6ESJaSYIVJE/Lex8d3+8n5YIQxmC+ZxHJUoFj616f y82+duNC8gl4l7Ey2xWiK+8CGHQ5yRQu/WK4L9uVhUPOutx5x9+YLeZblxksUzW3dpazmTx2wpm
 XH3FSMssOOQOaYJYfcmrVqxXz8J+HvbHmCog2Yqwp46htUWplSrNVxCv6UnaHo47w5/CZqOa
X-Proofpoint-ORIG-GUID: kcpt86meLL3ENsPQrYa3GWbZ5eyJRjNk
X-Proofpoint-GUID: kcpt86meLL3ENsPQrYa3GWbZ5eyJRjNk
X-Authority-Analysis: v=2.4 cv=P846hjAu c=1 sm=1 tr=0 ts=6825a249 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=UlE0iww382u4jLCPTdwA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13186

Hi Greg,

On 14/05/25 18:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
