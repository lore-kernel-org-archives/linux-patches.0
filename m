Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23E83AFB0B
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780322453; cv=fail; b=hbELpa3TqeFUxpq9JmwS6YLLLW4nBIfPn3GuquLiHZv9DuFZ+oEQ+3hUYB5LWOeZMMj7qUhPfig2+xLa3yniXumrqASiKylKqhG4ohVMOPDZEPOW19nxmOpE9tMzctBWlGiMIl50thCcA+D1y6T5s/AVFdmXsDiG9cNAc/lPG7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780322453; c=relaxed/simple;
	bh=Yo2ZoJg2vap41tCT2oycrYgMoKORGyn0i/MTCn0WXjE=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ODQoSs+Xhb736huuECQmmahoodfrQj2GxgOsdKKsNoz825FdE/waXulfX32HOkSWPIFw6Lj6/1/hRSk2sFMwnC1cLte5COjZhbyvb4x7lpTHy6lGJkb5weiOyVq57xJgtrRDD5f3G0niQcJ64seR/3GE5GLV4GlWuCvQ65izy20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lvs1rn9W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QX5Zoxzy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lvs1rn9W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QX5Zoxzy"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6511N2h43562834;
	Mon, 1 Jun 2026 14:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dFdm+Rauyld7yvjUHOVsyO3NMbXR99PEBrr8eNCZozI=; b=
	lvs1rn9Wz2wpZY5aMVfl/q7oe78R7rydYFLJuPkd8UEi6l2KlgDVvNM9VvLSGyCg
	/WdWkoyutlnx0MPpzX0qbATa/gVUL0ZGqTUvtseLWUE/1F1s0lW0KmaIJcd556KD
	RhNhFzg2cwPeAOn+nXyvXRSL/gL2LRzNEjzGJzYG6jfCqJHtBaBLNLE1TH5HMYCJ
	MgF2saYpSUA5sA8SckFTP7k0/3NkIrEjiW90ROhl6xZUzfUsUuICaR0P1JaSSTBZ
	ue5bBxq4Y4GPFwjeVbe6peQ9i9AFa3BhUP+/SESjbfMRchm5mUOz3QGWTQbXIVCH
	KvE1llCL8NJbgZIJmfL6RQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqgrt82y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 14:00:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 651DxmKk022622;
	Mon, 1 Jun 2026 14:00:44 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012018.outbound.protection.outlook.com [52.101.43.18])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbbw6ry-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 14:00:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IP4pYLSdonSes4MjBLHHvD+eEcYBaP28zEf+aRd+LTX988zO3cZ38GA3tHq+74bzi9pla8mt0a/VJZdQPW1Y5eNOq9TpzqGJQRqVh3o4piBC4s5H74+cP417+evSCMO2XgtJASRTw0syRqjencB2E2HgiWpujJMfwCoX9+xx5nqJ47QCqssk2yUwRU3xmL2PMwuWz86ze+t37MOskE99aGHc3GZxGIcTdp7VvrjYfU8ttlfm5RRImW1tFO8Xn6OGammlQmD93pZn6wR4SANTVDtJ+F/mhjHNdziAzFWKnjGUPM1b8OQR6p0rdnxKVcvXCYxM4dDuUbB08IuC3RpdHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFdm+Rauyld7yvjUHOVsyO3NMbXR99PEBrr8eNCZozI=;
 b=HF1O01l2752mr/iyVgnU7G2lnm8NNJoVl/3p7jfuxBRCdJIrH8HfW+q03an6ULDWOrnitJnIPM4j4HILueE0wCWxC0ZG21OnPcjMF1PA8jRLmfhpstsajw1TPLhQpRIyblgDcpYS79fNztFKakHxT0qnKFAEXtytrcPeoWAahpru/F/CwB+Q87wEplcBXHS1XdU/5a6ciszDOPlNL8PN5l9+gL8QLK2yPPTlOyHOB/Y+0f1LdtJ5vo7l6yCWIpVa5cLw1mVbOxYMo959Yrae0JjcDRDRXVw7drswxq37rFqevmR6KSpHgqW+NIweGKjAv6R4X5slA/CY44R781xB4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFdm+Rauyld7yvjUHOVsyO3NMbXR99PEBrr8eNCZozI=;
 b=QX5ZoxzyRyBdqir4mNHuL4kZj1PUqpt0GaTrNPJjgOZpzKR+3XlxqCp2INDDKCT1MF28yFPoqx4cicPPKn2lNJ3/FXg9Kr0QgNreXNMMUGnhmw58pk2iSYsnd6PkVPv8J4kKXOLO6u0EtFZdm0vobnTco2LA3zaUvr7MnmXDQWY=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN7PR10MB6618.namprd10.prod.outlook.com (2603:10b6:806:2ad::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 14:00:34 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0071.011; Mon, 1 Jun 2026
 14:00:34 +0000
Message-ID: <c6fe43ca-a707-44a9-a98b-5a687588454c@oracle.com>
Date: Mon, 1 Jun 2026 19:30:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 041/272] i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT
 handling in DMA dequeue
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Frank Li <Frank.Li@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jianqiang kang <jianqkang@sina.cn>, Sasha Levin <sashal@kernel.org>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194630.531977894@linuxfoundation.org>
 <fad22bda-4493-4f92-a5f3-e8b802277e0f@oracle.com>
Content-Language: en-US
In-Reply-To: <fad22bda-4493-4f92-a5f3-e8b802277e0f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0687.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::13) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN7PR10MB6618:EE_
X-MS-Office365-Filtering-Correlation-Id: 88affda2-873d-46f9-e13a-08debfe6269c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|4143699003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	VdrBqsmm8suq6p+lt6QUbEqzZrnD0E9pGDLhT13SPMDCrwi6SC/t3G62QBmTcF8K1i4pPQBvnZQc+sPS/CYbcmk41I3xgZMac4QRa33GOfB4qRPnjwCWFuPt7Nlu0OQDIz/ulaPxEHwVBFZwGYVYk27gXBcRPcoZpnJogLKfBk7A/uVe7kY8aSfMP3BzTXjFesuSKbnUu0LwekDjqT96c2lknD6+amqp6BMWexHHzXwTITMbUjWjSeU09QAKjpMGEFgTxB3q/bPeBI/UbCRQxnT7WOGNLQks1Xqz2iEsRIxELCdpjot3wbsgN3UxfkHHKZCfNUyjVVT+rpHf1ZEsQHFcShpaAFRg7cW+zaehDvA52u2Q456f4whhfkgdczDf+98BobHS27ORcCqnRNq9H3eGNNCIek7FtjAze1DAG/mJq13Ga5EP4iPFU4n6UNOALpZRNCMUPTGcDySBL5bR98Xmmt6YPIM8tIZkDhCVV6+I0fDOO8iVa0YExmRHH/sIHx/3zIHAGNcosCH2x07ZOvx6/4SzNJjy4/4kUd70ds6PRvQ/WR3mFOuh6c1evhidbK5pUV1wr3MlceJAHbW+jeAguSJ4GRmrnsjexoX3yWY3Gbd+LU+qsjTAtlY01xWealLBh4JZzQ83BlY4lStFvQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(4143699003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDByVFVDUHFGTUtNcE1QZDVMWnY0ZDNvclZtTkxHeDNWclRzb0NZZkNRZDBL?=
 =?utf-8?B?ZEtzWDY0bjBJdkRFQXdNVTM4dTB3Mmc0Y0NCbFpBZWVmMW1ZSXpuZDEraDRB?=
 =?utf-8?B?WVBBNGpiVGpTVkN1eGZ4TjBxVk5PRWMrS2IzWW9iS3I2QU1aNjBPcEp5Wi9p?=
 =?utf-8?B?ajMxOTgrQlNNMUNlZGFjUW9FdHJNQ1lSNmRMOVhEcnJ0MzJzRmlveDdpYllF?=
 =?utf-8?B?eXRvSnVpaTVyKzJjWUx5Q3NWUk9GVUtpYkM0ZHNLbjRaZkp2RHlhTkVvUnNu?=
 =?utf-8?B?N2hCUFJmME10Q0RQNUN4TDRrK0NYWjVydUVqUzBPMkN4TE1JZmJmaGErclFx?=
 =?utf-8?B?Q0lOVTJ5bzh1UEZQNUhiQXQrOUJqWmk1MWxNb1BwdXl4L1MyY3RZT2NJQzlE?=
 =?utf-8?B?dW5neHIwMzVva1lER1hxei85K2FDRk9ZYVJMVStNN0g5NjRVN0xKNXUwMDlB?=
 =?utf-8?B?VXpTRGN3eE8rZHU3VDBJTU1pcG1nR2dlZ1dRSXRvNFdRcWxlekhienk0bjJp?=
 =?utf-8?B?dFEzdFUvWE54WlR4YnFTMkFyWGNGZGxJSG15TE9HWEFQaFlQNVA5SlRzRHF3?=
 =?utf-8?B?bzdWVGdhdE5sMVZjZWh6WVhpWnpsbWlvditkZnBoN2E1eXhIcjlKanFPaVRD?=
 =?utf-8?B?SnUvQ3BpLzl4aFVTc2RuSnlvTnF4cEFXTGxGb1Y3NHhtbkFCa2xEVC9LcmZT?=
 =?utf-8?B?QmJtRGFKdlRTcURCWm5YYm9TVjZBejluakdPa1cxMm5uUkxUQjhEV1VOQ0dh?=
 =?utf-8?B?VmxreFp5cU12NWpkb3NqdzVlNEZUdFVWWXBtM3N3VzRraDZiL1lWck1BVVhB?=
 =?utf-8?B?K1lyN21wSU90UGd5SEthYU5zRHg4L1JiTTZTaGZqUkVJM2d3eldDYmNVNzhs?=
 =?utf-8?B?VW1seVhKcXNJVGoxSnBWTER6REZiTlM1aFA2ZFlvcE1WWVA2UStkVHcwY0dv?=
 =?utf-8?B?bUIyeUNET3RITEZJMXhzTjN4UlRrQk55bjYzZ25FeGRHNTg4SFRXUHlVcWd4?=
 =?utf-8?B?TmhRY3VRUTkwMTZ0TXdIVG8vWWt2V1JmTkd3Mnd6KzFrYmtwMjNOTUxQSWRq?=
 =?utf-8?B?V1VlTGpmbmhRZSt1VDJhMk9TdDdxRWE5UnFJSURiSk9PNWw3TjFUNitOT1gw?=
 =?utf-8?B?ajh0US9Rc284U2YyU0ZwZEdPaFJ3STVmY1JIb3Y4NGpseW40czdKenNERjBz?=
 =?utf-8?B?TWh0a1NKNkdvQTdob1dMbVh0RC91cGdMNzkvVmVXdjdMR0djY3V3aVpLMGNs?=
 =?utf-8?B?K0k3cWIrTWdVaEVuaUlLTktEek1kbUZvei81dlpiL2d6RitEQ3BFaVNnbEwx?=
 =?utf-8?B?QWExdlJvRDl5MWV4TnVZSTZEQ3l1TTRFRUlCZWh2cE10dHRsOEtxYklwODlJ?=
 =?utf-8?B?TzNVMHhjdEFVR01FcWJEb3B3OUJRRXZQMng5ekw1RTJNWnB6RkFnOGtORUxH?=
 =?utf-8?B?SlBMcnhHZnhJYjE3eFNNaFBVcFpHeThySWM3bFFnRGtzNmpCYVl2KzlNZm0v?=
 =?utf-8?B?VHA3RFl6U2dEQmRVblpKTXQvaFdTODV2cXhZcXFRQmVBbkppVFdiQU5qdXZG?=
 =?utf-8?B?OEJqRWN4RWJpUUNkZ256Rm9oUmxjVkRnbk9sZTdnVHdyTzhxR0VWYW9ubTZm?=
 =?utf-8?B?UTkzcmZMNzIzMitwNWpkZTdCNkxPU25ZZVZEdmVkdzE0K0ZuS0pPVHRsVE1V?=
 =?utf-8?B?QW4wdlYwKzJJN0NjWHV6ZFZGM0ZaVkVrNFBHZDFQMFpSemIzKzl4S3Q2SnZJ?=
 =?utf-8?B?V1gvdzVpZkRxbHFGMnB3dTBqTDhjNzYxK0NpNndSMFhlWitLZmNYY3pKQU1B?=
 =?utf-8?B?cHQ3WkdRa2pHVCt5NkYvT040amwxQ1hiVkpOdGV0ZkNtTm8vRmo1dTlJNmla?=
 =?utf-8?B?a0tFMFRoRTgraDA0MVhoV0t0Qzh1ZE1pS3V2cis3dDRsZ0o2eWkrelVpYnp3?=
 =?utf-8?B?RzBTb1lxMHFvbTZ1RFR6VDg4K25UOFlpUm1ueG1raTdzVGZ3a0JZdVQ3N2RB?=
 =?utf-8?B?UVBsbUFFRWFMSUMwU0xiSUVUTGNuSWo0aFAvc0lkZXFSajgwcFJ6SlIvN0ho?=
 =?utf-8?B?UXV4NkczMUNGd0hocDlqL1FOOGZwaGkrcW4zcGNGeGRoQ3FWVW4yeWZXckRq?=
 =?utf-8?B?Z2RKOTFMSWsyaEFUK1JCSmp3bmx5VktQZXhvSVd5cENUZjVxWmtoQlRWbC9S?=
 =?utf-8?B?bFFFMzAzNmw5UGxFQVE0MUNUd2VYU21Jdm84MTh5aWZybVRzdloyZnVKbHJU?=
 =?utf-8?B?T1l3VzJPb0U5WU5uK3lDRnVvMzMwSE9zcUZFV3hjeHRjcVArYW9JczRBNVov?=
 =?utf-8?B?cFZqY3lxeUdoTXZKWWl1UFVuTTlPRituWEQ4MVd3Um5mczNDSklBZm5KVlla?=
 =?utf-8?Q?3wsig1s4ufHPRLbL2sWN+rWjbTQdx0ZhGpgmU?=
X-Exchange-RoutingPolicyChecked:
	hjrtyrKskGFtk8wDOiGP6c/zbE6Nr3jR7ZnKG3FMSMmbfpx1zlkyOZnjj6ptWXD5F5oBdljHkbn6K3FFzyXl6Y0ccO0XbBEJzNcL3acr8Cy8iRSfa1wv+lCoKkPsBnSCVJrP0PLCtvc7OJ0meq5qugefCT8GfvbbUcnZUaciY8HHjRhvSPjsAbnKlqwIpDXGqnASGHCR4bXkEOPDI8pIbwJa+ZynvNM28+wOQ2rCG04vx+p2QEi0mb5B9rDO6EiHe8eIVim3M3zBd5d6aG6ldKS9aCO0WFjb45WDGLj/fcz2IUyqselThfNqe9JwV6h3gogtUz6EvFSRfIPbXP2sAQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IhubL+FZntH0zmPLGPuEaU+8XHRM/EsXL4eIAF9iiLPewdRjUYtKWrUDgds78kwfjT9h22Z1ejK3SqQSct+dCEqmBLZlJl69b2id3kVmcoVfDP01oDrE6OR44XcSwyizsKxR0nYw18M6nwuu2SQ3e/+qBaMsO575m1R2JSRZcjlNhwDxvTW3Bh3IPtj4eBmwsqSmAz2ScRf0fuHpgYkt7hXaSSgBQ5tmMJqh1hkTkztN/X27lVyhsZoaKEzV4woXZS24PL+QG8dJVsg4z/Ov8qanIo/pouFBq824Ns3y81TwpTi4pcFBa0gz+yG2Kbjpw6zznLa0oCcvdBboVOgtaRTd0A+IiF2NprfmoYkD3KOf9Ido1qdFpcDiwfcf3mDH15HM+Y2eujBBAcWbSMBcZh4SzXulyqwmy4RCU6PT4o7gchKgw45Bev7+rZQ3B00c6E2QzksfDXAp7mg2J0oaiajW5q6z+sDJ+L9M12E2w0XEtSA0+FfStPqMRVPOU++I381xPJ+Otktq4ZuwDcMq6VxzfD6/ghzBLBp6J+2uInNiSF6ILMToDgqy8fc+N1dNDnCorFpujleHT9aZya8C79sjhg9AYWml1oc6COMYWuM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88affda2-873d-46f9-e13a-08debfe6269c
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 14:00:34.5862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BEBJz51LCQyX751pJkCUZVTCdAVNYY3J2O8FUpt1RQQmah6HPfuqZdl6vYw8GPm2q21csasviycfBWakeS0iikyPTkCUB/wqc3sbukVtdfKTVdO1w8uoV6DmSkmFyy20
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606010140
X-Authority-Analysis: v=2.4 cv=NLnlPU6g c=1 sm=1 tr=0 ts=6a1d908d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=8AirrxEcAAAA:8 a=P-IC7800AAAA:8
 a=KIumSKolJZfcbhfNofIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=ST-jHhOKWsTCqRlWije3:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-GUID: rPYeUToqMzSgJhn_-pfMXsv4-6pG1x6s
X-Proofpoint-ORIG-GUID: rPYeUToqMzSgJhn_-pfMXsv4-6pG1x6s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDE0MCBTYWx0ZWRfX9xwkX6CDXsjZ
 MVRa5kuUtaTR/wJ062Ucy0cUJKtMfuoB0QOWQTQDbCR9FWGmhbXZp101b5l+f19fPrzQfnwq4pH
 V4kGeEtFhficwXZKa1GPMaqxzxriLwtLgph3u50LhFQevS7JklHTYKEXmyIUOZrhUjJCtSnlt1D
 m82mWHL2LbsMgAM6mGvwvgASchG32ZgU1otkLrOHz9Ux7wg6sOy8OcOR+we06EBExfL4qYBiD1L
 yuaAyDb8VB3Uk8Ng1QH8gZ7Lp8M03bjvFtvPual6jxb8gnesQ2zyKJ4GSw0qjyuLUGvUrMtCtLp
 4fJPsYowo+OQ2djL92MDL9XzhVJV3drbtILdDZ6D0ftKNQKLH++H/Mc4JUPufCc2smRJJourJJl
 JK1bRJyF2i49T3dDo+hybG5BOLEbxv3uZNHGqOcg/dpp9tqYBYNqPMMQMGy68rBUN3TfboJDc3J
 jJn7Hv4yJpYXt38fJJQ==

On 01/06/26 19:27, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> On 29/05/26 01:16, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Adrian Hunter <adrian.hunter@intel.com>
>>
>> [ Upstream commit b795e68bf3073d67bebbb5a44d93f49efc5b8cc7 ]
>>
>> The logic used to abort the DMA ring contains several flaws:
>>
>>   1. The driver unconditionally issues a ring abort even when the ring 
>> has
>>      already stopped.
>>   2. The completion used to wait for abort completion is never
>>      re-initialized, resulting in incorrect wait behavior.
>>   3. The abort sequence unintentionally clears RING_CTRL_ENABLE, which
>>      resets hardware ring pointers and disrupts the controller state.
>>   4. If the ring is already stopped, the abort operation should be
>>      considered successful without attempting further action.
>>
>> Fix the abort handling by checking whether the ring is running before
>> issuing an abort, re-initializing the completion when needed, ensuring 
>> that
>> RING_CTRL_ENABLE remains asserted during abort, and treating an already
>> stopped ring as a successful condition.
>>
>> Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> Reviewed-by: Frank Li <Frank.Li@nxp.com>
>> Link: https://patch.msgid.link/20260306072451.11131-9- 
>> adrian.hunter@intel.com
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
>> Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/i3c/master/mipi-i3c-hci/dma.c | 27 +++++++++++++++++----------
>>   1 file changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/ 
>> master/mipi-i3c-hci/dma.c
>> index b9496e8c4784d..44461f13b54cd 100644
>> --- a/drivers/i3c/master/mipi-i3c-hci/dma.c
>> +++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
>> @@ -457,16 +457,23 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci 
>> *hci,
>>       struct hci_rh_data *rh = &rings->headers[xfer_list[0].ring_number];
>>       unsigned int i;
>>       bool did_unqueue = false;
>> -
>> -    /* stop the ring */
>> -    rh_reg_write(RING_CONTROL, RING_CTRL_ABORT);
>> -    if (wait_for_completion_timeout(&rh->op_done, HZ) == 0) {
>> -        /*
>> -         * We're deep in it if ever this condition is ever met.
>> -         * Hardware might still be writing to memory, etc.
>> -         */
>> -        dev_crit(&hci->master.dev, "unable to abort the ring\n");
>> -        WARN_ON(1);
>> +    u32 ring_status;
>> +
>> +    ring_status = rh_reg_read(RING_STATUS);
>> +    if (ring_status & RING_STATUS_RUNNING) {
>> +        /* stop the ring */
>> +        reinit_completion(&rh->op_done);
>> +        rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
>> +        wait_for_completion_timeout(&rh->op_done, HZ);
>> +        ring_status = rh_reg_read(RING_STATUS);
>> +        if (ring_status & RING_STATUS_RUNNING) {
>> +            /*
>> +             * We're deep in it if ever this condition is ever met.
>> +             * Hardware might still be writing to memory, etc.
>> +             */
>> +            dev_crit(&hci->master.dev, "unable to abort the ring\n");
>> +            WARN_ON(1);
>> +        }
> 
> 
> I ran an AI-assisted backport review and checked the 6.12.y tree.
> 
> The posted backport adds the RING_CTRL_ABORT completion handling, 
> including:
> 
>      reinit_completion(&rh->op_done);
>      rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
>      wait_for_completion_timeout(&rh->op_done, HZ);
> 
> In upstream b795e68bf307, that path runs under hci->control_mutex, and 
> the ring bookkeeping is also serialized with hci->lock.
> 
> @@ -546,18 +546,25 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
>          struct hci_rh_data *rh = &rings- 
>  >headers[xfer_list[0].ring_number];
>          unsigned int i;
>          bool did_unqueue = false;
> +       u32 ring_status;
> 
>          guard(mutex)(&hci->control_mutex);
> 
> -       /* stop the ring */
> -       rh_reg_write(RING_CONTROL, RING_CTRL_ABORT);
> -       if (wait_for_completion_timeout(&rh->op_done, HZ) == 0) {
> -               /*
> -                * We're deep in it if ever this condition is ever met.
> -                * Hardware might still be writing to memory, etc.
> -                */
> -               dev_crit(&hci->master.dev, "unable to abort the ring\n");
> -               WARN_ON(1);
> +       ring_status = rh_reg_read(RING_STATUS);
> +       if (ring_status & RING_STATUS_RUNNING) {
> +               /* stop the ring */
> +               reinit_completion(&rh->op_done);
> +               rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | 
> RING_CTRL_ABORT);
> +               wait_for_completion_timeout(&rh->op_done, HZ);
> +               ring_status = rh_reg_read(RING_STATUS);
> +               if (ring_status & RING_STATUS_RUNNING) {
> +                       /*
> +                        * We're deep in it if ever this condition is 
> ever met.
> +                        * Hardware might still be writing to memory, etc.
> +                        */
> +                       dev_crit(&hci->master.dev, "unable to abort the 
> ring\n");
> +                       WARN_ON(1);
> +               }
>          }
> 
>          spin_lock_irq(&hci->lock);
> 
> 
> 
> 
> Downstream 6.12.y has the new reinit_completion() path, but it still 
> lacks the MIPI I3C HCI control_mutex and the IRQ/dequeue ring-state 
> locking.
> 
> So the backport can reinitialize and wait on the shared ring completion 
> while another timeout/dequeue or IRQ completion path is still touching 
> the same transfer state. Thoughts ?
> 
> Maybe we should drop this for now and queue it up with its prerequisites 
> together ?

Forgot to metnion,  the prerequisites are 1dca8aee80ee ("i3c: 
mipi-i3c-hci: Fix race in DMA ring dequeue") and f0b5159637ca ("i3c: 
mipi-i3c-hci: Fix race between DMA ring dequeue and interrupt handler")


thanks,
Harshit


> 
> 
> thanks,
> Harshit
> 
> 
> 
> 
>>       }
>>       for (i = 0; i < n; i++) {
> 

