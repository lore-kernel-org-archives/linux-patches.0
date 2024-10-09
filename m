Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6F31E48A
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 06:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728456592; cv=fail; b=s4nYrbbvcSsplF2hwEgisXwGETHEPWAQfOTl0bVNJHqIwQGY5Nu0DAOMq1W1dyhEXVUlpNakXRE4vENwYfORBkX19iSS5mB4v230Yj5KectqpuAP2xkdR9Xhaj/z5GsJY6bSJX+huRyOJLTkHu44fHIknSGvSbFFZMyBdeIqGz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728456592; c=relaxed/simple;
	bh=nKENERnnQQWqQafJ+9jcnLvPz3/ypGaDo4+G8/hMjrk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WkhYFIhCM3cvvt358H1Qi2Ncp2sqW91mehOvXuZnrKFYgOwiI238Iqh/OQbjgNJvQX7DWqwNLvQB/Fmj7WtZQv1uSjVKkgf2RRYMGFnRAiBoB7sHFgJJxM/eFXVoIhuPZSExu50QZOOxXXvGJ99UJrO8Of5NLJFLCmelqkSMdp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZfaWTbuw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gQVwKvQG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZfaWTbuw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gQVwKvQG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4991tfK6026969;
	Wed, 9 Oct 2024 06:49:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=uz8ezlIBd8CSO6VOJzls8l0lNXDB1QX/5oXURkfGGSc=; b=
	ZfaWTbuw1rgGywIvV0964Mqyw+xCHCTLYgqvcyVvVkYrY6rxvrTn3ugpFgCo7g/P
	GbbryHFtCRWHWFgbCV7Za73rvVbUyzS8RlntdwZxxpzcTAhjN2O5cdPR5acU6Rmm
	sMa/YGcNtf9d3KLLvD5nmtnqPX1fJiBynwXO6hQd/szo0wb/OcB+JSnMo6OAMc/I
	Q2v16WBVL34bXlWstVJiS2zp99QgTmm1/si5HeXV0lLaaL4XtsYjRtG3Kb1sxy89
	iIIQll1B0Z8KI+3byygiyytc2zfmblVzGhPz+W5kZnslc2dMOgJUqGrFqt8bNEAy
	jE8/kWvTMb2bZ4JfMixZKQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42303yffb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 06:49:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4995qOsL015291;
	Wed, 9 Oct 2024 06:49:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422uw85ss8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 06:49:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/6BGw4lRlUIPW4hibY5FId1XDWt4bElXI0qwLbaExjGZ1czN85oNuPBpKdoNp1simdxItdN3J0hSHKB8e5/w1D0Kc+tAhINwWkyQivlkCtuhWWQdLdJoANZbakvppzcEPi6PqWm7tkET4jepLJzadnGyEfLlJCdaFcKYpa4naAv21ymTP4BASA6YivdUsmH0HGjJ6sNt9rZliJv9GAR+3ixZHd8jBHSH1yNk6mx7/TZax3fi1rGRloTZLN7RCKwO1+MdfG4wELIsgTEHyJqbhTLt53F+vwoJ6MoSd9FNqeHBQADR6UqcqMyGWnb+m92eajQM/xszZjZaPbEGDCFgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uz8ezlIBd8CSO6VOJzls8l0lNXDB1QX/5oXURkfGGSc=;
 b=UKRrxEzcYKJjM92PehB7jDrno14WE65DKWz3p14ItJLmLTfxYTD2Z3kT1bMOKoPJyfi8qA7tjNPCThblVTadpkAYIp/3MteY1+3p7PYxZzLg9bspG8paup1HEqNvtyCD7is35lpI2epmWYEdThjmadRLb/71jEcpXWn5W7x+AVYxDESHVz3XALmYeGnmBYo1he6gs3bXYRrK5Ho+CK7JD+/HGNVDnX4yiZ4pqqKyHx4suPU5TF6as2sG8JCBwlbcSpkecZsY5/JIeM6e5ElFAXPGWnwIYZfNhNpfo9RLD0jPjkKvyKNiFN68Liuw9C8M0j43fa9d0v+Z5ETmsqM1Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uz8ezlIBd8CSO6VOJzls8l0lNXDB1QX/5oXURkfGGSc=;
 b=gQVwKvQGJktoqCzOGI71soM52wcSII9a4ux2xKbERjEZiAgXJxpY8kASHhKvbI5w544QNhsUcDjN9hV9KvFCncuXyyLZoeRTLAzKmrI2aYBf6WLpBBQiBGsNAHYsLHHG8X+5eTNz3vRiEjBqmXysl2NY3XlnZVEcYF+HCnaJatU=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SJ2PR10MB7757.namprd10.prod.outlook.com (2603:10b6:a03:57b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 06:49:29 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.8026.020; Wed, 9 Oct 2024
 06:49:29 +0000
Message-ID: <4817050d-9aea-46fd-b71c-d1123af29268@oracle.com>
Date: Wed, 9 Oct 2024 12:19:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        allen.lkml@gmail.com, broonie@kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
References: <20241008115629.309157387@linuxfoundation.org>
 <CA+G9fYttfwQ7s6P2RLc6QA81_DYi5WrpWtiM4gK7_RDG69=6AA@mail.gmail.com>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <CA+G9fYttfwQ7s6P2RLc6QA81_DYi5WrpWtiM4gK7_RDG69=6AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::13) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SJ2PR10MB7757:EE_
X-MS-Office365-Filtering-Correlation-Id: baf21909-0132-4815-54ac-08dce82e859a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnBlOFh0LzBKa3Q2dlBwQnFiMkYvS2g3V3VUNUVZM3NBMXhuYTNrZWlvNzEw?=
 =?utf-8?B?OG9ScVdmUG0wRThqQmYzRGxET2Q4ajJ0dDM1Y0RwbXJCMHc3OWJQMXZSbVVk?=
 =?utf-8?B?R0J3M3lHUE43SlRpWG0xUTRDVjlja2NEc21OQzhvaStlY3BsUEl2WWJ0bW8y?=
 =?utf-8?B?ZnJTYTFuTkdhbTVBV1ZBODFQOHYzSk02UVRIeWJKOGQwVWlQVXY3ckptd0xF?=
 =?utf-8?B?S0E0MGZvVW1hcXZTeW9aV2lLbTgvNzVKSWNLVVp4eXhRWHZkbTRxMXlCZXR5?=
 =?utf-8?B?d3VEQ2VMc20wcEs0Y21ZTXVObnV2VkxZSjdjNGFPaHFnbFQ2Wkd1L0tNenVY?=
 =?utf-8?B?UHVvQUQ3MlEwU2kwYTBRSEFSRE1Yb0IzeDZQZGFwMFBPQ29BZFJjYlY2N1Zt?=
 =?utf-8?B?RkVpWmhHakFNNVM5cGtpZUEvNGZMV256WWNvRnhKZDZRWXpmbmx5OHZDQWV5?=
 =?utf-8?B?bGZkcmJURFI5ZHhGUW5BOENVK0RTMWd4Qzl5VmpIYzV4aEowZGEvTnQxOVhD?=
 =?utf-8?B?dFg3UEZDMHpFQzJlUWYreHp5RkJwclRpK2FGMWNCbkhtTVVTNFdaaGdRWVFt?=
 =?utf-8?B?RVYzbW9pSWZwYmF3NC9nNUo1UVQwbGdoeGVLSnRIZDVWckh6cUo0QVlXdGI4?=
 =?utf-8?B?cUp2L1FJSFdnTjY2Tk9uMlI4TTcvcEpRTCtzVHl1T0V1R0F6TDBZRjJEYVNj?=
 =?utf-8?B?ZkkyMGZ0WHVicEs2WlBSUGE2VEJKbG5LbmdUMDUvNWFobmxUdURrWUpnNFM3?=
 =?utf-8?B?cXVmZXZ1d3IyVmZnQ1BYU3VoRG51VFR3eFpUQ2VLTHY0NENqQ2hONnVWNkZw?=
 =?utf-8?B?SG0yeXdvT01lNnpEV1BsWm0xelRQNGlhZG9OTjR6SlVQRUpidUtjVUc3QWRk?=
 =?utf-8?B?UTZQQzVxQWd4Vmp6azNkZVZVSnhyK3Z6QmU5R1RZbkp0R1ppUm54QUEyMDBH?=
 =?utf-8?B?NVBUNjNPcWVUT1FONFN4RnZ1R0l2dlVwWE8wc2RWUVhxSFg1UVBRb2FlT0Z3?=
 =?utf-8?B?MXBPcUFaVHBMSFJ1ZFBBYS9BNVhlWDVxR3lVa3VYS1JldThDKzVzZzR3L0ky?=
 =?utf-8?B?WWxhRk5KNU16U3NFekJqKzNCWlUvQ0trV1JVSEJjSjlJb1dIRkVWUzNZY1RV?=
 =?utf-8?B?Ni9OU0tjNzZheExiTkQvVE9wLzlhYjdLcFlQVktvYS9lZ0tFZUZPVXMrcnpV?=
 =?utf-8?B?TTMvM0pQc2FZd1M1b3BGTmRKbkZSdTJnQnE5b1NxNnVYZVA1VjhKRUw3TnNv?=
 =?utf-8?B?UU5oVVU2MDladnFkZ0hRNUp0WWw4cml5SnJDem1NSWEyMm5PTEhzMEVSTnBm?=
 =?utf-8?B?S3hEdWxYREkxOUJEZTF6Zi9XRUUrSlZQU2hXWWNVNUt2ZDNXcW1FZDZ4aGRi?=
 =?utf-8?B?UXVDd1hjalBId0lNWXkxZ0ZtdCs4Y1hyekV4U1ZpNmdFa0FyWmpIaWF2dGtI?=
 =?utf-8?B?OVRjYytpcGVXVWp5VUQ0eml1VXZHMm82Rnc4UTViclMzdXQxMndWdUIyNUVa?=
 =?utf-8?B?M2hmMkVaSGtXRVEzNko2Q3Y2NDIyRFJ5dHREV1ZiaW5KUzdoZ0h1QjlRYTha?=
 =?utf-8?B?L0pLZzR1M3pXWjIxZUdMd2hTeXRLT2Voc3Jqdnl5TFdXcHdsVWsvdjFMUkI2?=
 =?utf-8?Q?RQAzXv8tMioIlPecN0c8kAzihds/C14w3Ngv33IHN/YQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmdKSDNDSHB5ZGp0MlR0aVJvYm1iU3RzL3E1VnRJQWdFNkN5UUlmdEwvRzZi?=
 =?utf-8?B?OHdud29tN3lHMm0xRjdPeStBdml4T3NiNUJvdW5QZXJibzRKanN2MnVyL3Nx?=
 =?utf-8?B?RnVoMUdHR0FFVDZBODg1NThiVXlmaEp6WHNXZ294Qk8zNnJPdHZndSszMCs2?=
 =?utf-8?B?TVBTaGVETXpBNERjR2pOTVZpUjlkOWhJR1U2aHZhYlB2Z3MraEJ0UElzWE1C?=
 =?utf-8?B?N1VVQ3UvSlVtb1IrdmY2QVphWFdadG96NzVrTWhxUkRjd2Z6cFh1WVRLRVZC?=
 =?utf-8?B?L1NBdURHMmJuL3FVaHBWbXZ6ZklaT1JrV2Z6T2JNQzNVT1RxWkZYbEFEaXZn?=
 =?utf-8?B?OHNFN01iQW9MZjhmYWNSRlFiUEVlNEhBQzRoY0VzSXRqUThwU0J6aGNHWXdF?=
 =?utf-8?B?M2sySG9TckZBY2hSZ0xEZzhkTkV0T1RvYXFLbzNhbmR6TmdpbTk3UUJNbFFl?=
 =?utf-8?B?ZWFmZjRieFhzVnY4cFBRYS80N1AvcVZ5aDlrd29xRlFrVlJZZDdMZE5FNk0r?=
 =?utf-8?B?YUQyeUVLd3hBZS8xVlB6c1VQaklRWWQ3anNzak9TZGJTNmFHdDNzV3JEZTh1?=
 =?utf-8?B?MFh2TEg0ZG5nTXlKWVhQWkcrZWF6eUlTVThFRlN3TDc1Vkl5ZmMvb0RmTndj?=
 =?utf-8?B?aDh5Mm1xNUJWL3doZVo3Z1Z6YWZzd1lneFA4MlZXUXdQWVIwSHFIcGdiRWs4?=
 =?utf-8?B?a3FRd2ZHVlNvdisxNDJ0elhUdlF1K3huazRHU0VNZzVaSWlyZngwU2pJYzNG?=
 =?utf-8?B?TGxmS294V0V6WVlEL0lmZFJSemViMTZ4VElIcnBWSUwyREVrOGxLOVRTa3kz?=
 =?utf-8?B?Y1lvTytyZkxTcm9IemFTUlFUMFRRQ1lqbm9iZTJCUmI4KzhtaXVqZndyUlZN?=
 =?utf-8?B?T21KQlZrYWx3Z3ZmeGtFUUM4REFuTmNUYytjS2JwalJjNnRzTTc0TTRmWlNy?=
 =?utf-8?B?Nkl4S3BPelBiR0NOVEU2aDlHcFRZZ3k4Ry9pTmxiTHF5RmZNQzI4YitjenM3?=
 =?utf-8?B?cVFJbm1XZStxQ2tNQ2JteTVMb1ZBWHJhblNxVm5TcHVMZlRyMENGWTV5UmpP?=
 =?utf-8?B?YURtKy9tQmd3bUFlL1kyN0doRkZQcWdVSWhkdktJaTNOUzdDQ05oMmZZbXZX?=
 =?utf-8?B?OStzVmdGQnVmL0c0eHo3NXIxTzRRVHpOK3NRNnZNdFl6ckVkVG1wZTI3bjJZ?=
 =?utf-8?B?OXRBTmRjdXJSb0ZvTTNmNVIyNm5xZGh2VnpvNTN3c3huZFpEbzJkeFZ2VmZ5?=
 =?utf-8?B?MmVCdUs5RFp5VlJFaUpEbDFnaEQ2K09nbndVUEU5M2tCaWVnRUY5UGY3UEFH?=
 =?utf-8?B?YjRtNE9KUVNiTVZUYmJOY2tJbko4NDRJL1hGdVdOUFc2cmNsblNxNVlnNW5U?=
 =?utf-8?B?ajdhNU90YXUrZ2FRM2dxS2pMbmVMOE9uVTlrN09yU09xbjRVcmRTS0MyeVFO?=
 =?utf-8?B?SEpHVHJnQzdIVzNLZkd5amdBbis3dWt6dHJEV1ovdTlvaVFxNE9RUHhNTitW?=
 =?utf-8?B?T2pRYkhJay9LSko1VVExV01IRmNqdjVOd3lsWGJkb1NPS3JQdVladnFXdkRH?=
 =?utf-8?B?amRLdzJ6elVqcVZkekdaVlpDcGNpTndNa1dvY3hUWEkxa1NHQXJWVjd5QWFh?=
 =?utf-8?B?WE1KcEkveXNkYWVaQmFDUzZLRmtud0dqeU1pVEJLTWszcG5MYVlEWWt3djAz?=
 =?utf-8?B?NHgrbDc4ZHgxRGNMb0hyQ2FSU2Z1L2hMdmRzMVhyUFZ5cHBZQ0w5eHJCMXZZ?=
 =?utf-8?B?TG1XU3VlQUREdzFIODdoWXJtWlNLU1JObzhtM2pRdnk4SnNDSTd4elRkWUMv?=
 =?utf-8?B?ZWhTcUgrQ1laV01MTmNLMTNRREcwTzRpbkQ4LzVXYndRd2NocFp4c2hiWGJY?=
 =?utf-8?B?OXluQ3BrVldxbTNUcEtka0ZyelYzamkyUnl1QlYrRTFjSGRMMU9rRUtlVXlB?=
 =?utf-8?B?enlveVllYXdJemxkK0l3TWxJWThnWU5RSEYrRnJiU2lmM214TXhVVU5jK3k0?=
 =?utf-8?B?UmhIU2R4cVZ6OWhUdUhqcjM0eFY3SDk4dEozek8ySjlFU2lNOGg3aDgvRFl6?=
 =?utf-8?B?SUc4eDJQZ3YwaWtwZ0xmcE1weldhMytBRDVrUHFNUFMzNG4wMlhYOUNVNVVs?=
 =?utf-8?B?Y3JCUU14d3lyTjRTUmhZUm01ZThJY1JhdUliQVpZRHZpcE5YdWVudnZtUU1m?=
 =?utf-8?Q?JjTJCUxByKlNG7ERCoNXKAk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kXthnEhcnGGbeuw1kilTeuTM6GT78PlsV68iVEyjVe4V7UYrqx0RZ0NV3qlw3H2BfR0HO3Ebd5ah3/PbUIdc0k/9ChcEFDq8J2UNrfO711wy7gOe6SEnFxuVgO9ktxMDGQzDPaG3WxTVt+Bli9MI+qIP7KGC8Mghi8M2C115EQzaE+KRZ7MFjXh5thXmDZgvXnhKV+gvAuKM7Xf1/xB/AY94xCi8BXKl+BtrjyERK7iTafwPdKPK6J8OydJpOjkU8S9h/WW0PnefbJN6NH1rYvCRRmmgODuJNfA4OEIfKoe7bnNwI4Iclq1kItiJD8TdAh2Q1pQom0Ecr0F21s/N8GD4Y7yd9gxEQSzPBXd6+EbwuhFj7lTwqnuaIJQvtMd1qmaWalKJnvTk/RPeI5MdtZtZLRGOPJKe26wTorakA/q0OPQg8GUEHo4pqPlpfwX4OF2JfvkXlQHNd9oFj4kDpES8NWvvMELUd/YQ3/Lce6jrqFRXu9RMKAXqETBOtC0a1SPmwWxF6zQfoJEeLwASJY01dIeh+RkYfMeHIFtKfNojbbOrbc864AeZ/YJzdHhULZk1lMkVu8FV0LxPd/66dhONbkyu3poZmKA7Q2A1s3M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baf21909-0132-4815-54ac-08dce82e859a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 06:49:29.0292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GpAZbAW7iS/mqmX8M6WgGIH5TR+dLkDY+wM7HEO4+yYnJ4dy/4bmV2kNRJrbB6+eebI0yNbMOWTl/az3ZLqKrJr7OSUp08WtFbnViDIvKNq6wz1rcZuXkHyJ/bfc02MT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7757
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-09_05,2024-10-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410090044
X-Proofpoint-ORIG-GUID: unM4JQ-aKf14rhc7xr97JG432WZlLWu3
X-Proofpoint-GUID: unM4JQ-aKf14rhc7xr97JG432WZlLWu3

Hi,


On 09/10/24 11:54, Naresh Kamboju wrote:
> On Tue, 8 Oct 2024 at 18:40, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
...
> 
> The LTP syscalls fanotify22 test failed  (broken).
> This regression is noticed on linux.6.6.y, linux.6.10.y and linux.6.11.y.
> 
> We are bisecting this issue.
> 
>   ltp-syscalls
>    - fanotify22

FYI: I remember seeing a discussion thread on this(atleast very similar):

https://lore.kernel.org/all/Zvp6L+oFnfASaoHl@t14s/


So based on that it should be PATCH 178/386:

Jan Kara <jack@suse.cz>
     ext4: don't set SB_RDONLY after filesystem errors

Thanks,
Harshit
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Test log,
> -----------
> fanotify16.c:751[  452.527701] EXT4-fs error (device loop0):
> __ext4_remount:6522: comm fanotify22: Abort forced by user
> tst_device.c:96: TINFO: Found free device 0 '/dev/loop0'
> tst_test.c:1106: TINFO: Formatting /dev/loop0 with ext4 opts='' extra opts=''
> mke2fs 1.47.1 (20-May-2024)
> tst_test.c:1120: TINFO: Mounting /dev/loop0 to
> /scratch/ltp-6nPLv2EGcV/LTP_fanbDvQcT/test_mnt fstyp=ext4 flags=0
> tst_test.c:1733: TINFO: LTP version: 20240524
> tst_test.c:1617: TINFO: Timeout per run is 0h 02m 30s
> fanotify.h:122: TINFO: fid(test_mnt/internal_dir/bad_dir) =
> 6bd2dab9.86fe4716.7e82.df82837f.0...
> fanotify.h:122: TINFO: fid(test_mnt/internal_dir) =
> 6bd2dab9.86fe4716.7e81.beaa198d.0...
> fanotify22.c:278: TINFO: Umounting
> /scratch/ltp-6nPLv2EGcV/LTP_fanbDvQcT/test_mnt
> debugfs 1.47.1 (20-May-2024)
> debugfs 1.47.1 (20-May-2024)
> fanotify22.c:281: TINFO: Mounting /dev/loop0 to
> /scratch/ltp-6nPLv2EGcV/LTP_fanbDvQcT/test_mnt fstyp=ext4 flags=0
> fanotify.h:122: TINFO: fid(test_mnt) = 6bd2dab9.86fe4716.2.0.0...
> fanotify22.c:59: TINFO: Mounting /dev/loop0 to
> /scratch/ltp-6nPLv2EGcV/LTP_fanbDvQcT/test_mnt fstyp=ext4 flags=21
> fanotify22.c:59: TBROK: mount(/dev/loop0, test_mnt, ext4, 33,
> 0x5659a1d5) failed: EROFS (30)
> 
> HINT: You _MAY_ be missing kernel fixes:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=124e7c61deb2
> 
> Summary:
> passed   0
> failed   0
> broken   1
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 

