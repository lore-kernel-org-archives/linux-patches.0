Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B044528850B
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758620903; cv=fail; b=EJS0V3JNyZ96EGknjVqPDioitloKlO4CHwq8TJwcZZNZcrIxBHVlT94GW4OrMXVsxxJzAPKKJ00Yx1gsCRkhAzONe4Bl7OuNcZ3UUqKOaXl1GhFQlfI5M6mv54rvVrY1P1m5vmpFpexvI7VgvrIZXC+HiHoSPG2lQmrDvNdCPKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758620903; c=relaxed/simple;
	bh=rE7ddty5Moi4KHTfKr4FJ+bW0CTdLKZ1ZJ/BsyI0jLM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qXV3RjiWxBGMLS+jES4rHPbgaDuzKQu9rOwvoV/b6CSwmgVXZtAUw/XDma/uvai9i15U1O19Zv3Hd0Pk6tK2oZcsTP7FHDSNXis+G1/Ac/ao0WLK2n3i2Olgb3S6/WUqyK0DS0FrQ1GVzUUbkbjP8LcJi0vySLBgFaPoyKKwZoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iwc/pD68; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EDAh9JV6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iwc/pD68";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EDAh9JV6"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58N7u9CS023252;
	Tue, 23 Sep 2025 09:47:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ts9+8Ij6hQL460LX16AnzJX7woU4xK22qv95rOeH9Rs=; b=
	iwc/pD684fFLGrJ6RVNqeqKlxWLGIv5Nyy8rp+CfZu+tEuJssCvjVciHNMYmGDsU
	MfyfHJq6TiT7jE2yx3aNrkcKSzEkbbvQzm3pWPOxmCdhyBKJcaf+lhGuMcj1+qyE
	v4NFuo5SJUBew4rN6Lye70p5Fpi5klDu+WxyXgTu5t7XO1O6H4lVEOJz72WSHZtV
	/4Tz3VQM7ylwuuDDDw41jbXync+fZhMXe+9FLb0P6Y7d2+1M/s/K1mZXs4MUkO68
	5Y1xorLXRoFg8cHI1gtxoZu+e6FdEziSUttI6oUhNG5Wj8+y6Gbdza1B/jFrRfhp
	2O5kbvoIdoXRWrCiEJCC+g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499mtt483u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 09:47:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58N7e8ST013650;
	Tue, 23 Sep 2025 09:47:47 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jq8050p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 09:47:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KJW74hBPh6c3c/z0+/BkXlbkRxneXHunZPMz1i1UTk/ySuHK3R6M8zBpWR3ec5ILI7jQDGnO8pSlHyjlrb/Ozb0k7X8qtrkfoBln3QeeBi6rR/yLRdmOk13SBrBNRNA4sMQtjVThVwB6QH+LqL+RJ9J4SYLNC2jQzPUB1HRf8mXp76vVPbwY/Z894n5MijDM8fskByJd8kbIDC/SgtA7RnY1/xcpX1/0Cjhk86AF2eMwdmY3q1Ya9LM+RCEA2lwFbeqVBEANiQ1m7mxApIMG2ykM+rjuOLIWmOLCib6+BRhSRToa1xrmyOqIEZMrQsVCbpPR8D1vLY5Xo9zT0th2mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ts9+8Ij6hQL460LX16AnzJX7woU4xK22qv95rOeH9Rs=;
 b=Qw/J+t6kYsVqRKcqGcNjwHaNYr+8sswFmO6cOzGBhf6W8LXeP/s8/53KJwhWnLnhIP/eUTmWHK78uhOJe1nQH5+Sk/blOOVkyk0WAL8LL/0gayHp0Mo0IhP69m86iQyE8J4vVxU2i/oDANpx6eBOVDkdXRgqIgfqHSHt7QMJvnX1oQzjOSbw4j3VUCX7fe7w+9Ql4aKpvuAt5qsoFY/AZp+iz1X1XiKMsg44w4WZFgUiI8pjO/TSpAcOxsj3d3cUK5/hx7WS9BkImebXLdoWp9QCgPr47B387CVk1arYKPkGVybGM3qSygQsILIMxH9hoT4dyUdjtQnGX9Yhs/FunA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ts9+8Ij6hQL460LX16AnzJX7woU4xK22qv95rOeH9Rs=;
 b=EDAh9JV6D3CNaIn1AvwAKaSb7Gpi65C57IWxAVOf3IhJmLDoL9vFWCZjIZ1I8Cf7rqFZ/kTAARObF8qjO4ExMEXTUatQzFThvdVsM+XDDGskgdI2WbPlW7ETQZylLngpSM1rtxA94E72uhKoiKiiNRdj0niF7/A+PHqox1LSCiM=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by BN0PR10MB4854.namprd10.prod.outlook.com (2603:10b6:408:123::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 09:47:45 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9094.021; Tue, 23 Sep 2025
 09:47:45 +0000
Message-ID: <ee415163-0cf1-4b64-a3fc-82ed2073cf60@oracle.com>
Date: Tue, 23 Sep 2025 15:17:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/105] 6.12.49-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250922192408.913556629@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::22) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|BN0PR10MB4854:EE_
X-MS-Office365-Filtering-Correlation-Id: 00075193-a616-4465-d957-08ddfa863f06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzNZZFNvU0hGck1xZkFXY0Q5c1ZrZVZHK0x3WUxlU3RzSktsWmxIQS9FT0pi?=
 =?utf-8?B?dVNMb09lQkRhd2dsb1dxamJQOTc3cnFPT1ZmQ2h3N0pZZzF6Rld5angzaUtM?=
 =?utf-8?B?UTFycHZQY3BTWWpiRFJzdDhNaGR0cmplZjRaMUdGdVVKWGhZSWMxZ0RicTJY?=
 =?utf-8?B?VU9hY1VvUEdvWDF5Y09GZDJjWEdIY2hVRThKM2F3L1FBdzdaQWhGVFliMlB5?=
 =?utf-8?B?SEttcmljeHJSb3pDNjZFbFp1WXo4clpVRXd6RmNubWFNWXVuaHNaaTlpUEor?=
 =?utf-8?B?U01VQWZEN0M5M3dZM1h5TzlncUxNdnJXNktRUW9GeWRFNDFvSWpjUm9CUjFM?=
 =?utf-8?B?VWNEdGs4dHdXelh2Q04yUTg1bDduZnJRQXJxY3B5WlU3YUxGMDNpNERhSnQw?=
 =?utf-8?B?aHNOTkZWdnlBZFFteUpTVktNeE5DN0VBZWhHUVBzeWdkR2FRbXlldmhQUnZ2?=
 =?utf-8?B?cjNBbHk2Q1lBM0s1S3dGbjJBUlV1a0N6VTd0UUJtNjN0VmF6bTNKWG1qOGpY?=
 =?utf-8?B?cExmdEE5K1VKSzhkdmhKREh4am9hOFowaFNCRjlXK0pObXdqZWlQYWVianFh?=
 =?utf-8?B?b1h6Umk1N1dramFLWDlWMUdOa3FvZVNNQnAyVCtMS0ZOYk1nMHhMZWZOMjdD?=
 =?utf-8?B?U1RScytjQnVKbFpVV3N3S0V0V3FrZERyZVJUWUNCUUF0ZmFuYmlSL052YXN0?=
 =?utf-8?B?dGlRSmVhMHVaYjF4ZFJVcUFOd1J6MDEzNFFqSUZsR2dEZVhEWkhMcERtZzhL?=
 =?utf-8?B?MUtaRjY1azdhb1hrV2pDNVc4K2V6OWZwWUlMaFM0S3gxM1R6SjYzbGdjdGxh?=
 =?utf-8?B?N1V5bUExTlIyMFJ5aGJvTjIzbytrVXdWa0E1WDhlaTFhOTYxM2VSM0VIdWVO?=
 =?utf-8?B?Mkd0SjliMm5GSGJuYUhwSWFqWFAyVUZZZldibTlPVXEwV1R3VTBHaitOUUxn?=
 =?utf-8?B?SG1yQnEwNVIxRjdWbHdCWGtEdGl1MWpmYXZXUWwvN0VmUmtsOTJ4T2Zvcm1j?=
 =?utf-8?B?ajR3MGdMQ0lnb1Q5ZXBkclJQRm5makZsK3R0SzBYbUFTUVErMVVERTdTa2Rp?=
 =?utf-8?B?Q0ljeGp4bm1VeE1neEtabmxHSDVQRWhSajNmdktYRzY3VkgxUkNpc0xuVktX?=
 =?utf-8?B?OXF1VGwyYTNSMWN4bW5iSnJBN09zazNOa0RjMUhmcEVxMW00Z01Sa3lzSjk4?=
 =?utf-8?B?Ym1lbURzeTBNRG9LSWp3bCt5RXBHTGxMMDBwMCsrenFxYjVHdFd3OFNGb29E?=
 =?utf-8?B?K1d1VmJPZVgwVWs5OENKUjZBaEx4QnphRnZVeDh5OTZDdWNQMk5MVlovTVpy?=
 =?utf-8?B?UUZLRVcrQktWOFB5UmtxMlpkUU9BZ0dGU2ZWOTIxSnZyREFGRWVSRVJVOWZq?=
 =?utf-8?B?S1IyeFUxS1BPL0prbi9pbW1pcWpXS091dXBKY0dZaDNQdTZBQnFXQWxxdzJl?=
 =?utf-8?B?eU5lYklCWHRPMVNHU2t3ZVNhMFZ1bzhGSnBBVlZaZHBXWFcyMTJWZ1lSb09T?=
 =?utf-8?B?enY5aUxhWU1USDRSVHN1Uzl5QlBCZE1GZzVvdW5QTXU4STRqaUhBTnZ4ak9h?=
 =?utf-8?B?eDZsUVUzMkQ4OGNrbyt6bTRpTzVma3B0ZG04VjN0SCtnczRyMnpuek1tc1BU?=
 =?utf-8?B?dVFMQUJJb3NtZWdlMVd3ZkMyNWNFcTE1SWVUalJCdjZ0NnRwMFFXZEZXWVcy?=
 =?utf-8?B?eEFEaUtheW5aSlh0VHpjTkRkbHFkWlhJVWI4cVpHWmJRY0ZIVWtOL3VJSmw4?=
 =?utf-8?B?U3FKeHhiZWREQU0xUzNQSVJrMzI4LzVTQUhkVmlRT0lkaElNYUt2cC82dW5y?=
 =?utf-8?B?dXI5LzVjVUdCNVpQUXFsekp6RnNpS0kzUEFrK3EyRDR6bkZZT081d05QaEZI?=
 =?utf-8?B?WFI3cTNnOUUrUnJrU3Z3L1NDaGJXa29kcHFVY0xocFkxZEs5ekpsbUloak5I?=
 =?utf-8?Q?QMuCHo1gkO0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXF3WWlxRXBMazVHTEd5bU82R2NETkVuZ0lYR0RxNWlQU3VHSDNmRHd5M29U?=
 =?utf-8?B?cUtzRUNtbzR3NkpIclZiWEV3K2lPUFB6YVpnWkwvcy9mSms2a3Q2SXBGcWtu?=
 =?utf-8?B?VmVDbDhoSEpUSCs3dFlrVXk0S3A0dUxhRHR1M2t0eEE4ZUwxSkVpb0VHWU1Q?=
 =?utf-8?B?ZVRZZW9FemxNdmd2YUVWV1FWWEhCN25pcW9WdXZhNjhneUwwZENGclVQMjV6?=
 =?utf-8?B?WFdVZkY5RlJhYllBYW02Z1FXT0dOK1prOXFLY254czE0OVExSk4vTDJUWnpO?=
 =?utf-8?B?andrdFFweHd2clA4bXFHTDM5dG5TaHNQTmNQbkNmVlRCZEdtck9zV2tJU1R6?=
 =?utf-8?B?VWNSV01HTnZEQ1hPUUN2YnpnTFhkNW0wd2NKUUIyTTdlemVTTDVFLzdLYVdN?=
 =?utf-8?B?RVZqbS9jZUVSTTQvMTU5NU5aRVE5bHg0UWRhNzlnU3NtSFlqM0dUUHpHdlpL?=
 =?utf-8?B?cVBGditwamhiYUNwNTU1UENpLzlvSlBkOTFXN2Y2Rm9MM1M4SWZWRzViME9I?=
 =?utf-8?B?L0l4OUNXd0luNThWS2NKdWxIcTZiRllUNGovVGw1Vk9ZOGpwQlRrc1VJNUVT?=
 =?utf-8?B?VXpza3RNZHF1eWlOQzNLbnJNSytmNGhJenpyd1g3YTE0Z2g5Wlh6TXlsS3hX?=
 =?utf-8?B?YVloOFI4ME9wbVBQR2lrSmRybDg3TStLMzFSd3Bhd0YxQ0hXdDdNVDBzNmww?=
 =?utf-8?B?UlR2WmcyVm5vallLTXVqUXFxbzRkTEUzRXpHQUhSOWZaWmVtOHVkNmFKS3p4?=
 =?utf-8?B?Nm1hZ1hGamhYcjBEL083di9rVkJFaUdVbnNQMGJMZE5GLzJxQk4rcmFTNU9y?=
 =?utf-8?B?MVlCMEN5N2ZaNG54VS9iVjNNN3JMcjRrZEJRNnlZVkRCdmsyY2M0MklhdER1?=
 =?utf-8?B?ZE40ZGdpbWJHT0xyaDFTRlplNHRIV083K09LcUxVVm9NUitqalE1ckl1STJa?=
 =?utf-8?B?ajd6cnQrellqYXZDRVlackxwdmJZU2ozSVFnREZMM2hvVlF0OGhiM01YY3ZV?=
 =?utf-8?B?N3hWeWtCNTZhY1BCL1F6djJ2d3YvWUNXRzVPa3VrQ2xNMnNzUGlvN3JZazVq?=
 =?utf-8?B?OHZjaVVZTnArNnBIdmlnK0Q3cXhRc0ptd2dGeEpaZ1B6Wld4Z3BTNTZvdlZE?=
 =?utf-8?B?QTY2TmhadXMxVGloYTN6aXFzRVZXRXlYaUNxNURaTDRtTWd3SEpXVHdjYmhy?=
 =?utf-8?B?V1QyYlkyTHVoMTE2NnlSZk12T28xYzdTcGVRMkdsaDV0bXVjQzI5R2c5andP?=
 =?utf-8?B?QjBkeVRWTnNtZEs1aURadTEyZmRPQlMwcm54WFd2Y0xHUWRDa3dQVzRVMTdM?=
 =?utf-8?B?ODFSSElvSzlJNHNlNHRjSTVOU1ZWaGhMQ1hCVDJ5RFhYZmRWcFUyaWhaVmVj?=
 =?utf-8?B?eEJQNUtic3VyNUFyQlcvalVxYllOZU5xdysxUnN2U1JtWDJncWN2NlRnRmlw?=
 =?utf-8?B?ME1rNHEzMmlKbnhrMGxVNEk4TWRHVGFWSkw4YXdlTnNKMmdaMVZxRjdXVzNT?=
 =?utf-8?B?dGp6aWhWMTdhMk0vZVdsamdqcmVYQnJYQ1ppSTcrWmdhRTA3ZTRiUU5RK0p1?=
 =?utf-8?B?U2QrakVCbk8rTE5rYkJwMG1jS3NvRExHdEYzL0JhMVpVcHNqSHpjTGE3S1Vj?=
 =?utf-8?B?WFpESWVZTHpyczNEdlpqaVRLNzUvM1h5eCtrb0RhQjlkMmRIdEpzdlova21k?=
 =?utf-8?B?WXNTZkdaQkQzSEF0SjlCanZVdkhqNnJ6TnlhNWJ3V1BYYzlZbjEvUDBka3Qz?=
 =?utf-8?B?dkk4bW1LNzhJK0NGNE5oNnFDa1FCUDdIVWdWS1RCZEo4NDVLQmUxNWswV0ox?=
 =?utf-8?B?aW94bVVGWVNFYXY1dk13dHNWZWNGaFBGVjdIdmt3c2dVd2l1VnpKdUNrQi9x?=
 =?utf-8?B?MnVTYTFqYmtZbHFYZVMycmNQWjE2OVdkaDNSYVFpanhQc0ZXR1BnbnA4NnNF?=
 =?utf-8?B?YXdYbWprMmRJTG5BaFAxMXAxY2lHU3lxK1NUU3g1aXhDdU51alJyK0I0UWJF?=
 =?utf-8?B?UWNBdXg1N25uV04zaXRSR29IcWo2c3dtK0trdmk2OGliQlhzR3NhL0hsZ3ZQ?=
 =?utf-8?B?WUtoL3lsRVp4SUZOQlFvbGVFSEYvSm81RXVpc3RsRzlLaGhwajA0cS95TGVG?=
 =?utf-8?B?UEVaQ2RKdmUrNzIrb1dzRlRxZFloVDF5WTJ0dWFJQkEycFBlekpOOHpVcFdE?=
 =?utf-8?Q?irSb1Z0A0fFcHw2a82jMymI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/533YVrTkCKdYGv660aeQM/K9vvAbKlnyT/8+NNBgaGgkqpyv2K2nVPz5VpmH4qVnkfVXifmgnjaY6MrCQ6VN8/KrYNuc3UEcMqCqQoYe9F2pu1eEGfo8yZlH7fkrfVw+Xs75y2bPlcE8thHHJ+RROVhY54sAzJLfr5COgt2mOJoyNHdxkmgOlbvzbbWx19hCO8PRG8La9RNyAL5tOICmroIkW9aDvBiIgJnncUBJyxdH9AxXSUVySiD4a/vW+Vd2Vk1JxXNdNzu6Jb+NMDqAtPRk54/TQPEq57+nohyDFF6pQY/lM6KRy6g+t+oUhyT5os3Rc4B3CmIXiAJ/0J296mLRoycU8eecpcomC52x11pI+YdXc5GcV/kWcIdnZ8Nd82HOREke59hTRY0mH35I7NOULgVrazFd7AF6sBSeuBNmMk+kZyXTg4XGStmrlSAFkIawG7XcJnHZd62MKUjDZ98AkpIGW9ror211ic2BucIZNOCw1Wo3XcXN/wac6N/qTUI6uMol5pOccPKlE2ULdDQp4LIpbFoe14AYeXN0Ys8JllGiTb98cyo2CWBh+i9vI7AzjiLLU3O+mr9Ai3lgRIsUrmPLgJnTZVPZQDGhOw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00075193-a616-4465-d957-08ddfa863f06
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 09:47:44.8701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3k8YxZzdzxEIauAfrNAw9h25LiwQrL5RbKN4bH89gNiWaBAwijWGKj4sF8+vg8SbOEvfKOSueJ3SaO+vdfAU6blnhF7BiU7gXrH3xKqjsqynrQJUMTGCbqO0Dx57lcW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4854
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_02,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509230090
X-Authority-Analysis: v=2.4 cv=fd2ty1QF c=1 sm=1 tr=0 ts=68d26cc5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=UlE0iww382u4jLCPTdwA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12083
X-Proofpoint-ORIG-GUID: D42mWfiuFR2rVBaoAtwSYjnttKNG1XeE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzNCBTYWx0ZWRfXxRPsw6Q8BcWP
 w18Gagn6Lfa+JKNRd2KmVu+1nIfSha/dOFf/T853vBrsdjAxs+speI4z30/xOmqsTclINwVTDW2
 NQ7xTUGIoE/edlNdVZVKv4+q7m7dE4SU6u6wWi1EUKdH5yE/94CD64FlVQXlRgrh7LeWc3fKKoU
 RZkQrNvLydD0IKpav7mKcYVeMbdnNoJ7l9DHYcwZNgtI4lLu+OG4kWivxWFPGZDEpE53ReOlb1p
 wwzyCsbHR3LPFEWoCNJhJ6RZTaizbj+dvWaiDvzMW/NE18f0BjwYbf50wGtfHDa5zeHck/2QCvL
 iq0s0vPukbllfqd+roVBQIBx9jQN224DN5SzEeADvL1gbweH/lyFWdbPvKReZPXuRdwsCeqmUwo
 hiPaE8NeFUXEZ2iXnb00JSsMDxhQQw==
X-Proofpoint-GUID: D42mWfiuFR2rVBaoAtwSYjnttKNG1XeE

Hi Greg,

On 23/09/25 00:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.49 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
